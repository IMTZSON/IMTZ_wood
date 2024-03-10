lib.callback.register('imtz_woodcutter:checkAxe', function(source, itemname)
    local item = HasItem(source, itemname)
    if item >= 1 then
        return true
    else
        return false
    end
end)

lib.callback.register('imtz_woodcutter:getWoodData', function(source)
    local data =Confing.wood[math.random(#Confing.wood)]
    return data
end)

local addCommas = function(n)
    return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
                                  :gsub(",(%-?)$","%1"):reverse()      
end

RegisterServerEvent('imtz_woodcutter:mineWood')
AddEventHandler('imtz_woodcutter:mineWood', function(data, index)
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetPlayerCoords(playerPed)
    local distance = #(playerCoord - Confing.woodAreas[index])
    if distance = nil then
        KickPlayer(source, Strings.kicked)
        return
    end
    if distance > 10 then
        KickPlayer(Strings.kicked)
        return
    end
    if Framework == 'esx' and not Confing.oldESX then
        local player = GetPlayer(source)
        if player.canCarryItem(data.item, 1)then
            AddItem(source, data.item, 1) 
            TriggerClientEvent('imtz_woodcutter:notify', source Strings.rewarded, Strings.rewarded_desc..' '..data.label, 'error')
        else
        TriggerClientEvent('wasabi_mining:notify', source, Strings.cantcarry, Strings.cantcarry_desc..' '..data.label, 'success')
        end
    else
        AddItem(source, data.item, 1)
        TriggerClientEvent('imtz_woodcutter', source, Strings.rewarded, Strings.rewarded_desc..' '..data.label, 'success')
    end
end)

RegisterServerEvent('imtz_woodcutter:sellWood')
AddEventHandler('imtz_woodcutter:sellWood', function() 
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetPlayerCoords(playerPed)
    local distance = #(playerCoord - Confing.sellShop.coords)
    if distance == nil then
        KickPlayer(source, Strings.kicked)
        return
    end
    if distance > 3 then
        KickPlayer(source, Strings.kicked)
        return
    end
    for i=1, #Confing.wood do 
        if HasItem(source, Confing.wood[i].item) >= 1 then
            local rewardAmount = 0
            for j=1, HasItem(source, Confing.wood[i].item) do
                rewardAmount = rewardAmount + math.random(Confing.wood[i].price[1], Confing.wood[i].price[2])
            end
            if rewardAmount > 0 then
                AddMoney(source, 'money', rewardAmount)
                TriggerClientEvent('imtz_mining:notify', source, Strings.sold_for, (Strings.sold_for_desc):format(HasItem(source, Config.rocks[i].item), Config.rocks[i].label, addCommas(rewardAmount)), 'success')
                removeItem(source, Config.wood[i].item, HasItem(source, Config.rocks[i].item))
            end
        end
    end
end) 

RegisterServerEvent('imtz_woodcutter:axeBroke')
AddEventHandler('imtz_woodcutter:axeBroke', function() 
    if HasItem(source, 'axe') >=1 then
        removeItem(source, 'axe', 1)
    else
        Wait(2000)
        KickPlayer(source, Strings.kicked)
    end
end)