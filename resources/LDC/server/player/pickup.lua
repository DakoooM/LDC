Pickup = {}

RegisterServerEvent(Config.ServerName.. ":newItemPickup")
AddEventHandler(Config.ServerName.. ":newItemPickup", function(setting)
    if setting.type == "add" then
        Pickup[source].name = setting.name;
        Pickup[source].count = setting.count+1;
        Pickup[source].label = setting.label;
        Pickup[source].usable = setting.usable;
    end
end)

RegisterCommand("insertTest", function(source, args, raw)
    table.insert(Pickup, {license = GetLicense(source), name = "bread", count = 15, label = "Paigne", usable = false})
    print("AFTER INSERT", json.encode(Pickup))
end)