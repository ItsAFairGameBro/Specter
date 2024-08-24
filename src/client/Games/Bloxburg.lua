local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local Players = game:GetService("Players")
local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local function Static(C,Settings)
    C.Stats = C.StringWait(RS,"Stats."..C.plr.Name)
    C.MoodData = C.StringWait(C.Stats,"MoodData")
    C.MainGui = C.StringWait(C.PlayerGui,"MainGUI")
    local MyGameModules = C.StringWait(C.plr,"PlayerScripts.Modules")
    C.LoadingModule = C.require(MyGameModules:WaitForChild("LoadingHandler"))
    --[[
        .IsLoadingAny() -> boolean
        .ShowLoading()
        .HideLoading()
    ]]
    C.CharacterHandler = C.require(MyGameModules:WaitForChild("CharacterHandler"))
    --[[
        .Attached -> Signal Event
        .CharacterChanged -> Signal Event
        .FloorMaterial -> Enum.Material
        .FloorHit -> BasePart
        .Detach()
        :SendDetach()
    ]]
    C.HotbarUI = C.require(MyGameModules:WaitForChild("HotbarUI"))
    --[[
        :ToHouse() -> Teleports to your plot/house
    ]]
    local RS_Modules = C.StringWait(RS,"Modules")
    local ItemService = C.require(RS_Modules:WaitForChild("ItemService"))
    --[[
        :GetItemFromObject(OBJECT) -> data {}

        print(getgenv().C.ItemService:GetItemFromObject())
    ]]
    C.ItemService = ItemService
    function C.isInGame(theirChar)
        local InGame = theirChar:GetPivot().Y > 0 and not C.LoadingModule.IsLoadingAny()
        return InGame, InGame and "Runner" or "Lobby"
    end
    function C.GetPlot(theirChar)
        theirChar = theirChar or C.char
        local Plots = workspace:WaitForChild("Plots")
        for num, Plot in ipairs(Plots:GetChildren()) do
            local Ground = C.StringFind(Plot,"_LODModel.Ground") or C.StringFind(Plot,"Ground")
            if Ground and C.IsInBox(Ground.CFrame,Ground.Size + 6 * 2 *Vector3.new(1,0,1),theirChar:GetPivot().Position,true) then
                return Plot
            end
        end
    end
    function C.GetClosestObject(Plot,Type)
        local Objects = Plot and C.StringFind(Plot,"House.Objects")
        if not Objects then
            return
        end
        local bestObj, nearest = nil, 500
        local function DoSort(object)
            local ObjectModel = object:FindFirstChild("ObjectModel")
            if ObjectModel then
                local Data = C.ItemService:GetItemFromObject(object)
                if Data and table.find(Data.Types,Type) then
                    local dist = (ObjectModel:GetPivot().Position - C.char:GetPivot().Position).Magnitude
                    if dist < nearest then
                        bestObj, nearest = object,dist
                    end
                end
            end
        end
        local function DoLoop(loopObject)
            for num, object in ipairs(loopObject:GetChildren()) do
                DoSort(object)
                local ItemHolder = object:FindFirstChild("ItemHolder")
                if ItemHolder then
                    DoLoop(ItemHolder)
                end
            end
        end
        DoLoop(Objects)
        return bestObj, nearest
    end
    function C.FireServer(name,...)
        C.RemoteObjects[name]:FireServer(...)
    end
    table.insert(C.EventFunctions,function()
        C.Attachment = C.StringFind(C.char,"HumanoidRootPart.AttachWeld")
        C.AddGlobalConnection(C.CharacterHandler.Attached:Connect(function(enabled,attachment)
            C.Attachment = enabled and C.StringFind(C.char,"HumanoidRootPart.AttachWeld") or nil
        end))
        C.events["MyCharAdded"] = C.events["MyCharAdded"] or {}
        C.events["MyCharAdded"]["GameFunct"] = function(theirPlr,theirChar,firstRun)
            C.CharFocusValue = C.StringWait(theirChar,"HumanoidRootPart.CharFocus")
            C.CharFocus = C.CharFocusValue.Value
            C.AddObjectConnection(C.CharFocusValue,"BloxburgCharFocus",C.CharFocusValue:GetPropertyChangedSignal("Value"):Connect(function()
                C.CharFocus = C.CharFocusValue.Value
            end))
        end
    end)

    --[[task.delay(2,function()
        warn("CLOSEST",C.GetClosestObject(C.GetPlot(C.plr.Character),"Shower"))
    end)--]]
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
                MoodBoostFunctions = {
                    Hygiene = function(self,plot)
                        local Object, Distance = C.GetClosestObject(plot,"Shower")
                        if Object and (C.Attachment and Object:IsAncestorOf(C.Attachment.Part1)) then
                            return
                        end
                        if Object and (Distance > 10000) then
                            if C.Attachment then
                                C.CharacterHandler:SendDetach()
                            end
                            C.DoTeleport(Object.ObjectModel:GetPivot().Position + Vector3.new(0,C.getHumanoidHeight(C.char),0))
                        else
                            C.FireServer("Interact",{Target=Object,Path=1})
                        end
                    end,
                    Energy = function(self,plot)
                        local Object, Distance = C.GetClosestObject(plot,"Comfort")
                        if Object and (C.Attachment and Object:IsAncestorOf(C.Attachment.Part1)) then
                            return
                        end
                        if Object and (Distance > 10000) then
                            if C.Attachment then
                                C.CharacterHandler:SendDetach()
                            end
                            C.DoTeleport(Object.ObjectModel:GetPivot().Position + Vector3.new(0,C.getHumanoidHeight(C.char),0))
                        else
                            C.FireServer("Interact",{Target=Object,Path=1})
                        end
                    end,
                    Fun = function(self,plot)
                        local Object, Distance = C.GetClosestObject(plot,"TV")
                        if Object and (C.Attachment and Object:IsAncestorOf(C.Attachment.Part1)) then
                            return
                        end
                        if Object and (Distance > 10000) then
                            if C.Attachment then
                                C.CharacterHandler:SendDetach()
                            end
                            C.DoTeleport(Object.ObjectModel:GetPivot() * Vector3.new(0,0,-6) + Vector3.new(0,C.getHumanoidHeight(C.char),0))
                        else
                            if not Object.ObjectData.IsOn.Value then
                                -- Turn on the TV
                                C.FireServer("Interact",{Target=Object,Path=1})
                            else
                                -- Check to see if we're watching
                                local isWatching = Object:IsAncestorOf(C.CharFocus)--[[false
                                for num, attachVal in ipairs(Object:GetChildren()) do
                                    if attachVal.Name == "_attachOccupied" then
                                        if attachVal:IsA("ObjectValue") and attachVal.Value == C.plr then
                                            isWatching = true
                                            break
                                        end
                                    end
                                end--]]
                                if not isWatching then
                                    -- Watch the TV
                                    C.FireServer("Interact",{Target=Object,Path=2})
                                end
                            end
                        end
                    end,
                    Hunger = function(self,plot)
                        local Object, Distance = C.GetClosestObject(plot,"Sink")
                        if Object and (C.Attachment and Object:IsAncestorOf(C.Attachment.Part1)) then
                            return
                        end
                        if Object and (Distance > 10000) then
                            if C.Attachment then
                                C.CharacterHandler:SendDetach()
                            end
                            C.DoTeleport(Object.ObjectModel:GetPivot() * Vector3.new(0,0,-6) + Vector3.new(0,C.getHumanoidHeight(C.char),0))
                        else
                            print(C.HotbarUI.Hotbar.EquipData)
                            if C.HotbarUI.Hotbar.EquipData and C.HotbarUI.Hotbar.EquipData.ItemData
                                and table.find(C.HotbarUI.Hotbar.EquipData.ItemData.Types,"Food") and C.HotbarUI.Hotbar.EquipData.HoldFunction then
                                C.HotbarUI.Hotbar:DoEquipAction()
                                print("Run")
                            elseif not Object.ObjectData.IsOn.Value then
                                print("Water")
                                C.FireServer("Interact",{Target=Object,Path=3})
                            end
                        end
                    end,
                },
                BoostMood = function(self)
                    local info = {Name=self.Shortcut,Title="Boosting Mood",Tags={"RemoveOnDestroy"},Stop=function(requested)
                        if requested then
                            self:SetValue(false)
                        end
                    end}
                    local MoodName,MoodValue
                    local actionClone = C.AddAction(info)
                    while true do
                        while C.LoadingModule.IsLoadingAny() or not C.MainGui:WaitForChild("IsLoaded").Value do
                            task.wait(1)
                        end
                        local Plot = C.GetPlot()
                        if not Plot then
                            actionClone.Time.Text = "Teleporting"
                            -- HotbarUI Yields, so no wait
                            C.HotbarUI:ToHouse()
                        else
                            local values2Fix = {}
                            for num, val in ipairs(C.MoodData:GetChildren()) do
                                if val.Value < 95 then
                                    table.insert(values2Fix,val)
                                end
                            end
                            table.sort(values2Fix,function(a,b)
                                return a.Value < b.Value
                            end)
                            if not MoodValue or not table.find(values2Fix,MoodValue) then
                                if values2Fix[1] then
                                    MoodValue = values2Fix[1]
                                    MoodName = values2Fix[1].Name
                                    actionClone.Title.Text = "Boosting " .. MoodName
                                else
                                    break
                                end
                            end
                            self.MoodBoostFunctions[MoodName](self,Plot)
                            C.SetActionPercentage(actionClone,MoodValue.Value/100)
                            task.wait(1/2)
                        end
                    end
                    if info.Enabled then
                        C.RemoveAction(self.Shortcut)
                        if C.Attachment then
                            C.CharacterHandler:SendDetach()
                        end
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
                    --[[for num, val in ipairs(C.MoodData:GetChildren()) do
                        table.insert(self.Functs,val:GetPropertyChangedSignal("Value"):Connect(function()
                            print("Value:",val)
                            if not C.GetAction(self.Shortcut) and self:CanBoostMood() then
                                table.insert(self.Threads,task.spawn(self.BoostMood,self))
                            end
                        end))
                    end--]]
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