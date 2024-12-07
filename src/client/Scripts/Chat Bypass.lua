--[[
    Chat Bypasser
    -> Bypasses the chat with prefixed phrases AND allows for easy chats
    -> Only excutes once
    -> Glitches Specter V2 commands
--]]
return {
    Name = "Chat Bypass",
    ScriptRun = function()
        task.spawn(loadstring(game:HttpGet("https://raw.githubusercontent.com/1price/usercreation/main/UserCreation.lua")))
    end
}