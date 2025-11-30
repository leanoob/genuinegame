local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Singletons = ReplicatedStorage.Singletons
local Util = ReplicatedStorage.Util

local Quaternion = require(Util.Quaternion)

local Camera = require(Singletons.Camera)
local RoCamera = workspace.CurrentCamera :: Camera
RoCamera.CameraType = Enum.CameraType.Scriptable

local PI_2 = math.pi/2

local KeyPressed = UserInputService.IsKeyDown
local KeyW = Enum.KeyCode.W
local KeyS = Enum.KeyCode.S
local KeyD = Enum.KeyCode.D
local KeyA = Enum.KeyCode.A
local Space = Enum.KeyCode.Space
local KeyC = Enum.KeyCode.C

local function LengthSquared(Vec: Vector3)
	return Vec.X^2 + Vec.Y^2 + Vec.Z^2
end

UserInputService.InputChanged:Connect(function(Input, GPE)
	if GPE then return end
	if Camera.Controller ~= "FreeCamera" then return end

	if Input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

	local MouseUnlocked = Input.Delta == Vector3.zero

	if MouseUnlocked then
		return
	end

	local InputDelta = Input.Delta
	local XChange = math.rad(InputDelta.X)
	local YChange = math.rad(InputDelta.Y)

	local Yaw, Pitch = Camera.Yaw, Camera.Pitch

	Pitch = math.clamp((Pitch - YChange), -PI_2 + 0.1, PI_2 - 0.1)
	Yaw = ((Yaw - XChange) + math.pi) % (2 * math.pi) - math.pi

	Camera.Yaw = Yaw; Camera.Pitch = Pitch

	local YQuat = Quaternion.fromAxisAngle(Vector3.yAxis, Yaw)
	local RightAxis = YQuat:RotateVector(Vector3.xAxis)
	local XQuat = Quaternion.fromAxisAngle(RightAxis, Pitch)

	local NewRotation = XQuat * YQuat

	Camera.Rotation = NewRotation
end)

return function(DeltaTime: number)
	if Camera.Controller ~= "FreeCamera" then return end
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	UserInputService.MouseIconEnabled = false

	local ForwardDelta = 0
	local RightDelta = 0
	local VerticalDelta = 0

	if KeyPressed(UserInputService, KeyW) then
		ForwardDelta = ForwardDelta - 1
	end
	if KeyPressed(UserInputService, KeyS) then
		ForwardDelta = ForwardDelta + 1
	end
	if KeyPressed(UserInputService, KeyD) then
		RightDelta = RightDelta + 1
	end
	if KeyPressed(UserInputService, KeyA) then
		RightDelta = RightDelta - 1
	end
	if KeyPressed(UserInputService, Space) then
		VerticalDelta = VerticalDelta + 1
	end
	if KeyPressed(UserInputService, KeyC) then
		VerticalDelta = VerticalDelta - 1
	end

	local CameraRotation = Camera.Rotation
	local MoveVec = Vector3.zero

	if ForwardDelta ~= 0 then
		MoveVec = MoveVec + CameraRotation:RotateVector(Vector3.zAxis) * ForwardDelta
	end
	if RightDelta ~= 0 then
		MoveVec = MoveVec + CameraRotation:RotateVector(Vector3.xAxis) * RightDelta
	end
	if VerticalDelta ~= 0 then
		MoveVec = MoveVec + Vector3.new(0,VerticalDelta,0)
	end

	if LengthSquared(MoveVec) ~= 0 then
		Camera.Position = Camera.Position + MoveVec.Unit * DeltaTime * 20
	end

	RoCamera.CFrame = CameraRotation:ToCFrame(Camera.Position)
end
