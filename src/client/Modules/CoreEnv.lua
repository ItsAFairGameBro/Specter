local CS = game:GetService("CollectionService")
local HS = game:GetService("HttpService")
local RunS = game:GetService("RunService")
local TCS = game:GetService("TextChatService")
local SG = game:GetService("StarterGui")
return function(C,Settings)
	function C.API(service,method,tries,...)
		tries = tries or 3
		local success, result
		while (tries > 0 or tries == -1) and not success do
			if method then
				success, result = pcall(service[method],service,...)
			else
				success, result = pcall(service,...)
			end
			if not success then
				C.AddNotification("API Failed",`{tostring(method)} from service {tostring(service)} has failed!\nTries: {tries<0 and "inf" or tries}`)
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
		C.DoActivate(hackTbl.Activate,hackTbl,hackTbl.EnTbl.En)
	end
	function C.DoActivate(funct,self,...)
		self:ClearData()
		funct(self,...)
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
		local profileName = C.getgenv().ProfileName
		if not C.readfile or not C.writefile or profileName == "" then
			if Settings.Deb.Save then
				print("Save Stopped, profileName: "..tostring(profileName))
			end
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
			local EncodedSaveDict2 = HS:JSONEncode({Settings = C.enHacks.Settings})
			--General Storage Folder Link

			--Save files
			C.writefile(FilePath,EncodedSaveDict)
			C.writefile(FilePath2,EncodedSaveDict2)
		end
		local success, result = C.API(internallySaveProfile,nil,1)
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
			end
			if not C.isfile(path) then
				if Settings.Deb.Save then
					C.AddNotification(`{path} Profile Not Found`,`The profile named "{path}" was not found in your workspace folder.`)
				end
				if not C.isStudio then
					C.getgenv().ProfileName = "Default"
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
		if success then
			C.getgenv().ProfileName = profileName
			if not C.StartUp then
				C:ReloadStates()
			end
		elseif not success then
			C.AddNotification(`Profile Load Error`,`Loading {profileName} failed: {result}`)
		end
		return success, result
	end
	--Chat
	function C.CreateSysMessage(message,color,typeText)
		if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
			(TCS:FindFirstChild("RBXGeneral",true) or TCS:FindFirstChildWhichIsA("TextChannel",true)):DisplaySystemMessage(message)
		else
			SG:SetCore("ChatMakeSystemMessage",  { Text = `[{typeText or "Sys"}] {message}`, Color = color or Color3.fromRGB(255), 
				Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size24 } )
		end
	end
	--Yieldable Handler
	function C.RunFunctionWithYield(func, args, timeout)
		--RunFunc((Function)func, (Table)args, (Number)timeout)
	
		local bindableEvent = Instance.new("BindableEvent")
		bindableEvent:AddTag("RemoveOnDestroy")
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
	--Destroy Function
	function C:Destroy()
		assert(C==self, "C is not the called function")
		-- It is cleared
		C.Cleared = true

		-- First, undo the connections
		C.ClearFunctTbl(C.functs)

		local RemoveOnDestroyIndex = 0

		for category, groupedTabData in pairs(C.hackData) do
			for num, hackTbl in pairs(groupedTabData) do
				if hackTbl.ClearData then -- This function is empty when the game has not loaded!
					hackTbl:ClearData()
				end
				if hackTbl.RunOnDestroy and hackTbl.Enabled then
					RemoveOnDestroyIndex += 1
					task.spawn(function()
						hackTbl:RunOnDestroy()
						RemoveOnDestroyIndex -= 1
					end)
				end
			end
		end

		for name, commandData in pairs(C.CommandFunctions) do
			if commandData.RunOnDestroy then
				RemoveOnDestroyIndex += 1
				task.spawn(function()
					commandData:RunOnDestroy()
					RemoveOnDestroyIndex -= 1
				end)
			end
		end
		
		for actionName, hackTbl in pairs(C.BindedActions) do
			C.UnbindAction(actionName)
		end

		for key, dict in pairs(C.playerfuncts) do
			C.ClearFunctTbl(dict)
		end

		for key, dict in pairs(C.objectfuncts) do
			C.ClearFunctTbl(dict,true)
		end

		-- Then, destroy everything
		RunS:UnbindFromRenderStep("Follow"..C.SaveIndex)
		RunS:UnbindFromRenderStep("Spin"..C.SaveIndex)
		
		for key, instance in ipairs(CS:GetTagged("RemoveOnDestroy")) do
			instance:Destroy()
		end

		if C.GUI then
			C.GUI:Destroy()
			C.GUI = nil
		end

		while RemoveOnDestroyIndex > 0 do
			task.wait() -- Wait while being destroyed
		end
		
		C.TblRemove(C.getgenv().Instances,C.SaveIndex or -1)
		RunS.RenderStepped:Wait()
		C.getgenv().DestroyEvent:Fire()
		
		if C.isStudio then
			script.Parent.Parent:Destroy()
		end
	end
	
	C.SaveIndex = (C.getgenv().SpecterIndex or 0)+1
	C.getgenv().SpecterIndex = C.SaveIndex

	table.insert(C.getgenv().Instances,C.SaveIndex)
	C.AddGlobalConnection(C.getgenv().CreateEvent.Event:Connect(function(SaveIndex)
		if C.SaveIndex == SaveIndex then
			return -- our signal sent this!
		end
		C:Destroy()
	end))
	if C.getgenv().CreateEvent then
		while #C.getgenv().Instances>1 do
			C.getgenv().CreateEvent:Fire(C.SaveIndex)
			C.getgenv().DestroyEvent.Event:Wait()
			RunS.RenderStepped:Wait()
			if #C.getgenv().Instances>1 then
				print("Still waiting for instances to be deleted!")
			end
		end
	else
		C.getgenv().CreateEvent = Instance.new("BindableEvent")
		C.getgenv().DestroyEvent = Instance.new("BindableEvent")
		C.getgenv().Instances = {}
	end
	
end
