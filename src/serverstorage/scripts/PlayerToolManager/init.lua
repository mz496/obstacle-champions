local Utils = require(game.ReplicatedStorage.Common.Utils)

local PlayerToolManager = {}

PlayerToolManager.grantTool = function(--[[Tool]] tool, --[[Player]] player)
    local playerTool = tool:Clone()
    playerTool.Parent = player.Backpack
    Utils.logInfo("Granted player " .. player.Name .. " tool " .. tool.Name)
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
