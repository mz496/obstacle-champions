print("Hello world, from client!")

local Utils = require(game.ReplicatedStorage.Scripts.Utils)

Utils.logInfo(game.Players.LocalPlayer.Name .. " joined the game")
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
