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

Utils.round = --[[number]] function(--[[number]] n)
    return n + 0.5 - (n + 0.5) % 1
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

Utils.placeMarker = function(--[[Vector3]] pos, --[[string]] name, --[[object]] parent)
    local p = Instance.new("Part")
    p.Anchored = true
    p.CanCollide = false
    p.Locked = true
    p.Size = Vector3.new(0.1, 0.1, 0.1)
    p.Color = Color3.new(1, 1, 1)
    p.Name = name
    p.Position = pos
    p.Parent = parent
    return p
end

Utils.placeBeam = function(--[[Vector3]] sPos, --[[Vector3]] tPos, --[[string]] name, --[[ColorSequence]] colorSequence)
    local viz = Instance.new("Model")
    viz.Name = name
    viz.Parent = game.Workspace.Terrain

    local s = Utils.placeMarker(sPos, "s:"..Utils.toStringVector3(sPos), viz)
    s.Transparency = 1

    local t = Utils.placeMarker(tPos, "t:"..Utils.toStringVector3(tPos), viz)
    t.Transparency = 1

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
    b.Color = colorSequence
    b.Parent = viz
end

Utils.visualizeRay = --[[void]] function(--[[Ray]] r)
    Utils.placeBeam(r.Origin, r.Origin + r.Direction, Utils.toStringRay(r), ColorSequence.new(Color3.new(1,1,0), Color3.new(1,0,1)))
end

return Utils
