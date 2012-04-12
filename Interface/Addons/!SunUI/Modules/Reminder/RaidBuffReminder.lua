-- Engines
local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("RaidBuffReminder", "AceEvent-3.0")
local BuffFrame, IsInParty = {}, false
local RaidBuffList = {
	[1] = {
		-- 合剂
    	94160, -- 流水合剂
    	79469, -- 钢皮合剂
    	79470, -- 神龙心智合剂
    	79471, -- 风行合剂
    	79472, -- 泰坦之力合剂
    	79638, -- 增强力量
    	79639, -- 增强敏捷
    	79640, -- 增强智力	
		-- 卷轴
		89343, -- 敏捷卷轴
		63308, -- 护甲卷轴
		89347, -- 智力卷轴
		89342, -- 精神卷轴
		89346, -- 力量卷轴  
		-- 战斗药剂
		79481, -- 命中(无限精准药剂)
		79632, -- 急速(狂速药剂)
		79477, -- 暴击(眼镜蛇药剂)
		79635, -- 精通(大师药剂)
		79474, -- 精准(纳迦药剂)
		79468, -- 精神(幽魂药剂)
		-- 守护药剂
		79480, -- 900 护甲
		79631, -- 90 全抗性	
	},
	[2] = {		
		-- 食物
		87545, -- 90 力量
		87546, -- 90 敏捷
		87547, -- 90 智力
		87548, -- 90 精神
		87549, -- 90 精通
		87550, -- 90 命中
		87551, -- 90 暴击
		87552, -- 90 急速
		87554, -- 90 躲闪
		87555, -- 90 招架
		87635, -- 90 精准		
	},
	[3] = {
		-- 全属性
		20217, -- 王者祝福
		 1126, -- 野性印记
		90363, -- 页岩蛛之拥	
	},
	[4] = {
		-- 耐力
		21562, -- 真言术：韧
		  469, -- 命令怒吼
		 6307, -- 血契
		90364, -- 其拉虫群坚韧
		72590, -- 坚韧	
	},
	[5] = {
		-- 智力
		79058, -- 奥术智慧
		61316, -- 达拉然光辉
		 1459, -- 奥术光辉
	},
	[6] = {
		-- AP
		19740, -- 力量祝福
		30808, -- 怒火释放
		53138, -- 憎恶之力
		19506, -- 强击光环
	},
	[7] = {
		-- 回蓝
		 5675, -- 法力之泉图腾
		19740, -- 力量祝福
	},	
}

local function OnEvent_PARTY_MEMBERS_CHANGED(event, ...)
	IsInParty = (GetNumPartyMembers() > 0) and true or false
end
local function OnEvent_ACTIVE_TALENT_GROUP_CHANGED(event, ...)
	local Melee = false
	local _, Class = UnitClass("player")
	local Talent = GetPrimaryTalentTree()
	if	(Class == "DRUID" and Talent == 2) or Class == "HUNTER" or Class == "ROGUE" or
		(Class == "SHAMAN" and Talent == 2) or Class == "DEATHKNIGHT" or Class == "WARRIOR" or
		(Class == "PALADIN" and (Talent == 2 or Talent == 3)) then
		Flag = true
	else
		Flag = false
	end
end
local function OnEvent_UNIT_AURA(event, unit, ...)
	if ReminderDB.ShowOnlyInParty and not IsInParty then 
		for key, value in pairs(BuffFrame) do value:SetAlpha(0) end
		return
	end
	if unit ~= "player" then return end
	for i = 1, 5 do
		if RaidBuffList[i] and RaidBuffList[i][1] then
			BuffFrame[i]:SetAlpha(1)
			BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[i][1])))
			BuffFrame[i].Overlay:SetAlpha(0.7)
			BuffFrame[i].Flag:SetAlpha(0)
			for key, value in pairs(RaidBuffList[i]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[i]:SetAlpha(1)
					BuffFrame[i].Overlay:SetAlpha(0)
					BuffFrame[i].Flag:SetAlpha(1)
					break
				end
			end
		end
	end
	if Flag then
		if RaidBuffList[6] and RaidBuffList[6][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[6][1])))
			BuffFrame[6].Overlay:SetAlpha(0.7)
			BuffFrame[6].Flag:SetAlpha(0)
			for key, value in pairs(RaidBuffList[6]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(1)
					BuffFrame[6].Overlay:SetAlpha(0)
					BuffFrame[6].Flag:SetAlpha(1)
					break
				end
			end
		end
	else
		if RaidBuffList[7] and RaidBuffList[7][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[7][1])))
			BuffFrame[6].Overlay:SetAlpha(0.7)
			BuffFrame[6].Flag:SetAlpha(0)
			for key, value in pairs(RaidBuffList[7]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(1)
					BuffFrame[6].Overlay:SetAlpha(0)
					BuffFrame[6].Flag:SetAlpha(1)
					break
				end
			end
		end
	end
end
local function OnEvent_PLAYER_ENTERING_WORLD(event, ...)
	if ReminderDB.ShowOnlyInParty and not IsInParty then 
		for key, value in pairs(BuffFrame) do value:SetAlpha(0) end
		return
	end
	for i = 1, 5 do
		if RaidBuffList[i] and RaidBuffList[i][1] then
			BuffFrame[i]:SetAlpha(1)
			BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[i][1])))
			BuffFrame[i].Overlay:SetAlpha(0.7)
			BuffFrame[i].Flag:SetAlpha(0)
			for key, value in pairs(RaidBuffList[i]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[i]:SetAlpha(1)
					BuffFrame[i].Overlay:SetAlpha(0)
					BuffFrame[i].Flag:SetAlpha(1)
					break
				end
			end
		end
	end
	if Flag then
		if RaidBuffList[6] and RaidBuffList[6][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[6][1])))
			BuffFrame[6].Overlay:SetAlpha(0.7)
			BuffFrame[6].Flag:SetAlpha(0)
			for key, value in pairs(RaidBuffList[6]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(1)
					BuffFrame[6].Overlay:SetAlpha(0)
					BuffFrame[6].Flag:SetAlpha(1)
					break
				end
			end
		end
	else
		if RaidBuffList[7] and RaidBuffList[7][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[7][1])))
			BuffFrame[6].Overlay:SetAlpha(0.7)
			BuffFrame[6].Flag:SetAlpha(0)
			for key, value in pairs(RaidBuffList[7]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(1)
					BuffFrame[6].Overlay:SetAlpha(0)
					BuffFrame[6].Flag:SetAlpha(1)
					break
				end
			end
		end
	end
end
local function BuildBuffFrame()
	for i = 1, 6 do
		local Temp = CreateFrame("Frame", nil, UIParent)
		Temp:SetSize(ReminderDB.RaidBuffSize, ReminderDB.RaidBuffSize)
		Temp:SetFrameStrata("LOW")
		Temp.Shadow = CreateFrame("Frame", nil, Temp)
		Temp.Shadow:SetPoint("TOPLEFT", Temp, "TOPLEFT", -2, 2)
		Temp.Shadow:SetPoint("BOTTOMRIGHT", Temp, "BOTTOMRIGHT", 2, -2)
		Temp.Shadow:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = 2})
		Temp.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
		Temp.Shadow:SetFrameLevel(0)
		
		Temp.Icon = Temp:CreateTexture(nil, "ARTWORK")
		Temp.Icon:SetTexCoord(.1, .9, .1, .9)
		Temp.Icon:SetAllPoints()
		
		if ReminderDB.RaidBuffDirection == 1 then
			if i == 1 then
				MoveHandle.Reminder = S.MakeMoveHandle(Temp, L["药水"], "Reminder")
			else
				Temp:SetPoint("LEFT", BuffFrame[i-1], "RIGHT", 4, 0)
			end
		elseif ReminderDB.RaidBuffDirection == 2 then
			if i == 1 then
				MoveHandle.Reminder = S.MakeMoveHandle(Temp, L["药水"], "Reminder")
			else
				Temp:SetPoint("TOP", BuffFrame[i-1], "BOTTOM", 0, -4)
			end
		end
		
		Temp.Overlay = Temp:CreateTexture(nil, "OVERLAY")
		Temp.Overlay:SetAllPoints()
		Temp.Overlay:SetTexture(0, 0, 0)
		
		Temp.Flag = Temp:CreateTexture(nil, "OVERLAY")
		if ReminderDB.RaidBuffDirection == 1 then
			Temp.Flag:SetHeight(2)
			Temp.Flag:SetPoint("TOPLEFT", Temp, "BOTTOMLEFT", 0, -4)
			Temp.Flag:SetPoint("TOPRIGHT", Temp, "BOTTOMRIGHT", 0, -4)
		elseif ReminderDB.RaidBuffDirection == 2 then
			Temp.Flag:SetWidth(2)
			Temp.Flag:SetPoint("TOPRIGHT", Temp, "TOPLEFT", -4, 0)
			Temp.Flag:SetPoint("BOTTOMRIGHT", Temp, "BOTTOMLEFT", -4, 0)	
		end
		Temp.Flag:SetTexture(0.1, 1, 0.1, 0.8)
		Temp.Flag.Border = CreateFrame("Frame", nil, Temp)
		Temp.Flag.Border:SetPoint("TOPLEFT", Temp.Flag, "TOPLEFT", -1, 1)
		Temp.Flag.Border:SetPoint("BOTTOMRIGHT", Temp.Flag, "BOTTOMRIGHT", 1, -1)
		Temp.Flag.Border:SetBackdrop({edgeFile = DB.Solid, edgeSize = S.mult})
		Temp.Flag.Border:SetBackdropBorderColor(0, 0, 0, 1)

		Temp:SetAlpha(0)	
		tinsert(BuffFrame,Temp)
	end
end

function Module:OnEnable()
	if not ReminderDB.ShowRaidBuff then return end
	BuildBuffFrame()
	Module:RegisterEvent("PLAYER_ENTERING_WORLD", OnEvent_PLAYER_ENTERING_WORLD)
	Module:RegisterEvent("UNIT_AURA", OnEvent_UNIT_AURA)
	Module:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", OnEvent_ACTIVE_TALENT_GROUP_CHANGED)
	Module:RegisterEvent("PARTY_MEMBERS_CHANGED", OnEvent_PARTY_MEMBERS_CHANGED)
end
