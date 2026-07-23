local Translate2code=require("util.animations.translate2code")
local tab={}
for k,v in pairs(Translate2code) do
    tab[v]=k
end
return tab