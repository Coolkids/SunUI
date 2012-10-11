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
	--[GetSpellInfo(92956)] = true,
}

ns.auras_buffs = {
	first = {
		--[GetSpellInfo(17)] = 9, 	--test
	},
	second = {
		--[GetSpellInfo(61295)] = 9, 	--test
		--------------------------战士---------------
		[GetSpellInfo(871)] = 2,	-- 盾墙
		[GetSpellInfo(12975)] = 2,	--破釜沉舟
		[GetSpellInfo(97462)] = 2,	--集结呐喊
		[GetSpellInfo(2565)] = 2,	--盾牌格挡
		--[GetSpellInfo(114030)] = 2,	--警戒
		[GetSpellInfo(114203)] = 2,	--挫志战旗
		--------------------------骑士---------------
		[GetSpellInfo(642)] = 2,	--圣盾术
		[GetSpellInfo(86659)] = 2,	--远古列王守卫
		[GetSpellInfo(31821)] = 2,	--虔诚光环
		[GetSpellInfo(31850)] = 2,	--炽热防御者
		[GetSpellInfo(498)] = 2,	--圣佑术
		[GetSpellInfo(1022)] = 2,	--保护之手
		[GetSpellInfo(1038)] = 2,	--拯救之手
		[GetSpellInfo(6940)] = 2,	--牺牲之手
		[GetSpellInfo(114039)] = 2,	--纯净之手		
		--------------------------DK---------------
		[GetSpellInfo(48707)] = 2,	--反魔法护罩
		[GetSpellInfo(50461)] = 2,	--反魔法领域
		[GetSpellInfo(42650)] = 2,	--亡者大军
		--[GetSpellInfo(49222)] = 2,	--白骨之盾
		[GetSpellInfo(48792)] = 2,	--冰封之韧
		[GetSpellInfo(55233)] = 2,	--吸血鬼之血
		[GetSpellInfo(81256)] = 2,	--符文刃舞
		------------------------德鲁伊---------------
		[GetSpellInfo(22812)] = 2,	--树皮术
		[GetSpellInfo(22842)] = 2,	--狂暴回复
		[GetSpellInfo(61336)] = 2,	--生存本能
		[GetSpellInfo(106922)] = 2,	--乌索尔之力
		------------------------牧师--------------------
		[GetSpellInfo(33206)] = 2, 	--痛苦压制
		[GetSpellInfo(47788)] = 2, 	--守护之魂
		[GetSpellInfo(62618)] = 2, 	--真言术:障
		------------------------武僧--------------------
		[GetSpellInfo(116849)] = 2, 	--作茧缚命
		[GetSpellInfo(115213)] = 2, 	--慈悲庇护
		[GetSpellInfo(115176)] = 2, 	--禅悟冥想
		[GetSpellInfo(122783)] = 2, 	--散魔功
		[GetSpellInfo(115308)] = 2, 	--飘渺酒
		[GetSpellInfo(115295)] = 2, 	--金钟罩
		[GetSpellInfo(115203)] = 2, 	--壮胆酒
		------------------------raid-------------------
		[GetSpellInfo(106213)] = 71, 	--奈萨里奥的血液
	},	
}

ns.auras_debuffs = {
	first = {
		[GetSpellInfo(39171)] = 9, -- Mortal Strike
		[GetSpellInfo(76622)] = 9, -- Sunder Armor	
	},
	second = {
	
	},	
}

ns.auras_instances_debuffs = {
	first = {
		[781] = {--"祖阿曼(5人)"
			[GetSpellInfo(43150)] = 8, -- 利爪之怒
			[GetSpellInfo(43648)] = 8, -- 电能风暴
			[GetSpellInfo(43501)] = 8, -- 灵魂虹吸
			[GetSpellInfo(43093)] = 10, -- 重伤投掷
			[GetSpellInfo(43095)] = 10, -- 麻痹蔓延
			[GetSpellInfo(42402)] = 10, -- 澎湃
		},
		[793] = {--"祖尔格拉布(5人)"
			[GetSpellInfo(96477)] = 10, -- 剧毒连接
			[GetSpellInfo(96466)] = 8, -- 赫希斯之耳语
			[GetSpellInfo(96776)] = 12, -- 血祭
			[GetSpellInfo(96423)] = 10, -- 痛苦鞭笞
			[GetSpellInfo(96342)] = 10, -- 扑杀
		},
		
		[756] = {--"死亡矿井"
			--[GetSpellInfo(91016)] = 7, -- 劈头斧
			[GetSpellInfo(88352)] = 8, -- 放置炸弹
			[GetSpellInfo(91830)] = 7, -- 注视
		},		
		
		[800] = { -- 火源
			--Trash 
			--Flamewaker Forward Guard 
			[GetSpellInfo(76622)] = 4, -- Sunder Armor 
			[GetSpellInfo(99610)] = 5, -- Shockwave 
			--Flamewaker Pathfinder 
			[GetSpellInfo(99695)] = 4, -- Flaming Spear 
			[GetSpellInfo(99800)] = 4, -- Ensnare 
			--Flamewaker Cauterizer 
			[GetSpellInfo(99625)] = 4, -- Conflagration (Magic/dispellable) 
			--Fire Scorpion 
			[GetSpellInfo(99993)] = 4, -- Fiery Blood 
			--Molten Lord 
			[GetSpellInfo(100767)] = 4, -- Melt Armor 
			--Ancient Core Hound 
			[GetSpellInfo(99692)] = 4, -- Terrifying Roar (Magic/dispellable) 
			[GetSpellInfo(99693)] = 4, -- Dinner Time 
			--Magma 
			[GetSpellInfo(97151)] = 4, -- Magma 

			--Beth'tilac 
			[GetSpellInfo(99506)] = 5, -- The Widow's Kiss 
			--Cinderweb Drone 
			[GetSpellInfo(49026)] = 6, -- Fixate 
			--Cinderweb Spinner 
			[GetSpellInfo(97202)] = 5, -- Fiery Web Spin 
			--Cinderweb Spiderling 
			[GetSpellInfo(97079)] = 4, -- Seeping Venom 
			--Cinderweb Broodling 

			[GetSpellInfo(100048)] = 4, --Fiery Web 

			--Lord Rhyolith 
			[GetSpellInfo(98492)] = 5, --Eruption 

			--Alysrazor 
			--[GetSpellInfo(101729)] = 5, -- Blazing Claw 
			[GetSpellInfo(100094)] = 4, -- Fieroblast 
			[GetSpellInfo(99389)] = 5, -- Imprinted 
			[GetSpellInfo(99308)] = 4, -- Gushing Wound 
			[GetSpellInfo(100640)] = 6, -- Harsh Winds 
			[GetSpellInfo(100555)] = 6, -- Smouldering Roots 
			--Do we want to show these? 
			[GetSpellInfo(99461)] = 4, -- Blazing Power 
			--[GetSpellInfo(98734)] = 4, -- Molten Feather 
			--[GetSpellInfo(98619)] = 4, -- Wings of Flame 
			--[GetSpellInfo(100029)] = 4, -- Alysra's Razor 

			--Shannox 
			[GetSpellInfo(99936)] = 5, -- Jagged Tear 
			[GetSpellInfo(99837)] = 7, -- Crystal Prison Trap Effect 
			--[GetSpellInfo(101208)] = 4, -- Immolation Trap 
			[GetSpellInfo(99840)] = 4, -- Magma Rupture 
			-- Riplimp 
			[GetSpellInfo(99937)] = 5, -- Jagged Tear 
			-- Rageface 
			[GetSpellInfo(99947)] = 6, -- Face Rage 
			[GetSpellInfo(100415)] = 5, -- Rage  

			--守门人贝尔洛克 
			[GetSpellInfo(99252)] = 4, -- Blaze of Glory 
			[GetSpellInfo(99256)] = 15, -- 饱受磨难 
			--[GetSpellInfo(99403)] = 6, -- Tormented 
			[GetSpellInfo(99262)] = 4, -- 活力火花
			[GetSpellInfo(99263)] = 4, -- 生命之焰
			[GetSpellInfo(99516)] = 7, -- Countdown 
			[GetSpellInfo(99353)] = 7, -- Decimating Strike 
			--[GetSpellInfo(100908)] = 6, -- Fiery Torment 

			--Majordomo Staghelm 
			[GetSpellInfo(98535)] = 5, -- Leaping Flames 
			[GetSpellInfo(98443)] = 6, -- Fiery Cyclone 
			[GetSpellInfo(98450)] = 5, -- Searing Seeds 
			--Burning Orbs 
			--[GetSpellInfo(100210)] = 6, -- Burning Orb 
			[GetSpellInfo(96993)] = 5, -- Stay Withdrawn? 

			--Ragnaros 
			[GetSpellInfo(99399)] = 5, -- Burning Wound 
			--[GetSpellInfo(100293)] = 5, -- Lava Wave 
			[GetSpellInfo(100238)] = 4, -- Magma Trap Vulnerability 
			[GetSpellInfo(98313)] = 4, -- Magma Blast 
			--Lava Scion 
			[GetSpellInfo(100460)] = 7, -- Blazing Heat 
			--Dreadflame? 
			--Son of Flame 
			--Lava 
			[GetSpellInfo(98981)] = 5, -- Lava Bolt 
			--Molten Elemental 
			--Living Meteor 
			--[GetSpellInfo(100249)] = 5, -- Combustion 
			--Molten Wyrms 
			[GetSpellInfo(99613)] = 6, -- Molten Blast   

		},	
		-- Dragon Soul
	   [824] = {
		  
			[GetSpellInfo(103687)] = 11, --Crush Armor
			[GetSpellInfo(103821)] = 12, --Earthen Vortex
			[GetSpellInfo(103785)] = 13, --Black Blood of the Earth
			[GetSpellInfo(103534)] = 14, --Danger (Red)
			[GetSpellInfo(103536)] = 15, --Warning (Yellow)
			-- Don't need to show Safe people
			[GetSpellInfo(103541)] = 16, --Safe (Blue)

			--督军
			[GetSpellInfo(104378)] = 21, --Black Blood of Go'rath
			[GetSpellInfo(103434)] = 22, --干扰之影

			--Yor'sahj the Unsleeping
			[GetSpellInfo(104849)] = 31, --虚空箭
			[GetSpellInfo(105171)] = 32, --深度腐蚀

			--Hagara the Stormbinder
			[GetSpellInfo(105316)] = 41, --Ice Lance
			[GetSpellInfo(105465)] = 42, --Lightning Storm
			[GetSpellInfo(105369)] = 43, --Lightning Conduit
			[GetSpellInfo(105289)] = 44, --Shattered Ice (dispellable)
			[GetSpellInfo(105285)] = 45, --Target (next Ice Lance)
			[GetSpellInfo(104451)] = 46, --Ice Tomb
			[GetSpellInfo(110317)] = 49, --水壕
			[GetSpellInfo(109325)] = 48, --霜冻

			--Ultraxion
			[GetSpellInfo(105925)] = 55, --黯淡之光
			[GetSpellInfo(106108)] = 52, --Heroic Will
			[GetSpellInfo(105984)] = 53, --Timeloop
			[GetSpellInfo(105927)] = 54, --Faded Into Twilight

			--Warmaster Blackhorn			  
			[GetSpellInfo(107558)] = 62, --溃变 
			[GetSpellInfo(108046)] = 63, --震荡波
			[GetSpellInfo(110214)] = 64, --吞噬遮幕
			[GetSpellInfo(107567)] = 65, --残忍打击
			[GetSpellInfo(108043)] = 66, --破甲

			--Spine of Deathwing
			[GetSpellInfo(105563)] = 71, --Grasping Tendrils
			[GetSpellInfo(105479)] = 72, --灼热血浆
			[GetSpellInfo(105490)] = 73, --灼热之握
			[GetSpellInfo(106200)] = 74, --血之腐蚀:大地
			[GetSpellInfo(106199)] = 75, --血之腐蚀:死亡

			--Madness of Deathwing
			[GetSpellInfo(105445)] = 81, --炽热
			[GetSpellInfo(105841)] = 82, --突变撕咬
			[GetSpellInfo(106385)] = 83, --重碾
			[GetSpellInfo(106730)] = 84, --破伤风
			[GetSpellInfo(106444)] = 85, --刺穿
			[GetSpellInfo(106794)] = 86, --碎屑
			[GetSpellInfo(108649)] = 87, --腐蚀寄生虫
		},	
		
		[875] = { --Gate of the Setting Sun 残阳关
			
			-- Raigonn 莱公
			[GetSpellInfo(111644)] = 7, -- Screeching Swarm 111640 111643
		},

		[885] = { --Mogu'shan Palace 魔古山神殿 
			
			-- Trial of the King 国王的试炼
			[GetSpellInfo(119946)] = 7, -- Ravage
			[GetSpellInfo(120167)] = 7, --焚烧
			[GetSpellInfo(120195)] = 7, --陨石术
			-- Xin the Weaponmaster <King of the Clans> 武器大师席恩
			[GetSpellInfo(119684)] = 7, --Ground Slam
		},
      
		[871] = { --Scarlet Halls 血色大厅

			-- Houndmaster Braun <PH Dressing>
			[GetSpellInfo(114056)] = 7, -- Bloody Mess
        
			-- Flameweaver Koegler
			[GetSpellInfo(113653)] = 7, -- Greater Dragon's Breath
			[GetSpellInfo(11366)] = 6,-- Pyroblast      
		},
      
		[874] = { --Scarlet Monastery 血色修道院 

			-- Thalnos the Soulrender
			[GetSpellInfo(115144)] = 7, -- Mind Rot
			[GetSpellInfo(115297)] = 6, -- Evict Soul
		},
      
		[763] = { --Scholomance 通灵学院 

			-- Instructor Chillheart
			[GetSpellInfo(111631)] = 7, -- Wrack Soul
			
			-- Lilian Voss
			[GetSpellInfo(111585)] = 7, -- Dark Blaze
			
			-- Darkmaster Gandling
			[GetSpellInfo(108686)] = 7, -- Immolate
		},
            
		[877] = { --Shado-Pan Monastery 影踪禅院 

			-- Sha of Violence
			[GetSpellInfo(106872)] = 7, -- Disorienting Smash
			
			-- Taran Zhu <Lord of the Shado-Pan>
			[GetSpellInfo(112932)] = 7, -- Ring of Malice
		},
      
		[887] = { --Siege of Niuzao Temple 围攻砮皂寺

			-- Wing Leader Ner'onok 
			[GetSpellInfo(121447)] = 7, -- Quick-Dry Resin
		},
      
		[867] = { --Temple of the Jade Serpent 青龙寺

			-- Wise Mari <Waterspeaker>
			[GetSpellInfo(106653)] = 7, -- Sha Residue
         
			-- Lorewalker Stonestep <The Keeper of Scrolls>
			[GetSpellInfo(106653)] = 7, -- Agony
         
			-- Liu Flameheart <Priestess of the Jade Serpent>
			[GetSpellInfo(106823)] = 7, -- Serpent Strike
         
			-- Sha of Doubt
			[GetSpellInfo(106113)] = 7, --Touch of Nothingness
		},
      
		[896] = { --Mogu'shan Vaults 魔古山宝库
         
			--Trash
			[GetSpellInfo(118562)] = 9, -- Petrified
			[GetSpellInfo(116596)] = 10, -- Smoke Bomb

			-- The Stone Guard
			[GetSpellInfo(130395)] = 11, -- Jasper Chains: Stacks
			[GetSpellInfo(130404)] = 12, -- Jasper Chains
			[GetSpellInfo(130774)] = 13, -- Amethyst Pool
			[GetSpellInfo(116038)] = 14, -- Jasper Petrification: stacks
			[GetSpellInfo(115861)] = 15, -- Cobalt Petrification: stacks
			[GetSpellInfo(116060)] = 16, -- Amethyst Petrification: stacks
			[GetSpellInfo(116281)] = 17, -- Cobalt Mine Blast, Magic root
			[GetSpellInfo(125206)] = 18, -- Rend Flesh: Tank only
			[GetSpellInfo(116008)] = 19, -- Jade Petrification: stacks

			--Feng the Accursed
			[GetSpellInfo(116040)] = 22, -- Epicenter, roomwide aoe.
			[GetSpellInfo(116784)] = 24, -- Wildfire Spark, Debuff that explodes leaving fire on the ground after 5 sec.
			[GetSpellInfo(116374)] = 29, -- Lightning Charge, Stun debuff.
			[GetSpellInfo(116417)] = 27, -- Arcane Resonance, aoe-people-around-you-debuff.
			[GetSpellInfo(116942)] = 23, -- Flaming Spear, fire damage dot.
			[GetSpellInfo(131788)] = 21, -- Lightning Lash: Tank Only: Stacks
			[GetSpellInfo(131790)] = 25, -- Arcane Shock: Stack : Tank Only
			[GetSpellInfo(102464)] = 26, -- Arcane Shock: AOE
			[GetSpellInfo(116364)] = 28, -- Arcane Velocity
			[GetSpellInfo(131792)] = 30, -- Shadowburn: Tank only: Stacks: HEROIC ONLY

			-- Gara'jal the Spiritbinder
			[GetSpellInfo(122151)] = 41,   -- Voodoo Doll, shared damage with the tank.
			[GetSpellInfo(117723)] = 42,   -- Frail Soul: HEROIC ONLY
			[GetSpellInfo(116161)] = 43,   -- Crossed Over, people in the spirit world.

			-- The Spirit Kings
			[GetSpellInfo(117708)] = 51, -- Meddening Shout, The mind control debuff.
			[GetSpellInfo(118303)] = 52, -- Fixate, the once targeted by the shadows.
			[GetSpellInfo(118048)] = 53, -- Pillaged, the healing/Armor/damage debuff.
			[GetSpellInfo(118135)] = 54, -- Pinned Down, Najentus spine 2.0
			[GetSpellInfo(118047)] = 55, -- Pillage: Target
			[GetSpellInfo(118163)] = 56, -- Robbed Blind

			--Elegon
			[GetSpellInfo(117878)] = 61, -- Overcharged, the stacking increased damage taken debuff.   
			[GetSpellInfo(117945)] = 63, -- Arcing Energy
			[GetSpellInfo(117949)] = 62, -- Closed Circuit, Magic Healing debuff.

			--Will of the Emperor
			[GetSpellInfo(116969)] = 76, -- Stomp, Stun from the bosses.
			[GetSpellInfo(116835)] = 77, -- Devestating Arc, Armor debuff from the boss.
			[GetSpellInfo(116969)] = 75, -- Focused Energy.
			[GetSpellInfo(116778)] = 72, -- Focused Defense, Fixate from the Emperors Courage.
			[GetSpellInfo(117485)] = 73, -- Impending Thrust, Stacking slow from the Emperors Courage.
			[GetSpellInfo(116525)] = 71, -- Focused Assault, Fixate from the Emperors Rage
			[GetSpellInfo(116550)] = 74, -- Energizing Smash, Knockdown from the Emperors Strength
		},
      
		[897] = { --Heart of Fear 恐惧之心 
         
			-- Imperial Vizier Zor'lok
			[GetSpellInfo(122760)] = 11, -- Exhale, The person targeted for Exhale. 
			[GetSpellInfo(123812)] = 12, -- Pheromones of Zeal, the gas in the middle of the room.
			[GetSpellInfo(122706)] = 14, -- Noise Cancelling, The "safe zone" from the roomwide aoe.
			[GetSpellInfo(122740)] = 13, -- Convert, The mindcontrol Debuff.

			-- Blade Lord Ta'yak
			[GetSpellInfo(123180)] = 21, -- Wind Step, Bleeding Debuff from stealth.
			[GetSpellInfo(123474)] = 23, -- Overwhelming Assault, stacking tank swap debuff. 
			[GetSpellInfo(122949)] = 22, -- Unseen Strike
			[GetSpellInfo(124783)] = 24, -- Storm Unleashed
			[GetSpellInfo(123600)] = 25, -- Storm Unleashed?

			-- Garalon
			[GetSpellInfo(122774)] = 31, -- Crush, stun from the crush ability.
			[GetSpellInfo(123120)] = 34, --- Pheromone Trail
			[GetSpellInfo(122835)] = 32, -- Pheromones, The buff indicating who is carrying the pheramone.
			[GetSpellInfo(123081)] = 33, -- Punchency, The stacking debuff causing the raid damage.

			--Wind Lord Mel'jarak
			[GetSpellInfo(122055)] = 42, -- Residue, The debuff after breaking a prsion preventing further breaking.
			[GetSpellInfo(121881)] = 41, -- Amber Prison, not sure what the differance is but both were used.
			[GetSpellInfo(122064)] = 43, -- Corrosive Resin, the dot you clear by moving/jumping.

			-- Amber-Shaper Un'sok 
			[GetSpellInfo(122064)] = 53, -- Corrosive Resin
			[GetSpellInfo(122784)] = 52, -- Reshape Life, Both were used.
			[GetSpellInfo(122504)] = 54, --Burning Amber.
			[GetSpellInfo(121949)] = 51, -- Parasitic Growth, the dot that scales with healing taken.
		
			--Grand Empress Shek'zeer
			[GetSpellInfo(125390)] = 61, --Fixate.
			[GetSpellInfo(123707)] = 62, --Eyes of the Empress.
			[GetSpellInfo(123788)] = 63, --Cry of Terror.
			[GetSpellInfo(124097)] = 64, --Sticky Resin.
			[GetSpellInfo(125824)] = 65, --Trapped!.
			[GetSpellInfo(124777)] = 66, --Poison Bomb.
			[GetSpellInfo(124821)] = 67, --Poison-Drenched Armor.
			[GetSpellInfo(124827)] = 68, --Poison Fumes.
			[GetSpellInfo(124849)] = 69, --Consuming Terror.
			[GetSpellInfo(124863)] = 70, --Visions of Demise.
			[GetSpellInfo(124862)] = 71, --Visions of Demise: Target.
			[GetSpellInfo(123845)] = 72, --Heart of Fear: Chosen.
			[GetSpellInfo(123846)] = 73, --Heart of Fear: Lure.
		},
      
		[886] = { --Terrace of Endless Spring 永春台
			
			--Trash
			[GetSpellInfo(125760)] = 10,

			--Protectors Of the Endless
			[GetSpellInfo(117519)] = 11, -- Touch of Sha, Dot that lasts untill Kaolan is defeated.
			[GetSpellInfo(111850)] = 12, -- Lightning Prison: Targeted
			[GetSpellInfo(117986)] = 15, -- Defiled Ground: Stacks
			[GetSpellInfo(118191)] = 14, -- Corrupted Essence
			[GetSpellInfo(117436)] = 13, -- Lightning Prison, Magic stun.

			--Tsulong
			[GetSpellInfo(122768)] = 21, -- Dread Shadows, Stacking raid damage debuff (ragnaros superheated style) 
			[GetSpellInfo(122789)] = 24, -- Sunbeam, standing in the sunbeam, used to clear dread shadows.
			[GetSpellInfo(122858)] = 28, -- Bathed in Light, 500% increased healing done debuff.
			[GetSpellInfo(122752)] = 23, -- Shadow Breath, increased shadow breath damage debuff.
			[GetSpellInfo(123011)] = 26, -- Terrorize: 10%, Magical dot dealing % health.
			[GetSpellInfo(123036)] = 27, -- Fright, 2 second fear.
			[GetSpellInfo(122777)] = 22, -- Nightmares, 3 second fear.
			[GetSpellInfo(123012)] = 25, -- Terrorize: 5% 
			
			--Lei Shi
			[GetSpellInfo(123121)] = 31, -- Spray, Stacking frost damage taken debuff.
			[GetSpellInfo(123705)] = 32, -- Scary Fog
			
			--Sha of Fear
			[GetSpellInfo(129147)] = 42, -- Ominous Cackle, Debuff that sends players to the outer platforms.
			[GetSpellInfo(119086)] = 49, -- Penetrating Bolt, Increased Shadow damage debuff.
			[GetSpellInfo(119775)] = 50, -- Reaching Attack, Increased Shadow damage debuff.
			[GetSpellInfo(120669)] = 44, -- Naked and Afraid.
			[GetSpellInfo(119983)] = 43, -- Dread Spray, is also used.
			[GetSpellInfo(119414)] = 41, -- Breath of Fear, Fear+Massiv damage.
			[GetSpellInfo(75683)] = 45, -- Waterspout
			[GetSpellInfo(120629)] = 46, -- Huddle in Terror
			[GetSpellInfo(120394)] = 47, --Eternal Darkness
			[GetSpellInfo(129189)] = 48, --Sha Globe
		},
			--Sha of Anger
			[GetSpellInfo(119626)] = 11, --Aggressive Behavior
			[GetSpellInfo(119488)] = 12, --Unleashed Wrath
			[GetSpellInfo(119610)] = 13, --Bitter Thoughts
			[GetSpellInfo(119601)] = 14, --Bitter Thoughts
	},
	second = {
	
	},	
}

