local S, C, L, DB = unpack(SunUI)
 
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Petbar", "AceEvent-3.0")
function Module:OnInitialize()
	C = C["ActionBarDB"]
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