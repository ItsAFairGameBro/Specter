local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local PS = game:GetService("Players")
local RunS = game:GetService("RunService")
local CS = game:GetService("CollectionService")
local DS = game:GetService("Debris")
local UIS = game:GetService("UserInputService")
return function(C,Settings)
	return {
		Category = {
			Name = "Render",
			Title = "Render",
			Image = 14503021137,
			Layout = 1,
		},
		Tab = {
			{
				Title = "ESP Players",
				Tooltip = "Highlights users' characters when they are not visible on the screen",
				Layout = 1,Default=true,
				Shortcut = "PlayerHighlight", Threads={}, Functs={}, Instances = {}, Storage={},
				UpdVisibility = function(self,instances,hasCameraSbj,enabled,theirPlr,theirChar,theirHumanoid: Humanoid,theirIsInGame)
					--robloxHighlight.FillTransparency = enabled and 0 or 1
					--robloxHighlight.OutlineTransparency = enabled and 0 or 1
					local NameTag, Highlight = instances[1], instances[2]
					NameTag.Enabled = hasCameraSbj and ((self.EnTbl.NameTagVisible=="No Line Of Sight" and enabled) or self.EnTbl.NameTagVisible=="Always")
					Highlight.Enabled = hasCameraSbj and ((self.EnTbl.HighlightVisible=="No Line Of Sight" and enabled) or self.EnTbl.HighlightVisible=="Always")
					if NameTag.Enabled or Highlight.Enabled then
						Highlight.FillColor = C.GetPlayerNameTagColor(theirPlr,theirChar,theirIsInGame)
						if NameTag:FindFirstChild("Username") then
							NameTag.Username.TextColor3 = Highlight.FillColor
						end
					end
					if theirHumanoid then
						theirHumanoid.DisplayDistanceType = NameTag.Enabled and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Subject
					end
				end,
				checkIfInRange = function(self,camera,theirPlr,theirChar,HRP)
					if self.EnTbl.Distance < 0.1 or self.EnTbl.Distance < (camera.CFrame.Position - HRP.Position).Magnitude then
						return false -- no way we're reaching them lol!
					end
					if camera.CameraSubject and camera.CameraSubject.Parent == theirChar then
						return true
					end
					local options = {
						ignoreInvisibleWalls = self.EnTbl.IgnoreInvisibleWalls,
						ignoreUncollidable = self.EnTbl.IgnoreUncollidibleWalls,
						ignoreList = {},--{camera.CameraSubject and camera.CameraSubject.Parent or nil},  -- Example: ignore parts in this list
						raycastFilterType = Enum.RaycastFilterType.Exclude,  -- Choose filter type
						distance = self.EnTbl.Distance, -- Maximum cast distance
						detectionFunction = function(part)
							return theirChar:IsAncestorOf(part)--part:HasTag("CharPart") and 
						end,
						passFunction = function(part)
							return part:HasTag("CharPart")
						end,
					}

					local hitResult, hitPosition = C.Raycast(camera.CFrame.Position,(HRP.Position - camera.CFrame.Position).Unit,options)
					return hitResult and theirChar:IsAncestorOf(hitResult.Instance)
				end,
				RunCheck = function(self,instanceData)
					local camera = workspace.CurrentCamera
					local theirPlr,theirChar,instances,theirHumanoid,HRP = table.unpack(instanceData)
					local theirInGame = C.isInGame and table.pack(C.isInGame(theirChar))
					if (not camera.CameraSubject or not camera.CameraSubject.Parent) or (theirHumanoid~=camera.CameraSubject and (not theirInGame or
					((theirInGame[3]==nil and select(3,C.isInGame(camera.CameraSubject.Parent))==theirInGame[3]) or
					(theirInGame[3]~=nil and C.isInGame(camera.CameraSubject.Parent)==theirInGame[1])))) then
						local isInRange
						-- Only run when needed
						if self.EnTbl.NameTagVisible=="No Line Of Sight" or self.EnTbl.HighlightVisible=="No Line Of Sight" then
							isInRange = self:checkIfInRange(camera,theirPlr,theirChar,HRP)
						end
						self:UpdVisibility(instances,true,not isInRange,theirPlr,theirChar,theirHumanoid,theirInGame)
					else
						self:UpdVisibility(instances,false,false,theirPlr,theirChar,theirHumanoid)
					end
				end,
				ClearStorage = function(self)
					for theChar, data in pairs(self.Storage) do
						self.Events.CharRemoved(self,nil,theChar) -- Fake cleanup!
					end
				end,
				Activate = function(self,newValue)
					self:ClearStorage()
					if not newValue then
						return
					end
					for num, theirPlr in ipairs(PS:GetPlayers()) do
						local theirChar = theirPlr.Character
						if theirChar then
							task.spawn(self.Events.CharAdded,self,theirPlr,theirChar)
						end
					end
					local oldCameraSubject = workspace:WaitForChild("Camera").CameraSubject
					table.insert(self.Functs,workspace:WaitForChild("Camera"):GetPropertyChangedSignal("CameraSubject"):Connect(function()
						local OldStorage = self.Storage[oldCameraSubject and oldCameraSubject.Parent or nil]
						oldCameraSubject = workspace.Camera.CameraSubject
						local NewStorage = self.Storage[oldCameraSubject and oldCameraSubject.Parent or nil]
						
						if NewStorage then
							self:RunCheck(NewStorage)
						end
						RunS.RenderStepped:Wait()
						if OldStorage then
							self:RunCheck(OldStorage)
						end
					end))
					while true do
						for _, instanceData in pairs(self.Storage) do
							self:RunCheck(instanceData)
						end
						task.wait(self.EnTbl.UpdateTime)
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						local robloxHighlight = Instance.new("Highlight")
						robloxHighlight.Enabled = false
						robloxHighlight.OutlineTransparency,robloxHighlight.FillTransparency = 1, 0
						robloxHighlight.OutlineColor = Color3.fromRGB()
						robloxHighlight.Adornee = theirChar
						robloxHighlight:AddTag("RemoveOnDestroy")
						robloxHighlight.Parent = C.GUI
						local nameTag = C.Examples.NameTagEx:Clone()
						nameTag:WaitForChild("Username").Text = theirPlr.Name
						nameTag.Parent = C.GUI
						nameTag.Adornee = theirChar:FindFirstChild("Head") or theirChar.PrimaryPart
						table.insert(self.Instances,nameTag)
						table.insert(self.Instances,robloxHighlight)
						local theirHumanoid = theirChar:WaitForChild("Humanoid",1000)
						local camera = workspace.CurrentCamera
						local HRP = theirChar:WaitForChild("HumanoidRootPart",15)
						if not HRP then
							return
						end
						local StorageTbl = {theirPlr,theirChar,{nameTag,robloxHighlight},theirHumanoid,HRP}
						self.Storage[theirChar] = StorageTbl
						self:RunCheck(StorageTbl)
					end,
					CharRemoved = function(self,thePlr,theChar)
						local instanceData = self.Storage[theChar]
						if instanceData then
							local theirPlr,theirChar,instances,theirHumanoid,HRP = table.unpack(instanceData)
							self.Storage[theChar] = nil
							for num, instance in ipairs(instances) do
								C.TblRemove(self.Instances,instance)
								instance:Destroy()
							end
						else
							warn(`InstanceData not found for {theChar} but its being removed!`)
						end
					end,
				},
				Options = {
					{
						Type = Types.Dropdown,
						Title = "NameTags",
						Tooltip = "When NameTags are displayed",
						Layout = -2,Default="Always",
						Selections = {"Always","No Line Of Sight","Never"},
						Shortcut="NameTagVisible",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Dropdown,
						Title = "Highlight",
						Tooltip = "When NameTags are displayed",
						Layout = -1,Default="No Line Of Sight",
						Selections = {"Always","No Line Of Sight","Never"},
						Shortcut="HighlightVisible",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Slider,
						Title = "Raycast Update Time*",
						Tooltip = "How often to update its visibility (PERFORMANCE)",
						Layout = 0,Default=1,
						Min=0,Max=3,Digits=1,
						Shortcut="UpdateTime",
					},
					{
						Type = Types.Slider,
						Title = "Raycast Distance",
						Tooltip = "Highlights will not appear when a character's head can be directly seen from this distance (set to 0 to disable)",
						Layout = 2,Default=100,
						Min=0,Max=100,Digits=1,
						Shortcut="Distance",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Invisible Walls",
						Tooltip = "Whether or not the raycast goes through invisible walls",
						Layout = 2,Default=true,
						Shortcut="IgnoreInvisibleWalls",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Uncollidible Walls",
						Tooltip = "Whether or not the raycast goes through uncollidible walls (walls that have CanCollide=false)",
						Layout = 3,Default=true,
						Shortcut="IgnoreUncollidibleWalls",
					},
				}
			},
			{
				Title = "ESP Touch Transmitters",
				Tooltip = "Ability to toggle/activate touch transmitters",
				Layout = 2,Default=false,Deb=0,
				Shortcut = "DisableTouchTransmitters", Instances = {}, Functs={},
				TouchTransmitters={}, Threads = {},
				GlobalTouchTransmitters={},
				GetType=function(self,instance)
					if instance.Parent.Parent.ClassName=="Model" and instance.Parent.Parent.Parent==workspace
						and instance.Parent.Parent:WaitForChild("Humanoid",.1) then
						return "Humanoid"
					else
						return "Part"
					end
				end,
				CanBeEnabled=function(self,instance,Type)
					Type = Type or self:GetType(instance)
					if C.Cleared or not instance or not instance.Parent then
						return false, Type
					end
					if not self.RealEnabled then
						return false, Type
					elseif self.EnTbl.Humanoids and Type=="Humanoid" then
						return true, Type
					elseif self.EnTbl.Parts and Type=="Part" then
						return true, Type
					else
						return false, Type
					end
				end,
				UndoTransmitter=function(self,index)
					local data = self.TouchTransmitters[index]
					local object, parent, Type, TouchToggle = table.unpack(data or {})
					if parent and parent.Parent then-- and not self:CanBeEnabled(object,Type) then
						C.ResetPartProperty(parent,"CanTouch","DisableTouchTransmitters")
						if TouchToggle then
							TouchToggle:Destroy()
						end
						parent:RemoveTag("TouchDisabled")
						self.TouchTransmitters[index]=nil
						self.GlobalTouchTransmitters[parent] = nil
					end
				end,
				UndoTransmitters=function(self,saveEn,clearOverride)
					for index = #self.TouchTransmitters,1,-1 do
						if (saveEn ~= self.RealEnabled or C.Cleared) and not clearOverride then
							return
						end
						self:UndoTransmitter(index)
						if index%15==0 then
							RunS.RenderStepped:Wait()
						end
					end
				end,
				RunOnDestroy=function(self)
					C.ClearTagTraces("TouchDisabled")
					print("Tags Cleared!")
				end,
				ApplyTransmitters=function(self,instance)
					if instance:IsA("TouchTransmitter") and instance.Parent and instance.Parent.Parent then
						local parent = instance.Parent
						local canBeEn, Type = self:CanBeEnabled(instance)
						if canBeEn and not parent:HasTag("TouchDisabled") then
							local TouchToggle=C.Examples.ToggleTagEx:Clone()
							local insertTbl = {instance,parent,Type,TouchToggle,{}}
							table.insert(self.TouchTransmitters,insertTbl)

							TouchToggle.Name = "TouchToggle"
							TouchToggle.Parent=C.GUI
							TouchToggle.Adornee=parent
							TouchToggle.ExtentsOffsetWorldSpace = Vector3.new(0, 0, 0)
							TouchToggle.Enabled = true
							CS:AddTag(TouchToggle,"RemoveOnDestroy")
							CS:AddTag(parent,"TouchDisabled")

							if Type=="Part" then
								if parent.CanCollide then
									TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 238)
								else
									TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 0, 255)
								end
								TouchToggle.Toggle.Text = "Activate"
							else
								TouchToggle.Toggle.Text = "Enable"
								TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(0,170)
							end
							local saveCollide = parent.CanCollide or parent.Parent.Name=="FadingTiles"
							local function clickfunction(didClick: boolean)
								if self.EnTbl.ClickMode == "Activate" then
									if not C.hrp then
										return
									end

									local toTouch

									if TouchToggle.Toggle.Text == "Activate" then
										TouchToggle.Toggle.Text = "DeActivate"
										TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(255,0,80)
										toTouch = 0
									else
										TouchToggle.Toggle.Text = "Activate"
										if saveCollide then
											TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 238)
										else
											TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 0, 255)
										end
										toTouch = 1
									end


									C.ResetPartProperty(parent,"CanTouch","DisableTouchTransmitters")
									RunS.RenderStepped:Wait()
									C.firetouchinterest(C.hrp, parent, toTouch)
									RunS.RenderStepped:Wait()

									if TouchToggle.Parent then
										C.SetPartProperty(parent,"CanTouch","DisableTouchTransmitters",false)
									end
								else
									if parent.CanTouch then
										TouchToggle.Toggle.Text = "Enable"
										TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(0,170)
									else
										TouchToggle.Toggle.Text = "Disable"
										TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(170)
									end
									if parent.CanTouch then
										C.SetPartProperty(parent,"CanTouch","DisableTouchTransmitters",false)
									else
										C.ResetPartProperty(parent,"CanTouch","DisableTouchTransmitters")
									end
								end
								if self.EnTbl.ClickDuration ~= "Forever" and didClick ~= false then
									table.insert(self.Threads,task.delay(tonumber(self.EnTbl.ClickDuration) or 0, clickfunction,false))
								end
							end
							table.insert(insertTbl[5],TouchToggle.Toggle.MouseButton1Up:Connect(clickfunction))
							self.GlobalTouchTransmitters[parent] = clickfunction
							table.insert(insertTbl[5],parent.AncestryChanged:Connect(function(child,newParent)
								if not newParent then
									task.wait(1)
									local Key = table.find(self.TouchTransmitters,insertTbl)
									if Key then
										self:UndoTransmitter(Key)
									end
								else
									TouchToggle.Adornee=workspace:IsAncestorOf(child) and parent or nil
								end
							end))
							C.AddObjectConnection(parent,"DisableTouchTransmitters",parent.Destroying:Connect(function()
								DS:AddItem(TouchToggle,1)
							end))
							C.SetPartProperty(parent,"CanTouch","DisableTouchTransmitters",false)
						end
					end

					local saveEn = self.RealEnabled
					for num, location in ipairs(instance:GetChildren()) do
						if saveEn ~= self.RealEnabled then
							return
						end
						self:ApplyTransmitters(location)
						if num%150==0 then
							RunS.RenderStepped:Wait()
						end
					end
				end,
				Activate=function(self,newValue)
					C.ClearFunctTbl(self.Functs)
					self:UndoTransmitters(newValue)
					if newValue then
						table.insert(self.Functs,workspace.DescendantAdded:Connect(function(descendant)
							self:ApplyTransmitters(descendant)
						end))
						self:ApplyTransmitters(workspace)
					end
				end,
				Events={
					--[[CharAdded=function(self,theirPlr,theirChar,firstRun)
						local theirHRP = theirChar:WaitForChild("HumanoidRootPart",30)-- wait for it to be loaded!
						if not theirHRP then
							return
						end
						task.wait(.5)
						if firstRun then
							task.wait(2.5)
							self:Activate(self.RealEnabled)
						end
					end,--]]
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Humanoids",
						Tooltip = "Whether or not parts that are humanoids are affected",
						Layout = 0,Default=false,
						Shortcut="Humanoids",
						Activate = C.ReloadHack
					},
					{
						Type = Types.Toggle,
						Title = "Parts",
						Tooltip = "Whether or not regular parts are affected",
						Layout = 1,Default=true,
						Shortcut="Parts",
						Activate = C.ReloadHack
					},
					{
						Type = Types.Dropdown, Selections = {"Activate","Enable"},
						Title = "Click Mode",
						Tooltip = "What happens when you click on a disabled object",
						Layout = 2,Default="Activate",
						Shortcut="ClickMode",
						Activate = C.ReloadHack
					},
					{
						Type = Types.Dropdown, Selections = {"Instant", "Forever"},
						Title = "Click Duration",
						Tooltip = "How long the clicking lasts before it reverts to being disabled",
						Layout = 3,Default="Instant",
						Shortcut="ClickDuration",
						Activate = C.ReloadHack
					},
					--[[{
						Type = Types.Slider,
						Title = "Raycast Update Time*",
						Tooltip = "How often to update its visibility (PERFORMANCE)",
						Layout = 0,Default=1,
						Min=0,Max=3,Digits=1,
						Shortcut="UpdateTime",
					},
					{
						Type = Types.Slider,
						Title = "Raycast Distance",
						Tooltip = "Highlights will not appear when a character's head can be directly seen from this distance (set to 0 to disable)",
						Layout = 2,Default=100,
						Min=0,Max=100,Digits=1,
						Shortcut="Distance",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Invisible Walls",
						Tooltip = "Whether or not the raycast goes through invisible walls",
						Layout = 2,Default=true,
						Shortcut="IgnoreInvisibleWalls",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Uncollidible Walls",
						Tooltip = "Whether or not the raycast goes through uncollidible walls (walls that have CanCollide=false)",
						Layout = 3,Default=true,
						Shortcut="IgnoreUncollidibleWalls",
					},--]]
				}
			},
			{
				Title = "Frame Rate",
				Tooltip = "Displays frame rate at the top right corner of your screen",
				Layout = 20,Default=true,
				Shortcut = "FrameRate", Threads = {},
				Activate = function(self,newValue)
					local TL = C.UI.FrameRate
					TL.Visible = newValue
					if not newValue then
						return
					end
					while true do
						TL.Text = ("%i"):format(1/RunS.RenderStepped:Wait())
					end
				end,
			},
		}
	}
end