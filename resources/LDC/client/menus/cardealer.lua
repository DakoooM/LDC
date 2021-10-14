local opencardealer = false
local CardealerMenu = RageUI.CreateMenu("Concessionnaire", "aFramework")
local CardealerCatVehMenu = RageUI.CreateSubMenu(CardealerMenu,"Concessionnaire", "aFramework")
local CardealerBuyVehMenu = RageUI.CreateSubMenu(CardealerCatVehMenu,"Concessionnaire", "aFramework")
local CardealerPaimentVehMenu = RageUI.CreateSubMenu(CardealerCatVehMenu,"Concessionnaire", "aFramework")

CardealerBuyVehMenu.EnableMouse = true

CardealerMenu.Closed = function()
    opencardealer = false
    FreezeEntityPosition(Player:Ped(), false)
end
CardealerBuyVehMenu.Closed = function()
    DeleteVehicle(CacheCardealer["CurrentTypeVeh"])
    destorycam()
end

VehiclesC = {    
    Class = {

        ["Compact"] = {
            {Name = "Blista", model = "blista", price = 200},
            {Name = "Dilettante", model = "dilettante", price = 200},
            {Name = "Brioso", model = "brioso", price = 200},
            {Name = "Issi2", model = "issi2", price = 200},
            {Name = "Issi3", model = "issi3", price = 200},
            {Name = "Panto", model = "panto", price = 200},
            {Name = "Prairie", model = "prairie", price = 200},
            {Name = "Rhapsody", model = "rhapsody", price = 200},
        },
        ["Coupes"] = {
            {Name = "Cogcabrio", model = "cogcabrio", price = 200},
            {Name = "Exemplar", model = "exemplar", price = 200},
            {Name = "F620", model = "f620", price = 200},
            {Name = "Felon", model = "felon", price = 200},
            {Name = "Felon2", model = "felon2", price = 200},
            {Name = "Jackal", model = "jackal", price = 200},
            {Name = "Oracle", model = "oracle", price = 200},
            {Name = "Oracle2", model = "oracle2", price = 200},
            {Name = "Sentinel", model = "sentinel", price = 200},
            {Name = "Sentinel2", model = "sentinel2", price = 200},
            {Name = "Windsor", model = "windsor", price = 200},
            {Name = "Windsor2", model = "windsor2", price = 200},
            {Name = "Zion", model = "zion", price = 200},
            {Name = "Zion2", model = "zion2", price = 200},
        },
        ["SUVs"] = {
            {Name = "Baller", model= "baller", price= 24000},
            {Name = "Baller2",model= "baller2", price= 25000},
            {Name = "Baller3",model= "baller3", price= 26000},
            {Name = "Baller4",model= "baller4", price= 27500},
            {Name = "BJXL",model= "bjxl", price= 21500},
            {Name = "Cavalcade",model= "cavalcade", price= 20000},
            {Name = "Cavalcade2",model= "cavalcade2", price= 20500},
            {Name = "Contender",model= "contender", price= 36000},
            {Name = "Dubsta",model= "dubsta", price= 27800},
            {Name = "Dubsta2",model= "dubsta2", price= 28000},
            {Name = "FQ2",model= "fq2", price= 24500},
            {Name = "Granger",model= "granger", price= 26000},
            {Name = "Gresley",model= "gresley", price= 21500},
            {Name = "Habanero",model= "habanero", price= 19500},
            {Name = "Huntley",model= "huntley", price= 15500},
            {Name = "LandStalker",model= "landstalker", price= 14500},
            {Name = "Mesa",model= "mesa", price= 16500},
            {Name = "Patriot",model= "patriot", price= 17800},
            {Name = "Radi",model= "radi", price= 14500},
            {Name = "Rocoto",model= "rocoto", price= 15000},
            {Name = "Seminole",model= "seminole", price= 14000},
            {Name = "Serrano",model= "serrano", price= 14500},
            {Name = "Toros",model= "toros", price= 45000},
            {Name = "XLS",model= "xls", price= 16500},
    
        },
        ["Sedans"] = {
            {Name = "Asea", model= "asea", price= 11500},
            {Name = "Asterope",model= "asterope", price= 12000},
            {Name = "Cog55",model= "cog55", price= 15000},
            {Name = "Cognoscenti",model= "cognoscenti", price= 15500},
            {Name = "Emperor",model= "emperor", price= 13500},
            {Name = "Emperor2",model= "emperor2", price= 12000},
            {Name = "Fugitive",model= "fugitive", price= 11500},
            {Name = "Glendale",model= "glendale", price= 12000},
            {Name = "Ingot",model= "ingot", price= 13000},
            {Name = "Intruder",model= "intruder", price= 13500},
            {Name = "Premier",model= "premier", price= 12500},
            {Name = "Primo",model= "primo", price= 12500},
            {Name = "Primo2",model= "primo2", price= 15000},
            {Name = "Regina",model= "regina", price= 11500},
            {Name = "Romero",model= "romero", price= 18500},
            {Name = "Stafford",model= "stafford", price= 21000},
            {Name = "Stanier",model= "stanier", price= 12500},
            {Name = "Stratum",model= "stratum", price= 13500},
            {Name = "Stretch",model= "stretch", price= 29000},
            {Name = "SuperD",model= "superd", price= 23000},
            {Name = "Surge",model= "surge", price= 13500},
            {Name = "Tailgater",model= "tailgater", price= 12500},
            {Name = "Warrener",model= "warrener", price= 11500},
            {Name = "Washington",model= "washington", price= 12500},
    
        }
    }
}

CacheCardealer = {}

local Action = {
    Couleur = {
            Primaire = {1, 5},
            Secondaire = {1, 5}
        },
    }

local CurrentTypeVeh = nil

local CouleurPrinc = {}
local CouleurSec = {}

local charset = {} do
    for c = 65, 90  do table.insert(charset, string.char(c)) end
end

local function randomString(length)
    if not length or length <= 0 then return '' end
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end

local Vehicule = nil

function CreateLocalCardealerVehicle(Name, Vehicle)
	RequestModel(Vehicle)
	while not HasModelLoaded(Vehicle) do Wait(1) end
    CacheCardealer[Name] = CreateVehicle(Vehicle, -45.13, -1098.05, 25.81, 300.0, false, true)
	SetVehicleOnGroundProperly(CacheCardealer[Name])
	FreezeEntityPosition(CacheCardealer[Name], 1)
	SetModelAsNoLongerNeeded(CacheCardealer[Name])
    Vehicule = CacheCardealer[Name]
end

function CreateCardealerVehicle(Vehicle, InVehicle)
	RequestModel(Vehicle)
	while not HasModelLoaded(Vehicle) do Wait(1) end
    CurrentTypeVeh = CreateVehicle(Vehicle, -30.99, -1090.69, 26.42, 340.9, true, true)
	SetVehicleOnGroundProperly(CurrentTypeVeh)
	SetModelAsNoLongerNeeded(CurrentTypeVeh)
    SetVehicleCustomPrimaryColour(CurrentTypeVeh, CouleurPrinc.CouleurRed, CouleurPrinc.CouleurGreen, CouleurPrinc.CouleurBlue)
    SetVehicleCustomSecondaryColour(CurrentTypeVeh, CouleurSec.CouleurRed, CouleurSec.CouleurGreen, CouleurSec.CouleurBlue)
    if InVehicle then 
        SetPedIntoVehicle(Player:Ped(), CurrentTypeVeh, -1)
    end
end


function openCardealerMenu()
    if opencardealer == false then
        if opencardealer then
            opencardealer = false
            RageUI.Visible(CardealerMenu, false)
        else
            opencardealer = true
            RageUI.Visible(CardealerMenu, true)
            FreezeEntityPosition(Player:Ped(), true)
            CreateThread(function()
                while opencardealer do
                    RageUI.IsVisible(CardealerMenu, function()
                        RageUI.Separator("- ~r~Intéraction automobile~s~ -")
                        RageUI.Button("Acheter un véhicule", nil, {RightLabel = "→"}, true, {}, CardealerCatVehMenu)
                    end)
                    RageUI.IsVisible(CardealerCatVehMenu, function()
                        RageUI.Separator("- ~b~Achat du véhicule~s~ -")
                        RageUI.Separator("↓ ~y~Catégories disponibles~s~ ↓")
                        for k,v in pairs(VehiclesC.Class) do
                            RageUI.Button(k, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    CurrentTypeVeh = k
                                end
                            }, CardealerBuyVehMenu)
                        end
                    end)
                    RageUI.IsVisible(CardealerBuyVehMenu, function()
                        for k,v in pairs(VehiclesC.Class) do
                            if k == CurrentTypeVeh then
                                for f,j in pairs(v) do
                                    RageUI.Button(j.Name, nil, {RightLabel = "price: ~g~"..j.price.."$"}, true, {
                                        onActive = function()
                                            if Selected ~= j.model then 
                                                local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -38.06, -1100.25, 28.0, -15.0, 0.0, 69.0, 60.0, false, 0)
                                                SetCamActive(cam, true)
                                                RenderScriptCams(true, false, 2000, true, true) 
                                                DeleteVehicle(CacheCardealer["CurrentTypeVeh"])
                                                CreateLocalCardealerVehicle("CurrentTypeVeh", j.model)
                                            end
                                            Selected = j.model
                                        end,
                                        onSelected = function()
                                            CurrentPrice = j.price
                                            Wait(50)
                                            TimeTransaction = true
                                        end
                                        }, CardealerPaimentVehMenu)
                                    end
                                end
                            end
                        end, function()
                            RageUI.Separator("")
                            for k,v in pairs(VehiclesC.Class) do
                                if k == CurrentTypeVeh then
                                    for f,j in pairs(v) do
                                        RageUI.ColourPanel("Couleur primaire", RageUI.PanelColour.HairCut, Action.Couleur.Primaire[1], Action.Couleur.Primaire[2], {
                                            onColorChange = function(MinimumIndex, CurrentIndex)
                                                Action.Couleur.Primaire[1] = MinimumIndex
                                                Action.Couleur.Primaire[2] = CurrentIndex
                                                for k,v in pairs(RageUI.PanelColour.HairCut) do
                                                    if k == CurrentIndex then
                                                        r, g, b = table.unpack(v)
                                                        CouleurPrinc = {
                                                            CouleurRed =  r,
                                                            CouleurGreen =  g,
                                                            CouleurBlue =  b
                                                        }
                                                    end
                                                end
                                                SetVehicleCustomPrimaryColour(Vehicule, CouleurPrinc.CouleurRed, CouleurPrinc.CouleurGreen, CouleurPrinc.CouleurBlue)
                                            end
                                        }, f, {Seperator = {Text = "/"}})

                                        RageUI.ColourPanel("Couleur secondaire", RageUI.PanelColour.HairCut, Action.Couleur.Secondaire[1], Action.Couleur.Secondaire[2], {
                                            onColorChange = function(MinimumIndex, CurrentIndex)
                                                Action.Couleur.Secondaire[1] = MinimumIndex
                                                Action.Couleur.Secondaire[2] = CurrentIndex
                                                for k,v in pairs(RageUI.PanelColour.HairCut) do
                                                    if k == CurrentIndex then
                                                        r, g, b = table.unpack(v)
                                                        CouleurSec = {
                                                            CouleurRed =  r,
                                                            CouleurGreen =  g,
                                                            CouleurBlue =  b
                                                        }
                                                    end
                                                end
                                                SetVehicleCustomSecondaryColour(Vehicule, CouleurSec.CouleurRed, CouleurSec.CouleurGreen, CouleurSec.CouleurBlue)
                                            end
                                        }, f, {Seperator = {Text = "/"}})
                                    end
                                end
                            end
                        end)
                        RageUI.IsVisible(CardealerPaimentVehMenu, function()
                            if TimeTransaction == true then
                                RageUI.Separator("Modèle du véhicule : ~b~"..Selected)
                                RageUI.Separator("price du véhicule : ~g~"..CurrentPrice.."$")
                                RageUI.Button("Payer ce véhicule", nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        local PlaqueOfVeh = math.random(10, 99) .. randomString(3) .. math.random(100, 999)
                                        TriggerServerEvent("aFrw:BuyVehiclePlayer", tonumber(CurrentPrice), Selected, PlaqueOfVeh, json.encode(CouleurPrinc), json.encode(CouleurSec))
                                        FreezeEntityPosition(Player:Ped(), false)
                                        DeleteVehicle(CacheCardealer["CurrentTypeVeh"])
                                        destorycam()
                                        TimeTransaction = false
                                        opencardealer = false
                                    end
                                })
                                RageUI.Button("Retourner au catalogue", nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        RageUI.GoBack()
                                        destorycam()
                                        DeleteVehicle(CacheCardealer["CurrentTypeVeh"])
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

RegisterNetEvent("aFrw:CreateVehicle")
AddEventHandler("aFrw:CreateVehicle", function(model)
    CreateCardealerVehicle(model, true)
end)