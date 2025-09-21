local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Packages.jecs)
local World = require(ServerStorage.Singletons.World)

local Components = ServerStorage.Components

return function (Prefab: {[string]: any}, Overrides: {[string]: any}?, Removes: {[string]: any}?): jecs.Entity
    local ComponentMap = table.clone(Prefab)

    if Overrides then
        for ComponentName, ComponentValue in Overrides do       
            ComponentMap[ComponentName] = ComponentValue
        end
    end

    if Removes then
        for ComponentName,_ in Removes do
            ComponentMap[ComponentName] = nil
        end
    end

    local Entity = World:entity()
    for ComponentName, ComponentValue in ComponentMap do
        local ComponentModule = Components:FindFirstChild(ComponentName)
        if not ComponentModule then
            warn("Attempt to create non existant component", ComponentName, debug.info(1, "sn"))
                        
            continue
        end

        local Component = require(ComponentModule)
        World:set(Entity, Component, ComponentValue)
    end

    return Entity
end

