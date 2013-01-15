SStaticPopup_DisplayedFrames = { };

SSTATICPOPUP_NUMDIALOGS = 4;
SSTATICPOPUP_TIMEOUT = 60;
SSTATICPOPUP_TEXTURE_ALERT = "Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew";
SSTATICPOPUP_TEXTURE_ALERTGEAR = "Interface\\DialogFrame\\UI-Dialog-Icon-AlertOther";
SStaticPopupDialogs = { };

function SStaticPopup_FindVisible(which, data)
	local info = SStaticPopupDialogs[which];
	if ( not info ) then
		return nil;
	end
	for index = 1, SSTATICPOPUP_NUMDIALOGS, 1 do
		local frame = _G["SStaticPopup"..index];
		if ( frame:IsShown() and (frame.which == which) and (not info.multiple or (frame.data == data)) ) then
			return frame;
		end
	end
	return nil;
end

function SStaticPopup_Resize(dialog, which)
	local info = SStaticPopupDialogs[which];
	if ( not info ) then
		return nil;
	end

	local text = _G[dialog:GetName().."Text"];
	local editBox = _G[dialog:GetName().."EditBox"];
	local button1 = _G[dialog:GetName().."Button1"];
	
	local maxHeightSoFar, maxWidthSoFar = (dialog.maxHeightSoFar or 0), (dialog.maxWidthSoFar or 0);
	local width = 320;
	
	if ( dialog.numButtons == 3 ) then
		width = 440;
	elseif (info.showAlert or info.showAlertGear or info.closeButton) then
		-- Widen
		width = 420;
	elseif ( info.editBoxWidth and info.editBoxWidth > 260 ) then
		width = width + (info.editBoxWidth - 260);
	elseif ( which == "HELP_TICKET" ) then
		width = 350;
	elseif ( which == "GUILD_IMPEACH" ) then
		width = 375;
	end
	if ( width > maxWidthSoFar )  then
		dialog:SetWidth(width);
		dialog.maxWidthSoFar = width;
	end
	
	local height = 32 + text:GetHeight() + 8 + button1:GetHeight();
	if ( info.hasEditBox ) then
		height = height + 8 + editBox:GetHeight();
	elseif ( info.hasMoneyFrame ) then
		height = height + 16;
	elseif ( info.hasMoneyInputFrame ) then
		height = height + 22;
	end
	if ( info.hasItemFrame ) then
		height = height + 64;
	end

	if ( height > maxHeightSoFar ) then
		dialog:SetHeight(height);
		dialog.maxHeightSoFar = height;
	end
end

local tempButtonLocs = {};	--So we don't make a new table each time.
function SStaticPopup_Show(which, text_arg1, text_arg2, data)
	local info = SStaticPopupDialogs[which];
	if ( not info ) then
		return nil;
	end

	if ( UnitIsDeadOrGhost("player") and not info.whileDead ) then
		if ( info.OnCancel ) then
			info.OnCancel();
		end
		return nil;
	end

	if ( InCinematic() and not info.interruptCinematic ) then
		if ( info.OnCancel ) then
			info.OnCancel();
		end
		return nil;
	end

	if ( info.exclusive ) then
		SStaticPopup_HideExclusive();
	end

	if ( info.cancels ) then
		for index = 1, SSTATICPOPUP_NUMDIALOGS, 1 do
			local frame = _G["SStaticPopup"..index];
			if ( frame:IsShown() and (frame.which == info.cancels) ) then
				frame:Hide();
				local OnCancel = SStaticPopupDialogs[frame.which].OnCancel;
				if ( OnCancel ) then
					OnCancel(frame, frame.data, "override");
				end
			end
		end
	end

	if ( (which == "CAMP") or (which == "QUIT") ) then
		for index = 1, SSTATICPOPUP_NUMDIALOGS, 1 do
			local frame = _G["SStaticPopup"..index];
			if ( frame:IsShown() and not SStaticPopupDialogs[frame.which].notClosableByLogout ) then
				frame:Hide();
				local OnCancel = SStaticPopupDialogs[frame.which].OnCancel;
				if ( OnCancel ) then
					OnCancel(frame, frame.data, "override");
				end
			end
		end
	end

	if ( which == "DEATH" ) then
		for index = 1, SSTATICPOPUP_NUMDIALOGS, 1 do
			local frame = _G["SStaticPopup"..index];
			if ( frame:IsShown() and not SStaticPopupDialogs[frame.which].whileDead ) then
				frame:Hide();
				local OnCancel = SStaticPopupDialogs[frame.which].OnCancel;
				if ( OnCancel ) then
					OnCancel(frame, frame.data, "override");
				end
			end
		end
	end

	-- Pick a free dialog to use
	local dialog = nil;
	-- Find an open dialog of the requested type
	dialog = SStaticPopup_FindVisible(which, data);
	if ( dialog ) then
		if ( not info.noCancelOnReuse ) then
			local OnCancel = info.OnCancel;
			if ( OnCancel ) then
				OnCancel(dialog, dialog.data, "override");
			end
		end
		dialog:Hide();
	end
	if ( not dialog ) then
		-- Find a free dialog
		local index = 1;
		if ( info.preferredIndex ) then
			index = info.preferredIndex;
		end
		for i = index, SSTATICPOPUP_NUMDIALOGS do
			local frame = _G["SStaticPopup"..i];
			if ( not frame:IsShown() ) then
				dialog = frame;
				break;
			end
		end

		--If dialog not found and there's a preferredIndex then try to find an available frame before the preferredIndex
		if ( not dialog and info.preferredIndex ) then
			for i = 1, info.preferredIndex do
				local frame = _G["SStaticPopup"..i];
				if ( not frame:IsShown() ) then
					dialog = frame;
					break;
				end
			end
		end
	end
	if ( not dialog ) then
		if ( info.OnCancel ) then
			info.OnCancel();
		end
		return nil;
	end

	dialog.maxHeightSoFar, dialog.maxWidthSoFar = 0, 0;
	-- Set the text of the dialog
	local text = _G[dialog:GetName().."Text"];
	if ( (which == "DEATH") or
	     (which == "CAMP") or
		 (which == "QUIT") or
		 (which == "DUEL_OUTOFBOUNDS") or
		 (which == "RECOVER_CORPSE") or
		 (which == "RESURRECT") or
		 (which == "RESURRECT_NO_SICKNESS") or
		 (which == "INSTANCE_BOOT") or
		 (which == "INSTANCE_LOCK") or
		 (which == "CONFIRM_SUMMON") or
		 (which == "BFMGR_INVITED_TO_ENTER") or
		 (which == "AREA_SPIRIT_HEAL") ) then
		text:SetText(" ");	-- The text will be filled in later.
		text.text_arg1 = text_arg1;
		text.text_arg2 = text_arg2;
	elseif ( which == "BILLING_NAG" ) then
		text:SetFormattedText(info.text, text_arg1, MINUTES);
	elseif ( which == "SPELL_CONFIRMATION_PROMPT" ) then
		text:SetText(text_arg1);
		info.text = text_arg1;
		info.timeout = text_arg2;
	else
		text:SetFormattedText(info.text, text_arg1, text_arg2);
	end

	-- Show or hide the close button
	if ( info.closeButton ) then
		local closeButton = _G[dialog:GetName().."CloseButton"];
		if ( info.closeButtonIsHide ) then
			closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-HideButton-Up");
			closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-HideButton-Down");
		else
			closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up");
			closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down");
		end
		closeButton:Show();
	else
		_G[dialog:GetName().."CloseButton"]:Hide();
	end

	-- Set the editbox of the dialog
	local editBox = _G[dialog:GetName().."EditBox"];
	if ( info.hasEditBox ) then
		editBox:Show();

		if ( info.maxLetters ) then
			editBox:SetMaxLetters(info.maxLetters);
			editBox:SetCountInvisibleLetters(info.countInvisibleLetters);
		end
		if ( info.maxBytes ) then
			editBox:SetMaxBytes(info.maxBytes);
		end
		editBox:SetText("");
		if ( info.editBoxWidth ) then
			editBox:SetWidth(info.editBoxWidth);
		else
			editBox:SetWidth(130);
		end
	else
		editBox:Hide();
	end

	-- Show or hide money frame
	if ( info.hasMoneyFrame ) then
		_G[dialog:GetName().."MoneyFrame"]:Show();
		_G[dialog:GetName().."MoneyInputFrame"]:Hide();
	elseif ( info.hasMoneyInputFrame ) then
		local moneyInputFrame = _G[dialog:GetName().."MoneyInputFrame"];
		moneyInputFrame:Show();
		_G[dialog:GetName().."MoneyFrame"]:Hide();
		-- Set OnEnterPress for money input frames
		if ( info.EditBoxOnEnterPressed ) then
			moneyInputFrame.gold:SetScript("OnEnterPressed", SStaticPopup_EditBoxOnEnterPressed);
			moneyInputFrame.silver:SetScript("OnEnterPressed", SStaticPopup_EditBoxOnEnterPressed);
			moneyInputFrame.copper:SetScript("OnEnterPressed", SStaticPopup_EditBoxOnEnterPressed);
		else
			moneyInputFrame.gold:SetScript("OnEnterPressed", nil);
			moneyInputFrame.silver:SetScript("OnEnterPressed", nil);
			moneyInputFrame.copper:SetScript("OnEnterPressed", nil);
		end
	else
		_G[dialog:GetName().."MoneyFrame"]:Hide();
		_G[dialog:GetName().."MoneyInputFrame"]:Hide();
	end

	-- Show or hide item button
	if ( info.hasItemFrame ) then
		_G[dialog:GetName().."ItemFrame"]:Show();
		if ( data and type(data) == "table" ) then
			_G[dialog:GetName().."ItemFrame"].link = data.link
			_G[dialog:GetName().."ItemFrameIconTexture"]:SetTexture(data.texture);
			local nameText = _G[dialog:GetName().."ItemFrameText"];
			nameText:SetTextColor(unpack(data.color or {1, 1, 1, 1}));
			nameText:SetText(data.name);
			if ( data.count and data.count > 1 ) then
				_G[dialog:GetName().."ItemFrameCount"]:SetText(data.count);
				_G[dialog:GetName().."ItemFrameCount"]:Show();
			else
				_G[dialog:GetName().."ItemFrameCount"]:Hide();
			end
		end
	else
		_G[dialog:GetName().."ItemFrame"]:Hide();
	end

	-- Set the miscellaneous variables for the dialog
	dialog.which = which;
	dialog.timeleft = info.timeout or 0;
	dialog.hideOnEscape = info.hideOnEscape;
	dialog.exclusive = info.exclusive;
	dialog.enterClicksFirstButton = info.enterClicksFirstButton;
	-- Clear out data
	dialog.data = data;
	--print(dialog)
	-- Set the buttons of the dialog
	local button1 = _G[dialog:GetName().."Button1"];
	local button2 = _G[dialog:GetName().."Button2"];
	local button3 = _G[dialog:GetName().."Button3"];
	
	do	--If there is any recursion in this block, we may get errors (tempButtonLocs is static). If you have to recurse, we'll have to create a new table each time.
		assert(#tempButtonLocs == 0);	--If this fails, we're recursing. (See the table.wipe at the end of the block)
		
		tinsert(tempButtonLocs, button1);
		tinsert(tempButtonLocs, button2);
		tinsert(tempButtonLocs, button3);
		
		for i=#tempButtonLocs, 1, -1 do
			--Do this stuff before we move it. (This is why we go back-to-front)
			tempButtonLocs[i]:SetText(info["button"..i]);
			tempButtonLocs[i]:Hide();
			tempButtonLocs[i]:ClearAllPoints();
			--Now we possibly remove it.
			if ( not (info["button"..i] and ( not info["DisplayButton"..i] or info["DisplayButton"..i](dialog))) ) then
				tremove(tempButtonLocs, i);
			end
		end
		
		local numButtons = #tempButtonLocs;
		--Save off the number of buttons.
		dialog.numButtons = numButtons;
		
		if ( numButtons == 3 ) then
			tempButtonLocs[1]:SetPoint("BOTTOMRIGHT", dialog, "BOTTOM", -72, 16);
		elseif ( numButtons == 2 ) then
			tempButtonLocs[1]:SetPoint("BOTTOMRIGHT", dialog, "BOTTOM", -6, 16);
		elseif ( numButtons == 1 ) then
			tempButtonLocs[1]:SetPoint("BOTTOM", dialog, "BOTTOM", 0, 16);
		end
		
		for i=1, numButtons do
			if ( i > 1 ) then
				tempButtonLocs[i]:SetPoint("LEFT", tempButtonLocs[i-1], "RIGHT", 13, 0);
			end
			
			local width = tempButtonLocs[i]:GetTextWidth();
			if ( width > 110 ) then
				tempButtonLocs[i]:SetWidth(width + 20);
			else
				tempButtonLocs[i]:SetWidth(120);
			end
			tempButtonLocs[i]:Enable();
			tempButtonLocs[i]:Show();
		end
		
		table.wipe(tempButtonLocs);
	end

	-- Show or hide the alert icon
	local alertIcon = _G[dialog:GetName().."AlertIcon"];
	if ( info.showAlert ) then
		alertIcon:SetTexture(STATICPOPUP_TEXTURE_ALERT);
		if ( button3:IsShown() )then
			alertIcon:SetPoint("LEFT", 24, 10);
		else
			alertIcon:SetPoint("LEFT", 24, 0);
		end
		alertIcon:Show();
	elseif ( info.showAlertGear ) then
		alertIcon:SetTexture(SSTATICPOPUP_TEXTURE_ALERTGEAR);
		if ( button3:IsShown() )then
			alertIcon:SetPoint("LEFT", 24, 0);
		else
			alertIcon:SetPoint("LEFT", 24, 0);
		end
		alertIcon:Show();
	else
		alertIcon:SetTexture();
		alertIcon:Hide();
	end

	if ( info.StartDelay ) then
		dialog.startDelay = info.StartDelay();
		button1:Disable();
	else
		dialog.startDelay = nil;
		button1:Enable();
	end

	editBox.autoCompleteParams = info.autoCompleteParams;
	editBox.autoCompleteRegex = info.autoCompleteRegex;
	editBox.autoCompleteFormatRegex = info.autoCompleteFormatRegex;
	
	editBox.addHighlightedText = true;
	--print(dialog:GetName())
	-- Finally size and show the dialog
	SStaticPopup_SetUpPosition(dialog);
	dialog:Show();
	
	SStaticPopup_Resize(dialog, which);

	if ( info.sound ) then
		PlaySound(info.sound);
	end

	return dialog;
end

function SStaticPopup_Hide(which, data)
	for index = 1, SSTATICPOPUP_NUMDIALOGS, 1 do
		local dialog = _G["SStaticPopup"..index];
		if ( (dialog.which == which) and (not data or (data == dialog.data)) ) then
			dialog:Hide();
		end
	end
end

function SStaticPopup_OnUpdate(dialog, elapsed)
	if ( dialog.timeleft > 0 ) then
		local which = dialog.which;
		local timeleft = dialog.timeleft - elapsed;
		if ( timeleft <= 0 ) then
			if ( not SStaticPopupDialogs[which].timeoutInformationalOnly ) then
				dialog.timeleft = 0;
				local OnCancel = SStaticPopupDialogs[which].OnCancel;
				if ( OnCancel ) then
					OnCancel(dialog, dialog.data, "timeout");
				end
				dialog:Hide();
			end
			return;
		end
		dialog.timeleft = timeleft;

		if ( (which == "DEATH") or
		     (which == "CAMP")  or
			 (which == "QUIT") or
			 (which == "DUEL_OUTOFBOUNDS") or
			 (which == "INSTANCE_BOOT") or
			 (which == "CONFIRM_SUMMON") or
			 (which == "BFMGR_INVITED_TO_ENTER") or
			 (which == "AREA_SPIRIT_HEAL") or
			 (which == "SPELL_CONFIRMATION_PROMPT")) then
			local text = _G[dialog:GetName().."Text"];
			local hasText = nil;
			if ( text:GetText() ~= " " ) then
				hasText = 1;
			end
			timeleft = ceil(timeleft);
			if ( which == "INSTANCE_BOOT" ) then
				if ( timeleft < 60 ) then
					text:SetFormattedText(SStaticPopupDialogs[which].text, timeleft, SECONDS);
				else
					text:SetFormattedText(SStaticPopupDialogs[which].text, ceil(timeleft / 60), MINUTES);
				end
			elseif ( which == "CONFIRM_SUMMON" ) then
				if ( timeleft < 60 ) then
					text:SetFormattedText(SStaticPopupDialogs[which].text, GetSummonConfirmSummoner(), GetSummonConfirmAreaName(), timeleft, SECONDS);
				else
					text:SetFormattedText(SStaticPopupDialogs[which].text, GetSummonConfirmSummoner(), GetSummonConfirmAreaName(), ceil(timeleft / 60), MINUTES);
				end
			elseif ( which == "BFMGR_INVITED_TO_ENTER") then
				if ( timeleft < 60 ) then
					text:SetFormattedText(SStaticPopupDialogs[which].text, text.text_arg1, timeleft, SECONDS);
				else
					text:SetFormattedText(SStaticPopupDialogs[which].text, text.text_arg1, ceil(timeleft / 60), MINUTES);
				end
			elseif ( which == "SPELL_CONFIRMATION_PROMPT") then
				local time = "";
				if ( timeleft < 60 ) then
					text:SetFormattedText(ERR_SPELL_FAILED_S, timeleft, SECONDS);
				else
					text:SetFormattedText(ERR_SPELL_FAILED_S, ceil(timeleft / 60), MINUTES);
				end
				text:SetText(SStaticPopupDialogs[which].text .. " " ..TIME_REMAINING .. text:GetText());
			else
				if ( timeleft < 60 ) then
					text:SetFormattedText(SStaticPopupDialogs[which].text, timeleft, SECONDS);
				else
					text:SetFormattedText(SStaticPopupDialogs[which].text, ceil(timeleft / 60), MINUTES);
				end
			end
			if ( not hasText ) then
				SStaticPopup_Resize(dialog, which);
			end
		end
	end
	if ( dialog.startDelay ) then
		local which = dialog.which;
		local timeleft = dialog.startDelay - elapsed;
		if ( timeleft <= 0 ) then
			dialog.startDelay = nil;
			local text = _G[dialog:GetName().."Text"];
			text:SetFormattedText(SStaticPopupDialogs[which].text, text.text_arg1, text.text_arg2);
			local button1 = _G[dialog:GetName().."Button1"];
			button1:Enable();
			SStaticPopup_Resize(dialog, which);
			return;
		end
		dialog.startDelay = timeleft;

		if ( which == "RECOVER_CORPSE" or (which == "RESURRECT") or (which == "RESURRECT_NO_SICKNESS") ) then
			local text = _G[dialog:GetName().."Text"];
			local hasText = nil;
			if ( text:GetText() ~= " " ) then
				hasText = 1;
			end
			timeleft = ceil(timeleft);
			if ( (which == "RESURRECT") or (which == "RESURRECT_NO_SICKNESS") ) then
				if ( timeleft < 60 ) then
					text:SetFormattedText(SStaticPopupDialogs[which].delayText, text.text_arg1, timeleft, SECONDS);
				else
					text:SetFormattedText(SStaticPopupDialogs[which].delayText, text.text_arg1, ceil(timeleft / 60), MINUTES);
				end
			else
				if ( timeleft < 60 ) then
					text:SetFormattedText(SStaticPopupDialogs[which].delayText, timeleft, SECONDS);
				else
					text:SetFormattedText(SStaticPopupDialogs[which].delayText, ceil(timeleft / 60), MINUTES);
				end
			end
			if ( not hasText ) then
				SStaticPopup_Resize(dialog, which);
			end
		end
	end

	local onUpdate = SStaticPopupDialogs[dialog.which].OnUpdate;
	if ( onUpdate ) then
		onUpdate(dialog, elapsed);
	end
end

function SStaticPopup_EditBoxOnEnterPressed(self)
	local EditBoxOnEnterPressed, which, dialog;
	local parent = self:GetParent();
	if ( parent.which ) then
		which = parent.which;
		dialog = parent;
	elseif ( parent:GetParent().which ) then
		-- This is needed if this is a money input frame since it's nested deeper than a normal edit box
		which = parent:GetParent().which;
		dialog = parent:GetParent();
	end
	if ( not self.autoCompleteParams or not AutoCompleteEditBox_OnEnterPressed(self) ) then
		EditBoxOnEnterPressed = SStaticPopupDialogs[which].EditBoxOnEnterPressed;
		if ( EditBoxOnEnterPressed ) then
			EditBoxOnEnterPressed(self, dialog.data);
		end
	end
end

function SStaticPopup_EditBoxOnEscapePressed(self)
	local EditBoxOnEscapePressed = SStaticPopupDialogs[self:GetParent().which].EditBoxOnEscapePressed;
	if ( EditBoxOnEscapePressed ) then
		EditBoxOnEscapePressed(self, self:GetParent().data);
	end
end

function SStaticPopup_EditBoxOnEscapePressed(self, userInput)
	if ( not self.autoCompleteParams or not AutoCompleteEditBox_OnTextChanged(self, userInput) ) then
		local EditBoxOnTextChanged = SStaticPopupDialogs[self:GetParent().which].EditBoxOnTextChanged;
		if ( EditBoxOnTextChanged ) then
			EditBoxOnTextChanged(self, self:GetParent().data);
		end
	end
end

function SStaticPopup_OnShow(self)
	PlaySound("igMainMenuOpen");

	local dialog = SStaticPopupDialogs[self.which];
	local OnShow = dialog.OnShow;

	if ( OnShow ) then
		OnShow(self, self.data);
	end
	if ( dialog.hasMoneyInputFrame ) then
		_G[self:GetName().."MoneyInputFrameGold"]:SetFocus();
	end
	if ( dialog.enterClicksFirstButton ) then
		self:SetScript("OnKeyDown", SStaticPopup_OnKeyDown);
	end
end

function SStaticPopup_OnHide(self)
	PlaySound("igMainMenuClose");

	SStaticPopup_CollapseTable();
	
	local dialog = SStaticPopupDialogs[self.which];
	local OnHide = dialog.OnHide;
	if ( OnHide ) then
		OnHide(self, self.data);
	end
	self.extraFrame:Hide();
	if ( dialog.enterClicksFirstButton ) then
		self:SetScript("OnKeyDown", nil);
	end
end

function SStaticPopup_OnClick(dialog, index)
	if ( not dialog:IsShown() ) then
		return;
	end
	local which = dialog.which;
	local info = SStaticPopupDialogs[which];
	if ( not info ) then
		return nil;
	end
	local hide = true;
	if ( index == 1 ) then
		local OnAccept = info.OnAccept;
		if ( OnAccept ) then
			hide = not OnAccept(dialog, dialog.data, dialog.data2);
		end
	elseif ( index == 3 ) then
		local OnAlt = info.OnAlt;
		if ( OnAlt ) then
			OnAlt(dialog, dialog.data, "clicked");
		end
	else
		local OnCancel = info.OnCancel;
		if ( OnCancel ) then
			hide = not OnCancel(dialog, dialog.data, "clicked");
		end
	end

	if ( hide and (which == dialog.which) ) then
		-- can dialog.which change inside one of the On* functions???
		dialog:Hide();
	end
end

function SStaticPopup_OnKeyDown(self, key)
	-- previously, SStaticPopup_EscapePressed() captured the escape key for dialogs, but now we need
	-- to catch it here
	if ( GetBindingFromClick(key) == "TOGGLEGAMEMENU" ) then
		return SStaticPopup_EscapePressed();
	elseif ( GetBindingFromClick(key) == "SCREENSHOT" ) then
		RunBinding("SCREENSHOT");
		return;
	end

	local dialog = SStaticPopupDialogs[self.which];
	if ( dialog ) then
		if ( key == "ENTER" and dialog.enterClicksFirstButton ) then
			local frameName = self:GetName();
			local button;
			local i = 1;
			while ( true ) do
				button = _G[frameName.."Button"..i];
				if ( button ) then
					if ( button:IsShown() ) then
						SStaticPopup_OnClick(self, i);
						return;
					end
					i = i + 1;
				else
					break;
				end
			end
		end
	end
end

function SStaticPopup_Visible(which)
	for index = 1, SSTATICPOPUP_NUMDIALOGS, 1 do
		local frame = _G["SStaticPopup"..index];
		if( frame:IsShown() and (frame.which == which) ) then 
			return frame:GetName(), frame;
		end
	end
	return nil;
end

function SStaticPopup_EscapePressed()
	local closed = nil;
	for _, frame in pairs(SStaticPopup_DisplayedFrames) do
		if( frame:IsShown() and frame.hideOnEscape ) then
			local standardDialog = SStaticPopupDialogs[frame.which];
			if ( standardDialog ) then
				local OnCancel = standardDialog.OnCancel;
				local noCancelOnEscape = standardDialog.noCancelOnEscape;
				if ( OnCancel and not noCancelOnEscape) then
					OnCancel(frame, frame.data, "clicked");
				end
				frame:Hide();
			else
				SStaticPopupSpecial_Hide(frame);
			end
			closed = 1;
		end
	end
	return closed;
end

function SStaticPopup_SetUpPosition(dialog)
	if ( not tContains(SStaticPopup_DisplayedFrames, dialog) ) then
		local lastFrame = SStaticPopup_DisplayedFrames[#SStaticPopup_DisplayedFrames];
		if ( lastFrame ) then	
			dialog:SetPoint("TOP", lastFrame, "BOTTOM", 0, 0);
		else
			dialog:SetPoint("TOP", UIParent, "TOP", 0, -135);
		end
		tinsert(SStaticPopup_DisplayedFrames, dialog);
	end
end

function SStaticPopup_CollapseTable()
	local displayedFrames = SStaticPopup_DisplayedFrames;
	local index = #displayedFrames;
	while ( ( index >= 1 ) and ( not displayedFrames[index]:IsShown() ) ) do
		tremove(displayedFrames, index);
		index = index - 1;
	end
end

function StaticPopupSpecial_Show(frame)
	if ( frame.exclusive ) then
		SStaticPopup_HideExclusive();
	end
	SStaticPopup_SetUpPosition(frame);
	frame:Show();
end

function SStaticPopupSpecial_Hide(frame)
	frame:Hide();
	SStaticPopup_CollapseTable();
end

--Used to figure out if we can resize a frame
function SStaticPopup_IsLastDisplayedFrame(frame)
	for i=#SStaticPopup_DisplayedFrames, 1, -1 do
		local popup = SStaticPopup_DisplayedFrames[i];
		if ( popup:IsShown() ) then
			return frame == popup
		end
	end
	return false;
end

function SStaticPopup_OnEvent(self)
	self.maxHeightSoFar = 0;
	SStaticPopup_Resize(self, self.which);
end

function SStaticPopup_HideExclusive()
	for _, frame in pairs(SStaticPopup_DisplayedFrames) do
		if ( frame:IsShown() and frame.exclusive ) then	
			local standardDialog = SStaticPopupDialogs[frame.which];
			if ( standardDialog ) then
				frame:Hide();
				local OnCancel = standardDialog.OnCancel;
				if ( OnCancel ) then
					OnCancel(frame, frame.data, "override");
				end
			else
				SStaticPopupSpecial_Hide(frame);
			end
			break;
		end
	end
end
