--thanks susnow
local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("AutoLFG", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local ALFG = CreateFrame("Frame",nil,LFGDungeonReadyDialog)
ALFG.durationBar = CreateFrame("StatusBar",nil,ALFG)
ALFG.durationTime	= S.MakeFontString(ALFG.durationBar, 12, "NONE")

LFGDungeonReadyDialog.nextUpdate = 0

local DurationWidget = function()
	ALFG:SetSize(LFGDungeonReadyDialog:GetWidth()*0.8,6)
	ALFG:SetPoint("BOTTOM",LFGDungeonReadyDialog,0,12)
	ALFG.durationBar:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	ALFG.durationBar:SetPoint("TOPLEFT", ALFG, 1, -1)
	ALFG.durationBar:SetPoint("BOTTOMRIGHT", ALFG, -1, 1)
	ALFG.durationBar:SetMinMaxValues(0, 40)
	ALFG.durationBar:SetFrameLevel(LFGDungeonReadyDialog:GetFrameLevel()+1)
	ALFG:CreateBorder()

	S.CreateBack(ALFG.durationBar)
	S.CreateTop(ALFG.durationBar:GetStatusBarTexture(), 1,.7, 0)
	S.CreateMark(ALFG.durationBar)
	
	ALFG.durationTime:SetFontObject(GameFontNormalLarge)
	ALFG.durationTime:SetText("")
	ALFG.durationTime:SetPoint("RIGHT",LFGDungeonReadyDialogLeaveQueueButton,-8,0)
end

local PostUpdateDurationBar = function()
	local obj =	LFGDungeonReadyDialog	
	local oldTime = GetTime()
	local duration = 40 
	local interval = 0.1 
	obj:SetScript("OnUpdate",function(self,elapsed)
		obj.nextUpdate = obj.nextUpdate + elapsed
		if obj.nextUpdate > interval then
			local newTime = GetTime()
			if (newTime - oldTime) < duration then
				--print((newTime - oldTime)) --duration - (newTime - oldTime)
				ALFG.durationBar:SetValue(duration - (newTime - oldTime))
				ALFG.durationTime:SetText(string.format("%d",(duration - (newTime - oldTime))))		
			else
				obj:SetScript("OnUpdate",nil)
			end
			obj.nextUpdate = 0
		end
	end)
end
function Module:LFG_PROPOSAL_SHOW()
	if LFGDungeonReadyDialog:IsShown() then
		PostUpdateDurationBar()
	end
end
function Module:OnInitialize()
	DurationWidget()
	self:RegisterEvent("LFG_PROPOSAL_SHOW")
end