local S, L, DB, _, C = unpack(select(2, ...))

local sceenheight = string.match(GetCVar("gxResolution"), "%d+x(%d+)")
local HiddenFrame = CreateFrame("Frame")
HiddenFrame:Hide()
DB.Shadow = {}
DB.Border = {}
S.mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/(max(0.64, min(1.15, GetCVar('uiScale') or UIParent:GetScale() or (S.IsCoolkid() and 0.9 or 768/sceenheight))))
local function sceenscale(x)
	return (S.mult*math.floor(x/(S.mult)+.5)) 
end
S.Scale = function(x) return sceenscale(x) end

local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
		object:SetParent(HiddenFrame)
	else
		object.Show = function() end
	end
	object:Hide()
end
 local function StripTextures(object, kill)
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
local function Size(frame, width, height)
	frame:SetSize(S.Scale(width), S.Scale(height or width))
end

local function Width(frame, width)
	frame:SetWidth(S.Scale(width))
end

local function Height(frame, height)
	frame:SetHeight(S.Scale(height))
end

local function Point(obj, arg1, arg2, arg3, arg4, arg5)
	-- anyone has a more elegant way for this?
	if type(arg1)=="number" then arg1 = S.Scale(arg1) end
	if type(arg2)=="number" then arg2 = S.Scale(arg2) end
	if type(arg3)=="number" then arg3 = S.Scale(arg3) end
	if type(arg4)=="number" then arg4 = S.Scale(arg4) end
	if type(arg5)=="number" then arg5 = S.Scale(arg5) end

	obj:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local function CreateBorder(f, r, g, b, a)
 	f:SetBackdrop({
		edgeFile = DB.Solid, 
		edgeSize = S.mult,
		insets = { left = -S.mult, right = -S.mult, top = -S.mult, bottom = -S.mult }
	})
	f:SetBackdropBorderColor(r or 0, g or 0, b or 0, a or 1)
	tinsert(DB.Border, f)
end
local function SetOutside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then
		obj:ClearAllPoints()
	end

	obj:Point("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
	obj:Point("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

local function SetInside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then
		obj:ClearAllPoints()
	end

	obj:Point("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
	obj:Point("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end
local function CreateShadow(f, t, offset, thickness, texture)
	if f.shadow then return end
	
	local borderr, borderg, borderb, bordera = 0, 0, 0, 1
	local backdropr, backdropg, backdropb, backdropa =  .05, .05, .05, .9
	local frameLevel = f:GetFrameLevel() > 1 and f:GetFrameLevel() or 1
	if t == "Background" then
		backdropa = 0.6
	elseif t == "UnitFrame" then 
		backdropa = 0.3
	else
		backdropa = 0
	end
	
	local border = CreateFrame("Frame", nil, f)
	border:SetFrameLevel(frameLevel)
	border:Point("TOPLEFT", -1, 1)
	border:Point("TOPRIGHT", 1, 1)
	border:Point("BOTTOMRIGHT", 1, -1)
	border:Point("BOTTOMLEFT", -1, -1)
	border:CreateBorder()
	f.border = border
	
	local shadow = CreateFrame("Frame", nil, border)
	shadow:SetFrameLevel(frameLevel - 1)
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
	f.shadow = shadow
	
	tinsert(DB.Shadow, f)
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
local function FadeIn(f)
	UIFrameFadeIn(f, .4, f:GetAlpha(), 1)
end

local function FadeOut(f)
	UIFrameFadeOut(f, .4, f:GetAlpha(), 0)
end
local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Size then mt.Size = Size end
	if not object.Point then mt.Point = Point end
	if not object.Width then mt.Width = Width end
	if not object.Height then mt.Height = Height end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.CreateShadow then mt.CreateShadow = CreateShadow end
	if not object.StyleButton then mt.StyleButton = StyleButton end
	if not object.Kill then mt.Kill = Kill end
	if not object.StripTextures then mt.StripTextures = StripTextures end
	if not object.SetOutside then mt.SetOutside = SetOutside end
	if not object.SetInside then mt.SetInside = SetInside end
	if not object.FadeIn then mt.FadeIn = FadeIn end
	if not object.FadeOut then mt.FadeOut = FadeOut end
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

