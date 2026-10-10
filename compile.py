"""Bundle Luau modules as lazy functions, avoiding runtime recompilation."""

import argparse
import math
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import time
from urllib import parse

CLIENT_FOLDER = Path(__file__).resolve().parent / "src" / "client"
PLACEHOLDER = "C.preloadedModule = {}"
LONG_BRACKET = re.compile(r"\[(=*)\[")
# Scan ordinary code in C rather than visiting every identifier byte in Python.
# A single '[' or '-' remains ordinary code; only literal/comment openers stop.
CODE_BOUNDARY = re.compile(r"\s+|--|[\"'`]|\[(?:=*)\[")
LITERAL_BOUNDARIES = {quote: re.compile(pattern) for quote, pattern in {
    '"': r'[\\"]', "'": r"[\\']", "`": r"[\\`{]",
}.items()}
STRING_ESCAPES = {number: f"\\{number:03d}" for number in range(32)}
STRING_ESCAPES.update({127: "\\127", ord("\\"): "\\\\", ord('"'): '\\"', 10: "\\n", 13: "\\r", 9: "\\t"})


def _literal_end(source, start):
    """Skip literals intact, including nested Luau interpolated expressions."""
    match = LONG_BRACKET.match(source, start)
    if match:
        closing = "]" + match[1] + "]"
        end = source.find(closing, match.end())
        if end < 0:
            raise ValueError("Unterminated Luau long string/comment")
        return end + len(closing)
    quote = source[start]
    index = start + 1
    while index < len(source):
        boundary = LITERAL_BOUNDARIES[quote].search(source, index)
        if boundary is None:
            break
        index = boundary.start()
        char = boundary[0]
        if char == "\\":
            index += 2
        elif char == quote:
            return index + 1
        elif quote == "`" and char == "{":
            index = _interpolation_end(source, index + 1)
    raise ValueError("Unterminated Luau quoted/interpolated string")


def _interpolation_end(source, index):
    depth = 1
    while index < len(source):
        char = source[index]
        if source.startswith("--", index):
            index = _comment_end(source, index)
        elif char in "\"'`" or LONG_BRACKET.match(source, index):
            index = _literal_end(source, index)
        elif char == "{":
            depth += 1
            index += 1
        elif char == "}":
            depth -= 1
            index += 1
            if not depth:
                return index
        else:
            index += 1
    raise ValueError("Unterminated Luau interpolation")


def _comment_end(source, index):
    if LONG_BRACKET.match(source, index + 2):
        return _literal_end(source, index + 2)
    end = source.find("\n", index + 2)
    return len(source) if end < 0 else end


def compact_luau(source):
    """Remove comments and collapse whitespace without rewriting Luau tokens.

    Literal contents and interpolation expressions remain byte-for-byte intact.
    Always retain a space at removed boundaries to prevent token merging.
    """
    parts = []
    index = 0
    while index < len(source):
        boundary = CODE_BOUNDARY.search(source, index)
        if boundary is None:
            parts.append(source[index:])
            break
        start = boundary.start()
        parts.append(source[index:start])
        token = boundary[0]
        if token == "--":
            index = _comment_end(source, start)
            parts.append(" ")
        elif token.isspace():
            index = boundary.end()
            parts.append(" ")
        else:
            index = _literal_end(source, start)
            parts.append(source[start:index])
    return "".join(parts).strip()


def escape_multiline_string(value):
    if "\r" in value:
        return quote_string(value)
    # Luau discards the first newline after a long-string opening delimiter.
    # Supply our own newline, and avoid delimiters crossing the source boundary.
    level = 0
    while True:
        closing = "]" + "=" * level + "]"
        if (value + closing).find(closing) == len(value):
            return "[" + "=" * level + "[\n" + value + closing
        level += 1


def quote_string(value):
    return '"' + value.translate(STRING_ESCAPES) + '"'


def to_luau(value, indent=0):
    if isinstance(value, dict):
        return dict_to_luau_table(value, indent)
    if isinstance(value, list):
        return list_to_luau_table(value, indent)
    if isinstance(value, str):
        return escape_multiline_string(value) if "\n" in value else quote_string(value)
    if value is None:
        return "nil"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        if not math.isfinite(value):
            raise ValueError("Luau table values must be finite")
        return repr(value)
    raise TypeError(f"Unsupported Luau value: {type(value).__name__}")


def dict_to_luau_table(data, indent=0):
    lines = ["{"]
    for key, value in data.items():
        formatted_key = quote_string(key) if isinstance(key, str) else to_luau(key)
        lines.append("    " * (indent + 1) + f"[{formatted_key}] = {to_luau(value, indent + 1)},")
    lines.append("    " * indent + "}")
    return "\n".join(lines)


def list_to_luau_table(data, indent=0):
    lines = ["{"]
    for value in data:
        lines.append("    " * (indent + 1) + to_luau(value, indent + 1) + ",")
    lines.append("    " * indent + "}")
    return "\n".join(lines)


def list_lua_files(base_folder):
    base_folder = Path(base_folder)
    modules = {}
    for path in sorted(base_folder.rglob("*.lua")):
        if path.name in {"full_code.lua", "init.client.lua"}:
            continue
        key = parse.quote(path.relative_to(base_folder).with_suffix("").as_posix())
        modules[key] = path.read_text(encoding="utf-8")
    return modules


def module_factories(modules, clean=False):
    """Define factories before entry-point locals so module globals stay global.

    Clean builds keep source bytes (including comments and strings) untouched.
    Each factory has its own local scope and is invoked only on first use.
    """
    lines = ["{"]
    for key, source in modules.items():
        if not clean:
            source = compact_luau(source)
        if clean:
            lines.extend(["", f"-- Module: {key}"])
        # Game integrations and optional scripts are mostly unused in any one
        # session. Keep these lazy instead of compiling every game at startup.
        if key.startswith(("Games/", "Scripts/")) or key in {"Hacks/Developer", "Hacks/Scrapped"}:
            # Long strings avoid escape decoding in the outer Luau parser and
            # preserve the deferred source text exactly.
            lines.append(f"[{quote_string(key)}] = {escape_multiline_string(source)},")
            continue
        lines.append(f"[{quote_string(key)}] = function(...)\n{source}\nend,")
    lines.append("}")
    return "\n".join(lines)


def render_bundle(source, modules, *, clean=False, source_bundle=False):
    if source.count(PLACEHOLDER) != 1:
        raise ValueError("Expected exactly one preloaded-module placeholder")
    if source_bundle:
        return source.replace(PLACEHOLDER, "C.preloadedModule = " + to_luau(modules), 1)
    # This local is not in scope in its own initializer. Factories therefore
    # cannot accidentally capture it or the entry point's C/Settings/services.
    registry = "__specter_preloaded"
    if registry in source:
        raise ValueError(f"Entry point uses reserved bundle name {registry}")
    header = "-- Generated by compile.py; edit src/client instead.\n" if clean else ""
    prefix = f"local {registry} = " + module_factories(modules, clean) + "\n"
    replacement = f"C.preloadedModule = {registry}\n{registry} = nil"
    entry = source.replace(PLACEHOLDER, replacement, 1)
    return header + prefix + (entry if clean else compact_luau(entry))


def find_compiler():
    configured = os.environ.get("LUAU_COMPILE")
    if configured:
        return configured
    local = Path(__file__).resolve().parent / ".tools" / "luau" / "luau-compile.exe"
    return str(local) if local.is_file() else shutil.which("luau-compile")


def verify_bundle(compiler, output_path, modules, *, clean, source_bundle):
    # The outer compiler cannot see syntax errors in deferred source strings.
    # Compile every transformed module too, without executing Roblox code.
    checks = ["return {"]
    for key, source in modules.items():
        if not clean and not source_bundle:
            source = compact_luau(source)
        checks.append(f"-- Module: {key}\nfunction(...)\n{source}\nend,")
    checks.append("}")
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", newline="\n", suffix=".luau", dir=output_path.parent, delete=False) as stream:
            temporary = Path(stream.name)
            stream.write("\n".join(checks))
        result = subprocess.run([compiler, "--null", str(output_path), str(temporary)], capture_output=True, text=True, timeout=120)
        if result.returncode:
            raise ValueError("Luau verification failed:\n" + result.stdout + result.stderr)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


def compile_client(base_folder=CLIENT_FOLDER, *, clean=False, source_bundle=False, verify=False):
    base_folder = Path(base_folder)
    source = (base_folder / "init.client.lua").read_text(encoding="utf-8")
    modules = list_lua_files(base_folder)
    output = render_bundle(source, modules, clean=clean, source_bundle=source_bundle)
    compiler = find_compiler() if verify else None
    if verify and not compiler:
        raise RuntimeError("Verification requires luau-compile; set LUAU_COMPILE or install it in .tools/luau")
    destination = base_folder / "full_code.lua"
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", newline="\n", suffix=".luau", dir=base_folder, delete=False) as stream:
            temporary = Path(stream.name)
            stream.write(output)
        if verify:
            verify_bundle(compiler, temporary, modules, clean=clean, source_bundle=source_bundle)
        os.replace(temporary, destination)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)
    return destination


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--clean", action="store_true", help="Preserve comments and formatting, with readable module labels")
    parser.add_argument("--source-bundle", action="store_true", help="Use the legacy string bundle with lazy runtime compilation")
    parser.add_argument("--verify", action="store_true", help="Compile-check the generated Luau before replacing full_code.lua")
    args = parser.parse_args()
    start = time.perf_counter()
    destination = compile_client(clean=args.clean, source_bundle=args.source_bundle, verify=args.verify)
    print(f"Built {destination} ({destination.stat().st_size:,} bytes) in {time.perf_counter() - start:.2f}s")
