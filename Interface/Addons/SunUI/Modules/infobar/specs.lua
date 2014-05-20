local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")

function IB:CreateSpecs()

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
		local currentSpec = GetSpecialization()
		local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or NONE..TALENTS
		local _, _, _, icon = GetSpecializationInfo(currentSpec)
        icon = icon and "|T"..icon..":12:12:0:0:64:64:5:59:5:59|t " or ""
		if not GetSpecialization() then
			stat.text:SetText(NONE..TALENTS) 
		else		
			stat.text:SetText(icon..currentSpecName)
		end
	end

	local function Checktalentgroup(index)
		return GetSpecialization(false,false,index)
	end


	stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	stat:RegisterEvent("PLAYER_TALENT_UPDATE")
	stat:SetScript("OnEvent", OnEvent)
	stat:SetScript("OnEnter", function(self)
		if InCombatLockdown() then return end
		local c = GetActiveSpecGroup(false,false)
		local majorTree1 = GetSpecialization(false,false,1)
		local spec1 = { }
		for i = 1, 18 do 
			local name, iconTexture, tier, column, selected, available = GetTalentInfo(i,false,1)
			iconTexture = iconTexture and "|T"..iconTexture..":12:12:0:0:64:64:5:59:5:59|t " or ""
			if selected then
				table.insert(spec1, iconTexture..name)
			end
		end
		local majorTree2 = GetSpecialization(false,false,2)
		local spec2 = { }
		for i = 1, 18 do 
			local name, iconTexture, tier, column, selected, available = GetTalentInfo(i,false,2)
			iconTexture = iconTexture and "|T"..iconTexture..":12:12:0:0:64:64:5:59:5:59|t " or ""
			if selected then
				table.insert(spec2, iconTexture..name)
			end
		end
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(TALENTS_BUTTON,0,.6,1)
		GameTooltip:AddLine(" ")
		if GetNumSpecGroups() == 1 then
			local currentSpec = GetSpecialization()
			local currentSpecName = currentSpec and select(2, GetSpecializationInfo(majorTree1)) or NONE..TALENTS
			local _, currentSpecName, _, icon = GetSpecializationInfo(majorTree1)
			icon = icon and "|T"..icon..":12:12:0:0:64:64:5:59:5:59|t " or ""
			GameTooltip:AddLine(icon.."|cff00FF00* " ..currentSpecName.. "|r",1,1,1)
			for i = 1, #spec1 do
				GameTooltip:AddDoubleLine(" ", spec1[i],1,1,1,1,1,1)
			end
		else
			local currentSpecName = select(2, GetSpecializationInfo(majorTree1)) or NONE..TALENTS
			local _, currentSpecName, _, icon = GetSpecializationInfo(majorTree1)
			icon = icon and "|T"..icon..":12:12:0:0:64:64:5:59:5:59|t " or ""
			GameTooltip:AddLine("|cff00FF00"..(c == 1 and "* " or "   ") .. "|r" .. icon..currentSpecName..": ",1,1,1)
			for i = 1, #spec1 do
				GameTooltip:AddDoubleLine(" ", spec1[i],1,1,1,1,1,1)
			end
			if majorTree2 then
				local currentSpecName2 = select(2, GetSpecializationInfo(majorTree2)) or NONE..TALENTS
				local _, currentSpecName2, _, icon2 = GetSpecializationInfo(majorTree2)
				icon2 = icon2 and "|T"..icon2..":12:12:0:0:64:64:5:59:5:59|t " or ""
				GameTooltip:AddLine("|cff00FF00"..(c == 2 and "* " or "   ") .. "|r" .. icon2..currentSpecName2..": ",1,1,1)
			else
				GameTooltip:AddLine("|cff00FF00"..(c == 2 and "* " or "   ") .. "|r" ..NONE..TALENTS..": ",1,1,1)
			end
			for i = 1, #spec2 do
				GameTooltip:AddDoubleLine(" ", spec2[i],1,1,1,1,1,1)
			end
		end
		GameTooltip:Show()
	end)
	stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	stat:SetScript("OnMouseDown", function(_,btn)
		if btn == "LeftButton" then
			ToggleTalentFrame()
		else
			local c = GetActiveSpecGroup(false,false)
			SetActiveSpecGroup(c == 1 and 2 or 1)
		end
	end)
end