function InitPosition(pos)
    Player:Teleport(Player:Ped(), {pos.x, pos.y, pos.z})
    SetEntityHeading(PlayerPedId(), pos.w)
end

RegisterNetEvent("aFrw:refreshPlayerData")
AddEventHandler("aFrw:refreshPlayerData", function(data)
    Player:new(data)
end)

CreateThread(function()
    local coords = GetEntityCoords(PlayerPedId())
    spawnPlayer({x = coords.x, y = coords.x, z = coords.z, model = GetHashKey("u_m_m_aldinapoli"), heading = 215.0}, false, function()
        LDC.loadSkin("First Spawn")
        local getGround, zGround = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, true, 0)
        if getGround then SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, zGround + 1.0, 0.0, 0.0, 0.0) end
    end)
end)

AddEventHandler("playerSpawned", function()
    while Player == nil do Wait(5) end
    while Player:getIdentity() == nil do Wait(1) end

    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(Player:Ped(), true, true)
    
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

