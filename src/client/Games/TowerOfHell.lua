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
			Name = "TowerOfHell",
			Title = "Tower Of Hell",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab = {
			{
				Title = "Disable Killparts",
				Tooltip = "Automatically disables all killparts",
				Layout = 1,
				Shortcut = "DisableKillparts",Functs={},
				Activate = function(self,newValue,firstRun)
					if not newValue or not firstRun then
                        return
                    end
                    if C.char then
                        self.Events.MyCharAdded(self,C.plr,C.char,false)
                    end
				end,
                Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
                        local killScript = C.char:WaitForChild("KillScript")
                        if killScript then
                            killScript.Enabled = not self.RealEnabled
                        end
					end,
				},
			},
		}

	}
end