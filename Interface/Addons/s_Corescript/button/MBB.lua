local S, C, L, DB = unpack(s_Core) --Engine
if DB.Nuke == true then return end
--[[ local MBB = MBB_MinimapButtonFrame
S.StripTextures(MBB, Kill)
local MBB = CreateFrame("Button", "ButtonM", ChatFrame1)
MBB:Size(20)
MBB:Point("BOTTOMLEFT", ChatFrame1, "BOTTOMRIGHT", 5, 75)
MBB.text = S.MakeFontString(MBB, 10)
MBB.text:SetPoint("CENTER", MBB, "CENTER", 2, 0)
MBB.text:SetText("M")
MBB.text:SetTextColor(23/255, 132/255, 209/255)
MBB:SetScript("OnMouseUp", function(self, button) 
		MBB_OnLoad() MBB_OnEvent() 
		MBB_SecureOnClick(self, button) MBB_OnClick(button) 
		MBB_SetPositions() MBB_UpdateAltRadioButtons()
end)
MBB:SetScript("OnEnter", function(self, button) 
	GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 6)
	GameTooltip:AddLine("点击显示小地图按钮")
	GameTooltip:AddLine("按钮显示在小地图")
	GameTooltip:Show() 
end)
MBB:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
S.MakeBG(MBB, 0)
S.Reskin(MBB) ]]

local BlackList = { 
	["MiniMapTracking"] = true,
	["MiniMapVoiceChatFrame"] = true,
	["MiniMapWorldMapButton"] = true,
	["MiniMapLFGFrame"] = true,
	["MinimapZoomIn"] = true,
	["MinimapZoomOut"] = true,
	["MiniMapMailFrame"] = true,
	["MiniMapBattlefieldFrame"] = true,
	["MinimapBackdrop"] = true,
	["GameTimeFrame"] = true,
	["TimeManagerClockButton"] = true,
	["FeedbackUIButton"] = true,
	["HelpOpenTicketButton"] = true,
}

local buttons = {}
local MBCF = CreateFrame("Frame", "MinimapButtonCollectFrame", UIParent)
MBCF:SetFrameStrata("BACKGROUND")
MBCF:SetFrameLevel(1)
--MBCF.bg = MBCF:CreateTexture(nil, "BACKGROUND")
--MBCF.bg:SetAllPoints(MBCF)

local function PositionAndStyle()
	--MBCF.bg:SetTexture(0, 0, 0, 1)
	MBCF:SetAlpha(0)
	if select(3, Minimap:GetPoint()):upper():find("TOP") then
		MBCF:SetSize(150, 20)
		MBCF:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -2, -5)
		--MBCF.bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, .6)
		for i =1, #buttons do
			buttons[i]:ClearAllPoints()
			buttons[i]:SetPoint("LEFT", MinimapButtonCollectFrame, "LEFT", (i - 1) * 30, 0)
			buttons[i].ClearAllPoints = DB.dummy
			buttons[i].SetPoint = DB.dummy
		end
	else
		MBCF:SetSize(150, 20)
		MBCF:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", -2, 5)
		--MBCF.bg:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.6, 0, 0, 0, 0)
		for i =1, #buttons do
			buttons[i]:ClearAllPoints()
			buttons[i]:SetPoint("LEFT", MinimapButtonCollectFrame, "LEFT", (i - 1) * 30 , 0)
			buttons[i].ClearAllPoints = DB.dummy
			buttons[i].SetPoint = DB.dummy
		end
	end
end

local MinimapButtonCollect = CreateFrame("Frame")
MinimapButtonCollect:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapButtonCollect:SetScript("OnEvent", function(self)
	for i, child in ipairs({Minimap:GetChildren()}) do
		if not BlackList[child:GetName()] then
			if child:GetObjectType() == 'Button' and child:GetNumRegions() >= 3 then
				child:SetParent("MinimapButtonCollectFrame")
				for j = 1, child:GetNumRegions() do
					if select(j, child:GetRegions()):GetTexture():find("Highlight") then
						S.Kill(select(j, child:GetRegions()))
					end
				end
				tinsert(buttons, child)
			end
		end
	end
	if #buttons == 0 then 
		MBCF:Hide() 
	else
		for _, child in ipairs(buttons) do
			child:HookScript("OnEnter", function()
				UIFrameFadeIn(MBCF, .5, MBCF:GetAlpha(), 1)
			end)
			child:HookScript("OnLeave", function()
				UIFrameFadeOut(MBCF, .5, MBCF:GetAlpha(), 0)
			end)
		end
	end
	PositionAndStyle()
end)

MBCF:SetScript("OnEnter", function(self)
	UIFrameFadeIn(self, .5, self:GetAlpha(), 1)
end)

Minimap:HookScript("OnEnter", function()
	UIFrameFadeIn(MBCF, .5, MBCF:GetAlpha(), 1)
end)

MBCF:SetScript("OnLeave", function(self)
	UIFrameFadeOut(self, .5, self:GetAlpha(), 0)
end)

Minimap:HookScript("OnLeave", function()
	UIFrameFadeOut(MBCF, .5, MBCF:GetAlpha(), 0)
end)

hooksecurefunc(Minimap, "SetPoint", function()
			MBCF:ClearAllPoints()
			PositionAndStyle()
end)