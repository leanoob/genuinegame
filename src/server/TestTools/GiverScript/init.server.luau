local ToolFolder = script.Parent
local StarterPack = game:GetService("StarterPack")

if game:GetService("RunService"):IsStudio() then
	for _,Tool in next, ToolFolder:GetChildren() do
		if not Tool:IsA("Tool") then continue end

		Tool:Clone().Parent = StarterPack
	end
end
