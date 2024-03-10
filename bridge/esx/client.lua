if GetResourceState('es_extended') ~= 'started' then return end
ESX = exports['ex_extended']:getSharedObject()
Framework, PlayerLoaded, PlayerData = 'esx', nil, {}

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerSpawn', function()
    TriggerServerEvent('imtz_woodcutter:onPlayerSpawn') 
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    TriggerEvent('imtz_woodcutter:onPlayerDeath')
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    table.wipe(playerData)
    PlayerLoaded = false
end)

RegisterNetEvent('esx_setJob', function(job)
    PlayerData.job = job
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetInvokingResourceName() ~= resourceName or not ESX.PlayerLoaded then return end
    PlayerData = ESX.GetPlayerData()
    PlayerLoaded = true
end)

AddEventHandler('esx:setPlayerData', function(key, value)
    if GetInvokingResourceName() ~= 'es_extended' then return end
    PlayerData[key] = value
end)

function HasGroup(filter)
    local type = type(filter) 

    if type == 'string' then
        if PlayerData.job.name == filter then
            return PlayerData.job.name, PlayerData.job.grade
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            local grade = filter[PlayerData.job.name]

            if grade and grade <= PlayerData.job.grade then
                return PlayerData.job.name, PlayerData.job.grade
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                if PlayerData.job.name == filter[i] then
                    return PlayerData.job.name, PlayerData.job.grade
                end
            end
        end
    end
end