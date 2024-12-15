local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local DS = game:GetService("Debris")
local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")
return function(C,Settings)
	return {
		Category = {
			Name = "CarryMe",
			Title = "Carry Me",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab = {
			{
				Title = "Grab Teammate",
				Tooltip = "Automatically grabs teammate",
				Layout = 1,Type="NoToggle",
				Shortcut = "GrabTeammate",Functs={},
				Activate = function(self,newValue,firstRun)
                    local CanCarry = C.char.IsCarrying.Value or C.char.BeingCarried.Value
                    local MyPairPlr = C.char.Pair.Value
                    local MyPairChar = MyPairPlr.Character
                    C.CommandFunctions["teleport"]:Run({{MyPairPlr}})
                    task.wait()
                    C.fireproximityprompt(MyPairChar.HumanoidRootPart.ProximityPrompt)
				end,
			},
		}

	}
end