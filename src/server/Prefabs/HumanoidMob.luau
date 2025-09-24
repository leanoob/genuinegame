local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Singletons = ServerStorage.Singletons
local Assets = ServerStorage.Assets
local Components = ServerStorage.Components

local jecs = require(ReplicatedStorage.Packages.jecs)
local World = require(Singletons.World)

local pair = jecs.pair

local HealthComponent = require(Components.Health)
local HeartComponent = require(Components.Heart)
local FluidContainerComponent = require(Components.FluidContainer)
local ModelComponent = require(Components.Model)
local BodyPartComponent = require(Components.BodyPart)
local MobComponent = require(Components.Mob)

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
		HeartComponent,
		FluidContainerComponent,
		MobComponent
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
			DeletionMultiplier = 1
		},
		{
			Fluids = {},
			Capacity = 1000
		},
		true
	}

	-- Adds Entities per body part and makes them children of MobEntity
	MakeBodyParts(MobEntity, NewMobModel)

	jecs.bulk_insert(World, MobEntity, ComponentArr, ValueArr)

	return MobEntity
end
