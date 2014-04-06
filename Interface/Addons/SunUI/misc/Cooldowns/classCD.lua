local S, L, DB, _, C = unpack(select(2, ...))
local CCD = S:NewModule("ClassCD", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

CCD.modName = L["内置CD监视"]

function CCD:GetOptions()
	local options = {
			ClassCDOpen = {
				type = "toggle",
				name = L["内置CD监视"],
				order = 1,
				get = function() return self.db.ClassCDOpen end,
				set = function(_, value) 
					self.db.ClassCDOpen = value
					CCD:UpdateSet()
				end,
			},
			group = {
				type = "group", order = 2,
				name = " ",guiInline = true,
				disabled = function(info) return not self.db.ClassCDOpen end,
				args = {
					ClassCDIcon = {
						type = "toggle",
						name = L["启用图标模式"],
						order = 1,
					},
					ClassCDIconSize = {
						type = "input",
						name = L["图标大小"],
						desc = L["图标大小"], disabled = function(info) return not self.db.ClassCDIcon end,
						order = 2,
						get = function() return tostring(self.db.ClassCDIconSize) end,
						set = function(_, value) 
							self.db.ClassCDIconSize = tonumber(value) 
							CCD:UpdateSize()
						end,
					},
					ClassCDIconDirection = {
						type = "select",
						name = L["BUFF增长方向"],
						desc = L["BUFF增长方向"],
						order = 3, disabled =function(info) return not self.db.ClassCDIcon end,
						values = {[1] = L["从左向右"], [2] = L["从右向左"]},
						get = function() return self.db.ClassCDIconDirection end,
						set = function(_, value) 
							self.db.ClassCDIconDirection = value
							CCD:UpdatePositions()
						end,
					},
					ClassCDWidth = {
						type = "input",
						name = L["框体宽度"],
						desc = L["框体宽度"], disabled = function(info) return self.db.ClassCDIcon end,
						order = 5,
						get = function() return tostring(self.db.ClassCDWidth) end,
						set = function(_, value) 
							self.db.ClassCDWidth = tonumber(value) 
							CCD:UpdateSize()
						end,
					},
					ClassCDHeight = {
						type = "input",
						name = L["框体高度"],
						desc = L["框体高度"],
						order = 6, disabled =  function(info) return self.db.ClassCDIcon end,
						get = function() return tostring(self.db.ClassCDHeight) end,
						set = function(_, value) 
							self.db.ClassCDHeight = tonumber(value)
							CCD:UpdateSize()
						end,
					},
					ClassCDDirection = {
						type = "select",
						name = L["计时条增长方向"],
						desc = L["计时条增长方向"],
						order = 7, disabled = function(info) return self.db.ClassCDIcon end,
						values = {[1] = L["向下"], [2] = L["向上"]},
						get = function() return self.db.ClassCDDirection end,
						set = function(_, value) 
							self.db.ClassCDDirection = value 
							CCD:UpdatePositions()
						end,
					},
				}		
			},
	}
	return options
end

local show = {
	raid = true,
	party = true,
	arena = true,
	none = true,
}
local class_spells = S.CooldownsMod.ClassCD

local EVENT = {
	["SPELL_DAMAGE"] = true,
	["SPELL_PERIODIC_HEAL"] = true,
	["SPELL_HEAL"] = true,
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_ENERGIZE"] = true,
	["SPELL_CAST_SUCCESS"] = true,
	["SPELL_CAST_START"] = true, -- for early frost
	["SPELL_SUMMON"] = true, -- for t12 2p
}
local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local timer = 0
local bars = {}
local ClassCDAnchor = CreateFrame("Frame", "ClassCDAnchor", UIParent)
local FormatTime = function(time)
	if time >= 60 then
		return sformat("%.2d:%.2d", floor(time / 60), time % 60)
	else
		return sformat("%.2d", time)
	end
end

function CCD:UpdatePositions()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		bars[i].id = i
		if not self.db.ClassCDIcon then
			if i == 1 then
				bars[i]:SetPoint("CENTER", ClassCDAnchor)
			else
				if self.db.ClassCDDirection == 2 then
					bars[i]:SetPoint("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, self.db.ClassCDHeight*2-3)
				else
					bars[i]:SetPoint("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, -self.db.ClassCDHeight*2+3)
				end
			end
		else
			if i == 1 then
				bars[i]:SetPoint("CENTER", ClassCDAnchor)
			else
				if self.db.ClassCDIconDirection == 1 then
					bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
				else
					bars[i]:SetPoint("RIGHT", bars[i-1], "LEFT", -5, 0)
				end
			end
		end
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	CCD:UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	if not CCD.db.ClassCDIcon then
		self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
		self.right:SetText(FormatTime(self.endTime - curTime))
		else
		self.right = FormatTime(self.endTime - curTime)
	end
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetSpellByID(self.spell)
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if not CCD.db.ClassCDIcon then 
		if button == "LeftButton" then
			if IsInRaid() then
				SendChatMessage(sformat(COOLDOWN_REMAINING.." %s: %s", self.left:GetText(), self.right:GetText()), "RAID")
			elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
				SendChatMessage(sformat(COOLDOWN_REMAINING.." %s: %s", self.left:GetText(), self.right:GetText()), "INSTANCE_CHAT")
			elseif IsInGroup() then
				SendChatMessage(sformat(COOLDOWN_REMAINING.." %s: %s", self.left:GetText(), self.right:GetText()), "PARTY")
			else
				SendChatMessage(sformat(COOLDOWN_REMAINING.." %s: %s", self.left:GetText(), self.right:GetText()), "SAY")
			end
		elseif button == "RightButton" then
			StopTimer(self)
		end
	else
		if button == "LeftButton" then
			if IsInRaid() then
				SendChatMessage(sformat("SunUI"..COOLDOWN_REMAINING.." %s: %s", GetSpellInfo(self.spell), self.right), "RAID")
			elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
				SendChatMessage(sformat("SunUI"..COOLDOWN_REMAINING.." %s: %s", GetSpellInfo(self.spell), self.right), "INSTANCE_CHAT")
			elseif IsInGroup() then
				SendChatMessage(sformat("SunUI"..COOLDOWN_REMAINING.." %s: %s", GetSpellInfo(self.spell), self.right), "PARTY")
			else
				SendChatMessage(sformat("SunUI"..COOLDOWN_REMAINING.." %s: %s", GetSpellInfo(self.spell), self.right), "SAY")
			end
		elseif button == "RightButton" then
			StopTimer(self)
		end
	end
end

local CreateBar = function()
	local A = S:GetModule("Skins")
	if not CCD.db.ClassCDIcon then
		local bar = CreateFrame("Statusbar", nil, UIParent)
		bar:SetFrameStrata("LOW")
		bar:SetSize(CCD.db.ClassCDWidth, CCD.db.ClassCDHeight)
		bar:SetStatusBarTexture(S["media"].normal)
		bar:SetMinMaxValues(0, 100)
		A:CreateMark(bar)

		bar.left = S:CreateFS(bar)
		bar.left:SetPoint("LEFT", 2, CCD.db.ClassCDHeight)
		bar.left:SetJustifyH("LEFT")
		bar.left:SetSize(CCD.db.ClassCDWidth, CCD.db.ClassCDHeight)

		bar.right = S:CreateFS(bar)
		bar.right:SetPoint("RIGHT", 1, CCD.db.ClassCDHeight)
		bar.right:SetJustifyH("RIGHT")

		bar.icon = CreateFrame("Button", nil, bar)
		bar.icon:SetWidth(CCD.db.ClassCDHeight*2)
		bar.icon:SetHeight(CCD.db.ClassCDHeight*2)
		bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
		bar.icon:CreateShadow()
		bar:CreateShadow(0.5)
		return bar
	else
		bar = CreateFrame("Button", nil, UIParent)
		bar:SetFrameStrata("LOW")
		bar:SetSize(CCD.db.ClassCDIconSize, CCD.db.ClassCDIconSize)
		bar.cooldown = CreateFrame("Cooldown", nil, bar)
		bar.cooldown:SetAllPoints()
		bar.cooldown:SetReverse(true)
		bar:CreateShadow()
		return bar
	end
end

local StartTimer = function(name, spellId, cd)
	for i = 1, #bars do
		if bars[i].spell == spellId then
			return
		end
	end
	local bar = CreateBar()
	local spell, rank, icon = GetSpellInfo(spellId)
	bar.endTime = GetTime() + cd
	bar.startTime = GetTime()
	bar.spell = spellId
	if not CCD.db.ClassCDIcon then
		bar.right:SetText(FormatTime(cd))
		bar.left:SetText(spell)
		bar.icon:SetNormalTexture(icon)
		bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		bar:Show()
		local color = RAID_CLASS_COLORS[select(2, UnitClass(name))]
		if color then
			bar:SetStatusBarColor(color.r, color.g, color.b)
		else
			bar:SetStatusBarColor(0.3, 0.7, 0.3)
		end
	else
		bar:SetNormalTexture(icon)
		bar:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		bar.cooldown:SetReverse(false)
		CooldownFrame_SetTimer(bar.cooldown, GetTime(), cd, 1)
	end

	bar:EnableMouse(true)
	bar:SetScript("OnUpdate", BarUpdate)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	tinsert(bars, bar)
	CCD:UpdatePositions()
end
function CCD:COMBAT_LOG_EVENT_UNFILTERED(null, ...)
	local _, eventType, _, _, sourceName, sourceFlags = ...
	if band(sourceFlags, filter) == 0 or sourceName ~= DB.PlayerName then return end
	local spellId = select(12, ...)
	if class_spells[spellId] and EVENT[eventType] then
		StartTimer(sourceName, spellId, class_spells[spellId].cd)
	end
end

function CCD:ZONE_CHANGED_NEW_AREA()
	if select(2, IsInInstance()) == "arena" then
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end
function CCD:UpdateSize()
	if not self.db.ClassCDIcon then 
		ClassCDAnchor:SetSize(self.db.ClassCDWidth, self.db.ClassCDHeight)
	else
		ClassCDAnchor:SetSize(self.db.ClassCDIconSize, self.db.ClassCDIconSize)
	end
	for i = 1, #bars do
		if self.db.ClassCDIcon then
			bars[i]:SetSize(self.db.ClassCDIconSize, self.db.ClassCDIconSize)
		else
			bars[i]:SetSize(self.db.ClassCDWidth, self.db.ClassCDHeight)
		end
	end
end
function CCD:UpdateSet()
	if self.db.ClassCDOpen then
		CCD:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		CCD:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	else
		CCD:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		CCD:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end
function CCD:Initialize()
	if not self.db.ClassCDIcon then 
		ClassCDAnchor:SetSize(self.db.ClassCDWidth, self.db.ClassCDHeight)
	else
		ClassCDAnchor:SetSize(self.db.ClassCDIconSize, self.db.ClassCDIconSize)
	end
	ClassCDAnchor:SetPoint("LEFT", "UIParent", "LEFT", 30, 240)
	self:UpdateSet()
	S:CreateMover(ClassCDAnchor, "ClassCDAnchorMover", L["内置CD监视"], true, nil, "MINITOOLS")
end

function CCD:Info()
	return L["内置CD监视"]
end
S:RegisterModule(CCD:GetName())

SlashCmdList.ClassCD = function(msg)
	StartTimer(UnitName("player"), 47755, 12)
	StartTimer(UnitName("player"), 31616, 30)
	StartTimer(UnitName("player"), 45182, 90)
end
SLASH_ClassCD1 = "/classcd"