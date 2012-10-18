local _, ns = ...

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end
--优先级别设置最小为1,数字越大优先级越高.
--first = 主要图标里显示 
--second = 次要图标里显示
--如果first与second列表里有重复spellid,将只会在主要图标显示.

--ascending  添加需要正数显示而并非传统的倒数显示aura剩余时间.比如龙母的毁坏debuff.同时你还要在debuffs或者instances里添加相应的spellid.只适用于debuff.true= 启用,false=禁用

--debuffs 要监视的debuff,任何地图.

--buffs 要监视的buff,任何地图.

--instances 副本地图里的debuff,可以使用地图的MapID(使用GetCurrentMapAreaID()获得)或者使用地图名称分类.

ns.auras_ascending = {
	--[GetSpellInfo(92956] = true,
}

ns.auras_buffs = {
	first = {
		--[139]= 9,
		--[GetSpellInfo(17] = 9, 	--test
	},
	second = {
		--[GetSpellInfo(61295] = 9, 	--test
		--------------------------战士---------------
		[871] = 2,	-- 盾墙
		[12975] = 2,	--破釜沉舟
		[97462] = 2,	--集结呐喊
		[2565] = 2,	--盾牌格挡
		--[GetSpellInfo(114030] = 2,	--警戒
		[114203] = 2,	--挫志战旗
		--------------------------骑士---------------
		[642] = 2,	--圣盾术
		[86659] = 2,	--远古列王守卫
		[31821] = 2,	--虔诚光环
		[31850] = 2,	--炽热防御者
		[498] = 2,	--圣佑术
		[1022] = 2,	--保护之手
		[1038] = 2,	--拯救之手
		[6940] = 2,	--牺牲之手
		[114039] = 2,	--纯净之手		
		--------------------------DK---------------
		[48707] = 2,	--反魔法护罩
		[50461] = 2,	--反魔法领域
		[42650] = 2,	--亡者大军
		--[GetSpellInfo(49222] = 2,	--白骨之盾
		[48792] = 2,	--冰封之韧
		[55233] = 2,	--吸血鬼之血
		[81256] = 2,	--符文刃舞
		------------------------德鲁伊---------------
		[22812] = 2,	--树皮术
		[22842] = 2,	--狂暴回复
		[61336] = 2,	--生存本能
		[106922] = 2,	--乌索尔之力
		------------------------牧师--------------------
		[33206] = 2, 	--痛苦压制
		[47788] = 2, 	--守护之魂
		[62618] = 2, 	--真言术:障
		------------------------武僧--------------------
		[116849] = 2, 	--作茧缚命
		[115213] = 2, 	--慈悲庇护
		[115176] = 2, 	--禅悟冥想
		[122783] = 2, 	--散魔功
		[115308] = 2, 	--飘渺酒
		[115295] = 2, 	--金钟罩
		[115203] = 2, 	--壮胆酒
		------------------------raid-------------------
		[106213] = 71, 	--奈萨里奥的血液
		--test
	},	
}

ns.auras_debuffs = {
	first = {
		[39171] = 9, -- Mortal Strike
		[76622] = 9, -- Sunder Armor	
		--[6788] = 9, --test
	},
	second = {
	
	},	
}

ns.auras_instances_debuffs = {
	first = {
		[781] = {--"祖阿曼(5人)"
			[43150] = 8, -- 利爪之怒
			[43648] = 8, -- 电能风暴
			[43501] = 8, -- 灵魂虹吸
			[43093] = 10, -- 重伤投掷
			[43095] = 10, -- 麻痹蔓延
			[42402] = 10, -- 澎湃
		},
		[793] = {--"祖尔格拉布(5人)"
			[96477] = 10, -- 剧毒连接
			[96466] = 8, -- 赫希斯之耳语
			[96776] = 12, -- 血祭
			[96423] = 10, -- 痛苦鞭笞
			[96342] = 10, -- 扑杀
		},
		
		[756] = {--"死亡矿井"
			--[GetSpellInfo(91016] = 7, -- 劈头斧
			[88352] = 8, -- 放置炸弹
			[91830] = 7, -- 注视
		},		
		
		[800] = { -- 火源
			--Trash 
			--Flamewaker Forward Guard 
			[76622] = 4, -- Sunder Armor 
			[99610] = 5, -- Shockwave 
			--Flamewaker Pathfinder 
			[99695] = 4, -- Flaming Spear 
			[99800] = 4, -- Ensnare 
			--Flamewaker Cauterizer 
			[99625] = 4, -- Conflagration (Magic/dispellable) 
			--Fire Scorpion 
			[99993] = 4, -- Fiery Blood 
			--Molten Lord 
			[100767] = 4, -- Melt Armor 
			--Ancient Core Hound 
			[99692] = 4, -- Terrifying Roar (Magic/dispellable) 
			[99693] = 4, -- Dinner Time 
			--Magma 
			[97151] = 4, -- Magma 

			--Beth'tilac 
			[99506] = 5, -- The Widow's Kiss 
			--Cinderweb Drone 
			[49026] = 6, -- Fixate 
			--Cinderweb Spinner 
			[97202] = 5, -- Fiery Web Spin 
			--Cinderweb Spiderling 
			[97079] = 4, -- Seeping Venom 
			--Cinderweb Broodling 

			[100048] = 4, --Fiery Web 

			--Lord Rhyolith 
			[98492] = 5, --Eruption 

			--Alysrazor 
			--[GetSpellInfo(101729] = 5, -- Blazing Claw 
			[100094] = 4, -- Fieroblast 
			[99389] = 5, -- Imprinted 
			[99308] = 4, -- Gushing Wound 
			[100640] = 6, -- Harsh Winds 
			[100555] = 6, -- Smouldering Roots 
			--Do we want to show these? 
			[99461] = 4, -- Blazing Power 
			--[GetSpellInfo(98734] = 4, -- Molten Feather 
			--[GetSpellInfo(98619] = 4, -- Wings of Flame 
			--[GetSpellInfo(100029] = 4, -- Alysra's Razor 

			--Shannox 
			[99936] = 5, -- Jagged Tear 
			[99837] = 7, -- Crystal Prison Trap Effect 
			--[GetSpellInfo(101208] = 4, -- Immolation Trap 
			[99840] = 4, -- Magma Rupture 
			-- Riplimp 
			[99937] = 5, -- Jagged Tear 
			-- Rageface 
			[99947] = 6, -- Face Rage 
			[100415] = 5, -- Rage  

			--守门人贝尔洛克 
			[99252] = 4, -- Blaze of Glory 
			[99256] = 15, -- 饱受磨难 
			--[GetSpellInfo(99403] = 6, -- Tormented 
			[99262] = 4, -- 活力火花
			[99263] = 4, -- 生命之焰
			[99516] = 7, -- Countdown 
			[99353] = 7, -- Decimating Strike 
			--[GetSpellInfo(100908] = 6, -- Fiery Torment 

			--Majordomo Staghelm 
			[98535] = 5, -- Leaping Flames 
			[98443] = 6, -- Fiery Cyclone 
			[98450] = 5, -- Searing Seeds 
			--Burning Orbs 
			--[GetSpellInfo(100210] = 6, -- Burning Orb 
			[96993] = 5, -- Stay Withdrawn? 

			--Ragnaros 
			[99399] = 5, -- Burning Wound 
			--[GetSpellInfo(100293] = 5, -- Lava Wave 
			[100238] = 4, -- Magma Trap Vulnerability 
			[98313] = 4, -- Magma Blast 
			--Lava Scion 
			[100460] = 7, -- Blazing Heat 
			--Dreadflame? 
			--Son of Flame 
			--Lava 
			[98981] = 5, -- Lava Bolt 
			--Molten Elemental 
			--Living Meteor 
			--[GetSpellInfo(100249] = 5, -- Combustion 
			--Molten Wyrms 
			[99613] = 6, -- Molten Blast   

		},	
		-- Dragon Soul
	   [824] = {
		  
			[103687] = 11, --Crush Armor
			[103821] = 12, --Earthen Vortex
			[103785] = 13, --Black Blood of the Earth
			[103534] = 14, --Danger (Red)
			[103536] = 15, --Warning (Yellow)
			-- Don't need to show Safe people
			[103541] = 16, --Safe (Blue)

			--督军
			[104378] = 21, --Black Blood of Go'rath
			[103434] = 22, --干扰之影

			--Yor'sahj the Unsleeping
			[104849] = 31, --虚空箭
			[105171] = 32, --深度腐蚀

			--Hagara the Stormbinder
			[105316] = 41, --Ice Lance
			[105465] = 42, --Lightning Storm
			[105369] = 43, --Lightning Conduit
			[105289] = 44, --Shattered Ice (dispellable)
			[105285] = 45, --Target (next Ice Lance)
			[104451] = 46, --Ice Tomb
			[110317] = 49, --水壕
			[109325] = 48, --霜冻

			--Ultraxion
			[105925] = 55, --黯淡之光
			[106108] = 52, --Heroic Will
			[105984] = 53, --Timeloop
			[105927] = 54, --Faded Into Twilight

			--Warmaster Blackhorn			  
			[107558] = 62, --溃变 
			[108046] = 63, --震荡波
			[110214] = 64, --吞噬遮幕
			[107567] = 65, --残忍打击
			[108043] = 66, --破甲

			--Spine of Deathwing
			[105563] = 71, --Grasping Tendrils
			[105479] = 72, --灼热血浆
			[105490] = 73, --灼热之握
			[106200] = 74, --血之腐蚀:大地
			[106199] = 75, --血之腐蚀:死亡

			--Madness of Deathwing
			[105445] = 81, --炽热
			[105841] = 82, --突变撕咬
			[106385] = 83, --重碾
			[106730] = 84, --破伤风
			[106444] = 85, --刺穿
			[106794] = 86, --碎屑
			[108649] = 87, --腐蚀寄生虫
		},	
		
		[875] = { --Gate of the Setting Sun 残阳关
			[107268] = 7,
			[106933] = 7,
			[115458] = 7,
			-- Raigonn 莱公
			[111644] = 7, -- Screeching Swarm 111640 111643
			[111723] = 7, --凝视
		},

		[885] = { --Mogu'shan Palace 魔古山神殿 
			
			-- Trial of the King 国王的试炼
			[119946] = 7, -- Ravage
			[120167] = 7, --焚烧
			[120195] = 7, --陨石术
			-- Xin the Weaponmaster <King of the Clans> 武器大师席恩
			[119684] = 7, --Ground Slam
		},
      
		[871] = { --Scarlet Halls 血色大厅

			-- Houndmaster Braun <PH Dressing>
			[114056] = 7, -- Bloody Mess
        
			-- Flameweaver Koegler
			[113653] = 7, -- Greater Dragon's Breath
			[11366] = 6,-- Pyroblast      
		},
      
		[874] = { --Scarlet Monastery 血色修道院 

			-- Thalnos the Soulrender
			[115144] = 7, -- Mind Rot
			[115297] = 6, -- Evict Soul
		},
      
		[763] = { --Scholomance 通灵学院 

			-- Instructor Chillheart
			[111631] = 7, -- Wrack Soul
			
			-- Lilian Voss
			[111585] = 7, -- Dark Blaze
			
			-- Darkmaster Gandling
			[108686] = 7, -- Immolate
		},
            
		[877] = { --Shado-Pan Monastery 影踪禅院 

			-- Sha of Violence
			[106872] = 7, -- Disorienting Smash
			
			-- Taran Zhu <Lord of the Shado-Pan>
			[112932] = 7, -- Ring of Malice
		},
      
		[887] = { --Siege of Niuzao Temple 围攻砮皂寺

			-- Wing Leader Ner'onok 
			[121447] = 7, -- Quick-Dry Resin
		},
      
		[867] = { --Temple of the Jade Serpent 青龙寺

			-- Wise Mari <Waterspeaker>
			[106653] = 7, -- Sha Residue
         
			-- Lorewalker Stonestep <The Keeper of Scrolls>
			[106653] = 7, -- Agony
         
			-- Liu Flameheart <Priestess of the Jade Serpent>
			[106823] = 7, -- Serpent Strike
         
			-- Sha of Doubt
			[106113] = 7, --Touch of Nothingness
		},
      
		[896] = { --Mogu'shan Vaults 魔古山宝库
         
			--Trash
			[118562] = 9, -- Petrified
			[116596] = 10, -- Smoke Bomb

			-- The Stone Guard
			[130395] = 11, -- Jasper Chains: Stacks
			[130404] = 12, -- Jasper Chains
			[130774] = 13, -- Amethyst Pool
			[116038] = 14, -- Jasper Petrification: stacks
			[115861] = 15, -- Cobalt Petrification: stacks
			[116060] = 16, -- Amethyst Petrification: stacks
			[116281] = 17, -- Cobalt Mine Blast, Magic root
			[125206] = 18, -- Rend Flesh: Tank only
			[116008] = 19, -- Jade Petrification: stacks

			--Feng the Accursed
			[116040] = 22, -- Epicenter, roomwide aoe.
			[116784] = 24, -- Wildfire Spark, Debuff that explodes leaving fire on the ground after 5 sec.
			[116374] = 29, -- Lightning Charge, Stun debuff.
			[116417] = 27, -- Arcane Resonance, aoe-people-around-you-debuff.
			[116942] = 23, -- Flaming Spear, fire damage dot.
			[131788] = 21, -- Lightning Lash: Tank Only: Stacks
			[131790] = 25, -- Arcane Shock: Stack : Tank Only
			[102464] = 26, -- Arcane Shock: AOE
			[116364] = 28, -- Arcane Velocity
			[131792] = 30, -- Shadowburn: Tank only: Stacks: HEROIC ONLY

			-- Gara'jal the Spiritbinder
			[122151] = 41,   -- Voodoo Doll, shared damage with the tank.
			[117723] = 42,   -- Frail Soul: HEROIC ONLY --虛弱靈魂
			[116161] = 43,   -- Crossed Over, people in the spirit world.

			-- The Spirit Kings
			[117708] = 51, -- Meddening Shout, The mind control debuff.
			[118303] = 52, -- Fixate, the once targeted by the shadows.
			[118048] = 53, -- Pillaged, the healing/Armor/damage debuff.
			[118135] = 54, -- Pinned Down, Najentus spine 2.0
			[118047] = 55, -- Pillage: Target
			[118163] = 56, -- Robbed Blind

			--Elegon
			[117878] = 61, -- Overcharged, the stacking increased damage taken debuff.   
			[117945] = 63, -- Arcing Energy
			[117949] = 62, -- Closed Circuit, Magic Healing debuff.

			--Will of the Emperor
			[116969] = 76, -- Stomp, Stun from the bosses.
			[116835] = 77, -- Devestating Arc, Armor debuff from the boss.
			[116969] = 75, -- Focused Energy.
			[116778] = 72, -- Focused Defense, Fixate from the Emperors Courage.
			[117485] = 73, -- Impending Thrust, Stacking slow from the Emperors Courage.
			[116525] = 71, -- Focused Assault, Fixate from the Emperors Rage
			[116550] = 74, -- Energizing Smash, Knockdown from the Emperors Strength
		},
      
		[897] = { --Heart of Fear 恐惧之心 
         
			-- Imperial Vizier Zor'lok
			[122760] = 11, -- Exhale, The person targeted for Exhale. 
			[123812] = 12, -- Pheromones of Zeal, the gas in the middle of the room.
			[122706] = 14, -- Noise Cancelling, The "safe zone" from the roomwide aoe.
			[122740] = 13, -- Convert, The mindcontrol Debuff.

			-- Blade Lord Ta'yak
			[123180] = 21, -- Wind Step, Bleeding Debuff from stealth.
			[123474] = 23, -- Overwhelming Assault, stacking tank swap debuff. 
			[122949] = 22, -- Unseen Strike
			[124783] = 24, -- Storm Unleashed
			[123600] = 25, -- Storm Unleashed?

			-- Garalon
			[122774] = 31, -- Crush, stun from the crush ability.
			[123120] = 34, --- Pheromone Trail
			[122835] = 32, -- Pheromones, The buff indicating who is carrying the pheramone.
			[123081] = 33, -- Punchency, The stacking debuff causing the raid damage.

			--Wind Lord Mel'jarak
			[122055] = 42, -- Residue, The debuff after breaking a prsion preventing further breaking.
			[121881] = 41, -- Amber Prison, not sure what the differance is but both were used.
			[122064] = 43, -- Corrosive Resin, the dot you clear by moving/jumping.

			-- Amber-Shaper Un'sok 
			[122064] = 53, -- Corrosive Resin
			[122784] = 52, -- Reshape Life, Both were used.
			[122504] = 54, --Burning Amber.
			[121949] = 51, -- Parasitic Growth, the dot that scales with healing taken.
		
			--Grand Empress Shek'zeer
			[125390] = 61, --Fixate.
			[123707] = 62, --Eyes of the Empress.
			[123788] = 63, --Cry of Terror.
			[124097] = 64, --Sticky Resin.
			[125824] = 65, --Trapped!.
			[124777] = 66, --Poison Bomb.
			[124821] = 67, --Poison-Drenched Armor.
			[124827] = 68, --Poison Fumes.
			[124849] = 69, --Consuming Terror.
			[124863] = 70, --Visions of Demise.
			[124862] = 71, --Visions of Demise: Target.
			[123845] = 72, --Heart of Fear: Chosen.
			[123846] = 73, --Heart of Fear: Lure.
		},
      
		[886] = { --Terrace of Endless Spring 永春台
			
			--Trash
			[125760] = 10,

			--Protectors Of the Endless
			[117519] = 11, -- Touch of Sha, Dot that lasts untill Kaolan is defeated.
			[111850] = 12, -- Lightning Prison: Targeted
			[117986] = 15, -- Defiled Ground: Stacks
			[118191] = 14, -- Corrupted Essence
			[117436] = 13, -- Lightning Prison, Magic stun.

			--Tsulong
			[122768] = 21, -- Dread Shadows, Stacking raid damage debuff (ragnaros superheated style) 
			[122789] = 24, -- Sunbeam, standing in the sunbeam, used to clear dread shadows.
			[122858] = 28, -- Bathed in Light, 500% increased healing done debuff.
			[122752] = 23, -- Shadow Breath, increased shadow breath damage debuff.
			[123011] = 26, -- Terrorize: 10%, Magical dot dealing % health.
			[123036] = 27, -- Fright, 2 second fear.
			[122777] = 22, -- Nightmares, 3 second fear.
			[123012] = 25, -- Terrorize: 5% 
			
			--Lei Shi
			[123121] = 31, -- Spray, Stacking frost damage taken debuff.
			[123705] = 32, -- Scary Fog
			
			--Sha of Fear
			[129147] = 42, -- Ominous Cackle, Debuff that sends players to the outer platforms.
			[119086] = 49, -- Penetrating Bolt, Increased Shadow damage debuff.
			[119775] = 50, -- Reaching Attack, Increased Shadow damage debuff.
			[120669] = 44, -- Naked and Afraid.
			[119983] = 43, -- Dread Spray, is also used.
			[119414] = 41, -- Breath of Fear, Fear+Massiv damage.
			[75683] = 45, -- Waterspout
			[120629] = 46, -- Huddle in Terror
			[120394] = 47, --Eternal Darkness
			[129189] = 48, --Sha Globe
		},
			--Sha of Anger
			[119626] = 11, --Aggressive Behavior
			[119488] = 12, --Unleashed Wrath
			[119610] = 13, --Bitter Thoughts
			[119601] = 14, --Bitter Thoughts
	},
	second = {
	
	},	
}