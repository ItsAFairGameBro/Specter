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
						while task.wait(2) do
							workspace.Vote:InvokeServer("Veto")
						end
					end
				end,
                Events = {},
				Options = {},
			},
			{
				Title = "Auto Place",
				Tooltip = "Finds the optimal placement for towers until Max Tries are reached; otherwise, lets you place",
				Shortcut = "AutoPlace",
				Layout = 2,
				Activate = function(self, newValue, firstRun)
					--[[local clickyFound = 0
					for num, rawFunct in ipairs(C.getgc()) do
						local functInfo = debug.getinfo(rawFunct)
						if functInfo.name == "Clicked" then
							clickyFound+=1
							print("FOUND",clickyFound)
							C.HookMethod(rawFunct, self.Shortcut, newValue and function()
								print("NO CLICKY 4 U")
							end)
						end
					end--]]
					local toStr = tostring
					C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,troopName)
						if toStr(self) == "PlacingTower" then
							print("TroopName",troopName)
							return "Yield"
						end
					end,{"invokeserver"})
				end,
			}
		}
		
	}
end