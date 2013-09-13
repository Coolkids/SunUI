local addon, ns = ...
local oUF = ns.oUF or oUF 
local cast = ns.cast
local S, L, DB, _, C = unpack(select(2, ...))
local UF = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("UnitFrame")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local P,U
local class = DB.MyClass
local space = (class == "DEATHKNIGHT") and 2 or 6
oUF.colors.power['MANA'] = {.3,.45,.65}
oUF.colors.power['RAGE'] = {.7,.3,.3}
oUF.colors.power['FOCUS'] = {.7,.45,.25}
--oUF.colors.power['ENERGY'] = {.65,.65,.35}
oUF.colors.power['RUNIC_POWER'] = {.45,.45,.75}
local headframe
-----------------------------
-- FUNCTIONS
-----------------------------
local dropdown = CreateFrame('Frame', 'SunUIUF_DropDown', UIParent, 'UIDropDownMenuTemplate')

local function gen_fontstring(f, name, size, outline)
	local fs = f:CreateFontString(nil, "OVERLAY", 3)
	fs:SetFont(name, size, outline)
	fs:SetShadowColor(0,0,0,1)
    return fs
end  

local function fixStatusbar(b)
	b:GetStatusBarTexture():SetHorizTile(false)
	b:GetStatusBarTexture():SetVertTile(false)
end
  
local function menu(self)
	dropdown:SetParent(self)
	return ToggleDropDownMenu(1, nil, dropdown, 'cursor', 0, 0)
end
local function init(self)
	local unit = self:GetParent().unit
	local menu, name, id

	if(not unit) then
		return
	end

	if(UnitIsUnit(unit, "player")) then
		menu = "SELF"
	elseif(UnitIsUnit(unit, "vehicle")) then
		menu = "VEHICLE"
	elseif(UnitIsUnit(unit, "pet")) then
		menu = "PET"
	elseif(UnitIsPlayer(unit)) then
		id = UnitInRaid(unit)
		if(id) then
			menu = "RAID_PLAYER"
			name = GetRaidRosterInfo(id)
		elseif(UnitInParty(unit)) then
			menu = "PARTY"
		else
			menu = "PLAYER"
		end
	else
		menu = "TARGET"
		name = RAID_TARGET_ICON
	end

	if(menu) then
		UnitPopup_ShowMenu(self, menu, unit, name, id)
	end
end

UIDropDownMenu_Initialize(dropdown, init, 'MENU')

local function PortraitPostUpdate(self, unit) 
	if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
		self:SetCamera(1)
	end	
	self:SetCamDistanceScale(1 - 0.01) --Blizzard bug fix
	self:SetCamDistanceScale(1)
end
  
local function  gen_hpbar(f)
	local s = CreateFrame("StatusBar", nil, f) 
	local h = CreateFrame("Frame", nil, f)
	h:SetAllPoints(s)
	h:SetFrameLevel(9)
	s:SetFrameLevel(4)
	
	local bg = CreateFrame("Frame", nil, s)
	bg:SetFrameLevel(s:GetFrameLevel()+2)
	bg.b = bg:CreateTexture(nil, "BACKGROUND")
	bg.b:SetTexture(DB.Statusbar)
	bg.b:SetAllPoints(bg)
	
    s:SetHeight(f.height)
    s:SetWidth(f.width)
    s:SetPoint("TOPLEFT",0,0)
    s:SetOrientation("HORIZONTAL") 
	
	
	headframe = CreateFrame("Frame", nil, s)
	headframe:SetHeight(f.height+4)
    headframe:SetWidth(f.width)
	headframe:SetPoint("TOP", s)
	headframe:SetFrameLevel(3)
	headframe:CreateShadow()
	
	local line =  h:CreateTexture(nil, "OVERLAY", 1)
	line:SetTexture("Interface\\Buttons\\WHITE8x8")
	line:SetVertexColor(0, 0, 0)
	line:Height(1)
	line:SetWidth(f.width)
	line:SetPoint("BOTTOM", s)
	if not U["ReverseHPbars"] then
		s:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		s:SetStatusBarColor(0,0,0,0)
		S.CreateBack(s)
		s.SetStatusBarColor = function(t, r, g, b)
			S.CreateTop(bg.b, r, g, b)
		end
		s.mark =  h:CreateTexture(nil, "OVERLAY", 1)
		s.mark:SetVertexColor(0, 0, 0, 1)
		s.mark:SetTexture("Interface\\Buttons\\WHITE8x8")
		s.mark:Width(1)
		s.mark:SetPoint("TOPLEFT", s:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		s.mark:SetPoint("BOTTOMLEFT", s:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		bg:SetAlpha(0.65)
	else
		s:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		s.SetStatusBarColor = function(t, r, g, b)
			S.CreateTop(s:GetStatusBarTexture(), r, g, b)
		end
		s:SetAlpha(1)
		bg:SetAlpha(1)
		if U["ClassColor"] then 
			S.CreateTop(bg.b, 0.3, 0.3, 0.3)
		else
			S.CreateTop(bg.b, 0.6, 0.6, 0.6)
		end
	end
	fixStatusbar(s)
    
	if f.mystyle == "player" then
		local ri = h:CreateTexture(nil, 'OVERLAY')
		ri:SetSize(16, 16)
		ri:SetPoint("BOTTOMRIGHT", h, "TOPLEFT", 0, 0)
		f.Resting = ri
		f.Resting:SetTexture("Interface\\AddOns\\SunUI\\media\\UnitFrame\\rested")
		f.Resting:SetVertexColor(138/255, 1, 48/255)
	end
	
	if f.mystyle == "player" and f.mystyle == "target" then
	--LFD
		local LFDRole = h:CreateTexture(nil, "OVERLAY")
		LFDRole:SetSize(16, 16)
		LFDRole:Point("TOPLEFT", f, -15, 10)
		f.LFDRole = LFDRole
		f.LFDRole:SetTexture("Interface\\AddOns\\SunUI\\media\\UnitFrame\\lfd_role")
	end
	local mhpb = CreateFrame("StatusBar", nil, f)
	mhpb:SetFrameLevel(bg:GetFrameLevel()+1)
	mhpb:SetPoint("TOPLEFT", s:GetStatusBarTexture(), "TOPRIGHT")
	mhpb:SetPoint("BOTTOMLEFT", s:GetStatusBarTexture(), "BOTTOMRIGHT")
	mhpb:SetWidth(s:GetWidth())
	mhpb:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	S.CreateMark(mhpb)
	S.CreateTop(mhpb:GetStatusBarTexture(), 0, 1, 0.5)
	local ohpb = CreateFrame("StatusBar", nil, f)
	ohpb:SetFrameLevel(bg:GetFrameLevel()+1)
	ohpb:SetPoint("TOPLEFT", mhpb:GetStatusBarTexture(), "TOPRIGHT")
	ohpb:SetPoint("BOTTOMLEFT", mhpb:GetStatusBarTexture(), "BOTTOMRIGHT")
	ohpb:SetWidth(mhpb:GetWidth())
	ohpb:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	S.CreateMark(ohpb)
	S.CreateTop(ohpb:GetStatusBarTexture(), 0, 1, 0)
	f.HealPrediction = {
		myBar = mhpb,
		otherBar = ohpb,
		maxOverflow = 1,
		PostUpdate = function(frame)
			if frame.myBar:GetValue() == 0 then frame.myBar:SetAlpha(0) else frame.myBar:SetAlpha(1) end
			if frame.otherBar:GetValue() == 0 then frame.otherBar:SetAlpha(0) else frame.otherBar:SetAlpha(1) end
		end
	}
	
	f.Health = s
	f.Health.bd = bg
	f.Health.line = line
	if not U["ReverseHPbars"] then f.Health.mark = s.mark end
	h.shadow = headframe.shadow
	if U["ShowThreatWarn"] and (f.mystyle == "player" or f.mystyle == "pet" or f.mystyle == "party")then
		h:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
		h:SetScript("OnEvent", function(self, event, unit)
			if(unit ~= f.mystyle) then return end
			
			local party = GetNumGroupMembers()
			local raid = GetNumGroupMembers()
			local pet = select(1, HasPetUI())
		
			if party > 0 or raid > 0 or pet == 1 then
				local u = unit or f.mystyle
			
				local status = UnitThreatSituation(u)
				--print(u, status)
				if(status and status > 0) then
					local r, g, b = GetThreatStatusColor(status)
					--print(r,g,b)
					self.shadow:SetBackdropBorderColor(r, g, b)
				else
					self.shadow:SetBackdropBorderColor(0, 0, 0)
				end
			else
				self.shadow:SetBackdropBorderColor(0, 0, 0)
			end
		end)
	end
	if not U["ReverseHPbars"] then
		local isSetHeight = false
		h.time = 0
		h:SetScript("OnUpdate", function(self, t)
			self.time = self.time + t
			if self.time < 0.1 then return end
			local min, max = f.Health:GetMinMaxValues()
			local value = f.Health:GetValue()
			if value == min or value == max then f.Health.mark:Hide() else  f.Health.mark:Show() end
			min, max = f.Power:GetMinMaxValues()
			value = f.Power:GetValue()
			if value == min or value == max then
				f.Power.mark:Hide()
				f.Power.gradient:Hide()
			else
				f.Power.mark:Show()
				f.Power.gradient:Show()
			end
			if value == 0 then
				if not isSetHeight then
					f.Health.line:Hide()
					f.Health:SetHeight(f.height+4)
					isSetHeight = true
				end
			else
				if isSetHeight then
					f.Health.line:Show()
					f.Health:SetHeight(f.height)
					isSetHeight = false
				end
			end
			--print(self.time)
			self.time = 0
		end)
	end
	f.Health.PostUpdate = function()
		f.Health.bd:SetPoint("TOPRIGHT", f.Health)
		f.Health.bd:SetPoint("BOTTOMLEFT", f.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
	end
end

local function gen_portrait(f)
    s = f.Health
	local p = CreateFrame("PlayerModel", nil, f)
	p:SetFrameLevel(s:GetFrameLevel()+1)
	p:SetPoint("TOPLEFT", s, "TOPLEFT", 0, 0)
	p:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT", 0, 0)
	p:SetAlpha(U["Alpha3D"])
	p.PostUpdate = PortraitPostUpdate	
	
    f.Portrait = p
end

local function gen_hpstrings(f, unit)
	local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(10)
    f.tagname = gen_fontstring(h, DB.Font, U["FontSize"]*S.Scale(1), "THINOUTLINE")
	f.taghp = gen_fontstring(h, DB.Font,U["FontSize"]*S.Scale(1), "THINOUTLINE")
	f.tagpp = gen_fontstring(h, DB.Font, (U["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
    f.taginfo = gen_fontstring(h, DB.Font, U["FontSize"]*S.Scale(1), "THINOUTLINE")
	
	if f.mystyle == "player" then
		f.tagpp:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 0, -8)
		f.taghp:SetPoint("LEFT", f.Health, "LEFT", 3, 0)
		f.taginfo:Hide()
		f.tagname:Hide()
	elseif f.mystyle == "target" or f.mystyle == "arena" or f.mystyle == "boss" or f.mystyle == "party" then
		f.taghp:SetPoint("RIGHT", f.Health, "RIGHT", 0, 0)
		f.tagpp:SetPoint("TOPRIGHT", f.Health, "BOTTOMRIGHT", 0, -8)
		f.taginfo:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 0, -8)
		f.tagname:SetPoint("LEFT", f.taginfo, "RIGHT")
	elseif f.mystyle == "arenatarget" or f.mystyle == "partypet" or f.mystyle == "tot" then
		f.tagname:SetPoint("RIGHT", f.Health, "RIGHT", 0, 0)
		f.tagpp:Hide()
		f.taghp:Hide()
		f.taginfo:Hide()
	elseif f.mystyle == "pet" then
		f.tagname:Hide()
		f.tagpp:Hide()
		f.taghp:SetPoint("RIGHT", f.Health, "RIGHT", 3, 0)
		f.taginfo:Hide()
	elseif f.mystyle == "focus" then
		f.tagname:SetPoint("LEFT", f.Health, "LEFT")
		f.taghp:SetPoint("RIGHT", f.Health, "RIGHT", 3, 0)
	end
	
	if f.mystyle == "arenatarget" or f.mystyle == "partypet" then
		f:Tag(f.tagname, '[sunui:color][sunui:shortname]')
	else
		f:Tag(f.tagname, '[sunui:color][sunui:longname]')
	end
	if f.mystyle == "target" or f.mystyle == "player" or f.mystyle == "party" or f.mystyle == "arena" then
		f:Tag(f.taghp, '[sunui:hp]')
	else
		f:Tag(f.taghp, '[perhp]'.."%")
	end
	if class == "DRUID" then
		f:Tag(f.tagpp, '[sunui:druidpower] [sunui:pp]')
    else
		f:Tag(f.tagpp, '[sunui:pp]')
    end
    f:Tag(f.taginfo, '[sunui:info]')
	f.tagpp.frequentUpdates = 0.3 -- test it!!1
	
	if U["TagFadeIn"] then
		local list = {f.tagname,f.taghp,f.tagpp,f.taginfo}
		local Event = CreateFrame("Frame")
		Event:RegisterEvent("PLAYER_REGEN_DISABLED")
		Event:RegisterEvent("PLAYER_REGEN_ENABLED")
		Event:RegisterEvent("PLAYER_ENTERING_WORLD")
		Event:SetScript("OnEvent", function(self, event, ...)
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			if event == "PLAYER_REGEN_DISABLED" then
				for k,v in pairs(list) do
					UIFrameFadeIn(v, 0.5,v:GetAlpha(), 1)
				end
			elseif event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD"then
				for k,v in pairs(list) do
					UIFrameFadeOut(v, 0.5,v:GetAlpha(), 0)
				end
			end
		end)
		f:HookScript("OnEnter", function()
			UnitFrame_OnEnter(f)
			 f.Highlight:Show()
			if not UnitAffectingCombat("player") then
				for k,v in pairs(list) do
					UIFrameFadeIn(v, 0.5,v:GetAlpha(), 1)
				end
			end
		end)
		f:HookScript("OnLeave", function()
			UnitFrame_OnLeave(f)
			f.Highlight:Hide()
			if not UnitAffectingCombat("player") then
				for k,v in pairs(list) do
					UIFrameFadeOut(v, 0.5,v:GetAlpha(), 0)
				end
			end
		end)
	end
end

local function gen_ppbar(f)
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
    fixStatusbar(s)
    s:SetHeight(4)
	s:SetFrameLevel(4)
    s:SetWidth(f.width)
    s:SetPoint("TOPLEFT",f,"BOTTOMLEFT")
	s:SetAlpha(0.9)
    if f.mystyle == "partypet" or f.mystyle == "arenatarget" then
		s:Hide()
    end
	if not U["ReverseHPbars"] then 
		s.mark =  s:CreateTexture(nil, "OVERLAY", 1)
		s.mark:SetVertexColor(0, 0, 0, 1)
		s.mark:SetTexture("Interface\\Buttons\\WHITE8x8")
		s.mark:Width(1)
		s.mark:SetPoint("TOPLEFT", s:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		s.mark:SetPoint("BOTTOMLEFT", s:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		S.CreateBack(s)
	else
		local bg = CreateFrame("Frame", nil, s)
		bg:SetFrameLevel(s:GetFrameLevel()-1)
		bg:SetAllPoints(s)
		local b = bg:CreateTexture(nil, "BACKGROUND")
		b:SetTexture(DB.Statusbar)
		b:SetAllPoints(s)
		S.CreateTop(b, 0.15, 0.15, 0.15)
	end
	local sbg = s:GetStatusBarTexture()
    f.Power = s
	f.Power.PostUpdate = function() 
		local r,g,b = s:GetStatusBarColor()
		S.CreateTop(sbg, r, g, b)
	end
end

local function gen_ppstrings(f, unit)
end

local function gen_castbar(f)
    local s = CreateFrame("StatusBar", "oUF_SunUICastbar"..f.mystyle, f)
    s:SetSize(f.width-(f.height/1.5+4),f.height/1.5)
    s:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
    s:SetStatusBarColor(.3, .45, .65,1)
    s:SetFrameLevel(11)
    --color
    s.CastingColor = {.3, .45, .65}
    s.CompleteColor = {0.12, 0.86, 0.15}
    s.FailColor = {1.0, 0.09, 0}
    s.ChannelingColor = {.3, .45, .65}
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
	h:SetAllPoints()
	h:CreateShadow()
	S.CreateBack(h)
	--spark
	local sp
    --spell text
    local txt = gen_fontstring(s, DB.Font, (U["FontSize"]+1)*S.Scale(1), "THINOUTLINE")
   
	txt:SetPoint("LEFT", 2, 0)

    txt:SetJustifyH("LEFT")
	
    --time
    local t = gen_fontstring(s, DB.Font, (U["FontSize"]+1)*S.Scale(1), "THINOUTLINE")
   
	t:SetPoint("RIGHT", -2, 0)
    txt:SetPoint("RIGHT", t, "LEFT", -5, 0)
    --icon
    local i = s:CreateTexture(nil, "ARTWORK")
    --i:SetSize(s:GetHeight()+4,s:GetHeight()+4)
	i:SetSize(s:GetHeight(),s:GetHeight())
    i:Point("BOTTOMRIGHT", s, "BOTTOMLEFT", -6, 0)
    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	S.CreateShadow(s, i)
	
	if f.mystyle ~= "pet" and f.mystyle ~= "boss" then
		s.SetStatusBarColor = function(t, r, g, b)
			S.CreateTop(s:GetStatusBarTexture(), r, g, b)
		end
		sp =  s:CreateTexture(nil, "OVERLAY")
		sp:SetVertexColor(0, 0, 0, 1)
		sp:SetTexture("Interface\\AddOns\\SunUI\\media\\mark")
		sp:SetPoint("TOPLEFT", s:GetStatusBarTexture(), "TOPRIGHT", -10, 0)
		sp:SetPoint("BOTTOMRIGHT", s:GetStatusBarTexture(), "BOTTOMRIGHT", 10, 0)
	end
    if f.mystyle == "focus" and not U["focusCBuserplaced"] then
		s:SetSize(U["FocusCastBarWidth"],U["FocusCastBarHeight"])
		MoveHandle.Castbarfouce = S.MakeMoveHandle(s, L["焦点施法条"], "FocusCastbar")
		--sp:SetHeight(s:GetHeight()*2.5)
    elseif f.mystyle == "pet" or f.mystyle == "boss" then
		s:SetAllPoints(f.Health)
		s:SetScale(f:GetScale())
		i:SetSize(f.height,f.height)
		if f.mystyle == "pet" then
			i:SetPoint("TOPRIGHT", f.Health, "TOPLEFT", -5, 0)
		else
			i:SetPoint("BOTTOMRIGHT", f.Health, "TOPLEFT", -5, 5)
		end
		s:SetStatusBarColor(0, 0, 0, 0)
		s.SetStatusBarColor = function() end
		sp = s:CreateTexture(nil, "OVERLAY")
		sp:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
		sp:SetBlendMode("ADD")
		sp:SetAlpha(.8)
		sp:SetPoint("TOPLEFT", s:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
		sp:SetPoint("BOTTOMRIGHT", s:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)
		txt:Hide() t:Hide() h:Hide()
    elseif f.mystyle == "arena" then
		s:SetSize(f.width-(f.height/1.4+4),f.height/1.4)
		s:Point("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
		i:Point("RIGHT", s, "LEFT", -4, 0)
		i:SetSize(s:GetHeight(),s:GetHeight())
    elseif f.mystyle == "player" then
		if not U["playerCBuserplaced"] then
			s:SetSize(U["PlayerCastBarWidth"],U["PlayerCastBarHeight"])
			MoveHandle.Castbarplayer = S.MakeMoveHandle(s, L["玩家施法条"], "PlayerCastbar")
			i:SetSize(s:GetHeight(),s:GetHeight())
		else
			s:Point("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
		end
		--latency only for player unit
		local z = s:CreateTexture(nil, "OVERLAY", 3)
		z:SetBlendMode("ADD")
		z:SetWidth(1) -- it should never fill the entire castbar when GetNetStats() returns 0
		z:SetPoint("TOPRIGHT")
		z:SetPoint("BOTTOMRIGHT")
		S.CreateTop(z, .8,.31,.45)
		if UnitInVehicle("player") then z:Hide() end
		s.SafeZone = z
  
		local l = gen_fontstring(s, DB.Font, U["FontSize"]*S.Scale(1), "THINOUTLINE")
		l:SetPoint("RIGHT", 0, -s:GetHeight()/2-5)
		l:SetJustifyH("RIGHT")
		l:SetTextColor(.8,.31,.45)
		s.Lag = l
		--f:RegisterEvent("UNIT_SPELLCAST_START", cast.OnCastSent)
		f:RegisterEvent("UNIT_SPELLCAST_SENT", cast.OnCastSent)
	elseif f.mystyle == "target" and not U["targetCBuserplaced"] then
		s:SetSize(U["TargetCastBarWidth"],U["TargetCastBarHeight"])
		MoveHandle.Castbartarget = S.MakeMoveHandle(s, L["目标施法条"], "TargetCastbar")
		i:SetSize(s:GetHeight(),s:GetHeight())
	else
		s:SetPoint("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
		i:SetPoint("RIGHT", s, "LEFT", -3, 0)
    end
	local sbg =  s:GetStatusBarTexture()
	s.bd = sbg
	s.OnUpdate = cast.OnCastbarUpdate
	s.PostCastStart = cast.PostCastStart
	s.PostChannelStart = cast.PostCastStart
	s.PostCastStop = cast.PostCastStop
	s.PostChannelStop = cast.PostChannelStop
	s.PostCastFailed = cast.PostCastFailed
	s.PostCastInterrupted = cast.PostCastFailed
	
    f.Castbar = s
    f.Castbar.Text = txt
    f.Castbar.Time = t
    f.Castbar.Icon = i
    f.Castbar.Spark = sp
	if (f.mystyle == "target" and U["targetCBuserplaced"]) then
		s:HookScript("OnShow", function()
			if f.mystyle == "target" then
				f.tagpp:Hide()
				f.taginfo:Hide()
				f.tagname:Hide()
			end
		end)
		s:HookScript("OnHide", function()
			if f.mystyle == "target" then
				f.tagpp:Show()
				f.taginfo:Show()
				f.tagname:Show()
			end
		end)
	end
	
	if (f.mystyle == "player" and U["playerCBuserplaced"]) then
		s:HookScript("OnShow", function()
			if f.mystyle == "player" then
				f.tagpp:Hide()
				f.taghp:Hide()
			end
		end)
		s:HookScript("OnHide", function()
			if f.mystyle == "player" then
				f.tagpp:Show()
				f.taghp:Show()
			end
		end)
	end
end

local function FormatTime(s)
    local day, hour, minute = 86400, 3600, 60
    if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
    elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
    elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
    end
    return format("%d", s)
end
local function CreateAuraTimer(self,elapsed)
    if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		local w = self:GetWidth()
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 and w > 10 then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				if self.timeLeft < 5 then
					self.remaining:SetTextColor(1, .3, .2)
				else
					self.remaining:SetTextColor(.9, .7, .2)
				end
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
    end
end
local function PostUpdateIcon(self, unit, icon, index)
  local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)
    -- Debuff desaturation
	if(unit == "target") then	
		if (unitCaster == "player" or unitCaster == "vehicle") then
			icon.icon:SetDesaturated(false)                 
		elseif(not UnitPlayerControlled(unit)) then -- If Unit is Player Controlled don"t desaturate debuffs
			icon:SetBackdropColor(0, 0, 0)
			icon.overlay:SetVertexColor(0.3, 0.3, 0.3)      
			icon.icon:SetDesaturated(true)  
		end
	end
    -- Creating aura timers
	if duration and duration > 0 then
		icon.remaining:Show() 
		icon.overlay:Show()		
		icon.timeLeft = expirationTime	
		icon:SetScript("OnUpdate", CreateAuraTimer)			
	else
		icon.remaining:Hide()
		icon.overlay:Hide()
		icon.timeLeft = math.huge
		icon:SetScript("OnUpdate", nil)
	end
	icon.first = true
end
-- creating aura icons
local function PostCreateIcon(self, button)
    button.cd:SetReverse()
    button.cd.noOCC = true
    button.cd.noCooldownCount = true
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    button.icon:SetDrawLayer("BACKGROUND")
    --count
	local h3 = CreateFrame("Frame", nil, button)
    h3:SetAllPoints(button)
    h3:SetFrameLevel(10)
	button.count = gen_fontstring(h3, DB.Font, (U["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
    button.count:ClearAllPoints()
    button.count:SetJustifyH("RIGHT")
    button.count:Point("BOTTOMRIGHT", 2, -2)
    button.count:SetTextColor(1,1,1)
    --another helper frame for our fontstring to overlap the cd frame
    local h2 = CreateFrame("Frame", nil, button)
    h2:SetAllPoints(button)
    h2:SetFrameLevel(10)
    button.remaining = gen_fontstring(h2, DB.Font, (U["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
    button.remaining:SetPoint("TOPLEFT", -2, 4)

    button.overlay:SetTexture("Interface\\Addons\\SunUI\\media\\icon_clean")
    button.overlay:Point("TOPLEFT", button, "TOPLEFT", -1, 1)
    button.overlay:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    button.overlay:SetTexCoord(0.04, 0.96, 0.04, 0.96)
    button.overlay.Hide = function(self) self:SetVertexColor(0, 0, 0) end
end

--auras for certain frames
local function createAuras(f)
    a = CreateFrame('Frame', nil, f)
	if f.mystyle~="player" then 
		a:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, -18)
	else
		a:SetPoint('TOPLEFT', f, 'BOTTOMLEFT', 0, 15)
	end
    a['growth-x'] = 'RIGHT'
    a['growth-y'] = 'UP' 
    a.initialAnchor = 'TOPLEFT'
    a.gap = false
    a.spacing = 3
    a.size = 18
	a.showStealableBuffs = true
    a.showDebuffType = true
    if f.mystyle=="target" then
		a:SetHeight((a.size+a.spacing)*2)
		a:SetWidth((a.size+a.spacing)*8)
		a.numBuffs = 6 
		a.numDebuffs = 10
	elseif f.mystyle=="player" and U["PlayerBuff"]==3 then
		a.gap = false
		a['growth-x'] = 'RIGHT'
		a['growth-y'] = 'UP' 
		a:SetHeight((a.size+a.spacing)*2)
		a:SetWidth((a.size+a.spacing)*8)
		a.initialAnchor = 'BOTTOMLEFT'
		a.numBuffs = 8 
		a.numDebuffs = 8
		a:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, 15)
    elseif f.mystyle=="focus" then
		a:SetHeight((a.size+a.spacing)*2)
		a:SetWidth((a.size+a.spacing)*4)
		a.numBuffs = 10
		a.numDebuffs = 16
    end
    a.PostCreateIcon = PostCreateIcon
    a.PostUpdateIcon = PostUpdateIcon
	f.Auras = a
end
  -- buffs
local function createBuffs(f)
    b = CreateFrame("Frame", nil, f)
    b.initialAnchor = "TOPLEFT"
    b["growth-y"] = "DOWN"
    b.num = 8
    b.size = 16
    b.spacing = 3
	b.gap = false
    b:SetHeight((b.size+b.spacing)*2)
    b:SetWidth((b.size+b.spacing)*12)
    if f.mystyle=="tot" then
		b.initialAnchor = "TOPRIGHT"
		b:SetPoint("TOPRIGHT", f, "TOPLEFT", -b.spacing, -2)
		b["growth-x"] = "LEFT"
    elseif f.mystyle=="pet" then
		b:SetPoint("TOPLEFT", f, "TOPRIGHT", b.spacing, -2)
    elseif f.mystyle=="arena" then
		b.showBuffType = true
		b:SetPoint("TOPLEFT", f, "TOPRIGHT", b.spacing, -2)
		b.size = 16
		b.num = 5
		b:SetWidth((b.size+b.spacing)*4)
	elseif f.mystyle=="boss" then
		b["growth-x"] = "LEFT"
		b['growth-y'] = 'DOWN'
		b.initialAnchor = "RIGHT"
		b.showBuffType = true
		b:SetPoint("RIGHT", f, "LEFT", -2, 0)
		b.size = 16
		b.num = 4
		b:SetWidth((b.size+b.spacing)*4)
    elseif f.mystyle=='party' then
		b["growth-x"] = "RIGHT"
		b['growth-y'] = 'UP'
		b.initialAnchor = "BOTTOMLEFT"
		b.showBuffType = true
		b:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, b.spacing)
		b.size = 14
		b.num = 8
	elseif f.mystyle=="player" and U["PlayerBuff"]==2 then
		b['growth-x'] = 'RIGHT'
		b['growth-y'] = 'UP' 
		b.initialAnchor = 'BOTTOMLEFT'
		b.num = 8
		b.size = 16
		b:SetHeight((b.size+b.spacing)*2)
		b:SetWidth((b.size+b.spacing)*8)
		b:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 15)
    end
    b.PostCreateIcon = PostCreateIcon
    b.PostUpdateIcon = PostUpdateIcon
    f.Buffs = b
end
  -- debuffs
local function createDebuffs(f)
    d = CreateFrame("Frame", nil, f)
    d.initialAnchor = "TOPRIGHT"
	d['growth-x'] = 'RIGHT'
    d["growth-y"] = "DOWN"
    d.num = 8
    d.size = 16
    d.spacing = 3
	d.gap = false
    d:SetHeight((d.size+d.spacing)*2)
    d:SetWidth((d.size+d.spacing)*5)
	d.showStealableBuffs = true
	d.showDebuffType = true
    if f.mystyle=="tot" then
		d:SetPoint("TOPLEFT", f, "TOPRIGHT", d.spacing, -2)
		d.initialAnchor = "TOPLEFT"
    elseif f.mystyle=="pet" then
		d.initialAnchor = "BOTTOMLEFT"
		d:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, d.spacing)
		d["growth-x"] = "RIGHT"
		d["growth-y"] = "UP"
    elseif f.mystyle=="arena" then
		d.showDebuffType = false
		d.initialAnchor = "TOPLEFT"
		d.num = 4
		d.size = 16
		d:SetPoint('TOPLEFT', f, 'TOPRIGHT', 2, 0)
		d:SetWidth((d.size+d.spacing)*4)
    elseif f.mystyle=='party' then
		d:SetPoint("TOPLEFT", f, "TOPRIGHT", d.spacing, 0)
		d.initialAnchor = "TOPLEFT"
		d.num = 8
		d.size = 16
		d["growth-x"] = "RIGHT"
		d:SetWidth((d.size+d.spacing)*4)
	elseif f.mystyle=="player" and U["PlayerBuff"]==1 then
		d['growth-x'] = 'RIGHT'
		d['growth-y'] = 'UP' 
		d.initialAnchor = 'BOTTOMLEFT'
		d.num = 8
		d.size = 16
		d:SetHeight((d.size+d.spacing)*2)
		d:SetWidth((d.size+d.spacing)*8)
		d:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 15)
	elseif f.mystyle=="focus" then
		d:SetPoint("RIGHT", f, "LEFT", -d.spacing, 0)
		d["growth-x"] = "LEFT"
		d['growth-y'] = 'DOWN' 
		d.initialAnchor = 'RIGHT'
		d.num = 5
	elseif f.mystyle=="pet" then
		d['growth-x'] = 'RIGHT'
		d['growth-y'] = 'UP' 
		d.initialAnchor = 'BOTTOMLEFT'
		d.num = 8
		d.size = 16
		d:SetHeight((d.size+d.spacing)*2)
		d:SetWidth((d.size+d.spacing)*8)
		d:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 15)
	elseif f.mystyle=="boss" then
		d['growth-x'] = 'RIGHT'
		d['growth-y'] = 'UP' 
		d.initialAnchor = 'BOTTOMLEFT'
		d.num = 5
		d.size = 16
		d:SetHeight((d.size+d.spacing)*2)
		d:SetWidth((d.size+d.spacing)*8)
		d:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 5)
    end
	d.PostCreateIcon = PostCreateIcon
	d.PostUpdateIcon = PostUpdateIcon
	f.Debuffs = d
end
--SHAMAN图腾
local function gen_totembar(f)
	if  class ~= "SHAMAN" then return end
	local bars = {}
	bars.Destroy = false
	for i = 1, 4 do
		bars[i] = CreateFrame("StatusBar", nil, f)
		bars[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		bars[i]:SetWidth((f.width-space*(4-1))/4)
		bars[i]:SetHeight(f.height/4)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)

		bars[i]:CreateShadow()
		S.CreateBack(bars[i])
		S.CreateMark(bars[i])
		bars[i]:SetMinMaxValues(0, 1)
	end
	bars[2]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	bars[1]:SetPoint("LEFT", bars[2], "RIGHT", space, 0)
	bars[3]:SetPoint("LEFT", bars[1], "RIGHT", space, 0)
	bars[4]:SetPoint("LEFT", bars[3], "RIGHT", space, 0)
	
	f.TotemBar = bars
end
----圣能
local function gen_classpower(f)  
	if  class ~= "PALADIN" and class ~= "DEATHKNIGHT" then return end
	-- Runes, Shards, HolyPower
	local count
	if class == "DEATHKNIGHT" then 
		count = 6
	elseif class == "PALADIN" then
		count = 5
	end
	local bars = CreateFrame("Frame", nil, f)
	bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	bars:SetSize(f.width, f.height/5)
	for i = 1, count do
		bars[i] =CreateFrame("StatusBar", nil, bars)
		bars[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
		bars[i]:SetSize((f.width-space*(count-1))/count, f.height/5)
		if (i == 1) then
			bars[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", space, 0)
		end
		if class == "PALADIN" then
			bars[i]:SetStatusBarColor(0.9, 0.9, 0)
		end
		bars[i]:CreateShadow()
	end
	if class == "DEATHKNIGHT" then
		f.Runes = bars
	elseif class == "PALADIN" then
		f.HolyPower = bars
	end
end
--术士这该死的职业
local function warlockpower(f)
	if class ~= "WARLOCK" then return end
	local bars = CreateFrame("Frame", nil, f)
	bars:SetWidth(f.width)
	bars:SetHeight(f.height/3)
	bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	for i = 1, 4 do
		bars[i] = CreateFrame("StatusBar", nil, f)
		bars[i]:SetHeight(f.height/3)
		bars[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		S.CreateBack(bars[i])
		bars[i]:CreateShadow()
		local s = bars[i]:GetStatusBarTexture()
		bars[i].SetStatusBarColor = function(t, r, g, b)
			S.CreateTop(s, r, g, b)
		end
		if i == 1 then
			S.CreateMark(bars[i])
			bars[i]:SetPoint("LEFT", bars)
			bars[i]:SetWidth((f.width-space*(4-1))/4)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", space, 0)
			bars[i]:SetWidth((f.width-space*(4-1))/4)
		end
	end
	f.WarlockSpecBars = bars
end

--Monk harmony bar
local function addHarmony(f)
	if class ~= "MONK" then return end
	local chibar = CreateFrame("Frame",nil,f)
	chibar:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	chibar:SetSize((f.width-4*space)/5, f.height/4)
	for i=1,5 do
		chibar[i] = CreateFrame("StatusBar",nil,chibar)
		chibar[i]:SetSize((f.width-4*space)/5, f.height/4)
		chibar[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		local s = chibar[i]:GetStatusBarTexture()
		S.CreateTop(s, 0.0, 1.00 , 0.59)
		chibar[i]:CreateShadow()
		if i==1 then
			chibar[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
		else
			chibar[i]:SetPoint("LEFT", chibar[i-1], "RIGHT", space, 0)
		end
		chibar[i]:Hide()
	end
	chibar:RegisterEvent("PLAYER_ENTERING_WORLD")
	chibar:RegisterEvent("UNIT_POWER")
	chibar:RegisterEvent("UNIT_DISPLAYPOWER")
	chibar:SetScript("OnEvent",function()
		local chinum = UnitPower("player",SPELL_POWER_CHI)
		local chimax = UnitPowerMax("player",SPELL_POWER_CHI)
		if chinum ~= chimax then
			if chimax == 4 then
				chibar[5]:Hide()
				for i = 1,4 do
					chibar[i]:SetWidth((f.width-3*space)/4)
				end
			elseif chimax == 5 then
				chibar[5]:Show()
				for i = 1,5 do
					chibar[i]:SetWidth((f.width-4*space)/5)
				end
			end
		end
		for i = 1,chimax do
			if i <= chinum then
				chibar[i]:Show()
			else
				chibar[i]:Hide()
			end
		end
	end)
end

--Shadow Orbs bar
local function genShadowOrbs(f)
	if class ~= "PRIEST" then return end
	
	local ShadowOrbs = CreateFrame("Frame", nil, f)
	ShadowOrbs:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	ShadowOrbs:SetSize((f.width-8)/5, f.height/4)

	local maxShadowOrbs = UnitPowerMax('player', SPELL_POWER_SHADOW_ORBS)
	
	for i = 1,maxShadowOrbs do
		ShadowOrbs[i] = CreateFrame("StatusBar", nil, f)
		ShadowOrbs[i]:SetSize((f.width-space*(maxShadowOrbs-1))/maxShadowOrbs, f.height/4)
		ShadowOrbs[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		local s = ShadowOrbs[i]:GetStatusBarTexture()
		S.CreateTop(s, .86,.22,1)
		ShadowOrbs[i]:CreateShadow()
		if (i == 1) then
			ShadowOrbs[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
		else
			ShadowOrbs[i]:SetPoint("LEFT", ShadowOrbs[i-1], "RIGHT", space, 0)
		end
	end
	ShadowOrbs:RegisterEvent("PLAYER_ENTERING_WORLD")
	ShadowOrbs:RegisterEvent("UNIT_POWER")
	ShadowOrbs:RegisterEvent("UNIT_DISPLAYPOWER")
	ShadowOrbs:SetScript("OnEvent",function()
		local numShadowOrbs = UnitPower('player', SPELL_POWER_SHADOW_ORBS)
		for i = 1,maxShadowOrbs do
			if i <= numShadowOrbs then
				ShadowOrbs[i]:Show()
			else
				ShadowOrbs[i]:Hide()
			end
		end
	end)
end
--奥法的4个东西
local function genMage(f)
	if class ~= "MAGE" then return end
	
	local bars = CreateFrame("Frame", nil, f)
	bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	bars:SetSize(f.width, f.height/4)
	for i = 1,4 do
		bars[i] = CreateFrame("StatusBar", nil, f)
		bars[i]:SetSize((f.width-space*(4-1))/4, f.height/4)
		bars[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		local s = bars[i]:GetStatusBarTexture()
		S.CreateTop(s, 0.41, 0.8, 0.94)
		bars[i]:CreateShadow()
		bars[i]:Hide()
		if (i == 1) then
			bars[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", space, 0)
		end
	end
	bars:RegisterEvent("UNIT_AURA")
	bars:SetScript("OnEvent",function(self, event, unit)
		if unit ~= "player" then return end
		local num = select(4, UnitDebuff("player", GetSpellInfo(36032)))
		if num == nil then num = 0 end
		for i = 1,4 do
			if i <= num then
				bars[i]:Show()
			else
				bars[i]:Hide()
			end
		end
	end)
end
  --gen eclipse bar
local function gen_EclipseBar(f)
	if class ~= "DRUID" then return end
	local eb = CreateFrame('Frame', nil, f)
	eb:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, S.Scale(2))
	eb:SetSize(f.width, 6)
	eb:CreateShadow()
	local lb = CreateFrame('StatusBar', nil, eb)
	lb:SetPoint('LEFT', eb, 'LEFT')
	lb:SetSize(f.width, 6)
	lb:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	local s = lb:GetStatusBarTexture()
	S.CreateMark(lb)
	S.CreateTop(s, 0.27, 0.47, 0.74)
	S.SmoothBar(lb)
	eb.LunarBar = lb
	local sb = CreateFrame('StatusBar', nil, eb)
	sb:SetPoint('LEFT', lb:GetStatusBarTexture(), 'RIGHT', 0, 0)
	sb:SetSize(f.width, 6)
	sb:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	local s2 = sb:GetStatusBarTexture()
	S.CreateTop(s2, 0.9, 0.6, 0.3)
	eb.SolarBar = sb
  	local h = CreateFrame("Frame", nil, eb)
	h:SetAllPoints(eb)
	h:SetFrameLevel(eb:GetFrameLevel()+1)
	f.EclipseBar = eb
	local ebInd = gen_fontstring(h, DB.Font, (U["FontSize"]+4)*S.Scale(1), "THINOUTLINE")
	ebInd:SetPoint('CENTER', eb, 'CENTER', 0, 0)
	f.EclipseBar.PostDirectionChange = function(element, unit)
		local dir = GetEclipseDirection()
		if dir=="sun" then
			ebInd:SetText("|cff4478BC>>>|r")
		elseif dir=="moon" then
			ebInd:SetText("|cffE5994C<<<|r")
		end
	end
end
  --gen combo points
local function gen_cp(f)
	if class ~= "ROGUE" and class ~= "DRUID" then return end
	local colors = {
		[1] = {["r"] = 0.9, ["g"] = 0.9, ["b"] = 0},
		[2] = {["r"] = 0.9, ["g"] = 0.9, ["b"] = 0},
		[3] = {["r"] = 0.9, ["g"] = 0.9, ["b"] = 0},
		[4] = {["r"] = 0.9, ["g"] = 0.9, ["b"] = 0},
		[5] = {["r"] = 1, ["g"] = 0.2, ["b"] = 0.2},}
	local bars = CreateFrame("Frame", nil, f)
	bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	bars:SetFrameLevel(f:GetFrameLevel()+1)
	bars:SetSize((f.width-8)/5, f.height/4)
	for i = 1, 5 do
		bars[i] =CreateFrame("StatusBar", nil, bars)
		bars[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		bars[i]:CreateShadow()
		local s = bars[i]:GetStatusBarTexture()
		bars[i]:SetSize((f.width-space*4)/5, f.height/4)
		if (i == 1) then
			bars[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", space, 0)
		end
		S.CreateTop(s, colors[i].r, colors[i].g, colors[i].b)
		i=i-1
	end
	bars[1]:SetScript("OnShow", function()
		f.Auras:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, -10)
	end)
	bars[1]:SetScript("OnHide", function()
		f.Auras:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, -18)
	end)
	f.CPoints = bars
end 

  --gen combat and leader icons
local function gen_InfoIcons(f)
    local h = CreateFrame("Frame",nil,f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(10)
    --combat icon
    if f.mystyle == 'player' then
		f.Combat = h:CreateTexture(nil, 'OVERLAY')
		f.Combat:SetSize(20,20)
		f.Combat:SetPoint('TOPRIGHT', 3, 9)
		f.Combat:SetTexture("Interface\\AddOns\\SunUI\\media\\UnitFrame\\combat")
		f.Combat:SetVertexColor(0.6, 0, 0)
    end
	
    --Leader icon
    li = h:CreateTexture(nil, "OVERLAY")
    li:SetPoint("TOPLEFT", f, 0, 6)
    li:SetSize(12,12)
    f.Leader = li
    --Assist icon
    ai = h:CreateTexture(nil, "OVERLAY")
    ai:SetPoint("TOPLEFT", f, 0, 6)
    ai:SetSize(12,12)
    f.Assistant = ai
    --ML icon
    local ml = h:CreateTexture(nil, 'OVERLAY')
    ml:SetSize(12,12)
    ml:SetPoint('LEFT', f.Leader, 'RIGHT')
    f.MasterLooter = ml
	f.MasterLooter:SetTexture("Interface\\AddOns\\SunUI\\media\\UnitFrame\\looter")
	f.MasterLooter:SetVertexColor(0.8, 0.8, 0.8)
	 --PVP icon
    local pvp = h:CreateTexture(nil, 'OVERLAY')
    pvp:SetSize(25, 25)
    pvp:SetPoint("CENTER", f, "TOPRIGHT", 3, -3)
    f.PvP = pvp
	 --QuestIcon icon
	if f.mystyle == "target" then
		local QuestIcon = h:CreateTexture(nil, 'OVERLAY')
		QuestIcon:SetSize(24, 24)
		QuestIcon:SetPoint('TOPLEFT', f, 'TOPRIGHT', -3, 8)
		QuestIcon:SetTexture("Interface\\AddOns\\SunUI\\media\\UnitFrame\\quest")
		QuestIcon:SetVertexColor(1.0, 0.82, 0)
		f.QuestIcon = QuestIcon
	end 
end
  --gen raid mark icons
local function gen_RaidMark(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
    h:SetAlpha(1)
    local ri = h:CreateTexture(nil,'OVERLAY',h)
    ri:SetPoint("CENTER", f, "CENTER", 0, 0)
    ri:SetSize(S.Scale(20), S.Scale(20))
	if f.mystyle == "tot" then
		ri:SetPoint("LEFT", f, "LEFT", 3, 0)
	elseif f.mystyle == "player" then
		ri:SetPoint("BOTTOMLEFT", f, "TOPRIGHT", 3, 0)
	elseif f.mystyle == "target" then
		ri:SetPoint("BOTTOMRIGHT", f, "TOPLEFT", -3, 0)
	end
    f.RaidIcon = ri
end
  --gen hilight texture
local function gen_highlight(f)
    local hl = f.Health:CreateTexture(nil, "OVERLAY")
    hl:SetAllPoints(headframe)
    hl:SetTexture(DB.Solid)
    hl:SetVertexColor(.5,.5,.5,.2)
    hl:SetBlendMode("ADD")
    hl:Hide()
    f.Highlight = hl
end
  --gen trinket and aura tracker for arena frames
local function UpdateAuraTracker(self, elapsed)
	if self.active then
		self.timeleft = self.timeleft - elapsed
		if self.timeleft <= 5 then
			self.text:SetTextColor(1, .3, .2)
		else
			self.text:SetTextColor(.9, .7, .2)
		end
		if self.timeleft <= 0 then
			self.icon:SetTexture('')
			self.text:SetText('')
		end	
		self.text:SetFormattedText('%.1f', self.timeleft)
	end
end
local function gen_arenatracker(f)
    t = CreateFrame("Frame", nil, f)
    t:SetSize(21,21)
	t:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", 0, 3)
    t:SetFrameLevel(30)
    t:SetAlpha(1)
    t.trinketUseAnnounce = true
	t:CreateShadow()
    f.Trinket = t
	at = CreateFrame('Frame', nil, f)
	at:SetAllPoints(f.Trinket)
	at:SetFrameStrata('HIGH')
	at.icon = at:CreateTexture(nil, 'ARTWORK')
	at.icon:SetAllPoints(at)
	at.icon:SetTexCoord(0.07,0.93,0.07,0.93)
	at.text = gen_fontstring(at, DB.Font, (U["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
	at.text:SetPoint('CENTER', at, 0, 0)
	at:SetScript('OnUpdate', UpdateAuraTracker)
	f.AuraTracker = at
end
  --gen current target indicator
local function gen_targeticon(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(10)
    local ti = gen_fontstring(h, DB.Font, U["FontSize"], "THINOUTLINE")
    ti:SetPoint("LEFT", f.Health, "BOTTOMLEFT",-5,0)
    ti:SetJustifyH("LEFT")
    f:Tag(ti, '[sunui:targeticon]')
end
  -- 复仇
local function gen_swing_timer(f)
	if U["EnableVengeanceBar"] then
		local VengeanceBar = CreateFrame("Statusbar", "VengeanceBar", f)
		VengeanceBar:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		VengeanceBar:SetPoint("TOPLEFT", f.Health, "TOPRIGHT", 5, 0)
		VengeanceBar:SetSize(4, f.Health:GetHeight()+4)
		VengeanceBar:CreateShadow()
		S.CreateBack(VengeanceBar, true)
		S.SmoothBar(VengeanceBar)
		VengeanceBar:SetOrientation("VERTICAL")
		VengeanceBar.shadow:SetBackdropColor(.12, .12, .12, 1)
		VengeanceBar.Text = VengeanceBar:CreateFontString(nil, "OVERLAY")
		VengeanceBar.Text:SetPoint("CENTER")
		VengeanceBar.Text:SetFont(DB.Font, U["FontSize"], "THINOUTLINE")
		VengeanceBar.Text:Hide()
		VengeanceBar.SetStatusBarColor = function() end
		f.Vengeance = VengeanceBar
		
		VengeanceBar:SetScript("OnValueChanged", function(self, value)
			local _, max = VengeanceBar:GetMinMaxValues()
			r, g, b = oUF.ColorGradient(value, max, unpack(oUF.colors.smooth))
			local texture = self:GetStatusBarTexture()
			S.CreateTop(texture, r, g, b, true)
		end)
	end
end
   -- 仇恨
local function gen_threat(f)
	if U["EnableThreat"] == false then return end
	local ThreatBar = CreateFrame("Statusbar", nil, f)
	ThreatBar:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	ThreatBar:SetPoint("TOPRIGHT", f.Health, "TOPLEFT", -5, 0)
	ThreatBar:SetSize(4, f.Health:GetHeight()+4)
	ThreatBar:CreateShadow()
	S.CreateBack(ThreatBar, true)
	ThreatBar:SetOrientation("VERTICAL")
	ThreatBar:SetMinMaxValues(0, 100)
	S.SmoothBar(ThreatBar)
	local function OnEvent(self, event, ...)
		
		local party = GetNumGroupMembers()
		local raid = GetNumGroupMembers()
		local pet = select(1, HasPetUI())
		if event == "PLAYER_ENTERING_WORLD" then
			self:Hide()
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		elseif event == "PLAYER_REGEN_ENABLED" then
			self:Hide()
		elseif event == "PLAYER_REGEN_DISABLED" then
			if party > 0 or raid > 0 or pet == 1 then
				self:Show()
			else
				self:Hide()
			end
		else
			if (InCombatLockdown()) and (party > 0 or raid > 0 or pet == 1) then
				self:Show()
			else
				self:Hide()
			end
		end
	end

	local function OnUpdate(self, event, unit)
		if UnitAffectingCombat(self.unit) then
			local _, _, threatpct, rawthreatpct, _ = UnitDetailedThreatSituation(self.unit, self.tar)
			local threatval = threatpct or 0
			self:SetValue(threatval)
			self.num = threatval
			local r, g, b = S.ColorGradient(threatval/100, 0,.8,0,.8,.8,0,.8,0,0)
			local texture = self:GetStatusBarTexture()
			S.CreateTop(texture, r, g, b, true)

			if threatval > 0 then
				self:SetAlpha(1)
			else
				self:SetAlpha(0)
			end	
		end
	end
	ThreatBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	ThreatBar:RegisterEvent("PLAYER_REGEN_ENABLED")
	ThreatBar:RegisterEvent("PLAYER_REGEN_DISABLED")
	ThreatBar:SetScript("OnEvent", OnEvent)
	ThreatBar:SetScript("OnUpdate", OnUpdate)
	ThreatBar.unit = "player"
	ThreatBar.tar = ThreatBar.unit.."target"
	ThreatBar:SetScript("OnEnter", function(self)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
		GameTooltip:AddDoubleLine("仇恨:", format("%3.1f", ThreatBar.num).."%")
		GameTooltip:Show()
	end)
	ThreatBar:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
end
  -- alt power bar
local function gen_alt_powerbar(f)
	local apb = CreateFrame("StatusBar", nil, f)
	apb:SetSize(f.width, 2)
	apb:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	apb:GetStatusBarTexture():SetHorizTile(false)
	apb:SetStatusBarColor(1, 1, 0)
	apb:Point("TOP", headframe, "BOTTOM", 0, -4)
	apb:CreateShadow()
	S.CreateMark(apb)
	S.CreateBack(apb)
	S.SmoothBar(apb)
	f.AltPowerBar = apb
	apb.text = S.MakeFontString(apb, 10)
	apb.text:SetPoint("CENTER")
	--apb.text:SetText("1/1")
	apb:SetScript("OnValueChanged", function(_, value)
		local _, max = apb:GetMinMaxValues()
		local texture = apb:GetStatusBarTexture()
		local r, g, b = oUF.ColorGradient((max-value), max, unpack(oUF.colors.smooth))
		S.CreateTop(texture, r, g, b)
		apb.text:SetText(ceil(value).."/"..max)
	end)
	
	f.AltPowerBar:SetScript("OnShow", function()
		if f.mystyle == "player" then
			f.tagpp:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 0, -15)
		elseif f.mystyle == "target" then
			f.tagpp:SetPoint("TOPRIGHT", f.Health, "BOTTOMRIGHT", 0, -15)
			f.taginfo:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 0, -15)
		end
	end)
	f.AltPowerBar:SetScript("OnHide", function()
		if f.mystyle == "player" then
			f.tagpp:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 0, -8)
		elseif f.mystyle == "target" then
			f.tagpp:SetPoint("TOPRIGHT", f.Health, "BOTTOMRIGHT", 0, -8)
			f.taginfo:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 0, -8)
		end
	end)
	
	--apb:Show()
	--apb.Hide = function() end
end
local BarFader = function(self) 
	self.BarFade = U["EnableBarFader"]
	self.BarFaderMinAlpha = 0
	self.BarFaderMaxAlpha = 1 
end
local function genStyle(self)
	self.menu = menu
	self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type2", "menu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    gen_hpbar(self)
    gen_hpstrings(self)
    gen_ppbar(self)
    gen_highlight(self)
    gen_RaidMark(self)
	self.Health.frequentUpdates = true
	if U["ReverseHPbars"] then 
		if U["ClassColor"] then 
			self.Health.colorClass = true
			self.Health.colorReaction = true
		else
			self.colors.health = {0.15, 0.15, 0.15}
			self.Health.colorHealth = true 
		end
	else 
		if U["ClassColor"] then 
			self.Health.colorClass = true
			self.Health.colorReaction = true
		else
			self.colors.health = {228/255, 38/255, 141/255}
			self.Health.colorHealth = true 
		end
	end
	self.Health.multiplier = 0.3
	self.Health.colorDisconnected = true
end

  --the player style
local function CreatePlayerStyle(self, unit)
    self.width = U["Width"]
    self.height = U["Height"]
    self.mystyle = "player"
    genStyle(self)
	BarFader(self)
    self.Health.Smooth = true
    self.Power.frequentUpdates = true
    self.Power.Smooth = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
	if U["CastBar"] == true then
		gen_castbar(self)
	end
    gen_portrait(self)
    gen_ppstrings(self)
    gen_InfoIcons(self)
	gen_alt_powerbar(self)
    createAuras(self)
	createBuffs(self)
    createDebuffs(self)
	if not P["Open"] then 
		gen_EclipseBar(self)
		gen_classpower(self)
		addHarmony(self)
		genShadowOrbs(self)
		genMage(self)
		warlockpower(self)
		gen_totembar(self)
	end
	gen_swing_timer(self)
    self:SetSize(self.width,self.height)
end  
  
  --the target style
local function CreateTargetStyle(self, unit)
    self.width = U["Width"]
    self.height = U["Height"]
    self.mystyle = "target"
    genStyle(self)
    self.Health.Smooth = true
    self.Power.frequentUpdates = true
    self.Power.Smooth = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
	self.Health.colorTapping = true
   	if U["CastBar"] == true then
		gen_castbar(self)
	end
    gen_portrait(self)
	gen_threat(self)
	gen_InfoIcons(self)
	if U["TargetAura"] ~= 2 then
		createAuras(self)
	end
	if U["TargetRange"] then
		self.SpellRange = {
	       insideAlpha = 1,
           outsideAlpha = U["RangeAlpha"]}
	end
    gen_ppstrings(self)
	gen_alt_powerbar(self)
	if not P["Open"] then 
		gen_cp(self)
	end
	self:SetSize(self.width,self.height)
	if U["TargetAura"] == 3 then self.Auras.onlyShowPlayer = true end
end  
  
  --the tot style
local function CreateToTStyle(self, unit)
    self.width = U["PetWidth"]
    self.height = U["PetHeight"]
    self.mystyle = "tot"
    genStyle(self)
	self.Health.Smooth = true
	self.Power.Smooth = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3	
	if U["TargetRange"] then
		self.SpellRange = {
	       insideAlpha = 1,
           outsideAlpha = U["RangeAlpha"]}
	end
	self:SetSize(self.width,self.height)
end 
  
 --the pet style
local function CreatePetStyle(self, unit)
    self.width = U["PetWidth"]
    self.height = U["PetHeight"]
    self.mystyle = "pet"
    self.disallowVehicleSwap = false
    genStyle(self)
	BarFader(self)
    self.Power.frequentUpdates = true
	self.Health.Smooth = true
	self.Power.Smooth = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
    if U["CastBar"] == true then
		gen_castbar(self)
	end
    createDebuffs(self)
	gen_alt_powerbar(self)
	self:SetSize(self.width,self.height)
end  

  --the focus style
local function CreateFocusStyle(self, unit)
	if U["BigFocus"] then
		self.width =U["BossWidth"]
		self.height = U["BossHeight"]
	else
		self.width = U["PetWidth"]
		self.height = U["PetHeight"]
	end
    self.mystyle = "focus"
    genStyle(self)
	self.Health.Smooth = true
	self.Power.Smooth = true
    self.Power.frequentUpdates = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
    if U["CastBar"] == true then
		gen_castbar(self)
	end
	createDebuffs(self)
	if U["TargetRange"] then
		self.SpellRange = {
	       insideAlpha = 1,
           outsideAlpha = U["RangeAlpha"]}
	end
	self.Debuffs.onlyShowPlayer = U["FocusDebuff"]
	self:SetSize(self.width,self.height)
end
  
  --partypet style
local function CreatePartyPetStyle(self)
    self.width = U["BossHeight"]+U["BossHeight"]/3+3
    self.height = self.width
    self.mystyle = "partypet"
    genStyle(self)
    self.Range = {
      insideAlpha = 1,
      outsideAlpha = 0.6}
end
  
  --the party style
local function CreatePartyStyle(self)
	if self:GetAttribute("unitsuffix") == "pet" then
      return CreatePartyPetStyle(self)
    end
    self.width = U["BossWidth"]
    self.height = U["BossHeight"]
    self.mystyle = "party"
    genStyle(self)
    self.Health.Smooth = true
	self.Power.Smooth = true
    self.Power.frequentUpdates = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
    self.Range = {
      insideAlpha = 1,
      outsideAlpha = 0.6}
	if U["Party3D"] then
		gen_portrait(self)
	end
    createBuffs(self)
    createDebuffs(self)
    gen_InfoIcons(self)
    gen_targeticon(self)
end  
  
  --arena frames
local function CreateArenaStyle(self, unit)
    self.width =U["BossWidth"]
    self.height = U["BossHeight"]
    self.mystyle = "arena"
    genStyle(self)
	--if U["ClassColor"] then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	--end
	self.Health.Smooth = true
	self.Power.Smooth = true
    self.Power.frequentUpdates = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
	--gen_portrait(self)
    createBuffs(self)
    createDebuffs(self)
    gen_ppstrings(self)
   	if U["CastBar"] == true then
		gen_castbar(self)
	end
    gen_arenatracker(self)
    gen_targeticon(self)
	self:SetSize(self.width,self.height)
end

  --mini arena targets
local function CreateArenaTargetStyle(self, unit)
    self.width = U["BossHeight"]+U["BossHeight"]/3+3
    self.height = self.width
    self.mystyle = "arenatarget"
    genStyle(self)
    self.Health.Smooth = true
	self.Power.Smooth = true
	self:SetSize(self.width,self.height)
end  
  
  --boss frames
local function CreateBossStyle(self, unit)
    self.width = U["BossWidth"]
    self.height = U["BossHeight"]
    self.mystyle = "boss"
    genStyle(self)
	self.Health.Smooth = true
	self.Power.Smooth = true
    self.Power.frequentUpdates = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
	createBuffs(self)
	createDebuffs(self)
	self.Debuffs.onlyShowPlayer = true
	if U["CastBar"] == true then
		gen_castbar(self)
	end
	gen_alt_powerbar(self)
	self:SetSize(self.width,self.height)
end 

function UF:fixArena()
	local arenaprep = {}
	for i = 1, 5 do
		arenaprep[i] = CreateFrame("Frame", "oUF_ArenaPrep"..i, UIParent)
		arenaprep[i]:SetAllPoints(_G["oUF_SunUIArena"..i])
		arenaprep[i]:CreateShadow()
		S.CreateBack(arenaprep[i])
		arenaprep[i]:SetFrameStrata("BACKGROUND")

		arenaprep[i].Health = CreateFrame("StatusBar", nil, arenaprep[i])
		arenaprep[i].Health:SetAllPoints()
		arenaprep[i].Health:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		arenaprep[i].Health.SetStatusBarColor = function(t, r, g, b)
			S.CreateTop(arenaprep[i].Health, r, g, b)
		end
		arenaprep[i].Spec = gen_fontstring(arenaprep[i].Health, DB.Font, U["FontSize"]*S.Scale(1), "THINOUTLINE")
		arenaprep[i].Spec:SetPoint("CENTER")

		arenaprep[i]:Hide()
	end

	local arenaprepupdate = CreateFrame("Frame")
	arenaprepupdate:RegisterEvent("PLAYER_ENTERING_WORLD")
	arenaprepupdate:RegisterEvent("ARENA_OPPONENT_UPDATE")
	arenaprepupdate:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	arenaprepupdate:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			for i = 1, 5 do
				arenaprep[i]:SetAllPoints(_G["oUF_SunUIArena"..i])
			end
		elseif event == "ARENA_OPPONENT_UPDATE" then
			for i = 1, 5 do
				arenaprep[i]:Hide()
			end
		else
			local numOpps = GetNumArenaOpponentSpecs()

			if numOpps > 0 then
				for i = 1, 5 do
					local f = arenaprep[i]

					if i <= numOpps then
						local s = GetArenaOpponentSpec(i)
						local _, spec, class = nil, "UNKNOWN", "UNKNOWN"

						if s and s > 0 then
							_, spec, _, _, _, _, class = GetSpecializationInfoByID(s)
						end

						if class and spec then
							local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
								if color then
									f.Health:SetStatusBarColor(color.r, color.g, color.b)
								else
									f.Health:SetStatusBarColor(0,0,0,0)
								end
				
							f.Spec:SetText(spec.."  -  "..LOCALIZED_CLASS_NAMES_MALE[class])
							f:Show()
						end
					else
						f:Hide()
					end
				end
			else
				for i = 1, 5 do
					arenaprep[i]:Hide()
				end
			end
		end
	end)
end

function UF:OnInitialize()
	if IsAddOnLoaded("Stuf") or IsAddOnLoaded("PitBull4") or IsAddOnLoaded("ShadowedUnitFrames") then
		return
	end
	U = SunUIConfig.db.profile.UnitFrameDB
	P = SunUIConfig.db.profile.PowerBarDB
	local SunUF_Parent = CreateFrame("Frame", "SunUF_Parent", UIParent, "SecureHandlerStateTemplate");
	SunUF_Parent:SetSize(1, 1)
	SunUF_Parent:SetPoint("RIGHT", UIParent, "LEFT", -1000, 0)
	RegisterStateDriver(SunUF_Parent, "visibility", "[petbattle] hide;show")
	
	oUF:RegisterStyle("SunUIPlayer", CreatePlayerStyle)
	oUF:RegisterStyle("SunUITarget", CreateTargetStyle)
	oUF:RegisterStyle("SunUIToT", CreateToTStyle)
	oUF:RegisterStyle("SunUIFocus", CreateFocusStyle)
	oUF:RegisterStyle("SunUIFocusTarget", CreateFocusStyle)
	oUF:RegisterStyle("SunUIPet", CreatePetStyle)
	oUF:RegisterStyle("SunUIParty", CreatePartyStyle)
	oUF:RegisterStyle("SunUIArena", CreateArenaStyle)
	oUF:RegisterStyle("SunUIArenaTarget", CreateArenaTargetStyle)
	oUF:RegisterStyle("SunUIBoss", CreateBossStyle)
	  
	oUF:Factory(function(self)
		self:SetActiveStyle("SunUIPlayer")
		local player = self:Spawn("player", "SunUF_Player")
		player:SetParent(SunUF_Parent)
		player:SetScale(U["Scale"])
		MoveHandle.SunUIPlayerFrame = S.MakeMove(player, "PlayerFrame", "PlayerFrame", U["Scale"])
	  
		self:SetActiveStyle("SunUITarget")
		local target = self:Spawn("target", "SunUF_Target")
		target:SetParent(SunUF_Parent)
		target:SetScale(U["Scale"])
		MoveHandle.SunUITargetFrame = S.MakeMove(target, "TargetFrame", "TargetFrame", U["Scale"])
	  
		if U["showtot"] then
			self:SetActiveStyle("SunUIToT")
			local tot = self:Spawn("targettarget", "SunUF_ToT")
			tot:SetParent(SunUF_Parent)
			tot:SetScale(U["PetScale"])
			MoveHandle.SunUIToTFrame = S.MakeMove(tot, "ToTFrame", "ToTFrame", U["PetScale"])
		end
	  
		if U["showfocus"] then
			self:SetActiveStyle("SunUIFocus")
			local focus = self:Spawn("focus", "SunUF_Focus")
			focus:SetParent(SunUF_Parent)
			focus:SetScale(U["PetScale"])
			MoveHandle.SunUIFocusFrame = S.MakeMove(focus, "FocusFrame", "FocusFrame", U["PetScale"])
		
			self:SetActiveStyle("SunUIFocusTarget")
			local focust = self:Spawn("focustarget", "SunUF_FocusTarget")
			focust:SetScale(U["PetScale"])
			MoveHandle.SunUIFocusTFrame = S.MakeMove(focust, "FocusTargetFrame", "FocusTFrame", U["PetScale"])
		else
			oUF:DisableBlizzard'focus'
		end
	  
		if U["showpet"] then
			self:SetActiveStyle("SunUIPet")
			local pet = self:Spawn("pet", "SunUF_Pet")
			pet:SetParent(SunUF_Parent)
			pet:SetScale(U["PetScale"])
			MoveHandle.SunUIPetFrame = S.MakeMove(pet, "PetFrame", "PetFrame", U["PetScale"])
		end
	  
		local w = U["BossWidth"]
		local h = U["BossHeight"]
		local s = U["BossScale"]
		local ph = 1.5*h+3

		local init = [[
			self:SetWidth(%d)
			self:SetHeight(%d)
			self:SetScale(%f)
			if self:GetAttribute("unitsuffix") == "pet" then
				self:SetWidth(%d)
				self:SetHeight(%d)
			end
		]]
		if U["showparty"] then
			self:SetActiveStyle("SunUIParty") 
			local party = self:SpawnHeader(nil,nil,'custom [group:party,nogroup:raid][@raid6,noexists,group:raid] show;hide',
				'oUF-initialConfigFunction', init:format(w,h,s,ph,ph),
				'showParty',true,
				'template','SunUF_PartyPet',
				'yOffset', -50)
			party:SetParent(SunUF_Parent)
			party:SetScale(U["BossScale"])
			MoveHandle.SunUIPartyFrame = S.MakeMove(party, "PartyFrame", "PartyFrame", U["BossScale"])
		else
			oUF:DisableBlizzard'party'
		end
	  
		local gap = 66
		if U["showarena"] and not IsAddOnLoaded('Gladius') then
			SetCVar("showArenaEnemyFrames", false)
			self:SetActiveStyle("SunUIArena")
			local arena = {}
			local arenatarget = {}
			for i = 1, 5 do
				arena[i] = self:Spawn("arena"..i, "SunUF_Arena"..i)
				arena[i]:SetParent(SunUF_Parent)
				arena[i]:SetScale(U["BossScale"])
				if i == 1 then
					MoveHandle.SunUIArenaFrame = S.MakeMove(arena[i], "Arena"..i, "ArenaFrame", U["BossScale"])
				else
					arena[i]:SetPoint("BOTTOMRIGHT", arena[i-1], "BOTTOMRIGHT", 0, gap)
				end
			end
			self:SetActiveStyle("SunUIArenaTarget")
			for i = 1, 5 do
				arenatarget[i] = self:Spawn("arena"..i.."target", "SunUF_Arena"..i.."target")
				arenatarget[i]:SetParent(SunUF_Parent)
				arenatarget[i]:SetPoint("TOPRIGHT",arena[i], "TOPLEFT", -4, 0)
				arenatarget[i]:SetScale(U["BossScale"])
			end
			UF:fixArena()
		end

		if U["showboss"] then
			self:SetActiveStyle("SunUIBoss")
			local boss = {}
			for i = 1, MAX_BOSS_FRAMES do
				boss[i] = self:Spawn("boss"..i, "SunUF_Boss"..i)
				boss[i]:SetParent(SunUF_Parent)
				boss[i]:SetScale(U["BossScale"])
				if i == 1 then
					MoveHandle.SunUIBossFrame = S.MakeMove(boss[i], "Boss"..i, "BossFrame", U["BossScale"])
				else
					boss[i]:SetPoint("BOTTOMRIGHT", boss[i-1], "BOTTOMRIGHT", 0, gap)
				end
			end
		end
	end)
end