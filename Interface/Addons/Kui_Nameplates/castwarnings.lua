local kui = LibStub('Kui-1.0')
local kn = KuiNameplates
local cw = CreateFrame('Frame')
    
-- combat log events to listen to for cast warnings/healing
local warningEvents = {
	['SPELL_CAST_START']    = true,
	['SPELL_CAST_SUCCESS']  = true,
	['SPELL_INTERRUPT']     = true,
	['SPELL_HEAL']          = true,
	['SPELL_PERIODIC_HEAL'] = true
}

local function SetCastWarning(self, spellName, spellSchool)
	self.castWarning.ag:Stop()

	if spellName == nil then
		-- hide the warning instantly (i.e. when interrupted)
		self.castWarning:SetAlpha(0)
	else
		local col = COMBATLOG_DEFAULT_COLORS.schoolColoring[spellSchool] or
			{r = 1, g = 1, b = 1}

		self.castWarning:SetText(spellName)
		self.castWarning:SetTextColor(col.r, col.g, col.b)
		self.castWarning:SetAlpha(1)

		self.castWarning.ag:Play()
	end
end

local function SetIncomingWarning(self, amount)
	if amount == 0 then return end
	self.incWarning.ag:Stop()

	if amount > 0 then
		-- healing
		amount = '+'..amount
		self.incWarning:SetTextColor(0, 1, 0)
	else
		-- damage (nyi)
		self.incWarning:SetTextColor(1, 0, 0)
	end

	self.incWarning:SetText(amount)

	self.incWarning:SetAlpha(1)
	self.incWarning.ag.fade:SetEndDelay(.5)

	self.incWarning.ag:Play()
end

-------------------------------------------------------------- Event handlers --
local function OnEvent(self, event, ...)
	local castTime, event, _, guid, name, _, _, targetGUID, targetName
		= ...

	if warningEvents[event] then
		if	event == 'SPELL_HEAL' or
			event == 'SPELL_PERIODIC_HEAL'
		then
			-- fetch the spell's target's nameplate
			guid, name = targetGUID, targetName
		end

		-- [[debug]]
		--guid, name = UnitGUID('target'), GetUnitName('target')

		local f = kn.f:GetNameplate(guid, name:gsub('%-.+$', ''))
		if f then
			if not f.SetIncomingWarning or f.trivial then return end
			local spName, spSch = select(13, ...)
			
			if event == 'SPELL_HEAL' or
			   event == 'SPELL_PERIODIC_HEAL'
			then
				-- display heal warning
				local amount = select(15, ...)
				f:SetIncomingWarning(amount)
			elseif event == 'SPELL_INTERRUPT' then
				-- hide the warning
				f:SetCastWarning(nil)
			else
				-- or display it for this spell
				f:SetCastWarning(spName, spSch)
			end
		end
	end
end

---------------------------------------------------------------------- Create --
cw.CreateCastWarnings = function(frame)
    -- casting spell name
    frame.castWarning = kui.CreateFontString(frame.overlay, {
        font = kn.font, size = kn.fontSizes.spellname, outline = 'OUTLINE' })
    frame.castWarning:SetPoint('BOTTOMLEFT', frame.level, 'TOPLEFT', 0, 1)
    frame.castWarning:Hide()

    frame.castWarning.ag 	= frame.castWarning:CreateAnimationGroup()
    frame.castWarning.fade	= frame.castWarning.ag:CreateAnimation('Alpha')
    frame.castWarning.fade:SetSmoothing('IN')
    frame.castWarning.fade:SetDuration(3)
    frame.castWarning.fade:SetChange(-1)

    frame.castWarning.ag:SetScript('OnPlay', function(self)
        self:GetParent():Show()
    end)

    frame.castWarning.ag:SetScript('OnFinished', function(self)
        self:GetParent():Hide()
    end)

    -- incoming healing
    frame.incWarning = kui.CreateFontString(frame.overlay, {
        font = kn.font, size = kn.fontSizes.small, outline = 'OUTLINE' })
    frame.incWarning:SetPoint('BOTTOMRIGHT', frame.health.p, 'TOPRIGHT', 1)
    frame.incWarning:Hide()

    frame.incWarning.ag 	 = frame.incWarning:CreateAnimationGroup()
    frame.incWarning.ag.fade = frame.incWarning.ag:CreateAnimation('Alpha')
    frame.incWarning.ag.fade:SetSmoothing('IN')
    frame.incWarning.ag.fade:SetDuration(.5)
    frame.incWarning.ag.fade:SetChange(-.5)

    frame.incWarning.ag:SetScript('OnPlay', function(self)
        self:GetParent():Show()
    end)

    frame.incWarning.ag:SetScript('OnFinished', function(self)
        if self.fade:GetEndDelay() > 0 then
            -- fade out fully
            self:GetParent():SetAlpha(.5)
            self.fade:SetEndDelay(0)
            self:Play()
        else
            self:GetParent():Hide()
        end
    end)

    -- handlers
    frame.SetCastWarning = SetCastWarning
    frame.SetIncomingWarning = SetIncomingWarning
end
------------------------------------------------------------------------ Hide --
cw.HideCastWarnings = function(frame)
	if frame.castWarning then
		frame.castWarning:SetText()
		frame.castWarning.ag:Stop()
		frame.incWarning:SetText()
	end
end
-------------------------------------------------------------------- Register --
cw.Enable = function(self)	
    kn.RegisterPostFunction('create', self.CreateCastWarnings)
    kn.RegisterPostFunction('hide', self.HideCastWarnings)
    self:SetScript('OnEvent', OnEvent)
    
    self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
end

kn.RegisterModule('warnings', cw)
