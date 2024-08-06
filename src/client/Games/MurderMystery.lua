local HttpService = game:GetService("HttpService")
local PS = game:GetService("Players")
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local function Static(C, Settings)
    local RoundTimerPart = workspace:WaitForChild("RoundTimerPart")
    function C.isInGame(theirChar)
		if theirChar and theirChar.Name == "InviClone" then
			theirChar = C.char
		end
		local player,human=PS:GetPlayerFromCharacter(theirChar), theirChar:FindFirstChild("Humanoid")
		if not player or not human or human.Health <=0 or not C.GameInProgress then
			return false, "Lobby", false--No player, no team!
		end
        local defactoInGame = (theirChar:GetPivot().Position - RoundTimerPart.Position).Magnitude > 150
        local realInGame = player:GetAttribute("Alive")
        local hasGun = theirChar:FindFirstChild("Gun") or C.StringFind(player,"Backpack.Gun")
        local hasKnife = theirChar:FindFirstChild("Knife") or C.StringFind(player,"Backpack.Knife")

        if hasGun then
            return realInGame, "Sheriff", defactoInGame
        elseif hasKnife then
            return realInGame, "Murderer", defactoInGame
        end

		return realInGame, (defactoInGame or realInGame) and "Innocent" or "Lobby", defactoInGame
	end
    C.GameInProgress = game:GetService("Workspace").RoundTimerPart.SurfaceGui.Timer.Text ~= "1s"
    C.AddGlobalConnection(C.StringWait(RS,"Remotes.Gameplay.RoundStart").OnClientEvent:Connect(function(...)
        C.GameInProgress = true
    end))
    C.AddGlobalConnection(C.StringWait(RS,"Remotes.Gameplay.VictoryScreen").OnClientEvent:Connect(function(...)
        C.GameInProgress = false
    end))
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
        Tab = {
            {
				Title = "Murderer Win",
				Tooltip = "As the murderer, kill every single person",
				Layout = 0,Type="NoToggle",
				Shortcut = "MurdererWin", Threads={},
				Activate = function(self,newValue)
                    if select(2,C.isInGame(C.char)) ~= "Murderer" then
                        return "Not Murderer"
                    end
                    C.SavePlayerCoords(self.Shortcut)
                    local info = {Name=self.Shortcut,Tags={"RemoveOnDestroy"}}
                    local actionClone = C.AddAction(info)
                    local LastClick
                    local Knife = C.StringFind(C.plr,'Backpack.Knife') or C.StringFind(C.char,'Knife')
                    for num, theirChar in ipairs(CS:GetTagged("Character")) do -- loop through characters
                        if theirChar == C.char then
                            continue--don't try and oof yourself, won't end well.
                        end
                        while info.Enabled and C.isInGame(theirChar) do
                            if Knife.Parent ~= C.char then
                                C.human:EquipTool(Knife)
                            end
                            C.DoTeleport(theirChar:GetPivot() * CFrame.new(0,0,2)) -- Behind 2 studs
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
				end,
				Options = {
					
				}
			},
            {
				Title = "Sheriff Win",
				Tooltip = "As the sheriff, kill the murderer",
				Layout = 0,Type="NoToggle",
				Shortcut = "SheriffWin", Threads={},
				Activate = function(self,newValue)
                    if select(2,C.isInGame(C.char)) ~= "Sheriff" then
                        return "Not Sheriff"
                    end
                    C.SavePlayerCoords(self.Shortcut)
                    local info = {Name=self.Shortcut,Tags={"RemoveOnDestroy"}}
                    local actionClone = C.AddAction(info)
                    local LastClick
                    local Gun = C.StringFind(C.plr,'Backpack.Gun') or C.StringFind(C.char,'Gun')
                    for num, theirChar in ipairs(CS:GetTagged("Character")) do -- loop through characters
                        if theirChar == C.char then
                            continue--don't try and oof yourself, won't end well.
                        end
                        while info.Enabled and select(2,C.isInGame(theirChar)) == "Murderer" do
                            if Gun.Parent ~= C.char then
                                C.human:EquipTool(Gun)
                            end
                            C.DoTeleport(theirChar:GetPivot() * CFrame.new(0,0,0.4)) -- Behind 2 studs
                            if not LastClick or os.clock() - LastClick > 2 then
                                if C.StringWait(Gun,"KnifeLocal.CreateBeam.RemoteFunction"):InvokeServer(1,theirChar:GetPivot().Position,"AH2") then
                                    break
                                end
                                LastClick = os.clock()
                            end
                            actionClone.Time.Text = `{theirChar.Name}`
                            RunService.RenderStepped:Wait()
                        end
                    end
                    C.human:UnequipTools()
                    C.RemoveAction(info.Name)
                    C.LoadPlayerCoords(self.Shortcut)
				end,
				Options = {
					
				}
			},
        }
    }
end