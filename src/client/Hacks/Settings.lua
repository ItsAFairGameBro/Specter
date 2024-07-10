local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local SG = game:GetService("StarterGui")
return function(C,Settings)
	return {
		Tab = {
			{
				Title = "Developer",
				Tooltip = "This is designed for developers only; it includes tools that are useful for production",
				Layout = 1,
				Shortcut = "DeveloperMode",
				Functs={},
				Activate = function(self,newValue)
					print("Developer!")
				end,
                Events = {},
				Options = {},
			},
		}
	}
end