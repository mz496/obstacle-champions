local Utils = require(game.ReplicatedStorage.Scripts.Utils)
-- Other scripts in this tool may not have replicated yet?
local InputRouter = require(script.Parent:WaitForChild("InputRouter"))
local Fly = require(script.Parent:WaitForChild("Fly"))
local Manipulate = require(script.Parent:WaitForChild("Manipulate"))
local ModelPreview = require(script.Parent:WaitForChild("ModelPreview"))

local tool = script.Parent
local player = game.Players.LocalPlayer

local onEquip = function(mouse)
    Utils.logDebug(player.Name .. " equipped " .. tool.Name)
    InputRouter.bindListeners()
    Manipulate.activateInputs()
    Fly.construct()

    local onMouseMove = function()
        local sCFrame = player.Character.HumanoidRootPart.CFrame
        local tCFrame = mouse.Hit
        local s = sCFrame.p
        local t = tCFrame.p

        Fly.updateGyroTargetCFrame(tCFrame)
        Fly.updateTrajectory(sCFrame)
        --Utils.visualizeRay(Ray.new(s, t - s))
        ModelPreview.renderPreview(s, t, mouse.Target)
    end
    mouse.Move:Connect(onMouseMove)
end
local onUnequip = function()
    Utils.logDebug(player.Name .. " unequipped " .. tool.Name)
    InputRouter.unbindListeners()
    Manipulate.deactivateAllInputs()
    Fly.deconstruct()
    ModelPreview.clearPreview()
end

local onActivate = function()
    Utils.logDebug(player.Name .. " activated " .. tool.Name)
    if (ModelPreview.isActive()) then
        game.ReplicatedStorage.Remote.Function_PlaceObstacle:InvokeServer(ModelPreview.getPreviewCFrame())
        ModelPreview.clearPreview()
    else
        Utils.logInfo(player.Name .. " activated tool but preview was not active")
    end
end
local onDeactivate = function()
    Utils.logDebug(player.Name .. " deactivated " .. tool.Name)
end

tool.Equipped:Connect(onEquip)
tool.Unequipped:Connect(onUnequip)
tool.Activated:Connect(onActivate)
tool.Deactivated:Connect(onDeactivate)
