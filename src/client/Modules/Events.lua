local PS = game:GetService("Players")

return function(C,Settings)
	--[[for eventName,functDict in pairs(C.events) do
		for hackTbl, funct in pairs(functDict) do
			
		end
	end--]]
	local function FireEvent(name,doExternalConn,...)
		if doExternalConn~=nil then
			if doExternalConn then
				FireEvent("My"..name,nil,...)
			else
				FireEvent("Others"..name,nil,...)
			end
		end
		for hackTbl, funct in pairs(C.events[name] or {}) do
			if hackTbl.RealEnabled then
				funct(hackTbl,...)
			end
		end
	end
	local function ShouldConnectEvent(name)
		return Settings.ConnectAllEvents or C.events[name]~=nil
	end
	local function CharAdded(theirChar,wasAlreadyIn)
		local theirPlr = PS:GetPlayerFromCharacter(theirChar)
		local theirHuman = theirChar:WaitForChild("Humanoid")
		local theirAnimator = theirHuman:WaitForChild("Animator")
		local centerPart = theirChar:WaitForChild("HumanoidRootPart",15)
		if not centerPart then
			return
		end
		local isMe = C.plr.Character == theirChar
		if isMe then
			C.char = theirChar
			C.human = theirHuman
			C.animator = theirAnimator
			C.hrp = centerPart
		end
		theirChar:AddTag("Character")
		for num, part in ipairs(theirChar:GetDescendants()) do
			if part:IsA("BasePart") then
				part:AddTag("CharPart")
			end
		end
		if (isMe and ShouldConnectEvent("MySeatAdded")) or (isMe and ShouldConnectEvent("MySeatRemoved")) or 
			ShouldConnectEvent("SeatAdded") or ShouldConnectEvent("SeatRemoved") then
			local lastSeatPart
			local function SeatAdded(active,seatPart)
				--Do not connect global SeatAdded connections, hence the "nil"
				if active then
					lastSeatPart = seatPart
				end
				if isMe then
					C.seatPart = seatPart
				end
				FireEvent("Seat"..(active and "Added" or "Removed"),nil,lastSeatPart)
			end--instance,key,connection
			C.AddObjectConnection(theirHuman,"EventsSeatChanged",theirHuman.SeatAdded:Connect(SeatAdded))
			SeatAdded(theirHuman.SeatPart~=nil, theirHuman.SeatPart)
		end
		if ShouldConnectEvent("MyCharDied",true) and isMe then
			C.AddObjectConnection(theirHuman,"EventsHumanDied",theirHuman.Died:Connect(function()
				FireEvent("MyCharDied",nil,theirPlr,theirChar)
			end))
		end
		if ShouldConnectEvent("CharRemoved",true) then
			C.AddObjectConnection(theirChar,"CharRemoved",theirChar.AncestryChanged:Connect(function(oldParent, newParent)
				if not newParent then
					FireEvent("CharRemoved",isMe,theirPlr,theirChar)
				end
			end))
		end
		FireEvent("CharAdded",isMe,theirPlr,theirChar,wasAlreadyIn)
	end
	local function PlrAdded(theirPlr,wasAlreadyIn)
		if theirPlr.Character then
			task.spawn(CharAdded,theirPlr.Character,true)
		end
		C.AddPlayerConnection(theirPlr,theirPlr.CharacterAdded:Connect(CharAdded))
		FireEvent("PlayerAdded",theirPlr==C.plr,theirPlr,wasAlreadyIn)
	end
	local function PlrRemoving(theirPlr)
		C.RemoveAllPlayerConnections(theirPlr)
	end
	C.AddGlobalConnection(PS.PlayerAdded:Connect(PlrAdded))
	C.AddGlobalConnection(PS.PlayerRemoving:Connect(PlrRemoving))
	for num, theirPlr in ipairs(PS:GetPlayers()) do
		task.spawn(PlrAdded,theirPlr,true)
	end
end
