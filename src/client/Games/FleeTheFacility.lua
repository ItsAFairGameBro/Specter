local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local DS = game:GetService("Debris")
local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local GS = game:GetService("GuiService")
local PS = game:GetService("Players")
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
                Layout = 1,Default = 1,
                Min = 0, Max=10, Digits=0,
                Shortcut="EventCrateQty",
            },
            {
                Type = Types.Slider,
                Title = "Event Bundles",
                Tooltip = "How much of every event bundle to buy!",
                Layout = 2,Default = 1,
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
        Functs = {},
        Activate = function(self, newValue)
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
            end
        end,
        Events = {
            MyCharAdded = C.ReloadHack,
            MapRemoved = function(self)
                local Torso = C.char and C.char:FindFirstChild("Torso")
                if Torso then
                    warn("Torso Anchored, Resetting...")
                    C.ResetCharacter()
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
            while (newMap == CurrentMap.Value and C.GameStatus.Value:lower():find("loading")) do
                C.GameStatus:GetPropertyChangedSignal("Value"):Wait()
            end
            if newMap ~= CurrentMap.Value then
                return
            end
            if not newMap then
                C.FireEvent("MapRemoved",nil,C.Map)
                CleanUpMap()
                return
            end
            -- ADD FREEZING PODS, COMPUTERS --
            local function newChild(item)
                if item.Name:sub(1,9) == "FreezePod" then
                    table.insert(C.FreezingPods, item)
                    C.FireEvent("NewFreezingPod", item)
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
                newChild(item)
            end
            C.Map = newMap
            C.FireEvent("MapAdded",nil,C.Map)
        end
        C.AddGlobalConnection(CurrentMap.Changed:Connect(MapAdded))
        MapAdded(CurrentMap.Value)
        local gameActiveVal = RS:WaitForChild("IsGameActive")
        local function gameActiveValChanged(newVal)
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
                local function RopeUpd(newVal)
                    C.FireEvent(newVal and "BeastRopeAdded" or "BeastRopeRemoved",theirPlr == C.plr,newVal and newVal.Parent or nil)
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
            return
        end
        local Dist=(C.Handle.Position-theirChar.PrimaryPart.Position).magnitude
        if Dist<15 then
            local closestPart, closestDist = nil, 10 -- Test Success: Hit Part Must Be < 8 Studs of Hammer
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
    if game.PlaceId == 893973440 then
        SetUpGame(C,Settings)
    end
    C.SelectPlayerType = {
        {
            Type = Types.Toggle,
            Title = "Me",
            Tooltip = "Whether or not this hack will target you",
            Layout = -10,Default=true,
            Shortcut="Me",
            Activate = C.ReloadHack,
        },
        {
            Type = Types.Toggle,
            Title = "Others",
            Tooltip = "Whether or not this hack will target you",
            Layout = -9,Default=true,
            Shortcut="Others",
            Activate = C.ReloadHack,
        },
    }
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
            warn("Timeout occured for yield signal",retType)
            return false, "Timeout Occured"
        end
    end


    function C.GetUserInventory(theirPlr)
        local RequestName = theirPlr and "GetOtherPlayerInventory" or "GetPlayerInventory"

        local Success, Res, Inventory
        repeat
            Success, Res, Inventory = SendWaitRemoteEvent(RequestName, RequestName, theirPlr and theirPlr.UserId or nil)
        until Success
        local InventoryCount = {}

        for _, item in ipairs(Inventory) do
            InventoryCount[item] = (InventoryCount[item] or 0) + 1
        end
        InventoryCount["H0001"], InventoryCount["G0001"] = nil, nil
        return InventoryCount, #Inventory
    end
    -- COMMANDS --
    table.insert(C.InsertCommandFunctions,function()
        return {
            ["findtrader"] = {
                Parameters={{Type="User"}},
                Alias = {},
                AfterTxt = " %s in %.1fs",
                Run = function(self,args)
                    local SearchUser = args[1][1]:lower()
                    local TimeStart = os.clock()

                    local result, signal, dict = SendWaitRemoteEvent("ReceiveTradingPostPlayersList", "RequestTradingPostPlayersList")
                    if not result then
                        return true, `Failed Getting From Server: {signal}`, os.clock() - TimeStart
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
                        if count%8==0 then
                            task.wait(1/7)
                        end
                    end
                    return true, found and `In {found}` or `Not Found`, os.clock() - TimeStart
                end,
            }
        }
    end)
    -- MAIN GAME --
    if game.PlaceId ~= 1738581510 then
        do
            --local BeastCaveBaseplate = workspace:WaitForChild("BeastCaveBaseplate")
            local LobbyOBWall = workspace:WaitForChild("LobbyOBWall")
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
                                    if C.CanTarget(self, theirPlr) and theirPlr.Character then
                                        C.HitSurvivor(theirPlr.Character)
                                    end
                                end
                                task.wait(1/4)
                            end
                        end,
                        RagdollRemoved = function(self, theirChar)
                            local theirPlr = PS:GetPlayerFromCharacter(theirChar)
                            if theirPlr and C.CanTarget(self, theirPlr) and theirPlr.Character then
                                C.HitSurvivor(theirPlr.Character)
                            end
                        end,
                    },
                    Options = AppendToFirstArr({

                        },
                        C.SelectPlayerType,true
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
                            if not C.LastCaptureTime or (os.clock() - C.LastCaptureTime) > 2 then
                                for _, theirPlr in ipairs(C.GetPlayerListOfType({Ragdoll=true})) do
                                    self.Events.RagdollAdded(self, theirPlr, theirPlr.Character)
                                end
                            end
                        end,
                    },
                    Options = AppendToFirstArr({

                        },
                        C.SelectPlayerType,true
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
                    Activate = function(self, newValue)
                        if not newValue then
                            return
                        end
                        for _, freezePod in ipairs(C.FreezingPods) do
                            self.Events.NewFreezingPod(self, freezePod)
                        end
                    end,
                    Events = {
                        NewFreezingPod = function(self, freezePod)
                            local PodTrigger = freezePod:WaitForChild("PodTrigger",10)
                            local CapturedTorso = PodTrigger and PodTrigger:WaitForChild("CapturedTorso",30)
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
                    StartSurvivor = function(self, actionClone, info)
                        if self.EnTbl.RunType == "Capture" then
                            C.SetActionLabel(actionClone,"[Idle] Waiting To Get Captured")
                        elseif self.EnTbl.RunType == "Rescue" then
                            local runnerPlrs={}
                            local myRunerPlrKey
                            local function canRun(fullLoop)
                                runnerPlrs = C.GetPlayerListOfType({Survivor = true,Beast=false,Lobby=false})
                                self.SurvivorList = runnerPlrs
                                table.sort(runnerPlrs, function(a, b)
                                    local aLevel = C.StringWait(a, "SavedPlayerStatsModule.Level").Value
                                    local bLevel = C.StringWait(b, "SavedPlayerStatsModule.Level").Value
                                    return aLevel < bLevel
                                end)
                                myRunerPlrKey = table.find(runnerPlrs,C.plr)

                                if true then return true end

                                local Ret1 = (C.char and C.human and C.human.Health>0 and C.char:FindFirstChild("HumanoidRootPart") and C.Hammer)
                                local Ret2 = ((select(2,C.isInGame(C.char))=="Survivor") and not C.Cleared)
                                return (Ret1 and Ret2)
                            end
                            table.insert(self.Threads,task.spawn(function()
                                while canRun(true) and not C.plr:GetAttribute("HasRescued") do
                                    local GuyToRescueIndex = (myRunerPlrKey%#runnerPlrs)+1--gets next index and loops over array
                                    local myGuyToRescuePlr = runnerPlrs[GuyToRescueIndex]
                                    --print("TO RESCUE:",myGuyToRescuePlr,GuyToRescueIndex,myRunerPlrKey,#runnerPlrs)
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
                                for key, theirPlr in ipairs(runnerPlrs) do
                                    if not theirPlr:GetAttribute("HasCaptured") then
                                        keyNeeded = key
                                        break
                                    end
                                end
                                local Result = (myRunerPlrKey==keyNeeded and not C.plr:GetAttribute("HasCaptured")) or C.plr:GetAttribute("HasRescued") or #runnerPlrs==1
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
                            warn(`[C.StartBeast]: Unknown Implementation for StartBeast`)
                        end
                    end,
                    DoOverrides = function(self, toggle)
                        --toggle = toggle and self.EnTbl.RunType == "Survivor"
                        C[toggle and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoHit,self.Shortcut)
                        C[toggle and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoRope,self.Shortcut)
                        C[toggle and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoCapture,self.Shortcut)
                        C[toggle and "AddOverride" or "RemoveOverride"](C.hackData.Blatant.Fly,self.Shortcut)
                        self.WasRunning = toggle
                    end,
                    StartUp = function(self, gameOver)
                        C.RemoveAction(self.Shortcut)
                        C.getgenv().Rescued = nil
                        if gameOver or not C.BeastChar or not C.char or not C.isInGame(C.char) or not self.RealEnabled then
                            --print("Disabled: ",C.char,C.BeastChar,C.isInGame(C.char),self.RealEnabled)
                            return self:DoOverrides(false)-- No beast no hoes
                        end
                        self:DoOverrides(true)
                        local inGame, role = C.isInGame(C.char)
                        if inGame then
                            local myActionClone
                            myActionClone = C.AddAction({Title=`{self.EnTbl.RunType} ({role})`, Name = self.Shortcut, Threads = {}, Time = function(actionClone, info)
                                self["Start"..role](self, actionClone, info)
                            end, Stop = function(byReq)
                                if BotActionClone == myActionClone then
                                    BotActionClone = nil
                                end
                                if byReq then
                                    print("Disabled by request!")
                                    C.DoActivate(self, self.Activate, self.RealEnabled, false)
                                end
                            end})
                            BotActionClone = myActionClone
                            table.insert(self.Threads,task.delay(309, function()
                                if myActionClone ~= BotActionClone then
                                    return
                                end
                                C.CreateSysMessage(`[Flee.ServerFarm]: System Timeout For One Game Occured Of 30 Seconds; Resetting Activated!`)
                                warn(`System Timeout For One Game Occured Of 30 Seconds; Resetting Activated!`)
                                --C.ResetCharacter()
                            end))
                        end
                    end,
                    Activate = function(self, newValue, firstRun)
                        self:StartUp()
                    end,
                    Completed = function(self)
                        -- Finished on its own --
                        print(debug.traceback("GAME OVER"))
                        self:StartUp(true)
                        C.getgenv().Rescued = nil
                        self.SurvivorList = nil
                        --C.DoActivate(self, self.Activate, self.RealEnabled, false)
                        for _, theirPlr in ipairs(PS:GetPlayers()) do
                            theirPlr:SetAttribute("HasRescued",nil)
                            theirPlr:SetAttribute("HasCaptured",nil)
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
                            C.ClearThreadTbl(self.Threads)
                        end,
                        MapRemoved = function(self)
                            self:Completed()
                        end,
                        CapturedAdded = function(self, theirPlr, theirChar)
                            --print(theirPlr,"CAPTURED")
                            theirPlr:SetAttribute("HasCaptured", true)
                        end,
                        CapturedRemoved = function(self, theirPlr, theirChar)
                            --print(theirPlr,"FREED")
                            -- Attribute it to that player
                            if self.SurvivorList then
                                local theirKey = table.find(self.SurvivorList, theirPlr)
                                if not theirKey then
                                    --warn("Survivor",theirPlr,"has no associated survivor key??")
                                    return
                                end
                                local theirKeyPlusOne = (theirKey%#self.SurvivorList) + 1
                                self.SurvivorList[theirKeyPlusOne]:SetAttribute("HasRescued", true)
                                --print(theirPlr.Name,"Rescued!")
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
                    whitelistedUsers = {"queen_bestiesforlife","itsagoodgamebros","facilitystorage","z_baeby","yvettecarreno08"},
                    lastSend = 0,
                    IsAllowed = function(self,theirPlr)
                        return table.find(self.whitelistedUsers,theirPlr.Name:lower()) or table.find(C.AdminUsers, theirPlr.Name:lower())
                    end,
                    Activate = function(self,newValue,firstRun)
                        if not newValue then
                            return
                        end
                        local ReceiveEvent=Instance.new("BindableEvent")
                        table.insert(self.Instances, ReceiveEvent)

                        local IsTrading = false
                        local tradePlr
                        local function RemoteEventReceivedFunction(main,sec,third)
                            if main=="StartTradeCoolDown" then
                                self.lastSend=os.clock()
                            end
                            if main=="RecieveTradeRequest" and not IsTrading then
                                tradePlr=PS:GetPlayerByUserId(sec)
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
                                    local theirInventory = C.GetUserInventory(tradePlr)

                                    local myInventory = C.GetUserInventory()
                                    for name, count in pairs(myInventory) do
                                        local newCount = math.min(count - self.EnTbl.KeepAmount, 10 - (theirInventory[name] or 0))
                                        myInventory[name] = newCount>0 and newCount or nil
                                    end
                                    task.wait(1/2)
                                    if not self.EnTbl.ReceiveOnly then
                                        local ItemsToSend = 4
                                        local sendArr = {}
                                        for name, count in pairs(myInventory) do
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
                                    tradePlr = theirPlr
                                end
                            end
                            if not IsTrading and tradePlr then
                                print("Sending Trade Request:",tradePlr)
                                C.RemoteEvent:FireServer("SendTradeRequest", tradePlr.UserId)
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
                    },
                },
            }
        )
	}
end
