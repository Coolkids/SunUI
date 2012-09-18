local S, C, L, DB, _ = unpack(SunUI)
 if IsAddOnLoaded("TipTac") or IsAddOnLoaded("FreebTip") or IsAddOnLoaded("bTooltip") or IsAddOnLoaded("PhoenixTooltip") or IsAddOnLoaded("Icetip") then
	return
end
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Tooltips")
local _G = _G
function Module:OnInitialize()
	C=C["TooltipDB"]
end
function Module:OnEnable()
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
	local types = {}
	if DB.zone == "zhCN" then 
		types = {
		rare = " |cffFF44FF稀有|r ",
		elite = " |cffFFFF00+|r ",
		worldboss = " |cffFF1919首领|r ",
		rareelite = " |cff9933FA稀有|r |cffFFFF00+|r ",
		}
	else
		types = {
		rare = " |cffFF44FF稀有|r ",
		elite = " |cffFFFF00+|r ",
		worldboss = " |cffFF1919首領|r ",
		rareelite = " |cff9933FA稀有|r |cffFFFF00+|r ",
		}
	end

	for _, v in pairs(tooltips) do
		v:SetBackdrop(backdrop)
		v:SetBackdropColor(0, 0, 0, 0.65)
		v:SetBackdropBorderColor(0, 0, 0, 1)
		v:SetScale(scale)
		v:SetScript("OnShow", function(self)
			if InCombatLockdown() and C["HideInCombat"] then self:Hide() end
			self:SetBackdropColor(0, 0, 0, 0.65)
			local item
			if self.GetItem then
				item = select(2, self:GetItem())
			end
			if v.NumLines then
				for index=1, v:NumLines() do
					_G[v:GetName()..'TextLeft'..index]:SetShadowOffset(S.mult, -S.mult)
				end
			end
		end)
		v:HookScript("OnHide", function(self)
			self:SetBackdropBorderColor(0, 0, 0, 1)
		end)
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

	GameTooltip:HookScript("OnTooltipSetUnit", function(self)
		local unit = select(2, self:GetUnit())
		if unit then
			local unitClassification = types[UnitClassification(unit)] or " "
			local creatureType = UnitCreatureType(unit) or ""
			local unitName = UnitName(unit)
			local unitLevel = UnitLevel(unit)
			local diffColor = unitLevel > 0 and GetQuestDifficultyColor(UnitLevel(unit)) or QuestDifficultyColors["impossible"]
			if unitLevel < 0 then unitLevel = '??' end
			if UnitIsPlayer(unit) then
				local unitRace = UnitRace(unit)
				local unitClass = UnitClass(unit)
				local guild, rank, tmp2 = GetGuildInfo(unit)
				local playerGuild = GetGuildInfo("player")
				GameTooltipStatusBar:SetStatusBarColor(unpack({GameTooltip_UnitColor(unit)}))
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
						_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r ", unitLevel) .. unitRace .. " ".. unitClass)
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
					r = FACTION_BAR_COLORS[reaction].r;
					g = FACTION_BAR_COLORS[reaction].g;
					b = FACTION_BAR_COLORS[reaction].b;
					GameTooltipStatusBar:SetStatusBarColor(r, g, b)
				end
			end
			if UnitIsPVP(unit) then
				for i = 2, GameTooltip:NumLines() do
					if _G["GameTooltipTextLeft"..i]:GetText():find(PVP) then
						_G["GameTooltipTextLeft"..i]:SetText(nil)
						break
					end
				end
			end
			if UnitExists(unit.."target") then
				local r, g, b = GameTooltip_UnitColor(unit.."target")
				if UnitName(unit.."target") == UnitName("player") then
					text = hex(1, 0, 0)..">>你<<|r"
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
	end)

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
			if UnitIsPlayer(unit) then
				GameTooltipStatusBar:SetStatusBarColor(unpack({GameTooltip_UnitColor(unit)}))
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
			
	hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
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
	end)

	GameTooltip:HookScript("OnUpdate", function(self, ...)
   if self:GetAnchorType() == "ANCHOR_CURSOR" then
	  local x, y = GetCursorPosition()
	  local effScale = self:GetEffectiveScale()
	  local width = self:GetWidth() or 0
	  self:ClearAllPoints()
	  self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / effScale +5, y / effScale + 20)
   end
end)
end