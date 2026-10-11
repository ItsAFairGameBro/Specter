local UIS = game:GetService("UserInputService")
local GS = game:GetService("GuiService")
local Players = game:GetService("Players")

return function(C)
    local Input = C.LoadModule("Modules/CommandInput")
    local bar, list = C.UI.Commandbar, C.UI.ChatAutoComplete
    local z = math.max(bar.ZIndex, list.ZIndex)
    local function make(class, parent, properties)
        local object = Instance.new(class)
        for key, value in pairs(properties) do object[key] = value end
        object.Parent = parent
        return object
    end
    local panel = make("Frame", C.GUI, {
        Name = "CommandPalette", Visible = false, ZIndex = z,
        BackgroundColor3 = Color3.fromRGB(27, 30, 40), BorderSizePixel = 0,
    })
    make("UICorner", panel, {CornerRadius = UDim.new(0, 10)})
    bar.Parent = panel
    bar.AnchorPoint = Vector2.zero
    bar.Position = UDim2.fromOffset(8, 8)
    bar.Size = UDim2.new(1, -80, 0, 44)
    bar.Visible = true
    bar.TextScaled, bar.TextWrapped, bar.MultiLine = false, false, false
    bar.TextSize = 18
    bar.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    bar.TextXAlignment = Enum.TextXAlignment.Left
    bar.TextStrokeTransparency = 1
    bar.PlaceholderText = "Search commands..."
    bar.BackgroundColor3 = Color3.fromRGB(42, 46, 58)
    list.Parent = panel
    list.AnchorPoint = Vector2.zero
    list.Position = UDim2.fromOffset(8, 108)
    list.Size = UDim2.new(1, -16, 1, -116)
    list.ScrollBarThickness = 6
    list.ScrollingDirection = Enum.ScrollingDirection.Y
    list.Visible = true
    local function button(text, position, size)
        return make("TextButton", panel, {
            Text = text, Position = position, Size = size, ZIndex = z + 1,
            Font = Enum.Font.SourceSansSemibold, TextSize = 18,
            TextColor3 = Color3.new(1, 1, 1), BackgroundColor3 = Color3.fromRGB(51, 65, 87),
            BorderSizePixel = 0, AutoButtonColor = true,
        })
    end
    local run = button("Run", UDim2.new(1, -64, 0, 8), UDim2.fromOffset(56, 44))
    local previous = button("Previous", UDim2.fromOffset(8, 58), UDim2.fromOffset(82, 44))
    local nextButton = button("Next", UDim2.fromOffset(96, 58), UDim2.fromOffset(64, 44))
    local close = button("Close", UDim2.new(1, -72, 0, 58), UDim2.fromOffset(64, 44))
    local launcher = make("TextButton", C.GUI, {
        Name = "CommandsButton", Text = "Commands", AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.fromOffset(104, 44), ZIndex = z,
        Font = Enum.Font.SourceSansSemibold, TextSize = 18,
        TextColor3 = Color3.new(1, 1, 1), BackgroundColor3 = Color3.fromRGB(42, 46, 58),
        BorderSizePixel = 0,
    })
    C.UI.CommandsButton = launcher
    local rows, options, selected, first, last = {}, {}, 1, 1, 1
    local cursor, historyIndex, draft, updating = 1, 0, "", false
    local refresh
    local function layout()
        if C.Cleared then return end
        local size = C.GUI.AbsoluteSize
        local inset = GS:GetGuiInset()
        local top = inset.Y + 8
        local bottom = size.Y - 8
        if UIS.OnScreenKeyboardVisible and UIS.OnScreenKeyboardPosition.Y > 0 then
            bottom = math.min(bottom, UIS.OnScreenKeyboardPosition.Y - 8)
        end
        local width = math.max(1, math.min(560, size.X - 16))
        panel.Position = UDim2.fromOffset((size.X - width) / 2, top)
        panel.Size = UDim2.fromOffset(width, math.max(116, math.min(400, bottom - top)))
        launcher.Position = UDim2.new(1, -8, 0, top)
        -- A physical keyboard takes precedence even on touch devices/emulators.
        bar.ShowNativeInput = not UIS.KeyboardEnabled
    end
    local function setText(text, position)
        updating = true
        bar.Text = text
        cursor = position or #text + 1
        bar.CursorPosition = cursor
        updating = false
        refresh()
    end
    local function highlight()
        for i, row in ipairs(rows) do
            row.BackgroundColor3 = i == selected and Color3.fromRGB(55, 91, 134) or Color3.fromRGB(38, 42, 54)
        end
        if rows[selected] then
            local y = rows[selected].AbsolutePosition.Y - list.AbsolutePosition.Y + list.CanvasPosition.Y
            local view = list.AbsoluteSize.Y
            if y < list.CanvasPosition.Y then list.CanvasPosition = Vector2.new(0, y)
            elseif y + 44 > list.CanvasPosition.Y + view then list.CanvasPosition = Vector2.new(0, math.max(0, y + 44 - view)) end
        end
    end
    local function accept(index)
        local option = options[index]
        if not option then return end
        local text, position = Input.Complete(bar.Text, first, last, option[1])
        bar:CaptureFocus()
        setText(text, position)
    end
    refresh = function()
        if updating or C.Cleared or not panel.Visible then return end
        local tokens, word, start, finish, query = Input.Context(bar.Text, cursor)
        first, last = start, finish
        local candidates = {}
        local function add(value, label) table.insert(candidates, {value, label or value}) end
        if word == 1 then
            for name, command in pairs(C.CommandFunctions) do
                local label = name
                for _, parameter in ipairs(command.Parameters) do
                    label ..= " <" .. tostring(parameter.Type or "value"):lower() .. ">"
                end
                add(name, label)
            end
        else
            local _, command = Input.Resolve(C.CommandFunctions, tokens[1] or "")
            local parameter = command and command.Parameters[word - 1]
            if parameter then
                local kind = parameter.Type
                if kind == "Players" or kind == "Player" then
                    if not parameter.ExcludeMe then add("me") end
                    if kind == "Players" then add("all") add("others") end
                    add("random")
                    if parameter.SupportsNew then add("new") end
                    local eligible = parameter.AllowFriends and Players:GetPlayers() or C.GetNonFriends(true)
                    for _, player in ipairs(eligible) do
                        if not (parameter.ExcludeMe and player == C.plr) then
                            add(player.Name, player.DisplayName .. " (@" .. player.Name .. ")")
                        end
                    end
                elseif kind == "Options" then
                    for _, value in ipairs(parameter.Options) do add(value) end
                elseif kind == "Number" then
                    if parameter.Default ~= nil then add(parameter.Default) end
                    for i = 0, 8 do
                        local value = parameter.Min + (parameter.Max - parameter.Min) * i / 8
                        if parameter.Step then value = math.round(value / parameter.Step) * parameter.Step end
                        add(math.clamp(value, parameter.Min, parameter.Max))
                    end
                elseif kind == "Friend" then
                    for _, friend in ipairs(C.friends or {}) do add(friend.UserId, friend.SortName) end
                elseif kind == "Outfit" then
                    local matches = C.StringStartsWith(C.friendnames, tokens[word - 1] or "", true)
                    local friend = matches[#matches]
                    local id = friend and C.friendnamestoids[friend[2]]
                    for _, outfit in ipairs(id and C.getgenv().Outfits[id] or {}) do add(outfit.id, outfit.SortName) end
                elseif kind == "Instance" then
                    local root = C[parameter.Root]
                    for _, object in ipairs(root and root:GetDescendants() or {}) do
                        if object:IsA("Animation") then add(object.Name) end
                    end
                end
                -- Free text and user IDs deliberately have no forced suggestions.
            end
        end
        local preferred = options[selected] and options[selected][1]
        options = Input.Filter(candidates, query)
        for _, row in ipairs(rows) do row:Destroy() end
        rows, selected = {}, 1
        for i, option in ipairs(options) do
            if option[1] == preferred then selected = i end
            local row = make("TextButton", list, {
                Name = option[1], Text = "  " .. option[2], LayoutOrder = i,
                Size = UDim2.new(1, -8, 0, 44), ZIndex = z + 1,
                Font = Enum.Font.SourceSans, TextSize = 18, TextColor3 = Color3.new(1, 1, 1),
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                BorderSizePixel = 0,
            })
            row.Activated:Connect(function() accept(i) end)
            table.insert(rows, row)
        end
        highlight()
    end
    local function history(delta)
        if historyIndex == 0 then draft = bar.Text end
        historyIndex = math.clamp(historyIndex + delta, 0, #C.savedCommands)
        setText(historyIndex == 0 and draft or C.savedCommands[historyIndex])
    end
    local function dismiss()
        panel.Visible = false
        bar:ReleaseFocus(false)
    end
    local function submit()
        if not panel.Visible or not bar.Text:find("%S") then return end
        local text = bar.Text
        -- Clear and close before dispatch; mobile Return and FocusLost can both fire.
        setText("")
        dismiss()
        task.spawn(C.RunCommand, text, true)
    end
    function C.OpenCommandBar()
        if C.Cleared then return end
        layout()
        panel.Visible = true
        historyIndex = 0
        bar:CaptureFocus()
        cursor = #bar.Text + 1
        bar.CursorPosition = cursor
        refresh()
    end
    local function connect(signal, callback) C.AddGlobalConnection(signal:Connect(callback)) end
    connect(launcher.Activated, C.OpenCommandBar)
    connect(run.Activated, submit)
    connect(close.Activated, dismiss)
    connect(previous.Activated, function() history(1) end)
    connect(nextButton.Activated, function() history(-1) end)
    connect(bar:GetPropertyChangedSignal("Text"), function()
        if not updating then
            historyIndex = 0
            if bar.Text:find("\t") then
                setText(bar.Text:gsub("\t", ""), cursor)
            else
                refresh()
            end
        end
    end)
    connect(bar:GetPropertyChangedSignal("CursorPosition"), function()
        if bar.CursorPosition > 0 then cursor = bar.CursorPosition refresh() end
    end)
    connect(bar.FocusLost, function(enterPressed) if enterPressed then submit() end end)
    connect(bar.ReturnPressedFromOnScreenKeyboard, submit)
    connect(UIS.InputBegan, function(input, processed)
        if not UIS.KeyboardEnabled then return end
        if bar:IsFocused() then
            if input.KeyCode == Enum.KeyCode.Tab then accept(selected)
            elseif input.KeyCode == Enum.KeyCode.Up then
                if #options > 0 then selected = math.max(1, selected - 1) highlight() else history(1) end
            elseif input.KeyCode == Enum.KeyCode.Down then
                if #options > 0 then selected = math.min(#options, selected + 1) highlight() else history(-1) end
            elseif input.KeyCode == Enum.KeyCode.PageUp then history(1)
            elseif input.KeyCode == Enum.KeyCode.PageDown then history(-1)
            elseif input.KeyCode == Enum.KeyCode.Escape then dismiss() end
        elseif not processed and not UIS:GetFocusedTextBox() and input.KeyCode == Enum.KeyCode.Semicolon then
            -- Defer past the opener keystroke so it is not inserted twice.
            task.defer(C.OpenCommandBar)
        end
    end)
    for _, property in ipairs({"KeyboardEnabled", "OnScreenKeyboardVisible", "OnScreenKeyboardPosition", "OnScreenKeyboardSize"}) do
        connect(UIS:GetPropertyChangedSignal(property), layout)
    end
    connect(C.GUI:GetPropertyChangedSignal("AbsoluteSize"), layout)
    connect(Players.PlayerAdded, refresh)
    connect(Players.PlayerRemoving, function() task.defer(refresh) end)
    layout()
end
