local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Singletons = ServerStorage.Singletons
local Components = ServerStorage.Components
local World = require(Singletons.World)

local ParentComponent = require(Components:FindFirstChild("Parent"))
local ChildrenComponent = require(Components.Children)

local jecs = require(ReplicatedStorage.Packages.jecs)

local ChildrenRemoves = {}
local ParentRemoves = {}

World:set(
	ChildrenComponent,
	jecs.OnRemove,
	function(Entity, ...)
		local Children = World:get(Entity, ChildrenComponent)

		print("Children remove", ...)

		for i = 1,#Children do
			ChildrenRemoves[#ChildrenRemoves+1] = Children[i]
		end
	end
)

World:set(
	ParentComponent,
	jecs.OnRemove,
	function(Entity, ...)
		local Parent = World:get(Entity, ParentComponent)

		print("Parent remove", ...)

		ParentRemoves[#ParentRemoves+1] = {Parent, Entity}
	end
)

return function()
	if #ChildrenRemoves>0 then
		local Seen = {}
		local i = 1
		while i <= #ChildrenRemoves do
			local Entity = ChildrenRemoves[i]
			i = i + 1
			if not World:contains(Entity) then continue end

			local Children = World:get(Entity, ChildrenComponent)
			if Children then
				local ChildList = Children.List
				for i2 = 1,#ChildList do
					local Child = ChildList[i2]
					if not Seen[Child] then
						Seen[Child] = true
						ChildrenRemoves[#ChildrenRemoves+1] = Child
					end
				end
			end

			World:delete(Entity)
		end
		
		ChildrenRemoves = {}
	end

	if #ParentRemoves>0 then
		for i = 1,#ParentRemoves do
			local Entry = ParentRemoves[i]
			local Parent = Entry[1]

			if not World:contains(Parent) then continue end

			local Children = World:get(Parent, ChildrenComponent)
			if not Children then continue end

			local Child = Entry[2]

			local List = Children.List
			local Map = Children.Map

			local Index =  Map[Child]
			if not Index then continue end

			local Last = #List
			if Index ~= Last then
				local Swap = List[Last]
				Map[Swap] = Index
				List[Index] = Swap
			end

			Map[Child] = nil
			List[Last] = nil
		end

		ParentRemoves = {}
	end
end
