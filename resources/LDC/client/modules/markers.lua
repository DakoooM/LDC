local openmarker = false

Keys.Register("TAB", "TAB", "Delete weapon from hands player", function()
    for i=1,4 do 
        if IsPedArmed(Player:Ped(), i) and CurrentWeapon ~= nil then 
            RemoveWeaponFromPed(Player:Ped(), GetHashKey(CurrentWeapon))
        end
    end
end)

function CreatePedOnPos(name, ped, x,y,z, heading, scenario, call)
    name = name or ""
    local hash = GetHashKey(ped)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(5) RequestModel(hash) end
    local ped = CreatePed(1, ped, x, y, z, heading, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true) 
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true) 
    print("ped (" ..tostring(name).. ") has loaded")
    if (scenario) then 
        TaskStartScenarioInPlace(ped, scenario, 0, false)
    end
    if (call) then
        call(ped)
    end
end

function CreateCamOnPos(Name, Position1, Position2, FOV, Focus, Time)
    Name = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamActive(Name, true)
    SetCamCoord(Name, Position1)
    SetCamFov(Name, FOV)
    PointCamAtCoord(Name, Position2)
    if Focus then 
        SetFocusPosAndVel(Position2, 0.0, 0.0, 0.0)
    end
    RenderScriptCams(1, 1, Time, 1, 1)
end

function LDC.addBlip(setting)
    local blip = AddBlipForCoord(setting.position or vector3(0.0, 0.0, 0.0))
    SetBlipSprite(blip, setting.sprite or 1)
    SetBlipDisplay(blip, setting.display or 4)
    SetBlipScale(blip, setting.scale or 0.6)
    SetBlipColour(blip, setting.color or 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(setting.name or "NULL" ..tostring(setting.position))
    EndTextCommandSetBlipName(blip)
    if (call) then
        call(blip)
    end
end

function DestroyCamera(Name)
    DestroyCam(Name, false)
    RenderScriptCams(false, true, 1500, false, false)
end

CreateThread(function()
    while true do 
        pos = GetEntityCoords(PlayerPedId())
        speed = math.floor(GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6 + 0.5)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then 
            Wait(1)
            LDC.showText({
                shadow = true,  
                size = 0.65,
                msg = "~b~"..GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)))), posx = 0.17, posy = 0.81
            })
        if speed > 150 then
            LDC.showText({
                shadow = true,
                size = 0.65, 
                msg = "~r~"..speed.."~s~km/h", posx = 0.17, posy = 0.85
            })
        elseif speed > 120 then
            LDC.showText({
                shadow = true,  
                size = 0.65,
                msg = "~o~"..speed.."~s~km/h", posx = 0.17, posy = 0.85
            })
        elseif speed > 60 then
            LDC.showText({
                shadow = true,  
                size = 0.65,
                msg = "~y~"..speed.."~s~km/h", posx = 0.17, posy = 0.85
            })
        elseif speed < 60 then
            LDC.showText({
                shadow = true,  
                size = 0.65,
                msg = "~g~"..speed.."~s~km/h", posx = 0.17, posy = 0.85
            })
        end
            LDC.showText({
                shadow = true,  
                size = 0.65,
                msg = "~g~"..GetStreetNameFromHashKey(GetStreetNameAtCoord(pos.x, pos.y, pos.z)), posx = 0.17, posy = 0.89
            })
        else
            Wait(800)
        end
    end
end)

CreateThread(function()
    -- Ped(s) on pos
    CreatePedOnPos("LocationVehiclePed", "csb_miguelmadrazo", -45.46, -791.15, 43.24, 130.0, false)
    CreatePedOnPos("CardealerPed", "ig_car3guy2", -42.65, -1092.38, 25.42, 163.0, false)

    -- end of Ped(s) on pos
    -- Blip(s) on pos
    for _, locveh in pairs(Config.LocationPos) do    
        LDC.addBlip({
            position = locveh.pos,
            sprite = 1,
            scale = 0.7,
            color = 2,
            name = "Location de véhicule(s)"
        })
    end
    for _, makeup in pairs(Config.MakeupPos) do    
        LDC.addBlip({
            position = makeup.pos,
            sprite = 304,
            scale = 0.7,
            color = 8,
            name = "Institut de beauté"
        })
    end
    for _, surgery in pairs(Config.SurgeryPos) do    
        LDC.addBlip({
            position = surgery.pos,
            sprite = 498,
            scale = 0.7,
            color = 47,
            name = "Chirurgie"
        })
    end
    for _, carwash in pairs(Config.CarWashPos) do    
        LDC.addBlip({
            position = carwash.pos,
            sprite = 100,
            scale = 0.7,
            color = 18,
            name = "CarWash"
        })
    end
    for _, cardealer in pairs(Config.CardealerPos) do    
        LDC.addBlip({
            position = cardealer.pos,
            sprite = 734,
            scale = 0.7,
            color = 0,
            name = "Concessionnaire"
        })
    end
    for _, garage in pairs(Config.GaragePos) do    
        LDC.addBlip({
            position = garage.pos,
            sprite = 357,
            scale = 0.7,
            color = 3,
            name = "Garage"
        })
    end
    for _, pound in pairs(Config.PoundPos) do    
        LDC.addBlip({
            position = pound.position,
            sprite = 643,
            scale = 0.7,
            color = 17,
            name = "Fourrière"
        })
    end
    -- end of Blip(s) on pos
    -- Marker(s) on pos
    while true do
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        BlockWeaponWheelThisFrame()
        SetPedCanSwitchWeapon(PlayerPedId(), false)
        local pCoords = GetEntityCoords(Player:Ped())
        local spam = false
        for _, v in pairs(Config.PoundPos) do 
            if #(pCoords - v.position) < 10.0 then
                spam = true;
                DrawMarker(36, v.position, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 0, 100, 255, 120, 1, 0, 0, 2)
            end
            if #(pCoords - v.position) < 1.2 then
                spam = true;
                Visual.Subtitle("Appuyer sur [~b~E~s~] pour accéder à la fourrière")
                if IsControlJustPressed(1, 51) then
                    openPound({
                        price = v.price
                    })
                end               
            end
        end
        for _,v in pairs(Config.LocationPos) do
            if #(pCoords - v.pos) < 1.5 then
                spam = true
                DrawMarker(32, v.pos, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 0, 100, 255, 120, 1, 0, 0, 2)
                Visual.Subtitle("Appuyer sur [~b~E~s~] pour accéder à la : ~b~location")
                if IsControlJustPressed(1, 51) then
                    openLocationMenu()
                end                                
            elseif #(pCoords - v.pos) < 1.6 then
                spam = false
                openmarker = false
            end
        end
        for _,v in pairs(Config.MakeupPos) do             
            if #(pCoords - v.pos) < 1.2 then
                spam = true
                DrawMarker(2, v.pos, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 0, 100, 255, 120, 1, 0, 0, 2)
                Visual.Subtitle("Appuyer sur [~b~E~s~] pour accéder à ~b~l'Institut")
                if IsControlJustPressed(1, 51) then
                    InstitutMenu:SetTitle(v.label)
                    OpenInstitutMenu()
                end                                
            elseif #(pCoords - v.pos) < 1.3 then
                spam = false
                openmarker = false
            end      
        end
        for _,v in pairs(Config.SurgeryPos) do             
            if #(pCoords - v.pos) < 1.2 then
                spam = true
                DrawMarker(2, v.pos, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 0, 100, 255, 120, 1, 0, 0, 2)
                Visual.Subtitle("Appuyer sur [~b~E~s~] pour accéder à ~b~la chirurgie")
                if IsControlJustPressed(1, 51) then
                    SurgeryMenu:SetTitle(v.label)
                    OpenSurgeryMenu()
                end                                
            elseif #(pCoords - v.pos) < 1.3 then
                spam = false
                openmarker = false
            end      
        end
        for _,v in pairs(Config.CardealerPos) do
            if #(pCoords - v.pos) < 1.6 then
                spam = true
                DrawMarker(32, v.pos, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 0, 100, 255, 120, 1, 0, 0, 2)
                Visual.Subtitle("Appuyer sur [~b~E~s~] pour accéder au ~b~Concessionnaire")
                if IsControlJustPressed(1, 51) then
                    openCardealerMenu()
                end                                
            elseif #(pCoords - v.pos) < 1.3 then
                spam = false
                openmarker = false
            end   
        end
        for _,v in pairs(Config.GaragePos) do
            if #(pCoords - v.pos) < 1.4 then
                spam = true
                DrawMarker(36, v.pos, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 0, 100, 255, 120, 1, 0, 0, 2)
                Visual.Subtitle("Appuyer sur [~b~E~s~] pour accéder au ~b~Garage")
                if IsControlJustPressed(1, 51) then
                    openGarageMenu({v.ExitPos[1], v.ExitPos[2], v.ExitPos[3], v.ExitPos[4]})
                end                                
            elseif #(pCoords - v.pos) < 1.3 then
                spam = false
                openmarker = false
            end   
        end
        for _,v in pairs(Config.GarageEnterPos) do
            if IsPedSittingInAnyVehicle(Player:Ped()) then
            if #(pCoords - v.pos) < 1.9 then
                spam = true
                DrawMarker(36, v.pos, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 255, 0, 0, 120, 1, 0, 0, 2)
                Visual.Subtitle("Appuyer sur [~r~E~s~] pour rentrer le ~r~Véhicule")
                if IsControlJustPressed(1, 51) then
                    ParkedGarage()
                end                                
            elseif #(pCoords - v.pos) < 1.3 then
                spam = false
                openmarker = false
            end   
        end
        for _,v in pairs(Config.CarWashPos) do             
            if IsPedSittingInAnyVehicle(Player:Ped()) then 
                if #(pCoords - v.pos) < 1.2 then
                    spam = true
                    DrawMarker(2, v.pos, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 0, 100, 255, 120, 1, 0, 0, 2)
                    Visual.Subtitle("Appuyer sur [~b~E~s~] pour laver votre ~b~véhicule")
                    if IsControlJustPressed(1, 51) then
                        SetVehicleDirtLevel(GetVehiclePedIsIn(Player:Ped()), 0)
                        TriggerServerEvent("aFrw:BuyAtCarWash", 20, 1)
                    end                                
                elseif #(pCoords - v.pos) < 1.3 then
                    spam = false
                    openmarker = false
                end   
            end     
        end 
    end

        -- end of Marker(s) on pos
        if spam then
            Wait(1)
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do 
        Wait(Config.WaitForStatus)
        local vehicle = GetVehiclePedIsIn(Player:Ped(), false)
        if IsPedRunning(Player:Ped()) then
            TriggerServerEvent("aFrw:UpdateStatus", 2)
        elseif IsPedShooting(Player:Ped()) then
            TriggerServerEvent("aFrw:UpdateStatus", 3)
        elseif IsPedSprinting(Player:Ped()) then
            TriggerServerEvent("aFrw:UpdateStatus", 4)
        elseif IsPedSwimming(Player:Ped()) then
            TriggerServerEvent("aFrw:UpdateStatus", 5)
        elseif IsPedWalking(Player:Ped()) then
            TriggerServerEvent("aFrw:UpdateStatus", 1)
        elseif (IsPedInAnyVehicle(PlayerPedId(), false) and GetIsVehicleEngineRunning(vehicle)) then
            if (GetEntitySpeed(vehicle) * 3600 > 40.0 --[[ 40 km ]]) then
                TriggerServerEvent("aFrw:UpdateStatus", 4)
            end
        end
    end
end)