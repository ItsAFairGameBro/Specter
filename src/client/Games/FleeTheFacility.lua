local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local DS = game:GetService("Debris")
local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local GS = game:GetService("GuiService")
local PS = game:GetService("Players")
local LS = game:GetService("Lighting")
local RS = game:GetService("ReplicatedStorage")
local SG = game:GetService("StarterGui")


local MAX_SHOP_ITEM = 10
local BotActionClone

-- STANDARD FUNCTIONS--

local function AppendToFirstArr(tbl1, tbl2, clone)
    for _, val2 in ipairs(tbl2) do
        table.insert(tbl1, clone and table.clone(val2) or val2)
    end
    return tbl1
end

local function GetSharedHacks(C, Settings)
    function C.sortPlayersByXPThenCredits(plrList)
		plrList = plrList or PS:GetPlayers()


		table.sort(plrList,	function(a,b)
			local aStats=a:FindFirstChild("SavedPlayerStatsModule")
			local bStats=b:FindFirstChild("SavedPlayerStatsModule")
			local doesExistA, doesExistB = aStats and aStats.Parent, bStats and bStats.Parent
			if doesExistA and not doesExistB then
				return true
			elseif not doesExistA and doesExistB then
				return false
			end
			local isABot=table.find(C.BotUsers, a.Name:lower()) ~= nil
			local isBBot=table.find(C.BotUsers, b.Name:lower()) ~= nil
			if isABot~=isBBot then
				return isABot and not isBBot
			end
			local aLevel = aStats:FindFirstChild("Level")
			local bLevel = bStats:FindFirstChild("Level")
			if not aLevel or not bLevel then
				return aLevel~=nil
			end
			if aLevel.Value~=bLevel.Value then
				return (aLevel.Value>bLevel.Value)
			end
			local aXP = aStats:FindFirstChild("Xp")
			local bXP = bStats:FindFirstChild("Xp")
			if not aXP or not bXP then
				return aXP~=nil
			end
			if aXP.Value~=bXP.Value then
				return (aXP.Value>bXP.Value)
			end
			if (aStats.Credits.Value ~= bStats.Credits.Value) then
				return (aStats.Credits.Value>bStats.Credits.Value)
			end
			return a.Name:lower() > b.Name:lower()
		end)

		return plrList
	end
    local SharedHacks = {
    {
        Title = "Speed Buy",
        Tooltip = "Automatically buys selected items up to n amount!",
        Layout = 0,
        Shortcut = "SpeedBuy",
        IgnoreList = {"Series 1H", "Series 1G"},

        Process = function(self, actionClone, info)
            C.SetActionLabel(actionClone, "Loading Modules...")

            local Crates = require(RS.ShopCrates)
            local Bundles = require(RS.ShopBundles)

            C.SetActionLabel(actionClone, "Loading Inventory...")
            local MyInventory, StartCount = C.GetUserInventory()
            local CurCount = StartCount
            local CountToPurchase = 0
            local ItemsToBuy = {}
            local function CountTotalFunction(itemName, itemType: nil, requiredItems)
                local amntToBuy = MAX_SHOP_ITEM
                if itemType then -- Crate
                    amntToBuy = self.EnTbl.EventCrateQty - (MyInventory[itemName] or 0)
                else-- Bundle
                    for _, item in ipairs(requiredItems) do
                        local itemNeeds = self.EnTbl.EventBundleQty - (MyInventory[item] or 0)
                        amntToBuy = math.min(amntToBuy, itemNeeds)
                    end
                    amntToBuy = amntToBuy * #requiredItems
                end
                if amntToBuy > 0 then
                    table.insert(ItemsToBuy,{itemName,itemType,requiredItems})
                end
                return amntToBuy
            end
            local function GetItemWhileNotLimit(itemName, itemType: nil, requiredItems)
                if itemType then -- Crate
                    while (MyInventory[itemName] or 0) < self.EnTbl.EventCrateQty do
                        actionClone.Title.Text = `Purchasing ({CurCount - StartCount + 1}/{CountToPurchase})`
                        C.SetActionLabel(actionClone, `{itemName}`)
                        C.RemoteEvent:FireServer("BuyCrateBoxItem", itemType, itemName)--SendWaitRemoteEvent("RefreshCurrentMenu","BuyCrateBoxItem", itemType, itemName)
                        task.wait(1)
                        MyInventory, CurCount = C.GetUserInventory()
                    end
                else-- Bundle
                    while true do
                        local HasAll = true
                        local HasOneMaxed = false
                        for _, item in ipairs(requiredItems) do
                            if (MyInventory[item] or 0) < self.EnTbl.EventBundleQty then
                                HasAll = false
                            elseif (MyInventory[item] or 0) >= MAX_SHOP_ITEM then
                                HasOneMaxed = true
                                break
                            end
                        end
                        if HasAll or HasOneMaxed then
                            break
                        end
                        actionClone.Title.Text = `Purchasing ({CurCount - StartCount + 1}/{CountToPurchase})`
                        C.SetActionLabel(actionClone, `{itemName}`)
                        C.RemoteEvent:FireServer("BuyShopBundle",itemName)--SendWaitRemoteEvent("RefreshCurrentMenu","BuyShopBundle",itemName)
                        task.wait(1)
                        MyInventory, CurCount = C.GetUserInventory()
                    end
                end

            end
            C.SetActionLabel(actionClone, "Calculating")
            local start = os.clock()
            for name, data in pairs(Crates) do
                if not table.find(self.IgnoreList, name) then
                    for _, prizeVal in pairs(data.Prizes) do
                        CountToPurchase+=CountTotalFunction(prizeVal, name)
                    end
                end
            end
            for name, data in pairs(Bundles) do
                if not data.CostRobux then
                    CountToPurchase+=CountTotalFunction(name, nil, data.Items)
                end
            end

            -- Dummy Check / Confirmation
            info.CanCancel += 1
            local CanContinue = CountToPurchase > 0 and C.Prompt(`Purchase {CountToPurchase} Items`,
                `Are you sure that you want to buy these hammers and gems?\nIf you are unsure, configure this under "Speed Buy".`, "Y/N")
            info.CanCancel -= 1
            if CanContinue then
                C.hackData.FleeTheFacility.InstaTrade:SetValue(false) -- Disable the trading mechanism while we buy bundles!
                for n, data in ipairs(ItemsToBuy) do
                    GetItemWhileNotLimit(table.unpack(data))
                end

                -- COMPELTED --
                C.CreateSysMessage(`Successfully purchased {CountToPurchase} crates and bundles in {C.GetFormattedTime(os.clock()-start)}!`, Color3.fromRGB(0,255,0))
            elseif CountToPurchase <= 0 then
                C.AddNotification(`No Items To Purchases`,`All the crates and bundles you have selected for pruchase are already in your inventory at the requested/max amount.`)
            end


            self:SetValue(false)
        end,
        Activate = function(self, enabled, firstRun)
            C.RemoveAction(self.Shortcut)
            if not enabled then
                return
            elseif firstRun then
                self:SetValue(false)
                return
            end

            local info = {Name = self.Shortcut, Title = "Purchasing", CanCancel = 0, Tags = {"RemoveOnDestroy"}, Threads = {}, Time = function(actionClone, info)
                self:Process(actionClone, info)
            end, Stop = function(byRequest)
                self:SetValue(false)
            end}
            local actionClone = C.AddAction(info)
        end,
        Options = {
            {
                Type = Types.Slider,
                Title = "Event Crates",
                Tooltip = "How much of every event crate to buy!",
                Layout = 1,Default = 10,
                Min = 0, Max=10, Digits=0,
                Shortcut="EventCrateQty",
            },
            {
                Type = Types.Slider,
                Title = "Event Bundles",
                Tooltip = "How much of every event bundle to buy!",
                Layout = 2,Default = 10,
                Min = 0, Max=10, Digits=0,
                Shortcut="EventBundleQty",
            },
        },
    },
    {
        Title = "Game Improvements",
        Tooltip = "Fixes stuff necessary to live💀",
        Layout = 100,
        Shortcut = "GameImprovements",
        Default = true,
        TeleportOnFailPos = Vector3.new(103, 8, -435),
        Functs = {},
        Activate = function(self, newValue, firstRun)
            if not newValue then
                return
            end
            if game.PlaceId == 893973440 then
                local ScreenGui = C.PlayerGui:WaitForChild("ScreenGui");
                local MenusTabFrame = ScreenGui:WaitForChild("MenusTabFrame");
                local BeastPowerMenuFrame = ScreenGui:WaitForChild("BeastPowerMenuFrame")
                local SurvivorStartFrame = ScreenGui:WaitForChild("SurvivorStartFrame")
                local IsCheckingLoadData = C.plr:WaitForChild("IsCheckingLoadData");
                local function menusTab()
                    MenusTabFrame.Visible=not IsCheckingLoadData.Value
                end
                local function beastScreen()
                    BeastPowerMenuFrame.Visible=false
                end
                local function survivorScreen()
                    SurvivorStartFrame.Visible=false
                end
                table.insert(self.Functs,MenusTabFrame:GetPropertyChangedSignal("Visible"):Connect(menusTab))
                menusTab()

                table.insert(self.Functs,BeastPowerMenuFrame:GetPropertyChangedSignal("Visible"):Connect(beastScreen))
                beastScreen()

                table.insert(self.Functs,SurvivorStartFrame:GetPropertyChangedSignal("Visible"):Connect(survivorScreen))
                survivorScreen()

                if firstRun then
                    return
                end

                for num, theirPlr in ipairs(PS:GetPlayers()) do
                    if theirPlr and theirPlr.Character then
                        task.spawn(self.Events.CharAdded, self, theirPlr, theirPlr.Character)
                    end
                end
            end
        end,
        Events = {
            MyCharAdded = C.ReloadHack,
            MapRemoved = function(self)
                local Torso = C.char and C.char:FindFirstChild("Torso")
                if Torso and (Torso.Anchored or C.char:FindFirstChild("RopeConstraint", true)) then
                    warn((Torso.Anchored and "Torso Anchored" or "RopeConstraint Found" ) .. " Anchored, Resetting...")
                    task.spawn(C.ResetCharacter)
                end
                if (C.isInGame(C.char)) then
                    C.DoTeleport(self.TeleportOnFailPos)
                    warn("Teleported back from the game because game ended, and map was destroyed!")
                --else
                    --print("Not in game, all good ✅")
                end
                self.Events.MyBeastHammerRemoved(self)

            end,
            MyBeastHammerRemoved = function(self)
                task.wait(1)
                for num, animTrack in ipairs(C.human:GetPlayingAnimationTracks()) do
                    if animTrack.Name == "AnimArmIdle" then
                        animTrack:Stop(0)
                    end
                end
            end,
            CharAdded = function(self, theirPlr, theirChar)
                local function ChildAdded(basePart)
                    if basePart:IsA("BasePart") then
                        if basePart.Name == "Part" then
                            local Rope = basePart:WaitForChild("RopeConstraint",1/3)
                            if Rope then
                                Rope.Enabled = false
                            end
                        end
                    end
                end
                table.insert(self.Functs, theirChar.ChildAdded:Connect(ChildAdded))
                for num, basePart in ipairs(theirChar:GetChildren()) do
                    ChildAdded(basePart)
                end
            end
        }
    },

    }
    return SharedHacks
end

local function SetUpGame(C, Settings)
    C.GameTimer = RS:WaitForChild("GameTimer")
    C.GameStatus = RS:WaitForChild("GameStatus")
    function C.CanTarget(self, target)
        if self.EnTbl.Me and target == C.plr then
            return true
        elseif self.EnTbl.Others and target ~= C.plr then
            return true
        else
            return false
        end
    end
    local function CleanUpMap()
        C.FreezingPods = {}
        C.Computers = {}
        C.NormalDoors = {}
        C.ExitDoors = {}
        C.Map = nil
    end
    CleanUpMap()
    table.insert(C.EventFunctions,function()
        local CurrentMap = RS:WaitForChild("CurrentMap")
		local function MapAdded(newMap)
            if not newMap then
                CurrentMap.Value = workspace
                return
            end
            while (newMap ~= workspace and newMap == CurrentMap.Value and C.GameStatus.Value:lower():find("loading")) do
                C.GameStatus:GetPropertyChangedSignal("Value"):Wait()
            end
            if newMap ~= CurrentMap.Value then
                return
            end
            if newMap == workspace then
                C.FireEvent("MapRemoved",nil,C.Map)
                CleanUpMap()
                return
            end
            -- ADD FREEZING PODS, COMPUTERS --
            local function newChild(item)
                task.wait()
                if item.Name:sub(1,9) == "FreezePod" then
                    table.insert(C.FreezingPods, item)
                    C.FireEvent("NewFreezingPod", nil, item)
                elseif item.Name:sub(1,13) == "ComputerTable" then
                    table.insert(C.Computers, item)
                elseif item.Name=="SingleDoor" or item.Name=="DoubleDoor" then
                    table.insert(C.NormalDoors, item)
                elseif item.Name=="ExitDoor" then
                    table.insert(C.ExitDoors, item)
                end
            end
            C.AddObjectConnection(newMap, "MapAddedChild", newMap.ChildAdded:Connect(newChild))
            for _, item in ipairs(newMap:GetChildren()) do
                task.spawn(newChild,item)
            end
            C.Map = newMap
            C.FireEvent("MapAdded",nil,C.Map)
            C.AddObjectConnection(newMap, "MapDestroyed", newMap.AncestryChanged:Connect(function()
                if newMap == CurrentMap.Value then -- Check to see if still valid
                    CurrentMap.Value = workspace -- If not, reset the map value to refresh!
                end
            end))
        end
        C.AddGlobalConnection(CurrentMap.Changed:Connect(MapAdded))
        C.AddGlobalThread(task.spawn(MapAdded, CurrentMap.Value))
        local gameActiveVal = RS:WaitForChild("IsGameActive")
        local function gameActiveValChanged(newVal)
            C.GameActive = newVal
            C.FireEvent(newVal and "GameAdded" or "GameRemoved", nil)
        end
        C.AddGlobalConnection(gameActiveVal.Changed:Connect(gameActiveValChanged))
        if gameActiveVal.Value then
            gameActiveValChanged(gameActiveVal.Value)
        end
    end)
    table.insert(C.CharacterAddedEventFuncts, function(theirPlr, theirChar, theirHuman)
        local function childAdded(inst)
            if inst and inst.Name == "Hammer" then
                local Handle = inst:WaitForChild("Handle",100)
                local HammerEvent = inst:WaitForChild("HammerEvent", 100)
                if not Handle or not HammerEvent then
                    return
                end
                C.Hammer, C.Handle, C.HammerEvent, C.BeastPlr, C.BeastChar = inst, Handle, HammerEvent, theirPlr, theirPlr.Character
                C.FireEvent("BeastHammerAdded",theirPlr == C.plr,theirPlr,theirChar,theirHuman)
                C.AddObjectConnection(Handle, "BeastHammerRemoved", Handle.AncestryChanged:Connect(function()
                    if not workspace:IsAncestorOf(Handle.Parent) then
                        C.Hammer, C.Handle, C.BeastPlr, C.BeastChar, C.CarriedTorso = nil, nil, nil, nil, nil
                        C.FireEvent("BeastHammerRemoved",theirPlr == C.plr,theirPlr,theirChar,theirHuman)
                    end
                end))
                local CarriedTorso = theirChar:WaitForChild("CarriedTorso",20)
                if not CarriedTorso then return end
                C.CarriedTorso = CarriedTorso
                local LastCarried
                local function RopeUpd(newVal)
                    if newVal then
                        C.FireEvent("BeastRopeAdded",theirPlr == C.plr, newVal and newVal.Parent or nil)
                    else
                        C.FireEvent("BeastRopeRemoved",theirPlr == C.plr, LastCarried)
                    end
                    LastCarried = newVal and newVal.Parent or nil
                end
                C.AddObjectConnection(CarriedTorso, "BeastRope", CarriedTorso.Changed:Connect(RopeUpd))
                if CarriedTorso.Value then
                    RopeUpd(CarriedTorso.Value)
                end
            end
        end

        C.AddObjectConnection(theirChar, "BeastHammerAdded", theirChar.ChildAdded:Connect(childAdded))
        childAdded(theirChar:FindFirstChild("Hammer"))
    end)
    table.insert(C.PlayerAddedEventFuncts, function(theirPlr, wasAlreadyIn)
        local theTSM = theirPlr:WaitForChild("TempPlayerStatsModule")
        local isMe = theirPlr == C.plr

        local isBeastVal = theTSM:WaitForChild("IsBeast")
        local hpVal = theTSM:WaitForChild("Health")
        local escapedVal = theTSM:WaitForChild("Escaped")
        local ragdollVal = theTSM:WaitForChild("Ragdoll")
        local capturedVal = theTSM:WaitForChild("Captured")
        local function beastChangedVal(newVal)
            C.FireEvent(newVal and "BeastAdded" or "BeastRemoved",theirPlr == C.plr,theirPlr)
        end
        C.AddPlayerConnection(theirPlr,isBeastVal.Changed:Connect(beastChangedVal))
        if isBeastVal.Value then
            beastChangedVal(isBeastVal.Value)
        end
        local wasInGame = false
        local function healthChangedVal(newVal)
            local inGame = newVal > 0 and not escapedVal.Value
            if not wasInGame and inGame then
                C.FireEvent("SurvivorAdded",theirPlr == C.plr,theirPlr)
            elseif wasInGame and not inGame then
                C.FireEvent("SurvivorRemoved",theirPlr == C.plr,theirPlr)
            end
            wasInGame = inGame
        end
        C.AddPlayerConnection(theirPlr, hpVal.Changed:Connect(healthChangedVal))
        local function ragdollChangedVal(newVal)
            C.FireEvent(newVal and "RagdollAdded" or "RagdollRemoved", theirPlr == C.plr, theirPlr, theirPlr.Character)
        end
        C.AddPlayerConnection(theirPlr, ragdollVal.Changed:Connect(ragdollChangedVal))
        if ragdollVal.Value then
            ragdollChangedVal(ragdollVal.Value)
        end
        local function capturedChangedVal(newVal)
            C.FireEvent(newVal and "CapturedAdded" or "CapturedRemoved", theirPlr == C.plr, theirPlr, theirPlr.Character)
        end
        C.AddPlayerConnection(theirPlr, capturedVal.Changed:Connect(capturedChangedVal))
        if capturedVal.Value then
            ragdollChangedVal(capturedVal.Value)
        end
    end)




    function C.HitSurvivor(theirChar)
        if not theirChar.PrimaryPart then
            print('Hit stopped because {theirChar.Name} does not have a primary part!')
            return
        end
        local Dist=(C.Handle.Position-theirChar.PrimaryPart.Position).magnitude
        if Dist<18 then
            local closestPart, closestDist = nil, 14 -- Test Success: Hit Part Must Be < 8 Studs of Hammer
            for num, part in ipairs(theirChar:GetChildren()) do
                if part:IsA("BasePart") then
                    local testDist = (part.Position-C.Handle.Position).Magnitude
                    if testDist < closestDist then
                        closestPart, closestDist = part, testDist
                    end
                end
            end
            if closestPart then
                C.SetActionLabel(BotActionClone, `Hitting {theirChar.Name}`)
                C.HammerEvent:FireServer("HammerHit", closestPart)
                return true
            end
        end
    end
    function C.RopeSurvivor(theirChar)
        local Torso = theirChar:FindFirstChild("Torso")
        if C.CarriedTorso.Value and Torso then
            return
        end
        C.SetActionLabel(BotActionClone, `Roping {theirChar.Name}`)
        C.HammerEvent:FireServer("HammerTieUp",Torso,Torso.NeckAttachment.WorldPosition)
    end
    function C.RemoveRope()
        if not C.Hammer or not C.CarriedTorso then
            return
        end
        for s = 15, 1, -1 do
            if not C.CarriedTorso.Value then
                return
            end
            C.HammerEvent:FireServer("HammerClick", true)
            task.wait(.05)
        end
        warn(`[C.RemoveRope]: Failed to remove rope {C.CarriedTorso.Value} after 15 tries!`)
    end
    function C.CaptureSurvivor(theirChar)
        if C.BeastPlr ~= C.plr or C.BeastChar.CarriedTorso.Value==nil then
            return
        end
        C.SetActionLabel(BotActionClone, `Capturing {theirChar.Name}`)
        local function isCapsuleOpen(cap)
            return cap:FindFirstChild("PodTrigger") and cap.PodTrigger:FindFirstChild("CapturedTorso") and not cap.PodTrigger.CapturedTorso.Value
        end
        local capsule,closestDist=nil,math.huge
        for _, cap in ipairs(C.FreezingPods) do
            if isCapsuleOpen(cap) then
                local dist=(cap:GetPivot().Position-theirChar.PrimaryPart.Position).Magnitude
                if (dist<closestDist) then
                    capsule,closestDist=cap,dist
                end
            end
        end
        if not capsule then
            warn("[C.CaptureSurvivor]: Capsule Not Found For",theirChar,#C.FreezingPods,"Found!")
            return false, "Capsule Not Found"
        end
        C.LastCaptureTime = os.clock()
        task.wait(1/3)
        local Trigger = capsule:WaitForChild("PodTrigger",5)
        local ActionSign = Trigger and Trigger:FindFirstChild("ActionSign")
        for s=1,3,1 do
            local isOpened = ActionSign and (ActionSign.Value==11)
            if not Trigger or not ActionSign or not Trigger:FindFirstChild("CapturedTorso") then
                return
            elseif (Trigger and Trigger.CapturedTorso.Value~=nil) then
                break --we got ourselves a trapped survivor!
            elseif s~=1 then
                task.wait(.15)
            end
            if Trigger:FindFirstChild("Event") then
                C.RemoteEvent:FireServer("Input", "Trigger", true, Trigger.Event)
                C.RemoteEvent:FireServer("Input", "Action", true)
                if isOpened then
                    C.RemoteEvent:FireServer("Input", "Trigger", false)
                end
            end
        end
    end
    function C.RescueSurvivor(capsule)
        if not capsule or not capsule:FindFirstChild("PodTrigger")
					or not capsule.PodTrigger.CapturedTorso.Value then return end
        if C.char:FindFirstChild("Hammer")~=nil or C.myTSM.Health.Value <= 0 then return end
        local Trigger=capsule:FindFirstChild("PodTrigger")
        if not Trigger then return end
        C.SetActionLabel(BotActionClone, `Rescuing {capsule.PodTrigger.CapturedTorso.Value.Parent.Name}`)
        for s=5,1,-1 do
            if not workspace:IsAncestorOf(Trigger) then
                break
            elseif Trigger.CapturedTorso.Value==nil then
                return true
            end
            local isOpened=Trigger.ActionSign.Value==11
            C.RemoteEvent:FireServer("Input", "Trigger", true, Trigger.Event)
            C.RemoteEvent:FireServer("Input", "Action", true)
            if isOpened then
                C.RemoteEvent:FireServer("Input", "Trigger", false)
            end
            task.wait(.075)
            C.RemoteEvent:FireServer("Input", "Action", false)
            task.wait(.075)
        end
    end
    function C.WaitForHammer()
        while not C.Hammer or not C.CarriedTorso do
            task.wait(1)
        end
    end
end

return function(C,Settings)
    C.RemoteEvent = RS:WaitForChild("RemoteEvent")
    local LobbyOBWall
    if game.PlaceId == 893973440 then
        LobbyOBWall = workspace:WaitForChild("LobbyOBWall")
        SetUpGame(C,Settings)
    end
    function C.SelectPlayerType(meDefault, otherDefault)
        return {
            {
                Type = Types.Toggle,
                Title = "Me",
                Tooltip = "Whether or not this hack will target you",
                Layout = -10,Default=meDefault,
                Shortcut="Me",
                Activate = C.ReloadHack,
            },
            {
                Type = Types.Toggle,
                Title = "Others",
                Tooltip = "Whether or not this hack will target you",
                Layout = -9,Default=otherDefault,
                Shortcut="Others",
                Activate = C.ReloadHack,
            },
        }
    end
    C.myTSM = C.plr:WaitForChild("TempPlayerStatsModule")
    C.mySSM = C.plr:WaitForChild("SavedPlayerStatsModule")

    function C.GetPlayerListOfType(options)
        local list = {}
        for _, theirPlr in ipairs(PS:GetPlayers()) do
            if theirPlr == C.plr and options.ExcludeMe then
                continue
            end
            local theirTSM = theirPlr:FindFirstChild("TempPlayerStatsModule")
            if not theirTSM then
                --print("[C.GetPlayerListOfType]: No TSM Found",theirPlr)
                continue
            end
            local inGame, role = C.isInGame(theirPlr.Character)
            if (options.InGame == nil or inGame == options.InGame) and (options[role] == nil or options[role])
                and (options.Ragdoll == nil or options.Ragdoll == theirTSM.Ragdoll.Value)
                and (options.Captured == nil or options.Captured == theirTSM.Captured.Value) then
                table.insert(list, theirPlr)
            end
        end
        return list
    end
    local SharedHacks = GetSharedHacks(C, Settings)
    local function SendWaitRemoteEvent(retType, ...)
        local bindableEvent = Instance.new("BindableEvent")
        local rets
        local isWaiting = true
        local conn
        task.delay(4, function()
            if not isWaiting then
                return
            end
            isWaiting = false
            bindableEvent:Fire()
        end)
        conn = C.RemoteEvent.OnClientEvent:Connect(function(type,...)
            if type == retType then
                rets = {type,...}
                isWaiting = false
                bindableEvent:Fire()
            end
        end)
        C.RemoteEvent:FireServer(...)
        while isWaiting do
            bindableEvent.Event:Wait()
        end
        bindableEvent:Destroy()
        conn:Disconnect()
        if rets then
            return true, table.unpack(rets)
        else
            warn("Timeout occured for yield signal",retType,...)
            return false, "Timeout Occured"
        end
    end
    local SetsRarityValue = {
        [0] = 750, -- Unknown Rarity (Bundle)
        [1] = 100, -- Common Rarity (Crate)
        [2] = 200, -- Uncommon Rarity (Crate)
        [3] = 400, -- Rare Rarity (Crate)
        [4] = 700, -- Legendary Rarity (Crate)
    }
    function C.GetCreditsValue(sets)
        local value = 0
        for setName, qty in pairs(sets) do
            local ItemHammer = C.StringWait(RS,`ItemDatabase.{setName}`)
            local Rarity = ItemHammer:GetAttribute("Rarity")
            value += qty * (SetsRarityValue[Rarity] or -9999999999)
        end
        return value
    end
    function C.GetUserInventory(theirPlr)
        theirPlr = theirPlr or C.plr
        local RequestName = theirPlr == C.plr and "GetPlayerInventory" or "GetOtherPlayerInventory"

        if RequestName == "GetOtherPlayerInventory" and game.PlaceId == 893973440 then -- Cannot view inventory in main game!!
            return {}
        end

        local Success, Res, Inventory
        repeat
            Success, Res, Inventory = SendWaitRemoteEvent(RequestName, RequestName, RequestName=="GetOtherPlayerInventory" and theirPlr.UserId or nil)
            if not Success and not theirPlr.Parent then
                return {}
            end
        until Success
        local InventoryCount = {}

        for _, item in ipairs(Inventory) do
            InventoryCount[item] = (InventoryCount[item] or 0) + 1
        end
        InventoryCount["H0001"], InventoryCount["G0001"] = nil, nil
        return InventoryCount, #Inventory
    end
    local LevelingXpCurve
    function C.GetTotalXP(theirPlr)
        local theirSSM = theirPlr:WaitForChild("SavedPlayerStatsModule")
        LevelingXpCurve = LevelingXpCurve or C.require(RS:WaitForChild("LevelingXpCurve"))
        local TotXP = theirSSM.Xp.Value
        for s = 1, theirSSM.Level.Value, 1 do
            TotXP += LevelingXpCurve[s] or 4000
        end
        return TotXP
    end
    function C.GetSetsCount(Sets)
        local setsTotal = 0
        for key, qty in pairs(Sets) do
            if key:sub(1,1) == "H" then -- for hammers only
                setsTotal += math.min(qty, Sets["G" .. key:sub(2)] or 0)
            end
        end
        return setsTotal
    end
    function C.GetUserStats(theirPlr)
        local Results = {
            Assets = 0,
            Credits = 0,
            NetWorth = 0,
            XP = 0,
            Level = 0,
        }
        local theirSSM = theirPlr:WaitForChild("SavedPlayerStatsModule")
        if theirSSM then
            local UserInventory = C.GetUserInventory(theirPlr)
            Results.Assets = C.GetCreditsValue(UserInventory)
            Results.Sets = C.GetSetsCount(UserInventory)
            Results.Credits = theirSSM.Credits.Value
            Results.NetWorth = Results.Assets + Results.Credits
            Results.XP = C.GetTotalXP(theirPlr)
            Results.Level = theirSSM.Level.Value
        end
        return Results
    end
    -- COMMANDS --
    table.insert(C.InsertCommandFunctions,function()
        return {
            ["addwhitelist"] = {
                Parameters={{Type="Player", ExcludeMe = true}},
                Alias = {},
                AfterTxt = "",
                Priority = -1000,
                Run = function(self, args)
                    local list = C.hackData.FleeTheFacility.InstaTrade.whitelistedUsers
                    if not C.TblAdd(list, args[1][1].Name:lower()) then
                        return false, `{args[1][1].Name} is already in the list`
                    end
                    return true
                end,
            },
            ["removewhitelist"] = {
                Parameters={{Type="Player", ExcludeMe = true}},
                Alias = {},
                AfterTxt = "",
                Priority = -1000,
                Run = function(self, args)
                    local list = C.hackData.FleeTheFacility.InstaTrade.whitelistedUsers
                    if not C.TblRemove(list, args[1][1].Name) then
                       return false, `{args[1][1].Name} is not whitelisted!`
                    end
                    return true
                end,
            },
            ["findtrader"] = {
                Parameters={{Type="User"}},
                Alias = {},
                AfterTxt = " %s in %.1fs",
                Priority = -7,
                Run = function(self,args)
                    local SearchUser = args[1][1]:lower()
                    local TimeStart = os.clock()
                    local TradeLocalScript = C.PlayerGui:FindFirstChild("TradePostMenuLocalScript", true)
                    if TradeLocalScript then
                        TradeLocalScript.Enabled = false
                    end

                    local result, signal, dict = SendWaitRemoteEvent("ReceiveTradingPostPlayersList", "RequestTradingPostPlayersList")
                    if not result then
                        return true, `Failed Getting From Server: {signal}`, os.clock() - TimeStart
                    end
                    if SearchUser:lower() == "random" then
                        local namesList = C.GetRandomDict(dict).Val.namesList
                        SearchUser = namesList[C.Randomizer:NextInteger(1,#namesList)]
                    end
                    local found, count = false, 0
                    for gameID, data in pairs(dict) do
                        count+=1
                        for key, val in ipairs(data.namesList) do
                            if val:lower() == SearchUser then
                                found = true
                                break
                            end
                        end
                        if found then
                            task.spawn(function()
                                if C.Prompt(`Join {SearchUser} In Trading? ({#data.namesList} Players)`, table.concat(data.namesList,"\t"), "Y/N") == true then
                                    C.ServerTeleport(1738581510,gameID)
                                end
                            end)
                            found = gameID
                            break
                        end
                    end
                    if TradeLocalScript and TradeLocalScript.Parent then
                        TradeLocalScript.Enabled = true
                    end
                    return true, found and `In {found}` or `Not Found`, os.clock() - TimeStart
                end,
            },
            ["stats"] = {
                Parameters={{Type="Players"}},
                Alias = {},
                AfterTxt = " Results in %.1fs:\n%s",
                Priority = -7,
                Run = function(self, args)
                    local clockStart = os.clock()
                    local displayTxt = ``
                    for num, theirPlr in ipairs(C.sortPlayersByXPThenCredits(args[1])) do
                        if num ~= 1 then
                            task.wait(1/20)
                        end
                        local Stats = C.GetUserStats(theirPlr)
                        displayTxt = displayTxt .. `({Stats.Level}) {theirPlr.Name}:\n`
                        Stats.Level = nil
                        for key, val in pairs(Stats) do
                            displayTxt = displayTxt .. `\t{key}: {C.FormatLargeNumber(val)}\n`
                        end
                    end
                    return true, os.clock() - clockStart, displayTxt
                end,
            }
        }
    end)
    -- MAIN GAME --
    if game.PlaceId ~= 1738581510 then
        do
            --local BeastCaveBaseplate = workspace:WaitForChild("BeastCaveBaseplate")
            function C.isInGame(theirChar,isDefacto)
                local theirPlr = theirChar and PS:GetPlayerFromCharacter(theirChar)
                if not theirChar or not theirPlr then
                    return false, "Lobby"
                end
                local theirTSM = theirPlr:WaitForChild("TempPlayerStatsModule")
                if theirChar:FindFirstChild("Hammer") or theirTSM.IsBeast.Value then
                    return true, "Beast"
                elseif theirTSM.Health.Value > 0 then
                    return true, "Survivor"
                elseif isDefacto then
                    local Location = theirChar:GetPivot().Position
                    if C.IsInBox(LobbyOBWall.CFrame, LobbyOBWall.Size, Location, true) then
                        return false, "Lobby"
                    else
                        return true, "Survivor"
                    end
                else
                    return false, "Lobby"
                end
            end
        end
        return {
            Category = {
                Name = "FleeTheFacility",
                Title = "Flee The Facility",
                Image = nil, -- Set to nil for game image
                Layout = 20,
            },
            Tab = AppendToFirstArr(SharedHacks, AppendToFirstArr({
                {
                    Title = "Auto Hit",
                    Tooltip = "Automatically ropes nearby survivors",
                    Layout = 1,
                    Shortcut = "AutoHit",Threads={},
                    Events = {
                        GameAdded = function(self)
                            while true do
                                C.WaitForHammer()
                                for _, theirPlr in ipairs(C.GetPlayerListOfType({Survivor=true,Lobby=false,Beast=false})) do
                                    if C.CanTarget(self, C.BeastPlr) and theirPlr.Character then
                                        C.HitSurvivor(theirPlr.Character)
                                    end
                                end
                                task.wait(1/2)
                            end
                        end,
                        RagdollRemoved = function(self, theirChar)
                            local theirPlr = PS:GetPlayerFromCharacter(theirChar)
                            if theirPlr and C.CanTarget(self, C.BeastPlr) and theirPlr.Character then
                                C.HitSurvivor(theirPlr.Character)
                            end
                        end,
                    },
                    Options = AppendToFirstArr({

                        },
                        C.SelectPlayerType(true, false)
                    )
                },
                {
                    Title = "Auto Rope",
                    Tooltip = "Automatically ropes nearby survivors",
                    Layout = 1,
                    Shortcut = "AutoRope",
                    Events = {
                        RagdollAdded = function(self, theirPlr, theirChar)
                            C.WaitForHammer()
                            if C.CanTarget(self, C.BeastPlr) then
                                C.RopeSurvivor(theirChar)
                            end
                        end,
                        BeastRopeRemoved = function(self)
                            if not C.CanTarget(self, C.BeastPlr) then
                                return
                            end
                            if not C.LastCaptureTime or (os.clock() - C.LastCaptureTime) < 1 then
                                for _, theirPlr in ipairs(C.GetPlayerListOfType({Ragdoll=true})) do
                                    self.Events.RagdollAdded(self, theirPlr, theirPlr.Character)
                                end
                            end
                        end,
                    },
                    Options = AppendToFirstArr({

                        },
                        C.SelectPlayerType(true, false)
                    )
                },
                {
                    Title = "Auto No Rope",
                    Tooltip = "Automatically removes rope after a delay",
                    Layout = 4,
                    Shortcut = "AutoRemoveRope",
                    Events = {
                        BeastRopeAdded = function(self, theirChar)
                            if C.CanTarget(self, C.BeastPlr) then
                                C.RemoveRope()
                            end
                        end,
                    },
                    Options = AppendToFirstArr({

                        },
                        C.SelectPlayerType(false, true)
                    )
                },
                {
                    Title = "🔨Auto Capture",
                    Tooltip = "Capture survivors when roped (BEAST ONLY)",
                    Layout = 3,
                    Shortcut = "AutoCapture",Functs={},
                    Activate = function(self, newValue, firstRun)
                        if firstRun or not newValue then
                            return
                        end
                        if C.CarriedTorso and C.BeastPlr == C.plr and C.CarriedTorso.Value then
                            self.Events.MyBeastRopeAdded(self, C.CarriedTorso.Value.Parent)
                        end
                    end,
                    Events = {
                        MyBeastRopeAdded = function(self,theirChar)
                            C.CaptureSurvivor(theirChar)
                        end,
                    },
                },
                {
                    Title = "⛹️Auto Rescue",
                    Tooltip = "Capture survivors when roped (SURVIVOR ONLY)",
                    Layout = 4,
                    Shortcut = "AutoRescue",Functs={},Threads = {},
                    Activate = function(self, newValue, firstRun)
                        if not newValue or firstRun then
                            return
                        end
                        --print("Activated with",#C.FreezingPods,"Pods!")
                        for _, freezePod in ipairs(C.FreezingPods) do
                            table.insert(self.Threads,task.spawn(self.Events.NewFreezingPod, self, freezePod))
                        end
                    end,
                    Events = {
                        NewFreezingPod = function(self, freezePod)
                            local PodTrigger = freezePod and freezePod:WaitForChild("PodTrigger",100)
                            local CapturedTorso = PodTrigger and PodTrigger:WaitForChild("CapturedTorso",300)
                            if CapturedTorso then
                                table.insert(self.Functs, CapturedTorso.Changed:Connect(function()
                                    C.RescueSurvivor(freezePod)
                                end) or false)
                                if CapturedTorso.Value then
                                    table.insert(self.Threads, task.spawn(C.RescueSurvivor,freezePod))
                                end
                            end
                        end,
                    }
                },
                {
                    Title = "Slow Beast",
                    Tooltip = "Permanently slows the beast",
                    Layout = 5,
                    Shortcut = "SlowBeast",
                    Threads = {},
                    Events = {
                        BeastAdded = function(self)
                            if not C.CanTarget(self, C.BeastPlr) then
                                return
                            end
                            local BeastEvent = C.StringWait(C.BeastChar, "BeastPowers.PowersEvent", 5)
                            while BeastEvent do
                                BeastEvent:FireServer("Jumped");
                                RunS.RenderStepped:Wait()
                            end
                        end,
                    },
                    Options = AppendToFirstArr({

                        },
                        C.SelectPlayerType(false, true)
                    )
                },
                {
                    Title = "🔨Crawl",
                    Tooltip = "Always allow the beast to crawl, and go through vents!",
                    Layout = 6,
                    Shortcut = "BeastCrawl",
                    Activate = function(self, newValue)
                        local OldIndex
                        OldIndex = C.HookMethod("__index",self.Shortcut,newValue and function(theirScript,index,self,...)
                            if OldIndex(self, "Name") == "DisableCrawl" then
                                return "Spoof", {false}
                            end
                        end,{"value"})
                        C.firesignal(C.myTSM.DisableCrawl.Changed)
                    end,
                    Threads = {},
                    Events = {
                        MyBeastHammerAdded = function(self)
                            for num, ventPart in ipairs(C.Map:GetDescendants()) do
                                if ventPart.Name == "VentBlock" or ventPart.Name == "VentBlocks" then
                                    ventPart:Destroy()
                                end
                            end
                        end,
                    }
                },
                {
                    Title = "Utility",
                    Tooltip = "Automatically does actions, such as rescuing a survivor or hacking a PC",
                    Layout = 9,
                    Threads = {}, Functs = {},
                    Default = true,
                    Shortcut = "FTFUtility",
                    MinigameActivate = function(self)
                        local minigameResultVal = C.myTSM:WaitForChild("MinigameResult")
                        local function updateMiniGameResult()
                            if not minigameResultVal.Value then
                                C.RemoteEvent:FireServer("SetPlayerMinigameResult", true)
                            end
                        end
                        table.insert(self.Functs,minigameResultVal.Changed:Connect(updateMiniGameResult))
                        updateMiniGameResult()
                        while true do
                            while not C.plr.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("TimingCircle").Visible do
                                C.plr.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("TimingCircle"):GetPropertyChangedSignal("Visible"):Wait()
                            end
                            while C.plr.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("TimingCircle").Visible do
                                if C.PlayerGui.ScreenGui.TimingCircle.TimingPin.Rotation>=C.PlayerGui.ScreenGui.TimingCircle.TimingBase.Rotation+45 then
                                    C.myTSM.ActionInput.Value=true
                                end
                                RunS.PreRender:Wait()
                                --C.PlayerGui.ScreenGui.TimingCircle.TimingPin:GetPropertyChangedSignal("Rotation"):Wait()
                            end
                            C.myTSM.ActionInput.Value=false
                        end
                    end,
                    Activate = function(self, newValue, firstRun)
                        if not newValue then
                            return
                        end
                        if self.EnTbl.Minigame then
                            table.insert(self.Threads, task.spawn(self.MinigameActivate, self))
                        end
                    end,
                    Events = {},
                    Options = {
                        {
                            Type = Types.Toggle,
                            Title = "Minigame",
                            Tooltip = "Whether or not minigame is enabled for hacking computers",
                            Layout = 1,Default=true,
                            Shortcut="Minigame",
                            Activate = C.ReloadHack
                        },
                    },
                },
                {
                    Title = "Spectate",
                    Tooltip = "Always allows spectate, even while in game or in lobby",
                    Layout = 10,
                    Shortcut = "Spectate",
                    Activate = function(self, newValue)
                        local toStr = tostring
                        local myTSM = C.myTSM
                        local isAncestorOf = myTSM.IsAncestorOf
                        local traceback = debug.traceback
                        local find = string.find

                        local lobbyPlrs = self.EnTbl.LobbyPlayers
                        local OldIndex
                        OldIndex = C.HookMethod("__index",self.Shortcut,newValue and function(theirScript,index,self,...)
                            if (toStr(theirScript) == "LocalGuiScript") then
                                local isMe = isAncestorOf(myTSM, self)
                                local traceback = traceback()
                                for _, val in ipairs({704, 712, 726, 712, 735, 739}) do
                                    if find(traceback,toStr(val)) then
                                        local theValue = toStr(self)
                                        if theValue == "Health" then
                                            local spoofHP = (isMe and 0) or ((lobbyPlrs or not rawget(C, "GameActive")) and 100)
                                            if spoofHP then
                                                return "Spoof", {spoofHP}
                                            end
                                        elseif theValue == "IsBeast" and isMe then
                                            return "Spoof", {false}
                                        end
                                    end
                                end
                            end
                        end,{"value"})

                        local DefaultLighting = RS:WaitForChild("DefaultLightingSettings")
                        --for num, funct in ipairs(C.GetFunctionsWithName({Name="ChangeLightingSettings"})) do
                        --    local Old
                        --    --local TargetLighting = DefaultLighting
                        --    Old = C.HookFunc(funct, self.Shortcut, function(lightInstance)
                        --        --if C.isInGame(C.Camera.CameraSubject and C.Camera.CameraSubject.Parent, true) then
                        --            --lightInstance = C.Map and C.Map:FindFirstChild("_LightingSettings")
                        --        --else
                        --            lightInstance = RS.DefaultLightingSettings
                        --        --end
                        --        return Old(lightInstance)
                        --    end)
                        --end
                        local OldNamecall
                        local FindChild = workspace.FindFirstChild
                        OldNamecall = C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,name,recursive)
                            if name == "_LightingSettings" or name == "DefaultLightingSettings" then
                                local subject = C.Camera.CameraSubject
                                if not subject then
                                    return
                                end
                                local isInGame = not C.IsInBox(LobbyOBWall.CFrame, LobbyOBWall.Size, subject.Parent:GetPivot().Position, true)
                                if isInGame then
                                    local Ret = C.Map and FindChild(C.Map, "_LightingSettings") or nil
                                    return "Spoof", {Ret}
                                else
                                    return "Spoof", {DefaultLighting}
                                end
                            end
                        end,{"findfirstchild"})
                    end,
                    Options = {
                        {
                            Type = Types.Toggle,
                            Title = "Lobby Players",
                            Tooltip = "Whether or not to spectate other lobby players WHEN A GAME IS IN PROGRESS",
                            Layout = 2,Default=false,
                            Shortcut="LobbyPlayers",
                            Activate = C.ReloadHack,
                        },
                    },
                    Events = {
                        MyCharAdded=function(self,theirPlr,theirChar,firstRun)
                            if firstRun then return end
                            C.DoActivate(self,self.Activate,self.RealEnabled)
                        end,
                    }
                },
            }, table.find(C.BotUsers, C.plr.Name:lower()) and {
                {
                    Title = "Server Farm",
                    Tooltip = "Verifies that the whole server is a bot, and if so, proceeds by grinding credits and xp for the whole server",
                    Layout = 100,
                    Shortcut = "ServerBot",Functs={}, Threads={}, Default=true,
                    WasRunning = false,
                    FreezeMyself = function(self,canRun,canCapture)
                        while C.BeastChar do
                            local i = 0
                            while ((C.BeastChar and C.BeastChar:FindFirstChild("HumanoidRootPart"))) do
                                i+=1
                                if i==10 then
                                    i = 0
                                elseif i>1 then
                                    RunS.RenderStepped:Wait()
                                end
                                if not canCapture or canCapture() then
                                    if not canRun(true) then
                                        return
                                    end
                                    local inRange = (C.BeastChar:GetPivot().Position-C.char:GetPivot().Position).Magnitude<6
                                    if not inRange then
                                        if not C.myTSM.Captured.Value and (not C.myTSM.Ragdoll.Value or (C.CarriedTorso
                                            and (C.CarriedTorso.Value and C.CarriedTorso.Value.Parent)~=C.char)) then
                                            C.DoTeleport(C.BeastChar:GetPivot()*Vector3.new(0,0,-4))
                                        end
                                    else
                                        if not C.myTSM.Ragdoll.Value and C.BeastChar and C.BeastChar.Parent and C.char:FindFirstChild("Head") then
                                            C.HammerEvent:FireServer("HammerHit", C.char.Head)
                                        end
                                        if not canRun(true) then
                                            return
                                        end
                                        if C.myTSM.Ragdoll.Value and C.BeastChar and C.BeastChar.Parent
                                            and (C.CarriedTorso.Value and C.CarriedTorso.Value.Parent)~=C.char then
                                            C.RopeSurvivor(C.char)
                                        end
                                    end
                                end
                            end
                            RunS.RenderStepped:Wait()
                        end
                    end,
                    HasVerification = function()
                        for num, theirPlr in ipairs(C.GetPlayerListOfType({Survivor = true,Beast=true,Lobby=false})) do
                            if not table.find(C.BotUsers, theirPlr.Name:lower()) then
                                return false
                            end
                        end
                        return true
                    end,
                    StartSurvivor = function(self, actionClone, info)
                        if self.EnTbl.RunType == "Capture" then
                            C.SetActionLabel(actionClone,"[Idle] Waiting To Get Captured")
                        elseif self.EnTbl.RunType == "Rescue" then
                            local function canRun(fullLoop)
                                local runnerPlrs = C.GetPlayerListOfType({Survivor = true,Beast=false,Lobby=false})
                                C.sortPlayersByXPThenCredits(runnerPlrs)
                                if #runnerPlrs == 0 then
                                    task.spawn(self.Completed, self, false)
                                    return false
                                end
                                self.SurvivorList = runnerPlrs
                                self.myKey = table.find(self.SurvivorList,C.plr)
                                self.rescueKey = (self.myKey%#self.SurvivorList) + 1

                                local Ret1 = (C.char and C.human and C.human.Health>0 and C.char:FindFirstChild("HumanoidRootPart") and C.Hammer)
                                local Ret2 = ((select(2,C.isInGame(C.char))=="Survivor") and not C.Cleared)
                                return (Ret1 and Ret2)
                            end
                            canRun()
                            --print("Runners",self.SurvivorList)
                            table.insert(self.Threads,task.spawn(function()
                                while canRun(true) and not C.plr:GetAttribute("HasRescued") do
                                    --local GuyToRescueIndex = (myKey%#self.SurvivorList)+1--gets next index and loops over array
                                    local myGuyToRescuePlr = self.SurvivorList[self.rescueKey]
                                    if myGuyToRescuePlr and myGuyToRescuePlr.TempPlayerStatsModule.Captured.Value then
                                        --print("My guy was captured!")
                                        local targetCapsule
                                        for _, capsule in ipairs(C.FreezingPods) do
                                            if capsule:FindFirstChild("PodTrigger")~=nil and capsule.Parent then
                                                local capturedTorso = capsule.PodTrigger.CapturedTorso.Value
                                                if capturedTorso and capturedTorso.Parent and capturedTorso:IsDescendantOf(myGuyToRescuePlr.Character) then
                                                    targetCapsule=capsule
                                                    break
                                                end
                                            end
                                        end
                                        if targetCapsule then
                                            local Freed = C.RescueSurvivor(targetCapsule)
                                            if Freed then
                                                C.plr:SetAttribute("HasRescued", true)
                                                break
                                            end
                                            --print("Found Pod, Freeing Status:",Freed)
                                        end
                                    end
                                    RunS.RenderStepped:Wait()
                                end
                                --print("FInished Rescue!")
                            end))
                            local function canCapture()
                                --task.wait(1.5)
                                local keyNeeded = 1
                                for key, theirPlr in ipairs(self.SurvivorList) do
                                    if not theirPlr:GetAttribute("HasCaptured") then
                                        keyNeeded = key
                                        break
                                    end
                                end
                                local Result = (self.myKey==keyNeeded and not C.plr:GetAttribute("HasCaptured")) or C.plr:GetAttribute("HasRescued") or #self.SurvivorList==1
                                --print("CanCapture Called2:", Result, "---",
                                    --myRunerPlrKey,keyNeeded,C.plr:GetAttribute("HasCaptured"),C.plr:GetAttribute("HasRescued"))
                                return Result
                            end
                            self:FreezeMyself(canRun,canCapture)
                        else
                            warn(`[Server Farm]: Unknown RunType: {self.EnTbl.RunType}`)
                        end
                    end,
                    StartBeast = function(self, actionClone, info)
                        if self.EnTbl.RunType == "Capture" then
                            while true do
                                local MyList = C.GetPlayerListOfType({Survivor = true, Captured = false, ExcludeMe = true})
                                for _, theirPlr in ipairs(MyList) do
                                    local TSM = theirPlr:FindFirstChild("TempPlayerStatsModule")
                                    if not TSM then
                                        return
                                    end
                                    local i = 0
                                    while theirPlr and theirPlr.Parent and not TSM.Captured.Value do
                                        if i%12 == 0 then
                                            C.CommandFunctions.teleport:Run({{theirPlr}})
                                        end
                                        RunS.RenderStepped:Wait()
                                        i+=1
                                    end
                                end
                                if #MyList == 0 then
                                    task.wait(1)
                                end
                            end
                        elseif self.EnTbl.RunType == "Rescue" then
                            C.SetActionLabel(actionClone,"[Idle]")
                        else
                            warn(`[C.StartBeast]: Unknown Implementation for StartBeast: {self.EnTbl.RunType}`)
                        end
                    end,--game:GetService("Players").ItsAGoodGameBros.PlayerGui.MenusScreenGui.TradePostMenuWindow.TradePostMenuLocalScript
                    DoOverrides = function(self, toggle, role)
                        --toggle = toggle and self.EnTbl.RunType == "Survivor"
                        C[role == "Beast" and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoHit,self.Shortcut)
                        C[role == "Beast" and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoRope,self.Shortcut)
                        C[role == "Beast" and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoCapture,self.Shortcut)
                        C[toggle and "AddOverride" or "RemoveOverride"](C.hackData.Blatant.Fly,self.Shortcut)
                        self.WasRunning = toggle
                    end,
                    --ResetThread = nil,
                    StartUp = function(self, gameOver)
                        C.RemoveAction(self.Shortcut)
                        C.getgenv().Rescued = nil
                        self.SurvivorList = nil
                        if gameOver or not C.BeastChar or not C.char or not C.isInGame(C.char) or not self.RealEnabled or not self:HasVerification() then
                            --print("Disabled: ",C.char,C.BeastChar,C.isInGame(C.char),self.RealEnabled)
                            return self:DoOverrides(false)-- No beast no hoes
                        end
                        local inGame, role = C.isInGame(C.char)
                        if inGame then
                            self:DoOverrides(true, role)
                            local myActionClone
                            myActionClone = C.AddAction({Title=`{self.EnTbl.RunType} ({role})`, Name = self.Shortcut, Threads = {}, Time = function(actionClone, info)
                                table.insert(info.Threads, task.delay(30, function()
                                    if myActionClone ~= BotActionClone or C.GetAction(info.Name) ~= info then
                                        return
                                    end
                                    C.CreateSysMessage(`[Flee.ServerFarm]: System Timeout For One Game Occured Of 30 Seconds; Resetting Activated!`)
                                    warn(`System Timeout For One Game Occured Of 30 Seconds; Resetting Activated!`)
                                    --C.ResetCharacter()
                                end))
                                self["Start"..role](self, actionClone, info)

                            end, Stop = function(byReq)
                                if BotActionClone == myActionClone then
                                    BotActionClone = nil
                                end
                                if byReq then
                                    --print("Disabled by request!")
                                    C.DoActivate(self, self.Activate, self.RealEnabled, false)
                                end
                            end})
                            BotActionClone = myActionClone
                        end
                    end,
                    Activate = function(self, newValue, firstRun)
                        --self.ResetThread = nil
                        self:StartUp()
                    end,
                    Completed = function(self)
                        -- Finished on its own --
                        --print(debug.traceback("GAME OVER"))
                        self:StartUp(true)
                        C.getgenv().Rescued = nil
                        self.SurvivorList = nil
                        --C.DoActivate(self, self.Activate, self.RealEnabled, false)
                        for _, theirPlr in ipairs(PS:GetPlayers()) do
                            theirPlr:SetAttribute("HasRescued",nil)
                            theirPlr:SetAttribute("HasCaptured",nil)
                            --theirPlr:SetAttribute("BeenRescued",nil)
                        end
                        --task.delay(2, C.DoTeleport, workspace.SpawnLocation:GetPivot())
                        --task.spawn(C.ResetCharacter)
                    end,
                    Events = {
                        BeastHammerAdded = function(self,theirPlr,theirChar,theirHuman)
                            self:StartUp()
                        end,
                        MySurvivorRemoved = function(self)
                            self:Completed()
                        end,
                        MyBeastHammerRemoved = function(self)
                            self:Completed()
                        end,
                        GameRemoved = function(self)
                            self:Completed()--C.ClearThreadTbl(self.Threads)
                        end,
                        MapRemoved = function(self)
                            self:Completed()
                        end,
                        CapturedAdded = function(self, theirPlr, theirChar)
                            theirPlr:SetAttribute("HasCaptured", true)
                        end,
                        CapturedRemoved = function(self, theirPlr, theirChar)
                            -- Attribute it to that player
                            if self.SurvivorList then
                                local theirKey = table.find(self.SurvivorList, theirPlr)
                                if not theirKey then
                                    --warn("Survivor",theirPlr,"has no associated survivor key??")
                                    return
                                end
                                local theirKeyPlusOne = ((theirKey-2)%#self.SurvivorList) + 1
                                self.SurvivorList[theirKeyPlusOne]:SetAttribute("HasRescued", true)
                                --theirPlr:SetAttribute("BeenRescued",true)
                                --print(self.SurvivorList[theirKeyPlusOne],"Rescued",theirPlr.Name,self.SurvivorList,theirKey,theirKeyPlusOne)
                            end
                        end,
                    },
                    Options = {
                        {
                            Type = Types.Dropdown,
                            Title = "Run Type",
                            Tooltip = "Which ServerFarm type to run",
                            Layout = 1, Default = "Rescue",
                            Shortcut="RunType",
                            Selections = {"Capture","Rescue"},
                            Activate = C.ReloadHack,
                        },
                    },
                }


            } or {}))
        }
    end

	return {
		Category = {
			Name = "FleeTheFacility",
			Title = "Flee The Facility",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab =
            AppendToFirstArr(SharedHacks,{
                {
                    Title = "Insta Trade",
                    Tooltip = "Automatically trades with \"trusted\" users!",
                    Layout = 1,
                    Shortcut = "InstaTrade",Functs={}, Threads={}, Instances = {},Default=false,
                    whitelistedUsers = {"queen_bestiesforlife","itsagoodgamebros","facilitystorage","z_baeby","yvettecarreno08","kitcat4681"},
                    lastSend = 0,
                    IsAllowed = function(self,theirPlr)
                        if theirPlr == C.plr then
                            return false
                        end
                        return table.find(self.whitelistedUsers,theirPlr.Name:lower()) or table.find(C.AdminUsers, theirPlr.Name:lower())
                    end,
                    GetItemListing = function(self, internalName)
                        for name, listings in pairs(self.SendTypeIdentifiers) do
                            if table.find(listings, internalName) then
                                return name
                            end
                        end
                        return "Unlisted"
                    end,
                    GetTradableItems = function(self, tradePlr)
                        local theirInventory = C.GetUserInventory(tradePlr)
                        local sendType = self.EnTbl.SendType

                        local myInventory = C.GetUserInventory()
                        for name, count in pairs(myInventory) do
                            local newCount = math.min(count - self.EnTbl.KeepAmount, 10 - (theirInventory[name] or 0))
                            if sendType ~= "Any" and sendType ~= self:GetItemListing(name) then
                                newCount = 0
                            end
                            myInventory[name] = newCount>0 and newCount or nil
                        end
                        print(tradePlr,#myInventory)
                        return myInventory
                    end,
                    Activate = function(self,newValue,firstRun)
                        if not newValue then
                            return
                        end
                        local ReceiveEvent=Instance.new("BindableEvent")
                        table.insert(self.Instances, ReceiveEvent)

                        local IsTrading = false
                        local tradePlr, lastTradePlr
                        local function RemoteEventReceivedFunction(main,sec,third)
                            if main=="StartTradeCoolDown" then
                                self.lastSend=os.clock()
                            end
                            if main=="RecieveTradeRequest" and not IsTrading then
                                tradePlr=PS:GetPlayerByUserId(sec)
                                lastTradePlr = tradePlr
                                if self:IsAllowed(tradePlr) then
                                    IsTrading = true
                                    C.RemoteEvent:FireServer("AcceptTradeRequest")
                                    print("Trade Accepted")
                                else
                                    C.RemoteEvent:FireServer("CancelTrade")
                                    print("Trade Denied:",tradePlr)
                                    IsTrading, tradePlr = false, nil
                                end
                            elseif main == "StartTrading" then
                                if not tradePlr then
                                    warn("StartTrading occured but unknown trading partner!")
                                    return
                                end
                                IsTrading = true
                                table.insert(self.Threads, task.spawn(function()
                                    local tradableItems = self:GetTradableItems(tradePlr)
                                    task.wait(1/2)
                                    if not self.EnTbl.ReceiveOnly then
                                        local ItemsToSend = 4
                                        local sendArr = {}
                                        for name, count in pairs(tradableItems) do
                                            while count > 0 do
                                                table.insert(sendArr,  name)
                                                count -=1
                                            end

                                            ItemsToSend -= 1
                                            if ItemsToSend == 0 then
                                                break
                                            end
                                        end
                                        C.RemoteEvent:FireServer("SendMyTradeOffer", sendArr)
                                    end
                                    task.wait(3)
                                    for s = 30, 1, -1 do
                                        if not IsTrading then
                                            return
                                        end
                                        C.RemoteEvent:FireServer("AcceptTradeOffer")
                                        task.wait(1/3)
                                    end
                                    print("Trade Timed Out!")
                                    C.RemoteEvent:FireServer("CancelTrade")
                                    IsTrading, tradePlr = false, nil
                                end))

                            elseif main == "TradeCancelled" then
                                print("Trade Cancelled!")
                                IsTrading, tradePlr = false, nil
                            elseif main == "TradeVerifying" then
                                print("Trade Successfully Complete!")
                                IsTrading = false
                                tradePlr = nil
                            end
                        end
                        table.insert(self.Functs,C.RemoteEvent.OnClientEvent:Connect(RemoteEventReceivedFunction))
                        C.RemoteEvent:FireServer("CancelTrade")
                        task.wait(2)
                        while self.EnTbl.AutoSend do
                            if IsTrading then
                                while IsTrading do
                                    task.wait(1)
                                end
                            end

                            for _, theirPlr in ipairs(PS:GetPlayers()) do
                                if self:IsAllowed(theirPlr) then
                                    local tradableItems = self:GetTradableItems(theirPlr)
                                    if (C.GetDictLength(tradableItems) > 0) then
                                        tradePlr = theirPlr
                                        break
                                    end
                                end
                            end
                            if not IsTrading and tradePlr then
                                if tradePlr then
                                    print("Sending Trade Request:",tradePlr)
                                    C.RemoteEvent:FireServer("SendTradeRequest", tradePlr.UserId)
                                elseif lastTradePlr then
                                    task.spawn(C.Prompt, `Trade Completed!`,`All necessary items were traded with {lastTradePlr.Name}`,`Ok`)
                                    lastTradePlr = nil
                                end
                                task.wait(3)
                            else
                                task.wait(1)
                            end
                        end

                    end,
                    Events = {},
                    Options = {
                        {
                            Type = Types.Slider,
                            Title = "Keep Amount",
                            Tooltip = "How many of each item to keep!",
                            Layout = 1,Default = 1,
                            Min = 0, Max=9, Digits=0,
                            Shortcut="KeepAmount",
                        },
                        {
                            Type = Types.Toggle,
                            Title = "Receive Only",
                            Tooltip = "Only allows receiving items, it will not trade any of your inventory",
                            Layout = 1,Default = false,
                            Shortcut="ReceiveOnly",
                        },
                        {
                            Type = Types.Toggle,
                            Title = "AutoSend",
                            Tooltip = "Enables auto sender so that it sends to the bot immediately!",
                            Layout = 2,Default = false,
                            Shortcut="AutoSend",
                            Activate = C.ReloadHack,
                        },
                        {
                            Type = Types.Dropdown,
                            Title = "Send Type",
                            Tooltip = "Specifies the type of items to send.",
                            Layout = 2,Default = false,
                            Shortcut="SendType",
                            Selections = {"Any", "Unlisted", "Halloween 2024"},
                            Activate = C.ReloadHack,
                        },
                    },
                    SendTypeIdentifiers={
                        ["Halloween 2024"] = {
                            [1] = "Ghal0075",
                            [2] = "Ghal0076",
                            [3] = "Ghal0077",
                            [4] = "Ghal0078",
                            [5] = "Ghal0079",
                            [6] = "Ghal0080",
                            [7] = "Ghal0081",
                            [8] = "Ghal0082",
                            [9] = "Ghal0083",
                            [10] = "Ghal0084",
                            [11] = "Hhal0075",
                            [12] = "Hhal0076",
                            [13] = "Hhal0077",
                            [14] = "Hhal0078",
                            [15] = "Hhal0079",
                            [16] = "Hhal0080",
                            [17] = "Hhal0081",
                            [18] = "Hhal0082",
                            [19] = "Hhal0083",
                            [20] = "Hhal0084",
                            [21] = "Ghal0091",
                            [22] = "Hhal0091",
                            [23] = "Ghal0087",
                            [24] = "Hhal0087",
                            [25] = "Ghal0086",
                            [26] = "Hhal0086",
                            [27] = "Ghal0093",
                            [28] = "Hhal0093",
                            [29] = "Ghal0094",
                            [30] = "Hhal0094",
                            [31] = "Ghal0089",
                            [32] = "Hhal0089",
                            [33] = "Ghal0090",
                            [34] = "Hhal0090",
                            [35] = "Ghal0092",
                            [36] = "Hhal0092",
                            [37] = "Ghal0088",
                            [38] = "Hhal0088",
                            [39] = "Ghal0085",
                            [40] = "Hhal0085",
                        },
                    },
                },
            }
        )
	}
end
