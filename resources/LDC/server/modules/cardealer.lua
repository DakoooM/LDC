RegisterServerEvent("aFrw:BuyVehiclePlayer", function(price, vehiclemodel, vehicleplate, vehiclecolor1, vehiclecolor2)
    local source = source
    if GetMoney(source) <= tonumber(price) then
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous n'avez pas assez d'argent"})
    else
        TriggerClientEvent("aFrw:CreateVehicle", source, vehiclemodel)
        TriggerClientEvent("RageUI:Popup", source, {message="~y~Informations~s~\n- Transaction effectué\n- Profitez de votre nouveau véhicule !"})
        player[source].money = player[source].money - tonumber(price)
        saveMoney(source)
        refreshMoney(source)
        MySQL.Async.execute("INSERT INTO `player_veh` (owner, plate, model, color1, color2) VALUES (@owner, @plate, @model, @color1, @color2)", {
            ['@owner'] = GetLicense(source),
            ['@plate'] = vehicleplate,
            ['@model'] = vehiclemodel,
            ['@color1'] = vehiclecolor1,
            ['@color2'] = vehiclecolor2,
        }, function(rowsChanged)
        end)
    end
end)