local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
return function(C,Settings)
	return {
		Category = {
			Name = "Utility",
			Title = "Utility",
			Image = 6953984446,
			Layout = 5,
		},
		Tab = {
			{
				Title = "Anti Afk",
				Tooltip = "Prevents you from being idle kicked after 20m",
				Layout = 100,
				Shortcut = "AntiAfk",Functs={},Default=true,
                Update = function()
					if C.isStudio then
						return
					end
					VU:CaptureController()
                    VU:ClickButton2(Vector2.new())
                end,
				Activate = function(self,newValue)
                    if not newValue then
                        return
                    end
                    table.insert(self.Functs, C.plr.Idled:Connect(self.Update))
				end,
                Events = {},
				Options = {},
			},
			{
				Title = "Chat",Type="NoToggle",
				Tooltip = "Simulates the chat key press",
				Layout = 99,
				Shortcut = "Chat",Keybind="Slash",
				Activate = function(self,newValue)
					if TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
						local ChatBar = C.StringWait(C.PlayerGui,"Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar")
						ChatBar:CaptureFocus()
						task.wait()
						ChatBar:ReleaseFocus()
						task.wait(.4)
						ChatBar:CaptureFocus()
					else
						C.AddNotification("Unsupported Chat","This game uses a newer TCS version, so it is currently unusable.")
					end
				end,
                Events = {},
				Options = {},
			},
			{
				Title = "Client/Mobile Improvements",
				Tooltip = "Many Client Improvement Settings can be found here!",
				Layout = 103,
				Shortcut = "ClientImprovement",Functs={},Default=true,
				SetAutoJump = function(self)
					if C.human then
						C.human.AutoJumpEnabled = (not self.EnTbl.En or not self.EnTbl.PreventAutoJump) and UIS.TouchEnabled and C.Defaults.AutoJumpEnabled
					end
				end,
				Activate = function(self,newValue)
					local EnTbl = self.EnTbl.En and self.EnTbl.En or {}
					--Disable TouchGui
					if UIS.TouchEnabled then
						local ContextActionGui = C.PlayerGui:WaitForChild("ContextActionGui")
						local TouchGui = C.PlayerGui:WaitForChild("TouchGui");
						local TouchGui2 = C.gameName == "FlagWars" and C.PlayerGui:WaitForChild("Mobile UI")
						local function updateTouchScreenEnability()
							TouchGui.Enabled = not EnTbl.DisableTouchGUI
							ContextActionGui.Enabled = not EnTbl.DisableTouchGUI
							if TouchGui2 then
								TouchGui2.Enabled = not EnTbl.DisableTouchGUI
							end
						end
						if EnTbl.DisableTouchGUI then
							table.insert(self.Functs,TouchGui:GetPropertyChangedSignal("Enabled"):Connect(updateTouchScreenEnability))
							table.insert(self.Functs,ContextActionGui:GetPropertyChangedSignal("Enabled"):Connect(updateTouchScreenEnability))
							if TouchGui2 then
								table.insert(self.Functs,TouchGui2:GetPropertyChangedSignal("Enabled"):Connect(updateTouchScreenEnability))
							end	
						end
						updateTouchScreenEnability()	
					end
					--Lock Camera Orientation
					local function UpdateCamera()
						local Camera = workspace.CurrentCamera
						if Camera then
							local newCameraType = Camera.CameraType
							if newCameraType == Enum.CameraType.Custom and EnTbl.LockCamera then
								Camera.CameraType = Enum.CameraType.Track
							elseif newCameraType == Enum.CameraType.Track and not EnTbl.LockCamera then
								Camera.CameraType = Enum.CameraType.Custom
							end
						end
					end
					table.insert(self.Functs,workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(UpdateCamera))
					UpdateCamera()
					
					self:SetAutoJump()
				end,
                Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						print("New char",theirPlr.Name,firstRun)
						self:SetAutoJump()
						--C.DoActivate(self.Activate,self,self.EnTbl.En)
					end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Disable TouchGui",
						Tooltip = "Whether or not to show TouchGui (useful for PC users)",
						Layout = 3,Default=true,
						Shortcut="DisableTouchGUI",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Lock Camera Orientation",
						Tooltip = "Prevents the camera from being rotated when the character moves",
						Layout = 2,Default=true,
						Shortcut="LockCamera",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Disable Autojump",
						Tooltip = "Prevents the character from jumping when an object is near",
						Layout = 1,Default=true,
						Shortcut="PreventAutoJump",
						Activate = C.ReloadHack,
					},
				},
			},
		}
		
	}
end
