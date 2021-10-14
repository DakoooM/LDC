RegisterNetEvent("aFrw:UpdateStatus")
AddEventHandler("aFrw:UpdateStatus", function(value)
    local source = source
    if player[source].status.hunger < 10 or player[source].status.water < 10 then 
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous allez bientôt tomber dans les pommes, veillez à boire et manger"})
    end
    if player[source].status.hunger < 1 and player[source].status.water < 1 then 
        player[source].status.hunger = 0
    else
        player[source].status.hunger = player[source].status.hunger - value
    end
    if player[source].status.water < 1 then 
        player[source].status.water = 0
    else
        player[source].status.water = player[source].status.water - value
    end
    TriggerClientEvent("aFrw:refreshPlayerData", source, player[source])
end)

RegisterNetEvent("aFrw:AddHunger")
AddEventHandler("aFrw:AddHunger", function(value)
    local source = source
    if player[source].status.hunger > 100 then
        player[source].status.hunger = 100
        return TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous avez le ventre plein !"})
    end
    player[source].status.hunger = player[source].status.hunger + value
    TriggerClientEvent("aFrw:refreshPlayerData", source, player[source])
end)

RegisterNetEvent("aFrw:AddWater")
AddEventHandler("aFrw:AddWater", function(value)
    local source = source
    if player[source].status.water > 100 then
        player[source].status.water = 100
        return TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous n'avez plus soif !"})
    end
    player[source].status.water = player[source].status.water + value
    TriggerClientEvent("aFrw:refreshPlayerData", source, player[source])
end)