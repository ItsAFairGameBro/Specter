const fs = require('fs');
const path = require('path');
const { URL } = require('url');

const startTime = Date.now();

// Get the current script's directory
const currentDir = path.dirname(new URL(import.meta.url).pathname);

// Define the base folder dynamically based on the current directory
const baseFolder = path.join(currentDir, 'src', 'client');

// Define paths for input and output files
const initFilePath = path.join(baseFolder, 'init.client.lua');
const outputFilePath = path.join(baseFolder, 'full_code.lua');

// Function to escape multi-line strings for Luau
function escapeMultilineString(value) {
    if (value.includes('[[') || value.includes(']]')) {
        let delimiterLevel = 1;
        while (value.includes(`[${'='.repeat(delimiterLevel)}[` ) || value.includes(`]${'='.repeat(delimiterLevel)}]`)) {
            delimiterLevel++;
        }
        return `[${'='.repeat(delimiterLevel)}[${value}]${'='.repeat(delimiterLevel)}]`;
    } else {
        return `[[${value}]]`;
    }
}

// Function to convert a JavaScript object to a Luau table
function dictToLuauTable(data, indent = 0) {
    const lines = ["{"];
    const indentSpace = "    ".repeat(indent + 1);

    for (const [key, value] of Object.entries(data)) {
        const formattedKey = `["${key}"]`;
        let formattedValue;
        if (typeof value === 'object' && !Array.isArray(value)) {
            formattedValue = dictToLuauTable(value, indent + 1);
        } else if (Array.isArray(value)) {
            formattedValue = listToLuauTable(value, indent + 1);
        } else if (typeof value === 'string') {
            formattedValue = value.includes('\n') ? escapeMultilineString(value) : `"${value}"`;
        } else {
            formattedValue = JSON.stringify(value);
        }
        lines.push(`${indentSpace}${formattedKey} = ${formattedValue},`);
    }
    lines.push("    ".repeat(indent) + "}");
    return lines.join("\n");
}

// Function to convert a JavaScript array to a Luau table
function listToLuauTable(data, indent = 0) {
    const indentSpace = "    ".repeat(indent + 1);
    const lines = ["{"];
    for (const value of data) {
        let formattedValue;
        if (typeof value === 'object' && !Array.isArray(value)) {
            formattedValue = dictToLuauTable(value, indent + 1);
        } else if (Array.isArray(value)) {
            formattedValue = listToLuauTable(value, indent + 1);
        } else if (typeof value === 'string') {
            formattedValue = value.includes('\n') ? escapeMultilineString(value) : `"${value}"`;
        } else {
            formattedValue = JSON.stringify(value);
        }
        lines.push(`${indentSpace}${formattedValue},`);
    }
    lines.push("    ".repeat(indent) + "}");
    return lines.join("\n");
}

// Function to list Lua files and their content
function listLuaFiles(baseFolder) {
    const luaFiles = {};
    const ignoreList = ["full_code.lua", "init.client.lua"];
    const files = fs.readdirSync(baseFolder, { withFileTypes: true });

    for (const file of files) {
        if (file.isDirectory()) {
            const nestedFiles = listLuaFiles(path.join(baseFolder, file.name));
            Object.assign(luaFiles, nestedFiles);
        } else if (file.name.endsWith('.lua') && !ignoreList.includes(file.name)) {
            const relativePath = path.relative(baseFolder, path.join(baseFolder, file.name));
            const key = encodeURIComponent(relativePath.replace(/\\/g, '/').replace('.lua', ''));
            luaFiles[key] = fs.readFileSync(path.join(baseFolder, file.name), 'utf-8');
        }
    }
    return luaFiles;
}

// Read the init.client.lua file
const data = fs.readFileSync(initFilePath, 'utf-8');

// Get Lua files as modules
const modules = listLuaFiles(baseFolder);

// Replace preloaded module placeholder in the data
const updatedData = data.replace("C.preloadedModule = {}", `C.preloadedModule = ${dictToLuauTable(modules)}`);

// Write to the output file
fs.writeFileSync(outputFilePath, updatedData, 'utf-8');

console.log(`Successfully compiled in ${(Date.now() - startTime) / 1000} seconds`);