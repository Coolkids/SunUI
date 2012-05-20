local S, C, L, DB = unpack(SunUI)
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("durability")
function Module:OnEnable()
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
end