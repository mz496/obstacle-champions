local Utils = require(game.ReplicatedStorage.Scripts.Utils)
-- Other scripts in this tool may not have replicated yet?
local Fly = require(script.Parent:WaitForChild("Fly"))
local VoxelPreview = require(script.Parent:WaitForChild("VoxelPreview"))

local tool = script.Parent
local player = game.Players.LocalPlayer

local onEquip = function(mouse)
    Utils.logDebug(player.Name .. " equipped " .. tool.Name)
    Fly.construct()

    local onMouseMove = function()
        local sCFrame = player.Character.HumanoidRootPart.CFrame
        local tCFrame = mouse.Hit
        local s = sCFrame.p
        local t = tCFrame.p

        Fly.updateGyroTargetCFrame(tCFrame)
        Fly.updateTrajectory(sCFrame)
        --Utils.visualizeRay(Ray.new(s, t - s))
        VoxelPreview.renderPreview(s, t, mouse.Target)
    end
    mouse.Move:Connect(onMouseMove)
end
local onUnequip = function()
    Utils.logDebug(player.Name .. " unequipped " .. tool.Name)
    Fly.deconstruct()

    VoxelPreview.deconstruct()
end

local onActivate = function()
    Utils.logDebug(player.Name .. " activated " .. tool.Name)

end
local onDeactivate = function()
    Utils.logDebug(player.Name .. " deactivated " .. tool.Name)
end

tool.Equipped:Connect(onEquip)
tool.Unequipped:Connect(onUnequip)
tool.Activated:Connect(onActivate)
tool.Deactivated:Connect(onDeactivate)
