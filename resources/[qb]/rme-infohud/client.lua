local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}

local function jobLabel(data)
    if not data or not data.job then return 'Civilian' end
    local name = data.job.name
    if not name or name == 'unemployed' then return 'Civilian' end
    return data.job.label or name
end

local function gangLabel(data)
    if not data or not data.gang then return 'No Gang' end
    local name = data.gang.name
    if not name or name == 'none' then return 'No Gang' end
    return data.gang.label or name
end

local function sendUpdate()
    if not PlayerData or not PlayerData.citizenid then return end
    local money = PlayerData.money or {}
    SendNUIMessage({
        action = 'update',
        serverId = GetPlayerServerId(PlayerId()),
        citizenId = PlayerData.citizenid or '---',
        cash = money.cash or 0,
        bank = money.bank or 0,
        job = jobLabel(PlayerData),
        jobGrade = (PlayerData.job and PlayerData.job.grade and PlayerData.job.grade.name) or '',
        onDuty = (PlayerData.job and PlayerData.job.onduty) or false,
        gang = gangLabel(PlayerData),
    })
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    SendNUIMessage({ action = 'show' })
    sendUpdate()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    SendNUIMessage({ action = 'hide' })
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
    sendUpdate()
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    PlayerData.gang = gang
    sendUpdate()
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(onDuty)
    if PlayerData.job then PlayerData.job.onduty = onDuty end
    sendUpdate()
end)

RegisterNetEvent('hud:client:OnMoneyChange', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    sendUpdate()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Wait(800)
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData and PlayerData.citizenid then
        SendNUIMessage({ action = 'show' })
        sendUpdate()
    end
end)

-- safety-net refresh so balances/job/gang never go stale
CreateThread(function()
    while true do
        Wait(3000)
        if LocalPlayer.state.isLoggedIn then
            PlayerData = QBCore.Functions.GetPlayerData()
            sendUpdate()
        end
    end
end)
