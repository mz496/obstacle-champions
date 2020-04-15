local Event = {}

Event.new = --[[Event]] function(self, --[[string]] name)
    self._name = name
    return self
end

Event.equals = --[[boolean]] function(self, --[[Event]] op1, --[[Event]] op2)
    return op1._name == op2._name
end

Event.str = --[[string]] function(self)
    return "Event<name="..self._name..">"
end

-- Override reserved methods
setmetatable(Event, {__tostring = Event.str, __eq = Event.equals})
return Event

