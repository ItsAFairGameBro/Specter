local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local DS = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local PS = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")
local SC = game:GetService("ScriptContext")
local LS = game:GetService("LogService")
local NC = game:GetService("NetworkClient")
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
				Layout = 100, NoStudio = true,
				Shortcut = "AntiAfk",Functs={},Default=true,
                Update = function()
					VU:CaptureController()
                    VU:ClickButton2(Vector2.new())
                end,
				Activate = function(self,newValue)
					C.SetInstanceConnections(C.plr,"Idled",self.Shortcut,not newValue or not self.EnTbl.GameProtection)
                    if not newValue then
                        return
                    end
					table.insert(self.Functs, C.plr.Idled:Connect(self.Update))
				end,
                Events = {},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Game Protection",
						Tooltip = "Prevents game scripts from accessing the Player.Idled connection",
						Layout = 3,Default=true,
						Shortcut="GameProtection",
						Activate = C.ReloadHack,
					},
				},
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
					if SG:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
						if TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
							self:SlashPressedOld()
						else
							C.AddNotification("Unsupported Chat","This game uses a newer TCS version, so it is currently unusable.")
						end
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
				BestMessage = nil,
				Message = "%s (Error Code %i)\nRejoin to interact with the game and other PS, and click here to hide this prompt.",
				Events = {
					RbxErrorPrompt = function(self, errorMessage,errorCode,identification)
						if identification:find("Teleport") then
							return -- Who cares?
						end
						local KickedButton = C.UI.KickedButton
						if not self.BestMessage or (#errorMessage>0 and errorMessage ~= "You have been kicked from the game") then
							self.BestMessage = errorMessage
							print((`%s Error Has Occured (%.1f): %s`):format(identification, time(), errorMessage))
						end

						if KickedButton then
							KickedButton.Size = UDim2.fromScale(KickedButton.Size.X.Scale,0)
							KickedButton.AutomaticSize = Enum.AutomaticSize.Y
							if self.BestMessage then
								KickedButton.Text = self.Message:format(self.BestMessage,errorCode)
							end
							KickedButton.Visible = true
						end

						-- Debug.Traceback doesn't work for this:
						task.defer(GS.ClearError,GS)
						SG:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
					end,
				},
			},
			{
				Title = "Bot",
				Tooltip = "Implements several automatic features",
				Layout = 99,
				Shortcut = "BotAuto",
				RejoinDelay = 30,
				Sending = false,
                ChatConnected = false,
                Functs = {},
                Threads = {},
				--[[Functs = {},
				Activate = function(self, newValue)
					if newValue then
						table.insert(self.Functs, TeleportService.TeleportInitFailed:Connect(function(player,teleportResult,errorMessage,placeId,teleportOptions)
							if errorMessage == "Teleport failed due to an unexpected error. Please try teleporting again." then

							end
							task.wait(2)
						end))
					end
				end,--]]
                FPSRate = 10,
                SetFPS = function(self, enabled)
                    if enabled then
                        C.setfpscap(self.FPSRate) -- enable FPS cap
                    else
                        C.setfpscap(0) -- disable FPS cap
                    end
                end,
                Activate = function(self, newValue, firstRun)
                    if newValue and self.EnTbl.LowerFPS then
                        self:SetFPS(true)
                        local timePassed = time()
                        if (timePassed < 15) then
                            table.insert(self.Threads, task.delay(15 - timePassed, function()
                                self:SetFPS(true)
                                C.AddNotification("FPS Cap", "FPS Cap Added After Delayed Start")
                            end))
                        end
                    elseif C.setfpscap and not firstRun then
                        self:SetFPS(false)
                    end
                    if not firstRun and C.char then
                        if newValue then
                            table.insert(self.Threads, task.spawn(self.Events.MyCharAdded,self, C.plr, C.char, false))
                        else
                            self.Events.MyCharAdded(self, C.plr, C.char, false)
                        end
                    end
                    if not newValue then
                        self.ChatConnected = false
                        return
                    end
                    for _, theirPlr in ipairs(PS:GetPlayers()) do
                        self.Events.OthersPlayerAdded(self, theirPlr, false)
                    end
                end,
                HasAdminAccess = function(self, theirPlr)
                    return table.find(C.AdminUsers, theirPlr.Name:lower())
                end,
                Options = {
                    C.setfpscap and {
                        Type = Types.Toggle,
                        Default = false,
                        Title = "FPS Cap",
                        Tooltip = "Lowers FPS to 10 to allow for other CPU processes",
                        Layout = 1,
                        Shortcut="LowerFPS",
                        Activate=C.ReloadHack,
                    },
                    {
                        Type = Types.Toggle,
                        Default = false,
                        Title = "Hide Character",
                        Tooltip = "Hides your character from visible view, but also unable to interact with anything",
                        Layout = 2,
                        Shortcut="HideChar",
                        Activate=C.ReloadHack,
                    }
                },
				Events = {
					RbxErrorPrompt = function(self, errorMessage, errorCode, errorIdentification)
						if self.Sending then
							return
						end
						self.Sending = true
						local RejoinDelay = self.RejoinDelay
						local Cancel = task.spawn(function()
							if not C.Prompt(`Auto-Rejoin`,`Auto Rejoin Will Occur In {RejoinDelay} Seconds.\nTo turn this off, disable \"Utility->Bot\"`,"Cancel") then
								self.Sending = false
							end
						end)
						task.wait(5)
						if self.Sending then
							C.Prompt_ButtonTriggerEvent:Fire("Yes")
							task.wait(0.4)
                            self.Sending = false
							C.ServerTeleport(game.PlaceId, nil)
						end
					end,
                    OthersPlayerAdded = function(self,theirPlr,firstRun)
                        if theirPlr == C.plr or self.ChatConnected or firstRun then
                            return -- do not double do it!
                        end
                        if self:HasAdminAccess(theirPlr) then
							self.ChatConnected = true
                            if TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
                                local DoneFiltering = C.StringWait(RS, "DefaultChatSystemChatEvents.OnMessageDoneFiltering")
                                table.insert(self.Functs, DoneFiltering.OnClientEvent:Connect(function(data, channel)
                                    local thePlr = PS:GetPlayerByUserId(data.SpeakerUserId)
                                    if thePlr and thePlr ~= C.plr and self:HasAdminAccess(thePlr) then
                                        local msg = data.Message
                                        if not msg then
                                            return
                                        end
                                        if msg:sub(1,1) == "/" then
                                            C.RunCommand(msg, true)
                                        end
                                    end
                                end))
                                --print("Chat Connected Because Of User",theirPlr)
                            elseif TCS.ChatVersion == Enum.ChatVersion.TextChatService then
								local enabled = true
								local function TCSAdded(textChannel: TextChannel)
									if textChannel:IsA("TextChannel") then
										local thisFunct
										thisFunct = textChannel.MessageReceived:Connect(function(incomingMessage: TextChatMessage)
											while incomingMessage.Status == Enum.TextChatMessageStatus.Sending do
												print("Waiting for filtering!")
												incomingMessage:GetPropertyChangedSignal("Status"):Wait()
											end
											if not table.find(self.Functs, thisFunct) or not incomingMessage.TextSource then
												return
											end
											-- print("SOURCE:",incomingMessage.TextSource, incomingMessage.Translation, incomingMessage.Text)
											local thePlr = PS:GetPlayerByUserId(incomingMessage.TextSource.UserId)
											if thePlr and thePlr ~= C.plr and self:HasAdminAccess(thePlr) then
												local msg = incomingMessage.Translation:len() > 0 and incomingMessage.Translation or incomingMessage.Text
												if not msg then
													print("Message Not Found!")
													return
												end
												if msg:sub(1,1) == "/" then
													C.RunCommand(msg, true)
												-- else
													-- print(`Message doesn't start with "/": "{msg}"`)
												end
											-- else
												-- print(`USER NOT VALID: {thePlr}`)
											end
										end)
										table.insert(self.Functs, thisFunct)
									end
								end
								table.insert(self.Functs, TCS.DescendantAdded:Connect(TCSAdded))
								for _, textChannel in ipairs(TCS:GetDescendants()) do
									TCSAdded(textChannel)
								end
							else
                                C.CreateSysMessage(`[Utility.Bot]: Unknown Chat Service is Not Supported: {TCS.ChatVersion.Name}!`)
                                warn("[Utility.Bot]: New Chat Service Not Supported!",TCS.ChatVersion.Name)
                            end
                        end
                    end,
                    MyCharAdded = function(self,theirPlr,theirChar,firstRun)
                        if self.RealEnabled and self.EnTbl.HideChar then
                            C.SavePlayerCoords(self.Shortcut)
                            while true do
                                C.DoTeleport(CFrame.new(0,10000,0))
                                C.hrp.AssemblyLinearVelocity = Vector3.zero
                                C.hrp.AssemblyAngularVelocity = Vector3.zero
                                RunS.PreSimulation:Wait()
                            end
                        else
                            C.LoadPlayerCoords(self.Shortcut)
                        end
                    end,
				},
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
					local InputFound = (C.human and C.human.MoveDirection.Magnitude > 1e-5) or C.IsJumping

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
							local TouchGui = C.PlayerGui:FindFirstChild("TouchGui");
							if not TouchGui then
								return
							end
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

					--Fix Keyboard
					if EnTbl.FixKeyboard and not UIS:GetFocusedTextBox() and not InputFound then

						local tb = Instance.new("TextBox",C.PlayerGui)
						tb.Position = UDim2.new(-1, 0,-1, 0)
						tb.AnchorPoint = Vector2.new(1, 1)
						tb:CaptureFocus()
                        RunS.RenderStepped:Wait()
                        RunS.RenderStepped:Wait()
                        RunS.RenderStepped:Wait()

                        if tb:IsFocused() then
                            tb:ReleaseFocus()
                        end
                        -- print("Textbox Fixed!")
                        -- Remove next frame to allow for smooth transition!
                        DS:AddItem(tb,0)

						--warn("Textbox Select")
					end
                    --[EXPERIMENTAL] [FAILED]: Lock the mouse when right clicking
                    --[[if EnTbl.MouseFix and mousemoveabs then
                        local UserInputService = game:GetService("UserInputService")
                        local setPoso

                        table.insert(self.Functs,UserInputService.InputBegan:Connect(function(input, gameProcessed)
                            if input.UserInputType == Enum.UserInputType.MouseButton2 and not gameProcessed and UserInputService.MouseBehavior == Enum.MouseBehavior.Default then
                                --UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                                print("LOCK")
                                setPoso = input.Position
                            end
                        end))

                        table.insert(self.Functs,UserInputService.InputEnded:Connect(function(input, gameProcessed)
                            if input.UserInputType == Enum.UserInputType.MouseButton2 and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCurrentPosition then
                                task.wait(.5)
                                if mousemoveabs and setPoso then
                                    mousemoveabs(setPoso.X, setPoso.Y)
                                    setPoso = nil
                                    print("MOVED")
                                end
                            end
                        end))
                    end]]


                    -- Infinite Zoom
                    if EnTbl.NoZoomLimit then
				        C.SetPartProperty(C.plr,"CameraMaxZoomDistance",self.Shortcut,10000)
                    else
				        C.ResetPartProperty(C.plr,"CameraMaxZoomDistance",self.Shortcut)
                    end

                    -- No First Person
                    if EnTbl.NoFirstPerson then
                        C.SetPartProperty(C.plr,"CameraMinZoomDistance",self.Shortcut,1)
                        C.SetPartProperty(C.plr,"CameraMode",self.Shortcut,Enum.CameraMode.Classic)
                    else
				        C.ResetPartProperty(C.plr,"CameraMinZoomDistance",self.Shortcut)
                        C.ResetPartProperty(C.plr,"CameraMode",self.Shortcut)
                    end

                    -- Anti Lag
                    if EnTbl.AntiLag ~= "Off" then
                        task.spawn(self.AntiLag, self)
                    end

                    -- Spoof TouchEnabled
                    C.HookMethod("__index",self.Shortcut .. "/SpoofKeyboard",newValue and self.EnTbl.SpoofKeyboard and function(theirScript,index,self,...)
                        if index == "touchenabled" then
							-- print("sp00f t0uch")
                            return "Spoof", {false}
                        end
                    end)
				end,
                AntiLag = function(self)
                    local Terrain = workspace:FindFirstChildOfClass('Terrain')
                    Terrain.WaterWaveSize = 0
                    Terrain.WaterWaveSpeed = 0
                    Terrain.WaterReflectance = 0
                    Terrain.WaterTransparency = 0
                    Lighting.GlobalShadows = false
                    Lighting.FogEnd = 9e9
                    settings().Rendering.QualityLevel = 1
                    for i,v in pairs(game:GetDescendants()) do
                        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                            v.Material = "Plastic"
                            v.Reflectance = 0
                        elseif v:IsA("Decal") then
                            v.Transparency = 1
                        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                            v.Lifetime = NumberRange.new(0)
                        elseif v:IsA("Explosion") then
                            v.BlastPressure = 1
                            v.BlastRadius = 1
                        end
                        if (i%1000 == 0) then
                            RunS.RenderStepped:Wait()
                        end
                    end
                    for i,v in pairs(Lighting:GetDescendants()) do
                        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                            v.Enabled = false
                        end
                    end
                    table.insert(self.Functs,workspace.DescendantAdded:Connect(function(child)
                        task.spawn(function()
                            if child:IsA('ForceField') then
                                RunS.Heartbeat:Wait()
                                child:Destroy()
                            elseif child:IsA('Sparkles') then
                                RunS.Heartbeat:Wait()
                                child:Destroy()
                            elseif child:IsA('Smoke') or child:IsA('Fire') then
                                RunS.Heartbeat:Wait()
                                child:Destroy()
                            end
                        end)
                    end))
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
                    {
						Type = Types.Toggle,
						Title = "No Zoom Limit",
						Tooltip = "Allows for infinite zooming",
						Layout = 5,Default=true,
						Shortcut="NoZoomLimit",
						Activate = C.ReloadHack,
					},
                    {
						Type = Types.Toggle,
						Title = "Disable First Person",
						Tooltip = "Prevents First Person",
						Layout = 6,Default=true,
						Shortcut="NoFirstPerson",
						Activate = C.ReloadHack,
					},
                    {
						Type = Types.Dropdown,
						Title = "Anti Lag",
						Tooltip = "Irreversibly removes lots of textures to minimize lag",
						Layout = 9,Default="Off",
						Shortcut="AntiLag",
                        Selections = {"Off","Destroy"},
						Activate = C.ReloadHack,
					},
                    {
						Type = Types.Toggle,
						Title = "No Touchscreen",
						Tooltip = "Forces only to have keyboard input",
						Layout = 15,Default=false,
						Shortcut="SpoofKeyboard",
						Activate = C.ReloadHack,
					},
				},
			},
			{
				Title = "❌❌Disable LogService❌❌",
				Tooltip = "Prevents logs from being viewed or tracked\nNote: this may cause crash on startup!",
				Layout = 200,
				Shortcut = "LogServiceProtection",Default=false,
				Activate = function(self,newValue,firstRun)
					C.HookMethod("__namecall",self.Shortcut,newValue and function (newSc,method,self)
						print("CALLED!",newSc,method,self)
						if self == LS then
							print("Prevented LogService")
							return "Override", {{}}
						end
					end, {"getloghistory"})
					C.SetInstanceConnections(SC,"Error",self.Shortcut,not newValue)
					C.SetInstanceConnections(LS,"MessageOut",self.Shortcut,not newValue)
				end
			}
		}

	}
end
