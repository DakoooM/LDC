Player = {}
Player.HasPlayerLoaded = false 

CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerServerEvent('hardcap:playerActivated')
            ShutdownLoadingScreen()
            ShutdownLoadingScreenNui()
            break
		end
	end
end)

function Player:new(data)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.FirstConnect = data.FirstConnect
    obj.license = data.license 
    obj.name = data.name 
    obj.money = data.money
    obj.bank_money = data.bank_money
    obj.job = data.job
    obj.job_grade = data.job_grade
    obj.group = data.group
    obj.inventory = data.inventory
    obj.skin = data.skin
    obj.clothes = data.clothes
    obj.pos = data.pos 
    obj.status = data.status 
    Player = obj
end

function Player:Ped()
    return PlayerPedId()
end

function Player:GetCoords(ped) 
    return GetEntityCoords(ped or Player:Ped())
end

function Player:getClothes()
    return self.clothes
end

function Player:getGroup()
    return self.group
end

function Player:getStatus()
    return self.status
end

function GetGroupLabel(grade) -- GOOD
    return Config.Groups[grade].label
end

function Player:getLicense()
    return self.license
end

function Player:getPos()
    return self.pos
end

function Player:getIdentity()
    return self.name
end

function Player:getMoney()
    return self.money
end

function Player:getBankMoney()
    return self.bank_money
end

function Player:getSkin()
    return self.skin
end

function Player:getInventory()
    return self.inventory
end

function Player:getJob()
    return self.job
end

function Player:getJobGrade()
    return self.job_grade
end

function GetJobLabel(job) -- GOOD
    return Config.Jobs[job].label
end

function GetJobGrade(job, grade) -- GOOD
    return Config.Jobs[job].grades[grade].Name
end

-- Set Infos

function Player:setLicense(license)
    self.license = license
end

function Player:setPos(pos)
    self.pos = pos
end

function Player:setJob(job)
    self.job = job
end

function Player:setJobGrade(grade)
    self.job_grade = grade
end

function Player:setIdentity(identity)
    self.name = identity
end

function Player:setMoney(money)
    self.money = money
end



--- Commands 

function Player:playAnim(dict, anim, flag)
    if dict ~= "" then
        RequestAnimDict(dict)
        print("requesting anim dict "..dict)
        while not HasAnimDictLoaded(dict) do Wait(1) end
        print("Start anim")
        TaskPlayAnim(self:ped(), dict, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
    end
end

function Player:Teleport(ped, pos, Callback) 
    if tonumber(pos[1]) and tonumber(pos[2]) and tonumber(pos[3]) then
        while not HasCollisionLoadedAroundEntity(Player:Ped()) do Wait(50) end
        SetEntityCoords(ped or Player:Ped(), tonumber(pos[1]), tonumber(pos[2]), tonumber(pos[3]))
        Citizen.Trace("Teleport To Coord sucess")
        if (Callback) then
            Callback(pos[1], pos[2], pos[3])
        end
    end
end
