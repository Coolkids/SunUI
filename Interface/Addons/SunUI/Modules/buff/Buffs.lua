-- Engines
local S, L, DB, _, C = unpack(select(2, ...))
local Buff = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Buff", "AceHook-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local holder = CreateFrame("Frame", "BuffFrameHolder", UIParent)
local debuffholder = CreateFrame("Frame", "DeBuffFrameHolder", UIParent)
local font = "Interface\\Addons\\SunUI\\Media\\font.ttf"
-- making frame to hold all buff frame elements
local function PositionTempEnchant()
	TemporaryEnchantFrame:SetParent(BuffFrameHolder)
	TemporaryEnchantFrame:ClearAllPoints()
	TemporaryEnchantFrame:SetAllPoints(BuffFrameHolder)
end

local function CreateBuffStyle(buff, t)
	if not buff or (buff and buff.styled) then return end
	local bn = buff:GetName()
	local border 	= _G[bn.."Border"]
    local icon 		= _G[bn.."Icon"]
	local duration 	= _G[bn.."Duration"]
	local count 	= _G[bn.."Count"]
	buff:SetSize(C["IconSize"],C["IconSize"])
	icon:SetTexCoord(.08, .92, .08, .92)

	if icon and not buff.shadow then
		local h = CreateFrame("Frame" , nil, buff)
		h:SetAllPoints(buff)
		h:SetFrameLevel(buff:GetFrameLevel()+1)
		duration:SetParent(h)
		duration:ClearAllPoints()
		duration:Point("TOP", h, "BOTTOM", 2, 3)
		duration:SetFont(font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
		count:SetParent(h)
		count:ClearAllPoints()
		count:SetPoint("TOPRIGHT", h, 3, -1)
		count:SetFont(font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
		buff:CreateShadow()
		buff:StyleButton(true)
	end

	if border then 
		if t == "enchant" then border:SetAlpha(0) buff.border:SetBackdropBorderColor(0.7,0,1) end
	end
	buff.styled = true
end

function Buff:OverrideBuffAnchors()
	local buff, previousBuff, aboveBuff;
	local numBuffs = 0;
	for i=1, BUFF_ACTUAL_DISPLAY do
		local buff = _G["BuffButton"..i]
		if not buff.styled then CreateBuffStyle(buff) end
		numBuffs = numBuffs + 1
		index = numBuffs
		buff:SetParent(BuffFrame)
		buff.consolidated = nil
		buff.parent = BuffFrame
		buff:ClearAllPoints()
		if ((index > 1) and (mod(index, C["IconPerRow"]) == 1)) then
			buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -23)
			aboveBuff = buff; 
		elseif ( index == 1 ) then
			local  mh, _, _, oh = GetWeaponEnchantInfo()
			if (mh and oh) and not UnitHasVehicleUI("player") then
				if C["BuffDirection"] == 1 then
					buff:SetPoint("RIGHT", TempEnchant2, "LEFT", -8, 0)
				end
				if C["BuffDirection"] == 2 then
					TempEnchant2:ClearAllPoints()
					TempEnchant2:SetPoint("LEFT", TempEnchant1, "RIGHT", 8, 0)
					buff:SetPoint("LEFT", TempEnchant2, "RIGHT", 8, 0)
				end
				aboveBuff = TempEnchant2
			elseif ((mh and not oh) or (oh and not mh)) and not UnitHasVehicleUI("player") then
				if C["BuffDirection"] == 1 then
					buff:SetPoint("RIGHT", TempEnchant1, "LEFT", -8, 0)
				end
				if C["BuffDirection"] == 2 then
					buff:SetPoint("LEFT", TempEnchant1, "RIGHT", 8, 0)
				end
				aboveBuff = TempEnchant1
			else
				buff:SetPoint("CENTER", BuffFrame, "CENTER", 0, 0)
				aboveBuff = buff
			end
		else
			--buff:SetPoint("RIGHT", previousBuff, "LEFT", -8, 0);
			if C["BuffDirection"] == 1 then
				buff:SetPoint("RIGHT", previousBuff, "LEFT", -8, 0)
			end
			if C["BuffDirection"] == 2 then
				buff:SetPoint("LEFT", previousBuff, "RIGHT", 8, 0)
			end
		end
		previousBuff = buff
	end
end

function Buff:OverrideDebuffAnchors(buttonName, i)
	local color
	local buffName = buttonName..i
	local dtype = select(5, UnitDebuff("player",i))   
	local border = _G[buffName.."Border"]
	local buff = _G[buttonName..i];
	local Pre = _G[buttonName..(i-1)]
	local PreRow = _G[buttonName..(i-C["IconPerRow"])]
	buff:ClearAllPoints()
	if not buff.styled then CreateBuffStyle(buff) end

	if i == 1 then
		buff:SetPoint("CENTER", debuffholder)
	else
		if C["DebuffDirection"] == 1 then
			if i%C["IconPerRow"] == 1 then
				buff:SetPoint("TOP", PreRow, "BOTTOM", 0, -23)
			else
				buff:SetPoint("RIGHT", Pre, "LEFT", -8, 0)
			end
		end
		if C["DebuffDirection"] == 2 then
			if i%C["IconPerRow"] == 1 then
				buff:SetPoint("TOP", PreRow, "BOTTOM", 0, -23)
			else
				buff:SetPoint("LEFT", Pre, "RIGHT", 8, 0)
			end
		end
	end
	if (dtype ~= nil) then
		color = DebuffTypeColor[dtype]
	else
		color = DebuffTypeColor["none"]
	end
	if border then border:SetAlpha(0) buff.border:SetBackdropBorderColor(color.r, color.g, color.b, 1) end
end

local function OverrideTempEnchantAnchors()
	local previousBuff
	for i=1, NUM_TEMP_ENCHANT_FRAMES do
		local te = _G["TempEnchant"..i]
		if te then
			te:SetSize(C["IconSize"],C["IconSize"])
			if (i == 1) then
				te:SetPoint("CENTER", TemporaryEnchantFrame, "CENTER", 0, 0)
			else
				te:SetPoint("RIGHT", previousBuff, "LEFT", -8, 0)
			end
			previousBuff = te
		end
	end
end

local function initialize()
	PositionTempEnchant()
	BuffFrame:SetParent(BuffFrameHolder)
	BuffFrame:ClearAllPoints()
	BuffFrame:SetAllPoints(BuffFrameHolder)
	for i=1, NUM_TEMP_ENCHANT_FRAMES do
		local buff = _G["TempEnchant"..i]
		if not buff.styled then CreateBuffStyle(buff, "enchant") end
	end
	OverrideTempEnchantAnchors()
	if ConsolidatedBuffs then
		ConsolidatedBuffs:UnregisterAllEvents()
		ConsolidatedBuffs:HookScript("OnShow", function(s)
			s:Hide()
			PositionTempEnchant()
		end)
		ConsolidatedBuffs:HookScript("OnHide", function(s)
			PositionTempEnchant()
		end)
		ConsolidatedBuffs:Hide()
	end
end

function Buff:UpdateTime(auraButton, timeLeft)
	local Duration = auraButton.duration
	if timeLeft then
		Duration:SetText(S.FormatTime(timeLeft, true))
		if timeLeft >= 86400 then
			Duration:SetVertexColor(0.4, 0.4, 1)
		elseif (timeLeft < 86400 and timeLeft >= 3600) then
			Duration:SetVertexColor(0.4, 1, 1)
		elseif (timeLeft < 60 and timeLeft >= 15) then
			Duration:SetVertexColor(1, 1, 0)
		elseif timeLeft < 15 then
			Duration:SetVertexColor(1, 0, 0)
		end
	end
end

function Buff:UpdateSet()
	for i=1, BUFF_ACTUAL_DISPLAY do
		local buff = _G["BuffButton"..i]
		buff:SetSize(C["IconSize"],C["IconSize"])
		buff.styled = false
	end
	for i=1, DEBUFF_ACTUAL_DISPLAY do
		local debuff = _G["DebuffButton"..i]
		debuff:SetSize(C["IconSize"],C["IconSize"])
		debuff.styled = false
	end
	holder:SetSize(C["IconSize"],C["IconSize"])
	debuffholder:SetSize(C["IconSize"],C["IconSize"])
end
function Buff:UpdateBuffDirection()
	local previousBuff
	local numBuffs = 0;
	for i=1, BUFF_ACTUAL_DISPLAY do
		local buff = _G["BuffButton"..i]
		numBuffs = numBuffs + 1
		index = numBuffs
		buff:ClearAllPoints()
		if ((index > 1) and (mod(index, C["IconPerRow"]) == 1)) then
			buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -23)
			aboveBuff = buff; 
		elseif ( index == 1 ) then
			local  mh, _, _, oh = GetWeaponEnchantInfo()
			if (mh and oh) and not UnitHasVehicleUI("player") then
				if C["BuffDirection"] == 1 then
					buff:SetPoint("RIGHT", TempEnchant2, "LEFT", -8, 0)
				end
				if C["BuffDirection"] == 2 then
					TempEnchant2:ClearAllPoints()
					TempEnchant2:SetPoint("LEFT", TempEnchant1, "RIGHT", 8, 0)
					buff:SetPoint("LEFT", TempEnchant2, "RIGHT", 8, 0)
				end
				aboveBuff = TempEnchant2
			elseif ((mh and not oh) or (oh and not mh)) and not UnitHasVehicleUI("player") then
				if C["BuffDirection"] == 1 then
					buff:SetPoint("RIGHT", TempEnchant1, "LEFT", -8, 0)
				end
				if C["BuffDirection"] == 2 then
					buff:SetPoint("LEFT", TempEnchant1, "RIGHT", 8, 0)
				end
				aboveBuff = TempEnchant1
			else
				buff:SetPoint("CENTER", BuffFrame, "CENTER", 0, 0)
				aboveBuff = buff
			end
		else
			if C["BuffDirection"] == 1 then
				buff:SetPoint("RIGHT", previousBuff, "LEFT", -8, 0)
			end
			if C["BuffDirection"] == 2 then
				buff:SetPoint("LEFT", previousBuff, "RIGHT", 8, 0)
			end
		end
		previousBuff = buff
	end
end
function Buff:UpdateDebuffDirection()
	for i=1, DEBUFF_ACTUAL_DISPLAY do
		if i == 1 then
			buff:SetPoint("CENTER", debuffholder)
		else
			if C["DebuffDirection"] == 1 then
				if i%C["IconPerRow"] == 1 then
					buff:SetPoint("TOP", PreRow, "BOTTOM", 0, -23)
				else
					buff:SetPoint("RIGHT", Pre, "LEFT", -8, 0)
				end
			end
			if C["DebuffDirection"] == 2 then
				if i%C["IconPerRow"] == 1 then
					buff:SetPoint("TOP", PreRow, "BOTTOM", 0, -23)
				else
					buff:SetPoint("LEFT", Pre, "RIGHT", 8, 0)
				end
			end
		end
	end
end
function Buff:OnInitialize()
	C = SunUIConfig.db.profile.BuffDB
	SetCVar("consolidateBuffs",0)
	SetCVar("buffDurations", 1)
	holder:SetSize(C["IconSize"],C["IconSize"])
	debuffholder:SetSize(C["IconSize"],C["IconSize"])
	MoveHandle.Buff = S.MakeMoveHandle(holder, "Buff", "Buff")
	MoveHandle.Debuff = S.MakeMoveHandle(debuffholder, "Debuff", "Debuff")
	initialize()
	self:SecureHook("BuffFrame_UpdateAllBuffAnchors", "OverrideBuffAnchors")
	self:SecureHook("DebuffButton_UpdateAnchors", "OverrideDebuffAnchors")
	self:SecureHook("AuraButton_UpdateDuration", "UpdateTime")
end