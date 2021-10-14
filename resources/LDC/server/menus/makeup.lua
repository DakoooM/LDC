
RegisterServerEvent("aFrw:BuyAtInstitut")
AddEventHandler("aFrw:BuyAtInstitut", function(NewInstitut, Price, Type)
    local source = source
    local PlayerMoney = GetMoney(source)
    local BankPlayerMoney = GetBankMoney(source)
    if Type == 1 then 
        if Price >= PlayerMoney then
            TriggerClientEvent("RageUI:Popup", source, {message="Il vous manque ~g~"..Price-PlayerMoney.."$~s~ sur vous pour pouvoir acheter ceci."})
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Institut de Beauté~s~\nPaiement effectué\n- ~g~"..Price.."$"})
            player[source].skin.makeup = NewInstitut.makeup
            player[source].skin.lipstick = NewInstitut.lipstick
            player[source].skin.lipstickColor = NewInstitut.lipstickColor
            player[source].money = player[source].money - tonumber(Price)
            saveSkin(source)
            saveMoney(source)
            refreshMoney(source)
            refreshSkin(source)
        end
    elseif Type == 2 then 
        if Price >= BankPlayerMoney then
            TriggerClientEvent("RageUI:Popup", source, {message="Il vous manque ~g~"..Price-BankPlayerMoney.."$~s~ sur votre compte pour pouvoir acheter ceci."})
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Institut de Beauté~s~\nPaiement effectué\n- ~g~"..Price.."$"})
            player[source].skin.makeup = NewInstitut.makeup
            player[source].skin.lipstick = NewInstitut.lipstick
            player[source].skin.lipstickColor = NewInstitut.lipstickColor
            player[source].bank_money = player[source].bank_money - tonumber(Price)
            saveSkin(source)
            saveMoney(source)
            refreshMoney(source)
            refreshSkin(source)
        end
    end
end)

function saveSkin(source)
    local skin = player[source].skin 
    local license = GetLicense(source)
    MySQL.Async.execute("UPDATE players SET skin = @skin WHERE license = @license", {
        ["license"] = license,
        ["skin"] = json.encode(skin)
    })
end