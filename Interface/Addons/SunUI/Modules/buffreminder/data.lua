local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local BR = S:GetModule("BufferReminder")

--职业buff
BR.ReminderBuffs = {
	PRIEST = {
		["Shields"] = { --inner fire/will group
			["spells"] = {
				[588] = true, -- inner fire
				[73413] = true, -- inner will
			},
			["combat"] = true,
			["instance"] = true,
		},
	},
	HUNTER = {
		["Aspects"] = { --aspects group
			["spells"] = {
				[13165] = true, -- hawk
				[109260] = true, --铁鹰守护
			},
			["combat"] = true,
			["instance"] = true,
		},				
	},
	MAGE = {
		["Armors"] = { --armors group
			["spells"] = {
				[7302] = true, -- frost armor
				[6117] = true, -- mage armor
				[30482] = true, -- molten armor		
			},
			["combat"] = true,
			["instance"] = true,
		},		
		["spell"] = { --armors group
			["spells"] = {
				[1459] = true, -- 奥术光辉
				[109773] = true, --意图
				[77747] = true,--萨满
				[61316] = true,--法师
			},
			["combat"] = true,
			["instance"] = true,
		},	
	},
	WARLOCK = {
		["spell"] = { --armors group
			["spells"] = {
				[1459] = true, -- 奥术光辉
				[109773] = true, --意图
				[77747] = true,--萨满
				[61316] = true,--法师
			},
			["combat"] = true,
			["instance"] = true,
		},	
	},
	PALADIN = {
		["Righteous Fury"] = { -- righteous fury group
			["spells"] = {
				[25780] = true,
			},
			["role"] = "Tank",
			["instance"] = true,
			["reversecheck"] = true,
			["negate_reversecheck"] = 1, --Holy paladins use RF sometimes
		},
	},
	SHAMAN = {
		["Shields"] = { --shields group
			["spells"] = {
				[52127] = true, -- water shield
				[324] = true, -- lightning shield			
			},
			["combat"] = true,
			["instance"] = true,
		},
		["Weapon Enchants"] = { --check weapons for enchants
			["weapon"] = true,
			["combat"] = true,
			["instance"] = true,
			["level"] = 10,
		},
	},
	WARRIOR = {
		["Commanding Shout"] = { -- commanding Shout group
			["spells"] = {
				[21562] = true, -- 真言术：韧
				  [469] = true, -- 命令怒吼
				[109773] = true,		--意图
				[90364] = true, -- 其拉虫群坚韧
				[72590] = true, -- 坚韧
			},
			["negate_spells"] = {
				[6307] = true, -- Blood Pact
				[90364] = true, -- Qiraji Fortitude
				[72590] = true, -- Drums of fortitude
				[21562] = true, -- Fortitude				
			},
			["combat"] = true,
			["role"] = "Tank",
		},
		["Battle Shout"] = { -- battle Shout group
			["spells"] = {
				[6673] = true, 
			},
			["negate_spells"] = {
				[57330] = true, -- horn of Winter
				[93435] = true, -- roar of courage (hunter pet)						
			},
			["combat"] = true,
			["role"] = "Melee",
		},
	},
	DEATHKNIGHT = {
		["Horn of Winter"] = { -- horn of Winter group
			["spells"] = {
				[57330] = true, 
			},
			["negate_spells"] = {
				[6673] = true, -- battle Shout
				[93435] = true, -- roar of courage (hunter pet)			
			},
			["combat"] = true,
		},
		["Blood Presence"] = { -- blood presence group
			["spells"] = {
				[48263] = true, 
			},
			["role"] = "Tank",
			["combat"] = true,
		},
	},
	ROGUE = { 
		["Poison1"] = { -- auras
			["spells"] = {
				[2823] = true, -- 致命毒藥
				[8679] = true, -- 致傷毒藥
			},
			["combat"] = true,
		},
	},
}


--团队buff
BR.RaidBuffList = {
	[1] = {
		-- 全属性
		20217, -- 王者祝福
		 1126, -- 野性印记
		90363, -- 页岩蛛之拥
		115921,	--MK
		72586, --山寨王者
	},
	[2] = {		
		-- 耐力
		21562, -- 真言术：韧
		  469, -- 命令怒吼
		109773,		--意图
		90364, -- 其拉虫群坚韧
		72590, -- 坚韧
	},
	[3] = {
		-- 精通
		19740, -- 力量祝福
		128997, --灵魂兽
		93435, --猎人宝宝 猫科
		116956, --風之優雅
	},
	[4] = {
		--5%暴击
		17007,
		1459,
		116781,
		61316,--法师
		24604, --LR宝宝
		126309, --疑似鸟德
		116781, --武僧5%暴击
	},
	[5] = {
		-- 10%法伤
		1459, -- 奥术光辉
		109773, --意图
		77747,--萨满
		61316,--法师
		126309, --疑似鸟德
	},
	[6] = {
			-- 10%AP
			6673, -- 战斗怒吼
			19506, -- 强击光环
			57330,--DK
		},
	[7] = {
		--法术加速
		49868,--暗牧
		24907,--鸟德
		51470,--萨满
		135678,--猎人宝宝
	},
	[8] = {
		--物理加速
		113742, --DZ
		55610,--邪恶光环 DK
		30809,--怒火释放 SM
	},
}
