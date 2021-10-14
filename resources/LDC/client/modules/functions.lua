LDC = {
    get = {
        -- LDC.get.getClosestVehicle(2.0)
        getClosestVehicle = function(radius)
            return GetClosestVehicle(Player:GetCoords().x, Player:GetCoords().y, Player:GetCoords().z, radius, 0, 71)
        end,
        -- LDC.get.getVehiclePedsIn()
        getVehiclePedsIn = function()
            return GetVehiclePedIsIn(Player:Ped(), false)
        end
    }
}
LDC = _G.LDC

-- LDC.CreateCamera({20.0, 20.0, 110.0, rotY = -40.0, heading = 10.0, fov = 50.0, AnimTime = 4500})
LDC.CreateCamera = function(var)
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
	SetCamActive(cam, true)
	SetCamParams(cam, var[1] or 10.0, var[2] or 10.0, var[3] or 10.0, var.rotY or 1.0, 0.0, var.heading or 200.0, 42.24, 0, 1, 1, 2)
	SetCamCoord(cam, var[1], var[2], var[3])
	SetCamFov(cam, var.fov or 40.0)
	RenderScriptCams(true, var.Anim or true, var.AnimTime or 0, true, true)
    if (call) then
        call(cam)
    else
        return cam
    end
end


-- LDC.DeleteCam(camera1, {Anim = true, AnimTime = 2000})
LDC.DeleteCam = function(name, var)
	if DoesCamExist(name) then
		SetCamActive(name, false)
		DestroyCam(name, false, false)
		RenderScriptCams(false, var.Anim or true, var.AnimTime or 0, false, false)
	else
		print("ERROR - LA CAM N'EXISTE PAS " ..tostring(name))
	end
end

LDC.RequestModel = function(entity)
	local EntityHash = GetHashKey(entity)
	RequestModel(EntityHash)
	while not HasModelLoaded(EntityHash) do 
		RequestModel(EntityHash)
		Wait(5) 
	end
end

LDC.DeleteEntity = function(entity)
	SetEntityAsMissionEntity(entity, false, true)
	SetModelAsNoLongerNeeded(entity)
	DeleteEntity(entity)
end

-- LDC.SpawnVehicle("adder", false, vector3(0.0, 0.0, 0.0), function(thisVehicle)
-- SetPedIntoVehicle(Player:Ped(), thisVehicle, -1)
-- end)
LDC.SpawnVehicle = function(vehiclename, Local, coords, heading, Callback)
	CreateThread(function()
		LDC.RequestModel(vehiclename)
		local LDCVeh = CreateVehicle(GetHashKey(vehiclename), coords, coords, coords, heading, Local, false)
		local networkId = NetworkGetNetworkIdFromEntity(LDCVeh)

		if Local ~= true then
			SetNetworkIdCanMigrate(networkId, true)
			SetEntityAsMissionEntity(LDCVeh, true, false)
			SetVehicleHasBeenOwnedByPlayer(LDCVeh, true)
			SetVehicleNeedsToBeHotwired(LDCVeh, false)
			RequestCollisionAtCoord(coords, coords, coords)
			SetVehRadioStation(LDCVeh, 'OFF')
			SetModelAsNoLongerNeeded(LDCVeh)
		else
			SetEntityAsMissionEntity(LDCVeh, true, false)
			SetVehicleHasBeenOwnedByPlayer(LDCVeh, true)
			SetVehicleNeedsToBeHotwired(LDCVeh, false)
			SetVehRadioStation(LDCVeh, 'OFF')
			SetModelAsNoLongerNeeded(LDCVeh)
			RequestCollisionAtCoord(coords, coords, coords)
		end

		if (Callback) then
			Callback(LDCVeh)
		end
	end)
end

LDC.SpawnPed = function(pedname, localped, coords, heading, Callback)
	CreateThread(function()
		LDC.RequestModel(pedname)
		local LDCPed = CreatePed(4, GetHashKey(pedname), coords, coords, coords-1, heading, localped, true)
		if (Callback) then
			Callback(LDCPed)
		end
	end)
end

LDC.setPlayerModel = function(skin)
	local model = GetHashKey(skin)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(Player:Ped())
        if skin == 'mp_m_freemode_01' then
            SetPedComponentVariation(Player:Ped(), 3, 15, 0, 2) -- arms
            SetPedComponentVariation(Player:Ped(), 11, 15, 0, 2) -- torso
            SetPedComponentVariation(Player:Ped(), 8, 15, 0, 2) -- tshirt
            SetPedComponentVariation(Player:Ped(), 4, 61, 1, 2) -- pants
            SetPedComponentVariation(Player:Ped(), 6, 34, 0, 2) -- shoes
        elseif skin == 'mp_f_freemode_01' then
            SetPedComponentVariation(Player:Ped(), 3, 15, 0, 2) -- arms
            SetPedComponentVariation(Player:Ped(), 11, 15, 0, 2) -- torso
            SetPedComponentVariation(Player:Ped(), 8, 15, 0, 2) -- tshirt
            SetPedComponentVariation(Player:Ped(), 4, 15, 0, 2) -- pants
            SetPedComponentVariation(Player:Ped(), 6, 35, 0, 2) -- shoe
        end
        SetModelAsNoLongerNeeded(model)
    end
end

DrawAdvancedText = function(x,y ,w,h,sc, text,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    SetTextJustification(jus)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end

KeyboardInput = function(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Wait(0) end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

TeleportBlips = function()
    local entity = Player:Ped()
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    local success = false
    local blipFound = false
    local blipIterator = GetBlipInfoIdIterator()
    local blip = GetFirstBlipInfoId(8)
    while DoesBlipExist(blip) do
        if GetBlipInfoIdType(blip) == 4 then
            cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector()))
            blipFound = true
            break
        end
        blip = GetNextBlipInfoId(blipIterator)
        Wait(0)
    end
    if blipFound then
        local groundFound = false
        local yaw = GetEntityHeading(entity)
        for i = 0, 1000, 1 do
            SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
            SetEntityRotation(entity, 0, 0, 0, 0, 0)
            SetEntityHeading(entity, yaw)
            Wait(0)
            if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then
                cz = ToFloat(i)
                groundFound = true
                break
            end
        end
        if not groundFound then
            cz = -300.0
        end
        success = true
    else
        Visual.Popup({message= "~r~Aucun point sur la carte"})
    end
    if success then
        Visual.Popup({message= "~g~Téléporté sur le marqueur"})
        SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
        if IsPedSittingInAnyVehicle(Player:Ped()) then
            if GetPedInVehicleSeat(GetVehiclePedIsUsing(Player:Ped()), -1) == Player:Ped() then
                SetVehicleOnGroundProperly(GetVehiclePedIsUsing(Player:Ped()))
            end
        end
    end
end

function corePrint(string)
    print("^3Core:^7 "..string)
end

ServerCallbacks           = {}
CurrentRequestId          = 0

TriggerServerCallback = function(name, Callback, ...)
	ServerCallbacks[CurrentRequestId] = Callback
	TriggerServerEvent("aFrw:CallbackTrigger", name, CurrentRequestId, ...)
	if CurrentRequestId < 65535 then
		CurrentRequestId = CurrentRequestId + 1
	else
		CurrentRequestId = 0
	end
end

RegisterNetEvent("aFrw:serverCallback")
AddEventHandler("aFrw:serverCallback", function(requestId, ...)
	ServerCallbacks[requestId](...)
	ServerCallbacks[requestId] = nil
end)

local noClip = false
local NoClipSpeed = 0.5
function NoClip()
    NoClipSpeed = 0.5
    noClip = not noClip
    if noClip then    
        CreateThread(function()
            while noClip do 
                Wait(1)
                local pCoords = GetEntityCoords(Player:Ped(), false)
                local camCoords = getCamDirection()
                SetEntityVelocity(Player:Ped(), 0.01, 0.01, 0.01)
                SetEntityCollision(Player:Ped(), 0, 1)
                FreezeEntityPosition(Player:Ped(), true)
                if IsControlPressed(0, 32) then
                    pCoords = pCoords + (NoClipSpeed * camCoords)
                end
                if IsControlPressed(0, 269) then
                    pCoords = pCoords - (NoClipSpeed * camCoords)
                end
                if IsDisabledControlJustPressed(1, 15) then
                    NoClipSpeed = NoClipSpeed + 0.3
                end
                if IsDisabledControlJustPressed(1, 14) then
                    NoClipSpeed = NoClipSpeed - 0.3
                    if NoClipSpeed < 0 then
                        NoClipSpeed = 0
                    end
                end
                SetEntityCoordsNoOffset(Player:Ped(), pCoords, true, true, true)
                SetEntityVisible(Player:Ped(), 0, 0)      
            end
            FreezeEntityPosition(Player:Ped(), false)
            SetEntityVisible(Player:Ped(), 1, 0)
            SetEntityCollision(Player:Ped(), 1, 1)
        end)
    end
end

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(Player:Ped())
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))
	if len ~= 0 then
		coords = coords / len
	end
	return coords
end

RegisterNetEvent("aFrw:ShowYourIDCardForPlayer")
AddEventHandler("aFrw:ShowYourIDCardForPlayer", function(Identity)
    IsOpenIdentity = not IsOpenIdentity
    CreateThread(function()
        while IsOpenIdentity do
            Wait(0)
            DrawRect(0.85, 0.50, 0.2400, 0.270, 0, 0, 0, 155)
            DrawAdvancedText(0.890, 0.388, 0.005, 0.005, 0.9, "Pièce d'identité", 6, 0) 
            DrawAdvancedText(0.876, 0.440, 0.005, 0.005, 0.64, "~y~"..Identity.firstname.." "..Identity.lastname, 6, 0) 
            DrawAdvancedText(0.834, 0.500, 0.005, 0.0028, 0.46, "Date de naissance", 6, 1)
            DrawAdvancedText(0.940, 0.500, 0.005, 0.0028, 0.46, "Taille", 6, 1)
            DrawAdvancedText(0.834, 0.530, 0.005, 0.0028, 0.35, "~b~"..Identity.ddn, 6, 1)
            DrawAdvancedText(0.940, 0.530, 0.005, 0.0028, 0.35, "~b~"..Identity.height.."cm", 6, 1)
            DrawAdvancedText(0.990, 0.625, 0.005, 0.0028, 0.33, "Expiration - Février 2024", 6, 1)      
            if IsControlJustPressed(0, 73) then
                IsOpenIdentity = false
                break;
            end
        end
    end)
end)

function FixPlayer()
    if FixPlayerActions then
        Controls1, Controls2 = IsDisabledControlPressed(1, 108), IsDisabledControlPressed(1, 109)
        if Controls1 or Controls2 then
            Ped = Player:Ped()
            SetEntityHeading(Player:Ped(), Controls1 and GetEntityHeading(Ped) - 1.0 or Controls2 and GetEntityHeading(Ped) + 1.0)
        end
    end
end

function LoadCharCreatorClothes(CurrentClothes)
    if CurrentClothes == 1 then 
        SetPedComponentVariation(Player:Ped(), 11, 111, 3) 
        SetPedComponentVariation(Player:Ped(), 8, 15, 0) 
        SetPedComponentVariation(Player:Ped(), 3, 12, 0)
        SetPedComponentVariation(Player:Ped(), 4, 24, 0) 
        SetPedComponentVariation(Player:Ped(), 6, 10, 0) 
        CharacterClothes = {
            torso = 111,
            torso2 = 3,
            tshirts = 15,
            tshirts2 = 0,
            arms = 12,
            pants = 24,
            pants2 = 0,
            shoes = 10,
            shoes2 = 0
        }
    end
end

function LoadSkin()
    if (Player:getSkin() ~= nil) then 
        if Player:getSkin().sex == 1 then 
            LDC.setPlayerModel("mp_m_freemode_01")
        else
            LDC.setPlayerModel("mp_f_freemode_01")
        end
        Wait(250)
        SetPedHeadBlendData(Player:Ped(), Player:getSkin().mom, Player:getSkin().dad, nil, Player:getSkin().mom, Player:getSkin().dad, nil, Player:getSkin().resem, Player:getSkin().face, nil, true)
        SetPedEyeColor(Player:Ped(), Player:getSkin().eyesColor, 0, 1)
        SetPedComponentVariation(Player:Ped(), 2, Player:getSkin().hair, 1)
        SetPedHairColor(Player:Ped(), Player:getSkin().hairColor, Player:getSkin().hairColor)
        SetPedHeadOverlay(Player:Ped(), 1, Player:getSkin().beard, 1.0)
        SetPedHeadOverlayColor(Player:Ped(), 1, 1, Player:getSkin().beardColor, Player:getSkin().beardColor)
        SetPedHeadOverlay(Player:Ped(), 2, Player:getSkin().eyesbrow, 1.0)
        SetPedHeadOverlayColor(Player:Ped(), 2, 1, Player:getSkin().eyesbrowColor, Player:getSkin().eyesbrowColor)
        SetPedHeadOverlay(Player:Ped(), 3, Player:getSkin().ageing, 1.0)
        SetPedHeadOverlay(Player:Ped(), 11, Player:getSkin().blemishes, 1.0)
        SetPedHeadOverlay(Player:Ped(), 4, Player:getSkin().makeup, 1.0)
        SetPedHeadOverlay(Player:Ped(), 8, Player:getSkin().lipstick, 1.0)
        SetPedHeadOverlayColor(Player:Ped(), 8, 2, Player:getSkin().lipstickColor, Player:getSkin().lipstickColor)
        SetPedHeadOverlay(Player:Ped(), 7, Player:getSkin().sundamage, 1.0)
        if Player:getClothes() ~= nil then 
            if Player:getClothes().torso ~= nil then 
                SetPedComponentVariation(Player:Ped(), 11, Player:getClothes().torso, Player:getClothes().torso2 or 0) 
                SetPedComponentVariation(Player:Ped(), 8, Player:getClothes().tshirts, Player:getClothes().tshirts2 or 0) 
                SetPedComponentVariation(Player:Ped(), 3, Player:getClothes().arms, 0)
            end
            if Player:getClothes().pants ~= nil then 
                SetPedComponentVariation(Player:Ped(), 4, Player:getClothes().pants, Player:getClothes().pants2 or 0) 
            end
            if Player:getClothes().shoes ~= nil then 
                SetPedComponentVariation(Player:Ped(), 6, Player:getClothes().shoes, Player:getClothes().shoes2) 
            end
        end
    end
end

-- GET CLOSEST PED 
GetPlayers = function()
	local players = {}

	for _,i in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(i)

		if DoesEntityExist(ped) then
			table.insert(players, i)
		end
	end

	return players
end

GetClosestPlayer = function(coords)
	local players         = GetPlayers()
	local closestDistance = -1
	local closestPlayer   = -1
	local coords          = coords
	local usePlayerPed    = false
	local playerPed       = Player:Ped()
	local playerId        = PlayerId()

	if coords == nil then
		usePlayerPed = true
		coords       = GetEntityCoords(playerPed)
	end

	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
			local targetCoords = GetEntityCoords(target)
			local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer   = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

AddEventHandler("playerSpawned", function()
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(Player:Ped(), true, true)
end)

function destorycam()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
end