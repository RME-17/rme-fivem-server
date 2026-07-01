-- Convenience command to open the Redline mechanic tablet without needing the
-- item in hand. Stand next to a vehicle and run /redlinetablet.
--
-- Gated to mechanic jobs. We accept the job by TYPE ('mechanic') OR by NAME, so
-- a character whose saved job object is missing the newer type field (set before
-- the job had type = 'mechanic') is not wrongly locked out.

local QBCore = exports['qb-core']:GetCoreObject()

local MechanicJobs = {
    mechanic = true,
    mechanic2 = true,
    mechanic3 = true,
    beeker = true,
    redline = true,
}

local function isMechanic(job)
    if not job then return false end
    return job.type == 'mechanic' or MechanicJobs[job.name] == true
end

RegisterCommand('redlinetablet', function()
    local pd = QBCore.Functions.GetPlayerData()
    local job = pd and pd.job
    if Config and Config.RequireJob and not isMechanic(job) then
        QBCore.Functions.Notify('You are not a Redline mechanic', 'error')
        return
    end
    TriggerEvent('qb-mechanicjob:client:useTablet')
end, false)

TriggerEvent('chat:addSuggestion', '/redlinetablet', 'Open the Redline mechanic tablet (stand next to a vehicle)')
