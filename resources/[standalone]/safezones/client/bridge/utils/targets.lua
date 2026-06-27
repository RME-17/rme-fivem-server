local Targets = {}

local registeredPoints = {}
local pointMetas = {}
local activePointId = nil
local lastPressAt = 0
local stopping = false
local drawTextPollStarted = false

Targets.IsOxTargetEnabled = function()
    if not Config or not exports or not exports.ox_target then return false end
    local interaction = Config.Interaction
    if type(interaction) == 'string' then
        return interaction == 'ox_target'
    end
    return false
end

Targets.IsDrawTextEnabled = function()
    local cfg = Config and Config.DrawText
    if type(cfg) == 'boolean' then
        return cfg == true
    end
    return type(cfg) == 'table' and cfg.enabled == true
end

Targets.GetDrawTextKey = function()
    local cfg = Config and Config.DrawText
    if type(cfg) == 'table' and type(cfg.key) == 'number' then
        return cfg.key
    end
    return 38
end

Targets.HideTextIfCurrent = function(pointId)
    if stopping then return end
    if activePointId == pointId and exports and exports['koja-lib'] then
        pcall(function()
            exports['koja-lib']:hideTextUI()
        end)
        activePointId = nil
    end
end

Targets.getWinningInteractionPointId = function()
    if stopping then return nil end
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local bestId = nil
    local bestScore = nil
    for pid, meta in pairs(pointMetas) do
        local d = #(pcoords - meta.coords)
        if d <= meta.radius then
            local ok, al = pcall(meta.canInteract)
            if ok and al then
                local pr = meta.priority or 0
                local score = pr * 100000 - math.floor(d * 100)
                if not bestId or score > bestScore or (score == bestScore and tostring(pid) < tostring(bestId)) then
                    bestScore = score
                    bestId = pid
                end
            end
        end
    end
    return bestId
end

Targets.playerInsideAnyPointShell = function()
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    for _, meta in pairs(pointMetas) do
        local enter = meta.enterDistance or (meta.radius + 1.25)
        if #(pcoords - meta.coords) <= enter then
            return true
        end
    end
    return false
end

Targets.startDrawTextPollThread = function()
    if drawTextPollStarted then return end
    drawTextPollStarted = true
    CreateThread(function()
        while true do
            if stopping then
                Wait(500)
            elseif not next(pointMetas) then
                if activePointId then
                    Targets.HideTextIfCurrent(activePointId)
                end
                Wait(500)
            elseif not Targets.playerInsideAnyPointShell() then
                if activePointId then
                    Targets.HideTextIfCurrent(activePointId)
                end
                Wait(100)
            else
                local win = Targets.getWinningInteractionPointId()
                local meta = win and pointMetas[win] or nil
                local key = (meta and type(meta.key) == 'number') and meta.key or Targets.GetDrawTextKey()
                if win and meta then
                    if exports and exports['koja-lib'] then
                        pcall(function()
                            exports['koja-lib']:showTextUI({
                                key = 'E',
                                label = 'Press to interact',
                                desc = meta.label
                            })
                        end)
                        activePointId = win
                    end
                    if IsControlJustPressed(0, key) then
                        local now = GetGameTimer()
                        if now - lastPressAt > 250 then
                            lastPressAt = now
                            if meta.onPress then
                                pcall(meta.onPress)
                            end
                        end
                    end
                else
                    if activePointId then
                        Targets.HideTextIfCurrent(activePointId)
                    end
                end
                Wait(0)
            end
        end
    end)
end

Targets.AddLocalEntity = function(entity, options)
    if not Targets.IsOxTargetEnabled() then return false end
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end
    exports.ox_target:addLocalEntity(entity, options)
    return true
end

Targets.RemoveLocalEntity = function(entity, names)
    if not Targets.IsOxTargetEnabled() then return false end
    if not entity or entity == 0 then return false end
    exports.ox_target:removeLocalEntity(entity, names)
    return true
end

Targets.AddPointInteraction = function(id, coords, radius, label, canInteract, onPress, pointOpts)
    if not Targets.IsDrawTextEnabled() then return nil end
    if not coords or not KOJA or not KOJA.Client or not KOJA.Client.points then return nil end
    if stopping then return nil end

    pointOpts = pointOpts or {}
    local pointCoords = vector3(coords.x, coords.y, coords.z)
    local pointRadius = radius or 2.0
    local priority = type(pointOpts.priority) == 'number' and pointOpts.priority or 0
    local enterDistance = pointRadius + 1.25

    if registeredPoints[id] and type(registeredPoints[id].remove) == 'function' then
        registeredPoints[id]:remove()
        registeredPoints[id] = nil
        Targets.HideTextIfCurrent(id)
    end

    local metaKey = type(pointOpts.key) == 'number' and pointOpts.key or nil
    pointMetas[id] = {
        coords = pointCoords,
        radius = pointRadius,
        enterDistance = enterDistance,
        canInteract = canInteract,
        onPress = onPress,
        label = label,
        priority = priority,
        key = metaKey
    }

    local point = KOJA.Client.points.new({
        coords = pointCoords,
        distance = enterDistance,
        resource = GetCurrentResourceName(),
        onExit = function()
            Targets.HideTextIfCurrent(id)
        end
    })

    registeredPoints[id] = point
    Targets.startDrawTextPollThread()
    return id
end

Targets.RemovePointInteraction = function(id)
    if not id then return false end
    local point = registeredPoints[id]
    if point and type(point.remove) == 'function' then
        point:remove()
    end
    registeredPoints[id] = nil
    pointMetas[id] = nil
    Targets.HideTextIfCurrent(id)
    return true
end

Targets.ClearAllInteractionPoints = function()
    stopping = true
    for id, point in pairs(registeredPoints) do
        if point and type(point.remove) == 'function' then
            point:remove()
        end
        registeredPoints[id] = nil
        pointMetas[id] = nil
    end
    if exports and exports['koja-lib'] then
        pcall(function()
            exports['koja-lib']:hideTextUI()
        end)
    end
    activePointId = nil
end

KOJA.Client.IsOxTargetEnabled = Targets.IsOxTargetEnabled
KOJA.Client.IsDrawTextEnabled = Targets.IsDrawTextEnabled
KOJA.Client.GetDrawTextKey = Targets.GetDrawTextKey
KOJA.Client.HideTextIfCurrent = Targets.HideTextIfCurrent
KOJA.Client.ClearAllInteractionPoints = Targets.ClearAllInteractionPoints

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    Targets.ClearAllInteractionPoints()
end)

KojaCarmarketTargets = Targets

return Targets
