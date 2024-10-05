local DS = game:GetService("Debris")
local RunService = game:GetService("RunService")
local SC = game:GetService("ScriptContext")
local LS = game:GetService("LogService")
local RS = game:GetService("ReplicatedStorage")
local NC = game:GetService("NetworkClient")
local TeleportService = game:GetService("TeleportService")

local function Static(C,Settings)
    local function yieldForeverFunct(...)
        C.DebugMessage("AntiCheat",debug.traceback('AntiCheat Disabled Successfully'))
        game:WaitForChild("SuckMyPp",math.huge)
        return true
    end
    return yieldForeverFunct
end
local function ShouldBlock(name)
	local sc = getcallingscript()
	return sc and not sc.Parent and not checkcaller() and name ~= nil
end
-- https://apis.roblox.com/universes/v1/places/2961583129/universe
return function(C,Settings)
    local yieldForeverFunct = Static(C,Settings)
    -- Here's where the anti cheat stuff is done
    local AntiCheat = {
        {
            Run = function(self)
                local Old
                Old = hookfunction(C.getrenv().task.spawn, function(funct,...)
                    if funct == C.getrenv().xpcall then
                        return yieldForeverFunct()
                    elseif debug.traceback():find(".Core.Anti") then
                        print("Blocked Traceback!",debug.traceback())
                        return
                    end
                    return Old(funct,...)
                end)
                return true -- indicate that the anti cheat is successful
            end,
            KeepGoing = false, RunOnce = true,
            GameIds = {1069466626,495693931},
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
                --[[local NewMessage = C.StringWait(RS,"Events.AntiCheatRemotes.NewMessage")
                C.HookNamecall("AntiCheat5",{"fireserver","invokeserver"},function(theirScript,method,self,arg1,...)
                    if true then
                        return
                    end
                    if (not theirScript.Parent or theirScript.Name == "BAC_") and (typeof(arg1) ~= "table" and (arg1[1]~=arg1)) and arg1 ~= 0 then--(arg1[1]~=arg1)) then --and arg1 ~= 0 then
                        if typeof(arg1) == "table" then
                            --C.DebugMessage("AntiCheat",`CANCELLING ON: {theirScript:GetFullName()} because it tried sending method {self.Name} with table arg1 index 1={tostring(arg1[1])}`)
                        else
                            --C.DebugMessage("AntiCheat",`CANCELLING ON: {theirScript:GetFullName()} because it tried sending method {self.Name} with arg1 {tostring(arg1)}`)
                        end
                        return "Cancel"
                    elseif theirScript.Name == "BAC_" then
                        --for num, arg in ipairs(table.pack(arg1,...)) do
                        --    if arg~=0 then
                                --print("Pass",self,arg)
                         --   end
                        --end
                        
                        
                        if arg1 == 0 then
                            return -- Run it
                        else
                            local argCount = (arg1~=nil and 1 or 0) + #({...})
                            print("CANCELLING TWO WITH ",method,self,"argcount:",argCount,"arg1:",arg1[1])
                            
                            task.defer(NewMessage.FireServer,NewMessage,"A-1","RSSERV MTHD")
                        end
                        return "Cancel"
                    end
                end)--]]

                C.HookMethod(C.getrenv().task.spawn,"AntiCheat5", C.newcclosure(function(theirScript,method,funct,...)
                    local Args = table.pack(...)
                    if not theirScript.Parent or theirScript.Name == "BAC_" then
                        task.spawn(C.DebugMessage,"AntiCheat",`TASK SPAWN YIELD ON SCR: {theirScript:GetFullName()}!`)
                        return "Yield"
                    end
                end))
                C.HookMethod("__namecall","AntiCheat5",C.newcclosure(function(theirScript,method,self,...)
                    local MySelf = tostring(self)
                    if (MySelf == "RemoteEvent" or MySelf == "NewMessage") then
                        task.spawn(C.DebugMessage,"AntiCheat",`YIELDING NAMECALL FOR SCR: {theirScript:GetFullName()} ATTEMPT: {self:GetFullName()}`)
                        return "Yield"
                    end
                end),{"fireserver"})
                C.HookMethod("__index","AntiCheat5",C.newcclosure(function(theirScript,index,self,...)
                    local MySelf = tostring(self)
                    if (MySelf == "RemoteEvent" or MySelf == "NewMessage") then
                        task.spawn(C.DebugMessage,"AntiCheat",`YIELDING INDEXCALL: {theirScript:GetFullName()} ATTEMPT: {self:GetFullName()} INDEX: {index}`)
                        return "Yield"
                    end
                end),{"fireserver"})
                -- DISABLE TELEPORT
                --[[C.AddGlobalThread(task.spawn(function()
                    while true do
                        local success, result = pcall(TeleportService.Teleport,TeleportService,0,C.plr)
                        if result ~= "Cannot teleport to invalid place id. Aborting teleport." then
                            warn("TELEPORTING NOTICED. CANCEL ATTEMPT!")
                            TeleportService:TeleportCancel()
                        end
                        RunService.RenderStepped:Wait()
                    end
                end))--]]
            end,
            KeepGoing = false, RunOnce = false,
            GameIds = {1160789089},PlaceIds={}
        },
        {
            Run = function(self)
                --[[local Old
                Old = hookfunction(getrenv().pcall, C.newcclosure(function(self,...)
                    local Returns = {Old(self,...)}
                    print(self,debug.traceback(),Returns)
                    return table.unpack(Returns)
                end))

                local Old = getrenv().pcall
                getrenv().pcall = C.newcclosure(function(self,...)
                    local Returns = {Old(self,...)}
                    print(self,...,Returns)
                    return table.unpack(Returns)
                end)
                local Old
                Old = hookfunction(debug.info, C.newcclosure(function(self,...)
                    local Returns = {Old(self,...)}
                    print("info",self,...,Returns)
                    return table.unpack(Returns)
                end))
                local Old2
                Old2 = hookfunction(debug.traceback, C.newcclosure(function(self,...)
                    local Returns = {Old2(self,...)}
                    print("traceback",self,...,Returns)
                    return table.unpack(Returns)
                end))--]]
                local Old2
                Old2 = hookfunction(getrenv().pcall, function(...)
                    if ShouldBlock(pcall) then
                        C.DebugMessage("AntiCheat","Killed a pcall script: "..tostring(getcallingscript()))
                        while true do
                            task.wait(9999999999)
                        end
                        return
                    end
                    return Old2(...)
                end)

                local Old3
                Old3 = hookfunction(getrenv().ipairs,function(...)
                    if ShouldBlock(ipairs) then
                        C.DebugMessage("AntiCheat","Killed a ipairs script: "..tostring(getcallingscript()))
                        while true do
                            task.wait(9999999999)
                        end
                        return
                    end
                    return Old3(...)
                end)

                local Old4
                Old4 = hookmetamethod(game,"__namecall",function(...)
                    if ShouldBlock(game) then
                        C.DebugMessage("AntiCheat","Killed a __namecall script: "..tostring(getcallingscript()))
                        while true do
                            task.wait(9999999999)
                        end
                        return
                    end
                    return Old4(...)
                end)
            end,
            KeepGoing = false, RunOnce = true,
            GameIds = {3734304510},PlaceIds={},
        },
        {
            Run = function(self)
                local DataService = require(game:GetService("ReplicatedStorage").Modules.DataService)
                local remotefunc
                local hashtable = getupvalue(getupvalue(DataService.InvokeServer, 5),3)
                local remoteNames, remoteObjects = {}, {}
                for i,v in pairs(getreg()) do
                    if type(v) == "function" and getinfo(v).name == "remoteAdded" then
                        remotefunc = v
                    end
                end
                for i,v in pairs(getupvalue(getupvalue(remotefunc,2),1)) do
                    remoteNames[hashtable[i]] = v:gsub("F_", "") --some remotes start with F_ cuz gay
                    remoteObjects[v:gsub("F_","")] = hashtable[i]
                end
                C.RemoteNames = remoteNames
                C.RemoteObjects = remoteObjects
            end,
            KeepGoing = false, RunOnce = false, IgnoreKick = true,
            GameIds = {88070565},PlaceIds={},
        },
    }
    local GameDisconnected = not NC:FindFirstChildWhichIsA("ClientReplicator")
    for num, cheatTbl in ipairs(AntiCheat) do
        if table.find(cheatTbl.GameIds,game.GameId) or table.find(cheatTbl.PlaceIds,game.PlaceId) then
            if GameDisconnected and not cheatTbl.IgnoreKick then
                C.DebugMessage("AntiCheat",`AntiCheat Method {num} Not Running Because Of Game Disconnect!`)
                continue
            end
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