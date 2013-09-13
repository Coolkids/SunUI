local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SkinDBM", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local function SkinDBMBar(self)
	for bar in self:GetBarIterator() do
		if not bar.injected then
			local frame = bar.frame
			local tbar = _G[frame:GetName().."Bar"]
			local spark = _G[frame:GetName().."BarSpark"]
			local texture = _G[frame:GetName().."BarTexture"]
			local icon1 = _G[frame:GetName().."BarIcon1"]
			local icon2 = _G[frame:GetName().."BarIcon2"]
			local name = _G[frame:GetName().."BarName"]
			local timer = _G[frame:GetName().."BarTimer"]
			
			if icon1 then
				icon1:ClearAllPoints()
				icon1:SetSize(16, 16)
				icon1:SetTexCoord(0.08, 0.92, 0.08, 0.92)
				icon1:Point("BOTTOMRIGHT", frame, "BOTTOMLEFT", -8, -1)
			end

			if icon2 then
				icon2:ClearAllPoints()
				icon2:SetSize(16, 16)
				icon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)
				icon2:Point("BOTTOMLEFT", frame, "BOTTOMRIGHT", 8, -1)
			end

			if not frame.styled then
				frame:SetScale(1)
				frame:SetHeight(icon1:GetHeight()/2)
				frame.styled = true
			end

			if not tbar.styled then
				tbar:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
				S.CreateTop(tbar:GetStatusBarTexture(), DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
				tbar.SetStatusBarTexture = function() end
				tbar.SetStatusBarColor = function() 
					S.CreateTop(tbar:GetStatusBarTexture(), DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
				end
				tbar:Point("TOPLEFT", frame, "TOPLEFT", -1, 1)
				tbar:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
				tbar:CreateShadow()
				S.CreateBack(tbar)
				S.CreateMark(tbar)
				tbar.styled = true
			end
			
			if not spark.killed then
				spark:SetAlpha(0)
				spark:SetTexture(nil)
				spark.killed = true
			end

			if not icon1.styled then
				icon1.Shadow = S.CreateShadow(frame, icon1)
				icon1.styled = true
			end

			if not name.styled then
				name:ClearAllPoints()
				name:SetPoint("LEFT", frame, 5, icon1:GetHeight()/2)
				name:SetFont(DB.Font, 11*S.Scale(1), "THINOUTLINE")
				name:SetShadowOffset(0, 0)
				name:SetJustifyH("LEFT")
				name.SetFont = function() end
				name.styled = true
			end

			if not timer.styled then
				timer:ClearAllPoints()
				timer:SetPoint("RIGHT", frame, -5, icon1:GetHeight()/2)					
				timer:SetFont(DB.Font, 11*S.Scale(1), "THINOUTLINE")
				timer:SetShadowOffset(0,0)
				timer:SetJustifyH("RIGHT")
				timer.SetFont = function() end
				timer.styled = true
			end
			
			bar.injected = true
		end
	end
end
local SkinBossTitle=function()
	local anchor=DBMBossHealthDropdown:GetParent()
	if not anchor.styled then
		local header={anchor:GetRegions()}
			if header[1]:IsObjectType("FontString") then
				header[1]:SetFont(DB.Font, 12*S.Scale(1), "THINOUTLINE")
				header[1]:SetTextColor(1,1,1,1)
				header[1]:SetShadowColor(0, 0, 0, 0)
				anchor.styled=true	
			end
		header=nil
	end
	anchor=nil
end
local function SkinBoss()
	local count = 1
	while (_G[format("DBM_BossHealth_Bar_%d", count)]) do
		local bar = _G[format("DBM_BossHealth_Bar_%d", count)]
		local background = _G[bar:GetName().."BarBorder"]
		local progress = _G[bar:GetName().."Bar"]
		local name = _G[bar:GetName().."BarName"]
		local timer = _G[bar:GetName().."BarTimer"]
		local prev = _G[format("DBM_BossHealth_Bar_%d", count-1)]	

		if (count == 1) then
			local	_, anch, _ ,_, _ = bar:GetPoint()
			bar:ClearAllPoints()
			if DBM_SavedOptions.HealthFrameGrowUp then
				bar:Point("BOTTOM", anch, "TOP" , 0 , 15)
			else
				bar:Point("TOP", anch, "BOTTOM" , 0, -15)
			end
		else
			bar:ClearAllPoints()
			if DBM_SavedOptions.HealthFrameGrowUp then
				bar:Point("TOPLEFT", prev, "TOPLEFT", 0, 10+10)
			else
				bar:Point("TOPLEFT", prev, "TOPLEFT", 0, -(10+10))
			end
		end

		if not bar.styled then
			bar:SetHeight(10)
			background:StripTextures()
			progress:StripTextures()
			local h = CreateFrame("Frame", nil, bar)
			h:Point("TOPLEFT", bar, "TOPLEFT", 1, -1)
			h:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -1, 1)
			h:CreateShadow()
			S.CreateBack(h)
			S.CreateMark(progress, 8)
			bar.styled=true
		end	
	
		if not progress.styled then
			progress:SetStatusBarTexture(DB.Statusbar)
			progress.SetStatusBarColor = function(t, r, g, b)
				S.CreateTop(progress:GetStatusBarTexture(), r, g, b)
			end
			progress.styled=true
		end				
		progress:ClearAllPoints()
		progress:Point("TOPLEFT", bar, "TOPLEFT", 1, -1)
		progress:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -1, 1)
			

		if not name.styled then
			name:ClearAllPoints()
			name:SetPoint("LEFT", bar, "LEFT", 4, 6)
			name:SetFont(DB.Font,  12*S.Scale(1), "THINOUTLINE")
			name:SetJustifyH("LEFT")
			name:SetShadowColor(0, 0, 0, 0)
			name.styled=true
		end

		if not timer.styled then
			timer:ClearAllPoints()
			timer:SetPoint("RIGHT", bar, "RIGHT", -4, 6)
			timer:SetFont(DB.Font, 12*S.Scale(1), "THINOUTLINE")
			timer:SetJustifyH("RIGHT")
			timer:SetShadowColor(0, 0, 0, 0)
			timer.styled=true
		end
		count = count + 1
	end
end
local UploadDBM = function()
	DBM_SavedOptions.Enabled = true
	DBT_SavedOptions["DBM"].Scale = 1
	DBT_SavedOptions["DBM"].HugeScale = 1
	DBT_SavedOptions["DBM"].Texture = DB.Statusbar
	DBT_SavedOptions["DBM"].ExpandUpwards = false
	DBT_SavedOptions["DBM"].BarXOffset = 0
	DBT_SavedOptions["DBM"].BarYOffset = 12
	DBT_SavedOptions["DBM"].IconLeft = true
	DBT_SavedOptions["DBM"].IconRight = false	
	DBT_SavedOptions["DBM"].Flash = false
	DBT_SavedOptions["DBM"].FadeIn = true
	DBM_SavedOptions["DisableCinematics"] = true
	DBT_SavedOptions["DBM"].TimerX = 420
	DBT_SavedOptions["DBM"].TimerY = -29
	DBT_SavedOptions["DBM"].TimerPoint = "TOPLEFT"
	DBT_SavedOptions["DBM"].StartColorR = DB.MyClassColor.r
	DBT_SavedOptions["DBM"].StartColorG = DB.MyClassColor.g
	DBT_SavedOptions["DBM"].StartColorB = DB.MyClassColor.b
	DBT_SavedOptions["DBM"].EndColorR = DB.MyClassColor.r
	DBT_SavedOptions["DBM"].EndColorG = DB.MyClassColor.g
	DBT_SavedOptions["DBM"].EndColorB = DB.MyClassColor.b
	DBT_SavedOptions["DBM"].Width = 130
	DBT_SavedOptions["DBM"].HugeWidth = 155
	DBT_SavedOptions["DBM"].HugeTimerPoint = "TOP"
	DBT_SavedOptions["DBM"].HugeTimerX = -150
	DBT_SavedOptions["DBM"].HugeTimerY = -207
	DBM_SavedOptions["SpecialWarningFontColor"] = {
		0.40,
		0.78,
		1,
	}
	DBM_SavedOptions["ShowWarningsInChat"] = false
	DBM_SavedOptions["HideBossEmoteFrame"] = true
end
SlashCmdList["SetDBM"] = function()
	StaticPopupDialogs["CFG_RELOAD"] = {
	text = "改变DBM参数需重载应用设置",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() ReloadUI() end,
	timeout = 0,
	whileDead = 1,
	}
	if not UnitAffectingCombat("player") then
		UploadDBM()
		StaticPopup_Show("CFG_RELOAD")
	end
end
SLASH_SetDBM1 = "/SetDBM"
local function SkinGUI(event, addon)
	if addon == "DBM-GUI" then
		local skinned = false
		DBM_GUI_OptionsFrame:HookScript("OnShow", function()
			if skinned then return end
			DBM_GUI_OptionsFrame:StripTextures()
			DBM_GUI_OptionsFramePanelContainer:StripTextures()
			DBM_GUI_OptionsFrameBossMods:StripTextures()
			DBM_GUI_OptionsFrameDBMOptions:StripTextures()
			S.SetBD(DBM_GUI_OptionsFrame)
			S.CreateBD(DBM_GUI_OptionsFrameBossMods)
			S.CreateBD(DBM_GUI_OptionsFrameDBMOptions)
			S.CreateBD(DBM_GUI_OptionsFramePanelContainer)
			skinned = true
		end)
		S.Reskin(DBM_GUI_OptionsFrameOkay)
		S.ReskinScroll(DBM_GUI_OptionsFramePanelContainerFOVScrollBar)
	end
end
local function SkinRangeCheck()
	if DBMRangeCheck.sunuistyle then return end
	S.SetBD(DBMRangeCheck)
	DBMRangeCheck:StripTextures()
	if DBMRangeCheckRadar then
		DBMRangeCheckRadar:SetSize(110, 110)
		DBMRangeCheckRadar:SetBackdropBorderColor(65/255, 74/255, 79/255)
		S.SetBD(DBMRangeCheckRadar)
		DBMRangeCheckRadar.text:SetFont(DB.Font, 13*S.Scale(1), "THINOUTLINE")
		DBMRangeCheckRadar.text:Point("BOTTOMLEFT", DBMRangeCheckRadar, "TOPLEFT", 0, 5)
	end
	DBMRangeCheck.sunuistyle = true
end
local function SkinInfoFrame()
	if DBMInfoFrame.sunuistyle then return end
	DBMInfoFrame:StripTextures()
	S.SetBD(DBMInfoFrame)
	DBMInfoFrame.sunuistyle = true
end
function Module:OnEnable()
	C = SunUIConfig.db.profile
	if not C["SkinDB"]["EnableDBMSkin"] then return end
	if not IsAddOnLoaded("DBM-Core") then return end
	hooksecurefunc(DBT, "CreateBar", SkinDBMBar)
	hooksecurefunc(DBM.BossHealth,"Show",SkinBossTitle)
	hooksecurefunc(DBM.BossHealth,"AddBoss",SkinBoss)
	hooksecurefunc(DBM.BossHealth,"UpdateSettings",SkinBoss)
	hooksecurefunc(DBM.RangeCheck, "Show", SkinRangeCheck)
	hooksecurefunc(DBM.InfoFrame, "Show", SkinInfoFrame)
	local RaidNotice_AddMessage_=RaidNotice_AddMessage
	RaidNotice_AddMessage=function(noticeFrame, textString, colorInfo)
		if textString:find(" |T") then
			textString = string.gsub(textString,"(:12:12)",":18:18:0:0:64:64:5:59:5:59")
		end
		return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
	end
	
	if S.IsCoolkid() then UploadDBM() end
	Module:RegisterEvent("ADDON_LOADED", SkinGUI)
end