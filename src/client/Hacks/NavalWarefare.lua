local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local CG = game:GetService("CoreGui")
return function(C,Settings)
	return {
		Category = {
			Name = "NavalWarefare",
			Title = "Naval Warefare",
			Image = nil, -- Set Image to nil in order to get game image!
			Layout = 20,
		},
		Tab = {
			{
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
			},
		}
	}
end
