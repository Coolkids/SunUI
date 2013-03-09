local S, L, DB, _, C = unpack(select(2, ...))
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local _G =_G
local filename, fontHeight, _ = GameFontNormal:GetFont()
-- just for creating text
function S.MakeFontString(parent, size, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(DB.Font, size or fontHeight, fontStyle or "OUTLINE")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(S.mult, -S.mult)
	return fs
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
		local day, hour, minute = 86400, 3600, 60
		if Time >= day then
		  return format("%dd", floor(Time/day + 0.5)), Time % day
		elseif Time >= hour then
		  return format("%dh", floor(Time/hour + 0.5)), Time % hour
		elseif Time >= minute then
		  return format("%dm", floor(Time/minute + 0.5)), Time % minute
		elseif Time >= minute / 12 then
		  return floor(Time + 0.5) .. "s", (Time * 100 - floor(Time * 100))/100 .. "s"
		end
		return format("%.1fs", Time), (Time * 100 - floor(Time * 100))/100
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

function S.ShortValue(v)
	if v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end
local function CheckRole(self, event, unit)
	local tree = GetSpecialization()
	local role = tree and select(6, GetSpecializationInfo(tree))

	if role == "TANK" then
		DB.Role = "Tank"
	elseif role == "HEALER" then
		DB.Role = "Healer"
	elseif role == "DAMAGER" then
		local playerint = select(2, UnitStat("player", 4))
		local playeragi = select(2, UnitStat("player", 2))
		local base, posBuff, negBuff = UnitAttackPower("player")
		local playerap = base + posBuff + negBuff

		if (playerap > playerint) or (playeragi > playerint) then
			DB.Role = "Melee"
		else
			DB.Role = "Caster"
		end
	end
end
local RoleUpdater = CreateFrame("Frame")
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:RegisterEvent("UNIT_INVENTORY_CHANGED")
RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
RoleUpdater:SetScript("OnEvent", CheckRole)

function S.MakeMoveHandle(Frame, Text, key)
	local MoveHandle = CreateFrame("Frame", nil, UIParent)
	MoveHandle:Size(Frame:GetWidth(), Frame:GetHeight())
	MoveHandle:SetFrameStrata("HIGH")
	MoveHandle:SetBackdrop({
		bgFile = DB.Solid,
		edgeFile = DB.GlowTex, edgeSize = S.Scale(1),
		insets = {left = S.Scale(1), right = S.Scale(1), top = S.Scale(1), bottom = S.Scale(1)},
	})
	MoveHandle:SetBackdropColor(0, 0, 0, 0.9)
	MoveHandle:SetBackdropBorderColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b, 0.9)
	MoveHandle.Text = S.MakeFontString(MoveHandle)
	MoveHandle.Text:SetPoint("CENTER")
	MoveHandle.Text:SetText(Text)
	MoveHandle:SetPoint(unpack(SunUIConfig.db.profile.MoveHandleDB[key]))
	MoveHandle:EnableMouse(true)
	MoveHandle:SetMovable(true)
	MoveHandle:RegisterForDrag("LeftButton")
	MoveHandle:SetScript("OnDragStart", function(self) MoveHandle:StartMoving() end)
	MoveHandle:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		SunUIConfig.db.profile.MoveHandleDB[key] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)
	MoveHandle:Hide()
	Frame:SetPoint("CENTER", MoveHandle)
	return MoveHandle
end
function S.MakeMove(Frame, Text, key, a)
	local MoveHandle = CreateFrame("Frame", nil, UIParent)
	MoveHandle:Size(Frame:GetWidth(), Frame:GetHeight())
	MoveHandle:SetScale(a)
	MoveHandle:SetFrameStrata("HIGH")
	MoveHandle:SetBackdrop({
		bgFile = DB.Solid,
		edgeFile = DB.GlowTex, edgeSize = S.Scale(1),
		insets = {left = S.Scale(1), right = S.Scale(1), top = S.Scale(1), bottom = S.Scale(1)},
	})
	MoveHandle:SetBackdropColor(0, 0, 0, 0.9)
	MoveHandle:SetBackdropBorderColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b, 0.9)
	MoveHandle.Text = S.MakeFontString(MoveHandle)
	MoveHandle.Text:SetPoint("CENTER")
	MoveHandle.Text:SetText(Text)
	MoveHandle:SetPoint(unpack(SunUIConfig.db.profile.MoveHandleDB[key]))
	MoveHandle:EnableMouse(true)
	MoveHandle:SetMovable(true)
	MoveHandle:RegisterForDrag("LeftButton")
	MoveHandle:SetScript("OnDragStart", function(self) MoveHandle:StartMoving() end)
	MoveHandle:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		SunUIConfig.db.profile.MoveHandleDB[key] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)
	MoveHandle:Hide()
	Frame:SetPoint("CENTER", MoveHandle)
	return MoveHandle
end

function S.CreateShadow(p, f, t) 
	if f.sw then return end

	local borderr, borderg, borderb, bordera = 0, 0, 0, 1
	local backdropr, backdropg, backdropb, backdropa =  .05, .05, .05, .9

	if t == "Background" then
		backdropa = 0.6
	elseif t == "UnitFrame" then 
		backdropa = 0.3
	else
		backdropa = 0
	end

	local border = CreateFrame("Frame", nil, p)
	border:SetFrameLevel(1)
	border:SetPoint("TOPLEFT", f, -S.mult, S.mult)
	border:SetPoint("BOTTOMRIGHT", f, S.mult, -S.mult)
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
		edgeSize = S.Scale(4),
		insets = {left = S.Scale(4), right = S.Scale(4), top = S.Scale(4), bottom = S.Scale(4)},
	})
	shadow:SetBackdropColor( backdropr, backdropg, backdropb, backdropa )
	shadow:SetBackdropBorderColor( borderr, borderg, borderb, bordera )
	f.sw = shadow
end
function S.CreateBorder(p, f) 
	if f.border then return end
	local border = CreateFrame("Frame", nil, p)
	border:SetFrameLevel(1)
	border:SetPoint("TOPLEFT", f, -S.mult, S.mult)
	border:SetPoint("BOTTOMRIGHT", f, S.mult, -S.mult)
	border:CreateBorder(nil,nil,nil,0.5)
	f.border = border
end
function S.FadeOutFrameDamage(p, t, show)  --隐藏
	if type(p) == "table" then 
		if p:GetAlpha()>0 then
			local fadeInfo = {}
			fadeInfo.mode = "OUT"
			fadeInfo.timeToFade = t or 1.5
			if not show then
				fadeInfo.finishedFunc = function() p:Hide() end 
			end
			fadeInfo.startAlpha = p:GetAlpha()
			fadeInfo.endAlpha = 0
			UIFrameFade(p, fadeInfo)
		end 
		return
	end
	if not _G[p] then print("SunUI:没有发现"..p.."这个框体")return end
	if _G[p]:GetAlpha()>0 then
		local fadeInfo = {}
		fadeInfo.mode = "OUT"
		fadeInfo.timeToFade = t or 1.5
		if not show then
			fadeInfo.finishedFunc = function() _G[p]:Hide() end 
		end
		fadeInfo.startAlpha = _G[p]:GetAlpha()
		fadeInfo.endAlpha = 0
		UIFrameFade(_G[p], fadeInfo)
	end 
end

function S.CreateBack(f, orientation, a, b, r, g, b)
	local uistyle = SunUIConfig.db.profile.MiniDB.uistyle
	local gradient = f:CreateTexture(nil, "BACKGROUND", -1)
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture("Interface\\Buttons\\WHITE8x8")
	if uistyle == "plane" then
		gradient:SetVertexColor(r or 0, g or 0, b or 0, 0.5)
	else
		if orientation then
			gradient:SetGradientAlpha("HORIZONTAL",  0.5, 0.5, 0.5, a or 0.5, 0, 0, 0, b or 0)
		else
			gradient:SetGradientAlpha("VERTICAL",  0.5, 0.5, 0.5, a or 0.5, 0, 0, 0, b or 0)
		end
	end
	f.gradient = gradient
end

function S.CreateBack2(f, orientation, r, g, b, a, r2, g2, b2, a2)
	local uistyle = SunUIConfig.db.profile.MiniDB.uistyle
	local gradient = f:CreateTexture(nil, "BACKGROUND", -1)
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture("Interface\\Buttons\\WHITE8x8")
	if uistyle == "plane" then
		gradient:SetVertexColor(r or 0, g or 0, b or 0, 0.5)
	else
		if orientation then
			gradient:SetGradientAlpha("HORIZONTAL", r, g, b, a, r2, g2, b2, a2)
		else
			gradient:SetGradientAlpha("VERTICAL", r, g, b, a, r2, g2, b2, a2)
		end
	end
	f.gradient = gradient
end

function S.CreateBackTexture(f, orientation, a, b, r, g, b)
	local uistyle = SunUIConfig.db.profile.MiniDB.uistyle
	f:SetTexture("Interface\\Buttons\\WHITE8x8")
	if uistyle == "plane" then
		f:SetVertexColor(r or 0, g or 0, b or 0, 0.4)
	else
		if orientation then
			f:SetGradientAlpha("HORIZONTAL",  0.5, 0.5, 0.5, a or 0.5, 0, 0, 0, b or 0)
		else
			f:SetGradientAlpha("VERTICAL",  0.5, 0.5, 0.5, a or 0.5, 0, 0, 0, b or 0)
		end
	end
end

function S.CreateTop(f, r, g, b, orientation, a)
	local uistyle = SunUIConfig.db.profile.MiniDB.uistyle
	if uistyle == "plane" then
		f:SetVertexColor(r, g, b, a)
	else
		if orientation then
			f:SetGradientAlpha("HORIZONTAL", r, g, b, a or 1, r/3, g/3, b/3, a or 1)
		else
			f:SetGradientAlpha("VERTICAL", r, g, b, a or 1, r/3, g/3, b/3, a or 1)
		end
	end
end
function S.CreateSpark(f, w, h)
	local spark =  f:CreateTexture(nil, "OVERLAY")
	spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
	spark:SetBlendMode("ADD")
	spark:SetAlpha(.8)
	spark:SetPoint("TOPLEFT", f:GetStatusBarTexture(), "TOPRIGHT", -w, h)
	spark:SetPoint("BOTTOMRIGHT", f:GetStatusBarTexture(), "BOTTOMRIGHT", w, -h)
end
function S.CreateMark(f, orientation)
	local spark =  f:CreateTexture(nil, "OVERLAY", 1)
	spark:SetTexture("Interface\\Buttons\\WHITE8x8")
	spark:SetVertexColor(0, 0, 0)
	if not orientation then
		spark:Width(1)
		spark:Point("TOPLEFT", f:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		spark:Point("BOTTOMLEFT", f:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	else
		spark:Height(1)
		spark:Point("TOPLEFT", f:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		spark:Point("TOPRIGHT", f:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
	end
end

function S.CreateBackdropTexture(f)
	local tex = f:CreateTexture(nil, "BACKGROUND")
    tex:SetDrawLayer("BACKGROUND", 1)
	tex:SetInside(f, 1, 1)
	tex:SetTexture("Interface\\AddOns\\SunUI\\media\\gloss")
	--tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
	tex:SetVertexColor(0.1, 0.1, 0.1)
	tex:SetAlpha(0.8)
	f.backdropTexture = tex
end

local smoothing = {}
local function Smooth(self, value)
	local _, maxv = self:GetMinMaxValues()
	if value == self:GetValue() or (self.prevMax and self.prevMax ~= maxv) then
		-- finished smoothing/max health updated
		smoothing[self] = nil
		self:SetValue_(value)
	else
		smoothing[self] = value
	end

	self.prevMax = maxv
end

function S.SmoothBar(bar)
	if not bar.SetValue_ then
		bar.SetValue_ = bar.SetValue
		bar.SetValue = Smooth
	end
end

local SmoothUpdate = CreateFrame("Frame")
SmoothUpdate:SetScript("OnUpdate", function()
	local limit = 30/GetFramerate()
	local speed = 1/12

	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + math.min((value-cur)*speed, math.max(value-cur, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
		if (cur == value or math.abs(new - value) < 1) then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)