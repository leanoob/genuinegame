local Quaternion = require(game:GetService("ReplicatedStorage").Util.Quaternion)

return {
	Position = Vector3.new(),
	Rotation = Quaternion.new(0,0,0,1),
	Yaw = 0,
	Pitch = 0,
	Mode = "Standing", -- Standing | Floating
	PreviousMode = "Standing"
}
