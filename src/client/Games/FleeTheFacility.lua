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
        Functs = {},
        Activate = function(self, newValue)
            if not newValue then
                return
            end
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
        end,
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
            for _, item in ipairs(newMap:GetChildren()) do
                if item.Name:sub(1,9) == "FreezePod" then
                    table.insert(C.FreezingPods, item)
                elseif item.Name:sub(1,13) == "ComputerTable" then
                    table.insert(C.Computers, item)
                elseif item.Name=="SingleDoor" or item.Name=="DoubleDoor" then
                    table.insert(C.NormalDoors, item)
                elseif item.Name=="ExitDoor" then
                    table.insert(C.ExitDoors, item)
                end
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
                C.Hammer, C.BeastPlr, C.BeastChar = inst, theirPlr, theirPlr.Character
                C.FireEvent("BeastHammerAdded",theirPlr == C.plr,theirPlr,theirChar,theirHuman)
                C.AddObjectConnection(inst, "BeastHammerRemoved", inst.Destroying:Connect(function()
                    C.Hammer, C.BeastPlr, C.BeastChar, C.CarriedTorso = nil, nil, nil, nil
                    C.FireEvent("BeastHammerRemoved",theirPlr == C.plr,theirPlr,theirChar,theirHuman)
                end))
                local CarriedTorso = theirChar:WaitForChild("CarriedTorso",20)
                if not CarriedTorso then return end
                C.CarriedTorso = CarriedTorso
                local function RopeUpd(newVal)
                    C.FireEvent(newVal and "BeastRopeAdded" or "BeastRopeRemoved",theirPlr == C.plr,newVal and newVal.Parent or nil)
                end
                C.AddObjectConnection(CarriedTorso, "BeastRope", CarriedTorso.Changed:Connect(RopeUpd))
                if CarriedTorso.Value then
                    RopeUpd()
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
        local ragdollVal = theTSM:WaitForChild("Ragdoll")
        local function beastChangedVal(newVal)
            C.FireEvent(newVal and "BeastAdded" or "BeastRemoved",theirPlr == C.plr,theirPlr)
        end
        C.AddPlayerConnection(theirPlr,isBeastVal.Changed:Connect(beastChangedVal))
        if isBeastVal.Value then
            beastChangedVal(isBeastVal.Value)
        end
        local wasInGame = false
        local function healthChangedVal(newVal)
            local inGame = newVal > 0
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
    end)

    

    
    function C.HitSurvivor(theirChar)
        if not theirChar.PrimaryPart then
            return
        end
        local Dist=(C.Hammer.Handle.Position-theirChar.PrimaryPart.Position).magnitude
        if Dist<15 then
            local closestPart, closestDist = nil, 10 -- Test Success: Hit Part Must Be < 8 Studs of Hammer
            for num, part in ipairs(theirChar:GetChildren()) do
                if part:IsA("BasePart") then
                    local testDist = (part.Position-C.Hammer.Handle.Position).Magnitude
                    if testDist < closestDist then
                        closestPart, closestDist = part, testDist
                    end
                end
            end
            if closestPart then
                C.Hammer.HammerEvent:FireServer("HammerHit", closestPart)
                return true
            end
        end
    end
    function C.RopeSurvivor(theirChar)
        if C.CarriedTorso.Value then
            return
        end
        C.Hammer.HammerEvent:FireServer("HammerTieUp",theirChar.Torso,theirChar.Torso.NeckAttachment.WorldPosition)
    end
    function C.CaptureSurvivor(theirChar)
        if C.BeastPlr ~= C.plr or C.BeastChar.CarriedTorso.Value==nil then
            return
        end
        local function isCapsuleOpen(cap)
            return cap.PrimaryPart and cap:FindFirstChild("PodTrigger") and cap.PodTrigger:FindFirstChild("CapturedTorso") and not cap.PodTrigger.CapturedTorso.Value
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
    function C.WaitForHammer()
        while not C.Hammer do
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
            local theirTSM = theirPlr:FindFirstChild("TempPlayerStatsModule")
            if not theirTSM then
                print("Not tsm",theirPlr)
                continue
            end
            local inGame, role = C.isInGame(theirPlr.Character)
            if (options.InGame~= nil and inGame == options.InGame) or (options[role] ~= nil and options[role])
                or (options.Ragdoll ~= nil and options.Ragdoll == theirTSM.Ragdoll.Value)
                or (options.Captured ~= nil and options.Captured == theirTSM.Captured.Value) then
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
                if C.IsInBox(LobbyOBWall.Size, LobbyOBWall.CFrame, Location, true) then
                    return false, "Lobby"
                else
                    return true, "Survivor"
                end
            else
                return false, "Lobby"
            end
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
                    print(result,SearchUser)
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
                            task.wait()
                        end
                    end
                    return true, found and `In {found}` or `Not Found`, os.clock() - TimeStart
                end,
            }
        }
    end)
    -- MAIN GAME --
    if game.PlaceId ~= 1738581510 then
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
                                for _, theirPlr in ipairs(C.GetPlayerListOfType({Survivor=true})) do
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
                            print("RagdollAdded")
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
                            self.Events.MyBeastRopeAdded(self)
                        end
                    end,
                    Events = {
                        MyBeastRopeAdded = function(self,theirChar)
                            C.CaptureSurvivor(theirChar)
                        end,
                    },
                },
            }, table.find(C.BotUsers, C.plr.Name:lower()) and {
                {
                    Title = "Server Farm",
                    Tooltip = "Event tester",
                    Layout = 100,
                    Shortcut = "ServerBot",Functs={}, Threads={}, Default=true,
                    StartSurvivor = function(self)
                        local hitList = C.GetPlayerListOfType({Lobby = false, Beast = false, Survivor = true})
                        table.sort(hitList,function(a,b)
                            return a.Name:lower() < b.Name:lower()
                        end)

                    end,
                    StartBeast = function(self)
                        for _, theirPlr in ipairs(C.GetPlayerListOfType({Captured = false})) do
                            local TSM = theirPlr:FindFirstChild("TempPlayerStatsModule")
                            if not TSM then
                                return
                            end
                            C.CommandFunctions.follow:Run({{theirPlr},5})
                            print(theirPlr,theirPlr.Parent,TSM.Captured.Value)
                            while theirPlr and theirPlr.Parent and not TSM.Captured.Value do
                                RunS.RenderStepped:Wait()
                            end
                        end
                        print("FINISHED")
                        C.CommandFunctions.follow:Run({{}})
                    end,
                    DoOverrides = function(self, toggle)
                        C[toggle and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoHit,self.Shortcut)
                        C[toggle and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoRope,self.Shortcut)
                        C[toggle and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoCapture,self.Shortcut)
                    end,
                    StartUp = function(self)
                        C.RemoveAction(self.Shortcut)
                        if not C.BeastChar or not C.char or not C.isInGame(C.char) then
                            return self:DoOverrides(false)-- No beast no hoes
                        end
                        self:DoOverrides(true)
                        local inGame, role = C.isInGame(C.char)
                        if inGame then
                            C.AddAction({Title=`ServerFarm: {role}`, Name = self.Shortcut, Threads = {}, Time = function(actionClone, info)
                                self["Start"..role](self, actionClone, info)
                            end, Stop = function(byReq)
                                if byReq then
                                    self:SetValue(true)
                                end
                            end})
                        end
                    end,
                    Activate = function(self, newValue, firstRun)
                        if firstRun then
                            return
                        end
                        self:StartUp()
                    end,
                    Events = {
                        BeastHammerAdded = function(self,theirPlr,theirChar,theirHuman)
                            self:StartUp()
                        end,
                    },
                    Options = {
                        {
                            Type = Types.Dropdown,
                            Title = "Run Type",
                            Tooltip = "Which ServerFarm type to run",
                            Layout = 1, Default = "BeastCapture",
                            Shortcut="RunType",
                            Selections = {"BeastCapture"},
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
                    whitelistedUsers = {"queen_bestiesforlife","itsagoodgamebros","facilitystorage","z_baeby"},
                    lastSend = 0,
                    IsAllowed = function(self,theirPlr)
                        return table.find(self.whitelistedUsers,theirPlr.Name:lower())
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
                                    --print("Trade Accepted")
                                else
                                    C.RemoteEvent:FireServer("CancelTrade")
                                    --print("Trade Denied:",tradePlr)
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
                                    --print("Trade Timed Out!")
                                    C.RemoteEvent:FireServer("CancelTrade")
                                    IsTrading, tradePlr = false, nil
                                end))
                                
                            elseif main == "TradeCancelled" then
                                --print("Trade Cancelled!")
                                IsTrading, tradePlr = false, nil
                            elseif main == "TradeVerifying" then
                                --print("Trade Successfully Complete!")
                                IsTrading = false
                                tradePlr = nil
                            end
                        end
                        table.insert(self.Functs,C.RemoteEvent.OnClientEvent:Connect(RemoteEventReceivedFunction))
                        C.RemoteEvent:FireServer("CancelTrade")
                        task.wait(2)
                        while true do
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
