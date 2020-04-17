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

return Utils

