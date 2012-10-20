--3.2.2 update. Fixed: Armor penetration and Haste. Done by Hoofik of Ashenvale (RU). Nov 10 2009. 
--New enchants/gems added. Hoofik of AshenVale (RU) 05.01.2008;
--Updated to the new format in 3.0.*/WotLK by Hoofik of AshenVale (RU) 22.10.2008;
--Russian localization by Darigaaz of SoulFlayer(RU), 3.09.2008 
--
if (GetLocale() ~= "ruRU") then
	return;
end

LibGearExam.Patterns = {
	-- Base Stats --
	{ p = "%+(%d+) к силе$", s = "STR" },
	{ p = "%+(%d+) к ловкости", s = "AGI" },
	{ p = "%+(%d+) к выносливости", s = "STA" },
	{ p = "%+(%d+) к интеллекту", s = "INT" },
	{ p = "%+(%d+) к духу", s = "SPI" },
	{ p = "Броня: (%d+)", s = "ARMOR" }, -- Should catch all armor: Base armor, Armor enchants, Armor kits

	-- Resistances --
	{ p = "%+(%d+) к сопротивлению тайной магии", s = "ARCANERESIST" },
	{ p = "%+(%d+) к сопротивлению огню", s = "FIRERESIST" },
	{ p = "%+(%d+) к сопротивлению силам природы", s = "NATURERESIST" },
	{ p = "%+(%d+) к сопротивлению магии льда", s = "FROSTRESIST" },
	{ p = "%+(%d+) к сопротивлению темной магии", s = "SHADOWRESIST" },
	--
	{ p = "%+(%d+) ко всем видам сопротивления", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } }, -- enchants id: 28,903,65,1888,2488,2998
    { p = "%+(%d+) к сопротивлению всему", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } }, -- Void Sphere (Пустая сфера), Infinite Sphere (Абсолютная сфера), Prismatic Sphere (Призматическая сфера) & id 3095

	-- Equip: Other --
	{ p = "Рейтинг устойчивости %+(%d+)%.", s = "RESILIENCE" },
	{ p = "Рейтинг защиты %+(%d+)%.", s = "DEFENSE" },
	{ p = "Увеличение рейтинга защиты на (%d+) ед%.", s = "DEFENSE" }, --some pre bc items
	{ p = "Рейтинг уклонения %+?(%d+)%.", s = "DODGE" },
	{ p = "Увеличение рейтинга уклонения на %+?(%d+) ед%.", s = "DODGE" }, --pre bc
    { p = "Рейтинг парирования %+(%d+)%.", s = "PARRY" },
    { p = "Увеличение рейтинга парирования атак на (%d+) ед%.", s = "PARRY" }, --pre bc
	{ p = "Рейтинг блокирования щитом %+(%d+)%.", s = "BLOCK" },
	{ p = "Увеличение рейтинга блока на (%d+) ед%.", s = "BLOCK" }, -- pre bc
    { p = "Увеличение показателя блока щитом на (%d+) ед%.", s = "BLOCKVALUE" }, --pre bc
	{ p = "Блокирование: (%d+)", s = "BLOCKVALUE" }, -- Should catch only base block value from a shield 

	-- Equip: Melee & Ranged --
	{ p = "Увеличивает силу атаки на (%d+)%.", s = "AP" },
	{ p = "Сила атаки увеличена на (%d+)%.", s = "AP" },
	{ p = "Увеличивает силу атаки на (%d+) ед%. в облике кошки, медведя, лютого медведя или лунного совуха%.", s = "APFERAL" },
	{ p = "Рейтинг мастерства %+(%d+)%.", s = "EXPERTISE" },
	{ p = "Увеличивает рейтинг пробивания брони на (%d+)%.", s = "ARMORPENETRATION" },

	--  Equip: Spell Power  --
	{ p = "Увеличивает проникающую способность заклинаний на (%d+)%.", s = "SPELLPENETRATION" },
	{ p = "Увеличивает силу заклинаний на (%d+)%.", s = { "HEAL", "SPELLDMG" } },
	{ p = "Увеличивает силу заклинаний на (%d+) ед%.", s = { "HEAL", "SPELLDMG" } },
	{ p = "Слегка увеличивает силу заклинаний%.", s = { "HEAL", "SPELLDMG" }, v = 6 }, -- Bronze Band of Force (Бронзовое кольцо Силы)

	--{ p = "Increases arcane spell power by (%d+)%.", s = "ARCANEDMG" },
	--{ p = "Increases fire spell power by (%d+)%.", s = "FIREDMG" },
	--{ p = "Increases nature spell power by (%d+)%.", s = "NATUREDMG" },
	--{ p = "Increases frost spell power by (%d+)%.", s = "FROSTDMG" },
	--{ p = "Increases shadow spell power by (%d+)%.", s = "SHADOWDMG" },
	{ p = "Увеличивает силу заклинаний светлой магии на (%d+)%.", s = "HOLYDMG" },

	--  Equip: Stats Which Improves Both Spells & Melee  --
	{ p = "Рейтинг критического удара %+(%d+)%.", s = { "CRIT", "SPELLCRIT" } },
	{ p = "Рейтинг меткости %+(%d+)%.", s = { "HIT", "SPELLHIT" } },
	{ p = "Рейтинг скорости боя %+(%d+)%.", s = { "HASTE", "SPELLHASTE" } },
	{ p = "%+(%d+) к критическому удару в дальнем бою", s = { "CRIT", "SPELLCRIT" } }, --Heartseeker Scope (Прицел "Сердцелов")
	{ p = "%+(%d+) к рейтингу скорости боя дальнего боя", s = { "HASTE", "SPELLHASTE" } }, --Micro Stabilizer (Микростабилизатор)


	--  Health & Mana Per 5 Sec  --
	{ p = "%+(%d+) ед%. здоровья каждые 5 секунд", s = "HP5" },
	{ p = "%+(%d+) ед%. маны каждые 5 секунд", s = "MP5" }, -- Royal Shadow Draenite (Королевский сумеречный дренит), Magister's Armor Kit (Накладки для брони магистра), Royal Shadow Draenite (Королевский сумеречный дренит)
	{ p = "%+(%d+) к восполнению маны", s = "MP5" }, -- id 2992
	{ p = "Восполнение (%d+) ед%. маны каждые 5 секунд%.", s = "MP5" }, -- id 2565 (Enchant Bracer - Mana Regeneration)
	{ p = "Восполнение (%d+) ед%. маны раз в 5 секунд%.", s = "MP5" },
	{ p = "%+(%d+) маны каждые 5 секунд", s = "MP5" }, -- Scryer Shoulder Enchant, Priest ZG Enchant, Inscription of the Crag, Dazzling Deep Peridot
	{ p = "(%d+) ед%. маны каждые 5 секунд", s = "MP5" }, --id 2679 (Enchant Bracer - Restore Mana Prime)
	
	--  Enchants / Gems / Socket Bonuses / Mixed / Misc  --
	{ p = "^%+(%d+) ЗД", s = "HP" }, -- id 1503
	{ p = "^%+(%d+) к здоровью", s = "HP" },
	{ p = "^%+(%d+) к мане", s = "MP" },
	
	-- id 1524: "+75/14 ЗД/СО" means 75 HP, 14 Fire Resistance --
	{ p = "^%+(%d+)/14 ЗД/СО", s = "HP" },
	{ p = "^%+75/(%d+) ЗД/СО", s = "FIRERESIST" },
	--
	{ p = "^Живучесть$", s = { "MP5", "HP5" }, v = 4 },
	{ p = "^Живучесть 2$", s = { "MP5", "HP5" }, v = 6 },
	{ p = "^Мудрость$", s = "SPI", v = 10 },
	{ p = "^Выносливость клыкара$", s = "STA", v = 15 },
	{ p = "^Свирепость$", s = "AP", v = 70 },
	{ p = "^Ледяная душа$", s = { "FROSTDMG", "SHADOWDMG" }, v = 54 },
	{ p = "^Солнечный огонь$", s = { "ARCANEDMG", "FIREDMG" }, v = 50 },
	{ p = "^Ледопроходец$", s = { "CRIT", "HIT" }, v = 12 },
	{ p = "^Точность$", s = { "CRIT", "HIT" }, v = 25 },
	
	{ p = "%+(%d+) ко всем характеристикам", s = { "STR", "AGI", "STA", "INT", "SPI" } }, -- Chest + Bracer Enchant

	--{ p = "%+(%d+) Arcane S?p?e?l?l? ?Damage", s = "ARCANEDMG" },
	--{ p = "%+(%d+) Fire S?p?e?l?l? ?Damage", s = "FIREDMG" },
	--{ p = "%+(%d+) Nature S?p?e?l?l? ?Damage", s = "NATUREDMG" },
	--{ p = "%+(%d+) Frost S?p?e?l?l? ?Damage", s = "FROSTDMG" },
	--{ p = "%+(%d+) Shadow S?p?e?l?l? ?Damage", s = "SHADOWDMG" },
	--{ p = "%+(%d+) Holy S?p?e?l?l? ?Damage", s = "HOLYDMG" },

	{ p = "%+(%d+) к защите", s = "DEFENSE" },
	{ p = "%+24 к защите", s = "STA", v = 24 }, -- +24 Sta (ring enchant) - bug in ruRU localisation. "защите" (defense) instead of "выносливости" (stamina)
	{ p = "%+(%d+) к рейтингу уклонения", s = "DODGE" },
	{ p = "%+(%d+) к рейтингу парирования", s = "PARRY" },
	{ p = "%+(%d+) к броне", s = "ARMOR" }, --id 2716 (Fortitude of the Scourge)
	{ p = "%+(%d+) к рейтингу блока ?щ?и?т?о?м?", s = "BLOCK" }, -- Combined Pattern: Covers [Shield Enchant] [Socket Bonus]
	{ p = "%+(%d+) к блокированию ?щ?и?т?о?м?", s = "BLOCK" }, --id 2583
	{ p = "%+(%d+) к блоку", s = "BLOCKVALUE" }, -- id 2975,2888
	{ p = "%+(%d+) к силе атаки", s = "AP" },
	
	{ p = "%+(%d+) к рейтингу меткости", s = { "HIT", "SPELLHIT" } },
	{ p = "%+(%d+) к рейтингу критического удара", s = { "CRIT", "SPELLCRIT" } },
	{ p = "%+(%d+) у рейтингу критического удара", s = { "CRIT", "SPELLCRIT" } }, -- bug in ruRU localisation, Icescale Leg Armor (Накладки для поножей из ледяной чешуи)
	--{ p = "%+(%d+) к рейтингу скорости боя", s = { "HASTE", "SPELLHASTE" } },
	{ p = "%+(%d+) к рейтингу скорости", s = { "HASTE", "SPELLHASTE" } },
	{ p = "Рейтинг скорости %+(%d+)%.", s = { "HASTE", "SPELLHASTE" } },
	{ p = "%+(%d+) к рейтингу мастерства", s = "EXPERTISE" },
	{ p = "%+(%d+) к ?р?е?й?т?и?н?г?у? устойчивости", s = "RESILIENCE" }, -- id 3087,2789,2801,2788 without "рейтингу"

	{ p = "%+(%d+) к силе заклинаний", s = { "SPELLDMG", "HEAL" } }, -- Was used in a few items/gems before WotLK, but is now the permanent spell pattern
	{ p = "%+(%d+) к проникающей способности заклинаний", s = "SPELLPENETRATION" },

	-- Should no longer be relavent for WotLK, but keeping them in case something turns up on enchants I've yet to see
	--{ p = "%+(%d+) Healing", s = "HEAL" }, -- Has to appear before patterns with a SPELLDMG entry, due to the workaround
	--{ p = "%+(%d+) Healing and Spell Damage", s = "SPELLDMG" }, -- Warlock ZG Enchant (Healing will be caught by the pattern above)
	--{ p = "Spell Damage %+(%d+)", s = { "SPELLDMG", "HEAL" } }, -- WORKAROUND: Infused Amethyst (31116)
	--{ p = "%+(%d+) Spell Damage", s = { "SPELLDMG", "HEAL" } },
	--{ p = "%+(%d+) Damage and Healing Spells", s = { "SPELLDMG", "HEAL" } },
	--{ p = "%+(%d+) Damage Spells", s = "SPELLDMG" }, -- New 2.3: Damage part of the previously "+Healing" enchants

	{ p = "%+(%d+) к урону ?о?р?у?ж?и?е?м?", s = "WPNDMG" },
	{ p = "^Прицел %(%+(%d+) урону%)$", s = "RANGEDDMG" },
	{ p = "^Титановая цепь для оружия", s = { "HIT", "SPELLHIT" }, v = 28 },


	-- Demon's Blood
	{ p = "Усиление защиты на 5 ед%., сопротивления темной магии - на 10 ед%. и скорости восполнения здоровья - на 3%.", s = { "DEFENSE", "SHADOWRESIST", "HP5" }, v = { 5, 10, 3 } },

	-- Void Star Talisman
	{ p = "Увеличивает сопротивление прислужника магии на 130, а вашу силу заклинаний - на 48%.", s = "SPELLDMG", v = 48 },

	-- Temp Enchants (Disabled as they are not part of "gear" stats)
	--{ p = "Minor Mana Oil", s = "MP5", v = 4 },
	--{ p = "Lesser Mana Oil", s = "MP5", v = 8 },
	--{ p = "Superior Mana Oil", s = "MP5", v = 14 },
	--{ p = "Brilliant Mana Oil", s = { "MP5", "HEAL" }, v = { 12, 25 } },

	--{ p = "Minor Wizard Oil", s = "SPELLDMG", v = 8 },
	--{ p = "Lesser Wizard Oil", s = "SPELLDMG", v = 16 },
	--{ p = "Wizard Oil", s = "SPELLDMG", v = 24 },
	--{ p = "Superior Wizard Oil", s = "SPELLDMG", v = 42 },
	--{ p = "Brilliant Wizard Oil", s = { "SPELLDMG", "SPELLCRIT" }, v = { 36, 14 } },

	-- Future Patterns (Disabled)
	--{ p = "When struck in combat inflicts (%d+) .+ damage to the attacker.", s = "DMGSHIELD" },
};