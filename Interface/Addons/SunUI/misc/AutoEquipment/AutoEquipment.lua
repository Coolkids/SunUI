local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local A = S:GetModule("AutoEquipment")
local F = CreateFrame("Frame") 
function A:Equipment()
	local equipmenttotal = GetNumEquipmentSets()
	for i = 1, equipmenttotal do
		self.equipments[i] = GetEquipmentSetInfo(i)
	end
end
function A:UpdataSet()
	if self.db.Enable then
		F:RegisterEvent("UNIT_SPELLCAST_STOP")
		F:SetScript("OnEvent", function(_,_,unit,_,_,_,spell) 
			if unit == "player" then 
				if spell == 63645 and self.equipments[self.db.FirstName]then 
					EquipmentManager_EquipSet(self.equipments[self.db.FirstName])   -- 主天賦套裝名稱為spec1
					S:Print("|cffFFD700切换到|r:"..self.equipments[self.db.FirstName])
				elseif spell == 63644 and self.equipments[self.db.SecondName] then
					EquipmentManager_EquipSet(self.equipments[self.db.SecondName])   -- 副天賦套裝名稱為spec2 
					S:Print("|cffFFD700切换到|r:"..self.equipments[self.db.SecondName])
				end 
			end  
		end)
	else
		F:UnregisterEvent("UNIT_SPELLCAST_STOP")
		F:SetScript("OnEvent", nil)
	end
end

function A:init()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "Equipment")
	self:Equipment()
	self:UpdataSet()
end

	
	