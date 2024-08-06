task.wait(3 - time())
local PS = game:GetService("Players")
local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local HS = game:GetService("HttpService")
local CG = game:GetService("CoreGui")
local HS = game:GetService("HttpService")
local SP = game:GetService("StarterPlayer")

local isStudio = RunS:IsStudio()
local PrintName = "[Module Loader]"

local C = {}

local function RegisterFunctions()
	--Studio Functions
	C.checkcaller = isStudio and (function() return true end) or checkcaller
	C.getconnections = isStudio and (function(signal) return {} end) or getconnections
	C.getrenv = isStudio and function() return _G end or getrenv
	C.getgenv = isStudio and function() return _G end or getgenv
	C.getsenv = isStudio and (function() return {} end) or getsenv
	C.loadstring = isStudio and function() return function() end end or loadstring
	C.getnamecallmethod = isStudio and (function() return "" end) or getnamecallmethod
	C.getcallingscript = isStudio and (function() return nil end) or getcallingscript
	C.hookfunction = isStudio and function() return end or hookfunction
	C.hookmetamethod = isStudio and function() return end or hookmetamethod
	C.newcclosure = isStudio and function(funct) return funct end or newcclosure
	C.gethui = isStudio and function() return C.PlayerGui end or gethui
	C.firetouchinterest = isStudio and function() return end or function(part1,part2,number)
		local CanTouch1, CanTouch2 = part1.CanTouch, part2.CanTouch
		part1.CanTouch, part2.CanTouch = true, true
		if part1.Parent and part2.Parent then
			if number then
				firetouchinterest(part1,part2,number)
			else
				firetouchinterest(part1,part2,0)
				task.spawn(firetouchinterest,part1,part2,1)
			end
		end
		part1.CanTouch, part2.CanTouch = CanTouch1, CanTouch2
	end
	C.fireclickdetector = isStudio and function() return end or fireclickdetector
	function C.fireproximityprompt(ProximityPrompt, Amount, Skip)
		assert(ProximityPrompt, "Argument #1 Missing or nil")
		assert(typeof(ProximityPrompt) == "Instance" and ProximityPrompt:IsA("ProximityPrompt"), "Attempted to fire a Value that is not a ProximityPrompt")
	
		local HoldDuration = ProximityPrompt.HoldDuration
		if Skip then
			ProximityPrompt.HoldDuration = 0
		end
	
		for i = 1, Amount or 1 do
			ProximityPrompt:InputHoldBegin()
			if Skip then
				local Start = time()
				repeat
					RunS.Heartbeat:Wait()
				until time() - Start > HoldDuration
			end
			ProximityPrompt:InputHoldEnd()
		end
		ProximityPrompt.HoldDuration = HoldDuration
	end
	C.setclipboard = isStudio and function() return end or function(input: string)
		setclipboard(tostring(input))
	end
	C.getloadedmodules = isStudio and function() return {C.PlayerScripts.PlayerModule.ControlModule} end or getloadedmodules
	C.request = not isStudio and request
	C.isfolder = not isStudio and isfolder
	C.readfile = not isStudio and readfile
	C.isfile = not isStudio and isfile
	C.makefolder = not isStudio and makefolder
	C.writefile = not isStudio and writefile
	C.setscriptable = not isStudio and setscriptable
	C.request = isStudio and function() end or request
	--Important In-Game Functions
	function C.GenerateGUID()
		return HS:GenerateGUID(false)
	end
end

RegisterFunctions() -- Loads Studio and Hack Compatiblity

C.isStudio = isStudio
C.plr = PS.LocalPlayer
C.StartUp = true
if C.getgenv().Defaults then
	C.Defaults = C.getgenv().Defaults
else
	C.Defaults = {WalkSpeed = SP.CharacterWalkSpeed, JumpPower = SP.CharacterJumpPower, Gravity = workspace.Gravity,
		Username = C.plr.Name,DisplayName = C.plr.DisplayName, AutoJumpEnabled = SP.AutoJumpEnabled}
	C.getgenv().Defaults = C.Defaults
end
C.PlayerGui = C.plr:WaitForChild("PlayerGui")
C.PlayerScripts = C.plr:WaitForChild("PlayerScripts")
C.BaseUrl = "https://github.com/ItsAFairGameBro/Specter/%s/main/src/client"
if C.getgenv().enHacks then
	C.enHacks = C.getgenv().enHacks
else
	C.enHacks = {}
	C.getgenv().enHacks = C.enHacks
end
C.getgenv().ProfileId = C.getgenv().ProfileId or ""
C.hackData = {}
C.events = {}
C.keybinds = {}
C.functs = {} -- global connections
C.friends = {}
C.playerfuncts = {} -- player connections
C.objectfuncts = {} -- instance connections
C.preloadedModule = {}
C.forcePropertyFuncts = {}
C.BindedActions = {} -- key binds
C.EventFunctions = {}
C.Randomizer = Random.new()
C.Debugs = {All = false,
	Destroy = false,
	Module = false,
	Load = false,
	SaveSystem = false,
	Teleport = false,
	Override = false,
	Thread = false,
	AntiCheat = false,
}

local Settings = C.getgenv().SETTINGS
if not Settings then
	Settings = {
		ServerSaveDeleteTime = 3600 * 24 -- Time before deletion
	}
	C.getgenv().SETTINGS = Settings
end
C.getgenv().C = C

local PreDebugMessage = `[SpecterV2/%s]: `
function C.DebugMessage(type,message)
	assert(C.Debugs[type]~=nil, `{PreDebugMessage}Message Type Not Found: "{tostring(type)}" in an attempt to create message: "{message}"`)
	if not C.Debugs[type] and not C.Debugs.All then
		return false
	end
	print(`{PreDebugMessage:format(type)}{message}`)
	return true
end

function C.StringWait(start,path,timeout,seperationChar)
	local seperationChar = seperationChar or "."
	local current = start
	local pathTbl = string.split(path,seperationChar)
	for i,v in ipairs(pathTbl) do
		local next = current:WaitForChild(v,timeout)
		if next then
			current = next
		else
			warn("C.StringWait failed to find "..v.." in "..next:GetFullName().." from "..start)
			return
		end
	end
	return current
end

function C.StringFind(start,path,seperationChar,recursionEnabled)
	local seperationChar = seperationChar or "."
	local current = start
	local pathTbl = string.split(path,seperationChar)
	for i,v in ipairs(pathTbl) do
		local next = current:FindFirstChild(v,recursionEnabled)
		if next then
			current = next
		else
			warn("C.StringFind failed to find "..v.." in "..current:GetFullName().." from "..start:GetFullName())
			return
		end
	end
	return current
end

function C.RunLink(githubLink,gitType,name)
	local URL = githubLink:format(gitType:lower(),name);
	local success, response = pcall(game.HttpGet,game,URL,false)

	if not success then
		return warn(PrintName.." Error Requesting Script " .. name .. ":" ..response)
	end
	local scriptName = URL:sub(20)
	scriptName = scriptName:sub(scriptName:find("/")+1)
	scriptName = scriptName:sub(1,scriptName:find("/")-1):gsub("-"," ")
	local success3, codeString
	if URL:find("blob")~=nil then
		local startText = '"blob":{"rawLines":'
		local endText = ',"stylingDirectives":'
		local startAddress = response:find(startText) + startText:len()
		local endAddress = response:find(endText) -- endText:len()
		response = response:sub(startAddress,endAddress-1)
		local success2, decodedJSON = pcall(HS.JSONDecode,HS,response)

		if not success2 then
			return warn(PrintName.." Error Parsing JSON: "..decodedJSON)
		end

		success3, codeString = pcall(table.concat, decodedJSON, "\n")

		if not success3 then
			return warn(PrintName.." Error Parsing Code: "..codeString)
		end
	elseif URL:find("raw") then
		codeString = response
	end

	local success4, compiledFunction = pcall(loadstring,codeString)

	if not success4 then
		return warn(PrintName.." Error Compiling Code: "..compiledFunction)
	elseif not compiledFunction then
		return warn(PrintName.." Loadstring Failed: Syntax Error!\n\n\t\tCheck Github or DM author!")
	end

	return compiledFunction()
end

C.SaveModules = {}

function GetModule(moduleName: string)
	local path = moduleName:find("/") and moduleName or ("Modules/"..moduleName)
	if isStudio then
		return require(C.StringWait(script,path,nil,"/"))(C, Settings)
	else
		local gitType = "blob"
		local githubLink = C.BaseUrl .. "/%s.lua"
		local result = C.preloadedModule[moduleName] or C.RunLink(githubLink,gitType,path)
		return result(C,Settings)
	end
end

function C.LoadModule(moduleName: string)
	local informalSplit = moduleName:split("/")
	local informalName = informalSplit[#informalSplit]
	local Ret = C.SaveModules[informalName]
	if Ret then
		return Ret
	end
	local Start = os.clock()
	C.DebugMessage("Module",`Loading {moduleName}`)
	local Mod = GetModule(moduleName)
	C.SaveModules[informalName] = Mod
	C.DebugMessage("Module",(`Loaded {moduleName} in %.2f seconds`):format(os.clock()-Start))
	return Mod
end
local ModulesToPreload = {"Hacks/Blatant","Hacks/Friends","Hacks/Render","Hacks/Utility","Hacks/World","Hacks/Settings","Binds","CoreEnv","CoreLoader","Env","Events","GuiElements","HackOptions"}
if not C.isStudio then
	local loaded = 0
	for num, module in ipairs(ModulesToPreload) do
		local gitType = "blob"
		local githubLink = C.BaseUrl .. "/%s.lua"
		local path = module:find("/") and module or ("Modules/"..module)
		local moduleParams = module:split("/")
		local informalSplit = module:split("/")
		local informalName = informalSplit[#informalSplit]
		task.spawn(function()
			C.preloadedModule[module] = C.RunLink(githubLink,gitType,path)
			loaded += 1
		end)
	end
	while loaded < #ModulesToPreload do
		RunS.RenderStepped:Wait()
	end
end

return C.LoadModule("CoreLoader")