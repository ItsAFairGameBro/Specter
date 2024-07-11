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
				Layout = 1,Default=true,
				Shortcut = "PlayerHighlight", Instances = {},
				Activate = function(self,newValue)
					if not newValue then
						return
					end
					for num, theirPlr in ipairs(PS:GetPlayers()) do
						local theirChar = theirPlr.Character
						if theirChar then -- and theirPlr ~= C.plr then
							task.spawn(self.Events.CharAdded,self,theirPlr,theirChar)
						end
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						RunService.RenderStepped:Wait()
						if firstRun or C.Cleared then
							return
						end
						local camera = workspace.CurrentCamera
						local robloxHighlight = Instance.new("Highlight")
						robloxHighlight.Parent = theirChar
						robloxHighlight.OutlineColor = Color3.fromRGB()
						table.insert(self.Instances,robloxHighlight)
						local theirHumanoid = theirChar:WaitForChild("Humanoid",1000)
						local HRP = theirChar:WaitForChild("HumanoidRootPart")
						local function changeVisibility(enabled,color)
							robloxHighlight.FillTransparency = enabled and 0 or 1
							robloxHighlight.OutlineTransparency = enabled and 0 or 1
							if color then
								robloxHighlight.FillColor = color
							end
						end
						local function checkIfInRange()
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
									return not theirChar:IsAncestorOf(part)--part:HasTag("CharPart") and 
								end,
								passFunction = function(part)
									return part:HasTag("CharPart")
								end,
							}
		
							local hitResult, hitPosition = C.Raycast(camera.CFrame.Position,(HRP.Position - camera.CFrame.Position).Unit,options)
							return hitResult and theirChar:IsAncestorOf(hitResult.Instance)
						end
						while self.EnTbl.En and HRP and not C.Cleared do
							if (not C.isInGame or (({C.isInGame(theirChar)})[1])==({C.isInGame(camera.CameraSubject.Parent)})[1]) then
								changeVisibility(not checkIfInRange(), C.GetPlayerNameTagColor(theirPlr,theirChar))
							else
								changeVisibility(false)
							end
							while theirHumanoid==camera.CameraSubject do
								changeVisibility(false)
								camera:GetPropertyChangedSignal("CameraSubject"):Wait()
							end
							task.wait(self.EnTbl.UpdateTime)
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