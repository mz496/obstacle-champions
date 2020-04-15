print("Hello world, from server!")

local TestEZ = require(game.ReplicatedStorage.Common.TestEZ)

tests = {game.ServerScriptService.Server}
TestEZ.TestBootstrap:run(tests, nil, nil)
