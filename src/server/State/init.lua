State = {}

State.__call = --[[State]] function(self, --[[string]] name)
    o = {}
    setmetatable(o, {__index = self})

end

State.new = --[[State]] function(self, --[[string]] name) {
    self._name = name
    return self


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

