local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Systems = ReplicatedStorage.Systems

return {
    PhaseOrder = {
        "Init",
        "Reconcile"
    },
    Phases = {
        Init = {
            -- require(Systems.ReconcilePlayers)
            require(Systems.FreeCamera),
            require(Systems.Respawn)
        },
        Reconcile = {
            
        }
    }
}
