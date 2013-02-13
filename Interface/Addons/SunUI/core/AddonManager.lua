local S, L, DB, _, C = unpack(select(2, ...))
local font = { DB.Font, 12*S.Scale(1), "THINOUTLINE" }
local barTex = DB.Statusbar
local blankTex = DB.Solid
local glowTex = DB.GlowTex
local AM = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("AddonManager", "AceEvent-3.0", "AceHook-3.0")
------------------------------------------------------
-- INITIAL FRAME CREATION ----------------------------
------------------------------------------------------
stAddonManager = CreateFrame("Frame", "stAddonManager", UIParent)
stAddonManager:SetFrameStrata("HIGH")
stAddonManager.header = CreateFrame("Frame", "stAddonmanager_Header", stAddonManager)

stAddonManager.header:SetPoint("CENTER", UIParent, "CENTER", 0, 230)
stAddonManager:SetPoint("TOP", stAddonManager.header, "TOP", 0, 0)

------------------------------------------------------
-- FUNCTIONS -----------------------------------------
------------------------------------------------------
local function SkinFrame(frame, transparent)
	if transparent == true then
	frame:CreateShadow("Background")
	else
	frame:CreateShadow()
	end
end


local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		end
	end		
end

local function SkinScrollBar(frame, thumbTrim)
	if _G[frame:GetName().."BG"] then _G[frame:GetName().."BG"]:SetTexture(nil) end
	if _G[frame:GetName().."Track"] then  _G[frame:GetName().."Track"]:SetTexture(nil) end
	
	if _G[frame:GetName().."Top"] then
		_G[frame:GetName().."Top"]:SetTexture(nil)
		_G[frame:GetName().."Bottom"]:SetTexture(nil)
		_G[frame:GetName().."Middle"]:SetTexture(nil)
	end

	local uScroll = _G[frame:GetName().."ScrollUpButton"]
	local dScroll = _G[frame:GetName().."ScrollDownButton"]
	local track = _G[frame:GetName().."Track"]
	
	if uScroll and dScroll then
		StripTextures(uScroll)		
		StripTextures(dScroll)
		dScroll:EnableMouse(false)
		uScroll:EnableMouse(false)

		if frame:GetThumbTexture() then
			frame:GetThumbTexture():SetTexture(nil)
			if not frame.thumbbg then
				frame.thumbbg = CreateFrame("Frame", nil, frame)
				frame.thumbbg:SetPoint("TOPLEFT", frame:GetThumbTexture(), "TOPLEFT", 2, 14)
				frame.thumbbg:SetPoint("BOTTOMRIGHT", frame:GetThumbTexture(), "BOTTOMRIGHT", -2, -14)
				SkinFrame(frame.thumbbg, true)
				if frame.trackbg then
					frame.thumbbg:SetFrameLevel(frame.trackbg:GetFrameLevel()+2)
				end
			end
		end	
	end	
end

local function GetEnabledAddons()
	local EnabledAddons = {}
		for i=1, GetNumAddOns() do
			local name, _, _, enabled = GetAddOnInfo(i)
			if enabled then
				tinsert(EnabledAddons, name)
			end
		end
	return EnabledAddons
end



local function CreateMenuButton(parent, width, height, text, ...)
	local button = CreateFrame("Button", nil, parent)
	button:SetFrameLevel(parent:GetFrameLevel()+1)
	button:SetSize(width, height)
	SkinFrame(button)
	if ... then button:SetPoint(...) end
	
	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:SetFont(unpack(font))
	button.text:SetPoint("CENTER", 1, 0)
	if text then button.text:SetText(text) end
	S.Reskin(button)	
	
	return button
end

function stAddonManager:UpdateAddonList(queryString)
	local addons = {}
	for i=1, GetNumAddOns() do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
		local lwrTitle, lwrName = strlower(title), strlower(name)
		if (queryString and (strfind(lwrTitle,strlower(queryString)) or strfind(lwrName,strlower(queryString)))) or (not queryString) then
			addons[i] = {}
			addons[i].name = name
			addons[i].title = title
			addons[i].notes = notes
			addons[i].enabled = enabled
			if GetAddOnMetadata(i, "version") then
				addons[i].version = GetAddOnMetadata(i, "version")
			end
			if GetAddOnDependencies(i) then
				addons[i].dependencies = {GetAddOnDependencies(i)}
			end
			if GetAddOnOptionalDependencies(i) then
				addons[i].optionaldependencies = {GetAddOnOptionalDependencies(i)}
			end
		end
	end
	return addons
end



function stAddonManager:LoadProfileWindow()
	local self = stAddonManager
	if not stAddonProfiles then stAddonProfiles = {} end
	
	if self.ProfileWindow then ToggleFrame(self.ProfileWindow) return end
	
	local window = CreateFrame("Frame", "stAddonManager_ProfileWindow", self)
	window:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 0)
	window:SetSize(175, 20)
	SkinFrame(window, true)

		
	local title = window:CreateFontString(nil, "OVERLAY")
	title:SetFont(unpack(font))
	title:SetPoint("CENTER")
	title:SetText(L["Profiles"])
	window.title = title
	
	local EnableAll = CreateMenuButton(window, (window:GetWidth()-15)/2, 20, L["Enable_All"], "TOPLEFT", window, "BOTTOMLEFT", 5, -5)
	EnableAll:SetScript("OnClick", function(self)
		for i, addon in pairs(stAddonManager.AllAddons) do
			EnableAddOn(addon.name)
			stAddonManager.Buttons[i].Icon:SetVertexColor(0, 0.67, 1, 0.8)
			addon.enabled = true
		end
	end)
	self.EnableAll = EnableAll
	
	local DisableAll = CreateMenuButton(window, EnableAll:GetWidth(), EnableAll:GetHeight(), L["Disable_All"], "TOPRIGHT", window, "BOTTOMRIGHT", -5, -5)
	DisableAll:SetScript("OnClick", function(self)
		for i, addon in pairs(stAddonManager.AllAddons) do
			if addon.name ~= ADDON_NAME then			
				DisableAddOn(addon.name)
				stAddonManager.Buttons[i].Icon:SetVertexColor(0.1, 0.1, 0.1, 0.8)
				addon.enabled = false
			end
		end
	end)
	self.DisableAll = DisableAll
	
	local SaveProfile = CreateMenuButton(window, window:GetWidth()-10, 20, L["New_Profile"], "TOPLEFT", EnableAll, "BOTTOMLEFT", 0, -5)
	SaveProfile:SetScript("OnClick", function(self)
		if not self.editbox then
			local editbox = CreateFrame("EditBox", nil, self)
			SkinFrame(editbox)
			editbox:SetAllPoints(self)
			editbox:SetFont(unpack(font))
			editbox:SetText(L["Profile_Name"])
			editbox:SetAutoFocus(false)
			editbox:SetFocus(true)
			editbox:HighlightText()
			editbox:SetTextInsets(3, 0, 0, 0)
			editbox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
			editbox:SetScript("OnEscapePressed", function(self) self:SetText(L["Profile_Name"]) self:ClearFocus() self:Hide() end)
			editbox:SetScript("OnEnterPressed", function(self)
				local profileName = self:GetText()
				self:ClearFocus()
				self:SetText(L["Profile_Name"])
				self:Hide()
				if not profileName then return end
				stAddonProfiles[profileName] = GetEnabledAddons()
				stAddonManager:UpdateProfileList()
			end)
	
			self.editbox = editbox
		else
			self.editbox:Show()
			self.editbox:SetFocus(true)
			self.editbox:HighlightText()
		end
	end)
	self.SaveProfile = SaveProfile
	
	self:SetScript("OnHide", function(self)
		if self.SaveProfile.editbox then self.SaveProfile.editbox:Hide() end
		window:Hide()
	end)
	
	local buttons = {}
	function stAddonManager:UpdateProfileList()
		
		--Thanks for hydra for this sort code
		local sort = function(t, func)
			local temp = {}
			local i = 0

			for n in pairs(t) do
				table.insert(temp, n)
			end

			table.sort(temp, func)
			
			local iter = function()
				i = i + 1
				if temp[i] == nil then
					return nil
				else
					return temp[i], t[temp[i]]
				end
			end

			return iter
		end
		
		local function CollapseAllProfiles()
			for i=1, #buttons do
				buttons[i].overlay:Hide()
				buttons[i]:SetHeight(20)
			end
		end
		
		for i=1, #buttons do
			buttons[i]:Hide()
			CollapseAllProfiles()
		end

		local i = 1
		for profileName, addonList in sort(stAddonProfiles, function(a, b) return strlower(b) > strlower(a) end) do
			if not buttons[i] then
				local button = CreateMenuButton(window, window:GetWidth()-10, 20, "<"..L["Profile_Name"]..">")
				button.text:ClearAllPoints()
				button.text:SetPoint("CENTER", button, "TOP", 0, -10)
				
				local overlay = CreateFrame("Frame", nil, button)
				overlay:SetHeight(1)
				overlay:SetPoint("TOP", button, "TOP", 0, -18)
				overlay:SetWidth(button:GetWidth()-10)
				overlay:SetFrameLevel(button:GetFrameLevel()+1)
				overlay:Hide()

				overlay.set = CreateMenuButton(overlay, overlay:GetWidth(), 20, L["Set_To"], "TOP", button, "TOP", 0, -18)
				overlay.add = CreateMenuButton(overlay, overlay:GetWidth(), 20, L["Add_To"], "TOP", overlay.set, "BOTTOM", 0, 1)
				overlay.remove = CreateMenuButton(overlay, overlay:GetWidth(), 20, L["Remove_From"], "TOP", overlay.add, "BOTTOM", 0, 1)
				overlay.delete = CreateMenuButton(overlay, overlay:GetWidth(), 20, L["Delete_Profile"], "TOP", overlay.remove, "BOTTOM", 0, 1)
				
				button.overlay = overlay
				
				button:SetScript("OnClick", function(self)
					
					
					if self.overlay:IsShown() then
						CollapseAllProfiles()
					else
						CollapseAllProfiles()
						self.overlay:Show()
						self:SetHeight(20*5)
					end
				end)
				
				buttons[i] = button
			end
			
			buttons[i]:Show()
			buttons[i].text:SetText(profileName)
			local overlay = buttons[i].overlay
			overlay.set:SetScript("OnClick", function(self)
				DisableAllAddOns()
				EnableAddOn(ADDON_NAME)
				for i, name in pairs(addonList) do EnableAddOn(name) end
				stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
				stAddonManager:UpdateList(stAddonManager.AllAddons)
				CollapseAllProfiles()
			end)
			overlay.add:SetScript("OnClick", function(self)
				for i, name in pairs(addonList) do EnableAddOn(name) end
				stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
				stAddonManager:UpdateList(stAddonManager.AllAddons)
				CollapseAllProfiles()
			end)
			overlay.remove:SetScript("OnClick", function(self)
				for i, name in pairs(addonList) do if name ~= ADDON_NAME then DisableAddOn(name) end end
				stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
				stAddonManager:UpdateList(stAddonManager.AllAddons)
				CollapseAllProfiles()
			end)
			overlay.delete:SetScript("OnClick", function(self)
				if IsShiftKeyDown() then
					stAddonProfiles[profileName] = nil
					stAddonManager:UpdateProfileList()
					CollapseAllProfiles()
				else
					print("|cff00aaffAddonManager|r: "..L["Confirm_Delete"])
				end
			end)
			i = i + 1
		end

		local prevButton
		for i,button in pairs(buttons) do
			if i == 1 then
				button:SetPoint("TOP", SaveProfile, "BOTTOM", 0, -5)
			else
				button:SetPoint("TOP", prevButton, "BOTTOM", 0, 1)
			end
			prevButton = button
		end

		if not prevButton then prevButton = SaveProfile end
		
	end
	self.ProfileWindow = window
	
	stAddonManager:UpdateProfileList()
end

function stAddonManager:LoadWindow()
	if stAddonManager.Loaded then stAddonManager:Show() UIFrameFadeIn(stAddonManager, 0.3, 0, 1); return  end
	local window = stAddonManager
	local header = window.header
	
	tinsert(UISpecialFrames,window:GetName());
	
	window:SetSize(300,500)
	header:SetSize(window:GetWidth(),20)
	S.SetBD(window)
	--SkinFrame(window, true)
	--SkinFrame(header)
	
	header:EnableMouse(true)
	header:SetMovable(true)
	header:SetScript("OnMouseDown", function(self) self:StartMoving() end)
	header:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
	
	local hTitle = stAddonManager.header:CreateFontString(nil, "OVERLAY")
	hTitle:SetFont(unpack(font))
	hTitle:SetPoint("CENTER")
	hTitle:SetText(L["SunUI插件管理"])
	header.title = hTitle 

	local close = CreateMenuButton(header, 15, 15, "x", "RIGHT", header, "RIGHT", -5, -2)
	close:SetBackdrop(nil)
	close:HookScript("OnEnter", function(self) self:SetBackdrop(nil) end)
	close:HookScript("OnLeave", function(self) self:SetBackdrop(nil) end)
	close:SetScript("OnClick", function() S.FadeOutFrameDamage(window, 0.3) end)
	header.close = close
	
	local addonListBG = CreateFrame("Frame", window:GetName().."_ScrollBackground", window)
	addonListBG:SetPoint("TOPLEFT", header, "TOPLEFT", 10, -50)
	addonListBG:SetWidth(window:GetWidth()-20)
	addonListBG:SetHeight(window:GetHeight()-60)
	--SkinFrame(addonListBG)
	
	--Create scroll frame (God damn these things are a pain)
	local scrollFrame = CreateFrame("ScrollFrame", window:GetName().."_ScrollFrame", window, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", addonListBG, "TOPLEFT", 0, -2)
	scrollFrame:SetWidth(addonListBG:GetWidth()-25)
	scrollFrame:SetHeight(addonListBG:GetHeight()-5)
	SkinScrollBar(_G[window:GetName().."_ScrollFrameScrollBar"])
	scrollFrame:SetFrameLevel(window:GetFrameLevel()+1)
	
	scrollFrame.Anchor = CreateFrame("Frame", window:GetName().."_ScrollAnchor", scrollFrame)
	scrollFrame.Anchor:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 0, -3)
	scrollFrame.Anchor:SetWidth(window:GetWidth()-40)
	scrollFrame.Anchor:SetHeight(scrollFrame:GetHeight())
	scrollFrame.Anchor:SetFrameLevel(scrollFrame:GetFrameLevel()+1)
	scrollFrame:SetScrollChild(scrollFrame.Anchor)
	
	--Load up addon information
	stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
	stAddonManager.FilteredAddons = stAddonManager:UpdateAddonList()
	stAddonManager.showEnabled = true
	stAddonManager.showDisabled = true
	
	stAddonManager.Buttons = {}
	
	--Create initial list
	for i, addon in pairs(stAddonManager.AllAddons) do
		local button = CreateFrame("Frame", nil, scrollFrame.Anchor)
		button:SetFrameLevel(scrollFrame.Anchor:GetFrameLevel() + 1)
		button:SetSize(16, 16)
		button.Icon = button:CreateTexture(nil, "ARTWORK") 
		button.Icon:SetTexture(barTex) 
		button.Icon:SetPoint("CENTER", button, "CENTER", 0, 0)
		button.Icon:SetSize(16, 16)
		--S.MakeTexShadow(button, button.Icon, 3)
		if addon.enabled then
			button.Icon:SetVertexColor(0, 0.67, 1, 0.8)
		else
			button.Icon:SetVertexColor(0.1, 0.1, 0.1, 0.8)
		end
		
		if i == 1 then
			button:Point("TOPLEFT", scrollFrame.Anchor, "TOPLEFT", 7, -5)
		else
			button:SetPoint("TOP", stAddonManager.Buttons[i-1], "BOTTOM", 0, -3)
		end
		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetFont(unpack(font))
		button.text:SetJustifyH("LEFT")
		button.text:SetPoint("LEFT", button, "RIGHT", 8, 0)
		button.text:SetPoint("RIGHT", scrollFrame.Anchor, "RIGHT", 0, 0)
		button.text:SetText(addon.title)
		
		button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", -3, self:GetHeight())
			GameTooltip:ClearLines()
			local mem = GetAddOnMemoryUsage(i)
			local InfoBarStatusColor = {{1, 0, 0}, {1, 1, 0}, {0, 1, 0}}
			local r, g, b = S.ColorGradient((3000-mem)/3000, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																					InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																					InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
			if addon.version then GameTooltip:AddDoubleLine(addon.title, addon.version, 0.40, 0.78, 1, 1, 1, 1)
			else GameTooltip:AddLine(addon.title, 0.40, 0.78, 1) end
			if addon.notes then	GameTooltip:AddLine(addon.notes, nil, nil, nil, true) end
			if addon.dependencies then GameTooltip:AddLine(L["Dependencies"]..unpack(addon.dependencies), 1, .5, 0) end
			if addon.optionaldependencies then GameTooltip:AddLine(L["Optional Dependencies"]..unpack(addon.optionaldependencies), 1, .5, 0) end
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(L["内存占用"], S.FormatMemory(mem), 1, 1, 1, r, g, b)
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		
		button:SetScript("OnMouseDown", function(self)
			if addon.enabled then
				button.Icon:SetVertexColor(0.1, 0.1, 0.1, 0.8)
				DisableAddOn(addon.name)
				addon.enabled = false
			else
				button.Icon:SetVertexColor(0, 0.67, 1, 0.8)
				EnableAddOn(addon.name)
				addon.enabled = true
			end
		end)
			
		stAddonManager.Buttons[i] = button
	end
		
	function stAddonManager:UpdateList(AddonsTable)
		--Start off by hiding all of the buttons
		for _, b in pairs(stAddonManager.Buttons) do b:Hide() end
		local i = 1
		for _, addon in pairs(AddonsTable) do
			local button = stAddonManager.Buttons[i]
			button:Show()
			if addon.enabled then
				stAddonManager.Buttons[i].Icon:SetVertexColor(0, 0.67, 1, 0.8)
			else
				stAddonManager.Buttons[i].Icon:SetVertexColor(0.1, 0.1, 0.1, 0.8)
			end
			
			button:SetScript("OnMouseDown", function(self)
				if addon.enabled then
					stAddonManager.Buttons[i].Icon:SetVertexColor(0.1, 0.1, 0.1, 0.8)
					DisableAddOn(addon.name)
					addon.enabled = false
				else
					stAddonManager.Buttons[i].Icon:SetVertexColor(0, 0.67, 1, 0.8)
					EnableAddOn(addon.name)
					addon.enabled = true
				end
			end)
			
			button.text:SetText(addon.title)
			i = i+1
		end
	end
		
	--Search Bar
	local searchBar = CreateFrame("EditBox", window:GetName().."_SearchBar", window)
	searchBar:SetFrameLevel(window:GetFrameLevel()+1)
	searchBar:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 10, -5)
	searchBar:SetWidth(150)
	searchBar:SetHeight(20)
	SkinFrame(searchBar)
	searchBar:SetFont(unpack(font))
	searchBar:SetText(L["Search"])
	searchBar:SetAutoFocus(false)
	searchBar:SetTextInsets(3, 0, 0 ,0)
	searchBar:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	searchBar:SetScript("OnEscapePressed", function(self) searchBar:SetText(L["Search"]) stAddonManager:UpdateList(stAddonManager.AllAddons) searchBar:ClearFocus() end)
	searchBar:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
	searchBar:SetScript("OnTextChanged", function(self, input)
		if input then
			stAddonManager.FilteredAddons = stAddonManager:UpdateAddonList(self:GetText())
			stAddonManager:UpdateList(stAddonManager.FilteredAddons)
		end
	end)
		
	local sbClear = CreateFrame("Button", nil, searchBar)
	sbClear:SetPoint("RIGHT", searchBar, "RIGHT", 0, 0)
	sbClear:SetFrameLevel(searchBar:GetFrameLevel()+2)
	sbClear:SetSize(20, 20)
	sbClear.text = sbClear:CreateFontString(nil, "OVERLAY")
	sbClear.text:SetFont(unpack(font))
	sbClear.text:SetText("x")
	sbClear.text:SetPoint("CENTER", sbClear, "CENTER", 0, 0)
	sbClear:SetScript("OnEnter", function(self) self.text:SetTextColor(0/255, 170/255, 255/255) end)
	sbClear:SetScript("OnLeave", function(self) self.text:SetTextColor(255/255, 255/255, 255/255) end)
	sbClear:SetScript("OnClick", function(self) searchBar:SetText(L["Search"]) stAddonManager:UpdateList(stAddonManager.AllAddons) searchBar:ClearFocus() end)
	searchBar.clear = sbClear
	stAddonManager.searchBar = searchBar

	local profileButton = CreateMenuButton(window, 50, 20, L["Profiles"], "TOPRIGHT", header, "BOTTOMRIGHT", -10, -5)
	profileButton:SetScript("OnClick", function(self)
		stAddonManager:LoadProfileWindow()
	end)
	stAddonManager.profileButton = profileButton
	
	local reloadButton = CreateMenuButton(window, 1, searchBar:GetHeight(), L["ReloadUI"], "LEFT", searchBar, "RIGHT", 5, 0)
	reloadButton:SetPoint("RIGHT", profileButton, "LEFT", -5, 0)
	reloadButton:SetScript("OnClick", function(self)
		if InCombatLockdown() then return end
		ReloadUI()
	end)
	stAddonManager.reloadButton = reloadButton
	
	stAddonManager.Loaded = true
end

SLASH_STADDONMANAGER1, SLASH_STADDONMANAGER2, SLASH_STADDONMANAGER3 = "/staddonmanager", "/stam", "/addon"
SlashCmdList["STADDONMANAGER"] = function() stAddonManager:LoadWindow() end

local function CheckForAddon(event, addon, addonName)
	return ((event == "PLAYER_ENTERING_WORLD" and IsAddOnLoaded(addonName)) or (event == "ADDON_LOADED" and addon == addonName))
end

local gmbAddOns = CreateFrame("Button", "GameMenuButtonAddOns", GameMenuFrame, "GameMenuButtonTemplate")
gmbAddOns:RegisterEvent("ADDON_LOADED")
gmbAddOns:RegisterEvent("PLAYER_ENTERING_WORLD")

function AM:OnInitialize()
	gmbAddOns:SetSize(_G["GameMenuButtonHelp"]:GetWidth(), _G["GameMenuButtonHelp"]:GetHeight())

	gmbAddOns:SetText(L["插件管理"])
	gmbAddOns:SetPoint(_G["GameMenuButtonHelp"]:GetPoint())
	_G["GameMenuButtonHelp"]:SetPoint("TOP", gmbAddOns, "BOTTOM", 0, -1)
	_G["GameMenuFrame"]:SetHeight(_G["GameMenuFrame"]:GetHeight()+_G["GameMenuButtonMacros"]:GetHeight());
	gmbAddOns:SetScript("OnClick", function()
		HideUIPanel(_G["GameMenuFrame"]);
		stAddonManager:LoadWindow()
	end)
	S.Reskin(gmbAddOns)
end