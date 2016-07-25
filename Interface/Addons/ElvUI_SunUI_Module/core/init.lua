local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

if CUSTOM_CLASS_COLORS then
	E.myclasscolor = CUSTOM_CLASS_COLORS[E.myclass]
else
	E.myclasscolor = RAID_CLASS_COLORS[E.myclass]
end
E.myname             = UnitName("player")
E.myrealm            = GetRealmName()
E.zone = GetLocale()
E.level = UnitLevel("player")