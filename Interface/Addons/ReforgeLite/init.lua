local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/0.7
local reloadborder = CreateFrame("Frame")   
reloadborder:RegisterEvent("PLAYER_ENTERING_WORLD")
reloadborder:RegisterEvent("UI_SCALE_CHANGED")
reloadborder:SetScript("OnEvent", function()
   reloadborder:UnregisterEvent("PLAYER_ENTERING_WORLD")
   mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/UIParent:GetEffectiveScale()
end)
local function scale(x)
	return (mult*math.floor(x/mult+.5)) 
end

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
		edgeFile = "Interface\\Addons\\s_Core\\media\\solid", 
		edgeSize = mult,
		insets = { left = -mult, right = -mult, top = -mult, bottom = -mult }
	})
	f:SetBackdropBorderColor(r or 0, g or 0, b or 0, a or 1)
end
local function CreateShadow(f, t, offset, thickness, texture)
	if f.shadow then return end
	
	local borderr, borderg, borderb, bordera = 0, 0, 0, 1
	local backdropr, backdropg, backdropb, backdropa =  .05, .05, .05, .9
	
	if t == "Background" then
		backdropa = 0.6
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
		edgeFile = "Interface\\Addons\\s_Core\\media\\glowTex",
		bgFile = "Interface\\Addons\\s_Core\\media\\solid",
		edgeSize = scale(4),
		insets = {left = scale(4), right = scale(4), top = scale(4), bottom = scale(4)},
	})
	shadow:SetBackdropColor( backdropr, backdropg, backdropb, backdropa )
	shadow:SetBackdropBorderColor( borderr, borderg, borderb, bordera )
	f.shadow = shadow
end




local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Size then mt.Size = Size end
	if not object.Point then mt.Point = Point end
	if not object.Width then mt.Width = Width end
	if not object.Height then mt.Height = Height end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.CreateShadow then mt.CreateShadow = CreateShadow end
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
