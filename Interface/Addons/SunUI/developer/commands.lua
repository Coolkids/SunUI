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
		ChatFrame1:AddMessage(L["Frame没名字"])
	else
		ChatFrame1:AddMessage(L["找不到Frame"])
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

SlashCmdList["DISABLE_ADDON"] = function(s) DisableAddOn(s) S:Print(s, "|cffd36b6b"..DISABLE) end
SLASH_DISABLE_ADDON1 = "/dis"   -- You need to reload UI after enabling/disabling addon

SlashCmdList["ENABLE_ADDON"] = function(s) EnableAddOn(s) S:Print(s, "|cfff07100"..ENABLE) end
SLASH_ENABLE_ADDON1 = "/en"   -- You need to reload UI after enabling/disabling addon

SlashCmdList["CLCE"] = function() CombatLogClearEntries() end
SLASH_CLCE1 = "/clc"


-- simple spec and equipment switching
SlashCmdList["SPEC"] = function() 
	if GetActiveSpecGroup()==1 then SetActiveSpecGroup(2) elseif GetActiveSpecGroup()==2 then SetActiveSpecGroup(1) end
end
SLASH_SPEC1 = "/ss"

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
	text = RESET_TO_DEFAULT,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() 
		wipe(SunUIData)
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
		SendChatMessage(TEAM_DISBAND, "RAID")
		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= pName then
				UninviteUnit(name)
			end
		end
	else  --if UnitInParty("player") then
		SendChatMessage(TEAM_DISBAND, "PARTY")
		for i = MAX_PARTY_MEMBERS, 1, -1 do
			if GetPartyMember(i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	end
	LeaveParty()
end
StaticPopupDialogs["DISBAND_RAID"] = {
	text = TEAM_DISBAND.."?",
	button1 = YES,
	button2 = NO,
	OnAccept = GroupDisband,
	timeout = 0,
	whileDead = 1,}
StaticPopupDialogs["ERROR_DISBAND_RAID"] = {
	text = ERR_NOT_IN_GROUP.."\n"..ERR_NOT_IN_INSTANCE_GROUP,
	button1 = YES,
	timeout = 0,
	whileDead = 1,}
SlashCmdList["GROUPDISBAND"] = function()
	if UnitInParty("player") or UnitInRaid("player") then
		StaticPopup_Show("DISBAND_RAID")
	else
		StaticPopup_Show("ERROR_DISBAND_RAID")
	end
end
SLASH_GROUPDISBAND1 = '/rd'
-- convert group from raid to party
SlashCmdList["RAIDTOPARTY"] = function()
	if not IsInRaid() then
		S:Print(ERR_NOT_IN_RAID)
	elseif GetNumGroupMembers() <= MEMBERS_PER_RAID_GROUP and IsInRaid() then
		ConvertToParty()
		S:Print(CONVERT_TO_PARTY)
	else
		S:Print(L["未能转换成小队"])
	end
end
SLASH_RAIDTOPARTY1 = '/rtp'
-- convert group from party to raid
SlashCmdList["PARTYTORAID"] = function()
	if IsInRaid() then
		S:Print(L["你在团队中"])
	elseif GetNumSubgroupMembers() > 0 and not IsInRaid() then
		ConvertToRaid()
		S:Print(CONVERT_TO_PARTY)
	else
		S:Print(L["你不在小队中"])
	end
end
SLASH_PARTYTORAID1 = '/ptr'

StaticPopupDialogs["SUNUI_DBM_CFG_RELOAD"] = {
	text = L["改变DBM参数需重载应用设置"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() S.db.IsSetDBM = false; ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}
StaticPopupDialogs["SUNUI_DBM_NOT_FAUND"] = {
	text = L["您没有安装DBM"],
	button1 = CANCEL,
	timeout = 0,
	whileDead = 1,
}
SlashCmdList["SetDBM"] = function()
	if not UnitAffectingCombat("player") then	
		if IsAddOnLoaded("DBM-Core") then 
			StaticPopup_Show("SUNUI_DBM_CFG_RELOAD") 
		else
			StaticPopup_Show("SUNUI_DBM_NOT_FAUND") 
		end
	end
end
SLASH_SetDBM1 = "/SetDBM"

StaticPopupDialogs["SUNUI_BW_CFG_RELOAD"] = {
	text = L["改变bigwigs参数需重载应用设置"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() S.db.IsSetBW = false; ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}
StaticPopupDialogs["SUNUI_BW_NOT_FAND"] = {
	text = L["您没有安装bigwigs"],
	button1 = CANCEL,
	timeout = 0,
	whileDead = 1,
}
SlashCmdList["SetBW"] = function()
	if not UnitAffectingCombat("player") then	
		if IsAddOnLoaded("BigWigs") then 
			StaticPopup_Show("SUNUI_BW_CFG_RELOAD") 
		else
			StaticPopup_Show("SUNUI_BW_NOT_FAND") 
		end
	end
end
SLASH_SetBW1 = "/SetBW"