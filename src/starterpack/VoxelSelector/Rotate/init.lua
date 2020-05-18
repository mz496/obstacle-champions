local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local ModelPreview = require(script.Parent:WaitForChild("ModelPreview"))
local Rotate = {}

Rotate.INPUTS = {
    [Enum.KeyCode.Q.Name] = 0,
}

-- Like Z axis in right-handed coordinates
Rotate.rotateAboutUp = function(rad)
    return
end

-- Like Y axis in right-handed coordinates
Rotate.rotateAboutLook = function(rad)
    return
end

-- Like X axis in right-handed coordinates
Rotate.rotateAboutRight = function(rad)
    return
end

Rotate.inputBegan = function(input, gameProcessedEvent)
    return
end

Rotate.inputEnded = function(input, gameProcessedEvent)
    return
end

Rotate.construct = function()
    return
end

Rotate.deconstruct = function()
    return
end

return Rotate
