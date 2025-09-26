local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Singletons = ServerStorage.Singletons
local Components = ServerStorage.Components
local Tags = ServerStorage.Tags
local Relatioships = ServerStorage.Relationships

local World = require(Singletons.World)

local BloodSystemComponent = require(Components.BloodSystem)
local HeartChangedTag = require(Tags.HeartChanged)
local OwnedHeartRelation = require(Relatioships.OwnedHeart)

local jecs = require(ReplicatedStorage.Packages.jecs)

local Removals = {}

local Query = World:query(HeartChangedTag)

return function()
	for Entity in Query do
		local HeartEntity = World:target(Entity, OwnedHeartRelation)
		local HasHeart = World:contains(HeartEntity) and World:target(HeartEntity, jecs.ChildOf) == Entity -- and World:contains(HeartEntity)

		local BloodSystem = World:get(Entity, BloodSystemComponent)
		if BloodSystem then
			BloodSystem.Disabled = not HasHeart
		end

		Removals[#Removals+1] = Entity
	end

	if #Removals>0 then
		for i = 1,#Removals do
			World:remove(Removals[i], HeartChangedTag)
		end
		Removals = {}
	end
end
