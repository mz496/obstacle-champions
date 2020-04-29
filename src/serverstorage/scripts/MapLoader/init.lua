local Utils = require(game.ReplicatedStorage.Common.Utils)

-- Static class that loads maps
local MapLoader = {}

MapLoader.loadMap = function(--[[Model]] model, --[[CFrame]] destCFrame)
    local anchor = model.PrimaryPart
    if anchor == nil then
        Utils.logError("Map PrimaryPart not found")
        return
    end

    modelCopy = model:Clone()
    modelCopy.Parent = game.Workspace
    modelCopy:SetPrimaryPartCFrame(destCFrame)
end

return MapLoader

