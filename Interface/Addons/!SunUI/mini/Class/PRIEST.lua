local S, C, L, DB = unpack(select(2, ...))

if DB.ShadowPetOpen ~= true then return end
if DB.MyClass ~= "PRIEST" then return end

local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("ShadowPet")
function Module:OnInitialize()
	local petbar = CreateFrame("Frame", nil, UIParent)
	petbar:SetWidth(110) 
	petbar:SetHeight(10) 
	petbar:SetPoint("BOTTOM", ShadowPet, "BOTTOM", 0, 0)
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
	
	petbar.text = S.MakeFontString(psbar, 12)
	petbar.text:SetText("")
	petbar.text:SetPoint("CENTER", psbar)
	
	local spar =  psbar:CreateTexture(nil, "OVERLAY")
	spar:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
	spar:SetBlendMode("ADD")
	spar:SetAlpha(.8)
	spar:SetPoint("TOPLEFT", psbar:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
	spar:SetPoint("BOTTOMRIGHT", psbar:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)
	
	petbar:Hide()
	
	local function UpdatePet(self,elapsed)
		if GetPetTimeRemaining() and GetPetTimeRemaining() < 15000 then
			psbar:SetValue(GetPetTimeRemaining())
			petbar.text:SetText(floor(GetPetTimeRemaining()/1000))
			psbar:SetStatusBarColor(S.ColorGradient(GetPetTimeRemaining()/15000,1, 0, 0, 1, 1, 0, 0.8, 0.87, 0.9))
		else
			petbar.text:SetText("")
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