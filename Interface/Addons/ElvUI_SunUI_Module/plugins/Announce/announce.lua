local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local A = E:GetModule("Announce")
local filter = COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band

function A:COMBAT_LOG_EVENT_UNFILTERED(_, ...)
	local _, eventType, _, _, sourceName, sourceFlags = ...
	if band(sourceFlags, filter) == 0 or sourceName ~= E.myname then return end
	local spellId = select(12, ...)
	local tspellId = select(15, ...)
	
	--打断
	if eventType == "SPELL_INTERRUPT" and self.db.Interrupt then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage(GetSpellLink(spellId).."→"..select(9, ...)..GetSpellLink(tspellId), channel)
		else
			DEFAULT_CHAT_FRAME:AddMessage(GetSpellLink(spellId).."→"..select(9, ...)..GetSpellLink(tspellId))
		end
	end
	--重要通道技能	
	if self.cl[spellId] and self.db.Channel and eventType == "SPELL_CAST_SUCCESS" then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage("正在施放"..GetSpellLink(spellId), channel)
		else
			return
			--DEFAULT_CHAT_FRAME:AddMessage("正在施放"..GetSpellLink(spellId))
		end
	end
	--重要给出去的技能
	if self.givelist[spellId] and self.db.Give and eventType == "SPELL_AURA_APPLIED" then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage(GetSpellLink(spellId).."→"..select(9, ...), channel)
		else
			return
			--DEFAULT_CHAT_FRAME:AddMessage("施放"..GetSpellLink(spellId).."给>>"..select(9, ...).."<<")
		end
	end
	--治疗大招
	if self.heal[spellId] and self.db.Heal and (eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_SUMMON") then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage("已施放"..GetSpellLink(spellId), channel)
		else
			return
			--DEFAULT_CHAT_FRAME:AddMessage("已施放"..GetSpellLink(spellId))
		end
	end
	--保命技能
	if self.baoming[spellId] and self.db.BaoM and eventType == "SPELL_CAST_SUCCESS" then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage("已施放"..GetSpellLink(spellId), channel)
		else
			return
			--DEFAULT_CHAT_FRAME:AddMessage("已施放"..GetSpellLink(spellId))
		end
	end
	--复活技能
	if self.resurrect[spellId] and self.db.Resurrect and eventType == "SPELL_RESURRECT" then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage(GetSpellLink(spellId).."→"..select(9, ...), channel)
		else
			return
		end
	end
	--误导
	if self.mislead[spellId] and self.db.Mislead and eventType == "SPELL_CAST_SUCCESS" then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage(GetSpellLink(spellId).."→"..select(9, ...), channel)
		else	
			--DEFAULT_CHAT_FRAME:AddMessage(GetSpellLink(spellId).."→"..select(9, ...))
			return
		end
	end
end
function A:UpdateSet()
	if self.db.Open then
		A:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		A:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end