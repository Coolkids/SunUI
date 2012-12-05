--thanks susnow
local S, C, L, DB = unpack(select(2, ...))
local _
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("AutoLFG")


local Locale = {
	zhCN = {
		ignore = "|cffffff00AutoLFG:警告!! 队列(%s:已击杀%d/%d个首领)|r",
	},
	zhTW = {ignore = "|cffffff00AutoLFG:警告!! 隊列(%s:已擊殺%d/%d個首領)|r",},
	enUS = {
		ignore = "|cffffff00AutoLFG:the queue(%s:%d/%d Bosses defeated)|r"
	},
}
local L = Locale[GetLocale()]
local ALFG = CreateFrame("Frame",nil,LFGDungeonReadyDialog)
ALFG.durationBar = CreateFrame("StatusBar",nil,ALFG)
ALFG.durationBar.Border = CreateFrame("Frame",nil,ALFG.durationBar)
ALFG.durationTime	= ALFG.durationBar:CreateFontString(nil,"OVERLAY")
local text = S.MakeFontString(ALFG, nil, "NONE")
text:SetFontObject(GameFontNormal)
LFGDungeonReadyDialog.nextUpdate = 0

local DurationWidget = function()
	ALFG:SetSize(LFGDungeonReadyDialog:GetWidth()*0.8,6)
	ALFG:SetPoint("BOTTOM",LFGDungeonReadyDialog,0,12)
	ALFG.durationBar:SetStatusBarTexture(DB.Statusbar)
	ALFG.durationBar:SetPoint("TOPLEFT", ALFG, 1, -1)
	ALFG.durationBar:SetPoint("BOTTOMRIGHT", ALFG, -1, 1)
	ALFG.durationBar:SetMinMaxValues(0, 40)
	ALFG.durationBar:SetFrameLevel(LFGDungeonReadyDialog:GetFrameLevel()+1)
	ALFG:CreateBorder()
	--ALFG.durationBar:CreateShadow()
	S.CreateBack(ALFG.durationBar)
	S.CreateTop(ALFG.durationBar:GetStatusBarTexture(), 1,.7, 0)
	S.CreateMark(ALFG.durationBar, 4)
	text:SetPoint("TOP", LFGDungeonReadyDialogInstanceInfoFrame, "BOTTOM", 0, 14)
	ALFG.durationTime:SetFontObject(GameFontNormalLarge)
	local f,s,g =  ALFG.durationTime:GetFont()
	ALFG.durationTime:SetFont(f,12,g)
	ALFG.durationTime:SetText("")
	ALFG.durationTime:SetPoint("RIGHT",LFGDungeonReadyDialogLeaveQueueButton,-8,0)
end
local IgnoreOldDungeon = function()
	local _, _, _, _, _, _, _, _, _, completedEncounters, _, _, _, totalEncounters = GetLFGProposal(); 
	if totalEncounters and totalEncounters > 1 then
		text:SetFormattedText(BOSSES_KILLED, completedEncounters, totalEncounters)
		if completedEncounters and completedEncounters > 0 then
			text:SetTextColor(1, 0, 0)
		end
	else
		text:SetText("")
	end
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

--init
DurationWidget()
ALFG:RegisterEvent("LFG_PROPOSAL_SHOW")
ALFG:RegisterEvent("LFG_PROPOSAL_UPDATE")
ALFG:SetScript("OnEvent",function(self,e)
	if e == "LFG_PROPOSAL_SHOW" then
		if LFGDungeonReadyDialog:IsShown() then
			PostUpdateDurationBar()
		end
	end
	IgnoreOldDungeon()
end)