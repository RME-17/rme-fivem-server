-- Map blip for Giant Burger / Burger Shot MLO (Little Seoul, Giant_Burger resource)
-- Adjust SPRITE / COLOUR / SCALE / LABEL below to taste.
-- NOTE: GTA V has NO native food/burger icon. Sprite 52 = store/shopping bag (closest 'buy food' native).
-- For a real burger graphic you need a custom streamed blip texture (minimap.gfx + .ytd) - ask RME.
-- Other valid swaps: 93 = bar/drink, 51 = drugs. Full list: docs.fivem.net/docs/game-references/blips

local BURGER_COORDS = vector3(-595.71, -861.46, 25.89)
local SPRITE = 52       -- store/shopping bag (closest valid native to 'food'; no native burger exists)
local COLOUR = 17       -- 17 = orange (burger branding)
local SCALE  = 0.9
local LABEL  = 'Burger Shot'

CreateThread(function()
    local blip = AddBlipForCoord(BURGER_COORDS.x, BURGER_COORDS.y, BURGER_COORDS.z)
    SetBlipSprite(blip, SPRITE)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, SCALE)
    SetBlipColour(blip, COLOUR)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(LABEL)
    EndTextCommandSetBlipName(blip)
end)
