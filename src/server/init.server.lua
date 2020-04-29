print("Hello world, from server!")

local TestEZ = require(game.ReplicatedStorage.Common.TestEZ)
local Utils = require(game.ReplicatedStorage.Common.Utils)
local MapLoader = require(game.ServerStorage.Scripts.MapLoader)

tests = {game.ServerScriptService.Server}
TestEZ.TestBootstrap:run(tests, nil, nil)

MapLoader.loadMap(game.Workspace.Pile, CFrame.new(Vector3.new(0, 10, 0)))
Utils.logInfo("Loaded map!")

