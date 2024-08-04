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
			Name = "PassBomb",
			Title = "Pass The Bomb",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab = {
			{
				Title = "Auto Pass Bomb",
				Tooltip = "Passes the bomb to the closest player automatically!",
				Layout = 1,
				Shortcut = "AutoPassBomb",Functs={},Default=true,
                DontActivate=true,
				PassBomb = function(self)
                    print("Passing")
					local Bomb = C.char:WaitForChild("Bomb",5)
                    if Bomb then
                        print("Bomb Found")
                        while Bomb.Parent and Bomb.Parent == C.char do
                            local closestHead, dist = C.getClosest()
                            if not closestHead then
                                error("Nearest player failed: nobody found!")
                            end
                            local theirChar = closestHead.Parent
                            local args = {
                                [1] = theirChar,
                                [2] = theirChar:WaitForChild("CollisionPart"),
                            }
                            Bomb.RemoteEvent:FireServer(unpack(args))
                            print("sent to",theirChar)
                            RunS.RenderStepped:Wait()
                        end
                    end
				end,
				Activate = function(self,newValue,firstRun)
					if not newValue then
                        return
                    end
                    if C.char then
                        self.Events.MyCharAdded(self,C.plr,C.char,false)
                    end
				end,
                Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
                        print("Waiting FOr GotBombVal")
						local BombVal = theirChar:WaitForChild("GotBombVal",10)
                        if not BombVal then
                            print"Failed after 10s"
                            return
                        end
                        table.insert(self.Functs,BombVal.Changed:Connect(function(new)
                            if new then
                                self:PassBomb()
                            end
                        end))
                        if BombVal.value then
                            self:PassBomb()
                        end
					end,
				},
				Options = {
					--[[{
						Type = Types.Toggle,
						Title = "Disable TouchGui",
						Tooltip = "Whether or not to show TouchGui (useful for PC users)",
						Layout = 3,Default=true,
						Shortcut="DisableTouchGUI",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Lock Camera Orientation",
						Tooltip = "Prevents the camera from being rotated when the character moves",
						Layout = 2,Default=true,
						Shortcut="LockCamera",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Disable Autojump",
						Tooltip = "Prevents the character from jumping when an object is near",
						Layout = 1,Default=true,
						Shortcut="PreventAutoJump",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Fix Keyboard",
						Tooltip = "Fixes the keyboard so that you can move when you first join",
						Layout = 0,Default=true,
						Shortcut="FixKeyboard",
						Activate = C.ReloadHack,
					},--]]
				},
			},
		}
		
	}
end
