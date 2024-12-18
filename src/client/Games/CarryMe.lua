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
				Shortcut = "GrabTeammate",Threads={},
                CanCarry = function(self)
                    local HasCarry = C.char.IsCarrying.Value or C.char.BeingCarried.Value
                    return not HasCarry
                end,
				Activate = function(self,newValue,firstRun)
                    if not self:CanCarry() then
                        return
                    end
                    local MyPairPlr = C.char.Pair.Value
                    local MyPairChar = MyPairPlr.Character
                    --
                    --task.wait()
                    C.SavePlayerCoords(self.Shortcut)
                    --C.CommandFunctions["follow"]:Run({{MyPairPlr},0})
                    while self:CanCarry() do
                        C.DoTeleport(MyPairChar:GetPivot())
                        C.fireproximityprompt(MyPairChar.HumanoidRootPart.ProximityPrompt, 1, true)
                        --RunS.RenderStepped:Wait()
                        task.wait(1/12)
                    end
                    --C.CommandFunctions["follow"]:Run({{C.plr},0})
                    C.LoadPlayerCoords(self.Shortcut)
				end,
			},
		}

	}
end