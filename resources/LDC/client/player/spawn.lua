function InitPosition(pos)
    Player:Teleport(Player:Ped(), {pos.x, pos.y, pos.z})
    SetEntityHeading(PlayerPedId(), pos.w)
end

RegisterNetEvent("aFrw:refreshPlayerData")
AddEventHandler("aFrw:refreshPlayerData", function(data)
    Player:new(data)
end)

AddEventHandler("playerSpawned", function()
    while Player == nil do Wait(1000) end
    while Player:getIdentity() == nil do
        Wait(1)
    end
    if Player:getIdentity() == nil then
        loadCharCreator()
    else
        loadChooseMenu()
    end
end)

function LoadPlayerData()  
    InitPosition(Player:getPos())
end

TriggerServerEvent('aFrw:loadPlayerData')

