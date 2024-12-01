--[[
EXECUTES THIS SCRIPT:


loadstring(game:HttpGet("https://raw.githubusercontent.com/ItsAFairGameBro/Specter/main/src/shared/Shared.lua"))()

--]]
--SCRIPT GITHUB LINK:
local gitType = "blob" -- use 'blob' for more recent updates, or 'raw' for more consistency/loading speed
local githubLink = "https://github.com/ItsAFairGameBro/Specter/blob/main/src/client/full_code.lua"--paste your script here

--GLOBAL SETTINGS DATA:
GlobalSettings = {
	botModeEnabled = true, -- Whether or not you are using the bots to grind (select accounts only)
	isTeleportingAllowed = true, -- Whether or not teleporting is allowed in the game!
	enHacks = {}, -- The shortcut of the hack and what it defaults to!
	--add more here!
}

local RunS = game:GetService("RunService")
local HS = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")

local PrintName = "[Script Loader]"
local IsStudio = RunS:IsStudio()

local requestCaller = IsStudio and RS:WaitForChild("FakeHttpRequest") or game

local requestFunction = IsStudio and requestCaller.InvokeServer or game.HttpGet

function ReloadFunction()
	local StartTime = os.clock()
	GlobalSettings = GlobalSettings; -- refresh so that all caller functions can see this!
	local URL = githubLink:format(gitType:lower()):gsub("/raw/","/"..gitType:lower().."/"):gsub("/blob/","/"..gitType:lower().."/");
	local success, response = pcall(requestFunction,requestCaller,URL,false)

	if not success then
		return warn(PrintName.." Error Requesting Script: "..response)
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

	local Callback = compiledFunction()

	print(("%s %s Callback: %s (%.2fs)"):format(PrintName,scriptName or "Unknown",tostring(Callback) or "Exited Mysteriously",os.clock()-StartTime))
end

return task.spawn(ReloadFunction)
