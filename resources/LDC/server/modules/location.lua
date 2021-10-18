RegisterNetEvent("aFrw:BuyLocationVehicle", function(price, type)
    if type == 1 then 
        player[source].money = player[source].money - tonumber(price)
        saveMoney(source)
        refreshMoney(source)
        refreshInventory(source)
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nPaiement effectué : ~g~"..price.."$"})
    elseif type == 2 then 
        player[source].bank_money = player[source].bank_money - tonumber(price)
        saveMoney(source)
        refreshMoney(source)
        refreshInventory(source)
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nPaiement effectué : ~g~"..price.."$"})
    end
end)

