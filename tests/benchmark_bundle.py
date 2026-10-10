"""Compare bundle compilation costs using actual modules and the Luau CLI.

No Roblox services are used. Timings include parsing the bundle, creating its
registry, and compiling selected modules. Dispatch uses a synthetic module;
steady-state comparisons run the actual table-equality implementation.
"""

import argparse
from pathlib import Path
import statistics
import subprocess

from test_regressions import LUAU, ROOT, bundle, section, workspace_temp


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--iterations", type=int, default=30)
    parser.add_argument("--baseline-registry", type=Path, help="Compare against a previous bundle that returns its module registry")
    parser.add_argument("--baseline-loader", type=Path, default=ROOT / "tests/loader_baseline.luau", help="Compare module dispatch against a previous loader section")
    args = parser.parse_args()
    if args.iterations < 1:
        parser.error("--iterations must be positive")
    if not LUAU.is_file():
        parser.error("Set LUAU to the official Luau CLI executable")
    modules = bundle.list_lua_files(ROOT / "src/client")
    entry = "local C = {}\n" + bundle.PLACEHOLDER + "\nreturn C.preloadedModule"
    legacy = bundle.render_bundle(entry, modules, source_bundle=True)
    if args.baseline_registry:
        legacy = args.baseline_registry.read_text(encoding="utf-8")
    fast = bundle.render_bundle(entry, modules)
    core = [key for key in modules if key.startswith("Modules/")]
    startup = [key for key in modules if key.startswith(("Modules/", "Hacks/")) and key not in {"Hacks/Developer", "Hacks/Scrapped"}]
    harness = (
        "local legacy = " + bundle.to_luau(legacy) + "\n"
        "local fast = " + bundle.to_luau(fast) + "\n"
        "local core = " + bundle.to_luau(core) + "\n"
        "local startup = " + bundle.to_luau(startup) + "\n"
        "local all = " + bundle.to_luau(list(modules)) + "\n"
        + f"local iterations = {args.iterations}\n"
        + '''
local function measure(source, keys)
    local start = os.clock()
    local registry = assert(loadstring(source))()
    for _, key in keys do
        if type(registry[key]) == "string" then
            assert(loadstring(registry[key]))
        end
    end
    return os.clock() - start
end
for _, scenario in {{"core", core}, {"startup", startup}, {"all", all}} do
    measure(legacy, scenario[2])
    measure(fast, scenario[2])
    for i = 1, iterations do
        -- Alternate ordering to reduce warmup/GC bias.
        local a, b
        if i % 2 == 0 then
            b = measure(fast, scenario[2]); a = measure(legacy, scenario[2])
        else
            a = measure(legacy, scenario[2]); b = measure(fast, scenario[2])
        end
        print(scenario[1], a, b)
    end
end
'''
    )
    with workspace_temp() as directory:
        if args.baseline_loader:
            debug = section('src/client/init.client.lua', 'function C.DebugMessage', 'function C.StringWait')
            current_loader = section('src/client/init.client.lua', 'C.SaveModules = {}', '--Load hooks immediately')
            prefix = '''
local isStudio, PreCached = false, true
local Settings = {}
local C = {BaseUrl="url", Debugs={Module=false,All=false}, preloadedModule={
    ["Modules/Test%20Module"] = function() return {ok=true} end,
}}
'''
            for name, code in (("old_loader", args.baseline_loader.read_text(encoding="utf-8")), ("new_loader", current_loader)):
                (directory / (name + ".luau")).write_text(prefix + debug + code + '\nreturn C', encoding="utf-8")
            harness += '''
local old = require("./old_loader")
local new = require("./new_loader")
local function dispatch(C)
    local start = os.clock()
    for i=1,100000 do
        C.SaveModules["Modules/Test%20Module"] = nil
        assert(C.LoadModule("Modules/Test%20Module").ok)
    end
    return os.clock() - start
end
dispatch(old); dispatch(new)
for i=1,iterations do
    local a,b
    if i % 2 == 0 then b=dispatch(new); a=dispatch(old)
    else a=dispatch(old); b=dispatch(new) end
    print("dispatch",a,b)
end
'''
        equality = section('src/client/Modules/Env.lua', '\tfunction C.AreTablesEqual', '\tlocal savedFriendsCashe')
        runtime_modules = {"Equality": "return function(C)\n" + equality + "\nend"}
        runtime_entry = "local C = {}\n" + bundle.PLACEHOLDER + '''
local module = C.preloadedModule.Equality
if type(module) == "string" then module = assert(loadstring(module)) end
module()(C)
return C.AreTablesEqual
'''
        for name, legacy_mode in (("legacy", True), ("fast", False)):
            (directory / (name + ".luau")).write_text(
                bundle.render_bundle(runtime_entry, runtime_modules, source_bundle=legacy_mode), encoding="utf-8")
        harness += '''
local oldEqual = require("./legacy")
local newEqual = require("./fast")
local a = {x={a=1,b=2,c=3},y={a=4,b=5,c=6},z="value"}
local b = {x={a=1,b=2,c=3},y={a=4,b=5,c=6},z="value"}
local function compare(equal)
    local start = os.clock()
    for i=1,100000 do assert(equal(a,b)) end
    return os.clock() - start
end
compare(oldEqual); compare(newEqual)
for i=1,iterations do
    local a, b
    if i % 2 == 0 then
        b=compare(newEqual); a=compare(oldEqual)
    else
        a=compare(oldEqual); b=compare(newEqual)
    end
    print("equality",a,b)
end
'''
        script = directory / "benchmark.luau"
        script.write_text(harness, encoding="utf-8")
        result = subprocess.run([str(LUAU), str(script)], capture_output=True, text=True, timeout=120)
        if result.returncode:
            raise RuntimeError(result.stdout + result.stderr)
    samples = {name: ([], []) for name in ("core", "startup", "all", "equality")}
    if args.baseline_loader:
        samples["dispatch"] = ([], [])
    for line in result.stdout.splitlines():
        name, old, new = line.split()
        samples[name][0].append(float(old))
        samples[name][1].append(float(new))
    for name, (old, new) in samples.items():
        old_ms, new_ms = statistics.median(old) * 1000, statistics.median(new) * 1000
        baseline = "previous" if (args.baseline_registry and name != "equality") or name == "dispatch" else "legacy"
        print(f"{name}: {baseline} {old_ms:.2f}ms, current {new_ms:.2f}ms, {old_ms / new_ms:.2f}x ({args.iterations} runs)")


if __name__ == "__main__":
    main()
