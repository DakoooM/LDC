function ifGroupExist(group) 
    if Config.Groups[group] ~= nil then
        return true
    else
        return false
    end
end

function GetGroupLabel(group) 
    return Config.Groups[group].label
end

function setGroup(source, id, group)
    if GetPlayerPed(id) ~= 0 then
        if ifGroupExist(group) then
            player[id].group = group
            saveGroup(id)
            refreshGroup(id)
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nCe groupe n'existe pas"})
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nLe joueur demandé n'existe pas"})
    end
end

function saveGroup(id)
    local group = player[id].group
    local license = GetLicense(id)
    MySQL.Async.execute("UPDATE players SET grade = @grade WHERE license = @license", {
        ["license"] = license,
        ["grade"] = group
    })
end

function refreshGroup(id)
    local obj = {}
    obj.group = player[id].group
    TriggerClientEvent('aFrw:refreshPlayerData', id, obj)
end

RegisterCommand("setGroup", function(source, args)
    local id = tonumber(args[1])
    local group = args[2]
    if player[source].group == "admin" or  player[source].group == "sadmin" or  player[source].group == "dev" then 
        if id and group then 
            setGroup(source, id, group)
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nIl manque des arguments."})
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous ne pouvez pas faire ceci.."})
    end
end)