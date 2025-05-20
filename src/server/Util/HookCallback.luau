local module = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Packages.jecs)
local World = require(ServerStorage.Singletons.World)

local Map = {}

function module.GetCallback(Hook: jecs.Entity<any>, Component: jecs.Entity<unknown>, Callback)
	local HookedComponents = Map[Hook]
	if not HookedComponents then
		HookedComponents = {}
		Map[Hook] = HookedComponents
	end

	local ComponentHookCallbacks = HookedComponents[Component]
	if not ComponentHookCallbacks then
		ComponentHookCallbacks = {}
		HookedComponents[Component] = ComponentHookCallbacks
		World:set(
			Component,
			Hook,
			function(...)
				for Callback,_ in next, ComponentHookCallbacks do
					Callback(...)
				end
			end
		)
	end

	ComponentHookCallbacks[Callback] = true
end

function module.ReleaseCallback(Hook: jecs.Entity<any>, Component: jecs.Entity<unknown>, Callback)
	local HookedComponents = Map[Hook]
	assert(HookedComponents)
	local ComponentHookCallbacks = HookedComponents[Component]
	assert(ComponentHookCallbacks)

	ComponentHookCallbacks[Callback] = nil
end
