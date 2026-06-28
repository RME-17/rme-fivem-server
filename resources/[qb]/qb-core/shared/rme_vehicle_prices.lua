-- RME vehicle price overrides.
-- Loaded right AFTER shared/vehicles.lua in the qb-core fxmanifest so it patches
-- the prices in place on QBCore.Shared.Vehicles. Both the PDM browse menu and the
-- server-side buy/finance handlers read price from this same table, so changing
-- it here updates the displayed price AND the amount charged.
--
-- Only the models listed below are changed; everything else keeps its stock price.

QBCore = QBCore or {}
QBCore.Shared = QBCore.Shared or {}
QBCore.Shared.Vehicles = QBCore.Shared.Vehicles or {}

local PriceOverrides = {
    -- ===== SUPERS (made pricier) =====
    adder         = 2500000,
    autarch       = 1400000,
    banshee2      = 600000,
    bullet        = 450000,
    cheetah       = 900000,
    cyclone       = 1300000,
    entity2       = 1200000,
    entityxf      = 1100000,
    emerus        = 1500000,
    fmj           = 700000,
    furia         = 1600000,
    gp1           = 500000,
    infernus      = 800000,
    italigtb      = 900000,
    italigtb2     = 1150000,
    krieger       = 2100000,
    le7b          = 1800000,
    nero          = 1200000,
    nero2         = 1500000,
    osiris        = 1400000,
    penetrator    = 700000,
    pfister811    = 1135000,
    prototipo     = 2700000,
    reaper        = 600000,
    s80           = 2500000,
    sc1           = 500000,
    sheava        = 1000000,
    t20           = 2300000,
    taipan        = 2400000,
    tempesta      = 800000,
    tezeract      = 2800000,
    thrax         = 2000000,
    tigon         = 1500000,
    turismor      = 750000,
    tyrant        = 3000000,
    tyrus         = 1700000,
    vacca         = 450000,
    vagner        = 2200000,
    voltic        = 500000,
    xa21          = 1000000,
    zentorno      = 1800000,
    zorrusso      = 1300000,
    ignus         = 2400000,
    zeno          = 2600000,
    deveste       = 1800000,
    lm87          = 1400000,
    torero2       = 1900000,
    entity3       = 1250000,
    virtue        = 900000,
    turismo3      = 2100000,

    -- ===== SELECT "GOOD" SPORTS CARS (made pricier) =====
    italigto      = 650000,
    italirsx      = 750000,
    stingertt     = 620000,
    cheetah2      = 700000,
    jester4       = 600000,
    jester2       = 470000,
    neo           = 550000,
    neon          = 520000,
    comet6        = 500000,
    growler       = 480000,
    locust        = 480000,
    ruston        = 350000,
    sultanrs      = 280000,
    elegy         = 320000,
    elegy2        = 350000,
    tenf          = 460000,
    tenf2         = 520000,
    vorschlaghammer = 600000,
    paragon3      = 540000,
    coquette4     = 520000,
    coquette5     = 520000,
    visione       = 1200000,
    corsita       = 350000,
    pipistrello   = 560000,
    niobe         = 480000,
    coureur       = 470000,
    r300          = 280000,
}

local applied = 0
for model, price in pairs(PriceOverrides) do
    local veh = QBCore.Shared.Vehicles[model]
    if veh then
        veh.price = price
        applied = applied + 1
    end
end

print(('^2[rme_prices]^7 applied %d vehicle price overrides'):format(applied))
