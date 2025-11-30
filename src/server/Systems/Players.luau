local PlayerService = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local Singletons = ServerStorage.Singletons
local Components = ServerStorage.Components

local PlayerEntities = require(Singletons.Players)
local World = require(Singletons.World)

local PlayerComponent = require(Components.Player)

PlayerService.PlayerAdded:Connect(function(Player)
	local UserID = Player.UserId

	if PlayerEntities[UserID] then
		Player:Kick("Rejoin")
		return
	end

	local PlayerEntity = World:entity()

	World:set(
		PlayerEntity,
		PlayerComponent,
		{
			RespawnAllowed = true,
			Model = nil
		}
	)
	
	PlayerEntities[UserID] = PlayerEntity
end)

PlayerService.PlayerRemoving:Connect(function(Player)
	local UserID = Player.UserId

	local PlayerEntity = PlayerEntities[UserID]

	if not PlayerEntity then
		return
	end

	World:delete(PlayerEntity)
end)

return false
