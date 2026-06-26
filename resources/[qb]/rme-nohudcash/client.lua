-- rme-nohudcash
-- Hides GTA's native cash HUD and the +$/-$ money-change animation that pops
-- in the top-right wallet whenever money changes.
--
-- These native HUD components must be re-hidden every frame, so this runs a
-- tight loop. It does NOT touch ps-hud's custom money display (separate NUI
-- overlay), so your styled cash/bank HUD keeps working.
--
-- HUD component IDs:
--   3 = HUD_CASH      (single-player wallet)
--   4 = HUD_MP_CASH   (the +$/-$ change ticker / MP wallet)

CreateThread(function()
    while true do
        HideHudComponentThisFrame(3) -- HUD_CASH
        HideHudComponentThisFrame(4) -- HUD_MP_CASH
        Wait(0)
    end
end)
