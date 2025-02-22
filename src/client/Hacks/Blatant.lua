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
					local CenterPart = (C.human.RigType == Enum.HumanoidRigType.R6 and C.char:WaitForChild("Torso",2)) or C.char:WaitForChild("HumanoidRootPart")
					local newInput = nil
					C.LastLoc = C.char:GetPivot() -- Inital Starting Position
					self.BlockTeleports = (not C.isInGame or C.isInGame(C.char))
					table.insert(self.Functs,RunS.RenderStepped:Connect(function()
						C.LastLoc = C.char:GetPivot()
					end))
					local function TeleportDetected()
						if C.Camera.CameraType == Enum.CameraType.Scriptable and self.EnTbl.Active == "Camera On Character" then
							return
						end
						newInput = C.char:GetPivot()
						if self.BlockTeleports and CenterPart.AssemblyMass == math.huge then
							if (newInput.Position - C.LastLoc.Position).Magnitude > 1 then
								C.LastTeleportLoc = C.LastLoc
								C.char:PivotTo(C.LastLoc)
								if self.EnTbl.UpdateOthers and C.hrp.AssemblyAngularVelocity.Magnitude < .5 then
									C.hrp.AssemblyAngularVelocity += Vector3.new(0,3,0)
								end
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
				Options = {
					{
						Type = Types.Toggle,
						Title = "NoMove Update",
						Tooltip = "Updates for other players when you're not moving",
						Layout = 1,Default=true,
						Shortcut="UpdateOthers",
					},
					{
						Type = Types.Dropdown,
						Title = "Active",Default="Camera On Character",
						Tooltip = "Only runs when this condition is true.",
						Selections={"Always","Camera On Character"},
						Layout = 2,
						Shortcut="Active",
					},
				},
			},
			{
				Title = "Fly",
				Tooltip = "Allows you to fly on enable",
				Layout = 1,DontActivate=true,
				Shortcut = "Fly",Functs={},Instances={},Default=false,Keybind = "Z",
				AllowedIds={1416947241,939025537,894494203,894494919,961932719,6802445333},
                Anims={},
				RunOnDestroy=function(self)
					self:ClearData()
					self:Activate(false)
				end,
                IsAnimationWhitelisted = function(self, animTrack)
                    if animTrack.Priority.Value > Enum.AnimationPriority.Movement.Value
                        and animTrack.Priority ~= Enum.AnimationPriority.Core then
                        return true
                    elseif animTrack.Animation.Name == "ToolNoneAnim" then
                        return true
                    end
                    local id = tonumber(animTrack.Animation.AnimationId:gmatch("%d+")())
                    return self.AllowedIds[id]
                end,
                StopAnimation = function(self, v)
                    if v.Looped then
                        table.insert(self.Anims, v)
                        v:SetAttribute("OrgSpeed", v.Speed)
                    end
                    v:Stop(0)
                end,
				StopAllAnims=function(self)
					for i, v in pairs(C.animator:GetPlayingAnimationTracks()) do
						if not self:IsAnimationWhitelisted(v) then
                            self:StopAnimation(v)
						end
					end
				end,
                StartAnims = function(self)
                    for _, v in ipairs(self.Anims) do
                        v:Play(0, 1, v:GetAttribute("OrgSpeed"))
                        v:SetAttribute("OrgSpeed",nil)
                    end
                    self.Anims = {}
                end,
				Activate = function(self,newValue)
					if not C.human then return end --else task.wait(.1) end
                    local IsSeated = false
                    if C.human:GetState() ~= Enum.HumanoidStateType.Seated then -- Only update if not sitting
					    C.human:SetStateEnabled(Enum.HumanoidStateType.Seated,not newValue)
                    else
                        IsSeated = true
                    end

					if not newValue then
						self:StopAllAnims()
                    else
                        self:StartAnims()
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

                            if not IsSeated then
							    C.human:ChangeState(Enum.HumanoidStateType.Running)
                            end
						end

						return
					else
                        if not IsSeated then
						    C.human:ChangeState(Enum.HumanoidStateType.Physics)
                        end
						task.spawn(self.StopAllAnims,self)
					end

					local enTbl = self.EnTbl

					local alignOrien, lineVel, vectorForce
                    local dumpLocation = C.hrp
                    --local dumpLocation = workspace:FindFirstChildWhichIsA("BasePart",true)
                    --if C.char:IsAncestorOf(dumpLocation) then
                    --    dumpLocation = workspace
                    --    warn("[Blatant.Fly]: DumpLocation targeted BasePart inside C.char; re-parenting to workspace!")
                    --end

					if enTbl.LookDirection then
						alignOrien = Instance.new("AlignOrientation")
						--alignOrien.MaxTorque = 10^6
                        alignOrien.Responsiveness = 200 -- Instant turn speed
                        alignOrien.RigidityEnabled = true -- Instant turn speed
                        alignOrien.Mode = Enum.OrientationAlignmentMode.OneAttachment
                        alignOrien.Attachment0 = C.rootAttachment
						--alignOrien.P = 10^6
						--alignOrien.D = 800
						--alignOrien.Name = "BasePart"
						alignOrien.Parent = dumpLocation
						table.insert(self.Instances,alignOrien)
					end
					if enTbl.Mode == "Physics" then
						lineVel = Instance.new("LinearVelocity")
						lineVel.MaxForce = 10^6
                        lineVel.RelativeTo = Enum.ActuatorRelativeTo.World
                        lineVel.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
                        lineVel.Attachment0 = C.rootAttachment
						--lineVel.P = 10^4
						--bodyVel.Name = "BasePart"
						lineVel.Parent = dumpLocation
						table.insert(self.Instances,lineVel)
					else
						vectorForce = Instance.new("VectorForce")
                        vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
                        vectorForce.Attachment0 = C.rootAttachment
						vectorForce.Force = Vector3.new(0,workspace.Gravity * getMass(C.char))
                        vectorForce.Parent = dumpLocation
						table.insert(self.Instances,vectorForce)
					end

					local SaveMode = enTbl.Mode
					local idx = 0
					--local CharacterMass = getMass(C.char)
					local function onUpdate(dt)
						local cf = workspace.CurrentCamera.CFrame
						local charCF = C.char:GetPivot()

						local MoveDirection = C.human.MoveDirection
						if MoveDirection.Magnitude > 0 then
							local cameraLook = cf.LookVector
							local cameraRight = cf.RightVector
							
							-- MoveDirection = Vector3.new(MoveDirection.X, 0, MoveDirection.Z)(cameraRight * MoveDirection.X) + (cameraLook * -MoveDirection.Z)
						
							-- Normalize to get unit vector
							MoveDirection = MoveDirection.Unit
						else
							MoveDirection = Vector3.zero
						end
						idx+=1
						if idx == 20 then
							idx = 0
							print(C.human.MoveDirection,MoveDirection)
						end
						local up = 0
						if enTbl.UseExtraKeybinds then
							if (C.IsJumping) then
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
						if alignOrien then
							alignOrien.CFrame = cf
						else
							C.hrp.AssemblyAngularVelocity = Vector3.zero
						end
						if SaveMode == "Physics" then
							lineVel.VectorVelocity = newVelocity
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
                        if not self:IsAnimationWhitelisted(animTrack) then
                            self:StopAnimation(animTrack)
						end
					end
					table.insert(self.Functs,C.animator.AnimationPlayed:Connect(animatorPlayedFunction))
					onUpdate(0.05)
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
                SetExtraStructure = function(structure, en)
                    for num, part in ipairs(structure:GetDescendants()) do
						if part:IsA("BasePart") then
							if en then
								C.SetPartProperty(part,"CanCollide","NoClip",false)
							else--part, propertyName, requestName, value, alwaysSet
								C.ResetPartProperty(part,"CanCollide","NoClip")
							end
						end
					end
                end,
				Activate = function(self,newValue,firstRun)
					if not C.char then
						return
					end
                    if not newValue and C.human and C.human.FloorMaterial ~= Enum.Material.Air then
                        C.human:ChangeState(Enum.HumanoidStateType.Landed)
                    end
					if C.human then
						if newValue and not self.EnTbl.EnClimbing then
							C.human:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
						else
							C.human:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
						end
					end
                    if not firstRun and C.SeatPart then
                        self.Events.MySeatAdded(self, C.SeatPart)
                    end
					self.Update(newValue)
					if not newValue then
                        self.Events.MySeatRemoved(self, C.SeatPart)
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
                    MySeatAdded = function(self, seat)
                        task.wait(2)
                        if seat then
                            self.SetExtraStructure(seat.Parent, true)
                        end
                    end,
                    MySeatRemoved = function(self, seat)
                        if seat then
                            self.SetExtraStructure(seat.Parent, false)
                        end
                    end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Enable Climbing",
						Tooltip = "Allows you to climb ladders while still noclipping.\nThis may mess with ",
						Layout = 3,Default=false,
						Shortcut="EnClimbing",
						Activate = C.ReloadHack,
					},
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
                    local myIgnoreList = {C.char};

                    if self.EnTbl.CamIgnoreDist > 0 then
                        for num, part in ipairs(workspace:GetPartBoundsInRadius(workspace.CurrentCamera.CFrame.Position,self.EnTbl.CamIgnoreDist)) do
                            table.insert(myIgnoreList,part)
                        end
                    end

					local screenToWorldRay = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)

					local options = {
						ignoreInvisibleWalls = self.EnTbl.IgnoreInvisibleWalls,
						ignoreUncollidable = self.EnTbl.IgnoreUncollidibleWalls,
						ignoreList = myIgnoreList,  -- Example: ignore parts in this list
						raycastFilterType = Enum.RaycastFilterType.Exclude,  -- Choose filter type
						distance = self.EnTbl.Distance,  -- Retry up to 3 times
						collisionGroup = C.hrp.CollisionGroup,
						Type = screenToWorldRay.Direction,
					}

					local hitResult, hitPosition = C.Raycast(screenToWorldRay.Origin,screenToWorldRay.Direction,options)


					if (self.EnTbl.AlwaysTeleport or hitResult) and C.char.PrimaryPart then
						local OrientX,OrientY,OrientZ = C.char:GetPivot():toEulerAnglesXYZ()
                        if C.SeatPart then
                            C.DoTeleport(hitPosition + Vector3.new(0,C.getCharacterHeight(C.char)))
                        else
                            C.DoTeleport(CFrame.new(hitPosition) * CFrame.Angles(OrientX,OrientY,OrientZ) + Vector3.new(0,C.getCharacterHeight(C.char)))
                        end
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
						Title = "Distance*",
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
                    {
						Type = Types.Slider,
						Title = "Cam Ignore Dist",
						Tooltip = "Objects closer to your camera than this distance will be ignored",
						Layout = 1,Default=1,
						Min=0,Max=5,Digits=1,
						Shortcut="CamIgnoreDist",
					},
				}
			},
			{
				Title = "WalkSpeed",
				Tooltip = "Changes your walkspeed to the set value",
				Layout = 97,
				Shortcut = "WalkSpeed",Functs={},
				SetProperty = function(self)
					local toSet = self.RealEnabled and self.EnTbl.Speed or C.Defaults.WalkSpeed
					if C.human and math.abs(C.human.WalkSpeed - toSet) > 1e-3 then
						C.human.WalkSpeed = toSet
					end
				end,
				Activate = function(self,newValue)
					if not C.human then return else task.wait(.1) end
					local GetPartProperty, Defaults = C.GetPartProperty, C.Defaults
					C.HookMethod("__index",self.Shortcut,newValue and self.EnTbl.Hidden and function(theirScript,index,self,...)
						if (self == C.human) then
							return "Spoof", {rawget(Defaults,"WalkSpeed")}
						end
					end,{"walkspeed"})
					if newValue and self.EnTbl.Override then
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
					{
						Type = Types.Toggle,
						Title = "Hidden",
						Tooltip = `Prevents other scripts from noticing`,
						Layout = 2,Default=true,
						Shortcut="Hidden",
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
					local toSet = self.RealEnabled and self.EnTbl.Jump or C.Defaults.JumpPower
					if C.human and math.abs(C.human.JumpPower - toSet) > 1e-3 then
						C.human.JumpPower = toSet
					end
				end,
				Activate = function(self,newValue)
					if not C.human then return else task.wait(.1) end

					local GetPartProperty, Defaults = C.GetPartProperty, C.Defaults
					C.HookMethod("__index",self.Shortcut,newValue and self.EnTbl.Hidden and function(theirScript,index,self,...)
						if (self == C.human) then
							return "Spoof", {rawget(Defaults,"JumpPower")}
						end
					end,{"jumppower"})
					if newValue and self.EnTbl.Override then
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
					{
						Type = Types.Toggle,
						Title = "Hidden",
						Tooltip = `Prevents other scripts from noticing`,
						Layout = 2,Default=true,
						Shortcut="Hidden",
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
