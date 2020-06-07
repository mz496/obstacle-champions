local PlayerToolManager = require(game.ServerStorage.Scripts.PlayerToolManager)
local GameRunner = require(game.ServerScriptService.Server.GameRunner)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

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
end

ServerAdmin.incrementRoundScore = function(--[[Player]] p, --[[number]] increment)
    GameRunner.incrementRoundScore(p, increment)
end

ServerAdmin.removeActivePlayer = function(--[[Player]] p)
    GameRunner.removeActivePlayer(p)
end


return ServerAdmin
