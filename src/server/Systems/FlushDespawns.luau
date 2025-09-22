local ServerStorage = game:GetService("ServerStorage")
local Singletons = ServerStorage.Singletons

local World = require(Singletons.World)
local DespawnQueue = require(Singletons.DespawnQueue)

return function()
	for i = 1,#DespawnQueue do
		local Entity = DespawnQueue[i]
		if not World:contains(Entity) then continue end

		World:delete(Entity)
	end

	table.clear(DespawnQueue)
end
