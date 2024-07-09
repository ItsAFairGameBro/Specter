local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local CG = game:GetService("CoreGui")
return function(C,Settings)
	return {
		Category = {
			Name = "Render",
			Title = "Render",
			Image = 14503021137,
			Layout = 1,
		},
		Tab = {
			{
				Title = "Nicknamer",
				Tooltip = "LOCALLY changes your username and displayname",
				Layout = 1,
				Shortcut = "Nickname",Functs={},Default=false,
				Set = function(Username:string, Display: string)
					if C.isStudio then
						return
					end
					Display = Username or Display
					local Display1Box = C.StringWait(CG,"PlayerList.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame"
					..`.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame.p_{C.plr.UserId}.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName`)
					local Display2Box = C.StringWait(CG,`RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.PageViewClipper.PageView.PageViewInnerFrame.Players.PlayerLabel{C.plr.Name}.DisplayNameLabel`)
					local Username1Box = C.StringWait(CG,`RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.PageViewClipper.PageView.PageViewInnerFrame.Players.PlayerLabel{C.plr.Name}.NameLabel`)
					Display1Box.Text = Display
					Display2Box.Text = Display
					Username1Box.Text = Username
					--Set the character, if it exists
					if C.char then
						C.char.Name = Username
					end
					if C.human then
						C.human.DisplayName = Display
					end
					--Set the actual username
					C.setscriptable(C.plr,"Name",true)
					C.setscriptable(C.plr,"DisplayName",true)
					
					C.plr.Name, C.plr.DisplayName = Username, Display
					
					C.setscriptable(C.plr,"Name",false)
					C.setscriptable(C.plr,"DisplayName",false)
				end,
				Activate = function(self,newValue)
					if self.EnTbl.En then
						self:Set(self.EnTbl.Username,self.EnTbl.DisplayName)
					else
						self:Set(C.Defaults.Username,C.Defaults.DisplayName)
					end
				end,
                Events = {},
				Options = {
					{
						Type = Types.Textbox,
						Title = "Username",
						Tooltip = "Swings everywhere cuz why not?",
						Layout = 1,Default = "Player1",Min=3,Max=20,
						Shortcut="Username",
					},
					{
						Type = Types.Textbox,
						Title = "DisplayName",
						Tooltip = "Swings everywhere cuz why not?",
						Layout = 2,Default = "Player",Min=3,Max=20,
						Shortcut="DisplayName",
					}
				},
			},
			--[[{
				Title = "AimAssist",
				Tooltip = "Aims At Enemies",
				Layout = 1,
				Shortcut = "AimAssist",
				Activate = function(self,newValue)
					print("wow",newValue)
				end,
				Events = {
					
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "God Mode",
						Tooltip = "Swings everywhere cuz why not?",
						Layout = 1,Default = true,
						Shortcut="GodMode",
					},
					{
						Type = Types.Slider,
						Title = "Distance",
						Tooltip = "How far an enemy can be before the interaction occurs",
						Layout = 2,Default=10,
						Min=0,Max=100,Digits=1,
						Shortcut="Distance",
					},
					{
						Type = Types.Dropdown,
						Title = "Mode",
						Tooltip = "What kind of mode to select",
						Layout = 3,Default="Ranged",
						Selections = {"Ranged","Legit","Far"},
						Shortcut="Dropdown1",
					},
					{
						Type = Types.Dropdown,
						Title = "Mode2",
						Tooltip = "What kind of mode to select",
						Layout = 4,Default="Ranged2",
						Selections = {"Ranged2","Legit2","Far2"},
						Shortcut="Dropdown2",
					},
				}
			},--]]
		}
	}
end
