--[[ RME_GARAGE_MARKERS_V2
  Blue chevron ground markers at every PUBLIC car parking lot.
  Marker style matches the jewelry crafting marker (DrawMarker type 2 chevron),
  recolored blue. Coordinates mirror the car-class public garages in
  qb-garages/config.lua (Config.Garages, takeVehicle points).

  Note: air / sea / big-rig lots and hidden gang/police garages are intentionally
  NOT marked. If you add or move a public car garage in qb-garages, add/update the
  matching coordinate below.
]]

-- takeVehicle points of every public car parking lot
local carParkingLots = {
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
}

local DRAW_DISTANCE = 25.0

CreateThread(function()
    while true do
        local sleep = 1000
        local pcoords = GetEntityCoords(PlayerPedId())
        for i = 1, #carParkingLots do
            local loc = carParkingLots[i]
            local dist = #(pcoords - loc)
            if dist < DRAW_DISTANCE then
                sleep = 0
                DrawMarker(
                    2,                       -- chevron / arrow marker (same as jewelry marker)
                    loc.x, loc.y, loc.z + 1.0,
                    0.0, 0.0, 0.0,           -- direction
                    0.0, 180.0, 0.0,         -- rotation (point downward)
                    0.4, 0.4, 0.4,           -- scale
                    0, 120, 255, 180,        -- BLUE (r, g, b, alpha)
                    false, true, 2, false, nil, nil, false
                )
            end
        end
        Wait(sleep)
    end
end)
