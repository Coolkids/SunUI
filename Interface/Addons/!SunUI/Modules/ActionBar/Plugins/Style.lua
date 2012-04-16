-- Engines
local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("ActionStyle", "AceEvent-3.0")

function Module:UpdateActionStyle()
	C = ActionBarDB
	if C["Style"] == 1 then
	local _G = _G
	local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")

	local function UpdateHotkey(self, actionButtonType)
	local hotkey = _G[self:GetName() .. 'HotKey']
	local text = hotkey:GetText()

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

	if hotkey:GetText() == _G['RANGE_INDICATOR'] then
		hotkey:SetText('')
	else
		hotkey:SetText(text)
	end
end

function Style(self, totem, flyout)
	local name = self:GetName()
	
	if name:match("MultiCast") then return end 

	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal  = _G[name.."NormalTexture"]
	local normal2 = self:GetNormalTexture()

	if Flash then Flash:SetTexture(nil) end
	if normal then normal:SetTexture(nil) end
	if normal2 then normal2:SetTexture(nil) end
	--if Border then S.Kill(Border) end
	if Border then
		Border:ClearAllPoints()
		Border:SetPoint("TOPLEFT", -12, 12)
		Border:SetPoint("BOTTOMRIGHT", 12, -12)
	end

	if Count then
		Count:ClearAllPoints()
		Count:SetJustifyH("RIGHT")
		Count:SetPoint("BOTTOMRIGHT", 3, 0)
		Count:SetFont(DB.Font, S.mult*C["FontSize"], "OUTLINE")
	end

	if _G[name..'FloatingBG'] then
		S.Kill(_G[name..'FloatingBG'])
	end	

	if self.styled then return end	

	if Btname then
	Btname:SetJustifyH("LEFT")
	Btname:SetJustifyV("BOTTOM")
	Btname:SetPoint("BOTTOMLEFT")
	--Btname:SetPoint("BOTTOMRIGHT")
	Btname:SetFont(DB.Font, S.mult*C["MFontSize"], "THINOUTLINE")
		if C["HideMacroName"] then
			Btname:SetText("")
			Btname:Hide()
			Btname.Show = function() end
		end
	end

	if not self.shadow then
		if not totem then
			if not flyout then
				self:SetWidth(C["ButtonSize"])
				self:SetHeight(C["ButtonSize"])
			end
 
			self:CreateShadow("Background")
		end

		if Icon then
			Icon:SetTexCoord(.08, .92, .08, .92)
			Icon:SetAllPoints()
		end
	end

	if HotKey then
		HotKey:ClearAllPoints()
		HotKey:SetJustifyH("RIGHT")
		HotKey:SetPoint("TOPRIGHT", 3, 0)
		HotKey:SetFont(DB.Font, S.mult*C["FontSize"], "OUTLINE")
		HotKey:SetShadowColor(0, 0, 0, 0.3)
		HotKey.ClearAllPoints = function() end
		HotKey.SetPoint = function() end
		if C["HideHotKey"] then
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

	self.styled = true
end

local function Stylesmallbutton(normal, button, icon, name, pet)
	local Flash	 = _G[name.."Flash"]
	-- button:SetWidth(C["actionbar"].buttonsize)
	-- button:SetHeight(C["actionbar"].buttonsize)

	button:SetNormalTexture("")
	button.SetNormalTexture = function() end

	Flash:SetTexture(1, 1, 1, 0.3)

	if not button.shadow then
		button:CreateShadow("Background")
	end

	icon:SetTexCoord(.08, .92, .08, .92)
	icon:ClearAllPoints()
	if pet then			
		if C["ButtonSize"]*C["PetBarSacle"] < 30 then
			local autocast = _G[name.."AutoCastable"]
			autocast:SetAlpha(0)
		end
		local shine = _G[name.."Shine"]
		shine:SetSize(C["ButtonSize"], C["ButtonSize"])
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
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture"]
		Stylesmallbutton(normal, button, icon, name)
	end
end

local function StylePet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture2"]
		Stylesmallbutton(normal, button, icon, name, true)
	end
end

-- rescale cooldown spiral to fix texture.
local buttonNames = { "ActionButton",  "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "ShapeshiftButton", "PetActionButton"}
for _, name in ipairs( buttonNames ) do
	for index = 1, 12 do
		local buttonName = name .. tostring(index)
		local button = _G[buttonName]
		local cooldown = _G[buttonName .. "Cooldown"]
 
		if ( button == nil or cooldown == nil ) then
			break
		end

		cooldown:ClearAllPoints()
		cooldown:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
		cooldown:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	end
end

local buttons = 0
local function SetupFlyoutButton()
	for i=1, buttons do
		--prevent error if you don't have max ammount of buttons
		if _G["SpellFlyoutButton"..i] and not _G["SpellFlyoutButton"..i].styled then
			Style(_G["SpellFlyoutButton"..i], nil, true)
			_G["SpellFlyoutButton"..i]:StyleButton(true)
			--[[ if C["actionbar"].rightbarmouseover == true then
				SpellFlyout:HookScript("OnEnter", function(self) RightBarMouseOver(1) end)
				SpellFlyout:HookScript("OnLeave", function(self) RightBarMouseOver(0) end)
				_G["SpellFlyoutButton"..i]:HookScript("OnEnter", function(self) RightBarMouseOver(1) end)
				_G["SpellFlyoutButton"..i]:HookScript("OnLeave", function(self) RightBarMouseOver(0) end)
			end ]]
		end
	end
end
SpellFlyout:HookScript("OnShow", SetupFlyoutButton)

 
--Hide the Mouseover texture and attempt to find the ammount of buttons to be skinned
local function StyleFlyout(self)
	if not self.FlyoutBorder then return end
	self.FlyoutBorder:SetAlpha(0)
	self.FlyoutBorderShadow:SetAlpha(0)

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
	if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self) then
		arrowDistance = 5
	else
		arrowDistance = 2
	end

	if self:GetParent() and self:GetParent():GetParent() and self:GetParent():GetParent():GetName() and self:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then 
		return 
	end

--[[ 	if self:GetAttribute("flyoutDirection") ~= nil then
		local point, _, _, _, _ = self:GetPoint()

		if strfind(point, "TOP") then
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
			SetClampedTextureRotation(self.FlyoutArrow, 270)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "LEFT") end		
		else
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance)
			SetClampedTextureRotation(self.FlyoutArrow, 0)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "UP") end
		end
	end ]]
end

do	
	for i = 1, 12 do
		_G["MultiBarLeftButton"..i]:StyleButton(true)
		_G["MultiBarRightButton"..i]:StyleButton(true)
		_G["MultiBarBottomRightButton"..i]:StyleButton(true)
		_G["MultiBarBottomLeftButton"..i]:StyleButton(true)
		_G["ActionButton"..i]:StyleButton(true)
	end

	for i=1, 10 do
		_G["ShapeshiftButton"..i]:StyleButton(true)
		_G["PetActionButton"..i]:StyleButton(true)
	end

	for i=1, 6 do
		_G["VehicleMenuBarActionButton"..i]:StyleButton(true)
		Style(_G["VehicleMenuBarActionButton"..i])
	end
end

local function UpdateOverlayGlow(self)
	if self.overlay and self.shadow then
		self.overlay:SetParent(self)
		self.overlay:ClearAllPoints()
		self.overlay:SetAllPoints(self.shadow)
		self.overlay.ants:ClearAllPoints()
		self.overlay.ants:SetPoint("TOPLEFT", self.shadow, "TOPLEFT", -2, 2)
		self.overlay.ants:SetPoint("BOTTOMRIGHT", self.shadow, "BOTTOMRIGHT", 2, -2)
		self.overlay.outerGlow:SetPoint("TOPLEFT", self.shadow, "TOPLEFT", -2, 2)
		self.overlay.outerGlow:SetPoint("BOTTOMRIGHT", self.shadow, "BOTTOMRIGHT", 2, -2)
	end
end

hooksecurefunc("ActionButton_ShowOverlayGlow", UpdateOverlayGlow)

hooksecurefunc("ActionButton_Update", Style)
hooksecurefunc("ActionButton_UpdateHotkeys", UpdateHotkey)
hooksecurefunc("ActionButton_UpdateFlyout", StyleFlyout)

hooksecurefunc("ShapeshiftBar_Update", StyleShift)
hooksecurefunc("ShapeshiftBar_UpdateState", StyleShift)
hooksecurefunc("PetActionBar_Update", StylePet)

local Logon = CreateFrame("Frame")
Logon:RegisterEvent("PLAYER_ENTERING_WORLD")
Logon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	SetCVar("alwaysShowActionBars", 0)
	--S.Kill(InterfaceOptionsActionBarsPanelAlwaysShowActionBars)
	--[[ if C["actionbar"].showgrid == true then
		ActionButton_HideGrid = function() end
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("BonusActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
		end
	end ]]
end)
	elseif ActionBarDB.Style == 2 then
	
	local ActionBarMedia = "Interface\\Addons\\!SunUI\\Modules\\ActionBar\\Plugins\\Media\\"
	local textures = {
    normal            = ActionBarMedia.."gloss",
    flash             = ActionBarMedia.."flash",
    hover             = ActionBarMedia.."hover",
    pushed            = ActionBarMedia.."gloss",
    checked           = ActionBarMedia.."checked",
    equipped          = ActionBarMedia.."gloss",
    buttonback        = ActionBarMedia.."button_background",
    buttonbackflat    = ActionBarMedia.."button_background_flat",
    outer_shadow      = ActionBarMedia.."outer_shadow",
  }

  local background = {
    showbg            = false,  --show an background image?
    showshadow        = true,   --show an outer shadow?
    useflatbackground = false,  --true uses plain flat color instead
    backgroundcolor   = { r = 0.3, g = 0.3, b = 0.3, a = 0.7},
    shadowcolor       = { r = 0, g = 0, b = 0, a = 0.9},
    classcolored      = false,
    inset             = 5, 
  }
  
  local color = {
    normal            = { r = 0.37, g = 0.3, b = 0.3, },
    equipped          = { r = 0.1, g = 0.5, b = 0.1, },
    classcolored      = false,
  }
  
  local hotkeys = {
    fontsize        = 12,
    pos1             = { a1 = "TOPRIGHT", x = 0, y = 0 }, 
    pos2             = { a1 = "TOPLEFT", x = 0, y = 0 }, --important! two points are needed to make the hotkeyname be inside of the button
  }
  
  local macroname = {
    fontsize        = 10,
    pos1             = { a1 = "BOTTOMLEFT", x = 0, y = 0 }, 
    pos2             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 }, --important! two points are needed to make the macroname be inside of the button
  }
  
  local itemcount = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 }, 
  }
  
  local cooldown = {
    spacing         = 0,
  }
  
	  local _G = _G

	  local nomoreplay = function() end

	  local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

	  if color.classcolored then
		color.normal = classcolor
	  end

	  --backdrop settings
	  local bgfile, edgefile = "", ""
	  if background.showshadow then edgefile = textures.outer_shadow end
	  if background.useflatbackground and background.showbg then bgfile = textures.buttonbackflat end

	  --backdrop
	  local backdrop = {
		bgFile = bgfile,
		edgeFile = edgefile,
		tile = false,
		tileSize = 32,
		edgeSize = background.inset,
		insets = {
		  left = background.inset,
		  right = background.inset,
		  top = background.inset,
		  bottom = background.inset,
		},
	  }

	  local function applyBackground(bu)
		--shadows+background
		if bu:GetFrameLevel() > 0 and (background.showbg or background.showshadow) then
		  bu.bg = CreateFrame("Frame", nil, bu)
		  bu.bg:SetAllPoints(bu)
		  bu.bg:SetPoint("TOPLEFT", bu, "TOPLEFT", -4, 4)
		  bu.bg:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 4, -4)
		  bu.bg:SetFrameLevel(bu:GetFrameLevel()-1)

		  if background.classcolored then
			background.backgroundcolor = classcolor
			background.shadowcolor = classcolor
		  end

		  if background.showbg and not background.useflatbackground then
			local t = bu.bg:CreateTexture(nil,"BACKGROUND",-8)
			t:SetTexture(textures.buttonback)
			t:SetAllPoints(bu)
			t:SetVertexColor(background.backgroundcolor.r,background.backgroundcolor.g,background.backgroundcolor.b,background.backgroundcolor.a)
		  end

		  bu.bg:SetBackdrop(backdrop)
		  if background.useflatbackground then
			bu.bg:SetBackdropColor(background.backgroundcolor.r,background.backgroundcolor.g,background.backgroundcolor.b,background.backgroundcolor.a)
		  end
		  if background.showshadow then
			bu.bg:SetBackdropBorderColor(background.shadowcolor.r,background.shadowcolor.g,background.shadowcolor.b,background.shadowcolor.a)
		  end
		end
	  end

	  local function ntSetVertexColorFunc(nt, r, g, b, a)
		--do stuff
		if nt then
		  local self = nt:GetParent()
		  --print(self:GetName()..": r"..r.."g"..g.."b"..b)--debug
		  local action = self.action
		  if r==1 and g==1 and b==1 and action and (IsEquippedAction(action)) then
			nt:SetVertexColor(color.equipped.r,color.equipped.g,color.equipped.b,1)
		  elseif r==0.5 and g==0.5 and b==1 then
			--blizzard oom color
			nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
		  elseif r==1 and g==1 and b==1 then
			nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
		  end
		end
	  end
	  
	  --style extraactionbutton
	local function styleExtraActionButton(bu)
		if not bu or (bu and bu.rabs_styled) then return end
		local name = bu:GetName()
		local ho = _G[name.."HotKey"]
		--remove the style background theme
		bu.style:SetTexture(nil)
		hooksecurefunc(bu.style, "SetTexture", function(self, texture)
		  if texture and string.sub(texture,1,9) == "Interface" then
			self:SetTexture(nil)
		  end
		end)
		--icon
		bu.icon:SetTexCoord(0.1,0.9,0.1,0.9)
		bu.icon:SetAllPoints(bu)
		--cooldown
		bu.cooldown:SetAllPoints(bu.icon)
		--hotkey
		ho:Hide()
		--add button normaltexture
		bu:SetNormalTexture(textures.normal)
		local nt = bu:GetNormalTexture()
		nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
		nt:SetAllPoints(bu)
		--apply background
		if not bu.bg then applyBackground(bu) end
		bu.rabs_styled = true
	  end
	  
	  --initial style func
	  local function rActionButtonStyler_AB_style(self)
		if self.rABS_Styled then return end

		local action = self.action
		local name = self:GetName()
		local bu  = _G[name]
		local ic  = _G[name.."Icon"]
		local co  = _G[name.."Count"]
		local bo  = _G[name.."Border"]
		local ho  = _G[name.."HotKey"]
		local cd  = _G[name.."Cooldown"]
		local na  = _G[name.."Name"]
		local fl  = _G[name.."Flash"]
		local nt  = _G[name.."NormalTexture"]
		local fbg  = _G[name.."FloatingBG"]

		if not nt then
		  --error no button to style found, get out asap
		  self.rABS_Styled = true
		  --print(name)
		  return
		end

		if fbg then
		  fbg:Hide()
		  fbg.Show = nomoreplay
		end

		--hide the border (plain ugly, sry blizz)
		bo:Hide()
		bo.Show = nomoreplay

		if  C["HideHotKey"] == false then
		  ho:SetFont(DB.Font, C["FontSize"]*S.Scale(1), "OUTLINE")
		  ho:ClearAllPoints()
		  ho:SetPoint(hotkeys.pos1.a1,bu,hotkeys.pos1.x,hotkeys.pos1.y)
		  ho:SetPoint(hotkeys.pos2.a1,bu,hotkeys.pos2.x,hotkeys.pos2.y)
		else
		  ho:Hide()
		  ho.Show = nomoreplay
		end

		if C["HideMacroName"] == false then
		  na:SetFont(DB.Font, C["MFontSize"]*S.Scale(1), "OUTLINE")
		  na:ClearAllPoints()
		  na:SetPoint(macroname.pos1.a1,bu,macroname.pos1.x,macroname.pos1.y)
		  na:SetPoint(macroname.pos2.a1,bu,macroname.pos2.x,macroname.pos2.y)
		else
		  na:Hide()
		end

		if itemcount.show then
		  co:SetFont(DB.Font, C["FontSize"]*S.Scale(1), "OUTLINE")
		  co:ClearAllPoints()
		  co:SetPoint(itemcount.pos1.a1,bu,itemcount.pos1.x,itemcount.pos1.y)
		else
		  co:Hide()
		end

		--applying the textures
		fl:SetTexture(textures.flash)
		bu:SetHighlightTexture(textures.hover)
		bu:SetPushedTexture(textures.pushed)
		bu:SetCheckedTexture(textures.checked)
		bu:SetNormalTexture(textures.normal)

		--cut the default border of the icons and make them shiny
		ic:SetTexCoord(0.1,0.9,0.1,0.9)
		ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
		ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)

		--adjust the cooldown frame
		cd:SetPoint("TOPLEFT", bu, "TOPLEFT", cooldown.spacing, -cooldown.spacing)
		cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -cooldown.spacing, cooldown.spacing)

		--apply the normaltexture
		if ( IsEquippedAction(action) ) then
		  bu:SetNormalTexture(textures.equipped)
		  nt:SetVertexColor(color.equipped.r,color.equipped.g,color.equipped.b,1)
		else
		  bu:SetNormalTexture(textures.normal)
		  nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
		end

		--make the normaltexture match the buttonsize
		nt:SetAllPoints(bu)

		--disable resetting of textures
		fl.SetTexture = nomoreplay
		bu.SetHighlightTexture = nomoreplay
		bu.SetPushedTexture = nomoreplay
		bu.SetCheckedTexture = nomoreplay
		bu.SetNormalTexture = nomoreplay

		--hook to prevent Blizzard from reseting our colors
		hooksecurefunc(nt, "SetVertexColor", ntSetVertexColorFunc)

		--shadows+background
		if not bu.bg then applyBackground(bu) end
		styleExtraActionButton(_G["ExtraActionButton1"]) --新的哦,亲~~
		self.rABS_Styled = true

	  end

	  --style pet buttons
	  local function rActionButtonStyler_AB_stylepet()

		for i=1, NUM_PET_ACTION_SLOTS do
		  local name = "PetActionButton"..i
		  local bu  = _G[name]
		  local ic  = _G[name.."Icon"]
		  local fl  = _G[name.."Flash"]
		  local nt  = _G[name.."NormalTexture2"]

		  nt:SetAllPoints(bu)

		  --applying color
		  nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)

		  --setting the textures
		  fl:SetTexture(textures.flash)
		  bu:SetHighlightTexture(textures.hover)
		  bu:SetPushedTexture(textures.pushed)
		  bu:SetCheckedTexture(textures.checked)
		  bu:SetNormalTexture(textures.normal)

		  --cut the default border of the icons and make them shiny
		  ic:SetTexCoord(0.1,0.9,0.1,0.9)
		  ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
		  ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)

		  --shadows+background
		  if not bu.bg then applyBackground(bu) end

		end
	  end

	  --style shapeshift buttons
	  local function rActionButtonStyler_AB_styleshapeshift()
		for i=1, NUM_SHAPESHIFT_SLOTS do
		  local name = "ShapeshiftButton"..i
		  local bu  = _G[name]
		  local ic  = _G[name.."Icon"]
		  local fl  = _G[name.."Flash"]
		  local nt  = _G[name.."NormalTexture2"]

		  nt:SetAllPoints(bu)

		  --applying color
		  nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)

		  --setting the textures
		  fl:SetTexture(textures.flash)
		  bu:SetHighlightTexture(textures.hover)
		  bu:SetPushedTexture(textures.pushed)
		  bu:SetCheckedTexture(textures.checked)
		  bu:SetNormalTexture(textures.normal)

		  --cut the default border of the icons and make them shiny
		  ic:SetTexCoord(0.1,0.9,0.1,0.9)
		  ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
		  ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)

		  --shadows+background
		  if not bu.bg then applyBackground(bu) end

		end
	  end

	  ---------------------------------------
	  -- CALLS // HOOKS
	  ---------------------------------------

	  hooksecurefunc("ActionButton_Update",         rActionButtonStyler_AB_style)
	  hooksecurefunc("ShapeshiftBar_Update",        rActionButtonStyler_AB_styleshapeshift)
	  hooksecurefunc("ShapeshiftBar_UpdateState",   rActionButtonStyler_AB_styleshapeshift)
	  hooksecurefunc("PetActionBar_Update",         rActionButtonStyler_AB_stylepet)
	  
	  end
end

function Module:OnInitialize()
	Module:UpdateActionStyle()
end