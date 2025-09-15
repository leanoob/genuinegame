local ServerStorage = game:GetService("ServerStorage")
local PlayerService = game:GetService("Players")

local Prefabs = ServerStorage.Prefabs

local PlayerPrefab = require(Prefabs.Player)

PlayerService.PlayerAdded:Connect(function(Player)
	PlayerPrefab(Player)

	Player:LoadCharacter()
end)

return nil
