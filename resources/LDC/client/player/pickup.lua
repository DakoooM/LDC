local Pickup = {}

RegisterNetEvent(Config.ServerName.. ":addPickupObject")
AddEventHandler(Config.ServerName.. ":addPickupObject", function(setting)
    local myPos = Player:GetCoords()
    LDC.SpawnObject(setting.objectName, {x = myPos.x, y = myPos.y, z = myPos.z}, function(objectPickup)
        PlaceObjectOnGroundProperly(objectPickup);
        FreezeEntityPosition(objectPickup, true);
        table.insert(Pickup, {
            object = objectPickup, 
            objName = setting.objectName
        })
    end)
    CreateThread(function()
        while setting.whilee do
            local waitToGoSleeping = 400;
            if #Pickup > 0 then
                for i, objects in pairs (Pickup) do
                    local dst = #(Player:GetCoords() - GetEntityCoords(objects.object))
                    if dst < 7.0 and dst >= 2.0 then
                        waitToGoSleeping = 0;
                        LDC.showText3D({
                            coords = vector3(GetEntityCoords(objects.object).x, GetEntityCoords(objects.object).y, GetEntityCoords(objects.object).z+0.4),
                            text = setting.labelItem.. " - x~b~" ..tostring(setting.quantityLabel).. "~s~"
                        })
                    end

                    if dst < 2.0 then
                        waitToGoSleeping = 1;
                        LDC.showText3D({
                            coords = vector3(GetEntityCoords(objects.object).x, GetEntityCoords(objects.object).y, GetEntityCoords(objects.object).z+0.4),
                            text = "Ramasser ~b~" ..tostring(setting.quantityLabel).. "~s~x - " ..setting.labelItem.. "~s~",
                            size = 0.50,
                        })
                        if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) then
                            DeleteEntity(objects.object)
                            table.remove(Pickup, i)
                            setting[1] = false;
                            break
                        end
                    end
                end
            end
            Wait(waitToGoSleeping)
        end
    end)
end)