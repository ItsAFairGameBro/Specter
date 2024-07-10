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
	
	-- Function to perform a raycast with options
	function C.Raycast(origin, direction, options)
		options = options or {}

		local ignoreList = options.ignoreList or {}  -- List of instances to ignore
		local ignoreInvisibleWalls = options.ignoreInvisibleWalls or false  -- Ignore parts with CanCollide = false
		local ignoreUncollidable = options.ignoreUncollidable or false  -- Ignore parts with custom collision enabled
		local raycastFilterType = options.raycastFilterType or Enum.RaycastFilterType.Exclude  -- Default to blacklist
		local distance = options.distance or 30

		local rayParams = RaycastParams.new()
		rayParams.FilterType = raycastFilterType
		rayParams.IgnoreWater = true
		rayParams.FilterDescendantsInstances = ignoreList

		local hitPart, hitPosition, hitNormal = nil, nil, nil
		local didHit = false

		local function customFilter(instance)
			if ignoreInvisibleWalls and instance.Transparency > .9 then
				return false
			end

			if ignoreUncollidable and not instance.CanCollide then
				return false
			end

			return true
		end
		
		--direction = (direction - origin).Unit
		local hitResult
		local attempts = 0
		repeat
			hitResult = workspace:Raycast(origin, direction * distance, rayParams)

			if hitResult then
				if customFilter(hitResult.Instance) then
					hitPart = hitResult.Instance
					hitPosition = hitResult.Position
					hitNormal = hitResult.Normal
					didHit = true
				else
					-- Adjust origin slightly to retry
					origin = hitResult.Position + direction * 0.01
					distance -= hitResult.Distance
				end
			else
				didHit = false
				break
			end

			attempts = attempts + 1
		until didHit
		
		local hitPosition = hitResult and hitResult.Position
		if not hitPosition then
			hitPosition = origin + direction * options.distance
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
			fake = string.gsub(fake, "\n", "\r")
			C.StringWait(TCS,"TextChannels.RBXGeneral"):SendAsync(real..'\r'..fake)
		elseif TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
			C.StringWait(RS,"DefaultChatSystemChatEvents.SayMessageRequest"):FireServer(real..string.sub((" "):rep(155),#real)..fake,"All")
		else
			error("Unknown TCS ChatVersion For SendGeneralMessage: "..tostring(TCS.ChatVersion))
		end
	end
end
