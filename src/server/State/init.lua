Object = {}

local tableToString = function(o)
    if o == nil then
        return "(nil)"
    end

    local result = ""
    for k, v in pairs(o) do
        result = ", "..k..":"..tostring(v)..result
    end
    return "{"..string.sub(result,2).."}"
end

Object.new = --[[Object]] function(self)
    print("OBJECT NEW")
    setmetatable(self, {})
    return self
end

Object.logDebug = --[[void]] function(self, --[[string]] msg)
    print(tostring(tick()).." [DEBUG] "..msg)
end

Object.logInfo = --[[void]] function(self, --[[string]] msg)
    game.TestService:Message(tostring(tick()).." [INFO] "..msg)
end

Object.logWarn = --[[void]] function(self, --[[string]] msg)
    game.TestService:Warn(false, tostring(tick()).." [WARN] "..msg)
end

Object.logError = --[[void]] function(self, --[[string]] msg)
    game.TestService:Error(tostring(tick()).." [ERROR] "..msg)
end

Object.__tostring = --[[string]] function(self)
    return tableToString(self)
end

Class = {}

local _reservedConstructor = function(classT, ...)
    local instanceT = {}--classT:new(...)
    for k,v in pairs(classT) do
        instanceT[k] = v
    end
    return instanceT:new(...)
end

local metatables = {}

Class.classDefinition --[[<T,U extends Object>]] = function(--[[U]] baseClassU)
    local classT = {}
    for k,v in pairs(baseClassU) do
        classT[k] = v
    end
    local classTMetatable = {}
    -- Match methods in T first before looking elsewhere
    classTMetatable.__index = classT
    -- ClassT(arg) will call _reservedConstructor(arg)
    classTMetatable.__call = _reservedConstructor
    setmetatable(classT, classTMetatable)


    -- Build up an "instance" of T starting by inheriting all methods from base class
    --local instanceT = {}
    -- Replace the metatable of the instance with that of its class, since the class may define special overrides like __tostring
    --setmetatable(instanceT, classT)


    return classT, baseClassU
end



print(tableToString(Object))
print(tableToString(getmetatable(Object)))
local State, super = Class.classDefinition(Object)
--[[
State = Object

State.newInstance = --[[State function(self, --[[string name)
    local instance = {}
    self.__index = self
    setmetatable(instance, self)
    instance._new(instance, name)
    return instance
end
]]
State.new = function(self, name)
    local this = super.new(self)
    print("STATE NEW")
    this._name = name
    return this
end
print(tableToString(State))
local s = State("K")
local t = State("T")
print(tostring(s))
print(s._name)
print(tostring(t))
print(t._name)

State.execute = --[[void]] function(self)
    self:logWarn("base execution logic was not overridden")
end

State.getName = --[[string]] function(self)
    return self._name
end

--State.__tostring = --[[string]] function(self)
    --return "State<name="..self._name..">"
--end

return State

