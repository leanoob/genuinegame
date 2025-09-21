local jecs = require(game:GetService("ReplicatedStorage").Packages.jecs)
local World = require(game:GetService("ServerStorage").Singletons.World)

-- return (World:component() :: any ) :: jecs.Id<{
-- 	Gases: {},
-- 	Capacity: number
-- }>
return World:component()
