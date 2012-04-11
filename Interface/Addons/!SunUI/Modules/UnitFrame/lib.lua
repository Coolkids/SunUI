local addon, ns = ...
local oUF = ns.oUF or oUF 
local cast = ns.cast
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("UnitFrameLib")
local lib = CreateFrame("Frame")  
if DB.Nuke == true then return end
local PlayerTimersOnly = false 
function Module:OnInitialize()
local playerauras = "DEBUFFS"  		
local EnableCombatFeedback = false
C = UnitFrameDB
  -----------------------------
  -- local variables
  -----------------------------
  oUF.colors.power['MANA'] = {.3,.45,.65}
  oUF.colors.power['RAGE'] = {.7,.3,.3}
  oUF.colors.power['FOCUS'] = {.7,.45,.25}
  oUF.colors.power['ENERGY'] = {.65,.65,.35}
  oUF.colors.power['RUNIC_POWER'] = {.45,.45,.75}
  local class = select(2, UnitClass("player"))

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --fontstring func
  lib.gen_fontstring = function(f, name, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, outline)
    fs:SetShadowColor(0,0,0,1)
--    fs:SetTextColor(1,1,1)
    return fs
  end  

  --backdrop table
  local backdrop_tab = { 
    bgFile = DB.Solid, 
    edgeFile = DB.GlowTex,
    tile = false, tileSize = 0, edgeSize = 5, 
    insets = {left = 5, right = 5, top = 5, bottom = 5,},}
  
  --backdrop func
  lib.gen_backdrop = function(f)
    f:SetBackdrop(backdrop_tab);
    f:SetBackdropColor(0,0,0,0)
    f:SetBackdropBorderColor(0,0,0,1)
  end
  
  --status bar filling fix
  local fixStatusbar = function(b)
    b:GetStatusBarTexture():SetHorizTile(false)
    b:GetStatusBarTexture():SetVertTile(false)
  end
  
  --right click menu
  lib.menu = function(self)
	local unit = self.unit:sub(1, -2)
    local cunit = self.unit:gsub("(.)", string.upper, 1)

    if(unit == "party" or unit == "partypet") then
      ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
      ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
    end
  end
  
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
	if not C["ReverseHPbars"] then 
		s = ReverseBar(f) 
		s.PostUpdate = lib.PostUpdateHealth  
		s:SetAlpha(1)
	else 
		s = CreateFrame("StatusBar", nil, f) 
		s:SetAlpha(1)
	end
    --local s = ReverseBar(f)--CreateFrame("StatusBar", nil, f)--
    s:SetStatusBarTexture(DB.Statusbar)
    fixStatusbar(s)
    s:SetHeight(f.height)
    s:SetWidth(f.width)
    s:SetPoint("TOPLEFT",0,0)
    --s:SetAlpha(0.7)
    s:SetOrientation("HORIZONTAL") 
	s:SetFrameLevel(5)
    --shadow backdrop
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",0,0)
    h:SetPoint("BOTTOMRIGHT",0,0)
	--h:SetAlpha(0.5)
	h:CreateShadow("UnitFrame")
    --bar bg
	local bg = CreateFrame("Frame", nil, s)
	bg:SetFrameLevel(s:GetFrameLevel()-2)
    bg:SetAllPoints(s)
    local b = bg:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(nil)
	b:SetAlpha(0)
    b:SetAllPoints(s)
	--CreateShadow(s, b, "UnitFrame")
	-- threat border

	if f.mystyle == "party" then
		bg.t = CreateFrame("Frame", nil,bg)
		bg.t:SetPoint("TOPLEFT", bg, "TOPLEFT", -1, 1)
		bg.t:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", 1, -1)
		bg.t:SetBackdrop({edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = .5,
							insets = {left = 6, right = -6, top = -6, bottom = 6}})
		bg.t:SetBackdropColor(0, 0, 0, 0)
		bg.t:SetBackdropBorderColor(0, 1, 1, 0) 
		bg.t.Override = updateThreat
		f.Threat = bg.t
	end
	
    f.Health = s
    f.Health.bg = b
  end
  --3d portrait behind hp bar
  lib.gen_portrait = function(f)
    s = f.Health
	local p = CreateFrame("PlayerModel", nil, f)
	p:SetFrameLevel(s:GetFrameLevel()-1)
    p:SetWidth(f.width-2)
    p:SetHeight(f.height-2)
    p:SetPoint("TOP", s, "TOP", 0, -2)
	p:SetAlpha(C["Alpha3D"])
	p.PostUpdate = lib.PortraitPostUpdate	
    f.Portrait = p
  end
  --gen hp strings func
  lib.gen_hpstrings = function(f, unit)
    --creating helper frame here so our font strings don't inherit healthbar parameters
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(15)
    local valsize
    if f.mystyle == "arenatarget" or f.mystyle == "partypet" then valsize = 11 else valsize = 13 end 
    local name = lib.gen_fontstring(h, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
    local hpval = lib.gen_fontstring(h, DB.Font,C["FontSize"]*S.Scale(1), "THINOUTLINE")
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
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",0,0)
    h:SetPoint("BOTTOMRIGHT",0,0)
    h:CreateShadow("UnitFrame")
    --bg
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(nil)
	b:SetAlpha(.0)
    b:SetAllPoints(s)
    if f.mystyle=="tot" or f.mystyle=="pet" then
      s:SetHeight(f.height/3)
    end
	
    f.Power = s
    f.Power.bg = b
  end
  --filling up powerbar with text strings
  lib.gen_ppstrings = function(f, unit)
    --helper frame
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Power)
    h:SetFrameLevel(10)
    local fh
    if f.mystyle == "arena" then fh = 9 else fh = 11 end
    local pp = lib.gen_fontstring(h, DB.Font, (C["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
    local info = lib.gen_fontstring(h, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
    if f.mystyle == "target" or f.mystyle == "tot" then
        info:SetPoint("RIGHT", f.Power, "RIGHT",-3,0)
        pp:SetPoint("LEFT", f.Power, "LEFT",3,0)
        info:SetJustifyH("RIGHT")
    else
        info:SetPoint("LEFT", f.Power, "LEFT",3,3)
        pp:SetPoint("RIGHT", f.Power, "RIGHT",-5,4)
        info:SetJustifyH("LEFT")
    end
	--resting indicator for player frame
	if f.mystyle == "player" then
		local ri = lib.gen_fontstring(f.Power, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
		ri:SetPoint("LEFT", info, "RIGHT",2,0)
		ri:SetText("|cff8AFF30Zzz|r")
		f.Resting = ri
	end
	pp.frequentUpdates = 0.2 -- test it!!1
    if class == "DRUID" then
      f:Tag(pp, '[mono:druidpower] [mono:pp]')
    else
      f:Tag(pp, '[mono:pp]')
    end
    f:Tag(info, '[mono:info]')
  end

------ [Castbar, +mirror castbar]
  --gen castbar
  lib.gen_castbar = function(f)
    local s = CreateFrame("StatusBar", "oUF_monoCastbar"..f.mystyle, f)
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
    h:SetPoint("TOPLEFT",0,0)
    h:SetPoint("BOTTOMRIGHT",0,0)
    --lib.gen_backdrop(h)
    --[[--backdrop
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(DB.Statusbar)
    b:SetAllPoints(s)
    b:SetVertexColor(0.3*0.2, 0.45*0.2, 0.65*0.2, 0.7)--]]
	--backdrop
	h:CreateShadow("Background")

    --[[spark
    sp = s:CreateTexture(nil, "OVERLAY")
    sp:SetBlendMode("ADD")
    sp:SetAlpha(0.5)
    sp:SetHeight(s:GetHeight()*2.5)--]]
	--spark
	local sp =  s:CreateTexture(nil, "OVERLAY")
	sp:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
	sp:SetBlendMode("ADD")
	sp:SetAlpha(.8)
	sp:SetPoint("TOPLEFT", s:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
	sp:SetPoint("BOTTOMRIGHT", s:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)
    --spell text
    local txt = lib.gen_fontstring(s, DB.Font, (C["FontSize"]+1)*S.Scale(1), "THINOUTLINE")
    txt:SetPoint("LEFT", 2, s:GetHeight()/2)
    txt:SetJustifyH("LEFT")
    --time
    local t = lib.gen_fontstring(s, DB.Font, (C["FontSize"]+1)*S.Scale(1), "THINOUTLINE")
    t:SetPoint("RIGHT", -2, s:GetHeight()/2)
    txt:SetPoint("RIGHT", t, "LEFT", -5, 0)
    --icon
    local i = s:CreateTexture(nil, "ARTWORK")
    --i:Size(s:GetHeight()+4,s:GetHeight()+4)
	i:Size(s:GetHeight(),s:GetHeight())
    i:SetPoint("BOTTOMRIGHT", s, "BOTTOMLEFT", -6, 0)
    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	CreateShadow(s, i)
    --helper2 for icon
    local h2 = CreateFrame("Frame", nil, s)
    h2:SetFrameLevel(0)
    h2:SetPoint("TOPLEFT",i,"TOPLEFT",-5,5)
    h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
    
    if f.mystyle == "focus" and not C["focusCBuserplaced"] then
      s:Size(C["FocusCastBarWidth"],C["FocusCastBarHeight"])
	  MoveHandle.Castbarfouce = S.MakeMoveHandle(s, L["焦点施法条"], "FocusCastbar")
      i:SetPoint("RIGHT", s, "LEFT", 0, 0)
      sp:SetHeight(s:GetHeight()*2.5)
    elseif f.mystyle == "pet" then
      s:SetPoint("BOTTOMRIGHT",f.Power,"BOTTOMRIGHT",0,0)
      s:SetScale(f:GetScale())
      s:Size(f.width-f.height/2,f.height/2.5)
      i:SetPoint("RIGHT", s, "LEFT", -2, 0)
      h2:SetFrameLevel(9)
      b:Hide() txt:Hide() t:Hide() h:Hide()
    elseif f.mystyle == "arena" then
      s:Size(f.width-(f.height/1.4+4),f.height/1.4)
      s:SetPoint("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
      i:SetPoint("RIGHT", s, "LEFT", -4, 0)
      i:Size(s:GetHeight(),s:GetHeight())
    elseif f.mystyle == "player" then
	  if not C["playerCBuserplaced"] then
		s:Size(C["PlayerCastBarWidth"],C["PlayerCastBarHeight"])
		MoveHandle.Castbarplay = S.MakeMoveHandle(s, L["玩家施法条"], "PlayerCastbar")
		i:Size((s:GetHeight()+2)*2,(s:GetHeight()+2)*2)
		sp:SetHeight(s:GetHeight()*2.5)
	  else
		s:SetPoint("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
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
      local l = lib.gen_fontstring(s, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
      l:SetPoint("RIGHT", 0, -s:GetHeight())
      l:SetJustifyH("RIGHT")
	  l:SetTextColor(.8,.31,.45)
      s.Lag = l
      f:RegisterEvent("UNIT_SPELLCAST_SENT", cast.OnCastSent)
	elseif f.mystyle == "target" and not C["targetCBuserplaced"] then
	  s:Size(C["TargetCastBarWidth"],C["TargetCastBarHeight"])
	  MoveHandle.Castbartarget = S.MakeMoveHandle(s, L["目标施法条"], "TargetCastbar")
	  i:Size(s:GetHeight()*2,s:GetHeight()*2)
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
  --gen Mirror Cast Bar
  --/run local t = _G["MirrorTimer1StatusBar"]:GetValue() print(t)
 --[[  lib.gen_mirrorcb = function(f)
    for _, bar in pairs({'MirrorTimer1','MirrorTimer2','MirrorTimer3',}) do   
      for i, region in pairs({_G[bar]:GetRegions()}) do
        if (region.GetTexture and region:GetTexture() == 'SolidTexture') then
          region:Hide()
        end
      end
      _G[bar..'Border']:Hide()
      _G[bar]:SetParent(UIParent)
      _G[bar]:SetScale(1)
      _G[bar]:SetHeight(16)
      --_G[bar]:SetBackdropColor(.1,.1,.1)
      _G[bar..'Background'] = _G[bar]:CreateTexture(bar..'Background', 'BACKGROUND', _G[bar])
      _G[bar..'Background']:SetAllPoints(bar)
      _G[bar..'Background']:SetVertexColor(.15,.15,.15, 0)
      _G[bar..'Text']:SetFont(DB.Font, (C["FontSize"]+2)*S.Scale(1))
      _G[bar..'Text']:ClearAllPoints()
      _G[bar..'Text']:SetPoint('CENTER', _G[bar..'StatusBar'], 0, 0)
	  _G[bar..'StatusBar']:SetAllPoints(_G[bar])

      --glowing borders
      local h = CreateFrame("Frame", nil, _G[bar])
      h:SetFrameLevel(0)
      h:SetPoint("TOPLEFT")
      h:SetPoint("BOTTOMRIGHT")
      --lib.gen_backdrop(h)
	  h:CreateShadow("Background")
    end
  end ]]
  
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
      if PlayerTimersOnly and unitCaster ~= 'player' then 
		if unit=='player' and icon.debuff then icon.remaining:Show() else icon.remaining:Hide() end
	  else 
		icon.remaining:Show() 
	  end
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
	button.count = lib.gen_fontstring(h3, DB.Font, (C["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
    button.count:ClearAllPoints()
    button.count:SetJustifyH("RIGHT")
    button.count:SetPoint("BOTTOMRIGHT", 2, -2)
    button.count:SetTextColor(1,1,1)
    --helper
    local h = CreateFrame("Frame", nil, button)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-4,4)
    h:SetPoint("BOTTOMRIGHT",4,-4)
    --lib.gen_backdrop(h)
    --another helper frame for our fontstring to overlap the cd frame
    local h2 = CreateFrame("Frame", nil, button)
    h2:SetAllPoints(button)
    h2:SetFrameLevel(10)
    button.remaining = lib.gen_fontstring(h2, DB.Font, (C["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
	--button.remaining:SetShadowColor(0, 0, 0)--button.remaining:SetShadowOffset(2, -1)
    button.remaining:SetPoint("TOPLEFT", -2, 4)
    --overlay texture for debuff types display
	
    button.overlay:SetTexture("Interface\\Addons\\!SunUI\\media\\icon_clean")
    button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    button.overlay:SetTexCoord(0.04, 0.96, 0.04, 0.96)
    button.overlay.Hide = function(self) self:SetVertexColor(0, 0, 0) end
	--button.overlay:CreateShadow()
  end
  -- position update for certain class/specs
--[[   lib.PreSetPosition = function(self, num)
	local f = self:GetParent()
	local pttree = GetPrimaryTalentTree(false, false, GetActiveTalentGroup())
	if f.mystyle=="player" and ((class=="DRUID" and pttree == 1) or class == "DEATHKNIGHT" or (class == "SHAMAN" and IsAddOnLoaded("oUF_boring_totembar"))) then
		self:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 1, 6+f.height/3)
	else
		self:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 1.5, 4)
	end
  end ]]
  --auras for certain frames
  lib.createAuras = function(f)
    a = CreateFrame('Frame', nil, f)
    a:SetPoint('TOPLEFT', f, 'TOPRIGHT', 3, 0)
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
	elseif f.mystyle=="player" and playerauras=="AURAS" then
	  a.gap = false
      a['growth-x'] = 'LEFT'
      a['growth-y'] = 'DOWN' 
      a.initialAnchor = 'TOPLEFT'
      a:SetHeight((a.size+a.spacing)*2)
      a:SetWidth((a.size+a.spacing)*8)
      a.numBuffs = 8 
      a.numDebuffs = 8
	  a:SetPoint('TOPLEFT', f, 'TOPLEFT', -a.size-5, -1)
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
	elseif f.mystyle=="player" and playerauras=="BUFFS" then
	  b['growth-x'] = 'LEFT'
      b['growth-y'] = 'DOWN' 
      b.initialAnchor = 'TOPRIGHT'
	  b.num = 8
	  b.size = 16
      b:SetHeight((b.size+b.spacing)*2)
      b:SetWidth((b.size+b.spacing)*8)
	  b:SetPoint("TOPRIGHT", f, "TOPLEFT", -5, -1)
	  --b.PreSetPosition = lib.PreSetPosition
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
    d.num = 16
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
	elseif f.mystyle=="player" and playerauras=="DEBUFFS" then
	  d['growth-x'] = 'RIGHT'
      d['growth-y'] = 'UP' 
      d.initialAnchor = 'BOTTOMLEFT'
	  d.num = 8
	  d.size = 16
      d:SetHeight((d.size+d.spacing)*2)
      d:SetWidth((d.size+d.spacing)*8)
	  d:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 15)
	  --d.PreSetPosition = lib.PreSetPosition
	  elseif f.mystyle=="focus" then
	  d:SetPoint("RIGHT", f, "LEFT", -d.spacing, 0)
      d["growth-x"] = "LEFT"
	  d['growth-y'] = 'DOWN' 
	  d.initialAnchor = 'RIGHT'
	  d.num = 16
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
 lib.gen_sppower = function(f)  
	if class ~= "PRIEST" then return end
	local color = oUF.colors.power["SOUL_SHARDS"]
	local bars = CreateFrame("Frame", nil, f)
	bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
    bars:SetSize((f.width-4)/3, f.height/3)
            for i = 1, 3 do
                bars[i] =CreateFrame("StatusBar", nil, bars)
				bars[i]:SetStatusBarTexture(DB.Statusbar)
				bars[i]:GetStatusBarTexture():SetHorizTile(false)
				bars[i]:SetSize((f.width-4)/3, f.height/3)
				 if (i == 1) then
					bars[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
				else
					bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 2, 0)
				end
                bars[i]:SetStatusBarColor(color[1], color[2], color[3])
				bars[i].bg = CreateFrame("Frame", nil, bars[i])
				bars[i].bg:SetAllPoints()
				bars[i].bg:CreateShadow("Background")
                i=i-1
            end
	local function OnEvent(self,event)
		rank = select(4,UnitBuff("player", GetSpellInfo(77487)))
		if rank then
			for i = 1, rank do
				bars[i]:SetAlpha(1)
			end
		else
			for i = 1, 3 do
				bars[i]:SetAlpha(0)
			end
		end
	end
	bars:RegisterEvent("UNIT_AURA")
	bars:RegisterEvent("PLAYER_ENTERING_WORLD")
	bars:RegisterEvent("PLAYER_REGEN_DISABLED")
	bars:RegisterEvent("PLAYER_REGEN_ENABLED")
	bars:SetScript("OnEvent", OnEvent)
end
   lib.gen_classpower = function(f)  
	if class ~= "WARLOCK" and class ~= "PALADIN" and class ~= "DEATHKNIGHT" then return end
        -- Runes, Shards, HolyPower
            local count
            if class == "DEATHKNIGHT" then 
                count = 6 
            else 
                count = 3 
            end
			local bars = CreateFrame("Frame", nil, f)
			bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
            bars:SetSize((f.width-2*(count-1))/count, f.height/3)
            for i = 1, count do
                bars[i] =CreateFrame("StatusBar", nil, bars)
				bars[i]:SetStatusBarTexture(DB.Statusbar)
				bars[i]:GetStatusBarTexture():SetHorizTile(false)
				bars[i]:SetSize((f.width-2*(count-1))/count, f.height/3)
				 if (i == 1) then
					bars[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
				else
					bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 2, 0)
				end
                if class == "WARLOCK" then
                    local color = oUF.colors.power["SOUL_SHARDS"]
                    bars[i]:SetStatusBarColor(color[1], color[2], color[3])
                elseif class == "PALADIN" then
                    local color = oUF.colors.power["HOLY_POWER"]
                    bars[i]:SetStatusBarColor(color[1], color[2], color[3])
				end
				bars[i].bd = CreateFrame("Frame", nil, bars[i])
				bars[i].bd:SetAllPoints()
				bars[i].bd:CreateShadow("Background")
                i=i-1
            end
            if class == "DEATHKNIGHT" then
                bars[3], bars[4], bars[5], bars[6] = bars[5], bars[6], bars[3], bars[4]
                f.Runes = bars
            elseif class == "WARLOCK" then
                f.SoulShards = bars
            elseif class == "PALADIN" then
                f.HolyPower = bars
            end
end

  --gen eclipse bar
  lib.gen_EclipseBar = function(f)
	if class ~= "DRUID" then return end
	local eb = CreateFrame('Frame', nil, f)
	eb:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', -3, -1)
	eb:Size(f.width+7, 20)
	lib.gen_backdrop(eb)
	local lb = CreateFrame('StatusBar', nil, eb)
	lb:SetPoint('LEFT', eb, 'LEFT', 4, 0)
	lb:Size(f.width-2, 10)
	lb:SetStatusBarTexture(DB.Statusbar)
	lb:SetStatusBarColor(0.27, 0.47, 0.74)
	eb.LunarBar = lb
	local sb = CreateFrame('StatusBar', nil, eb)
	sb:SetPoint('LEFT', lb:GetStatusBarTexture(), 'RIGHT', 0, 0)
	sb:Size(f.width-2, 10)
	sb:SetStatusBarTexture(DB.Statusbar)
	sb:SetStatusBarColor(0.9, 0.6, 0.3)
	eb.SolarBar = sb
  	local h = CreateFrame("Frame", nil, eb)
	h:SetAllPoints(eb)
	h:SetFrameLevel(30)
 	--[[local ebText = lib.gen_fontstring(h, DB.Font, 20, "THINOUTLINE")
	ebText:SetPoint('CENTER', eb, 'CENTER', 0, 0)
	eb.Text = ebText]]
	f.EclipseBar = eb
	local ebInd = lib.gen_fontstring(h, DB.Font, (C["FontSize"]+4)*S.Scale(1), "THINOUTLINE")
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
  --gen TotemBar for shamans
  lib.gen_TotemBar = function(f)
    if class ~= "SHAMAN" then return
    else
		local width = (f.width + 4) / 4 - 4
		local height = f.height/3
		local TotemBar = CreateFrame("Frame", nil, f)
		TotemBar:Size(width,height)
		TotemBar:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 1, 3)
		TotemBar.Destroy = true
		TotemBar.UpdateColors = true
		TotemBar.AbbreviateNames = true
		for i = 1, 4 do
			local t = CreateFrame("Frame", nil, TotemBar)
			t:SetPoint("LEFT", (i - 1) * (width + 3.5), 0)
			t:SetWidth(width)
			t:SetHeight(height)
			local bar = CreateFrame("StatusBar", nil, t)
			bar:SetWidth(width)
			bar:SetPoint"BOTTOM"
			bar:SetHeight(8)
			t.StatusBar = bar
			local h = CreateFrame("Frame",nil,t)
			h:SetFrameLevel(10)
			local time = lib.gen_fontstring(h, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
			time:SetPoint("BOTTOMRIGHT",t,"TOPRIGHT", 0, -1)
			time:SetFontObject"GameFontNormal"
			t.Time = time
			local text = lib.gen_fontstring(h, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
			text:Hide()---SetPoint("BOTTOMLEFT", t, "TOPLEFT", 0, -1)
			--text:SetFontObject"GameFontNormal"
			t.Text = text
	        t.bg = CreateFrame("Frame", nil, t)
			t.bg:SetPoint("TOPLEFT", t, "TOPLEFT", -4, 5)
			t.bg:SetPoint("BOTTOMRIGHT", t, "BOTTOMRIGHT", 4, -5)
			t.bg:SetBackdrop(backdrop_tab)
			t.bg:SetBackdropColor(0,0,0,0)
			t.bg:SetBackdropBorderColor(0,0,0,1)
			t.bg = t:CreateTexture(nil, "BACKGROUND")
			t.bg:SetAllPoints()
			t.bg:SetTexture(1, 1, 1)
			t.bg.multiplier = 0.2
			TotemBar[i] = t
		end
		f.TotemBar = TotemBar
    end
  end
  --gen class specific power display
  lib.gen_specificpower = function(f, unit)
   if class ~= "DRUID" and class ~= "SHAMAN" then return end
	local bars = CreateFrame("Frame", nil, f)
	bars:SetFrameLevel(f:GetFrameLevel()+1)
	if class == "DRUID" then 
		bars:SetSize((f.width-10)/3, f.height/3/2)
		bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, -3)
	else
		bars:SetSize((f.width-4)/3, f.height/3)
		bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	end
    for i = 1, 3 do
        bars[i] =CreateFrame("StatusBar", nil, bars)
		bars[i]:SetStatusBarTexture(DB.Statusbar)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
		if class == "DRUID" then 
			bars[i]:SetSize((f.width-4)/3, f.height/3/2)
		else
			bars[i]:SetSize((f.width-4)/3, f.height/3)
		end
		if (i == 1) then
			if class ~= "DRUID" then
				bars[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
			else
				bars[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, -1.5)
			end
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 2, 0)
		end
		if class == "DRUID" then 
			local color = oUF.colors.power["SOUL_SHARDS"]
            bars[i]:SetStatusBarColor(color[1], color[2], color[3])
		else
			bars[i]:SetStatusBarColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
		end
		bars[i].bg = CreateFrame("Frame", nil, bars[i])
		bars[i].bg:SetAllPoints()
		bars[i].bg:CreateShadow("Background")
        i=i-1
        end
		if 	class == "SHAMAN" then
		local function OnEvent(self,event)
			rank = select(4,UnitBuff("player", GetSpellInfo(52127)))
			if rank then
				for i = 1, rank do
					bars[i]:SetAlpha(1)
				end
			else
				for i = 1, 3 do
					bars[i]:SetAlpha(0)
				end
			end
		end
		bars:RegisterEvent("UNIT_AURA")
		bars:RegisterEvent("PLAYER_ENTERING_WORLD")
		bars:RegisterEvent("PLAYER_REGEN_DISABLED")
		bars:RegisterEvent("PLAYER_REGEN_ENABLED")
		bars:SetScript("OnEvent", OnEvent)
		elseif class == "DRUID" then
			local function OnEvent(self,event)
				for i=1,3 do
					local dur = select(4,GetTotemInfo(i))
					if dur > 0 then
						bars[i]:SetAlpha(1)
					else
						bars[i]:SetAlpha(0)
					end
				end
			end
		bars:RegisterEvent("PLAYER_TOTEM_UPDATE")
		bars:RegisterEvent("PLAYER_ENTERING_WORLD")
		bars:RegisterEvent("PLAYER_REGEN_DISABLED")
		bars:RegisterEvent("PLAYER_REGEN_ENABLED")
		bars:SetScript("OnEvent", OnEvent)
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
  lib.gen_lifebloom = function(f)  
	if class ~= "DRUID" then return end
	local bars = CreateFrame("Frame", nil, f)
	bars:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
    bars:SetSize((f.width-4)/3, f.height/3)
            for i = 1, 3 do
                bars[i] =CreateFrame("StatusBar", nil, bars)
				bars[i]:SetStatusBarTexture(DB.Statusbar)
				bars[i]:GetStatusBarTexture():SetHorizTile(false)
				bars[i]:SetSize((f.width-4)/3, f.height/3)
				 if (i == 1) then
					bars[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
				else
					bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 2, 0)
				end
                bars[i]:SetStatusBarColor(0.2, 0.8, 0.2)
				bars[i].bg = CreateFrame("Frame", nil, bars[i])
				bars[i].bg:SetAllPoints()
				bars[i].bg:CreateShadow("Background")
                i=i-1
            end
	local function OnEvent(self,event)
		rank = select(4,UnitBuff("target", GetSpellInfo(33763)))
		caster = select(8,UnitBuff("target", GetSpellInfo(33763)))
		if rank and caster == "player" then
			for i = 1, rank do
				bars[i]:SetAlpha(1)
			end
		else
			for i = 1, 3 do
				bars[i]:SetAlpha(0)
			end
		end
	end
	bars:RegisterEvent("UNIT_AURA")
	bars:RegisterEvent("PLAYER_ENTERING_WORLD")
	bars:RegisterEvent("PLAYER_REGEN_DISABLED")
	bars:RegisterEvent("PLAYER_REGEN_ENABLED")
	bars:SetScript("OnEvent", OnEvent)
end
  --gen LFD role indicator
  lib.gen_LFDindicator = function(f)
    local lfdi = lib.gen_fontstring(f.Power, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
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
    local OnEnter = function(f)
      UnitFrame_OnEnter(f)
      f.Highlight:Show()
    end
    local OnLeave = function(f)
      UnitFrame_OnLeave(f)
      f.Highlight:Hide()
    end
    f:SetScript("OnEnter", OnEnter)
    f:SetScript("OnLeave", OnLeave)
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
    t:SetPoint("CENTER", f.Power, "CENTER", 0, 0)
    t:SetFrameLevel(30)
    t:SetAlpha(0.8)
    t.trinketUseAnnounce = true
    t.bg = CreateFrame("Frame", nil, t)
    t.bg:SetPoint("TOPLEFT",-4,4)
    t.bg:SetPoint("BOTTOMRIGHT",4,-4)
    t.bg:SetBackdrop(backdrop_tab);
    t.bg:SetBackdropColor(0,0,0,0)
    t.bg:SetBackdropBorderColor(0,0,0,1)
    f.Trinket = t
	at = CreateFrame('Frame', nil, f)
	at:SetAllPoints(f.Trinket)
	at:SetFrameStrata('HIGH')
	at.icon = at:CreateTexture(nil, 'ARTWORK')
	at.icon:SetAllPoints(at)
	at.icon:SetTexCoord(0.07,0.93,0.07,0.93)
	at.text = lib.gen_fontstring(at, DB.Font, (C["FontSize"]-1)*S.Scale(1), "THINOUTLINE")
	at.text:SetPoint('CENTER', at, 0, 0)
	at:SetScript('OnUpdate', lib.UpdateAuraTracker)
	f.AuraTracker = at
  end
  --gen current target indicator
  lib.gen_targeticon = function(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(10)
    local ti = lib.gen_fontstring(h, DB.Font, C["FontSize"], "THINOUTLINE")
    ti:SetPoint("LEFT", f.Health, "BOTTOMLEFT",-5,0)
    ti:SetJustifyH("LEFT")
    f:Tag(ti, '[mono:targeticon]')
  end
  --gen fake target bars
  lib.gen_faketarget = function(f)
    local fhp = CreateFrame("frame","FakeHealthBar",UIParent) 
    fhp:SetAlpha(.6)
    fhp:Size(f.width,f.height)
    fhp:SetPoint("TOPLEFT",oUF_monoTargetFrame,"TOPLEFT",0,0)
    fhp.bg = fhp:CreateTexture(nil, "PARENT")
    fhp.bg:SetTexture(DB.Statusbar)
    fhp.bg:ClearAllPoints()
    fhp.bg:SetAllPoints(fhp)
    fhp.bg:SetVertexColor(.3,.3,.3)
    local h = CreateFrame("Frame",nil,fhp)
    h:SetBackdrop(backdrop_tab)
    h:SetPoint("TOPLEFT",-3.5,3.5)
    h:SetPoint("BOTTOMRIGHT",3.5,-3.5)
    h:SetBackdropColor(0,0,0,0)
    h:SetBackdropBorderColor(0,0,0,.7)

    local fpp = CreateFrame("frame","FakeManaBar",fhp)
    fpp:SetWidth(fhp:GetWidth())
    fpp:SetHeight(f.height/3)
    fpp:SetPoint("TOPLEFT",FakeHealthBar,"BOTTOMLEFT",0,-2)
    fpp.bg = fpp:CreateTexture(nil, "PARENT")
    fpp.bg:SetTexture(DB.Statusbar)
    fpp.bg:ClearAllPoints()
    fpp.bg:SetAllPoints(fpp)
    fpp.bg:SetVertexColor(.30,.45,.65)
    local h2 = CreateFrame("Frame",nil,fpp)
    h2:SetBackdrop(backdrop_tab)
    h2:SetPoint("TOPLEFT",-3.5,5)
    h2:SetPoint("BOTTOMRIGHT",3.5,-5)
    h2:SetBackdropColor(0,0,0,0)
    h2:SetBackdropBorderColor(0,0,0,1)

    fhp:RegisterEvent('PLAYER_TARGET_CHANGED')
    fhp:SetScript('OnEvent', function(self)
      if UnitExists("target") then
        self:Hide()
      else
        self:Show()
      end
    end)
  end
  -- oUF_CombatFeedback
  lib.gen_combat_feedback = function(f)
	if EnableCombatFeedback then
		local h = CreateFrame("Frame", nil, f.Health)
		h:SetAllPoints(f.Health)
		h:SetFrameLevel(30)
		local cfbt = lib.gen_fontstring(h, DB.Font, (C["FontSize"]+4)*S.Scale(1), "THINOUTLINE")
		cfbt:SetPoint("CENTER", f.Health, "BOTTOM", 0, -1)
		cfbt.maxAlpha = 0.75
		cfbt.ignoreEnergize = true
		f.CombatFeedbackText = cfbt
	end
  end
  -- oUF_Swing
  lib.gen_swing_timer = function(f)
	if C["EnableSwingTimer"] then
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
		lib.gen_backdrop(sw.bd)
		sw.Text = lib.gen_fontstring(sw, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
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

	apb.bg = apb:CreateTexture(nil, "BORDER")
	apb.bg:SetAllPoints(apb)
	apb.bg:SetTexture(DB.Statusbar)
	apb.bg:SetVertexColor(.18, .18, .18, 1)
	f.AltPowerBar = apb
	
	apb.b = CreateFrame("Frame", nil, apb)
	apb.b:SetFrameLevel(f.Health:GetFrameLevel() + 1)
	apb.b:SetPoint("TOPLEFT", apb, "TOPLEFT", -4, 4)
	apb.b:SetPoint("BOTTOMRIGHT", apb, "BOTTOMRIGHT", 4, -5)
	apb.b:SetBackdrop(backdrop_tab)
	apb.b:SetBackdropColor(0, 0, 0, 0)
	apb.b:SetBackdropBorderColor(0,0,0,1)
	
	apb.v = lib.gen_fontstring(apb, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
	apb.v:SetPoint("CENTER", apb, "CENTER", 0, 0)
	f:Tag(apb.v, '[mono:altpower]')
  end
    end
  --hand the lib to the namespace for further usage
  ns.lib = lib
