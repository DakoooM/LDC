local openSociety = false

local SocietyMenu = RageUI.CreateMenu("Société", Config.ServerName)

function opensSociety()
    if openSociety == false then
        if openSociety then
            openSociety = false
            RageUI.Visible(SocietyMenu, false)
        else
            openSociety = true
            RageUI.Visible(SocietyMenu, true)
            CreateThread(function()
                while openSociety do
                    RageUI.IsVisible(SocietyMenu, function()
                        
                    end)
 
                    Wait(1)
                end
            end)
        end
    end
end

RegisterCommand("boss", function()
    opensSociety()
end)