Object = require(game.ReplicatedStorage.Common.Object)

Class = require(game.ReplicatedStorage.Common.Class)



--print(tableToString(Object))
--print(tableToString(getmetatable(Object)))
local State, super = Class.classDefinition(Object)
State._className = "State"
State._new = function(self, name)
    self = super._new(self)
    print("STATE NEW")
    self._name = name
    return self
end

State.execute = --[[void]] function(self)
    self:logWarn("base execution logic was not overridden")
end

State.getName = --[[string]] function(self)
    return self._name
end

State.__tostring = --[[string]] function(self)
    return "State<name="..self._name..">"
end

return State

