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
local allDisabled = {
	firetouchinterest = false,
}
local executorName = not isStudio and identifyexecutor()
local enExecutor = (isStudio and allDisabled) or (executorName=="Cryptic" and {firetouchinterest=true}) or {firetouchinterest=true}

local function RegisterFunctions()
	local firetouchinterest = firetouchinterest
	if not enExecutor.firetouchinterest or not firetouchinterest then
		
		firetouchinterest = function(part1,part2,number)--creates a fake touch function
			local thread
			thread = task.spawn(function(dt)
				C.SetPartProperty(part2,"CanCollide","firetouchinterest",false)
				C.SetPartProperty(part2,"Transparency","firetouchinterest",1)
				C.SetPartProperty(part2,"Size","firetouchinterest",Vector3.one * 1e3)
				C.SetPartProperty(part2,"CFrame","firetouchinterest",part1:GetPivot() * CFrame.new(Vector3.new(0,0,-2)+part1.AssemblyLinearVelocity/60))
				C.SetPartProperty(part2,"Anchored","firetouchinterest",false)
				local touching = 0
				while true do
					if table.find(part2:GetTouchingParts(), part1) then
						touching+=1
						if touching==4 then break end
					else
						touching = 0
					end
					part2.AssemblyLinearVelocity = (part1.Position - part2.Position) * 60 --* (6*(1+part1.AssemblyLinearVelocity.Magnitude))
					RunS.PreSimulation:Wait()
				end
				C.ResetPartProperty(part2,"CanCollide","firetouchinterest")
				C.ResetPartProperty(part2,"Transparency","firetouchinterest")
				C.ResetPartProperty(part2,"Size","firetouchinterest")
				C.ResetPartProperty(part2,"CFrame","firetouchinterest")
				C.ResetPartProperty(part2,"Anchored","firetouchinterest")
			end)
			C.StopThread(thread)
		end
	end
	--Generic Functions
	function C.yieldForeverFunct()
		game:WaitForChild("SuckMyPPOrYoureGay",math.huge)
	end
	--Studio Functions
	C.checkcaller = isStudio and (function() return true end) or checkcaller
	C.getconnections = isStudio and (function(signal) return {} end) or getconnections
	C.getrenv = isStudio and function() return _G end or getrenv
	C.getgenv = isStudio and function() return _G end or getgenv
	C.getsenv = isStudio and (function() return {} end) or getsenv
	C.loadstring = isStudio and function() return function() end end or loadstring
	C.getnamecallmethod = isStudio and (function() return "" end) or getnamecallmethod
	C.getcallingscript = isStudio and (function() return nil end) or getcallingscript
	C.hookfunction = isStudio and function(a,b) return C.checkcaller end or hookfunction
	C.hookmetamethod = isStudio and function() return end or hookmetamethod
	C.newcclosure = isStudio and function(funct) return funct end or newcclosure
	C.gethui = isStudio and function() return C.PlayerGui end or gethui
	C.firetouchinterest = function(part1,part2,number)
		if not firetouchinterest then
			return
		end
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
				local Start = os.clock()
				repeat
					RunS.Heartbeat:Wait()
				until os.clock() - Start > HoldDuration
			end
			ProximityPrompt:InputHoldEnd()
		end
		ProximityPrompt.HoldDuration = HoldDuration
	end
	C.setclipboard = isStudio and function() return end or function(input: string)
		setclipboard(tostring(input))
	end
	C.getloadedmodules = isStudio and function() return {C.PlayerScripts.PlayerModule.ControlModule} end or getloadedmodules
	C.getrunningscripts = isStudio and function () return {} end or getrunningscripts
	C.getinstances = isStudio and function () return game:GetDescendants() end or getinstances
	C.request = not isStudio and request
	C.isfolder = not isStudio and isfolder
	C.readfile = not isStudio and readfile
	C.isfile = not isStudio and isfile
	C.makefolder = not isStudio and makefolder
	C.writefile = not isStudio and writefile
	C.setscriptable = not isStudio and setscriptable
	C.request = isStudio and function() end or request
	local requireFunctsToRun = isStudio and {require} or {getrenv().require,require,getsenv}
	function C.require(ModuleScript: Script)
		local success, result
		for num, funct in ipairs(requireFunctsToRun) do
			success, result = pcall(funct,ModuleScript)
			if result ~= "Cannot require a non-RobloxScript module from a RobloxScript" then
				break
			end
		end
		if not success then
			warn("[Specter C.require]: Failed To Load Module "..tostring(ModuleScript)..": "..tostring(result))
			C.yieldForeverFunct()
		end
		return result
	end
	
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
C.HighestNumber = 2^63-1 -- Largest integer possible
C.PlayerGui = C.plr:WaitForChild("PlayerGui")
task.spawn(function()
	C.PlayerScripts = C.plr:WaitForChild("PlayerScripts",100)
end)
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
C.functs, C.threads = {}, {} -- global connections/threads
C.friends = {}
C.playerfuncts = {} -- player connections
C.objectfuncts = {} -- instance connections
C.preloadedModule = {}
C.forcePropertyFuncts = {}
C.BindedActions = {} -- key binds
C.EventFunctions = {}
C.Camera = workspace.CurrentCamera -- updated later in Events
C.Randomizer = Random.new()
C.Debugs = {All = false,
	Destroy = false,
	Module = false,
	Load = false,
	Teleport = false,
	Override = false,
	Thread = false,
	SaveSystem = false,
	RenderHighlight=true,
	AntiCheat = true,
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
	if not start then return end
	local current = start
	local pathTbl = path:split(seperationChar or ".")
	for i,v in ipairs(pathTbl) do
		local next = current:WaitForChild(v,timeout)
		if next then
			current = next
		else
			warn("C.StringWait failed to find "..v.." in "..next:GetFullName().." from "..tostring(start))
			return
		end
	end
	return current
end

function C.StringFind(start,path,seperationChar,recursionEnabled)
	if not start then return end
	local current = start
	local pathTbl = path:split(seperationChar or ".")
	for i,v in ipairs(pathTbl) do
		local next = current:FindFirstChild(v,recursionEnabled)
		if next then
			current = next
		else
			--warn("C.StringFind failed to find "..v.." in "..current:GetFullName().." from "..tostring(start))
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
local loaded = 0
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

--Load hooks immediately
local originalNamecall = nil
local getgenv = getgenv
local debFunct, traceback, tskWait, coroYield = C.DebugMessage, debug.traceback, task.wait, coroutine.yield
local yieldForeverFunct
function yieldForeverFunct()
	debFunct("AntiCheat","Yielding Forever")
	--tskWait(highestNum)
	--while true do
	coroYield()--Yields the thread forever
	--end

	warn(traceback(`YIELDING COMPLETE!? THIS IS NOT SUPPOSED TO HAPPEN. PLEASE CHECCK C.yieldForeverFunct`))
	yieldForeverFunct() -- Run it again sucker!
end
C.yieldForeverFunct = yieldForeverFunct
C.getgenv().SavedHookData = C.getgenv().SavedHookData or {}
function C.HookMethod(hook, name, runFunct, methods)
	if C.isStudio or (not C.getgenv().SavedHookData[hook] and not runFunct) then
		return
	end
	if not C.getgenv().SavedHookData[hook] then
		-- Hook the namecall function
		local checkcaller = C.checkcaller
		local gsub = string.gsub
		local getVal, setVal = rawget, rawset
		local getcallingscript,getnamecallmethod,lower,tblFind,tblPack,tblUnpack = C.getcallingscript,getnamecallmethod,string.lower,table.find,table.pack,unpack

		local myHooks = {}
		C.getgenv().SavedHookData[hook] = myHooks

		local HookType = (typeof(hook)=="string" and "hookmetamethod") or
			(typeof(hook)=="function" and "hookfunction")

		assert(hookfunction,`[C.HookMethod]: Unknown HookType: {hook}!`)

		local OriginFunct
		local function CallFunction(self,...)
			 -- Check if the caller is not a local script
			 if not checkcaller() then
                -- Get the method being called
				local method = getnamecallmethod() or ...
				if method then
					method = gsub(lower(method), "\000.*", "") -- Remove trailing characters, so no shananigans
				end
                local theirScript = getcallingscript()
				if tostring(theirScript) == "BAC_" then
					C.DebugMessage()
					if hook == "__index" then
						return yieldForeverFunct -- Return the function to run forever haha!!
					else
						return yieldForeverFunct()
					end
				end--]]
                -- Block FireServer or InvokeServer methods
                for name, list in pairs(myHooks) do
					local indexes = getVal(list,2)
                    if not indexes or tblFind(indexes,method) then -- Authorization
                        local operation,returnData = getVal(list,3)(theirScript,method,self,...)
                        if operation then
                            if operation == "Spoof" then
                                return tblUnpack(returnData)
							elseif operation == "Override" then
								return OriginFunct(self,tblUnpack(returnData))
							elseif operation == "FireSeperate" then
								return task.delay(.1,self[method],self,tblUnpack(returnData))
                            elseif operation == "Cancel" then
                                return -- Cancelled
                            elseif operation == "Yield" then
								if hook == "__index" then
									return yieldForeverFunct -- Return the function to run forever haha!!
								else
									return yieldForeverFunct()
								end
                            else
                                warn(`[C.{HookType}]: Unknown Operation for {name}: {operation}. Letting Remote Run!`)
                            end
                        end
                    end
                end
            end
			return OriginFunct(self,...)
		end
        OriginFunct = (HookType == "hookmetamethod" and C.hookmetamethod(game, hook, (CallFunction)))
			or (HookType == "hookfunction" and C.hookfunction(hook, (CallFunction)))
	end
	if runFunct then
		C.getgenv().SavedHookData[hook][name] = {name,methods,runFunct}
	else
		C.getgenv().SavedHookData[hook][name] = nil
	end
end
--[[function C.HookNamecall(name,methods,runFunct)
	error"SHOULDN't be running"
	if C.isStudio or (not C.getgenv().NamecallHooks and not methods) then
		return
	end
    if not C.getgenv().NamecallHooks then
		warn("STARTING HOOKNAMECALL (should only happen once)")
        -- Hook the namecall function
		local checkcaller = C.checkcaller
        local getcallingscript,getnamecallmethod,lower,tblFind,tblPack,tblUnpack = C.getcallingscript,getnamecallmethod,string.lower,table.find,table.pack,table.unpack

		local myHooks = {}
        C.getgenv().NamecallHooks = myHooks
        originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            -- Check if the caller is not a local script
            if not checkcaller() and self.Name ~= "CharacterSoundEvent" then
                -- Get the method being called
                local method = lower(getnamecallmethod())
                local theirScript = getcallingscript()
                -- Block FireServer or InvokeServer methods
                for name, list in pairs(myHooks) do
                    if tblFind(list[1],method) then -- Authorization
                        local operation,returnData = list[2](theirScript,method,self,...)
                        if operation then
                            if operation == "Override" then
                                return tblUnpack(returnData)
                            elseif operation == "Cancel" then
                                return
                            elseif operation == "Yield" then
                                C.yieldForeverFunct()
								warn("[C.HookNameCall:] YIELDING COMPLETE!?")
								return
                            else
                                warn(`[C.HookNameCall]: Unknown Operation for {name}: {operation}. Letting Remote Run!`)
                            end
                        end
                    end
                end
            end

            -- If the caller is a local script, call the original namecall method
            return originalNamecall(self, ...)
        end))
    end
    if methods then
        C.getgenv().NamecallHooks[name] = {methods,runFunct}
    else
        C.getgenv().NamecallHooks[name] = nil
    end
end
function C.HookFunction(name,orgFunct,runFunct)
	C.getgenv().FunctionHooks = C.getgenv().FunctionHooks or {}
	if C.isStudio or (not C.getgenv().FunctionHooks[orgFunct] and not runFunct) then
		return
	end
    if not C.getgenv().FunctionHooks[orgFunct] then
		warn("STARTING FUNCTIONCALL FOR FUNCT (should only happen once per function)")
        -- Hook the namecall function
		local checkcaller = C.checkcaller
        local getcallingscript,getnamecallmethod,lower,tblFind,tblPack,tblUnpack = C.getcallingscript,getnamecallmethod,string.lower,table.find,table.pack,table.unpack

		local myHooks = {}
        C.getgenv().FunctionHooks[orgFunct] = myHooks
        originalNamecall = C.hookfunction(orgFunct, function(self, ...)
            -- Check if the caller is not a local script
            if not checkcaller() then
                -- Get the method being called
                local theirScript = getcallingscript()
                -- Block FireServer or InvokeServer methods
                for name, list in pairs(myHooks) do
					local operation,returnData = list[1](theirScript,self,...)
					if operation then
						if operation == "Override" then
							return tblUnpack(returnData)
						elseif operation == "Cancel" then
							return
						elseif operation == "Yield" then
							C.yieldForeverFunct()
							warn("[C.HookFunction:] YIELDING COMPLETE!?")
							return
						else
							warn(`[C.HookFunction]: Unknown Operation for {name}: {operation}. Letting Remote Run!`)
						end
                    end
                end
            end

            -- If the caller is a local script, call the original namecall method
            return originalNamecall(self, ...)
        end)
    end
    if runFunct then
        C.getgenv().FunctionHooks[orgFunct][name] = {runFunct}
    else
        C.getgenv().FunctionHooks[orgFunct][name] = nil
    end
end--]]

--Load AntiCheat Immediately!
C.LoadModule("AntiCheat")
return C.LoadModule("CoreLoader")