local Tool = script.Parent :: Tool
local Remote = Tool.Remote :: RemoteEvent

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Singletons = ServerStorage.Singletons
local Components = ServerStorage.Components
local Tags = ServerStorage.Tags

local jecs = require(ReplicatedStorage.Packages.jecs)
local pair = jecs.pair

local InstanceEntityMap = require(Singletons.InstanceEntityMap)

local World = require(Singletons.World)
local ModelComponent = require(Components.Model)
local HeartComponent = require(Components.Heart)
local HeartChangedTag = require(Tags.HeartChanged)

Remote.OnServerEvent:Connect(function(Player: Player, MouseTarget: Instance?)
	if not MouseTarget then return end
	if typeof(MouseTarget) ~= "Instance" then return end
	if not MouseTarget.Parent then return end

	local Model = MouseTarget.Parent
	if not Model:IsA("Model") then return end
	local MobEntity = InstanceEntityMap[Model]

	if MobEntity then
		for Entity, HeartModel in World:query(ModelComponent, HeartComponent, pair(jecs.ChildOf, MobEntity)) do
			HeartModel:PivotTo(Model:GetPivot() + Vector3.new(0,3,0))
			HeartModel.Parent = workspace

			World:remove(Entity, pair(jecs.ChildOf, MobEntity))
			World:add(MobEntity, HeartChangedTag)

			break
		end
	end
end)

