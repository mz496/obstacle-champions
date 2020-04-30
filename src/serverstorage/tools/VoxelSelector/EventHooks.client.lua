local Utils = require(game.ReplicatedStorage.Common.Utils)

local tool = script.Parent
local player = game.Players.LocalPlayer

local onEquip = function(mouse)
    Utils.logInfo(player.Name .. " equipped " .. tool.Name)
    local onMouseMove = function()
        local s = player.Character.HumanoidRootPart.CFrame.p
        local t = mouse.Hit.p
        Utils.visualizeRay(Ray.new(s, t-s))
    end
    mouse.Move:Connect(onMouseMove)
end
local onUnequip = function()
    Utils.logInfo(player.Name .. " unequipped " .. tool.Name)
end
local onActivate = function()
    Utils.logInfo(player.Name .. " activated " .. tool.Name)
    --[[
    local vector2CursorPosition = game:GetService("UserInputService"):GetMouseLocation()
    local rayViewport = game.Workspace.CurrentCamera:ViewportPointToRay(vector2CursorPosition.x, vector2CursorPosition.y, 0)
    Utils.logInfo(player.Name .. " ray " .. Utils.toStringRay(rayViewport))
    rayViewportExtended = Ray.new(rayViewport.Origin, rayViewport.Direction * 100)
    Utils.visualizeRay(rayViewportExtended)
    ]]

end
local onDeactivate = function()
    Utils.logInfo(player.Name .. " deactivated " .. tool.Name)
end

tool.Equipped:Connect(onEquip)
tool.Unequipped:Connect(onUnequip)
tool.Activated:Connect(onActivate)
tool.Deactivated:Connect(onDeactivate)
