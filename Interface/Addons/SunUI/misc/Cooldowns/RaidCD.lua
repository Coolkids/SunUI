local S, L, DB, _, C = unpack(select(2, ...))

local RCD = S:NewModule("RaidCD", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
RCD.modName = L["团队CD监视"]
RCD.order = 19
function RCD:GetOptions()
	local options = {
		RaidCD = {
			type = "toggle",
			name = L["团队CD监视"],
			order = 1,
			get = function() return self.db.RaidCD end,
			set = function(_, value) 
				self.db.RaidCD = value 
				self:UpdateSet()
			end,
		},
		group = {
			type = "group", order = 2,
			name = " ",guiInline = true,
			disabled = function(info) return not self.db.RaidCD end,
			args = {
				RaidCDWidth = {
					type = "input",
					name = L["框体宽度"],
					desc = L["框体宽度"],
					order = 2,
					get = function() return tostring(self.db.RaidCDWidth) end,
					set = function(_, value) 
						self.db.RaidCDWidth = tonumber(value) 
						self:UpdateSize()
					end,
				},
				RaidCDHeight = {
					type = "input",
					name = L["框体高度"],
					desc = L["框体高度"],
					order = 3,
					get = function() return tostring(self.db.RaidCDHeight) end,
					set = function(_, value) 
						self.db.RaidCDHeight = tonumber(value) 
						self:UpdateSize()
					end,
				},
				RaidCDDirection = {
					type = "select",
					name = L["计时条增长方向"],
					desc = L["计时条增长方向"],
					order = 4,
					values = {[1] = L["向下"], [2] = L["向上"]},
					get = function() return self.db.RaidCDDirection end,
					set = function(_, value) 
						self.db.RaidCDDirection = value
						self:UpdatePositions()
					end,
				},
				RowNum = {
					type = "input",
					name = L["换行数目"],
					desc = L["换行数目"],
					order = 5,
					get = function() return tostring(self.db.RowNum) end,
					set = function(_, value) 
						self.db.RowNum = tonumber(value) 
						self:UpdatePositions()
					end,
				},
				RowDirection = {
					type = "select",
					name = L["换行方向"],
					desc = L["换行方向"],
					order = 6,
					values = {["left"] = L["向左"], ["right"] = L["向右"]},
					get = function() return self.db.RowDirection end,
					set = function(_, value) 
						self.db.RowDirection = value
						self:UpdatePositions()
					end,
				},
				MaxNumber = {
					type = "input",
					name = L["上限"],
					desc = L["上限"],
					order = 7,
					get = function() return tostring(self.db.MaxNumber) end,
					set = function(_, value) 
						self.db.MaxNumber = tonumber(value) 
						self:UpdatePositions()
					end,
				},
			}	
		}
	}
	return options
end
local show = {
	raid = true,
	party = true,
	arena = true,
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
	bar = nil
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
			if self.db.RaidCDDirection == 2 then
				v:SetPoint("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, self.db.RaidCDHeight*2-3)
			else
				v:SetPoint("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, -self.db.RaidCDHeight*2+3)
			end
			if i > self.db.RowNum and i <= self.db.MaxNumber then
				if self.db.RowDirection == "left" then
					if i%self.db.RowNum == 1 then
						v:ClearAllPoints()
						v:SetPoint("RIGHT", bars[(floor(i/self.db.RowNum)-1)*self.db.RowNum+1], "LEFT", -self.db.RaidCDHeight*2-12, 0)
					end
				elseif self.db.RowDirection == "right" then
					if i%self.db.RowNum == 1 then
						--print("换行", bars[i].id, floor(i/self.db.MaxNumber))
						v:ClearAllPoints()
						v:SetPoint("LEFT", bars[(floor(i/self.db.RowNum)-1)*self.db.RowNum+1], "RIGHT", self.db.RaidCDHeight*2+12, 0)
					end
				end
			end
			if i > self.db.MaxNumber then
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
	local A = S:GetModule("Skins")
	local bar = CreateFrame("Statusbar", nil, UIParent)
	bar:SetFrameStrata("LOW")
	bar:SetSize(RCD.db.RaidCDWidth, RCD.db.RaidCDHeight)
	bar:SetStatusBarTexture(S["media"].normal)
	bar:SetMinMaxValues(0, 100)

	A:CreateMark(bar)
	bar.left = S:CreateFS(bar)
	bar.left:SetPoint("LEFT", 2, RCD.db.RaidCDHeight)
	bar.left:SetJustifyH("LEFT")
	bar.left:SetSize(RCD.db.RaidCDWidth*2/3, RCD.db.RaidCDHeight)

	bar.right = S:CreateFS(bar)
	bar.right:SetPoint("RIGHT", 1, RCD.db.RaidCDHeight)
	bar.right:SetJustifyH("RIGHT")

	bar.icon = CreateFrame("Button", nil, bar)
	bar.icon:SetWidth(RCD.db.RaidCDHeight*2)
	bar.icon:SetHeight(RCD.db.RaidCDHeight*2)
	bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
	bar.icon:CreateShadow()
	bar:CreateShadow(0.5)

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
	bar.endTime = GetTime() + S.CooldownsMod.RaidCD[spellId]
	bar.startTime = GetTime()
	bar.left:SetText(name)
	bar.right:SetText(FormatTime(S.CooldownsMod.RaidCD[spellId]))
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
	if S.CooldownsMod.RaidCD[spellId] and show[select(2, IsInInstance())] then
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
		self:PLAYER_REGEN_ENABLED()
	end
end
function RCD:PLAYER_REGEN_ENABLED()
	for k, v in pairs(bars) do
		v:SetScript("OnUpdate", nil)
		v:Hide()
		v = nil
	end	
	RCD:UpdatePositions()
	wipe(bars)
end
function RCD:UpdateSize()
	RaidCDAnchor:SetSize(self.db.RaidCDWidth, self.db.RaidCDHeight)
	for i = 1, #bars do
		bars[i]:SetSize(self.db.RaidCDWidth, self.db.RaidCDHeight)
	end
end

function RCD:UpdateSet()
	if self.db.RaidCD then
		RCD:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		RCD:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		RCD:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		RCD:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		RCD:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		RCD:UnregisterEvent("PLAYER_REGEN_ENABLED")
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end
function RCD:Initialize()

	RaidCDAnchor:SetSize(self.db.RaidCDWidth, self.db.RaidCDHeight)
	RCD:UpdateSet()
	RaidCDAnchor:SetPoint("LEFT", "UIParent", "LEFT", 30, 0)
	
	S:CreateMover(RaidCDAnchor, "RaidCDAnchorMover", L["团队CD监视"], true, nil, "ALL,MINITOOLS")
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

S:RegisterModule(RCD:GetName())