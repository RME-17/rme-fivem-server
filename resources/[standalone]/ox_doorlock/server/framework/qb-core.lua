local QBCore = exports['qb-core']:GetCoreObject()

function GetPlayer(playerId)
    return QBCore.Functions.GetPlayer(playerId)
end

function GetCharacterId(player)
    return player.PlayerData.citizenid
end

function IsPlayerInGroup(player, filter)
    local filterType = type(filter)
    local job = player.PlayerData.job
    local gang = player.PlayerData.gang

    if filterType == 'string' then
        if job and job.name == filter then
            return job.name, job.grade.level
        end

        if gang and gang.name == filter then
            return gang.name, gang.grade.level
        end
    elseif filterType == 'table' then
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            if job then
                local jobGrade = filter[job.name]

                if jobGrade and jobGrade <= job.grade.level then
                    return job.name, job.grade.level
                end
            end

            if gang then
                local gangGrade = filter[gang.name]

                if gangGrade and gangGrade <= gang.grade.level then
                    return gang.name, gang.grade.level
                end
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                if job and job.name == filter[i] then
                    return job.name, job.grade.level
                end

                if gang and gang.name == filter[i] then
                    return gang.name, gang.grade.level
                end
            end
        end
    end
end
