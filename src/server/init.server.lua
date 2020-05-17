print("Hello world, from server!")

local TestEZ = require(game.ReplicatedStorage.Scripts.TestEZ)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local MapLoader = require(game.ReplicatedStorage.Scripts.MapLoader)
local PlayerToolManager = require(game.ServerStorage.Scripts.PlayerToolManager)
local ServerAdmin = require(game.ServerStorage.Scripts.ServerAdmin)

tests = {game.ServerScriptService.Server}
TestEZ.TestBootstrap:run(tests, nil, nil)

MapLoader.loadMap(game.Workspace.Pile, CFrame.new(Vector3.new(0, 10, 0)))
Utils.logInfo("Loaded map!")

local onClientPlaceObstacle = function(player, --[[CFrame]] obstacleCFrame)
    print(player.Name.."placed obstacle at "..Utils.toStringVector3(obstacleCFrame.p))
    MapLoader.loadMap(game.ReplicatedStorage.Models.Obstacle_Test, obstacleCFrame)
    return true
end
game.ReplicatedStorage.Remote.Function_PlaceObstacle.OnServerInvoke = onClientPlaceObstacle
