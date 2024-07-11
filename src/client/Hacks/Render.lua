local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local PS = game:GetService("Players")
local RunService = game:GetService("RunService")
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
					local options = {
						ignoreInvisibleWalls = self.EnTbl.IgnoreInvisibleWalls,
						ignoreUncollidable = self.EnTbl.IgnoreUncollidibleWalls,
						ignoreList = {camera.CameraSubject and camera.CameraSubject.Parent or nil},  -- Example: ignore parts in this list
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
		}
	}
end