local opengarage = false
local GarageMenu = RageUI.CreateMenu("Garage", Config.ServerName)
local GarageSubMyCars = RageUI.CreateSubMenu(GarageMenu, "Garage", "~b~Mes Véhicules")
local GarageSubOption = RageUI.CreateSubMenu(GarageSubMyCars, "Garage", "~b~Mes Véhicules")

GarageMenu.Closed = function()
    opengarage = false
    FreezeEntityPosition(Player:Ped(), false)
end

local Garage = {}
local VehTab = {}
local vehSelected = {}

local refreshVehicle = function(typeMan, cb)
    TriggerServerCallback(Config.ServerName.. "GetOwnVehicle", function(actualData) 
        if typeMan == "refresh" then
            VehTab = {}
            VehTab = actualData
        elseif typeMan == "animation" then
            if (cb) then 
                cb(actualData)
            end
        end
    end, {type = typeMan})
end

function openGarageMenu(pos)
    if opengarage == false then
        if opengarage then
            opengarage = false
            RageUI.Visible(GarageMenu, false)
        else
            opengarage = true
            RageUI.Visible(GarageMenu, true)
            FreezeEntityPosition(Player:Ped(), true)
            CreateThread(function()
                while opengarage do
                    RageUI.IsVisible(GarageMenu, function()
                        RageUI.Button("Mes Véhicules", false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                refreshVehicle("refresh")
                            end
                        }, GarageSubMyCars)
                    end)

                    RageUI.IsVisible(GarageSubMyCars, function()
                        if #VehTab > 0 then
                            for index, vehicles in pairs (VehTab) do
                                local itm = vehicles
                                local vehlbl = GetLabelText(GetDisplayNameFromVehicleModel(itm.model))
                                local vehplace = GetVehicleModelNumberOfSeats(itm.model)

                                state = ""
                                if itm.parked == "1" or itm.parked == 1 then state = "~g~Rentrer" else state = "~r~Sortie" end
                                if itm.label == "NULL" or itm.label == NULL or itm.label == vehlbl then itm.label = vehlbl else itm.label = itm.label end

                                RageUI.Button(itm.label.." (~b~"..itm.plate.."~s~)", "Nombre de place : "..vehplace.."\nVéhicule : "..vehlbl, {RightLabel = state}, true, {
                                    onSelected = function()
                                        vehSelected = itm
                                    end
                                }, GarageSubOption)
                            end
                        else
                            RageUI.Separator("~r~Vous n'avez pas de véhicule")
                        end
                    end)

                    RageUI.IsVisible(GarageSubOption, function()
                        RageUI.Separator(vehSelected.label)
                        if vehSelected.parked == 1 then 
                            RageUI.Button("Sortir le véhicule", false, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    LDC.SpawnVehicle(vehSelected.model, false, vector3(pos[1], pos[2], pos[3]), pos[4], function(vehicle)
                                        SetVehicleUndriveable(vehicle, false)
                                        SetVehicleNumberPlateText(vehicle, vehSelected.plate)
                                        TriggerServerEvent("aFrw:SetParked", vehSelected.plate, 0)
                                        FreezeEntityPosition(Player:Ped(), false)
                                        Visual.Popup({message = "~g~<C>Succès</C>\n~s~Vous avez sortie ~c~" ..vehSelected.label.. "~s~ de votre garage"})
                                    end)
                                    RageUI.CloseAll()
                                    opengarage = false
                                end
                            })
                        else 
                            RageUI.Button("Sortir le véhicule", false, {RightLabel = "→"}, false, {})
                        end
                    end)

                    Wait(1)
                end
            end)
        end
    end
end

function ParkedGarage()
    if #VehTab > 0 then
        for i = 1 , #VehTab,1 do
            vehlabel = GetLabelText(GetDisplayNameFromVehicleModel(VehTab[i].model))
        end
    end
    if LDC.get.getVehiclePedsIn() ~= 0 then
        TriggerServerCallback(Config.ServerName.. "GetOwnVehicle", function(vehicles)
            vehicleowner = false
            for k,v in pairs(vehicles) do
                if GetVehicleNumberPlateText(LDC.get.getVehiclePedsIn()) == v.plate then
                    vehicleowner = true
                end
            end
            if (vehicleowner) then
                local hash = GetHashKey(vehicles.model)
                if (GetVehicleBodyHealth(GetVehiclePedIsIn(Player:Ped()), false) >= 800) then
                    TriggerServerEvent("aFrw:SetParked", GetVehicleNumberPlateText(LDC.get.getVehiclePedsIn()), tonumber(1))
                    LDC.DeleteEntity(LDC.get.getVehiclePedsIn())
                    for k,v in pairs(vehicles) do platevehicle = v.plate end
                    Visual.Popup({message = "Vous avez rentré~s~\n~y~Véhicule~s~ : ~b~"..vehlabel.."~s~\n~g~Plaque~s~ : "..platevehicle})
                else
                    Visual.Popup({message = "~r~Le véhicule est trop casser pour pouvoir le rentrez~s~"})
                end
            else 
                Visual.Popup({message = "~r~Ce véhicule ne vous appartient pas !~s~"})
            end
        end)
    end
end

local exitVehicleName, exitVehiclePlate, exitVehicleModel = "", "", "";
local showNoVehicleInPound, PoundOpened = false, false;
local cameraForPound = nil;
local PoundMenu = RageUI.CreateMenu("Fourrière", Config.ServerName.. " - Fourrière Public")
PoundMenu:SetRectangleBanner(235, 134, 52, 70)
PoundMenu.Closed = function()
    PoundOpened = false;
    LDC.DeleteCam(cameraForPound, {Anim = true, AnimTime = 1200})
end

local exitMainMenuPound = RageUI.CreateSubMenu(PoundMenu, "Fourrière", Config.ServerName.. " Fourrière - Sortir votre véhicule");
exitMainMenuPound:SetRectangleBanner(235, 134, 52, 70);

function spawnVehicleWithAnimation(var, spawnVehicle)
    if #exitVehicleModel > 0 then
        local xSpawn, ySpawn, zSpawn, vehicleModel = var.spawnPoint[1], var.spawnPoint[2], var.spawnPoint[3], GetHashKey(exitVehicleModel:lower());
        RageUI.CloseAll()
        PoundOpened = false;
        SetPlayerControl(PlayerId(), false, 12)
        LDC.SpawnVehicle(spawnVehicle, false, vector3(xSpawn, ySpawn, zSpawn), var.headingSpawn, function(thisVehicle)
            SetEntityHeading(thisVehicle, var.headingSpawn)
            LDC.SpawnPed("s_m_y_xmech_02", {x = xSpawn, y = ySpawn, z = zSpawn, heading = 321.9521}, function(callped)
                SetPedIntoVehicle(callped, thisVehicle, -1)
                TaskVehicleDriveToCoord(callped, thisVehicle, var.DriveToCoords[1], var.DriveToCoords[2], var.DriveToCoords[3], 5.0, 0.0, GetEntityModel(thisVehicle), 262144, 0.1, 1000.0);
                local enable = true;
                CreateThread(function()
                    while enable do 
                        Wait(100)
                        local pedCoords = GetEntityCoords(callped);
                        if #(pedCoords - vector3(var.DriveToCoords[1], var.DriveToCoords[2], var.DriveToCoords[3])) < 1.7 then
                            TaskLeaveVehicle(callped, thisVehicle, 0)
                            Wait(2500)
                            LDC.DeleteEntity(callped)
                            LDC.DeleteCam(cameraForPound, {Anim = true, AnimTime = 1200})
                            SetPlayerControl(PlayerId(), true, 12)
                            enable = false;
                            break
                        end
                    end
                end)
            end)
        end)
    else
        print("^1ERROR [spawnVehicleWithAnimation]:^0 vehicle model is not valid")
    end
end

function openPound(setting)
    if PoundOpened == false then
        if PoundOpened then
            PoundOpened = false
        else
            RageUI.Visible(PoundMenu, true)
            PoundOpened = true
            refreshVehicle("refresh")
            cameraForPound = LDC.CreateCamera({404.4324, -1617.005, 32.29196, rotY = -20.0, heading = 103.9367, fov = 40.0, AnimTime = 1200})
            CreateThread(function()
                while PoundOpened do
                    Wait(0)
                    RageUI.IsVisible(PoundMenu, function()
                    if (#VehTab > 0) then
                            for none, keys in pairs (VehTab) do
                                if keys.parked == 0 then
                                    showNoVehicleInPound = false;
                                    local nameVehicle = GetLabelText(GetDisplayNameFromVehicleModel(keys.model))
                                    RageUI.Button(nameVehicle, "Plaque du véhicule: [~o~" ..tostring(keys.plate).. "~s~]\nPrix de sortie: ~g~$" ..tostring(setting.price).. "~s~", {RightLabel = "~g~$" ..tostring(setting.price).. "~s~"}, true, {
                                        onSelected = function()
                                            exitVehicleName = GetLabelText(GetDisplayNameFromVehicleModel(keys.model))
                                            exitVehiclePlate = keys.plate
                                            exitVehicleModel = keys.model
                                        end
                                    }, exitMainMenuPound)
                                else
                                    showNoVehicleInPound = true;
                                end
                            end
                        end
                        if showNoVehicleInPound == true then
                            RageUI.Separator()
                            RageUI.Separator("~o~Vous n'avez Aucun véhicule en fourrière")
                            RageUI.Separator()
                        end
                    end)
                    RageUI.IsVisible(exitMainMenuPound, function()
                        RageUI.Separator(exitVehicleName.. " - [" ..tostring(exitVehiclePlate).. "]")
                        RageUI.Button("Sortir " ..exitVehicleName.. " pour ~g~" ..tostring(setting.price).. "$~s~", nil, {}, true, {
                            onSelected = function()
                                if Player:getMoney() >= setting.price then
                                    spawnVehicleWithAnimation(setting, exitVehicleModel)
                                    TriggerServerEvent(Config.ServerName.. "actionsPound", {
                                        plate = tostring(exitVehiclePlate),
                                        money = setting.price,
                                        coords = vector3(setting.spawnPoint[1], setting.spawnPoint[2], setting.spawnPoint[3])
                                    })
                                else
                                    Visual.Popup({message = "~r~Vous n'avez pas assez d'argent~s~"})
                                end
                            end
                        })
                    end)
                end
            end)
        end
    end
end