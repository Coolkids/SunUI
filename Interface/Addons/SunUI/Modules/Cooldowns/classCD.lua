local S, L, DB, _, C = unpack(select(2, ...))
local CCD = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("ClassCD", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
----------------------------------------------------------------------------------------
--	职业被动技能,饰品,附魔内置CD
--  Modify by Ljxx.net at 2011.10.15
--  Modify by Coolkid at 2012.12.27
----------------------------------------------------------------------------------------
local show = {
	raid = true,
	party = true,
	arena = true,
	none = true,
}
local class_spells = {
	[121283] = {
			desc = "",
			type = "talent",
			class = "MONK",
			talent = 7,
			cd = 20,
		}, -- Power Strike
	[122281] = {
		desc = "",
		type = "talent",
		class = "MONK",
		talent = 13,
		cd = 15,
	}, -- Healing Elixirs
	-- shaman
	[31616] = {
		desc = "",
		type = "talent",
		class = "SHAMAN",
		talent = 1,
		cd = 30,
		duration = 10,
	}, -- Nature's Guardian

	-- mage
	[87023] = {
		desc = "",
		type = "talent",
		class = "MAGE",
		talent = 11,
		cd = 120,
		duration = 6,
	}, -- Cauterize

	-- rogue
	[45182] = {
		desc = "",
		type = "talent",
		class = "ROGUE",
		talent = 7,
		cd = 90,
		duration = 3,
	}, -- Cheated Death

	-- priest
	[114214] = {
		desc = "",
		type = "talent",
		class = "PRIEST",
		talent = 12,
		cd = 90,
	}, -- Angelic Bulwark

	-- dk
	[116888] = {
		desc = "",
		type = "talent",
		class = "DEATHKNIGHT",
		talent = 6,
		cd = 180,
		duration = 3,
	}, -- Purgatory	

-- spec
	-- type = "spec" 
	-- spec = {the numbers of the spec(from 1 to 3(4 for druid))}
	-- druid
	[34299] = {
		desc = "",
		type = "spec",
		class = "DRUID",
		spec = {2, 3},
		cd = 6,
	}, -- Leader of the Pack

	-- hunter
	[56453] = {
		desc = "",
		type = "spec",
		class = "HUNTER",
		spec = {3},
		cd = 10,
	}, -- Lock and Load

	-- priest
	[47755] = {
		desc = "",
		type = "spec",
		class = "PRIEST",
		spec = {1},
		cd = 12,
	}, -- Rapture

	--dk
	[96171] = {
		desc = "",
		type = "spec",
		class = "DEATHKNIGHT",
		spec = {1},
		cd = 45,
		duration = 8,
	}, -- Will of the Necropolis	

	--warlock
	[104317] = {
		desc = "",
		type = "spec",
		class = "WARLOCK",
		spec = {2},
		cd = 20,
	}, --
	[34936] = {
		desc = "",
		type = "spec",
		class = "WARLOCK",
		spec = {3},
		cd = 8,
	}, --



-- item
	-- type = "item" 
	-- item = {the item id}
	-- MOP 5.2
	-- TH(Thunderforged)/ H/ TN/ N/ LFR Raid
	[138756] = {
		desc = "",
		type = "item",
		item = {96369,95997,94512,95625},
		cd = 22,
		duration = 20,
	}, -- Renataki's Soul Charm
	[138786] = {
		desc = "",
		type = "item",
		item = {96785,96413,96041,94513,95669},
		cd = 22,
		duration = 20,
	}, -- Wushoolay's Final Choice
	[140380] = {
		desc = "",
		type = "item",
		item = {96828,96456,96084,94520,95712},
		cd = 17,
	}, -- Inscribed Bag of Hydra-Spawn
	
	[138759] = {
		desc = "",
		type = "item",
		item = {96470,96098,94515,95726},
		cd = 22,
		duration = 20,
	}, -- Fabled Feather of Ji-Kun
	[138973] = {
		desc = "",
		type = "item",
		item = {96471,96099,94527,95727},
		cd = 30,
	}, -- Ji-Kun's Rising Winds
	
	[139120] = {
		desc = "",
		type = "item",
		item = {96546,96174,94532,95802},
		cd = 22,
		duration = 10,
	}, -- Rune of Re-Origination
	[139117] = {
		desc = "",
		type = "item",
		item = {96546,96174,94532,95802},
		cd = 22,
		duration = 10,
	}, -- Rune of Re-Origination
	[139121] = {
		desc = "",
		type = "item",
		item = {96546,96174,94532,95802},
		cd = 22,
		duration = 10,
	}, -- Rune of Re-Origination
	
	--  522 Valor Point
	[138703] = {
		desc = "",
		type = "item",
		item = {94510},
		cd = 45,
		duration = 10,
	}, -- Volatile Talisman of the Shado-Pan Assault
	[138702] = {
		desc = "",
		type = "item",
		item = {94508},
		cd = 75,
		duration = 15,
	}, -- Brutal Talisman of the Shado-Pan Assault
	[138699] = {
		desc = "",
		type = "item",
		item = {94511},
		cd = 105,
		duration = 20,
	}, -- Vicious Talisman of the Shado-Pan Assault			
		
	-- MOP 5.0
	-- 509 496 483 Raid
	[126646] = {
		desc = "",
		type = "item",
		item = {87160,86323,86881},
		cd = 105,
		duration = 20,
	}, -- Stuff of Nightmares
	[126640] = {
		desc = "",
		type = "item",
		item = {87163,86327,86885},
		cd = 105,
		duration = 20,
	},
	[126649] = {
		desc = "",
		type = "item",
		item = {87167,86332,86890},
		cd = 105,
		duration = 20,
	},
	[126657] = {
		desc = "",
		type = "item",
		item = {87172,86336,86894},
		cd = 105,
		duration = 20,
	}, -- H
	[126659] = {
		desc = "",
		type = "item",
		item = {87175,86388,86907},
		cd = 105,
		duration = 20,
	}, -- H

	-- 502 489 476 Raid
	[126554] = {
		desc = "",
		type = "item",
		item = {87057,86132,86791},
		cd = 45,
		duration = 20,
	}, -- H
	[126533] = {
		desc = "",
		type = "item",
		item = {87063,86131,86790},
		cd = 45,
		duration = 20,
	}, -- H
	[126577] = {
		desc = "",
		type = "item",
		item = {87065,86133,86792},
		cd = 45,
		duration = 20,
	}, -- H
	[126582] = {
		desc = "",
		type = "item",
		item = {87072,86144,86802},
		cd = 45,
		duration = 20,
	}, -- H
	[126588] = {
		desc = "",
		type = "item",
		item = {87075,86147,86805},
		cd = 45,
		duration = 20,
	}, -- H

	-- pvp 483 458
	[126707] = {
		desc = "",
		type = "item",
		item = {84935,84349},
		cd = 50,
		duration = 20,
	}, -- AGI
	[126705] = {
		desc = "",
		type = "item",
		item = {84941,84489},
		cd = 50,
		duration = 20,
	}, -- SP
	[126700] = {
		desc = "",
		type = "item",
		item = {84937,84495},
		cd = 50,
		duration = 20,
	}, -- STR

	-- Darkmoon Card 476
	[128985] = {
		desc = "",
		type = "item",
		item = {79331},
		cd = 50,
		duration = 15,
	}, -- Relic of Yu'lon
	[128986] = {
		desc = "",
		type = "item",
		item = {79327},
		cd = 45,
		duration = 15,
	}, -- Relic of Xuen STR
	[128984] = {
		desc = "",
		type = "item",
		item = {79328},
		cd = 55,
		duration = 15,
	}, -- Relic of Xuen AGI
	[128987] = {
		desc = "",
		type = "item",
		item = {79330},
		cd = 45,
		duration = 20,
	}, -- Relic of Chi Ji

	-- 470 
	[127923] = {
		desc = "",
		type = "item",
		item = {87572},
		cd = 45,
		duration = 10,
	}, -- Mithril Wristwatch
	[127928] = {
		desc = "",
		type = "item",
		item = {87574},
		cd = 45,
		duration = 10,
	}, -- Coren's Cold Chromium Coaster		
	[127915] = {
		desc = "",
		type = "item",
		item = {87573},
		cd = 45,
		duration = 10,
	}, -- Thousand-Year Pickled Egg

	-- 463 Heroic
	[126489] = {
		desc = "",
		type = "item",
		item = {81267},
		cd = 85,
		duration = 25,
	}, -- Searing Words
	[126483] = {
		desc = "",
		type = "item",
		item = {81125},
		cd = 65,
		duration = 20,
	}, -- Windswept Pages		
	[126236] = {
		desc = "",
		type = "item",
		item = {81243},
		cd = 50,
		duration = 15,
	}, -- Iron Protector Talisman
	[126266] = {
		desc = "",
		type = "item",
		item = {81133},
		cd = 30,
		duration = 10,
	}, -- Empty Fruit Barrel
	[126476] = {
		desc = "",
		type = "item",
		item = {81192},
		cd = 105,
		duration = 30,
	}, -- Vision of the Predator
	[126513] = {
		desc = "",
		type = "item",
		item = {81138},
		cd = 105,
		duration = 30,
	}, -- Carbonic Carbuncle		
	[126483] = {
		desc = "",
		type = "item",
		item = {81125},
		cd = 65,
		duration = 20,
	}, -- Windswept Pages
	[126489] = {
		desc = "",
		type = "item",
		item = {81267},
		cd = 85,
		duration = 25,
	}, -- Searing Words

	-- 450 and others
	[60234] = {
		desc = "",
		type = "item",
		item = {75274},
		cd = 55,
		duration = 15,
	}, -- Zen Alchemist Stone(Intellect)
	[60233] = {
		desc = "",
		type = "item",
		item = {75274},
		cd = 55,
		duration = 15,
	}, -- Zen Alchemist Stone(Agility)
	[60229] = {
		desc = "",
		type = "item",
		item = {75274},
		cd = 55,
		duration = 15,
	}, -- Zen Alchemist Stone(Strength)

	--old data. if you need these, release the comment.
	-- Cataclysm 4.3
	-- Ti'tahk, the Steps of Time
	[109844] = {
		desc = "",
		type = "item",
		item = {78477},
		cd = 45,
		duration = 10,
	}, -- H
	[107804] = {
		desc = "",
		type = "item",
		item = {77190},
		cd = 45,
		duration = 10,
	}, -- N
	[109842] = {
		desc = "",
		type = "item",
		item = {78486},
		cd = 45,
		duration = 10,
	}, -- LFR
	-- Maw of the Dragonlord
	[109849] = {
		desc = "",
		type = "item",
		item = {78476},
		cd = 15
	}, -- H
	[107835] = {
		desc = "",
		type = "item",
		item = {77196},
		cd = 15
	}, -- N
	[109847] = {
		desc = "",
		type = "item",
		item = {78485},
		cd = 15
	}, -- LFR
	-- Rathrak, the Poisonous Mind
	[109854] = {
		desc = "",
		type = "item",
		item = {78475},
		cd = 15,
		duration = 10,
	}, -- H
	[107831] = {
		desc = "",
		type = "item",
		item = {77195},
		cd = 15,
		duration = 10,
	}, -- N
	[109851] = {
		desc = "",
		type = "item",
		item = {78484},
		cd = 15,
		duration = 10,
	}, -- LFR
	-- Kiril, Fury of Beasts
	[109864] = {
		desc = "",
		type = "item",
		item = {78473},
		cd = 55,
		duration = 20,
	}, -- H
	[108011] = {
		desc = "",
		type = "item",
		item = {77194},
		cd = 55,
		duration = 20,
	}, -- N
	[109861] = {
		desc = "",
		type = "item",
		item = {78482},
		cd = 55,
		duration = 20,
	}, -- LFR
	-- Creche of the Final Dragon
	[109744] = {
		desc = "",
		type = "item",
		item = {77992},
		cd = 100,
		duration = 20,
	}, -- H
	[107988] = {
		desc = "",
		type = "item",
		item = {77205},
		cd = 100,
		duration = 20,
	}, -- N
	[109742] = {
		desc = "",
		type = "item",
		item = {77972},
		cd = 100,
		duration = 20,
	}, -- LFR
	-- Indomitable Pride
	[108008] = {
		desc = "",
		type = "item",
		item = {78003, 77211, 77983},
		cd = 60,
		duration = 6,
	}, 
	-- Insignia of the Corrupted Mind
	[109789] = {
		desc = "",
		type = "item",
		item = {77991},
		cd = 100,
		duration = 20,
	}, -- H
	[107982] = {
		desc = "",
		type = "item",
		item = {77203, 77204, 77202},
		cd = 100,
		duration = 20,
	}, -- N Starcatcher Compass and Insignia of the Corrupted Mind and Seal of the Seven Signs
	[109787] = {
		desc = "",
		type = "item",
		item = {77971},
		cd = 100,
		duration = 20,
	}, -- LFR
	-- Seal of the Seven Signs
	[109804] = {
		desc = "",
		type = "item",
		item = {77989},
		cd = 100,
		duration = 20,
	}, -- H
	[109802] = {
		desc = "",
		type = "item",
		item = {77969},
		cd = 100,
		duration = 20,
	}, -- LFR
	-- Soulshifter Vortex
	[109776] = {
		desc = "",
		type = "item",
		item = {77990},
		cd = 100,
		duration = 20,
	}, -- H
	[107986] = {
		desc = "",
		type = "item",
		item = {77206},
		cd = 100,
		duration = 20,
	}, -- N
	[109774] = {
		desc = "",
		type = "item",
		item = {77970},
		cd = 100,
		duration = 20,
	}, -- LFR
	-- Starcatcher Compass
	[109711] = {
		desc = "",
		type = "item",
		item = {77993},
		cd = 100,
		duration = 20,
	}, -- H
	[109709] = {
		desc = "",
		type = "item",
		item = {77973},
		cd = 100,
		duration = 20,
	}, -- LFR
	-- Windward Heart
	[109825] = {
		desc = "",
		type = "item",
		item = {78001},
		cd = 25,
	}, -- H
	[108000] = {
		desc = "",
		type = "item",
		item = {77209},
		cd = 25
	}, -- N
	[109822] = {
		desc = "",
		type = "item",
		item = {77981},
		cd = 25
	}, -- LFR

	-- Bone-Link Fetish
	[109754] = {
		desc = "",
		type = "item",
		item = {78002},
		cd = 25
	}, -- H
	[107997] = {
		desc = "",
		type = "item",
		item = {77210},
		cd = 25
	}, -- N
	[109752] = {
		desc = "",
		type = "item",
		item = {77982},
		cd = 25
	}, -- LFR
	-- Cunning of the Cruel
	[109800] = {
		desc = "",
		type = "item",
		item = {78000},
		cd = 10}, -- H
	[108005] = {
		desc = "",
		type = "item",
		item = {77208},
		cd = 10
	}, -- N
	[109798] = {
		desc = "",
		type = "item",
		item = {77980},
		cd = 10
	}, -- LFR
	-- Vial of Shadows
	[109724] = {
		desc = "",
		type = "item",
		item = {77999},
		cd = 10
	}, -- H
	[107994] = {
		desc = "",
		type = "item",
		item = {77207},
		cd = 10
	}, -- N
	[109721] = {
		desc = "",
		type = "item",
		item = {77979},
		cd = 10
	}, -- LFR
	-- S11 PVP
	[105135] = {
		desc = "",
		type = "item",
		item = {73643},
		cd = 50,
		duration = 20,
	},
	[105137] = {
		desc = "",
		type = "item",
		item = {73497},
		cd = 50,
		duration = 20,
	},
	[105139] = {
		desc = "",
		type = "item",
		item = {73491},
		cd = 50,
		duration = 20,
	},

	[102439] = {
		desc = "",
		type = "item",
		item = {72309},
		cd = 50,
		duration = 20,
	},
	[102435] = {
		desc = "",
		type = "item",
		item = {72449},
		cd = 50,
		duration = 20,
	},
	[102432] = {
		desc = "",
		type = "item",
		item = {72455},
		cd = 50,
		duration = 20,
	},

	-- 378 others
	[102659] = {
		desc = "",
		type = "item",
		item = {72897},
		cd = 50,
		duration = 20,
	},
	[102662] = {
		desc = "",
		type = "item",
		item = {72898},
		cd = 50,
		duration = 20,
	},
	[102664] = {
		desc = "",
		type = "item",
		item = {72899},
		cd = 50,
		duration = 20,
	},

	[109993] = {
		desc = "",
		type = "item",
		item = {74035},
		cd = 50,
		duration = 20,
	},
	[102660] = {
		desc = "",
		type = "item",
		item = {72901},
		cd = 50,
		duration = 20,
	},
	[102667] = {
		desc = "",
		type = "item",
		item = {72900},
		cd = 50,
		duration = 20,
	},

	-- Cataclysm Raid T12 378 - 397
	-- Matrix Restabilizer H
	[97139] = {
		desc = "",
		type = "item",
		item = {69150},
		cd = 105,
		duration = 30,
	},
	[97140] = {
		desc = "",
		type = "item",
		item = {69150},
		cd = 105,
		duration = 30,
	},
	[97141] = {
		desc = "",
		type = "item",
		item = {69150},
		cd = 105,
		duration = 30,
	},
	-- Matrix Restabilizer
	[96978] = {
		desc = "",
		type = "item",
		item = {68994},
		cd = 105,
		duration = 30,
	},
	[96977] = {
		desc = "",
		type = "item",
		item = {68994},
		cd = 105,
		duration = 30,
	},
	[96979] = {
		desc = "",
		type = "item",
		item = {68994},
		cd = 105,
		duration = 30,
	},
	[97136] = {
		desc = "",
		type = "item",
		item = {69149},
		cd = 45
	}, -- Eye of Blazing Power H
	[96966] = {
		desc = "",
		type = "item",
		item = {68983},
		cd = 45
	}, -- Eye of Blazing Power
	[97129] = {
		desc = "",
		type = "item",
		item = {69138},
		cd = 60
	}, -- Spidersilk Spindle H
	[96945] = {
		desc = "",
		type = "item",
		item = {68981},
		cd = 60
	}, -- Spidersilk Spindle
	[97125] = {
		desc = "",
		type = "item",
		item = {69112},
		cd = 60,
		duration = 15,
	}, -- The Hungerer H
	[96911] = {
		desc = "",
		type = "item",
		item = {68927},
		cd = 60,
		duration = 15,
	}, -- The Hungerer

	-- S10 PVP
	[99721] = {
		desc = "",
		type = "item",
		item = {70579},
		cd = 50,
		duration = 20,
	},
	[99719] = {
		desc = "",
		type = "item",
		item = {70578},
		cd = 50,
		duration = 20,
	},
	[99717] = {
		desc = "",
		type = "item",
		item = {70577},
		cd = 50,
		duration = 20,
	},
	[99742] = {
		desc = "",
		type = "item",
		item = {70402},
		cd = 50,
		duration = 20,
	},
	[99748] = {
		desc = "",
		type = "item",
		item = {70404},
		cd = 50,
		duration = 20,
	},
	[99746] = {
		desc = "",
		type = "item",
		item = {70403},
		cd = 50,
		duration = 20,
	},

	-- Festival Trinket 365
	[101289] = {
		desc = "",
		type = "item",
		item = {71336},
		cd = 50,
		duration = 10,
	}, -- Petrified Pickled Egg
	[101291] = {
		desc = "",
		type = "item",
		item = {71337},
		cd = 50,
		duration = 10,
	}, -- Mithril Stopwatch
	[101287] = {
		desc = "",
		type = "item",
		item = {71335},
		cd = 50,
		duration = 10,
	}, -- Coren's Chilled Chromium Coaster

	-- Mount Hyjal 365
	[100322] = {
		desc = "",
		type = "item",
		item = {70141},
		cd = 45,
		duration = 20,
	}, -- Dwyer's Caber

	-- Darkmoon Cards
	[89091] = {
		desc = "",
		type = "item",
		item = {62047},
		cd = 45,
		duration = 12,
	}, -- Darkmoon Card: Volcano

	-- Tol Barad factions
	[91192] = {
		desc = "",
		type = "item",
		item = {62467, 62472},
		cd = 50,
		duration = 10
	}, -- Mandala of Stirring Patterns
	[91047] = {
		desc = "",
		type = "item",
		item = {62465, 62470},
		cd = 75,
		duration = 15
	}, -- Stump of Time

	-- Valour Vendor 4.0
	[92233] = {
		desc = "",
		type = "item",
		item = {58182},
		cd = 30,
		duration = 10,
	}, -- Bedrock Talisman

	-- Cataclysm Raid 372
	[92320] = {
		desc = "",
		type = "item",
		item = {65105},
		cd = 90,
		duration = 20,
	}, -- Theralion's Mirror
	[92355] = {
		desc = "",
		type = "item",
		item = {65048},
		cd = 30,
		duration = 10,
	}, -- Symbiotic Worm
	[92349] = {
		desc = "",
		type = "item",
		item = {65026},
		cd = 75,
		duration = 15,
	}, -- Prestor's Talisman of Machination
	[92345] = {
		desc = "",
		type = "item",
		item = {65072},
		cd = 100,
		duration = 20,
	}, -- Heart of Rage
	[92332] = {
		desc = "",
		type = "item",
		item = {65124},
		cd = 75,
		duration = 15,
	}, -- Fall of Mortality
	[92351] = {
		desc = "",
		type = "item",
		item = {65140},
		cd = 50,
		duration = 10,
	}, -- Essence of the Cyclone
	[92342] = {
		desc = "",
		type = "item",
		item = {65118},
		cd = 75,
		duration = 15,
	}, -- Crushing Weight
	[92318] = {
		desc = "",
		type = "item",
		item = {65053},
		cd = 100,
		duration = 20,
	}, -- Bell of Enraging Resonance

	-- Cataclysm Raid 359
	[92108] = {
		desc = "",
		type = "item",
		item = {59520},
		cd = 50,
		duration = 10,
	}, -- Unheeded Warning
	[91024] = {
		desc = "",
		type = "item",
		item = {59519},
		cd = 90,
		duration = 20,
	}, -- Theralion's Mirror
	[92235] = {
		desc = "",
		type = "item",
		item = {59332},
		cd = 30,
		duration = 10,
	}, -- Symbiotic Worm
	[92124] = {
		desc = "",
		type = "item",
		item = {59441},
		cd = 75,
		duration = 15,
	}, -- Prestor's Talisman of Machination
	[91816] = {
		desc = "",
		type = "item",
		item = {59224},
		cd = 100,
		duration = 20,
	}, -- Heart of Rage
	[91184] = {
		desc = "",
		type = "item",
		item = {59500},
		cd = 75,
		duration = 15,
	}, -- Fall of Mortality
	[92126] = {
		desc = "",
		type = "item",
		item = {59473},
		cd = 50,
		duration = 10,
	}, -- Essence of the Cyclone
	[91821] = {
		desc = "",
		type = "item",
		item = {59506},
		cd = 75,
		duration = 15,
	}, -- Crushing Weight
	[91007] = {
		desc = "",
		type = "item",
		item = {59326},
		cd = 100,
		duration = 20,
	}, -- Bell of Enraging Resonance

	-- Cataclysm Dungeon 346
	[90992] = {
		desc = "",
		type = "item",
		item = {56407},
		cd = 50,
		duration = 10,
	}, -- Anhuur's Hymnal
	[91149] = {
		desc = "",
		type = "item",
		item = {56414},
		cd = 100,
		duration = 20,
	}, -- Blood of Isiset
	[92087] = {
		desc = "",
		type = "item",
		item = {56295},
		cd = 50,
		duration = 10,
	}, -- Grace of the Herald
	[91364] = {
		desc = "",
		type = "item",
		item = {56393},
		cd = 100,
		duration = 20,
	}, -- Heart of Solace
	[92091] = {
		desc = "",
		type = "item",
		item = {56328},
		cd = 75,
		duration = 15,
	}, -- Key to the Endless Chamber
	[92184] = {
		desc = "",
		type = "item",
		item = {56347},
		cd = 30,
		duration = 10,
	}, -- Leaden Despair
	[92094] = {
		desc = "",
		type = "item",
		item = {56427},
		cd = 50,
		duration = 10,
	}, -- Left Eye of Rajh
	[92174] = {
		desc = "",
		type = "item",
		item = {56280},
		cd = 80,
		duration = 20,
	}, -- Porcelain Crab
	[91143] = {
		desc = "",
		type = "item",
		item = {56377},
		cd = 75,
		duration = 15,
	}, -- Rainsong
	[91368] = {
		desc = "",
		type = "item",
		item = {56431},
		cd = 50,
		duration = 10,
	}, -- Right Eye of Rajh
	[91002] = {
		desc = "",
		type = "item",
		item = {56400},
		cd = 20,
		duration = 10,
	}, -- Sorrowsong
	[91139] = {
		desc = "",
		type = "item",
		item = {56351},
		cd = 75,
		duration = 15,
	}, -- Tear of Blood
	[90898] = {
		desc = "",
		type = "item",
		item = {56339},
		cd = 75,
		duration = 15,
	}, -- Tendrils of Burrowing Dark
	[92205] = {
		desc = "",
		type = "item",
		item = {56449},
		cd = 60,
		duration = 12,
	}, -- Throngus's Finger
	[90887] = {
		desc = "",
		type = "item",
		item = {56320},
		cd = 75,
		duration = 15,
	}, -- Witching Hourglass

	-- Cataclysm Dungeon and World drops 308-333
	[90989] = {
		desc = "",
		type = "item",
		item = {55889},
		cd = 50,
		duration = 10,
	}, -- Anhuur's Hymnal
	[91147] = {
		desc = "",
		type = "item",
		item = {55995},
		cd = 100,
		duration = 20,
	}, -- Blood of Isiset
	[91363] = {
		desc = "",
		type = "item",
		item = {55868},
		cd = 100,
		duration = 20,
	}, -- Heart of Solace
	[92096] = {
		desc = "",
		type = "item",
		item = {56102},
		cd = 50,
		duration = 10,
	}, -- Left Eye of Rajh
	[91370] = {
		desc = "",
		type = "item",
		item = {56100},
		cd = 50,
		duration = 10,
	}, -- Right Eye of Rajh
	[90996] = {
		desc = "",
		type = "item",
		item = {55879},
		cd = 20,
		duration = 10,
	}, -- Sorrowsong
	[92208] = {
		desc = "",
		type = "item",
		item = {56121},
		cd = 60,
		duration = 12,
	}, -- Throngus's Finger
	[92052] = {
		desc = "",
		type = "item",
		item = {66969},
		cd = 50,
		duration = 10,
	}, -- Heart of the Vile
	[92069] = {
		desc = "",
		type = "item",
		item = {55795},
		cd = 75,
		duration = 15,
	}, -- Key to the Endless Chamber
	[92179] = {
		desc = "",
		type = "item",
		item = {55816},
		cd = 30,
		duration = 10,
	}, -- Leaden Despair
	[91141] = {
		desc = "",
		type = "item",
		item = {55854},
		cd = 75,
		duration = 15,
	}, -- Rainsong
	[91138] = {
		desc = "",
		type = "item",
		item = {55819},
		cd = 75,
		duration = 15,
	}, -- Tear of Blood
	[90896] = {
		desc = "",
		type = "item",
		item = {55810},
		cd = 75,
		duration = 15,
	}, -- Tendrils of Burrowing Dark
	[92052] = {
		desc = "",
		type = "item",
		item = {55266},
		cd = 50,
		duration = 10,
	}, -- Grace of the Herald
	[90885] = {
		desc = "",
		type = "item",
		item = {55787},
		cd = 75,
		duration = 15,
	}, -- Witching Hourglass

	-- S9 PvP
	[85027] = {
		desc = "",
		type = "item",
		item = {61045},
		cd = 50,
		duration = 20,
	}, -- Vicious Gladiator's Insignia of Dominance
	[85032] = {
		desc = "",
		type = "item",
		item = {61046},
		cd = 50,
		duration = 20,
	}, -- Vicious Gladiator's Insignia of Victory
	[85022] = {
		desc = "",
		type = "item",
		item = {61047},
		cd = 50,
		duration = 20,
	}, -- Vicious Gladiator's Insignia of Conquest
	[92218] = {
		desc = "",
		type = "item",
		item = {64762},
		cd = 50,
		duration = 20,
	}, -- Bloodthirsty Gladiator's Insignia of Dominance
	[92216] = {
		desc = "",
		type = "item",
		item = {64763},
		cd = 50,
		duration = 20,
	}, -- Bloodthirsty Gladiator's Insignia of Victory
	[92220] = {
		desc = "",
		type = "item",
		item = {64761},
		cd = 50,
		duration = 20,
	}, -- Bloodthirsty Gladiator's Insignia of Conquest	
-- item set
	-- type = "itemset"
	-- items = {all items of this set(including all difficulties)}
	-- piece = the minimum pieces of the item set to get the bonus


	[102545] = {
		type = "itemset",
		class = "DRUID",
		items = {84377,84378,84379,84380,84381,84901,84832,84852,84871,84916},
		piece = 4,
		cd = 30,
	}, -- Feral PVP 4P

	[105919] = {
		type = "itemset",
		class = "HUNTER",
		items = {77028,77029,77030,77031,77032,78793,78832,78756,78769,78804,78698,78737,78661,78674,78709},
		piece = 4,
		cd = 105,
		duration = 15
	}, -- Hunter T13 4P Bonus
	[105582] = {
		type = "itemset",
		class = "DEATHKNIGHT",
		items = {77008,77009,77010,77011,77012,78792,78846,78758,78773,78881,78697,78751,78663,78678,78716},
		piece = 2,
		cd = 45
	}, -- Tank DK T13 2P Bonus 
	[99063] = {
		type = "itemset",
		class = "MAGE",
		items = {71286,71287,71288,71289,71290,71507,71508,71509,71510,71511},
		piece = 2,
		cd = 45,
		duration = 15
	}, -- Mage T12 2P Bonus
	[99221] = {
		type = "itemset",
		class = "WARLOCK",
		items = {71281,71282,71283,71284,71295,71594,71595,71596,71597,71598},
		piece = 2,
		cd = 45,
		duration = 15
	}, -- Warlock T12 2P Bonus
	[99035] = {
		type = "itemset",
		class = "DRUID",
		items = {71107,71108,71109,71110,71111,71496,71497,71498,71499,71500},
		piece = 2,
		cd = 45,
		duration = 15
	}, -- Balance Druid T12 2P Bonus
	[99202] = {
		type = "itemset",
		class = "SHAMAN",
		items = {71552,71553,71554,71555,71556,71291,71292,71293,71294,71295},
		piece = 2,
		cd = 90
	}, -- Elemental Shaman T12 2P Bonus 

-- enchant
	-- type = "enchant",
	-- slot = 16 main hand(two hand have the same enchant may cause mistakes), 15 cloak  
	-- enchant = {enchant Id}
	-- Cataclysm
	[74241] = {
		type = "enchant",
		enchant = {4097},
		slot = 16,
		cd = 45,
		duration = 12
	}, -- Power Torrent
	[99621] = {
		type = "enchant",
		enchant = {4267},
		slot = 16,
		cd = 40,
		duration = 10
	}, -- Flintlocke's Woodchucker
	[74221] = {
		type = "enchant",
		enchant = {4083},
		slot = 16,
		cd = 45,
		duration = 12
	}, -- Hurricane
	[74224] = {
		type = "enchant",
		enchant = {4084},
		slot = 16,
		cd = 20,
		duration = 15
	}, -- Heartsong
	[59626] = {
		type = "enchant",
		enchant = {3790},
		slot = 16,
		cd = 35,
		duration = 10
	}, -- Black Magic

	-- MOP
	[125488] = {
		desc = "",
		type = "enchant",
		enchant = {4893, 4116, 3728},
		slot = 15,
		cd = 60,
		duration = 15
	},	-- Darkglow Embroidery
	[125489] = {
		desc = "",
		type = "enchant",
		enchant = {4894, 3730, 4118},
		slot = 15,
		cd = 60,
		duration = 15
	}, -- Swordguard Embroidery
	[125487] = {
		desc = "",
		type = "enchant",
		enchant = {4892, 3722, 4115},
		slot = 15,
		cd = 55,
		duration = 15
	}, -- Lightweave Embroidery
	[104993] = {
		desc = "",
		type = "enchant",
		enchant = {4442},
		slot = 16,
		cd = 50,
		duration = 12
	}, -- Jade Spirit
}

local EVENT = {
	["SPELL_DAMAGE"] = true,
	["SPELL_PERIODIC_HEAL"] = true,
	["SPELL_HEAL"] = true,
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_ENERGIZE"] = true,
	["SPELL_CAST_SUCCESS"] = true,
	["SPELL_CAST_START"] = true, -- for early frost
	["SPELL_SUMMON"] = true, -- for t12 2p
}
local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local timer = 0
local bars = {}
local ClassCDAnchor = CreateFrame("Frame", "ClassCDAnchor", UIParent)
local FormatTime = function(time)
	if time >= 60 then
		return sformat("%.2d:%.2d", floor(time / 60), time % 60)
	else
		return sformat("%.2d", time)
	end
end

function CCD:UpdatePositions()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		bars[i].id = i
		if not C["ClassCDIcon"] then
			if i == 1 then
				bars[i]:SetPoint("CENTER", ClassCDAnchor)
			else
				if C["ClassCDDirection"] == 2 then
					bars[i]:Point("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, C["ClassCDHeight"]*2-3)
				else
					bars[i]:Point("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, -C["ClassCDHeight"]*2+3)
				end
			end
		else
			if i == 1 then
				bars[i]:SetPoint("CENTER", ClassCDAnchor)
			else
				if C["ClassCDIconDirection"] == 1 then
					bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
				else
					bars[i]:SetPoint("RIGHT", bars[i-1], "LEFT", -5, 0)
				end
			end
		end
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	CCD:UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	if not C["ClassCDIcon"] then
		self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
		self.right:SetText(FormatTime(self.endTime - curTime))
		else
		self.right = FormatTime(self.endTime - curTime)
	end
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetSpellByID(self.spell)
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if not C["ClassCDIcon"] then 
		if button == "LeftButton" then
			if IsInRaid() then
				SendChatMessage(sformat(COOLDOWN_REMAINING.." %s: %s", self.left:GetText(), self.right:GetText()), "RAID")
			elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
				SendChatMessage(sformat(COOLDOWN_REMAINING.." %s: %s", self.left:GetText(), self.right:GetText()), "INSTANCE_CHAT")
			elseif IsInGroup() then
				SendChatMessage(sformat(COOLDOWN_REMAINING.." %s: %s", self.left:GetText(), self.right:GetText()), "PARTY")
			else
				SendChatMessage(sformat(COOLDOWN_REMAINING.." %s: %s", self.left:GetText(), self.right:GetText()), "SAY")
			end
		elseif button == "RightButton" then
			StopTimer(self)
		end
	else
		if button == "LeftButton" then
			if IsInRaid() then
				SendChatMessage(sformat("SunUI"..COOLDOWN_REMAINING.." %s: %s", GetSpellInfo(self.spell), self.right), "RAID")
			elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
				SendChatMessage(sformat("SunUI"..COOLDOWN_REMAINING.." %s: %s", GetSpellInfo(self.spell), self.right), "INSTANCE_CHAT")
			elseif IsInGroup() then
				SendChatMessage(sformat("SunUI"..COOLDOWN_REMAINING.." %s: %s", GetSpellInfo(self.spell), self.right), "PARTY")
			else
				SendChatMessage(sformat("SunUI"..COOLDOWN_REMAINING.." %s: %s", GetSpellInfo(self.spell), self.right), "SAY")
			end
		elseif button == "RightButton" then
			StopTimer(self)
		end
	end
end

local CreateBar = function()
	if not C["ClassCDIcon"] then
		local bar = CreateFrame("Statusbar", nil, UIParent)
		bar:SetFrameStrata("LOW")
		bar:SetSize(C["ClassCDWidth"], C["ClassCDHeight"])
		bar:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		bar:SetMinMaxValues(0, 100)
		--S.SmoothBar(bar)
		S.CreateBack(bar)
		S.CreateMark(bar)

		bar.left = S.MakeFontString(bar, C["ClassFontSize"])
		bar.left:Point("LEFT", 2, C["ClassCDHeight"])
		bar.left:SetJustifyH("LEFT")
		bar.left:Size(C["ClassCDWidth"], C["ClassCDHeight"])

		bar.right = S.MakeFontString(bar, C["ClassFontSize"])
		bar.right:Point("RIGHT", 1, C["ClassCDHeight"])
		bar.right:SetJustifyH("RIGHT")

		bar.icon = CreateFrame("Button", nil, bar)
		bar.icon:Width(C["ClassCDHeight"]*2)
		bar.icon:Height(C["ClassCDHeight"]*2)
		bar.icon:Point("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
		bar.icon:CreateShadow()
		bar:CreateShadow()
		return bar
	else
		bar = CreateFrame("Button", nil, UIParent)
		bar:SetFrameStrata("LOW")
		bar:SetSize(C["ClassCDIconSize"], C["ClassCDIconSize"])
		bar.cooldown = CreateFrame("Cooldown", nil, bar)
		bar.cooldown:SetAllPoints()
		bar.cooldown:SetReverse(true)
		bar:CreateShadow("Background")
		return bar
	end
end

local StartTimer = function(name, spellId, cd)
	for i = 1, #bars do
		if bars[i].spell == spellId then
			return
		end
	end
	local bar = CreateBar()
	local spell, rank, icon = GetSpellInfo(spellId)
	bar.endTime = GetTime() + cd
	bar.startTime = GetTime()
	bar.spell = spellId
	if not C["ClassCDIcon"] then
		bar.right:SetText(FormatTime(cd))
		bar.left:SetText(spell)
		bar.icon:SetNormalTexture(icon)
		bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		bar:Show()
		local color = RAID_CLASS_COLORS[select(2, UnitClass(name))]
		if color then
			bar:SetStatusBarColor(color.r, color.g, color.b)
			local s = bar:GetStatusBarTexture()
			S.CreateTop(s, color.r, color.g, color.b)
		else
			bar:SetStatusBarColor(0.3, 0.7, 0.3)
		end
	else
		bar:SetNormalTexture(icon)
		bar:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		bar.cooldown:SetReverse(false)
		CooldownFrame_SetTimer(bar.cooldown, GetTime(), cd, 1)
	end

	bar:EnableMouse(true)
	bar:SetScript("OnUpdate", BarUpdate)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	tinsert(bars, bar)
	CCD:UpdatePositions()
end
function CCD:COMBAT_LOG_EVENT_UNFILTERED(null, ...)
	local _, eventType, _, _, sourceName, sourceFlags = ...
	if band(sourceFlags, filter) == 0 or sourceName ~= DB.PlayerName then return end
	local spellId = select(12, ...)
	if class_spells[spellId] and EVENT[eventType] then
		StartTimer(sourceName, spellId, class_spells[spellId].cd)
	end
end

function CCD:ZONE_CHANGED_NEW_AREA()
	if select(2, IsInInstance()) == "arena" then
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end
function CCD:UpdateSize()
	if not C["ClassCDIcon"] then 
		ClassCDAnchor:SetSize(C["ClassCDWidth"], C["ClassCDHeight"])
	else
		ClassCDAnchor:SetSize(C["ClassCDIconSize"], C["ClassCDIconSize"])
	end
	for i = 1, #bars do
		if C["ClassCDIcon"] then
			bars[i]:SetSize(C["ClassCDIconSize"], C["ClassCDIconSize"])
		else
			bars[i]:SetSize(C["ClassCDWidth"], C["ClassCDHeight"])
		end
	end
end
function CCD:UpdateSet()
	if C["ClassCDOpen"] then
		CCD:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		CCD:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	else
		CCD:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		CCD:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end
function CCD:OnInitialize()
	if IsAddOnLoaded("ExtarCD") then return end
	C = SunUIConfig.db.profile.ClassCDDB
	if not C["ClassCDIcon"] then 
		ClassCDAnchor:SetSize(C["ClassCDWidth"], C["ClassCDHeight"])
	else
		ClassCDAnchor:SetSize(C["ClassCDIconSize"], C["ClassCDIconSize"])
	end
	self:UpdateSet()
	MoveHandle.ClassCD = S.MakeMoveHandle(ClassCDAnchor, L["内置CD监视"], "ClassCD")
end

SlashCmdList.ClassCD = function(msg)
	StartTimer(UnitName("player"), 47755, 12)
	StartTimer(UnitName("player"), 31616, 30)
	StartTimer(UnitName("player"), 45182, 90)
end
SLASH_ClassCD1 = "/classcd"