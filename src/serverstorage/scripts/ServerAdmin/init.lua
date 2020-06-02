local PlayerToolManager = require(game.ServerStorage.Scripts.PlayerToolManager)

local ServerAdmin = {}

ServerAdmin.grantVoxelSelector = function(--[[Player]] p)
    PlayerToolManager.grantTool(game.ServerStorage.Tools.VoxelSelector, p)
end

ServerAdmin.removeVoxelSelector = function(--[[Player]] p)
    PlayerToolManager.removeTool(game.ServerStorage.Tools.VoxelSelector, p)
end

ServerAdmin.kill = function(--[[Player]] p)
    p.Character.Humanoid.Health = 0
end

ServerAdmin.removeActivePlayer = function(--[[Player]] p)
    game.Players[p]:Destroy()
    game.Players[p].Parent = nil

return ServerAdmin
