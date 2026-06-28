-- RME minimap reposition
-- Nudges the SQUARE minimap slightly RIGHT (it previously hugged the bottom-left
-- corner). Uses ps-hud's exact square size values; only the X (horizontal)
-- position is changed. Re-applies on a light loop so it survives ps-hud
-- re-loading the map (spawn / shape toggle).

local function applyMinimap()
    local defaultAspectRatio = 1920 / 1080
    local resX, resY = GetActiveScreenResolution()
    local aspectRatio = resX / resY
    local minimapOffset = 0.0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
    end

    -- X shifted right by ~0.03 from the previous corner-hug (-0.020 -> 0.010).
    -- Increase the first number on each line to push it further right.
    -- Y and size values are unchanged from ps-hud.
    SetMinimapComponentPosition("minimap", "L", "B", 0.010 + minimapOffset, -0.047, 0.1638, 0.183)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.010 + minimapOffset, 0.0, 0.128, 0.20)
    SetMinimapComponentPosition("minimap_blur", "L", "B", 0.000 + minimapOffset, 0.025, 0.262, 0.300)
end

CreateThread(function()
    while true do
        applyMinimap()
        Wait(2000)
    end
end)
