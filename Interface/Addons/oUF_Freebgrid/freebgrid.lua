local ADDON_NAME, ns = ...
local S,_,_,_ = unpack(SunUI)
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local L = ns.Locale

ns._Objects = {}
ns._Headers = {}

ns.nameCache = {}
ns.colorCache = {}
ns.debuffColor = {} 
ns.instDebuffs = {}

local media = LibStub("LibSharedMedia-3.0", true)
if media then
	media:Register("font", "Accidental Presidency",		[[Interface\Addons\oUF_Freebgrid\media\Accidental Presidency.ttf]])
	media:Register("font", "Expressway",				[[Interface\Addons\oUF_Freebgrid\media\expressway.ttf]])
	media:Register("statusbar", "gradient",				[[Interface\Addons\oUF_Freebgrid\media\gradient]])
	media:Register("statusbar", "Cabaret",				[[Interface\Addons\oUF_Freebgrid\media\Cabaret]])
	media:Register("statusbar", "statusbar7",				[[Interface\Addons\oUF_Freebgrid\media\statusbar7]])
	media:Register("statusbar", "statusbar",				[[Interface\Addons\oUF_Freebgrid\media\statusbar]])
end

local backdrop = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = S.Scale(2), left = S.Scale(2), bottom = S.Scale(2), right = S.Scale(2)},
}

local border = {
    bgFile = [=[Interface\AddOns\oUF_Freebgrid\media\white.tga]=],
    insets = {top = -S.Scale(2), left = -S.Scale(2), bottom = -S.Scale(2), right = -S.Scale(2)},
}

local border2 = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = -S.Scale(1), left = -S.Scale(1), bottom = -S.Scale(1), right = -S.Scale(1)},
}

local glowBorder = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    edgeFile = [=[Interface\AddOns\oUF_Freebgrid\media\glowTex.tga]=], edgeSize = S.Scale(5),
    insets = {left = S.Scale(3), right = S.Scale(3), top = S.Scale(3), bottom = S.Scale(3)}
}

local glowBorder2 = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    edgeFile = [=[Interface\AddOns\oUF_Freebgrid\media\glowTex.tga]=], edgeSize = S.Scale(3),
    insets = {left = S.Scale(1), right = S.Scale(1), top = S.Scale(1), bottom = S.Scale(1)}
}

local colors = setmetatable({
    power = setmetatable({
        ['MANA'] = {.31,.45,.63},
    }, {__index = oUF.colors.power}),
}, {__index = oUF.colors})

function ns:multicheck(check, ...)
    for i=1, select('#', ...) do
        if check == select(i, ...) then return true end
    end
    return false
end

function ns:hex(r, g, b)
    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

function ns:Getdifficulty()
	local _, instanceType, difficulty, _, maxPlayers, playerDifficulty, isDynamicInstance = GetInstanceInfo()
	if IsPartyLFG() and IsInLFGDungeon() and difficulty == 2 and instanceType == "raid" and maxPlayers == 25 then
		return "lfr25"
	elseif difficulty == 1 then
		return instanceType == "raid" and "normal10" or "normal5"
	elseif difficulty == 2 then
		return instanceType == "raid" and "normal25" or "heroic5"
	elseif difficulty == 3 then
		return "heroic10"
	elseif difficulty == 4 then
		return "heroic25"
	else
		return "unknown"
	end
end

function ns:GetTalentSpec()
	local spec = GetPrimaryTalentTree() or 0
	local name,group = "NONE",0
	
	if spec > 0 then
		group = GetActiveTalentGroup()
		name = select(2, GetTalentTabInfo(spec))
	end
	
	return spec, group, name
end

function ns:IsHealer()
	local _, class = UnitClass("player")
	local spec = ns:GetTalentSpec()

	if ((class == "SHAMAN" or class == "DRUID") and spec == 3) 
	or (class == "PALADIN" and spec == 1) or (class == "PRIEST" and (spec == 1 or spec == 2)) then
		return true
	end
	return false
end

function ns:GetMapID()
	SetMapToCurrentZone()
    local zone = GetCurrentMapAreaID()
	return zone
end

function ns:GetDispelClass()
	local _, class = UnitClass("player")
	local dispelClass = {				
		["PRIEST"] 	= { Disease = true, Magic = true},
		["SHAMAN"] 	= { Curse = true},
		["PALADIN"] = { Poison = true, Disease = true},
		["MAGE"] 	= { Curse = true},
		["DRUID"] 	= { Curse = true, Poison = true},
	}
	if class == "SHAMAN" and select(5, GetTalentInfo(3, 12)) == 1 then
		dispelClass[class].Magic = true	
	elseif class == "PALADIN" and select(5, GetTalentInfo(1, 14)) == 1 then
		dispelClass[class].Magic = true
		
	elseif class == "DRUID" and select(5, GetTalentInfo(3, 17)) == 1 then
		dispelClass[class].Magic = true			
	end
	return dispelClass[class] or {}
end

function ns:UpdateBlizzardRaidFrame()
	if InCombatLockdown() then return end
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameContainer:UnregisterAllEvents() 
	if ns.db.hideblzraid then
		CompactRaidFrameManager_SetSetting("IsShown", "0")
		CompactRaidFrameManager:Hide()
	else
		CompactRaidFrameManager:RegisterEvent("DISPLAY_SIZE_CHANGED")
		CompactRaidFrameManager:RegisterEvent("UI_SCALE_CHANGED")
		CompactRaidFrameManager:RegisterEvent("RAID_ROSTER_UPDATE")
		CompactRaidFrameManager:RegisterEvent("UNIT_FLAGS")
		CompactRaidFrameManager:RegisterEvent("PLAYER_FLAGS_CHANGED")
		CompactRaidFrameManager:RegisterEvent("PLAYER_ENTERING_WORLD")
		CompactRaidFrameManager:RegisterEvent("PARTY_LEADER_CHANGED")
		CompactRaidFrameManager:RegisterEvent("RAID_TARGET_UPDATE")
		CompactRaidFrameManager:RegisterEvent("PLAYER_TARGET_CHANGED")
		CompactRaidFrameManager:RegisterEvent("PARTY_MEMBERS_CHANGED")
				
		CompactRaidFrameContainer:RegisterEvent("RAID_ROSTER_UPDATE")
		CompactRaidFrameContainer:RegisterEvent("PARTY_MEMBERS_CHANGED")
		CompactRaidFrameContainer:RegisterEvent("UNIT_PET")
		CompactRaidFrameManager_SetSetting("IsShown", true)
		CompactRaidFrameManager:Show()
	end
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
local updateDispel = function(self, event, unit)
	if ns.db.dispel ~= "BORDER" or self.unit ~= unit then return end

    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(unit, index, 'HARMFUL')
        if not name then break end
		if ns.general.dispellist[dtype] then
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			self.DispelBorder:SetBackdropBorderColor(color.r, color.g, color.b, 1)
			self.DispelBorder:Show()
			return 
		end
        index = index + 1
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

local utf8sub = function(str, start, numChars) 
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
            if name:GetStringWidth() <= ns.db.width - 8 then 
				name:SetText(nil)
				break 
			end
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

local updateHealth = function(self, event, unit)
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

		if  UnitPlayerControlled(unit) and not UnitIsPlayer(unit) then
			hp:SetStatusBarColor(V.r, V.g, V.b, 0.9)
			hp.bg:SetVertexColor(V.r*.2, V.g*.2, V.b*.2)
			return
		elseif ns.db.definecolors then
			if ns.db.classbgcolor then
				hp.bg:SetVertexColor(r, g, b)
			else
				hp.bg:SetVertexColor(Hbg.r, Hbg.g, Hbg.b)
			end			
			hp:SetStatusBarColor(H.r, H.g, H.b, 0.9)
			return 
		elseif ns.db.reversecolors  then
			hp.bg:SetVertexColor(r*.2, g*.2, b*.2)
			hp:SetStatusBarColor(r, g, b, 0.9)
		else
			hp.bg:SetVertexColor(r, g, b)
			hp:SetStatusBarColor(0, 0, 0, .9)
		end		
	else
		hp:SetStatusBarColor(E.r, E.g, E.b, 0.9)
		hp.bg:SetVertexColor(E.r*.2, E.g*.2, E.b*.2)
	end
end

function ns:UpdateHealth(hp)
    hp:SetStatusBarTexture(ns.db.texturePath)
    hp:SetOrientation(ns.db.orientation)
    hp.bg:SetTexture(ns.db.texturePath)

	hp.freebSmooth = ns.db.smooth

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

local PostPower = function(power, unit)
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

    local perc = oUF.Tags.Methods['perpp'](unit)
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
	if not ns.db.roleicon then return end
	local lfdrole = self.LFDRole
	local role = UnitGroupRolesAssigned(self.unit)

	if role == 'TANK' then
		lfdrole:SetTexture([[Interface\AddOns\oUF_Freebgrid\media\tank.tga]])
	elseif role == 'HEALER' then
		lfdrole:SetTexture([[Interface\AddOns\oUF_Freebgrid\media\healer.tga]])
	elseif role == 'DAMAGER' then
		lfdrole:SetTexture([[Interface\AddOns\oUF_Freebgrid\media\dps.tga]])
	end

	if role ~= 'NONE' then		
		lfdrole:Show()
	else
		lfdrole:Hide()
	end	
end

local ResurrectIconUpdate = function(self, event)
	local incomingResurrect = UnitHasIncomingResurrection(self.unit)
	local resurrect = self.ResurrectIcon
	if UnitIsDeadOrGhost(self.unit) and incomingResurrect then
		resurrect:Show()
	else
		resurrect:Hide()
	end
end

-- 鼠标滑过高亮
local OnEnter = function(self)
	ns.MouseoverUnit = self.unit
    if ns.db.tooltip and InCombatLockdown() then	
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

local round = function(n)
    return math.floor(n * 1e5 + .5) / 1e5
end

local getPoint = function(obj)
    local UIx, UIy = UIParent:GetCenter()
    local Ox, Oy = obj:GetCenter()
	
    if(not Ox) then return end

    local UIS = UIParent:GetEffectiveScale()
    local OS = obj:GetEffectiveScale()

    local UIWidth, UIHeight = UIParent:GetRight(), UIParent:GetTop()

    local LEFT = UIWidth / 3
    local RIGHT = UIWidth * 2 / 3

    local point, x, y
    if(Ox >= RIGHT) then
        point = 'RIGHT'
        x = obj:GetRight() - UIWidth
    elseif(Ox <= LEFT) then
        point = 'LEFT'
        x = obj:GetLeft()
    else
        x = Ox - UIx
    end

    local BOTTOM = UIHeight / 3
    local TOP = UIHeight * 2 / 3

    if(Oy >= TOP) then
        point = 'TOP' .. (point or '')
        y = obj:GetTop() - UIHeight
    elseif(Oy <= BOTTOM) then
        point = 'BOTTOM' .. (point or '')
        y = obj:GetBottom()
    else
        if(not point) then point = 'CENTER' end
        y = Oy - UIy
    end

    return string.format(
    '%s\031%s\031%d\031%d',
    point, 'UIParent', round(x * UIS / OS),  round(y * UIS / OS)
    )
end

local savePosition = function(anchor)
	local _DB = ns.db.Freebgridomf2Char or {}

    local style, identifier  = "Freebgrid", anchor:GetName()
    if(not _DB[style]) then _DB[style] = {} end

    _DB[style][identifier] = getPoint(anchor)
	ns.db.Freebgridomf2Char = _DB
end

local anchorpool = {}

function ns:RestoreDefaultPosition()
	if not ns.db then return end
	local _DB = ns.db.Freebgridomf2Char or {}
	
    for _, anchor in next, anchorpool do
		local style, identifier = "Defaults", anchor:GetName()

		if(_DB[style] and _DB[style][identifier]) then 
			local scale = anchor:GetScale()
			local point, parentName, x, y = string.split('\031', _DB[style][identifier])
			anchor:ClearAllPoints();
			anchor:SetPoint(point, parentName, point, x / scale, y / scale)
		end
	end
end

function ns:RestorePosition()
	local _DB = ns.db.Freebgridomf2Char or {}
	for _, anchor in next, anchorpool do
        local style, identifier = "Freebgrid", anchor:GetName()
		if(_DB[style] and _DB[style][identifier]) then 
			local scale = anchor:GetScale()
			local point, parentName, x, y = string.split('\031', _DB[style][identifier])
			anchor:ClearAllPoints();
			anchor:SetPoint(point, parentName, point, x / scale, y / scale)
		end
    end
end

local OnDragStart = function(self)
	self:StartMoving()
	self:ClearAllPoints()
end

local OnDragStop = function(self)
	self:StopMovingOrSizing()
	savePosition(self)
end

local setframe = function(frame)
	frame:SetHeight(ns.db.height)
	frame:SetWidth(ns.db.width)
	frame:SetFrameStrata"TOOLTIP"
	frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background";})
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag"LeftButton"
	frame:SetBackdropBorderColor(0, .9, 0)
	frame:SetBackdropColor(0, .9, 0)
	frame:Hide()

	frame:SetScript("OnDragStart", OnDragStart)
	frame:SetScript("OnDragStop", OnDragStop)

	frame.name = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.name:SetPoint"CENTER"
	frame.name:SetJustifyH"CENTER"
	frame.name:SetFont(GameFontNormal:GetFont(), 12)
	frame.name:SetTextColor(1, 1, 1)

	return frame
end

local Anchors = function()

	local raidframe = CreateFrame("Frame", "oUF_FreebgridRaidFrame", UIParent)
	setframe(raidframe)
	raidframe.ident = "Raid"
	raidframe.name:SetText("Raid")
	raidframe:SetPoint("LEFT", UIParent, "LEFT", 8, 0)
	anchorpool["oUF_FreebgridRaidFrame"] = raidframe

	local petframe = CreateFrame("Frame", "oUF_FreebgridPetFrame", UIParent)
	setframe(petframe)
	petframe.ident = "Pet"
	petframe.name:SetText("Pet")
	petframe:SetPoint("LEFT", UIParent, "LEFT", 250, 0)
	anchorpool["oUF_FreebgridPetFrame"] = petframe

	local mtframe = CreateFrame("Frame", "oUF_FreebgridMTFrame", UIParent)
	setframe(mtframe)
	mtframe.ident = "MT"
	mtframe.name:SetText("MT")
	mtframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 8, -60)
	anchorpool["oUF_FreebgridMTFrame"] = mtframe

	ns:RestorePosition()
end

local _LOCK
function ns:Movable()

    if(not _LOCK) then
        for k, frame in next, anchorpool do
            frame:Show()
        end
        _LOCK = true
    else
        for k, frame in next, anchorpool do
            frame:Hide()
        end
        _LOCK = nil
    end
end
--设置样式
local style = function(self)
    self.menu = menu

	-- 鼠标事件
    self:SetScript("OnEnter", OnEnter)
    self:SetScript("OnLeave", OnLeave)
    self:RegisterForClicks"AnyDown"
	
	if type(ns.db.ClickCast) == "table" and type(ns.RegisterClicks) == "function" then
		ns:RegisterClicks(self)
	end
    -- 背景边框
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

    -- 生命条
    local Health = CreateFrame"StatusBar"
    Health:SetParent(self)
    Health.frequentUpdates = true
    Health.bg = Health:CreateTexture(nil, "BORDER")
    Health.bg:SetAllPoints(Health)
    Health.Override = updateHealth
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

	 -- 能力条
    local Power = CreateFrame"StatusBar"
    Power:SetParent(self)
    Power.bg = Power:CreateTexture(nil, "BORDER")
    Power.bg:SetAllPoints(Power)
	self.Power = Power
    ns:UpdatePower(self.Power)
	
    -- 仇恨边框
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
    name:SetShadowOffset(1, -1)
    name:SetWidth(ns.db.width)
    name.overrideUnit = true
    self.Name = name
    self:Tag(self.Name, '[freebgrid:name]')

    -- 高亮材质
    local hl = self.Health:CreateTexture(nil, "OVERLAY")
    hl:SetAllPoints(self)
    hl:SetTexture([=[Interface\AddOns\oUF_Freebgrid\media\white.tga]=])
    hl:SetVertexColor(1,1,1,.1)
    hl:SetBlendMode("ADD")
    hl:Hide()
    self.Highlight = hl
	
    -- 悬停高亮边框
    local hlBorder = CreateFrame("Frame", nil, self)
    hlBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
    hlBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    hlBorder:SetBackdrop(border)
    hlBorder:SetBackdropColor(.8, .5, .5, .8)
    hlBorder:SetFrameLevel(2)
    hlBorder:Hide()
    self.HighlightBorder = hlBorder

	-- GCD条
    local GCD = CreateFrame("StatusBar", nil, self)
    GCD:SetAllPoints(self)
    GCD:SetStatusBarTexture([=[Interface\AddOns\oUF_Freebgrid\media\white.tga]=])
    GCD:SetStatusBarColor(.4, .5, .4, .6)
    GCD:SetValue(0)
    GCD:SetFrameLevel(4)
    GCD:SetOrientation(ns.db.porientation)
    GCD:Hide()
    self.GCD = GCD	

    -- 焦点目标高亮边框
    local fBorder = CreateFrame("Frame", nil, self)
    fBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
    fBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    fBorder:SetBackdrop(border)
    fBorder:SetBackdropColor(0, 0, 0, 0)
    fBorder:SetFrameLevel(1)
    fBorder:Hide()
    self.FocusHighlight = fBorder
	
	-- 可驱散debuff显示边框
    local dispelBorder = CreateFrame("Frame", nil, self)
    dispelBorder:SetPoint("TOPLEFT", self, "TOPLEFT" )
    dispelBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    dispelBorder:SetBackdrop(glowBorder2)
    dispelBorder:SetBackdropColor(0, 0, 0, 0)
	dispelBorder:SetBackdropBorderColor(0, 0, 0, 0)
    dispelBorder:SetFrameLevel(5)
    dispelBorder:Hide()
    self.DispelBorder = dispelBorder

    -- 团队图标
    local ricon = self.Health:CreateTexture(nil, 'OVERLAY')
    ricon:SetPoint("TOP", self, -15, 6)
    ricon:SetSize(ns.db.leadersize+2, ns.db.leadersize+2)
    self.RaidIcon = ricon

    -- 队长图标
    local Leader = self.Health:CreateTexture(nil, "OVERLAY")
    Leader:SetPoint("TOPLEFT", self, 0, 8)
    Leader:SetSize(ns.db.leadersize, ns.db.leadersize )
	self.Leader = Leader

    -- 助手等图标
    local Assistant = self.Health:CreateTexture(nil, "OVERLAY")
    Assistant:SetPoint("TOPLEFT", self, 0, 8)
    Assistant:SetSize(ns.db.leadersize, ns.db.leadersize)
	self.Assistant = Assistant

	--拾取权限图标
    local masterlooter = self.Health:CreateTexture(nil, 'OVERLAY')
    masterlooter:SetSize(ns.db.leadersize, ns.db.leadersize)
    masterlooter:SetPoint('LEFT', self.Leader, 'RIGHT')
    self.MasterLooter = masterlooter

    -- 职业图标
	local LFDRole = self.Health:CreateTexture(nil, 'OVERLAY')
	LFDRole:SetSize(ns.db.leadersize + 4, ns.db.leadersize + 4)
	LFDRole:SetPoint('RIGHT', self, 'LEFT', ns.db.leadersize, 0)
	LFDRole.Override = RoleIconUpdate
	self:RegisterEvent("UNIT_CONNECTION", RoleIconUpdate)
	self.LFDRole = LFDRole

	--复活提示图标
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

    --准备确认图标
    local ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
    ReadyCheck:SetPoint("TOP", self)
    ReadyCheck:SetSize(ns.db.leadersize, ns.db.leadersize)
	self.ReadyCheck = ReadyCheck

    -- 光环图标
    local auras = CreateFrame("Frame", nil, self)
    auras:SetSize(ns.db.aurasize, ns.db.aurasize)
    auras:SetPoint("CENTER", self.Health)
    auras.size = ns.db.aurasize
    self.freebAuras = auras
	
	local secauras = CreateFrame("Frame", nil, self)
    secauras:SetSize(ns.db.secaurasize, ns.db.secaurasize)
    secauras:SetPoint("LEFT", self.Health)
    secauras.size = ns.db.secaurasize
    self.freebSecAuras = secauras

    self:RegisterEvent('PLAYER_FOCUS_CHANGED', FocusTarget)
    self:RegisterEvent('RAID_ROSTER_UPDATE', FocusTarget)
    self:RegisterEvent('PLAYER_TARGET_CHANGED', FocusTarget)
    self:RegisterEvent('RAID_ROSTER_UPDATE', FocusTarget)
	self:RegisterEvent('UNIT_AURA', updateDispel)

    self:SetScale(ns.db.scale)

    table.insert(ns._Objects, self)
end

oUF:RegisterStyle("Freebgrid", style)

local buildPosition = function(name)
	local horiz, grow, spacing = ns.db.horizontal, ns.db.growth, ns.db.spacing 
	local initconfig = [[
		self:SetWidth(%d)
		self:SetHeight(%d)
		]]
	if name == "pet" then
		horiz, grow = ns.db.pethorizontal, ns.db.petgrowth
		initconfig = [[ 
        self:SetWidth(%d)        
        self:SetHeight(%d)           
        self:SetAttribute('unitsuffix', 'pet')
        ]]
	elseif name == "mt" then
		horiz, grow = ns.db.MThorizontal, ns.db.MTgrowth		
	end

    if horiz then	
        point = "LEFT"
        xoff = spacing
        yoff = 0
        if grow == "UP" then
            growth = "BOTTOM"
            pos = "BOTTOMLEFT"
            posRel = "TOPLEFT"
            colY = spacing
			colX = 0
        else
            growth = "TOP"
            pos = "TOPLEFT"
            posRel = "BOTTOMLEFT"
            colY = -spacing
			colX = 0
        end
    else
        point = "TOP"
        xoff = 0
        yoff = -spacing
        if grow == "RIGHT" then
            growth = "BOTTOM"
            pos = "TOPLEFT"
            posRel = "TOPRIGHT"
            colX = spacing
			colY = 0
        else
            growth = "RIGHT"
            pos = "TOPRIGHT"
            posRel = "TOPLEFT"
            colX = -spacing
			colY = 0
        end
    end
	return pos, posRel, colX, colY, point, growth, xoff, yoff, initconfig
end

local function freebHeader(name, group, temp, htype)
	local _, _, colX, colY, point, growth, xoff, yoff, initconfig = buildPosition(htype)
	
    local template = temp or nil
    local header = oUF:SpawnHeader(name, template, 'raid,party,solo',
    'oUF-initialConfigFunction', (initconfig):format(ns.db.width, ns.db.height),
    'showPlayer', ns.db.player,
    'showSolo', ns.db.solo,
    'showParty', ns.db.party,
    'showRaid', true,
    'xOffset',	xoff,
    'yOffset', yoff,
    'point', point,
    'groupFilter', group,
    'groupingOrder', "1,2,3,4,5,6,7,8",
    'groupBy', "GROUP",
    'maxColumns', 8,
    'unitsPerColumn', 5,
    'columnSpacing', ns.db.spacing,
    'columnAnchorPoint', growth)
    return header
end

oUF:Factory(function(self)
	ns:InitDB()
    ns:Colors()
	Anchors()
	
	hooksecurefunc("CompactRaidFrameManager_UpdateShown", ns.UpdateBlizzardRaidFrame)

    self:SetActiveStyle"Freebgrid"
	
	for i = 1, 8 do
		local group = freebHeader("Raid_Freebgrid"..i, i)
		ns._Headers[group:GetName()] = group
	end

	local tank = freebHeader("MT_Freebgrid", nil, nil, "mt")
	tank:SetAttribute('groupFilter', 'MAINTANK')
	ns._Headers[tank:GetName()] = tank
	
	local pet = freebHeader("Pet_Freebgrid", nil, 'SecureGroupPetHeaderTemplate', "pet")
	pet:SetAttribute('useOwnerUnit', true)
	ns._Headers[pet:GetName()] = pet

	ns:UpdateAttribute()
end)

function ns:UpdateAttribute()
	if ns:CheckCombat(ns.UpdateAttribute) then return end
	
	local pos, posRel, colX, colY, point, growth, xoff, yoff, initconfig = buildPosition()

	local lastgroup, group
	
	for i = 1, 8 do
		group = ns._Headers["Raid_Freebgrid"..i]

		group :SetAttribute( 'oUF-initialConfigFunction', (initconfig):format(ns.db.width, ns.db.height))
		group :SetAttribute( 'groupBy', "GROUP")
		group :SetAttribute( 'showParty', ns.db.party)
		group :SetAttribute( 'showRaid', true)
		group :SetAttribute( 'showSolo', ns.db.solo)
		group :SetAttribute( 'showPlayer', ns.db.player)
		group :SetAttribute( 'point', point)		
		group :SetAttribute( 'groupingOrder', "1,2,3,4,5,6,7,8")		
		group :SetAttribute( 'maxColumns', 8)
		group :SetAttribute( 'unitsPerColumn', 5)
		group :SetAttribute( 'columnSpacing', ns.db.spacing)
		group :SetAttribute( 'xOffset', xoff)
		group :SetAttribute( 'yOffset', yoff)
		--group :SetAttribute( 'columnAnchorPoint', growth)
		group :SetAttribute( 'groupFilter', i <= ns.db.numCol and i or 0)
	
		group:ClearAllPoints()
		if i == 1 then
			group:SetPoint(pos, "oUF_FreebgridRaidFrame", pos)
		else
			group:SetPoint(pos, lastgroup, posRel, colX , colY )
		end
		lastgroup = group
	end
	--MT和宠物这块没完成.
	local pet = ns._Headers["Pet_Freebgrid"]
	if ns.db.pets then
		pet:SetAttribute('useOwnerUnit', true)

		pet:ClearAllPoints()
		pet:SetPoint(pos, "oUF_FreebgridPetFrame", pos)
	else
		pet:SetAttribute('useOwnerUnit', false)
	end
	
	local mt = ns._Headers["MT_Freebgrid"]
	if ns.db.MT then
		mt:SetAttribute('groupFilter', 'MAINTANK')
		mt:ClearAllPoints()
		mt:SetPoint(pos, "oUF_FreebgridMTFrame", pos)
	else
		mt:SetAttribute('groupFilter', '')
	end
	local i = 0 
	for _, object in next, ns._Objects do
		object:ClearAllPoints()
	end
	collectgarbage("collect")
end

local lockprint
local updatelist = {}
function ns:CheckCombat(func)
	if(InCombatLockdown()) then
		ns:RegisterEvent("PLAYER_REGEN_ENABLED")
		if not updatelist.func then
			table.insert(updatelist, func)
		end
		if not lockprint then
			lockprint = true
			print(ADDON_NAME..": "..L.incombatlock)
		end
		return true
	end
	return false
end

function ns:PLAYER_REGEN_ENABLED()
	print(ADDON_NAME..": "..L.outcombatlock)

    lockprint = nil
	for _, v in pairs (updatelist) do
		if type(v) == "function" then v() end
	end	
    ns:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

local getZone = function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed < 5 then return end	

	local mapid = ns:GetMapID()
    if IsInInstance() then       		 
		ns.difficulty = ns:Getdifficulty()
		
		local tbl = ns.auras or {}	
		tbl.first = tbl.first or {}
		tbl.second = tbl.second or {}
		
		if type(tbl.first.instances) == "table" or type(tbl.second.instances) == "table" then	
			local mapname = GetMapNameByID(mapid)		
			ns.instDebuffs.first = tbl.first.instances[mapid] or tbl.first.instances[mapname] or {}	
			ns.instDebuffs.second = tbl.second.instances[mapid] or tbl.second.instances[mapname] or {}
		end
    end
	ns.general.MapID = mapid
    self:SetScript("OnUpdate", nil)
    self.elapsed = 0
end

local updateData = function(self, event, ...)
	if event == "ACTIVE_TALENT_GROUP_CHANGED" then	
		ns:LoadPlayerData()

		if ns.general.TalentGroup > 0 and not _G[ADDON_NAME.."DB"].profileKeys[ns.general.playerDBKey].dualspec then
			if not IsAddOnLoaded('oUF_Freebgrid_Config') then
				LoadAddOn('oUF_Freebgrid_Config')
			end
			ns:FlushDB()
			ns.general.Profilename = _G[ADDON_NAME.."DB"].profileKeys[ns.general.playerDBKey].profile[tostring(ns.general.TalentGroup)]

			ns.db = _G[ADDON_NAME.."DB"].profiles[ns.general.Profilename]
			ns:CopyDefaults(ns.db, ns.defaults)
			
			ns:UpdateAttribute()
			ns:updateObjects()
			ns:RestorePosition()
		end
		
	elseif event == "CHARACTER_POINTS_CHANGED" then
		ns:LoadPlayerData()
	elseif event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
		if event == "PLAYER_ENTERING_WORLD" then	
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end 
		self:SetScript("OnUpdate", getZone)
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
	
	local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
    f:SetScript('OnShow', function(self)
        self:SetScript('OnShow', nil)
        if not IsAddOnLoaded('oUF_Freebgrid_Config') then
            LoadAddOn('oUF_Freebgrid_Config')
        end
    end)
	
	local frame = CreateFrame('Frame')
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	frame:RegisterEvent("CHARACTER_POINTS_CHANGED")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	frame:SetScript("OnEvent", updateData)
	
	
	self:UnregisterEvent("PLAYER_LOGIN")
    self.PLAYER_LOGIN = nil
end

function ns:PLAYER_LOGOUT()
    self:FlushDB()
end

function ns:Slash(inp)
    if(inp:match("%S+")) then
        if not IsAddOnLoaded('oUF_Freebgrid_Config') then
            LoadAddOn('oUF_Freebgrid_Config')
        end
        InterfaceOptionsFrame_OpenToCategory(ADDON_NAME)
    else
        ns:Movable()
    end
end

_G["SLASH_".. ADDON_NAME:upper().."1"] = GetAddOnMetadata(ADDON_NAME, "X-LoadOn-Slash")
SlashCmdList[ADDON_NAME:upper()] = function(inp)
    ns:Slash(inp)
end

Freebgrid_NS = ns