print("Hello world, from server!")

local TestEZ = require(game.ReplicatedStorage.Common.TestEZ)
local Utils = require(game.ReplicatedStorage.Common.Utils)
local MapLoader = require(game.ReplicatedStorage.Common.MapLoader)
local PlayerToolManager = require(game.ServerStorage.Scripts.PlayerToolManager)

tests = {game.ServerScriptService.Server}
TestEZ.TestBootstrap:run(tests, nil, nil)

MapLoader.loadMap(game.Workspace.Pile, CFrame.new(Vector3.new(0, 10, 0)))
Utils.logInfo("Loaded map!")

-- Temporary, for debugging tools
local voxelTool = game.ServerStorage.Tools.VoxelSelector:Clone()
voxelTool.Parent = game.StarterPack
