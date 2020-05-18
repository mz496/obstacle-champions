local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local Fly = require(script.Parent:WaitForChild("Fly"))
local Rotate = require(script.Parent:WaitForChild("Rotate"))
local InputRouter = {}

-- Connection instances for bound event listeners
local UserInputService = game:GetService("UserInputService")
local INPUT_BEGAN_CONNECTION = nil
local INPUT_ENDED_CONNECTION = nil

local routeInputBegan = function(input, gameProcessedEvent)
    if (Fly.INPUTS[input.KeyCode.Name] ~= nil) then
        Utils.logDebug("Routing input began to Fly: " .. input.KeyCode.Name)
        Fly.inputBegan(input, gameProcessedEvent)
    elseif (Rotate.INPUTS[input.KeyCode.Name] ~= nil) then
        Utils.logDebug("Routing input began to Rotate: " .. input.KeyCode.Name)
        Rotate.inputBegan(input, gameProcessedEvent)
    else
        Utils.logDebug("Dropping unrouted input began: " .. input.KeyCode.Name)
    end
end

local routeInputEnded = function(input, gameProcessedEvent)
    if (Fly.INPUTS[input.KeyCode.Name] ~= nil) then
        Utils.logDebug("Routing input ended to Fly: " .. input.KeyCode.Name)
        Fly.inputEnded(input, gameProcessedEvent)
    elseif (Rotate.INPUTS[input.KeyCode.Name] ~= nil) then
        Utils.logDebug("Routing input ended to Rotate: " .. input.KeyCode.Name)
        Rotate.inputEnded(input, gameProcessedEvent)
    else
        Utils.logDebug("Dropping unrouted input ended: " .. input.KeyCode.Name)
    end
end

InputRouter.bindListeners = function()
    INPUT_BEGAN_CONNECTION = UserInputService.InputBegan:Connect(routeInputBegan)
    INPUT_ENDED_CONNECTION = UserInputService.InputEnded:Connect(routeInputEnded)
end

InputRouter.unbindListeners = function()
    INPUT_BEGAN_CONNECTION:Disconnect()
    INPUT_ENDED_CONNECTION:Disconnect()
end

return InputRouter
