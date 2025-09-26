local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Singletons = ServerStorage.Singletons
local Assets = ServerStorage.Assets
local Components = ServerStorage.Components
local Tags = ServerStorage.Tags
local Relationships = ServerStorage.Relationships
local HiddenModels = ReplicatedStorage.HiddenModels

local jecs = require(ReplicatedStorage.Packages.jecs)
local World = require(Singletons.World)

local pair = jecs.pair

local HealthComponent = require(Components.Health)
local BloodSystemComponent = require(Components.BloodSystem)
local FluidContainerComponent = require(Components.FluidContainer)
local ModelComponent = require(Components.Model)
local BodyPartComponent = require(Components.BodyPart)
local ItemComponent = require(Components.Item)
local MobTag = require(Tags.Mob)
local OwnedHeartRelation = require(Relationships.OwnedHeart)

local HeartComponent = require(Components.Heart)

local StarterCharacter = Assets.StarterCharacter :: Model

type PrefabOptions = {
	CFrame: CFrame?
}

local BodyPartNames = {
	Head = true, Torso = true,
	["Left Arm"] = true, ["Right Arm"] = true,
	["Left Leg"] = true, ["Right Leg"] = true
}

local function MakeBodyParts(MobEntity, Model)
	for Name, _ in next, BodyPartNames do
		local Part = Model:FindFirstChild(Name)
		if not Part then continue end

		local Entity = World:entity()

		World:set(
			Entity,
			BodyPartComponent,
			{Damage = 0}
		)
		World:set(
			Entity,
			ModelComponent,
			Part
		)
		World:add(Entity, pair(jecs.ChildOf, MobEntity))
	end
end

local function MakeOrgans(MobEntity)
	local HeartEntity = World:entity()

	World:add(HeartEntity, HeartComponent)
	World:add(HeartEntity, pair(jecs.ChildOf, MobEntity))
	World:add(HeartEntity, ItemComponent)

	local NewHeartModel = Assets.Organs.Heart:Clone() :: Model
	NewHeartModel.Parent = HiddenModels
	
	World:set(
		HeartEntity,
		ModelComponent,
		NewHeartModel
	)

	World:add(MobEntity, pair(OwnedHeartRelation, HeartEntity))
end

return function(Options: PrefabOptions)
	local NewMobModel = StarterCharacter:Clone()
	NewMobModel.Parent = workspace

	if Options.CFrame then
		NewMobModel:PivotTo(Options.CFrame)
	end

	local MobEntity = World:entity()

	local ComponentArr = {
		ModelComponent,
		HealthComponent,
		BloodSystemComponent,
		FluidContainerComponent,
		MobTag
	}
	local ValueArr = {
		NewMobModel,
		{
			Damage = {
				Limit = 100,
				Amount = 0
			},
			Types = {
				Brute = 0,
				Burn = 0,
				Toxic = 0,
				Oxygen = 0
			}
		},
		{
			BloodCapacity = 500,
			Blood = 500,
			DeletionMultiplier = 1,
			Disabled = false,
		},
		{
			Fluids = {},
			Capacity = 1000
		},
		true
	}

	-- Adds Entities per body part and makes them children of MobEntity
	MakeBodyParts(MobEntity, NewMobModel)
	MakeOrgans(MobEntity)

	jecs.bulk_insert(World, MobEntity, ComponentArr, ValueArr)

	return MobEntity
end
