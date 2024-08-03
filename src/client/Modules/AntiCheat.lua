local function yieldForeverFunct(...)
    print(debug.traceback('poo poo pee pee'))
    game:WaitForChild("SuckMyPp",math.huge)
    return true
end
return function(C,Settings)
    --- METHOD TWO
    if game.GameId == 1069466626 then -- Pass the bomb
        local Old
        Old = C.hookfunction(C.getrenv().task.spawn, function(funct,...)
            if funct == C.getrenv().xpcall then
                return yieldForeverFunct()
            end
            return Old(funct,...)
        end)    
    end
end