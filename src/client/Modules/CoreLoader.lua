local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local ModulesToRun = {"Render","Blatant","World","Utility","Friends","Settings"}
local GamesWithModules = {
	--[6203382228] = {ModuleName="TestPlace"},
	[770538576] = {ModuleName="NavalWarefare",GameName="Naval Warefare"}
}
-- USE THIS API TO GET UNIVERSE IDs:
-- https://apis.roblox.com/universes/v1/places/PlaceId/universe

local KeybindRunFunct,BindButton

return function(C, _SETTINGS)
	--Load Locale Environment
	C.LoadModule('Env')
	--Load Core Env
	C.LoadModule('CoreEnv')
	if C.Cleared then return end
	--Load GUI Elements
	C.LoadModule('GuiElements')
	if C.Cleared then return end
	--Load Binds and such
	C.LoadModule("Binds")
	--Load Current Profile, But Only If We're The First
	if C.SaveIndex == 1 then
		C:LoadProfile("Default")
		if C.Cleared then return end
	end
	--Load Category Buttons & Tabs
	C.UI.Tabs = {}
	local HeaderTab,ButtonsTab,SettingsTab = C.UI.CategoriesFrame:WaitForChild("HeaderTab"),
		C.UI.CategoriesFrame:WaitForChild("Buttons"),C.UI.CategoriesFrame:WaitForChild("Settings")
	local ThisGameTbl = GamesWithModules[game.GameId]
	local GameModule
	local SupportedFrame = SettingsTab:WaitForChild("SupportedFrame")
	local GameImage = "https://www.roblox.com/Thumbs/Asset.ashx?Width=768&Height=432&AssetID="..game.PlaceId
	if ThisGameTbl then
		SupportedFrame:WaitForChild("Description").Text = `Specter supports this game✅`
		SupportedFrame:WaitForChild("Supported").Text = `Supported Game`
		GameModule = ThisGameTbl.ModuleName
		table.insert(ModulesToRun,GameModule)
	else
		SupportedFrame:WaitForChild("Description").Text = `Specter DOES NOT support this game❌`
		SupportedFrame:WaitForChild("Supported").Text = `Unsupported Game`
	end
	--if success then
	C.SetImage(SupportedFrame:WaitForChild("Image"),GameImage)
	--end

	--Add developer settings
	if (C.enHacks.Settings and C.enHacks.Settings.DeveloperMode.En) or C.isStudio then
		table.insert(ModulesToRun,"Developer")
	end

	C.ButtonClick(HeaderTab:WaitForChild("SettingsButton"),function()
		ButtonsTab.Visible = not ButtonsTab.Visible
		SettingsTab.Visible = not SettingsTab.Visible
	end)

	local SettingsTab = C.UI.CategoriesFrame:WaitForChild("Settings")

	local BottomFrame = ButtonsTab:WaitForChild("BottomFrame")
	local SaveButton = BottomFrame:WaitForChild("SaveButton")
	local WaitButton = SaveButton:WaitForChild("Wait")

	local SaveDeb = false
	function C.DoSave()
		if SaveDeb then return end SaveDeb = true
		SaveButton.ImageColor3 = Color3.fromRGB(81,81,81)
		WaitButton.Visible = true
		WaitButton.Text = "•••"
		local success = C:SaveProfile()
		if success then
			WaitButton.Text = "✅"
			task.wait(3)
			WaitButton.Visible = false
		else
			WaitButton.Text = "❌"
		end
		task.wait(5)
		WaitButton.Visible = false
		SaveButton.ImageColor3 = Color3.fromRGB(255,255,255)
		SaveDeb = false
	end
	C.ButtonClick(SaveButton,C.DoSave)

	local RefreshButton = SettingsTab:WaitForChild("BottomFrame"):WaitForChild("RefreshButton")
	local AlreadyRefreshing = false
	function C.Refresh()
		if AlreadyRefreshing or C.isStudio then return end AlreadyRefreshing = true
		local LoopTween = TS:Create(RefreshButton,TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1),{Rotation=360})
		LoopTween:Play()
		task.spawn(loadstring(game:HttpGet("https://raw.githubusercontent.com/ItsAFairGameBro/Specter/main/src/shared/Shared.lua")))
		task.wait(5)
		if C.Cleared then
			return
		end
		LoopTween:Cancel()
		AlreadyRefreshing = false
	end
	C.ButtonClick(RefreshButton,C.Refresh)

	for num, name in ipairs(ModulesToRun) do
		if C.Cleared then return end
		local hack = C.LoadModule("Hacks/"..name)
		local category = hack.Category
		local idName = category and category.Name or name

		local isGame = GameModule == name

		local visible = false
		local enHackTab = C.enHacks[idName] or {}
		C.enHacks[idName] = enHackTab
		C.hackData[name] = {}

		local ScrollTab

		if category then
			-- Create the category button
			local CategoryEx = C.Examples.CategoryEx:Clone()
			local TabEx = C.Examples.TabEx:Clone()
			CategoryEx.LayoutOrder = category.Layout + (category.AfterMisc and 50 or 0)
			CategoryEx:WaitForChild("Text").Text = category.Title
			local UsableImage = category.Image and 'rbxassetid://' .. category.Image or GameImage
			C.SetImage(CategoryEx:WaitForChild("Image"), UsableImage)
			CategoryEx.Parent = ButtonsTab
			local function ToggleVisiblity()
				visible = not visible
				TS:Create(CategoryEx.Text,TweenInfo.new(.15),{TextColor3=visible and Color3.fromRGB(0,170) or Color3.fromRGB(255,255,255)}):Play()
				TS:Create(CategoryEx.Image,TweenInfo.new(.15),{ImageColor3=visible and Color3.fromRGB(0,170) or Color3.fromRGB(255,255,255)}):Play()
				TabEx.Visible = visible
			end
			C.ButtonClick(CategoryEx,ToggleVisiblity)
			ToggleVisiblity()
			-- Create the tab frame
			local HeaderTab = TabEx:WaitForChild("HeaderTab")
			ScrollTab = TabEx:WaitForChild("ScrollTab")
			HeaderTab:WaitForChild("Text").Text = category.Title
			C.SetImage(HeaderTab:WaitForChild("Image"),UsableImage)
			if GameModule == name then
				TabEx.Position = UDim2.fromOffset(250 * (4),100)
			elseif category.Layout < 4 then
				TabEx.Position = UDim2.fromOffset(250 * (category.Layout),100)
			else
				TabEx.Position = UDim2.fromOffset(250 + 500 * (category.Layout-4),300)
			end
			TabEx.Name = category.Name
			TabEx.Parent = C.UI.TabsFrame
			TabEx.ZIndex = CategoryEx.LayoutOrder
			C.UI.Tabs[category.Name] = TabEx
			
			task.spawn(C.MakeDraggableTab,TabEx,true)
		else
			ScrollTab = SettingsTab:WaitForChild("ScrollTab")
		end

		-- Load Individual Hacks
		for num, hackData in ipairs(hack.Tab) do
			assert(hackData.Shortcut,`{hackData.Title} from {name} doesn't have a Shortcut identifer!`)
			C.hackData[name][hackData.Shortcut] = hackData
			local ButtonEx = C.Examples.HackButtonEx:Clone()
			hackData.Button = ButtonEx
			hackData.Parent = hack
			--Basic Information
			local OptionsList = ButtonEx:WaitForChild("OptionsList")
			local MainText = ButtonEx:WaitForChild("HackText")
			local HackExpand = ButtonEx:WaitForChild("HackExpand")
			local KeybindButton = ButtonEx:WaitForChild("KeybindButton")
			ButtonEx.Name = hackData.Title
			ButtonEx.LayoutOrder = hackData.Layout
			MainText.Text = hackData.Title
			assert(hackData.Shortcut,`{hackData.Title} does't have a Shortcut`)
			local enTbl = enHackTab[hackData.Shortcut] or {}
			enHackTab[hackData.Shortcut] = enTbl
			hackData.EnTbl = enTbl
			if enTbl.En == nil and hackData.Default ~= nil then
				enTbl.En = hackData.Default
			end

			--Options Activation
			for num, optionData in ipairs(hackData.Options or {}) do
				optionData.Parent = hackData
				C.UI.Options[optionData.Type].new(ButtonEx,optionData)
			end
			--Three Dots Button
			local ViewSettingsVisible = true
			if not hackData.Options or #hackData.Options == 0 then
				HackExpand.Visible = false
				ViewSettingsVisible = false
				KeybindButton.Position = UDim2.new(1,0,0,KeybindButton.Position.Y.Offset)
			else
				local function UpdateViewSettings(Instant)
					ViewSettingsVisible = not ViewSettingsVisible
					OptionsList.Visible = ViewSettingsVisible --TS:Create(OptionsList,TweenInfo.new(Instant == true and 0 or .3),
					--	{Size=UDim2.new(1,0,0,(ViewSettingsVisible and OptionsList.AbsoluteSize.Y or 0))}):Play()
				end
				C.ButtonClick(HackExpand,UpdateViewSettings)
				UpdateViewSettings()
			end
			
			--Active Logic
			local HighlightBackground = ButtonEx:WaitForChild("HighlightBackground")
			local function UpdateButtonColor(started: boolean)
				TS:Create(HighlightBackground,TweenInfo.new(.1),
					{BackgroundTransparency=hackData.Enabled and 0.3 or 1}):Play()
			end
			function hackData:ClearData()
				if hackData.Instances then
					for num, inst in ipairs(hackData.Instances) do
						inst:Destroy()
					end hackData.Instances = {}
				end
				if hackData.Functs then
					C.ClearFunctTbl(hackData.Functs)
				end
			end
			local activatedDeb = 0
			function hackData:SetValue(value,started)
				if value == hackData.Enabled or C.Cleared then
					return--no change, don't bother!
				end
				if value and hackData.Type == "NoToggle" then
					value = false
					if not started then
						activatedDeb+=1
						local saveActivateDeb = activatedDeb
						MainText.Text = "Activated!"
						MainText.TextColor3 = Color3.fromRGB(0,255)
						task.delay(1,function()
							if activatedDeb ~= saveActivateDeb then
								return
							end
							MainText.Text = hackData.Title
							MainText.TextColor3 = Color3.fromRGB(255,255,255)
						end)
					end
				end
				hackData.Enabled = value
				enTbl.En = value
				UpdateButtonColor()
				if not value then
					hackData:ClearData()
				end
				if C.Cleared then
					return
				end
				if hackData.Activate and not started then
					if started then
						--task.delay(0.3,hackData.Activate,hackData,hackData.Enabled,started)
					else
						hackData:Activate(hackData.Enabled, started)
					end
				end
			end
			C.ButtonClick(MainText,function()
				hackData:SetValue(not hackData.Enabled)
			end)
			task.spawn(hackData.SetValue,hackData,enTbl.En==true, true)
			
			--Keybind
			if name ~= "Settings" then
				local BindedKey = KeybindButton:WaitForChild("BindedKey")
				function hackData:SetKeybind(key: Enum.KeyCode)
					if key then
						BindedKey.Text = key.Name:gsub("Slash","/")
						C.AddKeybind(key,hackData)
					else
						BindedKey.Text = ""
						C.RemoveKeybind(hackData)
					end
					C.IsBinding = false
				end
				local function KeybindClick(override)
					if KeybindRunFunct then
						C.RemoveGlobalConnection(KeybindRunFunct)
						KeybindRunFunct = nil
						BindButton.KeybindLabel.Visible = false
						BindButton.HighlightBackground.Visible = true
						if BindButton == ButtonEx and override ~= true then
							hackData:SetKeybind(nil)
						end
					end
					
					if BindButton ~= ButtonEx then
						BindButton = ButtonEx
						KeybindRunFunct = C.AddGlobalConnection(UIS.InputBegan:Connect(function(inputObject,gameProcessed)
							if inputObject.UserInputType == Enum.UserInputType.Keyboard then
								local key = inputObject.KeyCode
								hackData:SetKeybind(key)
								KeybindClick(true)
							end
						end))
						ButtonEx.KeybindLabel.Visible = true
						BindButton.HighlightBackground.Visible = false
						C.IsBinding = true
					else
						BindButton = nil
					end
				end
				
				hackData:SetKeybind((enTbl.Keybind and Enum.KeyCode[enTbl.Keybind])
					or (hackData.Keybind and Enum.KeyCode[hackData.Keybind]))
				C.ButtonClick(KeybindButton,KeybindClick)
			else
				KeybindButton.Visible = false
				MainText.Size = UDim2.new(MainText.Size.X.Scale,KeybindButton.AbsoluteSize.X,0,MainText.Size.Y.Offset)
			end

			C.BindEvents(hackData)

			--Tooltip
			if hackData.Tooltip then
				C.TooltipSetUp(MainText,hackData.Tooltip)
			end
			
			ButtonEx.Parent = ScrollTab
		end
	end
	if C.Cleared then return end
	for name, modData in pairs(C.hackData) do
		for shortcut, data in pairs(modData) do
			if data.Enabled and data.Activate then
				task.spawn(data.Activate,data,data.Enabled, true)
			end
		end
	end
	for num, instance in ipairs(ButtonsTab:GetChildren()) do
		for num, guiElement in ipairs(instance:GetDescendants()) do
			guiElement.ZIndex -= instance.ZIndex
		end
	end
	if C.Cleared then return end

	--Load Commands
	C.LoadModule("Hacks/Commands")
	C.LoadModule("CommandCore")

	--Load Events
	C.LoadModule("Events")
	if C.Cleared then return end
	
	--Make it appear
	C.GUI.Parent = C.gethui()
	
	C.MakeDraggableTab(C.UI.CategoriesFrame)

	
	C.AddNotification("Specter Loaded","Push RShift to open the UI")
	
	C.StartUp = nil
	if C.SaveIndex == 1 and C.isStudio then
		C.PlayerGui:WaitForChild("SpecterGUI"):Destroy()
	end
	
	return "Load Successful"
end
