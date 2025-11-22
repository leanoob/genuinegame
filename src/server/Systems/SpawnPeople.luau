game:GetService("Players").PlayerAdded:Connect(function(Player)
	Player:WaitForChild("Backpack")
	if not Player or not Player.Parent then return end
	Player:LoadCharacter()
end)

return false
