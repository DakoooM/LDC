local openmakeup = false
InstitutMenu = RageUI.CreateMenu("Institut de Beauté", Config.ServerName)
InstitutMenu.EnableMouse = true
InstitutMenu.Closed = function()
    openmakeup = false
    LDC.loadSkin()
end

AfterInstitutPlayer = {}
InstitutSettings = {
    IndexPayment = 1,
    Maquillage = 1,
    Rougealevre = 1,
    ColorRougealevre = {
        primary = { 1, 1 },
    },
}

function OpenInstitutMenu()
    if openmakeup == false then
        if openmakeup then 
            openmakeup = false 
            RageUI.Visible(InstitutMenu,false)
            return
        else
            openmakeup = true 
            RageUI.Visible(InstitutMenu, true)
            Citizen.CreateThread(function ()
                while openmakeup do 
                    RageUI.IsVisible(InstitutMenu, function()
                        RageUI.List("Moyen de paiement :", Config.DefaultPayment, InstitutSettings.IndexPayment, false, {}, true, {
                            onListChange = function(Index)
                                InstitutSettings.IndexPayment = Index
                            end
                        })
                        RageUI.List('Liste des maquillages :', {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","0"}, InstitutSettings.Maquillage, nil, {}, true, {
                            onListChange = function(Index)
                                InstitutSettings.Maquillage = Index
                                SetPedHeadOverlay(Player:Ped(), 4, InstitutSettings.Maquillage, 1.0)
                            end
                        })
                        RageUI.List('Liste des rouges à lèvres :', {"1","2","3","4","5","6","7","8","9","0"}, InstitutSettings.Rougealevre, nil, {}, true, {
                            onListChange = function(Index)
                                InstitutSettings.Rougealevre = Index
                                SetPedHeadOverlay(Player:Ped(), 8, InstitutSettings.Rougealevre, 1.0)
                            end
                        })
                        RageUI.Button("Valider et payer" , false, { Color = { BackgroundColor = { 0, 140, 0, 160 } } }, true, {
                            onSelected = function()
                                AfterInstitutPlayer = {
                                    makeup = InstitutSettings.Maquillage,
                                    lipstick = InstitutSettings.Rougealevre,
                                    lipstickColor = InstitutSettings.ColorRougealevre.primary[2]
                                }
                                if InstitutSettings.IndexPayment == 1 then 
                                    TriggerServerEvent("aFrw:BuyAtInstitut", AfterInstitutPlayer, 45, 1)
                                elseif InstitutSettings.IndexPayment == 2 then 
                                    TriggerServerEvent("aFrw:BuyAtInstitut", AfterInstitutPlayer, 45, 2)
                                end
                                Wait(250)
                                AfterInstitutPlayer = {}
                                InstitutSettings.Maquillage = 1
                                InstitutSettings.Rougealevre = 1
                                InstitutSettings.ColorRougealevre.primary[2] = 1
                            end
                        })
                        RageUI.Separator('Prix du maquillage : ~g~45$')
                        RageUI.ColourPanel("Couleur du Rouge à lèvres", RageUI.PanelColour.MakeUp, InstitutSettings.ColorRougealevre.primary[1], InstitutSettings.ColorRougealevre.primary[2], {
                            onColorChange = function(MinimumIndex, CurrentIndex)
                                InstitutSettings.ColorRougealevre.primary[1] = MinimumIndex
                                InstitutSettings.ColorRougealevre.primary[2] = CurrentIndex
                                SetPedHeadOverlayColor(Player:Ped(), 8, 2, CurrentIndex, CurrentIndex)
                            end
                        }, 3)
                    end)
                    Wait(0)
                end
            end)
        end
    end
end