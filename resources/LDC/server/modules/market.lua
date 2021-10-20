RegisterServerEvent("LDC:BuyMarket")
AddEventHandler("LDC:BuyMarket", function(price, coords)
    local src = tonumber(source);
    if not coords then print("ERROR COORDS Event Server BuyMarket") end
    if #(GetEntityCoords(GetPlayerPed(src)) - coords) < 2.5 then
        player[src].money = player[src].money - tonumber(price)
        saveMoney(src)
        refreshMoney(src)
    else
        print("tu bann mec")
    end
end)