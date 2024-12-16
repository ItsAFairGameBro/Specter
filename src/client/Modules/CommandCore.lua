local HttpService = game:GetService("HttpService")
local PS = game:GetService("Players")
local TCS = game:GetService("TextChatService")
local RunS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local GS = game:GetService("GuiService")
local CS = game:GetService("Chat")
local OverrideChatGames = {
    66654135 -- MM2
}
return function(C,Settings)
    C.savedCommands = C.getgenv().lastCommands
    if not C.savedCommands then
        C.savedCommands = {}
        C.getgenv().lastCommands = C.savedCommands
    end
    function C.RunCommand(inputMsg,shouldSave,noRefresh,canYield)
        if shouldSave then
            table.insert(C.savedCommands,1,inputMsg)
            if #C.savedCommands > 10 then
                table.remove(C.savedCommands,#C.savedCommands)
            end
        end

        local args = inputMsg:sub(2):split(" ")
        local inputCommand = args[1]
        table.remove(args,1)
        for index = 1, 3, 1 do
            args[index] = args[index] or "" -- leave them be empty so it doesn't confuse the game!
        end
        args.OrgArgs = table.clone(args)
        local command, CommandData = table.unpack(C.StringStartsWith(C.CommandFunctions,inputCommand)[1] or {})
        if CommandData then
            if CommandData.RequiresRefresh and noRefresh then
                return
            end
            local canRunFunction = true
            for num, argumentData in ipairs(CommandData.Parameters) do
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
                        args[num] = {plrList[Random.new():NextInteger(1,#plrList)]}
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
                    if canRunFunction and argumentData.Type=="Player" and #args[num]>1 then
                        canRunFunction = false
                        C.CreateSysMessage(`{command} only supports a single player`)
                    elseif canRunFunction and args[num][1] == C.plr and argumentData.ExcludeMe then
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
                elseif argumentData.Type == "Options" then
                    local Options = argumentData.Options
                    local ChosenOption = C.StringStartsWith(Options,args[num])[1]
                    if not ChosenOption and canRunFunction then
                        if args[num] == "" and (argumentData.Default or argumentData.Optional) then
                            args[num] = argumentData.Default or nil
                        else
                            canRunFunction = false
                            C.CreateSysMessage(`Invalid Parameter Options: {args[num]} is not valid option`)
                        end
                    else
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
                elseif argumentData.Type=="" then
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
    -- Chatbar Connection
    --MY PLAYER CHAT
    local chatBar
    local isFocused
    local index = 0
    local hasNewChat = TCS.ChatVersion == Enum.ChatVersion.TextChatService

    local function registerNewChatBar(_,firstRun)
        local sendButton = hasNewChat and C.StringWait(CG,"ExperienceChat.appLayout.chatInputBar.Background.Container.SendButton")
        chatBar = C.StringWait(not hasNewChat and C.PlayerGui or CG,not hasNewChat and
            "Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar" or "ExperienceChat.appLayout.chatInputBar.Background.Container.TextContainer.TextBoxContainer.TextBox")

        local sendTheMessage
        if hasNewChat then
            sendButton.Visible = false
            local mySendButton = sendButton:Clone()
            mySendButton.Parent = sendButton.Parent
            mySendButton.Visible = true
            mySendButton.Name = "MySendButton"
            C.AddGlobalInstance(mySendButton)
            sendTheMessage = function(message,dontSetTB)
                message = typeof(message)=="string" and message or chatBar.Text
                if message == "" then
                    return
                end
                local channels = TCS:WaitForChild("TextChannels")
                local myChannel = channels:FindFirstChild("RBXGeneral") or channels:FindFirstChild("General")
                assert(myChannel, "General chat channel not found!")
                local targetChannelTB = chatBar.Parent.Parent.TargetChannelChip
                if targetChannelTB.Visible then
                    local theirUser = targetChannelTB.Text:sub(5,targetChannelTB.Text:len()-1)
                    local theirPlr
                    for num, thisPlr in ipairs(PS:GetPlayers()) do
                        if thisPlr.Name == theirUser or thisPlr.DisplayName == theirUser then
                            if theirPlr then
                                warn(`(SendMessage) DUPLICATE Players Found For Display Name "{theirUser}"`)
                            end
                            theirPlr = thisPlr
                        end
                    end
                    if theirPlr then
                        myChannel = channels:FindFirstChild("RBXWhisper:"..C.plr.UserId.."_"..theirPlr.UserId) or channels:FindFirstChild("RBXWhisper:"..theirPlr.UserId.."_"..C.plr.UserId)
                        if not myChannel then
                            return warn(`(SendMessage) Could Not Find MyChannel {"RBXWhisper:"..C.plr.UserId.."_"..theirPlr.UserId} or {"RBXWhisper:"..theirPlr.UserId.."_"..C.plr.UserId}`)
                        end
                    else
                        return warn(`(SendMessage) Could Not Find Private Message User {theirUser} from "{targetChannelTB.Text}"`)
                    end
                end
                myChannel:SendAsync(message)
                if dontSetTB~=false then
                    chatBar.Text = ""
                end
            end
            mySendButton.MouseButton1Up:Connect(sendTheMessage)
            mySendButton.Destroying:Connect(function()
                if sendButton then
                    sendButton.Visible = true
                end
            end)
        end
        local connectionsFuncts = {}
        for num, connection in ipairs(C.getconnections(chatBar.FocusLost)) do
            connection:Disable()
            table.insert(connectionsFuncts,connection)
        end
        local lastText
        local lastUpd = -5
        if C.Cleared then
            return
        end
        local ChatAutoCompleteFrame = C.UI.ChatAutoComplete
        local DidSet = 0
        local Connections = {}
        local frameList, currentIndex = {}, 1
        local LastPreferred
        local function ClearSuggestions()
            if frameList[currentIndex] then
                LastPreferred = frameList[currentIndex].Name
            end
            C.ClearChildren(ChatAutoCompleteFrame)
            frameList, currentIndex = {}, 1
        end
		local function goToSaved(deltaIndex)
			index += deltaIndex
            lastUpd = os.clock()
            index = math.clamp(index,0,#C.savedCommands+1)

            local setTo = C.savedCommands[index] or ""
            local setCursor = chatBar.CursorPosition
            lastText = setTo
            RunS.RenderStepped:Wait()
            DidSet += 0
            chatBar.CursorPosition = setCursor
			chatBar.Text = setTo
            ClearSuggestions()
			chatBar.CursorPosition = setTo:len() + 1
        end
        local function HighlightLayout(num)
            currentIndex = math.clamp(num, math.min(#frameList,1), #frameList)

            for num2, frameButton in ipairs(frameList) do
                local selected = frameButton.LayoutOrder == currentIndex
                frameButton.BackgroundColor3 = selected and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

                if selected then
                    -- Get the position of the frameButton relative to the ChatAutoCompleteFrame
                    local objectTop = frameButton.AbsolutePosition.Y
                    local objectBottom = objectTop + frameButton.AbsoluteSize.Y
                    local canvasPosition = ChatAutoCompleteFrame.CanvasPosition.Y
                    local windowBottom = ChatAutoCompleteFrame.AbsolutePosition.Y + ChatAutoCompleteFrame.AbsoluteSize.Y

                    -- Check if the object is above the current view
                    if objectTop < ChatAutoCompleteFrame.AbsolutePosition.Y then
                        ChatAutoCompleteFrame.CanvasPosition =
                            Vector2.new(ChatAutoCompleteFrame.CanvasPosition.X, ChatAutoCompleteFrame.CanvasPosition.Y - (ChatAutoCompleteFrame.AbsolutePosition.Y - objectTop))
                    -- Check if the object is below the current view
                    elseif objectBottom > windowBottom then
                        ChatAutoCompleteFrame.CanvasPosition =
                            Vector2.new(ChatAutoCompleteFrame.CanvasPosition.X, ChatAutoCompleteFrame.CanvasPosition.Y + (objectBottom - windowBottom))
                    end
                end
            end
        end
        local Words,CurrentWordIndex
        local function ChatBarUpdated()
            if C.Cleared then
                return
            end
            local Inset = GS:GetGuiInset().Y
            isFocused = chatBar:IsFocused()
            ChatAutoCompleteFrame.Visible = isFocused
            ChatAutoCompleteFrame.Position = UDim2.fromOffset(chatBar.Parent.AbsolutePosition.X,chatBar.Parent.AbsolutePosition.Y+chatBar.Parent.AbsoluteSize.Y+Inset)
            ChatAutoCompleteFrame.Size = UDim2.fromOffset(chatBar.AbsoluteSize.X,C.GUI.AbsoluteSize.Y - ChatAutoCompleteFrame.AbsolutePosition.Y - Inset)
            if isFocused then
                local Deb = 0
                local ConnectedFunct
                function ConnectedFunct(inputObject, gameProcessed, noLoop)
                    local doContinue = false
                    if #frameList > 0 then
                        if inputObject.KeyCode == Enum.KeyCode.Up or inputObject.KeyCode == Enum.KeyCode.Insert then
                            HighlightLayout(currentIndex - 1)
                        elseif inputObject.KeyCode == Enum.KeyCode.Down or inputObject.KeyCode == Enum.KeyCode.Delete then
                            HighlightLayout(currentIndex + 1)
                        elseif inputObject.KeyCode == Enum.KeyCode.Tab then
                            local orgName = frameList[currentIndex].Name
                            --RunS.RenderStepped:Wait()
                            Words[math.max(1,CurrentWordIndex)] = orgName
                            Words[1] = chatBar.Text:sub(1,1) .. Words[1]
                            chatBar.Text = table.concat(Words, " ")
                            chatBar.CursorPosition = chatBar.Text:len() + 1
                        else
                            doContinue = true
                            noLoop = true
                        end
                    else
                        doContinue = true
                    end
                    if doContinue then
                        if inputObject.KeyCode == Enum.KeyCode.Up or inputObject.KeyCode == Enum.KeyCode.PageUp then
                            goToSaved(1)
                        elseif inputObject.KeyCode == Enum.KeyCode.Down or inputObject.KeyCode == Enum.KeyCode.PageDown then
                            goToSaved(-1)
                        else
                            return
                        end
                        noLoop = true -- don't loop
                    end
                    if noLoop then
                        return
                    end
                    Deb+= 1 local saveDeb = Deb
                    local accelerationFactor = 0.075 -- The rate at which the function speed increases
                    local minWaitTime = 0.015 -- Minimum wait time between function calls

                    task.wait(.4)
                    local startTime = os.clock() - 1 -- Capture the start time

                    while UIS:IsKeyDown(inputObject.KeyCode) and Deb == saveDeb do
                        local elapsedTime = os.clock() - startTime -- Calculate how long the key has been held
                        local waitTime = math.max(minWaitTime, accelerationFactor / elapsedTime) -- Compute the wait time with acceleration

                        ConnectedFunct(inputObject, gameProcessed, true)
                        task.wait(waitTime)
                    end
                end
                local function InputEnded(inputObject,gameProcessed)
                    if not gameProcessed then
                        return
                    end
                    if inputObject.KeyCode == Enum.KeyCode.PageDown or inputObject.KeyCode == Enum.KeyCode.PageUp then
                        chatBar.CursorPosition = chatBar.Text:len() + 1
                    end
                end
                local Conn1 = C.AddGlobalConnection(UIS.InputBegan:Connect(ConnectedFunct))
                local Conn2 = C.AddGlobalConnection(UIS.InputEnded:Connect(InputEnded))
                table.insert(Connections,Conn1)
                table.insert(Connections,Conn2)
                HighlightLayout(currentIndex) -- Make sure it's visible!
            elseif Connections then
                for num, conn in ipairs(Connections) do
                    C.RemoveGlobalConnection(conn)
                end
                Connections = {}
            end
        end
        -- Function to determine the current word and its index
        local function getCurrentWordAndIndex(words, cursorPosition)
            local totalLength = 0
            for index, word in ipairs(words) do
                totalLength = totalLength + #word + 1 -- +1 for the space
                if cursorPosition <= totalLength then
                    return word, index
                end
            end
            return "", 0 -- Default return if something goes wrong
        end
        local function textUpd()
            if DidSet <= 0 then
                index = 0
            end
            local newInputFirst, doubleSpaces = chatBar.Text:gsub("\t","")
            local newInput, moreSpaces = newInputFirst:gsub("%s+"," ")
            doubleSpaces += moreSpaces
            local newLength = newInput:len()
            --Load suggestions
            if DidSet <= 0 then
                if (newInput:sub(1, 1) == ";" or newInput:sub(1, 1) == "/") then
                    if doubleSpaces > 0 and chatBar.Text ~= newInput then
                        --print("Upd",doubleSpaces,moreSpaces)
                        chatBar.Text = newInput
                    end
                    Words = newInput:sub(2):split(" ")
                    local firstCommand = Words[1] -- Command, Really Important
                    local currentWord,currentWordIndex = getCurrentWordAndIndex(Words,chatBar.CursorPosition-1)--minus one for the command ;
                    local commands = C.StringStartsWith(C.CommandFunctions,firstCommand,true)
                    CurrentWordIndex = currentWordIndex
                    local options = {}
                    if currentWordIndex == 1 then
                        for num, list in ipairs(commands) do
                            local command, CommandData = table.unpack(list)
                            local afterTxt = ""
                            for num, suggestionData in ipairs(CommandData.Parameters) do
                                local curText = suggestionData.Type
                                afterTxt ..=" <" .. curText:lower() .. ">"
                            end
                            table.insert(options,{command,command..afterTxt})
                        end
                    elseif commands[1] then
                        local command,CommandData = table.unpack(commands[1]) -- Selected command
                        local mySuggestion = CommandData.Parameters[currentWordIndex - 1]
                        if mySuggestion then
                            if mySuggestion.Type == "Player" or mySuggestion.Type == "Players" then
                                for num, theirPlr in ipairs(PS:GetPlayers()) do
                                    if theirPlr ~= C.plr then
                                        local showLabel = theirPlr.DisplayName
                                        if theirPlr.DisplayName ~= theirPlr.Name then
                                            showLabel ..= " (@" .. theirPlr.Name..")"
                                        end
                                        table.insert(options,{theirPlr.Name,showLabel})
                                    end
                                end
                                if not mySuggestion.ExcludeMe then
                                    table.insert(options,1,{"me","me"})
                                end
                                if mySuggestion.Type == "Players" then
                                    table.insert(options,1,{"others","others"})
                                    table.insert(options,1,{"all","all"})
                                end
                                table.insert(options,{"random","random"})
                            elseif mySuggestion.Type == "Number" then
                                for s = mySuggestion.Min, mySuggestion.Max, (mySuggestion.Max - mySuggestion.Min) / 8 do
                                    local current = s
                                    if mySuggestion.Step then
                                        current = math.round(current/mySuggestion.Step)*mySuggestion.Step
                                    end
                                    local putInStep = tostring(math.clamp(current,mySuggestion.Min,mySuggestion.Max))
                                    local isIn = false
                                    for num, vals in ipairs(options) do
                                        if vals[1] == putInStep or vals[2] == putInStep then
                                            isIn = true
                                            break
                                        end
                                    end
                                    if not isIn then
                                        table.insert(options,{putInStep, putInStep})
                                    end
                                end
                            elseif mySuggestion.Type == "Options" then
                                for num, val in ipairs(mySuggestion.Options) do
                                    table.insert(options,{val,val})
                                end
                            elseif mySuggestion.Type == "Friend" then
                                for num, val in ipairs(C.friends) do
                                    table.insert(options,{val.UserId,val.SortName})
                                end
                            elseif mySuggestion.Type == "User" then
                                -- No suggestions available
                            else
                                assert(not mySuggestion.Type, `(CommandCore.RegisterNewChatBar.textUpd): Suggestion Type Not Yet Implented for {mySuggestion.Type}`)
                            end
                            options = C.StringStartsWith(options,currentWord,true,true)
                        end
                    end
                    ClearSuggestions()
                    for num, item in ipairs(options) do
                        if item[1] == LastPreferred then
                            currentIndex = num
                        end
                    end
                    for num, list in ipairs(options) do
                        local name, display = table.unpack(list)
                        local newClone = C.Examples.AutoCompleteEx:Clone()
                        newClone.BackgroundColor3 = num==currentIndex and Color3.fromRGB(0,255) or Color3.fromRGB(255)
                        newClone.AutoCompleteTitleLabel.Text = display
                        newClone.Name = name
                        newClone.Parent = ChatAutoCompleteFrame
                        newClone.LayoutOrder = num
                        table.insert(frameList,newClone)
                    end
                else
                    ClearSuggestions()
                end
            end
            DidSet = math.max(DidSet-1,0)
            if not chatBar or not isFocused then
                return
            end

            --Up Down Commands
            if #C.savedCommands==0 or lastText == newInput then
                return
            end
            local deltaIndex
            if newInput:match("/up") then
                deltaIndex = 1
            elseif newInput:match("/down") then
                deltaIndex = -1
            else
                return
            end
            goToSaved(deltaIndex)
        end
        C.AddObjectConnection(chatBar,"TextChatbar",chatBar:GetPropertyChangedSignal("Text"):Connect(textUpd))--:GetPropertyChangedSignal("Text"):Connect(textUpd))
        C.AddObjectConnection(chatBar,"TextChatbar",chatBar:GetPropertyChangedSignal("CursorPosition"):Connect(textUpd))
        textUpd()

        C.AddGlobalConnection(chatBar.Focused:Connect(ChatBarUpdated))
        ChatBarUpdated()
        C.AddObjectConnection(chatBar,"FocusLostChatbar",chatBar.FocusLost:Connect(function(enterPressed)
            local inputMsg = chatBar.Text
            if not C.Cleared then
                ChatBarUpdated()
                if enterPressed then
                    if inputMsg:sub(1,1)==";" or inputMsg:sub(1,1)=="/" then
                        enterPressed = inputMsg:sub(1,1)=="/" -- only send the message if it's a /
                        if not enterPressed then
                            chatBar.Text = ""
                            ClearSuggestions()
                        end
                        task.spawn(C.RunCommand,inputMsg,true)
                    end
                end
            end

            if not hasNewChat or C.Cleared then
                for num, connectionFunct in ipairs(connectionsFuncts) do
                    if connectionFunct.Function then
                        connectionFunct.Function(enterPressed)
                    else
                        warn("NO Function Found For "..num)
                    end
                end
            elseif enterPressed then
                sendTheMessage(inputMsg)
            end
        end))
    end
    if CS.LoadDefaultChat or table.find(OverrideChatGames,game.GameId) then
        if not hasNewChat then
            C.AddGlobalConnection(C.StringWait(C.PlayerGui,"Chat.Frame.ChatBarParentFrame").ChildAdded:Connect(function(child)
                registerNewChatBar()
            end))
        end
        task.spawn(registerNewChatBar,nil,true) -- do it on another thread
    else
        warn("[Specter Chat]: Chat cannot be loaded in custom games; commands may not work.")
    end
    if C.Cleared then
        return
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
                assert(not C.CommandFunctions[name], `[CommandCore]: C.CommandFunctions already has command "{name}"`)
                assert(commandData.Parameters, `[CommandCore]: {name} doesn't have .Paramters`)
                assert(commandData.Run, `[CommandCore]: {name} doesn't have .Run`)
                C.CommandFunctions[name] = commandData
            end
        end
    end
    C.InsertCommandFunctions = nil
    for shortcut, commandTbl in pairs(C.CommandFunctions or {}) do
        commandTbl.Shortcut = shortcut
        commandTbl.Parent = C.CommandFunctions
        for _, aliasName in ipairs(commandTbl.Alias or {}) do
            if C.CommandFunctions[aliasName] then
                error(`[CommandCore]: Duplicate AliasName: {aliasName} from the command {shortcut}: {warn(C.CommandFunctions[aliasName])}`)
            end
            C.CommandFunctions[aliasName] = commandTbl
        end
        commandTbl.Alias = nil
        C.BindEvents(commandTbl)
    end
end