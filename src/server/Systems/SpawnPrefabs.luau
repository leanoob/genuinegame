local ServerStorage = game:GetService("ServerStorage")
local Singletons = ServerStorage.Singletons

local PrefabQueue = require(Singletons.PrefabQueue)

return function()
	for i = 1,#PrefabQueue do
		local Command = PrefabQueue[i]
		Command.Prefab(Command.Args)
	end

	table.clear(PrefabQueue)
end
