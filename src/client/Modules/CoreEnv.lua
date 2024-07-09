local CS = game:GetService("CollectionService")
local HS = game:GetService("HttpService")
local RunS = game:GetService("RunService")
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
		local profileName = C.ProfileName
		if not C.readfile or not C.writefile or profileName == "" then
			if Settings.Deb.Save then
				print("Save Stopped, profileName: "..tostring(profileName))
			end
			return
		end
		local function internallySaveProfile()
			local FilePath = ProfileStoragePath .. "/" .. profileName .. SaveFileExtention
			-- Create the data as a table
			local SaveDict = {
				Hacks = C.enHacks
			}
			-- Encode the data
			local EncodedSaveDict = HS:JSONEncode(SaveDict)
			-- Storage Folder Link
			CreateStoragePath(ProfileStoragePath)
			C.writefile(FilePath,EncodedSaveDict)
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
			local path = ProfileStoragePath .. "/" .. profileName .. SaveFileExtention
			if not C.isfile(path) then
				if Settings.Deb.Save then
					C.AddNotification(`{path} Profile Not Found`,`The profile named "{path}" was not found in your workspace folder.`)
				end
				if not C.isStudio then
					C.ProfileName = "Default"
				end
				return
			end
			local decoded = HS:JSONDecode(C.readfile(path))
			C.enHacks = decoded.Hacks
		end
		local success, result = C.API(internallyLoadProfile,nil,1)
		if success then
			C.ProfileName = profileName
			if not C.StartUp then
				C:ReloadStates()
			end
		elseif not success then
			C.AddNotification(`Profile Load Error`,`Loading {profileName} failed: {result}`)
		end
		return success, result
	end
	
	--Destroy Function
	function C:Destroy()
		assert(C==self, "C is not the called function")
		-- It is cleared
		C.Cleared = true

		-- First, undo the connections
		--C.ClearFunctTbl(C.functs)
		for category, groupedTabData in pairs(C.hackData) do
			for num, hackTbl in pairs(groupedTabData) do
				hackTbl:ClearData()
			end
		end
		
		for actionName, hackTbl in pairs(C.BindedActions) do
			C.UnbindAction(actionName)
		end

		C.ClearFunctTbl(C.functs)

		for key, dict in pairs(C.playerfuncts) do
			C.ClearFunctTbl(dict)
		end

		for key, dict in pairs(C.objectfuncts) do
			C.ClearFunctTbl(dict,true)
		end

		-- Then, destroy everything

		for key, instance in ipairs(CS:GetTagged("RemoveOnDestroy")) do
			instance:Destroy()
		end

		if C.GUI then
			C.GUI:Destroy()
			C.GUI = nil
		end
		
		C.TblRemove(C.getgenv().Instances,C.SaveIndex or -1)
		C.getgenv().DestroyEvent:Fire()
		
		if C.isStudio then
			script.Parent.Parent:Destroy()
		end
		print(C.SaveIndex.." Destroy!")
	end
	
	C.SaveIndex = (C.getgenv().SpecterIndex or 0)+1
	C.getgenv().SpecterIndex = C.SaveIndex
	if C.getgenv().CreateEvent then
		while #C.getgenv().Instances>0 do
			C.getgenv().CreateEvent:Fire()
			C.getgenv().DestroyEvent.Event:Wait()
			RunS.RenderStepped:Wait()
			if #C.getgenv().Instances>0 then
				print("Still waiting!")
			end
		end
	else
		C.getgenv().CreateEvent = Instance.new("BindableEvent")
		C.getgenv().DestroyEvent = Instance.new("BindableEvent")
		C.getgenv().Instances = {}
	end
	table.insert(C.getgenv().Instances,C.SaveIndex)
	C.AddGlobalConnection(C.getgenv().CreateEvent.Event:Connect(function()
		C:Destroy()
	end))
end
