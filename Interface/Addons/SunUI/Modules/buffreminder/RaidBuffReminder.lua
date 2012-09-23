-- Engines
local S, C, L, DB, _ = unpack(select(2, ...))
local Module =LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("RaidBuffReminder", "AceEvent-3.0")
local _G = _G
local BuffFrame, IsInParty = {}, false
local Melee = false
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
		115921,	--MK
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
		-- 10%法伤
		1459, -- 奥术光辉
		109773, --意图
		77747,--萨满
	},
	[6] = {
			-- 10%AP
			6673, -- 战斗怒吼
			19506, -- 强击光环
			57330,--DK
		},
	[7] = {
		--法术加速
		49868,--暗牧
		24907,--鸟德
		51470,--萨满
	},
	[8] = {
		--物理加速
		113742, --DZ
		55610,--邪恶光环 DK
		30809,--怒火释放 SM
	},
	[9] = {
		-- 精通
		19740, -- 力量祝福
		128997, --灵魂兽
		116956, --風之優雅
	},	
}

local function OnEvent_GROUP_ROSTER_UPDATE(event, ...)
	IsInParty = (GetNumSubgroupMembers() > 0 or GetNumGroupMembers() > 0) and true or false
end
local function OnEvent_ACTIVE_TALENT_GROUP_CHANGED(event, ...)
	local _, Class = UnitClass("player")
	local Talent = GetSpecialization()
	if	(Class == "DRUID" and Talent == 2 or Talent == 3) or Class == "HUNTER" or Class == "ROGUE" or
		(Class == "SHAMAN" and Talent == 2) or Class == "DEATHKNIGHT" or Class == "WARRIOR" or
		(Class == "PALADIN" and (Talent == 2 or Talent == 3)) then
		Melee = true
	else
		Melee = false
	end
end
local function OnEvent_UNIT_AURA(event, unit, ...)
	if C["ReminderDB"].ShowOnlyInParty and not IsInParty then 
		for key, value in pairs(BuffFrame) do value:SetAlpha(0) end
		return
	end
	if unit ~= "player" then return end
	for i = 1, 4 do
		if RaidBuffList[i] and RaidBuffList[i][1] then
			BuffFrame[i]:SetAlpha(1)
			BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[i][1])))
			BuffFrame[i].Overlay:SetAlpha(0.7)
			for key, value in pairs(RaidBuffList[i]) do
				local name = GetSpellInfo(value)
				if name == nil then return end
				if UnitAura("player", name) then
					BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[i]:SetAlpha(1)
					BuffFrame[i].Overlay:SetAlpha(0)
					break
				end
			end
		end
	end
	if Melee then   --法伤/AP
		if RaidBuffList[6] and RaidBuffList[6][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[6][1])))
			BuffFrame[5].Overlay:SetAlpha(0.7)
			for key, value in pairs(RaidBuffList[6]) do
				local name = GetSpellInfo(value)
				if name == nil then return end
				if UnitAura("player", name) then
					BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[5]:SetAlpha(1)
					BuffFrame[5].Overlay:SetAlpha(0)
					break
				end
			end
		end
	else
		if RaidBuffList[5] and RaidBuffList[5][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[5][1])))
			BuffFrame[5].Overlay:SetAlpha(0.7)
			for key, value in pairs(RaidBuffList[5]) do
				local name = GetSpellInfo(value)
				if name == nil then return end
				if UnitAura("player", name) then
					BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[5]:SetAlpha(1)
					BuffFrame[5].Overlay:SetAlpha(0)
					break
				end
			end
		end
	end
	if Melee then --法术/物理加速
		if RaidBuffList[8] and RaidBuffList[8][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[8][1])))
			BuffFrame[6].Overlay:SetAlpha(0.7)
			for key, value in pairs(RaidBuffList[8]) do
				local name = GetSpellInfo(value)
				if name == nil then return end
				if UnitAura("player", name) then
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(1)
					BuffFrame[6].Overlay:SetAlpha(0)
					break
				end
			end
		end
	else
		if RaidBuffList[7] and RaidBuffList[7][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[7][1])))
			BuffFrame[6].Overlay:SetAlpha(0.7)
			for key, value in pairs(RaidBuffList[7]) do
				local name = GetSpellInfo(value)
				if name == nil then return end
				if UnitAura("player", name) then
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(1)
					BuffFrame[6].Overlay:SetAlpha(0)
					break
				end
			end
		end
	end
end
local function OnEvent_PLAYER_ENTERING_WORLD(event, ...)
	if C["ReminderDB"].ShowOnlyInParty and not IsInParty then 
		for key, value in pairs(BuffFrame) do value:SetAlpha(0) end
		return
	end
	if unit ~= "player" then return end
	for i = 1, 4 do
		if RaidBuffList[i] and RaidBuffList[i][1] then
			BuffFrame[i]:SetAlpha(1)
			BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[i][1])))
			BuffFrame[i].Overlay:SetAlpha(0.7)
			for key, value in pairs(RaidBuffList[i]) do
				local name = GetSpellInfo(value)
				if name == nil then return end
				if UnitAura("player", name) then
					BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[i]:SetAlpha(1)
					BuffFrame[i].Overlay:SetAlpha(0)
					break
				end
			end
		end
	end
	if Melee then   --法伤/AP
		if RaidBuffList[6] and RaidBuffList[6][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[6][1])))
			BuffFrame[5].Overlay:SetAlpha(0.7)
			for key, value in pairs(RaidBuffList[6]) do
				local name = GetSpellInfo(value)
				if name == nil then return end
				if UnitAura("player", name) then
					BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[5]:SetAlpha(1)
					BuffFrame[5].Overlay:SetAlpha(0)
					break
				end
			end
		end
	else
		if RaidBuffList[5] and RaidBuffList[5][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[5][1])))
			BuffFrame[5].Overlay:SetAlpha(0.7)
			for key, value in pairs(RaidBuffList[5]) do
				local name = GetSpellInfo(value)
				if name == nil then return end
				if UnitAura("player", name) then
					BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[5]:SetAlpha(1)
					BuffFrame[5].Overlay:SetAlpha(0)
					break
				end
			end
		end
	end
	if Melee then --法术/物理加速
		if RaidBuffList[8] and RaidBuffList[8][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[8][1])))
			BuffFrame[6].Overlay:SetAlpha(0.7)
			for key, value in pairs(RaidBuffList[8]) do
				local name = GetSpellInfo(value)
				if name == nil then return end
				if UnitAura("player", name) then
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(1)
					BuffFrame[6].Overlay:SetAlpha(0)
					break
				end
			end
		end
	else
		if RaidBuffList[7] and RaidBuffList[7][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[7][1])))
			BuffFrame[6].Overlay:SetAlpha(0.7)
			for key, value in pairs(RaidBuffList[7]) do
				local name = GetSpellInfo(value)
				if name == nil then return end
				if UnitAura("player", name) then
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(1)
					BuffFrame[6].Overlay:SetAlpha(0)
					break
				end
			end
		end
	end
end
local function BuildBuffFrame()
	for i = 1, 6 do
		local Temp = CreateFrame("Frame", nil, Minimap)
		--Temp:SetSize(C["ReminderDB"].RaidBuffSize, C["ReminderDB"].RaidBuffSize)
		Temp:SetSize((Minimap:GetWidth()-(6-1)*2)/6, (Minimap:GetWidth()-(6-1)*2)/6)
		Temp:SetFrameStrata("LOW")
		Temp:CreateBorder()
		Temp.Icon = Temp:CreateTexture(nil, "ARTWORK")
		Temp.Icon:SetTexCoord(.1, .9, .1, .9)
		Temp.Icon:SetPoint("TOPLEFT", Temp, "TOPLEFT", 1, -1)
		Temp.Icon:SetPoint("BOTTOMRIGHT", Temp, "BOTTOMRIGHT", -1, 1)
		--Temp.Icon:SetAllPoints()
		
		if C["ReminderDB"].RaidBuffDirection == 1 then
			if i == 1 then
				MoveHandle.Reminder = S.MakeMoveHandle(Temp, L["药水"], "Reminder")
			else
				Temp:SetPoint("LEFT", BuffFrame[i-1], "RIGHT", 2, 0)
			end
		elseif C["ReminderDB"].RaidBuffDirection == 2 then
			if i == 1 then
				MoveHandle.Reminder = S.MakeMoveHandle(Temp, L["药水"], "Reminder")
			else
				Temp:SetPoint("TOP", BuffFrame[i-1], "BOTTOM", 0, -2)
			end
		end
		
		Temp.Overlay = Temp:CreateTexture(nil, "OVERLAY")
		Temp.Overlay:SetAllPoints()
		Temp.Overlay:SetTexture(0, 0, 0)
		Temp:SetAlpha(0)	
		tinsert(BuffFrame,Temp)
	end
end

function Module:OnEnable()
	if not C["ReminderDB"].ShowRaidBuff then return end
	OnEvent_GROUP_ROSTER_UPDATE()
	OnEvent_ACTIVE_TALENT_GROUP_CHANGED()
	BuildBuffFrame()
	Module:RegisterEvent("PLAYER_ENTERING_WORLD", OnEvent_PLAYER_ENTERING_WORLD)
	Module:RegisterEvent("UNIT_AURA", OnEvent_UNIT_AURA)
	Module:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", OnEvent_ACTIVE_TALENT_GROUP_CHANGED)
	Module:RegisterEvent("GROUP_ROSTER_UPDATE", OnEvent_GROUP_ROSTER_UPDATE)
	--debug
	-- for i = 1, 7 do
		-- for key, value in pairs(RaidBuffList[i]) do
			-- local name = GetSpellInfo(value)
			-- if name == nil then print("无效ID"..value) return end
		-- end
	-- end
end