local ServerStorage = game:GetService("ServerStorage")

local Singletons = ServerStorage.Singletons
local Assets = ServerStorage.Assets
local Components = ServerStorage.Components

local World = require(Singletons.World)

local Mobs = require(Singletons.Mobs)

local HealthComponent = require(Components.Health)
local HeartComponent = require(Components.Heart)
local FluidContainerComponent = require(Components.FluidContainer)
local ModelComponent = require(Components.Model)

local StarterCharacter = Assets.StarterCharacter :: Model

return function()
	local NewMobModel = StarterCharacter:Clone()
	NewMobModel.Parent = workspace

	local MobEntity = World:entity()
	World:set(
		MobEntity,
		ModelComponent,
		NewMobModel
	)
	World:set(
		MobEntity,
		HealthComponent,
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
		}
	)
	World:set(
		MobEntity,
		HeartComponent,
		{
			BloodCapacity = 500,
			Blood = 500,
			DeletionMultiplier = 1
		}
	)
	World:set(
		MobEntity,
		FluidContainerComponent,
		{
			Fluids = {},
			Capacity = 1000
		}
	)

	Mobs[NewMobModel] = MobEntity

	return MobEntity
end
