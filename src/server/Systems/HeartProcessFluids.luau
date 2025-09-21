local ServerStorage = game:GetService("ServerStorage")

local Singletons = ServerStorage.Singletons
local Components = ServerStorage.Components
local Resources = ServerStorage.Resources

local World = require(Singletons.World)

local FluidEffects = Resources.FluidEffects

local HeartComponent = require(Components.Heart)
local FluidContainerComponent = require(Components.FluidContainer)
local HealthComponent = require(Components.Health)

local SystemLastRan: number
local SecondsBetweenRuns = 2

local function DeepCopy(t, seen)
	if type(t) ~= "table" then return t end
	if seen and seen[t] then return seen[t] end

	seen = seen or {}
	local copy = {}
	seen[t] = copy

	for k, v in next, t do
		copy[k] = DeepCopy(v, seen)
	end

	return copy
end

return function()
	if not SystemLastRan then
		SystemLastRan = os.clock()
		return
	end

	local Time = os.clock()
	local TimeDiff = Time-SystemLastRan

	if TimeDiff < SecondsBetweenRuns then
		return
	end

	SystemLastRan = SystemLastRan + SecondsBetweenRuns
	
	for Entity, FluidContainer, Health, _ in World:query(FluidContainerComponent, HealthComponent, HeartComponent) do
		local Fluids = FluidContainer.Fluids

		local Damage = Health.Damage
		local DamageTypes = Health.Types
		
		for Fluid, Amount in next, Fluids do
			local FluidModule = FluidEffects:FindFirstChild(Fluid)
			if not FluidModule then continue end

			local FluidData = require(FluidModule)

			local FluidDamage = FluidData.Damage
			local Depletion = FluidData.Depletion

			if FluidDamage and next(FluidDamage) then
				for DamageType, DamageValue in next, FluidDamage do
					if not DamageTypes[DamageType] then continue end

					Damage.Amount = Damage.Amount + DamageValue
					DamageTypes[DamageType] = DamageTypes[DamageType] + DamageValue
				end
			end

			if not Depletion or Depletion == 0 then continue end

			local NewFluidAmount = Amount - Depletion
			Fluids[Fluid] = (NewFluidAmount > 0) and NewFluidAmount or nil
		end
	end
end
