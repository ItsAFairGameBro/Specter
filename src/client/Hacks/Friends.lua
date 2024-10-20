local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}
local PS = game:GetService("Players")
return function(C,Settings)
	return {
		Category = {
			Name = "Users",
			Title = "Friends",
			Image = 10885655986,
			Layout = 3,
			AfterMisc = true,
		},
		Tab = {
			{
				Title = "Target Blacklist",Shortcut="NoTargetFriends",
				Tooltip = "Modules that attack other players do not attack a selected list of \"friends\"",
				Layout = 1, Default = true,
				Activate = function(self, enabled, firstRun)
					--[[if not enabled then
						C.friends = {}
						return
					end--]]
					local theirEnTbl = C.enHacks.Users.MainAccount
					local friends = C.GetFriendsFunct(theirEnTbl.En and theirEnTbl.MainAccountId[1] or C.plr.UserId)
                    local friendNames = {}
                    for _, data in ipairs(friends) do
                        table.insert(friendNames,data.SortName)
                    end

                    C.friendnames = friendNames
					C.friends = friends
					if self.RealEnabled and not firstRun then
						C.AddNotification("Friends Loaded",`{#friends} Friends will not be targeted by modules`)
					end
				end,
				Options = {
					{
						Type = Types.Toggle,
						Title = "Roblox Friends",Shortcut="RobloxFriends",
						Tooltip = "Doesn't target Roblox Friends. Refreshes on enable",
						Activate=C.ReloadHack,
						Layout = 1,Default = true,
					},
					{
						Type = Types.UserList,
						Title = "Additional Friends",Shortcut="AdditionalFriends",
						Tooltip = "A list of friends that are never targeted from modules",
						Layout = 2,Default={},
						Limit = 30,
					},
				}
			},
			{
				Title = "Main Account",Shortcut="MainAccount",
				Tooltip = "Input your main account and it will be",
				Layout = 2, Default = true,
				Events = {},
				Options = {
					{
						Type = Types.UserList,
						Title = "Account",Shortcut="MainAccountId",
						Tooltip = "Your main account (defaults to current account)",
						Layout = 2,Default={},
						Limit = 1,
						Activate = C.ReloadHack,--function(self)
							--local FriendHack = self.Parent.Parent[1]
							--FriendHack.Options[1].Activate(FriendHack,FriendHack.Enabled)
							--self.Parent.Parent:Activate()
						--end,
					},
				},
				Activate = function(self,newValue,startUp)
					if startUp then
						return
					end
					local FriendHack = self.Parent.Tab[1]
					FriendHack.Options[1].Activate(FriendHack,FriendHack.RealEnabled)
				end,
			},
		}
	}
end
