local PlayerService = game:GetService("Players")

PlayerService.PlayerAdded:Connect(function(Player)
  Player.CharacterAdded:Connect(function(Model)
    local Humanoid = Model:WaitForChild("Humanoid")
    Humanoid.Died:Connect(function()
      Player:LoadCharacter()
    end)
  end)
  
  Player:WaitForChild("Backpack") -- Backpack is added when player has loaded
  if not Player.Parent then return end

  Player:LoadCharacter()
end)
