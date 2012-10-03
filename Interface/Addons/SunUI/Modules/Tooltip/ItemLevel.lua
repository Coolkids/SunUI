local S, C, L, DB, _ = unpack(select(2, ...))
local MINCOLOR = 0.5;
local COLORINC = 0.2;
local INCMOD = 0.5;
local MinIL = 284;
local MaxIL = 509;

local slotName = {
	"HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot","WristSlot",
	"HandsSlot","WaistSlot","LegsSlot","FeetSlot","Finger0Slot","Finger1Slot",
	"Trinket0Slot","Trinket1Slot","MainHandSlot","SecondaryHandSlot"
}

local function GetAiL(unit)
	i = 0;
	total = 0;
	itn = 0;
	
	if (unit ~= nil) then
		for i in ipairs(slotName) do
			slot = GetInventoryItemID(unit, GetInventorySlotInfo(slotName[i]));
			
			if (slot ~= nil) then
				sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(slot);
				
				if (iLevel ~= nil) then
					if (iLevel > 0) then
						itn = itn + 1;
						total = total + iLevel;
					end
				end
			end
		end
	end
	
	if (total < 1 or itn < 1) then
		return 0;
	end
	
	return floor(total / itn);
end

local function GetAiLColor(ail)
	local r, gb;
	
	if (ail < MinIL) then
		r = (ail / MinIL);
		gb = r;
	else
		r = MINCOLOR + ((ail / MaxIL) * INCMOD);
		gb = 1.0 - ((ail / MaxIL) * INCMOD);
	end
	
	if (r < MINCOLOR) then
		r = MINCOLOR;
		gb = r;
	end
	
	return r, gb;
end
GameTooltip:HookScript("OnTooltipSetUnit", function(self, ...)
		local ail, r, gb;
		local name, unit = GameTooltip:GetUnit();
		if (unit and CanInspect(unit)) then
			local isInspectOpen = (InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown());
			if ((unit) and (CanInspect(unit)) and (not isInspectOpen)) then
				NotifyInspect(unit);
				ail = GetAiL(unit);
				r, gb = GetAiLColor(ail);
				ClearInspectPlayer(unit);
				GameTooltip:AddLine(STAT_AVERAGE_ITEM_LEVEL..":"..format(S.ToHex(r, gb, gb)..ail.."|r"));
				GameTooltip:Show();
			end
		end
	end)