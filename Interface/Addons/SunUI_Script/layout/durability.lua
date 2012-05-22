local S, C, L, DB = unpack(SunUI)
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("durability")
function Module:OnEnable()
	if C["InfoPanelDB"]["OpenBottom"] ~= true then return end
	local Slots = {
		[1] = {1, L["头部"], 1000},
		[2] = {3, L["肩部"], 1000},
		[3] = {5, L["胸部"], 1000},
		[4] = {6, L["腰部"], 1000},
		[5] = {9, L["手腕"], 1000}, 
		[6] = {10, L["手"], 1000},
		[7] = {7, L["腿部"], 1000},
		[8] = {8, L["脚"], 1000},
		[9] = {16, L["主手"], 1000},
		[10] = {17, L["副手"], 1000}, 
		[11] = {18, L["远程"], 1000}
	}
	local durability = CreateFrame("Frame", nil, UIParent)
	durability.text = S.MakeFontString(durability, 14)
	durability.text:SetTextColor(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)
	durability.text:SetPoint("LEFT", BottomBar, "LEFT", 80, 2)
	durability:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	durability:RegisterEvent("MERCHANT_SHOW")
	durability:RegisterEvent("PLAYER_ENTERING_WORLD")
	durability:SetAllPoints(durability.text)
	durability:SetScript("OnEvent", function(self)
			for i = 1, 11 do
				if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
					local durability, max = GetInventoryItemDurability(Slots[i][1])
					if durability then 
						Slots[i][3] = durability/max
					end
				end
			end
			table.sort(Slots, function(a, b) return a[3] < b[3] end)
			local value = floor(Slots[1][3]*100)
			if value < 40 then
				self.text:SetText(Slots[1][2].."耐久过低!")
			else
				self.text:SetText("")
			end
	end)
	durability:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, 0)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(L["耐久度"], 0.4, 0.78, 1)
			GameTooltip:AddLine(" ")
			for i = 1, 11 do
				if Slots[i][3] ~= 1000 then
					green = Slots[i][3]/1
					red = 1-green
					GameTooltip:AddDoubleLine(Slots[i][2], format("%d %%", floor(Slots[i][3]*100)), 1 , 1 , 1, red, green, 0)
				end
			end
			GameTooltip:Show()
		end
	end)
	durability:SetScript("OnLeave", function() GameTooltip:Hide() end)
	durability:SetScript("OnMouseDown", function(self, button)
	ToggleCharacter("PaperDollFrame") end)
end