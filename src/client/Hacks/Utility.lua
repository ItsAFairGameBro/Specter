local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
return function(C,Settings)
	return {
		Category = {
			Name = "Utility",
			Title = "Utility",
			Image = 6953984446,
			Layout = 5,
		},
		Tab = {
			{
				Title = "Anti Afk",
				Tooltip = "Prevents you from being idle kicked after 20m",
				Layout = 100,
				Shortcut = "AntiAfk",Functs={},Default=true,
                Update = function()
					VU:CaptureController()
                    VU:ClickButton2(Vector2.new())
                end,
				Activate = function(self,newValue)
                    if not newValue then
                        return
                    end
                    table.insert(self.Functs, C.plr.Idled:Connect(self.Update))
				end,
                Events = {},
				Options = {},
			},
		}
	}
end
