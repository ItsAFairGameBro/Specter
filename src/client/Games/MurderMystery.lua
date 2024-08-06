local HttpService = game:GetService("HttpService")
local PS = game:GetService("Players")
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local function Static(C, Settings)
    local RoundTimerPart = workspace:WaitForChild("RoundTimerPart")
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
        local defactoInGame = (theirChar:GetPivot().Position - RoundTimerPart.Position).Magnitude > 300
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
                        while info.Enabled do
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
                    if select(2,C.isInGame(C.char)) ~= "Sheriff" then
                        return "Not Sheriff"
                    end
                    C.AddOverride(C.hackData.Blatant.Noclip, self.Shortcut)
                    C.SavePlayerCoords(self.Shortcut)
                    local info = {Name=self.Shortcut,Tags={"RemoveOnDestroy"}}
                    local actionClone = C.AddAction(info)
                    local LastClick = os.clock() - .89
                    local Gun = C.StringFind(C.plr,'Backpack.Gun') or C.StringFind(C.char,'Gun')
                    local RemoteFunction = C.StringWait(Gun,"KnifeLocal.CreateBeam.RemoteFunction")
                    for num, theirChar in ipairs(CS:GetTagged("Character")) do -- loop through characters
                        if theirChar == C.char then
                            continue--don't try and oof yourself, won't end well.
                        end
                        while info.Enabled do
                            local inGame = table.pack(C.isInGame(theirChar))
                            if not inGame[1] or inGame[2] ~= "Murderer" or not inGame[3] then
                                break
                            end
                            if Gun.Parent ~= C.char then
                                C.human:EquipTool(Gun)
                            end
                            C.DoTeleport(theirChar:GetPivot() * CFrame.new(0,-0,0.4)) -- Behind 2 studs
                            if not LastClick or os.clock() - LastClick > 1 then
                                task.spawn(RemoteFunction.InvokeServer,RemoteFunction,1,theirChar:GetPivot().Position,"AH2")
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
                    if select(2,C.isInGame(C.char)) ~= "Innocent" then
                        return "Not Innocent"
                    end
                    C.SavePlayerCoords(self.Shortcut)
                    local info = {Name=self.Shortcut,Tags={"RemoveOnDestroy"}}
                    local actionClone = C.AddAction(info)
                    local Gun = C.StringFind(workspace,"Normal.GunDrop")
                    while Gun and Gun.Parent == C.Map and select(2,C.isInGame(C.char)) == "Innocent" and info.Enabled do
                        C.DoTeleport(Gun:GetPivot())
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
				Layout = 4, Default=true, DontActivate = true,
				Shortcut = "AutoWin", Functs = {},
                Reset = function(self)
                    C.RemoveOverride(C.hackData.MurdererWin,self.Shortcut)
                    C.RemoveOverride(C.hackData.SheriffWin,self.Shortcut)
                    C.RemoveOverride(C.hackData.GunPickup,self.Shortcut)
                end,
				Activate = function(self,newValue)
                    self:Reset()
                    if newValue and C.GameInProgress then
                        table.insert(self.Functs,C.plr.Backpack.ChildAdded:Connect(function(newChild)
                            if newChild.Name == "Gun" then
                                C.AddOverride(C.hackData.SheriffWin,self.Shortcut)
                            elseif newChild.Name == "Knife" then
                                C.AddOverride(C.hackData.MurdererWin,self.Shortcut)
                            end
                        end))
                        table.insert(self.Functs,C.Map.ChildAdded:Connect(function(newChild)
                            if newChild.Name == "Gun" then
                                C.AddOverride(C.hackData.GunPickup,self.Shortcut)
                            end
                        end))
                    end
                end,
                Events = {
                    GameStatus = function(self,en)
                        C.ReloadHack(self)
                    end,
                }
            },
            {
				Title = "Disable Killbricks",
				Tooltip = "Removes the killbricks in the map",
				Layout = 100,
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