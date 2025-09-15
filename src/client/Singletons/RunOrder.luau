local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Systems = ReplicatedStorage.Systems

-- Ideally this table is only initialized with "official" systems. If you want to add a system, just insert it at runtime.
return {
    PhaseOrder = {
        "Init",
        "Reconcile"
    },
    Phases = {
        Init = {
            -- require(Systems.ReconcilePlayers)
        },
        Reconcile = {

        }
    }
}
