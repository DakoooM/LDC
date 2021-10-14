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

local Vehicle_RefreshTable = function()
    TriggerServerCallback("aFrw:GetOwnVehicle", function(data) 
        VehTab = {}
        VehTab = data
    end)
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
                                Vehicle_RefreshTable()
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
        TriggerServerCallback("aFrw:GetOwnVehicle", function(vehicles)
            vehicleowner = false
            for k,v in pairs(vehicles) do
                if GetVehicleNumberPlateText(GetVehiclePedIsIn(Player:Ped(), true)) == v.plate then
                    vehicleowner = true
                end
            end
            if (vehicleowner) then
                local hash = GetHashKey(vehicles.model)
                if (GetVehicleBodyHealth(GetVehiclePedIsIn(Player:Ped()), false) >= 800) then
                    TriggerServerEvent("aFrw:SetParked", GetVehicleNumberPlateText(GetVehiclePedIsIn(Player:Ped(), true)), tonumber(1))
                    Cars:DeleteVeh(Cars:GetVehiclePedIsIn())
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
local PoundMenu = RageUI.CreateMenu("Fourrière", Config.ServerName.. " - Fourrière Public")
PoundMenu:SetRectangleBanner(235, 134, 52, 70)
PoundMenu.Closed = function()
    PoundOpened = false;
end

local exitMainMenuPound = RageUI.CreateSubMenu(PoundMenu, "Fourrière", Config.ServerName.. " Fourrière - Sortir votre véhicule");
exitMainMenuPound:SetRectangleBanner(235, 134, 52, 70);

function spawnVehicleWithAnimation(var)
    if #exitVehicleModel > 0 then
        print("MODEL THIS: ", exitVehicleModel)
        local xSpawn, ySpawn, zSpawn = var.SpawnPoint[1], var.SpawnPoint[2], var.SpawnPoint[3];
        local vehicle = Cars.CreateCar(GetHashKey(exitVehicleModel:lower()), {xSpawn, ySpawn, zSpawn, 40.0}, false)
        if (vehicle.exist) then
            CreatePedOnPos("pedForPound", "s_m_y_xmech_02", xSpawn, ySpawn, zSpawn, 321.952148, nil, function(pedSpawned)
            end)
            TaskVehicleDriveToCoord(pedvehlocc, vehloca, var.DriveToCoords[1], var.DriveToCoords[2], var.DriveToCoords[3], 8.0, 0, GetEntityModel(vehloca), 411, 10.0)
            Wait(var.Waitaftervehtocoord)
        end
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
            Vehicle_RefreshTable()
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
                                spawnVehicleWithAnimation(setting)
                            end
                        })
                        RageUI.Button("Retour", nil, {Color = {HightLightColor = {155, 0, 0, 160}, BackgroundColor = {97, 28, 7, 160}}}, true, {
                            onSelected = function()
                                RageUI.GoBack()
                            end
                        })
                    end)
                end
            end)
        end
    end
end