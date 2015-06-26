local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")

function IB:CreateDurability()
	local Slots = {
		[1] = {1, INVTYPE_HEAD, 1000}, --头
		[2] = {3, INVTYPE_SHOULDER, 1000}, --L["肩部"]
		[3] = {5, INVTYPE_ROBE, 1000}, --L["胸部"]
		[4] = {6, INVTYPE_WAIST, 1000}, --L["腰部"]
		[5] = {9, INVTYPE_WRIST, 1000},  --L["手腕"]
		[6] = {10, INVTYPE_HAND, 1000}, --L["手"]
		[7] = {7, INVTYPE_LEGS, 1000}, --L["腿部"]
		[8] = {8, INVTYPE_FEET, 1000}, --L["脚"]
		[9] = {16, INVTYPE_WEAPONMAINHAND, 1000}, --L["主手"]
		[10] = {17, INVTYPE_SHIELD, 1000},  --L["副手"]
	}
	local nowSlots = {}
	local A = S:GetModule("Skins")
	
	local stat = CreateFrame("Frame", "InfoPanelBottom2", BottomInfoPanel or UIParent)
	stat:SetFrameStrata("BACKGROUND")
	stat:SetFrameLevel(3)
	stat:EnableMouse(true)

	stat.text = S:CreateFS(stat, nil, nil, IB.font)
	stat.text:SetPoint("LEFT", InfoPanelBottom1, "RIGHT", 20, 0)
	
	stat.icon = stat:CreateTexture(nil, "OVERLAY")
	stat.icon:SetSize(8, 8)
	stat.icon:SetPoint("RIGHT", stat.text, "LEFT", -5, 0)
	stat.icon:SetTexture(IB.backdrop)
	stat.icon:SetVertexColor(unpack(IB.InfoBarStatusColor[3]))
	A:CreateShadow(stat, stat.icon)
	
	stat:SetPoint("TOPLEFT", stat.icon)
	stat:SetPoint("BOTTOMLEFT", stat.icon)
	stat:SetPoint("TOPRIGHT", stat.text)
	stat:SetPoint("BOTTOMRIGHT", stat.text)
	
	stat:SetScript("OnEvent", function(self)
		wipe(nowSlots)
		local total, num = 0, 0
		for i = 1, 10 do
			if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
				local durability, max = GetInventoryItemDurability(Slots[i][1])
				if durability then
					local per = durability/max
					table.insert(nowSlots, {i, Slots[i][2], per})
					total = per + total
					num = num + 1
				end
			end
		end
		table.sort(nowSlots, function(a, b) return a[3] < b[3] end)
		local value = num ~= 0 and floor(nowSlots[1][3]*100) or nil
		if value then
			local r, g, b = S:ColorGradient(((100-value)/100), IB.InfoBarStatusColor[3][1], IB.InfoBarStatusColor[3][2], IB.InfoBarStatusColor[3][3], 
																IB.InfoBarStatusColor[2][1], IB.InfoBarStatusColor[2][2], IB.InfoBarStatusColor[2][3],
																IB.InfoBarStatusColor[1][1], IB.InfoBarStatusColor[1][2], IB.InfoBarStatusColor[1][3])
			self.text:SetText(value.."|cffffd700%|r")
			self.icon:SetVertexColor(r, g, b, 0.8)
		else
			self.text:SetText("|cffffd700N/A|r")
			stat.icon:SetVertexColor(unpack(IB.InfoBarStatusColor[3]))
		end
	end)
	stat:SetScript("OnEnter", function(self)
		if InCombatLockdown() then return end
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(DURABILITY, 0.4, 0.78, 1)
		GameTooltip:AddLine(" ")
		for k,v in pairs(nowSlots) do
			local green = v[3]*2
			local red = 1 - green
			GameTooltip:AddDoubleLine(v[2], format("%d|cffffd700%%|r", floor(v[3]*100)), 1 ,1 , 1, red + 1, green, 0)
		end
		GameTooltip:Show()
	end)
	stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	stat:SetScript("OnMouseDown", function(self, button)
		ToggleCharacter("PaperDollFrame") 
	end)
	
	stat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	stat:RegisterEvent("MERCHANT_SHOW")
	stat:RegisterEvent("PLAYER_ENTERING_WORLD")
end