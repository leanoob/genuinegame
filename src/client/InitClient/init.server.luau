local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunOrder = require(ReplicatedStorage.Singletons.RunOrder)
local PhaseOrder = RunOrder.PhaseOrder
local Phases = RunOrder.Phases

local vide = require(ReplicatedStorage.Packages.vide)

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

-- local create = vide.create

-- local test = create "ScreenGui" {
--     create "Frame" {
--         AnchorPoint = Vector2.new(0.5, 0.5),
--         Position = UDim2.fromScale(0.5, 0.5),
--         Size = UDim2.fromScale(0.4, 0.7),

--         create "TextLabel" {
--             Text = "hi",
--             Size = UDim2.fromScale(1, 1)
--         },

--         create "TextLabel" {
--             Text = "bye",
--             Size = UDim2.fromScale(1, 1)
--         },

--         create "TextButton" {
--             Text = "click me",
--             Size = UDim2.fromScale(1, 1),
--             TextScaled = true,

--             Activated = function()
--                 print "clicked!"
--             end
--         }
--     },

--     Parent = game.Players.LocalPlayer.PlayerGui
-- }
