local openinventory = false
local InventoryMenu = RageUI.CreateMenu("Inventaire", Config.ServerName)
InventoryMenu.Closed = function()
    openinventory = false
end

local Inventory = RageUI.CreateSubMenu(InventoryMenu, "Inventaire", Config.ServerName)
local Inventory_use = RageUI.CreateSubMenu(Inventory, "Inventaire", Config.ServerName)
local Wallet = RageUI.CreateSubMenu(Inventory, "Portefeuille", Config.ServerName)
local LookIdentityCard = RageUI.CreateSubMenu(Wallet, "Identité", Config.ServerName)
local ManageVeh = RageUI.CreateSubMenu(InventoryMenu,"Gestion Véhicule", Config.ServerName)
local VariousMenu = RageUI.CreateSubMenu(InventoryMenu,"Divers", Config.ServerName)
local weight, engineActionIndex, engineCoolDown, doorActionOpenIndex, doorActionCloseIndex = 0, 1, false, 1, 1;
local IdentityTable = {}

local DoorListTable = {
    {Name = "Porte", Value = 1}
}

local PersonalActions = {
    ClothesActions = {"Équiper", "Enlever", "Donner", "Renommer"},
    ClothesIndex = 1,
    Index = 1,
    List = {"-", "Équipement"}
}

local CurrentWeapon = nil
local Weapons, Items, Clothes = true, true, true

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
            CreateThread(function()
                while openinventory do
                    RageUI.IsVisible(InventoryMenu, function()
                        RageUI.Button("Inventaire", nil, {RightLabel = "→"}, true, {}, Inventory)
                        RageUI.Button("Gestion Vehicule", nil, {RightLabel = "→"}, IsPedInAnyVehicle(Player:Ped(), false), {}, ManageVeh)
                    end)
                    RageUI.IsVisible(Inventory, function()
                        RageUI.Button("Portefeuille", nil, {RightLabel = "→"}, true, {}, Wallet)
                        RageUI.SliderProgress('Taux de faim : ', Player:getStatus().hunger, 100, description, {
                            ProgressBackgroundColor = { R = 0, G = 0, B = 0, A = 200 },
                            ProgressColor = { R = 0, G = 255, B = 0, A = 255 },
                        }, true, {})
                        RageUI.SliderProgress('Taux de soif : ', Player:getStatus().water, 100, description, {
                            ProgressBackgroundColor = { R = 0, G = 0, B = 0, A = 200 },
                            ProgressColor = { R = 0, G = 160, B = 255, A = 255 },
                        }, true, {})
                        
                        RageUI.Separator("Poids: ~o~"..math.floor(weight).."/"..Config.Weight.."KG")
                        RageUI.List('Filtre :', PersonalActions.List, PersonalActions.Index, nil, {}, true, {
                            onListChange = function(Index)
                                PersonalActions.Index = Index
                                if Index == 1 then 
                                    Items = true
                                    Weapons = true
                                    Clothes = true
                                elseif Index == 2 then 
                                    Items = false
                                    Weapons = true
                                    Clothes = false
                                elseif Index == 3 then 
                                    Items = false
                                    Weapons = false
                                    Clothes = true
                                end
                            end
                        })
                        if Weapons and Items and Clothes then
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
                                IdentityTable = {firstname = Player:getIdentity().prenom, lastname = Player:getIdentity().nom, height = Player:getIdentity().taille, ddn = Player:getIdentity().ddn}
                                TriggerServerEvent("aFrw:ShowIdentity", GetPlayerServerId(PlayerId()), IdentityTable)
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
                                    TriggerServerEvent("aFrw:ShowIdentity", GetPlayerServerId(closestPlayer), IdentityTable)
                                else
                                    Visual.Popup({message="~r~Aucune personne(s) à proximité"})
                                end                        
                            end
                        })
                    end)
                    RageUI.IsVisible(LookIdentityCard, function()
                        RageUI.Separator("↓ ~y~Pièce d'identité~s~ ↓")
                        RageUI.Separator("Nom : ~b~"..Player:getIdentity().nom.." ~s~Prénom : ~b~"..Player:getIdentity().prenom)
                        RageUI.Separator("Date de naissance : ~b~"..Player:getIdentity().ddn)
                        RageUI.Separator("Taille : ~b~"..Player:getIdentity().taille.."~s~cm")
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
                        RageUI.Button("Jeter", nil, {}, false, {})
                    end)
                    RageUI.IsVisible(ManageVeh, function()
                        if LDC.get.getVehiclePedsIn() ~= 0 then
                            RageUI.List("Action moteur", {"~g~Allumer~s~","~r~Eteindre~s~"}, engineActionIndex, nil, {}, not engineCoolDown, {
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
                            RageUI.List("Ouvrir Portes", DoorListTable, doorActionOpenIndex, nil, {}, true, {
                                onListChange = function(Index)
                                    if doorActionOpenIndex ~= Index then
                                        doorActionOpenIndex = Index;
                                    end
                                end,
                                onSelected = function(Index, Button)
                                    SetVehicleDoorOpen(myVehicle, Button.Value, false, true)
                                end
                            })
                        end
                    end)
                    Wait(1)
                end
            end)
        end
    end
end

Keys.Register("F5", "F5", "personal menu", function()
    Player:getInventory()
    openInventoryMenu()
end)