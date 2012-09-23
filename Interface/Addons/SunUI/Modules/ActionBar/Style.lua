local S, C, L, DB, _ = unpack(select(2, ...))
 if (IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("Macaroon")) then
	return 
end	
local AB = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("ActionStyle", "AceEvent-3.0")
local _G = _G
local function UpdateHotkey(button, actionButtonType)
	local hotkey = _G[button:GetName() .. 'HotKey']
	local text = hotkey:GetText()
	if text == nil then return end
	text = string.gsub(text, '(s%-)', 'S')
	text = string.gsub(text, '(a%-)', 'A')
	text = string.gsub(text, '(c%-)', 'C')
	text = string.gsub(text, '(Mouse Button )', 'M')
	text = string.gsub(text, '(滑鼠按鍵)', 'M')
	text = string.gsub(text, '(鼠标按键)', 'M')
	text = string.gsub(text, KEY_BUTTON3, 'M3')
	text = string.gsub(text, '(Num Pad )', 'N')
	text = string.gsub(text, KEY_PAGEUP, 'PU')
	text = string.gsub(text, KEY_PAGEDOWN, 'PD')
	text = string.gsub(text, KEY_SPACE, 'SpB')
	text = string.gsub(text, KEY_INSERT, 'Ins')
	text = string.gsub(text, KEY_HOME, 'Hm')
	text = string.gsub(text, KEY_DELETE, 'Del')
	text = string.gsub(text, KEY_MOUSEWHEELUP, 'MwU')
	text = string.gsub(text, KEY_MOUSEWHEELDOWN, 'MwD')
	text = string.gsub(text, '(數字鍵盤)', 'N')

	if hotkey:GetText() == _G['RANGE_INDICATOR'] then
		hotkey:SetText('')
	else
		hotkey:SetText(text)
	end
end
local function Style(button, totem, flyout)
	local name = button:GetName()
	if name:match("MultiCast") then return end

	local action = button.action
		
	if button.s == true then return end
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal = _G[name.."NormalTexture"]
	local normal2 = button:GetNormalTexture()
	local cooldown = _G[name .. "Cooldown"]
		 
	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:SetAllPoints(button)
	end

	if Flash then Flash:SetTexture(nil) end
	if normal then normal:SetTexture(nil) end
	if normal2 then normal2:SetTexture(nil) end
	--if Border then Border:Kill() end
	if Border then
		Border:ClearAllPoints()
		Border:SetPoint("TOPLEFT", -12, 12)
		Border:SetPoint("BOTTOMRIGHT", 12, -12)
	end

	if Count then
		Count:ClearAllPoints()
		Count:SetJustifyH("RIGHT")
		Count:SetPoint("BOTTOMRIGHT", 3, 0)
		Count:SetFont(DB.Font, C["ActionBarDB"]["FontSize"], "OUTLINE")
	end

	if _G[name..'FloatingBG'] then
		_G[name..'FloatingBG']:Kill()
	end

		

	if Btname then	
		Btname:SetJustifyH("CENTER")
		Btname:SetPoint("BOTTOMLEFT", -3, 1)
		Btname:SetFont(DB.Font, C["ActionBarDB"]["MFontSize"], "OUTLINE")
		if C["ActionBarDB"]["HideMacroName"] then
				Btname:SetText("")
				Btname:Hide()
				Btname.Show = function() end
		end
	end

	if not button.shadow then
		if not totem then
			if not flyout then
				button:SetSize(C["ActionBarDB"]["ButtonSize"], C["ActionBarDB"]["ButtonSize"])
			end
			 
			button:CreateShadow("Background")
		end

		if Icon then
			Icon:SetTexCoord(.08, .92, .08, .92)
			Icon:SetAllPoints()
		end
	end

	if HotKey then
		HotKey:ClearAllPoints()
		HotKey:SetJustifyH("RIGHT")
		HotKey:SetPoint("TOPRIGHT", 4, 1)
		HotKey:SetFont(DB.Font, C["ActionBarDB"]["FontSize"], "OUTLINE")
		HotKey:SetShadowColor(0, 0, 0, 1)
		HotKey.ClearAllPoints = function() end
		HotKey.SetPoint = function() end
		if C["ActionBarDB"]["HideHotKey"] then
			HotKey:SetText("")
			HotKey:Hide()
			HotKey.Show = function() end
		end
	end

	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end

	button:StyleButton(true)
	button.s = true
end

local function StyleSmallButton(normal, button, icon, name, pet)
	if button.shadow then return end

	local Flash = _G[name.."Flash"]

	button:SetNormalTexture("")
	button.SetNormalTexture = function() end
	button:StyleButton(true)

	Flash:SetTexture(1, 1, 1, 0.3)

	if not button.shadow then
		button:CreateShadow("Background")
	end

	icon:SetTexCoord(.08, .92, .08, .92)
	icon:ClearAllPoints()
	if pet then
		if C["ActionBarDB"]["ButtonSize"]*C["ActionBarDB"]["PetBarSacle"] < 30 then
			local autocast = _G[name.."AutoCastable"]
			autocast:SetAlpha(0)
		end
		local shine = _G[name.."Shine"]
		shine:Size(C["ActionBarDB"]["ButtonSize"]*C["ActionBarDB"]["PetBarSacle"])
		shine:ClearAllPoints()
		shine:SetPoint("CENTER", button, 0, 0)
		icon:SetAllPoints()
		else
			icon:SetAllPoints()
		end

		if normal then
			normal:ClearAllPoints()
			normal:SetPoint("TOPLEFT")
			normal:SetPoint("BOTTOMRIGHT")
		end
	end

local function StyleShift()
	for i=1, NUM_SHAPESHIFT_SLOTS do
		local name = "ShapeshiftButton"..i
		local button = _G[name]
		local icon = _G[name.."Icon"]
		local normal = _G[name.."NormalTexture"]
		StyleSmallButton(normal, button, icon, name)
	end
end

local function StylePet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button = _G[name]
		local icon = _G[name.."Icon"]
		local normal = _G[name.."NormalTexture2"]
		StyleSmallButton(normal, button, icon, name, true)
	end
end

local buttons = 0
local function SetupFlyoutButton()
	for i=1, buttons do
		if _G["SpellFlyoutButton"..i] then
			Style(_G["SpellFlyoutButton"..i])
			_G["SpellFlyoutButton"..i]:StyleButton(true)
		end
	end
end
SpellFlyout:HookScript("OnShow", SetupFlyoutButton)

local function StyleFlyout(button)
	if not button.FlyoutBorder then return end
	button.FlyoutBorder:SetAlpha(0)
	button.FlyoutBorderShadow:SetAlpha(0)

	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)

	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end

	--Change arrow direction depending on what bar the button is on
	local arrowDistance
	if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == button) or GetMouseFocus() == button) then
		arrowDistance = 5
	else
		arrowDistance = 2
	end

	if button:GetParent() and button:GetParent():GetParent() and button:GetParent():GetParent():GetName() and button:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then
		return
	end

	if button:GetAttribute("flyoutDirection") ~= nil then
		local point, _, _, _, _ = button:GetPoint()
		if point then 
			if strfind(point, "TOP") then
				button.FlyoutArrow:ClearAllPoints()
				button.FlyoutArrow:SetPoint("LEFT", button, "LEFT", -arrowDistance, 0)
				SetClampedTextureRotation(button.FlyoutArrow, 270)
				if not InCombatLockdown() then button:SetAttribute("flyoutDirection", "LEFT") end
			else
				button.FlyoutArrow:ClearAllPoints()
				button.FlyoutArrow:SetPoint("TOP", button, "TOP", 0, arrowDistance)
				SetClampedTextureRotation(button.FlyoutArrow, 0)
				if not InCombatLockdown() then button:SetAttribute("flyoutDirection", "UP") end
			end
		end
	end
end

local function UpdateOverlayGlow(button)
	if button.overlay and button.shadow then
		button.overlay:SetParent(button)
		button.overlay:ClearAllPoints()
		button.overlay:SetAllPoints(button.shadow)
		button.overlay.ants:ClearAllPoints()
		button.overlay.ants:Point("TOPLEFT", button.shadow, "TOPLEFT", -2, 2)
		button.overlay.ants:Point("BOTTOMRIGHT", button.shadow, "BOTTOMRIGHT", 2, -2)
		button.overlay.outerGlow:Point("TOPLEFT", button.shadow, "TOPLEFT", -2, 2)
		button.overlay.outerGlow:Point("BOTTOMRIGHT", button.shadow, "BOTTOMRIGHT", 2, -2)
	end
end
local function styleExtraActionButton(bu)
    if not bu or (bu and bu.sun_styled) then return end
    local name = bu:GetName()
 
	local normal = _G[name.."NormalTexture"]

	if normal then normal:SetTexture(nil) end
	bu.icon:SetTexCoord(.08, .92, .08, .92)
	bu.icon:SetAllPoints()
    bu.cooldown:SetAllPoints(bu)
	bu:StyleButton(true)
    bu.sun_styled = true
end
local function init()
    --style the actionbar buttons
    for i = 1, NUM_ACTIONBAR_BUTTONS do
      Style(_G["ActionButton"..i])
      Style(_G["MultiBarBottomLeftButton"..i])
      Style(_G["MultiBarBottomRightButton"..i])
      Style(_G["MultiBarRightButton"..i])
      Style(_G["MultiBarLeftButton"..i])
    end
    for i = 1, 6 do
      Style(_G["OverrideActionBarButton"..i])
    end
    --petbar buttons
    for i=1, NUM_PET_ACTION_SLOTS do
      StylePet(_G["PetActionButton"..i])
    end
    --stancebar buttons
    for i=1, NUM_STANCE_SLOTS do
      Style(_G["StanceButton"..i])
    end
    --possess buttons
    for i=1, NUM_POSSESS_SLOTS do
      Style(_G["PossessButton"..i])
    end
    --extraactionbutton1
    styleExtraActionButton(ExtraActionButton1)
end

	
function AB:OnEnable()
	init()
	hooksecurefunc("ActionButton_ShowOverlayGlow", UpdateOverlayGlow)
	hooksecurefunc("ActionButton_Update", UpdateHotkey)
	hooksecurefunc("ActionButton_UpdateHotkeys", UpdateHotkey)
	hooksecurefunc("ActionButton_UpdateFlyout", StyleFlyout)
end