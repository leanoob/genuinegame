local jecs = require(game:GetService("ReplicatedStorage").Packages.jecs)
local World = require(game:GetService("ServerStorage").Singletons.World)

local Component = World:component()
World:set(Component, jecs.Name, script.Name)
return Component
