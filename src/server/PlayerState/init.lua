local Object = require(game.ReplicatedStorage.Scripts.Object)
local Class = require(game.ReplicatedStorage.Scripts.Class)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local PlayerState, super = Class.classDefinition(Object)
PlayerState._className = "PlayerState"
PlayerState._new = --[[PlayerState]] function(self,
        --[[string]] name, --[[number]] currentRoundScore, --[[number]] currentGameScore, --[[boolean]] isAlive)
    self = super._new(self)
    self._name = name

    self._currentRoundScore = 0
    self._currentGameScore = 0
    self._isAlive = isAlive
    return self
end

PlayerState.__tostring = --[[string]] function(self)
    return "PlayerState<"..self._name..",currentRoundScore="..Utils.truncateNumber(self._currentRoundScore)..",currentGameScore="..Utils.truncateNumber(self._currentGameScore)..">"
end

PlayerState.toValue = --[[StringValue]] function(self)
    local val = Instance.new("StringValue")
    val.Name = self._name
    val.Value = self._name
    local currentRoundScore = Instance.new("NumberValue", val)
    currentRoundScore.Name = "CurrentRoundScore"
    currentRoundScore.Value = self._currentRoundScore
    local currentGameScore = Instance.new("NumberValue", val)
    currentGameScore.Name = "CurrentGameScore"
    currentGameScore.Value = self._currentGameScore
    local isAlive = Instance.new("BoolValue", val)
    isAlive.Name = "IsAlive"
    isAlive.Value = self._isAlive
    return val
end

return PlayerState
