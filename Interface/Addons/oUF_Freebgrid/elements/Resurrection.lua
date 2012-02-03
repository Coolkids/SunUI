local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local ResurrectionSpells = {
	7328,			-- Paladin
	2008,			-- Shaman
	50769,			-- Druid 起死回生
	--20484,			-- Druid 复生
	2006,			-- Priest
}

local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local spellname = nil

local Init = function()
	local FindInSpellbook = function(spell)
		for tab = 1, 4 do
			local _, _, offset, numSpells = GetSpellTabInfo(tab)
			for i = (1+offset), (offset + numSpells) do
				local bspell = GetSpellInfo(i, BOOKTYPE_SPELL)
				if (bspell == spell) then
					return i   
				end
			end
		end
		return nil
	end

	for _, lspell in pairs(ResurrectionSpells) do
		local na = GetSpellInfo (lspell)
		local x = FindInSpellbook(na)
		if x ~= nil then
			spellname = na
			break
		end
	end
	return spellname
end

local Resurrection = function(_,_,cast,name,_,unit)
	if(InCombatLockdown()) then return end
--[[	local unitname = nil
	if unit =="未知目标" and MouseoverUnit then
		unitname =  UnitName( MouseoverUnit)
	else
		unitname = unit
	end
--]]
	if cast == "player" and name == spellname and unit ~="未知目标" then 
		local Text = "正在复活<< "..unit.." >>...."
		if (GetNumRaidMembers() > 0) then
			SendChatMessage(Text, "RAID", nil, nil);
		elseif (GetNumPartyMembers() > 0) then
			SendChatMessage(Text, "PARTY", nil, nil);
		else
			SendChatMessage(Text, "WHISPER", nil, unit);
		end		
	end	
end


local Enable = function(self)	
	if not ns.db.Resurrection or (spellname == nil and Init() == nil) then  return end 
		if(not OnResFrame) then
            OnResFrame = CreateFrame"Frame"
			OnResFrame:RegisterEvent('UNIT_SPELLCAST_SENT')
			OnResFrame:SetScript('OnEvent', Resurrection)
		end
end


local Disable = function(self)
	if OnResFrame then
		OnResFrame:UnregisterEvent('UNIT_SPELLCAST_SENT')
	end
end
oUF:AddElement('Resurrection', Update, Enable, Disable)


