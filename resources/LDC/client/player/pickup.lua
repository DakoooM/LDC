local Pickup = {}

RegisterNetEvent(Config.ServerName.. ":addPickupObject")
AddEventHandler(Config.ServerName.. ":addPickupObject", function(setting)
    local myPos = Player:GetCoords()
    LDC.SpawnObject(setting.objectName, {x = myPos.x, y = myPos.y, z = myPos.z}, function(objectPickup)
        PlaceObjectOnGroundProperly(objectPickup);
        FreezeEntityPosition(objectPickup, true);
        table.insert(Pickup, {
            object = objectPickup, 
            label = setting.labelItem,
            itemName = setting.itemName, 
            itemCount = setting.quantityLabel,
            coords = GetEntityCoords(objectPickup)
        })
    end)
    CreateThread(function()
        while #Pickup > 0 do
            print("TEST")
            local waitToGoSleeping = 400;
            for i, objects in pairs (Pickup) do
                local objectCoords = objects.coords;
                local dst = #(Player:GetCoords() - objectCoords);
                local inCinematic = false;

                if (dst <= 2.0 and dst >= 1.3) then
                    waitToGoSleeping = 0;
                    LDC.showText3D({
                        coords = vector3(objectCoords.x, objectCoords.y, objectCoords.z+1.0),
                        text = objects.label.. " - x~b~" ..tostring(objects.itemCount).. "~s~"
                    })
                end

                if (dst <= 1.3) then
                    waitToGoSleeping = 0;
                    LDC.showText3D({coords = vector3(objectCoords.x, objectCoords.y, objectCoords.z+1.0), size = 0.50,
                        text = "Ramasser ~b~" ..tostring(objects.itemCount).. "~s~x - " ..objects.label.. "~s~"
                    })
                    if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) and not inCinematic then
                        inCinematic = true;
                        LDC.playAnimation({animDict = "random@domestic", animName = "pickup_low"})
                        Wait(1200)
                        ClearPedTasks(Player:Ped())
                        TriggerServerEvent(Config.ServerName.. ":newItemPickup", {type = "rentItem", coords = vector3(objectCoords.x, objectCoords.y, objectCoords.z),
                            itemName = objects.itemName, itemCount = objects.itemCount
                        })
                        DeleteEntity(objects.object)
                        table.remove(Pickup, i)
                    end
                end
            end
            Wait(waitToGoSleeping)
        end
    end)
end)