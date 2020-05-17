local Utils = require(game.ReplicatedStorage.Scripts.Utils)

-- Static class that loads maps
local ModelLoader = {}

ModelLoader.loadModel = --[[Object]] function(--[[Model]] model, --[[CFrame]] destCFrame)
    local anchor = model.PrimaryPart
    if anchor == nil then
        Utils.logError("Model PrimaryPart not found")
        return
    end

    modelCopy = model:Clone()
    modelCopy.Parent = game.Workspace
    modelCopy:SetPrimaryPartCFrame(destCFrame)
    return modelCopy
end

return ModelLoader
