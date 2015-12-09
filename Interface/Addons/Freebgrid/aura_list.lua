local _, ns = ...

local foo = {""}
local spellcache = setmetatable({}, 
{__index=function(t,id) 
	local a = {GetSpellInfo(id)} 

	if GetSpellInfo(id) then
	    t[id] = a
	    return a
	end

   t[id] = foo
	return foo
end
})
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
	[GetSpellInfo(89435)]= true,
	[GetSpellInfo(89421)]= true,
}

ns.auras_buffs = {
	first = {

	},
	second = {
		--------------------------战士---------------
		[GetSpellInfo(871)]     = 2,	-- 盾墙
		[GetSpellInfo(12975)]   = 2,	-- 破釜沉舟
		[GetSpellInfo(97462)]   = 2,	-- 集结呐喊
		[GetSpellInfo(2565)]    = 2,	-- 盾牌格挡
		[GetSpellInfo(112048)]  = 2,	-- 盾牌屏障
		--------------------------骑士---------------
		[GetSpellInfo(642)]     = 2,	-- 圣盾术
		[GetSpellInfo(86659)]   = 2,	-- 远古列王守卫
		[GetSpellInfo(31821)]   = 2,	-- 虔诚光环
		[GetSpellInfo(31850)]   = 2,	-- 炽热防御者
		[GetSpellInfo(498)]     = 2,	-- 圣佑术
		[GetSpellInfo(1022)]    = 2,	-- 保护之手
		[GetSpellInfo(1038)]    = 2,	-- 拯救之手
		[GetSpellInfo(6940)]    = 2,	-- 牺牲之手
		[GetSpellInfo(114039)]  = 2,	-- 纯净之手
		--------------------------DK---------------
		[GetSpellInfo(48707)]   = 2,	-- 反魔法护罩
		[GetSpellInfo(50461)]   = 2,	-- 反魔法领域
		[GetSpellInfo(48792)]   = 2,	-- 冰封之韧
		[GetSpellInfo(55233)]   = 2,	-- 吸血鬼之血
		[GetSpellInfo(81256)]   = 2,	-- 符文刃舞
		[GetSpellInfo(171049)]  = 2,	-- 符文分流
		------------------------德鲁伊---------------
		[GetSpellInfo(22812)]   = 2,	-- 树皮术
		[GetSpellInfo(22842)]   = 2,	-- 狂暴回复
		[GetSpellInfo(61336)]   = 2,	-- 生存本能
		[GetSpellInfo(155835)]  = 2,	-- 鬃毛倒竖
		[GetSpellInfo(102342)]  = 2,	-- 铁木树皮
		[GetSpellInfo(132402)]  = 2,	-- 野蛮防御
		------------------------牧师--------------------
		[GetSpellInfo(33206)]   = 2,	-- 痛苦压制
		[GetSpellInfo(47788)]   = 2,	-- 守护之魂
		[GetSpellInfo(62618)]   = 2,	-- 真言术:障
		------------------------武僧--------------------
		[GetSpellInfo(116849)]  = 2,	-- 作茧缚命
		[GetSpellInfo(115176)]  = 2,	-- 禅悟冥想
		[GetSpellInfo(122783)]  = 2,	-- 散魔功
		[GetSpellInfo(115308)]  = 2,	-- 飘渺酒
		[GetSpellInfo(115295)]  = 2,	-- 金钟罩
		[GetSpellInfo(115203)]  = 2,	-- 壮胆酒
		[GetSpellInfo(122278)]  = 2,	-- 躯不坏
		------------------------橙戒-------------------
		[GetSpellInfo(187616)]  = 1,	-- 尼萨姆斯
		[GetSpellInfo(187617)]  = 1,	-- 伊瑟拉鲁斯
		[GetSpellInfo(187618)]  = 1,	-- 索拉苏斯
		[GetSpellInfo(187619)]  = 1,	-- 索拉苏斯
		[GetSpellInfo(187620)]  = 1,	-- 玛鲁斯
	},
}

ns.auras_debuffs = {
	first = {
		[GetSpellInfo(39171)]   = 9,	-- 致伤打击
		[GetSpellInfo(76622)]   = 9,	-- 破甲攻击
	},
	second = {
	
	},	
}

ns.auras_instances_debuffs = {
	first = {
-------------------------------德拉诺之王------------------------------------
		[1026] = {-- 地狱火堡垒

			-- 小怪 Trash
			[GetSpellInfo(185806)] = 5, -- 导电冲击脉冲
			[GetSpellInfo(187459)] = 4, -- 魔能震击
			[GetSpellInfo(190735)] = 6, -- 腐化虹吸
			[GetSpellInfo(188087)] = 6, -- 地火滔天
			[GetSpellInfo(188216)] = 5, -- 烈焰
			[GetSpellInfo(188189)] = 4, -- 邪能污秽
			[GetSpellInfo(187122)] = 5, -- 原始能量
			[GetSpellInfo(188541)] = 6, -- 狂乱
			[GetSpellInfo(187099)] = 5, -- 暗影残渣
			[GetSpellInfo(187110)] = 6, -- 集火
			[GetSpellInfo(188474)] = 6, -- 活动炸弹
			[GetSpellInfo(188104)] = 6, -- 定向爆破
			[GetSpellInfo(188476)] = 4, -- 口臭
			[GetSpellInfo(188510)] = 5, -- 加拉戈之击
			[GetSpellInfo(182644)] = 6, -- 黑暗命运
			[GetSpellInfo(184587)] = 5, -- 致死之触
			[GetSpellInfo(186046)] = 5, -- 炽阳飞轮
			[GetSpellInfo(186197)] = 5, -- 恶魔献祭
			[GetSpellInfo(190044)] = 6, -- 邪血腐蚀
			[GetSpellInfo(189551)] = 5, -- 噬灵之击
			[GetSpellInfo(189554)] = 6, -- 吞噬之痛
			[GetSpellInfo(189564)] = 5, -- 蛰伏
			[GetSpellInfo(189532)] = 5, -- 灵魂灼烧
			[GetSpellInfo(184734)] = 5, -- 地火斩
			[GetSpellInfo(184725)] = 4, -- 暗影烈焰冲击
			[GetSpellInfo(189550)] = 5, -- 火焰之雨

			-- 奇袭地狱火 Hellfire Assault
			[GetSpellInfo(184369)] = 6, -- 啸风战斧
			[GetSpellInfo(184243)] = 4, -- 猛击
			[GetSpellInfo(184238)] = 1, -- 颤抖！
			[GetSpellInfo(180022)] = 2, -- 钻孔
			[GetSpellInfo(185157)] = 6, -- 灼烧
			[GetSpellInfo(180079)] = 6, -- 邪火弹药

			-- 钢铁掠夺者 Fel Reaver
			[GetSpellInfo(182280)] = 6, -- 炮击
			[GetSpellInfo(185242)] = 5, -- 迅猛突袭
			[GetSpellInfo(182003)] = 1, -- 燃料尾痕
			[GetSpellInfo(182074)] = 3, -- 献祭
			[GetSpellInfo(182001)] = 4, -- 不稳定的宝珠
			[GetSpellInfo(185978)] = 2, -- 火焰炸弹易伤

			-- 考莫克 Kormrok
			[GetSpellInfo(181306)] = 6, -- 爆裂冲击
			[GetSpellInfo(181321)] = 1, -- 邪能之触
			[GetSpellInfo(188081)] = 2, -- 重碾
			[GetSpellInfo(181345)] = 5, -- 邪污碾压
			[GetSpellInfo(186559)] = 6, -- 火焰之池
			[GetSpellInfo(185519)] = 2, -- 炽热血球
			[GetSpellInfo(181082)] = 6, -- 暗影之池
			[GetSpellInfo(180270)] = 2, -- 暗影血球
			[GetSpellInfo(186560)] = 6, -- 邪污之池
			[GetSpellInfo(185521)] = 2, -- 邪污血球

			-- 高阶地狱火议会 Hellfire High Council
			[GetSpellInfo(184450)] = 5, -- 死灵印记
			[GetSpellInfo(184652)] = 6, -- 暗影收割
			[GetSpellInfo(184847)] = 4, -- 酸性创伤
			[GetSpellInfo(184358)] = 5, -- 邪能狂怒
			[GetSpellInfo(184357)] = 1, -- 污血
			[GetSpellInfo(184355)] = 4, -- 血液沸腾

			-- 基尔罗格·死眼 Kilrogg Deadeye
			[GetSpellInfo(188929)] = 6, -- 剖心飞刀 
			[GetSpellInfo(188852)] = 5, -- 溅血
			[GetSpellInfo(182159)] = 2, -- 邪能腐蚀
			[GetSpellInfo(180200)] = 4, -- 碎甲
			[GetSpellInfo(181488)] = 3, -- 死亡幻象
			[GetSpellInfo(189612)] = 3, -- 撕裂嚎叫
			[GetSpellInfo(180033)] = 3, -- 灰烬吐息
			[GetSpellInfo(184067)] = 5, -- 邪能腐液

			-- 血魔 Gorefiend
			[GetSpellInfo(179864)] = 5, -- 死亡之影
			[GetSpellInfo(181295)] = 3, -- 消化
			[GetSpellInfo(179867)] = 2, -- 血魔的腐化
			[GetSpellInfo(179978)] = 6, -- 毁灭之触
			[GetSpellInfo(179995)] = 5, -- 末日井
			[GetSpellInfo(179909)] = 6, -- 命运相连 (定身)
			[GetSpellInfo(179908)] = 6, -- 命运相连
			[GetSpellInfo(182601)] = 5, -- 邪能之怒
			[GetSpellInfo(185189)] = 5, -- 邪能烈焰
			[GetSpellInfo(180148)] = 6, -- 生命渴望
			[GetSpellInfo(180093)] = 1, -- 灵魂箭雨
			[GetSpellInfo(186770)] = 5, -- 灵魂之池

			-- 暗影领主艾斯卡 Shadow-Lord Iskar
			[GetSpellInfo(179202)] = 5, -- 安苏之眼
			[GetSpellInfo(185239)] = 6, -- 安苏之光
			[GetSpellInfo(181957)] = 5, -- 幻影之风
			[GetSpellInfo(182325)] = 2, -- 幻影之伤
			[GetSpellInfo(182200)] = 3, -- 邪能飞轮
			[GetSpellInfo(185747)] = 3, -- 邪能光束锁定
			[GetSpellInfo(179219)] = 4, -- 幻影邪能炸弹
			[GetSpellInfo(181753)] = 7, -- 邪能炸弹
			[GetSpellInfo(187990)] = 4, -- 幻影腐蚀
			[GetSpellInfo(187344)] = 1, -- 幻影焚化
			[GetSpellInfo(185510)] = 2, -- 暗影之缚

			-- 永恒者索克雷萨 Soulbound Construct
			[GetSpellInfo(182038)] = 3, -- 粉碎防御
			[GetSpellInfo(189627)] = 5, -- 易爆的邪能宝珠
			[GetSpellInfo(189540)] = 2, -- 压倒能量
			[GetSpellInfo(182218)] = 5, -- 邪炽残渣
			[GetSpellInfo(180415)] = 1, -- 邪能牢笼
			[GetSpellInfo(182769)] = 6, -- 魅影重重
			[GetSpellInfo(182900)] = 4, -- 恶毒鬼魅
			[GetSpellInfo(184124)] = 3, -- 堕落者之赐
			[GetSpellInfo(184239)] = 4, -- 暗言术：恶
			[GetSpellInfo(190922)] = 2, -- 无拘之力

			-- 邪能领主扎昆 Fel Lord Zakuun
			[GetSpellInfo(181508)] = 6, -- 毁灭之种
			[GetSpellInfo(179428)] = 5, -- 轰鸣的裂隙
			[GetSpellInfo(182008)] = 2, -- 潜伏能量
			[GetSpellInfo(189260)] = 3, -- 破碎之魂
			[GetSpellInfo(179407)] = 1, -- 魂不附体
			[GetSpellInfo(189030)] = 6, -- 玷污
			--[GetSpellInfo(179711)] = 6, -- 玷污
			--[GetSpellInfo(189031)] = 6, -- 玷污
			--[GetSpellInfo(189032)] = 6, -- 玷污
			[GetSpellInfo(181653)] = 5, -- 邪能水晶
			[GetSpellInfo(188998)] = 2, -- 枯竭灵魂

			-- 祖霍拉克 Xhul'horac
			[GetSpellInfo(186134)] = 2, -- 邪蚀
			[GetSpellInfo(186135)] = 2, -- 邪能炙烤
			[GetSpellInfo(186407)] = 7, -- 魔能喷涌
			[GetSpellInfo(186333)] = 7, -- 灵能涌动
			[GetSpellInfo(185656)] = 1, -- 邪影屠戮
			[GetSpellInfo(186500)] = 6, -- 邪能锁链
			[GetSpellInfo(186448)] = 4, -- 邪焰乱舞
			[GetSpellInfo(188208)] = 3, -- 点燃
			[GetSpellInfo(186547)] = 5, -- 黑洞
			[GetSpellInfo(186785)] = 4, -- 凋零凝视
			[GetSpellInfo(186073)] = 3, -- 邪能炙烤
			[GetSpellInfo(186063)] = 3, -- 虚空消耗

			-- 暴君维哈里 Tyrant Velhari
			[GetSpellInfo(180166)] = 5, -- 裂伤之触
			[GetSpellInfo(180128)] = 6, -- 谴责法令
			[GetSpellInfo(180526)] = 6, -- 腐蚀序列
			[GetSpellInfo(180000)] = 4, -- 凋零契印
			[GetSpellInfo(181683)] = 1, -- 抑制光环
			[GetSpellInfo(179987)] = 1, -- 蔑视光环
			[GetSpellInfo(179993)] = 1, -- 怨恨光环
			[GetSpellInfo(180604)] = 3, -- 亵渎之地

			-- 玛诺洛斯 Mannoroth
			[GetSpellInfo(181099)] = 6, -- 末日印记
			[GetSpellInfo(181275)] = 3, -- 军团诅咒
			[GetSpellInfo(181119)] = 4, -- 末日之刺
			[GetSpellInfo(182171)] = 2, -- 玛诺洛斯之血
			[GetSpellInfo(181359)] = 5, -- 巨力冲击
			[GetSpellInfo(184252)] = 3, -- 穿刺之伤
			[GetSpellInfo(181597)] = 4, -- 玛诺洛斯凝视
			[GetSpellInfo(181841)] = 6, -- 暗影之力
			[GetSpellInfo(182113)] = 1, -- 徘徊力场
			[GetSpellInfo(182088)] = 6, -- 强化暗影之力
			[GetSpellInfo(182006)] = 4, -- 强化玛诺洛斯凝视
			[GetSpellInfo(182031)] = 3, -- 凝视暗影
			[GetSpellInfo(186362)] = 6, -- 古尔丹之怒
			[GetSpellInfo(190482)] = 2, -- 186362

			-- 阿克蒙德 Archimonde
			[GetSpellInfo(183634)] = 6, -- 邪影爆裂
			[GetSpellInfo(183828)] = 4, -- 死亡烙印
			[GetSpellInfo(183963)] = 1, -- 纳鲁之光
			[GetSpellInfo(182879)] = 6, -- 魔火锁定
			[GetSpellInfo(182878)] = 2, -- 魔火
			[GetSpellInfo(183864)] = 3, -- 暗影冲击
			[GetSpellInfo(184964)] = 6, -- 枷锁酷刑
			[GetSpellInfo(186123)] = 5, -- 精炼混乱
			[GetSpellInfo(185014)] = 5, -- 聚焦混乱
			[GetSpellInfo(186961)] = 6, -- 虚空放逐
			[GetSpellInfo(189891)] = 3, -- 虚空撕裂
			[GetSpellInfo(187047)] = 2, -- 吞噬生命
			[GetSpellInfo(190341)] = 2, -- 虚空腐化
			[GetSpellInfo(187255)] = 3, -- 虚空风暴
			[GetSpellInfo(189895)] = 5, -- 虚空之星锁定
			[GetSpellInfo(190400)] = 3, -- 军团之触
			[GetSpellInfo(187050)] = 6, -- 军团标记
			[GetSpellInfo(190706)] = 2, -- 混沌之源
		},


		[988] = {--黑石铸造厂
			-- 1 Gruul 格鲁尔
			[GetSpellInfo(155080)] = 5, -- 炼狱切割
			[GetSpellInfo(155078)] = 6, -- 压迫打击
			[GetSpellInfo(162322)] = 6, -- 炼狱打击
			[GetSpellInfo(155506)] = 5, -- 石化
			[GetSpellInfo(155326)] = 5, -- 石化猛击
			[GetSpellInfo(165298)] = 6, -- 火耀石M

			-- 2 Oregorger 奥尔高格
			[GetSpellInfo(156203)] = 5, -- 呕吐黑石
			[GetSpellInfo(156374)] = 5, -- 爆裂残片
			[GetSpellInfo(156297)] = 6, -- 酸液洪流
			[GetSpellInfo(173471)] = 5, -- 酸液巨口
			[GetSpellInfo(155900)] = 3, -- 翻滚之怒

			-- 3 Blast Furnace 爆裂熔炉
			[GetSpellInfo(156932)] = 5, -- 崩裂
			[GetSpellInfo(178279)] = 4, -- 炸弹
			[GetSpellInfo(155192)] = 4, -- 炸弹
			[GetSpellInfo(174176)] = 4, -- 炸弹
			[GetSpellInfo(176121)] = 4, -- 不稳定的火焰
			[GetSpellInfo(155196)] = 4, -- 锁定
			[GetSpellInfo(155743)] = 5, -- 熔渣池
			[GetSpellInfo(155240)] = 6, -- 淬火
			[GetSpellInfo(155242)] = 5, -- 高热
			[GetSpellInfo(155225)] = 5, -- 熔化
			[GetSpellInfo(155223)] = 5, -- 熔化

			-- 4 Hans'gar and Franzok 汉斯加尔与弗兰佐克 
			[GetSpellInfo(157139)] = 6, -- 折脊碎椎
			[GetSpellInfo(160838)] = 6, -- 干扰怒吼
			[GetSpellInfo(160845)] = 6, -- 干扰怒吼
			[GetSpellInfo(160847)] = 6, -- 干扰怒吼
			[GetSpellInfo(160848)] = 6, -- 干扰怒吼
			[GetSpellInfo(155818)] = 4, -- 灼热燃烧
			[GetSpellInfo(157853)] = 5, -- 余震

			-- 5 Flamebender Ka'graz 缚火者卡格拉兹 
			[GetSpellInfo(154952)] = 4, -- 锁定
			[GetSpellInfo(155074)] = 6, -- 焦灼吐息
			[GetSpellInfo(155049)] = 4, -- 烧灼
			[GetSpellInfo(154932)] = 5, -- 熔岩激流
			[GetSpellInfo(155277)] = 4, -- 炽热光辉
			[GetSpellInfo(155314)] = 5, -- 岩浆猛击
			[GetSpellInfo(163284)] = 5, -- 升腾烈焰

			-- 6 Kromog 克罗莫格 
			[GetSpellInfo(156766)] = 6, -- 扭曲护甲
			[GetSpellInfo(157059)] = 5, -- 纠缠之地符文
			[GetSpellInfo(161839)] = 7, -- 破碎大地符文
			[GetSpellInfo(161923)] = 7, -- 破碎大地符文

			-- 7 Beastlord Darmac 兽王达玛克
			[GetSpellInfo(154960)] = 6, -- 长矛钉刺
			[GetSpellInfo(155061)] = 5, -- 狂乱撕扯
			[GetSpellInfo(162283)] = 6, -- 狂乱撕扯
			[GetSpellInfo(154989)] = 6, -- 炼狱吐息
			[GetSpellInfo(154981)] = 6, -- 爆燃
			[GetSpellInfo(155030)] = 6, -- 炽燃利齿
			[GetSpellInfo(155236)] = 6, -- 碾碎护甲
			[GetSpellInfo(155499)] = 6, -- 高热弹片
			[GetSpellInfo(155657)] = 5, -- 烈焰灌注
			[GetSpellInfo(159044)] = 6, -- 地动山摇
			[GetSpellInfo(162277)] = 6, -- 地动山摇

			-- 8 Operator Thogar 主管索戈尔 
			[GetSpellInfo(155921)] = 5, -- 点燃
			[GetSpellInfo(165195)] = 5, -- 实验型脉冲手雷
			[GetSpellInfo(160140)] = 4, -- 灼疗之箭
			[GetSpellInfo(155921)] = 4, -- 锯齿劈斩
			[GetSpellInfo(156310)] = 5, -- 熔岩震击
			[GetSpellInfo(159481)] = 6, -- 延时攻城炸弹
			[GetSpellInfo(164380)] = 5, -- 燃烧
			[GetSpellInfo(164280)] = 5, -- 热能冲击

			-- 9 Iron Maidens 钢铁女武神 
			[GetSpellInfo(156631)] = 2, -- 急速射击
			[GetSpellInfo(164271)] = 6, -- 穿透射击
			[GetSpellInfo(158601)] = 6, -- 主炮轰击
			[GetSpellInfo(156214)] = 5, -- 震颤暗影
			[GetSpellInfo(158315)] = 6, -- 暗影猎杀
			[GetSpellInfo(159724)] = 4, -- 鲜血仪式
			[GetSpellInfo(158010)] = 5, -- 浸血觅心者
			[GetSpellInfo(158692)] = 6, -- 致命投掷
			[GetSpellInfo(158702)] = 4, -- 锁定
			[GetSpellInfo(158683)] = 5, -- 堕落之血
			[GetSpellInfo(170405)] = 6, -- 玛拉卡的血腥召唤
			[GetSpellInfo(170395)] = 6, -- 苏卡的猎物

			-- 10 Warlord Blackhand  黑手 
			[GetSpellInfo(156096)] = 4, -- 死亡标记
			[GetSpellInfo(156653)] = 4, -- 锁定
			[GetSpellInfo(157354)] = 5, -- 断骨
			[GetSpellInfo(156047)] = 6, -- 熔渣冲击
			[GetSpellInfo(157018)] = 6, -- 熔渣冲击
			[GetSpellInfo(157322)] = 6, -- 熔渣冲击
			[GetSpellInfo(156743)] = 7, -- 穿刺
			[GetSpellInfo(175020)] = 7, -- 穿刺
			[GetSpellInfo(158054)] = 7, -- 巨力粉碎猛击
			[GetSpellInfo(162490)] = 5, -- 燃烧
			[GetSpellInfo(156604)] = 5, -- 燃烧
			[GetSpellInfo(156401)] = 5, -- 熔火熔渣
			[GetSpellInfo(156404)] = 6, -- 烧伤
			[GetSpellInfo(156772)] = 5, -- 燃烧射击
			[GetSpellInfo(157000)] = 4, -- 投掷炉渣炸弹
			[GetSpellInfo(159179)] = 4, -- 投掷炉渣炸弹
		},

		[994] = {--悬槌堡
			-- Trash 小怪
			[GetSpellInfo(175601)]=  5, -- 污染之爪
			[GetSpellInfo(175599)]=  4, -- 吞噬
			[GetSpellInfo(172069)]=  5, -- 剧毒辐射
			[GetSpellInfo(172066)]=  4, -- 剧毒辐射
			[GetSpellInfo(166779)]=  5, -- 震荡打击
			[GetSpellInfo( 56037)]=  4, -- 毁灭符文
			[GetSpellInfo(175654)]=  5, -- 瓦解符文
			[GetSpellInfo(166185)]=  5, -- 撕裂猛击
			[GetSpellInfo(166175)]=  5, -- 裂地打击
			[GetSpellInfo(174404)]=  5, -- 冰冻核心
			[GetSpellInfo(173827)]=  5, -- 野火
			[GetSpellInfo(174500)]=  5, -- 撕裂投掷
			[GetSpellInfo(174939)]=  4, -- 时间停止
			[GetSpellInfo(166200)]=  4, -- 奥能动荡
			[GetSpellInfo(161635)]=  5, -- 熔火炸弹
			[GetSpellInfo(172115)]=  4, -- 大地冲击
			[GetSpellInfo(174473)]=  5, -- 堕落之血

			-- 1 Kargath Bladefist 卡加斯·刃拳
			[GetSpellInfo(159113)]=  5, -- 穿刺(Dot)
			[GetSpellInfo(159178)]=  6, -- 迸裂创伤(坦克)
			[GetSpellInfo(159213)]=  7, -- 困兽犹斗
			[GetSpellInfo(158986)]=  4, -- 狂暴冲锋
			[GetSpellInfo(159413)]=  5, -- 暴虐酒
			[GetSpellInfo(160521)]=  6, -- 邪恶吐息
			[GetSpellInfo(159386)]=  5, -- 钢铁炸弹
			[GetSpellInfo(159188)]=  5, -- 抓钩
			[GetSpellInfo(162497)]=  4, -- 搜寻猎物(M)
			[GetSpellInfo(159311)]=  5, -- 烈焰喷射
			--[GetSpellInfo(159947)]=  5, -- 锁链投掷

			-- 2 The Butcher  屠夫
			[GetSpellInfo(156152)]=  5, -- 龟裂创伤
			[GetSpellInfo(156151)]=  6, -- 捶肉槌
			[GetSpellInfo(156147)]=  5, -- 切肉刀
			[GetSpellInfo(163046)]=  5, -- 白鬼硫酸(M)

			-- 3 Tectus 泰克图斯
			[GetSpellInfo(162892)]=  5, -- 石化
			[GetSpellInfo(162346)]=  6, -- 晶化弹幕(点名)
			[GetSpellInfo(162370)]=  5, -- 晶化弹幕(踩到)
			[GetSpellInfo(162475)]=  5, -- 地质剧变

			-- 4 Brackenspore 深渊行者布兰肯斯波
			[GetSpellInfo(163242)]=  5, -- 感染孢子
			[GetSpellInfo(163590)]=  5, -- 滑溜溜的苔藓
			[GetSpellInfo(163241)]=  5, -- 溃烂
			[GetSpellInfo(159220)]=  6, -- 死疽吐息
			[GetSpellInfo(160179)]=  6, -- 蚀脑真菌
			[GetSpellInfo(159972)]=  6, 

			-- 5 Twin Ogron 独眼魔双子
			[GetSpellInfo(158026)]=  6, -- 致衰咆哮
			[GetSpellInfo(158241)]=  5, -- 烈焰
			[GetSpellInfo(155569)]=  5, -- 受伤
			[GetSpellInfo(167200)]=  5, -- 奥术之伤
			[GetSpellInfo(159709)]=  6, -- 防御削弱
			[GetSpellInfo(163374)]=  4, -- 奥能动荡
			[GetSpellInfo(158200)]=  4, -- 地震

			-- 6 Ko'ragh 克拉戈
			[GetSpellInfo(161242)]=  4, -- 腐蚀能量
			[GetSpellInfo(161345)]=  4, -- 压制力场
			[GetSpellInfo(162184)]=  6, -- 魔能散射：暗影
			[GetSpellInfo(162186)]=  6, -- 魔能散射：奥术
			[GetSpellInfo(172813)]=  6, -- 魔能散射：冰霜
			[GetSpellInfo(162185)]=  7, -- 魔能散射：火焰
			[GetSpellInfo(163472)]=  4, -- 统御之力
			[GetSpellInfo(172886)]=  5, -- 废灵标记
			[GetSpellInfo(172895)]=  6, -- 魔能散射：邪能(点名)(M)
			[GetSpellInfo(172917)]=  5, -- 魔能散射：邪能(踩到)(M)
			--[GetSpellInfo(163134)]=  7, -- 废灵壁垒

			-- 7 Imperator Mar'gok 元首马尔高克
			[GetSpellInfo(156238)]=  4, -- 奥术愤怒
			[GetSpellInfo(156467)]=  5, -- 毁灭共鸣
			[GetSpellInfo(164075)]=  4, -- 毁灭共鸣：偏移
			[GetSpellInfo(164076)]=  4, -- 毁灭共鸣：强固
			[GetSpellInfo(164077)]=  4, -- 毁灭共鸣：复制
			[GetSpellInfo(158605)]=  4, -- 混沌标记
			[GetSpellInfo(164176)]=  4, -- 混沌标记：偏移
			[GetSpellInfo(164178)]=  4, -- 混沌标记：强固
			[GetSpellInfo(164191)]=  4, -- 混沌标记：复制
			[GetSpellInfo(156225)]=  6, -- 烙印
			[GetSpellInfo(164004)]=  4, -- 烙印：偏移
			[GetSpellInfo(164005)]=  4, -- 烙印：强固
			[GetSpellInfo(164006)]=  4, -- 烙印：复制
			[GetSpellInfo(157349)]=  5, -- 奥能新星
			[GetSpellInfo(157763)]=  4, -- 锁定
			[GetSpellInfo(158553)]=  6, -- 碾碎护甲
			[GetSpellInfo(165595)]=  6, -- 深渊凝视爆炸计时(M)
			[GetSpellInfo(165102)]=  6, -- 无尽黑暗(M)
			[GetSpellInfo(176533)]=  4, -- 蔓延暗影(M)
			--[GetSpellInfo(164232)]=  4, -- 奥能新星：偏移
			--[GetSpellInfo(164235)]=  4, -- 奥能新星：强固
			--[GetSpellInfo(164240)]=  4, -- 奥能新星：复制
			--[GetSpellInfo(158619)]=  5, -- 拘禁
			--[GetSpellInfo(163988)]=  4, -- 奥术愤怒：偏移
			--[GetSpellInfo(163989)]=  4, -- 奥术愤怒：强固
			--[GetSpellInfo(163990)]=  4, -- 奥术愤怒：复制
		},

-------------------------------熊猫人之谜-----------------------------------
			[953]=  {--决战奥格瑞玛
			--小怪
			[GetSpellInfo(149207)]=  1, --腐蚀之触
			[GetSpellInfo(145553)]=  1, --贿赂
			[GetSpellInfo(147554)]=  1, --亚煞极之血

			--伊墨苏斯
			[GetSpellInfo(143297)]=  5, --煞能喷溅
			[GetSpellInfo(143459)]=  4, --煞能残渣
			[GetSpellInfo(143524)]=  4, --净化残渣
			[GetSpellInfo(143286)]=  4, --渗透煞能
			[GetSpellInfo(143413)]=  3, --漩涡
			[GetSpellInfo(143411)]=  3, --增速
			[GetSpellInfo(143436)]=  2, --腐蚀冲击 (坦克)
			[GetSpellInfo(143579)]=  3, --煞能腐蚀 (仅英雄模式)

			--堕落的守护者
			[GetSpellInfo(143239)]=  4, --致命剧毒
			[GetSpellInfo(143198)]=  6, --锁喉
			[GetSpellInfo(143301)]=  2, --凿击
			[GetSpellInfo(143010)]=  3, --蚀骨回旋踢
			[GetSpellInfo(143434)]=  6, --暗言术：蛊 (驱散)
			[GetSpellInfo(143840)]=  6, --苦痛印记
			[GetSpellInfo(143959)]=  4, --亵渎大地
			[GetSpellInfo(143423)]=  6, --煞能灼烧
			[GetSpellInfo(143292)]=  5, --锁定
			[GetSpellInfo(147383)]=  4, --衰竭 (Heroic Only)
			--[GetSpellInfo(144176)]=  5, --暗影虚弱
			--[GetSpellInfo(143564)]=  3, --冥想领域
			--[GetSpellInfo(143023)]=  3, --蚀骨酒

			--诺鲁什
			[GetSpellInfo(146124)]=  2, --自惑 (坦克)
			[GetSpellInfo(146324)]=  4, --妒忌
			[GetSpellInfo(144850)]=  5, --信赖的试炼
			[GetSpellInfo(145861)]=  6, --自恋 (驱散)
			[GetSpellInfo(144851)]=  2, --自信的试炼 (坦克)
			[GetSpellInfo(146703)]=  3, --无底深渊
			[GetSpellInfo(144514)]=  6, --纠缠腐蚀
			[GetSpellInfo(144849)]=  4, --冷静的试炼
			--[GetSpellInfo(144639)]=  6, --腐化

			--傲之煞
			[GetSpellInfo(144358)]=  2, --受损自尊 (坦克)
			[GetSpellInfo(144843)]=  3, --压制
			[GetSpellInfo(146594)]=  4, --泰坦之赐
			[GetSpellInfo(144351)]=  6, --傲慢标记
			[GetSpellInfo(144364)]=  4, --泰坦之力
			[GetSpellInfo(146822)]=  6, --投影
			[GetSpellInfo(146817)]=  5, --傲气光环
			[GetSpellInfo(144774)]=  2, --伸展打击 (坦克)
			[GetSpellInfo(144636)]=  5, --腐化囚笼
			[GetSpellInfo(144574)]=  6, --腐化囚笼，随机
			[GetSpellInfo(145215)]=  4, --放逐 (仅英雄模式)
			[GetSpellInfo(147207)]=  4, --动摇的决心 (仅英雄模式)

			--迦拉卡斯
			[GetSpellInfo(146765)]=  5, --烈焰之箭
			[GetSpellInfo(147705)]=  5, --毒性云雾
			[GetSpellInfo(146902)]=  2, --剧毒利刃

			--钢铁战蝎
			[GetSpellInfo(144467)]=  2, --燃烧护甲
			[GetSpellInfo(144459)]=  5, --激光灼烧
			[GetSpellInfo(144498)]=  5, --切割激光
			[GetSpellInfo(144918)]=  5, --切割激光
			[GetSpellInfo(146325)]=  6, --切割激光瞄准（重点监控）

			--库卡隆黑暗萨满
			[GetSpellInfo(144089)]=  6, --T剧毒之雾
			[GetSpellInfo(144215)]=  2, --冰霜风暴打击(坦克)
			[GetSpellInfo(143990)]=  2, --污水喷涌(坦克)
			[GetSpellInfo(144304)]=  2, --撕裂
			[GetSpellInfo(144330)]=  6, --钢铁囚笼(仅英雄模式)

			--纳兹戈林将军
			[GetSpellInfo(143638)]=  6, --碎骨重锤
			[GetSpellInfo(143480)]=  5, --刺客印记
			[GetSpellInfo(143431)]=  6, --魔法打击(驱散)
			[GetSpellInfo(143494)]=  2, --碎甲重击(坦克)
			[GetSpellInfo(143882)]=  5, --猎人印记

			--马尔考罗克
			[GetSpellInfo(142863)]=  5, --虚弱的上古屏障
			[GetSpellInfo(142864)]=  5, --上古屏障
			[GetSpellInfo(142865)]=  5, --强大的上古屏障
			[GetSpellInfo(142990)]=  2, --致命打击(坦克)
			[GetSpellInfo(142913)]=  6, --散逸能量 (驱散)
			[GetSpellInfo(143919)]=  5, --受难 (仅英雄模式)

			--潘达利亚战利品
			[GetSpellInfo(144853)]=  3, --血肉撕咬
			[GetSpellInfo(145987)]=  5, --设置炸弹
			[GetSpellInfo(145218)]=  4, --硬化血肉
			[GetSpellInfo(145230)]=  1, --禁忌魔法
			[GetSpellInfo(146217)]=  4, --投掷酒桶
			[GetSpellInfo(146235)]=  4, --火焰之息
			[GetSpellInfo(145523)]=  4, --活化打击
			[GetSpellInfo(142983)]=  6, --折磨 (the new Wrack)
			[GetSpellInfo(145715)]=  3, --疾风炸弹
			[GetSpellInfo(145747)]=  5, --浓缩信息素
			[GetSpellInfo(146289)]=  4, --严重瘫痪
			--[GetSpellInfo(145685)]=  2, --不稳定的防御系统

			--嗜血的索克
			[GetSpellInfo(143766)]=  2, --恐慌(坦克)
			[GetSpellInfo(143773)]=  2, --冰冻吐息(坦克)
			[GetSpellInfo(143452)]=  1, --鲜血淋漓
			[GetSpellInfo(146589)]=  5, --万能钥匙(坦克)
			[GetSpellInfo(143445)]=  6, --锁定
			[GetSpellInfo(143791)]=  5, --腐蚀之血
			[GetSpellInfo(143777)]=  3, --冻结(坦克)
			[GetSpellInfo(143780)]=  4, --酸性吐息
			[GetSpellInfo(143800)]=  5, --冰冻之血
			[GetSpellInfo(143428)]=  4, --龙尾扫击

			--攻城匠师黑索
			[GetSpellInfo(144236)]=  4, --图像识别
			[GetSpellInfo(143385)]=  2, --电荷冲击(坦克)
			[GetSpellInfo(143856)]=  6, --过热
			--[GetSpellInfo(144466)]=  5, --电磁振荡

			--卡拉克西英杰
			[GetSpellInfo(143701)]=  5, --晕头转向 (stun)
			[GetSpellInfo(143702)]=  5, --晕头转向
			[GetSpellInfo(143572)]=  6, --紫色催化热罐燃料
			[GetSpellInfo(142808)]=  6, --炎界
			[GetSpellInfo(142931)]=  2, --血脉暴露
			[GetSpellInfo(143735)]=  6, --腐蚀琥珀
			[GetSpellInfo(146452)]=  5, --共鸣琥珀
			[GetSpellInfo(142929)]=  2, --脆弱打击
			[GetSpellInfo(142797)]=  5, --剧毒蒸汽
			[GetSpellInfo(143939)]=  5, --凿击
			[GetSpellInfo(143275)]=  2, --挥砍
			[GetSpellInfo(143768)]=  2, --音波发射
			[GetSpellInfo(143279)]=  2, --基因变异
			[GetSpellInfo(143339)]=  6, --注射
			[GetSpellInfo(142803)]=  6, --橙色催化爆炸之环
			[GetSpellInfo(142649)]=  4, --吞噬
			[GetSpellInfo(146556)]=  6, --穿刺
			[GetSpellInfo(142671)]=  6, --催眠术
			[GetSpellInfo(143979)]=  2, --恶意突袭
			[GetSpellInfo(142547)]=  6, --毒素：橙色
			[GetSpellInfo(142549)]=  6, --毒素：绿色
			[GetSpellInfo(142550)]=  6, --毒素：白色
			[GetSpellInfo(142948)]=  4, --瞄准
			[GetSpellInfo(148589)]=  4, --变异缺陷
			[GetSpellInfo(143570)]=  6, --热罐燃料准备（3S）
			[GetSpellInfo(142945)]=  5, --绿色催化诡异之雾
			[GetSpellInfo(143358)]=  4, --饥饿
			[GetSpellInfo(142315)]=  5, --酸性血液
			--[GetSpellInfo(143617)]=  5, --Blue Bomb
			--[GetSpellInfo(143609)]=  5, --Yellow Sword
			--[GetSpellInfo(143610)]=  5, --Red Drum
			--[GetSpellInfo(143619)]=  5, --Yellow Bomb
			--[GetSpellInfo(143607)]=  5, --Blue Sword
			--[GetSpellInfo(143614)]=  5, --Yellow Drum
			--[GetSpellInfo(143612)]=  5, --Blue Drum
			--[GetSpellInfo(143615)]=  5, --Red Bomb

			--加尔鲁什·地狱咆哮
			[GetSpellInfo(144582)]=  4, --断筋
			[GetSpellInfo(145183)]=  2, --绝望之握(坦克)
			[GetSpellInfo(144762)]=  4, --亵渎
			[GetSpellInfo(145071)]=  5, --亚煞极之触
			[GetSpellInfo(148718)]=  4, --火坑
			[GetSpellInfo(148983)]=  4, --勇气永春台
			[GetSpellInfo(147235)]=  6, --恶毒冲击
			[GetSpellInfo(148994)]=  4, --信念青龙寺
			[GetSpellInfo(149004)]=  4, --希望朱鹤寺
			[GetSpellInfo(147324)]=  5, --毁灭之惧
			[GetSpellInfo(145171)]=  5, --强化亚煞极之触（H）
			[GetSpellInfo(145175)]=  5, --强化亚煞极之触（N）
			[GetSpellInfo(145195)]=  6, --强化绝望之握
			[GetSpellInfo(147665)]=  5, --P4钢铁之星锁定
			[GetSpellInfo(144817)]=  4, --H强化亵渎
			[GetSpellInfo(145065)]=  5, --H亚煞极之触
			--[GetSpellInfo(144954)]=  4, --亚煞极之境
		},
	
	
	
		[930]=  { --雷霆王座
			--Jin'rokh the Breaker
			[GetSpellInfo(138006)]=  4, --Electrified Waters
			[GetSpellInfo(137399)]=  6, --Focused Lightning fixate
			[GetSpellInfo(138732)]=  5, --Ionization
			[GetSpellInfo(138349)]=  2, --Static Wound (tank only)
			[GetSpellInfo(137371)]=  2, --Thundering Throw (tank only)

			--Horridon
			[GetSpellInfo(136769)]=  6, --Charge
			[GetSpellInfo(136767)]=  2, --Triple Puncture (tanks only)
			[GetSpellInfo(136708)]=  6, --Stone Gaze
			[GetSpellInfo(136723)]=  5, --Sand Trap
			[GetSpellInfo(136587)]=  5, --Venom Bolt Volley (dispellable)
			[GetSpellInfo(136710)]=  5, --Deadly Plague (disease)
			[GetSpellInfo(136670)]=  4, --Mortal Strike
			[GetSpellInfo(136573)]=  5, --Frozen Bolt (Debuff used by frozen orb)
			[GetSpellInfo(136512)]=  6, --Hex of Confusion
			[GetSpellInfo(136719)]=  6, --Blazing Sunlight
			[GetSpellInfo(136654)]=  6, --Rending Charge
			[GetSpellInfo(140946)]=  4, --Dire Fixation (Heroic Only)

			--Council of Elders
			[GetSpellInfo(136922)]=  6, --Frostbite
			[GetSpellInfo(137084)]=  3, --Body Heat
			[GetSpellInfo(137641)]=  6, --Soul Fragment (Heroic only)
			[GetSpellInfo(136878)]=  5, --Ensnared
			[GetSpellInfo(136857)]=  6, --Entrapped (Dispell)
			[GetSpellInfo(137650)]=  5, --Shadowed Soul
			[GetSpellInfo(137359)]=  6, --Shadowed Loa Spirit fixate target
			[GetSpellInfo(137972)]=  6, --Twisted Fate (Heroic only)
			[GetSpellInfo(136860)]=  5, --Quicksand

			--Tortos
			[GetSpellInfo(134030)]=  6, --Kick Shell
			[GetSpellInfo(134920)]=  6, --Quake Stomp
			[GetSpellInfo(136751)]=  6, --Sonic Screech
			[GetSpellInfo(136753)]=  2, --Slashing Talons (tank only)
			[GetSpellInfo(137633)]=  5, --Crystal Shell (heroic only)

			--Megaera
			[GetSpellInfo(139822)]=  6, --Cinder (Dispell)
			[GetSpellInfo(134396)]=  6, --Consuming Flames (Dispell)
			[GetSpellInfo(137731)]=  5, --Ignite Flesh
			[GetSpellInfo(136892)]=  6, --Frozen Solid
			[GetSpellInfo(139909)]=  5, --Icy Ground
			[GetSpellInfo(137746)]=  6, --Consuming Magic
			[GetSpellInfo(139843)]=  4, --Artic Freeze
			[GetSpellInfo(139840)]=  4, --Rot Armor
			[GetSpellInfo(140179)]=  6, --Suppression (stun)

			--Ji-Kun
			[GetSpellInfo(138309)]=  4, --Slimed
			[GetSpellInfo(138319)]=  5, --Feed Pool
			[GetSpellInfo(140571)]=  3, --Feed Pool
			[GetSpellInfo(134372)]=  3, --Screech

			--Durumu the Forgotten
			[GetSpellInfo(133768)]=  2, --Arterial Cut (tank only)
			[GetSpellInfo(133767)]=  2, --Serious Wound (Tank only)
			[GetSpellInfo(136932)]=  6, --Force of Will
			[GetSpellInfo(134122)]=  5, --Blue Beam
			[GetSpellInfo(134123)]=  5, --Red Beam
			[GetSpellInfo(134124)]=  5, --Yellow Beam
			[GetSpellInfo(133795)]=  6, --Life Drain
			[GetSpellInfo(133597)]=  6, --Dark Parasite
			[GetSpellInfo(133732)]=  3, --Infrared Light (the stacking red debuff)
			[GetSpellInfo(133677)]=  3, --Blue Rays (the stacking blue debuff)
			[GetSpellInfo(133738)]=  3, --Bright Light (the stacking yellow debuff)
			[GetSpellInfo(133737)]=  4, --Bright Light (The one that says you are actually in a beam)
			[GetSpellInfo(133675)]=  4, --Blue Rays (The one that says you are actually in a beam)
			[GetSpellInfo(134626)]=  5, --Lingering Gaze

			--Primordius
			[GetSpellInfo(140546)]=  6, --Fully Mutated
			[GetSpellInfo(136180)]=  3, --Keen Eyesight (Helpful)
			[GetSpellInfo(136181)]=  4, --Impared Eyesight (Harmful)
			[GetSpellInfo(136182)]=  3, --Improved Synapses (Helpful)
			[GetSpellInfo(136183)]=  4, --Dulled Synapses (Harmful)
			[GetSpellInfo(136184)]=  3, --Thick Bones (Helpful)
			[GetSpellInfo(136185)]=  4, --Fragile Bones (Harmful)
			[GetSpellInfo(136186)]=  3, --Clear Mind (Helpful)
			[GetSpellInfo(136187)]=  4, --Clouded Mind (Harmful)
			[GetSpellInfo(136050)]=  2, --Malformed Blood(Tank Only)

			--Dark Animus
			[GetSpellInfo(138569)]=  2, --Explosive Slam (tank only)
			[GetSpellInfo(138659)]=  6, --Touch of the Animus
			[GetSpellInfo(138609)]=  6, --Matter Swap
			[GetSpellInfo(138691)]=  4, --Anima Font
			[GetSpellInfo(136962)]=  5, --Anima Ring
			[GetSpellInfo(138480)]=  6, --Crimson Wake Fixate

			--Iron Qon
			[GetSpellInfo(134647)]=  6, --Scorched
			[GetSpellInfo(136193)]=  5, --Arcing Lightning
			[GetSpellInfo(135147)]=  2, --Dead Zone
			[GetSpellInfo(134691)]=  2, --Impale (tank only)
			[GetSpellInfo(135145)]=  6, --Freeze
			[GetSpellInfo(136520)]=  5, --Frozen Blood
			[GetSpellInfo(137669)]=  3, --Storm Cloud
			[GetSpellInfo(137668)]=  5, --Burning Cinders
			[GetSpellInfo(137654)]=  5, --Rushing Winds 
			[GetSpellInfo(136577)]=  4, --Wind Storm
			[GetSpellInfo(136192)]=  4, --Lightning Storm
			[GetSpellInfo(136615)]=  6, --Electrified

			--Twin Consorts
			[GetSpellInfo(137440)]=  6, --Icy Shadows (tank only)
			[GetSpellInfo(137417)]=  6, --Flames of Passion
			[GetSpellInfo(138306)]=  5, --Serpent's Vitality
			[GetSpellInfo(137408)]=  2, --Fan of Flames (tank only)
			[GetSpellInfo(137360)]=  6, --Corrupted Healing (tanks and healers only?)
			[GetSpellInfo(137375)]=  3, --Beast of Nightmares
			[GetSpellInfo(136722)]=  6, --Slumber Spores

			--Lei Shen
			[GetSpellInfo(135695)]=  6, --Static Shock
			[GetSpellInfo(136295)]=  6, --Overcharged
			[GetSpellInfo(135000)]=  2, --Decapitate (Tank only)
			[GetSpellInfo(394514)]=  5, --Fusion Slash
			[GetSpellInfo(136543)]=  5, --Ball Lightning
			[GetSpellInfo(134821)]=  4, --Discharged Energy
			[GetSpellInfo(136326)]=  6, --Overcharge
			[GetSpellInfo(137176)]=  4, --Overloaded Circuits
			[GetSpellInfo(136853)]=  4, --Lightning Bolt
			[GetSpellInfo(135153)]=  6, --Crashing Thunder
			[GetSpellInfo(136914)]=  2, --Electrical Shock
			[GetSpellInfo(135001)]=  2, --Maim

			--Ra-Den (Heroic only)
			[GetSpellInfo(138308)]=  6, --Unstable Vita
			[GetSpellInfo(138372)]=  5, --Vita Sensitivity
		},
		
		[886]=  { --永春台
			--Trash
			[GetSpellInfo(125760)]=  10,

			--Protectors Of the Endless
			[GetSpellInfo(117519)]=  11, -- Touch of Sha, Dot that lasts untill Kaolan is defeated.
			[GetSpellInfo(111850)]=  12, -- Lightning Prison: Targeted
			[GetSpellInfo(117986)]=  15, -- Defiled Ground: Stacks
			[GetSpellInfo(118191)]=  14, -- Corrupted Essence
			[GetSpellInfo(117436)]=  13, -- Lightning Prison, Magic stun.

			--Tsulong
			[GetSpellInfo(122768)]=  21, -- Dread Shadows, Stacking raid damage debuff (ragnaros superheated style) 
			--[GetSpellInfo(122789)]=  24, -- Sunbeam, standing in the sunbeam, used to clear dread shadows.
			[GetSpellInfo(122858)]=  28, -- Bathed in Light, 500% increased healing done debuff.
			[GetSpellInfo(122752)]=  23, -- Shadow Breath, increased shadow breath damage debuff.
			[GetSpellInfo(123011)]=  26, -- Terrorize: 10%, Magical dot dealing % health.
			[GetSpellInfo(123036)]=  27, -- Fright, 2 second fear.
			[GetSpellInfo(122777)]=  22, -- Nightmares, 3 second fear.
			[GetSpellInfo(123012)]=  25, -- Terrorize: 5% 
			
			--Lei Shi
			[GetSpellInfo(123121)]=  31, -- Spray, Stacking frost damage taken debuff.
			[GetSpellInfo(123705)]=  32, -- Scary Fog
			
			--Sha of Fear
			[GetSpellInfo(129147)]=  42, -- Ominous Cackle, Debuff that sends players to the outer platforms.
			[GetSpellInfo(119086)]=  49, -- Penetrating Bolt, Increased Shadow damage debuff.
			[GetSpellInfo(119775)]=  50, -- Reaching Attack, Increased Shadow damage debuff.
			[GetSpellInfo(120669)]=  44, -- Naked and Afraid.
			[GetSpellInfo(119983)]=  43, -- Dread Spray, is also used.
			[GetSpellInfo(119414)]=  41, -- Breath of Fear, Fear+Massiv damage.
			[GetSpellInfo(75683)]=  45, -- Waterspout
			[GetSpellInfo(120629)]=  46, -- Huddle in Terror
			[GetSpellInfo(120394)]=  47, --Eternal Darkness
			[GetSpellInfo(129189)]=  48, --Sha Globe
		},
		
		[897]=  { --恐惧之心 
			--小怪
			[GetSpellInfo(125907)]=  11,	--哭号浩劫
			-- Imperial Vizier Zor'lok
			[GetSpellInfo(122760)]=  11, -- Exhale, The person targeted for Exhale. 
			[GetSpellInfo(123812)]=  12, -- Pheromones of Zeal, the gas in the middle of the room.
			[GetSpellInfo(122706)]=  14, -- Noise Cancelling, The "safe zone" from the roomwide aoe.
			[GetSpellInfo(122740)]=  13, -- Convert, The mindcontrol Debuff.

			-- Blade Lord Ta'yak
			[GetSpellInfo(123180)]=  21, -- Wind Step, Bleeding Debuff from stealth.
			[GetSpellInfo(123474)]=  23, -- Overwhelming Assault, stacking tank swap debuff. 
			[GetSpellInfo(122949)]=  22, -- Unseen Strike
			[GetSpellInfo(124783)]=  24, -- Storm Unleashed
			[GetSpellInfo(123600)]=  25, -- Storm Unleashed?
			[GetSpellInfo(123017)]=  25, -- 無形打擊
			-- Garalon
			[GetSpellInfo(122774)]=  31, -- Crush, stun from the crush ability.
			[GetSpellInfo(123120)]=  34, --- Pheromone Trail
			[GetSpellInfo(122835)]=  32, -- Pheromones, The buff indicating who is carrying the pheramone.
			[GetSpellInfo(123081)]=  33, -- Punchency, The stacking debuff causing the raid damage.
			[GetSpellInfo(122835)]=  30, --費洛蒙
			--Wind Lord Mel'jarak
			[GetSpellInfo(122055)]=  42, -- Residue, The debuff after breaking a prsion preventing further breaking.
			[GetSpellInfo(121881)]=  41, -- Amber Prison, not sure what the differance is but both were used.
			[GetSpellInfo(122064)]=  43, -- Corrosive Resin, the dot you clear by moving/jumping.
			--[GetSpellInfo()]=  45,
			-- Amber-Shaper Un'sok 
			[GetSpellInfo(122064)]=  53, -- Corrosive Resin
			[GetSpellInfo(122784)]=  52, -- Reshape Life, Both were used.
			[GetSpellInfo(122504)]=  54, --Burning Amber.
			[GetSpellInfo(121949)]=  51, -- Parasitic Growth, the dot that scales with healing taken.
			[GetSpellInfo(122370)]=  51,
			--Grand Empress Shek'zeer
			[GetSpellInfo(125390)]=  61, --Fixate.
			[GetSpellInfo(123707)]=  62, --Eyes of the Empress.
			[GetSpellInfo(123788)]=  63, --Cry of Terror.
			[GetSpellInfo(124097)]=  64, --Sticky Resin.
			[GetSpellInfo(125824)]=  65, --Trapped!.
			[GetSpellInfo(124777)]=  66, --Poison Bomb.
			[GetSpellInfo(124821)]=  67, --Poison-Drenched Armor.
			[GetSpellInfo(124827)]=  68, --Poison Fumes.
			[GetSpellInfo(124849)]=  69, --Consuming Terror.
			[GetSpellInfo(124863)]=  70, --Visions of Demise.
			[GetSpellInfo(124862)]=  71, --Visions of Demise: Target.
			[GetSpellInfo(123845)]=  72, --Heart of Fear: Chosen.
			[GetSpellInfo(123846)]=  73, --Heart of Fear: Lure.
		},		
		
		[896]=  { --魔古山宝库
         
			--Trash
			[GetSpellInfo(118562)]=  9, -- Petrified
			[GetSpellInfo(116596)]=  10, -- Smoke Bomb

			-- The Stone Guard
			[GetSpellInfo(130395)]=  11, -- Jasper Chains: Stacks
			[GetSpellInfo(130404)]=  12, -- Jasper Chains
			[GetSpellInfo(130774)]=  13, -- Amethyst Pool
			[GetSpellInfo(116038)]=  14, -- Jasper Petrification: stacks
			[GetSpellInfo(115861)]=  15, -- Cobalt Petrification: stacks
			[GetSpellInfo(116060)]=  16, -- Amethyst Petrification: stacks
			[GetSpellInfo(116281)]=  17, -- Cobalt Mine Blast, Magic root
			[GetSpellInfo(125206)]=  18, -- Rend Flesh: Tank only
			[GetSpellInfo(116008)]=  19, -- Jade Petrification: stacks

			--Feng the Accursed
			[GetSpellInfo(116040)]=  22, -- Epicenter, roomwide aoe.
			[GetSpellInfo(116784)]=  24, -- Wildfire Spark, Debuff that explodes leaving fire on the ground after 5 sec.
			[GetSpellInfo(116374)]=  29, -- Lightning Charge, Stun debuff.
			[GetSpellInfo(116417)]=  27, -- Arcane Resonance, aoe-people-around-you-debuff.
			[GetSpellInfo(116942)]=  23, -- Flaming Spear, fire damage dot.
			[GetSpellInfo(131788)]=  21, -- Lightning Lash: Tank Only: Stacks
			[GetSpellInfo(131790)]=  25, -- Arcane Shock: Stack : Tank Only
			[GetSpellInfo(102464)]=  26, -- Arcane Shock: AOE
			[GetSpellInfo(116364)]=  28, -- Arcane Velocity
			[GetSpellInfo(131792)]=  30, -- Shadowburn: Tank only: Stacks: HEROIC ONLY

			-- Gara'jal the Spiritbinder
			[GetSpellInfo(122151)]=  41,   -- Voodoo Doll, shared damage with the tank.
			[GetSpellInfo(117723)]=  42,   -- Frail Soul: HEROIC ONLY --虛弱靈魂
			[GetSpellInfo(116161)]=  43,   -- Crossed Over, people in the spirit world.

			-- The Spirit Kings
			[GetSpellInfo(117708)]=  51, -- Meddening Shout, The mind control debuff.
			[GetSpellInfo(118303)]=  52, -- Fixate, the once targeted by the shadows.
			[GetSpellInfo(118048)]=  53, -- Pillaged, the healing/Armor/damage debuff.
			[GetSpellInfo(118135)]=  54, -- Pinned Down, Najentus spine 2.0
			[GetSpellInfo(118047)]=  55, -- Pillage: Target
			[GetSpellInfo(118163)]=  56, -- Robbed Blind

			--Elegon
			[GetSpellInfo(117878)]=  61, -- Overcharged, the stacking increased damage taken debuff.   
			[GetSpellInfo(117945)]=  63, -- Arcing Energy
			[GetSpellInfo(117949)]=  62, -- Closed Circuit, Magic Healing debuff.

			--Will of the Emperor
			[GetSpellInfo(116969)]=  76, -- Stomp, Stun from the bosses.
			[GetSpellInfo(116835)]=  77, -- Devestating Arc, Armor debuff from the boss.
			[GetSpellInfo(116969)]=  75, -- Focused Energy.
			[GetSpellInfo(116778)]=  72, -- Focused Defense, Fixate from the Emperors Courage.
			[GetSpellInfo(117485)]=  73, -- Impending Thrust, Stacking slow from the Emperors Courage.
			[GetSpellInfo(116525)]=  71, -- Focused Assault, Fixate from the Emperors Rage
			[GetSpellInfo(116550)]=  74, -- Energizing Smash, Knockdown from the Emperors Strength
		},
      
			--[[怒之煞
			[GetSpellInfo(119626)]=  11, --Aggressive Behavior
			[GetSpellInfo(119488)]=  12, --Unleashed Wrath
			[GetSpellInfo(119610)]=  13, --Bitter Thoughts
			[GetSpellInfo(119601)]=  14, --Bitter Thoughts]]
		
		[800]=  { --火焰之地
			--Trash 
			--Flamewaker Forward Guard 
			[GetSpellInfo(76622)]=  4, -- Sunder Armor 
			[GetSpellInfo(99610)]=  5, -- Shockwave 
			--Flamewaker Pathfinder 
			[GetSpellInfo(99695)]=  4, -- Flaming Spear 
			[GetSpellInfo(99800)]=  4, -- Ensnare 
			--Flamewaker Cauterizer 
			[GetSpellInfo(99625)]=  4, -- Conflagration (Magic/dispellable) 
			--Fire Scorpion 
			[GetSpellInfo(99993)]=  4, -- Fiery Blood 
			--Molten Lord 
			[GetSpellInfo(100767)]=  4, -- Melt Armor 
			--Ancient Core Hound 
			[GetSpellInfo(99692)]=  4, -- Terrifying Roar (Magic/dispellable) 
			[GetSpellInfo(99693)]=  4, -- Dinner Time 
			--Magma 
			[GetSpellInfo(97151)]=  4, -- Magma 

			--Beth'tilac 
			[GetSpellInfo(99506)]=  5, -- The Widow's Kiss 
			--Cinderweb Drone 
			[GetSpellInfo(49026)]=  6, -- Fixate 
			--Cinderweb Spinner 
			[GetSpellInfo(97202)]=  5, -- Fiery Web Spin 
			--Cinderweb Spiderling 
			[GetSpellInfo(97079)]=  4, -- Seeping Venom 
			--Cinderweb Broodling 

			[GetSpellInfo(100048)]=  4, --Fiery Web 

			--Lord Rhyolith 
			[GetSpellInfo(98492)]=  5, --Eruption 

			--Alysrazor 
			--[GetSpellInfo(101729)]=  5, -- Blazing Claw 
			[GetSpellInfo(100094)]=  4, -- Fieroblast 
			[GetSpellInfo(99389)]=  5, -- Imprinted 
			[GetSpellInfo(99308)]=  4, -- Gushing Wound 
			[GetSpellInfo(100640)]=  6, -- Harsh Winds 
			[GetSpellInfo(100555)]=  6, -- Smouldering Roots 
			--Do we want to show these? 
			[GetSpellInfo(99461)]=  4, -- Blazing Power 
			--[GetSpellInfo(98734)]=  4, -- Molten Feather 
			--[GetSpellInfo(98619)]=  4, -- Wings of Flame 
			--[GetSpellInfo(100029)]=  4, -- Alysra's Razor 

			--Shannox 
			[GetSpellInfo(99936)]=  5, -- Jagged Tear 
			[GetSpellInfo(99837)]=  7, -- Crystal Prison Trap Effect 
			--[GetSpellInfo(101208)]=  4, -- Immolation Trap 
			[GetSpellInfo(99840)]=  4, -- Magma Rupture 
			-- Riplimp 
			[GetSpellInfo(99937)]=  5, -- Jagged Tear 
			-- Rageface 
			[GetSpellInfo(99947)]=  6, -- Face Rage 
			[GetSpellInfo(100415)]=  5, -- Rage  

			--守门人贝尔洛克 
			[GetSpellInfo(99252)]=  4, -- Blaze of Glory 
			[GetSpellInfo(99256)]=  15, -- 饱受磨难 
			--[GetSpellInfo(99403)]=  6, -- Tormented 
			[GetSpellInfo(99262)]=  4, -- 活力火花
			[GetSpellInfo(99263)]=  4, -- 生命之焰
			[GetSpellInfo(99516)]=  7, -- Countdown 
			[GetSpellInfo(99353)]=  7, -- Decimating Strike 
			--[GetSpellInfo(100908)]=  6, -- Fiery Torment 

			--Majordomo Staghelm 
			[GetSpellInfo(98535)]=  5, -- Leaping Flames 
			[GetSpellInfo(98443)]=  6, -- Fiery Cyclone 
			[GetSpellInfo(98450)]=  5, -- Searing Seeds 
			--Burning Orbs 
			--[GetSpellInfo(100210)]=  6, -- Burning Orb 
			[GetSpellInfo(96993)]=  5, -- Stay Withdrawn? 

			--Ragnaros 
			[GetSpellInfo(99399)]=  5, -- Burning Wound 
			--[GetSpellInfo(100293)]=  5, -- Lava Wave 
			[GetSpellInfo(100238)]=  4, -- Magma Trap Vulnerability 
			[GetSpellInfo(98313)]=  4, -- Magma Blast 
			--Lava Scion 
			[GetSpellInfo(100460)]=  7, -- Blazing Heat 
			--Dreadflame? 
			--Son of Flame 
			--Lava 
			[GetSpellInfo(98981)]=  5, -- Lava Bolt 
			--Molten Elemental 
			--Living Meteor 
			--[GetSpellInfo(100249)]=  5, -- Combustion 
			--Molten Wyrms 
			[GetSpellInfo(99613)]=  6, -- Molten Blast   

		},	
		
	   [824]=  {--巨龙之魂
		  
			[GetSpellInfo(103687)]=  11, --Crush Armor
			[GetSpellInfo(103821)]=  12, --Earthen Vortex
			[GetSpellInfo(103785)]=  13, --Black Blood of the Earth
			[GetSpellInfo(103534)]=  14, --Danger (Red)
			[GetSpellInfo(103536)]=  15, --Warning (Yellow)
			-- Don't need to show Safe people
			[GetSpellInfo(103541)]=  16, --Safe (Blue)

			--督军
			[GetSpellInfo(104378)]=  21, --Black Blood of Go'rath
			[GetSpellInfo(103434)]=  22, --干扰之影

			--Yor'sahj the Unsleeping
			[GetSpellInfo(104849)]=  31, --虚空箭
			[GetSpellInfo(105171)]=  32, --深度腐蚀

			--Hagara the Stormbinder
			[GetSpellInfo(105316)]=  41, --Ice Lance
			[GetSpellInfo(105465)]=  42, --Lightning Storm
			[GetSpellInfo(105369)]=  43, --Lightning Conduit
			[GetSpellInfo(105289)]=  44, --Shattered Ice (dispellable)
			[GetSpellInfo(105285)]=  45, --Target (next Ice Lance)
			[GetSpellInfo(104451)]=  46, --Ice Tomb
			[GetSpellInfo(110317)]=  49, --水壕
			[GetSpellInfo(109325)]=  48, --霜冻

			--Ultraxion
			[GetSpellInfo(105925)]=  55, --黯淡之光
			[GetSpellInfo(106108)]=  52, --Heroic Will
			[GetSpellInfo(105984)]=  53, --Timeloop
			[GetSpellInfo(105927)]=  54, --Faded Into Twilight

			--Warmaster Blackhorn			  
			[GetSpellInfo(107558)]=  62, --溃变 
			[GetSpellInfo(108046)]=  63, --震荡波
			[GetSpellInfo(110214)]=  64, --吞噬遮幕
			[GetSpellInfo(107567)]=  65, --残忍打击
			[GetSpellInfo(108043)]=  66, --破甲

			--Spine of Deathwing
			[GetSpellInfo(105563)]=  71, --Grasping Tendrils
			[GetSpellInfo(105479)]=  72, --灼热血浆
			[GetSpellInfo(105490)]=  73, --灼热之握
			[GetSpellInfo(106200)]=  74, --血之腐蚀:大地
			[GetSpellInfo(106199)]=  75, --血之腐蚀:死亡

			--Madness of Deathwing
			[GetSpellInfo(105445)]=  81, --炽热
			[GetSpellInfo(105841)]=  82, --突变撕咬
			[GetSpellInfo(106385)]=  83, --重碾
			[GetSpellInfo(106730)]=  84, --破伤风
			[GetSpellInfo(106444)]=  85, --刺穿
			[GetSpellInfo(106794)]=  86, --碎屑
			[GetSpellInfo(108649)]=  87, --腐蚀寄生虫
		},	

-------------------------------WOD(5H)------------------------------------
		[1008] = {-- 永茂林地
			[GetSpellInfo(164294)] = 4,  -- 失控蔓生
			[GetSpellInfo(168187)] = 4,  -- 撕裂冲锋
			[GetSpellInfo(169376)] = 5,  -- 剧毒蛰针
			[GetSpellInfo(169179)] = 4,  -- 巨灵猛击
		},

		[995] = {-- 黑石塔上层
			[GetSpellInfo(161288)] = 4,  -- 邪血药水
			[GetSpellInfo(155031)] = 4,  -- 噬体火焰
		},

		[993] = {-- 恐轨车站
			[GetSpellInfo(161089)] = 4,  -- 疯狂冲锋
			[GetSpellInfo(160681)] = 4,  -- 火力压制
			[GetSpellInfo(162058)] = 4,  -- 蚀骨之矛
			[GetSpellInfo(162066)] = 4,  -- 冰冻诱捕
		},

		[989] = {-- 通天峰
			[GetSpellInfo(154149)] = 4,  -- 充能
			[GetSpellInfo(153794)] = 4,  -- 穿刺护甲
			[GetSpellInfo(153795)] = 4,  -- 穿甲
			[GetSpellInfo(154043)] = 4,  -- 眩光
		},

		[987] = {-- 钢铁码头
			[GetSpellInfo(163390)] = 4,  -- 食人魔陷阱
			[GetSpellInfo(162418)] = 5,  -- 吞食狂热
		},

		[984] = {-- 奥金顿
			[GetSpellInfo(153006)] = 4,  -- 圣洁之光
			[GetSpellInfo(153477)] = 4,  -- 灵魂容器
			[GetSpellInfo(154018)] = 4,  -- 烈火
			[GetSpellInfo(153396)] = 5,  -- 火幕
			[GetSpellInfo(156921)] = 5,  -- 怨毒之种
			[GetSpellInfo(156842)] = 4,  -- 腐蚀术
			[GetSpellInfo(156964)] = 4,  -- 献祭
		},

		[969] = {-- 影月墓地
			[GetSpellInfo(162652)] = 4,  -- 纯净之月
			[GetSpellInfo(153692)] = 4,  -- 死疽沥青
		},

		[964] = {-- 血槌炉渣矿井
			[GetSpellInfo(149997)] = 4,  -- 火焰风暴
			[GetSpellInfo(149975)] = 5,  -- 跳动烈焰
			[GetSpellInfo(150032)] = 5,  -- 凋零烈焰
			[GetSpellInfo(149941)] = 4,  -- 蛮力猛击
			[GetSpellInfo(150023)] = 4,  -- 炉渣猛击
			[GetSpellInfo(150745)] = 4,  -- 重压跳跃
		},
--------------------------------MOP--------------------------------		
		[875]=  { --残阳关
			[GetSpellInfo(107268)]=  7,
			[GetSpellInfo(106933)]=  7,
			[GetSpellInfo(115458)]=  7,
			-- Raigonn 莱公
			[GetSpellInfo(111644)]=  7, -- Screeching Swarm 111640 111643
			[GetSpellInfo(111723)]=  7, --凝视
		},

		[885]=  { --魔古山神殿 
			-- Trial of the King 国王的试炼
			[GetSpellInfo(119946)]=  7, -- Ravage
			[GetSpellInfo(120167)]=  7, --焚烧
			[GetSpellInfo(120195)]=  7, --陨石术
			[GetSpellInfo(120160)]=  7, --陨石术
			-- Xin the Weaponmaster <King of the Clans> 武器大师席恩
			[GetSpellInfo(119684)]=  7, --Ground Slam
		},
      
		[871]=  { --血色大厅
			-- Houndmaster Braun <PH Dressing>
			[GetSpellInfo(114056)]=  7, -- Bloody Mess
			-- Flameweaver Koegler
			[GetSpellInfo(113653)]=  7, -- Greater Dragon's Breath
			[GetSpellInfo(11366)]=  6,-- Pyroblast      
		},
      
		[874]=  { --血色修道院 
			-- Thalnos the Soulrender
			[GetSpellInfo(115144)]=  7, -- Mind Rot
			[GetSpellInfo(115297)]=  6, -- Evict Soul
		},
      
		[763]=  { --通灵学院 
			-- Instructor Chillheart
			[GetSpellInfo(111631)]=  7, -- Wrack Soul
			-- Lilian Voss
			[GetSpellInfo(111585)]=  7, -- Dark Blaze
			[GetSpellInfo(115350)]=  7,--凝视
			-- Darkmaster Gandling
			[GetSpellInfo(108686)]=  7, -- Immolate
		},
            
		[877]=  { --影踪禅院 
			[GetSpellInfo(107140)]=  7, --磁能障壁
			-- Sha of Violence
			[GetSpellInfo(106872)]=  7, -- Disorienting Smash
			-- Taran Zhu <Lord of the Shado-Pan>
			[GetSpellInfo(112932)]=  7, -- Ring of Malice
		},
      
		[887]=  { --围攻砮皂寺
			-- Wing Leader Ner'onok 
			[GetSpellInfo(121447)]=  7, -- Quick-Dry Resin
		},
      
		[867]=  { --青龙寺
			-- Wise Mari <Waterspeaker>
			[GetSpellInfo(106653)]=  7, -- Sha Residue
			-- Lorewalker Stonestep <The Keeper of Scrolls>
			[GetSpellInfo(106653)]=  7, -- Agony
			-- Liu Flameheart <Priestess of the Jade Serpent>
			[GetSpellInfo(106823)]=  7, -- Serpent Strike
			-- Sha of Doubt
			[GetSpellInfo(106113)]=  7, --Touch of Nothingness
		},
      
		[781]=  {--祖阿曼
			[GetSpellInfo(43150)]=  8, -- 利爪之怒
			[GetSpellInfo(43648)]=  8, -- 电能风暴
			[GetSpellInfo(43501)]=  8, -- 灵魂虹吸
			[GetSpellInfo(43093)]=  10, -- 重伤投掷
			[GetSpellInfo(43095)]=  10, -- 麻痹蔓延
			[GetSpellInfo(42402)]=  10, -- 澎湃
		},
		[793]=  {--祖尔格拉布
			[GetSpellInfo(96477)]=  10, -- 剧毒连接
			[GetSpellInfo(96466)]=  8, -- 赫希斯之耳语
			[GetSpellInfo(96776)]=  12, -- 血祭
			[GetSpellInfo(96423)]=  10, -- 痛苦鞭笞
			[GetSpellInfo(96342)]=  10, -- 扑杀
		},
		
		[756]=  {--死亡矿井
			--[GetSpellInfo(91016)]=  7, -- 劈头斧
			[GetSpellInfo(88352)]=  8, -- 放置炸弹
			[GetSpellInfo(91830)]=  7, -- 注视
		},	
	},
	second = {
	
	},	
}

