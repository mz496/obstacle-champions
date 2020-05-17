local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local MapLoader = require(game.ReplicatedStorage.Scripts.MapLoader)
local VoxelPreview = {}

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
local getFarthestVisibleVoxelCenter = --[[Vector3]] function(--[[Vector3]] s, --[[Vector3]] t, --[[Part]] target)
    local epsilon = 1e-3
    if (target ~= nil and target.Parent == boundedObjectRef) then
        epsilon = -epsilon
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

    boundedObjectRef = MapLoader.loadMap(game.ReplicatedStorage.Models.Obstacle_Test, CFrame.new(center))
    boundingBoxIsActive = true
end

local attemptToDestroyBoundingBox = --[[void]] function()
    if (boundingBoxIsActive == true) then
        boundingBoxIsActive = false
        boundingBoxRef:Destroy()
        boundingBoxRef.Parent = nil
        boundedObjectRef:Destroy()
        boundedObjectRef.Parent = nil
    end
end

VoxelPreview.renderPreview = --[[void]] function(--[[Vector3]] s, --[[Vector3]] t, --[[Part]] targetPart)
    local currentVoxelCenterMouseLocation = getFarthestVisibleVoxelCenter(s, t, targetPart)
    if (currentVoxelCenterMouseLocation ~= voxelCenterMouseLocation) then
        -- This should only happen the first time the tool is equipped
        attemptToDestroyBoundingBox()
        renderBoundingBox(currentVoxelCenterMouseLocation)
        --Utils.visualizeRay(Ray.new(s, worldCoordinatesMouseLocation - s))
        voxelCenterMouseLocation = currentVoxelCenterMouseLocation
        Utils.logInfo("Selected voxel changed: "..Utils.toStringVector3(voxelCenterMouseLocation))
    end
end

VoxelPreview.deconstruct = --[[void]] function()
    attemptToDestroyBoundingBox()
end

return VoxelPreview
