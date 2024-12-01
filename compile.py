import os
import re

file = open("C:\\Users\\ryanb\\Documents\\ROBLOX\\Specter\\src\\client\\init.client.lua", 'r', encoding="utf-8")

def escape_multiline_string(value):
    """Escape multi-line strings with appropriate Luau block delimiters."""
    if "[[" in value or "]]" in value:
        # Use alternative block delimiters if [[ or ]] is found
        delimiter_level = 1
        while f"[{'=' * delimiter_level}[" in value or f"]{'=' * delimiter_level}]" in value:
            delimiter_level += 1
        return f'[{"=" * delimiter_level}[{value}]{"=" * delimiter_level}]'
    else:
        # Default block string delimiters for multi-line
        return f'[[{value}]]'

def dict_to_luau_table(data, indent=0):
    """Convert a Python dictionary to a readable Luau table format."""
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

def list_to_luau_table(data, indent=0):
    """Convert a Python list to a readable Luau array format."""
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


data = file.read()

modules = {}

import os

def list_lua_files(base_folder):
    """Recursively find all Lua files in a folder and its subfolders, and format their paths."""
    lua_files = {}
    ignore_list = ["full_code.lua", "init.client.lua"]
    
    for root, _, files in os.walk(base_folder):
        for file in files:
            relative_path = os.path.relpath(os.path.join(root, file), base_folder)
            if file.endswith(".lua") and not relative_path in ignore_list:
                # Get the relative path of the Lua file from the base folder
                cur_file = open(root + "\\" + file, "r", encoding='utf-8')
                lua_files[relative_path.replace("\\", "/").replace(".lua","")] = cur_file.read() # Ensure Unix-style paths
    
    return lua_files

base_folder = "C:\\Users\\ryanb\\Documents\\ROBLOX\\Specter\\src\\client"  # Replace with your folder path
modules = list_lua_files(base_folder)


#C.preloadedModule = {}
# Replace with
# C.preloadedModule = {[key] = `code`}

data = data.replace("C.preloadedModule = {}", "C.preloadedModule = " + dict_to_luau_table(modules))

writeFile = open("C:\\Users\\ryanb\\Documents\\ROBLOX\\Specter\\src\\client\\full_code.lua", "w", encoding="utf-8")
writeFile.write(data)

writeFile.close()
file.close()