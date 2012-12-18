-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Buff = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Buff", "AceHook-3.0")
local holder = CreateFrame("Frame", "BuffFrameHolder", UIParent)
local debuffholder = CreateFrame("Frame", "DeBuffFrameHolder", UIParent)
local _
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
	if icon and not buff.shadow then
		local h = CreateFrame("Frame" , nil, buff)
		h:SetAllPoints(buff)
		h:SetFrameLevel(buff:GetFrameLevel()+1)
		icon:SetTexCoord(.08, .92, .08, .92)
		buff:SetSize(C["BuffDB"]["IconSize"],C["BuffDB"]["IconSize"])
		duration:SetParent(h)
		duration:ClearAllPoints()
		duration:Point("TOP", h, "BOTTOM", 2, 3)
		duration:SetFont(font, C["BuffDB"]["FontSize"]*S.Scale(1), "THINOUTLINE")
		
		count:SetParent(h)
		count:ClearAllPoints()
		count:SetPoint("TOPRIGHT", h, 3, -1)
		count:SetFont(font, C["BuffDB"]["FontSize"]*S.Scale(1), "THINOUTLINE")
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
		if ((index > 1) and (mod(index, C["BuffDB"]["IconPerRow"]) == 1)) then
			buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -23)
			aboveBuff = buff; 
		elseif ( index == 1 ) then
			local  mh, _, _, oh = GetWeaponEnchantInfo()
			if (mh and oh) and not UnitHasVehicleUI("player") then
				if C["BuffDB"]["BuffDirection"] == 1 then
					buff:SetPoint("RIGHT", TempEnchant2, "LEFT", -8, 0)
				end
				if C["BuffDB"]["BuffDirection"] == 2 then
					TempEnchant2:ClearAllPoints()
					TempEnchant2:SetPoint("LEFT", TempEnchant1, "RIGHT", 8, 0)
					buff:SetPoint("LEFT", TempEnchant2, "RIGHT", 8, 0)
				end
				aboveBuff = TempEnchant2
			elseif ((mh and not oh) or (oh and not mh)) and not UnitHasVehicleUI("player") then
				if C["BuffDB"]["BuffDirection"] == 1 then
					buff:SetPoint("RIGHT", TempEnchant1, "LEFT", -8, 0)
				end
				if C["BuffDB"]["BuffDirection"] == 2 then
					buff:SetPoint("LEFT", TempEnchant1, "RIGHT", 8, 0)
				end
				aboveBuff = TempEnchant1
			else
				buff:SetPoint("CENTER", BuffFrame, "CENTER", 0, 0)
				aboveBuff = buff
			end
		else
			--buff:SetPoint("RIGHT", previousBuff, "LEFT", -8, 0);
			if C["BuffDB"]["BuffDirection"] == 1 then
				buff:SetPoint("RIGHT", previousBuff, "LEFT", -8, 0)
			end
			if C["BuffDB"]["BuffDirection"] == 2 then
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
	local PreRow = _G[buttonName..(i-C["BuffDB"]["IconPerRow"])]
	buff:ClearAllPoints()
	if not buff.styled then CreateBuffStyle(buff) end
	
	if i == 1 then
		buff:SetPoint("CENTER", debuffholder)
	else
		buff:SetPoint("RIGHT", _G[buttonName..(i-1)], "LEFT", -8, 0)
		if C["BuffDB"]["DebuffDirection"] == 1 then
			if i%C["BuffDB"]["IconPerRow"] == 1 then
				buff:SetPoint("TOP", PreRow, "BOTTOM", 0, -23)
			else
				buff:SetPoint("RIGHT", Pre, "LEFT", -8, 0)
			end
		end
		if C["BuffDB"]["DebuffDirection"] == 2 then
			if i%C["BuffDB"]["IconPerRow"] == 1 then
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
			te:SetSize(C["BuffDB"]["IconSize"],C["BuffDB"]["IconSize"])
			if (i == 1) then
				te:SetPoint("CENTER", TemporaryEnchantFrame, "CENTER", 0, 0)
			else
				te:SetPoint("RIGHT", previousBuff, "LEFT", -8, 0)
			end
			previousBuff = te
		end
	end
end
	
local initialize = function()
	--position buff & temp enchant frames
	PositionTempEnchant()
	BuffFrame:SetParent(BuffFrameHolder)
	BuffFrame:ClearAllPoints()
	BuffFrame:SetAllPoints(BuffFrameHolder)
	--stylize temp enchant frames
	for i=1, NUM_TEMP_ENCHANT_FRAMES do
		local buff = _G["TempEnchant"..i]
		if not buff.styled then CreateBuffStyle(buff, "enchant") end
	end
	OverrideTempEnchantAnchors()
	--getting rid of consolidate buff frame
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

function Buff:OnInitialize()
	SetCVar("consolidateBuffs",0)
	SetCVar("buffDurations", 1)
	holder:SetSize(C["BuffDB"]["IconSize"],C["BuffDB"]["IconSize"])
	debuffholder:SetSize(C["BuffDB"]["IconSize"],C["BuffDB"]["IconSize"])
	MoveHandle.Buff = S.MakeMoveHandle(holder, "Buff", "Buff")
	MoveHandle.Debuff = S.MakeMoveHandle(debuffholder, "Debuff", "Debuff")
	initialize()
	self:SecureHook("BuffFrame_UpdateAllBuffAnchors", "OverrideBuffAnchors")
	self:SecureHook("DebuffButton_UpdateAnchors", "OverrideDebuffAnchors")
	self:SecureHook("AuraButton_UpdateDuration", "UpdateTime")
end
