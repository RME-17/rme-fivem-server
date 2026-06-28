-- RME PDM private browsing - server side.
-- Puts each browsing player into their own routing bucket so multiple players can
-- browse the catalog at the same time without seeing each other, then restores
-- their original bucket when they leave (or disconnect).

local originalBucket = {}

RegisterNetEvent('rme_pdm:server:enterBrowse', function()
    local src = source
    -- Remember where they were so we can put them back exactly.
    originalBucket[src] = GetPlayerRoutingBucket(src) or 0

    -- Unique, per-player bucket. +80000 keeps us well clear of the default (0)
    -- and any normal instancing buckets.
    local bucket = 80000 + src
    SetPlayerRoutingBucket(src, bucket)
    SetRoutingBucketPopulationEnabled(bucket, false) -- no ambient peds/traffic
    SetRoutingBucketEntityLockdownMode(bucket, 'relaxed') -- still allow our spawns

    TriggerClientEvent('rme_pdm:client:enteredBrowse', src)
end)

RegisterNetEvent('rme_pdm:server:exitBrowse', function()
    local src = source
    local bucket = originalBucket[src] or 0
    SetPlayerRoutingBucket(src, bucket)
    originalBucket[src] = nil
    TriggerClientEvent('rme_pdm:client:exitedBrowse', src)
end)

-- Safety: if a player disconnects mid-browse just forget them. They will spawn
-- back in bucket 0 normally on next connect.
AddEventHandler('playerDropped', function()
    local src = source
    originalBucket[src] = nil
end)
