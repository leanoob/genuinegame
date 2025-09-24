local Tool = script.Parent :: Tool
local Remote = Tool.Remote :: RemoteEvent

local ServerStorage = game:GetService("ServerStorage")
local Singletons = ServerStorage.Singletons

local World = require(Singletons.World)
local Commands = ServerStorage.Util.Commands

local InstanceEntityMap = require(Singletons.InstanceEntityMap)
local DeferDespawn = require(Commands.DespawnEntity)

Remote.OnServerEvent:Connect(function(Player: Player, MouseTarget: Instance?)
	if not MouseTarget then return end
	if typeof(MouseTarget) ~= "Instance" then return end
	if not MouseTarget.Parent then return end

	local Model = MouseTarget.Parent
	local IsRegistered = InstanceEntityMap[Model]
	
	if IsRegistered then
		local Entity = InstanceEntityMap[Model]
		if not Entity then return end
		if not World:contains(Entity) then return end

		DeferDespawn(Entity)
		return
	end

	local Entity = InstanceEntityMap[MouseTarget]
	if not Entity then return end
	if not World:contains(Entity) then return end

	DeferDespawn(Entity)
end)
