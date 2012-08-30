----------------------------------------------------------------------------------------
--	Raid cooldowns(alRaidCD by Allez)
--  Modify by Ljxx.net at 2011.10.7
----------------------------------------------------------------------------------------
local S, C, L, DB = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("RaidCD")

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

		--团队免伤技能	
		[97462] = 180,  -- 集结呐喊
		[98008] = 180,  -- 灵魂链接图腾
		[62618] = 180,  -- 真言术: 障
		[51052] = 120,  -- 反魔法领域
		[70940] = 180,  -- 神圣守卫(FQ)
		[31821] = 120,  -- 光环掌握(NQ)
		[64843] = 180,  -- 神圣赞美诗 *
		[740]   = 180,  -- 宁静(ND) *
		[87023] = 60,   --FS
		[16190] = 180,  --SM 潮汐
		[105763] =180,  --NS 2T13
		[105914] =180,  --战士 4T13
		[105739] =180,  --小德 4T13
	}

	local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
	local band = bit.band
	local sformat = string.format
	local floor = math.floor
	local timer = 0
	local bars = {}

	local RaidCDAnchor = CreateFrame("Frame", "RaidCDAnchor", UIParent)
	RaidCDAnchor:SetSize(C["MiniDB"].RaidCDWidth, C["MiniDB"].RaidCDHeight)
	

	local FormatTime = function(time)
		if time >= 60 then
			return sformat("%.2d:%.2d", floor(time / 60), time % 60)
		else
			return sformat("%.2d", time)
		end
	end

	local CreateFS = function(frame, fsize, fstyle)
		local fstring = frame:CreateFontString(nil, "OVERLAY")
		fstring:SetFont(DB.Font, C["MiniDB"]["RaidCDFontSize"], "OUTLINE")
		return fstring
	end

	local UpdatePositions = function()
		for i = 1, #bars do
			bars[i]:ClearAllPoints()
			if i == 1 then
				bars[i]:SetPoint("TOPLEFT", RaidCDAnchor, "TOPLEFT")
			else
				if C["MiniDB"].RaidCDDirection == 2 then
					bars[i]:Point("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, C["MiniDB"].RaidCDHeight*2+5)
				else
					bars[i]:Point("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, -C["MiniDB"].RaidCDHeight*2+5)
				end
			end
			bars[i].id = i
		end
	end

	local StopTimer = function(bar)
		bar:SetScript("OnUpdate", nil)
		bar:Hide()
		tremove(bars, bar.id)
		UpdatePositions()
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
		GameTooltip:AddDoubleLine(self.spell, self.right:GetText())
		GameTooltip:SetClampedToScreen(true)
		GameTooltip:Show()
	end

	local OnLeave = function(self)
		GameTooltip:Hide()
	end

	local OnMouseDown = function(self, button)
		if button == "LeftButton" then
			if GetRealNumRaidMembers() > 0 then
				SendChatMessage(sformat("SunUI_RaidCD".." %s: %s", self.left:GetText(), self.right:GetText()), "RAID")
			elseif GetRealNumPartyMembers() > 0 and not UnitInRaid("player") then
				SendChatMessage(sformat("SunUI_RaidCD".." %s: %s", self.left:GetText(), self.right:GetText()), "PARTY")
			else
				SendChatMessage(sformat("SunUI_RaidCD".." %s: %s", self.left:GetText(), self.right:GetText()), "SAY")
			end
		elseif button == "RightButton" then
			StopTimer(self)
		end
	end

	local CreateBar = function()
		local bar = CreateFrame("Statusbar", nil, UIParent)
		bar:SetFrameStrata("LOW")
		bar:Size(C["MiniDB"].RaidCDWidth, C["MiniDB"].RaidCDHeight)
		bar:SetStatusBarTexture(DB.Statusbar)
		bar:SetMinMaxValues(0, 100)
	
		bar:SetReverseFill(true)
		local gradient = bar:CreateTexture(nil, "BACKGROUND")
		gradient:SetPoint("TOPLEFT")
		gradient:SetPoint("BOTTOMRIGHT")
		gradient:SetTexture(DB.Statusbar)
		gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
		
		bar.left = CreateFS(bar)
		bar.left:SetPoint("LEFT", 2, C["MiniDB"].RaidCDHeight)
		bar.left:SetJustifyH("LEFT")
		bar.left:Size(C["MiniDB"].RaidCDWidth*2/3, C["MiniDB"].RaidCDHeight)

		bar.right = CreateFS(bar)
		bar.right:Point("RIGHT", 1, C["MiniDB"].RaidCDHeight)
		bar.right:SetJustifyH("RIGHT")

		bar.icon = CreateFrame("Button", nil, bar)
		bar.icon:Width(C["MiniDB"].RaidCDHeight*2)
		bar.icon:Height(C["MiniDB"].RaidCDHeight*2)
		bar.icon:Point("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
		bar.icon:CreateShadow()
		bar.icon.backdrop = CreateFrame("Frame", nil, bar.icon)
		bar.icon.backdrop:Point("TOPLEFT", -2, 2)
		bar.icon.backdrop:Point("BOTTOMRIGHT", 2, -2)
		bar.icon.backdrop:SetFrameStrata("BACKGROUND")
		bar:CreateShadow()

		return bar
	end

	local StartTimer = function(name, spellId)
		for i = 1, #bars do
			if bars[i].spell == GetSpellInfo(spellId) and bars[i].name == name then
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
		bar.name = name
		bar:Show()
		local color = RAID_CLASS_COLORS[select(2, UnitClass(name))]
		if color then
			bar:SetStatusBarColor(color.r, color.g, color.b)
		else
			bar:SetStatusBarColor(0.3, 0.7, 0.3)
		end
		bar:SetScript("OnUpdate", BarUpdate)
		bar:EnableMouse(true)
		bar:SetScript("OnEnter", OnEnter)
		bar:SetScript("OnLeave", OnLeave)
		bar:SetScript("OnMouseDown", OnMouseDown)
		tinsert(bars, bar)
		UpdatePositions()
	end

	local OnEvent = function(self, event, ...)
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
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
		elseif event == "ZONE_CHANGED_NEW_AREA" and select(2, IsInInstance()) == "arena" then
			for k, v in pairs(bars) do
				StopTimer(v)
			end
		end
	end
function Module:OnEnable()
	if C["MiniDB"].RaidCD ~= true then return end
	local addon = CreateFrame("Frame")
	addon:SetScript("OnEvent", OnEvent)
	addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	MoveHandle.RaidCD = S.MakeMoveHandle(RaidCDAnchor, "RaidCD", "RaidCD")
	SlashCmdList.RaidCD = function(msg)
		StartTimer(UnitName("player"), 20484)	-- Rebirth
		StartTimer(UnitName("player"), 20707)	-- Soulstone
		StartTimer(UnitName("player"), 6346)	-- Fear Ward
		StartTimer(UnitName("player"), 29166)	-- Innervate
		StartTimer(UnitName("player"), 32182)	-- Heroism
		StartTimer(UnitName("player"), 2825)	-- Bloodlust
	end
	SLASH_RaidCD1 = "/raidcd"
end