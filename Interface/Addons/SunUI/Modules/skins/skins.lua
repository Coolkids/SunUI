local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:NewModule("Skins", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
A.modName = L["插件美化"]

A.SkinFuncs = {}
A.SkinFuncs["SunUI"] = {}

local alpha
local backdropcolorr, backdropcolorg, backdropcolorb
local backdropfadecolorr, backdropfadecolorg, backdropfadecolorb
local bordercolorr, bordercolorg, bordercolorb

local r, g, b
if CUSTOM_CLASS_COLORS then
	r, g, b =  CUSTOM_CLASS_COLORS[S.myclass].r, CUSTOM_CLASS_COLORS[S.myclass].g, CUSTOM_CLASS_COLORS[S.myclass].b
else
	r, g, b =  RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b
end

A["media"] = {
	["checked"] = "Interface\\AddOns\\SunUI\\media\\CheckButtonHilight",
	["arrowUp"] = "Interface\\AddOns\\SunUI\\media\\arrow-up-active",
	["arrowDown"] = "Interface\\AddOns\\SunUI\\media\\arrow-down-active",
	["arrowLeft"] = "Interface\\AddOns\\SunUI\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\SunUI\\media\\arrow-right-active",
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground",
}



function A:CreateStripesThin(f)
	if not f then return end
	f.stripesthin = f:CreateTexture(nil, "BACKGROUND", nil, 1)
	f.stripesthin:SetAllPoints()
	f.stripesthin:SetTexture([[Interface\AddOns\SunUI\media\StripesThin]], true)
	f.stripesthin:SetHorizTile(true)
	f.stripesthin:SetVertTile(true)
	f.stripesthin:SetBlendMode("ADD")
end

function A:CreateBackdropTexture(f)
	if not f then return end
	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetDrawLayer("BACKGROUND", 1)
	tex:SetInside(f, 1, 1)
	tex:SetTexture(S["media"].gloss)
	--tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
	tex:SetVertexColor(backdropcolorr, backdropcolorg, backdropcolorb)
	tex:SetAlpha(0.8)
	f.backdropTexture = tex
end

function A:CreateBD(f, a)
	if not f then return end
	f:SetBackdrop({
		bgFile = S["media"].blank, 
		edgeFile = S["media"].blank, 
		edgeSize = S.mult, 
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
	bg:SetTexture(S["media"].blank)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

function A:CreateSD(parent, size, r, g, b, alpha, offset)
	if not parent then return end
	A:CreateStripesThin(parent)

	if S.global.general.theme~="Shadow" then return end
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.size = sd.size - 5
	sd.offset = offset or 0
	sd:Point("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:Point("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:CreateShadow()
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
	if not f:IsEnabled() then return end
	f:SetBackdropColor(r, g, b, .2)
	f:SetBackdropBorderColor(r, g, b)
	if S.global.general.theme == "Shadow" then
		f.glow:SetAlpha(1)
		A:CreatePulse(f.glow)
	end
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
		f:SetHighlightTexture("")
		f:SetPushedTexture("")
		f:SetDisabledTexture("")
	else
		f:SetNormalTexture("")
		f:SetHighlightTexture("")
		f:SetPushedTexture("")
		f:SetDisabledTexture("")
	end
	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	f:SetTemplate("Default", true)

	if not noGlow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
			edgeFile = S["media"].glow,
			edgeSize = S:Scale(4),
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

	local bg = CreateFrame("Frame", nil, f)
	bg:Point("TOPLEFT", 8, -3)
	bg:Point("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	A:CreateBD(bg)

	f:SetHighlightTexture(S["media"].blank)
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
	A:CreateBD(bu.bg, 0)
	A:CreateBackdropTexture(f)
	f.backdropTexture:SetInside(bu.bg, 1, 1)

	local up = _G[frame.."ScrollUpButton"]
	local down = _G[frame.."ScrollDownButton"]

	up:Width(17)
	down:Width(17)

	A:Reskin(up)
	A:Reskin(down)

	up:SetDisabledTexture(S["media"].blank)
	local dis1 = up:GetDisabledTexture()
	dis1:SetVertexColor(0, 0, 0, .3)
	dis1:SetDrawLayer("OVERLAY")

	down:SetDisabledTexture(S["media"].blank)
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

	down:SetDisabledTexture(S["media"].blank)
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

	-- local text = f:CreateFontString(nil, "OVERLAY")
	-- text:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
	-- text:Point("CENTER", 2, 1)
	-- text:SetText("x")

	-- f:HookScript("OnEnter", function(self) text:SetTextColor(1, .1, .1) end)
	-- f:HookScript("OnLeave", function(self) text:SetTextColor(1, 1, 1) end)
end

function A:ReskinInput(f, height, width)
	if not f then return end
	local frame = f:GetName()
	if frame then
		if _G[frame.."Left"] then _G[frame.."Left"]:Hide() end
		if _G[frame.."Right"] then _G[frame.."Right"]:Hide() end
		if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
		if _G[frame.."Mid"] then _G[frame.."Mid"]:Hide() end
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

	f:SetDisabledTexture(S["media"].blank)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = f:CreateTexture(nil, "ARTWORK")
	tex:Size(8, 8)
	tex:SetPoint("CENTER")

	tex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-"..direction.."-active")
end

function A:ReskinCheck(f)
	if not f then return end
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(S["media"].blank)
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
	ck:SetPoint("TOPLEFT", 5, -5)
	ck:SetPoint("BOTTOMRIGHT", -5, 5)
end

function A:ReskinSlider(f)
	if not f then return end
	f:SetBackdrop(nil)
	f.SetBackdrop = S.dummy

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

function A:RegisterSkin(name, loadFunc)
	if name == 'SunUI' then
		tinsert(self.SkinFuncs["SunUI"], loadFunc)
	else
		self.SkinFuncs[name] = loadFunc
	end
end

function A:ADDON_LOADED(event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") or addon == "SunUI" then return end
	if self.SkinFuncs[addon] then
		self.SkinFuncs[addon]()
		self.SkinFuncs[addon] = nil
	end
end

function A:PLAYER_ENTERING_WORLD(event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") then return end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	for t, skinfunc in pairs(self.SkinFuncs["SunUI"]) do
		if skinfunc then
			skinfunc()
		end
	end
	wipe(self.SkinFuncs["SunUI"])
end

function A:Initialize()
	A["media"].backdrop = S["media"].normal
	backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, alpha = unpack(S["media"].backdropfadecolor)
	backdropcolorr, backdropcolorg, backdropcolorb = unpack(S["media"].backdropcolor)
	bordercolorr, bordercolorg, bordercolorb = unpack(S["media"].bordercolor)
	for addon, loadFunc in pairs(self.SkinFuncs) do
		if addon ~= "SunUI" then
			if IsAddOnLoaded(addon) then
				loadFunc()
				self.SkinFuncs[addon] = nil
			end
		end
	end

	A:RegisterEvent("ADDON_LOADED")
	A:RegisterEvent("PLAYER_ENTERING_WORLD")
end

S:RegisterModule(A:GetName())

function A:CreateMark(f, orientation)
	local spark =  f:CreateTexture(nil, "OVERLAY", 1)
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

function A:CreateShadow(p, f, t, thickness) 
	if p.shadow then return end

	local borderr, borderg, borderb = 0, 0, 0
    local backdropr, backdropg, backdropb, backdropa = unpack(S["media"].backdropcolor)
	local frameLevel = p:GetFrameLevel() > 1 and p:GetFrameLevel() - 1 or 1
	local thickness = thickness or 4
	local offset = thickness - 1

    if t == "Background" then
        backdropr, backdropg, backdropb, backdropa = unpack(S["media"].backdropfadecolor)
    else
        backdropa = 0
    end

	local border = CreateFrame("Frame", nil, p)
	border:SetFrameLevel(frameLevel)
	border:SetOutside(f, 1, 1)
    border:SetTemplate("Border")
	f.border = border

	local shadow = CreateFrame("Frame", nil, border)
	shadow:SetFrameLevel(frameLevel - 1)
	shadow:SetOutside(border, offset, offset)
	shadow:SetBackdrop( {
		edgeFile = S.global.general.theme == "Shadow" and S["media"].glow or nil,
        bgFile = S["media"].blank, 
		edgeSize = S:Scale(thickness),
        tile = false,
        tileSize = 0,
		insets = {left = S:Scale(thickness), right = S:Scale(thickness), top = S:Scale(thickness), bottom = S:Scale(thickness)},
	})
	shadow:SetBackdropColor( backdropr, backdropg, backdropb, backdropa )
	shadow:SetBackdropBorderColor( borderr, borderg, borderb )
	p.shadow = shadow
end

function A:ReskinFrame(f)
	if f.reskin == true then return end
	f.glow = CreateFrame("Frame", nil, f)
	f.glow:SetBackdrop({
		edgeFile = S["media"].glow,
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