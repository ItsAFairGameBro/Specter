local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local DS = game:GetService("Debris")
local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")
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
				Functs={},
				SlashPressedOld = function(self)
					local chatBar = C.StringWait(C.PlayerGui,"Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar")

					SG:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
					SG:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)

					table.insert(self.Functs,chatBar:GetPropertyChangedSignal("TextTransparency"):Connect(function()
						chatBar.TextTransparency = 0
					end))
					chatBar.TextTransparency = 0
					RunS.RenderStepped:Wait()
					chatBar:CaptureFocus()
					task.wait(2.5)
					C.ClearFunctTbl(self.Functs)
				end,
				Activate = function(self,newValue)
					if TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
						self:SlashPressedOld()
					else
						C.AddNotification("Unsupported Chat","This game uses a newer TCS version, so it is currently unusable.")
					end
				end,
                Events = {},
				Options = {},
			},
			{
				Title = "NoKick UI",
				Tooltip = "Hides the kick display a few seconds after you are kicked",
				Layout = 100, Default = true, NoStudio = true,
				Shortcut = "NoKick",
				Functs={}, Threads={},
				Message = "Kick Message: %s",
				Update = function(self,msg)
					local KickedButton = C.UI.KickedButton

					if KickedButton then
						KickedButton.Size = UDim2.fromScale(KickedButton.Size.X.Scale,0)
						KickedButton.AutomaticSize = Enum.AutomaticSize.Y
						if msg then
							KickedButton.Text = self.Message:format(msg)
						end
						KickedButton.Visible = true
					end
				end,
				Activate = function(self,newValue)
					if not newValue then
						return
					end
					table.insert(self.Functs,GS.ErrorMessageChanged:Connect(function(msg)
						if not msg or msg:len() == 0 then
							return
						end
						task.delay(1,GS.ClearError,GS)
						self:Update(msg)
						-- Debug.Traceback doesn't work for this:
						print(("Client/Server Kick Has Occured (%.2f): %s"):format(time(), msg))
					end))
				end,
			},
			{
				Title = "Improvements",
				Tooltip = "Many Client Improvement Settings can be found here!",
				Layout = 103,
				Shortcut = "ClientImprovement",Functs={},Default=true,
				SetAutoJump = function(self)
					if C.human then
						C.human.AutoJumpEnabled = (not self.RealEnabled or not self.EnTbl.PreventAutoJump) and UIS.TouchEnabled and C.Defaults.AutoJumpEnabled
					end
				end,
				Activate = function(self,newValue,firstRun)
					local EnTbl = self.RealEnabled and self.EnTbl or {}
					--Fix Keyboard
					if EnTbl.FixKeyboard then
						local tb = Instance.new("TextBox")
						tb:AddTag("RemoveOnDestroy")
						tb:CaptureFocus()
						DS:AddItem(tb,0)
					end
					--Lock Camera Orientation
					local LastCameraSubjectChangeSignal, LastCamera
					local function UpdateCamera()
						local Camera = workspace.CurrentCamera
						if LastCameraSubjectChangeSignal and Camera ~= LastCamera then
							LastCameraSubjectChangeSignal:Disconnect()
							C.TblRemove(self.Functs,LastCameraSubjectChangeSignal)
						end
						if Camera then
							local newCameraType = Camera.CameraType
							if newCameraType == Enum.CameraType.Custom and EnTbl.LockCamera then
								Camera.CameraType = Enum.CameraType.Track
							elseif newCameraType == Enum.CameraType.Track and not EnTbl.LockCamera then
								Camera.CameraType = Enum.CameraType.Custom
							end
							LastCameraSubjectChangeSignal = Camera:GetPropertyChangedSignal("CameraType"):Connect(UpdateCamera)
							table.insert(self.Functs, LastCameraSubjectChangeSignal)
						end
					end
					table.insert(self.Functs,workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(UpdateCamera))
					UpdateCamera()
					
					self:SetAutoJump()

					--Disable TouchGui (if it exists)
					if UIS.TouchEnabled then
						local function GUIAdded()
							local ContextActionGui = C.PlayerGui:WaitForChild("ContextActionGui",.3)
							local TouchGui = C.PlayerGui:WaitForChild("TouchGui");
							local TouchGui2 = C.gameName == "FlagWars" and C.PlayerGui:WaitForChild("Mobile UI")
							local function updateTouchScreenEnability()
								TouchGui.Enabled = not EnTbl.DisableTouchGUI
								if ContextActionGui then
									ContextActionGui.Enabled = not EnTbl.DisableTouchGUI
								end
								if TouchGui2 then
									TouchGui2.Enabled = not EnTbl.DisableTouchGUI
								end
							end
							if EnTbl.DisableTouchGUI then
								table.insert(self.Functs,TouchGui:GetPropertyChangedSignal("Enabled"):Connect(updateTouchScreenEnability))
								if ContextActionGui then
									table.insert(self.Functs,ContextActionGui:GetPropertyChangedSignal("Enabled"):Connect(updateTouchScreenEnability))
								end
								if TouchGui2 then
									table.insert(self.Functs,TouchGui2:GetPropertyChangedSignal("Enabled"):Connect(updateTouchScreenEnability))
								end	
							end
							updateTouchScreenEnability()	
						end
						table.insert(self.Functs,C.PlayerGui.ChildAdded:Connect(GUIAdded))
						GUIAdded()
					end
				end,
                Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						self:SetAutoJump()
						--C.DoActivate(self,self.Activate,self.RealEnabled)
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
					{
						Type = Types.Toggle,
						Title = "Fix Keyboard",
						Tooltip = "Fixes the keyboard so that you can move when you first join",
						Layout = 0,Default=true,
						Shortcut="FixKeyboard",
						Activate = C.ReloadHack,
					},
				},
			},
		}
		
	}
end
