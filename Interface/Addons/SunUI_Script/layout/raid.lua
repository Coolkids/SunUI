local S, C, L, DB = unpack(SunUI)
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("raid")

function Module:OnEnable()
	local myPlayerRealm = GetCVar("realmName");
	local myPlayerName  = UnitName("player");		
	local raidinfo = {}	
	if (MiniDB == nil) then MiniDB = {}; end
	if (MiniDB.raid == nil) then MiniDB.raid = {}; end
	if (MiniDB.raid[myPlayerRealm]==nil) then MiniDB.raid[myPlayerRealm]={}; end
	
	for i = 1, GetNumSavedInstances() do
		local name, _, reset, _, locked, extended, _, isRaid, _ = GetSavedInstanceInfo(i)
			if isRaid and (locked or extended) then
				raidinfo[name] = reset
			end
	end	
	MiniDB.raid[myPlayerRealm][myPlayerName] = raidinfo
end