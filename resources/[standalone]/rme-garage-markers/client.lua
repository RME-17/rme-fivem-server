--[[ RME_GARAGE_MARKERS_V1
  Draws a glowing, pulsing blue ground marker at every PUBLIC car parking
  (qb-garages) take point, so players can clearly see where each garage is.

  The marker style is identical to rme-pd-garage so PD and civilian garages
  look consistent. qb-garages already creates the map blips (car icon 357),
  so this resource only adds the in-world glow.

  Coords below mirror qb-garages/config.lua Config.Garages takeVehicle for
  all type='public'/'depot' car-class garages. Keep in sync if you move or
  add garages there.
]]

local MARKER_DIST = 25.0   -- start drawing the marker within this range

-- Mirror of qb-garages public car garage take points
local GaragePoints = {
    vector3(274.29, -334.15, 44.92),    -- Motel Parking
    vector3(883.96, -4.71, 78.76),      -- Casino Parking
    vector3(-330.01, -780.33, 33.96),   -- San Andreas Parking
    vector3(-1160.86, -741.41, 19.63),  -- Spanish Ave Parking
    vector3(69.84, 12.6, 68.96),        -- Caears 24 Parking
    vector3(-453.7, -786.78, 30.56),    -- Caears 24 Parking (2)
    vector3(364.37, 297.83, 103.49),    -- Laguna Parking
    vector3(-773.12, -2033.04, 8.88),   -- Airport Parking
    vector3(-1185.32, -1500.64, 4.38),  -- Beach Parking
    vector3(1137.77, 2663.54, 37.9),    -- The Motor Hotel Parking
    vector3(883.99, 3649.67, 32.87),    -- Liqour Parking
    vector3(1737.03, 3718.88, 34.05),   -- Shore Parking
    vector3(76.88, 6397.3, 31.23),      -- Bell Farms Parking
    vector3(165.75, -3227.2, 5.89),     -- Dumbo Private Parking
    vector3(213.2, -796.05, 30.86),     -- Pillbox Garage Parking
    vector3(2552.68, 4671.8, 33.95),    -- Grapeseed Parking
    vector3(401.76, -1632.57, 29.29),   -- Depot Lot
}

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i = 1, #GaragePoints do
            local p = GaragePoints[i]
            local d = #(pos - p)
            if d < MARKER_DIST then
                sleep = 0
                local pulse = (math.sin(GetGameTimer() / 400.0) * 0.5) + 0.5
                local a = math.floor(70 + (pulse * 140))
                DrawMarker(1, p.x, p.y, p.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    1.5, 1.5, 0.6, 0, 150, 255, a, false, true, 2, false, nil, nil, false)
            end
        end
        Wait(sleep)
    end
end)
