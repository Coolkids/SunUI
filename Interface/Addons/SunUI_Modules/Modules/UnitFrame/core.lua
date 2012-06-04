local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF 
local lib = ns.lib
local S, C, L, DB = unpack(SunUI)
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("UnitFrame")
 
local showfaketarget = false -- fake target bars that spawn if you don't have anything targeted
function Module:OnInitialize()
C = C["UnitFrameDB"]
  -- compatibility with older versions cfg
--if not FTpos then FTpos = {"TOPLEFT", "oUF_monoTargetFrame", "BOTTOMLEFT", 0, -37} end
  -----------------------------
  -- STYLE FUNCTIONS
  -----------------------------
	local BarFader = function(self) 
         self.BarFade = C["EnableBarFader"]
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
	if C["ReverseHPbars"] then 
		if C["ClassColor"] then 
			self.colors.smooth = {DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b,DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b,DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b}
		else
			self.colors.smooth = {1,0,0,199/255,97/255,20/255, 0.1,0.1,0.1} 
		end
	else 
		if C["ClassColor"] then 
			self.colors.smooth = {DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b,DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b,DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b}
		else
			--self.colors.smooth = {1,0,0, .7,.41,.44, .3,.3,.3}
			
			self.colors.smooth = {1,0,0,1,1,0,0,0.5,0.5}
		end
	end
    self.Health.colorSmooth = true
	--self.Health.colorHealth = true self.colors.health = {.6,.3,.3}
	self.Health.multiplier = 0.3
	self.Health.colorDisconnected = true
  end

  --the player style
  local function CreatePlayerStyle(self, unit)
    self.width = C["Width"]
    self.height = C["Height"]
    self.mystyle = "player"
    genStyle(self)
	BarFader(self)
    self.Health.Smooth = true
    self.Power.frequentUpdates = true
    self.Power.Smooth = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
    lib.gen_castbar(self)
    lib.gen_portrait(self)
    lib.gen_ppstrings(self)
	lib.gen_classpower(self)
	--lib.gen_sppower(self)
    lib.gen_TotemBar(self)
    lib.gen_InfoIcons(self)
    --lib.gen_specificpower(self)
    --lib.gen_combat_feedback(self)
	--lib.gen_EclipseBar(self)
	lib.gen_alt_powerbar(self)
    lib.createAuras(self)
	lib.createBuffs(self)
    lib.createDebuffs(self)
	lib.gen_swing_timer(self)
    self:Size(self.width,self.height)
  end  
  
  --the target style
  local function CreateTargetStyle(self, unit)
    self.width = C["Width"]
    self.height = C["Height"]
    self.mystyle = "target"
    genStyle(self)
	if C["ClassColor"] then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
    self.Health.Smooth = true
    self.Power.frequentUpdates = true
    self.Power.Smooth = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
	self.Health.colorTapping = true
    lib.gen_castbar(self)
    lib.gen_portrait(self)
	if C["TargetAura"] ~= 2 then
		lib.createAuras(self)
	end
    lib.gen_ppstrings(self)
	lib.gen_alt_powerbar(self)
    lib.gen_cp(self)
	--lib.gen_lifebloom(self)
	--lib.gen_combat_feedback(self)
    --if showfaketarget then lib.gen_faketarget(self) end
	self:Size(self.width,self.height)
	if C["TargetAura"] == 3 then self.Auras.onlyShowPlayer = true print("1") end
  end  
  
  --the tot style
  local function CreateToTStyle(self, unit)
    self.width = C["PetWidth"]
    self.height = C["PetHeight"]
    self.mystyle = "tot"
    genStyle(self)
    if C["ClassColor"] then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
    self.Power.colorPower = true
    self.Power.multiplier = 0.3	
	self:Size(self.width,self.height)
  end 
  
  --the pet style
  local function CreatePetStyle(self, unit)
    self.width = C["PetWidth"]
    self.height = C["PetHeight"]
    self.mystyle = "pet"
    self.disallowVehicleSwap = true
    genStyle(self)
    self.Power.frequentUpdates = true
	self.Power.Smooth = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
    lib.gen_castbar(self)
    lib.createDebuffs(self)
	self:Size(self.width,self.height)
  end  

  --the focus style
  local function CreateFocusStyle(self, unit)
	if C["BigFocus"] then
		self.width =C["BossWidth"]
		self.height = C["BossHeight"]
	else
		self.width = C["PetWidth"]
		self.height = C["PetHeight"]
	end
    self.mystyle = "focus"
    genStyle(self)
	if C["ClassColor"] then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
    self.Power.frequentUpdates = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
    lib.gen_castbar(self)
	lib.createDebuffs(self)
	--self.Debuffs.onlyShowPlayer = true
	self:Size(self.width,self.height)
  end
  
  --partypet style
  local function CreatePartyPetStyle(self)
    self.width = C["BossHeight"]+C["BossHeight"]/3+3
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
    self.width = C["BossWidth"]
    self.height = C["BossHeight"]
    self.mystyle = "party"
    genStyle(self)
	if C["ClassColor"] then
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
    --lib.gen_portrait(self)
    lib.createBuffs(self)
    lib.createDebuffs(self)
    lib.gen_InfoIcons(self)
    lib.gen_targeticon(self)
	lib.gen_LFDindicator(self)
	lib.gen_specificpower(self)
  end  
  
  --arena frames
  local function CreateArenaStyle(self, unit)
    self.width =C["BossWidth"]
    self.height = C["BossHeight"]
    self.mystyle = "arena"
    genStyle(self)
    self.Health.Smooth = true
	if C["ClassColor"] then
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
    lib.gen_castbar(self)
    lib.gen_arenatracker(self)
    lib.gen_targeticon(self)
	self:Size(self.width,self.height)
  end

  --mini arena targets
  local function CreateArenaTargetStyle(self, unit)
    self.width = C["BossHeight"]+C["BossHeight"]/3+3
    self.height = self.width
    self.mystyle = "arenatarget"
    genStyle(self)
    
	self:Size(self.width,self.height)
  end  
  
  --boss frames
  local function CreateBossStyle(self, unit)
    self.width = C["BossWidth"]
    self.height = C["BossHeight"]
    self.mystyle = "boss"
    genStyle(self)
	if C["ClassColor"] then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
    self.Power.frequentUpdates = true
    self.Power.colorPower = true
    self.Power.multiplier = 0.3
	lib.createBuffs(self)
	lib.createDebuffs(self)
	self.Debuffs.onlyShowPlayer = true
    lib.gen_castbar(self)
	lib.gen_alt_powerbar(self)
	self:Size(self.width,self.height)
  end  

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
  player:SetScale(C["Scale"])
  MoveHandle.SunUIPlayerFrame = S.MakeMove(player, "SunUI_PlayerFrame", "PlayerFrame", C["Scale"])
  
  self:SetActiveStyle("SunUITarget")
  local target = self:Spawn("target", "oUF_SunUITarget")
  target:SetScale(C["Scale"])
  MoveHandle.SunUITargetFrame = S.MakeMove(target, "SunUI_TargetFrame", "TargetFrame", C["Scale"])
  
  if C["showtot"] then
    self:SetActiveStyle("SunUIToT")
    local tot = self:Spawn("targettarget", "oUF_SunUIToT")
	tot:SetScale(C["PetScale"])
	MoveHandle.SunUIToTFrame = S.MakeMove(tot, "SunUI_ToTFrame", "ToTFrame", C["PetScale"])
  end
  
  if C["showfocus"] then
    self:SetActiveStyle("SunUIFocus")
    local focus = self:Spawn("focus", "oUF_SunUIFocus")
	focus:SetScale(C["PetScale"])
	MoveHandle.SunUIFocusFrame = S.MakeMove(focus, "SunUI_FocusFrame", "FocusFrame", C["PetScale"])
	
	self:SetActiveStyle("SunUIFocusTarget")
	local focust = self:Spawn("focustarget", "oUF_SunUIFocusTarget")
	focust:SetScale(C["PetScale"])
	MoveHandle.SunUIFocusTFrame = S.MakeMove(focust, "SunUI_FocusTargetFrame", "FocusTFrame", C["PetScale"])
  else
    oUF:DisableBlizzard'focus'
  end
  
  if C["showpet"] then
    self:SetActiveStyle("SunUIPet")
    local pet = self:Spawn("pet", "oUF_SunUIPet")
	pet:SetScale(C["PetScale"])
	MoveHandle.SunUIPetFrame = S.MakeMove(pet, "SunUI_PetFrame", "PetFrame", C["PetScale"])
  end
  
  local w = C["BossWidth"]
  local h = C["BossHeight"]
  local s = C["BossScale"]
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
  local visible = 'custom [group:party,nogroup:raid][@raid6,noexists,group:raid] show;hide'
  --local visible = 'raid, party'
  if C["showparty"] then
    self:SetActiveStyle("SunUIParty") 
    local party = self:SpawnHeader("SunUIParty",nil,visible,
	'oUF-initialConfigFunction', init:format(w,h,s,ph,ph),
	'showParty',true,
	'template','oUF_SunUIPartyPet',
	--'useOwnerUnit', true, 
	'yOffset', -40)
	party:SetScale(C["BossScale"])
    MoveHandle.SunUIPartyFrame = S.MakeMove(party, "SunUI_PartyFrame", "PartyFrame", C["BossScale"])
  --else
    oUF:DisableBlizzard'party'
  end
  
  local gap = 66
  if C["showarena"] and not IsAddOnLoaded('Gladius') then
    SetCVar("showArenaEnemyFrames", false)
    self:SetActiveStyle("SunUIArena")
    local arena = {}
    local arenatarget = {}
    for i = 1, 5 do
      arena[i] = self:Spawn("arena"..i, "oUF_SunUIArena"..i)
	  arena[i]:SetScale(C["BossScale"])
      if i == 1 then
        MoveHandle.SunUIArenaFrame = S.MakeMove(arena[i], "SunUIArena"..i, "ArenaFrame", C["BossScale"])
      else
        arena[i]:SetPoint("BOTTOMRIGHT", arena[i-1], "BOTTOMRIGHT", 0, gap)
      end
    end
    self:SetActiveStyle("SunUIArenaTarget")
    for i = 1, 5 do
      arenatarget[i] = self:Spawn("arena"..i.."target", "oUF_Arena"..i.."target")
	  arenatarget[i]:SetPoint("TOPRIGHT",arena[i], "TOPLEFT", -4, 0)
	  arenatarget[i]:SetScale(C["BossScale"])
    end
  end

  if C["showboss"] then
    self:SetActiveStyle("SunUIBoss")
    local boss = {}
    for i = 1, MAX_BOSS_FRAMES do
      boss[i] = self:Spawn("boss"..i, "oUF_Boss"..i)
	  boss[i]:SetScale(C["BossScale"])
      if i == 1 then
		MoveHandle.SunUIBossFrame = S.MakeMove(boss[i], "SunUIBoss"..i, "BossFrame", C["BossScale"])
      else
        boss[i]:SetPoint("BOTTOMRIGHT", boss[i-1], "BOTTOMRIGHT", 0, gap)
      end
    end
  end
end)  
end