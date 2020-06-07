print("Hello world, from server!")

local TestEZ = require(game.ReplicatedStorage.Scripts.TestEZ)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local ModelLoader = require(game.ReplicatedStorage.Scripts.ModelLoader)
local PlayerToolManager = require(game.ServerStorage.Scripts.PlayerToolManager)
local GameLifecycleManager = require(game.ServerScriptService.Server.GameLifecycleManager)
local GameRunner = require(game.ServerScriptService.Server.GameRunner)
local GameLifecycleConstants = require(game.ServerScriptService.Server.Constants.GameLifecycle)
local States = GameLifecycleConstants.States
local Events = GameLifecycleConstants.Events

tests = {game.ServerScriptService.Server}
TestEZ.TestBootstrap:run(tests, nil, nil)

ModelLoader.loadModel(game.Workspace.Pile, CFrame.new(Vector3.new(0, 10, 0)))
Utils.logInfo("Loaded map!")

GameRunner.init()

local onPlayerPlaceObstacle = function(player, --[[CFrame]] obstacleCFrame)
    print(player.Name.." placed obstacle at "..Utils.toStringVector3(obstacleCFrame.p))
    print("TEMPORARY SWITCH: sending no-one-in-progress event")
    gameRunner.noOneInProgress()
    ModelLoader.loadModel(game.ReplicatedStorage.Models.Obstacle_Test, obstacleCFrame)
    return true
end
game.ReplicatedStorage.Remote.Function_PlaceObstacle.OnServerInvoke = onPlayerPlaceObstacle

local onPlayerDied = function(player)
    print(player.Name.." died")
end
game.ReplicatedStorage.Remote.Function_Died.OnServerInvoke = onPlayerDied

local onPlayerLeft = function(player)
    print(player.Name.." left")
    GameRunner.removePlayer(player)
end
game.Players.PlayerRemoving:Connect(onPlayerLeft)

game.Players.PlayerAdded:Connect(function(player)
    print("A player was added, starting game now")
    GameRunner.addQueuedPlayer(player)
    GameRunner.startGame()
end)

--[[
local s = require(game.ServerStorage.Scripts.ServerAdmin);

s.grantVoxelSelector(game.Players.LEG0builder)
s.removeVoxelSelector(game.Players.LEG0builder)
s.kill(game.Players.LEG0builder)
s.incrementRoundScore(game.Players.LEG0builder, 1000)
]]
