local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local function getMass(model)
	assert(model and model:IsA("Model"), "Model argument of getMass must be a model.");
	
	return model.PrimaryPart.AssemblyMass;
end
return function(C,Settings)
	return {
		Category = {
			Name = "Utility",
			Title = "Utility",
			Image = 10901055597,
			Layout = 2,
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
				Options = {
					{
						Type = Types.Slider,
						Title = "Speed",
						Tooltip = "How fast you fly through the air",
						Layout = 1,Default=20,
						Min=0,Max=200,Digits=1,
						Shortcut="Speed",
					},
					{
						Type = Types.Dropdown,
						Title = "Mode",
						Tooltip = "What kind of movement type",
						Layout = 2,Default="Velocity",
						Selections = {"Physics","CFrame","Velocity"},
						Shortcut="Mode",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Use Walkspeed",
						Tooltip = "Use Walkspeed in calculation",
						Layout = 3,Default=false,
						Shortcut="UseWalkspeed",
					},
					{
						Type = Types.Slider,
						Title = "Horizontal Multiplier",
						Tooltip = "How much faster you go horizontally (forward/left/right/back)",
						Layout = 4,Default=1,
						Min=0.1,Max=10,Digits=1,
						Shortcut="HorizontalMult",
					},
					{
						Type = Types.Slider,
						Title = "Vertical Multiplier",
						Tooltip = "How much faster you go vertically (up/down)",
						Layout = 5,Default=1,
						Min=0.1,Max=10,Digits=1,
						Shortcut="VerticalMult",
					},
					{
						Type = Types.Toggle,
						Title = "Use E+Q+Space",
						Tooltip = "Uses the keybinds E, Q, and Space for control keybinds",
						Layout = 6,Default=true,
						Shortcut="UseExtraKeybinds",
					},
					{
						Type = Types.Toggle,
						Title = "Face Direction",
						Tooltip = "Whether or not to face where you're going",
						Layout = 7,Default=true,
						Shortcut="LookDirection",
						Activate = C.ReloadHack,
					},
				}
			},
		}
	}
end
