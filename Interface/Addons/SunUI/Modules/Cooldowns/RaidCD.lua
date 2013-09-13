----------------------------------------------------------------------------------------
--	Raid cooldowns(alRaidCD by Allez)
--  Modify by Ljxx.net at 2011.10.7
----------------------------------------------------------------------------------------
local S, L, DB, _, C = unpack(select(2, ...))
local RCD = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("RaidCD", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local show = {
	raid = true,
	party = true,
	arena = true,
}

local raid_spells = {
	[20484] = 600,	-- 复生
	[61999] = 600,	-- 复活盟友
	[20707] = 900,	-- 灵魂石复活
	[6346] = 180,	-- 防护恐惧结界
	[29166] = 180,	-- 激活
	[32182] = 300,	-- 英勇
	[2825] = 300,	-- 嗜血
	[80353] = 300,	-- 时间扭曲
	[90355] = 300,	-- 远古狂乱
	[15286] = 180,	-- 吸血鬼的拥抱
	--团队免伤技能	
	[97462] = 180,  -- 集结呐喊
	[98008] = 180,  -- 灵魂链接图腾
	[62618] = 180,  -- 真言术: 障
	[51052] = 120,  -- 反魔法领域
	[70940] = 180,  -- 神圣守卫(FQ)
	[31821] = 120,  -- 光环掌握(NQ)
	[64843] = 180,  -- 神圣赞美诗 *
	[64901] = 360,	-- 希望圣歌
	[740]   = 180,  -- 宁静(ND) *
	[87023] = 60,   --FS
	[16190] = 180,  --SM 潮汐
	[105763] =180,  --NS 2T13
	[6940] = 120, --QS 牺牲之手
	[47788] = 180, --MS 天使
	[108280] = 180,
		 -- Monk
	[115176] = 180,
	[116849] = 120,
	[115310] = 180,
	     -- Warrior
	[114203] = 180,
}

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local timer = 0
local bars = {}
local RaidCDAnchor = CreateFrame("Frame", "RaidCDAnchor", UIParent)

local FormatTime = function(time)
	if time >= 60 then
		return sformat("%.2d:%.2d", floor(time / 60), time % 60)
	else
		return sformat("%.2d", time)
	end
end
local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	RCD:UpdatePositions()
end
function RCD:UpdatePositions()
	local i = 1
	for k,v in pairs(bars) do
		v:ClearAllPoints()
		v.id = i
		if i == 1 then
			v:SetPoint("CENTER", RaidCDAnchor)
			--bars[i]:SetPoint("CENTER")
		else
			if C["RaidCDDirection"] == 2 then
				v:Point("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, C["RaidCDHeight"]*2-3)
			else
				v:Point("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, -C["RaidCDHeight"]*2+3)
			end
			if i > C["RowNum"] and i <= C["MaxNumber"] then
				if C["RowDirection"] == "left" then
					if i%C["RowNum"] == 1 then
						v:ClearAllPoints()
						v:Point("RIGHT", bars[(floor(i/C["RowNum"])-1)*C["RowNum"]+1], "LEFT", -C["RaidCDHeight"]*2-12, 0)
					end
				elseif C["RowDirection"] == "right" then
					if i%C["RowNum"] == 1 then
						--print("换行", bars[i].id, floor(i/C["MaxNumber"]))
						v:ClearAllPoints()
						v:Point("LEFT", bars[(floor(i/C["RowNum"])-1)*C["RowNum"]+1], "RIGHT", C["RaidCDHeight"]*2+12, 0)
					end
				end
			end
			if i > C["MaxNumber"] then
				StopTimer(v)
			end
		end
		i = i + 1
	end
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetSpellByID(self.spellId)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(self.left:GetText(), self.right:GetText())
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		if IsInRaid() then
			SendChatMessage("SunUI"..COOLDOWN_REMAINING..self.left:GetText().."-"..GetSpellLink(self.spellId)..":"..self.right:GetText(), "RAID")
		elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
				SendChatMessage("SunUI"..COOLDOWN_REMAINING..self.left:GetText().."-"..GetSpellLink(self.spellId)..":"..self.right:GetText(), "INSTANCE_CHAT")
		elseif IsInGroup() then
				SendChatMessage("SunUI"..COOLDOWN_REMAINING..self.left:GetText().."-"..GetSpellLink(self.spellId)..":"..self.right:GetText(), "PARTY")		
		else
			SendChatMessage("SunUI"..COOLDOWN_REMAINING..self.left:GetText().."-"..GetSpellLink(self.spellId)..":"..self.right:GetText(), "SAY")
		end
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = CreateFrame("Statusbar", nil, UIParent)
	bar:SetFrameStrata("LOW")
	bar:SetSize(C["RaidCDWidth"], C["RaidCDHeight"])
	bar:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	bar:SetMinMaxValues(0, 100)

	S.CreateBack(bar)
	S.CreateMark(bar)
	bar.left = S.MakeFontString(bar, C["RaidCDFontSize"])
	bar.left:SetPoint("LEFT", 2, C["RaidCDHeight"])
	bar.left:SetJustifyH("LEFT")
	bar.left:Size(C["RaidCDWidth"]*2/3, C["RaidCDHeight"])

	bar.right = S.MakeFontString(bar, C["RaidCDFontSize"])
	bar.right:Point("RIGHT", 1, C["RaidCDHeight"])
	bar.right:SetJustifyH("RIGHT")

	bar.icon = CreateFrame("Button", nil, bar)
	bar.icon:Width(C["RaidCDHeight"]*2)
	bar.icon:Height(C["RaidCDHeight"]*2)
	bar.icon:Point("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
	bar.icon:CreateShadow()
	bar:CreateShadow()

	return bar
end

local StartTimer = function(name, spellId)
	for k, v in pairs(bars) do
		if v.spell == GetSpellInfo(spellId) and v.name == name then
			return
		end
	end
	local bar = CreateBar()
	local spell, rank, icon = GetSpellInfo(spellId)
	bar.endTime = GetTime() + raid_spells[spellId]
	bar.startTime = GetTime()
	bar.left:SetText(name)
	bar.right:SetText(FormatTime(raid_spells[spellId]))
	bar.icon:SetNormalTexture(icon)
	bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	bar.spell = spell
	bar.spellId = spellId
	bar.name = name
	bar:Show()
	local color
	if CUSTOM_CLASS_COLORS then
		color = CUSTOM_CLASS_COLORS[select(2, UnitClass(name))]
	else
		color = RAID_CLASS_COLORS[select(2, UnitClass(name))]
	end
	if color then
		bar:SetStatusBarColor(color.r, color.g, color.b)
		local s = bar:GetStatusBarTexture()
		S.CreateTop(s, color.r, color.g, color.b)
	else
		bar:SetStatusBarColor(0.3, 0.7, 0.3)
	end
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	tinsert(bars, bar)
	RCD:UpdatePositions()
end

function RCD:COMBAT_LOG_EVENT_UNFILTERED(null, ...)
	local _, eventType, _, _, sourceName, sourceFlags = ...
	if band(sourceFlags, filter) == 0 then return end
	local spellId = select(12, ...)
	if raid_spells[spellId] and show[select(2, IsInInstance())] then
		if eventType == "SPELL_RESURRECT" and not spellId == 61999 then
			if spellId == 95750 then spellId = 6203 end
			StartTimer(sourceName, spellId)
		elseif eventType == "SPELL_AURA_APPLIED" then
			if spellId == 20707 and select(2, UnitClass(sourceName)) == 'WARLOCK' then
				StartTimer(sourceName, spellId)
			end
			if spellId == 87023 and select(2, UnitClass(sourceName)) == 'MAGE' then
				StartTimer(sourceName, spellId)
			end
			if spellId == 105763 and select(2, UnitClass(sourceName)) == 'SHAMAN' then
				StartTimer(sourceName, 16190)
			end				
		elseif eventType == "SPELL_CAST_SUCCESS" then
			StartTimer(sourceName, spellId)
		end
		if eventType == "SPELL_RESURRECT" and spellId == 20484 then StartTimer(sourceName, spellId) end
	end
end
function RCD:ZONE_CHANGED_NEW_AREA()
	if select(2, IsInInstance()) == "arena" then
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end
function RCD:UpdateSize()
	RaidCDAnchor:SetSize(C["RaidCDWidth"], C["RaidCDHeight"])
	for i = 1, #bars do
		bars[i]:SetSize(C["RaidCDWidth"], C["RaidCDHeight"])
	end
end
function RCD:UpdateSet()
	if C["RaidCD"] then
		RCD:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		RCD:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	else
		RCD:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		RCD:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end
function RCD:OnInitialize()
	C = SunUIConfig.db.profile.RaidCDDB
	RaidCDAnchor:SetSize(C["RaidCDWidth"], C["RaidCDHeight"])
	RCD:UpdateSet()
	MoveHandle.RaidCD = S.MakeMoveHandle(RaidCDAnchor, "RaidCD", "RaidCD")
end
SlashCmdList.RaidCD = function(msg)
	for i = 1, 6 do
		StartTimer(UnitName("player"), 20484)	-- Rebirth
		StartTimer(UnitName("player"), 20707)	-- Soulstone
		StartTimer(UnitName("player"), 6346)	-- Fear Ward
		StartTimer(UnitName("player"), 29166)	-- Innervate
		StartTimer(UnitName("player"), 32182)	-- Heroism
		StartTimer(UnitName("player"), 2825)	-- Bloodlust
	end
end
SLASH_RaidCD1 = "/raidcd"