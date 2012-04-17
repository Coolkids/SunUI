-- Engines
local S, _, _, DB = unpack(select(2, ...))
if DB.Nuke == true then return end

local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b

function S.MakeBG(Parent, Size)
	local BG = CreateFrame("Frame", nil, Parent)
	x = S.Scale(Size)
	BG:SetFrameLevel(0)
	BG:SetPoint("TOPLEFT", -x, x)
	BG:SetPoint("BOTTOMRIGHT", x, -x)
	BG:SetBackdrop({
		bgFile = DB.bgFile, insets = {left = x, right = x, top = x, bottom = x},
		edgeFile = DB.GlowTex, edgeSize = S.Scale(Size-1),
	})
	BG:SetBackdropColor(0, 0, 0, 0.6)
	BG:SetBackdropBorderColor(0, 0, 0, 1)
	return BG
end

function S.MakeFontString(Parent, FontSize)
	local Text = Parent:CreateFontString(nil, "OVERLAY")
	Text:SetFont(DB.Font, FontSize*S.Scale(1), "THINOUTLINE")
	return Text
end

function S.ToHex(r, g, b)
	if r then
		if type(r) == "table" then
			if r.r then
				r, g, b = r.r, r.g, r.b
			else
				r, g, b = unpack(r)
			end
		end
		return ("|cff%02x%02x%02x"):format(r*255, g*255, b*255)
	end
end
function S.RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end
function S.FormatTime(Time, Short)
	local Day = floor(Time/86400)
	local Hour = floor((Time-Day*86400)/3600)
	local Minute = floor((Time-Day*86400-Hour*3600)/60)
	local Second = floor(Time-Day*86400-Hour*3600-Minute*60)
	if not Short then
		if Time > 86400 then
			return Day.."d "..Hour.."m"		
		elseif Time > 3600 then
			return Hour.."h "..Minute.."m"
		elseif Time < 3600 and Time > 60 then
			return Minute.."m "..Second.."s"
		elseif Time < 60 and Time > 0 then	
			return Second.."s"
		else
			return "N/A"
		end
	else
		if Time >= 86400 then
			return format('%dd', floor(Time/86400 + 0.5))
		elseif Time >= 3600 then
			return format('%dh', floor(Time/3600 + 0.5))
		elseif Time >= 60 then
			return format('%dm', floor(Time/60))
		elseif Time >= 0 then 
			return format('%ds', floor(Time))
		else
			return "N/A"
		end
	end
end

function S.FormatMemory(Memory)
	local M = format("%.2f", Memory/1024)
	local K = floor(Memory-floor(Memory/1024))
	if Memory > 1024 then
		return M.."m "	
	elseif Memory > 0 and Memory < 1024 then
		return K.."k"
	else
		return "N/A"
	end	
end

local function CreateBD(f, a)
	
	f:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground", 
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", 
		edgeSize = S.mult, 
	})
	if a then
		f:SetBackdropColor(0, 0, 0, a)
	else
		f:SetBackdropColor(0, 0, 0, 0.6)
	end
	f:SetBackdropBorderColor(0, 0, 0)
end
S.CreateBD = CreateBD
local function CreatePulse(frame, speed, mult, alpha)
	frame.speed = speed or .05
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha)
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
S.CreatePulse = CreatePulse
local function CreateSD(parent, size, r, g, b, alpha, offset)
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
S.CreateSD = CreateSD
local function StartGlow(f)
	f:SetBackdropColor(r, g, b, .1)
	f:SetBackdropBorderColor(r, g, b)
	CreatePulse(f.glow)
end
S.StartGlow = StartGlow
local function StopGlow(f)
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(0, 0, 0)
	f.glow:SetScript("OnUpdate", nil)
	f.glow:SetAlpha(0)
end
S.StopGlow = StopGlow
function S.Reskin(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f:GetName() then
		local left = _G[f:GetName().."Left"]
		local middle = _G[f:GetName().."Middle"]
		local right = _G[f:GetName().."Right"]

		if left then left:SetAlpha(0) end
		if middle then middle:SetAlpha(0) end
		if right then right:SetAlpha(0) end
	end

	CreateBD(f, .0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT")
	tex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

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
end
function S.ReskinInput(f, height, width)
	local frame = f:GetName()
	_G[frame.."Left"]:Hide()
	if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
	if _G[frame.."Mid"] then _G[frame.."Mid"]:Hide() end
	_G[frame.."Right"]:Hide()
	CreateBD(f, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT")
	tex:SetTexture(DB.aurobackdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	if height then f:SetHeight(height) end
	if width then f:SetWidth(width) end
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
	CreateBD(bu.bg, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:Point("TOPLEFT", bu.bg)
	tex:Point("BOTTOMRIGHT", bu.bg)
	tex:SetTexture(DB.aurobackdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	local up = _G[frame.."ScrollUpButton"]
	local down = _G[frame.."ScrollDownButton"]

	up:Width(17)
	down:Width(17)
	
	S.Reskin(up)
	S.Reskin(down)
	
	up:SetDisabledTexture(DB.aurobackdrop)
	local dis1 = up:GetDisabledTexture()
	dis1:SetVertexColor(0, 0, 0, .4)
	dis1:SetDrawLayer("OVERLAY")
	
	down:SetDisabledTexture(DB.aurobackdrop)
	local dis2 = down:GetDisabledTexture()
	dis2:SetVertexColor(0, 0, 0, .4)
	dis2:SetDrawLayer("OVERLAY")

	local uptex = up:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture("Interface\\AddOns\\!SunUI\\Media\\arrow-up-active")
	uptex:Size(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture("Interface\\AddOns\\!SunUI\\Media\\arrow-down-active")
	downtex:Size(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
end
function S.MakeButton(Parent)
	local Button = CreateFrame("Button", nil, Parent)
	S.Reskin(Button)
	return Button
end
function S.SetBD(f, x, y, x2, y2)
	if not f then return end
	if f. ssb then return end
	local bg = CreateFrame("Frame", nil, f)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:Point("TOPLEFT", x, y)
		bg:Point("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(0)
	CreateBD(bg)
	CreateSD(bg, 6, 0, 0, 0, 1, 0)
	f.ssb = bg
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

	CreateBD(f, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT")
	tex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	local text = f:CreateFontString(nil, "OVERLAY")
	text:SetFont(DB.Font, 11*S.Scale(1), "THINOUTLINE")
	text:SetPoint("CENTER", 1, 1)
	text:SetText("x")

	f:HookScript("OnEnter", function(self) text:SetTextColor(1, .1, .1) end)
 	f:HookScript("OnLeave", function(self) text:SetTextColor(1, 1, 1) end)
end
function S.MakeMoveHandle(Frame, Text, key)
	local MoveHandle = CreateFrame("Frame", nil, UIParent)
	MoveHandle:SetSize(Frame:GetWidth(), Frame:GetHeight())
	MoveHandle:SetFrameStrata("HIGH")
	MoveHandle:SetBackdrop({bgFile = DB.Solid})
	MoveHandle:SetBackdropColor(0, 0, 0, 0.9)
	MoveHandle.Text = S.MakeFontString(MoveHandle, 10)
	MoveHandle.Text:SetPoint("CENTER")
	MoveHandle.Text:SetText(Text)
	MoveHandle:SetPoint(unpack(MoveHandleDB[key]))
	MoveHandle:EnableMouse(true)
	MoveHandle:SetMovable(true)
	MoveHandle:RegisterForDrag("LeftButton")
	MoveHandle:SetScript("OnDragStart", function(self) MoveHandle:StartMoving() end)
	MoveHandle:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		MoveHandleDB[key] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)
	MoveHandle:Hide()
	Frame:SetPoint("CENTER", MoveHandle)
	return MoveHandle
end
function S.MakeMove(Frame, Text, key, a)
	local MoveHandle = CreateFrame("Frame", nil, UIParent)
	MoveHandle:SetSize(Frame:GetWidth(), Frame:GetHeight())
	MoveHandle:SetScale(a)
	MoveHandle:SetFrameStrata("HIGH")
	MoveHandle:SetBackdrop({bgFile = DB.Solid})
	MoveHandle:SetBackdropColor(0, 0, 0, 0.9)
	if a < 0.5 then
	MoveHandle.Text = S.MakeFontString(MoveHandle, 10*(1+a))
	elseif a >= 0.5 and a < 1 then 
	MoveHandle.Text = S.MakeFontString(MoveHandle, 9)
	elseif a <= 1.5 and a >= 1 then
	MoveHandle.Text = S.MakeFontString(MoveHandle, 11)
	elseif a > 1.5 then
	MoveHandle.Text = S.MakeFontString(MoveHandle, 8)
	end
	MoveHandle.Text:SetPoint("CENTER")
	MoveHandle.Text:SetText(Text)
	MoveHandle:SetPoint(unpack(MoveHandleDB[key]))
	MoveHandle:EnableMouse(true)
	MoveHandle:SetMovable(true)
	MoveHandle:RegisterForDrag("LeftButton")
	MoveHandle:SetScript("OnDragStart", function(self) MoveHandle:StartMoving() end)
	MoveHandle:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		MoveHandleDB[key] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)
	MoveHandle:Hide()
	Frame:SetPoint("CENTER", MoveHandle)
	return MoveHandle
end
function S.Kill(object)
	if object.IsProtected then 
		if object:IsProtected() then
			error("Attempted to kill a protected object: <"..object:GetName()..">")
		end
	end
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = function() return end
	object:Hide()
end
 function S.StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Kill()
			else
				region:SetTexture(nil)
			end
		end
	end		
end
function S.UpdateSize(obj, width, height)
	if not obj then return end
	if width then obj:SetWidth(width) end
	if height then obj:SetHeight(height) end
end
local uiscale = SetUIScale()
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/uiscale
local function scale(x)
	return (mult*math.floor(x/mult+.5)) 
end
S.mult = mult
S.Scale = scale

function S.ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select('#', ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end

	local num = select('#', ...) / 3
	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end
function S.RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end
function S.ShortValue(v)
	if v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end
RoleUpdater = CreateFrame("Frame")
local function CheckRole(self, event, unit)
	local tree = GetPrimaryTalentTree()
	local resilience
	local resilperc = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	if resilperc > GetDodgeChance() and resilperc > GetParryChance() then
		resilience = true
	else
		resilience = false
	end
	if (DB.MyClass == "PALADIN" and tree == 1) or (DB.MyClass == "SHAMAN" and tree == 3) or (DB.MyClass == "PRIEST" and (tree == 1 or tree == 2)) or (DB.MyClass == "DRUID" and tree == 3) then
		DB.isHealer = true
	else
		DB.isHealer = false
	end
	if ((DB.MyClass == "PALADIN" and tree == 2) or 
	(DB.MyClass == "WARRIOR" and tree == 3) or 
	(DB.MyClass == "DEATHKNIGHT" and tree == 1)) and
	resilience == false or
	(DB.MyClass == "DRUID" and tree == 2 and GetBonusBarOffset() == 3) then
		DB.Role = "Tank"
	else
		local playerint = select(2, UnitStat("player", 4))
		local playeragi	= select(2, UnitStat("player", 2))
		local base, posBuff, negBuff = UnitAttackPower("player");
		local playerap = base + posBuff + negBuff;

		if (((playerap > playerint) or (playeragi > playerint)) and not (DB.MyClass == "SHAMAN" and tree ~= 1 and tree ~= 3) and not (UnitBuff("player", GetSpellInfo(24858)) or UnitBuff("player", GetSpellInfo(65139)))) or DB.MyClass == "ROGUE" or DB.MyClass == "HUNTER" or (DB.MyClass == "SHAMAN" and tree == 2) then
			DB.Role = "Melee"
		else
			DB.Role = "Caster"
		end
	end
end	
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:RegisterEvent("CHARACTER_POINTS_CHANGED")
RoleUpdater:RegisterEvent("UNIT_INVENTORY_CHANGED")
RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
RoleUpdater:SetScript("OnEvent", CheckRole)
CheckRole()
local function Size(frame, width, height)
	frame:SetSize(scale(width), scale(height or width))
end

local function Width(frame, width)
	frame:SetWidth(scale(width))
end

local function Height(frame, height)
	frame:SetHeight(scale(height))
end

local function Point(obj, arg1, arg2, arg3, arg4, arg5)
	-- anyone has a more elegant way for this?
	if type(arg1)=="number" then arg1 = scale(arg1) end
	if type(arg2)=="number" then arg2 = scale(arg2) end
	if type(arg3)=="number" then arg3 = scale(arg3) end
	if type(arg4)=="number" then arg4 = scale(arg4) end
	if type(arg5)=="number" then arg5 = scale(arg5) end

	obj:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local function CreateBorder(f, r, g, b, a)
	f:SetBackdrop({
		edgeFile = DB.Solid, 
		edgeSize = S.mult,
		insets = { left = -S.mult, right = -S.mult, top = -S.mult, bottom = -S.mult }
	})
	f:SetBackdropBorderColor(r or 0, g or 0, b or 0, a or 1)
end
local function CreateShadow(f, t, offset, thickness, texture)
	if f.shadow then return end
	
	local borderr, borderg, borderb, bordera = 0, 0, 0, 1
	local backdropr, backdropg, backdropb, backdropa =  .05, .05, .05, .9
	
	if t == "Background" then
		backdropa = 0.6
	elseif t == "UnitFrame" then 
		backdropa = 0.3
	else
		backdropa = 0
	end
	
	local border = CreateFrame("Frame", nil, f)
	border:SetFrameLevel(1)
	border:Point("TOPLEFT", -1, 1)
	border:Point("TOPRIGHT", 1, 1)
	border:Point("BOTTOMRIGHT", 1, -1)
	border:Point("BOTTOMLEFT", -1, -1)
	border:CreateBorder()
	f.border = border
	
	local shadow = CreateFrame("Frame", nil, border)
	shadow:SetFrameLevel(0)
	shadow:Point("TOPLEFT", -3, 3)
	shadow:Point("TOPRIGHT", 3, 3)
	shadow:Point("BOTTOMRIGHT", 3, -3)
	shadow:Point("BOTTOMLEFT", -3, -3)
	shadow:SetBackdrop( { 
		edgeFile = DB.GlowTex,
		bgFile =DB.Solid,
		edgeSize = scale(4),
		insets = {left = scale(4), right = scale(4), top = scale(4), bottom = scale(4)},
	})
	shadow:SetBackdropColor( backdropr, backdropg, backdropb, backdropa )
	shadow:SetBackdropBorderColor( borderr, borderg, borderb, bordera )
	f.shadow = shadow
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
local function StyleButton(button, setallpoints)
	if button.SetHighlightTexture and not button.hover then
		local hover = button:CreateTexture(nil, "OVERLAY")
		hover:SetTexture(1, 1, 1, 0.3)
		if setallpoints then
			hover:SetAllPoints()
		else
			hover:Point('TOPLEFT', 2, -2)
			hover:Point('BOTTOMRIGHT', -2, 2)
		end
		button.hover = hover
		button:SetHighlightTexture(hover)
	end
	
	if button.SetPushedTexture and not button.pushed then
		local pushed = button:CreateTexture(nil, "OVERLAY")
		pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
		if setallpoints then
			pushed:SetAllPoints()
		else
			pushed:Point('TOPLEFT', 2, -2)
			pushed:Point('BOTTOMRIGHT', -2, 2)
		end
		button.pushed = pushed
		button:SetPushedTexture(pushed)
	end
	
	if button.SetCheckedTexture and not button.checked then
		local checked = button:CreateTexture(nil, "OVERLAY")
		checked:SetTexture(23/255,132/255,209/255,0.5)
		if setallpoints then
			checked:SetAllPoints()
		else
			checked:Point('TOPLEFT', 2, -2)
			checked:Point('BOTTOMRIGHT', -2, 2)
		end
		button.checked = checked
		button:SetCheckedTexture(checked)
	end

	if button:GetName() and _G[button:GetName().."Cooldown"] then
		local cooldown = _G[button:GetName().."Cooldown"]
		cooldown:ClearAllPoints()
		if setallpoints then
			cooldown:SetAllPoints()
		else
			cooldown:Point('TOPLEFT', 2, -2)
			cooldown:Point('BOTTOMRIGHT', -2, 2)
		end
	end
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Size then mt.Size = Size end
	if not object.Point then mt.Point = Point end
	if not object.Width then mt.Width = Width end
	if not object.Height then mt.Height = Height end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.CreateShadow then mt.CreateShadow = CreateShadow end
	if not object.SetTemplate then mt.SetTemplate = SetTemplate end
	if not object.StyleButton then mt.StyleButton = StyleButton end
	if not object.CreateBD then mt.CreateBD = CreateBD end
	if not object.CreateSD then mt.CreateSD = CreateSD end
end
local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())
object = EnumerateFrames()

while object do
	if not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

