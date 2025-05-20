local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local Utils = ServerStorage.Util

local SetCharacterRemote = ReplicatedStorage.RemoteEvents.SetCharacter :: RemoteEvent
local Mobs = require(ServerStorage.Singletons.Mobs)

local jecs = require(ReplicatedStorage.Packages.jecs)
local World = require(ServerStorage.Singletons.World)
local Components = ServerStorage.Components
local Hooks = require(Utils.HookCallback)

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

local function WatchHumanoid(Player: Player, Humanoid: Humanoid)
	local Model = Humanoid.Parent

	local StateChanged = false

	local Event1: RBXScriptConnection, Event2: RBXScriptConnection
	Event1 = Humanoid.HealthChanged:Connect(function()
		StateChanged = true
	end)
	Event2 = Model.AncestryChanged:Connect(function()
		StateChanged = true
	end)
	
	while task.wait() do
		if not StateChanged then continue end
		if Humanoid.Health > 0 and Model:IsDescendantOf(workspace) then continue end
		Event1:Disconnect()
		Event2:Disconnect()
		StateChanged = false

		if Model.Parent then
			Model:Destroy()
		end

		local CharacterModel = MakeCharacterFromPlayer(Player)
		if not CharacterModel then
			return
		end

		GivePlayerModelOwnership(Player, CharacterModel)
		SetCharacterRemote:FireClient(Player, CharacterModel)

		Humanoid = CharacterModel:FindFirstChildOfClass("Humanoid")

		Model = CharacterModel

		Event1 = Humanoid.HealthChanged:Connect(function()
			StateChanged = true
		end)
		Event2 = Model.AncestryChanged:Connect(function()
			StateChanged = true
		end)
	end
end

local function SetupCharacterRespawn(Player: Player, Model: Model)
	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	assert(Humanoid)

	local Thread = task.spawn(WatchHumanoid, Player, Humanoid)

	Player.AncestryChanged:Once(function()
		coroutine.close(Thread)
	end)
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
		Mobs[CharacterModel] = NewMob

		local WorkspaceCheck: RBXScriptConnection
		WorkspaceCheck = CharacterModel.AncestryChanged:Connect(function()
			if not CharacterModel:IsDescendantOf(workspace) then
				Mobs[CharacterModel] = nil
				if WorkspaceCheck then
					WorkspaceCheck:Disconnect()
				end
			end
		end)

		World:add(
			ID,
			jecs.pair(PlayerCharacterRelation, NewMob)
		)

		GivePlayerModelOwnership(Player, CharacterModel)
		SetCharacterRemote:FireClient(Player, CharacterModel)
		SetupCharacterRespawn(Player, CharacterModel)

		return
	else
		local CharacterModel = World:get(CharacterEntity, ModelComponent)
		if (not CharacterModel.Parent) or (not CharacterModel:FindFirstChildOfClass("Humanoid")) or (CharacterModel:FindFirstChildOfClass("Humanoid").Health <= 0) then
			if CharacterModel.Parent then
				CharacterModel:Destroy()
			end
			
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
		SetupCharacterRespawn(Player, CharacterModel)
		
		return
	end
end

Hooks.GetCallback(
	jecs.OnChange,
	PlayerComponent,
	ChangeOrAdd
)

Hooks.GetCallback(
	jecs.OnAdd,
	PlayerComponent,
	ChangeOrAdd
)

return false
