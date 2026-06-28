Config = {}

-- ---------------------------------------------------------------------------
-- RME Postals
-- Draws postal numbers on the pause map (press ESC -> Map).
-- Numbers are 3-4 digits, grouped by region, increasing roughly south -> north
-- so they read logically as you scan the map.
-- ---------------------------------------------------------------------------

Config.Style = {
	font    = 4,        -- 0=Chalet, 4=ChaletComprime (clean condensed)
	scale   = 0.30,    -- text size on the map
	r       = 240, g = 240, b = 245, a = 215, -- soft white
	outline = true,    -- dark outline so codes stay readable over any map area
}

-- Only draw postals whose projected position falls inside this screen box.
-- Keeps numbers off the pause-menu header / side panels.
Config.Bounds = { minX = 0.015, maxX = 0.985, minY = 0.055, maxY = 0.965 }

-- Live calibration tuning (advanced -- leave as-is unless codes are misplaced).
Config.Calibration = {
	minSpread   = 40.0, -- world units the cursor must travel before solving scale
	sampleCount = 16,   -- how many recent cursor samples to keep
}

-- /postaldev toggles an on-screen calibration readout (for fine-tuning).
Config.Dev = false

-- ---------------------------------------------------------------------------
-- Postal data: { x, y, code }
-- ---------------------------------------------------------------------------
Config.Postals = {
	-- 300s : South LS - airport, beaches, docks
	{ x = -1037.0, y = -2737.0, code = "300" }, -- LSIA terminal
	{ x = -1300.0, y = -3000.0, code = "305" }, -- LSIA south apron
	{ x = -1223.0, y = -1491.0, code = "311" }, -- Vespucci Beach
	{ x = -1850.0, y = -1232.0, code = "317" }, -- Del Perro Pier
	{ x = -1015.0, y = -1462.0, code = "323" }, -- Vespucci Canals
	{ x =  -784.0, y = -1455.0, code = "329" }, -- Puerto Del Sol Marina
	{ x =   340.0, y = -2710.0, code = "335" }, -- Elysian Island docks
	{ x =  1090.0, y = -2960.0, code = "341" }, -- Port of Los Santos

	-- 350s : Davis / Strawberry / Chamberlain / Rancho
	{ x =    80.0, y = -1950.0, code = "350" }, -- Davis (Grove St)
	{ x =   200.0, y = -1640.0, code = "356" }, -- Strawberry
	{ x =  -150.0, y = -1640.0, code = "362" }, -- Chamberlain Hills
	{ x =   380.0, y = -1860.0, code = "368" }, -- Rancho
	{ x =   820.0, y = -1530.0, code = "374" }, -- La Mesa
	{ x =  1380.0, y = -1530.0, code = "380" }, -- El Burro Heights
	{ x =  1010.0, y = -2200.0, code = "386" }, -- Cypress Flats

	-- 400s : Downtown / Pillbox / Mission Row / Legion
	{ x =   195.0, y =  -934.0, code = "400" }, -- Legion Square
	{ x =   298.0, y =  -584.0, code = "406" }, -- Pillbox Hill (hospital)
	{ x =   428.0, y =  -981.0, code = "412" }, -- Mission Row PD
	{ x =   220.0, y =  -780.0, code = "418" }, -- Textile City
	{ x =  -270.0, y =  -690.0, code = "424" }, -- Alta
	{ x =   380.0, y =  -680.0, code = "430" }, -- Mission Row

	-- 450s : West central - Rockford / Richman / Morningwood
	{ x =  -800.0, y =  -150.0, code = "450" }, -- Rockford Hills
	{ x = -1500.0, y =   150.0, code = "456" }, -- Richman
	{ x = -1430.0, y =  -560.0, code = "462" }, -- Morningwood
	{ x = -1280.0, y =   180.0, code = "468" }, -- GWC & Golfing Society

	-- 500s : Vinewood / Mirror Park / East
	{ x =   300.0, y =   180.0, code = "500" }, -- Vinewood Blvd
	{ x =   700.0, y =  -120.0, code = "506" }, -- East Vinewood
	{ x =  1130.0, y =  -650.0, code = "512" }, -- Mirror Park
	{ x =  1180.0, y =  -560.0, code = "518" }, -- Mirror Park Lake
	{ x =  1020.0, y =  -300.0, code = "524" }, -- Tataviam Mountains

	-- 560s : Vinewood Hills / North LS
	{ x =   300.0, y =   560.0, code = "560" }, -- Vinewood Hills
	{ x =   490.0, y =   600.0, code = "566" }, -- Lake Vinewood Estates
	{ x =  -440.0, y =  1090.0, code = "572" }, -- Galileo Observatory

	-- 600s : West coast - Pacific Bluffs / Banham / Chumash
	{ x = -2200.0, y =   300.0, code = "600" }, -- Pacific Bluffs
	{ x = -2050.0, y =  1200.0, code = "606" }, -- Banham Canyon
	{ x = -3190.0, y =  1010.0, code = "612" }, -- Chumash
	{ x = -3420.0, y =   967.0, code = "618" }, -- Chumash Pier

	-- 700s : Tongva / Great Chaparral / Zancudo
	{ x = -1500.0, y =  2100.0, code = "700" }, -- Tongva Hills
	{ x = -1100.0, y =  1700.0, code = "706" }, -- Tongva Valley
	{ x =   -50.0, y =  2900.0, code = "712" }, -- Great Chaparral
	{ x = -1900.0, y =  3100.0, code = "718" }, -- Lago Zancudo

	-- 1000s : Harmony / Route 68
	{ x =   280.0, y =  2860.0, code = "1000" }, -- Harmony
	{ x =   855.0, y =  2200.0, code = "1006" }, -- Route 68
	{ x =  1390.0, y =  3590.0, code = "1012" }, -- Sandy Shores approach

	-- 2000s : Sandy Shores / Alamo Sea
	{ x =  1960.0, y =  3740.0, code = "2000" }, -- Sandy Shores
	{ x =  1700.0, y =  3280.0, code = "2006" }, -- Sandy Shores Airfield
	{ x =  2000.0, y =  3420.0, code = "2012" }, -- Trailer Park
	{ x =  1300.0, y =  4350.0, code = "2018" }, -- Alamo Sea (east shore)

	-- 3000s : Grand Senora / Grapeseed
	{ x =  2300.0, y =  3050.0, code = "3000" }, -- Grand Senora Desert
	{ x =  2440.0, y =  4960.0, code = "3006" }, -- Grapeseed
	{ x =  1700.0, y =  4900.0, code = "3012" }, -- Grapeseed Main St

	-- 4000s : Raton Canyon / Mount Chiliad
	{ x = -1500.0, y =  4400.0, code = "4000" }, -- Raton Canyon
	{ x =  -700.0, y =  5500.0, code = "4006" }, -- Paleto Forest
	{ x =   450.0, y =  5600.0, code = "4012" }, -- Mount Chiliad

	-- 5000s : Paleto Bay / north coast
	{ x =  -100.0, y =  6420.0, code = "5000" }, -- Paleto Bay
	{ x =  -250.0, y =  6320.0, code = "5006" }, -- Paleto Blvd
	{ x =  -560.0, y =  5340.0, code = "5012" }, -- Paleto Sawmill
	{ x =   130.0, y =  6620.0, code = "5018" }, -- Procopio Beach
}
