local QBCore = exports['qb-core']:GetCoreObject()

local currentTattoos = {}
local cam = nil
local back = 1
local opacity = 1
local scaleType = nil
local scaleString = ""
local savedOutfit = nil

CreateThread(function()
    AddTextEntry("ParaTattoos", "Tattoo Shop")
    for k, v in pairs(Config.Shops) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, 75)
        SetBlipColour(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("ParaTattoos")
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('Select:Tattoos')
end)

RegisterNetEvent('Apply:Tattoo', function(tats)
    QBCore.Functions.TriggerCallback('SmallTattoos:GetPlayerTattoos', function(tattooList)
        if tattooList then
            for k, v in pairs(tattooList) do
                SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
            end
            currentTattoos = tattooList
        end
    end)
end)

CreateThread(function()
    while true do
        Wait(300000)
        if not IsMenuOpen() then
            QBCore.Functions.TriggerCallback('SmallTattoos:GetPlayerTattoos', function(tattooList)
                if tattooList then
                    ClearPedDecorations(PlayerPedId())
                    for k, v in pairs(tattooList) do
                        if v.Count ~= nil then
                            for i = 1, v.Count do
                                SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
                            end
                        else
                            SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
                        end
                    end
                    currentTattoos = tattooList
                end
            end)
        end
    end
end)

function DrawTattoo(collection, name)
    ClearPedDecorations(PlayerPedId())
    for k, v in pairs(currentTattoos) do
        if v.Count ~= nil then
            for i = 1, v.Count do
                SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
            end
        else
            SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
        end
    end
    for i = 1, opacity do
        SetPedDecoration(PlayerPedId(), collection, name)
    end
end

-- Save the player's current outfit, then strip down to underwear so tattoos
-- are fully visible while browsing. The outfit is restored on menu close.
function StripToUnderwear()
    local ped = PlayerPedId()

    if not savedOutfit then
        savedOutfit = { components = {}, props = {} }
        for _, comp in ipairs({1, 3, 4, 5, 6, 7, 8, 9, 10, 11}) do
            savedOutfit.components[comp] = {
                GetPedDrawableVariation(ped, comp),
                GetPedTextureVariation(ped, comp),
                GetPedPaletteVariation(ped, comp)
            }
        end
        for _, prop in ipairs({0, 1, 2, 6, 7}) do
            savedOutfit.props[prop] = {
                GetPedPropIndex(ped, prop),
                GetPedPropTextureIndex(ped, prop)
            }
        end
    end

    SetPedComponentVariation(ped, 1, 0, 0, 0)   -- mask off
    SetPedComponentVariation(ped, 5, 0, 0, 0)   -- bag off
    SetPedComponentVariation(ped, 7, 0, 0, 0)   -- neck accessory off
    SetPedComponentVariation(ped, 9, 0, 0, 0)   -- body armor off
    SetPedComponentVariation(ped, 10, 0, 0, 0)  -- decals off
    SetPedComponentVariation(ped, 3, 15, 0, 0)  -- bare arms

    if GetEntityModel(ped) == GetHashKey('mp_m_freemode_01') then
        SetPedComponentVariation(ped, 8, 15, 0, 0)   -- no undershirt
        SetPedComponentVariation(ped, 11, 15, 0, 0)  -- bare chest
        SetPedComponentVariation(ped, 4, 14, 0, 0)   -- underpants
        SetPedComponentVariation(ped, 6, 34, 0, 0)   -- barefoot
    else
        SetPedComponentVariation(ped, 8, 34, 0, 0)   -- no undershirt
        SetPedComponentVariation(ped, 11, 101, 1, 0) -- bare top
        SetPedComponentVariation(ped, 4, 16, 0, 0)   -- underwear
        SetPedComponentVariation(ped, 6, 35, 0, 0)   -- barefoot
    end

    ClearAllPedProps(ped)
end

-- Put the player's saved outfit back exactly as it was.
function RestoreOutfit()
    local ped = PlayerPedId()
    if not savedOutfit then return end
    for comp, v in pairs(savedOutfit.components) do
        SetPedComponentVariation(ped, comp, v[1], v[2], v[3])
    end
    for prop, v in pairs(savedOutfit.props) do
        if v[1] == -1 then
            ClearPedProp(ped, prop)
        else
            SetPedPropIndex(ped, prop, v[1], v[2], true)
        end
    end
    savedOutfit = nil
end

function ResetSkin()
    ClearPedDecorations(PlayerPedId())
    for k, v in pairs(currentTattoos) do
        if v.Count ~= nil then
            for i = 1, v.Count do
                SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
            end
        else
            SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
        end
    end
end

function ReqTexts(text, slot)
    RequestAdditionalText(text, slot)
    while not HasAdditionalTextLoaded(slot) do
        Wait(0)
    end
end

function OpenTattooShop()
    StripToUnderwear()
    JayMenu.OpenMenu("tattoo")
    FreezeEntityPosition(PlayerPedId(), true)
    ReqTexts("TAT_MNU", 9)
end

function CloseTattooShop()
    ClearAdditionalText(9, 1)
    RestoreOutfit()
    FreezeEntityPosition(PlayerPedId(), false)
    EnableAllControlActions(0)
    back = 1
    opacity = 1
    return true
end

function ButtonPress()
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function IsMenuOpen()
    return (JayMenu.IsMenuOpened('tattoo') or string.find(tostring(JayMenu.CurrentMenu() or ""), "ZONE_"))
end

function BuyTattoo(collection, name, label, price)
    QBCore.Functions.TriggerCallback('SmallTattoos:PurchaseTattoo', function(success)
        if success then
            table.insert(currentTattoos, {collection = collection, nameHash = name, Count = opacity})
        end
    end, currentTattoos, price, {collection = collection, nameHash = name, Count = opacity}, GetLabelText(label))
end

function RemoveTattoo(name, label)
    for k, v in pairs(currentTattoos) do
        if v.nameHash == name then
            table.remove(currentTattoos, k)
        end
    end
    TriggerServerEvent("SmallTattoos:RemoveTattoo", currentTattoos)
    print("You have removed the ~y~" .. GetLabelText(label) .. "~s~ tattoo")
end

function CreateScale(sType)
    if scaleString ~= sType and sType == "OpenShop" then
        scaleType = setupScaleform("instructional_buttons", "Open Tattoo Shop", 38)
        scaleString = sType
    elseif scaleString ~= sType and sType == "Control" then
        scaleType = setupScaleform2("instructional_buttons", "Change Camera View", 21, "Change Opacity", {90, 89}, "Buy/Remove Tattoo", 191)
        scaleString = sType
    end
end

CreateThread(function()
    JayMenu.CreateMenu("tattoo", "Tattoo Shop", function()
        return CloseTattooShop()
    end)
    JayMenu.SetSubTitle('tattoo', "Categories")
    
    for k, v in ipairs(Config.TattooCats) do
        JayMenu.CreateSubMenu(v[1], "tattoo", v[2])
        JayMenu.SetSubTitle(v[1], v[2])
    end
    
    while true do
        Wait(0)
        local CanSleep = true
        if not IsMenuOpen() then
            for _, interiorId in ipairs(Config.interiorIds) do
                if GetInteriorFromEntity(PlayerPedId()) == interiorId then
                    CanSleep = false
                    if not IsPedInAnyVehicle(PlayerPedId(), false) then
                        CreateScale("OpenShop")
                        DrawScaleformMovieFullscreen(scaleType, 255, 255, 255, 255, 0)
                        if IsControlJustPressed(0, 38) then
                            OpenTattooShop()
                        end
                    end
                end
            end
        end
        
        if IsMenuOpen() then
            DisableAllControlActions(0)
            CanSleep = false
        end
        
        if JayMenu.IsMenuOpened('tattoo') then
            CanSleep = false
            for k, v in ipairs(Config.TattooCats) do
                JayMenu.MenuButton(v[2], v[1])
            end
            ClearPedDecorations(PlayerPedId())
            for k, v in pairs(currentTattoos) do
                if v.Count ~= nil then
                    for i = 1, v.Count do
                        SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
                    end
                else
                    SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
                end
            end
            if DoesCamExist(cam) then
                DetachCam(cam)
                SetCamActive(cam, false)
                RenderScriptCams(false, false, 0, 1, 0)
                DestroyCam(cam, false)
            end
            JayMenu.Display()
        end
        for k, v in ipairs(Config.TattooCats) do
            if JayMenu.IsMenuOpened(v[1]) then
                CanSleep = false
                if not DoesCamExist(cam) then
                    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                    SetCamActive(cam, true)
                    RenderScriptCams(true, false, 0, true, true)
                    StopCamShaking(cam, true)
                end
                CreateScale("Control")
                DrawScaleformMovieFullscreen(scaleType, 255, 255, 255, 255, 0)
                if IsDisabledControlJustPressed(0, 21) then
                    ButtonPress()
                    if back == #v[3] then
                        back = 1
                    else
                        back = back + 1
                    end
                end
                if IsDisabledControlJustPressed(0, 90) then
                    ButtonPress()
                    if opacity == 10 then
                        opacity = 10
                    else
                        opacity = opacity + 1
                    end
                end
                if IsDisabledControlJustPressed(0, 89) then
                    ButtonPress()
                    if opacity == 1 then
                        opacity = 1
                    else
                        opacity = opacity - 1
                    end
                end
                if GetCamCoord(cam) ~= GetOffsetFromEntityInWorldCoords(PlayerPedId(), v[3][back]) then
                    SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), v[3][back]))
                    PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), v[4]))
                end
                for _, tattoo in pairs(Config.AllTattooList) do
                    if tattoo.Zone == v[1] then
                        if GetEntityModel(PlayerPedId()) == GetHashKey('mp_m_freemode_01') then
                            if tattoo.HashNameMale ~= '' then
                                local found = false
                                for k, v in pairs(currentTattoos) do
                                    if v.nameHash == tattoo.HashNameMale then
                                        found = true
                                        break
                                    end
                                end
                                if found then
                                    local clicked, hovered = JayMenu.SpriteButton(GetLabelText(tattoo.Name), "commonmenu", "shop_tattoos_icon_a", "shop_tattoos_icon_b")
                                    if clicked then
                                        RemoveTattoo(tattoo.HashNameMale, tattoo.Name)
                                    end
                                else
                                    local price = math.ceil(tattoo.Price / 20) == 0 and 100 or math.ceil(tattoo.Price / 20)
                                    local clicked, hovered = JayMenu.Button(GetLabelText(tattoo.Name), "~HUD_COLOUR_GREENDARK~$" .. price)
                                    if clicked then
                                        BuyTattoo(tattoo.Collection, tattoo.HashNameMale, tattoo.Name, price)
                                    elseif hovered then
                                        DrawTattoo(tattoo.Collection, tattoo.HashNameMale)
                                    end
                                end
                            end
                        else
                            if tattoo.HashNameFemale ~= '' then
                                local found = false
                                for k, v in pairs(currentTattoos) do
                                    if v.nameHash == tattoo.HashNameFemale then
                                        found = true
                                        break
                                    end
                                end
                                if found then
                                    local clicked, hovered = JayMenu.SpriteButton(GetLabelText(tattoo.Name), "commonmenu", "shop_tattoos_icon_a", "shop_tattoos_icon_b")
                                    if clicked then
                                        RemoveTattoo(tattoo.HashNameFemale, tattoo.Name)
                                    end
                                else
                                    local price = math.ceil(tattoo.Price / 20) == 0 and 100 or math.ceil(tattoo.Price / 20)
                                    local clicked, hovered = JayMenu.Button(GetLabelText(tattoo.Name), "~HUD_COLOUR_GREENDARK~$" .. price)
                                    if clicked then
                                        BuyTattoo(tattoo.Collection, tattoo.HashNameFemale, tattoo.Name, price)
                                    elseif hovered then
                                        DrawTattoo(tattoo.Collection, tattoo.HashNameFemale)
                                    end
                                end
                            end
                        end
                    end
                end
                JayMenu.Display()
            end
        end
        if CanSleep then
            Wait(3000)
        end
    end
end)

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    PushScaleformMovieMethodParameterButtonName(ControlButton)
end

function setupScaleform2(scaleform, message, button, message2, buttons, message3, button2)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, buttons[1], true))
    Button(GetControlInstructionalButton(2, buttons[2], true))
    ButtonMessage(message2)
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, button, true))
    ButtonMessage(message)
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, button2, true))
    ButtonMessage(message3)
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()
    
    return scaleform
end

function setupScaleform(scaleform, message, button)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, button, true))
    ButtonMessage(message)
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()
    
    return scaleform
end

RegisterNetEvent('remover:tudo', function()
    local ped = PlayerPedId()
    ClearPedDecorationsLeaveScars(ped)
end)
