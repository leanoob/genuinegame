local jecs = require(game:GetService("ReplicatedStorage").Packages.jecs)
local World = require(game:GetService("ServerStorage").Singletons.World)

-- return (World:component() :: any ) :: jecs.Id<{
-- 	BloodCapacity: number,
-- 	Blood: number,
-- 	DepletionMultiplier: number
-- }>
return World:component()
