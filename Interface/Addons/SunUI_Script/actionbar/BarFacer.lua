local S, C, L, DB = unpack(SunUI)
 
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("AutoHide", "AceEvent-3.0")

function Module:UpdateAutoHide()
	local autohide = CreateFrame("Frame")
	local rabs = {}

	if SunUIStanceBar and ActionBarDB["EnableBarFader"] then table.insert(rabs, "SunUIStanceBar") end
	if SunUIPetBar and ActionBarDB["EnableBarFader"] then table.insert(rabs, "SunUIPetBar") end
	if SunUIActionBar1 and ActionBarDB["EnableBarFader"] then table.insert(rabs, "SunUIActionBar1") end
	if SunUIActionBar2 and ActionBarDB["EnableBarFader"] then table.insert(rabs, "SunUIActionBar2") end
	if SunUIActionBar3 and ActionBarDB["EnableBarFader"] then table.insert(rabs, "SunUIActionBar3") end
	if SunUIActionBar4 and ActionBarDB["EnableBarFader"] then table.insert(rabs, "SunUIActionBar4") end
	if SunUIActionBar5 and ActionBarDB["EnableBarFader"] then table.insert(rabs, "SunUIActionBar5") end
	if SunUIMultiBarLeft1 and ActionBarDB["EnableBarFader"] then table.insert(rabs, "SunUIMultiBarLeft1") end
	if SunUIMultiBarLeft2 and ActionBarDB["EnableBarFader"] then table.insert(rabs, "SunUIMultiBarLeft2") end
	if SunUIMultiBarLeft3 and ActionBarDB["EnableBarFader"] then table.insert(rabs, "SunUIMultiBarLeft3") end
	if SunUIMultiBarLeft4 and ActionBarDB["EnableBarFader"] then table.insert(rabs, "SunUIMultiBarLeft4") end

	if #rabs == 0 then return end

	autohide:RegisterEvent("PLAYER_REGEN_ENABLED")
	autohide:RegisterEvent("PLAYER_REGEN_DISABLED")
	autohide:RegisterEvent("PLAYER_TARGET_CHANGED")
	autohide:RegisterEvent("PLAYER_ENTERING_WORLD")
	autohide:RegisterEvent("UNIT_ENTERED_VEHICLE")
	autohide:RegisterEvent("UNIT_EXITED_VEHICLE")

	local function pending()
		if UnitAffectingCombat("player") then return true end
		if UnitExists("target") then return true end
		if UnitInVehicle("player") then return true end
		if SpellBookFrame:IsShown() then return true end
		if IsAddOnLoaded("Blizzard_MacroUI") and MacroFrame:IsShown() then return true end
	end

	local function FadeOutActionButton()
		for _, v in ipairs(rabs) do 
			if _G[v]:GetAlpha()>0 then
				local fadeInfo = {};
				fadeInfo.mode = "OUT";
				fadeInfo.timeToFade = 0.5;
				fadeInfo.finishedFunc = function() _G[v]:Hide() end
				fadeInfo.startAlpha = _G[v]:GetAlpha()
				fadeInfo.endAlpha = 0
				UIFrameFade(_G[v], fadeInfo)
			end 
		end
	end

	local function FadeInActionButton()
		for _, v in ipairs(rabs) do
			if _G[v]:GetAlpha()<1 then
				_G[v]:Show()
				UIFrameFadeIn(_G[v], 0.5, _G[v]:GetAlpha(), 1)
			end
		end
	end

	local buttons = 0
	local function UpdateButtonNumber()
		for i=1, GetNumFlyouts() do
			local x = GetFlyoutID(i)
			local _, _, numSlots, isKnown = GetFlyoutInfo(x)
			if isKnown then
				buttons = numSlots
				break
			end
		end
	end
	hooksecurefunc("ActionButton_UpdateFlyout", UpdateButtonNumber)
	local function SetUpFlyout()
		for i=1, buttons do
			local button = _G["SpellFlyoutButton"..i]
			if button then
				if button:GetParent():GetParent():GetParent() == MultiBarLeft  then
					button:SetScript("OnEnter", function(self) UIFrameFadeIn(SunUIActionBar5,0.5,SunUIActionBar5:GetAlpha(),1) end)
					button:SetScript("OnLeave", function(self) UIFrameFadeOut(SunUIActionBar5,0.5,SunUIActionBar5:GetAlpha(),0) end)
				end
				if button:GetParent():GetParent():GetParent() == MultiBarRight then
					button:SetScript("OnEnter", function(self) UIFrameFadeIn(SunUIActionBar4,0.5,SunUIActionBar4:GetAlpha(),1) end)
					button:SetScript("OnLeave", function(self) UIFrameFadeOut(SunUIActionBar4,0.5,SunUIActionBar4:GetAlpha(),0) end)
				end
				if button:GetParent():GetParent():GetParent() == MultiBarBottomRight then
					button:SetScript("OnEnter", function(self) UIFrameFadeIn(SunUIActionBar3,0.5,SunUIActionBar3:GetAlpha(),1) end)
					button:SetScript("OnLeave", function(self) UIFrameFadeOut(SunUIActionBar3,0.5,SunUIActionBar3:GetAlpha(),0) end)
				end
				if button:GetParent():GetParent():GetParent() == MultiBarBottomLeft then
					button:SetScript("OnEnter", function(self) UIFrameFadeIn(SunUIActionBar2,0.5,SunUIActionBar2:GetAlpha(),1) end)
					button:SetScript("OnLeave", function(self) UIFrameFadeOut(SunUIActionBar2,0.5,SunUIActionBar2:GetAlpha(),0) end)
				end
			end
		end
	end
	SpellFlyout:HookScript("OnShow", SetUpFlyout)


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

	local a = CreateFrame("Frame")
	a:RegisterEvent("ADDON_LOADED")
	a:SetScript("OnEvent", function(self, event, addon)
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
end)
end
function Module:OnInitialize()
	Module:UpdateAutoHide()
end 