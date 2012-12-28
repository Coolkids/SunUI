local S, L, DB, _, C = unpack(select(2, ...))
local _G = _G
SLASH_FRAMMODE1 = "/fm"
SLASH_FRAMMODE2 = "/frammode"
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local ParseOpts = function(str)
    local fields = {}
    for opt,args in string.gmatch(str,"(%w*)%s*=%s*([%w%,%-%_%.%:%\\%']+)") do
        fields[opt:lower()] = tonumber(args) or args
    end
    return fields
end
function SlashCmdList.FRAMMODE(msg, editbox)
	k,v = string.match(msg, "([%w%+%-%=]+) ?(.*)")
	--print(k, v)
	if (k == 'on') then
		Minimap:SetPoint("CENTER", UIParent, "BOTTOM", 0, 155)
	elseif (k == 'off') then
		local a,b,c,d,e = unpack(SunUIConfig.db.profile.MoveHandleDB.Minimap)
		Minimap:SetPoint(a,b,c,d,e)
	elseif (k == "set") then
		local p = ParseOpts(v)
		local size = p["size"]
		Minimap:SetSize(size,size)
	else
		print("/fm on - /fm off")
	end
end