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
-- Should be the same reference for the lifetime of this module
local FLY_BODY_VELOCITY = nil

-- Connections for bound event listeners
-- Should be the same references for the lifetime of this module
local INPUT_BEGAN_CONNECTION = nil
local INPUT_ENDED_CONNECTION = nil

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
    FLY_BODY_VELOCITY = Instance.new("BodyVelocity")
    FLY_BODY_VELOCITY.Parent = player.Character.HumanoidRootPart
    FLY_BODY_VELOCITY.Name = "Fly"
    FLY_BODY_VELOCITY.Velocity = Vector3.new(0,0,0)
    return FLY_BODY_VELOCITY
end

local addMoverVelocity = function(--[[Vector3]] v)
    Utils.logInfo("Adding: "..Utils.toStringVector3(v))
    FLY_BODY_VELOCITY.Velocity = FLY_BODY_VELOCITY.Velocity + v
    Utils.logInfo("Current: "..Utils.toStringVector3(FLY_BODY_VELOCITY.Velocity).." (magnitude "..Utils.truncateNumber(FLY_BODY_VELOCITY.Velocity.Magnitude)..")")
end

Fly.destroyMover = function()
    FLY_BODY_VELOCITY:Destroy()
    FLY_BODY_VELOCITY.Parent = nil
    FLY_BODY_VELOCITY = nil
end

local computeNetOngoingVelocity = function()
    local netOngoingVelocity = Vector3.new(0,0,0)
    for _,dir in pairs(DIRECTIONS) do
        netOngoingVelocity = netOngoingVelocity + dir:getOngoingVelocity()
    end
    FLY_BODY_VELOCITY.Velocity = netOngoingVelocity
    Utils.logInfo("NET VELOCITY: "..Utils.toStringVector3(FLY_BODY_VELOCITY.Velocity))
end

-- Takes the new direction vector and applies it to the
Fly.adjustTrajectory = function(--[[CFrame]] oldCFrame, --[[CFrame]] newCFrame)
    local offset = oldCFrame:ToObjectSpace(newCFrame)

    for _,dir in pairs(DIRECTIONS) do
        local oldVelocity = dir:getOngoingVelocity()
        -- Retain speed i.e. magnitude of the ray, but adjust direction
        local epsilon = 1e-5
        local newSpeed = oldVelocity.Magnitude
        if (newSpeed > epsilon) then
            local newDirectionVector3 = (offset * oldVelocity).Unit
            local newVelocity = newSpeed * newDirectionVector3

            dir:setOngoingVelocity(newVelocity)
            Utils.logInfo("DIR "..dir:getName().."'s new velocity is "..Utils.toStringVector3(newVelocity))
        end
    end
    computeNetOngoingVelocity()
    --Utils.logInfo("ADJUST TRAJECTORY: "..Utils.toStringVector3(FLY_BODY_VELOCITY.Velocity).." (magnitude "..Utils.truncateNumber(FLY_BODY_VELOCITY.Velocity.Magnitude)..")")
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
            --addMoverVelocity(MOVE_DISTANCE * (dir:getRay(rootCFrame).Direction).Unit)
            dir:setOngoingVelocity(MOVE_DISTANCE * (dir:getRay(rootCFrame).Direction.Unit))
            --local goal = placeGoal(dir:getRay(rootCFrame), dir:getName())
            --dir:setGoalRef(goal)
            --[[while (dir:getIsActive()) do
                rootCFrame = player.Character.HumanoidRootPart.CFrame
                local newGoalRay = dir:getRay(rootCFrame)
                local newGoalLocation = newGoalRay.Origin + newGoalRay.Direction
                goal.Location = newGoalLocation
            end]]
        end
        --Utils.logInfo(dir:getName().." "..Utils.toStringBoolean(dir:getIsActive()))
    end

    computeNetOngoingVelocity()

    -- TODO recalculate bodyvelocity based on directions table
    --Utils.logInfo("--------")
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
            --addMoverVelocity(-MOVE_DISTANCE * (dir:getRay(rootCFrame).Direction).Unit)
            dir:setOngoingVelocity(Vector3.new(0,0,0))
            --[[while (dir:getIsActive()) do
                rootCFrame = player.Character.HumanoidRootPart.CFrame
                local newGoalRay = dir:getRay(rootCFrame)
                local newGoalLocation = newGoalRay.Origin + newGoalRay.Direction
                goal.Location = newGoalLocation
            end]]
        end
    end

    computeNetOngoingVelocity()

    -- TODO recalculate bodyvelocity based on directions table
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
    INPUT_BEGAN_CONNECTION = UserInputService.InputBegan:Connect(inputBegan)
    INPUT_ENDED_CONNECTION = UserInputService.InputEnded:Connect(inputEnded)
end

Fly.unbindListeners = function()
    INPUT_BEGAN_CONNECTION:Disconnect()
    INPUT_ENDED_CONNECTION:Disconnect()
end

return Fly
