print("Hello world, from client!")

local Utils = require(game.ReplicatedStorage.Common.Utils)
local player = script.Parent.Parent

Utils.logInfo(player.Name .. " joined the game")
