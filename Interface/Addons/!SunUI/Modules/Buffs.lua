-- Engines
local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Buff")

local BuffPos, DebuffPos = nil, nil
local tinsert, _G, tsort = tinsert, _G, table.sort
local BuffTable = {["Time"] = {}, ["None"] = {}}

function Module:Style(buttonName, i)
	if not _G[buttonName..i] then return end
	
	local Button	= _G[buttonName..i]
	local Icon		= _G[buttonName..i.."Icon"]
	local Duration	= _G[buttonName..i.."Duration"]
	local Count 	= _G[buttonName..i.."Count"]
	local Border = _G[buttonName..i.."Border"]

	Button:Size(C["IconSize"], C["IconSize"])
	
	Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	
	Duration:ClearAllPoints()
	Duration:SetParent(Button)
	Duration:Point("TOP", Button, "BOTTOM", 2, 5)
	Duration:SetFont(DB.bfont, 12*S.Scale(1)*MiniDB["FontScale"], "THINOUTLINE")
	
	Count:ClearAllPoints()
	Count:SetParent(Button)
	Count:Point("TOPRIGHT", Button, 3, -1)
	Count:SetFont(DB.bfont, 12*S.Scale(1)*MiniDB["FontScale"], "THINOUTLINE")
	
	if Border then
		Border:Hide()
	end
	
	if not Button.shadow then
		Button:CreateShadow()
		Button:StyleButton(true)
	end	
end

function Module:OnInitialize()
	C = BuffDB
	SetCVar("consolidateBuffs", 0)
	SetCVar("buffDurations", 1)
end

function Module:OnEnable()
	BuffPos = CreateFrame("Frame", nil, UIParent)
	BuffPos:Size(C["IconSize"], C["IconSize"])
	MoveHandle.Buff = S.MakeMoveHandle(BuffPos, "Buff", "Buff")
	DebuffPos = CreateFrame("Frame", nil, UIParent)
	DebuffPos:Size(C["IconSize"], C["IconSize"])
	MoveHandle.Debuff = S.MakeMoveHandle(DebuffPos, "Debuff", "Debuff")
end

function Module:SortBuff()
	--[[tsort(BuffTable["Time"], function(a, b)
		return a.timeLeft > b.timeLeft
	end)--]]
	for key, value in pairs(BuffTable["Time"]) do
		tinsert(BuffTable["None"], value)
	end
end

function Module:GetWeaponEnchantNum()
	local Num = 0
	hasMainHandEnchant, _, _, hasOffHandEnchant, _, _, hasThrownEnchant = GetWeaponEnchantInfo()
	if hasMainHandEnchant then Num = Num + 1 end
	if hasOffHandEnchant then Num = Num + 1 end
	if hasThrownEnchant then Num = Num + 1 end
	for i = 1, Num do
		Module:Style("TempEnchant", i)
		tinsert(BuffTable["None"], _G["TempEnchant"..i])
	end
end

function Module:UpdateBuffPos()
	for key, value in pairs(BuffTable["None"]) do
		local Pre = BuffTable["None"][key-1]
		local PreRow = BuffTable["None"][key-C["IconPerRow"]]
		value:ClearAllPoints()
		if C["BuffDirection"] == 1 then
			if key == 1 then
				value:Point("CENTER", BuffPos)
			elseif key%C["IconPerRow"] == 1 then
				value:Point("TOP", PreRow, "BOTTOM", 0, -15)
			else
				value:Point("RIGHT", Pre, "LEFT", -8, 0)
			end
		end
		if C["BuffDirection"] == 2 then
			if key == 1 then
				value:Point("CENTER", BuffPos)
			elseif key%C["IconPerRow"] == 1 then
				value:Point("TOP", PreRow, "BOTTOM", 0, -15)
			else
				value:Point("LEFT", Pre, "RIGHT", 8, 0)
			end
		end
	end
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function()
	wipe(BuffTable["Time"])
	wipe(BuffTable["None"])
	
	Module:GetWeaponEnchantNum()
	
	for i = 1, BUFF_ACTUAL_DISPLAY do
		Module:Style("BuffButton", i)
		if select(6, UnitBuff("player", i)) == 0 then
			tinsert(BuffTable["None"], _G["BuffButton"..i])
		else
			tinsert(BuffTable["Time"], _G["BuffButton"..i])
		end
	end
	
	Module:SortBuff()
	Module:UpdateBuffPos()
end)

hooksecurefunc("AuraButton_OnUpdate", function(self, elapsed)
	if self.timeLeft < BUFF_DURATION_WARNING_TIME then
		self:SetAlpha(BuffFrame.BuffAlphaValue)
	else
		self:SetAlpha(1)
	end
end)

hooksecurefunc("AuraButton_UpdateDuration", function(auraButton, timeLeft)
	local Duration = auraButton.duration
		Duration:SetText(S.FormatTime(timeLeft, true))
end) 

hooksecurefunc("DebuffButton_UpdateAnchors", function(buttonName, i)
	Module:Style(buttonName, i)
	local Aura = _G[buttonName..i]
	local Pre = _G[buttonName..(i-1)]
	local PreRow = _G[buttonName..(i-C["IconPerRow"])]
	Aura:ClearAllPoints()
	if C["DebuffDirection"] == 1 then
		if i == 1 then
			Aura:Point("CENTER", DebuffPos)
		elseif i%C["IconPerRow"] == 1 then
			Aura:Point("TOP", PreRow, "BOTTOM", 0, -15)
		else
			Aura:Point("RIGHT", Pre, "LEFT", -8, 0)
		end
	end
	if C["DebuffDirection"] == 2 then
		if i == 1 then
			Aura:Point("CENTER", DebuffPos)
		elseif i%C["IconPerRow"] == 1 then
			Aura:Point("TOP", PreRow, "BOTTOM", 0, -15)
		else
			Aura:Point("LEFT", Pre, "RIGHT", 8, 0)
		end
	end
end)