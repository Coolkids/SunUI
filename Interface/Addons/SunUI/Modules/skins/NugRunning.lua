if not IsAddOnLoaded("NugRunning") then return end
local S, C, L, DB = unpack(select(2, ...))
local _
--(\d+)(\s*,.+name\s*=\s*)\"[^"]+\"Ìæ»»\1\2GetSpellInfo\(\1\)

-- Replace bar creation function
ConstructTimerBar = function(width, height)
    local f = CreateFrame("Frame",nil,UIParent)
    f.prototype = "TimerBar"

    f:SetWidth(width-height)
    f:SetHeight(height)
    
    
    local ic = CreateFrame("Frame",nil,f)
    ic:SetPoint("BOTTOMRIGHT",f,"BOTTOMLEFT", -10, 0)
    ic:SetWidth(height)
    ic:SetHeight(height)
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
    S.CreateSpark(f.bar, 10, 10)
    
	f.bar.bg = f.bar:CreateTexture(nil, "BORDER")
	f.bar.bg:SetAllPoints(f.bar)
	--f.bar.bg:SetTexture(tex)
    
	f.timeText = f.bar:CreateFontString();
    f.timeText:SetFont(NugRunningConfig.timeFont.font, NugRunningConfig.timeFont.size, "THINOUTLINE")
    f.timeText:SetJustifyH("LEFT")
    f.timeText:SetVertexColor(1,1,1)
    f.timeText:SetPoint("LEFT", f.bar, "LEFT",0,height/2)
		
	f.timeText.SetFormattedText = SetTimeText
    
	f.spellText = f.bar:CreateFontString();
    f.spellText:SetFont(NugRunningConfig.nameFont.font, NugRunningConfig.nameFont.size, "THINOUTLINE")
    f.spellText:SetWidth(f.bar:GetWidth()*0.7)
    f.spellText:SetHeight(height/2+1)
    f.spellText:SetJustifyH("RIGHT")
    f.spellText:SetPoint("RIGHT", f.bar, "RIGHT",0,height/2)
    f.spellText.SetName = SpellTextUpdate
    
	f.SetColor = TimerBarSetColor
	local overlay = f.bar:CreateTexture(nil, "ARTWORK", nil, 3)
    overlay:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    overlay:SetVertexColor(0,0,0, 0.2)
    overlay:Hide()
    f.overlay = overlay
    local status = f.bar:CreateTexture(nil, "ARTWORK", nil, 5)
    status:SetTexture("Interface\\AddOns\\NugRunning\\white")
    status:SetSize(width/2,height)
    status:SetPoint("TOPLEFT", f.bar, "TOPLEFT",0,0)
    status:Hide()
    f.status = status
	
    local at = ic:CreateTexture(nil,"OVERLAY")
    at:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
    at:SetTexCoord(0.00781250,0.50781250,0.27734375,0.52734375)
    --at:SetTexture([[Interface\AchievementFrame\UI-Achievement-IconFrame]])
    --at:SetTexCoord(0,0.5625,0,0.5625)
    at:SetWidth(height*1.6)
    at:SetHeight(height*1.6)
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
    texture:SetTexture("Interface\\AddOns\\SunUI\\Modules\\skins\\mark")
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
        insets = {left = -1, right = -1, top = -1, bottom = -1},
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