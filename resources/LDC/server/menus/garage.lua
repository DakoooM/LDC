RegisterServerCallback('aFrw:GetOwnVehicle', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM player_veh WHERE (owner = @owner)', {
        ['owner'] = GetLicense(source)
    }, function(result)
        cb(result)
    end)
end)

RegisterServerEvent("aFrw:SetParked")
AddEventHandler("aFrw:SetParked", function(plate, parked)
    MySQL.Async.execute('UPDATE player_veh SET parked = @parked WHERE plate = @plate',{
        ['@plate'] = plate,
        ['@parked'] = parked,
    })
end)