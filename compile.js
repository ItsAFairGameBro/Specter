import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

// Measure start time
const startTime = Date.now();

// Get the current script's directory
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Define the base folder dynamically based on the current directory
const baseFolder = path.join(__dirname, 'Modules', 'Env');

// Define paths for input and output files
const initFilePath = path.join(baseFolder, 'init.client.lua');
const outputFilePath = path.join(baseFolder, 'full_code.lua');

// Function to escape multi-line strings for Luau
function escapeMultilineString(value) {
    if (value.includes('[[') || value.includes(']]')) {
        let delimiterLevel = 1;
        while (value.includes(`[${'='.repeat(delimiterLevel)}[`) || value.includes(`]${'='.repeat(delimiterLevel)}]`)) {
            delimiterLevel++;
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
            formattedValue = value.includes('\n') ? escapeMultilineString(value) : `"${value}"`;
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
    const lines = ['{'];
    const indentSpace = '    '.repeat(indent + 1);

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
    lines.push('    '.repeat(indent) + '}');
    return lines.join('\n');
}

// Function to list Lua files and their content
function listLuaFiles(baseFolder) {
    const luaFiles = {};
    const ignoreList = ['full_code.lua', 'init.client.lua'];

    const walkSync = (dir) => {
        fs.readdirSync(dir, { withFileTypes: true }).forEach(dirent => {
            const resolvedPath = path.resolve(dir, dirent.name);
            if (dirent.isDirectory()) {
                walkSync(resolvedPath);
            } else if (dirent.isFile() && dirent.name.endsWith('.lua') && !ignoreList.includes(dirent.name)) {
                const relativePath = path.relative(baseFolder, resolvedPath).replace(/\\/g, '/');
                const key = encodeURIComponent(relativePath.replace(/\.lua$/, ''));
                const content = fs.readFileSync(resolvedPath, 'utf-8');
                luaFiles[key] = content;
            }
        });
    };

    walkSync(baseFolder);
    return luaFiles;
}

// Read the init.client.lua file
const data = fs.readFileSync(initFilePath, 'utf-8');

// Get Lua files as modules
const modules = listLuaFiles(baseFolder);

// Replace preloaded module placeholder in the data
const updatedData = data.replace('C.preloadedModule = {}', `C.preloadedModule = ${dictToLuauTable(modules)}`);

// Write to the output file
fs.writeFileSync(outputFilePath, updatedData, 'utf-8');

console.log(`Successfully compiled in ${(Date.now() - startTime) / 1000} seconds`);
