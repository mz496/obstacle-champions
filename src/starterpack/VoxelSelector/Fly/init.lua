local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local FlyDirection = require(script.Parent:WaitForChild("FlyDirection"))
local Fly = {}

local player = game.Players.LocalPlayer

-- The velocity to float in a direction when a button is pressed
local MOVE_VELOCITY = 20

-- Instances inserted to player humanoid root part
local FLY_BODY_VELOCITY = nil
local FLY_BODY_GYRO = nil

Fly.INPUTS = {
    [Enum.KeyCode.Space.Name] = FlyDirection("Up",
        (function(rootCFrame) return rootCFrame.UpVector.Unit end)),
    [Enum.KeyCode.LeftShift.Name] = FlyDirection("Down",
        (function(rootCFrame) return -1 * rootCFrame.UpVector.Unit end)),
    [Enum.KeyCode.D.Name] = FlyDirection("Right",
        (function(rootCFrame) return rootCFrame.RightVector.Unit end)),
    [Enum.KeyCode.A.Name] = FlyDirection("Left",
        (function(rootCFrame) return -1 * rootCFrame.RightVector.Unit end)),
    [Enum.KeyCode.W.Name] = FlyDirection("Forward",
        (function(rootCFrame) return rootCFrame.LookVector.Unit end)),
    [Enum.KeyCode.S.Name] = FlyDirection("Backward",
        (function(rootCFrame) return -1 * rootCFrame.LookVector.Unit end))
}

local addGyro = function()
    FLY_BODY_GYRO = Instance.new("BodyGyro")
    FLY_BODY_GYRO.Parent = player.Character.HumanoidRootPart
    FLY_BODY_GYRO.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FLY_BODY_GYRO.P = 1e9
end

local destroyGyro = function()
    FLY_BODY_GYRO:Destroy()
    FLY_BODY_GYRO.Parent = nil
    FLY_BODY_GYRO = nil
end

local addMover = function()
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

local destroyMover = function()
    FLY_BODY_VELOCITY:Destroy()
    FLY_BODY_VELOCITY.Parent = nil
    FLY_BODY_VELOCITY = nil
end

local computeNetOngoingVelocity = function()
    local netOngoingVelocity = Vector3.new(0,0,0)
    for _,dir in pairs(Fly.INPUTS) do
        netOngoingVelocity = netOngoingVelocity + dir:getOngoingVelocity()
    end
    FLY_BODY_VELOCITY.Velocity = netOngoingVelocity
    Utils.logInfo("NET VELOCITY: "..Utils.toStringVector3(FLY_BODY_VELOCITY.Velocity))
end

Fly.inputBegan = function(input, gameProcessedEvent)
    local rootCFrame = player.Character.HumanoidRootPart.CFrame
    local directionObject = Fly.INPUTS[input.KeyCode.Name]
    directionObject:setOngoingVelocity(MOVE_VELOCITY * directionObject:getUnitDirectionVector3(rootCFrame))
    computeNetOngoingVelocity()
end

Fly.inputEnded = function(input, gameProcessedEvent)
    local rootCFrame = player.Character.HumanoidRootPart.CFrame
    Fly.INPUTS[input.KeyCode.Name]:setOngoingVelocity(Vector3.new(0,0,0))
    computeNetOngoingVelocity()
end

Fly.updateGyroTargetCFrame = function(--[[CFrame]] newCFrame)
    FLY_BODY_GYRO.CFrame = newCFrame
end

-- TODO: Sometimes slight motion even when no keys are held
Fly.updateTrajectory = function(--[[CFrame]] newCFrame)
    for _,dir in pairs(Fly.INPUTS) do
        local oldVelocity = dir:getOngoingVelocity()
        -- Retain speed i.e. magnitude of the ray, but adjust direction
        local epsilon = 1e-5
        local newSpeed = oldVelocity.Magnitude
        if (newSpeed > epsilon) then
            local newDirectionVector3 = dir:getUnitDirectionVector3(newCFrame)
            local newVelocity = newSpeed * newDirectionVector3
            dir:setOngoingVelocity(newVelocity)
        end
    end
    computeNetOngoingVelocity()
end

Fly.construct = function()
    addMover()
    addGyro()
end

Fly.deconstruct = function()
    for _,dir in pairs(Fly.INPUTS) do
        dir:setOngoingVelocity(Vector3.new(0,0,0))
    end
    destroyMover()
    destroyGyro()
end

return Fly
