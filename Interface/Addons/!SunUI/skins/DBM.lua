-- Engines
local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("SkinDBM", "AceEvent-3.0")
function Module:OnInitialize()
	local Event = CreateFrame("Frame")
	Event:RegisterEvent("PLAYER_LOGIN")
	Event:SetScript("OnEvent", function()
		if IsAddOnLoaded("DBM-Core") then
			if not SkinDB["EnableDBMSkin"] then return end
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
						if icon1 then
							icon1:ClearAllPoints()
							icon1:SetSize(24, 24)
							icon1:SetTexCoord(0.08, 0.92, 0.08, 0.92)
							icon1:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", -5, 0)
						end

						if icon2 then
							icon2:ClearAllPoints()
							icon2:SetSize(24, 24)
							icon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)
							icon2:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 5, 0)
						end

						if not frame.styled then
							frame:SetScale(1)
							frame:SetHeight(icon1:GetHeight()/3)
							frame:CreateShadow("Background")
							frame.styled = true
						end

						if not tbar.styled then
							tbar:SetAllPoints(frame)
							frame.styled = true
						end
						
						if not spark.killed then
							spark:SetAlpha(0)
							spark:SetTexture(nil)
							spark.killed = true
						end

						if not icon1.styled then
							icon1.Shadow = CreateShadow(frame, icon1)
							icon1.styled = true
						end

						if not name.styled then
							name:ClearAllPoints()
							name:SetPoint("LEFT", frame, 5, icon1:GetHeight()/2)
							name:SetFont(DB.Font, 11*S.Scale(1), "THINOUTLINE")
							name:SetShadowOffset(0, 0)
							name.SetFont = function() end
							name.styled = true
						end

						if not timer.styled then
							timer:ClearAllPoints()
							timer:SetPoint("RIGHT", frame, -5, icon1:GetHeight()/2)					
							timer:SetFont(DB.Font, 11*S.Scale(1), "THINOUTLINE")
							timer:SetShadowOffset(0,0)
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
							bar:SetPoint("BOTTOM", anch, "TOP" , 0 , 12)
						else
							bar:SetPoint("TOP", anch, "BOTTOM" , 0, -10)
						end
					else
						bar:ClearAllPoints()
						if DBM_SavedOptions.HealthFrameGrowUp then
							bar:SetPoint("TOPLEFT", prev, "TOPLEFT", 0, 10+8)
						else
							bar:SetPoint("TOPLEFT", prev, "TOPLEFT", 0, -(10+8))
						end
					end

			if not bar.styled then
				bar:SetHeight(10)
				S.Kill(background)
				--S.MakeTexShadow(bar, background, 3)
				background:SetNormalTexture(nil)
				bar.styled=true
			end	
			
					if not progress.styled then
						progress:SetStatusBarTexture(DB.Statusbar)
						progress.styled=true
					end				
					progress:ClearAllPoints()
					progress:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, -2)
					progress:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 2)
		
					if not name.styled then
						name:ClearAllPoints()
						name:SetPoint("LEFT", bar, "LEFT", 4, 2)
						name:SetFont(DB.Font,  12*S.Scale(1), "THINOUTLINE")
						name:SetJustifyH("LEFT")
						name:SetShadowColor(0, 0, 0, 0)
						name.styled=true
					end
			
					if not timer.styled then
						timer:ClearAllPoints()
						timer:SetPoint("RIGHT", bar, "RIGHT", -4, 2)
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
				self:SetBackdrop({
					edgeFile = "Interface\\Buttons\\WHITE8x8", 
					edgeSize = 1, 
				})
				self:SetBackdropBorderColor(65/255, 74/255, 79/255)
				self.shadow = CreateFrame("Frame", nil, self)
				self.shadow:SetFrameLevel(1)
				self.shadow:SetFrameStrata(self:GetFrameStrata())
				self.shadow:SetPoint("TOPLEFT", -5, 5)
				self.shadow:SetPoint("BOTTOMRIGHT", 5, -5)
				self.shadow:SetBackdrop({
					edgeFile = DB.GlowTex, 
					edgeSize = 5,
					insets = { left = 4, right = 4, top = 4, bottom = 4 }
				})
				self.shadow:SetBackdropBorderColor(0,0,0)
			end)

			DBMRangeCheckRadar:HookScript("OnShow",function(self)
				self:SetBackdrop({
					edgeFile = "Interface\\Buttons\\WHITE8x8", 
					edgeSize = 1, 
				})
				self:SetBackdropBorderColor(65/255, 74/255, 79/255)
				self.shadow = CreateFrame("Frame", nil, self)
				self.shadow:SetFrameLevel(1)
				self.shadow:SetFrameStrata(self:GetFrameStrata())
				self.shadow:SetPoint("TOPLEFT", -5, 5)
				self.shadow:SetPoint("BOTTOMRIGHT", 5, -5)
				self.shadow:SetBackdrop({
					edgeFile = DB.GlowTex, 
					edgeSize = 5,
					insets = { left = 4, right = 4, top = 4, bottom = 4 }
				})
				self.shadow:SetBackdropBorderColor(0,0,0)
				self.text:SetFont(DB.Font, 14*S.Scale(1), "THINOUTLINE")
			end)


			local RaidNotice_AddMessage_=RaidNotice_AddMessage
			RaidNotice_AddMessage=function(noticeFrame, textString, colorInfo)
				if textString:find(" |T") then
					textString = string.gsub(textString,"(:12:12)",":18:18:0:0:64:64:5:59:5:59")
				end
				return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
			end

			DBM_SavedOptions.Enabled = true
			DBT_SavedOptions["DBM"].Scale = 1
			DBT_SavedOptions["DBM"].HugeScale = 1
			DBT_SavedOptions["DBM"].Texture = DB.Statusbar
			DBT_SavedOptions["DBM"].ExpandUpwards = false
			DBT_SavedOptions["DBM"].BarXOffset = 0
			DBT_SavedOptions["DBM"].BarYOffset = 20
			DBT_SavedOptions["DBM"].IconLeft = true
			DBT_SavedOptions["DBM"].Texture = "Interface\\Buttons\\WHITE8x8"
			DBT_SavedOptions["DBM"].IconRight = false
		end
	end)
end