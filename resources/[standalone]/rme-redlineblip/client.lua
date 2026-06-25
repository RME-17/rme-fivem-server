-- Map blip for Redline Mechanic MLO (energy_redlinemlo, Mirror Park)
-- Adjust SPRITE / COLOUR / SCALE / LABEL below to taste.

local SHOP_COORDS = vector3(1148.10, -771.46, 57.57)
local SPRITE = 72       -- LS Customs / mechanic wrench. Swap this number for a different icon.
local COLOUR = 46       -- matches your other mechanic blips
local SCALE  = 0.9
local LABEL  = 'Redline Mechanic'

CreateThread(function()
    local blip = AddBlipForCoord(SHOP_COORDS.x, SHOP_COORDS.y, SHOP_COORDS.z)
    SetBlipSprite(blip, SPRITE)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, SCALE)
    SetBlipColour(blip, COLOUR)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(LABEL)
    EndTextCommandSetBlipName(blip)
end)
