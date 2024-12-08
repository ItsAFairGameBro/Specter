local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local DS = game:GetService("Debris")
local Players = game:GetService("Players")
local RunS = game:GetService("RunService")
local SocialService = game:GetService("SocialService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local LS = game:GetService("Lighting")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local GamePlaceIds = {
	["N/A"]=0,
	["Lobby"]=45146873,
	["Halloween"]=45200529,
	["Arena (Versus)"]=46955756,
	["Survival"]=49707852,
	["Christmas"]=1241893197,
	["Halloween 2018"]=2470348319,
	["Winter 2019"]=2776257214,
	["Halloween 2023"]=5645832762,
	["Winter 2022"]=8652280014,
}
local function Static(C, Settings)
	table.insert(C.EventFunctions,function()
		C.AddGlobalThread(task.spawn(function()
			local instance = workspace:WaitForChild("Map",1e9)
			C.Map = instance
			C.FireEvent("MapAdded",nil,instance)
		end))
	end)
    if game.PlaceId ~= GamePlaceIds.Lobby then
        table.insert(C.EventFunctions, (function()
            local Towers = workspace:WaitForChild("Towers")
            C.Towers = Towers
            local function TowerAdded(tower)
                C.FireEvent("TowerAdded", nil, tower)
            end
            local function TowerRemoved(tower)
                C.FireEvent("TowerRemoved", nil, tower)
            end
            C.AddGlobalConnection(Towers.ChildAdded:Connect(TowerAdded))
            C.AddGlobalConnection(Towers.ChildRemoved:Connect(TowerRemoved))
            for num, tower in ipairs(Towers:GetChildren()) do
                TowerAdded(tower)
            end
        end))
        table.insert(C.InsertCommandFunctions, function()

            return {
                ["zombiewalk"]={
                    Parameters = {{Type="Number",Min=0,Max=10,Default=0}},
                    Alias = {},
                    AfterTxt = "ing",
                    Threads = {},
                    Run = function(self, args)
                        if args[1] == 0 then
                            self:Reset(true)
                            return true
                        else
                            self:Reset()
                        end
                        local Nodes = C.StringFind(C.Map,`{C.plr.Team.Name}Nodes`)
                        if not Nodes then
                            return false, "Map Not Yet Loaded!"
                        end
                        self.Parent.scale:Run({{C.plr}, 1/3})
                        C.SetPartProperty(C.human, "WalkSpeed", "ZombieWalk", args[1])
                        table.insert(self.Threads, task.spawn(function()
                            while true do
                                C.DoTeleport(Nodes.Start.Position)
                                local index = 1
                                while true do
                                    local current = Nodes:FindFirstChild(tostring(index))
                                    if not current then
                                        index = "Finish"
                                        continue
                                    end
                                    if typeof(index) == "number" then
                                        index+=1
                                    end
                                    local target = current.centAt.WorldPosition
                                    --while ((target - C.hrp.Position)/Vector3.new(1,math.huge,1)).Magnitude > 1 do
                                    C.human:MoveTo(target)
                                    --task.wait(1/5)
                                    --end
                                    C.human.MoveToFinished:Wait()
                                    if index == "Finish" then
                                        break
                                    end
                                end
                            end
                        end))
                        return true, ""
                    end,
                    RunOnDestroy = function(self,softReset)
                        self:Reset(true)
                    end,
                    Reset = function(self, hardReset)
                        C.ClearThreadTbl(self.Threads)
                        if hardReset then
                            self.Parent.scale:Run({{C.plr}, 1})
                            C.ResetPartProperty(C.human, "WalkSpeed", "ZombieWalk")
                            if C.hrp and C.human then
                                C.human:MoveTo(C.hrp.Position)
                            end
                        end
                    end
                }
            }
        end)
    end
	C.PlayerInformation = C.plr:WaitForChild("Information")
end
return function(C,Settings)
	Static(C,Settings)
	local TabTbl
	local IsPlacing = false
	local IgnorePoints = {}
	local CashVal,TowerCount, TowerCap
	if game.PlaceId ~= GamePlaceIds.Lobby then
		CashVal = C.PlayerInformation:WaitForChild("Cash")
		TowerCount = C.PlayerInformation:WaitForChild("Towers")
		TowerCap = workspace:WaitForChild("TowerCap").Value
	end
	local function PlaceTroop(TroopName)
		if IsPlacing then return false, "Placement In Progress" end
		local TowerInformation = workspace:WaitForChild("TowerInformation")[TroopName]
		if TowerInformation.Value > C.PlayerInformation.Cash.Value then
			return false,
				C.CreateSysMessage(("Not Enough Cash: $%i Needed)"):format(TowerInformation.Value - C.PlayerInformation.Cash.Value))
		elseif TowerCount.Value >= TowerCap then
			return false,
				C.CreateSysMessage(("Max Towers %i/%i)"):format(TowerCount.Value, TowerCap))
		elseif not C.Map then
			return false, C.CreateSysMessage(`Map Not Found`)
		end
		IsPlacing = true

		local Path = {} -- Parts representing the path
		local StartTime = os.clock()

		local Range -- Range of the troop
		local PlacementType -- "Grass" / "High"
		local MinDistBetweenTroops = 4.5

		local TroopTemplate = not C.isStudio and LS.Placement[TroopName] -- Get the troop from ServerStorage
		local GroundY = C.Map:WaitForChild("Height").Value
		if TroopTemplate then
			local Default = TroopTemplate:IsA("Folder") and TroopTemplate.Default or TroopTemplate
			PlacementType = TroopTemplate.Type.Value
			Range = Default.Tower.Visibility.Mesh.Scale.X / 2
		end

		local BestPosition, BestPart = nil, nil -- Best troop placement
		local YOffset = 0
		local MaxCoveredArea = 0 -- Maximum total area covered

		-- Utility function to check if a point is within a circle
		local function isPointInCircle(point, circleCenter, radius)
			local dx = point.x - circleCenter.x
			local dz = point.z - circleCenter.z
			return (dx * dx + dz * dz) <= (radius * radius)
		end
		-- Function to calculate overlap area between a circle and a rectangle
		local function calculateCircleRectangleOverlap(circle, rect)
			local radius, circleCenter = circle.Size.Z / 2, circle.Position
			local rectSize, rectCenter = rect.Size, rect.Position

			if (C.ClosestPointOnPart(rect.CFrame, rectSize, circleCenter) - circleCenter).Magnitude > radius then
				return 0 -- disable for more thorough checking
			end
			-- Sample points inside the rectangle to check if they are inside the circle
			local sampleStepX = 1 / 2
			local sampleStepZ = 1 / 2

			local overlapCount = 0
			local totalSampleCount = 0


			-- Loop through the grid of points in the rectangle
			for x = rectCenter.x - rectSize.x / 2, rectCenter.x + rectSize.x / 2, sampleStepX do
				for z = rectCenter.z - rectSize.z / 2, rectCenter.z + rectSize.z / 2, sampleStepZ do
					local samplePoint = Vector3.new(x, 0, z)

					totalSampleCount = totalSampleCount + 1
					if isPointInCircle(samplePoint, circleCenter, radius) then
						overlapCount = overlapCount + 1
					end
				end
			end

			-- Calculate the percentage of samples that are within the circle
			local overlapArea = (overlapCount / totalSampleCount) * (rectSize.x * rectSize.z)

			return overlapArea
		end


		-- Function to calculate the total area covered for a given troop position
		local function CalculateTotalCoveredArea(troopPosition)
			local FakeRange = {
				Position = troopPosition,
				Orientation = Vector3.new(0,0,-90),
				Size = 2 * Vector3.new(10, Range, Range),
				Transparency = 0.8,
			}
			local totalCoveredArea = 0
			for _, part in pairs(Path) do
				totalCoveredArea = totalCoveredArea + calculateCircleRectangleOverlap(FakeRange, part)
			end
			return totalCoveredArea
		end

		-- Function to calculate the points inside a part
		local function calculatePointsInsideRotatedPart(part, step, yOffsetLocal)
			local points = {}

			-- Get part's position, size, and CFrame
			local position = part.Position -- Center of the part (Vector3)
			local size = C.GetPartGlobalSize(part) / Vector3.new(1.5,1,1.5) -- Size of the part (Vector3)
			local cframe = part.CFrame -- CFrame of the part (position and rotation)

			-- Calculate bounds in local space (assuming the part is centered at (0, 0) in local space)
			local minX = -(size.X / 2)
			local maxX = (size.X / 2)
			local minZ = -(size.Z / 2)
			local maxZ = (size.Z / 2)

			-- Iterate over the area using the step value (in local space)
			for x = minX, maxX, step do
				for z = minZ, maxZ, step do
					-- Create the point in local space
					local localPoint = Vector3.new(x, yOffsetLocal + size.Y/2, z) -- Flat part, so Z is 0
					local worldPoint = cframe.Position + (localPoint)
					table.insert(points, worldPoint)
				end
			end

			return points
		end

		local PotentialPositions = {}
		local Nodes = C.Map:WaitForChild("BlueNodes")
		local CurPart, LastPart, Index = nil, Nodes.Start, 0

		while not CurPart or CurPart.Name ~= "Finish" do
			Index += 1
			CurPart = Nodes:FindFirstChild(Index) or Nodes.Finish
			local newPart = Instance.new("Part",workspace.Camera)
			local startPosition, endPosition = LastPart.centAt.WorldPosition, CurPart.centAt.WorldPosition
			-- Calculate the midpoint between startPosition and endPosition
			local midPoint = (startPosition + endPosition) / 2

			-- Calculate the distance between the two points
			local distance = (endPosition - startPosition).Magnitude

			-- Position the part at the midpoint
			newPart.Position = midPoint

			-- Scale the part so that it spans the distance between the two points
			newPart.Size = Vector3.new(1, .5, distance)

			-- Align the part's CFrame to face the endPosition
			newPart.CFrame = CFrame.new(startPosition, endPosition) * CFrame.new(0, 0, -distance / 2)

			newPart.Anchored = true
			newPart.Name = "Path"..Index
			newPart.CanCollide, newPart.CanQuery = false, false
			newPart.CanTouch = false
			newPart.Transparency = .6
			newPart.Color = Color3.fromRGB(25,25,180)
			newPart.TopSurface = Enum.SurfaceType.Smooth
			newPart.BottomSurface = Enum.SurfaceType.Smooth
			table.insert(Path,newPart)
			LastPart = CurPart
		end
		local cycles = 1
		local MaxPlacement = C.enHacks.TowerBattles.AutoPlace.Placement=="Anywhere" and PlacementType == "High"
		repeat
			if cycles >= 3 then
				C.CreateSysMessage(`Maximum Cycles of {cycles} reached and no position found!`,Color3.fromRGB(25,225,25))
				break
			end
			for _, placement in ipairs(C.Map:GetDescendants()) do
				if not (((cycles==1 and placement.Name == PlacementType) or (MaxPlacement and cycles > 1 and placement.Name == "High")) and placement:IsA("BasePart")) then
					continue
				end
				for num, point in ipairs(calculatePointsInsideRotatedPart(placement, 1, YOffset)) do
					local overlapping = (PlacementType == "High" and point.Y < GroundY + .5)
						or (PlacementType == "Grass" and math.abs(point.Y - GroundY)>4)
					--[[if not overlapping then
						for num2, path in ipairs(Map:WaitForChild("Bad"):GetChildren()) do
							if C.IsInBox(path.CFrame, path.Size, point - Vector3.new(0,YOffset)) then
								overlapping = true
								break
							end
						end
					end--]]
					if not overlapping then
						local firstPoint
						local HitRes, HitPos = C.Raycast(point + Vector3.new(0,.5),-Vector3.new(0,1.5,0),{
							--distance = YOffset,
							raycastFilterType = Enum.RaycastFilterType.Include,
							ignoreList = {C.Map},
						})
						local HitInst = HitRes and HitRes.Instance
						if HitInst then
							if HitInst.Name == PlacementType then
								point = HitRes.Position
							else
								overlapping = true
							end
						end
					end
					if not overlapping then
						local hasChecked = false
						local stackleft = (PlacementType == "High" and tonumber(C.enHacks.TowerBattles.AutoPlace.StackAmount) or 0)
						repeat
							hasChecked = true
							for num3, tower in ipairs(workspace:WaitForChild("Towers"):GetChildren()) do
								if (point - tower:WaitForChild("FakeBase").Position).Magnitude < MinDistBetweenTroops then
									if stackleft > 0 then
										stackleft -= 1
										point += Vector3.new(0,MinDistBetweenTroops+.3,0)
										hasChecked = false
									else
										overlapping = true
									end
									break
								end
							end
							--RunS.RenderStepped:Wait()
						until stackleft == 0 or hasChecked
					end
					if not overlapping and IgnorePoints[point] == nil then
						table.insert(PotentialPositions, {Point = point, Part = placement})
					end
					if num%1000 == 0 then
						RunS[C.isStudio and "Heartbeat" or "RenderStepped"]:Wait()
					end
				end
			end

			local NumLeft = #PotentialPositions

			-- Loop through all potential positions and find the best one
			for num, positionData in pairs(PotentialPositions) do
				local coveredArea = CalculateTotalCoveredArea(positionData.Point)
				if coveredArea >= MaxCoveredArea then
					MaxCoveredArea = coveredArea
					BestPosition, BestPart = positionData.Point, positionData.Part
				end
				NumLeft -= 1
				if num%1000 == 0 then
					RunS[C.isStudio and "Heartbeat" or "RenderStepped"]:Wait()
				end
			end
			cycles += 1
		until BestPart or not MaxPlacement

		for _, pathInstance in ipairs(Path) do
			pathInstance:Destroy()
		end
		task.delay(1/3,function()
			IsPlacing = false
		end)
		local TotalTime = os.clock() - StartTime

		-- Place troop at the best position
		if BestPosition and MaxCoveredArea > 1e-2 then
			if Range * 0.05 > MaxCoveredArea then
				return false, C.CreateSysMessage(("Min Size Failed of %.1f%%. Best find was %.1f"):format(Range*0.05,MaxCoveredArea))
			end
			if not C.isStudio then
				--C.DoTeleport(BestPosition+Vector3.new(0,3,0))
				C.createTestPart(BestPosition)
				local Result = "Worked"--workspace.PlacingTower:InvokeServer(TroopName)
				if Result == "Worked" then
					Result = workspace.Placed:InvokeServer(BestPosition - Vector3.new(0,0.4,0), 1, TroopName, BestPart);
					if Result == true then
						return true,
							C.CreateSysMessage(("Placement Succeeded: %i/%i (%.1f seconds)"):format(
								MaxCoveredArea,Range*2*math.pi,TotalTime),Color3.fromRGB(0,225))
					else
						IgnorePoints[BestPosition] = true
						return false, C.CreateSysMessage("Placement Failed: "..tostring(Result))
					end
				else
					return false, C.CreateSysMessage("Tower Placing Failed: "..tostring(Result))
				end
			end
		else
			C.CreateSysMessage(("Position Failed: No valid position found (%.1f seconds)"):format(TotalTime))
			return false, "No Position"
		end

		return true
	end
	TabTbl = {
		Category = {
			Name = "TowerBattles",
			Title = "Tower Battles",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab = {
			{
				Title = "Join Mode",
				Tooltip = "Automatically joins the selected mode!",
				Layout = 1,
				Shortcut = "JoinMode",Functs={},Threads={},
				Activate = function(self,newValue,firstRun)
					if not newValue then
                        return
                    end
                    if game.PlaceId == 45146873 then
						local NeedsToCollectVal = C.StringWait(C.plr, "Information.NeedsToCollect")
						while NeedsToCollectVal.Value and not self.EnTbl.IgnoreReward do
							NeedsToCollectVal.Changed:Wait()
						end
						local JoinLocation = GamePlaceIds[self.EnTbl.Gamemode]
						assert(JoinLocation,`Invalid JoinLocation: `..self.EnTbl.Gamemode)
						C.ServerTeleport(JoinLocation, nil)
					end
				end,
                Events = {},
				Options = {
					{
						Type = Types.Dropdown,
						Title = "Gamemode",
						Tooltip = "Choose which game to join",
						Layout = 1,Default="Survival",
						Shortcut="Gamemode",
						Selections = {"Halloween","Arena (Versus)","Survival","Christmas","Halloween 2018",
						"Winter 2019","Halloween 2023","Winter 2022"},
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Reward",
						Tooltip = "Proceed to join without waiting to collect your reward, overriding it",
						Layout = 2,Default=false,
						Shortcut="IgnoreReward",
						Activate = C.ReloadHack,
					},
				},
			},
			{
				Title = "Auto Place",
				Tooltip = "Finds the optimal placement for towers until Max Tries are reached; otherwise, lets you place",
				Shortcut = "AutoPlace",
				Layout = 2,
				Activate = function(self, newValue, firstRun)
					--[[local clickyFound = 0
					for num, rawFunct in ipairs(C.getgc()) do
						local functInfo = debug.getinfo(rawFunct)
						if functInfo.name == "Clicked" then
							clickyFound+=1
							print("FOUND",clickyFound)
							C.HookMethod(rawFunct, self.Shortcut, newValue and function()
								print("NO CLICKY 4 U")
							end)
						end
					end--]]
					local lastClickTime
					local toStr,tskSpawn, tskDefer = tostring, task.spawn, task.defer
					C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,troopName)
						--tskSpawn(print,"invoke",self)
						if toStr(self) == "PlacingTower" and troopName then
							if lastClickTime and os.clock() - lastClickTime < .5 then
								return
							end
							tskDefer(PlaceTroop,troopName)
							lastClickTime = os.clock()
							return "Yield"
						end
					end,{"invokeserver"})
				end,
				Options = {
					{
						Type = Types.Dropdown,
						Title = "Stack",
						Tooltip = "How many troops to stack on",
						Layout = 1,Default="Disabled",
						Shortcut="StackAmount",
						Selections = {"Disabled","1","2","3","4","5"},
					},
					{
						Type = Types.Dropdown,
						Title = "Placement",
						Tooltip = "Where troops can be placed; only affects Placement High troops (i.e. Snipers) where Stack is not disabled.",
						Layout = 2,Default="Placement",
						Shortcut="Placement",
						Selections = {"Legal","Anywhere"},
					},
				},
			},
			{
				Title = "Auto Bot",
				Tooltip = "Plays for you",
				Shortcut = "AutoBot",
				Layout = 5, Threads = {},
				Activate = function(self, newValue, firstRun)
					if not newValue or GamePlaceIds.Lobby == game.PlaceId then
						return
					end
					local NoSpotsLeft = false
					while GamePlaceIds.Survival == game.PlaceId and workspace.VoteCount.Value > 0 do
						local selMap, maxLength = nil, nil
						for mapIndex = 1, 3 do
							local mapStat = workspace:WaitForChild("Map"..mapIndex)
							local mapType = mapStat:WaitForChild("Type").Value
							local mapData = C.StringWait(workspace,"MapsInformation."..mapType)
							local mapLength = mapData:WaitForChild("Length").Value
							if self.EnTbl.PickMap == mapType then
								selMap = mapStat
								break
							elseif self.EnTbl.PickMap == "Longest Of 3" then
								if not selMap or maxLength < mapData.Length.Value then
									selMap, maxLength = mapStat, mapData.Length.Value
								end
							end
						end
						if selMap then
							workspace.Vote:InvokeServer(selMap.Name)
							workspace.SkipWaitVote:InvokeServer()
						else
							workspace.Vote:InvokeServer("Veto")
						end
						workspace.VoteCount.Changed:Wait()
					end
					-- MAP LOADING --
					if not workspace:FindFirstChild("Map") then
						workspace:WaitForChild("Map") -- Wait for it to be inserted!
						task.wait(2.5) -- Wait for it to load
					end
					-- AUTOPLAY TIME--
					local AutoPlayCond = self.EnTbl.AutoplayCond
					local WaveStop = AutoPlayCond:gmatch("Wave %d+")() and tonumber(AutoPlayCond:gmatch("%d+")())
					local TowerIndex = self.EnTbl.AutoplayTroop:gmatch("%d+")()
					local ChosenTower = C.StringWait(C.plr, "StuffToSave.Tower"..TowerIndex).Value
					while true do
						-- RUN CONDITION --
						if WaveStop and workspace.Waves.Wave.Value >= WaveStop then
							break
						elseif AutoPlayCond == "Never" then
							break
						end
						if ChosenTower == "Nothing" then
							return C.Prompt("Invalid Tower", "In Slot "..TowerIndex..", you have nothing equipped.")
						end
						-- NEEDS --
						local Priority = self.EnTbl.AutoplayStyle or "Quality"
						local Action, ActionType
						local CashCost
						if not NoSpotsLeft then
							if Priority == "Sniper" then
								local MyTowers, HiddenDet = 0, 0
								for num, towerModel in ipairs(workspace:WaitForChild("Towers"):GetChildren()) do
									if towerModel.Owner.Value == C.plr then
										local Level = C.StringWait(towerModel,"Tower.UP1").Value + 1
										if Level >= 3 then
											HiddenDet+=1
										end
										MyTowers+=1
									end
								end
								if (HiddenDet >= 3 or MyTowers < 3) and MyTowers < TowerCap then
									Priority = "Quantity"
								else
									Priority = "Quality"
								end
							end
						else
							Priority="Quality"
						end
						local TowerInformation, LowestLevel
						if Priority == "Quality" then
							Action, LowestLevel = nil, 5
							local TowerType = nil
							for num, towerModel in ipairs(workspace:WaitForChild("Towers"):GetChildren()) do
								if towerModel.Owner.Value == C.plr then
									local Level = C.StringWait(towerModel,"Tower.UP1").Value + 1
									if Level < LowestLevel then
										TowerType, Action, LowestLevel = C.StringWait(towerModel,"Tower.Tower").Value,
											towerModel.Name,Level
									end
								end
							end
							if not TowerType then
								Priority = "Quantity"
							else
								ActionType = "Upgrade"
								TowerInformation = workspace:WaitForChild("TowerInformation")[TowerType]
								CashCost = TowerInformation[tostring(LowestLevel)].Value
							end
						end
						if Priority == "Quantity" then
							if TowerCount.Value >= TowerCap then
								C.CreateSysMessage(`Your towers are maxed ({TowerCount.Value}/{TowerCap})`,
									Color3.fromRGB(25,225,25))
								break
							end
							Action = ChosenTower
							TowerInformation = workspace:WaitForChild("TowerInformation")[ChosenTower]
							CashCost = TowerInformation.Value
							ActionType = "Place"
						end
						-- TOWER PLACE --
						if CashVal.Value < CashCost then
							while CashVal.Value < CashCost do
								C.PlayerInformation.Cash:GetPropertyChangedSignal("Value"):Wait()
							end
						elseif ActionType == "Upgrade" then
							if workspace.Towers:FindFirstChild(tostring(Action)) then
								local Result = workspace.UpgradeTower:InvokeServer(Action)
								if Result then
									C.CreateSysMessage(`Upgrade Tower Success: {ChosenTower} #{Action} to Level {LowestLevel+1} for ${CashCost}`,
										Color3.fromRGB(25,225,25))
								else
									C.CreateSysMessage(`Upgrade Tower Fail: {tostring(Result)}!`)
								end
							else
								RunS.RenderStepped:Wait()
							end
						elseif ActionType == "Place" and not IsPlacing then
							local Result, Error = PlaceTroop(ChosenTower)
							if not Result then
								if Error == "No Position" then
									NoSpotsLeft = true
								end
								task.wait(1/3)
							end
						else
							RunS.RenderStepped:Wait()
						end
					end
					-- SELL ALL --
					while WaveStop and workspace.Waves.Wave.Value < WaveStop do
						workspace.Waves.Wave.Changed:Wait()
					end
					if WaveStop and workspace.Waves.Wave.Value >= WaveStop then
						local TowersCount = 0
						for num, towerModel in ipairs(workspace:WaitForChild("Towers"):GetChildren()) do
							if towerModel.Owner.Value == C.plr then
								TowersCount+=1
							end
						end
						if TowersCount > 0 then
							local Waiting = true
							table.insert(self.Threads,task.delay(10,function()
								if Waiting then
									C.Prompt_ButtonTriggerEvent:Fire(true)
								end
							end))
							local Res = C.Prompt(`Selling All Towers ({TowersCount})`,
								`ALL YOUR TOWERS WILL BE SOLD IN 10 SECONDS!!\nYES TO ACTIVATE RIGHT NOW, NO TO CANCEL`,`Y/N`)
							Waiting = false
							if Res == true then
								for num, towerModel in ipairs(workspace:WaitForChild("Towers"):GetChildren()) do
									if towerModel.Owner.Value == C.plr then
										task.spawn(workspace.SellTower.InvokeServer,workspace.SellTower,towerModel.Name)
									end
								end
							end
						end
					end
				end,
				Options = {
					{
						Type = Types.Dropdown,
						Title = "Map Selection",
						Tooltip = "In survival, vetos until chosen map is found.",
						Layout = 1,Default="Borderlands",
						Shortcut="PickMap",
						Selections = {"Nothing","Midnight Road","Borderlands","Longest Of 3"},
					},
					{
						Type = Types.Dropdown,
						Title = "Autoplay Condition",
						Tooltip = "Until what wave the autoplay runs before SELLING ALL TOWERS",
						Layout = 2,Default="Never",
						Shortcut="AutoplayCond",
						Selections = {"Never","Wave 20","Always"},
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Dropdown,
						Title = "Autoplay Troop",
						Tooltip = "What troop is autoplayed",
						Layout = 3, Default = "Slot 2",
						Shortcut="AutoplayTroop",
						Selections = {"Slot 1","Slot 2","Slot 3","Slot 4","Slot 5"},
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Dropdown,
						Title = "Autoplay Style",
						Tooltip = "How the bot plays: quantity of more towers or quality of less towers?",
						Layout = 4, Default = "Sniper",
						Shortcut="AutoplayStyle",
						Selections = {"Quality","Sniper","Quantity"},
						Activate = C.ReloadHack,
					},
				},
			},
			{
				Title = "Claim Goodies",
				Tooltip = "Automatically claims goods",
				Shortcut = "ClaimRewards",
				Layout = 15, Functs = {},
				RewardFrames = {
					JustFinished = "SurvivalAnalysis",
					JustFinishedWinter = "Winter2022Analysis",
					JustFinishedHallow = "Halloween2023Analysis",
					JustTied = "Triumph",
					JustWon = "Winner",
				},
				Activate = function(self, newValue, firstRun)
					if not newValue then
						return
					end
					if game.PlaceId ~= GamePlaceIds["Lobby"] then
						if not firstRun then
							C.AddNotification("Restricted Game","This hack only works in the lobby")
						end
						return
					end
					local cent = C.StringWait(C.PlayerGui,"Games.cent")
					for num, frame in ipairs(cent:GetChildren()) do
						if frame:IsA("Frame") then
							local RemoteName = self.RewardFrames[frame.Name]
							if RemoteName then
								local function VisiblityChanged()
									if not frame.Visible then
										return
									end
									local RemoteInstance = workspace:WaitForChild(RemoteName)
									local RemoteResult = RemoteInstance:InvokeServer()
									if RemoteResult == "Success" then
										frame.Visible = false
									end
								end
								table.insert(self.Functs,frame:GetPropertyChangedSignal("Visible"):Connect(VisiblityChanged))
								task.spawn(VisiblityChanged)
							end
						end
					end
				end,
			},
			{
				Title = "Fix Teleport Back",
				Tooltip = "Sometimes when the game crashes, it doesn't teleport all users back. This fixes it!",
				Layout = 30,
				Shortcut = "FixTeleportBack",Threads={},
				Activate = function(self,newValue,firstRun)
					if not newValue then
                        return
                    end
					local Announce = C.StringWait(workspace,"Waves.Anounce")
					while Announce.Value == "Teleporting everybody back to the Lobby..." do
						C.API(C.ServerTeleport,nil,1,GamePlaceIds.Lobby)
						task.wait(5)
					end
				end,
			},
            C.Jerk and
            {
                Title = "Blackify",
                Tooltip = "Turns all of the towers skins to black",
                Layout = 35,
                Shortcut = "Colorify",Threads={}, Functs = {},
                Activate = function(self,newValue,firstRun)
                    if not firstRun then
                        for num, tower in ipairs(C.Towers:GetChildren()) do
                            task.spawn(self.Events.TowerAdded, self, tower)
                        end
                    end
                end,
                BodyNames = {"Torso","Head","Right Arm","Left Arm","Right Leg","Left Leg"},
                Events = {
                    TowerAdded = function(self, tower)
                        task.wait(1/2)
                        local function PartAdded(basepart)
                            if basepart:IsA("BasePart") and table.find(self.BodyNames,basepart.Name) then
---@diagnostic disable-next-line: invalid-class-name
                                C.SetPartProperty(basepart, "Color", "Colorify", self.RealEnabled and BrickColor.new("Medium brown").Color or C, true)
                            end
                        end
                        for num, basepart in ipairs(tower:GetDescendants()) do
                            PartAdded(basepart)
                        end
                        if self.RealEnabled then
                            table.insert(self.Functs, tower.DescendantAdded:Connect(PartAdded))
                        end
                    end,
                },
            },
            C.Jerk and
            {
                Title = "Morph",
                Tooltip = "Morphs all to the hot avatar",
                Shortcut = "Morph",
                Layout = 40,
                Threads = {},
                Functs = {},
                Instances = {},
                ZombieInserted = function(self, zombie)
                    local Rig = zombie:WaitForChild("Rig", 30)
                    if not Rig then
                        warn("Rig not found")
                        return
                    end
                    local Block = Rig:WaitForChild("Block") or Rig.PrimaryPart
                    local Desc2Apply = (C.getgenv().currentDesc[C.plr.Name] or C.human:FindFirstChildOfClass("HumanoidDescription")):Clone()
                    for num, part in ipairs(Rig:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("Mesh") or part:IsA("Texture") then
                            C.SetPartProperty(part, "Transparency", "MorphTransparency", 1)
                        end
                    end
                    local FakeRig = Players:CreateHumanoidModelFromDescription(Desc2Apply, Enum.HumanoidRigType.R6)
                    FakeRig:PivotTo(zombie:GetPivot())
                    local RigWeld = Instance.new("WeldConstraint")
                    RigWeld.Part0 = Block
                    RigWeld.Part1 = FakeRig.Torso
                    RigWeld.Parent = FakeRig
                    FakeRig.PrimaryPart.Anchored = false
                    FakeRig:ScaleTo(math.pow((Rig.PrimaryPart.Size / FakeRig.PrimaryPart.Size).Magnitude, 1/3))
                    FakeRig.Parent = zombie
                    task.wait(1/2)
                    local SpeedVal = C.StringFind(Rig, "Walk.Speed")
                    local WeightVal = C.StringFind(Rig, "Walk.Weight")
                    FakeRig.Humanoid.Animator:LoadAnimation(Rig.Walk):Play(SpeedVal and SpeedVal.Value or nil,
                        WeightVal and WeightVal.Value or nil)
                end,
                Activate = function(self, newValue)
                    if newValue then
                        local WaveTeam = C.StringWait(workspace, "Wave.Blue", math.huge)
                        table.insert(self.Functs, WaveTeam.ChildAdded:Connect(function(new)
                            self:ZombieInserted(new)
                        end))
                        for _, zomb in ipairs(WaveTeam:GetChildren()) do
                            table.insert(self.Threads, task.spawn(self.ZombieInserted, self, zomb))
                        end
                    end
                end,
            },
		}
	}
	return TabTbl
end