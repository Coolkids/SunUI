local S, L, DB, _, C = unpack(select(2, ...))
if not IsAddOnLoaded("NugRunning") then return end
local NR = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("NugRunningSkin", "AceEvent-3.0")
--(\d+)(\s*,.+name\s*=\s*)\"[^"]+\"Ìæ»»\1\2GetSpellInfo\(\1\)
NugRunningConfig.nameFont = { font = DB.Font, size = 12, alpha = 0.5 }
NugRunningConfig.timeFont = { font = "interface\\addons\\SunUI\\Media\\font.ttf", size = 12, alpha = 1 }
NugRunningConfig.stackFont = { font = DB.Font, size = 12 }
NugRunningConfig.dotpowerFont = { font = "interface\\addons\\SunUI\\Media\\font.ttf", size = 11,  alpha = 1  }

NugRunningConfig.anchors = {
    main = {
        { name = "player", gap = 6, alpha = 1 },
        { name = "target", gap = 6, alpha = 1},
        { name = "buffs", gap = 6, alpha = 1},
        { name = "offtargets", gap = 6, alpha = .7},
    },
    secondary = {
        { name = "procs", gap = 6, alpha = .8},
    },
}
-- Replace bar creation function
ConstructTimerBar = function(width, height)
    local f = CreateFrame("Frame",nil,UIParent)
    f.prototype = "TimerBar"

    f:SetWidth(width-height)
    f:SetHeight(height+4)
    
    
    local ic = CreateFrame("Frame",nil,f)
    ic:SetPoint("BOTTOMRIGHT",f,"BOTTOMLEFT", -10, 0)
    ic:SetWidth(height+2)
    ic:SetHeight(height+2)
	ic:CreateShadow()
	
    local ict = ic:CreateTexture(nil,"ARTWORK",0)
    ict:SetTexCoord(.07, .93, .07, .93)
    ict:SetAllPoints(ic)
    f.icon = ict
    
    f.stacktext = ic:CreateFontString(nil, "OVERLAY");
    f.stacktext:SetFont(NugRunningConfig.stackFont.font,
                        NugRunningConfig.stackFont.size,
                        "OUTLINE")
    f.stacktext:SetJustifyH("RIGHT")
    f.stacktext:SetVertexColor(1,1,1)
    f.stacktext:SetPoint("LEFT", ic, "RIGHT",-9,-3)
    
    f.bar = CreateFrame("StatusBar",nil,f)
	f.bar:CreateShadow()
	S.CreateBack(f.bar)
	
    f.bar:SetFrameStrata("MEDIUM")
    f.bar:SetStatusBarTexture(DB.Statusbar)
    f.bar:GetStatusBarTexture():SetDrawLayer("ARTWORK")
    f.bar:SetHeight(height/2)
    f.bar:SetWidth(width - height )
	f.bar:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,0)
    S.CreateMark(f.bar)
    
	f.bar.bg = f.bar:CreateTexture(nil, "BORDER")
	f.bar.bg:SetAllPoints(f.bar)
	--f.bar.bg:SetTexture(tex)
    
	f.timeText = f.bar:CreateFontString(nil, "OVERLAY", 2);
    f.timeText:SetFont(NugRunningConfig.timeFont.font, NugRunningConfig.timeFont.size, "THINOUTLINE")
    f.timeText:SetJustifyH("LEFT")
    f.timeText:SetVertexColor(1,1,1)
    f.timeText:SetPoint("LEFT", f.bar, "LEFT",0,height/2)
		
	f.timeText.SetFormattedText = SetTimeText
    
	f.spellText = f.bar:CreateFontString(nil, "OVERLAY", 2);
    f.spellText:SetFont(NugRunningConfig.nameFont.font, NugRunningConfig.nameFont.size, "THINOUTLINE")
    f.spellText:SetWidth(f.bar:GetWidth()*0.7)
    f.spellText:SetHeight(height/2+1)
    f.spellText:SetJustifyH("RIGHT")
    f.spellText:SetPoint("RIGHT", f.bar, "RIGHT",0,height/2)
    f.spellText.SetName = SpellTextUpdate
    
	local overlay = f.bar:CreateTexture(nil, "ARTWORK", nil, 3)
    overlay:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    overlay:SetVertexColor(0,0,0, 0.2)
    overlay:Hide()
    f.overlay = overlay
	
	f.SetColor = TimerBarSetColor
	
	local powertext = f.bar:CreateFontString()
   powertext:SetFont(NugRunningConfig.dotpowerFont.font,
                      NugRunningConfig.dotpowerFont.size,
                      "THINOUTLINE")
    powertext:SetPoint("BOTTOMLEFT", f.bar, "BOTTOMRIGHT",2,0)
	powertext:SetShadowColor(0, 0, 0)
	powertext:SetShadowOffset(S.mult, -S.mult)
	
    local sbg = f.bar:CreateTexture(nil, "ARTWORK", nil, 5)
    sbg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    sbg:SetVertexColor(0,0,0, 0)
    sbg:SetAllPoints(powertext)
    powertext.bg = sbg
    f.status = powertext
	
	
    local at = ic:CreateTexture(nil,"OVERLAY")
    at:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
    at:SetTexCoord(0.00781250,0.50781250,0.27734375,0.52734375)
    at:SetWidth(height*1.8)
    at:SetHeight(height*1.8)
    at:SetPoint("CENTER",f.icon,"CENTER",0,0)
    at:SetAlpha(0)
    
    local sag = at:CreateAnimationGroup()
    local sa1 = sag:CreateAnimation("Alpha")
    sa1:SetChange(1)
    sa1:SetDuration(0.3)
    sa1:SetOrder(1)
    local sa2 = sag:CreateAnimation("Alpha")
    sa2:SetChange(-1)
    sa2:SetDuration(0.5)
    sa2:SetSmoothing("OUT")
    sa2:SetOrder(2)
    
    f.shine = sag
    f.shine.tex = at
    
    local aag = f:CreateAnimationGroup()
    local aa1 = aag:CreateAnimation("Scale")
    aa1:SetOrigin("BOTTOM",0,0)
    aa1:SetScale(1,0.1)
    aa1:SetDuration(0)
    aa1:SetOrder(1)
    local aa2 = aag:CreateAnimation("Scale")
    aa2:SetOrigin("BOTTOM",0,0)
    aa2:SetScale(1,10)
    aa2:SetDuration(0.15)
    aa2:SetOrder(2)
    
    local glow = f:CreateAnimationGroup()
    local ga1 = glow:CreateAnimation("Alpha")
    ga1:SetChange(-0.5)
    ga1:SetDuration(0.25)
    ga1:SetOrder(1)
    glow:SetLooping("BOUNCE")
    f.glow = glow
    
    f.animIn = aag
         
    local m = CreateFrame("Frame",nil,self)
    m:SetParent(f)
    m:SetWidth(16)
    m:SetHeight(f:GetHeight()/2)
    m:SetFrameLevel(4)
    m:SetAlpha(1)
    
    local texture = m:CreateTexture(nil, "OVERLAY")
    texture:SetTexture("Interface\\AddOns\\SunUI\\media\\mark")
    texture:SetVertexColor(0,0,0,1)
    texture:SetAllPoints(m)
    m.texture = texture
    
    local spark = m:CreateTexture(nil, "OVERLAY")
    spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    spark:SetAlpha(0)
    spark:SetWidth(20)
    spark:SetHeight(m:GetWidth()*4)
    spark:SetPoint("CENTER",m)
    spark:SetBlendMode('ADD')
    m.spark = spark
    
    local ag = spark:CreateAnimationGroup()
    local a1 = ag:CreateAnimation("Alpha")
    a1:SetChange(1)
    a1:SetDuration(0.2)
    a1:SetOrder(1)
    local a2 = ag:CreateAnimation("Alpha")
    a2:SetChange(-1)
    a2:SetDuration(0.4)
    a2:SetOrder(2)
    
    m.shine = ag

    f.mark = m

    return f
end
NugRunning.ConstructTimerBar = ConstructTimerBar
hooksecurefunc(NugRunning.TimerBar, "SetColor", function(self,r,g,b)
    self.bar:SetStatusBarColor(r,g,b)
	local s = self.bar:GetStatusBarTexture()
	S.CreateTop(s, r, g, b)
end)

function NugRunning.TimerBar.SetPowerStatus(self, status, powerdiff)
    if status == "HIGH" then
        self.status:SetTextColor(.1,1,.1)
        self.status:SetText("+"..powerdiff)
        self.status:Show()
        self.status.bg:Hide()
    elseif status == "LOW" then
        self.status:SetTextColor(1,.1,.1)
        self.status:SetText(powerdiff)
        self.status:Show()
        self.status.bg:Hide()
    else
        self.status:Hide()
        self.status.bg:Hide()
    end
end
function NugRunning:DoNameplates()

local next = next
local table_remove = table.remove

local makeicon = true

local Nplates
local plates = {}

local oldTargetGUID
local guidmap = {}

local function OnHide(frame)
    local frame_guid = frame.guid
    if frame_guid then
        guidmap[frame_guid] = nil
        frame.guid = nil
        if frame_guid == oldTargetGUID then
            oldTargetGUID = nil
        end
    end
    for _, timer in ipairs(frame.timers) do
        timer:Hide()
    end
end

local function HookFrames(...)
    for index=1,select("#", ...) do
        local frame = select(index, ...)
        local region = frame:GetRegions()
        local fname = frame:GetName()
        if  not plates[frame] and
            fname and string.find(fname, "NamePlate")
        then
            local hp, cb = frame:GetChildren()
            local threat, hpborder, overlay, oldname, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
            local _, cbborder, cbshield, cbicon = cb:GetRegions()
            frame.name = oldname
            frame.timers = {}
            -- frame.healthBar = healthBar
            -- frame.castBar = castBar
            plates[frame] = true
            frame:HookScript("OnHide", OnHide)
        end
    end
end

NugRunningNameplates = CreateFrame("Frame")
NugRunningNameplates:SetScript('OnUpdate', function(self, elapsed)
    if(WorldFrame:GetNumChildren() ~= Nplates) then
        Nplates = WorldFrame:GetNumChildren()
        HookFrames(WorldFrame:GetChildren())
    end
    if UnitExists("target") then
        local targetGUID = UnitGUID("target")
        for frame in pairs(plates) do
            if frame:IsShown() and frame:GetAlpha() == 1 and
                (UnitName("target") == frame.name:GetText()) and
                targetGUID ~= oldTargetGUID then
                    guidmap[targetGUID] =  frame
                    frame.guid = targetGUID
                    oldTargetGUID = targetGUID
                    local guidTimers = NugRunning:GetTimersByDstGUID(targetGUID)
                    NugRunningNameplates:UpdateNPTimers(frame, guidTimers)
                    return
                    -- frame.name:SetText(targetGUID)
            end
        end
    else
        oldTargetGUID = nil
    end
end)

local MiniOnUpdate = function(self, time)
    self._elapsed = self._elapsed + time
    if self._elapsed < 0.02 then return end
    self._elapsed = 0

    local endTime = self.endTime
    local beforeEnd = endTime - GetTime()

    self:SetValue(beforeEnd + self.startTime)
end

local backdrop = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        tile = true, tileSize = 0,
        insets = {left = -S.mult, right = -S.mult, top = -S.mult, bottom = -S.mult},
    }

function NugRunningNameplates:CreateNameplateTimer(frame)
    local f = CreateFrame("StatusBar", nil, frame)
    f:SetStatusBarTexture(DB.Statusbar, "OVERLAY")
    f:SetWidth(70)
    local h = 7
    f:SetHeight(h)

    if makeicon then
        local icon = f:CreateTexture("ARTWORK")
        -- icon:SetTexCoord(.1, .9, .1, .9)
        -- icon:SetHeight(h); icon:SetWidth(h)
        icon:SetTexCoord(.1, .9, .1, .9)
        icon:SetHeight(h*2); icon:SetWidth(2*h)
        icon:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT",-5,0)
        -- backdrop.insets.left = -h -1
		local border = CreateFrame("Frame", nil, f)
		border:SetFrameLevel(1)
		border:SetPoint("TOPLEFT", icon, -S.mult, S.mult)
		border:SetPoint("BOTTOMRIGHT", icon, S.mult, -S.mult)
		border:CreateBorder()
        backdrop.insets.left = -(h*2) -1
        f.icon = icon
    end
	f:CreateShadow()
	S.CreateBack(f)
    local bg = f:CreateTexture("BACKGROUND", nil, -5)
    bg:SetTexture(nil)
    bg:SetAllPoints(f)
    f.bg = bg

    f._elapsed = 0
    f:SetScript("OnUpdate", MiniOnUpdate)

    if not next(frame.timers) then
        f:SetPoint("BOTTOM", frame, "TOP", 0, 3)
    else
        local prev = frame.timers[#frame.timers]
        f:SetPoint("BOTTOM", prev, "TOP", 0,h)
    end
    table.insert(frame.timers, f)
    return f
end

function NugRunningNameplates:Update(targetTimers, guidTimers)
    local tGUID = UnitGUID("target")
    if tGUID then
        guidTimers[tGUID] = targetTimers
    end
    for guid, np in pairs(guidmap) do
        local nrunTimers = guidTimers[guid]
        self:UpdateNPTimers(np, nrunTimers)
    end
end

function NugRunningNameplates:UpdateNPTimers(np, nrunTimers)
    if nrunTimers then
        local i = 1
        while i <= #nrunTimers do
            local timer = nrunTimers[i]
            if not timer.opts.nameplates or timer.isGhost then
                table_remove(nrunTimers, i)
            else
                i = i + 1
            end
        end

        local max = math.max(#nrunTimers, #np.timers)
        for i=1, max do
            local npt = np.timers[i]
            local nrunt = nrunTimers[i]
            if not npt then npt = self:CreateNameplateTimer(np) end
            if not nrunt  then
                npt:Hide()
            else
                npt.startTime = nrunt.startTime
                npt.endTime = nrunt.endTime
                npt:SetMinMaxValues(nrunt.bar:GetMinMaxValues())
                local r,g,b = nrunt.bar:GetStatusBarColor()
                npt:SetStatusBarColor(r,g,b)
                npt.bg:SetVertexColor(r*.4,g*.4,b*.4)
                if npt.icon then
                    npt.icon:SetTexture(nrunt.icon:GetTexture())
                end
                npt:Show()
            end

        end
    else
        for _, timer in ipairs(np.timers) do
            timer:Hide()
        end
    end
end
end

local helpers = NugRunning.helpers
local Spell, ModSpell = helpers.Spell, helpers.ModSpell
local Cooldown, ModCooldown = helpers.Cooldown, helpers.ModCooldown
local Activation, ModActivation = helpers.Activation, helpers.ModActivation
local EventTimer = helpers.EventTimer
local Talent = helpers.Talent
local Glyph = helpers.Glyph
local GetCP = helpers.GetCP
local _,class = UnitClass("player")
local colors = NugRunningConfig.colors

if class == "WARLOCK" then
-- ModSpell(348, { color = colors.WOO }) -- modifying Immolate color
-- Spell(348, {}) -- remove immolate
end

if class == "PRIEST" then
	-- BUFFS
	Spell( 139 ,{ name = GetSpellInfo(139), shinerefresh = true, color = colors.LGREEN, duration = 12, textfunc = function(timer) return timer.dstName end })
	Spell( 17 ,{ name = GetSpellInfo(17), shinerefresh = true, duration = 15, color = colors.LRED, textfunc = function(timer) return timer.dstName end })  --, textfunc = function(timer) return timer.absorb end
	Spell( 41635 ,{ name = GetSpellInfo(41635), shinerefresh = true, duration = 30, color = colors.RED, textfunc = function(timer) return timer.dstName end })
	Spell( 47788 ,{ name = GetSpellInfo(47788), shine = true, duration = 10, color = colors.LBLUE, short = "Guardian" })
	Spell( 33206 ,{ name = GetSpellInfo(33206),shine = true, duration = 8, color = colors.LBLUE })
	Spell( 586 ,{ name = GetSpellInfo(586),duration = 10 })
	Spell( 89485 ,{ name = GetSpellInfo(89485), shine = true, color = colors.LBLUE, timeless = true, duration = 0.1 })
	Spell( 589 ,{ name = GetSpellInfo(589),duration = 18, overlay = {0,1.5, 0.2}, ghost = true, showpower = true, nameplates = true, priority = 9, color = colors.PURPLE, refreshed =true, short = "SW:Pain", textfunc = function(timer) return timer.dstName end })

	EventTimer({ event = "SPELL_SUMMON", spellID = 123040, name = GetSpellInfo(123040), duration = 15, priority = -10, color = colors.BLACK })
	EventTimer({ event = "SPELL_SUMMON", spellID = 34433, name = GetSpellInfo(34433), duration = 12, priority = -10, color = colors.BLACK })
	Spell( 34914 ,{ name = GetSpellInfo(34914), overlay = {0, 1.5, 0.2}, recast_mark = 2.8, ghost = true, showpower = true, nameplates = true,  priority = 10, duration = 15, color = colors.RED, short = "VampTouch", hasted = true, textfunc = function(timer) return timer.dstName end })
	Spell( 2944 ,{ name = GetSpellInfo(2944),duration = 6, priority = 8, nameplates = true, showpower = true, color = colors.WOO, short = "Plague", textfunc = function(timer) return timer.dstName end })
	Spell( 47585 ,{ name = GetSpellInfo(47585),duration = 6, color = colors.PURPLE })
	Spell( 59889,{ name = GetSpellInfo(59889), duration = 6 })
	-- DEBUFFS
	Spell( 109964 ,{ name = GetSpellInfo(109964), duration = 15, color = colors.PURPLE2 })
	Spell( 114908 ,{ name = GetSpellInfo(114908), duration = 15, color = colors.PURPLE2 }) --shield effect

	Spell( 87160 ,{ name = GetSpellInfo(87160), duration = 10, color = colors.LRED })
	Spell( 87160 ,{ name = GetSpellInfo(87160), duration = 10, color = colors.LRED })
	Spell( 114255,{ name = GetSpellInfo(114255), duration = 20, color = colors.LRED })
	Spell( 112833,{ name = GetSpellInfo(112833), duration = 6, color = colors.CURSE })
	Spell( 123266,{ name = GetSpellInfo(123266), duration = 10, color = colors.BLACK }) -- discipline
	Spell( 123267,{ name = GetSpellInfo(123267), duration = 10, color = colors.BLACK }) -- holy
	Spell( 124430,{ name = GetSpellInfo(124430), duration = 12, color = colors.BLACK }) -- shadow


	Spell( 9484 ,{ name = GetSpellInfo(9484),duration = 50, pvpduration = 8, short = "Shackle" })
	Spell( 15487 ,{ name = GetSpellInfo(15487),duration = 5, color = colors.PINK })

	Spell( 113792 ,{ name = GetSpellInfo(113792),duration = 30, pvpduration = 8 })
	Spell( 8122 ,{ name = GetSpellInfo(8122),duration = 8, multiTarget = true })

	--Rapture
	EventTimer({ event = "SPELL_ENERGIZE", spellID = 47755, name = GetSpellInfo(47755), color = colors.BLACK, duration = 12 })
	--¹âÈ¦
	EventTimer({ event = "SPELL_CAST_START", spellID = 88685, name = GetSpellInfo(88685), duration = 31 })
	Spell( 88684 ,{ name = GetSpellInfo(88684), duration = 6})

	Cooldown( 8092, { name = GetSpellInfo(8092), recast_mark = 1.5, color = colors.CURSE, resetable = true, ghost = true })
	Cooldown( 32379, { name = GetSpellInfo(32379), short = "SW:Death",  color = colors.PURPLE, resetable = true  })

	EventTimer({ event = "SPELL_CAST_SUCCESS", spellID = 62618, name = GetSpellInfo(62618), duration = 10, color = colors.GOLD })
	Spell( 88625 ,{ name = GetSpellInfo(88625), color = colors.LRED, short = "HW: Chastise", duration = 3 })

	Cooldown( 47540 ,{ name = GetSpellInfo(47540), color = colors.CURSE })
	Cooldown( 14914 ,{ name = "", recast_mark = 3, overlay = {0,3}, color = colors.PINK })
	Spell( 81661 ,{ name = GetSpellInfo(81661),duration = 15, color = colors.ORANGE, stackcolor = {
		[1] = {0.7,0,0},
		[2] = {1,0.6,0.2},
		[3] = {1,1,0.4},
		[4] = {0.8,1,0.5},
		[5] = {0.7,1,0.2},
	} })
end

if class == "ROGUE" then
    
end

if class == "WARRIOR" then
    
end

if class == "MAGE" then
    EventTimer({ event = "SPELL_SUMMON", spellID = 84714, name = GetSpellInfo(84714), duration = 10, color = colors.BLACK })
	EventTimer({ event = "SPELL_SUMMON", spellID = 58833, name = GetSpellInfo(55342), duration = 30, color = colors.BLACK })
end

if class == "DRUID" then
    
end

if class == "DEATHKNIGHT" then
    
end

if class == "HUNTER" then
    
end

if class == "SHAMAN" then
    
end

if class == "PALADIN" then
    
end
