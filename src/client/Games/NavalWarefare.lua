local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunS = game:GetService("RunService")
local DS = game:GetService("Debris")
local PS = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")
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

		["Bomber"]={Health=100,Type="Plane",MaxTorque=33.5e3,MaxForce=31148.7},
		["Torpedo Bomber"]={Health=100,Type="Plane",MaxTorque=33.5e3,MaxForce=31148.7},
		["Large Bomber"]={Health=300,Type="Plane",MaxTorque=13e4,MaxForce=71223.6},
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
		if not PrimaryPart or PrimaryPart.Position.Y < -103 then
			return false, player.Team -- Player, but in lobby!
		end

		return true, player.Team -- Player exists!
	end
    function C.getHealth(asset)
        local HP = asset:FindFirstChild("HP")
        if HP then
            return (asset:GetAttribute("Dead") or asset:GetAttribute("Ignore")) and 0 or HP.Value
        end
    end
	
	function C.getClosestBase(location: Vector3)
		local myHRPPos = location or (C.char and C.char.PrimaryPart and C.char:GetPivot().Position)
		if not myHRPPos then return end

		local selBase, maxDist = nil, math.huge
		for baseType, bases in pairs(C.Bases) do
			for num, base in ipairs(bases) do
				if base:FindFirstChild("Team") and base.Team.Value ~= "" and base.Team.Value ~= C.plr.Team.Name and C.getHealth(base) > 0 then
					local MainBody = base:WaitForChild("MainBody")
					local d = (MainBody.Position - myHRPPos).Magnitude
					if d < maxDist then
						if baseType == "Dock" then
							d -= 50
						end
						selBase, maxDist = MainBody, d
					end
				end
			end
		end
		return selBase, maxDist
	end
	local function CanTargetOwner(model: Model)
		local Owner = model:FindFirstChild("Owner")
		if Owner and Owner.Value ~= "" then
			local theirPlr = PS:FindFirstChild(Owner)
			if theirPlr and not C.CanTargetPlayer(theirPlr) then
				return false
			end
		end
		return true
	end
	function C.getClosestShip(location: Vector3)
		local myHRPPos = location or (C.char and C.char.PrimaryPart and C.char:GetPivot().Position)
		if not myHRPPos then return end

		local selShip, maxDist = nil, math.huge
		for num, ship  in pairs(C.Ships) do
			if ship:FindFirstChild("Team") and ship.Team.Value ~= "" and ship.Team.Value ~= C.plr.Team.Name and C.getHealth(ship) > 0 and CanTargetOwner(ship) then
				local MainBody = ship:WaitForChild("MainBody")
				local d = (MainBody.Position - myHRPPos).Magnitude
				if d < maxDist then
					selShip, maxDist = MainBody, d
				end
			end
		end
		return selShip, maxDist
	end
	function C.getClosestPlane(location: Vector3)
		local myHRPPos = location or (C.char and C.char.PrimaryPart and C.char:GetPivot().Position)
		if not myHRPPos then return end

		local selShip, maxDist = nil, math.huge
		for num, plane  in pairs(C.Planes) do
			if plane:FindFirstChild("Team") and plane.Team.Value ~= "" and plane.Team.Value ~= C.plr.Team.Name and C.getHealth(plane) > 0 and CanTargetOwner(plane) then
				local MainBody = plane:FindFirstChild("MainBody")
                if MainBody then
                    local d = (MainBody.Position - myHRPPos).Magnitude
                    if d < maxDist then
                        selShip, maxDist = MainBody, d
                    end
                end
			end
		end
		return selShip, maxDist / 1000
	end
	function C.VehicleTeleport(vehicle, loc, useCF)
		if not useCF then
			useCF = CFrame.new(loc.Position) * loc.Rotation
		end
		local HitCode = vehicle:FindFirstChild("HitCode")
		if HitCode then
			-- Get where the secondary turrets are relative to basepart
			local saveData = {}
			for num, model in ipairs(vehicle:GetChildren()) do
				if model.Name == "Turret" then
					table.insert(saveData,{model,model:GetPivot().Position - vehicle:GetPivot().Position,vehicle:GetPivot():ToObjectSpace(model:GetPivot())})
				end
			end
			-- Move the main object
			vehicle:PivotTo(loc)
			-- Move the secondary turret objects
			for num, data in ipairs(saveData) do
				local Turret, Offset, RelativeRotation = table.unpack(data)
				-- Calculate the new position for the turret
				local newTurretPos = loc.Position + Offset

				-- Calculate the new rotation for the turret
				local newTurretCFrame = loc * RelativeRotation

				-- Set the turret's new position and rotation
				Turret:PivotTo(newTurretCFrame)
			end
		else
			vehicle:PivotTo(loc)
		end
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
		C.AddGlobalConnection(workspace.ChildAdded:Connect(newChild))
		for num, instance in ipairs(workspace:GetChildren()) do
			newChild(instance)
		end
	end)
	function C.GetNearestTuple(tbl)
		local closestPart, closestDist = nil, math.huge
		for num, values in ipairs(tbl) do
			if values[1] and (not closestPart or values[2] < closestDist) then
				closestPart, closestDist = values[1], values[2]
			end
		end
		return closestPart,closestDist
	end
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
				Title = "Turret AimAssist",
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
									local u = C.getClosest({})
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
						local Target, Distance = C.getClosest({})
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
							local theirHead, dist = C.getClosest({})
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
            --
            {
				Title = "Switch Teams",
				Tooltip = "One click to change teams!",
				Layout = 4, Functs = {}, Threads = {},
				Shortcut = "ChangeTeams", Type = "NoToggle",
                Activate = function(self)
                    local part2Touch
                    if C.plr.Team.Name == "Japan" then
                        part2Touch = C.StringWait(workspace,"Lobby.TeamChange.ToUSA")
                    else
                        part2Touch = C.StringWait(workspace,"Lobby.TeamChange.ToJapan")
                    end
                    C.firetouchinterest(C.hrp, part2Touch)
                end,
            },
			--[[{
				Title = ({"OP","Balanced","NEENOO's","NotAVirus","Easy"})[math.random(1,5)].." God Mode",
				Tooltip = "Keeps you invulerable using a forcefield. Only works in planes and when unseated",
				Layout = 4, Functs = {}, Threads = {},
				Shortcut = "GodMode",
				Activate = function(self,newValue)
					if not C.char or not newValue then
						return
					end
					while C.human.Health > 0 do
						while not C.isInGame(C.char) do
							task.wait(4) -- FF lasts for 20 seconds so we good
						end
						local FF = C.char:FindFirstChildWhichIsA("ForceField")
						if FF then
							FF.Visible = not self.EnTbl.FFVisibility
							DS:AddItem(FF,15) -- Delete it after 15 seconds!
							FF.AncestryChanged:Wait() -- Wait until we're defenseless!
						elseif C.human.SeatPart then
							C.human:GetPropertyChangedSignal("SeatPart"):Wait()
						elseif C.human.Health > 0 then
							C.RemoteEvent:FireServer("Teleport", {
								[1] = "Harbour",
								[2] = ""
							})
							task.wait(2) -- Wait a bit so it doesn't lag!
						end
						RunS.RenderStepped:Wait()
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
						Title = "Disable Visibility",
						Tooltip = "Whether or not you can see your own forcefield. Disable for better visiblity.",
						Layout = 1,Default=true,
						Shortcut="FFVisibility",
					},
				},
			},--]]
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
										local nearestTbl = {}
										if self.EnTbl.Users then
											table.insert(nearestTbl,{C.getClosest({},instance.Position)})
										end
										if self.EnTbl.Planes then
											table.insert(nearestTbl,{C.getClosestPlane(instance.Position)})
										end
										local closestBasePart, distance = C.GetNearestTuple(nearestTbl)
										if closestBasePart then
											if self.EnTbl.Spectate then
												C.Spectate(closestBasePart.Parent)
											end
											--closestBasePart = game:GetService("Workspace").JapanDock.Decoration.ConcreteBases.ConcreteBase
											--[[for s = 0, 1, 1 do
												C.firetouchinterest(instance,closestBasePart,0)
												task.wait()
												C.firetouchinterest(instance,closestBasePart,1)
												task.wait()
											end--]]
											C.firetouchinterest(instance,closestBasePart)
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
						Type = Types.Toggle,
						Title = "Users",
						Tooltip = "Shoots users not in vehicles (PARTIALLY PATCHED: Can only target INGAME players with NO FF)",
						Layout = 2,Default=true,
						Shortcut="Users",
					},
					{
						Type = Types.Toggle,
						Title = "Planes",
						Tooltip = "Target enemy planes",
						Layout = 3,Default=true,
						Shortcut="Planes",
					},
					--[[{
						Type = Types.Dropdown, Selections = {"InGame"},
						Title = "Target Users",
						Tooltip = "Who on the enemy team to target. (PATCHED: Can only target INGAME players with NO FF)",
						Layout = 2,Default="InGame",
						Shortcut="Target",
					},--]]
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
								RunS.RenderStepped:Wait()
							end
						end
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "Pull Up Speed",
						Tooltip = "How fast you are re-orientated back to inside the bounds of the map.",
						Layout = 1,Default=20,
						Min=10,Max=40,Digits=0,
						Shortcut="PullUpSpeed",
					},
					{
						Type = Types.Slider,
						Title = "Min Height",
						Tooltip = "The minimum y height a plane can be before it is pulled up using `Pull Up Speed`",
						Layout = 1,Default=10,
						Min=0,Max=20,Digits=0,
						Shortcut="MinHeight",
					},
				},
			},
			{
				Title = "Hitbox Expander",
				Tooltip = "Expands enemy ship's hitbox, making them easier to hit!",
				Layout = 6, Threads = {},
				Shortcut = "HitboxExpander",
				DontActivate = true,
				RunOnDestroy = function(self)
					self:Activate(false)
				end,
				Activate=function(self,newValue)
					for num, ship in ipairs(C.Ships) do
						self.Events.ShipAdded(self,ship)
					end
				end,
				Events = {
					ShipAdded=function(self,ship)
						local MainBody = ship:WaitForChild("MainBody")
						local Team = ship:WaitForChild("Team")
						local ExpandSize = (Team.Value == C.plr.Team.Name or not self.RealEnabled) and 0 or self.EnTbl.Size
						local DefaultSize = C.GetPartProperty(MainBody,"Size")
	
						C.ResetPartProperty(MainBody,"Size","ShipHitboxExpander")

						if ExpandSize ~= 0 then
							local NewSize = DefaultSize + 2 * Vector3.one * ExpandSize
							C.SetPartProperty(MainBody,"Size","ShipHitboxExpander",NewSize, true, true)-- Times two in order to expand in EVERY direction
						end
					end,
					MyTeamAdded=function(self,newTeam)
						self:Activate()
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "Size",
						Tooltip = "The size, in studs, that the hitboxes are expanded in every direction",
						Layout = 1,Default=2,
						Min=0.1,Max=50,Digits=1,
						Shortcut="Size",
						Activate = C.ReloadHack,
					}
				}
			},
			{
				Title = "Bomb Hit",
				Tooltip = "Bombs hit the closest target",
				Layout = 7, Functs = {},
				Shortcut = "BombInstantHit",
				BombThrowTime = {},
				ComparePos = nil,
				Activate = function(self, newValue)
					-- Disconnect funct and set up childadded workspace event for the projectiles
					if newValue then
						if C.SeatPart then
							self.Events.MySeatAdded(self,C.SeatPart)
						end
					end
				end,
				Events = {
					MySeatAdded = function(self,seatPart)
						local deb = 0
						table.insert(self.Functs,workspace.ChildAdded:Connect(function(instance)
							if instance.Name ~= "Bomb" then
								return
							end
                            instance.CanTouch = false
							local Spectate = C.hrp and (instance.Position - (self.ComparePos or C.hrp.Position)).Magnitude < 90
							task.wait(.4)
							if instance.Parent then
								local nearestTbl = {}

								if self.EnTbl.Base then
									table.insert(nearestTbl,{C.getClosestBase(instance.Position)})
								end
								if self.EnTbl.Ship then
									table.insert(nearestTbl,{C.getClosestShip(instance.Position)})
								end
								if self.EnTbl.Plane then
									table.insert(nearestTbl,{C.getClosestPlane(instance.Position)})
								end

								local closestBasePart, distance = C.GetNearestTuple(nearestTbl)
								if closestBasePart then
                                    local closestParent = closestBasePart.Parent
									if self.EnTbl.Spectate and Spectate then
										deb+= 1 local saveDeb = deb
										C.Spectate(closestBasePart)
										task.delay(1,function()
											if deb == saveDeb then
												C.Spectate() -- undo it
											end
										end)
									end
									--closestBasePart = game:GetService("Workspace").JapanDock.Decoration.ConcreteBases.ConcreteBase
									instance.CanTouch = true
									--[[for s = 0, 1, 1 do
										C.firetouchinterest(instance,closestBasePart,0)
										task.wait()
										C.firetouchinterest(instance,closestBasePart,1)
										task.wait()
									end--]]
                                    local changedFunct = closestParent.HP.Changed:Connect(function(newVal)
                                        if newVal <= 0 then
                                            closestParent:SetAttribute("Dead",true)
                                        end
                                    end)
                                    local setIgnore = false
                                    if closestParent.HP.Value <= 300 then
                                        closestParent:SetAttribute("Ignore",true)
                                        setIgnore = true
                                    end
									C.firetouchinterest(instance,closestBasePart)
                                    task.wait(2/3)
                                    changedFunct:Disconnect()
                                    if setIgnore then
                                        closestParent:SetAttribute("Ignore",nil)
                                    end
								else
									instance.CanTouch = true
								end
							end
						end))
					end,
                    MySeatRemoved = C.ReloadHack,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Bases",
						Tooltip = "Allows targets such as bases, i.e. harbours and enemy islands.",
						Layout = 1,Default=true,
						Shortcut="Base",
					},
					{
						Type = Types.Toggle,
						Title = "Ships",
						Tooltip = "Allows targets such as ships, i.e. subs and battleships.",
						Layout = 2,Default=true,
						Shortcut="Ship",
					},
					{
						Type = Types.Toggle,
						Title = "Planes",
						Tooltip = "Allows targets such as individual users.",
						Layout = 3,Default=true,
						Shortcut="Plane",
					},
					{
						Type = Types.Toggle,
						Title = "Spectate",
						Tooltip = "Spectates who you did dirty..",
						Layout = 4,Default=true,
						Shortcut="Spectate",
					}
				}
			},
			{
				Title = "Disable Kill Bricks",
				Tooltip = "Disables the Pacific Ocean kill floor (the grey blocks below the ocean 🌊🦈)",
				Layout = 100, Threads = {}, Default = true,
				Shortcut = "DisableKillBricks",
				SetPartEn = function(self,part,en)
					if en then
						C.ResetPartProperty(part, "CanTouch", "DisableKillBricks")
					else
						C.SetPartProperty(part, "CanTouch", "DisableKillBricks",false)
					end
				end,
				ToggleVehicleColliders = function(self,Vehicle,Enabled)
					if not Vehicle then
						return
					end
					for num, part in ipairs(Vehicle:GetDescendants()) do
						if part:IsA("BasePart") then
							self:SetPartEn(part,Enabled)
						end
					end
				end,
				ToggleBaseColliders = function(self,Enabled)
					local EnemyHarbor = C.plr.Team.Name == "Japan" and workspace:WaitForChild("USDock") or workspace:WaitForChild("JapanDock")
					for num, part in ipairs(C.StringWait(EnemyHarbor,"Decoration.ConcreteBases"):GetChildren()) do
						if part:IsA("BasePart") then
							self:SetPartEn(part,Enabled)
						end
					end
					self:SetPartEn(EnemyHarbor:WaitForChild("MainBody"),Enabled)
				end,
				Activate = function(self,newValue)
					local SeaFloorGroup = C.StringWait(workspace,"Setting.SeaFloor")
					for num, seaFloorPart in ipairs(SeaFloorGroup:GetChildren()) do
						if seaFloorPart:IsA("BasePart") then
							self:SetPartEn(seaFloorPart,not newValue)
						end
					end
					if C.human and C.human.SeatPart then
						self.Events.MySeatAdded(self,C.human.SeatPart)
					else
						self:ToggleBaseColliders(not newValue)
					end
				end,
				Events = {
					MySeatAdded = function(self,seatPart)
						local Vehicle = seatPart.Parent
						local HitCode = Vehicle:WaitForChild("HitCode",5)
						if not HitCode or HitCode.Value ~= "Plane" then
							return
						end
						local LineVelocity = Vehicle:WaitForChild("MainBody"):WaitForChild("BodyVelocity")
						while self.EnTbl.PlaneHitbox and C.SeatPart == seatPart do
							local isGrounded = LineVelocity.MaxForce < 2
							self:ToggleVehicleColliders(Vehicle,isGrounded) -- Disable CanTouch colliders
							self:ToggleBaseColliders(not isGrounded)
							RunS.RenderStepped:Wait()
						end
						self.Events.MySeatRemoved(self,seatPart)
					end,
					MySeatRemoved = function(self,seatPart)
						local Vehicle = seatPart.Parent
						self:ToggleVehicleColliders(Vehicle,true) -- Disable CanTouch colliders
						self:ToggleBaseColliders(false)
					end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Plane Hitbox",
						Tooltip = "Disables Plane Hitbox.",
						Layout = 1,Default=true,
						Shortcut="PlaneHitbox",
						Activate = C.ReloadHack,
					}
				},
			},
			{
				Title = "ESP Island Capture",
				Tooltip = "Adds a button to capture neutral islands automatically",
				Layout = 30, Threads = {}, Instances = {}, Functs = {}, Default = true,
				Shortcut = "ESPIslandCapture",
				DontActivate = true,
				Activate=function(self,newValue)
					if not newValue then
						return
					end
					for num, island in pairs(C.Bases.Island) do
						self.Events.IslandAdded(self,island)
					end
				end,
				Events = {
					IslandAdded=function(self,island)
						local newTag=C.Examples.ToggleTagEx:Clone()
						newTag.Name = "Island"
						newTag.Parent=C.GUI
						newTag.StudsOffsetWorldSpace = Vector3.new(0, 45, 0)
						newTag.ExtentsOffsetWorldSpace = Vector3.zero
		
						table.insert(self.Instances,newTag)
						C.AddObjectConnection(island,"ESPIslandCapture",island.Destroying:Connect(function()
							newTag:Destroy()
						end))
						local TeamVal = island:WaitForChild("Team")
						local HPVal = island:WaitForChild("HP")
						local IslandCode = island:WaitForChild("IslandCode").Value
						local FlagPad = island:WaitForChild("Flag"):WaitForChild("FlagPad")
						local button = newTag:WaitForChild("Toggle")
						local isEn = false
						local Info = {Name="Capturing "..IslandCode,Tags={"RemoveOnDestroy"}}
						local function activate(new)
							isEn = new
							button.Text = isEn and "Pause" or "Capture"
							button.BackgroundColor3 = isEn and Color3.fromRGB(255) or Color3.fromRGB(170,0,255)
							if new then
								local ActionClone = C.AddAction(Info)
								local Touching = false
								while Info.Enabled and TeamVal.Value == "" and ActionClone and ActionClone.Parent do
									C.SetActionPercentage(ActionClone, HPVal.Value / C.DataStorage.Island.Health)
									Touching = not Touching
									local PrimaryPart = C.char and C.char.PrimaryPart
									if PrimaryPart then
										--C.firetouchinterest(C.char.PrimaryPart, FlagPad, Touching and 0 or 1)
										C.firetouchinterest(C.char.PrimaryPart, FlagPad, Touching and 0 or 1)
									end
									RunS.RenderStepped:Wait()
								end
								return activate(false) -- Disable it
							end
							C.RemoveAction(Info.Name)
						end
						button.MouseButton1Up:Connect(function()
							activate(not isEn)
						end)
						activate(isEn)
						local function UpdVisibiltiy()
							button.Visible = TeamVal.Value == ""
						end
						table.insert(self.Functs,TeamVal:GetPropertyChangedSignal("Value"):Connect(UpdVisibiltiy))
						UpdVisibiltiy()
						newTag.Adornee=FlagPad
						newTag.Enabled = true
					end,
				}
			},
			{
				Title = "ESP Loop Bomb",
				Tooltip = "Adds a button above objectives to bomb them continously",
				Layout = 31, Threads = {}, Instances = {}, Functs = {}, Default = true,
				Shortcut = "ESPLoopBomb",
				DontActivate = true,
				RefreshEn=function(self,tag)
					if not tag.Adornee then
						return
					end
					local Base = tag.Adornee.Parent
					if Base then
						local Team = Base:WaitForChild("Team",5)
						if Team and C.getHealth(Base) > 0 then
							local Plane = C.human and C.human.SeatPart and C.human.SeatPart.Parent
							if Plane and C.human.SeatPart.Name == "Seat" then
								local HitCode = Plane:FindFirstChild("HitCode")
								if HitCode and HitCode.Value == "Plane" then
									tag.Enabled = self.RealEnabled and Team.Value ~= C.plr.Team.Name and Team.Value ~= ""
									return
								end
							end
                        elseif Base:FindFirstChild("HP") and Base.HP.Value == 0 then
                            Base:SetAttribute("Dead",true)
						end
					end
					tag.Enabled = false
				end,
				RefreshAllTags = function(self)
					for num, tag in ipairs(self.Instances) do
						self:RefreshEn(tag)
					end
				end,
				Activate=function(self,newValue)
					if not newValue then
						C.RemoveAction("LoopBomb")
						return
					end
					for name, data in pairs(C.Bases) do
						for num, island in ipairs(data) do
							task.spawn(self.Events.IslandAdded,self,island)
						end
					end
					for num, ship in ipairs(C.Ships) do
						table.insert(self.Threads,task.spawn(self.Events.ShipAdded,self,ship))
					end
				end,
				Events = {
					MyTeamAdded=function(self)
						self:RefreshAllTags()
					end,
					MySeatAdded=function(self)
						self:RefreshAllTags()
					end,
					MySeatRemoved = function(self)
						self:RefreshAllTags()
					end,
					IslandAdded=function(self,island)
						local DropOffset = 250
						local TimeFromDropToExpl = math.sqrt(DropOffset/workspace.Gravity)
						
						local newTag=C.Examples.ToggleTagEx:Clone()
						newTag.Name = "LoopBombESP"
						newTag.Parent=C.GUI
						newTag.ExtentsOffsetWorldSpace = Vector3.zero
						table.insert(self.Instances, newTag)
		
						C.AddObjectConnection(island,"Parent",island:GetPropertyChangedSignal("Parent"):Connect(function()
							newTag:Destroy()
						end))
						local IslandData = C.DataStorage[island.Name]
						local TeamVal = island:WaitForChild("Team",15)
						if not TeamVal then
							return
						end
						local HPVal = island:WaitForChild("HP")
						local HitCode = island:WaitForChild("HitCode").Value
						local IslandBody = island:WaitForChild("MainBody")
						local button = newTag:WaitForChild("Toggle")
						local isEn = false
						local Info = {Name="LoopBomb",Title="Bombing "..HitCode,Tags={"RemoveOnDestroy"}}
						newTag.StudsOffsetWorldSpace = Vector3.new(0, HitCode=="Dock" and 120 or 60, 0)
						local function basebomb_activate(new)
							button.Text = new and "Pause" or "Bomb"
							button.BackgroundColor3 = new and Color3.fromRGB(255) or (HitCode=="Dock" and Color3.fromRGB(170,0,255) or Color3.fromRGB(170,255))
							if new then
								if C.GetAction(Info.Name) then
									C.RemoveAction(Info.Name)
									RunS.RenderStepped:Wait()
								end
								
								
								local Plane = C.human.SeatPart and C.human.SeatPart.Parent
								if not Plane then
									return basebomb_activate(false)
								end
								local PlaneMB = Plane:WaitForChild("MainBody")
								local BombC = Plane:WaitForChild("BombC")
								local ActionClone = C.AddAction(Info)
								
								local IslandLoc
								
								local HalfSize = IslandBody.Size/4 -- Make it a quarter so it doesn't miss!
								local Randomizer = Random.new()
								
								local XOfffset,ZOffset
								local TargetCF
								
								local function CalculateNew(Regenerate)
									if Regenerate or not XOfffset then
										XOfffset,ZOffset = Randomizer:NextNumber(-HalfSize.X,HalfSize.X), Randomizer:NextNumber(-HalfSize.Z,HalfSize.Z)
									end
									IslandLoc = IslandBody:GetPivot() + (IslandBody.AssemblyLinearVelocity * TimeFromDropToExpl)
									TargetCF = IslandLoc * CFrame.new(XOfffset,0,ZOffset) + Vector3.new(0,DropOffset,0)
								end
														
								local WhileIn = 0
								while Info.Enabled and TeamVal.Value ~= "" and TeamVal.Value ~= C.plr.Team.Name and ActionClone and ActionClone.Parent and island.Parent
									and C.human.SeatPart and C.human.SeatPart.Parent == Plane and HPVal.Value > 0 do
									CalculateNew(Randomizer:NextInteger(1,5) == 1)
									if not C.GetAction("Plane Refuel") and BombC.Value > 0 then
										PlaneMB.AssemblyLinearVelocity = TargetCF.Position - PlaneMB.Position
										if BombC.Value > 0 and WhileIn>.5 then
											WhileIn = 0
											C.RemoteEvent:FireServer("bomb")
											local savePos = C.hrp.Position
											local data = C.hackData.NavalWarefare.BombInstantHit
											data.ComparePos = savePos
											task.delay(.6,function()
												if data.ComparePos == savePos then
													data.ComparePos = nil
												end
											end)
										end
									elseif BombC.Value == 0 and not C.enHacks.NavalWarefare.PlaneRestock.En then
										break
									end
									C.SetActionPercentage(ActionClone,1-(HPVal.Value / IslandData.Health))
									local Distance = ((PlaneMB:GetPivot().Position - TargetCF.Position)/Vector3.new(1,1000,1)).Magnitude
									if Distance > 30 and not C.GetAction("Plane Refuel") then
										C.VehicleTeleport(Plane,TargetCF)
									end
									if Distance < 300 then
										WhileIn += RunS.RenderStepped:Wait()
									else
										WhileIn = 0
										RunS.RenderStepped:Wait()
									end
								end
								isEn = true
								return basebomb_activate(false) -- Disable it
							elseif isEn then -- Disable only if we WERE bombing earlier!
								C.RemoveAction(Info.Name)
							end
							isEn = new
						end
						button.MouseButton1Up:Connect(function()
							basebomb_activate(not isEn)
						end)
						table.insert(self.Threads,task.spawn(basebomb_activate,isEn))
						local function UpdVisibiltiy()
							self:RefreshEn(newTag)
						end
						C.AddObjectConnection(TeamVal,"LoopBomb",TeamVal:GetPropertyChangedSignal("Value"):Connect(UpdVisibiltiy))
						C.AddObjectConnection(HPVal,"LoopBomb",HPVal:GetPropertyChangedSignal("Value"):Connect(UpdVisibiltiy))
						newTag.Adornee=IslandBody
						UpdVisibiltiy()
					end,
					DockAdded=function(self,dock)
						self.Events.IslandAdded(self,dock)
					end,
					ShipAdded=function(self,ship)
						self.Events.IslandAdded(self,ship)
					end,
				}
			},
			{
				Title = "Plane Restock",
				Tooltip = "Refuels when things like ammo, bombs, or health are below certain configurable thresholds",
				Layout = 10, Threads = {}, Functs = {}, Default = true,
				Shortcut = "PlaneRestock",
				DontActivate = true,
				Activate=function(self,newValue)
					if not newValue then
						self.Events.MySeatRemoved(self) -- Cancel the action
					elseif C.human.SeatPart then
						self.Events.MySeatAdded(self,C.human.SeatPart)
					end
				end,
				Events = {
					MySeatAdded=function(self,seatPart)
						self.Events.MySeatRemoved(self)
						local Plane = seatPart.Parent
						local HitCode = Plane:WaitForChild("HitCode",5)
						local MainBody = Plane.PrimaryPart
						if HitCode and MainBody and HitCode.Value == "Plane" then
							local HP = Plane:WaitForChild("HP")
							local Fuel = Plane:WaitForChild("Fuel")
							local AmmoC = Plane:FindFirstChild("BulletC1")
							local AmmoC2 = Plane:FindFirstChild("BulletC2")
							local BombC = Plane:WaitForChild("BombC")
							local Conn
							local function canRun(toRun)
								return MainBody and Plane.Parent and table.find(self.Functs,Conn) and not MainBody:FindFirstChild("weldConstraint")
									and C.human and seatPart == C.human.SeatPart and not C.Cleared
									and (not toRun or 
										((self.EnTbl.Bomb and BombC.Value == 0) 
											or (self.EnTbl.MinHPPercentage*C.DataStorage[Plane.Name].Health/100>=HP.Value)
											or (self.EnTbl.Fuel and Fuel.Value <= 3))
											or (self.EnTbl.Ammo and ((AmmoC and AmmoC.Value <= 30) or (AmmoC2 and AmmoC2.Value <= 0)))
										)
							end
							local function HarborRefuel()
								local Harbor = workspace:WaitForChild(C.plr.Team.Name:gsub("USA","US").."Dock")
								local HarborMain = Harbor:WaitForChild("MainBody")
								local MainBody = Plane:WaitForChild("MainBody")
								local Origin = Plane:GetPivot()
								local Info = {Name="Plane Refuel",Tags={"RemoveOnDestroy"},Stop=function(onRequest)
									if not C.GetAction("LoopBomb") then
										C.VehicleTeleport(Plane,Origin)
									end
									if onRequest then
										self:SetValue(false)
									elseif seatPart ~= C.human.SeatPart then
										self:ClearData()
									end
								end,}
								local actionClone = C.AddAction(Info)
								if actionClone then
									actionClone:WaitForChild("Time").Text = "~2s"
								end
								while canRun(true) and Info.Enabled do
									if (Plane:GetPivot().Position - HarborMain.Position).Magnitude > 30 then
										C.VehicleTeleport(Plane,HarborMain:GetPivot() * CFrame.new(0,45,15))
									end
									MainBody.AssemblyLinearVelocity = Vector3.new()
									--MainBody.AssemblyAngularVelocity = Vector3.new()
									RunS.RenderStepped:Wait()
								end
							end
							local function CheckDORefuel(newBomb)
								if newBomb ~= nil then
									task.wait(1/3) -- wait for the bomb to spawn!
								end
								if not canRun() then
									return
								end
								if canRun(true) then
									HarborRefuel()
								else -- Refueled!
									C.RemoveAction("Plane Refuel")
								end
							end
							Conn = BombC.Changed:Connect(CheckDORefuel)
							table.insert(self.Functs,Conn)
							table.insert(self.Functs,HP.Changed:Connect(CheckDORefuel))
							table.insert(self.Functs,Fuel.Changed:Connect(CheckDORefuel))
							table.insert(self.Functs,MainBody.ChildRemoved:Connect(CheckDORefuel))
							CheckDORefuel()
						end
					end,
					MySeatRemoved = function(self)
						C.RemoveAction("Plane Refuel")
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "HP",
						Tooltip = "Refuels when your health is below this percentage",
						Layout = 0,Default=99,
						Min=0,Max=99,Digits=0,
						Shortcut="MinHPPercentage",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Ammo",
						Tooltip = "Refuels when ammo is low",
						Layout = 1,Default=true,
						Shortcut="Ammo",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Bomb",
						Tooltip = "Refuels when bombs are out",
						Layout = 2,Default=true,
						Shortcut="Bomb",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Fuel",
						Tooltip = "Refuels when fuel is out",
						Layout = 3,Default=true,
						Shortcut="Fuel",
						Activate = C.ReloadHack,
					},
				},
			},
			{
				Title = "Vehicle",
				Tooltip = "Allows you to modify speed for ships and planes",
				Layout = 11, Functs = {}, Default = true,
				Shortcut = "VehicleSpeed",
				DontActivate = true,
				Activate = function(self,newValue)
					if C.human and C.human.SeatPart then
						if newValue then
							self.Events.MySeatAdded(self,C.human.SeatPart)
						else
							self.Events.MySeatRemoved(self,C.human.SeatPart)
						end
					end
				end,
				Set = function(self, Vehicle, LineVelocity, AlignOrientation, SpeedMult, TurnMult)
					--print("SEt",Vehicle,SpeedMult,TurnMult)
					local VehicleType = Vehicle:WaitForChild("HitCode").Value
					local FuelLeft = VehicleType == "Plane" and Vehicle:WaitForChild("Fuel")
					local FlyButton = C.StringWait(C.PlayerGui,"ScreenGui.InfoFrame.Fly")
					local MyData = C.DataStorage[Vehicle.Name]
					if not MyData.MaxTorque or not MyData.MaxForce then
						return
					end

					local isOn = (VehicleType == "Ship" or FlyButton.BackgroundColor3.R*255>250) and (not FuelLeft or (FuelLeft:GetAttribute("RealFuel") or FuelLeft.Value) > 0)
						--(FlyButton.BackgroundColor3.R*255>250 and self.EnTbl.InfFuel and false))

					self.LastSet = SpeedMult * LineVelocity.VectorVelocity
					LineVelocity.VectorVelocity = self.LastSet
					C.SetPartProperty(LineVelocity,"MaxAxesForce","VehicleHack",C.GetPartProperty(LineVelocity,"MaxAxesForce") * SpeedMult,true)
					C.SetPartProperty(LineVelocity,"MaxForce","VehicleHack",isOn and (MyData.MaxForce * SpeedMult) or 0,true)
					--LineVelocity.MaxForce = isOn and (MyData.MaxForce * SpeedMult) or 0
					--C.SetPartProperty(LineVelocity,"MaxForce","VehicleHack", isOn and (MyData.MaxForce * math.max(1,SpeedMult/6)) or 0, true) --* SpeedMult/8) or 0
					--(VehicleType=="Ship" and 49.281604e6 or 31.148e3)
					--C.SetPartProperty(AlignOrientation,"Responsiveness","VehicleHack",C.GetPartProperty(AlignOrientation,"Responsiveness") * (TurnMult*16),true)
					if AlignOrientation then
						AlignOrientation.MaxTorque = isOn and (MyData.MaxTorque * TurnMult) or 0
					end
					local Collisions = not self.EnTbl.NoCollisions or not isOn
					if Vehicle.PrimaryPart:GetAttribute("CanCollide_Request_VehicleHack") ~= (Collisions and nil) then
						self:SetCollisions(Vehicle,Collisions)
					end
				end,
				SetCollisions = function(self,Vehicle,Collidible)
					for num, basePart in ipairs(Vehicle:GetDescendants()) do
						if basePart:IsA("BasePart") then
							if Collidible then
								C.ResetPartProperty(basePart,"CanCollide","VehicleHack")
							else
								C.SetPartProperty(basePart,"CanCollide","VehicleHack",false)
							end
						end
					end
				end,
				LastSet = nil,
				Events = {
					MySeatAdded = function(self,seatPart)
						self.Events.MySeatRemoved(self,seatPart)
						local Vehicle = seatPart.Parent
						local HitCode = Vehicle:WaitForChild("HitCode",5)
						local FlyButton = C.StringWait(C.PlayerGui,"ScreenGui.InfoFrame.Fly")
						--The "BodyVelocity" is actually "LineVelocity"
						if HitCode and ((HitCode.Value == "Ship" and self.EnTbl.Ship) or (HitCode.Value == "Plane" and self.EnTbl.Plane)) then
							local MainBody = Vehicle:WaitForChild("MainBody")
							local LineVelocity = MainBody:WaitForChild("BodyVelocity")
							local VehicleType = Vehicle:WaitForChild("HitCode").Value
							local FuelLeft = HitCode.Value == "Plane" and Vehicle:WaitForChild("Fuel")
							local AlignOrientation = LineVelocity.Parent:FindFirstChildWhichIsA("AlignOrientation")
							self.LastSet = nil
							local function Upd()
								if self.LastSet and (LineVelocity.VectorVelocity - self.LastSet).Magnitude < 0.3 then
									return
								end
								local SpeedMult = self.EnTbl[HitCode.Value .. "Speed"]
								if VehicleType=="Ship" then
									SpeedMult = math.min(SpeedMult,1.8)
								end
								local TurnMult = SpeedMult--self.EnTbl[HitCode.Value .. "Turn"] or 1
								if C.GetAction("LoopBomb") or C.GetAction("Plane Refuel") then
									SpeedMult,TurnMult = 0, 0 -- Override to stop it from moving!
								end
								if FuelLeft then
									if self.EnTbl.InfFuel and false then
										if FuelLeft.Value < 500 then
											FuelLeft:SetAttribute("RealFuel",FuelLeft.Value)
										end
										FuelLeft.Value = 999999
									elseif FuelLeft:GetAttribute("RealFuel") then
										FuelLeft.Value = FuelLeft:GetAttribute("RealFuel")
									end
								end
								self:Set(Vehicle,LineVelocity,AlignOrientation,SpeedMult,TurnMult)
							end
							table.insert(self.Functs,LineVelocity:GetPropertyChangedSignal("VectorVelocity"):Connect(Upd))
							Upd()
						end
					end,
					MySeatRemoved = function(self, seatPart)
						self:ClearData()
						local Vehicle = seatPart.Parent
						if Vehicle and Vehicle.PrimaryPart then
							Vehicle.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
							Vehicle.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
							local MainBody = Vehicle:WaitForChild("MainBody")
							local LineVelocity = MainBody:WaitForChild("BodyVelocity")
							local AlignOrientation = LineVelocity.Parent:FindFirstChildWhichIsA("AlignOrientation")
							self:Set(Vehicle,LineVelocity,AlignOrientation,1, 1)
						end
					end,
                    PlaneAdded = function(self, vehicle)
                        if not self.EnTbl.AutoSit then
                            return
                        end
                        local owner = vehicle:FindFirstChild("Owner")
                        if owner then
                            if owner.Value == C.plr.Name then
                                vehicle.Seat:Sit(C.human)
                            end
                        end
                    end,
                    ShipAdded = function(self, ship)
                        self.Events.PlaneAdded(self,ship)
                    end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Ships",
						Tooltip = "Injects into Ships (i.e. submarines, battleships, carriers, cruisers)",
						Layout = 1,Default=true,
						Shortcut="Ship",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Planes",
						Tooltip = "Injects into Planes (i.e. Heavy Bomber, Torpedo Bomber, Bomber)",
						Layout = 2,Default=true,
						Shortcut="Plane",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "No Collisions",
						Tooltip = "Allows vehicles that you drive to go through collidble objects",
						Layout = 3,Default=false,
						Shortcut="NoCollisions",
					},
                    {
						Type = Types.Toggle,
						Title = "Auto Sit",
						Tooltip = "Automatically makes you sit in the pilot seat of a ship you spawned",
						Layout = 4,Default=false,
						Shortcut="AutoSit",
					},
					--[[{
						Type = Types.Toggle,
						Title = "Inf Fuel",
						Tooltip = "Tricks the game into thinking that you have infinite fuel",
						Layout = 4,Default=true,
						Shortcut="InfFuel",
					},--]]
					{
						Type = Types.Slider,
						Title = "Plane Speed",
						Tooltip = "How much faster you go when driving a plane",
						Layout = 5,Default=3,
						Min=0,Max=20,Digits=1,
						Shortcut="PlaneSpeed",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Slider,
						Title = "Ship Speed",
						Tooltip = "How much faster you go when driving a ship",
						Layout = 6,Default=3,
						Min=0,Max=20,Digits=1,
						Shortcut="ShipSpeed",
						Activate = C.ReloadHack,
					},
				}
			}
		}
	}
end
