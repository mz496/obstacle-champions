print("Hello world, from client!")

local Utils = require(game.ReplicatedStorage.Scripts.Utils)

Utils.logInfo(game.Players.LocalPlayer.Name .. " joined the game")

-- Make tools unequippable
--game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        Utils.logInfo(game.Players.LocalPlayer.Name .. " died")
        game.ReplicatedStorage.Remote.Function_Died:InvokeServer()
    end)
end)
