local S, C, L, DB = unpack(select(2, ...))
local alpha = .5
local _G = _G
--[[ local classcolours = {
	["HUNTER"] = { r = 0.58, g = 0.86, b = 0.49 },
	["WARLOCK"] = { r = 0.6, g = 0.47, b = 0.85 },
	["PALADIN"] = { r = 1, g = 0.22, b = 0.52 },
	["PRIEST"] = { r = 0.8, g = 0.87, b = .9 },
	["MAGE"] = { r = 0, g = 0.76, b = 1 },
	["MONK"] = {r = 0.0, g = 1.00 , b = 0.59},
	["ROGUE"] = { r = 1, g = 0.91, b = 0.2 },
	["DRUID"] = { r = 1, g = 0.49, b = 0.04 },
	["SHAMAN"] = { r = 0, g = 0.6, b = 0.6 };
	["WARRIOR"] = { r = 0.9, g = 0.65, b = 0.45 },
	["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
} ]]

local media = {
	["arrowUp"] = "Interface\\AddOns\\SunUI\\media\\arrow-up-active",
	["arrowDown"] = "Interface\\AddOns\\SunUI\\media\\arrow-down-active",
	["arrowLeft"] = "Interface\\AddOns\\SunUI\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\SunUI\\media\\arrow-right-active",
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground",
	["checked"] = "Interface\\AddOns\\SunUI\\media\\CheckButtonHilight",
	["glow"] = "Interface\\AddOns\\SunUI\\media\\glowTex",
}
local frames = {}

-- [[ Functions ]]

local _, class = UnitClass("player")
local r, g, b
if CUSTOM_CLASS_COLORS then
	r, g, b = CUSTOM_CLASS_COLORS[class].r, CUSTOM_CLASS_COLORS[class].g, CUSTOM_CLASS_COLORS[class].b
else
	r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
end

function S.CreateBD(f, a)
	f:SetBackdrop({
		bgFile = media.backdrop,
		edgeFile = media.backdrop,
		edgeSize = S.mult,
	})
	f:SetBackdropColor(0, 0, 0, a or alpha)
	f:SetBackdropBorderColor(0, 0, 0)
	if not a then tinsert(frames, f) end
end

function S.CreateBG(frame)
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:Point("TOPLEFT", frame, -1, 1)
	bg:Point("BOTTOMRIGHT", frame, 1, -1)
	bg:SetTexture(media.backdrop)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

function S.CreateSD(parent, size, r, g, b, alpha, offset)
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
end

function  S.CreateGradient(f)
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT")
	tex:SetTexture(media.backdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
end

function S.CreatePulse(frame)
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

function S.Reskin(f, noGlow)
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

	S.CreateGradient(f)

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

function S.CreateTab(f)
	if f.ct then return end
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
	f.ct = true
end

function S.ReskinScroll(f)
	local frame = f:GetName()

	if _G[frame.."Track"] then _G[frame.."Track"]:Hide() end
	if _G[frame.."BG"] then _G[frame.."BG"]:Hide() end
	if _G[frame.."Top"] then _G[frame.."Top"]:Hide() end
	if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
	if _G[frame.."Bottom"] then _G[frame.."Bottom"]:Hide() end

	local bu = _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:Width(17)

	bu.bg = CreateFrame("Frame", nil, f)
	bu.bg:Point("TOPLEFT", bu, 0, -2)
	bu.bg:Point("BOTTOMRIGHT", bu, 0, 4)
	S.CreateBD(bu.bg, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT", bu.bg)
	tex:SetPoint("BOTTOMRIGHT", bu.bg)
	tex:SetTexture(media.backdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	local up = _G[frame.."ScrollUpButton"]
	local down = _G[frame.."ScrollDownButton"]

	up:Width(17)
	down:Width(17)

	S.Reskin(up)
	S.Reskin(down)

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
	uptex:Size(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
end

local function colourArrow(f)
	if f:IsEnabled() then
		f.downtex:SetVertexColor(r, g, b)
	end
end

local function clearArrow(f)
	f.downtex:SetVertexColor(1, 1, 1)
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
function S.ReskinDropDown(f)
	local frame = f:GetName()

	local left = _G[frame.."Left"]
	local middle = _G[frame.."Middle"]
	local right = _G[frame.."Right"]

	if left then left:SetAlpha(0) end
	if middle then middle:SetAlpha(0) end
	if right then right:SetAlpha(0) end

	local down = _G[frame.."Button"]

	down:Size(20, 20)
	down:ClearAllPoints()
	down:Point("RIGHT", -18, 2)

	S.Reskin(down, true)

	down:SetDisabledTexture(media.backdrop)
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(media.arrowDown)
	downtex:Size(8, 8)
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
	f.text:SetTextColor(1, .1, .1)
end

local function clearClose(f)
	f.text:SetTextColor(1, 1, 1)
end

function S.ReskinClose(f, a1, p, a2, x, y)
	f:Size(17, 17)

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
	text:SetFont(DB.Font, 14, "THINOUTLINE")
	text:SetPoint("CENTER", 1, 1)
	text:SetText("x")
	f.text = text

	f:HookScript("OnEnter", colourClose)
 	f:HookScript("OnLeave", clearClose)
end

function S.ReskinInput(f, height, width)
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

function S.ReskinArrow(f, direction)
	f:Size(18, 18)
	S.Reskin(f)

	f:SetDisabledTexture(media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = f:CreateTexture(nil, "ARTWORK")
	tex:Size(8, 8)
	tex:SetPoint("CENTER")

	tex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-"..direction.."-active")
end

function S.ReskinCheck(f)
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
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

function S.ReskinRadio(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture(media.backdrop)
	f:SetCheckedTexture(media.backdrop)

	local hl = f:GetHighlightTexture()
	hl:Point("TOPLEFT", 4, -4)
	hl:Point("BOTTOMRIGHT", -4, 4)
	hl:SetVertexColor(r, g, b, .3)

	local ch = f:GetCheckedTexture()
	ch:Point("TOPLEFT", 4, -4)
	ch:Point("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(r, g, b, .6)

	local bd = CreateFrame("Frame", nil, f)
	bd:Point("TOPLEFT", 3, -3)
	bd:Point("BOTTOMRIGHT", -3, 3)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bd, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:Point("TOPLEFT", 4, -4)
	tex:Point("BOTTOMRIGHT", -4, 4)
	tex:SetTexture(media.backdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
end

function S.ReskinSlider(f)
	f:SetBackdrop(nil)
	f.SetBackdrop = DB.dummy

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

function S.ReskinExpandOrCollapse(f)
	f:Size(13, 13)
	S.Reskin(f, true)
	f.SetNormalTexture = DB.dummy

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
end

function S.SetBD(f, x, y, x2, y2)
	if f.sbd then return end
	local bg = CreateFrame("Frame", nil, f)
	local frameLevel = f:GetFrameLevel() > 1 and f:GetFrameLevel() or 1
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:Point("TOPLEFT", x, y)
		bg:Point("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(frameLevel)
	S.CreateBD(bg)
	S.CreateSD(bg, 4+S.mult, 0, 0, 0, 1, 0)
	f.sbd = true
end

function S.ReskinPortraitFrame(f, isButtonFrame)
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

function S.CreateBDFrame(f, a)
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