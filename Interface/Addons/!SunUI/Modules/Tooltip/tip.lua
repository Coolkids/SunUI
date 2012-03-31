local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Tooltips")
local _, ns = ...
function Module:OnInitialize()
C=TooltipDB

local cfg = {
    font = DB.Font,
    fontsize = C["FontSize"]*S.Scale(1),
    outline = "OUTLINE",
    --tex = "Interface\\AddOns\\!SunUI\\Media\\tooltip\\texture",

    scale = 1,
    point = { "BOTTOMRIGHT", "BOTTOMRIGHT", -50, 200 },
    cursor = C["Cursor"],    --true鼠标跟随,false,右下角

    hideTitles = C["HideTitles"],
    hideRealm = false,

    --[[ backdrop = {
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = DB.GlowTex,       --"Interface\\AddOns\\!SunUI\\Media\\ToolTip\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        tileSize = 16,
        edgeSize = 6,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    }, ]]
    bgcolor = { r=0.05, g=0.05, b=0.05, t=0.8 },
    bdrcolor = { r=0.0, g=0.00, b=0.0, a=0.8 },
    --gcolor = { r=1, g=0.12, b=0.80 },
	gcolor = { r=112/255, g=192/255, b=245/255 },
    you = ">>你<<",
    boss = "首領",
    colorborderClass = false,           
    combathide = C["HideInCombat"],                 
}

local classification = {
    elite = "+",
    rare = " 稀有",
    rareelite = " 稀有+",
}

local find = string.find
local format = string.format
local hex = function(color)
    return format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end

local function unitColor(unit)
    local color = { r=1, g=1, b=1 }
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        color = RAID_CLASS_COLORS[class]
        return color
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            color = FACTION_BAR_COLORS[reaction]
            return color
        end
    end
    return color
end


 


function GameTooltip_UnitColor(unit)
    local color = unitColor(unit)
    return color.r, color.g, color.b
end

local function getTarget(unit)
    if UnitIsUnit(unit, "player") then
        return ("|cffff0000%s|r"):format(cfg.you)
    else
        return hex(unitColor(unit))..UnitName(unit).."|r"
    end
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    local name, unit = self:GetUnit()
    if unit then
        if cfg.combathide and InCombatLockdown() then
            return self:Hide()
        end

        local color = unitColor(unit)
        local ricon = GetRaidTargetIndex(unit)

        if ricon then
            local text = GameTooltipTextLeft1:GetText()
            GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[ricon].."18|t", text))
        end

        if UnitIsPlayer(unit) then
            self:AppendText((" |cff00cc00%s|r"):format(UnitIsAFK(unit) and CHAT_FLAG_AFK or 
            UnitIsDND(unit) and CHAT_FLAG_DND or 
            not UnitIsConnected(unit) and "<DC>" or ""))

            if cfg.hideTitles then
                local title = UnitPVPName(unit)
                if title then
                    local text = GameTooltipTextLeft1:GetText()
                    title = title:gsub(name, "")
                    text = text:gsub(title, "")
                    if text then GameTooltipTextLeft1:SetText(text) end
                end
            end

            if cfg.hideRealm then
                local _, realm = UnitName(unit)
                if realm then
                    local text = GameTooltipTextLeft1:GetText()
                    text = text:gsub("- "..realm, "")
                    if text then GameTooltipTextLeft1:SetText(text) end
                end
            end

            local unitGuild, tmp,tmp2 = GetGuildInfo(unit)
            local text = GameTooltipTextLeft2:GetText()
            if tmp then
               --tmp2=tmp2+1
               GameTooltipTextLeft2:SetText("<"..text..">  "..tmp.."  ("..tmp2..")")
            end
        end


        local alive = not UnitIsDeadOrGhost(unit)
        local level = UnitLevel(unit)

        if level then
            local unitClass = UnitIsPlayer(unit) and hex(color)..UnitClass(unit).."|r" or ""
            local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
            local diff = GetQuestDifficultyColor(level)

            if level == -1 then
                level = "|cffff0000"..cfg.boss
            end

            local classify = UnitClassification(unit)
            local textLevel = ("%s%s%s|r"):format(hex(diff), tostring(level), classification[classify] or "")

            for i=2, self:NumLines() do
                local tiptext = _G["GameTooltipTextLeft"..i]
                if tiptext:GetText():find(LEVEL) then
                    if alive then
                        tiptext:SetText(("%s %s%s %s"):format(textLevel, creature, UnitRace(unit) or "", unitClass):trim())
                    else
                        tiptext:SetText(("%s %s"):format(textLevel, "|cffCCCCCC"..DEAD.."|r"):trim())
                    end
                end

                if tiptext:GetText():find(PVP) then
                    tiptext:SetText(nil)
                end
            end
        end

        if not alive then
            GameTooltipStatusBar:Hide()
        end

        if UnitExists(unit.."target") then
            local tartext = ("%s: %s"):format(TARGET, getTarget(unit.."target"))
            self:AddLine(tartext)
        end

        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
    else
        for i=2, self:NumLines() do
            local tiptext = _G["GameTooltipTextLeft"..i]

            if tiptext:GetText():find(PVP) then
                tiptext:SetText(nil)
            end
        end

        GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
    end

    if GameTooltipStatusBar:IsShown() then
        GameTooltipStatusBar:ClearAllPoints()
		GameTooltipStatusBar:Height(8)
		GameTooltipStatusBar:Point("BOTTOMLEFT", GameTooltipStatusBar:GetParent(), "TOPLEFT", 0, 5)
		GameTooltipStatusBar:Point("BOTTOMRIGHT", GameTooltipStatusBar:GetParent(), "TOPRIGHT", 0, 5)
		if not GameTooltipStatusBar.Shadow then
			GameTooltipStatusBar:CreateShadow("Background")
		end
    end
end)

GameTooltipStatusBar:SetStatusBarTexture(DB.Statusbar)


local numberize = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end

GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
    if not value then
        return
    end
    local min, max = self:GetMinMaxValues()
    if (value < min) or (value > max) then
        return
    end
    local _, unit = GameTooltip:GetUnit()
    if unit then
        min, max = UnitHealth(unit), UnitHealthMax(unit)
        if not self.text then
            self.text = self:CreateFontString(nil, "OVERLAY")
            self.text:SetPoint("CENTER", GameTooltipStatusBar)
            self.text:SetFont(cfg.font, 9*S.Scale(1), cfg.outline)
        end
        self.text:Show()
        local hp = numberize(min).." / "..numberize(max)
        self.text:SetText(hp)
    end
end)

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    local frame = GetMouseFocus()
    if cfg.cursor  then  --and frame == WorldFrame
       tooltip:SetOwner(parent, "ANCHOR_CURSOR")  
		
    else
        tooltip:SetOwner(parent, "ANCHOR_NONE")	
        tooltip:SetPoint(cfg.point[1], UIParent, cfg.point[2], cfg.point[3], cfg.point[4])
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

local function style(frame)
    if not frame.shadow then
        --setBakdrop(frame)
		--frame:CreateShadow("Background")
		frame:SetScale(cfg.scale)
    end

    if frame.GetItem then
        local _, item = frame:GetItem()
		if item then
            local quality = select(3, GetItemInfo(item))
            if quality then
                local r, g, b = GetItemQualityColor(quality)
					if r == 1 and g == 1 and b ==1 then 
						frame:SetBackdropBorderColor(0, 0, 0) 
					else
						frame:SetBackdropBorderColor(0, 0, 0) 
						--frame:SetBackdropBorderColor(r, g, b)
					end
            end
        else
            frame:SetBackdropBorderColor(cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b, cfg.bdrcolor.a)
        end
	end

    if cfg.colorborderClass then
        local _, unit = GameTooltip:GetUnit()
        if UnitIsPlayer(unit) then
            frame:SetBackdropBorderColor(GameTooltip_UnitColor(unit))
        end
    end

    if frame.NumLines then
        for index=1, frame:NumLines() do
            if index == 1 then
                _G[frame:GetName()..'TextLeft'..index]:SetFont(cfg.font, cfg.fontsize+2, cfg.outline)
            else
                _G[frame:GetName()..'TextLeft'..index]:SetFont(cfg.font, cfg.fontsize, cfg.outline)
            end
            _G[frame:GetName()..'TextRight'..index]:SetFont(cfg.font, cfg.fontsize, cfg.outline)
        end
    end
end

local tooltips = {
    GameTooltip,
    ItemRefTooltip,
    ShoppingTooltip1,
    ShoppingTooltip2, 
    ShoppingTooltip3,
    WorldMapTooltip,
    DropDownList1MenuBackdrop, 
    DropDownList2MenuBackdrop,
}

for i, frame in ipairs(tooltips) do
    frame:SetScript("OnShow", function(frame) style(frame)   end)
end
local itemrefScripts = {
    "OnTooltipSetItem",
    "OnTooltipSetAchievement",
    "OnTooltipSetQuest",
    "OnTooltipSetSpell",
}

for i, script in ipairs(itemrefScripts) do
    ItemRefTooltip:HookScript(script, function(self)
        style(self)
    end)
end

if IsAddOnLoaded("ManyItemTooltips") then
    MIT:AddHook("FreebTip", "OnShow", function(frame)  style(frame)   end)
end

local f = CreateFrame"Frame"
f:SetScript("OnEvent", function(self, event, ...) if ns[event] then return ns[event](ns, event, ...) end end)
function ns:RegisterEvent(...) for i=1,select("#", ...) do f:RegisterEvent((select(i, ...))) end end
function ns:UnregisterEvent(...) for i=1,select("#", ...) do f:UnregisterEvent((select(i, ...))) end end

ns:RegisterEvent"PLAYER_LOGIN"
function ns:PLAYER_LOGIN()
    for i, frame in ipairs(tooltips) do
        --frame:CreateShadow()
		style(frame)
		end

    ns:UnregisterEvent"PLAYER_LOGIN"
end
end