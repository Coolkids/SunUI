local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b

	local PVPUIFrame = PVPUIFrame
	local PVPQueueFrame = PVPQueueFrame
	local HonorFrame = HonorFrame
	local ConquestFrame = ConquestFrame
	local WarGamesFrame = WarGamesFrame
	local PVPArenaTeamsFrame = PVPArenaTeamsFrame

	PVPUIFrame:DisableDrawLayer("ARTWORK")
	PVPUIFrame.LeftInset:DisableDrawLayer("BORDER")
	PVPUIFrame.Background:Hide()
	PVPUIFrame.Shadows:Hide()
	PVPUIFrame.LeftInset:GetRegions():Hide()
	select(24, PVPUIFrame:GetRegions()):Hide()
	select(25, PVPUIFrame:GetRegions()):Hide()

	-- Category buttons

	for i = 1, 3 do
		local bu = PVPQueueFrame["CategoryButton"..i]
		local icon = bu.Icon
		local cu = bu.CurrencyIcon

		bu.Ring:Hide()

		A:Reskin(bu, true)

		bu.Background:SetAllPoints()
		bu.Background:SetTexture(r, g, b, .2)
		bu.Background:Hide()

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetPoint("LEFT", bu, "LEFT")
		icon:SetDrawLayer("OVERLAY")
		icon.bg = A:CreateBG(icon)
		icon.bg:SetDrawLayer("ARTWORK")

		if cu then
			cu:SetSize(16, 16)
			cu:SetPoint("TOPLEFT", bu.Name, "BOTTOMLEFT", 0, -8)
			bu.CurrencyAmount:SetPoint("LEFT", cu, "RIGHT", 4, 0)

			cu:SetTexCoord(.08, .92, .08, .92)
			cu.bg = A:CreateBG(cu)
			cu.bg:SetDrawLayer("BACKGROUND", 1)
		end
	end

	PVPQueueFrame.CategoryButton1.Icon:SetTexture("Interface\\Icons\\achievement_bg_winwsg")
	PVPQueueFrame.CategoryButton2.Icon:SetTexture("Interface\\Icons\\achievement_bg_killxenemies_generalsroom")
	PVPQueueFrame.CategoryButton3.Icon:SetTexture("Interface\\Icons\\ability_warrior_offensivestance")

	local englishFaction = UnitFactionGroup("player")
	PVPQueueFrame.CategoryButton1.CurrencyIcon:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..englishFaction)
	PVPQueueFrame.CategoryButton2.CurrencyIcon:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..englishFaction)

	hooksecurefunc("PVPQueueFrame_SelectButton", function(index)
		local self = PVPQueueFrame
		for i = 1, 3 do
			local bu = self["CategoryButton"..i]
			if i == index then
				bu.Background:Show()
			else
				bu.Background:Hide()
			end
		end
	end)

	-- Honor frame

	local Inset = HonorFrame.Inset
	local BonusFrame = HonorFrame.BonusFrame

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	BonusFrame.BattlegroundTexture:Hide()
	BonusFrame.WorldBattlesTexture:Hide()
	BonusFrame.BattlegroundHeader:Hide()
	BonusFrame.WorldPVPHeader:Hide()
	BonusFrame.ShadowOverlay:Hide()

	A:Reskin(BonusFrame.DiceButton)

	for _, bu in pairs({BonusFrame.RandomBGButton, BonusFrame.CallToArmsButton, BonusFrame.WorldPVP1Button, BonusFrame.WorldPVP2Button}) do
		A:Reskin(bu, true)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints()
	end

	BonusFrame.BattlegroundReward1.Amount:SetPoint("RIGHT", BonusFrame.BattlegroundReward1.Icon, "LEFT", -2, 0)
	BonusFrame.BattlegroundReward1.Icon:SetTexCoord(.08, .92, .08, .92)
	BonusFrame.BattlegroundReward1.Icon:SetSize(16, 16)
	A:CreateBG(BonusFrame.BattlegroundReward1.Icon)
	BonusFrame.BattlegroundReward2.Amount:SetPoint("RIGHT", BonusFrame.BattlegroundReward2.Icon, "LEFT", -2, 0)
	BonusFrame.BattlegroundReward2.Icon:SetTexCoord(.08, .92, .08, .92)
	BonusFrame.BattlegroundReward2.Icon:SetSize(16, 16)
	A:CreateBG(BonusFrame.BattlegroundReward2.Icon)

	hooksecurefunc("HonorFrameBonusFrame_Update", function()
		local hasData, canQueue, bgName, battleGroundID, hasWon, winHonorAmount, winConquestAmount = GetHolidayBGInfo()
		local rewardIndex = 0
		if winConquestAmount and winConquestAmount > 0 then
			rewardIndex = rewardIndex + 1
			local frame = HonorFrame.BonusFrame["BattlegroundReward"..rewardIndex]
			frame.Icon:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..englishFaction)
		end
		if winHonorAmount and winHonorAmount > 0 then
			rewardIndex = rewardIndex + 1
			local frame = HonorFrame.BonusFrame["BattlegroundReward"..rewardIndex]
			frame.Icon:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..englishFaction)
		end
	end)

	IncludedBattlegroundsDropDown:SetPoint("TOPRIGHT", BonusFrame.DiceButton, 40, 26)

	-- Role buttons

	local RoleInset = HonorFrame.RoleInset

	RoleInset:DisableDrawLayer("BACKGROUND")
	RoleInset:DisableDrawLayer("BORDER")

	for _, roleButton in pairs({RoleInset.HealerIcon, RoleInset.TankIcon, RoleInset.DPSIcon}) do
		--roleButton.cover:SetTexture("Interface\\Addons\\SunUI\\media\\UI-LFG-ICON-ROLES")
		--roleButton:SetNormalTexture("Interface\\Addons\\SunUI\\media\\UI-LFG-ICON-ROLES")

		roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)
		--[[
		for i = 1, 2 do
			local left = roleButton:CreateTexture()
			left:SetDrawLayer("OVERLAY", i)
			left:SetWidth(1)
			left:SetTexture(A.media.backdrop)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", roleButton, 6, -4)
			left:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
			roleButton["leftLine"..i] = left

			local right = roleButton:CreateTexture()
			right:SetDrawLayer("OVERLAY", i)
			right:SetWidth(1)
			right:SetTexture(A.media.backdrop)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", roleButton, -6, -4)
			right:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
			roleButton["rightLine"..i] = right

			local top = roleButton:CreateTexture()
			top:SetDrawLayer("OVERLAY", i)
			top:SetHeight(1)
			top:SetTexture(A.media.backdrop)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", roleButton, 6, -4)
			top:SetPoint("TOPRIGHT", roleButton, -6, -4)
			roleButton["topLine"..i] = top

			local bottom = roleButton:CreateTexture()
			bottom:SetDrawLayer("OVERLAY", i)
			bottom:SetHeight(1)
			bottom:SetTexture(A.media.backdrop)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
			bottom:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
			roleButton["bottomLine"..i] = bottom
		end
		--]]
		--roleButton.leftLine2:Hide()
		--roleButton.rightLine2:Hide()
		--roleButton.topLine2:Hide()
		--roleButton.bottomLine2:Hide()
	
		A:ReskinCheck(roleButton.checkButton)
	end

	-- Honor frame specific

	for _, bu in pairs(HonorFrame.SpecificFrame.buttons) do
		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		A:CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		--bu.tex = A:CreateGradient(bu)
		--bu.tex:SetDrawLayer("BACKGROUND")
		--bu.tex:SetPoint("TOPLEFT", bg, 1, -1)
		--bu.tex:SetPoint("BOTTOMRIGHT", bg, -1, 1)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints(bu.tex)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = A:CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)
	end

	-- Conquest Frame

	local Inset = ConquestFrame.Inset
	local ConquestBar = ConquestFrame.ConquestBar

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	ConquestFrame.ArenaTexture:Hide()
	ConquestFrame.RatedBGTexture:Hide()
	ConquestFrame.ArenaHeader:Hide()
	ConquestFrame.RatedBGHeader:Hide()
	ConquestFrame.ShadowOverlay:Hide()

	A:CreateBD(ConquestTooltip)

	local ConquestFrameButton_OnEnter = function(self)
		ConquestTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 1, 0)
	end

	ConquestFrame.Arena2v2:HookScript("OnEnter", ConquestFrameButton_OnEnter)
	ConquestFrame.Arena3v3:HookScript("OnEnter", ConquestFrameButton_OnEnter)
	ConquestFrame.Arena5v5:HookScript("OnEnter", ConquestFrameButton_OnEnter)
	ConquestFrame.RatedBG:HookScript("OnEnter", ConquestFrameButton_OnEnter)

	for _, bu in pairs({ConquestFrame.Arena2v2, ConquestFrame.Arena3v3, ConquestFrame.Arena5v5, ConquestFrame.RatedBG}) do
		A:Reskin(bu, true)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints()
	end

	ConquestFrame.Arena3v3:SetPoint("TOP", ConquestFrame.Arena2v2, "BOTTOM", 0, -1)
	ConquestFrame.Arena5v5:SetPoint("TOP", ConquestFrame.Arena3v3, "BOTTOM", 0, -1)

	ConquestFrame.ArenaReward.Amount:SetPoint("RIGHT", ConquestFrame.ArenaReward.Icon, "LEFT", -2, 0)
	ConquestFrame.ArenaReward.Icon:SetTexCoord(.08, .92, .08, .92)
	ConquestFrame.ArenaReward.Icon:SetSize(16, 16)
	A:CreateBG(ConquestFrame.ArenaReward.Icon)
	ConquestFrame.RatedBGReward.Amount:SetPoint("RIGHT", ConquestFrame.RatedBGReward.Icon, "LEFT", -2, 0)
	ConquestFrame.RatedBGReward.Icon:SetTexCoord(.08, .92, .08, .92)
	ConquestFrame.RatedBGReward.Icon:SetSize(16, 16)
	A:CreateBG(ConquestFrame.RatedBGReward.Icon)

	ConquestFrame.ArenaReward.Icon:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..englishFaction)
	ConquestFrame.RatedBGReward.Icon:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..englishFaction)

	for i = 1, 4 do
		select(i, ConquestBar:GetRegions()):Hide()
		_G["ConquestPointsBarDivider"..i]:Hide()
	end

	ConquestBar.shadow:Hide()

	ConquestBar.progress:SetTexture(A["media"].normal)
	ConquestBar.progress:SetGradient("VERTICAL", .8, 0, 0, 1, 0, 0)

	local bg = A:CreateBDFrame(ConquestBar, .25)
	bg:SetPoint("TOPLEFT", -1, -2)
	bg:SetPoint("BOTTOMRIGHT", 1, 2)

	-- War games

	local Inset = WarGamesFrame.RightInset

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	WarGamesFrame.InfoBG:Hide()
	WarGamesFrame.HorizontalBar:Hide()
	WarGamesFrameInfoScrollFrame.scrollBarBackground:Hide()
	WarGamesFrameInfoScrollFrame.scrollBarArtTop:Hide()
	WarGamesFrameInfoScrollFrame.scrollBarArtBottom:Hide()

	WarGamesFrameDescription:SetTextColor(.9, .9, .9)

	local function onSetNormalTexture(self, texture)
		if texture:find("Plus") then
			self.plus:Show()
		else
			self.plus:Hide()
		end
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

		--local tex = A:CreateGradient(bu)
		--tex:SetDrawLayer("BACKGROUND")
		--tex:SetPoint("TOPLEFT", 3, -1)
		--tex:SetPoint("BOTTOMRIGHT", -2, 3)

		SelectedTexture:SetDrawLayer("BACKGROUND")
		SelectedTexture:SetTexture(r, g, b, .2)
		SelectedTexture:SetPoint("TOPLEFT", 2, 0)
		SelectedTexture:SetPoint("BOTTOMRIGHT", -1, 2)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = A:CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)

		local header = button.Header

		header:GetNormalTexture():SetAlpha(0)
		header:SetHighlightTexture("")
		header:SetPushedTexture("")

		local headerBg = CreateFrame("Frame", nil, header)
		headerBg:SetSize(13, 13)
		headerBg:SetPoint("LEFT", 4, 0)
		headerBg:SetFrameLevel(header:GetFrameLevel()-1)
		A:CreateBD(headerBg, 0)

		--local headerTex = A:CreateGradient(header)
		--headerTex:SetAllPoints(headerBg)

		local minus = header:CreateTexture(nil, "OVERLAY")
		minus:SetSize(7, 1)
		minus:SetPoint("CENTER", headerBg)
		minus:SetTexture(A.media.backdrop)
		minus:SetVertexColor(1, 1, 1)

		local plus = header:CreateTexture(nil, "OVERLAY")
		plus:SetSize(1, 7)
		plus:SetPoint("CENTER", headerBg)
		plus:SetTexture(A.media.backdrop)
		plus:SetVertexColor(1, 1, 1)
		header.plus = plus

		hooksecurefunc(header, "SetNormalTexture", onSetNormalTexture)
	end

	-- Main style

	A:ReskinPortraitFrame(PVPUIFrame)
	A:Reskin(HonorFrame.SoloQueueButton)
	A:Reskin(HonorFrame.GroupQueueButton)
	A:Reskin(ConquestFrame.JoinButton)
	A:Reskin(WarGameStartButton)
	A:ReskinDropDown(HonorFrameTypeDropDown)
	A:ReskinScroll(HonorFrameSpecificFrameScrollBar)
	A:ReskinScroll(WarGamesFrameScrollFrameScrollBar)
	A:ReskinScroll(WarGamesFrameInfoScrollFrameScrollBar)
end

A:RegisterSkin("Blizzard_PVPUI", LoadSkin)