RegisterServerEvent("LDC:BuyMarket", function(price)
    local source = source
    if GetMoney(source) <= tonumber(price) then
        TriggerClientEvent("RageUI:Popup", source, {message="~g~<C>Market</C>~s~\n~o~Vous n'avez pas assez d'argent~s~"})
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~g~<C>Market</C>~s~\n~g~Merci de votre achat~s~"})
        player[source].money = player[source].money - tonumber(price)
        saveMoney(source)
        refreshMoney(source)
    end
end)