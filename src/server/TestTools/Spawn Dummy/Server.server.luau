local Tool = script.Parent :: Tool
local Remote = Tool.Remote :: RemoteEvent

local ServerStorage = game:GetService("ServerStorage")
local Prefabs = ServerStorage.Prefabs
local Commands = ServerStorage.Util.Commands

local SpawnPrefab = require(Commands.SpawnPrefab)
local MobPrefab = require(Prefabs.HumanoidMob)

Remote.OnServerEvent:Connect(function(Player: Player, MouseLocation: CFrame)
	SpawnPrefab(MobPrefab, {CFrame = MouseLocation})
end)
