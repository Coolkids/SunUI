local REVISION = 1;
if (type(AzDialog) == "table") and (AzDialog.revision >= REVISION) then
	return;
end

AzDialog = AzDialog or {};
AzDialog.revision = REVISION;
AzDialog.dialogs = AzDialog.dialogs or {};

local dialogs = AzDialog.dialogs;

local backdrop = { bgFile="Interface\\ChatFrame\\ChatFrameBackground", edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize = 3, insets = { left = 2, right = 2, top = 2, bottom = 2 } };
local backdropEdit = { bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 2, insets = { left = 0, right = 0, top = 0, bottom = 0 } }

--------------------------------------------------------------------------------------------------------
--                                         Create the Dialog                                          --
--------------------------------------------------------------------------------------------------------

-- OnMouseDown
local function Dialog_OnMouseDown(self)
	self:StartMoving();
end

-- OnMouseUp
local function Dialog_OnMouseUp(self)
	self:StopMovingOrSizing();
end

-- OnOkay
local function Dialog_OnOkay(self)
	local dlg = self:GetParent();
	if (dlg.okayFunc) then
		dlg.okayFunc(dlg.oldText and dlg.edit:GetText());
	end
	dlg:Hide();
end

-- OnCancel
local function Dialog_OnCancel(self)
	local dlg = self:GetParent();
	if (dlg.cancelFunc) then
		dlg.cancelFunc(dlg.oldText);
	end
	dlg:Hide();
end

-- Creates a Dialog
local function CreateDialog()
	local index = (#dialogs + 1);
	local f = CreateFrame("Frame",nil,UIParent);
	f:SetWidth(340);
	f:SetHeight(88);
	f:SetBackdrop(backdrop);
	f:SetBackdropColor(0.1,0.22,0.35,1.0);
	f:SetBackdropBorderColor(0.1,0.1,0.1,1.0);
	f:SetMovable(1);
	f:EnableMouse(1);
	f:SetToplevel(1);
	f:SetFrameStrata("DIALOG");
	f:SetScript("OnMouseDown",Dialog_OnMouseDown);
	f:SetScript("OnMouseUp",Dialog_OnMouseUp);

	f.header = f:CreateFontString(nil,"ARTWORK","GameFontHighlight");

	f.edit = CreateFrame("EditBox",nil,f);
	f.edit:SetHeight(24);
	f.edit:SetPoint("TOPLEFT",12,-28);
	f.edit:SetPoint("TOPRIGHT",-12,-28);
	f.edit:SetScript("OnEnterPressed",Dialog_OnOkay);
	f.edit:SetScript("OnEscapePressed",Dialog_OnCancel);
	f.edit:SetBackdrop(backdropEdit);
	f.edit:SetBackdropColor(0.05,0.05,0.05,1);
	f.edit:SetBackdropBorderColor(0.2,0.2,0.2,1);
	f.edit:SetTextInsets(6,0,0,0);
	f.edit:SetFontObject("GameFontHighlight");

	f.cancel = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
	f.cancel:SetWidth(75);
	f.cancel:SetHeight(21);
	f.cancel:SetScript("OnClick",Dialog_OnCancel);
	f.cancel:SetText(CANCEL);

	f.ok = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
	f.ok:SetWidth(75);
	f.ok:SetHeight(21);
	f.ok:SetPoint("RIGHT",f.cancel,"LEFT",-8,0);
	f.ok:SetScript("OnClick",Dialog_OnOkay);
	f.ok:SetText(OKAY);

	f.index = index;
	dialogs[index] = f;
	return f;
end

-- Show Dialog
function AzDialog:Show(header,text,okayFunc,cancelFunc)
	local dlg;
	-- Find Free Dialog
	for k, v in ipairs(dialogs) do
		if (not v:IsShown()) then
			dlg = v;
			break;
		end
	end
	-- Create One
	if (not dlg) then
		dlg = CreateDialog();
	end
	-- Setup Frame
	dlg.oldText = text;
	dlg.okayFunc = okayFunc;
	dlg.cancelFunc = cancelFunc;
	-- Set Type
	dlg.header:SetText(header or "Enter text here...");
	if (text) then
		dlg:SetHeight(88);
		dlg.header:ClearAllPoints();
		dlg.header:SetPoint("TOPLEFT",10,-10);
		dlg.edit:Show();
		dlg.edit:SetText(text);
		dlg.edit:SetFocus();
		dlg.edit:HighlightText();
		dlg.cancel:ClearAllPoints();
		dlg.cancel:SetPoint("BOTTOMRIGHT",-10,10);
	else
		dlg:SetHeight(66);
		dlg.header:ClearAllPoints();
		dlg.header:SetPoint("TOP",0,-10);
		dlg.edit:Hide();
		dlg.cancel:ClearAllPoints();
		dlg.cancel:SetPoint("BOTTOM",42,10);
	end
	-- Center Dialog & Show
	dlg:ClearAllPoints();
	dlg:SetPoint("CENTER",0,100 - (dlg.index - 1) * 100);
	dlg:Show();
end