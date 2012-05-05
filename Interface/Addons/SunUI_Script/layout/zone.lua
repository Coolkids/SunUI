local S, C, L, DB = unpack(SunUI)
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("bottomleftbarzone")


function Module:OnEnable()		
local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("MEDIUM")
Stat:SetFrameLevel(3)

local text  = Stat:CreateFontString(nil, "OVERLAY")
text:SetFont(DB.Font, 12*S.Scale(1)*MiniDB["FontScale"], "THINOUTLINE")
text:SetShadowOffset(1.25, -1.25)
text:SetShadowColor(0, 0, 0, 0.4)
text:Point("BOTTOM", BottomLeftBar, "BOTTOM", 0, -8)
Stat:SetParent(BottomLeftBar)

local function Update(self)	
		pvp,_,_ = GetZonePVPInfo()
		if pvp == "friendly" then r,g,b = 0.1,1,0.1 elseif pvp == "sanctuary" then r,g,b = 0.41,0.8,0.94 elseif pvp =="arena" then r,g,b = 1,0.1,0.1 elseif pvp == "hostile" then r,g,b = 1,0.1,0.1 elseif pvp == "contested" then r,g,b = 1,0.7,0 elseif pvp == "combat" then r,g,b = 1,0.1,0.1 else r,g,b = 1,1,1 end
		text:SetText(GetMinimapZoneText())
		text:SetTextColor(r,g,b)
		self:SetAllPoints(text)
end

local function ShowTooltip(self)
		pvp,_,_ = GetZonePVPInfo()
		if pvp == "friendly" then r,g,b = 0.1,1,0.1 elseif pvp == "sanctuary" then r,g,b = 0.41,0.8,0.94 elseif pvp =="arena" then r,g,b = 1,0.1,0.1 elseif pvp == "hostile" then r,g,b = 1,0.1,0.1 elseif pvp == "contested" then r,g,b = 1,0.7,0 elseif pvp == "combat" then r,g,b = 1,0.1,0.1 else r,g,b = 1,1,1 end
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
		GameTooltip:AddLine(L["地区"], 0.4, 0.78, 1)
		GameTooltip:AddLine(" ")
	GameTooltip:AddLine(GetZoneText(), r, g, b)
	GameTooltip:AddLine(GetMinimapZoneText(), r, g, b)
	GameTooltip:Show()
end

Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
Stat:RegisterEvent("ZONE_CHANGED")
Stat:RegisterEvent("ZONE_CHANGED_INDOORS")
Stat:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Stat:SetScript("OnEnter", function() ShowTooltip(Stat) end)
Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
Stat:SetScript("OnMouseDown", function() ToggleFrame(WorldMapFrame) end)
Stat:SetScript("OnUpdate", Update)
Update(Stat)
end