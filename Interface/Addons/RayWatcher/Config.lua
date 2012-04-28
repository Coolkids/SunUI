
-----------------------------------------------------------------------------------------------------
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

local _, ns = ...
local S, C, L, DB = unpack(SunUI)
ns.font = DB.Font
ns.fontsize = 14
ns.fontflag = "OUTLINE"

ns.watchers ={
	["DRUID"] = {
		{
			name = "玩家buff",
			direction = "RIGHT",
			setpoint =  {"BOTTOM", UIParent, "BOTTOM",-68, 203},
			size = 20,
				-- 节能施法
				{ spellID = 16870, unitId = "player", caster = "player", filter = "BUFF" },
				-- 自然之赐
				{ spellID = 16886, unitId = "player", caster = "player", filter = "BUFF" },
				-- 日蚀
				{ spellID = 48517, unitId = "player", caster = "player", filter = "BUFF" },			
				-- 月蚀
				{ spellID = 48518, unitId = "player", caster = "player", filter = "BUFF" },
				-- 狂暴(猫&熊)
				{ spellID = 50334, unitId = "player", caster = "player", filter = "BUFF" },
				-- 狂怒
				{ spellID = 5229, unitId = "player", caster = "player", filter = "BUFF" },
				-- 野蛮咆哮(猫)
				{ spellID = 52610, unitId = "player", caster = "player", filter = "BUFF" },
				-- 粉碎
				{ spellID = 80951, unitId = "player", caster = "player", filter = "BUFF" },
				-- 月光淋漓
				{ spellID = 81192, unitId = "player", caster = "player", filter = "BUFF" },
				-- 坠星
				{ spellID = 93400, unitId = "player", caster = "player", filter = "BUFF" },
				-- 狂暴
				{ spellID = 93622, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint ={"TOP", UIParent, "BOTTOM", 101, 235},
			size = 28,
				-- 挫志咆哮(熊)
				{ spellID =    99, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 回春术
				{ spellID =   774, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 割裂(猫)
				{ spellID =  1079, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 斜掠(猫)
				{ spellID =  1822, unitId = "target", caster = "player", filter = "DEBUFF" },			
				-- 虫群
				{ spellID =  5570, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 月火术
				{ spellID =  8921, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 割伤(熊)
				{ spellID = 33745, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 生命绽放
				{ spellID = 33763, unitId = "target", caster = "player", filter = "DEBUFF" },			
				-- 裂伤(猫)
				{ spellID = 33876, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 野蛮咆哮(猫)
				{ spellID = 52610, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 阳炎术
				{ spellID = 93402, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 割碎
				{ spellID = 33878, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM", -38, 135},
			size = 20,
				-- 狂暴恢复
				{ spellID = 22842, filter = "CD" },
				-- 求生本能
				{ spellID = 61336, filter = "CD" },
				-- 樹皮術
				{ spellID = 22812, filter = "CD" },
				-- 狂暴
				{ spellID = 50334, filter = "CD" },
		},
	},
	["HUNTER"] = {
		{
			name = "目标框上方",
			direction = "RIGHT",
			setpoint ={"TOP", UIParent, "BOTTOM", 101, 235},
			size = 28,
				-- 毒蛇钉刺
				{ spellID =  1978 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				{ spellID =  88453 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 驱散射击
				{ spellID = 19503 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 穿刺射击
				{ spellID = 63468 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 黑蝕箭
				{ spellID = 3674, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 爆炸射擊
				{ spellID = 53301, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 連環火網
				{ spellID = 82921, unitId = "player", caster = "player", filter = "BUFF" },			
				-- 强化稳固射击
				{ spellID = 53220, unitId = "player", caster = "player", filter = "BUFF" },
				-- 驱散射击
				{ spellID = 19503 ,unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			name = "目標的目标框上方",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM",-68, 203},
			size = 20,
				-- 急速射击
				{ spellID =  3045, unitId = "player", caster = "player", filter = "BUFF" },
				-- 治疗宠物
				{ spellID = 136, unitId = "pet", caster = "player", filter = "BUFF" },
				-- 野兽之心
				{ spellID = 34471, unitId = "player", caster = "player", filter = "BUFF" },
				-- 误导
				{ spellID = 34477, unitId = "player", caster = "player", filter = "BUFF" },
				-- 误导
				{ spellID = 35079, unitId = "player", caster = "player", filter = "BUFF" },				
				-- 眼镜蛇打击
				{ spellID = 53257, unitId = "player", caster = "player", filter = "BUFF" },
				-- 狂野呼唤
				{ spellID = 53434, unitId = "player", caster = "all", filter = "BUFF" },
				-- 荷枪实弹
				{ spellID = 56453, unitId = "player", caster = "player", filter = "BUFF" },
				-- 攻击弱点
				{ spellID = 70728, unitId = "player", caster = "player", filter = "BUFF" },
				-- 准备,端枪,瞄准... ...
				{ spellID = 82925, unitId = "player", caster = "player", filter = "BUFF" },
				-- 开火!
				{ spellID = 82926, unitId = "player", caster = "player", filter = "BUFF" },
				-- 上!
				{ spellID = 89388, unitId = "player", caster = "player", filter = "BUFF" },
				-- 血性大发
				{ spellID = 94007, unitId = "player", caster = "player", filter = "BUFF" },
				-- 4T12特效
				{ spellID = 99060, unitId = "player", caster = "player", filter = "BUFF" },
				-- 阻擊訓練
				{ spellID = 64420, unitId = "player", caster = "player", filter = "BUFF" },
				-- 狂乱
				{ spellID = 19615, unitId = "pet", caster = "player", filter = "BUFF" }
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM", -38, 135},
			size = 20,
				-- 奇美拉射击
				{ spellID = 53209, filter = "CD" },
				-- 急速射击
				{ spellID =  3045, filter = "CD" },
				-- 准备就绪
				{ spellID = 23989, filter = "CD" },
				-- 爆炸射擊
				{ spellID = 53301, filter = "CD" },
				-- 黑蝕箭
				{ spellID =  3674, filter = "CD" },
		},
	},
	["MAGE"] = {
		{
			name = "目标框上方",
			direction = "RIGHT",
			setpoint ={"TOP", UIParent, "BOTTOM", 101, 235},
			size = 28,
			
				-- 点燃
				{ spellID = 12654 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 临界炽焰
				{ spellID = 22959 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 减速
				{ spellID = 31589 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 活动炸弹
				{ spellID = 44457 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 秘法衝擊
				{ spellID = 36032, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 燃火
				{ spellID = 83853, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 深度凍結
				{ spellID = 44572, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 炎爆!
				{ spellID = 92315, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 炎爆
				{ spellID = 11366, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			name = "目标的目标上方",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM",-68, 203},
			size = 28,
			  -- 奥术强化
				{ spellID = 12042, unitId = "player", caster = "player", filter = "BUFF" },
				-- 唤醒
				{ spellID = 12051, unitId = "player", caster = "player", filter = "BUFF" },
				-- 奥术冲击
				{ spellID = 36032, unitId = "player", caster = "player", filter = "BUFF" },				
				-- 寒冰指
				{ spellID = 44544, unitId = "player", caster = "player", filter = "BUFF" },
				-- 法术连击
				{ spellID = 48108, unitId = "player", caster = "player", filter = "BUFF" },
				-- 冰冷智慧
				{ spellID = 57761, unitId = "player", caster = "player", filter = "BUFF" },
				-- 冲击(等级1)
				{ spellID = 64343, unitId = "player", caster = "player", filter = "BUFF" },
				-- 秘法飛彈!
				{ spellID = 79683, unitId = "player", caster = "player", filter = "BUFF" },
				-- 灸灼
				{ spellID = 87023, unitId = "player", caster = "player", filter = "BUFF" },	
				-- 魔法凝聚
				{ spellID = 54648, unitId = "player", caster = "player", filter = "BUFF" },
				-- 强化法力宝石
				{ spellID = 83098, unitId = "player", caster = "player", filter = "BUFF" },	
				-- 隱形術
				{ spellID = 66, unitId = "player", caster = "player", filter = "BUFF" },
				-- 隱形術
				{ spellID = 32612, unitId = "player", caster = "player", filter = "BUFF" },
				-- 咒法移轉
				{ spellID = 44413, unitId = "player", caster = "player", filter = "BUFF" },				
				-- 幻鏡之像
				{ spellID = 55342, unitId = "player", caster = "player", filter = "BUFF" },
				-- 節能施法
				{ spellID = 12536, unitId = "player", caster = "player", filter = "BUFF" },
				-- 龍之吐息
				{ spellID = 31661, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 烈焰風暴
				{ spellID = 2120, unitId = "player", caster = "player", filter = "DEBUFF" },
				
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM", -38, 135},
			size = 20,
				-- 唤醒
				{ spellID = 12051, filter = "CD" },
				-- 秘法强化
				{ spellID =  12042, filter = "CD" },
				-- 燃火
				{ spellID = 11129, filter = "CD" },
		},
	},
	["WARRIOR"] = {
		{
			name = "玩家Buff",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM",-68, 203},
			size = 20,
				-- 盾墙(防御姿态)
				{ spellID =   871, unitId = "player", caster = "player", filter = "BUFF" },
				-- 怒火中烧
				{ spellID =  1134, unitId = "player", caster = "player", filter = "BUFF" },
				-- 盾牌格挡(防御姿态)
				{ spellID =  2565, unitId = "player", caster = "player", filter = "BUFF" },
				-- 嗜血
				{ spellID =  2825, unitId = "player", caster = "all", filter = "BUFF" },				
				-- 横扫攻击(战斗,狂暴姿态)
				{ spellID = 12328, unitId = "player", caster = "player", filter = "BUFF" },
				-- 战斗专注
				{ spellID = 12964, unitId = "player", caster = "player", filter = "BUFF" },
				-- 破釜沉舟
				{ spellID = 12975, unitId = "player", caster = "player", filter = "BUFF" },
				-- 血之狂热
				{ spellID = 16491, unitId = "player", caster = "player", filter = "BUFF" },
				-- 反击风暴(战斗姿态)
				{ spellID = 20230, unitId = "player", caster = "player", filter = "BUFF" },
				-- 嗜血
				{ spellID = 23885, unitId = "player", caster = "player", filter = "BUFF" },
				-- 法术发射(战斗,防御姿态)
				{ spellID = 23920, unitId = "player", caster = "player", filter = "BUFF" },
				-- 复苏之风(等级1)
				{ spellID = 29841, unitId = "player", caster = "player", filter = "BUFF" },
				-- 英勇气概
				{ spellID = 32182, unitId = "player", caster = "all", filter = "BUFF" },
				-- 胜利
				{ spellID = 32216, unitId = "player", caster = "player", filter = "BUFF" },
				-- 血脉喷张
				{ spellID = 46916, unitId = "player", caster = "player", filter = "BUFF" },
				-- 剑盾猛攻
				{ spellID = 50227, unitId = "player", caster = "player", filter = "BUFF" },
				-- 猝死
				{ spellID = 55694, unitId = "player", caster = "player", filter = "BUFF" },
				-- 激怒(等级2)
				{ spellID = 57519, unitId = "player", caster = "player", filter = "BUFF" },
				-- 血之气息
				{ spellID = 60503, unitId = "player", caster = "player", filter = "BUFF" },
				-- 主宰
				{ spellID = 65156, unitId = "player", caster = "player", filter = "BUFF" },
				-- 时间扭曲
				{ spellID = 80353, unitId = "player", caster = "all", filter = "BUFF" },
				-- 胜利
				{ spellID = 82368, unitId = "player", caster = "player", filter = "BUFF" },
				-- 屠夫(等级3)
				{ spellID = 84586, unitId = "player", caster = "player", filter = "BUFF" },
				-- 坚守阵地
				{ spellID = 84620, unitId = "player", caster = "player", filter = "BUFF" },
				-- 致命平静
				{ spellID = 85730, unitId = "player", caster = "player", filter = "BUFF" },
				-- 激动
				{ spellID = 86627, unitId = "player", caster = "player", filter = "BUFF" },
				-- 雷霆余震
				{ spellID = 87096, unitId = "player", caster = "player", filter = "BUFF" },
				-- 行刑者
				{ spellID = 90806, unitId = "player", caster = "player", filter = "BUFF" },		
		},
		{
			name = "目标Debuff",
			direction = "RIGHT",
			setpoint ={"TOP", UIParent, "BOTTOM", 101, 235},
			size = 28,
			
			-- Charge Stun / Sturmangriffsbetäubung
			{ spellID = 7922, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Shockwave / Schockwelle
			{ spellID = 46968, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Hamstring / Kniesehne
			{ spellID = 1715, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Rend / Verwunden
			{ spellID = 94009, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Sunder Armor /Rüstung zerreiße
			{ spellID = 7386, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Thunder Clap / Donnerknall
			{ spellID = 6343, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Demoralizing Shout / Demoralisierender Ruf
			{ spellID = 1160, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Expose Armor / Rüstung schwächen (Rogue)
			{ spellID = 8647, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Infected Wounds / Infizierte Wunden (Druid)
			{ spellID = 48484, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Frost Fever / Frostfieber (Death Knight)
			{ spellID = 55095, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Demoralizing Roar / Demoralisierendes Gebrüll (Druid)
			{ spellID = 99, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Curse of Weakness / Fluch der Schwäche (Warlock)
			{ spellID = 702, unitId = "target", caster = "all", filter = "DEBUFF" },

		},
	},
	["SHAMAN"] = {
		{
			name = "玩家buff",
			direction = "RIGHT",
			setpoint =  {"BOTTOM", UIParent, "BOTTOM",-68, 203},
			size = 20,
				-- 嗜血
				{ spellID =  2825, unitId = "player", caster = "all", filter = "BUFF" },
				-- 闪电之盾
				{ spellID =   324, unitId = "player", caster = "player", filter = "BUFF" },
				-- 萨满之怒
				{ spellID = 30823, unitId = "player", caster = "player", filter = "BUFF" },
				-- 英勇气概
				{ spellID = 32182, unitId = "player", caster = "all", filter = "BUFF" },
				-- 水之护盾
				{ spellID = 52127, unitId = "player", caster = "player", filter = "BUFF" },
				-- 潮汐奔涌
				{ spellID = 53390, unitId = "player", caster = "player", filter = "BUFF" },
				-- 5层漩涡武器
				{ spellID = 53817, unitId = "player", caster = "player", filter = "BUFF" },
				-- 灵魂行者的恩赐
				{ spellID = 79206, unitId = "player", caster = "player", filter = "BUFF" },
				-- 时间扭曲
				{ spellID = 80353, unitId = "player", caster = "all", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint ={"TOP", UIParent, "BOTTOM", 101, 235},
			size = 28,
				-- 大地震击
				{ spellID =  8042, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 烈焰震击
				{ spellID =  8050, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 冰霜震击
				{ spellID =  8056, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 风暴打击
				{ spellID = 17364, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 灼热烈焰
				{ spellID = 77661, unitId = "target", caster = "player", filter = "DEBUFF" },
				--漩涡武器
				{ spellID = 53817, unitId = "player", caster = "player", filter = "BUFF" }, 
		},
	},
	["PALADIN"] = {
		{
			name = "玩家buff",
			direction = "RIGHT",
			setpoint =  {"BOTTOM", UIParent, "BOTTOM",-68, 203},
			size = 20,
				-- 圣佑术
				{ spellID =   498, unitId = "player", caster = "player", filter = "BUFF" },
				-- 圣盾术
				{ spellID =   642, unitId = "player", caster = "player", filter = "BUFF" },
				-- 嗜血
				{ spellID =  2825, unitId = "player", caster = "all", filter = "BUFF" },
				-- 神恩术
				{ spellID = 31842, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神圣之盾
				{ spellID = 20925, unitId = "player", caster = "player", filter = "BUFF" },
				-- 智者审判
				{ spellID = 31930, unitId = "player", caster = "player", filter = "BUFF" },		
				-- 复仇之怒
				{ spellID = 31884, unitId = "player", caster = "player", filter = "BUFF" },
				-- 炙热防御者
				{ spellID = 31850, unitId = "player", caster = "player", filter = "BUFF" },
				-- 英勇气概
				{ spellID = 32182, unitId = "player", caster = "all", filter = "BUFF" },
				-- 纯洁审判(等级3)
				{ spellID = 53657, unitId = "player", caster = "player", filter = "BUFF" },
				-- 圣光灌注(等级2)
				{ spellID = 54149, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神圣恳求
				{ spellID = 54428, unitId = "player", caster = "player", filter = "BUFF" },
				-- 战争艺术
				{ spellID = 59578, unitId = "player", caster = "player", filter = "BUFF" },
				-- 时间扭曲
				{ spellID = 80353, unitId = "player", caster = "all", filter = "BUFF" },
				-- 异端裁决
				{ spellID = 84963, unitId = "player", caster = "player", filter = "BUFF" },
				-- 大十字军 (复仇盾)
				{ spellID = 85043, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神圣使命 (盾击必暴)
				{ spellID = 85433, unitId = "player", caster = "player", filter = "BUFF" },
				-- 狂热
				{ spellID = 85696, unitId = "player", caster = "player", filter = "BUFF" },
				-- 远古列王守卫
				{ spellID = 86659, unitId = "player", caster = "player", filter = "BUFF" },
				-- 破晓
				{ spellID = 88819, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神圣意志
				{ spellID = 90174, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint ={"TOP", UIParent, "BOTTOM", 101, 235},
			size = 28,
				-- 制裁之锤
				{ spellID =   853, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 神圣愤怒
				{ spellID =  2812, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 超度邪恶
				{ spellID = 10326, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 忏悔
				{ spellID = 20066, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 辩护
				{ spellID = 26017, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 圣光道标
				{ spellID = 53563, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
	},
	["PRIEST"] = {
		{
			name = "玩家buff",
			direction = "RIGHT",
			setpoint =  {"BOTTOM", UIParent, "BOTTOM",-68, 203},
			size = 20,
				-- 心靈熔蝕
				{ spellID = 87160, unitId = "player", caster = "player", filter = "BUFF" },
				-- 黑暗佈道
				{ spellID = 87118, unitId = "player", caster = "player", filter = "BUFF" },
				-- 大天使
				{ spellID = 87152, unitId = "player", caster = "player", filter = "BUFF" },
				-- 黑天使
				{ spellID = 87153, unitId = "player", caster = "player", filter = "BUFF" },  
				-- 消散
				{ spellID = 47585, unitId = "player", caster = "player", filter = "BUFF" },  
				-- 佈道
				{ spellID = 81661, unitId = "player", caster = "player", filter = "BUFF" },
				-- 心靈意志
				--{ spellID = 73413, unitId = "player", caster = "player", filter = "BUFF" },
				-- 心靈之火
				--{ spellID =   588, unitId = "player", caster = "player", filter = "BUFF" },
				-- 吸血鬼的擁抱
				--{ spellID = 15286, unitId = "player", caster = "player", filter = "BUFF" },
				-- 守护圣灵
				{ spellID = 47788, unitId = "target", caster = "player", filter = "BUFF" },
				-- 预支时间
				{ spellID = 59889, unitId = "player", caster = "player", filter = "BUFF" },
				-- 预支时间
				{ spellID = 59888, unitId = "player", caster = "player", filter = "BUFF" },
				-- 预支时间
				{ spellID = 59887, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神禦之盾
				{ spellID = 47753, unitId = "target", caster = "player", filter = "BUFF" },
				-- 漸隱術
				{ spellID = 586, unitId = "player", caster = "player", filter = "BUFF" },    
				-- 精神分流
				{ spellID = 81301, unitId = "player", caster = "player", filter = "BUFF" },
				-- 脈輪運轉
				{ spellID = 14751, unitId = "player", caster = "player", filter = "BUFF" },
				-- 脈輪運轉:懲擊 
				{ spellID = 81209, unitId = "player", caster = "player", filter = "BUFF" },
				-- 脈輪運轉:治療禱言
				{ spellID = 81206, unitId = "player", caster = "player", filter = "BUFF" },
				-- 脈輪運轉:治療術
				{ spellID = 81208, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神性火焰
				{ spellID = 99132, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标框體上方",
			direction = "RIGHT",
			setpoint ={"TOP", UIParent, "BOTTOM", 101, 235},
			size = 28,
				--心灵尖刺
				{ spellID = 87178, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 吸血鬼之触
				{ spellID = 34914, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 暗言术:痛
				{ spellID =   589, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 噬灵疫病
				{ spellID =  2944, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 虚弱灵魂
				{ spellID =  6788, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- T12 4件特效
				{ spellID = 99158, unitId = "player", caster = "player", filter = "BUFF" },
				-- 灵感(等级1)
				{ spellID = 14893, unitId = "target", caster = "player", filter = "BUFF" },
				-- 灵感(等级2)
				{ spellID = 15357, unitId = "target", caster = "player", filter = "BUFF" },
				-- 守护圣灵
				{ spellID = 47788, unitId = "target", caster = "player", filter = "BUFF" },
				--光明回想
				{ spellID = 77489, unitId = "target", caster = "player", filter = "BUFF" },
				-- 恢复
				{ spellID = 139, unitId = "target", caster = "player", filter = "BUFF" },
				-- 聖言術:寧 
				{ spellID = 88684, unitId = "target", caster = "player", filter = "BUFF" },
				-- 聖言術:譴
				{ spellID = 88625, unitId = "tatget", caster = "player", filter = "DEBUFF"},
		},
		{
			name = "玩家框體下方",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM", -123, 133},
			--setpoint = {"CENTER", UIParent, "CENTER", -185, -265},
			mode = "ICON",
			size = 22,
				-- 暗影宝珠
				{ spellID = 77487, unitId = "player", caster = "player", filter = "BUFF" },
			  -- 强效暗影
				{ spellID = 95799, unitId = "player", caster = "player", filter = "BUFF" },	
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM", -38, 135},
			size = 20,
				-- 心靈震爆
				{ spellID = 8092, filter = "CD" },
				-- 暗影魔
				{ spellID =  34433, filter = "CD" },
				-- 大天使
				{ spellID = 87151, filter = "CD" },
		},
	},
	["WARLOCK"]={
		{
			name = "玩家Buff",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM",-68, 203},
			mode = "ICON",
			size = 20,
				-- 嗜血
				{ spellID =  2825, unitId = "player", caster = "player", filter = "BUFF" },
				-- 暗影冥思
				{ spellID = 17941, unitId = "player", caster = "player", filter = "BUFF" },
				-- 英勇气概
				{ spellID = 32182, unitId = "player", caster = "player", filter = "BUFF" },
				-- 反冲(等级3)
				{ spellID = 34939, unitId = "player", caster = "player", filter = "BUFF" },
				-- 小鬼增效
				{ spellID = 47283, unitId = "player", caster = "player", filter = "BUFF" },			
				-- 灭杀(等级2)
				{ spellID = 63158, unitId = "player", caster = "player", filter = "BUFF" },
				-- 灭杀
				{ spellID = 63167, unitId = "player", caster = "player", filter = "BUFF" },
				-- 熔火之心
				{ spellID = 71165, unitId = "player", caster = "player", filter = "BUFF" },
				-- 时间扭曲
				{ spellID = 80353, unitId = "player", caster = "player", filter = "BUFF" },
				-- 强化灵魂之火
				{ spellID = 85383, unitId = "player", caster = "player", filter = "BUFF" },
				-- 魔能火花
				{ spellID = 89937, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			setpoint ={"TOP", UIParent, "BOTTOM", 101, 235},
			direction = "RIGHT",
			mode = "ICON",
			size = 28,
				-- 腐蚀术
				{ spellID =   172, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 献祭
				{ spellID =   348, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 末日灾祸
				{ spellID =   603, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 痛苦灾祸
				{ spellID =   980, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 元素诅咒
				{ spellID =  1490, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 暗影烈焰 (强化暗箭)
				{ spellID = 17800, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 烧尽
				{ spellID = 29722, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 痛苦无常
				{ spellID = 30108, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 暗影之拥
				{ spellID = 32389, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 鬼影缠身
				{ spellID = 48181, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 混乱之箭
				{ spellID = 50796, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 浩劫灾祸
				{ spellID = 80240, unitId = "target", caster = "player",filter = "DEBUFF" },
				-- 古尔丹邪咒
				{ spellID = 86000, unitId = "target", caster = "player",filter = "DEBUFF" },	
		},
	},
	["ROGUE"] = {
		{
			name = "目標的目標上方",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM",-68, 203},
			size = 20,
				-- 冷血
				{ spellID = 14177, unitId = "player", caster = "player", filter = "BUFF" },
				-- 嫁祸诀窍
				{ spellID = 57934, unitId = "player", caster = "player", filter = "BUFF" },			
				-- 灭绝
				{ spellID = 58427, unitId = "player", caster = "player", filter = "BUFF" },
				-- 嫁祸诀窍
				{ spellID = 59628, unitId = "player", caster = "player", filter = "BUFF" },
				-- 致命冲动
				{ spellID = 84590, unitId = "player", caster = "player", filter = "BUFF" },
				-- 能量刺激
				{ spellID = 13750, unitId = "player", caster = "player", filter = "BUFF" },
		
		},
		{
			name = "目标框上方",
			direction = "RIGHT",
			setpoint = {"TOP", UIParent, "BOTTOM", 101, 235},
			size = 28,
				-- 肾击
				{ spellID =   408, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 绞喉
				{ spellID =   703, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 偷袭
				{ spellID =  1833, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 割裂
				{ spellID =  1943, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 破甲
				{ spellID =  8647, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 缴械
				{ spellID = 51722, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 要害打击
				{ spellID = 84617, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 仇杀
				{ spellID = 79140, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 切割
				{ spellID =  5171, unitId = "player", caster = "player", filter = "BUFF" },
				-- 淺察
				{ spellID = 84745, unitId = "player", caster = "player", filter = "BUFF" },
				-- 中度
				{ spellID = 84746, unitId = "player", caster = "player", filter = "BUFF" },
				-- 深度
				{ spellID = 84747, unitId = "player", caster = "player", filter = "BUFF" },
				-- 养精蓄锐
				{ spellID = 73651, unitId = "player", caster = "player", filter = "BUFF" },
				-- 毒伤
				{ spellID = 32645, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM", -38, 135},
			size = 20,
				-- 殺戮盛筵
				{ spellID = 51690, filter = "CD" },
				-- 冲动
				{ spellID =  13750, filter = "CD" },
		},
	},
	["DEATHKNIGHT"] = {
		{
			name = "玩家Buff",
			direction = "RIGHT",
			setpoint = {"BOTTOM", UIParent, "BOTTOM",-68, 203},
			size = 20,
				-- 反魔法护罩
				{ spellID = 48707, unitId = "player", caster = "player", filter = "BUFF" },
				-- 冰封之韧
				{ spellID = 48792, unitId = "player", caster = "player", filter = "BUFF" },
				-- 末日突降
				{ spellID = 49018, unitId = "player", caster = "player", filter = "BUFF" },		
				-- 巫妖之躯
				{ spellID = 49039, unitId = "player", caster = "player", filter = "BUFF" },
				-- 白骨之盾
				{ spellID = 49222, unitId = "player", caster = "player", filter = "BUFF" },
				-- 杀戮机器
				{ spellID = 51124, unitId = "player", caster = "player", filter = "BUFF" },
				-- 灰烬冰川
				{ spellID = 53386, unitId = "player", caster = "player", filter = "BUFF" },
				-- 吸血鬼之血
				{ spellID = 55233, unitId = "player", caster = "player", filter = "BUFF" },
				-- 冰冻之雾
				{ spellID = 59052, unitId = "player", caster = "player", filter = "BUFF" },
				-- 赤色天灾
				{ spellID = 81141, unitId = "player", caster = "player", filter = "BUFF" },
				-- 大墓地的意志
				{ spellID = 81162, unitId = "player", caster = "player", filter = "BUFF" },
				-- 符文刃舞
				{ spellID = 81256, unitId = "player", caster = "player", filter = "BUFF" },
				-- 暗影灌注
				{ spellID = 91342, unitId = "pet", caster = "player", filter = "BUFF" }, 		
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint ={"TOP", UIParent, "BOTTOM", 101, 235},
			size = 28,
				-- 血之疫病
				{ spellID = 55078, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 冰霜疫病
				{ spellID = 55095, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 血红热疫
				{ spellID = 81130, unitId = "target", caster = "player", filter = "DEBUFF" },		
		},
	},
	["ALL"]={
		{
			name = "玩家Debuff",
			direction = "RIGHT",
			setpoint = {"TOP", UIParent, "TOP", 160, -157},
			size = 46,
				-- 震懾波
				{ spellID = 46968, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 变羊
				{ spellID =   118, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 制裁之锤
				{ spellID =   853, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 肾击
				{ spellID =   408, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 撕扯
				{ spellID = 47481, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 沉默
				{ spellID = 55021, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 割碎
				{ spellID = 22570, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 断筋
				{ spellID =  1715, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 沉默
				{ spellID = 15487, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 心靈恐慌
				{ spellID = 64058, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 罪與罰
				{ spellID = 87204, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 魔法反制
				{ spellID = 18469, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 魔法反制
				{ spellID = 55021, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 腳踢
				{ spellID = 18425, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 腳踢
				{ spellID = 86759, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 絞殺
				{ spellID = 47476, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 冰鍊術
				{ spellID = 45524, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 心靈尖嘯
				{ spellID =  8122, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 恐懼
				{ spellID =  5782, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 恐懼嚎叫
				{ spellID =  5484, unitId = "player", caster = "all", filter = "DEBUFF" },
				--致殘毒藥
				{ spellID =  3775, unitId = "player", caster = "all", filter = "DEBUFF" },
				--聚雷針
				{ spellID = 83099, unitId = "player", caster = "all", filter = "DEBUFF" },
				--侵蝕魔法
				{ spellID = 86622, unitId = "player", caster = "all", filter = "DEBUFF" },
				--暮光隕星
				{ spellID = 88518, unitId = "player", caster = "all", filter = "DEBUFF" },
				--爆裂灰燼
				{ spellID = 79339, unitId = "player", caster = "all", filter = "DEBUFF" },
				--火焰易傷
				{ spellID = 98492, unitId = "player", caster = "all", filter = "DEBUFF" },
				--爆裂種子
				{ spellID = 98450, unitId = "player", caster = "all", filter = "DEBUFF" },
				--折磨
				{ spellID = 100230, unitId = "player", caster = "all", filter = "DEBUFF" },
				--折磨
				{ spellID = 100231, unitId = "player", caster = "all", filter = "DEBUFF" },
				--受到折磨
				{ spellID = 99257, unitId = "player", caster = "all", filter = "DEBUFF" },
				--受到折磨
				{ spellID = 99403, unitId = "player", caster = "all", filter = "DEBUFF" },
				--凝视
				{ spellID = 99849, unitId = "player", caster = "all", filter = "DEBUFF" },
				--燃烧之球
				{ spellID = 100210, unitId = "player", caster = "all", filter = "DEBUFF" },
				--折磨
				{ spellID = 99256, unitId = "player", caster = "all", filter = "DEBUFF" },
				--冰霜
				{ spellID = 109325, unitId = "player", caster = "all", filter = "DEBUFF" },
				---- Dragon Soul
				-- Morchok
				{ spellID = 103687, unitId = "player", caster = "all", filter = "DEBUFF" }, -- Crush Armor(擊碎護甲)
				-- Zon'ozz
				{ spellID = 103434, unitId = "player", caster = "all", filter = "DEBUFF" }, -- Disrupting Shadows(崩解之影)
				{ spellID = 104600, unitId = "player", caster = "all", filter = "DEBUFF" },--崩解之影
				-- Yor'sahj
				{ spellID = 105171, unitId = "player", caster = "all", filter = "DEBUFF" },-- Deep Corruption(深度腐化)
				{ spellID = 103628, unitId = "player", caster = "all", filter = "DEBUFF" },
				--{ spellID = 103628)] = 7, -- Deep Corruption(深度腐化)
				{ spellID = 104849, unitId = "player", caster = "all", filter = "DEBUFF" },  -- Void Bolt(虛無箭)
				-- Hagara
				{ spellID = 104451, unitId = "player", caster = "all", filter = "DEBUFF" },  -- Ice Tomb(寒冰之墓)
				-- Ultraxion
				{ spellID = 110073, unitId = "player", caster = "all", filter = "DEBUFF" }, -- Fading Light(凋零之光)
				-- Blackhorn
				{ spellID = 109209, unitId = "player", caster = "all", filter = "DEBUFF" },  -- Brutal Strike(蠻橫打擊)
				{ spellID = 108043, unitId = "player", caster = "all", filter = "DEBUFF" },  -- Sunder Armor(破甲攻擊)
				{ spellID = 108861, unitId = "player", caster = "all", filter = "DEBUFF" }, -- Degeneration(衰亡)
				-- Spine
				{ spellID = 105479, unitId = "player", caster = "all", filter = "DEBUFF" }, -- 燃燒血漿
				{ spellID = 109379, unitId = "player", caster = "all", filter = "DEBUFF" },-- Searing Plasma(燃燒血漿)
				{ spellID = 109457, unitId = "player", caster = "all", filter = "DEBUFF" },  -- Fiery Grip(熾熱之握)
				{ spellID = 105490, unitId = "player", caster = "all", filter = "DEBUFF" },  -- Fiery Grip(熾熱之握)
				-- Madness 
				{ spellID = 105841, unitId = "player", caster = "all", filter = "DEBUFF" },  -- Degenerative Bite(退化咬擊)
				{ spellID = 105445, unitId = "player", caster = "all", filter = "DEBUFF" },  -- Blistering Heat(極熾高熱)
				{ spellID = 106444, unitId = "player", caster = "all", filter = "DEBUFF" },  -- Impale(刺穿)
				--凋零之光
				{ spellID = 110079, unitId = "player", caster = "all", filter = "DEBUFF" },
				{ spellID = 110080, unitId = "player", caster = "all", filter = "DEBUFF" },
				{ spellID = 105925, unitId = "player", caster = "all", filter = "DEBUFF" },
				{ spellID = 109075, unitId = "player", caster = "all", filter = "DEBUFF" },
				{ spellID = 110069, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		{
			name = "玩家PVPDebuff",
			direction = "RIGHT",
			setpoint = {"TOP", UIParent, "TOP", 160, -111},
			size = 40,
				--啃食
		        { spellID = 47481, unitId = "player", caster = "all", filter = "DEBUFF" },
				--絞殺
				{ spellID = 47476, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--冰鍊術
				{ spellID = 45524, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--褻瀆
				{ spellID = 55666, unitId = "player", caster = "all", filter = "DEBUFF" },
				--碎心打擊雕紋
				{ spellID = 58617, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--重擊
				{ spellID = 5211, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--颶風術
				{ spellID = 33786, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--休眠
				{ spellID = 2637, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--傷殘術
				{ spellID = 22570, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--突襲
				{ spellID = 9005, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--糾纏根鬚
				{ spellID = 339, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--感染之傷
				{ spellID = 58179, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--颱風
				{ spellID = 61391, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--冰凍陷阱
				{ spellID = 3355, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--脅迫
				{ spellID = 24394, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--恐嚇野獸
				{ spellID = 1513, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--驅散射擊
				{ spellID = 19503, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--翼龍釘刺
				{ spellID = 19386, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--沉默射擊
				{ spellID = 34490, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--反擊
				{ spellID = 19306, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--誘捕
				{ spellID = 19185, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--震盪狙擊
				{ spellID = 35101, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--震盪射擊
				{ spellID = 5116, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--寒冰陷阱
				{ spellID = 13810, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--凍痕
				{ spellID = 61394, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--摔絆
				{ spellID = 2974, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--音波衝擊
				{ spellID = 50519, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--奪械
				{ spellID = 50541, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--霜雷之息
				{ spellID = 54644, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--釘刺
				{ spellID = 50245, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--裂筋
				{ spellID = 50271, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--劫掠
				{ spellID = 50518, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--噴灑毒網
				{ spellID = 54706, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--蛛網
				{ spellID = 4167, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--極度冰凍
				{ spellID = 44572, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--龍之吐息
				{ spellID = 31661, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--衝擊
				{ spellID = 12355, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--變形術
				{ spellID = 118, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--沉默 - 強化法術反制
				{ spellID = 18469, unitId = "player", caster = "all", filter = "DEBUFF" },
				--熾熱代價
				{ spellID = 64346, unitId = "player", caster = "all", filter = "DEBUFF" },
				--冰凍術
				{ spellID = 33395, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--冰霜新星
				{ spellID = 122, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--碎裂屏障
				{ spellID = 55080, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--衝擊波
				{ spellID = 11113, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--冰凍
				{ spellID = 6136, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--冰錐術
				{ spellID = 120, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--寒冰箭
				{ spellID = 116, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--減速術
				{ spellID = 31589, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--制裁之錘
				{ spellID = 853, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--神聖憤怒
				{ spellID = 2812, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--懺悔
				{ spellID = 20066, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--公正聖印
				{ spellID = 20170, unitId = "player", caster = "all", filter = "DEBUFF" },
				--退邪術
				{ spellID = 10326, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--暈眩 - 復仇之盾
				{ spellID = 63529, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--精神控制
				{ spellID = 605, unitId = "player", caster = "all", filter = "DEBUFF" },
				--心靈恐慌
				{ spellID = 64044, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--心靈尖嘯
				{ spellID = 8122, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--沉默
				{ spellID = 15487, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--	致盲			
				{ spellID = 2094, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--偷襲
				{ spellID = 1833, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--鑿擊
				{ spellID = 1776, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--腎擊
				{ spellID = 408, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--悶棍
				{ spellID = 6770, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--絞喉 - 沉默
				{ spellID = 1330, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--沉默 - 強化腳踢
				{ spellID = 18425, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--卸除武裝
				{ spellID = 51722, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--旋轉劍刃
				{ spellID = 31125, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--致殘毒藥
				{ spellID = 3409, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--擲殺
				{ spellID = 26679, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--石爪昏迷
				{ spellID = 39796, unitId = "player", caster = "all", filter = "DEBUFF" },
				--妖術
				{ spellID = 51514, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--陷地
				{ spellID = 64695, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--凍結
				{ spellID = 63685, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--地縛術
				{ spellID = 3600, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--冰霜震擊
				{ spellID = 8056, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--冰封攻擊
				{ spellID = 8034, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--放逐術
				{ spellID = 710, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--死亡纏繞
				{ spellID = 6789, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--恐懼術
				{ spellID = 5782, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--恐懼嚎叫
				{ spellID = 5484, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--誘惑
				{ spellID = 6358, unitId = "player", caster = "all", filter = "DEBUFF" },
				--暗影之怒
				{ spellID = 30283, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--法術封鎖
				{ spellID = 24259, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--清算
				{ spellID = 18118, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--疲勞詛咒
				{ spellID = 18223, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--衝鋒昏迷
				{ spellID = 7922, unitId = "player", caster = "all", filter = "DEBUFF" },
				--震盪猛擊
				{ spellID = 12809, unitId = "player", caster = "all", filter = "DEBUFF" },
				--攔截
				{ spellID = 20253, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--破膽怒吼
				{ spellID = 5246, unitId = "player", caster = "all", filter = "DEBUFF" },
				--震懾波
				{ spellID = 46968, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--沉默 - 窒息律令
				{ spellID = 18498, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--繳械
				{ spellID = 676, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--斷筋雕紋
				{ spellID = 58373, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--強化斷筋
				{ spellID = 23694, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--斷筋
				{ spellID = 1715, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--刺耳怒吼
				{ spellID = 12323, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--戰爭踐踏
				{ spellID = 20549, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--奧流之術
				{ spellID = 25046, unitId = "player", caster = "all", filter = "DEBUFF" }, 
				--暈眩
				{ spellID = 29703, unitId = "player", caster = "all", filter = "DEBUFF" },  
		},
		{
			name = "药水减伤等Buff",
			direction = "RIGHT",
			setpoint = {"CENTER", UIParent, "CENTER", -319, 68},
			size = 50,
				-- 火山药水
				{ spellID = 79476, unitId = "player", caster = "player", filter = "BUFF" },  
				-- 英勇
				{ spellID = 80353, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 时间扭曲
				{ spellID = 32182, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 上古狂乱
				{ spellID = 90355, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 托维尔药水
				{ spellID = 79633, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 魔像药水
				{ spellID = 79634, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 能量灌注
				{ spellID = 10060, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 痛苦镇压
				{ spellID = 33206, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 真言術壁
				{ spellID = 81782, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 真言術壁
				{ spellID = 81781, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 集结呐喊
				{ spellID = 97463, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 神性犧牲
				{ spellID = 70940, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 反魔法領域
				{ spellID = 50461, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 靈魂連接圖騰
				{ spellID = 98007, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 邪惡狂熱
				{ spellID = 8699, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 寧靜
				{ spellID = 44203, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 神聖禮頌
				{ spellID = 64844, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 神聖禮頌
				{ spellID = 64843, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 希望禮頌
				{ spellID = 64904, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 希望禮頌
				{ spellID = 64901, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 守护圣灵
				{ spellID = 47788, unitId = "player", caster = "all", filter = "BUFF" },
				--战士4T13防御
				{ spellID = 105914, unitId = "player", caster = "all", filter = "BUFF" },
				--群体恢复
				{ spellID = 105739, unitId = "player", caster = "all", filter = "BUFF" },
				-- 佯攻
				{ spellID =  1966, unitId = "player", caster = "player", filter = "BUFF" }, 

		},
		{
			name = "玩家重要Buff",
			direction = "RIGHT",
			setpoint = {"CENTER", UIParent, "CENTER", -319, 8},
			size = 50,
				-- 急速射击
				{ spellID =  3045, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 4T12特效
				{ spellID = 99060, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 强化法力宝石
				{ spellID = 83098, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 奥术强化
				{ spellID = 12042, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 黑天使
				{ spellID = 87153, unitId = "player", caster = "player", filter = "BUFF" },   
				-- 消散
				{ spellID = 47585, unitId = "player", caster = "player", filter = "BUFF" },   
				-- 劍舞
				{ spellID = 13877, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 能量刺激
				{ spellID = 13750, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 荷枪实弹
				{ spellID = 56453, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 开火!
				{ spellID = 82926, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 冰霜之指
				{ spellID = 44544, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 腦部凍結
				{ spellID = 57761, unitId = "player", caster = "player", filter = "BUFF" }, 
				--焦炎之痕
				{ spellID =48108, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 機緣回復
				{ spellID = 63735, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 光之澎湃
				{ spellID = 88688, unitId = "player", caster = "player", filter = "BUFF" }, 
				--聖盾術
				{ spellID = 642, unitId = "player", caster = "player", filter = "DEBUFF" },  
				--寒冰屏障
				{ spellID = 45438, unitId = "player", caster = "player", filter = "DEBUFF" },  
				--獸心
				{ spellID = 34692, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				--猎人4T13
				{ spellID = 105919, unitId = "player", caster = "player", filter = "BUFF" },
				--保护韧性
				{ spellID = 33143, unitId = "player", caster = "player", filter = "BUFF" },
				--移星换月
				{ spellID = 105864, unitId = "player", caster = "player", filter = "BUFF" },
				--求生本能
				{ spellID = 61336, unitId = "player", caster = "player", filter = "BUFF" }, 
				--狂怒
				{ spellID = 5229, unitId = "player", caster = "player", filter = "BUFF" }, 
				--狂暴恢复
				{ spellID = 22842, unitId = "player", caster = "player", filter = "BUFF" }, 
				--狂暴
				{ spellID = 50334, unitId = "player", caster = "player", filter = "BUFF" }, 
				--树皮术
				{ spellID = 22812, unitId = "player", caster = "player", filter = "BUFF" }, 
				--橙色匕首特效
				{ spellID = 109949, unitId = "player", caster = "player", filter = "BUFF" },
		},
				{
			name = "玩家饰品附魔触发buff",
			direction = "RIGHT",
			setpoint ={"BOTTOM", UIParent, "BOTTOM",-68, 230},
			size = 20,
				--电容器
				{ spellID = 96890, unitId = "player", caster = "player", filter = "BUFF" }, 
				--死灵法师极核
				{ spellID = 97131, unitId = "player", caster = "player", filter = "BUFF" }, 
				--神經突觸彈簧
				{ spellID = 96230, unitId = "player", caster = "player", filter = "BUFF" }, 
				--炎魔印記
				{ spellID = 97007, unitId = "player", caster = "player", filter = "BUFF" }, 
				--織炎精華
				{ spellID = 97008, unitId = "player", caster = "player", filter = "BUFF" }, 
				--遠古石化種子
				{ spellID = 97009, unitId = "player", caster = "player", filter = "BUFF" }, 
				--吞噬
				{ spellID = 96911, unitId = "player", caster = "player", filter = "BUFF" }, 
				--火山毀滅
				{ spellID = 89091, unitId = "player", caster = "player", filter = "BUFF" }, 
				--能量洪流
				{ spellID = 74241, unitId = "player", caster = "player", filter = "BUFF" }, 
				--災厄魔力
				{ spellID = 92318, unitId = "player", caster = "player", filter = "BUFF" }, 
				--光紋
				{ spellID = 75170, unitId = "player", caster = "player", filter = "BUFF" }, 
				--崩土流石
				{ spellID = 74245, unitId = "player", caster = "player", filter = "BUFF" }, 
				--燧鎖的發射器
				{ spellID = 99621, unitId = "player", caster = "player", filter = "BUFF" }, 
				--矩阵加速
				{ spellID = 96977, unitId = "player", caster = "player", filter = "BUFF" }, 
				--矩阵暴击
				{ spellID = 96978, unitId = "player", caster = "player", filter = "BUFF" }, 
				--矩阵精通
				{ spellID = 96979, unitId = "player", caster = "player", filter = "BUFF" }, 
				--贼4T12加速(火上的未來)
				{ spellID = 99186, unitId = "player", caster = "player", filter = "BUFF" }, 
				--贼4T12暴击(熾熱破壞)
				{ spellID = 99187, unitId = "player", caster = "player", filter = "BUFF" }, 
				--贼4T12精通(火焰大師)
				{ spellID = 96978, unitId = "player", caster = "player", filter = "BUFF" }, 
				--H無縛之怒  觸發buff名字:作戰狀態 X
				{ spellID =109719, unitId = "player", caster = "player", filter = "BUFF" },  
				--H淨縛之意志  觸發buff名字:鬥心 X
				{ spellID =109795, unitId = "player", caster = "player", filter = "BUFF" },  
				--H無命之心 觸發buff名字:開闊思維 X
				{ spellID =109813, unitId = "player", caster = "player", filter = "BUFF" },  
				--H壞滅之眼  觸發buff名字:泰坦之力 X
				{ spellID =77997, unitId = "player", caster = "player", filter = "BUFF" },  
				--H不朽的決心  觸發buff名字:超自然閃避 X
				{ spellID =109782, unitId = "player", caster = "player", filter = "BUFF" }, 
				--H七徵聖印   觸發buff名字:速度
				{ spellID =109804, unitId = "player", caster = "player", filter = "BUFF" },  
				--H靈魂轉移者漩渦  觸發buff名字:戰術大師 
				{ spellID =109776, unitId = "player", caster = "player", filter = "BUFF" },  
				--H腐敗心靈徽記  觸發buff名字:速度 
				{ spellID =109789, unitId = "player", caster = "player", filter = "BUFF" }, 
				--H末代之龍的誕生塑像   觸發buff名字:找尋弱點
				{ spellID =109744, unitId = "player", caster = "player", filter = "BUFF" },  
				--H擒星羅盤   觸發buff名字:速度
				{ spellID =109711, unitId = "player", caster = "player", filter = "BUFF" }, 
				--H基洛提瑞克符印  觸發buff名字:輕靈
				{ spellID =109715, unitId = "player", caster = "player", filter = "BUFF" },  
				--H瓶裝願望   觸發buff名字:究極之力
				{ spellID =109792, unitId = "player", caster = "player", filter = "BUFF" },  
				--H聖光倒影   觸發buff名字:究極之力
				{ spellID =109792, unitId = "player", caster = "player", filter = "BUFF" }, 
				--H腐爛頭顱  觸發buff名字:泰坦之力
				{ spellID =109747, unitId = "player", caster = "player", filter = "BUFF" }, 
				--H深淵之火  觸發buff名字:難以捉摸
				{ spellID =109779, unitId = "player", caster = "player", filter = "BUFF" },   
				--無縛之怒  觸發buff名字:作戰狀態 X
				{ spellID =107960, unitId = "player", caster = "player", filter = "BUFF" },  
				--淨縛之意志  觸發buff名字:鬥心 X
				{ spellID =107970, unitId = "player", caster = "player", filter = "BUFF" },  
				--無命之心  觸發buff名字:開闊思維 X
				{ spellID =107962, unitId = "player", caster = "player", filter = "BUFF" }, 
				--壞滅之眼  觸發buff名字:泰坦之力 X
				{ spellID =107967, unitId = "player", caster = "player", filter = "BUFF" },  
				--不朽的決心  觸發buff名字:超自然閃避 X
				{ spellID =107968, unitId = "player", caster = "player", filter = "BUFF" }, 
				--基洛提瑞克符印 觸發buff名字:輕靈
				{ spellID =107947, unitId = "player", caster = "player", filter = "BUFF" }, 
				--瓶裝願望  觸發buff名字:究極之力
				{ spellID =107948, unitId = "player", caster = "player", filter = "BUFF" }, 
				--聖光倒影  觸發buff名字:究極之力
				{ spellID =107948, unitId = "player", caster = "player", filter = "BUFF" }, 
				--腐爛頭顱  觸發buff名字:泰坦之力
				{ spellID =107949, unitId = "player", caster = "player", filter = "BUFF" }, 
				--深淵之火  觸發buff名字:難以捉摸
				{ spellID =107951, unitId = "player", caster = "player", filter = "BUFF" }, 
				--擒星羅盤  觸發buff名字:速度
				{ spellID =107982, unitId = "player", caster = "player", filter = "BUFF" }, 
				--腐敗心靈徽記  觸發buff名字:速度 
				{ spellID =107982, unitId = "player", caster = "player", filter = "BUFF" }, 
				--七徵聖印   觸發buff名字:速度
				{ spellID =107982, unitId = "player", caster = "player", filter = "BUFF" }, 
				--末代之龍的誕生塑像  觸發buff名字:找尋弱點
				{ spellID =107988, unitId = "player", caster = "player", filter = "BUFF" }, 
				--靈魂轉移者漩渦  觸發buff名字:戰術大師
				{ spellID =107986, unitId = "player", caster = "player", filter = "BUFF" }, 
				--時間之箭  觸發buff名字:時間之箭
				{ spellID =102659, unitId = "player", caster = "player", filter = "BUFF" }, 
				--惡魔領主之賜  觸發buff名字:邪惡之禮 
				{ spellID =102662, unitId = "player", caster = "player", filter = "BUFF" },  
				--惡魔領主之賜  觸發buff名字:邪惡之禮 
				{ spellID =109908, unitId = "player", caster = "player", filter = "BUFF" }, 
				--L七徵聖印  觸發buff名字:速度
				{ spellID =109802, unitId = "player", caster = "player", filter = "BUFF" }, 
				--L腐敗心靈徽記  觸發buff名字:速度
				{ spellID =109802, unitId = "player", caster = "player", filter = "BUFF" }, 
				--L擒星羅盤  觸發buff名字:速度
				{ spellID =109802, unitId = "player", caster = "player", filter = "BUFF" }, 
				--L無縛之怒 X 觸發buff名字:作戰狀態
				{ spellID =109717, unitId = "player", caster = "player", filter = "BUFF" }, 
				--L淨縛之意志  X  觸發buff名字:鬥心
				{ spellID =109793, unitId = "player", caster = "player", filter = "BUFF" }, 
				--L無命之心 X  觸發buff名字:開闊思維
				{ spellID =109811, unitId = "player", caster = "player", filter = "BUFF" }, 
				--L壞滅之眼  X   觸發buff名字:泰坦之力
				{ spellID =109748, unitId = "player", caster = "player", filter = "BUFF" }, 
				--L不朽的決心  X 觸發buff名字:超自然閃避
				{ spellID =109780, unitId = "player", caster = "player", filter = "BUFF" }, 
				-- 暗月卡片:海啸
				{ spellID = 89182, unitId = "player", caster = "player", filter = "BUFF" },
				--偷取时间
				{ spellID = 105785, unitId = "player", caster = "player", filter = "BUFF" },
				--橙色匕首
				{ spellID = 109941, unitId = "player", caster = "player", filter = "BUFF" },
		},
	},
}