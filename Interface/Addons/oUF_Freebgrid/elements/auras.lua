local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local auralist = ns.auras

local glowBorder = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    edgeFile = [=[Interface\AddOns\oUF_Freebgrid\media\glowTex.tga]=], edgeSize = 4,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
}

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

local CreateAuraIcon = function(auras)
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
    count:SetFont(font, fontsize + 2, "THINOUTLINE")
    count:SetPoint("LEFT", button, "BOTTOM", 3, 2)

    local border = CreateFrame("Frame", nil, button)
    border:SetPoint("TOPLEFT", button, "TOPLEFT", -5, 5)
    border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 5, -5)
    border:SetFrameLevel(4)
    border:SetBackdrop(glowBorder)
    border:SetBackdropColor(0,0,0,1)
    border:SetBackdropBorderColor(0,0,0,1)
    button.border = border

    local remaining = button:CreateFontString(nil, "OVERLAY")
    remaining:SetPoint("CENTER") 
    remaining:SetFont(font, fontsize, "THINOUTLINE")
    remaining:SetTextColor(1, 1, 0)
	
    button.remaining = remaining
    button.parent = auras
    button.icon = icon
    button.count = count
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
    local isbuff, name, _, _, _, dtype = ...	
    local priority = 0
	ns.instDebuffs.first = ns.instDebuffs.first or {}
	ns.instDebuffs.second = ns.instDebuffs.second or {}
	
	if isbuff then
		if auralist.first.buffs[name] then
			priority = auralist.first.buffs[name]
			return true, 1, priority
		elseif auralist.second.buffs[name] then
			priority = auralist.second.buffs[name]
			return true, 2, priority
		end
	else
		if ns.instDebuffs.first[name] then
			priority = ns.instDebuffs.first[name]
			return true, 1, priority
		elseif ns.instDebuffs.second[name] then
			priority = ns.instDebuffs.second[name]
			return true, 2, priority
		elseif auralist.first.debuffs[name] then
			priority = auralist.first.debuffs[name]
			return true, 1, priority
		elseif auralist.second.debuffs[name] then
			priority = auralist.second.debuffs[name]
			return true, 2, priority
		elseif dispelPriority[dtype] then
			priority = dispelPriority[dtype]
			return true, 1, priority
		end
	end 
end

local AuraTimer = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed < .2 then return end

	local timeLeft = self.currentExpires - GetTime()
	if timeLeft <= 0 then
		self.remaining:SetText(nil)
	else

		if auralist[self.name].ascending[self.spellName] then
			local duration = self.currentDuration - timeLeft
			self.remaining:SetText(FormatTime(duration))
		else
			self.remaining:SetText(FormatTime(timeLeft))
		end
	end
	self.elapsed = 0
end

local buffcolor = { r = 0.0, g = 1.0, b = 1.0 }
local updateDebuff = function(icon)
    local color = (icon.isbuff and buffcolor) or DebuffTypeColor[icon.currentDtype] or DebuffTypeColor.none
	icon.border:SetBackdropBorderColor(color.r, color.g, color.b)
    icon.icon:SetTexture(icon.currentTexture)

	icon.count:SetText(icon.currentCount > 1 and icon.currentCount)

    icon:SetScript("OnUpdate", AuraTimer)
end

local Update = function(self, event, unit)
    if(self.unit ~= unit) then return end

    local mainicon = self.freebAuras.button
	local secicon = self.freebSecAuras.button
	local icon, isbuff
	mainicon.cur = 0
	secicon.cur = 0
	mainicon.name = "first"
	secicon.name = "second"
	mainicon.show 	= false
	secicon.show = false
	
    local index = 1
    while true do
        local name, rank, texture, count, dtype, duration, expires, caster = UnitDebuff(unit, index)

        if not name then break end
      
        local show ,num, priority = CustomFilter(false, name, rank, texture, count, dtype, duration, expires, caster)

        if(show) then
			if num == 1 then
				icon = mainicon 
			elseif num == 2 then
				icon = secicon
			end
			if (priority > icon.cur) or (priority ~= 0 and priority == icon.cur and count > icon.currentCount) then
				icon.cur				= priority
				icon.currentTexture		= texture 
				icon.currentCount		= count 
				icon.currentDtype		= dtype 
				icon.currentDuration	= duration 
				icon.currentExpires		= expires 
				icon.spellName 			= name
				icon.isbuff 			= false
				icon.show 				= true	
			end
        end
        index = index + 1
    end

    index = 1
    while true do
        local name, rank, texture, count, dtype, duration, expires, caster = UnitBuff(unit, index)
        if not name then break end

        local show ,num, priority = CustomFilter(true, name, rank, texture, count, dtype, duration, expires, caster)
		
		if show then	
			if num == 1 then
				icon = mainicon 
			elseif num == 2 then
				icon = secicon
			end
			
			if (priority > icon.cur) then
				icon.cur				= priority 
				icon.currentTexture		= texture
				icon.currentCount		= count 
				icon.currentDtype		= dtype 
				icon.currentDuration	= duration 
				icon.currentExpires		= expires 
				icon.spellName 			= name
				icon.isbuff 			= true
				icon.show 				= true
			end			
        end
        index = index + 1
    end

    if mainicon.show then      
		updateDebuff(mainicon)
		mainicon:Show()
	else 
		mainicon:Hide()
    end
	if secicon.show then      
		updateDebuff(secicon)
		secicon:Show()
	else 
		secicon:Hide()
    end
end 

local Enable = function(self)
    local auras = self.freebAuras
	local secauras = self.freebSecAuras
	if auras or secauras then
		if auras then
			auras.button = CreateAuraIcon(auras)			
		end
		if secauras then
			secauras.button = CreateAuraIcon(secauras)	
		end
		self:RegisterEvent("UNIT_AURA", Update)
		return true
	end
end

local Disable = function(self)
    local auras = self.freebAuras
	local secauras = self.freebSecAuras
    if auras or secauras then
        self:UnregisterEvent("UNIT_AURA", Update)
    end
end

oUF:AddElement('freebAuras', Update, Enable, Disable)
