local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local BR = S:GetModule("BufferReminder")

--职业buff
BR.ReminderBuffs = {
		DEATHKNIGHT = {
			[1] = {	-- Horn of Winter group
				["spells"] = {
					57330,	-- Horn of Winter
				},
				["negate_spells"] = {
					6673,	-- Battle Shout
					19506,	-- Trueshot Aura
				},
				["combat"] = true,
			},
			[2] = {	-- Blood Presence group
				["spells"] = {
					48263,	-- Blood Presence
				},
				["role"] = "Tank",
				["instance"] = true,
				["reversecheck"] = true,
			},
		},
		DRUID = {
			[1] = {	-- Mark of the Wild group
				["spells"] = {
					1126,	-- Mark of the Wild
				},
				["negate_spells"] = {
					20217, 90363, 115921, 116781, 159988, 160017, 160077, 160206,
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
		},
		MAGE = {
			[1] = {	-- Brilliance group
				["spells"] = {
					1459,	-- Arcane Brilliance
					61316,	-- Dalaran Brilliance
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
		},
		MONK = {
			[1] = {	-- Legacy of the Emperor group
				["spells"] = {
					115921,	-- Legacy of the Emperor
				},
				["negate_spells"] = {
					1126,	-- Mark of the Wild
					20217,	-- Blessing of Kings
					90363,	-- Embrace of the Shale Spider
					116781,	-- Legacy of the White Tiger
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
			[2] = {	-- Legacy of the White Tiger group
				["spells"] = {
					116781,	-- Legacy of the White Tiger
				},
				["negate_spells"] = {
					90363,	-- Embrace of the Shale Spider
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
		},
		PALADIN = {
			[1] = {	-- Righteous Fury group
				["spells"] = {
					25780,	-- Righteous Fury
				},
				["role"] = "Tank",
				["instance"] = true,
				["reversecheck"] = true,
				["negate_reversecheck"] = 1,	-- Holy paladins use RF sometimes
			},
			[2] = {	-- Blessing of Kings group
				["spells"] = {
					20217,	-- Blessing of Kings
				},
				["negate_spells"] = {
					1126,	-- Mark of the Wild
					115921,	-- Legacy of the Emperor
					116781,	-- Legacy of the White Tiger
					90363,	-- Embrace of the Shale Spider
				},
				["personal"] = {
					19740,	-- Blessing of Might
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
			[3] = {	-- Blessing of Might group
				["spells"] = {
					19740,	-- Blessing of Might
				},
				["negate_spells"] = {
					116956,	-- Grace of Air
					93435,	-- Roar of Courage
					128997,	-- Spirit Beast Blessing
				},
				["personal"] = {
					20217,	-- Blessing of Kings
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
		},
		PRIEST = {
			[1] = {	-- Stamina group
				["spells"] = {
					21562,	-- Power Word: Fortitude
				},
				["negate_spells"] = {
					469,	-- Commanding Shout
					90364,	-- Qiraji Fortitude
					166928,	-- Blood Pact
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true
			},
		},
		ROGUE = {
			[1] = {	-- Lethal Poisons group
				["spells"] = {
					2823,	-- Deadly Poison
					8679,	-- Wound Poison
					157584,	-- Instant Poison
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
			[2] = {	-- Non-Lethal Poisons group
				["spells"] = {
					3408,	-- Crippling Poison
					108211,	-- Leeching Poison
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
		},
		SHAMAN = {
			[1] = {	-- Shields group
				["spells"] = {
					52127,	-- Water Shield
					324,	-- Lightning Shield
					974,	-- Earth Shield
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
		},
		WARLOCK = {
			[1] = {	-- Dark Intent group
				["spells"] = {
					109773,	-- Dark Intent
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
		},
		WARRIOR = {
			[1] = {	-- Commanding Shout group
				["spells"] = {
					469,	-- Commanding Shout
				},
				["negate_spells"] = {
					21562,	-- Power Word: Fortitude
					90364,	-- Qiraji Fortitude
					166928,	-- Blood Pact
				},
				["personal"] = {
					6673,	-- Battle Shout
				},
				["combat"] = true,
				["role"] = "Tank",
			},
			[2] = {	-- Battle Shout group
				["spells"] = {
					6673,	-- Battle Shout
				},
				["negate_spells"] = {
					19506,	-- Trueshot Aura
					57330,	-- Horn of Winter
				},
				["personal"] = {
					469,	-- Commanding Shout
				},
				["combat"] = true,
				["role"] = "Melee",
			},
		},
	}


--团队buff
BR.RaidBuffList = {
	[1] = {
		-- 5%属性
		 20217,  -- 王者祝福
		  1126,  -- 野性印记
		115921,  -- 织雾
		116781,  -- 酿酒/踏风
		 90363,  -- 页岩蛛之拥
		159988,  -- 狂野怒吼
		160017,  -- 金剛的祝福
		160077,  -- 大地之力
		160206,  -- 孤狼
		 69378,  -- 山寨王者
	},
	[2] = {		
		-- 10%耐力
		 21562,  -- 真言术：韧
		   469,  -- 命令怒吼
		166928,  -- 血之锲约
		 90364,  -- 其拉虫群坚韧
		160003,  -- 野性活力
		160014,  -- 堅忍不拔
		160199,  -- 孤狼
		111922,  -- 坚韧
	},
	[3] = {
		-- 精通
		 19740,  -- 力量祝福
		155522,  -- 血DK
		 24907,  -- 枭兽光环
		116956,  -- 风之优雅
		128997,  -- 灵魂兽
		 93435,  -- 猎人宝宝 猫科
		160039,  -- 多头蛇
		160073,  -- 陆行鸟
		160198,  -- 孤狼
	},
	[4] = {
		--5%暴击
		 17007,  -- 兽群领袖
		  1459,  -- 奥术光辉
		 61316,  -- 达拉然光辉
		116781,  -- 武僧5%暴击
		 24604,  -- 狼
		126309,  -- 水黽
		 90309,  -- 魔暴龙
		126373,  -- 魁麟
		160052,  -- 迅猛龙
		 90363,  -- 页岩蛛
		160200,  -- 孤狼
	},
	[5] = {
		-- 10%法伤
		  1459,  -- 奥术光辉
		 61316,  -- 达拉然光辉
		109773,  -- 黑暗意图
		 90364,  -- 其拉虫
		126309,  -- 水黽
		160205,  -- 孤狼
	},
	[6] = {
		-- 10%AP
		  6673,  -- 战斗怒吼
		 19506,  -- 强击光环
		 57330,  -- 寒冬号角
		},
	[7] = {
		-- 5%急速
		 49868,  -- 暗牧
		 55610,  -- 邪恶光环
		113742,  -- 迅刃之黠
		116956,  -- 风之优雅
		135678,  -- 孢子蝠
		160003,  -- 双头飞龙
		160074,  -- 蜂
		160203,  -- 孤狼
	},
	[8] = {
		-- 3%全能
		  1126,  -- 野性印记
		 55610,  -- 邪恶光环
		167187,  -- 惩戒 QS
		167188,  -- 战士
		159735,  -- 猛禽
		 35290,  -- 野豬
		160045,  -- 刺蝟
		 50518,  -- 劫毀者
		 57386,  -- 犀牛
		160077,  -- 蟲
	},
	[9] = {
		-- 5%(濺射)
		166916,  -- 武僧
		 49868,  -- 思維敏捷
		113742,  -- 迅刃之黠
		109773,  -- 意图
		159733,  -- 蜥蝪
		 54644,  -- 奇美拉
		 58604,  -- 熔核犬
		 34889,  -- 龍鷹
		160011,  -- 狐狸
		 57386,  -- 犀牛
		 24844,  -- 風蛇
	},
}
