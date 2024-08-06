local PS = game:GetService("Players")
local function Static(C, Settings)
    local RoundTimerPart = workspace:WaitForChild("RoundTimerPart")
    function C.isInGame(theirChar)
		if theirChar and theirChar.Name == "InviClone" then
			theirChar = C.char
		end
		local player=PS:GetPlayerFromCharacter(theirChar)
		if not player then
			return false, "Lobby", false--No player, no team!
		end
        local defactoInGame = (theirChar:GetPivot().Position - RoundTimerPart.Position).Magnitude > 150
        local realInGame = player:GetAttribute("Alive")
        local hasGun = theirChar:FindFirstChild("Gun") or C.StringFind(player,"Backpack.Gun",0)
        local hasKnife = theirChar:FindFirstChild("Knife") or C.StringFind(player,"Backpack.Knife",0)

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
            
        }
    }
end