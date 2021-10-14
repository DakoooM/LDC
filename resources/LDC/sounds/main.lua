MusicZone = {
    {
        name = "spawnPoint",
        link = "https://www.youtube.com/watch?v=jrZOAg3oH4c", -- https://www.youtube.com/watch?v=rBLuvEwIF5E
        dst = 18.0,
        starting = 18.0,
        pos = vector3(-40.21, -774.41, 44.22),
        max = 0.050,
    },
}

CreateThread(function()
    while true do
        Wait(1000)
        local NearZone = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        SendNUIMessage({
            status = "position",
            x = pos.x,
            y = pos.y,
            z = pos.z
        })
        NearZone = false
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        for k,v in pairs(MusicZone) do
            local dst = GetDistanceBetweenCoords(pCoords, v.pos, true)
            if not NearZone then
                if dst < v.starting then
                    NearZone = true
                    if soundExists(v.name) then
                        Resume(v.name)
                    else
                        PlayUrlPos(v.name, v.link, v.max, v.pos, true)
                        setVolumeMax(v.name, v.max)
                        Distance(v.name, v.dst)
                    end
                else
                    if soundExists(v.name) then
                        if not isPaused(v.name) then
                            Pause(v.name)
                        end
                    end
                end
            end
        end
        if not NearZone then
            Wait(350)
        else
            Wait(50)
        end
    end
end)