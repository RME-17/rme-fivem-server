-- RME map dressing for the Benny's MLO.
-- Hides clutter props (Config.MapHides) and spawns decorative props such as extra
-- car lifts/ramps (Config.MapProps). Fully config-driven - no CodeWalker needed.

local spawnedProps = {}

local function applyModelHides()
    if not Config.MapHides then return end
    for i = 1, #Config.MapHides do
        local h = Config.MapHides[i]
        if h and h.coords and h.model then
            local model = type(h.model) == 'number' and h.model or GetHashKey(h.model)
            CreateModelHide(h.coords.x, h.coords.y, h.coords.z, h.radius or 1.0, model, false)
        end
    end
end

local function spawnDecorProps()
    if not Config.MapProps then return end
    for i = 1, #Config.MapProps do
        local p = Config.MapProps[i]
        if p and p.coords and p.model then
            local model = type(p.model) == 'number' and p.model or GetHashKey(p.model)
            if IsModelValid(model) then
                RequestModel(model)
                local timeout = 0
                while not HasModelLoaded(model) and timeout < 100 do
                    Wait(50)
                    timeout = timeout + 1
                end
                if HasModelLoaded(model) then
                    local obj = CreateObject(model, p.coords.x, p.coords.y, p.coords.z, false, false, false)
                    SetEntityHeading(obj, p.coords.w or 0.0)
                    if p.snapToGround then PlaceObjectOnGroundProperly(obj) end
                    SetEntityCollision(obj, p.collision ~= false, true)
                    FreezeEntityPosition(obj, true)
                    SetEntityAsMissionEntity(obj, true, true)
                    spawnedProps[#spawnedProps + 1] = obj
                    SetModelAsNoLongerNeeded(model)
                end
            end
        end
    end
end

CreateThread(function()
    Wait(1500) -- let the interior stream in first
    applyModelHides()
    spawnDecorProps()
end)

-- CreateModelHide can reset after a teleport/respawn, so re-apply on load.
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(1500)
    applyModelHides()
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for i = 1, #spawnedProps do
        if DoesEntityExist(spawnedProps[i]) then
            DeleteEntity(spawnedProps[i])
        end
    end
end)
