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
				Activate = function(self,newValue)
                    C.RemoveAction(self.Shortcut)
                    if select(2,C.isInGame(C.char)) ~= "Sheriff" then
                        return "Not Sheriff"
                    end
                    C.AddOverride(C.hackData.Blatant.Noclip, self.Shortcut)
                    C.SavePlayerCoords(self.Shortcut)
                    local info = {Name=self.Shortcut,Tags={"RemoveOnDestroy"}}
                    local actionClone = C.AddAction(info)
                    local LastClick, LastTeleport = os.clock() - .7, os.clock() - .5
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
                            if Gun.Parent ~= C.char then
                                C.human:EquipTool(Gun)
                            end
                            local options = {
								ignoreInvisibleWalls = false,
								ignoreUncollidable = true,
								ignoreList = {C.char},  -- Example: ignore parts in this list
								raycastFilterType = Enum.RaycastFilterType.Exclude,  -- Choose filter type
								distance = 12,  -- Retry up to 3 times
							}
                            local dir = theirChar:GetPivot().Position - theirChar:GetPivot()*Vector3.new(0,0,-10)

							local hitResult, hitPosition = C.Raycast(theirChar:GetPivot().Position,dir,options)

                            --theirChar:GetPivot() * CFrame.new(0,-0,0.4)) -- Behind 2 studs
                            if not LastTeleport or os.clock() - LastTeleport >= .5 then
                                C.DoTeleport(CFrame.new(hitPosition,theirChar:GetPivot().Position))
                                LastTeleport = os.clock()
                            end
                            if not LastClick or os.clock() - LastClick > 1 then
                                task.spawn(RemoteFunction.InvokeServer,RemoteFunction,1,theirChar:GetPivot().Position+theirChar.PrimaryPart.AssemblyLinearVelocity/50,"AH2")
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
                end,
				Activate = function(self,newValue)
                    self:Reset()
                    if newValue and C.GameInProgress then
                        local Backpack = C.StringWait(C.plr, "Backpack")
                        local function BackpackAdded(newChild,notConn)
                            if not notConn then
                                print("Registered",newChild)
                            end
                            if newChild.Parent ~= C.plr:WaitForChild("Backpack") then
                                return -- not backpack
                            end
                            if newChild.Name == "Gun" then
                                C.AddOverride(C.hackData.MurderMystery.SheriffWin,self.Shortcut)
                            elseif newChild.Name == "Knife" then
                                C.AddOverride(C.hackData.MurderMystery.MurdererWin,self.Shortcut)
                            end
                        end
                        table.insert(self.Functs,C.plr.DescendantAdded:Connect(BackpackAdded))
                        table.insert(self.Functs,C.char.ChildAdded:Connect(BackpackAdded))
                        for num, item in ipairs(Backpack:GetChildren()) do
                            task.spawn(BackpackAdded,item,true)
                        end
                        for num, item in ipairs(C.char:GetChildren()) do
                            task.spawn(BackpackAdded,item,true)
                        end
                        local function MapAdded(newChild)
                            if newChild.Name == "GunDrop" then
                                C.AddOverride(C.hackData.MurderMystery.GunPickup,self.Shortcut)
                            end
                        end
                        workspace:WaitForChild("Normal"):WaitForChild("Map")
                        table.insert(self.Functs,C.Map.ChildAdded:Connect(MapAdded))
                        for num, item in ipairs(C.Map:GetChildren()) do
                            task.spawn(MapAdded,item)
                        end
                    end
                end,
                Events = {
                    GameStatus = function(self,en)
                        task.spawn(C.ReloadHack,self)
                    end,
                }
            },
            {
				Title = "Disable Killbricks",
				Tooltip = "Removes the killbricks in the map",
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
        }
    }
end