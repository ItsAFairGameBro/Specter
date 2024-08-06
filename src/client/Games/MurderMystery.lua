local PS = game:GetService("Players")
local function Static(C, Settings)
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

end
return function(C,Settings)
    
end