Character = {}
CharacterClothes = {}
identite = {}
CharCreator = {
    ClothesList = {"Chic"},
    ClothesIndex = 1,
    Sexe = {"Masculin", "Féminin"},
    SexIndex = 1,
    List = {"Homme","Femme"},
    Index = 1,
    hairIndex = 1,
    hairColorIndex = {1, 1},
    beardsIndex = 1,
    beardsColorIndex = {1, 1},
    eyesbrowsIndex = 1,
    eyesbrowsColorIndex = {1, 1},
    bodyblemishesIndex = 1,
    ageingIndex = 1,
    sundamageIndex = 1,
    makeupIndex = 1,
    lipstickIndex = 1,
    lipstickColorIndex = {1, 1},
}

local MotherListCreator = { "Hannah", "Aubrey", "Jasmine", "Gisele", "Amelia", "Isabella", "Zoe", "Ava", "Camila", "Violet", "Sophia", "Evelyn", "Nicole", "Ashley", "Gracie", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma" }
local FatherListCreator = { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony",  "Claude", "Niko" }  

local actionMother, actionFather, actionRessemblance, actionSkin = 1, 1, 5, 5
local MomCharacter, DadCharacter, ShapeMixData, SkinMixData = 1, 1, 0.5, 0.5

CharCreatorMenu = RageUI.CreateMenu("CharCreator", "aFramework")
CharCreatorMenu:SetRectangleBanner(15, 15, 15, 200)
CharSexMenu = RageUI.CreateSubMenu(CharCreatorMenu, "CharCreator", "aFramework")
CharSexMenu:SetRectangleBanner(15, 15, 15, 200)
CharHeritageMenu = RageUI.CreateSubMenu(CharCreatorMenu, "CharCreator", "aFramework")
CharHeritageMenu:SetRectangleBanner(15, 15, 15, 200)
CharFaceMenu = RageUI.CreateSubMenu(CharCreatorMenu, "CharCreator", "aFramework")
CharFaceMenu:SetRectangleBanner(15, 15, 15, 200)
CharIdentityMenu = RageUI.CreateSubMenu(CharCreatorMenu, "CharCreator", "aFramework")
CharIdentityMenu:SetRectangleBanner(15, 15, 15, 200)
charclothesmenu = RageUI.CreateSubMenu(CharCreatorMenu, "CharCreator", "aFramework")
charclothesmenu:SetRectangleBanner(15, 15, 15, 200)
CharCreatorMenu.Closable = false
CharFaceMenu.EnableMouse = true
CharCreatorMenu.Closed = function()
    open = false
end

Character = {}

local IsDateGood = function(date)
    if (string.match(date, "^%d+%p%d+%p%d%d%d%d$")) then
        local d, m, y = string.match(date, "(%d+)%p(%d+)%p(%d+)")
        d, m, y = tonumber(d), tonumber(m), tonumber(y)
        local dm2 = d*m*m
        if  d>31 or m>12 or dm2==0 or dm2==116 or dm2==120 or dm2==124 or dm2==496 or dm2==1116 or dm2==2511 or dm2==3751 then
            if dm2==116 and (y%400 == 0 or (y%100 ~= 0 and y%4 == 0)) then
                return true
            else
                return false
            end
        else
            return true
        end
    else
        return false
    end
end


function loadCharCreator()
    if open then
        open = false
        RageUI.Visible(CharCreatorMenu, false)
    else
        LDC.setPlayerModel("mp_m_freemode_01")
        Player:Teleport(Player:Ped(), {-62.45, -811.00, 242.38})
        SetEntityHeading(Player:Ped(), 160.0)
        DoScreenFadeOut(500)
        Wait(600)
        DisplayRadar(false)
        while not HasCollisionLoadedAroundEntity(Player:Ped()) do
            Wait(1)
        end
        CreateCamOnPos("CreatorCam", vector3(-63.47, -813.89, 243.5), vector3(-62.45, -811.00, 243.40), 45.0, false, 2200)
        DisplayRadar(false)
        Wait(3000)
        open = true
        FixPlayerActions = true
        RageUI.Visible(CharCreatorMenu, true)
        FreezeEntityPosition(Player:Ped(), true)
        DoScreenFadeIn(1000)  
        CreateThread(function()
            while open do
                FixPlayer()
                RageUI.IsVisible(CharCreatorMenu, function()
                    RageUI.Separator("  ↓ ~b~Création du personnage~s~ ↓")
                    RageUI.Button("                          ← Genre(s) →", false, {}, true, {}, CharSexMenu)
                    RageUI.Button("                          ← Héritage →", false, {}, true, {}, CharHeritageMenu)
                    RageUI.Button("                           ← Visage →", false, {}, true, {}, CharFaceMenu)
                    RageUI.Button("                      ← Vestimentaire →", false, {}, true, {}, charclothesmenu)
                    RageUI.Button("                   ← Création d'Identité →", false, {Color = {BackgroundColor = {255, 151, 0}}}, true, {},CharIdentityMenu)         
                    RageUI.Button("                      Valider la création", false, {Color = {HightLightColor = {0, 155, 0, 150}, BackgroundColor = {38, 85, 150, 160}}}, true, {
                        onSelected = function()
                            if identite["nom"] == nil then
                                Visual.Popup({message="Veuillez entrer votre nom"})
                            elseif identite["prenom"] == "" then
                                Visual.Popup({message="Veuillez entrer un prenom"})
                            elseif identite["taille"] == "" then
                                Visual.Popup({message="Veuillez entrer une taille"})
                            elseif ddn == "" then
                                Visual.Popup({message="Veuillez entrer une date de naissance"})
                            end
                            if identite["nom"] and identite["prenom"] and identite["taille"] and ddn then
                                Character["sex"] = CharCreator.Index
                                Character["mom"] = MomCharacter
                                Character["dad"] = DadCharacter
                                Character["resem"] = ShapeMixData
                                Character["face"] = SkinMixData
                                Character["eyesColor"] = eyesIndex
                                Character["hair"] = CharCreator.hairIndex
                                Character["hairColor"] = CharCreator.hairColorIndex[2]
                                Character["beard"] = beardsIndex
                                Character["beardColor"] = CharCreator.beardsColorIndex[2]
                                Character["eyesbrow"] = eyesbrowsIndex
                                Character["eyesbrowColor"] = CharCreator.eyesbrowsColorIndex[2]
                                Character["ageing"] = ageingIndex
                                Character["blemishes"] = bodyblemishesIndex
                                Character["sundamage"] = sundamageIndex
                                Character["makeup"] = makeupIndex
                                Character["lipstick"] = lipstickIndex
                                Character["lipstickColor"] = CharCreator.lipstickColorIndex[2]
                                TriggerServerEvent('aFrw:AddPlayerIntoDatabase', Character, CharacterClothes, identite, {status = {hunger = 100, water = 100}})
                            end    
                            DoScreenFadeOut(500)
                            Wait(600)
                            DisplayRadar(true)
                            DestroyCamera("CreatorCam")
                            open = false
                            FixPlayerActions = false
                            Player:Teleport(Player:Ped(), {-66.55, -801.91, 44.22})
                            SetEntityHeading(Player:Ped(), 240.0)
                            FreezeEntityPosition(Player:Ped(), false)
                            Wait(1000)
                            DoScreenFadeIn(1000)  
                        end
                    })
                end)
                RageUI.IsVisible(CharSexMenu, function()
                    RageUI.Separator("↓ ~b~Genre(s)~s~ ↓")
                    RageUI.List('Liste des Genres :', CharCreator.List, CharCreator.Index, nil, {}, true, {
                        onListChange = function(Index)
                            CharCreator.Index = Index
                            if Index == 1 then
                                LDC.setPlayerModel("mp_m_freemode_01")
                            elseif Index == 2 then
                                LDC.setPlayerModel("mp_f_freemode_01")
                            end
                        end
                    })
                end)
                RageUI.IsVisible(CharHeritageMenu, function()
                    RageUI.Separator("↓ ~b~Héritage~s~ ↓")
                    RageUI.Window.Heritage(MomCharacter, DadCharacter)
                    RageUI.List('Choix de la mère :', MotherListCreator, actionMother, false, {}, true, {
                        onListChange = function(Index)
                            actionMother = Index
                            MomCharacter = Index
                            SetPedHeadBlendData(Player:Ped(), MomCharacter, DadCharacter, nil, MomCharacter, DadCharacter, nil, ShapeMixData, SkinMixData, nil, true)
                        end
                    })
                    RageUI.List('Choix du père :',FatherListCreator, actionFather, false, {}, true, {
                        onListChange = function(Index)
                            actionFather = Index
                            DadCharacter = Index
                            SetPedHeadBlendData(Player:Ped(), MomCharacter, DadCharacter, nil, MomCharacter, DadCharacter, nil, ShapeMixData, SkinMixData, nil, true)
                        end
                    })
                    RageUI.UISliderHeritage('Ressemblance :', actionRessemblance, false, {
                        onSliderChange = function(Float, Index)
                            actionRessemblance = Index
                            ShapeMixData = Index/10
                            SetPedHeadBlendData(Player:Ped(), MomCharacter, DadCharacter, nil, MomCharacter, DadCharacter, nil, ShapeMixData, SkinMixData, nil, true)
                        end
                    })                      
                    RageUI.UISliderHeritage('Teint de la peau :',actionSkin, false, {
                        onSliderChange = function(Float, Index)
                            actionSkin = Index
                            SkinMixData = Index/10
                            SetPedHeadBlendData(Player:Ped(), MomCharacter, DadCharacter, nil, MomCharacter, DadCharacter, nil, ShapeMixData, SkinMixData, nil, true)
                        end
                    })
                end)
                RageUI.IsVisible(CharFaceMenu, function()
                    RageUI.Separator("↓ ~b~Apparence du visage~s~ ↓")
                    RageUI.List("Couleur des yeux", {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33"}, eyesIndex or 1, nil, {}, true, {
                        onListChange = function(Index, Items)
                            eyesIndex = Index
                            SetPedEyeColor(Player:Ped(), eyesIndex, 0, 1)
                        end
                    })
                    RageUI.List('Liste des coiffures :', {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"}, CharCreator.hairIndex or 1, nil, {}, true, {
                        onListChange = function(Index)
                            CharCreator.hairIndex = Index
                            SetPedComponentVariation(Player:Ped(), 2, CharCreator.hairIndex, 1)
                        end
                    })
                    RageUI.List('Liste des Barbes :', {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28", "29"}, beardsIndex or 1, nil, {}, true, {
                        onListChange = function(Index)
                            beardsIndex = Index
                            SetPedHeadOverlay(Player:Ped(), 1, beardsIndex, 1.0)
                        end
                    })
                    RageUI.List('Liste des Sourcils :', {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34"}, eyesbrowsIndex or 1, nil, {}, true, {
                        onListChange = function(Index)
                            eyesbrowsIndex = Index
                            SetPedHeadOverlay(Player:Ped(), 2, eyesbrowsIndex, 1.0)
                        end
                    })
                    RageUI.List('Rides :', {"1","2","3","4","5","6","7","8","9","10","11","12","13","14"}, ageingIndex or 1, nil, {}, true, {
                        onListChange = function(Index)
                            ageingIndex = Index
                            SetPedHeadOverlay(Player:Ped(), 3, ageingIndex, 1.0)
                        end
                    })
                    RageUI.List('Imperfections Corporel :', {"1","2","3","4","5","6","7","8","9","10","11"}, bodyblemishesIndex or 1, nil, {}, true, {
                        onListChange = function(Index)
                            bodyblemishesIndex = Index
                            SetPedHeadOverlay(Player:Ped(), 11, bodyblemishesIndex, 1.0)
                        end
                    })
                    RageUI.List('Dommage Solaire :', {"1","2","3","4","5","6","7","8","9","10"}, sundamageIndex or 1, nil, {}, true, {
                        onListChange = function(Index)
                            sundamageIndex = Index
                            SetPedHeadOverlay(Player:Ped(), 7, sundamageIndex, 1.0)
                        end
                    })
                    RageUI.List('Maquillage :', {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","0"}, makeupIndex or 1, nil, {}, true, {
                        onListChange = function(Index)
                            makeupIndex = Index
                            SetPedHeadOverlay(Player:Ped(), 4, makeupIndex, 1.0)
                        end
                    })
                    RageUI.List('Rouge à Lèvres :', {"1","2","3","4","5","6","7","8","9","0"}, lipstickIndex or 1, nil, {}, true, {
                        onListChange = function(Index)
                            lipstickIndex = Index
                            SetPedHeadOverlay(Player:Ped(), 8, lipstickIndex, 1.0)
                        end
                    })
                    RageUI.ColourPanel("Couleur principale", RageUI.PanelColour.HairCut, CharCreator.hairColorIndex[1], CharCreator.hairColorIndex[2], {
                        onColorChange = function(MinimumIndex, CurrentIndex)
                            CharCreator.hairColorIndex[1] = MinimumIndex   
                            CharCreator.hairColorIndex[2] = CurrentIndex      
                            SetPedHairColor(Player:Ped(), CurrentIndex, CurrentIndex)
                        end
                    }, 3)
                    RageUI.ColourPanel("Couleur principale", RageUI.PanelColour.HairCut, CharCreator.beardsColorIndex[1], CharCreator.beardsColorIndex[2], {
                        onColorChange = function(MinimumIndex, CurrentIndex)
                            CharCreator.beardsColorIndex[1] = MinimumIndex   
                            CharCreator.beardsColorIndex[2] = CurrentIndex      
                            SetPedHeadOverlayColor(Player:Ped(), 1, 1, CurrentIndex, CurrentIndex)

                        end
                    }, 4)
                    RageUI.ColourPanel("Couleur principale", RageUI.PanelColour.HairCut, CharCreator.eyesbrowsColorIndex[1], CharCreator.eyesbrowsColorIndex[2], {
                        onColorChange = function(MinimumIndex, CurrentIndex)
                            CharCreator.eyesbrowsColorIndex[1] = MinimumIndex   
                            CharCreator.eyesbrowsColorIndex[2] = CurrentIndex      
                            SetPedHeadOverlayColor(Player:Ped(), 2, 1, CurrentIndex, CurrentIndex)
                        end
                    }, 5)
                    RageUI.ColourPanel("Couleur principale", RageUI.PanelColour.MakeUp, CharCreator.lipstickColorIndex[1], CharCreator.lipstickColorIndex[2], {
                        onColorChange = function(MinimumIndex, CurrentIndex)
                            CharCreator.lipstickColorIndex[1] = MinimumIndex   
                            CharCreator.lipstickColorIndex[2] = CurrentIndex      
                            SetPedHeadOverlayColor(Player:Ped(), 8, 2, CurrentIndex, CurrentIndex)
                        end
                    }, 10)
                end)
                RageUI.IsVisible(charclothesmenu, function()
                    RageUI.Separator("↓ ~b~Vestimentaire~s~ ↓")
                    RageUI.List('Liste des tenues :', CharCreator.ClothesList, CharCreator.ClothesIndex, nil, {}, true, {
                        onListChange = function(Index)
                            CharCreator.ClothesIndex = Index
                            if Index == 1 then
                                LoadCharCreatorClothes(1)
                            end
                        end
                    })
                end)
                RageUI.IsVisible(CharIdentityMenu, function()
                    RageUI.Button("Nom: ", nil, { RightLabel = identite["nom"] }, true, {
                        onSelected = function()
                            local nom = KeyboardInput("ChangeName", "Entrer votre nom :", "", 20)
                            if nom ~= nil then
                                identite["nom"] = nom
                            end
                        end
                    })
                    RageUI.Button("Prenom: ", nil, { RightLabel = identite["prenom"] }, true, {
                        onSelected = function()
                            local prenom = KeyboardInput("ChangePrenom", "Entrer votre prenom :", "", 20)
                            if prenom ~= nil then
                                identite["prenom"] = prenom
                            end
                        end
                    })
                    RageUI.Button("Taille: ", nil, { RightLabel = identite["taille"] }, true, {
                        onSelected = function()
                            local taille = KeyboardInput("ChangeTaille", "Entrer votre taille :", "", 20)
                            local currentTaille = tonumber(taille)
                            if currentTaille ~= nil and type(currentTaille) == "number" then
                                identite["taille"] = currentTaille
                            else
                                print("Veuillez indiquer des nombres")
                            end
                        end
                    })
                    RageUI.Button("Date de naissance: ", nil, { RightLabel = ddn }, true, {
                        onSelected = function()
                            local ddnn = KeyboardInput("ChangeDDN", "Entrer votre date de naissance :", "", 20)
                            if ddnn ~= nil then
                                if IsDateGood(ddnn) then
                                    ddn = ddnn
                                    identite["ddn"] = ddnn
                                else
                                    print("votre date de naissance n'est pas bonne")
                                end
                            end
                        end
                    })
                    RageUI.List("Sexe:", CharCreator.Sexe, CharCreator.SexIndex, nil, {}, true, {
                        onListChange = function(Index, Item)
                            CharCreator.SexIndex = Index
                        end
                    })
                end)

                Wait(1)
            end
        end)
    end
end

RegisterNetEvent("aFrw:OpenIdentityMenu")
AddEventHandler("aFrw:OpenIdentityMenu", function()
    loadCharCreator()
end)

local ChooseMenu = RageUI.CreateMenu("Choix Personnage", "aFramework")
ChooseMenu.Closable = false

function loadChooseMenu()
    if open then
        open = false
        RageUI.Visible(ChooseMenu, false)
    else
        open = true
        LoadSkin()
        Player:Teleport(Player:Ped(), {-62.45, -811.00, 242.38})
        SetEntityHeading(Player:Ped(), 160.0)
        FreezeEntityPosition(Player:Ped(), true)
        DisplayRadar(false)
        SetMaxWantedLevel(0)
        ClearPlayerWantedLevel(Player:Ped())
        DoScreenFadeOut(500)
        Wait(600)
        while not HasCollisionLoadedAroundEntity(Player:Ped()) do
            Wait(1)
        end
        CreateCamOnPos("CreatorCam", vector3(-63.47, -813.89, 243.5), vector3(-62.45, -811.00, 243.40), 45.0, false, 2200)
        RageUI.Visible(ChooseMenu, true)
        Wait(1000)
        DoScreenFadeIn(1000)  
        CreateThread(function()
            while open do
                RageUI.IsVisible(ChooseMenu, function()
                    RageUI.Separator("↓ Identité ↓")
                    RageUI.Separator("[Nom - Prénom] : ~b~"..Player:getIdentity().nom.. "~s~ - ~b~"..Player:getIdentity().prenom)
                    RageUI.Separator("[Date de Naissance] : ~b~"..Player:getIdentity().ddn)
                    RageUI.Separator("[Métier] : ~b~"..GetJobLabel(Player:getJob()))
                    grade = tonumber(Player:getJobGrade())
                    RageUI.Separator("[Grade] : ~b~"..GetJobGrade(Player:getJob(), grade))
                    RageUI.Separator("↓ Autre(s) Informations ↓")
                    if Player:getGroup() ~= "player" then 
                        RageUI.Separator("[Groupe] : ~r~"..GetGroupLabel(Player:getGroup()))
                    end
                    if Player:getStatus().hunger > 1 and Player:getStatus().water > 1 then 
                        RageUI.Separator("[Status] : ~y~".. Player:getStatus().hunger.."%".."~s~ - ~b~"..Player:getStatus().water.."%")
                    else
                        RageUI.Separator("[Status] : ~r~Vous êtes décédé")
                    end
                    RageUI.Separator("[Argent liquide] : ~g~"..Player:getMoney().."$")
                    RageUI.Separator("[Solde bancaire] : ~b~"..Player:getBankMoney().."$")
                    RageUI.Button("Valider votre arrivée", false, {RightLabel = "→", Color = {HightLightColor = {38, 85, 150}}}, true, {
                        onSelected = function() 
                            FreezeEntityPosition(Player:Ped(), false)
                            open = false
                            DisplayRadar(true)
                            DestroyCamera("CreatorCam")
                            LoadPlayerData()
                        end 
                    })    
                end)
                Wait(1)
            end
        end)
    end
end