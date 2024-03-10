Config = {}
Config.checkForUpdates = false
Config.oldESX = false
Config.axe = {
    prop = `prop_tool_fireaxe`,
    breakChance = 20
}
Config.wood = {
    {item = 'wood', label = 'Wood', price = {100, 200}, difficulty = {'medium', 'easy'} }
}
Config.woodAreas = {
    --importare i valori di dove si vuole mettere gl'alberi
}
Config.sellShop = {
    enabled = true, 
    --coords = --mettere le cordinate dello shop
    heading = 314.65
    ped = 's_m_m_gaffer_01'
}

RegisterServerEvent('imtz_woodcutter:notify')
AddEventHandler('imtz_woodcutter:notify' function(title, message, msgType) 
    if not msgType then
        lib.notify({
            title = title,
            description = message,
            type = 'inform'
        })
    else
        lib.notify({
            title = title,
            description = message,
            type = msgType
        })
    end
end)
