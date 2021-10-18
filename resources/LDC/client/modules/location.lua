local openlocation = false
local LocationInteractionMenu = RageUI.CreateMenu("Car Rentals", Config.ServerName)
LocationInteractionMenu.Closed = function()
    openlocation = false
    FreezeEntityPosition(Player:Ped(), false)
    DeleteVehicle(CacheLocation["CurrentVehicle"])
    DestroyCamera("LocationCam")
    -- LDC.DeleteCam(camera1, {Anim = true, AnimTime = 2000})
end

VehiclesL = {
    IndexPayment = 1,
    Location = {
        {model = "turismor", label = "Grotti Turismo R", price = 1450},
        {model = "manchez2", label = "Maibatsu Manchez Scout", price = 900}
    }
}

CacheLocation = {}

function CreateLocalLocationVehicle(Name, Vehicle)
	RequestModel(Vehicle)
	while not HasModelLoaded(Vehicle) do Wait(1) end
    CacheLocation[Name] = CreateVehicle(Vehicle, -50.18, -784.65, 44.18, 240.0, false, true)
	SetVehicleOnGroundProperly(CacheLocation[Name])
	FreezeEntityPosition(CacheLocation[Name], 1)
	SetModelAsNoLongerNeeded(CacheLocation[Name])
end

function CreateLocationVehicle(Vehicle, InVehicle)
	RequestModel(Vehicle)
	while not HasModelLoaded(Vehicle) do Wait(1) end
    CurrentVehicle = CreateVehicle(Vehicle, -50.18, -784.65, 44.18, 240.0, true, true)
	SetVehicleOnGroundProperly(CurrentVehicle)
	SetModelAsNoLongerNeeded(CurrentVehicle)
    if InVehicle then 
        SetPedIntoVehicle(Player:Ped(), CurrentVehicle, -1)
    end
end

function openLocationMenu()
    if openlocation == false then
        if openlocation then
            openlocation = false
            RageUI.Visible(LocationInteractionMenu, false)
        else
            cameraLocation = LDC.CreateCamera({ -39.81, -787.92, 47.50, -5.0, rotY = -20.0, heading = 73.0, fov = 40.0, AnimTime = 2000})
            FreezeEntityPosition(Player:Ped(), true)
            Wait(2200)
            Selected = false
            openlocation = true
            RageUI.Visible(LocationInteractionMenu, true)
            CreateThread(function()
                while openlocation do
                    RageUI.IsVisible(LocationInteractionMenu, function()
                        RageUI.List("Moyen de paiement :", Config.DefaultPayment, VehiclesL.IndexPayment, false, {}, true, {
                            onListChange = function(Index)
                                VehiclesL.IndexPayment = Index
                            end
                        })
                        for k,v in pairs (VehiclesL.Location) do 
                            RageUI.Button(v.label, "• Prix : ~g~"..v.price.."$", {RightLabel = "~b~Louer ~s~→"}, true, {
                                onActive = function()
                                    if Selected ~= v.model then 
                                        DeleteVehicle(CacheLocation["CurrentVehicle"])
                                        CreateLocalLocationVehicle("CurrentVehicle", v.model)  
                                    end
                                    Selected = v.model
                                end,
                                onSelected = function()
                                    if VehiclesL.IndexPayment == 1 then 
                                        if v.price >= Player:getMoney() then
                                            Visual.Popup({message="~r~Informations~s~\nVous n'avez pas assez d'argent"})
                                        else
                                            DeleteVehicle(CacheLocation["CurrentVehicle"])
                                            LDC.DeleteCam(cameraLocation, {Anim = true, AnimTime = 2000})
                                            FreezeEntityPosition(Player:Ped(), false)
                                            CreateLocationVehicle(v.model, true)
                                            TriggerServerEvent("aFrw:BuyLocationVehicle", v.price, 1)
                                            openlocation = false                                
                                        end   
                                    end
                                    if VehiclesL.IndexPayment == 2 then 
                                        if v.price >= Player:getBankMoney() and VehiclesL.IndexPayment == 2 then
                                            Visual.Popup({message="~r~Informations~s~\nVous n'avez pas assez d'argent sur votre compte"})
                                        else
                                            DeleteVehicle(CacheLocation["CurrentVehicle"])
                                            LDC.DeleteCam(cameraLocation, {Anim = true, AnimTime = 2000})
                                            FreezeEntityPosition(Player:Ped(), false)
                                            CreateLocationVehicle(v.model, true)
                                            TriggerServerEvent("aFrw:BuyLocationVehicle", v.price, 2)
                                            openlocation = false      
                                        end
                                    end
                                end                                                                                          
                            })
                        end
                    end)
                    Wait(1)
                end
            end)
        end
    end
end