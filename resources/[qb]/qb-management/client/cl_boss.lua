local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })
local sharedJobs = exports['qb-core']:GetShared('Jobs')
local PlayerJob = QBCore.Functions.GetPlayerData().job
local shownBossMenu = false
local DynamicMenuItems = {}

-- UTIL
local function CloseMenuFull()
    exports['qb-menu']:closeMenu()
    exports['qb-core']:HideText()
    shownBossMenu = false
end

local function AddBossMenuItem(data, id)
    local menuID = id or (#DynamicMenuItems + 1)
    DynamicMenuItems[menuID] = deepcopy(data)
    return menuID
end

exports('AddBossMenuItem', AddBossMenuItem)

local function RemoveBossMenuItem(id)
    DynamicMenuItems[id] = nil
end

exports('RemoveBossMenuItem', RemoveBossMenuItem)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnPlayerUpdated', function(key, val)
    if key == 'job' then
        local JobInfo = val
        PlayerJob = JobInfo
    elseif key == 'all' then
        local JobInfo = val.job
        PlayerJob = JobInfo
    end
end)

RegisterNetEvent('qb-bossmenu:client:OpenMenu', function()
    if not PlayerJob.name or not PlayerJob.isboss then return end

    local bossMenu = {
        {
            header = Lang:t('headers.bsm') .. string.upper(PlayerJob.label),
            icon = 'fa-solid fa-circle-info',
            isMenuHeader = true,
        },
        {
            header = Lang:t('body.manage'),
            txt = Lang:t('body.managed'),
            icon = 'fa-solid fa-list',
            params = {
                event = 'qb-bossmenu:client:employeelist',
            }
        },
        {
            header = Lang:t('body.hire'),
            txt = Lang:t('body.hired'),
            icon = 'fa-solid fa-hand-holding',
            params = {
                event = 'qb-bossmenu:client:HireMenu',
            }
        },
        {
            header = Lang:t('body.storage'),
            txt = Lang:t('body.storaged'),
            icon = 'fa-solid fa-box-open',
            params = {
                isServer = true,
                event = 'qb-bossmenu:server:stash',
            }
        },
        {
            header = Lang:t('body.outfits'),
            txt = Lang:t('body.outfitsd'),
            icon = 'fa-solid fa-shirt',
            params = {
                event = 'qb-bossmenu:client:Wardrobe',
            }
        }
    }

    bossMenu[#bossMenu + 1] = {
        header = Lang:t('body.money'),
        txt = Lang:t('body.moneyd'),
        icon = 'fa-solid fa-sack-dollar',
        params = {
            event = 'qb-bossmenu:client:MoneyMenu',
        }
    }

    bossMenu[#bossMenu + 1] = {
        header = 'Promote / Demote',
        txt = Lang:t('body.managed'),
        icon = 'fa-solid fa-user-gear',
        params = {
            event = 'qb-bossmenu:client:employeelist',
        }
    }

    if PlayerJob.name == 'police' then
        bossMenu[#bossMenu + 1] = {
            header = 'Toggle Duty',
            txt = 'Go on or off duty',
            icon = 'fa-solid fa-clipboard-user',
            params = {
                event = 'qb-policejob:ToggleDuty',
            }
        }
    end

    for _, v in pairs(DynamicMenuItems) do
        bossMenu[#bossMenu + 1] = v
    end

    bossMenu[#bossMenu + 1] = {
        header = Lang:t('body.exit'),
        icon = 'fa-solid fa-angle-left',
        params = {
            event = 'qb-menu:closeMenu',
        }
    }

    exports['qb-menu']:openMenu(bossMenu)
end)

RegisterNetEvent('qb-bossmenu:client:employeelist', function()
    local EmployeesMenu = {
        {
            header = Lang:t('body.mempl') .. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = 'fa-solid fa-circle-info',
        },
    }
    QBCore.Functions.TriggerCallback('qb-bossmenu:server:GetEmployees', function(cb)
        for _, v in pairs(cb) do
            EmployeesMenu[#EmployeesMenu + 1] = {
                header = v.name,
                txt = v.grade.name,
                icon = 'fa-solid fa-circle-user',
                params = {
                    event = 'qb-bossmenu:client:ManageEmployee',
                    args = {
                        player = v,
                        work = PlayerJob
                    }
                }
            }
        end
        EmployeesMenu[#EmployeesMenu + 1] = {
            header = Lang:t('body.return'),
            icon = 'fa-solid fa-angle-left',
            params = {
                event = 'qb-bossmenu:client:OpenMenu',
            }
        }
        exports['qb-menu']:openMenu(EmployeesMenu)
    end, PlayerJob.name)
end)

RegisterNetEvent('qb-bossmenu:client:ManageEmployee', function(data)
    local EmployeeMenu = {
        {
            header = Lang:t('body.mngpl') .. data.player.name .. ' - ' .. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = 'fa-solid fa-circle-info'
        },
    }
    for k, v in pairs(sharedJobs[data.work.name].grades) do
        EmployeeMenu[#EmployeeMenu + 1] = {
            header = v.name,
            txt = Lang:t('body.grade') .. k,
            params = {
                isServer = true,
                event = 'qb-bossmenu:server:GradeUpdate',
                icon = 'fa-solid fa-file-pen',
                args = {
                    cid = data.player.empSource,
                    grade = tonumber(k),
                    gradename = v.name
                }
            }
        }
    end
    EmployeeMenu[#EmployeeMenu + 1] = {
        header = Lang:t('body.fireemp'),
        icon = 'fa-solid fa-user-large-slash',
        params = {
            isServer = true,
            event = 'qb-bossmenu:server:FireEmployee',
            args = data.player.empSource
        }
    }
    EmployeeMenu[#EmployeeMenu + 1] = {
        header = Lang:t('body.return'),
        icon = 'fa-solid fa-angle-left',
        params = {
            event = 'qb-bossmenu:client:OpenMenu',
        }
    }
    exports['qb-menu']:openMenu(EmployeeMenu)
end)

RegisterNetEvent('qb-bossmenu:client:Wardrobe', function()
    TriggerEvent('qb-clothing:client:openOutfitMenu')
end)

RegisterNetEvent('qb-bossmenu:client:HireMenu', function()
    local HireMenu = {
        {
            header = Lang:t('body.hireemp') .. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = 'fa-solid fa-circle-info',
        },
    }
    QBCore.Functions.TriggerCallback('qb-bossmenu:getplayers', function(players)
        for _, v in pairs(players) do
            if v and v ~= PlayerId() then
                HireMenu[#HireMenu + 1] = {
                    header = v.name,
                    txt = Lang:t('body.cid') .. v.citizenid .. ' - ID: ' .. v.sourceplayer,
                    icon = 'fa-solid fa-user-check',
                    params = {
                        isServer = true,
                        event = 'qb-bossmenu:server:HireEmployee',
                        args = v.sourceplayer
                    }
                }
            end
        end
        HireMenu[#HireMenu + 1] = {
            header = Lang:t('body.return'),
            icon = 'fa-solid fa-angle-left',
            params = {
                event = 'qb-bossmenu:client:OpenMenu',
            }
        }
        exports['qb-menu']:openMenu(HireMenu)
    end)
end)

RegisterNetEvent('qb-bossmenu:client:MoneyMenu', function()
    if not PlayerJob.name or not PlayerJob.isboss then return end
    QBCore.Functions.TriggerCallback('qb-bossmenu:server:GetBalance', function(balance)
        local MoneyMenu = {
            {
                header = Lang:t('headers.bsm') .. string.upper(PlayerJob.label),
                isMenuHeader = true,
                icon = 'fa-solid fa-sack-dollar',
            },
            {
                header = Lang:t('body.balance') .. balance,
                isMenuHeader = true,
                icon = 'fa-solid fa-money-bill-trend-up',
            },
            {
                header = Lang:t('body.deposit'),
                txt = Lang:t('body.depositd'),
                icon = 'fa-solid fa-arrow-down',
                params = {
                    event = 'qb-bossmenu:client:DepositMoney',
                }
            },
            {
                header = Lang:t('body.withdraw'),
                txt = Lang:t('body.withdrawd'),
                icon = 'fa-solid fa-arrow-up',
                params = {
                    event = 'qb-bossmenu:client:WithdrawMoney',
                }
            },
            {
                header = Lang:t('body.return'),
                icon = 'fa-solid fa-angle-left',
                params = {
                    event = 'qb-bossmenu:client:OpenMenu',
                }
            }
        }
        exports['qb-menu']:openMenu(MoneyMenu)
    end)
end)

RegisterNetEvent('qb-bossmenu:client:DepositMoney', function()
    local dialog = exports['qb-input']:ShowInput({
        header = Lang:t('body.deposit'),
        submitText = Lang:t('body.submit'),
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = Lang:t('body.amount')
            }
        }
    })
    if dialog and dialog.amount then
        local amount = tonumber(dialog.amount)
        if amount and amount > 0 then
            TriggerServerEvent('qb-bossmenu:server:DepositMoney', amount)
        end
    end
end)

RegisterNetEvent('qb-bossmenu:client:WithdrawMoney', function()
    local dialog = exports['qb-input']:ShowInput({
        header = Lang:t('body.withdraw'),
        submitText = Lang:t('body.submit'),
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = Lang:t('body.amount')
            }
        }
    })
    if dialog and dialog.amount then
        local amount = tonumber(dialog.amount)
        if amount and amount > 0 then
            TriggerServerEvent('qb-bossmenu:server:WithdrawMoney', amount)
        end
    end
end)

-- MAIN THREAD
CreateThread(function()
    if Config.UseTarget then
        for job, zones in pairs(Config.BossMenus) do
            for index, coords in ipairs(zones) do
                local zoneName = job .. '_bossmenu_' .. index
                exports['qb-target']:AddCircleZone(zoneName, coords, 0.5, {
                    name = zoneName,
                    debugPoly = false,
                    useZ = true
                }, {
                    options = {
                        {
                            type = 'client',
                            event = 'qb-bossmenu:client:OpenMenu',
                            icon = 'fas fa-sign-in-alt',
                            label = Lang:t('target.label'),
                            canInteract = function() return job == PlayerJob.name and PlayerJob.isboss end,
                        },
                    },
                    distance = 2.5
                })
            end
        end
    else
        while true do
            local wait = 2500
            local pos = GetEntityCoords(PlayerPedId())
            local inRangeBoss = false
            local nearBossmenu = false
            if PlayerJob then
                wait = 0
                for k, menus in pairs(Config.BossMenus) do
                    for _, coords in ipairs(menus) do
                        if k == PlayerJob.name and PlayerJob.isboss then
                            if #(pos - coords) < 5.0 then
                                inRangeBoss = true
                                if #(pos - coords) <= 1.5 then
                                    nearBossmenu = true
                                    if not shownBossMenu then
                                        exports['qb-core']:DrawText(Lang:t('drawtext.label'), 'left')
                                        shownBossMenu = true
                                    end
                                    if IsControlJustReleased(0, 38) then
                                        exports['qb-core']:HideText()
                                        TriggerEvent('qb-bossmenu:client:OpenMenu')
                                    end
                                end

                                if not nearBossmenu and shownBossMenu then
                                    CloseMenuFull()
                                    shownBossMenu = false
                                end
                            end
                        end
                    end
                end
                if not inRangeBoss then
                    Wait(1500)
                    if shownBossMenu then
                        CloseMenuFull()
                        shownBossMenu = false
                    end
                end
            end
            Wait(wait)
        end
    end
end)
