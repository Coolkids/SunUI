--thanks susnow
local S, C, L, DB = unpack(select(2, ...))
local _
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("AutoLFG")
function Module:OnInitialize()
C = C["MiniDB"]

	local Locale = {
		zhCN = {
			ignore = "|cffffff00AutoLFG:自动离开队列(%s:已击杀%d/%d个首领)|r",
		},
		zhTW = {ignore = "|cffffff00AutoLFG:自動離開隊列(%s:已擊殺%d/%d個首領)|r",},
		enUS = {
			ignore = "|cffffff00AutoLFG:Auto leave the queue(%s:%d/%d Bosses defeated)|r"
		},
	}
	local L = Locale[GetLocale()]

	local ALFG = CreateFrame("Frame",nil,LFGDungeonReadyDialog)
	ALFG.durationBar = CreateFrame("StatusBar",nil,ALFG)
	ALFG.durationBar.Border = CreateFrame("Frame",nil,ALFG.durationBar)
	ALFG.durationTime	= ALFG.durationBar:CreateFontString(nil,"OVERLAY")
	LFGDungeonReadyDialog.nextUpdate = 0

	local leaveLFG = function(name,curKilled,maxKilled)
		LFGDungeonReadyDialogLeaveQueueButton:Click()
		print(string.format(L.ignore,name,curKilled,maxKilled))
	end

	local DurationWidget = function()
		ALFG:SetSize(LFGDungeonReadyDialog:GetWidth()*0.8,6)
		ALFG:SetPoint("BOTTOM",LFGDungeonReadyDialog,0,12)
		ALFG.durationBar:SetStatusBarTexture(DB.Statusbar)
		ALFG.durationBar:SetPoint("TOPLEFT",ALFG)
		ALFG.durationBar:SetPoint("BOTTOMRIGHT",ALFG)
		ALFG.durationBar:SetFrameLevel(LFGDungeonReadyDialog:GetFrameLevel()+1)
		ALFG:CreateShadow()
		S.CreateBack(ALFG.durationBar)
		S.CreateTop(ALFG.durationBar:GetStatusBarTexture(), 1,.7,0,1)
		S.CreateSpark(ALFG.durationBar, 6, 6)
		
		ALFG.durationTime:SetFontObject(GameFontNormalLarge)
		do local f,s,g =  ALFG.durationTime:GetFont()
			ALFG.durationTime:SetFont(f,12,g)
			ALFG.durationTime:SetText("")
			ALFG.durationTime:SetPoint("RIGHT",LFGDungeonReadyDialogLeaveQueueButton,-8,0)
		end
	end

	local PostUpdateDurationBar = function()
		local obj =	LFGDungeonReadyDialog	
		local oldTime = GetTime()
		local flag = 0
		local duration = 40 
		local interval = 0.1 
		obj:SetScript("OnUpdate",function(self,elapsed)
			obj.nextUpdate = obj.nextUpdate + elapsed
			if obj.nextUpdate > interval then
				local newTime = GetTime()
				if (newTime - oldTime) < duration then
					local width = ALFG:GetWidth() * (newTime - oldTime)/duration
					ALFG.durationBar:SetPoint("BOTTOMRIGHT",ALFG,0-width,0)
					ALFG.durationTime:SetText(string.format("%d",(duration - (newTime - oldTime))))		
					flag = flag + 1
					if flag >= 10 then
						--PlaySoundFile(cfg.countSound2,"Master")
						flag = 0
					end
				else
					obj:SetScript("OnUpdate",nil)
				end
				obj.nextUpdate = 0
			end
		end)
	end

	local IgnoreOldDungeon = function()
		local killedInfo = LFGDungeonReadyDialogInstanceInfoFrame.statusText:GetText()
			local nameInfo = LFGDungeonReadyDialogInstanceInfoFrame.name:GetText()	
			local curKilled = 0
			local maxKilled = 0
			if killedInfo then
				local i,j = string.find(killedInfo,"%/")
				curKilled = string.sub(killedInfo,i-1,j-1)
				maxKilled = string.sub(killedInfo,i+1,i+1)
				if tonumber(curKilled) > 0 and C["igonoreOld"] then
					leaveLFG(nameInfo,curKilled,maxKilled)
				end
			end
	end

	--init
	do DurationWidget() end
	ALFG:RegisterEvent("LFG_PROPOSAL_SHOW")
	ALFG:SetScript("OnEvent",function(self,e)
		if LFGDungeonReadyDialog:IsShown() then
			PostUpdateDurationBar()
			IgnoreOldDungeon()	
		end
	end)

end