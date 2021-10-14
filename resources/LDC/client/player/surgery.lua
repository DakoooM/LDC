local opensurgery = false
SurgeryMenu = RageUI.CreateMenu("Chirurgie", "~b~Changez votre visage")
SurgerySubMenu = RageUI.CreateSubMenu(SurgeryMenu, "Chirurgie", "aFramework")
SurgerySubMenu.Closable = false
SurgeryMenu.EnableMouse = false

AfterSurgeryPlayer = {}
SurgerySettings = {
    IndexPayment = 1,
}

local actionMother, actionFather, actionRessemblance, actionSkin = 1, 1, 5, 5
local Visage1, Visage2, ShapeMixData, SkinMixData, ageingIndex = 1, 1, 0.5, 0.5, 1

function OpenSurgeryMenu()
    if opensurgery == false then
        local colorVar = "~s~"
        CreateThread(function()
            while opensurgery do
                Wait(800)
                if colorVar == "~s~" then colorVar = "~b~" else colorVar = "~s~" end
            end
        end)
        local colorVar2 = "~s~"
        CreateThread(function()
            while opensurgery do
                Wait(800)
                if colorVar2 == "~s~" then colorVar2 = "~y~" else colorVar2 = "~s~" end
            end
        end)
        if opensurgery then 
            opensurgery = false 
            RageUI.Visible(SurgeryMenu,false)
            return
        else
            opensurgery = true 
            RageUI.Visible(SurgeryMenu, true)
            Citizen.CreateThread(function ()
                while opensurgery do 
                RageUI.IsVisible(SurgeryMenu, function()
                    RageUI.Button("Parler au Chirurgien", false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                FreezeEntityPosition(Player:Ped(), true)
                                SetEntityCoords(Player:Ped(), 408.17, -365.60, 46.0)
                                SetEntityHeading(GetPlayerPed(-1), 30.0)
                                local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 407.38, -364.43, 47.6, -5.0, 0.0, 215.0, 20.0, false, 0)
                                SetCamActive(cam, true)
                                RenderScriptCams(true, false, 2000, true, true) 
                                DisplayRadar(false)
                            end
                        }, SurgerySubMenu)
                    end)
                    
                    RageUI.IsVisible(SurgerySubMenu, function()
                        RageUI.Separator("← "..colorVar.."Chirurgie : Visage°...~s~ →")
                        RageUI.List('Visage 1 :', {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21"}, actionMother, false, {}, true, {
                            onListChange = function(Index)
                                actionMother = Index
                                Visage1 = Index
                                SetPedHeadBlendData(Player:Ped(), Visage1, Visage2, nil, Visage1, Visage2, nil, ShapeMixData, SkinMixData, nil, true)
                            end
                        })
                        RageUI.List('Visage 2 :', {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"}, actionFather, false, {}, true, {
                            onListChange = function(Index)
                                actionFather = Index
                                Visage2 = Index
                                SetPedHeadBlendData(Player:Ped(), Visage1, Visage2, nil, Visage1, Visage2, nil, ShapeMixData, SkinMixData, nil, true)
                            end
                        })
                        RageUI.Separator("← "..colorVar2.."Chirurgie : Perfections...~s~ →")
                        RageUI.UISliderHeritage('Ressemblance :', actionRessemblance, false, {
                            onSliderChange = function(Float, Index)
                                actionRessemblance = Index
                                ShapeMixData = Index/10
                                SetPedHeadBlendData(Player:Ped(), Visage1, Visage2, nil, Visage1, Visage2, nil, ShapeMixData, SkinMixData, nil, true)
                            end
                        })                      
                        RageUI.UISliderHeritage('Teint de la peau :',actionSkin, false, {
                            onSliderChange = function(Float, Index)
                                actionSkin = Index
                                SkinMixData = Index/10
                                SetPedHeadBlendData(Player:Ped(), Visage1, Visage2, nil, Visage1, Visage2, nil, ShapeMixData, SkinMixData, nil, true)
                            end
                        })
                        RageUI.List('Rides :', {"1","2","3","4","5","6","7","8","9","10","11","12","13","14", "0"}, ageingIndex or 1, nil, {}, true, {
                            onListChange = function(Index)
                                ageingIndex = Index
                                SetPedHeadOverlay(Player:Ped(), 3, ageingIndex, 1.0)
                            end
                        })
                        RageUI.Separator("← "..colorVar.."Chirurgie : Payement...~s~ →")
                        RageUI.Separator("~g~Prix de la Chirurgie: 5000$")
                        RageUI.Button("Valider et payer" , false, { Color = { BackgroundColor = { 0, 140, 0, 160 } } }, true, {
                            onSelected = function()
                                AfterSurgeryPlayer = {
                                    mom = Visage1,
                                    dad = Visage2,
                                    resem = ShapeMixData,
                                    face = SkinMixData,
                                    ageing = ageingIndex
                                }
                                if SurgerySettings.IndexPayment == 1 then 
                                    TriggerServerEvent("aFrw:BuyAtSurgery", AfterSurgeryPlayer, 5000, 1)
                                end
                                Wait(250)
                                AfterSurgeryPlayer = {}
                                Visage1 = 1
                                Visage2 = 1
                                ShapeMixData = 1
                                SkinMixData = 1
                                ageingIndex = 1
                                destorycam()
                                LDC.loadSkin()
                                opensurgery = false
                                FreezeEntityPosition(Player:Ped(), false)
                            end
                        })
                        RageUI.Button("Annuler" , false, { Color = { BackgroundColor = { 255, 0, 0, 160 } } }, true, {
                            onSelected = function()
                                DisplayRadar(true)
                                destorycam()
                                LDC.loadSkin()
                                opensurgery = false
                                FreezeEntityPosition(Player:Ped(), false)
                            end
                        })
                    end)
                    Wait(0)
                end
            end)
        end
    end
end