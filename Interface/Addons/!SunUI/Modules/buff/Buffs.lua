-- Engines
local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Buff")

local BuffPos, DebuffPos = nil, nil
local tinsert, _G, tsort = tinsert, _G, table.sort
local BuffTable = {["Time"] = {}, ["None"] = {}}

function Module:Style(buttonName, i, f)
	if not _G[buttonName..i] then return end
	
	local Button	= _G[buttonName..i]
	local Icon		= _G[buttonName..i.."Icon"]
	local Duration	= _G[buttonName..i.."Duration"]
	local Count 	= _G[buttonName..i.."Count"]
	local Border = _G[buttonName..i.."Border"]
	
	Button:SetSize(C["IconSize"], C["IconSize"])
	
	Icon:SetTexCoord(.1, .9, .1, .9)
	
	Duration:ClearAllPoints()
	Duration:SetParent(Button)
	Duration:SetPoint("TOP", Button, "BOTTOM", 2, -3)
	Duration:SetFont("Interface\\Addons\\!SunUI\\media\\ROADWAY.ttf", 12*S.Scale(1)*MiniDB["FontScale"], "THINOUTLINE")
	
	Count:ClearAllPoints()
	Count:SetParent(Button)
	Count:SetPoint("TOPRIGHT", Button, 3, -1)
	Count:SetFont("Interface\\Addons\\!SunUI\\media\\ROADWAY.ttf", 12*S.Scale(1)*MiniDB["FontScale"], "THINOUTLINE")
	
	if Border then
		Border:Hide()
	end
	

	Button:CreateShadow()
	Button:StyleButton(true)
	
	if f == d then
		local dtype = select(5, UnitDebuff("player",i))
			if (dtype ~= nil) then
				color = DebuffTypeColor[dtype]
			else
				color = DebuffTypeColor["none"]
			end
		Button.shadow:SetBackdropColor(0, 0, 0)
		Button.border:SetBackdropBorderColor(color.r, color.g, color.b, 1)
	end
	
	if f == w then
		local id = Button:GetID()
		local itemId
		if id ~= 0 then itemId = GetInventoryItemID("player", id) end
			if itemId then
				local quality = select(3, GetItemInfo(itemId))
				if quality then
					local r, g, b = GetItemQualityColor(quality)
					Button.border:SetBackdropBorderColor(r, g, b, 1)
				end
			end
	Button.shadow:SetBackdropColor(0, 0, 0)	
	end
end

function Module:OnInitialize()
	C = BuffDB
	SetCVar("consolidateBuffs", 0)
	SetCVar("buffDurations", 1)
end

function Module:OnEnable()
	BuffPos = CreateFrame("Frame", nil, UIParent)
	BuffPos:SetSize(C["IconSize"], C["IconSize"])
	MoveHandle.Buff = S.MakeMoveHandle(BuffPos, "Buff", "Buff")
	DebuffPos = CreateFrame("Frame", nil, UIParent)
	DebuffPos:SetSize(C["IconSize"], C["IconSize"])
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
		Module:Style("TempEnchant", i, w)
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
				value:SetPoint("CENTER", BuffPos)
			elseif key%C["IconPerRow"] == 1 then
				value:SetPoint("TOP", PreRow, "BOTTOM", 0, -23)
			else
				value:SetPoint("RIGHT", Pre, "LEFT", -8, 0)
			end
		end
		if C["BuffDirection"] == 2 then
			if key == 1 then
				value:SetPoint("CENTER", BuffPos)
			elseif key%C["IconPerRow"] == 1 then
				value:SetPoint("TOP", PreRow, "BOTTOM", 0, -23)
			else
				value:SetPoint("LEFT", Pre, "RIGHT", 8, 0)
			end
		end
	end
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function()
	wipe(BuffTable["Time"])
	wipe(BuffTable["None"])
	
	Module:GetWeaponEnchantNum()
	
	for i = 1, BUFF_ACTUAL_DISPLAY do
		Module:Style("BuffButton", i, b)
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

--[[ hooksecurefunc("AuraButton_UpdateDuration", function(auraButton, timeLeft)
	local Duration = auraButton.duration
		Duration:SetText(S.FormatTime(timeLeft, true))
end)  ]]

hooksecurefunc("DebuffButton_UpdateAnchors", function(buttonName, i)
	Module:Style(buttonName, i, d)
	local Aura = _G[buttonName..i]
	local Pre = _G[buttonName..(i-1)]
	local PreRow = _G[buttonName..(i-C["IconPerRow"])]
	Aura:ClearAllPoints()
	if C["DebuffDirection"] == 1 then
		if i == 1 then
			Aura:SetPoint("CENTER", DebuffPos)
		elseif i%C["IconPerRow"] == 1 then
			Aura:SetPoint("TOP", PreRow, "BOTTOM", 0, -23)
		else
			Aura:SetPoint("RIGHT", Pre, "LEFT", -8, 0)
		end
	end
	if C["DebuffDirection"] == 2 then
		if i == 1 then
			Aura:SetPoint("CENTER", DebuffPos)
		elseif i%C["IconPerRow"] == 1 then
			Aura:SetPoint("TOP", PreRow, "BOTTOM", 0, -23)
		else
			Aura:SetPoint("LEFT", Pre, "RIGHT", 8, 0)
		end
	end
end)
--时间格式修改
 HOUR_ONELETTER_ABBR = "%dh";
 DAY_ONELETTER_ABBR = "%dd";
 MINUTE_ONELETTER_ABBR = "%dm";
 SECOND_ONELETTER_ABBR = "%ds";
