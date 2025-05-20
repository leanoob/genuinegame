local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage =  game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Packages.jecs)
local World = require(ServerStorage.Singletons.World)
local Players = require(ServerStorage.Singletons.Players)
local Components = ServerStorage.Components

local PlayerComponent = require(Components.Player)

return function(Player: Player): jecs.Entity
	if Players[Player.UserId] then
		World:set(
			Players[Player.UserId],
			PlayerComponent,
			Player
		)

		Player.AncestryChanged:Once(function()
			World:remove(Players[Player.UserId], PlayerComponent)
		end)

		return Players[Player.UserId]
	end

	local NewPlayerEntity = World:entity()
	World:set(
		NewPlayerEntity,
		PlayerComponent,
		Player
	)

	Players[Player.UserId] = NewPlayerEntity

	Player.AncestryChanged:Once(function()
		World:remove(Players[Player.UserId], PlayerComponent)
	end)

	return NewPlayerEntity
end
