-- RenderSprite(TextureDictionary, TextureName, X, Y, Width, Height, Heading, R, G, B, A)

local actualBasket = {}

local ItemsCaca = {"Ketchup", "Sauce Tomate"}

local tmr = 1
CreateThread(function()
    while true do 
        Wait(1)
        local myPos = Player:GetCoords()
        local dst = #(myPos - vector3(24.38351, -1345.813, 29.49703))

        if dst <= 2.0 then
            RenderRectangle(1500, 60.0, 400, 550, 0, 0, 0, 170)
            LDC.showText({shadow = true, size = 0.65,
                msg = "~g~Panier Actuel :~s~", 
                posx = 0.84, posy = 0.06
            })
            -- for k,v in pairs(actu)
        end


        local dst = #(myPos - vector3(30.42977, -1345.202, 29.49703))
        if dst <= 1.5 then
            LDC.showText({shadow = true, size = 0.65, 
                msg = "Object(s): " ..ItemsCaca[tmr],  
                posx = 0.45, posy = 0.94
            })
            if IsControlJustPressed(0, 175) then -- ARROW RIGHT
                if tmr < #ItemsCaca then
                    tmr=tmr+1
                end
            elseif IsControlJustPressed(0, 174) then -- ARROW LEFT
                if tmr > 1 then
                    tmr=tmr-1
                end
            elseif IsControlJustPressed(0, 191) then -- ENTER
                table.insert(actualBasket, {Name = ItemsCaca[tmr]})
            end
        end
    end
end)



















