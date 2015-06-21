local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local RT = S:GetModule("RLTools")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-----------------from EUI           -------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
local join = string.join
local find = string.find
local format = string.format
local sort = table.sort
local floor = math.floor
local insert = table.insert
local MaxGroup = 5

local L = {}
RT.L = L
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
	L.BottomPanelRaidCheck = "SunUI团队检查工具"
	L.GameSetting = "打开SunUI设置界面"
	
	L.BuffType1 = '属性';
	L.BuffType2 = '耐力';
	L.BuffType3 = '攻击强度';
	L.BuffType4 = '急速';
	L.BuffType5 = '法术强度';
	L.BuffType6 = '爆击';
	L.BuffType7 = '精通';
	L.BuffType8 = '溅射';
	L.BuffType9 = '全能';

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
	L.BottomPanelRaidCheck = "SunUI團隊檢查工具"
	L.GameSetting = "打開SunUI設置界面"
	
	L.BuffType1 = '屬性';
	L.BuffType2 = '耐力';
	L.BuffType3 = '攻擊強度';
	L.BuffType4 = '急速';
	L.BuffType5 = '法術強度';
	L.BuffType6 = '爆擊';
	L.BuffType7 = '精通';
	L.BuffType8 = '濺射';
	L.BuffType9 = '全能';
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
	
	L.BuffType1 = 'Property';
	L.BuffType2 = 'Endurance ';
	L.BuffType3 = 'Attack power';
	L.BuffType4 = 'haste';
	L.BuffType5 = 'Spell power';
	L.BuffType6 = 'Crit';
	L.BuffType7 = 'Master';
	L.BuffType8 = 'Multistrike';
	L.BuffType9 = 'Versatility';
end

local function GN(id)
	local name, test = GetSpellInfo(id)
	
	return name
end
--[[
L.RaidCheckBuff1 = {GN(1126),GN(117666),GN(20217)} --属性(德鲁依：野性印记,武僧：帝王传承,圣骑士：王者祝福)
L.RaidCheckBuff2 = {GN(21562),GN(109773),GN(469)} --耐力(牧师：真言术：韧,术士：黑暗意图,战士：命令怒吼)
L.RaidCheckBuff3 = {GN(19506),GN(6673),GN(57330)} --攻强(强击光环,战斗怒吼,寒冬号角)
L.RaidCheckBuff4 = {GN(113742),GN(30809),GN(55610)} --攻速(盗贼：迅刃之黠(被动),增强萨满：怒火释放(被动),DK-邪恶光环)
L.RaidCheckBuff5 = {GN(1459),GN(61316),GN(77747),GN(109773)} --法强(法师：奥术光辉,达拉然光辉,萨满：燃烧之怒(被动),术士：黑暗意图)
L.RaidCheckBuff6 = {GN(49868),GN(24907),GN(51470)} --法术急速(暗影牧师：暗影形态(被动),平衡德鲁依：枭兽形态(被动),元素萨满：元素之誓(被动))
L.RaidCheckBuff7 = {GN(1459),GN(61316),GN(24932),GN(116781)} --爆击(法师：奥术光辉,达拉然光辉,德鲁依：熊形态和猫形态的兽群领袖(被动),风行武僧：白虎传承)
L.RaidCheckBuff8 = {GN(116956),GN(19740)} --精通(萨满：风之优雅(被动),圣骑士：力量祝福)
L.RaidCheckBuff9 = GN(87564) --食物
]]
--wod 6.0 by EUI丶唐猫儒
L.RaidCheckBuff1 = {GN(1126),GN(115921),GN(116781),GN(20217)} --属性(德鲁依：野性印记,织雾武僧:帝王传承,踏风/酒仙武僧:白虎传承,圣骑士：王者祝福)
L.RaidCheckBuff2 = {GN(21562),GN(166928),GN(469)} --耐力(牧师：真言术：韧,术士：深红契印(被动),战士：命令怒吼)
L.RaidCheckBuff3 = {GN(19506),GN(6673),GN(57330)} --攻强(猎人：强击光环(被动),战士：战斗怒吼,DK：寒冬号角)
L.RaidCheckBuff4 = {GN(49868),GN(113742),GN(116956),GN(55610)} --急速(暗影牧师：思维加速(被动),盗贼：迅刃之黠(被动),萨满：风之优雅(被动),冰霜/邪恶DK：邪恶光环(被动))
L.RaidCheckBuff5 = {GN(1459),GN(61316),GN(109773)} --法强(法师：奥术光辉,达拉然光辉,萨满：术士：黑暗意图)
L.RaidCheckBuff6 = {GN(1459),GN(61316),GN(24932),GN(116781)} --爆击(法师：奥术光辉,达拉然光辉,野性德鲁依：兽群领袖(被动),踏风/酒仙武僧：白虎传承)
L.RaidCheckBuff7 = {GN(116956),GN(19740),GN(24907),GN(155522)} --精通(萨满：风之优雅(被动),圣骑士：力量祝福，平衡德鲁依：枭兽形态(被动),血DK：幽冥之力(被动))
L.RaidCheckBuff8 = {GN(166916),GN(49868),GN(113742),GN(109773)} --溅射(武僧：狂风骤雨（被动）,暗影牧师：思维加速(被动),盗贼：迅刃之黠(被动),术士：黑暗意图)
L.RaidCheckBuff9 = {GN(55610),GN(1126),GN(167187),GN(167188)} --全能(冰霜/邪恶DK：邪恶光环,德鲁依：野性印记,圣骑士：圣洁光环(被动),狂暴/武器战士：英姿勃发(被动))
L.RaidCheckBuff10 = GN(87564) --食物
-------------------------------------------------------------------------------------------------------------------
--	团队Buff检查
-------------------------------------------------------------------------------------------------------------------
function RT:CheckRaidBuff()
	local NoBuff1, NoBuff2, NoBuff3, NoBuff4, NoBuff5, NoBuff6, NoBuff7, NoBuff8, NoBuff9, NoBuff10 = {},{},{},{},{},{},{},{},{},{}

	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	local raidNum = GetNumGroupMembers()
	if inInstance and instanceType == "raid" then raidNum = maxPlayers end
	if raidNum == 0 then return end
	for i = 1, raidNum do
		local name, _, subgroup = GetRaidRosterInfo(i)
		
		if subgroup <= math.floor(raidNum / 5) then
			local unit = "raid"..i
			local j = 1
			local haveBuff1, haveBuff2, haveBuff3, haveBuff4, haveBuff5, haveBuff6, haveBuff7, haveBuff8, haveBuff9, haveBuff10
			while UnitBuff(unit, j) do
				local BuffTEXT = UnitBuff(unit, j)
				for k = 1, #L.RaidCheckBuff1 do
					if find(BuffTEXT, L.RaidCheckBuff1[k]) then haveBuff1 = true; break; end
				end
				for k = 1, #L.RaidCheckBuff2 do
					if find(BuffTEXT, L.RaidCheckBuff2[k]) then haveBuff2 = true; break; end
				end
				for k = 1, #L.RaidCheckBuff3 do
					if find(BuffTEXT, L.RaidCheckBuff3[k]) then haveBuff3 = true; break; end
				end
				for k = 1, #L.RaidCheckBuff4 do
					if find(BuffTEXT, L.RaidCheckBuff4[k]) then haveBuff4 = true; break; end
				end
				for k = 1, #L.RaidCheckBuff5 do
					if find(BuffTEXT, L.RaidCheckBuff5[k]) then haveBuff5 = true; break; end
				end
				for k = 1, #L.RaidCheckBuff6 do
					if find(BuffTEXT, L.RaidCheckBuff6[k]) then haveBuff6 = true; break; end
				end
				for k = 1, #L.RaidCheckBuff7 do
					if find(BuffTEXT, L.RaidCheckBuff7[k]) then haveBuff7 = true; break; end
				end
				for k = 1, #L.RaidCheckBuff8 do
					if find(BuffTEXT, L.RaidCheckBuff8[k]) then haveBuff8 = true; break; end
				end
				for k = 1, #L.RaidCheckBuff9 do
					if find(BuffTEXT, L.RaidCheckBuff9[k]) then haveBuff9 = true; break; end
				end				
				if find(BuffTEXT, L.RaidCheckBuff10) then haveBuff10 = true; end			
				
				j = j + 1
			end
			if not haveBuff1 then insert(NoBuff1, name); end
			if not haveBuff2 then insert(NoBuff2, name); end
			if not haveBuff3 then insert(NoBuff3, name); end
			if not haveBuff4 then insert(NoBuff4, name); end
			if not haveBuff5 then insert(NoBuff5, name); end
			if not haveBuff6 then insert(NoBuff6, name); end
			if not haveBuff7 then insert(NoBuff7, name); end
			if not haveBuff8 then insert(NoBuff8, name); end
			if not haveBuff9 then insert(NoBuff9, name); end
			if not haveBuff10 then insert(NoBuff10, name); end
		end
	end
	
	if #NoBuff1 == 0 and #NoBuff2 == 0 and #NoBuff3 == 0 and #NoBuff4 == 0 and #NoBuff5 == 0 and #NoBuff6 == 0 and #NoBuff7 == 0 and #NoBuff8 == 0 and #NoBuff9 == 0 and #NoBuff10 == 0 then
		SendChatMessage(L.RaidCheckMsgFullBuff, S:CheckChat())
	else
		SendChatMessage(L.RaidCheckMsgNoBuff, S:CheckChat())
		if #NoBuff1 == raidNum then NoBuff1 = {'*'..ALL..'*'} end
		if #NoBuff2 == raidNum then NoBuff2 = {'*'..ALL..'*'} end
		if #NoBuff3 == raidNum then NoBuff3 = {'*'..ALL..'*'} end
		if #NoBuff4 == raidNum then NoBuff4 = {'*'..ALL..'*'} end
		if #NoBuff5 == raidNum then NoBuff5 = {'*'..ALL..'*'} end
		if #NoBuff6 == raidNum then NoBuff6 = {'*'..ALL..'*'} end
		if #NoBuff7 == raidNum then NoBuff7 = {'*'..ALL..'*'} end
		if #NoBuff8 == raidNum then NoBuff8 = {'*'..ALL..'*'} end
		if #NoBuff9 == raidNum then NoBuff9 = {'*'..ALL..'*'} end
		if #NoBuff10 == raidNum then NoBuff10 = {'*'..ALL..'*'} end
		
		if #NoBuff1 > 0 then SendChatMessage(L.BuffType1.. ': '.. table.concat(NoBuff1, ","), S:CheckChat()) end
		if #NoBuff2 > 0 then SendChatMessage(L.BuffType2.. ': '.. table.concat(NoBuff2, ","), S:CheckChat()) end
		if #NoBuff3 > 0 then SendChatMessage(L.BuffType3.. ': '.. table.concat(NoBuff3, ","), S:CheckChat()) end
		if #NoBuff4 > 0 then SendChatMessage(L.BuffType4.. ': '.. table.concat(NoBuff4, ","), S:CheckChat()) end
		if #NoBuff5 > 0 then SendChatMessage(L.BuffType5.. ': '.. table.concat(NoBuff5, ","), S:CheckChat()) end
		if #NoBuff6 > 0 then SendChatMessage(L.BuffType6.. ': '.. table.concat(NoBuff6, ","), S:CheckChat()) end
		if #NoBuff7 > 0 then SendChatMessage(L.BuffType7.. ': '.. table.concat(NoBuff7, ","), S:CheckChat()) end
		if #NoBuff8 > 0 then SendChatMessage(L.BuffType8.. ': '.. table.concat(NoBuff8, ","), S:CheckChat()) end		
		if #NoBuff9 > 0 then SendChatMessage(L.BuffType9.. ': '.. table.concat(NoBuff9, ","), S:CheckChat()) end		
		if #NoBuff10 > 0 then SendChatMessage(L.RaidCheckBuff10.. ': '.. table.concat(NoBuff10, ","), S:CheckChat()) end
	end
	
	wipe(NoBuff1);
	wipe(NoBuff2);
	wipe(NoBuff3);
	wipe(NoBuff4);
	wipe(NoBuff5);
	wipe(NoBuff6);
	wipe(NoBuff7);
	wipe(NoBuff8);
	wipe(NoBuff9);
	wipe(NoBuff10);
	NoBuff1, NoBuff2, NoBuff3, NoBuff4, NoBuff5, NoBuff6, NoBuff7, NoBuff8, NoBuff9, NoBuff10 = nil
end

-------------------------------------------------------------------------------------------------------------------
--	团队成员到位检查
-------------------------------------------------------------------------------------------------------------------
function RT:CheckPosition()

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
	if raidNum == 0 then return end
	for i = 1, RaidNum do
		_, _, subgroup = GetRaidRosterInfo(i)
		if subgroup <= math.floor(RaidNum/5) then
			local unit = "raid"..i
			if UnitIsConnected(unit) then
				if not UnitIsDeadOrGhost(unit) then
					if not UnitIsVisible(unit) then
						UnVisiblePlayerCount = UnVisiblePlayerCount + 1
						if UnVisiblePlayerCount > 0 and UnVisiblePlayerCount < 20 then
							UnVisiblePlayer = UnVisiblePlayer..(UnitName(unit) or UNKNOWN).."."
						end
						if UnVisiblePlayerCount == 20 then
							UnVisiblePlayer = UnVisiblePlayer.." "..L.RaidCheckMsgETC
						end
					end
				else
					DeadPlayerCount = DeadPlayerCount + 1
					if DeadPlayerCount > 0 and DeadPlayerCount < 10 then
						DeadPlayer = DeadPlayer..(UnitName(unit) or UNKNOWN).."."
					end
					if DeadPlayerCount == 10 then
						DeadPlayer = DeadPlayer.." "..L.RaidCheckMsgETC
					end
				end
			else
				OfflinePlayerCount = OfflinePlayerCount + 1
				if OfflinePlayerCount > 0 and OfflinePlayerCount < 10 then
					OfflinePlayer = OfflinePlayer..(UnitName(unit) or UNKNOWN).."."
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
	
	SendChatMessage(msg, S:CheckChat())
end

-------------------------------------------------------------------------------------------------------------------
--	团队成员合剂检查
-------------------------------------------------------------------------------------------------------------------
function RT:CheckRaidFlask()

	local FlaskText = RAL_TEXT_CHECK_12
	local FlaskDATA = L.RaidCheckFlaskData
	local FlaskPlayer, NoFlaskPlayer = "", ""
	local FlaskPlayerCount, NoFlaskPlayerCount = 0, 0
	local msg = "["..L.RaidCheckMsgFlask.."]"
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	local raidNum = GetNumGroupMembers()
	if inInstance and instanceType == "raid" then raidNum = maxPlayers end
	if raidNum == 0 then return end
	for i = 1,raidNum do
		local _, _, subgroup = GetRaidRosterInfo(i)
		if subgroup <= math.floor(raidNum/5) then
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
	SendChatMessage(msg, S:CheckChat())
end

-------------------------------------------------------------------------------------------------------------------
--	创建团队状态检测按钮
-------------------------------------------------------------------------------------------------------------------
function RT:CheckRaidStatus()
	local inInstance, instanceType = IsInInstance()
	if ((GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > 0) and not IsInRaid() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
		return true
	else
		return false
	end
end
--[[
function RT:Initialize()
	if not EuiInfoBar then return end
	
	EuiInfoBar.RaidTool.raidtool1.text:SetText(RaidUtilityPanel and L.RAIDCHECK_RAIDTOOL or L.RaidCheckTipLeftButtonOnLeftInfo)
	EuiInfoBar.RaidTool.raidtool1:HookScript("OnClick", function()
		if RaidUtilityPanel and RC:CheckRaidStatus() then RaidUtilityPanel:Show() else RC:CheckPosition() end
	end)
	EuiInfoBar.RaidTool.raidtool2.text:SetText(L.RaidCheckTipRightButtonOnLeftInfo)
	EuiInfoBar.RaidTool.raidtool2:HookScript("OnClick", function()
		DoReadyCheck()
	end)
	
	EuiInfoBar.RaidTool.raidtool3.text:SetText(L.RaidCheckTipLeftButtonOnRightInfo)
	EuiInfoBar.RaidTool.raidtool3:HookScript("OnClick", function()
		RC:CheckRaidBuff()
	end)
	EuiInfoBar.RaidTool.raidtool4.text:SetText(L.RaidCheckTipRightButtonOnRightInfo)
	EuiInfoBar.RaidTool.raidtool4:HookScript("OnClick", function()
		RC:CheckRaidFlask()
	end)	
end
]]
