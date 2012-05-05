local S, C, L, DB = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Interrupt")

function Module:OnInitialize()
	C = MiniDB
	if C["Interrupt"] ~= true then return end

InterruptSayDB= {
	intsayonoff = 1,
	INTSAYOUTPUT = 'Auto',
	Verbose = 1,
	msg = ("我已斷法: MobName的 [SpellLink]."),
	Allmembersonoff = 0,
}

local InterruptSay = CreateFrame("Frame")

local function OnEvent(self, event, ...)
	local dispatch = self[event]

	if dispatch then
		dispatch(self, ...)
	end
end

InterruptSay:SetScript("OnEvent", OnEvent)
InterruptSay:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
InterruptSay:RegisterEvent("ADDON_LOADED")

function InterruptSay:ADDON_LOADED(...)
    if not InterruptSayDB.intsayonoff then
		InterruptSayDB.intsayonoff = 1
	end
    if not InterruptSayDB.INTSAYOUTPUT then
		InterruptSayDB.INTSAYOUTPUT = 'Auto'
	end
    if not InterruptSayDB.Verbose then
		InterruptSayDB.Verbose = 1
	end
    if not InterruptSayDB.msg then
		InterruptSayDB.msg = ("=> I Interrupted That: MobName's [SpellLink].")
	end
    if not InterruptSayDB.Allmembersonoff then
		InterruptSayDB.Allmembersonoff = 0
	end
    print("variables were loaded.")
    self:UnregisterEvent("ADDON_LOADED")
    print("event was unregistered.")

end

function IIT_verbtog()
	if InterruptSayDB.Verbose==1 then
		InterruptSayDB.Verbose=0
		print("|c00bfffffI Interrupted That - Verbose is off.|r")
	else
		InterruptSayDB.Verbose=1
		print("|c00bfffffI Interrupted That - Verbose is on.|r")
	end
end

function InterruptSay:COMBAT_LOG_EVENT_UNFILTERED(...)
	local inParty = GetNumPartyMembers()>=1
	local inRaid = GetNumRaidMembers()>=1
	local aEvent = select(2, ...)
	local aUser = select(5, ...)
	local destName = select(9, ...)
	local spellID = select(15, ...)
	if InterruptSayDB.intsayonoff==1 then
		if aEvent=="SPELL_INTERRUPT" then
			if inParty then xxx="PARTY" end
			local ssInInstance, ssinstanceType = IsInInstance();
			if ssinstanceType == "pvp" then 
				xxx="BATTLEGROUND";
			else
			if inRaid then xxx="RAID" end
			end
			if InterruptSayDB.Allmembersonoff==0 and aUser~=UnitName("player") then return end 
			if (UnitInRaid("player")) then
				if not UnitInRaid(aUser) then return end
			else
				if not UnitInParty(aUser) then return end
			end
			if InterruptSayDB.Verbose~=1 then 
				if aUser~=UnitName("player") then
					intsaymsg = (aUser..L["我已打断: =>"]..destName.. L["<=的 "] ..GetSpellLink(spellID).. ".")
					InterruptSayDB.msg = ("Interrupted MobName's [SpellLink].")
				else
					intsaymsg = (L["我已打断: =>"]..destName.. L["<=的 "] ..GetSpellLink(spellID).. ".")
					InterruptSayDB.msg = ("我已斷法 MobName的 [SpellLink].")
				end
			else
				if aUser~=UnitName("player") then
					intsaymsg = (aUser..L["我已打断: =>"]..destName..L["<=的 "] ..GetSpellLink(spellID).. ".")
					InterruptSayDB.msg = ("=> Someone Else Interrupted That: MobName's [SpellLink].")
				else
					intsaymsg = (L["我已打断: =>"]..destName.. L["<=的 "] ..GetSpellLink(spellID).. ".")
					InterruptSayDB.msg = ("我已斷法: MobName的 [SpellLink].")
				end
			end
			if InterruptSayDB.INTSAYOUTPUT=='Emote' then
				if aUser~=UnitName("player") then return end
				SendChatMessage("interrupted "..destName.."'s "..GetSpellLink(spellID)..".", "EMOTE")
			elseif InterruptSayDB.INTSAYOUTPUT=='Self' then
				print(intsaymsg)
			elseif InterruptSayDB.INTSAYOUTPUT=='Say' then
				if xxx == "pvp" then
					print(intsaymsg)
				else
					if (not inParty) and (not inRaid) then
						if aUser~=UnitName("player") then 
						return
						end
					else
						SendChatMessage(intsaymsg, "SAY")
					end
				end
			elseif InterruptSayDB.INTSAYOUTPUT=='Auto' then 
				if (not inParty) and (not inRaid) then
					print(intsaymsg)
				else 
					SendChatMessage(intsaymsg, xxx)
				end
			end
		end
	end
end

function IIT_toggleon()
	if InterruptSayDB.intsayonoff==1 then
		InterruptSayDB.intsayonoff=0
		print("|c00bfffffI Interrupted That is now off.|r")
	else
		InterruptSayDB.intsayonoff=1
		print("|c00bfffffI Interrupted That is now on.|r")
	end
end

function IIT_allmemberstog()
	if InterruptSayDB.Allmembersonoff==1 then
		InterruptSayDB.Allmembersonoff=0
		print("|c00bfffffI Interrupted That - All Members is off.|r")
	else
		InterruptSayDB.Allmembersonoff=1
		print("|c00bfffffI Interrupted That - All Members is on.|r")
	end
end

SLASH_IIT1="/iit"
SlashCmdList["IIT"] =
	function(msg)
		local a1 = gsub(msg, "%s*([^%s]+).*", "%1");
		local a2 = gsub(msg, "%s*([^%s]+)%s*(.*)", "%2");
	if (a1 == "") then print(IIT_list) end
	if (a1 == "info") or (a1 == "Info") then print(IIT_list)
		if InterruptSayDB.intsayonoff~=1 then 
			print("|c00bfffffI Interrupted That is off.|r") 
		else 
			print(IIT_outputchannel, InterruptSayDB.INTSAYOUTPUT) 
			if InterruptSayDB.Allmembersonoff==1 then
				print(IIT_allmembers.." On")
			else
				print(IIT_allmembers.." Off")
			end
		end
		if InterruptSayDB.INTSAYOUTPUT~="Emote" then
			if InterruptSayDB.Verbose~=1 then
				print("|c00bfffffVerbose is: |rOFF")
			else print("|c00bfffffVerbose is: |rON")
			end 
		end
	end
	if (a1 == "toggle") then IIT_toggleon() end
    if (a1 == "Say") or (a1 == "say") then
		InterruptSayDB.INTSAYOUTPUT = 'Say' print(IIT_outputchannel, InterruptSayDB.INTSAYOUTPUT)
    elseif (a1 == "Self") or (a1 == "self") then 
		InterruptSayDB.INTSAYOUTPUT = 'Self' print(IIT_outputchannel, InterruptSayDB.INTSAYOUTPUT)
    elseif (a1 == "Auto") or (a1 == "auto") then 
		InterruptSayDB.INTSAYOUTPUT = 'Auto' print(IIT_outputchannel, InterruptSayDB.INTSAYOUTPUT) 
    elseif (a1 == "Emote") or (a1 == "emote") then 
		InterruptSayDB.INTSAYOUTPUT = 'Emote' 
		InterruptSayDB.msg = (UnitName("player").." interrupted MobName's [SpellLink]")
		print(IIT_outputchannel, InterruptSayDB.INTSAYOUTPUT) 
    end
	if (a1 == "verbose") then 
		if InterruptSayDB.INTSAYOUTPUT=='Emote' then 
			print("|c00bfffffEmote doesn't have a verbose output. Change to toggle. :)|r") 
		else 
			IIT_verbtog()
		end
	end
	if (a1 == "allmembers") then IIT_allmemberstog() end
	if (a1 == "msg") then 
		print("|c00bfffff"..InterruptSayDB.msg)
    end
end   
end