--Upload zhTW localization by Pastor(夜空之歌), 2009/05/13
if (GetLocale() ~= "zhTW") then
	return;
end

LibGearExam.Patterns = {
	--基本狀態--
	{ p = "%+(%d+)力量", s = "STR" },
	{ p = "%+(%d+)敏捷", s = "AGI" },
	{ p = "%+(%d+)耐力", s = "STA" },
	{ p = "%+(%d+)智力", s = "INT" },
	{ p = "%+(%d+)精神", s = "SPI" },
	{ p = "(%d+)點護甲", s = "ARMOR" }, 
	{ p = "%+(%d+)護甲", s = "ARMOR" }, --附魔
	{ p = "%+(%d+)所有屬性", s = { "STR", "AGI", "STA", "INT", "SPI" } }, --附魔
	
	--抗性--
	{ p = "%+(%d+)秘法抗性", s = "ARCANERESIST" },
	{ p = "%+(%d+)火焰抗性", s = "FIRERESIST" },
	{ p = "%+(%d+)自然抗性", s = "NATURERESIST" },
	{ p = "%+(%d+)冰霜抗性", s = "FROSTRESIST" },
	{ p = "%+(%d+)暗影抗性", s = "SHADOWRESIST" },
	{ p = "%+(%d+)點所有魔法抗性。", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } },
	{ p = "%+(%d+)所有抗性", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } }, --附魔

	--其他法術傷害--
	{ p = "%+(%d+)秘法能量", s = "ARCANEDMG" },
	{ p = "%+(%d+)火焰能量", s = "FIREDMG" },
	{ p = "%+(%d+)自然能量", s = "NATUREDMG" },
	{ p = "%+(%d+)冰霜能量", s = "FROSTDMG" },
	{ p = "%+(%d+)暗影能量", s = "SHADOWDMG" },
	{ p = "%+(%d+)神聖能量", s = "HOLYDMG" },
	{ p = "使你的秘法法術能量提高(%d+)點。", s = "ARCANEDMG" },
	{ p = "使你的火焰法術能量提高(%d+)點。", s = "FIREDMG" },
	{ p = "使你的自然法術能量提高(%d+)點。", s = "NATUREDMG" },
	{ p = "使你的冰霜法術能量提高(%d+)點。", s = "FROSTDMG" },
	{ p = "使你的暗影法術能量提高(%d+)點。", s = "SHADOWDMG" },
	{ p = "使你的神聖法術能量提高(%d+)點。", s = "HOLYDMG" },
	{ p = "提高(%d+)點秘法法術能量。", s = "ARCANEDMG" },
	{ p = "提高(%d+)點火焰法術能量。", s = "FIREDMG" },
	{ p = "提高(%d+)點自然法術能量。", s = "NATUREDMG" },
	{ p = "提高(%d+)點冰霜法術能量。", s = "FROSTDMG" },
	{ p = "提高(%d+)點暗影法術能量。", s = "SHADOWDMG" },
	{ p = "提高(%d+)點神聖法術能量。", s = "HOLYDMG" },	
	{ p = "提高秘法法術能量(%d+)點。", s = "ARCANEDMG" },
	{ p = "提高火焰法術能量(%d+)點。", s = "FIREDMG" },
	{ p = "提高自然法術能量(%d+)點。", s = "NATUREDMG" },
	{ p = "提高冰霜法術能量(%d+)點。", s = "FROSTDMG" },
	{ p = "提高暗影法術能量(%d+)點。", s = "SHADOWDMG" },
	{ p = "提高神聖法術能量(%d+)點。", s = "HOLYDMG" },	
	
	--裝備--
	--韌性等級--
	{ p = "使你的韌性等級提高(%d+)點。", s = "RESILIENCE" },
	{ p = "提高(%d+)點韌性等級。", s = "RESILIENCE" },
	{ p = "%+(%d+)韌性等級", s = "RESILIENCE" },
	
	--法術穿透力穿透--
	{ p = "使你的法術穿透力提高(%d+)點。", s = "SPELLPENETRATION" },
	{ p = "提高(%d+)點法術穿透力。", s = "SPELLPENETRATION" },
	{ p = "%+(%d+)法術穿透力", s = "SPELLPENETRATION" },
	
	--護甲穿透等級--
	{ p = "使你的護甲穿透等級提高(%d+)點。", s = "ARMORPENETRATION" },
	{ p = "提高(%d+)點護甲穿透等級。", s = "ARMORPENETRATION" },
	{ p = "%+(%d+)護甲穿透等級", s = "ARMORPENETRATION" },
	
	--致命一擊等級--
	{ p = "使你的致命一擊等級提高(%d+)點。", s = { "CRIT", "SPELLCRIT" } },
	{ p = "提高致命一擊等級(%d+)點。", s = { "CRIT", "SPELLCRIT" } },
	{ p = "%+(%d+)致命一擊等級", s = { "CRIT", "SPELLCRIT" } },
	{ p = "提高(%d+)點致命一擊等級。", s = { "CRIT", "SPELLCRIT" } },
	
	--命中等級--
	{ p = "使你的命中等級提高(%d+)點。", s = { "HIT", "SPELLHIT" } },
	{ p = "提高命中等級(%d+)點。", s = { "HIT", "SPELLHIT" } },	
	{ p = "%+(%d+)命中等級", s = { "HIT", "SPELLHIT" } },
	{ p = "提高(%d+)點命中等級。", s = { "HIT", "SPELLHIT" } },
	
	--加速等級--
	{ p = "使你的加速等級提高(%d+)點。", s = { "HASTE", "SPELLHASTE" } },
	{ p = "提高加速等級(%d+)點。", s = { "HASTE", "SPELLHASTE" } },
	{ p = "%+(%d+)加速等級", s = { "HASTE", "SPELLHASTE" } },
	{ p = "提高法術加速等級(%d+)點。", s = { "HASTE", "SPELLHASTE" } },
	{ p = "提高(%d+)點加速等級。", s = { "HASTE", "SPELLHASTE" } },
	
	--熟練等級--
	{ p = "使你的熟練等級提高(%d+)點。", s = "EXPERTISE" },
	{ p = "提高熟練等級(%d+)點。", s = "EXPERTISE" },
	{ p = "%+(%d+)熟練等級", s = "EXPERTISE" },
	
	--法術能量--
	{ p = "使你的法術能量提高(%d+)點。", s = { "SPELLDMG", "HEAL" } },
	{ p = "提高法術能量(%d+)點。", s = { "SPELLDMG", "HEAL" } },
	{ p = "提高(%d+)點法術能量。", s = { "SPELLDMG", "HEAL" } },
	{ p = "%+(%d+)法術能量", s = { "SPELLDMG", "HEAL" } },
	
	--攻擊強度--
	{ p = "使你的攻擊強度提高(%d+)點。", s = "AP" },
	{ p = "提高(%d+)點攻擊強度。", s = "AP" },
	{ p = "%+(%d+)攻擊強度", s = "AP" },
	
	--遠程攻擊強度--
	{ p = "使你的遠程攻擊強度提高(%d+)點。", s = "RAP" },
	{ p = "提高遠程攻擊強度(%d+)點。", s = "RAP" },
	{ p = "%+(%d+)遠程攻擊強度", s = "RAP" },
	
	--防禦等級--
	{ p = "使你的防禦等級提高(%d+)點。", s = "DEFENSE" },
	{ p = "提高防禦等級(%d+)點。", s = "DEFENSE" },
	{ p = "%+(%d+)防禦等級", s = "DEFENSE" },	
	{ p = "提高(%d+)點防禦等級。", s = "DEFENSE" },
--	{ p = "%+(%d+)防禦", s = "DEFENSE" },
	
	--閃躲等級--
	{ p = "使你的閃躲等級提高(%d+)點。", s = "DODGE" },
	{ p = "提高閃躲等級(%d+)點。", s = "DODGE" },
	{ p = "%+(%d+)閃躲等級", s = "DODGE" },
	{ p = "提高(%d+)點閃躲等級。", s = "DODGE" },
--	{ p = "%+(%d+)閃躲", s = "DODGE" },
	
	--招架等級--
	{ p = "使你的招架等級提高(%d+)點。", s = "PARRY" },
	{ p = "提高招架等級(%d+)點。", s = "PARRY" },
	{ p = "%+(%d+)招架等級", s = "PARRY" },
	{ p = "提高(%d+)點招架等級。", s = "PARRY" },
--	{ p = "%+(%d+)招架", s = "PARRY" },
	
	--格檔等級--
	{ p = "使你盾牌的格擋等級提高(%d+)點。", s = "BLOCK" },
	{ p = "提高你的盾牌格擋等級(%d+)點。", s = "BLOCK" },
	{ p = "%+(%d+)盾牌格擋等級", s = "BLOCK" },
	{ p = "%+(%d+)格擋等級", s = "BLOCK" },
	{ p = "提高(%d+)點盾牌格擋等級。", s = "BLOCK" },
	
	--盾牌格檔值--
	{ p = "使你盾牌的格擋值提高(%d+)點。", s = "BLOCKVALUE" },
	{ p = "提高你的盾牌格擋值(%d+)點。", s = "BLOCKVALUE" },
	{ p = "%+(%d+)盾牌格擋值", s = "BLOCKVALUE" },
	{ p = "%+(%d+)格擋值", s = "BLOCKVALUE" },
	{ p = "(%d+)格擋", s = "BLOCKVALUE" },	 --盾牌白色字體
	{ p = "提高(%d+)點盾牌格擋值。", s = "BLOCKVALUE" },

	--HP5&MP5--
	{ p = "%每5秒恢復(%d+)點生命力。", s = "HP5" },
--	{ p = "%每5秒恢復(%d+)點法力。", s = "MP5" }, 
	{ p = "%每5秒恢復(%d+)點法力", s = "MP5" }, 
	{ p = "%+(%d+)法力恢復", s = "MP5" },
	{ p = "^%+(%d+)點生命力$", s = "HP" },
	{ p = "^%+(%d+)點法力$", s = "MP" },
	{ p = "^活力$", s = { "MP5", "HP5" }, v = 4 },
	{ p = "^強效活力$", s = { "MP5", "HP5" }, v = 6 },
	--其他--
	{ p = "^兇蠻$", s = "AP", v = 70 },--武器附魔
--	{ p = "^冰行者$", s = { "CRIT", "HIT", "SPELLCRIT", "SPELLHIT" }, v = 12 },--鞋子附魔
	{ p = "^穩固$", s = { "CRIT", "HIT", "SPELLCRIT", "SPELLHIT" }, v = 10 },--鞋子附魔
	{ p = "^精準$", s = { "CRIT", "HIT", "SPELLCRIT", "SPELLHIT" }, v = 25 }, --武器附魔
	{ p = "^精確$", s = { "CRIT", "HIT", "SPELLCRIT", "SPELLHIT" }, v = 25 }, --武器附魔(待確認)
	{ p = "^靈魂冰霜$", s = { "FROSTDMG", "SHADOWDMG" }, v = 54 },--武器附魔
	{ p = "^烈日火焰$", s = { "ARCANEDMG", "FIREDMG" }, v = 50 },--武器附魔
	{ p = "%+(%d+)武器傷害", s = "WPNDMG" },
	{ p = "%+(%d+)點武器傷害", s = "WPNDMG" }, --戒指附魔
--	{ p = "^石膚石像鬼符文$", s = "DEFENSE", v = 25 }, -- 在你的雙手符文武器上附加一個符文，提高25點防禦技能以及2%的總耐力。改造你的符文武器需要黯黑堡的符文熔爐。(於09.03.16版本移除.請看更新日誌)
	{ p = "^瞄準鏡 %(%+(%d+)傷害%)$", s = "RANGEDDMG" },
	-- Demon's Blood惡魔之血
	{ p = "使防禦等級提高5點，暗影抗性提高10點和一般的生命力恢復速度提高3點。", s = { "DEFENSE", "SHADOWRESIST", "HP5" }, v = { 5, 10, 3 } },
	-- 虛無之星咒符 (術士 T5 職業飾品)
	{ p = "使你寵物的抗性提高130點，並提高你的法術能量48點。", s = { "SPELLDMG", "HEAL" }, v = 48 },	
	-- Az: these 3 was added 09.01.05 and has not been checked out in game yet, please confirm they are correct.
	{ p = "^泰坦鋼武器鍊$", s = { "HIT", "SPELLHIT" }, v = 10 },
	{ p = "^巨牙活力$", s = "STA", v = 15 }, --鞋子附魔
	{ p = "^智慧$", s = "SPI", v = 10 }, --披風附魔
	{ p = "^智慧精進$", s = "SPI", v = 10 }, --披風附魔(待確認)
	{ p = "^硝基推進器$", s = { "SPELLCRIT","CRIT" }, v = 12 },--鞋子附魔(工程學)
	{ p = "^彈性編織襯底$", s = "AGI", v = 10 },--披風附魔(工程學)(待確認)
	{ p = "^武裝者$", s = "PARRY", v = 10 },--手套附魔(待確認)
};