local CAS = game:GetService("ContextActionService")
local CS = game:GetService("CollectionService")
local PS = game:GetService("Players")
local TCS = game:GetService"TextChatService"
local RS = game:GetService"ReplicatedStorage"
local DS = game:GetService('Debris')
return function(C,Settings)
	C.OriginalCollideName = "WeirdCanCollide"
	--Table Functions
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
	--Raycast
	local rayParams = RaycastParams.new()
	rayParams.IgnoreWater = true
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
	

	function C.StringStartsWith(tbl,name,override,leaveAsIs)
		if name == "" and not override then
			return {}
		end
		name = name:lower()
		local closestMatch, results = math.huge, {}
		for index, theirValue in pairs(tbl) do
			local itsIndex = tostring((typeof(theirValue)=="table" and (theirValue.SortName or theirValue[1])) or (typeof(index)=="number" and theirValue) or index)
			local canPass = itsIndex:lower():sub(1,name:len()) == name
			if not canPass then
				itsIndex = (typeof(theirValue)=="Instance" and theirValue.ClassName=="Player" and theirValue.DisplayName) or itsIndex
				canPass = itsIndex:lower():sub(1,name:len()) == name
			end
			if canPass then
				if itsIndex:len() < closestMatch or true then
					closestMatch = itsIndex:len() / (typeof(theirValue)=="table" and theirValue.Priority or 1)
					table.insert(results,leaveAsIs and theirValue or {index,theirValue})
				end
			end
		end
		return results;
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
	-- Force Add Function, C.hackData[name][hackData.Shortcut]
	function C.AddOverride(hackTbl,name)
		local old = #hackTbl.Override
		if C.TblAdd(hackTbl.Override,name) then
			C.DebugMessage("Override",`Added marker "{name}" to override`)
			hackTbl.RealEnabled = true
			if old == 0 and not hackTbl.Enabled then
				C.DebugMessage("Override",`Ran function from override`)
				C.DoActive(hackTbl.Activate,hackTbl,hackTbl.RealEnabled)
			end
		end
	end
	function C.RemoveOverride(hackTbl,name)
		if C.TblRemove(hackTbl.Override,name) then
			C.DebugMessage("Override",`Removed marker "{name}" from override`)
			if #hackTbl.Override == 0 then
				hackTbl.RealEnabled = hackTbl.Enabled
				if not hackTbl.RealEnabled then
					C.DebugMessage("Override",`Removed function from override`)
					C.DoActive(hackTbl.Activate,hackTbl,hackTbl.RealEnabled)
				end
			end
		end
	end

	-- Function to set the property with an option to always set it
	function C.SetPartProperty(part, propertyName, requestName, value, alwaysSet)
		if C.gameUniverse == "Flee" and part.Name == "Weight" then
			return
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
			part:SetAttribute(requestAttrName, true)
			part:SetAttribute(requestCountAttr, requestCount + 1)

			if not C.forcePropertyFuncts[part] then
				C.forcePropertyFuncts[part] = {}
			end
			if not C.forcePropertyFuncts[part][propertyName] then
				C.forcePropertyFuncts[part][propertyName] = part:GetPropertyChangedSignal(propertyName):Connect(function()
					part[propertyName] = value
				end)
			end
		end

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
		if part:GetAttribute(requestAttrName) then
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
end