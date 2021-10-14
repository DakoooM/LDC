
RegisterServerEvent("aFrw:BuyAtCarWash")
AddEventHandler("aFrw:BuyAtCarWash", function(Price, Type)
    local source = source
    local PlayerMoney = GetMoney(source)
    if Type == 1 then 
        if Price >= PlayerMoney then
            TriggerClientEvent("RageUI:Popup", source, {message="Il vous manque ~g~"..Price-PlayerMoney.."$~s~ sur vous pour pouvoir acheter ceci."})
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~CarWash~s~\nPaiement effectué\n- ~g~"..Price.."$"})
            player[source].money = player[source].money - tonumber(Price)
            saveMoney(source)
            refreshMoney(source)
        end
    end
end)