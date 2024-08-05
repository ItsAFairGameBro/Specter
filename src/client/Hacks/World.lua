local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local TCS = game:GetService("TextChatService")
local RS = game:GetService"ReplicatedStorage"
local PS = game:GetService"Players"
local RunS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
return function(C,Settings)
	return {
		Category = {
			Name = "World",
			Title = "World",
			Image = 15170258619,
			Layout = 4,
		},
		Tab = {
			{
				Title = "Fake Chat",
				Tooltip = "Display two messages in the chat",
				Layout = 1,Type = "NoToggle",
				Shortcut = "Nickname",
				Activate = function(self,newValue)
					local real = self.EnTbl.Real
                    local fake = self.EnTbl.Fake
                    if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
                        fake = string.gsub(fake, "\n", "\r")
                        C.SendGeneralMessage(real..'\r'..fake)
                    elseif TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
                        C.SendGeneralMessage(real..string.sub((" "):rep(155),#real)..fake)
                    else
                        error("Unknown TCS ChatVersion For `Fake Chat`: "..tostring(TCS.ChatVersion))
                    end
				end,
                Events = {},
				Options = {
					{
						Type = Types.Textbox,
						Title = "Real",
						Tooltip = "What you say in the chat",
						Layout = 1,Default = ";admin all",Min=1,Max=100,
						Shortcut="Real",
					},
					{
						Type = Types.Textbox,
						Title = "Fake",
						Tooltip = "What is said a message below your chat",
						Layout = 2,Default = "{Team} You are now on the 'Admins' team.",Min=1,Max=100,
						Shortcut="Fake",
					}
				},
			},
            {
				Title = "Chat Spy",
				Tooltip = "Puts ALL whispers and team chat messages not visible to you into the chat!",
				Layout = 2,
				Shortcut = "ChatSpy",Default=true,
                AddToChat = function(self,theirPlr)
                    local DefaultChatSystemChatEvents = RS:WaitForChild("DefaultChatSystemChatEvents",10)
                    local Config = {public = false}
                    if not DefaultChatSystemChatEvents then
                        return
                    end
                    local getmsg = DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering")
                    table.insert(self.Functs,theirPlr.Chatted:Connect(function(msg)
                        msg = msg:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ') -- CLIP THE MESSAGE (important!)
						local setChannel,moveon,hidden = nil,false,true
						local conn = getmsg.OnClientEvent:Connect(function(packet,channel)
							if (packet.Message==msg:sub(#msg-#packet.Message+1) and (channel=="All") and packet.SpeakerUserId==theirPlr.UserId)
								or (channel=="Team" and Config.public==false and PS[packet.FromSpeaker].Team==C.plr.Team) then
								hidden = false
							end
                            setChannel,moveon = channel or packet.OriginalChannel, true
						end)
                        task.delay(C.plr:GetNetworkPing()*3,function()
                            moveon=true
                        end)
                        while not moveon do
                            RunS.RenderStepped:Wait()
                        end
						conn:Disconnect()
						if hidden then
							C.CreateSysMessage("["..theirPlr.Name.."]: "..msg,Color3.fromRGB(0,175),`{setChannel or "Chat"} Spy`)
                            if self.EnTbl.Echo then
                                C.SendGeneralMessage("["..theirPlr.Name.."]: "..msg)
                            end
						end
                    end))
                end,
				Activate = function(self,newValue)
                    if not newValue then return end
					for num, theirPlr in ipairs(PS:GetPlayers()) do
                        if theirPlr ~= C.plr then
                            self:AddToChat(theirPlr)
                        end
                    end
				end,
                Events = {
                    OthersPlayerAdded=function(self,theirPlr,firstRun)
                        if not self.RealEnabled or firstRun then return end
						self:AddToChat(theirPlr)
					end,
                },Functs={},
				Options = {
                    {
						Type = Types.Toggle,
						Title = "Echo",
						Tooltip = "What is said privately in the chat you repeat (using the chat function)",
						Layout = 2,Default = false,
						Shortcut="Echo",
					}
				},
			},
			{
				Title = "Fire",Type="NoToggle",
				Tooltip = "Fires TouchInterest, ProximityPrompt, ClickDetector",
				Layout = 3,NoStudio=true,
				Shortcut = "FireElements",Threads={},
				CheckForBlacklist = function(self,instance)
					if game.GameId == 2733031763 and instance.Parent.Name == "Floor" then
						return true
					end
					return false
				end,
				GetSearchInstance = function(self)
					if game.GameId == 2733031763 then
						return C.StringWait(workspace,"Bridge")
					end
					return workspace
				end,
				TouchTransmitter = function(self,instance)
					local Parent = instance.Parent
					local CanTouch = Parent.CanTouch
					Parent.CanTouch = true
					if C.hrp then
						C.firetouchinterest(C.hrp,Parent,0)
						task.wait()
						C.firetouchinterest(C.hrp,Parent,1)
					end
					Parent.CanTouch = CanTouch
				end,
				ClickDetector = function(self,instance)
					C.fireclickdetector(instance,C.Randomizer:NextNumber(2,3),"MouseClick")
				end,
				ProximityPrompt = function(self,instance)
					C.fireproximityprompt(instance,1,true)
				end,
				Activate = function(self,newValue)
					local EnTbl = self.EnTbl
                    for num, instance in ipairs(self:GetSearchInstance():GetDescendants()) do
						for name, en in pairs(EnTbl) do
							if instance:IsA(name) and en and not self:CheckForBlacklist(instance) then
								self[name](self,instance)
							end
						end
						if num%100 == 0 then
							RunS.RenderStepped:Wait()
						end
					end
				end,
				Options = {
                    {
						Type = Types.Toggle,
						Title = "TouchInterest",
						Tooltip = "Fire TouchInterests with your character's rootpart",
						Layout = 1,Default = true,
						Shortcut="TouchTransmitter",
					},
					{
						Type = Types.Toggle,
						Title = "ProximityPrompt",
						Tooltip = "Fires all ProximityPrompts exactly once",
						Layout = 2,Default = false,
						Shortcut="ProximityPrompt",
					},
					{
						Type = Types.Toggle,
						Title = "ClickDetector",
						Tooltip = "Clicks on all ClickDetectors at the same time",
						Layout = 3,Default = false,
						Shortcut="ClickDetector",
					}
				},
			}
		}
	}
end
