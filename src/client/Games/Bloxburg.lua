local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local Players = game:GetService("Players")
local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local function Static(C,Settings)
    C.Stats = C.StringWait(RS,"Stats."..C.plr.Name)
    C.MoodData = C.StringWait(C.Stats,"MoodData")
    local MyGameModules = C.StringWait(C.plr,"PlayerScripts.Modules")
    C.LoadingModule = C.require(MyGameModules:WaitForChild("LoadingHandler"))
    --[[
        .IsLoadingAny() -> boolean
        .ShowLoading()
        .HideLoading()
    ]]
    local RS_Modules = C.StringWait(RS,"Modules")
    local ItemService = C.require(RS_Modules:WaitForChild("ItemService"))
    C.ItemService = ItemService
    function C.isInGame(theirChar)
        local InGame = theirChar:GetPivot().Y > 0 and not C.LoadingModule.IsLoadingAny()
        return InGame, InGame and "Runner" or "Lobby"
    end
    function C.GetPlot(theirChar)
        local Plots = game:GetService("Workspace").Plots
        for num, Plot in ipairs(Plots:GetChildren()) do
            local Ground = C.StringWait(Plot,"_LODModel.Ground")
            if Ground and C.IsInBox(Ground.CFrame,Ground.Size,C.char:GetPivot().Position,true) then
                return Plot
            end
        end
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
				Title = "Mood Boost",
				Tooltip = "Automatically boost moods when your moods get low",
				Layout = 18, Functs = {}, Threads = {}, Default=true,
				Shortcut = "MoodBoost",
                BoostMood = function(self)
                    local info = {Name=self.Shortcut,Title="Boosting Mood",Tags={"RemoveOnDestroy"}}
                    local actionClone = C.AddAction(info)
                    while true do
                        while C.LoadingModule.IsLoadingAny() do
                            task.wait(1)
                        end
                        task.wait(1)
                    end
                end,
                CanBoostMood = function(self)
                    for num, val in ipairs(C.MoodData:GetChildren()) do
                        if val.Value < 70 then
                            return true
                        end
                    end
                end,
				Activate = function(self,newValue)
                    C.RemoveAction(self.Shortcut)
                    if not newValue then
                        return
                    end
                    for num, val in ipairs(C.MoodData:GetChildren()) do
                        table.insert(self.Functs,val:GetPropertyChangedSignal("Value"):Connect(function()
                            if not C.HasAction(self.Shortcut) and self:CanBoostMood() then
                                table.insert(self.Threads,task.spawn(self.BoostMood,self))
                            end
                        end))
                    end
                    if self:CanBoostMood() then
                        self:BoostMood()
                    end
                end,
            },
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
                            task.wait(C.Randomizer:NextNumber(C.GetMinMax(self.EnTbl.MinDelay,self.EnTbl.MaxDelay)))
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
                        if (tag<19 or tag>21) then--(tag < 0 or tag > 2) and (tag<19 or tag>21) then
                            C.plr:Kick(`[KickOnStaff]: You were kicked because {theirPlr.Name} is in the game and has the tag rank of {tag}`)
                        end
                    end
                },
            },
        }
    }
end