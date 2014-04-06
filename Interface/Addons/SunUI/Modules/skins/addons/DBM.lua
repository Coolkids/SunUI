local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function UploadDBM()
	DBM_SavedOptions.Enabled = true
	DBT_SavedOptions["DBM"].Scale = 1
	DBT_SavedOptions["DBM"].HugeScale = 1
	DBT_SavedOptions["DBM"].Texture = S["media"].normal
	DBT_SavedOptions["DBM"].ExpandUpwards = false
	DBT_SavedOptions["DBM"].BarXOffset = 0
	DBT_SavedOptions["DBM"].BarYOffset = 18
	DBT_SavedOptions["DBM"].IconLeft = true
	DBT_SavedOptions["DBM"].IconRight = false	
	DBT_SavedOptions["DBM"].Flash = false
	DBT_SavedOptions["DBM"].FadeIn = true
	DBM_SavedOptions["DisableCinematics"] = true
	DBT_SavedOptions["DBM"].TimerX = 420
	DBT_SavedOptions["DBM"].TimerY = -29
	DBT_SavedOptions["DBM"].TimerPoint = "TOPLEFT"
	DBT_SavedOptions["DBM"].StartColorR = S.myclasscolor.r
	DBT_SavedOptions["DBM"].StartColorG = S.myclasscolor.g
	DBT_SavedOptions["DBM"].StartColorB = S.myclasscolor.b
	DBT_SavedOptions["DBM"].EndColorR = S.myclasscolor.r
	DBT_SavedOptions["DBM"].EndColorG = S.myclasscolor.g
	DBT_SavedOptions["DBM"].EndColorB = S.myclasscolor.b
	DBT_SavedOptions["DBM"].Width = 130
	DBT_SavedOptions["DBM"].Height = 20
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

local function SkinDBM()
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
					--icon1:SetSize(icon1:GetWidth()-5, icon1:GetWidth()-5)
					icon1.SetSize = S.dummy
					icon1:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					icon1:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", -8, -1)
				end

				if icon2 then
					icon2:ClearAllPoints()
					icon2.SetSize = S.dummy
					--icon2:SetSize(icon2:GetWidth()-5, icon2:GetWidth()-5)
					icon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					icon2:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 8, -1)
					icon2.SetSize = S.dummy
				end

				if not frame.styled then
					frame:SetScale(1)
					frame.SetScale=S.dummy
					frame:SetHeight(icon1:GetHeight()/2-4)
					frame.SetHeight = S.dummy
					frame.styled = true
				end
				--if bar.enlarged then frame:SetHeight(icon1:GetHeight()/2) else frame:SetHeight(icon1:GetHeight()/2) end
				--if bar.enlarged then tbar:SetHeight(icon1:GetHeight()/2) else tbar:SetHeight(icon1:GetHeight()/2) end
				if not tbar.styled then
					tbar:SetStatusBarTexture(S["media"].normal)
					tbar:SetStatusBarColor(S.myclasscolor.r, S.myclasscolor.g, S.myclasscolor.b)
					tbar:SetHeight(icon1:GetHeight()/2-4)
					--A:CreateTop(tbar:GetStatusBarTexture(), DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
					--tbar.SetStatusBarTexture = function() end
					--tbar.SetStatusBarColor = function() end
					tbar:SetAllPoints(frame)
					--tbar:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
					--tbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
					tbar:CreateShadow("Background")
					A:CreateMark(tbar)
					tbar.styled = true
				end
				if not texture.styled then
					texture:SetTexture(S["media"].normal)
					texture.styled=true
				end
				if not spark.killed then
					spark:SetAlpha(0)
					spark:SetTexture(nil)
					spark.killed = true
				end

				if not icon1.styled then
					icon1.Shadow = A:CreateShadow(frame, icon1)
					icon1.styled = true
				end

				if not name.styled then
					name:ClearAllPoints()
					name:SetPoint("LEFT", frame, 5, icon1:GetHeight()/2)
					name.SetPoint = S.dummy
					name:SetFont(S["media"].font, S["media"].fontsize, "THINOUTLINE")
					name:SetShadowOffset(0, 0)
					name:SetJustifyH("LEFT")
					name.SetFont = function() end
					name.styled = true
				end

				if not timer.styled then
					timer:ClearAllPoints()
					timer:SetPoint("RIGHT", frame, -5, icon1:GetHeight()/2)					
					timer:SetFont(S["media"].font, S["media"].fontsize, "THINOUTLINE")
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
					header[1]:SetFont(S["media"].font, S["media"].fontsize, "THINOUTLINE")
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
					bar:SetPoint("BOTTOM", anch, "TOP" , 0 , 15)
				else
					bar:SetPoint("TOP", anch, "BOTTOM" , 0, -15)
				end
			else
				bar:ClearAllPoints()
				if DBM_SavedOptions.HealthFrameGrowUp then
					bar:SetPoint("TOPLEFT", prev, "TOPLEFT", 0, 10+10)
				else
					bar:SetPoint("TOPLEFT", prev, "TOPLEFT", 0, -(10+10))
				end
			end

			if not bar.styled then
				bar:SetHeight(10)
				background:StripTextures()
				progress:StripTextures()
				local h = CreateFrame("Frame", nil, bar)
				h:SetPoint("TOPLEFT", bar, "TOPLEFT", 1, -1)
				h:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -1, 1)
				h:CreateShadow("Background")
				A:CreateMark(progress)
				bar.styled=true
			end	
		
			if not progress.styled then
				progress:SetStatusBarTexture(S["media"].normal)
				progress.styled=true
			end				
			progress:ClearAllPoints()
			progress:SetPoint("TOPLEFT", bar, "TOPLEFT", 1, -1)
			progress:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -1, 1)
				

			if not name.styled then
				name:ClearAllPoints()
				name:SetPoint("LEFT", bar, "LEFT", 4, 6)
				name:SetFont(S["media"].font,  S["media"].fontsize, "THINOUTLINE")
				name:SetJustifyH("LEFT")
				name:SetShadowColor(0, 0, 0, 0)
				name.styled=true
			end

			if not timer.styled then
				timer:ClearAllPoints()
				timer:SetPoint("RIGHT", bar, "RIGHT", -4, 6)
				timer:SetFont(S["media"].font, S["media"].fontsize, "THINOUTLINE")
				timer:SetJustifyH("RIGHT")
				timer:SetShadowColor(0, 0, 0, 0)
				timer.styled=true
			end
			count = count + 1
		end
	end
	
	hooksecurefunc(DBT, "CreateBar", SkinDBMBar)
	hooksecurefunc(DBM.BossHealth,"Show",SkinBossTitle)
	hooksecurefunc(DBM.BossHealth,"AddBoss",SkinBoss)
	hooksecurefunc(DBM.BossHealth,"UpdateSettings",SkinBoss)
	
	DBM.RangeCheck:Show()
	DBM.RangeCheck:Hide()
	if DBMRangeCheck then
		DBMRangeCheck:HookScript("OnShow",function(self)
			if not self.styled then
				self:SetBackdrop(nil)
				--print("call DBMRangeCheck OnShow styled")
				A:SetBD(self)
				--self:CreateShadow("Background")
			end
		end)
	end
	if DBMRangeCheckRadar then
		DBMRangeCheckRadar:HookScript("OnShow",function(self)
			if not self.styled then
				--print("call DBMRangeCheckRadar OnShow styled")
				A:SetBD(self)
				--self:CreateShadow("Background")
				self.text:SetFont(S["media"].font, S["media"].fontsize+1, "THINOUTLINE")
				DBMRangeCheckRadar.text:SetPoint("BOTTOMLEFT", DBMRangeCheckRadar, "TOPLEFT", 0, 5)
				DBMRangeCheckRadar:SetBackdropBorderColor(65/255, 74/255, 79/255)
				self.text:SetShadowColor(0, 0, 0)
				self.text:SetShadowOffset(1, -1)
				self.styled = true
			end
		end)
	end
	
	if DBM.InfoFrame then
		DBM.InfoFrame:Show(5, "test")
		DBM.InfoFrame:Hide()
		DBMInfoFrame:HookScript("OnShow",function(self)
			if not self.styled then
				--print("call InfoFrame OnShow styled")
				self:SetBackdrop(nil)
				A:SetBD(self)
				self.styled = true
			end
			--self:CreateShadow("Background")
		end)
	end
	
	hooksecurefunc(DBM, "ShowUpdateReminder", function()
		for i = UIParent:GetNumChildren(), 1, -1 do
			local frame = select(i, UIParent:GetChildren())

			local editBox = frame:GetChildren()
			if editBox and editBox:GetObjectType() == "EditBox" and editBox:GetText() == "http://www.deadlybossmods.com" and not frame.styled then
				A:CreateBD(frame)

				select(6, editBox:GetRegions()):Hide()
				select(7, editBox:GetRegions()):Hide()
				select(8, editBox:GetRegions()):Hide()

				local bg = S:CreateBDFrame(editBox, .25)
				bg:SetPoint("TOPLEFT", -2, -6)
				bg:SetPoint("BOTTOMRIGHT", 2, 8)

				A:Reskin(select(2, frame:GetChildren()))

				frame.styled = true
			end
		end
	end)
	
	local RaidNotice_AddMessage_ = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
		if textString:find("|T") then
			if textString:match(":(%d+):(%d+)") then
				local size1, size2 = textString:match(":(%d+):(%d+)")
				size1, size2 = size1 + 6, size2 + 6
				textString = string.gsub(textString,":(%d+):(%d+)",":"..size1..":"..size2..":0:0:64:64:5:59:5:59")
			elseif textString:match(":(%d+)|t") then
				local size = textString:match(":(%d+)|t")
				size = size + 6
				textString = string.gsub(textString,":(%d+)|t",":"..size..":"..size..":0:0:64:64:5:59:5:59|t")
			end
		end
		return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
	end
	
	if S:IsDeveloper() then UploadDBM() end
end
A:RegisterSkin("DBM-Core", SkinDBM)

StaticPopupDialogs["SUNUI_DBM_CFG_RELOAD"] = {
	text = "改变DBM参数需重载应用设置",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() UploadDBM() ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}
StaticPopupDialogs["SUNUI_DBM_NOT_FAND"] = {
	text = "您没有安装DBM",
	button1 = CANCEL,
	timeout = 0,
	whileDead = 1,
}
SlashCmdList["SetDBM"] = function()
	if not UnitAffectingCombat("player") then	
		if IsAddOnLoaded("DBM-Core") then 
			StaticPopup_Show("SUNUI_DBM_CFG_RELOAD") 
		else
			StaticPopup_Show("SUNUI_DBM_NOT_FAND") 
		end
	end
end
SLASH_SetDBM1 = "/SetDBM"
local function SkinGUI()
	DBM_GUI_OptionsFrameHeader:SetTexture(nil)
	DBM_GUI_OptionsFramePanelContainer:SetBackdrop(nil)
	DBM_GUI_OptionsFrameBossModsList:SetBackdrop(nil)
	DBM_GUI_OptionsFrameBossMods:DisableDrawLayer("BACKGROUND")
	DBM_GUI_OptionsFrameDBMOptions:DisableDrawLayer("BACKGROUND")

	if DBM_GUI_OptionsFramecheck then
		A:Reskin(DBM_GUI_OptionsFramecheck)
		A:Reskin(DBM_GUI_OptionsFramecheck2)
		DBM_GUI_OptionsFrameSoundMM:Kill()
		DBM_GUI_OptionsFrameWebsite:Kill()
		DBM_GUI_OptionsFrameWebsiteButton:Kill()
		DBM_GUI_OptionsFrameTranslation:Kill()
	end

	for i = 1, 2 do
		_G["DBM_GUI_OptionsFrameTab"..i.."Left"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."Middle"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."Right"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
	end

	local count = 1

	local function styleDBM()
		local option = _G["DBM_GUI_Option_"..count]
		while option do
			local objType = option:GetObjectType()
			if objType == "CheckButton" then
				A:ReskinCheck(option)
			elseif objType == "Slider" then
				A:ReskinSlider(option)
			elseif objType == "EditBox" then
				A:ReskinInput(option)
			elseif option:GetName():find("DropDown") then
				A:ReskinDropDown(option)
			elseif objType == "Button" then
				A:Reskin(option)
			elseif objType == "Frame" then
				option:SetBackdrop(nil)
			end

			count = count + 1
			option = _G["DBM_GUI_Option_"..count]
			if not option then
				option = _G["DBM_GUI_DropDown"..count]
			end
		end
	end

	DBM:RegisterOnGuiLoadCallback(function()
		styleDBM()
		hooksecurefunc(DBM_GUI, "UpdateModList", styleDBM)
		DBM_GUI_OptionsFrameBossMods:HookScript("OnShow", styleDBM)
	end)

	DBM_GUI_OptionsFrame:StripTextures()
	A:SetBD(DBM_GUI_OptionsFrame)
	A:Reskin(DBM_GUI_OptionsFrameOkay)
	A:Reskin(DBM_GUI_OptionsFrameWebsiteButton)
	A:ReskinScroll(DBM_GUI_OptionsFramePanelContainerFOVScrollBar)
	A:ReskinScroll(DBM_GUI_OptionsFrameBossModsListScrollBar)
end

local function SkinInfoFrame()
	if DBMInfoFrame.sunuistyle then return end
	DBMInfoFrame:StripTextures()
	A:SetBD(DBMInfoFrame)
	DBMInfoFrame.sunuistyle = true
end
A:RegisterSkin("DBM-GUI", SkinGUI)
