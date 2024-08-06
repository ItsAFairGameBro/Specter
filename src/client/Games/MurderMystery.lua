local HttpService = game:GetService("HttpService")
local PS = game:GetService("Players")
local CS = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local function Static(C, Settings)
    local RoundTimerPart = workspace:WaitForChild("RoundTimerPart")
    function C.isInGame(theirChar)
		if theirChar and theirChar.Name == "InviClone" then
			theirChar = C.char
		end
		local player,human=PS:GetPlayerFromCharacter(theirChar), theirChar:FindFirstChild("Humanoid")
		if not player or not human or human.Health <=0 then
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
                    local info = {Name=self.Shortcut,Tags={"RemoveOnDestroy"}}
                    local actionClone = C.AddAction(info)
                    local Knife = C.StringFind(C.plr,'Backpack.Knife') or C.StringFind(C.char,'Knife')
                    for num, theirChar in ipairs(CS:GetTagged("Character")) do -- loop through characters
                        while info.Enabled do
                            local InGame = table.pack(C.isInGame(theirChar))
                            if not InGame[1] or not InGame[3] then
                                break
                            end
                            if Knife.Parent ~= C.char then
                                C.human:EquipTool(Knife)
                            end
                            C.DoTeleport(theirChar:GetPivot() * CFrame.new(0,0,2)) -- Behind 2 studs
                            Knife:WaitForChild("Stab"):FireServer("Slash")
                            actionClone.Time.Text = `{theirChar.Name}`
                            RunService.RenderStepped:Wait()
                        end
                    end
                    C.RemoveAction(info.Name)
				end,
				Options = {
					
				}
			},
        }
    }
end