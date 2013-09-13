local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("AutoHide", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local autohide = CreateFrame("Frame", "BarFade", UIParent)

local function pending()
	if UnitAffectingCombat("player") then return true end
	if UnitExists("target") then return true end
	if UnitInVehicle("player") then return true end
	if SpellBookFrame:IsShown() then return true end
	if IsAddOnLoaded("Blizzard_MacroUI") and MacroFrame:IsShown() then return true end
end

local function FadeOutActionButton() 
	if BarFade:GetAlpha()>0 then
		local fadeInfo = {};
		fadeInfo.mode = "OUT";
		fadeInfo.timeToFade = 0.5;
		fadeInfo.finishedFunc = function()BarFade:Hide()  end
		fadeInfo.startAlpha = BarFade:GetAlpha()
		fadeInfo.endAlpha = 0
		UIFrameFade(BarFade, fadeInfo)
	end 
end

local function FadeInActionButton()
	if BarFade:GetAlpha()<1 then
		BarFade:Show()
		UIFrameFadeIn(BarFade, 0.5,BarFade:GetAlpha(), 1)
	end
end

local function On_ADDON_LOADED(self, event, addon)
	if addon == "Blizzard_MacroUI" then
		self:UnregisterEvent("ADDON_LOADED")
		MacroFrame:HookScript("OnShow", function(self, event)
			FadeInActionButton()
		end)
		MacroFrame:HookScript("OnHide", function(self, event)
			if not pending() then
				FadeOutActionButton()
			end
		end)
	end
end

function Module:UpdateAutoHide()
	if C["AllFade"] then 
		if SunUIStanceBar then SunUIStanceBar:SetParent(BarFade) end
		if SunUIPetBar then SunUIPetBar:SetParent(BarFade) end
		if SunUIActionBar1  then SunUIActionBar1:SetParent(BarFade) end
		if SunUIActionBar2  then SunUIActionBar2:SetParent(BarFade) end
		if SunUIActionBar3 then SunUIActionBar3:SetParent(BarFade) end
		if SunUIActionBar3_2 then SunUIActionBar3_2:SetParent(BarFade) end
		if SunUIActionBar4  then SunUIActionBar4:SetParent(BarFade) end
		if SunUIActionBar5  then SunUIActionBar5:SetParent(BarFade) end
		if SunUIMultiBarLeft1 then SunUIMultiBarLeft1:SetParent(BarFade) end
		if SunUIMultiBarLeft2 then SunUIMultiBarLeft2:SetParent(BarFade) end
		if SunUIMultiBarLeft3 then SunUIMultiBarLeft3:SetParent(BarFade) end
		if SunUIMultiBarLeft4 then SunUIMultiBarLeft4:SetParent(BarFade) end
	else
		if SunUIStanceBar and C["StanceBarFade"] then SunUIStanceBar:SetParent(BarFade) end
		if SunUIPetBar and C["PetBarFade"] then SunUIPetBar:SetParent(BarFade) end
		if SunUIActionBar1 and C["Bar1Fade"] then SunUIActionBar1:SetParent(BarFade) end
		if SunUIActionBar2 and C["Bar2Fade"] then SunUIActionBar2:SetParent(BarFade) end
		if SunUIActionBar3 and C["Bar3Fade"] then SunUIActionBar3:SetParent(BarFade) end
		if SunUIActionBar3_2 and C["Bar3Fade"] then SunUIActionBar3_2:SetParent(BarFade) end
		if SunUIActionBar4 and C["Bar4Fade"] then SunUIActionBar4:SetParent(BarFade) end
		if SunUIActionBar5 and C["Bar5Fade"] then SunUIActionBar5:SetParent(BarFade) end
		if SunUIMultiBarLeft1 and C["Bar5Fade"] then SunUIMultiBarLeft1:SetParent(BarFade) end
		if SunUIMultiBarLeft2 and C["Bar5Fade"] then SunUIMultiBarLeft2:SetParent(BarFade) end
		if SunUIMultiBarLeft3 and C["Bar5Fade"] then SunUIMultiBarLeft3:SetParent(BarFade) end
		if SunUIMultiBarLeft4 and C["Bar5Fade"] then SunUIMultiBarLeft4:SetParent(BarFade) end
	end

	autohide:RegisterEvent("PLAYER_REGEN_ENABLED")
	autohide:RegisterEvent("PLAYER_REGEN_DISABLED")
	autohide:RegisterEvent("PLAYER_TARGET_CHANGED")
	autohide:RegisterEvent("PLAYER_ENTERING_WORLD")
	autohide:RegisterEvent("UNIT_ENTERED_VEHICLE")
	autohide:RegisterEvent("UNIT_EXITED_VEHICLE")

	autohide:SetScript("OnEvent", function(self, event, arg1, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
		if pending() then
			FadeInActionButton()
		else
			FadeOutActionButton()
		end
	end) 

	SpellBookFrame:HookScript("OnShow", function(self, event)
		FadeInActionButton()
	end)

	SpellBookFrame:HookScript("OnHide", function(self, event)
		if not pending() then
			FadeOutActionButton()
		end
	end)
end
	
function Module:OnEnable()
	C = SunUIConfig.db.profile.ActionBarDB
	Module:UpdateAutoHide()
	Module:RegisterEvent("ADDON_LOADED", On_ADDON_LOADED)
end 