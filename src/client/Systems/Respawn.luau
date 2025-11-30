local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local vide = require(ReplicatedStorage.Packages.vide)
local blink = require(ReplicatedStorage.blink)
local Singletons = ReplicatedStorage.Singletons

local PlayerData = require(Singletons.Player)
local Camera = require(Singletons.Camera)

local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui

local create = vide.create
local source = vide.source
local root = vide.root
-- local effect = vide.effect

local RespawnAllowed = source(PlayerData.RespawnAllowed)

UserInputService.InputBegan:Connect(function(Input, GPE)
	if GPE then return end

	if Input.KeyCode == Enum.KeyCode.E then
		if RespawnAllowed() then
			blink.RequestRespawn.Fire()
		end
	end
end)

root(function()
	create "ScreenGui" {
		ResetOnSpawn = false,
		Name = "RespawnUI",
		Enabled = function() return RespawnAllowed() end,
		Parent = PlayerGui,

		create "TextLabel" {
			Text = "Press E to respawn",
			AnchorPoint = Vector2.new(0.5,0.5),
			Size = UDim2.new(0.5, 0, 0.15, 0),
			TextScaled = true,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.7, 0)
		}
	}
end)

blink.PlayerCharacterChange.On(function(CharacterData)
	RespawnAllowed(CharacterData.RespawnAllowed)
	local RoCamera = workspace.CurrentCamera

	if CharacterData.RespawnAllowed then
		RoCamera.CameraType = Enum.CameraType.Scriptable
		Camera.Position = workspace.CurrentCamera.CFrame.Position
		Camera.Controller = "FreeCamera"
	else
		RoCamera.CameraType = Enum.CameraType.Custom
		Camera.Controller = "Roblox"
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
	end
end)

return false
