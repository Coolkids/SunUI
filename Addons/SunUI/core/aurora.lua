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
	["gradient"] = "Interface\\AddOns\\SunUI\\media\\gradient",
	["roleIcons"] = "Interface\\Addons\\SunUI\\media\\UI-LFG-ICON-ROLES",
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
local mult = 1
S.dummy = function() end

S.CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = media.backdrop,
		edgeFile = media.backdrop,
		edgeSize = mult,
	})
	f:SetBackdropColor(0, 0, 0, a or alpha)
	f:SetBackdropBorderColor(0, 0, 0)
end

S.CreateBG = function(frame)
	if frame.setbg then return end
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", frame, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", frame, 1, -1)
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
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:CreateShadow()
	sd.shadow:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd.border:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(alpha or 1)
	parent.sd = sd
end

S.CreateGradient = function(f)
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
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
		f.glow:SetPoint("TOPLEFT", -5, 5)
		f.glow:SetPoint("BOTTOMRIGHT", 5, -5)
		f.glow:SetBackdropBorderColor(r, g, b)
		f.glow:SetAlpha(0)

		f:HookScript("OnEnter", StartGlow)
 		f:HookScript("OnLeave", StopGlow)
	end
end

S.ReskinTab = function(f)
	f:DisableDrawLayer("BACKGROUND")

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", 8, -3)
	bg:SetPoint("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bg)

	f:SetHighlightTexture(media.backdrop)
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 9, -4)
	hl:SetPoint("BOTTOMRIGHT", -9, 1)
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
	bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
	S.CreateBD(bu.bg, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT", bu.bg, 1, -1)
	tex:SetPoint("BOTTOMRIGHT", bu.bg, -1, 1)
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
	bg:SetPoint("TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", -18, 8)
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
		f:SetPoint("TOPRIGHT", -4, -4)
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
	bd:SetPoint("TOPLEFT", -2, 0)
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
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .2)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 4, -4)
	bd:SetPoint("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bd, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT", 5, -5)
	tex:SetPoint("BOTTOMRIGHT", -5, 5)
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
	ch:SetPoint("TOPLEFT", 4, -4)
	ch:SetPoint("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(r, g, b, .6)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 3, -3)
	bd:SetPoint("BOTTOMRIGHT", -3, 3)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bd, 0)
	f.bd = bd

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT", 4, -4)
	tex:SetPoint("BOTTOMRIGHT", -4, 4)
	tex:SetTexture(media.backdrop)
	tex:SetGradientAlpha(gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha)

	f:HookScript("OnEnter", colourRadio)
	f:HookScript("OnLeave", clearRadio)
end

S.ReskinSlider = function(f)
	f:SetBackdrop(nil)
	f.SetBackdrop = S.dummy

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 14, -2)
	bd:SetPoint("BOTTOMRIGHT", -15, 3)
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
	f.minus:SetSize(7, 1)
	f.minus:SetPoint("CENTER")
	f.minus:SetTexture(media.backdrop)
	f.minus:SetVertexColor(1, 1, 1)

	f.plus = f:CreateTexture(nil, "OVERLAY")
	f.plus:SetSize(1, 7)
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
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)
end

function S.ReskinFrame(f)
	if f.reskin == true then return end
	f.glow = CreateFrame("Frame", nil, f)
	f.glow:SetBackdrop({
		edgeFile = DB.GlowTex,
		edgeSize = 5,
	})
	f.glow:SetPoint("TOPLEFT", -6, 6)
	f.glow:SetPoint("BOTTOMRIGHT", 6, -6)
	f.glow:SetBackdropBorderColor(r, g, b)
	f.glow:SetAlpha(0)

	f:HookScript("OnEnter", StartGlow)
 	f:HookScript("OnLeave", StopGlow)
	f.reskin = true
end

S.ColourQuality = function(button, id)
	local quality, texture, _
	local quest = _G[button:GetName().."IconQuestTexture"]

	if id then
		quality, _, _, _, _, _, _, texture = select(3, GetItemInfo(id))
	end

	local glow = button.AuroraGlow
	if not glow then
		glow = button:CreateTexture(nil, "BACKGROUND")
		glow:SetPoint("TOPLEFT", -1, 1)
		glow:SetPoint("BOTTOMRIGHT", 1, -1)
		glow:SetTexture(media.backdrop)

		button.AuroraGlow = glow
	end

	if texture then
		local r, g, b

		if quest and quest:IsShown() then
			r, g, b = 1, 0, 0
		else
			r, g, b = GetItemQualityColor(quality)
			if r == 1 and g == 1 then r, g, b = 0, 0, 0 end
		end

		glow:SetVertexColor(r, g, b)
		glow:Show()
	else
		glow:Hide()
	end
end