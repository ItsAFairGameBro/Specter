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
			Name = "NaturalDisasterModded",
			Title = "Natural Disaster Survival: Modded",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab = {
			{
				Title = "Disable Fall Damage",
				Tooltip = "Removes your fall damage!",
				Layout = 1,
				Shortcut = "DisableFallDamage",Threads={},
				Activate = function(self,newValue,firstRun)
                    local toStr = tostring
                    local tskSpawn = task.spawn
                    C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,...)
						if toStr(self) == "TrackDamage" or toStr(self) == "DmgEvent" then
                            tskSpawn(print, "Cancelled dmg:",toStr(self),...)
							return "Yield"
						end
					end,{"fireserver"})
				end,
			},
		}

	}
end