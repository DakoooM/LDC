CreateThread(function()
    while true do
        local aCoords = GetEntityCoords(Player:Ped())        
            local distance1 = GetDistanceBetweenCoords(aCoords.x, aCoords.y, aCoords.z, 4840.571, -5174.425, 2.0, false)
            if distance1 < 2000.0 then
                Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)  
                Citizen.InvokeNative("0x5E1460624D194A38", true)
            else
                Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
                Citizen.InvokeNative("0x5E1460624D194A38", false)
            end
        Wait(5000)
    end
end)