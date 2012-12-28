local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("AutoEquipment")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local equipment = {}
local F = CreateFrame("Frame") 
function Module:Equipment()
	local equipmenttotal = GetNumEquipmentSets()
	for i = 1, equipmenttotal do
		equipment[i] = GetEquipmentSetInfo(i)
	end
end
function Module:UpdataSet()
	if SunUIConfig.db.profile.EquipmentDB.Enable then
		F:RegisterEvent("UNIT_SPELLCAST_STOP")
		F:SetScript("OnEvent", function(_,_,unit,_,_,_,spell) 
			if unit == "player" then 
				if spell == 63645 and equipment[SunUIConfig.db.profile.EquipmentDB.FirstName]then 
					EquipmentManager_EquipSet(equipment[SunUIConfig.db.profile.EquipmentDB.FirstName])   -- 主天賦套裝名稱為spec1
					print("|cffFFD700切换到|r:"..equipment[SunUIConfig.db.profile.EquipmentDB.FirstName])
				elseif spell == 63644 and equipment[SunUIConfig.db.profile.EquipmentDB.SecondName] then
					EquipmentManager_EquipSet(equipment[SunUIConfig.db.profile.EquipmentDB.SecondName])   -- 副天賦套裝名稱為spec2 
					print("|cffFFD700切换到|r:"..equipment[SunUIConfig.db.profile.EquipmentDB.SecondName])
				end 
			end  
		end)
	else
		F:UnregisterEvent("UNIT_SPELLCAST_STOP")
		F:SetScript("OnEvent", nil)
	end
end

function Module:OnEnable()
	Module:Equipment()
	Module:UpdataSet()
end

	
	