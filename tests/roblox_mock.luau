-- Minimal data-model mock for serializer tests; no game or network code runs.
local objects = {}
local builtinTypeof = typeof
local function typeof(value)
    return type(value) == "table" and rawget(value, "__kind") or builtinTypeof(value)
end
local function vector(kind, fields, ...)
    local result = {__kind = kind}
    for i, key in ipairs(fields) do result[key] = select(i, ...) end
    return result
end
local Vector2 = {new = function(x, y) return vector("Vector2", {"X", "Y"}, x, y) end}
local Vector3 = {new = function(x, y, z) return vector("Vector3", {"X", "Y", "Z"}, x, y, z) end}
local Color3 = {new = function(r, g, b) return vector("Color3", {"R", "G", "B"}, r, g, b) end}
local CFrame = {new = function(...)
    local components = {...}
    return {__kind = "CFrame", GetComponents = function() return table.unpack(components) end}
end}
local NumberRange = {new = function(min, max) return vector("NumberRange", {"Min", "Max"}, min, max) end}
local ColorSequence = {new = function(points) return {__kind="ColorSequence", Keypoints=points} end}
local NumberSequence = {new = function(points) return {__kind="NumberSequence", Keypoints=points} end}
local ColorSequenceKeypoint = {new = function(t, v) return {Time=t, Value=v} end}
local NumberSequenceKeypoint = {new = function(t, v, e) return {Time=t, Value=v, Envelope=e} end}
local Instance = {new = function(class)
    local object = {__kind="Instance", ClassName=class, Name=class}
    function object:GetChildren()
        local children = {}
        for _, other in objects do
            if other.Parent == self then table.insert(children, other) end
        end
        return children
    end
    function object:IsDescendantOf(ancestor)
        assert(ancestor ~= nil, "IsDescendantOf requires an Instance")
        local current = self.Parent
        while current do
            if current == ancestor then return true end
            current = current.Parent
        end
        return false
    end
    table.insert(objects, object)
    return object
end}
local warn = function() end
