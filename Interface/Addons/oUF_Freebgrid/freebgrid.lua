local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

ns.nameCache = {}
ns.colorCache = {}
ns.debuffColor = {} -- hex debuff colors for tags

local backdrop = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = 2, left = 2, bottom = 2, right = 2},
}

local border = {
    bgFile = [=[Interface\AddOns\oUF_Freebgrid\media\white.tga]=],
    insets = {top = -2, left = -2, bottom = -2, right = -2},
}

local border2 = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local glowBorder = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    edgeFile = [=[Interface\AddOns\oUF_Freebgrid\media\glowTex.tga]=], edgeSize = 5,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
}

local colors = setmetatable({
    power = setmetatable({
        ['MANA'] = {.31,.45,.63},
    }, {__index = oUF.colors.power}),
}, {__index = oUF.colors})

function ns:hex(r, g, b)
    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

-- 单位菜单
local dropdown = CreateFrame('Frame', ADDON_NAME .. 'DropDown', UIParent, 'UIDropDownMenuTemplate')

local init = function(self)
    if (ns.db and ns.db.hidemenu) and InCombatLockdown() then
        return
    end

    local unit = self:GetParent().unit
	if(not unit) then return end
	
    local menu, name, id
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

local menu = function (self)
    dropdown:SetParent(self)
    return ToggleDropDownMenu(1, nil, dropdown, 'cursor', 0, 0)
end

-- 高亮显示焦点单位边框
local FocusTarget = function(self)
    if ns.db.fborder then 
		if UnitIsUnit('focus', self.unit) then
			self.FocusHighlight:SetBackdropColor(.6, .8, .0, 1)
			self.FocusHighlight:Show()
			return
		elseif UnitIsUnit('target', self.unit) then
			self.FocusHighlight:SetBackdropColor(.8, .8, .8, 1)
			self.FocusHighlight:Show()
			return
		end       
    end
	self.FocusHighlight:Hide()
end
--可驱散边框显示
local updateDispel = function(self)
	if ns.db.dispel ~= "BORDER" then return end
	local dispellist = ns.dispellist or {}
    local index = 1

    while true do
        local name,_,_,_, dtype = UnitAura(self.unit, index, 'HARMFUL')
        if not name then break end
		if dispellist[dtype] then
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			self.DispelBorder:SetBackdropColor(color.r, color.g, color.b)
			self.DispelBorder:Show()
			return 
		end
        index = index+1
    end
	self.DispelBorder:Hide()
end

--更新仇恨边框
local updateThreat = function(self, event, unit)
    if(unit ~= self.unit) then return end

    local status = UnitThreatSituation(unit)

    if(status and status > 0) then
        local r, g, b = GetThreatStatusColor(status)
        self.Threat:SetBackdropBorderColor(r, g, b, 1)
        self.border:SetBackdropColor(r, g, b, 1)
    else
        self.Threat:SetBackdropBorderColor(0, 0, 0, 1)
        self.border:SetBackdropColor(0, 0, 0, 1)
    end
    self.Threat:Show()
end

local function utf8sub(str, start, numChars) 
    local currentIndex = start 
    while numChars > 0 and currentIndex <= #str do 
        local char = string.byte(str, currentIndex) 
        if char >= 240 then 
            currentIndex = currentIndex + 4 
        elseif char >= 225 then 
            currentIndex = currentIndex + 3 
        elseif char >= 192 then 
            currentIndex = currentIndex + 2 
        else 
            currentIndex = currentIndex + 1 
        end 
        numChars = numChars - 1 
    end 
    return str:sub(start, currentIndex - 1) 
end 

function ns:UpdateName(name, unit) 

    if(unit) then
        local _NAME = UnitName(unit)      
        if not _NAME then return end

        local substring
        for length=#_NAME, 1, -1 do
            substring = utf8sub(_NAME, 1, length)
            name:SetText(substring)
            if name:GetStringWidth() <= ns.db.width - 8 then name:SetText(nil); break end
        end

		local _, class = UnitClass(unit)
		if class then
			 ns.nameCache[_NAME] = ns.colorCache[class]..substring
		else
			ns.nameCache[_NAME] = substring
		end
        name:UpdateTag()
    end
end

local  function UpdateHealth(self, event, unit)
	
	if(self.unit ~= unit) then return end
	local hp = self.Health
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local disconnected = not UnitIsConnected(unit)
	hp:SetMinMaxValues(0, max)
	if UnitIsDeadOrGhost (unit) or (disconnected) then
		hp:SetValue(max)
	else
		hp:SetValue(min)
	end

    local name = UnitName(unit)
	if not ns.nameCache[name] then
        ns:UpdateName(self.Name, unit)
    end

	local V, D, E, H, Hbg = ns.db.vehiclecolor, ns.db.deadcolor, ns.db.enemycolor, ns.db.hpcolor,ns.db.hpbgcolor
		
	if not UnitIsEnemy("player",unit) then
		local r, g, b, t
		local _, class = UnitClass(unit)
		local t = colors.class[class] or { .2, .8, .15}
		r, g, b  = t[1], t[2], t[3]
		
		if UnitIsDeadOrGhost (unit) or disconnected then
			hp:SetStatusBarColor(D.r, D.g, D.b,.6)
			hp.bg:SetVertexColor(D.r*.2, D.g*.2, D.b*.2,.6)
			return
		end

		--local suffix = self:GetAttribute'unitsuffix'
		--local ispet = string.match(unit,"pet")
		--if suffix == 'pet' or unit == 'vehicle' or ispet then
		if  UnitPlayerControlled(unit) and not UnitIsPlayer(unit) then
			hp:SetStatusBarColor(V.r, V.g, V.b)
			hp.bg:SetVertexColor(V.r*.2, V.g*.2, V.b*.2)
			return
		elseif ns.db.definecolors then
			if ns.db.classbgcolor then
				hp.bg:SetVertexColor(r, g, b)
			else
				hp.bg:SetVertexColor(Hbg.r, Hbg.g, Hbg.b)
			end
			
			if not hp.colorSmooth then
				hp:SetStatusBarColor(H.r, H.g, H.b)
			else
				local perc
				if(max == 0) then
					perc = 0
				else
					perc = min / max
				end
				r, g, b = self.ColorGradient(perc, unpack(hp.smoothGradient or colors.smooth))
				hp:SetStatusBarColor(r, g, b)
			end
			return 
		elseif ns.db.reversecolors  then
			hp.bg:SetVertexColor(r*.2, g*.2, b*.2)
			hp:SetStatusBarColor(r, g, b)
		else
			hp.bg:SetVertexColor(r, g, b)
			hp:SetStatusBarColor(0, 0, 0, .8)
		end		
	else
		hp:SetStatusBarColor(E.r, E.g, E.b)
		hp.bg:SetVertexColor(E.r*.2, E.g*.2, E.b*.2)
	end
end

function ns:UpdateHealth(hp)
    hp:SetStatusBarTexture(ns.db.texturePath)
    hp:SetOrientation(ns.db.orientation)
    hp.bg:SetTexture(ns.db.texturePath)
    hp.freebSmooth = ns.db.smooth

    hp.colorSmooth = ns.db.colorSmooth
    hp.smoothGradient = { 
        ns.db.gradient.r, ns.db.gradient.g, ns.db.gradient.b,
        ns.db.hpcolor.r, ns.db.hpcolor.g, ns.db.hpcolor.b,
    }
    if not ns.db.powerbar then		
        hp:SetHeight(ns.db.height)
        hp:SetWidth(ns.db.width)
    end

    hp:ClearAllPoints()
    hp:SetPoint"TOP"
    if ns.db.orientation == "VERTICAL" and ns.db.porientation == "VERTICAL" then
        hp:SetPoint"LEFT"
        hp:SetPoint"BOTTOM"
    elseif ns.db.orientation == "HORIZONTAL" and ns.db.porientation == "VERTICAL" then
        hp:SetPoint"RIGHT"
        hp:SetPoint"BOTTOM"
    else
        hp:SetPoint"LEFT"
        hp:SetPoint"RIGHT"
    end
end

local function PostPower(power, unit)
    local self = power.__owner
    local _, ptype = UnitPowerType(unit)
    local _, class = UnitClass(unit)

    if  not ns.db.onlymana or (ptype == 'MANA' and ns.db.onlymana)then
		power:Show()
		if(ns.db.porientation == "VERTICAL")then
			power:SetWidth(ns.db.width*ns.db.powerbarsize)
			self.Health:SetWidth((0.98 - ns.db.powerbarsize)*ns.db.width)
		else
			power:SetHeight(ns.db.height*ns.db.powerbarsize)
			self.Health:SetHeight((0.98 - ns.db.powerbarsize)*ns.db.height)
		end
	else 
	power:Hide()
		if(ns.db.porientation == "VERTICAL")then
			self.Health:SetWidth(ns.db.width)
		else
			self.Health:SetHeight(ns.db.height)
		end
    end    

    local perc = oUF.Tags['perpp'](unit)
    -- This kinda conflicts with the threat module, but I don't really care
    if (ns.db.lowmana and perc < ns.db.manapercent and UnitIsConnected(unit) and ptype == 'MANA' and not UnitIsDeadOrGhost(unit)) then
        self.Threat:SetBackdropBorderColor(0, 0, 1, 1)			--蓝低于10%,边框高亮显示
        self.border:SetBackdropColor(0, 0, 1, 1)
    else
        -- pass the coloring back to the threat func
        updateThreat(self, nil, unit)
    end
	
	if UnitIsDeadOrGhost (unit) then
		power.bg:SetVertexColor(ns.db.deadcolor.r, ns.db.deadcolor.g, ns.db.deadcolor.b)
        power:SetStatusBarColor(ns.db.deadcolor.r, ns.db.deadcolor.g, ns.db.deadcolor.b)
		return
	end
	
    if ns.db.powerdefinecolors then
        power.bg:SetVertexColor(ns.db.powerbgcolor.r, ns.db.powerbgcolor.g, ns.db.powerbgcolor.b)
        power:SetStatusBarColor(ns.db.powercolor.r, ns.db.powercolor.g, ns.db.powercolor.b)
        return
    end

    local r, g, b, t
    t = ns.db.powerclass and colors.class[class] or colors.power[ptype]

    if(t) then
        r, g, b = t[1], t[2], t[3]
    else
        r, g, b = 1, 1, 1
    end

    if(b) then
        if ns.db.reversecolors or ns.db.powerclass then
            power.bg:SetVertexColor(r*.2, g*.2, b*.2)
            power:SetStatusBarColor(r, g, b)
        else
            power.bg:SetVertexColor(r, g, b)
            power:SetStatusBarColor(0, 0, 0, .8)
        end
    end
end

function ns:UpdatePower(power) 
    if ns.db.powerbar then
        power:Show()
        power.PostUpdate = PostPower
    else
        power:Hide()
        power.PostUpdate = nil
        return
    end
    power:SetStatusBarTexture(ns.db.texturePath)
    power:SetOrientation(ns.db.porientation)
    power.bg:SetTexture(ns.db.texturePath)

    power:ClearAllPoints()
    if ns.db.orientation == "HORIZONTAL" and ns.db.porientation == "VERTICAL" then
        power:SetPoint"LEFT"
        power:SetPoint"TOP"
        power:SetPoint"BOTTOM"
    elseif ns.db.porientation == "VERTICAL" then
        power:SetPoint"TOP"
        power:SetPoint"RIGHT"
        power:SetPoint"BOTTOM"
    else
        power:SetPoint"LEFT"
        power:SetPoint"RIGHT"
        power:SetPoint"BOTTOM"
    end
end

local RoleIconUpdate = function(self, event)
	local lfdrole = self.LFDRole
	local role = UnitGroupRolesAssigned(self.unit)

	if(role == 'TANK' or role == 'HEALER' or role == 'DAMAGER') and UnitIsConnected(self.unit) and ns.db.roleicon then
		if role == 'TANK' then
			lfdrole:SetTexture([[Interface\AddOns\oUF_Freebgrid\media\tank.tga]])
		elseif role == 'HEALER' then
			lfdrole:SetTexture([[Interface\AddOns\oUF_Freebgrid\media\healer.tga]])
		elseif role == 'DAMAGER' then
			lfdrole:SetTexture([[Interface\AddOns\oUF_Freebgrid\media\dps.tga]])
		end
		lfdrole:Show()
	else
		lfdrole:Hide()
	end	
end

local ResurrectIconUpdate = function(self, event)
	local incomingResurrect = UnitHasIncomingResurrection(self.unit)
	local resurrect = self.ResurrectIcon
	if UnitIsDeadOrGhost (self.unit) and incomingResurrect  then
		resurrect:Show()
	else
		resurrect:Hide()
	end
end

-- 鼠标滑过高亮
local OnEnter = function(self)
	ns.MouseoverUnit = self.unit
    if ns.db.tooltip and  InCombatLockdown() then	
		GameTooltip:Hide()       
    else
        UnitFrame_OnEnter(self)
    end
	
    if ns.db.highlight then
		self.Highlight:Show()		
		self.HighlightBorder:Show()
    end

    if ns.db.arrow and ns.db.arrowmouseover then
        ns:arrow(self, self.unit)
    end
end

local OnLeave = function(self)
    if not ns.db.tooltip then UnitFrame_OnLeave(self) end
    self.Highlight:Hide()
    self.HighlightBorder:Hide()

    if(self.freebarrow and self.freebarrow:IsShown()) and ns.db.arrowmouseover then
        self.freebarrow:Hide()
    end
end

   --设置鼠标点击
function  ns:RegisterClicks (self)
    if not ns.db.ClickCastenable then return end
	local action,macrotext,key_tmp
	local C = ns.db.ClickCastset
	for id, _ in pairs(C) do
		for	key, _ in pairs(C[id]) do
			key_tmp = string.gsub(key,"Click","")
			action =  C[id][key]["action"]
			macrotext = C[id][key]["macrotext"]
			if action == "macro"  and type(macrotext) == "string" then
				self:SetAttribute(key_tmp.."type"..id, "macro")
				self:SetAttribute(key_tmp.."macrotext"..id, macrotext)
			elseif action == "follow" then
				self:SetAttribute(key_tmp.."type"..id, "macro")
				self:SetAttribute(key_tmp.."macrotext"..id, "/follow mouseover")
			elseif	action == "menu" then		
				self:SetAttribute(key_tmp.."type"..id, "menu")
			elseif	action == "target" then		
				self:SetAttribute(key_tmp.."type"..id, "target")
			else				
				self:SetAttribute(key_tmp.."type"..id, 'spell')
				self:SetAttribute(key_tmp.."spell"..id, action)
			end				
		end
	end
end
local raid_visible
local function kill_raid()
	if InCombatLockdown() then return end

	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager:Hide()
	raid_visible = CompactRaidFrameManager_GetSetting("IsShown")

	if raid_visible and raid_visible ~= "0" then 
	  CompactRaidFrameManager_SetSetting("IsShown", "0")
	end
end


--设置样式
local style = function(self)
    self.menu = menu

    -- 创建背景边框
    self.BG = CreateFrame("Frame", nil, self)
    self.BG:SetPoint("TOPLEFT", self, "TOPLEFT")
    self.BG:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    self.BG:SetFrameLevel(3)
    self.BG:SetBackdrop(backdrop)
    self.BG:SetBackdropColor(0, 0, 0)

    self.border = CreateFrame("Frame", nil, self)
    self.border:SetPoint("TOPLEFT", self, "TOPLEFT")
    self.border:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    self.border:SetFrameLevel(self:GetFrameLevel())
    self.border:SetBackdrop(border2)
    self.border:SetBackdropColor(0, 0, 0)

    -- 注册鼠标事件,鼠标按下施法注册'AnyDown',否则'AnyUp'
    self:SetScript("OnEnter", OnEnter)
    self:SetScript("OnLeave", OnLeave)
    self:RegisterForClicks"AnyDown"

	ns:RegisterClicks(self)

    -- 创建生命条
    local Health = CreateFrame"StatusBar"
    Health:SetParent(self)
    Health.frequentUpdates = true
    Health.bg = Health:CreateTexture(nil, "BORDER")
    Health.bg:SetAllPoints(Health)
    Health.Override = UpdateHealth
	self.Health = Health
    ns:UpdateHealth(self.Health)
	
	--AKF计时
	local afktext = self.Health:CreateFontString(nil, "OVERLAY")
    afktext:SetPoint("TOP")
    afktext:SetShadowOffset(1.25, -1.25)
    afktext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
    afktext:SetWidth(ns.db.width)
    afktext.frequentUpdates = 1
    self:Tag(afktext, "[freebgrid:afk]")
	self.AFKtext = afktext

	 -- 创建能力条
    local Power = CreateFrame"StatusBar"
    Power:SetParent(self)
    Power.bg = Power:CreateTexture(nil, "BORDER")
    Power.bg:SetAllPoints(Power)
	self.Power = Power
    ns:UpdatePower(self.Power)
	
    -- 创建仇恨边框
    local threat = CreateFrame("Frame", nil, self)
    threat:SetPoint("TOPLEFT", self, "TOPLEFT", -5, 5)
    threat:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 5, -5)
    threat:SetFrameLevel(0)
    threat:SetBackdrop(glowBorder)
    threat:SetBackdropColor(0, 0, 0, 0)
    threat:SetBackdropBorderColor(0, 0, 0, 1)
    threat.Override = updateThreat
    self.Threat = threat

    -- 单位名称
    local name = self.Health:CreateFontString(nil, "OVERLAY")
    name:SetPoint("CENTER")
    name:SetJustifyH("CENTER")
    name:SetFont(ns.db.fontPath, ns.db.fontsize, ns.db.outline)
    name:SetShadowOffset(1.25, -1.25)
    name:SetWidth(ns.db.width)
    name.overrideUnit = true
    self.Name = name
    self:Tag(self.Name, '[freebgrid:name]')

    -- 创建高亮材质
    local hl = self.Health:CreateTexture(nil, "OVERLAY")
    hl:SetAllPoints(self)
    hl:SetTexture([=[Interface\AddOns\oUF_Freebgrid\media\white.tga]=])
    hl:SetVertexColor(1,1,1,.1)
    hl:SetBlendMode("ADD")
    hl:Hide()
    self.Highlight = hl
	
    -- 鼠标悬停高亮边框
    local hlBorder = CreateFrame("Frame", nil, self)
    hlBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
    hlBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    hlBorder:SetBackdrop(border)
    hlBorder:SetBackdropColor(.8, .5, .5, .8)
    hlBorder:SetFrameLevel(2)
    hlBorder:Hide()
    self.HighlightBorder = hlBorder

	-- 创建GCD条
    local GCD = CreateFrame("StatusBar", nil, self)
    GCD:SetAllPoints(self)
    GCD:SetStatusBarTexture([=[Interface\AddOns\oUF_Freebgrid\media\white.tga]=])
    GCD:SetStatusBarColor(.4, .5, .4, .6)
    GCD:SetValue(0)
    GCD:SetFrameLevel(4)
    GCD:SetOrientation(ns.db.porientation)
    GCD:Hide()
    self.GCD = GCD	

    -- 创建焦点目标高亮边框
    local fBorder = CreateFrame("Frame", nil, self)
    fBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
    fBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    fBorder:SetBackdrop(border)
    fBorder:SetBackdropColor(0, 0, 0, 0)
    fBorder:SetFrameLevel(1)
    fBorder:Hide()
    self.FocusHighlight = fBorder
	
	-- 创建可驱散debuff显示边框
    local dispelBorder = CreateFrame("Frame", nil, self)
    dispelBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
    dispelBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    dispelBorder:SetBackdrop(border)
    dispelBorder:SetBackdropColor(0, 0, 0, 0)
    dispelBorder:SetFrameLevel(3)
    dispelBorder:Hide()
    self.DispelBorder = dispelBorder

    -- 设置团队图标
    local ricon = self.Health:CreateTexture(nil, 'OVERLAY')
    ricon:SetPoint("TOP", self, -15, 6)
    ricon:SetSize(ns.db.leadersize+2, ns.db.leadersize+2)
    self.RaidIcon = ricon

    -- 设置队长图标
    local Leader = self.Health:CreateTexture(nil, "OVERLAY")
    Leader:SetPoint("TOPLEFT", self, 0, 8)
    Leader:SetSize(ns.db.leadersize, ns.db.leadersize )
	self.Leader = Leader

    -- 设置助手等图标
    local Assistant = self.Health:CreateTexture(nil, "OVERLAY")
    Assistant:SetPoint("TOPLEFT", self, 0, 8)
    Assistant:SetSize(ns.db.leadersize, ns.db.leadersize)
	self.Assistant = Assistant

	--设置拾取权限图标
    local masterlooter = self.Health:CreateTexture(nil, 'OVERLAY')
    masterlooter:SetSize(ns.db.leadersize, ns.db.leadersize)
    masterlooter:SetPoint('LEFT', self.Leader, 'RIGHT')
    self.MasterLooter = masterlooter

    -- 设置职业图标
	local LFDRole = self.Health:CreateTexture(nil, 'OVERLAY')
	LFDRole:SetSize(ns.db.leadersize + 4, ns.db.leadersize + 4)
	LFDRole:SetPoint('RIGHT', self, 'LEFT', ns.db.leadersize, 0)
	LFDRole.Override = RoleIconUpdate
	self:RegisterEvent("UNIT_CONNECTION", RoleIconUpdate)
	self.LFDRole = LFDRole

	--设置复活提示图标
	local ResurrectIcon = self.Health:CreateTexture(nil, 'OVERLAY')
    ResurrectIcon:SetPoint("TOP", self, 0, -2)
    ResurrectIcon:SetSize(16, 16)
	ResurrectIcon.Override = ResurrectIconUpdate
	self.ResurrectIcon = ResurrectIcon
	
    self.freebIndicators = true
    self.freebHeals = true

    -- 距离
    local range = {
        insideAlpha = 1,
        outsideAlpha = ns.db.outsideRange,
    }
    self.freebRange = ns.db.arrow and range
    self.Range = ns.db.arrow == false and range

    --设置准备确认图标
    local ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
    ReadyCheck:SetPoint("TOP", self)
    ReadyCheck:SetSize(ns.db.leadersize, ns.db.leadersize)
	self.ReadyCheck = ReadyCheck

    -- 设置光环图标
    local auras = CreateFrame("Frame", nil, self)
    auras:SetSize(ns.db.aurasize, ns.db.aurasize)
    auras:SetPoint("CENTER", self.Health)
    auras.size = ns.db.aurasize
    self.freebAuras = auras

    self:RegisterEvent('PLAYER_FOCUS_CHANGED', FocusTarget)
    self:RegisterEvent('RAID_ROSTER_UPDATE', FocusTarget)
    self:RegisterEvent('PLAYER_TARGET_CHANGED', FocusTarget)
    self:RegisterEvent('RAID_ROSTER_UPDATE', FocusTarget)
	self:RegisterEvent('UNIT_AURA', updateDispel)

    self:SetScale(ns.db.scale)

    table.insert(ns._Objects, self)
end

oUF:RegisterStyle("Freebgrid", style)

function ns:Colors()
    for class, color in next, colors.class do
        if ns.db.reversecolors then
            ns.colorCache[class] = "|cffFFFFFF"
        else
            ns.colorCache[class] = ns:hex(color)
        end
    end

    for dtype, color in next, DebuffTypeColor do
        ns.debuffColor[dtype] = ns:hex(color)
    end
end

local pos, posRel, colX, colY
local function freebHeader(name, group, temp, pet, MT)
    local horiz, grow = ns.db.horizontal, ns.db.growth
    local numUnits = ns.db.multi and 5 or ns.db.numUnits
    local initconfig = [[
    self:SetWidth(%d)
    self:SetHeight(%d)
    ]]

    if pet then
        horiz, grow = ns.db.pethorizontal, ns.db.petgrowth
        numUnits = ns.db.petUnits
        initconfig = [[ 
        self:SetWidth(%d)        
        self:SetHeight(%d)           
        self:SetAttribute('unitsuffix', 'pet')
        ]]
    elseif MT then
        horiz, grow = ns.db.MThorizontal, ns.db.MTgrowth
        numUnits = ns.db.MTUnits
    end

    local point, growth, xoff, yoff
    if horiz then
        point = "LEFT"
        xoff = ns.db.spacing
        yoff = 0
        if grow == "UP" then
            growth = "BOTTOM"
            pos = "BOTTOMLEFT"
            posRel = "TOPLEFT"
            colY = ns.db.spacing
        else
            growth = "TOP"
            pos = "TOPLEFT"
            posRel = "BOTTOMLEFT"
            colY = -ns.db.spacing
        end
    else
        point = "TOP"
        xoff = 0
        yoff = -ns.db.spacing
        if grow == "RIGHT" then
            growth = "LEFT"
            pos = "TOPLEFT"
            posRel = "TOPRIGHT"
            colX = ns.db.spacing
        else
            growth = "RIGHT"
            pos = "TOPRIGHT"
            posRel = "TOPLEFT"
            colX = -ns.db.spacing
        end
    end

    local groupBy, groupOrder = "GROUP", "1,2,3,4,5,6,7,8"
    if not pet and not MT then
        if ns.db.sortClass then
            groupBy = "CLASS"
            groupOrder = ns.db.classOrder
            group = ns.db.classOrder
        end
    end

    local template = temp or nil
    local header = oUF:SpawnHeader(name, template, 'raid,party,solo',
    'oUF-initialConfigFunction', (initconfig):format(ns.db.width, ns.db.height),
	'initial-width', ns.db.width, 
    'initial-height',ns.db.height,
    'showPlayer', ns.db.player,
    'showSolo', ns.db.solo,
    'showParty', ns.db.party,
    'showRaid', true,
    'xOffset', xoff,
    'yOffset', yoff,
    'point', point,
 --   'sortMethod', sort,
    'groupFilter', group,
    'groupingOrder', groupOrder,
    'groupBy', groupBy,
    'maxColumns', ns.db.numCol,
    'unitsPerColumn', numUnits,
    'columnSpacing', ns.db.spacing,
    'columnAnchorPoint', growth)

    return header
end

oUF:Factory(function(self)
	ns.InitDB()
    ns:Anchors()
    ns:Colors()
	
	if ns.db.hideblzraid then
		hooksecurefunc("CompactRaidFrameManager_UpdateShown",function() kill_raid() end)
		CompactRaidFrameManager:HookScript('OnShow', kill_raid)
		CompactRaidFrameManager:SetScale(0.000001)
	end
	
    self:SetActiveStyle"Freebgrid"
    if ns.db.multi then
        local raid = {}
        for i=1, 8 do
            local group = freebHeader("Raid_Freebgrid"..i, i)
            if i == 1 then
                group:SetPoint(pos, "oUF_FreebgridRaidFrame", pos)
            else
                group:SetPoint(pos, raid[i-1], posRel, colX or 0, colY or 0)
            end
			if i > ns.db.numCol then
				group:SetAttribute("groupFilter", "")
			end
            raid[i] = group
            ns._Headers[group:GetName()] = group
        end
    else
       local raid = freebHeader("Raid_Freebgrid")
        raid:SetPoint(pos, "oUF_FreebgridRaidFrame", pos)
        ns._Headers[raid:GetName()] = raid
    end

    if ns.db.pets then
        local pet = freebHeader("Pet_Freebgrid", nil, 'SecureGroupPetHeaderTemplate', true)
        pet:SetPoint(pos, "oUF_FreebgridPetFrame", pos)
        pet:SetAttribute('useOwnerUnit', true)
        ns._Headers[pet:GetName()] = pet
    end

    if ns.db.MT then
        local tank = freebHeader("MT_Freebgrid", nil, nil, nil, true)
        tank:SetPoint(pos, "oUF_FreebgridMTFrame", pos)
        ns._Headers[tank:GetName()] = tank

        if oRA3 then
            tank:SetAttribute("initial-unitWatch", true)
            tank:SetAttribute("nameList", table.concat(oRA3:GetSortedTanks(), ","))

            local tankhandler = {}
            function tankhandler:OnTanksUpdated(event, tanks) 
                tank:SetAttribute("nameList", table.concat(tanks, ","))
            end
            oRA3.RegisterCallback(tankhandler, "OnTanksUpdated")
        else
            tank:SetAttribute('groupFilter', 'MAINTANK')
        end
    end
end)

ns.textures = {
    ["gradient"] = ns.mediapath.."gradient",
    ["Cabaret"] = ns.mediapath.."Cabaret",
}

ns.fonts = {
    ["Accidental Presidency"] = ns.mediapath.."Accidental Presidency.ttf",
    ["Expressway"] = ns.mediapath.."expressway.ttf",
}

local SM = LibStub("LibSharedMedia-3.0", true)
if SM then
    for font, path in pairs(ns.fonts) do
        SM:Register("font", font, path)
    end

    for tex, path in pairs(ns.textures) do
        SM:Register("statusbar", tex, path)
    end
end

ns:RegisterEvent("ADDON_LOADED")

function ns:ADDON_LOADED(event, addon)
    if addon ~= ADDON_NAME then return end
	if event == "ADDON_LOADED" then
		self:UnregisterEvent("ADDON_LOADED")
		self.ADDON_LOADED = nil
	end

    if IsLoggedIn() then self:PLAYER_LOGIN() else self:RegisterEvent("PLAYER_LOGIN") end
end

function ns:PLAYER_LOGIN()
    self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

    local frame = CreateFrame('Frame', nil, InterfaceOptionsFrame)
    frame:SetScript('OnShow', function(self)
        self:SetScript('OnShow', nil)
        if not IsAddOnLoaded('oUF_Freebgrid_Config') then
            LoadAddOn('oUF_Freebgrid_Config')
        end
    end)
		
    self:UnregisterEvent("PLAYER_LOGIN")
    self.PLAYER_LOGIN = nil
end

function ns:PLAYER_LOGOUT()
    self:FlushDB()
end

function ns:ACTIVE_TALENT_GROUP_CHANGED()
	ns.TalentChanged = true
	if not IsAddOnLoaded('oUF_Freebgrid_Config') then
            LoadAddOn('oUF_Freebgrid_Config')
    end
	self:InitDB()
end

function ns:Slash(inp)
    if(inp:match("%S+")) then
        if not IsAddOnLoaded('oUF_Freebgrid_Config') then
            LoadAddOn('oUF_Freebgrid_Config')
        end
        InterfaceOptionsFrame_OpenToCategory(ADDON_NAME)
    else
        ns.Movable()
    end
end

_G["SLASH_".. ADDON_NAME:upper().."1"] = GetAddOnMetadata(ADDON_NAME, "X-LoadOn-Slash")
SlashCmdList[ADDON_NAME:upper()] = function(inp)
    ns:Slash(inp)
end
