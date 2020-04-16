State = {}

State.newInstance = --[[State]] function(self, --[[string]] name)
    local instance = {}
    self.__index = self
    setmetatable(instance, self)
    instance._new(instance, name)
    return instance
end

State._new = function(self, name)
    self._name = name
end

State.execute = --[[void]] function(self)
    print("WARNING: base execution logic was not overridden")
end

State.getName = --[[string]] function(self)
    return self._name
end

State.__tostring = --[[string]] function(self)
    return "State<name="..self._name..">"
end

return State

