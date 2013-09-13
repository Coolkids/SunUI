local S, L, DB, _, C = unpack(select(2, ...))
local FBF = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Compatibility", "AceEvent-3.0", "AceHook-3.0")
local AddonNotSupported = {}
local BlackList = {"bigfoot", "duowan", "163ui", "大脚", "大腳", "魔盒"}
local oldList = {"fixstaticpopup", "sfishing", "shaofangercd", "fishingace", "niotiller", "fishingbuddy","kui_nameplates"}

function FBF:TableIsEmpty(t)
	--print(type(t))
	if type(t) ~= "table" then
		return true
	else
		return next(t) == nil
	end
end

function FBF:CheckAddon()
	for i = 1, GetNumAddOns() do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
		--print(name)
		if enabled then
			for _, word in pairs(BlackList) do
				if (name and name:lower():find(word)) or (title and title:lower():find(word)) then
					AddonNotSupported[i] = {isload = true, msg = L["不兼容"]}
				end
			end
			for _, word in pairs(oldList) do
				if (name and name:lower():find(word)) or (title and title:lower():find(word)) then
					--print(title, name)
					AddonNotSupported[i] = {isload = true, msg = L["已包含的"]}
				end
			end
		end
	end
	if self:TableIsEmpty(AddonNotSupported) then
		return
	else
		self:CreateCompatibilityCheckFrame()
	end
end

function FBF:CreateCompatibilityCheckFrame()
	local frame = CreateFrame("Frame", "SunUICompatibilityCheckFrame", UIParent)
	frame:Size(400, 400)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:EnableMouse(true)
	frame:SetFrameStrata("DIALOG")
	S.SetBD(frame)
	
	local titile = S.MakeFontString(frame)
	titile:Point("TOPLEFT", 0, -10)
	titile:Point("TOPRIGHT", 0, -10)
	titile:SetFontObject(GameFontNormal)
	titile:SetText(L["兼容性检查"])
	
	local scrollArea = CreateFrame("ScrollFrame", "SunUICompatibilityCheckFrameScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:Point("TOPLEFT", frame, "TOPLEFT", 8, -40)
	scrollArea:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 80)

	S.ReskinScroll(SunUICompatibilityCheckFrameScrollScrollBar)

	local messageFrame = CreateFrame("EditBox", nil, frame)
	messageFrame:SetFont(DB.Font, DB.FontSize, "OUTLINE")
	messageFrame:EnableMouse(false)
	messageFrame:EnableKeyboard(false) 
	messageFrame:SetMultiLine(true)
	messageFrame:SetMaxLetters(99999)
	messageFrame:Size(400, 400)

	scrollArea:SetScrollChild(messageFrame)

	for i,k in pairs(AddonNotSupported) do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
		messageFrame:SetText(messageFrame:GetText().."\n"..name..k.msg)
	end

	local button1 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	button1:Size(150, 30)
	button1:Point("BOTTOMLEFT", 10, 10)
	S.Reskin(button1)
	button1:SetText(L["禁用他们"])
	button1:SetScript("OnClick", function()
		for i = 1, GetNumAddOns() do
			if AddonNotSupported[i] then
				DisableAddOn(i)
			end
		end
		ReloadUI()
	end)

	local button2 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	button2:Size(150, 30)
	button2:Point("BOTTOMRIGHT", -10, 10)
	S.Reskin(button2)
	button2:SetText(L["不要禁用"])
	button2:SetScript("OnClick", function()
		for i = 1, GetNumAddOns() do
			if GetAddOnInfo(i) == "SunUI" then
				DisableAddOn(i)
			end
		end
		ReloadUI()
	end)
	
	local msg = S.MakeFontString(frame)
	msg:Point("BOTTOMLEFT", 0, 50)
	msg:Point("BOTTOMRIGHT", 0, 50)
	--msg:SetFontObject(GameFontNormal)
	msg:SetText(L["兼容性检查信息"])
end

function FBF:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if UnitAffectingCombat("player") then return end
	self:CheckAddon()
end

function FBF:OnInitialize()
	FBF:RegisterEvent("PLAYER_ENTERING_WORLD")
end