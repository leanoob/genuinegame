local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Singletons = ServerStorage.Singletons
local DespawnQueue = require(Singletons.DespawnQueue)

local jecs = require(ReplicatedStorage.Packages.jecs)

return function(ToDespawn: jecs.Entity | {[number]: jecs.Entity})
	if typeof(ToDespawn) == "table" then
		for i = 1,#ToDespawn do
			DespawnQueue[#DespawnQueue+1] = ToDespawn[i]
		end

		return
	end

	DespawnQueue[#DespawnQueue+1] = ToDespawn
end
