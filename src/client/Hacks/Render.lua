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
				Title = "ESP Player Highlight",
				Tooltip = "Highlights users' characters when they are not visible on the screen",
				Layout = 1,Default=true,Deb=0,
				Shortcut = "PlayerHighlight", Instances = {}, Storage={},
				UpdVisibility = function(self,robloxHighlight,enabled,theirPlr,theirChar)
					--robloxHighlight.FillTransparency = enabled and 0 or 1
					--robloxHighlight.OutlineTransparency = enabled and 0 or 1
					robloxHighlight.Enabled = enabled
					if enabled then
						robloxHighlight.FillColor = C.GetPlayerNameTagColor(theirPlr,theirChar)
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
					local theirPlr,theirChar,robloxHighlight,theirHumanoid,HRP = table.unpack(instanceData)
					if theirHumanoid~=camera.CameraSubject and (not C.isInGame or (C.isInGame(theirChar)==C.isInGame(camera.CameraSubject.Parent))) then
						local isInRange = self:checkIfInRange(camera,theirPlr,theirChar,HRP)
						self:UpdVisibility(robloxHighlight,not isInRange,theirPlr,theirChar)
					else
						self:UpdVisibility(robloxHighlight,false,theirPlr,theirChar)
					end
				end,
				Activate = function(self,newValue)
					self.Storage = {}
					if not newValue then
						return
					end
					self.Deb = self.Deb + 1 local saveDeb = self.Deb
					local function CanRun()
						return saveDeb == self.Deb and not C.Cleared
					end
					if C.char then
						for num, theirPlr in ipairs(PS:GetPlayers()) do
							local theirChar = theirPlr.Character
							if theirChar then
								task.spawn(self.Events.CharAdded,self,theirPlr,theirChar)
							end
						end
					end
					while CanRun() do
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
						robloxHighlight.OutlineTransparency,robloxHighlight.FillTransparency = 0, 0
						robloxHighlight.OutlineColor = Color3.fromRGB()
						robloxHighlight.Adornee = theirChar
						robloxHighlight:AddTag("RemoveOnDestroy")
						robloxHighlight.Parent = C.GUI
						table.insert(self.Instances,robloxHighlight)
						local theirHumanoid = theirChar:WaitForChild("Humanoid",1000)
						local camera = workspace.CurrentCamera
						local HRP = theirChar:WaitForChild("HumanoidRootPart")
						local StorageTbl = {theirPlr,theirChar,robloxHighlight,theirHumanoid,HRP}
						table.insert(self.Storage,StorageTbl)
						self:RunCheck(StorageTbl)
					end,
					CharRemoved = function(self,thePlr,theChar)
						for s = #self.Storage, 1, -1 do
							local instanceData = self.Storage[s]
							local theirPlr,theirChar,robloxHighlight,theirHumanoid,HRP = table.unpack(instanceData)
							if theirChar == theChar then
								table.remove(self.Storage,s)
								C.TblRemove(self.Instances,robloxHighlight)
								robloxHighlight:Destroy()
								break
							elseif s == 1 then
								warn(tostring(thePlr) .. " does not have a valid highlight to remove!")
							end
						end
					end,
				},
				Options = {
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
				Layout = 2,Default=true,Deb=0,
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
						return true, Type
					end
				end,
				UndoTransmitter=function(self,index)
					local data = self.TouchTransmitters[index]
					local object, parent, Type, TouchToggle = table.unpack(data or {})
					if parent and parent.Parent and not self:CanBeEnabled(object,Type) then
						C.ResetPartProperty(parent,"CanTouch","DisableTouchTransmitters")
						if TouchToggle then
							TouchToggle:Destroy()
						end
						parent:RemoveTag("TouchDisabled")
						self.TouchTransmitters[index]=nil
						self.GlobalTouchTransmitters[parent] = nil
					end
				end,
				UndoTransmitters=function(self,saveEn)
					for index = #self.TouchTransmitters,1,-1 do
						if saveEn ~= self.RealEnabled and not C.Cleared then
							return
						end
						self:UndoTransmitter(index)
						if index%15==0 then
							RunS.RenderStepped:Wait()
						end
					end
				end,
				RunOnDestroy=function(self)
					self:UndoTransmitters()
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
							local function clickfunction()
								if self.EnTbl.ClickMode == "Activate" then
									local HRP = C.char and C.char:FindFirstChild("HumanoidRootPart")
									if not HRP then
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
									C.firetouchinterest(parent,HRP, toTouch)
									RunS.RenderStepped:Wait()
									task.wait(.5)

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
								if self.EnTbl.ClickDuration ~= "Forever" then
									table.insert(self.Threads,task.delay(tonumber(self.EnTbl.ClickDuration) or 0, clickfunction))
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
					CharAdded=function(self,theirPlr,theirChar,firstRun)
						local theirHRP = theirChar:WaitForChild("HumanoidRootPart",30)-- wait for it to be loaded!
						if not theirHRP then
							return
						end
						task.wait(.5)
						if firstRun then
							task.wait(5)
							self:Activate(self.RealEnabled)
						end
					end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Humanoids",
						Tooltip = "Whether or not parts that are humanoids are affected",
						Layout = 0,Default=false,
						Shortcut="Humanoids",
					},
					{
						Type = Types.Toggle,
						Title = "Parts",
						Tooltip = "Whether or not regular parts are affected",
						Layout = 1,Default=true,
						Shortcut="Humanoids",
					},
					{
						Type = Types.Dropdown, Selections = {"Activate","Enable"},
						Title = "Click Mode",
						Tooltip = "What happens when you click on a disabled object",
						Layout = 2,Default="Activate",
						Shortcut="ClickMode",
					},
					{
						Type = Types.Dropdown, Selections = {"Instant", "Forever"},
						Title = "Click Duration",
						Tooltip = "How long the clicking lasts before it reverts to being disabled",
						Layout = 3,Default="Instant",
						Shortcut="ClickDuration",
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
		}
	}
end