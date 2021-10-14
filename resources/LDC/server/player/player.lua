player = {}


---- SKIN

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

---- FINISH SKIN

RegisterNetEvent("aFrw:AddPlayerIntoDatabase")
AddEventHandler("aFrw:AddPlayerIntoDatabase", function(Character, CharacterClothes, identite)
    local source = source
    local obj = {}
    local GetStatus = {hunger = 100, water = 100}
    obj = {
        FirstConnect = true,
        license = GetLicense(source), 
        name = json.encode(identite), 
        group = "player",
        money = 7500, 
        bank_money = 12500,
        inventory = json.encode({}), 
        skin = json.encode(Character),
        clothes = json.encode(CharacterClothes), 
        job = "unemployed", 
        job_grade = 1, 
        pos = Config.DefaultPos,
        status = json.encode(GetStatus)
    }
    local xPos = json.encode(obj.pos)
    MySQL.Async.execute("INSERT INTO `players` (license, name, grade, money, bank_money, inventory, skin, clothes, job, job_grade, pos) VALUES (@license, @name, @grade, @money, @bank_money, @inventory, @skin, @clothes, @job, @job_grade, @pos)", {
        ["license"] = obj.license,
        ["name"] = obj.name,
        ["grade"] = obj.group,
        ["money"] = obj.money,
        ["bank_money"] = obj.bank_money,
        ["inventory"] = obj.inventory,
        ["skin"] = obj.skin,
        ["clothes"] = obj.clothes,
        ["job"] = obj.job,
        ["job_grade"] = obj.job_grade,
        ["pos"] = xPos,
        ["status"] = json.encode(GetStatus)
    }, function()
        player[source] = obj
        player[source].name = json.decode(player[source].name)
        player[source].clothes = json.decode(player[source].clothes)
        player[source].inventory = json.decode(player[source].inventory)
        player[source].skin = json.decode(player[source].skin)
        player[source].status = json.decode(player[source].status)
        TriggerClientEvent("aFrw:refreshPlayerData", source, obj)
        print(GetPlayerName(source).." was create in database")
    end)
end)

local function InitPlayer(source)
    local license = GetLicense(source)
    local data = {}
    local obj = {}
    local haveData = false
    local PlayerSkin = {}

    MySQL.Async.fetchAll("SELECT * FROM players WHERE license = @license", { ["@license"] = license}, function(result)
        data = result[1]     
        haveData = true
    end)
 
    while haveData == false do
        corePrint("Waiting to load player data")
        Wait(200)
    end

    corePrint("Player "..GetPlayerName(source).." loaded")
    if data == nil then
        TriggerClientEvent("aFrw:OpenIdentityMenu", source)
    else
        data.FirstConnect = false
        obj.license = data.license
        obj.inventory = json.decode(data.inventory)
        obj.skin = json.decode(data.skin)
        obj.clothes = json.decode(data.clothes)
        obj.job = data.job
        obj.job_grade = data.job_grade
        obj.group = data.grade
        obj.name = json.decode(data.name)
        obj.money = data.money
        obj.bank_money = data.bank_money
        obj.pos = json.decode(data.pos)
        obj.status = json.decode(data.status)
        player[source] = obj
        TriggerClientEvent('aFrw:refreshPlayerData', source, player[source])
        refreshInventory(source)
        refreshMoney(source)
        corePrint("Loaded player "..GetPlayerName(source).." from database")
    end
end

function savePlayerData(source)
    local data = player[source]
    local license = GetLicense(source)
    local xPos = json.encode(data.pos)
    local xStatus = json.encode(data.status)
    if data.FirstConnect == true then 
        MySQL.Async.execute("UPDATE players SET name = @name, clothes = @clothes, pos = @pos, status = @status WHERE license = @license", {
            ["license"] = license,
            ["name"] = json.encode(player[source].name),
            ["clothes"] = json.encode(player[source].clothes),
            ["pos"] = xPos,
            ["status"] = xStatus
        }, function()
            print("First connexion of "..tostring(GetPlayerName(source)).." saved")
        end)
    else
        MySQL.Async.execute("UPDATE players SET name = @name, grade = @grade, money = @money, bank_money = @bank_money, inventory = @inventory, skin = @skin, clothes = @clothes, job = @job, job_grade = @job_grade, pos = @pos, status = @status WHERE license = @license", {
            ["license"] = license,
            ["name"] = json.encode(player[source].name),
            ["grade"] = data.group,
            ["money"] = data.money,
            ["bank_money"] = data.bank_money,
            ["inventory"] = json.encode(data.inventory),
            ["skin"] = json.encode(player[source].skin),
            ["clothes"] = json.encode(player[source].clothes),
            ["job"] = data.job,
            ["job_grade"] = data.job_grade,
            ["pos"] = xPos,
            ["status"] = xStatus
        }, function()
            print("Player "..tostring(GetPlayerName(source)).." saved")
        end)
    end
end

function RemovePlayer(source)
    player[source] = nil
end


function refreshSkin(source)
    local obj = {}
    obj.skin = player[source].skin
    TriggerClientEvent('aFrw:refreshPlayerData', source, obj)
end

RegisterNetEvent('aFrw:RefreshClothes')
AddEventHandler('aFrw:RefreshClothes', function(clothes, type)
    if type == 1 then 
        player[source].clothes.torso = clothes.torso
        player[source].clothes.torso2 = clothes.torso2
        player[source].clothes.tshirts = clothes.tshirts
        player[source].clothes.tshirts2 = clothes.tshirts2
        player[source].clothes.arms = clothes.arms
    elseif type == 2 then 
        player[source].clothes.pants = clothes.pants
        player[source].clothes.pants2 = clothes.pants2
    elseif type == 3 then 
        player[source].clothes.shoes = clothes.shoes
        player[source].clothes.shoes2 = clothes.shoes2
    end
    saveClothes(source)
end)

RegisterNetEvent('aFrw:loadPlayerData')
AddEventHandler('aFrw:loadPlayerData', function()
    local source = source 
    InitPlayer(source)
end)

AddEventHandler('playerDropped', function (reason)
    local source = source
    local coords = GetCoords(source)
    player[source].pos = coords
    corePrint("Player "..GetPlayerName(source).." dropped ( "..reason.." )")
    savePlayerData(source)
end)

RegisterNetEvent('aFrw:ShowIdentity')
AddEventHandler('aFrw:ShowIdentity', function(xTarget, IdentityTable)
    TriggerClientEvent("aFrw:ShowYourIDCardForPlayer", xTarget, IdentityTable)
end)