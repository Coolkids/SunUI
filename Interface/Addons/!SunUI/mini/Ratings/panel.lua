if not Ratings then return end

local panel = CreateFrame"Frame"
panel.name = "Ratings"

panel:SetScript("OnShow", function (self)
	self:SetScript("OnShow", nil)
	local function CreateTexture(parent, texture, mode)
		local t = parent:CreateTexture()
		t:SetTexture(texture)
		t:SetAllPoints()
		if mode then t:SetBlendMode(mode) end
		return t
	end

	local cb = CreateFrame("CheckButton", nil, self)
	cb:SetPoint("TOPLEFT", 20, -20)
	cb:SetWidth(26) cb:SetHeight(26)
	cb:SetNormalTexture(CreateTexture(cb, "Interface\\Buttons\\UI-CheckBox-Up"))
	cb:SetPushedTexture(CreateTexture(cb, "Interface\\Buttons\\UI-CheckBox-Down"))
	cb:SetHighlightTexture(CreateTexture(cb, "Interface\\Buttons\\UI-CheckBox-Highlight", "ADD"))
	cb:SetCheckedTexture(CreateTexture(cb, "Interface\\Buttons\\UI-CheckBox-Check"))
	cb:SetDisabledCheckedTexture(CreateTexture(cb, "Interface\\Buttons\\UI-CheckBox-Check-Disabled"))

	cb:SetScript("OnClick", function (self)
		if self:GetChecked() then
			self.dependency:Enable()
		else
			self.dependency:Disable()
		end
	end)

	local text = cb:CreateFontString(nil, "ARTWORK")
	text:SetPoint("LEFT", cb, "RIGHT", 0, 1)
	text:SetFontObject(GameFontHighlight)
	text:SetText"Force the level used for rating conversion"

	local slider = CreateFrame("Slider", nil, self)
	slider:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 5, -15)
	slider:SetWidth(244) slider:SetHeight(17)
	slider:SetBackdrop{
		bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
		edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 8,
		insets = {
			left = 3,
			right = 3,
			top = 6,
			bottom = 6,
		},
	}
	local thumb = CreateTexture(slider, "Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	thumb:SetWidth(32) thumb:SetHeight(32)
	slider:SetThumbTexture(thumb)

	text = slider:CreateFontString(nil, "ARTWORK")
	text:SetPoint("BOTTOM", slider, "TOP")
	text:SetFontObject(GameFontHighlight)
	slider.text = text

	text = slider:CreateFontString(nil, "ARTWORK")
	text:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", -4, 3)
	text:SetFontObject(GameFontHighlightSmall)
	text:SetText"10"
	slider.low = text

	text = slider:CreateFontString(nil, "ARTWORK")
	text:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 4, 3)
	text:SetFontObject(GameFontHighlightSmall)
	text:SetText(Ratings.MAX_SUPPORTED_LEVEL)
	slider.high = text

	slider.Disable = function (self)
		local color = GRAY_FONT_COLOR
		getmetatable(self).__index.Disable(self)
		self.text:SetVertexColor(color.r, color.g, color.b)
		self.low:SetVertexColor(color.r, color.g, color.b)
		self.high:SetVertexColor(color.r, color.g, color.b)
	end

	slider.Enable = function (self)
		local color = NORMAL_FONT_COLOR
		getmetatable(self).__index.Enable(self)
		self.text:SetVertexColor(color.r, color.g, color.b)
		color = HIGHLIGHT_FONT_COLOR
		self.low:SetVertexColor(color.r, color.g, color.b)
		self.high:SetVertexColor(color.r, color.g, color.b)
	end

	slider:SetMinMaxValues(10, Ratings.MAX_SUPPORTED_LEVEL)
	slider:SetValueStep(1)
	slider.text:SetText(slider:GetValue())
	slider:SetOrientation"HORIZONTAL"

	slider:SetScript("OnValueChanged", function (self, value)
		self.text:SetFormattedText("Level %d", value)
	end)

	cb.dependency = slider

	local edit = CreateFrame("EditBox", nil, self, "InputBoxTemplate")
	text = edit:CreateFontString()
	text:SetFontObject(GameFontHighlight)
	text:SetText"Format of the inserted text:"
	text:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 0, -50)
	edit:SetPoint("LEFT", text, "RIGHT", 5, 0)
	edit:SetWidth(180)
	edit:SetHeight(19)
	edit:SetFontObject(ChatFontNormal)
	edit:SetAutoFocus(false)
	edit:ClearFocus()
	edit:SetTextInsets(0,0,3,3)

	local dropdown = CreateFrame("Frame", "RatingsDropdown", self, "UIDropDownMenuTemplate")
	local label = dropdown:CreateFontString()
	label:SetFontObject(GameFontHighlight)
	label:SetText"Rating conversion value used for hit/crit/haste:"
	label:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -50)
	dropdown:SetPoint("LEFT", label, "RIGHT", 5, 0)
	UIDropDownMenu_SetWidth(dropdown, 140)

	local optionList = { "melee", "spell", "ranged" }

	local onClick = function (self)
		UIDropDownMenu_SetSelectedValue(RatingsDropdown, self.value)
	end

	self.dropdown_init = function (self)
		local selectedValue = UIDropDownMenu_GetSelectedValue(self)
		local info = UIDropDownMenu_CreateInfo()

		for _, v in ipairs(optionList) do
			info.text = v
			info.value = v
			if selectedValue and v == selectedValue then
				info.checked = 1
				UIDropDownMenu_SetText(self, v)
			else
				info.checked = nil
			end
			info.func = onClick

			UIDropDownMenu_AddButton(info)
		end
	end

	self.cb = cb
	self.slider = slider
	self.edit = edit
	self.dropdown = dropdown

	self.refresh = function(self)
		local level = RatingsDB.forceLevel
		if level then
			self.cb:SetChecked(true)
			self.slider:Enable()
		else
			level = UnitLevel"player"
			self.cb:SetChecked(false)
			self.slider:Disable()
		end
		self.slider:SetValue(level)
		self.slider.text:SetFormattedText("Level %d", level)
		self.edit:SetText(RatingsDB.format:gsub("|", "||"))
		self.edit:SetCursorPosition(0)

		UIDropDownMenu_SetSelectedValue(self.dropdown, Ratings:GetModifier())
		UIDropDownMenu_Initialize(self.dropdown, self.dropdown_init)
	end

	self.okay = function (self)
		if self.cb:GetChecked() then
			RatingsDB.forceLevel = self.slider:GetValue()
		else
			RatingsDB.forceLevel = nil
		end
		RatingsDB.format = self.edit:GetText():gsub("||", "|")
		RatingsDB.modifier = UIDropDownMenu_GetSelectedValue(self.dropdown)
	end
	self:refresh()
end)

InterfaceOptions_AddCategory(panel)
