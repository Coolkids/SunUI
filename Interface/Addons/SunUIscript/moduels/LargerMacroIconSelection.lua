local addonName, BTSUi = ...
local Launch = CreateFrame("Frame")
Launch:RegisterEvent("ADDON_LOADED")
Launch:SetScript("OnEvent", function(self, event)
 if  not  IsAddOnLoaded("Blizzard_MacroUI") then return end

LargerMacroIconSelectionDB = {
	width = 10,  
	height = 10, 
}

-- Local constants
local NUM_ICONS_PER_ROW
local NUM_ICON_ROWS
local NUM_MACRO_ICONS_SHOWN
local MacroPopupFrame_OrigWidth = MacroPopupFrame:GetWidth()
local MacroPopupFrame_OrigHeight = MacroPopupFrame:GetHeight()
local MacroPopupScrollFrame_OrigWidth = MacroPopupScrollFrame:GetWidth()
local MacroPopupScrollFrame_OrigHeight = MacroPopupScrollFrame:GetHeight()

-- More locals
local extrawidth
local extraheight
local kids
local kids2
local maxcreatedbuttons = 0

-- Localization
local L = {
	["LargerMacroIconSelection v1.0.2"] = "LargerMacroIconSelection v1.0.2",
	["Setting macro icon selection width to %d and height to %d"] = "Setting macro icon selection width to %d and height to %d",
	["Usage: /lmis width height"] = "Usage: /lmis width height",
	["Width must be 5 or larger, height must be 4 or larger"] = "Width must be 5 or larger, height must be 4 or larger",
	["Current width is %d and current height is %d"] = "Current width is %d and current height is %d",
}

-- For non-English localizations, uncomment the relevant
-- sections if someone ever actually helps to localize it

if GetLocale == "deDE" then
	L = setmetatable({
		["LargerMacroIconSelection v1.0.2"] = "LargerMacroIconSelection v1.0.2",
		["Setting macro icon selection width to %d and height to %d"] = "Macrosymbol-Auswahlfenster ist nun %d Symbole breit und %d Symbole hoch",
		["Usage: /lmis width height"] = "So geht's: /lmis Breite Höhe",
		["Width must be 5 or larger, height must be 4 or larger"] = "Breite muss mindestens 5, Höhe mindestens 4 sein",
		["Current width is %d and current height is %d"] = "Aktuelle Breite ist: %d, aktuelle Höhe ist: %d",
	}, {__index = L})
end
--[[
if GetLocale == "frFR" then
	L = setmetatable({
		["LargerMacroIconSelection v1.0.2"] = "LargerMacroIconSelection v1.0.2",
		["Setting macro icon selection width to %d and height to %d"] = "blah blah %d blah %d",
		["Usage: /lmis width height"] = "Usage: /lmis blah blah",
		["Width must be 5 or larger, height must be 4 or larger"] = "blah blah blah blah blah blah",
		["Current width is %d and current height is %d"] = "Current width is %d and current height is %d",
	}, {__index = L})
end
-- blah blah blah, cut and paste for more locales
]]

-- Hook the display of the macro icons to re-display to our size.
-- Most of this function is copied from MacroPopupFrame_Update(), except
-- that it uses our local constants instead of the global ones, and it
-- has an extra macroPopupButton:SetID() line.
local function Hooked_MacroPopupFrame_Update()
	local numMacroIcons = #(GetMacroIcons());
	local macroPopupIcon, macroPopupButton;
	local macroPopupOffset = FauxScrollFrame_GetOffset(MacroPopupScrollFrame);
	local index;
	local texture;

	for i=1, NUM_MACRO_ICONS_SHOWN do
		macroPopupIcon = _G["MacroPopupButton"..i.."Icon"];
		macroPopupButton = _G["MacroPopupButton"..i];
		index = (macroPopupOffset * NUM_ICONS_PER_ROW) + i;
		texture = GetSpellorMacroIconInfo(index);
		if ( index <= numMacroIcons and texture ) then
			macroPopupIcon:SetTexture("INTERFACE\\ICONS\\"..texture);
			macroPopupButton:Show();
		else
			macroPopupIcon:SetTexture("");
			macroPopupButton:Hide();
		end
		if ( MacroPopupFrame.selectedIcon and (index == MacroPopupFrame.selectedIcon) ) then
			macroPopupButton:SetChecked(1);
		elseif ( MacroPopupFrame.selectedIconTexture ==  texture ) then
			macroPopupButton:SetChecked(1);
		else
			macroPopupButton:SetChecked(nil);
		end
		macroPopupButton:SetID(i + (NUM_ICONS_PER_ROW - _G["NUM_ICONS_PER_ROW"]) * macroPopupOffset) -- new line
	end
	FauxScrollFrame_Update(MacroPopupScrollFrame, ceil(numMacroIcons / NUM_ICONS_PER_ROW) , NUM_ICON_ROWS, MACRO_ICON_ROW_HEIGHT );
end

-- Addon frame object
local LargerMacroIconSelection = CreateFrame("Frame", "LargerMacroIconSelection")
LargerMacroIconSelection:RegisterEvent("ADDON_LOADED")
LargerMacroIconSelection:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "LargerMacroIconSelection" then
		self.db = LargerMacroIconSelectionDB
		NUM_ICONS_PER_ROW = self.db.width
		NUM_ICON_ROWS = self.db.height
		NUM_MACRO_ICONS_SHOWN = NUM_ICONS_PER_ROW * NUM_ICON_ROWS
		self:InitOnce()
		self:Init()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)

-- Initialization that should only be done once
function LargerMacroIconSelection:InitOnce()
	-- Get the textures into a table since they are unnamed in Blizzard XML code
	kids = {MacroPopupFrame:GetRegions()}
	kids2 = {MacroPopupScrollFrame:GetRegions()}

	-- Create extra background textures
	MacroPopupFrame.largertexture1 = MacroPopupFrame:CreateTexture(nil, "BACKGROUND") -- top side
	MacroPopupFrame.largertexture2 = MacroPopupFrame:CreateTexture(nil, "BACKGROUND") -- left side
	MacroPopupFrame.largertexture3 = MacroPopupFrame:CreateTexture(nil, "BACKGROUND") -- middle
	MacroPopupFrame.largertexture4 = MacroPopupFrame:CreateTexture(nil, "BACKGROUND") -- right side
	MacroPopupFrame.largertexture5 = MacroPopupFrame:CreateTexture(nil, "BACKGROUND") -- bottom side1
	MacroPopupFrame.largertexture6 = MacroPopupFrame:CreateTexture(nil, "BACKGROUND") -- bottom side2

	-- And some more for the scrollframe
	MacroPopupScrollFrame.largertexture1 = MacroPopupScrollFrame:CreateTexture(nil, "BACKGROUND")

	-- Hook the macro update function
	hooksecurefunc("MacroPopupFrame_Update", Hooked_MacroPopupFrame_Update)

	-- Add the slash command
	SlashCmdList["LMIS"] = LargerMacroIconSelection.Config
	SLASH_LMIS1 = "/lmis"

	-- Kill myself so I won't get called twice
	LargerMacroIconSelection.InitOnce = function() end
end

-- Initialization that should be called when the width/height values change
function LargerMacroIconSelection:Init()
	-- Create the extra buttons
	for i = 21, NUM_MACRO_ICONS_SHOWN do
		local a = "MacroPopupButton"..i
		if not _G[a] then
			CreateFrame("CheckButton", a, MacroPopupFrame, "MacroPopupButtonTemplate")
		end
	end
	if NUM_MACRO_ICONS_SHOWN > maxcreatedbuttons then
		maxcreatedbuttons = NUM_MACRO_ICONS_SHOWN
	end

	-- Now reposition all the buttons except the first one
	for i = 2, NUM_MACRO_ICONS_SHOWN do
		local a = _G["MacroPopupButton"..i]
		a:ClearAllPoints()
		if i % NUM_ICONS_PER_ROW == 1 then
			a:SetPoint("TOPLEFT", _G["MacroPopupButton"..i-NUM_ICONS_PER_ROW], "BOTTOMLEFT", 0, -8)
		else
			a:SetPoint("LEFT", _G["MacroPopupButton"..i-1], "RIGHT", 10, 0)
		end
		a:Show()
	end

	-- Hide the rest
	for i = NUM_MACRO_ICONS_SHOWN + 1, maxcreatedbuttons do
		_G["MacroPopupButton"..i]:Hide()
	end

	-- Calculate the extra width and height due to the new size
	extrawidth = (MacroPopupButton1:GetWidth() + 10) * (NUM_ICONS_PER_ROW - _G["NUM_ICONS_PER_ROW"]) + 1
	extraheight = (MacroPopupButton1:GetHeight() + 8) * (NUM_ICON_ROWS - _G["NUM_ICON_ROWS"]) + 1

	-- Resize the frames
	MacroPopupFrame:SetWidth(MacroPopupFrame_OrigWidth + extrawidth)
	MacroPopupFrame:SetHeight(MacroPopupFrame_OrigHeight + extraheight)
	MacroPopupScrollFrame:SetWidth(MacroPopupScrollFrame_OrigWidth + extrawidth)
	MacroPopupScrollFrame:SetHeight(MacroPopupScrollFrame_OrigHeight + extraheight)

	-- Reposition the unnamed textures, as well as initialize
	-- the extra ones to cover up the extra areas
	for _, child in ipairs(kids) do
		if child.GetTexture then
			if child:GetTexture() == "Interface\\MacroFrame\\MacroPopup-TopLeft" then
				MacroPopupFrame.largertexture1:SetTexture(nil)
				MacroPopupFrame.largertexture1:SetTexCoord(0.5, 0.7, 0, 1)
				MacroPopupFrame.largertexture1:SetWidth(extrawidth)
				MacroPopupFrame.largertexture1:SetHeight(child:GetHeight())
				MacroPopupFrame.largertexture1:SetPoint("TOPLEFT", child, "TOPRIGHT")

				MacroPopupFrame.largertexture2:SetTexture(nil)
				MacroPopupFrame.largertexture2:SetTexCoord(0, 1, 0.5, 0.7)
				MacroPopupFrame.largertexture2:SetWidth(child:GetWidth())
				MacroPopupFrame.largertexture2:SetHeight(extraheight)
				MacroPopupFrame.largertexture2:SetPoint("TOPLEFT", child, "BOTTOMLEFT")

				MacroPopupFrame.largertexture3:SetTexture(nil)
				MacroPopupFrame.largertexture3:SetTexCoord(0.5, 0.7, 0.5, 0.7)
				MacroPopupFrame.largertexture3:SetWidth(extrawidth)
				MacroPopupFrame.largertexture3:SetHeight(extraheight)
				MacroPopupFrame.largertexture3:SetPoint("TOPLEFT", child, "BOTTOMRIGHT")
			elseif child:GetTexture() == "Interface\\MacroFrame\\MacroPopup-TopRight" then
				child:ClearAllPoints()
				child:SetPoint("TOPRIGHT", 23, 0)
			elseif child:GetTexture() == "Interface\\MacroFrame\\MacroPopup-BotLeft" then
				-- Resize this one
				child:ClearAllPoints()
				child:SetPoint("BOTTOMLEFT", 0, -21)
				child:SetWidth(256 * 0.1)
				child:SetTexCoord(0, 0.1, 0, 1)

				MacroPopupFrame.largertexture5:SetWidth(256 * 0.55)
				MacroPopupFrame.largertexture6:SetPoint("BOTTOMLEFT", child, "BOTTOMRIGHT")
			elseif child:GetTexture() == "Interface\\MacroFrame\\MacroPopup-BotRight" then
				child:ClearAllPoints()
				child:SetPoint("BOTTOMRIGHT", 23, -21)

				MacroPopupFrame.largertexture4:SetTexture(nil)
				MacroPopupFrame.largertexture4:SetTexCoord(0, 1, 0.5, 0.7)
				MacroPopupFrame.largertexture4:SetWidth(child:GetWidth())
				MacroPopupFrame.largertexture4:SetHeight(extraheight)
				MacroPopupFrame.largertexture4:SetPoint("BOTTOMRIGHT", child, "TOPRIGHT")

				MacroPopupFrame.largertexture5:SetTexture(nil)
				MacroPopupFrame.largertexture5:SetTexCoord(0.45, 1, 0, 1)
				MacroPopupFrame.largertexture5:SetHeight(child:GetHeight())
				MacroPopupFrame.largertexture5:SetPoint("BOTTOMRIGHT", child, "BOTTOMLEFT")

				MacroPopupFrame.largertexture6:SetTexture(nil)
				MacroPopupFrame.largertexture6:SetTexCoord(0.1, 0.45, 0, 1)
				MacroPopupFrame.largertexture6:SetPoint("BOTTOMRIGHT", MacroPopupFrame.largertexture5, "BOTTOMLEFT")
			end
		end
	end

	-- And some more for the scrollframe
	for _, child in ipairs(kids2) do
		if child.GetTexture then
			local a, b, c, d = child:GetTexCoord()
			if c - 0.0234375 < 0.01 then
				MacroPopupScrollFrame.largertexture1:SetTexture(nil)
				MacroPopupScrollFrame.largertexture1:SetTexCoord(0, 0.46875, 0.2, 0.9)
				MacroPopupScrollFrame.largertexture1:SetWidth(30)
				MacroPopupScrollFrame.largertexture1:SetHeight(extraheight)
				MacroPopupScrollFrame.largertexture1:SetPoint("TOPLEFT", child, "BOTTOMLEFT")
			end
		end
	end
end

function LargerMacroIconSelection.Config(msg)
	local self = LargerMacroIconSelection
	local width, height = strmatch(msg, "(%d+)[^%d]+(%d+)")
	width = tonumber(width)
	height = tonumber(height)
	if width and height then
		width = floor(width)
		height = floor(height)
		if width >= 5 and height >= 4 then
			self.db.width = width
			self.db.height = height
			NUM_ICONS_PER_ROW = width
			NUM_ICON_ROWS = height
			NUM_MACRO_ICONS_SHOWN = NUM_ICONS_PER_ROW * NUM_ICON_ROWS
			self:Init()
			if MacroPopupFrame:IsVisible() then
				Hooked_MacroPopupFrame_Update()
			end
			DEFAULT_CHAT_FRAME:AddMessage(L["Setting macro icon selection width to %d and height to %d"]:format(width, height))
			return
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage(L["LargerMacroIconSelection v1.0.2"])
	DEFAULT_CHAT_FRAME:AddMessage(L["Usage: /lmis width height"])
	DEFAULT_CHAT_FRAME:AddMessage(L["Width must be 5 or larger, height must be 4 or larger"])
	DEFAULT_CHAT_FRAME:AddMessage(L["Current width is %d and current height is %d"]:format(self.db.width, self.db.height))
end
end)