local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })

function ExploitBan(id, reason)
	MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
		GetPlayerName(id),
		QBCore.Functions.GetIdentifier(id, 'license'),
		QBCore.Functions.GetIdentifier(id, 'discord'),
		QBCore.Functions.GetIdentifier(id, 'ip'),
		reason,
		2147483647,
		'qb-management'
	})
	TriggerEvent('qb-log:server:CreateLog', 'bans', 'Player Banned', 'red', string.format('%s was banned by %s for %s', GetPlayerName(id), 'qb-management', reason), true)
	DropPlayer(id, 'You were permanently banned by the server for: Exploiting')
end

-- Get Employees
QBCore.Functions.CreateCallback('qb-bossmenu:server:GetEmployees', function(source, cb, jobname)
	local src = source
	local Player = exports['qb-core']:GetPlayer(src)

	if not Player.PlayerData.job.isboss then
		ExploitBan(src, 'GetEmployees Exploiting')
		return
	end

	local employees = {}

	local players = MySQL.query.await("SELECT * FROM `players` WHERE `job` LIKE '%" .. jobname .. "%'", {})

	if players[1] ~= nil then
		for _, value in pairs(players) do
			local Target = QBCore.Functions.GetPlayerByCitizenId(value.citizenid) or QBCore.Functions.GetOfflinePlayerByCitizenId(value.citizenid)

			if Target and Target.PlayerData.job.name == jobname then
				local isOnline = Target.PlayerData.source
				employees[#employees + 1] = {
					empSource = Target.PlayerData.citizenid,
					grade = Target.PlayerData.job.grade,
					isboss = Target.PlayerData.job.isboss,
					name = (isOnline and '🟢 ' or '❌ ') .. Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname
				}
			end
		end
		table.sort(employees, function(a, b)
			return a.grade.level > b.grade.level
		end)
	end
	cb(employees)
end)

RegisterNetEvent('qb-bossmenu:server:stash', function()
	local src = source
	local Player = exports['qb-core']:GetPlayer(src)
	if not Player then return end
	local playerJob = Player.PlayerData.job
	if not playerJob.isboss then return end
	local playerPed = GetPlayerPed(src)
	local playerCoords = GetEntityCoords(playerPed)
	if not Config.BossMenus[playerJob.name] then return end
	local bossCoords = Config.BossMenus[playerJob.name]
	for i = 1, #bossCoords do
		local coords = bossCoords[i]
		if #(playerCoords - coords) < 2.5 then
			local stashName = 'boss_' .. playerJob.name
			exports['qb-inventory']:OpenInventory(src, stashName, {
				maxweight = 4000000,
				slots = 25,
			})
			return
		end
	end
end)

-- Grade Change
RegisterNetEvent('qb-bossmenu:server:GradeUpdate', function(data)
	local src = source
	local Player = exports['qb-core']:GetPlayer(src)
	local Employee = QBCore.Functions.GetPlayerByCitizenId(data.cid) or QBCore.Functions.GetOfflinePlayerByCitizenId(data.cid)

	if not Player.PlayerData.job.isboss then
		ExploitBan(src, 'GradeUpdate Exploiting')
		return
	end
	if data.grade > Player.PlayerData.job.grade.level then
		TriggerClientEvent('QBCore:Notify', src, 'You cannot promote to this rank!', 'error')
		return
	end

	if Employee then
		if Employee.Functions.SetJob(Player.PlayerData.job.name, data.grade) then
			TriggerClientEvent('QBCore:Notify', src, 'Sucessfully promoted!', 'success')
			Employee.Functions.Save()

			if Employee.PlayerData.source then -- Player is online
				TriggerClientEvent('QBCore:Notify', Employee.PlayerData.source, 'You have been promoted to ' .. data.gradename .. '.', 'success')
			end
		else
			TriggerClientEvent('QBCore:Notify', src, 'Promotion grade does not exist.', 'error')
		end
	end
	TriggerClientEvent('qb-bossmenu:client:OpenMenu', src)
end)

-- Fire Employee
RegisterNetEvent('qb-bossmenu:server:FireEmployee', function(target)
	local src = source
	local Player = exports['qb-core']:GetPlayer(src)
	local Employee = QBCore.Functions.GetPlayerByCitizenId(target) or QBCore.Functions.GetOfflinePlayerByCitizenId(target)

	if not Player.PlayerData.job.isboss then
		ExploitBan(src, 'FireEmployee Exploiting')
		return
	end

	if Employee then
		if target == Player.PlayerData.citizenid then
			TriggerClientEvent('QBCore:Notify', src, 'You can\'t fire yourself', 'error')
			return
		elseif Employee.PlayerData.job.grade.level > Player.PlayerData.job.grade.level then
			TriggerClientEvent('QBCore:Notify', src, 'You cannot fire this citizen!', 'error')
			return
		end
		if Employee.Functions.SetJob('unemployed', '0') then
			Employee.Functions.Save()
			TriggerClientEvent('QBCore:Notify', src, 'Employee fired!', 'success')
			TriggerEvent('qb-log:server:CreateLog', 'bossmenu', 'Job Fire', 'red', Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname .. ' successfully fired ' .. Employee.PlayerData.charinfo.firstname .. ' ' .. Employee.PlayerData.charinfo.lastname .. ' (' .. Player.PlayerData.job.name .. ')', false)

			if Employee.PlayerData.source then -- Player is online
				TriggerClientEvent('QBCore:Notify', Employee.PlayerData.source, 'You have been fired! Good luck.', 'error')
			end
		else
			TriggerClientEvent('QBCore:Notify', src, 'Error..', 'error')
		end
	end
	TriggerClientEvent('qb-bossmenu:client:OpenMenu', src)
end)

-- Recruit Player
RegisterNetEvent('qb-bossmenu:server:HireEmployee', function(recruit)
	local src = source
	local Player = exports['qb-core']:GetPlayer(src)
	local Target = exports['qb-core']:GetPlayer(recruit)

	if not Player.PlayerData.job.isboss then
		ExploitBan(src, 'HireEmployee Exploiting')
		return
	end

	if Target and Target.Functions.SetJob(Player.PlayerData.job.name, 0) then
		TriggerClientEvent('QBCore:Notify', src, 'You hired ' .. (Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname) .. ' come ' .. Player.PlayerData.job.label .. '', 'success')
		TriggerClientEvent('QBCore:Notify', Target.PlayerData.source, 'You were hired as ' .. Player.PlayerData.job.label .. '', 'success')
		TriggerEvent('qb-log:server:CreateLog', 'bossmenu', 'Recruit', 'lightgreen', (Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname) .. ' successfully recruited ' .. (Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname) .. ' (' .. Player.PlayerData.job.name .. ')', false)
	end
	TriggerClientEvent('qb-bossmenu:client:OpenMenu', src)
end)

-- Get closest player sv
QBCore.Functions.CreateCallback('qb-bossmenu:getplayers', function(source, cb)
	local src = source
	local players = {}
	local PlayerPed = GetPlayerPed(src)
	local pCoords = GetEntityCoords(PlayerPed)
	for _, v in pairs(QBCore.Functions.GetPlayers()) do
		local targetped = GetPlayerPed(v)
		local tCoords = GetEntityCoords(targetped)
		local dist = #(pCoords - tCoords)
		if PlayerPed ~= targetped and dist < 10 then
			local ped = exports['qb-core']:GetPlayer(v)
			players[#players + 1] = {
				id = v,
				coords = GetEntityCoords(targetped),
				name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname,
				citizenid = ped.PlayerData.citizenid,
				sources = GetPlayerPed(ped.PlayerData.source),
				sourceplayer = ped.PlayerData.source
			}
		end
	end
	table.sort(players, function(a, b)
		return a.name < b.name
	end)
	cb(players)
end)


-- Society Account: balance / deposit / withdraw (added)
QBCore.Functions.CreateCallback('qb-bossmenu:server:GetBalance', function(source, cb)
    local Player = exports['qb-core']:GetPlayer(source)
    if not Player or not Player.PlayerData.job.isboss then
        cb(0)
        return
    end
    cb(exports['qb-banking']:GetAccountBalance(Player.PlayerData.job.name) or 0)
end)

RegisterNetEvent('qb-bossmenu:server:DepositMoney', function(amount)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    if not Player.PlayerData.job.isboss then
        ExploitBan(src, 'DepositMoney Exploiting')
        return
    end
    amount = tonumber(amount)
    if not amount or amount <= 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Invalid amount', 'error')
        return
    end
    amount = math.floor(amount)
    local account = Player.PlayerData.job.name
    if (Player.PlayerData.money.bank or 0) < amount then
        TriggerClientEvent('QBCore:Notify', src, 'Not enough money in your bank account', 'error')
        return
    end
    if Player.Functions.RemoveMoney('bank', amount, 'boss-deposit-' .. account) then
        if exports['qb-banking']:AddMoney(account, amount, 'Boss deposit') then
            TriggerClientEvent('QBCore:Notify', src, 'Deposited $' .. amount .. ' into the society account', 'success')
        else
            Player.Functions.AddMoney('bank', amount, 'boss-deposit-refund')
            TriggerClientEvent('QBCore:Notify', src, 'Deposit failed', 'error')
        end
    end
    TriggerClientEvent('qb-bossmenu:client:MoneyMenu', src)
end)

RegisterNetEvent('qb-bossmenu:server:WithdrawMoney', function(amount)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    if not Player.PlayerData.job.isboss then
        ExploitBan(src, 'WithdrawMoney Exploiting')
        return
    end
    amount = tonumber(amount)
    if not amount or amount <= 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Invalid amount', 'error')
        return
    end
    amount = math.floor(amount)
    local account = Player.PlayerData.job.name
    local balance = exports['qb-banking']:GetAccountBalance(account) or 0
    if balance < amount then
        TriggerClientEvent('QBCore:Notify', src, 'Not enough money in the society account', 'error')
        return
    end
    if exports['qb-banking']:RemoveMoney(account, amount, 'Boss withdrawal') then
        Player.Functions.AddMoney('bank', amount, 'boss-withdraw-' .. account)
        TriggerClientEvent('QBCore:Notify', src, 'Withdrew $' .. amount .. ' from the society account', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Withdrawal failed', 'error')
    end
    TriggerClientEvent('qb-bossmenu:client:MoneyMenu', src)
end)
