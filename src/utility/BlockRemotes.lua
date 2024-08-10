-- Store the original remote functions
--[[local originalFireServer = Instance.new("RemoteEvent").FireServer
local originalInvokeServer = Instance.new("RemoteFunction").InvokeServer

local function yieldForeverFunct()
    game:WaitForChild("PeePeePooPoo")
end

-- Hook the functions to block remotes
hookfunction(originalFireServer, function(...)
    -- If the caller is not from the local script, block the request
    if not checkcaller() then
        warn("RemoteFunction:FireServer: "..getcallingscript():GetFullName().." with args:",...)
        return yieldForeverFunct()
    end

    -- If it's from a local script, call the original function
    return originalFireServer(...)
end)

hookfunction(originalInvokeServer, function(...)
    -- If the caller is not from the local script, block the request
    if not checkcaller() then
        warn("RemoteFunction:InvokeServer: "..getcallingscript():GetFullName().." with args:",...)
        return yieldForeverFunct()
    end

    -- If it's from a local script, call the original function
    return originalInvokeServer(...)
end)

-- Notify that the protection is active
print("Remote blocking is active.")
--]]

-- Store the original namecall method
local originalNamecall = nil

-- Hook the namecall function
originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    -- Check if the caller is not a local script
    if not checkcaller() or true then
        -- Get the method being called
        local method = getnamecallmethod()

        -- Block FireServer or InvokeServer methods
        if method == "FireServer" or method == "InvokeServer" then
            warn(`Blocked a remote call attempt from an external script: {getcallingscript()}. Args:`,...)
            return -- Prevent the remote call from being executed
        end
    end

    -- If the caller is a local script, call the original namecall method
    return originalNamecall(self, ...)
end)

-- Notify that the protection is active
print("Namecall hook to block remote calls is active.")