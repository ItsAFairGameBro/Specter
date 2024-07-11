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
				UpdVisibility = function(self,robloxHighlight,enabled,color)
					robloxHighlight.FillTransparency = enabled and 0 or 1
					robloxHighlight.OutlineTransparency = enabled and 0 or 1
					if color then
						robloxHighlight.FillColor = color
					end
				end,
				checkIfInRange = function(self,camera,theirPlr,theirChar,HRP)
					if self.EnTbl.Distance < 0.1 then
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
				Activate = function(self,newValue)
					self.Storage = {}
					if not newValue then
						return
					end
					self.Deb = self.Deb + 1 local saveDeb = self.Deb
					local function CanRun()
						return saveDeb == self.Deb and not C.Cleared
					end
					for num, theirPlr in ipairs(PS:GetPlayers()) do
						local theirChar = theirPlr.Character
						if theirChar then -- and theirPlr ~= C.plr then
							task.spawn(self.Events.CharAdded,self,theirPlr,theirChar)
						end
					end
					local camera = workspace.CurrentCamera
					while CanRun() do
						for num, instanceData in ipairs(self.Storage) do
							local theirPlr,theirChar,robloxHighlight,theirHumanoid,HRP = table.unpack(instanceData)
							if theirHumanoid~=camera.CameraSubject and (not C.isInGame or (({C.isInGame(theirChar)})[1])==({C.isInGame(camera.CameraSubject.Parent)})[1]) then
								local isInRange = self:checkIfInRange(camera,theirPlr,theirChar,HRP)
								self:UpdVisibility(robloxHighlight,not isInRange, C.GetPlayerNameTagColor(theirPlr,theirChar))
							else
								self:UpdVisibility(robloxHighlight,false)
							end
						end
						task.wait(self.EnTbl.UpdateTime)
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						RunService.RenderStepped:Wait()
						if firstRun or C.Cleared then
							return
						end
						local robloxHighlight = Instance.new("Highlight")
						robloxHighlight.Parent = theirChar
						robloxHighlight.OutlineColor = Color3.fromRGB()
						table.insert(self.Instances,robloxHighlight)
						local theirHumanoid = theirChar:WaitForChild("Humanoid",1000)
						local HRP = theirChar:WaitForChild("HumanoidRootPart")
						table.insert(self.Storage,{theirPlr,theirChar,robloxHighlight,theirHumanoid,HRP})
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