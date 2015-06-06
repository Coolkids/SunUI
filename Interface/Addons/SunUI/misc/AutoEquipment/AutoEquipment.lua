local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local A = S:GetModule("AutoEquipment")
local F = CreateFrame("Frame") 
function A:Equipment()
	local equipmenttotal = GetNumEquipmentSets()
	for i = 1, equipmenttotal do
		self.equipments[i] = GetEquipmentSetInfo(i)
	end
end
local function OnEvent(...)
	local _,_,unit,_,_,_,spell = ...
	if InCombatLockdown() then return end
	if unit == "player" then 
		if spell == 63645 then
			if self.db.Enable and self.equipments[self.db.FirstName] then
				EquipmentManager_EquipSet(self.equipments[self.db.FirstName])   -- 主天賦套裝名稱為spec1
				S:Print("|cffFFD700切换到|r:"..self.equipments[self.db.FirstName])
			end
			if (self.db.bindLayout) then
				S.db.layout.mainLayout = self.db.SecondLayout
				S:SetMoversPositions()
			end
		elseif spell == 63644 then
			if self.db.Enable and self.equipments[self.db.SecondName] then
				EquipmentManager_EquipSet(self.equipments[self.db.SecondName])   -- 副天賦套裝名稱為spec2 
				S:Print("|cffFFD700切换到|r:"..self.equipments[self.db.SecondName])
			end
			if (self.db.bindLayout) then
				S.db.layout.mainLayout = self.db.SecondLayout
				S:SetMoversPositions()
			end
		end 
	end  
end
function A:UpdataSet()
	if self.db.Enable or self.db.bindLayout then
		F:RegisterEvent("UNIT_SPELLCAST_STOP")
		F:SetScript("OnEvent", OnEvent)
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

	
	