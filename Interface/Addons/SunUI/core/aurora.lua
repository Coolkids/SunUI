local S, L, DB, _, C = unpack(select(2, ...))
local alpha = .5
local _G = _G
local AA = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("AuroraAPI", "AceEvent-3.0", "AceHook-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")

local media = {
	["arrowUp"] = "Interface\\AddOns\\SunUI\\media\\arrow-up-active",
	["arrowDown"] = "Interface\\AddOns\\SunUI\\media\\arrow-down-active",
	["arrowLeft"] = "Interface\\AddOns\\SunUI\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\SunUI\\media\\arrow-right-active",
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground",
	["checked"] = "Interface\\AddOns\\SunUI\\media\\CheckButtonHilight",
	["glow"] = "Interface\\AddOns\\SunUI\\media\\glowTex",
}

local gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha = "VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35
local frames, fsd = {}, {}

-- [[ Functions ]]

local class = DB.MyClass

local r, g, b
if CUSTOM_CLASS_COLORS then
	r, g, b = CUSTOM_CLASS_COLORS[class].r, CUSTOM_CLASS_COLORS[class].g, CUSTOM_CLASS_COLORS[class].b
else
	r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
end
local mult = S.mult
S.dummy = function() end

S.CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = media.backdrop,
		edgeFile = media.backdrop,
		edgeSize = mult,
	})
	f:SetBackdropColor(0, 0, 0, a or alpha)
	f:SetBackdropBorderColor(0, 0, 0)
	tinsert(frames, f)
end

S.CreateBG = function(frame)
	if frame.setbg then return end
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:Point("TOPLEFT", frame, -1, 1)
	bg:Point("BOTTOMRIGHT", frame, 1, -1)
	bg:SetTexture(media.backdrop)
	bg:SetVertexColor(0, 0, 0)
	frame.setbg = true
	return bg
end

S.CreateSD = function(parent, size, r, g, b, alpha, offset)
	if parent.sd then return end
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.size = sd.size - 5
	sd.offset = offset or 0
	sd:Point("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:Point("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:CreateShadow()
	sd.shadow:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd.border:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(alpha or 1)
	parent.sd = sd
	tinsert(fsd, sd)
end

S.CreateGradient = function(f)
	local tex = f:CreateTexture(nil, "BORDER")
	tex:Point("TOPLEFT", 1, -1)
	tex:Point("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(media.backdrop)
	tex:SetGradientAlpha(gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha)

	return tex
end

S.CreatePulse = function(frame)
	local speed = .05
	local mult = 1
	local alpha = 1
	local last = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		last = last + elapsed
		if last > speed then
			last = 0
			self:SetAlpha(alpha)
		end
		alpha = alpha - elapsed*mult
		if alpha < 0 and mult > 0 then
			mult = mult*-1
			alpha = 0
		elseif alpha > 1 and mult < 0 then
			mult = mult*-1
		end
	end)
end

local function StartGlow(f)
	if not f:IsEnabled() then return end
	f:SetBackdropColor(r, g, b, .1)
	f:SetBackdropBorderColor(r, g, b)
	f.glow:SetAlpha(1)
	S.CreatePulse(f.glow)
end

local function StopGlow(f)
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(0, 0, 0)
	f.glow:SetScript("OnUpdate", nil)
	f.glow:SetAlpha(0)
end

S.Reskin = function(f, noGlow)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	S.CreateBD(f, .0)

	S.CreateBack2(f, false, 0, 0, 0, 0.3, 0.35, 0.35, 0.35, 0.35)

	if not noGlow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
			edgeFile = media.glow,
			edgeSize = 5,
		})
		f.glow:Point("TOPLEFT", -6, 6)
		f.glow:Point("BOTTOMRIGHT", 6, -6)
		f.glow:SetBackdropBorderColor(r, g, b)
		f.glow:SetAlpha(0)

		f:HookScript("OnEnter", StartGlow)
 		f:HookScript("OnLeave", StopGlow)
	end
end

S.ReskinTab = function(f)
	f:DisableDrawLayer("BACKGROUND")

	local bg = CreateFrame("Frame", nil, f)
	bg:Point("TOPLEFT", 8, -3)
	bg:Point("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bg)

	f:SetHighlightTexture(media.backdrop)
	local hl = f:GetHighlightTexture()
	hl:Point("TOPLEFT", 9, -4)
	hl:Point("BOTTOMRIGHT", -9, 1)
	hl:SetVertexColor(r, g, b, .25)
end

local function colourScroll(f)
	if f:IsEnabled() then
		f.tex:SetVertexColor(r, g, b)
	end
end

local function clearScroll(f)
	f.tex:SetVertexColor(1, 1, 1)
end

S.ReskinScroll = function(f)
	local frame = f:GetName()

	if _G[frame.."Track"] then _G[frame.."Track"]:Hide() end
	if _G[frame.."BG"] then _G[frame.."BG"]:Hide() end
	if _G[frame.."Top"] then _G[frame.."Top"]:Hide() end
	if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
	if _G[frame.."Bottom"] then _G[frame.."Bottom"]:Hide() end

	local bu = _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:SetWidth(17)

	bu.bg = CreateFrame("Frame", nil, f)
	bu.bg:Point("TOPLEFT", bu, 0, -2)
	bu.bg:Point("BOTTOMRIGHT", bu, 0, 4)
	S.CreateBD(bu.bg, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:Point("TOPLEFT", bu.bg, 1, -1)
	tex:Point("BOTTOMRIGHT", bu.bg, -1, 1)
	tex:SetTexture(media.backdrop)
	tex:SetGradientAlpha(gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha)

	local up = _G[frame.."ScrollUpButton"]
	local down = _G[frame.."ScrollDownButton"]

	up:SetWidth(17)
	down:SetWidth(17)

	S.Reskin(up, true)
	S.Reskin(down, true)

	up:SetDisabledTexture(media.backdrop)
	local dis1 = up:GetDisabledTexture()
	dis1:SetVertexColor(0, 0, 0, .4)
	dis1:SetDrawLayer("OVERLAY")

	down:SetDisabledTexture(media.backdrop)
	local dis2 = down:GetDisabledTexture()
	dis2:SetVertexColor(0, 0, 0, .4)
	dis2:SetDrawLayer("OVERLAY")

	local uptex = up:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture(media.arrowUp)
	uptex:SetSize(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)
	up.tex = uptex

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
	down.tex = downtex

	up:HookScript("OnEnter", colourScroll)
	up:HookScript("OnLeave", clearScroll)
	down:HookScript("OnEnter", colourScroll)
	down:HookScript("OnLeave", clearScroll)
end

local function colourArrow(f)
	if f:IsEnabled() then
		f.downtex:SetVertexColor(r, g, b)
	end
end

local function clearArrow(f)
	f.downtex:SetVertexColor(1, 1, 1)
end

S.colourArrow = colourArrow
S.clearArrow = clearArrow

S.ReskinDropDown = function(f)
	local frame = f:GetName()

	local left = _G[frame.."Left"]
	local middle = _G[frame.."Middle"]
	local right = _G[frame.."Right"]

	if left then left:SetAlpha(0) end
	if middle then middle:SetAlpha(0) end
	if right then right:SetAlpha(0) end

	local down = _G[frame.."Button"]

	down:SetSize(20, 20)
	down:ClearAllPoints()
	down:SetPoint("RIGHT", -18, 2)

	S.Reskin(down, true)

	down:SetDisabledTexture(media.backdrop)
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
	down.downtex = downtex

	down:HookScript("OnEnter", colourArrow)
	down:HookScript("OnLeave", clearArrow)

	local bg = CreateFrame("Frame", nil, f)
	bg:Point("TOPLEFT", 16, -4)
	bg:Point("BOTTOMRIGHT", -18, 8)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bg, 0)

	S.CreateGradient(bg)
end

local function colourClose(f)
	f.text:SetTextColor(1, 0.2, 0.2)
end

local function clearClose(f)
	f.text:SetTextColor(r, g, b)
end

S.ReskinClose = function(f, a1, p, a2, x, y)
	f:SetSize(17, 17)

	if not a1 then
		f:Point("TOPRIGHT", -4, -4)
	else
		f:ClearAllPoints()
		f:SetPoint(a1, p, a2, x, y)
	end

	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	S.CreateBD(f, 0)

	S.CreateGradient(f)
	
	local text = f:CreateFontString(nil, "OVERLAY")
	text:SetFont(DB.Font, DB.FontSize, "THINOUTLINE")
	text:SetPoint("CENTER", 1, 1)
	text:SetText("x")
	f.text = text
	

	f:HookScript("OnEnter", colourClose)
 	f:HookScript("OnLeave", clearClose)
end

S.ReskinInput = function(f, height, width)
	local frame = f:GetName()
	_G[frame.."Left"]:Hide()
	if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
	if _G[frame.."Mid"] then _G[frame.."Mid"]:Hide() end
	_G[frame.."Right"]:Hide()

	local bd = CreateFrame("Frame", nil, f)
	bd:Point("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bd, 0)

	S.CreateGradient(bd)

	if height then f:SetHeight(height) end
	if width then f:SetWidth(width) end
end

S.ReskinArrow = function(f, direction)
	f:SetSize(18, 18)
	S.Reskin(f)

	f:SetDisabledTexture(media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = f:CreateTexture(nil, "ARTWORK")
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")

	tex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-"..direction.."-active")
end

S.ReskinCheck = function(f)
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(media.backdrop)
	local hl = f:GetHighlightTexture()
	hl:Point("TOPLEFT", 5, -5)
	hl:Point("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .2)

	local bd = CreateFrame("Frame", nil, f)
	bd:Point("TOPLEFT", 4, -4)
	bd:Point("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bd, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:Point("TOPLEFT", 5, -5)
	tex:Point("BOTTOMRIGHT", -5, 5)
	tex:SetTexture(media.backdrop)
	tex:SetGradientAlpha(gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha)

	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

local function colourRadio(f)
	f.bd:SetBackdropBorderColor(r, g, b)
end

local function clearRadio(f)
	f.bd:SetBackdropBorderColor(0, 0, 0)
end

S.ReskinRadio = function(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetCheckedTexture(media.backdrop)

	local ch = f:GetCheckedTexture()
	ch:Point("TOPLEFT", 4, -4)
	ch:Point("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(r, g, b, .6)

	local bd = CreateFrame("Frame", nil, f)
	bd:Point("TOPLEFT", 3, -3)
	bd:Point("BOTTOMRIGHT", -3, 3)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bd, 0)
	f.bd = bd

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:Point("TOPLEFT", 4, -4)
	tex:Point("BOTTOMRIGHT", -4, 4)
	tex:SetTexture(media.backdrop)
	tex:SetGradientAlpha(gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha)

	f:HookScript("OnEnter", colourRadio)
	f:HookScript("OnLeave", clearRadio)
end

S.ReskinSlider = function(f)
	f:SetBackdrop(nil)
	f.SetBackdrop = S.dummy

	local bd = CreateFrame("Frame", nil, f)
	bd:Point("TOPLEFT", 14, -2)
	bd:Point("BOTTOMRIGHT", -15, 3)
	bd:SetFrameStrata("BACKGROUND")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bd, 0)

	S.CreateGradient(bd)

	local slider = select(4, f:GetRegions())
	slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	slider:SetBlendMode("ADD")
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

S.colourExpandOrCollapse = colourExpandOrCollapse
S.clearExpandOrCollapse = clearExpandOrCollapse

S.ReskinExpandOrCollapse = function(f)
	f:SetSize(13, 13)

	S.Reskin(f, true)
	f.SetNormalTexture = S.dummy

	f.minus = f:CreateTexture(nil, "OVERLAY")
	f.minus:Size(7, 1)
	f.minus:SetPoint("CENTER")
	f.minus:SetTexture(media.backdrop)
	f.minus:SetVertexColor(1, 1, 1)

	f.plus = f:CreateTexture(nil, "OVERLAY")
	f.plus:Size(1, 7)
	f.plus:SetPoint("CENTER")
	f.plus:SetTexture(media.backdrop)
	f.plus:SetVertexColor(1, 1, 1)

	f:HookScript("OnEnter", colourExpandOrCollapse)
	f:HookScript("OnLeave", clearExpandOrCollapse)
end

S.SetBD = function(f, x, y, x2, y2)
	if f.setbd then return end
	local bg = CreateFrame("Frame", nil, f)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(0)
	S.CreateBD(bg)
	S.CreateSD(bg)
	f.setbd = true
end

S.ReskinPortraitFrame = function(f, isButtonFrame)
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

	S.CreateBD(f)
	S.CreateSD(f)
	S.ReskinClose(_G[name.."CloseButton"])
end

S.CreateBDFrame = function(f, a)
	local frame
	if f:GetObjectType() == "Texture" then
		frame = f:GetParent()
	else
		frame = f
	end

	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", f, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", f, 1, -1)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	S.CreateBD(bg, a or .5)

	return bg
end

S.ReskinColourSwatch = function(f)
	local name = f:GetName()

	local bg = _G[name.."SwatchBg"]

	f:SetNormalTexture(media.backdrop)
	local nt = f:GetNormalTexture()

	nt:SetPoint("TOPLEFT", 3, -3)
	nt:SetPoint("BOTTOMRIGHT", -3, 3)

	bg:SetTexture(0, 0, 0)
	bg:Point("TOPLEFT", 2, -2)
	bg:Point("BOTTOMRIGHT", -2, 2)
end

function S.ReskinFrame(f)
	if f.reskin == true then return end
	f.glow = CreateFrame("Frame", nil, f)
	f.glow:SetBackdrop({
		edgeFile = DB.GlowTex,
		edgeSize = S.Scale(5),
	})
	f.glow:Point("TOPLEFT", -6, 6)
	f.glow:Point("BOTTOMRIGHT", 6, -6)
	f.glow:SetBackdropBorderColor(r, g, b)
	f.glow:SetAlpha(0)

	f:HookScript("OnEnter", StartGlow)
 	f:HookScript("OnLeave", StopGlow)
	f.reskin = true
end

function AA:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if UnitAffectingCombat("player") then return end
	local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/UIParent:GetEffectiveScale()
	local function sceenscale(x)
		return (mult*math.floor(x/mult+.5)) 
	end
	--print(mult)
	for k,v in pairs(frames) do
		local r, g, b, a = v:GetBackdropColor() 
		local br, bg, bb, ba = v:GetBackdropBorderColor() 
		v:SetBackdrop({
			bgFile = media.backdrop,
			edgeFile = media.backdrop,
			edgeSize = mult,
		})
		v:SetBackdropColor(r, g, b, a)
		v:SetBackdropBorderColor(br, bg, bb, ba)
	end
	for k,v in pairs(fsd) do
		local parent = v:GetParent()
		v:SetPoint("TOPLEFT", parent, sceenscale(-v.size - 1 - v.offset), sceenscale(v.size + 1 + v.offset))
		v:SetPoint("BOTTOMRIGHT", parent, sceenscale(v.size + 1 + v.offset), sceenscale(-v.size - 1 - v.offset))
	end
	
	for k,v in pairs(DB.Border) do
		local br, bg, bb, ba = v:GetBackdropBorderColor() 
		v:SetBackdrop({
			edgeFile = DB.Solid, 
			edgeSize = mult,
			insets = { left = -mult, right = -mult, top = -mult, bottom = -mult }
		})
		v:SetBackdropBorderColor(br, bg, bb, ba)
	end
	
	for k,v in pairs(DB.Shadow) do
		local backdropr, backdropg, backdropb, backdropa = v.shadow:GetBackdropColor() 
		local borderr, borderg, borderb, bordera = v.shadow:GetBackdropBorderColor()
		v.border:SetPoint("TOPLEFT", -sceenscale(1), sceenscale(1))
		v.border:SetPoint("TOPRIGHT", sceenscale(1), sceenscale(1))
		v.border:SetPoint("BOTTOMRIGHT", sceenscale(1), -sceenscale(1))
		v.border:SetPoint("BOTTOMLEFT", -sceenscale(1), -sceenscale(1))
		
		v.shadow:SetPoint("TOPLEFT", -sceenscale(3), sceenscale(3))
		v.shadow:SetPoint("TOPRIGHT", sceenscale(3), sceenscale(3))
		v.shadow:SetPoint("BOTTOMRIGHT", sceenscale(3), -sceenscale(3))
		v.shadow:SetPoint("BOTTOMLEFT", -sceenscale(3), -sceenscale(3))
		v.shadow:SetBackdrop( { 
			edgeFile = DB.GlowTex,
			bgFile =DB.Solid,
			edgeSize = sceenscale(4),
			insets = {left = sceenscale(4), right = sceenscale(4), top = sceenscale(4), bottom = sceenscale(4)},
		})
		v.shadow:SetBackdropColor( backdropr, backdropg, backdropb, backdropa )
		v.shadow:SetBackdropBorderColor( borderr, borderg, borderb, bordera )
	end
	collectgarbage("collect")
end

function AA:UI_SCALE_CHANGED()
	self:PLAYER_ENTERING_WORLD()
end

function AA:OnInitialize()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	--VideoOptionsFrameOkay:HookScript("OnClick", AA.PLAYER_ENTERING_WORLD)
	--VideoOptionsFrameApply:HookScript("OnClick", AA.PLAYER_ENTERING_WORLD)
	self:RegisterEvent("UI_SCALE_CHANGED")
end
