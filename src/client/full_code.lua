--print("Begin Loading Main")

local PS = game:GetService("Players")
local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local HS = game:GetService("HttpService")
local CG = game:GetService("CoreGui")
local SP = game:GetService("StarterPlayer")
local MPS = game:GetService("MarketplaceService")
local TextChatService = game:GetService("TextChatService")
local VirtualUser = game:GetService("VirtualUser")

--print("services loaded")

local PreCached = true
local isStudio = RunS:IsStudio()
local PrintName = "[Module Loader]"

if isStudio then
	task.wait(3 - time())
end

local C = {}
local allDisabled = {
	firetouchinterest = false,
}
local executorName = not isStudio and identifyexecutor()
local enExecutor = (isStudio and allDisabled) or (executorName=="Cryptic" and {firetouchinterest=true}) or {firetouchinterest=true}
C.Executor = executorName
--print("1")
local function RegisterFunctions()
	local firetouchinterest = firetouchinterest
	if not enExecutor.firetouchinterest or not firetouchinterest then

		firetouchinterest = function(part1,part2,number)--creates a fake touch function
			local thread
			thread = task.spawn(function(dt)
				C.SetPartProperty(part2,"CanCollide","firetouchinterest",false)
				C.SetPartProperty(part2,"Transparency","firetouchinterest",1)
				C.SetPartProperty(part2,"Size","firetouchinterest",Vector3.one * 1e3)
				C.SetPartProperty(part2,"CFrame","firetouchinterest",part1:GetPivot() * CFrame.new(Vector3.new(0,0,-2)+part1.AssemblyLinearVelocity/60))
				C.SetPartProperty(part2,"Anchored","firetouchinterest",false)
				local touching = 0
				while true do
					if table.find(part2:GetTouchingParts(), part1) then
						touching+=1
						if touching==4 then break end
					else
						touching = 0
					end
					part2.AssemblyLinearVelocity = (part1.Position - part2.Position) * 60 --* (6*(1+part1.AssemblyLinearVelocity.Magnitude))
					RunS.PreSimulation:Wait()
				end
				C.ResetPartProperty(part2,"CanCollide","firetouchinterest")
				C.ResetPartProperty(part2,"Transparency","firetouchinterest")
				C.ResetPartProperty(part2,"Size","firetouchinterest")
				C.ResetPartProperty(part2,"CFrame","firetouchinterest")
				C.ResetPartProperty(part2,"Anchored","firetouchinterest")
			end)
			C.StopThread(thread)
		end
	end
	--Generic Functions
	function C.yieldForeverFunct()
		game:WaitForChild("SuckMyPPOrYoureGay",math.huge)
	end
	--Studio Functions
	C.checkcaller = isStudio and (function() return true end) or checkcaller
	C.getconnections = isStudio and (function(signal) return {} end) or getconnections
	C.getrenv = isStudio and function() return _G end or getrenv
	C.getgenv = isStudio and function() return _G end or getgenv
	C.getsenv = isStudio and (function() return {} end) or getsenv
	C.getgc = isStudio and function () return {} end or getgc
	C.loadstring = isStudio and function() return function() end end or loadstring
	C.getnamecallmethod = isStudio and (function() return "" end) or getnamecallmethod
	C.getcallingscript = isStudio and (function() return nil end) or getcallingscript
	C.hookfunction = isStudio and function(a,b) return C.checkcaller end or hookfunction
	C.hookmetamethod = isStudio and function() return end or hookmetamethod
	C.newcclosure = isStudio and function(funct) return funct end or newcclosure
	C.gethui = isStudio and function() return C.PlayerGui end or gethui
	C.firetouchinterest = function(part1,part2,number)
		if not firetouchinterest then
			return
		end
		local CanTouch1, CanTouch2 = part1.CanTouch, part2.CanTouch
		part1.CanTouch, part2.CanTouch = true, true
		if part1.Parent and part2.Parent then
			if number then
				pcall(firetouchinterest,part1,part2,number)
			else
				pcall(firetouchinterest,part1,part2,0)
				task.spawn(pcall,firetouchinterest,part1,part2,1)
			end
		end
		part1.CanTouch, part2.CanTouch = CanTouch1, CanTouch2
	end
	local keyCodeMap = {
		[Enum.KeyCode.A] = "0x41",
		[Enum.KeyCode.B] = "0x42",
		[Enum.KeyCode.C] = "0x43",
		[Enum.KeyCode.D] = "0x44",
		[Enum.KeyCode.E] = "0x45",
		[Enum.KeyCode.F] = "0x46",
		[Enum.KeyCode.G] = "0x47",
		[Enum.KeyCode.H] = "0x48",
		[Enum.KeyCode.I] = "0x49",
		[Enum.KeyCode.J] = "0x4A",
		[Enum.KeyCode.K] = "0x4B",
		[Enum.KeyCode.L] = "0x4C",
		[Enum.KeyCode.M] = "0x4D",
		[Enum.KeyCode.N] = "0x4E",
		[Enum.KeyCode.O] = "0x4F",
		[Enum.KeyCode.P] = "0x50",
		[Enum.KeyCode.Q] = "0x51",
		[Enum.KeyCode.R] = "0x52",
		[Enum.KeyCode.S] = "0x53",
		[Enum.KeyCode.T] = "0x54",
		[Enum.KeyCode.U] = "0x55",
		[Enum.KeyCode.V] = "0x56",
		[Enum.KeyCode.W] = "0x57",
		[Enum.KeyCode.X] = "0x58",
		[Enum.KeyCode.Y] = "0x59",
		[Enum.KeyCode.Z] = "0x5A",
		[Enum.KeyCode.Space] = "0x20",
		[Enum.KeyCode.LeftShift] = "0xA0",
		[Enum.KeyCode.RightShift] = "0xA1",
		[Enum.KeyCode.LeftControl] = "0xA2",
		[Enum.KeyCode.RightControl] = "0xA3",
		[Enum.KeyCode.LeftAlt] = "0xA4",
		[Enum.KeyCode.RightAlt] = "0xA5",
		[Enum.KeyCode.Escape] = "0x1B",
		[Enum.KeyCode.Return] = "0x0D",
		[Enum.KeyCode.Backspace] = "0x08",
		[Enum.KeyCode.Tab] = "0x09",
		-- Add more mappings as needed
	}
	function C.firekey(keyCode: Enum.KeyCode,enabled: boolean | nil)
		local virtualKeyCode = keyCodeMap[keyCode]

		if virtualKeyCode then
			if enabled then
				VirtualUser:SetKeyDown(virtualKeyCode)
			elseif enabled == false then
				VirtualUser:SetKeyUp(virtualKeyCode)
			else
				VirtualUser:SetKeyDown(virtualKeyCode)
				RunS.RenderStepped:Wait()
				VirtualUser:SetKeyUp(virtualKeyCode)
			end
		else
			warn("KeyCode not mapped: " .. tostring(keyCode))
		end
	end
	C.fireclickdetector = isStudio and function() return end or fireclickdetector
	function C.firesignal(Signal, ...)
		for num, mySignal in ipairs(C.getconnections(Signal)) do
			local Enabled = mySignal.Enable
			if not Enabled then
				mySignal:Enable()
			end
			mySignal:Fire(...)
			if not Enabled then
				mySignal:Disable()
			end
		end
	end
	function C.fireproximityprompt(ProximityPrompt, Amount, Skip)
		assert(ProximityPrompt, "Argument #1 Missing or nil")
		assert(typeof(ProximityPrompt) == "Instance" and ProximityPrompt:IsA("ProximityPrompt"), "Attempted to fire a Value that is not a ProximityPrompt")

		local HoldDuration = ProximityPrompt.HoldDuration
		if Skip then
			ProximityPrompt.HoldDuration = 0
		end

		for i = 1, Amount or 1 do
			ProximityPrompt:InputHoldBegin()
			if Skip then
				local Start = os.clock()
				repeat
					RunS.Heartbeat:Wait()
				until os.clock() - Start > HoldDuration
			end
			ProximityPrompt:InputHoldEnd()
		end
		ProximityPrompt.HoldDuration = HoldDuration
	end
	C.setclipboard = isStudio and function() return end or function(input: string, notifyMsg: string)
		setclipboard(tostring(input))
        C.AddNotification(`Copied{notifyMsg and " " .. notifyMsg or ""}`,`Successfully copied to clipboard!`)
	end
	C.getloadedmodules = isStudio and function() return {C.PlayerScripts.PlayerModule.ControlModule} end or getloadedmodules
	C.getrunningscripts = isStudio and function () return {} end or getrunningscripts
	C.getinstances = isStudio and function () return game:GetDescendants() end or getinstances
	C.request = not isStudio and request
	C.isfolder = not isStudio and isfolder
	C.readfile = not isStudio and readfile
	C.isfile = not isStudio and isfile
	C.makefolder = not isStudio and makefolder
	C.writefile = not isStudio and writefile
	C.setscriptable = not isStudio and setscriptable
	C.request = isStudio and function() end or request
	local requireFunctsToRun = isStudio and {require} or {getrenv().require,require,getsenv}
	function C.require(ModuleScript: Script)
		local success, result
		for num, funct in ipairs(requireFunctsToRun) do
			success, result = pcall(funct,ModuleScript)
			if result ~= "Cannot require a non-RobloxScript module from a RobloxScript" then
				break
			end
		end
		if not success then
			warn("[Specter C.require]: Failed To Load Module "..tostring(ModuleScript)..": "..tostring(result))
			C.yieldForeverFunct()
		end
		return result
	end

	--Important In-Game Functions
	function C.GenerateGUID()
		return HS:GenerateGUID(false)
	end
end

RegisterFunctions() -- Loads Studio and Hack Compatiblity

C.isStudio = isStudio
C.plr = PS.LocalPlayer
C.StartUp = true
if C.getgenv().Defaults then
	C.Defaults = C.getgenv().Defaults
else
	C.Defaults = {WalkSpeed = SP.CharacterWalkSpeed, JumpPower = SP.CharacterJumpPower, Gravity = workspace.Gravity,
		Username = C.plr.Name,DisplayName = C.plr.DisplayName, AutoJumpEnabled = SP.AutoJumpEnabled}
	C.getgenv().Defaults = C.Defaults
end
C.HighestNumber = 2^63-1 -- Largest integer possible
C.PlayerGui = C.plr:WaitForChild("PlayerGui")
task.spawn(function()
	C.PlayerScripts = C.plr:WaitForChild("PlayerScripts",100)
end)
C.BaseUrl = "https://github.com/ItsAFairGameBro/Specter/%s/main/src/client"
if C.getgenv().enHacks then
	C.enHacks = C.getgenv().enHacks
else
	C.enHacks = {}
	C.getgenv().enHacks = C.enHacks
end
C.getgenv().ProfileId = C.getgenv().ProfileId or ""
C.getgenv().AlreadyRanScripts = C.getgenv().AlreadyRanScripts or {}
C.hackData = {}
C.events = {}
C.keybinds = {}
C.functs, C.threads = {}, {} -- global connections/threads
C.instances = {} -- global instances
C.friends = {}
C.playerfuncts = {} -- player connections
C.objectfuncts = {} -- instance connections
C.preloadedModule = {
    ["Games/Bloxburg"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

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
        local function RegisterGUIChild(child)
            if child:IsA("ScreenGui") and child.Name == "_MessageBox" then
                C.FireEvent("MessageBoxAdded",nil,child)
            end
        end
        C.AddObjectConnection(C.PlayerGui,"Game: Bloxburg",C.PlayerGui.ChildAdded:Connect(RegisterGUIChild))
        for num, child in ipairs(C.PlayerGui:GetChildren()) do
            RegisterGUIChild(child)
        end
    end)
    table.insert(C.InsertCommandFunctions,function()
        return {
            ["donate"] = {
                Parameters={{Type="Player",ExcludeMe=true},{Type="Number",Min=1,Max=50000,Step=1}},
                AfterTxt = " $%.2f",
                Run = function(self,args)
                    local DonatePerms = C.StringFind(RS,`Stats.{args[1][1].Name}.Options.DonatePermission`)
                    if not DonatePerms then
                        return false, "Player Stats Not Found"
                    end
                    if DonatePerms.Value == 1 and not C.plr:IsFriendsWith(args[1][1].UserId) then
                        return false, `{args[1][1].Name} has donate set to friends only!`
                    end
                    if DonatePerms.Value == 2 then
                        return false, `{args[1][1].Name} has donate set to off!`
                    end
                    local Event = Instance.new("BindableEvent")
                    C.AddGlobalInstance(Event)
                    C.AddObjectConnection(Event,"One",C.RemoteObjects.DonationSent.OnClientEvent:Connect(function()
                        Event:Fire(true)
                    end))
                    local AmountLeft = args[2]
                    local Step = AmountLeft
                    for event, name in pairs(C.RemoteNames) do
                        if name == "CreateGUI" then
                            warn(event, "Found:",name,event.ClassName)
                            if event.ClassName == "RemoteEvent" then
                                C.AddObjectConnection(Event,"Two",event.OnClientEvent:Connect(function(data)
                                    local val = data.Args[2]:gsub("T_",""):gsub("(%u)(%u%l+)", "%1 %2"):gsub("(%l)(%u)", "%1 %2")
                                    C.CreateSysMessage(`Donation To {args[1][1].Name} Of {Step} Failed: {val}`)
                                    Event:Fire(val)
                                end))
                            end
                        end
                    end
                    local Count = 0
                    local DonateEvent = C.RemoteObjects.Donate
                    while true do
                        print("Set",Step)
                        task.delay(.1,DonateEvent.FireServer, DonateEvent,
                            {
                                Player = args[1][1],
                                Action = "Donate",
                                Amount = Step,
                            }
                        )
                        local Result = Event.Event:Wait()
                        if Result == true then
                            AmountLeft -= Step
                            if AmountLeft <= 0 then
                                break
                            end
                        elseif Result == "Donation Limited" then
                            Step = math.floor(Step/10)
                        else
                            warn("[Bloxburg.Donate]: unknown error: "..Result)
                            break
                        end
                        print("Result",Result)
                        Count+=1
                        if Count == 10 then
                            print("Count Reached")
                            break
                        elseif Step == 0 then
                            break
                        end
                        Step = math.clamp(Step,0,AmountLeft)
                        task.wait(2/3)
                    end
                    Event:Destroy()
                    return true, args[2] - AmountLeft
                end,
            }
        }
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
                                            C.SetActionLabel(actionClone,"Casting")
                                            task.spawn(C.HotbarUI.Hotbar.DoEquipAction,C.HotbarUI.Hotbar)
                                        elseif Title == "Pull" then
                                            if EquipData.Object.Pos.Value.Y <= 7.7 then
                                                C.SetActionLabel(actionClone,"Pulling")
                                                task.spawn(C.HotbarUI.Hotbar.DoEquipAction,C.HotbarUI.Hotbar)
                                            else
                                                C.SetActionLabel(actionClone,"Waiting")
                                            end
                                        else
                                            C.SetActionLabel(actionClone,". . .")
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
                                        C.SetActionLabel(actionClone,"Firing")
                                        C.RemoteObjects["TakeFoodCrate"]:FireServer({Object=closest})
                                        C.human:MoveTo(C.char:GetPivot().Position)
                                        return "Wait", 0
                                    else
                                        C.SetActionLabel(actionClone, "Walking")
                                        C.human:MoveTo(closest:GetPivot().Position)
                                        return true
                                    end
                                else
                                    C.SetActionLabel(actionClone, "No Resupply Crates")
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
                                        C.SetActionLabel(actionClone, "Firing2")
                                        C.RemoteObjects["RestockShelf"]:FireServer({Shelf = closest2})
                                        C.human:MoveTo(C.char:GetPivot().Position)
                                        return "Wait", 0
                                    else
                                        C.human:MoveTo(closest2:GetPivot()*Vector3.new(0,0,3))
                                        C.SetActionLabel(actionClone, "Walking2")
                                        return true
                                    end
                                else
                                    C.SetActionLabel(actionClone, "No Empty Shelves")
                                end
                            end
                            C.human:MoveTo(C.char:GetPivot().Position)
                        end,
                    },
                    SupermarketCashier = {
                        Overrides = {{"Noclip"}},Part="Floor",ProximityOnly=true,
                        Workstations = {Path="CashierWorkstations",PartOffset=Vector3.new(0,0,0)},
                        BotFunct = function(self, model, actionClone, myWorkstation)
                            local Customer = myWorkstation.Occupied.Value
                            if not Customer then
                                C.SetActionLabel(actionClone, "Waiting For Customer")
                                return
                            end
                            C.CanMoveOutOfPosition = myWorkstation.BagsLeft.Value <= 0
                            if myWorkstation.BagsLeft.Value <= 0 then
                                local BagCrate = model.Crates.BagCrate
                                if not C.HotbarUI.Hotbar.EquipData or C.HotbarUI.Hotbar.EquipData.Name ~= "BFF Bags" then
                                    C.human:MoveTo(BagCrate:GetPivot() * Vector3.new(3,0,0))
                                    if (model.Crates.BagCrate:GetPivot().Position - C.char:GetPivot().Position).Magnitude < 10 then
                                        C.SetActionLabel(actionClone, "New Bags (2/2)")
                                        C.RemoteObjects["TakeNewBags"]:FireServer({Object = model.Crates.BagCrate})
                                    else
                                        C.SetActionLabel(actionClone, "New Bags (1/2)")
                                    end
                                else
                                    if (myWorkstation:GetPivot().Position - C.char:GetPivot().Position).Magnitude < 10 then
                                        C.SetActionLabel(actionClone, "Restocking (2/2)")
                                        C.RemoteObjects["RestockBags"]:FireServer({Workstation = myWorkstation})
                                        C.human:MoveTo(C.char:GetPivot().Position)
                                    else
                                        C.human:MoveTo(myWorkstation:GetPivot().Position)
                                        C.SetActionLabel(actionClone, "Restocking (1/2)")
                                    end
                                end
                            elseif #myWorkstation.DroppedFood:GetChildren() > 0 then
                                local curBagCount = 0
                                for num, bag in ipairs(myWorkstation.Bags:GetChildren()) do
                                    local curCount = #bag:GetChildren() -- One instance in the Mesh instance!
                                    if bag.Transparency < 1e-3 and curCount <= 3 then
                                        curBagCount = curCount
                                        break
                                    end
                                end
                                if curBagCount > 0 then
                                    for num, instance in ipairs(myWorkstation.DroppedFood:GetChildren()) do
                                        if num - 1 <= 3 - curBagCount then
                                            C.SetActionLabel(actionClone, "Scanning "..instance.Name)
                                            C.RemoteObjects["ScanDroppedItem"]:FireServer({Item=instance})
                                            --task.wait()
                                        else
                                            C.SetActionLabel(actionClone, "Finish Scan")
                                            break
                                        end
                                    end
                                    return "Wait", 0
                                else
                                    C.RemoteObjects["TakeNewBag"]:FireServer({Workstation=myWorkstation})
                                    C.SetActionLabel(actionClone, "Getting Bag")
                                    return "Wait", 0.15
                                end
                            else
                                local hasAtLeastOneItem = false
                                for num, bag in ipairs(myWorkstation.Bags:GetChildren()) do
                                    if bag.Transparency < 1e-3 and #bag:GetChildren() > 1 then
                                        hasAtLeastOneItem = true
                                        break
                                    end
                                end
                                if hasAtLeastOneItem then
                                    --self.Timer = (self.Timer or 0) + 1
                                    if (myWorkstation.CustomerTarget_2.Position - Customer:GetPivot().Position).Magnitude < 3 then
                                        C.SetActionLabel(actionClone, "Finishing")
                                        C.RemoteObjects["JobCompleted"]:FireServer({Workstation=myWorkstation})
                                        myWorkstation.Occupied.Value = nil
                                    else
                                        C.SetActionLabel(actionClone, "Item Wait")
                                        return "Wait", 0
                                    end
                                else
                                    C.SetActionLabel(actionClone, "First Item Wait")
                                    return "Wait", 0
                                end
                            end
                        end,
                    },
                    PizzaPlanetBaker = {
                        Overrides = {{"Noclip"}},ProximityOnly=true,
                        Workstations = {Path="BakerWorkstations",PartOffset=Vector3.new(3,-1,0),Size=10},
                        BotFunct = function(self, model, actionClone, myWorkstation)
                            local Order = myWorkstation.Order
                            C.CanMoveOutOfPosition = Order.IngredientsLeft.Value <= 0
                            if Order.IngredientsLeft.Value <= 0 then
                                local IngrCrate = model.IngredientCrates.Crate
                                if not C.HotbarUI.Hotbar.EquipData or C.HotbarUI.Hotbar.EquipData.Name ~= "Ingredient Crate" then
                                    C.human:MoveTo(IngrCrate:GetPivot() * Vector3.new(3,0,0))
                                    if (IngrCrate:GetPivot().Position - C.char:GetPivot().Position).Magnitude < 10 then
                                        C.SetActionLabel(actionClone, "Get Crate (2/2)")
                                        C.RemoteObjects["TakeIngredientCrate"]:FireServer({Object = IngrCrate})
                                    else
                                        C.SetActionLabel(actionClone, "Get Crate (1/2)")
                                    end
                                else
                                    if (myWorkstation:GetPivot().Position - C.char:GetPivot().Position).Magnitude < 10 then
                                        C.SetActionLabel(actionClone, "Restock (2/2)")
                                        C.RemoteObjects["RestockIngredients"]:FireServer({Workstation = myWorkstation})
                                        C.human:MoveTo(C.char:GetPivot().Position)
                                    else
                                        C.human:MoveTo(myWorkstation:GetPivot().Position)
                                        C.SetActionLabel(actionClone, "Restock (1/2)")
                                    end
                                end
                            elseif Order.Value == "true" then
                                C.SetActionLabel(actionClone, "Waiting")
                            else
                                local PizzaTbls = {
                                    ["Cheese"]={false},
                                    ["Pepperoni"]={"Pepperoni"},
                                    ["Vegetable"]={"Vegetable"},
                                    ["Ham"]={"Ham"},
                                }
                                local myTbl = PizzaTbls[Order.Value]
                                if not myTbl then
                                    C.SetActionLabel(actionClone, "Order: "..Order.Value .. " (UNKNOWN)")
                                else
                                    C.SetActionLabel(actionClone, "Order: "..Order.Value)
                                    local endResult = {true,true,true}
                                    table.insert(endResult,myTbl[1])
                                    for s = 1, 4 do
                                        if s ~= 4 or myTbl[1] then
                                            C.RemoteObjects.UseWorkstation:FireServer({Workstation=myWorkstation})
                                            task.wait()
                                        end
                                    end
                                    C.RemoteObjects.JobCompleted:FireServer({Order=endResult,Workstation=myWorkstation})
                                end
                            end
                            return "Wait", 0
                        end,
                    },
                    BensIceCreamSeller = {
                        Part = "Floor",
                        BotFunct = function(self,model,actionClone)
                            local HasValid = false
                            local StaticCust, CurrentCustomer, ClosestDist = nil, nil, math.huge
                            for num, cust in ipairs(model.CustomerTargets:GetChildren()) do
                                local MyCust = cust.Occupied.Value
                                if MyCust and (not cust.InUse.Value or cust.InUse.Value == C.plr) then
                                    local Icon = C.StringFind(MyCust,"Head.ChatBubble.Body.IconFrame")
                                    local MyDist = (MyCust:GetPivot().Position - C.char:GetPivot().Position).Magnitude
                                    if (MyDist < ClosestDist) and Icon and Icon.Visible then
                                        StaticCust, CurrentCustomer, ClosestDist = cust, MyCust, MyDist
                                    end
                                    HasValid = true
                                end
                            end
                            if CurrentCustomer then
                                C.SetActionLabel(actionClone, "")
                                if not C.HotbarUI.Hotbar.EquipData or C.HotbarUI.Hotbar.EquipData.Name ~= "Ice Cream Cup" then
                                    C.SetActionLabel(actionClone, "Getting Cup")
                                    C.RemoteObjects["TakeIceCreamCup"]:FireServer({})
                                else
                                    local Cup = C.HotbarUI.Hotbar.EquipData.Object
                                    local Order = CurrentCustomer.Order
                                    --C.human:MoveTo(CurrentCustomer:GetPivot()*Vector3.new(0,0,-4))
                                    if Order.Flavor1.Value ~= "" and Cup.Ball1.Transparency == 1 then
                                        C.SetActionLabel(actionClone, "Flavor 1")
                                        C.RemoteObjects["AddIceCreamScoop"]:FireServer({
                                            Ball = Cup.Ball1,
                                            Taste = Order.Flavor1.Value,
                                        })
                                        Cup.Ball1.Transparency = 0
                                    elseif Order.Flavor2.Value ~= "" and Cup.Ball2.Transparency == 1 then
                                        C.SetActionLabel(actionClone, "Flavor 2")
                                        C.RemoteObjects["AddIceCreamScoop"]:FireServer({
                                            Ball = Cup.Ball2,
                                            Taste = Order.Flavor2.Value,
                                        })
                                        Cup.Ball2.Transparency = 0
                                    elseif Order.Topping.Value ~= "" and not Cup.Ball1:FindFirstChild("Sprinkles") then
                                        C.SetActionLabel(actionClone, "Topping")
                                        C.RemoteObjects["AddIceCreamTopping"]:FireServer({
                                            Taste = Order.Topping.Value
                                        })
                                        Instance.new("Folder",Cup.Ball1).Name = "Sprinkles"
                                    else
                                        if (C.char:GetPivot().Position - CurrentCustomer:GetPivot().Position).Magnitude < 10 then
                                            C.RemoteObjects["JobCompleted"]:FireServer({Workstation = StaticCust})
                                            C.SetActionLabel(actionClone, "Firing")
                                            return "Wait",0
                                        else
                                            C.SetActionLabel(actionClone, "Delivering")
                                            --C.human:MoveTo(CurrentCustomer:GetPivot()*Vector3.new(0,0,-4))
                                            
                                        end
                                        --if StaticCust.Occupied.Value == CurrentCustomer and CurrentCustomer then
                                            --StaticCust.Occupied.Value = nil
                                        --end
                                    end
                                end
                                if actionClone.Time.Text == "Getting Cup" then
                                    local IceCreamLoc = C.StringWait(model,"TableObjects.IceCreamCups"):GetPivot() * Vector3.new(0,0,-3)
                                    --Vector3.new(932,13.72,1047) -- Vector3.new(932,13.72,1047)
                                    if (IceCreamLoc - C.char:GetPivot().Position).Magnitude > 0.2 then
                                        C.human:MoveTo(IceCreamLoc)
                                    end
                                else
                                    C.human:MoveTo(CurrentCustomer:GetPivot()*Vector3.new(0,0,-4))
                                end
                                
                                return "Wait",0
                            else
                                if HasValid then
                                    C.human:MoveTo(Vector3.new(940,13.7269,1043.7152))
                                    --C.human:MoveTo(Vector3.new(932,13.72,1047))
                                    C.SetActionLabel(actionClone, "Waiting For Next")
                                    self.MoveTime = nil
                                else
                                    if not self.MoveTime then
                                        self.MoveTime = os.clock() + 1
                                    elseif os.clock() >= self.MoveTime then
                                        C.human:MoveTo(Vector3.new(940,13.7269,1043.7152))
                                        self.MoveTime = nil
                                    end
                                    C.SetActionLabel(actionClone, "Waiting For First Customer")
                                end
                            end
                        end,
                    },
                    StylezHairdresser = {
                        Overrides = {{"Noclip"}},Part="Roof",ProximityOnly=true,
                        Workstations = {Path="HairdresserWorkstations",PartOffset=Vector3.new(3,-1,0),Size=10},
                        BotFunct = function(self, model, actionClone, myWorkstation)
                            local StoolAttach = C.StringWait(myWorkstation,"Stool.AttachPos")
                            local Customer = myWorkstation.Occupied.Value
                            if Customer ~= self.IgnoreCustomer then
                                if self.Customer ~= Customer then
                                    self.SendTime = nil
                                    self.Customer = Customer
                                end
                            else
                                C.SetActionLabel(actionClone, "Waiting For Next")
                                return "Wait", 0
                            end
                            if not Customer or (Customer:GetPivot().Position - StoolAttach.Position).Magnitude > 1 then
                                C.SetActionLabel(actionClone, "Waiting For Customer")
                                return "Wait", 0
                            end
                            local Order = Customer.Order
                            if not self.SendTime then
                                self.SendTime = os.clock() + C.Randomizer:NextNumber(0.15,0.25) -- Run it on next call!
                            elseif os.clock() >= self.SendTime then
                                self.SendTime = nil
                                C.SetActionLabel(actionClone, "Spoofing")
                                C.RemoteObjects.JobCompleted:FireServer(
                                    {Order={Order.Style.Value,Order.Color.Value},Workstation=myWorkstation}
                                )
                                self.IgnoreCustomer = Customer
                                return
                            else
                                C.SetActionLabel(actionClone, ("Waiting %.1f"):format(self.SendTime - os.clock()))
                                return "Wait", 0
                            end
                            return "Wait", 0
                        end,
                    },
                    MikesMechanic = {
                        Overrides = {{"Noclip"}},ProximityOnly=true,
                        Workstations = {Path="MechanicWorkstations",PartOffset=Vector3.new(3,0,3),Size=100},
                        BotFunct = function(self, model, actionClone, myWorkstation)
                            C.CanMoveOutOfPosition = true
                            local Customer = myWorkstation.Occupied.Value
                            if Customer ~= self.IgnoreCustomer then
                                if self.Customer ~= Customer then
                                    self.Customer = Customer
                                end
                            else
                                --C.SetActionLabel(actionClone, "Waiting For Next"
                                --return "Wait", 0
                            end
                            if not Customer or (Customer:GetPivot().Position - myWorkstation.CustomerTarget.Position).Magnitude > 2 then
                                C.SetActionLabel(actionClone, "Waiting For Customer")
                                return "Wait", 0
                            end
                            local Order,Vehicle = Customer.Order, Customer.Vehicle
                            if self.Completed then
                                C.SetActionLabel(actionClone, "Completed")
                                self.Parent:WalkAndFire({myWorkstation},"JobCompleted","Workstation")
                                --self.IgnoreCustomer = Customer
                                self.Completed = false
                                return
                            elseif Order:FindFirstChild("Color") then
                                -- It's a coloring one!
                                if not C.HotbarUI.Hotbar.EquipData or C.HotbarUI.Hotbar.EquipData.ItemData.Name ~= "Spray Painter" then
                                    C.SetActionLabel(actionClone, "Color: "..Order.Color.Value)
                                    self.Parent:WalkAndFire({C.StringWait(model,"PaintingEquipment."..Order.Color.Value)},"TakePainter","Object")
                                    self.Completed = false
                                else
                                    C.SetActionLabel(actionClone, "Fixing Color")
                                    self.Parent:WalkAndFire({myWorkstation},"FixBike","Workstation")
                                end
                                return "Wait", 0
                            elseif Order:FindFirstChild("Wheels") then
                                local Wheel2Replace = (not Vehicle.FrontWheel:GetAttribute("Replaced") and "FrontWheel")
                                    or (not Vehicle.BackWheel:GetAttribute("Replaced") and "BackWheel") or "Completed"
                                if Wheel2Replace ~= "Completed" then
                                    if not C.HotbarUI.Hotbar.EquipData or C.HotbarUI.Hotbar.EquipData.ItemData.Name ~= "Motorcycle Wheel" then
                                        C.SetActionLabel(actionClone, "Getting Wheels")
                                        self.Parent:WalkAndFire({C.StringWait(model,"TireRacks."..Order.Wheels.Value)},"TakeWheel","Object")
                                        self.Completed = false
                                    else
                                        C.SetActionLabel(actionClone, "Fixing Wheels")
                                        local beforeTbl = {}
                                        if Wheel2Replace == "FrontWheel" then
                                            beforeTbl.Front = true
                                        end
                                        self.Parent:WalkAndFire({myWorkstation},"FixBike","Workstation",beforeTbl)
                                        if self.Completed then
                                            self.Completed = false
                                            Vehicle[Wheel2Replace]:SetAttribute("Replaced",true)
                                        end
                                    end
                                else
                                    C.SetActionLabel(actionClone, "Wheel Completion")
                                end
                                self.Completed = Wheel2Replace == "Completed"
                            elseif Order:FindFirstChild("Oil") then
                                if not C.HotbarUI.Hotbar.EquipData or C.HotbarUI.Hotbar.EquipData.ItemData.Name ~= "Oil Can" then
                                    self.Parent:WalkAndFire(C.StringWait(model,"OilCans"):GetChildren(),"TakeOil","Object")
                                    self.Completed = false
                                    C.SetActionLabel(actionClone, "Getting Oil")
                                else
                                    C.SetActionLabel(actionClone, "Fixing Oil")
                                    self.Parent:WalkAndFire({myWorkstation},"FixBike","Workstation")
                                end
                            else
                                C.SetActionLabel(actionClone, "NO NAME: " .. Order:GetChildren()[1].Value .. " " .. Order:GetChildren()[2].Value)
                            end
                            return "Wait", 0
                        end,
                    },
                    BloxBurgersEmployee = {
                        --Location = {CFrame = CFrame.new(1080,12.5,1097) * CFrame.Angles(0,math.rad(180),0), Size = Vector3.new(20,1,6)},
                        Workstations = {Path = "ScriptableObjects.Cashier.Workstations",PartOffset = Vector3.new(0,0,-2)},
                        BotFunct = function(self, model, actionClone, myWorkstation, jobModule)
                            local MainModule = jobModule.BloxBurgersCashier
                            if not myWorkstation.InUse.Value then
                                C.SetActionLabel(actionClone, "Assigning Workstation")
                                local Result = C.RemoteObjects.RequestCashierRole:InvokeServer({StationName = "Cashier", StationIndexName = myWorkstation.Name})
                                if Result then
                                    MainModule:OnStationClaimed(myWorkstation.StationPart,C.Attachment)
                                end
                                return "Wait", 0
                            elseif myWorkstation.InUse.Value ~= C.plr then
                                C.SetActionLabel(actionClone,"In Use")
                                return "Wait", 0
                            else
                                return
                            end
                            local StoolAttach = C.StringWait(myWorkstation,"Stool.AttachPos")
                            local Customer = myWorkstation.Occupied.Value
                            if Customer ~= self.IgnoreCustomer then
                                if self.Customer ~= Customer then
                                    self.SendTime = nil
                                    self.Customer = Customer
                                end
                            else
                                C.SetActionLabel(actionClone, "Waiting For Next")
                                return "Wait", 0
                            end
                            if not Customer or (Customer:GetPivot().Position - StoolAttach.Position).Magnitude > 1 then
                                C.SetActionLabel(actionClone, "Waiting For Customer")
                                return "Wait", 0
                            end
                            local Order = Customer.Order
                            if not self.SendTime then
                                self.SendTime = os.clock() + C.Randomizer:NextNumber(0.15,0.25) -- Run it on next call!
                            elseif os.clock() >= self.SendTime then
                                self.SendTime = nil
                                C.SetActionLabel(actionClone, "Spoofing")
                                --C.RemoteObjects.JobCompleted:FireServer(
                                --    {Order={Order.Style.Value,Order.Color.Value},Workstation=myWorkstation}
                                --)
                                --self.IgnoreCustomer = Customer
                                --return

                            else
                                C.SetActionLabel(actionClone, ("Waiting %.1f"):format(self.SendTime - os.clock()))
                                return "Wait", 0
                            end
                            return "Wait", 0
                        end,
                    },
                },
                WalkAndFire = function(self,possibilities,event,formatName,tbl)
                    local closest, closestDist = nil, math.huge
                    for num, instance in ipairs(possibilities) do
                        local curDist = ((instance:GetPivot().Position - C.char:GetPivot().Position)/Vector3.new(1,math.huge,1)).Magnitude
                        if curDist < closestDist then
                            closest, closestDist = instance, curDist
                        end
                    end
                    if closest then
                        C.human:MoveTo(closest:GetPivot().Position)
                        if closestDist < 5 then
                            tbl = tbl or {}
                            tbl[formatName]=closest
                            C.RemoteObjects[event]:FireServer(tbl)
                            self.Completed=true
                        end
                        return true
                    else
                        warn("None found out of event",event,possibilities)
                    end
                end,
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
                        --C.DoTeleport(closest:GetBoundingBox().Position)
                        return true, closest, closestDist
                    else
                        return false, "Not Found"
                    end
                end,
                JobRunner = function(self,jobName)
                    C.CanMoveOutOfPosition, self.Timer = false, 0
                    self.SendTime, self.MoveTime, self.Completed = nil, nil, nil
                    local displayJobName = jobName:gsub("%a+ ","")
                    local botData = self.BotData[jobName]
                    botData.Parent = self
                    local jobHandler = C.JobHandler
                    local jobModule = C.require(C.StringWait(C.plr,"PlayerScripts.Modules.JobHandler."..jobName))
                    
                    if botData.Part then
                        local instance = C.StringWait(jobModule.Model,botData.Part)
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
                        C.SetActionLabel(actionClone,"Going To Station")
                        
                        C.DoTeleport(botData.Location.CFrame.Rotation + C.RandomPointOnPart(botData.Location.CFrame,botData.Location.Size))
                    end
                    while info.Enabled do
                        while C.IsBusy() do
                            if not info.Enabled then
                                return
                            end
                            if actionClone and actionClone:FindFirstChild("Time") then
                                C.SetActionLabel(actionClone,"Busy")
                            end
                            task.wait(1)
                        end
                        actionClone = actionClone or C.AddAction(info)
                        while C.char and not C.IsBusy() and ((jobHandler:GetJob() ~= jobName and not false)--botData.ProximityOnly)
                            or (botData.Location and (botData.Location.CFrame.Position - C.char:GetPivot().Position).Magnitude > 500)) do
                            while not C.Cleared and (not actionClone or not pcall(C.SetActionLabel,actionClone,"TextChatService") 
                                or not actionClone.Parent or info ~= C.getgenv().ActionsList[info.Name]) do
                                warn("Stil Running After Deadline")
                                task.wait()
                            end
                            if not jobHandler:GetJob() then--and jobHandler:CanStartWorking(jobName,jobModule) then
                                C.SetActionLabel(actionClone,"Going To Work")
                                if jobHandler:GoToWork(jobName) then
                                    break
                                end
                            else
                                C.SetActionLabel(actionClone,"Waiting")
                            end
                            if jobHandler:GetJob() then
                                jobHandler:StopWorking()
                            end
                            task.wait(.1)
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
                            if botData.Location and not C.CanMoveOutOfPosition and not C.IsInBox(botData.Location.CFrame,botData.Location.Size,C.char:GetPivot().Position,true) then
                                TeleportToStation()
                                Return, Return2 = "Wait", 0
                            elseif botData.Workstations and (not myWorkstation or (not C.CanMoveOutOfPosition and
                                (not myWorkstation.Occupied or not C.IsInBox(myWorkstation:GetBoundingBox(),myWorkstation:GetExtentsSize()+Vector3.new(botData.Size,botData.Size,botData.Size),
                                    C.char:GetPivot().Position,true)))) then
                                Return, Return2 = self:GetClosestWorkstation(botData,jobModule)
                                if Return then
                                    myWorkstation = Return2
                                    if not C.IsInBox(myWorkstation:GetBoundingBox(),myWorkstation:GetExtentsSize()+Vector3.new(botData.Size,botData.Size,botData.Size),C.char:GetPivot().Position,true) then
                                        C.DoTeleport(myWorkstation:GetBoundingBox() * botData.Workstations.PartOffset)
                                    end
                                    Return, Return2 = "Wait", 0
                                end
                            else
                                --TimeLabel.Text = "Run"
                                Return, Return2 = botData:BotFunct(jobModule.Model,actionClone,myWorkstation,jobModule)
                                if Return == "Teleport" then
                                    TeleportToStation()
                                    Return, Return2 = "Wait", 0
                                end
                            end
                        end
                        if Return == "Wait" then
                            task.wait(Return2)
                        else
                            task.wait(.25)
                        end
                    end
                    --C.RemoveAction(self.Shortcut)
                end,
				Activate = function(self,newValue)
                    C.RemoveAction(self.Shortcut)
                    if not newValue then
                        return
                    end
                    table.insert(self.Threads,task.spawn(self.JobRunner,self,self.EnTbl.SelJob:gsub(" ","")))
                end,
                Options = {
                    {
						Type = Types.Dropdown,
                        Selections = {"Hut Fisherman","Supermarket Stocker",
                            "Supermarket Cashier","Bens Ice Cream Seller","Pizza Planet Baker",
                            "Stylez Hairdresser","Blox Burgers Employee"},--"Mikes Mechanic"},
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
                            C.SetActionLabel(actionClone,"Teleporting")
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
                                    C.SetActionLabel(actionClone,`Boosting {MoodValue}`,"Title")
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
                Activate = function(self,newValue,firstRun)
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
                    if not firstRun and newValue and self.EnTbl.HideUI then
                        local GUI = C.PlayerGui:FindFirstChild("_MessageBox")
                        if GUI then
                            self.Events.MessageBoxAdded(self,GUI)
                        end
                    end
                end,
                Events = {
                    MessageBoxAdded = function(self,GUI)
                        if not self.EnTbl.HideUI then
                            return
                        end
                        local Title = C.StringWait(GUI,"MessageBox.Title")
                        if Title.Text ~= "Critically low moods!" then
                            return
                        end
                        local EventSignal = C.StringWait(GUI,"MessageBox.Event",30)
                        assert(EventSignal,"[Bloxburg.AntiFaint]: Event Signal Yielded for 30 seconds and it was not found!")
                        EventSignal:Fire("Faint") -- hide it right away!
                    end,
                },
                Options = {
                    {
						Type = Types.Toggle,
                        Default = true,
						Title = "Hide UI",
						Tooltip = "Prevents the UI from popping up so that you don't have to click \"Faint\"",
						Layout = 1,
						Shortcut="HideUI",
                        Activate=C.ReloadHack,
					},
                },
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
end]=],
    ["Games/Doomspire"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local absoluteMaximumDirtDistance = 20
local function Static(C,Settings)

end

return function (C,Settings)
    Static(C,Settings)

    return {
        Category = {
            Name = "Doomspire",
            Title = "Doomspire Brickbattle",
            Image = nil, -- Set Image to nil in order to get game image!
            Layout = 20,
        },
        Tab = {
            {
				Title = "Weapon Stats",
				Tooltip = "Hacks weapon stats to allow you to perform at your best ;)\nReset required",
				Layout = 0, Instances = {}, Functs={}, Original = {},
				Shortcut = "WeaponStats",Default=true, DontActivate=true,
                PreModify = function(self, tbl, key)
                    --if not self.Original[key] then
                    for key, val in pairs(tbl) do
                        if (key ~= "TeamsFiltered") then
                            self.Original[key] = typeof(val) == "table" and C.DeepCopy(tbl[key]) or val
                        end
                    end
                    --end
                end,
                SetEnabled = function(self, en)
                    for num, mod in ipairs(C.getgc(true)) do
                        local ModSettings = typeof(mod) == "table" and rawget(mod, "Settings")
                        if ModSettings and typeof(ModSettings) == "table" and rawget(ModSettings,"Rocket") then
                            --C.setclipboard(print(mod))
                            if (not en) then
                                for key, val in pairs(self.Original) do
                                    rawset(mod,key,val)
                                end
                            else
                                self:PreModify(mod, "Settings")
                                local RocketStats = rawget(ModSettings,"Rocket")
                                local BombStats = rawget(ModSettings, "Bomb")
                                --print("Modified Bomb.Reload from",rawget(BombStats,"Reload"),"to 0.0")
                                rawset(RocketStats,"ReloadTime",1)
                                rawset(RocketStats,"Speed",600)
                                rawset(RocketStats, "Radius", 600)
                                rawset(RocketStats, "MaxMassToDestroy", 300)


                                rawset(ModSettings,"TeamKill",true)
                                rawset(BombStats, "ReloadTime", 4)
                                rawset(BombStats, "Radius", 600)
                                rawset(BombStats, "ExplosionForce", 0)--1e6 * (rawget(BombStats, "Radius") / 12))
                                rawset(BombStats, "Damage", 1000)
                                rawset(BombStats, "MaxMassToDestroy", 300)
                            end
                        end
                    end
                end,
                RunOnDestroy = function(self)
                    self:SetEnabled(false)
                end,
				Activate = function(self,newValue)
                    self:SetEnabled(newValue)
                end,
                Events = {
                    MyCharAdded=function(self,theirPlr,theirChar,firstRun)
                        --[[table.insert(self.Functs,theirPlr:WaitForChild("Backpack").ChildAdded:Connect(function(newTool)
                            self:NewInstance(newTool)
                        end))--]]
                        task.delay(.5,self.Activate,self,self.RealEnabled)
					end,
                },
            },
        }
    }
end





]=],
    ["Games/FlagWars"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local absoluteMaximumDirtDistance = 20
local function Static(C,Settings)
    function C.getClosestDirt(location: Vector3)
        local myHRPPos = location or (C.char and C.char.PrimaryPart and C.char:GetPivot().Position)
        if not myHRPPos then return end
        local selDirt, maxDist, closestAngle = nil, absoluteMaximumDirtDistance, 360
        for num, part in pairs(workspace.Core.CurrentDirt:GetDescendants()) do
            if part:IsA("BasePart") then
                local d = (part.Position - myHRPPos).Magnitude
                --local angle = math.round(math.abs(C.AngleOffFromCFrame(C.hrp:GetPivot(),part.Position))/10)*10
                if (((not selDirt or part.Position.Y - 0.5 < selDirt.Position.Y) and d < maxDist) or (selDirt and part.Position.Y+0.5 < selDirt.Position.Y)) then
                        --and (angle < closestAngle) and d < absoluteMaximumDirtDistance then
                    selDirt, maxDist, closestAngle = part, d, nil
                end
            end
        end
        return selDirt, maxDist
    end
    -- Map Added is lowkey just team added -.-
    --[[table.insert(C.EventFunctions,function()
		local function MapAdded()
            C.Map = workspace:WaitForChild("Normal")
            C.FireEvent("MapAdded",nil,C.Map)
            C.AddObjectConnection(C.Map,"MapRemoved",C.Map.Destroying:Connect(function()
                
                C.FireEvent("MapRemoved",nil,C.Map)
            end))
        end
        C.StringWait(RS,"Remotes.Gameplay.LoadingMap").OnClientEvent:Connect(MapAdded)
        if workspace:FindFirstChild("Normal") then
            MapAdded()
        end

    end)--]]
end

return function (C,Settings)
    Static(C,Settings)

    return {
        Category = {
            Name = "FlagWars",
            Title = "Flag Wars",
            Image = nil, -- Set Image to nil in order to get game image!
            Layout = 20,
        },
        Tab = {
            {
				Title = "Weapon Stats",
				Tooltip = "Creates infinite ammo, firerate, and accuracy hack; re-equip on enable/disable",
				Layout = 0, Instances = {}, Functs={},
				Shortcut = "WeaponStats",Default=true, DontActivate=true,
                NewInstance = function(self,newTool)
                    local config = newTool:WaitForChild("Configuration",10)
                    if not config or not newTool:IsA("Tool") then
                        return
                    end
                    local function SetStat(config,name,newValue,doInsert)
                        local val = config:FindFirstChild(name)
                        if not val and doInsert and self.RealEnabled then
                            val = Instance.new((typeof(newValue)=="string" and "StringValue")
                                or (typeof(newValue)=="boolean" and "BoolValue")
                                or (typeof(newValue)=="number" and "NumberValue"), config)
                            val.Name = name
                            table.insert(self.Instances,val)
                        elseif not val then
                            return
                        end
                        C.ResetPartProperty(val,"Value",self.Shortcut)
                        if self.RealEnabled then
                            C.SetPartProperty(val,"Value",self.Shortcut,newValue)
                        --else
                            --C.ResetPartProperty(val,"Value",self.Shortcut)
                        end
                    end
                    SetStat(config,"RecoilMin",0)
                    SetStat(config,"RecoilMax",0)
                    SetStat(config,"RecoilDecay",0)
                    SetStat(config,"TotalRecoilMax",0)
                    SetStat(config,"MinSpread",0)
                    SetStat(config,"MaxSpread",0)
                    SetStat(config,"ShotCooldown",0)
                    SetStat(config,"Cooldown",0)
                    SetStat(config,"SwingCooldown",0)
                    SetStat(config,"HitRate",0)

                    SetStat(config,"FireMode","Automatic",true)
                    SetStat(config.Parent,"CurrentAmmo",69)
                end,
				Activate = function(self,newValue)
                    local toolsToLoop = C.plr:WaitForChild("Backpack"):GetChildren()
                    local curTool = C.char:FindFirstChildWhichIsA("Tool")
                    if curTool then
                        table.insert(toolsToLoop,curTool)
                    end
                    for num, tool in ipairs(toolsToLoop) do
                        task.spawn(self.NewInstance,self,tool)
                    end
                end,
                Events = {
                    MyCharAdded=function(self,theirPlr,theirChar,firstRun)
                        table.insert(self.Functs,theirPlr:WaitForChild("Backpack").ChildAdded:Connect(function(newTool)
                            self:NewInstance(newTool)
                        end))
                        task.delay(.5,self.Activate,self)
					end,
                },
            },
            {
				Title = "Gun Hit",
				Tooltip = "Hits the closest user",
				Layout = 4,AlwaysActivate=true,
				Shortcut = "GunHit",Default=true,
                Activate = function(self,newValue)
                    local EnTbl = self.EnTbl
                    local tblClone, tblPack, tskSpawn = table.clone, table.pack, task.spawn
                    local getVal, setVal = rawget, rawset
                    C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,arg1,arg2,...)
                        if tostring(self) == "WeaponHit" then
                            local ClosestHead, Distance = C.getClosest(nil,getVal(arg2,"p"))
                            if ClosestHead then--and Distance < 50 then
                                -- Table Clone: Security Prevention
                                --tskSpawn(print,arg2)
                                arg2 = tblClone(arg2)
                                setVal(arg2,"part",ClosestHead)
                                setVal(arg2,"p",ClosestHead.Position)
                                setVal(arg2,"h",ClosestHead)
                                if rawget(EnTbl,"SetALLTargets") then
                                    setVal(arg2,"m",ClosestHead.Material)
                                    setVal(arg2,"t",rawget(arg2,"t")*3)
                                    setVal(arg2,"d",rawget(arg2,"d")*3)
                                    setVal(arg2,"maxDist",rawget(arg2,"maxDist")*3)
                                end
                                

                                --[[dataTbl["p"] = ClosestHead.Position
                                dataTbl["d"] = Distance
                                dataTbl["m"] = ClosestHead.Material
                                dataTbl['n'] = -(ClosestHead.Position - C.char.PrimaryPart.Position).Unit
                                dataTbl["maxDist"] = Distance + .3
                                dataTbl["t"] = 1--]]
                                return "Override", tblPack(self,arg1,arg2,...)
                            elseif rawget(EnTbl,"NoSelfKill") then
                                --task.delay(1,print,"Canceled; none found")
                                return "Cancel"--do nothing lol, don't kill yaself!
                            end
                        end
                        
                    end,{"fireserver"})
                end,
                Options = {
                    {
						Type = Types.Toggle,
						Title = "No Self Kill",
						Tooltip = "Disabling hitting yourself with explosive weapons",
						Layout = 1,Default=true,
						Shortcut="NoSelfKill",
					},
                    {
						Type = Types.Toggle,
						Title = "(Experimental) Set All",
						Tooltip = "Sets ALL aspects, not just the target. This includes direction, unit vector, distance, and time.",
						Layout = 2,Default=true,
						Shortcut="SetALLTargets",
					},
                },
            },
            false and {
				Title = "Sword Hit",
				Tooltip = "Hits the closest user",
				Layout = 5,
				Shortcut = "SwordHit",Default=true,
                Activate = function(self,newValue)
                    local tblClone, tblPack = table.clone, table.pack
                    C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,arg1,arg2,arg3,...)
                        if tostring(self) == "ClientCast-Replication" then
                            local ClosestHead, Distance = C.getClosest(nil,arg3.Position)
                            if ClosestHead then--and Distance < 50 then
                                -- Table Clone: Security Prevention
                                arg3 = tblClone(arg3)
                                arg3["Instance"] = ClosestHead

                                -- Fake the signal into firing, meanwhile firing our own
                                task.spawn(self.FireServer,self,arg1,arg2,arg3,...)

                                task.spawn(print,"HIT PLR")
                                return "Cancel"
                            else
                                -- Doesn't matter, do nothing!
                            end
                        end
                        
                    end,{"fireserver"})
                end
            },
            {
				Title = "Auto Bore",
				Tooltip = "Automatically digs nearby dirt near you",
				Layout = 10,Threads={},DontActivate = true,
				Shortcut = "AutoBore",Default=true,
                Run = function(self)
                    local DigEvent = C.StringWait(RS,"Events.Dig")

                    while true do
                        local dirt, distance = C.getClosestDirt()
                        if dirt and distance < absoluteMaximumDirtDistance then
                            --warn("Distance",tostring(distance))
                            for s = 1, 4, 1 do
                                task.spawn(DigEvent.FireServer,DigEvent,"Shovel",dirt)
                            end
                        end
                        RunS.RenderStepped:Wait()
                    end
                end,
                Activate = function(self,newValue)
                    if not newValue then
                        return--stop it!
                    end
                    --for s = 1, 10, 1 do
                    --    table.insert(self.Threads,task.spawn(self.Run,self))
                    --end
                    self:Run()
                end,
                Events = {
                    MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
                }
            },
            {
				Title = "Loop Capture",
				Tooltip = "Captures the flag the fastest possible",
				Layout = 15,Functs={},Threads={},
				Shortcut = "LoopCature",Default=true,DontActivate=true,
                Activate = function(self,newValue)
                    C.RemoveAction(self.Shortcut)
                    C.LoadPlayerCoords(self.Shortcut)
                    if not newValue or C.plr.Team.Name == "Neutral" then
                        return
                    end
                    local EnemyTeam = C.plr.Team.Name == "Team Blue" and "Team Red" or "Team Blue"
                    local AllyFlag = game:GetService("Workspace").Core.Flags[C.plr.Team.Name].Base
                    local EnemyFlag = game:GetService("Workspace").Core.Flags[EnemyTeam].Base
                    local info = {Name=self.Shortcut,Title="Loop Capture",Tags={"RemoveOnDestroy"},Stop=function()
                        self:SetValue(false)
                    end}
                    local actionClone = C.AddAction(info)
                    C.SavePlayerCoords(self.Shortcut)
                    local TeleportOffset = Vector3.new(0,2,0)
                    local TempOffset = Vector3.new(0,-44,0)
                    local LastTouch
                    local LastGet = os.clock()
                    while true do
                        if C.char then
                            local HasFlag = C.char:FindFirstChild("Flag")
                            if HasFlag then
                                if not LastTouch then
                                    LastTouch = os.clock()
                                elseif os.clock()-LastTouch >= 7 then
                                    C.DoTeleport(AllyFlag.Position + TeleportOffset + Vector3.new(C.Randomizer:NextNumber(-3,3),C.Randomizer:NextNumber(-2,-4),C.Randomizer:NextNumber(-3,3)))
                                    actionClone.Time.Text = "Capturing"
                                else
                                    C.DoTeleport(EnemyFlag.Position + TempOffset)
                                    actionClone.Time.Text = (`Wait %i`):format(math.ceil(7 - (os.clock()-LastTouch)))
                                end
                                LastGet = os.clock()
                            else
                                if not LastGet then
                                    LastGet = os.clock()
                                end
                                if os.clock() - LastGet >= 3 then
                                    local Debris = C.StringFind(workspace,"Core.Debris")
                                    local EnemyDropMiddle
                                    for num, flag in ipairs(Debris and Debris:GetChildren() or {}) do
                                        if flag.Name == "FlagDrop" then
                                            local DropMiddle = C.StringFind(flag,"Parts.Middle")
                                            local DropTL = C.StringFind(flag,"DropCount.Time")
                                            if DropMiddle and (DropTL.TextColor3.R*255 > .8 and EnemyTeam=="Team Red") or (DropTL.TextColor3.B > .8 and EnemyTeam=="Team Blue") then
                                                EnemyDropMiddle = DropMiddle
                                            end
                                        end
                                    end
                                    if EnemyDropMiddle then
                                        actionClone.Time.Text = "Pick Up"
                                        C.DoTeleport(EnemyDropMiddle.Position + TeleportOffset + Vector3.new(C.Randomizer:NextNumber(-1,1),C.Randomizer:NextNumber(-2,4),C.Randomizer:NextNumber(-1,1)))
                                    else
                                        actionClone.Time.Text = "Base Steal"
                                        C.DoTeleport(EnemyFlag.Position + TeleportOffset + Vector3.new(C.Randomizer:NextNumber(-3,3),C.Randomizer:NextNumber(-2,4),C.Randomizer:NextNumber(-3,3)))
                                    end
                                else
                                    actionClone.Time.Text = (`Wait %i`):format(math.ceil(3 - (os.clock()-LastGet)))
                                end
                                LastTouch = nil
                            end
                        end
                        RunS.PreSimulation:Wait()
                    end
                end,
                Events = {
                    MyTeamAdded = function(self,theirPlr,newTeamName)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
                }
            },
            {
				Title = "Disable Killwall",
				Tooltip = "Disables SOME Kill bricks!",
				Layout = 20,Functs={},
				Shortcut = "NoKillBricks",Default=true,
                NewInMap = function(self,part)
                    if part:IsA("BasePart") and part:FindFirstChildWhichIsA("TouchTransmitter") then
                        if self.RealEnabled then
                            C.SetPartProperty(part,"CanTouch",self.Shortcut,false)
                        else
                            C.ResetPartProperty(part,"CanTouch",self.Shortcut)
                        end
                    end
                end,
                Activate = function(self)
                    local CurMap = C.StringWait(workspace,"Core.CurrentMap")
                    for num, touchPart in ipairs(CurMap:GetChildren()) do
                        self:NewInMap(touchPart)
                    end
                    table.insert(self.Functs,CurMap.ChildAdded:Connect(function(new)
                        self:NewInMap(new)
                    end))
                end,
                Events = {
                    MyTeamAdded = function(self,theirPlr,newTeamName)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
                }
            },
            
            --[[
                local args = {
                    [1] = "Shovel",
                    [2] = workspace.Core.CurrentDirt.Chunk4.dirt
                }

                game:GetService("ReplicatedStorage").Events.Dig:FireServer(unpack(args))
            ]]
            
        },
    }
end





]=],
    ["Games/FleeTheFacility"] = [[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local DS = game:GetService("Debris")
local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local GS = game:GetService("GuiService")
local PS = game:GetService("Players")
local LS = game:GetService("Lighting")
local RS = game:GetService("ReplicatedStorage")
local SG = game:GetService("StarterGui")


local MAX_SHOP_ITEM = 10
local BotActionClone

-- STANDARD FUNCTIONS--

local function AppendToFirstArr(tbl1, tbl2, clone)
    for _, val2 in ipairs(tbl2) do
        table.insert(tbl1, clone and table.clone(val2) or val2)
    end
    return tbl1
end

local function GetSharedHacks(C, Settings)
    function C.sortPlayersByXPThenCredits(plrList)
		plrList = plrList or PS:GetPlayers()


		table.sort(plrList,	function(a,b)
			local aStats=a:FindFirstChild("SavedPlayerStatsModule")
			local bStats=b:FindFirstChild("SavedPlayerStatsModule")
			local doesExistA, doesExistB = aStats and aStats.Parent, bStats and bStats.Parent
			if doesExistA and not doesExistB then
				return true
			elseif not doesExistA and doesExistB then
				return false
			end
			local isABot=table.find(C.BotUsers, a.Name:lower()) ~= nil
			local isBBot=table.find(C.BotUsers, b.Name:lower()) ~= nil
			if isABot~=isBBot then
				return isABot and not isBBot
			end
			local aLevel = aStats:FindFirstChild("Level")
			local bLevel = bStats:FindFirstChild("Level")
			if not aLevel or not bLevel then
				return aLevel~=nil
			end
			if aLevel.Value~=bLevel.Value then
				return (aLevel.Value>bLevel.Value)
			end
			local aXP = aStats:FindFirstChild("Xp")
			local bXP = bStats:FindFirstChild("Xp")
			if not aXP or not bXP then
				return aXP~=nil
			end
			if aXP.Value~=bXP.Value then
				return (aXP.Value>bXP.Value)
			end
			if (aStats.Credits.Value ~= bStats.Credits.Value) then
				return (aStats.Credits.Value>bStats.Credits.Value)
			end
			return a.Name:lower() > b.Name:lower()
		end)

		return plrList
	end
    local SharedHacks = {
    {
        Title = "Speed Buy",
        Tooltip = "Automatically buys selected items up to n amount!",
        Layout = 0,
        Shortcut = "SpeedBuy",
        IgnoreList = {"Series 1H", "Series 1G"},

        Process = function(self, actionClone, info)
            C.SetActionLabel(actionClone, "Loading Modules...")

            local Crates = require(RS.ShopCrates)
            local Bundles = require(RS.ShopBundles)

            C.SetActionLabel(actionClone, "Loading Inventory...")
            local MyInventory, StartCount = C.GetUserInventory()
            local CurCount = StartCount
            local CountToPurchase = 0
            local ItemsToBuy = {}
            local function CountTotalFunction(itemName, itemType: nil, requiredItems)
                local amntToBuy = MAX_SHOP_ITEM
                if itemType then -- Crate
                    amntToBuy = self.EnTbl.EventCrateQty - (MyInventory[itemName] or 0)
                else-- Bundle
                    for _, item in ipairs(requiredItems) do
                        local itemNeeds = self.EnTbl.EventBundleQty - (MyInventory[item] or 0)
                        amntToBuy = math.min(amntToBuy, itemNeeds)
                    end
                    amntToBuy = amntToBuy * #requiredItems
                end
                if amntToBuy > 0 then
                    table.insert(ItemsToBuy,{itemName,itemType,requiredItems})
                end
                return amntToBuy
            end
            local function GetItemWhileNotLimit(itemName, itemType: nil, requiredItems)
                if itemType then -- Crate
                    while (MyInventory[itemName] or 0) < self.EnTbl.EventCrateQty do
                        actionClone.Title.Text = `Purchasing ({CurCount - StartCount + 1}/{CountToPurchase})`
                        C.SetActionLabel(actionClone, `{itemName}`)
                        C.RemoteEvent:FireServer("BuyCrateBoxItem", itemType, itemName)--SendWaitRemoteEvent("RefreshCurrentMenu","BuyCrateBoxItem", itemType, itemName)
                        task.wait(1)
                        MyInventory, CurCount = C.GetUserInventory()
                    end
                else-- Bundle
                    while true do
                        local HasAll = true
                        local HasOneMaxed = false
                        for _, item in ipairs(requiredItems) do
                            if (MyInventory[item] or 0) < self.EnTbl.EventBundleQty then
                                HasAll = false
                            elseif (MyInventory[item] or 0) >= MAX_SHOP_ITEM then
                                HasOneMaxed = true
                                break
                            end
                        end
                        if HasAll or HasOneMaxed then
                            break
                        end
                        actionClone.Title.Text = `Purchasing ({CurCount - StartCount + 1}/{CountToPurchase})`
                        C.SetActionLabel(actionClone, `{itemName}`)
                        C.RemoteEvent:FireServer("BuyShopBundle",itemName)--SendWaitRemoteEvent("RefreshCurrentMenu","BuyShopBundle",itemName)
                        task.wait(1)
                        MyInventory, CurCount = C.GetUserInventory()
                    end
                end

            end
            C.SetActionLabel(actionClone, "Calculating")
            local start = os.clock()
            for name, data in pairs(Crates) do
                if not table.find(self.IgnoreList, name) then
                    for _, prizeVal in pairs(data.Prizes) do
                        CountToPurchase+=CountTotalFunction(prizeVal, name)
                    end
                end
            end
            for name, data in pairs(Bundles) do
                if not data.CostRobux then
                    CountToPurchase+=CountTotalFunction(name, nil, data.Items)
                end
            end

            -- Dummy Check / Confirmation
            info.CanCancel += 1
            local CanContinue = CountToPurchase > 0 and C.Prompt(`Purchase {CountToPurchase} Items`,
                `Are you sure that you want to buy these hammers and gems?\nIf you are unsure, configure this under "Speed Buy".`, "Y/N")
            info.CanCancel -= 1
            if CanContinue then
                C.hackData.FleeTheFacility.InstaTrade:SetValue(false) -- Disable the trading mechanism while we buy bundles!
                for n, data in ipairs(ItemsToBuy) do
                    GetItemWhileNotLimit(table.unpack(data))
                end

                -- COMPELTED --
                C.CreateSysMessage(`Successfully purchased {CountToPurchase} crates and bundles in {C.GetFormattedTime(os.clock()-start)}!`, Color3.fromRGB(0,255,0))
            elseif CountToPurchase <= 0 then
                C.AddNotification(`No Items To Purchases`,`All the crates and bundles you have selected for pruchase are already in your inventory at the requested/max amount.`)
            end


            self:SetValue(false)
        end,
        Activate = function(self, enabled, firstRun)
            C.RemoveAction(self.Shortcut)
            if not enabled then
                return
            elseif firstRun then
                self:SetValue(false)
                return
            end

            local info = {Name = self.Shortcut, Title = "Purchasing", CanCancel = 0, Tags = {"RemoveOnDestroy"}, Threads = {}, Time = function(actionClone, info)
                self:Process(actionClone, info)
            end, Stop = function(byRequest)
                self:SetValue(false)
            end}
            local actionClone = C.AddAction(info)
        end,
        Options = {
            {
                Type = Types.Slider,
                Title = "Event Crates",
                Tooltip = "How much of every event crate to buy!",
                Layout = 1,Default = 10,
                Min = 0, Max=10, Digits=0,
                Shortcut="EventCrateQty",
            },
            {
                Type = Types.Slider,
                Title = "Event Bundles",
                Tooltip = "How much of every event bundle to buy!",
                Layout = 2,Default = 10,
                Min = 0, Max=10, Digits=0,
                Shortcut="EventBundleQty",
            },
        },
    },
    {
        Title = "Game Improvements",
        Tooltip = "Fixes stuff necessary to live💀",
        Layout = 100,
        Shortcut = "GameImprovements",
        Default = true,
        TeleportOnFailPos = Vector3.new(103, 8, -435),
        Functs = {},
        Activate = function(self, newValue, firstRun)
            if not newValue then
                return
            end
            if game.PlaceId == 893973440 then
                local ScreenGui = C.PlayerGui:WaitForChild("ScreenGui");
                local MenusTabFrame = ScreenGui:WaitForChild("MenusTabFrame");
                local BeastPowerMenuFrame = ScreenGui:WaitForChild("BeastPowerMenuFrame")
                local SurvivorStartFrame = ScreenGui:WaitForChild("SurvivorStartFrame")
                local IsCheckingLoadData = C.plr:WaitForChild("IsCheckingLoadData");
                local function menusTab()
                    MenusTabFrame.Visible=not IsCheckingLoadData.Value
                end
                local function beastScreen()
                    BeastPowerMenuFrame.Visible=false
                end
                local function survivorScreen()
                    SurvivorStartFrame.Visible=false
                end
                table.insert(self.Functs,MenusTabFrame:GetPropertyChangedSignal("Visible"):Connect(menusTab))
                menusTab()

                table.insert(self.Functs,BeastPowerMenuFrame:GetPropertyChangedSignal("Visible"):Connect(beastScreen))
                beastScreen()

                table.insert(self.Functs,SurvivorStartFrame:GetPropertyChangedSignal("Visible"):Connect(survivorScreen))
                survivorScreen()

                if firstRun then
                    return
                end

                for num, theirPlr in ipairs(PS:GetPlayers()) do
                    if theirPlr and theirPlr.Character then
                        task.spawn(self.Events.CharAdded, self, theirPlr, theirPlr.Character)
                    end
                end
            end
        end,
        Events = {
            MyCharAdded = C.ReloadHack,
            MapRemoved = function(self)
                local Torso = C.char and C.char:FindFirstChild("Torso")
                if Torso and (Torso.Anchored or C.char:FindFirstChild("RopeConstraint", true)) then
                    warn((Torso.Anchored and "Torso Anchored" or "RopeConstraint Found" ) .. " Anchored, Resetting...")
                    task.spawn(C.ResetCharacter)
                end
                if (C.isInGame(C.char)) then
                    C.DoTeleport(self.TeleportOnFailPos)
                    warn("Teleported back from the game because game ended, and map was destroyed!")
                --else
                    --print("Not in game, all good ✅")
                end
                self.Events.MyBeastHammerRemoved(self)

            end,
            MyBeastHammerRemoved = function(self)
                task.wait(1)
                for num, animTrack in ipairs(C.human:GetPlayingAnimationTracks()) do
                    if animTrack.Name == "AnimArmIdle" then
                        animTrack:Stop(0)
                    end
                end
            end,
            CharAdded = function(self, theirPlr, theirChar)
                local function ChildAdded(basePart)
                    if basePart:IsA("BasePart") then
                        if basePart.Name == "Part" then
                            local Rope = basePart:WaitForChild("RopeConstraint",1/3)
                            if Rope then
                                Rope.Enabled = false
                            end
                        end
                    end
                end
                table.insert(self.Functs, theirChar.ChildAdded:Connect(ChildAdded))
                for num, basePart in ipairs(theirChar:GetChildren()) do
                    ChildAdded(basePart)
                end
            end
        }
    },

    }
    return SharedHacks
end

local function SetUpGame(C, Settings)
    C.GameTimer = RS:WaitForChild("GameTimer")
    C.GameStatus = RS:WaitForChild("GameStatus")
    function C.CanTarget(self, target)
        if self.EnTbl.Me and target == C.plr then
            return true
        elseif self.EnTbl.Others and target ~= C.plr then
            return true
        else
            return false
        end
    end
    local function CleanUpMap()
        C.FreezingPods = {}
        C.Computers = {}
        C.NormalDoors = {}
        C.ExitDoors = {}
        C.Map = nil
    end
    CleanUpMap()
    table.insert(C.EventFunctions,function()
        local CurrentMap = RS:WaitForChild("CurrentMap")
		local function MapAdded(newMap)
            if not newMap then
                CurrentMap.Value = workspace
                return
            end
            while (newMap ~= workspace and newMap == CurrentMap.Value and C.GameStatus.Value:lower():find("loading")) do
                C.GameStatus:GetPropertyChangedSignal("Value"):Wait()
            end
            if newMap ~= CurrentMap.Value then
                return
            end
            if newMap == workspace then
                C.FireEvent("MapRemoved",nil,C.Map)
                CleanUpMap()
                return
            end
            -- ADD FREEZING PODS, COMPUTERS --
            local function newChild(item)
                task.wait()
                if item.Name:sub(1,9) == "FreezePod" then
                    table.insert(C.FreezingPods, item)
                    C.FireEvent("NewFreezingPod", nil, item)
                elseif item.Name:sub(1,13) == "ComputerTable" then
                    table.insert(C.Computers, item)
                elseif item.Name=="SingleDoor" or item.Name=="DoubleDoor" then
                    table.insert(C.NormalDoors, item)
                elseif item.Name=="ExitDoor" then
                    table.insert(C.ExitDoors, item)
                end
            end
            C.AddObjectConnection(newMap, "MapAddedChild", newMap.ChildAdded:Connect(newChild))
            for _, item in ipairs(newMap:GetChildren()) do
                task.spawn(newChild,item)
            end
            C.Map = newMap
            C.FireEvent("MapAdded",nil,C.Map)
            C.AddObjectConnection(newMap, "MapDestroyed", newMap.AncestryChanged:Connect(function()
                if newMap == CurrentMap.Value then -- Check to see if still valid
                    CurrentMap.Value = workspace -- If not, reset the map value to refresh!
                end
            end))
        end
        C.AddGlobalConnection(CurrentMap.Changed:Connect(MapAdded))
        C.AddGlobalThread(task.spawn(MapAdded, CurrentMap.Value))
        local gameActiveVal = RS:WaitForChild("IsGameActive")
        local function gameActiveValChanged(newVal)
            C.GameActive = newVal
            C.FireEvent(newVal and "GameAdded" or "GameRemoved", nil)
        end
        C.AddGlobalConnection(gameActiveVal.Changed:Connect(gameActiveValChanged))
        if gameActiveVal.Value then
            gameActiveValChanged(gameActiveVal.Value)
        end
    end)
    table.insert(C.CharacterAddedEventFuncts, function(theirPlr, theirChar, theirHuman)
        local function childAdded(inst)
            if inst and inst.Name == "Hammer" then
                local Handle = inst:WaitForChild("Handle",100)
                local HammerEvent = inst:WaitForChild("HammerEvent", 100)
                if not Handle or not HammerEvent then
                    return
                end
                C.Hammer, C.Handle, C.HammerEvent, C.BeastPlr, C.BeastChar = inst, Handle, HammerEvent, theirPlr, theirPlr.Character
                C.FireEvent("BeastHammerAdded",theirPlr == C.plr,theirPlr,theirChar,theirHuman)
                C.AddObjectConnection(Handle, "BeastHammerRemoved", Handle.AncestryChanged:Connect(function()
                    if not workspace:IsAncestorOf(Handle.Parent) then
                        C.Hammer, C.Handle, C.BeastPlr, C.BeastChar, C.CarriedTorso = nil, nil, nil, nil, nil
                        C.FireEvent("BeastHammerRemoved",theirPlr == C.plr,theirPlr,theirChar,theirHuman)
                    end
                end))
                local CarriedTorso = theirChar:WaitForChild("CarriedTorso",20)
                if not CarriedTorso then return end
                C.CarriedTorso = CarriedTorso
                local LastCarried
                local function RopeUpd(newVal)
                    if newVal then
                        C.FireEvent("BeastRopeAdded",theirPlr == C.plr, newVal and newVal.Parent or nil)
                    else
                        C.FireEvent("BeastRopeRemoved",theirPlr == C.plr, LastCarried)
                    end
                    LastCarried = newVal and newVal.Parent or nil
                end
                C.AddObjectConnection(CarriedTorso, "BeastRope", CarriedTorso.Changed:Connect(RopeUpd))
                if CarriedTorso.Value then
                    RopeUpd(CarriedTorso.Value)
                end
            end
        end

        C.AddObjectConnection(theirChar, "BeastHammerAdded", theirChar.ChildAdded:Connect(childAdded))
        childAdded(theirChar:FindFirstChild("Hammer"))
    end)
    table.insert(C.PlayerAddedEventFuncts, function(theirPlr, wasAlreadyIn)
        local theTSM = theirPlr:WaitForChild("TempPlayerStatsModule")
        local isMe = theirPlr == C.plr

        local isBeastVal = theTSM:WaitForChild("IsBeast")
        local hpVal = theTSM:WaitForChild("Health")
        local escapedVal = theTSM:WaitForChild("Escaped")
        local ragdollVal = theTSM:WaitForChild("Ragdoll")
        local capturedVal = theTSM:WaitForChild("Captured")
        local function beastChangedVal(newVal)
            C.FireEvent(newVal and "BeastAdded" or "BeastRemoved",theirPlr == C.plr,theirPlr)
        end
        C.AddPlayerConnection(theirPlr,isBeastVal.Changed:Connect(beastChangedVal))
        if isBeastVal.Value then
            beastChangedVal(isBeastVal.Value)
        end
        local wasInGame = false
        local function healthChangedVal(newVal)
            local inGame = newVal > 0 and not escapedVal.Value
            if not wasInGame and inGame then
                C.FireEvent("SurvivorAdded",theirPlr == C.plr,theirPlr)
            elseif wasInGame and not inGame then
                C.FireEvent("SurvivorRemoved",theirPlr == C.plr,theirPlr)
            end
            wasInGame = inGame
        end
        C.AddPlayerConnection(theirPlr, hpVal.Changed:Connect(healthChangedVal))
        local function ragdollChangedVal(newVal)
            C.FireEvent(newVal and "RagdollAdded" or "RagdollRemoved", theirPlr == C.plr, theirPlr, theirPlr.Character)
        end
        C.AddPlayerConnection(theirPlr, ragdollVal.Changed:Connect(ragdollChangedVal))
        if ragdollVal.Value then
            ragdollChangedVal(ragdollVal.Value)
        end
        local function capturedChangedVal(newVal)
            C.FireEvent(newVal and "CapturedAdded" or "CapturedRemoved", theirPlr == C.plr, theirPlr, theirPlr.Character)
        end
        C.AddPlayerConnection(theirPlr, capturedVal.Changed:Connect(capturedChangedVal))
        if capturedVal.Value then
            ragdollChangedVal(capturedVal.Value)
        end
    end)




    function C.HitSurvivor(theirChar)
        if not theirChar.PrimaryPart then
            print('Hit stopped because {theirChar.Name} does not have a primary part!')
            return
        end
        local Dist=(C.Handle.Position-theirChar.PrimaryPart.Position).magnitude
        if Dist<18 then
            local closestPart, closestDist = nil, 14 -- Test Success: Hit Part Must Be < 8 Studs of Hammer
            for num, part in ipairs(theirChar:GetChildren()) do
                if part:IsA("BasePart") then
                    local testDist = (part.Position-C.Handle.Position).Magnitude
                    if testDist < closestDist then
                        closestPart, closestDist = part, testDist
                    end
                end
            end
            if closestPart then
                C.SetActionLabel(BotActionClone, `Hitting {theirChar.Name}`)
                C.HammerEvent:FireServer("HammerHit", closestPart)
                return true
            end
        end
    end
    function C.RopeSurvivor(theirChar)
        local Torso = theirChar:FindFirstChild("Torso")
        if C.CarriedTorso.Value and Torso then
            return
        end
        C.SetActionLabel(BotActionClone, `Roping {theirChar.Name}`)
        C.HammerEvent:FireServer("HammerTieUp",Torso,Torso.NeckAttachment.WorldPosition)
    end
    function C.RemoveRope()
        if not C.Hammer or not C.CarriedTorso then
            return
        end
        for s = 15, 1, -1 do
            if not C.CarriedTorso.Value then
                return
            end
            C.HammerEvent:FireServer("HammerClick", true)
            task.wait(.05)
        end
        warn(`[C.RemoveRope]: Failed to remove rope {C.CarriedTorso.Value} after 15 tries!`)
    end
    function C.CaptureSurvivor(theirChar)
        if C.BeastPlr ~= C.plr or C.BeastChar.CarriedTorso.Value==nil then
            return
        end
        C.SetActionLabel(BotActionClone, `Capturing {theirChar.Name}`)
        local function isCapsuleOpen(cap)
            return cap:FindFirstChild("PodTrigger") and cap.PodTrigger:FindFirstChild("CapturedTorso") and not cap.PodTrigger.CapturedTorso.Value
        end
        local capsule,closestDist=nil,math.huge
        for _, cap in ipairs(C.FreezingPods) do
            if isCapsuleOpen(cap) then
                local dist=(cap:GetPivot().Position-theirChar.PrimaryPart.Position).Magnitude
                if (dist<closestDist) then
                    capsule,closestDist=cap,dist
                end
            end
        end
        if not capsule then
            warn("[C.CaptureSurvivor]: Capsule Not Found For",theirChar,#C.FreezingPods,"Found!")
            return false, "Capsule Not Found"
        end
        C.LastCaptureTime = os.clock()
        task.wait(1/3)
        local Trigger = capsule:WaitForChild("PodTrigger",5)
        local ActionSign = Trigger and Trigger:FindFirstChild("ActionSign")
        for s=1,3,1 do
            local isOpened = ActionSign and (ActionSign.Value==11)
            if not Trigger or not ActionSign or not Trigger:FindFirstChild("CapturedTorso") then
                return
            elseif (Trigger and Trigger.CapturedTorso.Value~=nil) then
                break --we got ourselves a trapped survivor!
            elseif s~=1 then
                task.wait(.15)
            end
            if Trigger:FindFirstChild("Event") then
                C.RemoteEvent:FireServer("Input", "Trigger", true, Trigger.Event)
                C.RemoteEvent:FireServer("Input", "Action", true)
                if isOpened then
                    C.RemoteEvent:FireServer("Input", "Trigger", false)
                end
            end
        end
    end
    function C.RescueSurvivor(capsule)
        if not capsule or not capsule:FindFirstChild("PodTrigger")
					or not capsule.PodTrigger.CapturedTorso.Value then return end
        if C.char:FindFirstChild("Hammer")~=nil or C.myTSM.Health.Value <= 0 then return end
        local Trigger=capsule:FindFirstChild("PodTrigger")
        if not Trigger then return end
        C.SetActionLabel(BotActionClone, `Rescuing {capsule.PodTrigger.CapturedTorso.Value.Parent.Name}`)
        for s=5,1,-1 do
            if not workspace:IsAncestorOf(Trigger) then
                break
            elseif Trigger.CapturedTorso.Value==nil then
                return true
            end
            local isOpened=Trigger.ActionSign.Value==11
            C.RemoteEvent:FireServer("Input", "Trigger", true, Trigger.Event)
            C.RemoteEvent:FireServer("Input", "Action", true)
            if isOpened then
                C.RemoteEvent:FireServer("Input", "Trigger", false)
            end
            task.wait(.075)
            C.RemoteEvent:FireServer("Input", "Action", false)
            task.wait(.075)
        end
    end
    function C.WaitForHammer()
        while not C.Hammer or not C.CarriedTorso do
            task.wait(1)
        end
    end
end

return function(C,Settings)
    C.RemoteEvent = RS:WaitForChild("RemoteEvent")
    local LobbyOBWall
    if game.PlaceId == 893973440 then
        LobbyOBWall = workspace:WaitForChild("LobbyOBWall")
        SetUpGame(C,Settings)
    end
    function C.SelectPlayerType(meDefault, otherDefault)
        return {
            {
                Type = Types.Toggle,
                Title = "Me",
                Tooltip = "Whether or not this hack will target you",
                Layout = -10,Default=meDefault,
                Shortcut="Me",
                Activate = C.ReloadHack,
            },
            {
                Type = Types.Toggle,
                Title = "Others",
                Tooltip = "Whether or not this hack will target you",
                Layout = -9,Default=otherDefault,
                Shortcut="Others",
                Activate = C.ReloadHack,
            },
        }
    end
    C.myTSM = C.plr:WaitForChild("TempPlayerStatsModule")
    C.mySSM = C.plr:WaitForChild("SavedPlayerStatsModule")

    function C.GetPlayerListOfType(options)
        local list = {}
        for _, theirPlr in ipairs(PS:GetPlayers()) do
            if theirPlr == C.plr and options.ExcludeMe then
                continue
            end
            local theirTSM = theirPlr:FindFirstChild("TempPlayerStatsModule")
            if not theirTSM then
                --print("[C.GetPlayerListOfType]: No TSM Found",theirPlr)
                continue
            end
            local inGame, role = C.isInGame(theirPlr.Character)
            if (options.InGame == nil or inGame == options.InGame) and (options[role] == nil or options[role])
                and (options.Ragdoll == nil or options.Ragdoll == theirTSM.Ragdoll.Value)
                and (options.Captured == nil or options.Captured == theirTSM.Captured.Value) then
                table.insert(list, theirPlr)
            end
        end
        return list
    end
    local SharedHacks = GetSharedHacks(C, Settings)
    local function SendWaitRemoteEvent(retType, ...)
        local bindableEvent = Instance.new("BindableEvent")
        local rets
        local isWaiting = true
        local conn
        task.delay(4, function()
            if not isWaiting then
                return
            end
            isWaiting = false
            bindableEvent:Fire()
        end)
        conn = C.RemoteEvent.OnClientEvent:Connect(function(type,...)
            if type == retType then
                rets = {type,...}
                isWaiting = false
                bindableEvent:Fire()
            end
        end)
        C.RemoteEvent:FireServer(...)
        while isWaiting do
            bindableEvent.Event:Wait()
        end
        bindableEvent:Destroy()
        conn:Disconnect()
        if rets then
            return true, table.unpack(rets)
        else
            warn("Timeout occured for yield signal",retType,...)
            return false, "Timeout Occured"
        end
    end
    local SetsRarityValue = {
        [0] = 750, -- Unknown Rarity (Bundle)
        [1] = 100, -- Common Rarity (Crate)
        [2] = 200, -- Uncommon Rarity (Crate)
        [3] = 400, -- Rare Rarity (Crate)
        [4] = 700, -- Legendary Rarity (Crate)
    }
    function C.GetCreditsValue(sets)
        local value = 0
        for setName, qty in pairs(sets) do
            local ItemHammer = C.StringWait(RS,`ItemDatabase.{setName}`)
            local Rarity = ItemHammer:GetAttribute("Rarity")
            value += qty * (SetsRarityValue[Rarity] or -9999999999)
        end
        return value
    end
    function C.GetUserInventory(theirPlr)
        theirPlr = theirPlr or C.plr
        local RequestName = theirPlr == C.plr and "GetPlayerInventory" or "GetOtherPlayerInventory"

        if RequestName == "GetOtherPlayerInventory" and game.PlaceId == 893973440 then -- Cannot view inventory in main game!!
            return {}
        end

        local Success, Res, Inventory
        repeat
            Success, Res, Inventory = SendWaitRemoteEvent(RequestName, RequestName, RequestName=="GetOtherPlayerInventory" and theirPlr.UserId or nil)
            if not Success and not theirPlr.Parent then
                return {}
            end
        until Success
        local InventoryCount = {}

        for _, item in ipairs(Inventory) do
            InventoryCount[item] = (InventoryCount[item] or 0) + 1
        end
        InventoryCount["H0001"], InventoryCount["G0001"] = nil, nil
        return InventoryCount, #Inventory
    end
    local LevelingXpCurve
    function C.GetTotalXP(theirPlr)
        local theirSSM = theirPlr:WaitForChild("SavedPlayerStatsModule")
        LevelingXpCurve = LevelingXpCurve or C.require(RS:WaitForChild("LevelingXpCurve"))
        local TotXP = theirSSM.Xp.Value
        for s = 1, theirSSM.Level.Value, 1 do
            TotXP += LevelingXpCurve[s] or 4000
        end
        return TotXP
    end
    function C.GetSetsCount(Sets)
        local setsTotal = 0
        for key, qty in pairs(Sets) do
            if key:sub(1,1) == "H" then -- for hammers only
                setsTotal += math.min(qty, Sets["G" .. key:sub(2)] or 0)
            end
        end
        return setsTotal
    end
    function C.GetUserStats(theirPlr)
        local Results = {
            Assets = 0,
            Credits = 0,
            NetWorth = 0,
            XP = 0,
            Level = 0,
        }
        local theirSSM = theirPlr:WaitForChild("SavedPlayerStatsModule")
        if theirSSM then
            local UserInventory = C.GetUserInventory(theirPlr)
            Results.Assets = C.GetCreditsValue(UserInventory)
            Results.Sets = C.GetSetsCount(UserInventory)
            Results.Credits = theirSSM.Credits.Value
            Results.NetWorth = Results.Assets + Results.Credits
            Results.XP = C.GetTotalXP(theirPlr)
            Results.Level = theirSSM.Level.Value
        end
        return Results
    end
    -- COMMANDS --
    table.insert(C.InsertCommandFunctions,function()
        return {
            ["addwhitelist"] = {
                Parameters={{Type="Player", ExcludeMe = true}},
                Alias = {},
                AfterTxt = "",
                Priority = -1000,
                Run = function(self, args)
                    local list = C.hackData.FleeTheFacility.InstaTrade.whitelistedUsers
                    if not C.TblAdd(list, args[1][1].Name:lower()) then
                        return false, `{args[1][1].Name} is already in the list`
                    end
                    return true
                end,
            },
            ["removewhitelist"] = {
                Parameters={{Type="Player", ExcludeMe = true}},
                Alias = {},
                AfterTxt = "",
                Priority = -1000,
                Run = function(self, args)
                    local list = C.hackData.FleeTheFacility.InstaTrade.whitelistedUsers
                    if not C.TblRemove(list, args[1][1].Name) then
                       return false, `{args[1][1].Name} is not whitelisted!`
                    end
                    return true
                end,
            },
            ["findtrader"] = {
                Parameters={{Type="User"}},
                Alias = {},
                AfterTxt = " %s in %.1fs",
                Priority = -7,
                Run = function(self,args)
                    local SearchUser = args[1][1]:lower()
                    local TimeStart = os.clock()
                    local TradeLocalScript = C.PlayerGui:FindFirstChild("TradePostMenuLocalScript", true)
                    if TradeLocalScript then
                        TradeLocalScript.Enabled = false
                    end

                    local result, signal, dict = SendWaitRemoteEvent("ReceiveTradingPostPlayersList", "RequestTradingPostPlayersList")
                    if not result then
                        return true, `Failed Getting From Server: {signal}`, os.clock() - TimeStart
                    end
                    if SearchUser:lower() == "random" then
                        local namesList = C.GetRandomDict(dict).Val.namesList
                        SearchUser = namesList[C.Randomizer:NextInteger(1,#namesList)]
                    end
                    local found, count = false, 0
                    for gameID, data in pairs(dict) do
                        count+=1
                        for key, val in ipairs(data.namesList) do
                            if val:lower() == SearchUser then
                                found = true
                                break
                            end
                        end
                        if found then
                            task.spawn(function()
                                if C.Prompt(`Join {SearchUser} In Trading? ({#data.namesList} Players)`, table.concat(data.namesList,"\t"), "Y/N") == true then
                                    C.ServerTeleport(1738581510,gameID)
                                end
                            end)
                            found = gameID
                            break
                        end
                    end
                    if TradeLocalScript and TradeLocalScript.Parent then
                        TradeLocalScript.Enabled = true
                    end
                    return true, found and `In {found}` or `Not Found`, os.clock() - TimeStart
                end,
            },
            ["stats"] = {
                Parameters={{Type="Players"}},
                Alias = {},
                AfterTxt = " Results in %.1fs:\n%s",
                Priority = -7,
                Run = function(self, args)
                    local clockStart = os.clock()
                    local displayTxt = ``
                    for num, theirPlr in ipairs(C.sortPlayersByXPThenCredits(args[1])) do
                        if num ~= 1 then
                            task.wait(1/20)
                        end
                        local Stats = C.GetUserStats(theirPlr)
                        displayTxt = displayTxt .. `({Stats.Level}) {theirPlr.Name}:\n`
                        Stats.Level = nil
                        for key, val in pairs(Stats) do
                            displayTxt = displayTxt .. `\t{key}: {C.FormatLargeNumber(val)}\n`
                        end
                    end
                    return true, os.clock() - clockStart, displayTxt
                end,
            }
        }
    end)
    -- MAIN GAME --
    if game.PlaceId ~= 1738581510 then
        do
            --local BeastCaveBaseplate = workspace:WaitForChild("BeastCaveBaseplate")
            function C.isInGame(theirChar,isDefacto)
                local theirPlr = theirChar and PS:GetPlayerFromCharacter(theirChar)
                if not theirChar or not theirPlr then
                    return false, "Lobby"
                end
                local theirTSM = theirPlr:WaitForChild("TempPlayerStatsModule")
                if theirChar:FindFirstChild("Hammer") or theirTSM.IsBeast.Value then
                    return true, "Beast"
                elseif theirTSM.Health.Value > 0 then
                    return true, "Survivor"
                elseif isDefacto then
                    local Location = theirChar:GetPivot().Position
                    if C.IsInBox(LobbyOBWall.CFrame, LobbyOBWall.Size, Location, true) then
                        return false, "Lobby"
                    else
                        return true, "Survivor"
                    end
                else
                    return false, "Lobby"
                end
            end
        end
        return {
            Category = {
                Name = "FleeTheFacility",
                Title = "Flee The Facility",
                Image = nil, -- Set to nil for game image
                Layout = 20,
            },
            Tab = AppendToFirstArr(SharedHacks, AppendToFirstArr({
                {
                    Title = "Auto Hit",
                    Tooltip = "Automatically ropes nearby survivors",
                    Layout = 1,
                    Shortcut = "AutoHit",Threads={},
                    Events = {
                        GameAdded = function(self)
                            while true do
                                C.WaitForHammer()
                                for _, theirPlr in ipairs(C.GetPlayerListOfType({Survivor=true,Lobby=false,Beast=false})) do
                                    if C.CanTarget(self, C.BeastPlr) and theirPlr.Character then
                                        C.HitSurvivor(theirPlr.Character)
                                    end
                                end
                                task.wait(1/2)
                            end
                        end,
                        RagdollRemoved = function(self, theirChar)
                            local theirPlr = PS:GetPlayerFromCharacter(theirChar)
                            if theirPlr and C.CanTarget(self, C.BeastPlr) and theirPlr.Character then
                                C.HitSurvivor(theirPlr.Character)
                            end
                        end,
                    },
                    Options = AppendToFirstArr({

                        },
                        C.SelectPlayerType(true, false)
                    )
                },
                {
                    Title = "Auto Rope",
                    Tooltip = "Automatically ropes nearby survivors",
                    Layout = 1,
                    Shortcut = "AutoRope",
                    Events = {
                        RagdollAdded = function(self, theirPlr, theirChar)
                            C.WaitForHammer()
                            if C.CanTarget(self, C.BeastPlr) then
                                C.RopeSurvivor(theirChar)
                            end
                        end,
                        BeastRopeRemoved = function(self)
                            if not C.CanTarget(self, C.BeastPlr) then
                                return
                            end
                            if not C.LastCaptureTime or (os.clock() - C.LastCaptureTime) < 1 then
                                for _, theirPlr in ipairs(C.GetPlayerListOfType({Ragdoll=true})) do
                                    self.Events.RagdollAdded(self, theirPlr, theirPlr.Character)
                                end
                            end
                        end,
                    },
                    Options = AppendToFirstArr({

                        },
                        C.SelectPlayerType(true, false)
                    )
                },
                {
                    Title = "Auto No Rope",
                    Tooltip = "Automatically removes rope after a delay",
                    Layout = 4,
                    Shortcut = "AutoRemoveRope",
                    Events = {
                        BeastRopeAdded = function(self, theirChar)
                            if C.CanTarget(self, C.BeastPlr) then
                                C.RemoveRope()
                            end
                        end,
                    },
                    Options = AppendToFirstArr({

                        },
                        C.SelectPlayerType(false, true)
                    )
                },
                {
                    Title = "🔨Auto Capture",
                    Tooltip = "Capture survivors when roped (BEAST ONLY)",
                    Layout = 3,
                    Shortcut = "AutoCapture",Functs={},
                    Activate = function(self, newValue, firstRun)
                        if firstRun or not newValue then
                            return
                        end
                        if C.CarriedTorso and C.BeastPlr == C.plr and C.CarriedTorso.Value then
                            self.Events.MyBeastRopeAdded(self, C.CarriedTorso.Value.Parent)
                        end
                    end,
                    Events = {
                        MyBeastRopeAdded = function(self,theirChar)
                            C.CaptureSurvivor(theirChar)
                        end,
                    },
                },
                {
                    Title = "⛹️Auto Rescue",
                    Tooltip = "Capture survivors when roped (SURVIVOR ONLY)",
                    Layout = 4,
                    Shortcut = "AutoRescue",Functs={},Threads = {},
                    Activate = function(self, newValue, firstRun)
                        if not newValue or firstRun then
                            return
                        end
                        --print("Activated with",#C.FreezingPods,"Pods!")
                        for _, freezePod in ipairs(C.FreezingPods) do
                            table.insert(self.Threads,task.spawn(self.Events.NewFreezingPod, self, freezePod))
                        end
                    end,
                    Events = {
                        NewFreezingPod = function(self, freezePod)
                            local PodTrigger = freezePod and freezePod:WaitForChild("PodTrigger",100)
                            local CapturedTorso = PodTrigger and PodTrigger:WaitForChild("CapturedTorso",300)
                            if CapturedTorso then
                                table.insert(self.Functs, CapturedTorso.Changed:Connect(function()
                                    C.RescueSurvivor(freezePod)
                                end) or false)
                                if CapturedTorso.Value then
                                    table.insert(self.Threads, task.spawn(C.RescueSurvivor,freezePod))
                                end
                            end
                        end,
                    }
                },
                {
                    Title = "Slow Beast",
                    Tooltip = "Permanently slows the beast",
                    Layout = 5,
                    Shortcut = "SlowBeast",
                    Threads = {},
                    Events = {
                        BeastAdded = function(self)
                            if not C.CanTarget(self, C.BeastPlr) then
                                return
                            end
                            local BeastEvent = C.StringWait(C.BeastChar, "BeastPowers.PowersEvent", 5)
                            while BeastEvent do
                                BeastEvent:FireServer("Jumped");
                                RunS.RenderStepped:Wait()
                            end
                        end,
                    },
                    Options = AppendToFirstArr({

                        },
                        C.SelectPlayerType(false, true)
                    )
                },
                {
                    Title = "🔨Crawl",
                    Tooltip = "Always allow the beast to crawl, and go through vents!",
                    Layout = 6,
                    Shortcut = "BeastCrawl",
                    Activate = function(self, newValue)
                        local OldIndex
                        OldIndex = C.HookMethod("__index",self.Shortcut,newValue and function(theirScript,index,self,...)
                            if OldIndex(self, "Name") == "DisableCrawl" then
                                return "Spoof", {false}
                            end
                        end,{"value"})
                        C.firesignal(C.myTSM.DisableCrawl.Changed)
                    end,
                    Threads = {},
                    Events = {
                        MyBeastHammerAdded = function(self)
                            for num, ventPart in ipairs(C.Map:GetDescendants()) do
                                if ventPart.Name == "VentBlock" or ventPart.Name == "VentBlocks" then
                                    ventPart:Destroy()
                                end
                            end
                        end,
                    }
                },
                {
                    Title = "Utility",
                    Tooltip = "Automatically does actions, such as rescuing a survivor or hacking a PC",
                    Layout = 9,
                    Threads = {}, Functs = {},
                    Default = true,
                    Shortcut = "FTFUtility",
                    MinigameActivate = function(self)
                        local minigameResultVal = C.myTSM:WaitForChild("MinigameResult")
                        local function updateMiniGameResult()
                            if not minigameResultVal.Value then
                                C.RemoteEvent:FireServer("SetPlayerMinigameResult", true)
                            end
                        end
                        table.insert(self.Functs,minigameResultVal.Changed:Connect(updateMiniGameResult))
                        updateMiniGameResult()
                        while true do
                            while not C.plr.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("TimingCircle").Visible do
                                C.plr.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("TimingCircle"):GetPropertyChangedSignal("Visible"):Wait()
                            end
                            while C.plr.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("TimingCircle").Visible do
                                if C.PlayerGui.ScreenGui.TimingCircle.TimingPin.Rotation>=C.PlayerGui.ScreenGui.TimingCircle.TimingBase.Rotation+45 then
                                    C.myTSM.ActionInput.Value=true
                                end
                                RunS.PreRender:Wait()
                                --C.PlayerGui.ScreenGui.TimingCircle.TimingPin:GetPropertyChangedSignal("Rotation"):Wait()
                            end
                            C.myTSM.ActionInput.Value=false
                        end
                    end,
                    Activate = function(self, newValue, firstRun)
                        if not newValue then
                            return
                        end
                        if self.EnTbl.Minigame then
                            table.insert(self.Threads, task.spawn(self.MinigameActivate, self))
                        end
                    end,
                    Events = {},
                    Options = {
                        {
                            Type = Types.Toggle,
                            Title = "Minigame",
                            Tooltip = "Whether or not minigame is enabled for hacking computers",
                            Layout = 1,Default=true,
                            Shortcut="Minigame",
                            Activate = C.ReloadHack
                        },
                    },
                },
                {
                    Title = "Spectate",
                    Tooltip = "Always allows spectate, even while in game or in lobby",
                    Layout = 10,
                    Shortcut = "Spectate",
                    Activate = function(self, newValue)
                        local toStr = tostring
                        local myTSM = C.myTSM
                        local isAncestorOf = myTSM.IsAncestorOf
                        local traceback = debug.traceback
                        local find = string.find

                        local lobbyPlrs = self.EnTbl.LobbyPlayers
                        local OldIndex
                        OldIndex = C.HookMethod("__index",self.Shortcut,newValue and function(theirScript,index,self,...)
                            if (toStr(theirScript) == "LocalGuiScript") then
                                local isMe = isAncestorOf(myTSM, self)
                                local traceback = traceback()
                                for _, val in ipairs({704, 712, 726, 712, 735, 739}) do
                                    if find(traceback,toStr(val)) then
                                        local theValue = toStr(self)
                                        if theValue == "Health" then
                                            local spoofHP = (isMe and 0) or ((lobbyPlrs or not rawget(C, "GameActive")) and 100)
                                            if spoofHP then
                                                return "Spoof", {spoofHP}
                                            end
                                        elseif theValue == "IsBeast" and isMe then
                                            return "Spoof", {false}
                                        end
                                    end
                                end
                            end
                        end,{"value"})

                        local DefaultLighting = RS:WaitForChild("DefaultLightingSettings")
                        --for num, funct in ipairs(C.GetFunctionsWithName({Name="ChangeLightingSettings"})) do
                        --    local Old
                        --    --local TargetLighting = DefaultLighting
                        --    Old = C.HookFunc(funct, self.Shortcut, function(lightInstance)
                        --        --if C.isInGame(C.Camera.CameraSubject and C.Camera.CameraSubject.Parent, true) then
                        --            --lightInstance = C.Map and C.Map:FindFirstChild("_LightingSettings")
                        --        --else
                        --            lightInstance = RS.DefaultLightingSettings
                        --        --end
                        --        return Old(lightInstance)
                        --    end)
                        --end
                        local OldNamecall
                        local FindChild = workspace.FindFirstChild
                        OldNamecall = C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,name,recursive)
                            if name == "_LightingSettings" or name == "DefaultLightingSettings" then
                                local subject = C.Camera.CameraSubject
                                if not subject then
                                    return
                                end
                                local isInGame = not C.IsInBox(LobbyOBWall.CFrame, LobbyOBWall.Size, subject.Parent:GetPivot().Position, true)
                                if isInGame then
                                    local Ret = C.Map and FindChild(C.Map, "_LightingSettings") or nil
                                    return "Spoof", {Ret}
                                else
                                    return "Spoof", {DefaultLighting}
                                end
                            end
                        end,{"findfirstchild"})
                    end,
                    Options = {
                        {
                            Type = Types.Toggle,
                            Title = "Lobby Players",
                            Tooltip = "Whether or not to spectate other lobby players WHEN A GAME IS IN PROGRESS",
                            Layout = 2,Default=false,
                            Shortcut="LobbyPlayers",
                            Activate = C.ReloadHack,
                        },
                    },
                    Events = {
                        MyCharAdded=function(self,theirPlr,theirChar,firstRun)
                            if firstRun then return end
                            C.DoActivate(self,self.Activate,self.RealEnabled)
                        end,
                    }
                },
            }, table.find(C.BotUsers, C.plr.Name:lower()) and {
                {
                    Title = "Server Farm",
                    Tooltip = "Verifies that the whole server is a bot, and if so, proceeds by grinding credits and xp for the whole server",
                    Layout = 100,
                    Shortcut = "ServerBot",Functs={}, Threads={}, Default=true,
                    WasRunning = false,
                    FreezeMyself = function(self,canRun,canCapture)
                        while C.BeastChar do
                            local i = 0
                            while ((C.BeastChar and C.BeastChar:FindFirstChild("HumanoidRootPart"))) do
                                i+=1
                                if i==10 then
                                    i = 0
                                elseif i>1 then
                                    RunS.RenderStepped:Wait()
                                end
                                if not canCapture or canCapture() then
                                    if not canRun(true) then
                                        return
                                    end
                                    local inRange = (C.BeastChar:GetPivot().Position-C.char:GetPivot().Position).Magnitude<6
                                    if not inRange then
                                        if not C.myTSM.Captured.Value and (not C.myTSM.Ragdoll.Value or (C.CarriedTorso
                                            and (C.CarriedTorso.Value and C.CarriedTorso.Value.Parent)~=C.char)) then
                                            C.DoTeleport(C.BeastChar:GetPivot()*Vector3.new(0,0,-4))
                                        end
                                    else
                                        if not C.myTSM.Ragdoll.Value and C.BeastChar and C.BeastChar.Parent and C.char:FindFirstChild("Head") then
                                            C.HammerEvent:FireServer("HammerHit", C.char.Head)
                                        end
                                        if not canRun(true) then
                                            return
                                        end
                                        if C.myTSM.Ragdoll.Value and C.BeastChar and C.BeastChar.Parent
                                            and (C.CarriedTorso.Value and C.CarriedTorso.Value.Parent)~=C.char then
                                            C.RopeSurvivor(C.char)
                                        end
                                    end
                                end
                            end
                            RunS.RenderStepped:Wait()
                        end
                    end,
                    HasVerification = function()
                        for num, theirPlr in ipairs(C.GetPlayerListOfType({Survivor = true,Beast=true,Lobby=false})) do
                            if not table.find(C.BotUsers, theirPlr.Name:lower()) then
                                return false
                            end
                        end
                        return true
                    end,
                    StartSurvivor = function(self, actionClone, info)
                        if self.EnTbl.RunType == "Capture" then
                            C.SetActionLabel(actionClone,"[Idle] Waiting To Get Captured")
                        elseif self.EnTbl.RunType == "Rescue" then
                            local function canRun(fullLoop)
                                local runnerPlrs = C.GetPlayerListOfType({Survivor = true,Beast=false,Lobby=false})
                                C.sortPlayersByXPThenCredits(runnerPlrs)
                                if #runnerPlrs == 0 then
                                    task.spawn(self.Completed, self, false)
                                    return false
                                end
                                self.SurvivorList = runnerPlrs
                                self.myKey = table.find(self.SurvivorList,C.plr)
                                self.rescueKey = (self.myKey%#self.SurvivorList) + 1

                                local Ret1 = (C.char and C.human and C.human.Health>0 and C.char:FindFirstChild("HumanoidRootPart") and C.Hammer)
                                local Ret2 = ((select(2,C.isInGame(C.char))=="Survivor") and not C.Cleared)
                                return (Ret1 and Ret2)
                            end
                            canRun()
                            --print("Runners",self.SurvivorList)
                            table.insert(self.Threads,task.spawn(function()
                                while canRun(true) and not C.plr:GetAttribute("HasRescued") do
                                    --local GuyToRescueIndex = (myKey%#self.SurvivorList)+1--gets next index and loops over array
                                    local myGuyToRescuePlr = self.SurvivorList[self.rescueKey]
                                    if myGuyToRescuePlr and myGuyToRescuePlr.TempPlayerStatsModule.Captured.Value then
                                        --print("My guy was captured!")
                                        local targetCapsule
                                        for _, capsule in ipairs(C.FreezingPods) do
                                            if capsule:FindFirstChild("PodTrigger")~=nil and capsule.Parent then
                                                local capturedTorso = capsule.PodTrigger.CapturedTorso.Value
                                                if capturedTorso and capturedTorso.Parent and capturedTorso:IsDescendantOf(myGuyToRescuePlr.Character) then
                                                    targetCapsule=capsule
                                                    break
                                                end
                                            end
                                        end
                                        if targetCapsule then
                                            local Freed = C.RescueSurvivor(targetCapsule)
                                            if Freed then
                                                C.plr:SetAttribute("HasRescued", true)
                                                break
                                            end
                                            --print("Found Pod, Freeing Status:",Freed)
                                        end
                                    end
                                    RunS.RenderStepped:Wait()
                                end
                                --print("FInished Rescue!")
                            end))
                            local function canCapture()
                                --task.wait(1.5)
                                local keyNeeded = 1
                                for key, theirPlr in ipairs(self.SurvivorList) do
                                    if not theirPlr:GetAttribute("HasCaptured") then
                                        keyNeeded = key
                                        break
                                    end
                                end
                                local Result = (self.myKey==keyNeeded and not C.plr:GetAttribute("HasCaptured")) or C.plr:GetAttribute("HasRescued") or #self.SurvivorList==1
                                --print("CanCapture Called2:", Result, "---",
                                    --myRunerPlrKey,keyNeeded,C.plr:GetAttribute("HasCaptured"),C.plr:GetAttribute("HasRescued"))
                                return Result
                            end
                            self:FreezeMyself(canRun,canCapture)
                        else
                            warn(`[Server Farm]: Unknown RunType: {self.EnTbl.RunType}`)
                        end
                    end,
                    StartBeast = function(self, actionClone, info)
                        if self.EnTbl.RunType == "Capture" then
                            while true do
                                local MyList = C.GetPlayerListOfType({Survivor = true, Captured = false, ExcludeMe = true})
                                for _, theirPlr in ipairs(MyList) do
                                    local TSM = theirPlr:FindFirstChild("TempPlayerStatsModule")
                                    if not TSM then
                                        return
                                    end
                                    local i = 0
                                    while theirPlr and theirPlr.Parent and not TSM.Captured.Value do
                                        if i%12 == 0 then
                                            C.CommandFunctions.teleport:Run({{theirPlr}})
                                        end
                                        RunS.RenderStepped:Wait()
                                        i+=1
                                    end
                                end
                                if #MyList == 0 then
                                    task.wait(1)
                                end
                            end
                        elseif self.EnTbl.RunType == "Rescue" then
                            C.SetActionLabel(actionClone,"[Idle]")
                        else
                            warn(`[C.StartBeast]: Unknown Implementation for StartBeast: {self.EnTbl.RunType}`)
                        end
                    end,--game:GetService("Players").ItsAGoodGameBros.PlayerGui.MenusScreenGui.TradePostMenuWindow.TradePostMenuLocalScript
                    DoOverrides = function(self, toggle, role)
                        --toggle = toggle and self.EnTbl.RunType == "Survivor"
                        C[role == "Beast" and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoHit,self.Shortcut)
                        C[role == "Beast" and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoRope,self.Shortcut)
                        C[role == "Beast" and "AddOverride" or "RemoveOverride"](C.hackData.FleeTheFacility.AutoCapture,self.Shortcut)
                        C[toggle and "AddOverride" or "RemoveOverride"](C.hackData.Blatant.Fly,self.Shortcut)
                        self.WasRunning = toggle
                    end,
                    --ResetThread = nil,
                    StartUp = function(self, gameOver)
                        C.RemoveAction(self.Shortcut)
                        C.getgenv().Rescued = nil
                        self.SurvivorList = nil
                        if gameOver or not C.BeastChar or not C.char or not C.isInGame(C.char) or not self.RealEnabled or not self:HasVerification() then
                            --print("Disabled: ",C.char,C.BeastChar,C.isInGame(C.char),self.RealEnabled)
                            return self:DoOverrides(false)-- No beast no hoes
                        end
                        local inGame, role = C.isInGame(C.char)
                        if inGame then
                            self:DoOverrides(true, role)
                            local myActionClone
                            myActionClone = C.AddAction({Title=`{self.EnTbl.RunType} ({role})`, Name = self.Shortcut, Threads = {}, Time = function(actionClone, info)
                                table.insert(info.Threads, task.delay(30, function()
                                    if myActionClone ~= BotActionClone or C.GetAction(info.Name) ~= info then
                                        return
                                    end
                                    C.CreateSysMessage(`[Flee.ServerFarm]: System Timeout For One Game Occured Of 30 Seconds; Resetting Activated!`)
                                    warn(`System Timeout For One Game Occured Of 30 Seconds; Resetting Activated!`)
                                    --C.ResetCharacter()
                                end))
                                self["Start"..role](self, actionClone, info)

                            end, Stop = function(byReq)
                                if BotActionClone == myActionClone then
                                    BotActionClone = nil
                                end
                                if byReq then
                                    --print("Disabled by request!")
                                    C.DoActivate(self, self.Activate, self.RealEnabled, false)
                                end
                            end})
                            BotActionClone = myActionClone
                        end
                    end,
                    Activate = function(self, newValue, firstRun)
                        --self.ResetThread = nil
                        self:StartUp()
                    end,
                    Completed = function(self)
                        -- Finished on its own --
                        --print(debug.traceback("GAME OVER"))
                        self:StartUp(true)
                        C.getgenv().Rescued = nil
                        self.SurvivorList = nil
                        --C.DoActivate(self, self.Activate, self.RealEnabled, false)
                        for _, theirPlr in ipairs(PS:GetPlayers()) do
                            theirPlr:SetAttribute("HasRescued",nil)
                            theirPlr:SetAttribute("HasCaptured",nil)
                            --theirPlr:SetAttribute("BeenRescued",nil)
                        end
                        --task.delay(2, C.DoTeleport, workspace.SpawnLocation:GetPivot())
                        --task.spawn(C.ResetCharacter)
                    end,
                    Events = {
                        BeastHammerAdded = function(self,theirPlr,theirChar,theirHuman)
                            self:StartUp()
                        end,
                        MySurvivorRemoved = function(self)
                            self:Completed()
                        end,
                        MyBeastHammerRemoved = function(self)
                            self:Completed()
                        end,
                        GameRemoved = function(self)
                            self:Completed()--C.ClearThreadTbl(self.Threads)
                        end,
                        MapRemoved = function(self)
                            self:Completed()
                        end,
                        CapturedAdded = function(self, theirPlr, theirChar)
                            theirPlr:SetAttribute("HasCaptured", true)
                        end,
                        CapturedRemoved = function(self, theirPlr, theirChar)
                            -- Attribute it to that player
                            if self.SurvivorList then
                                local theirKey = table.find(self.SurvivorList, theirPlr)
                                if not theirKey then
                                    --warn("Survivor",theirPlr,"has no associated survivor key??")
                                    return
                                end
                                local theirKeyPlusOne = ((theirKey-2)%#self.SurvivorList) + 1
                                self.SurvivorList[theirKeyPlusOne]:SetAttribute("HasRescued", true)
                                --theirPlr:SetAttribute("BeenRescued",true)
                                --print(self.SurvivorList[theirKeyPlusOne],"Rescued",theirPlr.Name,self.SurvivorList,theirKey,theirKeyPlusOne)
                            end
                        end,
                    },
                    Options = {
                        {
                            Type = Types.Dropdown,
                            Title = "Run Type",
                            Tooltip = "Which ServerFarm type to run",
                            Layout = 1, Default = "Rescue",
                            Shortcut="RunType",
                            Selections = {"Capture","Rescue"},
                            Activate = C.ReloadHack,
                        },
                    },
                }


            } or {}))
        }
    end

	return {
		Category = {
			Name = "FleeTheFacility",
			Title = "Flee The Facility",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab =
            AppendToFirstArr(SharedHacks,{
                {
                    Title = "Insta Trade",
                    Tooltip = "Automatically trades with \"trusted\" users!",
                    Layout = 1,
                    Shortcut = "InstaTrade",Functs={}, Threads={}, Instances = {},Default=false,
                    whitelistedUsers = {"queen_bestiesforlife","itsagoodgamebros","facilitystorage","z_baeby","yvettecarreno08","kitcat4681"},
                    lastSend = 0,
                    IsAllowed = function(self,theirPlr)
                        if theirPlr == C.plr then
                            return false
                        end
                        return table.find(self.whitelistedUsers,theirPlr.Name:lower()) or table.find(C.AdminUsers, theirPlr.Name:lower())
                    end,
                    GetItemListing = function(self, internalName)
                        for name, listings in pairs(self.SendTypeIdentifiers) do
                            if table.find(listings, internalName) then
                                return name
                            end
                        end
                        return "Unlisted"
                    end,
                    GetTradableItems = function(self, tradePlr)
                        local theirInventory = C.GetUserInventory(tradePlr)
                        local sendType = self.EnTbl.SendType

                        local myInventory = C.GetUserInventory()
                        for name, count in pairs(myInventory) do
                            local newCount = math.min(count - self.EnTbl.KeepAmount, 10 - (theirInventory[name] or 0))
                            if sendType ~= "Any" and sendType ~= self:GetItemListing(name) then
                                newCount = 0
                            end
                            myInventory[name] = newCount>0 and newCount or nil
                        end
                        print(tradePlr,#myInventory)
                        return myInventory
                    end,
                    Activate = function(self,newValue,firstRun)
                        if not newValue then
                            return
                        end
                        local ReceiveEvent=Instance.new("BindableEvent")
                        table.insert(self.Instances, ReceiveEvent)

                        local IsTrading = false
                        local tradePlr, lastTradePlr
                        local function RemoteEventReceivedFunction(main,sec,third)
                            if main=="StartTradeCoolDown" then
                                self.lastSend=os.clock()
                            end
                            if main=="RecieveTradeRequest" and not IsTrading then
                                tradePlr=PS:GetPlayerByUserId(sec)
                                lastTradePlr = tradePlr
                                if self:IsAllowed(tradePlr) then
                                    IsTrading = true
                                    C.RemoteEvent:FireServer("AcceptTradeRequest")
                                    print("Trade Accepted")
                                else
                                    C.RemoteEvent:FireServer("CancelTrade")
                                    print("Trade Denied:",tradePlr)
                                    IsTrading, tradePlr = false, nil
                                end
                            elseif main == "StartTrading" then
                                if not tradePlr then
                                    warn("StartTrading occured but unknown trading partner!")
                                    return
                                end
                                IsTrading = true
                                table.insert(self.Threads, task.spawn(function()
                                    local tradableItems = self:GetTradableItems(tradePlr)
                                    task.wait(1/2)
                                    if not self.EnTbl.ReceiveOnly then
                                        local ItemsToSend = 4
                                        local sendArr = {}
                                        for name, count in pairs(tradableItems) do
                                            while count > 0 do
                                                table.insert(sendArr,  name)
                                                count -=1
                                            end

                                            ItemsToSend -= 1
                                            if ItemsToSend == 0 then
                                                break
                                            end
                                        end
                                        C.RemoteEvent:FireServer("SendMyTradeOffer", sendArr)
                                    end
                                    task.wait(3)
                                    for s = 30, 1, -1 do
                                        if not IsTrading then
                                            return
                                        end
                                        C.RemoteEvent:FireServer("AcceptTradeOffer")
                                        task.wait(1/3)
                                    end
                                    print("Trade Timed Out!")
                                    C.RemoteEvent:FireServer("CancelTrade")
                                    IsTrading, tradePlr = false, nil
                                end))

                            elseif main == "TradeCancelled" then
                                print("Trade Cancelled!")
                                IsTrading, tradePlr = false, nil
                            elseif main == "TradeVerifying" then
                                print("Trade Successfully Complete!")
                                IsTrading = false
                                tradePlr = nil
                            end
                        end
                        table.insert(self.Functs,C.RemoteEvent.OnClientEvent:Connect(RemoteEventReceivedFunction))
                        C.RemoteEvent:FireServer("CancelTrade")
                        task.wait(2)
                        while self.EnTbl.AutoSend do
                            if IsTrading then
                                while IsTrading do
                                    task.wait(1)
                                end
                            end

                            for _, theirPlr in ipairs(PS:GetPlayers()) do
                                if self:IsAllowed(theirPlr) then
                                    local tradableItems = self:GetTradableItems(theirPlr)
                                    if (C.GetDictLength(tradableItems) > 0) then
                                        tradePlr = theirPlr
                                        break
                                    end
                                end
                            end
                            if not IsTrading and tradePlr then
                                if tradePlr then
                                    print("Sending Trade Request:",tradePlr)
                                    C.RemoteEvent:FireServer("SendTradeRequest", tradePlr.UserId)
                                elseif lastTradePlr then
                                    task.spawn(C.Prompt, `Trade Completed!`,`All necessary items were traded with {lastTradePlr.Name}`,`Ok`)
                                    lastTradePlr = nil
                                end
                                task.wait(3)
                            else
                                task.wait(1)
                            end
                        end

                    end,
                    Events = {},
                    Options = {
                        {
                            Type = Types.Slider,
                            Title = "Keep Amount",
                            Tooltip = "How many of each item to keep!",
                            Layout = 1,Default = 1,
                            Min = 0, Max=9, Digits=0,
                            Shortcut="KeepAmount",
                        },
                        {
                            Type = Types.Toggle,
                            Title = "Receive Only",
                            Tooltip = "Only allows receiving items, it will not trade any of your inventory",
                            Layout = 1,Default = false,
                            Shortcut="ReceiveOnly",
                        },
                        {
                            Type = Types.Toggle,
                            Title = "AutoSend",
                            Tooltip = "Enables auto sender so that it sends to the bot immediately!",
                            Layout = 2,Default = false,
                            Shortcut="AutoSend",
                            Activate = C.ReloadHack,
                        },
                        {
                            Type = Types.Dropdown,
                            Title = "Send Type",
                            Tooltip = "Specifies the type of items to send.",
                            Layout = 2,Default = false,
                            Shortcut="SendType",
                            Selections = {"Any", "Unlisted", "Halloween 2024"},
                            Activate = C.ReloadHack,
                        },
                    },
                    SendTypeIdentifiers={
                        ["Halloween 2024"] = {
                            [1] = "Ghal0075",
                            [2] = "Ghal0076",
                            [3] = "Ghal0077",
                            [4] = "Ghal0078",
                            [5] = "Ghal0079",
                            [6] = "Ghal0080",
                            [7] = "Ghal0081",
                            [8] = "Ghal0082",
                            [9] = "Ghal0083",
                            [10] = "Ghal0084",
                            [11] = "Hhal0075",
                            [12] = "Hhal0076",
                            [13] = "Hhal0077",
                            [14] = "Hhal0078",
                            [15] = "Hhal0079",
                            [16] = "Hhal0080",
                            [17] = "Hhal0081",
                            [18] = "Hhal0082",
                            [19] = "Hhal0083",
                            [20] = "Hhal0084",
                            [21] = "Ghal0091",
                            [22] = "Hhal0091",
                            [23] = "Ghal0087",
                            [24] = "Hhal0087",
                            [25] = "Ghal0086",
                            [26] = "Hhal0086",
                            [27] = "Ghal0093",
                            [28] = "Hhal0093",
                            [29] = "Ghal0094",
                            [30] = "Hhal0094",
                            [31] = "Ghal0089",
                            [32] = "Hhal0089",
                            [33] = "Ghal0090",
                            [34] = "Hhal0090",
                            [35] = "Ghal0092",
                            [36] = "Hhal0092",
                            [37] = "Ghal0088",
                            [38] = "Hhal0088",
                            [39] = "Ghal0085",
                            [40] = "Hhal0085",
                        },
                    },
                },
            }
        )
	}
end
]],
    ["Games/MurderMystery"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local HttpService = game:GetService("HttpService")
local PS = game:GetService("Players")
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local function Static(C, Settings)
    C.RoundTimerPart = workspace:WaitForChild("RoundTimerPart")
    function C.isInGame(theirChar)
        if not theirChar then
            return false, "Lobby", false
        end
		if theirChar and theirChar.Name == "InviClone" then
			theirChar = C.char
		end
		local player,human=PS:GetPlayerFromCharacter(theirChar), theirChar:FindFirstChild("Humanoid")
		if not player or not human or human:GetState() == Enum.HumanoidStateType.Dead or not C.GameInProgress then
			return false, "Lobby", false--No player, no team!
		end
        local defactoInGame = (theirChar:GetPivot().Position - C.RoundTimerPart.Position).Magnitude > 300
        local realInGame = player:GetAttribute("Alive")
        local hasGun = theirChar:FindFirstChild("Gun") or C.StringFind(player,"Backpack.Gun")
        local hasKnife = theirChar:FindFirstChild("Knife") or C.StringFind(player,"Backpack.Knife")

        if hasGun then
            return realInGame, "Sheriff", defactoInGame
        elseif hasKnife then
            return realInGame, "Murderer", defactoInGame
        end

		return defactoInGame, (defactoInGame or realInGame) and "Innocent" or "Lobby", defactoInGame
	end
    function C.GetMurderer()
        for num, theirChar in ipairs(CS:GetTagged("Character")) do
            if select(2,C.isInGame(theirChar)) == "Murderer" then
                return PS:GetPlayerFromCharacter(theirChar), theirChar
            end
        end
    end
    function C.GetSherrif()
        for num, theirChar in ipairs(CS:GetTagged("Character")) do
            if select(2,C.isInGame(theirChar)) == "Sheriff" then
                return PS:GetPlayerFromCharacter(theirChar), theirChar
            end
        end
    end

    table.insert(C.EventFunctions,function()
		local function MapAdded()
            C.Map = workspace:WaitForChild("Normal")
            C.FireEvent("MapAdded",nil,C.Map)
            C.AddObjectConnection(C.Map,"MapRemoved",C.Map.Destroying:Connect(function()
                C.FireEvent("MapRemoved",nil,C.Map)
                C.Map = nil
            end))
        end
        C.StringWait(RS,"Remotes.Gameplay.LoadingMap").OnClientEvent:Connect(MapAdded)
        if workspace:FindFirstChild("Normal") then
            MapAdded()
        end

        C.GameInProgress = game:GetService("Workspace").RoundTimerPart.SurfaceGui.Timer.Text ~= "1s"
        C.FireEvent("GameStatus",nil,C.GameInProgress)
        C.AddGlobalConnection(C.StringWait(RS,"Remotes.Gameplay.RoundStart").OnClientEvent:Connect(function(...)
            C.GameInProgress = true
            C.FireEvent("GameStatus",nil,C.GameInProgress)
        end))
        C.AddGlobalConnection(C.StringWait(RS,"Remotes.Gameplay.VictoryScreen").OnClientEvent:Connect(function(...)
            C.GameInProgress = false
            C.FireEvent("GameStatus",nil,C.GameInProgress)
        end))
    end)
end
return function(C,Settings)
    Static(C,Settings)

    return {
        Category = {
            Name = "MurderMystery",
            Title = "Murder Mystery 2",
            Image = nil, -- Set Image to nil in order to get game image!
            Layout = 20,
        },
        --game:GetService("Workspace").Normal.GunDrop
        Tab = {
            {
				Title = "Murderer Win",
				Tooltip = "As the murderer, kill every single person",
				Layout = 1,Type="NoToggle",
				Shortcut = "MurdererWin", Threads={},
				Activate = function(self,newValue)
                    C.RemoveAction(self.Shortcut)
                    if select(2,C.isInGame(C.char)) ~= "Murderer" then
                        return "Not Murderer"
                    end
                    C.AddOverride(C.hackData.Blatant.Noclip, self.Shortcut)
                    C.SavePlayerCoords(self.Shortcut)
                    local info = {Name=self.Shortcut,Tags={"RemoveOnDestroy"}}
                    local actionClone = C.AddAction(info)
                    local LastClick = os.clock() - .25
                    local Knife = C.StringFind(C.plr,'Backpack.Knife') or C.StringFind(C.char,'Knife')
                    for num, theirChar in ipairs(CS:GetTagged("Character")) do -- loop through characters
                        if theirChar == C.char then
                            continue--don't try and oof yourself, won't end well.
                        end
                        while info.Enabled and select(2,C.isInGame(C.char)) == "Murderer" do
                            local inGame = table.pack(C.isInGame(theirChar))
                            if not inGame[1] or not inGame[3] then
                                break
                            end
                            if Knife.Parent ~= C.char then
                                C.human:EquipTool(Knife)
                            end
                            C.DoTeleport(theirChar:GetPivot() * CFrame.new(0,-2,2)) -- Behind 2 studs
                            if not LastClick or os.clock() - LastClick > .5 then
                                Knife:WaitForChild("Stab"):FireServer("Slash")
                                LastClick = os.clock()
                            end
                            actionClone.Time.Text = `{theirChar.Name}`
                            RunService.RenderStepped:Wait()
                        end
                    end
                    C.human:UnequipTools()
                    C.RemoveAction(info.Name)
                    C.LoadPlayerCoords(self.Shortcut)
                    C.RemoveOverride(C.hackData.Blatant.Noclip, self.Shortcut)
				end,
				Options = {
					
				}
			},
            {
				Title = "Sheriff Win",
				Tooltip = "As the sheriff, kill the murderer",
				Layout = 2,Type="NoToggle",
				Shortcut = "SheriffWin", Threads={},
                FindFurtherDistance=function(self,charPosition)
                    local options = {
                        ignoreInvisibleWalls = false,
                        ignoreUncollidable = true,
                        ignoreList = {C.char},
                        raycastFilterType = Enum.RaycastFilterType.Exclude,
                        collisionGroup = C.hrp.CollisionGroup,
                        distance = 100 -- Set a large distance to find the maximum
                    }

                    local function getRaycastDirection(angle)
                        -- Convert angle to radians
                        local radians = math.rad(angle)
                        -- Calculate the direction vector in the xz plane
                        local direction = Vector3.new(math.cos(radians), 0, math.sin(radians))
                        return direction
                    end

                    local maxDistance = 0
                    local maxHitPosition = charPosition

                    for i = 0, 360, 360/12 do
                        local dir = getRaycastDirection(i)
                        local hitResult, hitPosition = C.Raycast(charPosition, dir + charPosition, options)
                        
                        local distance = (hitPosition - charPosition).Magnitude
                        if distance > maxDistance then
                            maxDistance = distance
                            maxHitPosition = hitPosition
                        end
                    end

                    return maxHitPosition
                end,
				Activate = function(self,newValue,firstRun)
                    C.RemoveAction(self.Shortcut)
                    if firstRun then
                        task.wait(1.5) -- Wait a bit for GetTagged("Character") load
                    end
                    if select(2,C.isInGame(C.char)) ~= "Sheriff" then
                        return "Not Sheriff"
                    end
                    C.AddOverride(C.hackData.Blatant.Noclip, self.Shortcut)
                    C.SavePlayerCoords(self.Shortcut)
                    local info = {Name=self.Shortcut,Tags={"RemoveOnDestroy"}}
                    local actionClone = C.AddAction(info)
                    actionClone.Time.Text = "Firing.."
                    local canShoot = true
                    local LastClick, LastTeleport = os.clock() - .7, os.clock() - .5
                    local ShotDelay = 0
                    local Gun = C.StringFind(C.plr,'Backpack.Gun') or C.StringFind(C.char,'Gun')
                    local RemoteFunction = C.StringWait(Gun,"KnifeLocal.CreateBeam.RemoteFunction")
                    for num, theirChar in ipairs(CS:GetTagged("Character")) do -- loop through characters
                        if theirChar == C.char then
                            continue--don't try and oof yourself, won't end well.
                        end
                        while info.Enabled and select(2,C.isInGame(C.char)) == "Sheriff" do
                            local inGame = table.pack(C.isInGame(theirChar))
                            if not inGame[1] or inGame[2] ~= "Murderer" or not inGame[3] then
                                break
                            end

                            --theirChar:GetPivot() * CFrame.new(0,-0,0.4)) -- Behind 2 studs
                            if not LastTeleport or os.clock() - LastTeleport >= 0 then
                                if Gun.Parent ~= C.char then
                                    C.human:EquipTool(Gun)
                                end
                                local hitCF = theirChar:GetPivot()
                                local offset = theirChar.PrimaryPart.AssemblyLinearVelocity/50
                                if offset.Magnitude < .1 then
                                    hitCF *= CFrame.new(0,0,5) -- Go five backwards
                                else
                                    hitCF -= offset -- Otherwise go behind em
                                end
                                --local hitCF = self:FindFurtherDistance(theirChar:GetPivot().Position)
                                if not canShoot then
                                    hitCF += Vector3.new(0,1,0) * 100
                                end
                                C.DoTeleport(hitCF)
                                if canShoot then
                                    task.wait(C.plr:GetNetworkPing() * 2)
                                end
                                
                                LastTeleport = os.clock()
                            end
                            if canShoot and (not LastClick or os.clock() - LastClick >= 1 + ShotDelay) then
                                canShoot = false
                                ShotDelay = C.Randomizer:NextNumber(C.GetMinMax(self.EnTbl.MinShotDelay,self.EnTbl.MaxShotDelay))
                                task.spawn(function()
                                    RemoteFunction:InvokeServer(1,theirChar:GetPivot().Position+theirChar.PrimaryPart.AssemblyLinearVelocity/50,"AH2")
                                    canShoot = true
                                end)
                                LastClick = os.clock()
                            end
                            actionClone.Time.Text = `{theirChar.Name}`
                            RunService.RenderStepped:Wait()
                        end
                        task.wait()
                    end
                    RunService.RenderStepped:Wait()
                    C.human:UnequipTools()
                    C.RemoveAction(info.Name)
                    C.LoadPlayerCoords(self.Shortcut)
                    C.RemoveOverride(C.hackData.Blatant.Noclip, self.Shortcut)
				end,
				Options = {
					{
						Type = Types.Slider,
						Title = "Min Delay",
						Tooltip = "How much ADDITIONAL minimum delay in between shots.",
						Layout = 1,Default=0,
						Min=0,Max=2,Digits=1,
						Shortcut="MinShotDelay",
					},
                    {
						Type = Types.Slider,
						Title = "Max Delay",
						Tooltip = "How much ADDITIONAL maximum delay in between shots.",
						Layout = 2,Default=0,
						Min=0,Max=2,Digits=1,
						Shortcut="MaxShotDelay",
					},
				}
			},
            {
				Title = "Gun Pickup",
				Tooltip = "As an innocent, pick up the sherrif's gun",
				Layout = 3,Type="NoToggle",
				Shortcut = "GunPickup", Threads={},
				Activate = function(self,newValue)
                    C.RemoveAction(self.Shortcut)
                    if select(2,C.isInGame(C.char)) ~= "Innocent" then
                        return "Not Innocent"
                    end
                    C.SavePlayerCoords(self.Shortcut)
                    local info = {Name=self.Shortcut,Tags={"RemoveOnDestroy"}}
                    local actionClone = C.AddAction(info)
                    local Gun = C.StringFind(C.Map,"GunDrop")
                    while Gun and Gun.Parent == C.Map and select(2,C.isInGame(C.char)) == "Innocent" and info.Enabled do
                        local MurdererPlr,Murderer = C.GetMurderer()
                        local Knife = Murderer and Murderer:FindFirstChild("Knife")
                        --[[if not Knife or (Knife.Position - C.GetMurderer():GetPivot().Position).Magnitude < 5 then
                            C.DoTeleport(Gun:GetPivot())
                        else
                            C.DoTeleport(C.RoundTimerPart:GetPivot()+Vector3.new(0,10000,0))
                        end--]]
                        C.firetouchinterest(C.hrp,Gun)
                        RunService.RenderStepped:Wait()
                    end
                    C.RemoveAction(info.Name)
                    C.LoadPlayerCoords(self.Shortcut)
                end,
            },
            {
				Title = "Auto Win",
				Tooltip = "Combines Gun Pickup, Sheriff/Murderer Win to make you when whenever possible.",
				Layout = 4, DontActivate = true,
				Shortcut = "AutoWin", Functs = {},
                Reset = function(self)
                    C.RemoveOverride(C.hackData.MurderMystery.MurdererWin,self.Shortcut)
                    C.RemoveOverride(C.hackData.MurderMystery.SheriffWin,self.Shortcut)
                    C.RemoveOverride(C.hackData.MurderMystery.GunPickup,self.Shortcut)
                    C.RemoveAction("MurdererWin")
                    C.RemoveAction("SheriffWin")
                    C.RemoveAction("GunPickup")
                end,
				Activate = function(self,newValue)
                    self:Reset()
                    if newValue and C.GameInProgress then
                        local Backpack = C.StringWait(C.plr, "Backpack")
                        local function BackpackAdded(newChild,notConn)
                            if newChild.Parent ~= C.plr:WaitForChild("Backpack") then
                                return -- not backpack
                            end
                            if newChild.Name == "Gun" and self.EnTbl.SheriffWinEn then
                                C.AddOverride(C.hackData.MurderMystery.SheriffWin,self.Shortcut)
                            elseif newChild.Name == "Knife" and self.EnTbl.MurdererWinEn then
                                C.AddOverride(C.hackData.MurderMystery.MurdererWin,self.Shortcut)
                            end
                        end
                        table.insert(self.Functs,Backpack.ChildAdded:Connect(BackpackAdded))
                        table.insert(self.Functs,C.char.ChildAdded:Connect(BackpackAdded))
                        for num, item in ipairs(Backpack:GetChildren()) do
                            task.spawn(BackpackAdded,item,true)
                        end
                        for num, item in ipairs(C.char:GetChildren()) do
                            task.spawn(BackpackAdded,item,true)
                        end
                        if self.EnTbl.GunPickupEn and C.Map then
                            local function MapAdded(newChild)
                                if newChild.Name == "GunDrop" and newChild.Parent == C.Map then
                                    C.AddOverride(C.hackData.MurderMystery.GunPickup,self.Shortcut)
                                end
                            end
                            workspace:WaitForChild("Normal",math.huge)
                            table.insert(self.Functs,C.Map.ChildAdded:Connect(MapAdded))
                            for num, item in ipairs(C.Map:GetChildren()) do
                                task.spawn(MapAdded,item)
                            end    
                        end
                    end
                end,
                Events = {
                    GameStatus = function(self,en)
                        task.spawn(C.ReloadHack,self)
                    end,
                },
                Options = {
                    {
						Type = Types.Toggle,
						Title = "Murderer Win",
						Tooltip = "Whether or not Murderer Win activates automatically.",
						Layout = 1,Default=true,
						Shortcut="MurdererWinEn",
                        Activate = C.ReloadHack,
					},
                    {
						Type = Types.Toggle,
						Title = "Sheriff Win",
						Tooltip = "Whether or not Sheriff Win activates automatically.",
						Layout = 2,Default=false,
						Shortcut="SheriffWinEn",
                        Activate = C.ReloadHack,
					},
                    {
						Type = Types.Toggle,
						Title = "Gun Pick Up",
						Tooltip = "Whether or not Gun Pick-Up activates automatically.",
						Layout = 3,Default=true,
						Shortcut="GunPickupEn",
                        Activate = C.ReloadHack,
					},
                }
            },
            {
				Title = "Unlock Emotes",
				Tooltip = "Unlocks every emote in the game and is visible to all",
				Layout = 90,Type="OneRun",
                Default = true,
                DontActivate = true, AlwaysFireEvents = true,
				Shortcut = "UnlockEmotes",
                DisableAttemptMsg = "Reset To Disable",
                EmotePageName = "Free Emotes",
                Activate = function(self,newValue)
                    local EmotesModule = C.require(C.StringWait(RS,"Modules.EmoteModule"))
                    if newValue then
                        EmotesModule.GeneratePage({"headless", "zombie", "zen", "ninja", "floss", "dab", "sit"}, EmotesModule.EmoteGUI, self.EmotePageName)
                        EmotesModule.ShowPage(self.EmotePageName)
                    end
                end,
                Events = {
                    MyCharAdded = function(self,myPlr,myChar,firstRun)
                        task.wait(5)
                        C.getgenv()["Hack/"..self.Parent.Category.Name.."/"..self.Shortcut] = false
                        if self.RealEnabled then
                            C.DoActivate(self,self.Activate,self.RealEnabled)
                        end
                    end,
                }
            },
            {
				Title = "Disable Killbricks",
				Tooltip = "Removes detection for the killbricks, and for the metal detector in the bank map",
				Layout = 100,Default=true,
				Shortcut = "DisableKillbricks",
                Activate = function(self,newValue)
                    self.Events.MapAdded(self)
                end, 
                Events = {
                    MapAdded = function(self)
                        if not C.Map then
                            return
                        end
                        local GlitchPoofs = C.Map:WaitForChild("GlitchProof",5)
                        if not GlitchPoofs then
                            return
                        end
                        local list = GlitchPoofs:GetChildren()
                        local Sensor = C.StringFind(C.Map,"Interactive.MetalDetector.Sensor")
                        if Sensor then
                            table.insert(list,Sensor)
                        end
                        for num, part in ipairs(list) do
                            if part:IsA("BasePart") then
                                if self.RealEnabled then
                                    C.SetPartProperty(part,"CanTouch",self.Shortcut,false)
                                else
                                    C.ResetPartProperty(part,"CanTouch",self.Shortcut)
                                end
                            end
                        end
                    end,
                }
            },
            {
				Title = "Bottom Part",
				Tooltip = "Adds a part at the lowest point in the map",
				Layout = 101, DontActivate = true, Default = true,
				Shortcut = "BottomPart", Functs = {}, Instances = {},
				Activate = function(self,newValue)
                    if C.Map and newValue then
                        self.Events.MapAdded(self,C.Map)
                    end
                end,
                Events = {
                    MapAdded = function(self,map)
                        local cf, size = (map:WaitForChild("Map",1e-3) or map:WaitForChild("Parts",1e-3)):GetBoundingBox()
                        local inviPart = Instance.new("Part")
                        inviPart.TopSurface = Enum.SurfaceType.Smooth
                        inviPart.BottomSurface = Enum.SurfaceType.Smooth
                        inviPart.Material = Enum.Material.Slate
                        inviPart.Color = Color3.fromRGB(215,215,215)  -- Specify the desired color

                        -- Calculate the global size by applying the rotation part of the CFrame to the local size
                        local globalSize = (cf - cf.Position):VectorToWorldSpace(size)

                        -- Create a new CFrame that only uses the position of the parent part's CFrame
                        local positionOnlyCFrame = CFrame.new(cf.Position)


                        inviPart.Size = Vector3.new(math.abs(globalSize.X), 0.2, math.abs(globalSize.Z)) + 300 * 2 * Vector3.new(1, 0, 1)

                        -- Adjust the CFrame to position the part correctly
                        local offsetCFrame = positionOnlyCFrame + Vector3.new(0, -math.abs(globalSize.Y) / 2, 0)

                        -- Apply this CFrame to the part
                        inviPart.CFrame = offsetCFrame - Vector3.new(0,inviPart.Size.Y/2 + 1e-3,0)

                        -- Set the size using the global size
                        inviPart.Anchored = true
                        inviPart.Parent = workspace
                        table.insert(self.Instances,inviPart)
                    end,
                    MapRemoved = C.ReloadHack,
                }
            },
        }
    }
end]=],
    ["Games/NavalWarefare"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunS = game:GetService("RunService")
local DS = game:GetService("Debris")
local PS = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")
local function Static(C,Settings)
	C.DataStorage={
		["USDock"]={Health=25e3,Base="Dock",Type="Base"},
		["JapanDock"]={Health=25e3,Base="Dock",Type="Base"},
		["Island"]={Health=8e3,Base="Island",Type="Base"},

		["Carrier"]={Health=10e3,Type="Ship"},
		["Battleship"]={Health=10e3,Type="Ship"},
		["Destroyer"]={Health=2500,Type="Ship"},
		["Cruiser"]={Health=3500,Type="Ship"},
		["Heavy Cruiser"]={Health=5500,Type="Ship"},
		["Submarine"]={Health=1000,Type="Ship"},

		["Bomber"]={Health=100,Type="Plane",MaxTorque=33.5e3,MaxForce=31148.7},
		["Torpedo Bomber"]={Health=100,Type="Plane",MaxTorque=33.5e3,MaxForce=31148.7},
		["Large Bomber"]={Health=300,Type="Plane",MaxTorque=13e4,MaxForce=71223.6},
	}
	function C.isInGame(theirChar)
		if theirChar and theirChar.Name == "InviClone" then
			theirChar = C.char
		end
		local player=PS:GetPlayerFromCharacter(theirChar)
		if not player then
			return false, "Neutral"--No player, no team!
		end
		local PrimaryPart = theirChar.PrimaryPart
		if not PrimaryPart or PrimaryPart.Position.Y < -103 then
			return false, player.Team -- Player, but in lobby!
		end

		return true, player.Team -- Player exists!
	end
    function C.getHealth(asset)
        local HP = asset:FindFirstChild("HP")
        if HP then
            if C.DataStorage[asset.Name].Type == "Base" then
                return HP.Value
            end
            return (asset:GetAttribute("Dead") or asset:GetAttribute("Ignore")) and 0 or HP.Value
        end
        return 0
    end

	function C.getClosestBase(location: Vector3)
		local myHRPPos = location or (C.char and C.char.PrimaryPart and C.char:GetPivot().Position)
		if not myHRPPos then return end

		local selBase, maxDist = nil, math.huge
		for baseType, bases in pairs(C.Bases) do
			for num, base in ipairs(bases) do
				if base:FindFirstChild("Team") and base.Team.Value ~= "" and base.Team.Value ~= C.plr.Team.Name and C.getHealth(base) > 0 then
					local MainBody = base:WaitForChild("MainBody")
					local d = (MainBody.Position - myHRPPos).Magnitude
					if d < maxDist then
						if baseType == "Dock" then
							d -= 50
						end
						selBase, maxDist = MainBody, d
					end
				end
			end
		end
		return selBase, maxDist
	end
	local function CanTargetOwner(model: Model)
		local Owner = model:FindFirstChild("Owner")
		if Owner and Owner.Value ~= "" then
			local theirPlr = PS:FindFirstChild(Owner.Value)
			if theirPlr and not C.CanTargetPlayer(theirPlr) then
				return false
			end
		end
		return true
	end
    for num, plane in ipairs(workspace:GetChildren()) do
        if plane:FindFirstChild("Owner") and plane.Owner.Value == "Biglugger2017" then
            print("Plane",plane,CanTargetOwner(plane))
        end
    end
    local function IsNearHarbor(location: Vector3, team: string)
        local TheirHarbor = workspace:WaitForChild(team=="Japan" and "JapanDock" or "USDock")
        local HarborMainBody = TheirHarbor:WaitForChild("MainBody")

        local HarborSize = HarborMainBody.Size+Vector3.new(340,240,340)
        local HarborCF = HarborMainBody.CFrame*CFrame.new(0,0,-80)

        --[[local myPart = Instance.new("Part",workspace)
        myPart.CanCollide = false
        myPart.Transparency = .87
        myPart.Anchored = true
        myPart.Size, myPart.CFrame = HarborSize, HarborCF
        DS:AddItem(myPart,20)--]]

        return C.IsInBox(HarborCF, HarborSize, location)
    end
	function C.getClosestShip(location: Vector3)
		local myHRPPos = location or (C.char and C.char.PrimaryPart and C.char:GetPivot().Position)
		if not myHRPPos then return end

		local selShip, maxDist = nil, math.huge
		for num, ship  in pairs(C.Ships) do
			if ship:FindFirstChild("Team") and ship.Team.Value ~= "" and ship.Team.Value ~= C.plr.Team.Name and C.getHealth(ship) > 0 and CanTargetOwner(ship) then
				local MainBody = ship:WaitForChild("MainBody")
				local d = (MainBody.Position - myHRPPos).Magnitude
				if d < maxDist and not IsNearHarbor(MainBody.Position, ship.Team.Value) then
					selShip, maxDist = MainBody, d
				end
			end
		end
		return selShip, maxDist
	end
	function C.getClosestPlane(location: Vector3)
		local myHRPPos = location or (C.char and C.char.PrimaryPart and C.char:GetPivot().Position)
		if not myHRPPos then return end

		local selShip, maxDist = nil, math.huge
		for num, plane  in pairs(C.Planes) do
			if plane:FindFirstChild("Team") and plane.Team.Value ~= "" and plane.Team.Value ~= C.plr.Team.Name and C.getHealth(plane) > 0 and CanTargetOwner(plane) then
				local MainBody = plane:FindFirstChild("MainBody")
                if MainBody then
                    local d = (MainBody.Position - myHRPPos).Magnitude
                    if d < maxDist then
                        selShip, maxDist = MainBody, d
                    end
                end
			end
		end
		return selShip, maxDist / 1000
	end
	function C.VehicleTeleport(vehicle, loc, useCF)
		if not useCF then
			useCF = CFrame.new(loc.Position) * loc.Rotation
		end
		local HitCode = vehicle:FindFirstChild("HitCode")
		if HitCode then
			-- Get where the secondary turrets are relative to basepart
			local saveData = {}
			for num, model in ipairs(vehicle:GetChildren()) do
				if model.Name == "Turret" then
					table.insert(saveData,{model,model:GetPivot().Position - vehicle:GetPivot().Position,vehicle:GetPivot():ToObjectSpace(model:GetPivot())})
				end
			end
			-- Move the main object
			vehicle:PivotTo(loc)
			-- Move the secondary turret objects
			for num, data in ipairs(saveData) do
				local Turret, Offset, RelativeRotation = table.unpack(data)
				-- Calculate the new position for the turret
				local newTurretPos = loc.Position + Offset

				-- Calculate the new rotation for the turret
				local newTurretCFrame = loc * RelativeRotation

				-- Set the turret's new position and rotation
				Turret:PivotTo(newTurretCFrame)
			end
		else
			vehicle:PivotTo(loc)
		end
	end
	C.getgenv().isInGame = C.isInGame
	C.RemoteEvent = RS:WaitForChild("Event") -- image naming something "Event"
	C.Bases = {Dock={},Island={}}
	C.Planes, C.Ships = {}, {}
	table.insert(C.EventFunctions,function()
		local function newChild(instance)
			if instance.ClassName ~= "Model" then
				return
			end
			local instData = C.DataStorage[instance.Name]
			if instData then
				local HitCode = instance:WaitForChild("HitCode")
				local ID = instData.Base or instData.Type -- Dock or Island
				local SelectTbl = C[instData.Type.."s"]
				if SelectTbl[ID] then
					SelectTbl = SelectTbl[ID]
				end
				table.insert(SelectTbl,instance)
				C.FireEvent(ID .. "Added",nil,instance)
				C.AddObjectConnection(instance,"NavalWarefareDestroying",instance.Destroying:Connect(function()
					--Disconnect the event
					C.TblRemove(SelectTbl,instance)
					C.FireEvent(ID .. "Removed",nil,instance)
				end))
			end
		end
		C.AddGlobalConnection(workspace.ChildAdded:Connect(newChild))
		for num, instance in ipairs(workspace:GetChildren()) do
			newChild(instance)
		end
	end)
	function C.GetNearestTuple(tbl)
		local closestPart, closestDist = nil, math.huge
		for num, values in ipairs(tbl) do
			if values[1] and (not closestPart or values[2] < closestDist) then
				closestPart, closestDist = values[1], values[2]
			end
		end
		return closestPart,closestDist
	end
    table.insert(C.InsertCommandFunctions,function()
        C.getgenv().LastBanVoteKick = nil
        local LegitVoteKick = true
        local TimeNeeded = LegitVoteKick and 60.4 or 3
        return {
            ["votekick"] = {
                Parameters={{Type="Player"}},
                Alias = {"ban"},
                AfterTxt = " %s",
                Priority = -3,
                KickThread = nil,
                Run = function(self,args)
                    C.RemoveAction("NavalVotekick")
                    local targetPlr = args[1][1]
                    if not targetPlr or targetPlr == C.plr then
                        return true, "Stopped!"
                    end
                    local Genv = C.getgenv()
                    local OrgName = args.OrgArgs[1]
                    local sendList = {targetPlr}
                    local functs = {}
                    local info
                    info = {Name="NavalVotekick",Title="Kick Starting", Tags={}, Stop=function()
                        C.ClearFunctTbl(functs,true)
                        if Genv.NavalKickThread then
                            C.StopThread(Genv.NavalKickThread)
                            Genv.NavalKickThread = nil
                        end
                        Genv.NavalKickThread = task.spawn(function()
                            for _, time in ipairs({45, 30, 15}) do
                                local TimeLeft = Genv.LastKick - os.clock()
                                --print("LastKick",TimeLeft,time,TimeLeft - time)
                                if TimeLeft >= time then
                                    task.wait(TimeLeft - time)
                                else
                                    continue
                                end
                                if C.GetAction("NavalVotekick") then
                                    return
                                end
                                C.CreateSysMessage(`Ban cooldown: {C.GetFormattedTime(Genv.LastKick - os.clock())}`, Color3.fromRGB(255,255))
                            end
                            task.wait(Genv.LastKick - os.clock())
                            if C.GetAction("NavalVotekick") then
                                return
                            end
                            C.CreateSysMessage(`Your ban cooldown has expired!`, Color3.fromRGB(255,255))
                        end)
                    end, Time=function()

                        if Genv.NavalKickThread then
                            C.StopThread(Genv.NavalKickThread)
                            Genv.NavalKickThread = nil
                        end
                        local actionClone = info.ActionClone
                        local JustKicked = false
                        table.insert(functs,targetPlr.AncestryChanged:Connect(function()
                            warn("Votekick",C.GetPlayerName(targetPlr),
                                "Completed:",JustKicked and "BANNED" or "LEFT","after",targetPlr:GetAttribute("KickCounter") or 0,"Counters")
                            C.RemoveAction("NavalVotekick")
                            C.getgenv().LastBanVoteKick = OrgName
                            C.CreateSysMessage(`Stopped banning because {C.GetPlayerName(targetPlr)} left. ` ..
                                `It is {JustKicked and "HIGHLY LIKELY" or "POSSIBLE"} that they were banned!`
                                .. ` (You voted {targetPlr:GetAttribute("KickCounter") or 0} times)`,
                                JustKicked and Color3.fromRGB(0,255) or nil)
                        end))
                        actionClone.Title.Text = "Kicking " .. C.GetPlayerName(targetPlr) .. " (".. (targetPlr:GetAttribute("KickCounter") or 0) .. "/6)"
                        while info.Enabled do
                            if Genv.LastKick == nil or (Genv.LastKick - os.clock()) <= 0 then
                                actionClone.Time.Text = "Sending (1/2)"
                                if not LegitVoteKick or C.StringWait(RS,"ServerResponse"):InvokeServer("CheckCanVote") then
                                    if not info.Enabled then return end
                                    actionClone.Time.Text = "Sending (2/2)"
                                    Genv.LastKick = os.clock() + TimeNeeded
                                    targetPlr:SetAttribute("KickCounter", (targetPlr:GetAttribute("KickCounter") or 0) + 1)
                                    JustKicked = true
                                    C.StringWait(RS,"Event"):FireServer("KickExploiter",sendList)
                                    task.delay(3,function()
                                        JustKicked = false
                                    end)
                                    if not info.Enabled then return end
                                    actionClone.Title.Text = "Kicking " .. C.GetPlayerName(targetPlr) .. " (".. targetPlr:GetAttribute("KickCounter") .. "/6)"
                                else
                                    Genv.LastKick = os.clock() + 1.5
                                    actionClone.Time.Text = "More Time Needed"
                                    task.wait(1)
                                end
                            end
                            while (info.Enabled and Genv.LastKick - os.clock() > 0) do
                                actionClone.Time.Text = C.GetFormattedTime(Genv.LastKick - os.clock())
                                task.wait(math.min(Genv.LastKick - os.clock(), 1))
                            end
                        end
                    end}
                    C.AddAction(info)
                    return true, "Started!"
                end,
            },
            ["votekickmessage"] = {
                Parameters = {},
                Alias = {"banmessage"},
                Priority = 1,
                AfterTxt = " %s",
                Run = function(self, args)
                    if not C.getgenv().LastBanVoteKick then
                        return false, "Nobody was recently votekicked!"
                    end
                    local brainrot = {
                        "thought i was a giga chad but the minions had me feeling like a beta banana",
                        "i tried to grind like a warier but life said nah youre just a goofy goober",
                        "i wanted to vibe like a wizzard but the goblins made me goofy",
                        "the grindset was on max then the hamster wheel broke and now im spinning in freefall",
                        "i wanted to become the goat but the sheep in me went baa instead",
                        "got that boss energy but my inner gremlin just keeps hiting snooze",
                        "they told me to chase the bag but i ended up chasing my own shadow",
                        "i was ready to riz up the universe but the vibes went npc mode",
                        "i wanted to be a shark but my inner goldfish just keeps swimming in circles",
                        "started the day as a main character but ended up as a side quest",
                        "thought i was built diferent then realized i was just built like ikea",
                        "i wanted to play chess in my mind but my thoughts keep defaulting to tic tac toe",
                        "i tried to big brain the situation but the small brain energy came out swinging",
                        "i was ready to conquer the world but the universe made me do the macarena",
                        "i wanted to be a vibe but the cringe got me in a headlock",
                        "got that 200 iq mindset but life said nah youre back to double digits",
                        "i tried to level up but the respawn button got stuck on loop",
                        "i thought i had plot armor but the scriptwriters made me the comic relief",
                        "i was feeling philisophical but my brain just went boing boing",
                        "set out to be a sigma but the popcorn guy kept stealing my spotlight"
                    }
                    local parseMultiLine = C.hackData.World.ChatEdit.ParseMultiLine
                    local brainrotmsg = brainrot[C.Randomizer:NextInteger(1, #brainrot)]
                    C.SendGeneralMessage(parseMultiLine(`{brainrotmsg}\\n{C.getgenv().LastBanVoteKick} was PERMANENTLY banned from this server!`));
                    C.getgenv().LastBanVoteKick = nil
                    return true, "Message Spoofed!"
                end,
            }
        }
    end)
end
return function(C,Settings)
	Static(C,Settings)

	return {
		Category = {
			Name = "NavalWarefare",
			Title = "Naval Warefare",
			Image = nil, -- Set Image to nil in order to get game image!
			Layout = 20,
		},
		Tab = {
			{
				Title = "Turret AimAssist",
				Tooltip = "Automatically Aims At Enemies When In A Turret",
				Layout = 1, Functs = {},
				Shortcut = "AimAssist",
				Activate = function(self,newValue)
					local c = 800 -- bullet velocity you can put between 799-800
					local function l(m, n)
						if not m then return m.Position end
						local o = m.Velocity
						return m.Position + (o * n)
					end
					local function p(q)
						local r = C.plr.Character
						if not r or not r:FindFirstChild("HumanoidRootPart") then return 0 end
						local s = r.HumanoidRootPart.Position
						local t = (q - s).Magnitude
						return t / c
					end
					if newValue then
						table.insert(self.Functs,UIS.InputBegan:Connect(function(inputObject,gameProcessed)
							if inputObject.KeyCode == Enum.KeyCode.F then
								while UIS:IsKeyDown(Enum.KeyCode.F) and self.RealEnabled do
									local u = C.getClosest({})
									if u then
										local v = u.Parent:FindFirstChild("HumanoidRootPart")
										if v then
											local w = p(v.Position)
											local x = l(v, w)
											C.RemoteEvent:FireServer("aim", {x})
										end
									end
									RunS.RenderStepped:Wait()
								end
							end
						end))
					end
				end,
			},
			{
				Title = "Rifle Kill Aura",
				Tooltip = "Uses rifle to loop kill nearby enemies.\nPlease note that people know who killed them",
				Layout = 2, Functs = {}, Threads = {},
				Shortcut = "KillAura",
				Shoot = function(self,Target: BasePart)
					if C.char and not C.char:FindFirstChild("InGame") and not C.char:GetAttribute("InGame") then
						C.RemoteEvent:FireServer("Teleport",{"Harbour",""})
						C.char:SetAttribute("InGame",true) -- Only fire once, no need for spam
					end
					C.RemoteEvent:FireServer("shootRifle","",{Target})
					C.RemoteEvent:FireServer("shootRifle","hit",{Target.Parent:FindFirstChild("Humanoid")})
				end,
				Activate = function(self,newValue)
					if not C.char then
						return
					end
					local Tool = C.char:FindFirstChildWhichIsA("Tool")
					while self.RealEnabled do
						local Target, Distance = C.getClosest({})
						if Tool and Target and Distance <= 450 then
							self:Shoot(Target)
						end
						RunS.RenderStepped:Wait()
						while not Tool or not Tool:IsA("Tool") or not Tool.Parent or not Tool.Parent.Parent do
							Tool = C.char.ChildAdded:Wait() -- Wait for new tool!
						end
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				}
			},
			{
				Title = "Loop Kill Enemies",
				Tooltip = "Uses rifle to loop kill enemies.\nPlease note that people know who killed them",
				Layout = 3, Functs = {}, Threads = {},
				Shortcut = "LoopKillEnemies",
				Activate = function(self,newValue)
					if not C.char then
						return
					end
					local Title = "Loop Kill Enemies"
					C.SetHumanoidTouch(newValue,"rifleLoopKill")
					if newValue then
						local actionClone = C.AddAction({Name=Title,Tags={"RemoveOnDestroy"},Stop=function(onRequest)
							self:SetValue(false)
						end,})
						if not self.LastSpotted and C.char and C.hrp then
							self.LastSpotted = C.char:GetPivot()
						end
						local Time = actionClone:FindFirstChild("Time")
						local saveChar = C.char
						while Time and self.RealEnabled and C.char == saveChar and C.char.PrimaryPart and C.human and C.human.Health>0 do
							local theirHead, dist = C.getClosest({})
							if theirHead then
								C.DoTeleport(theirHead.Parent:GetPivot() * CFrame.new(0,20,0))
								Time.Text = theirHead.Parent.Name
								self.Parent.Tab[2]:Shoot(theirHead)
								C.Spectate(theirHead.Parent)
							else
								Time.Text = "(Waiting)"
							end
							RunS.RenderStepped:Wait()
						end
					else
						C.Spectate()
						C.RemoveAction(Title)
						if self.LastSpotted then
							C.DoTeleport(self.LastSpotted)
							self.LastSpotted = false
						end
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						if self.RealEnabled and not firstRun then
							local Rifle = C.plr:WaitForChild("Backpack"):WaitForChild("M1 Garand",5)
							if Rifle then
								C.human:EquipTool(Rifle)
							end
						end
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				}
			},

			--[[{
				Title = ({"OP","Balanced","NEENOO's","NotAVirus","Easy"})[math.random(1,5)].." God Mode",
				Tooltip = "Keeps you invulerable using a forcefield. Only works in planes and when unseated",
				Layout = 4, Functs = {}, Threads = {},
				Shortcut = "GodMode",
				Activate = function(self,newValue)
					if not C.char or not newValue then
						return
					end
					while C.human.Health > 0 do
						while not C.isInGame(C.char) do
							task.wait(4) -- FF lasts for 20 seconds so we good
						end
						local FF = C.char:FindFirstChildWhichIsA("ForceField")
						if FF then
							FF.Visible = not self.EnTbl.FFVisibility
							DS:AddItem(FF,15) -- Delete it after 15 seconds!
							FF.AncestryChanged:Wait() -- Wait until we're defenseless!
						elseif C.human.SeatPart then
							C.human:GetPropertyChangedSignal("SeatPart"):Wait()
						elseif C.human.Health > 0 then
							C.RemoteEvent:FireServer("Teleport", {
								[1] = "Harbour",
								[2] = ""
							})
							task.wait(2) -- Wait a bit so it doesn't lag!
						end
						RunS.RenderStepped:Wait()
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						task.delay(2,C.DoActivate,self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Disable Visibility",
						Tooltip = "Whether or not you can see your own forcefield. Disable for better visiblity.",
						Layout = 1,Default=true,
						Shortcut="FFVisibility",
					},
				},
			},--]]
			{
				Title = "Projectile Hit",
				Tooltip = "Instantly hits enemies when shooting bullets\nPlease note that players you directly kill will know who killed them",
				Layout = 4, Functs = {},
				Shortcut = "ProjectileHit",
				Activate = function(self,newValue)
					if not C.char then
						return
					end
					if newValue then
                        local ConnectionTbl = {}
						local CurConn
						table.insert(self.Functs,UIS.InputBegan:Connect(function(inputObj, gameProcessed)
							if inputObj.KeyCode == Enum.KeyCode.F and not CurConn then
								local MyConn
								MyConn = workspace.ChildAdded:Connect(function(instance)
									task.wait(.1)
									if instance.Name == "bullet" and instance.Parent and MyConn == CurConn then
										local nearestTbl = {}
										if self.EnTbl.Users then
											table.insert(nearestTbl,{C.getClosest({noForcefield=true},instance.Position)})
										end
										if self.EnTbl.Planes then
											table.insert(nearestTbl,{C.getClosestPlane(instance.Position)})
										end
										local closestBasePart, distance = C.GetNearestTuple(nearestTbl)
										if closestBasePart then
											if self.EnTbl.Spectate then
												C.Spectate(closestBasePart.Parent)
											end
                                            local HP = closestBasePart.Parent:FindFirstChild("HP")
                                            if not ConnectionTbl[closestBasePart] and HP then
                                                local HPChangedFunct = HP.Changed:Connect(function(newVal)
                                                    if newVal <= 0 then
                                                        closestBasePart.Parent:SetAttribute("Dead",true)
                                                    end
                                                end)
                                                ConnectionTbl[closestBasePart] = true
                                                task.delay(1,HPChangedFunct.Disconnect, HPChangedFunct)
                                                task.delay(1,rawset,ConnectionTbl,closestBasePart,nil)
                                            end

											--closestBasePart = game:GetService("Workspace").JapanDock.Decoration.ConcreteBases.ConcreteBase
											--[[for s = 0, 1, 1 do
												C.firetouchinterest(instance,closestBasePart,0)
												task.wait()
												C.firetouchinterest(instance,closestBasePart,1)
												task.wait()
											end--]]
											C.firetouchinterest(instance,closestBasePart)
										end
									end
								end)
								CurConn = MyConn
								table.insert(self.Functs,CurConn)
							end
						end))
						table.insert(self.Functs,UIS.InputEnded:Connect(function(inputObj, gameProcessed)
							if inputObj.KeyCode == Enum.KeyCode.F then
								C.TblRemove(self.Functs,CurConn)
								if CurConn then
									CurConn:Disconnect()
									CurConn = nil
								end
								C.Spectate()
							end
						end))
					else
						C.Spectate()
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Spectate Users",
						Tooltip = "Whether or not spectate who you are killing.",
						Layout = 1,Default=true,
						Shortcut="Spectate",
					},
					{
						Type = Types.Toggle,
						Title = "Users",
						Tooltip = "Shoots users not in vehicles (PARTIALLY PATCHED: Can only target INGAME players with NO FF)",
						Layout = 2,Default=true,
						Shortcut="Users",
					},
					{
						Type = Types.Toggle,
						Title = "Planes",
						Tooltip = "Target enemy planes",
						Layout = 3,Default=true,
						Shortcut="Planes",
					},
					{
						Type = Types.Dropdown, Selections = {"InGame"},
						Title = "Target Users",
						Tooltip = "Who on the enemy team to target. (PATCHED: Can only target INGAME players with NO FF)",
						Layout = 2,Default="InGame",
						Shortcut="Target",
					},--]]
				},
			},
			{
				Title = "Anti Bounds",
				Tooltip = "Prevents your plane from going into the Pacific or exiting!",
				Layout = 5, Threads = {},
				Shortcut = "AntiBounds",
				Activate = function(self)
					if not C.char then
						return
					end
					if C.human.SeatPart then
						self.Events.MySeatAdded(self,C.human.SeatPart)
					end
				end,
				Events = {
					MySeatAdded = function(self,seatPart)
						local Vehicle = seatPart.Parent
						local HitCode = Vehicle:WaitForChild("HitCode",5)
						if not HitCode then return end
						local VehicleType = HitCode.Value
						local EnemyHarbor = workspace:WaitForChild(C.plr.Team.Name=="Japan" and "USDock" or "JapanDock")
						local HarborMainBody = EnemyHarbor:WaitForChild("MainBody")
						local LineVelocity = Vehicle:FindFirstChild("BodyVelocity",true)
						local MainVelocity = LineVelocity.Parent

						local BoundingSize = Vector3.new(10240,20e3,16384)

						local HarborSize = HarborMainBody.Size+Vector3.new(60,220,60)
						local HarborCF = HarborMainBody.CFrame*CFrame.new(0,-40,0)

						--The "BodyVelocity" is actually "LineVelocity"
						if VehicleType=="Plane" or VehicleType == "Ship" then
							while C.human and C.human.SeatPart == seatPart and self.RealEnabled do
								local BoundingCF = CFrame.new(0, BoundingSize.Y/2 + self.EnTbl.MinHeight, 0)
								local OldVelocity = MainVelocity.AssemblyLinearVelocity
								local GetOutSpeed = Vector3.zero
								--{PartCF,PartSize,isBlacklist} (All Three Arguments Required)
								local ListedAreas = {{BoundingCF,BoundingSize,false},{HarborCF,HarborSize,true}}
								for num, data in ipairs(ListedAreas) do
									if not C.IsInBox then
										warn("C.iSinbox not found/loaded!")
										continue
									end
									if C.IsInBox(data[1],data[2],seatPart.Position) == data[3] then
										local PullUpSpeed = self.EnTbl.PullUpSpeed
										GetOutSpeed +=
											((data[3] and C.ClosestPointOnPartSurface or C.ClosestPointOnPart)(data[1], data[2], seatPart.Position)
												- seatPart.Position) * (data[3] and PullUpSpeed/3 or PullUpSpeed)
									end
								end
								if GetOutSpeed.Magnitude > .3 then
									local NewX, NewY, NewZ = OldVelocity.X, OldVelocity.Y, OldVelocity.Z
									if math.abs(GetOutSpeed.X) > .5 then
										NewX = GetOutSpeed.X
									end
									if math.abs(GetOutSpeed.Y) > .5 then
										NewY = GetOutSpeed.Y
									end
									if math.abs(GetOutSpeed.Z) > .5 then
										NewZ = GetOutSpeed.Z
									end
									MainVelocity.AssemblyLinearVelocity = Vector3.new(NewX,NewY,NewZ)
								end
								RunS.RenderStepped:Wait()
							end
						end
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "Pull Up Speed",
						Tooltip = "How fast you are re-orientated back to inside the bounds of the map.",
						Layout = 1,Default=20,
						Min=10,Max=40,Digits=0,
						Shortcut="PullUpSpeed",
					},
					{
						Type = Types.Slider,
						Title = "Min Height",
						Tooltip = "The minimum y height a plane can be before it is pulled up using `Pull Up Speed`",
						Layout = 1,Default=10,
						Min=0,Max=20,Digits=0,
						Shortcut="MinHeight",
					},
				},
			},
			{
				Title = "Hitbox Expander",
				Tooltip = "Expands enemy ship's hitbox, making them easier to hit!",
				Layout = 6, Threads = {},
				Shortcut = "HitboxExpander",
				DontActivate = true,
				RunOnDestroy = function(self)
					self:Activate(false)
				end,
				Activate=function(self,newValue)
					for num, ship in ipairs(C.Ships) do
						self.Events.ShipAdded(self,ship)
					end
				end,
				Events = {
					ShipAdded=function(self,ship)
						local MainBody = ship:WaitForChild("MainBody",1e-3)
                        if not MainBody then
                            return
                        end
						local Team = ship:WaitForChild("Team")
						local ExpandSize = (Team.Value == C.plr.Team.Name or not self.RealEnabled) and 0 or self.EnTbl.Size
						local DefaultSize = C.GetPartProperty(MainBody,"Size")

						C.ResetPartProperty(MainBody,"Size","ShipHitboxExpander")

						if ExpandSize ~= 0 then
							local NewSize = DefaultSize + 2 * Vector3.one * ExpandSize
							C.SetPartProperty(MainBody,"Size","ShipHitboxExpander",NewSize, true, true)-- Times two in order to expand in EVERY direction
						end
					end,
					MyTeamAdded=function(self,newTeam)
						self:Activate()
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "Size",
						Tooltip = "The size, in studs, that the hitboxes are expanded in every direction",
						Layout = 1,Default=2,
						Min=0.1,Max=50,Digits=1,
						Shortcut="Size",
						Activate = C.ReloadHack,
					}
				}
			},
			{
				Title = "Bomb Hit",
				Tooltip = "Bombs hit the closest target",
				Layout = 7, Functs = {},
				Shortcut = "BombInstantHit",
				BombThrowTime = {},
				ComparePos = nil,
				Activate = function(self, newValue)
					-- Disconnect funct and set up childadded workspace event for the projectiles
					if newValue then
						if C.SeatPart then
							self.Events.MySeatAdded(self,C.SeatPart)
						end
					end
				end,
                MoveBombTo = function(self,instance,target)
                    instance.CFrame = CFrame.new(target + Vector3.new(0,1,0), target)
                    instance.AssemblyLinearVelocity = instance.AssemblyLinearVelocity
                    instance.AssemblyAngularVelocity = Vector3.zero
                    --instance.CanTouch = true
                    --C.Spectate(instance)
                end,
				Events = {
					MySeatAdded = function(self,seatPart)
					    local secondaryBasePart = C.Bases.Island[2].PrimaryPart
						local deb = 0
						table.insert(self.Functs,workspace.ChildAdded:Connect(function(instance)
							if instance.Name ~= "Bomb" then
								return
							end
                            instance.CanTouch = false
							local Spectate = C.hrp and (instance.Position - (self.ComparePos or C.hrp.Position)).Magnitude < 90
							task.wait(.4)
                            --[[if true then
                                local target = game:GetService("Workspace").Lobby.KickExploiter.Visual.Position + Vector3.new(0,10,0)
                                instance.Position = target
                                instance.AssemblyLinearVelocity = Vector3.zero
                                instance.AssemblyAngularVelocity = Vector3.zero
                                instance.CanTouch = true
                                C.Spectate(game:GetService("Workspace").Lobby.KickExploiter.Visual)
                                print("MOVED")
                                return
                            end--]]
							if instance.Parent then
								local nearestTbl = {}

								if self.EnTbl.Base then
									table.insert(nearestTbl,{C.getClosestBase(instance.Position)})
								end
								if self.EnTbl.Ship then
									table.insert(nearestTbl,{C.getClosestShip(instance.Position)})
								end
								if self.EnTbl.Plane then
									table.insert(nearestTbl,{C.getClosestPlane(instance.Position)})
								end
                                if self.EnTbl.User then
                                    table.insert(nearestTbl,{C.getClosest({noForcefield=true,noGame=true},instance.Position)})
                                end

								local closestBasePart, distance = C.GetNearestTuple(nearestTbl)
								if closestBasePart then
                                    local closestParent = closestBasePart.Parent
									if self.EnTbl.Spectate and Spectate then
										deb+= 1 local saveDeb = deb
										C.Spectate(closestBasePart)
										task.delay(1,function()
											if deb == saveDeb then
												C.Spectate() -- undo it
											end
										end)
									end
									--closestBasePart = game:GetService("Workspace").JapanDock.Decoration.ConcreteBases.ConcreteBase
									instance.CanTouch = true
									--[[for s = 0, 1, 1 do
										C.firetouchinterest(instance,closestBasePart,0)
										task.wait()
										C.firetouchinterest(instance,closestBasePart,1)
										task.wait()
									end--]]
                                    local changedFunct
                                    local HP = closestParent:FindFirstChild("HP")
                                    if HP then
                                        changedFunct = closestParent.HP.Changed:Connect(function(newVal)
                                            if newVal <= 0 then
                                                closestParent:SetAttribute("Dead",true)
                                            end
                                        end)
                                    end

                                    local setIgnore = false
                                    if HP and closestParent.HP.Value <= 300 then
                                        closestParent:SetAttribute("Ignore",true)
                                        setIgnore = true
                                    end
                                    if self.EnTbl.RemoteExplosion or closestParent:FindFirstChild("Humanoid") then
                                        local End = os.clock() + 1
                                        while os.clock() < End do
                                            self:MoveBombTo(instance,closestBasePart.Position)
                                            RunS.RenderStepped:Wait()
                                        end
                                        C.firetouchinterest(instance,secondaryBasePart)
                                    else
                                        C.firetouchinterest(instance,closestBasePart)
                                    end
                                    task.wait(2/3)
                                    if changedFunct then
                                        changedFunct:Disconnect()
                                    end
                                    if setIgnore then
                                        closestParent:SetAttribute("Ignore",nil)
                                    end
								else
									instance.CanTouch = true
								end
							end
						end))
					end,
                    MySeatRemoved = C.ReloadHack,
				},
				Options = {
                    {
						Type = Types.Toggle,
						Title = "Users",
						Tooltip = "Allows targets such as individual users.",
						Layout = 0,Default=true,
						Shortcut="User",
					},
					{
						Type = Types.Toggle,
						Title = "Bases",
						Tooltip = "Allows targets such as bases, i.e. harbours and enemy islands.",
						Layout = 1,Default=true,
						Shortcut="Base",
					},
					{
						Type = Types.Toggle,
						Title = "Ships",
						Tooltip = "Allows targets such as ships, i.e. subs and battleships.",
						Layout = 2,Default=true,
						Shortcut="Ship",
					},
					{
						Type = Types.Toggle,
						Title = "Planes",
						Tooltip = "Allows targets such as planes.",
						Layout = 3,Default=true,
						Shortcut="Plane",
					},
					{
						Type = Types.Toggle,
						Title = "Spectate",
						Tooltip = "Spectates who you did dirty..",
						Layout = 4,Default=true,
						Shortcut="Spectate",
					},
                    {
						Type = Types.Toggle,
						Title = "Remote Explosion",
						Tooltip = "When possible, drops the bomb on top of the target\nSometimes required, in which case always happens",
						Layout = 4,Default=true,
						Shortcut="RemoteExplosion",
					}
				}
			},
			{
				Title = "Disable Kill Bricks",
				Tooltip = "Disables the Pacific Ocean kill floor (the grey blocks below the ocean 🌊🦈)",
				Layout = 100, Threads = {}, Default = true,
				Shortcut = "DisableKillBricks",
				SetPartEn = function(self,part,en)
					if en then
						C.ResetPartProperty(part, "CanTouch", "DisableKillBricks")
					else
						C.SetPartProperty(part, "CanTouch", "DisableKillBricks",false)
					end
				end,
				ToggleVehicleColliders = function(self,Vehicle,Enabled)
					if not Vehicle then
						return
					end
					for num, part in ipairs(Vehicle:GetDescendants()) do
						if part:IsA("BasePart") then
							self:SetPartEn(part,Enabled)
						end
					end
				end,
				ToggleBaseColliders = function(self,Enabled)
					local EnemyHarbor = C.plr.Team.Name == "Japan" and workspace:WaitForChild("USDock") or workspace:WaitForChild("JapanDock")
					for num, part in ipairs(C.StringWait(EnemyHarbor,"Decoration.ConcreteBases"):GetChildren()) do
						if part:IsA("BasePart") then
							self:SetPartEn(part,Enabled)
						end
					end
					self:SetPartEn(EnemyHarbor:WaitForChild("MainBody"),Enabled)
				end,
				Activate = function(self,newValue)
					local SeaFloorGroup = C.StringWait(workspace,"Setting.SeaFloor")
					for num, seaFloorPart in ipairs(SeaFloorGroup:GetChildren()) do
						if seaFloorPart:IsA("BasePart") then
							self:SetPartEn(seaFloorPart,not newValue)
						end
					end
					if C.human and C.human.SeatPart then
						self.Events.MySeatAdded(self,C.human.SeatPart)
					else
						self:ToggleBaseColliders(not newValue)
					end
				end,
				Events = {
					MySeatAdded = function(self,seatPart)
						local Vehicle = seatPart.Parent
						local HitCode = Vehicle:WaitForChild("HitCode",5)
						if not HitCode or HitCode.Value ~= "Plane" then
							return
						end
						local LineVelocity = Vehicle:WaitForChild("MainBody"):WaitForChild("BodyVelocity")
						while self.EnTbl.PlaneHitbox and C.SeatPart == seatPart do
							local isGrounded = LineVelocity.MaxForce < 2
							self:ToggleVehicleColliders(Vehicle,isGrounded) -- Disable CanTouch colliders
							self:ToggleBaseColliders(not isGrounded)
							RunS.RenderStepped:Wait()
						end
						self.Events.MySeatRemoved(self,seatPart)
					end,
					MySeatRemoved = function(self,seatPart)
						local Vehicle = seatPart.Parent
						self:ToggleVehicleColliders(Vehicle,true) -- Disable CanTouch colliders
						self:ToggleBaseColliders(false)
					end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Plane Hitbox",
						Tooltip = "Disables Plane Hitbox.",
						Layout = 1,Default=true,
						Shortcut="PlaneHitbox",
						Activate = C.ReloadHack,
					}
				},
			},
			{
				Title = "ESP Island Capture",
				Tooltip = "Adds a button to capture neutral islands automatically",
				Layout = 30, Threads = {}, Instances = {}, Functs = {}, Default = true,
				Shortcut = "ESPIslandCapture",
				DontActivate = true,
				Activate=function(self,newValue)
					if not newValue then
						return
					end
					for num, island in pairs(C.Bases.Island) do
						self.Events.IslandAdded(self,island)
					end
				end,
				Events = {
					IslandAdded=function(self,island)
						local newTag=C.Examples.ToggleTagEx:Clone()
						newTag.Name = "Island"
						newTag.Parent=C.UI.ESP
						newTag.StudsOffsetWorldSpace = Vector3.new(0, 45, 0)
						newTag.ExtentsOffsetWorldSpace = Vector3.zero

						table.insert(self.Instances,newTag)
						C.AddObjectConnection(island,"ESPIslandCapture",island.Destroying:Connect(function()
							newTag:Destroy()
						end))
						local TeamVal = island:WaitForChild("Team")
						local HPVal = island:WaitForChild("HP")
						local IslandCode = island:WaitForChild("IslandCode").Value
						local FlagPad = island:WaitForChild("Flag"):WaitForChild("FlagPad")
						local button = newTag:WaitForChild("Toggle")
						local isEn = false
						local Info = {Name="Capturing "..IslandCode,Tags={"RemoveOnDestroy"}}
						local function activate(new)
							isEn = new
							button.Text = isEn and "Pause" or "Capture"
							button.BackgroundColor3 = isEn and Color3.fromRGB(255) or Color3.fromRGB(170,0,255)
							if new then
								local ActionClone = C.AddAction(Info)
								local Touching = false
								while Info.Enabled and TeamVal.Value == "" and ActionClone and ActionClone.Parent do
									C.SetActionPercentage(ActionClone, HPVal.Value / C.DataStorage.Island.Health)
									Touching = not Touching
									local PrimaryPart = C.hrp
									if PrimaryPart and PrimaryPart.Parent then
										--C.firetouchinterest(C.char.PrimaryPart, FlagPad, Touching and 0 or 1)
										C.firetouchinterest(PrimaryPart, FlagPad, Touching and 0 or 1)
									end
									RunS.RenderStepped:Wait()
								end
								return activate(false) -- Disable it
							end
							C.RemoveAction(Info.Name)
						end
						button.MouseButton1Up:Connect(function()
							activate(not isEn)
						end)
						activate(isEn)
						local function UpdVisibiltiy()
							button.Visible = TeamVal.Value == ""
						end
						table.insert(self.Functs,TeamVal:GetPropertyChangedSignal("Value"):Connect(UpdVisibiltiy))
						UpdVisibiltiy()
						newTag.Adornee=FlagPad
						newTag.Enabled = true
					end,
				}
			},
			{
				Title = "ESP Loop Bomb",
				Tooltip = "Adds a button above objectives to bomb them continously",
				Layout = 31, Threads = {}, Instances = {}, Functs = {}, Default = true,
				Shortcut = "ESPLoopBomb",
				DontActivate = true,
				RefreshEn=function(self,tag)
					if not tag.Adornee then
						return
					end
					local Base = tag.Adornee.Parent
					if Base then
						local Team = Base:WaitForChild("Team",5)
						if Team and C.getHealth(Base) > 0 then
							local Plane = C.human and C.human.SeatPart and C.human.SeatPart.Parent
							if Plane and C.human.SeatPart.Name == "Seat" then
								local HitCode = Plane:FindFirstChild("HitCode")
								if HitCode and HitCode.Value == "Plane" then
									tag.Enabled = self.RealEnabled and Team.Value ~= C.plr.Team.Name and Team.Value ~= ""
									return
								end
							end
                        elseif Base:FindFirstChild("HP") and Base.HP.Value == 0 then
                            Base:SetAttribute("Dead",true)
						end
					end
					tag.Enabled = false
				end,
				RefreshAllTags = function(self)
					for num, tag in ipairs(self.Instances) do
						self:RefreshEn(tag)
					end
				end,
				Activate=function(self,newValue)
					if not newValue then
						C.RemoveAction("LoopBomb")
						return
					end
					for name, data in pairs(C.Bases) do
						for num, island in ipairs(data) do
							task.spawn(self.Events.IslandAdded,self,island)
						end
					end
					for num, ship in ipairs(C.Ships) do
						table.insert(self.Threads,task.spawn(self.Events.ShipAdded,self,ship))
					end
				end,
				Events = {
					MyTeamAdded=function(self)
						self:RefreshAllTags()
					end,
					MySeatAdded=function(self)
						self:RefreshAllTags()
					end,
					MySeatRemoved = function(self)
						self:RefreshAllTags()
					end,
					IslandAdded=function(self,island)
						local DropOffset = 250
						local TimeFromDropToExpl = math.sqrt(DropOffset/workspace.Gravity)

						local newTag=C.Examples.ToggleTagEx:Clone()
						newTag.Name = "LoopBombESP"
						newTag.Parent=C.UI.ESP
						newTag.ExtentsOffsetWorldSpace = Vector3.zero
						table.insert(self.Instances, newTag)

						C.AddObjectConnection(island,"Parent",island:GetPropertyChangedSignal("Parent"):Connect(function()
							newTag:Destroy()
						end))
						local IslandData = C.DataStorage[island.Name]
						local TeamVal = island:WaitForChild("Team",15)
						if not TeamVal then
							return
						end
						local HPVal = island:WaitForChild("HP")
						local HitCode = island:WaitForChild("HitCode").Value
						local IslandBody = island:WaitForChild("MainBody")
						local button = newTag:WaitForChild("Toggle")
						local isEn = false
						local Info = {Name="LoopBomb",Title="Bombing "..HitCode,Tags={"RemoveOnDestroy"}}
						newTag.StudsOffsetWorldSpace = Vector3.new(0, HitCode=="Dock" and 120 or 60, 0)
						local function basebomb_activate(new)
							button.Text = new and "Pause" or "Bomb"
							button.BackgroundColor3 = new and Color3.fromRGB(255) or (HitCode=="Dock" and Color3.fromRGB(170,0,255) or Color3.fromRGB(170,255))
							if new then
								if C.GetAction(Info.Name) then
									C.RemoveAction(Info.Name)
									RunS.RenderStepped:Wait()
								end


								local Plane = C.human.SeatPart and C.human.SeatPart.Parent
								if not Plane then
									return basebomb_activate(false)
								end
								local PlaneMB = Plane:WaitForChild("MainBody")
								local BombC = Plane:WaitForChild("BombC")
								local ActionClone = C.AddAction(Info)

								local IslandLoc

								local HalfSize = IslandBody.Size/4 -- Make it a quarter so it doesn't miss!
								local Randomizer = Random.new()

								local XOfffset,ZOffset
								local TargetCF

								local function CalculateNew(Regenerate)
									if Regenerate or not XOfffset then
										XOfffset,ZOffset = Randomizer:NextNumber(-HalfSize.X,HalfSize.X), Randomizer:NextNumber(-HalfSize.Z,HalfSize.Z)
									end
									IslandLoc = IslandBody:GetPivot() + (IslandBody.AssemblyLinearVelocity * TimeFromDropToExpl)
									TargetCF = IslandLoc * CFrame.new(XOfffset,0,ZOffset) + Vector3.new(0,DropOffset,0)
								end

								local WhileIn = 0
								while Info.Enabled and TeamVal.Value ~= "" and TeamVal.Value ~= C.plr.Team.Name and ActionClone and ActionClone.Parent and island.Parent
									and C.human.SeatPart and C.human.SeatPart.Parent == Plane and HPVal.Value > 0 do
									CalculateNew(Randomizer:NextInteger(1,5) == 1)
									if not C.GetAction("Plane Refuel") and BombC.Value > 0 then
										PlaneMB.AssemblyLinearVelocity = TargetCF.Position - PlaneMB.Position
										if BombC.Value > 0 and WhileIn>.5 then
											WhileIn = 0
											C.RemoteEvent:FireServer("bomb")
											local savePos = C.hrp.Position
											local data = C.hackData.NavalWarefare.BombInstantHit
											data.ComparePos = savePos
											task.delay(.6,function()
												if data.ComparePos == savePos then
													data.ComparePos = nil
												end
											end)
										end
									elseif BombC.Value == 0 and not C.enHacks.NavalWarefare.PlaneRestock.En then
										break
									end
									C.SetActionPercentage(ActionClone,1-(HPVal.Value / IslandData.Health))
									local Distance = ((PlaneMB:GetPivot().Position - TargetCF.Position)/Vector3.new(1,1000,1)).Magnitude
									if Distance > 30 and not C.GetAction("Plane Refuel") then
										C.VehicleTeleport(Plane,TargetCF)
									end
									if Distance < 300 then
										WhileIn += RunS.RenderStepped:Wait()
									else
										WhileIn = 0
										RunS.RenderStepped:Wait()
									end
								end
								isEn = true
								return basebomb_activate(false) -- Disable it
							elseif isEn then -- Disable only if we WERE bombing earlier!
								C.RemoveAction(Info.Name)
							end
							isEn = new
						end
						button.MouseButton1Up:Connect(function()
							basebomb_activate(not isEn)
						end)
						table.insert(self.Threads,task.spawn(basebomb_activate,isEn))
						local function UpdVisibiltiy()
							self:RefreshEn(newTag)
						end
						C.AddObjectConnection(TeamVal,"LoopBomb",TeamVal:GetPropertyChangedSignal("Value"):Connect(UpdVisibiltiy))
						C.AddObjectConnection(HPVal,"LoopBomb",HPVal:GetPropertyChangedSignal("Value"):Connect(UpdVisibiltiy))
						newTag.Adornee=IslandBody
						UpdVisibiltiy()
					end,
					DockAdded=function(self,dock)
						self.Events.IslandAdded(self,dock)
					end,
					ShipAdded=function(self,ship)
						self.Events.IslandAdded(self,ship)
					end,
				}
			},
			{
				Title = "Plane Restock",
				Tooltip = "Refuels when things like ammo, bombs, or health are below certain configurable thresholds",
				Layout = 10, Threads = {}, Functs = {}, Default = true,
				Shortcut = "PlaneRestock",
				DontActivate = true,
				Activate=function(self,newValue)
					if not newValue then
						self.Events.MySeatRemoved(self) -- Cancel the action
					elseif C.human.SeatPart then
						self.Events.MySeatAdded(self,C.human.SeatPart)
					end
				end,
				Events = {
					MySeatAdded=function(self,seatPart)
						self.Events.MySeatRemoved(self)
						local Plane = seatPart.Parent
						local HitCode = Plane:WaitForChild("HitCode",5)
						local MainBody = Plane.PrimaryPart
						if HitCode and MainBody and HitCode.Value == "Plane" then
							local HP = Plane:WaitForChild("HP")
							local Fuel = Plane:WaitForChild("Fuel")
							local AmmoC = Plane:FindFirstChild("BulletC1")
							local AmmoC2 = Plane:FindFirstChild("BulletC2")
							local BombC = Plane:WaitForChild("BombC")
							local Conn
							local function canRun(toRun)
								return MainBody and Plane.Parent and table.find(self.Functs,Conn) and not MainBody:FindFirstChild("weldConstraint")
									and C.human and seatPart == C.human.SeatPart and HP.Value > 0 and not C.Cleared
									and (not toRun or
										((self.EnTbl.Bomb and BombC.Value == 0)
											or (self.EnTbl.MinHPPercentage*C.DataStorage[Plane.Name].Health/100>=HP.Value)
											or (self.EnTbl.Fuel and Fuel.Value <= 3))
											or (self.EnTbl.Ammo and ((AmmoC and AmmoC.Value <= 30) or (AmmoC2 and AmmoC2.Value <= 0)))
										)
							end
							local function HarborRefuel()
								local Harbor = workspace:WaitForChild(C.plr.Team.Name:gsub("USA","US").."Dock")
								local HarborMain = Harbor:WaitForChild("MainBody")
								local MainBody = Plane:WaitForChild("MainBody")
								local Origin = Plane:GetPivot()
								local Info = {Name="Plane Refuel",Tags={"RemoveOnDestroy"},Stop=function(onRequest)
									if not C.GetAction("LoopBomb") then
										C.VehicleTeleport(Plane,Origin)
									end
									if onRequest then
										self:SetValue(false)
									elseif seatPart ~= C.human.SeatPart then
										self:ClearData()
									end
								end,}
								local actionClone = C.AddAction(Info)
								if actionClone then
									actionClone:WaitForChild("Time").Text = "~2s"
								end
                                local ChosenNumber = C.Randomizer:NextNumber(-40, 40)
								while canRun(true) and Info.Enabled do
									if (Plane:GetPivot().Position - HarborMain.Position).Magnitude > 30 then
										C.VehicleTeleport(Plane,HarborMain:GetPivot() * CFrame.new(-40,0,80)) -- used to be 0 45, 15
									end
									MainBody.AssemblyLinearVelocity = Vector3.new()
									--MainBody.AssemblyAngularVelocity = Vector3.new()
									RunS.RenderStepped:Wait()
								end
							end
							local function CheckDORefuel(newBomb)
								if newBomb ~= nil then
									task.wait(1/3) -- wait for the bomb to spawn!
								end
								if not canRun() then
									return
								end
								if canRun(true) then
									HarborRefuel()
								else -- Refueled!
									C.RemoveAction("Plane Refuel")
                                    if MainBody then
                                        MainBody.AssemblyAngularVelocity = Vector3.new()
                                    end
								end
							end
							Conn = BombC.Changed:Connect(CheckDORefuel)
							table.insert(self.Functs,Conn)
							table.insert(self.Functs,HP.Changed:Connect(CheckDORefuel))
							table.insert(self.Functs,Fuel.Changed:Connect(CheckDORefuel))
							table.insert(self.Functs,MainBody.ChildRemoved:Connect(CheckDORefuel))
							CheckDORefuel()
						end
					end,
					MySeatRemoved = function(self)
						C.RemoveAction("Plane Refuel")
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "HP",
						Tooltip = "Refuels when your health is below this percentage",
						Layout = 0,Default=99,
						Min=0,Max=99,Digits=0,
						Shortcut="MinHPPercentage",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Ammo",
						Tooltip = "Refuels when ammo is low",
						Layout = 1,Default=true,
						Shortcut="Ammo",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Bomb",
						Tooltip = "Refuels when bombs are out",
						Layout = 2,Default=true,
						Shortcut="Bomb",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Fuel",
						Tooltip = "Refuels when fuel is out",
						Layout = 3,Default=true,
						Shortcut="Fuel",
						Activate = C.ReloadHack,
					},
				},
			},
			{
				Title = "Vehicle",
				Tooltip = "Allows you to modify speed for ships and planes",
				Layout = 11, Functs = {}, Default = true,
				Shortcut = "VehicleSpeed",
				DontActivate = true,
				Activate = function(self,newValue)
					if C.human and C.human.SeatPart then
						if newValue then
							self.Events.MySeatAdded(self,C.human.SeatPart)
						else
							self.Events.MySeatRemoved(self,C.human.SeatPart)
						end
					end
				end,
				Set = function(self, Vehicle, LineVelocity, AlignOrientation, SpeedMult, TurnMult)
					--print("SEt",Vehicle,SpeedMult,TurnMult)
					local VehicleType = Vehicle:WaitForChild("HitCode").Value
					local FuelLeft = VehicleType == "Plane" and Vehicle:WaitForChild("Fuel")
					local FlyButton = C.StringWait(C.PlayerGui,"ScreenGui.InfoFrame.Fly")
					local MyData = C.DataStorage[Vehicle.Name]
					if not MyData.MaxTorque or not MyData.MaxForce then
						return
					end

					local isOn = (VehicleType == "Ship" or FlyButton.BackgroundColor3.R*255>250) and (not FuelLeft or (FuelLeft:GetAttribute("RealFuel") or FuelLeft.Value) > 0)
						--(FlyButton.BackgroundColor3.R*255>250 and self.EnTbl.InfFuel and false))

					self.LastSet = SpeedMult * LineVelocity.VectorVelocity
					LineVelocity.VectorVelocity = self.LastSet
					C.SetPartProperty(LineVelocity,"MaxAxesForce","VehicleHack",C.GetPartProperty(LineVelocity,"MaxAxesForce") * SpeedMult,true)
					C.SetPartProperty(LineVelocity,"MaxForce","VehicleHack",isOn and (MyData.MaxForce * SpeedMult) or 0,true)
					--LineVelocity.MaxForce = isOn and (MyData.MaxForce * SpeedMult) or 0
					--C.SetPartProperty(LineVelocity,"MaxForce","VehicleHack", isOn and (MyData.MaxForce * math.max(1,SpeedMult/6)) or 0, true) --* SpeedMult/8) or 0
					--(VehicleType=="Ship" and 49.281604e6 or 31.148e3)
					--C.SetPartProperty(AlignOrientation,"Responsiveness","VehicleHack",C.GetPartProperty(AlignOrientation,"Responsiveness") * (TurnMult*16),true)
					if AlignOrientation then
						AlignOrientation.MaxTorque = isOn and (MyData.MaxTorque * TurnMult) or 0
					end
					local Collisions = not self.EnTbl.NoCollisions or not isOn
					if Vehicle.PrimaryPart:GetAttribute("CanCollide_Request_VehicleHack") ~= (Collisions and nil) then
						self:SetCollisions(Vehicle,Collisions)
					end
				end,
				SetCollisions = function(self,Vehicle,Collidible)
					for num, basePart in ipairs(Vehicle:GetDescendants()) do
						if basePart:IsA("BasePart") then
							if Collidible then
								C.ResetPartProperty(basePart,"CanCollide","VehicleHack")
							else
								C.SetPartProperty(basePart,"CanCollide","VehicleHack",false)
							end
						end
					end
				end,
				LastSet = nil,
				Events = {
					MySeatAdded = function(self,seatPart)
						self.Events.MySeatRemoved(self,seatPart)
						local Vehicle = seatPart.Parent
						local HitCode = Vehicle:WaitForChild("HitCode",5)
						local FlyButton = C.StringWait(C.PlayerGui,"ScreenGui.InfoFrame.Fly")
						--The "BodyVelocity" is actually "LineVelocity"
						if HitCode and ((HitCode.Value == "Ship" and self.EnTbl.Ship) or (HitCode.Value == "Plane" and self.EnTbl.Plane)) then
							local MainBody = Vehicle:WaitForChild("MainBody")
							local LineVelocity = MainBody:WaitForChild("BodyVelocity")
							local VehicleType = Vehicle:WaitForChild("HitCode").Value
							local FuelLeft = HitCode.Value == "Plane" and Vehicle:WaitForChild("Fuel")
							local AlignOrientation = LineVelocity.Parent:FindFirstChildWhichIsA("AlignOrientation")
							self.LastSet = nil
							local function Upd()
								if self.LastSet and (LineVelocity.VectorVelocity - self.LastSet).Magnitude < 0.3 then
									return
								end
								local SpeedMult = self.EnTbl[HitCode.Value .. "Speed"]
								if VehicleType=="Ship" then
									SpeedMult = math.min(SpeedMult,1.8)
								end
								local TurnMult = SpeedMult--self.EnTbl[HitCode.Value .. "Turn"] or 1
								if C.GetAction("LoopBomb") or C.GetAction("Plane Refuel") then
									SpeedMult,TurnMult = 0, 0 -- Override to stop it from moving!
								end
								if FuelLeft then
									if self.EnTbl.InfFuel and false then
										if FuelLeft.Value < 500 then
											FuelLeft:SetAttribute("RealFuel",FuelLeft.Value)
										end
										FuelLeft.Value = 999999
									elseif FuelLeft:GetAttribute("RealFuel") then
										FuelLeft.Value = FuelLeft:GetAttribute("RealFuel")
									end
								end
								self:Set(Vehicle,LineVelocity,AlignOrientation,SpeedMult,TurnMult)
							end
							table.insert(self.Functs,LineVelocity:GetPropertyChangedSignal("VectorVelocity"):Connect(Upd))
							Upd()
						end
					end,
					MySeatRemoved = function(self, seatPart)
						self:ClearData()
						local Vehicle = seatPart.Parent
						if Vehicle and Vehicle.PrimaryPart then
							Vehicle.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
							Vehicle.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
							local MainBody = Vehicle:WaitForChild("MainBody")
							local LineVelocity = MainBody:WaitForChild("BodyVelocity")
							local AlignOrientation = LineVelocity.Parent:FindFirstChildWhichIsA("AlignOrientation")
							self:Set(Vehicle,LineVelocity,AlignOrientation,1, 1)
						end
					end,
                    PlaneAdded = function(self, vehicle)
                        if not self.EnTbl.AutoSit then
                            return
                        end
                        local owner = vehicle:FindFirstChild("Owner")
                        if owner then
                            if owner.Value == C.plr.Name then
                                vehicle.Seat:Sit(C.human)
                            end
                        end
                    end,
                    ShipAdded = function(self, ship)
                        self.Events.PlaneAdded(self,ship)
                    end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Ships",
						Tooltip = "Injects into Ships (i.e. submarines, battleships, carriers, cruisers)",
						Layout = 1,Default=true,
						Shortcut="Ship",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Planes",
						Tooltip = "Injects into Planes (i.e. Heavy Bomber, Torpedo Bomber, Bomber)",
						Layout = 2,Default=true,
						Shortcut="Plane",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "No Collisions",
						Tooltip = "Allows vehicles that you drive to go through collidble objects",
						Layout = 3,Default=false,
						Shortcut="NoCollisions",
					},
                    {
						Type = Types.Toggle,
						Title = "Auto Sit",
						Tooltip = "Automatically makes you sit in the pilot seat of a ship you spawned",
						Layout = 4,Default=false,
						Shortcut="AutoSit",
					},
					--[[{
						Type = Types.Toggle,
						Title = "Inf Fuel",
						Tooltip = "Tricks the game into thinking that you have infinite fuel",
						Layout = 4,Default=true,
						Shortcut="InfFuel",
					},--]]
					{
						Type = Types.Slider,
						Title = "Plane Speed",
						Tooltip = "How much faster you go when driving a plane",
						Layout = 5,Default=3,
						Min=0,Max=20,Digits=1,
						Shortcut="PlaneSpeed",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Slider,
						Title = "Ship Speed",
						Tooltip = "How much faster you go when driving a ship",
						Layout = 6,Default=3,
						Min=0,Max=20,Digits=1,
						Shortcut="ShipSpeed",
						Activate = C.ReloadHack,
					},
				}
			},
            {
				Title = "God Mode 2",
				Tooltip = "New and improved God Mode?\nBreaks the Rifle btw",
				Layout = 100,
				Shortcut = "GodMode2",
                TeleportTo = function(self,dataTbl)
                    local name = rawget(dataTbl,1)
                    local owner = rawget(dataTbl, 2)
                    local id = rawget(dataTbl, 3)

                    if name == "Harbour" then
					    local HarborModel = C.plr.Team.Name == "Japan" and workspace:WaitForChild("JapanDock") or workspace:WaitForChild("USDock")
                        local Barracks = C.StringWait(HarborModel,"Decoration.Barracks")
                        local List = Barracks:GetChildren()
                        local Index = C.Randomizer:NextInteger(1,#List)
                        local ChosenPart = List[Index]
                        local TelLoc = ChosenPart.Position + Vector3.new(0, 3, 0)
                        C.char:MoveTo(TelLoc)
                        return
                    end
                    for _, inst in ipairs(workspace:GetChildren()) do
                        if inst.Name == name then
                            if name == "Island" then
                                if inst.IslandCode.Value == owner then
                                    C.DoTeleportToObject(inst.PrimaryPart)
                                    return
                                end
                            else
                                if inst.Number.Value == id and inst.Owner.Value == owner and C.plr.Team.Name == inst.Team.Value then
                                    if inst.Name == "Battleship" then
                                        C.DoTeleportToObject(C.StringWait(inst,"Body.TopBody"))
                                    else
                                        C.DoTeleportToObject(inst.PrimaryPart)
                                    end
                                    return
                                end
                            end
                        end
                    end
                    warn(`[God Mode 2: TeleportTo]: SPAWN LOCATION NOT FOUND:`,name,owner,id)
                end,
                Activate = function(self,newValue)
                    local remoteEvent = C.RemoteEvent
                    local tskSpawn = task.spawn
                    local runFunct = rawget(self, "TeleportTo")
                    C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self, eventType, dataTbl)
						if self == remoteEvent and eventType == "Teleport" then
                            tskSpawn(runFunct, self, dataTbl)

							return "Cancel"
						end
					end,{"fireserver"})
                end,
            },
            {
				Title = "Change Teams",
				Tooltip = "One click to change teams!",
				Layout = 400,
				Shortcut = "ChangeTeams", Type = "NoToggle",
                Activate = function(self)
                    local part2Touch
                    if C.plr.Team.Name == "Japan" then
                        part2Touch = C.StringWait(workspace,"Lobby.TeamChange.ToUSA")
                    else
                        part2Touch = C.StringWait(workspace,"Lobby.TeamChange.ToJapan")
                    end
                    C.firetouchinterest(C.hrp, part2Touch)
                end,
            },
		},
	}
end
]=],
    ["Games/PassBomb"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

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
					local Bomb = C.char:WaitForChild("Bomb",5)
                    if Bomb then
                        local OldLoc
                        while Bomb.Parent and Bomb.Parent == C.char and self.RealEnabled do
                            local closestHead, dist = C.getClosest({noTeam=true})
                            if closestHead then
                                local theirChar = closestHead.Parent
                                if dist > 5 then
                                    if not OldLoc then
                                        OldLoc = theirChar:GetPivot()
                                    end
                                    C.DoTeleport(theirChar:GetPivot())
                                end
                                local args = {
                                    [1] = theirChar,
                                    [2] = theirChar:WaitForChild("CollisionPart"),
                                }
                                Bomb.RemoteEvent:FireServer(unpack(args))
                            end
                            RunS.RenderStepped:Wait()
                        end
                        if OldLoc then
                            C.DoTeleport(OldLoc)
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
						local BombVal = theirChar:WaitForChild("GotBombValue",10)
                        if not BombVal then
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
]=],
    ["Games/TowerBattles"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local DS = game:GetService("Debris")
local RunS = game:GetService("RunService")
local SocialService = game:GetService("SocialService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local LS = game:GetService("Lighting")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local function Static(C, Settings)
	table.insert(C.EventFunctions,function()
		C.AddGlobalThread(task.spawn(function()
			local instance = workspace:WaitForChild("Map",1e9)
			C.Map = instance
			C.FireEvent("MapAdded",nil,instance)
		end))
	end)
	C.PlayerInformation = C.plr:WaitForChild("Information")
end
local GamePlaceIds = {
	["N/A"]=0,
	["Lobby"]=45146873,
	["Halloween"]=45200529,
	["Arena (Versus)"]=46955756,
	["Survival"]=49707852,
	["Christmas"]=1241893197,
	["Halloween 2018"]=2470348319,
	["Winter 2019"]=2776257214,
	["Halloween 2023"]=5645832762,
	["Winter 2022"]=8652280014,
}
return function(C,Settings)
	Static(C,Settings)
	local TabTbl
	local IsPlacing = false
	local IgnorePoints = {}
	local CashVal,TowerCount, TowerCap
	if game.PlaceId ~= GamePlaceIds.Lobby then
		CashVal = C.PlayerInformation:WaitForChild("Cash")
		TowerCount = C.PlayerInformation:WaitForChild("Towers")
		TowerCap = workspace:WaitForChild("TowerCap").Value
	end 
	local function PlaceTroop(TroopName)
		if IsPlacing then return false, "Placement In Progress" end
		local TowerInformation = workspace:WaitForChild("TowerInformation")[TroopName]
		if TowerInformation.Value > C.PlayerInformation.Cash.Value then
			return false,
				C.CreateSysMessage(("Not Enough Cash: $%i Needed)"):format(TowerInformation.Value - C.PlayerInformation.Cash.Value))
		elseif TowerCount.Value >= TowerCap then
			return false,
				C.CreateSysMessage(("Max Towers %i/%i)"):format(TowerCount.Value, TowerCap))
		elseif not C.Map then
			return false, C.CreateSysMessage(`Map Not Found`)
		end
		IsPlacing = true

		local Path = {} -- Parts representing the path
		local StartTime = os.clock()

		local Range -- Range of the troop
		local PlacementType -- "Grass" / "High"
		local MinDistBetweenTroops = 4.5

		local TroopTemplate = not C.isStudio and LS.Placement[TroopName] -- Get the troop from ServerStorage
		local GroundY = C.Map:WaitForChild("Height").Value
		if TroopTemplate then
			local Default = TroopTemplate:IsA("Folder") and TroopTemplate.Default or TroopTemplate
			PlacementType = TroopTemplate.Type.Value
			Range = Default.Tower.Visibility.Mesh.Scale.X / 2
		end

		local BestPosition, BestPart = nil, nil -- Best troop placement
		local YOffset = 0
		local MaxCoveredArea = 0 -- Maximum total area covered

		-- Utility function to check if a point is within a circle
		local function isPointInCircle(point, circleCenter, radius)
			local dx = point.x - circleCenter.x
			local dz = point.z - circleCenter.z
			return (dx * dx + dz * dz) <= (radius * radius)
		end
		-- Function to calculate overlap area between a circle and a rectangle
		local function calculateCircleRectangleOverlap(circle, rect)
			local radius, circleCenter = circle.Size.Z / 2, circle.Position
			local rectSize, rectCenter = rect.Size, rect.Position

			if (C.ClosestPointOnPart(rect.CFrame, rectSize, circleCenter) - circleCenter).Magnitude > radius then
				return 0 -- disable for more thorough checking
			end
			-- Sample points inside the rectangle to check if they are inside the circle
			local sampleStepX = 1 / 2
			local sampleStepZ = 1 / 2

			local overlapCount = 0
			local totalSampleCount = 0


			-- Loop through the grid of points in the rectangle
			for x = rectCenter.x - rectSize.x / 2, rectCenter.x + rectSize.x / 2, sampleStepX do
				for z = rectCenter.z - rectSize.z / 2, rectCenter.z + rectSize.z / 2, sampleStepZ do
					local samplePoint = Vector3.new(x, 0, z)

					totalSampleCount = totalSampleCount + 1
					if isPointInCircle(samplePoint, circleCenter, radius) then
						overlapCount = overlapCount + 1
					end
				end
			end

			-- Calculate the percentage of samples that are within the circle
			local overlapArea = (overlapCount / totalSampleCount) * (rectSize.x * rectSize.z)

			return overlapArea
		end


		-- Function to calculate the total area covered for a given troop position
		local function CalculateTotalCoveredArea(troopPosition)
			local FakeRange = {
				Position = troopPosition,
				Orientation = Vector3.new(0,0,-90),
				Size = 2 * Vector3.new(10, Range, Range),
				Transparency = 0.8,
			}
			local totalCoveredArea = 0
			for _, part in pairs(Path) do
				totalCoveredArea = totalCoveredArea + calculateCircleRectangleOverlap(FakeRange, part)
			end
			return totalCoveredArea
		end

		-- Function to calculate the points inside a part
		local function calculatePointsInsideRotatedPart(part, step, yOffsetLocal)
			local points = {}

			-- Get part's position, size, and CFrame
			local position = part.Position -- Center of the part (Vector3)
			local size = C.GetPartGlobalSize(part) / Vector3.new(1.5,1,1.5) -- Size of the part (Vector3)
			local cframe = part.CFrame -- CFrame of the part (position and rotation)

			-- Calculate bounds in local space (assuming the part is centered at (0, 0) in local space)
			local minX = -(size.X / 2)
			local maxX = (size.X / 2)
			local minZ = -(size.Z / 2)
			local maxZ = (size.Z / 2)

			-- Iterate over the area using the step value (in local space)
			for x = minX, maxX, step do
				for z = minZ, maxZ, step do
					-- Create the point in local space
					local localPoint = Vector3.new(x, yOffsetLocal + size.Y/2, z) -- Flat part, so Z is 0
					local worldPoint = cframe.Position + (localPoint)
					table.insert(points, worldPoint)
				end
			end

			return points
		end

		local PotentialPositions = {}
		local Nodes = C.Map:WaitForChild("BlueNodes")
		local CurPart, LastPart, Index = nil, Nodes.Start, 0

		while not CurPart or CurPart.Name ~= "Finish" do
			Index += 1
			CurPart = Nodes:FindFirstChild(Index) or Nodes.Finish
			local newPart = Instance.new("Part",workspace.Camera)
			local startPosition, endPosition = LastPart.centAt.WorldPosition, CurPart.centAt.WorldPosition
			-- Calculate the midpoint between startPosition and endPosition
			local midPoint = (startPosition + endPosition) / 2

			-- Calculate the distance between the two points
			local distance = (endPosition - startPosition).Magnitude

			-- Position the part at the midpoint
			newPart.Position = midPoint

			-- Scale the part so that it spans the distance between the two points
			newPart.Size = Vector3.new(1, .5, distance)

			-- Align the part's CFrame to face the endPosition
			newPart.CFrame = CFrame.new(startPosition, endPosition) * CFrame.new(0, 0, -distance / 2)

			newPart.Anchored = true
			newPart.Name = "Path"..Index
			newPart.CanCollide, newPart.CanQuery = false, false
			newPart.CanTouch = false
			newPart.Transparency = .6
			newPart.Color = Color3.fromRGB(25,25,180)
			newPart.TopSurface = Enum.SurfaceType.Smooth
			newPart.BottomSurface = Enum.SurfaceType.Smooth
			table.insert(Path,newPart)
			LastPart = CurPart
		end
		local cycles = 1
		local MaxPlacement = C.enHacks.TowerBattles.AutoPlace.Placement=="Anywhere" and PlacementType == "High"
		repeat
			if cycles >= 3 then
				C.CreateSysMessage(`Maximum Cycles of {cycles} reached and no position found!`,Color3.fromRGB(25,225,25))
				break
			end
			for _, placement in ipairs(C.Map:GetDescendants()) do
				if not (((cycles==1 and placement.Name == PlacementType) or (MaxPlacement and cycles > 1 and placement.Name == "High")) and placement:IsA("BasePart")) then
					continue
				end
				for num, point in ipairs(calculatePointsInsideRotatedPart(placement, 1, YOffset)) do
					local overlapping = (PlacementType == "High" and point.Y < GroundY + .5)
						or (PlacementType == "Grass" and math.abs(point.Y - GroundY)>4)
					--[[if not overlapping then
						for num2, path in ipairs(Map:WaitForChild("Bad"):GetChildren()) do
							if C.IsInBox(path.CFrame, path.Size, point - Vector3.new(0,YOffset)) then
								overlapping = true
								break
							end
						end
					end--]]
					if not overlapping then
						local firstPoint
						local HitRes, HitPos = C.Raycast(point + Vector3.new(0,.5),-Vector3.new(0,1.5,0),{
							--distance = YOffset,
							raycastFilterType = Enum.RaycastFilterType.Include,
							ignoreList = {C.Map},
						})
						local HitInst = HitRes and HitRes.Instance
						if HitInst then
							if HitInst.Name == PlacementType then
								point = HitRes.Position
							else
								overlapping = true
							end
						end
					end
					if not overlapping then
						local hasChecked = false
						local stackleft = (PlacementType == "High" and tonumber(C.enHacks.TowerBattles.AutoPlace.StackAmount) or 0)
						repeat
							hasChecked = true
							for num3, tower in ipairs(workspace:WaitForChild("Towers"):GetChildren()) do
								if (point - tower:WaitForChild("FakeBase").Position).Magnitude < MinDistBetweenTroops then
									if stackleft > 0 then
										stackleft -= 1
										point += Vector3.new(0,MinDistBetweenTroops+.3,0)
										hasChecked = false
									else
										overlapping = true
									end
									break
								end
							end
							--RunS.RenderStepped:Wait()
						until stackleft == 0 or hasChecked
					end
					if not overlapping and IgnorePoints[point] == nil then
						table.insert(PotentialPositions, {Point = point, Part = placement})
					end
					if num%1000 == 0 then
						RunS[C.isStudio and "Heartbeat" or "RenderStepped"]:Wait()
					end
				end
			end

			local NumLeft = #PotentialPositions

			-- Loop through all potential positions and find the best one
			for num, positionData in pairs(PotentialPositions) do
				local coveredArea = CalculateTotalCoveredArea(positionData.Point)
				if coveredArea >= MaxCoveredArea then
					MaxCoveredArea = coveredArea
					BestPosition, BestPart = positionData.Point, positionData.Part
				end
				NumLeft -= 1
				if num%1000 == 0 then
					RunS[C.isStudio and "Heartbeat" or "RenderStepped"]:Wait()
				end
			end
			cycles += 1
		until BestPart or not MaxPlacement

		for _, pathInstance in ipairs(Path) do
			pathInstance:Destroy()
		end
		task.delay(1/3,function()
			IsPlacing = false
		end)
		local TotalTime = os.clock() - StartTime

		-- Place troop at the best position
		if BestPosition and MaxCoveredArea > 1e-2 then
			if Range * 0.05 > MaxCoveredArea then
				return false, C.CreateSysMessage(("Min Size Failed of %.1f%%. Best find was %.1f"):format(Range*0.05,MaxCoveredArea))
			end
			if not C.isStudio then
				--C.DoTeleport(BestPosition+Vector3.new(0,3,0))
				C.createTestPart(BestPosition)
				local Result = "Worked"--workspace.PlacingTower:InvokeServer(TroopName)
				if Result == "Worked" then
					Result = workspace.Placed:InvokeServer(BestPosition - Vector3.new(0,0.4,0), 1, TroopName, BestPart);
					if Result == true then
						return true,
							C.CreateSysMessage(("Placement Succeeded: %i/%i (%.1f seconds)"):format(
								MaxCoveredArea,Range*2*math.pi,TotalTime),Color3.fromRGB(0,225))
					else
						IgnorePoints[BestPosition] = true
						return false, C.CreateSysMessage("Placement Failed: "..tostring(Result))
					end
				else
					return false, C.CreateSysMessage("Tower Placing Failed: "..tostring(Result))
				end
			end
		else
			C.CreateSysMessage(("Position Failed: No valid position found (%.1f seconds)"):format(TotalTime))
			return false, "No Position"
		end

		return true
	end
	TabTbl = {
		Category = {
			Name = "TowerBattles",
			Title = "Tower Battles",
			Image = nil, -- Set to nil for game image
			Layout = 20,
		},
		Tab = {
			{
				Title = "Join Mode",
				Tooltip = "Automatically joins the selected mode!",
				Layout = 1,
				Shortcut = "JoinMode",Functs={},Threads={},
				Activate = function(self,newValue,firstRun)
					if not newValue then
                        return
                    end
                    if game.PlaceId == 45146873 then
						local NeedsToCollectVal = C.StringWait(C.plr, "Information.NeedsToCollect")
						while NeedsToCollectVal.Value and not self.EnTbl.IgnoreReward do
							NeedsToCollectVal.Changed:Wait()
						end
						local JoinLocation = GamePlaceIds[self.EnTbl.Gamemode]
						assert(JoinLocation,`Invalid JoinLocation: `..self.EnTbl.Gamemode)
						C.ServerTeleport(JoinLocation, nil)
					end
				end,
                Events = {},
				Options = {
					{
						Type = Types.Dropdown,
						Title = "Gamemode",
						Tooltip = "Choose which game to join",
						Layout = 1,Default="Survival",
						Shortcut="Gamemode",
						Selections = {"Halloween","Arena (Versus)","Survival","Christmas","Halloween 2018",
						"Winter 2019","Halloween 2023","Winter 2022"},
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Reward",
						Tooltip = "Proceed to join without waiting to collect your reward, overriding it",
						Layout = 2,Default=false,
						Shortcut="IgnoreReward",
						Activate = C.ReloadHack,
					},
				},
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
					local lastClickTime
					local toStr,tskSpawn, tskDefer = tostring, task.spawn, task.defer
					C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,troopName)
						--tskSpawn(print,"invoke",self)
						if toStr(self) == "PlacingTower" and troopName then
							if lastClickTime and os.clock() - lastClickTime < .5 then
								return
							end
							tskDefer(PlaceTroop,troopName)
							lastClickTime = os.clock()
							return "Yield"
						end
					end,{"invokeserver"})
				end,
				Options = {
					{
						Type = Types.Dropdown,
						Title = "Stack",
						Tooltip = "How many troops to stack on",
						Layout = 1,Default="Disabled",
						Shortcut="StackAmount",
						Selections = {"Disabled","1","2","3","4","5"},
					},
					{
						Type = Types.Dropdown,
						Title = "Placement",
						Tooltip = "Where troops can be placed; only affects Placement High troops (i.e. Snipers) where Stack is not disabled.",
						Layout = 2,Default="Placement",
						Shortcut="Placement",
						Selections = {"Legal","Anywhere"},
					},
				},
			},
			{
				Title = "Auto Bot",
				Tooltip = "Plays for you",
				Shortcut = "AutoBot",
				Layout = 5, Threads = {},
				Activate = function(self, newValue, firstRun)
					if not newValue or GamePlaceIds.Lobby == game.PlaceId then
						return
					end
					local NoSpotsLeft = false
					while GamePlaceIds.Survival == game.PlaceId and workspace.VoteCount.Value > 0 do
						local selMap, maxLength = nil, nil
						for mapIndex = 1, 3 do
							local mapStat = workspace:WaitForChild("Map"..mapIndex)
							local mapType = mapStat:WaitForChild("Type").Value
							local mapData = C.StringWait(workspace,"MapsInformation."..mapType)
							local mapLength = mapData:WaitForChild("Length").Value
							if self.EnTbl.PickMap == mapType then
								selMap = mapStat
								break
							elseif self.EnTbl.PickMap == "Longest Of 3" then
								if not selMap or maxLength < mapData.Length.Value then
									selMap, maxLength = mapStat, mapData.Length.Value
								end
							end
						end
						if selMap then
							workspace.Vote:InvokeServer(selMap.Name)
							workspace.SkipWaitVote:InvokeServer()
						else
							workspace.Vote:InvokeServer("Veto")
						end
						workspace.VoteCount.Changed:Wait()
					end
					-- MAP LOADING --
					if not workspace:FindFirstChild("Map") then
						workspace:WaitForChild("Map") -- Wait for it to be inserted!
						task.wait(2.5) -- Wait for it to load
					end
					-- AUTOPLAY TIME--
					local AutoPlayCond = self.EnTbl.AutoplayCond
					local WaveStop = AutoPlayCond:gmatch("Wave %d+")() and tonumber(AutoPlayCond:gmatch("%d+")())
					local TowerIndex = self.EnTbl.AutoplayTroop:gmatch("%d+")()
					local ChosenTower = C.StringWait(C.plr, "StuffToSave.Tower"..TowerIndex).Value
					while true do
						-- RUN CONDITION --
						if WaveStop and workspace.Waves.Wave.Value >= WaveStop then
							break
						elseif AutoPlayCond == "Never" then
							break
						end
						if ChosenTower == "Nothing" then
							return C.Prompt("Invalid Tower", "In Slot "..TowerIndex..", you have nothing equipped.")
						end
						-- NEEDS --
						local Priority = self.EnTbl.AutoplayStyle or "Quality"
						local Action, ActionType
						local CashCost
						if not NoSpotsLeft then
							if Priority == "Sniper" then
								local MyTowers, HiddenDet = 0, 0
								for num, towerModel in ipairs(workspace:WaitForChild("Towers"):GetChildren()) do
									if towerModel.Owner.Value == C.plr then
										local Level = C.StringWait(towerModel,"Tower.UP1").Value + 1
										if Level >= 3 then
											HiddenDet+=1
										end
										MyTowers+=1
									end
								end
								if (HiddenDet >= 3 or MyTowers < 3) and MyTowers < TowerCap then
									Priority = "Quantity"
								else
									Priority = "Quality"
								end
							end
						else
							Priority="Quality"
						end
						local TowerInformation, LowestLevel
						if Priority == "Quality" then
							Action, LowestLevel = nil, 5
							local TowerType = nil
							for num, towerModel in ipairs(workspace:WaitForChild("Towers"):GetChildren()) do
								if towerModel.Owner.Value == C.plr then
									local Level = C.StringWait(towerModel,"Tower.UP1").Value + 1
									if Level < LowestLevel then
										TowerType, Action, LowestLevel = C.StringWait(towerModel,"Tower.Tower").Value,
											towerModel.Name,Level
									end
								end
							end
							if not TowerType then
								Priority = "Quantity"
							else
								ActionType = "Upgrade"
								TowerInformation = workspace:WaitForChild("TowerInformation")[TowerType]
								CashCost = TowerInformation[tostring(LowestLevel)].Value
							end
						end
						if Priority == "Quantity" then
							if TowerCount.Value >= TowerCap then
								C.CreateSysMessage(`Your towers are maxed ({TowerCount.Value}/{TowerCap})`,
									Color3.fromRGB(25,225,25))
								break
							end
							Action = ChosenTower
							TowerInformation = workspace:WaitForChild("TowerInformation")[ChosenTower]
							CashCost = TowerInformation.Value
							ActionType = "Place"
						end
						-- TOWER PLACE --
						if CashVal.Value < CashCost then
							while CashVal.Value < CashCost do
								C.PlayerInformation.Cash:GetPropertyChangedSignal("Value"):Wait()
							end
						elseif ActionType == "Upgrade" then
							if workspace.Towers:FindFirstChild(tostring(Action)) then
								local Result = workspace.UpgradeTower:InvokeServer(Action)
								if Result then
									C.CreateSysMessage(`Upgrade Tower Success: {ChosenTower} #{Action} to Level {LowestLevel+1} for ${CashCost}`,
										Color3.fromRGB(25,225,25))
								else
									C.CreateSysMessage(`Upgrade Tower Fail: {tostring(Result)}!`)
								end
							else
								RunS.RenderStepped:Wait()
							end
						elseif ActionType == "Place" and not IsPlacing then
							local Result, Error = PlaceTroop(ChosenTower)
							if not Result then
								if Error == "No Position" then
									NoSpotsLeft = true
								end
								task.wait(1/3)
							end
						else
							RunS.RenderStepped:Wait()
						end
					end
					-- SELL ALL --
					while WaveStop and workspace.Waves.Wave.Value < WaveStop do
						workspace.Waves.Wave.Changed:Wait()
					end
					if WaveStop and workspace.Waves.Wave.Value >= WaveStop then
						local TowersCount = 0
						for num, towerModel in ipairs(workspace:WaitForChild("Towers"):GetChildren()) do
							if towerModel.Owner.Value == C.plr then
								TowersCount+=1
							end
						end
						if TowersCount > 0 then
							local Waiting = true
							table.insert(self.Threads,task.delay(10,function()
								if Waiting then
									C.Prompt_ButtonTriggerEvent:Fire(true)
								end
							end))
							local Res = C.Prompt(`Selling All Towers ({TowersCount})`,
								`ALL YOUR TOWERS WILL BE SOLD IN 10 SECONDS!!\nYES TO ACTIVATE RIGHT NOW, NO TO CANCEL`,`Y/N`)
							Waiting = false
							if Res == true then
								for num, towerModel in ipairs(workspace:WaitForChild("Towers"):GetChildren()) do
									if towerModel.Owner.Value == C.plr then
										task.spawn(workspace.SellTower.InvokeServer,workspace.SellTower,towerModel.Name)
									end
								end
							end
						end
					end
				end,
				Options = {
					{
						Type = Types.Dropdown,
						Title = "Map Selection",
						Tooltip = "In survival, vetos until chosen map is found.",
						Layout = 1,Default="Borderlands",
						Shortcut="PickMap",
						Selections = {"Nothing","Midnight Road","Borderlands","Longest Of 3"},
					},
					{
						Type = Types.Dropdown,
						Title = "Autoplay Condition",
						Tooltip = "Until what wave the autoplay runs before SELLING ALL TOWERS",
						Layout = 2,Default="Never",
						Shortcut="AutoplayCond",
						Selections = {"Never","Wave 20","Always"},
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Dropdown,
						Title = "Autoplay Troop",
						Tooltip = "What troop is autoplayed",
						Layout = 3, Default = "Slot 2",
						Shortcut="AutoplayTroop",
						Selections = {"Slot 1","Slot 2","Slot 3","Slot 4","Slot 5"},
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Dropdown,
						Title = "Autoplay Style",
						Tooltip = "How the bot plays: quantity of more towers or quality of less towers?",
						Layout = 4, Default = "Sniper",
						Shortcut="AutoplayStyle",
						Selections = {"Quality","Sniper","Quantity"},
						Activate = C.ReloadHack,
					},
				},
			},
			{
				Title = "Claim Goodies",
				Tooltip = "Automatically claims goods",
				Shortcut = "ClaimRewards",
				Layout = 15, Functs = {},
				RewardFrames = {
					JustFinished = "SurvivalAnalysis",
					JustFinishedWinter = "Winter2022Analysis",
					JustFinishedHallow = "Halloween2023Analysis",
					JustTied = "Triumph",
					JustWon = "Winner",
				},
				Activate = function(self, newValue, firstRun)
					if not newValue then
						return
					end
					if game.PlaceId ~= GamePlaceIds["Lobby"] then
						if not firstRun then
							C.AddNotification("Restricted Game","This hack only works in the lobby")
						end
						return
					end
					local cent = C.StringWait(C.PlayerGui,"Games.cent")
					for num, frame in ipairs(cent:GetChildren()) do
						if frame:IsA("Frame") then
							local RemoteName = self.RewardFrames[frame.Name]
							if RemoteName then
								local function VisiblityChanged()
									if not frame.Visible then
										return
									end
									local RemoteInstance = workspace:WaitForChild(RemoteName)
									local RemoteResult = RemoteInstance:InvokeServer()
									if RemoteResult == "Success" then
										frame.Visible = false
									end
								end
								table.insert(self.Functs,frame:GetPropertyChangedSignal("Visible"):Connect(VisiblityChanged))
								task.spawn(VisiblityChanged)
							end
						end
					end
				end,
			},
			{
				Title = "Fix Teleport Back",
				Tooltip = "Sometimes when the game crashes, it doesn't teleport all users back. This fixes it!",
				Layout = 30,
				Shortcut = "FixTeleportBack",Threads={},
				Activate = function(self,newValue,firstRun)
					if not newValue then
                        return
                    end
					local Announce = C.StringWait(workspace,"Waves.Anounce")
					while Announce.Value == "Teleporting everybody back to the Lobby..." do
						C.API(C.ServerTeleport,nil,1,GamePlaceIds.Lobby)
						task.wait(5)
					end
				end,
			},
		}
	}
	return TabTbl
end]=],
    ["Hacks/Blatant"] = [[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local function getMass(model)
	assert(model and model:IsA("Model"), "Model argument of getMass must be a model.");

	return model.PrimaryPart and model.PrimaryPart.AssemblyMass or 0;
end
return function(C,Settings)
	return {
		Category = {
			Name = "Blatant",
			Title = "Blatant",
			Image = 10901055597,
			Layout = 2,
		},
		Tab = {
			{
				Title = "AutoTeleportBack",
				Tooltip = "Teleports back when inside of the game",
				Layout = 0, Threads = {}, Functs={},
				Shortcut = "AutoTeleportBack",Default=true,
				Activate = function(self,newValue)
					if not newValue or not C.human then
						return
					end
					local CenterPart = (C.human.RigType == Enum.HumanoidRigType.R6 and C.char:WaitForChild("Torso",2)) or C.char:WaitForChild("HumanoidRootPart")
					local newInput = nil
					C.LastLoc = C.char:GetPivot() -- Inital Starting Position
					self.BlockTeleports = (not C.isInGame or C.isInGame(C.char))
					table.insert(self.Functs,RunS.RenderStepped:Connect(function()
						C.LastLoc = C.char:GetPivot()
					end))
					local function TeleportDetected()
						if C.Camera.CameraType == Enum.CameraType.Scriptable and self.EnTbl.Active == "Camera On Character" then
							return
						end
						newInput = C.char:GetPivot()
						if self.BlockTeleports and CenterPart.AssemblyMass == math.huge then
							if (newInput.Position - C.LastLoc.Position).Magnitude > 1 then
								C.LastTeleportLoc = C.LastLoc
								C.char:PivotTo(C.LastLoc)
								if self.EnTbl.UpdateOthers and C.hrp.AssemblyAngularVelocity.Magnitude < .5 then
									C.hrp.AssemblyAngularVelocity += Vector3.new(0,3,0)
								end
							end
						elseif (C.isInGame and C.isInGame(C.char)) then
							task.wait(.5)
							self.BlockTeleports = true
						end
					end
					local function AddToCFrameDetection(part)
						table.insert(self.Functs,part:GetPropertyChangedSignal("Position"):Connect(TeleportDetected))
						--table.insert(self.Functs,part:GetPropertyChangedSignal("CFrame"):Connect(TeleportDetected))
					end
					for num, part in ipairs(C.char:GetChildren()) do
						if part:IsA("BasePart") then--and part.Name == "Head" then
							AddToCFrameDetection(part)
						end
					end
				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "NoMove Update",
						Tooltip = "Updates for other players when you're not moving",
						Layout = 1,Default=true,
						Shortcut="UpdateOthers",
					},
					{
						Type = Types.Dropdown,
						Title = "Active",Default="Camera On Character",
						Tooltip = "Only runs when this condition is true.",
						Selections={"Always","Camera On Character"},
						Layout = 2,
						Shortcut="Active",
					},
				},
			},
			{
				Title = "Fly",
				Tooltip = "Allows you to fly on enable",
				Layout = 1,DontActivate=true,
				Shortcut = "Fly",Functs={},Instances={},Default=false,Keybind = "Z",
				AllowedIds={1416947241,939025537,894494203,894494919,961932719,6802445333},
                Anims={},
				RunOnDestroy=function(self)
					self:ClearData()
					self:Activate(false)
				end,
                IsAnimationWhitelisted = function(self, animTrack)
                    if animTrack.Priority.Value > Enum.AnimationPriority.Movement.Value
                        and animTrack.Priority ~= Enum.AnimationPriority.Core then
                        return true
                    elseif animTrack.Animation.Name == "ToolNoneAnim" then
                        return true
                    end
                    local id = tonumber(animTrack.Animation.AnimationId:gmatch("%d+")())
                    return self.AllowedIds[id]
                end,
                StopAnimation = function(self, v)
                    if v.Looped then
                        table.insert(self.Anims, v)
                        v:SetAttribute("OrgSpeed", v.Speed)
                    end
                    v:Stop(0)
                end,
				StopAllAnims=function(self)
					for i, v in pairs(C.animator:GetPlayingAnimationTracks()) do
						if not self:IsAnimationWhitelisted(v) then
                            self:StopAnimation(v)
						end
					end
				end,
                StartAnims = function(self)
                    for _, v in ipairs(self.Anims) do
                        v:Play(0, 1, v:GetAttribute("OrgSpeed"))
                        v:SetAttribute("OrgSpeed",nil)
                    end
                    self.Anims = {}
                end,
				Activate = function(self,newValue)
					if not C.human then return end --else task.wait(.1) end
                    local IsSeated = false
                    if C.human:GetState() ~= Enum.HumanoidStateType.Seated then -- Only update if not sitting
					    C.human:SetStateEnabled(Enum.HumanoidStateType.Seated,not newValue)
                    else
                        IsSeated = true
                    end

					if not newValue then
						self:StopAllAnims()
                    else
                        self:StartAnims()
					end

					if C.char:FindFirstChild("Animate") ~=nil and game.GameId~=372226183 and C.gameName ~= "NavalWarefare" then
						C.char.Animate.Enabled = not newValue
					end

					if not newValue then
						if C.char and C.hrp and C.human then
							local Orient = C.hrp.Orientation

							local options = {
								ignoreInvisibleWalls = false,
								ignoreUncollidable = true,
								ignoreList = {C.char},  -- Example: ignore parts in this list
								raycastFilterType = Enum.RaycastFilterType.Exclude,  -- Choose filter type
								distance = C.getCharacterHeight(C.char)+3.1,  -- Retry up to 3 times
							}

							local hitResult, hitPosition = C.Raycast(C.hrp.Position+Vector3.new(0,3,0),-Vector3.new(0,3,0),options)


							if hitResult then
								C.DoTeleport(CFrame.new(hitPosition) * CFrame.Angles(0,math.rad(Orient.Y),0) + Vector3.new(0,C.getCharacterHeight(C.char)))
							else
								C.DoTeleport(CFrame.new(C.char:GetPivot().Position) * CFrame.Angles(0,math.rad(Orient.Y),0))
							end
							C.hrp.AssemblyAngularVelocity = Vector3.zero

                            if not IsSeated then
							    C.human:ChangeState(Enum.HumanoidStateType.Running)
                            end
						end

						return
					else
                        if not IsSeated then
						    C.human:ChangeState(Enum.HumanoidStateType.Physics)
                        end
						task.spawn(self.StopAllAnims,self)
					end

					local enTbl = self.EnTbl

					local alignOrien, lineVel, vectorForce
                    local dumpLocation = C.hrp
                    --local dumpLocation = workspace:FindFirstChildWhichIsA("BasePart",true)
                    --if C.char:IsAncestorOf(dumpLocation) then
                    --    dumpLocation = workspace
                    --    warn("[Blatant.Fly]: DumpLocation targeted BasePart inside C.char; re-parenting to workspace!")
                    --end

					if enTbl.LookDirection then
						alignOrien = Instance.new("AlignOrientation")
						--alignOrien.MaxTorque = 10^6
                        alignOrien.Responsiveness = 200 -- Instant turn speed
                        alignOrien.RigidityEnabled = true -- Instant turn speed
                        alignOrien.Mode = Enum.OrientationAlignmentMode.OneAttachment
                        alignOrien.Attachment0 = C.rootAttachment
						--alignOrien.P = 10^6
						--alignOrien.D = 800
						--alignOrien.Name = "BasePart"
						alignOrien.Parent = dumpLocation
						table.insert(self.Instances,alignOrien)
					end
					if enTbl.Mode == "Physics" then
						lineVel = Instance.new("LinearVelocity")
						lineVel.MaxForce = 10^6
                        lineVel.RelativeTo = Enum.ActuatorRelativeTo.World
                        lineVel.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
                        lineVel.Attachment0 = C.rootAttachment
						--lineVel.P = 10^4
						--bodyVel.Name = "BasePart"
						lineVel.Parent = dumpLocation
						table.insert(self.Instances,lineVel)
					else
						vectorForce = Instance.new("VectorForce")
                        vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
                        vectorForce.Attachment0 = C.rootAttachment
						vectorForce.Force = Vector3.new(0,workspace.Gravity * getMass(C.char))
                        vectorForce.Parent = dumpLocation
						table.insert(self.Instances,vectorForce)
					end

					local SaveMode = enTbl.Mode
					--local CharacterMass = getMass(C.char)
					local function onUpdate(dt)
						local cf = workspace.CurrentCamera.CFrame

						local charCF = C.char:GetPivot()

						local MoveDirection = C.human.MoveDirection * Vector3.new(1,0,1)
						if MoveDirection:Dot(MoveDirection) > 0 then
							MoveDirection = (cf * CFrame.new((CFrame.new(cf.p, cf.p + Vector3.new(cf.lookVector.x, 0, cf.lookVector.z)):VectorToObjectSpace(MoveDirection)))).p - cf.p;
							MoveDirection = MoveDirection.Unit
						else
							MoveDirection = Vector3.zero
						end
						local up = 0
						if enTbl.UseExtraKeybinds then
							if (C.IsJumping) then
								up += 1
							end
							if (UIS:IsKeyDown(Enum.KeyCode.E)) then
								up += 1
							end
							if (UIS:IsKeyDown(Enum.KeyCode.Q)) then
								up -= 1
							end
						end
						MoveDirection = (cf.UpVector * up + MoveDirection)

						if (MoveDirection:Dot(MoveDirection) > 0) then
							MoveDirection = MoveDirection.Unit
						end

						local newVelocity = (MoveDirection * Vector3.new(enTbl.HorizontalMult,enTbl.VerticalMult,enTbl.HorizontalMult)) * enTbl.Speed * 5
							* (enTbl.UseWalkSpeed and (C.human.WalkSpeed/C.Defaults.WalkSpeed) or 1)
						if alignOrien then
							alignOrien.CFrame = cf
						else
							C.hrp.AssemblyAngularVelocity = Vector3.zero
						end
						if SaveMode == "Physics" then
							lineVel.VectorVelocity = newVelocity
						elseif SaveMode == "CFrame" then
							C.DoTeleport(charCF + dt * newVelocity)
							C.hrp.AssemblyLinearVelocity = Vector3.zero-- + dt * CharacterMass * workspace.Gravity * Vector3.new(0, 1, 0)
							--C.hrp.AssemblyAngularVelocity = Vector3.zero
							--bodyVel.Velocity = Vector3.new(0,newVelocity.Y,0)
						elseif SaveMode == "Velocity" then
							C.hrp.AssemblyLinearVelocity = newVelocity-- + dt * workspace.Gravity * Vector3.new(0, 1, 0)--* CharacterMass * workspace.Gravity
							--bodyVel.Velocity = newVelocity.Y
						end
					end

					table.insert(self.Functs,RunS.PreSimulation:Connect(onUpdate))
					local function animatorPlayedFunction(animTrack)
                        if not self:IsAnimationWhitelisted(animTrack) then
                            self:StopAnimation(animTrack)
						end
					end
					table.insert(self.Functs,C.animator.AnimationPlayed:Connect(animatorPlayedFunction))
					onUpdate()
				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
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
						Layout = 2,Default="Physics",
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
			{
				Title = "Swim",
				Tooltip = "Allows you to swim on enable",
				Layout = 4,DontActivate=true,
				Shortcut = "Swim",Functs={},
				Activate = function(self,newValue)
					if not C.human then
						return
					end
					C.human:SetStateEnabled(Enum.HumanoidStateType.Jumping,not newValue)
					C.human:SetStateEnabled(Enum.HumanoidStateType.GettingUp,not newValue)
					if not newValue then
						C.human:ChangeState(Enum.HumanoidStateType.GettingUp)
						return
					end
					C.human:ChangeState(Enum.HumanoidStateType.Swimming)
					table.insert(self.Functs,C.human.StateChanged:Connect(function(old, new)
						if old == Enum.HumanoidStateType.Swimming then
							C.human:ChangeState(Enum.HumanoidStateType.Swimming)
						end
					end))
					table.insert(self.Functs,RunS.PreSimulation:Connect(function(delta: number)
						local swimForce = C.human.MoveDirection * Vector3.new(self.EnTbl.HorizontalMult,self.EnTbl.VerticalMult,self.EnTbl.HorizontalMult) * self.EnTbl.MoveSpeed
						if self.EnTbl.WalkSpeed then
							swimForce *= (C.human.WalkSpeed / C.Defaults.WalkSpeed)
						end
						swimForce += Vector3.new(0,self.EnTbl.FloatSpeed,0)
						C.hrp.AssemblyLinearVelocity = swimForce * (delta * 60)
					end))
				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "Move Speed",
						Tooltip = "How fast you swim through the air",
						Layout = 1,Default=20,
						Min=0,Max=200,Digits=1,
						Shortcut="MoveSpeed",
					},
					{
						Type = Types.Slider,
						Title = "Float Speed",
						Tooltip = "How fast you go up",
						Layout = 1,Default=4,
						Min=-20,Max=20,Digits=0,
						Shortcut="FloatSpeed",
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
				}
			},
			{
				Title = "Noclip",
				Tooltip = "Allows your character to walk through walls",
				Layout = 5,
				Shortcut = "Noclip",Functs={},Default=false,Keybind = "R",
				RunOnDestroy=function(self)
					self:Activate(false)
				end,
				Update = function(value)
					for num, part in ipairs(C.char:GetDescendants()) do
						if part:IsA("BasePart") then
							if value then
								C.SetPartProperty(part,"CanCollide","NoClip",false,true)
							else--part, propertyName, requestName, value, alwaysSet
								C.ResetPartProperty(part,"CanCollide","NoClip")
							end
						end
					end
				end,
				Activate = function(self,newValue,firstRun)
					if not C.char then
						return
					end
                    if not newValue and C.human and C.human.FloorMaterial ~= Enum.Material.Air then
                        C.human:ChangeState(Enum.HumanoidStateType.Landed)
                    end
					if C.human then
						if newValue and not self.EnTbl.EnClimbing then
							C.human:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
						else
							C.human:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
						end
					end
					self.Update(newValue)
					if not newValue then
						return
					end
					table.insert(self.Functs,RunS.Stepped:Connect(self.Update))
				end,
				Cleared = function(self)

				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Enable Climbing",
						Tooltip = "Allows you to climb ladders while still noclipping.\nThis may mess with ",
						Layout = 3,Default=false,
						Shortcut="EnClimbing",
						Activate = C.ReloadHack,
					},
				}
			},
			{
				Title = "Teleport",
				Tooltip = "Teleports your character to where your mouse is",
				Layout = 10, Type = "NoToggle",
				Shortcut = "Teleport",Keybind = "T",
				Activate = function(self,newValue)
					if not C.char then
						return
					end

					local mouseLocation = UIS:GetMouseLocation()
                    local myIgnoreList = {C.char};

                    if self.EnTbl.CamIgnoreDist > 0 then
                        for num, part in ipairs(workspace:GetPartBoundsInRadius(workspace.CurrentCamera.CFrame.Position,self.EnTbl.CamIgnoreDist)) do
                            table.insert(myIgnoreList,part)
                        end
                    end

					local screenToWorldRay = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)

					local options = {
						ignoreInvisibleWalls = self.EnTbl.IgnoreInvisibleWalls,
						ignoreUncollidable = self.EnTbl.IgnoreUncollidibleWalls,
						ignoreList = myIgnoreList,  -- Example: ignore parts in this list
						raycastFilterType = Enum.RaycastFilterType.Exclude,  -- Choose filter type
						distance = self.EnTbl.Distance,  -- Retry up to 3 times
						collisionGroup = C.hrp.CollisionGroup,
						Type = screenToWorldRay.Direction,
					}

					local hitResult, hitPosition = C.Raycast(screenToWorldRay.Origin,screenToWorldRay.Direction,options)


					if (self.EnTbl.AlwaysTeleport or hitResult) and C.char.PrimaryPart then
						local OrientX,OrientY,OrientZ = C.char:GetPivot():toEulerAnglesXYZ()

						C.DoTeleport(CFrame.new(hitPosition) * CFrame.Angles(OrientX,OrientY,OrientZ) + Vector3.new(0,C.getCharacterHeight(C.char)))
					end
				end,
				Options = {
					{
						Type = Types.Toggle,
						Title = "Always Teleport",
						Tooltip = "Always teleport, even if the ray did not hit anything",
						Layout = 0,Default=true,
						Shortcut="AlwaysTeleport",
					},
					{
						Type = Types.Slider,
						Title = "Distance*",
						Tooltip = "How far the ray is cast. Longer rays cost more performance.",
						Layout = 1,Default=1000,
						Min=1,Max=20000,Digits=0,
						Shortcut="Distance",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Invisible Walls",
						Tooltip = "Whether or not you teleport through invisible walls",
						Layout = 2,Default=true,
						Shortcut="IgnoreInvisibleWalls",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Uncollidible Walls",
						Tooltip = "Whether or not you teleport through uncollidible walls (walls that have CanCollide=false)",
						Layout = 3,Default=true,
						Shortcut="IgnoreUncollidibleWalls",
					},
                    {
						Type = Types.Slider,
						Title = "Cam Ignore Dist",
						Tooltip = "Objects closer to your camera than this distance will be ignored",
						Layout = 1,Default=1,
						Min=0,Max=5,Digits=1,
						Shortcut="CamIgnoreDist",
					},
				}
			},
			{
				Title = "WalkSpeed",
				Tooltip = "Changes your walkspeed to the set value",
				Layout = 97,
				Shortcut = "WalkSpeed",Functs={},
				SetProperty = function(self)
					local toSet = self.RealEnabled and self.EnTbl.Speed or C.Defaults.WalkSpeed
					if C.human and math.abs(C.human.WalkSpeed - toSet) > 1e-3 then
						C.human.WalkSpeed = toSet
					end
				end,
				Activate = function(self,newValue)
					if not C.human then return else task.wait(.1) end
					local GetPartProperty, Defaults = C.GetPartProperty, C.Defaults
					C.HookMethod("__index",self.Shortcut,newValue and self.EnTbl.Hidden and function(theirScript,index,self,...)
						if (self == C.human) then
							return "Spoof", {rawget(Defaults,"WalkSpeed")}
						end
					end,{"walkspeed"})
					if newValue and self.EnTbl.Override then
						table.insert(self.Functs,C.human:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
							self:SetProperty()
						end))
					end
					self:SetProperty(true)
				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "Speed",
						Tooltip = `What value to set the speed to (Default: {C.Defaults.WalkSpeed})`,
						Layout = 0,Default=30,
						Min=0,Max=200,Digits=1,
						Shortcut="Speed",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Force Override",
						Tooltip = "Prevents speed from being updated to anything else",
						Layout = 1,Default=true,
						Shortcut="Override",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Hidden",
						Tooltip = `Prevents other scripts from noticing`,
						Layout = 2,Default=true,
						Shortcut="Hidden",
						Activate = C.ReloadHack,
					},
				}
			},
			{
				Title = "JumpPower",
				Tooltip = "How high you jump",
				Layout = 98,
				Shortcut = "JumpPower",Functs={},
				SetProperty = function(self)
					local toSet = self.RealEnabled and self.EnTbl.Jump or C.Defaults.JumpPower
					if C.human and math.abs(C.human.JumpPower - toSet) > 1e-3 then
						C.human.JumpPower = toSet
					end
				end,
				Activate = function(self,newValue)
					if not C.human then return else task.wait(.1) end

					local GetPartProperty, Defaults = C.GetPartProperty, C.Defaults
					C.HookMethod("__index",self.Shortcut,newValue and self.EnTbl.Hidden and function(theirScript,index,self,...)
						if (self == C.human) then
							return "Spoof", {rawget(Defaults,"JumpPower")}
						end
					end,{"jumppower"})
					if newValue and self.EnTbl.Override then
						table.insert(self.Functs,C.human:GetPropertyChangedSignal("JumpPower"):Connect(function()
							self:SetProperty()
						end))
					end
					self:SetProperty(true)
				end,
				Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
						Type = Types.Slider,
						Title = "JumpPower",
						Tooltip = `What value to set the jump power to (Default: {C.Defaults.JumpPower})`,
						Layout = 0,Default=C.Defaults.JumpPower*1.4,
						Min=0,Max=200,Digits=1,
						Shortcut="Jump",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Force Override",
						Tooltip = "Prevents jump from being updated to anything else",
						Layout = 1,Default=true,
						Shortcut="Override",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Hidden",
						Tooltip = `Prevents other scripts from noticing`,
						Layout = 2,Default=true,
						Shortcut="Hidden",
						Activate = C.ReloadHack,
					},
				}
			},
			{
				Title = "Gravity",
				Tooltip = "What to set the gravity to",
				Layout = 99,
				Shortcut = "Gravity",Functs={},
				SetProperty = function(self)
					workspace.Gravity = self.RealEnabled and self.EnTbl.Gravity or C.Defaults.Gravity
				end,
				Activate = function(self,newValue)
					if self.EnTbl.Override then
						table.insert(self.Functs,workspace:GetPropertyChangedSignal("Gravity"):Connect(function()
							self:SetProperty()
						end))
					end
					self:SetProperty(true)
				end,
				Events = {},
				Options = {
					{
						Type = Types.Slider,
						Title = "Gravity",
						Tooltip = `What value to set the gravity to (Default: {C.Defaults.Gravity})`,
						Layout = 0,Default=100,
						Min=0,Max=200,Digits=1,
						Shortcut="Gravity",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Toggle,
						Title = "Force Override",
						Tooltip = "Prevents gravity from being updated to anything else",
						Layout = 1,Default=true,
						Shortcut="Override",
						Activate = C.ReloadHack,
					},
				}
			},
		}
	}
end
]],
    ["Hacks/Commands"] = [=[local ChangeHistoryService = game:GetService("ChangeHistoryService")
local GuiService = game:GetService("GuiService")
local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local PS = game:GetService("Players")
local TeleportS = game:GetService("TeleportService")
local CS = game:GetService("CollectionService")
local DS = game:GetService("Debris")
local CP = game:GetService("ContentProvider")
local SG = game:GetService("StarterGui")
local HS = game:GetService("HttpService")
local AS = game:GetService("AssetService")

local MaxRelativeDist = 50
local MaxFlingSpeed = 1e6

return function(C,Settings)
    local Serializer = C.LoadModule("Modules/Serializer")
    C.getgenv().serializedDesc = C.getgenv().serializedDesc or {}
    C.getgenv().currentDesc = C.getgenv().currentDesc or {}
    C.getgenv().Outfits = C.getgenv().Outfits or {}
    C.CommandFunctions = {
        ["refresh"]={
            Parameters={},
            AfterTxt="%s",
            Priority=10,
            RequiresRefresh=true,
            Run=function(args)
                C.Refresh()
                return true
            end,
        },
        --[[["reset_settings"]={
            Parameters=false,
            AfterTxt="%s",
            RequiresRefresh=true,
            Run=function(args)
                C.AvailableHacks.Basic[99].ActivateFunction(true, true)
                return true,"Successful"
            end,
        },--]]
        ["freecam"]={
            Parameters={},
            AfterTxt="%s",
            RequiresRefresh=true,
            Run=function(args)
                C.hackData.World.Freecam:SetValue(not C.hackData.World.Freecam.RealEnabled)
                return true
            end,
        },
        ["spectate"]={
            Parameters={{Type="Player"}},
            AfterTxt=" %s",
            RequiresRefresh=true,
            Functs = {},
            RunOnDestroy = function(self)
                C.ClearFunctTbl(self.Functs)
                C.Spectate()
            end,
            TheirCharAdded = function(self, theirPlr, theirChar)
                local theirHuman = theirChar:WaitForChild("Humanoid",15)
                if theirHuman then
                    C.Spectate(theirChar)
                end
            end,
            Run=function(self,args)
                self:RunOnDestroy()

                local theirPlr = args[1][1]
                table.insert(self.Functs, theirPlr.CharacterAdded:Connect(function(newChar)
                    self:TheirCharAdded(theirPlr, newChar)
                end))
                table.insert(self.Functs, theirPlr.AncestryChanged:Connect(function()
                    C.CreateSysMessage(`Stopped spectating because {C.GetPlayerName(theirPlr)} left`, Color3.fromRGB(0,255,255))
                    self:Run({{C.plr}})
                end))
                if theirPlr.Character then
                    self:TheirCharAdded(theirPlr, theirPlr.Character)
                end
                return true,"Successful"
            end,
        },
        ["morph"]={
            Parameters={{Type="Players",SupportsNew = true, AllowFriends = true},{Type="Friend"}},
            AfterTxt=" to %s%s",Priority=-3,
            RestoreInstances={["Hammer"]=true,["Gemstone"]=true,["PackedGemstone"]=true,["PackedHammer"]=true},
            GetHumanoidDesc=function(self,userID,outfitId)
                local success, desc
                while not success do
                    success,desc = pcall(PS[outfitId and "GetHumanoidDescriptionFromOutfitId" or "GetHumanoidDescriptionFromUserId"], PS,outfitId or userID)
                    if not success then
                        task.wait(.3)
                    end
                end
                desc.Name = userID .. (outfitId and ("/"..outfitId) or "")
                return  desc
            end,
            DoAnimationEffect = nil,--"Fade",
            AnimationEffectFunctions={
                Fade = {
                    Tween = function(self,targetChar,loopList,visible,instant)
                        local newTransparency = visible and 0 or 1
                        local property = "Transparency"--targetChar == plr.Character and "LocalTransparencyModifier" or "Transparency"
                        for num, part in ipairs(loopList) do
                            if (part:IsA("BasePart") or part:IsA("Decal")) and
                                ((not visible and part.Transparency<1) or (part:GetAttribute("PreviousTransparency"))) then
                                local PreviousTransparency = part:GetAttribute('PreviousTransparency') or part.Transparency
                                part:SetAttribute("PreviousTransparency",PreviousTransparency)
                                if instant then
                                    part[property] = visible and PreviousTransparency or newTransparency
                                else
                                    TS:Create(part,TweenInfo.new(1),{[property] = visible and PreviousTransparency or newTransparency}):Play();
                                end
                            end
                        end
                    end,
                    Start = function(self,targetChar)
                        self:Tween(targetChar,targetChar:GetDescendants(),false,false)
                        task.wait(2)
                    end,
                    Update = function(self,targetChar,part)
                       self:Tween(targetChar,{part},false,true)
                    end,
                    End = function(self,targetChar)
                       self:Tween(targetChar,targetChar:GetDescendants(),true,false)
                    end,
                }
            },
            Headless={146574359,826042567,1287648573,1091344783,1001407414,1568359906},--"courteney_820","z_baeby","kitcat4681","bxnny_senpxii","queen","army"},
            MorphPlayer=function(self,targetChar, humanDesc, dontUpdate, dontAddCap, isDefault)
                local AnimationEffectData = not dontAddCap and C.CommandFunctions.morph.AnimationEffectFunctions[C.CommandFunctions.morph.DoAnimationEffect]

                local targetHuman = targetChar:FindFirstChild("Humanoid")
                local oldHumanDesc = targetHuman:FindFirstChild("HumanoidDescription")
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                if not targetHuman or targetHuman.Health <=0 or not targetHRP or not oldHumanDesc then
                    return
                end
                if AnimationEffectData then
                    AnimationEffectData:Start(targetChar)
                end
                for _, prop in ipairs({"HeadScale","BodyTypeScale","DepthScale","HeightScale","ProportionScale","WidthScale"}) do
                    humanDesc[prop] = oldHumanDesc[prop]
                end
                --local wasAnchored = targetHRP.Anchored
                --humanDesc.Name = "CharacterDesc"
                if not dontUpdate then
                    local currentDesc = C.getgenv().currentDesc[targetChar.Name]
                    if currentDesc and humanDesc~=currentDesc then
                        currentDesc:Destroy()
                    end
                    if not isDefault then
                        C.getgenv().currentDesc[targetChar.Name] = humanDesc
                        local serializedResult = Serializer.serialize(humanDesc)
                        if serializedResult ~= C.getgenv().serializedDesc.new then
                            C.getgenv().serializedDesc[targetChar.Name] = Serializer.serialize(humanDesc)
                        else
                            C.getgenv().serializedDesc[targetChar.Name] = nil
                        end
                    else
                        C.getgenv().currentDesc[targetChar.Name] = nil
                        C.getgenv().serializedDesc[targetChar.Name] = nil
                    end
                    self.Enabled = C.GetDictLength(C.getgenv().currentDesc) > 0
                end
                local isR6 = targetHuman.RigType == Enum.HumanoidRigType.R6

                local oldHuman = targetHuman
                local newHuman = oldHuman:Clone()--(isR6 and false) and Instance.new("Humanoid") or oldHuman:Clone()----oldHuman:Clone()


                local newHuman_Animator = newHuman:FindFirstChild("Animator")
                if newHuman_Animator then
                    newHuman_Animator:Destroy() -- Prevents LoadAnimation error spams
                end
                local oldChar_ForceField = targetChar:FindFirstChild("ForceField",true)

                newHuman.Name = "FakeHuman"
                newHuman.Parent = targetChar
                C.AddGlobalInstance(newHuman)
                local Instances2Restore = {}
                for num, accessory in ipairs(targetChar:GetDescendants()) do
                    if C.CommandFunctions.morph.RestoreInstances[accessory.Name] then
                        accessory.Parent = workspace
                        C.AddGlobalInstance(accessory)
                        table.insert(Instances2Restore,accessory)
                    elseif accessory:IsA("Accessory") or accessory:IsA("Pants") or accessory:IsA("Shirt") or accessory:IsA("ShirtGraphic") then
                        accessory:Destroy()
                    end
                end
                for num, instanceName in ipairs({"Shirt","Pants"}) do
                    local instance = targetChar:FindFirstChild(instanceName)
                    if instance then
                        if instanceName=="Shirt" then
                            instance.ShirtTemplate = humanDesc.Shirt
                        elseif instanceName=="Pants" then
                            instance.PantsTemplate = humanDesc.Pants
                        end
                    end
                end
                if not dontAddCap and C.gameName == "FleeMain" then
                    for num, capsule in ipairs(CS:GetTagged("Capsule")) do
                        C.CommandFunctions.morph.CapsuleAdded(capsule,true)
                    end
                end
                if not isDefault and humanDesc.Head ~= 86498048 and table.find(self.Headless, tonumber(humanDesc.Name:split("/")[1])) then
                    humanDesc.Head = 15093053680
                end
                local AnimationUpdateConnection
                if AnimationEffectData and AnimationEffectData.Update then
                    AnimationUpdateConnection = targetChar.DescendantAdded:Connect(function(part)
                        if part:IsA("BasePart") then
                            AnimationEffectData:Update(targetChar,part)
                        end
                    end)
                end
                while not pcall(newHuman.ApplyDescriptionReset,newHuman,humanDesc) do
                    task.wait(1)
                end
                if workspace.CurrentCamera.CameraSubject == newHuman then
                    workspace.CurrentCamera.CameraSubject = oldHuman
                end
                if oldChar_ForceField and oldChar_ForceField.Parent then
                    oldChar_ForceField.Parent = targetChar:FindFirstChild("HumanoidRootPart")
                end
                for num, instance in ipairs(Instances2Restore) do
                    if instance.Parent then
                        instance.Parent = targetChar
                        C.RemoveGlobalInstance(instance)
                    end
                end
                newHuman.Parent = nil
                DS:AddItem(newHuman,3)
                if AnimationEffectData then
                    AnimationEffectData:End(targetChar)
                end
                if AnimationUpdateConnection then
                    AnimationUpdateConnection:Disconnect()
                end
            end,
            Functs={},
            RunOnDestroy = function(self)
                C.ClearFunctTbl(self.Functs)
            end,
            --[[CapsuleAdded=function(self,capsule,noAddFunct)
                local function childAdded(child)
                    if child:IsA("Model") and child:WaitForChild("Humanoid",5) then
                        local humanDesc = C.getgenv().currentDesc[child.Name]
                        if humanDesc then
                            task.wait(.3)
                            local orgColor = child:WaitForChild("Head").Color
                            local myClone = humanDesc:Clone()
                            for num, prop in ipairs({"LeftArmColor","RightArmColor","LeftLegColor","RightLegColor","TorsoColor","HeadColor"}) do
                                myClone[prop] = orgColor
                            end
                            C.CommandFunctions.morph:MorphPlayer(child,myClone,true,true)
                            DS:AddItem(myClone,15)
                        end
                    end
                end

                if not noAddFunct then
                    table.insert(C.CommandFunctions.morph.Functs,capsule.ChildAdded:Connect(childAdded))
                end
                if not capsule:FindFirstChild("PodTrigger") then
                    for num, child in ipairs(capsule:GetChildren()) do
                        task.spawn(childAdded,child)
                    end
                end
            end,--]]
            Events = {
                CharAdded=function(self,theirPlr,theirChar,firstRun)
                    local theirHuman = theirChar:WaitForChild("Humanoid")
                    local PrimPart = theirHuman and theirChar:WaitForChild("HumanoidRootPart", 15)
                    if not theirHuman or not PrimPart then
                        print("TheirHuman Or PrimPart Not Found")
                        return
                    end
                    CP:PreloadAsync({theirChar})
                    if firstRun then
                        task.wait(.83) --Avatar loaded wait!
                    else
                        task.wait(.63) --Avatar loaded wait!
                    end
                    if not theirChar.Parent then
                        return
                    end
                    local currentChar = C.getgenv().currentDesc[theirPlr.Name]
                    if C.hackData.NavalWarefare then
                        task.wait(3)
                    end
                    if firstRun and not currentChar then
                        local JoinPlayerMorphDesc = C.getgenv().JoinPlayerMorphDesc
                        --print(theirChar,"first run")
                        if JoinPlayerMorphDesc then
                            JoinPlayerMorphDesc = JoinPlayerMorphDesc:Clone()
                            C.getgenv().currentDesc[theirPlr.Name] = JoinPlayerMorphDesc
                            --C.getgenv().serializedDesc[theirPlr.Name] = Serializer.serialize(JoinPlayerMorphDesc)
                            --print(theirChar,"first run set to",JoinPlayerMorphDesc)
                            self:MorphPlayer(theirChar,JoinPlayerMorphDesc,false,true)
                        end
                    elseif currentChar then
                        self:MorphPlayer(theirChar,currentChar,true,not firstRun)
                    end
                end,
                --CapturedRemoved = function(self, theirPlr, theirChar)
                --    task.wait(1)
                --    local foundChar
                --    for _, freezePod in ipairs(C.FreezingPods) do
                --        local theChar = freezePod:FindFirstChild(theirPlr.Name, true)
                --        if theChar then
                --            foundChar = theChar
                --            break
                --        end
                --    end
                --    if foundChar then
                --        print("Found Freeze",foundChar)
                --        local BodyColors = foundChar:FindFirstChildWhichIsA("BodyColors")
                --        self.Events.CharAdded(self, theirPlr, foundChar, true)
                --    end
                --end,
                NewFreezingPod = function(self, capsule)
                    local function childAdded(child)
                        if child:IsA("Model") and child:WaitForChild("Humanoid",5) then
                            local humanDesc = C.getgenv().currentDesc[child.Name]
                            if humanDesc then
                                --CP:PreloadAsync({child})
                                local orgColor = child:WaitForChild("Head").Color
                                local myClone = humanDesc:Clone()
                                for num, prop in ipairs({"LeftArmColor","RightArmColor","LeftLegColor","RightLegColor","TorsoColor","HeadColor"}) do
                                    myClone[prop] = orgColor
                                end
                                self:MorphPlayer(child,myClone,true,true)
                                DS:AddItem(myClone,15)
                            end
                        end
                    end

                    table.insert(self.Functs,capsule.ChildAdded:Connect(childAdded))
                    if not capsule:WaitForChild("PodTrigger",.5) then
                        for num, child in ipairs(capsule:GetChildren()) do
                            task.spawn(childAdded,child)
                        end
                    end
                end,
            },
            RealEnabled = C.getgenv().MorphEnabled,
            Run=function(self,args)
                self.RealEnabled = true
                C.getgenv().MorphEnabled = true
                local selectedName = (args[2] == "" and "no") or args[2]--C.checkFriendsPCALLFunction(args[2])[1]
                selectedName = selectedName ~= "no" and selectedName[2] or selectedName
                if not selectedName then
                    return false,`User Not Found: {args[2]}`--C.CreateSysMessage(`User Not Found: {args[2]}`)
                end
                local outfitData
                if args[3] and args[3] ~= "" then
                    if not C.getgenv().Outfits[selectedName.UserId] then
                        local wasSuccess,err = C.CommandFunctions.outfits:Run({selectedName})
                        if not wasSuccess then
                            return false, "Outfit Getter Err " .. tostring(err)
                        end
                    end
                    if not C.getgenv().Outfits[selectedName.UserId] then
                        return false, `Outfit not found for user {selectedName.UserName}, {selectedName.UserId}`
                    end
                    if tonumber(args[3]) then
                        args[3] = tonumber(args[3])
                    else
                        local list = C.StringStartsWith(C.getgenv().Outfits[selectedName.UserId], args[3])
                        if #list == 0 then
                            return false, "Outfit Name Not Found ("..tostring(args[3])..")"
                        end
                        args[3] = list[1][1];
                    end
                    outfitData = C.getgenv().Outfits[selectedName.UserId][args[3]]
                else
                    args[3] = nil
                end
                local defaultHumanDesc = selectedName~="no" and
                    (args[3] and PS:GetHumanoidDescriptionFromOutfitId(outfitData.id) or PS:GetHumanoidDescriptionFromUserId(selectedName.UserId))
                if defaultHumanDesc == nil then
                    return false, "HumanoidDesc returned NULL for all players!"
                end
                local savedDescription = selectedName~="no"
                    and C.CommandFunctions.morph:GetHumanoidDesc(selectedName.UserId,args[3] and outfitData.id)
                --((args[3] and PS:GetHumanoidDescriptionFromOutfitId(outfitData.id)) or PS:GetHumanoidDescriptionFromUserId(selectedName.UserId))
                if args[1]=="new" or #args[1] > 1 then
                    if C.getgenv().JoinPlayerMorphDesc and C.getgenv().JoinPlayerMorphDesc ~= savedDescription then
                        C.getgenv().JoinPlayerMorphDesc:Destroy()
                    end
                    if selectedName=="no" then
                        C.getgenv().JoinPlayerMorphDesc = nil
                        C.getgenv().serializedDesc.new = nil
                    else
                        C.getgenv().JoinPlayerMorphDesc = savedDescription
                        C.getgenv().serializedDesc.new = Serializer.serialize(C.getgenv().JoinPlayerMorphDesc)
                    end
                end
                if args[1]~="new" then
                    for num, theirPlr in ipairs(args[1]) do
                        if args[3] and not outfitData then
                            return false, `Outfit {args[3]} not found for player {theirPlr.Name}`
                        end
                        local desc2Apply = (selectedName =="no" and PS:GetHumanoidDescriptionFromUserId(theirPlr.UserId))
                            or self:GetHumanoidDesc(selectedName.UserId,args[3] and outfitData.id)
                        if not desc2Apply then
                            return false, `HumanoidDesc returned NULL for {theirPlr.Name}`
                        end
                        if theirPlr.Character then
                            task.spawn(C.CommandFunctions.morph.MorphPlayer,C.CommandFunctions.morph,theirPlr.Character,desc2Apply,false,false,selectedName == "no")
                        elseif selectedName ~= "no" then
                            if C.getgenv().currentDesc[theirPlr.Name]
                                and C.getgenv().currentDesc[theirPlr.Name] ~= desc2Apply then
                                C.getgenv().currentDesc[theirPlr.Name]:Destroy()
                            end
                            C.getgenv().currentDesc[theirPlr.Name] = desc2Apply
                        else
                            if C.getgenv().currentDesc[theirPlr.Name] then
                                C.getgenv().currentDesc[theirPlr.Name]:Destroy()
                            end
                            C.getgenv().currentDesc[theirPlr.Name] = nil
                        end
                        --(selectedName=="no" and theirPlr.UserId or PS:GetUserIdFromNameAsync(selectedName)))
                    end
                end
                return true,args[2]=="" and "nothing" or selectedName.UserName,outfitData and (" " ..outfitData.name) or ""
            end
        },
        ["unmorph"]={
            Parameters={{Type="Players"}},
            AfterTxt="",
            SupportsNew=true,
            Run=function(self,args)
                C.CommandFunctions.morph:Run({args[1],""})
                return true
            end,
        },
        ["outfits"]={
            Parameters={{Type="Friend"}},
            AfterTxt="%s",
            Run=function(self,args)
                local selectedName = args[1]--local index, selectedName = table.unpack(C.checkFriendsPCALLFunction(args[1])[1] or {})
                C.getgenv().Outfits = C.getgenv().Outfits or {}
                if not selectedName then
                    return false, "User Not Found ("..tostring(args[1])..")"
                end
                local results,bodyResult = "",C.getgenv().Outfits[selectedName.UserId]
                if not C.getgenv().Outfits[selectedName.UserId] then
                    local success,result = pcall(C.request,{Url="https://avatar.roblox.com/v1/users/"..selectedName.UserId.."/outfits",Method="GET",
                        Cookies={[".ROBLOSECURITY"]="CC5437678DF919BEDBCF4E13015BFB5AB984AC1772F3159199BBC3B154AEB901513BDF667123CF732E6119F5433EB7C74F3FD957AFBD778B0E7315205A9A05AA1FDD7BAEE276728F0016FBCC8EF5ECA807E14FD676CBE001C63A142E8B7958F438634ACCAFA8FC5C85A0881E6BD0105996C11DE5BE7CBC1A7D905E7B9622A228030373B31746E0FB4E052E297A7D3F12AAF4D6E649FE1AADD71B576085BE01AD83692B2AB3557D0E29CA12E2DA6B11338C157BC9F224D689699DA4CEBCDBC087933B7DF32A4CE0FC1A818499F7CCFE2001720871A0D655B86A1FA9D71FC918261EA0B031A80529998253D2DE8773F9120190C5102674D6D994AD59C1856606C32B3DFEEC8FA6145E178997F772BBB68A37D65C99CB651B76FA53A6A3ED2D277B8C0B8128324A81122A70D8EBCF4E36FD0665D1959C8DA858E6764E6223F0C19D2DD9B51EF6FAAF352BF31AFE05CDDE26DA801B74CD583138ACF997DBFA057B7C86549C31F256F9A2AE31AE829A5AD5111F424F80A5ABE312C060114AD79724E4F5D320805DEF02DC80FE59F1AE779AE1816C69EF046B884D284A17FC5C5349DA4A2DD1CAB8DA59180C28E27A375EF079B40643199BBD48C7D985F56536165D02300773C2097B5A90DB3B22D0D45FBC4B4B413C4044CD909509F51C1C39E4DB29F02F7F56A0828504AA64CDAD8C2ABE3ABF21B0C1472B9D3A8E5280217C63C00E4499665A7D140DCB8B955A7C1A163B9C6CFEB7FBC000246687D9F5EABA387D75067CD86694AC14EE49409DFEC381E26AF560031E589E33E8AAC74CCAA24634C7C306F2B579339AD4B0368F7ACA8B546A0594C8DEEDB2E008F79CBE0FC33A69ADF270AAF19EFFB14B816DB9045BE1B729040DAD4EBC115426E03807BFAD9BB3ECCAD275F7A796D8CE8259B80DF6C96CE8C9EA08EDFDF230224172860D5F454D9251728800FE119899D3AAC3BFC24B37BEFA86277259DBC3A8496F33AC770592FA1976C278B9D0A663BE56C248082109B0A3A5809EDBA34AC90E4D02FDA340B97197D596F9D8FF557979F76229975738E40B69DCAFDB66C5AFD195F9379C5858C09F9D309E"}})
                    if not success then
                        return false, "Http Error "..result
                    elseif not result.Success then
                        return false, "Http Error2 "..result.StatusMessage
                    else
                        bodyResult = HS:JSONDecode(result.Body).data;
                        for num = #bodyResult,1,-1 do--for num, val in ipairs(bodyResult) do
                            local val = bodyResult[num];
                            if val.isEditable then
                                val.SortName = val.name
                            else
                                table.remove(bodyResult,num)
                            end
                        end
                        C.getgenv().Outfits[selectedName.UserId] = bodyResult;
                    end
                end
                for num, val in ipairs(bodyResult) do
                    results..="\n"..num.."/"..val.name
                end
                return true, results
            end,
        },
        ["teleport"]={
            Parameters={{Type="Player",ExcludeMe=true}},
            AfterTxt="",
            Run=function(self,args)
                local theirPlr = args[1][1]
                local theirChar = theirPlr.Character
                if not theirChar then
                    return false, `Character not found for {theirPlr.Name}`
                end
                local HRP = theirChar:FindFirstChild("HumanoidRootPart")
                if not HRP then
                    return false, `HRP not found for {theirPlr.Name}`
                end
                C.CommandFunctions.unfollow:Run()
                C.DoTeleport(HRP.CFrame * CFrame.new(0,0,3))
                return true,nil--theirPlr.Name
            end,
        },
        ["time"]={
            Parameters={},
            AfterTxt="Connected for %i m, %.1f s (%is total)",
            Run=function(self,args)
                return true,math.floor(time()/60), time()%60, time()
            end,
        },
        ["follow"]={
            Parameters={{Type="Player"},{Type="Number",Min=-MaxRelativeDist,Max=MaxRelativeDist,Default=5}, {Type="Number",Min=-MaxRelativeDist,Max=MaxRelativeDist,Default=0}},
            AfterTxt="",
            Priority=-3,
            isFollowing=-1,
            ForcePlayAnimations={},
            MyPlayingAnimations={},
            Run=function(self,args)
                local theirPlr = args[1][1]
                local theirChar = theirPlr.Character
                if not theirChar then
                    return false, `Character not found for {theirPlr.Name}`
                end
                local HRP = theirChar.PrimaryPart
                if not HRP then
                    return false, `HRP not found for {theirPlr.Name}`
                end
                local dist = args[2]=="" and 5 or tonumber(args[2])
                if not dist then
                    return false, `Invalid Number {args[2]}`
                end

                --C.CommandFunctions.follow.isFollowing = theirPlr.UserId
                --print("Set To",C.CommandFunctions.follow.isFollowing,theirPlr.UserId)

                local saveChar = C.char
                C.CommandFunctions.unfollow:Run()
                if not theirPlr or theirPlr == C.plr then
                    return true
                end
                C.isFollowing = theirPlr
                RunS:BindToRenderStep("Follow"..C.SaveIndex,69,function(delta: number)
                    --print(plr:GetAttribute("isFollowing") ~= theirPlr.UserId,plr:GetAttribute("isFollowing"),theirPlr.UserId)
                    --while isFollowing == theirPlr and HRP and HRP.Parent and saveChar.Parent and not C.C.isCleared do
                    --if (plr:GetAttribute("isFollowing") ~= theirPlr.UserId or not HRP or not HRP.Parent or C.C.isCleared) then
                    --	return
                    --end
                    if not theirPlr.Parent or theirPlr.Parent ~= PS then
                        C.CommandFunctions.unfollow:Run()
                        C.CreateSysMessage(`Followed User {theirPlr.Name} has left the game!`)
                        return
                    end
                    if not HRP or not HRP.Parent then
                        theirChar = theirPlr.Character
                        if theirChar and theirChar.PrimaryPart then
                            HRP = theirChar.PrimaryPart
                        end
                    end

                    local setCFrame = dist == 0 and HRP.CFrame or CFrame.new(HRP.CFrame * Vector3.new(0,0,dist),HRP.Position)

                    setCFrame += HRP.AssemblyLinearVelocity * 0.06 -- Ping

                    C.DoTeleport(setCFrame)

                    if C.char and C.char.PrimaryPart and not C.CommandFunctions.fling.FlingThread then
                        C.char.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
                        C.char.PrimaryPart.AssemblyLinearVelocity = Vector3.new()
                    end
                    --[[for num, animTrack in ipairs(saveChar.Humanoid.Animator:GetPlayingAnimationTracks()) do
                        if animTrack then
                            local myAnimTrack = C.CommandFunctions.follow.MyPlayingAnimations[animTrack]
                            if not myAnimTrack then
                                myAnimTrack = C.human.Animator:LoadAnimation(animTrack.Animation)
                                table.insert(C.CommandFunctions.follow.ForcePlayAnimations,animTrack)--C.C.human:LoadAnimation(animTrack.Animator)
                                C.CommandFunctions.follow.MyPlayingAnimations[animTrack] = myAnimTrack
                            end
                            myAnimTrack:AdjustSpeed(animTrack.Speed)
                            if animTrack.IsPlaying then
                                myAnimTrack:Play()
                            else
                                myAnimTrack:Stop()
                            end
                        end
                    end--]]



                    -- * CFrame.new(0,C.getHumanoidHeight(C.char),dist))
                    --task.wait()
                    --end
                    --if isFollowing == theirPlr then
                    --	isFollowing = false
                    --end
                end)
                --task.spawn(function()
                --end)
                return true
            end,
        },
        ["unfollow"]={
            Parameters={},
            AfterTxt="%s",
            RunOnDestroy=function(self)
                self:Run({})
            end,
            Run=function(self,args)
                if not C.isFollowing then
                    return false, "Not Following Any User ("..tostring(C.isFollowing)..")"
                end
                local theirPlr = C.isFollowing
                local str = `{theirPlr or 'Unknown'}`
                C.isFollowing = nil
                --C.CommandFunctions.follow.isFollowing = -1
                RunS:UnbindFromRenderStep("Follow"..C.SaveIndex)
                for num, myAnimTrack in pairs(C.CommandFunctions.follow.MyPlayingAnimations) do
                    myAnimTrack:Stop(0)
                end
                C.CommandFunctions.follow.MyPlayingAnimations = {}
                C.CommandFunctions.follow.ForcePlayAnimations = {}
                return true,str
            end,
        },
        ["rejoin"]={
            Parameters={{Type="Options",Default="same",Options={"same","new","small","any"}}},
            AfterTxt="%s", Connection = nil,
            Run=function(self,args,promptOverride)
                --local RootPlaceInfo = AS:GetGamePlacesAsync():GetCurrentPage()[1]
                --local RootPlaceId = RootPlaceInfo.PlaceId
                --if game.PlaceId ~= RootPlaceId then
                    --if not promptOverride and not C.Prompt("Join Root PlaceID?","Are you sure that you want to rejoin? This will take you to the Root Place: "..RootPlaceInfo.Name,"Y/N") then
                    --    return true, "Cancelled"
                    --end
                    --RootPlaceId = game.PlaceId
                    --if args[1] == "same" then
                        --args[1] = "any"
                    --end
                --end
                local RootPlaceId = game.PlaceId
                if args[1] == "new" or args[1] == "small" then
                    local result, servers = pcall(game.HttpGet,game,`https://games.roblox.com/v1/games/{RootPlaceId}/servers/0?sortOrder={
                        args[1]=="small" and 1 or 2}&excludeFullGames=true&limit=100`)
                    if not result then
                        return false, "Request Failed: "..servers
                    end
                    local result2, decoded = pcall(HS.JSONDecode,HS,servers)
                    if not result2 then
                        return false, "Request Decode Failed: "..decoded
                    end

                    local ServerJobIds = {}

                    for i, v in ipairs(decoded.data) do
                        if v.id ~= game.JobId then
                            ServerJobIds[#ServerJobIds + 1] = v.id
                        end
                    end
                    local bool = #ServerJobIds ~= 0
                    if not bool then
                        return false, "No other servers found. Try ;rejoin any"
                    end

                    local random = C.Randomizer:NextInteger(1,#ServerJobIds)
                    --TeleportS:TeleportToPlaceInstance(game.PlaceId,ServerJobIds[random],C.plr)
                    C.ServerTeleport(RootPlaceId,ServerJobIds[random])
                elseif args[1] == "any" then
                    C.ServerTeleport(RootPlaceId,nil) -- Leave blank to indicate that you want to join any server
                elseif args[1] == "same" then
                    --TeleportS:TeleportToPlaceInstance(game.PlaceId,game.JobId,C.plr)
                    if #PS:GetPlayers() <= 1 then
                        --return false, "Requires at least 1 other player. Try ;rejoin any"
                    end
                    C.ServerTeleport(RootPlaceId,game.JobId)
                else
                    error("[Commands]: Teleport Cmd Invalid Arg[1] "..args[1])
                end
                self.Connection = TeleportS.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage, placeId, teleportOptions)
                    if player ~= C.plr then
                        return
                    end
                    print("ErrorMsg",errorMessage)
                    self:Run({"any"})
                    GuiService:ClearError()
                end)
                local MyConn = self.Connection
                task.delay(20,function()
                    if self.Connection == MyConn then
                        self.Connection:Disconnect()
                        self.Connection = nil
                    end
                end)
                return true, args[1]:sub(1,1):upper() .. args[1]:sub(2) .. " Server"
            end,
        },
        ["console"]={
            Parameters={},
            AfterTxt="%s",
            Run=function(self,args)
                SG:SetCore("DevConsoleVisible",not SG:GetCore("DevConsoleVisible"))
                return true
            end,
        },
        ["unfling"]={
            Parameters={},
            AfterTxt="%s",
            --RunOnDestroy=function(self)
            --    self:Run({})
           -- end,
            ResetVel = function(self)
                if C.char then
                    for num, part in ipairs(C.char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            C.hrp.AssemblyLinearVelocity = Vector3.zero
                            C.hrp.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end
            end,
            Run=function(self,args,notpback,nodeletethread)
                if self.Parent.fling.FlingThread then
                    if not nodeletethread then -- if its not our current thread
                        C.StopThread(self.Parent.fling.FlingThread)
                    end
                    self.Parent.fling.FlingThread = nil
                end
                self.Parent.fling:SetFling(false)
                self.Parent.unfollow:Run()
                if C.hrp then
                    C.hrp.AssemblyLinearVelocity, C.hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
                end
                self:ResetVel()
                if notpback and not self.OldLoc and C.hrp then
                    self.OldLoc = C.hrp:GetPivot()
                elseif not notpback and self.OldLoc and C.char then
                    C.human:ChangeState(Enum.HumanoidStateType.Landed)
                    task.spawn(C.char.PivotTo, C.char, self.OldLoc)
                    self.OldLoc = nil
                end
                return true
            end,
        },
        ["servers"]={
            Parameters={},
            AfterTxt="%s",
            Run=function(self,args)
                C.ToggleServersVisiblity()
                return true, ""
            end,
        },
        ["places"]={
            Parameters={},
            AfterTxt="%s",
            Run=function(self,args)
                C.ToggleServersVisiblity("Place")
                return true, ""
            end,
        },
        ["friends"]={
            Parameters={},
            AfterTxt="%s",
            Run=function(self,args)
                C.ToggleServersVisiblity("Friend")
                return true, ""
            end,
        },
        ["fling"]={
            Parameters={{Type="Players"},{Type="Number",Min=-MaxFlingSpeed,Max=MaxFlingSpeed,Default=5}},
            AfterTxt="%s",
            FlingThread=nil,
            OldLoc=nil,
            ActionFrame=nil,
            SetFling=function(self,enabled,speed,doLoopFling)
                if enabled then
                    C.SetPartProperty(workspace,"FallenPartsDestroyHeight", "fling",-1e4)
                else
                    C.ResetPartProperty(workspace,"FallenPartsDestroyHeight","fling")
                end
                RunS:UnbindFromRenderStep("Spin"..C.SaveIndex)
                if enabled then
                    C.AddOverride(C.hackData.Blatant.Noclip, "fling")
                    RunS:BindToRenderStep("Spin"..C.SaveIndex,69,function()
                        if C.hrp and self.Enabled then
                            C.hrp.AssemblyAngularVelocity = Vector3.new(1,0,1) * (speed or 1)*1e4
                            C.hrp.AssemblyLinearVelocity = Vector3.zero
                        end
                    end)
                    self.ActionFrame = C.AddAction({Name="fling",Title=`{doLoopFling and "Loop " or ""}Flinging..`,Tags={"RemoveOnDestroy"},
                    Time=function(ActionClone,info)
                        ActionClone.Time.Text = "Loading.."
                    end,Stop=function(onRequest)
                        self.Parent.unfling:Run()
                    end,}) or self.ActionFrame
                else
                    C.RemoveOverride(C.hackData.Blatant.Noclip, "fling")
                    C.RemoveAction("fling")
                    C.Spectate(C.plr.Character)
                end
                self.Enabled = enabled -- Toggle Events
                self.Events.MyCharAdded(self,C.plr,nil,nil)
            end,
            Run=function(self,args,doLoopFling)
                C.TblRemove(args[1],C.plr) -- don't fling yourself!
                if #args[1] == 0 then
                    self.Parent.unfling:Run() -- teleport back too!
                else
                    self.Parent.unfling:Run(nil,true,false)
                end
                if #args[1] == 0 then
                    return true, "Stopped"-- do nothing if there's nothing to fling or just yourself!
                end
                local wasSeated = C.human:GetState() == Enum.HumanoidStateType.Seated
                self.FlingThread = task.spawn(function()
                    local FallenDestroyHeight = C.GetPartProperty(workspace,"FallenPartsDestroyHeight")
                    repeat
                        for num, thisPlr in ipairs(args[1]) do
                            self:SetFling(true,args[2],doLoopFling)
                            local LastSpeedTime
                            for i = 0,30,1 do
                                local theirChar = thisPlr.Character
                                local theirHuman = theirChar and theirChar:FindFirstChild("Humanoid")
                                local theirPrim = theirChar and theirChar.PrimaryPart
                                if C.hrp and theirPrim and not PhysicsService:CollisionGroupsAreCollidable(C.hrp.CollisionGroup,theirPrim.CollisionGroup) then
                                    C.CreateSysMessage(`Fling cannot work because you do not collide with {thisPlr.Name}!`)
                                    task.spawn(self.Parent.unfling.Run,self.Parent.unfling)
                                    return
                                end
                                if self.ActionFrame:FindFirstChild("Time") then
                                    self.ActionFrame.Time.Text = `{thisPlr.Name} ({i}/30)`
                                end
                                C.Spectate(theirChar)
                                local exit = false
                                local timeLeft = 0
                                repeat
                                    if thisPlr.Parent ~= PS or not theirChar or not theirHuman or theirHuman:GetState() == Enum.HumanoidStateType.Dead or theirHuman.Health <= 0 or not theirPrim then
                                        exit = true
                                        break
                                    end
                                    if (theirPrim.AssemblyAngularVelocity).Magnitude > 50 then
                                        if not LastSpeedTime then
                                            LastSpeedTime = os.clock()
                                        elseif (os.clock() - LastSpeedTime > 1) then
                                            exit = true
                                            break -- We did enough damage!
                                        end
                                    else
                                        LastSpeedTime = nil
                                    end

                                    if C.hrp then
                                        local SeatPart = theirHuman.SeatPart
                                        local Target
                                        if not SeatPart or not SeatPart.Parent then
                                            Target = thisPlr.Character:GetPivot()
                                            Target += theirPrim.AssemblyLinearVelocity * .06
                                        else
                                            Target = SeatPart.Parent:GetPivot()
                                        end

                                        if Target.Y < FallenDestroyHeight + 12 then
                                            Target += Vector3.new(0, FallenDestroyHeight - Target.Y + 12,0)
                                        end
                                        C.DoTeleport(Target)
                                    end
                                    timeLeft += task.wait(1/6)
                                until timeLeft >= 0.15

                                if exit then
                                    break
                                end
                            end

                            if not wasSeated and C.human:GetState() == Enum.HumanoidStateType.Seated then --check if seated
                                C.human:ChangeState(Enum.HumanoidStateType.Running) --get out if you are
                            end
                        end
                        if doLoopFling then
                            task.wait(.15)
                        end
                    until not doLoopFling
                    self.Parent.unfling:Run(nil,false,true)
                end)
                return true
            end,
            Events={MyCharAdded=function(self,theirPlr,theirChar,firstRun)
                C.SetHumanoidTouch(self.Enabled,"fling")
            end}
        },
        ["lfling"]={
            Parameters={{Type="Players"},{Type="Number",Min=-MaxFlingSpeed,Max=MaxFlingSpeed,Default=5}},
            AfterTxt="%s",
            Run = function(self,args)
                return self.Parent.fling:Run(args,true)
            end
        },
        --["nick"]={
        --    Parameters={{Type="Players"},{Type="String",Min=1, Max = 20,Optional = true}},
        --    Run = function(self, args)
        --        local nickName = args[2]
        --        if nickName == "" then
        --            for num, theirPlr in ipairs(args[1]) do
        --                self.PlayerInstances[theirPlr] = nil
        --            end
        --        else
        --            for num, theirPlr in ipairs(args[1]) do
        --                self.PlayerInstances[theirPlr] = self.PlayerInstances[theirPlr] or {}
        --            end
        --        end
        --        C.ClearFunctTbl(self.Functs)
        --        local function NewInsert(newChild)
        --            if (newChild:IsA("TextLabel") and newChild.Text == )
        --        end
        --        table.insert(self.Functs, game.DescendantAdded:Connect())
        --    end,
        --    PlayerInstances = {},
        --    PlayerConnections = {},
        --    Functs = {},
        --},
    }
end]=],
    ["Hacks/Developer"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local RunService = game:GetService("RunService")
local SocialService = game:GetService("SocialService")
local SG = game:GetService("StarterGui")
local CG = game:GetService("CoreGui")
local RS = game:GetService("ReplicatedStorage")
local PhysicsS = game:GetService"PhysicsService"
local LS = game:GetService("LogService")
local UIS = game:GetService("UserInputService")
local AS = game:GetService("AssetService")

return function(C,Settings)
    return {
		Category = {
			Name = "Developer",
			Title = "Developer",
			Image = 11860859170,
			Layout = 8,
            AfterMisc = true,
		},
		Tab = {
            {
				Title = "Clear Logs",
				Tooltip = "Clears the console's logs",
				Layout = 0,Type="NoToggle",
				Shortcut = "ClearLogs",
				Activate = function(self,newValue)
                    C.getgenv().LogCutoffTimeStamp = #LS:GetLogHistory()
                    local ScrollList = C.StringWait(CG,"DevConsoleMaster.DevConsoleWindow.DevConsoleUI.MainView.ClientLog", math.huge)
                    if ScrollList then
                        C.ClearChildren(ScrollList, C.getgenv().LogCutoffTimeStamp)
                    end
                    
                    --C.getgenv().LogCutoffTimeStamp = os.time() + 1
                    --local tblInsert = table.insert
                    --local tskSpawn = task.spawn
					--local Old
                    --Old = C.HookMethod("__namecall",self.Shortcut, function(newSc,method,self)
                    --    tskSpawn(print, "yooo")
                    --    if (self == LS) then
                    --        local LatestTimeStamp = rawget(rawget(C, "getgenv"), "LogCutoffTimeStamp")
                    --        local Results = Old(self)
                    --        local Returns = {}
                    --        for num, item in ipairs(Results) do
                    --            if (rawget(item, 'timestamp') > LatestTimeStamp) then
                    --                tblInsert(Returns, item)
                    --            end
                    --        end
                    --        return "Override", {Returns}
                    --    end
                    --end,{"getloghistory","getlogHistory"})
				end,
				Options = {

				}
			},
			{
				Title = "OpenConsole",
				Tooltip = "Opens Developers Console",
				Layout = 1,Type="NoToggle",Keybind=Enum.KeyCode.F1.Name,
				Shortcut = "DevelopersConsole",
                Threads = {},
                ForceScrollToBottom = function(self)
                    local ScrollList = C.StringWait(CG,"DevConsoleMaster.DevConsoleWindow.DevConsoleUI.MainView.ClientLog")
                    local timeLeft = 1
                    repeat
                        if not ScrollList.Parent then
                            break
                        end
                        ScrollList.CanvasPosition = Vector2.new(0, 9999999)
                        timeLeft -= RunService.RenderStepped:Wait()
                    until timeLeft <= 0
                end,
				Activate = function(self,newValue)
					SG:SetCore("DevConsoleVisible", not SG:GetCore("DevConsoleVisible"))
                    self:ForceScrollToBottom()
				end,
				Options = {

				}
			},
            {
				Title = "Collisions Groups",
				Tooltip = "Prints Collisions Groups To Console",
				Layout = 3,Type="NoToggle",
				Shortcut = "CollisionGroups",
				Activate = function(self,newValue)
                    local CollisionGroups = PhysicsS:GetRegisteredCollisionGroups()
                    for key, val in ipairs(CollisionGroups) do
                        print(val.name.." (id=" .. key ..") collides:")
                        for num, val2 in pairs(CollisionGroups) do
                            print("\t"..val2.name,PhysicsS:CollisionGroupsAreCollidable(val2.name,val.name),"\n")
                        end
                    end
				end,
				Options = {

				}
			},
            {
				Title = "Teleport Detection",
				Tooltip = "Prints whenever any parts of your character are teleported!",
				Layout = 4,
				Shortcut = "TeleportDetection",
                WhitelistedNames={"UpperTorso", "Torso", "Head", "Head", "HumanoidRootPart"} ,
				Activate = function(self,newValue)
                    if not newValue or not C.char then return end
                    for num, instance in ipairs(C.char and C.char:GetChildren() or {}) do
                        if instance:IsA("BasePart") or table.find(self.WhitelistedNames,instance.Name) then
                            table.insert(self.Functs,instance:GetPropertyChangedSignal("CFrame"):Connect(function()
                                print(instance:GetFullName():gsub(C.char:GetFullName(),"Char") .. " Teleported!")
                            end))
                        end
                    end
				end,
                Functs={},
				Events = {
                    MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				}
			},
            {
				Title = "Attribute Scan",
				Tooltip = "Searches through nearly everything in the game for hidden attributes to edit!",
				Layout = 2,Type="NoToggle",
				Shortcut = "AttributeScanner",
				Activate = function(self,newValue)
                    local ignoreParents = {[game.CoreGui]=true}
                    local ignoreList = {["OrgColor"]=true,["OrgTrans"]=true,['wallclip']=true,['HackGUI1']=true,["LastTP"]=true,
                        ["OriginalCollide"]=true,["OrgSize"]=true,["WeirdCanCollide"]=true,["Opened"]=true,["SaveVolume"]=true,['ClearedHackGUI1']=true,
						["RealFuel"]=true}
					local ignoreRegex = {"[%a%d]+_OriginalValue","[%a%d]+_Request_","[%a%d]+_RequestCount"}
                    local function printAtt(obj)
                        for _,instance in ipairs(ignoreList) do
                            if instance:IsAncestorOf(obj) then
                                return
                            end
                        end
                        local printStr
                        for attribute, val in pairs(obj:GetAttributes()) do
							local hasRegex = false
							for num, val in ipairs(ignoreRegex) do
								if attribute:gmatch(val)() then
									hasRegex = true
									break
								end
							end
                            if not ignoreList[attribute] and not hasRegex then
                                if not printStr then
                                    printStr = "\tOBJ ["..obj:GetFullName().."]:"
                                end
                                printStr..="\n\t\t"..attribute.."="..tostring(val) .. " (" .. typeof(val) .. ")"
                            end
                        end
                        if printStr then
                            print(printStr)
                        end
                    end
                    local function loop(obj,instsScanned)
                        instsScanned = (instsScanned or 0) + 1
                        printAtt(obj)
                        if ignoreParents[obj] then
                            return -- don't go through ignoreparents!
                        end
                        for num, instance in ipairs(obj:GetChildren()) do
                            instsScanned = loop(instance,instsScanned)
                            if num%40==0 then
                                game["Run Service"].RenderStepped:Wait()
                            end
                        end
                        return instsScanned
                    end
                    local start = os.clock()

                    warn("[Attribute Search] Search Beggining...")

                    local Count = C.comma_value(loop(game))

                    warn(("[Attribute Search] Search Finished! Loop through %s instances in %.2f seconds!"):format(Count,os.clock()-start))
				end,
				Options = {

				}
			},
            {
				Title = "Print Remote Event Spy",
				Tooltip = "Prints all messages from remote events to the console.",
				Layout = 2,Functs={},
				Shortcut = "PrintRemoteSpy",
                IgnoreList = {[88070565] --[[BLOXBURG]] = {"FloorPos","LookDir","GetServerTime","CheckOwnsAsset","GetIKTargets","FirstPlayerExperience_IsFirstTime"}},
                Activate = function(self,newValue)
                    if newValue and self.EnTbl.Inbound then
                        for num, event in ipairs(C.getinstances()) do
                            if event:IsA("RemoteEvent") then
                                table.insert(self.Functs,event.OnClientEvent:Connect(function(...)
                                    local RemoteNames = rawget(C,"RemoteNames")
                                    local MyRemoteName = RemoteNames and rawget(RemoteNames,event) or event:GetFullName()
                                    print(`[Inbound Remote Spy]: {MyRemoteName}`,...)
                                end))
                            end
                        end
                    end
                    local IgnoreList = self.IgnoreList[game.GameId] or {}
                    local TblFind = C.TblFind
                    C.HookMethod("__namecall",self.Shortcut,newValue and self.EnTbl.Outbound and function(theirScript,method,self,...)
                        local RemoteNames = rawget(C,"RemoteNames") or {}
                        local MyRemoteName = rawget(RemoteNames,self) or self.Name
                        if not TblFind(IgnoreList,MyRemoteName) then
                            task.spawn(print,`[Outbound Remote Spy]: "{theirScript}" on {MyRemoteName}:{method}() w/ path {debug.traceback()}; args`,...)
                        end
                        --require(game:GetService("Players").SuitedForBans12.PlayerScripts.Modules.CharacterHandler)["_attachedEvent"].Event:Connect(function(...) warn("attach",...) end) warn("Hook")
                    end,{"fireserver","invokeserver"})
                end,
                Options = {
                    {
						Type = Types.Toggle,
						Title = "Inbound",
						Tooltip = "Tracks all requests coming TO the client (RemoteEvents)! Warning: DOES NOT TRACK REMOTE FUNCTIONS",
						Layout = 1,Default=true,
						Shortcut="Inbound",
                        Activate = C.ReloadHack,
					},
                    {
						Type = Types.Toggle,
						Title = "Outbound",
						Tooltip = "Tracks all requests going TO the server (RemoteEvents/RemoteFunctions)!",
						Layout = 2,Default=true,
						Shortcut="Outbound",
                        Activate = C.ReloadHack,
					},
                },
            },
            {
				Title = "Find Game Scripts",
				Tooltip = "Finds all the scripts in Player object and character",
				Layout = 6,Type="NoToggle",
				Shortcut = "FindAllScripts",
				Activate = function(self,newValue)
                    local ignoreParents = {[game.CoreGui]=true}
                    local ignoreList = {["OrgColor"]=true,["OrgTrans"]=true,['wallclip']=true,['HackGUI1']=true,["LastTP"]=true,
                        ["OriginalCollide"]=true,["OrgSize"]=true,["WeirdCanCollide"]=true,["Opened"]=true,["SaveVolume"]=true,['ClearedHackGUI1']=true,
						["RealFuel"]=true}
					local ignoreRegex = {"[%a%d]+_OriginalValue","[%a%d]+_Request_","[%a%d]+_RequestCount"}
                    local function printScr(obj)
                        if obj and (obj:IsA("LocalScript") or (obj.ClassName == "Script" and obj.RunContext == Enum.RunContext.Client)) then
							print(`[OBJ {obj.Parent:GetFullName()}]: {obj.Name}, {obj.Enabled}`)
						end
                    end
                    local function loop(obj,instsScanned)
                        instsScanned = (instsScanned or 0) + 1
                        if not obj then
                            return instsScanned
                        end
                        printScr(obj)
                        if ignoreParents[obj] then
                            return -- don't go through ignoreparents!
                        end
                        for num, instance in ipairs(obj:GetChildren()) do
                            instsScanned = loop(instance,instsScanned)
                            if num%40==0 then
                                game["Run Service"].RenderStepped:Wait()
                            end
                        end
                        return instsScanned
                    end
                    local start = os.clock()

                    warn("[Script Search] Search Beggining...")

                    local Count = C.comma_value(loop(game))

                    warn(("[Script Search] Search Finished! Loop through %s instances in %.2f seconds!"):format(Count,os.clock()-start))
				end,
				Options = {

				}
			},
            {
				Title = "Find Nil Scripts",
				Tooltip = "Finds scripts parented to nil",
				Layout = 5,Type="NoToggle",
				Shortcut = "FindNilScripts",
				Activate = function(self,newValue)
                    pcall(function()
                        for num, scr in ipairs(C.getrunningscripts()) do
                            if scr.Parent == workspace or scr.Parent == nil then
                                print(scr)
                            end
                        end
                    end)
				end,
				Options = {

				}
			},

            {
                Title = "Get Place Ids",Type="NoToggle",
                Tooltip = "Prints place ids for the current game",
                Layout=6,
                Shortcut = "GetPlaceIds",
                Activate = function(self,newValue)

                    local placePages = AS:GetGamePlacesAsync()

                    while true do
                        for _, place in placePages:GetCurrentPage() do
                            print({
                                Name = place.Name,
                                PlaceId=place.PlaceId
                            })
                        end
                        if placePages.IsFinished then
                            break
                        end
                        placePages:AdvanceToNextPageAsync()
                    end
                end
            },
            {
				Title = "Check Events",
				Tooltip = "Prints events in a table format to the console",
				Layout = 7,Type="NoToggle",NoStudio = true,
				Shortcut = "CheckEvents",
                EventsToCheck = {
                    [UIS] = {
                        --[["TouchEnded",
                        "TouchLongPress",
                        "TouchMoved",
                        "TouchPan",
                        "TouchPinch",
                        "TouchRotate",
                        "TouchStarted",
                        "TouchSwipe",--]]
                        "TouchTap",
                        "TouchTapInWorld"
                    }
                },
				Activate = function(self,newValue)
                    local tbl = {}
                    for instance, connections in pairs(self.EventsToCheck) do
                        local curTbl1 = {}
                        for num, connName in ipairs(connections) do
                            local curTbl2 = {}
                            for num2, connection in ipairs(C.getconnections(instance[connName])) do
                                table.insert(curTbl2, {imhere=true,
                                    --Enabled=connection.Enabled,
                                    --ForeignState=connection.ForeignState,
                                    --LuaConnection=connection.LuaConnection,
                                })
                            end
                            curTbl1[connName] = curTbl2
                        end
                        tbl[instance] = curTbl1
                    end
                    print("Client Connections:",tbl)
				end,
			},
            {
				Title = "Get GameID",
				Tooltip = "Sets the GameID to clipboard",
				Layout = 10,Type="NoToggle",NoStudio = true,
				Shortcut = "SetGameToClipBoard",
				Activate = function(self,newValue)
                    C.setclipboard(game.GameId)
				end,
			},
            C.Executor == "Cryptic" and {
				Title = "Improve GUI",
				Tooltip = "Improves the UI, which supports:\nCryptic",
				Layout = 30, Default = true,
				Shortcut = "ImproveGUI", Instances = {},
				Activate = function(self,newValue,firstRun)
                    if C.Executor == "Cryptic" then
                        local MainFrame = CG:FindFirstChild("MainShell",true).MainFrame

                        local ConsoleTab = C.StringWait(MainFrame,"Console Tab")
                        local ScrollingFrame = ConsoleTab:WaitForChild("ScrollingFrame")
                        local UIListLayout = ScrollingFrame:WaitForChild("UIListLayout")

                        C.SetPartProperty(UIListLayout,"Padding",self.Shortcut,newValue and UDim.new(0,0) or C)

                        if not newValue then return end

                        local ClearButton = Instance.new("TextButton",ConsoleTab)
                        ClearButton.Name = "ClearButton"
                        ClearButton.Text = "Clear"
                        ClearButton.TextScaled = true
                        ClearButton.Size = UDim2.fromScale(.1,.1)
                        ClearButton.Position = UDim2.fromScale(0.1,0)
                        ClearButton.AnchorPoint = Vector2.new(0,1)
                        ClearButton.ZIndex = 99999

                        table.insert(self.Instances, ClearButton)
                        C.ButtonClick(ClearButton,function()
                            C.ClearChildren(ScrollingFrame)
                            ScrollingFrame.CanvasSize = UDim2.new()
                            ScrollingFrame.CanvasPosition = Vector2.new(0,0)
                        end)
                    else
                        --"not doing anything lol"
                        error(`Unknown Improvement Executor`)
                    end
				end,
				Options = {

				}
			},
		}
	}
end
]=],
    ["Hacks/Friends"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}
local PS = game:GetService("Players")
return function(C,Settings)
	return {
		Category = {
			Name = "Users",
			Title = "Friends",
			Image = 10885655986,
			Layout = 3,
			AfterMisc = true,
		},
		Tab = {
			{
				Title = "Target Blacklist",Shortcut="NoTargetFriends",
				Tooltip = "Modules that attack other players do not attack a selected list of \"friends\"",
				Layout = 1, Default = true,
				Activate = function(self, enabled, firstRun)
					--[[if not enabled then
						C.friends = {}
						return
					end--]]
					local theirEnTbl = C.enHacks.Users.MainAccount
					local friends = C.GetFriendsFunct(theirEnTbl.En and theirEnTbl.MainAccountId[1] or C.plr.UserId)
                    local friendNames = {}
                    local friendNamesToIds = {}
                    for _, data in ipairs(friends) do
                        table.insert(friendNames,data.SortName)
                        friendNamesToIds[data.SortName] = data.UserId
                    end

                    C.friendnames = friendNames
                    C.friendnamestoids = friendNamesToIds
					C.friends = friends
					if self.RealEnabled and not firstRun then
						C.AddNotification("Friends Loaded",`{#friends} Friends will not be targeted by modules`)
					end
				end,
				Options = {
					{
						Type = Types.Toggle,
						Title = "Roblox Friends",Shortcut="RobloxFriends",
						Tooltip = "Doesn't target Roblox Friends. Refreshes on enable",
						Activate=C.ReloadHack,
						Layout = 1,Default = true,
					},
					{
						Type = Types.UserList,
						Title = "Additional Friends",Shortcut="AdditionalFriends",
						Tooltip = "A list of friends that are never targeted from modules",
						Layout = 2,Default={},
						Limit = 30,
					},
				}
			},
			{
				Title = "Main Account",Shortcut="MainAccount",
				Tooltip = "Input your main account and it will be",
				Layout = 2, Default = true,
				Events = {},
				Options = {
					{
						Type = Types.UserList,
						Title = "Account",Shortcut="MainAccountId",
						Tooltip = "Your main account (defaults to current account)",
						Layout = 2,Default={},
						Limit = 1,
						Activate = C.ReloadHack,--function(self)
							--local FriendHack = self.Parent.Parent[1]
							--FriendHack.Options[1].Activate(FriendHack,FriendHack.Enabled)
							--self.Parent.Parent:Activate()
						--end,
					},
				},
				Activate = function(self,newValue,startUp)
					if startUp then
						return
					end
					local FriendHack = self.Parent.Tab[1]
					FriendHack.Options[1].Activate(FriendHack,FriendHack.RealEnabled)
				end,
			},
		}
	}
end
]=],
    ["Hacks/Render"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local PS = game:GetService("Players")
local RunS = game:GetService("RunService")
local CS = game:GetService("CollectionService")
local DS = game:GetService("Debris")
local UIS = game:GetService("UserInputService")
return function(C,Settings)
	return {
		Category = {
			Name = "Render",
			Title = "Render",
			Image = 14503021137,
			Layout = 1,
		},
		Tab = {
			{
				Title = "ESP Players",
				Tooltip = "Highlights users' characters when they are not visible on the screen",
				Layout = 1,Default=true,
				Shortcut = "PlayerHighlight", Threads={}, Functs={}, Instances = {}, Storage={},
				UpdVisibility = function(self,instances,hasCameraSbj,enabled,theirPlr,theirChar,theirHumanoid: Humanoid,theirIsInGame)
					local NameTag, Highlight = instances[1], instances[2]
					NameTag.Enabled = hasCameraSbj and ((self.EnTbl.NameTagVisible=="No Line Of Sight" and enabled) or self.EnTbl.NameTagVisible=="Always")
					Highlight.Enabled = hasCameraSbj and ((self.EnTbl.HighlightVisible=="No Line Of Sight" and enabled) or self.EnTbl.HighlightVisible=="Always")
					if NameTag.Enabled or Highlight.Enabled then
						Highlight.FillColor = C.GetPlayerNameTagColor(theirPlr,theirChar,theirIsInGame)
						if NameTag:FindFirstChild("Username") then
							NameTag.Username.TextColor3 = Highlight.FillColor
						end
                        NameTag.Adornee = theirChar:FindFirstChild("Head") or theirChar.PrimaryPart
					end
					if theirHumanoid then
						--theirHumanoid.DisplayDistanceType = NameTag.Enabled and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Subject
                        C.SetPartProperty(theirHumanoid, "DisplayDistanceType", self.Shortcut, NameTag.Enabled and Enum.HumanoidDisplayDistanceType.None or C)
					end
				end,
				checkIfInRange = function(self,camera,theirPlr,theirChar,HRP)
					if self.EnTbl.Distance < 0.1 or self.EnTbl.Distance < (camera.CFrame.Position - HRP.Position).Magnitude then
						return false -- no way we're reaching them lol!
					end
					if camera.CameraSubject and camera.CameraSubject.Parent == theirChar then
						return true
					end
					local options = {
						ignoreInvisibleWalls = self.EnTbl.IgnoreInvisibleWalls,
						ignoreUncollidable = self.EnTbl.IgnoreUncollidibleWalls,
						ignoreList = {},--{camera.CameraSubject and camera.CameraSubject.Parent or nil},  -- Example: ignore parts in this list
						raycastFilterType = Enum.RaycastFilterType.Exclude,  -- Choose filter type
						distance = self.EnTbl.Distance, -- Maximum cast distance
						detectionFunction = function(part)
							return theirChar:IsAncestorOf(part)--part:HasTag("CharPart") and
						end,
						passFunction = function(part)
							return part:HasTag("CharPart")
						end,
					}

					local hitResult, hitPosition = C.Raycast(camera.CFrame.Position,(HRP.Position - camera.CFrame.Position).Unit,options)
					return hitResult and theirChar:IsAncestorOf(hitResult.Instance)
				end,
				RunCheck = function(self,instanceData)
					local camera = workspace.CurrentCamera
					local theirPlr,theirChar,instances,theirHumanoid,HRP = table.unpack(instanceData)
					local theirInGame = C.isInGame and table.pack(C.isInGame(theirChar))
					if C.enHacks.World.Freecam.En or
                    (not camera.CameraSubject or not camera.CameraSubject.Parent) or (theirHumanoid~=camera.CameraSubject and (not theirInGame or
					((theirInGame[3]==nil and select(3,C.isInGame(camera.CameraSubject.Parent))==theirInGame[3]) or
					(theirInGame[3]~=nil and C.isInGame(camera.CameraSubject.Parent)==theirInGame[1])))) then
						local isInRange
						-- Only run when needed
						if self.EnTbl.NameTagVisible=="No Line Of Sight" or self.EnTbl.HighlightVisible=="No Line Of Sight" then
							isInRange = self:checkIfInRange(camera,theirPlr,theirChar,HRP)
						end
						self:UpdVisibility(instances,true,not isInRange,theirPlr,theirChar,theirHumanoid,theirInGame)
					else
						self:UpdVisibility(instances,false,false,theirPlr,theirChar,theirHumanoid)
					end
				end,
				ClearStorage = function(self)
					for theChar, data in pairs(self.Storage) do
						self.Events.CharRemoved(self,nil,theChar) -- Fake cleanup!
					end
				end,
				Activate = function(self,newValue)
					self:ClearStorage()
					if not newValue then
						return
					end
					for num, theirPlr in ipairs(PS:GetPlayers()) do
						local theirChar = theirPlr.Character
						if theirChar then
							task.spawn(self.Events.CharAdded,self,theirPlr,theirChar)
						end
					end
					local oldCameraSubject = workspace:WaitForChild("Camera").CameraSubject
					table.insert(self.Functs,workspace:WaitForChild("Camera"):GetPropertyChangedSignal("CameraSubject"):Connect(function()
						local OldStorage = self.Storage[oldCameraSubject and oldCameraSubject.Parent or nil]
						oldCameraSubject = workspace.Camera.CameraSubject
						local NewStorage = self.Storage[oldCameraSubject and oldCameraSubject.Parent or nil]

						if NewStorage then
							self:RunCheck(NewStorage)
						end
						--RunS.RenderStepped:Wait()
						if OldStorage then
							self:RunCheck(OldStorage)
						end
					end))
					while true do
						for _, instanceData in pairs(self.Storage) do
							self:RunCheck(instanceData)
						end
						task.wait(self.EnTbl.UpdateTime)
					end
				end,
				Events = {
					CharAdded = function(self,theirPlr,theirChar,firstRun)
						local robloxHighlight = Instance.new("Highlight")
						robloxHighlight.Enabled = false
						robloxHighlight.OutlineTransparency,robloxHighlight.FillTransparency = 1, 0
						robloxHighlight.OutlineColor = Color3.fromRGB()
						robloxHighlight.Adornee = theirChar
						robloxHighlight.Parent = C.GUI
						local nameTag = C.Examples.NameTagEx:Clone()
						nameTag:WaitForChild("Username").Text = theirPlr.Name
						nameTag.Parent = C.UI.ESP
						--nameTag.Adornee = theirChar:FindFirstChild("Head") or theirChar.PrimaryPart
						table.insert(self.Instances,nameTag)
						table.insert(self.Instances,robloxHighlight)
						local theirHumanoid = theirChar:WaitForChild("Humanoid",1000)
						local camera = workspace.CurrentCamera
						local HRP = theirChar:WaitForChild("HumanoidRootPart",15)
						if not HRP then
							return
						end
						local StorageTbl = {theirPlr,theirChar,{nameTag,robloxHighlight},theirHumanoid,HRP}
						self.Storage[theirChar] = StorageTbl
						self:RunCheck(StorageTbl)
					end,
					CharRemoved = function(self,thePlr,theChar)
						local instanceData = self.Storage[theChar]
						if instanceData then
							local theirPlr,theirChar,instances,theirHumanoid,HRP = table.unpack(instanceData)
							self.Storage[theChar] = nil
							for num, instance in ipairs(instances) do
								C.TblRemove(self.Instances,instance)
								instance:Destroy()
							end
						else
							warn(`InstanceData not found for {theChar} but its being removed!`)
						end
					end,
				},
				Options = {
					{
						Type = Types.Dropdown,
						Title = "NameTags",
						Tooltip = "When NameTags are displayed",
						Layout = -2,Default="Always",
						Selections = {"Always","No Line Of Sight","Never"},
						Shortcut="NameTagVisible",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Dropdown,
						Title = "Highlight",
						Tooltip = "When NameTags are displayed",
						Layout = -1,Default="No Line Of Sight",
						Selections = {"Always","No Line Of Sight","Never"},
						Shortcut="HighlightVisible",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Slider,
						Title = "Raycast Update Time*",
						Tooltip = "How often to update its visibility (PERFORMANCE)",
						Layout = 0,Default=1,
						Min=0,Max=3,Digits=1,
						Shortcut="UpdateTime",
					},
					{
						Type = Types.Slider,
						Title = "Raycast Distance",
						Tooltip = "Highlights will not appear when a character's head can be directly seen from this distance (set to 0 to disable)",
						Layout = 2,Default=100,
						Min=0,Max=100,Digits=1,
						Shortcut="Distance",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Invisible Walls",
						Tooltip = "Whether or not the raycast goes through invisible walls",
						Layout = 2,Default=true,
						Shortcut="IgnoreInvisibleWalls",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Uncollidible Walls",
						Tooltip = "Whether or not the raycast goes through uncollidible walls (walls that have CanCollide=false)",
						Layout = 3,Default=true,
						Shortcut="IgnoreUncollidibleWalls",
					},
				}
			},
			{
				Title = "ESP Touch Transmitters",
				Tooltip = "Ability to toggle/activate touch transmitters",
				Layout = 2,Default=false,Deb=0,
				Shortcut = "DisableTouchTransmitters", Instances = {}, Functs={},
				TouchTransmitters={}, Threads = {},
				GlobalTouchTransmitters={},
				GetType=function(self,instance)
					if instance.Parent.Parent.ClassName=="Model" and instance.Parent.Parent.Parent==workspace
						and instance.Parent.Parent:WaitForChild("Humanoid",.1) then
						return "Humanoid"
					else
						return "Part"
					end
				end,
				CanBeEnabled=function(self,instance,Type)
					Type = Type or self:GetType(instance)
					if C.Cleared or not instance or not instance.Parent then
						return false, Type
					end
					if not self.RealEnabled then
						return false, Type
					elseif self.EnTbl.Humanoids and Type=="Humanoid" then
						return true, Type
					elseif self.EnTbl.Parts and Type=="Part" then
						return true, Type
					else
						return false, Type
					end
				end,
				UndoTransmitter=function(self,index)
					local data = self.TouchTransmitters[index]
					local object, parent, Type, TouchToggle = table.unpack(data or {})
					if parent and parent.Parent then-- and not self:CanBeEnabled(object,Type) then
						C.ResetPartProperty(parent,"CanTouch","DisableTouchTransmitters")
						if TouchToggle then
							TouchToggle:Destroy()
						end
						parent:RemoveTag("TouchDisabled")
						self.TouchTransmitters[index]=nil
						self.GlobalTouchTransmitters[parent] = nil
					end
				end,
				UndoTransmitters=function(self,saveEn,clearOverride)
					for index = #self.TouchTransmitters,1,-1 do
						if (saveEn ~= self.RealEnabled or C.Cleared) and not clearOverride then
							return
						end
						self:UndoTransmitter(index)
						if index%15==0 then
							RunS.RenderStepped:Wait()
						end
					end
				end,
				RunOnDestroy=function(self)
					C.ClearTagTraces("TouchDisabled")
					print("Tags Cleared!")
				end,
				ApplyTransmitters=function(self,instance)
					if instance:IsA("TouchTransmitter") and instance.Parent and instance.Parent.Parent then
						local parent = instance.Parent
						local canBeEn, Type = self:CanBeEnabled(instance)
						if canBeEn and not parent:HasTag("TouchDisabled") then
							local TouchToggle=C.Examples.ToggleTagEx:Clone()
							local insertTbl = {instance,parent,Type,TouchToggle,{}}
							table.insert(self.TouchTransmitters,insertTbl)

							TouchToggle.Name = "TouchToggle"
							TouchToggle.Parent=C.GUI
							TouchToggle.Adornee=parent
							TouchToggle.ExtentsOffsetWorldSpace = Vector3.new(0, 0, 0)
							TouchToggle.Enabled = self.EnTbl.ClickMode ~= "Hidden"
							table.insert(self.Instances,TouchToggle)
							CS:AddTag(parent,"TouchDisabled")

							if Type=="Part" then
								if parent.CanCollide then
									TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 238)
								else
									TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 0, 255)
								end
								TouchToggle.Toggle.Text = "Activate"
							else
								TouchToggle.Toggle.Text = "Enable"
								TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(0,170)
							end
							local saveCollide = parent.CanCollide or parent.Parent.Name=="FadingTiles"
							local function clickfunction(didClick: boolean)
								if self.EnTbl.ClickMode == "Activate" then
									if not C.hrp then
										return
									end

									local toTouch

									if TouchToggle.Toggle.Text == "Activate" then
										TouchToggle.Toggle.Text = "DeActivate"
										TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(255,0,80)
										toTouch = 0
									else
										TouchToggle.Toggle.Text = "Activate"
										if saveCollide then
											TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 238)
										else
											TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 0, 255)
										end
										toTouch = 1
									end


									C.ResetPartProperty(parent,"CanTouch","DisableTouchTransmitters")
									RunS.RenderStepped:Wait()
									C.firetouchinterest(C.hrp, parent, toTouch)
									RunS.RenderStepped:Wait()

									if TouchToggle.Parent then
										C.SetPartProperty(parent,"CanTouch","DisableTouchTransmitters",false)
									end
								else
									if parent.CanTouch then
										TouchToggle.Toggle.Text = "Enable"
										TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(0,170)
									else
										TouchToggle.Toggle.Text = "Disable"
										TouchToggle.Toggle.BackgroundColor3 = Color3.fromRGB(170)
									end
									if parent.CanTouch then
										C.SetPartProperty(parent,"CanTouch","DisableTouchTransmitters",false)
									else
										C.ResetPartProperty(parent,"CanTouch","DisableTouchTransmitters")
									end
								end
								if self.EnTbl.ClickDuration ~= "Forever" and didClick ~= false then
									table.insert(self.Threads,task.delay(tonumber(self.EnTbl.ClickDuration) or 0, clickfunction,false))
								end
							end
							table.insert(insertTbl[5],TouchToggle.Toggle.MouseButton1Up:Connect(clickfunction))
							self.GlobalTouchTransmitters[parent] = clickfunction
							table.insert(insertTbl[5],parent.AncestryChanged:Connect(function(child,newParent)
								if not newParent then
									task.wait(1)
									local Key = table.find(self.TouchTransmitters,insertTbl)
									if Key then
										self:UndoTransmitter(Key)
									end
								else
									TouchToggle.Adornee=workspace:IsAncestorOf(child) and parent or nil
								end
							end))
							C.AddObjectConnection(parent,"DisableTouchTransmitters",parent.Destroying:Connect(function()
								DS:AddItem(TouchToggle,1)
							end))
							C.SetPartProperty(parent,"CanTouch","DisableTouchTransmitters",false)
						end
					end

					local saveEn = self.RealEnabled
					for num, location in ipairs(instance:GetChildren()) do
						if saveEn ~= self.RealEnabled then
							return
						end
						self:ApplyTransmitters(location)
						if num%150==0 then
							RunS.RenderStepped:Wait()
						end
					end
				end,
				Activate=function(self,newValue)
					C.ClearFunctTbl(self.Functs)
					self:UndoTransmitters(newValue)
					if newValue then
						table.insert(self.Functs,workspace.DescendantAdded:Connect(function(descendant)
							self:ApplyTransmitters(descendant)
						end))
						self:ApplyTransmitters(workspace)
					end
				end,
				Events={
					--[[CharAdded=function(self,theirPlr,theirChar,firstRun)
						local theirHRP = theirChar:WaitForChild("HumanoidRootPart",30)-- wait for it to be loaded!
						if not theirHRP then
							return
						end
						task.wait(.5)
						if firstRun then
							task.wait(2.5)
							self:Activate(self.RealEnabled)
						end
					end,--]]
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Humanoids",
						Tooltip = "Whether or not parts that are humanoids are affected",
						Layout = 0,Default=false,
						Shortcut="Humanoids",
						Activate = C.ReloadHack
					},
					{
						Type = Types.Toggle,
						Title = "Parts",
						Tooltip = "Whether or not regular parts are affected",
						Layout = 1,Default=true,
						Shortcut="Parts",
						Activate = C.ReloadHack
					},
					{
						Type = Types.Dropdown, Selections = {"Activate","Enable","Hidden"},
						Title = "Button Mode",
						Tooltip = "What happens when you click on a disabled object",
						Layout = 2,Default="Activate",
						Shortcut="ClickMode",
						Activate = C.ReloadHack
					},
					{
						Type = Types.Dropdown, Selections = {"Instant", "Forever"},
						Title = "Click Duration",
						Tooltip = "How long the clicking lasts before it reverts to being disabled",
						Layout = 3,Default="Instant",
						Shortcut="ClickDuration",
						Activate = C.ReloadHack
					},
					--[[{
						Type = Types.Slider,
						Title = "Raycast Update Time*",
						Tooltip = "How often to update its visibility (PERFORMANCE)",
						Layout = 0,Default=1,
						Min=0,Max=3,Digits=1,
						Shortcut="UpdateTime",
					},
					{
						Type = Types.Slider,
						Title = "Raycast Distance",
						Tooltip = "Highlights will not appear when a character's head can be directly seen from this distance (set to 0 to disable)",
						Layout = 2,Default=100,
						Min=0,Max=100,Digits=1,
						Shortcut="Distance",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Invisible Walls",
						Tooltip = "Whether or not the raycast goes through invisible walls",
						Layout = 2,Default=true,
						Shortcut="IgnoreInvisibleWalls",
					},
					{
						Type = Types.Toggle,
						Title = "Ignore Uncollidible Walls",
						Tooltip = "Whether or not the raycast goes through uncollidible walls (walls that have CanCollide=false)",
						Layout = 3,Default=true,
						Shortcut="IgnoreUncollidibleWalls",
					},--]]
				}
			},
			{
				Title = "Frame Rate",
				Tooltip = "Displays frame rate at the top right corner of your screen",
				Layout = 20,Default=true,
				Shortcut = "FrameRate", Threads = {},
				Activate = function(self,newValue)
					local TL = C.UI.FrameRate
					TL.Visible = newValue
					if not newValue then
						return
					end
					while true do
						local Start = os.clock()
						local Frames = {}
						while (os.clock() - Start) < 2/3 do
							task.wait(1/10)
							table.insert(Frames,1/RunS.RenderStepped:Wait())
						end
						local Sum = 0
						for _, val in ipairs(Frames) do
							Sum += val
						end
						local AvgFrameRate = Sum / #Frames
						local FrameRate = math.min(60,AvgFrameRate)
						TL.Text = ("%i"):format(FrameRate)
					end
				end,
			},
		}
	}
end]=],
    ["Hacks/Scrapped"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local CG = game:GetService("CoreGui")
return function(C,Settings)
	return {
		Category = {
			Name = "Render",
			Title = "Render",
			Image = 14503021137,
			Layout = 1,
		},
		Tab = {
			--[[{
				Title = "Nicknamer",
				Tooltip = "LOCALLY spoofs your username and displayname",
				Layout = 1,
				Shortcut = "Nickname",Functs={},Default=false,
				Set = function(Username:string, Display: string)
					if C.isStudio then
						return
					end
					Display = Username or Display
					local Display1Box = C.StringWait(CG,"PlayerList.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame"
					..`.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame.p_{C.plr.UserId}.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName`)
					local Display2Box = C.StringWait(CG,`RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.PageViewClipper.PageView.PageViewInnerFrame.Players.PlayerLabel{C.plr.Name}.DisplayNameLabel`)
					local Username1Box = C.StringWait(CG,`RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.PageViewClipper.PageView.PageViewInnerFrame.Players.PlayerLabel{C.plr.Name}.NameLabel`)
					Display1Box.Text = Display
					Display2Box.Text = Display
					Username1Box.Text = Username
					--Set the character, if it exists
					if C.char then
						C.char.Name = Username
					end
					if C.human then
						C.human.DisplayName = Display
					end
					--Set the actual username
					C.setscriptable(C.plr,"Name",true)
					C.setscriptable(C.plr,"DisplayName",true)
					
					C.plr.Name, C.plr.DisplayName = Username, Display
					
					C.setscriptable(C.plr,"Name",false)
					C.setscriptable(C.plr,"DisplayName",false)
				end,
				DescendantAdded=function(newDescendant)
					if newDescendant:IsA("TextLabel") then
						
					end
				end,
				Activate = function(self,newValue)
					if self.RealEnabled then
						self:Set(self.EnTbl.Username,self.EnTbl.DisplayName)
						table.insert(self.Functs,C.PlayerGui.DescendantAdded:Connect(function(child)
							self:DescendantAdded(child)
						end))
						for num, child in ipairs(C.PlayerGui:GetDescendants()) do
							self:DescendantAdded(child)
						end
					else
						self:Set(C.Defaults.Username,C.Defaults.DisplayName)
					end
				end,
                Events = {},
				Options = {
					{
						Type = Types.Textbox,
						Title = "Username",
						Tooltip = "Swings everywhere cuz why not?",
						Layout = 1,Default = "Player1",Min=3,Max=20,
						Shortcut="Username",
					},
					{
						Type = Types.Textbox,
						Title = "DisplayName",
						Tooltip = "Swings everywhere cuz why not?",
						Layout = 2,Default = "Player",Min=3,Max=20,
						Shortcut="DisplayName",
					}
				},
			},--]]
			--[[{
				Title = "AimAssist",
				Tooltip = "Aims At Enemies",
				Layout = 1,
				Shortcut = "AimAssist",
				Activate = function(self,newValue)
					print("wow",newValue)
				end,
				Events = {
					
				},
				Options = {
					{
						Type = Types.Toggle,
						Title = "God Mode",
						Tooltip = "Swings everywhere cuz why not?",
						Layout = 1,Default = true,
						Shortcut="GodMode",
					},
					{
						Type = Types.Slider,
						Title = "Distance",
						Tooltip = "How far an enemy can be before the interaction occurs",
						Layout = 2,Default=10,
						Min=0,Max=100,Digits=1,
						Shortcut="Distance",
					},
					{
						Type = Types.Dropdown,
						Title = "Mode",
						Tooltip = "What kind of mode to select",
						Layout = 3,Default="Ranged",
						Selections = {"Ranged","Legit","Far"},
						Shortcut="Dropdown1",
					},
					{
						Type = Types.Dropdown,
						Title = "Mode2",
						Tooltip = "What kind of mode to select",
						Layout = 4,Default="Ranged2",
						Selections = {"Ranged2","Legit2","Far2"},
						Shortcut="Dropdown2",
					},
				}
			},--]]
		}
	}
end
]=],
    ["Hacks/Settings"] = [[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local SG = game:GetService("StarterGui")
return function(C,Settings)
	return {
		Tab = {
			{
				Title = "Developer",
				Tooltip = "This is designed for developers only; it includes tools that are useful for production (REQUIRES REFRESH)",
				Layout = 1,
				Shortcut = "DeveloperMode",
			},
		}
	}
end]],
    ["Hacks/Utility"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

local DS = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local PS = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TCS = game:GetService("TextChatService")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")
local SC = game:GetService("ScriptContext")
local LS = game:GetService("LogService")
local NC = game:GetService("NetworkClient")
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
				Layout = 100, NoStudio = true,
				Shortcut = "AntiAfk",Functs={},Default=true,
                Update = function()
					VU:CaptureController()
                    VU:ClickButton2(Vector2.new())
                end,
				Activate = function(self,newValue)
					C.SetInstanceConnections(C.plr,"Idled",self.Shortcut,not newValue or not self.EnTbl.GameProtection)
                    if not newValue then
                        return
                    end
					table.insert(self.Functs, C.plr.Idled:Connect(self.Update))
				end,
                Events = {},
				Options = {
					{
						Type = Types.Toggle,
						Title = "Game Protection",
						Tooltip = "Prevents game scripts from accessing the Player.Idled connection",
						Layout = 3,Default=true,
						Shortcut="GameProtection",
						Activate = C.ReloadHack,
					},
				},
			},
			{
				Title = "Chat",Type="NoToggle",
				Tooltip = "Simulates the chat key press",
				Layout = 99,
				Shortcut = "Chat",Keybind="Slash",
				Functs={},
				SlashPressedOld = function(self)
					local chatBar = C.StringWait(C.PlayerGui,"Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar")

					SG:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
					SG:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)

					table.insert(self.Functs,chatBar:GetPropertyChangedSignal("TextTransparency"):Connect(function()
						chatBar.TextTransparency = 0
					end))
					chatBar.TextTransparency = 0
					RunS.RenderStepped:Wait()
					chatBar:CaptureFocus()
					task.wait(2.5)
					C.ClearFunctTbl(self.Functs)
				end,
				Activate = function(self,newValue)
					if SG:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
						if TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
							self:SlashPressedOld()
						else
							C.AddNotification("Unsupported Chat","This game uses a newer TCS version, so it is currently unusable.")
						end
					end
				end,
                Events = {},
				Options = {},
			},
			{
				Title = "NoKick UI",
				Tooltip = "Hides the kick display a few seconds after you are kicked",
				Layout = 100, Default = true, NoStudio = true,
				Shortcut = "NoKick",
				Functs={}, Threads={},
				BestMessage = nil,
				Message = "%s (Error Code %i)\nRejoin to interact with the game and other PS, and click here to hide this prompt.",
				Events = {
					RbxErrorPrompt = function(self, errorMessage,errorCode,identification)
						if identification:find("Teleport") then
							return -- Who cares?
						end
						local KickedButton = C.UI.KickedButton
						if not self.BestMessage or (#errorMessage>0 and errorMessage ~= "You have been kicked from the game") then
							self.BestMessage = errorMessage
							print((`%s Error Has Occured (%.1f): %s`):format(identification, time(), errorMessage))
						end

						if KickedButton then
							KickedButton.Size = UDim2.fromScale(KickedButton.Size.X.Scale,0)
							KickedButton.AutomaticSize = Enum.AutomaticSize.Y
							if self.BestMessage then
								KickedButton.Text = self.Message:format(self.BestMessage,errorCode)
							end
							KickedButton.Visible = true
						end

						-- Debug.Traceback doesn't work for this:
						task.defer(GS.ClearError,GS)
						SG:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
					end,
				},
			},
			{
				Title = "Bot",
				Tooltip = "Implements several automatic features",
				Layout = 99,
				Shortcut = "BotAuto",
				RejoinDelay = 30,
				Sending = false,
                ChatConnected = false,
                Functs = {},
                Threads = {},
				--[[Functs = {},
				Activate = function(self, newValue)
					if newValue then
						table.insert(self.Functs, TeleportService.TeleportInitFailed:Connect(function(player,teleportResult,errorMessage,placeId,teleportOptions)
							if errorMessage == "Teleport failed due to an unexpected error. Please try teleporting again." then

							end
							task.wait(2)
						end))
					end
				end,--]]
                Activate = function(self, newValue, firstRun)
                    if newValue and self.EnTbl.LowerFPS then
                        setfpscap(10)
                    elseif setfpscap and not firstRun then
                        setfpscap(0)
                    end
                    if not firstRun and C.char then
                        if newValue then
                            table.insert(self.Threads, task.spawn(self.Events.MyCharAdded,self, C.plr, C.char, false))
                        else
                            self.Events.MyCharAdded(self, C.plr, C.char, false)
                        end
                    end
                    if not newValue then
                        self.ChatConnected = false
                        return
                    end
                    for _, theirPlr in ipairs(PS:GetPlayers()) do
                        self.Events.OthersPlayerAdded(self, theirPlr, false)
                    end
                end,
                HasAdminAccess = function(self, theirPlr)
                    return table.find(C.AdminUsers, theirPlr.Name:lower())
                end,
                Options = {
                    setfpscap and {
                        Type = Types.Toggle,
                        Default = false,
                        Title = "FPS Cap",
                        Tooltip = "Lowers FPS to 10 to allow for other CPU processes",
                        Layout = 1,
                        Shortcut="LowerFPS",
                        Activate=C.ReloadHack,
                    },
                    {
                        Type = Types.Toggle,
                        Default = false,
                        Title = "Hide Character",
                        Tooltip = "Hides your character from visible view, but also unable to interact with anything",
                        Layout = 2,
                        Shortcut="HideChar",
                        Activate=C.ReloadHack,
                    }
                },
				Events = {
					RbxErrorPrompt = function(self, errorMessage, errorCode, errorIdentification)
						if self.Sending then
							return
						end
						self.Sending = true
						local RejoinDelay = self.RejoinDelay
						local Cancel = task.spawn(function()
							if not C.Prompt(`Auto-Rejoin`,`Auto Rejoin Will Occur In {RejoinDelay} Seconds.\nTo turn this off, disable \"Utility->Bot\"`,"Cancel") then
								self.Sending = false
							end
						end)
						task.wait(5)
						if self.Sending then
							C.Prompt_ButtonTriggerEvent:Fire("Yes")
							task.wait(0.4)
                            self.Sending = false
							C.ServerTeleport(game.PlaceId, nil)
						end
					end,
                    OthersPlayerAdded = function(self,theirPlr,firstRun)
                        if theirPlr == C.plr or self.ChatConnected or firstRun then
                            return -- do not double do it!
                        end
                        if self:HasAdminAccess(theirPlr) then
                            self.ChatConnected = true
                            if TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
                                local DoneFiltering = C.StringWait(RS, "DefaultChatSystemChatEvents.OnMessageDoneFiltering")
                                table.insert(self.Functs, DoneFiltering.OnClientEvent:Connect(function(data, channel)
                                    local thePlr = PS:GetPlayerByUserId(data.SpeakerUserId)
                                    if thePlr and thePlr ~= C.plr and self:HasAdminAccess(thePlr) then
                                        local msg = data.Message
                                        if not msg then
                                            return
                                        end
                                        if msg:sub(1,1) == "/" then
                                            C.RunCommand(msg, true)
                                        end
                                    end
                                end))
                                --print("Waiting For Established Connection22!",theirPlr)
                            else
                                C.CreateSysMessage(`[Utility.Bot]: New Chat Service is not supportted!`)
                                warn("[Utility.Bot]: New Chat Service Not Supported!",theirPlr)
                            end
                        end
                    end,
                    MyCharAdded = function(self,theirPlr,theirChar,firstRun)
                        if self.RealEnabled and self.EnTbl.HideChar then
                            C.SavePlayerCoords(self.Shortcut)
                            while true do
                                C.DoTeleport(CFrame.new(0,10000,0))
                                C.hrp.AssemblyLinearVelocity = Vector3.zero
                                C.hrp.AssemblyAngularVelocity = Vector3.zero
                                RunS.PreSimulation:Wait()
                            end
                        else
                            C.LoadPlayerCoords(self.Shortcut)
                        end
                    end,
				},
			},
			{
				Title = "Improvements",
				Tooltip = "Many Client Improvement Settings can be found here!",
				Layout = 103,
				Shortcut = "ClientImprovement",Functs={},Default=true,
				SetAutoJump = function(self)
					if C.human then
						C.human.AutoJumpEnabled = (not self.RealEnabled or not self.EnTbl.PreventAutoJump) and UIS.TouchEnabled and C.Defaults.AutoJumpEnabled
					end
				end,
				Activate = function(self,newValue,firstRun)
					local EnTbl = self.RealEnabled and self.EnTbl or {}
					local InputFound = (C.human and C.human.MoveDirection.Magnitude > 1e-5) or C.IsJumping

					--Lock Camera Orientation
					local LastCameraSubjectChangeSignal, LastCamera
					local function UpdateCamera()
						local Camera = workspace.CurrentCamera
						if LastCameraSubjectChangeSignal and Camera ~= LastCamera then
							LastCameraSubjectChangeSignal:Disconnect()
							C.TblRemove(self.Functs,LastCameraSubjectChangeSignal)
						end
						if Camera then
							local newCameraType = Camera.CameraType
							if newCameraType == Enum.CameraType.Custom and EnTbl.LockCamera then
								Camera.CameraType = Enum.CameraType.Track
							elseif newCameraType == Enum.CameraType.Track and not EnTbl.LockCamera then
								Camera.CameraType = Enum.CameraType.Custom
							end
							LastCameraSubjectChangeSignal = Camera:GetPropertyChangedSignal("CameraType"):Connect(UpdateCamera)
							table.insert(self.Functs, LastCameraSubjectChangeSignal)
						end
					end
					table.insert(self.Functs,workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(UpdateCamera))
					UpdateCamera()

					self:SetAutoJump()

					--Disable TouchGui (if it exists)
					if UIS.TouchEnabled then
						local function GUIAdded()
							local ContextActionGui = C.PlayerGui:WaitForChild("ContextActionGui",.3)
							local TouchGui = C.PlayerGui:FindFirstChild("TouchGui");
							if not TouchGui then
								return
							end
							local TouchGui2 = C.gameName == "FlagWars" and C.PlayerGui:WaitForChild("Mobile UI")
							local function updateTouchScreenEnability()
								TouchGui.Enabled = not EnTbl.DisableTouchGUI
								if ContextActionGui then
									ContextActionGui.Enabled = not EnTbl.DisableTouchGUI
								end
								if TouchGui2 then
									TouchGui2.Enabled = not EnTbl.DisableTouchGUI
								end
							end
							if EnTbl.DisableTouchGUI then
								table.insert(self.Functs,TouchGui:GetPropertyChangedSignal("Enabled"):Connect(updateTouchScreenEnability))
								if ContextActionGui then
									table.insert(self.Functs,ContextActionGui:GetPropertyChangedSignal("Enabled"):Connect(updateTouchScreenEnability))
								end
								if TouchGui2 then
									table.insert(self.Functs,TouchGui2:GetPropertyChangedSignal("Enabled"):Connect(updateTouchScreenEnability))
								end
							end
							updateTouchScreenEnability()
						end
						table.insert(self.Functs,C.PlayerGui.ChildAdded:Connect(GUIAdded))
						GUIAdded()
					end

					--Fix Keyboard
					if EnTbl.FixKeyboard and not UIS:GetFocusedTextBox() and not InputFound then
						local tb = Instance.new("TextBox",C.PlayerGui)
						tb.Position = UDim2.new(-1, 0,-1, 0)
						tb.AnchorPoint = Vector2.new(1, 1)
						tb:CaptureFocus()
						RunS.RenderStepped:Wait()
						if tb:IsFocused() then
							tb:ReleaseFocus()
						end
						-- Remove next frame to allow for smooth transition!
						DS:AddItem(tb,0)
						--warn("Textbox Select")
					end

                    -- Infinite Zoom
                    if EnTbl.NoZoomLimit then
				        C.SetPartProperty(C.plr,"CameraMaxZoomDistance",self.Shortcut,10000)
                    else
				        C.ResetPartProperty(C.plr,"CameraMaxZoomDistance",self.Shortcut)
                    end

                    -- No First Person
                    if EnTbl.NoFirstPerson then
                        C.SetPartProperty(C.plr,"CameraMinZoomDistance",self.Shortcut,1)
                        C.SetPartProperty(C.plr,"CameraMode",self.Shortcut,Enum.CameraMode.Classic)
                    else
				        C.ResetPartProperty(C.plr,"CameraMinZoomDistance",self.Shortcut)
                        C.ResetPartProperty(C.plr,"CameraMode",self.Shortcut)
                    end

                    -- Anti Lag
                    if EnTbl.AntiLag ~= "Off" then
                        task.spawn(self.AntiLag, self)
                    end

                    -- Spoof TouchEnabled
                    C.HookMethod("__index",self.Shortcut .. "/SpoofKeyboard",newValue and self.EnTbl.SpoofKeyboard and function(theirScript,index,self,...)
                        if index == "touchenabled" then
                            return "Spoof", {false}
                        end
                    end)
				end,
                AntiLag = function(self)
                    local Terrain = workspace:FindFirstChildOfClass('Terrain')
                    Terrain.WaterWaveSize = 0
                    Terrain.WaterWaveSpeed = 0
                    Terrain.WaterReflectance = 0
                    Terrain.WaterTransparency = 0
                    Lighting.GlobalShadows = false
                    Lighting.FogEnd = 9e9
                    settings().Rendering.QualityLevel = 1
                    for i,v in pairs(game:GetDescendants()) do
                        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                            v.Material = "Plastic"
                            v.Reflectance = 0
                        elseif v:IsA("Decal") then
                            v.Transparency = 1
                        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                            v.Lifetime = NumberRange.new(0)
                        elseif v:IsA("Explosion") then
                            v.BlastPressure = 1
                            v.BlastRadius = 1
                        end
                        if (i%1000 == 0) then
                            RunS.RenderStepped:Wait()
                        end
                    end
                    for i,v in pairs(Lighting:GetDescendants()) do
                        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                            v.Enabled = false
                        end
                    end
                    table.insert(self.Functs,workspace.DescendantAdded:Connect(function(child)
                        task.spawn(function()
                            if child:IsA('ForceField') then
                                RunS.Heartbeat:Wait()
                                child:Destroy()
                            elseif child:IsA('Sparkles') then
                                RunS.Heartbeat:Wait()
                                child:Destroy()
                            elseif child:IsA('Smoke') or child:IsA('Fire') then
                                RunS.Heartbeat:Wait()
                                child:Destroy()
                            end
                        end)
                    end))
                end,
                Events = {
					MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						self:SetAutoJump()
						--C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				},
				Options = {
					{
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
					},
                    {
						Type = Types.Toggle,
						Title = "No Zoom Limit",
						Tooltip = "Allows for infinite zooming",
						Layout = 5,Default=true,
						Shortcut="NoZoomLimit",
						Activate = C.ReloadHack,
					},
                    {
						Type = Types.Toggle,
						Title = "Disable First Person",
						Tooltip = "Prevents First Person",
						Layout = 6,Default=true,
						Shortcut="NoFirstPerson",
						Activate = C.ReloadHack,
					},
                    {
						Type = Types.Dropdown,
						Title = "Anti Lag",
						Tooltip = "Irreversibly removes lots of textures to minimize lag",
						Layout = 9,Default="Off",
						Shortcut="AntiLag",
                        Selections = {"Off","Destroy"},
						Activate = C.ReloadHack,
					},
                    {
						Type = Types.Toggle,
						Title = "No Touchscreen",
						Tooltip = "Forces only to have keyboard input",
						Layout = 15,Default=false,
						Shortcut="SpoofKeyboard",
						Activate = C.ReloadHack,
					},
				},
			},
			{
				Title = "❌❌Disable LogService❌❌",
				Tooltip = "Prevents logs from being viewed or tracked\nNote: this may cause crash on startup!",
				Layout = 200,
				Shortcut = "LogServiceProtection",Default=false,
				Activate = function(self,newValue,firstRun)
					C.HookMethod("__namecall",self.Shortcut,newValue and function (newSc,method,self)
						print("CALLED!",newSc,method,self)
						if self == LS then
							print("Prevented LogService")
							return "Override", {{}}
						end
					end, {"getloghistory"})
					C.SetInstanceConnections(SC,"Error",self.Shortcut,not newValue)
					C.SetInstanceConnections(LS,"MessageOut",self.Shortcut,not newValue)
				end
			}
		}

	}
end
]=],
    ["Hacks/World"] = [=[local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local TCS = game:GetService("TextChatService")
local RS = game:GetService"ReplicatedStorage"
local PS = game:GetService"Players"
local RunS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
local CAS = game:GetService("ContextActionService")
local SG = game:GetService('StarterGui')
local UIS = game:GetService('UserInputService')

local AllowFonts = false
local CHAT_MAXLENGTH = 200

local strSub = string.sub
local strFind = string.find
local strgsub = string.gsub
local strSplit = string.split
local strRep = string.rep
local C

local pi    = math.pi
local abs   = math.abs
local clamp = math.clamp
local exp   = math.exp
local rad   = math.rad
local sign  = math.sign
local sqrt  = math.sqrt
local tan   = math.tan

local FREECAM_SETTINGS
local TOGGLE_INPUT_PRIORITY = Enum.ContextActionPriority.Low.Value
local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value

local NAV_GAIN = Vector3.new(1, 1, 1)*64
local PAN_GAIN = Vector2.new(0.75, 1)*8
local FOV_GAIN = 300

local PITCH_LIMIT = rad(90)

local VEL_STIFFNESS = 10
local PAN_STIFFNESS = 10
local FOV_STIFFNESS = 10

local Spring = {} do
	Spring.__index = Spring

	function Spring.new(freq, pos)
		local self = setmetatable({}, Spring)
		self.f = freq
		self.p = pos
		self.v = pos*0
		return self
	end

	function Spring:Update(dt, goal)
		local f = self.f*2*pi
		local p0 = self.p
		local v0 = self.v

		local offset = goal - p0
		local decay = exp(-f*dt)

		local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
		local v1 = (f*dt*(offset*f - v0) + v0)*decay

		self.p = p1
		self.v = v1

		return p1
	end

	function Spring:Reset(pos)
		self.p = pos
		self.v = pos*0
	end
end

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local cameraFov = 0

local velSpring = Spring.new(VEL_STIFFNESS, Vector3.new())
local panSpring = Spring.new(PAN_STIFFNESS, Vector2.new())
local fovSpring = Spring.new(FOV_STIFFNESS, 0)

local Input = {} do
	local thumbstickCurve do
		local K_CURVATURE = 2.0
		local K_DEADZONE = 0.15

		local function fCurve(x)
			return (exp(K_CURVATURE*x) - 1)/(exp(K_CURVATURE) - 1)
		end

		local function fDeadzone(x)
			return fCurve((x - K_DEADZONE)/(1 - K_DEADZONE))
		end

		function thumbstickCurve(x)
			return sign(x)*clamp(fDeadzone(abs(x)), 0, 1)
		end
	end

	local gamepad = {
		ButtonX = 0,
		ButtonY = 0,
		DPadDown = 0,
		DPadUp = 0,
		ButtonL2 = 0,
		ButtonR2 = 0,
		Thumbstick1 = Vector2.new(),
		Thumbstick2 = Vector2.new(),
	}

	local keyboard = {
		W = 0,
		A = 0,
		S = 0,
		D = 0,
		E = 0,
		Q = 0,
		U = 0,
		H = 0,
		J = 0,
		K = 0,
		I = 0,
		Y = 0,
		Up = 0,
		Down = 0,
		LeftShift = 0,
		RightShift = 0,
	}

	local mouse = {
		Delta = Vector2.new(),
		MouseWheel = 0,
	}

	local NAV_GAMEPAD_SPEED  = Vector3.new(1, 1, 1)
	local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
	local PAN_MOUSE_SPEED    = Vector2.new(1, 1)*(pi/64)
	local PAN_GAMEPAD_SPEED  = Vector2.new(1, 1)*(pi/8)
	local FOV_WHEEL_SPEED    = 1.0
	local FOV_GAMEPAD_SPEED  = 0.25
	local NAV_ADJ_SPEED      = 0.75
	local NAV_SHIFT_MUL      = 0.25

	local navSpeed = 1

	function Input.Vel(dt)
		navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED*FREECAM_SETTINGS.SpeedMult, 0.01, 4)

		local kGamepad = Vector3.new(
			thumbstickCurve(gamepad.Thumbstick1.X),
			thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
			thumbstickCurve(-gamepad.Thumbstick1.Y)
		)*NAV_GAMEPAD_SPEED*FREECAM_SETTINGS.SpeedMult

		local kKeyboard = Vector3.new(
			keyboard.D - keyboard.A + keyboard.K - keyboard.H,
			keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
			keyboard.S - keyboard.W + keyboard.J - keyboard.U
		)*NAV_KEYBOARD_SPEED*FREECAM_SETTINGS.SpeedMult

		local shift = UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift)

		return (kGamepad + kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
	end

	function Input.Pan(dt)
		local kGamepad = Vector2.new(
			thumbstickCurve(gamepad.Thumbstick2.Y),
			thumbstickCurve(-gamepad.Thumbstick2.X)
		)*PAN_GAMEPAD_SPEED*FREECAM_SETTINGS.TurnMult
		local kMouse = mouse.Delta*PAN_MOUSE_SPEED*FREECAM_SETTINGS.TurnMult
		mouse.Delta = Vector2.new()
		return kGamepad + kMouse
	end

	function Input.Fov(dt)
		local kGamepad = (gamepad.ButtonX - gamepad.ButtonY)*FOV_GAMEPAD_SPEED*FREECAM_SETTINGS.ZoomMult
		local kMouse = mouse.MouseWheel*FOV_WHEEL_SPEED*FREECAM_SETTINGS.ZoomMult
		mouse.MouseWheel = 0
		return kGamepad + kMouse
	end

	do
		local function Keypress(action, state, input)
			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function GpButton(action, state, input)
			gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function MousePan(action, state, input)
			local delta = input.Delta
			mouse.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end

		local function Thumb(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position
			return Enum.ContextActionResult.Sink
		end

		local function Trigger(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position.z
			return Enum.ContextActionResult.Sink
		end

		local function MouseWheel(action, state, input)
			mouse[input.UserInputType.Name] = -input.Position.z
			return Enum.ContextActionResult.Sink
		end

		local function Zero(t)
			for k, v in pairs(t) do
				t[k] = v*0
			end
		end

		function Input.StartCapture()
			CAS:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
				Enum.KeyCode.W, Enum.KeyCode.U,
				Enum.KeyCode.A, Enum.KeyCode.H,
				Enum.KeyCode.S, Enum.KeyCode.J,
				Enum.KeyCode.D, Enum.KeyCode.K,
				Enum.KeyCode.E, Enum.KeyCode.I,
				Enum.KeyCode.Q, Enum.KeyCode.Y,
				Enum.KeyCode.Up, Enum.KeyCode.Down
			)
			CAS:BindActionAtPriority("FreecamMousePan",          MousePan,   false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
			CAS:BindActionAtPriority("FreecamMouseWheel",        MouseWheel, false, INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
			CAS:BindActionAtPriority("FreecamGamepadButton",     GpButton,   false, INPUT_PRIORITY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
			CAS:BindActionAtPriority("FreecamGamepadTrigger",    Trigger,    false, INPUT_PRIORITY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
			CAS:BindActionAtPriority("FreecamGamepadThumbstick", Thumb,      false, INPUT_PRIORITY, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
		end

		function Input.StopCapture()
			navSpeed = 1
			Zero(gamepad)
			Zero(keyboard)
			Zero(mouse)
			CAS:UnbindAction("FreecamKeyboard")
			CAS:UnbindAction("FreecamMousePan")
			CAS:UnbindAction("FreecamMouseWheel")
			CAS:UnbindAction("FreecamGamepadButton")
			CAS:UnbindAction("FreecamGamepadTrigger")
			CAS:UnbindAction("FreecamGamepadThumbstick")
		end
	end
end

local function GetFocusDistance(cameraFrame)
	local znear = 0.1
	local viewport = C.Camera.ViewportSize
	local projy = 2*tan(cameraFov/2)
	local projx = viewport.x/viewport.y*projy
	local fx = cameraFrame.rightVector
	local fy = cameraFrame.upVector
	local fz = cameraFrame.lookVector

	local minVect = Vector3.new()
	local minDist = 512

	for x = 0, 1, 0.5 do
		for y = 0, 1, 0.5 do
			local cx = (x - 0.5)*projx
			local cy = (y - 0.5)*projy
			local offset = fx*cx - fy*cy + fz
			local origin = cameraFrame.p + offset*znear
			local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
			local dist = (hit - origin).magnitude
			if minDist > dist then
				minDist = dist
				minVect = offset.unit
			end
		end
	end

	return fz:Dot(minVect)*minDist
end


local function StepFreecam(dt)
	local vel = velSpring:Update(dt, Input.Vel(dt))
	local pan = panSpring:Update(dt, Input.Pan(dt))
	local fov = fovSpring:Update(dt, Input.Fov(dt))

	local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))

	cameraFov = clamp(cameraFov + fov*FOV_GAIN*(dt/zoomFactor), 1, 120)
	cameraRot = cameraRot + pan*PAN_GAIN*(dt/zoomFactor)
	cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y%(2*pi))

	local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*NAV_GAIN*dt)
	cameraPos = cameraCFrame.p

	C.Camera.CFrame = cameraCFrame
	C.Camera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
	C.Camera.FieldOfView = cameraFov
end

local PlayerState = {} do
	local mouseBehavior
	local mouseIconEnabled
	local cameraType
	local cameraFocus
	local cameraCFrame
	local cameraFieldOfView
	local coreGuis = {}
	local setCores = {}

	function PlayerState.Push()
		if FREECAM_SETTINGS.HideCoreUI then
			for name in pairs(coreGuis) do
				coreGuis[name] = SG:GetCoreGuiEnabled(Enum.CoreGuiType[name])
				SG:SetCoreGuiEnabled(Enum.CoreGuiType[name], false)
			end
			for name in pairs(setCores) do
				setCores[name] = SG:GetCore(name)
				SG:SetCore(name, false)
			end
		end
		if C.PlayerGui then
			for _, gui in pairs(C.PlayerGui:GetChildren()) do
				if gui:IsA("ScreenGui") and gui ~= C.GUI and (FREECAM_SETTINGS.HideCoreUI or gui.Name~="Chat") then
					C.SetPartProperty(gui,"Enabled","Freecam",false)
				end
			end
		end

		cameraFieldOfView = C.Camera.FieldOfView
		C.Camera.FieldOfView = 70

		cameraType = C.Camera.CameraType
		C.Camera.CameraType = Enum.CameraType.Custom

		cameraCFrame = C.Camera.CFrame
		cameraFocus = C.Camera.Focus

		mouseIconEnabled = UIS.MouseIconEnabled
		UIS.MouseIconEnabled = true

		mouseBehavior = UIS.MouseBehavior
		UIS.MouseBehavior = Enum.MouseBehavior.Default
	end

	function PlayerState.Pop()
		for name, isEnabled in pairs(coreGuis) do
			SG:SetCoreGuiEnabled(Enum.CoreGuiType[name], isEnabled)
		end
		for name, isEnabled in pairs(setCores) do
			SG:SetCore(name, isEnabled)
		end
		for _, gui in pairs(C.PlayerGui:GetChildren()) do
			if gui:IsA("ScreenGui") then
				C.ResetPartProperty(gui,"Enabled","Freecam")
			end
		end

		if cameraFieldOfView then
			C.Camera.FieldOfView = cameraFieldOfView
			cameraFieldOfView = nil
		end
		if cameraType then
			C.Camera.CameraType = cameraType
			cameraType = nil
		end
		if cameraCFrame then
			C.Camera.CFrame = cameraCFrame
			cameraCFrame = nil
		end
		if cameraFocus then
			C.Camera.Focus = cameraFocus
			cameraFocus = nil
		end
		if mouseIconEnabled then
			UIS.MouseIconEnabled = mouseIconEnabled
			mouseIconEnabled = nil
		end
		if mouseBehavior then
			UIS.MouseBehavior = mouseBehavior
			mouseBehavior = nil
		end
	end
end

return function(C_new,Settings)
	C = C_new
	return {
		Category = {
			Name = "World",
			Title = "World",
			Image = 15170258619,
			Layout = 4,
		},
		Tab = {
			--[[{
				Title = "Fake Chat",
				Tooltip = "Display two messages in the chat",
				Layout = 1,Type = "NoToggle",
				Shortcut = "Nickname",
				Activate = function(self,newValue)
					local real = self.EnTbl.Real
                    local fake = self.EnTbl.Fake
                    if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
                        fake = string.gsub(fake, "\n", "\r")
                        C.SendGeneralMessage(real..'\r'..fake)
                    elseif TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
                        C.SendGeneralMessage(real..string.sub((" "):rep(155),#real)..fake)
                    else
                        error("Unknown TCS ChatVersion For `Fake Chat`: "..tostring(TCS.ChatVersion))
                    end
				end,
                Events = {},
				Options = {
					{
						Type = Types.Textbox,
						Title = "Real",
						Tooltip = "What you say in the chat",
						Layout = 1,Default = ";admin all",Min=1,Max=100,
						Shortcut="Real",
					},
					{
						Type = Types.Textbox,
						Title = "Fake",
						Tooltip = "What is said a message below your chat",
						Layout = 2,Default = "{Team} You are now on the 'Admins' team.",Min=1,Max=100,
						Shortcut="Fake",
					}
				},
			},--]]
           	{
				Title = "Chat Spy",
				Tooltip = "Puts ALL whispers and team chat messages not visible to you into the chat!",
				Layout = 2,
				Shortcut = "ChatSpy",Default=true,
                AddToChat = function(self,theirPlr)
                    local DefaultChatSystemChatEvents = RS:WaitForChild("DefaultChatSystemChatEvents",10)
                    local Config = {public = false}
                    if not DefaultChatSystemChatEvents then
                        return
                    end
                    local getmsg = DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering")
                    table.insert(self.Functs,theirPlr.Chatted:Connect(function(msg)
                        msg = msg:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ') -- CLIP THE MESSAGE (important!)
                        --[[
						local setChannel,moveon,hidden = nil,false,true
						local conn = getmsg.OnClientEvent:Connect(function(packet,channel)
							if (packet.Message==msg:sub(#msg-#packet.Message+1) and (channel=="All") and packet.SpeakerUserId==theirPlr.UserId)
								or (channel=="Team" and Config.public==false and PS[packet.FromSpeaker].Team==C.plr.Team) then
								hidden = false
							end
                            setChannel,moveon = channel or packet.OriginalChannel, true
						end)
                        task.delay(1,function()
                            moveon=true
                        end)
                        while not moveon do
                            RunS.RenderStepped:Wait()
                        end
						conn:Disconnect()--]]
                        local clippedMsg = msg:gsub("/w %a+ ",""):gsub("/t ",""):gsub("/team ", "")
                        local fullmsg = theirPlr.UserId .. '\r' .. #clippedMsg
                        task.wait(self.EnTbl.HiddenTimeout)
                        local foundIndex = table.find(self.Messages,fullmsg)
						if foundIndex == nil then -- Not appearing, so hidden!
							C.CreateSysMessage("["..C.GetPlayerName(theirPlr).."]: "..msg,Color3.fromRGB(0,175),`{"Chat"} Spy`)
                            if self.EnTbl.Echo then
                                C.SendGeneralMessage("["..theirPlr.DisplayName.."]: "..msg)
                            end
                        else-- Found, so delete it!
                            table.remove(self.Messages, foundIndex)
						end
                    end))
                end,
                Messages = {},
				Activate = function(self,newValue)
                    if TCS.ChatVersion ~= Enum.ChatVersion.LegacyChatService then
                        C.CreateSysMessage(`[Chat Spy]: Chat Spy doesn't support the new roblox chat version: {Enum.ChatVersion.TextChatService.Name}`)
                        return
                    end
                    if not newValue then return end
					for num, theirPlr in ipairs(PS:GetPlayers()) do
                        if theirPlr ~= C.plr then
                            self:AddToChat(theirPlr)
                        end
                    end
                    -- Message detection
                    local newMessageEvent = C.StringWait(RS,"DefaultChatSystemChatEvents.OnNewMessage")
                    table.insert(self.Functs, newMessageEvent.OnClientEvent:Connect(function(data, channel)
                        local Message = data.SpeakerUserId .. '\r' .. data.MessageLength
                        local Index = #self.Messages + 1
                        table.insert(self.Messages, Message)
                        task.delay(10, C.TblRemove, self.Messages, Message)
                    end))
				end,
                Events = {
                    OthersPlayerAdded=function(self,theirPlr,firstRun)
                        if not self.RealEnabled or firstRun then return end
						self:AddToChat(theirPlr)
					end,
                },Functs={},
				Options = {
                    {
						Type = Types.Toggle,
						Title = "Echo",
						Tooltip = "What is said privately in the chat you repeat (using the chat function)",
						Layout = 2,Default = false,
						Shortcut="Echo",
					},
                    {
                        Type = Types.Slider,
                        Title = "Timeout",
                        Tooltip = "How long to wait before a message is revealed as hidden\nAdjust this to be higher if messages that are not hidden are displayed as such",
                        Layout = 2,Default = 1,
                        Min = 0, Max=3, Digits=1,
                        Shortcut="HiddenTimeout",
                    },
				},
			},--]]
			FireElements={
				Title = "Fire",Type="NoToggle",
				Tooltip = "Fires TouchInterest, ProximityPrompt, ClickDetector",
				Layout = 3,NoStudio=true,
				Shortcut = "FireElements",Threads={},
				CheckForBlacklist = function(self,instance)
					if game.GameId == 2733031763 and instance.Parent.Name == "Floor" then
						return true
					end
					return false
				end,
				GetSearchInstance = function(self)
					if game.GameId == 2733031763 then
						return C.StringWait(workspace,"Bridge")
					end
					return workspace
				end,
				TouchTransmitter = function(self,instance)
					local Parent = instance.Parent
					if C.hrp then
						C.firetouchinterest(C.hrp,Parent)
					end
				end,
				ClickDetector = function(self,instance)
					C.fireclickdetector(instance,C.Randomizer:NextNumber(2,3),"MouseClick")
				end,
				ProximityPrompt = function(self,instance)
					C.fireproximityprompt(instance,1,true)
				end,
				Activate = function(self,newValue)
					local EnTbl = self.EnTbl
                    for num, instance in ipairs(self:GetSearchInstance():GetDescendants()) do
						for name, en in pairs(EnTbl) do
							if instance:IsA(name) and en and not self:CheckForBlacklist(instance) then
								self[name](self,instance)
							end
						end
						if num%100 == 0 then
							RunS.RenderStepped:Wait()
						end
					end
				end,
				Options = {
                    {
						Type = Types.Toggle,
						Title = "TouchInterest",
						Tooltip = "Fire TouchInterests with your character's rootpart",
						Layout = 1,Default = true,
						Shortcut="TouchTransmitter",
					},
					{
						Type = Types.Toggle,
						Title = "ProximityPrompt",
						Tooltip = "Fires all ProximityPrompts exactly once",
						Layout = 2,Default = false,
						Shortcut="ProximityPrompt",
					},
					{
						Type = Types.Toggle,
						Title = "ClickDetector",
						Tooltip = "Clicks on all ClickDetectors at the same time",
						Layout = 3,Default = false,
						Shortcut="ClickDetector",
					}
				},
			},
			{
				Title = "Chat Edit",
				Tooltip = "Chat modifications are listed here",
				Layout = 3,
				Shortcut = "ChatEdit",
				DefaultInput = `ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,:;'"!?-_/+*=()%@#$&^~`,
				FontTranslations = {
					["Fancy Font 1"] = {
						Output = {`卂`,`乃`,`匚`,`D`,`乇`,`千`,`G`,`卄`,`丨`,`ﾌ`,`Ҝ`,`ㄥ`,`爪`,`几`,`ㄖ`,`卩`,`Ɋ`,`尺`,`丂`,`ㄒ`,`ㄩ`,`ᐯ`,`山`,`乂`,`ㄚ`,`乙`,`卂`,`乃`,`匚`,`D`,`乇`,`千`,`G`,`卄`,`丨`,`ﾌ`,`Ҝ`,`ㄥ`,`爪`,`几`,`ㄖ`,`卩`,`Ɋ`,`尺`,`丂`,`ㄒ`,`ㄩ`,`ᐯ`,`山`,`乂`,`ㄚ`,`乙`,`0`,`1`,`2`,`3`,`4`,`5`,`6`,`7`,`8`,`9`,`.`,`,`,`:`,`;`,`'`,`"`,`!`,`?`,`-`,`_`,`/`,`+`,`*`,`=`,`(`,`)`,`%`,`@`,`#`,`$`,`&`,`^`,`~`}},
					["Fancy Font 2"] = {
						Output = {"ค", "๒", "ς", "๔", "є", "Ŧ", "ﻮ", "ђ", "เ", "ן", "к", "ɭ", "๓", "ภ", "๏", "ק", "ợ", "г", "ร", "t", "ย", "ש", "ฬ", "א", "ץ", "Z", "ค", "๒", "ς", "๔", "є", "Ŧ", "ﻮ", "ђ", "เ", "ן", "к", "ɭ", "๓", "ภ", "๏", "ק", "ợ", "г", "ร", "t", "ย", "ש", "ฬ", "א", "ץ", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", ",", ":", ";", "'", "\"", "!", "?", "-", "_", "/", "+", "*", "=", "(", ")", "%", "@", "#", "$", "&", "^", "~"}
					},
					["Bubble Font 1"] = {
						Output = { "🅐", "🅑", "🅒", "🅓", "🅔", "🅕", "🅖", "🅗", "🅘", "🅙", "🅚", "🅛", "🅜", "🅝", "🅞", "🅟", "🅠", "🅡", "🅢", "🅣", "🅤", "🅥", "🅦", "🅧", "🅨", "🅩", "🅐", "🅑", "🅒", "🅓", "🅔", "🅕", "🅖", "🅗", "🅘", "🅙", "🅚", "🅛", "🅜", "🅝", "🅞", "🅟", "🅠", "🅡", "🅢", "🅣", "🅤", "🅥", "🅦", "🅧", "🅨", "🅩", "⓿", "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒", ".", ",", ":", ";", "'", '"', "!", "?", "-", "_", "/", "+", "*", "=", "(", ")", "%", "@", "#", "$", "&", "^", "~" }
					},
					["Bubble Font 2"] = {
						Output = { "🅰", "🅱", "🅲", "🅳", "🅴", "🅵", "🅶", "🅷", "🅸", "🅹", "🅺", "🅻", "🅼", "🅽", "🅾", "🅿", "🆀", "🆁", "🆂", "🆃", "🆄", "🆅", "🆆", "🆇", "🆈", "🆉", "🅰", "🅱", "🅲", "🅳", "🅴", "🅵", "🅶", "🅷", "🅸", "🅹", "🅺", "🅻", "🅼", "🅽", "🅾", "🅿", "🆀", "🆁", "🆂", "🆃", "🆄", "🆅", "🆆", "🆇", "🆈", "🆉", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", ",", ":", ";", "'", '"', "!", "?", "-", "_", "/", "+", "*", "=", "(", ")", "%", "@", "#", "$", "&", "^", "~"  }
					},
					["Bubble Font 3"] = {
						Output = {
							"🇦", "🇧", "🇨", "🇩", "🇪", "🇫", "🇬", "🇭", "🇮", "🇯", "🇰", "🇱", "🇲", "🇳", "🇴", "🇵", "🇶", "🇷", "🇸", "🇹", "🇺", "🇻", "🇼", "🇽", "🇾", "🇿",
							"🇦", "🇧", "🇨", "🇩", "🇪", "🇫", "🇬", "🇭", "🇮", "🇯", "🇰", "🇱", "🇲", "🇳", "🇴", "🇵", "🇶", "🇷", "🇸", "🇹", "🇺", "🇻", "🇼", "🇽", "🇾", "🇿",
							"⓪", "①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨",
							".", ",", ":", ";", "'", '"', "!", "?", "-", "_", "/", "+", "*", "=", "(", ")", "%", "@", "#", "$", "&", "^", "~"
						},
						SeperationCharacter = " ",
					},
					["Small Font 1"] = {
						Output = {"Ａ", "Ｂ", "Ｃ", "Ｄ", "Ｅ", "Ｆ", "Ｇ", "Ｈ", "Ｉ", "Ｊ", "Ｋ", "Ｌ", "Ｍ", "Ｎ", "Ｏ", "Ｐ", "Ｑ", "Ｒ", "Ｓ", "Ｔ", "Ｕ", "Ｖ", "Ｗ", "Ｘ", "Ｙ", "Ｚ", "ａｂ", "ｃ", "ｄ", "ｅ", "ｆ", "ｇ", "ｈ", "ｉ", "ｊ", "ｋ", "ｌ", "ｍ", "ｎ", "ｏ", "ｐ", "ｑ", "ｒ", "ｓ", "ｔ", "ｕ", "ｖ", "ｗ", "ｘ", "ｙ", "ｚ", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９", ".", ",", ":", ";", "'", '"', "!", "?", "-", "_", "/", "+", "*", "=", "(", ")", "%", "@", "#", "$", "&", "^", "~"}
					},
					["Accented Font 1"] = {
						Output = { "Á", "B", "Ć", "D", "É", "F", "Ǵ", "H", "í", "J", "Ḱ", "Ĺ", "Ḿ", "Ń", "Ő", "Ṕ", "Q", "Ŕ", "ś", "T", "Ű", "V", "Ẃ", "X", "Ӳ", "Ź", "á", "b", "ć", "d", "é", "f", "ǵ", "h", "í", "j", "ḱ", "ĺ", "ḿ", "ń", "ő", "ṕ", "q", "ŕ", "ś", "t", "ú", "v", "ẃ", "x", "ӳ", "ź", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", ",", ":", ";", "'", '"', "!", "?", "-", "_", "/", "+", "*", "=", "(", ")", "%", "@", "#", "$", "&", "^", "~" }
					},
					["Accented Font 2"] = {
						Output = { "Ä", "ß", "Ç", "Ð", "È", "£", "G", "H", "Ì", "J", "K", "L", "M", "ñ", "Ö", "þ", "Q", "R", "§", "†", "Ú", "V", "W", "×", "¥", "Z", "å", "ß", "¢", "Ð", "ê", "£", "g", "h", "ï", "j", "k", "l", "m", "ñ", "ð", "þ", "q", "r", "§", "†", "µ", "v", "w", "x", "¥", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", ",", ":", ";", "'", '"', "!", "?", "-", "_", "/", "+", "*", "=", "(", ")", "%", "@", "#", "$", "&", "^", "~" }
					}
				},
				ParseMultiLine = function(message,inBetween)
					local newMessage
					local splitArray = strSplit(strgsub(message,"\n", "\\n"),"\\n")
                    inBetween = inBetween or "{System}: "
					for num, curMessage in ipairs(splitArray) do
						if num == 1 then
							newMessage = curMessage
							continue
						end
						curMessage = inBetween .. curMessage
						--if rawget(C,"ChatVersion") == "TextChatService" and false then
						--	newMessage ..= '\n' .. curMessage
						--if rawget(C,"ChatVersion") == "LegacyChatService" then
						--  newMessage ..= rawget(string,"sub")(rawget(string,"rep")(" ",155),#rawget(splitArray,num-1))..curMessage
						--end
						newMessage ..= strSub(strRep("_",73),#rawget(splitArray,num-1)).. strRep(" ", 44) .. curMessage
                        if num > 1 then
                            break
                        end
                    end
					return strSub(newMessage, 1, CHAT_MAXLENGTH)
				end,
				Activate = function(self,newValue)
					local find, sub, isa = string.find, string.sub, workspace.IsA
					local gsub, tskSpawn = string.gsub, task.spawn
                    local CurrentFont = AllowFonts and self.EnTbl.ChosenFont or "Off"
					local TranslationTbl = self.FontTranslations[CurrentFont]
					local BetweenMultiLine = self.EnTbl.MultiLine
					assert(TranslationTbl or CurrentFont == "Off", `Chat Bypass Translation Doesn't Contain Proper Font: {self.EnTbl.ChosenFont}`)
					local gmatch = string.gmatch
					local Input, Output, SeperationCharacter
					if TranslationTbl then
						Input, Output = TranslationTbl.Input or self.DefaultInput, TranslationTbl.Output
						SeperationCharacter = TranslationTbl.SeperationCharacter or ""
					end
					local MultiLineFunction = self.ParseMultiLine
					C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,message,channel)
                        if tostring(self) == "SayMessageRequest" or isa(self,"TextChannel") then
							if BetweenMultiLine then
								message = MultiLineFunction(message, BetweenMultiLine)--gsub(message,"\\n","\n" .. MultiLine)
							end
							if TranslationTbl then
								local newMessage = ""
								local index,total = 0, #message
								for character in gmatch(message,".") do
									index+=1
									local foundIndex = find(Input,character,1,true)
									local newCharacter = foundIndex and rawget(Output,foundIndex)
									if newCharacter and newCharacter~=character then
										newMessage ..= newCharacter
										if total ~= index then
											newMessage ..= SeperationCharacter
										end
									else
										newMessage ..= character
									end
								end
								message = newMessage
							end
							return "Override", {self, message, channel}
						end
                    end,{"fireserver","sendasync"})
				end,
				Options = {
					AllowFonts and {
						Type = Types.Dropdown,
						Selections = {"Off","Fancy Font 1", "Fancy Font 2","Bubble Font 1","Bubble Font 2","Bubble Font 3","Small Font 1","Accented Font 1","Accented Font 2"},
						Title = "Font Bypass",
						Tooltip = "Replaces your text with fancy custom font, which bypasses filter!\nFonts are named by ChatGPT of course",
						Layout = 1,Default = 2,
						Shortcut="ChosenFont",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Textbox,
						Title = "Multi Line",
						Tooltip = `Whenever a \n is present, it is automatically replaced with a newline followed by this text! (This can be left blank)`,
						Layout = 1,Default = "{System}: ",Min=0,Max=50,
						Shortcut="MultiLine",
						Activate = C.ReloadHack,
					},
				},
			},
			{
				Title = "Freecam",
				Tooltip = "Allows your camera to fly around",
				Layout = 4,
				Shortcut = "Freecam",Threads={},
				RunOnDestroy = function(self)
					self:Activate(false)
				end,
				Activate = function(self,newValue)
					FREECAM_SETTINGS = self.EnTbl
					if newValue then
						self:Activate(false) -- Disable it to re-enable!
						task.wait()
						local cameraCFrame = C.Camera.CFrame
						cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
						cameraPos = cameraCFrame.Position
						cameraFov = C.Camera.FieldOfView

						velSpring:Reset(Vector3.new())
						panSpring:Reset(Vector2.new())
						fovSpring:Reset(0)


						PlayerState.Push()
						RunS:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
						Input.StartCapture()
					else
						Input.StopCapture()
						RunS:UnbindFromRenderStep("Freecam")
						PlayerState.Pop()
					end
				end,
				Options = {
					{
						Type = Types.Slider,
						Title = "Speed Mult",
						Tooltip = "How fast you move",
						Layout = 1,Default = 1,
						Min = 0, Max=5, Digits=1,
						Shortcut="SpeedMult",
					},
                    {
						Type = Types.Slider,
						Title = "Turn Mult",
						Tooltip = "How fast you turn",
						Layout = 2,Default = 1,
						Min = 0, Max=5, Digits=1,
						Shortcut="TurnMult",
					},
					{
						Type = Types.Slider,
						Title = "Zoom Mult",
						Tooltip = "How fast you zoom in/out",
						Layout = 3,Default = 1,
						Min = 0, Max=5, Digits=1,
						Shortcut="ZoomMult",
					},
					{
						Type = Types.Toggle,
						Title = "Hide Core UI",
						Tooltip = "Whether or not Core UI is hidden or not",
						Layout = 4,Default = true,
						Shortcut="HideCoreUI",
						Activate = C.ReloadHack,
					},
				},
			},
            {
				Title = "Invisi Cam",
				Tooltip = "Allows you to zoom through solid objects\nWorks in any zoomable game",
				Layout = 5,
				Shortcut = "InvisiCam",
                Activate = function(self, newValue)
                    C.SetPartProperty(C.plr, "DevCameraOcclusionMode", self.Shortcut, newValue and Enum.DevCameraOcclusionMode.Invisicam or C)
                end,
            },
		}
	}
end]=],
    ["Modules/AntiCheat"] = [=[local DS = game:GetService("Debris")
local RunService = game:GetService("RunService")
local SC = game:GetService("ScriptContext")
local LS = game:GetService("LogService")
local RS = game:GetService("ReplicatedStorage")
local NC = game:GetService("NetworkClient")
local TeleportService = game:GetService("TeleportService")

local function Static(C,Settings)
    local wait4Child = game.WaitForChild
    local function yieldForeverFunct(...)
        C.DebugMessage("AntiCheat",debug.traceback('AntiCheat Disabled Successfully'))
        wait4Child(game,"SuckMyPp",math.huge)
        return true
    end
    return yieldForeverFunct
end
local function ShouldBlock(name)
	local sc = getcallingscript()
	return sc and not sc.Parent and not checkcaller() and name ~= nil
end
-- https://apis.roblox.com/universes/v1/places/2961583129/universe
return function(C,Settings)
    local tskSpawn, strFind = task.spawn, string.find
    local yieldForeverFunct = Static(C,Settings)
    local CheckIfValid
    -- Here's where the anti cheat stuff is done
    local AntiCheat = {
        {
            Run = function(self)
                CheckIfValid = function()
                    local traceback = debug.traceback()
                    if (strFind(traceback, "Anti") and not strFind(traceback, "function __index")) then
                        return true
                    end
                    return false
                end
                local Old
                Old = hookfunction(C.getrenv().task.spawn, function(funct,...)
                    if CheckIfValid() then
                        return yieldForeverFunct()
                    end
                    return Old(funct,...)
                end)
                local Old2
                Old2 = hookfunction(C.getrenv().pcall, function(funct,...)
                    if CheckIfValid() then
                        return yieldForeverFunct()
                    end
                    return Old2(funct,...)
                end)
                local Old3
                Old3 = hookfunction(C.getrenv().xpcall, function(funct,...)
                    if CheckIfValid() then
                        return yieldForeverFunct()
                    end
                    return Old3(funct,...)
                end)
                --[[local Old2 = rawget(C.getrenv(), "xpcall")
                rawset(C.getrenv(),"xpcall", function(funct, ...)
                    tskSpawn(C.DebugMessage,`AntiCheat`,`Called from context: {debug.traceback()}`)
                    if funct == C.getrenv().xpcall then
                        return yieldForeverFunct()
                    end
                    return Old2(funct,...)
                end)--]]
                return true -- indicate that the anti cheat is successful
            end,
            KeepGoing = false, RunOnce = true,
            GameIds = {1069466626,495693931},
            PlaceIds = {},
        },
        {
            Run = function(self)
                local Old
                Old = C.hookfunction(getrenv().game:GetService("ContentProvider").PreloadAsync, function(funct,...)
                    warn("Preloaded from",C.getcallingscript())
                    if not C.checkcaller() then
                        return yieldForeverFunct()
                    end
                    return Old(funct,...)
                end)
                return true -- indicate that the anti cheat is successful
            end,
            KeepGoing = false, RunOnce = true,
            GameIds = {},
            PlaceIds = {352947107},
        },
        {
            Run = function(self)
                local localScript1 = C.StringWait(C.plr,"PlayerScripts.LocalScript",30)
				local localScript2 = C.StringWait(C.plr,"PlayerScripts.LocalScript2",30)
				if not localScript1 or not localScript2 then
					return
				end
				for num, connection in ipairs(C.getconnections(localScript1.Changed)) do
					connection:Disconnect()
				end
				local oldParent = localScript1.Parent
				localScript1.Parent = nil
				localScript2.Parent = nil
				localScript1.Disabled = true
				DS:AddItem(localScript1,3)
				DS:AddItem(localScript2,3)
				localScript1 = Instance.new("LocalScript")
				localScript1.Parent = oldParent
				localScript2 = Instance.new("LocalScript")
				localScript2.Name = "LocalScript2"
				localScript2.Parent = oldParent

				Instance.new("Folder",localScript1).Name = "FakeDummy"
				Instance.new("Folder",localScript2).Name = "FakeDummy"
            end,
            KeepGoing = false, RunOnce = true,
            GameIds = {703124385},
            PlaceIds = {},
        },
        {
            Run = function(self)
                for num, data in ipairs(C.getconnections(SC.Error)) do
                    if data.LuaConnection then
                        data:Disconnect()
                        C.DebugMessage("AntiCheat",`Disabled SC.Error {num}`)
                    end
                end
                for num, data in ipairs(C.getconnections(LS.MessageOut)) do
                    if data.LuaConnection then
                        data:Disconnect()
                        C.DebugMessage("AntiCheat",`Disabled LS.MessageOut {num}`)
                    end
                end
            end,
            KeepGoing = true, RunOnce = true,
            GameIds = {3150475059},
            PlaceIds = {},
        },
        {
            Run = function(self)
                --[[local NewMessage = C.StringWait(RS,"Events.AntiCheatRemotes.NewMessage")
                C.HookNamecall("AntiCheat5",{"fireserver","invokeserver"},function(theirScript,method,self,arg1,...)
                    if true then
                        return
                    end
                    if (not theirScript.Parent or theirScript.Name == "BAC_") and (typeof(arg1) ~= "table" and (arg1[1]~=arg1)) and arg1 ~= 0 then--(arg1[1]~=arg1)) then --and arg1 ~= 0 then
                        if typeof(arg1) == "table" then
                            --C.DebugMessage("AntiCheat",`CANCELLING ON: {theirScript:GetFullName()} because it tried sending method {self.Name} with table arg1 index 1={tostring(arg1[1])}`)
                        else
                            --C.DebugMessage("AntiCheat",`CANCELLING ON: {theirScript:GetFullName()} because it tried sending method {self.Name} with arg1 {tostring(arg1)}`)
                        end
                        return "Cancel"
                    elseif theirScript.Name == "BAC_" then
                        --for num, arg in ipairs(table.pack(arg1,...)) do
                        --    if arg~=0 then
                                --print("Pass",self,arg)
                         --   end
                        --end
                        
                        
                        if arg1 == 0 then
                            return -- Run it
                        else
                            local argCount = (arg1~=nil and 1 or 0) + #({...})
                            print("CANCELLING TWO WITH ",method,self,"argcount:",argCount,"arg1:",arg1[1])
                            
                            task.defer(NewMessage.FireServer,NewMessage,"A-1","RSSERV MTHD")
                        end
                        return "Cancel"
                    end
                end)--]]

                C.HookMethod(C.getrenv().task.spawn,"AntiCheat5", C.newcclosure(function(theirScript,method,funct,...)
                    local Args = table.pack(...)
                    if not theirScript.Parent or theirScript.Name == "BAC_" then
                        task.spawn(C.DebugMessage,"AntiCheat",`TASK SPAWN YIELD ON SCR: {theirScript:GetFullName()}!`)
                        return "Yield"
                    end
                end))
                C.HookMethod("__namecall","AntiCheat5",C.newcclosure(function(theirScript,method,self,...)
                    local MySelf = tostring(self)
                    if (MySelf == "RemoteEvent" or MySelf == "NewMessage") then
                        task.spawn(C.DebugMessage,"AntiCheat",`YIELDING NAMECALL FOR SCR: {theirScript:GetFullName()} ATTEMPT: {self:GetFullName()}`)
                        return "Yield"
                    end
                end),{"fireserver"})
                C.HookMethod("__index","AntiCheat5",C.newcclosure(function(theirScript,index,self,...)
                    local MySelf = tostring(self)
                    if (MySelf == "RemoteEvent" or MySelf == "NewMessage") then
                        task.spawn(C.DebugMessage,"AntiCheat",`YIELDING INDEXCALL: {theirScript:GetFullName()} ATTEMPT: {self:GetFullName()} INDEX: {index}`)
                        return "Yield"
                    end
                end),{"fireserver"})
                -- DISABLE TELEPORT
                --[[C.AddGlobalThread(task.spawn(function()
                    while true do
                        local success, result = pcall(TeleportService.Teleport,TeleportService,0,C.plr)
                        if result ~= "Cannot teleport to invalid place id. Aborting teleport." then
                            warn("TELEPORTING NOTICED. CANCEL ATTEMPT!")
                            TeleportService:TeleportCancel()
                        end
                        RunService.RenderStepped:Wait()
                    end
                end))--]]
            end,
            KeepGoing = false, RunOnce = false,
            GameIds = {1160789089},PlaceIds={}
        },
        {
            Run = function(self)
                --[[local Old
                Old = hookfunction(getrenv().pcall, C.newcclosure(function(self,...)
                    local Returns = {Old(self,...)}
                    print(self,debug.traceback(),Returns)
                    return table.unpack(Returns)
                end))

                local Old = getrenv().pcall
                getrenv().pcall = C.newcclosure(function(self,...)
                    local Returns = {Old(self,...)}
                    print(self,...,Returns)
                    return table.unpack(Returns)
                end)
                local Old
                Old = hookfunction(debug.info, C.newcclosure(function(self,...)
                    local Returns = {Old(self,...)}
                    print("info",self,...,Returns)
                    return table.unpack(Returns)
                end))
                local Old2
                Old2 = hookfunction(debug.traceback, C.newcclosure(function(self,...)
                    local Returns = {Old2(self,...)}
                    print("traceback",self,...,Returns)
                    return table.unpack(Returns)
                end))--]]
                local Old2
                Old2 = hookfunction(getrenv().pcall, function(...)
                    if ShouldBlock(pcall) then
                        C.DebugMessage("AntiCheat","Killed a pcall script: "..tostring(getcallingscript()))
                        while true do
                            task.wait(9999999999)
                        end
                        return
                    end
                    return Old2(...)
                end)

                local Old3
                Old3 = hookfunction(getrenv().ipairs,function(...)
                    if ShouldBlock(ipairs) then
                        C.DebugMessage("AntiCheat","Killed a ipairs script: "..tostring(getcallingscript()))
                        while true do
                            task.wait(9999999999)
                        end
                        return
                    end
                    return Old3(...)
                end)

                local Old4
                Old4 = hookmetamethod(game,"__namecall",function(...)
                    if ShouldBlock(game) then
                        C.DebugMessage("AntiCheat","Killed a __namecall script: "..tostring(getcallingscript()))
                        while true do
                            task.wait(9999999999)
                        end
                        return
                    end
                    return Old4(...)
                end)
            end,
            KeepGoing = false, RunOnce = true,
            GameIds = {3734304510},PlaceIds={},
        },
        {
            Run = function(self)
                local DataService = require(game:GetService("ReplicatedStorage").Modules.DataService)
                local remotefunc
                local hashtable = getupvalue(getupvalue(DataService.InvokeServer, 5),3)
                local remoteNames, remoteObjects = {}, {}
                for i,v in pairs(getreg()) do
                    if type(v) == "function" and getinfo(v).name == "remoteAdded" then
                        remotefunc = v
                    end
                end
                for i,v in pairs(getupvalue(getupvalue(remotefunc,2),1)) do
                    remoteNames[hashtable[i]] = v:gsub("F_", "") --some remotes start with F_ cuz gay
                    remoteObjects[v:gsub("F_","")] = hashtable[i]
                end
                C.RemoteNames = remoteNames
                C.RemoteObjects = remoteObjects
            end,
            KeepGoing = false, RunOnce = false, IgnoreKick = true,
            GameIds = {88070565},PlaceIds={},
        },
    }
    local GameDisconnected = not NC:FindFirstChildWhichIsA("ClientReplicator")
    for num, cheatTbl in ipairs(AntiCheat) do
        if table.find(cheatTbl.GameIds,game.GameId) or table.find(cheatTbl.PlaceIds,game.PlaceId) then
            if GameDisconnected and not cheatTbl.IgnoreKick then
                C.DebugMessage("AntiCheat",`AntiCheat Method {num} Not Running Because Of Game Disconnect!`)
                continue
            end
            if not cheatTbl.RunOnce or not C.getgenv()["AntiCheat"..num] then
                C.DebugMessage("AntiCheat",`Method {num} Activated`)
                cheatTbl.Run(cheatTbl)
                C.getgenv()["AntiCheat"..num] = true
            end
            if not cheatTbl.KeepGoing then
                break
            end
        end
    end
end]=],
    ["Modules/Binds"] = [[local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")
local TS = game:GetService("TweenService")
return function(C,Settings)
	--Binds idk
	function C.BindAction(name,funct,...)
		--name ..= C.SaveIndex
		C.BindedActions[name] = true
		if C.isStudio or true then
			CAS:BindActionAtPriority(name,funct,false,696969,...)
		else
			CAS:BindCoreAction(name,funct,false,...)
		end
	end
	function C.UnbindAction(name)
		--name ..= C.SaveIndex
		C.BindedActions[name] = nil
		if C.isStudio or true then
			CAS:UnbindAction(name)
		else
			CAS:UnbindCoreAction(name)
		end
	end
	local blacklistedCodes = {Enum.KeyCode.LeftControl,Enum.KeyCode.RightControl,Enum.KeyCode.LeftAlt,Enum.KeyCode.RightAlt,Enum.KeyCode.LeftShift,Enum.KeyCode.RightShift}
	--Register Keybinds
	function C.AddKeybind(key:string,tblHack:table)
		C.RemoveKeybind(tblHack)
		local function keyPressBind(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.Begin and not C.IsBinding then
				for num, keyCode in ipairs(blacklistedCodes) do
					if UIS:IsKeyDown(keyCode) then
						return -- cancel request
					end
				end
				tblHack:SetValue(not tblHack.Enabled)
			end
		end
		local name = "hack"..key.Name
		C.BindAction(name,keyPressBind,key)
		C.keybinds[tblHack] = {KeyCode = key, Name = name}
		C.enHacks[tblHack.Parent.Category.Name][tblHack.Shortcut].Keybind = key.Name
	end
	function C.RemoveKeybind(tblHack:table)
		local data = C.keybinds[tblHack]
		if data then
			C.UnbindAction(data.Name)
			C.keybinds[tblHack] = nil
			C.enHacks[tblHack.Parent.Category.Name][tblHack.Shortcut].Keybind = nil
		end
	end

	--Set Binds for UI
	local eventsAllowed={
		"MyCharAdded","CharAdded","OthersCharAdded",
		"MyPlayerAdded","PlayerAdded","OthersPlayerAdded",
		"MyCharRemoved","CharRemoved","OthersCharRemoved",
		"MySeatAdded","SeatAdded","OthersSeatAdded",
		"MySeatRemoved","SeatRemoved","OthersSeatRemoved",
		"RbxErrorPrompt",
		"IslandAdded", "DockAdded","ShipAdded","PlaneAdded",
		"MyTeamAdded","TeamAdded","OthersTeamAdded",
		"MapAdded","MapRemoved","GameStatus",
		"MessageBoxAdded",

        "MyBeastAdded", "BeastAdded", "OthersBeastAdded",
        "MyBeastHammerAdded", "BeastHammerAdded", "OthersBeastHammerAdded",
        "MyBeastHammerRemoved","BeastHammerRemoved","OthersBeastHammerRemoved",
        "MySurvivorAdded", "SurvivorAdded", "OthersSurvivorAdded",
        "MySurvivorRemoved", "SurvivorRemoved", "OthersSurvivorRemoved",
        "MyRagdollAdded", "RagdollAdded", "OthersRagdollAdded",
        "MyRagdollRemoved", "RagdollRemoved", "OthersRagdollRemoved",
        "MyBeastRopeAdded", "BeastRopeAdded", "OthersRopeAdded",
        "MyBeastRopeRemoved", "BeastRopeRemoved", "OthersRopeRemoved",
        "MyCapturedAdded", "CapturedAdded", "OthersCapturedAdded",
        "MyCapturedRemoved", "CapturedRemoved", "OthersCapturedRemoved",
        "MySurvivorRescued", "SurvivorRescued", "OthersSurvivorRescued",
        "GameAdded","GameRemoved",--Don't laugh!
        "NewFreezingPod"
	}
	function C.BindEvents(hackTbl)
		for name, funct in pairs(hackTbl.Events or {}) do
			if not table.find(eventsAllowed,name) then
                warn(`[C.BindEvents]: {name} is not a valid event!`)
            end
			C.events[name] = C.events[name] or {}
			C.events[name][hackTbl] = funct
		end
	end

	--Open HUD visibility
	C.UI.HUDEn = false
	function C.SetHUDVis(enabled,instant)
		C.UI.HUDEn = enabled
		C.UI.MainHUD.Visible = enabled
		C.UI.MainHUD.Active = enabled
		C.UI.MainHUD.Interactable = enabled
        C.UI.Modal.Visible = enabled
        C.UI.Modal.Modal = enabled
		TS:Create(C.UI.HUDBackgroundFade,TweenInfo.new(.3),{BackgroundTransparency=(enabled and 0.3 or 1)}):Play()
	end
	local function ToggleOpenHUDKeyPress(actionName,inputState)
		if inputState == Enum.UserInputState.Begin then
			C.SetHUDVis(not C.UI.HUDEn)
		end
	end
	C.BindAction("hackopen",ToggleOpenHUDKeyPress,Enum.KeyCode.RightShift)
	C.ButtonClick(C.UI.VisibilityButton,function()
		C.SetHUDVis(not C.UI.HUDEn)
	end)
	C.SetHUDVis(false,true)

	--Save keypress
	C.AddGlobalConnection(UIS.InputBegan:Connect(function(inputObject,gameProcessed)
		if gameProcessed then return end
		if inputObject.KeyCode == Enum.KeyCode.S and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			C:SaveProfile()
		elseif inputObject.KeyCode == Enum.KeyCode.Comma and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			C.ToggleServersVisiblity()
		end
	end))

	--Clear UI connection
	local function CheckDeleteButton(actionName,inputState)
		if inputState == Enum.UserInputState.Begin
			and (UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift)) then
			C:Destroy()
		end
	end
	C.BindAction("hackdelete",CheckDeleteButton,Enum.KeyCode.Delete)
end
]],
    ["Modules/CommandCore"] = [=[local HttpService = game:GetService("HttpService")
local PS = game:GetService("Players")
local TCS = game:GetService("TextChatService")
local RunS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local GS = game:GetService("GuiService")
local CS = game:GetService("Chat")
local OverrideChatGames = {
    66654135 -- MM2
}
return function(C,Settings)
    C.savedCommands = C.getgenv().lastCommands
    if not C.savedCommands then
        C.savedCommands = {}
        C.getgenv().lastCommands = C.savedCommands
    end
    function C.RunCommand(inputMsg,shouldSave,noRefresh,canYield)
        if shouldSave then
            table.insert(C.savedCommands,1,inputMsg)
            if #C.savedCommands > 10 then
                table.remove(C.savedCommands,#C.savedCommands)
            end
        end

        local args = inputMsg:sub(2):split(" ")
        local inputCommand = args[1]
        table.remove(args,1)
        for index = 1, 3, 1 do
            args[index] = args[index] or "" -- leave them be empty so it doesn't confuse the game!
        end
        args.OrgArgs = table.clone(args)
        local command, CommandData = table.unpack(C.StringStartsWith(C.CommandFunctions,inputCommand)[1] or {})
        if CommandData then
            if CommandData.RequiresRefresh and noRefresh then
                return
            end
            local canRunFunction = true
            for num, argumentData in ipairs(CommandData.Parameters) do
                if argumentData.Type=="Players" or argumentData.Type=="Player" then
                    local plrList = argumentData.AllowFriends and PS:GetPlayers() or C.GetNonFriends(true)
                    if args[num]=="all" then
                        args[num] = plrList
                    elseif args[num] == "others" then
                        args[num] = plrList
                        C.TblRemove(args[num],C.plr)
                        if #args[num]==0 then
                            canRunFunction = false
                            C.CreateSysMessage(`No other players found`)
                        end
                    elseif args[num] == "me" or args[num] == "" then
                        args[num] = {C.plr}
                    elseif args[num] == "random" then
                        args[num] = {plrList[Random.new():NextInteger(1,#plrList)]}
                    elseif args[num] == "new" then
                        if not argumentData.SupportsNew then
                            canRunFunction = false
                            C.CreateSysMessage(`{command} doesn't support "new" players`)
                        end
                        args[num] = "new"
                    else
                        local ChosenPlr = select(2,table.unpack(C.StringStartsWith(PS:GetPlayers(),args[1])[1] or {}))
                        if ChosenPlr then
                            args[num] = {ChosenPlr}
                        else
                            canRunFunction = false
                            C.CreateSysMessage(`Player(s) Not Found: {command}; allowed: all, others, me, <plrName>`)
                        end
                    end
                    if canRunFunction and argumentData.Type=="Player" and #args[num]>1 then
                        canRunFunction = false
                        C.CreateSysMessage(`{command} only supports a single player`)
                    elseif canRunFunction and args[num][1] == C.plr and argumentData.ExcludeMe then
                        canRunFunction = false
                        C.CreateSysMessage(`{command} doesn't support applying this command to yourself. Please choose another player`)
                    end
                elseif argumentData.Type=="Number" then
                    if args[num] ~= "" then
                        args[num] = tonumber(args[num])
                        if canRunFunction and not args[num] then
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows Number`)
                        elseif canRunFunction and (args[num] < argumentData.Min or args[num] > argumentData.Max) then
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows numbers between {argumentData.Min} to {argumentData.Max}`)
                            elseif canRunFunction and (argumentData.Step and math.floor(args[num]/argumentData.Step)*argumentData.Step~=args[num]) then
                                canRunFunction = false
                                C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows numbers to the precision of {argumentData.Step}, such as {argumentData.Step + argumentData.Min}`)
                        end
                    elseif argumentData.Default then
                        args[num] = argumentData.Default
                    end
                elseif argumentData.Type == "Options" then
                    local Options = argumentData.Options
                    if not table.find(Options,args[num]) and canRunFunction then
                        if args[num] == "" and argumentData.Default then
                            args[num] = argumentData.Default
                        else
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Options: {args[num]} is not valid option`)
                        end
                    end
                elseif argumentData.Type == "Friend" then
                    if args[num] == "" then
                        args[num] = ""
                    else
                        local BigRet = C.StringStartsWith(C.friendnames, args[num], true)
                        local Ret = BigRet[#BigRet]
                        if Ret then
                            args[num] = {UserId=C.friendnamestoids[Ret[2]], UserName= Ret[2]}
                        else
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows valid friends. No matching username/userid found for {tostring(args[num])}`)
                        end
                    end
                elseif argumentData.Type=="User" then
                    local success, name, id = C.GetUserNameAndId(args[num])
                    if success then
                        args[num] = {name, id}
                    else
                        canRunFunction = false
                        C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows valid users. No matching username/userid found for {args[num]}`)
                    end
                elseif argumentData.Type == "String" then
                    local min = argumentData.Min or 1
                    local max = argumentData.Max or 1000
                    if (args[num]:len() < min or args[num]:len() > max) then
                        if argumentData.Optional then
                            args[num] = false
                        else
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows text with length between {min} and {max}!`)
                        end
                    end
                elseif argumentData.Type=="" then
                    --do nothing
                elseif argumentData.Type~=false then
                    canRunFunction = false
                    C.CreateSysMessage(`Internal Error: Command Parameter Implemented But Not Supported: {command}, {tostring(argumentData.Type)}`)
                end
            end
            local ChosenPlr = args[1]
            if canRunFunction then
                local function yieldFunction()
                    local returns = table.pack(C.CommandFunctions[command]:Run(args))
                    local wasSuccess = returns[1]
                    table.remove(returns,1)
                    local displayNameCommand = command:sub(1,1):upper() .. command:sub(2)
                    if wasSuccess == true then
                        local Length = ChosenPlr and #ChosenPlr
                        local playersAffected = typeof(ChosenPlr) == "table" and (Length>1 and Length .. " Players" or tostring(ChosenPlr[1]))
                            --(typeof(ChosenPlr)=="Instance" and (ChosenPlr==C.plr and ChosenPlr.Name) or ChosenPlr.Name)
                           -- or (ChosenPlr:sub(1,1):upper() ..
                            --    ChosenPlr:sub(2,ChosenPlr:sub(ChosenPlr:len())=="s" and ChosenPlr:len()-1 or ChosenPlr:len()))
                        if playersAffected == C.plr.Name then
                            playersAffected = "you"
                        elseif not playersAffected or playersAffected == "nil" then
                            playersAffected = ""
                        end
                        returns[1] = returns[1] or ""
                        C.CreateSysMessage(`{displayNameCommand}ed {(playersAffected)}{(CommandData.AfterTxt or ""):format(table.unpack(returns)):gsub("  "," ")}`,
                            Color3.fromRGB(255,255,255))
                    else
                        C.CreateSysMessage(
                            `{displayNameCommand} Error: {returns[1] or `unknown RET for {displayNameCommand}`}`,
                            Color3.fromRGB(255))
                    end
                end
                if canYield then
                    yieldFunction()
                else
                    task.spawn(yieldFunction)
                end
            end

        elseif inputCommand~="c" and inputCommand~="whisper" and inputCommand~="mute" and inputCommand~="block" and inputCommand~="unblock"
            and inputCommand~="unmute" and inputCommand~="e" then
            C.CreateSysMessage(`Command Not Found: {inputCommand}`)
        end
    end
    -- Chatbar Connection
    --MY PLAYER CHAT
    local chatBar
    local isFocused
    local index = 0
    local hasNewChat = TCS.ChatVersion == Enum.ChatVersion.TextChatService

    local function registerNewChatBar(_,firstRun)
        local sendButton = hasNewChat and C.StringWait(CG,"ExperienceChat.appLayout.chatInputBar.Background.Container.SendButton")
        chatBar = C.StringWait(not hasNewChat and C.PlayerGui or CG,not hasNewChat and
            "Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar" or "ExperienceChat.appLayout.chatInputBar.Background.Container.TextContainer.TextBoxContainer.TextBox")

        local sendTheMessage
        if hasNewChat then
            sendButton.Visible = false
            local mySendButton = sendButton:Clone()
            mySendButton.Parent = sendButton.Parent
            mySendButton.Visible = true
            mySendButton.Name = "MySendButton"
            C.AddGlobalInstance(mySendButton)
            sendTheMessage = function(message,dontSetTB)
                message = typeof(message)=="string" and message or chatBar.Text
                if message == "" then
                    return
                end
                local channels = TCS:WaitForChild("TextChannels")
                local myChannel = channels.RBXGeneral
                local targetChannelTB = chatBar.Parent.Parent.TargetChannelChip
                if targetChannelTB.Visible then
                    local theirUser = targetChannelTB.Text:sub(5,targetChannelTB.Text:len()-1)
                    local theirPlr
                    for num, thisPlr in ipairs(PS:GetPlayers()) do
                        if thisPlr.Name == theirUser or thisPlr.DisplayName == theirUser then
                            if theirPlr then
                                warn(`(SendMessage) DUPLICATE Players Found For Display Name "{theirUser}"`)
                            end
                            theirPlr = thisPlr
                        end
                    end
                    if theirPlr then
                        myChannel = channels:FindFirstChild("RBXWhisper:"..C.plr.UserId.."_"..theirPlr.UserId) or channels:FindFirstChild("RBXWhisper:"..theirPlr.UserId.."_"..C.plr.UserId)
                        if not myChannel then
                            return warn(`(SendMessage) Could Not Find MyChannel {"RBXWhisper:"..C.plr.UserId.."_"..theirPlr.UserId} or {"RBXWhisper:"..theirPlr.UserId.."_"..C.plr.UserId}`)
                        end
                    else
                        return warn(`(SendMessage) Could Not Find Private Message User {theirUser} from "{targetChannelTB.Text}"`)
                    end
                end
                myChannel:SendAsync(message)
                if dontSetTB~=false then
                    chatBar.Text = ""
                end
            end
            mySendButton.MouseButton1Up:Connect(sendTheMessage)
            mySendButton.Destroying:Connect(function()
                if sendButton then
                    sendButton.Visible = true
                end
            end)
        end
        local connectionsFuncts = {}
        for num, connection in ipairs(C.getconnections(chatBar.FocusLost)) do
            connection:Disable()
            table.insert(connectionsFuncts,connection)
        end
        local lastText
        local lastUpd = -5
        if C.Cleared then
            return
        end
        local ChatAutoCompleteFrame = C.UI.ChatAutoComplete
        local DidSet = 0
        local Connections = {}
        local frameList, currentIndex = {}, 1
        local LastPreferred
        local function ClearSuggestions()
            if frameList[currentIndex] then
                LastPreferred = frameList[currentIndex].Name
            end
            C.ClearChildren(ChatAutoCompleteFrame)
            frameList, currentIndex = {}, 1
        end
		local function goToSaved(deltaIndex)
			index += deltaIndex
            lastUpd = os.clock()
            index = math.clamp(index,0,#C.savedCommands+1)

            local setTo = C.savedCommands[index] or ""
            local setCursor = chatBar.CursorPosition
            lastText = setTo
            RunS.RenderStepped:Wait()
            DidSet += 0
            chatBar.CursorPosition = setCursor
			chatBar.Text = setTo
            ClearSuggestions()
			chatBar.CursorPosition = setTo:len() + 1
        end
        local function HighlightLayout(num)
            currentIndex = math.clamp(num, math.min(#frameList,1), #frameList)

            for num2, frameButton in ipairs(frameList) do
                local selected = frameButton.LayoutOrder == currentIndex
                frameButton.BackgroundColor3 = selected and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

                if selected then
                    -- Get the position of the frameButton relative to the ChatAutoCompleteFrame
                    local objectTop = frameButton.AbsolutePosition.Y
                    local objectBottom = objectTop + frameButton.AbsoluteSize.Y
                    local canvasPosition = ChatAutoCompleteFrame.CanvasPosition.Y
                    local windowBottom = ChatAutoCompleteFrame.AbsolutePosition.Y + ChatAutoCompleteFrame.AbsoluteSize.Y

                    -- Check if the object is above the current view
                    if objectTop < ChatAutoCompleteFrame.AbsolutePosition.Y then
                        ChatAutoCompleteFrame.CanvasPosition =
                            Vector2.new(ChatAutoCompleteFrame.CanvasPosition.X, ChatAutoCompleteFrame.CanvasPosition.Y - (ChatAutoCompleteFrame.AbsolutePosition.Y - objectTop))
                    -- Check if the object is below the current view
                    elseif objectBottom > windowBottom then
                        ChatAutoCompleteFrame.CanvasPosition =
                            Vector2.new(ChatAutoCompleteFrame.CanvasPosition.X, ChatAutoCompleteFrame.CanvasPosition.Y + (objectBottom - windowBottom))
                    end
                end
            end
        end
        local Words,CurrentWordIndex
        local function ChatBarUpdated()
            if C.Cleared then
                return
            end
            local Inset = GS:GetGuiInset().Y
            isFocused = chatBar:IsFocused()
            ChatAutoCompleteFrame.Visible = isFocused
            ChatAutoCompleteFrame.Position = UDim2.fromOffset(chatBar.Parent.AbsolutePosition.X,chatBar.Parent.AbsolutePosition.Y+chatBar.Parent.AbsoluteSize.Y+Inset)
            ChatAutoCompleteFrame.Size = UDim2.fromOffset(chatBar.AbsoluteSize.X,C.GUI.AbsoluteSize.Y - ChatAutoCompleteFrame.AbsolutePosition.Y - Inset)
            if isFocused then
                local Deb = 0
                local ConnectedFunct
                function ConnectedFunct(inputObject, gameProcessed, noLoop)
                    local doContinue = false
                    if #frameList > 0 then
                        if inputObject.KeyCode == Enum.KeyCode.Up or inputObject.KeyCode == Enum.KeyCode.Insert then
                            HighlightLayout(currentIndex - 1)
                        elseif inputObject.KeyCode == Enum.KeyCode.Down or inputObject.KeyCode == Enum.KeyCode.Delete then
                            HighlightLayout(currentIndex + 1)
                        elseif inputObject.KeyCode == Enum.KeyCode.Tab then
                            local orgName = frameList[currentIndex].Name
                            --RunS.RenderStepped:Wait()
                            Words[math.max(1,CurrentWordIndex)] = orgName
                            Words[1] = chatBar.Text:sub(1,1) .. Words[1]
                            chatBar.Text = table.concat(Words, " ")
                            chatBar.CursorPosition = chatBar.Text:len() + 1
                        else
                            doContinue = true
                            noLoop = true
                        end
                    else
                        doContinue = true
                    end
                    if doContinue then
                        if inputObject.KeyCode == Enum.KeyCode.Up or inputObject.KeyCode == Enum.KeyCode.PageUp then
                            goToSaved(1)
                        elseif inputObject.KeyCode == Enum.KeyCode.Down or inputObject.KeyCode == Enum.KeyCode.PageDown then
                            goToSaved(-1)
                        else
                            return
                        end
                        noLoop = true -- don't loop
                    end
                    if noLoop then
                        return
                    end
                    Deb+= 1 local saveDeb = Deb
                    local accelerationFactor = 0.075 -- The rate at which the function speed increases
                    local minWaitTime = 0.015 -- Minimum wait time between function calls

                    task.wait(.4)
                    local startTime = os.clock() - 1 -- Capture the start time

                    while UIS:IsKeyDown(inputObject.KeyCode) and Deb == saveDeb do
                        local elapsedTime = os.clock() - startTime -- Calculate how long the key has been held
                        local waitTime = math.max(minWaitTime, accelerationFactor / elapsedTime) -- Compute the wait time with acceleration

                        ConnectedFunct(inputObject, gameProcessed, true)
                        task.wait(waitTime)
                    end
                end
                local function InputEnded(inputObject,gameProcessed)
                    if not gameProcessed then
                        return
                    end
                    if inputObject.KeyCode == Enum.KeyCode.PageDown or inputObject.KeyCode == Enum.KeyCode.PageUp then
                        chatBar.CursorPosition = chatBar.Text:len() + 1
                    end
                end
                local Conn1 = C.AddGlobalConnection(UIS.InputBegan:Connect(ConnectedFunct))
                local Conn2 = C.AddGlobalConnection(UIS.InputEnded:Connect(InputEnded))
                table.insert(Connections,Conn1)
                table.insert(Connections,Conn2)
                HighlightLayout(currentIndex) -- Make sure it's visible!
            elseif Connections then
                for num, conn in ipairs(Connections) do
                    C.RemoveGlobalConnection(conn)
                end
                Connections = {}
            end
        end
        -- Function to determine the current word and its index
        local function getCurrentWordAndIndex(words, cursorPosition)
            local totalLength = 0
            for index, word in ipairs(words) do
                totalLength = totalLength + #word + 1 -- +1 for the space
                if cursorPosition <= totalLength then
                    return word, index
                end
            end
            return "", 0 -- Default return if something goes wrong
        end
        local function textUpd()
            if DidSet <= 0 then
                index = 0
            end
            local newInputFirst, doubleSpaces = chatBar.Text:gsub("\t","")
            local newInput, moreSpaces = newInputFirst:gsub("%s+"," ")
            doubleSpaces += moreSpaces
            local newLength = newInput:len()
            --Load suggestions
            if DidSet <= 0 then
                if (newInput:sub(1, 1) == ";" or newInput:sub(1, 1) == "/") then
                    if doubleSpaces > 0 and chatBar.Text ~= newInput then
                        --print("Upd",doubleSpaces,moreSpaces)
                        chatBar.Text = newInput
                    end
                    Words = newInput:sub(2):split(" ")
                    local firstCommand = Words[1] -- Command, Really Important
                    local currentWord,currentWordIndex = getCurrentWordAndIndex(Words,chatBar.CursorPosition-1)--minus one for the command ;
                    local commands = C.StringStartsWith(C.CommandFunctions,firstCommand,true)
                    CurrentWordIndex = currentWordIndex
                    local options = {}
                    if currentWordIndex == 1 then
                        for num, list in ipairs(commands) do
                            local command, CommandData = table.unpack(list)
                            local afterTxt = ""
                            for num, suggestionData in ipairs(CommandData.Parameters) do
                                local curText = suggestionData.Type
                                afterTxt ..=" <" .. curText:lower() .. ">"
                            end
                            table.insert(options,{command,command..afterTxt})
                        end
                    elseif commands[1] then
                        local command,CommandData = table.unpack(commands[1]) -- Selected command
                        local mySuggestion = CommandData.Parameters[currentWordIndex - 1]
                        if mySuggestion then
                            if mySuggestion.Type == "Player" or mySuggestion.Type == "Players" then
                                for num, theirPlr in ipairs(PS:GetPlayers()) do
                                    if theirPlr ~= C.plr then
                                        local showLabel = theirPlr.DisplayName
                                        if theirPlr.DisplayName ~= theirPlr.Name then
                                            showLabel ..= " (@" .. theirPlr.Name..")"
                                        end
                                        table.insert(options,{theirPlr.Name,showLabel})
                                    end
                                end
                                if not mySuggestion.ExcludeMe then
                                    table.insert(options,1,{"me","me"})
                                end
                                if mySuggestion.Type == "Players" then
                                    table.insert(options,1,{"others","others"})
                                    table.insert(options,1,{"all","all"})
                                end
                                table.insert(options,{"random","random"})
                            elseif mySuggestion.Type == "Number" then
                                for s = mySuggestion.Min, mySuggestion.Max, (mySuggestion.Max - mySuggestion.Min) / 8 do
                                    local current = s
                                    if mySuggestion.Step then
                                        current = math.round(current/mySuggestion.Step)*mySuggestion.Step
                                    end
                                    local putInStep = tostring(math.clamp(current,mySuggestion.Min,mySuggestion.Max))
                                    local isIn = false
                                    for num, vals in ipairs(options) do
                                        if vals[1] == putInStep or vals[2] == putInStep then
                                            isIn = true
                                            break
                                        end
                                    end
                                    if not isIn then
                                        table.insert(options,{putInStep, putInStep})
                                    end
                                end
                            elseif mySuggestion.Type == "Options" then
                                for num, val in ipairs(mySuggestion.Options) do
                                    table.insert(options,{val,val})
                                end
                            elseif mySuggestion.Type == "Friend" then
                                for num, val in ipairs(C.friends) do
                                    table.insert(options,{val.UserId,val.SortName})
                                end
                            elseif mySuggestion.Type == "User" then
                                -- No suggestions available
                            else
                                assert(not mySuggestion.Type, `(CommandCore.RegisterNewChatBar.textUpd): Suggestion Type Not Yet Implented for {mySuggestion.Type}`)
                            end
                            options = C.StringStartsWith(options,currentWord,true,true)
                        end
                    end
                    ClearSuggestions()
                    for num, item in ipairs(options) do
                        if item[1] == LastPreferred then
                            currentIndex = num
                        end
                    end
                    for num, list in ipairs(options) do
                        local name, display = table.unpack(list)
                        local newClone = C.Examples.AutoCompleteEx:Clone()
                        newClone.BackgroundColor3 = num==currentIndex and Color3.fromRGB(0,255) or Color3.fromRGB(255)
                        newClone.AutoCompleteTitleLabel.Text = display
                        newClone.Name = name
                        newClone.Parent = ChatAutoCompleteFrame
                        newClone.LayoutOrder = num
                        table.insert(frameList,newClone)
                    end
                else
                    ClearSuggestions()
                end
            end
            DidSet = math.max(DidSet-1,0)
            if not chatBar or not isFocused then
                return
            end

            --Up Down Commands
            if #C.savedCommands==0 or lastText == newInput then
                return
            end
            local deltaIndex
            if newInput:match("/up") then
                deltaIndex = 1
            elseif newInput:match("/down") then
                deltaIndex = -1
            else
                return
            end
            goToSaved(deltaIndex)
        end
        C.AddObjectConnection(chatBar,"TextChatbar",chatBar:GetPropertyChangedSignal("Text"):Connect(textUpd))--:GetPropertyChangedSignal("Text"):Connect(textUpd))
        C.AddObjectConnection(chatBar,"TextChatbar",chatBar:GetPropertyChangedSignal("CursorPosition"):Connect(textUpd))
        textUpd()

        C.AddGlobalConnection(chatBar.Focused:Connect(ChatBarUpdated))
        ChatBarUpdated()
        C.AddObjectConnection(chatBar,"FocusLostChatbar",chatBar.FocusLost:Connect(function(enterPressed)
            local inputMsg = chatBar.Text
            if not C.Cleared then
                ChatBarUpdated()
                if enterPressed then
                    if inputMsg:sub(1,1)==";" or inputMsg:sub(1,1)=="/" then
                        enterPressed = inputMsg:sub(1,1)=="/" -- only send the message if it's a /
                        if not enterPressed then
                            chatBar.Text = ""
                            ClearSuggestions()
                        end
                        task.spawn(C.RunCommand,inputMsg,true)
                    end
                end
            end

            if not hasNewChat or C.Cleared then
                for num, connectionFunct in ipairs(connectionsFuncts) do
                    if connectionFunct.Function then
                        connectionFunct.Function(enterPressed)
                    else
                        warn("NO Function Found For "..num)
                    end
                end
            elseif enterPressed then
                sendTheMessage(inputMsg)
            end
        end))
    end
    if CS.LoadDefaultChat or table.find(OverrideChatGames,game.GameId) then
        if not hasNewChat then
            C.AddGlobalConnection(C.StringWait(C.PlayerGui,"Chat.Frame.ChatBarParentFrame").ChildAdded:Connect(function(child)
                registerNewChatBar()
            end))
        end
        task.spawn(registerNewChatBar,nil,true) -- do it on another thread
    else
        warn("[Specter Chat]: Chat cannot be loaded in custom games; commands may not work.")
    end
    if C.Cleared then
        return
    end
    -- TEMP: Add Scripts in there
    local Scripts2Add = {"Dark Dex", "Chat Bypass"}
    for num, scriptName in ipairs(Scripts2Add) do
        local FormattedName = scriptName:gsub("%s+","")
        local EncodedScriptName = HttpService:UrlEncode(scriptName)
        assert(not C.CommandFunctions[FormattedName], `[CommandCore]: C.CommandFunctions already has command "{FormattedName}"`)
        C.CommandFunctions[FormattedName] = {
            Parameters={},
            AfterTxt = "%s",
            Run = function()
                local CurrentModule = C.LoadModule("Scripts/"..EncodedScriptName)
                if C.getgenv().AlreadyRanScripts[scriptName] then
                    return false, "Already Ran " .. scriptName
                end
                C.getgenv().AlreadyRanScripts[scriptName] = true
                C.LoadModule("Scripts/"..EncodedScriptName).ScriptRun(C, Settings)
                return true, "Ran"
            end,
        }
    end
    for num, commandFunct in ipairs(C.InsertCommandFunctions) do
        if commandFunct then
            for name, commandData in pairs(commandFunct()) do
                assert(not C.CommandFunctions[name], `[CommandCore]: C.CommandFunctions already has command "{name}"`)
                assert(commandData.Parameters, `[CommandCore]: {name} doesn't have .Paramters`)
                assert(commandData.Run, `[CommandCore]: {name} doesn't have .Run`)
                C.CommandFunctions[name] = commandData
            end
        end
    end
    C.InsertCommandFunctions = nil
    for shortcut, commandTbl in pairs(C.CommandFunctions or {}) do
        commandTbl.Shortcut = shortcut
        commandTbl.Parent = C.CommandFunctions
        for _, aliasName in ipairs(commandTbl.Alias or {}) do
            assert(C.CommandFunctions[aliasName]==nil, `[CommandCore]: Duplicate AliasName: {aliasName} from the command {shortcut}`)
            C.CommandFunctions[aliasName] = commandTbl
        end
        C.BindEvents(commandTbl)
    end
end]=],
    ["Modules/CoreEnv"] = [=[local CS = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local HS = game:GetService("HttpService")
local RunS = game:GetService("RunService")
local TCS = game:GetService("TextChatService")
local PS = game:GetService("Players")
local SG = game:GetService("StarterGui")
return function(C,Settings)
    local Serializer = C.LoadModule("Modules/Serializer")
    C.getgenv().currentDesc = C.getgenv().currentDesc or {}
	function C.API(service,method,tries,...)
		assert(typeof(tries)=="number" or tries==nil,"[C.API]: Tries parameter must be a number")
		tries = tries or 3
		local success, result
		while (tries > 0 or tries == -1) and not success do
			if method then
				success, result = pcall(service[method],service,...)
			else
				success, result = pcall(service,...)
			end
			if not success then
				C.AddNotification("API Failed",`{tostring(method)} from service {tostring(service)} has failed: {tostring(result)}!\nTries: {tries<0 and "inf" or tries}`)
				warn(debug.traceback(`{tostring(method)} from service {tostring(service or "")} has failed: {tostring(result)}! Tries: {tries<0 and "inf" or tries}`))
			end
			tries -= 1
		end
		return success, result
	end
	local SettingsPath = "SpecterV2/Settings"
	local ProfileStoragePath = "SpecterV2/Profiles"
	local SaveFileExtention = ".json"
	local function CreateStoragePath(path)
		local previous = ""
		for num, addon in ipairs(ProfileStoragePath:split("/")) do
			local path = previous
			if path ~= "" then
				path ..= "/" .. addon
			else
				path ..= addon
			end
			if not C.isfolder(path) then
				C.makefolder(path)
			end
			previous = path
		end
	end
	function C.ReloadHack(hackTbl)
		--[[local oldEn = hackTbl.Enabled
		if oldEn then
			hackTbl:SetValue(false,true)
			hackTbl:SetValue(true,true)
		end--]]
		C.DoActivate(hackTbl,hackTbl.Activate,hackTbl.RealEnabled)
	end
	function C.DoActivate(self,funct,...)
        if self.Activate == funct then
            self:ClearData()
            local firstRun = select(2,...)
            if not firstRun and ... then -- check to see if true
                if C.SaveEvents and self.Events then
                    for key, eventFunct in pairs(self.Events) do
                        local eventList = C.SaveEvents[key:gsub("Added","")]
                        if eventList then
                            for _, eventData in ipairs(eventList) do
                                C.DoActivate(self,eventFunct,table.unpack(eventData))
                            end
                        end
                    end
                end
            end
        else
            --self:ClearData()
        end
        if not funct then
            if self.Activate ~= funct then
                warn(`[C.DoActivate]: Non activate function being ignored because it does not exist for {self.Shortcut}: `,self)
            end
            return
        end

		local header = "Hack/"..self.Parent.Category.Name.."/"..self.Shortcut
		if self.Type == "OneRun" then
			if not self.RealEnabled then
				self:FlashLabel(self.DisableAttemptMsg or "Cannot Disable",Color3.fromRGB(255))
				return
			elseif C.getgenv()[header] then
				-- Do nothing lol
				return
			end
			C.getgenv()[header] = true
		end
		local Thread = task.spawn(funct,self,...)
		if self.Threads then
			table.insert(self.Threads,Thread)
		end
	end
	function C:ReloadStates()
		for name, groupedTabData in pairs(C.hackData) do
			for shortcut, hackTbl in pairs(groupedTabData) do
				local EnDict = C.enHacks[name][shortcut]
				hackTbl:SetValue(EnDict.En)
				hackTbl:SetKeybind(EnDict.Keybind and Enum.KeyCode[EnDict.Keybind] or nil)
				for num, optionData in ipairs(hackTbl.Options) do
					optionData:SetValue(EnDict[optionData.Shortcut])
				end
			end
		end
	end
	function C:SaveProfile()
		if self ~= C then
			error("Invalid SaveProfile Call: must use `:` but only used `.`")
		end
		local profileName = C.getgenv().ProfileId
		if not C.readfile or not C.writefile or profileName == "" then
			C.DebugMessage("SaveSystem","Save Stopped, profileName: "..(profileName or "nil"))
			return
		end
		local function internallySaveProfile()
			local FilePath = ProfileStoragePath .. "/" .. profileName .. SaveFileExtention
			local FilePath2 = SettingsPath .. SaveFileExtention
			-- Create the data as a table
			local SaveDict = {
				Hacks = table.clone(C.enHacks)
			}
			SaveDict.Hacks.Settings = nil
			-- Encode the data
			local EncodedSaveDict = HS:JSONEncode(SaveDict)
			-- Storage Folder Link
			CreateStoragePath(ProfileStoragePath)

			--Store general settings
			if not C.getgenv().PreviousServers then
				C.getgenv().PreviousServers = {}
			end
			do -- Private server detection, cannot join any other servers! EDIT: CANNOT ACCESS FROM CLIENT
				local PreviousServers = C.getgenv().PreviousServers
				--if #PreviousServers == 0 or PreviousServers[1].JobId ~= game.JobId or PreviousServers[1].PlaceId ~= game.PlaceId then
				for index = #PreviousServers, 1, -1 do
					local data = PreviousServers[index]
					local shouldDestroy = (data.JobId == game.JobId and data.PlaceId == game.PlaceId and data.GameId == game.GameId)
						or (os.time() - data.Time > Settings.ServerSaveDeleteTime)
					if shouldDestroy then
						table.remove(PreviousServers,index)
					end
				end
				local PlayerCount = #PS:GetPlayers()
				if PlayerCount >= 1 then
					table.insert(PreviousServers,1,{
						PlaceId = game.PlaceId,
						JobId = game.JobId,
						GameId = game.GameId,
						Time = os.time(),
						Players = PlayerCount,
						MaxPlayers = PS.MaxPlayers,
						Name = C.getgenv().PlaceName,
					})
				end

			--[[else
					C.getgenv().PreviousServers[1].Time = os.time() -- Update time
					C.getgenv().PreviousServers[1].Players = #PS:GetPlayers() -- Update players
				end--]]
			end
            local MorphsData
            MorphsData = C.getgenv().serializedDesc or {}


			local EncodedSaveDict2 = HS:JSONEncode({
				Settings = C.enHacks.Settings,
				Servers = C.getgenv().PreviousServers,
                MorphData = MorphsData
			})
			--General Storage Folder Link

			--Save files
			C.writefile(FilePath,EncodedSaveDict)
			C.writefile(FilePath2,EncodedSaveDict2)
		end
		local success, result = C.API(internallySaveProfile,nil,1)
		C.DebugMessage("SaveSystem",`{tostring(success)}: {tostring(result)}`)
		if not success then
			C.AddNotification(`Profile Save Error`,`Saving {profileName} failed: {result}`)
		end
		return success, result
	end
	function C:LoadProfile(profileName:string)
		if not C.readfile or not C.writefile then
			C.AddNotification("Profiles Not Supported","Your exploit engine does not support readfile/writefile, meaning saved profiles cannot save/load!")
			return
		end
		local function internallyLoadProfile()
			C.enHacks = C.enHacks or {}
			local path = ProfileStoragePath .. "/" .. profileName .. SaveFileExtention
			local path2 = SettingsPath .. SaveFileExtention
			if C.isfile(path2) then
				local rawFile2 = C.readfile(path2)
				local decoded2 = HS:JSONDecode(rawFile2)
				C.enHacks.Settings = decoded2.Settings
				C.getgenv().PreviousServers = decoded2.Servers
                for userName, encodedData in pairs(decoded2.MorphData or {}) do
                    C.getgenv().currentDesc[userName] = Serializer.deserialize(encodedData)
                end
                C.getgenv().serializedDesc = decoded2.MorphData or {}
                C.getgenv().MorphEnabled = C.getgenv().MorphEnabled or (decoded2.MorphData and C.GetDictLength(decoded2.MorphData) > 0)
			end
			if not C.isfile(path) then
				C.DebugMessage("SaveSystem",`{path} Profile Not Found`,`The profile named "{path}" was not found in your workspace folder.`)
				if not C.isStudio then
					C.getgenv().ProfileId = "Default"
				end
				return
			end
			local rawFile = C.readfile(path)
			local decoded = HS:JSONDecode(rawFile)
			for key, val in pairs(decoded.Hacks) do
				C.enHacks[key] = val
			end


		end
		local success, result = C.API(internallyLoadProfile,nil,1)
		C.DebugMessage("SaveSystem",`Result: {tostring(success)}; {tostring(result)}`)
		if success then
			C.getgenv().ProfileId = profileName
			C.DebugMessage("SaveSystem",`Set: ProfileId to {profileName} aka {C.getgenv().ProfileId}`)
			if not C.StartUp then
				C:ReloadStates()
			end
		elseif not success then
			C.AddNotification(`Profile Load Error`,`Loading Profile {profileName} failed: {result}`)
			C.DebugMessage("SaveSystem",`Loading Profile {profileName} failed: {result}`)
		end
		return success, result
	end
	function C:StartAutoSave()
		local AutoSaveEvent = Instance.new("BindableEvent")
		local LastMenuSave
		C.AddGlobalConnection(GuiService.MenuOpened:Connect(function()
			if not LastMenuSave or os.clock() - LastMenuSave > 10 then
				LastMenuSave = os.clock()
				AutoSaveEvent:Fire("MenuOpened")
			end
		end))
		C.AddGlobalInstance(AutoSaveEvent)
		while not C.Cleared do
			local IsWaiting = true
			task.delay(60, function()
				if IsWaiting and AutoSaveEvent then
					AutoSaveEvent:Fire("Timeout")
				end
			end)
			local Reason = AutoSaveEvent.Event:Wait()
			IsWaiting = false
			if C.Cleared then
				return
			end
			C:SaveProfile()
		end
	end
	--Chat
	function C.CreateSysMessage(message,color,typeText)
		if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
			(TCS:FindFirstChild("RBXGeneral",true) or TCS:FindFirstChildWhichIsA("TextChannel",true)):DisplaySystemMessage(message)
		else
            typeText = typeText and ("[" .. typeText .. "]:") or "{Sys}"
			SG:SetCore("ChatMakeSystemMessage",  { Text = `{typeText} {message}`, Color = color or Color3.fromRGB(255),
				Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size24 } )
		end
	end
	--Yieldable Handler
	function C.RunFunctionWithYield(func, args, timeout)
		--RunFunc((Function)func, (Table)args, (Number)timeout)

		local bindableEvent = Instance.new("BindableEvent")
		C.AddGlobalInstance(bindableEvent)
		local response
		local success = false

		-- Coroutine to call the function
		task.spawn(function()
			local functionResult
			success, functionResult = pcall(function()
				if args then
					return func(unpack(args))
				else
					return func()
				end
			end)
			bindableEvent:Fire(success, functionResult)
		end)

		-- Timer for the timeout
		task.delay(timeout, function()
			if not bindableEvent then
				return
			end
			bindableEvent:Fire(false, "Function call timed out")
		end)

		-- Wait for either the function to complete or the timeout
		local success, result = bindableEvent.Event:Wait()
		bindableEvent:Destroy()

		return success, result
	end
	--Destroy Handler
	function C.ClearTagTraces(tagName:string)
		for num, tagInstance in ipairs(CS:GetTagged(tagName)) do
			tagInstance:RemoveTag(tagName)
		end
	end
	--Destroy Function
	function C:Destroy()
		assert(C==self, "C is not the called function")
		assert(not C.Cleared, `SaveIndex {C.SaveIndex} is already cleared / being destroyed!`)
		C.DebugMessage("Destroy",`Destroy Start`)
		-- It is cleared
		C.Cleared = true
		C.TblRemove(C.getgenv().Instances,C.SaveIndex or -1)

		-- First, undo the connections
		C.ClearThreadTbl(C.threads)
		C.ClearFunctTbl(C.functs)

		C.DebugMessage("Destroy",`Destroy 1`)

		local RemoveOnDestroyIndex = 0
		local ThingsToRemove = {}

		local function RunOnDestroy(hackTbl,name)
			local Identification = hackTbl.Shortcut or "cmd_unk"
			ThingsToRemove[Identification] = true
			RemoveOnDestroyIndex += 1
			task.spawn(function()
				local Done = false
				task.delay(3,function()
					if not Done then
						C.DebugMessage("Destroy", `RunOnDestroy: {name} is still running after 3 seconds!`)
					end
				end)
				hackTbl:RunOnDestroy()
				ThingsToRemove[Identification] = nil
				RemoveOnDestroyIndex -= 1
				Done = true
			end)
		end

		for category, groupedTabData in pairs(C.hackData) do
			for num, hackTbl in pairs(groupedTabData) do
				if hackTbl.ClearData then -- This function is empty when the game has not loaded!
					hackTbl:ClearData()
				end
				local ShouldDoRunOnDestroy = hackTbl.RunOnDestroy and hackTbl.RealEnabled
				hackTbl.Enabled, hackTbl.RealEnabled = false, false -- disable their enabled states!
				if ShouldDoRunOnDestroy then
					RunOnDestroy(hackTbl,"HackTBL: " .. hackTbl.Shortcut)
				end
			end
		end

		for name, commandData in pairs(C.CommandFunctions or {}) do
			if commandData.RunOnDestroy then
				RunOnDestroy(commandData,"CmdTBL: " .. name)
			end
		end

		C.DebugMessage("Destroy",`Destroy 2`)

		for instance, propertiesTbl in pairs(C.forcePropertyFuncts) do
			for attr, val in pairs(instance:GetAttributes()) do
				if attr:find("_Request_") or attr:find("_RequestCount") then
					--do nothing, it will be cleared
				elseif attr:find("_OriginalValue") then
					instance[attr:split("_")[1]] = val
					continue -- don't delete it...
				else
					continue -- everything else keep, prob important game stuff!
				end
				instance:SetAttribute(attr,nil)
			end
			for property, funct in pairs(propertiesTbl) do
				funct:Disconnect()
			end
		end C.forcePropertyFuncts = {} -- clear memory ig

		for actionName, hackTbl in pairs(C.BindedActions) do
			C.UnbindAction(actionName)
		end

		for key, dict in pairs(C.playerfuncts) do
			C.ClearFunctTbl(dict)
		end

		for key, dict in pairs(C.objectfuncts) do
			C.ClearFunctTbl(dict,true)
		end



		for instance, signalData in pairs(C.PartConnections) do
			for signal, data in pairs(signalData) do
				for key, enabled in pairs(data) do
					if key ~= "Value" and key ~= "Name" then
						--print("Attemping to disable",signal,data,key,enabled)
						C.SetInstanceConnections(instance,data.Name,key,true)
					end
				end
			end
		end

		-- Then, destroy everything
		RunS:UnbindFromRenderStep("Follow"..C.SaveIndex)
		RunS:UnbindFromRenderStep("Spin"..C.SaveIndex)
		if C.PurgeActionsWithTag then
			C.PurgeActionsWithTag("RemoveOnDestroy")
            for name, list in pairs(C.getgenv().ActionsList) do
                if list.Stop then
                    list.Stop()
                end
                list.Enabled = false
                list.ActionFrame = nil
                C.ClearThreadTbl(list.Threads)
            end
		end

		for key, instance in ipairs(CS:GetTagged("RemoveOnDestroy")) do
			instance:Destroy()
		end

		if C.GUI then
			C.GUI:Destroy()
			C.GUI = nil
		end

		C.DebugMessage("Destroy",`Destroy 3 / Waiting For RemoveOnDestroyIndex: {RemoveOnDestroyIndex}`)

		local theTime = 0

		while RemoveOnDestroyIndex > 0 do
			theTime+=task.wait() -- Wait while being destroyed
			if theTime > 10 then
				warn(`[C:Destroy]: It's been 10 seconds bro and I'm still waiting on RunOnDestroy functions: {RemoveOnDestroyIndex}`,ThingsToRemove)
				theTime = 0
			end
		end


		RunS.RenderStepped:Wait()
		C.getgenv().DestroyEvent:Fire()

		C.DebugMessage("Destroy",`Destroy Success`)

		if C.isStudio then
			script.Parent.Parent:Destroy()
		end
	end

	if not C.getgenv().Instances then
		C.getgenv().Instances = {}
	end

	if not C.getgenv().CreateEvent then
		C.getgenv().CreateEvent = Instance.new("BindableEvent")
		C.getgenv().DestroyEvent = Instance.new("BindableEvent")
	end

	C.AddGlobalConnection(C.getgenv().CreateEvent.Event:Connect(function(SaveIndex)
		C.DebugMessage("Destroy",`Destroy Called: {tostring(SaveIndex==C.SaveIndex)}`)
		if C.SaveIndex == SaveIndex then
			return -- our signal sent this!
		end
		C:Destroy()
	end))

	C.SaveIndex = (C.getgenv().SpecterIndex or 0)+1
	C.getgenv().SpecterIndex = C.SaveIndex

	table.insert(C.getgenv().Instances,C.SaveIndex)
	C.DebugMessage("Load",`Waiting To Load Starting`)
	local isWaiting = true
	task.delay(7,function()
		if not C.Cleared and isWaiting then
			C.getgenv().DestroyEvent:Fire(true)
		end
	end)
	while #C.getgenv().Instances>1 do
		if C.Cleared then
			return
		end
		C.DebugMessage("Load",`Waiting for destruction because SaveIndex={C.getgenv().Instances[1]}; {#C.getgenv().Instances-1} Extra Instance(s)`)
		task.spawn(C.getgenv().CreateEvent.Fire,C.getgenv().CreateEvent,C.SaveIndex)
		if C.getgenv().DestroyEvent.Event:Wait() == true then
			warn("Time out occured! Starting execution...")
			break
		end
		if #C.getgenv().Instances>1 then
			C.DebugMessage("Load",`Still waiting for instances to be deleted!`)
		end
	end
	C.DebugMessage("Load",`Waiting To Load Finished`)
	isWaiting = false
    task.spawn(function()
        C.writefile("SpecterV2.lua", `loadstring(game:HttpGet("https://raw.githubusercontent.com/ItsAFairGameBro/Specter/main/src/shared/Shared.lua"))()`)
    end)
end
]=],
    ["Modules/CoreLoader"] = [[local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local ModulesToRun = {"Render","Blatant","World","Utility","Friends","Settings"}
local GamesWithModules = {
	--[6203382228] = {ModuleName="TestPlace"},
	[770538576] = {ModuleName="NavalWarefare",GameName="Naval Warefare"},
	[1069466626] = {ModuleName="PassBomb",GameName="Pass The Bomb"},
	[66654135] = {ModuleName="MurderMystery",GameName="Murder Mystery 2"},
	[1160789089] = {ModuleName = "FlagWars",GameName="Flag Wars"},
	[88070565] = {ModuleName = "Bloxburg", GameName = "Bloxburg"},
	[39559307] = {ModuleName = "TowerBattles", GameName = "Tower Battles"},
	[495693931] = {ModuleName = "Doomspire", GameName = "Doomspire Brickbattle"},
    [372226183] = {ModuleName = "FleeTheFacility", GameName = "Flee The Facility"},
}
-- USE THIS API TO GET UNIVERSE IDs:
-- https://apis.roblox.com/universes/v1/places/PlaceId/universe

local KeybindRunFunct,BindButton

return function(C, _SETTINGS)
	--Load Locale Environment
	C.LoadModule('Modules/Env')
	if C.Cleared then return end
    --Load Core Env
	C.LoadModule('Modules/CoreEnv')
    if C.Cleared then return end
	--Load GUI Elements
	C.LoadModule('Modules/GuiElements')
	if C.Cleared then return end

	if C.SaveIndex == 1 then
		C:LoadProfile("Default")
		if C.Cleared then return end
	end
	if C.Cleared then return end
	--Load Binds and such
	C.LoadModule("Modules/Binds")
	--Load Current Profile, But Only If We're The First
	--Load Category Buttons & Tabs
	--C.UI.Tabs = {}
	local HeaderTab,ButtonsTab,SettingsTab = C.UI.CategoriesFrame:WaitForChild("HeaderTab"),
		C.UI.CategoriesFrame:WaitForChild("Buttons"),C.UI.CategoriesFrame:WaitForChild("Settings")
	local ThisGameTbl = GamesWithModules[game.GameId]
	local GameModule
	local SupportedFrame = SettingsTab:WaitForChild("SupportedFrame")
	local GameImage = "https://www.roblox.com/Thumbs/Asset.ashx?Width=768&Height=432&AssetID="..game.PlaceId
	if ThisGameTbl then
		SupportedFrame:WaitForChild("Description").Text = `Specter supports this game✅`
		SupportedFrame:WaitForChild("Supported").Text = `Supported Game`
		GameModule = ThisGameTbl.ModuleName
		table.insert(ModulesToRun,GameModule)
	else
		SupportedFrame:WaitForChild("Description").Text = `Specter DOES NOT support this game❌`
		SupportedFrame:WaitForChild("Supported").Text = `Unsupported Game`
	end
	--if success then
	C.SetImage(SupportedFrame:WaitForChild("Image"),GameImage)
	--end

	--Add developer settings
	if (C.enHacks.Settings and C.enHacks.Settings.DeveloperMode.En) or C.isStudio then
		table.insert(ModulesToRun,"Developer")
	end

	C.ButtonClick(HeaderTab:WaitForChild("SettingsButton"),function()
		ButtonsTab.Visible = not ButtonsTab.Visible
		SettingsTab.Visible = not SettingsTab.Visible
	end)

	local SettingsTab = C.UI.CategoriesFrame:WaitForChild("Settings")

	local BottomFrame = ButtonsTab:WaitForChild("BottomFrame")
	local SaveButton = BottomFrame:WaitForChild("SaveButton")
	local WaitButton = SaveButton:WaitForChild("Wait")

	local SaveDeb = false
	function C.DoSave()
		if SaveDeb then return end SaveDeb = true
		SaveButton.ImageColor3 = Color3.fromRGB(81,81,81)
		WaitButton.Visible = true
		WaitButton.Text = "•••"
		local success = C:SaveProfile()
		if success then
			WaitButton.Text = "✅"
			task.wait(3)
			WaitButton.Visible = false
		else
			WaitButton.Text = "❌"
		end
		task.wait(5)
		WaitButton.Visible = false
		SaveButton.ImageColor3 = Color3.fromRGB(255,255,255)
		SaveDeb = false
	end
	C.ButtonClick(SaveButton,C.DoSave)

	local RefreshButton = SettingsTab:WaitForChild("BottomFrame"):WaitForChild("RefreshButton")
	local AlreadyRefreshing = false
	function C.Refresh()
		if AlreadyRefreshing or C.isStudio then return end AlreadyRefreshing = true
		local LoopTween = TS:Create(RefreshButton,TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1),{Rotation=360})
		LoopTween:Play()
		task.spawn(loadstring(game:HttpGet("https://raw.githubusercontent.com/ItsAFairGameBro/Specter/main/src/shared/Shared.lua")))
		task.wait(5)
		if C.Cleared then
			return
		end
		LoopTween:Cancel()
		AlreadyRefreshing = false
	end
	C.ButtonClick(RefreshButton,C.Refresh)
	task.spawn(C.StartAutoSave,C)

	local ListOfElements = {}
	local function UpdateTextSize(ButtonEx,setUp: boolean)
		if setUp then
			table.insert(ListOfElements,ButtonEx)
		end
		ButtonEx.KeybindButton.Visible = UIS.KeyboardEnabled
		if ButtonEx.KeybindButton.Visible and not ButtonEx.HackExpand.Visible then
			ButtonEx.KeybindButton.Position = UDim2.new(0.991, 0, 0, 20)
		else
			ButtonEx.KeybindButton.Position = UDim2.new(0.841, 0, 0, 20)
		end
		local AdditionalOffset = 0
		AdditionalOffset += (ButtonEx.KeybindButton.Visible and 0 or ButtonEx.KeybindButton.Size.X.Scale)
		AdditionalOffset += (ButtonEx.HackExpand.Visible and 0 or ButtonEx.HackExpand.Size.X.Scale)
		ButtonEx.HackText.Size = UDim2.new(0.65 + AdditionalOffset, 0, 0, 40)
	end

	for num, name in ipairs(ModulesToRun or {}) do
		if C.Cleared then return end
		local isGame = GameModule == name

		local hack = C.LoadModule(isGame and "Games/"..name or "Hacks/"..name)
        if not hack then continue end -- No hacks is crazy!
		local category = hack.Category
		local idName = category and category.Name or name


		local visible = false
		local enHackTab = C.enHacks[idName] or {}
		C.enHacks[idName] = enHackTab
		C.hackData[name] = {}

		local ScrollTab

		if category then
			-- Create the category button
			local CategoryEx = C.Examples.CategoryEx:Clone()
			local TabEx = C.Examples.TabEx:Clone()
			CategoryEx.LayoutOrder = (category.Layout + (category.AfterMisc and 50 or 0)) * 100
			CategoryEx:WaitForChild("Text").Text = category.Title
			local UsableImage = category.Image and 'rbxassetid://' .. category.Image or GameImage
			C.SetImage(CategoryEx:WaitForChild("Image"), UsableImage)
			CategoryEx.Parent = ButtonsTab
			local function ToggleVisiblity()
				visible = not visible
				TS:Create(CategoryEx.Text,TweenInfo.new(.15),{TextColor3=visible and Color3.fromRGB(0,170) or Color3.fromRGB(255,255,255)}):Play()
				TS:Create(CategoryEx.Image,TweenInfo.new(.15),{ImageColor3=visible and Color3.fromRGB(0,170) or Color3.fromRGB(255,255,255)}):Play()
				TabEx.Visible = visible
			end
			C.ButtonClick(CategoryEx,ToggleVisiblity)
			ToggleVisiblity()
			-- Create the tab frame
			local HeaderTab = TabEx:WaitForChild("HeaderTab")
			ScrollTab = TabEx:WaitForChild("ScrollTab")
			HeaderTab:WaitForChild("Text").Text = category.Title
			C.SetImage(HeaderTab:WaitForChild("Image"),UsableImage)
			if GameModule == name then
				TabEx.Position = UDim2.fromOffset(250 * (4),100)
			elseif category.Layout < 4 then
				TabEx.Position = UDim2.fromOffset(250 * (category.Layout),100)
			else
				TabEx.Position = UDim2.fromOffset(250 + 500 * (category.Layout-4),300)
			end
			TabEx.Name = category.Name
			TabEx.Parent = C.UI.TabsFrame
			TabEx.ZIndex = CategoryEx.LayoutOrder + 100

			if C.Cleared then return end

			--C.UI.Tabs[category.Name] = TabEx

			task.spawn(C.MakeDraggableTab,TabEx,true)
		else
			ScrollTab = SettingsTab:WaitForChild("ScrollTab")
		end

		-- Load Individual Hacks
		for num, hackData in pairs(hack.Tab) do
			if not hackData or (C.isStudio and hackData.NoStudio) then
				continue
			end
			assert(hackData.Shortcut,`{hackData.Title} from {name} doesn't have a Shortcut identifer!`)
			assert(typeof(hackData.Layout)=="number",`{hackData.Title} from {name} has invalid .Layout property!`)
			if C.hackData[name][hackData.Shortcut] then
				warn(`Duplicate shortcut found: {name}/{hackData.Shortcut}; Therefore, not loading {hackData.Title}`)
				continue
			end
			C.hackData[name][hackData.Shortcut] = hackData
			local ButtonEx = C.Examples.HackButtonEx:Clone()
			hackData.Button = ButtonEx
			hackData.Parent = hack
			--Basic Information
			local OptionsList = ButtonEx:WaitForChild("OptionsList")
			local MainText = ButtonEx:WaitForChild("HackText")
			local HackExpand = ButtonEx:WaitForChild("HackExpand")
			local KeybindButton = ButtonEx:WaitForChild("KeybindButton")
			ButtonEx.Name = hackData.Title
			ButtonEx.LayoutOrder = hackData.Layout - (hackData.Title:find("ESP") and 1000 or 0)
			MainText.Text = hackData.Title
			assert(hackData.Shortcut,`{hackData.Title} does't have a Shortcut`)
			local enTbl = enHackTab[hackData.Shortcut] or {}
			enHackTab[hackData.Shortcut] = enTbl
			hackData.EnTbl = enTbl
            if _SETTINGS.StartDisabled then
                enTbl.En = false
            elseif enTbl.En == nil and hackData.Default ~= nil then
				enTbl.En = hackData.Default
            end
            hackData.RealEnabled = enTbl.En
            hackData.Enabled = enTbl.Enabled


			--Options Activation
			local optionsUnused = table.clone(enTbl)
			optionsUnused.En = nil -- Delete, it's useless
			for num, optionData in ipairs(hackData.Options or {}) do
                if not optionData then
                    continue
                end
				assert(optionData.Shortcut,`The option {num} on {category}/{hackData.Shortcut} is missing a Shortcut`)
				optionData.Parent = hackData
				optionsUnused[optionData.Shortcut] = nil
				C.UI.Options[optionData.Type].new(ButtonEx,optionData)
			end
			--Extra Options Warning
			for opName, option in pairs(optionsUnused) do
				if opName == "En" or opName == "Keybind" then
					continue
				end
				warn(`{name}/{hackData.Shortcut}: {opName} is set to {option} but that option no longer exists. It has been deleted for memory`)
				enTbl[opName] = nil -- Remove the option
			end
			--Three Dots Button
			local ViewSettingsVisible = true
			if not hackData.Options or #hackData.Options == 0 then
				HackExpand.Visible = false
				ViewSettingsVisible = false
				KeybindButton.Position = UDim2.new(1,0,0,KeybindButton.Position.Y.Offset)
			else
				local function UpdateViewSettings(Instant)
					ViewSettingsVisible = not ViewSettingsVisible
					OptionsList.Visible = ViewSettingsVisible --TS:Create(OptionsList,TweenInfo.new(Instant == true and 0 or .3),
					--	{Size=UDim2.new(1,0,0,(ViewSettingsVisible and OptionsList.AbsoluteSize.Y or 0))}):Play()
				end
				C.ButtonClick(HackExpand,UpdateViewSettings)
				UpdateViewSettings()
			end

			--Active Logic
			local HighlightBackground = ButtonEx:WaitForChild("HighlightBackground")
			local function UpdateButtonColor(started: boolean)
				TS:Create(HighlightBackground,TweenInfo.new(.1),
					{BackgroundTransparency=hackData.Enabled and 0.3 or 1}):Play()
			end
			function hackData:ClearData()
				if hackData.Threads then
					for num, thread in ipairs(hackData.Threads) do
						C.StopThread(thread)
					end hackData.Threads = {}
				end
				if hackData.Instances then
					for num, inst in ipairs(hackData.Instances) do
						inst:Destroy()
					end hackData.Instances = {}
				end
				if hackData.Functs then
					C.ClearFunctTbl(hackData.Functs)
				end
			end
			local activatedDeb = 0
			function hackData:FlashLabel(text,color)
				activatedDeb+=1
				local saveActivateDeb = activatedDeb
				MainText.Text = text
				MainText.TextColor3 = color
				task.delay(1,function()
					if activatedDeb ~= saveActivateDeb then
						return
					end
					MainText.Text = hackData.Title
					MainText.TextColor3 = Color3.fromRGB(255,255,255)
				end)
			end
			function hackData:SetValue(value,started)
				if (value == hackData.Enabled or C.Cleared) and not started then
					return--no change, don't bother!
				end
				if value and hackData.Type == "NoToggle" then
					value = false
					if not started then
						hackData:FlashLabel("Activated!",Color3.fromRGB(0,255))
					end
				end
				hackData.Enabled = value
				if #hackData.Override==0 then
					hackData.RealEnabled = value
				end
				enTbl.En = value
				UpdateButtonColor()
				if C.Cleared then
					return
				end
				if ((hackData.Activate and hackData.RealEnabled) or hackData.AlwaysActivate or not started
					or (not started and hackData.Type == "NoToggle"))
					and (not started or not hackData.DontActivate) then
					C.DoActivate(hackData,hackData.Activate, hackData.RealEnabled, started)
				end
			end
			hackData.Override = hackData.Override or {}
			C.ButtonClick(MainText,function()
				hackData:SetValue(not hackData.Enabled)
			end)
			--task.spawn(hackData.SetValue,hackData,enTbl.En==true, true)

			--Keybind
			if name ~= "Settings" then
				local BindedKey = KeybindButton:WaitForChild("BindedKey")
				function hackData:SetKeybind(key: Enum.KeyCode)
					if key then
						BindedKey.Text = key.Name:gsub("Slash","/")
						C.AddKeybind(key,hackData)
					else
						BindedKey.Text = ""
						C.RemoveKeybind(hackData)
					end
					C.IsBinding = false
				end
				local function KeybindClick(override)
					if KeybindRunFunct then
						C.RemoveGlobalConnection(KeybindRunFunct)
						KeybindRunFunct = nil
						BindButton.KeybindLabel.Visible = false
						BindButton.HighlightBackground.Visible = true
						if BindButton == ButtonEx and override ~= true then
							hackData:SetKeybind(nil)
						end
					end

					if BindButton ~= ButtonEx then
						BindButton = ButtonEx
						KeybindRunFunct = C.AddGlobalConnection(UIS.InputBegan:Connect(function(inputObject,gameProcessed)
							if inputObject.UserInputType == Enum.UserInputType.Keyboard then
								local key = inputObject.KeyCode
								hackData:SetKeybind(key)
								KeybindClick(true)
							end
						end))
						ButtonEx.KeybindLabel.Visible = true
						BindButton.HighlightBackground.Visible = false
						C.IsBinding = true
					else
						BindButton = nil
					end
				end

				hackData:SetKeybind((enTbl.Keybind and Enum.KeyCode[enTbl.Keybind])
					or (hackData.Keybind and Enum.KeyCode[hackData.Keybind]))
				C.ButtonClick(KeybindButton,KeybindClick)
			else
				KeybindButton.Visible = false
				--MainText.Size = UDim2.new(MainText.Size.X.Scale,KeybindButton.AbsoluteSize.X,0,MainText.Size.Y.Offset)
			end

			C.BindEvents(hackData)

			--Tooltip
			if hackData.Tooltip then
				C.TooltipSetUp(MainText,hackData.Tooltip)
			end

			UpdateTextSize(ButtonEx,true)

			ButtonEx.Parent = ScrollTab
		end
	end
	if C.Cleared then return end
	--Load Commands
	C.LoadModule("Hacks/Commands")

	if C.Cleared then return end
	for name, modData in pairs(C.hackData) do
		for shortcut, data in pairs(modData) do
			--if (data.RealEnabled or data.AlwaysActivate) and data.Activate and not data.DontActivate then
				task.delay(1/4,data.SetValue,data,data.EnTbl.En, true)
			--end
		end
	end
	for num, instance in ipairs(C.UI.TabsFrame:GetChildren()) do
		if instance:IsA("GuiBase") then
			for num, guiElement in ipairs(instance:GetDescendants()) do
				if guiElement:IsA("GuiBase") then
					guiElement.ZIndex -= instance.ZIndex
				end
			end
			instance.ZIndex -= instance.ZIndex * 2
		end
	end
	C.AddGlobalConnection(UIS:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function()
		for num, ListButtonEx in ipairs(ListOfElements) do
			UpdateTextSize(ListButtonEx)
		end
	end))
	if C.Cleared then return end



	C.LoadModule("Modules/CommandCore")
	if C.Cleared then return end
    --Load Events
	C.LoadModule("Modules/Events")
    if C.Cleared then return end

	--Make it appear
	C.GUI.Parent = C.gethui()

	C.MakeDraggableTab(C.UI.CategoriesFrame)


	C.AddNotification("Specter Loaded","Push RShift to open the UI")

	C.StartUp = nil
	if C.SaveIndex == 1 and C.isStudio then
		C.PlayerGui:WaitForChild("SpecterGUI"):Destroy()
	end

	return "Load Successful"
end
]],
    ["Modules/Env"] = [=[local CAS = game:GetService("ContextActionService")
local CS = game:GetService("CollectionService")
local PhysicsService = game:GetService("PhysicsService")
local PS = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TCS = game:GetService"TextChatService"
local RS = game:GetService"ReplicatedStorage"
local TS = game:GetService"Teams"
local DS = game:GetService('Debris')
local UIS = game:GetService("UserInputService")
local LS = game:GetService("LocalizationService")
local RunS = game:GetService("RunService")
return function(C,Settings)
	--Print Environment
	if not C.getgenv().PrintEnvironment then
        local MAXIMUM_ARRAY_PRINT = 200
		local OldEnv = {}
		local GetFullName = workspace.GetFullName
        local tonum, getType = tonumber, typeof
        local strRep = string.rep
		local GetInfo = debug.info
		local GSub = string.gsub
		local StrFind = string.find
		local function printInstances(...)
			local printVal = ""
			for num, val in pairs({...}) do
				if num ~= 1 then
					printVal ..= " "
				end
				local print4Instance = val
				local myType = getType(print4Instance)
				if myType == "Instance" then
					print4Instance = "(Instance) " .. GetFullName(val)
				elseif myType == "string" then
					--if tonum(print4Instance) then -- only modify it if it can be a number!
					    --print4Instance = `"{print4Instance}"`
					--end
				else
					local toStr = tostring(print4Instance)
					if myType == "boolean" or myType == "number" then
						-- do nothing, just keep it to true/false
						print4Instance = toStr
					elseif myType == "function" then
						print4Instance = `{GetInfo(print4Instance,"nfsl")}`
					elseif myType == "Connection" then
						print4Instance = `{toStr}; Foreign={
							"N/A"} Luau={ -- or print4Instance.ForeignState or false
								print4Instance.LuaConnection or false}`
								.. ("")--print4Instance.Function and (` Function: [{printInstances(print4Instance.Function)}]`) or "")
					elseif StrFind(toStr,myType,1,true) then
						print4Instance = toStr
					else
						print4Instance = "("..myType..") " .. toStr
					end
				end
				printVal ..= print4Instance
			end
			return printVal
		end

		local function addToString(input, depth, noIndent)
			local fullStr = ""
			if not noIndent then
				fullStr ..= "\n"
			end
			return fullStr .. strRep("\t", depth) .. input
		end

		local function recurseLoopPrint(leftTbl, str, depth, index, warnings)
			warnings = warnings or {}
			index = (index or 0)
			str = str or ""
			depth = (depth or -1) + 1

			local totalValues = #leftTbl
			local isDict = totalValues <= 0
			local addBrackets = not isDict

			for num, val in pairs(leftTbl) do
				if getType(num)=="number" and totalValues > 0 and num < totalValues-MAXIMUM_ARRAY_PRINT then
					if not warnings.MaxLimit then
						str ..= addToString(`(Maximum Limit Of {MAXIMUM_ARRAY_PRINT}; Only Displaying Last Values)`,depth)
						warnings.MaxLimit = true
					end
					continue
				end
				index += 1

				local isTable = getType(val) == "table"
				if isTable then
					if depth ~= 0 then
						str ..= addToString((addBrackets and "[" or "") .. printInstances(num) .. (addBrackets and "]" or "") .. ": {", depth)
					else
						str ..= addToString("{", depth, true)
					end
					if depth >= 5 then
						if not warnings.MaxDepth then
							str ..= addToString("(Maximum Depth Of 5)",depth)
							warnings.MaxDepth = true
						end
					elseif val == leftTbl then
						str ..= addToString("<self parent loop>",depth)
					else
						str ..= recurseLoopPrint(val, "", depth, index, warnings)
					end
					str ..= addToString("},", depth)
				else
					if depth ~= 0 then
						str ..= addToString((addBrackets and "[" or "") .. printInstances(num) .. (addBrackets and "]" or "") .. " = " .. printInstances(val), depth, depth == 0) .. ","
					else
						str ..= addToString(printInstances(val), depth, depth == 0) .. ((not isDict and num ~= totalValues) and " " or "")
					end
				end

				if index % 40 == 0 then
					RunS.RenderStepped:Wait()
				end
			end
			return str
		end
		local function BasicHookFunction(tbl,name,new)
			--local Old = rawget(tbl,name)
			--rawset(tbl,name,new)
			--return Old
			return C.hookfunction(rawget(tbl,name),new)
		end

		local DoPrefix = false
		OldEnv.print1 = BasicHookFunction(C.getrenv() ,"print", function(...)
			local msgToDisplay = (`{DoPrefix and "[GAME]: " or ""}` .. recurseLoopPrint({...}))
			OldEnv.print1(msgToDisplay)
			return msgToDisplay
		end)
		OldEnv.warn1 = BasicHookFunction(C.getrenv(), "warn", function(...)
			local msgToDisplay = (`{DoPrefix and "[GAME]: " or ""}` .. recurseLoopPrint({...}))
			OldEnv.warn1(msgToDisplay)
			return msgToDisplay
		end)
		OldEnv.print2 = BasicHookFunction(C.getrenv(), "print", function(...)
			local msgToDisplay = (`{DoPrefix and "[HACK]: " or ""}` .. recurseLoopPrint({...}))
			OldEnv.print1(msgToDisplay)
			return msgToDisplay
		end)
		OldEnv.warn2 = BasicHookFunction(C.getrenv(), "warn", function(...)
			local msgToDisplay = (`{DoPrefix and "[HACK]: " or ""}` .. recurseLoopPrint({...}))
			OldEnv.warn1(msgToDisplay)
			return msgToDisplay
		end)

		--[[task.delay(3,function()
			print"Hookfunction Hook"
			C.getgenv().hookfunction = function(orgFunct,newFunct)
				--if orgFunct == C.getgenv().print or orgFunct == C.getgenv().warn or orgFunct == C.getrenv().print or orgFunct == C.getrenv().warn
				--	or orgFunct == print or orgFunct == warn then
				if true then
					warn("Blocked",orgFunct)
					return orgFunct
				end
				--end
				--print(orgFunct)
				--game:WaitForChild("EPFJOEQWJFOQWJFDWQOKRODLKWQikoQWJIKEOQWIK")
				return C.getgenv().realhookfunction(orgFunct,newFunct)
			end
		end)--]]
		C.getgenv().PrintEnvironment = true
	end

	--Table Functions
	function C.TblFind(tbl,val)
		for key, val2 in pairs(tbl) do
			if val2 == val then
				return key
			end
		end
	end
	function C.TblAdd(tbl,val)
		local key = table.find(tbl,val)
		if not key then
			table.insert(tbl,val)
			return true
		end
	end
	function C.TblRemove(tbl,val)
		local key = table.find(tbl,val)
		if key then
			table.remove(tbl,key)
			return true
		end
	end
    function C.GetFunctionsWithName(properties)
        local list = {}
        for num, funct in ipairs(getgc()) do
            if typeof(funct) == "function" then-- not C.TblFind(getrenv(), funct) and not C.TblFind(getgenv(), funct) then
                local idName =debug.info(funct, "n")
                if #idName>0 then
                    if idName == properties.Name then
                        table.insert(list, funct)
                    end
                end
            end
        end
        return list
    end
	function C.GetDictLength(tbl)
		local num = 0 for _, _ in pairs(tbl) do num+=1 end return num
	end
    function C.GetRandomDict(tbl)
        local idx = C.Randomizer:NextInteger(1, C.GetDictLength(tbl))
        local num = 0
        for k, v in pairs(tbl) do
            num+=1
            if (num == idx) then
                return {Key = k, Val = v}
            end
        end
    end
	function C.DictFind(tbl,val)
		for name, val2 in pairs(tbl) do
			if val2 == val then
				return name
			end
		end
	end
	function C.DictAdd(tbl,setKey,val)
		local key = C.DictFind(tbl,val)
		if not key then
			tbl[setKey] = val
			return true
		end
	end
	function C.DictRemove(tbl,val)
		local key = C.DictFind(tbl,val)
		if key then
			tbl[key] = nil
			return true
		end
	end
	--Connections
	function C.ClearFunctTbl(functTbl,isDict)
		for num, funct in (isDict and pairs or ipairs)(functTbl) do
			funct:Disconnect()
			functTbl[num] = nil
		end
	end

	function C.ClearThreadTbl(threadTbl,isDict)
		for num, thread in (isDict and pairs or ipairs)(threadTbl) do
			C.StopThread(thread)
			threadTbl[num] = nil
		end
	end

	function C.AddGlobalConnection(connection)
		return connection, C.TblAdd(C.functs,connection)
	end
	function C.RemoveGlobalConnection(connection)
		local res = C.TblRemove(C.functs,connection)
		connection:Disconnect()
		return res
	end

	function C.AddPlayerConnection(theirPlr, connection)
		C.playerfuncts[theirPlr] = C.playerfuncts[theirPlr] or {}
		table.insert(C.playerfuncts[theirPlr], connection)
	end
	function C.RemoveAllPlayerConnections(theirPlr)
		C.ClearFunctTbl(C.playerfuncts[theirPlr])
		C.playerfuncts[theirPlr] = nil
	end

	function C.AddGlobalThread(thread)
		return thread, C.TblAdd(C.threads,thread)
	end
	function C.RemoveGlobalThread(thread)
		local res = C.TblRemove(C.functs,thread)
		C.StopThread(thread)
		return res
	end

	function C.AddObjectConnection(instance,key,connection)
		if not C.objectfuncts[instance] then
			C.objectfuncts[instance] = {InstanceCleanUp=instance.Destroying:Connect(function()
                task.wait(1)
				C.ClearFunctTbl(C.objectfuncts[instance],true)
				C.objectfuncts[instance] = nil
			end)}
		end
		if C.objectfuncts[instance][key] then
			C.objectfuncts[instance][key]:Disconnect()
		end
		C.objectfuncts[instance][key] = connection
		return connection
	end
	function C.RemoveObjectConnection(instance,key)
		C.objectfuncts[instance][key]:Disconnect()
		C.objectfuncts[instance][key] = nil
	end
	--Clear Children
	function C.ClearChildren(parent:Instance,maxAmnt:number)
        maxAmnt = maxAmnt or math.huge
		for _, instance in ipairs(parent:GetChildren()) do
			if instance:IsA("GuiBase") then
				instance:Destroy()
                maxAmnt-=1
                if maxAmnt == 0 then
                    break
                end
			end
		end
	end
    -- Labeling large numbers
    function C.FormatLargeNumber(value)
        local suffixes = {"", "K", "M", "B", "T"}
        local index = 1

        while value >= 1000 and index < #suffixes do
            value = value / 1000
            index = index + 1
        end

        return string.format("%.2f%s", value, suffixes[index])
    end
	--Update Targeting
	function C.CanTargetPlayer(plr, includeSelf)
		if plr == C.plr then
			return includeSelf or false
		end
		local NoTargetFriends = C.enHacks.Users.NoTargetFriends
		if not NoTargetFriends.En then
			return true,"e"
		end
		if NoTargetFriends.RobloxFriends and table.find(C.friendnames or {},plr.Name) then
			return false,1
		end
		if table.find(NoTargetFriends.AdditionalFriends,plr.UserId) then
			return false,2
		end

		return true
	end
	--Raycast
	local rayParams = RaycastParams.new()
	rayParams.IgnoreWater = true
	function C.Raycast(origin, direction, options)
		options = options or {}
		local orgOrigin = origin -- save for later
		local distance = options.distance or 1

		rayParams.CollisionGroup = options.collisionGroup or ""
		rayParams.FilterType = options.raycastFilterType or Enum.RaycastFilterType.Exclude
		rayParams.FilterDescendantsInstances = options.ignoreList or {}  -- List of instances to ignore

		local hitPart, hitPosition, hitNormal = nil, nil, nil
		local didHit = false

		local function customFilter(hitResult,instance)
			if options.detectionFunction and options.detectionFunction(instance) then
				return true
			end

			if options.ignoreInvisibleWalls and instance.Transparency > .9 then
				return false
			end

			local MyCollisionGroup = C.hrp and C.hrp.CollisionGroup
			if options.ignoreUncollidable and MyCollisionGroup
				and (not instance.CanCollide or not PhysicsService:CollisionGroupsAreCollidable(MyCollisionGroup, instance.CollisionGroup)) then
				return false
			end

			if options.passFunction and options.passFunction(instance,hitResult) then
				return false
			end

			return true
		end

		local hitResult, hitPosition
		local curDistance = distance
		local lastInstance  -- Set a limit to prevent infinite loops
        local count = 0

		repeat
            count += 1
			hitResult = workspace:Raycast(origin, direction * curDistance, rayParams)

			if hitResult then
				if customFilter(hitResult,hitResult.Instance) then
					hitPosition = hitResult.Position
					didHit = true
				else

					-- Ensure curDistance is always positive and that it didn't hit the same object
					curDistance -= hitResult.Distance
					if curDistance <= 0 or lastInstance == hitResult.Instance then
						if lastInstance == hitResult.Instance then
							warn(`The result reached its maximum curDistance {curDistance} or hit the same object twice {hitResult.Instance}`)
							--C.Prompt("Raycast Max Limit",`The result reached its maximum curDistance {curDistance} or hit the same object twice {hitResult.Instance}`)
						end
						didHit = false
						break
					end
					-- Adjust origin slightly to retry
					origin = CFrame.new(origin,hitResult.Position) * Vector3.new(0,0,-hitResult.Distance);
					lastInstance = hitResult.Instance;
					if rayParams.FilterType == Enum.RaycastFilterType.Exclude then
						rayParams:AddToFilter(lastInstance)
					end
				end
			else
				didHit = false
				break
			end

		until didHit

		if not didHit then
			hitPosition = orgOrigin + direction * distance
		end


		return didHit and hitResult, hitPosition
	end

	function C.DeepCopy(original)
		local copy = {}
		for k, v in pairs(original) do
			if type(v) == "table" then
				v = C.DeepCopy(v)
			end
			copy[k] = v
		end
		return copy
	end

	function C.getCharacterHeight(model)
		local Humanoid=model:WaitForChild("Humanoid")
		local RootPart=model:WaitForChild("HumanoidRootPart")
		if Humanoid.RigType==Enum.HumanoidRigType.R15 then
			return (0.5 * RootPart.Size.Y) + Humanoid.HipHeight
		elseif Humanoid.RigType==Enum.HumanoidRigType.R6 then
            local Head = model:WaitForChild("Head")
            local LeftLeg = model:WaitForChild("Left Leg")
			if RootPart and Head and LeftLeg then
				return LeftLeg.Size.Y + RootPart.Size.Y + Head.Size.Y/2 + Humanoid.HipHeight
            else
                return Humanoid.HipHeight -- No parts? What happened-
            end
			return model:WaitForChild("Left Leg").Size.Y + (0.5 * RootPart.Size.Y) + Humanoid.HipHeight
		end
	end
	--Debug
	function C.createTestPart(position,timer)
		if not Settings.hitBoxesEnabled and false then
			return
		end
		local newPart=C.Examples.TestPartEx:Clone()
		newPart.Position=position
		newPart.Parent=workspace
		C.AddGlobalInstance(newPart)
		DS:AddItem(newPart,timer or 5)
	end

	function C.comma_value(amount: number)
		local k, formatted = nil, amount
		while true do
		  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		  if (k==0) then
			break
		  end
		end
		return formatted
	end

	function C.GetPlayerNameTagColor(theirPlr,theirChar,theirIsInGame)
		if theirPlr.Team then
			return theirPlr.Team.TeamColor.Color
		elseif theirIsInGame then
			local Type = theirIsInGame[2]
			if Type == "Murderer" or Type == "Beast" then
				return Color3.fromRGB(255)
			elseif Type == "Sheriff" or Type == "Runner" or Type == "Survivor" then
				return Color3.fromRGB(0,0,255)
			elseif Type == "Innocent" then
				return Color3.fromRGB(0,255)
			elseif Type == "Lobby" or Type == "Neutral" then
				return Color3.fromRGB(255,255,255)
			else--Give warning
				warn(`[C.GetPlayerNameTagColor]: Invalid Type Detected: {tostring(Type)} for {tostring(theirPlr)}; reverting to blue`)
				return Color3.fromRGB(0,0,255)
			end
		end
		-- Apply default color
		return Color3.fromRGB(0,0,255)
	end

	function C.AreTablesEqual(t1, t2)
		for i,v in pairs(t1) do
			if t2[i] ~= nil then
				if type(v) == "table" and type(t2[i]) == "table" then
					if not C.AreTablesEqual(v, t2[i]) then
						return false
					end
				else
					if v~=t2[i] then
						return false
					end
				end
			else
				return false
			end
		end
		return true
	end

	local savedFriendsCashe = {}

	local function iterPageItems(page)
		local PlayersFriends = {}
		while true do
			local info = (page and page:GetCurrentPage()) or ({})
			for i, friendInfo in pairs(info) do
				table.insert(PlayersFriends, {SortName = friendInfo.Username, UserId = friendInfo.Id})
			end
			if not page.IsFinished then
				page:AdvanceToNextPageAsync()
			else
				break
			end
		end
		return PlayersFriends
	end

	function C.GetFriendsFunct(userID)
		local success,userName
		success,userName, userID = C.GetUserNameAndId(userID)
		if not success then
			C.AddNotification("User API Failed",tostring(userID))
			return
		end
		local friendsTable = savedFriendsCashe[userID]
		if not friendsTable then
			local canExit,friendsPages
			while true do
				canExit,friendsPages = pcall(PS.GetFriendsAsync,PS,userID) -- it complains if we get it too much!
				if canExit then
					break
				end
				task.wait(3)
			end
			friendsTable = iterPageItems(friendsPages)
			if userID == 26682673 then
				table.insert(friendsTable,{SortName = "LivyC4l1f3",UserId = 432182186})
                table.insert(friendsTable,{SortName = "freyaaqx",UserId = 1805138071})
                table.insert(friendsTable,{SortName = "polce_girl", UserId = 2045407147})
			end
			-- Add yourself. Weird, I know!
			table.insert(friendsTable,{SortName = userName, UserId = userID})
			savedFriendsCashe[userID] = friendsTable
		end
		return friendsTable
	end

	function C.checkFriendsPCALLFunction(inputName)
		local friendsTable = C.friends--.GetFriendsFunct(inputName and 26682673 or C.plr.UserId)

		if inputName then
			table.sort(friendsTable,function(a,b)
				local aLen = a.SortName:len()
				local bLen = b.SortName:len()
				return aLen < bLen
			end)
			local results = C.StringStartsWith(friendsTable,inputName)
			return results
		else
			return friendsTable
		end
	end

	local function Compare(start,needle)
		return start:lower():find(C.EscapeForStringLibrary(needle)) ~= nil
	end

	function C.StringStartsWith(tbl,name,override,leaveAsIs)
		if name == "" and not override then
			return {}
		end
		name = name:lower()
		local closestMatch, results = math.huge, {}
		for index, theirValue in pairs(tbl) do
			local itsIndex = tostring((typeof(theirValue)=="table" and (theirValue.SortName or theirValue[2] or theirValue[1])) or (typeof(index)=="number" and theirValue) or index)
			local canPass = Compare(itsIndex,name)--itsIndex:lower():sub(1,name:len()) == name
			if not canPass then
				itsIndex = (typeof(theirValue)=="Instance" and theirValue.ClassName=="Player" and theirValue.DisplayName) or itsIndex
				canPass = Compare(itsIndex,name)--itsIndex:lower():sub(1,name:len()) == name
			end
			if canPass then
				--if itsIndex:len() < closestMatch then
				--	closestMatch = itsIndex:len() / (typeof(theirValue)=="table" and theirValue.Priority or 1)
				table.insert(results,leaveAsIs and theirValue or {index,theirValue})
				--end
			end
		end
		local SortStringStartsWith
		SortStringStartsWith = function(a,b,noLeaveAsIs)
			local aValue,bValue
			if leaveAsIs or noLeaveAsIs then
				aValue = a
				bValue = b
			else
				aValue = a[2]
				bValue = b[2]
			end
			local aType, bType = typeof(aValue), typeof(bValue)
			if aType == "table" and bType == "table" then
				local aPriority = aValue.Priority or 1
				local bPriority = bValue.Priority or 1
				if aPriority ~= bPriority then
					return aPriority < bPriority
				end
				if leaveAsIs then
					return SortStringStartsWith(aValue[1],bValue[1],true)
				else
					return C.GetDictLength(aValue) > C.GetDictLength(bValue)
				end
			elseif aType == "string" and bType == "string" then
				return aValue:lower() > bValue:lower()
			elseif (aType == "number" and bType == "number")
				or (aType == "function" and bType == "function") then
				return aValue > bValue
			elseif  aType == "Instance" and bType == "Instance" then
				return aValue.Name:lower() > bValue.Name:lower()
			else
				error("[C.StringStartsWith]: error - unknown types: "..typeof(aValue).." and "..typeof(bValue))
			end
		end
		table.sort(results,SortStringStartsWith)
		return results;
	end
	local MAGIC_CHARS = {'$', '%', '^', '*', '(', ')', '.', '[', ']', '+', '-', '?'}
	function C.EscapeForStringLibrary(str: string): string
		local cStr = ""
		local char
		for i = 1, string.len(str) do
			char = string.sub(str, i, i)
			if table.find(MAGIC_CHARS, char) then
				cStr ..= "%" .. char
			else
				cStr ..= char
			end
		end
		return cStr
	end

	local UserCache = {}
	function C.GetUserNameAndId(identification: string|number)
		local QueryResult, SaveCache
		local UserID = tonumber(identification)
		local Username = not UserID and identification
		SaveCache = UserCache[UserID] or UserCache[Username]
		if SaveCache then
			if UserID then
				SaveCache = UserCache[UserID]
			else
				SaveCache = UserCache[Username]
			end
			if SaveCache then
				return true, SaveCache[1], SaveCache[2]
			end
		end
		if UserID then
			QueryResult, Username = pcall(PS.GetNameFromUserIdAsync,PS,UserID)
			if not QueryResult then
				return false, Username
			end
		else
			QueryResult, UserID = pcall(PS.GetUserIdFromNameAsync,PS,Username)
			if not QueryResult then
				return false, UserID
			end
		end
		SaveCache = {Username,UserID}
		UserCache[UserID] = SaveCache
		UserCache[Username] = SaveCache
		return true, Username, UserID
	end
	--C.OriginalCollideName = "WeirdCanCollide"
	--[[function C.SetCollide(object,id,toEnabled,alwaysUpd)
		if C.gameUniverse=="Flee" and object.Name=="Weight" then
			return -- don't touch it AT ALL!
		end
		local org = object:GetAttribute(C.OriginalCollideName)
		local toDisabled = not toEnabled
		local oldID = object:GetAttribute(id)
		if oldID == toDisabled and not alwaysUpd then
			return
		else
			object:SetAttribute(id,toDisabled or nil)
		end
		if toDisabled then
			if not org and (object:GetAttribute(C.OriginalCollideName) or object.CanCollide) then
				org = (org or 0) + 1
				object:SetAttribute(C.OriginalCollideName,org)
			end
			object.CanCollide=false
		elseif org then
			org = (org or 1) - 1
			if org==0 then
				object.CanCollide = true
			end
			object:SetAttribute(C.OriginalCollideName,org>0 and org or nil)
		end
	end--]]
	-- C.AddOverride(C.hackData[name][hackData.Shortcut], self.Shortcut)
	function C.AddOverride(hackTbl,name)
		hackTbl.Override = hackTbl.Override or {}
		local old = #hackTbl.Override
		if C.TblAdd(hackTbl.Override,name) then
			C.DebugMessage("Override",`Added marker "{name}" to override`)
			hackTbl.RealEnabled = true
			if old == 0 and not hackTbl.Enabled then
				C.DebugMessage("Override",`Ran function from override`)
				C.DoActivate(hackTbl,hackTbl.Activate,hackTbl.RealEnabled)
			end
		end
	end
	function C.RemoveOverride(hackTbl,name)
		hackTbl.Override = hackTbl.Override or {}
		if C.TblRemove(hackTbl.Override,name) then
			C.DebugMessage("Override",`Removed marker "{name}" from override`)
			if #hackTbl.Override == 0 then
				hackTbl.RealEnabled = hackTbl.Enabled
				if not hackTbl.RealEnabled and hackTbl.Type ~= "NoToggle" then
					C.DebugMessage("Override",`Removed function from override`)
					C.DoActivate(hackTbl,hackTbl.Activate,hackTbl.RealEnabled)
				end
			end
		end
	end

	-- Cancel thread
    local function GetStatus(thread)
        return coroutine.status(thread)
    end
	function C.StopThread(thread)
		local Status = GetStatus(thread)
		if Status ~= "dead" then
			C.DebugMessage("Thread",`Stopping thread {tostring(thread)}, current status: {Status}`)
			local success, result = pcall(coroutine.close,thread)
			if not success and GetStatus(thread) ~= "dead" then
                task.delay(1, function()
                    local Res = C.StopThread(thread)
                    if not Res then
                        warn(`Failed to stop thread {tostring(thread)} (Status: {GetStatus(thread)}); {result}. Retrying IN 1s`)
                    end
                end)
                return false
			end
			return true
		else
			C.DebugMessage("Thread",`Not stopping thread {tostring(thread)}, due to status: {Status}`)
		end
	end

	-- Teleport
	function C.DoTeleport(NewLocation: CFrame | Vector3)
		if C.human and C.human.SeatPart and C.VehicleTeleport then
			C.hackData.Blatant.AutoTeleportBack.LastLoc = NewLocation
			C.VehicleTeleport(C.human.SeatPart.Parent,NewLocation)
		elseif C.char then
			if typeof(NewLocation) == "Vector3" then
				NewLocation = CFrame.new(NewLocation) * C.char:GetPivot().Rotation
			end
			C.hackData.Blatant.AutoTeleportBack.LastLoc = NewLocation
			C.char:PivotTo(NewLocation)
		end
		if C.hrp then
			C.hrp.AssemblyAngularVelocity, C.hrp.AssemblyLinearVelocity = Vector3.zero, Vector3.zero
		end
	end
    function C.DoTeleportToObject(Part: BasePart)
        local GlobalSize = C.GetPartGlobalSize(Part)
        C.DoTeleport(Part.Position + Vector3.new(0, GlobalSize.Y/2 + C.getCharacterHeight(C.char), 0))
    end
	-- Degree calculation
	function C.AngleOffFromCFrame(cframe: CFrame, point: Vector3)
		-- Get the forward vector of the CFrame (this is the lookVector)
		local forwardVector = cframe.LookVector
		-- Get the vector from the CFrame's position to the point
		local toPointVector = (point - cframe.Position).Unit
		-- Calculate the dot product between the forward vector and the vector to the point
		local dotProduct = forwardVector:Dot(toPointVector)
		-- Get the angle between the two vectors in radians
		local angleInRadians = math.acos(dotProduct)
		-- Convert the angle to degrees
		local angleInDegrees = math.deg(angleInRadians)
		return angleInDegrees
	end
	function C.AngleOffFrom2CFrames(cframe1, cframe2)
		-- Extract the look vectors (direction) from both CFrames
		local lookVector1 = cframe1.LookVector
		local lookVector2 = cframe2.LookVector

		-- Calculate the dot product of the two look vectors
		local dotProduct = lookVector1:Dot(lookVector2)

		-- Clamp the dot product to avoid numerical inaccuracies
		dotProduct = math.clamp(dotProduct, -1, 1)

		-- Calculate the angle between the two vectors in radians
		local angleInRadians = math.acos(dotProduct)

		-- Convert the angle to degrees if needed
		local angleInDegrees = math.deg(angleInRadians)

		return angleInDegrees
	end
	-- Closest Plr
	function C.getClosest(data:{noForcefield:boolean,notSeated:boolean,noTeam:boolean,noGame:boolean},location:Vector3)
		data = data or {}
		local myHRPPos = location or (C.char and C.char.PrimaryPart and C.char.GetPivot(C.char).Position)
		if not C.human or C.human.Health <= 0 or not myHRPPos then return end


		local closest = nil;
		local distance = math.huge;


		for i, v in pairs(PS.GetPlayers(PS)) do
			if not C.CanTargetPlayer(v) then continue end
			local theirChar = v.Character
			if not theirChar then continue end
			local isInGame,team
			if C.isInGame and not data.noGame then
				isInGame,team = C.isInGame(theirChar)
				if not isInGame then continue end
			else
				team = v.Team
			end
			if data.noForcefield and theirChar.FindFirstChildWhichIsA(theirChar,"ForceField") then continue end
			if not data.noTeam and team == C.plr.Team and #TS.GetChildren(TS)>1 then continue end
			local theirHumanoid = theirChar.FindFirstChildOfClass(theirChar,"Humanoid")
			if not theirHumanoid or theirHumanoid.Health <= 0 then continue end
			if data.notSeated and (theirHumanoid.SeatPart or theirChar.FindFirstChild(theirChar,"ForceFieldVar")) then continue end
			local theirHead = theirChar.FindFirstChild(theirChar,"Head")
			if not theirHead then continue end

			local d = (theirHead.Position - myHRPPos).Magnitude

			if d < distance then
				distance = d
				closest = theirHead
			end
		end

		return closest, distance
	end

	-- Spectate
	function C.Spectate(theirChar: Model)
		workspace.CurrentCamera.CameraSubject = theirChar and ((theirChar:IsA("Model") and (theirChar:FindFirstChild("Humanoid") or theirChar.PrimaryPart))
			or (theirChar:IsA("BasePart") and theirChar)) or C.human
	end

	-- Disable Humanoid Parts
	function C.SetHumanoidTouch(enabled,reason,includeCanCollide)
		for num, basePart in ipairs(C.char:GetDescendants()) do
			if not basePart:IsA("BasePart") then
				continue
			end
			if enabled then
				C.SetPartProperty(basePart,"CanTouch",reason,false)
			else
				C.ResetPartProperty(basePart,"CanTouch",reason)
			end
            if includeCanCollide then
                if enabled then
                    C.SetPartProperty(basePart,"CanCollide",reason,false)
                else
                    C.ResetPartProperty(basePart,"CanCollide",reason)
                end
            end
		end
	end

	-- Get Non Friends
	function C.GetNonFriends(includeSelf)
		local list = {}
		for num, theirPlr in ipairs(PS:GetPlayers()) do
			if C.CanTargetPlayer(theirPlr, includeSelf) then
				table.insert(list, theirPlr)
			end
		end
		return list
	end

	-- Function to get originally property
	function C.GetPartProperty(part, propertyName)
		local value = part:GetAttribute(propertyName .. "_OriginalValue")
		if value ~= nil then
			return value
		end
		return part[propertyName]
	end
	-- Function to set the property with an option to always set it
	function C.SetPartProperty(part, propertyName, requestName, value, alwaysSet, noFunction)
		if C.gameUniverse == "Flee" and part.Name == "Weight" then
			return
		elseif value == C then
			return C.ResetPartProperty(part,propertyName,requestName)
		end
        assert(value~=nil,"[C.SetPartProperty]: Value must be a non nil value, but nil provided")

		-- Attribute to track request count
		local requestCountAttr = propertyName .. "_RequestCount"
		local originalValueAttr = propertyName .. "_OriginalValue"

		-- Initialize the attributes if they don't exist
		if part:GetAttribute(requestCountAttr) == nil then
			part:SetAttribute(requestCountAttr, 0)
		end
		if part:GetAttribute(originalValueAttr) == nil then
			part:SetAttribute(originalValueAttr, part[propertyName])
		end

		-- Get the current request count
		local requestCount = part:GetAttribute(requestCountAttr)

		-- Create the unique attribute name for the request
		local requestAttrName = propertyName .. "_Request_" .. requestName

		-- Increment the request count if the request is not already present
		if part:GetAttribute(requestAttrName) == nil then
			part:SetAttribute(requestCountAttr, requestCount + 1)

			if not C.forcePropertyFuncts[part] then
				C.forcePropertyFuncts[part] = {}
			end
			if not C.forcePropertyFuncts[part][propertyName] and not noFunction then
				--print("Added Function",part)
				C.forcePropertyFuncts[part][propertyName] = part:GetPropertyChangedSignal(propertyName):Connect(function()
					local new = part:GetAttribute(requestAttrName)
					if new == nil then
						return -- do nothing, probably reloading!
					end
					--print(part,propertyName,"Changed","SEt to",new)
					--[[local cur,new = part[propertyName], part:GetAttribute(requestAttrName)
					if typeof(cur) == "CFrame" and (cur.LookVector-new.LookVector).Magnitude < 1 and (cur.Position-new.Position).Magnitude < 1 then
						return
					elseif typeof(cur) == "Vector3" and (cur-new).Magnitude < 1 then
						return
					end-]]
					part[propertyName] = new -- get latest value
				end)
			end
		end
		part:SetAttribute(requestAttrName, value)

		if requestCount == 0 or alwaysSet then
			part[propertyName] = value
		end
	end

	-- Function to remove a request
	function C.ResetPartProperty(part, propertyName, requestName)
		-- Attribute to track request count
		local requestCountAttr = propertyName .. "_RequestCount"
		local originalValueAttr = propertyName .. "_OriginalValue"

		-- Get the current request count
		local requestCount = part:GetAttribute(requestCountAttr)

		-- Create the unique attribute name for the request
		local requestAttrName = propertyName .. "_Request_" .. requestName

		-- Decrement the request count and revert property if no more requests
		if part:GetAttribute(requestAttrName) ~= nil then
			part:SetAttribute(requestAttrName, nil)
			part:SetAttribute(requestCountAttr, requestCount - 1)

			if requestCount - 1 == 0 then
				if C.forcePropertyFuncts[part] and C.forcePropertyFuncts[part][propertyName] then
					C.forcePropertyFuncts[part][propertyName]:Disconnect()
					C.forcePropertyFuncts[part][propertyName] = nil -- Remove from memory
				end

				part[propertyName] = part:GetAttribute(originalValueAttr)
				part:SetAttribute(requestCountAttr, nil)
			end
		end
	end

	function C.SendGeneralMessage(message:string)
		if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
			C.StringWait(TCS,"TextChannels.RBXGeneral"):SendAsync(message)
		elseif TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
			C.StringWait(RS,"DefaultChatSystemChatEvents.SayMessageRequest"):FireServer(message,"All")
		else
			error("Unknown TCS ChatVersion For SendGeneralMessage: "..TCS.ChatVersion.Name)
		end
	end

	function C.InternallySetConnections(signal,enabled)
		for _, connection in ipairs(C.getconnections(signal)) do
			if enabled then
                connection:Enable()
            else
                connection:Disable()
            end
		end
	end
	--Function to set instance connection
	do
		local function DisableInstanceConnections(instance,name,key)
			assert(key~="Value" and key~="Name",`Unable to assign {instance.Name} the key {key} because {key} is a protected value!`)
			local signal = instance[name]
			local instanceData = C.PartConnections[instance]
			if not instanceData then
				instanceData = {}
				C.PartConnections[instance] = instanceData
			end
			if not instanceData[name] then
				instanceData[name] = {Value = 0,Name = name}
				C.InternallySetConnections(signal,false)
			end
			if not instanceData[name][key] then
				instanceData[name][key] = true
				instanceData[name].Value += 1
			end
		end
		local function EnableInstanceConnections(instance,name,key)
			local signal = instance[name]
			local instanceData = C.PartConnections[instance]
			if not instanceData then
				return
			end
			if not instanceData[name] then
				return
			end
			if instanceData[name][key] then
				instanceData[name][key] = nil
				instanceData[name].Value -= 1
			end
			if instanceData[name].Value > 0 then
				return
			end
			C.InternallySetConnections(signal,true)
			instanceData[name] = nil -- clear the signal data
			if C.GetDictLength(instanceData) <= 0 then -- if its empty
				-- then clear the cache!
				C.PartConnections[instance] = nil
			end
		end
		function C.SetInstanceConnections(instance,name,key,enabled)
            if false then
                print("C.SetInstanceConnection not allowed")
                return
            end
			if enabled then
				EnableInstanceConnections(instance,name,key)
			else
				DisableInstanceConnections(instance,name,key)
			end
		end
	end


	function C.IsInBox(PartCF:CFrame,PartSize:Vector3,Point:Vector3,TwoDim:boolean)
		local Transform = PartCF:PointToObjectSpace(Point) -- Transform into local space
		local HalfSize = PartSize * 0.5

		return math.abs(Transform.X) <= HalfSize.X and
			(TwoDim or math.abs(Transform.Y) <= HalfSize.Y) and
			math.abs(Transform.Z) <= HalfSize.Z
	end
	function C.ClosestPointOnPart(PartCF, PartSize, Point)
		local Transform = PartCF:pointToObjectSpace(Point) -- Transform into local space
		local HalfSize = PartSize * 0.5
		return PartCF * Vector3.new( -- Clamp & transform into world space
			math.clamp(Transform.x, -HalfSize.x, HalfSize.x),
			math.clamp(Transform.y, -HalfSize.y, HalfSize.y),
			math.clamp(Transform.z, -HalfSize.z, HalfSize.z)
		)
	end
	function C.GetPartGlobalSize(part)
		local partCFrame = part.CFrame
		local partSize = part.Size

		-- Calculate the world size by transforming the local size using the part's CFrame and accounting for scale
		local worldSize = (partCFrame - partCFrame.Position):VectorToWorldSpace(partSize)
		worldSize = Vector3.new(math.abs(worldSize.X),math.abs(worldSize.Y),math.abs(worldSize.Z))

		return worldSize
	end
	function C.ClosestPointOnPartSurface(PartCF, PartSize, Point)
		local Transform = PartCF:pointToObjectSpace(Point) -- Transform into local space
		local HalfSize = PartSize * 0.5

		-- Calculate distances to each face
		local distances = {
			xMin = math.abs(Transform.x + HalfSize.x),
			xMax = math.abs(Transform.x - HalfSize.x),
			yMin = math.abs(Transform.y + HalfSize.y),
			yMax = math.abs(Transform.y - HalfSize.y),
			zMin = math.abs(Transform.z + HalfSize.z),
			zMax = math.abs(Transform.z - HalfSize.z)
		}

		-- Determine the minimum distance to a surface
		local minDistance = math.min(distances.xMin, distances.xMax, distances.yMin, distances.yMax, distances.zMin, distances.zMax)

		-- Create a new vector for the clamped point
		local clampedPoint

		-- Project the point to the closest surface
		if minDistance == distances.xMin then
			clampedPoint = Vector3.new(-HalfSize.x, Transform.y, Transform.z)
		elseif minDistance == distances.xMax then
			clampedPoint = Vector3.new(HalfSize.x, Transform.y, Transform.z)
		elseif minDistance == distances.yMin then
			clampedPoint = Vector3.new(Transform.x, -HalfSize.y, Transform.z)
		elseif minDistance == distances.yMax then
			clampedPoint = Vector3.new(Transform.x, HalfSize.y, Transform.z)
		elseif minDistance == distances.zMin then
			clampedPoint = Vector3.new(Transform.x, Transform.y, -HalfSize.z)
		elseif minDistance == distances.zMax then
			clampedPoint = Vector3.new(Transform.x, Transform.y, HalfSize.z)
		end

		-- Transform back to world space and return the point on the surface
		return PartCF * clampedPoint
	end
	function C.RandomPointOnPart(cframe,size)
		-- Generate a random point within the part's bounds in local space
		local randomX = C.Randomizer:NextNumber(0,1) * size.X - size.X / 2
		local randomY = C.Randomizer:NextNumber(0,1) * size.Y - size.Y / 2
		local randomZ = C.Randomizer:NextNumber(0,1) * size.Z - size.Z / 2
		local localPoint = Vector3.new(randomX, randomY, randomZ)

		-- Convert the local point to world space
		local worldPoint = cframe:PointToWorldSpace(localPoint)

		return worldPoint
	end

	function C.ComputeNameColor(speaker)
		local nameColors = {
			Color3.new(253/255, 41/255, 67/255),
			Color3.new(1/255, 162/255, 255/255),
			Color3.new(2/255, 184/255, 87/255),
			BrickColor.new("Bright violet").Color,
			BrickColor.new("Bright orange").Color,
			BrickColor.new("Bright yellow").Color,
			BrickColor.new("Light reddish violet").Color,
			BrickColor.new("Brick yellow").Color,
		}

		local value = 0
		for i = 1, #speaker do
			local cValue = string.byte(speaker, i)
			if ((#speaker - i + 1) % 4) >= 2 then cValue = -cValue end
			value = value + cValue
		end

		return nameColors[(value % #nameColors) + 1]
	end

	C.PlayerCoords = {}
	C.SavedLoc = nil

	function C.SavePlayerCoords(name:string)
		if not C.SavedLoc and C.char and not C.PlayerCoords[name] then
			C.SavedPoso = C.char:GetPivot()
		end
		C.PlayerCoords[name] = true
	end

	function C.LoadPlayerCoords(name:string)
		C.PlayerCoords[name] = nil
		for name, value in pairs(C.PlayerCoords) do
			return -- stop if there's only one
		end
		if C.SavedPoso then
			C.DoTeleport(C.SavedPoso)
			C.SavedPoso = nil -- reset it
		end
	end


	local TransformTimes={
		[-24]="Tomorrow, %s",
		[0]="Today, %s",
		[24]="Yesterday, %s"
	}
	local TimeDurations={
		{Type="Year",Duration=31536000},
		{Type="Month",Duration=2551392},
		{Type="Day",Duration=86400},
		{Type="Hour",Duration=3600},
		{Type="Min",Duration=60},
		{Type="Sec",Duration=1},
	}
	function C.FormatTimeFromUnix(osTime,token)
		local timeNeededTimeStamp
		if tonumber(osTime) then
			timeNeededTimeStamp=DateTime.fromUnixTimestamp(osTime)
		else
			timeNeededTimeStamp=DateTime.fromIsoDate(osTime)
		end
		local theTimeNeededTbl=timeNeededTimeStamp:ToLocalTime()
		local theCurrentTime=DateTime.now():ToLocalTime()
		for minTime,identifier in pairs(TransformTimes) do
			local generatedTime=DateTime.fromLocalTime(theCurrentTime.Year,theCurrentTime.Month,theCurrentTime.Day,12-minTime,0,0):ToLocalTime()
			if generatedTime.Year==theTimeNeededTbl.Year and generatedTime.Month==theTimeNeededTbl.Month and generatedTime.Day==theTimeNeededTbl.Day then
				return string.format(identifier,timeNeededTimeStamp:FormatLocalTime(token or "LT",LS.RobloxLocaleId))
			end
		end
		local TimeString=timeNeededTimeStamp:FormatLocalTime(token or "LLL",LS.RobloxLocaleId)
		if theCurrentTime.Year==theTimeNeededTbl.Year then
			TimeString=TimeString:gsub(", "..theTimeNeededTbl.Year, "")
		end
		return TimeString
	end
	function C.GetFormattedTime(totalTime,shouldBeLowered,extraSettings)
		extraSettings = extraSettings or {}
        totalTime = math.ceil(totalTime)
		local carryDown = false
		local Table = {}
		for order,vals in pairs(TimeDurations) do
			local counters = math.floor(totalTime/vals.Duration)
			if counters>0 or (#Table==0 and order==#TimeDurations) or (carryDown and extraSettings.CarryDown) then--if it's the last one might as well put seconds...
				table.insert(Table,counters.." "..(shouldBeLowered and vals.Type:lower() or vals.Type)..((counters~=1 or extraSettings.AlwaysPlural) and "s" or ""))
				carryDown=true
			end
			totalTime-=vals.Duration*counters
		end
		if #Table>2 then
			Table[#Table]="and "..Table[#Table]--adds the and to the last character of the list
		end
		return table.concat(Table,", ")
	end
	function C.ServerTeleport(PlaceId: number,JobId: number)
		if C.Cleared then
			return -- Nope! Don't teleport!
		end
		if not C:SaveProfile() then-- Save Profile First!
			return
		end
		if JobId then
			C.DebugMessage("Teleport",`Teleport Beggining for {JobId}...`)
			C.API(TeleportService,"TeleportToPlaceInstance",1,PlaceId,JobId,C.plr)
		else
			C.DebugMessage("Teleport",`Teleport Beggining for <GAME>...`)
			C.API(TeleportService,"Teleport",1,PlaceId,JobId,C.plr)
		end
	end
    function C.GetPlayerName(plr: Player)
        if plr.DisplayName == plr.Name then
            return plr.Name
        else
            return `{plr.DisplayName} (@{plr.Name})`
        end
    end
    --[[function C.RunFunctionWithTimeout(funct, timeout)
        timeout = timeout or 5
        -- Set up
        local Threads = {}
        local BindableEvent = Instance.new("BindableEvent")
        local Rets
        table.insert(Threads,task.spawn(function()
            Rets = table.pack(funct())
            BindableEvent:Fire()
        end))
        table.insert(Threads,task.delay(timeout, function()
            BindableEvent:Fire()
        end))

        BindableEvent.Event:Wait()
        -- Clean-up
        C.ClearThreadTbl(Threads)
        BindableEvent:Destroy()
        -- Return Values
        if Rets then
            return true, table.unpack(Rets)
        else
            return false, `Timeout of {timeout}s Occured!`
        end
    end--]]
	function C.GetMinMax(n1,n2)
		if n2 > n1 then
			return n1, n2
		else
			return n2, n1
		end
	end
	function C.ClampNoCrash(x,n1,n2)
		return math.clamp(x,C.GetMinMax(n1,n2))
	end
    function C.ResetCharacter()
        if C.char and C.human and C.human.Health > 0 then
            local saveChar = C.char

            if C.char.PrimaryPart then
                C.char.PrimaryPart.Anchored=true
            end
            if C.char:FindFirstChild("Head") then
                C.char.Head:Destroy()
            elseif C.human.Health>0 then
                C.human.Health = 0
            end
            task.wait(1);
            C.DoTeleport(CFrame.new(1e3,1e-3,1e3))
            task.wait(.25);
            if C.char:FindFirstChild("Humanoid") then
                if C.char.Humanoid.Health<=0 then
                    for num,part in ipairs(C.char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part:Destroy()
                        end
                    end
                else
                    C.char.Humanoid.Health = 0;
                end
                task.delay(30,function()
                    if C.char==saveChar and table.find(C.BotUsers,C.plr.Name:lower()) and C.enHacks.FleeTheFacility.ServerBot.En and not C.Cleared then
                        C.plr:Kick("Reset Activation Failed")
                    end
                end)
            else
                warn("Humanoid Not Found!")
            end
        end
    end
end]=],
    ["Modules/Events"] = [=[local PS = game:GetService("Players")
local GS = game:GetService("GuiService")

return function(C,Settings)
	--[[for eventName,functDict in pairs(C.events) do
		for hackTbl, funct in pairs(functDict) do

		end
	end--]]
    C.SaveEvents = {MyRagdoll={}, Ragdoll={}, OthersRagdoll={},
                    MyBeast={}, Beast={}, OthersBeast={},
                    Game={}, BeastRope={}}
	local function FireEvent(name,doExternalConn,...)
        local SavedTable = C.SaveEvents[name:gsub("Added",""):gsub("Removed","")]
        if SavedTable then
            local args = table.pack(...)
            if name:find("Removed") then
                local del = false
                for key, val in ipairs(SavedTable) do
                    if C.AreTablesEqual(val, args) then
                        table.remove(SavedTable, key)
                        del = true
                        break
                    end
                end
                if not del then
                    warn(`[Events.FireEvent]: {name} has SaveEvent label but does not delete!`)
                end
            elseif name:find("Added") then
                table.insert(SavedTable, args)
            else
                warn(`[Events.FireEvent]: Unknown Prefix: {name} doesn't have Added or Removed`)
            end

        end
		if doExternalConn~=nil then
			if doExternalConn then
				FireEvent("My"..name,nil,...)
			else
				FireEvent("Others"..name,nil,...)
			end
		end
		for hackTbl, funct in pairs(C.events[name] or {}) do
			if typeof(hackTbl) ~= "table" then
				task.spawn(funct,...)
			elseif hackTbl.RealEnabled or hackTbl.AlwaysFireEvents then
				local Thread = task.spawn(funct,hackTbl,...)
				if hackTbl.Threads then
					table.insert(hackTbl.Threads,Thread)
                end
			end
		end
	end
	local function ShouldConnectEvent(name)
        --if C.events[name]==nil then
            --warn("Not Loading",name,"Event!")
        --end
		return Settings.ConnectAllEvents or C.events[name]~=nil
	end
	C.FireEvent = FireEvent
    -- local HasAttachment = game.GameId ~= 5203828273 -- Dress To Impress
	local function CharAdded(theirChar,wasAlreadyIn)
		local theirPlr = PS:GetPlayerFromCharacter(theirChar)
		local theirHuman = theirChar:WaitForChild("Humanoid",1e5)
		if not theirHuman then
			return
		end
		local theirAnimator = theirHuman:WaitForChild("Animator")
		local centerPart = theirChar:WaitForChild("HumanoidRootPart",15)
		if not centerPart then
			return
		end
        local rootAttachment = HasAttachment and centerPart:WaitForChild("RootAttachment") or centerPart:FindFirstChildWhichIsA("Attachment")
		local isMe = C.plr.Character == theirChar
		if isMe then
			C.char = theirChar
			C.human = theirHuman
			C.animator = theirAnimator
			C.hrp = centerPart
            C.rootAttachment = rootAttachment
		end
		theirChar:AddTag("Character")
		for num, part in ipairs(theirChar:GetDescendants()) do
			if part:IsA("BasePart") then
				part:AddTag("CharPart")
			end
		end
		if (isMe and ShouldConnectEvent("MySeatAdded")) or (isMe and ShouldConnectEvent("MySeatRemoved")) or
			ShouldConnectEvent("SeatAdded") or ShouldConnectEvent("SeatRemoved") then
			local lastSeatPart
			local function SeatAdded(active,seatPart)
				--Do not connect global SeatAdded connections, hence the "nil"
				if active then
					lastSeatPart = seatPart
				elseif not active and not lastSeatPart then
					return -- get out, was not seated!
				end
				if isMe then
					C.SeatPart = seatPart
				end
                --print("Firing","Seat"..(active and "Added" or "Removed"),isMe,lastSeatPart,C.events.MySeatAdded)
				FireEvent("Seat"..(active and "Added" or "Removed"),isMe,lastSeatPart)
			end--instance,key,connection
			C.AddObjectConnection(theirHuman,"EventsSeatChanged",theirHuman.Seated:Connect(SeatAdded))
			SeatAdded(theirHuman.SeatPart~=nil, theirHuman.SeatPart)
		end
		if ShouldConnectEvent("MyCharDied",true) and isMe then
			C.AddObjectConnection(theirHuman,"EventsHumanDied",theirHuman.Died:Connect(function()
				FireEvent("MyCharDied",nil,theirPlr,theirChar)
			end))
		end
		if ShouldConnectEvent("CharRemoved",true) then
			C.AddObjectConnection(theirChar,"CharRemoved",theirChar.AncestryChanged:Connect(function(oldParent, newParent)
				if not newParent then
				end
			end))
		end
        for _, additionalFunct in ipairs(C.CharacterAddedEventFuncts) do
            additionalFunct(theirPlr, theirChar, theirHuman)
        end
		task.wait(0.1)
		FireEvent("CharAdded",isMe,theirPlr,theirChar,wasAlreadyIn)
	end
	local function CharRemoving(theirChar)
		local theirPlr = PS:GetPlayerFromCharacter(theirChar)
		local isMe = theirPlr == C.plr
		FireEvent("CharRemoved",isMe,theirPlr,theirChar)
	end
	local function PlrAdded(theirPlr,wasAlreadyIn)
		local isMe = theirPlr == C.plr
        local isFirst = true
		if theirPlr.Character then
			task.spawn(CharAdded,theirPlr.Character,true)
            isFirst = false
		end
		C.AddPlayerConnection(theirPlr,theirPlr.CharacterAdded:Connect(function(newChar)
            CharAdded(newChar, isFirst)
            isFirst = false
        end))
		--if ShouldConnectEvent("CharRemoved",true) then
		C.AddPlayerConnection(theirPlr,theirPlr.CharacterRemoving:Connect(CharRemoving))
		--end
		FireEvent("PlayerAdded",isMe,theirPlr,wasAlreadyIn)
		if (isMe and ShouldConnectEvent("MyTeamAdded")) or (isMe and ShouldConnectEvent("MyTeamRemoved")) or
			ShouldConnectEvent("TeamAdded") or ShouldConnectEvent("TeamRemoved") then
			local function RegisterNewTeam()
				if theirPlr.Team then
					FireEvent("TeamAdded",isMe,theirPlr,theirPlr.Team)
				end
			end
			C.AddPlayerConnection(theirPlr, theirPlr:GetPropertyChangedSignal("Team"):Connect(RegisterNewTeam))
			RegisterNewTeam()
		end
        for _, theirFunct in ipairs(C.PlayerAddedEventFuncts) do
            theirFunct(theirPlr, wasAlreadyIn)
        end
	end
	local function PlrRemoving(theirPlr)
		C.RemoveAllPlayerConnections(theirPlr)
	end
	-- Connect other events
	for num, eventFunct in ipairs(C.EventFunctions) do
		eventFunct()
	end
	C.EventFunctions = nil

	C.AddGlobalConnection(PS.PlayerAdded:Connect(PlrAdded))
	C.AddGlobalConnection(PS.PlayerRemoving:Connect(PlrRemoving))
	for num, theirPlr in ipairs(PS:GetPlayers()) do
		task.spawn(PlrAdded,theirPlr,true)
	end
	C.Camera = workspace.CurrentCamera
	C.AddGlobalConnection(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		local newCamera = workspace.CurrentCamera
		if newCamera then
			C.Camera = newCamera
		end
	end))
	-- Kick detection
	local WhitelistedCodes = {
		[266] = "Connection",
		[267] = "Kick",
		[277] = "Connection",
		[288] = "Shut Down",
		[769] = "Teleport Failed",
	}
	local function CheckStatusCodes(ErrorMessage)
		local ErrorCodeInstanceVal = GS:GetErrorCode()
		local ErrorCode = ErrorCodeInstanceVal and ErrorCodeInstanceVal.Value or -1
		local ErrorIdentification = WhitelistedCodes[ErrorCode]
		if not ErrorIdentification then
			if ErrorCode ~= 0 then
				print("[Events.CheckStatusCodes]: Unknown Error Code:",ErrorCode)
			end
			return
		elseif ErrorMessage:len() == 0 then
			print("Blank Code Ignored For ErrorCode:",ErrorCode)
			return
		end
		FireEvent("RbxErrorPrompt", nil, ErrorMessage, ErrorCode, ErrorIdentification)
	end
	if not C.isStudio then
		C.AddGlobalConnection(GS.ErrorMessageChanged:Connect(CheckStatusCodes))
		CheckStatusCodes(GS:GetErrorMessage())
	end
end
]=],
    ["Modules/GuiElements"] = [=[local PolicyService = game:GetService("PolicyService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("Players")
local RunS = game:GetService("RunService")
local MS = game:GetService("MarketplaceService")
local HS = game:GetService("HttpService")

local function LoadCore(C,Settings)
-- Gui to Lua
-- Version: 3.2

-- Instances:

local GuiTbl = {
	SpecterGUI = Instance.new("ScreenGui"),
	MainHUD = Instance.new("Frame"),
	DropdownFrame = Instance.new("Frame"),
	UIListLayout = Instance.new("UIListLayout"),
	DropdownButtonEx = Instance.new("TextButton"),
	UICorner = Instance.new("UICorner"),
	UIStroke = Instance.new("UIStroke"),
	CategoriesFrame = Instance.new("Frame"),
	Buttons = Instance.new("Frame"),
	CategoryEx = Instance.new("Frame"),
	Image = Instance.new("ImageLabel"),
	Text = Instance.new("TextLabel"),
	Arrow = Instance.new("TextLabel"),
	BottomFrame = Instance.new("Frame"),
	SaveButton = Instance.new("ImageLabel"),
	Wait = Instance.new("TextLabel"),
	UICorner_2 = Instance.new("UICorner"),
	UIListLayout_2 = Instance.new("UIListLayout"),
	MiscDivider = Instance.new("Frame"),
	MiscLabel = Instance.new("TextLabel"),
	HeaderTab = Instance.new("Frame"),
	HeaderTitleLabel = Instance.new("TextLabel"),
	SettingsButton = Instance.new("ImageButton"),
	Settings = Instance.new("Frame"),
	SupportedFrame = Instance.new("Frame"),
	Image_2 = Instance.new("ImageLabel"),
	Description = Instance.new("TextLabel"),
	Supported = Instance.new("TextLabel"),
	BottomFrame_2 = Instance.new("Frame"),
	RefreshButton = Instance.new("ImageLabel"),
	UICorner_3 = Instance.new("UICorner"),
	UIStroke_2 = Instance.new("UIStroke"),
	UIListLayout_3 = Instance.new("UIListLayout"),
	HackDivider = Instance.new("Frame"),
	HackLabel = Instance.new("TextLabel"),
	GameDivider = Instance.new("Frame"),
	GameLabel = Instance.new("TextLabel"),
	ScrollTab = Instance.new("ScrollingFrame"),
	UIListLayout_4 = Instance.new("UIListLayout"),
	TabsFrame = Instance.new("Frame"),
	TabEx = Instance.new("CanvasGroup"),
	HeaderTab_2 = Instance.new("Frame"),
	HeaderTitleLabel_2 = Instance.new("TextLabel"),
	DropDownButton = Instance.new("ImageButton"),
	Text_2 = Instance.new("TextLabel"),
	Image_3 = Instance.new("ImageLabel"),
	ScrollTab_2 = Instance.new("ScrollingFrame"),
	UIListLayout_5 = Instance.new("UIListLayout"),
	HackButtonEx = Instance.new("Frame"),
	HackText = Instance.new("TextLabel"),
	HackExpand = Instance.new("ImageButton"),
	OptionsList = Instance.new("Frame"),
	UIListLayout_6 = Instance.new("UIListLayout"),
	ToggleEx = Instance.new("Frame"),
	NameTL = Instance.new("TextLabel"),
	ToggleSwitchSlider = Instance.new("ImageButton"),
	UICorner_4 = Instance.new("UICorner"),
	ToggleCircle = Instance.new("Frame"),
	UICorner_5 = Instance.new("UICorner"),
	UIGradient = Instance.new("UIGradient"),
	UIGradient_2 = Instance.new("UIGradient"),
	UIStroke_3 = Instance.new("UIStroke"),
	SliderEx = Instance.new("Frame"),
	NameTL_2 = Instance.new("TextLabel"),
	SlidingBar = Instance.new("ImageButton"),
	UICorner_6 = Instance.new("UICorner"),
	CurrentPosition = Instance.new("Frame"),
	UICorner_7 = Instance.new("UICorner"),
	UIGradient_3 = Instance.new("UIGradient"),
	UIGradient_4 = Instance.new("UIGradient"),
	Backing = Instance.new("Frame"),
	Track = Instance.new("Frame"),
	ForceTB = Instance.new("TextBox"),
	TBUnderbar = Instance.new("Frame"),
	LeftBound = Instance.new("TextLabel"),
	RightBound = Instance.new("TextLabel"),
	UIStroke_4 = Instance.new("UIStroke"),
	DropdownEx = Instance.new("Frame"),
	NameTL_3 = Instance.new("TextLabel"),
	UIStroke_5 = Instance.new("UIStroke"),
	DropdownButton = Instance.new("TextButton"),
	UICorner_8 = Instance.new("UICorner"),
	UIStroke_6 = Instance.new("UIStroke"),
	UserListEx = Instance.new("Frame"),
	NameTL_4 = Instance.new("TextLabel"),
	UIStroke_7 = Instance.new("UIStroke"),
	AddButton = Instance.new("TextButton"),
	UICorner_9 = Instance.new("UICorner"),
	UIStroke_8 = Instance.new("UIStroke"),
	MainList = Instance.new("Frame"),
	UIListLayout_7 = Instance.new("UIListLayout"),
	OneListEx = Instance.new("Frame"),
	DeleteButton = Instance.new("TextButton"),
	UICorner_10 = Instance.new("UICorner"),
	UIStroke_9 = Instance.new("UIStroke"),
	UserTL = Instance.new("TextLabel"),
	EnterTB = Instance.new("TextBox"),
	UICorner_11 = Instance.new("UICorner"),
	UIStroke_10 = Instance.new("UIStroke"),
	LimitTL = Instance.new("TextLabel"),
	TextboxEx = Instance.new("Frame"),
	NameTL_5 = Instance.new("TextLabel"),
	UIStroke_11 = Instance.new("UIStroke"),
	SetTB = Instance.new("TextBox"),
	UICorner_12 = Instance.new("UICorner"),
	UIStroke_12 = Instance.new("UIStroke"),
	LimitTL_2 = Instance.new("TextLabel"),
	EnterButton = Instance.new("ImageButton"),
	UICorner_13 = Instance.new("UICorner"),
	UIStroke_13 = Instance.new("UIStroke"),
	HighlightBackground = Instance.new("Frame"),
	KeybindButton = Instance.new("ImageButton"),
	BindedKey = Instance.new("TextLabel"),
	KeybindLabel = Instance.new("TextLabel"),
	KeybindBacking = Instance.new("Frame"),
	UIGradient_5 = Instance.new("UIGradient"),
	ToolTipHeaderFrame = Instance.new("Frame"),
	ToolTipText = Instance.new("TextLabel"),
	UICorner_14 = Instance.new("UICorner"),
	Notifications = Instance.new("Frame"),
	NotificationEx = Instance.new("Frame"),
	Timer = Instance.new("Frame"),
	UICorner_15 = Instance.new("UICorner"),
	NotificationTitle = Instance.new("TextLabel"),
	NotificationDesc = Instance.new("TextLabel"),
	UITextSizeConstraint = Instance.new("UITextSizeConstraint"),
	HUDBackgroundFade = Instance.new("Frame"),
	ChatAutoComplete = Instance.new("ScrollingFrame"),
	AutoCompleteEx = Instance.new("Frame"),
	AutoCompleteTitleLabel = Instance.new("TextLabel"),
	UIListLayout_8 = Instance.new("UIListLayout"),
	Actions = Instance.new("CanvasGroup"),
	HeaderTab_3 = Instance.new("Frame"),
	HeaderTitleLabel_3 = Instance.new("TextLabel"),
	DropDownButton_2 = Instance.new("ImageButton"),
	Text_3 = Instance.new("TextLabel"),
	Image_4 = Instance.new("ImageLabel"),
	ScrollTab_3 = Instance.new("ScrollingFrame"),
	UIListLayout_9 = Instance.new("UIListLayout"),
	ActionsEx = Instance.new("Frame"),
	Title = Instance.new("TextLabel"),
	StopButton = Instance.new("TextButton"),
	UIStroke_14 = Instance.new("UIStroke"),
	Time = Instance.new("TextLabel"),
	UIStroke_15 = Instance.new("UIStroke"),
	UIStroke_16 = Instance.new("UIStroke"),
	UIGradient_6 = Instance.new("UIGradient"),
	KickedButton = Instance.new("TextButton"),
	SecondaryHUD = Instance.new("Frame"),
	Servers = Instance.new("Frame"),
	UICorner_16 = Instance.new("UICorner"),
	ServersTitleLabel = Instance.new("TextLabel"),
	TabsSelection = Instance.new("Frame"),
	Game = Instance.new("TextButton"),
	UICorner_17 = Instance.new("UICorner"),
	UIStroke_17 = Instance.new("UIStroke"),
	UIGridLayout = Instance.new("UIGridLayout"),
	Recent = Instance.new("TextButton"),
	UICorner_18 = Instance.new("UICorner"),
	UIStroke_18 = Instance.new("UIStroke"),
	Close = Instance.new("TextButton"),
	UICorner_19 = Instance.new("UICorner"),
	UIStroke_19 = Instance.new("UIStroke"),
	Friend = Instance.new("TextButton"),
	UICorner_20 = Instance.new("UICorner"),
	UIStroke_20 = Instance.new("UIStroke"),
	MainScroll = Instance.new("ScrollingFrame"),
	ServerEx = Instance.new("Frame"),
	ServerTitle = Instance.new("TextLabel"),
	TimeStamp = Instance.new("TextLabel"),
	SecondData = Instance.new("TextLabel"),
	UICorner_21 = Instance.new("UICorner"),
	UIStroke_21 = Instance.new("UIStroke"),
	UIGridLayout_2 = Instance.new("UIGridLayout"),
	BottomButtons = Instance.new("Frame"),
	Previous = Instance.new("TextButton"),
	UICorner_22 = Instance.new("UICorner"),
	UIStroke_22 = Instance.new("UIStroke"),
	UIGridLayout_3 = Instance.new("UIGridLayout"),
	Join = Instance.new("TextButton"),
	UICorner_23 = Instance.new("UICorner"),
	UIStroke_23 = Instance.new("UIStroke"),
	Next = Instance.new("TextButton"),
	UICorner_24 = Instance.new("UICorner"),
	UIStroke_24 = Instance.new("UIStroke"),
	ExtraLabel = Instance.new("TextLabel"),
	NoneFoundLabel = Instance.new("TextLabel"),
	UICorner_25 = Instance.new("UICorner"),
	UIStroke_25 = Instance.new("UIStroke"),
	LoadingLabel = Instance.new("TextLabel"),
	UICorner_26 = Instance.new("UICorner"),
	UIStroke_26 = Instance.new("UIStroke"),
	UICorner_27 = Instance.new("UICorner"),
	UIStroke_27 = Instance.new("UIStroke"),
	PromptFrame = Instance.new("Frame"),
	UICorner_28 = Instance.new("UICorner"),
	UIStroke_28 = Instance.new("UIStroke"),
	PromptTitle = Instance.new("TextLabel"),
	PromptDesc = Instance.new("TextLabel"),
	PromptButtons = Instance.new("Frame"),
	UIGridLayout_4 = Instance.new("UIGridLayout"),
	Yes = Instance.new("TextButton"),
	UIStroke_29 = Instance.new("UIStroke"),
	UICorner_29 = Instance.new("UICorner"),
	No = Instance.new("TextButton"),
	UIStroke_30 = Instance.new("UIStroke"),
	UICorner_30 = Instance.new("UICorner"),
	Ok = Instance.new("TextButton"),
	UIStroke_31 = Instance.new("UIStroke"),
	UICorner_31 = Instance.new("UICorner"),
	VisibilityButton = Instance.new("Frame"),
	UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint"),
	UICorner_32 = Instance.new("UICorner"),
	VisibilityButton_2 = Instance.new("ImageLabel"),
	UICorner_33 = Instance.new("UICorner"),
	FrameRate = Instance.new("TextLabel"),
	ESP = Instance.new("Folder"),
	ToggleTagEx = Instance.new("BillboardGui"),
	Toggle = Instance.new("TextButton"),
	UIStroke_32 = Instance.new("UIStroke"),
	NameTagEx = Instance.new("BillboardGui"),
	Username = Instance.new("TextLabel"),
	Distance = Instance.new("TextLabel"),
	ExpandingBar = Instance.new("Frame"),
	AmtFinished = Instance.new("Frame"),
	Modal = Instance.new("TextButton"),
}

--Properties:

GuiTbl.SpecterGUI.Name = "SpecterGUI"

GuiTbl.SpecterGUI.DisplayOrder = -1
GuiTbl.SpecterGUI.ResetOnSpawn = false

GuiTbl.MainHUD.Name = "MainHUD"
GuiTbl.MainHUD.Parent = GuiTbl.SpecterGUI
C.UI.MainHUD = GuiTbl.MainHUD
GuiTbl.MainHUD.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.MainHUD.BackgroundTransparency = 1.000
GuiTbl.MainHUD.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MainHUD.BorderSizePixel = 0
GuiTbl.MainHUD.Size = UDim2.new(1, 0, 1, 0)
GuiTbl.MainHUD.ZIndex = -9999

GuiTbl.DropdownFrame.Name = "DropdownFrame"
GuiTbl.DropdownFrame.Parent = GuiTbl.MainHUD
C.UI.DropdownFrame = GuiTbl.DropdownFrame
GuiTbl.DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.DropdownFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
GuiTbl.DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropdownFrame.BorderSizePixel = 0
GuiTbl.DropdownFrame.Position = UDim2.new(0, 532, 0, 332)
GuiTbl.DropdownFrame.Size = UDim2.new(0, 92, 0, 0)
GuiTbl.DropdownFrame.Visible = false
GuiTbl.DropdownFrame.ZIndex = 20

GuiTbl.UIListLayout.Parent = GuiTbl.DropdownFrame
GuiTbl.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.DropdownButtonEx.Name = "DropdownButtonEx"
C.AddGlobalInstance(GuiTbl.DropdownButtonEx)
C.Examples.DropdownButtonEx = GuiTbl.DropdownButtonEx
GuiTbl.DropdownButtonEx.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.DropdownButtonEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
GuiTbl.DropdownButtonEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropdownButtonEx.BorderSizePixel = 0
GuiTbl.DropdownButtonEx.Position = UDim2.new(0.970000029, 0, 0.5, 0)
GuiTbl.DropdownButtonEx.Size = UDim2.new(1, 0, 0, 30)
GuiTbl.DropdownButtonEx.ZIndex = 21
GuiTbl.DropdownButtonEx.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.DropdownButtonEx.Text = "God Mode"
GuiTbl.DropdownButtonEx.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.DropdownButtonEx.TextScaled = true
GuiTbl.DropdownButtonEx.TextSize = 21
GuiTbl.DropdownButtonEx.TextStrokeTransparency = 0.000
GuiTbl.DropdownButtonEx.TextWrapped = true

GuiTbl.UICorner.Parent = GuiTbl.DropdownButtonEx

GuiTbl.UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke.Parent = GuiTbl.DropdownButtonEx

GuiTbl.CategoriesFrame.Name = "CategoriesFrame"
GuiTbl.CategoriesFrame.Parent = GuiTbl.MainHUD
C.UI.CategoriesFrame = GuiTbl.CategoriesFrame
GuiTbl.CategoriesFrame.Active = true
GuiTbl.CategoriesFrame.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.CategoriesFrame.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
GuiTbl.CategoriesFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.CategoriesFrame.BorderSizePixel = 0
GuiTbl.CategoriesFrame.LayoutOrder = -15
GuiTbl.CategoriesFrame.Position = UDim2.new(0, 30, 0, 100)
GuiTbl.CategoriesFrame.Size = UDim2.new(0, 200, 0, 0)

GuiTbl.Buttons.Name = "Buttons"
GuiTbl.Buttons.Parent = GuiTbl.CategoriesFrame
GuiTbl.Buttons.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.Buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Buttons.BackgroundTransparency = 1.000
GuiTbl.Buttons.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Buttons.BorderSizePixel = 0
GuiTbl.Buttons.Position = UDim2.new(0, 0, 0, 40)
GuiTbl.Buttons.Size = UDim2.new(1, 0, 0, 0)

GuiTbl.CategoryEx.Name = "CategoryEx"
C.AddGlobalInstance(GuiTbl.CategoryEx)
C.Examples.CategoryEx = GuiTbl.CategoryEx
GuiTbl.CategoryEx.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.CategoryEx.BackgroundTransparency = 1.000
GuiTbl.CategoryEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.CategoryEx.BorderSizePixel = 0
GuiTbl.CategoryEx.LayoutOrder = 1
GuiTbl.CategoryEx.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.Image.Name = "Image"
GuiTbl.Image.Parent = GuiTbl.CategoryEx
GuiTbl.Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Image.BackgroundTransparency = 1.000
GuiTbl.Image.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Image.BorderSizePixel = 0
GuiTbl.Image.Size = UDim2.new(0.150000006, 0, 1, 0)
C.SetImage(GuiTbl.Image,"rbxasset://textures/ui/GuiImagePlaceholder.png")
GuiTbl.Image.ScaleType = Enum.ScaleType.Fit

GuiTbl.Text.Name = "Text"
GuiTbl.Text.Parent = GuiTbl.CategoryEx
GuiTbl.Text.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text.BackgroundTransparency = 1.000
GuiTbl.Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Text.BorderSizePixel = 0
GuiTbl.Text.Position = UDim2.new(0.150000006, 0, 0.5, 0)
GuiTbl.Text.Size = UDim2.new(0.670000017, 0, 0.730000019, 0)
GuiTbl.Text.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Text.Text = " Render"
GuiTbl.Text.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text.TextScaled = true
GuiTbl.Text.TextSize = 21
GuiTbl.Text.TextWrapped = true
GuiTbl.Text.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.Arrow.Name = "Arrow"
GuiTbl.Arrow.Parent = GuiTbl.CategoryEx
GuiTbl.Arrow.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Arrow.BackgroundTransparency = 1.000
GuiTbl.Arrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Arrow.BorderSizePixel = 0
GuiTbl.Arrow.Position = UDim2.new(0.779999971, 0, 0.5, 0)
GuiTbl.Arrow.Size = UDim2.new(0.199999779, 0, 0.730000138, 0)
GuiTbl.Arrow.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Arrow.Text = ">"
GuiTbl.Arrow.TextColor3 = Color3.fromRGB(115, 115, 115)
GuiTbl.Arrow.TextScaled = true
GuiTbl.Arrow.TextSize = 21
GuiTbl.Arrow.TextWrapped = true

GuiTbl.BottomFrame.Name = "BottomFrame"
GuiTbl.BottomFrame.Parent = GuiTbl.Buttons
GuiTbl.BottomFrame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.BottomFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.BottomFrame.BorderSizePixel = 0
GuiTbl.BottomFrame.LayoutOrder = 12000
GuiTbl.BottomFrame.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.SaveButton.Name = "SaveButton"
GuiTbl.SaveButton.Parent = GuiTbl.BottomFrame
GuiTbl.SaveButton.Active = true
GuiTbl.SaveButton.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.SaveButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SaveButton.BackgroundTransparency = 1.000
GuiTbl.SaveButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SaveButton.BorderSizePixel = 0
GuiTbl.SaveButton.Position = UDim2.new(0, 0, 0.5, 0)
GuiTbl.SaveButton.Size = UDim2.new(0.200000003, 0, 0.899999976, 0)
C.SetImage(GuiTbl.SaveButton,"rbxassetid://14737163568")
GuiTbl.SaveButton.ScaleType = Enum.ScaleType.Fit

GuiTbl.Wait.Name = "Wait"
GuiTbl.Wait.Parent = GuiTbl.SaveButton
GuiTbl.Wait.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.Wait.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Wait.BackgroundTransparency = 1.000
GuiTbl.Wait.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Wait.BorderSizePixel = 0
GuiTbl.Wait.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.Wait.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
GuiTbl.Wait.Visible = false
GuiTbl.Wait.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
GuiTbl.Wait.Text = "•••"
GuiTbl.Wait.TextColor3 = Color3.fromRGB(143, 143, 143)
GuiTbl.Wait.TextScaled = true
GuiTbl.Wait.TextSize = 40.000
GuiTbl.Wait.TextStrokeTransparency = 0.000
GuiTbl.Wait.TextWrapped = true

GuiTbl.UICorner_2.CornerRadius = UDim.new(2, 0)
GuiTbl.UICorner_2.Parent = GuiTbl.Wait

GuiTbl.UIListLayout_2.Parent = GuiTbl.Buttons
GuiTbl.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.MiscDivider.Name = "MiscDivider"
GuiTbl.MiscDivider.Parent = GuiTbl.Buttons
GuiTbl.MiscDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.MiscDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MiscDivider.BorderSizePixel = 0
GuiTbl.MiscDivider.LayoutOrder = 2000
GuiTbl.MiscDivider.Size = UDim2.new(1, 0, 0, 24)

GuiTbl.MiscLabel.Name = "MiscLabel"
GuiTbl.MiscLabel.Parent = GuiTbl.MiscDivider
GuiTbl.MiscLabel.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.MiscLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.MiscLabel.BackgroundTransparency = 1.000
GuiTbl.MiscLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MiscLabel.BorderSizePixel = 0
GuiTbl.MiscLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
GuiTbl.MiscLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
GuiTbl.MiscLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.MiscLabel.Text = "MISC"
GuiTbl.MiscLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
GuiTbl.MiscLabel.TextScaled = true
GuiTbl.MiscLabel.TextSize = 21
GuiTbl.MiscLabel.TextStrokeTransparency = 0.000
GuiTbl.MiscLabel.TextWrapped = true
GuiTbl.MiscLabel.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.HeaderTab.Name = "HeaderTab"
GuiTbl.HeaderTab.Parent = GuiTbl.CategoriesFrame
GuiTbl.HeaderTab.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.HeaderTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTab.BorderSizePixel = 0
GuiTbl.HeaderTab.LayoutOrder = -20
GuiTbl.HeaderTab.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.HeaderTitleLabel.Name = "HeaderTitleLabel"
GuiTbl.HeaderTitleLabel.Parent = GuiTbl.HeaderTab
GuiTbl.HeaderTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel.BackgroundTransparency = 1.000
GuiTbl.HeaderTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTitleLabel.BorderSizePixel = 0
GuiTbl.HeaderTitleLabel.Size = UDim2.new(0.600000024, 0, 1, 0)
GuiTbl.HeaderTitleLabel.RichText = true
GuiTbl.HeaderTitleLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.HeaderTitleLabel.Text = " SPECTER"
GuiTbl.HeaderTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel.TextScaled = true
GuiTbl.HeaderTitleLabel.TextSize = 21
GuiTbl.HeaderTitleLabel.TextStrokeTransparency = 0.000
GuiTbl.HeaderTitleLabel.TextWrapped = true
GuiTbl.HeaderTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.SettingsButton.Name = "SettingsButton"
GuiTbl.SettingsButton.Parent = GuiTbl.HeaderTab
GuiTbl.SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.SettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SettingsButton.BackgroundTransparency = 1.000
GuiTbl.SettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SettingsButton.BorderSizePixel = 0
GuiTbl.SettingsButton.Position = UDim2.new(0.980000019, 0, 0.5, 0)
GuiTbl.SettingsButton.Size = UDim2.new(0.200000003, 0, 0.800000012, 0)
GuiTbl.SettingsButton.ZIndex = 50
C.SetImage(GuiTbl.SettingsButton,"rbxassetid://14134158045")
GuiTbl.SettingsButton.ScaleType = Enum.ScaleType.Fit

GuiTbl.Settings.Name = "Settings"
GuiTbl.Settings.Parent = GuiTbl.CategoriesFrame
GuiTbl.Settings.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.Settings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Settings.BackgroundTransparency = 1.000
GuiTbl.Settings.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Settings.BorderSizePixel = 0
GuiTbl.Settings.Position = UDim2.new(0, 0, 0, 40)
GuiTbl.Settings.Size = UDim2.new(1, 0, 0, 0)
GuiTbl.Settings.Visible = false

GuiTbl.SupportedFrame.Name = "SupportedFrame"
GuiTbl.SupportedFrame.Parent = GuiTbl.Settings
GuiTbl.SupportedFrame.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.SupportedFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SupportedFrame.BackgroundTransparency = 1.000
GuiTbl.SupportedFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SupportedFrame.BorderSizePixel = 0
GuiTbl.SupportedFrame.LayoutOrder = 1
GuiTbl.SupportedFrame.Size = UDim2.new(1, 0, 0, 0)

GuiTbl.Image_2.Name = "Image"
GuiTbl.Image_2.Parent = GuiTbl.SupportedFrame
GuiTbl.Image_2.Active = true
GuiTbl.Image_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Image_2.BackgroundTransparency = 1.000
GuiTbl.Image_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Image_2.BorderSizePixel = 0
GuiTbl.Image_2.Size = UDim2.new(0.150000006, 0, 1, 0)
C.SetImage(GuiTbl.Image_2,"rbxasset://textures/ui/GuiImagePlaceholder.png")
GuiTbl.Image_2.ScaleType = Enum.ScaleType.Fit

GuiTbl.Description.Name = "Description"
GuiTbl.Description.Parent = GuiTbl.SupportedFrame
GuiTbl.Description.Active = true
GuiTbl.Description.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Description.BackgroundTransparency = 1.000
GuiTbl.Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Description.BorderSizePixel = 0
GuiTbl.Description.Position = UDim2.new(0.150000006, 0, 0, 20)
GuiTbl.Description.Size = UDim2.new(0.790000021, 0, 0, 0)
GuiTbl.Description.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Description.Text = " Render"
GuiTbl.Description.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Description.TextSize = 21
GuiTbl.Description.TextWrapped = true
GuiTbl.Description.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.Supported.Name = "Supported"
GuiTbl.Supported.Parent = GuiTbl.SupportedFrame
GuiTbl.Supported.Active = true
GuiTbl.Supported.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Supported.BackgroundTransparency = 1.000
GuiTbl.Supported.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Supported.BorderSizePixel = 0
GuiTbl.Supported.Position = UDim2.new(0.150000006, 0, 0, 0)
GuiTbl.Supported.Size = UDim2.new(0.790000021, 0, 0, 20)
GuiTbl.Supported.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Supported.Text = "Supported Game"
GuiTbl.Supported.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Supported.TextScaled = true
GuiTbl.Supported.TextSize = 21
GuiTbl.Supported.TextWrapped = true
GuiTbl.Supported.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.BottomFrame_2.Name = "BottomFrame"
GuiTbl.BottomFrame_2.Parent = GuiTbl.Settings
GuiTbl.BottomFrame_2.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.BottomFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.BottomFrame_2.BorderSizePixel = 0
GuiTbl.BottomFrame_2.LayoutOrder = 50
GuiTbl.BottomFrame_2.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.RefreshButton.Name = "RefreshButton"
GuiTbl.RefreshButton.Parent = GuiTbl.BottomFrame_2
GuiTbl.RefreshButton.Active = true
GuiTbl.RefreshButton.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.RefreshButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
GuiTbl.RefreshButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.RefreshButton.BorderSizePixel = 0
GuiTbl.RefreshButton.Position = UDim2.new(1, -1, 0.5, 0)
GuiTbl.RefreshButton.Size = UDim2.new(0, 36, 0, 36)
C.SetImage(GuiTbl.RefreshButton,"rbxassetid://13492317101")
GuiTbl.RefreshButton.ScaleType = Enum.ScaleType.Fit

GuiTbl.UICorner_3.CornerRadius = UDim.new(0, 999)
GuiTbl.UICorner_3.Parent = GuiTbl.RefreshButton

GuiTbl.UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_2.Parent = GuiTbl.RefreshButton

GuiTbl.UIListLayout_3.Parent = GuiTbl.Settings
GuiTbl.UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.HackDivider.Name = "HackDivider"
GuiTbl.HackDivider.Parent = GuiTbl.Settings
GuiTbl.HackDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.HackDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HackDivider.BorderSizePixel = 0
GuiTbl.HackDivider.LayoutOrder = 20
GuiTbl.HackDivider.Size = UDim2.new(1, 0, 0, 24)

GuiTbl.HackLabel.Name = "HackLabel"
GuiTbl.HackLabel.Parent = GuiTbl.HackDivider
GuiTbl.HackLabel.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.HackLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HackLabel.BackgroundTransparency = 1.000
GuiTbl.HackLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HackLabel.BorderSizePixel = 0
GuiTbl.HackLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
GuiTbl.HackLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
GuiTbl.HackLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.HackLabel.Text = "HACK"
GuiTbl.HackLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
GuiTbl.HackLabel.TextScaled = true
GuiTbl.HackLabel.TextSize = 21
GuiTbl.HackLabel.TextStrokeTransparency = 0.000
GuiTbl.HackLabel.TextWrapped = true
GuiTbl.HackLabel.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.GameDivider.Name = "GameDivider"
GuiTbl.GameDivider.Parent = GuiTbl.Settings
GuiTbl.GameDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.GameDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.GameDivider.BorderSizePixel = 0
GuiTbl.GameDivider.LayoutOrder = -20
GuiTbl.GameDivider.Size = UDim2.new(1, 0, 0, 24)

GuiTbl.GameLabel.Name = "GameLabel"
GuiTbl.GameLabel.Parent = GuiTbl.GameDivider
GuiTbl.GameLabel.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.GameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.GameLabel.BackgroundTransparency = 1.000
GuiTbl.GameLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.GameLabel.BorderSizePixel = 0
GuiTbl.GameLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
GuiTbl.GameLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
GuiTbl.GameLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.GameLabel.Text = "GAME"
GuiTbl.GameLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
GuiTbl.GameLabel.TextScaled = true
GuiTbl.GameLabel.TextSize = 21
GuiTbl.GameLabel.TextStrokeTransparency = 0.000
GuiTbl.GameLabel.TextWrapped = true
GuiTbl.GameLabel.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.ScrollTab.Name = "ScrollTab"
GuiTbl.ScrollTab.Parent = GuiTbl.Settings
GuiTbl.ScrollTab.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ScrollTab.BackgroundTransparency = 1.000
GuiTbl.ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ScrollTab.BorderSizePixel = 0
GuiTbl.ScrollTab.LayoutOrder = 40
GuiTbl.ScrollTab.Position = UDim2.new(0, 0, 0, 45)
GuiTbl.ScrollTab.Size = UDim2.new(1, 0, 0, 0)
GuiTbl.ScrollTab.ZIndex = 0
GuiTbl.ScrollTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
GuiTbl.ScrollTab.BottomImage = "rbxassetid://3062505976"
GuiTbl.ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
GuiTbl.ScrollTab.MidImage = "rbxassetid://3062506202"
GuiTbl.ScrollTab.TopImage = "rbxassetid://3062506445"
GuiTbl.ScrollTab.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

GuiTbl.UIListLayout_4.Parent = GuiTbl.ScrollTab
GuiTbl.UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.TabsFrame.Name = "TabsFrame"
GuiTbl.TabsFrame.Parent = GuiTbl.MainHUD
C.UI.TabsFrame = GuiTbl.TabsFrame
GuiTbl.TabsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.TabsFrame.BackgroundTransparency = 1.000
GuiTbl.TabsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TabsFrame.BorderSizePixel = 0
GuiTbl.TabsFrame.LayoutOrder = -15
GuiTbl.TabsFrame.Size = UDim2.new(1, 0, 1, 0)
GuiTbl.TabsFrame.ZIndex = -12500

GuiTbl.TabEx.Name = "TabEx"
C.AddGlobalInstance(GuiTbl.TabEx)
C.Examples.TabEx = GuiTbl.TabEx
GuiTbl.TabEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
GuiTbl.TabEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TabEx.BorderSizePixel = 0
GuiTbl.TabEx.LayoutOrder = -14
GuiTbl.TabEx.Position = UDim2.new(0, 400, 0, 100)
GuiTbl.TabEx.Size = UDim2.new(0, 230, 0, 400)
GuiTbl.TabEx.ZIndex = -14

GuiTbl.HeaderTab_2.Name = "HeaderTab"
GuiTbl.HeaderTab_2.Parent = GuiTbl.TabEx
GuiTbl.HeaderTab_2.Active = true
GuiTbl.HeaderTab_2.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.HeaderTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTab_2.BorderSizePixel = 0
GuiTbl.HeaderTab_2.LayoutOrder = -13
GuiTbl.HeaderTab_2.Size = UDim2.new(1, 0, 0, 45)
GuiTbl.HeaderTab_2.ZIndex = -13

GuiTbl.HeaderTitleLabel_2.Name = "HeaderTitleLabel"
GuiTbl.HeaderTitleLabel_2.Parent = GuiTbl.HeaderTab_2
GuiTbl.HeaderTitleLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel_2.BackgroundTransparency = 1.000
GuiTbl.HeaderTitleLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTitleLabel_2.BorderSizePixel = 0
GuiTbl.HeaderTitleLabel_2.LayoutOrder = -12
GuiTbl.HeaderTitleLabel_2.Size = UDim2.new(0.600000024, 0, 1, 0)
GuiTbl.HeaderTitleLabel_2.Visible = false
GuiTbl.HeaderTitleLabel_2.RichText = true
GuiTbl.HeaderTitleLabel_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.HeaderTitleLabel_2.Text = " SPECTER"
GuiTbl.HeaderTitleLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel_2.TextScaled = true
GuiTbl.HeaderTitleLabel_2.TextSize = 21
GuiTbl.HeaderTitleLabel_2.TextStrokeTransparency = 0.000
GuiTbl.HeaderTitleLabel_2.TextWrapped = true
GuiTbl.HeaderTitleLabel_2.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.DropDownButton.Name = "DropDownButton"
GuiTbl.DropDownButton.Parent = GuiTbl.HeaderTab_2
GuiTbl.DropDownButton.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.DropDownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.DropDownButton.BackgroundTransparency = 1.000
GuiTbl.DropDownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropDownButton.BorderSizePixel = 0
GuiTbl.DropDownButton.LayoutOrder = -12
GuiTbl.DropDownButton.Position = UDim2.new(0.980000019, 0, 0.5, 0)
GuiTbl.DropDownButton.Size = UDim2.new(0.200000003, 0, 0.5, 0)
C.SetImage(GuiTbl.DropDownButton,"rbxassetid://14569017448")
GuiTbl.DropDownButton.ScaleType = Enum.ScaleType.Fit

GuiTbl.Text_2.Name = "Text"
GuiTbl.Text_2.Parent = GuiTbl.HeaderTab_2
GuiTbl.Text_2.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text_2.BackgroundTransparency = 1.000
GuiTbl.Text_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Text_2.BorderSizePixel = 0
GuiTbl.Text_2.LayoutOrder = -12
GuiTbl.Text_2.Position = UDim2.new(0.150000036, 0, 0.5, 0)
GuiTbl.Text_2.Size = UDim2.new(0.629999697, 0, 0.730000138, 0)
GuiTbl.Text_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Text_2.Text = " Render"
GuiTbl.Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text_2.TextScaled = true
GuiTbl.Text_2.TextSize = 21
GuiTbl.Text_2.TextWrapped = true
GuiTbl.Text_2.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.Image_3.Name = "Image"
GuiTbl.Image_3.Parent = GuiTbl.HeaderTab_2
GuiTbl.Image_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Image_3.BackgroundTransparency = 1.000
GuiTbl.Image_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Image_3.BorderSizePixel = 0
GuiTbl.Image_3.LayoutOrder = -12
GuiTbl.Image_3.Size = UDim2.new(0.150000006, 0, 1, 0)
C.SetImage(GuiTbl.Image_3,"rbxasset://textures/ui/GuiImagePlaceholder.png")
GuiTbl.Image_3.ScaleType = Enum.ScaleType.Fit

GuiTbl.ScrollTab_2.Name = "ScrollTab"
GuiTbl.ScrollTab_2.Parent = GuiTbl.TabEx
GuiTbl.ScrollTab_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ScrollTab_2.BackgroundTransparency = 1.000
GuiTbl.ScrollTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ScrollTab_2.BorderSizePixel = 0
GuiTbl.ScrollTab_2.LayoutOrder = -13
GuiTbl.ScrollTab_2.Position = UDim2.new(0, 0, 0, 45)
GuiTbl.ScrollTab_2.Size = UDim2.new(1, 0, 0, 300)
GuiTbl.ScrollTab_2.ZIndex = 0
GuiTbl.ScrollTab_2.AutomaticCanvasSize = Enum.AutomaticSize.Y
GuiTbl.ScrollTab_2.BottomImage = "rbxassetid://3062505976"
GuiTbl.ScrollTab_2.CanvasSize = UDim2.new(0, 0, 0, 0)
GuiTbl.ScrollTab_2.MidImage = "rbxassetid://3062506202"
GuiTbl.ScrollTab_2.TopImage = "rbxassetid://3062506445"
GuiTbl.ScrollTab_2.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

GuiTbl.UIListLayout_5.Parent = GuiTbl.ScrollTab_2
GuiTbl.UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.HackButtonEx.Name = "HackButtonEx"
C.AddGlobalInstance(GuiTbl.HackButtonEx)
C.Examples.HackButtonEx = GuiTbl.HackButtonEx
GuiTbl.HackButtonEx.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.HackButtonEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
GuiTbl.HackButtonEx.BackgroundTransparency = 1.000
GuiTbl.HackButtonEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HackButtonEx.BorderSizePixel = 0
GuiTbl.HackButtonEx.LayoutOrder = -12
GuiTbl.HackButtonEx.Size = UDim2.new(1, 0, 0, 0)

GuiTbl.HackText.Name = "HackText"
GuiTbl.HackText.Parent = GuiTbl.HackButtonEx
GuiTbl.HackText.Active = true
GuiTbl.HackText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HackText.BackgroundTransparency = 1.000
GuiTbl.HackText.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HackText.BorderSizePixel = 0
GuiTbl.HackText.Position = UDim2.new(0.0500000007, 0, 0, 0)
GuiTbl.HackText.Size = UDim2.new(0.649999976, 0, 0, 40)
GuiTbl.HackText.ZIndex = 2
GuiTbl.HackText.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.HackText.Text = "AimAssist"
GuiTbl.HackText.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HackText.TextScaled = true
GuiTbl.HackText.TextSize = 21
GuiTbl.HackText.TextStrokeTransparency = 0.000
GuiTbl.HackText.TextWrapped = true
GuiTbl.HackText.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.HackExpand.Name = "HackExpand"
GuiTbl.HackExpand.Parent = GuiTbl.HackButtonEx
GuiTbl.HackExpand.Active = false
GuiTbl.HackExpand.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.HackExpand.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HackExpand.BackgroundTransparency = 1.000
GuiTbl.HackExpand.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HackExpand.BorderSizePixel = 0
GuiTbl.HackExpand.Position = UDim2.new(1, 0, 0, 20)
GuiTbl.HackExpand.Selectable = false
GuiTbl.HackExpand.Size = UDim2.new(0.150000006, 0, 0, 40)
GuiTbl.HackExpand.ZIndex = 3
C.SetImage(GuiTbl.HackExpand,"rbxassetid://12809025337")
GuiTbl.HackExpand.ScaleType = Enum.ScaleType.Fit

GuiTbl.OptionsList.Name = "OptionsList"
GuiTbl.OptionsList.Parent = GuiTbl.HackButtonEx
GuiTbl.OptionsList.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.OptionsList.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
GuiTbl.OptionsList.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.OptionsList.BorderSizePixel = 0
GuiTbl.OptionsList.Position = UDim2.new(0, 0, 0, 40)
GuiTbl.OptionsList.Size = UDim2.new(1, 0, 0, 0)
GuiTbl.OptionsList.ZIndex = 2

GuiTbl.UIListLayout_6.Parent = GuiTbl.OptionsList
GuiTbl.UIListLayout_6.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
GuiTbl.UIListLayout_6.Padding = UDim.new(0, 1)

GuiTbl.ToggleEx.Name = "ToggleEx"
C.AddGlobalInstance(GuiTbl.ToggleEx)
C.Examples.ToggleEx = GuiTbl.ToggleEx
GuiTbl.ToggleEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
GuiTbl.ToggleEx.BackgroundTransparency = 1.000
GuiTbl.ToggleEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ToggleEx.BorderSizePixel = 0
GuiTbl.ToggleEx.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.NameTL.Name = "NameTL"
GuiTbl.NameTL.Parent = GuiTbl.ToggleEx
GuiTbl.NameTL.Active = true
GuiTbl.NameTL.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.NameTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL.BackgroundTransparency = 1.000
GuiTbl.NameTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NameTL.BorderSizePixel = 0
GuiTbl.NameTL.Position = UDim2.new(0.0500000007, 0, 0.5, 0)
GuiTbl.NameTL.Size = UDim2.new(0.600000024, 0, 0, 30)
GuiTbl.NameTL.ZIndex = 2
GuiTbl.NameTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NameTL.Text = "AimAssist"
GuiTbl.NameTL.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL.TextScaled = true
GuiTbl.NameTL.TextSize = 21
GuiTbl.NameTL.TextStrokeTransparency = 0.000
GuiTbl.NameTL.TextWrapped = true
GuiTbl.NameTL.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.ToggleSwitchSlider.Name = "ToggleSwitchSlider"
GuiTbl.ToggleSwitchSlider.Parent = GuiTbl.ToggleEx
GuiTbl.ToggleSwitchSlider.Active = false
GuiTbl.ToggleSwitchSlider.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.ToggleSwitchSlider.BackgroundColor3 = Color3.fromRGB(113, 113, 113)
GuiTbl.ToggleSwitchSlider.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.ToggleSwitchSlider.Position = UDim2.new(0.949999988, 0, 0.5, 0)
GuiTbl.ToggleSwitchSlider.Selectable = false
GuiTbl.ToggleSwitchSlider.Size = UDim2.new(0.25, 0, 0.600000024, 0)
GuiTbl.ToggleSwitchSlider.ZIndex = 2
GuiTbl.ToggleSwitchSlider.AutoButtonColor = false

GuiTbl.UICorner_4.CornerRadius = UDim.new(1, 0)
GuiTbl.UICorner_4.Parent = GuiTbl.ToggleSwitchSlider

GuiTbl.ToggleCircle.Name = "ToggleCircle"
GuiTbl.ToggleCircle.Parent = GuiTbl.ToggleSwitchSlider
GuiTbl.ToggleCircle.Active = true
GuiTbl.ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.ToggleCircle.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
GuiTbl.ToggleCircle.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.ToggleCircle.Position = UDim2.new(0.603999972, 0, 0.5, 0)
GuiTbl.ToggleCircle.Size = UDim2.new(0.345999986, 0, 0.649999976, 0)
GuiTbl.ToggleCircle.ZIndex = 3

GuiTbl.UICorner_5.CornerRadius = UDim.new(0, 100)
GuiTbl.UICorner_5.Parent = GuiTbl.ToggleCircle

GuiTbl.UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
GuiTbl.UIGradient.Rotation = 90
GuiTbl.UIGradient.Parent = GuiTbl.ToggleCircle

GuiTbl.UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
GuiTbl.UIGradient_2.Rotation = 90
GuiTbl.UIGradient_2.Parent = GuiTbl.ToggleSwitchSlider

GuiTbl.UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_3.Parent = GuiTbl.ToggleEx

GuiTbl.SliderEx.Name = "SliderEx"
C.AddGlobalInstance(GuiTbl.SliderEx)
C.Examples.SliderEx = GuiTbl.SliderEx
GuiTbl.SliderEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
GuiTbl.SliderEx.BackgroundTransparency = 1.000
GuiTbl.SliderEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SliderEx.BorderSizePixel = 0
GuiTbl.SliderEx.Size = UDim2.new(1, 0, 0, 60)

GuiTbl.NameTL_2.Name = "NameTL"
GuiTbl.NameTL_2.Parent = GuiTbl.SliderEx
GuiTbl.NameTL_2.Active = true
GuiTbl.NameTL_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_2.BackgroundTransparency = 1.000
GuiTbl.NameTL_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NameTL_2.BorderSizePixel = 0
GuiTbl.NameTL_2.Position = UDim2.new(0.0500000007, 0, 0, 0)
GuiTbl.NameTL_2.Size = UDim2.new(0.600000024, 0, 0, 30)
GuiTbl.NameTL_2.ZIndex = 2
GuiTbl.NameTL_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NameTL_2.Text = "Range"
GuiTbl.NameTL_2.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_2.TextScaled = true
GuiTbl.NameTL_2.TextSize = 21
GuiTbl.NameTL_2.TextStrokeTransparency = 0.000
GuiTbl.NameTL_2.TextWrapped = true
GuiTbl.NameTL_2.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.SlidingBar.Name = "SlidingBar"
GuiTbl.SlidingBar.Parent = GuiTbl.SliderEx
GuiTbl.SlidingBar.AnchorPoint = Vector2.new(0.5, 1)
GuiTbl.SlidingBar.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
GuiTbl.SlidingBar.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.SlidingBar.Position = UDim2.new(0.5, 0, 0.879999995, 0)
GuiTbl.SlidingBar.Selectable = false
GuiTbl.SlidingBar.Size = UDim2.new(0.699999988, 0, 0, 15)
GuiTbl.SlidingBar.ZIndex = 2
GuiTbl.SlidingBar.AutoButtonColor = false

GuiTbl.UICorner_6.CornerRadius = UDim.new(1, 0)
GuiTbl.UICorner_6.Parent = GuiTbl.SlidingBar

GuiTbl.CurrentPosition.Name = "CurrentPosition"
GuiTbl.CurrentPosition.Parent = GuiTbl.SlidingBar
GuiTbl.CurrentPosition.Active = true
GuiTbl.CurrentPosition.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.CurrentPosition.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
GuiTbl.CurrentPosition.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.CurrentPosition.Position = UDim2.new(0.200000003, 0, 0.5, 0)
GuiTbl.CurrentPosition.Size = UDim2.new(0.100000001, 0, 1, 0)
GuiTbl.CurrentPosition.ZIndex = 3

GuiTbl.UICorner_7.CornerRadius = UDim.new(0, 100)
GuiTbl.UICorner_7.Parent = GuiTbl.CurrentPosition

GuiTbl.UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
GuiTbl.UIGradient_3.Rotation = 90
GuiTbl.UIGradient_3.Parent = GuiTbl.CurrentPosition

GuiTbl.UIGradient_4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
GuiTbl.UIGradient_4.Rotation = 90
GuiTbl.UIGradient_4.Parent = GuiTbl.SlidingBar

GuiTbl.Backing.Name = "Backing"
GuiTbl.Backing.Parent = GuiTbl.SlidingBar
GuiTbl.Backing.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.Backing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Backing.BackgroundTransparency = 1.000
GuiTbl.Backing.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Backing.BorderSizePixel = 0
GuiTbl.Backing.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.Backing.Size = UDim2.new(1.29999995, 0, 1.70000005, 0)
GuiTbl.Backing.ZIndex = 9

GuiTbl.Track.Name = "Track"
GuiTbl.Track.Parent = GuiTbl.SlidingBar
GuiTbl.Track.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.Track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Track.BackgroundTransparency = 1.000
GuiTbl.Track.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Track.BorderSizePixel = 0
GuiTbl.Track.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.Track.Size = UDim2.new(0.899999976, 0, 0.100000001, 0)
GuiTbl.Track.ZIndex = 9

GuiTbl.ForceTB.Name = "ForceTB"
GuiTbl.ForceTB.Parent = GuiTbl.SliderEx
GuiTbl.ForceTB.AnchorPoint = Vector2.new(1, 0)
GuiTbl.ForceTB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ForceTB.BackgroundTransparency = 1.000
GuiTbl.ForceTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ForceTB.BorderSizePixel = 0
GuiTbl.ForceTB.Position = UDim2.new(1, 0, 0, 0)
GuiTbl.ForceTB.Size = UDim2.new(0.300000012, 0, 0, 30)
GuiTbl.ForceTB.ZIndex = 3
GuiTbl.ForceTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.ForceTB.Text = ""
GuiTbl.ForceTB.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ForceTB.TextScaled = true
GuiTbl.ForceTB.TextSize = 21
GuiTbl.ForceTB.TextStrokeTransparency = 0.000
GuiTbl.ForceTB.TextWrapped = true

GuiTbl.TBUnderbar.Name = "TBUnderbar"
GuiTbl.TBUnderbar.Parent = GuiTbl.ForceTB
GuiTbl.TBUnderbar.AnchorPoint = Vector2.new(0.5, 1)
GuiTbl.TBUnderbar.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
GuiTbl.TBUnderbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TBUnderbar.BorderSizePixel = 0
GuiTbl.TBUnderbar.Position = UDim2.new(0.5, 0, 0.959999979, 0)
GuiTbl.TBUnderbar.Size = UDim2.new(0.400000006, 0, 0, 1)

GuiTbl.LeftBound.Name = "LeftBound"
GuiTbl.LeftBound.Parent = GuiTbl.SliderEx
GuiTbl.LeftBound.Active = true
GuiTbl.LeftBound.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LeftBound.BackgroundTransparency = 1.000
GuiTbl.LeftBound.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.LeftBound.BorderSizePixel = 0
GuiTbl.LeftBound.Position = UDim2.new(0.0500000007, 0, 0.629999995, 0)
GuiTbl.LeftBound.Size = UDim2.new(0.100000001, 0, -0.25, 30)
GuiTbl.LeftBound.ZIndex = 2
GuiTbl.LeftBound.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.LeftBound.Text = "30"
GuiTbl.LeftBound.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LeftBound.TextScaled = true
GuiTbl.LeftBound.TextSize = 21
GuiTbl.LeftBound.TextStrokeTransparency = 0.000
GuiTbl.LeftBound.TextWrapped = true

GuiTbl.RightBound.Name = "RightBound"
GuiTbl.RightBound.Parent = GuiTbl.SliderEx
GuiTbl.RightBound.Active = true
GuiTbl.RightBound.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.RightBound.BackgroundTransparency = 1.000
GuiTbl.RightBound.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.RightBound.BorderSizePixel = 0
GuiTbl.RightBound.Position = UDim2.new(0.850000024, 0, 0.629999995, 0)
GuiTbl.RightBound.Size = UDim2.new(0.100000001, 0, -0.25, 30)
GuiTbl.RightBound.ZIndex = 2
GuiTbl.RightBound.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.RightBound.Text = "100"
GuiTbl.RightBound.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.RightBound.TextScaled = true
GuiTbl.RightBound.TextSize = 21
GuiTbl.RightBound.TextStrokeTransparency = 0.000
GuiTbl.RightBound.TextWrapped = true

GuiTbl.UIStroke_4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_4.Parent = GuiTbl.SliderEx

GuiTbl.DropdownEx.Name = "DropdownEx"
C.AddGlobalInstance(GuiTbl.DropdownEx)
C.Examples.DropdownEx = GuiTbl.DropdownEx
GuiTbl.DropdownEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
GuiTbl.DropdownEx.BackgroundTransparency = 1.000
GuiTbl.DropdownEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropdownEx.BorderSizePixel = 0
GuiTbl.DropdownEx.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.NameTL_3.Name = "NameTL"
GuiTbl.NameTL_3.Parent = GuiTbl.DropdownEx
GuiTbl.NameTL_3.Active = true
GuiTbl.NameTL_3.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.NameTL_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_3.BackgroundTransparency = 1.000
GuiTbl.NameTL_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NameTL_3.BorderSizePixel = 0
GuiTbl.NameTL_3.Position = UDim2.new(0.0500000007, 0, 0.5, 0)
GuiTbl.NameTL_3.Size = UDim2.new(0.5, 0, 0, 30)
GuiTbl.NameTL_3.ZIndex = 2
GuiTbl.NameTL_3.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NameTL_3.Text = "AimAssist"
GuiTbl.NameTL_3.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_3.TextScaled = true
GuiTbl.NameTL_3.TextSize = 21
GuiTbl.NameTL_3.TextStrokeTransparency = 0.000
GuiTbl.NameTL_3.TextWrapped = true
GuiTbl.NameTL_3.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.UIStroke_5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_5.Parent = GuiTbl.DropdownEx

GuiTbl.DropdownButton.Name = "DropdownButton"
GuiTbl.DropdownButton.Parent = GuiTbl.DropdownEx
GuiTbl.DropdownButton.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.DropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GuiTbl.DropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropdownButton.BorderSizePixel = 0
GuiTbl.DropdownButton.Position = UDim2.new(0.970000029, 0, 0.5, 0)
GuiTbl.DropdownButton.Size = UDim2.new(0.400000006, 0, 0, 30)
GuiTbl.DropdownButton.ZIndex = 2
GuiTbl.DropdownButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.DropdownButton.Text = "God Mode⬇"
GuiTbl.DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.DropdownButton.TextScaled = true
GuiTbl.DropdownButton.TextSize = 21
GuiTbl.DropdownButton.TextStrokeTransparency = 0.000
GuiTbl.DropdownButton.TextWrapped = true

GuiTbl.UICorner_8.Parent = GuiTbl.DropdownButton

GuiTbl.UIStroke_6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_6.Parent = GuiTbl.DropdownButton

GuiTbl.UserListEx.Name = "UserListEx"
C.AddGlobalInstance(GuiTbl.UserListEx)
C.Examples.UserListEx = GuiTbl.UserListEx
GuiTbl.UserListEx.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.UserListEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
GuiTbl.UserListEx.BackgroundTransparency = 1.000
GuiTbl.UserListEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.UserListEx.BorderSizePixel = 0
GuiTbl.UserListEx.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.NameTL_4.Name = "NameTL"
GuiTbl.NameTL_4.Parent = GuiTbl.UserListEx
GuiTbl.NameTL_4.Active = true
GuiTbl.NameTL_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_4.BackgroundTransparency = 1.000
GuiTbl.NameTL_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NameTL_4.BorderSizePixel = 0
GuiTbl.NameTL_4.Position = UDim2.new(0.0500000007, 0, 0, 5)
GuiTbl.NameTL_4.Size = UDim2.new(0.699999988, 0, 0, 30)
GuiTbl.NameTL_4.ZIndex = 2
GuiTbl.NameTL_4.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NameTL_4.Text = "AimAssist"
GuiTbl.NameTL_4.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_4.TextScaled = true
GuiTbl.NameTL_4.TextSize = 21
GuiTbl.NameTL_4.TextStrokeTransparency = 0.000
GuiTbl.NameTL_4.TextWrapped = true
GuiTbl.NameTL_4.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.UIStroke_7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_7.Parent = GuiTbl.UserListEx

GuiTbl.AddButton.Name = "AddButton"
GuiTbl.AddButton.Parent = GuiTbl.UserListEx
GuiTbl.AddButton.AnchorPoint = Vector2.new(1, 0)
GuiTbl.AddButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GuiTbl.AddButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.AddButton.BorderSizePixel = 0
GuiTbl.AddButton.Position = UDim2.new(0.970000029, 0, 0, 40)
GuiTbl.AddButton.Size = UDim2.new(0.150000006, 0, 0, 30)
GuiTbl.AddButton.ZIndex = 2
GuiTbl.AddButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.AddButton.Text = "+"
GuiTbl.AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.AddButton.TextScaled = true
GuiTbl.AddButton.TextSize = 21
GuiTbl.AddButton.TextStrokeTransparency = 0.000
GuiTbl.AddButton.TextWrapped = true

GuiTbl.UICorner_9.Parent = GuiTbl.AddButton

GuiTbl.UIStroke_8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_8.Parent = GuiTbl.AddButton

GuiTbl.MainList.Name = "MainList"
GuiTbl.MainList.Parent = GuiTbl.UserListEx
GuiTbl.MainList.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.MainList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.MainList.BackgroundTransparency = 1.000
GuiTbl.MainList.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MainList.BorderSizePixel = 0
GuiTbl.MainList.Position = UDim2.new(0, 0, 0, 80)
GuiTbl.MainList.Size = UDim2.new(1, 0, 0, 0)

GuiTbl.UIListLayout_7.Parent = GuiTbl.MainList
GuiTbl.UIListLayout_7.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.OneListEx.Name = "OneListEx"
C.AddGlobalInstance(GuiTbl.OneListEx)
C.Examples.OneListEx = GuiTbl.OneListEx
GuiTbl.OneListEx.BackgroundColor3 = Color3.fromRGB(79, 79, 79)
GuiTbl.OneListEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.OneListEx.BorderSizePixel = 0
GuiTbl.OneListEx.Size = UDim2.new(1, 0, 0, 20)

GuiTbl.DeleteButton.Name = "DeleteButton"
GuiTbl.DeleteButton.Parent = GuiTbl.OneListEx
GuiTbl.DeleteButton.AnchorPoint = Vector2.new(1, 0)
GuiTbl.DeleteButton.BackgroundColor3 = Color3.fromRGB(198, 0, 0)
GuiTbl.DeleteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DeleteButton.BorderSizePixel = 0
GuiTbl.DeleteButton.Position = UDim2.new(0.970000029, 0, 0, 0)
GuiTbl.DeleteButton.Size = UDim2.new(0.150000006, 0, 1, 0)
GuiTbl.DeleteButton.ZIndex = 2
GuiTbl.DeleteButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.DeleteButton.Text = "X"
GuiTbl.DeleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.DeleteButton.TextScaled = true
GuiTbl.DeleteButton.TextSize = 21
GuiTbl.DeleteButton.TextStrokeTransparency = 0.000
GuiTbl.DeleteButton.TextWrapped = true

GuiTbl.UICorner_10.Parent = GuiTbl.DeleteButton

GuiTbl.UIStroke_9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_9.Parent = GuiTbl.DeleteButton

GuiTbl.UserTL.Name = "UserTL"
GuiTbl.UserTL.Parent = GuiTbl.OneListEx
GuiTbl.UserTL.Active = true
GuiTbl.UserTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.UserTL.BackgroundTransparency = 1.000
GuiTbl.UserTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.UserTL.BorderSizePixel = 0
GuiTbl.UserTL.Position = UDim2.new(0.0500000007, 0, 0, 0)
GuiTbl.UserTL.Size = UDim2.new(0.699999988, 0, 1, 0)
GuiTbl.UserTL.ZIndex = 2
GuiTbl.UserTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.UserTL.Text = "areallycoolguy"
GuiTbl.UserTL.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.UserTL.TextScaled = true
GuiTbl.UserTL.TextSize = 21
GuiTbl.UserTL.TextStrokeTransparency = 0.000
GuiTbl.UserTL.TextWrapped = true
GuiTbl.UserTL.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.EnterTB.Name = "EnterTB"
GuiTbl.EnterTB.Parent = GuiTbl.UserListEx
GuiTbl.EnterTB.BackgroundColor3 = Color3.fromRGB(188, 188, 188)
GuiTbl.EnterTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.EnterTB.BorderSizePixel = 0
GuiTbl.EnterTB.Position = UDim2.new(0.0500000007, 0, 0, 40)
GuiTbl.EnterTB.Selectable = false
GuiTbl.EnterTB.Size = UDim2.new(0.730000019, 0, 0, 30)
GuiTbl.EnterTB.ZIndex = 2
GuiTbl.EnterTB.ClearTextOnFocus = false
GuiTbl.EnterTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.EnterTB.PlaceholderText = "Enter username/userid"
GuiTbl.EnterTB.Text = ""
GuiTbl.EnterTB.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.EnterTB.TextScaled = true
GuiTbl.EnterTB.TextSize = 21
GuiTbl.EnterTB.TextStrokeTransparency = 0.000
GuiTbl.EnterTB.TextWrapped = true

GuiTbl.UICorner_11.Parent = GuiTbl.EnterTB

GuiTbl.UIStroke_10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_10.Parent = GuiTbl.EnterTB

GuiTbl.LimitTL.Name = "LimitTL"
GuiTbl.LimitTL.Parent = GuiTbl.UserListEx
GuiTbl.LimitTL.Active = true
GuiTbl.LimitTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LimitTL.BackgroundTransparency = 1.000
GuiTbl.LimitTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.LimitTL.BorderSizePixel = 0
GuiTbl.LimitTL.Position = UDim2.new(0.789999783, 0, 0, 5)
GuiTbl.LimitTL.Size = UDim2.new(0.177391246, 0, 0, 30)
GuiTbl.LimitTL.ZIndex = 2
GuiTbl.LimitTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
GuiTbl.LimitTL.Text = "0/50"
GuiTbl.LimitTL.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LimitTL.TextScaled = true
GuiTbl.LimitTL.TextSize = 21
GuiTbl.LimitTL.TextStrokeTransparency = 0.000
GuiTbl.LimitTL.TextWrapped = true
GuiTbl.LimitTL.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.TextboxEx.Name = "TextboxEx"
C.AddGlobalInstance(GuiTbl.TextboxEx)
C.Examples.TextboxEx = GuiTbl.TextboxEx
GuiTbl.TextboxEx.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.TextboxEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
GuiTbl.TextboxEx.BackgroundTransparency = 1.000
GuiTbl.TextboxEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TextboxEx.BorderSizePixel = 0
GuiTbl.TextboxEx.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.NameTL_5.Name = "NameTL"
GuiTbl.NameTL_5.Parent = GuiTbl.TextboxEx
GuiTbl.NameTL_5.Active = true
GuiTbl.NameTL_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_5.BackgroundTransparency = 1.000
GuiTbl.NameTL_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NameTL_5.BorderSizePixel = 0
GuiTbl.NameTL_5.Position = UDim2.new(0.0500000007, 0, 0, 5)
GuiTbl.NameTL_5.Size = UDim2.new(0.699999988, 0, 0, 30)
GuiTbl.NameTL_5.ZIndex = 2
GuiTbl.NameTL_5.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NameTL_5.Text = "AimAssist"
GuiTbl.NameTL_5.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_5.TextScaled = true
GuiTbl.NameTL_5.TextSize = 21
GuiTbl.NameTL_5.TextStrokeTransparency = 0.000
GuiTbl.NameTL_5.TextWrapped = true
GuiTbl.NameTL_5.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.UIStroke_11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_11.Parent = GuiTbl.TextboxEx

GuiTbl.SetTB.Name = "SetTB"
GuiTbl.SetTB.Parent = GuiTbl.TextboxEx
GuiTbl.SetTB.BackgroundColor3 = Color3.fromRGB(188, 188, 188)
GuiTbl.SetTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SetTB.BorderSizePixel = 0
GuiTbl.SetTB.Position = UDim2.new(0.0500000007, 0, 0, 40)
GuiTbl.SetTB.Selectable = false
GuiTbl.SetTB.Size = UDim2.new(0.730000019, 0, 0, 30)
GuiTbl.SetTB.ZIndex = 2
GuiTbl.SetTB.ClearTextOnFocus = false
GuiTbl.SetTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.SetTB.PlaceholderText = "Enter something here.."
GuiTbl.SetTB.Text = ""
GuiTbl.SetTB.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SetTB.TextScaled = true
GuiTbl.SetTB.TextSize = 21
GuiTbl.SetTB.TextStrokeTransparency = 0.100
GuiTbl.SetTB.TextTransparency = 0.100
GuiTbl.SetTB.TextWrapped = true

GuiTbl.UICorner_12.Parent = GuiTbl.SetTB

GuiTbl.UIStroke_12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_12.Parent = GuiTbl.SetTB

GuiTbl.LimitTL_2.Name = "LimitTL"
GuiTbl.LimitTL_2.Parent = GuiTbl.TextboxEx
GuiTbl.LimitTL_2.Active = true
GuiTbl.LimitTL_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LimitTL_2.BackgroundTransparency = 1.000
GuiTbl.LimitTL_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.LimitTL_2.BorderSizePixel = 0
GuiTbl.LimitTL_2.Position = UDim2.new(0.789999783, 0, 0, 5)
GuiTbl.LimitTL_2.Size = UDim2.new(0.177391246, 0, 0, 30)
GuiTbl.LimitTL_2.ZIndex = 2
GuiTbl.LimitTL_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
GuiTbl.LimitTL_2.Text = "0/50"
GuiTbl.LimitTL_2.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LimitTL_2.TextScaled = true
GuiTbl.LimitTL_2.TextSize = 21
GuiTbl.LimitTL_2.TextStrokeTransparency = 0.000
GuiTbl.LimitTL_2.TextWrapped = true
GuiTbl.LimitTL_2.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.EnterButton.Name = "EnterButton"
GuiTbl.EnterButton.Parent = GuiTbl.TextboxEx
GuiTbl.EnterButton.AnchorPoint = Vector2.new(1, 0)
GuiTbl.EnterButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GuiTbl.EnterButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.EnterButton.BorderSizePixel = 0
GuiTbl.EnterButton.Position = UDim2.new(0.970000029, 0, 0, 40)
GuiTbl.EnterButton.Size = UDim2.new(0.150000006, 0, 0, 30)
GuiTbl.EnterButton.ZIndex = 2
C.SetImage(GuiTbl.EnterButton,"rbxassetid://504367763")

GuiTbl.UICorner_13.Parent = GuiTbl.EnterButton

GuiTbl.UIStroke_13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_13.Parent = GuiTbl.EnterButton

GuiTbl.HighlightBackground.Name = "HighlightBackground"
GuiTbl.HighlightBackground.Parent = GuiTbl.HackButtonEx
GuiTbl.HighlightBackground.BackgroundColor3 = Color3.fromRGB(0, 255, 60)
GuiTbl.HighlightBackground.BackgroundTransparency = 1.000
GuiTbl.HighlightBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HighlightBackground.BorderSizePixel = 0
GuiTbl.HighlightBackground.Size = UDim2.new(1, 20, 0, 40)

GuiTbl.KeybindButton.Name = "KeybindButton"
GuiTbl.KeybindButton.Parent = GuiTbl.HackButtonEx
GuiTbl.KeybindButton.Active = false
GuiTbl.KeybindButton.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.KeybindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.KeybindButton.BackgroundTransparency = 1.000
GuiTbl.KeybindButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.KeybindButton.BorderSizePixel = 0
GuiTbl.KeybindButton.Position = UDim2.new(0.841303527, 0, 0, 20)
GuiTbl.KeybindButton.Selectable = false
GuiTbl.KeybindButton.Size = UDim2.new(0.150000006, 0, 0, 40)
GuiTbl.KeybindButton.ZIndex = 3
C.SetImage(GuiTbl.KeybindButton,"rbxassetid://6884453656")
GuiTbl.KeybindButton.ScaleType = Enum.ScaleType.Fit

GuiTbl.BindedKey.Name = "BindedKey"
GuiTbl.BindedKey.Parent = GuiTbl.KeybindButton
GuiTbl.BindedKey.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.BindedKey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.BindedKey.BackgroundTransparency = 1.000
GuiTbl.BindedKey.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.BindedKey.BorderSizePixel = 0
GuiTbl.BindedKey.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.BindedKey.Size = UDim2.new(0.800000012, 0, 0.600000024, 0)
GuiTbl.BindedKey.ZIndex = 4
GuiTbl.BindedKey.FontFace = Font.new("rbxasset://fonts/families/Jura.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
GuiTbl.BindedKey.Text = ""
GuiTbl.BindedKey.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.BindedKey.TextScaled = true
GuiTbl.BindedKey.TextSize = 21
GuiTbl.BindedKey.TextStrokeTransparency = 0.000
GuiTbl.BindedKey.TextWrapped = true

GuiTbl.KeybindLabel.Name = "KeybindLabel"
GuiTbl.KeybindLabel.Parent = GuiTbl.HackButtonEx
GuiTbl.KeybindLabel.Active = true
GuiTbl.KeybindLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.KeybindLabel.BackgroundTransparency = 1.000
GuiTbl.KeybindLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.KeybindLabel.BorderSizePixel = 0
GuiTbl.KeybindLabel.Position = UDim2.new(0.0500000007, 0, 0, 0)
GuiTbl.KeybindLabel.Size = UDim2.new(0.649999976, 0, 0, 40)
GuiTbl.KeybindLabel.Visible = false
GuiTbl.KeybindLabel.ZIndex = 3
GuiTbl.KeybindLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.KeybindLabel.Text = "PRESS KEY TO BIND"
GuiTbl.KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.KeybindLabel.TextScaled = true
GuiTbl.KeybindLabel.TextSize = 21
GuiTbl.KeybindLabel.TextStrokeTransparency = 0.000
GuiTbl.KeybindLabel.TextWrapped = true
GuiTbl.KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.KeybindBacking.Name = "KeybindBacking"
GuiTbl.KeybindBacking.Parent = GuiTbl.KeybindLabel
GuiTbl.KeybindBacking.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.KeybindBacking.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.KeybindBacking.BorderSizePixel = 0
GuiTbl.KeybindBacking.Position = UDim2.new(-0.0769230798, 0, 0, 0)
GuiTbl.KeybindBacking.Size = UDim2.new(1.53846157, 0, 1, 0)
GuiTbl.KeybindBacking.ZIndex = 2

GuiTbl.UIGradient_5.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(117, 75, 255)), ColorSequenceKeypoint.new(0.52, Color3.fromRGB(169, 0, 23)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(197, 255, 39))}
GuiTbl.UIGradient_5.Parent = GuiTbl.KeybindBacking

GuiTbl.ToolTipHeaderFrame.Name = "ToolTipHeaderFrame"
GuiTbl.ToolTipHeaderFrame.Parent = GuiTbl.MainHUD
C.UI.ToolTipHeaderFrame = GuiTbl.ToolTipHeaderFrame
GuiTbl.ToolTipHeaderFrame.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.ToolTipHeaderFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
GuiTbl.ToolTipHeaderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ToolTipHeaderFrame.BorderSizePixel = 0
GuiTbl.ToolTipHeaderFrame.Position = UDim2.new(0, 536, 0, 180)
GuiTbl.ToolTipHeaderFrame.Size = UDim2.new(0, 200, 0, 0)
GuiTbl.ToolTipHeaderFrame.Visible = false
GuiTbl.ToolTipHeaderFrame.ZIndex = 15

GuiTbl.ToolTipText.Name = "ToolTipText"
GuiTbl.ToolTipText.Parent = GuiTbl.ToolTipHeaderFrame
GuiTbl.ToolTipText.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.ToolTipText.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.ToolTipText.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
GuiTbl.ToolTipText.BackgroundTransparency = 1.000
GuiTbl.ToolTipText.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ToolTipText.BorderSizePixel = 0
GuiTbl.ToolTipText.Position = UDim2.new(0.5, 0, 0, 0)
GuiTbl.ToolTipText.Size = UDim2.new(0.800000012, 0, 0, 0)
GuiTbl.ToolTipText.ZIndex = 16
GuiTbl.ToolTipText.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.ToolTipText.Text = "Aims At Enemies"
GuiTbl.ToolTipText.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ToolTipText.TextSize = 22.000
GuiTbl.ToolTipText.TextStrokeTransparency = 0.000
GuiTbl.ToolTipText.TextWrapped = true

GuiTbl.UICorner_14.CornerRadius = UDim.new(0.400000006, 0)
GuiTbl.UICorner_14.Parent = GuiTbl.ToolTipHeaderFrame

GuiTbl.Notifications.Name = "Notifications"
GuiTbl.Notifications.Parent = GuiTbl.SpecterGUI
C.UI.Notifications = GuiTbl.Notifications
GuiTbl.Notifications.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Notifications.BackgroundTransparency = 1.000
GuiTbl.Notifications.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Notifications.BorderSizePixel = 0
GuiTbl.Notifications.Size = UDim2.new(1, 0, 1, 0)

GuiTbl.NotificationEx.Name = "NotificationEx"
C.AddGlobalInstance(GuiTbl.NotificationEx)
C.Examples.NotificationEx = GuiTbl.NotificationEx
GuiTbl.NotificationEx.AnchorPoint = Vector2.new(1, 1)
GuiTbl.NotificationEx.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GuiTbl.NotificationEx.BackgroundTransparency = 0.300
GuiTbl.NotificationEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NotificationEx.BorderSizePixel = 0
GuiTbl.NotificationEx.Position = UDim2.new(1, 0, 1, 0)
GuiTbl.NotificationEx.Size = UDim2.new(0.150000006, 0, 0.100000001, 0)
GuiTbl.NotificationEx.Visible = false
GuiTbl.NotificationEx.ZIndex = 2

GuiTbl.Timer.Name = "Timer"
GuiTbl.Timer.Parent = GuiTbl.NotificationEx
GuiTbl.Timer.AnchorPoint = Vector2.new(0, 1)
GuiTbl.Timer.BackgroundColor3 = Color3.fromRGB(0, 115, 255)
GuiTbl.Timer.BackgroundTransparency = 0.600
GuiTbl.Timer.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Timer.BorderSizePixel = 0
GuiTbl.Timer.Position = UDim2.new(0, 0, 1, -15)
GuiTbl.Timer.Size = UDim2.new(1, 0, 0, 3)
GuiTbl.Timer.ZIndex = 3

GuiTbl.UICorner_15.CornerRadius = UDim.new(0, 20)
GuiTbl.UICorner_15.Parent = GuiTbl.NotificationEx

GuiTbl.NotificationTitle.Name = "NotificationTitle"
GuiTbl.NotificationTitle.Parent = GuiTbl.NotificationEx
GuiTbl.NotificationTitle.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NotificationTitle.BackgroundTransparency = 1.000
GuiTbl.NotificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NotificationTitle.BorderSizePixel = 0
GuiTbl.NotificationTitle.Position = UDim2.new(0.5, 0, -0, 0)
GuiTbl.NotificationTitle.Size = UDim2.new(0.800000012, 0, 0.200000003, 0)
GuiTbl.NotificationTitle.ZIndex = 3
GuiTbl.NotificationTitle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NotificationTitle.Text = "UI Loaded"
GuiTbl.NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NotificationTitle.TextScaled = true
GuiTbl.NotificationTitle.TextSize = 22.000
GuiTbl.NotificationTitle.TextStrokeTransparency = 0.000
GuiTbl.NotificationTitle.TextWrapped = true

GuiTbl.NotificationDesc.Name = "NotificationDesc"
GuiTbl.NotificationDesc.Parent = GuiTbl.NotificationEx
GuiTbl.NotificationDesc.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.NotificationDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NotificationDesc.BackgroundTransparency = 1.000
GuiTbl.NotificationDesc.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NotificationDesc.BorderSizePixel = 0
GuiTbl.NotificationDesc.Position = UDim2.new(0.500000179, 0, 0.190796182, 0)
GuiTbl.NotificationDesc.Size = UDim2.new(0.800000072, 0, 0.583613932, 0)
GuiTbl.NotificationDesc.ZIndex = 3
GuiTbl.NotificationDesc.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NotificationDesc.Text = "UI Loaded"
GuiTbl.NotificationDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NotificationDesc.TextScaled = true
GuiTbl.NotificationDesc.TextSize = 22.000
GuiTbl.NotificationDesc.TextStrokeTransparency = 0.000
GuiTbl.NotificationDesc.TextWrapped = true

GuiTbl.UITextSizeConstraint.Parent = GuiTbl.NotificationDesc
GuiTbl.UITextSizeConstraint.MaxTextSize = 44

GuiTbl.HUDBackgroundFade.Name = "HUDBackgroundFade"
GuiTbl.HUDBackgroundFade.Parent = GuiTbl.SpecterGUI
C.UI.HUDBackgroundFade = GuiTbl.HUDBackgroundFade
GuiTbl.HUDBackgroundFade.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.HUDBackgroundFade.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
GuiTbl.HUDBackgroundFade.BackgroundTransparency = 1.000
GuiTbl.HUDBackgroundFade.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HUDBackgroundFade.BorderSizePixel = 0
GuiTbl.HUDBackgroundFade.LayoutOrder = -30
GuiTbl.HUDBackgroundFade.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.HUDBackgroundFade.Size = UDim2.new(4, 0, 4, 0)
GuiTbl.HUDBackgroundFade.ZIndex = -1200000

GuiTbl.ChatAutoComplete.Name = "ChatAutoComplete"
GuiTbl.ChatAutoComplete.Parent = GuiTbl.SpecterGUI
C.UI.ChatAutoComplete = GuiTbl.ChatAutoComplete
GuiTbl.ChatAutoComplete.Active = true
GuiTbl.ChatAutoComplete.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ChatAutoComplete.BackgroundTransparency = 1.000
GuiTbl.ChatAutoComplete.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ChatAutoComplete.BorderSizePixel = 0
GuiTbl.ChatAutoComplete.Size = UDim2.new(0.300000012, 0, 0, 0)
GuiTbl.ChatAutoComplete.Visible = false
GuiTbl.ChatAutoComplete.AutomaticCanvasSize = Enum.AutomaticSize.Y
GuiTbl.ChatAutoComplete.CanvasSize = UDim2.new(0, 0, 0, 0)

GuiTbl.AutoCompleteEx.Name = "AutoCompleteEx"
C.AddGlobalInstance(GuiTbl.AutoCompleteEx)
C.Examples.AutoCompleteEx = GuiTbl.AutoCompleteEx
GuiTbl.AutoCompleteEx.BackgroundColor3 = Color3.fromRGB(55, 255, 0)
GuiTbl.AutoCompleteEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.AutoCompleteEx.BorderSizePixel = 0
GuiTbl.AutoCompleteEx.Size = UDim2.new(1, 0, 0, 25)

GuiTbl.AutoCompleteTitleLabel.Name = "AutoCompleteTitleLabel"
GuiTbl.AutoCompleteTitleLabel.Parent = GuiTbl.AutoCompleteEx
GuiTbl.AutoCompleteTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.AutoCompleteTitleLabel.BackgroundTransparency = 1.000
GuiTbl.AutoCompleteTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.AutoCompleteTitleLabel.BorderSizePixel = 0
GuiTbl.AutoCompleteTitleLabel.Size = UDim2.new(1, 0, 1, 0)
GuiTbl.AutoCompleteTitleLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.AutoCompleteTitleLabel.Text = "This sounds cool"
GuiTbl.AutoCompleteTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.AutoCompleteTitleLabel.TextScaled = true
GuiTbl.AutoCompleteTitleLabel.TextSize = 21
GuiTbl.AutoCompleteTitleLabel.TextStrokeTransparency = 0.000
GuiTbl.AutoCompleteTitleLabel.TextWrapped = true

GuiTbl.UIListLayout_8.Parent = GuiTbl.ChatAutoComplete
GuiTbl.UIListLayout_8.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.Actions.Name = "Actions"
GuiTbl.Actions.Parent = GuiTbl.SpecterGUI
C.UI.Actions = GuiTbl.Actions
GuiTbl.Actions.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
GuiTbl.Actions.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Actions.BorderSizePixel = 0
GuiTbl.Actions.LayoutOrder = -14
GuiTbl.Actions.Size = UDim2.new(0.0599999987, 150, 0.0799999982, 200)
GuiTbl.Actions.Visible = false
GuiTbl.Actions.ZIndex = -50

GuiTbl.HeaderTab_3.Name = "HeaderTab"
GuiTbl.HeaderTab_3.Parent = GuiTbl.Actions
GuiTbl.HeaderTab_3.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.HeaderTab_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTab_3.BorderSizePixel = 0
GuiTbl.HeaderTab_3.LayoutOrder = -13
GuiTbl.HeaderTab_3.Size = UDim2.new(1, 0, 0, 30)
GuiTbl.HeaderTab_3.ZIndex = -49

GuiTbl.HeaderTitleLabel_3.Name = "HeaderTitleLabel"
GuiTbl.HeaderTitleLabel_3.Parent = GuiTbl.HeaderTab_3
GuiTbl.HeaderTitleLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel_3.BackgroundTransparency = 1.000
GuiTbl.HeaderTitleLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTitleLabel_3.BorderSizePixel = 0
GuiTbl.HeaderTitleLabel_3.LayoutOrder = -12
GuiTbl.HeaderTitleLabel_3.Size = UDim2.new(0.600000024, 0, 1, 0)
GuiTbl.HeaderTitleLabel_3.Visible = false
GuiTbl.HeaderTitleLabel_3.ZIndex = -47
GuiTbl.HeaderTitleLabel_3.RichText = true
GuiTbl.HeaderTitleLabel_3.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.HeaderTitleLabel_3.Text = " SPECTER"
GuiTbl.HeaderTitleLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel_3.TextScaled = true
GuiTbl.HeaderTitleLabel_3.TextSize = 21
GuiTbl.HeaderTitleLabel_3.TextStrokeTransparency = 0.000
GuiTbl.HeaderTitleLabel_3.TextWrapped = true
GuiTbl.HeaderTitleLabel_3.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.DropDownButton_2.Name = "DropDownButton"
GuiTbl.DropDownButton_2.Parent = GuiTbl.HeaderTab_3
GuiTbl.DropDownButton_2.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.DropDownButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.DropDownButton_2.BackgroundTransparency = 1.000
GuiTbl.DropDownButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropDownButton_2.BorderSizePixel = 0
GuiTbl.DropDownButton_2.LayoutOrder = -12
GuiTbl.DropDownButton_2.Position = UDim2.new(0.980000019, 0, 0.5, 0)
GuiTbl.DropDownButton_2.Size = UDim2.new(0.200000003, 0, 0.5, 0)
GuiTbl.DropDownButton_2.ZIndex = -47
C.SetImage(GuiTbl.DropDownButton_2,"rbxassetid://14569017448")
GuiTbl.DropDownButton_2.ScaleType = Enum.ScaleType.Fit

GuiTbl.Text_3.Name = "Text"
GuiTbl.Text_3.Parent = GuiTbl.HeaderTab_3
GuiTbl.Text_3.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.Text_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text_3.BackgroundTransparency = 1.000
GuiTbl.Text_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Text_3.BorderSizePixel = 0
GuiTbl.Text_3.LayoutOrder = -12
GuiTbl.Text_3.Position = UDim2.new(0.150000036, 0, 0.5, 0)
GuiTbl.Text_3.Size = UDim2.new(0.629999995, 0, 1, 0)
GuiTbl.Text_3.ZIndex = -47
GuiTbl.Text_3.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Text_3.Text = " Actions"
GuiTbl.Text_3.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text_3.TextScaled = true
GuiTbl.Text_3.TextSize = 21
GuiTbl.Text_3.TextWrapped = true
GuiTbl.Text_3.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.Image_4.Name = "Image"
GuiTbl.Image_4.Parent = GuiTbl.HeaderTab_3
GuiTbl.Image_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Image_4.BackgroundTransparency = 1.000
GuiTbl.Image_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Image_4.BorderSizePixel = 0
GuiTbl.Image_4.LayoutOrder = -12
GuiTbl.Image_4.Size = UDim2.new(0.150000006, 0, 1, 0)
GuiTbl.Image_4.ZIndex = -47
C.SetImage(GuiTbl.Image_4,"rbxassetid://8068133")
GuiTbl.Image_4.ScaleType = Enum.ScaleType.Fit

GuiTbl.ScrollTab_3.Name = "ScrollTab"
GuiTbl.ScrollTab_3.Parent = GuiTbl.Actions
GuiTbl.ScrollTab_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ScrollTab_3.BackgroundTransparency = 1.000
GuiTbl.ScrollTab_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ScrollTab_3.BorderSizePixel = 0
GuiTbl.ScrollTab_3.LayoutOrder = -13
GuiTbl.ScrollTab_3.Position = UDim2.new(0, 0, 0, 30)
GuiTbl.ScrollTab_3.Size = UDim2.new(1, 0, 0, 300)
GuiTbl.ScrollTab_3.ZIndex = -49
GuiTbl.ScrollTab_3.AutomaticCanvasSize = Enum.AutomaticSize.Y
GuiTbl.ScrollTab_3.BottomImage = "rbxassetid://3062505976"
GuiTbl.ScrollTab_3.CanvasSize = UDim2.new(0, 0, 0, 0)
GuiTbl.ScrollTab_3.MidImage = "rbxassetid://3062506202"
GuiTbl.ScrollTab_3.TopImage = "rbxassetid://3062506445"
GuiTbl.ScrollTab_3.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

GuiTbl.UIListLayout_9.Parent = GuiTbl.ScrollTab_3
GuiTbl.UIListLayout_9.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.ActionsEx.Name = "ActionsEx"
C.AddGlobalInstance(GuiTbl.ActionsEx)
C.Examples.ActionsEx = GuiTbl.ActionsEx
GuiTbl.ActionsEx.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ActionsEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ActionsEx.BorderSizePixel = 0
GuiTbl.ActionsEx.Size = UDim2.new(1, 0, 0, 40)
GuiTbl.ActionsEx.ZIndex = -47

GuiTbl.Title.Name = "Title"
GuiTbl.Title.Parent = GuiTbl.ActionsEx
GuiTbl.Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Title.BackgroundTransparency = 1.000
GuiTbl.Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Title.BorderSizePixel = 0
GuiTbl.Title.Size = UDim2.new(0.699999988, 0, 0.5, 0)
GuiTbl.Title.ZIndex = -45
GuiTbl.Title.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Title.Text = "HACKING COMPUTER 5"
GuiTbl.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Title.TextScaled = true
GuiTbl.Title.TextSize = 21
GuiTbl.Title.TextStrokeTransparency = 0.000
GuiTbl.Title.TextWrapped = true

GuiTbl.StopButton.Name = "StopButton"
GuiTbl.StopButton.Parent = GuiTbl.ActionsEx
GuiTbl.StopButton.AnchorPoint = Vector2.new(1, 1)
GuiTbl.StopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GuiTbl.StopButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.StopButton.BorderSizePixel = 0
GuiTbl.StopButton.Position = UDim2.new(1, 0, 1, 0)
GuiTbl.StopButton.Size = UDim2.new(0.286956519, 0, 0.5, 0)
GuiTbl.StopButton.ZIndex = -45
GuiTbl.StopButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.StopButton.Text = "CANCEL"
GuiTbl.StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.StopButton.TextScaled = true
GuiTbl.StopButton.TextSize = 21
GuiTbl.StopButton.TextStrokeTransparency = 0.000
GuiTbl.StopButton.TextWrapped = true

GuiTbl.UIStroke_14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_14.Parent = GuiTbl.StopButton

GuiTbl.Time.Name = "Time"
GuiTbl.Time.Parent = GuiTbl.ActionsEx
GuiTbl.Time.AnchorPoint = Vector2.new(0, 1)
GuiTbl.Time.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Time.BackgroundTransparency = 1.000
GuiTbl.Time.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Time.BorderSizePixel = 0
GuiTbl.Time.Position = UDim2.new(-0, 0, 1, 0)
GuiTbl.Time.Size = UDim2.new(0.713, -1, 0.5, 0)
GuiTbl.Time.ZIndex = -45
GuiTbl.Time.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Time.Text = "34 m, 24 s"
GuiTbl.Time.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Time.TextScaled = true
GuiTbl.Time.TextSize = 21
GuiTbl.Time.TextStrokeTransparency = 0.000
GuiTbl.Time.TextWrapped = true

GuiTbl.UIStroke_15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_15.Parent = GuiTbl.Time

GuiTbl.UIStroke_16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_16.Parent = GuiTbl.ActionsEx

GuiTbl.UIGradient_6.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(140, 140, 140)), ColorSequenceKeypoint.new(0.96, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 39, 39))}
GuiTbl.UIGradient_6.Parent = GuiTbl.ActionsEx

GuiTbl.KickedButton.Name = "KickedButton"
GuiTbl.KickedButton.Parent = GuiTbl.SpecterGUI
C.UI.KickedButton = GuiTbl.KickedButton
GuiTbl.KickedButton.AnchorPoint = Vector2.new(0.5, 1)
GuiTbl.KickedButton.BackgroundColor3 = Color3.fromRGB(255, 106, 32)
GuiTbl.KickedButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.KickedButton.BorderSizePixel = 0
GuiTbl.KickedButton.Position = UDim2.new(0.5, 0, 0.980000019, 0)
GuiTbl.KickedButton.Size = UDim2.new(0.5, 0, 0, 0)
GuiTbl.KickedButton.Visible = false
GuiTbl.KickedButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.KickedButton.Text = "You are kicked. This means that you cannot interact with the game nor other players.Click to hide this prompt"
GuiTbl.KickedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.KickedButton.TextSize = 33.000
GuiTbl.KickedButton.TextStrokeTransparency = 0.000
GuiTbl.KickedButton.TextWrapped = true

GuiTbl.SecondaryHUD.Name = "SecondaryHUD"
GuiTbl.SecondaryHUD.Parent = GuiTbl.SpecterGUI
C.UI.SecondaryHUD = GuiTbl.SecondaryHUD
GuiTbl.SecondaryHUD.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.SecondaryHUD.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
GuiTbl.SecondaryHUD.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SecondaryHUD.BorderSizePixel = 0
GuiTbl.SecondaryHUD.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.SecondaryHUD.Size = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.SecondaryHUD.Visible = false
GuiTbl.SecondaryHUD.ZIndex = 100

GuiTbl.Servers.Name = "Servers"
GuiTbl.Servers.Parent = GuiTbl.SecondaryHUD
GuiTbl.Servers.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
GuiTbl.Servers.BackgroundTransparency = 1.000
GuiTbl.Servers.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Servers.BorderSizePixel = 0
GuiTbl.Servers.Size = UDim2.new(1, 0, 1, 0)
GuiTbl.Servers.ZIndex = 101

GuiTbl.UICorner_16.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_16.Parent = GuiTbl.Servers

GuiTbl.ServersTitleLabel.Name = "ServersTitleLabel"
GuiTbl.ServersTitleLabel.Parent = GuiTbl.Servers
GuiTbl.ServersTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ServersTitleLabel.BackgroundTransparency = 1.000
GuiTbl.ServersTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ServersTitleLabel.BorderSizePixel = 0
GuiTbl.ServersTitleLabel.Position = UDim2.new(0.300000012, 0, 0, 0)
GuiTbl.ServersTitleLabel.Size = UDim2.new(0.699999988, 0, 0.100000001, 0)
GuiTbl.ServersTitleLabel.ZIndex = 102
GuiTbl.ServersTitleLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.ServersTitleLabel.Text = "SERVERS"
GuiTbl.ServersTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ServersTitleLabel.TextScaled = true
GuiTbl.ServersTitleLabel.TextSize = 21
GuiTbl.ServersTitleLabel.TextStrokeTransparency = 0.000
GuiTbl.ServersTitleLabel.TextWrapped = true

GuiTbl.TabsSelection.Name = "TabsSelection"
GuiTbl.TabsSelection.Parent = GuiTbl.Servers
GuiTbl.TabsSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.TabsSelection.BackgroundTransparency = 1.000
GuiTbl.TabsSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TabsSelection.BorderSizePixel = 0
GuiTbl.TabsSelection.Size = UDim2.new(0.300000012, 0, 1, 0)
GuiTbl.TabsSelection.ZIndex = 102

GuiTbl.Game.Name = "Game"
GuiTbl.Game.Parent = GuiTbl.TabsSelection
GuiTbl.Game.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
GuiTbl.Game.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Game.BorderSizePixel = 0
GuiTbl.Game.LayoutOrder = -1
GuiTbl.Game.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Game.ZIndex = 103
GuiTbl.Game.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Game.Text = "This Game"
GuiTbl.Game.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Game.TextScaled = true
GuiTbl.Game.TextSize = 21
GuiTbl.Game.TextStrokeTransparency = 0.000
GuiTbl.Game.TextWrapped = true

GuiTbl.UICorner_17.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_17.Parent = GuiTbl.Game

GuiTbl.UIStroke_17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_17.Parent = GuiTbl.Game

GuiTbl.UIGridLayout.Parent = GuiTbl.TabsSelection
GuiTbl.UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
GuiTbl.UIGridLayout.CellPadding = UDim2.new(0, 0, 0.13333334, 0)
GuiTbl.UIGridLayout.CellSize = UDim2.new(1, 0, 0.150000006, 0)

GuiTbl.Recent.Name = "Recent"
GuiTbl.Recent.Parent = GuiTbl.TabsSelection
GuiTbl.Recent.BackgroundColor3 = Color3.fromRGB(0, 110, 255)
GuiTbl.Recent.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Recent.BorderSizePixel = 0
GuiTbl.Recent.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Recent.ZIndex = 103
GuiTbl.Recent.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Recent.Text = "Recent"
GuiTbl.Recent.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Recent.TextScaled = true
GuiTbl.Recent.TextSize = 21
GuiTbl.Recent.TextStrokeTransparency = 0.000
GuiTbl.Recent.TextWrapped = true

GuiTbl.UICorner_18.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_18.Parent = GuiTbl.Recent

GuiTbl.UIStroke_18.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_18.Parent = GuiTbl.Recent

GuiTbl.Close.Name = "Close"
GuiTbl.Close.Parent = GuiTbl.TabsSelection
GuiTbl.Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GuiTbl.Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Close.BorderSizePixel = 0
GuiTbl.Close.LayoutOrder = 2
GuiTbl.Close.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Close.ZIndex = 103
GuiTbl.Close.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Close.Text = "Exit"
GuiTbl.Close.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Close.TextScaled = true
GuiTbl.Close.TextSize = 21
GuiTbl.Close.TextStrokeTransparency = 0.000
GuiTbl.Close.TextWrapped = true

GuiTbl.UICorner_19.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_19.Parent = GuiTbl.Close

GuiTbl.UIStroke_19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_19.Parent = GuiTbl.Close

GuiTbl.Friend.Name = "Friend"
GuiTbl.Friend.Parent = GuiTbl.TabsSelection
GuiTbl.Friend.BackgroundColor3 = Color3.fromRGB(34, 255, 0)
GuiTbl.Friend.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Friend.BorderSizePixel = 0
GuiTbl.Friend.LayoutOrder = 1
GuiTbl.Friend.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Friend.ZIndex = 103
GuiTbl.Friend.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Friend.Text = "Friends"
GuiTbl.Friend.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Friend.TextScaled = true
GuiTbl.Friend.TextSize = 21
GuiTbl.Friend.TextStrokeTransparency = 0.000
GuiTbl.Friend.TextWrapped = true

GuiTbl.UICorner_20.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_20.Parent = GuiTbl.Friend

GuiTbl.UIStroke_20.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_20.Parent = GuiTbl.Friend

GuiTbl.MainScroll.Name = "MainScroll"
GuiTbl.MainScroll.Parent = GuiTbl.Servers
GuiTbl.MainScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MainScroll.BackgroundTransparency = 1.000
GuiTbl.MainScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MainScroll.BorderSizePixel = 0
GuiTbl.MainScroll.LayoutOrder = -13
GuiTbl.MainScroll.Position = UDim2.new(0.299999952, 0, 0.100000001, 0)
GuiTbl.MainScroll.Size = UDim2.new(0.699999988, 0, 0.760000229, 0)
GuiTbl.MainScroll.ZIndex = 102
GuiTbl.MainScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
GuiTbl.MainScroll.BottomImage = "rbxassetid://3062505976"
GuiTbl.MainScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
GuiTbl.MainScroll.MidImage = "rbxassetid://3062506202"
GuiTbl.MainScroll.TopImage = "rbxassetid://3062506445"

GuiTbl.ServerEx.Name = "ServerEx"
C.AddGlobalInstance(GuiTbl.ServerEx)
C.Examples.ServerEx = GuiTbl.ServerEx
GuiTbl.ServerEx.Active = true
GuiTbl.ServerEx.BackgroundColor3 = Color3.fromRGB(255, 81, 0)
GuiTbl.ServerEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ServerEx.BorderSizePixel = 0
GuiTbl.ServerEx.Size = UDim2.new(1, 0, 0, 60)
GuiTbl.ServerEx.ZIndex = 103

GuiTbl.ServerTitle.Name = "ServerTitle"
GuiTbl.ServerTitle.Parent = GuiTbl.ServerEx
GuiTbl.ServerTitle.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.ServerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ServerTitle.BackgroundTransparency = 1.000
GuiTbl.ServerTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ServerTitle.BorderSizePixel = 0
GuiTbl.ServerTitle.Position = UDim2.new(0.5, 0, 0, 0)
GuiTbl.ServerTitle.Size = UDim2.new(0.800000012, 0, 0.300000012, 0)
GuiTbl.ServerTitle.ZIndex = 103
GuiTbl.ServerTitle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.ServerTitle.Text = "SERVER"
GuiTbl.ServerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ServerTitle.TextScaled = true
GuiTbl.ServerTitle.TextSize = 21
GuiTbl.ServerTitle.TextStrokeTransparency = 0.000
GuiTbl.ServerTitle.TextWrapped = true

GuiTbl.TimeStamp.Name = "TimeStamp"
GuiTbl.TimeStamp.Parent = GuiTbl.ServerEx
GuiTbl.TimeStamp.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.TimeStamp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.TimeStamp.BackgroundTransparency = 1.000
GuiTbl.TimeStamp.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TimeStamp.BorderSizePixel = 0
GuiTbl.TimeStamp.Position = UDim2.new(0.5, 0, 0.699999988, 0)
GuiTbl.TimeStamp.Size = UDim2.new(0.800000012, 0, 0.300000012, 0)
GuiTbl.TimeStamp.ZIndex = 103
GuiTbl.TimeStamp.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.TimeStamp.Text = "7:56 PM"
GuiTbl.TimeStamp.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.TimeStamp.TextScaled = true
GuiTbl.TimeStamp.TextSize = 21
GuiTbl.TimeStamp.TextStrokeTransparency = 0.000
GuiTbl.TimeStamp.TextWrapped = true

GuiTbl.SecondData.Name = "SecondData"
GuiTbl.SecondData.Parent = GuiTbl.ServerEx
GuiTbl.SecondData.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.SecondData.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SecondData.BackgroundTransparency = 1.000
GuiTbl.SecondData.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SecondData.BorderSizePixel = 0
GuiTbl.SecondData.Position = UDim2.new(0.5, 0, 0.349999994, 0)
GuiTbl.SecondData.Size = UDim2.new(0.800000012, 0, 0.300000012, 0)
GuiTbl.SecondData.ZIndex = 103
GuiTbl.SecondData.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.SecondData.Text = "5/10 PLAYERS"
GuiTbl.SecondData.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SecondData.TextScaled = true
GuiTbl.SecondData.TextSize = 21
GuiTbl.SecondData.TextStrokeTransparency = 0.000
GuiTbl.SecondData.TextWrapped = true

GuiTbl.UICorner_21.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_21.Parent = GuiTbl.ServerEx

GuiTbl.UIStroke_21.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_21.Parent = GuiTbl.ServerEx

GuiTbl.UIGridLayout_2.Parent = GuiTbl.MainScroll
GuiTbl.UIGridLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIGridLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
GuiTbl.UIGridLayout_2.CellPadding = UDim2.new(0, 0, 0, 0)
GuiTbl.UIGridLayout_2.CellSize = UDim2.new(0.300000012, 0, 0, 150)

GuiTbl.BottomButtons.Name = "BottomButtons"
GuiTbl.BottomButtons.Parent = GuiTbl.Servers
GuiTbl.BottomButtons.AnchorPoint = Vector2.new(0, 1)
GuiTbl.BottomButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.BottomButtons.BackgroundTransparency = 1.000
GuiTbl.BottomButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.BottomButtons.BorderSizePixel = 0
GuiTbl.BottomButtons.Position = UDim2.new(0.300000012, 0, 0.980000019, 0)
GuiTbl.BottomButtons.Size = UDim2.new(0.699999988, 0, 0.109999999, 0)
GuiTbl.BottomButtons.ZIndex = 102

GuiTbl.Previous.Name = "Previous"
GuiTbl.Previous.Parent = GuiTbl.BottomButtons
GuiTbl.Previous.BackgroundColor3 = Color3.fromRGB(255, 238, 0)
GuiTbl.Previous.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Previous.BorderSizePixel = 0
GuiTbl.Previous.LayoutOrder = -1
GuiTbl.Previous.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Previous.ZIndex = 103
GuiTbl.Previous.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Previous.Text = "Previous"
GuiTbl.Previous.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Previous.TextScaled = true
GuiTbl.Previous.TextSize = 21
GuiTbl.Previous.TextStrokeTransparency = 0.000
GuiTbl.Previous.TextWrapped = true

GuiTbl.UICorner_22.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_22.Parent = GuiTbl.Previous

GuiTbl.UIStroke_22.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_22.Parent = GuiTbl.Previous

GuiTbl.UIGridLayout_3.Parent = GuiTbl.BottomButtons
GuiTbl.UIGridLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIGridLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
GuiTbl.UIGridLayout_3.CellPadding = UDim2.new(0, 0, 0, 0)
GuiTbl.UIGridLayout_3.CellSize = UDim2.new(0.333299994, 0, 1, 0)

GuiTbl.Join.Name = "Join"
GuiTbl.Join.Parent = GuiTbl.BottomButtons
GuiTbl.Join.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
GuiTbl.Join.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Join.BorderSizePixel = 0
GuiTbl.Join.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Join.Visible = false
GuiTbl.Join.ZIndex = 103
GuiTbl.Join.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Join.Text = "Join"
GuiTbl.Join.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Join.TextScaled = true
GuiTbl.Join.TextSize = 21
GuiTbl.Join.TextStrokeTransparency = 0.000
GuiTbl.Join.TextWrapped = true

GuiTbl.UICorner_23.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_23.Parent = GuiTbl.Join

GuiTbl.UIStroke_23.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_23.Parent = GuiTbl.Join

GuiTbl.Next.Name = "Next"
GuiTbl.Next.Parent = GuiTbl.BottomButtons
GuiTbl.Next.BackgroundColor3 = Color3.fromRGB(60, 255, 0)
GuiTbl.Next.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Next.BorderSizePixel = 0
GuiTbl.Next.LayoutOrder = 1
GuiTbl.Next.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Next.ZIndex = 103
GuiTbl.Next.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Next.Text = "Next"
GuiTbl.Next.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Next.TextScaled = true
GuiTbl.Next.TextSize = 21
GuiTbl.Next.TextStrokeTransparency = 0.000
GuiTbl.Next.TextWrapped = true

GuiTbl.UICorner_24.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_24.Parent = GuiTbl.Next

GuiTbl.UIStroke_24.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_24.Parent = GuiTbl.Next

GuiTbl.ExtraLabel.Name = "ExtraLabel"
GuiTbl.ExtraLabel.Parent = GuiTbl.Servers
GuiTbl.ExtraLabel.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.ExtraLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ExtraLabel.BackgroundTransparency = 1.000
GuiTbl.ExtraLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ExtraLabel.BorderSizePixel = 0
GuiTbl.ExtraLabel.Position = UDim2.new(0.5, 0, 1, 0)
GuiTbl.ExtraLabel.Size = UDim2.new(1, 0, 0, 30)
GuiTbl.ExtraLabel.ZIndex = 102
GuiTbl.ExtraLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.ExtraLabel.Text = "Player count or server joinability may not be up to date; Recent lists up to 24 hrs"
GuiTbl.ExtraLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ExtraLabel.TextScaled = true
GuiTbl.ExtraLabel.TextSize = 21
GuiTbl.ExtraLabel.TextStrokeTransparency = 0.000
GuiTbl.ExtraLabel.TextWrapped = true

GuiTbl.NoneFoundLabel.Name = "NoneFoundLabel"
GuiTbl.NoneFoundLabel.Parent = GuiTbl.Servers
GuiTbl.NoneFoundLabel.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.NoneFoundLabel.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.NoneFoundLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NoneFoundLabel.BorderSizePixel = 0
GuiTbl.NoneFoundLabel.Position = UDim2.new(0.649999976, 0, 0.479999989, 0)
GuiTbl.NoneFoundLabel.Size = UDim2.new(0.600000024, 0, 0.699999988, 0)
GuiTbl.NoneFoundLabel.Visible = false
GuiTbl.NoneFoundLabel.ZIndex = 102
GuiTbl.NoneFoundLabel.RichText = true
GuiTbl.NoneFoundLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NoneFoundLabel.Text = "There are no results for this category.<br />Click on the category again to refresh it."
GuiTbl.NoneFoundLabel.TextColor3 = Color3.fromRGB(255, 23, 23)
GuiTbl.NoneFoundLabel.TextScaled = true
GuiTbl.NoneFoundLabel.TextSize = 21
GuiTbl.NoneFoundLabel.TextStrokeTransparency = 0.000
GuiTbl.NoneFoundLabel.TextWrapped = true

GuiTbl.UICorner_25.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_25.Parent = GuiTbl.NoneFoundLabel

GuiTbl.UIStroke_25.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_25.Parent = GuiTbl.NoneFoundLabel

GuiTbl.LoadingLabel.Name = "LoadingLabel"
GuiTbl.LoadingLabel.Parent = GuiTbl.Servers
GuiTbl.LoadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.LoadingLabel.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.LoadingLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.LoadingLabel.BorderSizePixel = 0
GuiTbl.LoadingLabel.Position = UDim2.new(0.649999976, 0, 0.479999989, 0)
GuiTbl.LoadingLabel.Size = UDim2.new(0.600000024, 0, 0.699999988, 0)
GuiTbl.LoadingLabel.ZIndex = 102
GuiTbl.LoadingLabel.RichText = true
GuiTbl.LoadingLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.LoadingLabel.Text = "Loading, please wait...<br />Click on the category again if this takes too long!"
GuiTbl.LoadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LoadingLabel.TextScaled = true
GuiTbl.LoadingLabel.TextSize = 21
GuiTbl.LoadingLabel.TextStrokeTransparency = 0.000
GuiTbl.LoadingLabel.TextWrapped = true

GuiTbl.UICorner_26.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_26.Parent = GuiTbl.LoadingLabel

GuiTbl.UIStroke_26.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_26.Parent = GuiTbl.LoadingLabel

GuiTbl.UICorner_27.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_27.Parent = GuiTbl.SecondaryHUD

GuiTbl.UIStroke_27.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_27.Parent = GuiTbl.SecondaryHUD

GuiTbl.PromptFrame.Name = "PromptFrame"
GuiTbl.PromptFrame.Parent = GuiTbl.SpecterGUI
C.UI.PromptFrame = GuiTbl.PromptFrame
GuiTbl.PromptFrame.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.PromptFrame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
GuiTbl.PromptFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.PromptFrame.BorderSizePixel = 0
GuiTbl.PromptFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.PromptFrame.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
GuiTbl.PromptFrame.Visible = false
GuiTbl.PromptFrame.ZIndex = 1000

GuiTbl.UICorner_28.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_28.Parent = GuiTbl.PromptFrame

GuiTbl.UIStroke_28.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_28.Parent = GuiTbl.PromptFrame

GuiTbl.PromptTitle.Name = "PromptTitle"
GuiTbl.PromptTitle.Parent = GuiTbl.PromptFrame
GuiTbl.PromptTitle.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.PromptTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.PromptTitle.BackgroundTransparency = 1.000
GuiTbl.PromptTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.PromptTitle.BorderSizePixel = 0
GuiTbl.PromptTitle.Position = UDim2.new(0.5, 0, 0, 0)
GuiTbl.PromptTitle.Size = UDim2.new(0.699999988, 0, 0.125, 0)
GuiTbl.PromptTitle.ZIndex = 1002
GuiTbl.PromptTitle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.PromptTitle.Text = "SERVERS"
GuiTbl.PromptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.PromptTitle.TextScaled = true
GuiTbl.PromptTitle.TextSize = 21
GuiTbl.PromptTitle.TextStrokeTransparency = 0.000
GuiTbl.PromptTitle.TextWrapped = true

GuiTbl.PromptDesc.Name = "PromptDesc"
GuiTbl.PromptDesc.Parent = GuiTbl.PromptFrame
GuiTbl.PromptDesc.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.PromptDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.PromptDesc.BackgroundTransparency = 1.000
GuiTbl.PromptDesc.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.PromptDesc.BorderSizePixel = 0
GuiTbl.PromptDesc.Position = UDim2.new(0.5, 0, 0.12226776, 0)
GuiTbl.PromptDesc.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
GuiTbl.PromptDesc.ZIndex = 1002
GuiTbl.PromptDesc.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.PromptDesc.Text = "Insert a notifaction text here later. You can put a lot or a little, and it will scale."
GuiTbl.PromptDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.PromptDesc.TextScaled = true
GuiTbl.PromptDesc.TextSize = 21
GuiTbl.PromptDesc.TextStrokeTransparency = 0.000
GuiTbl.PromptDesc.TextWrapped = true

GuiTbl.PromptButtons.Name = "PromptButtons"
GuiTbl.PromptButtons.Parent = GuiTbl.PromptFrame
GuiTbl.PromptButtons.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.PromptButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.PromptButtons.BackgroundTransparency = 1.000
GuiTbl.PromptButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.PromptButtons.BorderSizePixel = 0
GuiTbl.PromptButtons.Position = UDim2.new(0.5, 0, 0.819672108, 0)
GuiTbl.PromptButtons.Size = UDim2.new(0.800000012, 0, 0.150000006, 0)
GuiTbl.PromptButtons.ZIndex = 1003

GuiTbl.UIGridLayout_4.Parent = GuiTbl.PromptButtons
GuiTbl.UIGridLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIGridLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
GuiTbl.UIGridLayout_4.CellPadding = UDim2.new(0, 0, 0, 0)
GuiTbl.UIGridLayout_4.CellSize = UDim2.new(0.5, 0, 1, 0)

GuiTbl.Yes.Name = "Yes"
GuiTbl.Yes.Parent = GuiTbl.PromptButtons
GuiTbl.Yes.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
GuiTbl.Yes.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Yes.BorderSizePixel = 0
GuiTbl.Yes.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Yes.ZIndex = 1004
GuiTbl.Yes.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Yes.Text = "Yes"
GuiTbl.Yes.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Yes.TextScaled = true
GuiTbl.Yes.TextSize = 21
GuiTbl.Yes.TextStrokeTransparency = 0.000
GuiTbl.Yes.TextWrapped = true

GuiTbl.UIStroke_29.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_29.Parent = GuiTbl.Yes

GuiTbl.UICorner_29.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_29.Parent = GuiTbl.Yes

GuiTbl.No.Name = "No"
GuiTbl.No.Parent = GuiTbl.PromptButtons
GuiTbl.No.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GuiTbl.No.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.No.BorderSizePixel = 0
GuiTbl.No.LayoutOrder = 1
GuiTbl.No.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.No.ZIndex = 1004
GuiTbl.No.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.No.Text = "No"
GuiTbl.No.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.No.TextScaled = true
GuiTbl.No.TextSize = 21
GuiTbl.No.TextStrokeTransparency = 0.000
GuiTbl.No.TextWrapped = true

GuiTbl.UIStroke_30.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_30.Parent = GuiTbl.No

GuiTbl.UICorner_30.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_30.Parent = GuiTbl.No

GuiTbl.Ok.Name = "Ok"
GuiTbl.Ok.Parent = GuiTbl.PromptButtons
GuiTbl.Ok.BackgroundColor3 = Color3.fromRGB(0, 132, 255)
GuiTbl.Ok.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Ok.BorderSizePixel = 0
GuiTbl.Ok.LayoutOrder = 2
GuiTbl.Ok.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Ok.Visible = false
GuiTbl.Ok.ZIndex = 1004
GuiTbl.Ok.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Ok.Text = "Ok"
GuiTbl.Ok.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Ok.TextScaled = true
GuiTbl.Ok.TextSize = 21
GuiTbl.Ok.TextStrokeTransparency = 0.000
GuiTbl.Ok.TextWrapped = true

GuiTbl.UIStroke_31.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_31.Parent = GuiTbl.Ok

GuiTbl.UICorner_31.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_31.Parent = GuiTbl.Ok

GuiTbl.VisibilityButton.Name = "VisibilityButton"
GuiTbl.VisibilityButton.Parent = GuiTbl.SpecterGUI
C.UI.VisibilityButton = GuiTbl.VisibilityButton
GuiTbl.VisibilityButton.Active = true
GuiTbl.VisibilityButton.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
GuiTbl.VisibilityButton.BackgroundTransparency = 0.250
GuiTbl.VisibilityButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.VisibilityButton.BorderSizePixel = 0
GuiTbl.VisibilityButton.Position = UDim2.new(0.74000001, 0, 0.800000012, 0)
GuiTbl.VisibilityButton.Selectable = true
GuiTbl.VisibilityButton.Size = UDim2.new(0.0850000009, 0, 0.0850000009, 0)
GuiTbl.VisibilityButton.ZIndex = 101

GuiTbl.UIAspectRatioConstraint.Parent = GuiTbl.VisibilityButton

GuiTbl.UICorner_32.CornerRadius = UDim.new(1, 0)
GuiTbl.UICorner_32.Parent = GuiTbl.VisibilityButton

GuiTbl.VisibilityButton_2.Name = "VisibilityButton"
GuiTbl.VisibilityButton_2.Parent = GuiTbl.VisibilityButton
GuiTbl.VisibilityButton_2.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.VisibilityButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.VisibilityButton_2.BackgroundTransparency = 1.000
GuiTbl.VisibilityButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.VisibilityButton_2.BorderSizePixel = 0
GuiTbl.VisibilityButton_2.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.VisibilityButton_2.Selectable = true
GuiTbl.VisibilityButton_2.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
GuiTbl.VisibilityButton_2.ZIndex = 102
C.SetImage(GuiTbl.VisibilityButton_2,"rbxassetid://18416048326")
GuiTbl.VisibilityButton_2.ImageTransparency = 0.360
GuiTbl.VisibilityButton_2.ScaleType = Enum.ScaleType.Fit

GuiTbl.UICorner_33.CornerRadius = UDim.new(1, 0)
GuiTbl.UICorner_33.Parent = GuiTbl.VisibilityButton_2

GuiTbl.FrameRate.Name = "FrameRate"
GuiTbl.FrameRate.Parent = GuiTbl.SpecterGUI
C.UI.FrameRate = GuiTbl.FrameRate
GuiTbl.FrameRate.AnchorPoint = Vector2.new(1, 0)
GuiTbl.FrameRate.BackgroundColor3 = Color3.fromRGB(255, 163, 3)
GuiTbl.FrameRate.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.FrameRate.BorderSizePixel = 0
GuiTbl.FrameRate.Position = UDim2.new(1, -60, 0, 10)
GuiTbl.FrameRate.Size = UDim2.new(0, 23, 0, 23)
GuiTbl.FrameRate.Visible = false
GuiTbl.FrameRate.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.FrameRate.Text = "60"
GuiTbl.FrameRate.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.FrameRate.TextScaled = true
GuiTbl.FrameRate.TextSize = 21
GuiTbl.FrameRate.TextStrokeTransparency = 0.000
GuiTbl.FrameRate.TextWrapped = true

GuiTbl.ESP.Name = "ESP"
GuiTbl.ESP.Parent = GuiTbl.SpecterGUI
C.UI.ESP = GuiTbl.ESP

GuiTbl.ToggleTagEx.Name = "ToggleTagEx"
C.AddGlobalInstance(GuiTbl.ToggleTagEx)
C.Examples.ToggleTagEx = GuiTbl.ToggleTagEx
GuiTbl.ToggleTagEx.Enabled = false
GuiTbl.ToggleTagEx.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GuiTbl.ToggleTagEx.Active = true
GuiTbl.ToggleTagEx.AlwaysOnTop = true
GuiTbl.ToggleTagEx.ExtentsOffsetWorldSpace = Vector3.new(0, 4, 0)
GuiTbl.ToggleTagEx.LightInfluence = 1.000
GuiTbl.ToggleTagEx.Size = UDim2.new(1, 30, 0.75, 10)

GuiTbl.Toggle.Name = "Toggle"
GuiTbl.Toggle.Parent = GuiTbl.ToggleTagEx
GuiTbl.Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GuiTbl.Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Toggle.BorderSizePixel = 0
GuiTbl.Toggle.Size = UDim2.new(1, 0, 1, 0)
GuiTbl.Toggle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Toggle.TextScaled = true
GuiTbl.Toggle.TextSize = 21
GuiTbl.Toggle.TextStrokeTransparency = 0.000
GuiTbl.Toggle.TextWrapped = true

GuiTbl.UIStroke_32.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_32.Parent = GuiTbl.Toggle

GuiTbl.NameTagEx.Name = "NameTagEx"
C.AddGlobalInstance(GuiTbl.NameTagEx)
C.Examples.NameTagEx = GuiTbl.NameTagEx
GuiTbl.NameTagEx.Enabled = false
GuiTbl.NameTagEx.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GuiTbl.NameTagEx.AlwaysOnTop = true
GuiTbl.NameTagEx.ExtentsOffsetWorldSpace = Vector3.new(0, 7, 0)
GuiTbl.NameTagEx.LightInfluence = 1.000
GuiTbl.NameTagEx.Size = UDim2.new(3, 40, 0.699999988, 10)

GuiTbl.Username.Name = "Username"
GuiTbl.Username.Parent = GuiTbl.NameTagEx
GuiTbl.Username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Username.BackgroundTransparency = 1.000
GuiTbl.Username.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.Username.Size = UDim2.new(1, 0, 1, 0)
GuiTbl.Username.ZIndex = 2
GuiTbl.Username.FontFace = Font.new("rbxasset://fonts/families/Roboto.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
GuiTbl.Username.Text = "Computer/1"
GuiTbl.Username.TextColor3 = Color3.fromRGB(13, 105, 172)
GuiTbl.Username.TextScaled = true
GuiTbl.Username.TextStrokeTransparency = 0.000
GuiTbl.Username.TextWrapped = true

GuiTbl.Distance.Name = "Distance"
GuiTbl.Distance.Parent = GuiTbl.NameTagEx
GuiTbl.Distance.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.Distance.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Distance.BackgroundTransparency = 1.000
GuiTbl.Distance.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.Distance.Position = UDim2.new(0.5, 0, -0.899999976, 0)
GuiTbl.Distance.Size = UDim2.new(0.275000006, 0, 1, 0)
GuiTbl.Distance.Visible = false
GuiTbl.Distance.ZIndex = 2
GuiTbl.Distance.FontFace = Font.new("rbxasset://fonts/families/Roboto.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
GuiTbl.Distance.Text = "15m"
GuiTbl.Distance.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Distance.TextScaled = true
GuiTbl.Distance.TextSize = 21
GuiTbl.Distance.TextStrokeTransparency = 0.000
GuiTbl.Distance.TextWrapped = true

GuiTbl.ExpandingBar.Name = "ExpandingBar"
GuiTbl.ExpandingBar.Parent = GuiTbl.NameTagEx
GuiTbl.ExpandingBar.AnchorPoint = Vector2.new(0, 1)
GuiTbl.ExpandingBar.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
GuiTbl.ExpandingBar.BackgroundTransparency = 0.200
GuiTbl.ExpandingBar.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.ExpandingBar.Position = UDim2.new(0, 0, 1.49000001, 0)
GuiTbl.ExpandingBar.Size = UDim2.new(1, 0, 0.5, 0)
GuiTbl.ExpandingBar.Visible = false

GuiTbl.AmtFinished.Name = "AmtFinished"
GuiTbl.AmtFinished.Parent = GuiTbl.ExpandingBar
GuiTbl.AmtFinished.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.AmtFinished.BackgroundTransparency = 0.100
GuiTbl.AmtFinished.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.AmtFinished.Size = UDim2.new(0, 0, 1, 0)

GuiTbl.Modal.Name = "Modal"
GuiTbl.Modal.Parent = GuiTbl.SpecterGUI
C.UI.Modal = GuiTbl.Modal
GuiTbl.Modal.Active = false
GuiTbl.Modal.AnchorPoint = Vector2.new(1, 1)
GuiTbl.Modal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Modal.BackgroundTransparency = 1.000
GuiTbl.Modal.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Modal.BorderSizePixel = 0
GuiTbl.Modal.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
GuiTbl.Modal.TextColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Modal.TextSize = 21
GuiTbl.Modal.TextTransparency = 1.000
	return GuiTbl.SpecterGUI,GuiTbl.CategoriesFrame,GuiTbl.TabsFrame,GuiTbl.ToolTipHeaderFrame,GuiTbl.ToolTipText
end

local function CreateOtherElements(C, Settings)
	local newPart = Instance.new("Part")
	newPart.Size=Vector3.new(1.15,1.15,1.15)
	newPart.BrickColor=BrickColor.Red()
	newPart.Anchored=true
	newPart.CanCollide=false
	newPart.TopSurface = Enum.SurfaceType.Smooth
	newPart.BottomSurface = Enum.SurfaceType.Smooth
	newPart.Transparency=.35
	newPart:AddTag("RemoveOnDestroy")
	C.Examples.TestPartEx = newPart
end

return function(C, Settings)
	-- Gui to Lua

	-- Initiziations
	C.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
	C.Examples = {}
	C.UI = {}

	-- Functions
	local BlockStartDragging = false
	function C.SetImage(imageButton,image)
		imageButton.Image = image
	end
	local function CreateDraggable(frame: Frame, dragInstance: Frame)
		local dragging
		local dragInput
		local dragStart
		local dragStartTime
		local startPos
		local wantLoc

		local function update(delta: UDim2, start: boolean)
			if start then
				startPos = frame.Position
			end
			local x = startPos.X.Scale * C.GUI.AbsoluteSize.X + startPos.X.Offset + delta.X
			local y = startPos.Y.Scale * C.GUI.AbsoluteSize.Y + startPos.Y.Offset + delta.Y

			if delta.Magnitude > 0 or not wantLoc then
				wantLoc = UDim2.fromOffset(x, y)
			else
				x, y = wantLoc.X.Offset, wantLoc.Y.Offset
			end

			-- Get the screen bounds
			local screenWidth = math.max(workspace.CurrentCamera.ViewportSize.X, C.GUI.AbsoluteSize.X)
			local screenHeight = math.max(workspace.CurrentCamera.ViewportSize.Y, C.GUI.AbsoluteSize.Y)

			-- Get the frame size
			local frameWidth = frame.AbsoluteSize.X
			local frameHeight = frame.AbsoluteSize.Y

			-- Get the frame anchor point
			local anchorX = frame.AnchorPoint.X
			local anchorY = frame.AnchorPoint.Y

			-- Calculate the clamping bounds based on the anchor point
			local minX = anchorX * frameWidth
			local maxX = screenWidth - (1 - anchorX) * frameWidth
			local minY = anchorY * frameHeight
			local maxY = screenHeight - (1 - anchorY) * frameHeight

			-- Clamp the x and y positions
			x = C.ClampNoCrash(x, minX, maxX)
			y = C.ClampNoCrash(y, minY, maxY)

			TS:Create(frame,TweenInfo.new(start and 0 or .07),{Position = UDim2.fromOffset(x, y)}):Play()
		end

		C.AddGlobalConnection(dragInstance.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch)
				and not BlockStartDragging then
				BlockStartDragging = true
				dragging = true
				dragStartTime = os.clock()
				dragStart = input.Position
				startPos = frame.Position

				local connection

				connection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						BlockStartDragging = false
						C.RemoveGlobalConnection(connection)
					end
				end)
				C.AddGlobalConnection(connection)
			end
		end))

		C.AddGlobalConnection(dragInstance.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				if C.UI.DisableDrag then
					return
				end
				dragInput = input
			end
		end))

		C.AddGlobalConnection(UIS.InputChanged:Connect(function(input)
			if input == dragInput and dragging and os.clock() - dragStartTime > .1 then
				update(input.Position - dragStart)
			end
		end))

		return update
	end
	function C.MakeDraggableTab(TabEx,HasScroll)
		if C.Cleared then
			return
		end
		local PercentageVisible
		local ScrollTab,HeaderTab
		if HasScroll then
			ScrollTab = TabEx:WaitForChild("ScrollTab",5)
			if not ScrollTab then return end -- Likely cleared!
			HeaderTab = TabEx:WaitForChild("HeaderTab")
			PercentageVisible = Instance.new("NumberValue",ScrollTab)
			PercentageVisible.Name = "PercentageVisible"
			PercentageVisible.Value = 1
		end
		--UIListLayout
		local UIListLayout = ScrollTab and ScrollTab:WaitForChild("UIListLayout")
		--Draggable
		local UpdateBounds = CreateDraggable(TabEx,TabEx:WaitForChild("HeaderTab"))
		-- Tab Resizing
		local function UpdateTabSize()
			if ScrollTab then
				local ySize =  math.min(UIListLayout.AbsoluteContentSize.Y,300)
				if HasScroll then
					ySize *= PercentageVisible.Value
				end
				ySize += HeaderTab.AbsoluteSize.Y
				TabEx.Size = UDim2.fromOffset(TabEx.AbsoluteSize.X,ySize)
			end
			UpdateBounds(Vector2.zero, true)
		end
		if HasScroll then
			PercentageVisible.Changed:Connect(UpdateTabSize)
			UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateTabSize)
			local vis = true
			C.ButtonClick(HeaderTab:WaitForChild("DropDownButton"),function()
				vis = not vis
				TS:Create(HeaderTab.DropDownButton,TweenInfo.new(.3),{Rotation=vis and 0 or 180}):Play()
				TS:Create(PercentageVisible,TweenInfo.new(.3),{Value=vis and 1 or 0}):Play()
			end)
		end
		C.AddGlobalConnection(C.GUI:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateTabSize))
		UpdateTabSize()
	end
	-- BEGIN LOAD CORE

	-- Instances:
	local SpecterGUI,CategoriesFrame,TabsFrame,ToolTipHeaderFrame,ToolTipText = LoadCore(C)
	if C.isStudio then
		SpecterGUI.Name = "SpecterGUI"
	else
		SpecterGUI.Name = C.GenerateGUID()
	end
	SpecterGUI.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	SpecterGUI.ScreenInsets = Enum.ScreenInsets.None
	SpecterGUI.ClipToDeviceSafeArea = false

	CreateOtherElements(C, Settings)

	-- Load tooltip


	local toolTipFunct
	local toolTipDeb = 0

	function C.TooltipActivate(text)
		toolTipDeb+=1
		local wasRegistered = C.TooltipDeactivate(true)
		ToolTipText.Text = text
		ToolTipHeaderFrame.Visible = true
		if not wasRegistered then
			toolTipFunct = C.AddGlobalConnection(RunS.RenderStepped:Connect(function()
				C.TooltipPosition(UIS:GetMouseLocation())
			end))
			C.TooltipPosition(UIS:GetMouseLocation())--Stop a render from being stepped!
		end
		return toolTipDeb
	end

	function C.TooltipDeactivate(doNotRemove)
		if toolTipFunct and not doNotRemove then
			ToolTipHeaderFrame.Visible = false
			C.RemoveGlobalConnection(toolTipFunct)
			toolTipFunct = nil
		end
		return toolTipFunct~=nil
	end

	function C.TooltipPosition(position)
		local x = position.X -- 47
		local y = position.Y - 40
		local screenWidth = SpecterGUI.AbsoluteSize.X
		local screenHeight = SpecterGUI.AbsoluteSize.Y
		local tooltipWidth = ToolTipHeaderFrame.AbsoluteSize.X
		local tooltipHeight = ToolTipHeaderFrame.AbsoluteSize.Y

		x = math.clamp(x, 0, screenWidth - tooltipWidth)
		y = math.clamp(y, 0, screenHeight - tooltipHeight)

		ToolTipHeaderFrame.Position = UDim2.fromOffset(x, y)
	end

	function C.TooltipSetUp(button,label)
		local saveDeb

		C.AddGlobalConnection(button.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				saveDeb = C.TooltipActivate(label)
			end
		end))

		-- Detect when input ends (e.g., mouse button up or movement stops)
		C.AddGlobalConnection(button.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and saveDeb == toolTipDeb and label == ToolTipText.Text then
				C.TooltipDeactivate()
			end
		end))
	end

	--Load Notifications

	local NotiList = {}
	function C.AddNotification(title,desc)
		local NotiClone = C.Examples.NotificationEx:Clone()
		NotiClone:WaitForChild("NotificationTitle").Text = title
		NotiClone:WaitForChild("NotificationDesc").Text = desc
		NotiClone.Position = UDim2.fromScale(1+NotiClone.Size.X.Scale/2,1)
		NotiClone.Visible = true
		NotiClone.Parent = C.UI.Notifications
		local xTween = Instance.new("NumberValue",NotiClone)
		xTween.Name = "XValue"
		xTween.Value = 1
		local order = Instance.new("IntValue",NotiClone)
		order.Name = "Order"
		order.Value = -1
		local yTween = Instance.new("NumberValue",NotiClone)
		yTween.Value = 1
		yTween.Name = 'YValue'
		table.insert(NotiList,NotiClone)
		for num, currentClone in ipairs(NotiList) do
			currentClone.Order.Value += 1
			TS:Create(currentClone.YValue,TweenInfo.new(.2),{Value=(1-(currentClone.Order.Value*currentClone.Size.Y.Scale))}):Play()
		end
		local XTweenObj = TS:Create(xTween,TweenInfo.new(.3),{Value=0})
		XTweenObj:Play()
		local AlreadyDisabled = false
		local function DisableFunct(tweenStatus)
			if AlreadyDisabled or tweenStatus == Enum.TweenStatus.Canceled then
				return
			end
			AlreadyDisabled = true
			C.TblRemove(NotiList,NotiClone)
			local XTweenObj2 = TS:Create(xTween,TweenInfo.new(.3),{Value=1})
			XTweenObj2:Play()
			XTweenObj2.Completed:Wait()
			NotiClone:Destroy()
		end
		task.delay(12,DisableFunct)
		local function UpdateNotiPos()
			NotiClone.Position = UDim2.fromScale(1+(xTween.Value * NotiClone.Size.X.Scale),yTween.Value)
			if yTween.Value <= NotiClone.Size.Y.Scale * 3 then
				DisableFunct()
			end
		end
		local TimerTween = TS:Create(NotiClone:WaitForChild("Timer"),TweenInfo.new(12,Enum.EasingStyle.Linear),{Size=UDim2.new(0,0,0,NotiClone.Timer.Size.Y.Offset)})
		TimerTween.Completed:Connect(DisableFunct)
		TimerTween:Play()
		--C.AddGlobalConnection(RunS.RenderStepped:Connect(UpdateNotiPos))
		C.AddGlobalConnection(xTween.Changed:Connect(UpdateNotiPos))
		C.AddGlobalConnection(yTween.Changed:Connect(UpdateNotiPos))
		UpdateNotiPos()
	end
	--[[task.spawn(function()
		while true do
			C.AddNotification("test",'testestestestes')
			task.wait(.3)
		end
	end)--]]
	local StartedClicking = false

	function C.ButtonClick(button:GuiBase,funct,msb)
		msb = msb or 1
		local FirstClick,FirstClickCoords
		--This does not need to be connected because it is removed when it is deleted.
		local function isValidPress(inputObject: InputObject, started: boolean)
			if started and C.FocusFrame and not C.FocusFrame:IsAncestorOf(button) then
				return
			end
			return (inputObject.UserInputType == Enum.UserInputType["MouseButton"..msb] or
				(inputObject.UserInputType == Enum.UserInputType.Touch and msb==1))
		end
		local TouchConn
		local function InputEnded(inputObject: InputObject)
			if isValidPress(inputObject) and not TouchConn then
				StartedClicking = false
				local diffTime = FirstClick and os.clock() - FirstClick
				if diffTime and diffTime > 0.03 and diffTime < 1.5 and (FirstClickCoords-inputObject.Position).Magnitude < 15 then
					funct()
				end
			end
		end
		button.InputBegan:Connect(function(inputObject: InputObject)
			if isValidPress(inputObject, true) and not StartedClicking then
				StartedClicking = true
				FirstClick = os.clock()
				FirstClickCoords = inputObject.Position
				if inputObject.UserInputType == Enum.UserInputType.Touch and msb == 1 then
					TouchConn = C.AddObjectConnection(button,"C.ButtonClick",UIS.TouchEnded:Connect(function(inputObject)
						TouchConn = C.RemoveObjectConnection(button,"C.ButtonClick",TouchConn)
						InputEnded(inputObject)
					end))
				end
			end
		end)
		button.InputEnded:Connect(InputEnded)
	end

	--Jump Detection
	do
		local JumpEvent = Instance.new("BindableEvent")
		local JumpIndex = 0

		local function UpdateJumping(Insert: boolean)
			local WasJumping = JumpIndex > 0
			JumpIndex += (Insert and 1 or -1)
			assert(JumpIndex>=0,"JumpIndex < 0: " .. JumpIndex)
			local IsJumping = JumpIndex > 0
			if WasJumping ~= IsJumping then
				-- Modification Detected!
				JumpEvent:Fire(IsJumping)
				C.IsJumping = IsJumping
			end
		end

		-- KeyCode (Desktop, Console)
		local KeyboardJumping, MobileJumping = false, false
		C.AddGlobalConnection(UIS.InputBegan:Connect(function(input, gameProccesedEvent)
			if not gameProccesedEvent and (input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA or input.KeyCode == Enum.KeyCode.ButtonX) then
				if KeyboardJumping then return end KeyboardJumping = true
				UpdateJumping(true)
			end
		end))
		C.AddGlobalConnection(UIS.InputEnded:Connect(function(input, gameProccesedEvent)
			if not gameProccesedEvent and (input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA or input.KeyCode == Enum.KeyCode.ButtonX) then
				if not KeyboardJumping then return end KeyboardJumping = false
				UpdateJumping()
			end
		end))

		-- Touch (Phone, Tablet)
		local MobileConnection
		local function RefreshMobileJumpInputs()
			if MobileConnection then
				MobileConnection:Disconnect()
				MobileConnection = nil
			end
			if not UIS.TouchEnabled then
				return
			end
			local JumpButton: ImageButton = C.StringWait(C.PlayerGui,"TouchGui.TouchControlFrame.JumpButton",1000000000)

			MobileConnection = C.AddGlobalConnection(JumpButton:GetPropertyChangedSignal("ImageRectOffset"):Connect(function()
				local JumpButtonDown = JumpButton.ImageRectOffset.X > 3
				if JumpButtonDown == MobileJumping then
					return -- Stop, no change!
				end
				UpdateJumping(JumpButtonDown)
				MobileJumping = JumpButtonDown
			end))
		end

		C.AddGlobalConnection(UIS:GetPropertyChangedSignal("TouchEnabled"):Connect(RefreshMobileJumpInputs))
		C.AddGlobalThread(task.spawn(RefreshMobileJumpInputs))

		C.AddGlobalInstance(JumpEvent)
		C.JumpEvent = JumpEvent
	end

	-- Set up actions

	local ActionsFrame = C.UI.Actions
	local ActionsList = ActionsFrame:WaitForChild("ScrollTab")

	C.getgenv().ActionsList = C.getgenv().ActionsList or {}

	function C.AddAction(info)
		local ActionClone = ActionsList:FindFirstChild(info.Name)
		if ActionsList:FindFirstChild(info.Name) then
			return ActionClone
		end
        info.Threads = info.Threads or {}

		ActionClone = C.Examples.ActionsEx:Clone()
		ActionClone.Name = info.Name
		ActionClone.Title.Text = (info.Title or info.Name):gsub("/"," "):gsub("_"," "):gsub("%l%u",function(old) return old:sub(1,1) .. " " .. old:sub(2) end)
		info.Tags = info.Tags or {"RemoveOnDestroy"}
        info.ActionClone = ActionClone
        info.Enabled = true
		local StopEvent = Instance.new("BindableEvent",ActionClone)
		StopEvent.Name = "StopEvent"
		StopEvent.Event:Connect(function(onRequest)
			StopEvent:Destroy()
			if info.Stop then
				info.Stop(onRequest)
			end
            C.ClearThreadTbl(info.Threads)
			info.Enabled = false
			ActionsFrame.Visible = #ActionsList:GetChildren()-1 > 2 -- If there's something else apart from UIListLayout and the deleted instance!
			ActionClone:Destroy()
		end)
		ActionClone.StopButton.MouseButton1Click:Connect(function()
            if (info.CanCancel and info.CanCancel > 0) or C.PromptVisible then
                return
            end
			StopEvent:Fire(true)
		end)
		C.getgenv().ActionsList[info.Name] = info
		ActionClone.Parent = ActionsList
		local TimeTextLabel = ActionClone:WaitForChild("Time")
		info.TimeLabel = TimeTextLabel
		if info.Time then
			if typeof(info.Time) == "number" then
				task.spawn(function()
					for s = info.Time, 1, -1 do
						if not ActionClone.Parent then
							return
						end
						TimeTextLabel.Text = s
						task.wait(1)
					end
					if StopEvent.Parent then
						StopEvent:Fire()
					end
				end)
			elseif typeof(info.Time) == "string" then
				TimeTextLabel.Text = info.Time
			else
				table.insert(info.Threads, task.spawn(info.Time,ActionClone,info))
			end
		else
			TimeTextLabel.Text = "Starting"
			--Probably utilized elsewhere!
		end
		ActionsFrame.Visible = true
		return ActionClone
	end

	function C.SetActionLabel(actionClone: Frame, text: string, type: string)
        if not actionClone then
            return
        end
		--local info = C.getgenv().ActionsList[actionClone.Name]
		local Time = actionClone:FindFirstChild("Time")
		if Time then
			Time.Text = text
		end
		return Time ~= nil
	end

	function C.SetActionPercentage(actionClone: Frame, percentage: number)
		local info = C.getgenv().ActionsList[actionClone.Name]
		local Time = info.TimeLabel
		if Time then
			local Display = ("%.2f%%"):format(percentage * 100)
			local LastPing, LastPercentage = actionClone:GetAttribute("LastPing"), actionClone:GetAttribute("LastPercentage")
			if not LastPercentage or LastPercentage ~= percentage then
				if LastPing and LastPercentage then
					local WholeTime = (os.clock() - LastPing) / (percentage - LastPercentage)
					local TimeLeft = (1 - percentage) * WholeTime
					Display ..= (" (%.0f seconds)"):format(TimeLeft)
				else
					actionClone:SetAttribute("LastPing", os.clock())
					actionClone:SetAttribute("LastPercentage",percentage)
				end
				Time.Text = Display
			end
		end
	end

	function C.GetAction(name)
		local actionInstance = ActionsList.FindFirstChild(ActionsList,name)
		if actionInstance then
			return actionInstance
		end
	end

	function C.RemoveAction(name)
        local info = C.getgenv().ActionsList[name]
		if info and info.ActionClone then
		    local actionInstance = info.ActionClone
			local event = actionInstance:FindFirstChild("StopEvent")
			if event then
				event:Fire(false)
			end
		end
		if C.getgenv().ActionsList[name] then
			C.getgenv().ActionsList[name] = nil
		end
	end

	function C.GetActionsWithTag(tagName:string)
		local Items = {}
		for name, data in pairs(C.getgenv().ActionsList) do
			if table.find(data.Tags,tagName) then
				Items[name] = data
			end
		end
		return Items
	end

	function C.PurgeActionsWithTag(tagName:string)
		for name, data in pairs(C.GetActionsWithTag(tagName)) do
			C.RemoveAction(name)
		end
	end

	ActionsFrame.Visible = false

	for name, actionData in pairs(C.getgenv().ActionsList) do
        if not table.find(actionData.Tags, "RemoveOnDestroy") then
		    C.AddAction(actionData)
        end
	end

	--Add Prompt control
	local PromptFrame=C.UI.PromptFrame
	local count=0
	local queue,canRunEvent={},Instance.new("BindableEvent",script)
	local buttonTriggerEvent=Instance.new("BindableEvent",script)
	buttonTriggerEvent:AddTag("RemoveOnDestroy")
	C.Prompt_ButtonTriggerEvent = buttonTriggerEvent
	canRunEvent:AddTag("RemoveOnDestroy")

	for _, button in ipairs(PromptFrame.PromptButtons:GetChildren()) do
		if button:IsA("UIBase") then
			continue
		end
		local Return = (button.Name == "Yes" and true) or button.Name
		if Return == "No" then
			Return = false
		end
		C.ButtonClick(button,function()
			buttonTriggerEvent:Fire(Return)
		end)
	end

	--[YIELDS] Result C.Prompt("Title","Description","Ok" | "Y/N")
	C.PromptVisible = false
	function C.Prompt(Title: string,Desc: string,Buttons: table): string
		-- First: Check to see if there's a duplicate. If so, drop it
		for num, promptData in ipairs(queue) do
			if promptData.Title == Title and promptData.Desc == Desc and promptData.Buttons == Buttons then
				return -- EQUAL FOUND!
			end
		end
		count+=1
		local saveNum=count
		local saveTbl = {Num=saveNum,Title=Title,Desc=Desc,Buttons=Buttons}
		table.insert(queue,saveTbl)
		while table.find(queue,saveTbl)~=1 do
			canRunEvent.Event:Wait()
		end
		PromptFrame.PromptTitle.Text=Title
		PromptFrame.PromptTitle.TextColor3=C.ComputeNameColor(Title)
		PromptFrame.PromptDesc.Text=Desc
		C.PromptVisible = true
		C.FocusFrame = PromptFrame
		--PromptFrame.PictureLabel.Visible = Image~=nil
		--PromptFrame.PictureLabel.Image = Image~=nil and Image or 0
		--PromptFrame.DescLabel.Size = Image~=nil and UDim2.fromScale(.575, .541) or UDim2.fromScale(.9,.541)
		local buttonCount=0
		for num, button in ipairs(PromptFrame.PromptButtons:GetChildren()) do
			if button:IsA("UIBase") then
				continue
			end
			if button.Name == "Ok" then
				button.Visible = Buttons == "Ok" or not Buttons
			elseif button.Name == "Yes" or button.Name == "No" then
				button.Visible = Buttons == "Y/N" or (button.Name == "No" and Buttons == "Cancel")
				if button.Name == "No" then
					button.Text = Buttons=="Cancel" and "Cancel" or "No"
				end
			else
				error(`[Prompt]: Unknown Button: {button.Name}`)
			end
			if button.Visible then
				buttonCount+=1
			end
		end
		--PromptFrame.Buttons.UIGridLayout.CellSize=UDim2.new(1/buttonCount,-3,1,0)
		PromptFrame.Position=UDim2.new(0.5, 0,-PromptFrame.Size.Y.Scale/2, -36)
		task.spawn(function()
			PromptFrame:TweenPosition(UDim2.new(0.5, 0,.5, 18),"Out","Quad",3/8,true)
		end)
		PromptFrame.Visible=true
		local result=buttonTriggerEvent.Event:Wait()
		buttonTriggerEvent:Destroy()
		PromptFrame:TweenPosition(UDim2.new(0.5,0,1+PromptFrame.Size.Y.Scale/2,36),"Out","Quad",3/8,true)
		C.PromptVisible = #queue > 1
		C.FocusFrame = nil
		task.delay(2/8,function()
			C.TblRemove(queue,saveTbl)
			if #queue<=0 then
				PromptFrame.Visible=false
			end
			canRunEvent:Fire()
		end)
		return result
	end

	--Kick button

	C.ButtonClick(C.UI.KickedButton,function()
		--C.UI.KickedButton:Destroy()
		--C.UI.KickedButton = nil
		C.UI.KickedButton.Visible = false
	end)

	--Load Servers
	local SecondaryHUD = C.UI.SecondaryHUD
	local ServersFrame = SecondaryHUD:WaitForChild("Servers")

	local CurrentPlaceId = game.PlaceId

	local MainScroll = ServersFrame:WaitForChild("MainScroll")
	local UIGridLayout = MainScroll:WaitForChild("UIGridLayout")
	local TabsSelection = ServersFrame:WaitForChild("TabsSelection")
	local BottomButtons = ServersFrame:WaitForChild("BottomButtons")
	local ServersTL = ServersFrame:WaitForChild("ServersTitleLabel")
	local NoneFound = ServersFrame:WaitForChild("NoneFoundLabel")
    local LoadingLabel = ServersFrame:WaitForChild("LoadingLabel")
	local PrevButton, NextButton = BottomButtons:WaitForChild("Previous"), BottomButtons:WaitForChild("Next")

	local CurrentlySel
	local MaxPageNum,PageNum,Previous,Next = 0, 0, "", ""

	local GetServers = {
		Recent = function()
			if C.isStudio then
				return true, {}
			end
			return true, C.getgenv().PreviousServers
		end,
		Game = function(Cursor)
			if C.isStudio then
				return true, {}
			end
			local success, result = C.API(C.request,nil,1,{Url=`https://games.roblox.com/v1/games/{CurrentPlaceId}/servers/Public?sortOrder=Desc&excludeFullGames=true&limit=100&cursor={Cursor}`})
			if not success then
				return false, result
			elseif not result.Success then
				return false, result.StatusMessage
			end
			local success2, result2 = C.API(HS,"JSONDecode",1,result.Body)
			if not success2 then
				return success2, result2
			end
			Previous,Next = result2.previousPageCursor, result2.nextPageCursor
			return true, result2.data
		end,
		Friend = function()
			local success, result = C.API(C.plr,"GetFriendsOnline",1)
			if not success then
				return false, result
			end
			for num = #result, 1, -1 do
				local friendData = result[num]

				friendData.JobId = friendData.GameId or friendData.JobId
				if friendData.JobId == game.GameId then
					result[num] = nil
				end
				friendData.GameId = nil
			end
			return true, result
		end,
		Place = function()
			local AssetService = game:GetService("AssetService")

			local success, placePages = C.API(function()
				local list = {}
				local placePages = AssetService:GetGamePlacesAsync()
				while true do
					for _, place in placePages:GetCurrentPage() do
						table.insert(list, place)
					end
					if placePages.IsFinished then
						break
					end
					placePages:AdvanceToNextPageAsync()
				end
				return list
			end,nil,1)
			if not success then
				return false, placePages
			end
			return true, placePages
		end,
	}
	local LocationType = {
		[0]="Mobile Website",
		[1]="Mobile InGame",
		[2]="Webpage",
		[3]="Studio",
		[4]="InGame",
		[5]="Xbox",
		[6]="Team Create"
	}
	local LoadingDeb
	local function ActivateServers(tabName: string, increment: boolean | nil)
		if LoadingDeb then return end LoadingDeb = true
        MainScroll.Visible = false
        LoadingLabel.Visible = true
		NoneFound.Visible = false
        BottomButtons.Visible = false
		local Cursor = ""
		if increment then
			Cursor = Next
			PageNum+=1
		elseif increment == false then
			Cursor = Previous
			PageNum-=1
		else
			Previous,Next = nil,nil
			PageNum,MaxPageNum = 1, nil
		end
		local success, result = GetServers[tabName](Cursor)
        LoadingLabel.Visible = false
		LoadingDeb = false
		if not success then
			return
		end

		CurrentlySel = tabName
        MainScroll.Visible = true
		C.ClearChildren(MainScroll)
		UIGridLayout.CellSize = UDim2.new(tabName == "Place" and 1 or 0.3,0,0,UIGridLayout.CellSize.Y.Offset)
		MainScroll.CanvasPosition = Vector2.zero
		local index = 0
		for num, data in ipairs(result) do
			if tabName~="Recent" or (data.GameId == game.GameId and (data.JobId ~= game.JobId or data.PlaceId ~= data.PlaceId)) then
				index+=1
				local serverClone = C.Examples.ServerEx:Clone()
				local RealIndex = (PageNum-1)*100 + index
				local JobId = data.JobId or data.id
				local IsSame
				serverClone.Name = index
				if tabName == "Place" then
					IsSame = game.PlaceId == data.PlaceId
					serverClone.ServerTitle.Text = data.Name
					serverClone.SecondData.Text = `PlaceID = {data.PlaceId}`
					serverClone.TimeStamp.Text = `{IsSame and "You are here" or "Click To Join"}`
					C.ButtonClick(serverClone, function()
						if IsSame then
							return C.Prompt(`Join Failed`, `You are currently in the place you are attempting to join:\n{data.Name}`,"Ok")
						end
						if C.Prompt(`Join Confirmation`, `Are you sure that you want to join:\n{data.Name}?`, "Y/N") then
							C.ServerTeleport(data.PlaceId,nil)
						end
					end)
                    C.ButtonClick(serverClone,function()
                        C.setclipboard(data.PlaceId, "PlaceId")
                    end, 2)
				else
					local listedData = {
						(tabName=="Friend" and `{data.UserName}`) or (JobId == game.JobId and `Your Server`) or `Server {RealIndex}`,
						(data.Players and `{data.Players}/{data.MaxPlayers} Players`) or (data.playing and `{data.playing}/{data.maxPlayers} Players`)
							or (data.PlaceId and MS:GetProductInfo(data.PlaceId).Name) or "Not InGame",
						(data.Time and `{C.FormatTimeFromUnix(data.Time)}`) or (data.ping and `{data.ping} ping`) or (data.LocationType and `{LocationType[data.LocationType]}`),
					}
					serverClone.ServerTitle.Text = listedData[1]
					serverClone.SecondData.Text = listedData[2]
					serverClone.TimeStamp.Text = listedData[3]
					IsSame = game.JobId == data.JobId
					C.ButtonClick(serverClone, function()
						if not JobId then
							return C.Prompt(`Not InGame`, `{listedData[1]} is currently not in a game.\nPlease try again later.`)
						end
						if C.Prompt(`{listedData[1]=="Your Server" and "Re" or ""}Join {listedData[1]}?`, `JobId: {JobId}\n{listedData[2]}\n{listedData[3]}`, "Y/N") then
							C.ServerTeleport(data.PlaceId or game.PlaceId,JobId)
						end
					end)
				end
				if IsSame then
					serverClone.BackgroundColor3 = Color3.fromRGB(0,0,0)
				else
					serverClone.BackgroundColor3 = C.ComputeNameColor(tostring(RealIndex))
				end
				serverClone.LayoutOrder = index
				serverClone.Parent = MainScroll
			end
		end
		local hasArrows = tabName == "Game" and (Next or Previous)
		local titleAfter = index
		if not Next then
			MaxPageNum = PageNum--We on last page
		end
		if tabName == "Game" then
			if MaxPageNum then
				titleAfter = `pg {PageNum}/{MaxPageNum}`
			else
				titleAfter = `pg {PageNum}`
			end
		end

		NextButton.BackgroundColor3 = Next and Color3.fromRGB(60, 255, 0) or Color3.fromRGB(170,170,170)
		PrevButton.BackgroundColor3 = Previous and Color3.fromRGB(255, 238, 0) or Color3.fromRGB(170,170,170)

		MainScroll.Size = UDim2.fromScale(.7,hasArrows and 0.76 or 0.9)
		BottomButtons.Visible = hasArrows
		ServersTL.Text = `{tabName:upper()}{tabName=="Place" and "S" or " SERVERS"} ({titleAfter})`
		NoneFound.Visible = index == 0
	end
	C.ButtonClick(NextButton, function()
		if not Next then
			return
		end
		ActivateServers(CurrentlySel,true)
	end)
	C.ButtonClick(PrevButton, function()
		if not Previous then
			return
		end
		ActivateServers(CurrentlySel,false)
	end)

	local Visible = false
	function C.ToggleServersVisiblity(startPlace)
        startPlace = startPlace or "Game"
        if startPlace ~= CurrentlySel and startPlace ~= "Exit" then
            Visible = true
        else
            Visible = not Visible
        end
        SecondaryHUD.Visible = Visible
		if Visible then
			ActivateServers(startPlace)
		end
	end
	SecondaryHUD.Visible = false

	for num, button in ipairs(TabsSelection:GetChildren()) do
		if button:IsA("TextButton") then
			if button.Name ~= "Close" then
				C.ButtonClick(button, function()
					ActivateServers(button.Name)
				end)
			else
				C.ButtonClick(button, function()
                    C.ToggleServersVisiblity("Exit")
                end)
			end
		end
	end


	--Load Settings Loader
	C.ExtraOptions = C.LoadModule("Modules/HackOptions")

	C.UI.CategoriesFrame = CategoriesFrame
	C.UI.TabsFrame = TabsFrame

	C.GUI = SpecterGUI

	ActionsFrame.Position = UDim2.fromOffset(0, C.GUI.AbsoluteSize.Y * 3)
	C.MakeDraggableTab(ActionsFrame, true)
	CreateDraggable(C.UI.VisibilityButton,C.UI.VisibilityButton)
end]=],
    ["Modules/HackOptions"] = [=[local TS = game:GetService("TweenService")
local CS = game:GetService("CollectionService")
local PS = game:GetService("Players")
local RunS = game:GetService("RunService")
return function(C,Settings)
	C.UI.Options = {}
	C.UI.DisableDrag = false
	
	local ToggleTbl,SliderTbl, DropdownTbl, UserListTbl, TextboxTbl = {}, {}, {}, {}, {}
	C.UI.Options.Toggle = ToggleTbl
	C.UI.Options.Slider = SliderTbl
	C.UI.Options.Dropdown = DropdownTbl
	C.UI.Options.UserList = UserListTbl
	C.UI.Options.Textbox = TextboxTbl
		
	local function DoCombined(tbl,name,parent,options)
		assert(options.Title,"Title is missing")
		local newFrame = C.Examples[name .. "Ex"]:Clone()
		local self = setmetatable(options, { __index = tbl })
		self.Frame = newFrame
		--self.Options = options
		--self.Parent = options.Parent
		
		self.CategoryName = self.Parent.Parent.Category.Name
		self.ParentShortcut = self.Parent.Shortcut
		assert(self.Shortcut,`{tbl.Title} doesn't have a Shortcut`)
		assert(self.Shortcut~="Keybind",`{self.Shortcut} is a restricted internal option name!`)
		assert(self.CategoryName,`{tbl.Title} doesn't have a category`)
		assert(self.ParentShortcut,`{tbl.Title} doesn't have a PARENT category for {parent.Name}`)
		self.EnHackTbl = C.enHacks[self.CategoryName][self.ParentShortcut]
		assert(self.EnHackTbl,`{self.ParentShortcut} doesn't have a table or smt`)
		local Default 
		if self.EnHackTbl[self.Shortcut] ~= nil then
			Default = self.EnHackTbl[self.Shortcut]
		else
			Default = self.Default
		end
        assert(Default ~= nil, `[HackOptions.Combined]: Invalid Default for {self.ParentShortcut} {self.Shortcut}`)
		newFrame.LayoutOrder = options.Layout
		newFrame.Name = options.Title
		newFrame:WaitForChild("NameTL").Text = options.Title
		if options.Tooltip then
			C.TooltipSetUp(newFrame:WaitForChild("NameTL"),options.Tooltip)
		end
		newFrame.Parent = parent:WaitForChild("OptionsList")
		return self, newFrame, Default
	end
	
	local function SetValueCombined(self,firstRun)
		self.EnHackTbl[self.Shortcut] = self.Value
		if not firstRun then
			if self.EnHackTbl.En and self.Activate then
				self.Activate(self.Parent,self,self.Value)
			end
		end
	end

	function ToggleTbl.new(parent,options)
		local self, newFrame, default = DoCombined(ToggleTbl,"Toggle",parent,options)
		self.Slider = newFrame:WaitForChild("ToggleSwitchSlider")
		self.Circle = self.Slider:WaitForChild("ToggleCircle")
		C.ButtonClick(self.Slider,function()
			self:Toggle()
		end)
		self:SetValue(default,true,true)
	end
	function ToggleTbl:Toggle(instant)
		self:SetValue(not self.Value, instant)
	end
	function ToggleTbl:SetValue(new,instant,firstRun)
		local tweenInfo = TweenInfo.new(instant and 0 or 0.2)
		if new then
			TS:Create(self.Circle, tweenInfo, {Position = UDim2.fromScale(0.604,.5)}):Play()
			TS:Create(self.Slider, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 115, 255)}):Play()	
		else
			TS:Create(self.Circle, tweenInfo, {Position = UDim2.fromScale(0.05,.5)}):Play()
			TS:Create(self.Slider, tweenInfo, {BackgroundColor3 = Color3.fromRGB(113, 113, 113)}):Play()	
		end
		self.Value = new
		SetValueCombined(self,firstRun)
	end
	
	function SliderTbl.new(parent, options)
		assert(options.Min,"Min is missing")
		assert(options.Max,"Max is missing")
		assert(options.Default,"Default is missing")
		
		local self, newFrame, default = DoCombined(SliderTbl, "Slider", parent, options)

		self.Min = options.Min
		self.Max = options.Max
		self.Digits = options.Digits or 0
		self.Step = 1 * 10^-options.Digits
		if self.Step==0 then
			self.Step = 1
		end

		self.Slider = newFrame:WaitForChild("SlidingBar")
		self.CurrentPosition = self.Slider:WaitForChild("CurrentPosition")
		self.Backing = self.Slider:WaitForChild("Backing")
		self.ForceTB = newFrame:WaitForChild("ForceTB")
		self.Track = self.Slider:WaitForChild("Track")
		
		newFrame:WaitForChild("RightBound").Text = self.Max
		newFrame:WaitForChild("LeftBound").Text = self.Min

		self.ForceTB.FocusLost:Connect(function(enterPressed)
			RunS.RenderStepped:Wait()
			local value = tonumber(self.ForceTB.Text)
			if value then
				self:CheckSetValue(value, false)
			end
		end)

		self.Backing.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				self.Dragging = true
				C.UI.DisableDrag = true
				self:SetValueFromSlider(input)
			end
		end)

		self.Backing.InputChanged:Connect(function(input)
			if self.Dragging then
				self:SetValueFromSlider(input)
			end
		end)

		self.Backing.InputEnded:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				self.Dragging = false
				C.UI.DisableDrag = false
			end
		end)

		self:SetValue(default,true,true)

		return self
	end
	
	function SliderTbl:SetValueFromSlider(input)
		local percentage = math.clamp((input.Position.X - self.Track.AbsolutePosition.X) / self.Track.AbsoluteSize.X, 0, 1)
		local value = percentage * (self.Max - self.Min) + self.Min
		self:SetValue(self:FormatValue(value))
	end
	
	function SliderTbl:FormatValue(value)
		local setValue = math.round(value/self.Step)*self.Step
		setValue = math.clamp(setValue,self.Min,self.Max)
		return setValue
	end
	
	function SliderTbl:CheckSetValue(new,instant)
		new = tonumber(new)
		if new then
			self:SetValue(self:FormatValue(new),instant)
		else
			self:SetValue(self.Value,instant)
		end
	end
	
	function SliderTbl:SetValue(new,instant,firstRun)
		local tweenInfo = TweenInfo.new(instant and 0 or .1)
		local percentageComplete = math.clamp((new-self.Min)/(self.Max-self.Min),0,1)
		local placementX = percentageComplete * (1-(.5 * self.CurrentPosition.AbsoluteSize.X/self.Track.AbsoluteSize.X))
		if placementX ~= placementX then
			placementX = percentageComplete
		end
		--(percentageComplete * widthToUse) + (.5 * (1 - widthToUse))
		TS:Create(self.CurrentPosition,tweenInfo,{Position = UDim2.fromScale(placementX,.5)}):Play()
		self.ForceTB.Text = ("%."..self.Digits.."f"):format(new)
		self.Value = new
		SetValueCombined(self,firstRun)
	end
	
	local DropdownFunct = nil
	local DropdownCurrent = nil

	function DropdownTbl.new(parent, options)
		assert(options.Selections,"Selections is missing")
		-- Pick first one!
		if options.Default ~= nil and not table.find(options.Selections,options.Default) then
			options.Default = options.Selections[#options.Selections]
			--warn(`Invalid Setting For DropdownTbl.new for {parent.Name}/{options.Shortcut}, prev {tostring(options.Default)}, Default Selection Applied`)
			--options.Default = nil
		end
		if typeof(options.Default) == "number" then
			options.Default = options.Selections[options.Default]
		end
		--assert(table.find(options.Selections,options.Default),"Default Selection is Missing")

		local self, newFrame, default = DoCombined(DropdownTbl, "Dropdown", parent, options)

        --assert(default, `[Dropdowntbl.new]: Missing/Invalid Default for {parent}`)
		
		self.SelectionsFrame = newFrame
		self.DropdownButton = newFrame:WaitForChild("DropdownButton")
		
		self.Dropdown = C.UI.DropdownFrame
		local DropdownEx = C.Examples.DropdownButtonEx
		
		self.DropdownVisible = false
		
		local function ToggleDropdown()
			if DropdownCurrent then
				if DropdownCurrent ~= self then
					DropdownCurrent.DropdownVisible = false
				end
				DropdownCurrent = nil
			end
			if DropdownFunct then
				C.RemoveGlobalConnection(DropdownFunct)
				DropdownFunct = nil
				DropdownCurrent = nil
			end
			for num, button in ipairs(self.Dropdown:GetChildren()) do
				if button:IsA("TextButton") then
					button:Destroy()
				end
			end
			self.DropdownVisible = not self.DropdownVisible
			if self.DropdownVisible then
				DropdownCurrent = self
				for num, name in ipairs(self.Selections) do
					--if name ~= self.Value then
					local newDropdownEx = DropdownEx:Clone()
					newDropdownEx.Text = name
					newDropdownEx.LayoutOrder = name == self.Value and -1 or num
					newDropdownEx.Position = UDim2.fromScale(0,newDropdownEx.AbsoluteSize.Y*(num-1))
					newDropdownEx.Parent = self.Dropdown
					C.ButtonClick(newDropdownEx,function()
						ToggleDropdown()
						if name ~= self.Value then
							self:SetValue(name)
						end
					end)
					--end
				end
				local function UpdLoc()
					if self.DropdownButton.AbsolutePosition.Y + self.Dropdown.AbsoluteSize.Y + self.DropdownButton.AbsoluteSize.Y 
						< C.GUI.AbsoluteSize.Y then
						self.Dropdown.Position = UDim2.fromOffset(self.DropdownButton.AbsolutePosition.X,
							self.DropdownButton.AbsolutePosition.Y + self.DropdownButton.AbsoluteSize.Y + self.Dropdown.AbsoluteSize.Y)
					else
						self.Dropdown.Position = UDim2.fromOffset(self.DropdownButton.AbsolutePosition.X,
							self.DropdownButton.AbsolutePosition.Y)
					end
				end
				DropdownFunct = C.AddGlobalConnection(RunS.RenderStepped:Connect(UpdLoc))
				UpdLoc()
				self.Dropdown.AnchorPoint = Vector2.new(0, 1)
			end
			self.Dropdown.Visible = self.DropdownVisible
		end
		
		C.ButtonClick(self.DropdownButton,ToggleDropdown)

		self:SetValue(default,true,true)

		return self
	end

	function DropdownTbl:SetValue(new,instant,firstRun)
		self.DropdownButton.Text = new
		self.Value = new
		SetValueCombined(self,firstRun)
	end
	
	function UserListTbl.new(parent,options)
		assert(options.Limit,`{options.Title} doesn't have Limits`)
		local self, newFrame, default = DoCombined(UserListTbl,"UserList",parent,options)
		self.Limit = options.Limit
		self.MainList = newFrame:WaitForChild("MainList")
		self.EnterTB = newFrame:WaitForChild("EnterTB")
		self.AddButton = newFrame:WaitForChild("AddButton")
		self.LimitTL = newFrame:WaitForChild("LimitTL")
		local function AddedButton()
			if #self.Value >= self.Limit then
				C.AddNotification("Maxed","You have the maximum number in the list!")
				return
			elseif self.EnterTB.Text:len() < 3 then
				C.AddNotification("Unavailable","You have entered an invalid username/id!")
				return
			end
			C.TblAdd(self.Value,self.EnterTB.Text)
			self:SetValue(self.Value)
			self.EnterTB.Text = ""
		end
		C.ButtonClick(self.AddButton,AddedButton)
		self.EnterTB.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				AddedButton()
			end
		end)
		self:SetValue(default,true,true)
	end
	function UserListTbl:SetValue(new,instant,firstRun)
		local newList = {}
		C.ClearChildren(self.MainList)
		for num, identification in ipairs(new) do
			local success, user, id = C.GetUserNameAndId(identification)
			if not success then
				continue
			elseif id == C.plr.UserId then
				C.AddNotification("Unavailable","You cannot add yourself")
				continue
			end
			local OneListEx = C.Examples.OneListEx:Clone()
			OneListEx.Name = id
			OneListEx:WaitForChild("UserTL").Text = user
			C.ButtonClick(OneListEx:WaitForChild("DeleteButton"),function()
				C.TblRemove(self.Value,id)
				self:SetValue(self.Value)
			end)
			OneListEx.Parent = self.MainList
			table.insert(newList,id)
		end
		if #newList ~= #new then
			C.AddNotification("User Loading Failed", "Some users have failed to render!")
		end
		self.LimitTL.Text = `{#newList}/{self.Limit}`
		self.Value = newList
		if #newList >= self.Limit then
			self.AddButton.Visible = false
			self.EnterTB.Visible = false
			self.MainList.Position = UDim2.fromOffset(0,50)
		else
			self.AddButton.Visible = true
			self.EnterTB.Visible = true
			self.MainList.Position = UDim2.fromOffset(0,80)
		end
		SetValueCombined(self,firstRun)
	end


	function TextboxTbl.new(parent, options)
		assert(options.Min,"Min is missing")
		assert(options.Max,"Max is missing")
		assert(options.Default,"Default is missing")
		
		local self, newFrame, default = DoCombined(TextboxTbl, "Textbox", parent, options)

		self.Min = options.Min
		self.Max = options.Max

		self.LimitTL = newFrame:WaitForChild("LimitTL")
		self.SetTB = newFrame:WaitForChild("SetTB")

		self.LimitTL.Text = `{self.Min}-{self.Max}`

		self.SetTB.FocusLost:Connect(function(enterPressed)
			RunS.RenderStepped:Wait()
			self:SetValue(self.SetTB.Text, false)
		end)

		C.ButtonClick(newFrame:WaitForChild("EnterButton"),function()
			self:SetValue(self.SetTB.Text)
		end)

		self:SetValue(default,true,true)

		return self
	end
		
	function TextboxTbl:SetValue(new,instant,firstRun)
		if new:len() > self.Max then
			new = new:sub(1,self.Max)
		elseif new:len() < self.Min then
			new = new .. string.rep("E",self.Min - new:len())
		end
		self.SetTB.Text = new
		self.Value = new
		SetValueCombined(self,firstRun)
	end

	
	
	for identity, tbl in pairs(C.UI.Options) do
		-- Define the __call metamethod
		--[[setmetatable(tbl, {
			__call = function(tbl, ...)
				return tbl.new(...)
			end
		})--]]
	end
	
	
end
]=],
    ["Modules/Serializer"] = [=[--------------------------------------------------------------------------------
--                                                                            --
--                  `7MM"""Mq.            .M"""bgd                            --
--                    MM   `MM.          ,MI    "Y                            --
--                    MM   ,M9  ,pW"Wq.  `MMb.      .gP"Ya                    --
--                    MMmmdM9  6W'   `Wb   `YMMNq. ,M'   Yb                   --
--                    MM  YM.  8M     M8 .     `MM 8M""""""                   --
--                    MM   `Mb.YA.   ,A9 Mb     dM YM.    ,                   --
--                  .JMML. .JMM.`Ybmd9'  P"Ybmmd"   `Mbmmd'                   --
--                                                                            --
--                         Roblox Instance Serializer                         --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--  Copyright (c) Gem_API                                                     --
--                                                                            --
--  Permission is hereby granted, free of charge, to any person obtaining     --
--  a copy of this software and associated documentation files (the           --
--  "Software"), to deal in the Software without restriction, including       --
--  without limitation the rights to use, copy, modify, merge, publish,       --
--  distribute, sublicense, and/or sell copies of the Software, and to        --
--  permit persons to whom the Software is furnished to do so, subject to     --
--  the following conditions:                                                 --
--                                                                            --
--  The above copyright notice and this permission notice shall be            --
--  included in all copies or substantial portions of the Software.           --
--                                                                            --
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,           --
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF        --
--  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.    --
--  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY      --
--  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,      --
--  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE         --
--  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                    --
--                                                                            --
--------------------------------------------------------------------------------
-- Utilities

local function invert_table(t)
	local s = {}
	for k in t do
		s[t[k]] = k
	end
	return s
end

local table_pack = table.pack
local table_unpack = table.unpack

local Instance_new = Instance.new
local Vector2_new = Vector2.new
local Vector3_new = Vector3.new
local Color3_new = Color3.new
local ColorSequence_new = ColorSequence.new
local ColorSequenceKeypoint_new = ColorSequenceKeypoint.new
local CFrame_new = CFrame.new
local NumberRange_new = NumberRange.new
local NumberSequenceKeypoint_new = NumberSequenceKeypoint.new
local NumberSequence_new = NumberSequence.new

--------------------------------------------------------------------------------
-- Datasets

local ROSE_VERSION = 2

local DESERIALIZE_DEFAULT_PARENT = nil

local MUTABLE_PROPERTIES = {
	Folder = {
		"Name"
	},
	Model = {
		"Name",

		"PrimaryPart",

		"WorldPivot"
	},
	SpecialMesh = {
		"MeshId",
		"MeshType",
		"Name",
		"Offset",
		"Scale",
		"TextureId"
	},
	BlockMesh = {
		"Name",
		"Offset",
		"Scale",
		"VertexColor"
	},
	CylinderMesh = {
		"Name",
		"Offset",
		"Scale",
		"VertexColor"
	},
	Weld = {
		"C0",
		"C1",
		"Name",
		"Part0",
		"Part1",

		"Enabled"
	},
	Snap = {
		"C0",
		"C1",
		"Name",
		"Part0",
		"Part1",

		"Enabled"
	},
	Part = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",
		"Shape",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface"
	},
	WedgePart = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface"
	},
	CornerWedgePart = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface"
	},
	TrussPart = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",
		"Shape",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface"
	},
	SpawnLocation = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",
		"Shape",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface",

		"Duration",

		"AllowTeamChangeOnTouch",
		"Neutral",
		"TeamColor"
	},
	Seat = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",
		"Shape",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface",

		"Disabled"
	},
	VehicleSeat = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",
		"Shape",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface",

		"Disabled",
		"HeadsUpDisplay",
		"MaxSpeed",
		"Steer",
		"SteerFloat",
		"Throttle",
		"ThrottleFloat",
		"Torque",
		"TurnSpeed"
	},
	Decal = {
		"Color3",
		"Texture",
		"Transparency",
		"ZIndex",

		"Face",
		"Name"
	},
	Texture = {
		"Color3",
		"OffsetStudsU",
		"OffsetStudsV",
		"StudsPerTileU",
		"StudsPerTileV",
		"Texture",
		"Transparency",
		"ZIndex",

		"Face",
		"Name"
	},
	ClickDetector = {
		"MaxActivationDistance",
		"Name",

		"CursorIcon"
	},
	PointLight = {
		"Brightness",
		"Color",
		"Enabled",
		"Range",
		"Shadows",

		"Name"
	},
	SpotLight = {
		"Angle",
		"Brightness",
		"Color",
		"Enabled",
		"Face",
		"Range",
		"Shadows",

		"Name"
	},
	SurfaceLight = {
		"Angle",
		"Brightness",
		"Color",
		"Enabled",
		"Face",
		"Range",
		"Shadows",

		"Name"
	},
	Fire = {
		"Color",
		"Enabled",
		"Heat",
		"Name",
		"SecondaryColor",
		"Size",
		"TimeScale"
	},
	Smoke = {
		"Color",
		"Enabled",
		"Name",
		"Opacity",
		"RiseVelocity",
		"Size",
		"TimeScale"
	},
	Sparkles = {
		"Enabled",
		"Name",
		"SparkleColor",
		"TimeScale"
	},
	ParticleEmitter = {
		"Color",
		"LightEmission",
		"LightInfluence",
		"Orientation",
		"Size",
		"Squash",
		"Texture",
		"Transparency",
		"ZOffset",

		"Name",
		"EmissionDirection",
		"Enabled",
		"Lifetime",
		"Rate",
		"Rotation",
		"RotSpeed",
		"Speed",
		"SpreadAngle",

		"Shape",
		"ShapeInOut",
		"ShapeStyle",

		"FlipbookLayout",

		"Acceleration",

		"Drag",
		"LockedToPart",
		"TimeScale",
		"VelocityInheritance",
		"WindAffectsDrag"
	},
	Beam = {
		"Color",
		"Enabled",
		"LightEmission",
		"LightInfluence",
		"Texture",
		"TextureLength",
		"TextureMode",
		"TextureSpeed",
		"Transparency",
		"ZOffset",

		"Name",

		"Attachment0",
		"Attachment1",
		"CurveSize0",
		"CurveSize1",
		"FaceCamera",
		"Segments",
		"Width0",
		"Width1"
	},
	Attachment = {
		"Visible",

		"Name",

		"CFrame"
	},
    HumanoidDescription = {
        "Name",
        "BackAccessory",
        "BodyTypeScale",
        "ClimbAnimation",
        "DepthScale",
        "Face",
        "FaceAccessory",
        "FallAnimation",
        "FrontAccessory",
        "GraphicTShirt",
        "HairAccessory",
        "HatAccessory",
        "Head",
        "HeadColor",
        "HeadScale",
        "HeightScale",
        "IdleAnimation",
        "JumpAnimation",
        "LeftArm",
        "LeftArmColor",
        "LeftLeg",
        "LeftLegColor",
        "MoodAnimation",
        "NeckAccessory",
        "Pants",
        "ProportionScale",
        "RightArm",
        "RightArmColor",
        "RightLeg",
        "RightLegColor",
        "RunAnimation",
        "Shirt",
        "ShouldersAccessory",
        "SwimAnimation",
        "Torso",
        "TorsoColor",
        "WaistAccessory",
        "WalkAnimation",
        "WidthScale"
    }
}

local IV_CLASSNAMES = {}

for i in MUTABLE_PROPERTIES do
	IV_CLASSNAMES[#IV_CLASSNAMES + 1] = i
end

local VI_CLASSNAMES = invert_table(IV_CLASSNAMES)

local IV_PROPERTY_TYPES = {
	"string",
	"number",
	"boolean",

	"NumberRange",
	"NumberSequence",

	"Vector2",
	"Vector3",

	"Color3",
	"ColorSequence",

	"EnumItem",

	"CFrame",

	"Instance"
}

local VI_PROPERTY_TYPES = invert_table(IV_PROPERTY_TYPES)

local DEFAULT_INSTANCES = {}

for className in MUTABLE_PROPERTIES do
	DEFAULT_INSTANCES[className] = Instance_new(className)
end

--------------------------------------------------------------------------------
-- Internal API

local give_warnings = false

local scope = nil

local uid_counter = 0
local uid_reference = {}

local skipped_instances = 0
local skipped_instance_types = {}

local post_deserialize_links_counter = 0
local post_deserialize_links = {}

local function reset_internal_variables()
	scope = nil

	uid_counter = 0
	uid_reference = {}

	skipped_instances = 0
	skipped_instance_types = {}

	post_deserialize_links_counter = 0
	post_deserialize_links = {}
end

local function build_uid_reference(instance)
	uid_counter += 1
	uid_reference[instance] = uid_counter

	local children = instance:GetChildren()
	for i in children do
		build_uid_reference(children[i])
	end
end

----------------------------------------
-- Serializer

local function serialize_property(p)
	local _type = typeof(p)

	local prop_type = VI_PROPERTY_TYPES[_type]
	if not prop_type then
		return nil
	end

	local value = nil

	if _type == "string" then
		value = p

	elseif _type == "number" then
        if p == math.floor(p) then
            value = p
        else
            value = ("%.3f"):format(p)
        end

	elseif _type == "boolean" then
		value = p

	elseif _type == "Vector3" then
		value = {serialize_property(p.X), serialize_property(p.Y), serialize_property(p.Z)}

	elseif _type == "Color3" then
		value = {serialize_property(p.R), serialize_property(p.G), serialize_property(p.B)}

	elseif _type == "EnumItem" then
		value = p.Value

	elseif _type == "Instance" then
		if not p:IsDescendantOf(scope) then
			warn("Object-type property references '" .. p.Name ..
				"' which is not in the serialization scope."
			)

			return nil
		else
			value = uid_reference[p]
		end

	elseif _type == "CFrame" then
		value = table_pack(p:GetComponents())
        for key, val in ipairs(value) do
            value[key] = serialize_property(val)
        end
	elseif _type == "Vector2" then
		value = {serialize_property(p.X), serialize_property(p.Y)}

	elseif _type == "ColorSequence" then
		value = {}

		local kps = p.Keypoints
		for i in kps do
			local kp = kps[i]
			local kpc = kp.Value

			value[i] = {serialize_property(kp.Time), serialize_property(kpc.R), serialize_property(kpc.G), serialize_property(kpc.B)}
		end

	elseif _type == "NumberRange" then
		value = {serialize_property(p.Min), serialize_property(p.Max)}

	elseif _type == "NumberSequence" then
		value = {}

		local kps = p.Keypoints
		for i in kps do
			local kp = kps[i]

			value[i] = {serialize_property(kp.Time), serialize_property(kp.Value), serialize_property(kp.Envelope)}
		end

	end

	return {
		prop_type,
		value
	}
end

local function serialize_instance(obj)
	local class_name = obj.ClassName

	local prop_pool = MUTABLE_PROPERTIES[class_name]

	local props = {}

	for i in prop_pool do
		local p = prop_pool[i]
		if DEFAULT_INSTANCES[class_name][p] == obj[p] then
			continue
		end
		props[p] = serialize_property(obj[p])
	end

	local children_counter = 0
	local children = {}

	local child_pool = obj:GetChildren()
	for i in child_pool do
		local c = child_pool[i]
		if not MUTABLE_PROPERTIES[c.ClassName] then
			skipped_instance_types[c.ClassName] = 1
			skipped_instances += 1

			continue
		end
		children_counter += 1
		children[children_counter] = serialize_instance(c)
	end

	return {
		uid_reference[obj],
		VI_CLASSNAMES[class_name],
		props,
		children
	}
end

----------------------------------------
-- Deserializer

local function post_deserialize_link_pass()
	for i in post_deserialize_links do
		local v = post_deserialize_links[i]
		v[1][v[2]] = uid_reference[v[3]]
	end
end


local function deserialize_property(property, prop_name, instance)
	local prop_type = IV_PROPERTY_TYPES[property[1]]
	local value = property[2]

	local result = nil

	if prop_type == "string" then
		result = value

	elseif prop_type == "number" then
		result = value

	elseif prop_type == "boolean" then
		result = value

	elseif prop_type == "Vector3" then
		result = Vector3_new(value[1], value[2], value[3])

	elseif prop_type == "Color3" then
		result = Color3_new(value[1], value[2], value[3])

	elseif prop_type == "EnumItem" then
		result = value

	elseif prop_type == "Instance" then
		post_deserialize_links_counter += 1
		post_deserialize_links[post_deserialize_links_counter] =
			{instance, prop_name, value}

	elseif prop_type == "CFrame" then
		result = CFrame_new(table_unpack(value))

	elseif prop_type == "Vector2" then
		result = Vector2_new(value.X, value.Y)

	elseif prop_type == "ColorSequence" then
		local kps = {}

		for i in value do
			local v = value[i]
			kps[i] = ColorSequenceKeypoint_new(
				v[1], Color3_new(v[2], v[3], v[4])
			)
		end

		result = ColorSequence_new(kps)

	elseif prop_type == "NumberRange" then
		result = NumberRange_new(value[1], value[2])

	elseif prop_type == "NumberSequence" then
		local kps = {}

		for i in value do
			local v = value[i]
			kps[i] = NumberSequenceKeypoint_new(
				v[1], v[2], v[3]
			)
		end

		result = NumberSequence_new(kps)

	end

	return result
end

local function deserialize_instance(obj, parent)
	local instance = Instance_new(IV_CLASSNAMES[obj[2]])

	for i in obj[4] do
		deserialize_instance(obj[4][i], instance)
	end

	for name in obj[3] do
		instance[name] = deserialize_property(obj[3][name], name, instance)
	end

	uid_reference[obj[1]] = instance

	instance.Parent = parent or DESERIALIZE_DEFAULT_PARENT

	return instance
end

--------------------------------------------------------------------------------
-- Exposed API

local rose = {}

function rose.serialize(instance)
	if not MUTABLE_PROPERTIES[instance.ClassName] then
		warn("Given instance was not serializable")
		return nil
	end

	reset_internal_variables()

	build_uid_reference(instance)

	local result = serialize_instance(instance)

	if skipped_instances ~= 0 and give_warnings then
		warn("ROSE - Some instance(s) were not serialized:")
		for i in skipped_instance_types do
			warn("    Type '" .. i .. "'")
		end
	end

	return {
		["version"] = ROSE_VERSION,
		["tree"] = result
	}
end

function rose.deserialize(packet)
	if packet.version ~= ROSE_VERSION then
		warn("ROSE packet provided was generated by an older version of ROSE.")
		return nil
	end

	reset_internal_variables()

	local result = deserialize_instance(packet.tree)

	post_deserialize_link_pass()

	return result
end

function rose.give_warnings(value: boolean)
	give_warnings = value
end

return rose]=],
    ["Scripts/Chat%20Bypass"] = [[return {
    Name = "Chat Bypass",
    ScriptRun = function()
        task.spawn(loadstring(game:HttpGet("https://raw.githubusercontent.com/1price/usercreation/main/UserCreation.lua")))
    end
}]],
    ["Scripts/Dark%20Dex"] = [[return {
    Name = "Dark Dex (Fix)",
    ScriptRun = function(C,Settings)
        -- DARK DEX but disabling print

        local oldestPrint = print

        -- Cloneref support (adds support for JJsploit/Temple/Electron and other sploits that don't have cloneref or really shit versions of it.)
        --loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/CloneRef.lua", true))()

        -- Dex Bypasses
        --loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/Bypasses.lua", true))()

        -- Dex with CloneRef Support (made as global)
        getgenv().Bypassed_Dex = game:GetObjects("rbxassetid://9352453730")[1]
        local Bypassed_Dex = getgenv().Bypassed_Dex

        local charset = {}
        for i = 48,  57 do table.insert(charset, string.char(i)) end
        for i = 65,  90 do table.insert(charset, string.char(i)) end
        for i = 97, 122 do table.insert(charset, string.char(i)) end
        local function RandomCharacters(length)
            if length > 0 then
                return RandomCharacters(length - 1) .. charset[math.random(1, #charset)]
            else
                return ""
            end
        end

        Bypassed_Dex.Name = RandomCharacters(math.random(5, 20))
        if gethui then
            Bypassed_Dex.Parent = gethui();
        elseif syn and syn.protect_gui then
            syn.protect_gui(Bypassed_Dex);
            Bypassed_Dex.Parent = cloneref(game:GetService("CoreGui"))
        else
            Bypassed_Dex.Parent = cloneref(game:GetService("CoreGui"))
        end

        local function Load(Obj, Url)
            local function GiveOwnGlobals(Func, Script)
                local Fenv = {}
                local RealFenv = {script = Script}
                local FenvMt = {}
                function FenvMt:__index(b)
                    if RealFenv[b] == nil then
                        return getfenv()[b]
                    else
                        return RealFenv[b]
                    end
                end
                function FenvMt:__newindex(b, c)
                    if RealFenv[b] == nil then
                        getfenv()[b] = c
                    else
                        RealFenv[b] = c
                    end
                end
                setmetatable(Fenv, FenvMt)
                setfenv(Func, Fenv)
                return Func
            end

            local function LoadScripts(Script)
                if Script.ClassName == "Script" or Script.ClassName == "LocalScript" then
                    task.spawn(function()
                        GiveOwnGlobals(loadstring(Script.Source, "=" .. Script:GetFullName()), Script)()
                        if Script.Name == "LocalScript" and Script.Parent.Name == "ExplorerPanel" then
                            print = oldestPrint
                        end
                    end)
                end
                for _,v in ipairs(Script:GetChildren()) do
                    LoadScripts(v)
                end
            end

            LoadScripts(Obj)
        end

        Load(Bypassed_Dex)
    end,
}]],
}
C.forcePropertyFuncts = {}
C.BindedActions = {} -- key binds
C.CharacterAddedEventFuncts = {}
C.PlayerAddedEventFuncts = {}
C.EventFunctions, C.InsertCommandFunctions = {}, {}
C.Camera = workspace.CurrentCamera -- updated later in Events
C.Randomizer = Random.new()
C.PartConnections = {}
C.ChatVersion = TextChatService.ChatVersion.Name
C.BotUsers = {`lexxy4life`,`theweirdspook`,`lifeisoofs`,`itsagoodgamebro`,`itsagoodgamebros`,`bottingforthewin`}
C.AdminUsers = {`suitedforbans`,`suitedforbans2`,`suitedforbans3`,`suitedforbans4`,`suitedforbans5`,
`suitedforbans6`,`suitedforbans7`,`suitedforbans8`,`suitedforbans9`,`suitedforbans10`,`suitedforbans11`,`suitedforbans12`,
`biglugger2017`,`sssnsss74`,`itsagoodgamebro`,`itsagoodgamebros`,`lifeisoofs`,`averynotafkbot3`,`theweirdspook`,`lexxy4life`,
`yvettecarreno08`}
if not C.getgenv().PlaceName then
	C.getgenv().PlaceName = MPS:GetProductInfo(game.PlaceId).Name
end
C.Debugs = {All = false,
	Destroy = false,
	Module = false,
	Load = false,
	Teleport = false,
	Override = false,
	Thread = false,
	SaveSystem = false,
	RenderHighlight=false,
	AntiCheat = false,
}
--print("2")

local Settings = C.getgenv().SETTINGS
if not Settings then
	Settings = {
		ServerSaveDeleteTime = 3600 * 24, -- Time before deletion
        StartDisabled = false, -- Starts everything disabled, regardless of your saved settings
        ConnectAllEvents = false, -- Connects every event [EXPENSIVE]
	}
	C.getgenv().SETTINGS = Settings
end
C.getgenv().C = C

function C.DebugMessage(type,message)
	local PreDebugMessage = `[{C.SaveIndex or "Unreg"}/%s]: `
	assert(C.Debugs[type]~=nil, `{PreDebugMessage}Message Type Not Found: "{tostring(type)}" in an attempt to create message: "{message}"`)
	if not C.Debugs[type] and not C.Debugs.All then
		return false
	end
	print(`{PreDebugMessage:format(type)}{message}`)
	return true
end

function C.StringWait(start,path,timeout,seperationChar)
	if not start then return end
	local current = start
	local pathTbl = path:split(seperationChar or ".")
	for i,v in ipairs(pathTbl) do
		local next = current:WaitForChild(v,timeout)
		if next then
			current = next
		else
			warn("C.StringWait failed to find "..v.." in "..next:GetFullName().." from "..tostring(start))
			return
		end
	end
	return current
end

function C.StringFind(start,path,seperationChar,recursionEnabled)
	if not start then return end
	local current = start
	local pathTbl = path:split(seperationChar or ".")
	for i,v in ipairs(pathTbl) do
		local next = current:FindFirstChild(v,recursionEnabled)
		if next then
			current = next
		else
			--warn("C.StringFind failed to find "..v.." in "..current:GetFullName().." from "..tostring(start))
			return
		end
	end
	return current
end

function C.AddGlobalInstance(instance)
	table.insert(C.instances,instance)
end

function C.RemoveGlobalInstance(instance)
	return C.TblRemove(C.instances,instance)
end

local ModulesLoaded = 0
function C.RunLink(githubLink,gitType,name)
    local RequestFinished = false
	local URL = githubLink:format(gitType:lower(),name);
    task.delay(3,function()
        if (not RequestFinished) then
            RequestFinished = true
            print("[C.RunLink]: Module Yielding For > 3 seconds: "..name.." [PRESUMING DEAD]")
            C.RunLink(githubLink, gitType, name)
        end
    end)
	local success, response = pcall(game.HttpGet,game,URL,false)
    if RequestFinished then
        print("[C.RunLink]: Module Yielding Callback-ed after alloted time: "..name)
        return
    end
    RequestFinished = true
	if not success then
		return warn(PrintName.." Error Requesting Script " .. name .. ":" ..response)
	end
	local scriptName = URL:sub(20)
	scriptName = scriptName:sub(scriptName:find("/")+1)
	scriptName = scriptName:sub(1,scriptName:find("/")-1):gsub("-"," ")
	local success3, codeString
	if URL:find("blob")~=nil then
		local startText = '"blob":{"rawLines":'
		local endText = ',"stylingDirectives":'
		local startAddress = response:find(startText) + startText:len()
		local endAddress = response:find(endText) -- endText:len()
		response = response:sub(startAddress,endAddress-1)
		local success2, decodedJSON = pcall(HS.JSONDecode,HS,response)

		if not success2 then
			return warn(PrintName.." Error Parsing JSON: "..decodedJSON)
		end

		success3, codeString = pcall(table.concat, decodedJSON, "\n")

		if not success3 then
			return warn(PrintName.." Error Parsing Code: "..codeString)
		end
	elseif URL:find("raw") then
		codeString = response
	end

	local success4, compiledFunction = pcall(loadstring,codeString)

	if not success4 then
		return warn(PrintName.." Error Compiling Code: "..compiledFunction)
	elseif not compiledFunction then
		return warn(PrintName.." Loadstring Failed: Syntax Error!\n\n\t\tCheck Github or DM author!")
	end
    ModulesLoaded+=1
	return compiledFunction()
end
--print("3")

C.SaveModules = {}
local LoadedModules = {}
function GetModule(path: string)
    -- All paths start from src and to the lua file
	-- local path = moduleName:find("/") and moduleName or ("Modules/"..moduleName)
	if isStudio then
		return require(C.StringWait(script,path,nil,"/"))(C, Settings)
	else
		local gitType = "blob"
		local githubLink = C.BaseUrl .. "/%s.lua"
        assert(C.preloadedModule[path], `{path} does not have a preloaded module!`)
		local result = C.preloadedModule[path]
        if PreCached and not LoadedModules[path] then
            LoadedModules[path] = true
            result = loadstring(result)()
            C.preloadedModule[path] = result
        elseif not PreCached and not result then
            result = C.RunLink(githubLink,gitType,path)
        end
		if typeof(result) == "function" then
			return result(C,Settings)
		else
			return result
		end
	end
end
function HttpUrlDecode(str)
	local output, t = string.gsub(str,"%%(%x%x)",function(hex)
		return string.char(tonumber(hex,16))
	end)
	return output
end
function C.LoadModule(moduleName: string)
	local informalSplit = moduleName:split("/")
	local informalName = informalSplit[#informalSplit]
	local Ret = C.SaveModules[informalName]
	if Ret then
		return Ret
	end
	local DisplayName = HttpUrlDecode(moduleName)
	local Start = os.clock()
	C.DebugMessage("Module",`Loading {DisplayName}`)
	local Mod = GetModule(moduleName)
	C.SaveModules[informalName] = Mod
	C.DebugMessage("Module",(`Loaded {DisplayName} in %.2f seconds`):format(os.clock()-Start))
	return Mod
end
--print("modules p reload")

local ModulesToPreload = {"Hacks/Blatant","Hacks/Friends","Hacks/Render","Hacks/Utility","Hacks/World","Hacks/Settings","Binds","CoreEnv","CoreLoader","Env","Events","GuiElements","HackOptions"}
if not C.isStudio and not PreCached then
	for num, module in ipairs(ModulesToPreload) do

		local gitType = "blob"
		local githubLink = C.BaseUrl .. "/%s.lua"
		local path = module:find("/") and module or ("Modules/"..module)
		local moduleParams = module:split("/")
		local informalSplit = module:split("/")
		local informalName = informalSplit[#informalSplit]
		task.delay(0.1 * (num), C.RunLink, githubLink,gitType,path)
	end
    --local startWait = os.clock()
	while ModulesLoaded < #ModulesToPreload do
		RunS.RenderStepped:Wait()
	end
    --print(("Module Loading Wait: %.1fs"):format(os.clock() - startWait))
end

--Load hooks immediately
local originalNamecall = nil
local getgenv = getgenv
local debFunct, traceback, tskWait, coroYield = C.DebugMessage, debug.traceback, task.wait, coroutine.yield
local tskSpawn, tskDelay = task.spawn, task.delay
local yieldForeverFunct
function yieldForeverFunct()
	tskSpawn(debFunct,"AntiCheat",traceback("Yielding Forever"))
	--tskWait(highestNum)
	--while true do
	coroYield()--Yields the thread forever
	--end

	warn(traceback(`YIELDING COMPLETE!? THIS IS NOT SUPPOSED TO HAPPEN. PLEASE CHECCK C.yieldForeverFunct`))
	yieldForeverFunct() -- Run it again sucker!
end
C.yieldForeverFunct = yieldForeverFunct
C.getgenv().SavedHookData = C.getgenv().SavedHookData or {}
C.getgenv().realhookfunction = C.getgenv().realhookfunction or C.getgenv().hookfunction
local MetaMethods = {"__index","__namecall","__newindex"}
local AllowHookMethod = true;
function C.HookFunc(funct, name, hook)
    local SavedStorage = getgenv().SavedHookData[funct]
    if not SavedStorage then
        if not hook then
            return
        end
        SavedStorage = {Name = name, Hook = hook}
        local localCheckCaller = C.checkcaller
        local OldMethod
        OldMethod = C.hookfunction(funct, hook, function(...)
            if not localCheckCaller() then
                local currFunc = rawget(SavedStorage,"Hook")
                if currFunc then
                    return currFunc(...)
                end
            end
            return OldMethod(...)
        end)
        SavedStorage.OldMethod = OldMethod
        getgenv().SavedHookData[funct] = SavedStorage
    else
        assert(SavedStorage.Name == name, `[C.HookFunction]: {SavedStorage.Name} does not match {name}!`)
        SavedStorage.Hook = hook
    end
    return SavedStorage.OldMethod
end
function C.HookMethod(hook, name, runFunct, methods, source)
	if C.isStudio or (not C.getgenv().SavedHookData[hook] and not runFunct) then
		return
    elseif not AllowHookMethod then
        warn("Hook Method Disabled; Attempt For:",hook,name)
        return
	end
	assert(name ~= "OldFunction", `[C.HookMethod]: {name} is a reserved method! Please use a different one!`)
	assert(hook ~= "__namecall" or #methods ~= 0, `[C.HookMethod]: __namecall {name} hooks require at least one method, but none was specified`)
	if not C.getgenv().SavedHookData[hook] then
		-- Hook the namecall function
		local gameId = game.GameId
		local checkcaller = C.checkcaller
		local gmatch, gsub, getType = string.gmatch, string.gsub, typeof
		local getVal, setVal = rawget, rawset
		local strLen, toStr = string.len, function(instance)
			local myType = getType(instance);
			if (myType == "table") then
				return "tbl"
			elseif myType == "Instance" then
				return instance.Name
			elseif myType == "number" or myType == "string" then
				return instance
			end
			return instance
		end
		local getcallingscript,getnamecallmethod,lower,tblFind,tblPack,tblUnpack = C.getcallingscript,getnamecallmethod,string.lower,table.find,table.pack,unpack
		local additionalCallerName = {["SayMessageRequest"]=true,["getloghistory"]=true,["getlogHistory"]=true}
		local additionalMethodName = {["sendasync"]=true}
		local additionalAvoidLower = {["getlogHistory"] = true}

		--[[if (not C.getgenv().hookedDebugInfo) then
			C.getgenv().hookedDebugInfo = true
			local OldDebug
			OldDebug = hookfunction(debug.info, function(num, arg, ...)
				if (arg == "f") then
					print("Bypassing hook!",debug.traceback())
					return OldDebug(num + 2, arg, ...)
				elseif (arg == "s") then
					return "[C]"
				elseif (arg == "l") then
					return 1
				elseif (arg == "n") then
					return ""
				elseif (arg == "a") then
					return 0
				end
				return OldDebug(num, arg, ...)
			end)
			print("HOOKED DEBUG.INFO")
		end--]]

		local myHooks = {}
		C.getgenv().SavedHookData[hook] = myHooks

		local HookType = ((source or typeof(hook)=="function") and "hookfunction")
			or (typeof(hook)=="string" and "hookmetamethod")

		assert(hookfunction,`[C.HookMethod]: Unknown HookType: {hook}!`)
		for num, methodName in ipairs(methods or {}) do
			assert(methodName == lower(methodName),`[C.HookMethod]: {toStr(methodName)} is not lowercase!`)
		end

		local OriginFunct
		local function CallFunction(self,...)
			--if (lower(getnamecallmethod()) == "getloghistory") then
			--	print("one")
			--end
			-- Get the method being called
			local method
            if (lower(getnamecallmethod() or "") == "getloghistory"
                or (... and getType(...) == "string" and lower(...) == "getloghistory")) then
				tskSpawn(print, "LOG", self, ...)
			end
			if HookType=="hookmetamethod" then
				if hook == "__namecall" then
					method = getnamecallmethod()
				else
					method = ...
				end
                --Basic safety..
				if lower(method) == "name" then
					return OriginFunct(self, ...)
				end
			elseif HookType == "hookfunction" then
				method = self
			end
			if method and getType(method) == "string" then
				if not rawget(additionalAvoidLower, method) then
					method = lower(method)
				end
				local parsed, count = gsub(method, "\000.*", "")
				if strLen(parsed) > 0 and count <= 1 then
					method = parsed
				elseif count > 1 then
					warn(`Parsed Method Count {count} For Method: {toStr(self)} {method}`)
				else
					warn(`Empty Message Parsed from {toStr(self)} {method}. Copied to clipboard for further inspection.`)
					getVal(C,"setclipboard")(method)
				end
			end
			--if getVal(additionalCallerName,toStr(self)) or getVal(additionalMethodName,method) or toStr(self) == "RBXGeneral" then
			--	tskSpawn(print,self,method,checkcaller(),getVal(additionalMethodName,method))
			--end

			local Override = getVal(additionalCallerName,toStr(self)) or getVal(additionalMethodName,method)
			local isGameScript = not checkcaller()
			 -- Check if the caller is not a local script
			 if isGameScript or Override then
                local theirScript = getcallingscript() or "nullptr"
				--if not theirScript and "WalkSpeed"==({...})[1] then
				--	tskSpawn(print,`method walkspeed {toStr(method)}`)
				--end
				if theirScript~="nullptr" or Override then
					if gameId == 1160789089 and toStr(theirScript) == "BAC_" then
						if hook == "__index" then
							--tskSpawn(debFunct,"AntiCheat",`Sending yielding forever function for script {theirScript.Name}`)
							return coroYield -- Return the function to run forever haha!!
						else
							--tskSpawn(debFunct,"AntiCheat",`Yielding forever on script {theirScript.Name}`)
							coroYield()
							error("coroutine thread was attempting to be resumed for script "..theirScript.Name)
							return
						end
					end--]]
					-- Block FireServer or InvokeServer methods
					for name, list in pairs(myHooks) do
						if (name == "OldFunction") then
							continue
						end
						local indexes = getVal(list,2)
						if not indexes or tblFind(indexes,method) then -- Authorization
							--myPrint("Authorized",theirScript)
							local isRunning = true
							tskDelay(3, function()
								if isRunning then
									warn(`[C.{HookType}]: Hook is taking > 3 seconds to run with id = {name}; method = {method}; orgScript = {theirScript}`)
								end
							end)
							local operation,returnData = getVal(list,3)(theirScript,method,self,...)
							isRunning = false
							if operation then
								if operation == "Override" or operation == "FireSeperate" then
									assert(typeof(getVal(returnData,1)) == typeof(self),
										`Invalid Override Argument 1; Expected same type as self {self} with id = {name}; method = {method}; origin = {theirScript}`)
								end
								if operation == "Spoof" then
									return tblUnpack(returnData)
								elseif operation == "Override" then
									return OriginFunct(tblUnpack(returnData))
								elseif operation == "FireSeperate" then
									return tskSpawn(OriginFunct,tblUnpack(returnData))
								elseif operation == "Cancel" then
									return -- Cancelled
								elseif operation == "Yield" then
									if hook == "__index" then
										return yieldForeverFunct -- Return the function to run forever haha!!
									else
										return yieldForeverFunct()
									end
								else
									warn(`[C.{HookType}]: Unknown Operation for {name}: {operation}. Letting Function Run!`)
								end
							end
						end
					end
                end
            end
			return OriginFunct(self,...)
		end
		--[[if HookType == "hookfunction" and typeof(hook) == "string" and source then -- we'll do this the old way then!
			OriginFunct = rawget(source,hook)
			rawset(source,hook,CallFunction)
			print("Origin",OriginFunct,hook,source)
		else--]]
		OriginFunct = (HookType == "hookmetamethod" and C.hookmetamethod(source or game, hook, (CallFunction)))
			or (HookType == "hookfunction" and C.hookfunction(hook, CallFunction))
		C.getgenv().SavedHookData[hook].OldFunction = OriginFunct
		--end
	end
	if runFunct then
		C.getgenv().SavedHookData[hook][name] = {name,methods,runFunct}
		return C.getgenv().SavedHookData[hook].OldFunction
	else
		C.getgenv().SavedHookData[hook][name] = nil
	end
end
--print("6")

--[[function C.HookNamecall(name,methods,runFunct)
	error"SHOULDN't be running"
	if C.isStudio or (not C.getgenv().NamecallHooks and not methods) then
		return
	end
    if not C.getgenv().NamecallHooks then
		warn("STARTING HOOKNAMECALL (should only happen once)")
        -- Hook the namecall function
		local checkcaller = C.checkcaller
        local getcallingscript,getnamecallmethod,lower,tblFind,tblPack,tblUnpack = C.getcallingscript,getnamecallmethod,string.lower,table.find,table.pack,table.unpack

		local myHooks = {}
        C.getgenv().NamecallHooks = myHooks
        originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            -- Check if the caller is not a local script
            if not checkcaller() and self.Name ~= "CharacterSoundEvent" then
                -- Get the method being called
                local method = lower(getnamecallmethod())
                local theirScript = getcallingscript()
                -- Block FireServer or InvokeServer methods
                for name, list in pairs(myHooks) do
                    if tblFind(list[1],method) then -- Authorization
                        local operation,returnData = list[2](theirScript,method,self,...)
                        if operation then
                            if operation == "Override" then
                                return tblUnpack(returnData)
                            elseif operation == "Cancel" then
                                return
                            elseif operation == "Yield" then
                                C.yieldForeverFunct()
								warn("[C.HookNameCall:] YIELDING COMPLETE!?")
								return
                            else
                                warn(`[C.HookNameCall]: Unknown Operation for {name}: {operation}. Letting Remote Run!`)
                            end
                        end
                    end
                end
            end

            -- If the caller is a local script, call the original namecall method
            return originalNamecall(self, ...)
        end))
    end
    if methods then
        C.getgenv().NamecallHooks[name] = {methods,runFunct}
    else
        C.getgenv().NamecallHooks[name] = nil
    end
end
function C.HookFunction(name,orgFunct,runFunct)
	C.getgenv().FunctionHooks = C.getgenv().FunctionHooks or {}
	if C.isStudio or (not C.getgenv().FunctionHooks[orgFunct] and not runFunct) then
		return
	end
    if not C.getgenv().FunctionHooks[orgFunct] then
		warn("STARTING FUNCTIONCALL FOR FUNCT (should only happen once per function)")
        -- Hook the namecall function
		local checkcaller = C.checkcaller
        local getcallingscript,getnamecallmethod,lower,tblFind,tblPack,tblUnpack = C.getcallingscript,getnamecallmethod,string.lower,table.find,table.pack,table.unpack

		local myHooks = {}
        C.getgenv().FunctionHooks[orgFunct] = myHooks
        originalNamecall = C.hookfunction(orgFunct, function(self, ...)
            -- Check if the caller is not a local script
            if not checkcaller() then
                -- Get the method being called
                local theirScript = getcallingscript()
                -- Block FireServer or InvokeServer methods
                for name, list in pairs(myHooks) do
					local operation,returnData = list[1](theirScript,self,...)
					if operation then
						if operation == "Override" then
							return tblUnpack(returnData)
						elseif operation == "Cancel" then
							return
						elseif operation == "Yield" then
							C.yieldForeverFunct()
							warn("[C.HookFunction:] YIELDING COMPLETE!?")
							return
						else
							warn(`[C.HookFunction]: Unknown Operation for {name}: {operation}. Letting Remote Run!`)
						end
                    end
                end
            end

            -- If the caller is a local script, call the original namecall method
            return originalNamecall(self, ...)
        end)
    end
    if runFunct then
        C.getgenv().FunctionHooks[orgFunct][name] = {runFunct}
    else
        C.getgenv().FunctionHooks[orgFunct][name] = nil
    end
end--]]


--Load AntiCheat Immediately!
C.LoadModule("Modules/AntiCheat")
return C.LoadModule("Modules/CoreLoader")