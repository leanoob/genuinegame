local PlayerService = game:GetService("Players")

PlayerService.PlayerAdded:Connect(function(Player)
  Player:WaitForChild("Backpack") -- Backpack is added when player has loaded
  if not Player.Parent then return end

  Player:LoadCharacter()
end)
