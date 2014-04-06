local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local BR = S:GetModule("BufferReminder")
local BuffFrame, IsInParty = {}, false
local Melee = false


local function OnEvent_GROUP_ROSTER_UPDATE(event, ...)
	IsInParty = (GetNumSubgroupMembers() > 0 or GetNumGroupMembers() > 0) and true or false
end
local function OnEvent_ACTIVE_TALENT_GROUP_CHANGED(event, ...)
	if	(S.Role == "Melee") or (S.Role == "Tank")then
		Melee = true
	else
		Melee = false
	end
end
local function OnEvent_UNIT_AURA(event, unit, ...)
	if BR.db.ShowOnlyInParty and not IsInParty then 
		for key, value in pairs(BuffFrame) do value:SetAlpha(0) end
		return
	end
	if unit ~= "player" then return end
	for i = 1, 4 do
		if BR.RaidBuffList[i] and BR.RaidBuffList[i][1] then
			BuffFrame[i]:SetAlpha(1)
			BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(BR.RaidBuffList[i][1])))
			for key, value in pairs(BR.RaidBuffList[i]) do
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
		if BR.RaidBuffList[6] and BR.RaidBuffList[6][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(BR.RaidBuffList[6][1])))
			for key, value in pairs(BR.RaidBuffList[6]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[5]:SetAlpha(0.2)
					break
				end
			end
		end
	else
		if BR.RaidBuffList[5] and BR.RaidBuffList[5][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(BR.RaidBuffList[5][1])))
			for key, value in pairs(BR.RaidBuffList[5]) do
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
		if BR.RaidBuffList[8] and BR.RaidBuffList[8][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(BR.RaidBuffList[8][1])))
			for key, value in pairs(BR.RaidBuffList[8]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(0.2)
					break
				end
			end
		end
	else
		if BR.RaidBuffList[7] and BR.RaidBuffList[7][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(BR.RaidBuffList[7][1])))
			for key, value in pairs(BR.RaidBuffList[7]) do
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
	if BR.db.ShowOnlyInParty and not IsInParty then 
		for key, value in pairs(BuffFrame) do value:SetAlpha(0) end
		return
	end
	if unit ~= "player" then return end
	for i = 1, 4 do
		if BR.RaidBuffList[i] and BR.RaidBuffList[i][1] then
			BuffFrame[i]:SetAlpha(1)
			BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(BR.RaidBuffList[i][1])))
			for key, value in pairs(BR.RaidBuffList[i]) do
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
		if BR.RaidBuffList[6] and BR.RaidBuffList[6][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(BR.RaidBuffList[6][1])))
			for key, value in pairs(BR.RaidBuffList[6]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[5]:SetAlpha(0.2)
					break
				end
			end
		end
	else
		if BR.RaidBuffList[5] and BR.RaidBuffList[5][1] then
			BuffFrame[5]:SetAlpha(1)
			BuffFrame[5].Icon:SetTexture(select(3, GetSpellInfo(BR.RaidBuffList[5][1])))
			for key, value in pairs(BR.RaidBuffList[5]) do
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
		if BR.RaidBuffList[8] and BR.RaidBuffList[8][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(BR.RaidBuffList[8][1])))
			for key, value in pairs(BR.RaidBuffList[8]) do
				local name = GetSpellInfo(value)
				if name and UnitAura("player", name) then 
					BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(0.2)
					break
				end
			end
		end
	else
		if BR.RaidBuffList[7] and BR.RaidBuffList[7][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Icon:SetTexture(select(3, GetSpellInfo(BR.RaidBuffList[7][1])))
			for key, value in pairs(BR.RaidBuffList[7]) do
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
	local MoveHander = CreateFrame("Frame", nil, UIParent)
	MoveHander:SetSize(120, (120-(6-1)*2)/6)
	MoveHander:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -5)
	for i = 1, 6 do
		local Temp = CreateFrame("Frame", nil, UIParent)
		Temp:SetSize((120-(6-1)*2)/6, (120-(6-1)*2)/6)
		Temp:SetFrameStrata("LOW")
		Temp:CreateBorder()
		Temp.Icon = Temp:CreateTexture(nil, "ARTWORK")
		Temp.Icon:SetTexCoord(.1, .9, .1, .9)
		Temp.Icon:SetPoint("TOPLEFT", Temp, "TOPLEFT", 1, -1)
		Temp.Icon:SetPoint("BOTTOMRIGHT", Temp, "BOTTOMRIGHT", -1, 1)
		
		if BR.db.RaidBuffDirection == 1 then
			if i == 1 then
				Temp:SetPoint("LEFT", MoveHander)
			else
				Temp:SetPoint("LEFT", BuffFrame[i-1], "RIGHT", 2, 0)
			end
		elseif BR.db.RaidBuffDirection == 2 then
			if i == 1 then
				Temp:SetPoint("LEFT", MoveHander)
			else
				Temp:SetPoint("TOP", BuffFrame[i-1], "BOTTOM", 0, -2)
			end
			MoveHander:SetSize((120-(6-1)*2)/6, 120)
		end
		Temp:SetAlpha(0)	
		tinsert(BuffFrame,Temp)
	end
	
	S:CreateMover(MoveHander, "RaidBuffMover", L["缺失Buff"], true, nil, "ALL,GENERAL")
end

function BR:initRaidBuffReminder()
	if not BR.db.ShowRaidBuff then return end
	OnEvent_GROUP_ROSTER_UPDATE()
	OnEvent_ACTIVE_TALENT_GROUP_CHANGED()
	BuildBuffFrame()
	OnEvent_UNIT_AURA(nil, "player")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", OnEvent_PLAYER_ENTERING_WORLD)
	self:RegisterEvent("UNIT_AURA", OnEvent_UNIT_AURA)
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", OnEvent_ACTIVE_TALENT_GROUP_CHANGED)
	self:RegisterEvent("GROUP_ROSTER_UPDATE", OnEvent_GROUP_ROSTER_UPDATE)
	--debug
	-- for i = 1, 7 do
		-- for key, value in pairs(BR.RaidBuffList[i]) do
			-- local name = GetSpellInfo(value)
			-- if name == nil then print("无效ID"..value) return end
		-- end
	-- end
end