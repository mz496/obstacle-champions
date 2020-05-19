local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local ModelPreview = require(script.Parent.ModelPreview)
local ElevateDirection = require(script.Parent.ElevateDirection)
local Elevate = {}

Elevate.INPUTS = {
    [Enum.KeyCode.V.Name] = ElevateDirection("ElevateDown",
        function(coord) return coord - ModelPreview.VOXEL_SIZE end),
    [Enum.KeyCode.B.Name] = ElevateDirection("ElevateUp",
        function(coord) return coord + ModelPreview.VOXEL_SIZE end),
}

Elevate.inputBegan = function(input, gameProcessedEvent)
    local elevateDirectionObject = Elevate.INPUTS[input.KeyCode.Name]
    Utils.logDebug("Applying elevation direction: " .. elevateDirectionObject:getName())
    ModelPreview.setPreviewPlane(elevateDirectionObject:getNewElevation(ModelPreview.getPreviewPlane()))
end

Elevate.inputEnded = function(input, gameProcessedEvent)
    return
end

return Elevate
