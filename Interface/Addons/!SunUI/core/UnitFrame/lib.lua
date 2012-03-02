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
    s:Height(f.height)
    s:Width(f.width)
    s:Point("TOPLEFT",0,0)
    --s:SetAlpha(0.5)
    s:SetOrientation("HORIZONTAL") 
	s:SetFrameLevel(5)
    --shadow backdrop
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:Point("TOPLEFT",0,0)
    h:Point("BOTTOMRIGHT",0,0)
	--S.MakeShadow(h, 6)
	--S.MakeBG(h, 0)
	h:CreateShadow("Background")
    --lib.gen_backdrop(h)
    --bar bg
	local bg = CreateFrame("Frame", nil, s)
	bg:SetFrameLevel(s:GetFrameLevel()-2)
    bg:SetAllPoints(s)
    local b = bg:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(DB.Statusbar)
	b:SetAlpha(0)
    b:SetAllPoints(s)
	-- threat border
	if f.mystyle == "party" then
		bg.t = CreateFrame("Frame", nil,bg)
		bg.t:Point("TOPLEFT", bg, "TOPLEFT", -1, 1)
		bg.t:Point("BOTTOMRIGHT", bg, "BOTTOMRIGHT", 1, -1)
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
    p:Width(f.width-2)
    p:Height(f.height-2)
    p:Point("TOP", s, "TOP", 0, -2)
	p:SetAlpha(.0)
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
      name:Point("RIGHT", f.Health, "RIGHT",-3,0)
      hpval:Point("LEFT", f.Health, "LEFT",3,0)
      name:SetJustifyH("RIGHT")
      name:Point("LEFT", hpval, "RIGHT", 5, 0)
    elseif f.mystyle == "arenatarget" or f.mystyle == "partypet" then
      name:Point("CENTER", f.Health, "CENTER",0,6)
      name:SetJustifyH("LEFT")
      hpval:Point("CENTER", f.Health, "CENTER",0,-6)
    else
      name:Point("LEFT", f.Health, "LEFT",3,0)
      hpval:Point("RIGHT", f.Health, "RIGHT",-3,0)
      name:SetJustifyH("LEFT")
      name:Point("RIGHT", hpval, "LEFT", -5, 0)
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
    s:Height(f.height/3)
    s:Width(f.width-1)
    s:Point("TOPLEFT",f,"BOTTOMLEFT",2,-2)
    if f.mystyle == "partypet" or f.mystyle == "arenatarget" then
      s:Hide()
    end
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:Point("TOPLEFT",-2,0)
    h:Point("BOTTOMRIGHT",0,2)
    --lib.gen_backdrop(h)
    --bg
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(DB.Statusbar)
	b:SetAlpha(.0)
    b:SetAllPoints(s)
    if f.mystyle=="tot" or f.mystyle=="pet" then
      s:Height(f.height/3)
    end
	h:CreateShadow("Background")
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
    local pp = lib.gen_fontstring(h, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
    local info = lib.gen_fontstring(h, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
    if f.mystyle == "target" or f.mystyle == "tot" then
        info:Point("RIGHT", f.Power, "RIGHT",-3,0)
        pp:Point("LEFT", f.Power, "LEFT",3,0)
        info:SetJustifyH("RIGHT")
    else
        info:Point("LEFT", f.Power, "LEFT",3,0)
        pp:Point("RIGHT", f.Power, "RIGHT",-5,0)
        info:SetJustifyH("LEFT")
    end
	--resting indicator for player frame
	if f.mystyle == "player" then
		local ri = lib.gen_fontstring(f.Power, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
		ri:Point("LEFT", info, "RIGHT",2,0)
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
    s:SetStatusBarTexture(DB.bar_texture)
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
    h:Point("TOPLEFT",0,0)
    h:Point("BOTTOMRIGHT",0,0)
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
    sp:Height(s:GetHeight()*2.5)--]]
	--spark
	local sp =  s:CreateTexture(nil, "OVERLAY")
	sp:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
	sp:SetBlendMode("ADD")
	sp:SetAlpha(.8)
	sp:Point("TOPLEFT", s:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
	sp:Point("BOTTOMRIGHT", s:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)
    --spell text
    local txt = lib.gen_fontstring(s, DB.Font, (C["FontSize"]+1)*S.Scale(1), "THINOUTLINE")
    txt:Point("LEFT", 2, s:GetHeight()/2)
    txt:SetJustifyH("LEFT")
    --time
    local t = lib.gen_fontstring(s, DB.Font, (C["FontSize"]+1)*S.Scale(1), "THINOUTLINE")
    t:Point("RIGHT", -2, s:GetHeight()/2)
    txt:Point("RIGHT", t, "LEFT", -5, 0)
    --icon
    local i = s:CreateTexture(nil, "ARTWORK")
    --i:Size(s:GetHeight()+4,s:GetHeight()+4)
	i:Size(s:GetHeight(),s:GetHeight())
    i:Point("BOTTOMRIGHT", s, "BOTTOMLEFT", -6, 0)
    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	S.MakeTexShadow(s, i, 3)
    --helper2 for icon
    local h2 = CreateFrame("Frame", nil, s)
    h2:SetFrameLevel(0)
    h2:Point("TOPLEFT",i,"TOPLEFT",-5,5)
    h2:Point("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h2)
    if f.mystyle == "focus" and not C["focusCBuserplaced"] then
      s:Point("BOTTOM", "Castbarfouce", "BOTTOM", 0, 0)
      s:Size(C["FocusCastBarWidth"],C["FocusCastBarHeight"])
      i:Point("RIGHT", s, "LEFT", 0, 0)
      sp:Height(s:GetHeight()*2.5)
    elseif f.mystyle == "pet" then
      s:Point("BOTTOMRIGHT",f.Power,"BOTTOMRIGHT",0,0)
      s:SetScale(f:GetScale())
      s:Size(f.width-f.height/2,f.height/2.5)
      i:Point("RIGHT", s, "LEFT", -2, 0)
      h2:SetFrameLevel(9)
      b:Hide() txt:Hide() t:Hide() h:Hide()
    elseif f.mystyle == "arena" then
      s:Size(f.width-(f.height/1.4+4),f.height/1.4)
      s:Point("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
      i:Point("RIGHT", s, "LEFT", -4, 0)
      i:Size(s:GetHeight(),s:GetHeight())
    elseif f.mystyle == "player" then
	  if not C["playerCBuserplaced"] then
		s:Size(C["PlayerCastBarWidth"],C["PlayerCastBarHeight"])
		s:Point("BOTTOM", "Castbarplay", "BOTTOM", 0, 0)
		i:Size((s:GetHeight()+2)*2,(s:GetHeight()+2)*2)
		sp:Height(s:GetHeight()*2.5)
	  else
		s:Point("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
	  end
      --latency only for player unit
	  local z = s:CreateTexture(nil, "OVERLAY")
	  z:SetBlendMode("ADD")
      z:SetTexture(DB.Statusbar)
	  --z:Width(1) -- it should never fill the entire castbar when GetNetStats() returns 0
      z:SetVertexColor(.8,.31,.45)
      z:Point("TOPRIGHT")
      z:Point("BOTTOMRIGHT")
	  --if UnitInVehicle("player") then z:Hide() end
      s.SafeZone = z
      --custom latency display
      local l = lib.gen_fontstring(s, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
      l:Point("RIGHT", 0, -s:GetHeight())
      l:SetJustifyH("RIGHT")
	  l:SetTextColor(.8,.31,.45)
      s.Lag = l
      f:RegisterEvent("UNIT_SPELLCAST_SENT", cast.OnCastSent)
	elseif f.mystyle == "target" and not C["targetCBuserplaced"] then
	  s:Size(C["TargetCastBarWidth"],C["TargetCastBarHeight"])
	  s:Point("BOTTOM", "Castbartarget", "BOTTOM", 0, 0)
	  i:Size(s:GetHeight()*2,s:GetHeight()*2)
      sp:Height(s:GetHeight()*2.5)
	else
      s:Point("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
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
  lib.gen_mirrorcb = function(f)
    for _, bar in pairs({'MirrorTimer1','MirrorTimer2','MirrorTimer3',}) do   
      for i, region in pairs({_G[bar]:GetRegions()}) do
        if (region.GetTexture and region:GetTexture() == 'SolidTexture') then
          region:Hide()
        end
      end
      _G[bar..'Border']:Hide()
      _G[bar]:SetParent(UIParent)
      _G[bar]:SetScale(1)
      _G[bar]:Height(16)
      _G[bar]:SetBackdropColor(.1,.1,.1)
      _G[bar..'Background'] = _G[bar]:CreateTexture(bar..'Background', 'BACKGROUND', _G[bar])
      _G[bar..'Background']:SetTexture(DB.Statusbar)
      _G[bar..'Background']:SetAllPoints(bar)
      _G[bar..'Background']:SetVertexColor(.15,.15,.15,1)
      _G[bar..'Text']:SetFont(DB.Font, (C["FontSize"]+2)*S.Scale(1))
      _G[bar..'Text']:ClearAllPoints()
      _G[bar..'Text']:Point('CENTER', _G[bar..'StatusBar'], 0, 0)
	  _G[bar..'StatusBar']:SetAllPoints(_G[bar])
      --glowing borders
      local h = CreateFrame("Frame", nil, _G[bar])
      h:SetFrameLevel(0)
      h:Point("TOPLEFT",-4,4)
      h:Point("BOTTOMRIGHT",4,-4)
      lib.gen_backdrop(h)
    end
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
      if s <= minute * 5 then
        return format('%d:%02d', floor(s/60), s % minute), s - floor(s)
      end
      return format("%dm", floor(s/minute + 0.5)), s % minute
    elseif s >= minute / 12 then
      return floor(s + 0.5), (s * 100 - floor(s * 100))/100
    end
    return format("%.1f", s), (s * 100 - floor(s * 100))/100
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
        if self.timeLeft > 0 and w > 19 then
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
    if unit == 'player' or unit == 'target' or (unit:match'(boss)%d?$' == 'boss') then
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
    button.count:ClearAllPoints()
    button.count:SetJustifyH("RIGHT")
    button.count:Point("BOTTOMRIGHT", 2, -2)
    button.count:SetTextColor(1,1,1)
    --helper
    local h = CreateFrame("Frame", nil, button)
    h:SetFrameLevel(0)
    h:Point("TOPLEFT",-4,4)
    h:Point("BOTTOMRIGHT",4,-4)
    lib.gen_backdrop(h)
    --another helper frame for our fontstring to overlap the cd frame
    local h2 = CreateFrame("Frame", nil, button)
    h2:SetAllPoints(button)
    h2:SetFrameLevel(10)
    button.remaining = lib.gen_fontstring(h2, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
	--button.remaining:SetShadowColor(0, 0, 0)--button.remaining:SetShadowOffset(2, -1)
    button.remaining:Point("TOPLEFT", 0, -0.5)
    --overlay texture for debuff types display
    --button.overlay:SetTexture(DB.Auratex)
    button.overlay:Point("TOPLEFT", button, "TOPLEFT", -1, 1)
    button.overlay:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    button.overlay:SetTexCoord(0.04, 0.96, 0.04, 0.96)
    button.overlay.Hide = function(self) self:SetVertexColor(0, 0, 0) end
	S.MakeTexShadow(button, button.overlay, 3)
  end
  -- position update for certain class/specs
--[[   lib.PreSetPosition = function(self, num)
	local f = self:GetParent()
	local pttree = GetPrimaryTalentTree(false, false, GetActiveTalentGroup())
	if f.mystyle=="player" and ((class=="DRUID" and pttree == 1) or class == "DEATHKNIGHT" or (class == "SHAMAN" and IsAddOnLoaded("oUF_boring_totembar"))) then
		self:Point('BOTTOMLEFT', f, 'TOPLEFT', 1, 6+f.height/3)
	else
		self:Point('BOTTOMLEFT', f, 'TOPLEFT', 1.5, 4)
	end
  end ]]
  --auras for certain frames
  lib.createAuras = function(f)
    a = CreateFrame('Frame', nil, f)
    a:Point('TOPLEFT', f, 'TOPRIGHT', 7, 0)
    a['growth-x'] = 'RIGHT'
    a['growth-y'] = 'DOWN' 
    a.initialAnchor = 'TOPLEFT'
    a.gap = true
    a.spacing = 6
    a.size = 23
    a.showDebuffType = true
    if f.mystyle=="target" then
      a:Height((a.size+a.spacing)*2)
      a:Width((a.size+a.spacing)*8)
      a.numBuffs = 8 
      a.numDebuffs = 8
	elseif f.mystyle=="player" and DB.playerauras=="AURAS" then
	  a.gap = false
      a['growth-x'] = 'LEFT'
      a['growth-y'] = 'DOWN' 
      a.initialAnchor = 'TOPLEFT'
      a:Height((a.size+a.spacing)*2)
      a:Width((a.size+a.spacing)*8)
      a.numBuffs = 15 
      a.numDebuffs = 15
	  a:Point('TOPLEFT', f, 'TOPLEFT', -a.size-5, -1)
    elseif f.mystyle=="focus" then
      a:Height((a.size+a.spacing)*2)
      a:Width((a.size+a.spacing)*4)
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
    b.size = 19
    b.spacing = 6
    b:Height((b.size+b.spacing)*2)
    b:Width((b.size+b.spacing)*12)
    if f.mystyle=="tot" then
      b.initialAnchor = "TOPRIGHT"
      b:Point("TOPRIGHT", f, "TOPLEFT", -b.spacing, -2)
      b["growth-x"] = "LEFT"
    elseif f.mystyle=="pet" then
      b:Point("TOPLEFT", f, "TOPRIGHT", b.spacing, -2)
    elseif f.mystyle=="arena" then
      b.showBuffType = true
      b:Point("TOPLEFT", f, "TOPRIGHT", b.spacing, -2)
	  b.size = 18
      b.num = 5
      b:Width((b.size+b.spacing)*4)
	elseif f.mystyle=="boss" then
      b.showBuffType = true
      b:Point("TOPLEFT", f, "TOPRIGHT", b.spacing, -2)
	  b.size = 18
      b.num = 4
      b:Width((b.size+b.spacing)*4)
    elseif f.mystyle=='party' then
      b:Point("TOPLEFT", f.Power, "BOTTOMLEFT", 0, -b.spacing)
	  b.size = 19
      b.num = 8
	elseif f.mystyle=="player" and DB.playerauras=="BUFFS" then
	  b['growth-x'] = 'LEFT'
      b['growth-y'] = 'DOWN' 
      b.initialAnchor = 'TOPRIGHT'
	  b.num = 8
	  b.size = 23
      b:Height((b.size+b.spacing)*2)
      b:Width((b.size+b.spacing)*8)
	  b:Point("TOPRIGHT", f, "TOPLEFT", -5, -1)
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
    d.num = 10
    d.size = 19
    d.spacing = 5
    d:Height((d.size+d.spacing)*2)
    d:Width((d.size+d.spacing)*5)
    d.showDebuffType = true
    if f.mystyle=="tot" then
      d:Point("TOPLEFT", f, "TOPRIGHT", d.spacing, -2)
      d.initialAnchor = "TOPLEFT"
    elseif f.mystyle=="pet" then
      d:Point("TOPRIGHT", f, "TOPLEFT", -d.spacing, -2)
      d["growth-x"] = "LEFT"
    elseif f.mystyle=="arena" then
      d.showDebuffType = false
      d.initialAnchor = "TOPLEFT"
      d.num = 4
	  d.size = 18
	  d:Point('TOPLEFT', f, 'TOPRIGHT', 2, 0)
      d:Width((d.size+d.spacing)*4)
--[[     elseif f.mystyle=="boss" then
      d.showDebuffType = false
      d.initialAnchor = "TOPLEFT"
      d.num = 4
	  d.size = 18
	  d:Point("TOPRIGHT", f, "TOPLEFT", d.spacing, -2)
      d:Width((d.size+d.spacing)*4) ]]
    elseif f.mystyle=='party' then
      d:Point("TOPRIGHT", f, "TOPLEFT", -d.spacing, -2)
	  d.num = 8
	  d.size = 18
      d["growth-x"] = "LEFT"
      d:Width((d.size+d.spacing)*4)
	elseif f.mystyle=="player" and DB.playerauras=="DEBUFFS" then
	  d['growth-x'] = 'RIGHT'
      d['growth-y'] = 'UP' 
      d.initialAnchor = 'BOTTOMLEFT'
	  d.num = 8
	  d.size = 23
      d:Height((d.size+d.spacing)*2)
      d:Width((d.size+d.spacing)*8)
	  d:Point("BOTTOMLEFT", f, "TOPLEFT", 0, 10)
	  --d.PreSetPosition = lib.PreSetPosition
    end
    d.PostCreateIcon = lib.PostCreateIcon
    d.PostUpdateIcon = lib.PostUpdateIcon
    f.Debuffs = d
  end

------ [Extra functionality]
  --gen DK runes
  lib.gen_Runes = function(f)
    if class ~= "DEATHKNIGHT" then return
    else
      local runeloadcolors = {
      [1] = {0.59, 0.31, 0.31},
      [2] = {0.59, 0.31, 0.31},
      [3] = {0.33, 0.51, 0.33},
      [4] = {0.33, 0.51, 0.33},
      [5] = {0.31, 0.45, 0.53},
      [6] = {0.31, 0.45, 0.53},}
      f.Runes = CreateFrame("Frame", nil, f)
      for i = 1, 6 do
        r = CreateFrame("StatusBar", f:GetName().."_Runes"..i, f)
        r:Size(f.width/6 - 2, f.height/3)
        if (i == 1) then
          r:Point("BOTTOMLEFT", f, "TOPLEFT", 1, 3)
        else
          r:Point("TOPLEFT", f.Runes[i-1], "TOPRIGHT", 2, 0)
        end
        r:SetStatusBarTexture(DB.Statusbar)
        r:GetStatusBarTexture():SetHorizTile(false)
        r:SetStatusBarColor(unpack(runeloadcolors[i]))
        r.bd = r:CreateTexture(nil, "BORDER")
        r.bd:SetAllPoints()
        r.bd:SetTexture(DB.Statusbar)
        r.bd:SetVertexColor(0.15, 0.15, 0.15)
        f.b = CreateFrame("Frame", nil, r)
        f.b:Point("TOPLEFT", r, "TOPLEFT", -4, 4)
        f.b:Point("BOTTOMRIGHT", r, "BOTTOMRIGHT", 4, -5)
        f.b:SetBackdrop(backdrop_tab)
        f.b:SetBackdropColor(0, 0, 0, 0)
        f.b:SetBackdropBorderColor(0,0,0,1)
        f.Runes[i] = r
      end
    end
  end
  --gen eclipse bar
  lib.gen_EclipseBar = function(f)
	if class ~= "DRUID" then return end
	local eb = CreateFrame('Frame', nil, f)
	eb:Point('BOTTOMLEFT', f, 'TOPLEFT', -3, -1)
	eb:Size(f.width+7, 20)
	lib.gen_backdrop(eb)
	local lb = CreateFrame('StatusBar', nil, eb)
	lb:Point('LEFT', eb, 'LEFT', 4, 0)
	lb:Size(f.width-2, 10)
	lb:SetStatusBarTexture(DB.Statusbar)
	lb:SetStatusBarColor(0.27, 0.47, 0.74)
	eb.LunarBar = lb
	local sb = CreateFrame('StatusBar', nil, eb)
	sb:Point('LEFT', lb:GetStatusBarTexture(), 'RIGHT', 0, 0)
	sb:Size(f.width-2, 10)
	sb:SetStatusBarTexture(DB.Statusbar)
	sb:SetStatusBarColor(0.9, 0.6, 0.3)
	eb.SolarBar = sb
  	local h = CreateFrame("Frame", nil, eb)
	h:SetAllPoints(eb)
	h:SetFrameLevel(30)
 	--[[local ebText = lib.gen_fontstring(h, DB.Font, 20, "THINOUTLINE")
	ebText:Point('CENTER', eb, 'CENTER', 0, 0)
	eb.Text = ebText]]
	f.EclipseBar = eb
	local ebInd = lib.gen_fontstring(h, DB.Font, (C["FontSize"]+4)*S.Scale(1), "THINOUTLINE")
	ebInd:Point('CENTER', eb, 'CENTER', 0, 0)
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
		TotemBar:Point("BOTTOMLEFT", f, "TOPLEFT", 1, 3)
		TotemBar.Destroy = true
		TotemBar.UpdateColors = true
		TotemBar.AbbreviateNames = true
		for i = 1, 4 do
			local t = CreateFrame("Frame", nil, TotemBar)
			t:Point("LEFT", (i - 1) * (width + 3.5), 0)
			t:Width(width)
			t:Height(height)
			local bar = CreateFrame("StatusBar", nil, t)
			bar:Width(width)
			bar:Point"BOTTOM"
			bar:Height(8)
			t.StatusBar = bar
			local h = CreateFrame("Frame",nil,t)
			h:SetFrameLevel(10)
			local time = lib.gen_fontstring(h, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
			time:Point("BOTTOMRIGHT",t,"TOPRIGHT", 0, -1)
			time:SetFontObject"GameFontNormal"
			t.Time = time
			local text = lib.gen_fontstring(h, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
			text:Point("BOTTOMLEFT", t, "TOPLEFT", 0, -1)
			--text:SetFontObject"GameFontNormal"
			t.Text = text
	        t.bg = CreateFrame("Frame", nil, t)
			t.bg:Point("TOPLEFT", t, "TOPLEFT", -4, 5)
			t.bg:Point("BOTTOMRIGHT", t, "BOTTOMRIGHT", 4, -5)
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
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(10)
	if f.mystyle == "party" then
		local es = lib.gen_fontstring(h, DB.Font, (C["FontSize"]+2)*S.Scale(1), "THINOUTLINE")
		es:Point("CENTER", f.Power, "BOTTOMRIGHT",0,0)	
		if class == "SHAMAN" then
			f:Tag(es, '[raid:earth]')
		elseif class == "DRUID" then
			f:Tag(es, '[raid:lb]')
		elseif class == "PRIEST" then
			f:Tag(es, '[raid:pom]')
		end
	end
	if f.mystyle == "player" then
		local sp = lib.gen_fontstring(h, DB.Font, 30*S.Scale(1), "OUTLINE")
		sp:Point("TOPLEFT", f.Health, "BOTTOMLEFT",0,0)
		sp:Point("BOTTOMRIGHT", f.Health, "BOTTOMRIGHT",0,-5)
		sp:Width(f.Health:GetWidth())
		sp:SetJustifyH("LEFT")
		if class == "DRUID" then
			f:Tag(sp, '[mono:wm1][mono:wm2][mono:wm3]')
		elseif class == "PRIEST" then
			f:Tag(sp, '[mono:orbs]')
		elseif class == "PALADIN" or class == "WARLOCK" then
			f:Tag(sp, '[mono:sp]')
		elseif class == "SHAMAN" then
			f:Tag(sp, '[mono:ws][mono:ls]')
		end
	end
  end
  --gen combo points
  lib.gen_cp = function(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(10)
    local cp = lib.gen_fontstring(h, DB.Font, 20*S.Scale(1), "THINOUTLINE")
    cp:Point("CENTER", f.Health, "CENTER",0,0)
	cp:SetJustifyH("CENTER")
    f:Tag(cp, '[mono:cp]')
  end
  --gen LFD role indicator
  lib.gen_LFDindicator = function(f)
    local lfdi = lib.gen_fontstring(f.Power, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
    lfdi:Point("LEFT", f.Power, "LEFT",1,0)
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
		f.Combat:Point('TOPRIGHT', 3, 9)
    end
    --Leader icon
    li = h:CreateTexture(nil, "OVERLAY")
    li:Point("TOPLEFT", f, 0, 6)
    li:Size(12,12)
    f.Leader = li
    --Assist icon
    ai = h:CreateTexture(nil, "OVERLAY")
    ai:Point("TOPLEFT", f, 0, 6)
    ai:Size(12,12)
    f.Assistant = ai
    --ML icon
    local ml = h:CreateTexture(nil, 'OVERLAY')
    ml:Size(12,12)
    ml:Point('LEFT', f.Leader, 'RIGHT')
    f.MasterLooter = ml
  end
  --gen raid mark icons
  lib.gen_RaidMark = function(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
    h:SetAlpha(1)
    local ri = h:CreateTexture(nil,'OVERLAY',h)
    ri:Point("CENTER", f, "CENTER", 0, 0)
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
    t:Point("CENTER", f.Power, "CENTER", 0, 0)
    t:SetFrameLevel(30)
    t:SetAlpha(0.8)
    t.trinketUseAnnounce = true
    t.bg = CreateFrame("Frame", nil, t)
    t.bg:Point("TOPLEFT",-4,4)
    t.bg:Point("BOTTOMRIGHT",4,-4)
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
	at.text:Point('CENTER', at, 0, 0)
	at:SetScript('OnUpdate', lib.UpdateAuraTracker)
	f.AuraTracker = at
  end
  --gen current target indicator
  lib.gen_targeticon = function(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(10)
    local ti = lib.gen_fontstring(h, DB.Font, C["FontSize"], "THINOUTLINE")
    ti:Point("LEFT", f.Health, "BOTTOMLEFT",-5,0)
    ti:SetJustifyH("LEFT")
    f:Tag(ti, '[mono:targeticon]')
  end
  --gen fake target bars
  lib.gen_faketarget = function(f)
    local fhp = CreateFrame("frame","FakeHealthBar",UIParent) 
    fhp:SetAlpha(.6)
    fhp:Size(f.width,f.height)
    fhp:Point("TOPLEFT",oUF_monoTargetFrame,"TOPLEFT",0,0)
    fhp.bg = fhp:CreateTexture(nil, "PARENT")
    fhp.bg:SetTexture(DB.Statusbar)
    fhp.bg:ClearAllPoints()
    fhp.bg:SetAllPoints(fhp)
    fhp.bg:SetVertexColor(.3,.3,.3)
    local h = CreateFrame("Frame",nil,fhp)
    h:SetBackdrop(backdrop_tab)
    h:Point("TOPLEFT",-3.5,3.5)
    h:Point("BOTTOMRIGHT",3.5,-3.5)
    h:SetBackdropColor(0,0,0,0)
    h:SetBackdropBorderColor(0,0,0,.7)

    local fpp = CreateFrame("frame","FakeManaBar",fhp)
    fpp:Width(fhp:GetWidth())
    fpp:Height(f.height/3)
    fpp:Point("TOPLEFT",FakeHealthBar,"BOTTOMLEFT",0,-2)
    fpp.bg = fpp:CreateTexture(nil, "PARENT")
    fpp.bg:SetTexture(DB.Statusbar)
    fpp.bg:ClearAllPoints()
    fpp.bg:SetAllPoints(fpp)
    fpp.bg:SetVertexColor(.30,.45,.65)
    local h2 = CreateFrame("Frame",nil,fpp)
    h2:SetBackdrop(backdrop_tab)
    h2:Point("TOPLEFT",-3.5,5)
    h2:Point("BOTTOMRIGHT",3.5,-5)
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
	if DB.EnableCombatFeedback then
		local h = CreateFrame("Frame", nil, f.Health)
		h:SetAllPoints(f.Health)
		h:SetFrameLevel(30)
		local cfbt = lib.gen_fontstring(h, DB.Font, (C["FontSize"]+4)*S.Scale(1), "THINOUTLINE")
		cfbt:Point("CENTER", f.Health, "BOTTOM", 0, -1)
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
		sw:Height(4)
		sw:Width(f.width)
		sw:Point("TOP", f.Power, "BOTTOM", 0, -3)
		sw.bg = sw:CreateTexture(nil, "BORDER")
		sw.bg:SetAllPoints(sw)
		sw.bg:SetTexture(DB.Statusbar)
		sw.bg:SetVertexColor(.1, .1, .1, 0.25)
		sw.bd = CreateFrame("Frame", nil, sw)
		sw.bd:SetFrameLevel(1)
		sw.bd:Point("TOPLEFT", -4, 4)
		sw.bd:Point("BOTTOMRIGHT", 4, -4)
		lib.gen_backdrop(sw.bd)
		sw.Text = lib.gen_fontstring(sw, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
		sw.Text:Point("CENTER", 0, 0)
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
	apb:Point("BOTTOM", f, "TOP", 0, -f.height/6)

	apb.bg = apb:CreateTexture(nil, "BORDER")
	apb.bg:SetAllPoints(apb)
	apb.bg:SetTexture(DB.Statusbar)
	apb.bg:SetVertexColor(.18, .18, .18, 1)
	f.AltPowerBar = apb
	
	apb.b = CreateFrame("Frame", nil, apb)
	apb.b:SetFrameLevel(f.Health:GetFrameLevel() + 1)
	apb.b:Point("TOPLEFT", apb, "TOPLEFT", -4, 4)
	apb.b:Point("BOTTOMRIGHT", apb, "BOTTOMRIGHT", 4, -5)
	apb.b:SetBackdrop(backdrop_tab)
	apb.b:SetBackdropColor(0, 0, 0, 0)
	apb.b:SetBackdropBorderColor(0,0,0,1)
	
	apb.v = lib.gen_fontstring(apb, DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
	apb.v:Point("CENTER", apb, "CENTER", 0, 0)
	f:Tag(apb.v, '[mono:altpower]')
  end
    end
  --hand the lib to the namespace for further usage
  ns.lib = lib
