local S, C, L, DB = unpack(select(2, ...))

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

	S.Reskin(down)
	
	down:SetDisabledTexture("Interface\\ChatFrame\\ChatFrameBackground")
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture("Interface\\AddOns\\Aurora\\arrow-down-active")
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", -18, 8)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bg, 0)

	local tex = bg:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT")
	tex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
end

S.ReskinCheck = function(f)
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture("Interface\\ChatFrame\\ChatFrameBackground")
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
	tex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
end

S.ReskinInput = function(f, height, width)
	local frame = f:GetName()
	_G[frame.."Left"]:Hide()
	if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
	if _G[frame.."Mid"] then _G[frame.."Mid"]:Hide() end
	_G[frame.."Right"]:Hide()
	S.CreateBD(f, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT")
	tex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	if height then f:SetHeight(height) end
	if width then f:SetWidth(width) end
end

function CreateShadow(f, t) 
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
	border:Point("TOPLEFT", 1, -1)
	border:Point("TOPRIGHT", -1, -1)
	border:Point("BOTTOMRIGHT", -1, 1)
	border:Point("BOTTOMLEFT", 1, 1)
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
		insets = {left = S.Scale(3), right = S.Scale(3), top = S.Scale(3), bottom = S.Scale(3)},
	})
	shadow:SetBackdropColor( backdropr, backdropg, backdropb, backdropa )
	shadow:SetBackdropBorderColor( borderr, borderg, borderb, bordera )
	f.shadow = shadow
end