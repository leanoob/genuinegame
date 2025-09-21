local jecs = require(game:GetService("ReplicatedStorage").Packages.jecs)
local World = require(game:GetService("ServerStorage").Singletons.World)

-- return (World:component() :: any ) :: jecs.Id<{
-- 	Damage: {
-- 		Limit: number,
-- 		Amount: number
-- 	},
-- 	Types: {
-- 		Brute: number,
-- 		Burn: number,
-- 		Toxic: number,
-- 		Oxygen: number
-- 	}
-- }>
return World:component()
