local DS = game:GetService("Debris")
local SC = game:GetService("ScriptContext")
local LS = game:GetService("LogService")
local function Static(C,Settings)
    local function yieldForeverFunct(...)
        C.DebugMessage("AntiCheat",debug.traceback('AntiCheat Disabled Successfully'))
        game:WaitForChild("SuckMyPp",math.huge)
        return true
    end
    return yieldForeverFunct
end
-- https://apis.roblox.com/universes/v1/places/1962086868/universe
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
            PlaceIds = {},
        },
        {
            Run = function(self)
                local Old
                Old = C.hookfunction(getrenv().game:GetService("ContentProvider").PreloadAsync, function(funct,...)
                    warn("Preloaded from",C.getcallingscript())
                    if not C.checkcaller() then
                        return yieldForeverFunct()
                    end
                    return Old(funct,...)
                end)
                return true -- indicate that the anti cheat is successful
            end,
            KeepGoing = false, RunOnce = true,
            GameIds = {},
            PlaceIds = {352947107},
        },
        {
            Run = function(self)
                local localScript1 = C.StringWait(C.plr,"PlayerScripts.LocalScript",30)
				local localScript2 = C.StringWait(C.plr,"PlayerScripts.LocalScript2",30)
				if not localScript1 or not localScript2 then
					return
				end
				for num, connection in ipairs(C.getconnections(localScript1.Changed)) do
					connection:Disconnect()
				end
				local oldParent = localScript1.Parent
				localScript1.Parent = nil
				localScript2.Parent = nil
				localScript1.Disabled = true
				DS:AddItem(localScript1,3)
				DS:AddItem(localScript2,3)
				localScript1 = Instance.new("LocalScript")
				localScript1.Parent = oldParent
				localScript2 = Instance.new("LocalScript")
				localScript2.Name = "LocalScript2"
				localScript2.Parent = oldParent

				Instance.new("Folder",localScript1).Name = "FakeDummy"
				Instance.new("Folder",localScript2).Name = "FakeDummy"
            end,
            KeepGoing = false, RunOnce = true,
            GameIds = {703124385},
            PlaceIds = {},
        },
        {
            Run = function(self)
                for num, data in ipairs(C.getconnections(SC.Error)) do
                    if data.LuaConnection then
                        data:Disconnect()
                        C.DebugMessage("AntiCheat",`Disabled SC.Error {num}`)
                    end
                end
                for num, data in ipairs(C.getconnections(LS.MessageOut)) do
                    if data.LuaConnection then
                        data:Disconnect()
                        C.DebugMessage("AntiCheat",`Disabled LS.MessageOut {num}`)
                    end
                end
            end,
            KeepGoing = true, RunOnce = true,
            GameIds = {3150475059},
            PlaceIds = {},
        },
        {
            Run = function(self)
                C.HookNamecall("AntiCheat5",{"fireserver","invokeserver"},function(theirScript,method,self,arg1,...)
                    if (not theirScript.Parent or theirScript.Name == "BAC_") and (typeof(arg1) ~= "table" or (arg1[1]~=arg1)) and arg1 ~= 0 then
                        if typeof(arg1) == "table" then
                            C.DebugMessage("AntiCheat",`CANCELLING ON: {theirScript:GetFullName()} because it tried sending method {self.Name} with table arg1 index 1={tostring(arg1[1])}`)
                        else
                            C.DebugMessage("AntiCheat",`CANCELLING ON: {theirScript:GetFullName()} because it tried sending method {self.Name} with arg1 {tostring(arg1)}`)
                        end
                        return "Cancel"
                    elseif theirScript.Name == "BAC_" then
                        print("Pass",self,arg1,...)
                        return
                    end
                end)
            end,
            KeepGoing = false, RunOnce = false,
            GameIds = {1160789089}, PlaceIds = {},
        },
    }
    for num, cheatTbl in ipairs(AntiCheat) do
        if table.find(cheatTbl.GameIds,game.GameId) or table.find(cheatTbl.PlaceIds,game.PlaceId) then
            if not cheatTbl.RunOnce or not C.getgenv()["AntiCheat"..num] then
                C.DebugMessage("AntiCheat",`Method {num} Activated`)
                cheatTbl.Run(cheatTbl)
                C.getgenv()["AntiCheat"..num] = true
            end
            if not cheatTbl.KeepGoing then
                break
            end
        end
    end
end