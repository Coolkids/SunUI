local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SkinReforgeLite", "AceEvent-3.0")
local style = false
local function Skin()
	if not IsAddOnLoaded("ReforgeLite") then return end
	if style then return end
	hooksecurefunc(ReforgeLite, 'CreateFrame', function(self)
		self:StripTextures()
		S.ReskinClose(self.close)
		S.ReskinScroll(self.scrollBar)
		S.SetBD(self)
	end)
	hooksecurefunc(ReforgeLite, 'CreateOptionList', function(self)
		S.Reskin(self.computeButton)
		self.quality:SetThumbTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	end)
	hooksecurefunc(ReforgeLite, 'FillSettings', function(self)
		S.Reskin(self.debugButton)
	end)
	hooksecurefunc(ReforgeLite, 'UpdateMethodCategory', function(self)
		S.Reskin(self.methodShow)
		S.Reskin(self.methodReset)
		S.Reskin(self.saveMethodPresetButton)
		S.Reskin(self.deleteMethodPresetButton)
	end)
	hooksecurefunc(ReforgeLite, 'ShowMethodWindow', function(self)
		self.methodWindow:StripTextures()
		S.SetBD(self.methodWindow)
		S.ReskinClose(self.methodWindow.close)
		S.Reskin(self.methodWindow.reforge)
	end)
	hooksecurefunc(ReforgeLite, 'CreateTaskUI', function(self)
		S.Reskin(self.savePresetButton)
		S.Reskin(self.deletePresetButton)
		S.Reskin(self.pawnButton)
	end)
	function ReforgeLiteGUI:CreateDropdown (parent, values, default, setter, width)
	  local sel
	  if #self.dropdowns > 0 then
		sel = table.remove (self.dropdowns, 1)
		sel:SetParent (parent)
		sel:Show ()
	  else
		local name = self:GenerateWidgetName ()
		sel = CreateFrame ("Frame", name, parent, "UIDropDownMenuTemplate")
		sel.Initialize = function (self)
		  local info = UIDropDownMenu_CreateInfo ()
		  for i = 1, #self.values do
			info.text = self.values[i].name
			info.func = function (inf)
			  UIDropDownMenu_SetSelectedValue (self, inf.value)
			  self.value = inf.value
			  if self.setter then self.setter (inf.value) end
			end
			info.value = self.values[i].value
			info.checked = (self.value == self.values[i].value)
			UIDropDownMenu_AddButton (info)
		  end
		end
		sel.SetValue = function (self, value)
		  self.value = value
		  for i = 1, #self.values do
			if self.values[i].value == value then
			  UIDropDownMenu_SetText (self, self.values[i].name)
			  return
			end
		  end
		  UIDropDownMenu_SetText (self, "")
		end
		sel:SetScript ("OnShow", function (self)
		  UIDropDownMenu_Initialize (self, self.Initialize)
		  UIDropDownMenu_SetSelectedValue (self, self.value)
		end)
		UIDropDownMenu_JustifyText (sel, "LEFT")
		sel:SetHeight (50)
		_G[name .. "Left"]:SetHeight (50)
		_G[name .. "Middle"]:SetHeight (50)
		_G[name .. "Right"]:SetHeight (50)
		_G[name .. "Text"]:SetPoint ("LEFT", _G[name .. "Left"], "LEFT", 27, -5)
		_G[name .. "Button"]:SetWidth (22)
		_G[name .. "Button"]:SetHeight (22)
		_G[name .. "ButtonNormalTexture"]:SetWidth (22)
		_G[name .. "ButtonNormalTexture"]:SetHeight (22)
		_G[name .. "ButtonPushedTexture"]:SetWidth (22)
		_G[name .. "ButtonPushedTexture"]:SetHeight (22)
		_G[name .. "ButtonDisabledTexture"]:SetWidth (22)
		_G[name .. "ButtonDisabledTexture"]:SetHeight (22)
		_G[name .. "ButtonHighlightTexture"]:SetWidth (22)
		_G[name .. "ButtonHighlightTexture"]:SetHeight (22)
		_G[name .. "Button"]:SetPoint ("TOPRIGHT", _G[name .. "Right"], "TOPRIGHT", -16, -13)
		sel.Recycle = function (sel)
		  sel:Hide ()
		  sel:SetScript ("OnEnter", nil)
		  sel:SetScript ("OnLeave", nil)
		  sel.setter = nil
		  table.insert (self.dropdowns, sel)
		end
	  end
	  sel.value = default
	  sel.values = values
	  sel.setter = setter
	  UIDropDownMenu_Initialize (sel, sel.Initialize)
	  sel:SetValue (default)
	  if width then
		UIDropDownMenu_SetWidth (sel, width)
	  end
	  S.ReskinDropDown(sel)
	  return sel
	end
	function ReforgeLiteGUI:CreateCheckButton (parent, text, default, setter)
	  local btn
	  if #self.checkButtons > 0 then
		btn = table.remove (self.checkButtons, 1)
		btn:SetParent (parent)
		btn:Show ()
	  else
		local name = self:GenerateWidgetName ()
		btn = CreateFrame ("CheckButton", name, parent, "UICheckButtonTemplate")
		btn.Recycle = function (btn)
		  btn:Hide ()
		  btn:SetScript ("OnEnter", nil)
		  btn:SetScript ("OnLeave", nil)
		  btn:SetScript ("OnClick", nil)
		  table.insert (self.checkButtons, btn)
		end
	  end
	  _G[btn:GetName () .. "Text"]:SetText (text)
	  btn:SetChecked (default)
	  if setter then
		btn:SetScript ("OnClick", function (self)
		  setter (self:GetChecked ())
		end)
	  end
	  S.ReskinCheck(btn)
	  return btn
	end
	style = true
end

function Module:OnEnable()
	Module:RegisterEvent("ADDON_LOADED", Skin)
end