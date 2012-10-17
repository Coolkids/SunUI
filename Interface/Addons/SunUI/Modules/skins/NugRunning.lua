if not IsAddOnLoaded("NugRunning") then return end
local S, C, L, DB = unpack(select(2, ...))
local _
--(\d+)(\s*,.+name\s*=\s*)\"[^"]+\"Ìæ»»\1\2GetSpellInfo\(\1\)
local bettertime = true
local color = "|cffff0000"
local universal_color = {0.45,0.45,0.45}

local unpack = unpack
local format = format

local FormatTime
do
	local day, hour, minute = 86400, 3600, 60
	function FormatTime(s)
		if s >= day then
			return format("%d%sd|r", ceil(s / day), color)
		elseif s >= hour then
			return format("%d%sh|r", ceil(s / hour), color)
		elseif s >= minute * 4 then
			return format("%d%sm|r", ceil(s / minute), color)
		elseif s >= 5 then
			return floor(s)
		end
		return format("%.1f", s)
	end
end
-- better time text; not called when "bettertime" is false
local function SetTimeText(self, _, timeDigits)
	self:SetText(FormatTime(timeDigits))
end
-- Only set alpha on the bar, the icon and stacks when target is changed
local ModifyElementAlpha
do
	local _
	local elements = {"icon", "stacktext", "bar"}
	function ModifyElementAlpha(self, alpha)
		for _, elm in pairs(elements) do
			self[elm]:SetAlpha(alpha)
		end
	end
end

-- injecting our default settings
hooksecurefunc(NugRunning, 'PLAYER_LOGIN', function(self,event,arg1)
	--if(NRunDB_Global) and not NRunDB.set then table.wipe(NRunDB_Global) end
	if not NRunDB_Global.set then
		table.wipe(NRunDB_Global)
		NRunDB.set = true
		NRunDB.anchor = NRunDB.anchor or {}
		NRunDB.anchor.point = NRunDB.anchor.point or "CENTER"
		NRunDB.anchor.parent = NRunDB.anchor.parent or "UIParent"
		NRunDB.anchor.to = NRunDB.anchor.to or "CENTER"
		NRunDB.anchor.x = NRunDB.anchor.x or 253.2259143850206
		NRunDB.anchor.y = NRunDB.anchor.y or -137.9071948009855
		NRunDB.growth = NRunDB.growth or "up"
		NRunDB.width = NRunDB.width or 110
		NRunDB.height = NRunDB.height or 16
		NRunDB.fontscale = NRunDB.fontscale or 1
		NRunDB.nonTargetOpacity = NRunDB.nonTargetOpacity or 0.7
		NRunDB.cooldownsEnabled = false
		NRunDB.spellTextEnabled = (NRunDB.spellTextEnabled == nil and true) or NRunDB.spellTextEnabled
		NRunDB.shortTextEnabled = (NRunDB.shortTextEnabled == nil and false) or NRunDB.shortTextEnabled
		NRunDB.swapTarget = (NRunDB.swapTarget == nil and true) or NRunDB.swapTarget
		NRunDB.localNames   = (NRunDB.localNames == nil and false) or NRunDB.localNames
		NRunDB.totems = false --(NRunDB.totems == nil and true) or NRunDB.totems
	end

    NugRunning.anchor = NugRunning.CreateAnchor()
    local pos = NRunDB_Global.anchor
    NugRunning.anchor:SetPoint(pos.point, pos.parent, pos.to, pos.x, pos.y)
	
	NugRunning:SetupArrange()
	
	local up = CreateFrame"Frame"
	up:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	up:RegisterEvent("PLAYER_ENTERING_WORLD")
	up:SetScript("OnEvent", function()
		local pttree = GetSpecialization()
		if (select(2,UnitClass("player"))=="DRUID" and pttree==1) or select(2,UnitClass("player")) == "DEATHKNIGHT" or (select(2,UnitClass("player")) == "SHAMAN") then
			NugRunning.anchor:SetPoint(pos.point, pos.parent, pos.to, pos.x, pos.y+12)
		else
			NugRunning.anchor:SetPoint(pos.point, pos.parent, pos.to, pos.x, pos.y)
		end
	end)
end)


---------------------------------------------------------------------------------------------------------------
local TimerBarSetColor = function(self,r,g,b)
    self.bar:SetStatusBarColor(r,g,b)
	--self.bar:SetStatusBarColor(unpack(universal_color))
    self.bar.bg:SetVertexColor(r*.3, g*.3, b*.3)
end

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
    f.stacktext:SetPoint("RIGHT", ic, "RIGHT",1,-5)
    
    f.bar = CreateFrame("StatusBar",nil,f)
	f.bar:CreateShadow()
	local gradient = f.bar:CreateTexture(nil, "BACKGROUND")
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture(DB.Statusbar)
	gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
    f.bar:SetFrameStrata("MEDIUM")
    f.bar:SetStatusBarTexture(DB.Statusbar)
    f.bar:GetStatusBarTexture():SetDrawLayer("ARTWORK")
    f.bar:SetHeight(height/2)
    f.bar:SetWidth(width - height )
	f.bar:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,0)
    local spar =  f.bar:CreateTexture(nil, "OVERLAY")
	spar:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
	spar:SetBlendMode("ADD")
	spar:SetAlpha(.8)
	spar:SetPoint("TOPLEFT", f.bar:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
	spar:SetPoint("BOTTOMRIGHT", f.bar:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)
    
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