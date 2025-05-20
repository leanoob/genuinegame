local ServerStorage = game:GetService("ServerStorage")
local PlayerService = game:GetService("Players")

local Prefabs = ServerStorage.Prefabs
local PlayerPrefab = require(Prefabs.Player)

PlayerService.PlayerAdded:Connect(function(Player)
	PlayerPrefab(Player) -- self cleaning
end)

return false
