Config = {}

Config.Locale = 'en'
Config.Command = 'safezone'
Config.AdminOnly = true -- true: ace 'command' permission required
Config.Debug     = true    -- true: enable debug prints in console
Config.NotifyType = 'chat' -- 'chat' (standalone) | 'ox_lib' | 'qb' | 'esx'

function DebugPrint(...)
    if Config.Debug then print(...) end
end

-- Safezone Effects
Config.DisableWeapons = true
Config.GodMode = true
Config.DisablePVP = true
Config.GhostMode = true       -- Ghost mode: no collision with other players in safezone
Config.PlayerAlpha = 200      -- 0~255, ghost transparency (255 = opaque)

-- Wall visualization
Config.WallHeight = 8.0
Config.WallColor = { r = 0, g = 150, b = 255, a = 40 }
Config.WallRenderDistance = 150.0

-- Draw Colors (RGBA 0-255)
Config.PreviewColor = { r = 0, g = 150, b = 255, a = 120 }
Config.PlacedColor  = { r = 0, g = 255, b = 100, a = 150 }
Config.LineColor     = { r = 255, g = 255, b = 255, a = 200 }
