local Utils = require(game.ReplicatedStorage.Common.Utils)

local tool = script.Parent
local player = game.Players.LocalPlayer

-- Places voxels' center coordinates at multiples of VOXEL_SIZE
local VOXEL_SIZE = 10

-- Returns the center of the voxel to which p belongs
local getVoxelCenter = --[[Vector3]] function(--[[Vector3]] p)
    local voxelX = Utils.round(p.X/VOXEL_SIZE) * VOXEL_SIZE
    local voxelY = Utils.round(p.Y/VOXEL_SIZE) * VOXEL_SIZE
    local voxelZ = Utils.round(p.Z/VOXEL_SIZE) * VOXEL_SIZE
    return Vector3.new(voxelX, voxelY, voxelZ)
end

-- Returns the center of the farthest observed voxel along a vector from s to t
-- Take a point along the s-t vector almost at t but just a bit toward s and find its corresponding voxel
local getFarthestVisibleVoxelCenter = --[[Vector3]] function(--[[Vector3]] s, --[[Vector3]] t)
    local epsilon = 0.001
    local epsilonST = (t-s) * epsilon
    local TminusEpsilonST = t - epsilonST
    return getVoxelCenter(TminusEpsilonST)
end

-- EVENT HOOKS
local onEquip = function(mouse)
    Utils.logInfo(player.Name .. " equipped " .. tool.Name)
    local onMouseMove = function()
        local s = player.Character.HumanoidRootPart.CFrame.p
        local t = mouse.Hit.p
        local los = Ray.new(s, t-s)
        local losUnit = los.Unit
        Utils.placeMarker(getFarthestVisibleVoxelCenter(s, t), "n", game.Workspace.Terrain)
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
