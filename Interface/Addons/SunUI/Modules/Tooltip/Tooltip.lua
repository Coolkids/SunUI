local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Tooltips", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local _G = _G
local reactionlist  = {
	[1] = FACTION_STANDING_LABEL1,
	[2] = FACTION_STANDING_LABEL2,
	[3] = FACTION_STANDING_LABEL3,
	[4] = FACTION_STANDING_LABEL4,
	[5] = FACTION_STANDING_LABEL5,
	[6] = FACTION_STANDING_LABEL6,
	[7] = FACTION_STANDING_LABEL7,
	[8] = FACTION_STANDING_LABEL8,
}
local gcol = {.35, 1, .6}										-- Guild Color
local pgcol = {1, .12, .8} 									-- Player's Guild Color
local scale = 1												-- Tooltip scale

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = S.mult,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local tooltips = {
	GameTooltip, 
	ItemRefTooltip,
	ItemRefShoppingTooltip1,
	ItemRefShoppingTooltip2,
	ItemRefShoppingTooltip3,
	ShoppingTooltip1, 
	ShoppingTooltip2, 
	ShoppingTooltip3, 
	WorldMapTooltip, 
	DropDownList1MenuBackdrop, 
	DropDownList2MenuBackdrop, 
}
types = {
	rare = " |cffFF44FFR|r ",
	elite = " |cffFFFF00+|r ",
	worldboss = " |cffFF1919B|r ",
	rareelite = " |cff9933FAR|r|cffFFFF00+|r ",
}
local tooptexture = GameTooltipStatusBar:GetStatusBarTexture()

function GameTooltip_UnitColor(unit)
	local r, g, b = 1, 1, 1
	if UnitPlayerControlled(unit) then
		if UnitCanAttack(unit, "player") then
			if UnitCanAttack("player", unit) then
				r = FACTION_BAR_COLORS[2].r
				g = FACTION_BAR_COLORS[2].g
				b = FACTION_BAR_COLORS[2].b
			end
		elseif UnitCanAttack("player", unit) then
			r = FACTION_BAR_COLORS[4].r
			g = FACTION_BAR_COLORS[4].g
			b = FACTION_BAR_COLORS[4].b
		elseif UnitIsPVP(unit) then
			r = FACTION_BAR_COLORS[6].r
			g = FACTION_BAR_COLORS[6].g
			b = FACTION_BAR_COLORS[6].b
		end
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			r = FACTION_BAR_COLORS[reaction].r
			g = FACTION_BAR_COLORS[reaction].g
			b = FACTION_BAR_COLORS[reaction].b
		end
	end
	if UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		if class then
			r = RAID_CLASS_COLORS[class].r
			g = RAID_CLASS_COLORS[class].g
			b = RAID_CLASS_COLORS[class].b
		end
	end
	return r, g, b
end

local hex = function(r, g, b)
	return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

local truncate = function(value)
	if value >= 1e6 then
		return string.format('%.2fm', value / 1e6)
	elseif value >= 1e4 then
		return string.format('%.1fk', value / 1e3)
	else
		return string.format('%.0f', value)
	end
end
local function LevelColor(target)
	local player = UnitLevel("player")
	local temp, color = 0, {}
	if target > 0 then
		temp = target - player
	end
	if target < 0 then
		color = {["r"] = 1, ["g"] = 0.1, ["b"] = 0.1}
	elseif temp >= 5 then
		color = {["r"] = 1, ["g"] = 1, ["b"] = 0}
	elseif temp < 5 and temp >= 3 then
		color = {["r"] = 1, ["g"] = 0.5, ["b"] = 0.25}
	elseif temp < 3 and temp > -3 then
		color = {["r"] = 1, ["g"] = 1, ["b"] = 0}
	elseif temp <= -3 and temp > -9 then
		color = {["r"] = 0.25, ["g"] = 0.75, ["b"] = 0.25}
	elseif temp <= -9 then
		color = {["r"] = 0.5, ["g"] = 0.5, ["b"] = 0.5}	
	end
	return color
end
local function On_OnTooltipSetUnit(self)
	local unit = select(2, self:GetUnit())
	if unit then
		local unitClassification = types[UnitClassification(unit)] or " "
		local creatureType = UnitCreatureType(unit) or ""
		local unitName = UnitName(unit)
		local unitLevel = UnitLevel(unit)
		local diffColor = LevelColor(unitLevel)
		--local diffColor = unitLevel > 0 and GetQuestDifficultyColor(UnitLevel(unit)) or QuestDifficultyColors["impossible"]
		--print(diffColor.r, diffColor.g, diffColor.b, unitLevel)
		if unitLevel < 0 then unitLevel = '??' end
		if UnitIsPlayer(unit) then
			local unitRace = UnitRace(unit)
			local unitClass, class = UnitClass(unit)
			local guild, rank, tmp2 = GetGuildInfo(unit)
			local playerGuild = GetGuildInfo("player")
			GameTooltipStatusBar:SetStatusBarColor(unpack({GameTooltip_UnitColor(unit)}))
			local r, g, b = unpack({GameTooltip_UnitColor(unit)})
			S.CreateTop(tooptexture, r, g, b)
			local a1, a2, a3, a4 = unpack(CLASS_ICON_TCOORDS[class])
			local a1, a2, a3, a4 = a1*62.5 or 0, a2*62.5 or 0, a3*62.5 or 0, a4*62.5 or 0
			local classtr = "|TInterface\\TargetingFrame\\UI-Classes-Circles:"..DB.FontSize..":"..DB.FontSize..":0:0:64:64:"..a1..":"..a2..":"..a3..":"..a4.."|t"
			--print(classtr)
			if guild then
				if guild:len()> 30 then guild = guild:sub(1, 30).."..." end
				GameTooltipTextLeft2:SetFormattedText("<%s>"..hex(1, 1, 1).." %s|r", guild, rank.."  ("..tmp2..")")
				if IsInGuild() and guild == playerGuild then
					GameTooltipTextLeft2:SetTextColor(pgcol[1], pgcol[2], pgcol[3])
				else
					GameTooltipTextLeft2:SetTextColor(gcol[1], gcol[2], gcol[3])
				end
			end
			for i=2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft" .. i]:GetText():find(PLAYER) then
					_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r ", unitLevel) .. unitRace .. " "..classtr..hex(unpack({GameTooltip_UnitColor(unit)}))..unitClass.."|r")
					break
				end
			end
			for i=2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft"..i]:GetText() and (_G["GameTooltipTextLeft" .. i]:GetText():find(FACTION_ALLIANCE) or  _G["GameTooltipTextLeft" .. i]:GetText():find(FACTION_HORDE)) then
					_G["GameTooltipTextLeft"..i]:SetText(nil)
					break
				end
			end
			if UnitFactionGroup(unit) and UnitFactionGroup(unit) ~= "Neutral" then
				GameTooltipTextLeft1:SetText("|TInterface\\Addons\\SunUI\\media\\UI-PVP-"..select(1, UnitFactionGroup(unit))..".blp:16:16:0:0:64:64:5:40:0:35|t"..GameTooltipTextLeft1:GetText())
			end
		elseif ( UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) ) then
			local petLevel = UnitBattlePetLevel(unit)
			local petType = _G["BATTLE_PET_DAMAGE_NAME_"..UnitBattlePetType(unit)]
			for i=2, GameTooltip:NumLines() do
				local text = _G["GameTooltipTextLeft" .. i]:GetText()
				if text:find(LEVEL) then
					_G["GameTooltipTextLeft" .. i]:SetText(petLevel .. unitClassification .. petType)
					break
				end
			end
		else
			for i=2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft" .. i]:GetText():find(LEVEL) or _G["GameTooltipTextLeft" .. i]:GetText():find(creatureType) then
					_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r", unitLevel) .. unitClassification .. creatureType)
					break
				end
			end
		end
		if (not UnitIsPlayer(unit)) then 
			local reaction = UnitReaction(unit, "player");
			if ( reaction ) then
				local r = FACTION_BAR_COLORS[reaction].r
				local g = FACTION_BAR_COLORS[reaction].g
				local b = FACTION_BAR_COLORS[reaction].b
				for i=2, GameTooltip:NumLines() do
					if _G["GameTooltipTextLeft" .. i]:GetText():find(LEVEL) or _G["GameTooltipTextLeft" .. i]:GetText():find(creatureType) then
						_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r", unitLevel) .. unitClassification .. creatureType .. hex(r, g, b) .."  (".. reactionlist[reaction] .. ")|r")
						break
					end
				end
				GameTooltipStatusBar:SetStatusBarColor(r, g, b)
				S.CreateTop(tooptexture, r, g, b)
			end
		end
		if UnitIsPVP(unit) then
			for i = 2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft"..i]:GetText() and _G["GameTooltipTextLeft"..i]:GetText():find(PVP) then
					_G["GameTooltipTextLeft"..i]:SetText(nil)
					break
				end
			end
		end
		if UnitExists(unit.."target") then
			local r, g, b = GameTooltip_UnitColor(unit.."target")
			if UnitName(unit.."target") == UnitName("player") then
				text = hex(1, 0, 0)..">>"..YOU.."<<|r"
			else
				text = hex(r, g, b)..UnitName(unit.."target").."|r"
			end
			self:AddLine(TARGET..": "..text)
		end
		if C["HideTitles"] then
			local name = self:GetUnit()
			local title = UnitPVPName(unit)
			if title then
				local text = GameTooltipTextLeft1:GetText()
				title = title:gsub(name, "")
				text = text:gsub(title, "")
				if text then GameTooltipTextLeft1:SetText(text) end
			end
		end
	end
end
function Module:PLAYER_ENTERING_WORLD()
	Module:UnregisterEvent("PLAYER_ENTERING_WORLD")
	for _, v in pairs(tooltips) do
		v:SetScale(scale)
		v:SetScript("OnShow", function(self)
			if InCombatLockdown() and C["HideInCombat"] then self:Hide() end
			if v.NumLines then
				for index=1, v:NumLines() do
					_G[v:GetName()..'TextLeft'..index]:SetShadowOffset(S.mult, -S.mult)
				end
			end
		end)
	end

	GameTooltipStatusBar.bg = CreateFrame("Frame", nil, GameTooltipStatusBar)
	GameTooltipStatusBar.bg:Point("TOPLEFT", GameTooltipStatusBar, "TOPLEFT", -1, 1)
	GameTooltipStatusBar.bg:Point("BOTTOMRIGHT", GameTooltipStatusBar, "BOTTOMRIGHT", 1, -1)
	GameTooltipStatusBar.bg:SetFrameStrata(GameTooltipStatusBar:GetFrameStrata())
	GameTooltipStatusBar.bg:SetFrameLevel(GameTooltipStatusBar:GetFrameLevel() - 1)
	GameTooltipStatusBar.bg:SetBackdrop(backdrop)
	GameTooltipStatusBar.bg:SetBackdropColor(0, 0, 0, 0.5)
	GameTooltipStatusBar.bg:SetBackdropBorderColor(0, 0, 0, 1)
	GameTooltipStatusBar:HookScript("OnValueChanged", function(self, value)
		if not value then
			return
		end
		local min, max = self:GetMinMaxValues()
		if value < min or value > max then
			return
		end
		local unit  = select(2, GameTooltip:GetUnit())
		if unit then
			if (not UnitIsPlayer(unit)) then 
				local reaction = UnitReaction(unit, "player");
				if ( reaction ) then
					local r, g, b
					r = FACTION_BAR_COLORS[reaction].r;
					g = FACTION_BAR_COLORS[reaction].g;
					b = FACTION_BAR_COLORS[reaction].b;
					--GameTooltipStatusBar:SetStatusBarColor(r, g, b)
					S.CreateTop(tooptexture, r, g, b)
				end
			end
			if UnitIsPlayer(unit) then
				--GameTooltipStatusBar:SetStatusBarColor(unpack({GameTooltip_UnitColor(unit)}))
				local r, g, b = unpack({GameTooltip_UnitColor(unit)})
				S.CreateTop(tooptexture, r, g, b)
			end
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			if not self.text then
				self.text = self:CreateFontString(nil, "OVERLAY")
				self.text:SetPoint("CENTER")
				self.text:SetFont(DB.Font, 10, "THINOUTLINE")
				-- self.text:SetShadowOffset(R.mult, -R.mult)
			end
			self.text:Show()
			local hp = truncate(min).." / "..truncate(max)
			self.text:SetText(hp)
		else
			if self.text then
				self.text:Hide()
			end
		end
	end)
end
local function On_SetDefaultAnchor(tooltip, parent)
	if C["Cursor"] then
		tooltip:SetOwner(parent, "ANCHOR_CURSOR")
	else
		tooltip:SetOwner(parent, "ANCHOR_NONE")
		local tooltipholder = CreateFrame("Frame", nil, UIParent)
		tooltipholder:SetFrameStrata("TOOLTIP")
		tooltipholder:SetSize(120, 20)
		MoveHandle.Tooltip = S.MakeMoveHandle(tooltipholder, L["鼠标提示"], "Tooltip")
		tooltip:SetPoint("BOTTOMRIGHT", tooltipholder, "BOTTOMRIGHT", 0, 0)
	end	
	tooltip.default = 1
end
local function On_ANCHOR_CURSOR(self, ...)
	if self:GetAnchorType() == "ANCHOR_CURSOR" then
		local x, y = GetCursorPosition()
		local effScale = self:GetEffectiveScale()
		local width = self:GetWidth() or 0
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / effScale +5, y / effScale + 20)
	end
	--颜色
	--[[ local unit = select(2, self:GetUnit())
	if unit then
		if (not UnitIsPlayer(unit)) then 
			local reaction = UnitReaction(unit, "player");
			if ( reaction ) then
				local r, g, b
				local r = FACTION_BAR_COLORS[reaction].r
				local g = FACTION_BAR_COLORS[reaction].g
				local b = FACTION_BAR_COLORS[reaction].b
				self.bg:SetBackdropColor(r/3, g/3, b/3, .6)
			end
		else
			self.bg:SetBackdropColor(0, 0, 0, .6)
		end
	else
		self.bg:SetBackdropColor(0, 0, 0, .6)
	end ]]
end

local function SkinTooltip()
	local tooltips = {
		"GameTooltip",
		"ItemRefTooltip",
		"ShoppingTooltip1",
		"ShoppingTooltip2",
		"ShoppingTooltip3",
		"WorldMapTooltip",
		"ChatMenu",
		"EmoteMenu",
		"LanguageMenu",
		"VoiceMacroMenu",
	}

	local backdrop = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeSize = S.mult,
	}

	-- so other stuff which tries to look like GameTooltip doesn't mess up
	local getBackdrop = function()
		return backdrop
	end

	local getBackdropColor = function()
		return 0, 0, 0, .6
	end

	local getBackdropBorderColor = function()
		return 0, 0, 0
	end

	for i = 1, #tooltips do
		local t = _G[tooltips[i]]
		t:SetBackdrop(nil)
		local bg = CreateFrame("Frame", nil, t)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
		bg:SetFrameLevel(t:GetFrameLevel()-1)
		bg:SetBackdrop(backdrop)
		bg:SetBackdropColor(0, 0, 0, .6)
		bg:SetBackdropBorderColor(0, 0, 0)
		t.bg = bg
		t.GetBackdrop = getBackdrop
		t.GetBackdropColor = getBackdropColor
		t.GetBackdropBorderColor = getBackdropBorderColor
	end

	local sb = _G["GameTooltipStatusBar"]
	sb:Height(6)
	sb:ClearAllPoints()
	sb:Point("BOTTOMLEFT", GameTooltip, "TOPLEFT", 1, 3)
	sb:Point("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -1, 3)
	sb:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	S.CreateBD(FriendsTooltip)
	S.CreateMark(sb)
end

function Module:OnInitialize()
	if IsAddOnLoaded("TipTac") or IsAddOnLoaded("FreebTip") or IsAddOnLoaded("bTooltip") or IsAddOnLoaded("PhoenixTooltip") or IsAddOnLoaded("Icetip") then
		return
	end
	C=SunUIConfig.db.profile.TooltipDB
	SkinTooltip()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	tooptexture = GameTooltipStatusBar:GetStatusBarTexture()
	GameTooltip:HookScript("OnTooltipSetUnit", On_OnTooltipSetUnit)
	hooksecurefunc("GameTooltip_SetDefaultAnchor", On_SetDefaultAnchor)
	GameTooltip:HookScript("OnUpdate", On_ANCHOR_CURSOR)
end