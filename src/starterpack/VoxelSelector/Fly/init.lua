local Utils = require(game.ReplicatedStorage.Common.Utils)
local Direction = require(script.Parent.Direction)
local Fly = {}

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- The distance to float in a direction when a button is pressed
local MOVE_DISTANCE = 5
local GOALS_MODEL = Instance.new("Model")
GOALS_MODEL.Name = "Goals"
GOALS_MODEL.Parent = game.Workspace.Terrain

-- Body velocity inserted to player humanoid root part
local bodyVelocityRef = nil

local DIRECTIONS = {
    UP=Direction("Up", Enum.KeyCode.Space,
        (function(rootCFrame) return Ray.new(rootCFrame.p, rootCFrame.UpVector * MOVE_DISTANCE) end)),
    DOWN=Direction("Down", Enum.KeyCode.LeftShift,
        (function(rootCFrame) return Ray.new(rootCFrame.p, rootCFrame.UpVector * -MOVE_DISTANCE) end)),
    RIGHT=Direction("Right", Enum.KeyCode.D,
        (function(rootCFrame) return Ray.new(rootCFrame.p, rootCFrame.RightVector * MOVE_DISTANCE) end)),
    LEFT=Direction("Left", Enum.KeyCode.A,
        (function(rootCFrame) return Ray.new(rootCFrame.p, rootCFrame.RightVector * -MOVE_DISTANCE) end)),
    FORWARD=Direction("Forward", Enum.KeyCode.W,
        (function(rootCFrame) return Ray.new(rootCFrame.p, rootCFrame.LookVector * MOVE_DISTANCE) end)),
    BACKWARD=Direction("Backward", Enum.KeyCode.S,
        (function(rootCFrame) return Ray.new(rootCFrame.p, rootCFrame.LookVector * -MOVE_DISTANCE) end))
}

Fly.addMover = function()
    bodyVelocityRef = Instance.new("BodyVelocity")
    bodyVelocityRef.Parent = player.Character.HumanoidRootPart
    bodyVelocityRef.Name = "Mover"
    bodyVelocityRef.Velocity = Vector3.new(0,0,0)
    return bodyVelocityRef
end

local getMover = function()
    return player.Character.HumanoidRootPart.Mover
end

local addMoverVelocity = function(--[[Vector3]] v)
    local mover = getMover()
    mover.Velocity = mover.Velocity + v
end

Fly.destroyMover = function()
    bodyVelocityRef:Destroy()
    bodyVelocityRef.Parent = nil
end

local getGoalName = --[[string]] function(--[[string]] direction)
    return "Goal:"..direction
end

-- Place goal relative to humanoid root part CFrame
-- Returns goal part
local placeGoal = --[[Part]] function(--[[Ray]] ray, --[[string]] direction)
    --Utils.visualizeRay(ray)
    local p = Utils.placeMarker(ray.Origin + ray.Direction, getGoalName(direction), GOALS_MODEL)
    p.Color = Color3.new(1,0,1)
    p.Size = Vector3.new(1,1,1)
    return p
end

local removeLandmarks = function()
    for _,c in pairs(GOALS_MODEL:GetChildren()) do
        c:Destroy()
        c.Parent = nil
    end
end
-- TODO: Store reference instead of using FindFirstChild
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
    local rootCFrame = player.Character.HumanoidRootPart.CFrame
    for _,dir in pairs(DIRECTIONS) do
        if (input.KeyCode == dir:getKeyCode()) then
            addMoverVelocity(dir:getRay(rootCFrame).Direction)
            --dir:setIsActive(true)
            --local goal = placeGoal(dir:getRay(rootCFrame), dir:getName())
            --dir:setGoalRef(goal)
            --[[while (dir:getIsActive()) do
                rootCFrame = player.Character.HumanoidRootPart.CFrame
                local newGoalRay = dir:getRay(rootCFrame)
                local newGoalLocation = newGoalRay.Origin + newGoalRay.Direction
                goal.Location = newGoalLocation
            end]]
        end
        Utils.logInfo(dir:getName().." "..Utils.toStringBoolean(dir:getIsActive()))
    end
    Utils.logInfo("--------")
    --[[
    if (input.KeyCode == Enum.KeyCode.W) then
        isForwardHeld = true
        Utils.logInfo("begin w")
        local r = Ray.new(player.Character.HumanoidRootPart.CFrame.p, player.Character.HumanoidRootPart.CFrame.LookVector * MOVE_DISTANCE)
        placeGoal(r, DIRECTIONS.FORWARD)
        while true do
            if not isForwardHeld then break end
            wait(1)
            removeDirectionGoal(DIRECTIONS.FORWARD)
            r = Ray.new(player.Character.HumanoidRootPart.CFrame.p, player.Character.HumanoidRootPart.CFrame.LookVector * MOVE_DISTANCE)
            placeGoal(r, DIRECTIONS.FORWARD)
        end
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
    ]]

    if gameProcessedEvent then
        Utils.logDebug("The game engine internally observed this input")
    end
end

local inputEnded = function(input, gameProcessedEvent)
    local rootCFrame = player.Character.HumanoidRootPart.CFrame
    for _,dir in pairs(DIRECTIONS) do
        if (input.KeyCode == dir:getKeyCode()) then
            addMoverVelocity(dir:getRay(rootCFrame).Direction * -1)
            --dir:setIsActive(false)
            --[[while (dir:getIsActive()) do
                rootCFrame = player.Character.HumanoidRootPart.CFrame
                local newGoalRay = dir:getRay(rootCFrame)
                local newGoalLocation = newGoalRay.Origin + newGoalRay.Direction
                goal.Location = newGoalLocation
            end]]
        end
    end
    --[[
    if (input.KeyCode == Enum.KeyCode.W) then
        Utils.logInfo("end w")
        isForwardHeld = false
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
    ]]

    if gameProcessedEvent then
        Utils.logDebug("The game engine internally observed this input")
    end
end

Fly.bindListeners = function()
    UserInputService.InputBegan:Connect(inputBegan)
    UserInputService.InputEnded:Connect(inputEnded)
end

return Fly
