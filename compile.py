import os
import re
from urllib import parse
import time
import sys
from pathlib import Path

startTime = time.time()

# Get the current script's directory
current_dir = Path(__file__).parent

# Define the base folder dynamically based on the current directory
base_folder = current_dir / "src" / "client"

# Define paths for input and output files
init_file_path = base_folder / "init.client.lua"
output_file_path = base_folder / "full_code.lua"

# Function to escape multi-line strings for Luau
def escape_multiline_string(value):
    if "[[" in value or "]]" in value:
        delimiter_level = 1
        while f"[{'=' * delimiter_level}[" in value or f"]{'=' * delimiter_level}]" in value:
            delimiter_level += 1
        return f'[{"=" * delimiter_level}[{value}]{"=" * delimiter_level}]'
    else:
        return f'[[{value}]]'

# Function to convert a Python dictionary to a Luau table
def dict_to_luau_table(data, indent=0):
    lines = ["{"]
    indent_space = "    " * (indent + 1)

    for key, value in data.items():
        formatted_key = f'["{key}"]'
        if isinstance(value, dict):
            formatted_value = dict_to_luau_table(value, indent + 1)
        elif isinstance(value, list):
            formatted_value = list_to_luau_table(value, indent + 1)
        elif isinstance(value, str):
            if "\n" in value:
                formatted_value = escape_multiline_string(value)
            else:
                formatted_value = f'"{value}"'
        else:
            formatted_value = repr(value)
        lines.append(f'{indent_space}{formatted_key} = {formatted_value},')
    lines.append("    " * indent + "}")
    return "\n".join(lines)

# Function to convert a Python list to a Luau table
def list_to_luau_table(data, indent=0):
    indent_space = "    " * (indent + 1)
    lines = ["{"]
    for value in data:
        if isinstance(value, dict):
            formatted_value = dict_to_luau_table(value, indent + 1)
        elif isinstance(value, list):
            formatted_value = list_to_luau_table(value, indent + 1)
        elif isinstance(value, str):
            if "\n" in value:
                formatted_value = escape_multiline_string(value)
            else:
                formatted_value = f'"{value}"'
        else:
            formatted_value = repr(value)
        lines.append(f'{indent_space}{formatted_value},')
    lines.append("    " * indent + "}")
    return "\n".join(lines)

# Function to list Lua files and their content
def list_lua_files(base_folder):
    lua_files = {}
    ignore_list = ["full_code.lua", "init.client.lua"]
    for root, _, files in os.walk(base_folder):
        for file in files:
            relative_path = Path(root).joinpath(file).relative_to(base_folder)
            if file.endswith(".lua") and relative_path.name not in ignore_list:
                with open(base_folder / relative_path, "r", encoding="utf-8") as cur_file:
                    key = parse.quote(str(relative_path.with_suffix("")).replace("\\", "/"))
                    lua_files[key] = cur_file.read()
    return lua_files

# Read the init.client.lua file
with open(init_file_path, "r", encoding="utf-8") as file:
    data = file.read()

# Get Lua files as modules
modules = list_lua_files(base_folder)

# Replace preloaded module placeholder in the data
data = data.replace("C.preloadedModule = {}", "C.preloadedModule = " + dict_to_luau_table(modules))

# Write to the output file
with open(output_file_path, "w", encoding="utf-8") as write_file:
    write_file.write(data)

print(f"Successfully compiled in {time.time() - startTime:.2f} seconds")