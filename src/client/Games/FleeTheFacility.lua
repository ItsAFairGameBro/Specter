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

return function(C,Settings)
    C.RemoteEvent = RS:WaitForChild("RemoteEvent")
    
    
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
        --[[task.delay(.3,C.RemoteEvent.FireServer,C.RemoteEvent, RequestName,theirPlr and {theirPlr.UserId} or nil)
    
        local Res, Inventory
        while (Res ~= RequestName) do
            Res, Inventory = C.RemoteEvent.OnClientEvent:Wait()
        end--]]
        --print("Sending",RequestName)
        local Success, Res, Inventory = SendWaitRemoteEvent(RequestName, RequestName, theirPlr and theirPlr.UserId or nil)
        local InventoryCount = {}
    
        for _, item in ipairs(Inventory) do
            InventoryCount[item] = (InventoryCount[item] or 0) + 1
        end
        InventoryCount["H0001"], InventoryCount["G0001"] = nil, nil
        return InventoryCount, #Inventory
    end
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
    if game.PlaceId ~= 1738581510 then -- Not Trading Hub!
        return
    end
    
	return {
		Category = {
			Name = "FleeTheFacility",
			Title = "Flee The Facility",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab = {
			{
				Title = "Insta Trade",
				Tooltip = "Automatically trades with \"trusted\" users!",
				Layout = 1,
				Shortcut = "InstaTrade",Functs={}, Threads={}, Instances = {},Default=false,
				whitelistedUsers = {"queen_bestiesforlife","itsagoodgamebros","facilitystorage"},
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

                    local waitForThing
                    local function waitForReceive(thing2Wait,args,shouldntSend)
                        while waitForThing do
                            ReceiveEvent.Event:Wait()
                        end
                        waitForThing=thing2Wait
                        if not shouldntSend then
                            task.delay(.15,function()
                                C.RemoteEvent:FireServer(C.RemoteEvent,thing2Wait,table.unpack(args or {}))
                            end)
                        end
                        return ReceiveEvent.Event:Wait()
                    end
                    local IsTrading = false
                    local TradeSpyEn = false
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
                                --[[local theirItems,theirUser=waitForReceive("GetOtherPlayerInventory",{user.UserId})
                                local items2Trade=waitForReceive("GetPlayerInventory")
                                local theirItemsCount={}
                                table.remove(items2Trade,table.find(items2Trade,"H0001"))
                                table.remove(items2Trade,table.find(items2Trade,"G0001"))
                                for num, item in ipairs(theirItems) do
                                    theirItemsCount[item]=(theirItemsCount[item] or 0)+1
                                    if theirItemsCount[item]>=10 then
                                        local Occurances = 0
                                        while true do --for num2, item2Remove in ipairs(items2Trade) do
                                            local KeyFind = table.find(items2Trade,item)
                                            if KeyFind then
                                                table.remove(items2Trade,KeyFind)
                                                Occurances = Occurances + 1
                                            else
                                                break
                                            end
                                        end
                                        print(theirUser.." has max limit of "..(item:sub(1,1)=="H" and "Hammer" or "Gem") .." "..RS.ItemDatabase[item]:GetAttribute("ItemName").."! ("..C.comma_value(Occurances).." Removed)")
                                    end
                                end
                                for s=1,#items2Trade-C.enHacks.Util_InstaTradeAmnt do
                                    table.remove(items2Trade,Random.new():NextInteger(1,#items2Trade))
                                end
                                local isStillSending=true
                                task.spawn(function()
                                    waitForReceive("UpdateMyTradeOfferResult",nil,true)
                                    isStillSending=false
                                end)
                                --while isStillSending or not isStillSending do
                                print("Sending "..C.comma_value(#items2Trade).." items: ", table.concat(items2Trade,", "))
                                C.RemoteEvent:FireServer("SendMyTradeOffer",items2Trade)
                                task.wait(2/4)
                                --end
                                self.lastSend=os.clock()>3 and os.clock() or self.lastSend
                                while os.clock()-self.lastSend<3.1 do
                                    task.wait(1/4)
                                end
                                local isWaiting=true
                                task.spawn(function()
                                    waitForReceive("TradeAccepted",nil,true)
                                    isWaiting=false
                                end)
                                while isWaiting do
                                    if os.clock()-self.lastSend>=30 then
                                        print("Trade complete timeout!")
                                        C.RemoteEvent:FireServer("CancelTrade")
                                        return
                                    end
                                    C.RemoteEvent:FireServer("AcceptTradeOffer")
                                    task.wait()
                                end--]]
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
                            local theirInventory = C.GetUserInventory(tradePlr)
                                
                            local myInventory = C.GetUserInventory()
                            for name, count in pairs(myInventory) do
                                local newCount = math.min(count - self.EnTbl.KeepAmount, 10 - (theirInventory[name] or 0))
                                myInventory[name] = newCount>0 and newCount or nil
                            end
                            task.wait(1)
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
                                task.wait(1)
                            end
                            print("Trade Timed Out!")
                            C.RemoteEvent:FireServer("CancelTrade")
                            IsTrading, tradePlr = false, nil
                        elseif main == "TradeCancelled" then
                            print("Trade Cancelled!")
                            IsTrading, tradePlr = false, nil
                        elseif main == "TradeVerifying" then
                            print("Trade Successfully Complete!")
                            IsTrading = false
                            tradePlr = nil
                        --elseif waitForThing==main then
                        --    waitForThing=nil
                        --    ReceiveEvent:Fire(sec,third)
                        elseif (TradeSpyEn and string.find(main:lower(),"trade")~=nil and main~="UpdateOpenTradePlayersList" and main~= "PlayerListJoined" and main~= "PlayerListRemoved") then
                            print("Spy;",table.unpack({main,sec,third}))
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
                                local itemNeeds = self.EnTbl.EventBundleQty - MyInventory[item]
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
                                SendWaitRemoteEvent("RefreshCurrentMenu","BuyCrateBoxItem", itemType, itemName)
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
                                SendWaitRemoteEvent("RefreshCurrentMenu","BuyShopBundle",itemName)
                                MyInventory, CurCount = C.GetUserInventory()
                            end
                        end
                        task.wait(.8)
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
	}
end
