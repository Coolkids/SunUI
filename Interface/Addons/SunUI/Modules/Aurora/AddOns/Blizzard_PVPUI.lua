local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_PVPUI"] = function()
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

	PVPUIFrameTab2:Point("LEFT", PVPUIFrameTab1, "RIGHT", -15, 0)

	-- Category buttons

	for i = 1, 3 do
		local bu = PVPQueueFrame["CategoryButton"..i]
		local icon = bu.Icon
		local cu = bu.CurrencyIcon

		bu.Ring:Hide()

		S.Reskin(bu, true)

		bu.Background:SetAllPoints()
		bu.Background:SetTexture(r, g, b, .2)

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetPoint("LEFT", bu, "LEFT")
		icon:SetDrawLayer("OVERLAY")
		icon.bg = S.CreateBG(icon)
		icon.bg:SetDrawLayer("ARTWORK")

		if cu then
			cu:Size(16, 16)
			cu:Point("TOPLEFT", bu.Name, "BOTTOMLEFT", 0, -8)
			bu.CurrencyAmount:Point("LEFT", cu, "RIGHT", 4, 0)

			cu:SetTexCoord(.08, .92, .08, .92)
			cu.bg = S.CreateBG(cu)
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

	--BonusFrame.DiceButton:SetNormalTexture("")
	--BonusFrame.DiceButton:SetPushedTexture("")
	S.Reskin(BonusFrame.DiceButton)

	for _, bu in pairs({BonusFrame.RandomBGButton, BonusFrame.CallToArmsButton, BonusFrame.WorldPVP1Button, BonusFrame.WorldPVP2Button}) do
		S.Reskin(bu, true)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints()
	end

	BonusFrame.CallToArmsButton:Point("TOP", BonusFrame.RandomBGButton, "BOTTOM", 0, -1)
	BonusFrame.WorldPVP2Button:Point("TOP", BonusFrame.WorldPVP1Button, "BOTTOM", 0, -1)

	-- Honor frame specific

	for _, bu in pairs(HonorFrame.SpecificFrame.buttons) do
		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:Point("TOPLEFT", 2, 0)
		bg:Point("BOTTOMRIGHT", 0, 2)
		S.CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		bu.tex = S.CreateGradient(bu)
		bu.tex:SetDrawLayer("BACKGROUND")
		bu.tex:Point("TOPLEFT", 3, -1)
		bu.tex:Point("BOTTOMRIGHT", -1, 3)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetTexture(r, g, b, .2)
		bu.SelectedTexture:Point("TOPLEFT", 2, 0)
		bu.SelectedTexture:Point("BOTTOMRIGHT", 0, 2)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = S.CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:Point("TOPLEFT", 5, -3)
	end

	-- if scroll frames aren't bugged then they are terribly implemented
	local bu1 = HonorFrame.SpecificFrame.buttons[1]
	bu1.tex:Point("TOPLEFT", 3, 0)
	bu1.tex:Point("BOTTOMRIGHT", -1, 3)
	bu1.Icon:Point("TOPLEFT", 4, -2)
	bu1.SelectedTexture:Point("BOTTOMRIGHT", 0, 3)

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

	for _, bu in pairs({ConquestFrame.Arena2v2, ConquestFrame.Arena3v3, ConquestFrame.Arena5v5, ConquestFrame.RatedBG}) do
		S.Reskin(bu, true)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints()
	end

	ConquestFrame.Arena3v3:Point("TOP", ConquestFrame.Arena2v2, "BOTTOM", 0, -1)
	ConquestFrame.Arena5v5:Point("TOP", ConquestFrame.Arena3v3, "BOTTOM", 0, -1)

	local classColour = DB.MyClassColor
	ConquestFrame.RatedBG.TeamNameText:SetText(UnitName("player"))
	ConquestFrame.RatedBG.TeamNameText:SetTextColor(classColour.r, classColour.g, classColour.b)

	for i = 1, 4 do
		select(i, ConquestBar:GetRegions()):Hide()
		_G["ConquestPointsBarDivider"..i]:Hide()
	end

	ConquestBar.shadow:Hide()

	ConquestBar.progress:SetTexture(DB.media.backdrop)
	ConquestBar.progress:SetGradient("VERTICAL", .8, 0, 0, 1, 0, 0)

	local bg = S.CreateBDFrame(ConquestBar, .25)
	bg:Point("TOPLEFT", -1, -2)
	bg:Point("BOTTOMRIGHT", 1, 2)

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
		bg:Point("TOPLEFT", 2, 0)
		bg:Point("BOTTOMRIGHT", -1, 2)
		S.CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		local tex = S.CreateGradient(bu)
		tex:SetDrawLayer("BACKGROUND")
		tex:Point("TOPLEFT", 3, -1)
		tex:Point("BOTTOMRIGHT", -2, 3)

		SelectedTexture:SetDrawLayer("BACKGROUND")
		SelectedTexture:SetTexture(r, g, b, .2)
		SelectedTexture:Point("TOPLEFT", 2, 0)
		SelectedTexture:Point("BOTTOMRIGHT", -1, 2)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = S.CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:Point("TOPLEFT", 5, -3)

		local header = button.Header

		header:GetNormalTexture():SetAlpha(0)
		header:SetHighlightTexture("")
		header:SetPushedTexture("")

		local headerBg = CreateFrame("Frame", nil, header)
		headerBg:Size(13, 13)
		headerBg:Point("LEFT", 4, 0)
		headerBg:SetFrameLevel(header:GetFrameLevel()-1)
		S.CreateBD(headerBg, 0)

		local headerTex = S.CreateGradient(header)
		headerTex:SetAllPoints(headerBg)

		local minus = header:CreateTexture(nil, "OVERLAY")
		minus:Size(7, 1)
		minus:SetPoint("CENTER", headerBg)
		minus:SetTexture(DB.media.backdrop)
		minus:SetVertexColor(1, 1, 1)

		local plus = header:CreateTexture(nil, "OVERLAY")
		plus:Size(1, 7)
		plus:SetPoint("CENTER", headerBg)
		plus:SetTexture(DB.media.backdrop)
		plus:SetVertexColor(1, 1, 1)
		header.plus = plus

		hooksecurefunc(header, "SetNormalTexture", onSetNormalTexture)
	end

	-- Arena

	local ArenaTeamFrame = ArenaTeamFrame
	local TopInset = ArenaTeamFrame.TopInset
	local WeeklyDisplay = ArenaTeamFrame.WeeklyDisplay
	local BottomInset = ArenaTeamFrame.BottomInset

	for i = 1, 9 do
		select(i, TopInset:GetRegions()):Hide()
		select(i, WeeklyDisplay:GetRegions()):Hide()
		select(i, BottomInset:GetRegions()):Hide()
	end

	ArenaTeamFrame.TeamNameHeader:Hide()
	ArenaTeamFrame.ArenaTexture:Hide()
	ArenaTeamFrame.TopShadowOverlay:Hide()

	for i = 1, 3 do
		local bu = PVPArenaTeamsFrame["Team"..i]

		bu.Flag.FlagGrabber:Hide()
		bu.Flag:Point("TOPLEFT", 10, -1)

		bu.Background:SetTexture(r, g, b, .2)
		bu.Background:SetAllPoints()

		S.Reskin(bu, true)
	end

	hooksecurefunc("PVPArenaTeamsFrame_SelectButton", function(button)
		for i = 1, MAX_ARENA_TEAMS do
			local teamButton = PVPArenaTeamsFrame["Team"..i]
			if teamButton == button then
				teamButton.Background:Show()
			else
				teamButton.Background:Hide()
			end
		end
	end)

	local function onEnter(self)
		self.bg:SetBackdropColor(r, g, b, .2)
	end

	local function onLeave(self)
		self.bg:SetBackdropColor(0, 0, 0, .25)
	end

	for i = 1, 4 do
		local header = ArenaTeamFrame["Header"..i]

		for j = 1, 3 do
			select(j, header:GetRegions()):Hide()
		end

		header:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, header)
		bg:Point("TOPLEFT", 2, 0)
		bg:Point("BOTTOMRIGHT", -1, 0)
		bg:SetFrameLevel(header:GetFrameLevel()-1)
		S.CreateBD(bg, .25)

		header.bg = bg

		header:HookScript("OnEnter", onEnter)
		header:HookScript("OnLeave", onLeave)
	end

	hooksecurefunc("PVPArenaTeamsFrame_ShowTeam", function(self)
		local frame = ArenaTeamFrame
		if not self.selectedButton then
			return
		end

		for i = 1, MAX_ARENA_TEAM_MEMBERS do
			local button = frame["TeamMember"..i]

			if button:IsEnabled() then
				local name, rank, level, class, online = GetArenaTeamRosterInfo(frame.teamIndex, i);
				local color = ConvertRGBtoColorString(DB.classcolours[class])
				if online then
					button.NameText:SetText(color..name..FONT_COLOR_CODE_CLOSE)
				else
					button.NameText:SetText(GRAY_FONT_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE)
				end
			end
		end
	end)

	local INVITE_DROPDOWN = 1;
	function ArenaInviteMenu_Init(self, level, team)
		local info = UIDropDownMenu_CreateInfo();
		info.notCheckable = true;
		info.value = nil;

		if (level == 1 and (not team or not team[1])) then
			info.text = INVITE_TEAM_MEMBERS;
			info.disabled = true;
			info.func =  nil;
			info.hasArrow = true;
			info.value = INVITE_DROPDOWN;
			UIDropDownMenu_AddButton(info, level)

			info.text = CANCEL
			info.disabled = nil;
			info.hasArrow = nil;
			info.value = nil;
			info.func = nil
			UIDropDownMenu_AddButton(info, level)
			return;
		end

		if (UIDROPDOWNMENU_MENU_VALUE == INVITE_DROPDOWN) then
			if (not team) then
				return
			end
			for i=1, #team do
				if (team[i].online) then
					local color = DB.classcolours[team[i].class]
					info.text = color..team[i].name..FONT_COLOR_CODE_CLOSE;
					info.func = function (menu, name) InviteToGroup(name); end
					info.arg1 = team[i].name;
					info.disabled = nil;
				else
					info.disabled = true;
					info.text = team[i].name;
				end
				UIDropDownMenu_AddButton(info, level)
			end
		end

		if (level == 1) then
			info.text = INVITE_TEAM_MEMBERS;
			info.func =  nil;
			info.hasArrow = true;
			info.value = INVITE_DROPDOWN;
			info.menuList = team;
			UIDropDownMenu_AddButton(info, level)
			info.text = CANCEL
			info.value = nil;
			info.hasArrow = nil;
			info.menuList = nil;
			UIDropDownMenu_AddButton(info, level)
		end
	end

	ArenaTeamFrame.Flag:Point("TOPLEFT", 25, -3)

	S.CreateBD(TopInset, .25)
	S.ReskinArrow(ArenaTeamFrame.weeklyToggleRight, "RIGHT")
	S.ReskinArrow(ArenaTeamFrame.weeklyToggleLeft, "LEFT")

	-- Main style

	S.ReskinPortraitFrame(PVPUIFrame)
	S.ReskinTab(PVPUIFrame.Tab1)
	S.ReskinTab(PVPUIFrame.Tab2)
	S.Reskin(HonorFrame.SoloQueueButton)
	S.Reskin(HonorFrame.GroupQueueButton)
	S.Reskin(ConquestFrame.JoinButton)
	S.Reskin(WarGameStartButton)
	S.Reskin(ArenaTeamFrame.AddMemberButton)
	S.ReskinDropDown(HonorFrameTypeDropDown)
	S.ReskinScroll(HonorFrameSpecificFrameScrollBar)
	S.ReskinScroll(WarGamesFrameScrollFrameScrollBar)
	S.ReskinScroll(WarGamesFrameInfoScrollFrameScrollBar)
end