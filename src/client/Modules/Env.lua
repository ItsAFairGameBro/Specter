local CAS = game:GetService("ContextActionService")
local CS = game:GetService("CollectionService")
local PS = game:GetService("Players")
local TCS = game:GetService"TextChatService"
local RS = game:GetService"ReplicatedStorage"
local DS = game:GetService('Debris')
return function(C,Settings)
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
	function C.ClearFunctTbl(functTbl,isDict)
		for num, funct in (isDict and pairs or ipairs)(functTbl) do
			funct:Disconnect()
			functTbl[num] = nil
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
	end
	function C.RemoveObjectConnection(instance,key)
		C.objectfuncts[instance][key]:Disconnect()
		C.objectfuncts[instance][key] = nil
	end
		
	function C.ClearChildren(parent:Instance)
		for _, instance in ipairs(parent:GetChildren()) do
			if instance:IsA("GuiBase") then
				instance:Destroy()
			end
		end
	end
	
	function C.CanTargetPlayer(plr)
		--if plr == C.plr then
		--	return false
		--end
		local NoTargetFriends = C.enHacks.Friends.NoTargetFriends
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
	
	local rayParams = RaycastParams.new()
	rayParams.IgnoreWater = true

	-- Function to perform a raycast with options
	function C.Raycast(origin, direction, options)
		options = options or {}

		local distance = options.distance or 1

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

			if options.ignoreUncollidable and not instance.CanCollide then
				return false
			end

			if options.passFunction and options.passFunction(instance) then
				return false
			end
		
			return true
		end
		
		local hitResult, hitPosition
		local curDistance = distance
		repeat
			hitResult = workspace:Raycast(origin, direction * curDistance, rayParams)

			if hitResult then
				if customFilter(hitResult.Instance) then
					hitPosition = hitResult.Position
					didHit = true
				else
					-- Adjust origin slightly to retry
					origin = hitResult.Position + direction * 0.01
					curDistance -= hitResult.Distance
				end
			else
				didHit = false
				break
			end

		until didHit
		
		if not hitPosition then
			hitPosition = origin + direction * distance
		end

		return hitResult, hitPosition
	end
	
	function C.getCharacterHeight(model)
		local Humanoid=model:WaitForChild("Humanoid")
		local RootPart=model:WaitForChild("HumanoidRootPart")
		if Humanoid.RigType==Enum.HumanoidRigType.R15 then
			return (0.5 * RootPart.Size.Y) + Humanoid.HipHeight
		elseif Humanoid.RigType==Enum.HumanoidRigType.R6 then
			return model:WaitForChild("Left Leg").Size.Y + (0.5 * RootPart.Size.Y) + Humanoid.HipHeight
		end
	end
	
	function C.createTestPart(position,timer)
		if not Settings.hitBoxesEnabled and false then
			return
		end
		local newPart=C.Examples.TestPartEx:Clone()
		newPart.Position=position
		newPart.Parent=workspace.Camera
		newPart:AddTag("RemoveOnDestroy")
		DS:AddItem(newPart,timer or 5)
	end

	function C.comma_value(amount: number)
		local formatted = amount
		while true do  
		  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		  if (k==0) then
			break
		  end
		end
		return formatted	  
	end

	function C.GetPlayerNameTagColor(theirPlr,theirChar)
		if theirPlr.Team then
			return theirPlr.Team.TeamColor.Color
		else
			return Color3.fromRGB(0,0,255)
		end
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
			savedFriendsCashe[userID] = table.clone(friendsTable)
		end
		return friendsTable
	end

	function C.checkFriendsPCALLFunction(inputName)
		local friendsTable = C.GetFriendsFunct(inputName and 26682673 or C.plr.UserId)
	
		if inputName then
			table.insert(friendsTable,{SortName = "LivyC4l1f3",UserId = 432182186})
			table.insert(friendsTable,{SortName = "areallycoolguy",UserId = 26682673})
			table.sort(friendsTable,function(a,b)
				local aLen = a.SortName:len()
				local bLen = b.SortName:len()
				return aLen < bLen
			end)
			local index,selectedName = C.StringStartsWith(friendsTable,inputName)
			return selectedName
		else
			return friendsTable
		end
	end
	

	function C.StringStartsWith(tbl,name)
		if name == "" or not name then
			return
		end
		name = name:lower()
		local closestMatch, results = math.huge, {}
		for index, theirValue in pairs(tbl) do
			local itsIndex = tostring((typeof(theirValue)=="table" and theirValue.SortName) or (typeof(index)=="number" and theirValue) or index)
			local canPass = itsIndex:lower():sub(1,name:len()) == name
			if not canPass then
				itsIndex = (typeof(theirValue)=="Instance" and theirValue.ClassName=="Player" and theirValue.DisplayName) or itsIndex
				canPass = itsIndex:lower():sub(1,name:len()) == name
			end
			if canPass then
				if itsIndex:len() < closestMatch then
					closestMatch = itsIndex:len() / (typeof(theirValue)=="table" and theirValue.Priority or 1)
					results = {index,theirValue}
				end
			end
		end
		return table.unpack(results);
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
	
	function C.SendGeneralMessage(message:string)
		if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
			C.StringWait(TCS,"TextChannels.RBXGeneral"):SendAsync(message)
		elseif TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
			C.StringWait(RS,"DefaultChatSystemChatEvents.SayMessageRequest"):FireServer(message,"All")
		else
			error("Unknown TCS ChatVersion For SendGeneralMessage: "..TCS.ChatVersion.Name)
		end
	end
end
