local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("AutoHide", "AceEvent-3.0")
function Module:OnInitialize()
local autohide = CreateFrame("Frame")
local rabs = {}

if rABS_StanceBar and UnitFrameDB["EnableBarFader"] then table.insert(rabs, "rABS_StanceBar") end
if rABS_PetBar and UnitFrameDB["EnableBarFader"] then table.insert(rabs, "rABS_PetBar") end
if rABS_MainMenuBar and UnitFrameDB["EnableBarFader"] then table.insert(rabs, "rABS_MainMenuBar") end
if rABS_MultiBarBottomLeft and UnitFrameDB["EnableBarFader"] then table.insert(rabs, "rABS_MultiBarBottomLeft") end
if rABS_MultiBarBottomRight and UnitFrameDB["EnableBarFader"] then table.insert(rabs, "rABS_MultiBarBottomRight") end
if rABS_MultiBarLeft and UnitFrameDB["EnableBarFader"] then table.insert(rabs, "rABS_MultiBarLeft") end
if rABS_MultiBarRight and UnitFrameDB["EnableBarFader"] then table.insert(rabs, "rABS_MultiBarRight") end

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
				button:SetScript("OnEnter", function(self) UIFrameFadeIn(rABS_MultiBarRight,0.5,rABS_MultiBarRight:GetAlpha(),1) end)
				button:SetScript("OnLeave", function(self) UIFrameFadeOut(rABS_MultiBarRight,0.5,rABS_MultiBarRight:GetAlpha(),0) end)
			end
			if button:GetParent():GetParent():GetParent() == MultiBarRight then
				button:SetScript("OnEnter", function(self) UIFrameFadeIn(rABS_MultiBarLeft,0.5,rABS_MultiBarLeft:GetAlpha(),1) end)
				button:SetScript("OnLeave", function(self) UIFrameFadeOut(rABS_MultiBarLeft,0.5,rABS_MultiBarLeft:GetAlpha(),0) end)
			end
			if button:GetParent():GetParent():GetParent() == MultiBarBottomRight then
				button:SetScript("OnEnter", function(self) UIFrameFadeIn(rABS_MultiBarBottomRight,0.5,rABS_MultiBarBottomRight:GetAlpha(),1) end)
				button:SetScript("OnLeave", function(self) UIFrameFadeOut(rABS_MultiBarBottomRight,0.5,rABS_MultiBarBottomRight:GetAlpha(),0) end)
			end
			if button:GetParent():GetParent():GetParent() == MultiBarBottomLeft then
				button:SetScript("OnEnter", function(self) UIFrameFadeIn(rABS_MultiBarBottomLeft,0.5,rABS_MultiBarBottomLeft:GetAlpha(),1) end)
				button:SetScript("OnLeave", function(self) UIFrameFadeOut(rABS_MultiBarBottomLeft,0.5,rABS_MultiBarBottomLeft:GetAlpha(),0) end)
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