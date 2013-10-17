local S, L, DB, _, C = unpack(select(2, ...))

local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

tinsert(DB.AuroraModules["SunUI"], function()
	S.CreateBD(RolePollPopup)
	S.CreateSD(RolePollPopup)
	S.Reskin(RolePollPopupAcceptButton)
	S.ReskinClose(RolePollPopupCloseButton)

	for _, roleButton in pairs({RolePollPopupRoleButtonTank, RolePollPopupRoleButtonHealer, RolePollPopupRoleButtonDPS}) do
		roleButton.cover:SetTexture(DB.media.roleIcons)
		roleButton:SetNormalTexture(DB.media.roleIcons)

		roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

		local left = roleButton:CreateTexture(nil, "OVERLAY")
		left:SetWidth(1)
		left:SetTexture(DB.media.backdrop)
		left:SetVertexColor(0, 0, 0)
		left:SetPoint("TOPLEFT", 9, -7)
		left:SetPoint("BOTTOMLEFT", 9, 11)

		local right = roleButton:CreateTexture(nil, "OVERLAY")
		right:SetWidth(1)
		right:SetTexture(DB.media.backdrop)
		right:SetVertexColor(0, 0, 0)
		right:SetPoint("TOPRIGHT", -9, -7)
		right:SetPoint("BOTTOMRIGHT", -9, 11)

		local top = roleButton:CreateTexture(nil, "OVERLAY")
		top:SetHeight(1)
		top:SetTexture(DB.media.backdrop)
		top:SetVertexColor(0, 0, 0)
		top:SetPoint("TOPLEFT", 9, -7)
		top:SetPoint("TOPRIGHT", -9, -7)

		local bottom = roleButton:CreateTexture(nil, "OVERLAY")
		bottom:SetHeight(1)
		bottom:SetTexture(DB.media.backdrop)
		bottom:SetVertexColor(0, 0, 0)
		bottom:SetPoint("BOTTOMLEFT", 9, 11)
		bottom:SetPoint("BOTTOMRIGHT", -9, 11)

		S.ReskinRadio(roleButton.checkButton)
	end
end)