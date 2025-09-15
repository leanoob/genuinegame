local module = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Packages.jecs)
local World = require(ServerStorage.Singletons.World)

local RegisteredHooks = {}

function module.GetCallback(Hook: jecs.Entity<any>, Component: jecs.Entity<unknown>, Callback)
	local HookedComponents = RegisteredHooks[Hook]
	if not HookedComponents then
		HookedComponents = {}
		RegisteredHooks[Hook] = HookedComponents
	end

	local ComponentHookCallbacks = HookedComponents[Component]
	if not ComponentHookCallbacks then
		ComponentHookCallbacks = {}
		HookedComponents[Component] = ComponentHookCallbacks
		World:set(
			Component,
			Hook,
			function(...)
				for CallbackFunc,_ in next, ComponentHookCallbacks do
					CallbackFunc(...)
				end
			end
		)
	end

	ComponentHookCallbacks[Callback] = true

	return Callback
end

function module.ReleaseCallback(Hook: jecs.Entity<any>, Component: jecs.Entity<unknown>, Callback)
	local HookedComponents = RegisteredHooks[Hook]
	if not HookedComponents then return end
	local ComponentHookCallbacks = HookedComponents[Component]
	if not ComponentHookCallbacks then return end

	ComponentHookCallbacks[Callback] = nil
end

return module
