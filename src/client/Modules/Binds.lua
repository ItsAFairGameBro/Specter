local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")
local TS = game:GetService("TweenService")
return function(C,Settings)
	--Binds idk
	C.BindedActions = {}
	function C.BindAction(name,funct,...)
		C.BindedActions[name] = true
		CAS:BindAction(name,funct,false,...)
	end
	function C.UnbindAction(name)
		C.BindedActions[name] = nil
		CAS:UnbindAction(name)
	end
	--Register Keybinds
	function C.AddKeybind(key:string,tblHack:table)
		C.RemoveKeybind(tblHack)
		local function keyPressBind(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.Begin and not C.IsBinding then
				tblHack:SetValue(not tblHack.Enabled)
			end
		end
		local name = "hack"..key.Name
		C.BindAction(name,keyPressBind,key)
		C.keybinds[tblHack] = {KeyCode = key, Name = name}
		C.enHacks[tblHack.Parent.Category.Name][tblHack.Shortcut].Keybind = key.Name
	end
	function C.RemoveKeybind(tblHack:table)
		local data = C.keybinds[tblHack]
		if data then
			C.UnbindAction(data.Name)
			C.keybinds[tblHack] = nil
			C.enHacks[tblHack.Parent.Category.Name][tblHack.Shortcut].Keybind = nil
		end
	end
	
	--Set Binds for UI
	local eventsAllowed={
		"MyCharAdded","CharAdded","OthersCharAdded",
		"MyPlayerAdded","PlayerAdded","OthersPlayerAdded"
	}
	function C.BindEvents(hackTbl)
		for name, funct in pairs(hackTbl.Events or {}) do
			assert(table.find(eventsAllowed,name),`{name} is not a valid event!`)
			C.events[name] = C.events[name] or {}
			C.events[name][hackTbl] = funct
		end
	end
	
	--Open HUD visibility
	C.UI.HUDEn = false
	function C.SetHUDVis(enabled,instant)
		C.UI.HUDEn = enabled
		C.UI.MainHUD.Visible = enabled
		C.UI.MainHUD.Active = enabled
		C.UI.MainHUD.Interactable = enabled
		TS:Create(C.UI.HUDBackgroundFade,TweenInfo.new(.3),{BackgroundTransparency=(enabled and 0.3 or 1)}):Play()
	end
	local function ToggleOpenHUDKeyPress(actionName,inputState)
		if inputState == Enum.UserInputState.Begin then
			C.SetHUDVis(not C.UI.HUDEn)
		end
	end
	C.BindAction("hackopen",ToggleOpenHUDKeyPress,Enum.KeyCode.RightShift)
	C.SetHUDVis(false,true)
	
	--Save keypress
	C.AddGlobalConnection(UIS.InputBegan:Connect(function(inputObject,gameProcessed)
		if gameProcessed then return end
		if inputObject.KeyCode == Enum.KeyCode.S and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			C.SaveProfile()
		end
	end))
	
	--Clear UI connection
	local function CheckDeleteButton(actionName,inputState)
		if inputState == Enum.UserInputState.Begin
			and (UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift)) then
			C:Destroy()
		end
	end
	C.BindAction("hackdelete",CheckDeleteButton,Enum.KeyCode.Delete)
end
