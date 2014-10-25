local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")

function IB:CreateSpecs()
	local join = string.join
	local activeString = join("", "|cff00FF00" , ACTIVE_PETS, "|r")
	local inactiveString = join("", "|cffFF0000", FACTION_INACTIVE, "|r")
	local menuList = {
		{ text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true },
		{ notCheckable = true, func = function() SetLootSpecialization(0) end },
		{ notCheckable = true },
		{ notCheckable = true },
		{ notCheckable = true },
		{ notCheckable = true }
	}
	local menuFrame = CreateFrame("Frame", "LootSpecializationDatatextClickMenu", UIParent, "UIDropDownMenuTemplate")
	
	local A = S:GetModule("Skins")
	local stat = CreateFrame("Frame", "InfoPanelBottom4", BottomInfoPanel or UIParent)
	stat:SetFrameStrata("BACKGROUND")
	stat:SetFrameLevel(3)
	stat:EnableMouse(true)

	stat.text = S:CreateFS(stat)
	stat.text:SetPoint("LEFT", InfoPanelBottom3 or InfoPanelBottom2 or InfoPanelBottom1, "RIGHT", 20, 0)
	stat:SetAllPoints(stat.text)
	
	stat.icon = stat:CreateTexture(nil, "OVERLAY")
	stat.icon:SetSize(8, 8)
	stat.icon:SetPoint("RIGHT", stat, "LEFT", -5, 0)
	stat.icon:SetTexture(IB.backdrop)
	stat.icon:SetVertexColor(unpack(IB.InfoBarStatusColor[3]))
	A:CreateShadow(stat, stat.icon)
	
	local function OnEvent(self)
		local specIndex = GetSpecialization();
		if not specIndex then stat.text:SetText(NONE..TALENTS) return; end	
		local active = GetActiveSpecGroup()
		local talent, loot = '', ''
		if GetSpecialization(false, false, active) then
			local _, name, _, icon = GetSpecializationInfo(GetSpecialization(false, false, active))
			if name and icon then
				talent = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', icon).." "..name
			end
		end
		local specialization = GetLootSpecialization()
		if specialization == 0 then
			local specIndex = GetSpecialization();
			
			if specIndex then
				local specID, name, _, texture = GetSpecializationInfo(specIndex);
				if texture and name then
					loot = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture).." "..name
				end
			else
				loot = NONE
			end
		else
			local specID, name, _, texture = GetSpecializationInfoByID(specialization);
			if specID then
				if texture and name then
					loot = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture).." "..name
				end
			else
				loot = NONE
			end
		end
		
		self.text:SetText(format('%s: %s %s: %s', TALENTS, talent, LOOT, loot))
	end

	local function Checktalentgroup(index)
		return GetSpecialization(false,false,index)
	end


	stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	stat:RegisterEvent("PLAYER_TALENT_UPDATE")
	stat:RegisterEvent("CHARACTER_POINTS_CHANGED")
	stat:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	stat:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
	
	stat:SetScript("OnEvent", OnEvent)
	stat:SetScript("OnEnter", function(self)
		if InCombatLockdown() then return end
		local c = GetActiveSpecGroup(false,false)
		local majorTree1 = GetSpecialization(false,false,1)
		local spec1 = { }
		for i = 1, 7 do
			for j = 1, 3 do
				local _, name, iconTexture, selected, available = GetTalentInfo(i, j, 1)
				iconTexture = iconTexture and "|T"..iconTexture..":14:14:0:0:64:64:4:60:4:60|t " or ""
				if selected then
					table.insert(spec1, iconTexture..name)
				end
			end
		end
		local majorTree2 = GetSpecialization(false,false,2)
		local spec2 = { }
		if majorTree2 then
			for i = 1, 7 do 
				for j = 1, 3 do
					local _, name, iconTexture, selected, available = GetTalentInfo(i, j, 2)
					iconTexture = iconTexture and "|T"..iconTexture..":14:14:0:0:64:64:4:60:4:60|t " or ""
					if selected then
						table.insert(spec2, iconTexture..name)
					end
				end
			end
		end
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(TALENTS_BUTTON,0,.6,1)
		GameTooltip:AddLine(" ")
		if GetNumSpecGroups() == 1 then
			local currentSpec = GetSpecialization()
			local currentSpecName = currentSpec and select(2, GetSpecializationInfo(majorTree1)) or NONE..TALENTS
			local _, _, _, icon = currentSpec and GetSpecializationInfo(currentSpec) or ""
			icon = icon and "|T"..icon..":14:14:0:0:64:64:4:60:4:60|t " or ""
			GameTooltip:AddLine(icon.."|cff00FF00* " ..currentSpecName.. "|r",1,1,1)
			for i = 1, #spec1 do
				GameTooltip:AddDoubleLine(" ", spec1[i],1,1,1,1,1,1)
			end
		else
			local currentSpecName = select(2, GetSpecializationInfo(majorTree1)) or NONE..TALENTS
			local _, currentSpecName, _, icon = GetSpecializationInfo(majorTree1)
			icon = icon and "|T"..icon..":14:14:0:0:64:64:4:60:4:60|t " or ""
			GameTooltip:AddLine("|cff00FF00"..(c == 1 and "* " or "   ") .. "|r" .. icon..currentSpecName..": ",1,1,1)
			for i = 1, #spec1 do
				GameTooltip:AddDoubleLine(" ", spec1[i],1,1,1,1,1,1)
			end
			if majorTree2 then
				local currentSpecName2 = select(2, GetSpecializationInfo(majorTree2)) or NONE..TALENTS
				local _, _, _, icon2 = GetSpecializationInfo(majorTree2)
				icon2 = icon2 and "|T"..icon2..":14:14:0:0:64:64:4:60:4:60|t " or ""
				GameTooltip:AddLine("|cff00FF00"..(c == 2 and "* " or "   ") .. "|r" .. icon2..currentSpecName2..": ",1,1,1)
			else
				GameTooltip:AddLine("|cff00FF00"..(c == 2 and "* " or "   ") .. "|r" ..NONE..TALENTS..": ",1,1,1)
			end
			for i = 1, #spec2 do
				GameTooltip:AddDoubleLine(" ", spec2[i],1,1,1,1,1,1)
			end
		end
		
		GameTooltip:AddLine(' ')
		local specialization = GetLootSpecialization()
		if specialization == 0 then
			local specIndex = GetSpecialization();
			
			if specIndex then
				local specID, name = GetSpecializationInfo(specIndex);
				GameTooltip:AddLine(format('|cffFFFFFF%s:|r %s', SELECT_LOOT_SPECIALIZATION, format(LOOT_SPECIALIZATION_DEFAULT, name)))
			end
		else
			local specID, name = GetSpecializationInfoByID(specialization);
			if specID then
				GameTooltip:AddLine(format('|cffFFFFFF%s:|r %s', SELECT_LOOT_SPECIALIZATION, name))
			end
		end

		GameTooltip:AddLine(' ')
		GameTooltip:AddLine('|cffFFFFFF'..KEY_BUTTON1..':|r '..GARRISON_SWITCH_SPECIALIZATIONS)  --左键
		GameTooltip:AddLine('|cffFFFFFF'..KEY_BUTTON3..':|r '..TALENTS)	--中键
		GameTooltip:AddLine('|cffFFFFFF'..KEY_BUTTON2..':|r '..SELECT_LOOT_SPECIALIZATION)	--右键
		
		GameTooltip:Show()
	end)
	stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	stat:SetScript("OnMouseDown", function(_,btn)
		if btn == "RightButton" then
			local specIndex = GetSpecialization();
			if not specIndex then return end
			GameTooltip:Hide()
			local specID, specName = GetSpecializationInfo(specIndex);
			menuList[2].text = format(LOOT_SPECIALIZATION_DEFAULT, specName);
			for index = 1, 4 do
				local id, name = GetSpecializationInfo(index);
				if ( id ) then
					menuList[index + 2].text = name
					menuList[index + 2].func = function() SetLootSpecialization(id) end
				else
					menuList[index + 2] = nil
				end
			end
			EasyMenu(menuList, menuFrame, "cursor", -15, -7, "MENU", 2)
		elseif btn == "MiddleButton" then
			if not PlayerTalentFrame then
				TalentFrame_LoadUI()
			end

			if not GlyphFrame then
				GlyphFrame_LoadUI()
			end
			
			if not PlayerTalentFrame:IsShown() then
				ShowUIPanel(PlayerTalentFrame)
			else
				HideUIPanel(PlayerTalentFrame)
			end
		else
			local c = GetActiveSpecGroup(false,false)
			SetActiveSpecGroup(c == 1 and 2 or 1)
		end
	end)
end