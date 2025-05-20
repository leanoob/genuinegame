local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Packages.jecs)
local World = require(ServerStorage.Singletons.World)
local Components = ServerStorage.Components
local Mobs = require(ServerStorage.Singletons.Mobs)

local ModelComponent = require(Components.Model)

return function(Model: Model): jecs.Entity
	local Mob = World:entity()

	World:set(
		Mob,
		ModelComponent,
		Model
	)

	Mobs[Model] = Mob

	local WorkspaceCheck: RBXScriptConnection
	WorkspaceCheck = Model.AncestryChanged:Connect(function()
		if not Model:IsDescendantOf(workspace) then
			Mobs[Model] = nil
			if WorkspaceCheck then
				WorkspaceCheck:Disconnect()
			end
		end
	end)

	return Mob
end
