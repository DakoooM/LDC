RegisterCommand("coords", function(src, args)
    print(GetEntityCoords(Player:Ped()).." - Heading : "..GetEntityHeading(Player:Ped()))
end)

RegisterCommand("id", function(src, args)
    print("ID: " ..GetPlayerServerId(PlayerId()))
end)

RegisterCommand("tpm", function(src)
    if Player:getGroup() ~= nil then
        if Player:getGroup() == "sadmin" or Player:getGroup() == "admin" or Player:getGroup() == "dev" then 
            TeleportBlips()
        end
    end
end)

RegisterCommand("tpc", function(src, args)
    if Player:getGroup() ~= nil then
        if Player:getGroup() == "sadmin" or Player:getGroup() == "admin" or Player:getGroup() == "dev" then 
            if tonumber(args[1]) and tonumber(args[2]) and tonumber(args[3]) then
                SetEntityCoords(Player:Ped(), args[1], args[2], args[3], false, false, false, true)
            end
        end
    end
end)

RegisterCommand("car", function(source, args)
    if Player:getGroup() == "sadmin" or Player:getGroup() == "admin" or Player:getGroup() == "dev" then 
        local vehicleName = tostring(args[1])
        if vehicleName ~= nil then
            local myCoords, myHeading = Player:GetCoords(), GetEntityHeading(Player:Ped())
            local hashKey = GetHashKey(vehicleName)
            if IsModelInCdimage(hashKey) then
                LDC.SpawnVehicle(vehicleName, false, myCoords, myHeading, function(thisVehicle)
                    SetPedIntoVehicle(Player:Ped(), thisVehicle, -1)
                end)
            else
                print("^1Le véhicule demander n'existe pas^0")
            end
        else
            print("^1Veuillez remplir l'argument manquant^0")
        end
    end
end)

RegisterCommand("dv", function(source)
    if Player:getGroup() == "sadmin" or Player:getGroup() == "admin" or Player:getGroup() == "dev" then 
        if IsPedInAnyVehicle(Player:Ped(), false) then
            local myVehicle = LDC.get.getVehiclePedsIn()
            LDC.DeleteEntity(myVehicle)
        else         
            local closestVeh = LDC.get.getClosestVehicle(5.0)
            if (closestVeh ~= 0) then
                LDC.DeleteEntity(closestVeh)
            end
        end
    end
end)

RegisterCommand("noclip", function(source, args)
    if Player:getGroup() == "sadmin" or Player:getGroup() == "admin" or Player:getGroup() == "dev" then 
        NoClip()
    end
end)

----------------- A NE PAS TOUCHER ---------------------

--[[ local _barWidth = 0.180
local _barHeight = 0.045
local _barSpacing = 0

local _barProgressWidth = _barWidth / 2.65
local _barProgressHeight = _barHeight / 3.25

local _barTexture = 'all_black_bg'
local _barTextureDict = 'timerbars'

local Gui = {}

SafeZone = { }
SafeZone.__index = SafeZone

function SafeZone.Size()
	return GetSafeZoneSize()
end

function SafeZone.Left()
	return (1.0 - SafeZone.Size()) * 0.5
end

function SafeZone.Right()
	return 1.0 - SafeZone.Left()
end

SafeZone.Top = SafeZone.Left
SafeZone.Bottom = SafeZone.Right


function SetTextParams(font, color, scale, shadow, outline, center)
	SetTextFont(font)
	SetTextColour(color.r, color.g, color.b, color.a or 255)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropShadow()
	end

	if outline then
		SetTextOutline()
	end

	if center then
		SetTextCentre(true)
	end
end

local function AddText(text)
	local str = tostring(text)
	local strLen = string.len(str)
	local maxStrLength = 99

	for i = 1, strLen, maxStrLength + 1 do
		if i > strLen then
			return
		end

		AddTextComponentString(string.sub(str, i, i + maxStrLength))
	end
end

function DrawText(text, position, width)
	BeginTextCommandDisplayText('STRING')
	AddText(text)

	if width then
		SetTextRightJustify(true)
		SetTextWrap(position.x - width, position.x)
	end

	EndTextCommandDisplayText(position.x, position.y)
end

function Gui.DrawProgressBar(title, progress, barPosition, color)
	RequestStreamedTextureDict(_barTextureDict)
	if not HasStreamedTextureDictLoaded(_barTextureDict) then return end

	local x = SafeZone.Right() - _barWidth / 2
	local y = SafeZone.Bottom() - _barHeight / 2 - (barPosition - 1) * (_barHeight + _barSpacing)

	DrawSprite(_barTextureDict, _barTexture, x, y, _barWidth, _barHeight, 0.0, 255, 255, 255, 160)

	SetTextParams(0, {r = 255, g = 255, b = 255, a = 200}, 0.3, false, false, false)
	DrawText(title, { x = SafeZone.Right() - _barWidth / 2, y = y - 0.011 }, SafeZone.Size() - _barWidth / 2)

	local color = color or { r = 255, g = 255, b = 255 }
	local progressX = x + _barWidth / 2 - _barProgressWidth / 2 - 0.00285 * 2
	DrawRect(progressX, y, _barProgressWidth, _barProgressHeight, color.r, color.g, color.b, 60)

	local progress = math.max(0.0, math.min(1.0, progress))
	local progressWidth = _barProgressWidth * progress
	DrawRect(progressX - (_barProgressWidth - progressWidth) / 2, y, progressWidth, _barProgressHeight, color.r, color.g, color.b, 255)
end

RegisterCommand("progress", function()
    local healthProgress = 0.0;
    CreateThread(function()
        while true do
            Wait(0)
            if IsControlPressed(0, 38) then
                healthProgress = healthProgress+0.0010
            end
            if math.floor(healthProgress) < 1 then
                Gui.DrawProgressBar('COUCOU', healthProgress, 2, {r = 255, g = 0, b = 0, a = 100})
            end
        end
    end)
end) ]]