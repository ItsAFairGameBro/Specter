local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local TCS = game:GetService("TextChatService")
local RS = game:GetService"ReplicatedStorage"
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
		}
	}
end
