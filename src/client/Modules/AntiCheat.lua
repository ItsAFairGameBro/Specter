local function Static(C,Settings)
    local function yieldForeverFunct(...)
        C.DebugMessage("AntiCheat",debug.traceback('AntiCheat Disabled Successfully'))
        game:WaitForChild("SuckMyPp",math.huge)
        return true
    end
    return yieldForeverFunct
end
return function(C,Settings)
    local yieldForeverFunct = Static(C,Settings)
    -- Here's where the anti cheat stuff is done
    local AntiCheat = {
        {
            Run = function(self)
                local Old
                Old = C.hookfunction(C.getrenv().task.spawn, function(funct,...)
                    if funct == C.getrenv().xpcall then
                        return yieldForeverFunct()
                    end
                    return Old(funct,...)
                end)
                return true -- indicate that the anti cheat is successful
            end,
            KeepGoing = false, RunOnce = true,
            GameIds = {1069466626},
        }
    }
    for num, cheatTbl in ipairs(AntiCheat) do
        if table.find(cheatTbl.GameIds,game.GameId) then
            if not cheatTbl.RunOnce or not C.getgenv()["AntiCheat"..num] then
                C.DebugMessage("AntiCheat",`AntiCheat {num} Hooked`)
                cheatTbl.Run(cheatTbl)
                C.getgenv()["AntiCheat"..num] = true
            end
            if not cheatTbl.KeepGoing then
                break
            end
        end
    end
end