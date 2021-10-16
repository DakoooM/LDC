function ifItemExist(item) -- GOOD
    if Config.Items[item] ~= nil then
        return true
    else
        return false
    end
end

-- Get..()

function GetLabelItem(item) -- GOOD
    return Config.Items[item].label
end

function GetWeightItem(item) -- GOOD 
    return Config.Items[item].weight
end

function GetItemType(item) -- GOOD 
    return Config.Items[item].type
end

function GetWeight()
    return Config.Weight
end

function GetInventory(id)
    return player[id].inventory
end

function GetJob(id)
    return player[id].job
end

function CreateItem(item, count)
    return {item = item, count = count, label = GetLabelItem(item)}
end

-- Inventory

function getInventoryWeight(id)
    local height = 0
    for k,v in pairs(player[id].inventory) do
        local wght = GetWeightItem(v.name)
        height = height + (wght * v.count)
    end
    return height
end

function AddItem(source, item, count)
    local count = tonumber(count)
    if ifItemExist(item) then
        if getInventoryWeight(source) + GetWeightItem(item) * count <= GetWeight() then
            if player[source].inventory[item] then
                player[source].inventory[item].count = player[source].inventory[item].count + count
            else
                player[source].inventory[item] = {}
                player[source].inventory[item].label = GetLabelItem(item)
                player[source].inventory[item].name = item
                player[source].inventory[item].count = count
            end
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous avez reçu "..count.." "..GetLabelItem(item)})
            saveInventory(source)
            refreshInventory(source)
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous n'avez pas assez de place"})
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nCet item n'existe pas"})
    end
end

function RemoveItem(source, item, count)
    local count = tonumber(count)
    if ifItemExist(item) then
        if player[source].inventory[item] then
            if (player[source].inventory[item].count - count) >= 0 then
                player[source].inventory[item].count = player[source].inventory[item].count - count
                if player[source].inventory[item].count == 0 then
                    player[source].inventory[item] = nil
                end
                saveInventory(source)
                refreshInventory(source)
            else
                TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous n'avez pas assez de ~b~"..GetLabelItem(item).." ~s~dans votre inventaire."})
            end
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nCet item n'existe pas"})
    end
end

function AddItemToPlayer(source, id, item, count)
    local count = tonumber(count)
    if GetPlayerPed(id) ~= 0 then
        if ifItemExist(item) then
            -- if getInventoryWeight(id) + GetWeightItem(item) * count <= GetWeight() then
                if GetItemType(item) == 1 and count >= 2 then 
                    TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous ne pouvez pas donner plus d'un "..GetLabelItem(item).." à un individu."})
                    TriggerClientEvent("RageUI:Popup", id, {message="~r~Informations~s~\nVous possédé déjà 1 "..GetLabelItem(item)})
                else
                    if player[id].inventory[item] then
                        player[id].inventory[item].count = player[id].inventory[item].count + count
                    else
                        player[id].inventory[item] = {}
                        player[id].inventory[item].label = GetLabelItem(item)
                        player[id].inventory[item].name = item
                        player[id].inventory[item].count = count
                    end
                    TriggerClientEvent("RageUI:Popup", id, {message="~r~Informations~s~\nVous avez reçu "..count.." "..GetLabelItem(item)})
                    saveInventory(id)
                    refreshInventory(id)
                end
            -- else
            --     TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\n"..GetPlayerName(source).." n'a pas assez de place"})
            -- end
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nCet item n'existe pas"})
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nLe joueur demandé n'existe pas"})
    end
end

function RemoveItemToPlayer(source, id, item, count)
    local count = tonumber(count)
    if GetPlayerPed(id) ~= 0 then
        if ifItemExist(item) then
            if player[id].inventory[item] then
                if (player[id].inventory[item].count - count) >= 0 then
                    player[id].inventory[item].count = player[id].inventory[item].count - count
                    if player[id].inventory[item].count == 0 then
                        player[id].inventory[item] = nil
                    end
                    TriggerClientEvent("RageUI:Popup", id, {message="~r~Informations~s~\nUn administrateur vous à retiré "..count.." "..GetLabelItem(item)})
                    saveInventory(id)
                    refreshInventory(id)
                else
                    TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\n"..GetPlayerName(source).." n'a pas assez de ~b~"..GetLabelItem(item).." ~s~dans son inventaire."})
                end
            end
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nCet item n'existe pas"})
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nLe joueur demandé n'existe pas"})
    end
end

function saveInventory(source)
    local inventaire = json.encode(player[source].inventory)
    local license = GetLicense(source)
    MySQL.Async.execute("UPDATE players SET inventory = @inventory WHERE license = @license", {
        ["license"] = license,
        ["inventory"] = inventaire
    })
end

function refreshInventory(source)
    local obj = {}
    obj.inventory = player[source].inventory
    obj.money = player[source].money
    obj.bank_money = player[source].bank_money
    TriggerClientEvent('aFrw:refreshPlayerData', source, obj)
    TriggerClientEvent('aFrw:getWeight', source, getInventoryWeight(source))
end

-- Money 

function saveMoney(source)
    local money = player[source].money
    local bank_money = player[source].bank_money
    local license = GetLicense(source)
    MySQL.Async.execute("UPDATE players SET money = @money, bank_money = @bank_money WHERE license = @license", {
        ["license"] = license,
        ["money"] = money,
        ["bank_money"] = bank_money
    })
end

function refreshMoney(source)
    local obj = {}
    obj.money = player[source].money
    obj.bank_money = player[source].bank_money
    TriggerClientEvent('aFrw:refreshPlayerData', source, obj)
end

-- Use divers

RegisterNetEvent('aFrw:GiveItem')
AddEventHandler('aFrw:GiveItem', function(id, item, count)
    AddItemToPlayer(source, id, item, count)
end)

RegisterNetEvent(Config.ServerName.."UseItem")
AddEventHandler(Config.ServerName.."UseItem", function(item, newItem)
    RemoveItem(source, item, 1)
    AddItem(source, newItem, 1)
    saveInventory(source)
    refreshInventory(source)
    TriggerClientEvent("RageUI:Popup", src, {message="~r~Informations~s~\nVous avez utilisé 1 "..GetLabelItem(item)})
end)

RegisterNetEvent(Config.ServerName.."UseWeapon")
AddEventHandler(Config.ServerName.."UseWeapon", function(weapon)
    local source = source 
    GiveWeaponToPed(GetPlayerPed(source), GetHashKey(weapon), tonumber(0), false, true)
    TriggerClientEvent("RageUI:Popup", source, {message="Vous utilisé un ~g~"..GetLabelItem(weapon)})
end)

RegisterNetEvent('aFrw:UseAmmoBox')
AddEventHandler('aFrw:UseAmmoBox', function(weapon)
    local source = source 
    RemoveItem(source, weapon, 1)
    TriggerClientEvent("RageUI:Popup", source, {message="Vous utilisé une ~g~"..GetLabelItem(weapon)})
end)

RegisterNetEvent('aFrw:DropItemToPlayer')
AddEventHandler('aFrw:DropItemToPlayer', function(id, item, count)
    local source = source 
    if player[source].inventory[item] then
        if (player[source].inventory[item].count - count) >= 0 then
            player[source].inventory[item].count = player[source].inventory[item].count - count
            if player[source].inventory[item].count == 0 then
                player[source].inventory[item] = nil
            end
            if player[id].inventory[item] then
                player[id].inventory[item].count = player[id].inventory[item].count + count
            else
                player[id].inventory[item] = {}
                player[id].inventory[item].label = GetLabelItem(item)
                player[id].inventory[item].name = item
                player[id].inventory[item].count = count
            end
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous avez donné "..count.." ~b~"..GetLabelItem(item).." ~s~à "..GetPlayerName(id)})
            TriggerClientEvent("RageUI:Popup", id, {message="~r~Informations~s~\nVous avez reçu "..count.." ~b~"..GetLabelItem(item).." ~s~de la part du joueur "..GetPlayerName(source)})
            saveInventory(source)
            refreshInventory(source)
            saveInventory(id)
            refreshInventory(id)
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous n'avez pas assez de ~b~"..GetLabelItem(item).." ~s~dans votre inventaire."})
        end
    end
end)

-- Interact Items

RegisterCommand("giveItem", function(source, args)
    local id = tonumber(args[1])
    local item = args[2]
    local count = tonumber(args[3])
    if player[source].group == "admin" or player[source].group == "sadmin" or player[source].group == "dev" then 
        if id and item and count then
            AddItemToPlayer(source, id, item, count)
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nIl manque des arguments."})
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous ne pouvez pas faire ceci.."})
    end
end)

RegisterCommand("removeItem", function(source, args)
    local id = tonumber(args[1])
    local item = args[2]
    local count = tonumber(args[3])
    if player[source].group == "admin" or  player[source].group == "sadmin" or player[source].group == "dev" then 
        if id and item and count then
            RemoveItemToPlayer(source, id, item, count)
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nIl manque des arguments."})
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous ne pouvez pas faire ceci.."})
    end
end)

RegisterNetEvent(Config.ServerName.. ":playerAdminActions")
AddEventHandler(Config.ServerName.. ":playerAdminActions", function(setting)
    local src = tonumber(source)
    if setting.type == "TeleportOnMe" then
        local coords = GetEntityCoords(GetPlayerPed(src));
        TriggerClientEvent(Config.ServerName.. ":playerClientAdminActions", setting.playerId, {
            type = "teleport",
            pos = {x = coords.x, y = coords.y, z = coords.z}
        })
    end
end)