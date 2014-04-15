local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local AB = S:NewModule("ActionBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local LibActionButton = LibStub and LibStub("LibActionButton-1.0", true)
local activeButtons = LibActionButton and LibActionButton.activeButtons or ActionBarActionEventsFrame.frames

local hidefunction = ActionButton_HideGrid
AB.modName = L["动作条"]
AB.order = 4
AB.visibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show"
AB.buttonList = {}
AB.bigButton = {}

function AB:GetOptions()
	local options = {
		group1 = {
			type = "group", order = 1,
			name = " ",guiInline = true,
			args = {
				Bar1Layout = {
					type = "select", order = 1,
					name = L["bar1布局"], desc = L["请选择布局"],
					values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
					set = function(info, value) self.db.Bar1Layout = value
						self:UpdateSpace()
					end,
				},
				Bar2Layout = {
					type = "select", order = 2,
					name = L["bar2布局"], desc = L["请选择布局"],
					values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
					set = function(info, value) self.db.Bar2Layout = value
						self:UpdateSpace()
					end,
				},
				Bar3Layout = {
					type = "select", order = 3,
					name = L["bar3布局"], desc = L["请选择布局"],
					values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
					set = function(info, value) self.db.Bar3Layout = value
						self:UpdateSpace()
					end,
				},	
				Bar4Layout = {
					type = "select", order = 4,
					name = L["bar4布局"], desc = L["请选择布局"],
					values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
					set = function(info, value) self.db.Bar4Layout = value
						self:UpdateSpace()
					end,
				},	
				Bar5Layout = {
					type = "select", order = 5,
					name = L["bar5布局"], desc = L["请选择布局"].."\n 需要"..L["正常布局"],disabled = function(info) return (self.db.Big4Layout == 1) end,
					values = {[1] = "12x1布局", [2] = "6x2布局"},
					set = function(info, value) self.db.Bar5Layout = value
						self:UpdateSpace()
					end,
				},	
				Big4Layout = {
					type = "select", order = 6,
					name = L["4方块布局"], desc = L["请选择布局"],
					values = {[1] = L["4方块布局"],  [2] = L["正常布局"] },
				},
			}
		},
		group2 = {
			type = "group", order = 2,
			name = " ",guiInline = true,
			args = {
				HideHotKey = {
					type = "toggle", order = 1,
					name = L["隐藏快捷键显示"],			
				},
				HideMacroName = {
					type = "toggle", order = 2,
					name = L["隐藏宏名称显示"],		
				},
				CooldownFlash = {
					type = "toggle", order = 3,
					name = L["冷却闪光"],	
					set = function(info, value) self.db.CooldownFlash = value
						self:UpdateSetCoolDownFlashUpdate()
					end,
				},
				UnLock = {
					type = "execute",
					name = L["按键绑定"],
					order = 4,
					func = function()
						SlashCmdList.MOUSEOVERBIND()
					end,
				},
			}
		},
		group3 = {
			type = "group", order = 3,
			name = " ",guiInline = true,
			args = {
				ButtonSize = {
					type = "range", order = 1,
					name = L["动作条按钮大小"], desc = L["动作条按钮大小"],
					min = 16, max = 64, step = 1,
					set = function(info, value) 
						self.db.ButtonSize = value
						self:UpdateSize(value)
					end,
				},
				ButtonSpacing = {
					type = "range", order = 2,
					name = L["动作条间距大小"], desc = L["动作条间距大小"],
					min = 0, max = 6, step = 1,
					get = function(info) return self.db.ButtonSpacing end,
					set = function(info, value) self.db.ButtonSpacing = value
						self:UpdateSpace()
					end,
				},
				FontSize = {
					type = "range", order = 3,
					name = L["动作条字体大小"], desc = L["动作条字体大小"],
					min = 1, max = 36, step = 1,
				},
				CooldownFlashSize = {
					type = "input",
					name = L["冷却闪光图标大小"],
					desc = L["冷却闪光图标大小"],
					order = 4,
					disabled = function(info) return not self.db.CooldownFlash end,
					get = function() return tostring(self.db.CooldownFlashSize) end,
					set = function(_, value) 
						self.db.CooldownFlashSize = tonumber(value) 
						self:UpdateSetCoolDownFlashUpdate()
					end,
				},
				CooldownAlhpa = {
					name = L["CD时透明度"],
					type = "range",
					order = 5,
					min = 0, max = 1, step = 0.05,
				},
			}
		},
		group5 = {
			type = "group", order = 4,
			name = " ",guiInline = true,
			args = {		
				AllFade = {
					type = "toggle", order = 2,
					name = L["全部动作条渐隐"],		
				},
				Bar1Fade = {
					type = "toggle", order = 3,
					disabled = function(info) return self.db.AllFade end,
					name = L["Bar1渐隐"],		
				},
				Bar2Fade = {
					type = "toggle", order = 4,
					disabled = function(info) return self.db.AllFade end,
					name = L["Bar2渐隐"],		
				},
				Bar3Fade = {
					type = "toggle", order = 5,
					disabled = function(info) return self.db.AllFade end,
					name = L["Bar3渐隐"],		
				},
				Bar4Fade = {
					type = "toggle", order = 6,
					disabled = function(info) return self.db.AllFade end,
					name = L["Bar4渐隐"],		
				},
				Bar5Fade = {
					type = "toggle", order = 7,
					disabled = function(info) return self.db.AllFade end,
					name = L["Bar5渐隐"],		
				},
				StanceBarFade = {
					type = "toggle", order = 8,
					disabled = function(info) return self.db.AllFade end,
					name = L["姿态栏渐隐"],		
				},

				PetBarFade = {
					type = "toggle", order = 9,
					disabled = function(info) return self.db.AllFade end,
					name = L["宠物渐隐"],		
				},
			}
		},
		group6 = {
			type = "group", order = 6,
			name = " ",guiInline = true, disabled =function(info) return (self.db.Big4Layout ~= 1) end,
			args = {
				BigSize1 = {
					type = "range", order = 1, desc = "大小设置为小于10的时候为关闭按钮",
					name = L["Big1大小"],
					min = 9, max = 80, step = 1,
					set = function(info, value) 
						self.db.BigSize1 = value
						self:UpdateBigButtonSize()
					end,
				},
				BigSize2 = {
					type = "range", order = 2, desc = "大小设置为小于10的时候为关闭按钮",
					name = L["Big2大小"],
					min = 9, max = 80, step = 1,
					set = function(info, value) 
						self.db.BigSize2 = value
						self:UpdateBigButtonSize()
					end,
				},
				BigSize3 = {
					type = "range", order = 3, desc = "大小设置为小于10的时候为关闭按钮",
					name = L["Big3大小"],
					min = 9, max = 80, step = 1,
					set = function(info, value) 
						self.db.BigSize3 = value
						self:UpdateBigButtonSize()
					end,
				},
				BigSize4 = {
					type = "range", order = 4, desc = "大小设置为小于10的时候为关闭按钮",
					name = L["Big4大小"],
					min = 9, max = 80, step = 1,
					set = function(info, value) 
						self.db.BigSize4 = value			
						self:UpdateBigButtonSize()
					end,
				},
			}
		},
	}
	return options
end
function AB:blizzHider()
	local hider = CreateFrame("Frame")
	hider:Hide()
	local hideFrames = {MainMenuBar, MainMenuBarPageNumber, ActionBarDownButton, ActionBarUpButton, OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame, CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, AchievementMicroButton, QuestLogMicroButton, GuildMicroButton, PVPMicroButton, LFDMicroButton, CompanionsMicroButton, EJMicroButton, MainMenuMicroButton, StoreMicroButton, HelpMicroButton, MainMenuBarBackpackButton,CharacterBag0Slot,CharacterBag1Slot,CharacterBag2Slot,CharacterBag3Slot}
	for k, frame in pairs(hideFrames) do
		if frame then
			frame:SetParent(hider)
		end
	end

	StanceBarLeft:SetTexture("")
	StanceBarMiddle:SetTexture("")
	StanceBarRight:SetTexture("")
	SlidingActionBarTexture0:SetTexture("")
	SlidingActionBarTexture1:SetTexture("")
	PossessBackground1:SetTexture("")
	PossessBackground2:SetTexture("")
	MainMenuBarTexture0:SetTexture("")
	MainMenuBarTexture1:SetTexture("")
	MainMenuBarTexture2:SetTexture("")
	MainMenuBarTexture3:SetTexture("")
	MainMenuBarLeftEndCap:SetTexture("")
	MainMenuBarRightEndCap:SetTexture("")

	local textureList = {"_BG","EndCapL","EndCapR","_Border","Divider1","Divider2","Divider3","ExitBG","MicroBGL","MicroBGR","_MicroBGMid","ButtonBGL","ButtonBGR","_ButtonBGMid"}

	for k, tex in pairs(textureList) do
		OverrideActionBar[tex]:SetAlpha(0)
	end
end

function AB:CreateExtrabarBar()
	local bar = CreateFrame("Frame","SunUIExtraActionBar",UIParent, "SecureHandlerStateTemplate")
	bar:SetSize(self.db.ButtonSize*2,self.db.ButtonSize*2)
	bar:SetFrameStrata("MEDIUM")
	bar:SetPoint("CENTER", "UIParent", "CENTER", 0, -150)

	ExtraActionBarFrame:SetParent(bar)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
	ExtraActionBarFrame.ignoreFramePositionManager = true
	ExtraActionButton1:SetSize(self.db.ButtonSize*2,self.db.ButtonSize*2)
	ExtraActionBarFrame:SetFrameLevel(3)
	ExtraActionButton1Cooldown:SetPoint("TOPLEFT")
	ExtraActionButton1Cooldown:SetPoint("BOTTOMRIGHT")
	ExtraActionButton1.style:SetTexture(nil)
    hooksecurefunc(ExtraActionButton1.style, "SetTexture", function(self, texture)
		if texture then
			self:SetTexture(nil)
		end
    end)
	S:CreateMover(bar, "ExtraActionBarMover", L["特殊动作条锚点"], true, nil, "ALL,ACTIONBARS")
end
function AB:CreateOverrideBar()
	local num = NUM_ACTIONBAR_BUTTONS
	--create the frame to hold the buttons
	local bar = CreateFrame("Frame", "SunUI_OverrideBar", UIParent, "SecureHandlerStateTemplate")
	bar:SetWidth(self.db.ButtonSize*12+self.db.ButtonSpacing*11)
	bar:SetHeight(self.db.ButtonSize)
	bar:SetPoint("LEFT", "ActionBar1Mover", "LEFT")
	--move the buttons into position and reparent them
	OverrideActionBar:SetParent(bar)
	OverrideActionBar:EnableMouse(false)
	OverrideActionBar:SetScript("OnShow", nil) --remove the onshow script
	local leaveButtonPlaced = false
	for i=1, num do
		local button =  _G["OverrideActionBarButton"..i]
		if not button and not leaveButtonPlaced then
			button = OverrideActionBar.LeaveButton --the magic 7th button
			leaveButtonPlaced = true
		end
		if not button then
			break
		end
		table.insert(self.buttonList, button) --add the button object to the list
		button:SetSize(self.db.ButtonSize, self.db.ButtonSize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0, 0)
		else
			local previous = _G["OverrideActionBarButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
		end
	end
	--show/hide the frame on a given state driver
	RegisterStateDriver(bar, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
	RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
end
function AB:CreatePetBar()
	local num = NUM_PET_ACTION_SLOTS
    local bar = CreateFrame("Frame", "SunUIPetBar", UIParent, "SecureHandlerStateTemplate")
    bar:SetWidth(self.db.ButtonSize*num+self.db.ButtonSpacing*(num-1))
    bar:SetHeight(self.db.ButtonSize)
	PetActionBarFrame:SetParent(bar)
	PetActionBarFrame:EnableMouse(false)
    bar:SetPoint("BOTTOMRIGHT", "MultiBarBottomRightButton12", "TOPRIGHT",  0,  4)
	local button
	
	for i = 1, num do
		button = _G["PetActionButton"..i]
		button:SetSize(self.db.ButtonSize, self.db.ButtonSize)
		button:ClearAllPoints()
		table.insert(self.buttonList, button)
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0, 0)
		else
			local previous = _G["PetActionButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
		end
	end
	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; [@pet,exists] show; hide")
	S:CreateMover(bar, "PetBarMover", L["宠物动作条锚点"], true, nil, "ALL,ACTIONBARS")
end
function AB:CreateStanceBar()
	
	local num = NUM_STANCE_SLOTS
	local num2 = NUM_POSSESS_SLOTS
    local bar = CreateFrame("Frame","SunUIStanceBar",UIParent, "SecureHandlerStateTemplate")
    bar:SetWidth(self.db.ButtonSize*6+self.db.ButtonSpacing*(6-1))
    bar:SetHeight(self.db.ButtonSize)
	bar:SetPoint("BOTTOMLEFT", "MultiBarBottomRightButton6", "TOPLEFT", 0, 4)

	StanceBarFrame:SetParent(bar)
    StanceBarFrame:EnableMouse(false)

	StanceBarFrame:ClearAllPoints()
	StanceBarFrame:SetPoint("BOTTOMLEFT",bar)
	StanceBarFrame.ignoreFramePositionManager = true

	for i=1, num do
		local button = _G["StanceButton"..i]
		table.insert(self.buttonList, button)
		button:SetSize(self.db.ButtonSize, self.db.ButtonSize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["StanceButton"..i-1]      
			button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
		end
    end
	--POSSESS BAR

	--move the buttons into position and reparent them
	PossessBarFrame:SetParent(bar)
	PossessBarFrame:EnableMouse(false)

	for i=1, num2 do
		local button = _G["PossessButton"..i]
		table.insert(self.buttonList, button) --add the button object to the list
		button:SetSize(self.db.ButtonSize, self.db.ButtonSize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0, 0)
		else
			local previous = _G["PossessButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
		end
	end
	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui] hide; show")
	S:CreateMover(bar, "StanceBarMover", L["姿态栏锚点"], true, nil, "ALL,ACTIONBARS")
end
function AB:CreateExitVehicle()
	
	local bar = CreateFrame("Frame","ExitVehicle",UIParent, "SecureHandlerStateTemplate")
	bar:SetHeight(self.db.ButtonSize)
	bar:SetWidth(self.db.ButtonSize)
	bar:SetScale(1.3)
	bar:SetPoint("BOTTOM", "UIParent", "BOTTOM", 278, 66)

	local button = CreateFrame("BUTTON", nil, bar, "SecureHandlerClickTemplate, SecureHandlerStateTemplate");
	button:SetAllPoints(bar)
	button:RegisterForClicks("AnyUp")
	button:SetNormalTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
	button:SetPushedTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
	button:SetHighlightTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
	button:SetScript("OnClick", function(self) VehicleExit() end)

	local nt = button:GetNormalTexture()
	local pu = button:GetPushedTexture()
	local hi = button:GetHighlightTexture()
	nt:SetTexCoord(0.0859375,0.1679688,0.359375,0.4414063)
	pu:SetTexCoord(0.001953125,0.08398438,0.359375,0.4414063)
	hi:SetTexCoord(0.6152344,0.6972656,0.359375,0.4414063)
	hi:SetBlendMode("ADD")

	RegisterStateDriver(button, "visibility", "[petbattle][overridebar][vehicleui] hide; [possessbar][@vehicle,exists] show; hide")
	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui] hide; show")
	S:CreateMover(bar, "ExitVehicleBarMover", BINDING_NAME_VEHICLEEXIT, true, nil, "ALL,ACTIONBARS")
end

function AB:UpdateBigButtonSize()
	local C = self.db
	for i=1, 4 do
		local button = _G["MultiBarLeftButton"..i]
		button:SetSize(C["BigSize"..i], C["BigSize"..i])
		_G["SunUIMultiBarLeft"..i]:SetSize(C["BigSize"..i], C["BigSize"..i])
		if C["BigSize"..i] < 10 then
			button:ClearAllPoints()
			button:SetParent(S.HiddenFrame)
		else
			button:SetParent(_G["SunUIMultiBarLeft"..i])
			if i == 1 then
				button:SetAllPoints(ActionBar5_1Mover)
			elseif i == 2 then
				button:SetAllPoints(ActionBar5_2Mover)
			elseif i == 3 then
				button:SetAllPoints(ActionBar5_3Mover)
			else
				button:SetAllPoints(ActionBar5_4Mover)
			end
		end
	end
end
function AB:UpdateSize(val)
	for k, v in ipairs(self.buttonList) do 
		if v then 
			v:SetSize(val, val)
		end
	end
end
local function ShowGrid(event, str, value)
	if str ~= "ALWAYS_SHOW_MULTIBARS_TEXT" then return end
	if GetCVar("alwaysShowActionBars") == "1" then 
		SetActionBarToggles(true, true, true, true)
		ActionButton_HideGrid = S.dummy
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
		end
	else
		ActionButton_HideGrid = hidefunction
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 0)
			ActionButton_HideGrid(button)
			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 0)
			ActionButton_HideGrid(button)
			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 0)
			ActionButton_HideGrid(button)
			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 0)
			ActionButton_HideGrid(button)
			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 0)
			ActionButton_HideGrid(button)
		end
	end
end

local function HideLossCD()
	for button in pairs(activeButtons) do
		button.cooldown:SetLossOfControlCooldown(0, 0)
	end
end

function AB:UpdateSpace()
	
	for i = 1, 12 do
		local button = _G["ActionButton"..i]
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", SunUIActionBar1, 0,0)
		else
			local previous = _G["ActionButton"..i-1]
			if self.db.Bar1Layout == 2 and i == 7 then
				previous = _G["ActionButton1"]
				button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, self.db.ButtonSpacing)
			else
				button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
			end
		end
	end
		
	for i=1, 12 do
		local button = _G["MultiBarBottomLeftButton"..i]
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", SunUIActionBar2, 0,0)
		else
			local previous = _G["MultiBarBottomLeftButton"..i-1]      
			if self.db.Bar2Layout == 2 and i == 7 then
				previous = _G["MultiBarBottomLeftButton1"]
				button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, self.db.ButtonSpacing)
			else
				button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
			end
		end
	end
		
	if self.db.Bar3Layout == 1 then
		for i=1, 12 do
			local button = _G["MultiBarBottomRightButton"..i]
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", SunUIActionBar3, 0,0)
			else
				local previous = _G["MultiBarBottomRightButton"..i-1]     
				button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0) 
			end
		end
	elseif self.db.Bar3Layout == 2 then
		for i = 1, 12 do
		button = _G["MultiBarBottomRightButton"..i]
		button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("BOTTOMRIGHT", SunUIActionBar3, "BOTTOMRIGHT", 0, 0)
			elseif i <= 3 then
				button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -self.db.ButtonSpacing, 0)
			elseif i == 4 then
				button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton1"], "TOPLEFT", 0, self.db.ButtonSpacing)
			elseif i <= 6 then
				button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -self.db.ButtonSpacing, 0)	
			elseif i == 7 then
				button:SetPoint("BOTTOMLEFT", SunUIActionBar3_2, "BOTTOMLEFT", 0, 0)
			elseif i <= 9 then
				button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", self.db.ButtonSpacing, 0)
			elseif i == 10 then
				button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton7"], "TOPLEFT", 0, self.db.ButtonSpacing)
			elseif i <= 12 then
				button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", self.db.ButtonSpacing, 0)	
			end
		end
	end
		
	if self.db.Bar4Layout == 1 then
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
			button:ClearAllPoints()
				if i == 1 then
					button:SetPoint("TOPLEFT", SunUIActionBar4, 0,0)
				else
					local previous = _G["MultiBarRightButton"..i-1]
					button:SetPoint("TOP", previous, "BOTTOM", 0, -self.db.ButtonSpacing)
				end
		end
	elseif self.db.Bar4Layout == 2 then 
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
			button:ClearAllPoints()
				if i == 1 then
					button:SetPoint("TOPLEFT", SunUIActionBar4, 0,0)	
				else
					local previous = _G["MultiBarRightButton"..i-1]
					if  i == 7 then
					previous = _G["MultiBarRightButton1"]
					button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -self.db.ButtonSpacing)
					else
					button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
					end
				end
		end
	end
	
	if self.db.Big4Layout == 2 then
		if self.db.Bar5Layout == 1 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
				button:ClearAllPoints()
					if i == 1 then
						button:SetPoint("TOPLEFT", bar, 0,0)
					else
						local previous = _G["MultiBarLeftButton"..i-1]
						button:SetPoint("TOP", previous, "BOTTOM", 0, -self.db.ButtonSpacing)
					end
			end
		elseif self.db.Bar5Layout == 2 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
				button:ClearAllPoints()
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)	
				else
					local previous = _G["MultiBarLeftButton"..i-1]
					if  i == 7 then
						previous = _G["MultiBarLeftButton1"]
						button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -self.db.ButtonSpacing)
					else
						button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
					end
				end
			end
		end
	end
	
	for i=1, NUM_ACTIONBAR_BUTTONS do
		local button =  _G["OverrideActionBarButton"..i]
		if not button and not leaveButtonPlaced then
			button = OverrideActionBar.LeaveButton 
			leaveButtonPlaced = true
		end
		if not button then
			break
		end
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", SunUI_OverrideBar, 0, 0)
		else
			local previous = _G["OverrideActionBarButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
		end
	end
	
	for i = 1, NUM_PET_ACTION_SLOTS do
		button = _G["PetActionButton"..i]
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", SunUIPetBar, 0, 0)
		else
			local previous = _G["PetActionButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
		end
	end
	
	for i=1, NUM_STANCE_SLOTS do
		local button = _G["StanceButton"..i]
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", SunUIStanceBar, 0,0)
		else
			local previous = _G["StanceButton"..i-1]      
			button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
		end
    end
	
	for i=1, NUM_POSSESS_SLOTS do
		local button = _G["PossessButton"..i]
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", SunUIStanceBar, 0, 0)
		else
			local previous = _G["PossessButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
		end
	end
end

function AB:Initialize()
	self:blizzHider()
	self:CreateBar1()
	self:CreateBar2()
	self:CreateBar3()
	self:CreateBar4()
	self:CreateBar5()
	self:CreateExtrabarBar()
	self:CreateOverrideBar()
	self:CreatePetBar()
	self:CreateStanceBar()
	self:CreateExitVehicle()
	
	self:UpdateAutoHide()
	self:CreateCooldown()
	self:initCooldownFlash()
	self:initStyle()
	
	self:RegisterEvent("CVAR_UPDATE", ShowGrid)
	self:RegisterEvent("LOSS_OF_CONTROL_ADDED", HideLossCD)
	self:RegisterEvent("LOSS_OF_CONTROL_UPDATE", HideLossCD)
	self:RegisterEvent("ADDON_LOADED")
	
	ShowGrid(nil, "ALWAYS_SHOW_MULTIBARS_TEXT", nil)
	
end

S:RegisterModule(AB:GetName())