local PS = game:GetService("Players")
local GS = game:GetService("GuiService")

return function(C,Settings)
	--[[for eventName,functDict in pairs(C.events) do
		for hackTbl, funct in pairs(functDict) do

		end
	end--]]
    C.SaveEvents = {MyRagdoll={}, Ragdoll={}, OthersRagdoll={},
                    MyBeast={}, Beast={}, OthersBeast={},
                    Game={}, BeastRope={}}
	local function FireEvent(name,doExternalConn,...)
        local SavedTable = C.SaveEvents[name:gsub("Added",""):gsub("Removed","")]
        if SavedTable then
            local args = table.pack(...)
            if name:find("Removed") then
                local del = false
                for key, val in ipairs(SavedTable) do
                    if C.AreTablesEqual(val, args) then
                        table.remove(SavedTable, key)
                        del = true
                        break
                    end
                end
                if not del then
                    warn(`[Events.FireEvent]: {name} has SaveEvent label but does not delete!`)
                end
            elseif name:find("Added") then
                table.insert(SavedTable, args)
            else
                warn(`[Events.FireEvent]: Unknown Prefix: {name} doesn't have Added or Removed`)
            end

        end
		if doExternalConn~=nil then
			if doExternalConn then
				FireEvent("My"..name,nil,...)
			else
				FireEvent("Others"..name,nil,...)
			end
		end
		for hackTbl, funct in pairs(C.events[name] or {}) do
			if typeof(hackTbl) ~= "table" then
				task.spawn(funct,...)
			elseif hackTbl.RealEnabled or hackTbl.AlwaysFireEvents then
				local Thread = task.spawn(funct,hackTbl,...)
				if hackTbl.Threads then
					table.insert(hackTbl.Threads,Thread)
                end
			end
		end
	end
	local function ShouldConnectEvent(name)
        --if C.events[name]==nil then
            --warn("Not Loading",name,"Event!")
        --end
		return Settings.ConnectAllEvents or C.events[name]~=nil
	end
	C.FireEvent = FireEvent
    local HasAttachment = game.GameId ~= 5203828273 -- Dress To Impress
	local function CharAdded(theirChar,wasAlreadyIn)
		local theirPlr = PS:GetPlayerFromCharacter(theirChar)
		local theirHuman = theirChar:WaitForChild("Humanoid",1e5)
		if not theirHuman then
			return
		end
		local theirAnimator = theirHuman:WaitForChild("Animator")
		local centerPart = theirChar:WaitForChild("HumanoidRootPart",15)
		if not centerPart then
			return
		end
        local rootAttachment = HasAttachment and centerPart:WaitForChild("RootAttachment")
		local isMe = C.plr.Character == theirChar
		if isMe then
			C.char = theirChar
			C.human = theirHuman
			C.animator = theirAnimator
			C.hrp = centerPart
            C.rootAttachment = rootAttachment
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
				elseif not active and not lastSeatPart then
					return -- get out, was not seated!
				end
				if isMe then
					C.SeatPart = seatPart
				end
                --print("Firing","Seat"..(active and "Added" or "Removed"),isMe,lastSeatPart,C.events.MySeatAdded)
				FireEvent("Seat"..(active and "Added" or "Removed"),isMe,lastSeatPart)
			end--instance,key,connection
			C.AddObjectConnection(theirHuman,"EventsSeatChanged",theirHuman.Seated:Connect(SeatAdded))
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
				end
			end))
		end
        for _, additionalFunct in ipairs(C.CharacterAddedEventFuncts) do
            additionalFunct(theirPlr, theirChar, theirHuman)
        end
		task.wait(0.1)
		FireEvent("CharAdded",isMe,theirPlr,theirChar,wasAlreadyIn)
	end
	local function CharRemoving(theirChar)
		local theirPlr = PS:GetPlayerFromCharacter(theirChar)
		local isMe = theirPlr == C.plr
		FireEvent("CharRemoved",isMe,theirPlr,theirChar)
	end
	local function PlrAdded(theirPlr,wasAlreadyIn)
		local isMe = theirPlr == C.plr
        local isFirst = true
		if theirPlr.Character then
			task.spawn(CharAdded,theirPlr.Character,true)
            isFirst = false
		end
		C.AddPlayerConnection(theirPlr,theirPlr.CharacterAdded:Connect(function(newChar)
            CharAdded(newChar, isFirst)
            isFirst = false
        end))
		--if ShouldConnectEvent("CharRemoved",true) then
		C.AddPlayerConnection(theirPlr,theirPlr.CharacterRemoving:Connect(CharRemoving))
		--end
		FireEvent("PlayerAdded",isMe,theirPlr,wasAlreadyIn)
		if (isMe and ShouldConnectEvent("MyTeamAdded")) or (isMe and ShouldConnectEvent("MyTeamRemoved")) or
			ShouldConnectEvent("TeamAdded") or ShouldConnectEvent("TeamRemoved") then
			local function RegisterNewTeam()
				if theirPlr.Team then
					FireEvent("TeamAdded",isMe,theirPlr,theirPlr.Team)
				end
			end
			C.AddPlayerConnection(theirPlr, theirPlr:GetPropertyChangedSignal("Team"):Connect(RegisterNewTeam))
			RegisterNewTeam()
		end
        for _, theirFunct in ipairs(C.PlayerAddedEventFuncts) do
            theirFunct(theirPlr, wasAlreadyIn)
        end
	end
	local function PlrRemoving(theirPlr)
		C.RemoveAllPlayerConnections(theirPlr)
	end
	-- Connect other events
	for num, eventFunct in ipairs(C.EventFunctions) do
		eventFunct()
	end
	C.EventFunctions = nil

	C.AddGlobalConnection(PS.PlayerAdded:Connect(PlrAdded))
	C.AddGlobalConnection(PS.PlayerRemoving:Connect(PlrRemoving))
	for num, theirPlr in ipairs(PS:GetPlayers()) do
		task.spawn(PlrAdded,theirPlr,true)
	end
	C.Camera = workspace.CurrentCamera
	C.AddGlobalConnection(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		local newCamera = workspace.CurrentCamera
		if newCamera then
			C.Camera = newCamera
		end
	end))
	-- Kick detection
	local WhitelistedCodes = {
		[266] = "Connection",
		[267] = "Kick",
		[277] = "Connection",
		[288] = "Shut Down",
		[769] = "Teleport Failed",
	}
	local function CheckStatusCodes(ErrorMessage)
		local ErrorCodeInstanceVal = GS:GetErrorCode()
		local ErrorCode = ErrorCodeInstanceVal and ErrorCodeInstanceVal.Value or -1
		local ErrorIdentification = WhitelistedCodes[ErrorCode]
		if not ErrorIdentification then
			if ErrorCode ~= 0 then
				print("[Events.CheckStatusCodes]: Unknown Error Code:",ErrorCode)
			end
			return
		elseif ErrorMessage:len() == 0 then
			print("Blank Code Ignored For ErrorCode:",ErrorCode)
			return
		end
		FireEvent("RbxErrorPrompt", nil, ErrorMessage, ErrorCode, ErrorIdentification)
	end
	if not C.isStudio then
		C.AddGlobalConnection(GS.ErrorMessageChanged:Connect(CheckStatusCodes))
		CheckStatusCodes(GS:GetErrorMessage())
	end
end
