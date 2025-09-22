local ServerStorage = game:GetService("ServerStorage")
local PrefabQueue = require(ServerStorage.Singletons.PrefabQueue)

return function(Prefab: (any) -> (any), ...)
	PrefabQueue[#PrefabQueue+1] = {
		Prefab = Prefab,
		Args = ...
	}
end
