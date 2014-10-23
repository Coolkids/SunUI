local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
-- a command to show frame you currently have mouseovered
SLASH_FRAME1 = "/frame"
SlashCmdList["FRAME"] = function(arg)
	if arg ~= "" then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil then FRAME = arg end
	if arg ~= nil and arg:GetName() ~= nil then
		local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
		ChatFrame1:AddMessage("|cffCC0000~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		ChatFrame1:AddMessage("Name: |cffFFD100"..arg:GetName())
		if arg:GetParent() and arg:GetParent():GetName() then
			ChatFrame1:AddMessage("Parent: |cffFFD100"..arg:GetParent():GetName())
		end

		ChatFrame1:AddMessage("Width: |cffFFD100"..format("%.2f", arg:GetWidth()))
		ChatFrame1:AddMessage("Height: |cffFFD100"..format("%.2f", arg:GetHeight()))
		ChatFrame1:AddMessage("Strata: |cffFFD100"..arg:GetFrameStrata())
		ChatFrame1:AddMessage("Level: |cffFFD100"..arg:GetFrameLevel())

		if relativeTo and relativeTo:GetName() then
			ChatFrame1:AddMessage("Point: |cffFFD100"..point.."|r anchored to "..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
		end
		if xOfs then
			ChatFrame1:AddMessage("X: |cffFFD100"..format("%.2f", xOfs))
		end
		if yOfs then
			ChatFrame1:AddMessage("Y: |cffFFD100"..format("%.2f", yOfs))
		end
		ChatFrame1:AddMessage("|cffCC0000~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	elseif arg == nil then
		ChatFrame1:AddMessage("Invalid frame name")
	else
		ChatFrame1:AddMessage("Could not find frame info")
	end
end

-- enable lua error by command
function SlashCmdList.LUAERROR(msg, editbox)
	if (msg == 'on') then
		SetCVar("scriptErrors", 1)
		-- because sometime we need to /rl to show an error on login.
		ReloadUI()
	elseif (msg == 'off') then
		SetCVar("scriptErrors", 0)
	else
		S:Print("/luaerror on - /luaerror off")
	end
end
SLASH_LUAERROR1 = '/luaerror'

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/gm"

SlashCmdList["READYCHECK"] = function() DoReadyCheck() end
SLASH_READYCHECK1 = '/rc'

SlashCmdList["CHECKROLE"] = function() InitiateRolePoll() end
SLASH_CHECKROLE1 = '/cr'

SlashCmdList["DISABLE_ADDON"] = function(s) DisableAddOn(s) S:Print(s, format("|cffd36b6b disabled")) end
SLASH_DISABLE_ADDON1 = "/dis"   -- You need to reload UI after enabling/disabling addon

SlashCmdList["ENABLE_ADDON"] = function(s) EnableAddOn(s) S:Print(s, format("|cfff07100 enabled")) end
SLASH_ENABLE_ADDON1 = "/en"   -- You need to reload UI after enabling/disabling addon

SlashCmdList["CLCE"] = function() CombatLogClearEntries() end
SLASH_CLCE1 = "/clc"


-- simple spec and equipment switching
SlashCmdList["SPEC"] = function() 
	if GetActiveSpecGroup()==1 then SetActiveSpecGroup(2) elseif GetActiveSpecGroup()==2 then SetActiveSpecGroup(1) end
end
SLASH_SPEC1 = "/ss"

-- Quest tracker(by Tukz)
--[[
local wf = _G["ObjectiveTrackerFrame"]
local wfmove = false 

wf:SetMovable(true);
wf:SetClampedToScreen(false); 
wf:ClearAllPoints()
wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -35, -200)
wf:SetUserPlaced(true)
wf:SetSize(180, 500)
wf.SetPoint = function() end
local wfg = CreateFrame("Frame", nil, UIParent)
wfg:SetPoint("TOPLEFT", wf, "TOPLEFT")
wfg:SetPoint("BOTTOMRIGHT", wf, "BOTTOMRIGHT")
wfg.text = wfg:CreateFontString(nil, "OVERLAY")
wfg:Hide()
local function WATCHFRAMELOCK()
	if not wfg.shadow then
		wfg:CreateShadow("Background") 
		wfg.text:SetFont(S["media"].font, 14, "THINOUTLINE")
		wfg.text:SetText("点我拖动")
		wfg.text:SetPoint("TOP", wfg, "TOP")
	end
	if wfmove == false then
		wfmove = true
		wfg:Show()
		S:Print("|cffFFD700任务追踪框|r |cff228B22解锁|r")
		wf:EnableMouse(true);
		wf:RegisterForDrag("LeftButton"); 
		wf:SetScript("OnDragStart", wf.StartMoving); 
		wf:SetScript("OnDragStop", wf.StopMovingOrSizing);
	elseif wfmove == true then
		wf:EnableMouse(false);
		wfmove = false
		wfg:Hide()
		S:Print("|cffFFD700任务追踪框|r |cffFF0000锁定|r")
	end
end
SLASH_WATCHFRAMELOCK1 = "/wf"
SlashCmdList["WATCHFRAMELOCK"] = WATCHFRAMELOCK
-- VS移动(by Coolkid)
local vs = _G["VehicleSeatIndicator"]
local vsmove = false 

vs:SetMovable(true);
vs:SetClampedToScreen(false);
vs:ClearAllPoints()
vs:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -150, 250)


vs:SetUserPlaced(true)
vs.SetPoint = function() end
local vsg = CreateFrame("Frame", nil, UIParent)
vsg:SetPoint("TOPLEFT", vs, "TOPLEFT")
vsg:SetPoint("BOTTOMRIGHT", vs, "BOTTOMRIGHT")
vsg.text = vsg:CreateFontString(nil, "OVERLAY")
vsg:Hide()
local function VSLOCK()
	if not vsg.shadow then
		vsg.text:SetFont(S["media"].font, 14, "THINOUTLINE")
		vsg.text:SetText("点我拖动")
		vsg.text:SetPoint("TOP", vsg, "TOP")
		vsg:CreateShadow("Background")
	end
	if vsmove == false then
		vsmove = true
		vsg:Show()
		S:Print("|cffFFD700载具框|r |cff228B22解锁|r")
		vs:EnableMouse(true);
		vs:RegisterForDrag("LeftButton"); 
		vs:SetScript("OnDragStart", vs.StartMoving); 
		vs:SetScript("OnDragStop", vs.StopMovingOrSizing);
	elseif vsmove == true then
		vs:EnableMouse(false);
		vsmove = false
		vsg:Hide()
		S:Print("|cffFFD700载具框|r |cffFF0000锁定|r")
	end
end

SLASH_VehicleSeatIndicatorLOCK1 = "/vs"
SlashCmdList["VehicleSeatIndicatorLOCK"] = VSLOCK
--]]
StaticPopupDialogs["TESTUI"] = {
	text = "测试弹窗系统",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() 
		S:Print("测试弹窗系统")
	end,
	timeout = 0,
	whileDead = 1,
}
SlashCmdList["TESTUI"] = function()
	if not UnitAffectingCombat("player") then
		StaticPopup_Show("TESTUI")
	end
end
SLASH_TESTUI1 = "/testui"

StaticPopupDialogs["CLEARSET"] = {
	text = "确定清空所有设置么",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() 
		wipe(SunUIData)
		wipe(nioTillerDBC)
		wipe(RayWatcherDB)
		wipe(SunUICharacterData)
		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
}
SlashCmdList["CLEARSUNUI"] = function()
	if not UnitAffectingCombat("player") then
		StaticPopup_Show("CLEARSET")
	end
end
SLASH_CLEARSUNUI1 = "/clearset"

SlashCmdList["CLEARGOLD"] = function()
	if not UnitAffectingCombat("player") then
		wipe(S.global.gold)
		ReloadUI()
	end
end
SLASH_CLEARGOLD1 = "/cleargold"

SlashCmdList["CLEARBS"] = function()
	if not UnitAffectingCombat("player") then
		wipe(S.global.BagSyncDB)
		ReloadUI()
	end
end
SLASH_CLEARBS1 = "/clearbs"

SlashCmdList["CLEARCC"] = function()
	if not UnitAffectingCombat("player") then
		wipe(S.global.SavedCurrency)
		ReloadUI()
	end
end
SLASH_CLEARCC1 = "/clearcc"

---------------- > Disband Group
local GroupDisband = function()
	local pName = UnitName("player")
	if UnitInRaid("player") then
	SendChatMessage("解散团队", "RAID")
		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= pName then
				UninviteUnit(name)
			end
		end
	else
		SendChatMessage("解散小队", "PARTY")
		for i = MAX_PARTY_MEMBERS, 1, -1 do
			if GetPartyMember(i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	end
	LeaveParty()
end
StaticPopupDialogs["DISBAND_RAID"] = {
	text = "解散团队?",
	button1 = YES,
	button2 = NO,
	OnAccept = GroupDisband,
	timeout = 0,
	whileDead = 1,}
SlashCmdList["GROUPDISBAND"] = function()
	StaticPopup_Show("DISBAND_RAID")
end
SLASH_GROUPDISBAND1 = '/rd'
-- convert group from raid to party
SlashCmdList["RAIDTOPARTY"] = function()
	if not IsInRaid() then
		S:Print("你不是团队中")
	elseif GetNumGroupMembers() <= MEMBERS_PER_RAID_GROUP and IsInRaid() then
		ConvertToParty()
		S:Print("已经转换成小队")
	else
		S:Print("未能转换成小队")
	end
end
SLASH_RAIDTOPARTY1 = '/rtp'
-- convert group from party to raid
SlashCmdList["PARTYTORAID"] = function()
	if IsInRaid() then
		S:Print("你在团队中")
	elseif GetNumSubgroupMembers() > 0 and not IsInRaid() then
		ConvertToRaid()
		S:Print("已经转成团队")
	else
		S:Print("你不在小队中")
	end
end
SLASH_PARTYTORAID1 = '/ptr'
