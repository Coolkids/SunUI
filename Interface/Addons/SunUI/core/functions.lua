local S, C, L, DB = unpack(select(2, ...))
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local _G =_G
local _
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
local roles = {
	["PALADIN"] = {
		[1] = "Caster",
		[2] = "Tank",
		[3] = "Melee",
	},
	["PRIEST"] = {
		[1] = "Caster",
		[2] = "Caster",
		[3] = "Caster",
	},
	["WARLOCK"] = {
		[1] = "Caster",
		[2] = "Caster",
		[3] = "Caster",
	},
	["WARRIOR"] = {
		[1] = "Melee",
		[2] = "Melee",
		[3] = "Tank",	
	},
	["HUNTER"] = {
		[1] = "Melee",
		[2] = "Melee",
		[3] = "Melee",
	},
	["SHAMAN"] = {
		[1] = "Caster",
		[2] = "Melee",
		[3] = "Caster",	
	},
	["ROGUE"] = {
		[1] = "Melee",
		[2] = "Melee",
		[3] = "Melee",
	},
	["MAGE"] = {
		[1] = "Caster",
		[2] = "Caster",
		[3] = "Caster",
	},
	["DEATHKNIGHT"] = {
		[1] = "Tank",
		[2] = "Melee",
		[3] = "Melee",	
	},
	["DRUID"] = {
		[1] = "Caster",
		[2] = "Melee",
		[3] = "Tank",	
		[4] = "Caster"
	},
	["MONK"] = {
		[1] = "Tank",
		[2] = "Caster",
		[3] = "Melee",	
	},
}
RoleUpdater = CreateFrame("Frame")
local function CheckRole(self, event, unit)
	local tree = GetSpecialization()
	DB.Role = roles[DB.MyClass][tree]
end	
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:RegisterEvent("CHARACTER_POINTS_CHANGED")
RoleUpdater:RegisterEvent("UNIT_INVENTORY_CHANGED")
RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
RoleUpdater:SetScript("OnEvent", CheckRole)
CheckRole()

function S.MakeMoveHandle(Frame, Text, key)
	local MoveHandle = CreateFrame("Frame", nil, UIParent)
	MoveHandle:SetSize(Frame:GetWidth(), Frame:GetHeight())
	MoveHandle:SetFrameStrata("HIGH")
	MoveHandle:SetBackdrop({bgFile = DB.Solid})
	MoveHandle:SetBackdropColor(0, 0, 0, 0.9)
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
	MoveHandle:SetSize(Frame:GetWidth(), Frame:GetHeight())
	MoveHandle:SetScale(a)
	MoveHandle:SetFrameStrata("HIGH")
	MoveHandle:SetBackdrop({bgFile = DB.Solid})
	MoveHandle:SetBackdropColor(0, 0, 0, 0.9)
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

function S.CreateBack(f, orientation, a)
	local gradient = f:CreateTexture(nil, "BACKGROUND", -1)
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture(DB.Statusbar)
	if orientation then
		gradient:SetGradientAlpha("HORIZONTAL",  0, 0, 0, a or 0.5, .35, .35, .35, a or .45)
	else
		gradient:SetGradientAlpha("VERTICAL",  0, 0, 0, a or 0.5, .35, .35, .35, a or .45)
	end
end
function S.CreateTop(f, r, g, b, orientation, a)
	if orientation then
		f:SetGradientAlpha("HORIZONTAL", r, g, b, a or 1, r/2, g/2, b/2, a or 1)
	else
		f:SetGradientAlpha("VERTICAL", r, g, b, a or 1, r/2, g/2, b/2, a or 1)
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
function S.CreateMark(f, w)
	local spark =  f:CreateTexture(nil, "OVERLAY", 1)
	spark:SetTexture("Interface\\Buttons\\WHITE8x8")
	spark:Size(1, w or f:GetHeight())
	spark:SetVertexColor(0, 0, 0)
	spark:SetPoint("LEFT", f:GetStatusBarTexture(), "RIGHT", 0, 0)
end
local players = {
	["Cooikid"] = true,
	["Coolkid"] = true,
	["Coolkids"] = true,
	["Coolkid"] = true,
	["Kenans"] = true,
	["月殤軒"] = true,
	["月殤玄"] = true,
	["月殤妶"] = true,
	["月殤玹"] = true,
	["月殤旋"] = true,
	["月殤璇"] = true,
}
function S.IsCoolkid()
	if players[DB.PlayerName] == true then 
		return true 
	else	
		return false	
	end
end