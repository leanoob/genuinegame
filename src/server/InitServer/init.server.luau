local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local RunOrder = require(ServerStorage.Singletons.RunOrder)
local PhaseOrder = RunOrder.PhaseOrder
local Phases = RunOrder.Phases

local jabby = require(ReplicatedStorage.Packages.jabby)

local scheduler = jabby.scheduler.create()

jabby.register{
    applet = jabby.applets.world,
    name = "world",
    configuration = {
        world = require(ServerStorage.Singletons.World)
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
    if RunService:IsStudio() then 
        return true
    end

    return false
end)

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

game:GetService("RunService").Heartbeat:Connect(function(DeltaTime)
    for i = 1,#OrderedSystems do
        local System = OrderedSystems[i]
        scheduler:run(System[1], System[2], DeltaTime)
    end
end)
