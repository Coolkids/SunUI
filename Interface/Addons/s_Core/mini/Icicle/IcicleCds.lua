local S, _, _, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):NewAddon("IcicleCds")
function Module:OnInitialize()
C = MiniDB
if C["Icicle"] ~= true then return end
DB.IcicleCds = {
	--Misc
	[28730] = 120,				--"Arcane Torrent",
	[50613] = 120,				--"Arcane Torrent",
	[80483] = 120,				--"Arcane Torrent",
	[25046] = 120,				--"Arcane Torrent",
	[69179] = 120,				--"Arcane Torrent",
	[20572] = 120,				--"Blood Fury",
	[33702] = 120,				--"Blood Fury",
	[33697] = 120,				--"Blood Fury",
	[59543] = 180,				--"Gift of the Naaru",
	[69070] = 120,				--"Rocket Jump",
	[26297] = 180,				--"Berserking",
	[20594] = 120,				--"Stoneform",
	[58984] = 120,				--"Shadowmeld",
	[20589] = 90,				--"Escape Artist",
	[59752] = 120,				--"Every Man for Himself",
	[7744] = 120,				--"Will of the Forsaken",
	[68992] = 120,				--"Darkflight",
	[50613] = 120,				--"Arcane Torrent",
	[11876] = 120,				--"War Stomp",
	[69041] = 120,				--"Rocket Barrage",
	[42292] = 120,				--"PvP Trinket",
	--Pets(Death Knight)
	--[91797] = 60,				--"Monstrous Blow",
	--[91837] = 45,				--"Putrid Bulwark",
	--[91802] = 30,				--"Shambling Rush",
	--[47482] = 30,				--"Leap",
	--[91809] = 30,				--"Leap",
	--[91800] = 60,				--"Gnaw",
	--[47481] = 60,				--"Gnaw",
	--Pets(Hunter)
	--[90339] = 60,				--"Harden Carapace",
	[61685] = 25,				--"Charge",
	[50519] = 60,				--"Sonic Blast",
	--[35290] = 10,				--"Gore",
	[50245] = 40,				--"Pin",
	[50433] = 10,				--"Ankle Crack",
	[26090] = 30,				--"Pummel",
	--[93434] = 90,				--"Horn Toss",
	--[57386] = 15,				--"Stampede",
	[50541] = 60, 				--"Clench",
	--[26064] = 60, 				--"Shell Shield",
	--[35346] = 15, 				--"Time Warp",
	--[93433] = 30,				--"Burrow Attack",
	[91644] = 60,				--"Snatch",
	--[54644] = 10,				--"Frost Breath",
	--[34889] = 30,				--"Fire Breath",
	--[50479] = 40,				--"Nether Shock",
	--[50518] = 15,				--"Ravage",
	--[35387] = 6, 				--"Corrosive Spit",
	[54706] = 40,				--"Vemom Web Spray",
	[4167] = 40,				--"Web",
	[50274] = 12,				--"Spore Cloud",
	--[24844] = 30, 				--"Lightning Breath",
	[90355] = 360,				--"Ancient Hysteria",
	--[54680] = 8,				--"Monstrous Bite",
	[90314] = 25,				--"Tailspin",
	[50271] = 10, 				--"Tendon Rip",
	[50318] = 60,				--"Serenity Dust",
	--[50498] = 6, 				--"Tear Armor",
	[90361] = 40,				--"Spirit Mend",
	[50285] = 40, 				--"Dust Cloud",
	--[56626] = 45,				--"Sting",
	--[24604] = 45,				--"Furious Howl",
	--[90309] = 45,				--"Terrifying Roar",
	--[24423] = 10,				--"Demoralizing Screech",
	--[93435] = 45,				--"Roar of Courage",
	--[58604] = 8,				--"Lava Breath",
	[90327] = 40,				--"Lock Jaw",
	[90337] = 60,				--"Bad Manner",
	--[53490] = 180,				--"Bullheaded",
	--[23145] = 32,				--"Dive",
	[55709] = 480,				--"Heart of the Phoenix",
	[53426] = 180,				--"Lick Your Wounds",
	--[53401] = 45, 				--"Rabid",
	[53476] = 30,				--"Intervene",
	[53480] = 60,				--"Roar of Sacrifice",
	[53478] = 360,				--"Last Stand",
	[53517] = 180,				--"Roar of Recovery",
	--Pets(Warlock)
	[19647] = 24,				--"Spell Lock",
	[7812] = 60,				--"Sacrifice",
	[89766] = 30,				--"Axe Toss"
	[89751] = 45,				--"Felstorm",
	--Pets(Mage)
	[33395] = 25,				--"Freeze", --No way to tell which WE cast this still usefull to some degree.
	--Death Knight
	[49039] = 120,				--"Lichborne",
	[47476] = 60,				--"Strangulate",
	[48707] = 45,				--"Anti-Magic Shell",
	[49576] = 25,				--"Death Grip",	
	[47528] = 10,				--"Mind Freeze",
	[49222] = 60,				--"Bone Shield",
	--[51271] = 60,				--"Pillar of Frost",
	[51052] = 120,				--"Anti-Magic Zone",
	[49203] = 60,				--"Hungering Cold",
	--[49028] = 90, 				--"Dancing Rune Weapon",
	--[49206] = 180,				--"Summon Gargoyle",
	--[43265] = 30,				--"Death and Decay",
	[48792] = 180,				--"Icebound Fortitude",
	--[48743] = 120,				--"Death Pact",
	--[42650] = 600,				--"Army of the Dead",
	--Druid
	[22812] = 60,				--"Barkskin",
	--[17116] = 180,				--"Nature's Swiftness",
	--[33891] = 180,				--"Tree of Life",
	[16979] = 14,				--"Feral Charge - Bear",
	[49376] = 28,				--"Feral Charge - Cat",
	[61336] = 180,				--"Survival Instincts",
	--[50334] = 180,				--"Berserk",
	[50516] = 17,				--"Typhoon",
	--[33831] = 180,				--"Force of Nature",
	--[22570] = 10,				--"Maim",
	--[18562] = 15,				--"Swiftmend",
	--[48505] = 60,				--"Starfall",
	[78675] = 60,				--"Solar Beam",
	[5211] = 50,				--"Bash",
	--[22842] = 180,				--"Frenzied Regeneration",
	--[16689] = 60, 				--"Nature's Grasp",
	--[740] = 480,				--"Tranquility",
	[80964] = 10,				--"Skull Bash",
	[80965] = 10,				--"Skull Bash",
	--[78674] = 15,				--"Starsurge",
	[29166] = 180,				--"Innervate",
	--Hunter
	--[82726] = 120,				--"Fervor",
	[19386] = 54,				--"Wyvern Sting",
	[3045] = 180,				--"Rapid Fire",
	[53351] = 10,				--"Kill Shot",
	[53271] = 45, 				--"Master's Call",
	--[51753] = 60,				--"Camouflage",
	[19263] = 120,				--"Deterrence",
	[19503] = 30,				--"Scatter Shot",
	[23989] = 180,				--"Readiness",
	[34490] = 20,				--"Silencing Shot",
	[19574] = 90,				--"Bestial Wrath",      
	--Mage
	[2139] = 24,				--"Counterspell",
	[44572] = 30,				--"Deep Freeze",
	[11958] = 384,				--"Cold Snap",
	[45438] = 300,				--"Ice Block",			
	[12042] = 106,				--"Arcane Power",		
	--[12051] = 240,				--"Evocation", 
	--[122] = 20,					--"Frost Nova",	
	--[11426] = 24,				--"Ice Barrier", 
	[12472] = 144,				--"Icy Veins",
	--[82731] = 60,				--"Flame Orb", 
	--[55342] = 180,				--"Mirror Image", 
	[66] = 132,					--"Invisibility",
	[82676] = 120,				--"Ring of Frost",
	[80353] = 300, 				--"Time Warp",
	[11113] = 15, 				--"Blast Wave",
	[12043] = 90,				--"Presence of Mind",
	[11129] = 120,				--"Combustion",
	[31661] = 17,				--"Dragon's Breath",	
	--Paladin
	[1044] = 25,				--"Hand of Freedom",
	--[31884] = 120,				--"Avenging Wrath",
	[853] = 50,					--"Hammer of Justice",
	[31935] = 15,				--"Avenger's Shield",
	[96231] = 10,				--"Rebuke",
	--[633] = 420,				--"Lay on Hands",
	[1022] = 180,				--"Hand of Protection",
	--[498] = 40,					--"Divine Protection",
	--[54428] = 120,			--"Divine Plea",
	[642] = 300,				--"Divine Shield",
	[6940] = 96,				--"Hand of Sacrifice",
	--[86150] = 120,				--"Guardian of Ancient Kings",
	--[31842] = 180,			--"Divine Favor",
	[31821] = 120,				--"Aura Mastery",
	--[70940] = 180,			--"Divine Guardian",
	[20066] = 60,				--"Repentance",
	--[31850] = 180,				--"Ardent Defender",
	--Priest
	[89485] = 45,				--"Inner Focus",
	[64044] = 90,				--"Psychic Horror",
	[8122] = 23,				--"Psychic Scream",
	[15487] = 45,				--"Silence",
	[47585] = 75,				--"Dispersion",
	[33206] = 180,				--"Pain Suppression",
	[10060] = 120,				--"Power Infusion",
	[88625] = 25,				--"Holy Word: Chastise",
	--[586] = 15,				--"Fade",
	[32379] = 10,				--"Shadow Word: Death",
	--[6346] = 180,				--"Fear Ward",
	--[64901] = 360,			--"Hymn of Hope",
	--[64843] = 480,			--"Divine Hymn",
	[73325] = 90,				--"Leap of Faith",
	--[19236] = 120,			--"Desperate Prayer",
	--[724] = 180,				--"Lightwell",
	--[62618] = 120,			--"Power Word: Barrier",
	--Rogue
	[2094] = 120,				--"Blind",
	[1766] = 10,				--"Kick",
	[2983] = 60,				--"Sprint",
	[14185] = 300,				--"Preparation",
	[31224] = 90,				--"Cloak of Shadows",
	[1856] = 120,				--"Vanish",
	[36554] = 24,				--"Shadowstep",
	[5277] = 180,				--"Evasion",
	--[408] = 20,				--"Kidney Shot",
	[51722] = 60,				--"Dismantle",
	[76577] = 180,				--"Smoke Bomb",
	--[14177] = 120,			--"Cold Blood",
	--[51690] = 120,			--"Killing Spree",
	--[51713] = 60, 			--"Shadow Dance",
	[79140] = 120,				--"Vendetta",
	--Shaman
	--[98008] = 120,			--"Spirit Link Totem",
	[8177] = 13.5,				--"Grounding Totem",
	[57994] = 5,				--"Wind Shear",
	[32182] = 300,				--"Heroism",
	[2825] = 300,				--"Bloodlust",
	[51533] = 120,				--"Feral Spirit",
	[16190] = 180,				--"Mana Tide Totem",
	[30823] = 60,				--"Shamanistic Rage",
	[51490] = 35,				--"Thunderstorm",
	[2484] = 15,				--"Earthbind Totem",
	[8143] = 60,				--"Tremor Totem", patch 4.0.6
	[5730] = 20,				--"Stoneclaw Totem",
	[51514] = 35,				--"Hex",
	--[79206] = 120,			--"Spiritwalker's Grace",
	--[16166] = 180,			--"Elemental Mastery",
	--[16188] = 120,				--"Nature's Swiftness",
	--Warlock
	[74434] = 45,				--"Soulburn",
	[30283] = 20,				--"Shadowfury",
	[6789] = 90,				--"Death Coil",
	--[17962] = 8,				--"Conflagrate",
	--[74434] = 45,				--"Soulburn",
	--[6229] = 30,				--"Shadow Ward",
	[5484] = 32,				--"Howl of Terror",
	[54785] = 45,				--"Demon Leap",
	[48020] = 26,				--"Demonic Circle: Teleport",
	[17877] = 15,				--"Shadowburn",
	--[71521] = 12,				--"Hand of Gul'dan",
	--[91711] = 30,				--"Nether Ward",
	--Warrior
	--[12292] = 144, 				--"Death Wish",
	--[86346] = 20,				--"Colossus Smash",
	[85730] = 120,				--"Deadly Calm",
	[85388] = 45,				--"Throwdown",
	[100] = 13,					--"Charge",
	[6552] = 10,				--"Pummel",
	[72] = 12,					--"Shield Bash",
	[23920] = 20,				--"Spell Reflection",
	--[2565] = 30,				--"Shield Block",
	[676] = 60,					--"Disarm",
	--[5246] = 120,				--"Intimidation Shout",
	[871] = 120,				--"Shield Wall",	
	[20252] = 20,				--"Intercept",
	--[20230] = 300,			--"Retaliation",
	--[1719] = 240,				--"Recklessness",
	--[3411] = 30,				--"Intervene",
	[64382] = 90,				--"Shattering Throw",
	--[6544] = 40,				--"Heroic Leap",
	[12809] = 30,				--"Concussion Blow",
	[12975] = 180,				--"Last Stand",
	--[12328] = 60,				--"Sweeping Strikes",
	--[85730] = 120,			--"Deadly Calm",
	[60970] = 30,				--"Heroic Fury",
	[46924] = 75,				--"Bladestorm",
	[46968] = 17,				--"Shockwave",
}
end