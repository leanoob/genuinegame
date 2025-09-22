local Tool = script.Parent
local Remote = Tool.Remote

local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

Tool.Activated:Connect(function()
	Remote:FireServer(Mouse.Hit)
end)
