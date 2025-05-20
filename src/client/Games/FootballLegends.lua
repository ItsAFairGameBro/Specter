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
			Name = "FootballLegends",
			Title = "Football Legends",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab = {
			{
				Title = "Auto Kicker",
				Tooltip = "Kicks the ball automatically!",
				Layout = 1,
				Shortcut = "AutoKicker",Functs={},Default=true,
				Activate = function(self,newValue,firstRun)
                    local tblPack = table.pack
                    local setVal1 = (100 - self.EnTbl.Accuracy) / 100
                    local setVal2 = self.EnTbl.Power / 100
					C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,arg1,arg2,...)
                        if tostring(self) == "KickValues" then
                            return "Override", tblPack(self,setVal1,setVal2,...)
                        end
                    end,{"fireserver"})
				end,
                Events = {},
				Options = {
                     {
                        Type = Types.Slider,
                        Title = "Power",
                        Tooltip = "How fast the ball should go (percent)",
                        Layout = 1,Default = 90,
                        Min = 0, Max=100, Digits=0,
                        Shortcut="Power",
                    },
                    {
                        Type = Types.Slider,
                        Title = "Accuracy",
                        Tooltip = "How accurate the aim is (percent)",
                        Layout = 1,Default = 90,
                        Min = 0, Max=100, Digits=0,
                        Shortcut="Accuracy",
                    },
				},
			},
		}
		
	}
end
