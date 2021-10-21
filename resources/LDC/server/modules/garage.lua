RegisterServerCallback(Config.ServerName.. "GetOwnVehicle", function(source, callback, setting)
    if setting.type == "refresh" then
        MySQL.Async.fetchAll('SELECT * FROM player_veh WHERE (owner = @owner)', {
            ['owner'] = GetLicense(source)
        }, function(result)
            callback(result)
        end)
    end
end)

RegisterServerEvent(Config.ServerName.. "actionsPound")
AddEventHandler(Config.ServerName.. "actionsPound", function(setting)
    if setting.type == "leavePound" then
        if #(GetEntityCoords(GetPlayerPed(source)) - setting.coords) < 20.0 then
            player[source].money = player[source].money - setting.money
            saveMoney(source)
            refreshInventory(source)
            MySQL.Async.execute('UPDATE player_veh SET parked = @parked WHERE plate = @plate',{
                ['@plate'] = setting.plate,
                ['@parked'] = 1,
            })
        else
            print("TES BAN")
        end
    end
end)