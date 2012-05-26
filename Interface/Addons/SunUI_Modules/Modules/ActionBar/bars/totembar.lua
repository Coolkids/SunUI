local S, C, L, DB = unpack(SunUI)
 
if DB.MyClass ~= "SHAMAN" then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("TotemBar", "AceEvent-3.0")
function Module:OnInitialize()
	C = C["ActionBarDB"]
	local bar = CreateFrame("Frame","SunUITotemBar",UIParent,"SecureHandlerStateTemplate")
	bar:SetSize(C["ButtonSize"]*7+5*5,C["ButtonSize"]+3)
	bar:SetScale(C["TotemBarSacle"])
	MoveHandle.SunUITotemBar = S.MakeMove(bar, "SunUI图腾栏", "totembar", C["TotemBarSacle"])
	if MultiCastActionBarFrame then
		MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		MultiCastActionBarFrame:SetScript("OnShow", nil)
		MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:SetParent(bar)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT")

		hooksecurefunc("MultiCastActionButton_Update",function(actionbutton) if not InCombatLockdown() then actionbutton:SetAllPoints(actionbutton.slotButton) end end)
	
		MultiCastActionBarFrame.SetParent = function() end
		MultiCastActionBarFrame.SetPoint = function() end
		MultiCastRecallSpellButton.SetPoint = function() end -- bug fix, see http://www.tukui.org/v2/forums/topic.php?id=2405
end

-- Tex Coords for empty buttons
	local SLOT_EMPTY_TCOORDS = {
		[EARTH_TOTEM_SLOT] = {
			left	= 66 / 128,
			right	= 96 / 128,
			top		= 3 / 256,
			bottom	= 32 / 256,
		},
		[FIRE_TOTEM_SLOT] = {
			left	= 68 / 128,
			right	= 97 / 128,
			top		= 100 / 256,
			bottom	= 129 / 256,
		},
		[WATER_TOTEM_SLOT] = {
			left	= 39 / 128,
			right	= 69 / 128,
			top		= 209 / 256,
			bottom	= 238 / 256,
		},
		[AIR_TOTEM_SLOT] = {
			left	= 66 / 128,
			right	= 96 / 128,
			top		= 36 / 256,
			bottom	= 66 / 256,
		},
	}

-- the color we use for border
	local bordercolors = {
		{0.741,0.580,0.04},   -- Earth
		{0.752,0.172,0.02},   -- Fire
		{0,0.443,0.631},   -- Water
		{0.6,1,0.945},   -- Air
	}

	local function StyleTotemFlyout(flyout)
		-- remove blizzard flyout texture
		flyout.top:SetTexture(nil)
		flyout.middle:SetTexture(nil)
		flyout:SetFrameStrata('MEDIUM')
		
		-- Skin buttons
		local last = nil
		
		for _,button in ipairs(flyout.buttons) do
			button:CreateShadow("Background")
			button.shadow:SetBackdropColor(0, 0, 0)
			local icon = select(1,button:GetRegions())
			icon:SetTexCoord(.09,.91,.09,.91)
			icon:SetDrawLayer("ARTWORK")
			icon:Point("TOPLEFT", 2, -2)
			icon:Point("BOTTOMRIGHT", -2, 2)
			if not InCombatLockdown() then
				button:ClearAllPoints()
				button:Point("BOTTOM",last,"TOP",0,2)
			end
			if button:IsVisible() then last = button end
			button:CreateBorder(flyout.parent:GetBackdropBorderColor())
			button:StyleButton(true)
		end
		
		flyout.buttons[1]:SetPoint("BOTTOM",flyout,"BOTTOM")
		
		if flyout.type == "slot" then
			local tcoords = SLOT_EMPTY_TCOORDS[flyout.parent:GetID()]
			flyout.buttons[1].icon:SetTexCoord(tcoords.left,tcoords.right,tcoords.top,tcoords.bottom)
		end
		
		-- Skin Close button
		local close = MultiCastFlyoutFrameCloseButton
		close:CreateShadow("Background")	
		close:GetHighlightTexture():SetTexture([[Interface\Buttons\ButtonHilight-Square]])
		close:GetHighlightTexture():Point("TOPLEFT",close,"TOPLEFT",1,-1)
		close:GetHighlightTexture():Point("BOTTOMRIGHT",close,"BOTTOMRIGHT",-1,1)
		close:GetNormalTexture():SetTexture(nil)
		close:ClearAllPoints()
		close:Point("BOTTOMLEFT",last,"TOPLEFT",0,4)
		close:Point("BOTTOMRIGHT",last,"TOPRIGHT",0,4)
		close:CreateBorder(last:GetBackdropBorderColor())
		close:SetHeight(8)
		
		flyout:ClearAllPoints()
		flyout:Point("BOTTOM",flyout.parent,"TOP",0,4)
	end
	hooksecurefunc("MultiCastFlyoutFrame_ToggleFlyout",function(self) StyleTotemFlyout(self) end)
		
	local function StyleTotemOpenButton(button, parent)
		button:GetHighlightTexture():SetAlpha(0)
		button:GetNormalTexture():SetAlpha(0)
		button:SetHeight(20)
		button:ClearAllPoints()
		button:Point("BOTTOMLEFT", parent, "TOPLEFT", 0, -3)
		button:Point("BOTTOMRIGHT", parent, "TOPRIGHT", 0, -3)
		if not button.visibleBut then
			button.visibleBut = CreateFrame("Frame",nil,button)
			button.visibleBut:SetHeight(8)
			button.visibleBut:SetWidth(C["ButtonSize"])
			button.visibleBut:SetPoint("CENTER")
			button.visibleBut.highlight = button.visibleBut:CreateTexture(nil,"HIGHLIGHT")
			button.visibleBut.highlight:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
			button.visibleBut.highlight:Point("TOPLEFT",button.visibleBut,"TOPLEFT",1,-1)
			button.visibleBut.highlight:Point("BOTTOMRIGHT",button.visibleBut,"BOTTOMRIGHT",-1,1)
			button.visibleBut:CreateShadow("Background")
		end
		button.visibleBut:CreateBorder(parent:GetBackdropBorderColor())
	end
	hooksecurefunc("MultiCastFlyoutFrameOpenButton_Show",function(button,_, parent) StyleTotemOpenButton(button, parent) end)

	local function StyleTotemSlotButton(button, index)
		button:CreateShadow("Background")
		button.shadow:SetBackdropColor(0, 0, 0)
		button.overlayTex:SetTexture(nil)
		button.background:SetDrawLayer("ARTWORK")
		button.background:ClearAllPoints()
		button.background:Point("TOPLEFT",button,"TOPLEFT",2, -2)
		button.background:Point("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2, 2)
		-- button.background:SetAllPoints()
		if not InCombatLockdown() then button:SetSize(C["ButtonSize"], C["ButtonSize"]) end
		button:CreateBorder(unpack(bordercolors[((index-1) % 4) + 1]))
		button:StyleButton(true)
		end
		hooksecurefunc("MultiCastSlotButton_Update",function(self, slot) StyleTotemSlotButton(self,tonumber( string.match(self:GetName(),"MultiCastSlotButton(%d)"))) end)

-- Skin the actual totem buttons
	local function StyleTotemActionButton(button, index)
		local icon = select(1,button:GetRegions())
		icon:SetTexCoord(.09,.91,.09,.91)
		icon:SetDrawLayer("ARTWORK")
		icon:Point("TOPLEFT",button,"TOPLEFT",2,-2)
		icon:Point("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)
		button.overlayTex:SetTexture(nil)
		button.overlayTex:Hide()
		button:GetNormalTexture():SetAlpha(0)
		if button.slotButton and not InCombatLockdown() then
			button:ClearAllPoints()
			button:SetAllPoints(button.slotButton)
			button:SetFrameLevel(button.slotButton:GetFrameLevel()+1)
		end
		button:CreateBorder(unpack(bordercolors[((index-1) % 4) + 1]))
		button:SetBackdropColor(0,0,0,0)
		button:StyleButton(true)
	end
	hooksecurefunc("MultiCastActionButton_Update",function(actionButton, actionId, actionIndex, slot) StyleTotemActionButton(actionButton,actionIndex) end)

	local function FixBackdrop(button)
		if button:GetName() and button:GetName():find("MultiCast") and button:GetNormalTexture() then
		button:GetNormalTexture():SetAlpha(0)
		end
	end
	hooksecurefunc("ActionButton_ShowGrid", FixBackdrop)

-- Skin the summon and recall buttons
	local function StyleTotemSpellButton(button, index)
		if not button then return end
		local icon = select(1,button:GetRegions())
		icon:SetTexCoord(.09,.91,.09,.91)
		icon:SetDrawLayer("ARTWORK")
		icon:SetAllPoints()
		button:CreateShadow("Background")
		button.shadow:SetBackdropColor(0, 0, 0)
		button:GetNormalTexture():SetTexture(nil)
		if not InCombatLockdown() then button:SetSize(C["ButtonSize"],C["ButtonSize"]) end
		_G[button:GetName().."Highlight"]:SetTexture(nil)
		_G[button:GetName().."NormalTexture"]:SetTexture(nil)
		button:StyleButton(true)
	end
	hooksecurefunc("MultiCastSummonSpellButton_Update", function(self) StyleTotemSpellButton(self,0) end)
	hooksecurefunc("MultiCastRecallSpellButton_Update", function(self) StyleTotemSpellButton(self,5) end)
	--shift 右键取消图腾
	local destroyers = { }
    local totemSlot  = { 2, 1, 3, 4 }

    local function Button_OnClick(self, button)
		DestroyTotem(self.slot)
    end

    local function Button_OnEvent(self, event, key)
		if key ~= "LSHIFT" and key ~= "RSHIFT" then return end

		local _, _, start, duration = GetTotemInfo(self.slot)

		if IsShiftKeyDown() and duration > 0 then
			self:Show()
			self:SetAlpha(ImprovedTotemFrameDB and ImprovedTotemFrameDB.dA or 0.5)
		else
			self:Hide()
		end
    end

    for i = 1, #totemSlot do
		local mcab = _G["MultiCastActionButton" .. i]

		local b = CreateFrame("Button", nil, UIParent)
		b:SetFrameStrata(mcab:GetFrameStrata())
		b:SetFrameLevel(mcab:GetFrameLevel() + 3)
		b:SetPoint("TOPLEFT", mcab, -1, 1)
		b:SetPoint("BOTTOMRIGHT", mcab, 1, -1)

		b:CreateShadow()

		b:Hide()
		b:RegisterEvent("MODIFIER_STATE_CHANGED")
		b:SetScript("OnEvent", Button_OnEvent)

		b:RegisterForClicks("RightButtonUp")
		b:SetScript("OnClick", Button_OnClick)

		b.id = i
		b.slot = totemSlot[i]

		destroyers[b.slot] = b
		mcab.destroyer = b
    end
	--图腾时间
	local totemSlot = { 2, 1, 3, 4 }

    local function OnEvent(self, event, slot)
		if event == "PLAYER_ENTERING_WORLD" then
			slot = self.slot
		elseif slot ~= self.slot then
			return
		end
		local _, _, start, duration = GetTotemInfo(slot)
		if duration > 0 then
			self.start = start
			self.duration = duration
			self:Show()
		else
			self:Hide()
		end
    end

    local function OnHide(self)
		self.start = nil
		self.duration = nil
    end

    local function OnShow(self)
		if not self.start or not self.duration then return self:Hide() end
		self.elapsed = 1000
    end

    --format time func
    local GetFormattedTime = function(time)
		local hr, m, s, text
		if time <= 0 then text = ""
		elseif(time < 3600 and time > 60) then
			hr = floor(time / 3600)
			m = floor(mod(time, 3600) / 60 + 1)
			text = format("%dm", m)
		elseif time < 60 then
			m = floor(time / 60)
			s = mod(time, 60)
			text = (m == 0 and format("%ds", s))
		else
			hr = floor(time / 3600 + 1)
			text = format("%dh", hr)
		end
		return text
	end

    local function OnUpdate(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > 0.33 then
			local timeLeft = self.start + self.duration - GetTime()
			if timeLeft > 0 then
				self.text:SetText(GetFormattedTime(timeLeft))
				self.elapsed = 0
			else
				self.text:SetText()
				self:Hide()
			end
		end
    end

    for i = 1, #totemSlot do
		local button = _G["MultiCastSlotButton"..i]
		local timerFrame = CreateFrame("Frame", nil, button)
		button.timerFrame = timerFrame
		timerFrame:SetAllPoints(button)
		timerFrame:Hide()
		timerFrame.text = timerFrame:CreateFontString(nil, "OVERLAY")
		timerFrame.text:SetPoint("CENTER", 1, 0)
		timerFrame.text:SetFont(STANDARD_TEXT_FONT, button:GetWidth()*16/36, "THINOUTLINE")
		timerFrame.text:SetShadowOffset(1,-2)
		timerFrame.text:SetShadowColor(0,0,0,0.6)
		timerFrame.text:SetJustifyH("CENTER")
		timerFrame.id = i
		timerFrame.slot = totemSlot[i]
		timerFrame:SetScript("OnEvent", OnEvent)
		timerFrame:SetScript("OnHide", OnHide)
		timerFrame:SetScript("OnShow", OnShow)
		timerFrame:SetScript("OnUpdate", OnUpdate)
		timerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		timerFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
		OnEvent(timerFrame, "PLAYER_TOTEM_UPDATE", timerFrame.slot)
    end
end