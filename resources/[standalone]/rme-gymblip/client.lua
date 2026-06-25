-- Map blip for La Mesa Strength and Conditioning (cc_lmsc_01)
-- Adjust SPRITE / COLOUR / SCALE / LABEL below to taste.

local GYM_COORDS = vector3(769.71, -900.93, 25.16)
local SPRITE = 311      -- fitness/gym style icon. Swap this number for a different icon.
local COLOUR = 2        -- 2 = green
local SCALE  = 0.9
local LABEL  = 'Gym - La Mesa S&C'

CreateThread(function()
    local blip = AddBlipForCoord(GYM_COORDS.x, GYM_COORDS.y, GYM_COORDS.z)
    SetBlipSprite(blip, SPRITE)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, SCALE)
    SetBlipColour(blip, COLOUR)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(LABEL)
    EndTextCommandSetBlipName(blip)
end)
