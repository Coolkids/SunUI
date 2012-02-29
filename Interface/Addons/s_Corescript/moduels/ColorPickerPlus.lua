local S, C, L, DB = unpack(s_Core)
-- ColorPickerPlus hooks into the standard Color Picker to provide 
--      1. text entry for colors (RGB and hex values) and alpha (for opacity), 
-- 		2. copy to and paste from a dialog buffer,
--		3. color swatches for the copied color and for the starting color. 


ColorPickerPlus = LibStub("AceAddon-3.0"):NewAddon("ColorPickerPlus", "AceEvent-3.0", "AceHook-3.0")
local MOD = ColorPickerPlus
local initialized = nil
local colorBuffer = {}
local editingText = nil

function MOD:OnEnable()
	-- Event received when starting, reloading or zoning
	self:RegisterEvent("PLAYER_ENTERING_WORLD")	
end

function MOD:PLAYER_ENTERING_WORLD()

	if initialized then return end
	initialized = true

	-- hook the function to call when dialog first shows
	MOD:HookScript(ColorPickerFrame, "OnShow", function(...)
		MOD.hooks[ColorPickerFrame].OnShow(...)
		local self = ...;
	
		-- get color that will be replaced
		local r, g, b = ColorPickerFrame:GetColorRGB()
		ColorPPOldColorSwatch:SetTexture(r,g,b)
		
			-- show/hide the alpha box
		if ColorPickerFrame.hasOpacity then 
			ColorPPBoxA:Show() 
			ColorPPBoxLabelA:Show() 
			ColorPPBoxH:SetScript("OnTabPressed", function(self) ColorPPBoxA:SetFocus()  end)
			MOD:UpdateAlphaText()
		
		else
			ColorPPBoxA:Hide() 
			ColorPPBoxLabelA:Hide() 
			ColorPPBoxH:SetScript("OnTabPressed", function(self) ColorPPBoxR:SetFocus()  end)
		end
	
		end)
		
	-- hook the function to call on a change of color via ColorSelect
	MOD:HookScript(ColorPickerFrame, "OnColorSelect", function(...)
		MOD.hooks[ColorPickerFrame].OnColorSelect(...)
		local self, arg1, arg2, arg3 = ...;
			if not editingText then
				MOD:UpdateColorTexts(arg1, arg2, arg3)
			end
		end)
		
	-- hook the function to call on a change of color via OpacitySlider	
	MOD:HookScript(OpacitySliderFrame, "OnValueChanged", function(...)
		local self = ...;
		MOD.hooks[OpacitySliderFrame].OnValueChanged(...)
			if not editingText then
				MOD:UpdateAlphaText()
			end
		end)
		
	-- make the Color Picker dialog a bit taller, to make room for edit boxes
	local h = ColorPickerFrame:GetHeight()
	ColorPickerFrame:SetHeight(h+40)
	ColorPickerFrame:SetScale(1.2)	
	-- move the Color Swatch
	ColorSwatch:ClearAllPoints()
	ColorSwatch:SetPoint("TOPLEFT", ColorPickerFrame, "TOPLEFT", 230, -45)
		
	-- add Color Swatch for original color
	local t = ColorPickerFrame:CreateTexture("ColorPPOldColorSwatch")
	local w, h = ColorSwatch:GetSize()
	t:SetSize(w*0.75,h*0.75)
	t:SetTexture(0,0,0)
	-- OldColorSwatch to appear beneath ColorSwatch
	t:SetDrawLayer("BORDER")
	t:SetPoint("BOTTOMLEFT", "ColorSwatch", "TOPRIGHT", -(w/2), -(h/3))
	
	-- add Color Swatch for the copied color
	t = ColorPickerFrame:CreateTexture("ColorPPCopyColorSwatch")
	t:SetSize(w,h)
	t:SetTexture(0,0,0)
	t:Hide()
		
	-- add copy button to the ColorPickerFrame
	local b = CreateFrame("Button", "ColorPPCopy", ColorPickerFrame, "UIPanelButtonTemplate")
	b:SetText("Copy")
	b:SetWidth("70")
	b:SetHeight("22")
	b:SetScale(0.80)
	b:SetPoint("TOPLEFT", "ColorSwatch", "BOTTOMLEFT", -15, -5)
	S.Reskin(b)
	-- copy color into buffer on button click
	b:SetScript("OnClick", function(self) 
	
		if IsShiftKeyDown() == 1 then
		-- this is a hidden utility for providing the WoW 0 to 1 based color numbers
			local r, g, b = ColorPickerFrame:GetColorRGB()
			print("ColorPickerPlus decimal -- r = "..string.format("%.2f", r).."  g = "..string.format("%.2f", g).."  b = "..string.format("%.2f",b))
			return	
		end
		
		-- copy current dialog colors into buffer
		local c = colorBuffer
		c.r, c.g, c.b = ColorPickerFrame:GetColorRGB()
		
		-- enable Paste button and display copied color into swatch
		ColorPPPaste:Enable()
		local t = ColorPPCopyColorSwatch
		t:SetTexture(c.r, c.g, c.b)
		t:Show()
		
		if ColorPickerFrame.hasOpacity then
			c.a = OpacitySliderFrame:GetValue()
		else
			c.a = nil
		end
	end)
		
	-- add paste button to the ColorPickerFrame		
	b = CreateFrame("Button", "ColorPPPaste", ColorPickerFrame, "UIPanelButtonTemplate")
	b:SetText("Paste")
	b:SetWidth("70")
	b:SetHeight("22")
	b:SetScale(0.8)
	b:SetPoint("TOPLEFT", "ColorPPCopy", "BOTTOMLEFT", 0, -7)
	b:Disable()  -- enable when something has been copied
	S.Reskin(b)
	-- paste color on button click, updating frame components
	b:SetScript("OnClick", function(self)
		local c = colorBuffer
		ColorPickerFrame:SetColorRGB(c.r, c.g, c.b)
		ColorSwatch:SetTexture(c.r, c.g, c.b)
		if ColorPickerFrame.hasOpacity then
			if c.a then  --color copied had an alpha value
				OpacitySliderFrame:SetValue(c.a)
			end
		end
	end)
		
	-- locate Color Swatch for copy color
	ColorPPCopyColorSwatch:SetPoint("LEFT", "ColorSwatch", "LEFT")
	ColorPPCopyColorSwatch:SetPoint("TOP", "ColorPPPaste", "BOTTOM", 0, -5)
		
	-- move the Opacity Slider Frame to align with bottom of Copy ColorSwatch
	OpacitySliderFrame:ClearAllPoints()
	OpacitySliderFrame:SetPoint("BOTTOM", "ColorPPCopyColorSwatch", "BOTTOM", 0, -3)
	OpacitySliderFrame:SetPoint("RIGHT", "ColorPickerFrame", "RIGHT", -35, 0)
	
	-- set up edit box frames and interior label and text areas
	local boxes = { "R", "G", "B", "H", "A" }	
	for i = 1, table.getn(boxes) do
	
		local rgb = boxes[i]
		local box = CreateFrame("EditBox", "ColorPPBox"..rgb, ColorPickerFrame, "InputBoxTemplate")
		box:SetID(i)
		box:SetFrameStrata("DIALOG")
		box:SetAutoFocus(false)
		box:SetTextInsets(0,5,0,0)
		box:SetJustifyH("RIGHT")
		box:SetHeight(24)

		if i == 4 then
			-- Hex entry box
			box:SetMaxLetters(12)
			box:SetWidth(80)
			box:SetNumeric(false)
		else
			box:SetMaxLetters(6)
			box:SetWidth(48)
			box:SetNumeric(true)
		end
		box:SetPoint("TOP", "ColorPickerWheel", "BOTTOM", 0, -15)
	
		-- label
		local label = box:CreateFontString("ColorPPBoxLabel"..rgb, "ARTWORK", "GameFontNormalSmall")
		label:SetTextColor(1, 1, 1)
		label:SetPoint("RIGHT", "ColorPPBox"..rgb, "LEFT", -5, 0)
		if i == 4 then
			label:SetText("#")
		else
			label:SetText(rgb)
		end
			
		-- set up scripts to handle event appropriately
		if i == 5 then
			box:SetScript("OnEscapePressed", function(self)	self:ClearFocus() MOD:UpdateAlphaText() end)
			box:SetScript("OnEnterPressed", function(self) self:ClearFocus() MOD:UpdateAlphaText() end)
			box:SetScript("OnTextChanged", function(self) MOD:UpdateAlpha(self) end)
		else
			box:SetScript("OnEscapePressed", function(self)	self:ClearFocus() MOD:UpdateColorTexts() end)
			box:SetScript("OnEnterPressed", function(self) self:ClearFocus() MOD:UpdateColorTexts() end)
			box:SetScript("OnTextChanged", function(self) MOD:UpdateColor(self) end)
		end

		box:SetScript("OnEditFocusGained", function(self) self:SetCursorPosition(0) self:HighlightText() end)
		box:SetScript("OnEditFocusLost", function(self)	self:HighlightText(0,0) end)	
		box:SetScript("OnTextSet", function(self) self:ClearFocus() end)	
		--box:SetScript("OnChar", function(self, text)	print(text) end)	
		box:Show()
	end
	
	-- finish up with placement
	ColorPPBoxA:SetPoint("RIGHT", "OpacitySliderFrame", "RIGHT", 28, 0)
	ColorPPBoxH:SetPoint("RIGHT", "ColorPPBoxA", "LEFT", -15, 0)
	ColorPPBoxB:SetPoint("RIGHT", "ColorPPBoxH", "LEFT", -15, 0)
	ColorPPBoxG:SetPoint("RIGHT", "ColorPPBoxB", "LEFT", -15, 0)
	ColorPPBoxR:SetPoint("RIGHT", "ColorPPBoxG", "LEFT", -15, 0)
	
		-- define the order of tab cursor movement
	ColorPPBoxR:SetScript("OnTabPressed", function(self) ColorPPBoxG:SetFocus() end)
	ColorPPBoxG:SetScript("OnTabPressed", function(self) ColorPPBoxB:SetFocus()  end)
	ColorPPBoxB:SetScript("OnTabPressed", function(self) ColorPPBoxH:SetFocus()  end)
	ColorPPBoxA:SetScript("OnTabPressed", function(self) ColorPPBoxR:SetFocus()  end)
	--  tab cursor movement from Hex box depends on whether alpha field is visible, so set in OnShow
	
	-- make the color picker movable.	
	local cpf = ColorPickerFrame
	local mover = CreateFrame('Frame', nil, cpf)
	mover:SetPoint('TOPLEFT', cpf, 'TOP', -60, 0)
	mover:SetPoint('BOTTOMRIGHT', cpf, 'TOP', 60, -15)
	mover:EnableMouse(true)
	mover:SetScript('OnMouseDown', function() cpf:StartMoving() end)
	mover:SetScript('OnMouseUp', function() cpf:StopMovingOrSizing() end)
	cpf:SetUserPlaced(true)
	cpf:EnableKeyboard(false)

end

function MOD:UpdateColor(tbox)

	local r, g, b = ColorPickerFrame:GetColorRGB()
	
	local id = tbox:GetID()
		
	if id == 1 then
		r = string.format("%d", tbox:GetNumber())
		if not r then r = 0 end
		r = r/255
	elseif id == 2 then
		g = string.format("%d", tbox:GetNumber())
		if not g then g = 0 end
		g = g/255
	elseif id == 3 then
		b = string.format("%d", tbox:GetNumber())
		if not b then b = 0 end
		b = b/255
	elseif id == 4 then
		-- hex values
		if tbox:GetNumLetters() == 6 then 
			local rgb = tbox:GetText()
			r, g, b = tonumber('0x'..strsub(rgb, 0, 2)), tonumber('0x'..strsub(rgb, 3, 4)), tonumber('0x'..strsub(rgb, 5, 6))
			if not r then r = 0 else r = r/255 end
			if not g then g = 0 else g = g/255 end
			if not b then b = 0 else b = b/255 end
		else return	
		end
	
	end
	
	-- This takes care of updating the hex entry when changing rgb fields and vice versa
	MOD:UpdateColorTexts(r,g,b)  
	
	editingText = true
	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorSwatch:SetTexture(r, g, b)
	editingText = nil
	
end


function MOD:UpdateColorTexts(r, g, b)
		
	if not r then r, g, b = ColorPickerFrame:GetColorRGB() end
	
	r = r*255 
	g = g*255
	b = b*255
	
    ColorPPBoxR:SetText(string.format("%d", r))
    ColorPPBoxG:SetText(string.format("%d", g))
    ColorPPBoxB:SetText(string.format("%d", b))
	ColorPPBoxH:SetText(string.format("%.2x", r)..string.format("%.2x",g)..string.format("%.2x", b))
	
end

function MOD:UpdateAlpha(tbox)
	
	local a = tbox:GetNumber()
	if a > 100 then 
		a = 100 
		ColorPPBoxA:SetText(string.format("%d", a))
	end
	a = a/100
	editingText = true
	OpacitySliderFrame:SetValue(a)
	editingText = nil
		
end

function MOD:UpdateAlphaText()

	local a = OpacitySliderFrame:GetValue()
	a = a * 100
	a = math.floor(a +.05)
	ColorPPBoxA:SetText(string.format("%d", a))
	
end

