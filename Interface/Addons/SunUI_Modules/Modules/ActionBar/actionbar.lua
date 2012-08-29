local S, C, L, DB = unpack(SunUI)

if (IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("Macaroon")) then
	return 
end

local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("actionbar", "AceEvent-3.0")
local buttonList = {}
function Module:blizzHider()
	local blizzHider = CreateFrame("Frame","SunUI_BizzardHider")
	blizzHider:Hide()
	--hide main menu bar frames  
	
    CharacterMicroButton:Hide()
    SpellbookMicroButton:Hide()
    TalentMicroButton:Hide()
    AchievementMicroButton:Hide()
    QuestLogMicroButton:Hide()
    GuildMicroButton:Hide()
    PVPMicroButton:Hide()
    LFDMicroButton:Hide()
    CompanionsMicroButton:Hide()
    EJMicroButton:Hide()
    MainMenuMicroButton:Hide()
    HelpMicroButton:Hide()
	MainMenuBarBackpackButton:Hide()
	CharacterBag0Slot:Hide()
	CharacterBag1Slot:Hide()
	CharacterBag2Slot:Hide()
	CharacterBag3Slot:Hide()
	MainMenuBar:SetParent(blizzHider)
	MainMenuBarPageNumber:SetParent(blizzHider)
	ActionBarDownButton:SetParent(blizzHider)
	ActionBarUpButton:SetParent(blizzHider)
	CharacterMicroButton:ClearAllPoints();
	--hide override actionbar frames

	OverrideActionBarExpBar:SetParent(blizzHider)
	OverrideActionBarHealthBar:SetParent(blizzHider)
	OverrideActionBarPowerBar:SetParent(blizzHider)
	OverrideActionBarPitchFrame:SetParent(blizzHider) --maybe we can use that frame later for pitchig and such

	StanceBarLeft:SetTexture(nil)
	StanceBarMiddle:SetTexture(nil)
	StanceBarRight:SetTexture(nil)
	SlidingActionBarTexture0:SetTexture(nil)
	SlidingActionBarTexture1:SetTexture(nil)
	PossessBackground1:SetTexture(nil)
	PossessBackground2:SetTexture(nil)
	
	MainMenuBarTexture0:SetTexture(nil)
	MainMenuBarTexture1:SetTexture(nil)
	MainMenuBarTexture2:SetTexture(nil)
	MainMenuBarTexture3:SetTexture(nil)
	MainMenuBarLeftEndCap:SetTexture(nil)
	MainMenuBarRightEndCap:SetTexture(nil)

	  --remove OverrideBar textures
	  
	local textureList =  {
		"_BG","EndCapL","EndCapR","_Border","Divider1","Divider2", "Divider3","ExitBG","MicroBGL","MicroBGR","_MicroBGMid", "ButtonBGL", "ButtonBGR","_ButtonBGMid",}

	for _,tex in pairs(textureList) do
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
	
	--move the buttons into position and reparent them
	MainMenuBarArtFrame:SetParent(bar)
	MainMenuBarArtFrame:EnableMouse(false)
	
	for i = 1, 12 do
		local button = _G["ActionButton"..i]
		table.insert(buttonList, button)
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
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
	--show/hide the frame on a given state driver
	RegisterStateDriver(bar, "visibility", "[petbattle] hide; [vehicleui] hide; show")
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
	RegisterStateDriver(bar, "visibility", "[petbattle] hide; [vehicleui] hide;show")
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
		RegisterStateDriver(bar, "visibility", "[petbattle] hide; [vehicleui] hide; show")
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
		RegisterStateDriver(bar, "visibility", "[petbattle] hide; [vehicleui] hide; show")
		RegisterStateDriver(bar2, "visibility", "[petbattle] hide; [vehicleui] hide; show")
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
	RegisterStateDriver(bar, "visibility", "[petbattle] hide; [vehicleui] hide; show")
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
		end
		  
		for i=5, 12 do
			local button = _G["MultiBarLeftButton"..i]
			button:ClearAllPoints()
		end
		local players = {
			["Coolkid"] = true,
			["Coolkids"] = true,
			["Kenans"] = true,
			["月殤軒"] = true,
			["月殤玄"] = true,
			["月殤妶"] = true,
			["月殤玹"] = true,
			["月殤璇"] = true,
			["月殤旋"] = true,
		}
		if players[DB.PlayerName] == true then 
			_G["MultiBarLeftButton1"]:ClearAllPoints()
			_G["MultiBarLeftButton2"]:ClearAllPoints()
		end
		RegisterStateDriver(bar51, "visibility", "[petbattle] hide; [vehicleui] hide; show")
		RegisterStateDriver(bar52, "visibility", "[petbattle] hide; [vehicleui] hide; show")
		RegisterStateDriver(bar53, "visibility", "[petbattle] hide; [vehicleui] hide; show")
		RegisterStateDriver(bar54, "visibility", "[petbattle] hide; [vehicleui] hide; show")
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
		RegisterStateDriver(bar5, "visibility", "[petbattle] hide; [vehicleui] hide; show")
	end
end
function Module:CreateExtrabarBar()
	local bar = CreateFrame("Frame","SunUIExtraActionBar",UIParent, "SecureHandlerStateTemplate")
	bar:SetSize(C["ButtonSize"],C["ButtonSize"])
	bar:SetScale(C["ExtraBarSacle"])
	MoveHandle.SunUIExtraActionBar = S.MakeMove(bar, "SunUI特殊按钮", "extrabar", C["ExtraBarSacle"])
	
	ExtraActionBarFrame:SetParent(bar)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
	ExtraActionBarFrame.ignoreFramePositionManager = true
	
	ExtraActionButton1Cooldown:SetPoint("TOPLEFT")
	ExtraActionButton1Cooldown:SetPoint("BOTTOMRIGHT")
	
	local button = ExtraActionButton1
	local texture = button.style
	local disableTexture = function(style, texture)
		if texture and string.sub(texture,1,9) == "Interface" then
			style:SetTexture("")
		end
	end
	button.style:SetTexture("")
	hooksecurefunc(texture, "SetTexture", disableTexture)
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
	RegisterStateDriver(bar, "visibility", "[petbattle] hide; [vehicleui] show; hide")
	RegisterStateDriver(OverrideActionBar, "visibility", "[vehicleui] show; hide")
end
function Module:CreatePetBar()
    local num = NUM_PET_ACTION_SLOTS
    local bar = CreateFrame("Frame","SunUIPetBar",UIParent, "SecureHandlerStateTemplate")
    bar:SetWidth(C["ButtonSize"]*num+C["ButtonSpacing"]*(num-1))
    bar:SetHeight(C["ButtonSize"])
    bar:SetHitRectInsets(-10, -10, -10, -10)
    bar:SetScale(C["PetBarSacle"])
  
    MoveHandle.SunUIPetBar = S.MakeMove(bar, "SunUI宠物条", "petbar", C["PetBarSacle"])

    PetActionBarFrame:SetParent(bar)
    PetActionBarFrame:EnableMouse(false)

	for i=1, num do
		local button = _G["PetActionButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["PetActionButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
		end
		--cooldown fix
		local cd = _G["PetActionButton"..i.."Cooldown"]
		cd:SetAllPoints(button)
	end
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
	PossessBarFrame:SetParent(frame)
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
	RegisterStateDriver(bar, "visibility", "[petbattle] hide; [vehicleui] hide; show")
end
function Module:CreateExitVehicle()
	local bar = CreateFrame("Frame","ExitVehicle",UIParent, "SecureHandlerStateTemplate")
	bar:SetHeight(C["ButtonSize"])
	bar:SetWidth(C["ButtonSize"])
	bar:SetScale(S.Scale(2))
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
	RegisterStateDriver(button, "visibility", "[petbattle] hide; [vehicleui] hide; [@vehicle,exists] show; hide")
	--frame is visibile when no vehicle ui is visible
	RegisterStateDriver(bar, "visibility", "[petbattle] hide; [vehicleui] hide; show")
end
function Module:UpdateSize()
	for _, v in ipairs(buttonList) do 
		v:SetSize(C["ButtonSize"], C["ButtonSize"])
	end
end
function Module:OnInitialize()
	C = C["ActionBarDB"]
end
function Module:OnEnable()
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
end