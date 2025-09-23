local jecs = require(game:GetService("ReplicatedStorage").Packages.jecs)
local World = require(game:GetService("ServerStorage").Singletons.World)

-- return (World:component() :: any ) :: jecs.Id<{
-- 	Slots: {},
-- 	Capacity: number
-- }>
local Component = World:component()
World:set(Component, jecs.Name, script.Name)
return Component
