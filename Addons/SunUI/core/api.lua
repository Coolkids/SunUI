local S, L, DB, _, C = unpack(select(2, ...))

local sceenheight = string.match(GetCVar("gxResolution"), "%d+x(%d+)")
local HiddenFrame = CreateFrame("Frame")
HiddenFrame:Hide()

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

local function CreateBorder(f, r, g, b, a)
 	f:SetBackdrop({
		edgeFile = DB.Solid, 
		edgeSize = 1,
		insets = { left = -1, right = -1, top = -1, bottom = -1 }
	})
	f:SetBackdropBorderColor(r or 0, g or 0, b or 0, a or 1)
end
local function SetOutside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then
		obj:ClearAllPoints()
	end

	obj:SetPoint("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
	obj:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

local function SetInside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then
		obj:ClearAllPoints()
	end

	obj:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
	obj:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end
local function CreateShadow(f, t, offset, thickness, texture)
	if f.shadow then return end
	
	local borderr, borderg, borderb, bordera = 0, 0, 0, 1
	local backdropr, backdropg, backdropb, backdropa =  .05, .05, .05, .9
	local frameLevel = f:GetFrameLevel() > 1 and f:GetFrameLevel() or 1
	if type(t) == "string" then
		if t == "Background" then
			backdropa = 0.6
		elseif t == "UnitFrame" then 
			backdropa = 0.3
		end
	elseif type(t) == "number" then
		backdropa = t
	else
		backdropa = 0
	end
	
	local border = CreateFrame("Frame", nil, f)
	border:SetFrameLevel(frameLevel)
	border:SetPoint("TOPLEFT", -1, 1)
	border:SetPoint("TOPRIGHT", 1, 1)
	border:SetPoint("BOTTOMRIGHT", 1, -1)
	border:SetPoint("BOTTOMLEFT", -1, -1)
	border:CreateBorder()
	f.border = border
	
	local shadow = CreateFrame("Frame", nil, border)
	shadow:SetFrameLevel(frameLevel - 1)
	shadow:SetPoint("TOPLEFT", -3, 3)
	shadow:SetPoint("TOPRIGHT", 3, 3)
	shadow:SetPoint("BOTTOMRIGHT", 3, -3)
	shadow:SetPoint("BOTTOMLEFT", -3, -3)
	shadow:SetBackdrop( { 
		edgeFile = DB.GlowTex,
		bgFile =DB.Solid,
		edgeSize = 4,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	shadow:SetBackdropColor( backdropr, backdropg, backdropb, backdropa )
	shadow:SetBackdropBorderColor( borderr, borderg, borderb, bordera )
	f.shadow = shadow

end

local function StyleButton(button, setallpoints)
	if button.SetHighlightTexture and not button.hover then
		local hover = button:CreateTexture(nil, "OVERLAY")
		hover:SetTexture(1, 1, 1, 0.3)
		if setallpoints then
			hover:SetAllPoints()
		else
			hover:SetPoint('TOPLEFT', 2, -2)
			hover:SetPoint('BOTTOMRIGHT', -2, 2)
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
			pushed:SetPoint('TOPLEFT', 2, -2)
			pushed:SetPoint('BOTTOMRIGHT', -2, 2)
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
			checked:SetPoint('TOPLEFT', 2, -2)
			checked:SetPoint('BOTTOMRIGHT', -2, 2)
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
			cooldown:SetPoint('TOPLEFT', 2, -2)
			cooldown:SetPoint('BOTTOMRIGHT', -2, 2)
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

