local ServerStorage = game:GetService("ServerStorage")
local PlayerService = game:GetService("Players")
local Singletons = ServerStorage.Singletons

local World = require(Singletons.World)
local Players = require(Singletons.Players)
local Components = ServerStorage.Components

local PlayerComponent = require(Components.Player)

local JoinedPlayers = {}
local LeftPlayers = {}

PlayerService.PlayerAdded:Connect(function(Player)
	JoinedPlayers[#JoinedPlayers+1] = Player
end)
PlayerService.PlayerRemoving:Connect(function(Player)
	LeftPlayers[#LeftPlayers+1] = Player
end)

return function()
	for i = 1,#LeftPlayers do
		local Entity = Players[LeftPlayers[i]]
		World:delete(Entity)
		Players[LeftPlayers[i]] = nil
	end
	
	for i = 1,#JoinedPlayers do
		local Player = JoinedPlayers[i]
		if not Player.Parent then continue end

		print("Creating new player for", Player)
		local NewPlayerEntity = World:entity()
		World:set(NewPlayerEntity, PlayerComponent, Player)
		Players[Player] = NewPlayerEntity

		Player:LoadCharacter()
	end

	if #LeftPlayers>0 then
		LeftPlayers = {}
	end
	if #JoinedPlayers>0 then
		JoinedPlayers = {}
	end
end
