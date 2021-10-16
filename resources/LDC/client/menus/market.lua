local actualBasket = {}
local ItemsCaca = {
    {Label = "Ketchup", Price = 10},
    {Label = "Sauce Tomate", Price = 5}
}
local actualItemsCount, IndexChoicesItems = 1, 1;
local firstAddToBasket = 0
local colorVar = ""

local function addToBasket(posY)
    table.insert(actualBasket, {
        Name = ItemsCaca[IndexChoicesItems].Label,
        Price = ItemsCaca[IndexChoicesItems].Price,
        Count = actualItemsCount,
        yPos = posY
    })
end

CreateThread(function()
    while true do 
        Wait(1)
        local myPos = Player:GetCoords()
        local dst = #(myPos - vector3(24.38351, -1345.813, 29.49703))

        if dst <= 2.0 then
            RenderRectangle(1500, 60.0, 400, 380, 0, 0, 0, 200)
            LDC.showText({shadow = true, size = 0.65,
                msg = "~o~Panier Actuel~s~", 
                posx = 0.84, posy = 0.06
            })
            if #actualBasket > 0 then
                for k, items in pairs(actualBasket) do
                    LDC.showText({shadow = true, size = 0.55, font = 4,
                        msg = items.Name.. " x~b~" ..items.Count.. "~s~ (~g~" ..tostring(items.Price).. "$~s~)",
                        posx = 0.84, posy = items.yPos
                    })
                end
            else
                LDC.showText({shadow = true, size = 0.65,
                    msg = "~r~Aucun Produits~s~", 
                    posx = 0.84, posy = 0.22
                })
            end
            if IsControlJustPressed(0, 38) then
                actualBasket = {}
                actualItemsCount = 1;
                IndexChoicesItems = 1;
            end
        end

        local dst3 = #(myPos - vector3(25.95537, -1347.956, 29.49))
        if dst3 <= 0.50 then
            LDC.showText({shadow = true, size = 0.65, 
                msg = "Prendre un ~g~sachet",
                posx = 0.45, posy = 0.94
            })
            if IsControlJustPressed(0, 51) then
                LDC.SpawnObject("prop_fruit_basket", {x= 0,y = 0, z = 0}, function(objectCreated)
                    AttachEntityToEntity(objectCreated, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0 --[[ rot x ]], 0.0 --[[ rot y ]], 0.0 --[[ rot z ]], false, false, false, false, 2, true)
                end)
            end
        end

        local dst2 = #(myPos - vector3(30.42977, -1345.202, 29.49703))
        if dst2 <= 1.5 then
            if actualItemsCount > 2 and actualItemsCount < 5 then
                colorVar = "~y~"
            elseif actualItemsCount > 4 and actualItemsCount < 9 then
                colorVar = "~o~"
            else
                colorVar = "~w~"
            end
            LDC.showText({shadow = true, size = 0.65, 
                msg = "Object(s): " ..ItemsCaca[IndexChoicesItems].Label.. " x" ..colorVar ..tostring(actualItemsCount),  
                posx = 0.45, posy = 0.94
            })
            if IsControlJustPressed(0, 175) then -- ARROW RIGHT
                if IndexChoicesItems < #ItemsCaca then
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
                    firstAddToBasket=firstAddToBasket+1;
                    if firstAddToBasket == 1 then
                        addToBasket(0.11)
                    elseif firstAddToBasket == 2 then
                        addToBasket(0.14)
                    elseif firstAddToBasket == 3 then
                        addToBasket(0.17)
                    elseif firstAddToBasket == 4 then
                        addToBasket(0.18)
                    elseif firstAddToBasket == 5 then
                        addToBasket(0.23)
                    elseif firstAddToBasket == 6 then
                        addToBasket(0.26)
                    elseif firstAddToBasket == 7 then
                        addToBasket(0.29)
                    elseif firstAddToBasket == 8 then
                        addToBasket(0.32)
                    end
                    print("AFTER UPDATE actualBasket", json.encode(actualBasket))
                else
                    print("vous ne pouvez pas")
                end
            end
        end
    end
end)