local _, ns = ...

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

local ResurrectionSpells = {
	[GetSpellInfo(7328)]   = true, 	--救赎
	[GetSpellInfo(2008)]   = true, 	--先祖之魂
	[GetSpellInfo(50769)]  = true, 	--起死回生
	[GetSpellInfo(115178)] = true, 	--轮回转世
	[GetSpellInfo(2006)]   = true, 	--复活术

	[GetSpellInfo(61999)]  = true, 	--复活盟友
	[GetSpellInfo(20484)]  = true, 	--复生
	[GetSpellInfo(20707)]  = true, 	--灵魂石复活
	[GetSpellInfo(126393)] = true, 	--永恒守护者(LR BB)
}

local Resurrection = function(self, event,...)

	if not ns.db.Resurrection then return end
	if event == "UNIT_SPELLCAST_SENT" then
		local cast, spellname, rank, unit = ...
		
		if cast ~= "player" then return end

		local _, instanceType, difficultyID = GetInstanceInfo()
		if difficultyID == 0 then
			return
		end
		
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance() then
			instanceType = "INSTANCE_CHAT"
		end
		
		if spellname == GetSpellInfo(83968) then	--群体复活
			SendChatMessage("正在释放群体复活...", instanceType, nil, nil)
			return
		end

		if ResurrectionSpells[spellname] and unit ~="unknown" and UnitIsDeadOrGhost(unit) then 
			local Text = "正在复活  "..unit.." ...."
			SendChatMessage(Text, instanceType, nil, nil);	
		end	
    end
end

local OnResFrame = CreateFrame"Frame"
OnResFrame:RegisterEvent('UNIT_SPELLCAST_SENT')
OnResFrame:SetScript('OnEvent', Resurrection)




