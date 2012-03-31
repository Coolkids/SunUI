local _, RT = ...
local string_find = string.find
local string_match = string.match
local string_len = string.len
local string_sub = string.sub
local string_replace = string.gsub
local string_lower = string.lower
local string_format = string.format
local string_gsub = string.gsub
local pairs = pairs
local next = next
local tonumber = tonumber
local select = select

RatingsDB = {
	forceLevel = nil,
	format = " |cffffff7f(+$V)|r", --" ($V@$L)",
}

local SEPARATORS, PATTERNS, STATS
if GetLocale() == "enUS" then
	SEPARATORS = {
		[","] = true,
		[" and "] = true,
		["/"] = true,
		[". "] = true,
	--	[" for "] = true,
		["&"] = true,
	--	[":"] = true,
	}
	PATTERNS = {
		[" by (%d+)"] = true,
		["([%+%-]%d+)"] = false,
		["grant.-(%d+)"] = true,
		["add.-(%d+)"] = true,
		["(%d+)([^%d%%|]+)"] = false,
	}
	STATS = {
		{"defense rating", CR_DEFENSE_SKILL},
		{"dodge rating", CR_DODGE},
		{"block rating", CR_BLOCK},
		{"parry rating", CR_PARRY},
		{"ranged critical strike rating", CR_CRIT_RANGED},
		{"ranged critical hit rating", CR_CRIT_RANGED},
		{"ranged critical rating", CR_CRIT_RANGED},
		{"ranged crit rating", CR_CRIT_RANGED},
		{"critical strike rating", CR_CRIT_MELEE},
		{"critical hit rating", CR_CRIT_MELEE},
		{"critical rating", CR_CRIT_MELEE},
		{"crit rating", CR_CRIT_MELEE},
		{"ranged hit rating", CR_HIT_RANGED},
		{"hit rating", CR_HIT_MELEE},
		{"resilience", COMBAT_RATING_RESILIENCE_CRIT_TAKEN},
		{"ranged haste rating", CR_HASTE_RANGED},
		{"haste rating", CR_HASTE_MELEE},
		{"skill rating", CR_WEAPON_SKILL},
		{"expertise rating", CR_EXPERTISE},
		{"hit avoidance rating", CR_HIT_TAKEN_MELEE},
		{"armor penetration rating", CR_ARMOR_PENETRATION},
    {"mastery rating", CR_MASTERY},
	}
elseif GetLocale() == "zhTW" then
	-- Thanks vivianalive http://wow.curse.com/downloads/wow-addons/details/ratings.aspx#714023
	SEPARATORS = {
		["，"] = true,
		[" 和"] = true,
		["。"] = true,
		["："] = true,
	}
	PATTERNS = {
		["提高(%d+)"] = true,
		["([%+%-]%d+)"] = false,
		["grant.-(%d+)"] = false,
		["add.-(%d+)"] = false,
		["(%d+)([^%d%%|]+)"] = false,
	}
	STATS = {
		{"防禦等級", CR_DEFENSE_SKILL},
		{"閃躲等級", CR_DODGE},
		{"格擋等級", CR_BLOCK},
		{"招架等級", CR_PARRY},
		{"遠程攻擊致命一擊等級", CR_CRIT_RANGED},
		{"致命一擊等級", CR_CRIT_MELEE},
		{"遠程命中等級", CR_HIT_RANGED},
		{"命中等級", CR_HIT_MELEE},
		{"韌性", COMBAT_RATING_RESILIENCE_CRIT_TAKEN},
		{"遠程攻擊加速等級", CR_HASTE_RANGED},
		{"加速等級", CR_HASTE_MELEE},
		{"技能等級", CR_WEAPON_SKILL},
		{"熟練等級", CR_EXPERTISE},
		{"命中迴避概率", CR_HIT_TAKEN_MELEE},
		{"護甲穿透等級", CR_ARMOR_PENETRATION},
    {"精通等級", CR_MASTERY},
	}
elseif GetLocale() == "zhCN" then
	SEPARATORS = {
		["，"] = true,
		["和"] = true,
		["。"] = true,
		["："] = true,
	}
	PATTERNS = {
		["提高(%d+)"] = true,
		["([%+%-]%d+)"] = false,
		["grant.-(%d+)"] = false,
		["add.-(%d+)"] = false,
		["(%d+)([^%d%%|]+)"] = false,
	}
	STATS = {
		{"防御等级", CR_DEFENSE_SKILL},
		{"躲闪等级", CR_DODGE},
		{"格挡等级", CR_BLOCK},
		{"招架等级", CR_PARRY},
		{"远程爆击等级", CR_CRIT_RANGED},
		{"爆击等级", CR_CRIT_MELEE},
		{"远程命中等级", CR_HIT_RANGED},
		{"命中等级", CR_HIT_MELEE},
		{"韧性等级", CR_CRIT_TAKEN_MELEE},
		{"远程急速等级", CR_HASTE_RANGED},
		{"急速等级", CR_HASTE_MELEE},
		{"武器技能等级", CR_WEAPON_SKILL},
		{"精准等级", CR_EXPERTISE},
		{"回避等级", CR_HIT_TAKEN_MELEE},
		{"护甲穿透等级", CR_ARMOR_PENETRATION},
    {"精通等级", CR_MASTERY},
	}
else
	DisableAddOn("Ratings")
	return
end

PATTERNS["|cff00ff00%+(%d+)|r"] = true
PATTERNS["|cffff2020%-(%d+)|r"] = true

local Ratings = {}

do
	local hook_otsi = function (...) Ratings:OnTooltipSetItem(...) end
	local hook_otc = function (...) Ratings:OnTooltipCleared(...) end
	function Ratings:HookTooltip(tt)
		tt:HookScript("OnTooltipSetItem", hook_otsi)
		tt:HookScript("OnTooltipCleared", hook_otc)
	end
end

local regions_set = {}
local function clear_regions(...)
	for i = 1, select("#", ...) do
		local region = select(i, ...)
		regions_set[region] = nil
	end
end

function Ratings:OnTooltipSetItem(tt)
	self:HandleFontStrings(tt:GetRegions())
end

function Ratings:OnTooltipCleared(tt)
	clear_regions(tt:GetRegions())
end

function Ratings:HandleFontStrings(...)
	for i = 1, select("#", ...) do
		local region = select(i, ...)
		if region.GetText and region:IsShown() and not regions_set[region] then
			regions_set[region] = true
			region:SetText(self:ReplaceText(region:GetText()))
		end
	end
end

do
	local function get_next_chunk(text, p)
		local lstart, lend
		for sep in pairs(SEPARATORS) do
			local s, e = string_find(text, sep, p, true)
			if s then
				if not lstart or lstart > s then
					lstart, lend = s, e
				end
			end
		end
		if not lstart then
			return string_sub(text, p), -1
		else
			return string_sub(text, p, lstart - 1), lend + 1
		end
	end

	local replacements = {}
	function Ratings:ReplaceText(text)
		if not text or not text:find("%d") then return text end
		local pos = 1
		while pos > 0 do
			local sub
			sub, pos = get_next_chunk(text, pos)
			replacements[sub] = self:GetReplacementText(sub)
		end
		while true do
			local sub, rep = next(replacements)
			if not sub then return text end
			replacements[sub] = nil
			text = string_replace(text, sub, rep)
		end
	end

	function Ratings:GetReplacementText(text)
		local lower_text = string_lower(text)
		for pattern, after in pairs(PATTERNS) do
			local value, partial = string_match(lower_text, pattern)
			if value then
				if tonumber(partial) then
					partial, value = value, partial
				end
				local check = partial or lower_text
				for _, info in pairs(STATS) do
					local stat, id = info[1], info[2]
					if string_find(check, stat, 1, true) then
						local bonus = self:GetRatingBonus(id, tonumber(value))
						if not bonus then return end
						if after then
							return string_replace(text, value, value .. bonus)
						else
							local s, e = string_find(lower_text, stat, 1, true)
							stat = string_sub(text, s, e)
							return string_replace(text, stat, stat .. bonus)
						end
					end
				end
			end
		end
	end
end

do
	local CombatRatingMap = {
		[CR_WEAPON_SKILL] = 2.5,
		[CR_DEFENSE_SKILL] = 1.5,
		[CR_DODGE] = 13.8,
		[CR_PARRY] = 13.8,
		[CR_BLOCK] = 5,
		[CR_HIT_MELEE] = 10,
		[CR_CRIT_MELEE] = 14,
		[CR_HIT_RANGED] = 10,
		[CR_CRIT_RANGED] = 14,
		[CR_HASTE_MELEE] = 10,
		[CR_HASTE_RANGED] = 10,
		[CR_HIT_SPELL] = 8,
		[CR_CRIT_SPELL] = 14,
		[CR_HASTE_SPELL] = 10,
		[COMBAT_RATING_RESILIENCE_CRIT_TAKEN] = 28.75,
		[CR_HIT_TAKEN_MELEE] = 10,
		[CR_EXPERTISE] = 2.5,
		[CR_ARMOR_PENETRATION] = 4.2682925137607,
    [CR_MASTERY] = 14,
	}

	local lowerlimit34 = {
		[CR_DEFENSE_SKILL] = true,
		[CR_DODGE] = true,
		[CR_PARRY] = true,
		[CR_BLOCK] = true,
		[CR_HIT_TAKEN_MELEE] = true,
		[CR_HIT_TAKEN_SPELL] = true,
	}

	local ratingMultiplier = setmetatable({
-- see http://elitistjerks.com/f15/t29453-combat_ratings_level_85_cataclysm/
		[81] = 1 / 4.3056,
		[82] = 1 / 5.65397,
		[83] = 1 / 7.42755,
		[84] = 1 / 9.75272,
		[85] = 1 / 12.805701,
	},{
		__index = function (self, level)
			--[[
			The following calculations are based on Whitetooth's calculations:
			http://www.wowinterface.com/downloads/info5819-Rating_Buster.html
			]]
			local value
			if level < 10 then
				value = 26
			elseif level <= 60 then
				value = 52 / (level - 8)
			elseif level <= 70 then
				value = (262-3*level) / 82
			elseif level <= 80 then
				value = 1 / ((82/52)*(131/63)^((level-70)/10))
			end
			if value then
				self[level] = value
			end
			return value
		end,
	})
	Ratings.MAX_SUPPORTED_LEVEL = 85

	local hasteBonusClasses = {
		DEATHKNIGHT = true,
		DRUID = true,
		PALADIN = true,
		SHAMAN = true,
	}

	local spellBasedClasses = {
		PRIEST = "spell",
		MAGE = "spell",
		WARLOCK = "spell",
		HUNTER = "ranged",
	}

	local modifiedRatings = {
		spell = {
			[CR_HIT_MELEE] = CR_HIT_SPELL,
			[CR_CRIT_MELEE] = CR_CRIT_SPELL,
			[CR_HASTE_MELEE] = CR_HASTE_SPELL,
		},
		ranged = {
			[CR_HIT_MELEE] = CR_HIT_RANGED,
			[CR_CRIT_MELEE] = CR_CRIT_RANGED,
			[CR_HASTE_MELEE] = CR_HASTE_RANGED,
		},
	}

	function Ratings:GetModifier()
		local modifier = RatingsDB.modifier
		if not modifier then
			local class = select(2, UnitClass"player")
			modifier = spellBasedClasses[class] or "melee"
			RatingsDB.modifier = modifier
		end
		return modifier
	end

	function Ratings:GetClassRatingType(base_type)
		local modifiers = modifiedRatings[self:GetModifier()]
		return modifiers and modifiers[base_type] or base_type
	end

	function Ratings:GetRatingBonus(type, value)
		type = self:GetClassRatingType(type)
		local F = CombatRatingMap[type]
		if not F then return end

		local level = RatingsDB.forceLevel or UnitLevel"player"
		local _, class = UnitClass"player"


		if level < 34 and lowerlimit34[type] then level = 34 end

		if type == CR_HASTE_MELEE then
			if hasteBonusClasses[class] then
				value = value * 1.3 -- or F /= 1.3
			end
		end

		local bonus = value / F * ratingMultiplier[level]
		return self:Format(bonus, level, type > 2 and type ~= 24)
	end
end

do
	local format_table = {}
	function Ratings:Format(bonus, level, has_percent)
		if has_percent then
			format_table.V = string_format("%.2f%%", bonus)
		else
			format_table.V = string_format("%.2f", bonus)
		end
		format_table.L = tostring(level)
		return string_gsub(RatingsDB.format, "%$([A-Z])", format_table)
	end
end

Ratings:HookTooltip(GameTooltip)
Ratings:HookTooltip(ItemRefTooltip)
Ratings:HookTooltip(ShoppingTooltip1)
Ratings:HookTooltip(ShoppingTooltip2)

_G.Ratings = Ratings
