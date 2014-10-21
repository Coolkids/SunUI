local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:SetBD(ArchaeologyFrame)
	A:Reskin(ArchaeologyFrameArtifactPageSolveFrameSolveButton)
	A:Reskin(ArchaeologyFrameArtifactPageBackButton)
	ArchaeologyFramePortrait:Hide()
	ArchaeologyFrame:DisableDrawLayer("BACKGROUND")
	ArchaeologyFrame:DisableDrawLayer("BORDER")
	ArchaeologyFrame:DisableDrawLayer("OVERLAY")
	ArchaeologyFrameInset:DisableDrawLayer("BACKGROUND")
	ArchaeologyFrameInset:DisableDrawLayer("BORDER")
	ArchaeologyFrameSummaryPageTitle:SetTextColor(1, 1, 1)
	ArchaeologyFrameArtifactPageHistoryTitle:SetTextColor(1, 1, 1)
	ArchaeologyFrameArtifactPageHistoryScrollChildText:SetTextColor(1, 1, 1)
	ArchaeologyFrameHelpPageTitle:SetTextColor(1, 1, 1)
	ArchaeologyFrameHelpPageDigTitle:SetTextColor(1, 1, 1)
	ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(1, 1, 1)
	ArchaeologyFrameCompletedPage:GetRegions():SetTextColor(1, 1, 1)
	ArchaeologyFrameCompletedPageTitle:SetTextColor(1, 1, 1)
	ArchaeologyFrameCompletedPageTitleTop:SetTextColor(1, 1, 1)
	ArchaeologyFrameCompletedPageTitleMid:SetTextColor(1, 1, 1)
	ArchaeologyFrameCompletedPagePageText:SetTextColor(1, 1, 1)
	ArchaeologyFrameSummaryPagePageText:SetTextColor(1, 1, 1)

	for i = 1, ARCHAEOLOGY_MAX_RACES do
		_G["ArchaeologyFrameSummaryPageRace"..i]:GetRegions():SetTextColor(1, 1, 1)
	end

	for i = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		local bu = _G["ArchaeologyFrameCompletedPageArtifact"..i]
		bu:GetRegions():Hide()
		select(2, bu:GetRegions()):Hide()
		select(3, bu:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		select(4, bu:GetRegions()):SetTextColor(1, 1, 1)
		select(5, bu:GetRegions()):SetTextColor(1, 1, 1)
		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		A:CreateBD(bg, .25)
		local vline = CreateFrame("Frame", nil, bu)
		vline:SetPoint("LEFT", 44, 0)
		vline:SetSize(1, 44)
		A:CreateBD(vline)
	end

	ArchaeologyFrameInfoButton:SetPoint("TOPLEFT", 3, -3)

	ArchaeologyFrameSummarytButton:SetPoint("TOPLEFT", ArchaeologyFrame, "TOPRIGHT", 1, -50)
	ArchaeologyFrameSummarytButton:SetFrameLevel(ArchaeologyFrame:GetFrameLevel()-1)
	ArchaeologyFrameCompletedButton:SetPoint("TOPLEFT", ArchaeologyFrame, "TOPRIGHT", 1, -120)
	ArchaeologyFrameCompletedButton:SetFrameLevel(ArchaeologyFrame:GetFrameLevel()-1)

	A:ReskinDropDown(ArchaeologyFrameRaceFilter)
	A:ReskinClose(ArchaeologyFrameCloseButton)
	A:ReskinScroll(ArchaeologyFrameArtifactPageHistoryScrollScrollBar)
	A:ReskinArrow(ArchaeologyFrameCompletedPagePrevPageButton, "left")
	A:ReskinArrow(ArchaeologyFrameCompletedPageNextPageButton, "right")
	ArchaeologyFrameCompletedPagePrevPageButtonIcon:Hide()
	ArchaeologyFrameCompletedPageNextPageButtonIcon:Hide()
	A:ReskinArrow(ArchaeologyFrameSummaryPagePrevPageButton, "left")
	A:ReskinArrow(ArchaeologyFrameSummaryPageNextPageButton, "right")
	ArchaeologyFrameSummaryPagePrevPageButtonIcon:Hide()
	ArchaeologyFrameSummaryPageNextPageButtonIcon:Hide()

	ArchaeologyFrameRankBarBorder:Hide()
	ArchaeologyFrameRankBarBackground:Hide()
	ArchaeologyFrameRankBarBar:SetTexture(A.media.backdrop)
	ArchaeologyFrameRankBarBar:SetGradient("VERTICAL", 0, .65, 0, 0, .75, 0)
	ArchaeologyFrameRankBar:SetHeight(14)
	A:CreateBD(ArchaeologyFrameRankBar, .25)

	ArchaeologyFrameArtifactPageSolveFrameStatusBarBarBG:Hide()
	local bar = select(3, ArchaeologyFrameArtifactPageSolveFrameStatusBar:GetRegions())
	bar:SetTexture(A.media.backdrop)
	bar:SetGradient("VERTICAL", .65, .25, 0, .75, .35, .1)

	local bg = CreateFrame("Frame", nil, ArchaeologyFrameArtifactPageSolveFrameStatusBar)
	bg:SetPoint("TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(0)
	A:CreateBD(bg, .25)

	ArchaeologyFrameArtifactPageIcon:SetTexCoord(.08, .92, .08, .92)
	A:CreateBG(ArchaeologyFrameArtifactPageIcon)
end

A:RegisterSkin("Blizzard_ArchaeologyUI", LoadSkin)
