local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local Players = game:GetService("Players")
local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local function Static(C,Settings)
    function C.isInGame(theirChar)
        return theirChar:GetPivot().Y > 0
    end
end

return function (C,Settings)
    Static(C,Settings)

    return {
        Category = {
            Name = "Bloxburg",
            Title = "Bloxburg",
            Image = nil, -- Set Image to nil in order to get game image!
            Layout = 20,
        },
        Tab = {
            {
				Title = "Auto Cook",
				Tooltip = "Automatically pushes the buttons that pop up when you cook.\nCheck delay setting if you get charcoal instead of food for no reason.",
				Layout = 19, Functs = {}, Default=true,
				Shortcut = "AutoCook",
				Activate = function(self,newValue)
                    if not newValue then
                        return
                    end
                    local MainGui = C.StringWait(C.PlayerGui,"MainGUI")
                    local HotbarModule = C.StringWait(C.PlayerScripts,"Modules.HotbarUI")
                    table.insert(self.Functs,HotbarModule.ChildAdded:Connect(function(child)
                        if child:IsA("BindableEvent") and child.Name == "Event" then
                            task.wait(C.Randomizer:NextNumber(self.EnTbl.MinDelay,self.EnTbl.MaxDelay))
                            --[[if not MainGui:FindFirstChild("DefaultButton") then
                                print("NOT FOUND: DEFUALTBUTOTN")
                                return
                            end--]]
                            child:Fire(true)
                        --else
                            --print("Not RUn",child,child.ClassName)
                        end
                    end))
                    if self.EnTbl.HideButtons then
                        table.insert(self.Functs,MainGui.ChildAdded:Connect(function(child)
                            if child.Name == "DefaultButton" then
                                child.Visible = false
                            end
                        end))
                    end
                end,
                Options = {
                    {
						Type = Types.Slider,
						Title = "Min Delay",
						Tooltip = "Delays the completion of the event so that you aren't detected and don't automatically get charcoal!",
						Layout = 0,Default=0.065,
						Min=0.06,Max=0.08,Digits=3,
						Shortcut="MinDelay",
					},
                    {
						Type = Types.Slider,
						Title = "Max Delay",
						Tooltip = "Randomize the completion",
						Layout = 1,Default=0.08,
						Min=0.06,Max=0.08,Digits=3,
						Shortcut="MaxDelay",
					},
                    {
						Type = Types.Toggle,
						Title = "Hide Buttons",
						Tooltip = "Prevents the annoying buttons from appearing that tell you to tap/press a key",
						Layout = 1,Default=true,
						Shortcut="HideButtons",
						Activate = C.ReloadHack,
					},
                }
            },
            {
				Title = "Kick On Staff",
				Tooltip = "Kicks you out of the game if a staff is detected in your game",
				Layout = 20, Threads = {},
				Shortcut = "KickOnStaff",DontActivate=true,
				Activate = function(self,newValue)
                    if not newValue then
                        return
                    end
                    for num, theirPlr in ipairs(Players:GetPlayers()) do
                        if theirPlr ~= C.plr then
                            self.Events.OthersPlayerAdded(self,theirPlr,false)
                        end
                    end
                end,
                Events = {
                    OthersPlayerAdded = function(self,theirPlr,firstRun)
                        local tag
                        while true do
                            tag = theirPlr:GetAttribute("_tag")
                            if tag then
                                break
                            else
                                theirPlr:GetAttributeChangedSignal("_tag"):Wait()
                            end
                        end
                        if (tag < 0 or tag > 2) and (tag<19 or tag>21) then
                            C.plr:Kick(`[KickOnStaff]: You were kicked because {theirPlr.Name} is in the game and has the tag rank of {tag}`)
                        end
                    end
                },
            },
        }
    }
end