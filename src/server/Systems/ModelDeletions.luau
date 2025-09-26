local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Singletons = ServerStorage.Singletons
local Components = ServerStorage.Components
local Tags = ServerStorage.Tags
local Commands = ServerStorage.Util.Commands
local jecs = require(ReplicatedStorage.Packages.jecs)

local World = require(Singletons.World)
local InstanceEntityMap = require(Singletons.InstanceEntityMap)

local ModelComponent = require(Components.Model)
local ModelOptionalTag = require(Tags.ModelOptional)

local DeferDespawn = require(Commands.DespawnEntity)

World:set(
	ModelComponent,
	jecs.OnRemove,
	function(Entity: jecs.Entity, Id: jecs.Id)
		local Model = World:get(Entity :: jecs.Entity<any> & number, ModelComponent)
		if InstanceEntityMap[Model] == Entity then
			InstanceEntityMap[Model] = nil
			Model:Destroy()
		end
	end
)

World:set(
	ModelComponent,
	jecs.OnAdd,
	function (Entity: jecs.Entity, Id: jecs.Id)
		local Model = World:get(Entity :: jecs.Entity<any> & number, ModelComponent) :: Model?
		if not Model then return end

		InstanceEntityMap[Model] = Entity

		local AncestryChange
		AncestryChange = Model.AncestryChanged:Connect(function(_, Parent: Instance?)
			if not World:contains(Entity :: jecs.Entity<any> & number) then
				if AncestryChange.Connected then
					AncestryChange:Disconnect()
				end
			end
			if Parent == nil then
				if World:has(ModelOptionalTag) then
					if AncestryChange.Connected then
						AncestryChange:Disconnect()
					end

					return
				end
				DeferDespawn(Entity)
				if AncestryChange.Connected then
					AncestryChange:Disconnect()
				end
			end
		end)
	end
)

return false
