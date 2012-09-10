--[[
  eXPeritia
]]
 
local eXPeritia = CreateFrame("Frame", "eXPeritia", UIParent)
local _G = getfenv(0)
eXPeritia:SetPoint("TOP", UIParent, "TOP", 0, -100)  -- Position of bar
 
local LargeValue = function(value)
  if(value > 999 or value < -999) then
    return string.format("|cffffffff%.0f|rk", value / 1e3)
  else
    return "|cffffffff"..value.."|r"
  end
end
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/0.68
function Scale(x)
	return (mult*math.floor(x/mult+.5))
end
local classColor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
local optionValues = {}
 
local bgleft = eXPeritia:CreateTexture(nil, "BACKGROUND")
bgleft:SetTexture([[Interface\AddOns\eXPeritia\bg-left]])
bgleft:SetPoint("TOPLEFT", -4, 0)
bgleft:SetPoint("BOTTOMRIGHT", eXPeritia, "BOTTOM", 0, 0)
 
local bgright = eXPeritia:CreateTexture(nil, "BACKGROUND")
bgright:SetTexture([[Interface\AddOns\eXPeritia\bg-right]])
bgright:SetPoint("TOPRIGHT", 4, 0)
bgright:SetPoint("BOTTOMLEFT", eXPeritia, "BOTTOM", 0, 0)
 
eXPeritia.Indicator = eXPeritia:CreateTexture(nil, "OVERLAY")
eXPeritia.Last = eXPeritia:CreateTexture(nil, "OVERLAY")
eXPeritia.Rest = eXPeritia:CreateTexture(nil, "OVERLAY")
eXPeritia.Indicator:SetWidth(1)
eXPeritia.Last:SetWidth(1)
eXPeritia.Rest:SetWidth(1)
 
local textIndicator = eXPeritia:CreateFontString(nil, "OVERLAY")
textIndicator:SetFont(ChatFrame1:GetFont(), 14*Scale(1))
textIndicator:SetPoint("LEFT", eXPeritia.Indicator, 10, 0)
textIndicator:SetShadowOffset(1, -1)
eXPeritia.textIndicator = textIndicator
 
local textTopRight = eXPeritia:CreateFontString(nil, "OVERLAY")
textTopRight:SetFont(ChatFrame1:GetFont(), 12*Scale(1))
textTopRight:SetPoint("BOTTOMRIGHT", eXPeritia, "TOPRIGHT", 0, 0)
textTopRight:SetShadowOffset(1, -1)
 
local textBottomRight = eXPeritia:CreateFontString(nil, "OVERLAY")
textBottomRight:SetFont(ChatFrame1:GetFont(), 12*Scale(1))
textBottomRight:SetPoint("TOPRIGHT", eXPeritia, "BOTTOMRIGHT", 0, 0)
textBottomRight:SetShadowOffset(1, -1)

local textTopLeft = eXPeritia:CreateFontString(nil, "OVERLAY")
textTopLeft:SetFont(ChatFrame1:GetFont(), 12*Scale(1))
textTopLeft:SetPoint("BOTTOMLEFT", eXPeritia, "TOPLEFT", 0, 0)
textTopLeft:SetShadowOffset(1, -1)

local textBottomLeft = eXPeritia:CreateFontString(nil, "OVERLAY")
textBottomLeft:SetFont(ChatFrame1:GetFont(), 12*Scale(1))
textBottomLeft:SetPoint("TOPLEFT", eXPeritia, "BOTTOMLEFT", 0, 0)
textBottomLeft:SetShadowOffset(1, -1)
 
eXPeritia:SetMovable(true)
eXPeritia:SetAlpha(0)

function eXPeritia:Enter() if(self.fadeInfo) then UIFrameFadeRemoveFrame(self) end self:SetAlpha(1) end
function eXPeritia:Leave() if(not eXPeritia.forceShown) then self:SetAlpha(0) end end
 
function eXPeritia:ApplyOptions(db)
  local db = db or eXPeritiaDB
  local color = db.ClassColor and classColor or db.Color
  self.Indicator:SetHeight(db.Height)
  self.Last:SetHeight(db.Height/3)
  self.Rest:SetHeight(db.Height/3)
 
  self.Indicator:SetTexture(color.r, color.g, color.b)
  self.Last:SetTexture(color.r, color.g, color.b)
  self.Rest:SetTexture(color.r, color.g, color.b)
  textIndicator:SetTextColor(color.r, color.g, color.b)
  textTopRight:SetTextColor(color.r, color.g, color.b)
  textBottomRight:SetTextColor(color.r, color.g, color.b)
  textTopLeft:SetTextColor(color.r, color.g, color.b)
  textBottomLeft:SetTextColor(color.r, color.g, color.b)
 
  self:SetWidth(db.Width)
  self:SetHeight(db.Height)
  
  self:SetScript("OnEnter", db.MouseOver and eXPeritia.Enter)
  self:SetScript("OnLeave", db.MouseOver and eXPeritia.Leave)
  self:EnableMouse(db.MouseOver)

  self.db = db
  return true
end

local lastXP, lastRep, lastRepName
local fadeOut = { mode = "OUT", timeToFade = 10 }
local StartFadingOut = function()
  fadeOut.fadeTimer = 0
  UIFrameFade(eXPeritia, fadeOut)
end
local fadeIn = { mode = "IN", timeToFade = 0.2 }
 
function eXPeritia:Update(event)
  local noFade
  if(event == "VARIABLES_LOADED") then
    eXPeritiaDB = eXPeritiaDB or {
      ['Width'] = 640,
      ['Height'] = 30,
      ['Color'] = { r = .9, g = .5, b = 0 },
      ['ClassColors'] = true,
	  ['Topleft'] = 6,
	  ['Topright'] = 2,
	  ['Bottomleft'] = 5,
	  ['Bottomright'] = 4,
    }
    noFade = self:ApplyOptions()
  end
  if(event == "UPDATE_FACTION") then self:UpdateRep(noFade) else self:UpdateXP(noFade) end
end

function eXPeritia:Flash()
  if(self:GetAlpha() == 0) then
    fadeIn.fadeTimer = 0
    fadeIn.finishedFunc = StartFadingOut
    UIFrameFade(self, fadeIn)
  end
end

function eXPeritia:UpdateXP(noFade)
  local min, max, rest = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
  self:Move(self.Indicator, min/max)
  if(rest and rest > 0) then
    self.Rest:Show()
    self:Move(self.Rest, (min+rest)/max)
	optionValues[6] = format("|cffffffff%.0f|r%% rest", rest/max*100)
  else
    self.Rest:Hide()
	optionValues[6] = ""
  end
 
  textIndicator:SetFormattedText("|cffffffff%.1f|r%%", min/max*100)
  optionValues[2] = LargeValue(min-max)
  optionValues[3] = LargeValue(min)
  optionValues[5] = format("|cffffffff%.1f|rbars", min/max*20-20)

  if(lastXP and lastXP ~= min) then
    self.Last:Show()
    self:Move(self.Last, lastXP/max)
    optionValues[4] = format("|cffffffff%.0f|rx", (max-min)/(min-lastXP))
  else
    self.Last:Hide()
	optionValues[4] = ""
  end
  lastXP = min
  
  self:UpdateText()
  
  return (noFade or self:Flash())
end

function eXPeritia:UpdateRep(noFade)
  local name, standing, min, max, value = GetWatchedFactionInfo()
  if(not name) then return nil end
  max, min = (max-min), (value-min)

  if(not lastRep) then
	lastRepName = name
	lastRep = min
	return nil
  end

  if(lastRepName == name and lastRep ~= min) then
    self.Last:Show()
    self:Move(self.Last, lastRep/max)
    optionValues[4] = format("|cffffffff%.0f|rx", (max-min)/(min-lastRep))
  elseif(lastRepName ~= name) then
    optionValues[4] = ""
    self.Last:Hide()
  else
    return nil
  end
  lastRepName = name
  lastRep = min
  
  self:Move(self.Indicator, min/max)
  self.Rest:Hide()

  optionValues[6] = format("|cffffffff%s|r (|cffffffff%s|r)", name, _G['FACTION_STANDING_LABEL'..standing])
  
  textIndicator:SetFormattedText("|cffffffff%.1f|r%%", min/max*100)
  optionValues[2] = LargeValue(min-max)
  optionValues[3] = LargeValue(min)
  optionValues[5] = format("|cffffffff%.1f|rbars", min/max*20-20)
  
  self:UpdateText()

  return (noFade or self:Flash())
end

function eXPeritia:UpdateText()
	textTopLeft:SetText(optionValues[self.db["Topleft"] or 1])
	textTopRight:SetText(optionValues[self.db["Topright"] or 1])
	textBottomLeft:SetText(optionValues[self.db["Bottomleft"] or 1])
	textBottomRight:SetText(optionValues[self.db["Bottomright"] or 1])
end

function eXPeritia:Move(ind, percent)
  ind:ClearAllPoints()
  ind:SetPoint("TOPLEFT", self.db.Width*percent, 0)
end

eXPeritia:SetScript("OnEvent", eXPeritia.Update)
eXPeritia:RegisterEvent("PLAYER_XP_UPDATE")
eXPeritia:RegisterEvent('UPDATE_FACTION')
eXPeritia:RegisterEvent("PLAYER_LEVEL_UP")
eXPeritia:RegisterEvent("VARIABLES_LOADED")