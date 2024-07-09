local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local ModulesToRun = {"Render","Blatant","World","Utility","Friends"}
local GamesWithModules = {
	--[6203382228] = {ModuleName="TestPlace"},
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
	local SupportedFrame = SettingsTab:WaitForChild("SupportedFrame")
	--local success, result = C.API(game:GetService("MarketplaceService"), "GetProductInfo", 3, game.PlaceId)
	if ThisGameTbl then
		SupportedFrame:WaitForChild("Description").Text = `Specter supports this game`
		SupportedFrame:WaitForChild("Supported").Text = `Supported Game`
		table.insert(ModulesToRun,ThisGameTbl.ModuleName)
	else
		SupportedFrame:WaitForChild("Description").Text = `Specter DOES NOT support this game!`
		SupportedFrame:WaitForChild("Supported").Text = `Unsupported Game`
	end
	--if success then
	C.SetImage(SupportedFrame:WaitForChild("Image"),"https://www.roblox.com/Thumbs/Asset.ashx?Width=768&Height=432&AssetID="..game.PlaceId)
	--end

	C.ButtonClick(HeaderTab:WaitForChild("SettingsButton"),function()
		ButtonsTab.Visible = not ButtonsTab.Visible
		SettingsTab.Visible = not SettingsTab.Visible
	end)

	local SaveButton = ButtonsTab:WaitForChild("BottomFrame"):WaitForChild("SaveButton")
	local WaitButton = SaveButton:WaitForChild("Wait")

	local SaveDeb = false
	C.ButtonClick(SaveButton,function()
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
	end)

	for num, name in ipairs(ModulesToRun) do
		if C.Cleared then return end
		local hack = C.LoadModule("Hacks/"..name)
		local category = hack.Category
		local visible = false
		local enHackTab = C.enHacks[category.Name] or {}
		C.enHacks[category.Name] = enHackTab
		C.hackData[name] = {}
		-- Create the category button
		local CategoryEx = C.Examples.CategoryEx:Clone()
		local TabEx = C.Examples.TabEx:Clone()
		CategoryEx.LayoutOrder = category.Layout + (category.AfterMisc and 50 or 0)
		CategoryEx:WaitForChild("Text").Text = category.Title
		C.SetImage(CategoryEx:WaitForChild("Image"), 'rbxassetid://' .. category.Image)
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
		local ScrollTab = TabEx:WaitForChild("ScrollTab")
		HeaderTab:WaitForChild("Text").Text = category.Title
		C.SetImage(HeaderTab:WaitForChild("Image"),'rbxassetid://'..category.Image)
		TabEx.Position = UDim2.fromOffset(90 + 250 * (category.Layout),100)
		TabEx.Name = category.Name
		TabEx.Parent = C.UI.TabsFrame
		C.UI.Tabs[category.Name] = TabEx
		
		task.delay(1,C.MakeDraggableTab,TabEx,true)
		
		
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
			for num, optionData in ipairs(hackData.Options) do
				optionData.Parent = hackData
				C.UI.Options[optionData.Type].new(ButtonEx,optionData)
			end			
			--Expand Button
			local ViewSettingsVisible = true
			if #hackData.Options == 0 then
				HackExpand.Visible = false
				ViewSettingsVisible = false
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
			local function UpdateButtonColor(started:boolean)
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
				if value == hackData.Enabled then
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
				if hackData.Activate and (not started or hackData.Type ~= "NoToggle") then
					hackData.Activate(hackData,hackData.Enabled)
				end
			end
			C.ButtonClick(MainText,function()
				hackData:SetValue(not hackData.Enabled)
			end)
			task.spawn(hackData.SetValue,hackData,enTbl.En==true, true)
			
			--Keybind
			local KeybindButton = ButtonEx:WaitForChild("KeybindButton")
			local BindedKey = KeybindButton:WaitForChild("BindedKey")
			function hackData:SetKeybind(key: Enum.KeyCode)
				if key then
					BindedKey.Text = key.Name
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
			C.BindEvents(hackData)

			--Tooltip
			if hackData.Tooltip then
				C.TooltipSetUp(MainText,hackData.Tooltip)
			end
			
			ButtonEx.Parent = ScrollTab
		end
	end
	if C.Cleared then return end

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
