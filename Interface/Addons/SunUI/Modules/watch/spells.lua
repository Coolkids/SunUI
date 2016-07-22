----------------------------------------------------------------------------------------------------
-- name = "目标debuff",
-- setpoint = { "LEFT", UIParent, "CENTER", 198, -190 },
-- direction = "UP",
-- iconSide = "LEFT",
-- mode = "BAR", 
-- size = 24,
-- barWidth = 200,				
--	{spellID = 8050, unitId = "target", caster = "target", filter = "DEBUFF"},
--	{ spellID = 18499, filter = "CD" },
--	{ itemID = 56285, filter = "CD" },
---------------------------------------------------------------------------------------------------
local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local FG = S:GetModule("Filger")
local _, ns = ...

FG["filger_position"] = {
	targetdebuff = {"BOTTOM", UIParent, "BOTTOM",  227,  335},	-- "目标debuff"
	playerbuff   = {"BOTTOM", UIParent, "BOTTOM", -227,  335},	-- "玩家buff
	playercd     = {"BOTTOM", UIParent, "BOTTOM", -227,  405},	-- "玩家技能CD"
	enbuff       = {"BOTTOM", UIParent, "BOTTOM", -227,  370},	-- "玩家饰品附魔触发buff"
	alldebuff    = {"TOP",    UIParent, "TOP",     200, -157},	-- "玩家Debuff"
	imbuff       = {"TOP",    UIParent, "TOP",     200, -203},	-- "玩家重要Buff"
	pvpdebuff    = {"TOP",    UIParent, "TOP",     200, -249},	-- "玩家PVPDebuff"
}

ns.watchers ={
	["DEMONHUNTER"] = { 		--[恶魔猎手DH]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",
			-- 痛苦使者
			{ spellID =  212988, unitID = "player", caster = "player", filter = "BUFF" },
			-- 贪吃魔
			{ spellID =  227330, unitID = "player", caster = "player", filter = "BUFF" },
			-- 献祭光环
			{ spellID =  178740, unitID = "player", caster = "player", filter = "BUFF" },
			-- 灵魂盛宴
			{ spellID =  207693, unitID = "player", caster = "player", filter = "BUFF" },
			-- 强化结界
			{ spellID =  218256, unitID = "player", caster = "player", filter = "BUFF" },
			-- 黑暗
			{ spellID =  209426, unitID = "player", caster = "player", filter = "BUFF" },
			-- 恶魔变形
			{ spellID =  187827, unitID = "player", caster = "player", filter = "BUFF" },
			-- 恶魔尖刺
			{ spellID =  203819, unitID = "player", caster = "player", filter = "BUFF" },
			-- 灵魂壁障
			{ spellID =  227225, unitID = "player", caster = "player", filter = "BUFF" },
			-- 灵魂残片
			{ spellID =  203981, unitID = "player", caster = "player", filter = "BUFF" },

			-- 疾影
			{ spellID =  212800, unitID = "player", caster = "player", filter = "BUFF" },
			-- 混乱之刃
			{ spellID =  211048, unitID = "player", caster = "player", filter = "BUFF" },
			-- 虚空行走
			{ spellID =  196555, unitID = "player", caster = "player", filter = "BUFF" },
			-- 准备就绪
			{ spellID =  203650, unitID = "player", caster = "player", filter = "BUFF" },
			-- 势如破竹
			{ spellID =  208628, unitID = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",

			-- 烈火烙印
			{ spellID = 207744, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 猛烈的死亡
			{ spellID = 212818, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 脆弱
			{ spellID = 224509, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 烈焰咒符
			{ spellID = 204598, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 沉默咒符
			{ spellID = 204490, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 锁链咒符
			{ spellID = 204843, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 悲苦咒符
			{ spellID = 207685, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 烈火烙印
			{ spellID = 207744, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 灵魂切削
			{ spellID = 207407, unitID = "target", caster = "player", filter = "DEBUFF" },


			-- 混乱新星
			{ spellID = 179057, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 复仇回避
			{ spellID = 178813, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 涅墨西斯
			{ spellID = 206491, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 血滴子
			{ spellID = 207690, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 战刃大师
			{ spellID = 213405, unitID = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",

			-- 恶魔变形
			{ spellID =  187827, filter = "CD" },
			-- 幻影打击
			{ spellID =  196718, filter = "CD" },
			-- 锁链咒符
			{ spellID =  202138, filter = "CD" },
			-- 灵魂切割
			{ spellID =  207407, filter = "CD" },


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
	["DEATHKNIGHT"] = { 		--[死骑DK]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",

			-- 反魔法护罩
			{ spellID =  48707, unitID = "player", caster = "player", filter = "BUFF" },
			-- 冰封之韧
			{ spellID =  48792, unitID = "player", caster = "player", filter = "BUFF" },

			-- 白骨风暴
			{ spellID = 194844, unitID = "player", caster = "player", filter = "BUFF" },
			-- 白骨之盾
			{ spellID = 185181, unitID = "player", caster = "player", filter = "BUFF" },
			-- 吸血鬼之血
			{ spellID =  55233, unitID = "player", caster = "player", filter = "BUFF" },
			-- 符文分流
			{ spellID = 194679, unitID = "player", caster = "player", filter = "BUFF" },
			-- 赤色天灾
			{ spellID =  81141, unitID = "player", caster = "player", filter = "BUFF" },
			-- 符文刃舞
			{ spellID =  81256, unitID = "player", caster = "player", filter = "BUFF" },
			-- 灵魂呑噬
			{ spellID = 213003, unitID = "player", caster = "player", filter = "BUFF" },
			-- 鲜血护盾
			{ spellID =  77535, unitID = "player", caster = "player", filter = "BUFF" },

			-- 末日突降
			{ spellID =  81340, unitID = "player", caster = "player", filter = "BUFF" },
			-- 血肉之盾
			{ spellID = 207319, unitID = "player", caster = "player", filter = "BUFF" },
			-- 亵渎
			{ spellID = 218100, unitID = "player", caster = "player", filter = "BUFF" },
			-- 坏疽
			{ spellID = 216974, unitID = "player", caster = "player", filter = "BUFF" },

			-- 邪能之风
			{ spellID = 187147, unitID = "player", caster = "player", filter = "BUFF" },
			-- 冷酷严冬
			{ spellID = 196770, unitID = "player", caster = "player", filter = "BUFF" },
			-- 寒冰之盾
			{ spellID = 207203, unitID = "player", caster = "player", filter = "BUFF" },
			-- 不洁之力
			{ spellID =  53365, unitID = "player", caster = "player", filter = "BUFF" },
			-- 杀戮机器
			{ spellID =  51124, unitID = "player", caster = "player", filter = "BUFF" },
			-- 湮灭
			{ spellID = 207256, unitID = "player", caster = "player", filter = "BUFF" },
			-- 白霜
			{ spellID =  59052, unitID = "player", caster = "player", filter = "BUFF" },
			-- 冰霜之柱
			{ spellID =  51271, unitID = "player", caster = "player", filter = "BUFF" },
			-- 风暴汇聚
			{ spellID = 211805, unitID = "player", caster = "player", filter = "BUFF" },
			-- 冰冻灵魂
			{ spellID = 204957, unitID = "player", caster = "player", filter = "BUFF" },
			-- 冰冷之爪
			{ spellID = 194879, unitID = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",

			-- 窒息
			{ spellID = 211562, unitID = "target", caster = "player", filter = "DEBUFF" },

			-- 灵魂收割
			{ spellID = 130736, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 诸界之灾
			{ spellID = 191748, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 溃烂之伤
			{ spellID = 194310, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 传染
			{ spellID = 191728, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 传染
			{ spellID = 191729, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 死亡
			{ spellID = 191730, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 恶性瘟疫
			{ spellID = 191587, unitID = "target", caster = "player", filter = "DEBUFF" },

			-- 血之疫病
			{ spellID =  55078, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 血之镜像
			{ spellID = 206997, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 鲜血印记
			{ spellID = 206940, unitID = "target", caster = "player", filter = "DEBUFF" },

			-- 冰霜疫病
			{ spellID =  55095, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 锋锐之霜
			{ spellID =  51714, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 凛冬将至
			{ spellID = 221794, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 苍白行者
			{ spellID = 212764, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 迷惑
			{ spellID = 207167, unitID = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",

			-- 枯萎凋零
			{ spellID =  43265, filter = "CD" },
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
	["DRUID"] = {		-- [德鲁伊XD]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",

			-- 化身：生命之树
			{ spellID = 117679, unitID = "player", caster = "player", filter = "BUFF"},
			-- 化身：艾露恩之眷
			{ spellID = 102560, unitID = "player", caster = "player", filter = "BUFF"},
			-- 化身：丛林之王
			{ spellID = 102543, unitID = "player", caster = "player", filter = "BUFF"},
			-- 野性本能
			{ spellID = 210649, unitID = "player", caster = "player", filter = "BUFF"},
			-- 化身：乌索克的守护者
			{ spellID = 102558, unitID = "player", caster = "player", filter = "BUFF"},
			-- 急奔
			{ spellID =   1850, unitID = "player", caster = "player", filter = "BUFF"},

			-- 树皮术
			{ spellID =  22812, unitID = "player", caster = "player", filter = "BUFF"},
			-- 加尼尔的精华
			{ spellID = 208253, unitID = "player", caster = "player", filter = "BUFF"},
			-- 铁木树皮
			{ spellID = 102342, unitID = "player", caster = "player", filter = "BUFF"},
			-- 激活
			{ spellID =  29166, unitID = "player", caster = "player", filter = "BUFF"},
			-- 节能施法
			{ spellID =  16870, unitID = "player", caster = "player", filter = "BUFF"},
			{ spellID = 135700, unitID = "player", caster = "player", filter = "BUFF"},

			-- 血污毛皮
			{ spellID = 201671, unitID = "player", caster = "player", filter = "BUFF"},
			-- 铁鬃
			{ spellID = 192081, unitID = "player", caster = "player", filter = "BUFF"},
			-- 裂伤(熊)
			{ spellID =  93622, unitID = "player", caster = "player", filter = "BUFF"},
			-- 乌索尔印记
			{ spellID = 192083, unitID = "player", caster = "player", filter = "BUFF"},
			-- 生存本能
			{ spellID =  61336, unitID = "player", caster = "player", filter = "BUFF"},
			-- 沉睡者之怒(神器)
			{ spellID = 200851, unitID = "player", caster = "player", filter = "BUFF"},
			-- 艾露恩的卫士
			{ spellID = 213680, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂奔怒吼
			{ spellID =  77761, unitID = "player", caster = "player", filter = "BUFF"},
			-- 热血咆哮
			{ spellID = 214998, unitID = "player", caster = "player", filter = "BUFF"},
			-- 粉碎
			{ spellID = 158792, unitID = "player", caster = "player", filter = "BUFF"},

			-- 狂奔怒吼
			{ spellID =  77764, unitID = "player", caster = "player", filter = "BUFF"},
			-- 掠食者的迅捷(猫)
			{ spellID =  69369, unitID = "player", caster = "player", filter = "BUFF"},
			-- 猛虎之怒(猫)
			{ spellID =   5217, unitID = "player", caster = "player", filter = "BUFF"},
			-- 阿莎曼的能量
			{ spellID = 210583, unitID = "player", caster = "player", filter = "BUFF"},
			-- 血之气息(猫)
			{ spellID = 210664, unitID = "player", caster = "player", filter = "BUFF"},
			-- 野蛮咆哮(猫)
			{ spellID =  52610, unitID = "player", caster = "player", filter = "BUFF"},
			-- 血腥爪击(猫)
			{ spellID = 145152, unitID = "player", caster = "player", filter = "BUFF"},

			-- 月光增效
			{ spellID = 164547, unitID = "player", caster = "player", filter = "BUFF"},
			-- 日光增效
			{ spellID = 164545, unitID = "player", caster = "player", filter = "BUFF"},
			-- 艾露恩的战士
			{ spellID = 202425, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",

			-- 生命绽放
			{ spellID =  33763, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 野性成长
			{ spellID =  48438, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 回春术
			{ spellID =    774, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 回春术(萌芽)
			{ spellID = 155777, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 愈合
			{ spellID =   8936, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 生命之种
			{ spellID =  48504, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 塞纳里奥结界
			{ spellID = 102351, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 铁木树皮
			{ spellID = 102342, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 春暖花开
			{ spellID = 207386, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 激活
			{ spellID =  29166, unitID = "target", caster = "player", filter = "BUFF"  },

			-- 痛击
			{ spellID = 192090, unitID = "target", caster = "player", filter = "DEBUFF"},
			{ spellID = 106830, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 割裂(猫)
			{ spellID =   1079, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 迸裂创伤
			{ spellID = 210670, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 斜掠(猫)
			{ spellID = 155722, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 割碎(猫)
			{ spellID = 203132, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 感染伤口
			{ spellID =  58180, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 阿莎曼的狂乱(神器)
			{ spellID = 210723, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 阳炎术
			{ spellID = 164815, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 月火术
			{ spellID = 164812, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 日光术
			{ spellID =  81261, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 纠缠根须
			{ spellID =    339, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 群体缠绕
			{ spellID = 102359, unitID = "target", caster = "all",    filter = "DEBUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",
			
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
	["HUNTER"] = {		-- [猎人LR]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",
			
			-- 标记目标
			{ spellID = 223138, unitID = "player", caster = "player", filter = "BUFF"},
			-- 灵巧打击
			{ spellID = 227272, unitID = "player", caster = "player", filter = "BUFF"},
			-- 灵龟守护
			{ spellID = 186265, unitID = "player", caster = "player", filter = "BUFF"},
			-- 治疗之壳
			{ spellID = 203924, unitID = "player", caster = "player", filter = "BUFF"},
			-- 荷枪实弹
			{ spellID = 194594, unitID = "player", caster = "player", filter = "BUFF"},
			-- 伪装
			{ spellID = 199483, unitID = "player", caster = "player", filter = "BUFF"},

			-- 野性守护
			{ spellID = 193530, unitID = "player", caster = "player", filter = "BUFF"},
			-- 凶暴野兽
			{ spellID = 120694, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂野怒火
			{ spellID =  19574, unitID = "player", caster = "player", filter = "BUFF"},
			-- 误导
			{ spellID =  35079, unitID = "player", caster = "player", filter = "BUFF"},

			-- 喷毒眼镜蛇
			{ spellID = 194407, unitID = "player", caster = "player", filter = "BUFF"},
			-- 猫鼬撕咬
			{ spellID = 190931, unitID = "player", caster = "player", filter = "BUFF"},
			-- 猫鼬本能
			{ spellID = 204333, unitID = "player", caster = "player", filter = "BUFF"},
			-- 迅猛龙本能
			{ spellID = 204321, unitID = "player", caster = "player", filter = "BUFF"},
			-- 猎豹本能
			{ spellID = 204324, unitID = "player", caster = "player", filter = "BUFF"},
			-- 莫克纳萨战术
			{ spellID = 201081, unitID = "player", caster = "player", filter = "BUFF"},
			-- 啸天者守护
			{ spellID = 203927, unitID = "player", caster = "player", filter = "BUFF"},
			-- 雄鹰守护
			{ spellID = 186289, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",
			
			-- 误导
			{ spellID = 211138, unitID = "target", caster = "player", filter = "DEBUFF"},
			{ spellID =  34477, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 猎人印记
			{ spellID = 185365, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 易伤
			{ spellID = 187131, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 黑箭
			{ spellID = 194599, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 精确瞄准
			{ spellID =  63468, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 稳定瞄准
			{ spellID = 199803, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 夺命黑鸦
			{ spellID = 131894, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 翼龙钉刺
			{ spellID =  19386, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 毒蛇釘刺
			{ spellID = 118253, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冰冻陷阱
			{ spellID =   3355, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 焦油陷阱
			{ spellID = 135299, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 爆炸陷阱
			{ spellID =  13812, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 精钢陷阱
			{ spellID = 162487, unitID = "target", caster = "all",    filter = "DEBUFF"},
			{ spellID = 162480, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 游侠之网
			{ spellID = 200108, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 铁蒺藜
			{ spellID = 194279, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 裂痕
			{ spellID = 185855, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 龙焰手雷
			{ spellID = 194858, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 黏性炸弹
			{ spellID = 191241, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 利刃留痕
			{ spellID = 204081, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 野兽狡诈
			{ spellID = 191397, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 野兽狂野
			{ spellID = 191413, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",
			
			-- 黑箭
			{ spellID = 194599, filter = "CD" },
			-- 假死
			{ spellID =   5384, filter = "CD" },
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
	["MAGE"] = {		--[法师FS]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",
			
			-- 冰枪御体
			{ spellID = 195391, unitID = "player", caster = "player", filter = "BUFF"},
			-- 冰刺
			{ spellID = 205473, unitID = "player", caster = "player", filter = "BUFF"},
			-- 寒冰指
			{ spellID =  44544, unitID = "player", caster = "player", filter = "BUFF"},
			-- 冰冷智慧
			{ spellID = 190446, unitID = "player", caster = "player", filter = "BUFF"},
			-- 连锁反应 
			{ spellID = 195418, unitID = "player", caster = "player", filter = "BUFF"},
			-- 寒冰屏障
			{ spellID =  45438, unitID = "player", caster = "player", filter = "BUFF"},
			-- 隐形术
			{ spellID =  32612, unitID = "player", caster = "player", filter = "BUFF"},
			-- 寒冰护体
			{ spellID =  11426, unitID = "player", caster = "player", filter = "BUFF"},
			-- 浮冰
			{ spellID = 108839, unitID = "player", caster = "player", filter = "BUFF"},
			-- 冰冷血脉
			{ spellID =  12472, unitID = "player", caster = "player", filter = "BUFF"},
			-- 极寒之心
			{ spellID = 195446, unitID = "player", caster = "player", filter = "BUFF"},
			-- 冰川尖刺
			{ spellID = 199844, unitID = "player", caster = "player", filter = "BUFF"},
			-- 咒术洪流
			{ spellID = 116267, unitID = "player", caster = "player", filter = "BUFF"},
			-- 刺骨冰寒
			{ spellID = 205766, unitID = "player", caster = "player", filter = "BUFF"},

			-- 炽烈之咒
			{ spellID = 194329, unitID = "player", caster = "player", filter = "BUFF"},
			-- 强化烟火之术
			{ spellID = 157644, unitID = "player", caster = "player", filter = "BUFF"},
			-- 热力迸发
			{ spellID =  48107, unitID = "player", caster = "player", filter = "BUFF"},
			-- 炽热连击!
			{ spellID =  48108, unitID = "player", caster = "player", filter = "BUFF"},
			-- 烧焦的大地
			{ spellID = 227482, unitID = "player", caster = "player", filter = "BUFF"},
			-- 燃烧
			{ spellID = 190319, unitID = "player", caster = "player", filter = "BUFF"},
			-- 火疗闪烁
			{ spellID = 194316, unitID = "player", caster = "player", filter = "BUFF"},

			-- 奥术强化
			{ spellID =  12042, unitID = "player", caster = "player", filter = "BUFF"},
			-- 能量符文
			{ spellID = 116014, unitID = "player", caster = "player", filter = "BUFF"},
			-- 奥术飞弹!
			{ spellID =  79683, unitID = "player", caster = "player", filter = "BUFF"},
			-- 气定神闲
			{ spellID = 205025, unitID = "player", caster = "player", filter = "BUFF"},
			-- 加速
			{ spellID = 198924, unitID = "player", caster = "player", filter = "BUFF"},
			-- 强化隐形术
			{ spellID = 110960, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",
			
			-- 变形术(羊/猪/火鸡/黑猫/兔子/乌龟/企鹅/猴子/北极熊幼崽/孔雀/豪猪)
			{ spellID =    118, unitId = "target", caster = "all",    filter = "DEBUFF" },
			{ spellID =  28272, unitId = "target", caster = "all",    filter = "DEBUFF" },
			{ spellID =  61780, unitId = "target", caster = "all",    filter = "DEBUFF" },
			{ spellID =  61305, unitId = "target", caster = "all",    filter = "DEBUFF" },
			{ spellID =  61721, unitId = "target", caster = "all",    filter = "DEBUFF" },
			{ spellID =  28271, unitId = "target", caster = "all",    filter = "DEBUFF" },
			{ spellID = 161355, unitId = "target", caster = "all",    filter = "DEBUFF" },
			{ spellID = 161354, unitId = "target", caster = "all",    filter = "DEBUFF" },
			{ spellID = 161353, unitId = "target", caster = "all",    filter = "DEBUFF" },
			{ spellID = 161355, unitId = "target", caster = "all",    filter = "DEBUFF" },
			{ spellID = 126819, unitId = "target", caster = "all",    filter = "DEBUFF" },

			-- 冰冻术
			{ spellID =  33395, unitID = "target", caster = "pet",    filter = "DEBUFF"},
			-- 寒冰炸弹
			{ spellID = 112948, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冰霜新星
			{ spellID =    122, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冰冻
			{ spellID = 205708, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冰川尖刺
			{ spellID = 228600, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冰锥术
			{ spellID = 212792, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 点燃
			{ spellID =  12654, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 龙息术
			{ spellID =  31661, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 爆裂熔炉
			{ spellID = 194522, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 烈焰风暴
			{ spellID =   2120, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 活动炸弹
			{ spellID = 217694, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冲击波
			{ spellID = 157981, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 洪荒烈火
			{ spellID = 226757, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 流星灼烧
			{ spellID = 155158, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 减速
			{ spellID =  31589, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 虚空风暴
			{ spellID = 114923, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 艾露尼斯的印记
			{ spellID = 224968, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 奥术侵蚀
			{ spellID = 210134, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 大法师之触
			{ spellID = 210824, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",
			
			-- 镜像术
			{ spellID = 55342, filter = "CD" },
			-- 唤醒
			{ spellID = 12051, filter = "CD" },
			-- 冰冷血脉
			{ spellID = 12472, filter = "CD" },
			-- 寒冰屏障
			{ spellID = 45438, filter = "CD" },

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
	["MONK"] = {		--[武僧WS]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",
			
			-- 转化力量 
			{ spellID = 195321, unitID = "player", caster = "player", filter = "BUFF"},
			-- 真气突
			{ spellID = 199085, unitID = "player", caster = "player", filter = "BUFF"},
			-- 风火雷电
			{ spellID = 137639, unitID = "player", caster = "player", filter = "BUFF"},
			-- 幻灭踢!
			{ spellID = 116768, unitID = "player", caster = "player", filter = "BUFF"},
			-- 业报之触
			{ spellID = 125174, unitID = "player", caster = "player", filter = "BUFF"},
			-- 碧玉疾风(踏风)
			{ spellID = 116847, unitID = "player", caster = "player", filter = "BUFF"},
			-- 迅如猛虎
			{ spellID = 116841, unitID = "player", caster = "player", filter = "BUFF"},
			-- 猛虎之眼
			{ spellID = 196608, unitID = "player", caster = "player", filter = "BUFF"},
			-- 连击
			{ spellID = 196741, unitID = "player", caster = "player", filter = "BUFF"},
			-- 屏气凝神
			{ spellID = 152173, unitID = "player", caster = "player", filter = "BUFF"},

			-- 散魔功
			{ spellID = 122783, unitID = "player", caster = "player", filter = "BUFF"},
			-- 力贯千钧
			{ spellID = 129914, unitID = "player", caster = "player", filter = "BUFF"},
			-- 躯不坏
			{ spellID = 122278, unitID = "player", caster = "player", filter = "BUFF"},

			-- 铁骨酒
			{ spellID = 215479, unitID = "player", caster = "player", filter = "BUFF"},
			-- 利涉大川
			{ spellID = 213177, unitID = "player", caster = "player", filter = "BUFF"},
			-- 壮胆酒
			{ spellID = 120954, unitID = "player", caster = "player", filter = "BUFF"},
			-- 胆略
			{ spellID = 213341, unitID = "player", caster = "player", filter = "BUFF"},
			-- 幻灭连击
			{ spellID = 228563, unitID = "player", caster = "player", filter = "BUFF"},

			-- 精华之泉
			{ spellID = 191840, unitID = "player", caster = "player", filter = "BUFF"},
			-- 生生不息
			{ spellID = 197919, unitID = "player", caster = "player", filter = "BUFF"},
			-- 升腾状态
			{ spellID = 197206, unitID = "player", caster = "player", filter = "BUFF"},
			-- 碧玉疾风(织雾)
			{ spellID = 196725, unitID = "player", caster = "player", filter = "BUFF"},
			-- 法力茶
			{ spellID = 197908, unitID = "player", caster = "player", filter = "BUFF"},
			-- 雷光聚神茶
			{ spellID = 116680, unitID = "player", caster = "player", filter = "BUFF"},
			-- 玉珑的祝福
			{ spellID = 199668, unitID = "player", caster = "player", filter = "BUFF"},
			-- 作茧缚命
			{ spellID = 116849, unitID = "player", caster = "player", filter = "BUFF"},
			-- 脚步轻盈
			{ spellID = 199407, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",
			
			-- 复苏之雾
			{ spellID = 119611, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 氤氲之雾 
			{ spellID = 124682, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 作茧缚命   
			{ spellID = 116849, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 赤精之歌
			{ spellID = 198909, unitID = "target", caster = "player", filter = "DEBUFF"}, 

			-- 火焰之息
			{ spellID = 123725, unitID = "target", caster = "player", filter = "DEBUFF"}, 
			-- 神鹤印记
			{ spellID = 228287, unitID = "target", caster = "player", filter = "DEBUFF"}, 
			-- 致死之伤
			{ spellID = 115864, unitID = "target", caster = "player", filter = "DEBUFF"}, 
			-- 业报之触
			{ spellID = 122470, unitID = "target", caster = "player", filter = "DEBUFF"}, 
			-- 风领主之击
			{ spellID = 205320, unitID = "target", caster = "player", filter = "DEBUFF"}, 
			-- 轮回之触
			{ spellID = 115080, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 无影脚
			{ spellID = 196723, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 扫堂腿
			{ spellID = 119381, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 月之暗面
			{ spellID = 213063, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 醉酿投
			{ spellID = 121253, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 爆炸酒桶
			{ spellID = 214326, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 猛虎之眼
			{ spellID = 196608, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 分筋错骨
			{ spellID = 115078, unitID = "target", caster = "all",    filter = "DEBUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",

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
	["PALADIN"] = {		--[骑士QS]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",

			-- 神圣复仇者
			{ spellID = 105809, unitID = "player", caster = "player", filter = "BUFF"},
			-- 复仇之怒
			{ spellID =  31884, unitID = "player", caster = "player", filter = "BUFF"},
			-- 守备官
			{ spellID = 200376, unitID = "player", caster = "player", filter = "BUFF"},
			-- 虔诚光环
			{ spellID =  31821, unitID = "player", caster = "player", filter = "BUFF"},
			-- 提尔的保护
			{ spellID = 221200, unitID = "player", caster = "player", filter = "BUFF"},
			-- 白银之手骑士
			{ spellID = 221422, unitID = "player", caster = "player", filter = "BUFF"},
			-- 圣光灌注
			{ spellID =  54149, unitID = "player", caster = "player", filter = "BUFF"},
			-- 神圣意志
			{ spellID = 216411, unitID = "player", caster = "player", filter = "BUFF"},
			-- 提尔的拯救
			{ spellID = 200652, unitID = "player", caster = "player", filter = "BUFF"},
			{ spellID = 200654, unitID = "player", caster = "player", filter = "BUFF"},
			-- 白银之手的力量
			{ spellID = 200656, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂热殉道者
			{ spellID = 223316, unitID = "player", caster = "player", filter = "BUFF"},
			-- 圣佑术
			{ spellID =    498, unitID = "player", caster = "player", filter = "BUFF"},
			-- 律法之则
			{ spellID = 214202, unitID = "player", caster = "player", filter = "BUFF"},


			-- 圣盾术
			{ spellID =    642, unitID = "player", caster = "player", filter = "BUFF"},
			-- 正义盾击
			{ spellID = 132403, unitID = "player", caster = "player", filter = "BUFF"},
			-- 秩序壁垒
			{ spellID = 209388, unitID = "player", caster = "player", filter = "BUFF"},
			-- 圣光护盾
			{ spellID = 204150, unitID = "player", caster = "player", filter = "BUFF"},
			-- 痛苦真理
			{ spellID = 209332, unitID = "player", caster = "player", filter = "BUFF"},
			-- 炽热防御者
			{ spellID =  31850, unitID = "player", caster = "player", filter = "BUFF"},
			-- 远古列王守卫
			{ spellID =  86659, unitID = "player", caster = "player", filter = "BUFF"},
			-- 泰坦之光
			{ spellID = 209540, unitID = "player", caster = "player", filter = "BUFF"},
			-- 炽天使
			{ spellID = 152262, unitID = "player", caster = "player", filter = "BUFF"},

			-- 正义之火
			{ spellID = 209785, unitID = "player", caster = "player", filter = "BUFF"},
			-- 神圣意志
			{ spellID = 223819, unitID = "player", caster = "player", filter = "BUFF"},
			-- 复仇之盾
			{ spellID = 184662, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂热
			{ spellID = 217020, unitID = "player", caster = "player", filter = "BUFF"},
			-- 以眼还眼
			{ spellID = 205191, unitID = "player", caster = "player", filter = "BUFF"},
			-- 征伐
			{ spellID = 224668, unitID = "player", caster = "player", filter = "BUFF"},
			-- 光明圣印
			{ spellID = 202273, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",

			-- 赋予信仰
			{ spellID = 223306, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 白银之手骑士
			{ spellID = 211422, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 美德道标
			{ spellID = 200025, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 圣光道标
			{ spellID =  53563, unitID = "target", caster = "all"   , filter = "BUFF"  },
			-- 信仰道标
			{ spellID = 156910, unitID = "target", caster = "all"   , filter = "BUFF"  },

			-- 忏悔
			{ spellID =  20066, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 复仇者之盾
			{ spellID =  31935, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 提尔之眼(神器)
			{ spellID = 209202, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 奉献
			{ spellID = 204242, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 自律
			{ spellID =  25771, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 制裁之錘
			{ spellID =    853, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 祝福之錘
			{ spellID = 204301, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 圣光审判
			{ spellID = 196941, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 盲目之光
			{ spellID = 105421, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 审判
			{ spellID = 197277, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 灰烬觉醒
			{ spellID = 205273, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 妨害之手
			{ spellID = 183218, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 愤怒之剑
			{ spellID = 202270, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 处决宣判
			{ spellID = 213757, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",

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
	["PRIEST"] = {		--[牧师MS]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",

			-- 争分夺秒
			{ spellID = 197763, unitID = "player", caster = "player", filter = "BUFF"},
			-- 全神贯注
			{ spellID =  47536, unitID = "player", caster = "player", filter = "BUFF"},
			-- 救赎
			{ spellID = 194384, unitID = "player", caster = "player", filter = "BUFF"},
			-- 能量灌注
			{ spellID =  10060, unitID = "player", caster = "player", filter = "BUFF"},
			-- 专注意志
			{ spellID =  45242, unitID = "player", caster = "player", filter = "BUFF"},
			-- 阴影面之力
			{ spellID = 198069, unitID = "player", caster = "player", filter = "BUFF"},
			-- 渐隐术
			{ spellID =    586, unitID = "player", caster = "player", filter = "BUFF"},

			-- 纳鲁之能
			{ spellID = 196490, unitID = "player", caster = "player", filter = "BUFF"},
			-- 圣洁
			{ spellID = 197030, unitID = "player", caster = "player", filter = "BUFF"},
			-- 希望象征
			{ spellID =  64901, unitID = "player", caster = "player", filter = "BUFF"},
			-- 圣光回响
			{ spellID =  77489, unitID = "player", caster = "player", filter = "BUFF"},
			-- 愈合祷言
			{ spellID =  41635, unitID = "player", caster = "player", filter = "BUFF"},
			-- 图雷之光
			{ spellID = 208065, unitID = "player", caster = "player", filter = "BUFF"},
			-- 神圣化身
			{ spellID = 200183, unitID = "player", caster = "player", filter = "BUFF"},
			-- 图雷的祝福
			{ spellID = 196644, unitID = "player", caster = "player", filter = "BUFF"},
			-- 圣光涌动
			{ spellID = 114255, unitID = "player", caster = "player", filter = "BUFF"},
			-- 愈合祷言
			{ spellID =  64843, unitID = "player", caster = "player", filter = "BUFF"},
			{ spellID =  64844, unitID = "player", caster = "player", filter = "BUFF"},

			-- 妙手回春
			{ spellID =  63735, unitID = "player", caster = "player", filter = "BUFF"},

			-- 消散
			{ spellID =  47585, unitID = "player", caster = "player", filter = "BUFF"},
			-- 暗中生长
			{ spellID = 194205, unitID = "player", caster = "player", filter = "BUFF"},
			-- 吸血鬼的拥抱
			{ spellID =  15286, unitID = "player", caster = "player", filter = "BUFF"},
			-- 虚空形态
			{ spellID = 194249, unitID = "player", caster = "player", filter = "BUFF"},
			-- 延宕狂乱
			{ spellID = 197937, unitID = "player", caster = "player", filter = "BUFF"},
			-- 虚空洪流
			{ spellID = 205065, unitID = "player", caster = "player", filter = "BUFF"},
			-- 疯入膏肓
			{ spellID = 193223, unitID = "player", caster = "player", filter = "BUFF"},
			-- 虚空射线
			{ spellID = 205372, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",

			-- 真言术：盾
			{ spellID =     17, unitID = "target", caster = "all",    filter = "BUFF"  },
			-- 意志洞悉
			{ spellID = 152118, unitID = "target", caster = "all",    filter = "BUFF"  },
			-- 救赎
			{ spellID = 194384, unitID = "player", caster = "player", filter = "BUFF"},
			-- 痛苦压制
			{ spellID =  33206, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 净化邪恶
			{ spellID = 204213, unitID = "target", caster = "player", filter = "DEBUFF"},


			-- 恢复
			{ spellID =    139, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 愈合祷言
			{ spellID =  41635, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 守护之魂
			{ spellID =  47788, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 神圣之火
			{ spellID =  14914, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 圣言术：罚
			{ spellID = 200200, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 暗言术：痛
			{ spellID =    589, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 吸血鬼之触
			{ spellID =  34914, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 精神控制
			{ spellID =    605, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 心灵尖啸
			{ spellID =   8122, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 沉默
			{ spellID =  15487, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 束缚亡灵
			{ spellID =   9484, unitID = "target", caster = "all",    filter = "DEBUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",

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
	["ROGUE"] = {		--[盗贼DZ]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",

			-- 消失
			{ spellID =  11327, unitID = "player", caster = "player", filter = "BUFF"},
			-- 闪避
			{ spellID =   5277, unitID = "player", caster = "player", filter = "BUFF"},
			-- 疾跑
			{ spellID =   2983, unitID = "player", caster = "player", filter = "BUFF"},
			-- 暗影斗篷
			{ spellID =  31224, unitID = "player", caster = "player", filter = "BUFF"},

			-- 黑暗之拥
			{ spellID = 197603, unitID = "player", caster = "player", filter = "BUFF"},
			-- 死亡标志
			{ spellID = 212283, unitID = "player", caster = "player", filter = "BUFF"},
			-- 死亡
			{ spellID = 227151, unitID = "player", caster = "player", filter = "BUFF"},
			-- 终结技:刺骨
			{ spellID = 197496, unitID = "player", caster = "player", filter = "BUFF"},
			-- 终结技:夜刃
			{ spellID = 197498, unitID = "player", caster = "player", filter = "BUFF"},
			-- 赤喉之咬
			{ spellID = 220901, unitID = "player", caster = "player", filter = "BUFF"},
			-- 猩红之瓶
			{ spellID = 185311, unitID = "player", caster = "player", filter = "BUFF"},
			-- 暗影之刃
			{ spellID = 121471, unitID = "player", caster = "player", filter = "BUFF"},
			-- 敏锐大师
			{ spellID =  31665, unitID = "player", caster = "player", filter = "BUFF"},
			-- 敏锐
			{ spellID = 193538, unitID = "player", caster = "player", filter = "BUFF"},
			-- 欺凌
			{ spellID = 115192, unitID = "player", caster = "player", filter = "BUFF"},
			-- 暗影笼罩
			{ spellID = 206237, unitID = "player", caster = "player", filter = "BUFF"},
			-- 暗影之舞
			{ spellID = 185422, unitID = "player", caster = "player", filter = "BUFF"},

			-- 恐惧之刃诅咒(神器)
			{ spellID = 202665, unitID = "player", caster = "player", filter="DEBUFF"},
			-- 可乘之机
			{ spellID = 195627, unitID = "player", caster = "player", filter = "BUFF"},
			-- 切割
			{ spellID =   5171, unitID = "player", caster = "player", filter = "BUFF"},
			-- 佯攻
			{ spellID =   1966, unitID = "player", caster = "player", filter = "BUFF"},
			-- 冲动
			{ spellID =  13750, unitID = "player", caster = "player", filter = "BUFF"},
			-- 迷离时刻
			{ spellID = 202776, unitID = "player", caster = "player", filter = "BUFF"},
			-- 还击
			{ spellID = 199754, unitID = "player", caster = "player", filter = "BUFF"},
			-- 精准定位
			{ spellID = 193359, unitID = "player", caster = "player", filter = "BUFF"},
			-- 大乱斗
			{ spellID = 193358, unitID = "player", caster = "player", filter = "BUFF"},
			-- 暗鲨涌动
			{ spellID = 193357, unitID = "player", caster = "player", filter = "BUFF"},
			-- 强势连击
			{ spellID = 193356, unitID = "player", caster = "player", filter = "BUFF"},
			-- 骷髅黑帆
			{ spellID = 199603, unitID = "player", caster = "player", filter = "BUFF"},
			-- 埋藏的宝藏
			{ spellID = 199600, unitID = "player", caster = "player", filter = "BUFF"},
			-- 影舞步
			{ spellID =  51690, unitID = "player", caster = "player", filter = "BUFF"},

			-- 毒伤
			{ spellID =  32645, unitID = "player", caster = "player", filter = "BUFF"},
			-- 暗影伏击
			{ spellID = 192432, unitID = "player", caster = "player", filter = "BUFF"},
			-- 深谋远虑
			{ spellID = 193641, unitID = "player", caster = "player", filter = "BUFF"},
			-- 装死
			{ spellID =  45182, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",

			-- 闷棍
			{ spellID =   6770, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 致盲
			{ spellID =   2094, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 肾击
			{ spellID =    408, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 偷袭
			{ spellID =   1833, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 夜刃
			{ spellID = 195452, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 暗夜恐怖
			{ spellID = 207760, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 赤喉之咬
			{ spellID = 209786, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 死亡标志
			{ spellID = 137619, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 凿击
			{ spellID =   1776, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 手枪射地击
			{ spellID = 185763, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 正中眉心
			{ spellID = 199804, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 鬼魅攻击
			{ spellID = 196937, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 谈判
			{ spellID = 199743, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 贿赂
			{ spellID = 199740, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 苦痛药膏
			{ spellID = 200803, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 君王之灾(神器)
			{ spellID = 192759, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 毒素冲动
			{ spellID = 192425, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 遇刺者之血
			{ spellID = 192925, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 割裂
			{ spellID =   1943, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 锁喉
			{ spellID =    703, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 宿敌
			{ spellID =  79140, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 致命药膏
			{ spellID =   2818, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 减速药膏
			{ spellID =   3409, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 出血
			{ spellID =  16511, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 内出血
			{ spellID = 154953, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",


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
	["SHAMAN"] = {		--[萨满SM]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",

			-- 熔岩奔腾
			{ spellID =  77762, unitID = "player", caster = "player", filter = "BUFF"},
			-- 元素集中
			{ spellID =  16246, unitID = "player", caster = "player", filter = "BUFF"},
			-- 漩涡之力
			{ spellID = 191877, unitID = "player", caster = "player", filter = "BUFF"},
			-- 风暴守护者
			{ spellID = 205495, unitID = "player", caster = "player", filter = "BUFF"},
			-- 元素掌握
			{ spellID =  16166, unitID = "player", caster = "player", filter = "BUFF"},
			-- 冰怒
			{ spellID = 210714, unitID = "player", caster = "player", filter = "BUFF"},
			-- 元素冲击
			{ spellID = 118522, unitID = "player", caster = "player", filter = "BUFF"},
			{ spellID = 173183, unitID = "player", caster = "player", filter = "BUFF"},
			{ spellID = 173184, unitID = "player", caster = "player", filter = "BUFF"},

			-- 潮汐奔涌
			{ spellID =  53390, unitID = "player", caster = "player", filter = "BUFF"},
			-- 潮汐之母的抚慰
			{ spellID = 209950, unitID = "player", caster = "player", filter = "BUFF"},
			-- 女王赦令
			{ spellID = 208899, unitID = "player", caster = "player", filter = "BUFF"},
			-- 女王崛起
			{ spellID = 207288, unitID = "player", caster = "player", filter = "BUFF"},
			-- 治疗之雨
			{ spellID =  73920, unitID = "player", caster = "player", filter = "BUFF"},
			-- 暴雨图腾
			{ spellID = 157504, unitID = "player", caster = "player", filter = "BUFF"},
			-- 迷雾幽灵
			{ spellID = 207527, unitID = "player", caster = "player", filter = "BUFF"},
			-- 先祖指引
			{ spellID = 108281, unitID = "player", caster = "player", filter = "BUFF"},
			-- 星界转移
			{ spellID = 108271, unitID = "player", caster = "player", filter = "BUFF"},
			-- 灵魂行者的恩赐
			{ spellID =  79206, unitID = "player", caster = "player", filter = "BUFF"},
			-- 生命释放
			{ spellID =  73685, unitID = "player", caster = "player", filter = "BUFF"},
			-- 十万火急
			{ spellID = 208416, unitID = "player", caster = "player", filter = "BUFF"},

			-- 升腾
			{ spellID = 114050, unitID = "player", caster = "player", filter = "BUFF"},
			{ spellID = 114051, unitID = "player", caster = "player", filter = "BUFF"},
			{ spellID = 114052, unitID = "player", caster = "player", filter = "BUFF"},

			-- 闪电之盾
			{ spellID =    324, unitID = "player", caster = "player", filter = "BUFF"},
			-- 风暴使者
			{ spellID = 201846, unitID = "player", caster = "player", filter = "BUFF"},
			-- 毁灭之风
			{ spellID = 204945, unitID = "player", caster = "player", filter = "BUFF"},
			-- 毁灭闪电
			{ spellID = 187878, unitID = "player", caster = "player", filter = "BUFF"},
			-- 集束风暴
			{ spellID = 198300, unitID = "player", caster = "player", filter = "BUFF"},
			-- 毁灭释放
			{ spellID = 165462, unitID = "player", caster = "player", filter = "BUFF"},
			-- 风暴之鞭
			{ spellID = 195222, unitID = "player", caster = "player", filter = "BUFF"},
			-- 火舌
			{ spellID = 194084, unitID = "player", caster = "player", filter = "BUFF"},
			-- 冰封
			{ spellID = 196834, unitID = "player", caster = "player", filter = "BUFF"},
			-- 山崩
			{ spellID = 202004, unitID = "player", caster = "player", filter = "BUFF"},
			-- 风歌
			{ spellID = 201898, unitID = "player", caster = "player", filter = "BUFF"},
			-- 疾风打击
			{ spellID = 198293, unitID = "player", caster = "player", filter = "BUFF"},
			-- 幽魂步
			{ spellID =  58875, unitID = "player", caster = "player", filter = "BUFF"},
			-- 灼热之手
			{ spellID = 215785, unitID = "player", caster = "player", filter = "BUFF"},
			-- 石拳
			{ spellID = 218825, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",

			-- 激流
			{ spellID =  61295, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 女王的恩赐
			{ spellID = 207778, unitID = "target", caster = "player", filter = "BUFF"  },
			-- 先祖活力
			{ spellID = 207400, unitID = "target", caster = "player", filter = "BUFF"  },

			-- 烈焰震击
			{ spellID =   8050, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 冰霜震击
			{ spellID = 190840, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 引雷针
			{ spellID = 197209, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 岩浆图腾
			{ spellID = 192226, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 冰封打击
			{ spellID = 147732, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 大地之刺
			{ spellID = 188089, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 妖术
			{ spellID =  51514, unitID = "target", caster = "all",    filter = "DEBUFF"},
			-- 静电充能
			{ spellID = 118905, unitID = "target", caster = "all",    filter = "DEBUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",

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
	["WARLOCK"] = {		--[术士SS]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",

			-- 不灭决心
			{ spellID = 104773, unitID = "player", caster = "player", filter = "BUFF" },
			-- 牺牲契约
			{ spellID = 108416, unitID = "player", caster = "player", filter = "BUFF" },

			-- 暗影冥思
			{ spellID = 196098, unitID = "player", caster = "player", filter = "BUFF" },
			-- 延绵恐惧
			{ spellID = 199281, unitID = "player", caster = "player", filter = "BUFF" },
			-- 灵魂榨取
			{ spellID = 108366, unitID = "player", caster = "player", filter = "BUFF" },
			-- 逆风收割者
			{ spellID = 216708, unitID = "player", caster = "player", filter = "BUFF" },

			-- 恶魔协同
			{ spellID = 171982, unitID = "player", caster = "pet",    filter = "BUFF" },
			-- 爆燃
			{ spellID = 117828, unitID = "player", caster = "player", filter = "BUFF" },
			-- 混沌燃烧
			{ spellID = 196546, unitID = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",

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

			-- 痛楚
			{ spellID =    980, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 痛苦无常
			{ spellID =  30108, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 鬼影缠身
			{ spellID =  48181, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 腐蚀术
			{ spellID = 146739, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 腐蚀之种
			{ spellID =  27243, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 诡异魅影
			{ spellID = 205179, unitID = "target", caster = "player", filter = "DEBUFF" },

			-- 末日降临
			{ spellID =    603, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 暗影烈焰
			{ spellID = 205181, unitID = "target", caster = "player", filter = "DEBUFF" },


			-- 浩劫
			{ spellID =  80240, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- 献祭
			{ spellID = 157736, unitID = "target", caster = "player", filter = "DEBUFF" },
			{ spellID = 108686, unitID = "target", caster = "player", filter = "DEBUFF" },
			-- 灭杀
			{ spellID = 196414, unitID = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",


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
	["WARRIOR"] = { 		--[战士ZS]
		{
			name = "玩家buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playerbuff)},
			mode = "ICON",

			-- 命令怒吼
			{ spellID =  97463, unitID = "player", caster = "player", filter = "BUFF"},
			-- 压制!
			{ spellID =  60503, unitID = "player", caster = "player", filter = "BUFF"},
			-- 粉碎防御
			{ spellID = 209706, unitID = "player", caster = "player", filter = "BUFF"},
			-- 防御姿态
			{ spellID = 197690, unitID = "player", caster = "player", filter = "BUFF"},
			-- 战吼
			{ spellID =   1719, unitID = "player", caster = "player", filter = "BUFF"},
			-- 扎卡兹的腐化之血
			{ spellID = 209567, unitID = "player", caster = "player", filter = "BUFF"},
			-- 怒火聚焦
			{ spellID = 207982, unitID = "player", caster = "player", filter = "BUFF"},
			-- 战术优势
			{ spellID = 209484, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂暴之怒
			{ spellID =  18499, unitID = "player", caster = "player", filter = "BUFF"},
			-- 剑在人在
			{ spellID = 118038, unitID = "player", caster = "player", filter = "BUFF"},
			-- 剑刃风暴
			{ spellID = 227847, unitID = "player", caster = "player", filter = "BUFF"},

			-- 血之气息
			{ spellID = 206333, unitID = "player", caster = "player", filter = "BUFF"},
			-- 血肉顺劈
			{ spellID =  85739, unitID = "player", caster = "player", filter = "BUFF"},
			-- 浴血奋战
			{ spellID =  12292, unitID = "player", caster = "player", filter = "BUFF"},
			-- 激怒
			{ spellID = 184362, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂暴
			{ spellID = 200953, unitID = "player", caster = "player", filter = "BUFF"},
			-- 战争疤痕
			{ spellID = 200954, unitID = "player", caster = "player", filter = "BUFF"},
			-- 巨龙怒吼
			{ spellID = 118000, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂怒回复
			{ spellID = 184364, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂乱
			{ spellID = 202539, unitID = "player", caster = "player", filter = "BUFF"},
			-- 无匹之力
			{ spellID = 200977, unitID = "player", caster = "player", filter = "BUFF"},
			-- 天神下凡
			{ spellID = 107574, unitID = "player", caster = "player", filter = "BUFF"},

			-- 盾墙
			{ spellID =    871, unitID = "player", caster = "player", filter = "BUFF"},
			-- 破釜沉舟
			{ spellID =  12975, unitID = "player", caster = "player", filter = "BUFF"},
			-- 盾牌格挡
			{ spellID = 132404, unitID = "player", caster = "player", filter = "BUFF"},
			-- 奈萨里奥之怒
			{ spellID = 203524, unitID = "player", caster = "player", filter = "BUFF"},
			-- 法术反射
			{ spellID =  23920, unitID = "player", caster = "player", filter = "BUFF"},
			-- 无视痛苦
			{ spellID = 190456, unitID = "player", caster = "player", filter = "BUFF"},
			-- 狂暴复兴
			{ spellID = 202289, unitID = "player", caster = "player", filter = "BUFF"},
			-- 怒火聚焦
			{ spellID = 204488, unitID = "player", caster = "player", filter = "BUFF"},
			-- 怒火聚焦
			{ spellID = 122510, unitID = "player", caster = "player", filter = "BUFF"},

			-- 乘胜追击
			{ spellID =  32216, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].targetdebuff)},
			mode = "ICON",

			-- 致死之伤
			{ spellID = 115804, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 创伤
			{ spellID = 215537, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 巨人打击
			{ spellID = 208086, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 撕裂
			{ spellID =    772, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 破胆怒吼
			{ spellID =   5246, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 浴血奋战
			{ spellID = 113344, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 奥丁之怒
			{ spellID = 205546, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 刺耳怒吼
			{ spellID =  12323, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 风暴之锤
			{ spellID = 132169, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 震荡波
			{ spellID = 132168, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 挫志怒吼
			{ spellID =   1160, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- 重伤
			{ spellID = 115767, unitID = "target", caster = "player", filter = "DEBUFF"},

			-- 断筋
			{ spellID =   1715, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].playercd)},
			mode = "ICON",

			-- 盾墙
			{ spellID =    871, filter = "CD" },
			-- 破胆怒吼
			{ spellID =   5246, filter = "CD" },
			-- 天神下凡
			{ spellID = 107574, filter = "CD" },
			-- 剑在人在
			{ spellID = 118038, filter = "CD" },
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
			name = "玩家饰品附魔触发buff",
			direction = "LEFT",
			size = 28,
			setpoint = {unpack(FG["filger_position"].enbuff)},
			mode = "ICON",


			-- 药水
			-------------------------------MOP----------------------------------------
			-- WOD护甲药水
			{ spellID = 156430, unitId = "player", caster = "player", filter = "BUFF" },
			-- WOD力量药水
			{ spellID = 156428, unitId = "player", caster = "player", filter = "BUFF" },
			-- WOD智力药水
			{ spellID = 156426, unitId = "player", caster = "player", filter = "BUFF" },
			-- WOD敏捷药水
			{ spellID = 156423, unitId = "player", caster = "player", filter = "BUFF" },
			-- WOD隐身药水
			{ spellID = 175833, unitId = "player", caster = "player", filter = "BUFF" },

			-- 武器附魔(caster = 必须是all)
			-------------------------------MOP----------------------------------------
			-- 霜狼之印(溅射)
			{ spellID = 159676, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 黑石之印(护甲)
			{ spellID = 159679, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 战歌之印(急速)
			{ spellID = 159675, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 影月之印(精神)
			{ spellID = 159678, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 雷神之印(爆击)
			{ spellID = 159234, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 血环之印(精通)
			{ spellID = 173322, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 赫米特的觅心者(精通)
			{ spellID = 173288, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 奥格索普的飞弹分离器(溅射)
			{ spellID = 156055, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 兆瓦纤维(爆击)
			{ spellID = 156060, unitId = "player", caster = "all",    filter = "BUFF" },
			-------------------------------MOP----------------------------------------
			-- 涓咏
			{ spellID = 116660, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 玉魂
			{ spellID = 104993, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 钢铁之舞
			{ spellID = 120032, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 爆裂领主的毁灭瞄准镜
			{ spellID = 109085, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 血腥舞钢
			{ spellID = 142530, unitId = "player", caster = "all",    filter = "BUFF" },


			-- 专业技能
			-- 神经元弹簧
			{ spellID = 126734, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 氮气推进器
			{ spellID =  54861, unitId = "player", caster = "all",    filter = "BUFF" },
			-- 降落伞
			{ spellID =  55001, unitId = "player", caster = "all",    filter = "BUFF" },


			-- 饰品触发

			-- 暗月卡牌
			-- 骑士徽章                (爆击, 触发)
			{ spellID = 162917, unitId = "player", caster = "player", filter = "BUFF"},
			-- 战争之颅                (爆击, 触发)
			{ spellID = 162915, unitId = "player", caster = "player", filter = "BUFF"},
			-- 睡魔之袋                (爆击, 触发)
			{ spellID = 162919, unitId = "player", caster = "player", filter = "BUFF"},
			-- 羽翼沙漏                (精神, 触发)
			{ spellID = 162913, unitId = "player", caster = "player", filter = "BUFF"},

			-- PvP 饰品
			-- 全能
			{ spellID = 170397, unitId = "player", caster = "player", filter = "BUFF" },
			-- 生命上限
			{ spellID = 126697, unitId = "player", caster = "player", filter = "BUFF" },
			-- 敏捷
			{ spellID = 126690, unitId = "player", caster = "player", filter = "BUFF" },
			{ spellID = 126707, unitId = "player", caster = "player", filter = "BUFF" },
			-- 智力
			{ spellID = 126683, unitId = "player", caster = "player", filter = "BUFF" },
			{ spellID = 126705, unitId = "player", caster = "player", filter = "BUFF" },
			-- 力量
			{ spellID = 126679, unitId = "player", caster = "player", filter = "BUFF" },
			{ spellID = 126700, unitId = "player", caster = "player", filter = "BUFF" },

			-----------------------------橙戒特效--------------------------------------
			-- 大法师的灼热(690)
			-- 智力 
			{ spellID = 177159, unitId = "player", caster = "player", filter = "BUFF" },
			-- 力量 
			{ spellID = 177160, unitId = "player", caster = "player", filter = "BUFF" },
			-- 敏捷 
			{ spellID = 177161, unitId = "player", caster = "player", filter = "BUFF" },

			-- 大法师的炽燃(710)
			-- 智力 
			{ spellID = 177176, unitId = "player", caster = "player", filter = "BUFF" },
			-- 力量 
			{ spellID = 177175, unitId = "player", caster = "player", filter = "BUFF" },
			-- 敏捷 
			{ spellID = 177172, unitId = "player", caster = "player", filter = "BUFF" },			-- 坦克

			-- 尼萨姆斯
			{ spellID = 187616, unitID = "player", caster = "player", filter = "BUFF" },
			-- 萨克图斯
			{ spellID = 187617, unitID = "player", caster = "player", filter = "BUFF" },
			-- 伊瑟拉鲁斯
			{ spellID = 187618, unitID = "player", caster = "player", filter = "BUFF" },
			-- 索拉苏斯
			{ spellID = 187619, unitID = "player", caster = "player", filter = "BUFF" },
			-- 玛鲁斯
			{ spellID = 187620, unitID = "player", caster = "player", filter = "BUFF" },


			-------------------------------WOD-----------------------------------------
			-- 重击护符                (急速, 触发)
			{ spellID = 177102, unitId = "player", caster = "player", filter = "BUFF" },
			-- 爆裂熔炉之门            (精通, 触发)
			{ spellID = 177056, unitId = "player", caster = "player", filter = "BUFF" },
			-- 无懈合击石板            (护甲, 使用)
			{ spellID = 176873, unitId = "player", caster = "player", filter = "BUFF" },
			-- 不眠奥术精魂            (护甲, 触发)
			{ spellID = 177053, unitId = "player", caster = "player", filter = "BUFF" },
			-- 石化食肉孢子            (精通, 触发)
			{ spellID = 165824, unitId = "player", caster = "player", filter = "BUFF" },
			-- 普尔的盲目之眼          (精通, 使用)
			{ spellID = 176876, unitId = "player", caster = "player", filter = "BUFF" },
			-- 齐布的愚忠              (生命, 使用)
			{ spellID = 176460, unitId = "player", caster = "player", filter = "BUFF" },
			-- 岩心雕像                (爆击, 触发)
			{ spellID = 176982, unitId = "player", caster = "player", filter = "BUFF" },
			-------------------------------MOP-----------------------------------------
			-- 狂妄之诅咒              (爆击, 使用)
			--{ spellID =     , unitId = "player", caster = "player", filter = "BUFF" },
			-- 鲁克的不幸护符          (减伤, 使用)
			{ spellID = 146343, unitId = "player", caster = "player", filter = "BUFF" },
			-- 砮皂之毅                (躲闪, 使用)
			{ spellID = 146344, unitId = "player", caster = "player", filter = "BUFF" },
			-- 季鹍的复苏之风          (生命, 触发)
			{ spellID = 138973, unitId = "player", caster = "player", filter = "BUFF" },
			-- 赞达拉之韧              (生命, 使用)
			{ spellID = 126697, unitId = "player", caster = "player", filter = "BUFF" },
			-- 嗜血者的精致小瓶        (精通, 触发)
			{ spellID = 138864, unitId = "player", caster = "player", filter = "BUFF" },
			-- 影踪突袭营的坚定护符    (躲闪, 使用)
			{ spellID = 138728, unitId = "player", caster = "player", filter = "BUFF" },
			-- 梦魇残片                (躲闪, 触发)
			{ spellID = 126646, unitId = "player", caster = "player", filter = "BUFF" },
			-- 龙血之瓶                (躲闪, 触发)
			{ spellID = 126533, unitId = "player", caster = "player", filter = "BUFF" },
			-- 玉质军阀俑              (精通, 使用)
			{ spellID = 126597, unitId = "player", caster = "player", filter = "BUFF" },

			-- 物理敏捷DPS
			-------------------------------WOD-----------------------------------------
			-- 蜂鸣黑铁触发器          (爆击, 触发)
			{ spellID = 177067, unitId = "player", caster = "player", filter = "BUFF" },
			-- 跃动的山脉之心          (溅射, 使用)
			{ spellID = 176878, unitId = "player", caster = "player", filter = "BUFF" },
			-- 多肉龙脊奖章            (急速, 触发)
			{ spellID = 177035, unitId = "player", caster = "player", filter = "BUFF" },
			-- 毁灭之鳞                (溅射, 触发)
			{ spellID = 177038, unitId = "player", caster = "player", filter = "BUFF" },
			-- 双面幸运金币            (敏捷, 使用)
			{ spellID = 177597, unitId = "player", caster = "player", filter = "BUFF" },
			-- 黑心执行者勋章          (溅射, 触发)
			{ spellID = 176984, unitId = "player", caster = "player", filter = "BUFF" },
			-------------------------------MOP-----------------------------------------
			-- 既定之天命              (敏捷, 触发)
			{ spellID = 146308, unitId = "player", caster = "player", filter = "BUFF" },
			-- 哈洛姆的护符            (敏捷, 触发)
			{ spellID = 148903, unitId = "player", caster = "player", filter = "BUFF" },
			-- 暴怒之印                (敏捷, 触发)
			{ spellID = 148896, unitId = "player", caster = "player", filter = "BUFF" },
			-- 滴答作响的黑色雷管      (敏捷, 触发)
			{ spellID = 146310, unitId = "player", caster = "player", filter = "BUFF" },
			-- 雪怒之律                (爆击, 触发)
			{ spellID = 146312, unitId = "player", caster = "player", filter = "BUFF" },
			-- 邪恶魂能                (敏捷, 触发)
			{ spellID = 138938, unitId = "player", caster = "player", filter = "BUFF" },
			-- 杀戮护符                (急速, 触发)
			{ spellID = 138895, unitId = "player", caster = "player", filter = "BUFF" },
			-- 重生符文                (转换, 触发)
			{ spellID = 139120, unitId = "player", caster = "player", filter = "BUFF" },
			{ spellID = 139121, unitId = "player", caster = "player", filter = "BUFF" },
			{ spellID = 139117, unitId = "player", caster = "player", filter = "BUFF" },
			-- 雷纳塔基的灵魂符咒      (敏捷, 触发)
			{ spellID = 138756, unitId = "player", caster = "player", filter = "BUFF" },
			-- 影踪突袭营的邪恶护符    (敏捷, 触发)
			{ spellID = 138699, unitId = "player", caster = "player", filter = "BUFF" },
			-- 飞箭奖章                (爆击, 使用)
			{ spellID = 136086, unitId = "player", caster = "player", filter = "BUFF" },
			-- 萦雾之恐                (爆击, 触发)
			{ spellID = 126649, unitId = "player", caster = "player", filter = "BUFF" },
			-- 玉质盗匪俑              (急速, 使用)
			{ spellID = 126599, unitId = "player", caster = "player", filter = "BUFF" },
			-- 群星之瓶                (敏捷, 触发)
			{ spellID = 126554, unitId = "player", caster = "player", filter = "BUFF" },

			-- 物理力量DPS
			-------------------------------WOD-----------------------------------------
			-- 熔炉主管的徽记          (爆击, 触发)
			{ spellID = 177096, unitId = "player", caster = "player", filter = "BUFF" },
			-- 尖啸之魂号角            (精通, 触发)
			{ spellID = 177042, unitId = "player", caster = "player", filter = "BUFF" },
			-- 抽搐暗影之瓶            (溅射, 使用)
			{ spellID = 176874, unitId = "player", caster = "player", filter = "BUFF" },
			-- 泰克图斯的脉动之心      (爆击, 触发)
			{ spellID = 177040, unitId = "player", caster = "player", filter = "BUFF" },
			-- 奇亚诺斯的剑鞘          (力量, 使用)
			{ spellID = 177189, unitId = "player", caster = "player", filter = "BUFF" },
			-- 活山之尘                (全能, 触发)
			{ spellID = 176974, unitId = "player", caster = "player", filter = "BUFF" },
			-------------------------------MOP-----------------------------------------
			-- 迦拉卡斯的邪恶之眼      (力量, 触发)
			{ spellID = 146245, unitId = "player", caster = "player", filter = "BUFF" },
			-- 索克的尾巴尖            (力量, 触发)
			{ spellID = 146250, unitId = "player", caster = "player", filter = "BUFF" },
			-- 斯基尔的沁血护符        (力量, 触发)
			{ spellID = 146285, unitId = "player", caster = "player", filter = "BUFF" },
			-- 融火之核                (力量, 触发)
			{ spellID = 148899, unitId = "player", caster = "player", filter = "BUFF" },
			-- 天神迅捷                (急速, 触发)
			{ spellID = 146296, unitId = "player", caster = "player", filter = "BUFF" },
			-- 季鹍的传说之羽          (力量, 触发)
			{ spellID = 138759, unitId = "player", caster = "player", filter = "BUFF" },
			-- 赞达拉之火              (力量, 触发)
			{ spellID = 138958, unitId = "player", caster = "player", filter = "BUFF" },
			-- 普莫迪斯的狂怒咒符      (力量, 触发)
			{ spellID = 138870, unitId = "player", caster = "player", filter = "BUFF" },
			-- 双后的凝视              (爆击, 触发)
			{ spellID = 139170, unitId = "player", caster = "player", filter = "BUFF" },
			-- 破盔者奖章              (爆击, 使用)
			{ spellID = 136084, unitId = "player", caster = "player", filter = "BUFF" },
			-- 影踪突袭营的野蛮护符    (力量, 触发)
			{ spellID = 138702, unitId = "player", caster = "player", filter = "BUFF" },
			-- 黑雾漩涡                (急速, 触发)
			{ spellID = 126657, unitId = "player", caster = "player", filter = "BUFF" },
			-- 雷神的遗诏              (力量, 触发)
			{ spellID = 126582, unitId = "player", caster = "player", filter = "BUFF" },
			-- 玉质御者俑              (力量, 使用)
			{ spellID = 126599, unitId = "player", caster = "player", filter = "BUFF" },
			-- 铁腹炒锅                (急速, 使用)
			{ spellID = 129812, unitId = "player", caster = "player", filter = "BUFF" },
			
			-- 法系DPS
			-------------------------------WOD-----------------------------------------
			-- 黑石微型坩埚            (爆击, 触发)
			{ spellID = 177081, unitId = "player", caster = "player", filter = "BUFF" },
			-- 达玛克的无常护符        (急速, 触发)
			{ spellID = 177051, unitId = "player", caster = "player", filter = "BUFF" },
			-- 鬣蜥人灵魂容器          (爆击, 触发)
			{ spellID = 177046, unitId = "player", caster = "player", filter = "BUFF" },
			-- 科普兰的清醒            (法强, 使用)
			{ spellID = 177594, unitId = "player", caster = "player", filter = "BUFF" },
			-- 虚无碎片                (急速 使用)
			{ spellID = 176875, unitId = "player", caster = "player", filter = "BUFF" },
			-- 狂怒之心                (急速, 触发)
			{ spellID = 176980, unitId = "player", caster = "player", filter = "BUFF" },
			-------------------------------MOP-----------------------------------------
			-- 伊墨苏斯的净化之缚      (智力, 触发)
			{ spellID = 146046, unitId = "player", caster = "player", filter = "BUFF" },
			-- 卡德里斯的剧毒图腾      (智力, 触发)
			{ spellID = 148906, unitId = "player", caster = "player", filter = "BUFF" },
			-- 亚煞极的黑暗之血        (智力, 触发)
			{ spellID = 146184, unitId = "player", caster = "player", filter = "BUFF" },
			-- 狂怒水晶                (智力, 触发)
			{ spellID = 148897, unitId = "player", caster = "player", filter = "BUFF" },
			-- 玉珑之噬                (爆击, 触发)
			{ spellID = 146218, unitId = "player", caster = "player", filter = "BUFF" },
			-- 雷神的精准之视          (智力, 触发)
			{spellID =  138963, unitId = "player", caster = "player", filter = "BUFF" },
			-- 张叶的辉煌精华          (智力, 触发)
			{ spellID = 139133, unitId = "player", caster = "player", filter = "BUFF" },
			-- 九头蛇之息              (智力, 触发)
			{ spellID = 138898, unitId = "player", caster = "player", filter = "BUFF" },
			-- 乌苏雷的最终抉择        (智力, 触发)
			{ spellID = 138786, unitId = "player", caster = "player", filter = "BUFF" },
			-- 影踪突袭营的烈性咒符    (急速, 触发)
			{ spellID = 138703, unitId = "player", caster = "player", filter = "BUFF" },
			-- 惊怖精华                (急速, 触发)
			{ spellID = 126659, unitId = "player", caster = "player", filter = "BUFF" },
			-- 宇宙之光                (智力, 触发)
			{ spellID = 126577, unitId = "player", caster = "player", filter = "BUFF" },
			
			-- 治疗
			-------------------------------WOD-----------------------------------------
			-- 自动修复灭菌器          (急速, 触发)
			{ spellID = 177086, unitId = "player", caster = "player", filter = "BUFF" },
			-- 铁刺狗玩具              (精神, 触发)
			{ spellID = 177060, unitId = "player", caster = "player", filter = "BUFF" },
			-- 元素师的屏蔽护符        (溅射, 触发)
			{ spellID = 177063, unitId = "player", caster = "player", filter = "BUFF" },
			-- 腐蚀治疗徽章            (急速, 使用)
			{ spellID = 176879, unitId = "player", caster = "player", filter = "BUFF" },
			-- 完美的活性蘑菇          (爆击, 触发)
			{ spellID = 176978, unitId = "player", caster = "player", filter = "BUFF" },
			-- 永燃蜡烛                (法力, 使用)
			{ spellID = 177592, unitId = "player", caster = "player", filter = "BUFF" },
			-------------------------------MOP-----------------------------------------
			-- 傲慢之棱光囚笼          (智力, 触发)
			{ spellID = 146314, unitId = "player", caster = "player", filter = "BUFF" },
			-- 纳兹戈林的抛光勋章      (智力, 触发)
			{ spellID = 148908, unitId = "player", caster = "player", filter = "BUFF" },
			-- 索克的酸蚀之牙          (智力, 触发)
			{ spellID = 148911, unitId = "player", caster = "player", filter = "BUFF" },
			-- 间歇性变异平衡器        (精神,触发)
			{ spellID = 146317, unitId = "player", caster = "player", filter = "BUFF" },
			-- 九头蛇卵的铭文袋        (吸收,触发)
			{ spellID = 140380, unitId = "player", caster = "player", filter = "BUFF" },
			-- 赫利东的垂死之息        (法力,触发)
			{ spellID = 138856, unitId = "player", caster = "player", filter = "BUFF" },
			-- 骄阳之魂                (精神,触发)
			{ spellID = 126640, unitId = "player", caster = "player", filter = "BUFF" },
			-- 秦希的偏振之印          (智力, 触发)
			{ spellID = 126588, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{ 
			name = "玩家重要Buff",
			direction = "RIGHT",
			size = 40,
			setpoint = {unpack(FG["filger_position"].imbuff)},
			mode = "ICON",

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
			{ spellID =  26297, unitID = "player", caster = "player", filter = "BUFF"},
			-- 石像形态 
			{ spellID =  65116, unitID = "player", caster = "player", filter = "BUFF"},
			-- 血性狂怒 
			{ spellID =  20572, unitID = "player", caster = "player", filter = "BUFF"},
			{ spellID =  33697, unitID = "player", caster = "player", filter = "BUFF"},
			-- 疾步夜行 
			{ spellID =  68992, unitID = "player", caster = "player", filter = "BUFF"},
			-- 纳鲁的赐福 
			{ spellID =  28880, unitID = "player", caster = "all",    filter = "BUFF"},

			-- Other

			-- 破咒祝福
			{ spellID = 204018, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 拯救祝福
			{ spellID = 204013, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 保护祝福
			{ spellID =   1022, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 自由祝福
			{ spellID =   1044, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 牺牲祝福
			{ spellID =   6940, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 强效王者祝福
			{ spellID = 203538, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 强效智慧祝福
			{ spellID = 203539, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 强效力量祝福
			{ spellID = 203528, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 虔诚光环
			{ spellID =  31821, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 黑暗
			{ spellID = 209426, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 漂浮术
			{ spellID =   1706, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 身心合一
			{ spellID =  65081, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 天堂之羽
			{ spellID = 121557, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 吸血鬼的拥抱
			{ spellID =  15286, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 真言术：障
			{ spellID =  81782, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 神圣赞美诗
			{ spellID =  64843, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 守护之魂
			{ spellID =  47788, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 痛苦压制
			{ spellID =  33206, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 铁木树皮
			{ spellID = 102342, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 宁静
			{ spellID =    740, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 狂奔怒吼
			{ spellID =  77764, unitID = "player", caster = "all",    filter = "BUFF"},
			{ spellID =  77761, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 命令怒吼
			{ spellID =  97463, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 灵魂链接图腾
			{ spellID =  98007, unitID = "player", caster = "all",    filter = "BUFF"}, 
			-- 风行图腾
			{ spellID = 114896, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 作茧缚命
			{ spellID = 116849, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 缓落术
			{ spellID =    130, unitID = "player", caster = "all",    filter = "BUFF"},
			-- 爆燃冲刺
			{ spellID = 111400, unitID = "player", caster = "player", filter = "BUFF"},


			-- 火箭鞋漏油
			{ spellID =94794, unitID = "player", caster = "player", filter = "DEBUFF"},
		},
		{ 
			name = "玩家PVPDebuff",
			direction = "RIGHT",
			size = 40,
			setpoint = {unpack(FG["filger_position"].pvpdebuff)},
			mode = "ICON",

			-- 死亡骑士
			-- 撕扯
			{ spellID =  91800, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 蛮兽打击
			{ spellID =  91797, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 窒息
			{ spellID = 108194, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 绞袭
			{ spellID =  47476, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 寒冰锁链
			{ spellID =  45524, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 德鲁伊
			-- 旋风
			{ spellID =  33786, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 斜掠(猫)
			{ spellID = 163505, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 割碎
			{ spellID =  22570, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 日光术
			{ spellID =  78675, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 纠缠根须
			{ spellID =    339, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 无法移动
			{ spellID =  45334, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 感染伤口
			{ spellID =  58180, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 猎人
			-- 胁迫
			{ spellID =  24394, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰冻陷阱
			{ spellID =   3355, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 翼龙钉刺
			{ spellID =  19386, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 险境求生
			{ spellID = 136634, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 震荡射击
			{ spellID =   5116, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 虚空震击 (虚空鳐)
			{ spellID =  44957, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰霜吐息 (奇美拉)
			{ spellID =  54644, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 碎踝 (鳄魚)
			{ spellID =  50433, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 时间扭曲 
			{ spellID =  35346, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 诱捕
			{ spellID = 135373, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰冻术
			{ spellID =  33395, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 法师
			-- 变形术
			{ spellID =    118, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰霜之环
			{ spellID =  82691, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 龙息术
			{ spellID =  31661, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰霜新星
			{ spellID =    122, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰锥术
			{ spellID =    120, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 减速
			{ spellID =  31589, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 冰冻
			{ spellID =   7321, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 武僧
			-- 分筋错骨
			{ spellID = 115078, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 扫堂腿
			{ spellID = 119381, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 圣骑士
			-- 制裁之锤
			{ spellID =    853, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 忏悔
			{ spellID =  20066, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 盲目之光
			{ spellID = 105421, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 复仇者之盾
			{ spellID =  31935, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 牧师
			-- 心灵尖啸
			{ spellID =   8122, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 心灵惊骇
			{ spellID =  64044, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 罪与罚
			{ spellID =  87204, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 沉默
			{ spellID =  15487, unitID = "player", caster = "all", filter = "DEBUFF" },

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

			-- 术士
			-- 暗影之怒
			{ spellID =  30283, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 巨斧投掷 (恶魔守卫)
			{ spellID =  89766, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 恐惧
			{ spellID = 118699, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 恐惧嚎叫
			{ spellID =   5484, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 死亡缠绕
			{ spellID =   6789, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 诱惑 (魅魔)
			{ spellID =   6358, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 迷魅 
			{ spellID = 115268, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 痛苦无常
			{ spellID =  31117, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 燃烧
			{ spellID =  17962, unitID = "player", caster = "all", filter = "DEBUFF" },

			-- 战士
			-- 风暴之锤
			{ spellID = 132169, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 震荡波
			{ spellID = 132168, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 错愕怒吼
			{ spellID = 107566, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 破胆怒吼
			{ spellID =   5246, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 断筋
			{ spellID =   1715, unitID = "player", caster = "all", filter = "DEBUFF" },
			-- 刺耳怒吼
			{ spellID =  12323, unitID = "player", caster = "all", filter = "DEBUFF" },
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
			name = "玩家Debuff",
			direction = "RIGHT",
			size = 40,
			setpoint = {unpack(FG["filger_position"].alldebuff)},
			mode = "ICON",


			-- 心智 [尤格萨隆]
			{ spellID =  63050, unitId = "player", caster = "all", filter = "DEBUFF"},


			-- DS
			-- Morchok
			-- (擊碎護甲)
			{ spellID = 103687, unitId = "player", caster = "all", filter = "DEBUFF" }, 
			-- Zon'ozz
			-- (崩解之影)
			{ spellID = 103434, unitId = "player", caster = "all", filter = "DEBUFF" }, 
			-- Yor'sahj
			-- (深度腐化)
			{ spellID = 105171, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 103628, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- 虛無箭)
			{ spellID = 104849, unitId = "player", caster = "all", filter = "DEBUFF" },  
			-- Hagara
			-- (寒冰之墓)
			{ spellID = 104451, unitId = "player", caster = "all", filter = "DEBUFF" },  
			-- Blackhorn
			-- (破甲攻擊)
			{ spellID = 108043, unitId = "player", caster = "all", filter = "DEBUFF" },  
			-- Spine
			-- 燃燒血漿
			{ spellID = 105479, unitId = "player", caster = "all", filter = "DEBUFF" }, 
			-- (燃燒血漿)
			{ spellID = 109379, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- (熾熱之握)
			{ spellID = 105490, unitId = "player", caster = "all", filter = "DEBUFF" },  
			-- Madness 
			-- (退化咬擊)
			{ spellID = 105841, unitId = "player", caster = "all", filter = "DEBUFF" }, 
			-- (極熾高熱) 
			{ spellID = 105445, unitId = "player", caster = "all", filter = "DEBUFF" }, 
			-- (刺穿) 
			{ spellID = 106444, unitId = "player", caster = "all", filter = "DEBUFF" },  
			-- 凋零之光
			{ spellID = 105925, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 109075, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- 寄生体
			{ spellID = 108601, unitId = "player", caster = "all", filter = "DEBUFF" },



			------------------------------------MOP----------------------------------
			-- 魔古山宝库 896
			
			-- [石头守卫]
			-- 紫晶之池
			{ spellID = 116235, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 红玉锁链
			{ spellID = 130395, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- [受诅者魔封]
			--  野性火花
			{ spellID = 116784, unitId = "player", caster = "all", filter = "DEBUFF"},
			--  奥术回响
			{ spellID = 116417, unitId = "player", caster = "all", filter = "DEBUFF"},
			--  废灵壁垒
			{ spellID = 115856, unitId = "player", caster = "all", filter = "BUFF"  },
			--  反射罩
			{ spellID = 115911, unitId = "player", caster = "all", filter = "BUFF"  },
			
			--  [缚灵者戈拉亚]
			--  巫毒娃娃
			{ spellID = 122151, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 灵魂越界
			{ spellID = 116166, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- [伊拉贡]
			-- 能量超载
			{ spellID = 117878, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 封闭回路
			{ spellID = 117949, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- [皇帝的意志]
			-- 专注打击
			{ spellID = 116525, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 专注能量
			{ spellID = 116829, unitId = "player", caster = "all", filter = "DEBUFF"},



			-- 恐惧之心 897
			
			-- 1	[皇家宰相佐尔洛克]
			--  吐气
			{ spellID = 122761, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 2	[刀锋领主塔亚克]
			-- 压制突袭
			{ spellID = 123474, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 疾风步
			{ spellID = 123175, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 无影击
			{ spellID = 123017, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 3	[加拉隆]
			-- 信息素
			{ spellID = 123092, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 4	[风领主梅尔加拉克]
			-- 风爆弹
			{ spellID = 131813, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 琥珀监牢
			{ spellID = 121885, unitId = "player", caster = "all", filter = "DEBUFF"}, 
			-- 腐蚀树脂
			{ spellID = 122064, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 5	[琥珀塑形者昂舒克]
			-- 燃烧的琥珀
			{ spellID = 122504, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 寄生增长
			{ spellID = 121949, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 6	[大女皇夏柯希尔]
			--  女皇邪眼
			{ spellID = 123707, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 粘稠树脂
			{ spellID = 124097, unitId = "player", caster = "all", filter = "DEBUFF"},
			--  浸毒护甲
			{ spellID = 124821, unitId = "player", caster = "all", filter = "DEBUFF"},
			--  恐惧吞噬
			{ spellID = 124849, unitId = "player", caster = "all", filter = "DEBUFF"},
			--  死亡幻像
			{ spellID = 124862, unitId = "player", caster = "all", filter = "DEBUFF"},
			--  恐惧之心
			{ spellID = 123845, unitId = "player", caster = "all", filter = "DEBUFF"},



			-- 永春台 886
			
			-- 1	[无尽守护者]
			--  闪电牢笼
			{ spellID = 111850, unitId = "player", caster = "all", filter = "DEBUFF"},
			--  大地污染
			{ spellID = 117986, unitId = "player", caster = "all", filter = "DEBUFF"},
			--  大型堕落精华
			{ spellID = 117905, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 2	[烛龙]
			--  恐惧之影
			{ spellID = 122768, unitId = "player", caster = "all", filter = "DEBUFF"},
			--  暗影吐息
			{ spellID = 122752, unitId = "player", caster = "all", filter = "DEBUFF"},
			--  暗影恐怖
			{ spellID = 123011, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 3	[雷施]
			--  喷射
			{ spellID = 123121, unitId = "player", caster = "all", filter = "DEBUFF"},
			--  恐怖迷雾
			{ spellID = 123705, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 4	[惧之煞]
			--  无畏
			{ spellID = 118977, unitId = "player", caster = "all", filter = "BUFF"  },


			-- 雷电王座 930
			
			-- 1	[击碎者金罗克] --
			-- 专注闪电
			{ spellID = 137422, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 电离反应
			{ spellID = 138732, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 静电创伤
			{ spellID = 138349, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 雷霆投掷
			{ spellID = 137371, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 2	[郝利东] --
			-- 三重穿刺
			{ spellID = 136767, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 冲锋
			{ spellID = 136769, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 流沙陷阱
			{ spellID = 136723, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 活化毒素
			{ spellID = 136646, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 寒冰宝珠
			{ spellID = 136573, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 闪电新星
			{ spellID = 136490, unitId = "player", caster = "all", filter = "DEBUFF"},
         
			-- 3	[长者议会] --
			-- 灵魂残片
			{ spellID = 137641, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- M标记灵魂
			{ spellID = 137359, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 扭曲命运
			{ spellID = 137972, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 冰寒突击
			{ spellID = 136903, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 霜寒刺骨
			{ spellID = 136922, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 刺骨之寒
			{ spellID = 136992, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 4	[托多斯] --
			-- 百裂爪
			{ spellID = 136753, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 晶化甲壳
			{ spellID = 137633, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 晶化甲壳：临界值！
			{ spellID = 140701, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 5	[墨格瑞拉]
			-- 燃烧血肉
			{ spellID = 137731, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 寒冰洪流
			{ spellID = 139857, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 139889, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 燃烬
			{ spellID = 134391, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 139822, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 6	[季鹍] --
			-- 爪掠
			{ spellID = 134366, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 灵巧之翼
			{ spellID = 134339, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 7	[遗忘者杜鲁姆] --
			-- 严重致伤
			{ spellID = 133767, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 蓝光追踪
			{ spellID = 139202, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 红光追踪
			{ spellID = 139204, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 强光
			{ spellID = 133738, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 纠缠凝视
			{ spellID = 134044, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 吸血
			{ spellID = 133795, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 8	[普利莫修斯] --
			{ spellID = 136050, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 9	[黑暗意志] --
			-- 爆炸猛击
			{ spellID = 138569, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 猩红追击
			{ spellID = 138480, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 心能之环
			{ spellID = 136954, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 物质交换
			{ spellID = 138618, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 10	[铁穹] --
			-- 穿刺
			{ spellID = 134691, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 烧灼
			{ spellID = 134647, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 11	[魔古双后] --
			-- 寒冷阴影
			{ spellID = 137440, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 烈焰刃舞
			{ spellID = 137408, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 堕落治疗
			{ spellID = 137360, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 梦魇兽
			{ spellID = 137375, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 12	[雷神] --
			-- 斩首
			{ spellID = 135000, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 静电冲击
			{ spellID = 135695, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 超载
			{ spellID = 136295, unitId = "player", caster = "all", filter = "DEBUFF"},



			-- 决战奥格瑞玛 Siege Of Orgrimmar 953

			-- 1	伊墨苏斯 [Immerseus]
			-- 邪煞池
			{ spellID = 143297, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 腐蚀冲击
			{ spellID = 143436, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 煞能腐蚀
			{ spellID = 143579, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 2	堕落的守护者 [FallenProtectors]
			-- 锁喉
			{ spellID = 143198, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 苦痛印记
			{ spellID = 143840, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 暗影虚弱
			{ spellID = 144176, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 煞能灼烧
			{ spellID = 143423, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 3	诺鲁什 [Norushen]
			-- 净化
			{ spellID = 144452, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 自惑
			{ spellID = 146124, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 纠缠腐蚀
			{ spellID = 144514, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 4	傲之煞 [ShaofPride]
			-- 受损自尊
			{ spellID = 144358, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 傲气光环
			{ spellID = 146817, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 投影
			{ spellID = 146822, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 泰坦之赐
			{ spellID = 146594, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 泰坦之力
			{ spellID = 144364, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 动摇的决心 H
			{ spellID = 147207, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 5	迦拉卡斯 [Galakras]
			-- 毒性云雾
			{ spellID = 147705, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 烈焰箭
			{ spellID = 146765, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 迦拉克隆之焰 (点名)
			{ spellID = 147068, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 迦拉克隆之焰 (debuff)
			{ spellID = 147029, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 6	钢铁战蝎 [IronJuggernaut]
			-- 燃烧护甲
			{ spellID = 144467, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 爆裂焦油
			{ spellID = 144498, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 切割激光
			{ spellID = 146325, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 7	库卡隆黑暗萨满 [KorkronDarkShaman]
			-- 冰霜风暴打击
			{ spellID = 144215, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 撕裂
			{ spellID = 144304, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 剧毒之雾
			{ spellID = 144089, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 钢铁囚笼 
			{ spellID = 144330, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 8	纳兹戈林将军 [GeneralNazgrim]
			-- 碎甲重击
			{ spellID = 143494, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 碎骨重锤
			{ spellID = 143638, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 刺客印记
			{ spellID = 143480, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 猎人印记
			{ spellID = 143882, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 9	马尔考罗克 [Malkorok]
			-- 致命打击
			{ spellID = 142990, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 10	潘达利亚战利品 [SpoilsOfPandria]
			-- 设置炸药
			{ spellID = 145987, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 11	嗜血的索克 [ThokTheBloodthirsty]
			-- 恐慌
			{ spellID = 143766, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 灼热吐息
			{ spellID = 143767, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 酸性吐息
			{ spellID = 143780, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 冰冻吐息
			{ spellID = 143773, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 锁定
			{ spellID = 143445, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 冰冻之血
			{ spellID = 143800, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 12	攻城匠师黑索 [SiegecrafterBlackfuse]
			-- 电荷冲击
			{ spellID = 143385, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 过热
			{ spellID = 143856, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 图像识别
			{ spellID = 144236, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 13	卡拉克西英杰 [ParagonsOfTheKlaxxi]
			-- 注射
			{ spellID = 143339, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 红色毒素
			{ spellID = 142533, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 蓝色毒素
			{ spellID = 142532, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 黄色毒素
			{ spellID = 142534, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 凿击
			{ spellID = 143939, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 盾击
			{ spellID = 143974, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 催眠术
			{ spellID = 142671, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 瞄准
			{ spellID = 142948, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 炎界的火线
			{ spellID = 142808, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 14	加尔鲁什·地狱咆哮 [GarroshHellscream]
			-- 绝望之握
			{ spellID = 145183, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 强化绝望之握
			{ spellID = 145195, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 绝望之破
			{ spellID = 145213, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 信念
			{ spellID = 148994, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 勇气
			{ spellID = 148983, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 希望
			{ spellID = 149004, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 亵渎(P2)
			{ spellID = 144762, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 亵渎(P3)
			{ spellID = 144817, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 亚煞极之触
			{ spellID = 145065, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 強化亚煞极之触
			{ spellID = 145171, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 凝视 H
			{ spellID = 147665, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 液态火焰 H
			{ spellID = 147136, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 恶意 H
			{ spellID = 147209, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 恶意冲击 H
			{ spellID = 147235, unitId = "player", caster = "all", filter = "DEBUFF"},
			
			-- 15	其它 [SooTrash]
			-- 断骨
			{ spellID = 147200, unitId = "player", caster = "all", filter = "DEBUFF"},



			----------------------------------WOD------------------------------------
			--  [970]  悬槌堡
			-- 0	小怪
			-- 污染之爪
			{ spellID = 175601, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 剧毒辐射
			{ spellID = 172069, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 毁灭符文
			{ spellID =  56037, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 瓦解符文
			{ spellID = 175654, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 冰冻核心
			{ spellID = 174404, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 野火
			{ spellID = 173827, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 熔火炸弹
			{ spellID = 161635, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 1	卡加斯.刃拳
			-- 烈焰喷射
			{ spellID = 159311, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 抓钩
			{ spellID = 159188, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 狂暴冲锋
			{ spellID = 158986, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 钢铁炸弹
			{ spellID = 159386, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 迸裂创伤 (仅坦克)
			{ spellID = 159178, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 穿刺 (DoT)
			{ spellID = 159113, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 锁链投掷
			{ spellID = 159947, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 暴虐酒
			{ spellID = 159413, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 邪恶吐息
			{ spellID = 160521, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 搜寻猎物
			{ spellID = 162497, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 2	屠夫
			-- 捶肉槌
			{ spellID = 156151, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 龟裂创伤
			{ spellID = 156152, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 切肉刀
			{ spellID = 156143, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 白鬼硫酸
			{ spellID = 163046, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 3	泰克图斯
			-- 晶化弹幕
			{ spellID = 162346, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 162370, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 石化
			{ spellID = 162892, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 4	布兰肯斯波
			-- 感染孢子
			{ spellID = 163242, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 蚀脑真菌
			{ spellID = 160179, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 死疽吐息
			{ spellID = 159220, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 脉冲高热
			{ spellID = 163666, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 溃烂
			{ spellID = 163241, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 滑溜溜的苔藓
			{ spellID = 163590, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 5	独眼魔双子
			-- 致衰咆哮
			{ spellID = 158026, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 防御削弱
			{ spellID = 159709, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 受伤
			{ spellID = 155569, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 烈焰
			{ spellID = 158241, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 奥能动荡
			{ spellID = 163372, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 奥术之伤
			{ spellID = 167200, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 6	克拉戈
			-- 腐蚀能量
			{ spellID = 161242, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 压制力场
			{ spellID = 161345, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 魔能散射:冰霜
			{ spellID = 172813, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 魔能散射:暗影
			{ spellID = 162184, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 魔能散射:火焰
			{ spellID = 162185, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 魔能散射:奥术
			{ spellID = 162186, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 魔能散射:邪能
			{ spellID = 172895, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 172917, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 统御之力
			{ spellID = 163472, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 废灵标记
			{ spellID = 172886, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 废灵壁垒
			{ spellID = 163134, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 7	元首马尔高克
			-- 混沌标记
			{ spellID = 158605, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 混沌标记:偏移
			{ spellID = 164176, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 混沌标记:强固
			{ spellID = 164178, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 混沌标记:复制
			{ spellID = 164191, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 拘禁
			{ spellID = 158619, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 碾碎护甲
			{ spellID = 158553, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 锁定
			{ spellID = 157763, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 减速
			{ spellID = 157801, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 毁灭共鸣
			{ spellID = 159200, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 174106, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 烙印
			{ spellID = 156225, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 烙印:偏移
			{ spellID = 164004, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 烙印:强固
			{ spellID = 164005, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 烙印:复制
			{ spellID = 164006, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 蔓延暗影(M)
			{ spellID = 176533, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 深渊凝视(M)
			{ spellID = 176537, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 深渊凝视(爆炸)(M)
			{ spellID = 165595, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 无尽黑暗制(M)
			{ spellID = 165102, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 熵能冲击(M)
			{ spellID = 165116, unitId = "player", caster = "all", filter = "DEBUFF"},


			-- [988] 黑石铸造厂
			-- 1	Gruul 格鲁尔
			-- 炼狱切割
			{ spellID = 155080, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 压迫打击
			{ spellID = 155078, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 炼狱打击
			{ spellID = 162322, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 石化
			{ spellID = 155506, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 火耀石
			{ spellID = 165298, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 2	Oregorger 奥尔高格
			-- 呕吐黑石
			{ spellID = 156203, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 爆裂残片
			{ spellID = 156374, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 酸液洪流
			{ spellID = 156297, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 酸液巨口
			{ spellID = 173471, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 翻滚之怒
			{ spellID = 155900, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 3	Blast Furnace 爆裂熔炉
			-- 崩裂
			{ spellID = 156932, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 炸弹
			{ spellID = 178279, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 155192, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 174176, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 不稳定的火焰
			{ spellID = 176121, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 锁定
			{ spellID = 155196, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 熔渣池
			{ spellID = 155743, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 淬火
			{ spellID = 155240, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 高热
			{ spellID = 155242, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 熔化
			{ spellID = 155225, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 155223, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 4	Hans'gar and Franzok 汉斯加尔与弗兰佐克 
			-- 折脊碎椎
			{ spellID = 157139, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 干扰怒吼
			{ spellID = 160838, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 160845, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 160847, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 160848, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 灼热燃烧
			{ spellID = 155818, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 5	Flamebender Ka'graz 缚火者卡格拉兹 
			-- 锁定
			{ spellID = 154952, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 焦灼吐息
			{ spellID = 155074, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 火焰链接
			{ spellID = 155049, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 熔岩激流
			{ spellID = 154932, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 炽热光辉
			{ spellID = 155277, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 岩浆猛击
			{ spellID = 155314, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 升腾烈焰
			{ spellID = 163284, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 6	Kromog 克罗莫格 
			-- 扭曲护甲
			{ spellID = 156766, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 纠缠之地符文
			{ spellID = 157059, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 破碎大地符文
			{ spellID = 161839, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 161923, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 7	Beastlord Darmac 兽王达玛克
			-- 长矛钉刺
			{ spellID = 154960, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 狂乱撕扯
			{ spellID = 155061, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 162283, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 炼狱吐息
			{ spellID = 154989, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 爆燃
			{ spellID = 154981, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 炽燃利齿
			{ spellID = 155030, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 碾碎护甲
			{ spellID = 155236, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 高热弹片
			{ spellID = 155499, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 烈焰灌注
			{ spellID = 155657, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 地动山摇
			{ spellID = 159044, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 162277, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 8	Operator Thogar 主管索戈尔 
			-- 点燃
			{ spellID = 155921, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 实验型脉冲手雷
			{ spellID = 165195, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 灼疗之箭
			{ spellID = 160140, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 锯齿劈斩
			{ spellID = 155921, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 熔岩震击
			{ spellID = 156310, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 延时攻城炸弹
			{ spellID = 159481, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 燃烧
			{ spellID = 164380, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 热能冲击
			{ spellID = 164280, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 9	Iron Maidens 钢铁女武神 
			-- 急速射击
			{ spellID = 156631, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 穿透射击
			{ spellID = 164271, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 主炮轰击
			{ spellID = 158601, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 震颤暗影
			{ spellID = 156214, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 暗影猎杀
			{ spellID = 158315, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 鲜血仪式
			{ spellID = 159724, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 浸血觅心者
			{ spellID = 158010, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 致命投掷
			{ spellID = 158692, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 锁定
			{ spellID = 158702, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 堕落之血
			{ spellID = 158683, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 玛拉卡的血腥召唤
			{ spellID = 170405, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 苏卡的猎物
			{ spellID = 170395, unitId = "player", caster = "all", filter = "DEBUFF"},

			-- 10	Warlord Blackhand  黑手 
			-- 死亡标记
			{ spellID = 156096, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 锁定
			{ spellID = 156653, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 断骨
			{ spellID = 157354, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 熔渣冲击
			{ spellID = 156047, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 157018, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 157322, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 穿刺
			{ spellID = 156743, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 175020, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 巨力粉碎猛击
			{ spellID = 158054, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 燃烧
			{ spellID = 162490, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 156604, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 熔火熔渣
			{ spellID = 156401, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 烧伤
			{ spellID = 156404, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 燃烧射击
			{ spellID = 156772, unitId = "player", caster = "all", filter = "DEBUFF"},
			-- 投掷炉渣炸弹
			{ spellID = 157000, unitId = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 159179, unitId = "player", caster = "all", filter = "DEBUFF"},



			-- 地狱火堡垒
			-- 1	奇袭地狱火
			-- 邪火弹药
			{ spellID = 180079, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 啸风战斧
			{ spellID = 184369, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 颤抖！
			{ spellID = 184238, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 猛击
			{ spellID = 184243, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 导电冲击脉冲
			{ spellID = 185806, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 钻孔
			{ spellID = 180022, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 灼烧
			{ spellID = 185157, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 腐化虹吸
			{ spellID = 187655, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 2	钢铁掠夺者
			-- 献祭
			{ spellID = 182074, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 不稳定的宝珠
			{ spellID = 182001, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 炮击
			{ spellID = 182280, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 燃料尾痕
			{ spellID = 182003, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 迅猛突袭
			{ spellID = 179897, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 185242, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 易爆火焰炸弹
			{ spellID = 185978, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 火焰易伤
			{ spellID = 182373, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 3	考莫克
			-- 攫取之手
			{ spellID = 181345, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能之触
			{ spellID = 181321, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 爆裂冲击
			{ spellID = 181306, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪污碾压
			{ spellID = 187819, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 暗影血球
			{ spellID = 180270, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 炽热血球
			{ spellID = 185519, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪污血球
			{ spellID = 185521, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 暗影之池
			{ spellID = 181082, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 火焰之池
			{ spellID = 186559, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪污之池
			{ spellID = 186560, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 暗影残渣
			{ spellID = 181208, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 爆炸残渣
			{ spellID = 185686, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪恶残渣
			{ spellID = 185687, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 4	高阶地狱火议会
			-- 死灵印记
			{ spellID = 184449, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 184450, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 184676, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 185065, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 185066, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 堕落狂怒
			{ spellID = 184360, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 酸性创伤
			{ spellID = 184847, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 暗影收割
			{ spellID = 184652, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 污血
			{ spellID = 184357, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 血液沸腾
			{ spellID = 184355, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 5	基尔罗格·死眼
			-- 剖心飞刀
			{ spellID = 188929, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 180389, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能腐蚀
			{ spellID = 182159, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 184396, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 恶魔附身
			{ spellID = 180313, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 永痕的决心
			{ spellID = 180718, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 死亡幻象
			{ spellID = 181488, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 永恒的救赎
			{ spellID = 185563, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 碎甲
			{ spellID = 180200, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能烈焰
			{ spellID = 180575, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 撕裂嚎叫
			{ spellID = 183917, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 溅血
			{ spellID = 188852, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能腐液
			{ spellID = 184067, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 6	血魔
			-- 灵魂箭雨
			{ spellID = 180093, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 死亡之影
			{ spellID = 179864, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 血魔的腐化
			{ spellID = 179867, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 消化
			{ spellID = 181295, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 生命渴望
			{ spellID = 180148, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 毁灭之触
			{ spellID = 179977, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 末日井
			{ spellID = 179995, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能之怒
			{ spellID = 185189, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能烈焰
			{ spellID = 185190, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 命运相连
			{ spellID = 179908, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 179909, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 灵魂之池
			{ spellID = 186770, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 7	暗影领主艾斯卡
			-- 安苏之光
			{ spellID = 185239, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 幻影之伤
			{ spellID = 182325, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能焚化
			{ spellID = 182600, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 幻影之风
			{ spellID = 181957, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能飞轮
			{ spellID = 182200, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 182178, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 幻影邪能炸弹
			{ spellID = 179219, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能炸弹
			{ spellID = 181753, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 幻影腐蚀
			{ spellID = 181824, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 幻影焚化
			{ spellID = 187344, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 暗影之缚
			{ spellID = 185510, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 8	邪能领主扎昆
			-- 破碎之魂
			{ spellID = 189260, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 魂不附体
			{ spellID = 179407, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 潜伏能量
			{ spellID = 182008, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 玷污
			{ spellID = 189032, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 189031, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 189030, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 179711, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 轰鸣的裂隙
			{ spellID = 179428, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 毁灭之种
			{ spellID = 181508, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 181515, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能水晶
			{ spellID = 181653, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 枯竭灵魂
			{ spellID = 188998, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 9	祖霍拉克
			-- 邪蚀
			{ spellID = 186134, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 灵媒
			{ spellID = 186135, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪影屠戮
			{ spellID = 185656, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能炙烤
			{ spellID = 186073, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 虚空消耗
			{ spellID = 186063, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 魔能喷涌
			{ spellID = 186407, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 灵能涌动
			{ spellID = 186333, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪焰乱舞
			{ spellID = 186448, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 186453, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 凋零凝视
			{ spellID = 186785, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 186783, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 点燃
			{ spellID = 188208, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 黑洞
			{ spellID = 186547, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能锁链
			{ spellID = 186500, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 強化魔化锁链
			{ spellID = 189775, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 10	永恒者索克雷萨
			-- 粉碎防御
			{ spellID = 182038, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 易爆的邪能宝珠
			{ spellID = 189627, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 魔炎残渣
			{ spellID = 182218, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能牢笼
			{ spellID = 180415, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 183017, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 压倒能量
			{ spellID = 189540, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 堕落者之赐
			{ spellID = 184124, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 魅影重重
			{ spellID = 182769, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 暗言术：恶
			{ spellID = 184239, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 恶毒鬼魅
			{ spellID = 182900, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 无尽饥渴
			{ spellID = 188666, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 索克雷萨之咒
			{ spellID = 190776, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 11	暴君维哈里
			-- 凋零契印
			{ spellID = 180000, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 蔑视光环
			{ spellID = 179987, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 抑制光环
			{ spellID = 181683, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 怨恨光环
			{ spellID = 179993, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 腐蚀序列
			{ spellID = 180526, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 裂伤之触
			{ spellID = 180166, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 180164, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 谴责法令
			{ spellID = 182459, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 亵渎之地
			{ spellID = 180604, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 12	玛诺洛斯
			-- 军团诅咒
			{ spellID = 181275, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 末日印记
			{ spellID = 181099, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 末日之刺
			{ spellID = 181119, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 189717, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 玛洛诺斯之血
			{ spellID = 182171, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 穿刺之伤
			{ spellID = 184252, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 191231, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 巨力冲击
			{ spellID = 181359, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 玛诺洛斯凝视
			{ spellID = 181597, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 暗影之力
			{ spellID = 181841, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 强化玛诺洛斯凝视
			{ spellID = 182006, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 强化暗影之力
			{ spellID = 182088, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 凝视暗影
			{ spellID = 182031, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 束缚暗影
			{ spellID = 190482, unitID = "player", caster = "all", filter = "DEBUFF"},


			-- 13	阿克蒙德
			-- 影魔冲击
			{ spellID = 183634, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 暗影爆破
			{ spellID = 187742, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 183864, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 死亡烙印
			{ spellID = 183828, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 魔火
			{ spellID = 183586, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 魔火锁定
			{ spellID = 182879, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 纳鲁之光
			{ spellID = 183963, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 聚焦混乱
			{ spellID = 185014, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 精炼混乱
			{ spellID = 186123, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 枷锁酷刑
			{ spellID = 184964, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 虚空放逐
			{ spellID = 186952, unitID = "player", caster = "all", filter = "DEBUFF"},
			{ spellID = 186961, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 吞噬声明
			{ spellID = 187047, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 虚空撕裂
			{ spellID = 189891, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 虚空腐化
			{ spellID = 190049, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- 邪能腐蚀
			{ spellID = 188796, unitID = "player", caster = "all", filter = "DEBUFF"},
		},
	},
}
