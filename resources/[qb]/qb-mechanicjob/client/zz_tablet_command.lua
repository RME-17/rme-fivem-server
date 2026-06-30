-- Convenience command to open the Redline mechanic tablet without needing the
-- item in hand. Stand next to a vehicle and run /redlinetablet. Job-gated to
-- mechanics (same rule as the useable item).

local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('redlinetablet', function()
    local pd = QBCore.Functions.GetPlayerData()
    if Config and Config.RequireJob and (not pd or not pd.job or pd.job.type ~= 'mechanic') then
        QBCore.Functions.Notify('You are not a Redline mechanic', 'error')
        return
    end
    TriggerEvent('qb-mechanicjob:client:useTablet')
end, false)

TriggerEvent('chat:addSuggestion', '/redlinetablet', 'Open the Redline mechanic tablet (stand next to a vehicle)')
