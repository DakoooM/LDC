local actualItemsCount, IndexChoicesItems = 1, 1;
local firstAddToBasket = 0;
local colorVar = "";
local enterZoneOneFrame = false;
local Objectbasket = nil;
local MoneyBasketAddition = nil;
local InCinematic = false;

local actualBasket, actualShopPed = {}, {}
local ExampleItems = {
    {Label = "Ketchup", Price = 8},
    {Label = "Sauce Tomate", Price = 5},
    {Label = "Petit Pois", Price = 3},
    {Label = "Mayonnaise", Price = 4},
}

local function ItemExistInBasket(itemName)
    if #actualBasket > 0 then
        for i, elems in pairs (actualBasket) do
            if itemName == elems.Name then
                return true
            end
        end
    else
        if itemName == actualBasket.Name then
            return true
        else
            return false
        end
    end
    return false
end

local function addToBasket(call)
    if not ItemExistInBasket(ExampleItems[IndexChoicesItems].Label) then
        table.insert(actualBasket, {
            Name = tostring(ExampleItems[IndexChoicesItems].Label),
            Price = tonumber(ExampleItems[IndexChoicesItems].Price),
            Count = tonumber(actualItemsCount)
        })
        Visual.Popup({message = "~g~<C>Ajout Panier</C>~s~\n~s~+" ..tostring(actualItemsCount).. " ~y~" ..ExampleItems[IndexChoicesItems].Label.. "~s~ pour ~o~" ..ExampleItems[IndexChoicesItems].Price * actualItemsCount.. "$~s~"})
        if (call) then call(true) end
    else
        Visual.Popup({message = "~g~<C>Market</C>~s~\n~o~L'objet est déja dans votre panier~s~"})
        if (call) then call(false) end
    end
end

-- RenderRectangle(X, Y, Width, Height, R, G, B, A)
-- RenderSprite("TextureDictionary", "TextureName", X, Y, Width, Height, Heading, R, G, B, A)

CreateThread(function()
    LDC.SpawnPed("mp_m_shopkeep_01", {x = 24.51963, y = -1345.543, z = 29.49703, heading = 265.4469}, function(shopPedCreated)
        LDC.playAnimation({ped = shopPedCreated, animDict = "abigail_mcs_1_concat-4", animName = "csb_abigail_dual-4"})
        FreezeEntityPosition(shopPedCreated, true)        
        SetEntityInvincible(shopPedCreated, true)
        SetBlockingOfNonTemporaryEvents(shopPedCreated, true)
        table.insert(actualShopPed, shopPedCreated)
    end)
end)

CreateThread(function()
    while true do 
        Wait(1)
        local myPos = Player:GetCoords()
        local dst = #(myPos - vector3(24.38351, -1345.813, 29.49703))

        if dst <= 2.0 then
            if (Objectbasket) then
                RenderRectangle(1500, 60.0, 400, 380, 0, 0, 0, 200)
                RenderSprite("helicopterhud", "hud_line", 1500, 110, 400, 3, 0, 255, 255, 255, 220)
                RenderSprite("shopui_title_conveniencestore", "shopui_title_conveniencestore", 1500, 60, 400, 50, 0, 255, 255, 255, 100)
                LDC.showText({shadow = true, size = 0.65, msg = "Panier Actuel", posx = 0.8450, posy = 0.06})
                if #actualBasket > 0 and not InCinematic then
                    for k, items in pairs(actualBasket) do
                        print(k,items, 0.11+0.03*(k-1))
                        LDC.showText({shadow = true, size = 0.55, font = 4,
                            msg = items.Name.. " x~b~" ..items.Count.. "~s~ (~g~" ..tostring(items.Price).. "$~s~)",
                            posx = 0.84, posy = 0.11+0.03*(k-1)
                        })
                    end
                else
                    LDC.showText({shadow = true, size = 0.65, msg = "~r~Aucun Produits~s~", posx = 0.84, posy = 0.22})
                end
                if IsControlJustPressed(0, 38) then
                    actualBasket.thisMoney = 0
                    if #actualBasket > 0 then
                        for i=1,#actualBasket,1 do
                            local item = actualBasket[i]
                            local Price = item.Price * item.Count
                            print("id:",i,"Price:",Price, type(Price))
                            actualBasket.thisMoney = actualBasket.thisMoney+Price
                        end
                        print(actualBasket.thisMoney)
                    end
                    if actualBasket.thisMoney > 0 and Player:getMoney() >= 1 then
                        InCinematic = true
                        LDC.SpawnObject("prop_paper_bag_01", GetEntityCoords(actualShopPed[1]), function(objectCreate)
                            SetPlayerControl(PlayerId(), false, 12)
                            DisplayRadar(false)
                            AttachEntityToEntity(objectCreate, actualShopPed[1], GetPedBoneIndex(actualShopPed[1], 0x49D9), 0.30, -0.03, 0.05, -100.0 --[[ rot x ]], 10.0 --[[ rot y ]], 90.0 --[[ rot z ]], 1, 1, 0, 0, 2, 1)
                            ClearPedTasks(actualShopPed[1])
                            LDC.playAnimation({ped = actualShopPed[1], animDict = "mp_am_hold_up", animName = "purchase_energydrink_shopkeeper"})
                            local scenarioCamera = LDC.CreateCamera({25.72379, -1345.498, 30.59703, rotY = -30.0, heading = 85.7200, fov = 60.0, AnimTime = 200})
                            PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
                            Wait(1200)
                            ClearPedTasks(actualShopPed[1])
                            DetachEntity(objectCreate, false, false)
                            DeleteEntity(objectCreate)
                            LDC.playAnimation({ped = actualShopPed[1], animDict = "abigail_mcs_1_concat-4", animName = "csb_abigail_dual-4"})
                            LDC.DeleteCam(scenarioCamera, {Anim = true, AnimTime = 500})
                            SetPlayerControl(PlayerId(), true, 12)
                            actualBasket = {}
                            actualItemsCount = 1;
                            IndexChoicesItems = 1;
                            InCinematic = false;
                        end)
                    else
                        print("TU N'A PAS ASSEZ D'ARGENT")
                    end
                elseif IsControlJustPressed(0, 202) then
                    actualBasket = {}
                    actualItemsCount = 1;
                    IndexChoicesItems = 1;
                end
            end
        end

        local dst3 = #(myPos - vector3(25.95537, -1347.956, 29.49))
        if dst3 <= 0.50 then
            LDC.showText({shadow = true, size = 0.65, msg = "Prendre un ~g~sachet", posx = 0.45, posy = 0.94})
            if IsControlJustPressed(0, 51) then
                if (Objectbasket == nil) then
                    LDC.SpawnObject("prop_paper_bag_01", {x= 0,y = 0, z = 0.0}, function(objectCreated)
                        Objectbasket = AttachEntityToEntity(objectCreated, Player:Ped(), GetPedBoneIndex(Player:Ped(), 0x49D9), 0.30, -0.03, 0.05, -100.0 --[[ rot x ]], 10.0 --[[ rot y ]], 90.0 --[[ rot z ]], 1, 1, 0, 0, 2, 1)
                        thisObject = objectCreated
                        LDC.playDemarches("move_m@fat@a", "move_m@fat@a")
                        Visual.Popup({message = "~g~<C>Market</C>~s~\n~o~Reposez le ~y~<C>sachet</C>~s~~o~ lorsque vous avez fini~s~"})
                    end)
                else
                    DetachEntity(thisObject, false, false)
                    DeleteEntity(thisObject)
                    Visual.Popup({message = "~g~<C>Market</C>~s~\nMerci de votre visite et à bientôt"})
                    RemoveAnimSet("move_m@fat@a")
                    ResetPedMovementClipset(Player:Ped(), 1000)
                    Objectbasket = nil;
                end
            end
        end

        if (Objectbasket) then
            local dst2 = #(myPos - vector3(30.42977, -1345.202, 29.49703))
            if dst2 <= 1.5 then
                if enterZoneOneFrame == false then
                    enterZoneOneFrame = true;
                end
                if actualItemsCount > 2 and actualItemsCount < 5 then
                    colorVar = "~y~"
                elseif actualItemsCount > 4 and actualItemsCount < 9 then
                    colorVar = "~o~"
                else
                    colorVar = "~w~"
                end
                LDC.showText({shadow = true, size = 0.65, msg = "Object(s): " ..ExampleItems[IndexChoicesItems].Label.. " x" ..colorVar ..tostring(actualItemsCount), posx = 0.45, posy = 0.94})
                if IsControlJustPressed(0, 175) then -- ARROW RIGHT
                    if IndexChoicesItems < #ExampleItems then
                        IndexChoicesItems=IndexChoicesItems+1
                        actualItemsCount = 1;
                    end
                elseif IsControlJustPressed(0, 174) then -- ARROW LEFT
                    if IndexChoicesItems > 1 then
                        IndexChoicesItems=IndexChoicesItems-1
                        actualItemsCount = 1;
                    end
                elseif IsControlJustPressed(0, 172) then -- ARROW UP
                    if actualItemsCount < 8 then
                        actualItemsCount=actualItemsCount+1
                    end
                elseif IsControlJustPressed(0, 173) then -- ARROW DOWN
                    if actualItemsCount > 1 then
                        actualItemsCount=actualItemsCount-1
                    end
                elseif IsControlJustPressed(0, 191) then -- ENTER
                    if #actualBasket < 8 then
                        if firstAddToBasket < 1 then
                            firstAddToBasket=firstAddToBasket+1;
                        end
                        addToBasket(function(IsGood)
                            if (IsGood) then 
                                firstAddToBasket=firstAddToBasket+1;
                            end
                        end)
                    else
                        Visual.Popup({message = "~g~<C>Market</C>~s~\n~r~Vous ne pouvez pas prendre plus de 8 objects~s~"})
                    end
                end
            else
                if enterZoneOneFrame == true then
                    actualItemsCount, IndexChoicesItems = 1, 1;
                    enterZoneOneFrame = false;
                end
            end
        end
    end
end)