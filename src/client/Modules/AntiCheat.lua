local function yieldForeverFunct(...)
    print(debug.traceback('AntiCheat Disabled Successfully'))
    game:WaitForChild("SuckMyPp",math.huge)
    return true
end
return function(C,Settings)
    -- Here's where the anti cheat stuff is done
    if game.GameId == 1069466626 and not C.getgenv().AntiCheat1 then -- Pass the bomb
        local Old
        Old = C.hookfunction(C.getrenv().task.spawn, function(funct,...)
            if funct == C.getrenv().xpcall then
                return yieldForeverFunct()
            end
            return Old(funct,...)
        end)
        C.getgenv().AntiCheat1 = true -- Mark it as finisheds
    end
end