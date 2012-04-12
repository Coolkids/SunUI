local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("ActionBar", "AceEvent-3.0")

function Module:UpdateBar1()
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
	bar:SetHitRectInsets(-10, -10, -10, -10)

	local Page = {
		["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
		["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
		["PRIEST"] = "[bonusbar:1] 7;",
		["ROGUE"] = "[bonusbar:1] 7; [form:3] 10;",
		["WARLOCK"] = "[form:2] 7;",
		["DEFAULT"] = "[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
	}

	local function GetBar()
    local condition = Page["DEFAULT"]
    local class = DB.MyClass
    local page = Page[class]
    if page then
		condition = condition.." "..page
    end
		condition = condition.." 1"
    return condition
	end

	bar:RegisterEvent("PLAYER_LOGIN")
	bar:RegisterEvent("PLAYER_ENTERING_WORLD")
	bar:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
	bar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	bar:RegisterEvent("BAG_UPDATE")
	bar:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_LOGIN" then
			local button, buttons
		 for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G["ActionButton"..i]
			self:SetFrameRef("ActionButton"..i, button)
		end
		  self:Execute([[
			buttons = table.new()
			for i = 1, 12 do
			  table.insert(buttons, self:GetFrameRef("ActionButton"..i))
			end
		  ]])

		  self:SetAttribute("_onstate-page", [[
			for i, button in ipairs(buttons) do
			  button:SetAttribute("actionpage", tonumber(newstate))
			end
		  ]])

		  RegisterStateDriver(self, "page", GetBar())
		elseif event == "PLAYER_ENTERING_WORLD" then
			local button
			for i = 1, 12 do
				button = _G["ActionButton"..i]
				button:SetSize(C["ButtonSize"], C["ButtonSize"])
				button:ClearAllPoints()
				button:SetParent(self)
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
		else
			MainMenuBar_OnEvent(self, event, ...)
		end
	end)
end
 
function Module:UpdateBar2()
	local bar = CreateFrame("Frame","SunUIActionBar2",UIParent, "SecureHandlerStateTemplate")
	if C["Bar2Layout"] == 2 then
		bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
		bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
	else  
		bar:SetWidth(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
		bar:SetHeight(C["ButtonSize"])
	end
	bar:SetScale(C["MainBarSacle"])
	if C["Bar2Layout"] == 2 then
		MoveHandle.SunUIActionBar2 = S.MakeMove(bar, "SunUIActionBar2", "bar2", C["MainBarSacle"])
	else 
		MoveHandle.SunUIActionBar2 = S.MakeMove(bar, "SunUIActionBar2", "bar2", C["MainBarSacle"])
	end
	bar:SetHitRectInsets(-10, -10, -10, -10)

	MultiBarBottomLeft:SetParent(bar)
	for i=1, 12 do
		local button = _G["MultiBarBottomLeftButton"..i]
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
end 

function Module:UpdateBar3()
	local bar = CreateFrame("Frame","SunUIActionBar3",UIParent, "SecureHandlerStateTemplate")
	local bar2 = CreateFrame("Frame","SunUIActionBar32",UIParent, "SecureHandlerStateTemplate")
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
	bar:SetHitRectInsets(-10, -10, -10, -10)

	MultiBarBottomRight:SetParent(bar)
	if C["Bar3Layout"] == 1 then
		for i=1, 12 do
			local button = _G["MultiBarBottomRightButton"..i]
			button:SetSize(C["ButtonSize"], C["ButtonSize"])
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", bar, 0,0)
			else
				local previous = _G["MultiBarBottomRightButton"..i-1]     
				button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0) 
			end
		end
	end
	if C["Bar3Layout"] == 2 then
	for i = 1, 12 do
		Button = _G["MultiBarBottomRightButton"..i]
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		Button:ClearAllPoints()
		if i == 1 then
				Button:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
			elseif i <= 3 then
				Button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -C["ButtonSpacing"], 0)
			elseif i == 4 then
				Button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton1"], "TOPLEFT", 0, C["ButtonSpacing"])
			elseif i <= 6 then
				Button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -C["ButtonSpacing"], 0)	
			elseif i == 7 then
				Button:SetPoint("BOTTOMLEFT", bar2, "BOTTOMLEFT", 0, 0)
			elseif i <= 9 then
				Button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", C["ButtonSpacing"], 0)
			elseif i == 10 then
				Button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton7"], "TOPLEFT", 0, C["ButtonSpacing"])
			elseif i <= 12 then
				Button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", C["ButtonSpacing"], 0)	
			end
		end
	end
end 

function Module:UpdateBar4()
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

	if C["Bar4Layout"] == 1 then
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
			button:ClearAllPoints()
			button:SetSize(C["ButtonSize"], C["ButtonSize"])
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)
				else
					local previous = _G["MultiBarRightButton"..i-1]
					button:SetPoint("TOP", previous, "BOTTOM", 0, -C["ButtonSpacing"])
				end
		end
	end 
	if C["Bar4Layout"] == 2 then 
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
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
end

function Module:UpdateBar5()
	if C["Big4Layout"] == 1 then
		local bar51 = CreateFrame("Frame","SunUIMultiBarLeft1",UIParent, "SecureHandlerStateTemplate")
		local bar52 = CreateFrame("Frame","SunUIMultiBarLeft2",UIParent, "SecureHandlerStateTemplate")
		local bar53 = CreateFrame("Frame","SunUIMultiBarLeft3",UIParent, "SecureHandlerStateTemplate")
		local bar54 = CreateFrame("Frame","SunUIMultiBarLeft4",UIParent, "SecureHandlerStateTemplate")
		bar51:SetWidth(C["BigSize1"])
		bar51:SetHeight(C["BigSize1"])
		bar51:SetHitRectInsets(-10, -10, -10, -10)
		MoveHandle.SunUIMultiBarLeft1 = S.MakeMove(bar51, "SunUIBigActionBar1", "bar51", 1)
			
		bar52:SetWidth(C["BigSize2"])
		bar52:SetHeight(C["BigSize2"])
		bar52:SetHitRectInsets(-10, -10, -10, -10)
		MoveHandle.SunUIMultiBarLeft2 = S.MakeMove(bar52, "SunUIBigActionBar2", "bar52", 1)
			
		bar53:SetWidth(C["BigSize3"])
		bar53:SetHeight(C["BigSize3"])
		bar53:SetHitRectInsets(-10, -10, -10, -10)
		MoveHandle.SunUIMultiBarLeft3 = S.MakeMove(bar53, "SunUIBigActionBar3", "bar53", 1)
			
		bar54:SetWidth(C["BigSize4"])
		bar54:SetHeight(C["BigSize4"])
		bar54:SetHitRectInsets(-10, -10, -10, -10)
		MoveHandle.SunUIMultiBarLeft4 = S.MakeMove(bar54, "SunUIBigActionBar4", "bar54", 1)

		MultiBarLeft:SetParent(bar51)
		for i=1, 2 do
			local button = _G["MultiBarLeftButton"..i]
			button:ClearAllPoints()
			button:SetSize(C["BigSize"..i], C["BigSize"..i])
			if i == 1 then
				button:SetAllPoints(bar51)
			else
				button:SetAllPoints(bar52)
			end
		end
		  
		for i=3, 10 do
			local button = _G["MultiBarLeftButton"..i]
			button:ClearAllPoints()
		 end
		  
		for i=11, 12 do
			local button = _G["MultiBarLeftButton"..i]
			button:ClearAllPoints()
			local b = 0
			b = i - 8
			button:SetSize(C["BigSize"..b], C["BigSize"..b])
			if i == 11 then
				button:SetAllPoints(bar53)
			else
				button:SetAllPoints(bar54)
			end
		end
	elseif C["Big4Layout"] == 2 then
	
		local bar = CreateFrame("Frame","SunUIActionBar5",UIParent, "SecureHandlerStateTemplate")
		if C["Bar5Layout"] == 2 then
			bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
			bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
		else  
			bar:SetWidth(C["ButtonSize"])
			bar:SetHeight(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
		end
		MoveHandle.SunUIActionBar5 = S.MakeMove(bar, "SunUIActionBar5", "bar5", C["MainBarSacle"])
		bar:SetHitRectInsets(-10, -10, -10, -10)
  
		bar:SetScale(C["MainBarSacle"])

		MultiBarLeft:SetParent(bar)
		if C["Bar5Layout"] == 1 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
				button:ClearAllPoints()
				button:SetSize(C["ButtonSize"], C["ButtonSize"])
					if i == 1 then
						button:SetPoint("TOPLEFT", bar, 0,0)
					else
						local previous = _G["MultiBarLeftButton"..i-1]
						button:SetPoint("TOP", previous, "BOTTOM", 0, -C["ButtonSpacing"])
					end
			end
		end
		if C["Bar5Layout"] == 2 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
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
	end
end

function Module:UpdateExtraBar()
	local bar = CreateFrame("Frame","SunUIExtraActionBar",UIParent,"SecureHandlerStateTemplate")
	bar:SetSize(C["ButtonSize"],C["ButtonSize"])
	bar:SetHitRectInsets(-10, -10, -10, -10)
	bar:SetScale(C["ExtraBarSacle"])
 
	MoveHandle.SunUIExtraActionBar = S.MakeMove(bar, "SunUI特殊按钮", "extrabar", C["ExtraBarSacle"])

  --the frame
	local f = ExtraActionBarFrame
	f:SetParent(bar)
	f:ClearAllPoints()
	f:SetPoint("CENTER", 0, 0)
	f.ignoreFramePositionManager = true

  --the button
	local b = ExtraActionButton1
	--b:SetSize(C["ButtonSize"],C["ButtonSize"])
	--b:SetScale(C["ExtraBarSacle"])   --新?
	bar.button = b
	ExtraActionButton1Cooldown:SetPoint("TOPLEFT")
	ExtraActionButton1Cooldown:SetPoint("BOTTOMRIGHT")
  --style texture
	local s = b.style
	s:SetTexture(nil)
	local disableTexture = function(style, texture)
    if not texture then return end
    if string.sub(texture,1,9) == "Interface" then
		style:SetTexture(nil) --bzzzzzzzz
    end
	end
	hooksecurefunc(s, "SetTexture", disableTexture)

  --register the event, make sure the damn button shows up
	bar:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
	bar:RegisterEvent("PLAYER_REGEN_ENABLED")
	bar:SetScript("OnEvent", function(self, event, ...)
		if (HasExtraActionBar()) then
			self:Show()
			self.button:Show()
		else
			self:Hide()
		end
	end)
end

function Module:UpdatePetBar()
    local num = NUM_PET_ACTION_SLOTS
    local bar = CreateFrame("Frame","SunUIPetBar",UIParent, "SecureHandlerStateTemplate")
    bar:SetWidth(C["ButtonSize"]*num+C["ButtonSpacing"]*(num-1))
    bar:SetHeight(C["ButtonSize"])
    bar:SetHitRectInsets(-10, -10, -10, -10)
    bar:SetScale(C["PetBarSacle"])
  
    MoveHandle.SunUIPetBar = S.MakeMove(bar, "SunUI宠物条", "petbar", C["PetBarSacle"])

    PetActionBarFrame:SetParent(bar)
    PetActionBarFrame:EnableMouse(false)
	PetBarUpdate = function(self, event)
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
			
			-- grid display
			if name then
				petActionButton:SetAlpha(1)
			else
				petActionButton:SetAlpha(0)
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
			
			if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
				PetActionButton_StopFlash(petActionButton)
				SetDesaturation(petActionIcon, 1)
				petActionButton:SetChecked(0)
			end
		end
	end	
	bar:RegisterEvent("PLAYER_LOGIN")
	bar:RegisterEvent("PLAYER_CONTROL_LOST")
	bar:RegisterEvent("PLAYER_CONTROL_GAINED")
	bar:RegisterEvent("PLAYER_ENTERING_WORLD")
	bar:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
	bar:RegisterEvent("PET_BAR_UPDATE")
	bar:RegisterEvent("PET_BAR_UPDATE_USABLE")
	bar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
	bar:RegisterEvent("PET_BAR_HIDE")
	bar:RegisterEvent("UNIT_PET")
	bar:RegisterEvent("UNIT_FLAGS")
	bar:RegisterEvent("UNIT_AURA")
	bar:SetScript("OnEvent", function(self, event, arg1)
		if event == "PLAYER_LOGIN" then	
		PetActionBarFrame.showgrid = 1
			local button		
			for i = 1, 10 do
				button = _G["PetActionButton"..i]
				button:ClearAllPoints()
				button:SetParent(bar)
				button:SetSize(C["ButtonSize"], C["ButtonSize"])
				if i == 1 then
					button:SetPoint("BOTTOMLEFT", bar, 0,0)
				else
					button:SetPoint("LEFT", _G["PetActionButton"..(i - 1)], "RIGHT", C["ButtonSpacing"], 0)
				end
				button:Show()
				self:SetAttribute("addchild", button)	
			end
			if DB.MyClass == "HUNTER" or DB.MyClass == "WARLOCK" then
				RegisterStateDriver(self, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
			end
			hooksecurefunc("PetActionBar_Update", PetBarUpdate)
		elseif event == "PET_BAR_UPDATE" or event == "UNIT_PET" and arg1 == "player" 
			or event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED" or event == "UNIT_FLAGS"
			or arg1 == "pet" and (event == "UNIT_AURA") then
				PetBarUpdate()
		elseif event == "PET_BAR_UPDATE_COOLDOWN" then
			PetActionBar_UpdateCooldowns()
		end
	end)
end 

function Module:UpdateStanceBar()
    local num = NUM_SHAPESHIFT_SLOTS
    local bar = CreateFrame("Frame","SunUIStanceBar",UIParent, "SecureHandlerStateTemplate")
    bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*(6-1))
    bar:SetHeight(C["ButtonSize"])
    bar:SetHitRectInsets(-10, -10, -10, -10)
    bar:SetScale(C["StanceBarSacle"])
    MoveHandle.SunUIStanceBar = S.MakeMove(bar, "SunUI姿态栏", "stancebar", C["StanceBarSacle"])

    ShapeshiftBarFrame:SetParent(bar)
    ShapeshiftBarFrame:EnableMouse(false)
    
    for i=1, num do
		local button = _G["ShapeshiftButton"..i]
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["ShapeshiftButton"..i-1]      
			button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
		end
    end
    
    local function MoveShapeshift()
		ShapeshiftButton1:SetPoint("BOTTOMLEFT", bar, 0,0)
    end
    hooksecurefunc("ShapeshiftBar_Update", MoveShapeshift);
end 

function Module:UpdateTotemBar()
    local f = _G['MultiCastActionBarFrame']
    local bar = CreateFrame("Frame","SunUITotemBar",UIParent,"SecureHandlerStateTemplate")
    bar:SetWidth(f:GetWidth())
    bar:SetHeight(f:GetHeight())
    bar:SetScale(C["TotemBarSacle"])
    MoveHandle.SunUITotemBar = S.MakeMove(bar, "SunUI图腾栏", "totembar", C["TotemBarSacle"])
	bar:SetHitRectInsets(-10, -10, -10, -10)
    bar:SetAttribute("_onstate-vis", [[
      if not newstate then return end
      if newstate == "show" then
        self:Show()
      elseif newstate == "hide" then
        self:Hide()
      end
    ]])
    RegisterStateDriver(bar, "vis", "[bonusbar:5][@player,dead][flying][mounted][stance]hide;show")
    f:SetParent(bar)
    f:ClearAllPoints()
    f:SetPoint("CENTER",0,0)
    f:EnableMouse(false)
    local moveTotem = function(self,a,b,c,d,e)
      if a == "CENTER" then return end
      self:ClearAllPoints()
      self:SetPoint("CENTER",0,0)
    end
    hooksecurefunc(f, "SetPoint", moveTotem)
    f.ignoreFramePositionManager = true

    local totemSlot = { 2, 1, 3, 4 }

    local function OnEvent(self, event, slot)
		if event == "PLAYER_ENTERING_WORLD" then
			slot = self.slot
		elseif slot ~= self.slot then
			return
		end
		local _, _, start, duration = GetTotemInfo(slot)
		if duration > 0 then
			self.start = start
			self.duration = duration
			self:Show()
		else
			self:Hide()
		end
    end

    local function OnHide(self)
		self.start = nil
		self.duration = nil
    end

    local function OnShow(self)
		if not self.start or not self.duration then return self:Hide() end
		self.elapsed = 1000
    end

    --format time func
    local GetFormattedTime = function(time)
		local hr, m, s, text
		if time <= 0 then text = ""
		elseif(time < 3600 and time > 60) then
			hr = floor(time / 3600)
			m = floor(mod(time, 3600) / 60 + 1)
			text = format("%dm", m)
		elseif time < 60 then
			m = floor(time / 60)
			s = mod(time, 60)
			text = (m == 0 and format("%ds", s))
		else
			hr = floor(time / 3600 + 1)
			text = format("%dh", hr)
		end
		return text
	end

    local function OnUpdate(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > 0.33 then
			local timeLeft = self.start + self.duration - GetTime()
			if timeLeft > 0 then
				self.text:SetText(GetFormattedTime(timeLeft))
				self.elapsed = 0
			else
				self.text:SetText()
				self:Hide()
			end
		end
    end

    for i = 1, #totemSlot do
		local button = _G["MultiCastActionButton"..i]
		local timerFrame = CreateFrame("Frame", nil, button)
		button.timerFrame = timerFrame
		timerFrame:SetAllPoints(button)
		timerFrame:Hide()
		timerFrame.text = timerFrame:CreateFontString(nil, "OVERLAY")
		timerFrame.text:SetPoint("CENTER", 0, 0)
		timerFrame.text:SetFont(STANDARD_TEXT_FONT, button:GetWidth()*16/36, "THINOUTLINE")
		timerFrame.text:SetShadowOffset(1,-2)
		timerFrame.text:SetShadowColor(0,0,0,0.6)
		timerFrame.text:SetJustifyH("CENTER")
		timerFrame.id = i
		timerFrame.slot = totemSlot[i]
		timerFrame:SetScript("OnEvent", OnEvent)
		timerFrame:SetScript("OnHide", OnHide)
		timerFrame:SetScript("OnShow", OnShow)
		timerFrame:SetScript("OnUpdate", OnUpdate)
		timerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		timerFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
		OnEvent(timerFrame, "PLAYER_TOTEM_UPDATE", timerFrame.slot)
    end

    --TOTEM DESTROYER

    local destroyers = { }
    local totemSlot  = { 2, 1, 3, 4 }
    local backdrop   = { bgFile = "Interface\\BUTTONS\\WHITE8X8", tile = false }

    local function Button_OnClick(self, button)
		DestroyTotem(self.slot)
    end

    local function Button_OnEvent(self, event, key)
		if key ~= "LSHIFT" and key ~= "RSHIFT" then return end

		local _, _, start, duration = GetTotemInfo(self.slot)

		if IsShiftKeyDown() and duration > 0 then
			self:Show()
			self:SetAlpha(ImprovedTotemFrameDB and ImprovedTotemFrameDB.dA or 0.5)
		else
			self:Hide()
		end
    end

    for i = 1, #totemSlot do
		local mcab = _G["MultiCastActionButton" .. i]

		local b = CreateFrame("Button", nil, UIParent)
		b:SetFrameStrata(mcab:GetFrameStrata())
		b:SetFrameLevel(mcab:GetFrameLevel() + 3)
		b:SetPoint("TOPLEFT", mcab, -1, 1)
		b:SetPoint("BOTTOMRIGHT", mcab, 1, -1)

		b:CreateShadow()

		b:Hide()
		b:RegisterEvent("MODIFIER_STATE_CHANGED")
		b:SetScript("OnEvent", Button_OnEvent)

		b:RegisterForClicks("RightButtonUp")
		b:SetScript("OnClick", Button_OnClick)

		b.id = i
		b.slot = totemSlot[i]

		destroyers[b.slot] = b
		mcab.destroyer = b
    end
end

function Module:UpdateVehicleExit()
	local bar = CreateFrame("Frame","Vehicle",UIParent, "SecureHandlerStateTemplate")
	bar:SetHeight(C["ButtonSize"])
	bar:SetWidth(C["ButtonSize"])
	bar:SetScale(S.Scale(1))
	MoveHandle.Vehicle = S.MakeMoveHandle(bar, "SunUI离开载具按钮", "vehicleexit")
	bar:SetHitRectInsets(-10, -10, -10, -10)

	local veb = CreateFrame("BUTTON", nil, bar, "SecureHandlerClickTemplate");
	veb:SetAllPoints(bar)
	veb:RegisterForClicks("AnyUp")
	veb:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
	veb:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
	veb:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
	veb:SetScript("OnClick", function(self) VehicleExit() end)
	RegisterStateDriver(veb, "visibility", "[target=vehicle,exists] show;hide")
end

function  Module:BuildActionBar()
	C = ActionBarDB
	Module:UpdateBar1()
	Module:UpdateBar2()
	Module:UpdateBar3()
	Module:UpdateBar4()
	Module:UpdateBar5()
	Module:UpdateExtraBar()
	Module:UpdatePetBar()
	Module:UpdateStanceBar()
	if DB.MyClass == "SHAMAN" then
		Module:UpdateTotemBar()
	end
	Module:UpdateVehicleExit()
end

function Module:OnInitialize()
	Module:BuildActionBar()
end