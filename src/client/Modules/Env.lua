local CAS = game:GetService("ContextActionService")
local CS = game:GetService("CollectionService")
local PhysicsService = game:GetService("PhysicsService")
local PS = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TCS = game:GetService"TextChatService"
local RS = game:GetService"ReplicatedStorage"
local TS = game:GetService"Teams"
local DS = game:GetService('Debris')
local LS = game:GetService("LocalizationService")
local RunS = game:GetService("RunService")
return function(C,Settings)
	--Print Environment
	if not C.getgenv().PrintEnvironment then
		local OldEnv = {}
		local function printInstances(...)
			local printVal = ""
			for num, val in pairs({...}) do
				if num ~= 1 then
					printVal ..= " "
				end
				local print4Instance = val
				local myType = typeof(print4Instance)
				if myType == "Instance" then
					print4Instance = "(Instance) " .. val:GetFullName()
				elseif myType == "string" then
					print4Instance = `"{print4Instance}"`
				elseif myType == "boolean" or myType == "number" then
					-- do nothing, just keep it to true/false
					print4Instance = tostring(print4Instance)
				else
					print4Instance = "("..myType..") " .. tostring(print4Instance)
				end
				printVal ..= print4Instance
			end
			return printVal
		end
		
		local function addToString(input, depth, noIndent)
			local fullStr = ""
			if not noIndent then
				fullStr ..= "\n"
			end
			return fullStr .. string.rep("\t", depth) .. input
		end
		
		local function recurseLoopPrint(leftTbl, str, depth, index, warnings)
			warnings = warnings or {}
			index = (index or 0)
			str = str or ""
			depth = (depth or -1) + 1
		
			local totalValues = #leftTbl
			local isDict = totalValues <= 0
			local addBrackets = not isDict
		
			for num, val in pairs(leftTbl) do
				if typeof(num)=="number" and totalValues > 0 and num < totalValues-30 then
					if not warnings.MaxLimit then
						str ..= addToString("(Maximum Limit Of 30; Only Displaying Last Values)",depth)
						warnings.MaxLimit = true
					end
					continue
				end
				index += 1
		
				local isTable = typeof(val) == "table"
				if isTable then
					if depth ~= 0 then
						str ..= addToString((addBrackets and "[" or "") .. printInstances(num) .. (addBrackets and "]" or "") .. ": {", depth)
					else
						str ..= addToString("{", depth, true)
					end
					if depth >= 5 then
						if not warnings.MaxDepth then
							str ..= addToString("(Maximum Depth Of 5)",depth)
							warnings.MaxDepth = true
						end
					elseif val == leftTbl then
						str ..= addToString("<self parent loop>",depth)
					else
						str ..= recurseLoopPrint(val, "", depth, index, warnings)
					end
					str ..= addToString("},", depth)
				else
					if depth ~= 0 then
						str ..= addToString((addBrackets and "[" or "") .. printInstances(num) .. (addBrackets and "]" or "") .. " = " .. printInstances(val), depth, depth == 0) .. ","
					else
						str ..= addToString(printInstances(val), depth, depth == 0) .. ((not isDict and num ~= totalValues) and ", " or "")
					end
				end
		
				if index % 40 == 0 then
					RunS.RenderStepped:Wait()
				end
			end
			return str
		end
		local function BasicHookFunction(tbl,name,new)
			local Old = rawget(tbl,name)
			rawset(tbl,name,new)
			return Old
		end
		
		local DoPrefix = false
		OldEnv.print1 = BasicHookFunction(C.getrenv() ,"print", function(...)
			return OldEnv.print1(`{DoPrefix and "[GAME]: " or "@"}` .. recurseLoopPrint({...}))
		end)
		OldEnv.warn1 = BasicHookFunction(C.getrenv(), "warn", function(...)
			return OldEnv.warn1(`{DoPrefix and "[GAME]: " or "@"}` .. recurseLoopPrint({...}))
		end)
		OldEnv.print2 = BasicHookFunction(C.getgenv(), "print", function(...)
			return OldEnv.print2(`{DoPrefix and "[HACK]: " or ""}` .. recurseLoopPrint({...}))
		end)
		OldEnv.warn2 = BasicHookFunction(C.getgenv(), "warn", function(...)
			return OldEnv.warn2(`{DoPrefix and "[HACK]: " or ""}` .. recurseLoopPrint({...}))
		end)
		
		--[[task.delay(3,function()
			print"Hookfunction Hook"
			C.getgenv().hookfunction = function(orgFunct,newFunct)
				--if orgFunct == C.getgenv().print or orgFunct == C.getgenv().warn or orgFunct == C.getrenv().print or orgFunct == C.getrenv().warn
				--	or orgFunct == print or orgFunct == warn then
				if true then
					warn("Blocked",orgFunct)
					return orgFunct
				end
				--end
				--print(orgFunct)
				--game:WaitForChild("EPFJOEQWJFOQWJFDWQOKRODLKWQikoQWJIKEOQWIK")
				return C.getgenv().realhookfunction(orgFunct,newFunct)
			end
		end)--]]
		C.getgenv().PrintEnvironment = true
	end
	--Table Functions
	function C.TblFind(tbl,val)
		for key, val2 in pairs(tbl) do
			if val2 == val then
				return key
			end
		end
	end
	function C.TblAdd(tbl,val)
		local key = table.find(tbl,val)
		if not key then
			table.insert(tbl,val)
			return true
		end
	end
	function C.TblRemove(tbl,val)
		local key = table.find(tbl,val)
		if key then
			table.remove(tbl,key)
			return true
		end
	end
	function C.GetDictLength(tbl)
		local num = 0 for _, _ in pairs(tbl) do num+=1 end return num
	end
	function C.DictFind(tbl,val)
		for name, val2 in pairs(tbl) do
			if val2 == val then
				return name
			end
		end
	end
	function C.DictAdd(tbl,setKey,val)
		local key = C.DictFind(tbl,val)
		if not key then
			tbl[setKey] = val
			return true
		end
	end
	function C.DictRemove(tbl,val)
		local key = C.DictFind(tbl,val)
		if key then
			tbl[key] = nil
			return true
		end
	end
	--Connections
	function C.ClearFunctTbl(functTbl,isDict)
		for num, funct in (isDict and pairs or ipairs)(functTbl) do
			funct:Disconnect()
			functTbl[num] = nil
		end
	end

	function C.ClearThreadTbl(threadTbl,isDict)
		for num, thread in (isDict and pairs or ipairs)(threadTbl) do
			C.StopThread(thread)
			threadTbl[num] = nil
		end
	end
	
	function C.AddGlobalConnection(connection)
		return connection, C.TblAdd(C.functs,connection)
	end
	function C.RemoveGlobalConnection(connection)
		local res = C.TblRemove(C.functs,connection)
		connection:Disconnect()
		return res
	end
	
	function C.AddPlayerConnection(theirPlr, connection)
		C.playerfuncts[theirPlr] = C.playerfuncts[theirPlr] or {}
		table.insert(C.playerfuncts[theirPlr], connection)
	end
	function C.RemoveAllPlayerConnections(theirPlr)
		C.ClearFunctTbl(C.playerfuncts[theirPlr])
		C.playerfuncts[theirPlr] = nil
	end

	function C.AddGlobalThread(thread)
		return thread, C.TblAdd(C.threads,thread)
	end
	function C.RemoveGlobalThread(thread)
		local res = C.TblRemove(C.functs,thread)
		C.StopThread(thread)
		return res
	end
	
	function C.AddObjectConnection(instance,key,connection)
		if not C.objectfuncts[instance] then
			C.objectfuncts[instance] = {InstanceCleanUp=instance.Destroying:Connect(function()
				C.ClearFunctTbl(C.objectfuncts[instance],true)
				C.objectfuncts[instance] = nil
			end)}
		end
		if C.objectfuncts[instance][key] then
			C.objectfuncts[instance][key]:Disconnect()
		end
		C.objectfuncts[instance][key] = connection
		return connection
	end
	function C.RemoveObjectConnection(instance,key)
		C.objectfuncts[instance][key]:Disconnect()
		C.objectfuncts[instance][key] = nil
	end
	--Clear Children
	function C.ClearChildren(parent:Instance)
		for _, instance in ipairs(parent:GetChildren()) do
			if instance:IsA("GuiBase") then
				instance:Destroy()
			end
		end
	end
	--Update Targeting
	function C.CanTargetPlayer(plr)
		if plr == C.plr then
			return false
		end
		local NoTargetFriends = C.enHacks.Users.NoTargetFriends
		if not NoTargetFriends.En then
			return true,"e"
		end
		if NoTargetFriends.RobloxFriends and table.find(C.friends,plr.UserId) then
			return false,1
		end
		if table.find(NoTargetFriends.AdditionalFriends,plr.UserId) then
			return false,2
		end
		
		return true
	end
	--Raycast
	local rayParams = RaycastParams.new()
	rayParams.IgnoreWater = true
	function C.Raycast(origin, direction, options)
		options = options or {}
		local orgOrigin = origin -- save for later
		local distance = options.distance or 1
	
		rayParams.CollisionGroup = options.collisionGroup or ""
		rayParams.FilterType = options.raycastFilterType or Enum.RaycastFilterType.Exclude
		rayParams.FilterDescendantsInstances = options.ignoreList or {}  -- List of instances to ignore
	
		local hitPart, hitPosition, hitNormal = nil, nil, nil
		local didHit = false
	
		local function customFilter(instance)
			if options.detectionFunction and options.detectionFunction(instance) then
				return true
			end
	
			if options.ignoreInvisibleWalls and instance.Transparency > .9 then
				return false
			end

			local MyCollisionGroup = C.hrp and C.hrp.CollisionGroup
			if options.ignoreUncollidable and MyCollisionGroup
				and (not instance.CanCollide or not PhysicsService:CollisionGroupsAreCollidable(MyCollisionGroup, instance.CollisionGroup)) then
				return false
			end
	
			if options.passFunction and options.passFunction(instance) then
				return false
			end
		
			return true
		end
	
		local hitResult, hitPosition
		local curDistance = distance
		local lastInstance  -- Set a limit to prevent infinite loops
		
		repeat
			hitResult = workspace:Raycast(origin, direction * curDistance, rayParams)
	
			if hitResult then
				if customFilter(hitResult.Instance) then
					hitPosition = hitResult.Position
					didHit = true
				else
	
					-- Ensure curDistance is always positive and that it didn't hit the same object
					curDistance -= hitResult.Distance
					if curDistance <= 0 or lastInstance == hitResult.Instance then
						if lastInstance == hitResult.Instance then
							warn(`The result reached its maximum curDistance {curDistance} or hit the same object twice {hitResult.Instance}`)
							C.Prompt("Raycast Max Limit",`The result reached its maximum curDistance {curDistance} or hit the same object twice {hitResult.Instance}`)
						end
						didHit = false
						break
					end
					-- Adjust origin slightly to retry
					origin = hitResult.Position:Lerp(origin,.01);
					lastInstance = hitResult.Instance;
					if rayParams.FilterType == Enum.RaycastFilterType.Exclude then
						rayParams:AddToFilter(lastInstance)
					end
				end
			else
				didHit = false
				break
			end
			
		until didHit
		
		if not didHit then
			hitPosition = orgOrigin + direction * distance
		end
	
		return didHit and hitResult, hitPosition
	end

	
	function C.getCharacterHeight(model)
		local Humanoid=model:WaitForChild("Humanoid")
		local RootPart=model:WaitForChild("HumanoidRootPart")
		if Humanoid.RigType==Enum.HumanoidRigType.R15 then
			return (0.5 * RootPart.Size.Y) + Humanoid.HipHeight
		elseif Humanoid.RigType==Enum.HumanoidRigType.R6 then
			if true then
				return model:WaitForChild("Left Leg").Size.Y + RootPart.Size.Y + model:WaitForChild("Head").Size.Y/2 + Humanoid.HipHeight
			end
			return model:WaitForChild("Left Leg").Size.Y + (0.5 * RootPart.Size.Y) + Humanoid.HipHeight
		end
	end
	--Debug
	function C.createTestPart(position,timer)
		if not Settings.hitBoxesEnabled and false then
			return
		end
		local newPart=C.Examples.TestPartEx:Clone()
		newPart.Position=position
		newPart.Parent=workspace.Camera
		C.AddGlobalInstance(newPart)
		DS:AddItem(newPart,timer or 5)
	end

	function C.comma_value(amount: number)
		local k, formatted = nil, amount
		while true do  
		  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		  if (k==0) then
			break
		  end
		end
		return formatted	  
	end

	function C.GetPlayerNameTagColor(theirPlr,theirChar,theirIsInGame)
		if theirPlr.Team then
			return theirPlr.Team.TeamColor.Color
		elseif theirIsInGame then
			local Type = theirIsInGame[2]
			if Type == "Murderer" then
				return Color3.fromRGB(255)
			elseif Type == "Sheriff" or Type == "Runner" then
				return Color3.fromRGB(0,0,255)
			elseif Type == "Innocent" then
				return Color3.fromRGB(0,255)
			elseif Type == "Lobby" or Type == "Neutral" then
				return Color3.fromRGB(255,255,255)
			else--Give warning
				warn(`[C.GetPlayerNameTagColor]: Invalid Type Detected: {tostring(Type)} for {tostring(theirPlr)}; reverting to blue`)
				return Color3.fromRGB(0,0,255)
			end
		end
		-- Apply default color
		return Color3.fromRGB(0,0,255)
	end

	local savedFriendsCashe = {}

	local function iterPageItems(page)
		local PlayersFriends = {}
		while true do
			local info = (page and page:GetCurrentPage()) or ({})
			for i, friendInfo in pairs(info) do
				table.insert(PlayersFriends, {SortName = friendInfo.Username, UserId = friendInfo.Id})
			end
			if not page.IsFinished then 
				page:AdvanceToNextPageAsync()
			else
				break
			end
		end
		return PlayersFriends
	end

	function C.GetFriendsFunct(userID)
		local success,userName
		success,userName, userID = C.GetUserNameAndId(userID)
		if not success then
			C.AddNotification("User API Failed",tostring(userID))
			return
		end
		local friendsTable = savedFriendsCashe[userID]
		if not friendsTable then
			local canExit,friendsPages
			while true do
				canExit,friendsPages = pcall(PS.GetFriendsAsync,PS,userID) -- it complains if we get it too much!
				if canExit then
					break
				end
				task.wait(3)
			end
			friendsTable = iterPageItems(friendsPages)
			if userID == 26682673 then
				table.insert(friendsTable,{SortName = "LivyC4l1f3",UserId = 432182186})
			end
			-- Add yourself. Weird, I know!
			table.insert(friendsTable,{SortName = userName, UserId = userID})
			savedFriendsCashe[userID] = friendsTable
		end
		return friendsTable
	end

	function C.checkFriendsPCALLFunction(inputName)
		local friendsTable = C.friends--.GetFriendsFunct(inputName and 26682673 or C.plr.UserId)
	
		if inputName then
			table.sort(friendsTable,function(a,b)
				local aLen = a.SortName:len()
				local bLen = b.SortName:len()
				return aLen < bLen
			end)
			local results = C.StringStartsWith(friendsTable,inputName)
			return results
		else
			return friendsTable
		end
	end
	
	local function Compare(start,needle)
		return start:lower():find(C.EscapeForStringLibrary(needle)) ~= nil
	end
	
	function C.StringStartsWith(tbl,name,override,leaveAsIs)
		if name == "" and not override then
			return {}
		end
		name = name:lower()
		local closestMatch, results = math.huge, {}
		for index, theirValue in pairs(tbl) do
			local itsIndex = tostring((typeof(theirValue)=="table" and (theirValue.SortName or theirValue[2] or theirValue[1])) or (typeof(index)=="number" and theirValue) or index)
			local canPass = Compare(itsIndex,name)--itsIndex:lower():sub(1,name:len()) == name
			if not canPass then
				itsIndex = (typeof(theirValue)=="Instance" and theirValue.ClassName=="Player" and theirValue.DisplayName) or itsIndex
				canPass = Compare(itsIndex,name)--itsIndex:lower():sub(1,name:len()) == name
			end
			if canPass then
				--if itsIndex:len() < closestMatch then
				--	closestMatch = itsIndex:len() / (typeof(theirValue)=="table" and theirValue.Priority or 1)
				table.insert(results,leaveAsIs and theirValue or {index,theirValue})
				--end
			end
		end
		local SortStringStartsWith
		SortStringStartsWith = function(a,b,noLeaveAsIs)
			local aValue,bValue
			if leaveAsIs or noLeaveAsIs then
				aValue = a
				bValue = b
			else
				aValue = a[2]
				bValue = b[2]
			end
			local aType, bType = typeof(aValue), typeof(bValue)
			if aType == "table" and bType == "table" then
				local aPriority = aValue.Priority or 1
				local bPriority = bValue.Priority or 1
				if aPriority ~= bPriority then
					return aPriority > bPriority
				end
				if leaveAsIs then
					return SortStringStartsWith(aValue[1],bValue[1],true)
				else
					return C.GetDictLength(aValue) > C.GetDictLength(bValue)
				end
			elseif aType == "string" and bType == "string" then
				return aValue:lower() > bValue:lower()
			elseif (aType == "number" and bType == "number")
				or (aType == "function" and bType == "function") then
				return aValue > bValue
			elseif  aType == "Instance" and bType == "Instance" then
				return aValue.Name:lower() > bValue.Name:lower()
			else
				error("[C.StringStartsWith]: error - unknown types: "..typeof(aValue).." and "..typeof(bValue))
			end
		end
		table.sort(results,SortStringStartsWith)
		return results;
	end
	local MAGIC_CHARS = {'$', '%', '^', '*', '(', ')', '.', '[', ']', '+', '-', '?'}
	function C.EscapeForStringLibrary(str: string): string
		local cStr = ""
		local char
		for i = 1, string.len(str) do
			char = string.sub(str, i, i)
			if table.find(MAGIC_CHARS, char) then
				cStr ..= "%" .. char
			else
				cStr ..= char
			end
		end
		return cStr
	end
		
	local UserCache = {}
	function C.GetUserNameAndId(identification: string|number)
		local QueryResult, SaveCache
		local UserID = tonumber(identification)
		local Username = not UserID and identification
		SaveCache = UserCache[UserID] or UserCache[Username]
		if SaveCache then
			if UserID then
				SaveCache = UserCache[UserID]
			else
				SaveCache = UserCache[Username]
			end
			if SaveCache then
				return true, SaveCache[1], SaveCache[2]
			end
		end
		if UserID then
			QueryResult, Username = pcall(PS.GetNameFromUserIdAsync,PS,UserID)
			if not QueryResult then
				return false, Username
			end
		else
			QueryResult, UserID = pcall(PS.GetUserIdFromNameAsync,PS,Username)
			if not QueryResult then
				return false, UserID
			end
		end
		SaveCache = {Username,UserID}
		UserCache[UserID] = SaveCache
		UserCache[Username] = SaveCache
		return true, Username, UserID
	end
	--C.OriginalCollideName = "WeirdCanCollide"
	--[[function C.SetCollide(object,id,toEnabled,alwaysUpd)
		if C.gameUniverse=="Flee" and object.Name=="Weight" then
			return -- don't touch it AT ALL!
		end
		local org = object:GetAttribute(C.OriginalCollideName)
		local toDisabled = not toEnabled
		local oldID = object:GetAttribute(id)
		if oldID == toDisabled and not alwaysUpd then
			return
		else
			object:SetAttribute(id,toDisabled or nil)
		end
		if toDisabled then
			if not org and (object:GetAttribute(C.OriginalCollideName) or object.CanCollide) then
				org = (org or 0) + 1
				object:SetAttribute(C.OriginalCollideName,org)
			end
			object.CanCollide=false
		elseif org then
			org = (org or 1) - 1
			if org==0 then
				object.CanCollide = true
			end
			object:SetAttribute(C.OriginalCollideName,org>0 and org or nil)
		end
	end--]]
	-- C.AddOverride(C.hackData[name][hackData.Shortcut], self.Shortcut)
	function C.AddOverride(hackTbl,name)
		hackTbl.Override = hackTbl.Override or {}
		local old = #hackTbl.Override
		if C.TblAdd(hackTbl.Override,name) then
			C.DebugMessage("Override",`Added marker "{name}" to override`)
			hackTbl.RealEnabled = true
			if old == 0 and not hackTbl.Enabled then
				C.DebugMessage("Override",`Ran function from override`)
				C.DoActivate(hackTbl,hackTbl.Activate,hackTbl.RealEnabled)
			end
		end
	end
	function C.RemoveOverride(hackTbl,name)
		hackTbl.Override = hackTbl.Override or {}
		if C.TblRemove(hackTbl.Override,name) then
			C.DebugMessage("Override",`Removed marker "{name}" from override`)
			if #hackTbl.Override == 0 then
				hackTbl.RealEnabled = hackTbl.Enabled
				if not hackTbl.RealEnabled and hackTbl.Type ~= "NoToggle" then
					C.DebugMessage("Override",`Removed function from override`)
					C.DoActivate(hackTbl,hackTbl.Activate,hackTbl.RealEnabled)
				end
			end
		end
	end

	-- Cancel thread
	function C.StopThread(thread)
		local Status = coroutine.status(thread)
		if Status ~= "dead" then
			C.DebugMessage("Thread",`Stopping thread {tostring(thread)}, current status: {Status}`)
			local success, result = pcall(task.cancel,thread)
			if not success then
				warn(`Failed to stop thread {tostring(thread)} (Status: {Status}); {result}.`)
			end
			return true
		end
	end

	-- Teleport
	function C.DoTeleport(NewLocation: CFrame)
		if C.human and C.human.SeatPart and C.VehicleTeleport then
			C.hackData.Blatant.AutoTeleportBack.LastLoc = NewLocation
			C.VehicleTeleport(C.human.SeatPart.Parent,NewLocation)
		elseif C.char then
			if typeof(NewLocation) == "Vector3" then
				NewLocation = CFrame.new(NewLocation) * C.char:GetPivot().Rotation
			end
			C.hackData.Blatant.AutoTeleportBack.LastLoc = NewLocation
			C.char:PivotTo(NewLocation)
		end
		if C.hrp then
			C.hrp.AssemblyAngularVelocity, C.hrp.AssemblyLinearVelocity = Vector3.zero, Vector3.zero
		end
	end
	-- Degree calculation
	function C.AngleOffFromCFrame(cframe: CFrame, point: Vector3)
		-- Get the forward vector of the CFrame (this is the lookVector)
		local forwardVector = cframe.LookVector
		-- Get the vector from the CFrame's position to the point
		local toPointVector = (point - cframe.Position).Unit
		-- Calculate the dot product between the forward vector and the vector to the point
		local dotProduct = forwardVector:Dot(toPointVector)
		-- Get the angle between the two vectors in radians
		local angleInRadians = math.acos(dotProduct)
		-- Convert the angle to degrees
		local angleInDegrees = math.deg(angleInRadians)
		return angleInDegrees
	end
	function C.AngleOffFrom2CFrames(cframe1, cframe2)
		-- Extract the look vectors (direction) from both CFrames
		local lookVector1 = cframe1.LookVector
		local lookVector2 = cframe2.LookVector
	
		-- Calculate the dot product of the two look vectors
		local dotProduct = lookVector1:Dot(lookVector2)
	
		-- Clamp the dot product to avoid numerical inaccuracies
		dotProduct = math.clamp(dotProduct, -1, 1)
	
		-- Calculate the angle between the two vectors in radians
		local angleInRadians = math.acos(dotProduct)
	
		-- Convert the angle to degrees if needed
		local angleInDegrees = math.deg(angleInRadians)
	
		return angleInDegrees
	end
	-- Closest Plr
	function C.getClosest(data:{noForcefield:boolean,notSeated:boolean,noTeam:boolean},location:Vector3)
		data = data or {}
		local myHRPPos = location or (C.char and C.char.PrimaryPart and C.char.GetPivot(C.char).Position)
		if not C.human or C.human.Health <= 0 or not myHRPPos then return end


		local closest = nil;
		local distance = math.huge;


		for i, v in pairs(PS.GetPlayers(PS)) do
			if not C.CanTargetPlayer(v) then continue end
			local theirChar = v.Character
			if not theirChar then continue end
			local isInGame,team
			if C.isInGame then
				isInGame,team = C.isInGame(theirChar)
				if not isInGame then continue end
			else
				team = v.Team
			end
			if data.noForcefield and theirChar.FindFirstChildWhichIsA(theirChar,"ForceField") then continue end
			if not data.noTeam and team == C.plr.Team and #TS.GetChildren(TS)>1 then continue end
			local theirHumanoid = theirChar.FindFirstChildOfClass(theirChar,"Humanoid")
			if not theirHumanoid or theirHumanoid.Health <= 0 then continue end
			if data.notSeated and (theirHumanoid.SeatPart or theirChar.FindFirstChild(theirChar,"ForceFieldVar")) then continue end
			local theirHead = theirChar.FindFirstChild(theirChar,"Head")
			if not theirHead then continue end

			local d = (theirHead.Position - myHRPPos).Magnitude

			if d < distance then
				distance = d
				closest = theirHead
			end
		end

		return closest, distance
	end

	-- Spectate
	function C.Spectate(theirChar: Model)
		workspace.CurrentCamera.CameraSubject = theirChar and ((theirChar:IsA("Model") and (theirChar:FindFirstChild("Humanoid") or theirChar.PrimaryPart))
			or (theirChar:IsA("BasePart") and theirChar)) or C.human
	end

	-- Disable Humanoid Parts
	function C.SetHumanoidTouch(enabled,reason)
		for num, basePart in ipairs(C.char:GetDescendants()) do
			if not basePart:IsA("BasePart") then
				continue
			end
			if enabled then
				C.SetPartProperty(basePart,"CanTouch",reason)
			else
				C.ResetPartProperty(basePart,"CanTouch",reason)
			end
		end
	end

	-- Get Non Friends
	function C.GetNonFriends()
		local list = {}
		for num, theirPlr in ipairs(PS:GetPlayers()) do
			if C.CanTargetPlayer(theirPlr) then
				table.insert(list, theirPlr)
			end
		end
		return list
	end

	-- Function to get originally property
	function C.GetPartProperty(part, propertyName)
		local value = part:GetAttribute(propertyName .. "_OriginalValue")
		if value ~= nil then
			return value
		end
		return part[propertyName]
	end
	-- Function to set the property with an option to always set it
	function C.SetPartProperty(part, propertyName, requestName, value, alwaysSet, noFunction)
		if C.gameUniverse == "Flee" and part.Name == "Weight" then
			return
		elseif value == C then
			return C.ResetPartProperty(part,propertyName,requestName)
		end

		-- Attribute to track request count
		local requestCountAttr = propertyName .. "_RequestCount"
		local originalValueAttr = propertyName .. "_OriginalValue"

		-- Initialize the attributes if they don't exist
		if part:GetAttribute(requestCountAttr) == nil then
			part:SetAttribute(requestCountAttr, 0)
		end
		if part:GetAttribute(originalValueAttr) == nil then
			part:SetAttribute(originalValueAttr, part[propertyName])
		end

		-- Get the current request count
		local requestCount = part:GetAttribute(requestCountAttr)

		-- Create the unique attribute name for the request
		local requestAttrName = propertyName .. "_Request_" .. requestName

		-- Increment the request count if the request is not already present
		if part:GetAttribute(requestAttrName) == nil then
			part:SetAttribute(requestCountAttr, requestCount + 1)

			if not C.forcePropertyFuncts[part] then
				C.forcePropertyFuncts[part] = {}
			end
			if not C.forcePropertyFuncts[part][propertyName] and not noFunction then
				--print("Added Function",part)
				C.forcePropertyFuncts[part][propertyName] = part:GetPropertyChangedSignal(propertyName):Connect(function()
					local new = part:GetAttribute(requestAttrName)
					if new == nil then
						return -- do nothing, probably reloading!
					end
					--print(part,propertyName,"Changed","SEt to",new)
					--[[local cur,new = part[propertyName], part:GetAttribute(requestAttrName)
					if typeof(cur) == "CFrame" and (cur.LookVector-new.LookVector).Magnitude < 1 and (cur.Position-new.Position).Magnitude < 1 then
						return
					elseif typeof(cur) == "Vector3" and (cur-new).Magnitude < 1 then
						return
					end-]]
					part[propertyName] = new -- get latest value
				end)
			end
		end
		part:SetAttribute(requestAttrName, value)

		if requestCount == 0 or alwaysSet then
			part[propertyName] = value
		end
	end

	-- Function to remove a request
	function C.ResetPartProperty(part, propertyName, requestName)
		-- Attribute to track request count
		local requestCountAttr = propertyName .. "_RequestCount"
		local originalValueAttr = propertyName .. "_OriginalValue"

		-- Get the current request count
		local requestCount = part:GetAttribute(requestCountAttr)

		-- Create the unique attribute name for the request
		local requestAttrName = propertyName .. "_Request_" .. requestName

		-- Decrement the request count and revert property if no more requests
		if part:GetAttribute(requestAttrName) ~= nil then
			part:SetAttribute(requestAttrName, nil)
			part:SetAttribute(requestCountAttr, requestCount - 1)

			if requestCount - 1 == 0 then
				if C.forcePropertyFuncts[part] and C.forcePropertyFuncts[part][propertyName] then
					C.forcePropertyFuncts[part][propertyName]:Disconnect()
					C.forcePropertyFuncts[part][propertyName] = nil -- Remove from memory
				end

				part[propertyName] = part:GetAttribute(originalValueAttr)
				part:SetAttribute(requestCountAttr, nil)
			end
		end
	end
	
	function C.SendGeneralMessage(message:string)
		if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
			C.StringWait(TCS,"TextChannels.RBXGeneral"):SendAsync(message)
		elseif TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
			C.StringWait(RS,"DefaultChatSystemChatEvents.SayMessageRequest"):FireServer(message,"All")
		else
			error("Unknown TCS ChatVersion For SendGeneralMessage: "..TCS.ChatVersion.Name)
		end
	end

	function C.InternallySetConnections(signal,enabled)
		for _, connection in ipairs(C.getconnections(signal)) do
			if not connection.ForeignState then
				connection[enabled and "Enable" or "Disable"](connection)
			end
		end
	end
	--Function to set instance connection
	function C.DisableInstanceConnections(instance,name,key)
		assert(key~="Value" and key~="Name",`Unable to assign {instance.Name} the key {key} because {key} is a protected value!`)
		local signal = instance[name]
		local instanceData = C.PartConnections[instance]
		if not instanceData then
			instanceData = {}
			C.PartConnections[instance] = instanceData
		end
		if not instanceData[name] then
			instanceData[name] = {Value = 0,Name = name}
			C.InternallySetConnections(signal,false)
		end
		if not instanceData[name][key] then
			instanceData[name][key] = true
			instanceData[name].Value += 1
		end
	end
	function C.EnableInstanceConnections(instance,name,key)
		local signal = instance[name]
		local instanceData = C.PartConnections[instance]
		if not instanceData then
			return
		end
		if not instanceData[name] then
			return
		end
		if instanceData[name][key] then
			instanceData[name][key] = nil
			instanceData[name].Value -= 1
		end
		if instanceData[name].Value > 0 then
			return
		end
		C.InternallySetConnections(signal,true)
		instanceData[name] = nil -- clear the signal data
		if C.GetDictLength(instanceData) <= 0 then -- if its empty
			-- then clear the cache!
			C.PartConnections[instance] = nil
		end
	end

	function C.IsInBox(PartCF:CFrame,PartSize:Vector3,Point:Vector3,TwoDim:boolean)
		local Transform = PartCF:PointToObjectSpace(Point) -- Transform into local space
		local HalfSize = PartSize * 0.5

		return math.abs(Transform.X) <= HalfSize.X and
			(TwoDim or math.abs(Transform.Y) <= HalfSize.Y) and
			math.abs(Transform.Z) <= HalfSize.Z
	end
	function C.ClosestPointOnPart(PartCF, PartSize, Point)
		local Transform = PartCF:pointToObjectSpace(Point) -- Transform into local space
		local HalfSize = PartSize * 0.5
		return PartCF * Vector3.new( -- Clamp & transform into world space
			math.clamp(Transform.x, -HalfSize.x, HalfSize.x),
			math.clamp(Transform.y, -HalfSize.y, HalfSize.y),
			math.clamp(Transform.z, -HalfSize.z, HalfSize.z)
		)
	end
	function C.ClosestPointOnPartSurface(PartCF, PartSize, Point)
		local Transform = PartCF:pointToObjectSpace(Point) -- Transform into local space
		local HalfSize = PartSize * 0.5

		-- Calculate distances to each face
		local distances = {
			xMin = math.abs(Transform.x + HalfSize.x),
			xMax = math.abs(Transform.x - HalfSize.x),
			yMin = math.abs(Transform.y + HalfSize.y),
			yMax = math.abs(Transform.y - HalfSize.y),
			zMin = math.abs(Transform.z + HalfSize.z),
			zMax = math.abs(Transform.z - HalfSize.z)
		}

		-- Determine the minimum distance to a surface
		local minDistance = math.min(distances.xMin, distances.xMax, distances.yMin, distances.yMax, distances.zMin, distances.zMax)

		-- Create a new vector for the clamped point
		local clampedPoint

		-- Project the point to the closest surface
		if minDistance == distances.xMin then
			clampedPoint = Vector3.new(-HalfSize.x, Transform.y, Transform.z)
		elseif minDistance == distances.xMax then
			clampedPoint = Vector3.new(HalfSize.x, Transform.y, Transform.z)
		elseif minDistance == distances.yMin then
			clampedPoint = Vector3.new(Transform.x, -HalfSize.y, Transform.z)
		elseif minDistance == distances.yMax then
			clampedPoint = Vector3.new(Transform.x, HalfSize.y, Transform.z)
		elseif minDistance == distances.zMin then
			clampedPoint = Vector3.new(Transform.x, Transform.y, -HalfSize.z)
		elseif minDistance == distances.zMax then
			clampedPoint = Vector3.new(Transform.x, Transform.y, HalfSize.z)
		end

		-- Transform back to world space and return the point on the surface
		return PartCF * clampedPoint
	end
	function C.RandomPointOnPart(cframe,size)
		-- Generate a random point within the part's bounds in local space
		local randomX = C.Randomizer:NextNumber(0,1) * size.X - size.X / 2
		local randomY = C.Randomizer:NextNumber(0,1) * size.Y - size.Y / 2
		local randomZ = C.Randomizer:NextNumber(0,1) * size.Z - size.Z / 2
		local localPoint = Vector3.new(randomX, randomY, randomZ)

		-- Convert the local point to world space
		local worldPoint = cframe:PointToWorldSpace(localPoint)

		return worldPoint
	end

	function C.ComputeNameColor(speaker)
		local nameColors = {
			Color3.new(253/255, 41/255, 67/255),
			Color3.new(1/255, 162/255, 255/255),
			Color3.new(2/255, 184/255, 87/255),
			BrickColor.new("Bright violet").Color,
			BrickColor.new("Bright orange").Color,
			BrickColor.new("Bright yellow").Color,
			BrickColor.new("Light reddish violet").Color,
			BrickColor.new("Brick yellow").Color,
		}
	
		local value = 0
		for i = 1, #speaker do
			local cValue = string.byte(speaker, i)
			if ((#speaker - i + 1) % 4) >= 2 then cValue = -cValue end
			value = value + cValue
		end
	
		return nameColors[(value % #nameColors) + 1]
	end

	C.PlayerCoords = {}
	C.SavedLoc = nil

	function C.SavePlayerCoords(name:string)
		if not C.SavedLoc and C.char then
			C.SavedPoso = C.char:GetPivot()
		end
		C.PlayerCoords[name] = true
	end

	function C.LoadPlayerCoords(name:string)
		C.PlayerCoords[name] = nil
		for name, value in pairs(C.PlayerCoords) do
			return -- stop if there's only one
		end
		if C.SavedPoso then
			C.DoTeleport(C.SavedPoso)
			C.SavedPoso = nil -- reset it
		end
	end


	local TransformTimes={
		[-24]="Tomorrow, %s",
		[0]="Today, %s",
		[24]="Yesterday, %s"
	}
	local TimeDurations={
		{Type="Year",Duration=31536000},
		{Type="Month",Duration=2551392},
		{Type="Day",Duration=86400},
		{Type="Hour",Duration=3600},
		{Type="Min",Duration=60},
		{Type="Sec",Duration=1},
	}
	function C.FormatTimeFromUnix(osTime,token)
		local timeNeededTimeStamp	
		if tonumber(osTime) then
			timeNeededTimeStamp=DateTime.fromUnixTimestamp(osTime)
		else
			timeNeededTimeStamp=DateTime.fromIsoDate(osTime)
		end
		local theTimeNeededTbl=timeNeededTimeStamp:ToLocalTime()
		local theCurrentTime=DateTime.now():ToLocalTime()
		for minTime,identifier in pairs(TransformTimes) do
			local generatedTime=DateTime.fromLocalTime(theCurrentTime.Year,theCurrentTime.Month,theCurrentTime.Day,12-minTime,0,0):ToLocalTime()
			if generatedTime.Year==theTimeNeededTbl.Year and generatedTime.Month==theTimeNeededTbl.Month and generatedTime.Day==theTimeNeededTbl.Day then
				return string.format(identifier,timeNeededTimeStamp:FormatLocalTime(token or "LT",LS.RobloxLocaleId))
			end
		end
		local TimeString=timeNeededTimeStamp:FormatLocalTime(token or "LLL",LS.RobloxLocaleId)
		if theCurrentTime.Year==theTimeNeededTbl.Year then
			TimeString=TimeString:gsub(", "..theTimeNeededTbl.Year, "")
		end
		return TimeString
	end
	function C.GetFormattedTime(totalTime,shouldBeLowered,extraSettings)
		extraSettings = extraSettings or {}
		local carryDown = false
		local Table = {}
		for order,vals in pairs(TimeDurations) do
			local counters = math.floor(totalTime/vals.Duration)
			if counters>0 or (#Table==0 and order==#TimeDurations) or (carryDown and extraSettings.CarryDown) then--if it's the last one might as well put seconds...
				table.insert(Table,counters.." "..(shouldBeLowered and vals.Type:lower() or vals.Type)..((counters~=1 or extraSettings.AlwaysPlural) and "s" or ""))
				carryDown=true
			end
			totalTime-=vals.Duration*counters
		end
		if #Table>2 then
			Table[#Table]="and "..Table[#Table]--adds the and to the last character of the list
		end
		return table.concat(Table,", ")
	end
	function C.ServerTeleport(PlaceId: number,JobId: number)
		if C.Cleared then
			return -- Nope! Don't teleport!
		end
		if not C:SaveProfile() then-- Save Profile First!
			return
		end
		C.DebugMessage("Teleport",`Teleport Beggining for {JobId}...`)
		C.API(TeleportService,"TeleportToPlaceInstance",1,PlaceId,JobId,C.plr)
		--TeleportService:TeleportToPlaceInstance(PlaceId,JobId,C.plr)
	end
	function C.GetMinMax(n1,n2)
		if n2 > n1 then
			return n1, n2
		else
			return n2, n1
		end
	end
	function C.ClampNoCrash(x,n1,n2)
		return math.clamp(x,C.GetMinMax(n1,n2))
	end
end