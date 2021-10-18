function GetLicense(id)
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            return v
        end
    end
end

-- function GetSteam(id)
--     local identifiers = GetPlayerIdentifiers(id)
--     for _, v in pairs(identifiers) do
--         if string.find(v, "steam") then
--             return v
--         end
--     end
-- end

-- function GetDiscord(id)
--     local identifiers = GetPlayerIdentifiers(id)
--     for _, v in pairs(identifiers) do
--         if string.find(v, "discord") then
--             return v
--         end
--     end
-- end

function GetCoords(source)
    local vector, heading = GetEntityCoords(GetPlayerPed(source)), GetEntityHeading(GetPlayerPed(source))
    return { x = vector.x, y = vector.y, z = vector.z, w = heading}
end

ServerCallbacks = {}

SetRoutingBucketPopulationEnabled(0, false)

RegisterServerCallback = function(name, cb)
	ServerCallbacks[name] = cb
end

TriggerServerCallback = function(name, requestId, source, cb, ...)
	if ServerCallbacks[name] then
		ServerCallbacks[name](source, cb, ...)
	else
		print(('[^3Server Callback^7] "%s" n\'existe pas'):format(name))
	end
end

RegisterServerEvent("aFrw:CallbackTrigger")
AddEventHandler("aFrw:CallbackTrigger", function(name, requestId, ...)
	local playerId = source

	TriggerServerCallback(name, requestId, playerId, function(...)
		TriggerClientEvent("aFrw:serverCallback", playerId, requestId, ...)
	end, ...)
end)

function saveSkin(source)
    local skin = player[source].skin 
    local license = GetLicense(source)
    MySQL.Async.execute("UPDATE players SET skin = @skin WHERE license = @license", {
        ["license"] = license,
        ["skin"] = json.encode(skin)
    })
end