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

local function AppendToFirstArr(tbl1, tbl2)
    for _, val2 in ipairs(tbl2) do
        table.insert(tbl1, val2)
    end
    return tbl1
end



local function Static(C, Settings)
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
    }
    return SharedHacks
end

local function SetUpGame(C, Settings)
    C.GameTimer = RS:WaitForChild("GameTimer")
    C.GameStatus = RS:WaitForChild("GameStatus")
    table.insert(C.EventFunctions,function()
        local CurrentMap = RS:WaitForChild("CurrentMap")
		local function MapAdded(newMap)
            while (newMap == CurrentMap and C.GameStatus.Value:lower():find("loading")) do
                C.GameStatus:GetPropertyChangedSignal("Value"):Wait()
            end
            if newMap ~= CurrentMap.Value then
                return
            end
            if not newMap then
                C.FireEvent("MapRemoved",nil,C.Map)
                C.Map = nil
                return
            end
            C.Map = newMap
            C.FireEvent("MapAdded",nil,C.Map)
        end
        C.AddGlobalConnection(CurrentMap.Changed:Connect(CurrentMap))
        MapAdded(CurrentMap)
    end)
    table.insert(C.CharacterAddedEventFuncts, function(theirPlr, theirChar, theirHuman)
        local function childAdded(inst)
            if inst and inst.Name == "Hammer" then
                print("BeastHammerAdded")
                C.BeastPlr, C.BeastChar = theirPlr, theirPlr.Character
                C.FireEvent("BeastHammerAdded",theirPlr == C.plr,theirPlr,theirChar,theirHuman)
                C.AddObjectConnection(inst, "BeastHammerRemoved", inst.Destroying:Connect(function()
                    print("BeastHammerRemoved")
                    C.BeastPlr, C.BeastChar = nil, nil
                    C.FireEvent("BeastHammerRemoved",theirPlr == C.plr,theirPlr,theirChar,theirHuman)
                end))
            end
        end
        C.AddObjectConnection(theirChar, "BeastHammerAdded", theirChar.ChildAdded:Connect(childAdded))
        childAdded(theirChar:FindFirstChild("Hammer"))
    end)
    table.insert(C.PlayerAddedEventFuncts, function(theirPlr, wasAlreadyIn)
        local theTSM = theirPlr:WaitForChild("TempPlayerStatsModule")
        local isMe = theirPlr == C.plr

        local isBeastVal = theTSM:WaitForChild("IsBeast")
        local function beastChangedVal(newVal)
            print("BeastAdded",theirPlr,newVal)
            if newVal then
                C.FireEvent("BeastAdded",theirPlr == C.plr,theirPlr)
            else
                C.FireEvent("BeastRemoved",theirPlr == C.plr,theirPlr)
            end
        end
        C.AddPlayerConnection(theirPlr,isBeastVal.Changed:Connect(beastChangedVal))
        if isBeastVal.Value then
            beastChangedVal(isBeastVal.Value)
        end
    end)
end

return function(C,Settings)
    C.RemoteEvent = RS:WaitForChild("RemoteEvent")
    if game.PlaceId == 0 then
        SetUpGame(C,Settings)
    end
    C.myTSM = C.plr:WaitForChild("TempPlayerStatsModule")
    C.mySSM = C.plr:WaitForChild("SavedPlayerStatsModule")
    
    function C.GetPlayerListOfType(options)
        local list = {}
        for _, theirPlr in ipairs(PS:GetPlayers()) do
            local inGame, role = C.isInGame(theirPlr.Character)
            if (options.InGame~= nil and inGame == options.InGame) or (options[role] ~= nil and options[role]) then
                table.insert(theirPlr, list)
            end
        end
        return list
    end
    local SharedHacks = Static(C, Settings)
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
            if not theirChar then
                return false, "Lobby"
            end
            local theirPlr = PS:GetPlayerFromCharacter(theirChar)
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

            }, C.BotUsers and {
                {
                    Title = "Server Farm",
                    Tooltip = "Event tester",
                    Layout = 1,
                    Shortcut = "ServerBot",Functs={}, Threads={}, Default=true,
                    StartRunner = function(self)
                        local hitList = C.GetPlayerListOfType({Lobby = false, Beast = false, Survivor = true})
                        table.sort(hitList,function(a,b)
                            return a:lower() < b:lower()
                        end)
                        print(hitList)
                    end,
                    StartBeast = function(self)
                        print("StartBeast")
                    end,
                    StartUp = function(self)
                        if not C.Beast or not C.char or not C.isInGame(C.char) then
                            return -- No beast no hoes
                        end
                        local inGame, role = C.isInGame(C.char)
                        if inGame then
                            if role == "Beast" then
                                self:StartBeast()
                            else
                                self:StartRunner()
                            end
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
                    }
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
