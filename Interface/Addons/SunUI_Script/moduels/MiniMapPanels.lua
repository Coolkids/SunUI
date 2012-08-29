local S, C, L, DB = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("MiniMapPanels")

function Module:OnInitialize()
	C = C["MiniDB"]
	if C["MiniMapPanels"] ~= true then return end
	local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
	wm:SetParent("UIParent") 
	wm:SetFrameLevel(Minimap:GetFrameLevel()+1)
	wm:ClearAllPoints() 
	wm:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -3, -3) 
	wm:SetSize(16, 16)
	S.Reskin(wm, false)
	S.CreateBG(wm)
	wm:SetText("O")
	wm:Hide()

	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonLeft:SetAlpha(0) 
	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonMiddle:SetAlpha(0) 
	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonRight:SetAlpha(0) 

	wm:RegisterEvent("PARTY_MEMBERS_CHANGED") 
	wm:HookScript("OnEvent", function(self) 
		local raid = GetNumRaidMembers() > 0 
		if (raid and (IsRaidLeader() or IsRaidOfficer())) or (GetNumPartyMembers() > 0 and not raid) then 
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
end 