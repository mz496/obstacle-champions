local PlayerToolManager = require(game.ServerStorage.Scripts.PlayerToolManager)

local ServerAdmin = {}

ServerAdmin.grantVoxelSelector = function(--[[String]] playerName)
    PlayerToolManager.grantTool(game.ServerStorage.Tools.VoxelSelector, game.Players[playerName])
end

return ServerAdmin
