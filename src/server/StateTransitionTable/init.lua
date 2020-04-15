local StateTransitionTable = {}

StateTransitionTable.new = --[[StateTransitionTable]] function(self, --[[StateTransition]] ...)
    self._transitions = args
    return self
end

StateTransitionTable.testEventForTransitionFromState = --[[boolean]] function(self, --[[Event]] event, --[[State]] state)
    for _, transition in ipairs(self._transitions) do
        if transition:shouldTransitionOn(event) then
            return transition:getToState()
        end
    end
    return nil
end

return StateTransitionTable

