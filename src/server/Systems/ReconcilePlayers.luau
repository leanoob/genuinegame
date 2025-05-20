local ServerStorage = game:GetService("ServerStorage")
local PlayerService = game:GetService("Players")

local World = require(ServerStorage.Singletons.World)
local Players = require(ServerStorage.Singletons.Players)
local Components = ServerStorage.Components

local PlayerComponent = require(Components.Player)

PlayerService.PlayerAdded:Connect(function(Player)
	if Players[Player.UserId] then
		World:set(
			Players[Player.UserId],
			PlayerComponent,
			Player
		)

		return
	end
	

	local NewPlayerEntity = World:entity()
	World:set(
		NewPlayerEntity,
		PlayerComponent,
		Player
	)
	
	Players[Player.UserId] = NewPlayerEntity
end)

PlayerService.PlayerRemoving:Connect(function(Player)
	local Entity = Players[Player.UserId]
	
	assert(Entity)

	World:remove(Entity, PlayerComponent)
end)

return false
