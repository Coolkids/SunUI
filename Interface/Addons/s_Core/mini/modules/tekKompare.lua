
local orig1 = GameTooltip:GetScript("OnTooltipSetItem")
GameTooltip:SetScript("OnTooltipSetItem", function(self, ...)
	if not ShoppingTooltip1:IsVisible() and not self:IsEquippedItem() then GameTooltip_ShowCompareItem(self, 1) end
	if orig1 then return orig1(self, ...) end
end)


local orig2 = ItemRefTooltip:GetScript("OnTooltipSetItem")
ItemRefTooltip:SetScript("OnTooltipSetItem", function(self, ...)
	GameTooltip_ShowCompareItem(self, 1)
	self.comparing = true
	if orig2 then return orig2(self, ...) end
end)


-- Don't let ItemRefTooltip fuck with the compare tips
ItemRefTooltip:SetScript("OnEnter", nil)
ItemRefTooltip:SetScript("OnLeave", nil)
ItemRefTooltip:SetScript("OnDragStart", function(self)
	ItemRefShoppingTooltip1:Hide(); ItemRefShoppingTooltip2:Hide(); ItemRefShoppingTooltip3:Hide()
	self:StartMoving()
end)
ItemRefTooltip:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	ValidateFramePosition(self)
	GameTooltip_ShowCompareItem(self, 1)
end)

--语言过滤
local SetCVar, BNGetMatureLanguageFilter, BNSetMatureLanguageFilter = 
	  SetCVar, BNGetMatureLanguageFilter, BNSetMatureLanguageFilter
local eventFr=CreateFrame("Frame")
local function set() SetCVar("profanityFilter","0") if BNGetMatureLanguageFilter() then BNSetMatureLanguageFilter(false) end end
eventFr:SetScript("OnEvent",set)
eventFr:RegisterEvent("CVAR_UPDATE")
eventFr:RegisterEvent("VARIABLES_LOADED")
eventFr:RegisterEvent("BN_MATURE_LANGUAGE_FILTER")
set()
---------------- > SetupUI
SetCVar("profanityFilter", 0)
SetCVar("scriptErrors", 1)
SetCVar("buffDurations", 1)
SetCVar("consolidateBuffs",0)
SetCVar("autoLootDefault", 1)
SetCVar("lootUnderMouse", 1)
SetCVar("autoSelfCast", 1)
SetCVar("ShowClassColorInNameplate", 1)
SetCVar("cameraDistanceMax", 50)
SetCVar("cameraDistanceMaxFactor", 3.4)
SetCVar("screenshotQuality", SCREENSHOT_QUALITY)
SetCVar("cameraSmoothStyle", 0)
SetCVar("chatStyle", "classic")

SetCVar("deselectOnClick", 1)
SetCVar("interactOnLeftClick", 0)
SetCVar("showTargetOfTarget", 1)
SetCVar("spamFilter", 0)
SetCVar("UnitNameNPC", 1)
SetCVar("UnitNameEnemyGuardianName", 1)
SetCVar("UnitNameEnemyTotemName", 1)
SetCVar("UnitNameFriendlyGuardianName", 1)
SetCVar("UnitNameFriendlyTotemName", 1)
SetCVar("UnitNameNonCombatCreatureName", 1)
SetCVar("UnitNameFriendlySpecialNPCName", 0)
SetCVar("fctDodgeParryMiss", 1)
SetCVar("fctDamageReduction", 1)
SetCVar("fctRepChanges", 1)
SetCVar("fctFriendlyHealers", 1)
SetCVar("fctEnergyGains", 1)
SetCVar("fctPeriodicEnergyGains", 1)
SetCVar("fctHonorGains", 1)
SetCVar("fctAuras", 1)
SetCVar("showNewbieTips", 0)
SetCVar("threatShowNumeric", 1)
SetCVar("showTutorials", 0)
--分解不必再点确定
local aotuClick = CreateFrame("Frame")
aotuClick:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
aotuClick:RegisterEvent("CONFIRM_LOOT_ROLL")
aotuClick:RegisterEvent("LOOT_BIND_CONFIRM")      
aotuClick:SetScript("OnEvent", function(self, event, ...)
   for i = 1, STATICPOPUP_NUMDIALOGS do
      local frame = _G["StaticPopup"..i]
      if (frame.which == "CONFIRM_LOOT_ROLL" or frame.which == "LOOT_BIND" or frame.which == "LOOT_BIND_CONFIRM") and frame:IsVisible() then 
      StaticPopup_OnClick(frame, 1) 
      end
   end
end)
---Hide Instance Difficulty flag 隐藏难度标志
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:Hide()

local id = CreateFrame("Frame", nil, Minimap)
id:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 6, -8)
id:RegisterEvent("PLAYER_ENTERING_WORLD")
id:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
id:RegisterEvent("GUILD_PARTY_STATE_UPDATED")
id:SetSize(10, 10)

local idtext = id:CreateFontString(nil, "OVERLAY")
idtext:SetPoint("LEFT", id)
idtext:SetJustifyH('LEFT')
idtext:SetTextColor(1, 0, 0)
idtext:SetFont("Fonts\\ARIALN.ttf", 18, "THINOUTLINE")

local function diff()
	local inInstance, instanceType = IsInInstance()
	local _, _, difficultyIndex, _, _, dynamicDifficulty, isDynamic = GetInstanceInfo()

	if inInstance and instanceType == "raid" then
		if (isDynamic and difficultyIndex == 1 and dynamicDifficulty == 0) or (not isDynamic and difficultyIndex == 1) then
			idtext:SetText("10")
		elseif (isDynamic and (difficultyIndex == 3 and dynamicDifficulty == 0) or (difficultyIndex == 1 and dynamicDifficulty == 1)) or (not isDynamic and difficultyIndex == 3) then
			idtext:SetText("10H")
		elseif (isDynamic and difficultyIndex == 2 and dynamicDifficulty == 0) or (not isDynamic and difficultyIndex == 2) then
			idtext:SetText("25")
		elseif (isDynamic and (difficultyIndex == 2 and dynamicDifficulty == 1) or (difficultyIndex == 4)) or (not isDynamic and difficultyIndex == 4) then
			idtext:SetText("25H")
		end
	elseif inInstance and instanceType == "party" then
		if difficultyIndex == 1 then
			idtext:SetText("5")
		elseif difficultyIndex == 2 then
			idtext:SetText("5H")
		end
	else
		idtext:SetText("")
	end
end
id:SetScript("OnEvent", diff)