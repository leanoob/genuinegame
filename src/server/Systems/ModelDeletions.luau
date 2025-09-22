local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Singletons = ServerStorage.Singletons
local Components = ServerStorage.Components
local jecs = require(ReplicatedStorage.Packages.jecs)

local World = require(Singletons.World)

local ModelComponent = require(Components.Model)

World:set(
	ModelComponent,
	jecs.OnRemove,
	function(Entity: jecs.Entity & number, Id: jecs.Id)
		local Model = World:get(Entity, ModelComponent)
		Model:Destroy()
	end
)

return false
