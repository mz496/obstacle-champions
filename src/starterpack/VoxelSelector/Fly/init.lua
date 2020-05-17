local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local Direction = require(script.Parent.Direction)
local Fly = {}

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- The velocity to float in a direction when a button is pressed
local MOVE_VELOCITY = 20

-- Instances inserted to player humanoid root part
local FLY_BODY_VELOCITY = nil
local FLY_BODY_GYRO = nil

-- Connection instances for bound event listeners
local INPUT_BEGAN_CONNECTION = nil
local INPUT_ENDED_CONNECTION = nil

local DIRECTIONS = {
    UP=Direction("Up",
        Enum.KeyCode.Space,
        (function(rootCFrame) return rootCFrame.UpVector.Unit end)),
    DOWN=Direction("Down",
        Enum.KeyCode.LeftShift,
        (function(rootCFrame) return -1 * rootCFrame.UpVector.Unit end)),
    RIGHT=Direction("Right",
        Enum.KeyCode.D,
        (function(rootCFrame) return rootCFrame.RightVector.Unit end)),
    LEFT=Direction("Left",
        Enum.KeyCode.A,
        (function(rootCFrame) return -1 * rootCFrame.RightVector.Unit end)),
    FORWARD=Direction("Forward",
        Enum.KeyCode.W,
        (function(rootCFrame) return rootCFrame.LookVector.Unit end)),
    BACKWARD=Direction("Backward",
        Enum.KeyCode.S,
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
    for _,dir in pairs(DIRECTIONS) do
        netOngoingVelocity = netOngoingVelocity + dir:getOngoingVelocity()
    end
    FLY_BODY_VELOCITY.Velocity = netOngoingVelocity
    Utils.logInfo("NET VELOCITY: "..Utils.toStringVector3(FLY_BODY_VELOCITY.Velocity))
end

local inputBegan = function(input, gameProcessedEvent)
    local rootCFrame = player.Character.HumanoidRootPart.CFrame
    for _,dir in pairs(DIRECTIONS) do
        if (input.KeyCode == dir:getKeyCode()) then
            dir:setOngoingVelocity(MOVE_VELOCITY * dir:getUnitDirectionVector3(rootCFrame))
        end
    end
    computeNetOngoingVelocity()

    if gameProcessedEvent then
        Utils.logDebug("The game engine internally observed this input")
    end
end

local inputEnded = function(input, gameProcessedEvent)
    local rootCFrame = player.Character.HumanoidRootPart.CFrame
    for _,dir in pairs(DIRECTIONS) do
        if (input.KeyCode == dir:getKeyCode()) then
            dir:setOngoingVelocity(Vector3.new(0,0,0))
        end
    end
    computeNetOngoingVelocity()

    if gameProcessedEvent then
        Utils.logDebug("The game engine internally observed this input")
    end
end

local bindListeners = function()
    INPUT_BEGAN_CONNECTION = UserInputService.InputBegan:Connect(inputBegan)
    INPUT_ENDED_CONNECTION = UserInputService.InputEnded:Connect(inputEnded)
end

local unbindListeners = function()
    INPUT_BEGAN_CONNECTION:Disconnect()
    INPUT_ENDED_CONNECTION:Disconnect()
end

Fly.updateGyroTargetCFrame = function(--[[CFrame]] newCFrame)
    FLY_BODY_GYRO.CFrame = newCFrame
end

Fly.updateTrajectory = function(--[[CFrame]] newCFrame)
    for _,dir in pairs(DIRECTIONS) do
        local oldVelocity = dir:getOngoingVelocity()
        -- Retain speed i.e. magnitude of the ray, but adjust direction
        local epsilon = 1e-5
        local newSpeed = oldVelocity.Magnitude
        if (newSpeed > epsilon) then
            local newDirectionVector3 = dir:getUnitDirectionVector3(newCFrame)
            Utils.placeMarker(player.Character.HumanoidRootPart.Position + oldVelocity, "m", game.Workspace.Terrain)
            local newVelocity = newSpeed * newDirectionVector3

            dir:setOngoingVelocity(newVelocity)
            Utils.logInfo("DIR "..dir:getName().."'s new velocity is "..Utils.toStringVector3(newVelocity))
        end
    end
    computeNetOngoingVelocity()
end

Fly.construct = function()
    addMover()
    addGyro()
    bindListeners()
end

Fly.deconstruct = function()
    for _,dir in pairs(DIRECTIONS) do
        dir:setOngoingVelocity(Vector3.new(0,0,0))
    end
    destroyMover()
    destroyGyro()
    unbindListeners()
end

return Fly
