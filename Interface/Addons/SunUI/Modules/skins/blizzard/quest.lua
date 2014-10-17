local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b
	A:ReskinPortraitFrame(QuestFrame, true)

	QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameDetailPanel:DisableDrawLayer("BORDER")
	QuestFrameRewardPanel:DisableDrawLayer("BORDER")

	QuestDetailScrollFrameTop:Hide()
	QuestDetailScrollFrameBottom:Hide()
	QuestDetailScrollFrameMiddle:Hide()
	QuestProgressScrollFrameTop:Hide()
	QuestProgressScrollFrameBottom:Hide()
	QuestProgressScrollFrameMiddle:Hide()
	QuestRewardScrollFrameTop:Hide()
	QuestRewardScrollFrameBottom:Hide()
	QuestRewardScrollFrameMiddle:Hide()
	QuestGreetingScrollFrameTop:Hide()
	QuestGreetingScrollFrameMiddle:Hide()
	QuestGreetingScrollFrameBottom:Hide()

	QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)
	
	QuestNPCModelShadowOverlay:Hide()
	QuestNPCModelBg:Hide()
	QuestNPCModel:DisableDrawLayer("OVERLAY")
	QuestNPCModelNameText:SetDrawLayer("ARTWORK")
	QuestNPCModelTextFrameBg:Hide()
	QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")
	
	QuestInfoItemHighlight:GetRegions():Hide()
	QuestInfoSpellObjectiveFrameNameFrame:Hide()
	QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)

	local npcbd = CreateFrame("Frame", nil, QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", 0, 1)
	npcbd:SetPoint("RIGHT", 1, 0)
	npcbd:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
	npcbd:SetFrameLevel(0)
	A:CreateBD(npcbd)

	local line = CreateFrame("Frame", nil, QuestNPCModel)
	line:SetPoint("BOTTOMLEFT", 0, -1)
	line:SetPoint("BOTTOMRIGHT", 0, -1)
	line:SetHeight(1)
	line:SetFrameLevel(0)
	A:CreateBD(line, 0)

	NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
	TRIVIAL_QUEST_DISPLAY = string.gsub(TRIVIAL_QUEST_DISPLAY, "|cff000000", "|cffffffff")
	QuestFont:SetTextColor(1, 1, 1)
	QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
	QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
	QuestProgressTitleText:SetShadowColor(0, 0, 0)
	QuestInfoTitleHeader:SetShadowColor(0, 0, 0)
	QuestInfoTitleHeader:SetTextColor(1, 1, 1)
	QuestInfoTitleHeader.SetTextColor = S.dummy
	QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
	QuestInfoDescriptionHeader.SetTextColor = S.dummy
	QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)
	QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
	QuestInfoObjectivesHeader.SetTextColor = S.dummy
	QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)
	QuestInfoDescriptionText:SetTextColor(1, 1, 1)
	QuestInfoDescriptionText.SetTextColor = S.dummy
	QuestInfoObjectivesText:SetTextColor(1, 1, 1)
	QuestInfoObjectivesText.SetTextColor = S.dummy
	QuestInfoGroupSize:SetTextColor(1, 1, 1)
	QuestInfoGroupSize.SetTextColor = S.dummy
	QuestInfoRewardText:SetTextColor(1, 1, 1)
	QuestInfoRewardText.SetTextColor = S.dummy
	GossipGreetingText:SetTextColor(1, 1, 1)
	QuestProgressTitleText:SetTextColor(1, 1, 1)
	QuestProgressTitleText.SetTextColor = S.dummy
	QuestProgressText:SetTextColor(1, 1, 1)
	QuestProgressText.SetTextColor = S.dummy
	AvailableQuestsText:SetTextColor(1, 1, 1)
	AvailableQuestsText.SetTextColor = S.dummy
	AvailableQuestsText:SetShadowColor(0, 0, 0)
	QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
	QuestInfoSpellObjectiveLearnLabel.SetTextColor = S.dummy
	QuestInfoTimerText:SetTextColor(1, 1, 1)
	QuestInfoTimerText.SetTextColor = S.dummy
	CurrentQuestsText:SetTextColor(1, 1, 1)
	CurrentQuestsText.SetTextColor = S.dummy
	CurrentQuestsText:SetShadowColor(0, 0, 0)
	CoreAbilityFont:SetTextColor(1, 1, 1)
	SystemFont_Large:SetTextColor(1, 1, 1)
	--[[for i = 1, MAX_OBJECTIVES do
		local objective = _G["QuestInfoObjective"..i]
		objective:SetTextColor(1, 1, 1)
		objective.SetTextColor = S.dummy
	end
	--]]
	--[[
	QuestInfoSkillPointFrameIconTexture:SetSize(40, 40)
	QuestInfoSkillPointFrameIconTexture:SetTexCoord(.08, .92, .08, .92)

	local bg = CreateFrame("Frame", nil, QuestInfoSkillPointFrame)
	bg:Point("TOPLEFT", -3, 0)
	bg:Point("BOTTOMRIGHT", -3, 0)
	bg:Lower()
	A:CreateBD(bg, .25)

	QuestInfoSkillPointFrame:StyleButton()
	QuestInfoSkillPointFrame:GetPushedTexture():Point("TOPLEFT", 1, -1)
	QuestInfoSkillPointFrame:GetPushedTexture():Point("BOTTOMRIGHT", -3, 1)
	QuestInfoSkillPointFrame:GetHighlightTexture():Point("TOPLEFT", 1, -1)
	QuestInfoSkillPointFrame:GetHighlightTexture():Point("BOTTOMRIGHT", -3, 1)

	QuestInfoSkillPointFrameNameFrame:Hide()
	QuestInfoSkillPointFrameName:SetParent(bg)
	QuestInfoSkillPointFrameIconTexture:SetParent(bg)
	QuestInfoSkillPointFrameSkillPointBg:SetParent(bg)
	QuestInfoSkillPointFrameSkillPointBgGlow:SetParent(bg)
	QuestInfoSkillPointFramePoints:SetParent(bg)

	local line2 = QuestInfoSkillPointFrame:CreateTexture(nil, "BACKGROUND")
	line2:SetSize(1, 40)
	line2:Point("RIGHT", QuestInfoSkillPointFrameIconTexture, 1, 0)
	line2:SetTexture(A["media"].backdrop)
	line2:SetVertexColor(0, 0, 0)
	--]]
	--[[
	local function clearhighlight()
		for i = 1, MAX_NUM_ITEMS do
			_G["MapQuestInfoRewardsFrameQuestInfoItem"..i]:SetBackdropColor(0, 0, 0, .25)
		end
	end

	local function sethighlight(self)
		clearhighlight()

		local _, point = self:GetPoint()
		point:SetBackdropColor(r, g, b, .2)
	end

	hooksecurefunc(QuestInfoItemHighlight, "SetPoint", sethighlight)
	QuestInfoItemHighlight:HookScript("OnShow", sethighlight)
	QuestInfoItemHighlight:HookScript("OnHide", clearhighlight)

	for i = 1, MAX_REQUIRED_ITEMS do
		local bu = _G["MapQuestInfoRewardsFrameQuestProgressItem"..i]
		local ic = _G["MapQuestInfoRewardsFrameQuestProgressItem"..i.."IconTexture"]
		local na = _G["MapQuestInfoRewardsFrameQuestProgressItem"..i.."NameFrame"]
		local co = _G["MapQuestInfoRewardsFrameQuestProgressItem"..i.."Count"]

		ic:SetSize(40, 40)
		ic:SetTexCoord(.08, .92, .08, .92)
		ic:SetDrawLayer("OVERLAY")

		A:CreateBD(bu, .25)

		na:Hide()
		co:SetDrawLayer("OVERLAY")

		local line = CreateFrame("Frame", nil, bu)
		line:SetSize(1, 40)
		line:Point("RIGHT", ic, 1, 0)
		A:CreateBD(line)

		bu:StyleButton(1)
	end

	for i = 1, MAX_NUM_ITEMS do
		local bu = _G["MapQuestInfoRewardsFrameQuestInfoItem"..i]
		local ic = _G["MapQuestInfoRewardsFrameQuestInfoItem"..i.."IconTexture"]
		local na = _G["MapQuestInfoRewardsFrameQuestInfoItem"..i.."NameFrame"]
		local co = _G["MapQuestInfoRewardsFrameQuestInfoItem"..i.."Count"]

		ic:Point("TOPLEFT", 1, -1)
		ic:SetSize(39, 39)
		ic:SetTexCoord(.08, .92, .08, .92)
		ic:SetDrawLayer("OVERLAY")

		A:CreateBD(bu, .25)

		na:Hide()
		co:SetDrawLayer("OVERLAY")
		if not bu.IconBD then
			local border = CreateFrame("Frame", nil, bu)
			border:SetFrameLevel(frameLevel)
			border:SetOutside(ic, 1, 1)
			border:SetTemplate("Border")
			bu.IconBD = border
		end
		--local line = CreateFrame("Frame", nil, bu)
		--line:SetSize(40, 40)
		--line:Point("RIGHT", ic, 1, 0)
		--A:CreateBD(line)
		--bu.IconBD = A:CreateBDFrame(ic, 0)
		bu:StyleButton(1)
	end
	
	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, portrait, text, name, x, y)
		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x+6, y)
	end)
	--]]
	A:ReskinScroll(QuestProgressScrollFrameScrollBar)
	A:ReskinScroll(QuestRewardScrollFrameScrollBar)
	A:ReskinScroll(QuestDetailScrollFrameScrollBar)
	A:ReskinScroll(QuestGreetingScrollFrameScrollBar)
	A:ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)

	local buttons = {
		"QuestFrameAcceptButton",
		"QuestFrameDeclineButton",
		"QuestFrameCompleteQuestButton",
		"QuestFrameCompleteButton",
		"QuestFrameGoodbyeButton",
		"QuestFrameGreetingGoodbyeButton",
	}
	for i = 1, #buttons do
	local button = _G[buttons[i]]
		A:Reskin(button)
	end
	A:ReskinClose(QuestFrameCloseButton)
	--[[
	A:Reskin(WatchFrameCollapseExpandButton)
	local downtex = WatchFrameCollapseExpandButton:CreateTexture(nil, "ARTWORK")
	downtex:Size(8, 8)
	downtex:Point("CENTER", 1, 0)
	downtex:SetVertexColor(1, 1, 1)

	if WatchFrame.userCollapsed then
		downtex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-down-active")
	else
		downtex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-up-active")
	end

	hooksecurefunc("WatchFrame_Collapse", function() downtex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-down-active") end)
	hooksecurefunc("WatchFrame_Expand", function() downtex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-up-active") end)
	--]]
	--[[
	local function updateQuest()
		local numEntries = GetNumQuestLogEntries()

		local buttons = QuestLogScrollFrame.buttons
		local numButtons = #buttons
		local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
		local questLogTitle, questIndex
		local isHeader, isCollapsed

		for i = 1, numButtons do
			questLogTitle = buttons[i]
			questIndex = i + scrollOffset

			if not questLogTitle.reskinned then
				questLogTitle.reskinned = true

				questLogTitle:SetNormalTexture("")
				questLogTitle.SetNormalTexture = S.dummy
				questLogTitle:SetPushedTexture("")
				questLogTitle:SetHighlightTexture("")
				questLogTitle.SetHighlightTexture = S.dummy

				questLogTitle.bg = CreateFrame("Frame", nil, questLogTitle)
				questLogTitle.bg:Size(13, 13)
				questLogTitle.bg:Point("LEFT", 4, 0)
				questLogTitle.bg:SetFrameLevel(questLogTitle:GetFrameLevel()-1)
				A:CreateBD(questLogTitle.bg, 0)

				questLogTitle.tex = questLogTitle:CreateTexture(nil, "BACKGROUND")
				questLogTitle.tex:SetAllPoints(questLogTitle.bg)
				questLogTitle.tex:SetTexture(A["media"].backdrop)
				questLogTitle.tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

				questLogTitle.minus = questLogTitle:CreateTexture(nil, "OVERLAY")
				questLogTitle.minus:Size(7, 1)
				questLogTitle.minus:SetPoint("CENTER", questLogTitle.bg)
				questLogTitle.minus:SetTexture(A["media"].backdrop)
				questLogTitle.minus:SetVertexColor(1, 1, 1)

				questLogTitle.plus = questLogTitle:CreateTexture(nil, "OVERLAY")
				questLogTitle.plus:Size(1, 7)
				questLogTitle.plus:SetPoint("CENTER", questLogTitle.bg)
				questLogTitle.plus:SetTexture(A["media"].backdrop)
				questLogTitle.plus:SetVertexColor(1, 1, 1)
			end

			if questIndex <= numEntries then
				_, _, _, _, isHeader, isCollapsed = GetQuestLogTitle(questIndex)
				if isHeader then
					questLogTitle.bg:Show()
					questLogTitle.tex:Show()
					questLogTitle.minus:Show()
					if isCollapsed then
						questLogTitle.plus:Show()
					else
						questLogTitle.plus:Hide()
					end
				else
					questLogTitle.bg:Hide()
					questLogTitle.tex:Hide()
					questLogTitle.minus:Hide()
					questLogTitle.plus:Hide()
				end
			end
		end
	end
	--]]
	-- hooksecurefunc("QuestLog_Update", updateQuest)
	-- QuestLogScrollFrame:HookScript("OnVerticalScroll", updateQuest)
	-- QuestLogScrollFrame:HookScript("OnMouseWheel", updateQuest)
end

A:RegisterSkin("SunUI", LoadSkin)