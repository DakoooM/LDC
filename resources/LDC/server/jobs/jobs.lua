function ifJobExist(job) -- GOOD
    if Config.Jobs[job] ~= nil then
        return true
    else
        return false
    end
end

function GetJobLabel(job) -- GOOD
    return Config.Jobs[job].label
end

 
function setJob(source, id, job, job_grade)
    if GetPlayerPed(id) ~= 0 then
        if ifJobExist(job) then
            if Config.Jobs[job].grades[tonumber(job_grade)] then
                player[id].job = job
                player[id].job_grade = job_grade
                saveJob(id)
                refreshJob(id)
            else
                print(string.format("Le grade %s n'existe pas pour le job  %s", job_grade,job ))
            end
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nCe job n'existe pas"})
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nLe joueur demandé n'existe pas"})
    end
end

function saveJob(id)
    local job = player[id].job
    local job_grade = player[id].job_grade
    local license = GetLicense(id)
    MySQL.Async.execute("UPDATE players SET job = @job, job_grade = @job_grade WHERE license = @license", {
        ["license"] = license,
        ["job"] = job,
        ["job_grade"] = job_grade
    })
end

function refreshJob(id)
    local obj = {}
    obj.job = player[id].job
    obj.job_grade = player[id].job_grade
    TriggerClientEvent('aFrw:refreshPlayerData', id, obj)
end

RegisterCommand("setJob", function(source, args)
    local id = tonumber(args[1])
    local job = args[2]
    local job_grade = args[3]
    if player[source].group == "admin" or  player[source].group == "sadmin" or player[source].group == "dev" then 
        if id and job and job_grade then 
            setJob(source, id, job, job_grade)
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nIl manque des arguments."})
        end
    else
        TriggerClientEvent("RageUI:Popup", source, {message="~r~Informations~s~\nVous ne pouvez pas faire ceci.."})
    end
end)

RegisterNetEvent('aFrw:SetJob')
AddEventHandler('aFrw:SetJob', function(id, Job, JobTable)
    local source = source 
    setJob(source, id, Job, JobTable.id)
end)