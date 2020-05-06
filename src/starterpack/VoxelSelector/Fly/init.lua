local Utils = require(game.ReplicatedStorage.Common.Utils)
local Fly = {}

local UserInputService = game:GetService("UserInputService")

Fly.inputBegan = function(input, gameProcessedEvent)
    if (input.KeyCode == Enum.KeyCode.W) then
        Utils.logInfo("begin w")
    elseif (input.KeyCode == Enum.KeyCode.S) then
        Utils.logInfo("begin s")
    elseif (input.KeyCode == Enum.KeyCode.A) then
        Utils.logInfo("begin a")
    elseif (input.KeyCode == Enum.KeyCode.D) then
        Utils.logInfo("begin d")
    end

    if gameProcessedEvent then
        Utils.logDebug("The game engine internally observed this input")
    end
end

Fly.inputEnded = function(input, gameProcessedEvent)
    if (input.KeyCode == Enum.KeyCode.W) then
        Utils.logInfo("end w")
    elseif (input.KeyCode == Enum.KeyCode.S) then
        Utils.logInfo("end s")
    elseif (input.KeyCode == Enum.KeyCode.A) then
        Utils.logInfo("end a")
    elseif (input.KeyCode == Enum.KeyCode.D) then
        Utils.logInfo("end d")
    end
    
    if gameProcessedEvent then
        Utils.logDebug("The game engine internally observed this input")
    end
end

Fly.bindListeners = function()
    UserInputService.InputBegan:Connect(Fly.inputBegan)
    UserInputService.InputEnded:Connect(Fly.inputEnded)
end

return Fly
