local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local AddOnName = ...

S.myclass            = select(2, UnitClass("player"))
if CUSTOM_CLASS_COLORS then
	S.myclasscolor = CUSTOM_CLASS_COLORS[S.myclass]
else
	S.myclasscolor = RAID_CLASS_COLORS[S.myclass]
end
S.myname             = UnitName("player")
S.myrealm            = GetRealmName()
S.version            = GetAddOnMetadata(AddOnName, "Version")
S.zone = GetLocale()