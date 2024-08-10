local TheRemoteEvent = game:GetService("ReplicatedStorage"):FindFirstChildWhichIsA("RemoteEvent",true)

local function yieldForeverFunct()
    print("Yielding Forever Funct!")
    game:WaitForChild("PeePeePooPoo",math.huge)
end

--[[
-- Store the original remote functions
local originalFireServer = TheRemoteEvent.FireServer
local originalInvokeServer = Instance.new("RemoteFunction").InvokeServer



-- Hook the functions to block remotes
hookfunction(originalFireServer, function(...)
    print("FIRED")
    -- If the caller is not from the local script, block the request
    if not checkcaller() or true then
        warn("RemoteFunction:FireServer: "..getcallingscript():GetFullName().." with args:",...)
        return yieldForeverFunct()
    end

    -- If it's from a local script, call the original function
    return originalFireServer(...)
end)

hookfunction(originalInvokeServer, function(...)
    -- If the caller is not from the local script, block the request
    if not checkcaller() or true then
        warn("RemoteFunction:InvokeServer: "..getcallingscript():GetFullName().." with args:",...)
        return yieldForeverFunct()
    end

    -- If it's from a local script, call the original function
    return originalInvokeServer(...)
end)

-- Notify that the protection is active
--]]

-- Store the original namecall method
local originalNamecall = nil
local getgenv = getgenv

local function HookNamecall(name,methods,runFunct)
    if not getgenv().NamecallHooks then
        getgenv().NamecallHooks = {}
        -- Hook the namecall function
        local getcallingscript,getnamecallmethod,lower,tblFind,tblPack,tblUnpack = getcallingscript,getnamecallmethod,string.lower,table.find,table.pack,table.unpack
        originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            -- Check if the caller is not a local script
            if not checkcaller() and self.Name ~= "CharacterSoundEvent" then
                -- Get the method being called
                local method = lower(getnamecallmethod())
                local theirScript = getcallingscript()
                -- Block FireServer or InvokeServer methods
                for name, list in pairs(getgenv().NamecallHooks) do
                    if tblFind(list[2],method) then -- Authorization
                        local operation,returnData = runFunct(theirScript,method,self,...)
                        if operation then
                            if operation == "Override" then
                                print("Overridden")
                                return tblUnpack(returnData)
                            elseif operation == "Cancel" then
                                print("Cancelled!")
                                return
                            elseif operation == "Yield" then
                                return yieldForeverFunct()
                            else
                                warn(`[C.HookNameCall]: Unknown Operation for {name}: {operation}`)
                            end
                        end
                        
                        warn(`Blocked a {method} from {self.Name}: {theirScript}. Args:`,...)
                    end
                end
            end

            -- If the caller is a local script, call the original namecall method
            return originalNamecall(self, ...)
        end)--]]
    end
    if runFunct or #methods==0 then
        getgenv().NamecallHooks[name] = {runFunct,methods}
    else
        getgenv().NamecallHooks[name] = nil
    end
end

HookNamecall("AntiRemotes",{"fireserver","invokeserver"},function(theirScript,method,self,...)
    return "Cancel"
end)
-- Notify that the protection is active
print("✅✅Namecall hook to block remote calls is active.")
--task.wait(1)
--print("Activating Test Call",TheRemoteEvent)
--task.wait(1)
TheRemoteEvent:FireServer("Hi Bob")


--task.cancel(getconnections(game.LogService.MessageOut)[2].Thread)

--[[


for num, part in ipairs(workspace:GetDescendants()) do if part:IsA("BasePart") then part.CanQuery = false end end

]]