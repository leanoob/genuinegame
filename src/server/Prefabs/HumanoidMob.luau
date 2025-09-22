local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Singletons = ServerStorage.Singletons
local Assets = ServerStorage.Assets
local Components = ServerStorage.Components
local Commands = ServerStorage.Util.Commands

local jecs = require(ReplicatedStorage.Packages.jecs)
local World = require(Singletons.World)

local Mobs = require(Singletons.Mobs)

local HealthComponent = require(Components.Health)
local HeartComponent = require(Components.Heart)
local FluidContainerComponent = require(Components.FluidContainer)
local ModelComponent = require(Components.Model)

local DeferDespawn = require(Commands.DespawnEntity)

local StarterCharacter = Assets.StarterCharacter :: Model

type PrefabOptions = {
	CFrame: CFrame?
}

return function(Options: PrefabOptions)
	local NewMobModel = StarterCharacter:Clone()
	NewMobModel.Parent = workspace

	if Options.CFrame then
		NewMobModel:PivotTo(Options.CFrame)
	end

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
	NewMobModel.AncestryChanged:Once(function()
		if World:contains(MobEntity) then
			DeferDespawn(MobEntity)
		end

		Mobs[NewMobModel] = nil

		if NewMobModel.Parent then
			NewMobModel:Destroy()
		end
	end)

	return MobEntity
end
