local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local ModulesToRun = {"Render","Blatant","World","Utility","Friends","Settings"}
local GamesWithModules = {
	--[6203382228] = {ModuleName="TestPlace"},
	[770538576] = {ModuleName="NavalWarefare",GameName="Naval Warefare"},
	[1069466626] = {ModuleName="PassBomb",GameName="Pass The Bomb"},
	[66654135] = {ModuleName="MurderMystery",GameName="Murder Mystery 2"},
	[1160789089] = {ModuleName = "FlagWars",GameName="Flag Wars"},
	[88070565] = {ModuleName = "Bloxburg", GameName = "Bloxburg"},
}
-- USE THIS API TO GET UNIVERSE IDs:
-- https://apis.roblox.com/universes/v1/places/PlaceId/universe

local KeybindRunFunct,BindButton

return function(C, _SETTINGS)
	--Load Locale Environment
	C.LoadModule('Env')
	if C.Cleared then return end
	--Load GUI Elements
	C.LoadModule('GuiElements')
	if C.Cleared then return end
	--Load Core Env
	C.LoadModule('CoreEnv')
	if C.SaveIndex == 1 then
		C:LoadProfile("Default")
		if C.Cleared then return end
	end
	if C.Cleared then return end
	--Load Binds and such
	C.LoadModule("Binds")
	--Load Current Profile, But Only If We're The First
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
		table.insert(ModulesToRun,""..GameModule)
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
	task.spawn(C.StartAutoSave,C)

	local ListOfElements = {}
	local function UpdateTextSize(ButtonEx,setUp: boolean)
		if setUp then
			table.insert(ListOfElements,ButtonEx)
		end
		ButtonEx.KeybindButton.Visible = UIS.KeyboardEnabled
		if ButtonEx.KeybindButton.Visible and not ButtonEx.HackExpand.Visible then
			ButtonEx.KeybindButton.Position = UDim2.new(0.991, 0, 0, 20)
		else
			ButtonEx.KeybindButton.Position = UDim2.new(0.841, 0, 0, 20)
		end
		local AdditionalOffset = 0
		AdditionalOffset += (ButtonEx.KeybindButton.Visible and 0 or ButtonEx.Size.X.Scale)
		AdditionalOffset += (ButtonEx.HackExpand.Visible and 0 or ButtonEx.HackExpand.Size.X.Scale)
		ButtonEx.HackText.Size = UDim2.new(0.65 + AdditionalOffset, 0, 0, 40)
	end

	for num, name in ipairs(ModulesToRun) do
		if C.Cleared then return end
		local isGame = GameModule == name

		local hack = C.LoadModule(isGame and "Games/"..name or "Hacks/"..name)
		local category = hack.Category
		local idName = category and category.Name or name


		local visible = false
		local enHackTab = C.enHacks[idName] or {}
		C.enHacks[idName] = enHackTab
		C.hackData[name] = {}

		local ScrollTab

		if category then
			-- Create the category button
			local CategoryEx = C.Examples.CategoryEx:Clone()
			local TabEx = C.Examples.TabEx:Clone()
			CategoryEx.LayoutOrder = (category.Layout + (category.AfterMisc and 50 or 0)) * 100
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
			TabEx.ZIndex = CategoryEx.LayoutOrder + 100
			C.UI.Tabs[category.Name] = TabEx
			
			task.spawn(C.MakeDraggableTab,TabEx,true)
		else
			ScrollTab = SettingsTab:WaitForChild("ScrollTab")
		end

		-- Load Individual Hacks
		for num, hackData in pairs(hack.Tab) do
			if not hackData or (C.isStudio and hackData.NoStudio) then
				continue
			end
			assert(hackData.Shortcut,`{hackData.Title} from {name} doesn't have a Shortcut identifer!`)
			assert(typeof(hackData.Layout)=="number",`{hackData.Title} from {name} has invalid .Layout property!`)
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
			local optionsUnused = table.clone(enTbl)
			optionsUnused.En = nil -- Delete, it's useless
			for num, optionData in ipairs(hackData.Options or {}) do
				optionData.Parent = hackData
				optionsUnused[optionData.Shortcut] = nil
				C.UI.Options[optionData.Type].new(ButtonEx,optionData)
			end
			--Extra Options Warning
			for opName, option in pairs(optionsUnused) do
				if opName == "En" or opName == "Keybind" then
					continue
				end
				warn(`{name}/{hackData.Shortcut}: {opName} is set to {option} but that option no longer exists. It has been deleted for memory`)
				enTbl[opName] = nil -- Remove the option
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
				if hackData.Threads then
					for num, thread in ipairs(hackData.Threads) do
						C.StopThread(thread)
					end hackData.Threads = {}
				end
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
			function hackData:FlashLabel(text,color)
				activatedDeb+=1
				local saveActivateDeb = activatedDeb
				MainText.Text = text
				MainText.TextColor3 = color
				task.delay(1,function()
					if activatedDeb ~= saveActivateDeb then
						return
					end
					MainText.Text = hackData.Title
					MainText.TextColor3 = Color3.fromRGB(255,255,255)
				end)
			end
			function hackData:SetValue(value,started)
				if value == hackData.Enabled or C.Cleared then
					return--no change, don't bother!
				end
				if value and hackData.Type == "NoToggle" then
					value = false
					if not started then
						hackData:FlashLabel("Activated!",Color3.fromRGB(0,255))
					end
				end
				hackData.Enabled = value
				if #hackData.Override==0 then
					hackData.RealEnabled = value
				end
				enTbl.En = value
				UpdateButtonColor()
				if C.Cleared then
					return
				end
				if hackData.Activate and not started then
					if started then
						--task.delay(0.3,hackData.Activate,hackData,hackData.Enabled,started)
					else
						C.DoActivate(hackData,hackData.Activate, hackData.RealEnabled, started)
					end
				end
			end
			hackData.Override = hackData.Override or {}
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
				--MainText.Size = UDim2.new(MainText.Size.X.Scale,KeybindButton.AbsoluteSize.X,0,MainText.Size.Y.Offset)
			end

			C.BindEvents(hackData)

			--Tooltip
			if hackData.Tooltip then
				C.TooltipSetUp(MainText,hackData.Tooltip)
			end

			UpdateTextSize(ButtonEx,true)
			
			ButtonEx.Parent = ScrollTab
		end
	end
	if C.Cleared then return end
	for name, modData in pairs(C.hackData) do
		for shortcut, data in pairs(modData) do
			if (data.RealEnabled or data.AlwaysActivate) and data.Activate and not data.DontActivate then
				task.spawn(data.Activate,data,data.RealEnabled, true)
			end
		end
	end
	for num, instance in ipairs(C.UI.TabsFrame:GetChildren()) do
		if instance:IsA("GuiBase") then
			for num, guiElement in ipairs(instance:GetDescendants()) do
				if guiElement:IsA("GuiBase") then
					guiElement.ZIndex -= instance.ZIndex
				end
			end
			instance.ZIndex -= instance.ZIndex * 2
		end
	end
	C.AddGlobalConnection(UIS:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function()
		for num, ListButtonEx in ipairs(ListOfElements) do
			UpdateTextSize(ListButtonEx)
		end
	end))
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
