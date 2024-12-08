--[[
    Save Instance
    -> Saves the current game to file
    -> Documentation: https://luau.github.io/UniversalSynSaveInstance/api/SynSaveInstance/
    -> License: https://github.com/luau/UniversalSynSaveInstance/blob/main/LICENSE
--]]
return {
    Name = "Save Instance",
    synsaveinstance = nil,
    AllowMultiRun = true,
    ScriptRun = function(self, args, C, Settings)
        local Params = {
            RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
            SSI = "saveinstance",
        }
        if not self.synsaveinstance then
            self.synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
        end
        local Options = {
            FilePath = args[1],
            RemovePlayerCharacters = false,
            AntiIdle = true,
            Anonymous = true,
            timeout = 10,
        } -- Documentation here https://luau.github.io/UniversalSynSaveInstance/api/SynSaveInstance
        self.synsaveinstance(Options)
    end
}