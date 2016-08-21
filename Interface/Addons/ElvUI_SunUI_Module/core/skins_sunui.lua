local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local A = E:NewModule("Skins-SunUI", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

local alpha = 0.8
local backdropcolorr, backdropcolorg, backdropcolorb = .1, .1, .1 
local backdropfadecolorr, backdropfadecolorg, backdropfadecolorb = .04, .04, .04, .7 
local bordercolorr, bordercolorg, bordercolorb = 0, 0, 0 

local r, g, b
if CUSTOM_CLASS_COLORS then
	r, g, b =  CUSTOM_CLASS_COLORS[E.myclass].r, CUSTOM_CLASS_COLORS[E.myclass].g, CUSTOM_CLASS_COLORS[E.myclass].b
else
	r, g, b =  RAID_CLASS_COLORS[E.myclass].r, RAID_CLASS_COLORS[E.myclass].g, RAID_CLASS_COLORS[E.myclass].b
end

local function SetTemplate3(f, t, glossTex)
	local r, g, b, alpha = unpack(P["media"].backdropcolor)
	if t == "Transparent" then 
		r, g, b, alpha = unpack(P["media"].backdropfadecolor)
	end

    if t == "Border" then
        f:SetBackdrop({
            edgeFile = P["media"].blank, 
            edgeSize = E.mult, 
            tile = false,
            tileSize = 0,
        })
    else
        f:SetBackdrop({
            bgFile = P["media"].blank, 
            edgeFile = P["media"].blank, 
            edgeSize = E.mult, 
            tile = false,
            tileSize = 0,
        })
    end

	if glossTex then 
        f.backdropTexture = f:CreateTexture(nil, "BACKGROUND")
        f.backdropTexture:SetDrawLayer("BACKGROUND", 1)
        f.backdropTexture:SetInside(f, E.mult, E.mult)
        f.backdropTexture:SetTexture(P["media"].gloss)
        f.backdropTexture:SetVertexColor(unpack(P["media"].backdropcolor))
        f.backdropTexture:SetAlpha(.8)
        alpha = 0
	end

	f:SetBackdropColor(backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, alpha)
	f:SetBackdropBorderColor(unpack(P["media"].bordercolor))
end

A["media"] = {
	["checked"] = "Interface\\AddOns\\ElvUI_SunUI_Module\\media\\CheckButtonHilight",
	["arrowUp"] = "Interface\\AddOns\\ElvUI_SunUI_Module\\media\\arrow-up-active",
	["arrowDown"] = "Interface\\AddOns\\ElvUI_SunUI_Module\\media\\arrow-down-active",
	["arrowLeft"] = "Interface\\AddOns\\ElvUI_SunUI_Module\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\ElvUI_SunUI_Module\\media\\arrow-right-active",
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground",
	["arrowLeft"] = "Interface\\AddOns\\ElvUI_SunUI_Module\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\ElvUI_SunUI_Module\\media\\arrow-right-active",
}

function A:classcolours(class)
	return RAID_CLASS_COLORS[class]
end

function A:CreateStripesThin(f)
	if not f then return end
	f.stripesthin = f:CreateTexture(nil, "BACKGROUND", nil, 1)
	f.stripesthin:SetAllPoints()
	f.stripesthin:SetTexture([[Interface\AddOns\ElvUI_SunUI_Module\media\StripesThin]], true)
	f.stripesthin:SetHorizTile(true)
	f.stripesthin:SetVertTile(true)
	f.stripesthin:SetBlendMode("ADD")
end

function A:CreateBackdropTexture(f)
	if not f then return end
	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetDrawLayer("BACKGROUND", 1)
	tex:SetInside(f, 1, 1)
	tex:SetTexture(P["media"].gloss)
	--tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
	tex:SetVertexColor(backdropcolorr, backdropcolorg, backdropcolorb)
	tex:SetAlpha(0.8)
	f.backdropTexture = tex
end

function A:CreateBD(f, a)
	if not f then return end
	f:SetBackdrop({
		bgFile = P["media"].blank, 
		edgeFile = P["media"].blank, 
		edgeSize = E.mult, 
	})
	f:SetBackdropColor(backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, a or alpha)
	f:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
end

function A:CreateBG(frame)
	if not frame then return end
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:Point("TOPLEFT", frame, -1, 1)
	bg:Point("BOTTOMRIGHT", frame, 1, -1)
	bg:SetTexture(P["media"].blank)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

function A:CreateSD(parent, size, r, g, b, alpha, offset)
	if not parent then return end
	A:CreateStripesThin(parent)

	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.size = sd.size - 5
	sd.offset = offset or 0
	sd:Point("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:Point("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	self:CreateShadow2(sd)
	sd.shadow:SetBackdropBorderColor(r or bordercolorr, g or bordercolorg, b or bordercolorb)
	sd.border:SetBackdropBorderColor(r or bordercolorr, g or bordercolorg, b or bordercolorb)
	sd:SetAlpha(alpha or 1)
end

function A:CreatePulse(frame, speed, alpha, mult)
	if not frame then return end
	frame.speed = .02
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		elapsed = elapsed * ( speed or 5/4 )
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha*(alpha or 3/5))
		end
		self.alpha = self.alpha - elapsed*self.mult
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult*-1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult*-1
		end
	end)
end

local function StartGlow(f)
	if f.IsEnabled == nil then return end
	if not f:IsEnabled() then return end
	f:SetBackdropColor(r, g, b, .2)
	f:SetBackdropBorderColor(r, g, b)
	f.glow:SetAlpha(1)
	A:CreatePulse(f.glow)
end

local function StopGlow(f)
	if not f then return end
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	f.glow:SetScript("OnUpdate", nil)
	f.glow:SetAlpha(0)
end

function A:Reskin(f, noGlow, saveTexture)
	if not f then return end
	if saveTexture then
		if f.SetHighlightTexture then f:SetHighlightTexture("") end
    if f.SetPushedTexture then f:SetPushedTexture("") end
    if f.SetDisabledTexture then f:SetDisabledTexture("") end
	else
		if f.SetNormalTexture then f:SetNormalTexture("") end
    if f.SetHighlightTexture then f:SetHighlightTexture("") end
    if f.SetPushedTexture then f:SetPushedTexture("") end
    if f.SetDisabledTexture then f:SetDisabledTexture("") end
	end
	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	SetTemplate3(f, "Default", true)

	if not noGlow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetFrameLevel(f:GetFrameLevel()+1)
		f.glow:SetBackdrop({
			edgeFile = P["media"].glow,
			edgeSize = E:Scale(4),
		})
		f.glow:SetOutside(f, 4, 4)
		f.glow:SetBackdropBorderColor(r, g, b)
		f.glow:SetAlpha(0)
		
		f:HookScript("OnEnter", StartGlow)
		f:HookScript("OnLeave", StopGlow)
	end
end

function A:CreateTab(f)
	if not f then return end
	f:DisableDrawLayer("BACKGROUND")

	f.backdrop = CreateFrame("Frame", nil, f)
	f.backdrop:Point("TOPLEFT", 8, -3)
	f.backdrop:Point("BOTTOMRIGHT", -8, 0)
	f.backdrop:SetFrameLevel(f:GetFrameLevel()-1)
	A:CreateBD(f.backdrop)

	f:SetHighlightTexture(P["media"].blank)
	local hl = f:GetHighlightTexture()
	hl:Point("TOPLEFT", 9, -4)
	hl:Point("BOTTOMRIGHT", -9, 1)
	hl:SetVertexColor(r, g, b, .25)
end

function A:ReskinTab(f)
	self:CreateTab(f)
end

function A:ReskinScroll(f)
	if not f then return end
	local frame = f:GetName()

	local track = (f.trackBG or f.Background) or (_G[frame.."Track"] or _G[frame.."BG"])
	if track then track:Hide() end
	local top = (f.ScrollBarTop or f.Top) or _G[frame.."Top"]
	if top then top:Hide() end
	local middle = (f.ScrollBarMiddle or f.Middle) or _G[frame.."Middle"]
	if middle then middle:Hide() end
	local bottom = (f.ScrollBarBottom or f.Bottom) or _G[frame.."Bottom"]
	if bottom then bottom:Hide() end

	local bu = f.ThumbTexture or f.thumbTexture or _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:Width(17)

	bu.bg = CreateFrame("Frame", nil, f)
	bu.bg:Point("TOPLEFT", bu, 0, -2)
	bu.bg:Point("BOTTOMRIGHT", bu, 0, 4)
	A:CreateBD(bu.bg, 0)
	A:CreateBackdropTexture(f)
	f.backdropTexture:SetInside(bu.bg, 1, 1)

	local up = f.ScrollUpButton or f.UpButton or _G[(frame or parent).."ScrollUpButton"]
	local down = f.ScrollDownButton or f.DownButton or _G[(frame or parent).."ScrollDownButton"]

	up:Width(17)
	down:Width(17)

	A:Reskin(up)
	A:Reskin(down)

	up:SetDisabledTexture(P["media"].blank)
	local dis1 = up:GetDisabledTexture()
	dis1:SetVertexColor(0, 0, 0, .3)
	dis1:SetDrawLayer("OVERLAY")

	down:SetDisabledTexture(P["media"].blank)
	local dis2 = down:GetDisabledTexture()
	dis2:SetVertexColor(0, 0, 0, .3)
	dis2:SetDrawLayer("OVERLAY")

	local uptex = up:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture(A.media.arrowUp)
	uptex:Size(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(A.media.arrowDown)
	downtex:Size(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
end

function A:ReskinDropDown(f)
	if not f then return end
	local frame = f:GetName()

	local left = _G[frame.."Left"]
	local middle = _G[frame.."Middle"]
	local right = _G[frame.."Right"]

	if left then left:SetAlpha(0) end
	if middle then middle:SetAlpha(0) end
	if right then right:SetAlpha(0) end

	local down = _G[frame.."Button"]

	down:ClearAllPoints()
	down:Point("TOPRIGHT", -18, -4)
	down:Point("BOTTOMRIGHT", -18, 8)
	down:SetWidth(19)

	A:Reskin(down)

	down:SetDisabledTexture(P["media"].blank)
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints(down)

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(A.media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)

	local bg = CreateFrame("Frame", nil, f)
	bg:Point("TOPLEFT", 16, -4)
	bg:Point("BOTTOMRIGHT", -18, 8)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	A:CreateBD(bg, 0)
	A:CreateBackdropTexture(bg)
end

local function colourClose(f)
	if f:IsEnabled() then
		for _, pixel in pairs(f.pixels) do
			pixel:SetVertexColor(r, g, b)
		end
	end
end

local function clearClose(f)
	for _, pixel in pairs(f.pixels) do
		pixel:SetVertexColor(1, 1, 1)
	end
end

function A:ReskinClose(f, a1, p, a2, x, y)
	if not f then return end
	f:Size(17, 17)

	if not a1 then
		f:Point("TOPRIGHT", -4, -4)
	else
		f:ClearAllPoints()
		f:Point(a1, p, a2, x, y)
	end

	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	A:CreateBD(f, 0)
	A:CreateBackdropTexture(f)

	f:SetDisabledTexture(A.media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	f.pixels = {}

	for i = 1, 7 do
		local tex = f:CreateTexture()
		tex:SetTexture(1, 1, 1)
		tex:Size(1, 1)
		tex:Point("BOTTOMLEFT", 4+i, 4+i)
		tinsert(f.pixels, tex)
	end

	for i = 1, 7 do
		local tex = f:CreateTexture()
		tex:SetTexture(1, 1, 1)
		tex:Size(1, 1)
		tex:Point("TOPLEFT", 4+i, -4-i)
		tinsert(f.pixels, tex)
	end

	f:HookScript("OnEnter", colourClose)
	f:HookScript("OnLeave", clearClose)
	if not f.text then
		f.text = f:CreateFontString(nil, "OVERLAY")
		f.text:SetFont(P["media"].font, E.mult*10, "OUTLINE,MONOCHROME")
		f.text:Point("CENTER", 2, 1)
		f.text:SetText("x")
	end
	f:HookScript("OnEnter", function(self) text:SetTextColor(1, .1, .1) end)
	f:HookScript("OnLeave", function(self) text:SetTextColor(1, 1, 1) end)
end

function A:ReskinInput(f, height, width)
	if not f then return end
	local frame = f:GetName()
	if frame then
		local left = f.Left or _G[frame.."Left"]
		local middle = f.Middle or _G[frame.."Middle"] or _G[frame.."Mid"]
		local right = f.Right or _G[frame.."Right"]

		left:Hide()
		middle:Hide()
		right:Hide()
	end
	A:CreateBD(f, 0)
	A:CreateBackdropTexture(f)

	if height then f:Height(height) end
	if width then f:Width(width) end
end

function A:ReskinArrow(f, direction)
	if not f then return end
	f:Size(18, 18)
	A:Reskin(f)

	f:SetDisabledTexture(P["media"].blank)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = f:CreateTexture(nil, "ARTWORK")
	tex:Size(8, 8)
	tex:SetPoint("CENTER")

	tex:SetTexture("Interface\\AddOns\\ElvUI_SunUI_Module\\media\\arrow-"..direction.."-active")
end

function A:ReskinCheck(f)
	if not f then return end
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(P["media"].blank)
	local hl = f:GetHighlightTexture()
	hl:SetInside(f, 5, 5)
	hl:SetVertexColor(r, g, b, .2)

	A:CreateBackdropTexture(f)
	f.backdropTexture:SetInside(f, 5, 5)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetInside(f, 4, 4)
	bd:SetFrameLevel(f:GetFrameLevel())
	A:CreateBD(bd, 0)

	f:SetCheckedTexture(A["media"].backdrop)
	local ck = f:GetCheckedTexture()
	ck:SetDesaturated(true)
	ck:SetVertexColor(r, g, b)
	ck:Point("TOPLEFT", bd, 5, -5)
	ck:Point("BOTTOMRIGHT", bd, -5, 5)
	ck.SetPoint = E.noop
end

function A:ReskinSlider(f)
	if not f then return end
	f:SetBackdrop(nil)
	f.SetBackdrop = E.noop

	local bd = CreateFrame("Frame", nil, f)
	bd:Point("TOPLEFT", 1, -2)
	bd:Point("BOTTOMRIGHT", -1, 3)
	bd:SetFrameStrata("BACKGROUND")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	A:CreateBD(bd, 0)
	A:CreateBackdropTexture(bd)

	local slider = select(4, f:GetRegions())
	slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	slider:SetBlendMode("ADD")
end

function A:SetBD(f, x, y, x2, y2)
	if not f or f.setbd then return end
	local bg = CreateFrame("Frame", nil, f)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:Point("TOPLEFT", x, y)
		bg:Point("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(0)
	A:CreateBD(bg, 0.5)
	A:CreateSD(bg)
	f.setbd = true
end

function A:ReskinPortraitFrame(f, isButtonFrame)
	local name = f:GetName()
	
	_G[name.."Bg"]:Hide()
	_G[name.."TitleBg"]:Hide()
	_G[name.."Portrait"]:Hide()
	_G[name.."PortraitFrame"]:Hide()
	_G[name.."TopRightCorner"]:Hide()
	_G[name.."TopLeftCorner"]:Hide()
	_G[name.."TopBorder"]:Hide()
	_G[name.."TopTileStreaks"]:SetTexture("")
	_G[name.."BotLeftCorner"]:Hide()
	_G[name.."BotRightCorner"]:Hide()
	_G[name.."BottomBorder"]:Hide()
	_G[name.."LeftBorder"]:Hide()
	_G[name.."RightBorder"]:Hide()
	
	if isButtonFrame then
		_G[name.."BtnCornerLeft"]:SetTexture("")
		_G[name.."BtnCornerRight"]:SetTexture("")
		_G[name.."ButtonBottomBorder"]:SetTexture("")
		
		f.Inset.Bg:Hide()
		f.Inset:DisableDrawLayer("BORDER")
	end

	A:CreateBD(f)
	A:CreateSD(f)
	A:ReskinClose(_G[name.."CloseButton"])
end

function A:CreateBDFrame(f, a)
	local frame
	if f:GetObjectType() == "Texture" then
		frame = f:GetParent()
	else
		frame = f
	end

	local lvl = frame:GetFrameLevel()
	
	local bg = CreateFrame("Frame", nil, frame)
	bg:Point("TOPLEFT", -1, 1)
	bg:Point("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	A:CreateBD(bg, a or alpha)
	return bg
end

function A:CreateMark(f, orientation)
	local spark =  f:CreateTexture(nil, "BORDER", 1)
	spark:SetTexture("Interface\\Buttons\\WHITE8x8")
	spark:SetVertexColor(0, 0, 0)
	if not orientation then
		spark:SetWidth(1)
		spark:SetPoint("TOPLEFT", f:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		spark:SetPoint("BOTTOMLEFT", f:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	else
		spark:SetHeight(1)
		spark:SetPoint("TOPLEFT", f:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		spark:SetPoint("TOPRIGHT", f:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
	end
	return spark
end

function A:CreateShadow2(f, t, thickness)
	if f.shadow then return end

	local borderr, borderg, borderb = 0, 0, 0
    local backdropr, backdropg, backdropb, backdropa = unpack(P["media"].backdropcolor)
	local frameLevel = f:GetFrameLevel() > 1 and f:GetFrameLevel() - 1 or 1
	local thickness = thickness or 4
	local offset = thickness - 1

    if t == "Background" then
        backdropr, backdropg, backdropb, backdropa = unpack(P["media"].backdropfadecolor)
    elseif type(t) == "number" then
		backdropa = t
	else
        backdropa = 0
    end

	local border = CreateFrame("Frame", nil, f)
	border:SetFrameLevel(frameLevel-1)
	border:SetOutside(f, 1, 1)
    SetTemplate3(border, "Border")
	f.border = border

	local shadow = CreateFrame("Frame", nil, border)
	shadow:SetFrameLevel(frameLevel - 1)
	shadow:SetOutside(border, offset, offset)
	shadow:SetBackdrop( {
		edgeFile = P["media"].glow,
        bgFile = P["media"].blank, 
		edgeSize = E:Scale(thickness),
        tile = false,
        tileSize = 0,
		insets = {left = E:Scale(thickness), right = E:Scale(thickness), top = E:Scale(thickness), bottom = E:Scale(thickness)},
	})
	shadow:SetBackdropColor( backdropr, backdropg, backdropb, backdropa )
	shadow:SetBackdropBorderColor( borderr, borderg, borderb )
	f.shadow = shadow
end

function A:CreateShadow(p, f, t, thickness) 
	if p.shadow then return end

	local borderr, borderg, borderb = 0, 0, 0
    local backdropr, backdropg, backdropb, backdropa = unpack(P["media"].backdropcolor)
	local frameLevel = p:GetFrameLevel() > 1 and p:GetFrameLevel() - 1 or 1
	local thickness = thickness or 4
	local offset = thickness - 1

    if t == "Background" then
        backdropr, backdropg, backdropb, backdropa = unpack(P["media"].backdropfadecolor)
    else
        backdropa = 0
    end

	local border = CreateFrame("Frame", nil, p)
	border:SetFrameLevel(frameLevel)
	border:SetOutside(f, 1, 1)
    SetTemplate3(border, "Border")
	f.border = border

	local shadow = CreateFrame("Frame", nil, border)
	shadow:SetFrameLevel(frameLevel - 1)
	shadow:SetOutside(border, offset, offset)
	shadow:SetBackdrop( {
		edgeFile = P["media"].glow,
        bgFile = P["media"].blank, 
		edgeSize = E:Scale(thickness),
        tile = false,
        tileSize = 0,
		insets = {left = E:Scale(thickness), right = E:Scale(thickness), top = E:Scale(thickness), bottom = E:Scale(thickness)},
	})
	shadow:SetBackdropColor( backdropr, backdropg, backdropb, backdropa )
	shadow:SetBackdropBorderColor( borderr, borderg, borderb )
	p.shadow = shadow
end

function A:ReskinFrame(f)
	if f.reskin == true then return end
	if not f.glow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
			edgeFile = P["media"].glow,
			edgeSize = 5,
		})
		f.glow:SetPoint("TOPLEFT", -6, 6)
		f.glow:SetPoint("BOTTOMRIGHT", 6, -6)
		f.glow:SetBackdropBorderColor(r, g, b)
		f.glow:SetAlpha(0)
	end
	f:HookScript("OnEnter", StartGlow)
 	f:HookScript("OnLeave", StopGlow)
	f.reskin = true
end

local function colourArrow(f)
	if f:IsEnabled() then
		f.tex:SetVertexColor(r, g, b)
	end
end

function A:colourArrow(f)
	colourArrow(f)
end

local function clearArrow(f)
	f.tex:SetVertexColor(1, 1, 1)
end

function A:clearArrow(f)
	clearArrow(f)
end

function A:ReskinNavBar(f)
	local overflowButton = f.overflowButton

	f:GetRegions():Hide()
	f:DisableDrawLayer("BORDER")
	f.overlay:Hide()
	f.homeButton:GetRegions():Hide()

	A:Reskin(f.homeButton)
	A:Reskin(overflowButton, true)

	local tex = overflowButton:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(A.media.arrowLeft)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	overflowButton.tex = tex

	overflowButton:HookScript("OnEnter", colourArrow)
	overflowButton:HookScript("OnLeave", clearArrow)
end

function A:ReskinGarrisonPortrait(portrait)
	local level = portrait.Level
	local cover = portrait.PortraitRingCover

	portrait.PortraitRing:Hide()
	portrait.PortraitRingQuality:SetTexture("")

	portrait.LevelBorder:SetTexture(0, 0, 0, .5)
	portrait.LevelBorder:SetSize(44, 11)
	portrait.LevelBorder:ClearAllPoints()
	portrait.LevelBorder:SetPoint("BOTTOM", 0, 12)

	level:ClearAllPoints()
	level:SetPoint("BOTTOM", portrait, 0, 12)

	local squareBG = CreateFrame("Frame", nil, portrait)
	squareBG:SetFrameLevel(portrait:GetFrameLevel()-1)
	squareBG:SetPoint("TOPLEFT", 3, -3)
	squareBG:SetPoint("BOTTOMRIGHT", -3, 11)
	A:CreateBD(squareBG, 1)
	portrait.squareBG = squareBG

	if cover then
		cover:SetTexture(0, 0, 0)
		cover:SetAllPoints(squareBG)
	end
end

function A:ReskinIcon(icon)
	icon:SetTexCoord(.08, .92, .08, .92)
	A:CreateBG(icon)
end

function A:CreateGradient(f)
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(A.media.backdrop)
	tex:SetVertexColor(0.2, 0.2, 0.2, 1)
	return tex
end

function A:ReskinFilterButton(f)
	f.TopLeft:Hide()
	f.TopRight:Hide()
	f.BottomLeft:Hide()
	f.BottomRight:Hide()
	f.TopMiddle:Hide()
	f.MiddleLeft:Hide()
	f.MiddleRight:Hide()
	f.BottomMiddle:Hide()
	f.MiddleMiddle:Hide()

	A:Reskin(f)
	f.Icon:SetTexture(A.media.arrowRight)

	f.Text:SetPoint("CENTER")
	f.Icon:SetPoint("RIGHT", f, "RIGHT", -5, 0)
	f.Icon:SetSize(8, 8)
end


local function colourRadio(f)
	f.bd:SetBackdropBorderColor(r, g, b)
end

local function clearRadio(f)
	f.bd:SetBackdropBorderColor(0, 0, 0)
end

function A:ReskinRadio(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetCheckedTexture(A.media.backdrop)

	local ch = f:GetCheckedTexture()
	ch:SetPoint("TOPLEFT", 4, -4)
	ch:SetPoint("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(r, g, b, .6)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 3, -3)
	bd:SetPoint("BOTTOMRIGHT", -3, 3)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	A:CreateBD(bd, 0)
	f.bd = bd

	A:CreateBackdropTexture(f)
	f.backdropTexture:SetPoint("TOPLEFT", 4, -4)
	f.backdropTexture:SetPoint("BOTTOMRIGHT", -4, 4)

	f:HookScript("OnEnter", colourRadio)
	f:HookScript("OnLeave", clearRadio)
end

local function colourExpandOrCollapse(f)
	if f:IsEnabled() then
		f.plus:SetVertexColor(r, g, b)
		f.minus:SetVertexColor(r, g, b)
	end
end

local function clearExpandOrCollapse(f)
	f.plus:SetVertexColor(1, 1, 1)
	f.minus:SetVertexColor(1, 1, 1)
end

A.colourExpandOrCollapse = colourExpandOrCollapse
A.clearExpandOrCollapse = clearExpandOrCollapse

function A:ReskinExpandOrCollapse(f)
	f:SetSize(13, 13)

	A:Reskin(f, true)
	f.SetNormalTexture = E.noop

	f.minus = f:CreateTexture(nil, "OVERLAY")
	f.minus:SetSize(7, 1)
	f.minus:SetPoint("CENTER")
	f.minus:SetTexture(A.media.backdrop)
	f.minus:SetVertexColor(1, 1, 1)

	f.plus = f:CreateTexture(nil, "OVERLAY")
	f.plus:SetSize(1, 7)
	f.plus:SetPoint("CENTER")
	f.plus:SetTexture(A.media.backdrop)
	f.plus:SetVertexColor(1, 1, 1)

	f:HookScript("OnEnter", colourExpandOrCollapse)
	f:HookScript("OnLeave", clearExpandOrCollapse)
end
