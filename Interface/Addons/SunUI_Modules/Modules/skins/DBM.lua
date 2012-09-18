-- Engines
local S, C, L, DB, _ = unpack(SunUI)
 
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SkinDBM", "AceEvent-3.0")
if not IsAddOnLoaded("DBM-Core") then return end
function Module:OnInitialize()
	local Event = CreateFrame("Frame")
	Event:RegisterEvent("PLAYER_LOGIN")
	Event:SetScript("OnEvent", function()
			if not C["SkinDB"]["EnableDBMSkin"] then return end
			hooksecurefunc(DBT, "CreateBar", function(self)
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
						--frame:SetReverseFill(true)
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
							tbar:SetReverseFill(true)
							tbar:Point("TOPLEFT", frame, "TOPLEFT", -1, 1)
							tbar:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
							tbar:CreateShadow()
							local gradient = tbar:CreateTexture(nil, "BACKGROUND")
							gradient:SetPoint("TOPLEFT")
							gradient:SetPoint("BOTTOMRIGHT")
							gradient:SetTexture(DB.Statusbar)
							gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
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
						frame:Show()
						bar:Update(0)
						bar.injected = true
					end
				end
			end)
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
	local SkinBoss=function()
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
				bar.styled=true
			end	
			
					if not progress.styled then
						progress:SetStatusBarTexture(DB.Statusbar)
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
			hooksecurefunc(DBM.BossHealth,"Show",SkinBossTitle)
			hooksecurefunc(DBM.BossHealth,"AddBoss",SkinBoss)
			hooksecurefunc(DBM.BossHealth,"UpdateSettings",SkinBoss)
			DBM.RangeCheck:Show()
			DBM.RangeCheck:Hide()
			DBMRangeCheck:HookScript("OnShow",function(self)
				self.shadow = CreateFrame("Frame", nil, self)
				self.shadow:SetFrameLevel(1)
				self.shadow:SetFrameStrata(self:GetFrameStrata())
				self.shadow:SetPoint("TOPLEFT", -5, 5)
				self.shadow:SetPoint("BOTTOMRIGHT", 5, -5)
			end)

			DBMRangeCheckRadar:HookScript("OnShow",function(self)
				self:SetSize(110, 110)
				self:SetBackdropBorderColor(65/255, 74/255, 79/255)
				S.SetBD(self)
				self.text:SetFont(DB.Font, 13*S.Scale(1), "THINOUTLINE")
				self.text:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
			end)


			local RaidNotice_AddMessage_=RaidNotice_AddMessage
			RaidNotice_AddMessage=function(noticeFrame, textString, colorInfo)
				if textString:find(" |T") then
					textString = string.gsub(textString,"(:12:12)",":18:18:0:0:64:64:5:59:5:59")
				end
				return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
			end
		--new
		local UploadDBM = function()
			DBM_SavedOptions.Enabled = true
			DBT_SavedOptions["DBM"].Scale = 1
			DBT_SavedOptions["DBM"].HugeScale = 1
			DBT_SavedOptions["DBM"].Texture = DB.Statusbar
			DBT_SavedOptions["DBM"].ExpandUpwards = false
			DBT_SavedOptions["DBM"].BarXOffset = 0
			DBT_SavedOptions["DBM"].BarYOffset = 12
			DBT_SavedOptions["DBM"].IconLeft = true
			DBT_SavedOptions["DBM"].Texture = "Interface\\Buttons\\WHITE8x8"
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
		local players = {
			["Coolkid"] = true,
			["Coolkids"] = true,
			["Kenans"] = true,
			["月殤軒"] = true,
			["月殤玄"] = true,
			["月殤妶"] = true,
			["月殤玹"] = true,
			["月殤璇"] = true,
			["月殤旋"] = true,
		}
		if players[DB.PlayerName] == true then UploadDBM() end
	end)
end