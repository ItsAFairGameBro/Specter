local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local DS = game:GetService("Debris")
local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local LS = game:GetService("Lighting")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")
local function Static(C, Settings)
	table.insert(C.EventFunctions,function()
		local function newChild(instance)
			local TypeVal = instance:WaitForChild("Height",5)
			if TypeVal then
				C.Map = instance
				C.FireEvent("MapAdded",nil,instance)
			end
		end
		C.AddGlobalConnection(workspace.ChildAdded:Connect(newChild))
		for num, instance in ipairs(workspace:GetChildren()) do
			task.spawn(newChild,instance)
		end
	end)
	C.PlayerInformation = C.plr:WaitForChild("Information")
end
return function(C,Settings)
	local IsPlacing = false
	local function PlaceTroop(TroopName)
		if IsPlacing then return false, "Placement In Progress" end
		local TowerInformation = workspace:WaitForChild("TowerInformation")[TroopName]
		if TowerInformation.Value > C.PlayerInformation.Cash.Value then
			return false,
				C.CreateSysMessage(("Not Enough Cash: $%i Needed)"):format(TowerInformation.Value - C.PlayerInformation.Cash.Value))
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

		for _, placement in ipairs(C.Map:GetDescendants()) do
			if placement.Name ~= PlacementType or not placement:IsA("BasePart") then
				continue
			end
			for num, point in ipairs(calculatePointsInsideRotatedPart(placement, 1, YOffset)) do
				local overlapping = (PlacementType == "High" and point.Y < GroundY + .5) or (PlacementType == "Grass" and math.abs(point.Y - GroundY)>4)
				--[[if not overlapping then
					for num2, path in ipairs(Map:WaitForChild("Bad"):GetChildren()) do
						if C.IsInBox(path.CFrame, path.Size, point - Vector3.new(0,YOffset)) then
							overlapping = true
							break
						end
					end
				end--]]
				if not overlapping then
					local HitRes, HitPos = C.Raycast(point + Vector3.new(0,.5),-Vector3.new(0,.2,0),{
						--distance = YOffset,
						raycastFilterType = Enum.RaycastFilterType.Include,
						ignoreList = {C.Map},
						passFunction = function(instance)
							return instance.Name == PlacementType
						end,
					})
					if HitRes then
						overlapping = true
					end
				end
				if not overlapping then
					for num3, tower in ipairs(workspace:WaitForChild("Towers"):GetChildren()) do
						if (point - tower:WaitForChild("FakeBase").Position).Magnitude < MinDistBetweenTroops then
							overlapping = true
							break
						end
					end
				end
				if not overlapping then
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

		for _, pathInstance in ipairs(Path) do
			pathInstance:Destroy()
		end
		task.delay(1/3,function()
			IsPlacing = false
		end)

		-- Place troop at the best position
		if BestPosition and MaxCoveredArea > 1e-2 then
			if Range * 0.05 > MaxCoveredArea then
				return false, C.CreateSysMessage(("Min Size Failed of %.1f%%. Best find was %.1f"):format(Range*0.05,MaxCoveredArea))
			end
			print(("Best troop position covers area is %.1f in %.2f s"):format(MaxCoveredArea, os.clock()-StartTime))
			if not C.isStudio then
				C.DoTeleport(BestPosition+Vector3.new(0,3,0))
				C.createTestPart(BestPosition)
				local Result = "Worked"--workspace.PlacingTower:InvokeServer(TroopName)
				if Result == "Worked" then
					Result = workspace.Placed:InvokeServer(BestPosition - Vector3.new(0,0.4,0), 1, TroopName, BestPart);
					if Result == true then
						print("Placement Successful")
						C.CreateSysMessage("Placement Success: "..MaxCoveredArea,Color3.fromRGB(0,225))
						return true, 
							C.CreateSysMessage(("Placement Success: %.1f"):format(MaxCoveredArea),Color3.fromRGB(0,225))
					else
						return false, C.CreateSysMessage("Placement Failed: "..tostring(Result))
					end
				else
					return false, C.CreateSysMessage("Tower Placing Failed: "..tostring(Result))
				end
			end
		else
			return false, C.CreateSysMessage("Position Failed: No valid position found")
		end

		return true
	end
	Static(C,Settings)
	return {
		Category = {
			Name = "TowerBattles",
			Title = "Tower Battles",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab = {
			{
				Title = "Join Survival",
				Tooltip = "Automatically joins survival!",
				Layout = 1,
				Shortcut = "Auto",Functs={},Threads={},
				Activate = function(self,newValue,firstRun)
					if not newValue then
                        return
                    end
                    if game.PlaceId == 45146873 then
						C.ServerTeleport(49707852, nil)
					--[[elseif game.PlaceId == 49707852 then
						while task.wait(2) do
							workspace.Vote:InvokeServer("Veto")
						end--]]
					end
				end,
                Events = {},
				Options = {},
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
					local toStr,tskSpawn, tskDefer = tostring, task.spawn, task.defer
					C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,troopName)
						--tskSpawn(print,"invoke",self)
						if toStr(self) == "PlacingTower" and troopName then
							tskDefer(PlaceTroop,troopName)
							return "Yield"
						end
					end,{"invokeserver"})
				end,
			},
			{
				Title = "Auto Bot",
				Tooltip = "Plays for you",
				Shortcut = "AutoPlace",
				Layout = 5, Threads = {}, Functs = {},
				Activate = function(self, newValue, firstRun)
					if not newValue then
						return
					end
					if game.PlaceId == 45146873 then
						C.ServerTeleport(49707852, nil)
					end
					while workspace.VoteCount.Value > 0 do
						local selMap, maxLength = nil, nil
						for mapIndex = 1, 3 do
							local mapStat = workspace:WaitForChild("Map"..mapIndex)
							local mapType = mapStat:WaitForChild("Type").Value
							local mapData = C.StringWait(workspace,"MapsInformation."..mapType)
							local mapLength = mapData:WaitForChild("Length").Value
							if self.EnTbl.PickMap == mapType then
								selMap = mapStat
								break
							elseif self.EnTbl.PickMap == "Longest Seen" then
								if not selMap or maxLength < mapData.Length.Value then
									selMap = mapStat, maxLength
								end
							end
						end
						if selMap then
							workspace.Vote:InvokeServer(selMap.Name)
						else
							workspace.Vote:InvokeServer("Veto")
						end
						workspace.VoteCount.Changed:Wait()
					end
					print("Finished Voting!")
				end,
				Options = {
					{
						Type = Types.Toggle,
						Title = "Map Selection",
						Tooltip = "In survival, vetos until chosen map is found.",
						Layout = 2,Default=false,
						Shortcut="PickMap",
						Selections = {"Longest Seen","Midnight Road","Borderlands"},
						Activate = C.ReloadHack,
					},
				},
			},
		}
		
	}
end