local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local RemoteEvents = ReplicatedStorage.RemoteEvents
local SetCharacterEvent = RemoteEvents.SetCharacter :: RemoteEvent

local LocalPlayer = PlayerService.LocalPlayer

SetCharacterEvent.OnClientEvent:Connect(function(Model: Model)
	LocalPlayer.Character = Model

	local Animate = Model:WaitForChild("Animate") :: LocalScript
	Animate.Enabled = false
	Animate.Enabled = true
end)
