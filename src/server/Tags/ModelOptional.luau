local jecs = require(game:GetService("ReplicatedStorage").Packages.jecs)
local World = require(game:GetService("ServerStorage").Singletons.World)

local Component = World:entity()
World:set(Component, jecs.Name, script.Name)
return Component
