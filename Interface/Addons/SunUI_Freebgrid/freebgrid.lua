local ADDON_NAME, ns = ...
local S, _, DB = unpack(SunUI)
local _G = _G
local L = ns.Locale
ns._Objects = {}
ns._Headers = {}

local media = LibStub("LibSharedMedia-3.0", true)
if media then
	media:Register("font", "Accidental Presidency",		[[Interface\Addons\SunUI_Freebgrid\media\AccidentalPresidency.ttf]])
	media:Register("font", "Expressway",				[[Interface\Addons\SunUI_Freebgrid\media\expressway.ttf]])
	media:Register("statusbar", "gradient",				[[Interface\Addons\SunUI_Freebgrid\media\gradient]])
	media:Register("statusbar", "Cabaret",				[[Interface\Addons\SunUI_Freebgrid\media\Cabaret]])
	media:Register("statusbar", "sunui",				[[Interface\Addons\SunUI_Freebgrid\media\statusbar7]])
	media:Register("statusbar", "waterline", [[Interface\Addons\SunUI_Freebgrid\media\waterline]])
end

local backdrop = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = S.Scale(1), left = S.Scale(1), bottom = S.Scale(1), right = S.Scale(1)},
}

local border = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = -S.Scale(1), left = -S.Scale(1), bottom = -S.Scale(1), right = -S.Scale(1)},
}

local glowBorder = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    edgeFile = [=[Interface\AddOns\SunUI_Freebgrid\media\glowTex.tga]=], edgeSize = S.Scale(5),
    insets = {left = S.Scale(3), right = S.Scale(3), top = S.Scale(3), bottom = S.Scale(3)}
}

local OnAttributeChanged = function(self, name, value)
	if name == "unit" and value then
		if type(value) == "string" then
			self.unit = value
			self.displayedUnit = value
			if not self.hasRegisterEvent then
				ns:RegisterEvents(self)
				self.hasRegisterEvent = true
			end
			ns:UpdateAllElements(self)
		else
			self.unit = nil
			self.displayedUnit = nil
		end
	end
end

local Freebgrid_OnShow = function(self)
	self:SetSize(ns.db.width, ns.db.height)
	self:SetScale(ns.db.scale)
	if not self.hasRegisterEvent then
		ns:RegisterEvents(self)
		self.hasRegisterEvent = true
	end
end

local Freebgrid_OnHide = function(self)
	if self.hasRegisterEvent then
		ns:UnregisterEvents(self)
		self.hasRegisterEvent = nil
	end
end

local Freebgrid_OnEnter = function(self)

	ns.GcdMouseoverUnit = self.displayedUnit
	self.ArrowMouseoverUnit = true
    if ns.db.tooltip and InCombatLockdown() then	
		GameTooltip:Hide()       
    else
        UnitFrame_OnEnter(self)
    end
	
    if ns.db.highlight then
		self.Highlight:Show()		
    end
end

local Freebgrid_OnLeave = function(self)
	self.ArrowMouseoverUnit = nil

    if not ns.db.tooltip then UnitFrame_OnLeave(self) end
    self.Highlight:Hide()
	GameTooltip:Hide() 
    if self.Freebarrow:IsShown() and ns.db.arrowmouseover then
       self.Freebarrow:Hide()
    end
end

local function OnUpdateUnitFrame(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed < .2 then 
		ns:UpdateHealthSmooth(self)
	return end
	
	ns:UpdateInRange(self)
	ns:CheckReadyCheckDecay(self, elapsed)
	ns:UpdateArrow(self)
	ns:UpdateIndicatorTimer(self)
	self.elapsed = 0
end

local Freebgrid_OnUpdate = function(self, elapsed)
	OnUpdateUnitFrame(self, elapsed)	
end

local Freebgrid_OnEvent = function(self, event, ...)

	local arg1, arg2, arg3, arg4 = ...

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		ns:UpdateAllElements(self)
	elseif ( event == "RAID_TARGET_UPDATE" ) then
		ns:UpdateRaidIcon(self)
	elseif ( event == "PARTY_MEMBERS_CHANGED" or event == "PARTY_LEADER_CHANGED" or event == "PARTY_LOOT_METHOD_CHANGED") then 
		ns:UpdateLeaderAndAssistantIcon(self)
		ns:UpdateMasterlooterIcon(self)
	elseif ( event == "PARTY_LOOT_METHOD_CHANGED" ) then
		ns:UpdateMasterlooterIcon(self)
	elseif ( event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED") then
		ns:UpdateSelectionHighlight(self)
	elseif ( event == "PLAYER_ROLES_ASSIGNED" ) then
		ns:UpdateRoleIcon(self)
	elseif ( event == "PLAYER_FLAGS_CHANGED" or event == "UNIT_FLAGS" ) then
		ns:UpdateStatusText(self)
	elseif ( event == "READY_CHECK" ) then
		ns:UpdateReadyCheck(self)
	elseif ( event == "READY_CHECK_FINISHED" ) then
		ns:FinishReadyCheck(self)
	elseif ( event == "PARTY_MEMBER_DISABLE" or event == "PARTY_MEMBER_ENABLE" ) then
		ns:UpdateStatusText(self)
		ns:UpdatePowerBar(self)
		ns:UpdatePower(self)	
		ns:UpdateThreatBorder(self)
	elseif ( event == "ACTIONBAR_UPDATE_COOLDOWN" ) then
		ns:UpdateGcdBar(self)
	elseif ( arg1 == self.unit or arg1 == self.displayedUnit or (arg1 == "vehicle" and self.inVehicle)) then
		if ( event == "UNIT_MAXHEALTH" ) then		
			ns:UpdateMaxHealth(self)
			ns:UpdateHealth(self)		
			ns:UpdateHealPrediction(self)
			ns:UpdateStatusText(self)
		elseif ( event == "UNIT_HEALTH" or event == "UNIT_HEALTH_FREQUENT" ) then
			ns:UpdateHealth(self)
			ns:UpdateStatusText(self)
			ns:UpdateHealthColor(self)
		elseif ( event == "UNIT_MAXPOWER" or  event == "UNIT_POWER" ) then
			ns:UpdatePower(self)
			ns:UpdateThreatBorder(self)
		elseif (event == "UNIT_DISPLAYPOWER" or event == "UNIT_POWER_BAR_SHOW" or event == "UNIT_POWER_BAR_HIDE" )then
			ns:UpdatePowerBar(self)
		elseif ( event == "UNIT_NAME_UPDATE" ) then
			ns:UpdateName(self)
			ns:UpdateHealthColor(self)
		elseif ( event == "UNIT_AURA" ) then
			ns:UpdateAuras(self)
			ns:UpdateIndicators(self)
			ns:UpdateDispelIcon(self)
		elseif ( event == "UNIT_THREAT_SITUATION_UPDATE" ) then
			ns:UpdateThreatBorder(self)
		elseif ( event == "UNIT_CONNECTION" ) then
			ns:UpdateHealthColor(self)
			ns:UpdatePower(self)
			ns:UpdateStatusText(self)
			ns:UpdateRoleIcon(self)
			ns:UpdateThreatBorder(self)
		elseif ( event == "UNIT_HEAL_PREDICTION" ) then
			ns:UpdateHealPrediction(self)
		elseif ( event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_PET" ) then
			ns:UpdateAllElements(self)
		elseif ( event == "READY_CHECK_CONFIRM" ) then
			ns:UpdateReadyCheck(self)
		elseif ( event == "INCOMING_RESURRECT_CHANGED" ) then
			ns:UpdateResurrectIcon(self)
		end
	end
end

function ns:RegisterEvents(button)
	button:RegisterEvent("PLAYER_ENTERING_WORLD" )
	button:RegisterEvent("PLAYER_TARGET_CHANGED" )
	button:RegisterEvent("PLAYER_ROLES_ASSIGNED" )
	button:RegisterEvent("PLAYER_FOCUS_CHANGED" )
	button:RegisterEvent("PLAYER_FLAGS_CHANGED" )
	
	button:RegisterEvent("UNIT_FLAGS" )
	button:RegisterEvent("UNIT_HEALTH" )
	button:RegisterEvent("UNIT_MAXHEALTH" )
	button:RegisterEvent("UNIT_POWER" )
	button:RegisterEvent("UNIT_MAXPOWER" )
	button:RegisterEvent("UNIT_DISPLAYPOWER" )
	button:RegisterEvent("UNIT_POWER_BAR_SHOW" )
	button:RegisterEvent("UNIT_POWER_BAR_HIDE" )
	button:RegisterEvent("UNIT_NAME_UPDATE" )
	button:RegisterEvent("UNIT_CONNECTION" )
	button:RegisterEvent("UNIT_HEAL_PREDICTION" )
	button:RegisterEvent("UNIT_AURA" )	
	button:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE" )	
	button:RegisterEvent("UNIT_ENTERED_VEHICLE" )
	button:RegisterEvent("UNIT_EXITED_VEHICLE" )
	button:RegisterEvent("UNIT_PET" )
	button:RegisterEvent("UNIT_HEALTH_FREQUENT" )
	
	button:RegisterEvent("READY_CHECK" )
	button:RegisterEvent("READY_CHECK_FINISHED" )
	button:RegisterEvent("READY_CHECK_CONFIRM" )
	button:RegisterEvent("PARTY_MEMBER_DISABLE" )
	button:RegisterEvent("PARTY_MEMBER_ENABLE" )
		
	button:RegisterEvent("RAID_TARGET_UPDATE" )
	button:RegisterEvent("PARTY_MEMBERS_CHANGED" )
	button:RegisterEvent("PARTY_LEADER_CHANGED" )
	button:RegisterEvent("PARTY_LOOT_METHOD_CHANGED" )
	button:RegisterEvent("INCOMING_RESURRECT_CHANGED" )
	button:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN" )

end

function ns:UnregisterEvents(button)
	button:UnregisterAllEvents()
end

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

function ns:Numberize(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end

function ns:Getdifficulty()
	local _, instanceType, difficulty, _, maxPlayers, _, dynamic  = GetInstanceInfo()
	if (instanceType=='pvp') or (instanceType=='arena') then return "unknow" end
	
	if instanceType == 'party' then
		return "heroic5"
	elseif instanceType == 'raid' and dynamic then
		if difficulty >= 7 then
			return "lfr25"
		elseif difficulty >= 5 then
			return "heroic"..maxPlayers
		else
			return "normal"..maxPlayers
		end
	else
		return "normal"..maxPlayers
	end
end

function ns:GetTalentSpec()
	local spec = GetSpecialization() or 0
	local name,group = "NONE",0
	
	if spec > 0 then
		group = GetActiveSpecGroup()
		name = select(2, GetSpecializationInfo(spec))
	end
	
	return spec, group, name
end

function ns:IsHealer()
	local _, class = UnitClass("player")
	local spec = self:GetTalentSpec()

	if (class == "SHAMAN" and spec == 3) or (class == "DRUID" and spec == 4) or (class == "MONK" and spec == 2)
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
		["PRIEST"] 	= { Magic = true},
		["SHAMAN"] 	= { Curse = true},
		["PALADIN"]	= { Poison = true, Disease = true},
		["MAGE"] 	= { Curse = true},
		["DRUID"] 	= { Curse = true, Poison = true},
		["MONK"]	= { Poison = true, Disease = true},
	}
	if class == "SHAMAN" and GetSpecialization() == 3 then
		dispelClass[class].Magic = true	
	elseif class == "PALADIN" and GetSpecialization() == 1 then
		dispelClass[class].Magic = true
	elseif class == "MONK" and GetSpecialization() == 2 then
		dispelClass[class].Magic = true	
	elseif class == "DRUID" and GetSpecialization() == 4 then
		dispelClass[class].Magic = true	
	elseif class == "PRIEST" and ((GetSpecialization() == 1) or (GetSpecialization() == 2)) then
		dispelClass[class].Disease = true 	
	end
	return dispelClass[class] or {}
end

function ns:UpdateBlizzardRaidFrame()

	ns:UpdateBlizzardCompactRaidFrameManager()
	
	if GetDisplayedAllyFrames() == "raid" then	
		if ns.db.hideblzraid then
				--[[ local frame = CompactRaidFrameManager
				frame:UnregisterAllEvents()
				frame.Show = function() end
				frame:Hide()
				frame = CompactRaidFrameContainer
				frame:UnregisterAllEvents()
				frame.Show = function() end
				frame:Hide() ]]
			CompactRaidFrameContainer:Kill()
			CompactRaidFrameManager:Kill()
		else
			if not _G["CompactRaidFrameManager"]:IsEventRegistered("GROUP_ROSTER_UPDATE") then		
				_G["CompactRaidFrameManager"]:RegisterEvent("GROUP_ROSTER_UPDATE")
				_G["CompactRaidFrameManager"]:RegisterEvent("UNIT_PET")
			end
			CompactRaidFrameManager_SetSetting("IsShown", true)
		end
	end	
end

local RegisterStateDriver = RegisterStateDriver
function ns:UpdateBlizzardPartyFrameDisplayStatus()
	ns:UpdateBlizzardCompactRaidFrameManager()
	--[[ for i = 1, 4 do	
		local frame = _G["PartyMemberFrame"..i]
		if ns.db.hideblzparty then			
			frame:UnregisterAllEvents()
			frame:Kill()

			local health = frame.healthbar
			if(health) then
				health:UnregisterAllEvents()
			end

			local power = frame.manabar
			if(power) then
				power:UnregisterAllEvents()
			end

			local spell = frame.spellbar
			if(spell) then
				spell:UnregisterAllEvents()
			end

			local altpowerbar = frame.powerBarAlt
			if(altpowerbar) then
				altpowerbar:UnregisterAllEvents()
			end
		else
			frame:SetAlpha(1)
			frame:SetScale(1)
			frame:RegisterEvent("PLAYER_ENTERING_WORLD")
			frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
			frame:RegisterEvent("PARTY_LEADER_CHANGED")
			frame:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
			frame:RegisterEvent("MUTELIST_UPDATE")
			frame:RegisterEvent("IGNORELIST_UPDATE")
			frame:RegisterEvent("UNIT_FACTION")
			frame:RegisterEvent("UNIT_AURA")
			frame:RegisterEvent("UNIT_PET")
			frame:RegisterEvent("VOICE_START")
			frame:RegisterEvent("VOICE_STOP")
			frame:RegisterEvent("VARIABLES_LOADED")
			frame:RegisterEvent("VOICE_STATUS_UPDATE")
			frame:RegisterEvent("READY_CHECK")
			frame:RegisterEvent("READY_CHECK_CONFIRM")
			frame:RegisterEvent("READY_CHECK_FINISHED")
			frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
			frame:RegisterEvent("UNIT_EXITED_VEHICLE")
			frame:RegisterEvent("UNIT_CONNECTION")
			frame:RegisterEvent("PARTY_MEMBER_ENABLE")
			frame:RegisterEvent("PARTY_MEMBER_DISABLE")
			frame:RegisterEvent("UNIT_PHASE")
			frame:SetScript("OnEvent", PartyMemberFrame_OnEvent)
			frame:SetScript("OnUpdate", PartyMemberFrame_OnUpdate)
			RegisterStateDriver(frame, "visibility", "[nogroup] hide; [group:raid] hide; [@party"..i..",exists] show; hide")
		end
	end ]]
end

function ns:UpdateBlizzardCompactRaidFrameManager()
	 --(GetDisplayedAllyFrames() == "party" and ns.db.hideblzparty) 
	if not GetDisplayedAllyFrames() or (GetDisplayedAllyFrames() == "raid" and ns.db.hideblzraid) then
		if CompactRaidFrameManager:IsShown() then
			CompactRaidFrameManager:UnregisterAllEvents()
			--CompactRaidFrameManager:Hide()
			CompactRaidFrameManager:Kill()
		end
	end
		--[[ if not CompactRaidFrameManager:IsEventRegistered("PARTY_MEMBERS_CHANGED") then
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
		end
		if not CompactRaidFrameManager:IsShown() then
			CompactRaidFrameManager:Show()
		end
		CompactRaidFrameManager_UpdateOptionsFlowContainer(CompactRaidFrameManager)
	end ]]
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

function ns:RestorePosition(Default)
	local _DB = ns.db.Freebgridomf2Char or {}
	local name = Default and "Defaults" or "Freebgrid"
	for _, anchor in next, anchorpool do
        local style, identifier = name, anchor:GetName()
		if(_DB[style] and _DB[style][identifier]) then 
			local scale = anchor:GetScale()
			local point, parentName, x, y = string.split('\031', _DB[style][identifier])
			anchor:ClearAllPoints()
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

local function setframe(frame)
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

	local raidframe = CreateFrame("Frame", "FreebgridRaidFrame", UIParent)
	setframe(raidframe)
	raidframe.ident = "Raid"
	raidframe.name:SetText("Raid")
	raidframe:SetPoint("LEFT", UIParent, "LEFT", 8, 0)
	anchorpool["FreebgridRaidFrame"] = raidframe

	local petframe = CreateFrame("Frame", "FreebgridPetFrame", UIParent)
	setframe(petframe)
	petframe.ident = "Pet"
	petframe.name:SetText("Pet")
	petframe:SetPoint("LEFT", UIParent, "LEFT", 250, 0)
	anchorpool["FreebgridPetFrame"] = petframe

	local mtframe = CreateFrame("Frame", "FreebgridMTFrame", UIParent)
	setframe(mtframe)
	mtframe.ident = "MT"
	mtframe.name:SetText("MT")
	mtframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 8, -60)
	anchorpool["FreebgridMTFrame"] = mtframe

	ns:RestorePosition()
end

local function Smooth(self, value)

	if value == self:GetValue() then
        self.smoothing = nil
    else
        self.smoothing = value
    end
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

local function unitFrameStyleSetup(button)
	button:SetFrameLevel(4)
	button.menu = menu

    local bg = CreateFrame("Frame", nil, button)
    bg:SetPoint("TOPLEFT", button, "TOPLEFT")
    bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
    bg:SetFrameLevel(3)
	button.BG = bg
    local Border = CreateFrame("Frame", nil, button)
    Border:SetPoint("TOPLEFT", button, "TOPLEFT")
    Border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
    Border:SetFrameLevel(4)
	S.CreateBD(Border, 0)
	button.Border = Border

    local Health = CreateFrame"StatusBar"
    Health:SetParent(button)
	Health:SetFrameLevel(1)
	Health.bd = CreateFrame("Frame", nil, Health)
	Health.bd:SetFrameLevel(2)
    Health.bg = Health.bd:CreateTexture(nil, "BACKGROUND")
    Health.bg:SetAllPoints(Health.bd)
	button.HealthBar = Health
	button.HealthBar.bd = Health.bd
	if ns.db.mode then
		S.CreateBack(Health)
	end
	local help = CreateFrame("Frame", nil, button)
	help:SetParent(button)
	help:SetAllPoints(Health)
    help:SetFrameLevel(6)
	button.help = help
	
	local help2 = CreateFrame("Frame", nil, button)
	help2:SetParent(button)
	help2:SetAllPoints(Health)
    help2:SetFrameLevel(5)
	button.help2 = help2
	
	local help3 = CreateFrame("Frame", nil, button)
	help3:SetParent(button)
	help3:SetAllPoints(Health)
    help3:SetFrameLevel(4)
	button.help3 = help3
	
	local help4 = CreateFrame("Frame", nil, button)
	help4:SetParent(button)
	help4:SetAllPoints(Health)
    help4:SetFrameLevel(3)
	button.help4 = help4
	
    local name = help3:CreateFontString(nil, "OVERLAY")
    name:SetPoint("CENTER")
    name:SetJustifyH("CENTER")
    name:SetFont(ns.db.fontPath, ns.db.fontsize, ns.db.outline)
    name:SetShadowOffset(ns.db.shadowoffset, -ns.db.shadowoffset)
    name:SetWidth(ns.db.width)
    button.Name = name
	
	local StatusText = help3:CreateFontString(nil, "OVERLAY")
    StatusText:SetPoint("TOP", button.Name, "BOTTOM", 0, -2)
    StatusText:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
	StatusText:SetShadowOffset(ns.db.shadowoffset, -ns.db.shadowoffset)
    StatusText:SetWidth(ns.db.width)
	button.StatusText = StatusText

    local Power = CreateFrame"StatusBar"
    Power:SetParent(button)
	Power:SetFrameLevel(1)
    Power.bg = Power:CreateTexture(nil, "BORDER")
    Power.bg:SetAllPoints(Power)
	button.PowerBar = Power
	
	local frame = CreateFrame("Frame")
	frame:SetAllPoints(button)
	frame:SetFrameStrata("HIGH")
	frame.arrow = frame:CreateTexture(nil, "OVERLAY")
	frame.arrow:SetTexture([[Interface\Addons\SunUI_Freebgrid\Media\Arrow]])
	frame.arrow:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	frame.arrow:SetSize(16, 16)
	frame:Hide()
	button.Freebarrow = frame
		
    local threat = CreateFrame("Frame", nil, button)
    threat:SetPoint("TOPLEFT", button, "TOPLEFT", -5, 5)
    threat:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 5, -5)
    threat:SetFrameLevel(0)
	--threat:CreateShadow()
    threat:SetBackdrop(glowBorder)
    threat:SetBackdropColor(0, 0, 0, 0)
    threat:SetBackdropBorderColor(0, 0, 0, 1)
    --button.ThreatBorder = threat.shadow
	button.ThreatBorder = threat
    local hl = help:CreateTexture(nil, "OVERLAY")
    hl:SetAllPoints(button)
    hl:SetTexture([=[Interface\AddOns\SunUI_Freebgrid\media\white.tga]=])
    hl:SetVertexColor(1, 1, 1, .1)
    hl:SetBlendMode("ADD")
    hl:Hide()
    button.Highlight = hl

    local Gcd = CreateFrame("StatusBar", nil, button)
    Gcd:SetAllPoints(button)
    Gcd:SetStatusBarTexture([=[Interface\AddOns\SunUI_Freebgrid\media\white.tga]=])
    Gcd:SetStatusBarColor(.4, .5, .4, .6)
	Gcd:SetMinMaxValues(0, 1)
    Gcd:SetValue(0)
    Gcd:SetFrameLevel(5)
    Gcd:SetOrientation(ns.db.porientation)
    Gcd:Hide()
    button.Gcd = Gcd	

    local fBorder = CreateFrame("Frame", nil, button)
    fBorder:Point("TOPLEFT", button, "TOPLEFT",-1, 1)
    fBorder:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    fBorder:SetBackdrop(border)
    fBorder:SetBackdropColor(0, 0, 0, 0)
    fBorder:SetFrameLevel(1)
    fBorder:Hide()
    button.FocusHighlight = fBorder

	local dispelicon = help:CreateTexture(nil, 'OVERLAY')
    dispelicon:SetPoint("RIGHT", button, -3, 0)
    dispelicon:SetSize(ns.db.dispeliconsize, ns.db.dispeliconsize)
    button.DispelIcon = dispelicon
	
    local ricon = help:CreateTexture(nil, 'OVERLAY')
    ricon:SetPoint("TOPRIGHT", button, -15, 6)
    ricon:SetSize(ns.db.leadersize + 2, ns.db.leadersize + 2)
	ricon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
    button.RaidIcon = ricon

    local Leader = help:CreateTexture(nil, "OVERLAY")
    Leader:SetPoint("TOPLEFT", button, 0, 8)
    Leader:SetSize(ns.db.leadersize, ns.db.leadersize )
	Leader:SetTexture([[Interface\GroupFrame\UI-Group-LeaderIcon]])
	button.LeaderIcon = Leader

    local Assistant = help:CreateTexture(nil, "OVERLAY")
    Assistant:SetPoint("TOPLEFT", button, 0, 8)
    Assistant:SetSize(ns.db.leadersize, ns.db.leadersize)
	Assistant:SetTexture([[Interface\GroupFrame\UI-Group-AssistantIcon]])
	button.AssistantIcon = Assistant

    local masterlooter = help:CreateTexture(nil, 'OVERLAY')
    masterlooter:SetSize(ns.db.leadersize, ns.db.leadersize)
    masterlooter:SetPoint('LEFT', button.LeaderIcon, 'RIGHT')
	masterlooter:SetTexture([[Interface\GroupFrame\UI-Group-MasterLooter]])
    button.MasterLooterIcon = masterlooter

	local roleicon = help:CreateTexture(nil, 'OVERLAY')
	roleicon:SetSize(ns.db.leadersize + 2, ns.db.leadersize + 2)
	roleicon:SetPoint('RIGHT', button, 'LEFT', ns.db.leadersize, 0)
	button.RoleIcon = roleicon

	local ResurrectIcon = help:CreateTexture(nil, 'OVERLAY')
    ResurrectIcon:SetPoint("TOP", button, 0, -2)
    ResurrectIcon:SetSize(ns.db.leadersize + 6, ns.db.leadersize + 6)
	ResurrectIcon:SetTexture([[Interface\RaidFrame\Raid-Icon-Rez]])
	button.ResurrectIcon = ResurrectIcon

    local ReadyCheck = help:CreateTexture(nil, "OVERLAY")
    ReadyCheck:SetPoint("TOP", button)
    ReadyCheck:SetSize(ns.db.leadersize + 4, ns.db.leadersize + 4)
	button.readyCheckIcon = ReadyCheck

	button.Auras = {}
    local auras = CreateFrame("Frame", nil, button)
	auras:SetFrameLevel(7)
    auras:SetSize(ns.db.aurasize, ns.db.aurasize)
    auras:SetPoint("CENTER", button.HealthBar)
    auras.size = ns.db.aurasize
    button.Auras.first = auras
	button.Auras.first.Button = ns:CreateAuraIcon(button.Auras.first)
	
	local secauras = CreateFrame("Frame", nil, button)
	secauras:SetFrameLevel(7)
    secauras:SetSize(ns.db.secaurasize, ns.db.secaurasize)
    secauras:SetPoint("LEFT", button.HealthBar)
    secauras.size = ns.db.secaurasize
    button.Auras.second = secauras
	button.Auras.second.Button = ns:CreateAuraIcon(button.Auras.second)
	
	ns:UpdatePowerBar(button)
	ns:UpdateHealthBarLayout(button)
	ns:UpdateHealPredictionBarLayout(button)
	ns:CreateIndicators(button)
	
	button:SetScript("OnAttributeChanged", OnAttributeChanged)
	button:RegisterForClicks("AnyDown")
	button:SetScript("OnShow", Freebgrid_OnShow)
	button:SetScript("OnHide", Freebgrid_OnHide)
	button:SetScript("OnEnter", Freebgrid_OnEnter)
    button:SetScript("OnLeave", Freebgrid_OnLeave)
	button:SetScript("OnEvent", Freebgrid_OnEvent)
	button:SetScript("OnUpdate", Freebgrid_OnUpdate)
	
	if ns.db.smooth then
		button.HealthBar.SetValue_ = button.HealthBar.SetValue
		button.HealthBar.SetValue = Smooth
	end
	
	if type(ns.db.ClickCast) == "table" and type(ns.RegisterClicks) == "function" then
		ns:RegisterClicks(button)
	end
	
    button:SetScale(ns.db.scale)
end

local function defaultUnitFrameSetup(header, name)
	if not name then return end
	local button = getglobal(name)
	
	if not button.hasStyleSetup then
		unitFrameStyleSetup(button)
		button.hasStyleSetup = true
	end

    table.insert(ns._Objects, button)
end

local function getPointAnchor(htype)
	local horiz, grow, spacing = ns.db.horizontal, ns.db.growth, ns.db.spacing 
	if htype == "Pet" then
		horiz, grow = ns.db.pethorizontal, ns.db.petgrowth
	elseif htype == "MT" then
		horiz, grow = ns.db.MThorizontal, ns.db.MTgrowth		
	end

    if horiz then	
        point = "LEFT"
        xoff = spacing
        yoff = 0

    else
        point = "TOP"
        xoff = 0
        yoff = -spacing
    end
	if grow == "UP" then
		growth = "BOTTOM"
		pos = "BOTTOMLEFT"
		posRel = "TOPLEFT"
		colY = spacing
		colX = 0
	elseif grow == "DOWN" then
		growth = "TOP"
		pos = "TOPLEFT"
		posRel = "BOTTOMLEFT"
		colY = -spacing
		colX = 0
	elseif grow == "LEFT" then
		growth = "RIGHT"		
		pos = "TOPRIGHT"
		posRel = "TOPLEFT"
		colX = -spacing
		colY = 0
	elseif grow == "RIGHT" then
		if htype ~= "GROUP" then
			growth = "LEFT"
		else
			growth = "BOTTOM"
		end
		pos = "TOPLEFT"
		posRel = "TOPRIGHT"
		colX = spacing
		colY = 0
	end
	return pos, posRel, colX, colY, point, growth, xoff, yoff
end

local initconfig = [[
	self:SetWidth(%d)
    self:SetHeight(%d)
	
	local header = self:GetParent()

	self:SetAttribute("*type1", "target")
	self:SetAttribute("*type2", "menu")
	self:SetAttribute("toggleForVehicle", true)

	header:CallMethod("styleFunction", self:GetName())
	
	local clique = header:GetFrameRef("clickcast_header")
	if(clique) then
		clique:SetAttribute("clickcast_button", self)
		clique:RunAttribute("clickcast_register")
	end
]]
local function setAttributes(header, htype, index, firstTime)
	local pos, posRel, colX, colY, point, growth, xoff, yoff = getPointAnchor(htype)
	local groupFilter = "1,2,3,4,5,6,7,8"
	local maxColumns = 8

	if htype == "GROUP" then
		if index and tonumber(index) <= ns.db.numCol then
			groupFilter = tonumber(index)
		else
			groupFilter =  0
		end
		maxColumns = 1
	elseif htype == "MT" then
		groupFilter = "MAINTANK"
	end
		
	header:SetAttribute("_ignore", "attributeChanges")
	header:SetAttribute("initialConfigFunction", initconfig:format(ns.db.width, ns.db.height))
	header:SetAttribute("showParty", ns.db.party)
	header:SetAttribute("showRaid", true)
	header:SetAttribute("showPlayer", ns.db.player)
	header:SetAttribute("showSolo", ns.db.solo)
	header:SetAttribute("groupingOrder", "1,2,3,4,5,6,7,8")
	header:SetAttribute("groupBy", "GROUP")
	header:SetAttribute("groupFilter", groupFilter)
	header:SetAttribute("maxColumns", maxColumns)
	header:SetAttribute("unitsPerColumn", 5)
	header:SetAttribute("xOffset", xoff)
	header:SetAttribute("yOffset", yoff)
	header:SetAttribute("point", point)
	header:SetAttribute("columnAnchorPoint", growth)
	header:SetAttribute("_ignore", nil)
	
	if not firstTime then  	
		for n = 1, #header do
			header[n]:ClearAllPoints()
		end
	end

	header:SetAttribute("columnSpacing", ns.db.spacing)
	
end

function ns:UpdateAttribute(header, htype, att, val, index, firstTime)

	if att then 
		for _, header in pairs(ns._Headers) do
			header:SetAttribute(att, val)
		end
	else		
		if not htype or htype == "GROUP" then
			setAttributes(header, "GROUP", index, firstTime)
		end
		if not htype or htype == "Pet" then
			setAttributes(header, "Pet", nil, firstTime)
		end
		if not htype or htype == "MT" then
			setAttributes(header, "MT", nil, firstTime)
		end
	end
end

function ns:CreateRaidGroupHeader(index, htype, template)
	local name, groupFilter, maxColumns
	if htype == "Pet" then
		name = "Pet_Freebgrid"
	elseif htype == "MT" then
		name = "MT_Freebgrid"
	elseif index then
		name = "Raid_Freebgrid"..index
	end
	if getglobal(name) then return end

	local header = CreateFrame("Frame", name, UIParent, template)

	header.styleFunction = defaultUnitFrameSetup

	header:SetAttribute("template", "SecureUnitButtonTemplate")
	header:SetAttribute("templateType", "Button")

	ns:UpdateAttribute(header, htype, nil, nil, index, true)

	if Clique and not ns.db.ClickCast.enable then
		SecureHandlerSetFrameRef(header, 'clickcast_header', Clique.header)
	end	
	header:Show()
	
	return header
end

function ns:CreateRaidFrame()
	local lastheader, header
	local pos, posRel, colX, colY = getPointAnchor()

	for i = 1, 8 do
		header = self:CreateRaidGroupHeader(i, "GROUP", "SecureGroupHeaderTemplate")
		header:ClearAllPoints()
		if i == 1 then
			header:SetPoint(pos, "FreebgridRaidFrame", pos)
		else
			header:SetPoint(pos, lastheader, posRel, colX , colY )
		end
		lastheader = header
		ns._Headers[header:GetName()] = header
	end
end

function ns:CreatePetFrame()
	local pos = getPointAnchor("Pet")
	local header = self:CreateRaidGroupHeader(nil, "Pet", "SecureGroupPetHeaderTemplate")
	header:ClearAllPoints()
	header:SetPoint(pos, "FreebgridPetFrame", pos)
	ns._Headers["Pet_Freebgrid"] = header
end

function ns:CreateMTFrame()
	local pos = getPointAnchor("MT")
	local header = self:CreateRaidGroupHeader(nil, "MT", "SecureGroupHeaderTemplate")
	header:ClearAllPoints()
	header:SetPoint(pos, "FreebgridMTFrame", pos)
	ns._Headers["MT_Freebgrid"] = header
end

function ns:UpdateHeadersLayout()
	local pos, posRel, colX, colY = getPointAnchor()
	local lastheader, header
	for i = 1, 8 do
		header = ns._Headers["Raid_Freebgrid"..i]

		header:ClearAllPoints()
		if i == 1 then
			header:SetPoint(pos, "FreebgridRaidFrame", pos)
		else
			header:SetPoint(pos, lastheader, posRel, colX , colY )
		end
		lastheader = header
		
		setAttributes(header, "GROUP", i)	
	end

	local pos, posRel, colX, colY = getPointAnchor("Pet")
	header = ns._Headers["Pet_Freebgrid"]	
	header:ClearAllPoints()
	header:SetPoint(pos, "FreebgridPetFrame", pos)
	setAttributes(header, "Pet")

	local pos, posRel, colX, colY = getPointAnchor("MT")
	header = ns._Headers["MT_Freebgrid"]
	header:ClearAllPoints()
	header:SetPoint(pos, "FreebgridMTFrame", pos)
	setAttributes(header, "MT")

	collectgarbage("collect")
end

function ns:UpdateHeadersDisplayStatus()
	local header
	for i = 1, 8 do
		header = ns._Headers["Raid_Freebgrid"..i]
		header:SetAttribute("groupFilter", i <= ns.db.numCol and i or 0)
	end
	
	header = ns._Headers["Pet_Freebgrid"]
	if ns.db.pets then
		header:Show()
	else
		header:Hide()
	end
	
	header = ns._Headers["MT_Freebgrid"]
	if ns.db.MT then
		header:Show()
	else
		header:Hide()
	end	
end

local lockprint
local updateFuncList = {}

function ns:CheckCombat(func)
	if(InCombatLockdown()) then
		if not updateFuncList.func then
			table.insert(updateFuncList, func)
		end
		if not lockprint then
			lockprint = true
			print(ADDON_NAME..": "..L.incombatlock)
		end		
		return true
	end
	return false
end

function ns:UpdateRoleIcon(self)
	if not ns.db.roleicon then return end
	
	local unit = self.displayedUnit or self.unit
	if self.inVehicle then
		self.RoleIcon:SetTexture("Interface\\Vehicles\\UI-Vehicles-Raid-Icon")
		self.RoleIcon:SetTexCoord(0, 1, 0, 1)
		self.RoleIcon:Show()
		return
	else
		self.RoleIcon:SetTexture("Interface\\Addons\\SunUI_Freebgrid\\media\\lfd_role")
		local role = UnitGroupRolesAssigned(unit)
		if(role == 'TANK' or role == 'HEALER' or role == 'DAMAGER') then
			self.RoleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
			self.RoleIcon:Show()
		else
			self.RoleIcon:Hide()
		end
		return
	end
	self.RoleIcon:Hide()
end

local GetRaidTargetIndex = GetRaidTargetIndex
local SetRaidTargetIconTexture = SetRaidTargetIconTexture
function ns:UpdateRaidIcon(self)
	if not self.RaidIcon then return end
	
	local index = GetRaidTargetIndex(self.unit)	
	if(index) then
		SetRaidTargetIconTexture(self.RaidIcon, index)
		self.RaidIcon:Show()
	else
		self.RaidIcon:Hide()
	end
end

function ns:UpdateLeaderAndAssistantIcon(self)
	local assistant = self.AssistantIcon
	local leader = self.LeaderIcon
	if not assistant or not leader then return end
	local unit = self.displayedUnit or self.unit

	if UnitInRaid(unit) and UnitIsGroupAssistant(unit) and not UnitIsGroupLeader(unit) then
		leader:Hide()
		assistant:Show()
		return
	elseif (UnitInParty(unit) or UnitInRaid(unit)) and UnitIsGroupLeader(unit) then
		assistant:Hide()
		leader:Show()
		return
	end
	leader:Hide()
	assistant:Hide()
end

function ns:UpdateMasterlooterIcon(self)
	local masterlooter = self.MasterLooterIcon
	if not masterlooter then return end
	
	local unit = self.displayedUnit or self.unit
	if(not (UnitInParty(unit) or UnitInRaid(unit))) then
		return masterlooter:Hide()
	end

	local method, pid, rid = GetLootMethod()	
	if(method == 'master') then
		local mlUnit
		if(pid) then
			if(pid == 0) then
				mlUnit = 'player'
			else
				mlUnit = 'party'..pid
			end
		elseif(rid) then
			mlUnit = 'raid'..rid
		end
		if(UnitIsUnit(unit, mlUnit)) then
			masterlooter:Show()
		elseif(masterlooter:IsShown()) then
			masterlooter:Hide()
		end
	else
		masterlooter:Hide()
	end
end

function ns:UpdateSelectionHighlight(self)
	if ns.db.fborder then 
		if UnitIsUnit('focus', self.displayedUnit) then
			self.FocusHighlight:Show()
			self.FocusHighlight:SetBackdropColor(.6, .8, .0, 1)
			return
		elseif UnitIsUnit('target', self.displayedUnit) then
			self.FocusHighlight:Show()
			self.FocusHighlight:SetBackdropColor(.8, .8, .8, 1)	
			return
		end       
    end
	self.FocusHighlight:Hide()
end

function ns:UpdateThreatBorder(self)
	--if not ns.db.ThreatBorder then self.ThreatBorder:Hide() return end
	local unit = self.displayedUnit or self.unit

	local status = UnitThreatSituation(unit)
	if(status and status > 0) then
        local r, g, b = GetThreatStatusColor(status)
        self.ThreatBorder:SetBackdropBorderColor(r, g, b, 1)
    else
		if (ns.db.lowmana and UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit)) then
			local _, ptype = UnitPowerType(unit)
			if ptype == 'MANA' and math.floor(UnitPower(unit)/UnitPowerMax(unit)*100+.5) < ns.db.manapercent then		
				self.ThreatBorder:SetBackdropBorderColor(0, 0, 1, 1)						
				return
			end
		end
		
		self.ThreatBorder:SetBackdropBorderColor(0, 0, 0, .5)
    end
end

function ns:UpdateResurrectIcon(self)
	local resurrect = self.ResurrectIcon
	local unit = self.displayedUnit or self.unit
	if not UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then resurrect:Hide() return end
	
	local incomingResurrect = UnitHasIncomingResurrection(unit)
	
	if incomingResurrect then
		resurrect:Show()
	else
		resurrect:Hide()
	end
end

function ns:UpdateName(self)
	local unit = self.displayedUnit or self.unit
	if not unit then return end
	local name = UnitName(unit)
    if not name then return end
	
	local class = select(2, UnitClass(unit))
	local substring
	for length = #name, 1, -1 do
		substring = utf8sub(name, 1, length)
		self.Name:SetText(substring)
		if self.Name:GetStringWidth() <= ns.db.width - 14 then 
			break 
		end
	end

	if not ns.db.reversecolors and type(ns.RaidClassColors[class]) == "table" then
		self.Name:SetTextColor(ns.RaidClassColors[class].r, ns.RaidClassColors[class].g, ns.RaidClassColors[class].b)
	else
		if ns.db.mode and type(RAID_CLASS_COLORS[class]) == "table" then
			self.Name:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g , RAID_CLASS_COLORS[class].b)
		else
			self.Name:SetTextColor(1, 1, 1)
		end
	end
end

function ns:UpdateReadyCheck(self)
	if ( self.readyCheckDecay and GetReadyCheckTimeLeft() <= 0 ) then
		return
	end
	
	local readyCheckStatus = GetReadyCheckStatus(self.displayedUnit)
	self.readyCheckStatus = readyCheckStatus
	if ( readyCheckStatus == "ready" ) then
		self.readyCheckIcon:SetTexture(READY_CHECK_READY_TEXTURE)
		self.readyCheckIcon:Show()
	elseif ( readyCheckStatus == "notready" ) then
		self.readyCheckIcon:SetTexture(READY_CHECK_NOT_READY_TEXTURE)
		self.readyCheckIcon:Show()
	elseif ( readyCheckStatus == "waiting" ) then
		self.readyCheckIcon:SetTexture(READY_CHECK_WAITING_TEXTURE)
		self.readyCheckIcon:Show()
	else
		self.readyCheckIcon:Hide()
	end
end

function ns:FinishReadyCheck(self)
	if ( self:IsVisible() ) then
		self.readyCheckDecay = CUF_READY_CHECK_DECAY_TIME;
		
		if ( self.readyCheckStatus == "waiting" ) then
			self.readyCheckIcon:SetTexture(READY_CHECK_NOT_READY_TEXTURE)
			self.readyCheckIcon:Show()
		end
	else
		ns:UpdateReadyCheck(self)
	end
end

function ns:CheckReadyCheckDecay(self, elapsed)
	
	if ( self.readyCheckDecay ) then
		if ( self.readyCheckDecay > 0 ) then
			self.readyCheckDecay = self.readyCheckDecay - elapsed
		else
			self.readyCheckDecay = nil
			ns:UpdateReadyCheck(self)
		end
	end
end

function ns:UpdateHealthBarLayout(self)   --样式
	local healthBar = self.HealthBar
	local power = self.PowerBar
    local h = self.help4
    healthBar:SetOrientation(ns.db.orientation)
	healthBar:SetStatusBarTexture(ns.db.texturePath)
	if ns.db.mode then
		healthBar:SetStatusBarColor(0,0,0,0)
		healthBar.bg:SetTexture(ns.db.texturePath)
		healthBar.bd:SetAlpha(1)
		--S.CreateMark(healthBar)
		--S.CreateTop(healthBar.bg, DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b) --职业颜色背景
		--S.CreateTop(healthBar.bg, 228/255, 38/255, 141/255)  --紫色背景
	else
		healthBar.bg:SetTexture(ns.db.texturePath)
	end	
	
    if not ns.db.powerbar or not power:IsShown() then		
        healthBar:SetHeight(ns.db.height)
        healthBar:SetWidth(ns.db.width)
	else
		healthBar:SetWidth((0.98 - ns.db.powerbarsize)*ns.db.width)
		healthBar:SetHeight((0.98 - ns.db.powerbarsize)*ns.db.height)
    end
	
    healthBar:ClearAllPoints()
	healthBar:Point("TOP", 0, -1)
    if ns.db.orientation == "VERTICAL" and ns.db.porientation == "VERTICAL" then
		healthBar:Point("LEFT", 1, 0)
		healthBar:Point("BOTTOM", 0, 1)
    elseif ns.db.orientation == "HORIZONTAL" and ns.db.porientation == "VERTICAL" then
		healthBar:Point("RIGHT", -1, 0)
		healthBar:Point("BOTTOM", 0, 1)
    else
		healthBar:Point("LEFT", 1, 0)
		healthBar:Point("RIGHT", -1, 0)
    end
end

function ns:UpdateHealthColor(self)
	local healthBar = self.HealthBar
	local unit = self.displayedUnit or self.unit
	local healthBartexture = healthBar:GetStatusBarTexture()
	if not unit then return end 
			
	--if UnitIsFriend("player",unit) then
	if	not UnitCanAttack("player", unit) then
		local r, g, b
		local _, class = UnitClass(unit)
		--local healthBartexture = healthBar:GetStatusBarTexture()
		if type(ns.RaidClassColors[class]) == "table" and not string.match(unit, "pet") then
			r, g, b  = ns.RaidClassColors[class].r, ns.RaidClassColors[class].g, ns.RaidClassColors[class].b
		else
			r, g, b  = 0.2, 0.9, 0.1
		end
		if ns.db.mode then
			healthBar:SetStatusBarColor(0,0,0,0)
			S.CreateTop(healthBar.bg, DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
		end
		if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
			if ns.db.definecolors then
				if ns.db.mode then
					S.CreateTop(healthBar.bg, ns.db.deadcolor.r, ns.db.deadcolor.g, ns.db.deadcolor.b)
				else
					S.CreateTop(healthBartexture, ns.db.deadcolor.r, ns.db.deadcolor.g, ns.db.deadcolor.b)
					S.CreateTop(healthBar.bg, ns.db.deadcolor.r*.2, ns.db.deadcolor.g*.2, ns.db.deadcolor.b*.2, 1)
				end
			else
				if ns.db.mode then
					S.CreateTop(healthBar.bg, r, g, b)
				else
					S.CreateTop(healthBartexture, ns.db.deadcolor.r, ns.db.deadcolor.g, ns.db.deadcolor.b)
					S.CreateTop(healthBar.bg, ns.db.deadcolor.r*.2, ns.db.deadcolor.g*.2, ns.db.deadcolor.b*.2,.6)
				end
			end
			--S.CreateTop(healthBartexture, ns.db.deadcolor.r, ns.db.deadcolor.g, ns.db.deadcolor.b)
			return
		end

		if  self.inVehicle then
			if ns.db.mode then
				healthBar.bg:SetVertexColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b, 0)
				healthBar:SetStatusBarColor(ns.db.vehiclecolor.r, ns.db.vehiclecolor.g, ns.db.vehiclecolor.b,1)
				S.CreateTop(healthBartexture, ns.db.vehiclecolor.r, ns.db.vehiclecolor.g, ns.db.vehiclecolor.b)
			else
				S.CreateTop(healthBar.bg, ns.db.vehiclecolor.r*.2, ns.db.vehiclecolor.g*.2, ns.db.vehiclecolor.b*.2)
				S.CreateTop(healthBartexture, ns.db.vehiclecolor.r, ns.db.vehiclecolor.g, ns.db.vehiclecolor.b)
			end
			return
		elseif ns.db.definecolors then
			if ns.db.classbgcolor then
				S.CreateTop(healthBar.bg, r, g, b)
			else
				if ns.db.mode then
					S.CreateTop(healthBar.bg, ns.db.hpcolor.r, ns.db.hpcolor.g, ns.db.hpcolor.b)
				else
					S.CreateTop(healthBartexture, ns.db.hpcolor.r, ns.db.hpcolor.g, ns.db.hpcolor.b)
					S.CreateTop(healthBar.bg, ns.db.hpbgcolor.r, ns.db.hpbgcolor.g, ns.db.hpbgcolor.b)
				end
			end			
			return 
		elseif ns.db.reversecolors  then
			if ns.db.mode then 
				S.CreateTop(healthBar.bg, r, g, b)
			else
				S.CreateTop(healthBar.bg, r*.2, g*.2, b*.2)
				S.CreateTop(healthBartexture, r, g, b)
			end
		else
			if ns.db.mode then
				S.CreateTop(healthBar.bg, DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
			else
				S.CreateTop(healthBar.bg, r, g, b)
			end
			--S.CreateTop(healthBartexture, 0, 0, 0)
		end		
	else
		if ns.db.mode then
			healthBar.bg:SetVertexColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b, 0)
			healthBar:SetStatusBarColor(ns.db.enemycolor.r, ns.db.enemycolor.g, ns.db.enemycolor.b,1)	
			S.CreateTop(healthBartexture, ns.db.enemycolor.r, ns.db.enemycolor.g, ns.db.enemycolor.b)
		else
			S.CreateTop(healthBartexture, ns.db.enemycolor.r, ns.db.enemycolor.g, ns.db.enemycolor.b)
		end
	end
end

function ns:UpdateMaxHealth(self)
	local healthBar = self.HealthBar
	local unit = self.displayedUnit or self.unit

	healthBar:SetMinMaxValues(0, UnitHealthMax(unit))
end

local min, max, abs = math.min, math.max, abs
function ns:UpdateHealthSmooth(self)
	if not ns.db.smooth or not self.HealthBar.smoothing then return end

	local val = self.HealthBar.smoothing
	local limit = 30/GetFramerate()
    local cur = self.HealthBar:GetValue()
    local new = cur + min((val-cur)/3, max(val-cur, limit))

    if new ~= new then
        new = val
    end

    self.HealthBar:SetValue_(new)
    if cur == val or abs(new - val) < 2 then
        self.HealthBar:SetValue_(val)
        self.HealthBar.smoothing = nil
    end
end

function ns:UpdateHealth(self)
	local healthBar = self.HealthBar
	local unit = self.displayedUnit or self.unit
	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		self.HealthBar:SetValue(0)
	else
		self.HealthBar:SetValue(UnitHealth(unit))
	end
	healthBar.bd:SetPoint("TOPRIGHT", healthBar)
	healthBar.bd:SetPoint("BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
end

function ns:UpdateHealPredictionBarColor(self)
	S.CreateTop(self.myHealPredictionBar:GetStatusBarTexture(), ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b)
	S.CreateTop(self.otherHealPredictionBar:GetStatusBarTexture(), ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b)
end

function ns:UpdateHealPredictionBarLayout(self)
	local healthBar = self.HealthBar
	self.myHealPredictionBar = CreateFrame('StatusBar', nil, healthBar)
	self.myHealPredictionBar:SetFrameLevel(3)
	self.myHealPredictionBar:SetStatusBarTexture(DB.Statusbar)
	if ns.db.orientation == "VERTICAL" then
		self.myHealPredictionBar:SetPoint("BOTTOMLEFT", healthBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		self.myHealPredictionBar:SetPoint("BOTTOMRIGHT", healthBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		self.myHealPredictionBar:SetHeight(ns.db.height)
		self.myHealPredictionBar:SetOrientation"VERTICAL"
	else
		self.myHealPredictionBar:SetPoint("TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		self.myHealPredictionBar:SetPoint("BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		self.myHealPredictionBar:SetWidth(ns.db.width)
		--S.CreateMark(self.myHealPredictionBar)
	end
	
	self.myHealPredictionBar:Hide()

	self.otherHealPredictionBar = CreateFrame('StatusBar', nil, healthBar)
	self.otherHealPredictionBar:SetStatusBarTexture(DB.Statusbar)
	self.otherHealPredictionBar:SetFrameLevel(3)
	if ns.db.orientation == "VERTICAL" then
		self.otherHealPredictionBar:SetPoint("BOTTOMLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		self.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		self.otherHealPredictionBar:SetHeight(ns.db.height)
		self.otherHealPredictionBar:SetOrientation"VERTICAL"
	else
		self.otherHealPredictionBar:SetPoint("TOPLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		self.otherHealPredictionBar:SetPoint("BOTTOMLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		self.otherHealPredictionBar:SetWidth(ns.db.width)
		--S.CreateMark(self.otherHealPredictionBar)
	end
	self.otherHealPredictionBar:Hide() 
	
	ns:UpdateHealPredictionBarColor(self)
end

function ns:UpdateHealPrediction(self)
	local unit = self.displayedUnit or self.unit
	local overflow = ns.db.healoverflow and 1.20 or 1
    local myIncomingHeal = UnitGetIncomingHeals(unit, "player") or 0
    local allIncomingHeal = UnitGetIncomingHeals(unit) or 0
	local healthBar = self.HealthBar
    local health = self.HealthBar:GetValue()
    local maxHealth = UnitHealthMax(unit)
	
	if ns.db.orientation == "VERTICAL" then
		self.myHealPredictionBar:SetPoint("BOTTOMLEFT", healthBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		self.myHealPredictionBar:SetPoint("BOTTOMRIGHT", healthBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		self.myHealPredictionBar:SetHeight(ns.db.height)
		self.myHealPredictionBar:SetOrientation"VERTICAL"
	else
		self.myHealPredictionBar:SetPoint("TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		self.myHealPredictionBar:SetPoint("BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		self.myHealPredictionBar:SetWidth(ns.db.width)
	end	

	if ns.db.orientation == "VERTICAL" then
		self.otherHealPredictionBar:SetPoint("BOTTOMLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		self.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		self.otherHealPredictionBar:SetHeight(ns.db.height)
		self.otherHealPredictionBar:SetOrientation"VERTICAL"
	else
		self.otherHealPredictionBar:SetPoint("TOPLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		self.otherHealPredictionBar:SetPoint("BOTTOMLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		self.otherHealPredictionBar:SetWidth(ns.db.width)
	end
    if ( health + allIncomingHeal > maxHealth * overflow ) then
        allIncomingHeal = maxHealth * overflow - health
    end

    if ( allIncomingHeal < myIncomingHeal ) then
        myIncomingHeal = allIncomingHeal
        allIncomingHeal = 0
    else
        allIncomingHeal = allIncomingHeal - myIncomingHeal
    end

    self.myHealPredictionBar:SetMinMaxValues(0, maxHealth) 
    if ns.db.healothersonly then
        self.myHealPredictionBar:SetValue(0)
    else
        self.myHealPredictionBar:SetValue(myIncomingHeal)
    end
    self.myHealPredictionBar:Show()

    self.otherHealPredictionBar:SetMinMaxValues(0, maxHealth)
    self.otherHealPredictionBar:SetValue(allIncomingHeal)
    self.otherHealPredictionBar:Show()
end

function ns:UpdatePowerBar(self) 
	local power = self.PowerBar
	local health = self.HealthBar  
	local unit = self.displayedUnit or self.unit
	if not unit then return end 
	
	local _, ptype = UnitPowerType(unit)

	if ns.db.powerbar and (not ns.db.onlymana or (ptype == 'MANA' and ns.db.onlymana)) then 
			power:Show()
		if(ns.db.porientation == "VERTICAL")then
			power:SetWidth(ns.db.width * ns.db.powerbarsize)
			power:SetHeight(ns.db.height)
			health:SetWidth((0.98 - ns.db.powerbarsize) * ns.db.width)
			health:SetHeight(ns.db.height)
		else
			power:SetWidth(ns.db.width)
			power:SetHeight(ns.db.height * ns.db.powerbarsize-2)
			health:SetWidth(ns.db.width)
			if ns.db.mode then
				health:SetHeight((0.98 - ns.db.powerbarsize) * ns.db.height)
			else
				health:SetHeight((1 - ns.db.powerbarsize) * ns.db.height)
			end
		end

		power:SetStatusBarTexture(ns.db.texturePath)
		power:SetOrientation(ns.db.porientation)
		
		if ns.db.mode then
			power.bg:SetTexture("")
			S.CreateBack(power)
		else
			power.bg:SetTexture(ns.db.texturePath)
		end
		power:ClearAllPoints()
		if ns.db.orientation == "HORIZONTAL" and ns.db.porientation == "VERTICAL" then
			power:Point("LEFT", 1, 0)
			power:Point("TOP", 0, -1)
			power:Point("BOTTOM", 0, 1)
		elseif ns.db.porientation == "VERTICAL" then
			power:Point("TOP", 0, -1)
			power:Point("RIGHT", -1, 0)
			power:Point("BOTTOM", 0, 1)
		else
			power:Point("LEFT", 1, 0)
			power:Point("RIGHT", -1, 0)
			power:Point("BOTTOM", 0, 1)
		end	
	else
		power:Hide()
		health:SetHeight(ns.db.height-2)
        health:SetWidth(ns.db.width)
	end
end


local function GetUnitPowerID(self)
	local unit = self.displayedUnit or self.unit
	local barType, minPower, startInset, endInset, smooth, hideFromOthers, showOnRaid, opaqueSpark, opaqueFlash, powerName, powerTooltip = UnitAlternatePowerInfo(unit)
	if showOnRaid and (UnitInParty(unit) or UnitInRaid(unit)) then
		return ALTERNATE_POWER_INDEX
	else
		return (UnitPowerType(unit))
	end
end

function ns:UpdatePower(self)
	local power = self.PowerBar
	local powertexture = self.PowerBar:GetStatusBarTexture()
	local unit = self.displayedUnit or self.unit
	if not UnitExists(unit) or not power:IsShown() then return end 
	
	power:SetMinMaxValues(0, UnitPowerMax(unit, GetUnitPowerID(self)))
	power:SetValue(UnitPower(unit, GetUnitPowerID(self)))
	
	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		S.CreateTop(power.bg, ns.db.deadcolor.r, ns.db.deadcolor.g, ns.db.deadcolor.b, .6)
       -- power:SetStatusBarColor(ns.db.deadcolor.r, ns.db.deadcolor.g, ns.db.deadcolor.b, .6)
		S.CreateTop(powertexture, ns.db.deadcolor.r, ns.db.deadcolor.g, ns.db.deadcolor.b)
		return
	end
	
    if ns.db.powerdefinecolors then
        S.CreateTop(power.bg, ns.db.powerbgcolor.r, ns.db.powerbgcolor.g, ns.db.powerbgcolor.b)
        --power:SetStatusBarColor(ns.db.powercolor.r, ns.db.powercolor.g, ns.db.powercolor.b)
		S.CreateTop(powertexture, ns.db.powercolor.r, ns.db.powercolor.g, ns.db.powercolor.b)
        return
    end

	local _, ptype = UnitPowerType(unit)
    local _, class = UnitClass(unit) 
	local r, g, b
	
	if ns.db.powerclass and type(ns.RaidClassColors[class]) == "table" then
		r, g, b  = ns.RaidClassColors[class].r, ns.RaidClassColors[class].g, ns.RaidClassColors[class].b
	elseif type(ns.PowerBarColor[ptype]) == "table" then
		r, g, b  = ns.PowerBarColor[ptype].r, ns.PowerBarColor[ptype].g, ns.PowerBarColor[ptype].b
	else
		r, g, b  = 0, 0, 1
	end

	if ns.db.reversecolors or ns.db.powerclass then
		S.CreateTop(power.bg, r*.2, g*.2, b*.2)
		--power:SetStatusBarColor(r, g, b)
		S.CreateTop(powertexture, r, g, b)
	else
		S.CreateTop(power.bg, r, g, b)
		--power:SetStatusBarColor(0, 0, 0, .8)
		S.CreateTop(powertexture, 0, 0, 0)
	end
end

function ns:UpdateStatusText(self)
	local statusText = self.StatusText
	local unit = self.displayedUnit or self.unit
	local maxHealth =  UnitHealthMax(unit)
	local minHealth =  UnitHealth(unit)
	local perc = math.ceil(100 * (minHealth/maxHealth))
	local text
	
	if not UnitIsConnected(unit) then
		text = L.Offline
	elseif UnitIsDead(unit) then
		text = L.Dead
	elseif UnitIsGhost(unit) then
		text = L.Ghost
	elseif UnitIsAFK(unit) then
		text = L.AFK
	elseif ns.db.hptext == "ACTUAL" then
		if perc < ns.db.hppercent then
			if ns.db.abbnumber then
				text = ns:Numberize(minHealth)
			else
				text = minHealth
			end
		end
	elseif ns.db.hptext == "DEFICIT" then
		if perc < ns.db.hppercent then
			local healthLost = maxHealth - minHealth
			if ( healthLost > 0 ) then
				if ns.db.abbnumber then
					text = "-"..ns:Numberize(healthLost)
				else
					text = "-"..healthLost
				end
			end
		end
	elseif ns.db.hptext == "PERC" then
		if perc < ns.db.hppercent then
			text = perc.."%"
		end		
	end
	if text then
		statusText:SetText(text)
		statusText:Show()
	else
		statusText:SetText(nil)
		statusText:Hide()
	end
end

local function ColorGradient(perc, ...)
    local num = select("#", ...)
    local hexes = type(select(1, ...)) == "string"

    if perc == 1 then
        return select(num-2, ...), select(num-1, ...), select(num, ...)
    end

    num = num / 3

    local segment, relperc = math.modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2
    r1, g1, b1 = select((segment*3)+1, ...), select((segment*3)+2, ...), select((segment*3)+3, ...)
    r2, g2, b2 = select((segment*3)+4, ...), select((segment*3)+5, ...), select((segment*3)+6, ...)

    if not r2 or not g2 or not b2 then
        return r1, g1, b1
    else
        return r1 + (r2-r1)*relperc,
        g1 + (g2-g1)*relperc,
        b1 + (b2-b1)*relperc
    end
end

local pi = math.pi
local twopi = pi * 2
local function ColorTexture(texture, angle)
    local perc = math.abs((pi - math.abs(angle)) / pi)

    local gr,gg,gb = 0, 1, 0
    local mr,mg,mb = 1, 1, 0
    local br,bg,bb = 1, 0, 0
    local r,g,b = ColorGradient(perc, br, bg, bb, mr, mg, mb, gr, gg, gb)

    texture:SetVertexColor(r,g,b)
end

local function RotateTexture(frame, angle)
    if not frame:IsShown() then
        frame:Show()
    end
    angle = angle - GetPlayerFacing()

    local cell = floor(angle / twopi * 108 + 0.5) % 108
    if cell == frame.cell then return end
    frame.cell = cell

    local column = cell % 9
    local row = floor(cell / 9)

    ColorTexture(frame.arrow, angle)
    local xstart = (column * 56) / 512
    local ystart = (row * 42) / 512
    local xend = ((column + 1) * 56) / 512
    local yend = ((row + 1) * 42) / 512
    frame.arrow:SetTexCoord(xstart,xend,ystart,yend)
end

local px, py, tx, ty
local function GetBearing(unit)

    px, py = GetPlayerMapPosition("player")
    if((px or 0)+(py or 0) <= 0) then
        if WorldMapFrame:IsVisible() then return end
        SetMapToCurrentZone()
        px, py = GetPlayerMapPosition("player")
        if((px or 0)+(py or 0) <= 0) then return end
    end

    tx, ty = GetPlayerMapPosition(unit)
    if((tx or 0)+(ty or 0) <= 0) then return end

    return pi - math.atan2(px-tx,ty-py)
end

function ns:UpdateArrow(self)	

	local unit = self.displayedUnit or self.unit
	local freebarrow = self.Freebarrow
	
	if UnitIsUnit(unit, "player") or not ns.db.arrow or (ns.db.arrow and ns.db.arrowmouseover and not self.ArrowMouseoverUnit) then
		if freebarrow:IsShown() then
			freebarrow:Hide() 
		end	
		return
	end
	
	if UnitIsConnected(unit) and not UnitInRange(unit) then	
		local bearing = GetBearing(unit)
		if bearing then
			freebarrow:SetScale(ns.db.arrowscale)
			RotateTexture(freebarrow, bearing)
		end
	end
end

function ns:UpdateInRange(self)
	local inRange, checkedRange = UnitInRange(self.displayedUnit)
	if checkedRange and not inRange then
		self:SetAlpha(ns.db.outsideRange)
	else
		self:SetAlpha(1)
	end
end

local function UpdateGcd(self, elapsed)
	local perc = (GetTime() - self.starttime) / self.duration
	if perc > 1 then
		self:Hide()
	else
		self:SetValue(perc)
	end
end

function ns:UpdateGcdBar(self)
	local unit = ns.GcdMouseoverUnit
	if (unit and unit ~= self.displayedUnit) or (not unit and not UnitIsUnit(self.displayedUnit, "player")) or not ns.general.isHealer or not ns.db.Gcd or not ns.general.GcdSpellID then 
		self.Gcd:Hide() 
		return 
	end

	local start, dur = GetSpellCooldown(ns.general.GcdSpellID)
	if start then 
		if (not dur) or dur == 0 then
			self.Gcd:SetScript('OnUpdate', nil)
			self.Gcd:Hide() 
		else
			self.Gcd.starttime = start
			self.Gcd.duration = dur			
			self.Gcd:Show()
			self.Gcd:SetScript('OnUpdate', UpdateGcd)
		end
	end
end

function ns:UpdateInVehicle(self)
	if UnitHasVehicleUI(self.unit) then
		if not self.inVehicle then
			self.inVehicle = true
			local prefix, id, suffix = string.match(self.unit, "([^%d]+)([%d]*)(.*)")
			self.displayedUnit = prefix.."pet"..id..suffix
		end
	else
		if self.inVehicle then
			self.inVehicle = false
			self.displayedUnit = self.unit
		end
	end
end

function ns:UpdateDispelIcon(self)
	if not ns.db.dispel then self.DispelIcon:Hide() return end
	local unit = self.displayedUnit or self.unit
	if not UnitExists(unit) then return end
	
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(unit, index, 'HARMFUL')
        if not name then break end
		if ns.general.dispellist[dtype] then
			self.DispelIcon:SetTexture("Interface\\RaidFrame\\Raid-Icon-Debuff"..dtype)
			self.DispelIcon:Show()
			return 
		end
        index = index + 1
    end
	self.DispelIcon:Hide()
end

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local FormatTime = function(s)
    if s >= day then
        return format("%dd", floor(s/day + 0.5))
    elseif s >= hour then
        return format("%dh", floor(s/hour + 0.5))
    elseif s >= minute then
        return format("%dm", floor(s/minute + 0.5))
    end

    return format("%d", fmod(s, minute))
end

function ns:UpdateIndicatorTimer(self, elapsed)

	local unit = self.displayedUnit or self.unit
	if not UnitExists(unit) or string.match(unit, "pet") then return end
	
	local text = ""
	local tbl = self.Indicators
	for k, _ in pairs(tbl) do
		if not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
			if tbl[k]:IsShown() then
				tbl[k]:Hide() 
			end
		end
		if tbl[k]:IsShown() and (k == "Cen" or k == "BR") then
			if tbl[k].count then
				local timeLeft = tbl[k].ex - GetTime()
				text = tostring(tbl[k].count)
				if (DB.MyClass == "DRUID" and k == "BR") then
					if text == "1" then text = "|cffFF00004|r"
					elseif text == "2" then text = "|cffFF99002|r"
					elseif text == "3" then text = "|cffA7FD0A3|r"
					end
				elseif (DB.MyClass == "PALADIN" and k == "BR") then
					if text == "1" then text = "|cffFFCC003|r" end
				elseif (DB.MyClass == "WARLOCK" and k == "BR") then
					if text == "1" then text = "|cffFFCC005|r" end
				elseif (DB.MyClass == "SHAMAN" and k == "BR") then
					local earthCount = {'i','h','g','f','p','q','Z','Z','Y'}
					if text then text=tonumber(text) text = '|cffFFCF7F'..earthCount[text]..'|r' end
				elseif (DB.MyClass == "PRIEST" and k == "BR") then
					local pomCount = {[1] = 'i',[2] = 'h',[3] = 'g',[4] = 'f',[5] = 'Z',[6] = 'Y',}
					if text then text=tonumber(text) text = "|cffFFCC00"..pomCount[text].."|r" end 
				end
				if timeLeft <= 5 then
					text = ns:hex(1, 0, 0)..text.."|r"
				end
			end
			if tbl[k].expires then
				local timeLeft = tbl[k].expires - GetTime()
				if timeLeft <= 0 then
					tbl[k].expires = nil
					tbl[k]:Hide()
				else
					if text ~= "" then
						text = text.."-"..FormatTime(timeLeft)
					else
						text = FormatTime(timeLeft)
					end
					if timeLeft <= 5 then
						text = ns:hex(1, 0, 0)..text.."|r"
					end
				end
			end
			if text ~= "" then
				tbl[k]:SetText(text)
			end
		end
	end
end

local function UpdateIndicatorsAura(self, spell, isbuff)
	local unit = self.displayedUnit or self.unit
	if not UnitExists(unit) then return end
	if string.match(unit, "pet") or not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then return end
	
	local getUnitAura = isbuff and UnitBuff or UnitDebuff
	local name, rank, texture, count, dtype, duration, expires, caster
	
	for i = 1, #spell do
		if GetSpellInfo(spell[i]) ==nil then return end
		name, rank, texture, count, dtype, duration, expires, caster = getUnitAura(unit, GetSpellInfo(spell[i]))
		if name then 
			break
		end
	end
	return name, rank, texture, count, dtype, duration, expires, caster
end


function ns:UpdateIndicators(self)
	local unit = self.displayedUnit or self.unit
	if not UnitExists(unit) then return end
	if string.match(unit, "pet") or not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then return end

	local text
	local r, g, b
	for k, _ in pairs(self.Indicators) do
		text = ""
		if type(ns.general.IndicatorsSet[k]) == "table" then		
			for i, v in pairs(ns.general.IndicatorsSet[k]) do
				if v.talent and v.talent ~= GetSpecialization() then break end
				if type(ns.general.IndicatorsSet[k][i]) == "table" then	
					if type(v.color) == "table" then
						r, g, b = v.color.r, v.color.g, v.color.b
					else
						r, g, b = 0.0, 1, 0.0
					end

					local name, rank, texture, count, dtype, duration, expires, caster = UpdateIndicatorsAura(self, v.id, v.isbuff)																	
					if not name then	
						if v.lack then
							text = text..ns:hex(r, g, b)..i.."|r"
						end
						self.Indicators[k].expires = nil
						self.Indicators[k].count = nil
					else
						--print(name)
						if not v.mine or (v.mine and caster == "player") then
							if v.count or v.etime then
								if v.count and count ~= 0 then
									self.Indicators[k].count = count
									self.Indicators[k].ex = expires	
								end
								if v.etime then	
									self.Indicators[k]:SetFont(DB.Font, ns.db.symbolsize, ns.db.outline)
									self.Indicators[k].expires = expires	
								end
							elseif not v.lack then
								if (DB.MyClass == "WARLOCK") then
									if i == "1" then text = ns:hex(r, g, b).."5|r" end
								else
									text = text..ns:hex(r, g, b)..i.."|r"
								end
								--text = text..ns:hex(r, g, b)..i.."|r"
							end
						end
					end
					
				end
			end
			if self.Indicators[k].expires or self.Indicators[k].count or text ~= "" then
				if not self.Indicators[k]:IsShown() then
					self.Indicators[k]:Show()
				end
				if text ~= "" then
					self.Indicators[k]:SetText(text)
				end
			else
				if self.Indicators[k]:IsShown() then
					self.Indicators[k]:Hide()
				end
			end
		end
	end
end

function ns:CreateIndicators(self)
	local indicator = ns.media.indicator
	local symbols = ns.media.symbols
	self.Indicators = {}
	
	local TL = self.help:CreateFontString(nil, "OVERLAY")
	TL:SetPoint("TOPLEFT", self.HealthBar,"TOPLEFT", 0, -1)
	TL:SetShadowOffset(ns.db.shadowoffset, -ns.db.shadowoffset)
	TL:SetFont(indicator, ns.db.indicatorsize, ns.db.outline)
	TL:Hide()
	self.Indicators.TL = TL

	local TR = self.help:CreateFontString(nil, "OVERLAY")
	TR:SetPoint("TOPRIGHT", self.HealthBar, 2, -1)
	TR:SetShadowOffset(ns.db.shadowoffset, -ns.db.shadowoffset)
	TR:SetFont(indicator, ns.db.indicatorsize, ns.db.outline)
	TR:Hide()
	self.Indicators.TR = TR

	local BL = self.help:CreateFontString(nil, "OVERLAY")
	BL:SetPoint("BOTTOMLEFT", self.HealthBar, 0, 0)
	BL:SetShadowOffset(ns.db.shadowoffset, -ns.db.shadowoffset)
	BL:SetFont(indicator, ns.db.indicatorsize, ns.db.outline)
	BL:Hide()
	self.Indicators.BL = BL

	local RC = self.help:CreateFontString(nil, "OVERLAY")
	RC:SetPoint("RIGHT", self.HealthBar, 2, -1)
	RC:SetShadowOffset(ns.db.shadowoffset, -ns.db.shadowoffset)
	RC:SetFont(indicator, ns.db.indicatorsize, ns.db.outline)
	RC:Hide()
	self.Indicators.RC = RC

	local BR = self.help:CreateFontString(nil, "OVERLAY")
	BR:SetPoint("BOTTOMRIGHT", self.HealthBar, 0, -2)
	BR:SetShadowOffset(ns.db.shadowoffset, -ns.db.shadowoffset)
	BR:SetFont(symbols, ns.db.symbolsize, ns.db.outline)
	BR:Hide()
	self.Indicators.BR = BR

	local Cen = self.help:CreateFontString(nil, "OVERLAY")
	Cen:SetPoint("TOP", 0, -2)
	Cen:SetJustifyH("CENTER")
	Cen:SetShadowOffset(ns.db.shadowoffset, -ns.db.shadowoffset)
	Cen:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
	Cen:SetWidth(ns.db.width)
	Cen:Hide()
	self.Indicators.Cen = Cen

end

function ns:CreateAuraIcon(auras)
    local button = CreateFrame("Button", nil, auras)
    button:EnableMouse(false)
    button:SetPoint("BOTTOMLEFT", auras, "BOTTOMLEFT")
    button:SetSize(auras.size, auras.size)
	
	local cd = CreateFrame("Cooldown", nil, button)
	cd:SetAllPoints(button)
	
    local icon = button:CreateTexture(nil, "OVERLAY")
    icon:SetAllPoints(button)
    icon:SetTexCoord(.07, .93, .07, .93)

    local font, fontsize = GameFontNormalSmall:GetFont()
    local count = button:CreateFontString(nil, "OVERLAY")
    count:SetFont(font, fontsize + 2, ns.db.outline)
	count:SetShadowOffset(ns.db.shadowoffset, -ns.db.shadowoffset)
    count:SetPoint("LEFT", button, "BOTTOM", 3, 2)

    local border = CreateFrame("Frame", nil, button)
    border:SetPoint("TOPLEFT", button, "TOPLEFT", -5, 5)
    border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 5, -5)
    border:SetFrameLevel(4)
    border:SetBackdrop(glowBorder)
    border:SetBackdropColor(0,0,0,1)
    border:SetBackdropBorderColor(0,0,0,1)
    
    local remaining = button:CreateFontString(nil, "OVERLAY")
    remaining:SetPoint("CENTER") 
    remaining:SetFont(font, fontsize, ns.db.outline)
	remaining:SetShadowOffset(ns.db.shadowoffset, -ns.db.shadowoffset)
    remaining:SetTextColor(1, 1, 0)
	
	button.border = border
    button.remaining = remaining
    button.parent = auras
    button.icon = icon
    button.currentCount = count
    button.cd = cd
    button:Hide()

    return button
end

local dispelPriority = {
    Magic = 4,
    Curse = 3,
    Poison = 2,
    Disease = 1,
}

local CustomFilter = function(...)
    local key, isbuff, name, _, _, _, dtype = ...	

	if isbuff then
		if type(ns.auras_buffs[key]) == "table" then
			for k, v in pairs(ns.auras_buffs[key]) do
				if k == name then
					return true, v
				end
			end
		end
	else
		if type(ns.auras_debuffs[key]) == "table" then
			for k, v in pairs(ns.auras_debuffs[key]) do
				if k == name then
					return true, v
				end
			end
		end
		if type(ns.auras_instances_debuffs[key]) == "table" then
			for k, v in pairs(ns.auras_instances_debuffs[key]) do
				if type(v) == "table" and (k == ns.general.MapID or (type(k) == "string" and k == GetMapNameByID(ns.general.MapID))) then
					for i, var in pairs(v) do
						if i == name then
							return true, var
						end
					end
				end
			end
		end
		if ns.general.dispellist[dtype] and key == "second" then
			return true, dispelPriority[dtype]
		end
	end
end

local function UpdateAuraTimer(self, elapsed)
    self.auraTimer = (self.auraTimer or 0) + elapsed
    if self.auraTimer < .4 then return end

	if self:IsShown() and self.Expires then
		local timeLeft = self.Expires - GetTime()
		if timeLeft <= 0 then
			self.remaining:SetText(nil)
		else

			if ns.auras_ascending[self.spellName] then
				local duration = self.Duration - timeLeft
				self.remaining:SetText(FormatTime(duration))
			else
				self.remaining:SetText(FormatTime(timeLeft))
			end
		end
	end
	self.auraTimer = 0
end

local buffcolor = { r = 0.0, g = 1.0, b = 1.0 }
function ns:UpdateAuras(self)
	local unit = self.displayedUnit or self.unit
	if not UnitExists(unit) then return end
	
	local show , priority
	
	for k, _ in pairs(self.Auras) do
		self.Auras[k].Button.cur		= 0 
		self.Auras[k].Button.Texture	= nil
		self.Auras[k].Button.Count		= nil 
		self.Auras[k].Button.Dtype		= nil 
		self.Auras[k].Button.Duration	= nil 
		self.Auras[k].Button.Expires	= nil 
		self.Auras[k].Button.spellName 	= nil
		self.Auras[k].Button.isbuff 	= nil
		self.Auras[k].Button.show 		= nil
	
		local index = 1
		while true do
			local _, rank, texture, count, dtype, duration, expires, caster, _, _, name = UnitDebuff(unit, index)
			if not name then break end
			
			show , priority = CustomFilter(k, false, name, rank, texture, count, dtype, duration, expires, caster)
			--print(name, show)
			if(show) then
				if (priority > self.Auras[k].Button.cur) or (priority ~= 0 and priority == self.Auras[k].Button.cur and count > self.Auras[k].Button.Count) then
					self.Auras[k].Button.cur		= priority
					self.Auras[k].Button.Texture	= texture 
					self.Auras[k].Button.Count		= count 
					self.Auras[k].Button.Dtype		= dtype 
					self.Auras[k].Button.Duration	= duration 
					self.Auras[k].Button.Expires	= expires 
					self.Auras[k].Button.spellName 	= name
					self.Auras[k].Button.isbuff 	= false
					self.Auras[k].Button.show 		= true	
				end
			end
			index = index + 1
		end

		index = 1
		while true do
			local _, rank, texture, count, dtype, duration, expires, caster, _, _, name = UnitBuff(unit, index)
			if not name then break end

			show, priority = CustomFilter(k, true, name, rank, texture, count, dtype, duration, expires, caster)
			
			if show then
				if (priority > self.Auras[k].Button.cur) then
					self.Auras[k].Button.cur		= priority 
					self.Auras[k].Button.Texture	= texture
					self.Auras[k].Button.Count		= count 
					self.Auras[k].Button.Dtype		= dtype 
					self.Auras[k].Button.Duration	= duration 
					self.Auras[k].Button.Expires	= expires 
					self.Auras[k].Button.spellName 	= name
					self.Auras[k].Button.isbuff 	= true
					self.Auras[k].Button.show 		= true
				end			
			end
			index = index + 1
		end

		if self.Auras[k].Button.show then
			local color = (self.Auras[k].Button.isbuff and buffcolor) or DebuffTypeColor[self.Auras[k].Button.Dtype] or DebuffTypeColor.none
			self.Auras[k].Button.border:SetBackdropBorderColor(color.r, color.g, color.b)
			self.Auras[k].Button.icon:SetTexture(self.Auras[k].Button.Texture)

			self.Auras[k].Button.currentCount:SetText(self.Auras[k].Button.Count > 1 and self.Auras[k].Button.Count)
			if not self.Auras[k].Button:IsShown() then
				self.Auras[k].Button:Show()
			end
			self.Auras[k].Button:SetScript("OnUpdate", UpdateAuraTimer)
		elseif self.Auras[k].Button:IsShown() then
			self.Auras[k].Button:SetScript("OnUpdate", nil)
			self.Auras[k].Button:Hide()
		end
	end
end

function ns:UpdateClickCastSet()

	if ns.db.ClickCast.enable then
		if IsAddOnLoaded("Clique") and type(Clique.UnregisterFrame) == "function" and type(Clique.ccframes) == "table" then
			for button, enabled in pairs(Clique.ccframes) do		
				if string.find(button:GetName(),"Freebgrid") and enabled then
					Clique:UnregisterFrame(button)
				end
			end
		end
		if type(ns.db.ClickCast) == "table" and type(ns.ApplyClickSetting) == "function" then 
			self:ApplyClickSetting()
		end
	else
		if type(ns.db.ClickCast) == "table" and type(ns.ApplyClickSetting) == "function" then 
			self:ApplyClickSetting()
		end

		if IsAddOnLoaded("Clique") and type(Clique.RegisterFrame) == "function" then
			for _, object in next, ns._Objects do
				Clique:RegisterFrame(object)
			end
		end	
	end
end

function ns:UpdateAllElements(self)
	ns:UpdateInVehicle(self)
	if UnitExists(self.unit) then
		
		ns:UpdateMaxHealth(self)
		ns:UpdateHealth(self)		
		ns:UpdateHealthColor(self)	
		ns:UpdateHealPrediction(self)		
		ns:UpdatePowerBar(self)
		ns:UpdatePower(self)		
		ns:UpdateName(self)
		ns:UpdateRaidIcon(self)
		ns:UpdateLeaderAndAssistantIcon(self)
		ns:UpdateMasterlooterIcon(self)
		ns:UpdateSelectionHighlight(self)
		ns:UpdateRoleIcon(self)
		ns:UpdateReadyCheck(self)
		ns:UpdateStatusText(self)
		ns:UpdateResurrectIcon(self)
		ns:UpdateThreatBorder(self)
		ns:UpdateIndicators(self)
		ns:UpdateDispelIcon(self)
	end
end

local updateZoneAndMapid = function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed < 5 then return end	

    if IsInInstance() then       		 
		ns.general.difficulty = ns:Getdifficulty()
    end
	ns.general.MapID = ns:GetMapID()
    self:SetScript("OnUpdate", nil)
    self.elapsed = 0
end

local OnEvent = function(self, event, ...)
	local arg1, arg2, arg3, arg4 = ...
	if ( event == "ADDON_LOADED" and arg1 ==  ADDON_NAME) then
		self:RegisterEvent("PLAYER_LOGIN")
		self:UnregisterEvent("ADDON_LOADED")
		
	elseif ( event == "PLAYER_LOGIN" ) then
		self:RegisterEvent("PLAYER_LOGOUT")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		self:RegisterEvent("CHARACTER_POINTS_CHANGED")
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("RAID_ROSTER_UPDATE")
		hooksecurefunc("CompactRaidFrameManager_UpdateShown", ns.UpdateBlizzardRaidFrame)
		ns:UpdateBlizzardRaidFrame()
		ns:InitDB()
		Anchors()	
		ns:CreateRaidFrame()
		ns:CreatePetFrame()
		ns:CreateMTFrame()
		ns:UpdateHeadersDisplayStatus()
		
		ns:UpdateBlizzardPartyFrameDisplayStatus()

		local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
		f:SetScript('OnShow', function(self)
			self:SetScript('OnShow', nil)
			if not IsAddOnLoaded('SunUI_Freebgrid_Config') then
				LoadAddOn('SunUI_Freebgrid_Config')
			end
		end)
		self:UnregisterEvent("PLAYER_LOGIN")
	elseif ( event == "PLAYER_REGEN_ENABLED" ) then
		if next(updateFuncList) then
			print(ADDON_NAME..": "..L.outcombatlock)

			lockprint = nil
			for _, v in pairs (updateFuncList) do
				if type(v) == "function" then v() end
			end	
			wipe(updateFuncList)
		end
	elseif ( event == "PLAYER_LOGOUT" ) then
		ns:FlushDB()
	elseif ( event == "RAID_ROSTER_UPDATE" ) then
		ns:UpdateBlizzardCompactRaidFrameManager()
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then	
		ns:UpdatePlayerData()

		if ns.general.TalentGroup > 0 and not _G[ADDON_NAME.."DB"].profileKeys[ns.general.playerDBKey].dualspec then
			if not IsAddOnLoaded('SunUI_Freebgrid_Config') then
				LoadAddOn('SunUI_Freebgrid_Config')
			end
			ns:FlushDB()
			ns.general.Profilename = _G[ADDON_NAME.."DB"].profileKeys[ns.general.playerDBKey].profile[tostring(ns.general.TalentGroup)]

			ns.db = _G[ADDON_NAME.."DB"].profiles[ns.general.Profilename]
			ns:CopyDefaults(ns.db, ns.defaults)
			
			ns:UpdateHeadersLayout()
			ns:UpdateObjectLayout()
			ns:RestorePosition()
			ns:ApplyClickSetting()
		end
		
	elseif event == "CHARACTER_POINTS_CHANGED" then
		ns:UpdatePlayerData()
	elseif event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
		if event == "PLAYER_ENTERING_WORLD" then	
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end 
		self:SetScript("OnUpdate", updateZoneAndMapid)
	end	
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", OnEvent)

function ns:Slash(inp)
    if(inp:match("%S+")) then
        if not IsAddOnLoaded('SunUI_Freebgrid_Config') then
            LoadAddOn('SunUI_Freebgrid_Config')
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