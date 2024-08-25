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
        .TriggerFaint() -> (faints user)
        .Detach()
        :SendDetach()
    ]]
    C.HotbarUI = C.require(MyGameModules:WaitForChild("HotbarUI"))
    --[[
        :ToHouse() -> Teleports to your plot/house
        :ToPlot((Player) PlayersPlot)
    ]]
    C.JobHandler = C.require(MyGameModules:WaitForChild("JobHandler"))
    --[[
        :CanStartWorking((string) JOB_NAME) -> returns true/false, (table) module, (table) reward
        :GoToJob((string) JOB_NAME)
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
    function C.IsBusy()
        return C.LoadingModule:IsLoadingAny() or not C.MainGui:WaitForChild("IsLoaded").Value
            or C.MainGui:WaitForChild("MainMenu").Visible
    end
    function C.GetWorkstation(Workstations)
        --game:GetService("Workspace").Environment.Locations.Supermarket.CashierWorkstations
        local curObj, closestDist = nil, math.huge
        for num, workstation in ipairs(Workstations:GetChildren()) do
            if workstation.Name == "Workstation" and not workstation.InUse.Value then
                local myDist = (C.hrp:GetPivot().Position - workstation:GetPivot().Position)
                if myDist < closestDist then
                    curObj, closestDist = workstation,myDist
                end
            end
        end
        return curObj,closestDist
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
				Title = "Auto Job",
				Tooltip = "Automatically does the selected job.",
				Layout = 19, Functs = {}, Threads = {}, Default=true,
				Shortcut = "AutoJob",
                BotData = {
                    HutFisherman = {
                        Location = {CFrame = CFrame.new(1080,12.5,1097) * CFrame.Angles(0,math.rad(180),0), Size = Vector3.new(20,1,6)},
                        BotFunct = function(self,model,actionClone)
                            local EquipData = C.HotbarUI.Hotbar.EquipData
                            local ItemData = EquipData and C.HotbarUI.Hotbar.EquipData.ItemData
                            if C.AngleOffFrom2CFrames(C.char:GetPivot(),self.Location.CFrame) > 30 then
                                return "Teleport"
                            end
                            if EquipData and ItemData then
                                if ItemData.Name == "Fishing Rod" then
                                    local Title = EquipData.Title
                                    if Title then
                                        Title = Title:gsub("%a_","")--Some start with I_ because gay!
                                        if Title == "Cast" then
                                            actionClone.Time.Text = "Casting"
                                            task.spawn(C.HotbarUI.Hotbar.DoEquipAction,C.HotbarUI.Hotbar)
                                        elseif Title == "Pull" then
                                            if EquipData.Object.Pos.Value.Y <= 7.7 then
                                                actionClone.Time.Text = "Pulling"
                                                task.spawn(C.HotbarUI.Hotbar.DoEquipAction,C.HotbarUI.Hotbar)
                                            else
                                                actionClone.Time.Text = "Waiting"
                                            end
                                        else
                                            actionClone.Time.Text = ""
                                        end
                                        return true
                                    end
                                end
                            end
                            return false
                        end,
                    },
                    SupermarketStocker = {
                        Overrides = {{"Noclip"}},Part = "Floor",
                        BotFunct = function(self,model,actionClone)
                            -- Has a Food Crate
                            if not C.HotbarUI.Hotbar.EquipData or C.HotbarUI.Hotbar.EquipData.Name ~= "Food Crate" then
                                local closest,closestDist = nil, math.huge
                                for num, crate in ipairs(model:WaitForChild("Crates"):GetChildren()) do
                                    if crate.Name == "Crate" then
                                        local curDist = (crate:GetPivot().Position - C.char:GetPivot().Position).Magnitude
                                        if curDist < closestDist then
                                            closest,closestDist = crate, curDist
                                        end
                                    end
                                end
                                if closest then
                                    if closestDist < 10 then
                                        actionClone.Time.Text = "Firing"
                                        C.RemoteObjects["TakeFoodCrate"]:FireServer({Object=closest})
                                        C.human:MoveTo(C.char:GetPivot().Position)
                                        return "Wait", 0
                                    else
                                        actionClone.Time.Text = "Walking"
                                        C.human:MoveTo(closest:GetPivot().Position)
                                        return true
                                    end
                                else
                                    actionClone.Time.Text = "No Resupply Crates"
                                end
                            else -- Has No Food Crate
                                local closest2, closestDist2 = nil, math.huge
                                for num, shelve in ipairs(model:WaitForChild("Shelves"):GetChildren()) do
                                    local curDist = (shelve:GetPivot().Position - C.char:GetPivot().Position).Magnitude
                                    if shelve:WaitForChild("IsEmpty").Value and curDist < closestDist2 then
                                        closest2,closestDist2 = shelve, curDist
                                    end
                                end
                                if closest2 then
                                    if closestDist2 < 10 then
                                        actionClone.Time.Text = "Firing2"
                                        C.RemoteObjects["RestockShelf"]:FireServer({Shelf = closest2})
                                        C.human:MoveTo(C.char:GetPivot().Position)
                                        return "Wait", 0
                                    else
                                        C.human:MoveTo(closest2:GetPivot()*Vector3.new(0,0,3))
                                        actionClone.Time.Text = "Walking2"
                                        return true
                                    end
                                else
                                    actionClone.Time.Text = "No Empty Shelves"
                                end
                            end
                            C.human:MoveTo(C.char:GetPivot().Position)
                        end,
                    },
                    SupermarketCashier = {
                        Workstations = {Path="CashierWorkstations",Part="Scanner",PartOffset=Vector3.new(0,-1,-3)},
                        BotFunct = function(self, model, actionClone, myWorkstation)
                            if #myWorkstation.DroppedFood:GetChildren() > 0 then
                                local curBagCount = 0
                                for num, bag in ipairs(myWorkstation.Bags:GetChildren()) do
                                    local curCount = #bag:GetChildren() - 1 -- One instance in the Mesh instance!
                                    if bag.Transparency < 1e-3 and #bag:GetChildren() - 1 < 3 then
                                        curBagCount = curCount
                                        break
                                    end
                                end
                                if curBagCount > 0 then
                                    for num, instance in ipairs(myWorkstation.DroppedFood:GetChildren()) do
                                        if num <= 3 - curBagCount then
                                            actionClone.Time.Text = "Scanning "..instance.Name
                                            C.RemoteObjects["ScanDroppedItem"]:FireServer({Item=instance})
                                        else
                                            break
                                        end
                                    end
                                    return "Wait", 0
                                else
                                    C.RemoteObjects["TakeNewBag"]:FireServer(myWorkstation)
                                    actionClone.Time.Text = "Getting Bag"
                                    return "Wait", 0
                                end
                            else
                                actionClone.Time.Text = "No Food"
                            end
                        end,
                    },
                },
                GetClosestWorkstation = function(self,botData,jobModule)
                    local WData = botData.Workstations
                    local Workstations = C.StringWait(jobModule.Model,WData.Path)

                    local closest,closestDist = nil,math.huge
                    for num, workstation in ipairs(Workstations:GetChildren()) do
                        if workstation.InUse.Value == nil or workstation.InUse.Value == C.plr then
                            local curDist = (workstation:GetPivot().Position - C.char:GetPivot().Position).Magnitude
                            if curDist < closestDist then
                                closest, closestDist = workstation, curDist
                            end
                        end
                    end
                    if closest then
                        C.DoTeleport(closest:GetBoundingBox().Position)
                        return true, closest, closestDist
                    else
                        return false, "Not Found"
                    end
                end,
                JobRunner = function(self,jobName)
                    local displayJobName = jobName:gsub("%a+ ","")
                    local botData = self.BotData[jobName]
                    local jobHandler = C.JobHandler
                    local jobModule = C.require(C.StringWait(C.plr,"PlayerScripts.Modules.JobHandler."..jobName))
                    
                    if botData.Part then
                        local instance = jobModule.Model:WaitForChild(botData.Part)
                        botData.Location = {CFrame = instance.CFrame, Size = instance.Size}
                    end

                    local info = {Name=self.Shortcut,Title="Job: "..displayJobName,Tags={"RemoveOnDestroy"},Stop=function(requested)
                        if requested then
                            task.spawn(self.SetValue,self,false)
                        end
                        for num, data in ipairs(botData.Overrides or {}) do
                            C.RemoveOverride(C.hackData.Blatant[data[1]],self.Shortcut)
                        end
                    end}
                    local lastCurJob
                    local actionClone = C.AddAction(info)
                    local myWorkstation
                    local function TeleportToStation()
                        actionClone.Time.Text = "Going To Station"
                        
                        C.DoTeleport(botData.Location.CFrame.Rotation + C.RandomPointOnPart(botData.Location.CFrame,botData.Location.Size))
                    end
                    while info.Enabled do
                        while C.IsBusy() do
                            if info.Enabled then
                                actionClone.Time.Text = "Busy"
                            end
                            task.wait(1)
                        end
                        actionClone = actionClone or C.AddAction(info)
                        while C.char and not C.IsBusy() and (jobHandler:GetJob() ~= jobName
                            or (botData.Location and (botData.Location.CFrame.Position - C.char:GetPivot().Position).Magnitude > 500)) do
                            if jobHandler:GetJob() then
                                jobHandler:StopWorking()
                            end
                            if jobHandler:CanStartWorking(jobName,jobModule) then
                                actionClone.Time.Text = "Going To Work"
                                jobHandler:GoToWork(jobName)
                            else
                                actionClone.Time.Text = "Waiting"
                            end
                            task.wait(.5)
                        end
                        local curJob = jobHandler:GetJob()
                        local Return,Return2
                        if jobHandler:GetJob() == jobName then
                            if lastCurJob ~= jobName then
                                lastCurJob = jobName
                                for num, data in ipairs(botData.Overrides or {}) do
                                    C.AddOverride(C.hackData.Blatant[data[1]],self.Shortcut)
                                end
                            end
                            if botData.Location and not C.IsInBox(botData.Location.CFrame,botData.Location.Size,C.char:GetPivot().Position,true) then
                                TeleportToStation()
                            elseif botData.Workstations and (not myWorkstation or not C.IsInBox(myWorkstation:GetBoundingBox(),myWorkstation:GetExtentsSize(),C.char:GetPivot().Position,true)) then
                                Return, Return2 = self:GetClosestWorkstation(botData,jobModule)
                                if Return then
                                    myWorkstation = Return2
                                    Return, Return2 = "Wait", 0
                                end
                            else
                                Return, Return2 = botData:BotFunct(jobModule.Model,actionClone,myWorkstation)
                                if Return == "Teleport" then
                                    TeleportToStation()
                                end
                            end
                        end
                        if Return == "Wait" then
                            task.wait(Return2)
                        else
                            task.wait(.25)
                        end
                    end
                    C.RemoveAction(self.Shortcut)
                end,
				Activate = function(self,newValue)
                    C.RemoveAction(self.Shortcut)
                    if not newValue then
                        return
                    end
                    self:JobRunner(self.EnTbl.SelJob:gsub(" ",""))
                end,
                Options = {
                    {
						Type = Types.Dropdown, Selections = {"Hut Fisherman","Supermarket Stocker","Supermarket Cashier"},
						Title = "Job",
						Tooltip = "Which job the autofarm does. Some may be unavilable",
						Layout = 1,
						Shortcut="SelJob",
						Activate = C.ReloadHack
					},
                },
            },
            {
				Title = "Mood Boost",
				Tooltip = "Automatically boost moods when your moods get low",
				Layout = 16, Functs = {}, Threads = {}, Default=true,
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
                            --print(C.HotbarUI.Hotbar.EquipData)
                            --MeshId == "rbxassetid://485263557"
                            if C.HotbarUI.Hotbar.EquipData and C.HotbarUI.Hotbar.EquipData.ItemData
                                and table.find(C.HotbarUI.Hotbar.EquipData.ItemData.Types,"Food") and C.HotbarUI.Hotbar.EquipData.HoldFunction then
                                C.HotbarUI.Hotbar:DoEquipAction()
                                print("Run")
                            elseif not Object.ObjectData.IsOn.Value then
                                print("Water",Object)
                                C.FireServer("Interact",{Target=Object,Path=3})
                            else
                                print("Nothing?")
                            end
                        end
                    end,
                },
                BoostMood = function(self)
                    local info = {Name=self.Shortcut,Title="Boosting Mood",Tags={"RemoveOnDestroy"},Stop=function(requested)
                        if requested then
                            task.spawn(self.SetValue,self,false)
                        end
                    end}
                    local MoodName,MoodValue
                    local actionClone = C.AddAction(info)
                    while info.Enabled do
                        while C.IsBusy() do
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
				Title = "Anti Faint",
				Tooltip = "Prevents you from being teleported when you faint",
				Layout = 18, Functs = {}, Threads = {}, Default=true,
                OldFaintFunct = nil,
				Shortcut = "AntiFaint",
                RunOnDestroy = function(self)
                    self:Activate(false)
                end,
                Activate = function(self,newValue)
                    if newValue and not self.OldFaintFunct then
                        self.OldFaintFunct = rawget(C.CharacterHandler,"TriggerFaint")
                        rawset(C.CharacterHandler,"TriggerFaint",function()
                            for num, animationTrack in ipairs(C.human:WaitForChild("Animator"):GetPlayingAnimationTracks()) do
                                if animationTrack.Animation.AnimationId == "rbxassetid://14689212702" then
                                    animationTrack:Stop(0)
                                end
                            end
                        end)
                    elseif not newValue and self.OldFaintFunct then
                        rawset(C.CharacterHandler,"TriggerFaint",self.OldFaintFunct)
                        self.OldFaintFunct = nil
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
                        if (tag<19 or tag>21) and tag ~= 2 and tag ~= 14 then--(tag < 0 or tag > 2) and (tag<19 or tag>21) then
                            C.plr:Kick(`[KickOnStaff]: You were kicked because {theirPlr.Name} is in the game and has the tag rank of {tag}`)
                        end
                    end
                },
            },
        }
    }
end