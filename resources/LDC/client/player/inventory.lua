local Administration = {
    checkboxStatus = false,
    checkboxNoclip = false,
    vehicleActionsIndex = 1,
    ActionsVehicles = {
        {
            Name = "Spawn",
            action = function()
                local spawnVehicle = KeyboardInput("ADMIN_SPAWN_VEHICLE", "Faire apparaitre un véhicule", "", 25)
                if spawnVehicle == "" or spawnVehicle == nil then return print("tu ne peux pas") end
                if LDC.get.getVehiclePedsIn() ~= 0 then return print("TU NE PEUX PAS FAIRE SPAWN DE VEHICULE QUAND TU EST DANS UN VEHICLE") end

                if IsModelInCdimage(spawnVehicle) then
                    LDC.SpawnVehicle(spawnVehicle, true, Player:GetCoords(), GetEntityHeading(Player:Ped()), function(adminVehicle)
                        SetPedIntoVehicle(Player:Ped(), adminVehicle, -1)
                        SetVehicleNumberPlateText(adminVehicle, "admin-"..math.random(10, 20))
                    end)
                else
                    print("le model que tu essai de faire spawn n'existe pas")
                end
            end
        },
        {
            Name = "Réparer",
            action = function()
                local interiorVehicle = LDC.get.getVehiclePedsIn()
                local exteriorVehicle = LDC.get.getClosestVehicle(3.0)
                if interiorVehicle ~= 0 then
                    for i = 1, 4 do SetVehicleWheelHealth(interiorVehicle, i, 1000) end
                    SetVehicleEngineHealth(interiorVehicle, 1000)
                    SetVehicleBodyHealth(interiorVehicle, 1000.0)
                    SetEntityHealth(interiorVehicle, 1000)
                    SetVehicleFixed(interiorVehicle)
                else
                    if exteriorVehicle ~= 0 then
                        for i = 1, 4 do SetVehicleWheelHealth(exteriorVehicle, i, 1000) end
                        SetVehicleEngineHealth(exteriorVehicle, 1000)
                        SetVehicleBodyHealth(exteriorVehicle, 1000.0)
                        SetEntityHealth(exteriorVehicle, 1000)
                        SetVehicleFixed(exteriorVehicle)
                    else
                        print("IL Y A VRAIMENT AUCUN VEHICULE AUTOUR DE VOUS")
                    end
                end
            end
        },
        {
            Name = "Supprimer",
            action = function()
                local interiorVehicle = LDC.get.getVehiclePedsIn()
                local exteriorVehicle = LDC.get.getClosestVehicle(3.0)
                if interiorVehicle ~= 0 then
                    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(interiorVehicle), true)
                    DeleteEntity(interiorVehicle)
                else
                    if exteriorVehicle ~= 0 then
                        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(exteriorVehicle), true)
                        DeleteEntity(exteriorVehicle)
                    else
                        print("IL Y A VRAIMENT AUCUN VEHICULE AUTOUR DE VOUS")
                    end
                end
            end
        }
    }
}

Administration.IndexListTeleportAdmin = 1;
Administration.oneFrameCallGroup = false;
Administration.InCallMenuPlayers, Administration.onlinePlayers = false, 0;
Administration.callPlayers = function(type, playerId)
    TriggerServerCallback(Config.ServerName.. ":getPlayers", function(players, playersOnline)
        if type == "All" then
            Administration.Players = {}
            Administration.Players = players;
            Administration.onlinePlayers = playersOnline;
        elseif type == "one" then
            Administration.OnePlayerData = {}
            Administration.OnePlayerData = players;
            Administration.onlinePlayers = playersOnline;
        end
    end, type, playerId)
end

local openinventory = false
local InventoryMenu = RageUI.CreateMenu("Inventaire", Config.ServerName.. " Main")
InventoryMenu.Closed = function()
    openinventory = false
end

local Inventory = RageUI.CreateSubMenu(InventoryMenu, "Inventaire", Config.ServerName.. " Inventaire")
local Inventory_use = RageUI.CreateSubMenu(Inventory, "Inventaire", Config.ServerName.. " Utilisation")
local Wallet = RageUI.CreateSubMenu(Inventory, "Portefeuille", Config.ServerName.. " Poches")
local ManageVeh = RageUI.CreateSubMenu(InventoryMenu,"Véhicule", Config.ServerName.. " Gestion Véhicule")
local VariousMenu = RageUI.CreateSubMenu(InventoryMenu,"Divers", Config.ServerName.. " Options supplémentaire")

Administration.mainAdminMenu = RageUI.CreateSubMenu(InventoryMenu, "Admin", Config.ServerName.. " Administration")
Administration.mainAdminMenu:SetRectangleBanner(245, 133, 73, 70)

Administration.playerListMainMenu = RageUI.CreateSubMenu(Administration.mainAdminMenu, "Joueurs", Config.ServerName.. " Joueurs connecté")
Administration.playerListMainMenu.Closed = function() Administration.InCallMenuPlayers = false; end
Administration.playerListMainMenu:DisplayPageCounter(true)
Administration.playerListMainMenu:SetRectangleBanner(245, 133, 73, 70)

Administration.playerOptionsMain = RageUI.CreateSubMenu(Administration.playerListMainMenu, "Options", Config.ServerName.. " Intéractions")
Administration.playerOptionsMain:DisplayPageCounter(true)
Administration.playerOptionsMain:SetRectangleBanner(245, 133, 73, 70)
Administration.playerOptionsMain.Closed = function()
    Administration.callPlayers("All")
end

Administration.subMainInfosPlayerData = RageUI.CreateSubMenu(Administration.playerOptionsMain, "Infos", Config.ServerName.. " Informations")
Administration.subMainInfosPlayerData:DisplayPageCounter(true)
Administration.subMainInfosPlayerData:SetRectangleBanner(245, 133, 73, 70)
Administration.subMainInfosPlayerData.Closed = function()
    Administration.oneFrameCallGroup = false;
end
Administration.personalAdminMain = RageUI.CreateSubMenu(Administration.mainAdminMenu, "Personnel", Config.ServerName.. " Personnal admin actions")

local weight, engineActionIndex, engineCoolDown, doorActionOpenIndex = 0, 1, false, 1;
local IdentityTable = {}

local DoorListActions = {
    {Name = "Avant Gauche", Value = 0},
    {Name = "Avant Droite", Value = 1},

    {Name = "Derrière Droite", Value = 2},
    {Name = "Derrière Droite", Value = 3},
}

local PersonalActions = {
    Index = 1,
    List = {"-", "Équipement"}
}

local CurrentWeapon = nil
local Weapons, Items = true, true

RegisterNetEvent("aFrw:getWeight")
AddEventHandler("aFrw:getWeight", function(wght)
    weight = wght
end)

function openInventoryMenu()
    if openinventory == false then
        if openinventory then
            openinventory = false
            RageUI.Visible(InventoryMenu, false)
        else
            openinventory = true
            RageUI.Visible(InventoryMenu, true)
            Player:getInventory()
            CreateThread(function()
                while openinventory do 
                    Administration.waitToGoSleep = 5000
                    if Administration.InCallMenuPlayers == true then
                        Administration.callPlayers("All")
                        Administration.playerListMainMenu:SetPageCounter(tostring(Administration.onlinePlayers).."/"..tostring(Config.PlayersMax))
                    else
                        Administration.waitToGoSleep = 6000
                    end
                    Wait(Administration.waitToGoSleep)
                end
            end)
            CreateThread(function()
                while openinventory do
                    RageUI.IsVisible(InventoryMenu, function()
                        RageUI.Button("Inventaire", nil, {RightLabel = "→"}, true, {}, Inventory)
                        RageUI.Button("Gestion Vehicule", nil, {RightLabel = "→"}, IsPedInAnyVehicle(Player:Ped(), false), {}, ManageVeh)
                        RageUI.Button("Administration", false, {RightLabel = "→"}, Player:getGroup() == "admin" or Player:getGroup() == "sadmin" or Player:getGroup() == "dev", {}, Administration.mainAdminMenu)
                    end)

                    RageUI.IsVisible(Inventory, function()
                        RageUI.Button("Portefeuille", nil, {RightLabel = "→"}, true, {}, Wallet)
                        RageUI.SliderProgress('Faim', Player:getStatus().hunger, 100, description, {
                            ProgressBackgroundColor = { R = 0, G = 0, B = 0, A = 200 },
                            ProgressColor = { R = 0, G = 255, B = 0, A = 255 },
                        }, true, {})
                        RageUI.SliderProgress('Soif', Player:getStatus().water, 100, description, {
                            ProgressBackgroundColor = { R = 0, G = 0, B = 0, A = 200 },
                            ProgressColor = { R = 0, G = 160, B = 255, A = 255 },
                        }, true, {})
                        
                        RageUI.Separator("~o~"..math.floor(weight).."~s~/~o~"..Config.Weight.."KG")
                        RageUI.List('Filtre', PersonalActions.List, PersonalActions.Index, nil, {}, true, {
                            onListChange = function(Index)
                                PersonalActions.Index = Index
                                if Index == 1 then 
                                    Items = true
                                    Weapons = true
                                elseif Index == 2 then 
                                    Items = false
                                    Weapons = true
                                elseif Index == 3 then 
                                    Items = false
                                    Weapons = false
                                end
                            end
                        })

                        if Weapons and Items then
                            for k,v in pairs(Player:getInventory()) do
                                if Config.Items[v.name].type == 1 then 
                                    RageUI.Button("• "..v.label, false, {RightLabel = "~b~Utiliser~s~ →→"}, true, {
                                        onSelected = function()
                                            useItem(v.name)
                                            CurrentWeapon = v.name
                                        end
                                    })
                                else
                                    RageUI.Button("• "..v.label, false, {RightLabel = "Quantité : x~r~"..v.count}, true, {
                                        onSelected = function()
                                            item_name = v.name
                                            item_label = v.label 
                                        end
                                    }, Inventory_use)
                                end
                            end
                        elseif Weapons then 
                            for k,v in pairs(Player:getInventory()) do
                                if Config.Items[v.name].type == 1 then 
                                    RageUI.Button("• "..v.label, false, {RightLabel = "~b~Utiliser~s~ →→"}, true, {
                                        onSelected = function()
                                            useItem(v.name)
                                            CurrentWeapon = v.name
                                        end
                                    })
                                end
                                if Config.Items[v.name].label == "Boite de munitions" then 
                                    RageUI.Button("• "..v.label, false, {RightLabel = "Quantité : x~r~"..v.count}, true, {
                                        onSelected = function()
                                            item_name = v.name
                                            item_label = v.label 
                                        end
                                    }, Inventory_use)
                                end
                            end
                        end
                    end)

                    RageUI.IsVisible(Wallet, function()
                        RageUI.Button("Métier : ~b~"..GetJobLabel(Player:getJob()), false, {}, true, {})
                        grade = tonumber(Player:getJobGrade())
                        RageUI.Button("Grade : ~b~"..GetJobGrade(Player:getJob(), grade), false, {}, true, {})
                        RageUI.Button("Argent liquide : ~g~"..Player:getMoney().."$", false, {}, true, {})
                        RageUI.Button("Solde bancaire : ~b~"..Player:getBankMoney().."$", false, {}, true, {})
                        RageUI.Button("Regarder votre pièce d'identité", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                TriggerEvent(Config.ServerName.. "ShowYourIDCardForPlayer", {
                                    firstname = Player:getIdentity().prenom, 
                                    lastname = Player:getIdentity().nom, 
                                    height = Player:getIdentity().taille, 
                                    ddn = Player:getIdentity().ddn
                                })
                            end
                        })
                        RageUI.Button("Montrer votre pièce d'identité", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                IdentityTable = {
                                    firstname = Player:getIdentity().prenom,
                                    lastname = Player:getIdentity().nom,
                                    height = Player:getIdentity().taille,
                                    ddn = Player:getIdentity().ddn
                                }
                                local closestPlayer, closestDistance = LDC.GetClosestPlayer()
                                if closestPlayer ~= -1 and closestDistance <= 3 then
                                    TriggerServerEvent(Config.ServerName.. "ShowIdentity", GetPlayerServerId(closestPlayer), IdentityTable)
                                else
                                    Visual.Popup({message="~r~Aucune personne(s) à proximité"})
                                end                        
                            end
                        })
                    end)

                    RageUI.IsVisible(Inventory_use, function()
                        RageUI.Button("Utiliser", nil, {}, true, {
                            onSelected = function()
                                if item_name == "ammobox" then 
                                    AddAmmoToPed(Player:Ped(), GetHashKey(CurrentWeapon), 25)
                                    TriggerServerEvent("aFrw:UseAmmoBox", "ammobox")
                                else
                                    useItem(item_name)
                                end
                                RageUI.GoBack()
                            end
                        })

                        RageUI.Button("Donner", nil, {}, true, {
                            onSelected = function()
                                local closestPlayer, closestDistance = LDC.GetClosestPlayer()
                                if closestPlayer ~= -1 and closestDistance <= 3 then
                                    local count = KeyboardInput("NumberOfDropToPlayerItem", "Combien souhaitez-vous donner ?", "", 2)
                                    TriggerServerEvent("aFrw:DropItemToPlayer", GetPlayerServerId(closestPlayer), item_name, math.floor(tonumber(count)))
                                else
                                    Visual.Popup({message="~r~Aucune personne(s) à proximité"})
                                end    
                            end
                        })
                        RageUI.Button("Jeter", nil, {}, true, {
                            onSelected = function()
                                if (Config.Items[item_name].props) then
                                    TriggerServerEvent(Config.ServerName.. ":newItemPickup", {
                                        type = "add",
                                        objectName = Config.Items[item_name].props,
                                        itemLabel = item_label,
                                        itemQuantity = 1
                                    })
                                end
                            end
                        })
                    end)
                    RageUI.IsVisible(ManageVeh, function()
                        if LDC.get.getVehiclePedsIn() ~= 0 then
                            RageUI.List("Action moteur", {"Allumer","Eteindre"}, engineActionIndex, nil, {}, not engineCoolDown, {
                                onListChange = function(Index)
                                    
                                        local veh = GetVehiclePedIsIn(Player:Ped(), false)
                                        if Index == 1 then
                                            SetVehicleEngineOn(GetVehiclePedIsIn(Player:Ped(),false),true,true,false)
                                            SetVehicleUndriveable(GetVehiclePedIsIn(PlayerPedId(), false), true)
                                        else
                                            SetVehicleEngineOn(GetVehiclePedIsIn(Player:Ped(),false),false,true,true)
                                            SetVehicleUndriveable(GetVehiclePedIsIn(PlayerPedId(), false), false)
                                        end
                                        engineCoolDown = true
                                        SetTimeout(1000, function()
                                            engineCoolDown = false
                                        end)
                                    engineActionIndex = Index
                                end
                            })

                            RageUI.List("Ouvrir Portes", DoorListActions, doorActionOpenIndex, nil, {}, true, {
                                onListChange = function(Index)
                                    if doorActionOpenIndex ~= Index then
                                        doorActionOpenIndex = Index;
                                    end
                                end,
                                onSelected = function(Index, Button)
                                    local myVehicle = LDC.get.getVehiclePedsIn()
                                    if (myVehicle ~= 0) then
                                        SetVehicleDoorOpen(myVehicle, Button.Value, true, true)
                                    else
                                        print("aucun véhicule")
                                    end
                                end
                            })
                        else
                            RageUI.GoBack()
                        end
                    end)
                    RageUI.IsVisible(Administration.mainAdminMenu, function()
                        RageUI.Checkbox("Status", false, Administration.checkboxStatus, {}, {
                            onChecked = function()
                            end,
                            onUnChecked = function()
                            end,
                            onSelected = function(Index)
                                Administration.checkboxStatus = Index
                            end
                        })

                        RageUI.Button("Joueurs", nil, {RightLabel = "→→"}, Administration.checkboxStatus, {
                            onSelected = function() Administration.callPlayers("All") Administration.InCallMenuPlayers = true; end
                        }, Administration.playerListMainMenu)

                        RageUI.Button("Intéractions", nil, {RightLabel = "→→"}, Administration.checkboxStatus, {}, Administration.personalAdminMain)
                    end)

                    RageUI.IsVisible(Administration.playerListMainMenu, function()
                        if (Administration.Players) then
                            for index, keys in pairs (Administration.Players) do
                                RageUI.Button(keys.name.prenom, nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        Administration.callPlayers("one", keys.playerId)
                                    end
                                }, Administration.playerOptionsMain)
                            end
                        end
                    end)

                    RageUI.IsVisible(Administration.playerOptionsMain, function()
                        PlayerData = Administration.OnePlayerData;

                        RageUI.Button("Informations", nil, {}, true, {
                        }, Administration.subMainInfosPlayerData)

                        RageUI.List("Téléportation", {{Name = "Sur moi"}, {Name = "Sur lui"}}, Administration.IndexListTeleportAdmin, nil, {}, true, {
                            onListChange = function(Index)
                                if Administration.IndexListTeleportAdmin ~= Index then
                                    Administration.IndexListTeleportAdmin = Index
                                end
                            end,
                            onSelected = function(Index, Button)
                                if Button.Name == "Sur moi" then
                                    TriggerServerEvent(Config.ServerName.. ":playerAdminActions", {
                                        type = "TeleportOnMe",
                                        playerId = PlayerData.playerId,                                       
                                    })
                                elseif Button.Name == "Sur lui" then

                                end
                            end
                        })
                    end)

                    RageUI.IsVisible(Administration.subMainInfosPlayerData, function()
                        if (Administration.OnePlayerData) then
                            if Administration.oneFrameCallGroup == false then
                                PlayerData = Administration.OnePlayerData;
                                if PlayerData.group == "dev" then 
                                    PlayerData.group = "~r~Developper~s~" 
                                elseif PlayerData.group == "player" then 
                                    PlayerData.group = "~c~Joueur~s~"
                                elseif PlayerData.group == "admin" then 
                                    PlayerData.group = "~p~Admin~s~"
                                elseif PlayerData.group == "sadmin" then 
                                    PlayerData.group = "~o~Super Admin~s~"
                                end
                                Administration.oneFrameCallGroup = true;
                            end

                            RageUI.Separator(PlayerData.name.prenom.. " " ..PlayerData.name.nom.. " - " ..PlayerData.name.taille.. "cm - " ..PlayerData.name.ddn)
                            RageUI.Button("Liquide ~g~" ..PlayerData.money.. "$~s~", nil, {RightLabel = "Banque ~b~" ..PlayerData.bank_money.. "$~s~"}, true, {})
                            RageUI.Button("Groupe", nil, {RightLabel = PlayerData.group}, true, {})

                            RageUI.SliderProgress("Faim", PlayerData.status.hunger, 100, nil, {
                                ProgressBackgroundColor = { R = 0, G = 0, B = 0, A = 200 },
                                ProgressColor = { R = 0, G = 255, B = 0, A = 255 },
                            }, true, {})

                            RageUI.SliderProgress("Soif", PlayerData.status.water, 100, nil, {
                                ProgressBackgroundColor = { R = 0, G = 0, B = 0, A = 200 },
                                ProgressColor = { R = 0, G = 160, B = 255, A = 255 },
                            }, true, {})
                        end
                    end)

                    RageUI.IsVisible(Administration.personalAdminMain, function()
                        RageUI.Separator("~o~Intéractions~s~")

                        RageUI.List("Véhicules", Administration.ActionsVehicles, Administration.vehicleActionsIndex, nil, {}, true, {
                            onListChange = function(Index)
                                Administration.vehicleActionsIndex = Index
                            end,
                            onSelected = function(i, Button)
                                if Button.action and type(Button.action) == "function" then
                                    Button.action()
                                end
                            end
                        })

                        RageUI.Checkbox("Noclip", nil, Administration.checkboxNoclip, {}, {
                            onChecked = function()
                                NoClip()
                            end,
                            onUnChecked = function()
                                NoClip()
                            end,
                            onSelected = function(Index)
                                Administration.checkboxNoclip = Index
                            end
                        })
                    end)
                    Wait(0)
                end
            end)
        end
    end
end

Keys.Register("F5", "F5", "personal menu", openInventoryMenu)

RegisterNetEvent(Config.ServerName.. ":playerClientAdminActions")
AddEventHandler(Config.ServerName.. ":playerClientAdminActions", function(setting)
    if setting.type == "teleport" then
        SetEntityCoords(PlayerPedId(), setting.pos.x, setting.pos.y, setting.pos.z)
        local ground, zGround = GetGroundZFor_3dCoord(setting.pos.x, setting.pos.y, setting.pos.z, true, 0)
        if (ground) then SetEntityCoordsNoOffset(PlayerPedId(), setting.pos.x, setting.pos.y, zGround + 1.0, 0.0, 0.0, 0.0) end
    end
end)