local S, C, L, DB, _ = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("MiniMapPanels")

function Module:OnInitialize()
	C = C["MiniDB"]
	if C["MiniMapPanels"] ~= true then return end
	local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
	wm:SetParent(UIParent) 
	wm:SetFrameLevel(3)
	wm:ClearAllPoints() 
	wm:SetPoint("TOP", -90, -5)
	wm:SetSize(50, 8)
	wm:Hide()
	wm:SetAlpha(0)
	wm:SetScript("OnEnter", function(self)
		UIFrameFadeIn(self, 2, self:GetAlpha(), 1)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:AddLine("团队工具", .6,.8,1)
		GameTooltip:Show()
	end)
	wm:SetScript("OnLeave", function(self) 
		UIFrameFadeOut(self, 2, self:GetAlpha(), 0)
		GameTooltip:Hide()
	end)
		
	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonLeft:SetAlpha(0) 
	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonMiddle:SetAlpha(0) 
	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonRight:SetAlpha(0) 

	wm:RegisterEvent("GROUP_ROSTER_UPDATE") 
	wm:HookScript("OnEvent", function(self) 
		local raid =  GetNumGroupMembers() > 0 
		if (raid and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))) or (GetNumSubgroupMembers() > 0 and not raid) then 
			self:Show()
		else 
			self:Hide() 
		end 
	end) 

	local wmmenuFrame = CreateFrame("Frame", "wmRightClickMenu", UIParent, "UIDropDownMenuTemplate") 
	local wmmenuList = { 
	{text = L["就位确认"], 
	func = function() DoReadyCheck() end}, 
	{text = L["角色检查"], 
	func = function() InitiateRolePoll() end}, 
	{text = L["转化为团队"], 
	func = function() ConvertToRaid() end}, 
	{text = L["转化为小队"], 
	func = function() ConvertToParty() end}, 
	} 

	wm:SetScript('OnMouseUp', function(self, button) 
		wm:StopMovingOrSizing() 
		if (button=="RightButton") then 
			EasyMenu(wmmenuList, wmmenuFrame, "cursor", -150, 0, "MENU", 2) 
		end 
	end)
	
	S.Reskin(wm)
end 