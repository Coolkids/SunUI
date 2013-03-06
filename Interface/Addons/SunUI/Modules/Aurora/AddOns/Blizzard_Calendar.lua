local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_Calendar"] = function()

	CalendarFrame:DisableDrawLayer("BORDER")

	for i = 1, 9 do
		select(i, CalendarViewEventFrame:GetRegions()):Hide()
	end
	select(15, CalendarViewEventFrame:GetRegions()):Hide()

	for i = 1, 9 do
		select(i, CalendarViewHolidayFrame:GetRegions()):Hide()
		select(i, CalendarViewRaidFrame:GetRegions()):Hide()
	end

	for i = 1, 3 do
		select(i, CalendarCreateEventTitleFrame:GetRegions()):Hide()
		select(i, CalendarViewEventTitleFrame:GetRegions()):Hide()
		select(i, CalendarViewHolidayTitleFrame:GetRegions()):Hide()
		select(i, CalendarViewRaidTitleFrame:GetRegions()):Hide()
		select(i, CalendarMassInviteTitleFrame:GetRegions()):Hide()
	end

	for i = 1, 42 do
		_G["CalendarDayButton"..i.."DarkFrame"]:SetAlpha(.5)
		local bu = _G["CalendarDayButton"..i]
		bu:DisableDrawLayer("BACKGROUND")
		bu:SetHighlightTexture(DB.media.backdrop)
		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .2)
		hl.SetAlpha = S.dummy
		hl:Point("TOPLEFT", -1, 1)
		hl:SetPoint("BOTTOMRIGHT")
	end

	for i = 1, 7 do
		_G["CalendarWeekday"..i.."Background"]:SetAlpha(0)
	end

	CalendarViewEventDivider:Hide()
	CalendarCreateEventDivider:Hide()
	CalendarViewEventInviteList:GetRegions():Hide()
	CalendarViewEventDescriptionContainer:GetRegions():Hide()
	select(5, CalendarCreateEventCloseButton:GetRegions()):Hide()
	select(5, CalendarViewEventCloseButton:GetRegions()):Hide()
	select(5, CalendarViewHolidayCloseButton:GetRegions()):Hide()
	select(5, CalendarViewRaidCloseButton:GetRegions()):Hide()
	select(5, CalendarMassInviteCloseButton:GetRegions()):Hide()
	CalendarCreateEventBackground:Hide()
	CalendarCreateEventFrameButtonBackground:Hide()
	CalendarCreateEventMassInviteButtonBorder:Hide()
	CalendarCreateEventCreateButtonBorder:Hide()
	CalendarEventPickerTitleFrameBackgroundLeft:Hide()
	CalendarEventPickerTitleFrameBackgroundMiddle:Hide()
	CalendarEventPickerTitleFrameBackgroundRight:Hide()
	CalendarEventPickerFrameButtonBackground:Hide()
	CalendarEventPickerCloseButtonBorder:Hide()
	CalendarCreateEventRaidInviteButtonBorder:Hide()
	CalendarMonthBackground:SetAlpha(0)
	CalendarYearBackground:SetAlpha(0)
	CalendarFrameModalOverlay:SetAlpha(.25)
	CalendarViewHolidayInfoTexture:SetAlpha(0)
	CalendarTexturePickerTitleFrameBackgroundLeft:Hide()
	CalendarTexturePickerTitleFrameBackgroundMiddle:Hide()
	CalendarTexturePickerTitleFrameBackgroundRight:Hide()
	CalendarTexturePickerFrameButtonBackground:Hide()
	CalendarTexturePickerAcceptButtonBorder:Hide()
	CalendarTexturePickerCancelButtonBorder:Hide()
	CalendarClassTotalsButtonBackgroundTop:Hide()
	CalendarClassTotalsButtonBackgroundMiddle:Hide()
	CalendarClassTotalsButtonBackgroundBottom:Hide()
	CalendarFilterFrameLeft:Hide()
	CalendarFilterFrameMiddle:Hide()
	CalendarFilterFrameRight:Hide()
		CalendarMassInviteFrameDivider:Hide()

	S.SetBD(CalendarFrame, 12, 0, -9, 4)
	S.CreateBD(CalendarViewEventFrame)
	S.CreateBD(CalendarViewHolidayFrame)
	S.CreateBD(CalendarViewRaidFrame)
	S.CreateBD(CalendarCreateEventFrame)
	S.CreateBD(CalendarClassTotalsButton)
	S.CreateBD(CalendarTexturePickerFrame)
	S.CreateBD(CalendarViewEventInviteList, .25)
	S.CreateBD(CalendarViewEventDescriptionContainer, .25)
	S.CreateBD(CalendarCreateEventInviteList, .25)
	S.CreateBD(CalendarCreateEventDescriptionContainer, .25)
	S.CreateBD(CalendarEventPickerFrame, .25)
	S.CreateBD(CalendarMassInviteFrame)

	CalendarWeekdaySelectedTexture:SetDesaturated(true)
	CalendarWeekdaySelectedTexture:SetVertexColor(r, g, b)

	hooksecurefunc("CalendarFrame_SetToday", function()
		CalendarTodayFrame:SetAllPoints()
	end)

	CalendarTodayFrame:SetScript("OnUpdate", nil)
	CalendarTodayTextureGlow:Hide()
	CalendarTodayTexture:Hide()

	CalendarTodayFrame:SetBackdrop({
		edgeFile = DB.media.backdrop,
		edgeSize = 1,
	})
	CalendarTodayFrame:SetBackdropBorderColor(r, g, b)

	for i, class in ipairs(CLASS_SORT_ORDER) do
		local bu = _G["CalendarClassButton"..i]
		bu:GetRegions():Hide()
		S.CreateBG(bu)

		local tcoords = CLASS_ICON_TCOORDS[class]
		local ic = bu:GetNormalTexture()
		ic:SetTexCoord(tcoords[1] + 0.015, tcoords[2] - 0.02, tcoords[3] + 0.018, tcoords[4] - 0.02)
	end

	local bd = CreateFrame("Frame", nil, CalendarFilterFrame)
	bd:Point("TOPLEFT", 40, 0)
	bd:Point("BOTTOMRIGHT", -19, 0)
	bd:SetFrameLevel(CalendarFilterFrame:GetFrameLevel()-1)
	S.CreateBD(bd, 0)

	S.CreateGradient(bd)

	local downtex = CalendarFilterButton:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(DB.media.arrowDown)
	downtex:Size(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)

	for i = 1, 6 do
		local vline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
		vline:Height(546)
		vline:Width(1)
		vline:SetPoint("TOP", _G["CalendarDayButton"..i], "TOPRIGHT")
		S.CreateBD(vline)
	end
	for i = 1, 36, 7 do
		local hline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
		hline:Width(637)
		hline:Height(1)
		hline:SetPoint("LEFT", _G["CalendarDayButton"..i], "TOPLEFT")
		S.CreateBD(hline)
	end

	if not(IsAddOnLoaded("CowTip") or IsAddOnLoaded("TipTac") or IsAddOnLoaded("FreebTip") or IsAddOnLoaded("lolTip") or IsAddOnLoaded("StarTip") or IsAddOnLoaded("TipTop")) then
		local tooltips = {CalendarContextMenu, CalendarInviteStatusContextMenu}

		for _, tooltip in pairs(tooltips) do
			tooltip:SetBackdrop(nil)
			local bg = CreateFrame("Frame", nil, tooltip)
			bg:Point("TOPLEFT", 2, -2)
			bg:Point("BOTTOMRIGHT", -1, 2)
			bg:SetFrameLevel(tooltip:GetFrameLevel()-1)
			S.CreateBD(bg)
		end
	end

	CalendarViewEventFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarViewHolidayFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarViewRaidFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarCreateEventFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarCreateEventInviteButton:Point("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 1, 1)
	CalendarClassButton1:Point("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)

	CalendarCreateEventHourDropDown:Width(80)
	CalendarCreateEventMinuteDropDown:Width(80)
	CalendarCreateEventAMPMDropDown:Width(90)

	local line = CalendarMassInviteFrame:CreateTexture(nil, "BACKGROUND")
	line:Size(240, 1)
	line:Point("TOP", CalendarMassInviteFrame, "TOP", 0, -150)
	line:SetTexture(DB.media.backdrop)
	line:SetVertexColor(0, 0, 0)

	CalendarMassInviteFrame:ClearAllPoints()
	CalendarMassInviteFrame:Point("BOTTOMLEFT", CalendarCreateEventCreateButton, "TOPRIGHT", 10, 0)

	CalendarTexturePickerFrame:ClearAllPoints()
	CalendarTexturePickerFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", 311, -24)

	local cbuttons = {"CalendarViewEventAcceptButton", "CalendarViewEventTentativeButton", "CalendarViewEventDeclineButton", "CalendarViewEventRemoveButton", "CalendarCreateEventMassInviteButton", "CalendarCreateEventCreateButton", "CalendarCreateEventInviteButton", "CalendarEventPickerCloseButton", "CalendarCreateEventRaidInviteButton", "CalendarTexturePickerAcceptButton", "CalendarTexturePickerCancelButton", "CalendarFilterButton", "CalendarMassInviteGuildAcceptButton", "CalendarMassInviteArenaButton2", "CalendarMassInviteArenaButton3", "CalendarMassInviteArenaButton5"}
	for i = 1, #cbuttons do
		local cbutton = _G[cbuttons[i]]
		S.Reskin(cbutton)
	end

	S.ReskinClose(CalendarCloseButton, "TOPRIGHT", CalendarFrame, "TOPRIGHT", -14, -4)
	S.ReskinClose(CalendarCreateEventCloseButton)
	S.ReskinClose(CalendarViewEventCloseButton)
	S.ReskinClose(CalendarViewHolidayCloseButton)
	S.ReskinClose(CalendarViewRaidCloseButton)
	S.ReskinClose(CalendarMassInviteCloseButton)
	S.ReskinScroll(CalendarTexturePickerScrollBar)
	S.ReskinScroll(CalendarViewEventInviteListScrollFrameScrollBar)
	S.ReskinScroll(CalendarViewEventDescriptionScrollFrameScrollBar)
	S.ReskinScroll(CalendarCreateEventInviteListScrollFrameScrollBar)
	S.ReskinScroll(CalendarCreateEventDescriptionScrollFrameScrollBar)
	S.ReskinDropDown(CalendarCreateEventTypeDropDown)
	S.ReskinDropDown(CalendarCreateEventHourDropDown)
	S.ReskinDropDown(CalendarCreateEventMinuteDropDown)
	S.ReskinDropDown(CalendarCreateEventAMPMDropDown)
	S.ReskinDropDown(CalendarMassInviteGuildRankMenu)
	S.ReskinInput(CalendarCreateEventTitleEdit)
	S.ReskinInput(CalendarCreateEventInviteEdit)
	S.ReskinInput(CalendarMassInviteGuildMinLevelEdit)
	S.ReskinInput(CalendarMassInviteGuildMaxLevelEdit)
	S.ReskinArrow(CalendarPrevMonthButton, "left")
	S.ReskinArrow(CalendarNextMonthButton, "right")
	CalendarPrevMonthButton:Size(19, 19)
	CalendarNextMonthButton:Size(19, 19)
	S.ReskinCheck(CalendarCreateEventLockEventCheck)
end