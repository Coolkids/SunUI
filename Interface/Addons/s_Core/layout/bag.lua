local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("bottomleftbarbag")
local InfoBarStatusColor = {{1, 0, 0}, {1, 1, 0}, {0, 0.4, 1}}

function Module:OnEnable()	
local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("MEDIUM")
Stat:SetFrameLevel(3)

local text  = Stat:CreateFontString(nil, "OVERLAY")
text:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
text:SetShadowOffset(1.25, -1.25)
text:SetShadowColor(0, 0, 0, 0.4)
text:SetPoint("BOTTOMRIGHT", BottomLeftBar, "BOTTOMRIGHT",-15, -8)
Stat:SetParent(BottomLeftBar)

local function Update(self)	
	local free, total = 0, 0
		for i = 0, NUM_BAG_SLOTS do
				free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
		end
	text:SetText(free.."/"..total)
	local r, g, b = S.ColorGradient(free/total, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
	text:SetTextColor(r, g, b)
	self:SetAllPoints(text)
end
	
local function ShowTooltip(self)
	local free, total = 0, 0
		for i = 0, NUM_BAG_SLOTS do
				free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
		end
		local r, g, b = S.ColorGradient(free/total, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
		GameTooltip:AddLine(L["背包"], 0.4, 0.78, 1)
		GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(L["背包剩余"], free, 0.75, 0.9, 1, r, g, b)
	GameTooltip:AddDoubleLine(L["背包总计"], total, 0.75, 0.9, 1, r, g, b)
	GameTooltip:Show()
end

Stat:RegisterEvent("PLAYER_LOGIN BAG_UPDATE")
Stat:SetScript("OnEnter", function() ShowTooltip(Stat) end)
Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
Stat:SetScript("OnMouseDown", function() OpenAllBags() end)
Stat:SetScript("OnUpdate", Update)
Update(Stat)	
end