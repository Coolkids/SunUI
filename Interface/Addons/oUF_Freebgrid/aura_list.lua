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
ns.auras = {
	first = {	--主要光环图标显示的spellid	
		ascending = {	
        [GetSpellInfo(92956)] = true, -- Wrack
		},
		debuffs = {
			--[GetSpellInfo(57724)] = 13,	--test 
			[GetSpellInfo(39171)] = 9, -- Mortal Strike
			[GetSpellInfo(76622)] = 9, -- Sunder Armor
		},
		buffs = {
			--[GetSpellInfo(139)] = 9, 	--test
		},
		-- Raid Debuffs
		instances = {
			["红玉圣殿"] = {
				[GetSpellInfo(74562)] = 7, -- Fiery Combustion
				[GetSpellInfo(75883)] = 5, -- Combustion
				[GetSpellInfo(74792)] = 6, -- Soul Consumption
				[GetSpellInfo(75876)] = 4, -- Consumption
			},
			[604] = {--"冰冠堡垒"
				--The Lower Spire
				[GetSpellInfo(70980)] = 7, -- Web Wrap
				[GetSpellInfo(69483)] = 6, -- Dark Reckoning
				[GetSpellInfo(69969)] = 5, -- Curse of Doom
				--The Plagueworks
				[GetSpellInfo(71089)] = 5, -- Bubbling Pus
				[GetSpellInfo(71127)] = 7, -- Mortal Wound
				[GetSpellInfo(71163)] = 6, -- Devour Humanoid
				[GetSpellInfo(71103)] = 6, -- Combobulating Spray
				[GetSpellInfo(71157)] = 5, -- Infested Wound
				--The Crimson Hall
				[GetSpellInfo(70645)] = 9, -- Chains of Shadow
				[GetSpellInfo(70671)] = 5, -- Leeching Rot
				[GetSpellInfo(70432)] = 6, -- Blood Sap
				[GetSpellInfo(70435)] = 7, -- Rend Flesh
				--Frostwing Hall
				[GetSpellInfo(71257)] = 6, -- Barbaric Strike
				[GetSpellInfo(71252)] = 5, -- Volley
				[GetSpellInfo(71327)] = 6, -- Web
				[GetSpellInfo(36922)] = 5, -- Bellowing Roar
				--Lord Marrowgar
				[GetSpellInfo(70823)] = 5, -- Coldflame
				[GetSpellInfo(69065)] = 8, -- Impaled
				[GetSpellInfo(70835)] = 5, -- Bone Storm
				--Lady Deathwhisper
				[GetSpellInfo(72109)] = 5, -- Death and Decay
				[GetSpellInfo(71289)] = 9, -- Dominate Mind
				[GetSpellInfo(71204)] = 4, -- Touch of Insignificance
				[GetSpellInfo(67934)] = 5, -- Frost Fever
				[GetSpellInfo(71237)] = 5, -- Curse of Torpor
				[GetSpellInfo(72491)] = 5, -- Necrotic Strike
				--Gunship Battle
				[GetSpellInfo(69651)] = 5, -- Wounding Strike
				--Deathbringer Saurfang
				[GetSpellInfo(72293)] = 6, -- Mark of the Fallen Champion
				[GetSpellInfo(72442)] = 8, -- Boiling Blood
				[GetSpellInfo(72449)] = 5, -- Rune of Blood
				[GetSpellInfo(72769)] = 5, -- Scent of Blood (heroic)
				--Rotface
				[GetSpellInfo(71224)] = 5, -- Mutated Infection
				[GetSpellInfo(71215)] = 5, -- Ooze Flood
				[GetSpellInfo(69774)] = 5, -- Sticky Ooze
				--Festergut
				[GetSpellInfo(69279)] = 5, -- Gas Spore
				[GetSpellInfo(71218)] = 5, -- Vile Gas
				[GetSpellInfo(72219)] = 5, -- Gastric Bloat
				--Proffessor
				[GetSpellInfo(70341)] = 5, -- Slime Puddle
				[GetSpellInfo(72549)] = 5, -- Malleable Goo
				[GetSpellInfo(71278)] = 5, -- Choking Gas Bomb
				[GetSpellInfo(70215)] = 5, -- Gaseous Bloat
				[GetSpellInfo(70447)] = 5, -- Volatile Ooze Adhesive
				[GetSpellInfo(72454)] = 5, -- Mutated Plague
				[GetSpellInfo(70405)] = 5, -- Mutated Transformation
				[GetSpellInfo(72856)] = 6, -- Unbound Plague
				[GetSpellInfo(70953)] = 4, -- Plague Sickness
				--Blood Princes
				[GetSpellInfo(72796)] = 7, -- Glittering Sparks
				[GetSpellInfo(71822)] = 5, -- Shadow Resonance
				--Blood-Queen Lana'thel
				[GetSpellInfo(70867)] = 8, -- 鲜血女王的精华
				[GetSpellInfo(70838)] = 5, -- Blood Mirror
				[GetSpellInfo(72265)] = 6, -- Delirious Slash
				[GetSpellInfo(71473)] = 5, -- Essence of the Blood Queen
				[GetSpellInfo(71474)] = 6, -- Frenzied Bloodthirst
				[GetSpellInfo(73070)] = 5, -- Incite Terror
				[GetSpellInfo(71340)] = 7, -- Pact of the Darkfallen
				[GetSpellInfo(71265)] = 6, -- Swarming Shadows
				[GetSpellInfo(70923)] = 9, -- Uncontrollable Frenzy
				--Valithria Dreamwalker
				[GetSpellInfo(70873)] = 1, -- Emerald Vigor
				[GetSpellInfo(71746)] = 5, -- Column of Frost
				[GetSpellInfo(71741)] = 4, -- Mana Void
				[GetSpellInfo(71738)] = 7, -- Corrosion
				[GetSpellInfo(71733)] = 6, -- Acid Burst
				[GetSpellInfo(71283)] = 6, -- Gut Spray
				[GetSpellInfo(71941)] = 1, -- Twisted Nightmares
				--Sindragosa
				[GetSpellInfo(69762)] = 5, -- Unchained Magic
				[GetSpellInfo(70106)] = 6, -- Chlled to the Bone
				[GetSpellInfo(69766)] = 6, -- Instability
				[GetSpellInfo(70126)] = 9, -- Frost Beacon
				[GetSpellInfo(70157)] = 8, -- Ice Tomb
				[GetSpellInfo(70127)] = 7, -- Mystic Buffet
				--The Lich King
				[GetSpellInfo(70337)] = 8, -- Necrotic plague
				[GetSpellInfo(72149)] = 5, -- Shockwave
				[GetSpellInfo(70541)] = 7, -- Infest
				[GetSpellInfo(69242)] = 5, -- Soul Shriek
				[GetSpellInfo(69409)] = 9, -- Soul Reaper
				[GetSpellInfo(72762)] = 5, -- Defile
				[GetSpellInfo(68980)] = 8, --Harvest Soul
			},
			[543] = {--"十字军的试炼"
				--Gormok the Impaler
				[GetSpellInfo(66331)] = 5, -- Impale
				[GetSpellInfo(67475)] = 5, -- Fire Bomb
				[GetSpellInfo(66406)] = 5, -- Snowbolled!
				--Acidmaw --Dreadscale
				[GetSpellInfo(67618)] = 5, -- Paralytic Toxin
				[GetSpellInfo(66869)] = 5, -- Burning Bile
				--Icehowl
				[GetSpellInfo(67654)] = 5, -- Ferocious Butt
				[GetSpellInfo(66689)] = 5, -- Arctic Breathe
				[GetSpellInfo(66683)] = 5, -- Massive Crash
				--Lord Jaraxxus
				[GetSpellInfo(66532)] = 5, -- Fel Fireball
				[GetSpellInfo(66237)] = 9, -- 血肉成灰
				[GetSpellInfo(66242)] = 7, -- Burning Inferno
				[GetSpellInfo(66197)] = 5, -- Legion Flame
				[GetSpellInfo(66283)] = 9, -- Spinning Pain Spike
				[GetSpellInfo(66209)] = 5, -- Touch of Jaraxxus(hard)
				[GetSpellInfo(66211)] = 5, -- Curse of the Nether(hard)
				[GetSpellInfo(67906)] = 5, -- Mistress's Kiss 10H
				--Faction Champions
				[GetSpellInfo(65812)] = 9, -- Unstable Affliction
				[GetSpellInfo(65960)] = 5, -- Blind
				[GetSpellInfo(65801)] = 5, -- Polymorph
				[GetSpellInfo(65543)] = 5, -- Psychic Scream
				[GetSpellInfo(66054)] = 5, -- Hex
				[GetSpellInfo(65809)] = 5, -- Fear
				--The Twin Val'kyr
				[GetSpellInfo(67176)] = 5, -- Dark Essence
				[GetSpellInfo(67222)] = 5, -- Light Essence
				[GetSpellInfo(67283)] = 7, -- Dark Touch
				[GetSpellInfo(67298)] = 7, -- Ligth Touch
				[GetSpellInfo(67309)] = 5, -- Twin Spike
				--Anub'arak
				[GetSpellInfo(67574)] = 9, -- Pursued by Anub'arak
				[GetSpellInfo(66013)] = 7, -- Penetrating Cold
				[GetSpellInfo(67847)] = 5, -- Expose Weakness
				[GetSpellInfo(66012)] = 5, -- Freezing Slash
				[GetSpellInfo(67863)] = 5, -- Acid-Drenched Mandibles(25H)
			},
			[529] = {--奥杜亚

			},
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
			[769] = {--旋云之巅

			},
			[747] = {--托维尔失落之城

			},
			[759] = {--起源大厅

			},

			[756] = {--"死亡矿井"
				[GetSpellInfo(91016)] = 7, -- 劈头斧
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
				[GetSpellInfo(101729)] = 5, -- Blazing Claw 
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
				[GetSpellInfo(101208)] = 4, -- Immolation Trap 
				[GetSpellInfo(99840)] = 4, -- Magma Rupture 
				-- Riplimp 
				[GetSpellInfo(99937)] = 5, -- Jagged Tear 
				-- Rageface 
				[GetSpellInfo(99947)] = 6, -- Face Rage 
				[GetSpellInfo(100415)] = 5, -- Rage  

				--守门人贝尔洛克 
				[GetSpellInfo(99252)] = 4, -- Blaze of Glory 
				[GetSpellInfo(99256)] = 15, -- 饱受磨难 
				[GetSpellInfo(99403)] = 6, -- Tormented 
				[GetSpellInfo(99262)] = 4, -- 活力火花
				[GetSpellInfo(99263)] = 4, -- 生命之焰
				[GetSpellInfo(99516)] = 7, -- Countdown 
				[GetSpellInfo(99353)] = 7, -- Decimating Strike 
				[GetSpellInfo(100908)] = 6, -- Fiery Torment 

				--Majordomo Staghelm 
				[GetSpellInfo(98535)] = 5, -- Leaping Flames 
				[GetSpellInfo(98443)] = 6, -- Fiery Cyclone 
				[GetSpellInfo(98450)] = 5, -- Searing Seeds 
				--Burning Orbs 
				[GetSpellInfo(100210)] = 6, -- Burning Orb 
				[GetSpellInfo(96993)] = 5, -- Stay Withdrawn? 

				--Ragnaros 
				[GetSpellInfo(99399)] = 5, -- Burning Wound 
				[GetSpellInfo(100293)] = 5, -- Lava Wave 
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
				[GetSpellInfo(100249)] = 5, -- Combustion 
				--Molten Wyrms 
				[GetSpellInfo(99613)] = 6, -- Molten Blast   

			},

			[752] = { --[[ 巴拉丁 ]]--	
				-- Demon Containment Unit
				[GetSpellInfo(89354)] = 10,
				-- Argaloth
				[GetSpellInfo(88942)] = 8, -- Meteor Slash
				[GetSpellInfo(88954)] = 12, -- Consuming Darkness
				-- Occu'thar
				[GetSpellInfo(96913)] = 10, -- 灼热暗影
				[GetSpellInfo(96884)] = 7, 	-- 集火
				-- Eye of Occu'thar
				[GetSpellInfo(105069)] = 11, -- 沸腾之怨
				[GetSpellInfo(104936)] = 12, -- 刺穿
			},
			
			[754] = { --[[ 黑翼]]--
				--熔喉
				[GetSpellInfo(78941)] = 6, -- 寄生感染
				[GetSpellInfo(89773)] = 7, -- 裂伤

				--全能金刚
				[GetSpellInfo(79888)] = 6, -- 闪电导体
				[GetSpellInfo(79505)] = 8, -- 火焰喷射器
				[GetSpellInfo(80161)] = 7, -- 化学云雾
				[GetSpellInfo(79501)] = 8, -- 获取目标
				[GetSpellInfo(80011)] = 7, -- 浸透毒液
				[GetSpellInfo(80094)] = 7, -- 锁定
				[GetSpellInfo(92023)] = 9, -- 暗影包围
				[GetSpellInfo(92048)] = 9, -- 暗影灌注
				[GetSpellInfo(92053)] = 9, -- 暗影导体
				--[GetSpellInfo(91858)] = 6, -- 超载的能量发生器
				
				--马洛拉克 教授龙
				[GetSpellInfo(92973)] = 8, -- 消蚀烈焰
				[GetSpellInfo(92978)] = 8, -- 快速冻结
				[GetSpellInfo(92976)] = 7, -- 酷寒
				[GetSpellInfo(91829)] = 7, -- 注视
				[GetSpellInfo(92787)] = 9, -- 黑暗吞噬

				--音波龙
				[GetSpellInfo(78092)] = 7, -- 追踪
				[GetSpellInfo(78897)] = 8, -- 声音太大了
				[GetSpellInfo(78023)] = 7, -- 咆哮烈焰

				--奇美隆
				[GetSpellInfo(89084)] = 8, -- 生命值过低
				[GetSpellInfo(82881)] = 7, -- 突破
				[GetSpellInfo(82890)] = 9, -- 至死方休
				[GetSpellInfo(82935)] = 10, -- 腐蚀烂泥

				--奈法利安
				[GetSpellInfo(94128)] = 7, -- 扫尾
				[GetSpellInfo(94075)] = 8, -- 熔岩
				[GetSpellInfo(81118)] = 8, -- 熔岩
				[GetSpellInfo(79339)] = 9, -- 爆裂灰烬
				[GetSpellInfo(79318)] = 9, -- 统御
				[GetSpellInfo(77827)] = 6, -- 龙尾扫击
			},

			[758] = { --[[ 暮光]]--
				--破龙
				[GetSpellInfo(39171)] = 7, -- 致伤打击
				[GetSpellInfo(86169)] = 8, -- 狂怒咆哮

				--双龙
				[GetSpellInfo(86788)] = 8, -- 眩晕
				[GetSpellInfo(86622)] = 7, -- 嗜体魔法
				[GetSpellInfo(86202)] = 7, -- 暮光位移

				--议会
				[GetSpellInfo(82665)] = 7, -- 寒冰之心
				[GetSpellInfo(82660)] = 7, -- 燃烧之血
				[GetSpellInfo(82762)] = 7, -- 浸水
				[GetSpellInfo(83099)] = 9, -- 闪电魔棒
				[GetSpellInfo(82285)] = 8, -- 元素禁止
				[GetSpellInfo(92488)] = 8, -- 重力碾压

				--古加尔
				[GetSpellInfo(86028)] = 6, -- 古加尔的冲击波
				[GetSpellInfo(93189)] = 7, -- 堕落之血
				[GetSpellInfo(93133)] = 7, -- 衰弱光线
				[GetSpellInfo(81836)] = 8, -- 腐蚀:加速
				[GetSpellInfo(81831)] = 8, -- 腐蚀:疫病
				[GetSpellInfo(82125)] = 8, -- 腐蚀:畸变
				[GetSpellInfo(82170)] = 8, -- 腐蚀:绝对

				--龙母
				[GetSpellInfo(92956)] = 15, -- 毁坏
				--[GetSpellInfo(92955)] = 15, -- 毁坏
			},

			[773] = { --[[ 四风 ]]--
				--风之议会
				[GetSpellInfo(85576)] = 9, -- 枯萎之风
				[GetSpellInfo(85573)] = 9, -- 呼啸狂风
				[GetSpellInfo(93057)] = 7, -- 刺骨旋风
				[GetSpellInfo(86481)] = 8, -- 飓风
				[GetSpellInfo(93123)] = 7, -- 风寒
				[GetSpellInfo(93121)] = 8, -- 剧毒孢子

				--奥拉基尔
				--[GetSpellInfo(93281)] = 7, -- 酸雨
				[GetSpellInfo(87873)] = 7, -- 静电震击
				[GetSpellInfo(88427)] = 7, -- 通电
				[GetSpellInfo(93294)] = 8, -- 闪电魔棒
				[GetSpellInfo(93284)] = 9, -- 狂风
			},
			
			-- Dragon Soul
		   [824] = {
			  --Morchok
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
		},
	
	},
	second = {	--次要光环图标显示的spellid
		ascending = {	
		},

		debuffs = {

		},
		buffs = {
			--[GetSpellInfo(53390)] = 13,	--test
			--[GetSpellInfo(79105)] = 13,	--test
			--[GetSpellInfo(77489)] = 15,	--test
			--------------------------战士---------------	
			[GetSpellInfo(871)] = 1,	-- 盾墙
			[GetSpellInfo(12975)] = 1,	--破釜沉舟
			[GetSpellInfo(97463)] = 1,	--集结呐喊
			[GetSpellInfo(2565)] = 1,	--盾牌格挡
			--------------------------骑士---------------
			[GetSpellInfo(642)] = 1,	--圣盾术
			[GetSpellInfo(86659)] = 1,	--远古列王守卫
			[GetSpellInfo(70940)] = 1,	--神圣守卫
			[GetSpellInfo(31850)] = 1,	--炽热防御者
			[GetSpellInfo(498)] = 1,	--圣佑术
			[GetSpellInfo(1022)] = 1,	--保护之手
			[GetSpellInfo(1038)] = 1,	--拯救之手
			[GetSpellInfo(6940)] = 1,	--牺牲之手
			
			--------------------------DK---------------
			[GetSpellInfo(48707)] = 1,	--反魔法护罩
			[GetSpellInfo(50461)] = 1,	--反魔法领域
			--[GetSpellInfo(49222)] = 1,	--白骨之盾
			[GetSpellInfo(48792)] = 1,	--冰封之韧
			[GetSpellInfo(55233)] = 1,	--吸血鬼之血
			------------------------德鲁伊---------------
			[GetSpellInfo(22812)] = 1,	--树皮术
			[GetSpellInfo(22842)] = 1,	--狂暴回复
			[GetSpellInfo(61336)] = 1,	--生存本能
			------------------------牧师--------------------
			[GetSpellInfo(33206)] = 1, --痛苦压制
			[GetSpellInfo(47788)] = 1, --守护之魂
		},
	
	},
    
}

---------------不要删除---------------------------------
if type(ns.auras.first) ~= "table" then
	ns.auras.first = {}
end

if type(ns.auras.first.buffs) ~= "table" then
	ns.auras.first.buffs = {}
end

if type(ns.auras.first.debuffs) ~= "table" then
	ns.auras.first.debuffs = {}
end

if type(ns.auras.first.instances) ~= "table" then
	ns.auras.first.instances = {}
end

if type(ns.auras.first.ascending) ~= "table" then
	ns.auras.first.ascending = {}
end

if type(ns.auras.second) ~= "table" then
	ns.auras.second = {}
end

if type(ns.auras.second.buffs) ~= "table" then
	ns.auras.second.buffs = {}
end

if type(ns.auras.second.debuffs) ~= "table" then
	ns.auras.second.debuffs = {}
end

if type(ns.auras.second.instances) ~= "table" then
	ns.auras.second.instances = {}
end

if type(ns.auras.second.ascending) ~= "table" then
	ns.auras.second.ascending = {}
end