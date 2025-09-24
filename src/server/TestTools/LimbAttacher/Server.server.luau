local Tool = script.Parent :: Tool
local Remote = Tool.Remote :: RemoteEvent

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Singletons = ServerStorage.Singletons
local Components = ServerStorage.Components

local jecs = require(ReplicatedStorage.Packages.jecs)
local pair = jecs.pair

local InstanceEntityMap = require(Singletons.InstanceEntityMap)

local World = require(Singletons.World)
local ModelComponent = require(Components.Model)
local BodyPartComponent = require(Components.BodyPart)
local MobComponent = require(Components.Mob)

local LimbTarget: {Instance: BasePart, Entity: jecs.Entity & number}? = nil

local function ResetTarget()
	print("Unselected")
	LimbTarget = nil
end

Remote.OnServerEvent:Connect(function(Player: Player, MouseTarget: Instance?)
	if not MouseTarget or typeof(MouseTarget) ~= "Instance" then
		if LimbTarget then
			ResetTarget()
		end

		return
	end

	if LimbTarget then
		if not LimbTarget.Instance or not LimbTarget.Instance.Parent then
			ResetTarget()
			return
		end
		
		if not World:contains(LimbTarget.Entity) then
			ResetTarget()
			return
		end

		local Joint = LimbTarget.Instance:FindFirstChildOfClass("Motor6D")
		if not Joint then
			ResetTarget()
			return
		end
		
		local TargetParent = MouseTarget.Parent
		if not TargetParent:IsA("Model") then
			ResetTarget()
			return
		end

		local Humanoid = TargetParent:FindFirstChildOfClass("Humanoid")
		if not Humanoid then
			ResetTarget()
			return
		end

		local Torso = TargetParent:FindFirstChild("Torso")
		if not Torso then
			ResetTarget()
			return
		end

		local ModelEntity = InstanceEntityMap[TargetParent]
		if not ModelEntity then
			ResetTarget()
			return
		end

		if not World:contains(ModelEntity) then
			ResetTarget()
			return
		end

		local Model = World:get(ModelEntity, ModelComponent)
		if not Model then return end

		if Model ~= TargetParent then return end

		if not World:get(ModelEntity, MobComponent) then return end

		Joint.Part0 = Torso
		Joint.Parent = Torso
		LimbTarget.Instance.CanCollide = false
		LimbTarget.Instance.Parent = TargetParent

		print("Rejoined", LimbTarget.Instance, "and", TargetParent)
		World:add(LimbTarget.Entity, pair(jecs.ChildOf, ModelEntity))

		ResetTarget()
	else

		local LimbEntity = InstanceEntityMap[MouseTarget]
		if not LimbEntity then return end

		if not World:contains(LimbEntity) then return end

		local BodyPart = World:get(LimbEntity, BodyPartComponent)
		if not BodyPart then return end

		local Model = World:get(LimbEntity, ModelComponent)
		if not Model then return end

		if Model ~= MouseTarget then return end

		local Parent = World:target(LimbEntity, jecs.ChildOf)
		if Parent then return end

		print("Selected", MouseTarget)
		LimbTarget = {Instance = MouseTarget, Entity = LimbEntity}
	end
end)

