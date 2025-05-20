local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")

local SetCharacterRemote = ReplicatedStorage.RemoteEvents.SetCharacter :: RemoteEvent

local jecs = require(ReplicatedStorage.Packages.jecs)
local World = require(ServerStorage.Singletons.World)
local Components = ServerStorage.Components

local PlayerComponent = require(Components.Player)
local ModelComponent = require(Components.Model)
local PlayerCharacterRelation = require(Components.PlayerCharacter)

local function GivePlayerModelOwnership(Player: Player, Model: Model)
	for _, Object in next, Model:GetDescendants() do
		if Object:IsA("BasePart") and not Object.Anchored then
			Object:SetNetworkOwner(Player)
		end
	end
end

local function MakeCharacterFromPlayer(Player: Player): Model?
	local UserID = Player.UserId
	if UserID < 0 then -- Studio Server Test
		UserID = 45204433
	end
	local CharacterModel = PlayerService:CreateHumanoidModelFromUserId(UserID) -- Blocking
	if not Player.Parent then -- Player left before loading finished
		CharacterModel:Destroy()
		return
	end
	CharacterModel.Name = Player.Name
	CharacterModel.Parent = workspace

	return CharacterModel
end

local function ChangeOrAdd(ID, _, Player)
	Player:WaitForChild("Backpack")
	local CharacterEntity = World:target(ID, PlayerCharacterRelation)
	if not CharacterEntity then
		local CharacterModel = MakeCharacterFromPlayer(Player)
		if not CharacterModel then
			return
		end

		local NewMob = World:entity()
		World:set(
			NewMob,
			ModelComponent,
			CharacterModel
		)

		World:add(
			ID,
			jecs.pair(PlayerCharacterRelation, NewMob)
		)

		GivePlayerModelOwnership(Player, CharacterModel)
		SetCharacterRemote:FireClient(Player, CharacterModel)

		return
	else
		local CharacterModel = World:get(CharacterEntity, ModelComponent)
		if not CharacterModel.Parent then
			CharacterModel = MakeCharacterFromPlayer(Player)
			if not CharacterModel then
				return
			end

			World:set(
				CharacterEntity,
				ModelComponent,
				CharacterModel
			)
		end

		GivePlayerModelOwnership(Player, CharacterModel)
		SetCharacterRemote:FireClient(Player, CharacterModel)
		
		return
	end
end

World:set(
	PlayerComponent,
	jecs.OnChange,
	ChangeOrAdd
)

World:set(
	PlayerComponent,
	jecs.OnAdd,
	ChangeOrAdd
)

return false
