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
	function C.getClosest(canBeInLobby:boolean,notSeated:boolean)
		local myHRP = C.char and C.char.PrimaryPart
		if not C.human or C.human.Health <= 0 or not myHRP then return end


		local closest = nil;
		local distance = math.huge;


		for i, v in pairs(PS.GetPlayers(PS)) do
			if not C.CanTargetPlayer(v) then continue end
			local theirChar = v.Character
			if not theirChar then continue end
			local isInGame,team = C.isInGame(theirChar)
			if not isInGame and not canBeInLobby then continue end
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
						table.insert(self.Functs,UIS.InputBegan:Connect(function(inputObj, gameProcessed)
							if inputObj.KeyCode == Enum.KeyCode.F then
								print("inserted")
								table.insert(self.Functs,workspace.ChildAdded:Connect(function(instance)
									task.wait(.1)
									if instance.Name == "bullet" and instance.Parent then
										local closestBasePart = C.getClosest(self.EnTbl.Target=="All",true)
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
								end))	
							end
						end))
						table.insert(self.Functs,UIS.InputEnded:Connect(function(inputObj, gameProcessed)
							if inputObj.KeyCode == Enum.KeyCode.F then
								print('deleted',#self.Functs[3])
								if self.Functs[3] then
									self.Functs[3]:Disconnect()
									table.remove(self.Functs,3)
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
						Type = Types.Dropdown, Selections = {"InGame","All"},
						Title = "Target Users",
						Tooltip = "Who on the enemy team to target.",
						Layout = 2,Default="All",
						Shortcut="Target",
					},
				},
			},
		}
	}
end
