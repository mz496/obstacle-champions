local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local ModelLoader = require(game.ReplicatedStorage.Scripts.ModelLoader)
local ModelPreview = {}

-- Places voxels' center coordinates at multiples of VOXEL_SIZE
ModelPreview.VOXEL_SIZE = 10
-- TODO: generalize to any obstacle
local MODEL_TO_PREVIEW = game.ReplicatedStorage.Models.Obstacle_Test

local MODEL_BOUNDING_BOX = nil
local MODEL_BOUNDED_OBJECT = nil
local _cFramePreviewPosition = nil

-- Contains the angle rotation only for the preview, so that when moving around the preview, the rotation angle doesn't change
local _cFrameAnglesOnly = nil

-- Y-coordinate of the manipulation plane (where all mouse input gets translated to updating preview)
local _coordPreviewPlane = 6

-- Returns the center of the voxel to which p belongs
local getVoxelCenter = --[[Vector3]] function(--[[Vector3]] p)
    local voxelX = Utils.round(p.X/ModelPreview.VOXEL_SIZE) * ModelPreview.VOXEL_SIZE
    local voxelY = Utils.round(p.Y/ModelPreview.VOXEL_SIZE) * ModelPreview.VOXEL_SIZE
    local voxelZ = Utils.round(p.Z/ModelPreview.VOXEL_SIZE) * ModelPreview.VOXEL_SIZE
    return Vector3.new(voxelX, voxelY, voxelZ)
end

-- Extend vector st until it hits plane y=_coordPreviewPlane and find closest voxel center to the intersection
ModelPreview.getPreviewCenter = --[[CFrame]] function(--[[Vector3]] s, --[[Vector3]] t, --[[Part]] target)
    --[[
    local epsilon = 1e-3
    if (target ~= nil and target.Parent == MODEL_BOUNDED_OBJECT) then
        epsilon = -epsilon
    end
    local epsilonST = (t-s) * epsilon
    local TminusEpsilonST = t - epsilonST
    return getVoxelCenter(TminusEpsilonST)
    ]]
    local r = (_coordPreviewPlane - s.Y) / (t.Y - s.Y)
    Utils.visualizeRay(Ray.new(s, r*(t-s)))
    return CFrame.new(getVoxelCenter(s + r * (t - s)))
end

-- Initialize preview, where the model to preview's primary part is centered around goal CFrame
local initializePreview = --[[void]] function(--[[Vector3]] center, --[[Model]] modelToPreview)
    --[[ Viewed from the top front:
    21
    34

    65
    78
    ]]
    local p1 = center + Vector3.new(ModelPreview.VOXEL_SIZE/2, ModelPreview.VOXEL_SIZE/2, ModelPreview.VOXEL_SIZE/2)
    local p2 = p1 + Vector3.new(-ModelPreview.VOXEL_SIZE, 0, 0)
    local p3 = p2 + Vector3.new(0, 0, -ModelPreview.VOXEL_SIZE)
    local p4 = p3 + Vector3.new(ModelPreview.VOXEL_SIZE, 0, 0)
    local p5 = p1 + Vector3.new(0, -ModelPreview.VOXEL_SIZE, 0)
    local p6 = p2 + Vector3.new(0, -ModelPreview.VOXEL_SIZE, 0)
    local p7 = p3 + Vector3.new(0, -ModelPreview.VOXEL_SIZE, 0)
    local p8 = p4 + Vector3.new(0, -ModelPreview.VOXEL_SIZE, 0)
    local color = ColorSequence.new(Color3.new(0,1,1))

    MODEL_BOUNDING_BOX = Instance.new("Model")
    MODEL_BOUNDING_BOX.Name = "BoundingBox"
    MODEL_BOUNDING_BOX.Parent = game.Workspace.Terrain

    local anchor = Instance.new("Part")
    anchor.Name = "Anchor"
    anchor.Parent = MODEL_BOUNDING_BOX
    anchor.Size = Vector3.new(1,1,1)
    anchor.Position = center
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

    MODEL_BOUNDED_OBJECT = ModelLoader.loadModel(modelToPreview, CFrame.new(center))
    _cFrameAnglesOnly = CFrame.Angles(0, 0, 0)
end

ModelPreview.getPreviewCFrame = --[[CFrame]] function()
    return MODEL_BOUNDED_OBJECT.PrimaryPart.CFrame
end

ModelPreview.setPreviewCFrameAnglesOnly = --[[void]] function(--[[CFrame]] newCFrameAnglesOnly)
    _cFrameAnglesOnly = newCFrameAnglesOnly - newCFrameAnglesOnly.p
    ModelPreview.renderPreview(ModelPreview.getPreviewCFrame() * _cFrameAnglesOnly)
end

ModelPreview.getPreviewPlane = --[[number]] function()
    return _coordPreviewPlane
end

ModelPreview.setPreviewPlane = --[[void]] function(--[[number]] newPreviewPlane)
    _coordPreviewPlane = newPreviewPlane
    ModelPreview.renderPreview(ModelPreview.getPreviewCFrame() + Vector3.new(0, newPreviewPlane, 0))
end

ModelPreview.isActive = --[[boolean]] function()
    return MODEL_BOUNDED_OBJECT ~= nil
end

ModelPreview.renderPreview = --[[void]] function(--[[CFrame]] cFrame)
    if (cFrame ~= _cFramePreviewPosition) then
        -- This should only happen once, when the tool is equipped
        if (not ModelPreview.isActive()) then
            initializePreview(cFrame.p, MODEL_TO_PREVIEW)
        else
            MODEL_BOUNDED_OBJECT:SetPrimaryPartCFrame(cFrame)
            MODEL_BOUNDING_BOX:SetPrimaryPartCFrame(cFrame)
        end
        _cFramePreviewPosition = cFrame
        Utils.logInfo("Selected voxel changed: "..Utils.toStringVector3(_cFramePreviewPosition.p))
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
