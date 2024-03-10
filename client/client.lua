local woodcutter = false

CreateThread(function()
    for i=1, #Config.woodAreas, 1 do
        CreateBlip(Config.woodAreas[i], 85, 5, Strings.wood_blips, 0.75)
    end
end)
CreateThread(function()
    local textUI = {}
    while true do
        local sleep = 1500
        local pos = GetEntityCoords(cache.ped)
        for i=1, #Config.woodAreas, 1 do
           local dist = #(pos - Config.woodAreas[i])
           if dist <= 2.0 and not woodcutter then
            sleep = 0 
            if not textUI[i] then
                lib.showTextUI(Strings.wood_cutter)
                textUI[i] = true
            end
            if IsControlJustReleased(0, 38) and dist <= 2.0 then
                lib.hideTextUI()
                local output = lib.callback.await('imtz_woodcutter:checkAxe', 100, 'axe')
                if output then 
                    woodcutter = true
                    local model = Config.axe.prop
                    lib.requestModel(model, 100)
                    local axe = CreateObject(model, GetEntityCoords(cache.ped), true, false, false)
                    AttachEntityToEntity(axe, cache.ped, GetPedBoneIndex(cache.ped, 57005))
                    while woodcutter do
                        Wait()
                        local unarmed = `WEAPON_UNARMED`
                        SetCurrentPedWeapon(cache.ped, unarmed)
                            showHelp(Strings.intro_instruction)
                            DisableControlAction(0, 24, true)
                            if IsDisabledControlJustReleased(0, 24) then
                                lib.requestAnimDict('melee@hatchet@streamed_core', 100)
                                TaskPlayAnim(cache.ped, 'melee@hatchet@streamed_core', 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
                                local rockData = lib.callback.await('wasabi_mining:getRockData', 100)
                                if lib.skillCheck(rockData.difficulty) then
                                    ClearPedTasks(cache.ped)
                                    tryMine(rockData, i)
                                else
                                    local breakChance = math.random(1, 100)
                                    if breakChance < Config.axe.breakChance then
                                        TriggerClientEvent('imtz_woodcutter:axeBroke')
                                        TriggerEvent('imtz_woodcutter:notify', Strings.axe_broke, Strings.axe_broke_desc, 'error')
                                        ClearPedTasks(cache.ped)
                                        textUI[i] = nil
                                        break
                                    end
                                    ClearPedTasks(PlayerPedId())
                                    TriggerEvent('imtz_woodcutter:notify', Strings.failed_mine, Strings.failed_mine_desc, 'error')
                                end
                            elseif IsControlJustReleased(0, 194) then
                                textUI[i] = nil
                                break
                            elseif #(GetEntityCoords(cache.ped) - Config.woodAreas[i]) > 2.0 then
                                textUI[i] = nil
                                break
                            end
                        end
                        woodcutter = false
                        textUI[i] = nil
                        DeleteObject(axe)
                        RemoveAnimDict('melee@hatchet@streamed_core')
                    elseif not output then
                        TriggerEvent('imtz_woodcutter:notify', Strings.no_axe, Strings.no_axe_desc, 'error')
                    end
                end
            elseif dist >= 2.1 then
                if textUI[i] then
                    lib.hideTextUI()
                    textUI[1] = nil
                end
            end
        end
        Wait(sleep)
    end
end)                
