-- Store the original remote functions
local originalFireServer = Instance.new("RemoteEvent").FireServer
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
