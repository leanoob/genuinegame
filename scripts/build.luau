local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
-- local process = require("@lune/process")
-- local stdio = require("@lune/stdio")

local TargetServices = {
  "ReplicatedStorage",
  "ServerStorage"
}

-- local out = process.exec("rojo", {
--   "build",
--   "-o",
--   "rojo-output.rbxl"
-- })

-- if not out.ok then
--   stdio.ewrite(out.stderr)
--   process.exit(1)
-- end

local placefile = fs.readFile("assets.rbxl")
local game = roblox.deserializePlace(placefile)

local rojo_placefile = fs.readFile("rojo-output.rbxl")
local rojo_game = roblox.deserializePlace(rojo_placefile)

for i = 1,#TargetServices do
  local service_name  = TargetServices[i]
  local rojo_service = rojo_game:GetService(service_name)
  local game_service = game:GetService(service_name)

  for _,Object in next, rojo_service:GetChildren() do
    Object.Parent = game_service
  end
end

local new_placefile = roblox.serializePlace(game)
fs.writeFile("output.rbxl", new_placefile)
fs.removeFile("rojo-output.rbxl")

print("built to output.rbxl")
