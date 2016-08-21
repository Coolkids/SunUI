----------------------------------------------------------------------------------------
--	Auto equip Chef's Hat(module from Inomena by p3lim)
----------------------------------------------------------------------------------------
--[[
local frame = CreateFrame("Frame"), hat
frame:RegisterEvent("TRADE_SKILL_SHOW")
frame:RegisterEvent("TRADE_SKILL_CLOSE")
frame:RegisterEvent("TRADE_SKILL_UPDATE")
frame:SetScript("OnEvent", function(self, event)
	if event == "TRADE_SKILL_SHOW" then
		if IsTradeSkillGuild() or IsTradeSkillLinked() then
			return
		elseif GetTradeSkillLine() == PROFESSIONS_COOKING and GetItemCount(46349) > 0 then
			hat = GetInventoryItemLink("player", 1)
			EquipItemByName(46349)
		end
	elseif event == "TRADE_SKILL_CLOSE" then
		if hat then
			EquipItemByName(hat)
			hat = nil
		end
	elseif event == "TRADE_SKILL_UPDATE" then
		if hat and GetTradeSkillLine() ~= PROFESSIONS_COOKING then
			EquipItemByName(hat)
			hat = nil
		end
	end
end)
]]