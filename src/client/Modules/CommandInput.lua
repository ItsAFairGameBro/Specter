-- Shared parsing and matching for execution and the command palette.
return function()
    local Input = {}
    function Input.Parse(text)
        local tokens, spans = {}, {}
        local i = (text:sub(1, 1) == ";" or text:sub(1, 1) == "/") and 2 or 1
        while i <= #text do
            if text:sub(i, i):match("%s") then i += 1 continue end
            local first, value, quote = i, "", nil
            while i <= #text do
                local char = text:sub(i, i)
                if char == "\\" and i < #text and (text:sub(i + 1, i + 1) == quote or text:sub(i + 1, i + 1) == "\\") then
                    i += 1
                    value ..= text:sub(i, i)
                elseif quote then
                    if char == quote then quote = nil else value ..= char end
                elseif char == '"' or char == "'" then
                    quote = char
                elseif char:match("%s") then
                    break
                else
                    value ..= char
                end
                i += 1
            end
            table.insert(tokens, value)
            table.insert(spans, {first, i})
            if quote then return tokens, spans, "Close the quoted argument before running." end
        end
        return tokens, spans
    end
    function Input.Resolve(commands, query)
        query = query:lower()
        if query == "" then return nil end
        local found, data
        for name, command in pairs(commands) do
            if name:lower() == query then return name, command end
        end
        for name, command in pairs(commands) do
            if name:lower():sub(1, #query) == query then
                if data and data ~= command then return nil, nil, "ambiguous" end
                found, data = name, command
            end
        end
        return found, data
    end
    function Input.Context(text, cursor)
        local tokens, spans = Input.Parse(text)
        cursor = cursor and cursor > 0 and math.clamp(cursor, 1, #text + 1) or #text + 1
        for index, span in ipairs(spans) do
            if cursor >= span[1] and cursor <= span[2] then
                local partial = Input.Parse(text:sub(span[1], cursor - 1))
                return tokens, index, span[1], span[2], partial[1] or ""
            elseif cursor < span[1] then
                return tokens, index, cursor, cursor, ""
            end
        end
        return tokens, #tokens + 1, cursor, cursor, ""
    end
    function Input.Complete(text, first, last, value)
        value = tostring(value)
        if value:find('[%s"\'\\]') then
            value = '"' .. value:gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
        end
        local suffix = text:sub(last)
        local replacement = value .. (suffix:match("^%s") and "" or " ")
        return text:sub(1, first - 1) .. replacement .. suffix, first + #replacement
    end
    function Input.Filter(options, query)
        local result, seen = {}, {}
        query = query:lower()
        for _, option in ipairs(options) do
            local value, label = tostring(option[1]), tostring(option[2])
            if not seen[value] and (value:lower():sub(1, #query) == query or label:lower():sub(1, #query) == query) then
                seen[value] = true
                table.insert(result, {value, label})
            end
        end
        table.sort(result, function(a, b)
            if (a[1]:lower() == query) ~= (b[1]:lower() == query) then return a[1]:lower() == query end
            return a[1]:lower() < b[1]:lower()
        end)
        return result
    end
    return Input
end
