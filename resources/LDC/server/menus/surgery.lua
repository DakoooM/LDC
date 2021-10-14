
RegisterServerEvent("aFrw:BuyAtSurgery")
AddEventHandler("aFrw:BuyAtSurgery", function(NewSurgery, Price, Type)
    local source = source
    local PlayerMoney = GetMoney(source)
    local BankPlayerMoney = GetBankMoney(source)
    if Type == 1 then 
        if Price >= PlayerMoney then
            TriggerClientEvent("RageUI:Popup", source, {message="Il vous manque ~g~"..Price-PlayerMoney.."$~s~ sur vous pour pouvoir acheter ceci."})
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Intervention Chirurgical~s~\nPaiement effectué\n- ~g~"..Price.."$"})
            player[source].skin.mom = NewSurgery.mom
            player[source].skin.dad = NewSurgery.dad
            player[source].skin.resem = NewSurgery.resem
            player[source].skin.face = NewSurgery.face
            player[source].skin.ageing = NewSurgery.ageing
            player[source].money = player[source].money - tonumber(Price)
            saveSkin(source)
            saveMoney(source)
            refreshMoney(source)
            refreshSkin(source)
        end
    end
end)