local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local PlayerToolManager = {}

PlayerToolManager.grantTool = function(--[[Tool]] tool, --[[Player]] player)
    local playerTool = tool:Clone()
    playerTool.Parent = player.Backpack
    for i,c in pairs(playerTool:GetChildren()) do
        print("in ptm")
        print(i)
        print(c)
    end
    for i,c in pairs(player.Backpack:GetChildren()) do
        print(i); print(c)
    end
    Utils.logInfo("Granted player " .. player.Name .. " tool " .. playerTool.Name)
end

PlayerToolManager.removeTool = function(--[[Tool]] tool, --[[Player]] player)
    local playerTool = player.Backpack:FindFirstChild(tool)
    if playerTool == nil then
        Utils.logError("Tool " .. tool.Name .. " was not found in player's backpack")
        return
    end

    player.Backpack.playerTool:Destroy()
    player.Backpack.playerTool = nil
end

return PlayerToolManager
