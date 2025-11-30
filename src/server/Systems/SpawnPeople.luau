local ServerStorage = game:GetService("ServerStorage")
local Singletons = ServerStorage.Singletons
local Components = ServerStorage.Components
local blink = require(ServerStorage.blink)

local World = require(Singletons.World)
local PlayerEntities = require(Singletons.Players)

local PlayerComponent = require(Components.Player)

local function AllowPlayerRespawn(Player: Player, Model: Model)
	local PlayerEntity = PlayerEntities[Player.UserId]
	if not PlayerEntity then return end

	local PlayerData = World:get(PlayerEntity, PlayerComponent)
	if not PlayerData then return end

	if PlayerData.Model == Model then
		PlayerData.Model = nil
	end

	PlayerData.RespawnAllowed = true

	blink.PlayerCharacterChange.Fire(Player, PlayerData)
end

local function TrackCharacter(Player: Player, Model: Model)
	local CancelEvents
	local PlayerAncestryChanged: RBXScriptConnection
	local CharacterAncestryChanged: RBXScriptConnection
	local HumanoidDied: RBXScriptConnection?

	PlayerAncestryChanged = Player.AncestryChanged:Once(function()
		CancelEvents = true
		
		if HumanoidDied and HumanoidDied.Connected then
			HumanoidDied:Disconnect()
		end

		if CharacterAncestryChanged.Connected then
			CharacterAncestryChanged:Disconnect()
		end

		if PlayerAncestryChanged.Connected then
			PlayerAncestryChanged:Disconnect()
		end
	end)

	CharacterAncestryChanged = Model.AncestryChanged:Connect(function()
		if Model.Parent then return end

		CancelEvents = true

		if PlayerAncestryChanged.Connected then
			PlayerAncestryChanged:Disconnect()
		end

		if HumanoidDied and HumanoidDied.Connected then
			HumanoidDied:Disconnect()
		end

		if CharacterAncestryChanged.Connected then
			CharacterAncestryChanged:Disconnect()
		end

		AllowPlayerRespawn(Player, Model)
	end)

	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		while not CancelEvents do
			Humanoid = Model:FindFirstChildOfClass("Humanoid")
			if Humanoid then break end

			task.wait()
		end
	end

	if CancelEvents then return end

	HumanoidDied = Humanoid.Died:Once(function()
		task.wait(3)
		if CancelEvents then return end

		if PlayerAncestryChanged.Connected then
			PlayerAncestryChanged:Disconnect()
		end

		if CharacterAncestryChanged.Connected then
			CharacterAncestryChanged:Disconnect()
		end

		if (HumanoidDied :: RBXScriptConnection).Connected then
			(HumanoidDied :: RBXScriptConnection):Disconnect()
		end

		AllowPlayerRespawn(Player, Model)
	end)
end

blink.RequestRespawn.On(function(Player)
	local PlayerEntity = PlayerEntities[Player.UserId]
	local PlayerData = World:get(PlayerEntity, PlayerComponent)

	if not PlayerData.RespawnAllowed then
		return
	end

	PlayerData.RespawnAllowed = false
	
	blink.PlayerCharacterChange.Fire(Player, PlayerData)

	local CharacterAdded
	local AncestryChanged
	
	CharacterAdded = Player.CharacterAdded:Once(function(Model)
		TrackCharacter(Player, Model)
		
		if AncestryChanged.Connected then
			AncestryChanged:Disconnect()
		end

		if CharacterAdded.Connected then
			CharacterAdded:Disconnect()
		end
	end)
	Player:LoadCharacter()

	AncestryChanged = Player.AncestryChanged:Once(function()
		CharacterAdded:Disconnect()
		AncestryChanged:Disconnect()
	end)
end)

game:GetService("Players").PlayerAdded:Connect(function(Player)
	Player:WaitForChild("Backpack")
	-- if not Player or not Player.Parent then return end
	-- Player:LoadCharacter()

	blink.PlayerCharacterChange.Fire(Player, {
		Model = nil,
		RespawnAllowed = true
	})
end)

return false
