local CS = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local HS = game:GetService("HttpService")
local RunS = game:GetService("RunService")
local TCS = game:GetService("TextChatService")
local PS = game:GetService("Players")
local SG = game:GetService("StarterGui")
return function(C,Settings)
    local Serializer = C.LoadModule("Modules/Serializer")
    C.getgenv().currentDesc = C.getgenv().currentDesc or {}
	function C.API(service,method,tries,...)
		assert(typeof(tries)=="number" or tries==nil,"[C.API]: Tries parameter must be a number")
		tries = tries or 3
		local success, result
		while (tries > 0 or tries == -1) and not success do
			if method then
				success, result = pcall(service[method],service,...)
			else
				success, result = pcall(service,...)
			end
			if not success then
				C.AddNotification("API Failed",`{tostring(method)} from service {tostring(service)} has failed: {tostring(result)}!\nTries: {tries<0 and "inf" or tries}`)
				warn(debug.traceback(`{tostring(method)} from service {tostring(service or "")} has failed: {tostring(result)}! Tries: {tries<0 and "inf" or tries}`))
			end
			tries -= 1
		end
		return success, result
	end
	local SettingsPath = "SpecterV2/Settings"
	local ProfileStoragePath = "SpecterV2/Profiles"
	local SaveFileExtention = ".json"
	local function CreateStoragePath(path)
		local previous = ""
		for num, addon in ipairs(ProfileStoragePath:split("/")) do
			local path = previous
			if path ~= "" then
				path ..= "/" .. addon
			else
				path ..= addon
			end
			if not C.isfolder(path) then
				C.makefolder(path)
			end
			previous = path
		end
	end
	function C.ReloadHack(hackTbl)
		--[[local oldEn = hackTbl.Enabled
		if oldEn then
			hackTbl:SetValue(false,true)
			hackTbl:SetValue(true,true)
		end--]]
		C.DoActivate(hackTbl,hackTbl.Activate,hackTbl.RealEnabled)
	end
	function C.DoActivate(self,funct,...)
        if self.Activate == funct then
            local firstRun = select(2,...)
            if not firstRun then
                self:ClearData()
            end
            if not firstRun and ... then -- check to see if true
                if C.SaveEvents and self.Events then
                    for key, eventFunct in pairs(self.Events) do
                        local eventList = C.SaveEvents[key:gsub("Added","")]
                        if eventList then
                            for _, eventData in ipairs(eventList) do
                                C.DoActivate(self,eventFunct,table.unpack(eventData))
                            end
                        end
                    end
                end
            end
        else
            --self:ClearData()
        end
        if not funct then
            if self.Activate ~= funct then
                warn(`[C.DoActivate]: Non activate function being ignored because it does not exist for {self.Shortcut}: `,self)
            end
            return
        end

		local header = "Hack/"..self.Parent.Category.Name.."/"..self.Shortcut
		if self.Type == "OneRun" then
			if not self.RealEnabled then
				self:FlashLabel(self.DisableAttemptMsg or "Cannot Disable",Color3.fromRGB(255))
				return
			elseif C.getgenv()[header] then
				-- Do nothing lol
				return
			end
			C.getgenv()[header] = true
		end
		local Thread = task.spawn(funct,self,...)
		if self.Threads then
			table.insert(self.Threads,Thread)
		end
	end
	function C:ReloadStates()
		for name, groupedTabData in pairs(C.hackData) do
			for shortcut, hackTbl in pairs(groupedTabData) do
				local EnDict = C.enHacks[name][shortcut]
				hackTbl:SetValue(EnDict.En)
				hackTbl:SetKeybind(EnDict.Keybind and Enum.KeyCode[EnDict.Keybind] or nil)
				for num, optionData in ipairs(hackTbl.Options) do
					optionData:SetValue(EnDict[optionData.Shortcut])
				end
			end
		end
	end
	function C:SaveProfile()
		if self ~= C then
			error("Invalid SaveProfile Call: must use `:` but only used `.`")
		end
		local profileName = C.getgenv().ProfileId
		if not C.readfile or not C.writefile or profileName == "" then
			C.DebugMessage("SaveSystem","Save Stopped, profileName: "..(profileName or "nil"))
			return
		end
		local function internallySaveProfile()
			local FilePath = ProfileStoragePath .. "/" .. profileName .. SaveFileExtention
			local FilePath2 = SettingsPath .. SaveFileExtention
			-- Create the data as a table
			local SaveDict = {
				Hacks = table.clone(C.enHacks)
			}
			SaveDict.Hacks.Settings = nil
			-- Encode the data
			local EncodedSaveDict = HS:JSONEncode(SaveDict)
			-- Storage Folder Link
			CreateStoragePath(ProfileStoragePath)

			--Store general settings
			if not C.getgenv().PreviousServers then
				C.getgenv().PreviousServers = {}
			end
			do -- Private server detection, cannot join any other servers! EDIT: CANNOT ACCESS FROM CLIENT
				local PreviousServers = C.getgenv().PreviousServers
				--if #PreviousServers == 0 or PreviousServers[1].JobId ~= game.JobId or PreviousServers[1].PlaceId ~= game.PlaceId then
				for index = #PreviousServers, 1, -1 do
					local data = PreviousServers[index]
					local shouldDestroy = (data.JobId == game.JobId and data.PlaceId == game.PlaceId and data.GameId == game.GameId)
						or (os.time() - data.Time > Settings.ServerSaveDeleteTime)
					if shouldDestroy then
						table.remove(PreviousServers,index)
					end
				end
				local PlayerCount = #PS:GetPlayers()
				if PlayerCount >= 1 then
					table.insert(PreviousServers,1,{
						PlaceId = game.PlaceId,
						JobId = game.JobId,
						GameId = game.GameId,
						Time = os.time(),
						Players = PlayerCount,
						MaxPlayers = PS.MaxPlayers,
						Name = C.getgenv().PlaceName,
					})
				end

			--[[else
					C.getgenv().PreviousServers[1].Time = os.time() -- Update time
					C.getgenv().PreviousServers[1].Players = #PS:GetPlayers() -- Update players
				end--]]
			end
            local MorphsData
            MorphsData = C.getgenv().serializedDesc or {}


			local EncodedSaveDict2 = HS:JSONEncode({
				Settings = C.enHacks.Settings,
				Servers = C.getgenv().PreviousServers,
                MorphData = MorphsData
			})
			--General Storage Folder Link

			--Save files
			C.writefile(FilePath,EncodedSaveDict)
			C.writefile(FilePath2,EncodedSaveDict2)
		end
		local success, result = C.API(internallySaveProfile,nil,1)
		C.DebugMessage("SaveSystem",`{tostring(success)}: {tostring(result)}`)
		if not success then
			C.AddNotification(`Profile Save Error`,`Saving {profileName} failed: {result}`)
		end
		return success, result
	end
	function C:LoadProfile(profileName:string)
		if not C.readfile or not C.writefile then
			C.AddNotification("Profiles Not Supported","Your exploit engine does not support readfile/writefile, meaning saved profiles cannot save/load!")
			return
		end
		local function internallyLoadProfile()
			C.enHacks = C.enHacks or {}
			local path = ProfileStoragePath .. "/" .. profileName .. SaveFileExtention
			local path2 = SettingsPath .. SaveFileExtention
			if C.isfile(path2) then
				local rawFile2 = C.readfile(path2)
				local decoded2 = HS:JSONDecode(rawFile2)
				C.enHacks.Settings = decoded2.Settings
				C.getgenv().PreviousServers = decoded2.Servers
                for userName, encodedData in pairs(decoded2.MorphData or {}) do
                    if userName ~= "new" then
                        C.getgenv().currentDesc[userName] = Serializer.deserialize(encodedData)
                    else
                        C.getgenv().JoinPlayerMorphDesc = Serializer.deserialize(encodedData)
                    end
                end
                C.getgenv().serializedDesc = decoded2.MorphData or {}
                C.getgenv().MorphEnabled = C.getgenv().MorphEnabled or (decoded2.MorphData and C.GetDictLength(decoded2.MorphData) > 0)
			end
			if not C.isfile(path) then
				C.DebugMessage("SaveSystem",`{path} Profile Not Found`,`The profile named "{path}" was not found in your workspace folder.`)
				if not C.isStudio then
					C.getgenv().ProfileId = "Default"
				end
				return
			end
			local rawFile = C.readfile(path)
			local decoded = HS:JSONDecode(rawFile)
			for key, val in pairs(decoded.Hacks) do
				C.enHacks[key] = val
			end


		end
		local success, result = C.API(internallyLoadProfile,nil,1)
		C.DebugMessage("SaveSystem",`Result: {tostring(success)}; {tostring(result)}`)
		if success then
			C.getgenv().ProfileId = profileName
			C.DebugMessage("SaveSystem",`Set: ProfileId to {profileName} aka {C.getgenv().ProfileId}`)
			if not C.StartUp then
				C:ReloadStates()
			end
		elseif not success then
			C.AddNotification(`Profile Load Error`,`Loading Profile {profileName} failed: {result}`)
			C.DebugMessage("SaveSystem",`Loading Profile {profileName} failed: {result}`)
		end
		return success, result
	end
	function C:StartAutoSave()
		local AutoSaveEvent = Instance.new("BindableEvent")
		local LastMenuSave
		C.AddGlobalConnection(GuiService.MenuOpened:Connect(function()
			if not LastMenuSave or os.clock() - LastMenuSave > 10 then
				LastMenuSave = os.clock()
				AutoSaveEvent:Fire("MenuOpened")
			end
		end))
		C.AddGlobalInstance(AutoSaveEvent)
		while not C.Cleared do
			local IsWaiting = true
			task.delay(60, function()
				if IsWaiting and AutoSaveEvent then
					AutoSaveEvent:Fire("Timeout")
				end
			end)
			local Reason = AutoSaveEvent.Event:Wait()
			IsWaiting = false
			if C.Cleared then
				return
			end
			C:SaveProfile()
		end
	end
	--Chat
	function C.CreateSysMessage(message,color,typeText)
		if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
			(TCS:FindFirstChild("RBXGeneral",true) or TCS:FindFirstChildWhichIsA("TextChannel",true)):DisplaySystemMessage(message)
		else
            typeText = typeText and ("[" .. typeText .. "]:") or "{Sys}"
			SG:SetCore("ChatMakeSystemMessage",  { Text = `{typeText} {message}`, Color = color or Color3.fromRGB(255),
				Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size24 } )
		end
	end
	--Yieldable Handler
	function C.RunFunctionWithYield(func, args, timeout)
		--RunFunc((Function)func, (Table)args, (Number)timeout)

		local bindableEvent = Instance.new("BindableEvent")
		C.AddGlobalInstance(bindableEvent)
		local response
		local success = false

		-- Coroutine to call the function
		task.spawn(function()
			local functionResult
			success, functionResult = pcall(function()
				if args then
					return func(unpack(args))
				else
					return func()
				end
			end)
			bindableEvent:Fire(success, functionResult)
		end)

		-- Timer for the timeout
		task.delay(timeout, function()
			if not bindableEvent then
				return
			end
			bindableEvent:Fire(false, "Function call timed out")
		end)

		-- Wait for either the function to complete or the timeout
		local success, result = bindableEvent.Event:Wait()
		bindableEvent:Destroy()

		return success, result
	end
	--Destroy Handler
	function C.ClearTagTraces(tagName:string)
		for num, tagInstance in ipairs(CS:GetTagged(tagName)) do
			tagInstance:RemoveTag(tagName)
		end
	end
	--Destroy Function
	function C:Destroy()
		assert(C==self, "C is not the called function")
		assert(not C.Cleared, `SaveIndex {C.SaveIndex} is already cleared / being destroyed!`)
		C.DebugMessage("Destroy",`Destroy Start`)
		-- It is cleared
		C.Cleared = true
		C.TblRemove(C.getgenv().Instances,C.SaveIndex or -1)

		-- First, undo the connections
		C.ClearThreadTbl(C.threads)
		C.ClearFunctTbl(C.functs)

		C.DebugMessage("Destroy",`Destroy 1`)

		local RemoveOnDestroyIndex = 0
		local ThingsToRemove = {}

		local function RunOnDestroy(hackTbl,name)
			local Identification = hackTbl.Shortcut or "cmd_unk"
			ThingsToRemove[Identification] = true
			RemoveOnDestroyIndex += 1
			task.spawn(function()
				local Done = false
				task.delay(3,function()
					if not Done then
						C.DebugMessage("Destroy", `RunOnDestroy: {name} is still running after 3 seconds!`)
					end
				end)
				hackTbl:RunOnDestroy()
				ThingsToRemove[Identification] = nil
				RemoveOnDestroyIndex -= 1
				Done = true
			end)
		end

		for category, groupedTabData in pairs(C.hackData) do
			for num, hackTbl in pairs(groupedTabData) do
				if hackTbl.ClearData then -- This function is empty when the game has not loaded!
					hackTbl:ClearData()
				end
				local ShouldDoRunOnDestroy = hackTbl.RunOnDestroy and hackTbl.RealEnabled
				hackTbl.Enabled, hackTbl.RealEnabled = false, false -- disable their enabled states!
				if ShouldDoRunOnDestroy then
					RunOnDestroy(hackTbl,"HackTBL: " .. hackTbl.Shortcut)
				end
			end
		end

		for name, commandData in pairs(C.CommandFunctions or {}) do
			if commandData.RunOnDestroy then
				RunOnDestroy(commandData,"CmdTBL: " .. name)
			end
		end

		C.DebugMessage("Destroy",`Destroy 2`)

		for instance, propertiesTbl in pairs(C.forcePropertyFuncts) do
			for attr, val in pairs(instance:GetAttributes()) do
				if attr:find("_Request_") or attr:find("_RequestCount") then
					--do nothing, it will be cleared
				elseif attr:find("_OriginalValue") then
					instance[attr:split("_")[1]] = val
					continue -- don't delete it...
				else
					continue -- everything else keep, prob important game stuff!
				end
				instance:SetAttribute(attr,nil)
			end
			for property, funct in pairs(propertiesTbl) do
				funct:Disconnect()
			end
		end C.forcePropertyFuncts = {} -- clear memory ig

		for actionName, hackTbl in pairs(C.BindedActions) do
			C.UnbindAction(actionName)
		end

		for key, dict in pairs(C.playerfuncts) do
			C.ClearFunctTbl(dict)
		end

		for key, dict in pairs(C.objectfuncts) do
			C.ClearFunctTbl(dict,true)
		end



		for instance, signalData in pairs(C.PartConnections) do
			for signal, data in pairs(signalData) do
				for key, enabled in pairs(data) do
					if key ~= "Value" and key ~= "Name" then
						--print("Attemping to disable",signal,data,key,enabled)
						C.SetInstanceConnections(instance,data.Name,key,true)
					end
				end
			end
		end

		-- Then, destroy everything
		RunS:UnbindFromRenderStep("Follow"..C.SaveIndex)
		RunS:UnbindFromRenderStep("Spin"..C.SaveIndex)
		if C.PurgeActionsWithTag then
			C.PurgeActionsWithTag("RemoveOnDestroy")
            for name, list in pairs(C.getgenv().ActionsList) do
                if list.Stop then
                    list.Stop()
                end
                list.Enabled = false
                list.ActionFrame = nil
                C.ClearThreadTbl(list.Threads)
            end
		end

		for key, instance in ipairs(CS:GetTagged("RemoveOnDestroy")) do
			instance:Destroy()
		end

		if C.GUI then
			C.GUI:Destroy()
			C.GUI = nil
		end

		C.DebugMessage("Destroy",`Destroy 3 / Waiting For RemoveOnDestroyIndex: {RemoveOnDestroyIndex}`)

		local theTime = 0

		while RemoveOnDestroyIndex > 0 do
			theTime+=task.wait() -- Wait while being destroyed
			if theTime > 10 then
				warn(`[C:Destroy]: It's been 10 seconds bro and I'm still waiting on RunOnDestroy functions: {RemoveOnDestroyIndex}`,ThingsToRemove)
				theTime = 0
			end
		end


		RunS.RenderStepped:Wait()
		C.getgenv().DestroyEvent:Fire()

		C.DebugMessage("Destroy",`Destroy Success`)

		if C.isStudio then
			script.Parent.Parent:Destroy()
		end
	end

	if not C.getgenv().Instances then
		C.getgenv().Instances = {}
	end

	if not C.getgenv().CreateEvent then
		C.getgenv().CreateEvent = Instance.new("BindableEvent")
		C.getgenv().DestroyEvent = Instance.new("BindableEvent")
	end

	C.AddGlobalConnection(C.getgenv().CreateEvent.Event:Connect(function(SaveIndex)
		C.DebugMessage("Destroy",`Destroy Called: {tostring(SaveIndex==C.SaveIndex)}`)
		if C.SaveIndex == SaveIndex then
			return -- our signal sent this!
		end
		C:Destroy()
	end))

	C.SaveIndex = (C.getgenv().SpecterIndex or 0)+1
	C.getgenv().SpecterIndex = C.SaveIndex

	table.insert(C.getgenv().Instances,C.SaveIndex)
	C.DebugMessage("Load",`Waiting To Load Starting`)
	local isWaiting = true
	task.delay(7,function()
		if not C.Cleared and isWaiting then
			C.getgenv().DestroyEvent:Fire(true)
		end
	end)
	while #C.getgenv().Instances>1 do
		if C.Cleared then
			return
		end
		C.DebugMessage("Load",`Waiting for destruction because SaveIndex={C.getgenv().Instances[1]}; {#C.getgenv().Instances-1} Extra Instance(s)`)
		task.spawn(C.getgenv().CreateEvent.Fire,C.getgenv().CreateEvent,C.SaveIndex)
		if C.getgenv().DestroyEvent.Event:Wait() == true then
			warn("Time out occured! Starting execution...")
			break
		end
		if #C.getgenv().Instances>1 then
			C.DebugMessage("Load",`Still waiting for instances to be deleted!`)
		end
	end
	C.DebugMessage("Load",`Waiting To Load Finished`)
	isWaiting = false
    task.spawn(function()
        C.writefile("SpecterV2.lua", `loadstring(game:HttpGet("https://raw.githubusercontent.com/ItsAFairGameBro/Specter/main/src/shared/Shared.lua"))()`)
    end)
end
