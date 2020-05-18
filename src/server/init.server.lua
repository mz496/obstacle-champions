print("Hello world, from server!")

local TestEZ = require(game.ReplicatedStorage.Scripts.TestEZ)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local ModelLoader = require(game.ReplicatedStorage.Scripts.ModelLoader)
local PlayerToolManager = require(game.ServerStorage.Scripts.PlayerToolManager)

tests = {game.ServerScriptService.Server}
TestEZ.TestBootstrap:run(tests, nil, nil)

ModelLoader.loadModel(game.Workspace.Pile, CFrame.new(Vector3.new(0, 10, 0)))
Utils.logInfo("Loaded map!")

local onClientPlaceObstacle = function(player, --[[CFrame]] obstacleCFrame)
    print(player.Name.."placed obstacle at "..Utils.toStringVector3(obstacleCFrame.p))
    ModelLoader.loadModel(game.ReplicatedStorage.Models.Obstacle_Test, obstacleCFrame)
    return true
end
game.ReplicatedStorage.Remote.Function_PlaceObstacle.OnServerInvoke = onClientPlaceObstacle

--[[
local s = require(game.ServerStorage.Scripts.ServerAdmin)

s.grantVoxelSelector(game.Players.LEG0builder)
s.removeVoxelSelector(game.Players.LEG0builder)
]]
