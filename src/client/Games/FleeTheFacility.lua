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
return function(C,Settings)
    C.RemoteEvent = RS:WaitForChild("RemoteEvent")
    table.insert(C.InsertCommandFunctions,function()
        return {
            ["findtrader"] = {
                Parameters={{Type="User"}},
                Alias = {},
                AfterTxt = " %s in %.2f",
                Run = function(self,args)
                    local SearchUser = args[1]

                    local conn
                    conn = C.RemoteEvent.OnClientEvent:Connect(function(signal, dict)
                        if signal == "ReceiveTradingPostPlayersList" then
                            conn:Disconnect()
                            local count = 0
                            for gameID, data in pairs(dict) do
                                count+=1
                                if table.find(data.namesList, SearchUser) then
                                    if C.Prompt(`Join {SearchUser} In Trading? ({#data.namesList} Players)`, table.concat(data.namesList,"\n"), "Y/N") == true then
                                        C.ServerTeleport(1738581510,gameID)
                                    end
                                    print("Found In ",gameID)
                                end
                                if count%8==0 then
                                    task.wait()
                                end
                            end
                            warn("NOT FOUND!")
                        end
                    end)

                    C.RemoteEvent:FireServer("RequestTradingPostPlayersList")
                    return "",.1
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
				Shortcut = "InstaTrade",Functs={}, Instances = {},Default=false,
				whitelistedUsers = {"queen_bestiesforlife"},
                lastSend = 0,
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
                    local TradeSpyEn = true
                    local function RemoteEventReceivedFunction(main,sec,third)
                        if main=="StartTradeCoolDown" then
                            self.lastSend=os.clock()
                        end
                        if main=="RecieveTradeRequest" then
                            local user=PS:GetPlayerByUserId(sec)
                            if ((self.whitelistedUsers[user.Name:lower()])) then
                                C.RemoteEvent:FireServer("AcceptTradeRequest")
                                print("Accepted")
                                local theirItems,theirUser=waitForReceive("GetOtherPlayerInventory",{user.UserId})
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
                                end
                                print("Trade Successfully Complete!")
                            else
                                C.RemoteEvent:FireServer("CancelTrade")
                            end
                        elseif waitForThing==main then
                            waitForThing=nil
                            ReceiveEvent:Fire(sec,third)
                        elseif (TradeSpyEn and string.find(main:lower(),"trade")~=nil and main~="UpdateOpenTradePlayersList" and main~= "PlayerListJoined" and main~= "PlayerListRemoved") then
                            print("Spy;",table.unpack({main,sec,third}))
                        end
                    end
                    table.insert(self.Functs,C.RemoteEvent.OnClientEvent:Connect(RemoteEventReceivedFunction))
                    C.RemoteEvent:FireServer("CancelTrade")
				end,
                Events = {},
				Options = {},
			},
		}
	}
end
