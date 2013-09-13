local SR_REP_MSG = "%s: %+d (%d/%d)";
local rep = {};

local function SR_Update(self)
	local numFactions = GetNumFactions();
	
	for i = 1, numFactions, 1 do
		local name, _, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(i);
		if (not isHeader) or (hasRep) then
			if not rep[name] then
				rep[name] = barValue;
			end
			
			local change = barValue - rep[name];
			if (change > 0) then
				rep[name] = barValue;
				local num = ceil((barMax - barValue)/change)
				local msg = string.format(SR_REP_MSG, name, change, barValue - barMin, barMax - barMin).." -"..num.."X";
				local info = ChatTypeInfo["COMBAT_FACTION_CHANGE"];
				for j = 1, 4, 1 do
					local chatfrm = getglobal("ChatFrame"..j);
					for k,v in pairs(chatfrm.messageTypeList) do
						if v == "COMBAT_FACTION_CHANGE" then
							chatfrm:AddMessage(msg, info.r, info.g, info.b, info.id);
							break;
						end
					end
				end
			end
		end
	end
end

local frame = CreateFrame("Frame");
frame:RegisterEvent("UPDATE_FACTION");
frame:SetScript("OnEvent", SR_Update);
ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", function() return true; end);

--[[ local beforeXP = UnitXP("player")
local playerMaxXP = UnitXPMax("player")
local XP_REP_MSG = "%s: %+d (%s/%s)";
local function SVal(Val)
    if Val >= 1e6 then
        return ("%.1fm"):format(Val/1e6):gsub("%.?0+([km])$", "%1")
    elseif Val >= 1e4 then
        return ("%.1fk"):format(Val/1e3):gsub("%.?0+([km])$", "%1")
    else
        return Val
    end
end
local function XP_Update(self)
	local change = UnitXP("player") - beforeXP
	beforeXP = UnitXP("player")
	local num = ceil((playerMaxXP - beforeXP)/change)
	local msg = string.format(XP_REP_MSG, COMBAT_XP_GAIN, change, SVal(beforeXP), SVal(playerMaxXP)).." -"..num.."X";
	local info = ChatTypeInfo["COMBAT_XP_GAIN"];
	DEFAULT_CHAT_FRAME:AddMessage(msg, info.r, info.g, info.b, info.id);
end
local xp = CreateFrame("Frame")
xp:RegisterEvent("PLAYER_XP_UPDATE")
xp:SetScript("OnEvent", XP_Update)
local levelup = CreateFrame("Frame")
levelup:RegisterEvent("PLAYER_LEVEL_UP")
levelup:SetScript("OnEvent", function()
	playerMaxXP = UnitXPMax("player")
end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_XP_GAIN", function() return true; end); ]]