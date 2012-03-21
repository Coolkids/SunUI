local S, C, L, DB = unpack(select(2, ...))

if DB.MyClass ~= "PRIEST" then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("ShadowPet")
function Module:OnInitialize()
	local petbar = CreateFrame("Frame", nil, UIParent)
	petbar:SetWidth(110) 
	petbar:SetHeight(10) 
	MoveHandle.ShadowPet = S.MakeMoveHandle(petbar, L["暗影魔计时条"], "ShadowPet")
	petbar:SetFrameStrata("MEDIUM")
	petbar:SetFrameLevel(2)
	petbar:CreateShadow("Background")

	local psbar = CreateFrame("StatusBar", nil, petbar)
	psbar:SetSize(petbar:GetWidth(), petbar:GetHeight())
	psbar:SetStatusBarTexture(DB.Statusbar)
	psbar:GetStatusBarTexture():SetHorizTile(false)
	psbar:SetAllPoints(petbar)
	psbar:SetMinMaxValues(0, 15000)
	psbar:SetValue(0)
	
	petbar.text = S.MakeFontString(psbar, 11)
	petbar.text:SetText("")
	petbar.text:SetPoint("LEFT", psbar, 5, 8)
	petbar.time = S.MakeFontString(psbar, 12)
	petbar.time:SetText("")
	petbar.time:SetPoint("RIGHT", psbar, -5, 8)
	
	local spar =  psbar:CreateTexture(nil, "OVERLAY")
	spar:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
	spar:SetBlendMode("ADD")
	spar:SetAlpha(.8)
	spar:SetPoint("TOPLEFT", psbar:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
	spar:SetPoint("BOTTOMRIGHT", psbar:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)
	
	local icon = CreateFrame("Frame", nil, petbar)
	icon:Size(20)
	icon:Point("BOTTOMRIGHT", petbar, "BOTTOMLEFT", -7, 0)
	a = icon:CreateTexture(nil, "ARTWORK") 
	a:SetTexture(select(3, GetSpellInfo(34433))) 
	a:SetAllPoints(icon)
	a:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon:CreateShadow()
	petbar:Hide()
	
	local function UpdatePet(self,elapsed)
		if GetPetTimeRemaining() and GetPetTimeRemaining() < 15000 then
			psbar:SetValue(GetPetTimeRemaining())
			petbar.text:SetText("暗影魔")
			petbar.time:SetText(floor(GetPetTimeRemaining()/1000))
			psbar:SetStatusBarColor(S.ColorGradient(GetPetTimeRemaining()/15000,1, 0, 0, 1, 1, 0, 0.8, 0.87, 0.9))
			if GetPetTimeRemaining() < 5000 then petbar.time:SetTextColor(1, 0, 0) end
		else
			petbar.text:SetText("")
			petbar.time:SetText("")
			psbar:Hide()
		end
	end
	
	local pethelper = CreateFrame("Frame", nil, UIParent)
	pethelper:SetScript("OnUpdate", function()
		if UnitExists("pet") then
			petbar:Show()
		else
			petbar:Hide()
		end
	end)

	petbar:SetScript("OnUpdate",UpdatePet)
end