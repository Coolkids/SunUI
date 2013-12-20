-- Engines
local S, L, DB, _, C = unpack(select(2, ...))
local Module =LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("RaidBuffReminder", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local _G = _G
local BuffFrame, IsInParty = {}, false
local Melee = false
local RaidBuffList = {
	[1] = {
		-- 全属性
		20217, -- 王者祝福
		 1126, -- 野性印记
		90363, -- 页岩蛛之拥
		115921,	--MK
	},
	[2] = {		
		-- 耐力
		21562, -- 真言术：韧
		  469, -- 命令怒吼
		109773,		--意图
		90364, -- 其拉虫群坚韧
		72590, -- 坚韧
	},
	[3] = {
		-- 精通
		19740, -- 力量祝福
		128997, --灵魂兽
		93435, --猎人宝宝 猫科
		116956, --風之優雅
	},
	[4] = {
		--5%暴击
		17007,
		1459,
		116781,
		61316,--法师
		24604, --LR宝宝
		126309, --疑似鸟德
		116781, --武僧5%暴击
	},
	[5] = {
		-- 10%法伤
		1459, -- 奥术光辉
		109773, --意图
		77747,--萨满
		61316,--法师
		126309, --疑似鸟德
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
		135678,--猎人宝宝
	},
	[8] = {
		--物理加速
		113742, --DZ
		55610,--邪恶光环 DK
		30809,--怒火释放 SM
	},
}

local function OnEvent_GROUP_ROSTER_UPDATE(event, ...)
	IsInParty = (GetNumSubgroupMembers() > 0 or GetNumGroupMembers() > 0) and true or false
end
local function OnEvent_ACTIVE_TALENT_GROUP_CHANGED(event, ...)
	if	(DB.Role == "Melee") or (DB.Role == "Tank")then
		Melee = true
	else
		Melee = false
	end
end
local function OnEvent_UNIT_AURA(event, unit, ...)
	if C.ShowOnlyInParty and not IsInParty then 
		for key, value in pairs(BuffFrame) do value:SetAlpha(0) end
		return
	end
	if unit ~= "player" then return end
	for i = 1, 4 do
		if RaidBuffList[i] and RaidBuffList[i][1] then
			BuffFrame[i]:SetAlpha(1)
			BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[i][1])))
			for key, value in pairs(RaidBuffList[i]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[i]:SetAlpha(0.2)
					break
				end
			end
		end
	end
	if Melee then   --法伤/AP
		if RaidBuffList[6] and RaidBuffList[6][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[6][1])))
			for key, value in pairs(RaidBuffList[6]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[5]:SetAlpha(0.2)
					break
				end
			end
		end
	else
		if RaidBuffList[5] and RaidBuffList[5][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[5][1])))
			for key, value in pairs(RaidBuffList[5]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[5]:SetAlpha(0.2)
					break
				end
			end
		end
	end
	if Melee then --法术/物理加速
		if RaidBuffList[8] and RaidBuffList[8][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[8][1])))
			for key, value in pairs(RaidBuffList[8]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(0.2)
					break
				end
			end
		end
	else
		if RaidBuffList[7] and RaidBuffList[7][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[7][1])))
			for key, value in pairs(RaidBuffList[7]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(0.2)
					break
				end
			end
		end
	end
end
local function OnEvent_PLAYER_ENTERING_WORLD(event, ...)
	if C.ShowOnlyInParty and not IsInParty then 
		for key, value in pairs(BuffFrame) do value:SetAlpha(0) end
		return
	end
	if unit ~= "player" then return end
	for i = 1, 4 do
		if RaidBuffList[i] and RaidBuffList[i][1] then
			BuffFrame[i]:SetAlpha(1)
			BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[i][1])))
			for key, value in pairs(RaidBuffList[i]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[i]:SetAlpha(0.2)
					break
				end
			end
		end
	end
	if Melee then   --法伤/AP
		if RaidBuffList[6] and RaidBuffList[6][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[6][1])))
			for key, value in pairs(RaidBuffList[6]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[5]:SetAlpha(0.2)
					break
				end
			end
		end
	else
		if RaidBuffList[5] and RaidBuffList[5][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[5][1])))
			for key, value in pairs(RaidBuffList[5]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[5]:SetAlpha(0.2)
					break
				end
			end
		end
	end
	if Melee then --法术/物理加速
		if RaidBuffList[8] and RaidBuffList[8][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[8][1])))
			for key, value in pairs(RaidBuffList[8]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(0.2)
					break
				end
			end
		end
	else
		if RaidBuffList[7] and RaidBuffList[7][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(RaidBuffList[7][1])))
			for key, value in pairs(RaidBuffList[7]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(0.2)
					break
				end
			end
		end
	end
end
local function BuildBuffFrame()
	for i = 1, 6 do
		local Temp = CreateFrame("Frame", nil, Minimap)
		--Temp:SetSize(C.RaidBuffSize, C.RaidBuffSize)
		Temp:SetSize((120-(6-1)*2)/6, (120-(6-1)*2)/6)
		Temp:SetFrameStrata("LOW")
		Temp:CreateBorder()
		Temp.Icon = Temp:CreateTexture(nil, "ARTWORK")
		Temp.Icon:SetTexCoord(.1, .9, .1, .9)
		Temp.Icon:SetPoint("TOPLEFT", Temp, "TOPLEFT", 1, -1)
		Temp.Icon:SetPoint("BOTTOMRIGHT", Temp, "BOTTOMRIGHT", -1, 1)
		
		if C.RaidBuffDirection == 1 then
			if i == 1 then
				MoveHandle.Reminder = S.MakeMoveHandle(Temp, L["药水"], "Reminder")
			else
				Temp:SetPoint("LEFT", BuffFrame[i-1], "RIGHT", 2, 0)
			end
		elseif C.RaidBuffDirection == 2 then
			if i == 1 then
				MoveHandle.Reminder = S.MakeMoveHandle(Temp, L["药水"], "Reminder")
			else
				Temp:SetPoint("TOP", BuffFrame[i-1], "BOTTOM", 0, -2)
			end
		end
		Temp:SetAlpha(0)	
		tinsert(BuffFrame,Temp)
	end
end

function Module:OnEnable()
	C = SunUIConfig.db.profile.ReminderDB
	if not C.ShowRaidBuff then return end
	OnEvent_GROUP_ROSTER_UPDATE()
	OnEvent_ACTIVE_TALENT_GROUP_CHANGED()
	BuildBuffFrame()
	OnEvent_UNIT_AURA(nil, "player")
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