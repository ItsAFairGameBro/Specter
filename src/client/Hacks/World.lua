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
			Image = 14503021137,
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
                        TCS.TextChannels.RBXGeneral:SendAsync(real..'\r'..fake)
                    elseif TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
                        RS.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(real..string.sub((" "):rep(155),#real)..fake,"All")
                    else
                        error("Unknown TCS ChatVersion: "..tostring(TCS.ChatVersion))
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
                    table.insert(self.Functs,theirPlr.Chatted:Connect(function(msg,recipient)
                        msg = msg:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ') -- CLIP THE MESSAGE (important!)
						local setChannel,moveon,hidden = nil,false,true
						local conn = getmsg.OnClientEvent:Connect(function(packet,channel)
							if (packet.Message==msg:sub(#msg-#packet.Message+1) and (channel=="All") and packet.SpeakerUserId==theirPlr.UserId)
								or (channel=="Team" and Config.public==false and PS[packet.FromSpeaker].Team==C.plr.Team) then
								hidden = false
							end
                            setChannel,moveon = channel, true
						end)
                        task.delay(C.plr:GetNetworkPing()*3,function()
                            moveon=true
                        end)
                        while not moveon do
                            RunS.RenderStepped:Wait()
                        end
						conn:Disconnect()
						if hidden then
							C.CreateSysMessage("["..theirPlr.Name.."]: "..msg,Color3.fromRGB(0,175),`{setChannel or tostring(recipient) or "Chat"} Spy`)
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
                        if not self.EnTbl.En then return end
						self:AddToChat(theirPlr)
					end,
                },Functs={},
				Options = {
					
				},
			},
		}
	}
end
