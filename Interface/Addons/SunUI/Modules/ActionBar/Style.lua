local S, L, DB, _, C = unpack(select(2, ...))
--if true then return end
local AB = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("ActionStyle", "AceEvent-3.0", "AceHook-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
function AB:GetScreenQuadrant(frame)
	local x, y = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local screenHeight = GetScreenHeight()
	local point

	if not frame:GetCenter() then
		return "UNKNOWN", frame:GetName()
	end

	if (x > (screenWidth / 4) and x < (screenWidth / 4)*3) and y > (screenHeight / 4)*3 then
		point = "TOP"
	elseif x < (screenWidth / 4) and y > (screenHeight / 4)*3 then
		point = "TOPLEFT"
	elseif x > (screenWidth / 4)*3 and y > (screenHeight / 4)*3 then
		point = "TOPRIGHT"
	elseif (x > (screenWidth / 4) and x < (screenWidth / 4)*3) and y < (screenHeight / 4) then
		point = "BOTTOM"
	elseif x < (screenWidth / 4) and y < (screenHeight / 4) then
		point = "BOTTOMLEFT"
	elseif x > (screenWidth / 4)*3 and y < (screenHeight / 4) then
		point = "BOTTOMRIGHT"
	elseif x < (screenWidth / 4) and (y > (screenHeight / 4) and y < (screenHeight / 4)*3) then
		point = "LEFT"
	elseif x > (screenWidth / 4)*3 and y < (screenHeight / 4)*3 and y > (screenHeight / 4) then
		point = "RIGHT"
	else
		point = "CENTER"
	end

	return point
end

function AB:UpdateHotkey(button, actionButtonType)
	local hotkey = _G[button:GetName() .. "HotKey"]
	local text = hotkey:GetText()

	text = string.gsub(text, "(s%-)", "S")
	text = string.gsub(text, "(a%-)", "A")
	text = string.gsub(text, "(c%-)", "C")
	text = string.gsub(text, "(Mouse Button )", "M")
	text = string.gsub(text, "(滑鼠按鍵)", "M")
	text = string.gsub(text, "(鼠标按键)", "M")
	text = string.gsub(text, KEY_BUTTON3, "M3")
	text = string.gsub(text, "(Num Pad )", "N")
	text = string.gsub(text, KEY_PAGEUP, "PU")
	text = string.gsub(text, KEY_PAGEDOWN, "PD")
	text = string.gsub(text, KEY_SPACE, "SpB")
	text = string.gsub(text, KEY_INSERT, "Ins")
	text = string.gsub(text, KEY_HOME, "Hm")
	text = string.gsub(text, KEY_DELETE, "Del")
	text = string.gsub(text, KEY_MOUSEWHEELUP, "M+")
	text = string.gsub(text, KEY_MOUSEWHEELDOWN, "M-")
	text = string.gsub(text, '(數字鍵盤)', 'N')
	
	if hotkey:GetText() == _G["RANGE_INDICATOR"] then
		hotkey:SetText("")
	else
		hotkey:SetText(text)
	end
end

function AB:Style(button)
	local name = button:GetName()
	local action = button.action

	if name:match("MultiCast") then return end

	if not button.equipped then
		local equipped = button:CreateTexture(nil, "OVERLAY")
		equipped:SetTexture(0, 1, 0, .3)
		equipped:SetAllPoints()
		equipped:Hide()
		button.equipped = equipped
	end

	if action and IsEquippedAction(action) then
		if not button.equipped:IsShown() then
			button.equipped:Show()
		end
	else
		if button.equipped:IsShown() then
			button.equipped:Hide()
		end
	end

	if button.styled then return end

	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local Normal  = _G[name.."NormalTexture"]
	local Normal2 = button:GetNormalTexture()
	local Cooldown = _G[name .. "Cooldown"]
	local FloatingBG = _G[name.."FloatingBG"]

	if Cooldown then
		Cooldown:ClearAllPoints()
		Cooldown:SetAllPoints(button)
	end

	if Flash then Flash:SetTexture(nil) end
	if Normal then Normal:SetTexture(nil) Normal:Hide() Normal:SetAlpha(0) end
	if Normal2 then Normal2:SetTexture(nil) Normal2:Hide() Normal2:SetAlpha(0) end
	if Border then Border:SetTexture(nil) end

	if Count then
		Count:ClearAllPoints()
		Count:SetJustifyH("RIGHT")
		Count:SetPoint("BOTTOMRIGHT", 3, 0)
		Count:SetFont(DB.Font, C["FontSize"], "OUTLINE")
	end

	if FloatingBG then
		FloatingBG:Kill()
	end

	if Btname then
		if C["HideMacroName"] then
			Btname:SetDrawLayer("HIGHLIGHT")
			Btname:Width(50)
		end
	end

	if not button.shadow then
		if not totem then
			if not flyout then
				--button:SetWidth(C["ButtonSize"])
				--button:SetHeight(C["ButtonSize"])
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
		HotKey:SetPoint("TOPRIGHT", 0, 0)
		HotKey:SetFont(DB.Font, C["FontSize"], "OUTLINE")
		HotKey:SetShadowColor(0, 0, 0, 0.3)
		HotKey.ClearAllPoints = function() end
		HotKey.SetPoint = function() end
		if C["HideHotKey"] then
			HotKey:SetText("")
			HotKey:Hide()
			HotKey.Show = function() end
		end
	end

	button:StyleButton(true)

	button.styled = true
end

function AB:StyleShift()
	for i=1, NUM_STANCE_SLOTS do
		local name = "StanceButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture"]
		self:Style(button)
	end
end

function AB:StylePet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture2"]
		local autocast = _G[name.."AutoCastable"]
		autocast:SetAlpha(0)
		self:Style(button)
	end
end

local buttons = 0
function AB:SetupFlyoutButton()
	for i=1, buttons do
		if _G["SpellFlyoutButton"..i] then
			self:Style(_G["SpellFlyoutButton"..i], nil, true)
			_G["SpellFlyoutButton"..i]:StyleButton(true)
		end
	end
end

function AB:StyleFlyout(button)
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
        local layout = "HORIZONTAL"
        if button:GetParent() and button:GetParent():GetParent() then
            if button:GetParent():GetParent():GetHeight() > button:GetParent():GetParent():GetWidth() then
                layout = "VERTICAL"
            end
        end
		local point = AB:GetScreenQuadrant(button)

        if layout == "HORIZONTAL" then
            if point:find("TOP") then
                button.FlyoutArrow:ClearAllPoints()
                button.FlyoutArrow:SetPoint("BOTTOM", button, "BOTTOM", 0, -arrowDistance)
                SetClampedTextureRotation(button.FlyoutArrow, 180)
                if not InCombatLockdown() then button:SetAttribute("flyoutDirection", "BOTTOM") end
            else
                button.FlyoutArrow:ClearAllPoints()
                button.FlyoutArrow:SetPoint("TOP", button, "TOP", 0,arrowDistance)
                SetClampedTextureRotation(button.FlyoutArrow, 0)
                if not InCombatLockdown() then button:SetAttribute("flyoutDirection", "TOP") end
            end
        else
            if point:find("LEFT") then
                button.FlyoutArrow:ClearAllPoints()
                button.FlyoutArrow:SetPoint("RIGHT", button, "RIGHT", arrowDistance, 0)
                SetClampedTextureRotation(button.FlyoutArrow, 90)
                if not InCombatLockdown() then button:SetAttribute("flyoutDirection", "RIGHT") end
            else
                button.FlyoutArrow:ClearAllPoints()
                button.FlyoutArrow:SetPoint("LEFT", button, "LEFT", -arrowDistance, 0)
                SetClampedTextureRotation(button.FlyoutArrow, 270)
                if not InCombatLockdown() then button:SetAttribute("flyoutDirection", "LEFT") end
            end
        end
	end
end

function AB:UpdateOverlayGlow(button)
	if button.overlay and button.shadow then
		button.overlay:SetParent(button)
		button.overlay:ClearAllPoints()
		button.overlay:SetAllPoints(button.shadow)
		button.overlay.ants:ClearAllPoints()
		button.overlay.ants:SetPoint("TOPLEFT", button.shadow, "TOPLEFT")
		button.overlay.ants:SetPoint("BOTTOMRIGHT", button.shadow, "BOTTOMRIGHT")
		button.overlay.outerGlow:SetPoint("TOPLEFT", button.shadow, "TOPLEFT")
		button.overlay.outerGlow:SetPoint("BOTTOMRIGHT", button.shadow, "BOTTOMRIGHT")
	end
end
function AB:OnInitialize()
	if (IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("Macaroon")) then
		return 
	end
	C = SunUIConfig.db.profile.ActionBarDB
	self:SecureHook("ActionButton_UpdateHotkeys", "UpdateHotkey")
end
function AB:OnEnable()
	self:SecureHook("ActionButton_ShowOverlayGlow", "UpdateOverlayGlow")
	
	self:SecureHook("ActionButton_Update", "Style")
	self:SecureHook("ActionButton_UpdateFlyout", "StyleFlyout")
	self:SecureHook("StanceBar_Update", "StyleShift")
	self:SecureHook("StanceBar_UpdateState", "StyleShift")
	self:SecureHook("PetActionBar_Update", "StylePet")
	self:HookScript(SpellFlyout, "OnShow", "SetupFlyoutButton")

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		self:Style(_G["ActionButton"..i])
		self:Style(_G["MultiBarBottomLeftButton"..i])
		self:Style(_G["MultiBarBottomRightButton"..i])
		self:Style(_G["MultiBarRightButton"..i])
		self:Style(_G["MultiBarLeftButton"..i])
	end
end