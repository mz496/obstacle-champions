local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local ModelLoader = require(game.ReplicatedStorage.Scripts.ModelLoader)
local ModelPreview = {}

-- Places voxels' center coordinates at multiples of VOXEL_SIZE
local VOXEL_SIZE = 10
-- TODO: generalize to any obstacle
local MODEL_TO_PREVIEW = game.ReplicatedStorage.Models.Obstacle_Test

local MODEL_BOUNDING_BOX = nil
local MODEL_BOUNDED_OBJECT = nil
local VECTOR3_PREVIEW_CENTER = nil

-- Returns the center of the voxel to which p belongs
local getVoxelCenter = --[[Vector3]] function(--[[Vector3]] p)
    local voxelX = Utils.round(p.X/VOXEL_SIZE) * VOXEL_SIZE
    local voxelY = Utils.round(p.Y/VOXEL_SIZE) * VOXEL_SIZE
    local voxelZ = Utils.round(p.Z/VOXEL_SIZE) * VOXEL_SIZE
    return Vector3.new(voxelX, voxelY, voxelZ)
end

-- Returns the center of the farthest observed voxel along a vector from s to t
-- Take a point along the s-t vector almost at t but just a bit toward s and find its corresponding voxel
local getPreviewCenter = --[[Vector3]] function(--[[Vector3]] s, --[[Vector3]] t, --[[Part]] target)
    local epsilon = 1e-3
    if (target ~= nil and target.Parent == MODEL_BOUNDED_OBJECT) then
        epsilon = -epsilon
    end
    local epsilonST = (t-s) * epsilon
    local TminusEpsilonST = t - epsilonST
    return getVoxelCenter(TminusEpsilonST)
end

-- Initialize preview, where the model to preview's primary part is centered around goal CFrame
local initializePreview = --[[void]] function(--[[CFrame]] goalCFrame, --[[Model]] modelToPreview)
    --[[ Viewed from the top front:
    21
    34

    65
    78
    ]]
    local center = goalCFrame.p
    local p1 = center + Vector3.new(VOXEL_SIZE/2, VOXEL_SIZE/2, VOXEL_SIZE/2)
    local p2 = p1 + Vector3.new(-VOXEL_SIZE, 0, 0)
    local p3 = p2 + Vector3.new(0, 0, -VOXEL_SIZE)
    local p4 = p3 + Vector3.new(VOXEL_SIZE, 0, 0)
    local p5 = p1 + Vector3.new(0, -VOXEL_SIZE, 0)
    local p6 = p2 + Vector3.new(0, -VOXEL_SIZE, 0)
    local p7 = p3 + Vector3.new(0, -VOXEL_SIZE, 0)
    local p8 = p4 + Vector3.new(0, -VOXEL_SIZE, 0)
    local color = ColorSequence.new(Color3.new(0,1,1))

    MODEL_BOUNDING_BOX = Instance.new("Model")
    MODEL_BOUNDING_BOX.Name = "BoundingBox"
    MODEL_BOUNDING_BOX.Parent = game.Workspace.Terrain

    local anchor = Instance.new("Part")
    anchor.Name = "Anchor"
    anchor.Parent = MODEL_BOUNDING_BOX
    anchor.Size = Vector3.new(1,1,1)
    anchor.CFrame = goalCFrame
    anchor.CanCollide = false
    anchor.Anchored = true
    anchor.Transparency = 1
    MODEL_BOUNDING_BOX.PrimaryPart = anchor

    Utils.placeBeam(p1, p2, "e12", color, MODEL_BOUNDING_BOX)
    Utils.placeBeam(p2, p3, "e23", color, MODEL_BOUNDING_BOX)
    Utils.placeBeam(p3, p4, "e34", color, MODEL_BOUNDING_BOX)
    Utils.placeBeam(p4, p1, "e41", color, MODEL_BOUNDING_BOX)

    Utils.placeBeam(p5, p6, "e56", color, MODEL_BOUNDING_BOX)
    Utils.placeBeam(p6, p7, "e67", color, MODEL_BOUNDING_BOX)
    Utils.placeBeam(p7, p8, "e78", color, MODEL_BOUNDING_BOX)
    Utils.placeBeam(p8, p5, "e85", color, MODEL_BOUNDING_BOX)

    Utils.placeBeam(p1, p5, "e15", color, MODEL_BOUNDING_BOX)
    Utils.placeBeam(p2, p6, "e26", color, MODEL_BOUNDING_BOX)
    Utils.placeBeam(p3, p7, "e37", color, MODEL_BOUNDING_BOX)
    Utils.placeBeam(p4, p8, "e48", color, MODEL_BOUNDING_BOX)

    MODEL_BOUNDED_OBJECT = ModelLoader.loadModel(modelToPreview, goalCFrame)
end

local updatePreview = --[[void]] function(--[[CFrame]] newCFrame)
    MODEL_BOUNDED_OBJECT:SetPrimaryPartCFrame(newCFrame)
    MODEL_BOUNDING_BOX:SetPrimaryPartCFrame(newCFrame)
end

ModelPreview.isActive = --[[boolean]] function()
    return MODEL_BOUNDED_OBJECT ~= nil
end

ModelPreview.getSelectedCFrame = --[[CFrame]] function()
    return MODEL_BOUNDED_OBJECT.PrimaryPart.CFrame
end

ModelPreview.renderPreview = --[[void]] function(--[[Vector3]] s, --[[Vector3]] t, --[[Part]] targetPart)
    local currentPreviewCenter = getPreviewCenter(s, t, targetPart)
    if (currentPreviewCenter ~= VECTOR3_PREVIEW_CENTER) then
        -- CFrame of the preview is the CFrame of its primary part
        -- Rotation matrix should be identity, but the position can be anything
        local previewCFrame = MODEL_TO_PREVIEW.PrimaryPart.CFrame + (-MODEL_TO_PREVIEW.PrimaryPart.CFrame.p + currentPreviewCenter)
        -- This should only happen once, when the tool is equipped
        if (not ModelPreview.isActive()) then
            initializePreview(previewCFrame, MODEL_TO_PREVIEW)
        else
            updatePreview(previewCFrame)
        end
        VECTOR3_PREVIEW_CENTER = currentPreviewCenter
        Utils.logInfo("Selected voxel changed: "..Utils.toStringVector3(VECTOR3_PREVIEW_CENTER))
    end
end

ModelPreview.clearPreview = --[[void]] function()
    if (MODEL_BOUNDING_BOX ~= nil) then
        MODEL_BOUNDING_BOX:Destroy()
        MODEL_BOUNDING_BOX.Parent = nil
        MODEL_BOUNDING_BOX = nil
    end
    if (MODEL_BOUNDED_OBJECT ~= nil) then
        MODEL_BOUNDED_OBJECT:Destroy()
        MODEL_BOUNDED_OBJECT.Parent = nil
        MODEL_BOUNDED_OBJECT = nil
    end
end

return ModelPreview