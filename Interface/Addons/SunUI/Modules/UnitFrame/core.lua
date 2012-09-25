local ADDON_NAME, ns = ...
local addon, ns = ...
local oUF = ns.oUF or oUF 
local cast = ns.cast
local S, C, L, DB, _ = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("SunUI")
local Module = Core:NewModule("UnitFrame")
local _G = _G
local P,U
if IsAddOnLoaded("Stuf") or IsAddOnLoaded("PitBull4") or IsAddOnLoaded("ShadowedUnitFrames") then
	return
end
 -----------------------------
 -- local variables
 -----------------------------
oUF.colors.power['MANA'] = {.3,.45,.65}
oUF.colors.power['RAGE'] = {.7,.3,.3}
oUF.colors.power['FOCUS'] = {.7,.45,.25}
oUF.colors.power['ENERGY'] = {.65,.65,.35}
oUF.colors.power['RUNIC_POWER'] = {.45,.45,.75}
local class = select(2, UnitClass("player"))
local lib = {}
-----------------------------
-- FUNCTIONS
-----------------------------
local dropdown = CreateFrame('Frame', 'oUF_SunUIDropDown', UIParent, 'UIDropDownMenuTemplate')
--fontstring func
lib.gen_fontstring = function(f, name, size, outline)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(name, size, outline)
	fs:SetShadowColor(0,0,0,1)
    return fs
end  

--status bar filling fix
local fixStatusbar = function(b)
	b:GetStatusBarTexture():SetHorizTile(false)
	b:GetStatusBarTexture():SetVertTile(false)
end
  
  --right click menu
lib.menu = function(self)
	dropdown:SetParent(self)
	return ToggleDropDownMenu(1, nil, dropdown, 'cursor', 0, 0)
end
 local init = function(self)
	local unit = self:GetParent().unit
	local menu, name, id

	if(not unit) then
		return
	end

	if(UnitIsUnit(unit, "player")) then
		menu = "SELF"
	elseif(UnitIsUnit(unit, "vehicle")) then
		-- NOTE: vehicle check must come before pet check for accuracy's sake because
		-- a vehicle may also be considered your pet
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

lib.PostUpdateHealth = function(s, u, min, max)
	if UnitIsDeadOrGhost(u) then s:SetValue(0) end
end
local ReverseBar
do
-- reposition the status bar texture to fill from the right to left, thx Saiket
	local UpdaterOnUpdate = function(Updater)
		Updater:Hide()
		local b = Updater:GetParent()
		local tex = b:GetStatusBarTexture()
		tex:ClearAllPoints()
		tex:SetPoint("BOTTOMRIGHT")
		tex:SetPoint("TOPLEFT", b, "TOPRIGHT", (b:GetValue()/select(2,b:GetMinMaxValues())-1)*b:GetWidth(), 0)
	end
	local OnChanged = function(bar)
		bar.Updater:Show()
	end
	function ReverseBar(f)
		local bar = CreateFrame("StatusBar", nil, f) --separate frame for OnUpdates
		bar.Updater = CreateFrame("Frame", nil, bar)
		bar.Updater:Hide()
		bar.Updater:SetScript("OnUpdate", UpdaterOnUpdate)
		bar:SetScript("OnSizeChanged", OnChanged)
		bar:SetScript("OnValueChanged", OnChanged)
		bar:SetScript("OnMinMaxChanged", OnChanged)
		return bar;
	end
end
  
-- worgen male portrait fix
lib.PortraitPostUpdate = function(self, unit) 
	if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
		self:SetCamera(1)
	end	
end
  
-- threat updater
local updateThreat = function(self, event, unit)
    if(unit ~= self.unit) then return end
    local threat = self.Threat
    unit = unit or self.unit
    local status = UnitThreatSituation(unit)
    if(status and status > 1) then
      local r, g, b = GetThreatStatusColor(status)
      threat:SetBackdropBorderColor(r, g, b, 1)
    else
      threat:SetBackdropBorderColor(0, 0, 0, 0)
    end
    threat:Show()
end
  	
------ [Building frames]
--gen healthbar func
lib.gen_hpbar = function(f)
    --statusbar
	local s
	if not U["ReverseHPbars"] then 
		s = ReverseBar(f) 
		s.PostUpdate = lib.PostUpdateHealth  
		s:SetAlpha(1)
	else 
		s = CreateFrame("StatusBar", nil, f) 
		s:SetAlpha(1)
	end
    s:SetStatusBarTexture(DB.Statusbar)
	local gradient = s:CreateTexture(nil, "BACKGROUND")
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture(DB.Statusbar)
	gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
    fixStatusbar(s)
    s:SetHeight(f.height)
    s:SetWidth(f.width)
    s:SetPoint("TOPLEFT",0,0)
    s:SetOrientation("HORIZONTAL") 
	s:SetFrameLevel(5)
	s:CreateShadow()
    f.Health = s
end
  --3d portrait behind hp bar
lib.gen_portrait = function(f)
    s = f.Health
	local p = CreateFrame("PlayerModel", nil, f)
	p:SetFrameLevel(s:GetFrameLevel()-1)
    p:SetAllPoints()
	p:SetAlpha(U["Alpha3D"])
	p.PostUpdate = lib.PortraitPostUpdate	
    f.Portrait = p
end
--gen hp strings func
lib.gen_hpstrings = function(f, unit)
    --creating helper frame here so our font strings don't inherit healthbar parameters
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(15)
    local name = lib.gen_fontstring(h, DB.Font, U["FontSize"]*S.Scale(1), "THINOUTLINE")
    local hpval = lib.gen_fontstring(h, DB.Font,U["FontSize"]*S.Scale(1), "THINOUTLINE")
    if f.mystyle == "target" or f.mystyle == "tot" then
      name:SetPoint("RIGHT", f.Health, "RIGHT",-3,0)
      hpval:SetPoint("LEFT", f.Health, "LEFT",3,0)
      name:SetJustifyH("RIGHT")
      name:SetPoint("LEFT", hpval, "RIGHT", 5, 0)
    elseif f.mystyle == "arenatarget" or f.mystyle == "partypet" then
      name:SetPoint("CENTER", f.Health, "CENTER",0,6)
      name:SetJustifyH("LEFT")
      hpval:SetPoint("CENTER", f.Health, "CENTER",0,-6)
    else
      name:SetPoint("LEFT", f.Health, "LEFT",3,0)
      hpval:SetPoint("RIGHT", f.Health, "RIGHT",-3,0)
      name:SetJustifyH("LEFT")
      name:SetPoint("RIGHT", hpval, "LEFT", -5, 0)
    end
    if f.mystyle == "arenatarget" or f.mystyle == "partypet" then
      f:Tag(name, '[mono:color][mono:shortname]')
      f:Tag(hpval, '[mono:hpraid]')
    else
      f:Tag(name, '[mono:color][mono:longname]')
      f:Tag(hpval, '[mono:hp]')
    end
	if U["TagFadeIn"] then
		local Event = CreateFrame("Frame")
		Event:RegisterEvent("PLAYER_REGEN_DISABLED")
		Event:RegisterEvent("PLAYER_REGEN_ENABLED")
		Event:RegisterEvent("PLAYER_ENTERING_WORLD")
		Event:SetScript("OnEvent", function(self, event, ...)
			if event == "PLAYER_REGEN_DISABLED" then
				UIFrameFadeIn(name, 0.5, 0, 1)
				UIFrameFadeIn(hpval, 0.5, 0, 1)
			elseif event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD"then
				UIFrameFadeOut(name, 0.5, 1, 0)
				UIFrameFadeOut(hpval, 0.5, 1, 0)
			end
		end)
		f:HookScript("OnEnter", function()
			UnitFrame_OnEnter(f)
			 f.Highlight:Show()
			if not UnitAffectingCombat("player") then
				UIFrameFadeIn(name, 0.5, 0, 1)
				UIFrameFadeIn(hpval, 0.5, 0, 1)
			end
		end)
		f:HookScript("OnLeave", function()
			UnitFrame_OnLeave(f)
			f.Highlight:Hide()
			if not UnitAffectingCombat("player") then
				UIFrameFadeOut(name, 0.5, 1, 0)
				UIFrameFadeOut(hpval, 0.5, 1, 0)
			end
		end)
	end
end
  
--gen powerbar func
lib.gen_ppbar = function(f)
    --statusbar
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(DB.Statusbar)
    fixStatusbar(s)
    s:SetHeight(f.height/4)
    s:SetWidth(f.width)
    s:SetPoint("TOPLEFT",f,"BOTTOMLEFT",0,-6)
	s:SetAlpha(.8)
    if f.mystyle == "partypet" or f.mystyle == "arenatarget" then
      s:Hide()
    end
    s:CreateShadow("Background")
    if f.mystyle=="tot" or f.mystyle=="pet" then
      s:SetHeight(f.height/3)
    end
	
    f.Power = s
end
--filling up powerbar with text strings
lib.gen_ppstrings = function(f, unit)
    --helper frame
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Power)
    h:SetFrameLevel(10)
    local fh
    if f.mystyle == "arena" then fh = 9 else fh = 11 end
    local pp = lib.gen_fontstring(h, DB.Font, (U["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
    local info = lib.gen_fontstring(h, DB.Font, U["FontSize"]*S.Scale(1), "THINOUTLINE")
    if f.mystyle == "target" or f.mystyle == "tot" then
        info:Point("RIGHT", f.Power, "RIGHT",-3,0)
        pp:Point("LEFT", f.Power, "LEFT",3,0)
        info:SetJustifyH("RIGHT")
    else
        info:Point("LEFT", f.Power, "LEFT",3,0)
        pp:Point("RIGHT", f.Power, "RIGHT",-3,0)
        info:SetJustifyH("LEFT")
    end
	--resting indicator for player frame
	if f.mystyle == "player" then
		local ri = lib.gen_fontstring(f.Power, DB.Font, U["FontSize"]*S.Scale(1), "THINOUTLINE")
		ri:SetPoint("LEFT", info, "RIGHT",2,0)
		ri:SetText("|cff8AFF30Zzz|r")
		f.Resting = ri
	end
	pp.frequentUpdates = 0.3 -- test it!!1
    if class == "DRUID" then
      f:Tag(pp, '[mono:druidpower] [mono:pp]')
    else
      f:Tag(pp, '[mono:pp]')
    end
    f:Tag(info, '[mono:info]')
	
	if U["TagFadeIn"] then
		local Event = CreateFrame("Frame")
		Event:RegisterEvent("PLAYER_REGEN_DISABLED")
		Event:RegisterEvent("PLAYER_REGEN_ENABLED")
		Event:RegisterEvent("PLAYER_ENTERING_WORLD")
		Event:SetScript("OnEvent", function(self, event, ...)
			if event == "PLAYER_REGEN_DISABLED" then
				UIFrameFadeIn(info, 0.5, 0, 1)
				UIFrameFadeIn(pp, 0.5, 0, 1)
			elseif event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD"then
				UIFrameFadeOut(info, 0.5, 1, 0)
				UIFrameFadeOut(pp, 0.5, 1, 0)
			end
		end)
		f:HookScript("OnEnter", function()
			if not UnitAffectingCombat("player") then
				UIFrameFadeIn(info, 0.5, 0, 1)
				UIFrameFadeIn(pp, 0.5, 0, 1)
			end
		end)
		f:HookScript("OnLeave", function()
			if not UnitAffectingCombat("player") then
				UIFrameFadeOut(info, 0.5, 1, 0)
				UIFrameFadeOut(pp, 0.5, 1, 0)
			end
		end)
	end
end

------ [Castbar, +mirror castbar]
  --gen castbar
lib.gen_castbar = function(f)
    local s = CreateFrame("StatusBar", "oUF_SunUICastbar"..f.mystyle, f)
    s:Size(f.width-(f.height/1.5+4),f.height/1.5)
    s:SetStatusBarTexture(DB.Statusbar)
    s:SetStatusBarColor(.3, .45, .65,1)
    s:SetFrameLevel(9)
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
	local gradient = h:CreateTexture(nil, "BACKGROUND")
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture(DB.Statusbar)
	gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
	
	--spark
	local sp =  s:CreateTexture(nil, "OVERLAY")
	sp:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
	sp:SetBlendMode("ADD")
	sp:SetAlpha(.8)
	sp:SetPoint("TOPLEFT", s:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
	sp:SetPoint("BOTTOMRIGHT", s:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)
    --spell text
    local txt = lib.gen_fontstring(s, DB.Font, (U["FontSize"]+1)*S.Scale(1), "THINOUTLINE")
   
	txt:SetPoint("LEFT", 2, 0)

    txt:SetJustifyH("LEFT")
	
    --time
    local t = lib.gen_fontstring(s, DB.Font, (U["FontSize"]+1)*S.Scale(1), "THINOUTLINE")
   
	t:SetPoint("RIGHT", -2, 0)
    txt:SetPoint("RIGHT", t, "LEFT", -5, 0)
    --icon
    local i = s:CreateTexture(nil, "ARTWORK")
    --i:Size(s:GetHeight()+4,s:GetHeight()+4)
	i:Size(s:GetHeight(),s:GetHeight())
    i:Point("BOTTOMRIGHT", s, "BOTTOMLEFT", -6, 0)
    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	S.CreateShadow(s, i)
    
    if f.mystyle == "focus" and not U["focusCBuserplaced"] then
      s:Size(U["FocusCastBarWidth"],U["FocusCastBarHeight"])
	  MoveHandle.Castbarfouce = S.MakeMoveHandle(s, L["焦点施法条"], "FocusCastbar")
      i:SetPoint("RIGHT", s, "LEFT", 0, 0)
      --sp:SetHeight(s:GetHeight()*2.5)
    elseif f.mystyle == "pet" then
      s:SetPoint("BOTTOMRIGHT",f.Power,"BOTTOMRIGHT",0,0)
      s:SetScale(f:GetScale())
      s:Size(f.width-f.height/2,f.height/2.5)
      i:Point("RIGHT", s, "LEFT", -2, 0)
      txt:Hide() t:Hide() h:Hide()
    elseif f.mystyle == "arena" then
      s:Size(f.width-(f.height/1.4+4),f.height/1.4)
      s:Point("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
      i:Point("RIGHT", s, "LEFT", -4, 0)
      i:Size(s:GetHeight(),s:GetHeight())
    elseif f.mystyle == "player" then
	  if not U["playerCBuserplaced"] then
		s:SetSize(U["PlayerCastBarWidth"],U["PlayerCastBarHeight"])
		MoveHandle.Castbarplayer = S.MakeMoveHandle(s, L["玩家施法条"], "PlayerCastbar")
		i:SetSize(s:GetHeight(),s:GetHeight())
		sp:SetHeight(s:GetHeight()*2.5)
	  else
		s:Point("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
	  end
      --latency only for player unit
	  local z = s:CreateTexture(nil, "OVERLAY")
	  z:SetBlendMode("ADD")
      z:SetTexture(DB.Statusbar)
	  --z:SetWidth(1) -- it should never fill the entire castbar when GetNetStats() returns 0
      z:SetVertexColor(.8,.31,.45)
      z:SetPoint("TOPRIGHT")
      z:SetPoint("BOTTOMRIGHT")
	  --if UnitInVehicle("player") then z:Hide() end
      s.SafeZone = z
      --custom latency display
      local l = lib.gen_fontstring(s, DB.Font, U["FontSize"]*S.Scale(1), "THINOUTLINE")
      l:SetPoint("RIGHT", 0, -s:GetHeight()/2-5)
      l:SetJustifyH("RIGHT")
	  l:SetTextColor(.8,.31,.45)
      s.Lag = l
      f:RegisterEvent("UNIT_SPELLCAST_SENT", cast.OnCastSent)
	elseif f.mystyle == "target" and not U["targetCBuserplaced"] then
	  s:Size(U["TargetCastBarWidth"],U["TargetCastBarHeight"])
	  MoveHandle.Castbartarget = S.MakeMoveHandle(s, L["目标施法条"], "TargetCastbar")
	  i:Size(s:GetHeight(),s:GetHeight())
      sp:SetHeight(s:GetHeight()*2.5)
	else
      s:SetPoint("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
    end

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
end
------ [Auras, all of them!]
-- Creating our own timers with blackjack and hookers!
lib.FormatTime = function(s)
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
lib.CreateAuraTimer = function(self,elapsed)
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
          local time = lib.FormatTime(self.timeLeft)
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
lib.PostUpdateIcon = function(self, unit, icon, index, offset)
  local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)
    -- Debuff desaturation
    if unitCaster ~= 'player' and unitCaster ~= 'vehicle' and not UnitIsFriend('player', unit) and icon.debuff then
      icon.icon:SetDesaturated(true)
    else
      icon.icon:SetDesaturated(false)
    end
    -- Creating aura timers
    if duration and duration > 0 then
		icon.remaining:Show() 
    else
		icon.remaining:Hide()
    end
    if unit == 'player' or unit == 'target' or (unit:match'(boss)%d?$' == 'boss') or unit == 'focus' or unit == 'focustarget' then
      icon.duration = duration
      icon.timeLeft = expirationTime
      icon.first = true
      icon:SetScript("OnUpdate", lib.CreateAuraTimer)
    end
end
-- creating aura icons
lib.PostCreateIcon = function(self, button)
    button.cd:SetReverse()
    button.cd.noOCC = true
    button.cd.noCooldownCount = true
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    button.icon:SetDrawLayer("BACKGROUND")
    --count
	local h3 = CreateFrame("Frame", nil, button)
    h3:SetAllPoints(button)
    h3:SetFrameLevel(10)
	button.count = lib.gen_fontstring(h3, DB.Font, (U["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
    button.count:ClearAllPoints()
    button.count:SetJustifyH("RIGHT")
    button.count:Point("BOTTOMRIGHT", 2, -2)
    button.count:SetTextColor(1,1,1)
    --another helper frame for our fontstring to overlap the cd frame
    local h2 = CreateFrame("Frame", nil, button)
    h2:SetAllPoints(button)
    h2:SetFrameLevel(10)
    button.remaining = lib.gen_fontstring(h2, DB.Font, (U["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
	--button.remaining:SetShadowColor(0, 0, 0)--button.remaining:SetShadowOffset(2, -1)
    button.remaining:SetPoint("TOPLEFT", -2, 4)
    --overlay texture for debuff types display
	
    button.overlay:SetTexture("Interface\\Addons\\SunUI\\media\\icon_clean")
    button.overlay:Point("TOPLEFT", button, "TOPLEFT", -1, 1)
    button.overlay:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    button.overlay:SetTexCoord(0.04, 0.96, 0.04, 0.96)
    button.overlay.Hide = function(self) self:SetVertexColor(0, 0, 0) end
	--button.overlay:CreateShadow()
end

--auras for certain frames
lib.createAuras = function(f)
    a = CreateFrame('Frame', nil, f)
	if f.mystyle~="player" then 
		a:SetPoint('TOPLEFT', f, 'TOPRIGHT', 3, 0)
	else
		a:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, 15)
	end
    a['growth-x'] = 'RIGHT'
    a['growth-y'] = 'DOWN' 
    a.initialAnchor = 'TOPLEFT'
    a.gap = true
    a.spacing = 3
    a.size = 16
    a.showDebuffType = true
    if f.mystyle=="target" then
      a:SetHeight((a.size+a.spacing)*2)
      a:SetWidth((a.size+a.spacing)*8)
      a.numBuffs = 8 
      a.numDebuffs = 8
	elseif f.mystyle=="player" and U["PlayerBuff"]==3 then
	  a.gap = false
	  a['growth-x'] = 'RIGHT'
      a['growth-y'] = 'UP' 
	  a:SetHeight((a.size+a.spacing)*2)
      a:SetWidth((a.size+a.spacing)*8)
      a.initialAnchor = 'BOTTOMLEFT'
      a.numBuffs = 4 
      a.numDebuffs = 4
	  a:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, 15)
    elseif f.mystyle=="focus" then
      a:SetHeight((a.size+a.spacing)*2)
      a:SetWidth((a.size+a.spacing)*4)
      a.numBuffs = 8
      a.numDebuffs = 8
    end
    a.PostCreateIcon = lib.PostCreateIcon
    a.PostUpdateIcon = lib.PostUpdateIcon
	f.Auras = a
end
  -- buffs
lib.createBuffs = function(f)
    b = CreateFrame("Frame", nil, f)
    b.initialAnchor = "TOPLEFT"
    b["growth-y"] = "DOWN"
    b.num = 8
    b.size = 16
    b.spacing = 3
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
		d['growth-y'] = 'DOWN'
		b.initialAnchor = "RIGHT"
		b.showBuffType = true
		b:SetPoint("RIGHT", f, "LEFT", -2, 0)
		b.size = 16
		b.num = 4
		b:SetWidth((b.size+b.spacing)*4)
    elseif f.mystyle=='party' then
		b:SetPoint("TOPLEFT", f.Power, "BOTTOMLEFT", 0, -b.spacing)
		b.size = 16
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
    b.PostCreateIcon = lib.PostCreateIcon
    b.PostUpdateIcon = lib.PostUpdateIcon
    f.Buffs = b
end
  -- debuffs
  lib.createDebuffs = function(f)
    d = CreateFrame("Frame", nil, f)
    d.initialAnchor = "TOPRIGHT"
	d['growth-x'] = 'RIGHT'
    d["growth-y"] = "DOWN"
    d.num = 8
    d.size = 16
    d.spacing = 3
    d:SetHeight((d.size+d.spacing)*2)
    d:SetWidth((d.size+d.spacing)*5)
    d.showDebuffType = true
    if f.mystyle=="tot" then
		d:SetPoint("TOPLEFT", f, "TOPRIGHT", d.spacing, -2)
		d.initialAnchor = "TOPLEFT"
    elseif f.mystyle=="pet" then
		d:SetPoint("TOPRIGHT", f, "TOPLEFT", -d.spacing, -2)
		d["growth-x"] = "LEFT"
    elseif f.mystyle=="arena" then
		d.showDebuffType = false
		d.initialAnchor = "TOPLEFT"
		d.num = 4
		d.size = 16
		d:SetPoint('TOPLEFT', f, 'TOPRIGHT', 2, 0)
		d:SetWidth((d.size+d.spacing)*4)
--[[     elseif f.mystyle=="boss" then
      d.showDebuffType = false
      d.initialAnchor = "TOPLEFT"
      d.num = 4
	  d.size = 18
	  d:SetPoint("TOPRIGHT", f, "TOPLEFT", d.spacing, -2)
      d:SetWidth((d.size+d.spacing)*4) ]]
    elseif f.mystyle=='party' then
		d:SetPoint("TOPRIGHT", f, "TOPLEFT", -d.spacing, -2)
		d.num = 8
		d.size = 16
		d["growth-x"] = "LEFT"
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
		d:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
    end
	d.PostCreateIcon = lib.PostCreateIcon
	d.PostUpdateIcon = lib.PostUpdateIcon
	f.Debuffs = d
end

------ [Extra functionality]
lib.gen_classpower = function(f)  
	if  class ~= "PALADIN" and class ~= "DEATHKNIGHT" then return end
        -- Runes, Shards, HolyPower
            local count
            if class == "DEATHKNIGHT" then 
                count = 6
            elseif class == "PALADIN" then
                count = UnitPowerMax('player', SPELL_POWER_HOLY_POWER)
            end
			local bars = CreateFrame("Frame", nil, f)
			bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
            bars:SetSize((f.width-2*(count-1))/count, f.height/5)
            for i = 1, count do
                bars[i] =CreateFrame("StatusBar", nil, bars)
				bars[i]:SetStatusBarTexture(DB.Statusbar)
				bars[i]:GetStatusBarTexture():SetHorizTile(false)
				bars[i]:SetSize((f.width-2*(count-1))/count, f.height/5)
				 if (i == 1) then
					bars[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
				else
					bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 2, 0)
				end
                if class == "WARLOCK" then  
                    bars[i]:SetStatusBarColor(0.5, 0.32, 0.55)
                elseif class == "PALADIN" then
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
lib.warlockpower = function(f)
	if class ~= "WARLOCK" then return end
	local bars = CreateFrame("Frame", nil, f)
			bars:SetWidth(f.width)
			bars:SetHeight(f.height/3)
			bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
			local gradient = bars:CreateTexture(nil, "BACKGROUND")
			gradient:SetPoint("TOPLEFT")
			gradient:SetPoint("BOTTOMRIGHT")
			gradient:SetTexture(DB.Statusbar)
			gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
			for i = 1, 4 do
				bars[i] = CreateFrame("StatusBar", nil, f)
				bars[i]:SetHeight(f.height/3)
				bars[i]:SetStatusBarTexture(DB.Statusbar)
				local gradient = bars[i]:CreateTexture(nil, "BACKGROUND")
				gradient:SetPoint("TOPLEFT")
				gradient:SetPoint("BOTTOMRIGHT")
				gradient:SetTexture(DB.Statusbar)
				gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
				bars[i]:CreateShadow()
				if i == 1 then
					bars[i]:SetPoint("LEFT", bars)
					bars[i]:SetWidth((f.width/4))
				else
					bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 2, 0)
					bars[i]:SetWidth((f.width/4)-2)
				end
			end
			f.WarlockSpecBars = bars
end

--Monk harmony bar
lib.addHarmony = function(f)
	if class ~= "MONK" then return end
	local chibar = CreateFrame("Frame",nil,f)
	chibar:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	chibar:SetSize((f.width-8)/5, f.height/4)
	for i=1,5 do
		chibar[i] = CreateFrame("StatusBar",nil,chibar)
		chibar[i]:SetSize((f.width-8)/5, f.height/4)
		chibar[i]:SetStatusBarTexture(DB.Statusbar)
		chibar[i]:SetStatusBarColor(0.0, 1.00 , 0.59)
		chibar[i]:CreateShadow()
		if i==1 then
			chibar[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
		else
			chibar[i]:SetPoint("LEFT", chibar[i-1], "RIGHT", 2, 0)
		end
		chibar[i]:Hide()
	end
	chibar:RegisterEvent("PLAYER_ENTERING_WORLD")
	chibar:RegisterEvent("UNIT_POWER")
	chibar:RegisterEvent("UNIT_DISPLAYPOWER")
	chibar:SetScript("OnEvent",function()
		local chinum = UnitPower("player",SPELL_POWER_LIGHT_FORCE)
		local chimax = UnitPowerMax("player",SPELL_POWER_LIGHT_FORCE)
		if chinum ~= chimax then
			if chimax == 4 then
				chibar[5]:Hide()
				for i = 1,4 do
					chibar[i]:SetWidth((f.width-6)/4)
				end
			elseif chimax == 5 then
				chibar[5]:Show()
				for i = 1,5 do
					chibar[i]:SetWidth((f.width-8)/5)
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
lib.genShadowOrbs = function(f)
	if class ~= "PRIEST" then return end
	
	local ShadowOrbs = CreateFrame("Frame", nil, f)
	ShadowOrbs:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	ShadowOrbs:SetSize((f.width-8)/5, f.height/4)

	local maxShadowOrbs = UnitPowerMax('player', SPELL_POWER_SHADOW_ORBS)
	
	for i = 1,maxShadowOrbs do
		ShadowOrbs[i] = CreateFrame("StatusBar", nil, f)
		ShadowOrbs[i]:SetSize((f.width-2*(maxShadowOrbs-1))/maxShadowOrbs, f.height/4)
		ShadowOrbs[i]:SetStatusBarTexture(DB.Statusbar)
		ShadowOrbs[i]:SetStatusBarColor(.86,.22,1)
		ShadowOrbs[i]:CreateShadow()
		if (i == 1) then
			ShadowOrbs[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
		else
			ShadowOrbs[i]:SetPoint("LEFT", ShadowOrbs[i-1], "RIGHT", 2, 0)
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
--奥法的6个东西
lib.genMage = function(f)
	if class ~= "MAGE" then return end
	
	local bars = CreateFrame("Frame", nil, f)
	bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	bars:SetSize((f.width-8)/5, f.height/4)
	
	for i = 1,6 do
		bars[i] = CreateFrame("StatusBar", nil, f)
		bars[i]:SetSize((f.width-2*(6-1))/6, f.height/4)
		bars[i]:SetStatusBarTexture(DB.Statusbar)
		bars[i]:SetStatusBarColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
		bars[i]:CreateShadow()
		bars[i]:Hide()
		if (i == 1) then
			bars[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 2, 0)
		end
	end
	bars:RegisterEvent("PLAYER_ENTERING_WORLD")
	bars:RegisterEvent("UNIT_AURA")
	bars:RegisterEvent("PLAYER_REGEN_DISABLED")
	bars:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	bars:SetScript("OnEvent",function()
		local num = select(4, UnitDebuff("player", GetSpellInfo(36032)))
		if num == nil then num = 0 end
		for i = 1,6 do
			if i <= num then
				bars[i]:Show()
			else
				bars[i]:Hide()
			end
		end
	end)
end
  --gen eclipse bar
  lib.gen_EclipseBar = function(f)
	if class ~= "DRUID" then return end
	local eb = CreateFrame('Frame', nil, f)
	eb:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, S.Scale(2))
	eb:SetSize(f.width, 6)
	eb:CreateShadow("Background")
	local lb = CreateFrame('StatusBar', nil, eb)
	lb:SetPoint('LEFT', eb, 'LEFT')
	lb:SetSize(f.width, 6)
	lb:SetStatusBarTexture(DB.Statusbar)
	lb:SetStatusBarColor(0.27, 0.47, 0.74)
	eb.LunarBar = lb
	local sb = CreateFrame('StatusBar', nil, eb)
	sb:SetPoint('LEFT', lb:GetStatusBarTexture(), 'RIGHT', 0, 0)
	sb:SetSize(f.width, 6)
	sb:SetStatusBarTexture(DB.Statusbar)
	sb:SetStatusBarColor(0.9, 0.6, 0.3)
	eb.SolarBar = sb
  	local h = CreateFrame("Frame", nil, eb)
	h:SetAllPoints(eb)
	h:SetFrameLevel(eb:GetFrameLevel()+1)
 	--[[local ebText = lib.gen_fontstring(h, DB.Font, 20, "THINOUTLINE")
	ebText:SetPoint('CENTER', eb, 'CENTER', 0, 0)
	eb.Text = ebText]]
	f.EclipseBar = eb
	local ebInd = lib.gen_fontstring(h, DB.Font, (U["FontSize"]+4)*S.Scale(1), "THINOUTLINE")
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
  lib.gen_cp = function(f)
	if class ~= "ROGUE" and class ~= "DRUID" then return end
     local colors = {
			[1]	= {0.05, 0.43, 0.72},
			[2]	= {0.71, 0.21, 0.82},
			[3]	= {0.24, 0.67, 0.23},
			[4]	= {0.95, 0.71, 0.00},
			[5]	= {0.72, 0.05, 0.05},}
			local bars = CreateFrame("Frame", nil, f)
			bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
            bars:SetSize((f.width-8)/5, f.height/4)
            for i = 1, 5 do
                bars[i] =CreateFrame("StatusBar", nil, bars)
				bars[i]:SetStatusBarTexture(DB.Statusbar)
				bars[i]:GetStatusBarTexture():SetHorizTile(false)
				bars[i]:SetSize((f.width-12)/5, f.height/4)
				 if (i == 1) then
					bars[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
				else
					bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 3, 0)
				end
				bars[i]:SetStatusBarColor(unpack(colors[i]))
				bars[i].bg = CreateFrame("Frame", nil, bars[i])
				bars[i].bg:SetAllPoints()
				bars[i].bg:CreateShadow("Background")
                i=i-1
				end
				f.CPoints = bars
  end 
  --gen LFD role indicator
  lib.gen_LFDindicator = function(f)
    local lfdi = lib.gen_fontstring(f.Power, DB.Font, U["FontSize"]*S.Scale(1), "THINOUTLINE")
    lfdi:SetPoint("LEFT", f.Power, "LEFT",1,0)
    f:Tag(lfdi, '[mono:LFD]')
  end
  --gen combat and leader icons
  lib.gen_InfoIcons = function(f)
    local h = CreateFrame("Frame",nil,f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(10)
    --combat icon
    if f.mystyle == 'player' then
		f.Combat = h:CreateTexture(nil, 'OVERLAY')
		f.Combat:Size(20,20)
		f.Combat:SetPoint('TOPRIGHT', 3, 9)
    end
    --Leader icon
    li = h:CreateTexture(nil, "OVERLAY")
    li:SetPoint("TOPLEFT", f, 0, 6)
    li:Size(12,12)
    f.Leader = li
    --Assist icon
    ai = h:CreateTexture(nil, "OVERLAY")
    ai:SetPoint("TOPLEFT", f, 0, 6)
    ai:Size(12,12)
    f.Assistant = ai
    --ML icon
    local ml = h:CreateTexture(nil, 'OVERLAY')
    ml:Size(12,12)
    ml:SetPoint('LEFT', f.Leader, 'RIGHT')
    f.MasterLooter = ml
	 --PVP icon
    local pvp = h:CreateTexture(nil, 'OVERLAY')
    pvp:Size(25)
    pvp:SetPoint('RIGHT', f.Leader, 'LEFT')
    f.PvP = pvp
  end
  --gen raid mark icons
  lib.gen_RaidMark = function(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
    h:SetAlpha(1)
    local ri = h:CreateTexture(nil,'OVERLAY',h)
    ri:SetPoint("CENTER", f, "CENTER", 0, 0)
    ri:Size(S.Scale(20), S.Scale(20))
    f.RaidIcon = ri
  end
  --gen hilight texture
  lib.gen_highlight = function(f)
    local hl = f.Health:CreateTexture(nil, "OVERLAY")
    hl:SetAllPoints(f.Health)
    hl:SetTexture(DB.Solid)
    hl:SetVertexColor(.5,.5,.5,.1)
    hl:SetBlendMode("ADD")
    hl:Hide()
    f.Highlight = hl
  end
  --gen trinket and aura tracker for arena frames
  lib.UpdateAuraTracker = function(self, elapsed)
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
  lib.gen_arenatracker = function(f)
    t = CreateFrame("Frame", nil, f)
    t:Size(21,21)
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
	at.text = lib.gen_fontstring(at, DB.Font, (U["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
	at.text:SetPoint('CENTER', at, 0, 0)
	at:SetScript('OnUpdate', lib.UpdateAuraTracker)
	f.AuraTracker = at
  end
  --gen current target indicator
  lib.gen_targeticon = function(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(10)
    local ti = lib.gen_fontstring(h, DB.Font, U["FontSize"], "THINOUTLINE")
    ti:SetPoint("LEFT", f.Health, "BOTTOMLEFT",-5,0)
    ti:SetJustifyH("LEFT")
    f:Tag(ti, '[mono:targeticon]')
  end
  -- oUF_Swing
  lib.gen_swing_timer = function(f)
	if U["EnableSwingTimer"] then
		sw = CreateFrame("StatusBar", f:GetName().."_Swing", f)
		sw:SetStatusBarTexture(DB.Statusbar)
		sw:SetStatusBarColor(.3, .3, .3)
		sw:SetHeight(4)
		sw:SetWidth(f.width)
		sw:SetPoint("TOP", f.Power, "BOTTOM", 0, -3)
		sw.bg = sw:CreateTexture(nil, "BORDER")
		sw.bg:SetAllPoints(sw)
		sw.bg:SetTexture(DB.Statusbar)
		sw.bg:SetVertexColor(.1, .1, .1, 0.25)
		sw.bd = CreateFrame("Frame", nil, sw)
		sw.bd:SetFrameLevel(1)
		sw.bd:SetPoint("TOPLEFT", -4, 4)
		sw.bd:SetPoint("BOTTOMRIGHT", 4, -4)
		sw.Text = lib.gen_fontstring(sw, DB.Font, U["FontSize"]*S.Scale(1), "THINOUTLINE")
		sw.Text:SetPoint("CENTER", 0, 0)
		sw.Text:SetTextColor(1, 1, 1)
		f.Swing = sw
	end
  end
  -- alt power bar
  lib.gen_alt_powerbar = function(f)
	local apb = CreateFrame("StatusBar", nil, f)
	apb:SetFrameLevel(f.Health:GetFrameLevel() + 2)
	apb:Size(f.width/2.2, f.height/3)
	apb:SetStatusBarTexture(DB.Statusbar)
	apb:GetStatusBarTexture():SetHorizTile(false)
	apb:SetStatusBarColor(1, 0, 0)
	apb:SetPoint("BOTTOM", f, "TOP", 0, -f.height/6)
	apb:CreateShadow()

	apb.bg = apb:CreateTexture(nil, "BORDER")
	apb.bg:SetAllPoints(apb)
	apb.bg:SetTexture(DB.Statusbar)
	apb.bg:SetVertexColor(.18, .18, .18, 1)
	f.AltPowerBar = apb
	
	apb.b = CreateFrame("Frame", nil, apb)
	apb.b:SetFrameLevel(f.Health:GetFrameLevel() + 1)
	apb.b:SetPoint("TOPLEFT", apb, "TOPLEFT", -4, 4)
	apb.b:SetPoint("BOTTOMRIGHT", apb, "BOTTOMRIGHT", 4, -5)
	
	apb.v = lib.gen_fontstring(apb, DB.Font, U["FontSize"]*S.Scale(1), "THINOUTLINE")
	apb.v:SetPoint("CENTER", apb, "CENTER", 0, 0)
	f:Tag(apb.v, '[mono:altpower]')
  end

	local BarFader = function(self) 
         self.BarFade = U["EnableBarFader"]
         self.BarFaderMinAlpha = 0
         self.BarFaderMaxAlpha = 1 
	end
  local function genStyle(self)
	self.menu = lib.menu
	self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type2", "menu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    lib.gen_hpbar(self)
    lib.gen_hpstrings(self)
    lib.gen_ppbar(self)
    lib.gen_highlight(self)
    lib.gen_RaidMark(self)
	self.Health.frequentUpdates = true
	if U["ReverseHPbars"] then 
		if U["ClassColor"] then 
			self.colors.smooth = {DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b,DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b,DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b}
		else
			self.colors.smooth = {1,0,0,199/255,97/255,20/255, 0.1,0.1,0.1} 
		end
	else 
		if U["ClassColor"] then 
			self.colors.smooth = {DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b,DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b,DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b}
		else
			self.colors.smooth = {1,0,0,1,1,0,0,128/255,0}
		end
	end
    self.Health.colorSmooth = true
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
		lib.gen_castbar(self)
	end
    lib.gen_portrait(self)
    lib.gen_ppstrings(self)
    lib.gen_InfoIcons(self)
	lib.gen_alt_powerbar(self)
    lib.createAuras(self)
	lib.createBuffs(self)
    lib.createDebuffs(self)
	if not P["Open"] then 
		lib.gen_EclipseBar(self)
		lib.gen_classpower(self)
		lib.addHarmony(self)
		lib.genShadowOrbs(self)
		lib.genMage(self)
		lib.warlockpower(self)
	end
	lib.gen_swing_timer(self)
    self:Size(self.width,self.height)
  end  
  
  --the target style
  local function CreateTargetStyle(self, unit)
    self.width = U["Width"]
    self.height = U["Height"]
    self.mystyle = "target"
    genStyle(self)
	if U["ClassColor"] then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
    self.Health.Smooth = true
    self.Power.frequentUpdates = true
    self.Power.Smooth = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
	self.Health.colorTapping = true
   	if U["CastBar"] == true then
		lib.gen_castbar(self)
	end
    lib.gen_portrait(self)
	if U["TargetAura"] ~= 2 then
		lib.createAuras(self)
	end
	if U["TargetRange"] then
		self.SpellRange = {
	       insideAlpha = 1,
           outsideAlpha = U["RangeAlpha"]}
	end
    lib.gen_ppstrings(self)
	lib.gen_alt_powerbar(self)
	if not P["Open"] then 
		lib.gen_cp(self)
	end
	self:Size(self.width,self.height)
	if U["TargetAura"] == 3 then self.Auras.onlyShowPlayer = true end
  end  
  
  --the tot style
  local function CreateToTStyle(self, unit)
    self.width = U["PetWidth"]
    self.height = U["PetHeight"]
    self.mystyle = "tot"
    genStyle(self)
    if U["ClassColor"] then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
    self.Power.colorPower = true
    self.Power.multiplier = 0.3	
	if U["TargetRange"] then
		self.SpellRange = {
	       insideAlpha = 1,
           outsideAlpha = U["RangeAlpha"]}
	end
	self:Size(self.width,self.height)
  end 
  
  --the pet style
  local function CreatePetStyle(self, unit)
    self.width = U["PetWidth"]
    self.height = U["PetHeight"]
    self.mystyle = "pet"
    self.disallowVehicleSwap = true
    genStyle(self)
    self.Power.frequentUpdates = true
	self.Power.Smooth = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
    if U["CastBar"] == true then
		lib.gen_castbar(self)
	end
    lib.createDebuffs(self)
	self:Size(self.width,self.height)
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
	if U["ClassColor"] then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
    self.Power.frequentUpdates = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
    if U["CastBar"] == true then
		lib.gen_castbar(self)
	end
	lib.createDebuffs(self)
	if U["TargetRange"] then
		self.SpellRange = {
	       insideAlpha = 1,
           outsideAlpha = U["RangeAlpha"]}
	end
	self.Debuffs.onlyShowPlayer = U["FocusDebuff"]
	self:Size(self.width,self.height)
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
	if U["ClassColor"] then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
    self.Health.Smooth = true
    self.Power.frequentUpdates = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
    self.Range = {
      insideAlpha = 1,
      outsideAlpha = 0.6}
	if U["Party3D"] then
		lib.gen_portrait(self)
	end
    lib.createBuffs(self)
    lib.createDebuffs(self)
    lib.gen_InfoIcons(self)
    lib.gen_targeticon(self)
	lib.gen_LFDindicator(self)
  end  
  
  --arena frames
  local function CreateArenaStyle(self, unit)
    self.width =U["BossWidth"]
    self.height = U["BossHeight"]
    self.mystyle = "arena"
    genStyle(self)
    self.Health.Smooth = true
	if U["ClassColor"] then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
    self.Power.frequentUpdates = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
	--lib.gen_portrait(self)
    lib.createBuffs(self)
    lib.createDebuffs(self)
    lib.gen_ppstrings(self)
   	if U["CastBar"] == true then
		lib.gen_castbar(self)
	end
    lib.gen_arenatracker(self)
    lib.gen_targeticon(self)
	self:Size(self.width,self.height)
  end

  --mini arena targets
  local function CreateArenaTargetStyle(self, unit)
    self.width = U["BossHeight"]+U["BossHeight"]/3+3
    self.height = self.width
    self.mystyle = "arenatarget"
    genStyle(self)
    
	self:Size(self.width,self.height)
  end  
  
  --boss frames
  local function CreateBossStyle(self, unit)
    self.width = U["BossWidth"]
    self.height = U["BossHeight"]
    self.mystyle = "boss"
    genStyle(self)
	if U["ClassColor"] then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
    self.Power.frequentUpdates = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
	lib.createBuffs(self)
	lib.createDebuffs(self)
	self.Debuffs.onlyShowPlayer = true
	if U["CastBar"] == true then
		lib.gen_castbar(self)
	end
	lib.gen_alt_powerbar(self)
	self:Size(self.width,self.height)
  end  
function Module:OnInitialize()
	U = C["UnitFrameDB"]
	P = C["PowerBarDB"]
end
function Module:OnEnable()
	  -----------------------------
	  -- SPAWN UNITS
	  -----------------------------
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
	  local player = self:Spawn("player", "oUF_SunUIPlayer")
	  player:SetPoint("CENTER", "UIParent", "CENTER", -225, -208)
	  player:SetScale(U["Scale"])
	  MoveHandle.SunUIPlayerFrame = S.MakeMove(player, "SunUI_PlayerFrame", "PlayerFrame", U["Scale"])
	  
	  self:SetActiveStyle("SunUITarget")
	  local target = self:Spawn("target", "oUF_SunUITarget")
	  target:SetScale(U["Scale"])
	  MoveHandle.SunUITargetFrame = S.MakeMove(target, "SunUI_TargetFrame", "TargetFrame", U["Scale"])
	  
	  if U["showtot"] then
		self:SetActiveStyle("SunUIToT")
		local tot = self:Spawn("targettarget", "oUF_SunUIToT")
		tot:SetScale(U["PetScale"])
		MoveHandle.SunUIToTFrame = S.MakeMove(tot, "SunUI_ToTFrame", "ToTFrame", U["PetScale"])
	  end
	  
	  if U["showfocus"] then
		self:SetActiveStyle("SunUIFocus")
		local focus = self:Spawn("focus", "oUF_SunUIFocus")
		focus:SetScale(U["PetScale"])
		MoveHandle.SunUIFocusFrame = S.MakeMove(focus, "SunUI_FocusFrame", "FocusFrame", U["PetScale"])
		
		self:SetActiveStyle("SunUIFocusTarget")
		local focust = self:Spawn("focustarget", "oUF_SunUIFocusTarget")
		focust:SetScale(U["PetScale"])
		MoveHandle.SunUIFocusTFrame = S.MakeMove(focust, "SunUI_FocusTargetFrame", "FocusTFrame", U["PetScale"])
	  else
		oUF:DisableBlizzard'focus'
	  end
	  
	  if U["showpet"] then
		self:SetActiveStyle("SunUIPet")
		local pet = self:Spawn("pet", "oUF_SunUIPet")
		pet:SetScale(U["PetScale"])
		MoveHandle.SunUIPetFrame = S.MakeMove(pet, "SunUI_PetFrame", "PetFrame", U["PetScale"])
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
		local party = self:SpawnHeader(nil,nil,"custom [@raid6,noexists,group:raid] hide; show",
		'oUF-initialConfigFunction', init:format(w,h,s,ph,ph),
		'showParty',true,
		'template','oUF_SunUIPartyPet',
		'yOffset', -40)
		party:SetScale(U["BossScale"])
		MoveHandle.SunUIPartyFrame = S.MakeMove(party, "SunUI_PartyFrame", "PartyFrame", U["BossScale"])
	  end
	  
	  local gap = 66
	  if U["showarena"] and not IsAddOnLoaded('Gladius') then
		SetCVar("showArenaEnemyFrames", false)
		self:SetActiveStyle("SunUIArena")
		local arena = {}
		local arenatarget = {}
		for i = 1, 5 do
		  arena[i] = self:Spawn("arena"..i, "oUF_SunUIArena"..i)
		  arena[i]:SetScale(U["BossScale"])
		  if i == 1 then
			MoveHandle.SunUIArenaFrame = S.MakeMove(arena[i], "SunUIArena"..i, "ArenaFrame", U["BossScale"])
		  else
			arena[i]:SetPoint("BOTTOMRIGHT", arena[i-1], "BOTTOMRIGHT", 0, gap)
		  end
		end
		self:SetActiveStyle("SunUIArenaTarget")
		for i = 1, 5 do
		  arenatarget[i] = self:Spawn("arena"..i.."target", "oUF_Arena"..i.."target")
		  arenatarget[i]:SetPoint("TOPRIGHT",arena[i], "TOPLEFT", -4, 0)
		  arenatarget[i]:SetScale(U["BossScale"])
		end
	  end

	  if U["showboss"] then
		self:SetActiveStyle("SunUIBoss")
		local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
		  boss[i] = self:Spawn("boss"..i, "oUF_Boss"..i)
		  boss[i]:SetScale(U["BossScale"])
		  if i == 1 then
			MoveHandle.SunUIBossFrame = S.MakeMove(boss[i], "SunUIBoss"..i, "BossFrame", U["BossScale"])
		  else
			boss[i]:SetPoint("BOTTOMRIGHT", boss[i-1], "BOTTOMRIGHT", 0, gap)
		  end
		end
	  end
	end)  
end