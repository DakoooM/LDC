-- in-memory spawnpoint array for this script execution instance
local spawnPoints = {}

-- auto-spawn enabled flag
local autoSpawnEnabled = false
local autoSpawnCallback

-- support for mapmanager maps
AddEventHandler('getMapDirectives', function(add)
    -- call the remote callback
    add('spawnpoint', function(state, model)
        -- return another callback to pass coordinates and so on (as such syntax would be [spawnpoint 'model' { options/coords }])
        return function(opts)
            local x, y, z, heading

            local s, e = pcall(function()
                -- is this a map or an array?
                if opts.x then
                    x = opts.x
                    y = opts.y
                    z = opts.z
                else
                    x = opts[1]
                    y = opts[2]
                    z = opts[3]
                end

                x = x + 0.0001
                y = y + 0.0001
                z = z + 0.0001

                -- get a heading and force it to a float, or just default to null
                heading = opts.heading and (opts.heading + 0.01) or 0

                -- add the spawnpoint
                addSpawnPoint({
                    x = x, y = y, z = z,
                    heading = heading,
                    model = model
                })

                -- recalculate the model for storage
                if not tonumber(model) then
                    model = GetHashKey(model, _r)
                end

                -- store the spawn data in the state so we can erase it later on
                state.add('xyz', { x, y, z })
                state.add('model', model)
            end)

            if not s then
                Citizen.Trace(e .. "\n")
            end
        end
    end, function(state, arg)
        for i, sp in ipairs(spawnPoints) do
            if sp.x == state.xyz[1] and sp.y == state.xyz[2] and sp.z == state.xyz[3] and sp.model == state.model then
                table.remove(spawnPoints, i)
                return
            end
        end
    end)
end)

function loadSpawns(spawnString)
    local data = json.decode(spawnString)

    if not data.spawns then
        error("no 'spawns' in JSON data")
    end

    for i, spawn in ipairs(data.spawns) do
        addSpawnPoint(spawn)
    end
end

local spawnNum = 1
function addSpawnPoint(spawn)
    if not tonumber(spawn.x) or not tonumber(spawn.y) or not tonumber(spawn.z) then
        error("invalid spawn position")
    end

    if not tonumber(spawn.heading) then
        error("invalid spawn heading")
    end

    local model = spawn.model

    if not tonumber(spawn.model) then
        model = GetHashKey(spawn.model)
    end

    if not IsModelInCdimage(model) then
        error("invalid spawn model")
    end

    spawn.model = model

    spawn.idx = spawnNum
    spawnNum = spawnNum + 1

    table.insert(spawnPoints, spawn)

    return spawn.idx
end

function removeSpawnPoint(spawn)
    for i = 1, #spawnPoints do
        if spawnPoints[i].idx == spawn then
            table.remove(spawnPoints, i)
            return
        end
    end
end

function setAutoSpawn(enabled)
    autoSpawnEnabled = enabled
end

function setAutoSpawnCallback(cb)
    autoSpawnCallback = cb
    autoSpawnEnabled = true
end

local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end

        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end

        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(player, true)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

function loadScene(x, y, z)
	if not NewLoadSceneStart then
		return
	end

    NewLoadSceneStart(x, y, z, 0.0, 0.0, 0.0, 20.0, 0)

    while IsNewLoadSceneActive() do
        networkTimer = GetNetworkTimer()

        NetworkUpdateLoadScene()
    end
end


local spawnLock = false
function spawnPlayer(spawnIdx, revive, cb)
    if spawnLock then return end
    spawnLock = true
    CreateThread(function()
        if not spawnIdx then
            spawnIdx = GetRandomIntInRange(1, #spawnPoints + 1)
        end

        local spawn

        if type(spawnIdx) == 'table' then
            spawn = spawnIdx

            -- prevent errors when passing spawn table
            spawn.x = spawn.x + 0.00
            spawn.y = spawn.y + 0.00
            spawn.z = spawn.z + 0.00

            spawn.heading = spawn.heading and (spawn.heading + 0.00) or 0
        else
            spawn = spawnPoints[spawnIdx]
        end

        if not spawn then
            Citizen.Trace("tried to spawn at an invalid spawn index\n")
            spawnLock = false

            return
        end

        freezePlayer(PlayerId(), true)

        if spawn.model then
            RequestModel(spawn.model)

            -- load the model for this spawn
            while not HasModelLoaded(spawn.model) do
                RequestModel(spawn.model)
                Wait(0)
            end

            SetPlayerModel(PlayerId(), spawn.model)
            SetModelAsNoLongerNeeded(spawn.model)
            
            if N_0x283978a15512b2fe then
				N_0x283978a15512b2fe(PlayerPedId(), true)
            end
        end

        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

        local ped = PlayerPedId()

        SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)

        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)

        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        ClearPlayerWantedLevel(PlayerId())


        local time = GetGameTimer()
        while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
            Wait(0)
        end

        ShutdownLoadingScreen()

        if IsScreenFadedOut() then
            DoScreenFadeIn(500)
            while not IsScreenFadedIn() do Wait(0) end
        end

        freezePlayer(PlayerId(), false)
        if (revive ~= nil and revive == true) then
            TriggerEvent('playerSpawned', spawn)
        end

        if (cb) then
            cb(spawn)
        end

        spawnLock = false
    end)
end

RegisterCommand("revive", function()
    local myCoords = GetEntityCoords(PlayerPedId())
    spawnPlayer({x = myCoords.x, y = myCoords.y, z = myCoords.z, model = GetHashKey("u_m_m_aldinapoli"), heading = 215.0}, false, function()
        LDC.loadSkin()
    end)
end)

function forceRespawn()
    spawnLock = false
    respawnForced = true
end

AddEventHandler('onClientMapStart', function()
    setAutoSpawn(true)
    forceRespawn()
end)

exports('spawnPlayer', spawnPlayer)
exports('addSpawnPoint', addSpawnPoint)
exports('removeSpawnPoint', removeSpawnPoint)
exports('loadSpawns', loadSpawns)
exports('setAutoSpawn', setAutoSpawn)
exports('setAutoSpawnCallback', setAutoSpawnCallback)
exports('forceRespawn', forceRespawn)
