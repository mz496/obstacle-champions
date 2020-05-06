print("Hello world, from server!")

local TestEZ = require(game.ReplicatedStorage.Common.TestEZ)
local Utils = require(game.ReplicatedStorage.Common.Utils)
local MapLoader = require(game.ReplicatedStorage.Common.MapLoader)
local PlayerToolManager = require(game.ServerStorage.Scripts.PlayerToolManager)
local ServerAdmin = require(game.ServerStorage.Scripts.ServerAdmin)

tests = {game.ServerScriptService.Server}
TestEZ.TestBootstrap:run(tests, nil, nil)

MapLoader.loadMap(game.Workspace.Pile, CFrame.new(Vector3.new(0, 10, 0)))
Utils.logInfo("Loaded map!")

local me = game.Players:WaitForChild("LEG0builder")
Utils.logInfo("Server saw that "..me.Name.." joined")
