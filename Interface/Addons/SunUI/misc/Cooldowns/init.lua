local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
S.CooldownsMod = {}
--替换规则
--正则替换 \{[^\{^\}]+\},
--为true,

S.CooldownsMod.ClassCD = {
	--talent
	
	[121283] =  true, -- Power Strike
	[122281] =  true, -- Healing Elixirs
	-- shaman
	[31616] =  true, -- Nature's Guardian
	-- mage
	[87023] =  true, -- Cauterize
	-- rogue
	[45182] =  true, -- Cheated Death
	-- priest
	[114214] =  true, -- Angelic Bulwark
	-- dk
	[116888] =  true, -- Purgatory	
	-- druid
	[68285] =  true, -- Leader of the Pack
	
	--[[--dk
	[96171] =  true, -- Will of the Necropolis
	]]
	--warlock
	[104317] =  true, --
		
-- item
	-- type = "item" 
	-- item = {the item id}
	-- WOD 6.0
	[177063] =  true, -- Elementalist's Shielding Talisman
	[177056] =  true, -- Blast Furnace Door
	[177051] =  true, -- Darmac's Unstable Talisman
	[177096] =  true, -- Forgemaster's Insignia
	[177081] =  true, -- Blackiron Micro Crucible
	[177067] =  true, -- Humming Blackiron Trigger
	[177086] =  true, -- Auto-Repairing Autoclave
	[177102] =  true, -- Battering Talisman
	[177035] =  true, -- Meaty Dragonspine Trophy
	[177060] =  true, -- Ironspike Chew Toy
	[177042] =  true, -- Horn of Screaming Spirits
	[177046] =  true, -- Goren Soul Repository
	
	[177053] =  true, -- Evergaze Arcane Eidolon
	[177038] =  true, -- Scales of Doom
	[177040] =  true, -- Tectus' Beating Heart
	[165824] =  true, -- Petrified Flesh-Eating Spore
	[176980] =  true, -- Furyheart Talisman
	[176984] =  true, -- Blackheart Enforcer's Medallion
	[176982] =  true, -- Stoneheart Idol
	[176978] =  true, -- Immaculate Living Mushroom
	[162915] =  true, -- Skull of War
	[162913] =  true, -- Winged Hourglass
	[162919] =  true, -- Sandman's Pouch
	[162917] =  true, -- Knight's Badge
	
	[176974] =  true, -- Mote of the Mountain
	
	--WOD heroic
	[165822] =  true, -- Witherbark's Branch, Spores of Alacrity
	
	[165832] =  true, -- Coagulated Genesaur Blood
	[165833] =  true, -- Leaf of the Ancient Protectors
	[165824] =  true, -- Xeri'tac's Unhatched Egg Sac
	
	-- MOP 5.4
	-- Legendary cloak
	[148010] =  true, -- Qian-Le, Courage of Niuzao & Qian-Ying, Fortitude of Niuzao
	[146198] =  true, -- Xing-Ho, Breath of Yu'lon
	[146194] =  true, -- Fen-Yu, Fury of Xuen & Gong-Lu, Strength of Xuen
	[146200] =  true, -- Jina-Kang, Kindness of Chi-Ji
	
	-- SoO 6.02ALL/ WH(Warforged Heroic)/ H/ WN/ N/ F(Flexible)/ LFR  
	[148911] =  true, -- Thok's Acid-Grooved Tooth
	[146250] =  true, -- Thok's Tail Tip
	[146046] =  true, -- Purified Bindings of Immerseus
	[146308] =  true, -- Assurance of Consequence
	[146314] =  true, -- Prismatic Prison of Pride
	[146245] =  true, -- Evil Eye of Galakras
	[148903] =  true, -- Haromm's Talisman
	[148906] =  true, -- Kardris' Toxic Totem
	[148908] =  true, -- Nazgrim's Burnished Insignia
	[148897] =  true, -- Frenzied Crystal of Rage
	[148896] =  true, -- Sigil of Rampage
	[146310] =  true, -- Ticking Ebon Detonator
	[146317] =  true, -- Dysmorphic Samophlange of Discontinuity
	[146285] =  true, -- Skeer's Bloodsoaked Talisman
	[146184] =  true, -- Black Blood of Y'Shaarj
	[148899] =  true, -- Fusion-Fire Core
	
	-- Timeless series 535 & 496 
	[146218] =  true, -- Yu'lon's Bite
	[146296] =  true, -- Alacrity of Xuen
	[146312] =  true, -- Discipline of Xuen
			
	
		
	-- MOP 5.2
	-- TH(Thunderforged Heroic)/ H/ TN/ N/ LFR Raid
	[138756] =  true, -- Renataki's Soul Charm
	[138856] =  true, -- Horridon's Last Gasp
	[138938] =  true, -- Bad Juju
	[138786] =  true, -- Wushoolay's Final Choice
	[138898] =  true, -- Breath of the Hydra
	[140380] =  true, -- Inscribed Bag of Hydra-Spawn
	
	[138759] =  true, -- Fabled Feather of Ji-Kun
	
	[138895] =  true, -- Talisman of Bloodlust
	
	[138973] =  true, -- Ji-Kun's Rising Winds
	
	[138870] =  true, -- Primordius' Talisman of Rage
	
	-- this ones' rppm are differs by spec or based on critical chance, temporarily set their duration only 
	-----------------------------------------------
	[139133] =  true, -- Cha-Ye's Essence of Brilliance		
	[139170] =  true, -- Gaze of the Twins		
	[138963] =  true, -- Unerring Vision of Lei-Shen
	[139120] =  true, -- Rune of Re-Origination
	[139117] =  true, -- Rune of Re-Origination
	[139121] =  true, -- Rune of Re-Origination
	------------------------------------------------
	--  522 Valor Point
	[138703] =  true, -- Volatile Talisman of the Shado-Pan Assault
	[138702] =  true, -- Brutal Talisman of the Shado-Pan Assault
	[138699] =  true, -- Vicious Talisman of the Shado-Pan Assault			
	
	-- MOP 5.0
	-- 509 496 483 Raid
	[126646] =  true, -- Stuff of Nightmares
	[126640] =  true,
	[126649] =  true,
	[126657] =  true, -- H
	[126659] =  true, -- H
	
	-- 502 489 476 Raid
	[126554] =  true, -- H
	[126533] =  true, -- H
	[126577] =  true, -- H
	[126582] =  true, -- H
	[126588] =  true, -- H
	
	
	-- pvp 660(H/L Tournoment set) 660(H/L set) 620(H/L set) 550(H/L set) 522(H/L set) 496(H/L set) 496(H/L) 483 476 458
	[126707] =  true, -- AGI
	[126705] =  true, -- SP
	[126700] =  true, -- STR
	
	-- Darkmoon Card 476
	[128985] =  true, -- Relic of Yu'lon
	[128986] =  true, -- Relic of Xuen STR
	[128984] =  true, -- Relic of Xuen AGI
	[128987] =  true, -- Relic of Chi Ji
	
	-- 470 
	[127923] =  true, -- Mithril Wristwatch
	[127928] =  true, -- Coren's Cold Chromium Coaster		
	[127915] =  true, -- Thousand-Year Pickled Egg
	
	-- 463 Heroic
	[126489] =  true, -- Searing Words
	[126483] =  true, -- Windswept Pages		
	[126236] =  true, -- Iron Protector Talisman
	[126266] =  true, -- Empty Fruit Barrel
	[126476] =  true, -- Vision of the Predator
	[126513] =  true, -- Carbonic Carbuncle		
	[126483] =  true, -- Windswept Pages
	[126489] =  true, -- Searing Words
	
	-- 450 and others
	[60234] =  true, -- Zen Alchemist Stone(Intellect)
	[60233] =  true, -- Zen Alchemist Stone(Agility)
	[60229] =  true, -- Zen Alchemist Stone(Strength)

	-- item set
	-- enchant
	-- Cataclysm
	[74241] =  true, -- Power Torrent
	[99621] =  true, -- Flintlocke's Woodchucker
	[74221] =  true, -- Hurricane
	[74224] =  true, -- Heartsong
	[59626] =  true, -- Black Magic
	-- MOP
	[104993] =  true, -- Jade Spirit
	[142535] =  true, -- Spirit of Conquest
	[120032] =  true, -- Steel Dancing
	[142530] =  true, -- Bloody Dancing Steel
	[116660] =  true, -- River's Song
	
	-- WOD
	[159675] =  true, -- Mark of Warsong
	[159234] =  true, -- Mark of the Thunderlord
	[159676] =  true, -- Mark of the Frostwolf
	[159678] =  true, -- Mark of Shadowmoon
	[173322] =  true, -- Mark of Bleeding Hollow
	[159679] =  true, -- Mark of Blackrock
	[137593] =  true, -- Indomitable Primal Diamond
	[137590] =  true, -- Sinister Primal Diamond
	[137331] =  true, -- Courageous Primal Diamond -- Monk
	[137247] =  true, -- Courageous Primal Diamond -- Druid
	[137288] =  true, -- Courageous Primal Diamond -- Paladin
	[137323] =  true, -- Courageous Primal Diamond -- Priest
	[137326] =  true, -- Courageous Primal Diamond -- Shaman
}

S.CooldownsMod.RaidCD = {
	-- 群体减伤
	[740]     = 180,  -- 宁静(ND) *
	[64843]   = 180,  -- 神圣赞美诗 *
	[108280]  = 180,  -- 治疗之潮图腾
	[115310]  = 180,  -- 还魂术
	[157535]  =  90,  -- 蟠龙之息
	[115176]  = 180,  -- 禅悟冥想
	[15286]   = 180,  -- 吸血鬼的拥抱
	[51052]   = 120,  -- 反魔法领域
	[31821]   = 120,  -- 虔诚光环
	[62618]   = 180,  -- 真言术: 障
	[88611]   = 180,  -- 烟雾弹
	[98008]   = 180,  -- 灵魂链接图腾
	[97462]   = 180,  -- 集结呐喊

	-- 单体减伤
	[102342]  =  60,  -- 铁木树皮 
	[116849]  = 100,  -- 作茧缚命 
	[6940]    = 120,  -- 牺牲之手
	[1038]    = 120,  -- 拯救之手
	[1022]    = 300,  -- 保护之手
	[33206]   = 180,  -- 痛苦压制 
	[47788]   = 180,  -- 守护之魂 
	[633]     = 600,  -- 圣疗术

	--其他团队增益
	[20484]   = 600,  -- 复生
	[61999]   = 600,  -- 复活盟友
	[20707]   = 900,  -- 灵魂石复活
	[126393]  = 600,  -- 永恒守护者
	[32182]   = 300,  -- 英勇
	[2825]    = 300,  -- 嗜血
	[80353]   = 300,  -- 时间扭曲
	[160452]  = 300,  -- 虛空之风
	[90355]   = 300,  -- 远古狂乱
	[159916]  = 120,  -- 魔法增效 
	[106898]  = 120,  -- 狂奔怒吼 
	[172166]  = 180,  -- 灵狐守护
	[6346]    = 180,  -- 防护恐惧结界
}
