RegisterServerEvent(Config.ServerName.. ":newItemPickup")
AddEventHandler(Config.ServerName.. ":newItemPickup", function(setting)
    if setting.type == "add" then
        TriggerClientEvent(Config.ServerName.. ":addPickupObject", source, {
            whilee = true, 
            objectName = setting.objectName, 
            labelItem = setting.itemLabel,
            quantityLabel = setting.itemQuantity
        })
    elseif setting.type == "rentItem" then
        
    end
end)