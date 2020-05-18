local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local PlayerToolManager = {}

local hasTool = function(--[[Tool]] tool, --[[Player]] player)
    local isEquipped = false
    local heldTool = player.Backpack:FindFirstChild(tool.Name)
    if (heldTool == nil) then
        heldTool = player.Character:FindFirstChild(tool.Name)
        if (heldTool == nil) then
            Utils.logDebug(player.Name .. " does not have tool " .. tool.Name)
            return nil
        end
        isEquipped = true
    end
    Utils.logDebug(player.Name .. " has tool " .. tool.Name .. " (isEquipped=" .. Utils.toStringBoolean(isEquipped) ..")")
    return heldTool
end

PlayerToolManager.grantTool = function(--[[Tool]] tool, --[[Player]] player)
    if (hasTool(tool, player) ~= nil) then return end
    local playerTool = tool:Clone()
    playerTool.Parent = player.Backpack
    player.Character.Humanoid:EquipTool(playerTool)
    Utils.logInfo("Granted player " .. player.Name .. " tool " .. playerTool.Name)
end

PlayerToolManager.removeTool = function(--[[Tool]] tool, --[[Player]] player)
    local playerTool = hasTool(tool, player)
    if (playerTool == nil) then return end
    player.Character.Humanoid:UnequipTools()
    playerTool:Destroy()
    playerTool = nil
end

return PlayerToolManager
