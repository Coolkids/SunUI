local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local FG = S:GetModule("Filger")

--------------------------------设置参数----------------------------------------
--Mode 计时条模式 参数为 BAR ICON  BAR为计时条模式  ICON为图标模式     不要更改大小写
--Direction 增长方向 参数为LEFT RIGHT UP DOWN 对应 左 右 上 下         不要更改大小写
--Name 组名
--Interval 排列间距 参数为数字 输入字符为0-9 严禁其他符号字符
--Alpha  透明度 参数为数字 范围0到1 例如0.5  输入字符为0-9 严禁除.的其他符号字符
--IconSize 图标大小 参数为数字 输入字符为0-9 严禁其他符号字符
--Position 组的显示位置 例如 {"CENTER", UIParent, "CENTER"} 
--最后一条: 大小写敏感, 请不要随意更改大小写
--- 请严格按照spec, spellID, unitID, caster, filter, absID, target, player, DEBUFF, BUFF的大小写
--- spec 天赋号码..  天赋界面从上倒下依次为1, 2, 3, 4
---- 这部分详细资料可以参考下面网址
---- http://bbs.ngacn.cc/read.php?tid=5002683&_ff=200&_fp=2
--- 请严格按照spellID, unitID, caster, filter, absID, target, player, DEBUFF, BUFF的大小写 
--------------------------------------------------------------------------------


FG["filger_spells"] = {
	["DEATHKNIGHT"] = { 		--[死骑]
		{
			Name = "玩家buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playerbuff)},

			-- 反魔法护罩
			{ spellID =  48707, unitID = "player", caster = "player", filter = "BUFF" },
			-- 冰封之韧
			{ spellID =  48792, unitID = "player", caster = "player", filter = "BUFF" },
			-- 巫妖之躯
			{ spellID =  49039, unitID = "player", caster = "player", filter = "BUFF" },
			-- 不洁之力
			{ spellID =  53365, unitID = "player", caster = "player", filter = "BUFF" },
			-- 杀戮机器
			{ spellID =  51124, unitID = "player", caster = "player", filter = "BUFF" },
			-- 冰霜之柱
			{ spellID =  51271, unitID = "player", caster = "player", filter = "BUFF" },
			-- 冰冻之雾
			{ spellID =  59052, unitID = "player", caster = "player", filter = "BUFF" },
			-- 白骨之盾
			{ spellID =  49222, unitID = "player", caster = "player", filter = "BUFF" },
			-- 吸血鬼之血
			{ spellID =  55233, unitID = "player", caster = "player", filter = "BUFF" },
			-- 符文分流
			{ spellID = 171049, unitID = "player", caster = "player", filter = "BUFF" },
			-- 鲜血护盾
			{ spellID =  77535, unitID = "player", caster = "player", filter = "BUFF" },
			-- 符文刃舞
			{ spellID =  81256, unitID = "player", caster = "player", filter = "BUFF" },
			-- 血之气息
			{ spellID =  50421, unitID = "player", caster = "player", filter = "BUFF" },
			-- 末日突降
			{ spellID =  81340, unitID = "player", caster = "player", filter = "BUFF" },
			-- 黑暗突变
			{ spellID =  63560, unitID = "pet",    caster = "player", filter = "BUFF" },
			-- 暗影灌注
			{ spellID =  91342, unitID = "pet",    caster = "player", filter = "BUFF" },
			-- 大地之墓的意志
			{ spellID = 157335, unitID = "player", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "目标debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].targetdebuff)},

			-- 血之疫病
			{ spellID =  55078, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 冰霜疫病
			{ spellID =  55095, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 死疽
			{ spellID = 155159, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 亵渎
			{ spellID = 156004, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 灵魂收割(鲜血)
			{ spellID = 114866, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- 灵魂收割(邪恶)
			{ spellID = 130736, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- 灵魂收割(冰霜)
			{ spellID = 130735, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- 窒息
			{ spellID = 108194, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 黑暗模拟
			{ spellID =  77606, unitID = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			Name = "玩家技能CD",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playercd)},

			-- 枯萎凋零
			{ spellID =  43265, filter = "CD" },
			-- 吸血瘟疫
			{ spellID = 123693, filter = "CD" },
			-- 召唤石像鬼
			{ spellID =  49206, filter = "CD" },
			-- 复活盟友
			{ spellID =  61999, filter = "CD" },
			-- 反魔法护罩
			{ spellID =  48707, filter = "CD" },
			-- 冰封之韧
			{ spellID =  48792, filter = "CD" },
			-- 符文刃舞
			{ spellID =  49028, filter = "CD" },
			-- 符文武器增效
			{ spellID =  47568, filter = "CD" },

			-- 物品
			-- 手套
			{ slotID = 10, filter = "CD" },
			-- 腰带
			{ slotID =  6, filter = "CD" },
			-- 披风
			{ slotID = 15, filter = "CD" },
			-- 饰品
			{ slotID = 13, filter = "CD" },
			{ slotID = 14, filter = "CD" },
		},
	},
	["DRUID"] = {		-- [德鲁伊]
		{
			Name = "玩家buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playerbuff)},

			-- 化身：生命之树
			{ spellID = 117679, unitID = "player", caster = "player", filter = "BUFF"},
			-- 化身：艾露恩之眷
			{ spellID = 102560, unitID = "player", caster = "player", filter = "BUFF"},
			-- 化身：丛林之王
			{ spellID = 102543, unitID = "player", caster = "player", filter = "BUFF"},
			-- 化身：乌索克之子
			{ spellID = 102558, unitID = "player", caster = "player", filter = "BUFF"},
			-- 生存本能
			{ spellID =  61336, unitID = "player", caster = "player", filter = "BUFF"},
			-- 树皮术
			{ spellID =  22812, unitID = "player", caster = "player", filter = "BUFF"},
			-- 野蛮防御(熊)
			{ spellID = 132402, unitID = "player", caster = "player", filter = "BUFF"},
			-- 尖牙与利爪(熊)
			{ spellID = 135286, unitID = "player", caster = "player", filter = "BUFF"},
			-- 粉碎(熊)
			{ spellID = 158792, unitID = "player", caster = "player", filter = "BUFF"},
			-- 原始愈合(熊)
			{ spellID = 177969, unitID = "player", caster = "player", filter = "BUFF"},
			-- 巨熊之力(熊)
			{ spellID = 159233, unitID = "player", caster = "player", filter = "BUFF"},
			-- 鬃毛倒竖(熊)
			{ spellID = 155835, unitID = "player", caster = "player", filter = "BUFF"},
			-- 野蛮咆哮(猫)
			{ spellID =  52610, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 野蛮咆哮雕文(猫)
			{ spellID = 174544, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 野性之心(猫)
			{ spellID = 108293, unitID = "player", caster = "player", filter = "BUFF"},
			-- 掠食者的迅捷(猫)
			{ spellID =  69369, unitID = "player", caster = "player", filter = "BUFF"},
			-- 猛虎之怒(猫)
			{ spellID =   5217, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂暴
			{ spellID = 106951, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID =  50334, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 超凡之盟
			{ spellID = 112071, unitID = "player", caster = "player", filter = "BUFF"},
			-- 星辰坠落
			{ spellID =  48505, unitID = "player", caster = "player", filter = "BUFF"},
			-- 落日余晖
			{ spellID = 155592, unitID = "player", caster = "player", filter = "BUFF"},
			-- 月光增效
			{ spellID = 164547, unitID = "player", caster = "player", filter = "BUFF"},
			-- 日光增效
			{ spellID = 164545, unitID = "player", caster = "player", filter = "BUFF"},
			-- 回春雕文
			{ spellID =  96206, unitID = "player", caster = "player", filter = "BUFF"},
			-- 节能施法
			{ spellID =  16870, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 135700, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 自然迅捷
			{ spellID = 132158, unitID = "player", caster = "player", filter = "BUFF"},
			-- 相生
			{ spellID = 100977, unitID = "player", caster = "player", filter = "BUFF"},
			-- 铁木树皮
			{ spellID = 102342, unitID = "player", caster = "player", filter = "BUFF"},
			-- 自然的守护
			{ spellID = 124974, unitID = "player", caster = "player", filter = "BUFF"},
			-- 急奔
			{ spellID =   1850, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "目标debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].targetdebuff)},

			-- 生命绽放
			{ spellID =  33763, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 野性成长
			{ spellID =  48438, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 回春术
			{ spellID =    774, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 回春术(萌芽)
			{ spellID = 155777, unitID = "target", caster = "player", filter = "BUFF", absID = true},
			-- 愈合
			{ spellID =   8936, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 生命之种
			{ spellID =  48504, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 塞纳里奥结界
			{ spellID = 102351, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 铁木树皮
			{ spellID = 102342, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 挫志咆哮(熊)
			{ spellID =     99, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 割伤(熊)
			{ spellID =  33745, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 割裂(猫)
			{ spellID =   1079, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 斜掠(猫)
			{ spellID = 155722, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- 割碎(猫)
			{ spellID =  22570, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 痛击
			{ spellID = 106830, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			{ spellID =  77758, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- 感染伤口
			{ spellID =  58180, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 阳炎术
			{ spellID = 164815, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 月火术
			{ spellID = 164812, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 星辰耀斑
			{ spellID = 152221, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 精灵之火
			{ spellID =    770, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			{ spellID = 102355, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- 旋风
			{ spellID =  33786, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 日光术
			{ spellID =  81261, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 纠缠根须
			{ spellID =    339, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 群体缠绕
			{ spellID = 102359, unitID = "target", caster = "all",    filter = "DEBUFF"},
		},
		{
			Name = "玩家技能CD",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playercd)},

			-- 狂暴
			{ spellID =  50334, filter = "CD" },
			-- 猛虎之怒
			{ spellID =   5217, filter = "CD" },
			-- 狂暴回复
			{ spellID =  22842, filter = "CD" },
			-- 复生
			{ spellID =  20484, filter = "CD" },
			-- 树皮术
			{ spellID =  22812, filter = "CD" },
			-- 宁静
			{ spellID =    740, filter = "CD" },
			-- 化身：乌索克之子
			{spellID  = 102558, filter = "CD" },
			-- 化身：生命之树
			{spellID  =  33891, filter = "CD" },
			-- 化身：艾露恩之眷
			{spellID  = 102560, filter = "CD" },
			-- 化身：丛林之王
			{spellID  = 102543, filter = "CD" },
			-- 自然的守护
			{ spellID = 124974, filter = "CD" },
			-- 超凡之盟
			{ spellID = 112071, filter = "CD" },
			-- 自然迅捷
			{ spellID = 132158, filter = "CD" },

			-- 物品
			-- 手套
			{ slotID = 10, filter = "CD" },
			-- 腰带
			{ slotID =  6, filter = "CD" },
			-- 披风
			{ slotID = 15, filter = "CD" },
			-- 饰品
			{ slotID = 13, filter = "CD" },
			{ slotID = 14, filter = "CD" },
		},
	},
	["HUNTER"] = {		-- [猎人]
		{
			Name = "玩家buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playerbuff)},

			-- 误导
			{ spellID =  34477, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID =  35079, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 威慑
			{ spellID = 148467, unitID = "player", caster = "player", filter = "BUFF"},
			-- 急速射击
			{ spellID =   3045, unitID = "player", caster = "player", filter = "BUFF"},
			-- 集中火力
			{ spellID =  82692, unitID = "player", caster = "player", filter = "BUFF"},
			-- 灵魂治愈
			{ spellID =  90361, unitID = "player", caster = "player", filter = "BUFF"},
			-- 迅疾如风
			{ spellID = 118922, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狩猎刺激
			{ spellID =  34720, unitID = "player", caster = "player", filter = "BUFF"},
			-- 治疗宠物
			{ spellID =    136, unitID = "pet",    caster = "player", filter = "BUFF"},
			-- 狂乱
			{ spellID =  19615, unitID = "pet",    caster = "pet",    filter = "BUFF", absID = true},
			-- 狂野怒火
			{ spellID =  19574, unitID = "player", caster = "player", filter = "BUFF"},
			-- 稳固集中
			{ spellID = 177668, unitID = "player", caster = "player", filter = "BUFF"},
			-- 眼镜蛇打击
			{ spellID =  53257, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂轰乱炸
			{ spellID =  82921, unitID = "player", caster = "player", filter = "BUFF"},
			-- T17 威猛射击
			{ spellID = 168980, unitID = "player", caster = "player", filter = "BUFF"},
			{ spellID = 167165, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "目标debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].targetdebuff)},

			-- 冰冻陷阱
			{ spellID =   3355, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 翼龙钉刺
			{ spellID =  19386, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 束缚射击
			{ spellID = 117405, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 毒蛇釘刺
			{ spellID = 118253, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 黑箭
			{ spellID =   3674, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 爆炸射击
			{ spellID =  53301, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 险境求生
			{ spellID = 136634, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 寒冰弹
			{ spellID = 162546, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 毒液弹
			{ spellID = 162543, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 爆炸陷阱
			{ spellID =  13812, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 黑鸦
			{ spellID = 131894, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "玩家技能CD",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playercd)},

			-- 奇美拉射击
			{ spellID =  53209, filter = "CD" },
			-- 急速射击
			{ spellID =   3045, filter = "CD" },
			-- 爆炸射击
			{ spellID =  53301, filter = "CD" },
			-- 黑箭
			{ spellID =   3674, filter = "CD" },
			-- 主人的召唤
			{ spellID =  53271, filter = "CD" },
			-- 假死
			{ spellID =   5384, filter = "CD" },
			-- 凶暴野兽
			{ spellID = 120679, filter = "CD" },
			-- 黑鸦
			{ spellID = 131894, filter = "CD" },

			-- 物品
			-- 手套
			{ slotID = 10, filter = "CD" },
			-- 腰带
			{ slotID =  6, filter = "CD" },
			-- 披风
			{ slotID = 15, filter = "CD" },
			-- 饰品
			{ slotID = 13, filter = "CD" },
			{ slotID = 14, filter = "CD" },
		},
	},
	["MAGE"] = {		--[法师]
		{
			Name = "玩家buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playerbuff)},

			-- 寒冰屏障
			{ spellID =  45438, unitID = "player", caster = "player", filter = "BUFF"},
			-- 隐形术
			{ spellID =  32612, unitID = "player", caster = "player", filter = "BUFF"},
			-- 强化隐形术
			{ spellID = 110960, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 冰冷血脉
			{ spellID =  12472, unitID = "player", caster = "player", filter = "BUFF"},
			-- 奥术强化
			{ spellID =  12042, unitID = "player", caster = "player", filter = "BUFF"},
			-- 寒冰护体
			{ spellID =  11426, unitID = "player", caster = "player", filter = "BUFF"},
			-- 寒冰结界
			{ spellID = 111264, unitID = "player", caster = "player", filter = "BUFF"},
			-- 热力迸发
			{ spellID =  48107, unitID = "player", caster = "player", filter = "BUFF"},
			-- 炎爆术
			{ spellID =  48108, unitID = "player", caster = "player", filter = "BUFF"},
			-- 浮冰
			{ spellID = 108839, unitID = "player", caster = "player", filter = "BUFF"},
			-- 操控时间
			{ spellID = 110909, unitID = "player", caster = "player", filter = "BUFF"},
			-- 时光护盾
			{ spellID = 115610, unitID = "player", caster = "player", filter = "BUFF"},
			-- 炽热疾速
			{ spellID = 108843, unitID = "player", caster = "player", filter = "BUFF"},
			-- 能量符文
			{ spellID = 116014, unitID = "player", caster = "player", filter = "BUFF"},
			-- 寒冰指
			{ spellID =  44544, unitID = "player", caster = "player", filter = "BUFF"},
			-- 冰冷智慧
			{ spellID =  57761, unitID = "player", caster = "player", filter = "BUFF"},
			-- 奥术飞弹
			{ spellID =  79683, unitID = "player", caster = "player", filter = "BUFF"},
			-- 魔法增益
			{ spellID = 159916, unitID = "player", caster = "player", filter = "BUFF"},
			-- 奥术充能
			{ spellID =  36032, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "目标debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].targetdebuff)},

			-- 变形术(羊/猪/火鸡/黑猫/兔子/乌龟/企鹅/猴子/北极熊幼崽/孔雀/豪猪)
			{ spellID =    118, unitID = "target", caster = "all",    filter = "DEBUFF", absID = true},
			{ spellID =  28272, unitID = "target", caster = "all",    filter = "DEBUFF", absID = true},
			{ spellID =  61780, unitID = "target", caster = "all",    filter = "DEBUFF", absID = true},
			{ spellID =  61305, unitID = "target", caster = "all",    filter = "DEBUFF", absID = true},
			{ spellID =  61721, unitID = "target", caster = "all",    filter = "DEBUFF", absID = true},
			{ spellID =  28271, unitID = "target", caster = "all",    filter = "DEBUFF", absID = true},
			{ spellID = 161355, unitID = "target", caster = "all",    filter = "DEBUFF", absID = true},
			{ spellID = 161354, unitID = "target", caster = "all",    filter = "DEBUFF", absID = true},
			{ spellID = 161353, unitID = "target", caster = "all",    filter = "DEBUFF", absID = true},
			{ spellID = 161355, unitID = "target", caster = "all",    filter = "DEBUFF", absID = true},
			{ spellID = 126819, unitID = "target", caster = "all",    filter = "DEBUFF", absID = true},
			-- 龙息术
			{ spellID =  31661, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冰霜之颌
			{ spellID = 102051, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冰霜新星
			{ spellID =    122, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冲击波
			{ spellID = 157981, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 减速
			{ spellID =  31589, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 点燃
			{ spellID =  12654, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 活动炸弹
			{ spellID =  44457, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 虚空风暴
			{ spellID = 114923, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 寒冰炸弹
			{ spellID = 112948, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 炎爆术
			{ spellID =  11366, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 燃烧
			{ spellID =  83853, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冰锥术
			{ spellID =    120, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 霜火之箭
			{ spellID =  44614, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "玩家技能CD",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playercd)},

			-- 镜像术
			{ spellID = 55342, filter = "CD" },
			-- 隐形术
			{ spellID =    66, filter = "CD" },
			-- 燃火
			{ spellID = 11129, filter = "CD" },
			-- 唤醒
			{ spellID = 12051, filter = "CD" },
			-- 秘法强化
			{ spellID = 12042, filter = "CD" },
			-- 急速冷却
			{ spellID = 11958, filter = "CD" },
			-- 深度冻结
			{ spellID = 44572, filter = "CD" },
			-- 冰冷血脉
			{ spellID = 12472, filter = "CD" },
			-- 寒冰屏障
			{ spellID = 45438, filter = "CD" },
			-- 冰霜之球
			{ spellID = 84714, filter = "CD" },

			-- 物品
			-- 手套
			{ slotID = 10, filter = "CD" },
			-- 腰带
			{ slotID =  6, filter = "CD" },
			-- 披风
			{ slotID = 15, filter = "CD" },
			-- 饰品
			{ slotID = 13, filter = "CD" },
			{ slotID = 14, filter = "CD" },
		},
	},
	["MONK"] = {		--[武僧]
		{
			Name = "玩家buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playerbuff)},

			-- 金钟罩
			{ spellID = 115295, unitID = "player", caster = "player", filter = "BUFF"},
			-- 躯不坏
			{ spellID = 122278, unitID = "player", caster = "player", filter = "BUFF"},
			-- 壮胆酒
			{ spellID = 120954, unitID = "player", caster = "player", filter = "BUFF"},
			-- 飘渺酒
			{ spellID = 115308, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 虎眼酒
			{ spellID = 116740, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 业报之触
			{ spellID = 125174, unitID = "player", caster = "player", filter = "BUFF"},
			-- 散魔功
			{ spellID = 122783, unitID = "player", caster = "player", filter = "BUFF"},
			-- 豪能酒
			{ spellID = 115288, unitID = "player", caster = "player", filter = "BUFF"},
			-- 势如破竹
			{ spellID = 119085, unitID = "player", caster = "player", filter = "BUFF"},
			-- 猛虎连击
			{ spellID = 120273, unitID = "player", caster = "player", filter = "BUFF"},
			-- 猛虎之力
			{ spellID = 125359, unitID = "player", caster = "player", filter = "BUFF"},
			-- 踏风连击：幻灭踢
			{ spellID = 116768, unitID = "player", caster = "player", filter = "BUFF"},
			-- 踏风连击：猛虎掌
			{ spellID = 118864, unitID = "player", caster = "player", filter = "BUFF"},
			-- 酒醒入定
			{ spellID = 115307, unitID = "player", caster = "player", filter = "BUFF"},
			-- 活力之雾
			{ spellID = 118674, unitID = "player", caster = "player", filter = "BUFF"},
			-- 青龙之忱
			{ spellID = 127722, unitID = "player", caster = "player", filter = "BUFF"},
			-- 雷神聚光茶
			{ spellID = 116680, unitID = "player", caster = "player", filter = "BUFF"},
			-- 真气破
			{ spellID = 159407, unitID = "player", caster = "player", filter = "BUFF"},
			-- 生死簿
			{ spellID = 121125, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "目标debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].targetdebuff)},

			-- 复苏之雾
			{ spellID = 119611, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 氤氲之雾 
			{ spellID = 132120, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 禅意珠   
			{ spellID = 124081, unitID = "target", caster = "player", filter = "BUFF"  }, 
			-- 作茧缚命   
			{ spellID = 116849, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 火焰之息
			{ spellID = 123725, unitID = "target", caster = "player", filter = "DEBUFF"}, 
			-- 旭日东升踢
			{ spellID = 130320, unitID = "target", caster = "player", filter = "DEBUFF"}, 
			-- 幻灭踢
			{ spellID = 128531, unitID = "target", caster = "player", filter = "DEBUFF"}, 
			-- 扫堂腿
			{ spellID = 119381, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 金钢震
			{ spellID = 116095, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 风火雷电
			{ spellID = 138130, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 分筋错骨
			{ spellID = 115078, unitID = "target", caster = "all",    filter = "DEBUFF"},
		},
		{
			Name = "玩家技能CD",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playercd)},

			-- 禅悟冥想 
			{ spellID = 115176, filter = "CD" }, 
			-- 业报之触 
			{ spellID = 122470, filter = "CD" }, 
			-- 豪能酒 
			{ spellID = 115288, filter = "CD" }, 
			-- 壮胆酒 
			{ spellID = 115203, filter = "CD" }, 
			-- 还魂术
			{ spellID = 115310, filter = "CD" }, 
			-- 旭日东升踢 
			{ spellID = 107428, filter = "CD" }, 
			-- 移花接木
			{ spellID = 115072, filter = "CD" },
			-- 作茧缚命
			{ spellID = 116849, filter = "CD" },

			-- 物品
			-- 手套
			{ slotID = 10, filter = "CD" },
			-- 腰带
			{ slotID =  6, filter = "CD" },
			-- 披风
			{ slotID = 15, filter = "CD" },
			-- 饰品
			{ slotID = 13, filter = "CD" },
			{ slotID = 14, filter = "CD" },
		},
	},
	["PALADIN"] = {		--[骑士]
		{
			Name = "玩家buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playerbuff)},

			-- 虔诚光环
			{ spellID =  31821, unitID = "player", caster = "player", filter = "BUFF"},
			-- 圣盾术
			{ spellID =    642, unitID = "player", caster = "player", filter = "BUFF"},
			-- 远古列王守卫
			{ spellID =  86659, unitID = "player", caster = "player", filter = "BUFF"},
			-- 神圣复仇者
			{ spellID = 105809, unitID = "player", caster = "player", filter = "BUFF"},
			-- 复仇之怒
			{ spellID =  31884, unitID = "player", caster = "player", filter = "BUFF"},
			-- 炽热防御者
			{ spellID =  31850, unitID = "player", caster = "player", filter = "BUFF"},
			-- 圣佑术
			{ spellID =    498, unitID = "player", caster = "player", filter = "BUFF"},
			-- 圣光之速
			{ spellID =  85499, unitID = "player", caster = "player", filter = "BUFF"},
			-- 圣洁护盾
			{ spellID =  20925, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 正义盾击
			{ spellID =  53600, unitID = "player", caster = "player", filter = "BUFF"},
			-- 圣光灌注
			{ spellID =  54149, unitID = "player", caster = "player", filter = "BUFF"},
			-- 荣耀堡垒
			{ spellID = 114637, unitID = "player", caster = "player", filter = "BUFF"},
			-- 无私治愈
			{ spellID = 114250, unitID = "player", caster = "player", filter = "BUFF"},
			-- 神圣意志
			{ spellID =  90174, unitID = "player", caster = "player", filter = "BUFF"},
			-- 大十字军
			{ spellID =  85416, unitID = "player", caster = "player", filter = "BUFF"},
			-- 破晓
			{ spellID =  88819, unitID = "player", caster = "player", filter = "BUFF"},
			-- 法网恢恢
			{ spellID =  87173, unitID = "player", caster = "player", filter = "BUFF"},
			-- 远古列王的圣光
			{ spellID =  86678, unitID = "player", caster = "player", filter = "BUFF"},
			-- 炽天使
			{ spellID = 152262, unitID = "player", caster = "player", filter = "BUFF"},
			-- 最终审判
			{ spellID = 157048, unitID = "player", caster = "player", filter = "BUFF"},
			-- 玛尔拉德的真理
			{ spellID = 156990, unitID = "player", caster = "player", filter = "BUFF"},
			-- 莉亚德琳的公正
			{ spellID = 156989, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "目标debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].targetdebuff)},

			-- 忏悔
			{ spellID =  20066, unitID = "target", caster = "all",    filter = "DEBUFF" },
			-- 自律
			{ spellID =  25771, unitID = "target", caster = "all",    filter = "DEBUFF" },
			-- 制裁之錘
			{ spellID =    853, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 制裁之拳
			{ spellID = 105593, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 罪孽如山
			{ spellID = 110300, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 公正圣印
			{ spellID =  20170, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 谴责
			{ spellID =   2812, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 谴罚
			{ spellID =  31803, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 复仇者之盾
			{ spellID =  31935, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 眩晕—之盾(雕纹)
			{ spellID =  63529, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 处决审判
			{ spellID = 114916, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 纯净之手
			{ spellID = 114039, unitID = "target", caster = "player", filter = "BUFF"   },
			-- 永恒之火
			{ spellID = 156322, unitID = "target", caster = "player", filter = "BUFF"   },
			-- 圣光救赎
			{ spellID = 157128, unitID = "target", caster = "player", filter = "BUFF"   },
			-- 洞察道标
			{ spellID = 157007, unitID = "target", caster = "player", filter = "BUFF"   },
			-- 光辉治疗
			{ spellID =  86273, unitID = "target", caster = "player", filter = "BUFF"   },
			-- 圣洁护盾
			{ spellID =  65148, unitID = "target", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 148039, unitID = "target", caster = "player", filter = "BUFF", absID = true},
			{ spellID =  20925, unitID = "target", caster = "player", filter = "BUFF", absID = true},
		},
		{
			Name = "玩家技能CD",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playercd)},

			-- 虔诚光环
			{ spellID = 31821, filter = "CD" },
			-- 圣佑术
			{ spellID =   498, filter = "CD" },
			-- 圣盾术
			{ spellID =   642, filter = "CD" },
			-- 炽热防御者
			{ spellID = 31850, filter = "CD" },
			-- 远古列王守卫
			{ spellID = 86659, filter = "CD" },

			-- 物品
			-- 手套
			{ slotID = 10, filter = "CD" },
			-- 腰带
			{ slotID =  6, filter = "CD" },
			-- 披风
			{ slotID = 15, filter = "CD" },
			-- 饰品
			{ slotID = 13, filter = "CD" },
			{ slotID = 14, filter = "CD" },
		},
	},
	["PRIEST"] = {		--[牧师]
		{
			Name = "玩家buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playerbuff)},

			-- 消散
			{ spellID =  47585, unitID = "player", caster = "player", filter = "BUFF"},
			-- 能量灌注
			{ spellID =  10060, unitID = "player", caster = "player", filter = "BUFF"},
			-- 灵魂护壳
			{ spellID = 109964, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 大天使
			{ spellID =  81700, unitID = "player", caster = "player", filter = "BUFF"},
			--天使之壁
			{ spellID = 114214, unitID = "player", caster = "player", filter = "BUFF"},
			-- 吸血鬼的拥抱
			{ spellID =  15286, unitID = "player", caster = "player", filter = "BUFF"},
			-- 渐隐术
			{ spellID =    586, unitID = "player", caster = "player", filter = "BUFF"},
			-- 争分夺秒
			{ spellID =  59889, unitID = "player", caster = "player", filter = "BUFF"},
			-- 专注意志
			{ spellID =  45242, unitID = "player", caster = "player", filter = "BUFF"},
			-- 愈合祷言
			{ spellID =  41635, unitID = "player", caster = "player", filter = "BUFF"},
			-- 神圣洞察
			{ spellID = 123266, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 123267, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 124430, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 光明涌动
			{ spellID = 114255, unitID = "player", caster = "player", filter = "BUFF"},
			-- 黑暗涌动
			{ spellID =  87160, unitID = "player", caster = "player", filter = "BUFF"},
			-- 妙手回春
			{ spellID =  63735, unitID = "player", caster = "player", filter = "BUFF"},
			-- 心灵尖刺雕文
			{ spellID =  81292, unitID = "player", caster = "player", filter = "BUFF"},
			-- 命运多舛
			{ spellID = 123254, unitID = "player", caster = "player", filter = "BUFF"},
			-- 福音传播
			{ spellID =  81661, unitID = "player", caster = "player", filter = "BUFF"},
			-- 愈合之语
			{ spellID = 155362, unitID = "player", caster = "player", filter = "BUFF"},
			-- 愈合之语(十层)
			{ spellID = 155363, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "目标debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].targetdebuff)},

			-- 束缚亡灵
			{ spellID =   9484, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 真言术：盾
			{ spellID =     17, unitID = "target", caster = "all",    filter = "BUFF"  },
			-- 恢复
			{ spellID =    139, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 静
			{ spellID =  88684, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 愈合祷言
			{ spellID =  41635, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 守护之魂
			{ spellID =  47788, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 痛苦压制
			{ spellID =  33206, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 神圣之火
			{ spellID =  14914, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 真言术：慰
			{ spellID = 129250, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 意志洞悉
			{ spellID = 152118, unitID = "target", caster = "all",    filter = "BUFF"  },
			-- 暗言术：痛
			{ spellID =    589, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 暗言术：乱
			{ spellID = 132573, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 吸血鬼之触
			{ spellID =  34914, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 噬灵疫病
			{ spellID = 158831, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 虚弱灵魂
			{ spellID =   6788, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 虚空熵能
			{ spellID = 155361, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 心灵尖啸
			{ spellID =   8122, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 心灵惊骇
			{ spellID =  64044, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 沉默
			{ spellID =  15487, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "玩家技能CD",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playercd)},

			-- 愈合祷言
			{ spellID =  33076, filter = "CD" },
			-- 治疗之环
			{ spellID =  34861, filter = "CD" },
			-- 圣言术：静
			{ spellID =  88684, filter = "CD" },
			-- 光晕
			{ spellID = 120517, filter = "CD" },
			-- 摧心魔
			{ spellID = 123040, filter = "CD" },
			-- 暗影魔
			{ spellID =  34433, filter = "CD" },
			-- 心灵震爆
			{ spellID =   8092, filter = "CD" },
			-- 神圣之箭
			{ spellID = 121135, filter = "CD" },
			-- 消散
			{ spellID =  47585, filter = "CD" },
			-- 吸血鬼的拥抱
			{ spellID =  15286, filter = "CD" },

			-- 物品
			-- 手套
			{ slotID = 10, filter = "CD" },
			-- 腰带
			{ slotID =  6, filter = "CD" },
			-- 披风
			{ slotID = 15, filter = "CD" },
			-- 饰品
			{ slotID = 13, filter = "CD" },
			{ slotID = 14, filter = "CD" },
		},
	},
	["ROGUE"] = {		--[盗贼]
		{
			Name = "玩家buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playerbuff)},

			-- 切割
			{ spellID =   5171, unitID = "player", caster = "player", filter = "BUFF"},
			-- 恢复
			{ spellID =  73651, unitID = "player", caster = "player", filter = "BUFF"},
			-- 冲动
			{ spellID =  13750, unitID = "player", caster = "player", filter = "BUFF"},
			-- 闪避
			{ spellID =   5277, unitID = "player", caster = "player", filter = "BUFF"},
			-- 毒伤
			{ spellID =  32645, unitID = "player", caster = "player", filter = "BUFF"},
			-- 暗影之舞
			{ spellID =  51713, unitID = "player", caster = "player", filter = "BUFF"},
			-- 暗影斗篷
			{ spellID =  31224, unitID = "player", caster = "player", filter = "BUFF"},
			-- 消失
			{ spellID =   1856, unitID = "player", caster = "player", filter = "BUFF"},
			-- 备战就绪
			{ spellID =  74001, unitID = "player", caster = "player", filter = "BUFF"},
			-- 战斗洞察
			{ spellID =  74002, unitID = "player", caster = "player", filter = "BUFF"},
			-- 装死
			{ spellID =  45182, unitID = "player", caster = "player", filter = "BUFF"},
			-- 剑刃乱舞
			{ spellID =  13877, unitID = "player", caster = "player", filter = "BUFF"},
			-- 疾跑
			{ spellID =   2983, unitID = "player", caster = "player", filter = "BUFF"},
			-- 佯攻
			{ spellID =   1966, unitID = "player", caster = "player", filter = "BUFF"},
			-- 诡诈
			{ spellID = 115192, unitID = "player", caster = "player", filter = "BUFF"},
			-- 预感
			{ spellID = 115189, unitID = "player", caster = "player", filter = "BUFF"},
			-- 初步洞悉
			{ spellID =  84745, unitID = "player", caster = "player", filter = "BUFF"},
			-- 中等洞悉
			{ spellID =  84746, unitID = "player", caster = "player", filter = "BUFF"},
			-- 深度洞悉
			{ spellID =  84747, unitID = "player", caster = "player", filter = "BUFF"},
			-- 盲点
			{ spellID = 121153, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "目标debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].targetdebuff)},

			-- 闷棍
			{ spellID =   6770, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 致盲
			{ spellID =   2094, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 锁喉 - 沉默
			{ spellID =   1330, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 肾击
			{ spellID =    408, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 锁喉
			{ spellID =    703, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 偷袭
			{ spellID =   1833, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 割裂
			{ spellID =   1943, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 凿击
			{ spellID =   1776, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 要害打击
			{ spellID =  84617, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 仇杀
			{ spellID =  79140, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 出血
			{ spellID =  16511, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 洞悉弱点
			{ spellID =  91021, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 致命药膏
			{ spellID =   2818, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 减速药膏
			{ spellID =   3409, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 致伤药膏
			{ spellID =   8680, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 吸血药膏
			{ spellID = 112961, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 猩红风暴
			{ spellID = 122233, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 致命投掷
			{ spellID =  26679, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 死亡标志
			{ spellID = 137619, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "玩家技能CD",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playercd)},

			-- 殺戮盛筵
			{ spellID =  51690, filter = "CD" },
			-- 冲动
			{ spellID =  13750, filter = "CD" },

			-- 物品
			-- 手套
			{ slotID = 10, filter = "CD" },
			-- 腰带
			{ slotID =  6, filter = "CD" },
			-- 披风
			{ slotID = 15, filter = "CD" },
			-- 饰品
			{ slotID = 13, filter = "CD" },
			{ slotID = 14, filter = "CD" },
		},
	},
	["SHAMAN"] = {		--[萨满]
		{
			Name = "玩家buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playerbuff)},

			-- 漩涡武器
			{ spellID =  53817, unitID = "player", caster = "player", filter = "BUFF"},
			-- 闪电之盾
			{ spellID =    324, unitID = "player", caster = "player", filter = "BUFF"},
			-- 萨满之怒
			{ spellID =  30823, unitID = "player", caster = "player", filter = "BUFF"},
			-- 元素掌握
			{ spellID =  16166, unitID = "player", caster = "player", filter = "BUFF"},
			-- 升腾
			{ spellID = 114050, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 114051, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 114052, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 灵魂行者的恩赐
			{ spellID =  79206, unitID = "player", caster = "player", filter = "BUFF"},
			-- 怒火释放
			{ spellID = 118470, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 118472, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 118473, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 火焰释放
			{ spellID = 165462, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID =  73683, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 生命释放
			{ spellID =  73685, unitID = "player", caster = "player", filter = "BUFF"},
			-- 风之释放
			{ spellID =  73681, unitID = "player", caster = "player", filter = "BUFF"},
			-- 元素融合
			{ spellID = 157174, unitID = "player", caster = "player", filter = "BUFF"},
			-- 元素专注
			{ spellID = 167205, unitID = "player", caster = "player", filter = "BUFF"},
			-- 石壁
			{ spellID = 114893, unitID = "player", caster = "player", filter = "BUFF"},
			-- 先祖指引
			{ spellID = 108281, unitID = "player", caster = "player", filter = "BUFF"},
			-- 星界转移
			{ spellID = 108271, unitID = "player", caster = "player", filter = "BUFF"},
			-- 熔岩奔腾
			{ spellID =  77762, unitID = "player", caster = "player", filter = "BUFF"},
			-- 元素冲击
			{ spellID = 118522, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 173183, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 173184, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 173185, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 173187, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 潮汐奔涌
			{ spellID =  53390, unitID = "player", caster = "player", filter = "BUFF"},
			-- 治疗之雨
			{ spellID =  73920, unitID = "player", caster = "player", filter = "BUFF"},
			-- 暴雨图腾
			{ spellID = 157504, unitID = "player", caster = "player", filter = "BUFF"},
			-- 幽魂步
			{ spellID =  58875, unitID = "player", caster = "player", filter = "BUFF"},
			-- 元素回响
			{ spellID = 159103, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "目标debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].targetdebuff)},

			-- 大地之盾
			{ spellID =    974, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 激流
			{ spellID =  61295, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 大地震击
			{ spellID =   8042, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 烈焰震击
			{ spellID =   8050, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冰霜震击
			{ spellID =   8056, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 风暴打击
			{ spellID =  17364, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 风切
			{ spellID = 115356, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 妖术
			{ spellID =  51514, unitID = "target", caster = "all",    filter = "DEBUFF"},
		},
		{
			Name = "玩家技能CD",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playercd)},

			--火元素TT
			{ spellID =   2894, filter = "CD" },
			--土元素TT
			{ spellID =   2062, filter = "CD" },
			--治疗之泉TT
			{ spellID =   5394, filter = "CD" },
			--元素掌控
			{ spellID =  16166, filter = "CD" },
			--风暴之鞭TT
			{ spellID = 120669, filter = "CD" },

			-- 物品
			-- 手套
			{ slotID = 10, filter = "CD" },
			-- 腰带
			{ slotID =  6, filter = "CD" },
			-- 披风
			{ slotID = 15, filter = "CD" },
			-- 饰品
			{ slotID = 13, filter = "CD" },
			{ slotID = 14, filter = "CD" },
		},
	},
	["WARLOCK"] = {		--[术士]
		{
			Name = "玩家buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playerbuff)},

			-- 暗影冥思
			{ spellID =  17941, unitID = "player", caster = "player", filter = "BUFF" },
			-- 黑暗灵魂:易爆
			{ spellID = 113858, unitID = "player", caster = "player", filter = "BUFF" },
			-- 黑暗灵魂:学识
			{ spellID = 113861, unitID = "player", caster = "player", filter = "BUFF" },
			-- 黑暗灵魂:哀难
			{ spellID = 113860, unitID = "player", caster = "player", filter = "BUFF" },
			-- 灵魂燃烧
			{ spellID =  74434, unitID = "player", caster = "player", filter = "BUFF" },
			-- 熔火之心
			{ spellID = 140074, unitID = "player", caster = "player", filter = "BUFF" },
			-- 爆燃
			{ spellID = 117828, unitID = "player", caster = "player", filter = "BUFF" },
			-- 火焰之雨
			{ spellID = 104232, unitID = "player", caster = "player", filter = "BUFF" },
			-- 灵魂交换
			{ spellID =  86211, unitID = "player", caster = "player", filter = "BUFF" },
			-- 黑暗交易
			{ spellID = 110913, unitID = "player", caster = "player", filter = "BUFF" },
			-- 不灭决心
			{ spellID = 104773, unitID = "player", caster = "player", filter = "BUFF" },
			-- 牺牲契约
			{ spellID = 108416, unitID = "player", caster = "player", filter = "BUFF" },
			-- 黑暗再生
			{ spellID = 108359, unitID = "player", caster = "player", filter = "BUFF" },
			-- 基尔加丹的狡诈
			{ spellID = 137587, unitID = "player", caster = "player", filter = "BUFF" },
			-- 献祭光环
			{ spellID = 104025, unitID = "player", caster = "player", filter = "BUFF" },
			-- 鬼魅灵魂
			{ spellID = 157698, unitID = "player", caster = "player", filter = "BUFF" },
			-- 硫磺烈火
			{ spellID = 108683, unitID = "player", caster = "player", filter = "BUFF" },
			-- 恶魔协同
			{ spellID = 171982, unitID = "player", caster = "pet",    filter = "BUFF" },
			-- 恶魔箭
			{ spellID = 157695, unitID = "player", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "目标debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].targetdebuff)},

			-- 恐惧
			{ spellID = 118699, unitID = "target", caster = "all",    filter = "DEBUFF" },
			-- 放逐术
			{ spellID =    710, unitID = "target", caster = "all",    filter = "DEBUFF" },
			-- 恐惧嚎叫
			{ spellID =   5484, unitID = "target", caster = "all",    filter = "DEBUFF" },
			-- 死亡缠绕
			{ spellID =   6789, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 奴役恶魔
			{ spellID =   1098, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 献祭
			{ spellID = 157736, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			{ spellID = 108686, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- 痛楚
			{ spellID =    980, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 痛苦无常
			{ spellID =  30108, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- 鬼影缠身
			{ spellID =  48181, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 腐蚀之种
			{ spellID =  27243, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			{ spellID = 114790, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- 腐蚀术
			{ spellID = 146739, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 末日降临
			{ spellID =    603, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 古尔丹之手
			{ spellID =  47960, unitID = "target", caster = "player", filter = "DEBUFF" },

			-- 披风
			{ spellID = 146198, unitID = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			Name = "玩家技能CD",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playercd)},

			-- 黑暗灵魂
			{ spellID =  77801, filter = "CD" },

			-- 物品
			-- 手套
			{ slotID = 10, filter = "CD" },
			-- 腰带
			{ slotID =  6, filter = "CD" },
			-- 披风
			{ slotID = 15, filter = "CD" },
			-- 饰品
			{ slotID = 13, filter = "CD" },
			{ slotID = 14, filter = "CD" },
		},
	},
	["WARRIOR"] = { 		--[战士]
		{
			Name = "玩家buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playerbuff)},

			-- 盾墙
			{ spellID =    871, unitID = "player", caster = "player", filter = "BUFF"},
			-- 破釜沉舟
			{ spellID =  12975, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂怒回复
			{ spellID =  55694, unitID = "player", caster = "player", filter = "BUFF"},
			-- 盾牌格挡
			{ spellID = 132404, unitID = "player", caster = "player", filter = "BUFF"},
			-- 盾牌屏障
			{ spellID = 112048, unitID = "player", caster = "player", filter = "BUFF"},
			-- 盾牌冲锋
			{ spellID = 169667, unitID = "player", caster = "player", filter = "BUFF"},
			-- 法术反射
			{ spellID =  23920, unitID = "player", caster = "player", filter = "BUFF"},
			-- 剑在人在
			{ spellID = 118038, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂暴之怒
			{ spellID =  18499, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 天神下凡
			{ spellID = 107574, unitID = "player", caster = "player", filter = "BUFF"},
			-- 鲁莽
			{ spellID =   1719, unitID = "player", caster = "player", filter = "BUFF"},
			-- 横扫攻击
			{ spellID =  12328, unitID = "player", caster = "player", filter = "BUFF"},
			-- 乘胜追击
			{ spellID =  32216, unitID = "player", caster = "player", filter = "BUFF"},
			-- 怒击
			{ spellID = 131116, unitID = "player", caster = "player", filter = "BUFF"},
			-- 血脉贲张
			{ spellID =  46916, unitID = "player", caster = "player", filter = "BUFF"},
			-- 剑盾猛攻
			{ spellID =  50227, unitID = "player", caster = "player", filter = "BUFF"},
			-- 最后通牒
			{ spellID = 122510, unitID = "player", caster = "player", filter = "BUFF"},
			-- 激怒
			{ spellID =  12880, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 狂战士
			{ spellID = 166588, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 绞肉机
			{ spellID =  85739, unitID = "player", caster = "player", filter = "BUFF"},
			-- 浴血奋战
			{ spellID =  12292, unitID = "player", caster = "player", filter = "BUFF"},
			-- 粗暴打断
			{ spellID =  86663, unitID = "player", caster = "player", filter = "BUFF"},
			-- 猝死
			{ spellID =  52437, unitID = "player", caster = "player", filter = "BUFF"},
			-- 破坏者
			{ spellID = 152277, unitID = "player", caster = "player", filter = "BUFF", absID = true},
		},
		{
			Name = "目标debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].targetdebuff)},

			-- 震荡波
			{ spellID =  132168, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 断筋
			{ spellID =    1715, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 挫志怒吼
			{ spellID =    1160, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 刺耳怒吼
			{ spellID =   12323, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 破胆怒吼
			{ spellID =    5246, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 巨人打击
			{ spellID =  167105, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 风暴之锤
			{ spellID =  132169, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- 撕裂
			{ spellID =     772, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 重伤
			{ spellID =  115767, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 浴血奋战
			{ spellID =  113344, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- 剑刃风暴
			{ spellID =   46924, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "玩家技能CD",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].playercd)},

			-- 鲁莽
			{ spellID =   1719, filter = "CD" },
			-- 浴血奋战
			{ spellID =  12292, filter = "CD" },
			-- 盾墙
			{ spellID =    871, filter = "CD" },
			-- 集结呐喊
			{ spellID =  97462, filter = "CD" },
			-- 破胆怒吼
			{ spellID =   5246, filter = "CD" },
			-- 天神下凡
			{ spellID = 107574, filter = "CD" },
			-- 狂怒回复
			{ spellID =  55694, filter = "CD" },
			-- 剑在人在
			{ spellID = 118038, filter = "CD" },
			-- 错愕怒吼
			{ spellID = 107566, filter = "CD" },
			-- 剑刃风暴
			{ spellID =  46924, filter = "CD" },
			-- 英勇飞跃
			{ spellID =   6544, filter = "CD" },

			-- 物品
			-- 手套
			{ slotID = 10, filter = "CD" },
			-- 腰带
			{ slotID =  6, filter = "CD" },
			-- 披风
			{ slotID = 15, filter = "CD" },
			-- 饰品
			{ slotID = 13, filter = "CD" },
			{ slotID = 14, filter = "CD" },
		},
	},
	["ALL"] = {
		{ 
			Name = "玩家饰品附魔触发buff",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 5,
			Alpha = 1,
			IconSize = 28,
			Position = {unpack(FG["filger_position"].enbuff)},


			-- 药水
			-------------------------------MOP----------------------------------------
			-- WOD护甲药水
			{ spellID = 156430, unitID = "player", caster = "player", filter = "BUFF" },
			-- WOD力量药水
			{ spellID = 156428, unitID = "player", caster = "player", filter = "BUFF" },
			-- WOD智力药水
			{ spellID = 156426, unitID = "player", caster = "player", filter = "BUFF" },
			-- WOD敏捷药水
			{ spellID = 156423, unitID = "player", caster = "player", filter = "BUFF" },
			-- WOD隐身药水
			{ spellID = 175833, unitID = "player", caster = "player", filter = "BUFF" },

			-- 武器附魔(caster = 必须是all)
			-------------------------------MOP----------------------------------------
			-- 霜狼之印(溅射)
			{ spellID = 159676, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 黑石之印(护甲)
			{ spellID = 159679, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 战歌之印(急速)
			{ spellID = 159675, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 影月之印(精神)
			{ spellID = 159678, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 雷神之印(爆击)
			{ spellID = 159234, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 血环之印(精通)
			{ spellID = 173322, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 赫米特的觅心者(精通)
			{ spellID = 173288, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 奥格索普的飞弹分离器(溅射)
			{ spellID = 156055, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 兆瓦纤维(爆击)
			{ spellID = 156060, unitID = "player", caster = "all",    filter = "BUFF" },
			-------------------------------MOP----------------------------------------
			-- 涓咏
			{ spellID = 116660, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 玉魂
			{ spellID = 104993, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 钢铁之舞
			{ spellID = 120032, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 爆裂领主的毁灭瞄准镜
			{ spellID = 109085, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 血腥舞钢
			{ spellID = 142530, unitID = "player", caster = "all",    filter = "BUFF" },


			-- 专业技能
			-- 神经元弹簧
			{ spellID = 126734, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 氮气推进器
			{ spellID =  54861, unitID = "player", caster = "all",    filter = "BUFF" },
			-- 降落伞
			{ spellID =  55001, unitID = "player", caster = "all",    filter = "BUFF" },


			-- 饰品触发

			-- 暗月卡牌
			-- 骑士徽章                (爆击, 触发)
			{ spellID = 162917, unitID = "player", caster = "player", filter = "BUFF"},
			-- 战争之颅                (爆击, 触发)
			{ spellID = 162915, unitID = "player", caster = "player", filter = "BUFF"},
			-- 睡魔之袋                (爆击, 触发)
			{ spellID = 162919, unitID = "player", caster = "player", filter = "BUFF"},
			-- 羽翼沙漏                (精神, 触发)
			{ spellID = 162913, unitID = "player", caster = "player", filter = "BUFF"},

			-- PvP 饰品
			-- 全能
			{ spellID = 170397, unitID = "player", caster = "player", filter = "BUFF" },
			-- 生命上限
			{ spellID = 126697, unitID = "player", caster = "player", filter = "BUFF" },
			-- 敏捷
			{ spellID = 126690, unitID = "player", caster = "player", filter = "BUFF" },
			{ spellID = 126707, unitID = "player", caster = "player", filter = "BUFF" },
			-- 智力
			{ spellID = 126683, unitID = "player", caster = "player", filter = "BUFF" },
			{ spellID = 126705, unitID = "player", caster = "player", filter = "BUFF" },
			-- 力量
			{ spellID = 126679, unitID = "player", caster = "player", filter = "BUFF" },
			{ spellID = 126700, unitID = "player", caster = "player", filter = "BUFF" },

			-----------------------------橙戒特效--------------------------------------
			-- 大法师的灼热(690)
			-- 智力 
			{ spellID = 177159, unitID = "player", caster = "player", filter = "BUFF" },
			-- 力量 
			{ spellID = 177160, unitID = "player", caster = "player", filter = "BUFF" },
			-- 敏捷 
			{ spellID = 177161, unitID = "player", caster = "player", filter = "BUFF" },

			-- 大法师的炽燃(710)
			-- 智力 
			{ spellID = 177176, unitID = "player", caster = "player", filter = "BUFF" },
			-- 力量 
			{ spellID = 177175, unitID = "player", caster = "player", filter = "BUFF" },
			-- 敏捷 
			{ spellID = 177172, unitID = "player", caster = "player", filter = "BUFF" },			-- 坦克

			-------------------------------WOD-----------------------------------------
			-- 重击护符                (急速, 触发)
			{ spellID = 177102, unitID = "player", caster = "player", filter = "BUFF" },
			-- 爆裂熔炉之门            (精通, 触发)
			{ spellID = 177056, unitID = "player", caster = "player", filter = "BUFF" },
			-- 无懈合击石板            (护甲, 使用)
			{ spellID = 176873, unitID = "player", caster = "player", filter = "BUFF" },
			-- 不眠奥术精魂            (护甲, 触发)
			{ spellID = 177053, unitID = "player", caster = "player", filter = "BUFF" },
			-- 石化食肉孢子            (精通, 触发)
			{ spellID = 165824, unitID = "player", caster = "player", filter = "BUFF" },
			-- 普尔的盲目之眼          (精通, 使用)
			{ spellID = 176876, unitID = "player", caster = "player", filter = "BUFF" },
			-- 齐布的愚忠              (生命, 使用)
			{ spellID = 176460, unitID = "player", caster = "player", filter = "BUFF" },
			-- 岩心雕像                (爆击, 触发)
			{ spellID = 176982, unitID = "player", caster = "player", filter = "BUFF" },
			-------------------------------MOP-----------------------------------------
			-- 狂妄之诅咒              (爆击, 使用)
			--{ spellID =     , unitID = "player", caster = "player", filter = "BUFF" },
			-- 鲁克的不幸护符          (减伤, 使用)
			{ spellID = 146343, unitID = "player", caster = "player", filter = "BUFF" },
			-- 砮皂之毅                (躲闪, 使用)
			{ spellID = 146344, unitID = "player", caster = "player", filter = "BUFF" },
			-- 季鹍的复苏之风          (生命, 触发)
			{ spellID = 138973, unitID = "player", caster = "player", filter = "BUFF" },
			-- 赞达拉之韧              (生命, 使用)
			{ spellID = 126697, unitID = "player", caster = "player", filter = "BUFF" },
			-- 嗜血者的精致小瓶        (精通, 触发)
			{ spellID = 138864, unitID = "player", caster = "player", filter = "BUFF" },
			-- 影踪突袭营的坚定护符    (躲闪, 使用)
			{ spellID = 138728, unitID = "player", caster = "player", filter = "BUFF" },
			-- 梦魇残片                (躲闪, 触发)
			{ spellID = 126646, unitID = "player", caster = "player", filter = "BUFF" },
			-- 龙血之瓶                (躲闪, 触发)
			{ spellID = 126533, unitID = "player", caster = "player", filter = "BUFF" },
			-- 玉质军阀俑              (精通, 使用)
			{ spellID = 126597, unitID = "player", caster = "player", filter = "BUFF" },

			-- 物理敏捷DPS
			-------------------------------WOD-----------------------------------------
			-- 蜂鸣黑铁触发器          (爆击, 触发)
			{ spellID = 177067, unitID = "player", caster = "player", filter = "BUFF" },
			-- 跃动的山脉之心          (溅射, 使用)
			{ spellID = 176878, unitID = "player", caster = "player", filter = "BUFF" },
			-- 多肉龙脊奖章            (急速, 触发)
			{ spellID = 177035, unitID = "player", caster = "player", filter = "BUFF" },
			-- 毁灭之鳞                (溅射, 触发)
			{ spellID = 177038, unitID = "player", caster = "player", filter = "BUFF" },
			-- 双面幸运金币            (敏捷, 使用)
			{ spellID = 177597, unitID = "player", caster = "player", filter = "BUFF" },
			-- 黑心执行者勋章          (溅射, 触发)
			{ spellID = 176984, unitID = "player", caster = "player", filter = "BUFF" },
			-------------------------------MOP-----------------------------------------
			-- 既定之天命              (敏捷, 触发)
			{ spellID = 146308, unitID = "player", caster = "player", filter = "BUFF" },
			-- 哈洛姆的护符            (敏捷, 触发)
			{ spellID = 148903, unitID = "player", caster = "player", filter = "BUFF" },
			-- 暴怒之印                (敏捷, 触发)
			{ spellID = 148896, unitID = "player", caster = "player", filter = "BUFF" },
			-- 滴答作响的黑色雷管      (敏捷, 触发)
			{ spellID = 146310, unitID = "player", caster = "player", filter = "BUFF" },
			-- 雪怒之律                (爆击, 触发)
			{ spellID = 146312, unitID = "player", caster = "player", filter = "BUFF" },
			-- 邪恶魂能                (敏捷, 触发)
			{ spellID = 138938, unitID = "player", caster = "player", filter = "BUFF" },
			-- 杀戮护符                (急速, 触发)
			{ spellID = 138895, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 重生符文                (转换, 触发)
			{ spellID = 139120, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 139121, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			{ spellID = 139117, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 雷纳塔基的灵魂符咒      (敏捷, 触发)
			{ spellID = 138756, unitID = "player", caster = "player", filter = "BUFF" },
			-- 影踪突袭营的邪恶护符    (敏捷, 触发)
			{ spellID = 138699, unitID = "player", caster = "player", filter = "BUFF" },
			-- 飞箭奖章                (爆击, 使用)
			{ spellID = 136086, unitID = "player", caster = "player", filter = "BUFF" },
			-- 萦雾之恐                (爆击, 触发)
			{ spellID = 126649, unitID = "player", caster = "player", filter = "BUFF" },
			-- 玉质盗匪俑              (急速, 使用)
			{ spellID = 126599, unitID = "player", caster = "player", filter = "BUFF" },
			-- 群星之瓶                (敏捷, 触发)
			{ spellID = 126554, unitID = "player", caster = "player", filter = "BUFF" },

			-- 物理力量DPS
			-------------------------------WOD-----------------------------------------
			-- 熔炉主管的徽记          (爆击, 触发)
			{ spellID = 177096, unitID = "player", caster = "player", filter = "BUFF" },
			-- 尖啸之魂号角            (精通, 触发)
			{ spellID = 177042, unitID = "player", caster = "player", filter = "BUFF" },
			-- 抽搐暗影之瓶            (溅射, 使用)
			{ spellID = 176874, unitID = "player", caster = "player", filter = "BUFF" },
			-- 泰克图斯的脉动之心      (爆击, 触发)
			{ spellID = 177040, unitID = "player", caster = "player", filter = "BUFF" },
			-- 奇亚诺斯的剑鞘          (力量, 使用)
			{ spellID = 177189, unitID = "player", caster = "player", filter = "BUFF" },
			-- 活山之尘                (全能, 触发)
			{ spellID = 176974, unitID = "player", caster = "player", filter = "BUFF" },
			-------------------------------MOP-----------------------------------------
			-- 迦拉卡斯的邪恶之眼      (力量, 触发)
			{ spellID = 146245, unitID = "player", caster = "player", filter = "BUFF" },
			-- 索克的尾巴尖            (力量, 触发)
			{ spellID = 146250, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 斯基尔的沁血护符        (力量, 触发)
			{ spellID = 146285, unitID = "player", caster = "player", filter = "BUFF" },
			-- 融火之核                (力量, 触发)
			{ spellID = 148899, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 天神迅捷                (急速, 触发)
			{ spellID = 146296, unitID = "player", caster = "player", filter = "BUFF" },
			-- 季鹍的传说之羽          (力量, 触发)
			{ spellID = 138759, unitID = "player", caster = "player", filter = "BUFF" },
			-- 赞达拉之火              (力量, 触发)
			{ spellID = 138958, unitID = "player", caster = "player", filter = "BUFF" },
			-- 普莫迪斯的狂怒咒符      (力量, 触发)
			{ spellID = 138870, unitID = "player", caster = "player", filter = "BUFF" },
			-- 双后的凝视              (爆击, 触发)
			{ spellID = 139170, unitID = "player", caster = "player", filter = "BUFF" },
			-- 破盔者奖章              (爆击, 使用)
			{ spellID = 136084, unitID = "player", caster = "player", filter = "BUFF" },
			-- 影踪突袭营的野蛮护符    (力量, 触发)
			{ spellID = 138702, unitID = "player", caster = "player", filter = "BUFF" },
			-- 黑雾漩涡                (急速, 触发)
			{ spellID = 126657, unitID = "player", caster = "player", filter = "BUFF" },
			-- 雷神的遗诏              (力量, 触发)
			{ spellID = 126582, unitID = "player", caster = "player", filter = "BUFF" },
			-- 玉质御者俑              (力量, 使用)
			{ spellID = 126599, unitID = "player", caster = "player", filter = "BUFF" },
			-- 铁腹炒锅                (急速, 使用)
			{ spellID = 129812, unitID = "player", caster = "player", filter = "BUFF" },
			
			-- 法系DPS
			-------------------------------WOD-----------------------------------------
			-- 黑石微型坩埚            (爆击, 触发)
			{ spellID = 177081, unitID = "player", caster = "player", filter = "BUFF" },
			-- 达玛克的无常护符        (急速, 触发)
			{ spellID = 177051, unitID = "player", caster = "player", filter = "BUFF" },
			-- 鬣蜥人灵魂容器          (爆击, 触发)
			{ spellID = 177046, unitID = "player", caster = "player", filter = "BUFF" },
			-- 科普兰的清醒            (法强, 使用)
			{ spellID = 177594, unitID = "player", caster = "player", filter = "BUFF" },
			-- 虚无碎片                (急速 使用)
			{ spellID = 176875, unitID = "player", caster = "player", filter = "BUFF" },
			-- 狂怒之心                (急速, 触发)
			{ spellID = 176980, unitID = "player", caster = "player", filter = "BUFF" },
			-------------------------------MOP-----------------------------------------
			-- 伊墨苏斯的净化之缚      (智力, 触发)
			{ spellID = 146046, unitID = "player", caster = "player", filter = "BUFF" },
			-- 卡德里斯的剧毒图腾      (智力, 触发)
			{ spellID = 148906, unitID = "player", caster = "player", filter = "BUFF" },
			-- 亚煞极的黑暗之血        (智力, 触发)
			{ spellID = 146184, unitID = "player", caster = "player", filter = "BUFF" },
			-- 狂怒水晶                (智力, 触发)
			{ spellID = 148897, unitID = "player", caster = "player", filter = "BUFF" },
			-- 玉珑之噬                (爆击, 触发)
			{ spellID = 146218, unitID = "player", caster = "player", filter = "BUFF" },
			-- 雷神的精准之视          (智力, 触发)
			{spellID =  138963, unitID = "player", caster = "player", filter = "BUFF" },
			-- 张叶的辉煌精华          (智力, 触发)
			{ spellID = 139133, unitID = "player", caster = "player", filter = "BUFF" },
			-- 九头蛇之息              (智力, 触发)
			{ spellID = 138898, unitID = "player", caster = "player", filter = "BUFF" },
			-- 乌苏雷的最终抉择        (智力, 触发)
			{ spellID = 138786, unitID = "player", caster = "player", filter = "BUFF" },
			-- 影踪突袭营的烈性咒符    (急速, 触发)
			{ spellID = 138703, unitID = "player", caster = "player", filter = "BUFF" },
			-- 惊怖精华                (急速, 触发)
			{ spellID = 126659, unitID = "player", caster = "player", filter = "BUFF" },
			-- 宇宙之光                (智力, 触发)
			{ spellID = 126577, unitID = "player", caster = "player", filter = "BUFF" },
			
			-- 治疗
			-------------------------------WOD-----------------------------------------
			-- 自动修复灭菌器          (急速, 触发)
			{ spellID = 177086, unitID = "player", caster = "player", filter = "BUFF" },
			-- 铁刺狗玩具              (精神, 触发)
			{ spellID = 177060, unitID = "player", caster = "player", filter = "BUFF" },
			-- 元素师的屏蔽护符        (溅射, 触发)
			{ spellID = 177063, unitID = "player", caster = "player", filter = "BUFF" },
			-- 腐蚀治疗徽章            (急速, 使用)
			{ spellID = 176879, unitID = "player", caster = "player", filter = "BUFF" },
			-- 完美的活性蘑菇          (爆击, 触发)
			{ spellID = 176978, unitID = "player", caster = "player", filter = "BUFF" },
			-- 永燃蜡烛                (法力, 使用)
			{ spellID = 177592, unitID = "player", caster = "player", filter = "BUFF" },
			-------------------------------MOP-----------------------------------------
			-- 傲慢之棱光囚笼          (智力, 触发)
			{ spellID = 146314, unitID = "player", caster = "player", filter = "BUFF" },
			-- 纳兹戈林的抛光勋章      (智力, 触发)
			{ spellID = 148908, unitID = "player", caster = "player", filter = "BUFF" },
			-- 索克的酸蚀之牙          (智力, 触发)
			{ spellID = 148911, unitID = "player", caster = "player", filter = "BUFF" },
			-- 间歇性变异平衡器        (精神,触发)
			{ spellID = 146317, unitID = "player", caster = "player", filter = "BUFF" },
			-- 九头蛇卵的铭文袋        (吸收,触发)
			{ spellID = 140380, unitID = "player", caster = "player", filter = "BUFF" },
			-- 赫利东的垂死之息        (法力,触发)
			{ spellID = 138856, unitID = "player", caster = "player", filter = "BUFF" },
			-- 骄阳之魂                (精神,触发)
			{ spellID = 126640, unitID = "player", caster = "player", filter = "BUFF" },
			-- 秦希的偏振之印          (智力, 触发)
			{ spellID = 126588, unitID = "player", caster = "player", filter = "BUFF" },
		},
		{ 
			Name = "玩家重要Buff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 5,
			Alpha = 1,
			IconSize = 40,
			Position = {unpack(FG["filger_position"].imbuff)},

			-- 英勇
			{ spellID =  80353, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 嗜血
			{ spellID =   2825, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 时间扭曲
			{ spellID =  32182, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 上古狂乱(熔火犬)
			{ spellID =  90355, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 虛空之风(虚空鳐)
			{ spellID = 160452, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 暴怒之鼓(25%)
			{ spellID = 146555, unitID = "player", caster = "all",    filter = "BUFF"},

			-- 种族
			-- 狂暴 
			{ spellID =  26297, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- 石像形态 
			{ spellID =  65116, unitID = "player", caster = "player", filter = "BUFF"},
			-- 血性狂怒 
			{ spellID =  20572, unitID = "player", caster = "player", filter = "BUFF"},
			-- 疾步夜行 
			{ spellID =  68992, unitID = "player", caster = "player", filter = "BUFF"},
			-- 纳鲁的赐福 
			{ spellID =  28880, unitID = "player", caster = "all",    filter = "BUFF"},

			-- Other
			-- 保护之手
			{ spellID =   1022, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 自由之手
			{ spellID =   1044, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 牺牲之手
			{ spellID =   6940, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 纯净之手
			{ spellID = 114039, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 拯救之手
			{ spellID =   1038, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 虔诚光环
			{ spellID =  31821, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 光明之泉恢复
			{ spellID =   7001, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 漂浮术
			{ spellID =   1706, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 身心合一
			{ spellID =  65081, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 天堂之羽
			{ spellID = 121557, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 防护恐惧结界
			{ spellID =   6346, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 吸血鬼的拥抱
			{ spellID =  15286, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 真言术：障
			{ spellID =  81782, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 神圣赞美诗
			{ spellID =  64844, unitID = "player", caster = "all",    filter = "BUFF", absID = true}, 
			{ spellID =  64843, unitID = "player", caster = "all",    filter = "BUFF", absID = true}, 
			-- 守护之魂
			{ spellID =  47788, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 痛苦压制
			{ spellID =  33206, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 铁木树皮
			{ spellID = 102342, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 宁静
			{ spellID =    740, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 警戒
			{ spellID = 114030, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 狂奔怒吼
			{ spellID = 106898, unitID = "player", caster = "all",    filter = "BUFF", absID = true},
			{ spellID =  77764, unitID = "player", caster = "all",    filter = "BUFF", absID = true},
			-- 根基图腾效果
			{ spellID =   8178, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 灵魂链接图腾
			{ spellID =  98007, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 风行图腾
			{ spellID = 114896, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 作茧缚命
			{ spellID = 116849, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 禅悟冥想
			{ spellID = 115176, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 迅如猛虎
			{ spellID = 116841, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 集结呐喊
			{ spellID =  97463, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 群体反射
			{ spellID = 114028, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 潜伏帷幕
			{ spellID = 114018, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 烟雾弹
			{ spellID =  88611, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 缓落术
			{ spellID =    130, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 魔法增益
			{ spellID = 159916, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 反魔法领域
			{ spellID =  50461, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 灵狐守护
			{ spellID = 172106, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 豹群守护
			{ spellID =  13159, unitID = "player", caster = "all",    filter = "BUFF"},

			-- 鲜血充能
			{ spellID = 114851, unitID = "player", caster = "player", filter = "BUFF"},
			-- 爆燃冲刺
			{ spellID = 111400, unitID = "player", caster = "player", filter = "BUFF"},
			-- 地狱烈焰
			{ spellID =   1949, unitID = "player", caster = "player", filter = "BUFF"},
			-- 蒸馏：虎眼酒
			{ spellID = 125195, unitID = "player", caster = "player", filter = "BUFF"},
			-- 飘渺酒
			{ spellID = 128939, unitID = "player", caster = "player", filter = "BUFF"},
			-- 法力茶
			{ spellID = 115867, unitID = "player", caster = "player", filter = "BUFF"},

			-- 轻度醉拳
			{ spellID = 124275, unitID = "player", caster = "all",  filter = "DEBUFF"},
			-- 中度醉拳
			{ spellID = 124274, unitID = "player", caster = "all",  filter = "DEBUFF"},
			-- 重度醉拳
			{ spellID = 124273, unitID = "player", caster = "all",  filter = "DEBUFF"},
			-- 火箭鞋漏油
			{ spellID =94794, unitID = "player", caster = "player", filter = "DEBUFF"},
		},
		{ 
			Name = "玩家PVPDebuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 5,
			Alpha = 1,
			IconSize = 40,
			Position = {unpack(FG["filger_position"].pvpdebuff)},

			-- 死亡骑士
			-- 撕扯
			{ spellID =  91800, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 蛮兽打击
			{ spellID =  91797, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 窒息
			{ spellID = 108194, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冷酷严冬
			{ spellID = 115001, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- 绞袭
			{ spellID =  47476, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 黑暗模拟
			{ spellID =  77606, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 寒冰锁链
			{ spellID =  45524, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冻疮
			{ spellID =  50435, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 德鲁伊
			-- 旋风
			{ spellID =  33786, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 蛮力猛击
			{ spellID =   5211, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 割碎
			{ spellID = 163505, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- 割碎
			{ spellID =  22570, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 惊魂咆哮
			{ spellID =     99, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 日光术
			{ spellID =  78675, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 精灵沉默
			{ spellID = 114238, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 纠缠根须
			{ spellID =    339, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 无法移动
			{ spellID =  45334, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 感染伤口
			{ spellID =  58180, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 猎人
			-- 胁迫
			{ spellID =  24394, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 束缚射击
			{ spellID = 117526, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- 冰冻陷阱
			{ spellID =   3355, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 翼龙钉刺
			{ spellID =  19386, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 险境求生
			{ spellID = 136634, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 震荡射击
			{ spellID =   5116, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰霜陷阱
			{ spellID =  61394, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 诱捕
			{ spellID = 135373, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- 虚空震击 (虚空鳐)
			{ spellID =  44957, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰霜吐息 (奇美拉)
			{ spellID =  54644, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 碎踝 (鳄魚)
			{ spellID =  50433, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 时间扭曲 
			{ spellID =  35346, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 音爆 (蝙蝠)
			{ spellID =  50519, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰冻术
			{ spellID =  33395, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 法师
			-- 深度冻结
			{ spellID =  44572, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 变形术
			{ spellID =    118, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰霜之环
			{ spellID =  82691, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 龙息术
			{ spellID =  31661, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰霜之颌
			{ spellID = 102051, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰霜新星
			{ spellID =    122, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 寒冰结界
			{ spellID = 111340, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰锥术
			{ spellID =    120, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 减速
			{ spellID =  31589, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 寒冰箭
			{ spellID =    116, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 霜火箭
			{ spellID =  44614, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰冻
			{ spellID =   7321, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 武僧
			-- 分筋错骨
			{ spellID = 115078, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 扫堂腿
			{ spellID = 119381, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 怒雷破
			{ spellID = 120086, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 蛮牛冲
			{ spellID = 119392, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 金刚震
			{ spellID = 116706, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},

			-- 圣骑士
			-- 制裁之锤
			{ spellID =    853, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 制裁之拳
			{ spellID = 105593, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 忏悔
			{ spellID =  20066, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 盲目之光
			{ spellID = 105421, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 复仇者之盾
			{ spellID =  31935, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 眩晕—之盾(雕纹)
			{ spellID =  63529, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 公正圣印
			{ spellID =  20170, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 罪孽如山
			{ spellID = 110300, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 谴责
			{ spellID =   2812, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 牧师
			-- 统御意志
			{ spellID =    605, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 心灵尖啸
			{ spellID =   8122, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 心灵惊骇
			{ spellID =  64044, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 罪与罚
			{ spellID =  87204, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 沉默
			{ spellID =  15487, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 虚空触须
			{ spellID = 114404, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 心灵震爆雕文
			{ spellID =  87194, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 盗贼
			-- 肾击
			{ spellID =    408, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 偷袭
			{ spellID =   1833, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 闷棍
			{ spellID =   6770, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 致盲
			{ spellID =   2094, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 凿击
			{ spellID =   1776, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 锁喉 - 沉默
			{ spellID =   1330, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 致命投掷
			{ spellID =  26679, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 减速药膏
			{ spellID =   3409, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 萨满
			-- 妖术
			{ spellID =  51514, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 静电充能
			{ spellID = 118905, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 粉碎
			{ spellID = 118345, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 地震术
			{ spellID =  77505, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 陷地
			{ spellID =  64695, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 地缚术
			{ spellID =   3600, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰霜震击
			{ spellID =   8056, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰冻
			{ spellID =   8056, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 雷霆风暴
			{ spellID =  63685, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 术士
			-- 暗影之怒
			{ spellID =  30283, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 巨斧投掷 (恶魔守卫)
			{ spellID =  89766, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 恐惧
			{ spellID = 118699, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 恐惧嚎叫
			{ spellID =   5484, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 鲜血恐惧
			{ spellID = 137143, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 死亡缠绕
			{ spellID =   6789, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 诱惑 (魅魔)
			{ spellID =   6358, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 迷魅 
			{ spellID = 115268, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 痛苦无常
			{ spellID =  31117, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- 燃烧
			{ spellID =  17962, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 暗影烈焰
			{ spellID =  47960, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 战士
			-- 风暴之锤
			{ spellID = 132169, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- 震荡波
			{ spellID = 132168, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 战神
			{ spellID = 105771, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 错愕怒吼
			{ spellID = 107566, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 破胆怒吼
			{ spellID =   5246, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 断筋
			{ spellID =   1715, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 刺耳怒吼
			{ spellID =  12323, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 巨人打击
			{ spellID =  86346, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冲锋昏迷
			{ spellID =   7922, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 种族天赋
			-- 战争践踏
			{ spellID =  20549, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 震山掌
			{ spellID = 107079, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 奥术洪流
			{ spellID =  28730, unitID = "player", caster = "all", filter = "DEBUFF" },
		},
		{ 
			Name = "玩家Debuff",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 5,
			Alpha = 1,
			IconSize = 40,
			Position = {unpack(FG["filger_position"].alldebuff)},


			-- 心智 [尤格萨隆]
			{ spellID =  63050, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- DS
			-- Morchok
			-- (擊碎護甲)
			{ spellID = 103687, unitID = "player", caster = "all", filter = "DEBUFF" }, 
			-- Zon'ozz
			-- (崩解之影)
			{ spellID = 103434, unitID = "player", caster = "all", filter = "DEBUFF" }, 
			-- Yor'sahj
			-- (深度腐化)
			{ spellID = 105171, unitID = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 103628, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 虛無箭)
			{ spellID = 104849, unitID = "player", caster = "all", filter = "DEBUFF" },  
			-- Hagara
			-- (寒冰之墓)
			{ spellID = 104451, unitID = "player", caster = "all", filter = "DEBUFF" },  
			-- Blackhorn
			-- (破甲攻擊)
			{ spellID = 108043, unitID = "player", caster = "all", filter = "DEBUFF" },  
			-- Spine
			-- 燃燒血漿
			{ spellID = 105479, unitID = "player", caster = "all", filter = "DEBUFF" }, 
			-- (燃燒血漿)
			{ spellID = 109379, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- (熾熱之握)
			{ spellID = 105490, unitID = "player", caster = "all", filter = "DEBUFF" },  
			-- Madness 
			-- (退化咬擊)
			{ spellID = 105841, unitID = "player", caster = "all", filter = "DEBUFF" }, 
			-- (極熾高熱) 
			{ spellID = 105445, unitID = "player", caster = "all", filter = "DEBUFF" }, 
			-- (刺穿) 
			{ spellID = 106444, unitID = "player", caster = "all", filter = "DEBUFF" },  
			-- 凋零之光
			{ spellID = 105925, unitID = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 109075, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 寄生体
			{ spellID = 108601, unitID = "player", caster = "all", filter = "DEBUFF" },



			------------------------------------MOP----------------------------------
			-- 魔古山宝库 896
			
			-- [石头守卫]
			-- 紫晶之池
			{ spellID = 116235, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 红玉锁链
			{ spellID = 130395, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- [受诅者魔封]
			--  野性火花
			{ spellID = 116784, unitID = "player", caster = "all", filter = "DEBUFF"},
			--  奥术回响
			{ spellID = 116417, unitID = "player", caster = "all", filter = "DEBUFF"},
			--  废灵壁垒
			{ spellID = 115856, unitID = "player", caster = "all", filter = "BUFF"  },
			--  反射罩
			{ spellID = 115911, unitID = "player", caster = "all", filter = "BUFF"  },
			
			--  [缚灵者戈拉亚]
			--  巫毒娃娃
			{ spellID = 122151, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 灵魂越界
			{ spellID = 116166, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- [伊拉贡]
			-- 能量超载
			{ spellID = 117878, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 封闭回路
			{ spellID = 117949, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- [皇帝的意志]
			-- 专注打击
			{ spellID = 116525, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 专注能量
			{ spellID = 116829, unitID = "player", caster = "all", filter = "DEBUFF"},



			-- 恐惧之心 897
			
			-- 1	[皇家宰相佐尔洛克]
			--  吐气
			{ spellID = 122761, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 2	[刀锋领主塔亚克]
			-- 压制突袭
			{ spellID = 123474, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 疾风步
			{ spellID = 123175, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 无影击
			{ spellID = 123017, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 3	[加拉隆]
			-- 信息素
			{ spellID = 123092, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 4	[风领主梅尔加拉克]
			-- 风爆弹
			{ spellID = 131813, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 琥珀监牢
			{ spellID = 121885, unitID = "player", caster = "all", filter = "DEBUFF"}, 
			-- 腐蚀树脂
			{ spellID = 122064, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 5	[琥珀塑形者昂舒克]
			-- 燃烧的琥珀
			{ spellID = 122504, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 寄生增长
			{ spellID = 121949, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 6	[大女皇夏柯希尔]
			--  女皇邪眼
			{ spellID = 123707, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 粘稠树脂
			{ spellID = 124097, unitID = "player", caster = "all", filter = "DEBUFF"},
			--  浸毒护甲
			{ spellID = 124821, unitID = "player", caster = "all", filter = "DEBUFF"},
			--  恐惧吞噬
			{ spellID = 124849, unitID = "player", caster = "all", filter = "DEBUFF"},
			--  死亡幻像
			{ spellID = 124862, unitID = "player", caster = "all", filter = "DEBUFF"},
			--  恐惧之心
			{ spellID = 123845, unitID = "player", caster = "all", filter = "DEBUFF"},



			-- 永春台 886
			
			-- 1	[无尽守护者]
			--  闪电牢笼
			{ spellID = 111850, unitID = "player", caster = "all", filter = "DEBUFF"},
			--  大地污染
			{ spellID = 117986, unitID = "player", caster = "all", filter = "DEBUFF"},
			--  大型堕落精华
			{ spellID = 117905, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 2	[烛龙]
			--  恐惧之影
			{ spellID = 122768, unitID = "player", caster = "all", filter = "DEBUFF"},
			--  暗影吐息
			{ spellID = 122752, unitID = "player", caster = "all", filter = "DEBUFF"},
			--  暗影恐怖
			{ spellID = 123011, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 3	[雷施]
			--  喷射
			{ spellID = 123121, unitID = "player", caster = "all", filter = "DEBUFF"},
			--  恐怖迷雾
			{ spellID = 123705, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 4	[惧之煞]
			--  无畏
			{ spellID = 118977, unitID = "player", caster = "all", filter = "BUFF"  },


			-- 雷电王座 930
			
			-- 1	[击碎者金罗克] --
			-- 专注闪电
			{ spellID = 137422, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 电离反应
			{ spellID = 138732, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 静电创伤
			{ spellID = 138349, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 雷霆投掷
			{ spellID = 137371, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 2	[郝利东] --
			-- 三重穿刺
			{ spellID = 136767, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 冲锋
			{ spellID = 136769, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 流沙陷阱
			{ spellID = 136723, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 活化毒素
			{ spellID = 136646, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 寒冰宝珠
			{ spellID = 136573, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 闪电新星
			{ spellID = 136490, unitID = "player", caster = "all", filter = "DEBUFF"},
         
			-- 3	[长者议会] --
			-- 灵魂残片
			{ spellID = 137641, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- M标记灵魂
			{ spellID = 137359, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 扭曲命运
			{ spellID = 137972, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 冰寒突击
			{ spellID = 136903, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 霜寒刺骨
			{ spellID = 136922, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 刺骨之寒
			{ spellID = 136992, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 4	[托多斯] --
			-- 百裂爪
			{ spellID = 136753, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 晶化甲壳
			{ spellID = 137633, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 晶化甲壳：临界值！
			{ spellID = 140701, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 5	[墨格瑞拉]
			-- 燃烧血肉
			{ spellID = 137731, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 寒冰洪流
			{ spellID = 139857, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 139889, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 燃烬
			{ spellID = 134391, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 139822, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 6	[季鹍] --
			-- 爪掠
			{ spellID = 134366, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 灵巧之翼
			{ spellID = 134339, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 7	[遗忘者杜鲁姆] --
			-- 严重致伤
			{ spellID = 133767, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 蓝光追踪
			{ spellID = 139202, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 红光追踪
			{ spellID = 139204, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 强光
			{ spellID = 133738, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 纠缠凝视
			{ spellID = 134044, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 吸血
			{ spellID = 133795, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 8	[普利莫修斯] --
			{ spellID = 136050, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 9	[黑暗意志] --
			-- 爆炸猛击
			{ spellID = 138569, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 猩红追击
			{ spellID = 138480, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 心能之环
			{ spellID = 136954, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 物质交换
			{ spellID = 138618, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 10	[铁穹] --
			-- 穿刺
			{ spellID = 134691, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 烧灼
			{ spellID = 134647, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 11	[魔古双后] --
			-- 寒冷阴影
			{ spellID = 137440, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 烈焰刃舞
			{ spellID = 137408, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 堕落治疗
			{ spellID = 137360, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 梦魇兽
			{ spellID = 137375, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 12	[雷神] --
			-- 斩首
			{ spellID = 135000, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 静电冲击
			{ spellID = 135695, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 超载
			{ spellID = 136295, unitID = "player", caster = "all", filter = "DEBUFF"},



			-- 决战奥格瑞玛 Siege Of Orgrimmar 953

			-- 1	伊墨苏斯 [Immerseus]
			-- 邪煞池
			{ spellID = 143297, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 腐蚀冲击
			{ spellID = 143436, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 煞能腐蚀
			{ spellID = 143579, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 2	堕落的守护者 [FallenProtectors]
			-- 锁喉
			{ spellID = 143198, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 苦痛印记
			{ spellID = 143840, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 暗影虚弱
			{ spellID = 144176, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 煞能灼烧
			{ spellID = 143423, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 3	诺鲁什 [Norushen]
			-- 净化
			{ spellID = 144452, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 自惑
			{ spellID = 146124, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 纠缠腐蚀
			{ spellID = 144514, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 4	傲之煞 [ShaofPride]
			-- 受损自尊
			{ spellID = 144358, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 傲气光环
			{ spellID = 146817, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 投影
			{ spellID = 146822, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 泰坦之赐
			{ spellID = 146594, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 泰坦之力
			{ spellID = 144364, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 动摇的决心 H
			{ spellID = 147207, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 5	迦拉卡斯 [Galakras]
			-- 毒性云雾
			{ spellID = 147705, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 烈焰箭
			{ spellID = 146765, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 迦拉克隆之焰 (点名)
			{ spellID = 147068, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 迦拉克隆之焰 (debuff)
			{ spellID = 147029, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 6	钢铁战蝎 [IronJuggernaut]
			-- 燃烧护甲
			{ spellID = 144467, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 爆裂焦油
			{ spellID = 144498, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 切割激光
			{ spellID = 146325, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 7	库卡隆黑暗萨满 [KorkronDarkShaman]
			-- 冰霜风暴打击
			{ spellID = 144215, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 撕裂
			{ spellID = 144304, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 剧毒之雾
			{ spellID = 144089, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 钢铁囚笼 
			{ spellID = 144330, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 8	纳兹戈林将军 [GeneralNazgrim]
			-- 碎甲重击
			{ spellID = 143494, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 碎骨重锤
			{ spellID = 143638, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 刺客印记
			{ spellID = 143480, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 猎人印记
			{ spellID = 143882, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 9	马尔考罗克 [Malkorok]
			-- 致命打击
			{ spellID = 142990, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 10	潘达利亚战利品 [SpoilsOfPandria]
			-- 设置炸药
			{ spellID = 145987, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 11	嗜血的索克 [ThokTheBloodthirsty]
			-- 恐慌
			{ spellID = 143766, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 灼热吐息
			{ spellID = 143767, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 酸性吐息
			{ spellID = 143780, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 冰冻吐息
			{ spellID = 143773, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 锁定
			{ spellID = 143445, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 冰冻之血
			{ spellID = 143800, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 12	攻城匠师黑索 [SiegecrafterBlackfuse]
			-- 电荷冲击
			{ spellID = 143385, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 过热
			{ spellID = 143856, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 图像识别
			{ spellID = 144236, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 13	卡拉克西英杰 [ParagonsOfTheKlaxxi]
			-- 注射
			{ spellID = 143339, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 红色毒素
			{ spellID = 142533, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 蓝色毒素
			{ spellID = 142532, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 黄色毒素
			{ spellID = 142534, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 凿击
			{ spellID = 143939, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 盾击
			{ spellID = 143974, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 催眠术
			{ spellID = 142671, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 瞄准
			{ spellID = 142948, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 炎界的火线
			{ spellID = 142808, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 14	加尔鲁什·地狱咆哮 [GarroshHellscream]
			-- 绝望之握
			{ spellID = 145183, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 强化绝望之握
			{ spellID = 145195, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 绝望之破
			{ spellID = 145213, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 信念
			{ spellID = 148994, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 勇气
			{ spellID = 148983, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 希望
			{ spellID = 149004, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 亵渎(P2)
			{ spellID = 144762, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 亵渎(P3)
			{ spellID = 144817, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 亚煞极之触
			{ spellID = 145065, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 強化亚煞极之触
			{ spellID = 145171, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 凝视 H
			{ spellID = 147665, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 液态火焰 H
			{ spellID = 147136, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 恶意 H
			{ spellID = 147209, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 恶意冲击 H
			{ spellID = 147235, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 15	其它 [SooTrash]
			-- 断骨
			{ spellID = 147200, unitID = "player", caster = "all", filter = "DEBUFF"},



			----------------------------------WOD------------------------------------
			--  [970]  悬槌堡
			-- 0	小怪
			-- 污染之爪
			{ spellID = 175601, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 剧毒辐射
			{ spellID = 172069, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 毁灭符文
			{ spellID =  56037, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 瓦解符文
			{ spellID = 175654, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 冰冻核心
			{ spellID = 174404, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 野火
			{ spellID = 173827, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 熔火炸弹
			{ spellID = 161635, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 1	卡加斯.刃拳
			-- 烈焰喷射
			{ spellID = 159311, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 抓钩
			{ spellID = 159188, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 狂暴冲锋
			{ spellID = 158986, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 钢铁炸弹
			{ spellID = 159386, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 迸裂创伤 (仅坦克)
			{ spellID = 159178, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 穿刺 (DoT)
			{ spellID = 159113, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 锁链投掷
			{ spellID = 159947, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 暴虐酒
			{ spellID = 159413, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪恶吐息
			{ spellID = 160521, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 搜寻猎物
			{ spellID = 162497, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 2	屠夫
			-- 捶肉槌
			{ spellID = 156151, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 龟裂创伤
			{ spellID = 156152, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 切肉刀
			{ spellID = 156143, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 白鬼硫酸
			{ spellID = 163046, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 3	泰克图斯
			-- 晶化弹幕
			{ spellID = 162346, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 162370, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 石化
			{ spellID = 162892, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 4	布兰肯斯波
			-- 感染孢子
			{ spellID = 163242, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 蚀脑真菌
			{ spellID = 160179, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 死疽吐息
			{ spellID = 159220, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 脉冲高热
			{ spellID = 163666, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 溃烂
			{ spellID = 163241, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 滑溜溜的苔藓
			{ spellID = 163590, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 5	独眼魔双子
			-- 致衰咆哮
			{ spellID = 158026, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 防御削弱
			{ spellID = 159709, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 受伤
			{ spellID = 155569, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 烈焰
			{ spellID = 158241, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 奥能动荡
			{ spellID = 163372, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 奥术之伤
			{ spellID = 167200, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 6	克拉戈
			-- 腐蚀能量
			{ spellID = 161242, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 压制力场
			{ spellID = 161345, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 魔能散射:冰霜
			{ spellID = 172813, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 魔能散射:暗影
			{ spellID = 162184, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 魔能散射:火焰
			{ spellID = 162185, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 魔能散射:奥术
			{ spellID = 162186, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 魔能散射:邪能
			{ spellID = 172895, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 172917, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 统御之力
			{ spellID = 163472, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 废灵标记
			{ spellID = 172886, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 废灵壁垒
			{ spellID = 163134, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 7	元首马尔高克
			-- 混沌标记
			{ spellID = 158605, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 混沌标记:偏移
			{ spellID = 164176, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 混沌标记:强固
			{ spellID = 164178, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 混沌标记:复制
			{ spellID = 164191, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 拘禁
			{ spellID = 158619, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 碾碎护甲
			{ spellID = 158553, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 锁定
			{ spellID = 157763, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 减速
			{ spellID = 157801, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 毁灭共鸣
			{ spellID = 159200, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 174106, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 烙印
			{ spellID = 156225, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 烙印:偏移
			{ spellID = 164004, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 烙印:强固
			{ spellID = 164005, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 烙印:复制
			{ spellID = 164006, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 蔓延暗影(M)
			{ spellID = 176533, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 深渊凝视(M)
			{ spellID = 176537, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 深渊凝视(爆炸)(M)
			{ spellID = 165595, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 无尽黑暗制(M)
			{ spellID = 165102, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 熵能冲击(M)
			{ spellID = 165116, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- [988] 黑石铸造厂
			-- 1	Gruul 格鲁尔
			-- 炼狱切割
			{ spellID = 155080, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 压迫打击
			{ spellID = 155078, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 炼狱打击
			{ spellID = 162322, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 石化
			{ spellID = 155506, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 火耀石
			{ spellID = 165298, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 2	Oregorger 奥尔高格
			-- 呕吐黑石
			{ spellID = 156203, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 爆裂残片
			{ spellID = 156374, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 酸液洪流
			{ spellID = 156297, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 酸液巨口
			{ spellID = 173471, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 翻滚之怒
			{ spellID = 155900, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 3	Blast Furnace 爆裂熔炉
			-- 崩裂
			{ spellID = 156932, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 炸弹
			{ spellID = 178279, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 155192, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 174176, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 不稳定的火焰
			{ spellID = 176121, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 锁定
			{ spellID = 155196, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 熔渣池
			{ spellID = 155743, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 淬火
			{ spellID = 155240, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 高热
			{ spellID = 155242, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 熔化
			{ spellID = 155225, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 155223, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 4	Hans'gar and Franzok 汉斯加尔与弗兰佐克 
			-- 折脊碎椎
			{ spellID = 157139, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 干扰怒吼
			{ spellID = 160838, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 160845, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 160847, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 160848, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 灼热燃烧
			{ spellID = 155818, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 5	Flamebender Ka'graz 缚火者卡格拉兹 
			-- 锁定
			{ spellID = 154952, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 焦灼吐息
			{ spellID = 155074, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 火焰链接
			{ spellID = 155049, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 熔岩激流
			{ spellID = 154932, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 炽热光辉
			{ spellID = 155277, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 岩浆猛击
			{ spellID = 155314, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 升腾烈焰
			{ spellID = 163284, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 6	Kromog 克罗莫格 
			-- 扭曲护甲
			{ spellID = 156766, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 纠缠之地符文
			{ spellID = 157059, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 破碎大地符文
			{ spellID = 161839, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 161923, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 7	Beastlord Darmac 兽王达玛克
			-- 长矛钉刺
			{ spellID = 154960, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 狂乱撕扯
			{ spellID = 155061, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 162283, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 炼狱吐息
			{ spellID = 154989, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 爆燃
			{ spellID = 154981, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 炽燃利齿
			{ spellID = 155030, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 碾碎护甲
			{ spellID = 155236, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 高热弹片
			{ spellID = 155499, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 烈焰灌注
			{ spellID = 155657, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 地动山摇
			{ spellID = 159044, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 162277, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 8	Operator Thogar 主管索戈尔 
			-- 点燃
			{ spellID = 155921, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 实验型脉冲手雷
			{ spellID = 165195, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 灼疗之箭
			{ spellID = 160140, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 锯齿劈斩
			{ spellID = 155921, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 熔岩震击
			{ spellID = 156310, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 延时攻城炸弹
			{ spellID = 159481, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 燃烧
			{ spellID = 164380, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 热能冲击
			{ spellID = 164280, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 9	Iron Maidens 钢铁女武神 
			-- 急速射击
			{ spellID = 156631, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 穿透射击
			{ spellID = 164271, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 主炮轰击
			{ spellID = 158601, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 震颤暗影
			{ spellID = 156214, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 暗影猎杀
			{ spellID = 158315, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 鲜血仪式
			{ spellID = 159724, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 浸血觅心者
			{ spellID = 158010, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 致命投掷
			{ spellID = 158692, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 锁定
			{ spellID = 158702, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 堕落之血
			{ spellID = 158683, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 玛拉卡的血腥召唤
			{ spellID = 170405, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 苏卡的猎物
			{ spellID = 170395, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- 10	Warlord Blackhand  黑手 
			-- 死亡标记
			{ spellID = 156096, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 锁定
			{ spellID = 156653, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 断骨
			{ spellID = 157354, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 熔渣冲击
			{ spellID = 156047, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 157018, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 157322, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 穿刺
			{ spellID = 156743, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 175020, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 巨力粉碎猛击
			{ spellID = 158054, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 燃烧
			{ spellID = 162490, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 156604, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 熔火熔渣
			{ spellID = 156401, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 烧伤
			{ spellID = 156404, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 燃烧射击
			{ spellID = 156772, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 投掷炉渣炸弹
			{ spellID = 157000, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 159179, unitID = "player", caster = "all", filter = "DEBUFF"},
		},
	},
}
