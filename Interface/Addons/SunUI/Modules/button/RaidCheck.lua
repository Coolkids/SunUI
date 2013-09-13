local S, L, DB, _, C = unpack(select(2, ...))
if DB.zone ~= "zhTW" and DB.zone ~= "zhCN" then return end
local RC = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule('RaidCheck');

local join = string.join
local find = string.find
local format = string.format
local sort = table.sort
local floor = math.floor
local MaxGroup = 5

local EuiSetTooltip = function(f,title,L1,R1,L2,R2,L3,R3,L4,R4)
	f:SetScript("OnEnter", function()
		if not InCombatLockdown() then
			GameTooltip:SetOwner(f, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:ClearLines()
			GameTooltip:SetText(title or " ")
			if title then GameTooltip:AddLine(" ") end
			if L1 and R1 then GameTooltip:AddDoubleLine(L1,R1,16/255,226/255,5/255,1,1,1) end
			if L2 and R2 then GameTooltip:AddLine(" "); GameTooltip:AddDoubleLine(L2,R2,16/255,226/255,5/255,1,1,1) end
			if L3 and R3 then GameTooltip:AddLine(" "); GameTooltip:AddDoubleLine(L3,R3,16/255,226/255,5/255,1,1,1) end
			if L4 and R4 then GameTooltip:AddLine(" "); GameTooltip:AddDoubleLine(L4,R4,16/255,226/255,5/255,1,1,1) end
			GameTooltip:Show()
		end
	end)

	f:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

end

local L = {}
if (GetLocale() == "zhCN") then
	L.RaidCheckMsgOUTRAID = "你不在一个团队中"
	L.RaidCheckMsgFullBuff = "SunUI Buff检查：常规Buff已齐全！"
	L.RaidCheckMsgNoBuff = "SunUI Buff检查：缺少如下！"
		
	L.RaidCheckMsgPosition = "到位检查"
	L.RaidCheckMsgAllInPlace = "%s人全部到位"
	L.RaidCheckMsgInPlace = "已到位%s人"
	L.RaidCheckMsgDead = "%s人死亡"
	L.RaidCheckMsgOffline = "%s人离线"
	L.RaidCheckMsgUnVisible = "%s人过远"
	L.RaidCheckMsgETC = "等."

	L.RaidCheckFlaskData = {
			"合剂",
		}
	L.RaidCheckMsgFlask = "合剂检查"
	L.RaidCheckMsgAllNoFlask = "所有人均无合剂效果"
	L.RaidCheckMsgAllHasFlask = "所有人均已有合剂效果"
	L.RaidCheckMsgNoFlask = "%s人无合剂效果"
	L.RaidCheckMsgHasFlask = "%s人已有合剂效果"

	L.RaidCheckTipLeftButtonOnLeftInfo = "到位情况"
	L.RaidCheckTipRightButtonOnLeftInfo = "就位确认"
	L.RaidCheckTipLeftButtonOnRightInfo = "检查BUFF"
	L.RaidCheckTipRightButtonOnRightInfo = "检查合剂"
	L.RAIDCHECK_RAIDTOOL = "团队工具"

	L.MouseLeftButton = "鼠标左键"
	L.MouseRightButton = "鼠标右键"
	L.MouseClick = "鼠标点击"
	L.BottomPanelRaidCheck = "EUI团队检查工具"
	L.GameSetting = "打开EUI设置界面"

elseif (GetLocale() == "zhTW") then
	L.RaidCheckMsgOUTRAID = "你不在一個團隊中"
	L.RaidCheckMsgFullBuff = "SunUI Buff檢查：常規Buff已齊全！"
	L.RaidCheckMsgNoBuff = "SunUI Buff檢查: 缺少如下！"
		
	L.RaidCheckMsgPosition = "到位檢查"
	L.RaidCheckMsgAllInPlace = "%s人全部到位"
	L.RaidCheckMsgInPlace = "已到位%s人"
	L.RaidCheckMsgDead = "%s人死亡"
	L.RaidCheckMsgOffline = "%s人離線"
	L.RaidCheckMsgUnVisible = "%s人過遠"
	L.RaidCheckMsgETC = "等."

	L.RaidCheckFlaskData = {
			"藥劑",
		}
	L.RaidCheckMsgFlask = "合劑檢查"
	L.RaidCheckMsgAllNoFlask = "所有人均無藥劑效果"
	L.RaidCheckMsgAllHasFlask = "所有人均已有藥劑效果"
	L.RaidCheckMsgNoFlask = "%s人無藥劑效果"
	L.RaidCheckMsgHasFlask = "%s人已有藥劑效果"

	L.RaidCheckTipLeftButtonOnLeftInfo = "到位情況"
	L.RaidCheckTipRightButtonOnLeftInfo = "就位確認"
	L.RaidCheckTipLeftButtonOnRightInfo = "檢查BUFF"
	L.RaidCheckTipRightButtonOnRightInfo = "檢查藥劑"
	L.RAIDCHECK_RAIDTOOL = "團隊工具"

	L.MouseLeftButton = "鼠標左鍵"
	L.MouseRightButton = "鼠標右鍵"
	L.MouseClick = "鼠標點擊"
	L.BottomPanelRaidCheck = "EUI團隊檢查工具"
	L.GameSetting = "打開EUI設置界面"
else
	L.RaidCheckMsgOUTRAID = "you are not a team"
	L.RaidCheckMsgFullBuff = "SunUI Buff check: conventional Buff complete!"
	L.RaidCheckMsgNoBuff = "SunUI Buff check: the lack of the following"

	L.RaidCheckMsgPosition = "place check"
	L.RaidCheckMsgAllInPlace = "% s of people all in place"
	L.RaidCheckMsgInPlace = "% s people has been put in place"
	L.RaidCheckMsgDead = "% s human death."
	L.RaidCheckMsgOffline = "% s people off"
	L.RaidCheckMsgUnVisible = "% s person too far."
	L.RaidCheckMsgETC = "and so on."

	L.RaidCheckFlaskData = {
	"Mixture",
	}
	L.RaidCheckMsgFlask = "Mixture inspection"
	L.RaidCheckMsgAllNoFlask  = "all no mixture effect. "
	L.RaidCheckMsgAllHasFlask = "all existing mixture effect"
	L.RaidCheckMsgNoFlask = "% s mixture effect"
	L.RaidCheckMsgHasFlask = "% s already has a mixture effect"

	L.RaidCheckTipLeftButtonOnLeftInfo = "check team members in place"
	L.RaidCheckTipRightButtonOnLeftInfo = "initiated by the team in place to confirm"
	L.RaidCheckTipLeftButtonOnRightInfo = "check team BUFF"
	L.RaidCheckTipRightButtonOnRightInfo = "check the mixture effect "
	L.RAIDCHECK_RAIDTOOL = "Open team the tools panel"

	L.MouseLeftButton = "left mouse button."
	L.MouseRightButton = "Right"
	L.MouseClick = "mouse clicks"
	L.BottomPanelRaidCheck = "SunUI team checking tool"
	L.GameSetting = "open SunUI set interface"
end

L.RaidCheckBuffMS = GetSpellInfo(21562)
L.RaidCheckBuffFS = GetSpellInfo(1459)
L.RaidCheckBuffFS2 = GetSpellInfo(61316)
L.RaidCheckBuffQS1 = GetSpellInfo(20217)
L.RaidCheckBuffQS2 = GetSpellInfo(19740)
L.RaidCheckBuffXD = GetSpellInfo(1126)
L.RaidCheckBuffFOOD = GetSpellInfo(87564)
L.RaidCheckBuffMONK = GetSpellInfo(115921)

-------------------------------------------------------------------------------------------------------------------
--	团队Buff检查
-------------------------------------------------------------------------------------------------------------------
function RC:CheckRaidBuff()
	local HasClass = {
		ms = false,
		qs = 0,
		xd = false,
		fs = false,
		monk = false,
	}

	local NoMSBuffName = {}
	local NoFSBuffName = {}
	local NoQS1BuffName = {}
	local NoQS2BuffName = {}
	local NoXDBuffName = {}
	local NoMONKBuffName = {}
	local NoFOODBuffName = {}

	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	local raidNum = GetNumGroupMembers()
	if inInstance and instanceType == "raid" then raidNum = maxPlayers end
	
	for i = 1, raidNum do
		local _, _, _, _, _, class, _, online = GetRaidRosterInfo(i)
		if online then
			if class == 'PRIEST' then HasClass.ms = true end
			if class == 'PALADIN' then HasClass.qs = HasClass.qs + 1 end
			if class == 'MAGE' then HasClass.fs = true end
			if class == 'DRUID' then HasClass.xd = true end
			if class == 'MONK' then HasClass.monk = true end
		end
	end
	
	for i = 1, raidNum do
		local name, _, subgroup = GetRaidRosterInfo(i)
		local HasBuffMS = false
		local HasBuffFS = false
		local HasBuffQS1 = false
		local HasBuffQS2 = false
		local HasBuffXD = false
		local HasBuffFOOD = false
		local HasBuffMONK = false
		if subgroup then
			local unit = "raid"..i
			local j = 1
			while UnitBuff(unit, j) do
				local BuffTEXT = UnitBuff(unit, j)
				if find(BuffTEXT, L.RaidCheckBuffMS) then HasBuffMS = true end
				if find(BuffTEXT, L.RaidCheckBuffFS) then HasBuffFS = true end
				if find(BuffTEXT, L.RaidCheckBuffQS1) then HasBuffQS1 = true end --王者
				if find(BuffTEXT, L.RaidCheckBuffQS2) then HasBuffQS2 = true end --力量
				if find(BuffTEXT, L.RaidCheckBuffXD) then HasBuffXD = true end
				if find(BuffTEXT, L.RaidCheckBuffFOOD) then HasBuffFOOD = true end
				if find(BuffTEXT, L.RaidCheckBuffMONK) then HasBuffMONK = true end
				j = j + 1
			end
			
			if HasClass.ms and HasBuffMS == false then table.insert(NoMSBuffName, name) end
			if HasClass.fs and HasBuffFS == false then table.insert(NoFSBuffName, name) end

			if HasClass.gs == 0 and HasClass.xd then
				if HasBuffXD == false then table.insert(NoXDBuffName, name) end		
			elseif HasClass.qs == 1 and HasClass.xd then
				if HasBuffQS2 == false then table.insert(NoQS2BuffName, name) end
				if HasBuffXD == false then table.insert(NoXDBuffName, name) end
			elseif HasClass.qs == 1 and HasClass.xd == false then
				if HasBuffQS1 == false then table.insert(NoQS1BuffName, name) end
			elseif HasClass.qs > 1 then
				if HasBuffQS1 == false and HasBuffXD == false then table.insert(NoQS1BuffName, name) end
				if HasBuffQS2 == false then table.insert(NoQS2BuffName, name) end
			end

			if HasBuffFOOD == false then table.insert(NoFOODBuffName, name) end
		end
	end
	if next(NoMONKBuffName) == nil and next(NoMSBuffName) == nil and next(NoFSBuffName) == nil and next(NoQS1BuffName) == nil and next(NoQS2BuffName) == nil and next(NoXDBuffName) == nil and next(NoFOODBuffName) == nil then
		SendChatMessage(L.RaidCheckMsgFullBuff, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
	else
		SendChatMessage(L.RaidCheckMsgNoBuff, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
		if next(NoMSBuffName) then SendChatMessage(L.RaidCheckBuffMS.. ": ".. table.concat(NoMSBuffName, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID") end
		if next(NoFSBuffName) then SendChatMessage(L.RaidCheckBuffFS.. ": ".. table.concat(NoFSBuffName, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID") end
		if next(NoQS1BuffName) then SendChatMessage(L.RaidCheckBuffQS1.. ": ".. table.concat(NoQS1BuffName, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID") end
		if next(NoQS2BuffName) then SendChatMessage(L.RaidCheckBuffQS2.. ": ".. table.concat(NoQS2BuffName, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID") end
		if next(NoXDBuffName) then SendChatMessage(L.RaidCheckBuffXD.. ": ".. table.concat(NoXDBuffName, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID") end
		if next(NoFOODBuffName) then SendChatMessage(L.RaidCheckBuffFOOD.. ": ".. table.concat(NoFOODBuffName, ","),  IsPartyLFG() and "INSTANCE_CHAT" or "RAID") end
		if next(NoMONKBuffName) then SendChatMessage(L.RaidCheckBuffFOOD.. ": ".. table.concat(NoMONKBuffName, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID") end
	end
end

-------------------------------------------------------------------------------------------------------------------
--	团队成员到位检查
-------------------------------------------------------------------------------------------------------------------
function RC:CheckPosition()

	local UnVisiblePlayer = ""
	local DeadPlayer = ""
	local OfflinePlayer = ""
	local UnVisiblePlayerCount = 0
	local DeadPlayerCount = 0
	local OfflinePlayerCount = 0
	local msg = "["..L.RaidCheckMsgPosition.."]"
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	local RaidNum = GetNumGroupMembers()
	if inInstance and instanceType == "raid" then RaidNum = maxPlayers end

	for i = 1, RaidNum do
		_, _, subgroup = GetRaidRosterInfo(i)
		if subgroup then
			local unit = "raid"..i
			if UnitIsConnected(unit) then
				if not UnitIsDeadOrGhost(unit) then
					if not UnitIsVisible(unit) then
						UnVisiblePlayerCount = UnVisiblePlayerCount + 1
						if UnVisiblePlayerCount > 0 and UnVisiblePlayerCount < 20 then
							UnVisiblePlayer = UnVisiblePlayer..UnitName(unit).."."
						end
						if UnVisiblePlayerCount == 20 then
							UnVisiblePlayer = UnVisiblePlayer.." "..L.RaidCheckMsgETC
						end
					end
				else
					DeadPlayerCount = DeadPlayerCount + 1
					if DeadPlayerCount > 0 and DeadPlayerCount < 10 then
						DeadPlayer = DeadPlayer..UnitName(unit).."."
					end
					if DeadPlayerCount == 10 then
						DeadPlayer = DeadPlayer.." "..L.RaidCheckMsgETC
					end
				end
			else
				OfflinePlayerCount = OfflinePlayerCount + 1
				if OfflinePlayerCount > 0 and OfflinePlayerCount < 10 then
					OfflinePlayer = OfflinePlayer..UnitName(unit).."."
				end
				if OfflinePlayerCount == 10 then
					OfflinePlayer = OfflinePlayer.." "..L.RaidCheckMsgETC
				end
			end
		end
	end

	if UnVisiblePlayerCount == 0 and DeadPlayerCount == 0 and OfflinePlayerCount == 0 then
		msg = msg..format(L.RaidCheckMsgAllInPlace, RaidNum)
	else
		msg = msg..format(L.RaidCheckMsgInPlace, (RaidNum - OfflinePlayerCount - DeadPlayerCount - UnVisiblePlayerCount)).."."
		if UnVisiblePlayerCount > 0 then
			msg = msg..format(L.RaidCheckMsgUnVisible, UnVisiblePlayerCount)..":"..UnVisiblePlayer
		end
		if DeadPlayerCount > 0 then
			msg = msg..format(L.RaidCheckMsgDead, DeadPlayerCount)..":"..DeadPlayer
		end
		if OfflinePlayerCount > 0 then
			msg = msg..format(L.RaidCheckMsgOffline, OfflinePlayerCount)..":"..OfflinePlayer
		end
	end
	
	SendChatMessage(msg, "RAID")
end

-------------------------------------------------------------------------------------------------------------------
--	团队成员合剂检查
-------------------------------------------------------------------------------------------------------------------
function RC:CheckRaidFlask()

	local FlaskText = RAL_TEXT_CHECK_12
	local FlaskDATA = L.RaidCheckFlaskData
	local FlaskPlayer, NoFlaskPlayer = "", ""
	local FlaskPlayerCount, NoFlaskPlayerCount = 0, 0
	local msg = "["..L.RaidCheckMsgFlask.."]"
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	local raidNum = GetNumGroupMembers()
	if inInstance and instanceType == "raid" then raidNum = maxPlayers end
	
	for i = 1,raidNum do
		_, _, subgroup = GetRaidRosterInfo(i)
		if subgroup then
			local unit = "raid"..i
			local j = 1
			local has = 0
			while UnitBuff(unit, j) and has == 0 and UnitIsConnected(unit) do
				for k, v in pairs(FlaskDATA) do
					if find(UnitBuff(unit, j), v) then
						has = 1
						FlaskPlayerCount = FlaskPlayerCount + 1
						FlaskPlayer = FlaskPlayer..UnitName(unit).."."
						break
					end
				end
				j = j + 1
				if not UnitBuff(unit, j) and has == 0 then
					NoFlaskPlayerCount = NoFlaskPlayerCount + 1
					NoFlaskPlayer = NoFlaskPlayer..UnitName(unit).."."
				end
			end
		end
	end

	if FlaskPlayerCount == 0 then
		msg = msg..L.RaidCheckMsgAllNoFlask
	elseif NoFlaskPlayerCount == 0 then
		msg = msg..L.RaidCheckMsgAllHasFlask
	elseif FlaskPlayerCount >= NoFlaskPlayerCount then
		msg = msg..format(L.RaidCheckMsgNoFlask, NoFlaskPlayerCount)..": "..NoFlaskPlayer
	else
		msg = msg..format(L.RaidCheckMsgHasFlask, FlaskPlayerCount)..": "..FlaskPlayer
	end
	SendChatMessage(msg, "RAID")
end

-------------------------------------------------------------------------------------------------------------------
--	创建团队状态检测按钮
-------------------------------------------------------------------------------------------------------------------
function RC:CheckRaidStatus()
	local inInstance, instanceType = IsInInstance()
	if ((GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > 0) and not IsInRaid() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
		return true
	else
		return false
	end
end

function RC:OnEnable()
	local RaidCheckFrameLeft = CreateFrame("Button", "RaidCheckFrameLeft",  ColectorButton)
	RaidCheckFrameLeft:Size(15)
	RaidCheckFrameLeft:Point("TOPRIGHT",  ColectorButton, "TOPRIGHT", -5, -5)
	RaidCheckFrameLeft.text = RaidCheckFrameLeft:CreateFontString(nil, 'OVERLAY')
	RaidCheckFrameLeft.text:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
	RaidCheckFrameLeft.text:Point("CENTER", RaidCheckFrameLeft, "CENTER", 2, 0)
	RaidCheckFrameLeft.text:SetText("R1")
	RaidCheckFrameLeft.text:SetTextColor(23/255, 132/255, 209/255)

	EuiSetTooltip(RaidCheckFrameLeft, L.BottomPanelRaidCheck, L.MouseLeftButton, RaidUtilityPanel and L.RAIDCHECK_RAIDTOOL or L.RaidCheckTipLeftButtonOnLeftInfo, L.MouseRightButton, L.RaidCheckTipRightButtonOnLeftInfo)
	S.Reskin(RaidCheckFrameLeft)
	RaidCheckFrameLeft:SetScript("OnMouseDown", function(self, btn)
		if InCombatLockdown() then return end
		if btn == "LeftButton" then
			if RaidUtilityPanel and RC:CheckRaidStatus() then RaidUtilityPanel:Show() else RC:CheckPosition() end
		elseif btn == "RightButton" then
			DoReadyCheck()
		end
	end)


	local RaidCheckFrameRight = CreateFrame("Button", "RaidCheckFrameRight",  ColectorButton)
	RaidCheckFrameRight:Size(15)
	RaidCheckFrameRight:Point("TOP", RaidCheckFrameLeft, "BOTTOM", 0, -5)
	RaidCheckFrameRight.text = RaidCheckFrameRight:CreateFontString(nil, 'OVERLAY')
	RaidCheckFrameRight.text:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
	RaidCheckFrameRight.text:Point("CENTER", RaidCheckFrameRight, "CENTER", 2, 0)
	RaidCheckFrameRight.text:SetText("R2")
	RaidCheckFrameRight.text:SetTextColor(23/255, 132/255, 209/255)
	EuiSetTooltip(RaidCheckFrameRight, L.BottomPanelRaidCheck, L.MouseLeftButton, L.RaidCheckTipLeftButtonOnRightInfo, L.MouseRightButton, L.RaidCheckTipRightButtonOnRightInfo)
	S.Reskin(RaidCheckFrameRight)
	RaidCheckFrameRight:SetScript("OnMouseDown", function(self, btn)
		if InCombatLockdown() then return end
		if btn == "LeftButton" then
			RC:CheckRaidBuff()
		elseif btn == "RightButton" then
			RC:CheckRaidFlask()
		end
	end)	
end