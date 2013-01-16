local kui = LibStub('Kui-1.0')
local kn = KuiNameplates
local cb = CreateFrame('Frame')
local castEvents = {
	['UNIT_SPELLCAST_START']          = true,
	['UNIT_SPELLCAST_FAILED']         = true,
	['UNIT_SPELLCAST_STOP']           = true,
	['UNIT_SPELLCAST_INTERRUPTED']    = true,
	['UNIT_SPELLCAST_DELAYED']        = true,
	['UNIT_SPELLCAST_CHANNEL_START']  = true,
	['UNIT_SPELLCAST_CHANNEL_UPDATE'] = true,
	['UNIT_SPELLCAST_CHANNEL_STOP']   = true
}

local UnitGUID, GetUnitName, UnitChannelInfo, UnitCastingInfo, GetTime, format =
      UnitGUID, GetUnitName, UnitChannelInfo, UnitCastingInfo, GetTime, format

------------------------------------------------------------- Script handlers --
local function OnCastbarUpdate(bar, elapsed)
	if bar.channel then
		bar.progress = bar.progress - elapsed
	else
		bar.progress = bar.progress + elapsed
	end

	if	not bar.duration or
		((not bar.channel and bar.progress >= bar.duration) or
		(bar.channel and bar.progress <= 0))
	then
		-- hide the castbar bg
		bar:GetParent():Hide()
		bar.progress = 0
		return
	end

	-- display progress
	if bar.max then
		bar.curr:SetText(string.format("%.1f", bar.progress))

		if bar.delay == 0 or not bar.delay then
			bar.max:SetText(string.format("%.1f", bar.duration))
		else
			-- display delay
			if bar.channel then
				-- time is removed
				bar.max:SetText(string.format("%.1f", bar.duration)..
					'|cffff0000-'..string.format("%.1f", bar.delay)..'|r')
			else
				-- time is added
				bar.max:SetText(string.format("%.1f", bar.duration)..
					'|cffff0000+'..string.format("%.1f", bar.delay)..'|r')
			end
		end
	end

	bar:SetValue(bar.progress/bar.duration)
end

---------------------------------------------------------------------- create --
cb.CreateCastbar = function(frame)
	-- cast bar background -------------------------------------------------
	frame.castbarbg = CreateFrame("Frame", nil, frame.parent)
	frame.castbarbg:SetFrameStrata('BACKGROUND');
	frame.castbarbg:SetBackdrop({
		bgFile = kui.m.t.solid, edgeFile = kui.m.t.shadow,
		edgeSize = 5, insets = {
			top = 5, left = 5, bottom = 5, right = 5
		}
	})

	frame.castbarbg:SetBackdropColor(0, 0, 0, .85)
	frame.castbarbg:SetBackdropBorderColor(1, .2, .1, 0)
	frame.castbarbg:SetHeight(kn.sizes.cbheight)

	frame.castbarbg:SetPoint('TOPLEFT', frame.bg.fill, 'BOTTOMLEFT', -5, 4)
	frame.castbarbg:SetPoint('TOPRIGHT', frame.bg.fill, 'BOTTOMRIGHT', 5, 0)

	frame.castbarbg:Hide()

	-- cast bar ------------------------------------------------------------
	frame.castbar = CreateFrame("StatusBar", nil, frame.castbarbg)
	frame.castbar:SetStatusBarTexture(kui.m.t.bar)

	frame.castbar:SetPoint('TOPLEFT', frame.castbarbg, 'TOPLEFT', 6, -6)
	frame.castbar:SetPoint('BOTTOMLEFT', frame.castbarbg, 'BOTTOMLEFT', 6, 6)
	frame.castbar:SetPoint('RIGHT', frame.castbarbg, 'RIGHT', -6, 0)

	frame.castbar:SetMinMaxValues(0, 1)

	-- uninterruptible cast shield -----------------------------------------
	frame.castbar.shield = frame.castbar:CreateTexture(nil, 'ARTWORK')
	frame.castbar.shield:SetTexture('Interface\\AddOns\\Kui_Nameplates\\Shield')
	frame.castbar.shield:SetTexCoord(0, .53125, 0, .6875)

	frame.castbar.shield:SetSize(12, 17)
	frame.castbar.shield:SetPoint('CENTER', frame.castbar, 0, 1)

	frame.castbar.shield:SetBlendMode('BLEND')
	frame.castbar.shield:SetDrawLayer('ARTWORK', 7)
	frame.castbar.shield:SetVertexColor(1, .1, .1)
	
	frame.castbar.shield:Hide()
	
	-- cast bar text -------------------------------------------------------
	if kn.profile.castbar.spellname then
		frame.castbar.name = kui.CreateFontString(frame.castbar, {
			font = kn.font, size = kn.fontSizes.name, outline = "OUTLINE" })
		frame.castbar.name:SetPoint('TOPLEFT', frame.castbar, 'BOTTOMLEFT', 2, -2)
	end

	if kn.profile.castbar.casttime then
		frame.castbar.max = kui.CreateFontString(frame.castbar, {
			font = kn.font, size = kn.fontSizes.name, outline = "OUTLINE" })
		frame.castbar.max:SetPoint('TOPRIGHT', frame.castbar, 'BOTTOMRIGHT', -2, -1)

		frame.castbar.curr = kui.CreateFontString(frame.castbar, {
			font = kn.font, size = kn.fontSizes.small, outline = "OUTLINE" })
		frame.castbar.curr:SetAlpha(.5)
		frame.castbar.curr:SetPoint('TOPRIGHT', frame.castbar.max, 'TOPLEFT', -1, -1)
	end

	if frame.spell then
		-- cast bar icon background ----------------------------------------
		frame.spellbg = frame.castbarbg:CreateTexture(nil, 'BACKGROUND')
		frame.spellbg:SetTexture(kui.m.t.solid)
		frame.spellbg:SetSize(kn.sizes.icon, kn.sizes.icon)

		frame.spellbg:SetVertexColor(0, 0, 0, .85)

		frame.spellbg:SetPoint('TOPRIGHT', frame.health, 'TOPLEFT', -2, 1)

		-- cast bar icon ---------------------------------------------------
		frame.spell:ClearAllPoints()
		frame.spell:SetParent(frame.castbarbg)
		frame.spell:SetSize(kn.sizes.icon - 2, kn.sizes.icon - 2)

		frame.spell:SetPoint('TOPRIGHT', frame.spellbg, -1, -1)

		frame.spell:SetTexCoord(.1, .9, .1, .9)
	end

	-- scripts -------------------------------------------------------------
	frame.castbar:HookScript('OnShow', function(bar)
		if bar.interruptible then
			bar:SetStatusBarColor(unpack(kn.profile.castbar.barcolour))
			bar:GetParent():SetBackdropBorderColor(0, 0, 0, .3)
			bar.shield:Hide()
		else
			bar:SetStatusBarColor(.8, .1, .1)
			bar:GetParent():SetBackdropBorderColor(1, .1, .2, .5)
			bar.shield:Show()
		end
	end)

	frame.castbar:SetScript('OnUpdate', OnCastbarUpdate)
end
------------------------------------------------------------------------ Hide --
cb.HideCastbar = function(frame)
    if frame.castbar then
        frame.castbar.duration = nil
        frame.castbar.id = nil
        frame.castbarbg:Hide()
    end
end
-------------------------------------------------------------- Event handlers --
function cb:UnitCastEvent(e, unit, ...)
	if unit == 'player' then return end
	local guid, name, f = UnitGUID(unit), GetUnitName(unit), nil
	--guid, name = UnitGUID('target'), GetUnitName('target')

	-- [debug]
	--print('CastEvent: ['..e..'] from ['..unit..'] (GUID: ['..(guid or 'nil')..']) (Name: ['..(name or 'nil')..'])')

	-- fetch the unit's nameplate
	f = kn.f:GetNameplate(guid, name)
	if f then
		if not f.castbar or f.trivial then return end
		if	e == 'UNIT_SPELLCAST_STOP' or
			e == 'UNIT_SPELLCAST_FAILED' or
			e == 'UNIT_SPELLCAST_INTERRUPTED'
		then
			-- these occasionally fire after a new _START
			local _, _, castID = ...
			if f.castbar.id ~= castID then
				return
			end
		end

		self[e](self, f, unit)
	end
end

function cb:UNIT_SPELLCAST_START(frame, unit, channel)
	local castbar = frame.castbar
	local name, _, text, texture, startTime, endTime, _, castID,
	      notInterruptible

	if channel then
		name, _, text, texture, startTime, endTime, _, castID, notInterruptible
			= UnitChannelInfo(unit)
	else
		name, _, text, texture, startTime, endTime, _, castID, notInterruptible
			= UnitCastingInfo(unit)
	end

	if not name then
		frame.castbarbg:Hide()
		return
	end

	castbar.id            = castID
	castbar.channel       = channel
	castbar.interruptible = not notInterruptible
	castbar.duration      = (endTime/1000) - (startTime/1000)
	castbar.delay         = 0

	if frame.spell then
		frame.spell:SetTexture(texture)
	end

	if castbar.name then
		castbar.name:SetText(name)
	end

	if castbar.channel then
		castbar.progress = (endTime/1000) - GetTime()
	else
		castbar.progress = GetTime() - (startTime/1000)
	end

	frame.castbarbg:Show()
end

function cb:UNIT_SPELLCAST_DELAYED(frame, unit, channel)
	local castbar = frame.castbar
	local _, name, startTime, endTime

	if channel then
		name, _, _, _, startTime, endTime = UnitChannelInfo(unit)
	else
		name, _, _, _, startTime, endTime = UnitCastingInfo(unit)
	end

	if not name then
		return
	end

	local newProgress
	if castbar.channel then
		newProgress	= (endTime/1000) - GetTime()
	else
		newProgress	= GetTime() - (startTime/1000)
	end

	castbar.delay = (castbar.delay or 0) + castbar.progress - newProgress
	castbar.progress = newProgress
end

function cb:UNIT_SPELLCAST_CHANNEL_START(frame, unit)
	self:UNIT_SPELLCAST_START(frame, unit, true)
end
function cb:UNIT_SPELLCAST_CHANNEL_UPDATE(frame, unit)
	self:UNIT_SPELLCAST_DELAYED(frame, unit, true)
end

function cb:UNIT_SPELLCAST_STOP(frame, unit)
	frame.castbarbg:Hide()
end
function cb:UNIT_SPELLCAST_FAILED(frame, unit)
	frame.castbarbg:Hide()
end
function cb:UNIT_SPELLCAST_INTERRUPTED(frame, unit)
	frame.castbarbg:Hide()
end
function cb:UNIT_SPELLCAST_CHANNEL_STOP(frame, unit)
	frame.castbarbg:Hide()
end

function cb.IsCasting(frame)
	-- TODO update this for other units (party1target etc)
	if not frame.castbar or not frame.target then return end

	local name = UnitCastingInfo('target')
	local channel = false

	if not name then
		name = UnitChannelInfo('target')
		channel = true
	end

	if name then
		-- if they're casting or channeling, try to show a castbar
		cb:UNIT_SPELLCAST_START(frame, 'target', channel)
	end
end

-------------------------------------------------------------------- Register --
local function OnEvent(self, event, ...)
    cb:UnitCastEvent(event, ...)
end

cb.Enable = function(self)	
	kn.RegisterPostFunction('create', self.CreateCastbar)
	kn.RegisterPostFunction('hide', self.HideCastbar)
	kn.RegisterPostFunction('show', self.IsCasting)
	kn.RegisterPostFunction('target', self.IsCasting)
	self:SetScript('OnEvent', OnEvent)
	
	for event,_ in pairs(castEvents) do
		self:RegisterEvent(event)
	end
end

kn.RegisterModule('castbar', cb)
