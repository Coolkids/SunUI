local S, C, L, DB = unpack(SunUI)
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

---Hide Instance Difficulty flag 隐藏难度标志
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:Hide()

local id = CreateFrame("Frame", nil, Minimap)
id:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 6, -6)
id:RegisterEvent("PLAYER_ENTERING_WORLD")
id:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
id:RegisterEvent("GUILD_PARTY_STATE_UPDATED")
id:SetSize(10, 10)

local idtext = id:CreateFontString(nil, "OVERLAY")
idtext:SetPoint("LEFT", id)
idtext:SetJustifyH('LEFT')
idtext:SetTextColor(1, 0, 0)
idtext:SetFont(DB.PFont, 18, "OUTLINEMONOCHROME")
idtext:SetShadowOffset(S.mult, -S.mult)
idtext:SetShadowColor(0, 0, 0, 0.4)

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