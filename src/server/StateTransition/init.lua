local StateTransition = {}

StateTransition.new = function(self, --[[State]] from, --[[State]] to, --[[ Event[] ]] on)
    self._from = from
    self._to = to
    -- TODO: Extract into this a library
    self._transitionSet = {}
    for _, event in ipairs(on) do
        self._transitionSet[event] = true
    end
    return self
end

StateTransition.shouldTransitionOn = --[[boolean]] function(self, --[[Event]] event)
    if self._transitionSet[event] then
        return true
    else
        return false
    end
end

StateTransition.getToState = --[[State]] function(self)
    return self._to
end

return StateTransition

