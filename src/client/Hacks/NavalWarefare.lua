local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunS = game:GetService("RunService")
local DS = game:GetService("Debris")
local PS = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local function Static(C,Settings)
	C.DataStorage={
		["USDock"]={Health=25e3,Base="Dock",Type="Base"},
		["JapanDock"]={Health=25e3,Base="Dock",Type="Base"},
		["Island"]={Health=8e3,Base="Island",Type="Base"},

		["Carrier"]={Health=10e3,Type="Ship"},
		["Battleship"]={Health=10e3,Type="Ship"},
		["Destroyer"]={Health=2500,Type="Ship"},
		["Cruiser"]={Health=3500,Type="Ship"},
		["Heavy Cruiser"]={Health=5500,Type="Ship"},
		["Submarine"]={Health=1000,Type="Ship"},

		["Bomber"]={Health=100,Type="Plane"},
		["Torpedo Bomber"]={Health=100,Type="Plane"},
		["Large Bomber"]={Health=300,Type="Plane"},
	}
	function C.isInGame(theirChar)
		if theirChar and theirChar.Name == "InviClone" then
			theirChar = C.char
		end
		local player=PS:GetPlayerFromCharacter(theirChar)
		if not player then
			return false, "Neutral"--No player, no team!
		end
		local PrimaryPart = theirChar.PrimaryPart
		if not PrimaryPart or PrimaryPart.Position.Y < -260 then
			return false, player.Team -- Player, but in lobby!
		end

		return true, player.Team -- Player exists!
	end
	function C.getClosest(noForcefield:boolean,notSeated:boolean)
		local myHRP = C.char and C.char.PrimaryPart
		if not C.human or C.human.Health <= 0 or not myHRP then return end


		local closest = nil;
		local distance = math.huge;


		for i, v in pairs(PS.GetPlayers(PS)) do
			if not C.CanTargetPlayer(v) then continue end
			local theirChar = v.Character
			if not theirChar then continue end
			local isInGame,team = C.isInGame(theirChar)
			if not isInGame then continue end
			if noForcefield and theirChar:FindFirstChildWhichIsA("ForceField") then continue end
			if team == C.plr.Team then continue end
			local theirHumanoid = theirChar.FindFirstChildOfClass(theirChar,"Humanoid")
			if not theirHumanoid or theirHumanoid.Health <= 0 then continue end
			if notSeated and (theirHumanoid.SeatPart or theirChar.FindFirstChild(theirChar,"ForceFieldVar")) then continue end
			local theirHead = theirChar.FindFirstChild(theirChar,"Head")
			if not theirHead then continue end

			local d = (theirHead.Position - myHRP.Position).Magnitude

			if d < distance then
				distance = d
				closest = theirHead
			end
		end

		return closest, distance
	end
	function C.getClosestBase()
		local selBase, maxDist = nil, math.huge
		for baseType, bases in pairs(C.Bases) do
			for num, base in ipairs(bases) do
				if base:FindFirstChild("Team") and base.Team.Value ~= "" and base.Team.Value ~= C.plr.Team.Name and base.HP.Value > 0 then
					local MainBody = base:WaitForChild("MainBody")
					local d = (MainBody.Position - C.char.PrimaryPart.Position).Magnitude
					if d < maxDist then
						selBase, maxDist = MainBody, d
					end
				end
			end
		end
		return selBase, maxDist
	end
	function C.getClosestShip()
		local selShip, maxDist = nil, math.huge
		for num, ship  in pairs(C.Ships) do
			if ship:FindFirstChild("Team") and ship.Team.Value ~= "" and ship.Team.Value ~= C.plr.Team.Name and ship.HP.Value > 0 then
				local MainBody = ship:WaitForChild("MainBody")
				local d = (MainBody.Position - C.char.PrimaryPart.Position).Magnitude
				if d < maxDist then
					selShip, maxDist = MainBody, d
				end
			end
		end
		return selShip, maxDist
	end
	C.getgenv().isInGame = C.isInGame
	C.RemoteEvent = RS:WaitForChild("Event") -- image naming something "Event"
	C.Bases = {Dock={},Island={}}
	C.Planes, C.Ships = {}, {}
	table.insert(C.EventFunctions,function()
		local function newChild(instance)
			if instance.ClassName ~= "Model" then
				return
			end
			local instData = C.DataStorage[instance.Name]
			if instData then
				local HitCode = instance:WaitForChild("HitCode")
				local ID = instData.Base or instData.Type -- Dock or Island
				local SelectTbl = C[instData.Type.."s"]
				if SelectTbl[ID] then
					SelectTbl = SelectTbl[ID]
				end
				table.insert(SelectTbl,instance)
				C.FireEvent(ID .. "Added",nil,instance)
				C.AddObjectConnection(instance,"NavalWarefareDestroying",instance.Destroying:Connect(function()
					--Disconnect the event
					C.TblRemove(SelectTbl,instance)
					C.FireEvent(ID .. "Removed",nil,instance)
				end))
			end
		end
		table.insert(C.functs,workspace.ChildAdded:Connect(newChild))
		for num, instance in ipairs(workspace:GetChildren()) do
			newChild(instance)
		end
	end)
end
return function(C,Settings)
	Static(C,Settings)

	return {
		Category = {
			Name = "NavalWarefare",
			Title = "Naval Warefare",
			Image = nil, -- Set Image to nil in order to get game image!
			Layout = 20,
		},
		Tab = {
			{
				Title = "AimAssist",
				Tooltip = "Automatically Aims At Enemies When In A Turret",
				Layout = 1, Functs = {},
				Shortcut = "AimAssist",
				Activate = function(self,newValue)
					local c = 800 -- bullet velocity you can put between 799-800
					local function l(m, n)
						if not m then return m.Position end
						local o = m.Velocity
						return m.Position + (o * n)
					end
					local function p(q)
						local r = C.plr.Character
						if not r or not r:FindFirstChild("HumanoidRootPart") then return 0 end
						local s = r.HumanoidRootPart.Position
						local t = (q - s).Magnitude
						return t / c
					end
					if newValue then
						table.insert(self.Functs,UIS.InputBegan:Connect(function(inputObject,gameProcessed)
							if inputObject.KeyCode == Enum.KeyCode.F then
								while UIS:IsKeyDown(Enum.KeyCode.F) and self.RealEnabled do
									local u = C.getClosest()
									if u then
										local v = u.Parent:FindFirstChild("HumanoidRootPart")
										if v then
											local w = p(v.Position)
											local x = l(v, w)
											C.RemoteEvent:FireServer("aim", {x})
										end
									end
									RunS.RenderStepped:Wait()
								end
							end
						end))
					end
				end,
			},
			{
				Title = "Rifle Kill Aura",
				Tooltip = "Uses rifle to loop kill nearby enemies.\nPlease note that people know who killed them",
				Layout = 2, Functs = {}, Threads = {},
				Shortcut = "KillAura",
				Shoot = function(self,Target: BasePart)
					if C.char and not C.char:FindFirstChild("InGame") and not C.char:GetAttribute("InGame") then
						C.RemoteEvent:FireServer("Teleport",{"Harbour",""})
						C.char:SetAttribute("InGame",true) -- Only fire once, no need for spam
					end
					C.RemoteEvent:FireServer("shootRifle","",{Target}) 
					C.RemoteEvent:FireServer("shootRifle","hit",{Target.Parent:FindFirstChild("Humanoid")})
				end,
				Activate = function(self,newValue)
					if not C.char then
						return
					end
					local Tool = C.char:FindFirstChildWhichIsA("Tool")
					while self.RealEnabled do
						local Target, Distance = C.getClosest()
						if Target and Distance <= 450 then
							self:Shoot(Target)
						end
						RunS.RenderStepped:Wait()
						while not Tool or not Tool:IsA("Tool") or not Tool.Parent or not Tool.Parent.Parent do
							Tool = C.char.ChildAdded:Wait() -- Wait for new tool!
						end
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				}
			},
			{
				Title = "Loop Kill Enemies",
				Tooltip = "Uses rifle to loop kill enemies.\nPlease note that people know who killed them",
				Layout = 3, Functs = {}, Threads = {},
				Shortcut = "LoopKillEnemies",
				Activate = function(self,newValue)
					if not C.char then
						return
					end
					local Title = "Loop Kill Enemies"
					C.SetHumanoidTouch(newValue,"rifleLoopKill")
					if newValue then
						local actionClone = C.AddAction({Name=Title,Tags={"RemoveOnDestroy"},Stop=function(onRequest)
							self:SetValue(false)
						end,})
						if not self.LastSpotted and C.char and C.hrp then
							self.LastSpotted = C.char:GetPivot()
						end
						local Time = actionClone:FindFirstChild("Time")
						local saveChar = C.char
						while Time and self.RealEnabled and C.char == saveChar and C.char.PrimaryPart and C.human and C.human.Health>0 do
							local theirHead, dist = C.getClosest()
							if theirHead then
								C.DoTeleport(theirHead.Parent:GetPivot() * CFrame.new(0,20,0))
								Time.Text = theirHead.Parent.Name
								self.Parent.Tab[2]:Shoot(theirHead)
								C.Spectate(theirHead.Parent)
							else
								Time.Text = "(Waiting)"
							end
							RunS.RenderStepped:Wait()
						end
					else
						C.Spectate()
						C.RemoveAction(Title)
						if self.LastSpotted then
							C.DoTeleport(self.LastSpotted)
							self.LastSpotted = false
						end
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						if self.RealEnabled and not firstRun then
							local Rifle = C.plr:WaitForChild("Backpack"):WaitForChild("M1 Garand",5)
							if Rifle then
								C.human:EquipTool(Rifle)
							end
						end
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				}
			},
			{
				Title = ({"OP","Balanced","NEENOO's","NotAVirus","Easy"})[math.random(1,5)].." God Mode",
				Tooltip = "Keeps you invulerable using a forcefield. Only works in planes and when unseated",
				Layout = 4, Functs = {}, Threads = {},
				Shortcut = "GodMode",
				Activate = function(self,newValue)
					if not C.char or not newValue then
						return
					end
					while true do
						if not C.isInGame(C.char) then
							task.wait(4) -- FF lasts for 20 seconds so we good
						end
						local FF = C.char:FindFirstChildWhichIsA("ForceField")
						if FF then
							FF.Visible = self.EnTbl.FFVisibility
							DS:AddItem(FF,15) -- Delete it after 15 seconds!
							FF.AncestryChanged:Wait() -- Wait until we're defenseless!
						elseif C.human.SeatPart then
							C.human:GetPropertyChangedSignal("SeatPart"):Wait()
						else
							C.RemoteEvent:FireServer("Teleport", {
								[1] = "Harbour",
								[2] = ""
							})
							task.wait(2) -- Wait a bit so it doesn't lag!
						end
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						task.delay(2,C.DoActivate,self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Forcefield Visibility",
						Tooltip = "Whether or not you can see your own forcefield. Disable for better visiblity.",
						Layout = 1,Default=false,
						Shortcut="FFVisibility",
					},
				},
			},
			{
				Title = "Projectile Hit",
				Tooltip = "Instantly hits enemies when shooting bullets",
				Layout = 4, Functs = {},
				Shortcut = "ProjectileHit",
				Activate = function(self,newValue)
					if not C.char then
						return
					end
					if newValue then
						local CurConn
						table.insert(self.Functs,UIS.InputBegan:Connect(function(inputObj, gameProcessed)
							if inputObj.KeyCode == Enum.KeyCode.F and not CurConn then
								local MyConn
								MyConn = workspace.ChildAdded:Connect(function(instance)
									task.wait(.1)
									if instance.Name == "bullet" and instance.Parent and MyConn == CurConn then
										local closestBasePart = C.getClosest(true,true)
										if closestBasePart then
											if self.EnTbl.Spectate then
												C.Spectate(closestBasePart.Parent)
											end
											--closestBasePart = game:GetService("Workspace").JapanDock.Decoration.ConcreteBases.ConcreteBase
											for s = 0, 1, 1 do
												C.firetouchinterest(instance,closestBasePart,0)
												task.wait()
												C.firetouchinterest(instance,closestBasePart,1)
												task.wait()
											end
										end
									end
								end)
								CurConn = MyConn 
								table.insert(self.Functs,CurConn)
							end
						end))
						table.insert(self.Functs,UIS.InputEnded:Connect(function(inputObj, gameProcessed)
							if inputObj.KeyCode == Enum.KeyCode.F then
								C.TblRemove(self.Functs,CurConn)
								if CurConn then
									CurConn:Disconnect()
									CurConn = nil
								end
								C.Spectate()
							end
						end))
					else
						C.Spectate()
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Spectate Users",
						Tooltip = "Whether or not spectate who you are killing.",
						Layout = 1,Default=true,
						Shortcut="Spectate",
					},
					{
						Type = Types.Dropdown, Selections = {"InGame"},
						Title = "Target Users",
						Tooltip = "Who on the enemy team to target. (PATCHED: Can only target INGAME players with NO FF)",
						Layout = 2,Default="InGame",
						Shortcut="Target",
					},
				},
			},
			{
				Title = "Anti Bounds",
				Tooltip = "Prevents your plane from going into the Pacific or exiting!",
				Layout = 5, Threads = {},
				Shortcut = "AntiBounds",
				Activate = function(self)
					if not C.char then
						return
					end
					if C.human.SeatPart then
						self.Events.MySeatAdded(self,C.human.SeatPart)
					end
				end,
				Events = {
					MySeatAdded = function(self,seatPart)
						local Vehicle = seatPart.Parent
						local HitCode = Vehicle:WaitForChild("HitCode",5)
						if not HitCode then return end
						local VehicleType = HitCode.Value
						local EnemyHarbor = workspace:WaitForChild(C.plr.Team.Name=="Japan" and "USDock" or "JapanDock")
						local HarborMainBody = EnemyHarbor:WaitForChild("MainBody")
						local LineVelocity = Vehicle:FindFirstChild("BodyVelocity",true)
						local MainVelocity = LineVelocity.Parent

						local BoundingSize = Vector3.new(10240,20e3,16384)

						local HarborSize = HarborMainBody.Size+Vector3.new(60,220,60)
						local HarborCF = HarborMainBody.CFrame*CFrame.new(0,-40,0)

						--The "BodyVelocity" is actually "LineVelocity"
						if VehicleType=="Plane" or VehicleType == "Ship" then
							while C.human and C.human.SeatPart == seatPart and self.RealEnabled do
								local BoundingCF = CFrame.new(0, BoundingSize.Y/2 + self.EnTbl.MinHeight, 0)
								local OldVelocity = MainVelocity.AssemblyLinearVelocity
								local GetOutSpeed = Vector3.zero
								--{PartCF,PartSize,isBlacklist} (All Three Arguments Required)
								local ListedAreas = {{BoundingCF,BoundingSize,false},{HarborCF,HarborSize,true}}
								for num, data in ipairs(ListedAreas) do
									if not C.IsInBox then
										warn("C.iSinbox not found/loaded!")
										continue
									end
									if C.IsInBox(data[1],data[2],seatPart.Position) == data[3] then
										local PullUpSpeed = self.EnTbl.PullUpSpeed
										GetOutSpeed += 
											((data[3] and C.ClosestPointOnPartSurface or C.ClosestPointOnPart)(data[1], data[2], seatPart.Position) 
												- seatPart.Position) * (data[3] and PullUpSpeed/3 or PullUpSpeed)
									end
								end
								if GetOutSpeed.Magnitude > .3 then
									local NewX, NewY, NewZ = OldVelocity.X, OldVelocity.Y, OldVelocity.Z
									if math.abs(GetOutSpeed.X) > .5 then
										NewX = GetOutSpeed.X
									end
									if math.abs(GetOutSpeed.Y) > .5 then
										NewY = GetOutSpeed.Y
									end
									if math.abs(GetOutSpeed.Z) > .5 then
										NewZ = GetOutSpeed.Z
									end
									MainVelocity.AssemblyLinearVelocity = Vector3.new(NewX,NewY,NewZ)
								end
								RunS.PreSimulation:Wait()
							end
						end
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "Pull Up Speed",
						Tooltip = "How fast you are re-orientated back to inside the bounds of the map.",
						Layout = 1,Default=30,
						Min=20,Max=40,Step=1,
						Shortcut="PullUpSpeed",
					},
					{
						Type = Types.Slider,
						Title = "Min Height",
						Tooltip = "The minimum y height a plane can be before it is pulled up using `Pull Up Speed`",
						Layout = 1,Default=10,
						Min=7,Max=13,Step=1,
						Shortcut="MinHeight",
					},
				},
			},
			{
				Title = "Hitbox Expander",
				Tooltip = "How large each ship's hitbox is",
				Layout = 6, Threads = {},
				Shortcut = "HitboxExpander",
				DontActivate = true,
				RunOnDestroy = function(self)
					self:Activate(false)
				end,
				ShipAdded=function(self,ship)
					local MainBody = ship:WaitForChild("MainBody")
					local Team = ship:WaitForChild("Team")
					local ExpandSize = Team.Value == C.plr.Team.Name and 0 or self.EnTbl.Size
					local DefaultSize = C.GetPartProperty(MainBody,"Size")

					if self.RealEnabled then
						C.SetPartProperty(MainBody,"Size","ShipHitboxExpander",DefaultSize + 2 * Vector3.one * ExpandSize, true)-- Times two in order to expand in EVERY direction
					else
						C.ResetPartProperty(MainBody,"Size","ShipHitboxExpander")
					end
				end,
				Activate=function(self,newValue)
					for num, ship in ipairs(C.Ships) do
						self:ShipAdded(ship)
					end
				end,
				MyTeamAdded=function(self,newTeam)
					self:Activate()
				end,
				Options = {
					{
						Type = Types.Slider,
						Title = "Size",
						Tooltip = "The size, in studs, that the hitboxes are expanded in every direction",
						Layout = 1,Default=2,
						Min=0.1,Max=10,Step=0.1,
						Shortcut="Size",
						Activate = C.ReloadHack,
					}
				}
			},
			{
				Title = "Bomb Instant Hit",
				Tooltip = "Bombs hit the closest target",
				Layout = 7, Functs = {},
				Shortcut = "BombInstantHit",
				Activate = function(self, newValue)
					-- Disconnect funct and set up childadded workspace event for the projectiles
					if newValue then
						table.insert(self.Functs,workspace.ChildAdded:Connect(function(instance)
							task.wait(.2)
							if instance.Name == "Bomb" and instance.Parent then
								local closestBasePart, distance
								if self.EnTbl.Base then
									closestBasePart, distance = C.getClosestBase()
								end
								local closestBasePart2, distance2
								if self.EnTbl.User then
									closestBasePart2, distance2 = C.getClosest()
								end
								local closestBasePart3, distance3
								if self.EnTbl.Ship then
									closestBasePart3, distance3 = C.getClosestShip()
								end
								if closestBasePart2 and (not closestBasePart or distance2 < distance) then
									closestBasePart, distance = closestBasePart2, distance2
								end
								if closestBasePart3 and (not closestBasePart or distance3 < distance) then
									closestBasePart, distance = closestBasePart3, distance3
								end
								print(closestBasePart, closestBasePart2)
								if closestBasePart then
									--closestBasePart = game:GetService("Workspace").JapanDock.Decoration.ConcreteBases.ConcreteBase
									for s = 0, 1, 1 do
										C.firetouchinterest(instance,closestBasePart,0)
										task.wait()
										C.firetouchinterest(instance,closestBasePart,1)
										task.wait()
									end
								end
							end
						end))
					end
				end,
				Options = {
					{
						Type = Types.Toggle,
						Title = "Bases",
						Tooltip = "Allows targets such as bases, i.e. harbours and enemy islands.",
						Layout = 1,Default=true,
						Shortcut="Base",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Ships",
						Tooltip = "Allows targets such as ships, i.e. subs and battleships.",
						Layout = 2,Default=true,
						Shortcut="Ship",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Users",
						Tooltip = "Allows targets such as individual users.",
						Layout = 3,Default=true,
						Shortcut="User",
						Activate = C.ReloadHack,
					}
				}
			},
			{
				Title = "Disable Kill Bricks",
				Tooltip = "Disables the Pacific Ocean kill floor (the grey blocks below the ocean 🌊🦈)",
				Layout = 100, Threads = {}, Default = true,
				Shortcut = "DisableKillBricks",
				ToggleColliders = function(self,Vehicle,Enabled)
					if not Vehicle then
						return
					end
					for num, part in ipairs(Vehicle:GetDescendants()) do
						if part:IsA("BasePart") then
							if Enabled then
								C.ResetPartProperty(part, "CanTouch", "AntiBounds")
							else
								C.SetPartProperty(part, "CanTouch", "AntiBounds",false)
							end
						end
					end
				end,
				Activate = function(self,newValue)
					local SeaFloorGroup = C.StringWait(workspace,"Setting.SeaFloor")
					for num, seaFloorPart in ipairs(SeaFloorGroup:GetChildren()) do
						if seaFloorPart:IsA("BasePart") then
							if newValue then
								C.SetPartProperty(seaFloorPart,"CanTouch","DisableKillBricks",false)
							else
								C.ResetPartProperty(seaFloorPart,"CanTouch","DisableKillBricks")
							end
						end
					end
				end,
				Events = {
					MySeatAdded = function(self,seatPart)
						local Vehicle = seatPart.Parent
						local HitCode = Vehicle:WaitForChild("HitCode",5)
						if not HitCode or HitCode.Value ~= "Plane" then
							return
						end
						while true do
							local isGrounded = seatPart.AssemblyLinearVelocity.Magnitude < 0.2
							self:ToggleColliders(Vehicle,isGrounded) -- Disable CanTouch colliders
							RunS.PreSimulation:Wait()
						end
					end,
					MySeatRemoved = function(self,seatPart)
						local Vehicle = seatPart.Parent
						self:ToggleColliders(Vehicle,true) -- Disable CanTouch colliders
					end,
				},
				Options = {
					
				},
			}
		}
	}
end
