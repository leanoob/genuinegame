local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Resources = ReplicatedStorage.Resources
local RunOrder = require(ServerStorage.Singletons.RunOrder)
local PhaseOrder = RunOrder.PhaseOrder
local Phases = RunOrder.Phases

local InstanceEntityMap = require(ServerStorage.Singletons.InstanceEntityMap)
local LiveDebuggers = require(Resources.LiveDebuggers)

require(ServerStorage.Singletons.World)

local jabby = require(ReplicatedStorage.Packages.jabby)
local scheduler = jabby.scheduler.create()

jabby.register{
    applet = jabby.applets.world,
    name = "world",
    configuration = {
        world = require(ServerStorage.Singletons.World),
        get_entity_from_part = function(Part)
            local Entity = InstanceEntityMap[Part]
            if not Entity then return end

            return Entity, Part
        end
    }
}

jabby.register{
    applet = jabby.applets.scheduler,
    name = "scheduler",
    configuration = {
        scheduler = scheduler
    }
}

jabby.set_check_function(function(Player)
    if RunService:IsStudio() or Player.UserId == game.CreatorId or LiveDebuggers[Player.UserId] then 
        return true
    end

    return false
end)
jabby.broadcast_server()

for i = 1,#PhaseOrder do -- Remove no-ops
    local Systems = Phases[PhaseOrder[i]]

    for i2 = #Systems,1,-1 do
    	if Systems[i2] == false then
    		table.remove(Systems, i2)
    	end
    end
end

local OrderedSystems = {}
for i = 1,#PhaseOrder do -- Register
    local Systems = Phases[PhaseOrder[i]]

    for i = 1,#Systems do
        local Split = debug.info(Systems[i], "s"):split(".")
        local SystemName = Split[#Split]

        local ID = scheduler:register_system{
            name = SystemName,
            phase = PhaseOrder[i],
            paused = false
        }
        OrderedSystems[#OrderedSystems+1] = {ID, Systems[i]}
    end
end

while RunService.PostSimulation:Wait() do
    for i = 1,#OrderedSystems do
        local System = OrderedSystems[i]
        scheduler:run(System[1], System[2], 0)
    end
end
