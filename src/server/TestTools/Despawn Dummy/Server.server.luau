local Tool = script.Parent :: Tool
local Remote = Tool.Remote :: RemoteEvent

local ServerStorage = game:GetService("ServerStorage")
local Singletons = ServerStorage.Singletons

local World = require(Singletons.World)
local Commands = ServerStorage.Util.Commands

local Mobs = require(Singletons.Mobs)
local DeferDespawn = require(Commands.DespawnEntity)

Remote.OnServerEvent:Connect(function(Player: Player, MouseTarget: Instance?)
	if not MouseTarget then return end
	if typeof(MouseTarget) ~= "Instance" then return end
	if not MouseTarget.Parent then return end

	local Model = MouseTarget.Parent
	if not Model:IsA("Model") then return end

	local Entity = Mobs[Model]
	if not Entity then return end
	if not World:contains(Entity) then return end

	DeferDespawn(Entity)
end)
