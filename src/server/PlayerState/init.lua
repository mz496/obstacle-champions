local Object = require(game.ReplicatedStorage.Scripts.Object)
local Class = require(game.ReplicatedStorage.Scripts.Class)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local PlayerState, super = Class.classDefinition(Object)
PlayerState._className = "PlayerState"
PlayerState._new = --[[PlayerState]] function(self,
        --[[string]] name, --[[number]] currentRoundScore, --[[number]] currentGameScore)
    self = super._new(self)
    self._name = name

    self._currentRoundScore = 0
    self._currentGameScore = 0
    return self
end

PlayerState.getName = --[[string]] function(self)
    return self._name
end

PlayerState.getCurrentRoundScore = --[[number]] function(self)
    return self._currentRoundScore
end

PlayerState.setCurrentRoundScore = --[[void]] function(self, s)
    self._currentRoundScore = s
end

PlayerState.getCurrentGameScore = --[[number]] function(self)
    return self._currentGameScore
end

PlayerState.setCurrentGameScore = --[[void]] function(self, s)
    self._currentGameScore = s
end

PlayerState.__tostring = --[[string]] function(self)
    return "PlayerState<"..self._name..",currentRoundScore="..Utils.truncateNumber(self._currentRoundScore)..",currentGameScore="..Utils.truncateNumber(self._currentGameScore)..">"
end

return PlayerState
