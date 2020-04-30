-- Collection of static methods, i.e. methods that do not use the self instance
local Utils = {}

Utils.objectToString = --[[string]] function(--[[Object]] o)
    if o == nil then
        return "(nil)"
    end

    local className = o._className
    local result = Utils.tableToString(o)
    local metatable = Utils.tableToString(getmetatable(o) or nil)
    return "<CLASS "..className..", ADDR "..tostring(o)..
        "\n|        "..result..
        "\n|        METATABLE "..metatable..">"
end

Utils.tableToString = --[[string]] function(--[[Object]] o)
    if o == nil then
        return "(nil)"
    end

    local result = ""
    for k, v in pairs(o) do
        result = ", "..k..":"..tostring(v)..result
    end
    return "{"..string.sub(result,2).."}"
end

Utils.logDebug = --[[void]] function(--[[string]] msg)
    print(tostring(tick()).." [DEBUG] "..msg)
end

Utils.logInfo = --[[void]] function(--[[string]] msg)
    game.TestService:Message(tostring(tick()).." [INFO] "..msg)
end

Utils.logWarn = --[[void]] function(--[[string]] msg)
    game.TestService:Warn(false, tostring(tick()).." [WARN] "..msg)
end

Utils.logError = --[[void]] function(--[[string]] msg)
    game.TestService:Error(tostring(tick()).." [ERROR] "..msg)
end

Utils.logFatal = --[[void]] function(--[[string]] msg)
    game.TestService:Error(tostring(tick()).." [FATAL] "..msg)
    local x = nil
    print(x.throw_intentional_error_for_stacktrace)
end

Utils.truncateNumber = --[[string]] function(--[[number]] n)
    if (n == 0) then
        return "0"
    end
    if (n == math.floor(n)) then
        return tostring(n)
    end
    -- This is one-indexed
    local decimalPointIndex = 2 + math.floor(math.log10(math.abs(n)))
    local decimalPlaces = 3
    if (n < 0) then
        decimalPointIndex = decimalPointIndex + 1
    end
    return string.sub(tostring(n), 1, decimalPointIndex + decimalPlaces)
end

Utils.toStringVector2 = --[[string]] function(--[[Vector2]] v)
    return "Vector2("..Utils.truncateNumber(v.X)..", "..Utils.truncateNumber(v.Y)..")"
end

Utils.toStringVector3 = --[[string]] function(--[[Vector3]] v)
    return "Vector3("..Utils.truncateNumber(v.X)..", "..Utils.truncateNumber(v.Y)..", "..Utils.truncateNumber(v.Z)..")"
end

Utils.toStringRay = --[[string]] function(--[[Ray]] r)
    return "Ray(origin="..Utils.toStringVector3(r.Origin)..", direction="..Utils.toStringVector3(r.Direction)..")"
end

Utils.visualizeRay = --[[void]] function(--[[Ray]] r)
    local viz = Instance.new("Model")
    viz.Name = Utils.toStringRay(r)
    viz.Parent = game.Workspace.Terrain

    local s = Instance.new("Part")
    s.Anchored = true
    s.CanCollide = false
    s.Locked = true
    s.Transparency = 1
    s.Size = Vector3.new(0.1, 0.1, 0.1)
    s.Position = r.Origin
    s.Name = "s:"..Utils.toStringVector3(s.Position)
    s.Parent = viz

    local t = Instance.new("Part")
    t.Anchored = true
    t.CanCollide = false
    t.Locked = true
    t.Transparency = 1
    t.Size = Vector3.new(0.1, 0.1, 0.1)
    t.Position = r.Origin + r.Direction
    t.Name = "t:"..Utils.toStringVector3(t.Position)
    t.Parent = viz

    local sAttachment = Instance.new("Attachment")
    sAttachment.Parent = s

    local tAttachment = Instance.new("Attachment")
    tAttachment.Parent = t

    local b = Instance.new("Beam")
    b.Segments = 1
    b.Width0 = 0.1
    b.Width1 = 0.1
    b.Attachment0 = sAttachment
    b.Attachment1 = tAttachment
    b.FaceCamera = true
    b.Transparency = NumberSequence.new(0)
    b.Color = ColorSequence.new(Color3.new(1,1,0), Color3.new(1,0,1))
    b.Parent = viz
end

return Utils
