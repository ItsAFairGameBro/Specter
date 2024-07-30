local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunS = game:GetService("RunService")
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
				Title = "Loop Kill Enemies",
				Tooltip = "Uses rifle to loop kill enemies.\nPlease note that people know who killed them",
				Layout = 2, Functs = {}, Threads = {},
				Shortcut = "LoopKillEnemies",
				Activate = function(self,newValue)
					local Title = "Loop Kill Enemies"
					if newValue then
						local actionClone = C.AddAction({Name=Title,Tags={"RemoveOnDestroy"},Stop=function(onRequest)
							self:SetValue(false)
						end,})
						if not actionClone then
							return
						end
						if not self.LastSpotted and C.char and C.hrp then
							self.LastSpotted = C.char:GetPivot()
						end
						local Time = actionClone:FindFirstChild("Time")
						local saveChar = C.char
						while Time and self.RealEnabled and C.char == saveChar and C.char.PrimaryPart and C.human and C.human.Health>0 do
							local theirHead, dist = C.getClosest()
							if theirHead then
								C.DoTeleport(theirHead.Parent:GetPivot() * CFrame.new(0,100,0))
								Time.Text = theirHead.Parent.Name
							else
								Time.Text = "(Waiting)"
							end
							--C.char.PrimaryPart.AssemblyLinearVelocity = Vector3.new()
							--C.char.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
							RunS.RenderStepped:Wait()
						end
					else
						C.RemoveAction(Title)
						if self.LastSpotted then
							C.DoTeleport(self.LastSpotted)
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
		}
	}
end
