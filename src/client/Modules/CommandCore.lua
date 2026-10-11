local HttpService = game:GetService("HttpService")
local PS = game:GetService("Players")
return function(C,Settings)
    C.savedCommands = C.getgenv().lastCommands
    if not C.savedCommands then
        C.savedCommands = {}
        C.getgenv().lastCommands = C.savedCommands
    end
    local CommandInput = C.LoadModule("Modules/CommandInput")
    local function PerformRootSearch(Root)
        local tbl = {}
        for _, instance in ipairs(Root:GetDescendants()) do
            if instance:IsA("Animation") then
                table.insert(tbl,{instance.Name, instance.Name})
            end
        end
        return tbl
    end
    function C.RunCommand(inputMsg,shouldSave,noRefresh,canYield)
        if shouldSave then
            table.insert(C.savedCommands,1,inputMsg)
            if #C.savedCommands > 10 then
                table.remove(C.savedCommands,#C.savedCommands)
            end
        end

        local args, _, parseError = CommandInput.Parse(inputMsg)
        if parseError then C.CreateSysMessage(parseError) return end
        local inputCommand = table.remove(args, 1) or ""
        if inputCommand == "" then return end
        for index = 1, 3 do args[index] = args[index] or "" end
        args.OrgArgs = table.clone(args)
        local command, CommandData, resolveError = CommandInput.Resolve(C.CommandFunctions, inputCommand)
        if resolveError then
            C.CreateSysMessage(`Ambiguous command: {inputCommand}. Choose a suggestion or type the full name.`)
            return
        end
        if CommandData then
            if CommandData.RequiresRefresh and noRefresh then
                return
            end
            local canRunFunction = true
            for num, argumentData in ipairs(CommandData.Parameters) do
                args[num] = args[num] or ""
                if argumentData.Type=="Players" or argumentData.Type=="Player" then
                    local plrList = argumentData.AllowFriends and PS:GetPlayers() or C.GetNonFriends(true)
                    if args[num]=="all" then
                        args[num] = plrList
                    elseif args[num] == "others" then
                        args[num] = plrList
                        C.TblRemove(args[num],C.plr)
                        if #args[num]==0 then
                            canRunFunction = false
                            C.CreateSysMessage(`No other players found`)
                        end
                    elseif args[num] == "me" or args[num] == "" then
                        args[num] = {C.plr}
                    elseif args[num] == "random" then
                        if #plrList == 0 then
                            canRunFunction = false
                            C.CreateSysMessage("No eligible players found")
                        else
                            args[num] = {plrList[Random.new():NextInteger(1,#plrList)]}
                        end
                    elseif args[num] == "new" then
                        if not argumentData.SupportsNew then
                            canRunFunction = false
                            C.CreateSysMessage(`{command} doesn't support "new" players`)
                        end
                        args[num] = "new"
                    else
                        local ChosenPlr = select(2,table.unpack(C.StringStartsWith(PS:GetPlayers(),args[num])[1] or {}))
                        if ChosenPlr then
                            args[num] = {ChosenPlr}
                        else
                            canRunFunction = false
                            C.CreateSysMessage(`Player(s) Not Found: {command}; allowed: all, others, me, <plrName>`)
                        end
                    end
                    if canRunFunction and argumentData.Type=="Player" and typeof(args[num]) == "table" and #args[num]>1 then
                        canRunFunction = false
                        C.CreateSysMessage(`{command} only supports a single player`)
                    elseif canRunFunction and typeof(args[num]) == "table" and args[num][1] == C.plr and argumentData.ExcludeMe then
                        canRunFunction = false
                        C.CreateSysMessage(`{command} doesn't support applying this command to yourself. Please choose another player`)
                    end
                elseif argumentData.Type=="Number" then
                    if args[num] ~= "" then
                        args[num] = tonumber(args[num])
                        if canRunFunction and not args[num] then
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows Number`)
                        elseif canRunFunction and (args[num] < argumentData.Min or args[num] > argumentData.Max) then
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows numbers between {argumentData.Min} to {argumentData.Max}`)
                            elseif canRunFunction and (argumentData.Step and math.floor(args[num]/argumentData.Step)*argumentData.Step~=args[num]) then
                                canRunFunction = false
                                C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows numbers to the precision of {argumentData.Step}, such as {argumentData.Step + argumentData.Min}`)
                        end
                    elseif argumentData.Default then
                        args[num] = argumentData.Default
                    end
                elseif argumentData.Type == "Instance" then
                    local Root = C[argumentData.Root]
                    assert(Root,`{args[num]} root not found: {argumentData.Root}`)
                    local ChosenOption = args[num] ~= "" and C.StringStartsWith(PerformRootSearch(Root),args[num], true)[1]
                    if not ChosenOption and canRunFunction then
                        if args[num] == "" and (argumentData.Default or argumentData.Optional) then
                            args[num] = argumentData.Default or nil
                        else
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Options: {args[num]} is not optional`)
                        end
                    elseif canRunFunction then
                        local instance = C[argumentData.Root]
                        if not instance then
                            C.CreateSysMessage(`Invalid Parameter Options: Instance root {argumentData.Root} not found`)
                            canRunFunction = false
                        else
                            instance = instance:FindFirstChild(ChosenOption[2][1], true)
                            if not instance then
                                C.CreateSysMessage(`Invalid Parameter Options: Animation {ChosenOption[2][1]} not found!`)
                                canRunFunction = false
                            else
                                args[num] = instance
                            end
                        end
                    end
                elseif argumentData.Type == "Options" then
                    local Options = argumentData.Options
                    local ChosenOption = args[num] ~= "" and C.StringStartsWith(Options,args[num])[1]
                    if not ChosenOption and canRunFunction then
                        if args[num] == "" and (argumentData.Default or argumentData.Optional) then
                            args[num] = argumentData.Default or nil
                        else
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Options: {args[num]} is not optional`)
                        end
                    elseif ChosenOption then
                        args[num] = ChosenOption[2]
                    end
                elseif argumentData.Type == "Friend" then
                    if args[num] == "" then
                        args[num] = ""
                    else
                        local BigRet = C.StringStartsWith(C.friendnames, args[num], true)
                        local Ret = BigRet[#BigRet]
                        if Ret then
                            args[num] = {UserId=C.friendnamestoids[Ret[2]], UserName= Ret[2]}
                        else
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows valid friends. No matching username/userid found for {tostring(args[num])}`)
                        end
                    end
                elseif argumentData.Type=="User" then
                    local success, name, id = C.GetUserNameAndId(args[num])
                    if success then
                        args[num] = {name, id}
                    else
                        canRunFunction = false
                        C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows valid users. No matching username/userid found for {args[num]}`)
                    end
                elseif argumentData.Type == "String" then
                    local min = argumentData.Min or 1
                    local max = argumentData.Max or 1000
                    if (args[num]:len() < min or args[num]:len() > max) then
                        if argumentData.Optional then
                            args[num] = false
                        else
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Number: {command}; only allows text with length between {min} and {max}!`)
                        end
                    end
                elseif argumentData.Type=="" or argumentData.Type == "Outfit" then
                    --do nothing
                elseif argumentData.Type~=false then
                    canRunFunction = false
                    C.CreateSysMessage(`Internal Error: Command Parameter Implemented But Not Supported: {command}, {tostring(argumentData.Type)}`)
                end
            end
            local ChosenPlr = args[1]
            if canRunFunction then
                local function yieldFunction()
                    local returns = table.pack(C.CommandFunctions[command]:Run(args))
                    local wasSuccess = returns[1]
                    table.remove(returns,1)
                    local displayNameCommand = command:sub(1,1):upper() .. command:sub(2)
                    if wasSuccess == true then
                        local Length = typeof(ChosenPlr)=="table" and #ChosenPlr
                        local playersAffected = Length and (Length>1 and Length .. " Players" or tostring(ChosenPlr[1]))
                            --(typeof(ChosenPlr)=="Instance" and (ChosenPlr==C.plr and ChosenPlr.Name) or ChosenPlr.Name)
                           -- or (ChosenPlr:sub(1,1):upper() ..
                            --    ChosenPlr:sub(2,ChosenPlr:sub(ChosenPlr:len())=="s" and ChosenPlr:len()-1 or ChosenPlr:len()))
                        if playersAffected == C.plr.Name then
                            playersAffected = "you"
                        elseif not playersAffected or playersAffected == "nil" then
                            playersAffected = ""
                        end
                        returns[1] = returns[1] or ""
                        C.CreateSysMessage(`{displayNameCommand}ed {(playersAffected)}{(CommandData.AfterTxt or ""):format(table.unpack(returns)):gsub("  "," ")}`,
                            Color3.fromRGB(255,255,255))
                    else
                        C.CreateSysMessage(
                            `{displayNameCommand} Error: {returns[1] or `unknown RET for {displayNameCommand}`}`,
                            Color3.fromRGB(255))
                    end
                end
                if canYield then
                    yieldFunction()
                else
                    task.spawn(yieldFunction)
                end
            end

        elseif inputCommand~="c" and inputCommand~="whisper" and inputCommand~="mute" and inputCommand~="block" and inputCommand~="unblock"
            and inputCommand~="unmute" and inputCommand~="e" then
            C.CreateSysMessage(`Command Not Found: {inputCommand}`)
        end
    end
    -- TEMP: Add Scripts in there
    local Scripts2Add = {"Dark Dex", "Chat Bypass", "Save Instance"}
    for num, scriptName in ipairs(Scripts2Add) do
        local FormattedName = scriptName:gsub("%s+","")
        local EncodedScriptName = HttpService:UrlEncode(scriptName)
        assert(not C.CommandFunctions[FormattedName], `[CommandCore]: C.CommandFunctions already has command "{FormattedName}"`)
        C.CommandFunctions[FormattedName] = {
            Parameters={},
            AfterTxt = "%s",
            Run = function(self, args)
                local CurrentModule = C.LoadModule("Scripts/"..EncodedScriptName)
                if C.getgenv().AlreadyRanScripts[scriptName] and not CurrentModule.AllowMultiRun then
                    return false, "Already Ran " .. scriptName
                end
                C.getgenv().AlreadyRanScripts[scriptName] = true
                CurrentModule.ScriptRun(CurrentModule, args, C, Settings)
                return true, "Ran"
            end,
        }
    end
    for num, commandFunct in ipairs(C.InsertCommandFunctions) do
        if commandFunct then
            for name, commandData in pairs(commandFunct()) do
                if not commandData then
                    continue
                end
                assert(not C.CommandFunctions[name], `[CommandCore]: C.CommandFunctions already has command "{name}"`)
                assert(commandData.Parameters, `[CommandCore]: {name} doesn't have .Paramters`)
                assert(commandData.Run, `[CommandCore]: {name} doesn't have .Run`)
                C.CommandFunctions[name] = commandData
            end
        end
    end
    C.InsertCommandFunctions = nil
    for shortcut, commandTbl in pairs(table.clone(C.CommandFunctions or {})) do
        assert(commandTbl, `CommandTbl must exist or be nil: {commandTbl}`)
        commandTbl.Shortcut = shortcut
        commandTbl.Parent = C.CommandFunctions
        for _, aliasName in ipairs(commandTbl.Alias or {}) do
            if C.CommandFunctions[aliasName] then
                error(`[CommandCore]: Duplicate AliasName: {aliasName} from the command {shortcut}: {warn(C.CommandFunctions[aliasName])}`)
            end
            C.CommandFunctions[aliasName] = commandTbl
        end
        C.BindEvents(commandTbl)
    end
    C.LoadModule("Modules/CommandPalette")
end
