-- Engines
local S, _, _, DB = unpack(select(2, ...))
local Launch = CreateFrame("Frame")
Launch:RegisterEvent("PLAYER_ENTERING_WORLD")
Launch:SetScript("OnEvent", function(self, event)
	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			for _, v in pairs({GetAddOnInfo(i)}) do
				if v and type(v) == 'string' and (v:lower():find("BigFoot") or v:lower():find("Duowan") or v:lower():find("163UI") or v:lower():find("FishUI") or v:lower():find("大脚") or v:lower():find("大腳") or v:lower():find("多玩")) then
					print("侦测到您正在使用大脚或者魔盒,为了让您用的舒适所以插件自我关闭掉.如想使用本插件请完全删除大脚或者魔盒")
					return end
				end
			end
		end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD" )
end)
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b

function S.MakeShadow(Parent, Size)
	local Shadow = CreateFrame("Frame", nil, Parent)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Size, -Size)
	Shadow:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = Size})
	Shadow:SetBackdropColor( .05, .05, .05, .9)
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end

function S.MakeBorder(Parent, Size)
	local Border = CreateFrame("Frame", nil, Parent)
	Border:SetFrameLevel(0)
	Border:SetPoint("TOPLEFT", -Size, Size)
	Border:SetPoint("BOTTOMRIGHT", Size, -Size)
	Border:SetBackdrop({edgeFile = DB.Solid, edgeSize = Size})
	Border:SetBackdropBorderColor(0, 0, 0, 1)
	return Border
end

function S.MakeBG(Parent, Size)
	local BG = CreateFrame("Frame", nil, Parent)
	BG:SetFrameLevel(0)
	BG:SetPoint("TOPLEFT", -Size, Size)
	BG:SetPoint("BOTTOMRIGHT", Size, -Size)
	BG:SetBackdrop({
		bgFile = DB.bgFile, insets = {left = Size, right = Size, top = Size, bottom = Size},
		edgeFile = DB.GlowTex, edgeSize = Size-1,
	})
	BG:SetBackdropColor(0, 0, 0, 0.6)
	BG:SetBackdropBorderColor(0, 0, 0, 1)
	return BG
end

function S.MakeTexShadow(Parent, Anchor, Size)
	local Shadow = CreateFrame("Frame", nil, Parent)
	Shadow:SetPoint("TOPLEFT", Anchor, -Size or 3, Size or 3)
	Shadow:SetPoint("BOTTOMRIGHT", Anchor, Size or 3, -Size or 3)
	Shadow:SetFrameLevel(1)
	Shadow:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = Size or 3})
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end

function S.MakeFontString(Parent, FontSize)
	local Text = Parent:CreateFontString(nil, "OVERLAY")
	Text:SetFont(DB.Font, FontSize*S.Scale(1), "THINOUTLINE")
	return Text
end

function S.SVal(Val)
    if Val >= 1e6 then
        return ("%.1fm"):format(Val/1e6):gsub("%.?0+([km])$", "%1")
    elseif Val >= 1e4 then
        return ("%.1fk"):format(Val/1e3):gsub("%.?0+([km])$", "%1")
    else
        return Val
    end
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
			return format('%dm', floor(Time/60 + 0.5))
		elseif Time >= 0 then 
			return format('%ds', floor(Time + 0.5))
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
		edgeSize = 1, 
	})
	f:SetBackdropColor(0, 0, 0, a or 0.6)
	f:SetBackdropBorderColor(0, 0, 0)
end
function S.CreateBD(f, a)
	f:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground", 
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", 
		edgeSize = 1, 
	})
	f:SetBackdropColor(0, 0, 0, a or 0.6)
	f:SetBackdropBorderColor(0, 0, 0)
end
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
local function CreateSD(parent, size, r, g, b, alpha, offset)
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.offset = offset or 0
	sd:SetBackdrop({
		edgeFile = DB.GlowTex,
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(0.7 or 1)
end
function S.CreateSD(parent, size, r, g, b, alpha, offset)
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.offset = offset or 0
	sd:SetBackdrop({
		edgeFile = DB.GlowTex,
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(0.7 or 1)
end
local function StartGlow(f)
	f:SetBackdropColor(r, g, b, .1)
	f:SetBackdropBorderColor(r, g, b)
	CreatePulse(f.glow)
end
local function StopGlow(f)
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(0, 0, 0)
	f.glow:SetScript("OnUpdate", nil)
	f.glow:SetAlpha(0)
end
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
		edgeSize = 5,
	})
	f.glow:SetPoint("TOPLEFT", -6, 6)
	f.glow:SetPoint("BOTTOMRIGHT", 6, -6)
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
	bu:SetWidth(17)

	bu.bg = CreateFrame("Frame", nil, f)
	bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
	CreateBD(bu.bg, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT", bu.bg)
	tex:SetPoint("BOTTOMRIGHT", bu.bg)
	tex:SetTexture(DB.aurobackdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	local up = _G[frame.."ScrollUpButton"]
	local down = _G[frame.."ScrollDownButton"]

	up:SetWidth(17)
	down:SetWidth(17)
	
	S.Reskin(up)
	S.Reskin(down)
	
	up:SetDisabledTexture(DB.aurobackdrop)
	local dis1 = up:GetDisabledTexture()
	dis1:SetVertexColor(0, 0, 0, .3)
	dis1:SetDrawLayer("OVERLAY")
	
	down:SetDisabledTexture(DB.aurobackdrop)
	local dis2 = down:GetDisabledTexture()
	dis2:SetVertexColor(0, 0, 0, .3)
	dis2:SetDrawLayer("OVERLAY")

	local uptex = up:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture("Interface\\AddOns\\s_Core\\Media\\arrow-up-active")
	uptex:SetSize(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture("Interface\\AddOns\\s_Core\\Media\\arrow-down-active")
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
end
function S.MakeButton(Parent)
	local Button = CreateFrame("Button", nil, Parent)
	S.Reskin(Button)
	return Button
end
function S.SetBD(f, x, y, x2, y2)
	local bg = CreateFrame("Frame", nil, f)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(0)
	--(parent, size, r, g, b, alpha, offset)
	CreateBD(bg, 0.4)
	CreateSD(bg)
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
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/MiniDB["uiScale"]
local function scale(x)
	return (mult*math.floor(x/mult+.5)) --(1/GetCVar("uiScale"))*x
end
S.mult = mult
S.Scale = scale
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
local function SetTemplate(f, t, texture)
	f:SetBackdrop({
	  bgFile = DB.Statusbar,
	})
	if t == "Transparent" then 
		f:SetBackdropColor(0.05, 0.05, 0.05, 0.6)
	else
		f:SetBackdropColor( .05, .05, .05, .9)
	end
	f:SetBackdropBorderColor (0, 0, 0, 1)
end
local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Size then mt.Size = Size end
	if not object.Point then mt.Point = Point end
	if not object.Width then mt.Width = Width end
	if not object.Height then mt.Height = Height end
	if not object.SetTemplate then mt.SetTemplate = SetTemplate end
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