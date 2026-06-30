-- Map blip for Giant Burger / Burger Shot MLO (Little Seoul, Giant_Burger resource)
-- Adjust SPRITE / COLOUR / SCALE / LABEL below to taste.
-- NOTE: GTA V has NO native burger icon. Sprite 93 = bar/drink venue (closest valid native).
-- Easy valid swaps: 52 = store bag, 1 = standard dot. Full list: docs.fivem.net/docs/game-references/blips

local BURGER_COORDS = vector3(-595.71, -861.46, 25.89)
local SPRITE = 93       -- bar/venue icon (closest valid native; no native burger exists). Swap for a different icon.
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
