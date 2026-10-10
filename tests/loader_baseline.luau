C.SaveModules = {}
local LoadedModules = {}
function GetModule(path: string)
    -- All paths start from src and to the lua file
	-- local path = moduleName:find("/") and moduleName or ("Modules/"..moduleName)
	if isStudio then
		local moduleRet = require(C.StringWait(script,HttpUrlDecode(path),nil,"/"))
		if typeof(moduleRet) == "function" then
			return moduleRet(C, Settings)
		else
			return moduleRet
		end
	else
		local gitType = "blob"
		local githubLink = C.BaseUrl .. "/%s.lua"
		local result = C.preloadedModule[path]
        if PreCached then
            assert(result, `{path} does not have a preloaded module!`)
            if not LoadedModules[path] then
                local compiled, compileError = result, nil
                if typeof(compiled) ~= "function" then
                    compiled, compileError = loadstring(result)
                    assert(compiled, `Compiler Error: {path}: {compileError}`)
                end
                result = compiled()
                assert(result, `Module Path Load Failed: {path}`)
                C.preloadedModule[path] = result
                LoadedModules[path] = true
            end
        else
            result = C.RunLink(githubLink,gitType,path)
        end
        assert(result, `Module Path Load Failed: {path}`)
		if typeof(result) == "function" then
			return result(C,Settings)
		else
			return result
		end
	end
end
function HttpUrlDecode(str)
	local output, t = string.gsub(str,"%%(%x%x)",function(hex)
		return string.char(tonumber(hex,16))
	end)
	return output
end
function C.LoadModule(moduleName: string)
	local Ret = C.SaveModules[moduleName]
	if Ret then
		return Ret
	end
	local DisplayName = HttpUrlDecode(moduleName)
	local Start = os.clock()
	C.DebugMessage("Module",`Loading {DisplayName}`)
	local Mod = GetModule(moduleName)
	C.SaveModules[moduleName] = Mod
	C.DebugMessage("Module",(`Loaded {DisplayName} in %.2f seconds`):format(os.clock()-Start))
	return Mod
end
--print("modules p reload")

