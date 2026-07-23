require("utils/link_modifiers")
require("utils/encryption")
if not IsClient() then return end
require("utils/client_functions")
SendToConsole("r_farz 50000")
Convars:SetInt("r_farz", 50000)