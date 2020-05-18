local PlayerToolManager = require(game.ServerStorage.Scripts.PlayerToolManager)

local ServerAdmin = {}

ServerAdmin.grantVoxelSelector = function(--[[Player]] p)
    PlayerToolManager.grantTool(game.ServerStorage.Tools.VoxelSelector, p)
end

ServerAdmin.removeVoxelSelector = function(--[[Player]] p)
    PlayerToolManager.removeTool(game.ServerStorage.Tools.VoxelSelector, p)
end

return ServerAdmin
