local ServerStorage = game:GetService("ServerStorage")
local Systems = ServerStorage.Systems

-- Ideally this table is only initialized with "official" systems. If you want to add a system, just insert it at runtime.
return {
    PhaseOrder = {
        "Init",
        "Reconcile"
    },
    Phases = {
        Init = {
            require(Systems.ModelDeletions),
            require(Systems.FlushDespawns),
            require(Systems.SpawnPrefabs)
        },
        Reconcile = {
            require(Systems.ReconcilePlayers),
            require(Systems.HeartProcessFluids)
        }
    }
}
