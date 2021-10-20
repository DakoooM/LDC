RegisterServerEvent(Config.ServerName.. ":newItemPickup")
AddEventHandler(Config.ServerName.. ":newItemPickup", function(setting)
    if setting.type == "add" then
        if player[source].inventory[setting.itemName].count >= setting.itemQuantity then
            TriggerClientEvent(Config.ServerName.. ":addPickupObject", source, {
                whilee = true,
                objectName = setting.objectName, 
                labelItem = setting.itemLabel,
                itemName = setting.itemName,
                quantityLabel = setting.itemQuantity
            })
            RemoveItem(source, setting.itemName, setting.itemQuantity)
        else
            TriggerClientEvent("RageUI:Popup", source, {message = "~r~<C>Attention</C>~s~\nVous n'avez pas assez d'item pour retirer tout cela"})
        end
    elseif setting.type == "rentItem" then
        if #(GetEntityCoords(GetPlayerPed(source)) - setting.coords) <= 2.0 then
            AddItem(source, setting.itemName, setting.itemCount)
        else
            print("TES BAN [newItemPickup]")
        end
    end
end)