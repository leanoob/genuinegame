local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunOrder = require(ReplicatedStorage.Singletons.RunOrder)
local PhaseOrder = RunOrder.PhaseOrder
local Phases = RunOrder.Phases

for i = 1,#PhaseOrder do -- Remove no-ops
    local Systems = Phases[PhaseOrder[i]]

    for i2 = #Systems,1,-1 do
    	if Systems[i2] == false then
    		table.remove(Systems, i2)
    	end
    end
end

game:GetService("RunService").Heartbeat:Connect(function(DeltaTime)
    for i = 1,#PhaseOrder do
        local Systems = Phases[PhaseOrder[i]]
        for i2 = 1,#Systems do
            Systems[i2](DeltaTime)
        end
    end
end)
