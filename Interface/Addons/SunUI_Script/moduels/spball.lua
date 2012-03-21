local S, C, L, DB = unpack(SunUI)
if DB.MyClass ~= "PRIEST" then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("BallBar")
function Module:OnInitialize()
	-- 設置
	local barsize = {UnitFrameDB["Width"],6}											-- 大小					
	local autofade = true												-- 是否开启脱战渐隐
	local bballcolor = {151/255, 86/255, 168/255}						-- 黑球颜色
	local rballcolor = {1, 0.3, 0.6}									-- 红球颜色
	local perbarcolor = {106/255, 90/255, 205/255}						-- 宠物条颜色
	-- 以下部份不要隨意動
	local bspn = GetSpellInfo(77487)  -- 暗影寶珠
	local rspn = GetSpellInfo(95799)  -- 強化暗影

	local bar = CreateFrame("Frame", "spbar", UIParent)
	bar:SetSize(unpack(barsize))
	bar:SetPoint("BOTTOM", oUF_monoPlayerFrame, "TOP", 0, 6)
	bar:SetFrameStrata("MEDIUM")
	bar:SetFrameLevel(2)
	bar:CreateShadow("Background")

	local bbar = CreateFrame("Frame", nil, bar)
	for i = 1, 3 do
		bbar[i] = CreateFrame("StatusBar", nil, bbar)
		bbar[i]:SetSize((bar:GetWidth()-4)/3, bar:GetHeight()/2)
		bbar[i]:SetStatusBarTexture(DB.Statusbar)
		bbar[i]:GetStatusBarTexture():SetHorizTile(false)
		bbar[i]:SetStatusBarColor(unpack(bballcolor))
		bbar[i]:SetAlpha(0)

		if i == 1 then
			bbar[i]:SetPoint("TOPLEFT", bar, 1, -1)
		else
			bbar[i]:SetPoint("LEFT", bbar[i-1], "RIGHT", 1, 0)
		end
	end

	local function tex(p,w,h)
		local f = p:CreateTexture(nil, "OVERLAY")
		f:SetTexture("Interface\\Buttons\\WHITE8x8")
		f:SetSize(w,h)
		f:SetVertexColor(0,0,0)
		
		return f
	end

	bar.ct = tex(bar,bar:GetWidth(),1)
	bar.ct:SetPoint("TOPLEFT",bbar[1],"BOTTOMLEFT",-1,0)

	bbar.ct1 = tex(bar,1,bbar[1]:GetHeight()+1)
	bbar.ct1:SetPoint("LEFT",bbar[1],"RIGHT",0,1)

	bbar.ct2 = tex(bar,1,bbar[2]:GetHeight()+1)
	bbar.ct2:SetPoint("LEFT",bbar[2],"RIGHT",0,1)

	local rbar = CreateFrame("StatusBar", "rstatusbar", bar)
	rbar:SetSize(bar:GetWidth(), bar:GetHeight()/2)
	rbar:SetStatusBarTexture(DB.Statusbar)
	rbar:GetStatusBarTexture():SetHorizTile(false)
	rbar:SetStatusBarColor(unpack(rballcolor))
	rbar:SetPoint("TOPLEFT", bbar[1], "BOTTOMLEFT", -1, -1)
	rbar:SetMinMaxValues(0, 15)
	rbar:SetValue(0)
	rbar:CreateShadow()
	
	rbar.mb1 = tex(rbar,1,rbar:GetHeight()+1)
	rbar.mb1:SetPoint("TOPRIGHT", -rbar:GetWidth()/15*6.5, 0)

	rbar.mb2 = tex(rbar,1,rbar:GetHeight()+1)
	rbar.mb2:SetPoint("TOPLEFT", rbar:GetWidth()/15*1.5, 0)
	
	local function makespar()
		spar =  rbar:CreateTexture(nil, "OVERLAY")
		spar:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		spar:SetBlendMode("ADD")
		spar:SetAlpha(.3)
		spar:SetPoint("TOPLEFT", rbar:GetStatusBarTexture(), "TOPRIGHT", -3, 5)
		spar:SetPoint("BOTTOMRIGHT", rbar:GetStatusBarTexture(), "BOTTOMRIGHT", 3, -5)
	end
	
	local function UpdateRed(self,elapsed)
		-- 紅球部份
		local expirationtime = select(7,UnitBuff("player", rspn))
		if expirationtime then
			rbar:SetAlpha(1)
			timer = expirationtime - GetTime()
			makespar()
		else
			timer = 0
			rbar:SetAlpha(0)
		end
		self:SetValue(timer)
		
	end

	bar:SetAlpha(autofade and .3 or 1)
	local function OnEvent(self,event)
		-- 黑球部份
		rank = select(4,UnitBuff("player", bspn))
		if rank then
			for i = 1, rank do
				bbar[i]:SetAlpha(1)
			end
		else
			for i = 1, 3 do
				bbar[i]:SetAlpha(0)
			end
		end
		rbar:SetScript("OnUpdate", UpdateRed)
		
		if autofade == true then
			if event == "PLAYER_REGEN_DISABLED" then
				self:SetAlpha(1)
			elseif event == "PLAYER_REGEN_ENABLED" then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 0)
			end
		end
	end

	bar:RegisterEvent("PLAYER_ENTERING_WORLD")
	bar:RegisterEvent("UNIT_AURA")
	bar:RegisterEvent("PLAYER_REGEN_DISABLED")
	bar:RegisterEvent("PLAYER_REGEN_ENABLED")
	bar:SetScript("OnEvent", OnEvent)

	local function GetTelent()
	   local points = {}
	   local talent = 1
	   for i=1,3 do
		  _,_,_,_,points[i] = GetTalentTabInfo(i,false,false,GetActiveTalentGroup(false,false));
		  if points[i] > points[talent] then talent = i end
	   end
	   return talent
	end

	local helper = CreateFrame("Frame", nil, UIParent)
	helper:RegisterEvent("PLAYER_ENTERING_WORLD")
	helper:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	helper:RegisterEvent("CONFIRM_TALENT_WIPE")
	helper:RegisterEvent("PLAYER_TALENT_UPDATE")
	helper:SetScript("OnEvent",function()
		if GetTelent() ~= 3 then
			bar:Hide()
			bar.shadow:Hide()
		else
			bar:Show()
			bar.shadow:Show()
		end
	end)
end