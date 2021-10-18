function GetMoney(source) return player[source].money end
function GetBankMoney(source) return player[source].bank_money end

RegisterCommand("addMoney", function(source, args)
    local id = tonumber(args[1])
    local money = math.floor(tonumber(args[2]))
    if player[source].group == "admin" or  player[source].group == "sadmin" or player[source].group == "dev" then 
        if id and money then
            if GetPlayerPed(id) ~= 0 then
                player[id].money = player[id].money + money
                saveMoney(id)
                refreshInventory(id)
                TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\n"..GetPlayerName(source).." : + ~g~"..money.."$"})
                TriggerClientEvent("RageUI:Popup", id, {message="~r~Informations~s~\nVous avez reçu + ~g~"..money.."$"})
            else
                TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nLe joueur demandé n'existe pas"})
            end
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nIl manque des arguments."})
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous ne pouvez pas faire ceci.."})
    end
end)

RegisterCommand("removeMoney", function(source, args)
    local id = tonumber(args[1])
    local money = math.floor(tonumber(args[2]))
    if player[source].group == "admin" or  player[source].group == "sadmin" or player[source].group == "dev" then 
        if id and money then
            if GetPlayerPed(id) ~= 0 then
                if money >= GetMoney(id) then
                    TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\n"..GetPlayerName(source).." n'a pas assez d'argent"})
                else
                    player[id].money = player[id].money - money
                    saveMoney(id)
                    refreshInventory(id)
                    TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\n"..GetPlayerName(source).." : - ~g~"..money.."$"})
                    TriggerClientEvent("RageUI:Popup", id, {message="~r~Informations~s~\nVous avez perdu - ~g~"..money.."$"})
                end
            else
                TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nLe joueur demandé n'existe pas"})
            end 
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nIl manque des arguments."})
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous ne pouvez pas faire ceci.."})
    end
end)