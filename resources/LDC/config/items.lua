Config.Items = {
    ["bread"] = {
        type = 0, 
        label = "Pain", 
        weight = 0.6, 
        props = "prop_chair_01a", 
        usage = function() 
            TriggerServerEvent(Config.ServerName.. "UseItem", "bread") TriggerServerEvent("aFrw:AddHunger", 5) 
        end
    },
    ["water"] = {
        type = 0, 
        label = "Bouteille d'eau", 
        weight = 0.4, 
        props = "prop_ld_flow_bottle", 
        usage = function() 
            TriggerServerEvent(Config.ServerName.."UseItem", "water", "empty_water") 
            TriggerServerEvent("aFrw:AddWater", 5) 
        end
    },
    ["empty_water"] = {
        type = 2, 
        label = "Bouteille vide", 
        weight = 0.2
    },
    ["ammobox"] = {
        type = 0, 
        label = "Boite de munitions", 
        weight = 2.0, 
        usage = function() 
            UseAmmoBox() 
        end
    },
    ["WEAPON_PISTOL"] = {
        type = 1, 
        label = "Pistolet", 
        weight = 1.4, 
        usage = function() 
            TriggerServerEvent(Config.ServerName.."UseWeapon", "WEAPON_PISTOL") 
        end
    },
    ["WEAPON_PISTOL50"] = {
        type = 1, 
        label = "Pistolet calibre 50", 
        weight = 1.4, 
        usage = function() 
            TriggerServerEvent(Config.ServerName.."UseWeapon", "WEAPON_PISTOL50") 
        end
    },
}

function useItem(item)
    if Config.Items[item].usage then
        Config.Items[item].usage()
    else
        Visual.Popup({message="~r~Informations~s~\nCet item n'est pas utilisable"})
    end
end

function Dump(table, ident)
    if not ident then ident = 0 end
    if (ident > 200) then
        return false
    end
    for k, v in pairs(table) do
        if (type(v) == "table") then
            print(string.rep(" ", ident) ..k.. ":")
            Dump(v, ident + 1)
        else
            print(string.rep(" ", ident) ..k.. ": ", v)
        end
    end
end