local ServerStorage = game:GetService("ServerStorage")
local Systems = ServerStorage.Systems

return {
    PhaseOrder = {
        "Init",
        "Reconcile"
    },
    Phases = {
        Init = {
            require(Systems.ModelDeletions),
            require(Systems.FlushDespawns),
            require(Systems.HierarchySync),
            require(Systems.SpawnPrefabs),
            require(Systems.Players),
            require(Systems.SpawnPeople)
        },
        Reconcile = {
        }
    }
}
