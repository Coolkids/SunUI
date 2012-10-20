-- German localization by Haldamir of Gorgonnash, 19.6. 2007
-- Modified by xonyx (aka Siphony of EU-Onyxia) for Patch 2.3, 15.11.2007 & 25.12.2007
-- Modified by Maxfunkey (aka Carambha of EU-Lordearon) for patch 3.0.2, October 30th 2008 & November 1st 2008
-- Modified by Thorakon (aka Pulgrim of EU-Alexstrasza) for WotLk, Patch 3.0.3, 13.12.2008

if (GetLocale() ~= "deDE") then
	return;
end

LibGearExam.Patterns = {
	-- Base stats
	{ p = "%+(%d+) St\195\164rke", s = "STR" },
	{ p = "%+(%d+) Beweglichkeit", s = "AGI" },
	{ p = "%+(%d+) Ausdauer", s = "STA" },
	-- { p = "Ausdauer %+(%d+)", s = "STA" }, -- WORKAROUND: Infused Amethyst (31116) => Energieerfüllter Amethyst (Thorakon: No longer needed with WotLk 3.0.3)		
	{ p = "%+(%d+) Intelligenz", s = "INT" },
	{ p = "%+(%d+) Willenskraft", s = "SPI" },
	{ p = "(%d+) R\195\188stung", s = "ARMOR" }, -- Should catch all armor: Base armor, Armor enchants, Armor kits

	-- Resistances (Exclude the Resist-"ance" then it picks up armor patches as well)
	{ p = "%+(%d+) Arkanwiderstand", s = "ARCANERESIST" },
	{ p = "%+(%d+) Feuerwiderstand", s = "FIRERESIST" },
	{ p = "%+(%d+) Naturwiderstand", s = "NATURERESIST" },
	{ p = "%+(%d+) Frostwiderstand", s = "FROSTRESIST" },
	{ p = "%+(%d+) Schattenwiderstand", s = "SHADOWRESIST" },
	{ p = "%+(%d+) Alle Widerstandsarten", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } },
	-- Void Sphere => Sphäre der Leere (already covered by "Alle Widerstandsarten")

	-- Equip: Other
	{ p = "Erh\195\182ht Eure Abh\195\164rtungswertung um (%d+)%.", s = "RESILIENCE" },
	-- { p = "+(%d+) Abh\195\164rtungswertung%.", s = "RESILIENCE" }, -- MF:covers enchants and gems as well; Thora: causes double scan of set boni?

	{ p = "Erh\195\182ht die Verteidigungswertung um (%d+)%.", s = "DEFENSE" },
	{ p = "%+15 Ausweichwertung und Verteidigungswertung %+(%d+)", s = "DEFENSE" }, -- Thora: WotLk Shoulder Enchant
	-- { p = "+(%d+) Verteidigungswertung%.", s = "DEFENSE" }, -- MF:covers enchants and gems as well
	{ p = "Erh\195\182ht Eure Ausweichwertung um (%d+)%.", s = "DODGE" },
	-- { p = "+(%d+) Ausweichwertung%.", s = "DODGE" },
	{ p = "Erh\195\182ht Eure Parierwertung um (%d+)%.", s = "PARRY" },
	-- { p = "+(%d+) Parierwertung%.", s = "PARRY" },
	{ p = "Erh\195\182ht Eure Blockwertung um (%d+)%.", s = "BLOCK" },
	-- { p = "+(%d+) Blockwert%.", s = "BLOCK" },

	{ p = "Erh\195\182ht den Blockwert Eures Schildes um (%d+)%.", s = "BLOCKVALUE" },
	{ p = "^(%d+) Blocken$", s = "BLOCKVALUE" }, -- Should catch only base block value from a shield -- translated by g3gg0
	-- { p = "+(%d+) Block$.", s = "BLOCKVALUE" }, -- MF: accepts enchants and possible +blockvalue-gems as well


	-- Equip: Melee & Ranged
	{ p = "Erh\195\182ht die Angriffskraft um (%d+)%.", s = "AP" },
	{ p = "Erh\195\182ht Angriffskraft um (%d+)%.", s = "AP" }, -- Thora: New WotLK Pattern
	{ p = "Erh\195\182ht Eure Angriffskraft um (%d+)%.", s = "AP" }, -- Thora: New WotLK Pattern
	{ p = "Erh\195\182ht die Distanzangriffskraft um (%d+)%.", s = "RAP" },
	{ p = "Erh\195\182ht die Angriffskraft in Katzengestalt, B\195\164rengestalt, Terrorb\195\164rengestalt oder Mondkingestalt um (%d+)%.", s = "APFERAL" },
    --{ p = "Erh\195\182ht die Angriffskraft in Untotengestalt oder Zombiegestalt um (%d+)%.", s = "APUNDEAD" }, -- MF: unused for now

	{ p = "Erh\195\182ht Eure Waffenkundewertung um (%d+)%.", s = "EXPERTISE" },
	{ p = "Erh\195\182ht Euren R\195\188stungsdurchschlag$ um (%d+)%.", s = "ARMORPENETRATION" },
	{ p = "Erh\195\182ht den R\195\188stungsdurchschlagwert um (%d+)%.", s = "ARMORPENETRATION" }, -- Thora: New pattern in WotLk
	{ p = "Erh\195\182ht Eure R\195\188stungsdurchschlagwertung um (%d+)%.", s = "ARMORPENETRATION" }, -- Thora: New pattern in WotLk
	{ p = "+(%d+) R\195\188stungsdurchschlagwertung", s = "ARMORPENETRATION" }, -- Thora: New pattern in WotLk (Gems)
	{ p = "+(%d+) R\195\188stungsdurchschlag%.", s = "ARMORPENETRATION" },

    --  Equip: Stats Which Improves Both Spells & Melee
	{ p = "Erh\195\182ht kritische Trefferwertung um (%d+)%.", s = { "SPELLCRIT", "CRIT" } },  
	{ p = "+(%d+) kritische Trefferwertung%.", s = {"SPELLCRIT", "CRIT" } },
	{ p = "+(%d+) kritische Trefferwertung", s = {"SPELLCRIT", "CRIT" } }, -- Thora: not "." on Leg enchant etc.
	{ p = "Erh\195\182ht Eure kritische Trefferwertung um (%d+)%.", s = { "SPELLCRIT", "CRIT" } },
	{ p = "Erh\195\182ht Trefferwertung um (%d+)%.", s = { "SPELLHIT", "HIT" } },
	{ p = "+(%d+) Trefferwertung%.", s = { "SPELLHIT", "HIT" } },
	{ p = "Erh\195\182ht Eure Trefferwertung um (%d+)%.", s = { "SPELLHIT", "HIT" } },

	{ p = "Erh\195\182ht Tempowertung um (%d+)%.", s = {"SPELLHASTE", "HASTE" } },
	{ p = "+(%d+) Tempowertung%.", s = { "SPELLHASTE", "HASTE" } },

    -- Equip (Magic only)
	{ p = "Erh\195\182ht Eure Zauberdurchschlagskraft um (%d+)%.", s = "SPELLPENETRATION" },
	{ p = "Erh\195\182ht Euren Zauberdurchschlag$ um (%d+)%.", s = "SPELLPENETRATION" }, -- MF: covers the alternate spelling as well now

	{ p = "Erh\195\182ht die Zaubermacht um (%d+)%.", s = { "HEAL", "SPELLDMG" } }, -- Mf: maybe I could add some conversion to the old addheal later on? (Thora: would only be missleading in my opinion, healers should be accustomed to spellpower by now)
	{ p = "Erh\195\182ht Zaubermacht um (%d+)%.", s = { "HEAL", "SPELLDMG" } }, -- Thora: new WotLk pattern
	{ p = "Erh\195\182ht Eure Zaubermacht um (%d+)%.", s = { "HEAL", "SPELLDMG" } }, -- Thora: new WotLk pattern (Set Bonus of i=41554 etc.)
	{ p = "Erh\195\182ht die Zaubermacht leicht%.", s = { "SPELLDMG", "HEAL" }, v = 6 }, -- Bronze Band of Force => Bronzeband der Kraft

	
	--  Health & Mana Per 5 Sec  -- (xonyx: Different than the Englisch version; Thora: Maybe some of these are no longer used?)
	{ p = "Stellt alle 5 Sek%. %+(%d+) Mana wieder her%.", s = "MP5" },
	{ p = "+(%d+) Mana alle 5 Sekunden%.", s = "MP5" }, 
	{ p = "(%d+) Mana alle 5 Sek", s = "MP5" },
	{ p = "(%d+) Mana alle 5 Sekunden", s = "MP5" },
	{ p = "(%d+) Mana per 5 Sek%.", s = "MP5" }, -- Covers equip bonus as well as socket bonus
	{ p = "Mana Regeneration (%d+) alle 5 Sek%.", s = "MP5" },
	{ p = "alle 5 Sek%. (%d+) Mana", s = "MP5" },
	{ p = "Alle 5 Sek%. (%d+) Mana", s = "MP5" },
	{ p = "+(%d+) Manaregeneration%.", s = "MP5" },
	{ p = "Erhöht Eure Manaregeneration um +(%d+)%.", s = "MP5" }, -- Thora: New pattern in WotLk

	{ p = "+(%d) Gesundheit alle 5 Sek%.", s = "HP5" },
	{ p = "Stellt alle 5 Sek%. (%d+) Gesundheit wieder her%.", s = "HP5" },

	-- Enchants / Gems / Socket Bonuses / Mixed / Misc
	{ p = "^%+(%d+) GP$", s = "HP" }, -- Thora: The following 3 were scanned 2 times before, I left them here and deleted the duplicated
	{ p = "^%+(%d+) Gesundheit$", s = "HP" },
	{ p = "^%+(%d+) Mana$", s = "MP" },

	{ p = "^Seelenfrost$", s = { "FROSTDMG", "SHADOWDMG" }, v = 54 },
	{ p = "^Sonnenfeuer$", s = { "ARCANEDMG", "FIREDMG" }, v = 50 },
	{ p = "^Vitalit\195\164t$", s = { "MP5", "HP5" }, v = 4 },
	{ p = "^Eiswandler$", s = { "HIT", "SPELLHIT", "CRIT", "SPELLCRIT" }, v = 12 },
	{ p = "^Unb\195\164ndigkeit$", s = "AP", v = 70 }, -- Thora: BC Enchant, greater version is displayed as "+85 Angriffskraft"
	{ p = "^Schnelligkeit der Katze$", s = "AGI", v = 6 }, --Thora: BC Enchant, not sure if this is needed, or if it is displayed as 6 Agi + Runspeed now
	{ p = "^Vitalit\195\164t der Tuskarr$", s = "STA", v = 15 }, -- Thora: New WotLK Recipe

	{ p = "%+(%d+) Alle Werte", s = { "STR", "AGI", "STA", "INT", "SPI" } },

	{ p = "%+(%d+) Arkanzauber", s = "ARCANEDMG" },
	{ p = "%+(%d+) Feuerschaden", s = "FIREDMG" },
	{ p = "%+(%d+) Naturschaden", s = "NATUREDMG" },
	{ p = "%+(%d+) Frostschaden", s = "FROSTDMG" },
	{ p = "%+(%d+) Schattenschaden", s = "SHADOWDMG" },
	{ p = "%+(%d+) Heiligschaden", s = "HOLYDMG" },

	{ p = "%+(%d+) Verteidigung", s = "DEFENSE" }, -- Exclude "Rating" from this pattern due to Paladin ZG Enchant
	{ p = "%+(%d+) Ausweichwertung", s = "DODGE" },
	{ p = "%+(%d+) Parierwertung", s = "PARRY" },
	{ p = "%+(%d+) Blockwertung", s = "BLOCK" },
	{ p = "%+(%d+) Blockwert$", s = "BLOCKVALUE" }, -- workaround by g3gg0
	{ p = "%+(%d+) Blockwert ", s = "BLOCKVALUE" }, -- workaround by g3gg0

	{ p = "%+(%d+) Angriffskraft", s = "AP" },
	{ p = "%+(%d+) Distanzangriffskraft", s = "RAP" },
	-- { p = "%+(%d+) Trefferwertung", s = "HIT" }, -- Thora: Covered below (melee and caster stat is the same now)
	-- { p = "%+(%d+) Crit Rating", s = "CRIT" }, -- Thora: Can't imagine this is used in German version
	-- { p = "%+(%d+) Kritische Trefferwertung", s = "CRIT" }, -- Thora: Covered below (melee and caster stat is the same now)
	{ p = "%+(%d+) Abh\195\164rtung", s = "RESILIENCE" },
	-- { p = "%+(%d+) Tempowertung", s = "HASTE" }, -- Thora: Covered below (melee and caster stat is the same now)
	{ p = "%+(%d+) Waffenkundewertung", s = "EXPERTISE" },

	
	{ p = "%+(%d+) Zaubermacht", s = { "SPELLDMG", "HEAL" } },
	
	-- Should no longer be relavent for WotLK, but keeping them in case something turns up on enchants I've yet to see
	-- { p = "%+(%d+) Schadenszauber", s = "SPELLDMG" },
	-- { p = "%+(%d+) Zauberkraft", s = { "SPELLDMG", "HEAL" } }, 
	-- { p = "%+(%d+) Schaden und Heilzauber", s = { "SPELLDMG", "HEAL" } },
	-- { p = "%+(%d+) Heilung", s = "HEAL" },
	-- { p = "%+(%d+) Heilzauber", s = "HEAL" },
	{ p = "%+(%d+) Trefferwertung", s = { "SPELLHIT", "HIT" } }, -- works fine now with Mage ZG enchant
	{ p = "%+(%d+) Kritische Trefferwertung", s = { "SPELLCRIT", "CRIT" } },
	{ p = "%+(%d+) Tempowertung", s = { "HASTE", "SPELLHASTE" } },
	-- { p = "%+(%d+) Critical Rating", s = "SPELLCRIT", "CRIT" }, -- Thora: Can't imagine this is used in German version
	-- { p = "%+(%d+) Critical Strike Rating", s = "SPELLCRIT", "CRIT" }, -- Thora: Can't imagine this is used in German version
	{ p = "%+(%d+) Zauberdurchschlagskraft", s = "SPELLPENETRATION" },


	{ p = "%+(%d+) Waffenschaden", s = "WPNDMG" },
	{ p = "+(%d+) Distanzwaffenschaden%.", s = "RANGEDDMG" },
	{ p = "^Zielfernrohr %(%+(%d+) Schaden%)$", s = "RANGEDDMG" }, -- translated by g3gg0

	-- Dämonenblut (Demons's Blood) 
	{ p = "Verbessert Verteidigungswertung um 5, Schattenwiderstand um 10 sowie Eure normale Gesundheitsregeneration um 3%.", s = { "DEFENSE", "SHADOWRESIST", "HP5" }, v = { 5, 10, 3 } },
	
	-- Void Star Talisman (Warlock T5 Class Trinket)
	{ p = "Erh\195\182ht die Widerst\195\164nde Eures Begleiters um 130 und Eure Zaubermacht um bis zu 48%.", s = { "SPELLDMG", "HEAL" }, v = 48 }, 

	-- Temp Enchants (Disabled as they are not part of "gear" stats)
	--{ p = "Schwaches Mana\195\182l", s = "MP5", v = 4 },
	--{ p = "Geringes Mana\195\182l", s = "MP5", v = 8 },
	--{ p = "\195\156berragendes Mana\195\182l", s = "MP5", v = 14 },
	--{ p = "Hervorragendes Mana\195\182l", s = { "MP5", "HEAL" }, v = { 12, 25 } },

	--{ p = "Schwaches Zauber\195\182l", s = "SPELLDMG", v = 8 },
	--{ p = "Geringes Zauber\195\182l", s = "SPELLDMG", v = 16 },
	--{ p = "Zauber\195\182l", v = 24 },
	--{ p = "\195\156berragendes Zauber\195\182l", s = "SPELLDMG", v = 42 },
	--{ p = "Hervorragendes Zauber\195\182l", s = { "SPELLDMG", "SPELLCRIT" }, v = { 36, 14 } },

	-- Future Patterns (Disabled)
	--{ p = "When struck in combat inflicts (%d+) .+ damage to the attacker.", s = "DMGSHIELD" },
};