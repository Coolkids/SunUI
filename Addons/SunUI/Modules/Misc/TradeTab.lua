local S, L, DB, _, C = unpack(select(2, ...))
local _
local ProfessionTabs = CreateFrame("Frame", "ProfessionTabs")
ProfessionTabs:SetScript("OnEvent", function(self, Event, ...) self[Event](self, Event, ...) end)
ProfessionTabs:RegisterEvent("TRADE_SKILL_SHOW")
ProfessionTabs:RegisterEvent("TRADE_SHOW")
ProfessionTabs:RegisterEvent("SKILL_LINES_CHANGED")

local __TradeSkillFrame
local format = string.format
local IsCurrentSpell = IsCurrentSpell
local Cache, TradeSkillFrameTabs, TradeFrameTabs = {}, {}, {}
local TradeSkillFrameTabIndex, TradeFrameTabIndex = 1, 1
local Professions = {
	[1] = { 2259, 3101, 3464, 11611, 28596, 51304, 80731, 105206 }, -- Alchemy --炼金
	[2] = { 2018, 3100, 3538, 9785, 29844, 51300, 76666, 110396  }, -- Blacksmithing 锻造
	[3] = { 7411, 7412, 7413, 13920, 28029, 51313, 74258, 110400 }, -- Enchanting --附魔
	[4] = { 4036, 4037, 4038, 12656, 30350, 51306, 82774, 110403 }, -- Engineering --工程
	[5] = { 45357, 45358, 45359, 45360, 45361, 45363, 86008, 110417 }, -- Inscription  铭文
	[6] = { 25229, 25230, 28894, 28895, 28897, 51311, 73318, 110420 }, -- Jewelcrafting --珠宝
	[7] = { 2108, 3104, 3811, 10662, 32549, 51302, 81199, 110423 }, -- Leatherworking 制皮
	[8] = { 3908, 3909, 3910, 12180, 26790, 51309, 751561, 110426 }, -- Tailoring --裁缝
	[9] = { 2550, 3102, 3413, 18260, 33359, 51296, 88053, 104381 }, -- Cooking   --烹饪
	[10] = { 3273, 3274, 7924, 10846, 27028, 45542, 74559, 110406 }, -- First Aid  --急救
	[11] = { 78670, 88961, 89718, 89719, 89720, 89721, 89722, 110393 }, --考古
	[12] = { 53428 }, -- Runeforging
	[13] = { 2656 }, -- Smelting
	[14] = { 13262 }, -- Disenchant
	[15] = { 51005 }, -- Milling
	[16] = { 31252 }, -- Prospecting
	[17] = { 818 }, -- Basic Campfire
	[18] = { 1804 }, -- Pick Lock
}

function ProfessionTabs:CacheProfessions()
	wipe(Cache)
	
	for Index = 1, #Professions do
		for NewIndex = 1, #Professions[Index] do
			local Profession = Professions[Index][NewIndex]
			if IsSpellKnown(Profession) then
				Cache[#Cache+1] = Profession
				break
			end
		end
	end	
end

function ProfessionTabs:TriggerEvents()
	if TradeFrame and TradeFrame:IsShown() then
		self:TRADE_SHOW()
	end
	
	if __TradeSkillFrame and __TradeSkillFrame:IsShown() then
		self:TRADE_SKILL_SHOW()
	end	
end

local function Tab_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT") 
	GameTooltip:AddLine(self.SpellRank ~= "" and format("%s (%s)", self.SpellName, self.SpellRank) or self.SpellName, 1, 1, 1)
	GameTooltip:Show()
end

local function Tab_OnLeave(self)
	GameTooltip:Hide()
end

function ProfessionTabs:CreateTab(Table, Parent)
	local Tab = CreateFrame("CheckButton", nil, Parent, "SpellBookSkillLineTabTemplate SecureActionButtonTemplate")
	Tab:SetPoint("TOPLEFT", Parent, "TOPRIGHT", (Parent == ATSWFrame or Parent == TradeFrame) and 5 or 13, (Parent == TradeFrame and -32 or -24) + -44 * #Table)
	Tab:SetScript("OnEnter", Tab_OnEnter)
	Tab:SetScript("OnLeave", Tab_OnLeave)
	Tab:CreateShadow("Background")
	Table[#Table + 1] = Tab
	return Tab
end

function ProfessionTabs:UpdateTabs(Table)
	local Combat = InCombatLockdown()
	
	for Index = 1, #Table do
		local Tab = Table[Index]
		
		if Index > #Cache then
			if not Combat then Tab:Hide() end
		else
			if not Combat then Tab:Show() end
			Tab:SetChecked(IsCurrentSpell(Tab.SpellName))
		end
	end	
end

function ProfessionTabs:EventHandler(Table, Parent)
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:CacheProfessions()
		
		for Index = 1, #Cache do
			local SpellName, SpellRank, SpellTexture = GetSpellInfo(Cache[Index])
			local Tab = Table[Index] or self:CreateTab(Table, Parent)
			
			Tab.SpellName = SpellName
			Tab.SpellRank = SpellRank
			Tab:SetNormalTexture(SpellTexture)
			Tab:GetNormalTexture():SetTexCoord(0.08, 0.92, 0.08, 0.92)
			Tab:SetAttribute("type", "spell")
			Tab:SetAttribute("spell", SpellName)
		end
	end
	
	self:UpdateTabs(Table)
end

function ProfessionTabs:TRADE_SKILL_SHOW()
	__TradeSkillFrame = __TradeSkillFrame or MRTSkillFrame or ATSWFrame or SkilletFrame or TradeSkillFrame
	self:EventHandler(TradeSkillFrameTabs, __TradeSkillFrame)
	
	if TradeFrame:IsShown() then
		self:EventHandler(TradeFrameTabs, TradeFrame)
	end
end

function ProfessionTabs:TRADE_SHOW()
	self:EventHandler(TradeFrameTabs, TradeFrame)
end

function ProfessionTabs:SKILL_LINES_CHANGED()
	self:TriggerEvents()
end

function ProfessionTabs:PLAYER_REGEN_ENABLED(Event)
	self:UnregisterEvent(Event)
	self:TriggerEvents()
end