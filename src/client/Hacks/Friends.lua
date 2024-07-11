local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}
local PS = game:GetService("Players")
return function(C,Settings)
	return {
		Category = {
			Name = "Friends",
			Title = "Friends",
			Image = 10885655986,
			Layout = 3,
			AfterMisc = true,
		},
		Tab = {
			{
				Title = "Target Blacklist",Shortcut="NoTargetFriends",
				Tooltip = "Modules that attack other players do not attack a selected list of \"friends\"",
				Layout = 1,
				Events = {},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Roblox Friends",Shortcut="RobloxFriends",
						Tooltip = "Doesn't target Roblox Friends. Refreshes on enable",
						Activate=function(self,enabled,firstRun)
							if not enabled then
								C.friends = {}
								return
							end
							local friendPages = PS:GetFriendsAsync(C.plr.UserId)
							local function iterPageItems(pages)
								return coroutine.wrap(function()
									local pagenum = 1
									while true do
										for _, item in ipairs(pages:GetCurrentPage()) do
											coroutine.yield(item, pagenum)
										end
										if pages.IsFinished then
											break
										end
										pages:AdvanceToNextPageAsync()
										pagenum = pagenum + 1
									end
								end)
							end
							local userids = {}
							for item, pageNo in iterPageItems(friendPages) do
								table.insert(userids, item.Id)
							end
							C.friends = userids
							if self.Enabled then
								C.AddNotification("Friends Loaded",`{#userids} Friends will not be targeted by modules`)
							end
						end,
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
		},
		{
			Title = "Main Account",Shortcut="MainAccount",
			Tooltip = "Input your main account and ",
			Layout = 1,
			Events = {},
			Options = {
				{
					Type = Types.UserList,
					Title = "Additional Friends",Shortcut="MainAccountId",
					Tooltip = "A list of friends that are never targeted from modules",
					Layout = 2,Default={},
					Limit = 1,
				},
			}
		},
	}
end
