local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Announce", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local baoming = {
	--战士
	[871] = true,	-- 盾墙
	[12975] = true,	--破釜沉舟
	[97462] = true,	--集结呐喊
	--圣骑士
	[642] = true,	--圣盾术
	[86659] = true,	--远古列王守卫
	[31821] = true,	--虔诚光环
	[31850] = true,	--炽热防御者
	[498] = true,	--圣佑术
	--------------------------DK---------------
	[48707] = true,	--反魔法护罩
	[50461] = true,	--反魔法领域
	[48792] = true,	--冰封之韧
	------------------------德鲁伊---------------
	--[22842] = true,	--狂暴回复
	[106922] = true, --30%血
	[61336] = true,	--生存本能
	------------------------武僧--------------------
	[115213] = true, 	--慈悲庇护
	[115176] = true, 	--禅悟冥想
	[115203] = true, 	--壮胆酒
	--test
	--[586] = true,
}
local heal = {
	--治疗
	[62618] = true, 	--真言术:障
	[98008] = true,  -- 灵魂链接图腾
	[31821] = true,  -- 光环掌握(NQ)
	[16190] = true,  --SM 潮汐
	[31821] = true,  -- 光环掌握(NQ)
	[724] = true, --光束泉
	[15286] = true,  -- 吸血鬼的拥抱 *
	--test
	--[586] = true,
}	
--通道技能
local cl = {		
	[64843] = true,  -- 神圣赞美诗 *
	[64901] = true,	-- 希望圣歌
	[740] = true,  -- 宁静(ND) *
	--[88685] = true,
	--test
	--[2050] = true,
}
--给的技能
local givelist = {
	--武僧
	[116849] = true, 	--作茧缚命
	[29166] = true,	-- 激活
	------------------------牧师--------------------
	[33206] = true, 	--痛苦压制
	[47788] = true, 	--守护之魂
	--圣骑士
	[1022] = true,	--保护之手
	[1038] = true,	--拯救之手
	[6940] = true,	--牺牲之手
	[114039] = true,	--纯净之手
	[115310] = true,  --五气归元
	[115176] = true,  --冥思禅功
	--test
	--[139] = true,
}
local resurrect = {
	[20484] = true,	-- 复生
	[61999] = true,	-- 复活盟友
	[20707] = true,	-- 灵魂石复活	
}
local mislead = {
	[34477] = true,	-- 误导
	[57934] = true,	-- 偷天
}
function Module:COMBAT_LOG_EVENT_UNFILTERED(_, _, ...)
	local arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16 = ...
	--if arg5 == UnitName("player") then print(arg2, GetSpellLink(arg12)) end
	--打断
	if arg2 == "SPELL_INTERRUPT" and arg5 == UnitName("player") and C["Interrupt"]then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage(GetSpellLink(arg12).."→"..arg9..GetSpellLink(arg15), channel)
		else
			DEFAULT_CHAT_FRAME:AddMessage(GetSpellLink(arg12).."→"..arg9..GetSpellLink(arg15))
		end
	end
	--重要通道技能	
	if cl[arg12] and arg5 == UnitName("player") and C["Channel"] and arg2 == "SPELL_CAST_SUCCESS" then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage(L["正在施放"]..GetSpellLink(arg12), channel)
		else
			return
			--DEFAULT_CHAT_FRAME:AddMessage("正在施放"..GetSpellLink(arg12))
		end
	end
	--重要给出去的技能
	if givelist[arg12] and arg5 == UnitName("player") and C["Give"] and arg2 == "SPELL_AURA_APPLIED" then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage(GetSpellLink(arg12).."→"..arg9.."", channel)
		else
			return
			--DEFAULT_CHAT_FRAME:AddMessage("施放"..GetSpellLink(arg12).."给>>"..arg9.."<<")
		end
	end
	--治疗大招
	if heal[arg12] and arg5 == UnitName("player") and C["Heal"] and (arg2 == "SPELL_CAST_SUCCESS" or arg2 == "SPELL_SUMMON") then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage(L["已施放"]..GetSpellLink(arg12), channel)
		else
			return
			--DEFAULT_CHAT_FRAME:AddMessage("已施放"..GetSpellLink(arg12))
		end
	end
	--保命技能
	if baoming[arg12] and arg5 == UnitName("player") and C["BaoM"] and arg2 == "SPELL_CAST_SUCCESS" then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage(L["已施放"]..GetSpellLink(arg12), channel)
		else
			return
			--DEFAULT_CHAT_FRAME:AddMessage("已施放"..GetSpellLink(arg12))
		end
	end
	--复活技能
	if resurrect[arg12] and arg5 == UnitName("player") and C["Resurrect"] and arg2 == "SPELL_RESURRECT" then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage(GetSpellLink(arg12)..L["复活"]..arg9, channel)
		else
			return
		end
	end
	--误导
	if mislead[arg12] and arg5 == UnitName("player") and C["Mislead"] and arg2 == "SPELL_CAST_SUCCESS" then
		local channel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		if channel then
			SendChatMessage(GetSpellLink(arg12).."→"..arg9, channel)
		else
			return
			--DEFAULT_CHAT_FRAME:AddMessage(GetSpellLink(arg12).."给>>"..arg9.."<<")
		end
	end
end
function Module:UpdateSet()
	C = SunUIConfig.db.profile.AnnounceDB
	if C["Open"] then
		Module:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		Module:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end	
function Module:OnInitialize()
	Module:UpdateSet()
end