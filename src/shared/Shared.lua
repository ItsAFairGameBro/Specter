--[[
EXECUTES THIS SCRIPT:


loadstring(game:HttpGet("https://raw.githubusercontent.com/ItsAFairGameBro/Specter/main/src/shared/Shared.lua"))()

--]]
--SCRIPT GITHUB LINK:
local githubLink = "https://raw.githubusercontent.com/ItsAFairGameBro/Specter/main/src/client/full_code.lua"--paste your script here

--GLOBAL SETTINGS DATA:
GlobalSettings = {
	botModeEnabled = true, -- Whether or not you are using the bots to grind (select accounts only)
	isTeleportingAllowed = true, -- Whether or not teleporting is allowed in the game!
	enHacks = {}, -- The shortcut of the hack and what it defaults to!
	--add more here!
}

local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")

local PrintName = "[Script Loader]"
local IsStudio = RunS:IsStudio()

local requestCaller = IsStudio and RS:WaitForChild("FakeHttpRequest") or game

local requestFunction = IsStudio and requestCaller.InvokeServer or game.HttpGet

function ReloadFunction()
	local StartTime = os.clock()
	GlobalSettings = GlobalSettings; -- refresh so that all caller functions can see this!
	local URL = githubLink
	local success, response = pcall(requestFunction,requestCaller,URL,false)

	if not success then
		return warn(PrintName.." Error Requesting Script: "..response)
	end
    local scriptName = "Specter"
    local compiledFunction, compileError = loadstring(response)
    if not compiledFunction then
        return warn(PrintName .. " Error compiling script: " .. tostring(compileError))
    end

	local Callback = compiledFunction()

	print(("%s %s Callback: %s (%.2fs)"):format(PrintName,scriptName or "Unknown",tostring(Callback) or "Exited Mysteriously",os.clock()-StartTime))
end

return task.spawn(ReloadFunction)
