const fs = require('fs');
const path = require('path');
const url = require('url');

if (true){ return }

const startTime = Date.now();

// Get the current script's directory
const currentDir = __dirname;

// Define the base folder dynamically based on the current directory
const baseFolder = path.join(currentDir, 'src', 'client');

// Define paths for input and output files
const initFilePath = path.join(baseFolder, 'init.client.lua');
const outputFilePath = path.join(baseFolder, 'full_code.lua');

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
// Function to escape multi-line strings for Luau
function escapeMultilineString(value) {
    if (value.includes('[[') || value.includes(']]')) {
        let delimiterLevel = 1;
        while (
            value.includes(`[${'='.repeat(delimiterLevel)}[`) ||
            value.includes(`]${'='.repeat(delimiterLevel)}]`)
        ) {
            delimiterLevel += 1;
        }
        return `[${'='.repeat(delimiterLevel)}[${value}]${'='.repeat(delimiterLevel)}]`;
    } else {
        return `[[${value}]]`;
    }
}

// Function to convert a JavaScript object to a Luau table
function dictToLuauTable(data, indent = 0) {
    const lines = ['{'];
    const indentSpace = '    '.repeat(indent + 1);

    for (const [key, value] of Object.entries(data)) {
        const formattedKey = `["${key}"]`;
        let formattedValue;

        if (typeof value === 'object' && !Array.isArray(value)) {
            formattedValue = dictToLuauTable(value, indent + 1);
        } else if (Array.isArray(value)) {
            formattedValue = listToLuauTable(value, indent + 1);
        } else if (typeof value === 'string') {
            formattedValue = value.includes('\n')
                ? escapeMultilineString(value)
                : `"${value}"`;
        } else {
            formattedValue = JSON.stringify(value);
        }

        lines.push(`${indentSpace}${formattedKey} = ${formattedValue},`);
    }

    lines.push('    '.repeat(indent) + '}');
    return lines.join('\n');
}

// Function to convert a JavaScript array to a Luau table
function listToLuauTable(data, indent = 0) {
    const indentSpace = '    '.repeat(indent + 1);
    const lines = ['{'];

    for (const value of data) {
        let formattedValue;

        if (typeof value === 'object' && !Array.isArray(value)) {
            formattedValue = dictToLuauTable(value, indent + 1);
        } else if (Array.isArray(value)) {
            formattedValue = listToLuauTable(value, indent + 1);
        } else if (typeof value === 'string') {
            formattedValue = value.includes('\n')
                ? escapeMultilineString(value)
                : `"${value}"`;
        } else {
            formattedValue = JSON.stringify(value);
        }

        lines.push(`${indentSpace}${formattedValue},`);
    }

    lines.push('    '.repeat(indent) + '}');
    return lines.join('\n');
}

// Function to list Lua files and their content
function listLuaFiles(baseFolder) {
    const luaFiles = {};
    const ignoreList = ['full_code.lua', 'init.client.lua'];

    const traverseDirectory = (dir) => {
        fs.readdirSync(dir, { withFileTypes: true }).forEach((entry) => {
            const entryPath = path.join(dir, entry.name);
            if (entry.isDirectory()) {
                traverseDirectory(entryPath);
            } else if (
                entry.isFile() &&
                entry.name.endsWith('.lua') &&
                !ignoreList.includes(entry.name)
            ) {
                // Get the relative path and convert it to a forward-slash format
                const relativePath = path.relative(baseFolder, entryPath).replace(/\\/g, '/');
                const key = relativePath.replace(/\.lua$/, ''); // Remove the .lua extension
                luaFiles[key] = fs.readFileSync(entryPath, 'utf-8');
            }
        });
    };

    traverseDirectory(baseFolder);
    return luaFiles;
}

// Read the init.client.lua file
const data = fs.readFileSync(initFilePath, 'utf-8');

// Get Lua files as modules
const modules = listLuaFiles(baseFolder);

// Replace preloaded module placeholder in the data
const replacedData = data.replace(
    'C.preloadedModule = {}',
    `C.preloadedModule = ${dictToLuauTable(modules)}`
);

// Write to the output file
fs.writeFileSync(outputFilePath, replacedData, 'utf-8');

console.log(`Successfully compiled in ${(Date.now() - startTime) / 1000} seconds`);
