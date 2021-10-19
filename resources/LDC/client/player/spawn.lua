function InitPosition(pos)
    Player:Teleport(Player:Ped(), {pos.x, pos.y, pos.z})
    SetEntityHeading(Player:Ped(), pos.w)
end

RegisterNetEvent("aFrw:refreshPlayerData")
AddEventHandler("aFrw:refreshPlayerData", function(data)
    Player:new(data)
end)

local deathPlayerCam = nil
local isDead = false
local angleY = 0.0
local angleZ = 0.0
local RadiusCamera = 1.5

function StartDeathCam()
    ClearFocus()
    deathPlayerCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(PlayerPedId()), 0, 0, 0, GetGameplayCamFov())
    SetCamActive(deathPlayerCam, true)
    SetCamFov(deathPlayerCam, 70.0)
    RenderScriptCams(true, true, 500, true, false)

end

function EndDeathCam()
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(deathPlayerCam, false)
    deathPlayerCam = nil
end


function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0
    
    -- keyboard
    if (IsInputDisabled(0)) then
        -- rotation
        mouseX = GetDisabledControlNormal(1, 1) * 8.0
        mouseY = GetDisabledControlNormal(1, 2) * 8.0
        
    -- controller
    else
        -- rotation
        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end

    angleZ = angleZ - mouseX -- around Z axis (left / right)
    angleY = angleY + mouseY -- up / down
    -- limit up / down angle to 90°
    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end
    
    local pCoords = GetEntityCoords(PlayerPedId())
    
    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (RadiusCamera + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (RadiusCamera + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (RadiusCamera + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    
    local maxRadius = RadiusCamera
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < RadiusCamera + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end
    
    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }
    
    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }

    return pos
end

function ProcessCamControls()
    local playerCoords = GetEntityCoords(Player:Ped())
    DisableFirstPersonCamThisFrame()
    local newPos = ProcessNewPosition()
    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    SetCamCoord(deathPlayerCam, newPos.x, newPos.y, newPos.z)
    PointCamAtCoord(deathPlayerCam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end


CreateThread(function()
    while true do
        Wait(1)
        if (not isDead and NetworkIsPlayerActive(PlayerId()) and IsPedFatallyInjured(PlayerPedId())) then
            isDead = true
            StartDeathCam()
        elseif (isDead == true and NetworkIsPlayerActive(PlayerId()) and not IsPedFatallyInjured(PlayerPedId())) then
            isDead = false
            EndDeathCam()
        end
        if (deathPlayerCam and isDead) then
            ProcessCamControls()
        else
            Wait(200)
        end
    end
end)

CreateThread(function()
    while Player:getPos() == nil do Wait(5) end
    print("RESULT", Player:getPos().x, Player:getPos().y, Player:getPos().z)
    local coords = Player:getPos()
    spawnPlayer({x = Player:getPos().x, y = Player:getPos().x, z = Player:getPos().z+50.0, model = GetHashKey("u_m_m_aldinapoli"), heading = 215.0}, false, function()
        LDC.loadSkin("First Spawn")
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(Player:Ped(), true, true)
        SwitchTrainTrack(0, true)
        SwitchTrainTrack(3, true)
        SetTrainTrackSpawnFrequency(0, 20000) -- default: 120000
        SetRandomTrains(true)
        ClearPlayerWantedLevel(PlayerId())
        SetMaxWantedLevel(0)
        DisplayRadar(true)
        local getGround, zGround = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, true, 0)
        if getGround then 
            SetEntityCoordsNoOffset(Player:Ped(), coords.x, coords.y, zGround + 1.0, 0.0, 0.0, 0.0) 
        end
    end)
end)

AddEventHandler("playerSpawned", function()
    while Player == nil do Wait(5) end
    while Player:getIdentity() == nil do Wait(1) end

    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(Player:Ped(), true, true)
    ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(0)
    DisplayRadar(true)
    
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
Player.HasPlayerLoaded = true;

