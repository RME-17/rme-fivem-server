-- rme-pdteleport
-- One-way rooftop teleport: roof green door -> inside Vinewood PD.
-- Stand on the marker and you are automatically teleported inside.
-- One direction only (roof -> inside). There is no return teleport here.
--
-- To change where players land, edit the 'dest' vector4 below.
--   dest = vector4(x, y, z, heading)
-- The current landing point is the PD duty / front desk area (bottom floor).

local TELEPORTS = {
    {
        name = 'Vinewood PD Rooftop',
        source = vector3(565.68, 4.66, 103.23),
        dest = vector4(622.11, -2.68, 82.78, 250.0),
        marker = true,
    },
}

local DRAW_DIST = 15.0
local TRIGGER_DIST = 1.2
local cooldown = false

local function doTeleport(dest)
    cooldown = true
    local ped = PlayerPedId()

    DoScreenFadeOut(400)
    local timeout = 0
    while not IsScreenFadedOut() and timeout < 50 do
        timeout = timeout + 1
        Wait(10)
    end

    SetEntityCoordsNoOffset(ped, dest.x, dest.y, dest.z, false, false, false)
    SetEntityHeading(ped, dest.w)
    Wait(300)

    DoScreenFadeIn(400)
    Wait(1000)
    cooldown = false
end

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for _, tp in ipairs(TELEPORTS) do
            local dist = #(pos - tp.source)
            if dist < DRAW_DIST then
                sleep = 0
                if tp.marker then
                    DrawMarker(1, tp.source.x, tp.source.y, tp.source.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0, 150, 255, 120, false, false, 2, false, nil, nil, false)
                end
                if dist < TRIGGER_DIST and not cooldown then
                    doTeleport(tp.dest)
                end
            end
        end

        Wait(sleep)
    end
end)
