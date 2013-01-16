--[[
	Kui Nameplates
	Kesava-Auchindoun
	
	TODO make option for friendly/enemy name text colour (defaults to white)
]]

local addon, ns = ...
local kui = LibStub('Kui-1.0')
local LSM = LibStub('LibSharedMedia-3.0')

KuiNameplates = {
	f = CreateFrame('Frame'),
    font = '', fontSizes = {}, sizes = {}
}

-- our frame, whee
ns.f = KuiNameplates.f

-- Custom reaction colours
ns.r = {
    { .7, .2, .1 }, -- hated
    { 1, .8, 0 },   -- neutral
    { .2, .6, .1 }, -- friendly
	{ .5, .5, .5 }, -- tapped
}

local bgOffset = 4 -- inset offset for the frame glow (frame.bg)
local uiscale, prevuiscale
local loadedGUIDs, loadedNames, targetExists, profile = {}, {}
local origSizes, origFontSizes = {},{}
local font, sizes, fontSizes = '', {}, {}

--------------------------------------------------------------------- globals --
local select, strfind, strsplit, pairs, ipairs, unpack, tinsert, type
    = select, strfind, strsplit, pairs, ipairs, unpack, tinsert, type

-- helper for setting a given fontstring's font size
local function SetFontSize(fontstring, size)
	local font, _, flags = fontstring:GetFont()
	fontstring:SetFont(font, size, flags)
end
	
-------------------------------------------------- External calling functions --
local modules = {}
local postFunctions = {
	target = {}, -- upon becoming the target
	create = {}, -- post creation
	show   = {}, -- post OnFrameShow
	hide   = {}  -- post OnFrameHide
}

local function CallPostFunction(typ, frame)
	if postFunctions[typ] then
		local _, func
		for _, func in ipairs(postFunctions[typ]) do
			func(frame)
		end
	end
end

KuiNameplates.RegisterPostFunction = function(typ, func)
	if postFunctions[typ] then
		table.insert(postFunctions[typ], func)
	end
end

KuiNameplates.RegisterModule = function(name, obj)
	if not modules[name] then
		modules[name] = obj
	end
end

------------------------------------------------------------- Frame functions --
-- set colour of health bar according to reaction/threat
local function SetHealthColour(self)
	if self.hasThreat then
		self.health.reset = true
		self.health:SetStatusBarColor(unpack(profile.tank.barcolour))
		return
	end

	local r, g, b = self.oldHealth:GetStatusBarColor()
	if self.health.reset  or
	   r ~= self.health.r or
	   g ~= self.health.g or
	   b ~= self.health.b
	then
		-- store the default colour
		self.health.r, self.health.g, self.health.b = r, g, b
		self.health.reset, self.friend, self.player = nil, nil, nil

		if g > .9 and r == 0 and b == 0 then
			-- friendly NPC
			self.friend = true
			r, g, b = unpack(ns.r[3])
		elseif b > .9 and r == 0 and g == 0 then
			-- friendly player
			self.friend = true
			self.player = true
			r, g, b = 0, .3, .6
		elseif r > .9 and g == 0 and b == 0 then
			-- enemy NPC
			r, g, b = unpack(ns.r[1])
		elseif (r + g) > 1.8 and b == 0 then
			-- neutral NPC
			r, g, b = unpack(ns.r[2])
		elseif b > .9 and (r+g) > 1.06 and (r+g) < 1.1 then
			-- tapped NPC
			if profile.hp.tapped then
				-- use grey...
				r, g, b = unpack(ns.r[4])
			else
				-- or don't change
				return
			end
		else
			-- enemy player, use default UI colour
			self.player = true
		end

		self.health:SetStatusBarColor(r, g, b)
	end
end

local function SetNameColour(self)
	if self.friend then
		self.name:SetTextColor(unpack(profile.text.friendlyname))
	else
		self.name:SetTextColor(unpack(profile.text.enemyname))
	end
end

local function SetGlowColour(self, r, g, b, a)
	if not r then
		-- set default colour
		r, g, b = 0, 0, 0
	end

	if not a then
		a = .85
	end

    self.bg:SetVertexColor(r, g, b, a)
end

local function StoreFrameGUID(self, guid)
	if not guid then return end
	if self.guid and loadedGUIDs[self.guid] then
		if self.guid ~= guid then
			-- the currently stored guid is incorrect
			loadedGUIDs[self.guid] = nil
		else
			return
		end
	end

	self.guid = guid
	loadedGUIDs[guid] = self

	if loadedNames[self.name.text] == self then
		loadedNames[self.name.text] = nil
	end
end

--------------------------------------------------------- Update combo points --
local function ComboPointsUpdate(self)
	if self.points and self.points > 0 then
		local size = (13 + ((18 - 13) / 5) * self.points)
		local blue = (1 - (1 / 5) * self.points)

		self:SetText(self.points)
		self:SetFont(font, size, 'OUTLINE')
		self:SetTextColor(1, 1, blue)
	elseif self:GetText() then
		self:SetText('')
	end
end

---------------------------------------------------- Update health bar & text --
local function OnHealthValueChanged(oldBar, curr)
	local frame	= oldBar:GetParent():GetParent()
	local min, max	= oldBar:GetMinMaxValues()
	local deficit,    big, sml, condition, display, pattern, rules
	    = max - curr, '',  ''

	frame.health:SetMinMaxValues(min, max)
	frame.health:SetValue(curr)
	
	-- select correct health display pattern
	if frame.friend then
		pattern = profile.hp.friendly
	else
		pattern = profile.hp.hostile
	end

	-- parse pattern into big/sml
	rules = { strsplit(';', pattern) }

	for k, rule in ipairs(rules) do
		condition, display = strsplit(':', rule)

		if condition == '<' then
			condition = curr < max
		elseif condition == '=' then
			condition = curr == max
		elseif condition == '<=' or condition == '=<' then
			condition = curr <= max
		else
			condition = nil
		end

		if condition then
			if display == 'd' then
				big = '-'..kui.num(deficit)
				sml = kui.num(curr)
			elseif display == 'm' then
				big = kui.num(max)
			elseif display == 'c' then
				big = kui.num(curr)
				sml = curr ~= max and kui.num(max)
			elseif display == 'p' then
				big = floor(curr / max * 100)
				sml = kui.num(curr)
			end

			break
		end
	end

	frame.health.p:SetText(big)

	if frame.health.mo then
		frame.health.mo:SetText(sml)
	end
end

------------------------------------------------------- Frame script handlers --
local function OnFrameShow(self)
	if self.carrier then
		self.carrier.DoShow = true
	end
	
	-- reset name
	self.name.text = self.oldName:GetText()
	self.name:SetText(self.name.text)

	if profile.hp.mouseover then
		-- force un-highlight
		self.highlighted = true
	end
	
	-- classifications
	if self.level.enabled then
		if self.boss:IsVisible() then
			self.level:SetText('??b')
			self.level:SetTextColor(1, 0, 0)
			self.level:Show()
		elseif self.state:IsVisible() then
			if self.state:GetTexture() == "Interface\\Tooltips\\EliteNameplateIcon"
			then
				self.level:SetText(self.level:GetText()..'+')
			else
				self.level:SetText(self.level:GetText()..'r')
			end
		end
	else
		self.level:Hide()
	end
	
	if self.state:IsVisible() then
		-- hide the elite/rare dragon
		self.state:Hide()
	end

	if profile.castbar.usenames and
		not loadedNames[self.name.text] and
		not self.guid
	then
		-- store this frame's name
		loadedNames[self.name.text] = self
	end
	
	---------------------------------------------- Trivial sizing/positioning --
	if self.firstChild:GetScale() < 1 then
		if not self.trivial then
			-- initialise trivial unit sizes
			if uiscale then
				self.parent:SetSize(self:GetWidth()/uiscale, self:GetHeight()/uiscale)
			end
			
			local w,h = self.parent:GetSize()
			local x,y = 
				floor((w / 2) - (sizes.twidth / 2)),
				floor((h / 2) - (sizes.theight / 2))
		
			self.health:ClearAllPoints()
			self.bg:ClearAllPoints()
			self.bg.fill:ClearAllPoints()
			self.name:ClearAllPoints()
			
			self.level:Hide()
			self.health.p:Hide()
			
			if self.health.mo then
				self.health.mo:Hide()
			end
			
			SetFontSize(self.name, fontSizes.small)
			self.name:SetJustifyH('CENTER')
			
			self.name:SetPoint('BOTTOM', self.health, 'TOP', 0, -3)
						
			self.bg.fill:SetSize(sizes.twidth, sizes.theight)
			self.health:SetSize(sizes.twidth-2, sizes.theight-2)
			
			self.health:SetPoint('BOTTOMLEFT', x+1, y+1)
			
			self.bg.fill:SetPoint('BOTTOMLEFT', x, y)
			
			self.bg:SetPoint('BOTTOMLEFT', x-(bgOffset-2), y-(bgOffset-2))
			self.bg:SetPoint('TOPRIGHT', self.parent, 'BOTTOMLEFT', x+sizes.twidth+(bgOffset-2), y+sizes.theight+(bgOffset-2))
		
			self.trivial = true
		else
			-- (performed each time a trivial frame is shown)
			self.level:Hide()
		end
	elseif self.trivial then
		-- return to normal sizes
		if uiscale then
			self.parent:SetSize(self:GetWidth()/uiscale, self:GetHeight()/uiscale)
		end
		
		local w,h = self.parent:GetSize()
		local x,y =
			floor((w / 2) - (sizes.width / 2)), 
			floor((h / 2) - (sizes.height / 2))
		
		self.health:ClearAllPoints()
		self.bg:ClearAllPoints()
		self.bg.fill:ClearAllPoints()
		self.name:ClearAllPoints()
			
		self.health.p:Show()	
		
		if self.health.mo then
			self.health.mo:Show()
		end
		
		SetFontSize(self.name, fontSizes.name)
		self.name:SetJustifyH('LEFT')
		self.name:SetPoint('RIGHT', self.health.p, 'LEFT')
		
		if self.level.enabled then
			self.name:SetPoint('LEFT', self.level, 'RIGHT', -2, 0)
			self.level:Show()
		else
			self.name:SetPoint('BOTTOMLEFT', self.health, 'TOPLEFT', 2, uiscale and -(2/uiscale) or -2)
		end
		
		self.bg.fill:SetSize(sizes.width, sizes.height)		
		self.health:SetSize(sizes.width - 2, sizes.height - 2)
		
		self.health:SetPoint('BOTTOMLEFT', x+1, y+1)
		
		self.bg.fill:SetPoint('BOTTOMLEFT', x, y)
		
		self.bg:SetPoint('BOTTOMLEFT', x-bgOffset, y-bgOffset)
		self.bg:SetPoint('TOPRIGHT', self.parent, 'BOTTOMLEFT', x+(sizes.width)+bgOffset, y+(sizes.height)+bgOffset)
		
		self.trivial = nil
	end

	self:UpdateFrame()
	self:UpdateFrameCritical()

	-- force health update
	OnHealthValueChanged(self.oldHealth, self.oldHealth:GetValue())
	
	self:SetGlowColour()
	
	CallPostFunction('show', self)
end

local function OnFrameHide(self)
	if self.carrier then
		self.carrier:Hide()
	end

	if self.guid then
		-- remove guid from the store and unset it
		loadedGUIDs[self.guid] = nil
		self.guid = nil

		if self.cp then
			self.cp.points = nil
			self.cp:Update()
		end
	end

	if loadedNames[self.name.text] == self then
		-- remove name from store
		-- if there are name duplicates, this will be recreated in an onupdate
		loadedNames[self.name.text] = nil
	end

	self.lastAlpha	= 0
	self.fadingTo	= nil
	self.hasThreat	= nil
	self.target		= nil

	-- unset stored health bar colours
	self.health.r, self.health.g, self.health.b, self.health.reset
		= nil, nil, nil, nil
		
	CallPostFunction('hide', self)
end

local function OnFrameEnter(self)
	self:StoreGUID(UnitGUID('mouseover'))

	if self.highlight then
		self.highlight:Show()
	end

	if profile.hp.mouseover then
		self.health.p:Show()
		if self.health.mo then self.health.mo:Show() end
	end
end

local function OnFrameLeave(self)
	if self.highlight then
		self.highlight:Hide()
	end

	if not self.target and profile.hp.mouseover then
		self.health.p:Hide()
		if self.health.mo then self.health.mo:Hide() end
	end
end

-- stuff that needs to be updated every frame
local function OnFrameUpdate(self, e)
	self.elapsed	= self.elapsed + e
	self.critElap	= self.critElap + e

	if self.carrier then
		------------------------------------------------------------ Position --
		local scale = self.firstChild:GetScale()
		local x, y = select(4, self.firstChild:GetPoint())
		x = (x / uiscale) * scale
		y = (y / uiscale) * scale
		
		self.carrier:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', floor(x-(self.carrier:GetWidth()/2)), floor(y))
		
		-- show the frame after it's been moved so it doesn't flash
		-- .DoShow is set OnFrameShow
		if self.carrier.DoShow then
			self.carrier:Show()
			self.carrier.DoShow = nil
		end
	end
	
	self.defaultAlpha = self:GetAlpha()
	------------------------------------------------------------------- Alpha --
	if (self.defaultAlpha == 1 and
	    targetExists)          or
	   (profile.fade.fademouse and
	    self.highlighted)
	then
		self.currentAlpha = 1
	elseif	targetExists or profile.fade.fadeall then
		self.currentAlpha = profile.fade.fadedalpha or .3
	else
		self.currentAlpha = 1
	end
	------------------------------------------------------------------ Fading --
	if profile.fade.smooth then
		-- track changes in the alpha level and intercept them
		if self.currentAlpha ~= self.lastAlpha then
			if not self.fadingTo or self.fadingTo ~= self.currentAlpha then
				if kui.frameIsFading(self) then
					kui.frameFadeRemoveFrame(self)
				end

				-- fade to the new value
				self.fadingTo 		= self.currentAlpha
				local alphaChange	= (self.fadingTo - (self.lastAlpha or 0))

				kui.frameFade(self.carrier and self.carrier or self, {
					mode		= alphaChange < 0 and 'OUT' or 'IN',
					timeToFade	= abs(alphaChange) * (profile.fade.fadespeed or .5),
					startAlpha	= self.lastAlpha or 0,
					endAlpha	= self.fadingTo,
					finishedFunc = function()
						self.fadingTo = nil
					end,
				})
			end

			self.lastAlpha = self.currentAlpha
		end
	else
		(self.carrier and self.carrier or self):SetAlpha(self.currentAlpha)
	end

	-- call delayed updates
	if self.elapsed > 1 then
		self.elapsed = 0
		self:UpdateFrame()
	end

	if self.critElap > .1 then
		self.critElap = 0
		self:UpdateFrameCritical()
	end
end

-- stuff that can be updated less often
local function UpdateFrame(self)
	if profile.castbar.usenames        and
	   not loadedNames[self.name.text] and
	   not self.guid
	then
		-- ensure a frame is still stored for this name, as name conflicts cause
		-- it to be erased when another might still exist
		-- also ensure that if this frame is targeted, this is the stored frame
		-- for its name
		loadedNames[self.name.text] = self
	end

	-- Health bar colour
	self:SetHealthColour()
	
	-- Name text colour
	self:SetNameColour()

	if self.cp then
		-- combo points
		self.cp:Update()
	end
end

-- stuff that needs to be updated often
local function UpdateFrameCritical(self)
	------------------------------------------------------------------ Threat --
	if self.glow:IsVisible() then
		self.glow.wasVisible = true

		-- set glow to the current default ui's colour
		self.glow.r, self.glow.g, self.glow.b = self.glow:GetVertexColor()
		self:SetGlowColour(self.glow.r, self.glow.g, self.glow.b)

		if not self.friend and profile.tank.enabled then
			-- in tank mode; is the default glow red (are we tanking)?
			self.hasThreat = (self.glow.g + self.glow.b) < .1

			if self.hasThreat then
				-- tanking; recolour bar & glow
				local r, g, b, a = unpack(profile.tank.glowcolour)
				self:SetGlowColour(r, g, b, a)
				self:SetHealthColour()
			end
		end
	elseif self.glow.wasVisible then
		self.glow.wasVisible = nil

		-- restore shadow glow colour
		self:SetGlowColour()

		if self.hasThreat then
			-- lost threat
			self.hasThreat = nil
			self:SetHealthColour()
		end
	end
	------------------------------------------------------------ Target stuff --
	if targetExists and
	   self.defaultAlpha == 1 and
	   self.name.text == UnitName('target')
	then
		-- this frame is targeted
		if not self.target then
			-- the frame just became targeted
			self.target = true
			self:StoreGUID(UnitGUID('target'))

			if self.carrier then
				-- move this frame above others
				-- default UI uses a level of 10 by default & 20 on the target
				self.carrier:SetFrameLevel(10)
			end

			if profile.hp.mouseover then
				self.health.p:Show()
				if self.health.mo then self.health.mo:Show() end
			end
			
			CallPostFunction('target', self)
		end
	elseif self.target then
		self.target = nil

		if self.carrier then
			self.carrier:SetFrameLevel(1)
		end

		if not self.highlighted and profile.hp.mouseover then
			self.health.p:Hide()
			if self.health.mo then self.health.mo:Hide() end
		end
	end
	--------------------------------------------------------------- Mouseover --
	if self.oldHighlight:IsShown() then
		if not self.highlighted then
			self.highlighted = true
			OnFrameEnter(self)
		end
	elseif self.highlighted then
		self.highlighted = false
		OnFrameLeave(self)
	end
	
	-- [debug]
	if _G['KuiNameplatesDebug'] then
		if self.guid and loadedGUIDs[self.guid] == self then
			self.guidtext:SetText(self.guid)
		else
			self.guidtext:SetText(nil)
		end

		if self.name.text and loadedNames[self.name.text] == self then
			self.nametext:SetText('Has name')
		else
			self.nametext:SetText(nil)
		end
		
		if self.friend then
			self.isfriend:SetText('friendly')
		else
			self.isfriend:SetText('not friendly')
		end
	end
end

--------------------------------------------------------------- KNP functions --
function ns.f:GetNameplate(guid, name)
	local gf, nf = loadedGUIDs[guid], loadedNames[name]

	if gf then
		return gf
	elseif nf then
		return nf
	else
		return nil
	end
end

function ns.f:IsNameplate(frame)
	if frame:GetName() and strfind(frame:GetName(), '^NamePlate%d') then
		local nameTextChild = select(2, frame:GetChildren())
		if nameTextChild then
			local nameTextRegion = nameTextChild:GetRegions()
			return (nameTextRegion and nameTextRegion:GetObjectType() == 'FontString')
		end
	end
end

function ns.f:InitFrame(frame)
	frame.init = true

	local overlayChild, nameTextChild = frame:GetChildren()
	local healthBar, castBar = overlayChild:GetChildren()
	
	local _, castbarOverlay, shieldedRegion, spellIconRegion
		= castBar:GetRegions()

	local nameTextRegion = nameTextChild:GetRegions()
    local
		glowRegion, overlayRegion, highlightRegion, levelTextRegion,
		bossIconRegion, raidIconRegion, stateIconRegion
		= overlayChild:GetRegions()

	highlightRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	glowRegion:SetTexture(nil)

	-- disable default cast bar
	castBar:SetParent(nil)
	castbarOverlay.Show = function() return end
	castBar:SetScript('OnShow', function() castBar:Hide() end)

	frame.firstChild = overlayChild
	
	frame.bg    = overlayRegion
	frame.glow  = glowRegion
	frame.boss  = bossIconRegion
	frame.state = stateIconRegion
	frame.level = levelTextRegion
	frame.icon  = raidIconRegion

	if profile.castbar.spellicon then
		frame.spell = spellIconRegion
	end

	frame.oldHealth = healthBar
	frame.oldHealth:Hide()

	frame.oldName = nameTextRegion
	frame.oldName:Hide()

	frame.oldHighlight = highlightRegion

    --------------------------------------------------------- Frame functions --
    frame.UpdateFrame			= UpdateFrame
    frame.UpdateFrameCritical	= UpdateFrameCritical
    frame.SetHealthColour   	= SetHealthColour
    frame.SetNameColour   	    = SetNameColour
    frame.SetGlowColour     	= SetGlowColour
	frame.StoreGUID				= StoreFrameGUID

    ------------------------------------------------------------------ Layout --
	local parent
	if profile.general.fixaa and uiscale then
		frame.carrier = CreateFrame('Frame', nil, WorldFrame)
		frame.carrier:SetFrameStrata('BACKGROUND')
		frame.carrier:SetSize(frame:GetWidth()/uiscale, frame:GetHeight()/uiscale)
		frame.carrier:SetScale(uiscale)
		
		frame.carrier:SetPoint('CENTER', UIParent)
		frame.carrier:Hide()
		
		-- [debug]
		if _G['KuiNameplatesDebug'] then
			frame.carrier:SetBackdrop({ bgFile = kui.m.t.solid })
			frame.carrier:SetBackdropColor(0,0,0,.5)
		end
		
		parent = frame.carrier
	else
		parent = frame
	end

	frame.parent = parent
	
	-- using CENTER breaks pixel-perfectness with oddly sized frames
	-- .. so we have to align frames manually.
	local w,h = parent:GetSize()
	local x,y

	x = floor((w / 2) - (sizes.width / 2))
	y = floor((h / 2) - (sizes.height / 2))

	-- border ------------------------------------------------------------------
	--frame.bg = (frame.carrier and frame.carrier or frame):CreateTexture(nil, 'BACKGROUND')
	frame.bg:SetParent(parent)
	frame.bg:SetTexture('Interface\\AddOns\\Kui_Nameplates\\FrameGlow')
	frame.bg:SetTexCoord(0, .469, 0, .625)
	frame.bg:SetVertexColor(0, 0, 0, .9)

	-- background
	frame.bg.fill = parent:CreateTexture(nil, 'BACKGROUND')
	frame.bg.fill:SetTexture(kui.m.t.solid)
	frame.bg.fill:SetVertexColor(0, 0, 0, .8)
	frame.bg.fill:SetDrawLayer('ARTWORK', 1) -- (1 sub-layer above .bg)

	frame.bg.fill:SetSize(sizes.width, sizes.height)
	frame.bg.fill:SetPoint('BOTTOMLEFT', x, y)

	frame.bg:ClearAllPoints()
	frame.bg:SetPoint('BOTTOMLEFT', x-bgOffset, y-bgOffset)
	frame.bg:SetPoint('TOPRIGHT', parent, 'BOTTOMLEFT', x+sizes.width+bgOffset, y+sizes.height+bgOffset)

	-- health bar --------------------------------------------------------------
	frame.health = CreateFrame('StatusBar', nil, parent)
	frame.health:SetStatusBarTexture(kui.m.t.bar)

	frame.health:ClearAllPoints()
	frame.health:SetSize(sizes.width-2, sizes.height-2)
	frame.health:SetPoint('BOTTOMLEFT', x+1, y+1)

	if ns.SetValueSmooth then
		-- smooth bar
		frame.health.OrigSetValue = frame.health.SetValue
		frame.health.SetValue = ns.SetValueSmooth
	end

	-- raid icon ---------------------------------------------------------------
	frame.icon:SetParent(parent)
	--frame.icon:SetSize(24, 24)

	frame.icon:ClearAllPoints()
	frame.icon:SetPoint('BOTTOM', parent, 'TOP', 0, -5)

	-- overlay (text is parented to this) --------------------------------------
	frame.overlay = CreateFrame('Frame', nil, parent)
	frame.overlay:SetAllPoints(frame.health)

	frame.overlay:SetFrameLevel(frame.health:GetFrameLevel()+1)

	-- highlight ---------------------------------------------------------------
	if profile.general.highlight then
		frame.highlight = frame.overlay:CreateTexture(nil, 'ARTWORK')
		frame.highlight:SetTexture(kui.m.t.bar)

		frame.highlight:SetAllPoints(frame.health)

		frame.highlight:SetVertexColor(1, 1, 1)
		frame.highlight:SetBlendMode('ADD')
		frame.highlight:SetAlpha(.4)
		frame.highlight:Hide()
	end

	-- health text -------------------------------------------------------------
	frame.health.p = kui.CreateFontString(frame.overlay, {
		font = font, size = fontSizes.large, outline = "OUTLINE" })
	frame.health.p:SetJustifyH('RIGHT')

	frame.health.p:SetPoint('BOTTOMRIGHT', frame.health, 'TOPRIGHT', -2, uiscale and -(3/uiscale) or -3)

	if profile.hp.showalt then
		frame.health.mo = kui.CreateFontString(frame.overlay, {
			font = font, size = fontSizes.small, outline = "OUTLINE" })
		frame.health.mo:SetJustifyH('RIGHT')

		frame.health.mo:SetPoint('BOTTOMRIGHT', frame.health, -2, uiscale and -(3/uiscale) or -3)
		frame.health.mo:SetAlpha(.6)
	end

	if profile.text.level then
		-- level text ----------------------------------------------------------
		frame.level = kui.CreateFontString(frame.level, { reset = true,
			font = font, size = fontSizes.name, outline = 'OUTLINE' })
		frame.level:SetParent(frame.overlay)

		frame.level:ClearAllPoints()
		frame.level:SetPoint('BOTTOMLEFT', frame.health, 'TOPLEFT', 2, uiscale and -(2/uiscale) or -2)
		frame.level.enabled = true
	else
		frame.level:Hide()
	end

	-- name text ---------------------------------------------------------------
	frame.name = kui.CreateFontString(frame.overlay, {
		font = font, size = fontSizes.name, outline = 'OUTLINE' })
	frame.name:SetJustifyH('LEFT')

	frame.name:SetHeight(13)

	if frame.level.enabled then
		frame.name:SetPoint('LEFT', frame.level, 'RIGHT', -2, 0)
	else
		frame.name:SetPoint('BOTTOMLEFT', frame.health, 'TOPLEFT', 2, uiscale and -(2/uiscale) or -2)
	end
		
	frame.name:SetPoint('RIGHT', frame.health.p, 'LEFT')

	-- combo point text --------------------------------------------------------
	if profile.general.combopoints then
		frame.cp = kui.CreateFontString(frame.health,
			{ font = font, size = fontSizes.combopoints, outline = 'OUTLINE', shadow = true })
		frame.cp:SetPoint('LEFT', frame.health, 'RIGHT', 5, 1)

		frame.cp.Update = ComboPointsUpdate
	end

    ----------------------------------------------------------------- Scripts --
	frame:SetScript('OnShow', OnFrameShow)
	frame:SetScript('OnHide', OnFrameHide)
    frame:SetScript('OnUpdate', OnFrameUpdate)

	frame.oldHealth:SetScript('OnValueChanged', OnHealthValueChanged)

	-- [debug]
	if _G['KuiNameplatesDebug'] then
		frame:SetBackdrop({bgFile=kui.m.t.solid})
		frame:SetBackdropColor(1, 1, 1, .5)

		frame.isfriend = kui.CreateFontString(frame, {
			font = font, size = 10, outline = 'OUTLINE' })
		frame.isfriend:SetPoint('BOTTOM', frame, 'TOP')
		
		frame.guidtext = kui.CreateFontString(frame, {
			font = font, size = 10, outline = "OUTLINE" })
		frame.guidtext:SetPoint('TOP', frame, 'BOTTOM')

		frame.nametext = kui.CreateFontString(frame, {
			font = font, size = 10, outline = "OUTLINE" })
		frame.nametext:SetPoint('TOP', frame.guidtext, 'BOTTOM')
	end

	------------------------------------------------------------ Finishing up --
	--frame.UpdateScales = UpdateScales

    frame.elapsed	= 0
	frame.critElap	= 0

	CallPostFunction('create', frame)
	
	-- force OnShow
	OnFrameShow(frame)
end

---------------------------------------------------------------------- Events --
function ns.f:UNIT_COMBO_POINTS()
	local target = UnitGUID('target')
	if not target or not loadedGUIDs[target] then return end
	target = loadedGUIDs[target]

	if target.cp then
		target.cp.points = GetComboPoints('player', 'target')
		target.cp:Update()
	end

	-- clear points on other frames
	for guid, frame in pairs(loadedGUIDs) do
		if frame.cp and guid ~= target.guid then
			frame.cp.points = nil
			frame.cp:Update()
		end
	end
end

function ns.f:PLAYER_TARGET_CHANGED()
	targetExists = UnitExists('target')
end

-- automatic toggling of enemy frames
function ns.f:PLAYER_REGEN_ENABLED()
	SetCVar('nameplateShowEnemies', 0)
end
function ns.f:PLAYER_REGEN_DISABLED()
	SetCVar('nameplateShowEnemies', 1)
end

------------------------------------------------------------- Script handlers --
ns.frames = 0

do
	local WorldFrame, lastUpdate
		= WorldFrame, 1

	function ns.OnUpdate(self, elapsed)
		lastUpdate     = lastUpdate + elapsed

		if lastUpdate >= .1 then
			lastUpdate = 0

			local frames = select('#', WorldFrame:GetChildren())

			if frames ~= ns.frames then
				local i, f

				for i = 1, frames do
					f = select(i, WorldFrame:GetChildren())
					if self:IsNameplate(f) and not f.init then
						self:InitFrame(f)
					end
				end

				ns.frames = frames
			end
		end
	end
end

function ns.OnEvent(self, event, ...)
    self[event](self, ...)
end

function ns.ToggleCombatEvents(io)
	if io then
		ns.f:RegisterEvent('PLAYER_REGEN_ENABLED')
		ns.f:RegisterEvent('PLAYER_REGEN_DISABLED')
	else
		ns.f:UnregisterEvent('PLAYER_REGEN_ENABLED')
		ns.f:UnregisterEvent('PLAYER_REGEN_DISABLED')
	end
end

function ns.ToggleComboPoints(io)
	if io then
		ns.f:RegisterEvent('UNIT_COMBO_POINTS')
	else
		ns.f:UnregisterEvent('UNIT_COMBO_POINTS')
	end
end

-------------------------------------------------- Listen for profile changes --
function ns:ProfileChanged()
	profile = self.db.profile
end

-------------------------------------------------------------------- Finalise --
function ns:OnEnable()
	profile = self.db.profile
	KuiNameplates.profile = profile

	KuiNameplates.sizes, KuiNameplates.fontSizes = {
		-- frame
		width  = 110,
		height = 11,
        twidth = 55,
        theight= 7,
		-- cast bar stuff
		cbheight = 14,
		icon = 16,
	}, {
		combopoints = 13,
		large = 10,
		spellname = 9,
		name  = 9,
		small = 8,
	}
    
	sizes, fontSizes = KuiNameplates.sizes, KuiNameplates.fontSizes
    
	for k,size in pairs(fontSizes) do
		fontSizes[k] = size * profile.general.fontscale
	end

	if profile.general.fixaa then
		uiscale,                      origSizes, origFontSizes =
		UIParent:GetEffectiveScale(), sizes,     fontSizes

		bgOffset = 5
		origSizes.cbheight = 12

		-- scale sizes up to "unscaled" values
		for k,size in pairs(origSizes) do
			sizes[k] = floor(size/uiscale)
		end

		for k,size in pairs(origFontSizes) do
			fontSizes[k] = size/uiscale
		end
	end
	
	-- fetch font path from lsm
	KuiNameplates.font = LSM:Fetch(LSM.MediaType.FONT, profile.general.font)
    font = KuiNameplates.font
    
	-------------------------------------- Health bar smooth update functions --
	-- (spoon-fed by oUF_Smooth)
	if profile.hp.smooth then
		local f,                    smoothing, GetFramerate, min,      max,      abs
			= CreateFrame('Frame'), {},        GetFramerate, math.min, math.max, math.abs

		function ns.SetValueSmooth(self, value)
			local _, maxv = self:GetMinMaxValues()

			if value == self:GetValue() or (self.prevMax and self.prevMax ~= maxv) then
				-- finished smoothing/max health updated
				smoothing[self] = nil
				self:OrigSetValue(value)
			else
				smoothing[self] = value
			end

			self.prevMax = maxv
		end

		f:SetScript('OnUpdate', function()
			local limit = 30/GetFramerate()
			
			for bar, value in pairs(smoothing) do
				local cur = bar:GetValue()
				local new = cur + min((value-cur)/3, max(value-cur, limit))

				if new ~= new then
					new = value
				end

				bar:OrigSetValue(new)

				if cur == value or abs(new - value) < 2 then
					bar:OrigSetValue(value)
					smoothing[bar] = nil
				end
			end
		end)
	end

	-- enable packed modules
	if profile.castbar.enabled and modules.castbar then
		modules.castbar:Enable()
	end
    if profile.castbar.warnings and modules.warnings then
        modules.warnings:Enable()
    end
	
	ns.f:SetScript('OnUpdate', self.OnUpdate)
	ns.f:SetScript('OnEvent', self.OnEvent)

	ns.f:RegisterEvent('PLAYER_TARGET_CHANGED')
	
	self.ToggleCombatEvents(profile.general.combat)
	self.ToggleComboPoints(profile.general.combopoints)
end
