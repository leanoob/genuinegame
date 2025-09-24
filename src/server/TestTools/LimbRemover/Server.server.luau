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

Remote.OnServerEvent:Connect(function(Player: Player, MouseTarget: Instance?)
	if not MouseTarget then return end
	if typeof(MouseTarget) ~= "Instance" then return end

	local Entity = InstanceEntityMap[MouseTarget]
	if not Entity then return end

	if not World:contains(Entity) then return end

	local BodyPart = World:get(Entity, BodyPartComponent)
	if not BodyPart then return end

	local Model = World:get(Entity, ModelComponent)
	if not Model then return end

	if Model ~= MouseTarget then return end

	-- local Parent = World:get(pair(jecs.ChildOf, jecs.Wildcard))
	local Parent = World:target(Entity, jecs.ChildOf)
	if not Parent then return end

	local Joints = Model:GetJoints()
	if #Joints ~= 1 then return end

	World:remove(Entity, pair(jecs.ChildOf, Parent))

	Joints[1].Part0 = nil
	Joints[1].Parent = Model

	Model.Parent = workspace
	Model.CanCollide = true
end)

