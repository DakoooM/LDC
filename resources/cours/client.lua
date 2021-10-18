-- return = retourne une valeur

-- nil = aucun -- (Type: nil)
-- false = faux -- (Type: boolean)
-- true = vrai -- (Type: boolean)

-- #variables = retourne la longeur de la chaine de caractères
-- tostring(5) = converti le nombre en chaine de caractère -- Après: "5"
-- tonumber("5") = converti la chaine de caractère en nombre -- Après: 5

-- Enlever de(s) caractère(s) spécifique dans une chaine de caractère
local string = "Hello Tout le monde OMG"
print(string:gsub("%o", "")) -- Résultat: "Hell Tut le mnde MG"


-- 1. - Retourne une valeur
local tableau = {"dakor", "luk214", "luk"}
local variable = "luk"

function execReturn(arg)
    if variable == arg then
        return true
    else
        return false
    end
end

if execReturn(tableau[3]) then
    -- true
else
    -- false
end

-- 2. - les variables
local variable = true;
CreateThread(function()
    while true do
        Wait(1)
        if (variable == true) then
            variable = "luk"
        elseif variable == "luk" then
            variable = true
        end
    end
end)

-- 3. la longueur de chaine de caractères
local firstCaracter = "DakorMec"

local tableau2 = {
    {Name = "Dakor"},
    {Name = "Luk"},
    {Name = "Wizosx"}
}

if (#firstCaracter > 1) then
    print(#firstCaracter) -- Résultat: 8
end

-- Tableau 
if #tableau2 > 0 then
    print(#tableau2) -- Résultat: 3
else
    RageUI.Separator("vide")
end

-- 4. les converteur
local myString = "50"
if tonumber(myString) == 50 then -- "50" > 50
    -- code
elseif tonumber(myString) > 40 then
    -- code
end

-- 5. les parametres des strings

local majuscules = "DAKOR"

string.lower(majuscules)
majuscules:lower()

local minuscules = "dakor2"

string.upper(minuscules)
minuscules:upper()

local example = "DakorLuk"

print(string.sub(example, 3)) -- korLuk
print(example:sub(3)) -- korLuk

local example2 = "OkokMecJesuisOk"
print(string.gsub(example2, "%o", " ")) -- kkMecJesuisk
print(example2:gsub("%o", " ")) -- kkMecJesuisk

local example3 = "123456789"

print(string.len(example3)) -- 9
print(example3:len()) -- 9