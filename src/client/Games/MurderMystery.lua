local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}

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
                        if C.char then
                            table.insert(self.Functs,C.char.ChildAdded:Connect(BackpackAdded))
                        end
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
end