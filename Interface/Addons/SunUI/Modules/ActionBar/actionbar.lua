local S, L, DB, _, C = unpack(select(2, ...))
local _G = _G
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("actionbar", "AceEvent-3.0", "AceHook-3.0")
local LibActionButton = LibStub and LibStub("LibActionButton-1.0", true)
local activeButtons = LibActionButton and LibActionButton.activeButtons or ActionBarActionEventsFrame.frames
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local buttonList = {}
local bigButton = {}
local hide = ActionButton_HideGrid
function Module:blizzHider()
	local hider = CreateFrame("Frame")
	hider:Hide()

	local hideFrames = {MainMenuBar, MainMenuBarPageNumber, ActionBarDownButton, ActionBarUpButton, OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame, CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, AchievementMicroButton, QuestLogMicroButton, GuildMicroButton, PVPMicroButton, LFDMicroButton, CompanionsMicroButton, EJMicroButton, MainMenuMicroButton, HelpMicroButton, MainMenuBarBackpackButton,CharacterBag0Slot,CharacterBag1Slot,CharacterBag2Slot,CharacterBag3Slot}
	for k, frame in pairs(hideFrames) do
		frame:SetParent(hider)
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
function Module:CreateBar1()
	local bar = CreateFrame("Frame","SunUIActionBar1",UIParent, "SecureHandlerStateTemplate")
	if C["Bar1Layout"] == 2 then
		bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
		bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
	else
		bar:SetWidth(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
		bar:SetHeight(C["ButtonSize"])
	end
	bar:SetScale(C["MainBarSacle"])
	MoveHandle.SunUIActionBar1 = S.MakeMove(SunUIActionBar1, "SunUIActionBar1", "bar1", C["MainBarSacle"])
	MainMenuBarArtFrame:SetParent(bar)
	MainMenuBarArtFrame:EnableMouse(false)

	for i = 1, 12 do
		local button = _G["ActionButton"..i]
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		table.insert(buttonList, button)
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["ActionButton"..i-1]
			if C["Bar1Layout"] == 2 and i == 7 then
				previous = _G["ActionButton1"]
				button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, C["ButtonSpacing"])
			else
				button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
			end
		end
	end
	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
end
function Module:CreateBar2()
	local bar = CreateFrame("Frame","SunUIActionBar2",UIParent, "SecureHandlerStateTemplate")
	if C["Bar2Layout"] == 2 then
		bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
		bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
	else  
		bar:SetWidth(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
		bar:SetHeight(C["ButtonSize"])
	end
	bar:SetScale(C["MainBarSacle"])
	MoveHandle.SunUIActionBar2 = S.MakeMove(bar, "SunUIActionBar2", "bar2", C["MainBarSacle"])


	--move the buttons into position and reparent them
	MultiBarBottomLeft:SetParent(bar)
	MultiBarBottomLeft:EnableMouse(false)

	for i=1, 12 do
		local button = _G["MultiBarBottomLeftButton"..i]
		table.insert(buttonList, button)
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["MultiBarBottomLeftButton"..i-1]      
			if C["Bar2Layout"] == 2 and i == 7 then
				previous = _G["MultiBarBottomLeftButton1"]
				button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, C["ButtonSpacing"])
			else
				button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
			end
		end
	end
	--show/hide the frame on a given state driver
	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
end
function Module:CreateBar3()
	local bar = CreateFrame("Frame","SunUIActionBar3",UIParent, "SecureHandlerStateTemplate")
	local bar2 = CreateFrame("Frame","SunUIActionBar3_2",UIParent, "SecureHandlerStateTemplate")
	if C["Bar3Layout"] == 1 then
		bar:SetWidth(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
		bar:SetHeight(C["ButtonSize"])
	else
		bar:SetWidth(C["ButtonSize"]*3+C["ButtonSpacing"]*2)
		bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
		bar2:SetWidth(C["ButtonSize"]*3+C["ButtonSpacing"]*2)
		bar2:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
		bar2:SetScale(C["MainBarSacle"])
	end
	bar:SetScale(C["MainBarSacle"])
	bar2:SetScale(C["MainBarSacle"])
	if C["Bar3Layout"] == 1 then
		MoveHandle.SunUIActionBar3 = S.MakeMove(bar, "SunUIActionBar3", "bar3", C["MainBarSacle"])
	else
		MoveHandle.SunUIActionBar3 = S.MakeMove(bar, "SunUIActionBar3", "bar3", C["MainBarSacle"])
		MoveHandle.SunUIActionBar32 = S.MakeMove(bar2, "SunUIActionBar3", "bar32", C["MainBarSacle"])
	end


	MultiBarBottomRight:SetParent(bar)
	MultiBarBottomRight:EnableMouse(false)
	if C["Bar3Layout"] == 1 then
		for i=1, 12 do
			local button = _G["MultiBarBottomRightButton"..i]
			table.insert(buttonList, button)
			button:SetSize(C["ButtonSize"], C["ButtonSize"])
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", bar, 0,0)
			else
				local previous = _G["MultiBarBottomRightButton"..i-1]     
				button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0) 
			end
		end
		RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
	elseif C["Bar3Layout"] == 2 then
	for i = 1, 12 do
		button = _G["MultiBarBottomRightButton"..i]
		table.insert(buttonList, button)
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		if i == 1 then
				button:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
			elseif i <= 3 then
				button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -C["ButtonSpacing"], 0)
			elseif i == 4 then
				button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton1"], "TOPLEFT", 0, C["ButtonSpacing"])
			elseif i <= 6 then
				button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -C["ButtonSpacing"], 0)	
			elseif i == 7 then
				button:SetPoint("BOTTOMLEFT", bar2, "BOTTOMLEFT", 0, 0)
			elseif i <= 9 then
				button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", C["ButtonSpacing"], 0)
			elseif i == 10 then
				button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton7"], "TOPLEFT", 0, C["ButtonSpacing"])
			elseif i <= 12 then
				button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", C["ButtonSpacing"], 0)	
			end
		end
		RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
		RegisterStateDriver(bar2, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
	end
end
function Module:CreateBar4()
	local bar = CreateFrame("Frame","SunUIActionBar4",UIParent, "SecureHandlerStateTemplate")
	if C["Bar4Layout"] == 2 then
		bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
		bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
	else  
		bar:SetWidth(C["ButtonSize"])
		bar:SetHeight(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
	end
	bar:SetScale(C["MainBarSacle"])
	bar:SetHitRectInsets(-10, -10, -10, -10)
	MoveHandle.SunUIActionBar4 = S.MakeMove(bar, "SunUIActionBar4", "bar4", C["MainBarSacle"])

	MultiBarRight:SetParent(bar)
	MultiBarRight:EnableMouse(false)

	if C["Bar4Layout"] == 1 then
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
			table.insert(buttonList, button)
			button:ClearAllPoints()
			button:SetSize(C["ButtonSize"], C["ButtonSize"])
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)
				else
					local previous = _G["MultiBarRightButton"..i-1]
					button:SetPoint("TOP", previous, "BOTTOM", 0, -C["ButtonSpacing"])
				end
		end
	elseif C["Bar4Layout"] == 2 then 
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
			table.insert(buttonList, button)
			button:ClearAllPoints()
			button:SetSize(C["ButtonSize"], C["ButtonSize"])
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)	
				else
					local previous = _G["MultiBarRightButton"..i-1]
					if  i == 7 then
					previous = _G["MultiBarRightButton1"]
					button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -C["ButtonSpacing"])
					else
					button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
					end
				end
		end
	end
	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
end
function Module:CreateBar5()
	if C["Big4Layout"] == 1 then
		local bar51 = CreateFrame("Frame","SunUIMultiBarLeft1",UIParent, "SecureHandlerStateTemplate")
		local bar52 = CreateFrame("Frame","SunUIMultiBarLeft2",UIParent, "SecureHandlerStateTemplate")
		local bar53 = CreateFrame("Frame","SunUIMultiBarLeft3",UIParent, "SecureHandlerStateTemplate")
		local bar54 = CreateFrame("Frame","SunUIMultiBarLeft4",UIParent, "SecureHandlerStateTemplate")
		bar51:SetWidth(C["BigSize1"])
		bar51:SetHeight(C["BigSize1"])
		MoveHandle.SunUIMultiBarLeft1 = S.MakeMove(bar51, "SunUIBigActionBar1", "bar51", 1)

		bar52:SetWidth(C["BigSize2"])
		bar52:SetHeight(C["BigSize2"])
		MoveHandle.SunUIMultiBarLeft2 = S.MakeMove(bar52, "SunUIBigActionBar2", "bar52", 1)

		bar53:SetWidth(C["BigSize3"])
		bar53:SetHeight(C["BigSize3"])
		MoveHandle.SunUIMultiBarLeft3 = S.MakeMove(bar53, "SunUIBigActionBar3", "bar53", 1)

		bar54:SetWidth(C["BigSize4"])
		bar54:SetHeight(C["BigSize4"])
		MoveHandle.SunUIMultiBarLeft4 = S.MakeMove(bar54, "SunUIBigActionBar4", "bar54", 1)

		MultiBarLeft:SetParent(bar51)
		MultiBarLeft:EnableMouse(false)
		for i=1, 4 do
			local button = _G["MultiBarLeftButton"..i]
			button:ClearAllPoints()
			button:SetSize(C["BigSize"..i], C["BigSize"..i])
			if i == 1 then
				button:SetAllPoints(bar51)
			elseif i == 2 then
				button:SetAllPoints(bar52)
			elseif i == 3 then
				button:SetAllPoints(bar53)
			else
				button:SetAllPoints(bar54)
			end
			if C["BigSize"..i] < 10 then
				button:ClearAllPoints()
			end
		end

		for i=5, 12 do
			local button = _G["MultiBarLeftButton"..i]
			button:ClearAllPoints()
			button:Kill()
		end
		if S.IsCoolkid() == true then 
			_G["MultiBarLeftButton1"]:ClearAllPoints()
			_G["MultiBarLeftButton2"]:ClearAllPoints()
		end
		RegisterStateDriver(bar51, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
		RegisterStateDriver(bar52, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
		RegisterStateDriver(bar53, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
		RegisterStateDriver(bar54, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
	elseif C["Big4Layout"] == 2 then
		local bar = CreateFrame("Frame","SunUIActionBar5",UIParent, "SecureHandlerStateTemplate")
		if C["Bar5Layout"] == 2 then
			bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
			bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
		else  
			bar:SetWidth(C["ButtonSize"])
			bar:SetHeight(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
		end
		bar:SetScale(C["MainBarSacle"])
		MoveHandle.SunUIActionBar5 = S.MakeMove(bar, "SunUIActionBar5", "bar5", C["MainBarSacle"])

		MultiBarLeft:SetParent(bar)
		MultiBarLeft:EnableMouse(false)
		if C["Bar5Layout"] == 1 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
				table.insert(buttonList, button)
				button:ClearAllPoints()
				button:SetSize(C["ButtonSize"], C["ButtonSize"])
					if i == 1 then
						button:SetPoint("TOPLEFT", bar, 0,0)
					else
						local previous = _G["MultiBarLeftButton"..i-1]
						button:SetPoint("TOP", previous, "BOTTOM", 0, -C["ButtonSpacing"])
					end
			end
		elseif C["Bar5Layout"] == 2 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
				table.insert(buttonList, button)
				button:ClearAllPoints()
				button:SetSize(C["ButtonSize"], C["ButtonSize"])
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)	
				else
					local previous = _G["MultiBarLeftButton"..i-1]
					if  i == 7 then
						previous = _G["MultiBarLeftButton1"]
						button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -C["ButtonSpacing"])
					else
						button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
					end
				end
			end
		end
		RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
	end
end
function Module:CreateExtrabarBar()
	local bar = CreateFrame("Frame","SunUIExtraActionBar",UIParent, "SecureHandlerStateTemplate")
	bar:SetSize(C["ButtonSize"],C["ButtonSize"])
	bar:SetScale(C["ExtraBarSacle"])
	bar:SetFrameStrata("MEDIUM")
	MoveHandle.SunUIExtraActionBar = S.MakeMove(bar, "SunUI特殊按钮", "extrabar", C["ExtraBarSacle"])

	ExtraActionBarFrame:SetParent(bar)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
	ExtraActionBarFrame.ignoreFramePositionManager = true
	ExtraActionButton1:SetSize(C["ButtonSize"],C["ButtonSize"])
	ExtraActionBarFrame:SetFrameLevel(3)
	ExtraActionButton1Cooldown:SetPoint("TOPLEFT")
	ExtraActionButton1Cooldown:SetPoint("BOTTOMRIGHT")

	ExtraActionButton1.style:SetTexture(nil)
    hooksecurefunc(ExtraActionButton1.style, "SetTexture", function(self, texture)
		if texture then
		self:SetTexture(nil)
		end
    end)
end
function Module:CreateOverrideBar()
	local num = NUM_ACTIONBAR_BUTTONS
	--create the frame to hold the buttons
	local bar = CreateFrame("Frame", "SunUI_OverrideBar", UIParent, "SecureHandlerStateTemplate")
	bar:SetWidth(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
	bar:SetHeight(C["ButtonSize"])
	bar:SetScale(C["MainBarSacle"])
	bar:SetPoint("LEFT", SunUIActionBar1, "LEFT")
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
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0, 0)
		else
			local previous = _G["OverrideActionBarButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
		end
	end
	--show/hide the frame on a given state driver
	RegisterStateDriver(bar, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
	RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
end
--[[ local function PetBarUpdate(self, event)
	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = "PetActionButton" .. i
		petActionButton = _G[buttonName]
		petActionIcon = _G[buttonName.."Icon"]
		petAutoCastableTexture = _G[buttonName.."AutoCastable"]
		petAutoCastShine = _G[buttonName.."Shine"]
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)

		if not isToken then
			petActionIcon:SetTexture(texture)
			petActionButton.tooltipName = name
		else
			petActionIcon:SetTexture(_G[texture])
			petActionButton.tooltipName = _G[name]
		end

		petActionButton.isToken = isToken
		petActionButton.tooltipSubtext = subtext

		if isActive and name ~= "PET_ACTION_FOLLOW" then
			petActionButton:SetChecked(1)
			if IsPetAttackAction(i) then
				PetActionButton_StartFlash(petActionButton)
			end
		else
			petActionButton:SetChecked(0)
			if IsPetAttackAction(i) then
				PetActionButton_StopFlash(petActionButton)
			end
		end

		if autoCastAllowed then
			petAutoCastableTexture:Show()
		else
			petAutoCastableTexture:Hide()
		end

		if autoCastEnabled then
			AutoCastShine_AutoCastStart(petAutoCastShine)
		else
			AutoCastShine_AutoCastStop(petAutoCastShine)
		end

		if texture then
			if GetPetActionSlotUsable(i) then
				SetDesaturation(petActionIcon, nil)
			else
				SetDesaturation(petActionIcon, 1)
			end
			petActionIcon:Show()
		else
			petActionIcon:Hide()
		end

		-- between level 1 and 10 on cata, we don't have any control on Pet. (I lol'ed so hard)
		-- Setting desaturation on button to true until you learn the control on class trainer.
		-- you can at least control "follow" button.
		if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
			PetActionButton_StopFlash(petActionButton)
			SetDesaturation(petActionIcon, 1)
			petActionButton:SetChecked(0)
		end
	end
end ]]
function Module:CreatePetBar()
	local num = NUM_PET_ACTION_SLOTS
    local bar = CreateFrame("Frame", "SunUIPetBar", UIParent, "SecureHandlerStateTemplate")
    bar:SetWidth(C["ButtonSize"]*num+C["ButtonSpacing"]*(num-1))
    bar:SetHeight(C["ButtonSize"])
    bar:SetScale(C["PetBarSacle"])
	PetActionBarFrame:SetParent(bar)
	PetActionBarFrame:EnableMouse(false)
    MoveHandle.SunUIPetBar = S.MakeMove(bar, "SunUI宠物条", "petbar", C["PetBarSacle"])
	local button
	
	for i = 1, num do
		button = _G["PetActionButton"..i]
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		table.insert(buttonList, button)
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0, 0)
		else
			local previous = _G["PetActionButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
		end
	end
	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; [@pet,exists] show; hide")
end
function Module:CreateStanceBar()
	local num = NUM_STANCE_SLOTS
	local num2 = NUM_POSSESS_SLOTS
    local bar = CreateFrame("Frame","SunUIStanceBar",UIParent, "SecureHandlerStateTemplate")
    bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*(6-1))
    bar:SetHeight(C["ButtonSize"])
    bar:SetScale(C["StanceBarSacle"])
    MoveHandle.SunUIStanceBar = S.MakeMove(bar, "SunUI姿态栏", "stancebar", C["StanceBarSacle"])

	StanceBarFrame:SetParent(bar)
    StanceBarFrame:EnableMouse(false)

	StanceBarFrame:ClearAllPoints()
	StanceBarFrame:SetPoint("BOTTOMLEFT",bar)
	StanceBarFrame.ignoreFramePositionManager = true

	for i=1, num do
		local button = _G["StanceButton"..i]
		table.insert(buttonList, button)
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["StanceButton"..i-1]      
			button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
		end
    end
	--POSSESS BAR

	--move the buttons into position and reparent them
	PossessBarFrame:SetParent(bar)
	PossessBarFrame:EnableMouse(false)

	for i=1, num2 do
		local button = _G["PossessButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0, 0)
		else
			local previous = _G["PossessButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
		end
	end
	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui] hide; show")
end
function Module:CreateExitVehicle()
	local bar = CreateFrame("Frame","ExitVehicle",UIParent, "SecureHandlerStateTemplate")
	bar:SetHeight(C["ButtonSize"])
	bar:SetWidth(C["ButtonSize"])
	bar:SetScale(S.Scale(1.3))
	MoveHandle.Vehicle = S.MakeMoveHandle(bar, "SunUI离开载具按钮", "vehicleexit")

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

	--the button will spawn if a vehicle exists, but no vehicle ui is in place (the vehicle ui has its own exit button)
	RegisterStateDriver(button, "visibility", "[petbattle][overridebar][vehicleui] hide; [possessbar][@vehicle,exists] show; hide")
	--frame is visibile when no vehicle ui is visible
	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui] hide; show")
end

function Module:UpdateBigButtonSize()
	for i=1, 4 do
		local button = _G["MultiBarLeftButton"..i]
		button:SetSize(C["BigSize"..i], C["BigSize"..i])
		_G["SunUIMultiBarLeft"..i]:SetSize(C["BigSize"..i], C["BigSize"..i])
		if i == 1 then
			button:SetAllPoints(SunUIMultiBarLeft1)
		elseif i == 2 then
			button:SetAllPoints(SunUIMultiBarLeft2)
		elseif i == 3 then
			button:SetAllPoints(SunUIMultiBarLeft3)
		else
			button:SetAllPoints(SunUIMultiBarLeft4)
		end
	end
end
function Module:UpdateSize(val)
	for k, v in ipairs(buttonList) do 
		if v then 
			v:SetSize(val, val)
		end
	end
end
local function ShowGrid(event, str, value)
	if str ~= "ALWAYS_SHOW_MULTIBARS_TEXT" then return end
	if GetCVar("alwaysShowActionBars") == "1" then 
		SetActionBarToggles(1, 1, 1, 1, 0)
		ActionButton_HideGrid = DB.dummy
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
		ActionButton_HideGrid = hide
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

function Module:UpdateMainScale()
	local mainscale = {
		SunUIActionBar1,
		SunUIActionBar2,
		SunUIActionBar3,
		SunUIActionBar3_2,
		SunUIActionBar4,
		SunUIActionBar5,
		SunUI_OverrideBar,
	}
	for k, v in pairs(mainscale) do 
		if v then 
			v:SetScale(C["MainBarSacle"])
		end
	end
end
function Module:UpdateSpace()
	for i = 1, 12 do
		local button = _G["ActionButton"..i]
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", SunUIActionBar1, 0,0)
		else
			local previous = _G["ActionButton"..i-1]
			if C["Bar1Layout"] == 2 and i == 7 then
				previous = _G["ActionButton1"]
				button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, C["ButtonSpacing"])
			else
				button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
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
			if C["Bar2Layout"] == 2 and i == 7 then
				previous = _G["MultiBarBottomLeftButton1"]
				button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, C["ButtonSpacing"])
			else
				button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
			end
		end
	end
		
	if C["Bar3Layout"] == 1 then
		for i=1, 12 do
			local button = _G["MultiBarBottomRightButton"..i]
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", SunUIActionBar3, 0,0)
			else
				local previous = _G["MultiBarBottomRightButton"..i-1]     
				button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0) 
			end
		end
	elseif C["Bar3Layout"] == 2 then
		for i = 1, 12 do
		button = _G["MultiBarBottomRightButton"..i]
		button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("BOTTOMRIGHT", SunUIActionBar3, "BOTTOMRIGHT", 0, 0)
			elseif i <= 3 then
				button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -C["ButtonSpacing"], 0)
			elseif i == 4 then
				button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton1"], "TOPLEFT", 0, C["ButtonSpacing"])
			elseif i <= 6 then
				button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -C["ButtonSpacing"], 0)	
			elseif i == 7 then
				button:SetPoint("BOTTOMLEFT", SunUIActionBar3_2, "BOTTOMLEFT", 0, 0)
			elseif i <= 9 then
				button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", C["ButtonSpacing"], 0)
			elseif i == 10 then
				button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton7"], "TOPLEFT", 0, C["ButtonSpacing"])
			elseif i <= 12 then
				button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", C["ButtonSpacing"], 0)	
			end
		end
	end
		
	if C["Bar4Layout"] == 1 then
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
			button:ClearAllPoints()
				if i == 1 then
					button:SetPoint("TOPLEFT", SunUIActionBar4, 0,0)
				else
					local previous = _G["MultiBarRightButton"..i-1]
					button:SetPoint("TOP", previous, "BOTTOM", 0, -C["ButtonSpacing"])
				end
		end
	elseif C["Bar4Layout"] == 2 then 
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
			button:ClearAllPoints()
				if i == 1 then
					button:SetPoint("TOPLEFT", SunUIActionBar4, 0,0)	
				else
					local previous = _G["MultiBarRightButton"..i-1]
					if  i == 7 then
					previous = _G["MultiBarRightButton1"]
					button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -C["ButtonSpacing"])
					else
					button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
					end
				end
		end
	end
	
	if C["Big4Layout"] == 2 then
		if C["Bar5Layout"] == 1 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
				button:ClearAllPoints()
					if i == 1 then
						button:SetPoint("TOPLEFT", bar, 0,0)
					else
						local previous = _G["MultiBarLeftButton"..i-1]
						button:SetPoint("TOP", previous, "BOTTOM", 0, -C["ButtonSpacing"])
					end
			end
		elseif C["Bar5Layout"] == 2 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
				button:ClearAllPoints()
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)	
				else
					local previous = _G["MultiBarLeftButton"..i-1]
					if  i == 7 then
						previous = _G["MultiBarLeftButton1"]
						button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -C["ButtonSpacing"])
					else
						button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
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
			button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
		end
	end
	
	for i = 1, NUM_PET_ACTION_SLOTS do
		button = _G["PetActionButton"..i]
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", SunUIPetBar, 0, 0)
		else
			local previous = _G["PetActionButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
		end
	end
	
	for i=1, NUM_STANCE_SLOTS do
		local button = _G["StanceButton"..i]
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", SunUIStanceBar, 0,0)
		else
			local previous = _G["StanceButton"..i-1]      
			button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
		end
    end
	
	for i=1, NUM_POSSESS_SLOTS do
		local button = _G["PossessButton"..i]
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", SunUIStanceBar, 0, 0)
		else
			local previous = _G["PossessButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
		end
	end
end
function Module:OnInitialize()
	if (IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("Macaroon")) then
		return 
	end
	C = SunUIConfig.db.profile.ActionBarDB
	Module:RegisterEvent("CVAR_UPDATE", ShowGrid)
	Module:RegisterEvent("LOSS_OF_CONTROL_ADDED", HideLossCD)
	Module:RegisterEvent("LOSS_OF_CONTROL_UPDATE", HideLossCD)
	
	Module:blizzHider()
	Module:CreateBar1()
	Module:CreateBar2()
	Module:CreateBar3()
	Module:CreateBar4()
	Module:CreateBar5()
	Module:CreateExtrabarBar()
	Module:CreateOverrideBar()
	Module:CreatePetBar()
	Module:CreateStanceBar()
	Module:CreateExitVehicle()
	if S.IsCoolkid() then  ShowGrid(nil, "ALWAYS_SHOW_MULTIBARS_TEXT", nil) end
end