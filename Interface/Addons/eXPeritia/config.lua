if(not eXPeritia or not LibStub) then return nil end
local _
local tempDB
local panel = CreateFrame("Frame", nil, UIParent)
panel.name = "eXPeritia"
InterfaceOptions_AddCategory(panel)
 
panel:SetScript("OnShow", function(self)
	if(not InterfaceOptionsFrame:IsShown()) then return nil end

	local info = {notCheckable = true}
	local optionTypes = {
		"None",
		"Missing",
		"Gained",
		"Gains to next level",
		"Needed Blizz bubbles",
		"Rested / Faction",
	}
	local function UpdateSliderValue(self)
		tempDB.Height = panel.height:GetValue()
		tempDB.Width = panel.width:GetValue()
		eXPeritia:ApplyOptions(tempDB)
		self.val:SetFormattedText("%.0f", self:GetValue())
	end
	
	local function UpdateTextValue(self, option)
		self.text:SetText(optionTypes[option])
		tempDB[self.label] = option
		eXPeritia:ApplyOptions(tempDB)
		eXPeritia:UpdateXP(true)
	end
	
	local function AddButton(frame, text, option)
		info.text = text
		info.arg1 = frame
		info.arg2 = option
		info.func = UpdateTextValue
		UIDropDownMenu_AddButton(info)
	end
	local function CreateDropdown(frameType)
		local dropdown, text = LibStub("tekKonfig-Dropdown").new(self, frameType.." text")
		dropdown.text = text
		dropdown.label = frameType
		UIDropDownMenu_Initialize(dropdown, function()
			for i, text in pairs(optionTypes) do
				AddButton(dropdown, optionTypes[i], i)
			end
		end)
		return dropdown
	end
 
	local title, subtitle = LibStub("tekKonfig-Heading").new(self, "eXPeritia ", GetAddOnMetadata("eXPeritia", "Notes"))
 
	local width, _, cont = LibStub("tekKonfig-Slider").new(self, "Width", 100, 2000, "TOPLEFT", subtitle, "BOTTOMLEFT", 0, -20)
	width.val = width:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	width.val:SetPoint("TOP", width, "BOTTOM", 0, 3)
	width:SetScript("OnValueChanged", UpdateSliderValue)
	cont:SetWidth(300)
	self.width = width
 
	local height, _, cont = LibStub("tekKonfig-Slider").new(self, "Height", 5, 100, "TOPLEFT", width, "BOTTOMLEFT", 0, -20)
	height.val = height:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	height.val:SetPoint("TOP", height, "BOTTOM", 0, 3)
	height:SetScript("OnValueChanged", UpdateSliderValue)
	cont:SetWidth(300)
	self.height = height
 
	local color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
	color = format("|cff%02x%02x%02x", color.r*255, color.g*255, color.b*255)
 
	local classcolor = LibStub("tekKonfig-Checkbox").new(self, 26, color.."Class|r colored indicators", "TOPLEFT", height, "BOTTOMLEFT", 0, -40)
	classcolor:SetScript("OnClick", function(self)
		tempDB.ClassColor = self:GetChecked()
		eXPeritia:ApplyOptions(tempDB)
	end)
	self.classColor = classcolor
	
	local mouseover = LibStub("tekKonfig-Checkbox").new(self, 26, "Show on mouseover", "TOPLEFT", classcolor, "BOTTOMLEFT")
	mouseover:SetScript("OnClick", function(self)
		tempDB.MouseOver = self:GetChecked()
		eXPeritia:ApplyOptions(tempDB)
	end)
	self.mouseOver = mouseover

	self.topleft = CreateDropdown("Topleft")
	self.topleft:SetPoint("TOPLEFT", mouseover, "BOTTOMLEFT", 0, -40)
	self.topright = CreateDropdown("Topright")
	self.topright:SetPoint("TOPLEFT", self.topleft, "TOPRIGHT", 10, 0)
	self.bottomleft = CreateDropdown("Bottomleft")
	self.bottomleft:SetPoint("TOP", self.topleft, "BOTTOM", 0, -20)
	self.bottomright = CreateDropdown("Bottomright")
	self.bottomright:SetPoint("TOPLEFT", self.bottomleft, "TOPRIGHT", 10, 0)
 
	eXPeritia:SetScript("OnDragStart", eXPeritia.StartMoving)
	eXPeritia:SetScript("OnDragStop", eXPeritia.StopMovingOrSizing)
	
	self.okay = function(self)
		local temp = eXPeritiaDB
		eXPeritiaDB = tempDB
		tempDB = temp
		eXPeritia:ApplyOptions()
	end
	self.cancel = function(self) eXPeritia:ApplyOptions() end
	
 
	local function OnShow(self)
		tempDB = {}
		for k,v in pairs(eXPeritiaDB) do tempDB[k] = v end
		self.classColor:SetChecked(eXPeritiaDB.ClassColor)
		self.mouseOver:SetChecked(eXPeritiaDB.MouseOver)
		self.width:SetValue(eXPeritiaDB.Width)
		self.height:SetValue(eXPeritiaDB.Height)
		
		self.topleft.text:SetText(optionTypes[eXPeritiaDB['Topleft']])
		self.topright.text:SetText(optionTypes[eXPeritiaDB['Topright']])
		self.bottomleft.text:SetText(optionTypes[eXPeritiaDB['Bottomleft']])
		self.bottomright.text:SetText(optionTypes[eXPeritiaDB['Bottomright']])
		
		eXPeritia:ApplyOptions()
		eXPeritia:UpdateXP(true)
		
		eXPeritia:SetAlpha(1)
		eXPeritia:EnableMouse(true)
		eXPeritia:RegisterForDrag("LeftButton", "RightButton")
		eXPeritia.forceShown = true
	end
	self:SetScript("OnShow", OnShow)
	self:SetScript("OnHide", function(self)
		eXPeritia:SetAlpha(0)
		eXPeritia:EnableMouse(eXPeritiaDB.MouseOver)
		eXPeritia:RegisterForDrag(nil)
		eXPeritia.forceShown = nil
	end)
 
	OnShow(self)
end)
function panel:cancel() eXPeritia:ApplyOptions() end
 
SlashCmdList['EXPERITIA'] = function(msg)
	if(msg == "hide" or (msg == "toggle" and eXPeritia:IsShown())) then
		return eXPeritia:SetAlpha(0)
	elseif(msg == "show" or msg == "toggle") then
		return	eXPeritia:SetAlpha(1)
	else
		InterfaceOptionsFrame_OpenToFrame("eXPeritia")
	end
end
SLASH_EXPERITIA1 = '/exp'
SLASH_EXPERITIA2 = '/experitia'