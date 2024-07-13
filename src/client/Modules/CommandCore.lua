local PS = game:GetService("Players")
local TCS = game:GetService("TextChatService")
local RunS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
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
        local command, CommandData = C.StringStartsWith(C.CommandFunctions,inputCommand)
        if CommandData then
            if CommandData.RequiresRefresh and noRefresh then
                return
            end
            local canRunFunction = true
            local ChosenPlr = args[1]
            if CommandData.Type=="Players" or CommandData.Type=="Player" then
                if ChosenPlr=="all" then
                    args[1] = PS:GetPlayers()
                elseif ChosenPlr == "others" then
                    args[1] = PS:GetPlayers()
                    table.remove(args[1],table.find(args[1],C.plr))
                    if #args[1]==0 then
                        canRunFunction = false
                        C.CreateSysMessage(`No other players found`)
                    end
                elseif ChosenPlr == "me" or ChosenPlr == "" then
                    args[1] = {C.plr}
                elseif ChosenPlr == "random" then
                    args[1] = {PS:GetPlayers()[Random.new():NextInteger(1,#PS:GetPlayers())]}
                elseif ChosenPlr == "new" then
                    if not CommandData.SupportsNew then
                        canRunFunction = false
                        C.CreateSysMessage(`{command} doesn't support "new" players`)
                    end
                    args[1] = "new"
                else
                    local _
                    _, ChosenPlr = C.StringStartsWith(PS:GetPlayers(),args[1])
                    if ChosenPlr then
                        args[1] = {ChosenPlr}
                    else
                        canRunFunction = false
                        C.CreateSysMessage(`Player(s) Not Found: {command}; allowed: all, others, me, <plrName>`)
                    end
                end
                if canRunFunction and CommandData.Type=="Player" and #args[1]>1 then
                    canRunFunction = false
                    C.CreateSysMessage(`{command} only supports a single player`)
                end
            elseif CommandData.Type=="" then
                --do nothing
            elseif CommandData.Type~=false then
                canRunFunction = false
                C.CreateSysMessage(`Internal Error: Command Implemented But Not Supported: {command}, {tostring(CommandData.Type)}`)
            end
            if canRunFunction then
                local function yieldFunction()
                    local returns = table.pack(C.CommandFunctions[command]:Run(args))
                    local wasSuccess = returns[1]
                    table.remove(returns,1)
                    local displayNameCommand = command:sub(1,1):upper() .. command:sub(2)
                    if wasSuccess then
                        local length = #args[1]
                        local playersAffected = 
                            (typeof(ChosenPlr)=="Instance" and (ChosenPlr==C.plr and ChosenPlr.Name) or ChosenPlr.Name) 
                            or (ChosenPlr:sub(1,1):upper() .. 
                                ChosenPlr:sub(2,ChosenPlr:sub(ChosenPlr:len())=="s" and ChosenPlr:len()-1 or ChosenPlr:len()))
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
        local function textUpd()
            if not chatBar or not chatBar:IsFocused() then
                return
            end
            local newInput = chatBar.Text
            local newLength = newInput:len()
            if #C.savedCommands==0 or lastText == newInput then
                return
            end
            if newInput:match("/up") then
                index += 1
            elseif newInput:match("/down") then
                index -= 1
            else
                return
            end
            lastUpd = os.clock()
            index = math.clamp(index,0,#C.savedCommands+1)

            local setTo = C.savedCommands[index] or ""
            lastText = setTo
            RunS.RenderStepped:Wait()
            chatBar.Text = setTo
        end
        C.AddObjectConnection(chatBar,"TextChatbar",chatBar:GetPropertyChangedSignal("Text"):Connect(textUpd))
        textUpd()
        C.AddObjectConnection(chatBar,"FocusLostChatbar",chatBar.FocusLost:Connect(function(enterPressed)
            index = 0
            local inputMsg = chatBar.Text
            if enterPressed then
                if inputMsg:sub(1,1)==";" or inputMsg:sub(1,1)=="/" then
                    enterPressed = inputMsg:sub(1,1)=="/" -- only send the message if it's a /
                    if not enterPressed then
                        chatBar.Text = ""
                    end
                    task.spawn(C.RunCommand,inputMsg,true)
                end
            end
            if not hasNewChat then
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
        table.insert(C.functs,C.StringWait(C.PlayerGui,"Chat.Frame.ChatBarParentFrame").ChildAdded:Connect(function(child)
            registerNewChatBar()
        end))
    end
    registerNewChatBar(nil,true)

    for num, commandTbl in pairs(C.CommandFunctions) do
        commandTbl.Parent = C.CommandFunctions
        C.BindEvents(commandTbl)
    end
end