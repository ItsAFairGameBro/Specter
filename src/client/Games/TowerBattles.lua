local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local DS = game:GetService("Debris")
local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")
return function(C,Settings)
	return {
		Category = {
			Name = "TowerBattles",
			Title = "Tower Battles",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab = {
			{
				Title = "Join Survival",
				Tooltip = "Automatically joins survival!",
				Layout = 1,
				Shortcut = "Auto",Functs={},Threads={},
				Activate = function(self,newValue,firstRun)
					if not newValue then
                        return
                    end
                    if game.PlaceId == 45146873 then
						C.ServerTeleport(49707852, nil)
					elseif game.PlaceId == 49707852 then
						while task.wait(2) and not C.Cleared do
							workspace.Vote:InvokeServer("Veto")
							print("Im here",#self.Threads)
						end
					end
				end,
                Events = {},
				Options = {},
			},
		}
		
	}
end