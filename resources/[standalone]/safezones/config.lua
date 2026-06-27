Config = {}

Config.Locale = 'en'
Config.Command = 'safezone'
Config.AdminOnly = true -- true: ace 'command' permission required
Config.Debug     = true    -- true: enable debug prints in console
Config.NotifyType = 'rme' -- 'rme' (RME glass UI) | 'chat' | 'ox_lib' | 'qb' | 'esx'

function DebugPrint(...)
    if Config.Debug then print(...) end
end

-- Safezone Effects
Config.DisableWeapons = true   -- no pulling out weapons
Config.GodMode = false         -- no invincibility
Config.DisablePVP = true       -- no combat
Config.GhostMode = false       -- players keep normal collision
Config.PlayerAlpha = 255       -- 0~255, players fully visible

-- Wall visualization (ring hidden)
Config.WallHeight = 0.0
Config.WallColor = { r = 0, g = 150, b = 255, a = 0 }
Config.WallRenderDistance = 150.0

-- Draw Colors (RGBA 0-255)
Config.PreviewColor = { r = 0, g = 150, b = 255, a = 120 }
Config.PlacedColor  = { r = 0, g = 255, b = 100, a = 150 }
Config.LineColor     = { r = 255, g = 255, b = 255, a = 200 }
