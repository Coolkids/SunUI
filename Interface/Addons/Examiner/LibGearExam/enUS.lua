-- For enchant and gem IDs, check out the following link: http://www.wowwiki.com/EnchantId

LibGearExam.Patterns = {
	--  Base Stats  --
	{ p = "([+-]%d+) Strength", s = "STR" },
	{ p = "([+-]%d+) Agility", s = "AGI" },
	{ p = "([+-]%d+) Stamina", s = "STA" },
	{ p = "([+-]%d+) Intellect", s = "INT" },
	{ p = "([+-]%d+) Spirit", s = "SPI" },
	{ p = "(%d+) Armor", s = "ARMOR" }, -- Should catch all armor: Base armor, Armor enchants, Armor kits

	{ p = "Increases Intellect by (%d+)", s = "INT" },	-- Found on old set bonuses which used to have spellpower. For example item:23304

	--  Resistances (Exclude the Resist-"ance" then it picks up armor patches as well)  --
	{ p = "%+(%d+) Arcane Resist", s = "ARCANERESIST" },
	{ p = "%+(%d+) Fire Resist", s = "FIRERESIST" },
	{ p = "%+(%d+) Nature Resist", s = "NATURERESIST" },
	{ p = "%+(%d+) Frost Resist", s = "FROSTRESIST" },
	{ p = "%+(%d+) Shadow Resist", s = "SHADOWRESIST" },
	{ p = "%+(%d+) t?o? ?All Resistances", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } },	-- Seen on cloak enchants for example -- Added optional "to " to match item:12065
	{ p = "%+(%d+) Resist All", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } }, -- Void Sphere

	--  Equip: Mastery  --
	{ p = "Increases your mastery rating by (%d+)%.", s = "MASTERY" },
	{ p = "(%d+) Mastery [Rr]ating", s = "MASTERY" },	-- Lower caps found on head enchant, capitalised string found on Gems & Enchants

	--  Equip: Other  --
	{ p = "Improves your resilience rating by (%d+)%.", s = "RESILIENCE", alert = 1 },
	{ p = "Increases your resilience rating by (%d+)%.", s = "RESILIENCE" },

	{ p = "Increases defense rating by (%d+)%.", s = "DEFENSE", alert = 1 },
	{ p = "Increases your dodge rating by (%d+)%.", s = "DODGE" },
	{ p = "Increases your parry rating by (%d+)%.", s = "PARRY" },
	{ p = "Increases your s?h?i?e?l?d? ?block rating by (%d+)%.", s = "BLOCK", alert = 1 }, -- Should catch both new and old style

	{ p = "Increases the block value of your shield by (%d+)%.", s = "BLOCKVALUE", alert = 1 },
	{ p = "^(%d+) Block$", s = "BLOCKVALUE" }, -- Should catch only base block value from a shield

	--  Equip: Melee & Ranged  --
	{ p = "Increases attack power by (%d+)%.", s = "AP" },
	{ p = "Increases ranged attack power by (%d+)%.", s = "RAP" },	-- (4.0) This stat is still found on some items, 19361 is one of them

	{ p = "Increases your expertise rating by (%d+)%.", s = "EXPERTISE" }, -- New 2.3 Stat
	{ p = "Increases y?o?u?r? ?armor penetration rating by (%d+)%.", s = "ARMORPENETRATION", alert = 1 }, -- Armor Penetration in 3.0

	--  Equip: Spell Power  --
	{ p = "Increases your spell penetration by (%d+)%.", s = "SPELLPENETRATION", alert = 1 },	-- Still exists on "Don Rodrigo's Band" (21563) -- Fixed in MoP or earlier

	{ p = "Increases spell power by (%d+)%.", s = "SPELLDMG" },
	{ p = "Increases spell power slightly%.", s = "SPELLDMG", v = 6, alert = 1 }, -- Bronze Band of Force

	{ p = "%+(%d+) Shadow and Frost Spell Power", s = { "FROSTDMG", "SHADOWDMG" } },	-- Soulfrost enchant
	{ p = "%+(%d+) Arcane and Fire Spell Power", s = { "ARCANEDMG", "FIREDMG" } },		-- Sunfire enchant

	{ p = "Increases arcane spell power by (%d+)%.", s = "ARCANEDMG", alert = 1 },
	{ p = "Increases fire spell power by (%d+)%.", s = "FIREDMG", alert = 1 },
	{ p = "Increases nature spell power by (%d+)%.", s = "NATUREDMG", alert = 1 },
	{ p = "Increases frost spell power by (%d+)%.", s = "FROSTDMG", alert = 1 },
	{ p = "Increases shadow spell power by (%d+)%.", s = "SHADOWDMG", alert = 1 },
	{ p = "Increases holy spell power by (%d+)%.", s = "HOLYDMG", alert = 1 },

	--  Equip: Stats Which Improves Both Spells & Melee  --
	{ p = "Increases your critical strike rating by (%d+)%.", s = { "CRIT", "SPELLCRIT" } },
	{ p = "Improves critical strike rating by (%d+)%.", s = { "CRIT", "SPELLCRIT" }, alert = 1 },
	{ p = "Increases your hit rating by (%d+)%.", s = { "HIT", "SPELLHIT" } },
	{ p = "Improves hit rating by (%d+)%.", s = { "HIT", "SPELLHIT" }, alert = 1 },
	{ p = "Increases your haste rating by (%d+)%.", s = { "HASTE", "SPELLHASTE" } },
	{ p = "Improves haste rating by (%d+)%.", s = { "HASTE", "SPELLHASTE" }, alert = 1 },

	--  Health & Mana Per 5 Sec  --
	{ p = "(%d+) health every 5 sec%.", s = "HP5", alert = 1 },
	{ p = "(%d+) [Hh]ealth per 5 sec%.", s = "HP5" }, -- Seen on the revamped Demon's Blood in Cataclysm, as well as Onyxia Blood Talisman -- Omited "Restores..." to catch several patterns

	{ p = "%+(%d+) Mana Regen", s = "MP5", alert = 1 }, -- Scryer Shoulder Enchant, Priest ZG Enchant
	{ p = "%+(%d+) Mana restored per 5 seconds", s = "MP5", alert = 1 }, -- Magister's Armor Kit

	{ p = "%+(%d+) Health and Mana every 5 sec", s = { "HP5", "MP5" } },	-- Old Vitality enchant changed into this pattern

	{ p = "%+?(%d+) [Mm]ana per 5 [Ss]econds", s = "MP5", alert = 1 }, -- Gem: Royal Shadow Draenite / Wyrmrest head enchant
	{ p = "Mana Regen (%d+) per 5 sec%.", s = "MP5", alert = 1 }, -- Bracer Enchant
	{ p = "%+(%d+) Mana/5 seconds", s = "MP5", alert = 1 }, -- Some WotLK Shoulder Enchant, unsure which

	{ p = "(%d+) [Mm]ana [Pp]er 5 [Ss]ec%.|-r-$", s = "MP5" }, -- Combined Pattern: Covers [Equip Bonuses] [Socket Bonuses] [Random Items] --- Added "|-r-$" to avoid confusing on item 33502
	{ p = "(%d+) [Mm]ana every 5 [Ss]ec", s = "MP5" }, -- Combined Pattern: Covers [Chest Enchant] [Gem: Dazzling Deep Peridot] [Various Gems] -- Az: 09.01.05 removed the "%+" at the start.

	--  Enchants / Gems / Socket Bonuses / Mixed / Misc  --
	{ p = "^%+(%d+) HP$", s = "HP" },
	{ p = "^%+(%d+) Health$", s = "HP" },
	{ p = "^%+(%d+) Mana$", s = "MP" },

	{ p = "^Titanium Plating$", s = "PARRY", v = 26 },
	{ p = "^Adamantite Weapon Chain$", s = "PARRY", v = 15 },
	{ p = "^Titanium Weapon Chain$", s = { "HIT", "SPELLHIT" }, v = 28 },
	{ p = "^Pyrium Weapon Chain$", s = { "HIT", "SPELLHIT" }, v = 40 },

	{ p = "%+(%d+) t?o? ?All Stats", s = { "STR", "AGI", "STA", "INT", "SPI" } }, -- Chest + Bracer Enchant

	{ p = "%+(%d+) Arcane S?p?e?l?l? ?Damage", s = "ARCANEDMG" },
	{ p = "%+(%d+) Fire S?p?e?l?l? ?Damage", s = "FIREDMG" },
	{ p = "%+(%d+) Nature S?p?e?l?l? ?Damage", s = "NATUREDMG" },
	{ p = "%+(%d+) Frost S?p?e?l?l? ?Damage", s = "FROSTDMG" },
	{ p = "%+(%d+) Shadow S?p?e?l?l? ?Damage", s = "SHADOWDMG" },
	{ p = "%+(%d+) Holy S?p?e?l?l? ?Damage", s = "HOLYDMG" },

	{ p = "%+(%d+) Defense", s = "DEFENSE", alert = 1 }, -- Exclude "Rating" from this pattern due to Paladin ZG Enchant
	{ p = "%+(%d+) Dodge Rating", s = "DODGE" },
	{ p = "(%d+) Parry Rating", s = "PARRY" }, -- Az: plus sign no longer needed for a match
	{ p = "%+(%d+) Block Rating", s = "BLOCK" }, -- Combined Pattern: Covers [Shield Enchant] [Socket Bonus]
	{ p = "%+(%d+) Shield Block Rating", s = "BLOCK", alert = 1 }, -- Combined Pattern: Covers [Shield Enchant] [Socket Bonus]

	{ p = "%+(%d+) Block Value", s = "BLOCKVALUE", alert = 1 },

	{ p = "%+(%d+) Attack Power", s = "AP" },	-- Found on enchants
	{ p = "%+(%d+) Ranged Attack Power", s = "RAP" },	-- Still exists on the hunter ZG enchant (2586)
	{ p = "%+(%d+) Hit Rating", s = { "HIT", "SPELLHIT" } },
	{ p = "%+(%d+) Crit Rating", s = { "CRIT", "SPELLCRIT" } },
	{ p = "%+(%d+) Critical S?t?r?i?k?e? ?Rating", s = { "CRIT", "SPELLCRIT" } }, -- Matches two versions, with/without "Strike". No "Strike" on "Unstable Citrine"
	{ p = "(%d+) Critical strike rating%.", s = { "CRIT", "SPELLCRIT" } }, -- Kirin Tor head enchant, no "+" sign, lower case "s" and "r"
	{ p = "%+(%d+) [Rr]esilience", s = "RESILIENCE" },	-- PvP Set bonus uses "resilience" so match lower case "r" as well.
	{ p = "%+(%d+) Haste Rating", s = { "HASTE", "SPELLHASTE" } },
	{ p = "%+(%d+) Expertise Rating", s = "EXPERTISE" },
	{ p = "%+(%d+) Armor Penetration Rating", s = "ARMORPENETRATION", alert = 1 },

	{ p = "%+(%d+) Spell Power", s = "SPELLDMG" }, -- Was used in a few items/gems before WotLK, but is now the permanent spell pattern
	{ p = "%+(%d+) Spell Hit", s = "SPELLHIT" }, -- Exclude "Rating" from this pattern to catch Mage ZG Enchant
	{ p = "%+(%d+) Spell Crit Rating", s = "SPELLCRIT", alert = 1 },
	{ p = "%+(%d+) Spell Critical ", s = "SPELLCRIT", alert = 1 }, -- Matches three versions, with Strike + Rating, with Rating, and without any suffix at all
	{ p = "%+(%d+) Spell Haste Rating", s = "SPELLHASTE", alert = 1 }, -- Found on gems
	{ p = "%+(%d+) Spell Penetration", s = "SPELLPENETRATION" },	-- Found on gems

	{ p = "%+(%d+)  ?Weapon Damage", s = "WPNDMG" }, -- Added optional space as enchant #250 has an extra space: "+1  Weapon Damage"
	{ p = "^Scope %(%+(%d+) Damage%)$", s = "RANGEDDMG" },

	-- Void Star Talisman (Warlock T5 Class Trinket)
	{ p = "Increases your pet's resistances by 130 and increases your spell power by 48%.", s = "SPELLDMG", v = 48 },
};