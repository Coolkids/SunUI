local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b

	PVPUIFrame:StripTextures()
	A:SetBD(PVPUIFrame)
	PVPUIFrame.LeftInset:StripTextures()
	PVPUIFrame.Shadows:StripTextures()

	A:ReskinClose(PVPUIFrameCloseButton)

	for i=1, 2 do
		A:CreateTab(_G["PVPUIFrameTab"..i])
	end

	for i=1, 3 do
		local button = _G["PVPQueueFrameCategoryButton"..i]
		button:SetTemplate('Default')
		button.Background:Kill()
		button.Ring:Kill()
		button.Icon:Size(45)
		button.Icon:SetTexCoord(.15, .85, .15, .85)
		A:Reskin(button)
	end

	--[[for i=1, 3 do
		local button = _G["PVPArenaTeamsFrameTeam"..i]
		button.Background:Kill()
		A:Reskin(button)
	end]]

	-->>>HONOR FRAME
	A:ReskinDropDown(HonorFrameTypeDropDown)

	HonorFrame.Inset:StripTextures()
	--HonorFrame.Inset:SetTemplate("Transparent")

	A:ReskinScroll(HonorFrameSpecificFrameScrollBar)
	A:Reskin(HonorFrameSoloQueueButton)
	A:Reskin(HonorFrameGroupQueueButton)
	HonorFrame.BonusFrame:StripTextures()
	HonorFrame.BonusFrame.ShadowOverlay:StripTextures()
	-->>>CONQUEST FRAME
	ConquestFrame.Inset:StripTextures()
	ConquestPointsBarLeft:Kill()
	ConquestPointsBarRight:Kill()
	ConquestPointsBarMiddle:Kill()
	ConquestPointsBarBG:Kill()
	ConquestPointsBarShadow:Kill()
	ConquestPointsBar.progress:SetTexture(A["media"].normal)
	ConquestFrame:StripTextures()
	ConquestFrame.ShadowOverlay:StripTextures()
	A:Reskin(ConquestJoinButton, true)

	local bg = CreateFrame("Frame", nil, ConquestPointsBar)
	A:CreateBD(ConquestPointsBar, .25)
	bg:SetPoint("TOPLEFT", -1, -2)
	bg:SetPoint("BOTTOMRIGHT", 1, 2)

	-->>>WARGRAMES FRAME
	WarGamesFrame:StripTextures()
	WarGamesFrame.RightInset:StripTextures()
	A:Reskin(WarGameStartButton, true)
	A:ReskinScroll(WarGamesFrameScrollFrameScrollBar)
	WarGamesFrame.HorizontalBar:StripTextures()

	local RoleInset = HonorFrame.RoleInset

	RoleInset:DisableDrawLayer("BACKGROUND")
	RoleInset:DisableDrawLayer("BORDER")

	for _, roleButton in pairs({RoleInset.HealerIcon, RoleInset.TankIcon, RoleInset.DPSIcon}) do
		A:ReskinCheck(roleButton.checkButton)
	end

	for _, button in pairs(WarGamesFrame.scrollFrame.buttons) do
		local bu = button.Entry
		local SelectedTexture = bu.SelectedTexture

		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		A:CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		SelectedTexture:SetDrawLayer("BACKGROUND")
		SelectedTexture:SetTexture(r, g, b, .2)
		SelectedTexture:SetPoint("TOPLEFT", 2, 0)
		SelectedTexture:SetPoint("BOTTOMRIGHT", -1, 2)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = A:CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)
	end
end

A:RegisterSkin("Blizzard_PVPUI", LoadSkin)