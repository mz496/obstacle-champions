local Utils = require(game.ReplicatedStorage.Common.Utils)
local Fly = {}

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- The distance to float in a direction when a button is pressed
local MOVE_DISTANCE = 5
local GOALS_MODEL = Instance.new("Model")
GOALS_MODEL.Name = "Goals"
GOALS_MODEL.Parent = game.Workspace.Terrain

local DIRECTIONS = {
    UP="Up",
    DOWN="Down",
    RIGHT="Right",
    LEFT="Left",
    FORWARD="Forward",
    BACKWARD="Backward"}

local getGoalName = --[[string]] function(--[[string]] direction)
    return "Goal:"..direction
end

-- Place goal relative to humanoid root part CFrame
local placeGoal = function(--[[Ray]] ray, --[[string]] direction)
    --Utils.visualizeRay(ray)
    local p = Utils.placeMarker(ray.Origin + ray.Direction, getGoalName(direction), GOALS_MODEL)
    p.Color = Color3.new(1,0,1)
end

local advanceGoal = function()
end

local removeLandmarks = function()
    for _,c in pairs(GOALS_MODEL:GetChildren()) do
        c:Destroy()
        c.Parent = nil
    end
end
local removeDirectionGoal = function(--[[string]] direction)
    local toRemove = GOALS_MODEL:FindFirstChild(getGoalName(direction))
    if (toRemove == nil) then
        Utils.logError("Couldn't remove goal for direction "..direction)
        return
    end
    toRemove:Destroy()
    toRemove.Parent = nil
end

local inputBegan = function(input, gameProcessedEvent)
    local rootCF = player.Character.HumanoidRootPart.CFrame
    if (input.KeyCode == Enum.KeyCode.W) then
        Utils.logInfo("begin w")
        placeGoal(Ray.new(rootCF.p, rootCF.LookVector * MOVE_DISTANCE), DIRECTIONS.FORWARD)
    elseif (input.KeyCode == Enum.KeyCode.S) then
        Utils.logInfo("begin s")
        placeGoal(Ray.new(rootCF.p, rootCF.LookVector * -MOVE_DISTANCE), DIRECTIONS.BACKWARD)
    elseif (input.KeyCode == Enum.KeyCode.D) then
        Utils.logInfo("begin d")
        placeGoal(Ray.new(rootCF.p, rootCF.RightVector * MOVE_DISTANCE), DIRECTIONS.RIGHT)
    elseif (input.KeyCode == Enum.KeyCode.A) then
        Utils.logInfo("begin a")
        placeGoal(Ray.new(rootCF.p, rootCF.RightVector * -MOVE_DISTANCE), DIRECTIONS.LEFT)
    elseif (input.KeyCode == Enum.KeyCode.Space) then
        Utils.logInfo("begin space")
        placeGoal(Ray.new(rootCF.p, rootCF.UpVector * MOVE_DISTANCE), DIRECTIONS.UP)
    elseif (input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift) then
        Utils.logInfo("begin shift")
        placeGoal(Ray.new(rootCF.p, rootCF.CFrame.UpVector * -MOVE_DISTANCE), DIRECTIONS.DOWN)
    end

    if gameProcessedEvent then
        Utils.logDebug("The game engine internally observed this input")
    end
end

local inputEnded = function(input, gameProcessedEvent)
    if (input.KeyCode == Enum.KeyCode.W) then
        Utils.logInfo("end w")
        removeDirectionGoal(DIRECTIONS.FORWARD)
    elseif (input.KeyCode == Enum.KeyCode.S) then
        Utils.logInfo("end s")
        removeDirectionGoal(DIRECTIONS.BACKWARD)
    elseif (input.KeyCode == Enum.KeyCode.D) then
        Utils.logInfo("end d")
        removeDirectionGoal(DIRECTIONS.RIGHT)
    elseif (input.KeyCode == Enum.KeyCode.A) then
        Utils.logInfo("end a")
        removeDirectionGoal(DIRECTIONS.LEFT)
    elseif (input.KeyCode == Enum.KeyCode.Space) then
        Utils.logInfo("end space")
        removeDirectionGoal(DIRECTIONS.UP)
    elseif (input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift) then
        Utils.logInfo("end shift")
        removeDirectionGoal(DIRECTIONS.DOWN)
    end

    if gameProcessedEvent then
        Utils.logDebug("The game engine internally observed this input")
    end
end

Fly.bindListeners = function()
    UserInputService.InputBegan:Connect(inputBegan)
    UserInputService.InputEnded:Connect(inputEnded)
end

return Fly
