local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local function getMass(model)
	assert(model and model:IsA("Model"), "Model argument of getMass must be a model.");
	
	return model.PrimaryPart and model.PrimaryPart.AssemblyMass or 0;
end
return function(C,Settings)
	return {
		Category = {
			Name = "Blatant",
			Title = "Blatant",
			Image = 10901055597,
			Layout = 2,
		},
		Tab = {
			{
				Title = "AutoTeleportBack",
				Tooltip = "Teleports back when inside of the game",
				Layout = 0, Threads = {}, Functs={},
				Shortcut = "AutoTeleportBack",Default=true,
				Activate = function(self,newValue)
					if not newValue or not C.human then
						return
					end
					local CenterPart = (C.gameName == "FleeMain" and C.char:FindFirstChild("HumanoidRootPart")) 
						or (C.human.RigType == Enum.HumanoidRigType.R6 and C.char:WaitForChild("Torso",2)) or C.char:WaitForChild("HumanoidRootPart")
					local newInput = nil
					C.LastLoc = C.char:GetPivot() -- Inital Starting Position
					self.BlockTeleports = (not C.isInGame or C.isInGame(C.char))
					table.insert(self.Functs,RunS.RenderStepped:Connect(function()
						C.LastLoc = C.char:GetPivot()
					end))
					local function TeleportDetected()
						newInput = C.char:GetPivot()
						if self.BlockTeleports then
							if (newInput.Position - C.LastLoc.Position).Magnitude > 16 then
								C.LastTeleportLoc = C.LastLoc
								C.char:PivotTo(C.LastLoc)
							end
						elseif (C.isInGame and C.isInGame(C.char)) then
							task.wait(.5)
							self.BlockTeleports = true
						end
					end
					local function AddToCFrameDetection(part)
						table.insert(self.Functs,part:GetPropertyChangedSignal("Position"):Connect(TeleportDetected))
						--table.insert(self.Functs,part:GetPropertyChangedSignal("CFrame"):Connect(TeleportDetected))
					end
					for num, part in ipairs(C.char:GetChildren()) do
						if part:IsA("BasePart") then--and part.Name == "Head" then
							AddToCFrameDetection(part)
						end
					end
				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
			},
			{
				Title = "Fly",
				Tooltip = "Allows you to fly on enable",
				Layout = 1,DontActivate=true,
				Shortcut = "Fly",Functs={},Instances={},Default=false,Keybind = "Z",
				AllowedIds={1416947241,939025537,894494203,894494919,961932719,6802445333},
				RunOnDestroy=function(self)
					self:Activate(false)
				end,
				StopAllAnims=function(self)
					for i, v in pairs(C.animator:GetPlayingAnimationTracks()) do
						if not self.AllowedIds[tonumber(v.Animation.AnimationId:gmatch("%d+")())] then
							v:Stop(1e-1)
							v:Destroy()
						end
					end
				end,
				Activate = function(self,newValue)
					--if not C.human then return end --else task.wait(.1) end
					C.human:SetStateEnabled(Enum.HumanoidStateType.Seated,not newValue)
					
					if not newValue then
						self:StopAllAnims()
					end
					
					if C.char:FindFirstChild("Animate") ~=nil and game.GameId~=372226183 and C.gameName ~= "NavalWarefare" then
						C.char.Animate.Enabled = not newValue
					end

					if not newValue then
						if C.char and C.hrp and C.human then
							local Orient = C.hrp.Orientation
							
							local options = {
								ignoreInvisibleWalls = false,
								ignoreUncollidable = true,
								ignoreList = {C.char},  -- Example: ignore parts in this list
								raycastFilterType = Enum.RaycastFilterType.Exclude,  -- Choose filter type
								distance = C.getCharacterHeight(C.char)+3.1,  -- Retry up to 3 times
							}
		
							local hitResult, hitPosition = C.Raycast(C.hrp.Position+Vector3.new(0,3,0),-Vector3.new(0,3,0),options)
							
		
							if hitResult then						
								C.DoTeleport(CFrame.new(hitPosition) * CFrame.Angles(0,math.rad(Orient.Y),0) + Vector3.new(0,C.getCharacterHeight(C.char)))
							else
								C.DoTeleport(CFrame.new(C.char:GetPivot().Position) * CFrame.Angles(0,math.rad(Orient.Y),0))
							end
							C.hrp.AssemblyAngularVelocity = Vector3.zero
							
							C.human:ChangeState(Enum.HumanoidStateType.Running)
						end
						
						return
					else
						C.human:ChangeState(Enum.HumanoidStateType.Physics)
						task.spawn(self.StopAllAnims,self)
					end

					local enTbl = self.EnTbl

					local bodyGyro, bodyVel, bodyForce
					
					
					if enTbl.LookDirection then
						bodyGyro = Instance.new("BodyGyro")
						bodyGyro.maxTorque = Vector3.new(1, 1, 1)*10^6
						bodyGyro.P = 10^6
						bodyGyro.D = 800
						bodyGyro.Name = "BasePart"
						bodyGyro.Parent = C.hrp
						table.insert(self.Instances,bodyGyro)
					end
					if enTbl.Mode == "Physics" then
						bodyVel = Instance.new("BodyVelocity")
						bodyVel.maxForce = Vector3.new(1, 1, 1)*10^6
						bodyVel.P = 10^4
						bodyVel.Name = "BasePart"
						bodyVel.Parent = C.hrp
						table.insert(self.Instances,bodyVel)
					else
						bodyForce = Instance.new("BodyForce")
						bodyForce.Force = Vector3.new(0,workspace.Gravity * getMass(C.char))						
						bodyForce.Parent = C.hrp--]]
						table.insert(self.Instances,bodyForce)
					end

					local SaveMode = enTbl.Mode
					--local CharacterMass = getMass(C.char)
					local function onUpdate(dt)
						local cf = workspace.CurrentCamera.CFrame

						local charCF = C.char:GetPivot()

						local MoveDirection = C.human.MoveDirection * Vector3.new(1,0,1)
						if MoveDirection:Dot(MoveDirection) > 0 then
							MoveDirection = (cf * CFrame.new((CFrame.new(cf.p, cf.p + Vector3.new(cf.lookVector.x, 0, cf.lookVector.z)):VectorToObjectSpace(MoveDirection)))).p - cf.p;
							MoveDirection = MoveDirection.Unit
						else
							MoveDirection = Vector3.zero
						end
						local up = 0
						if enTbl.UseExtraKeybinds then
							if (UIS:IsKeyDown(Enum.KeyCode.Space)) then
								up += 1
							end
							if (UIS:IsKeyDown(Enum.KeyCode.E)) then
								up += 1
							end
							if (UIS:IsKeyDown(Enum.KeyCode.Q)) then
								up -= 1
							end
						end
						MoveDirection = (cf.UpVector * up + MoveDirection)

						if (MoveDirection:Dot(MoveDirection) > 0) then
							MoveDirection = MoveDirection.Unit
						end
						
						local newVelocity = (MoveDirection * Vector3.new(enTbl.HorizontalMult,enTbl.VerticalMult,enTbl.HorizontalMult)) * enTbl.Speed * 5
							* (enTbl.UseWalkSpeed and (C.human.WalkSpeed/C.Defaults.WalkSpeed) or 1)
						if bodyGyro then
							bodyGyro.CFrame = cf
						else
							C.hrp.AssemblyAngularVelocity = Vector3.zero
						end
						if SaveMode == "Physics" then
							bodyVel.Velocity = newVelocity
						elseif SaveMode == "CFrame" then
							C.DoTeleport(charCF + dt * newVelocity)
							C.hrp.AssemblyLinearVelocity = Vector3.zero-- + dt * CharacterMass * workspace.Gravity * Vector3.new(0, 1, 0)
							--C.hrp.AssemblyAngularVelocity = Vector3.zero
							--bodyVel.Velocity = Vector3.new(0,newVelocity.Y,0)
						elseif SaveMode == "Velocity" then
							C.hrp.AssemblyLinearVelocity = newVelocity-- + dt * workspace.Gravity * Vector3.new(0, 1, 0)--* CharacterMass * workspace.Gravity
							--bodyVel.Velocity = newVelocity.Y
						end
					end

					table.insert(self.Functs,RunS.PreSimulation:Connect(onUpdate))
					local function animatorPlayedFunction(animTrack)
						if not self.AllowedIds[tonumber(animTrack.Animation.AnimationId:gmatch("%d+")())] then
							animTrack:Stop(1e-1)
						end
					end
					table.insert(self.Functs,C.animator.AnimationPlayed:Connect(animatorPlayedFunction))
					onUpdate()
				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "Speed",
						Tooltip = "How fast you fly through the air",
						Layout = 1,Default=20,
						Min=0,Max=200,Digits=1,
						Shortcut="Speed",
					},
					{
						Type = Types.Dropdown,
						Title = "Mode",
						Tooltip = "What kind of movement type",
						Layout = 2,Default="Physics",
						Selections = {"Physics","CFrame","Velocity"},
						Shortcut="Mode",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Use Walkspeed",
						Tooltip = "Use Walkspeed in calculation",
						Layout = 3,Default=false,
						Shortcut="UseWalkspeed",
					},
					{
						Type = Types.Slider,
						Title = "Horizontal Multiplier",
						Tooltip = "How much faster you go horizontally (forward/left/right/back)",
						Layout = 4,Default=1,
						Min=0.1,Max=10,Digits=1,
						Shortcut="HorizontalMult",
					},
					{
						Type = Types.Slider,
						Title = "Vertical Multiplier",
						Tooltip = "How much faster you go vertically (up/down)",
						Layout = 5,Default=1,
						Min=0.1,Max=10,Digits=1,
						Shortcut="VerticalMult",
					},
					{
						Type = Types.Toggle,
						Title = "Use E+Q+Space",
						Tooltip = "Uses the keybinds E, Q, and Space for control keybinds",
						Layout = 6,Default=true,
						Shortcut="UseExtraKeybinds",
					},
					{
						Type = Types.Toggle,
						Title = "Face Direction",
						Tooltip = "Whether or not to face where you're going",
						Layout = 7,Default=true,
						Shortcut="LookDirection",
						Activate = C.ReloadHack,
					},
				}
			},
			{
				Title = "Swim",
				Tooltip = "Allows you to swim on enable",
				Layout = 4,DontActivate=true,
				Shortcut = "Swim",Functs={},
				Activate = function(self,newValue)
					if not C.human then
						return
					end
					C.human:SetStateEnabled(Enum.HumanoidStateType.Jumping,not newValue)
					C.human:SetStateEnabled(Enum.HumanoidStateType.GettingUp,not newValue)
					if not newValue then
						C.human:ChangeState(Enum.HumanoidStateType.GettingUp)
						return
					end
					C.human:ChangeState(Enum.HumanoidStateType.Swimming)
					table.insert(self.Functs,C.human.StateChanged:Connect(function(old, new)
						if old == Enum.HumanoidStateType.Swimming then
							C.human:ChangeState(Enum.HumanoidStateType.Swimming)
						end
					end))
					table.insert(self.Functs,RunS.PreSimulation:Connect(function(delta: number)
						local swimForce = C.human.MoveDirection * Vector3.new(self.EnTbl.HorizontalMult,self.EnTbl.VerticalMult,self.EnTbl.HorizontalMult) * self.EnTbl.MoveSpeed
						if self.EnTbl.WalkSpeed then
							swimForce *= (C.human.WalkSpeed / C.Defaults.WalkSpeed)
						end
						swimForce += Vector3.new(0,self.EnTbl.FloatSpeed,0)
						C.hrp.AssemblyLinearVelocity = swimForce * (delta * 60)
					end))
				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "Move Speed",
						Tooltip = "How fast you swim through the air",
						Layout = 1,Default=20,
						Min=0,Max=200,Digits=1,
						Shortcut="MoveSpeed",
					},
					{
						Type = Types.Slider,
						Title = "Float Speed",
						Tooltip = "How fast you go up",
						Layout = 1,Default=4,
						Min=-20,Max=20,Digits=0,
						Shortcut="FloatSpeed",
					},
					{
						Type = Types.Toggle,
						Title = "Use Walkspeed",
						Tooltip = "Use Walkspeed in calculation",
						Layout = 3,Default=false,
						Shortcut="UseWalkspeed",
					},
					{
						Type = Types.Slider,
						Title = "Horizontal Multiplier",
						Tooltip = "How much faster you go horizontally (forward/left/right/back)",
						Layout = 4,Default=1,
						Min=0.1,Max=10,Digits=1,
						Shortcut="HorizontalMult",
					},
					{
						Type = Types.Slider,
						Title = "Vertical Multiplier",
						Tooltip = "How much faster you go vertically (up/down)",
						Layout = 5,Default=1,
						Min=0.1,Max=10,Digits=1,
						Shortcut="VerticalMult",
					},
				}
			},
			{
				Title = "Noclip",
				Tooltip = "Allows your character to walk through walls",
				Layout = 5,
				Shortcut = "Noclip",Functs={},Default=false,Keybind = "R",
				RunOnDestroy=function(self)
					self:Activate(false)
				end,
				Update = function(value)
					for num, part in ipairs(C.char:GetDescendants()) do
						if part:IsA("BasePart") then
							if value then
								C.SetPartProperty(part,"CanCollide","NoClip",false,true)
							else--part, propertyName, requestName, value, alwaysSet
								C.ResetPartProperty(part,"CanCollide","NoClip")
							end
						end
					end
				end,
				Activate = function(self,newValue)
					if not C.char then
						return
					end
					self.Update(newValue)
					if not newValue then
						return
					end
					table.insert(self.Functs,RunS.Stepped:Connect(self.Update))
				end,
				Cleared = function(self)

				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					
				}
			},
			{
				Title = "Teleport",
				Tooltip = "Teleports your character to where your mouse is",
				Layout = 10, Type = "NoToggle",
				Shortcut = "Teleport",Keybind = "T",
				Activate = function(self,newValue)
					if not C.char then
						return
					end

					local mouseLocation = UIS:GetMouseLocation()

					local screenToWorldRay = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
					
					local options = {
						ignoreInvisibleWalls = self.EnTbl.IgnoreInvisibleWalls,
						ignoreUncollidable = self.EnTbl.IgnoreUncollidibleWalls,
						ignoreList = {C.char},  -- Example: ignore parts in this list
						raycastFilterType = Enum.RaycastFilterType.Exclude,  -- Choose filter type
						distance = self.EnTbl.Distance,  -- Retry up to 3 times
						Type = screenToWorldRay.Direction,
					}

					local hitResult, hitPosition = C.Raycast(screenToWorldRay.Origin,screenToWorldRay.Direction,options)
					

					if (self.EnTbl.AlwaysTeleport or hitResult) and C.char.PrimaryPart then
						local OrientX,OrientY,OrientZ = C.char:GetPivot():toEulerAnglesXYZ()
						
						C.DoTeleport(CFrame.new(hitPosition) * CFrame.Angles(OrientX,OrientY,OrientZ) + Vector3.new(0,C.getCharacterHeight(C.char)))
					end
				end,
				Options = {
					{
						Type = Types.Toggle,
						Title = "Always Teleport",
						Tooltip = "Always teleport, even if the ray did not hit anything",
						Layout = 0,Default=true,
						Shortcut="AlwaysTeleport",
					},
					{
						Type = Types.Slider,
						Title = "Distance",
						Tooltip = "How far the ray is cast. Longer rays cost more performance.",
						Layout = 1,Default=1000,
						Min=1,Max=20000,Digits=0,
						Shortcut="Distance",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Invisible Walls",
						Tooltip = "Whether or not you teleport through invisible walls",
						Layout = 2,Default=true,
						Shortcut="IgnoreInvisibleWalls",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Uncollidible Walls",
						Tooltip = "Whether or not you teleport through uncollidible walls (walls that have CanCollide=false)",
						Layout = 3,Default=true,
						Shortcut="IgnoreUncollidibleWalls",
					},
				}
			},
			{
				Title = "Walkspeed",
				Tooltip = "Changes your walkspeed to the set value",
				Layout = 97,
				Shortcut = "Walkspeed",Functs={},
				SetProperty = function(self)
					if C.human then
						C.human.WalkSpeed = self.RealEnabled and self.EnTbl.Speed or C.Defaults.WalkSpeed
					end
				end,
				Activate = function(self,newValue)
					if not C.human then return else task.wait(.1) end
					if self.EnTbl.Override then
						table.insert(self.Functs,C.human:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
							self:SetProperty()
						end))
					end
					self:SetProperty(true)
				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "Speed",
						Tooltip = `What value to set the speed to (Default: {C.Defaults.WalkSpeed})`,
						Layout = 0,Default=30,
						Min=0,Max=200,Digits=1,
						Shortcut="Speed",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Force Override",
						Tooltip = "Prevents speed from being updated to anything else",
						Layout = 1,Default=true,
						Shortcut="Override",
						Activate = C.ReloadHack,
					},
				}
			},
			{
				Title = "JumpPower",
				Tooltip = "How high you jump",
				Layout = 98,
				Shortcut = "JumpPower",Functs={},
				SetProperty = function(self)
					if C.human then
						C.human.JumpPower = self.RealEnabled and self.EnTbl.Jump or C.Defaults.JumpPower
					end
				end,
				Activate = function(self,newValue)
					if not C.human then return else task.wait(.1) end
					if self.EnTbl.Override then
						table.insert(self.Functs,C.human:GetPropertyChangedSignal("JumpPower"):Connect(function()
							self:SetProperty()
						end))
					end
					self:SetProperty(true)
				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "JumpPower",
						Tooltip = `What value to set the jump power to (Default: {C.Defaults.JumpPower})`,
						Layout = 0,Default=C.Defaults.JumpPower*1.4,
						Min=0,Max=200,Digits=1,
						Shortcut="Jump",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Force Override",
						Tooltip = "Prevents jump from being updated to anything else",
						Layout = 1,Default=true,
						Shortcut="Override",
						Activate = C.ReloadHack,
					},
				}
			},
			{
				Title = "Gravity",
				Tooltip = "What to set the gravity to",
				Layout = 99,
				Shortcut = "Gravity",Functs={},
				SetProperty = function(self)
					workspace.Gravity = self.RealEnabled and self.EnTbl.Gravity or C.Defaults.Gravity
				end,
				Activate = function(self,newValue)
					if self.EnTbl.Override then
						table.insert(self.Functs,workspace:GetPropertyChangedSignal("Gravity"):Connect(function()
							self:SetProperty()
						end))
					end
					self:SetProperty(true)
				end,
				Events = {},
				Options = {
					{
						Type = Types.Slider,
						Title = "Gravity",
						Tooltip = `What value to set the gravity to (Default: {C.Defaults.Gravity})`,
						Layout = 0,Default=100,
						Min=0,Max=200,Digits=1,
						Shortcut="Gravity",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Force Override",
						Tooltip = "Prevents gravity from being updated to anything else",
						Layout = 1,Default=true,
						Shortcut="Override",
						Activate = C.ReloadHack,
					},
				}
			},
		}
	}
end
