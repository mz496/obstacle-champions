local Utils = require(game.ReplicatedStorage.Common.Utils)
local MapLoader = require(game.ReplicatedStorage.Common.MapLoader)
for i,c in pairs(script.Parent:GetChildren()) do
    print(i)
    print(c)
end
local Fly = require(script.Parent:WaitForChild("Fly"))

local tool = script.Parent
local player = game.Players.LocalPlayer

-- Places voxels' center coordinates at multiples of VOXEL_SIZE
local VOXEL_SIZE = 10

local boundingBoxIsActive = false
local boundingBoxRef = nil
local boundedObjectRef = nil
local worldCoordinatesMouseLocation = nil
local voxelCenterMouseLocation = nil

-- Returns the center of the voxel to which p belongs
local getVoxelCenter = --[[Vector3]] function(--[[Vector3]] p)
    local voxelX = Utils.round(p.X/VOXEL_SIZE) * VOXEL_SIZE
    local voxelY = Utils.round(p.Y/VOXEL_SIZE) * VOXEL_SIZE
    local voxelZ = Utils.round(p.Z/VOXEL_SIZE) * VOXEL_SIZE
    return Vector3.new(voxelX, voxelY, voxelZ)
end

-- Returns the center of the farthest observed voxel along a vector from s to t
-- Take a point along the s-t vector almost at t but just a bit toward s and find its corresponding voxel
local getFarthestVisibleVoxelCenter = --[[Vector3]] function(--[[Vector3]] s, --[[Vector3]] t, --[[Object]] target)
    local epsilon = nil
    if (target ~= nil and target.Parent == boundedObjectRef) then
        epsilon = -0.001
    else
        epsilon = 0.001
    end
    local epsilonST = (t-s) * epsilon
    local TminusEpsilonST = t - epsilonST
    return getVoxelCenter(TminusEpsilonST)
end

local renderBoundingBox = --[[void]] function(--[[Vector3]] center)
    --[[ Viewed from the top front:
    21
    34

    65
    78
    ]]
    local p1 = center + Vector3.new(VOXEL_SIZE/2, VOXEL_SIZE/2, VOXEL_SIZE/2)
    local p2 = p1 + Vector3.new(-VOXEL_SIZE, 0, 0)
    local p3 = p2 + Vector3.new(0, 0, -VOXEL_SIZE)
    local p4 = p3 + Vector3.new(VOXEL_SIZE, 0, 0)
    local p5 = p1 + Vector3.new(0, -VOXEL_SIZE, 0)
    local p6 = p2 + Vector3.new(0, -VOXEL_SIZE, 0)
    local p7 = p3 + Vector3.new(0, -VOXEL_SIZE, 0)
    local p8 = p4 + Vector3.new(0, -VOXEL_SIZE, 0)
    local color = ColorSequence.new(Color3.new(0,1,1))
    local box = Instance.new("Model")
    box.Name = "BoundingBox"
    box.Parent = game.Workspace.Terrain
    boundingBoxRef = box

    Utils.placeBeam(p1, p2, "e12", color, box)
    Utils.placeBeam(p2, p3, "e23", color, box)
    Utils.placeBeam(p3, p4, "e34", color, box)
    Utils.placeBeam(p4, p1, "e41", color, box)

    Utils.placeBeam(p5, p6, "e56", color, box)
    Utils.placeBeam(p6, p7, "e67", color, box)
    Utils.placeBeam(p7, p8, "e78", color, box)
    Utils.placeBeam(p8, p5, "e85", color, box)

    Utils.placeBeam(p1, p5, "e15", color, box)
    Utils.placeBeam(p2, p6, "e26", color, box)
    Utils.placeBeam(p3, p7, "e37", color, box)
    Utils.placeBeam(p4, p8, "e48", color, box)

    boundedObjectRef = MapLoader.loadMap(game.Workspace.TestObstacle, CFrame.new(center))
    boundingBoxIsActive = true
end

--TODO: make a function that also moves a bounding box

local attemptToDestroyBoundingBox = --[[void]] function()
    if (boundingBoxIsActive == true) then
        boundingBoxIsActive = false
        boundingBoxRef:Destroy()
        boundingBoxRef.Parent = nil
        boundedObjectRef:Destroy()
        boundedObjectRef.Parent = nil
    end
end

-- EVENT HOOKS
local onEquip = function(mouse)
    Utils.logDebug(player.Name .. " equipped " .. tool.Name)
    local onMouseMove = function()
        local s = player.Character.HumanoidRootPart.CFrame.p
        local t = mouse.Hit.p
        local target = mouse.Target
        worldCoordinatesMouseLocation = t
        local currentVoxelCenterMouseLocation = getFarthestVisibleVoxelCenter(s, t, target)
        if (currentVoxelCenterMouseLocation ~= voxelCenterMouseLocation) then
            -- This should only happen the first time the tool is equipped
            attemptToDestroyBoundingBox()
            renderBoundingBox(currentVoxelCenterMouseLocation)
            --Utils.visualizeRay(Ray.new(s, worldCoordinatesMouseLocation - s))
            voxelCenterMouseLocation = currentVoxelCenterMouseLocation
            Utils.logInfo("Selected voxel changed: "..Utils.toStringVector3(voxelCenterMouseLocation))
        end
        --renderBoundingBox(getFarthestVisibleVoxelCenter(s, t))
        --Utils.placeMarker(getFarthestVisibleVoxelCenter(s, t), "n", game.Workspace.Terrain)
        --Utils.visualizeRay(Ray.new(s, t-s))
    end
    mouse.Move:Connect(onMouseMove)
    Fly.bindListeners()
end
local onUnequip = function()
    attemptToDestroyBoundingBox()
    Utils.logDebug(player.Name .. " unequipped " .. tool.Name)
end
local onActivate = function()
    Utils.logDebug(player.Name .. " activated " .. tool.Name)
    -- TODO: convert rotation from deg vector into actual direction
    local rayLook = Ray.new(player.Character.HumanoidRootPart.CFrame.p, player.Character.HumanoidRootPart.CFrame.LookVector)
    local rayUp = Ray.new(player.Character.HumanoidRootPart.CFrame.p, player.Character.HumanoidRootPart.CFrame.UpVector)
    local rayRight = Ray.new(player.Character.HumanoidRootPart.CFrame.p, player.Character.HumanoidRootPart.CFrame.RightVector)
    --Utils.logDebug(Utils.toStringRay(rayFacing))
    Utils.visualizeRay(rayLook.Unit)
    Utils.visualizeRay(rayUp.Unit)
    Utils.visualizeRay(rayRight.Unit)
    --[[
    local vector2CursorPosition = game:GetService("UserInputService"):GetMouseLocation()
    local rayViewport = game.Workspace.CurrentCamera:ViewportPointToRay(vector2CursorPosition.x, vector2CursorPosition.y, 0)
    Utils.logInfo(player.Name .. " ray " .. Utils.toStringRay(rayViewport))
    rayViewportExtended = Ray.new(rayViewport.Origin, rayViewport.Direction * 100)
    Utils.visualizeRay(rayViewportExtended)
    ]]

end
local onDeactivate = function()
    Utils.logDebug(player.Name .. " deactivated " .. tool.Name)
end

tool.Equipped:Connect(onEquip)
tool.Unequipped:Connect(onUnequip)
tool.Activated:Connect(onActivate)
tool.Deactivated:Connect(onDeactivate)