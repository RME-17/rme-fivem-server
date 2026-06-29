-- RME Player Stats (server) - persistence per character (citizenid).
-- Stores a small JSON blob of raw activity counters in `player_stats`. Values
-- are whitelisted + coerced to non-negative integers on save so a bad client
-- payload can never inject arbitrary data.
--
-- On load we apply inactivity decay: the longer since the player's last save,
-- the more their skill counters shrink (see Config.Decay).

local QBCore = exports['qb-core']:GetCoreObject()

local function defaultStats()
    return {
        run_distance = 0, sprint_distance = 0,
        swim_distance = 0, drive_distance = 0, fly_distance = 0,
        shots_fired = 0, shots_hit = 0,
        kills = 0, deaths = 0,
        playtime = 0,
        -- Bonus XP granted by external training (e.g. the gym).
        bonus_running = 0, bonus_swimming = 0, bonus_shooting = 0,
        bonus_driving = 0, bonus_flying = 0, bonus_stamina = 0, bonus_strength = 0,
    }
end

local function ensureTable()
    MySQL.query([[CREATE TABLE IF NOT EXISTS player_stats (
        citizenid VARCHAR(60) NOT NULL,
        stats LONGTEXT,
        updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (citizenid)
    )]])
end

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then ensureTable() end
end)

local function applyDecay(stats, elapsedSeconds)
    local elapsedDays = (tonumber(elapsedSeconds) or 0) / 86400.0
    if elapsedDays <= Config.Decay.graceDays then return false end
    local decayDays = elapsedDays - Config.Decay.graceDays
    local factor = (1.0 - Config.Decay.perDay) ^ decayDays
    if factor < Config.Decay.floor then factor = Config.Decay.floor end
    if factor >= 1.0 then return false end
    for _, k in ipairs(Config.Decay.keys) do
        if stats[k] then stats[k] = math.floor((stats[k] or 0) * factor) end
    end
    return true
end

local function loadStats(cid)
    local stats = defaultStats()
    local row = MySQL.single.await('SELECT stats, TIMESTAMPDIFF(SECOND, updated, NOW()) AS elapsed FROM player_stats WHERE citizenid = ?', { cid })
    if row and row.stats then
        local ok, decoded = pcall(json.decode, row.stats)
        if ok and type(decoded) == 'table' then
            for k in pairs(stats) do
                local n = tonumber(decoded[k])
                if n and n >= 0 then stats[k] = n end
            end
        end
        if applyDecay(stats, row.elapsed) then
            MySQL.update('UPDATE player_stats SET stats = ? WHERE citizenid = ?', { json.encode(stats), cid })
        end
    else
        MySQL.insert('INSERT INTO player_stats (citizenid, stats) VALUES (?, ?)', { cid, json.encode(stats) })
    end
    return stats
end

local function saveStats(cid, incoming)
    if not cid or type(incoming) ~= 'table' then return end
    local clean = defaultStats()
    for k in pairs(clean) do
        local n = tonumber(incoming[k])
        if n and n >= 0 then clean[k] = math.floor(n) end
    end
    local enc = json.encode(clean)
    MySQL.update('INSERT INTO player_stats (citizenid, stats) VALUES (?, ?) ON DUPLICATE KEY UPDATE stats = ?', { cid, enc, enc })
end

QBCore.Functions.CreateCallback('rme-playerstats:server:get', function(source, cb)
    local player = exports['qb-core']:GetPlayer(source)
    if not player then cb(nil) return end
    cb(loadStats(player.PlayerData.citizenid))
end)

RegisterNetEvent('rme-playerstats:server:save', function(stats)
    local src = source
    local player = exports['qb-core']:GetPlayer(src)
    if not player then return end
    saveStats(player.PlayerData.citizenid, stats)
end)
