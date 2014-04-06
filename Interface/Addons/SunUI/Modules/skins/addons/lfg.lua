local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")
local LS = S:NewModule("LFGDungeonSkin", "AceEvent-3.0")
local ALFG = CreateFrame("Frame",nil,LFGDungeonReadyDialog)


LFGDungeonReadyDialog.nextUpdate = 0

local DurationWidget = function()
	ALFG:SetSize(LFGDungeonReadyDialog:GetWidth()*0.8,6)
	ALFG:SetPoint("BOTTOM",LFGDungeonReadyDialog,0,12)
	ALFG.durationBar = CreateFrame("StatusBar",nil,ALFG)
	ALFG.durationTime = ALFG.durationBar:CreateFontString(nil, "OVERLAY")
	ALFG.durationBar:SetStatusBarTexture(S["media"].normal)
	ALFG.durationBar:SetPoint("TOPLEFT", ALFG, 1, -1)
	ALFG.durationBar:SetPoint("BOTTOMRIGHT", ALFG, -1, 1)
	ALFG.durationBar:SetMinMaxValues(0, 40)
	ALFG.durationBar:SetFrameLevel(LFGDungeonReadyDialog:GetFrameLevel()+1)
	ALFG:CreateBorder()
	ALFG.durationBar:SetStatusBarColor(1,.7, 0)
	ALFG.durationBar:CreateShadow()
	A:CreateMark(ALFG.durationBar)
	
	ALFG.durationTime:FontTemplate()
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
function LS:LFG_PROPOSAL_SHOW()
	if LFGDungeonReadyDialog:IsShown() then
		PostUpdateDurationBar()
	end
end
local function SkinFrame()
	DurationWidget()
	LS:RegisterEvent("LFG_PROPOSAL_SHOW")
end
A:RegisterSkin("SunUI", SkinFrame)