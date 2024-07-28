local PS = game:GetService("Players")
local TCS = game:GetService("TextChatService")
local RunS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local GS = game:GetService("GuiService")
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
        local command, CommandData = table.unpack(C.StringStartsWith(C.CommandFunctions,inputCommand)[1] or {})
        if CommandData then
            if CommandData.RequiresRefresh and noRefresh then
                return
            end
            local canRunFunction = true
            for num, argumentData in ipairs(CommandData.Parameters) do
                if argumentData.Type=="Players" or argumentData.Type=="Player" then
                    if args[num]=="all" then
                        args[num] = PS:GetPlayers()
                    elseif args[num] == "others" then
                        args[num] = PS:GetPlayers()
                        table.remove(args[num],table.find(args[num],C.plr))
                        if #args[num]==0 then
                            canRunFunction = false
                            C.CreateSysMessage(`No other players found`)
                        end
                    elseif args[num] == "me" or args[num] == "" then
                        args[num] = {C.plr}
                    elseif args[num] == "random" then
                        local plrList = PS:GetPlayers()
                        if argumentData.ExcludeMe then
                            C.TblRemove(plrList,C.plr)
                        end
                        args[num] = {plrList[Random.new():NextInteger(1,#plrList)]}
                    elseif args[num] == "new" then
                        if not argumentData.SupportsNew then
                            canRunFunction = false
                            C.CreateSysMessage(`{command} doesn't support "new" players`)
                        end
                        args[num] = "new"
                    else
                        local ChosenPlr = select(2,table.unpack(C.StringStartsWith(PS:GetPlayers(),args[1])[1] or {}))
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
                        end
                    elseif argumentData.Default then
                        args[num] = argumentData.Default
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
                    if wasSuccess then
                        local Length = ChosenPlr and #ChosenPlr
                        local playersAffected = typeof(ChosenPlr) == "table" and (Length>1 and Length .. " Players" or tostring(ChosenPlr[1])) or "UNKNOWN"
                            --(typeof(ChosenPlr)=="Instance" and (ChosenPlr==C.plr and ChosenPlr.Name) or ChosenPlr.Name) 
                           -- or (ChosenPlr:sub(1,1):upper() .. 
                            --    ChosenPlr:sub(2,ChosenPlr:sub(ChosenPlr:len())=="s" and ChosenPlr:len()-1 or ChosenPlr:len()))
                        if playersAffected == C.plr.Name then
                            playersAffected = "you"
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
            mySendButton:AddTag("RemoveOnDestroy")
            sendTheMessage = function(message,dontSetTB)
                message = typeof(message)=="string" and message or chatBar.Text
                if message == "" then
                    return
                end
                local channels = TCS:WaitForChild("TextChannels")
                local myChannel = channels.RBXGeneral
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
        local ChatAutoCompleteFrame = C.UI.ChatAutoComplete
        local DidSet
        local Connection
        local frameList, currentIndex = {}, 1
        local function ClearSuggestions()
            C.ClearChildren(ChatAutoCompleteFrame)
            frameList, currentIndex = {}, 1
        end
		local function goToSaved(deltaIndex)
			index += deltaIndex
            lastUpd = os.clock()
            index = math.clamp(index,0,#C.savedCommands+1)

            local setTo = C.savedCommands[index] or ""
            lastText = setTo
            RunS.RenderStepped:Wait()
            DidSet = true
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
            local Inset = GS:GetGuiInset().Y
            isFocused = chatBar:IsFocused()
            ChatAutoCompleteFrame.Visible = isFocused
            ChatAutoCompleteFrame.Position = UDim2.fromOffset(chatBar.Parent.AbsolutePosition.X,chatBar.Parent.AbsolutePosition.Y+chatBar.Parent.AbsoluteSize.Y+Inset)
            ChatAutoCompleteFrame.Size = UDim2.fromOffset(chatBar.AbsoluteSize.X,C.GUI.AbsoluteSize.Y - ChatAutoCompleteFrame.AbsolutePosition.Y - Inset)
            if isFocused then
                local Deb = 0
                local ConnectedFunct
                function ConnectedFunct(inputObject, gameProcessed, noLoop)
                    if #frameList > 0 and not UIS:IsKeyDown(Enum.KeyCode.LeftShift) and not UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                        if inputObject.KeyCode == Enum.KeyCode.Up then
                            HighlightLayout(currentIndex - 1)
                        elseif inputObject.KeyCode == Enum.KeyCode.Down then
                            HighlightLayout(currentIndex + 1)
                        elseif inputObject.KeyCode == Enum.KeyCode.Tab then
                            local orgName = frameList[currentIndex].Name
                            --RunS.RenderStepped:Wait()
                            Words[math.max(1,CurrentWordIndex)] = orgName
                            Words[1] = chatBar.Text:sub(1,1) .. Words[1]
                            chatBar.Text = table.concat(Words, " ")
                            chatBar.CursorPosition = chatBar.Text:len() + 1
                        else
                            return
                        end
                    else
                        if inputObject.KeyCode == Enum.KeyCode.Up then
                            goToSaved(1)
                        elseif inputObject.KeyCode == Enum.KeyCode.Down then
                            goToSaved(-1)
                        else
                            return
                        end
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
                Connection = C.AddGlobalConnection(UIS.InputBegan:Connect(ConnectedFunct))
                HighlightLayout(currentIndex) -- Make sure it's visible!
            elseif Connection then
                C.RemoveGlobalConnection(Connection)
                Connection = nil
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
            RunS.RenderStepped:Wait()
            if not DidSet then
                index = 0
            end
            local newInputFirst, doubleSpaces = chatBar.Text:gsub("\t","")
            local newInput, moreSpaces = newInputFirst:gsub("%s+"," ")
            doubleSpaces += moreSpaces
            local newLength = newInput:len()
            --Load suggestions
            if not DidSet then
                if (newInput:sub(1, 1) == ";" or newInput:sub(1, 1) == "/") then
                    if doubleSpaces > 0 then
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
                    else
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
                                    table.insert(options,{"me","me"})
                                end
                                if mySuggestion.Type == "Players" then
                                    table.insert(options,{"all","all"})
                                    table.insert(options,{"others","others"})
                                end
                            elseif mySuggestion.Type == "Number" then
                                for s = mySuggestion.Min, mySuggestion.Max, (mySuggestion.Max - mySuggestion.Min) / 8 do
                                    table.insert(options,{tostring(s),tostring(s)})
                                end
                            end
                            options = C.StringStartsWith(options,currentWord,true,true)
                        end
                    end
                    ClearSuggestions()
                    for num, list in ipairs(options) do
                        local name, display = table.unpack(list)
                        local newClone = C.Examples.AutoCompleteEx:Clone()
                        newClone.BackgroundColor3 = num==1 and Color3.fromRGB(0,255) or Color3.fromRGB(255)
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
            DidSet = false
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
        C.AddObjectConnection(chatBar,"TextChatbar",chatBar:GetPropertyChangedSignal("Text"):Connect(textUpd))
        --C.AddObjectConnection(chatBar,"TextChatbar",chatBar:GetPropertyChangedSignal("CursorPosition"):Connect(textUpd))
        textUpd()
        
        C.AddGlobalConnection(chatBar.Focused:Connect(ChatBarUpdated))
        ChatBarUpdated()
        C.AddObjectConnection(chatBar,"FocusLostChatbar",chatBar.FocusLost:Connect(function(enterPressed)
            ChatBarUpdated()
            local inputMsg = chatBar.Text
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
    if not hasNewChat then
        C.AddGlobalConnection(C.StringWait(C.PlayerGui,"Chat.Frame.ChatBarParentFrame").ChildAdded:Connect(function(child)
            registerNewChatBar()
        end))
    end
    registerNewChatBar(nil,true)

    for num, commandTbl in pairs(C.CommandFunctions) do
        commandTbl.Parent = C.CommandFunctions
        C.BindEvents(commandTbl)
    end
end