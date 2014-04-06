local ADDON_NAME, ns = "oUF_Freebgrid", Freebgrid_NS

local indicator = ns.mediapath.."squares.ttf"
local symbols = ns.mediapath.."PIZZADUDEBULLETS.ttf"

local L ={}
if (GetLocale() == "zhCN") then
	L.none = "无"
	L.left = "左"
	L.right = "右"
	L.up = "上"
	L.down = "下"
	L.outlinevertical = "垂直"
	L.outlinehorizontal = "水平"
	L.hptextdeficit	= "显示缺失的生命值"
	L.hptextperc	= "显示生命值百分比"
	L.hptextactual	= "显示当前生命值"
	L.dispeltexticon	= "只显示图标"
	L.dispeltextborder	= "图标+边框显示"
	L.dispeltextindicator	= "图标+右侧指示器显示"
	L.defaultvaluestarget	= "目标"
	L.defaultvaluesmenu	= "菜单"
	L.defaultvaluesfollow	= "跟随"
	L.defaultvaluesmacro	= "宏"
	L.incombatlock = "前处于战斗状态,将在脱离战斗后生效."
	L.outcombatlock = "战斗结束,更新上次所做改动."
	L.applyclicksetting = "点击施法已经重新设置..."
	
	L.generalname = "样式设定"
	L.generalscale = "缩放"
	L.generalwidth = "宽度"
	L.generalheight = "高度"
	L.generalspacing = "间距"
	L.generalraid = "团队"
	L.generalraidhorizontalname = "小队单位水平排列"
	L.generalraidhorizontaldesc = "设置小队为横向或者竖向显示."
	L.generalraidgrowthname = "小队增长方向"
	L.generalraidgrowthdesc = "设置团队中小队的排列增长方向."
	
	L.generalraidgroupname = "队伍数量."
	L.generalraidgroupdesc = "设置团队中最大显示小队数量."
	
	L.generalraidmultiname = "按小队排列"
	L.generalraidmultidesc = "按暴雪的团队排列方式排列小队."
	
	L.generalraidunitsname = "每队伍单位数"
	
	L.generalraidsortClassname = "按职业排列"
	L.generalraidsortName = "按名字排列"
	L.generalraidclassOrdername = "职业顺序"
	
	L.generalraidresetClassOrdername = "重置职业顺序"
	
	L.generalpetsname = "宠物"
	L.generalpetgrowth = "增长方向"
	L.generalpethorizontal = "小队单位水平排列"
	L.generalppetunits = "每队伍单位数"
	
	L.statusbarname = "状态条"
	
	L.statusbarorientation = "生命条显示方向"
	L.statusbarpowerbar = "法力条"
	L.statusbarpowerbarname = "启用法力条"
	L.statusbaronlymana = "只显示有蓝职业"
	L.statusbarlowmana = "高亮显示低法力单位边框"
	L.statusbarpercent = "法力值阈值"
	L.statusbarpercentdesc = "当有蓝职业法力值低于设定阈值百分比时高亮边框显示."
	L.statusbarpsize = "法力条尺寸"
	L.statusbarporientation = "法力条方向"
	L.statusbaraltpower = "第二能量值"
	L.statusbaraltpowertext = "第二能量值文字"
	L.statusbaraltpowerdesc = "显示第二能量值,比如音波龙的音波值,古加尔腐化值等."
	
	L.fontoptsname = "字体"
	L.fontoptsoutline = "字体轮廓"
	L.fontoptsfontsize = "姓名字体尺寸"
	L.fontoptsfontsizedesc = "调整单位姓名的字体大小"
	L.fontoptsfontsizeEdge = "指示器字体尺寸"
	L.fontoptsfontsizeEdgedesc = "调整上下指示器显示的字体大小"
	
	L.rangeoptsname = "距离"
	L.fontoptsoor = "超出距离淡出"
	L.fontoptsarrow = "启用箭头方向指示"
	L.fontoptsarrowdesc = "使用一个箭头图标以指示同一地区内超出距离的单位的方向."
	L.fontoptsscaledesc = "调整箭头缩放尺寸."
	L.fontoptsIsNotConnected = "离线单位淡出显示."
	L.fontoptsmouseover = "只在鼠标悬停时显示."
	
	L.healoptsname = "治疗预估"
	L.healopthealtext = "治疗文字"
	L.healopthealtextname = "接受治疗文字"
	L.healopthealbar = "生命条"
	L.healopthealbarname = "接受生命条"
	L.healopthealbarmyheal = "我的治疗颜色"
	L.healopthealbarotherheal = "其他单位治疗颜色"
	L.healopthealbaroverflow = "过量治疗"
	L.healopthealbarothers = "只显示其他单位治疗"
	L.healoptshptext = "生命文字"
	L.healoptshptextname = "生命之文字显示方式"
	L.healoptspercent = "生命值显示阈值"
	L.healoptspercentdesc = "当生命值低于设定阈值百分比时才显示."
	
	L.miscoptsname = "一般设置"
	L.miscoptshideraid = "关闭wow自带团队框架"
	L.miscoptshideraiddesc = "关闭/显示wow自带团队框架,不可在战斗中使用,重启生效."
	L.miscoptsparty = "小队时显示"
	L.miscoptssolo = "solo时显示"
	L.miscoptsplayer = "队伍中显示自己"
	L.miscoptspets = "显示队伍/团队宠物"
	L.miscoptsMT = "主坦克"
	L.miscoptsGCD = "显示GCD条"
	L.miscoptsGCDdesc = "在鼠标所在的单位上以透明的条显示GCD状态."
	L.miscoptsGCDchange = "非治疗职业不显示GCD条"
	L.miscoptsrole = "角色类型图标"
	L.miscoptsfborder = "高亮焦点边框"
	L.miscoptsAFK = "AFK 标记/计时"
	L.miscoptshighlight = "鼠标悬停高亮"
	L.miscoptstooltip = "战斗中隐藏提示信息"
	L.miscoptstooltipdesc = "在战斗中隐藏鼠标提示信息."
	L.miscoptssmooth = "平滑显示"
	L.miscoptshidemenu = "战斗中隐藏右键菜单"
	L.miscoptshidemenudesc = "在战斗中不显示右键菜单."
	L.miscoptsres = "复活通知"
	L.miscoptsresdesc = "复活队友时聊天栏发出通知.只适合治疗职业"
	L.miscoptstankaura = "坦克技能监视"
	L.miscoptstankauradesc = "图标方式显示坦克的减伤技能.该技能的显示优先级最低."
	L.miscoptsdispel = "可驱散buff显示方式"
	L.miscoptsindicator = "指示器尺寸"
	L.miscoptssymbol = "右下指示器尺寸"
	L.miscoptsicon = "队长,角色类型等图标尺寸"
	L.miscoptsaura = "光环尺寸"
	
	L.coloropts = "颜色"
	L.coloroptshp = "生命条"
	L.coloroptshpreverse = "按职业颜色显示"
	L.coloroptshpdefine = "自定义生命条颜色"
	L.coloroptshpcolor = "生命条颜色"
	L.coloroptsclassbgcolor = "背景以职业颜色显示"
	L.coloroptshpbgcolor = "生命条背景色"
	L.coloroptscolorSmooth = "平滑梯度显示"
	L.coloroptsgradient = "低生命值颜色"
	L.coloroptspp = "法力条"
	L.coloroptsppdefine = "自定义法力条颜色"
	L.coloroptspowercolor = "法力条颜色"
	L.coloroptspowerbgcolor = "法力条背景色"
	L.coloroptsother = "其他"
	L.coloroptsvehiclecolor = "载具颜色"
	L.coloroptsvehiclecolordesc = "单位在载具时颜色."
	L.coloroptsenemycolor = "敌对颜色"
	L.coloroptsenemycolordesc = "单位处于敌对状态时颜色,如被心控等."
	L.coloroptsdeadcolor = "死亡颜色"
	L.coloroptsdeadcolordesc = "单位处于死亡或幽灵状态时颜色."
	
	L.ClickCast = "点击施法"
	L.ClickCastenable = "启用"
	L.ClickCastenabledesc = "启用点击施法,可以在下面设置相关技能和按键绑定."
	L.ClickCastSetDefault = "恢复默认"
	L.ClickCastSetDefaultdesc = "恢复点击施法设置为默认."
	L.ClickCastapply = "应用更改"
	L.ClickCastapplydesc = "应用当前按键设定."
	L.ClickCastleft = "鼠标左键"
	L.ClickCastright = "鼠标右键"
	L.ClickCastmiddle  = "鼠标中键"
	L.ClickCastfour = "鼠标4键"
	L.ClickCastfive = "鼠标5键"
	L.ClickCastmacro = "  宏编辑窗口."
	L.ClickCastmacrodesc = "注意:这只是一个简单的宏编辑窗口,不会检测你的宏的正确性,也不会改变当前目标,所以请使用@mouseover条件方式让你的法术对点击的目标使用.如:'/cast [@mouseover,help,nodead,exists]强效治疗波'."
	
	L.optionsunlock = "解锁锚点"
	L.optionsreload = "重载UI"
	L.optionsreloaddesc = "多数的选项更改需要重载UI后才能生效."
	L.optionsdefault = "恢复默认设置"
	L.optionsdefaultdesc = "还原所有设置为默认选项,可能需要重载UI以使设定生效."
elseif (GetLocale() == "zhTW") then
	L.none = "無"
	L.left = "左"
	L.right = "右"
	L.up = "上"
	L.down = "下"
	L.outlinevertical = "垂直"
	L.outlinehorizontal = "水平"
	L.hptextdeficit	= "顯示缺失的生命值"
	L.hptextperc	= "顯示生命值百分比"
	L.hptextactual	= "顯示當前生命值"
	L.dispeltexticon	= "只顯示圖標"
	L.dispeltextborder	= "圖標+邊框顯示"
	L.dispeltextindicator	= "圖標+右側指示器顯示"
	L.defaultvaluestarget	= "目標"
	L.defaultvaluesmenu	= "菜單"
	L.defaultvaluesfollow	= "跟隨"
	L.defaultvaluesmacro	= "宏"
	L.incombatlock = "當前處於戰鬥狀態,將在脫離戰鬥後生效."
	L.outcombatlock = "戰鬥結束,更新上次所做改動."
	L.applyclicksetting = "點擊施法已經重新設置..."
	
	L.generalname = "樣式設定"
	L.generalscale = "縮放"
	L.generalwidth = "寬度"
	L.generalheight = "高度"
	L.generalspacing = "間距"
	L.generalraid = "團隊"
	L.generalraidhorizontalname = "小隊單位水平排列"
	L.generalraidhorizontaldesc = "設置小隊為橫向或者豎向顯示."
	L.generalraidgrowthname = "小隊增長方向"
	L.generalraidgrowthdesc = "設置團隊中小隊的排列增長方向."
	
	L.generalraidgroupname = "隊伍數量."
	L.generalraidgroupdesc = "設置團隊中最大顯示小隊數量."
	
	L.generalraidmultiname = "按小隊排列"
	L.generalraidmultidesc = "按暴雪的團隊排列方式排列小隊."
	
	L.generalraidunitsname = "每隊伍單位數"
	
	L.generalraidsortClassname = "按職業排列"
	L.generalraidsortName ="按名字排列"
	L.generalraidclassOrdername = "職業順序"
	
	L.generalraidresetClassOrdername = "重置職業順序"
	
	L.generalpetsname = "寵物"
	L.generalpetgrowth = "增長方向"
	L.generalpethorizontal = "小隊單位水平排列"
	L.generalppetunits = "每隊伍單位數"
	
	L.statusbarname = "狀態條"
	
	L.statusbarorientation = "生命條顯示方向"
	L.statusbarpowerbar = "法力條"
	L.statusbarpowerbarname = "啟用法力條"
	L.statusbaronlymana = "只顯示有藍職業"
	L.statusbarlowmana = "高亮顯示低法力單位邊框"
	L.statusbarpercent = "法力值閾值"
	L.statusbarpercentdesc = "當有藍職業法力值低於設定閾值百分比時高亮邊框顯示."
	L.statusbarpsize = "法力條尺寸"
	L.statusbarporientation = "法力條方向"
	L.statusbaraltpower = "第二能量值"
	L.statusbaraltpowertext = "第二能量值文字"
	L.statusbaraltpowerdesc = "顯示第二能量值,比如音波龍的音波值,邱加利的腐化值等."
	
	L.fontoptsname = "字體"
	L.fontoptsoutline = "字體輪廓"
	L.fontoptsfontsize = "姓名字體尺寸"
	L.fontoptsfontsizedesc = "調整單位姓名的字體大小"
	L.fontoptsfontsizeEdge = "指示器字體尺寸"
	L.fontoptsfontsizeEdgedesc = "調整上下指示器顯示的字體大小"
	
	L.rangeoptsname = "距離"
	L.fontoptsoor = "超出距離淡出"
	L.fontoptsarrow = "啟用箭頭方向指示"
	L.fontoptsarrowdesc = "使用一個箭頭圖標以指示同一地區內超出距離的單位的方向."
	L.fontoptsscaledesc = "調整箭頭縮放尺寸."
	L.fontoptsIsNotConnected = "離綫單位淡出顯示."
	L.fontoptsmouseover = "只在鼠標懸停時顯示."
	
	L.healoptsname = "治療預估"
	L.healopthealtext = "治療文字"
	L.healopthealtextname = "接受治療文字"
	L.healopthealbar = "生命條"
	L.healopthealbarname = "接受生命條"
	L.healopthealbarmyheal = "我的治療顏色"
	L.healopthealbarotherheal = "其他單位治療顏色"
	L.healopthealbaroverflow = "過量治療"
	L.healopthealbarothers = "只顯示其他單位治療"
	L.healoptshptext = "生命文字"
	L.healoptshptextname = "生命文字顯示方式"
	L.healoptspercent = "生命值顯示閾值"
	L.healoptspercentdesc = "當生命值低於設定閾值百分比時才顯示."
	
	L.miscoptsname = "一般設置"
	L.miscoptshideraid = "關閉魔獸自帶團隊框架"
	L.miscoptshideraiddesc = "關閉/顯示魔獸自帶團隊插件,不可在戰鬥中使用,重啟生效."
	L.miscoptsparty = "小隊時顯示"
	L.miscoptssolo = "單人時顯示"
	L.miscoptsplayer = "隊伍中顯示自己"
	L.miscoptspets = "顯示隊伍/團隊寵物"
	L.miscoptsMT = "主坦克"
	L.miscoptsGCD = "顯示GCD條"
	L.miscoptsGCDdesc = "在鼠標所在的單位上以透明的條顯示GCD狀態."
	L.miscoptsGCDchange = "非治療職業不顯示GCD條"
	L.miscoptsrole = "角色類型圖標"
	L.miscoptsfborder = "高亮焦點邊框"
	L.miscoptsAFK = "AFK 標記/計時"
	L.miscoptshighlight = "鼠標懸停高亮"
	L.miscoptstooltip = "戰鬥中隱藏提示信息"
	L.miscoptstooltipdesc = "在戰鬥中隱藏鼠標提示信息."
	L.miscoptssmooth = "平滑顯示"
	L.miscoptshidemenu = "戰鬥中隱藏右鍵菜單"
	L.miscoptshidemenudesc = "在戰鬥中不顯示右鍵菜單."
	L.miscoptsres = "復活通知"
	L.miscoptsresdesc = "復活隊友時于聊天欄發送通知.只適合治療職業"
	L.miscoptstankaura = "坦克技能監視"
	L.miscoptstankauradesc = "以圖標方式顯示坦克的減傷技能.該技能的顯示優先級最低."
	L.miscoptsdispel = "可驅散buff顯示方式"
	L.miscoptsindicator = "指示器尺寸"
	L.miscoptssymbol = "右下角指示器尺寸"
	L.miscoptsicon = "隊長,角色類型等圖標尺寸"
	L.miscoptsaura = "光環尺寸"
	
	L.coloropts = "顏色"
	L.coloroptshp = "生命條"
	L.coloroptshpreverse = "按職業顏色顯示"
	L.coloroptshpdefine = "自定義生命條顏色"
	L.coloroptshpcolor = "生命條顏色"
	L.coloroptsclassbgcolor = "背景以職業顏色顯示"
	L.coloroptshpbgcolor = "生命條背景色"
	L.coloroptscolorSmooth = "平滑梯度顯示"
	L.coloroptsgradient = "低生命值顏色"
	L.coloroptspp = "法力條"
	L.coloroptsppdefine = "自定義法力條顏色"
	L.coloroptspowercolor = "法力條顏色"
	L.coloroptspowerbgcolor = "法力條背景色"
	L.coloroptsother = "其他"
	L.coloroptsvehiclecolor = "載具顏色"
	L.coloroptsvehiclecolordesc = "單位在載具時的顏色."
	L.coloroptsenemycolor = "敵對顏色"
	L.coloroptsenemycolordesc = "單位處於敵對狀態時的顏色,如被心控等."
	L.coloroptsdeadcolor = "死亡顏色"
	L.coloroptsdeadcolordesc = "單位處於死亡或幽靈狀態時的顏色."
	
	L.ClickCast = "點擊施法"
	L.ClickCastenable = "啟用"
	L.ClickCastenabledesc = "啟用點擊施法,可以在下面設置相關技能和按鍵綁定."
	L.ClickCastSetDefault = "恢復默認"
	L.ClickCastSetDefaultdesc = "點擊施法設置為默認狀態."
	L.ClickCastapply = "應用更改"
	L.ClickCastapplydesc = "應用當前按鍵設定."
	L.ClickCastleft = "鼠標左鍵"
	L.ClickCastright = "鼠標右鍵"
	L.ClickCastmiddle  = "鼠標中鍵"
	L.ClickCastfour = "鼠標4鍵"
	L.ClickCastfive = "鼠標5鍵"
	L.ClickCastmacro = "  宏編輯窗口."
	L.ClickCastmacrodesc = "注意:這只是一個簡單的宏編輯窗口,不會檢測你的宏的正確性,也不會改變當前目標,所以請使用@mouseover條件方式讓你的法術對點擊的目標使用.如:'/cast [@mouseover,help,nodead,exists]強效治療波'."
	
	L.optionsunlock = "解鎖錨點"
	L.optionsreload = "重載UI"
	L.optionsreloaddesc = "多數的選項更改需要重載UI後才能生效."
	L.optionsdefault = "恢復默認設置"
	L.optionsdefaultdesc = "還原所有設置為默認選項,可能需要重載UI從而使設定生效."

end                  --中文化结束
ns.outline = {
    ["None"] = "None",
    ["OUTLINE"] = "OUTLINE",
    ["THINOUTLINE"] = "THINOUTLINE",
    ["MONOCHROME"] = "MONOCHROME",
    ["OUTLINEMONO"] = "OUTLINEMONOCHROME",
}

ns.orientation = {
    ["VERTICAL"] = "VERTICAL",
    ["HORIZONTAL"] = "HORIZONTAL",
}
------  技能监测开始
local macroedit = {
	hidden = true,
	path = nil,
	keyname = "",
}

local defaultvalues = {
	["NONE"] = "无",
	["target"] = L.defaultvaluestarget,
	["menu"] = L.defaultvaluesmenu,
	["follow"] = L.defaultvaluesfollow,
	["macro"] = L.defaultvaluesmacro,
}

local default_spells = {
	PRIEST = { 
			139,			--"恢復",
			527,			--"驅散魔法",
			2061,			--"快速治療",
			2006,			--"復活術",
			17,				--"真言術:盾",
			33076,			--"癒合禱言",
			528,			--"驅除疾病", 
			2060,			--"強效治療術",
			32546,			--"束縛治療",
			34861,			--"治療之環",
			2050,			--治疗术
			1706,			--漂浮术
			21562,			--耐
			596,			--治疗祷言
			47758,			-- 苦修
			73325,			-- 信仰飞跃	
			48153,			-- 守护之魂
			88625,			-- 圣言术
			33206,			--痛苦压制
			10060,			--能量灌注
	},
	DRUID = { 
			774,			--"回春術",
			2782,			--"净化腐蚀",
			8936,			--"癒合",
			50769,			--"復活",
			48438,			--"野性成长",
			18562,			--"迅捷治愈",
			50464,			--"滋補術",
			1126,			-- 野性印记
			33763,			--"生命之花",
			5185,			--治疗之触
			20484,			--复生,
			29166,			--激活
			33763,			--生命之花
	},
	SHAMAN = { 
			974,			--"大地之盾",
			2008,			--"先祖之魂",
			8004,			--"治疗之涌",
			1064,			--"治疗链",
			331,			--"治疗波",
			51886,			--"净化灵魂",
			546,			--水上行走
			131,			--水下呼吸
			61295,			--"激流",
			77472,			--"强效治疗波",	
			73680,			--"元素释放",
	},

	PALADIN = { 
			635,			--"聖光術",
			19750,			--"聖光閃現",
			53563,			--"圣光信标",
			7328,			--"救贖",
		    20473,			--"神聖震擊",
			82326,			--"神圣之光",
			4987,			--"淨化術",
			85673,			--"荣耀圣令",
			633,			--"聖療術",
		    31789,			--正義防護
			1044,			--自由之手
			31789,			-- 正义防御
			1022,			--"保护之手",
			6940,  		--牺牲之手
			1038,			--"拯救之手",
	},

	WARRIOR = { 
			50720,			--"戒備守護",
			3411,			--"阻擾",
	},

	MAGE = { 
			1459,			--"秘法智力",
			54646,			--"专注",
			475,			--"解除詛咒",
			130,			--"缓落",
	},

	WARLOCK = { 
			80398,			--"黑暗意图",
			5697,			--"魔息",
	},

	HUNTER = { 
			34477,			--"誤導",
			136,			--治疗宠物
			53271,      --"主人的召唤"
	},
	
	ROGUE = { 
			57933,			--"偷天換日",
	},
	
	DEATHKNIGHT = {
			61999,			--复活盟友
			47541,			--死缠
			49016,			-- 邪恶狂乱（邪恶天赋)
	},
	
}

local  SetClickKeyvalue  = function(val,path1,path2,name)
	if val == "macro" then
		ns.db.ClickCastset[path1][path2]["action"] = "macro"
		macroedit.hidden = false
		macroedit.keyname = name
		macroedit.path = ns.db.ClickCastset[path1][path2]
	else
		ns.db.ClickCastset[path1][path2]["action"]  = val
		macroedit.hidden = true
		macroedit.path =nil
		macroedit.keyname = ""
	end
end	
----------------------------------添加结束


local function updateFonts(object)
    object.Name:SetFont(ns.db.fontPath, ns.db.fontsize, ns.db.outline)
    object.Name:SetWidth(ns.db.width)
    object.AFKtext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
    object.AFKtext:SetWidth(ns.db.width)
    object.AuraStatusCen:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline) 
    object.AuraStatusCen:SetWidth(ns.db.width)
    object.Healtext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline) 
    object.Healtext:SetWidth(ns.db.width)
    if object.freebCluster then
        object.freebCluster:SetTextColor(ns.db.cluster.textcolor.r, ns.db.cluster.textcolor.g, ns.db.cluster.textcolor.b)
        object.freebCluster:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
        object.freebCluster:SetWidth(ns.db.width)
    end
end

local function updateIndicators(object)
    object.AuraStatusTL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
    object.AuraStatusTR:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
    object.AuraStatusBL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
    object.AuraStatusBR:SetFont(symbols, ns.db.symbolsize, "THINOUTLINE")
end

local function updateIcons(object)
    object.Leader:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.Assistant:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.MasterLooter:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.RaidIcon:SetSize(ns.db.leadersize+2, ns.db.leadersize+2)
    object.ReadyCheck:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.freebAuras.button:SetSize(ns.db.aurasize, ns.db.aurasize)
    object.freebAuras.size = ns.db.aurasize
end

local function updateHealbar(object)
    if not object.myHealPredictionBar then return end

    object.myHealPredictionBar:ClearAllPoints()
    object.otherHealPredictionBar:ClearAllPoints()

    if ns.db.orientation == "VERTICAL" then
        if ns.db.hpreversed then
            object.myHealPredictionBar:SetPoint("TOPLEFT", object.Health:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
            object.myHealPredictionBar:SetPoint("TOPRIGHT", object.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
            object.myHealPredictionBar:SetReverseFill(true)

            object.otherHealPredictionBar:SetPoint("TOPLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
            object.otherHealPredictionBar:SetPoint("TOPRIGHT", object.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
            object.otherHealPredictionBar:SetReverseFill(true)
        else
            object.myHealPredictionBar:SetPoint("BOTTOMLEFT", object.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
            object.myHealPredictionBar:SetPoint("BOTTOMRIGHT", object.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
            object.myHealPredictionBar:SetReverseFill(false)

            object.otherHealPredictionBar:SetPoint("BOTTOMLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
            object.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
            object.otherHealPredictionBar:SetReverseFill(false)
        end
        object.myHealPredictionBar:SetSize(0, ns.db.height)
        object.myHealPredictionBar:SetOrientation"VERTICAL"

        object.otherHealPredictionBar:SetSize(0, ns.db.height)
        object.otherHealPredictionBar:SetOrientation"VERTICAL"
    else
        if ns.db.hpreversed then
            object.myHealPredictionBar:SetPoint("TOPRIGHT", object.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
            object.myHealPredictionBar:SetPoint("BOTTOMRIGHT", object.Health:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
            object.myHealPredictionBar:SetReverseFill(true)

            object.otherHealPredictionBar:SetPoint("TOPRIGHT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
            object.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", object.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
            object.otherHealPredictionBar:SetReverseFill(true)
        else
            object.myHealPredictionBar:SetPoint("TOPLEFT", object.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
            object.myHealPredictionBar:SetPoint("BOTTOMLEFT", object.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
            object.myHealPredictionBar:SetReverseFill(false)

            object.otherHealPredictionBar:SetPoint("TOPLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
            object.otherHealPredictionBar:SetPoint("BOTTOMLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
            object.otherHealPredictionBar:SetReverseFill(false)
        end
        object.myHealPredictionBar:SetSize(ns.db.width, 0)
        object.myHealPredictionBar:SetOrientation"HORIZONTAL"

        object.otherHealPredictionBar:SetSize(ns.db.width, 0)
        object.otherHealPredictionBar:SetOrientation"HORIZONTAL"
    end

    object.myHealPredictionBar:GetStatusBarTexture():SetTexture(ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b, ns.db.myhealcolor.a)
    object.otherHealPredictionBar:GetStatusBarTexture():SetTexture(ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b, ns.db.otherhealcolor.a)
end

local updateCluster = function(object)
    if ns.db.cluster.enabled then
        object:EnableElement('freebCluster')
    else
        object:DisableElement('freebCluster') 
    end
end
--------------修改和添加开始
local lockprint, updateObject, ApplyClickSet, updateFrameSet

local function CheckCombat()
	if(InCombatLockdown()) then
			ns:RegisterEvent("PLAYER_REGEN_ENABLED")
			if not lockprint then
				lockprint = true
				print(L.incombatlock)
				return true
			end
	else
		return false
	end
end

function ns.updateObjects()
      
      updateObject = CheckCombat()
	 if updateObject then
       print("Your in combat silly. Delaying updates until combat ends.")
	 return
     end
-------添加结束

    for _, object in next, ns._Objects do
        object:SetSize(ns.db.width, ns.db.height)
        --object:SetScale(ns.db.scale)

        object.freebarrow:SetScale(ns.db.arrowscale)

        ns:UpdateHealth(object.Health)
        ns:UpdatePower(object.Power)
        if UnitExists(object.unit) then
            object.Health:ForceUpdate()
            object.Power:ForceUpdate()
        end
        updateFonts(object)
        updateIndicators(object)
        updateIcons(object)
        updateHealbar(object)
        updateCluster(object)

        ns:UpdateName(object.Name, object.unit)

        if ns.db.smooth then
            object:EnableElement('freebSmooth')
        else
            object:DisableElement('freebSmooth')
        end

        if ns.db.autorez then
            object:EnableElement('freebAutoRez')
        else
            object:DisableElement('freebAutoRez')
        end
    end

    ns:scaleRaid()

    _G["oUF_FreebgridRaidFrame"]:SetSize(ns.db.width, ns.db.height)
    _G["oUF_FreebgridPetFrame"]:SetSize(ns.db.width, ns.db.height)
    _G["oUF_FreebgridMTFrame"]:SetSize(ns.db.width, ns.db.height)
end
------------添加开始
function ns.updateFrameSetting()
	updateFrameSet = CheckCombat ()
	if updateFrameSet then return end
	
	if ns.db.multi then
		local headers = ns._Headers
		local i = 1
		for k, v in pairs( headers ) do
			local raidframe = string.match(k,"Raid_Freebgrid")
			if raidframe then	
				headers[k] :SetAttribute( 'showPlayer', ns.db.player)
				--headers[k] :SetAttribute( 'showSolo', ns.db.showsolo)
				headers[k] :SetAttribute( 'showParty', ns.db.party)	
				headers[k] :SetAttribute( 'initial-width', ns.db.width)
				headers[k] :SetAttribute( 'initial-height', ns.db.height)
				headers[k] :SetAttribute( 'unitsPerColumn', ns.db.numUnits)	
				--headers[k] :SetAttribute( 'xOffset', )
				--headers[k] :SetAttribute( 'yOffset', )
				headers[k] :SetAttribute( 'columnSpacing', ns.db.spacing)
				headers[k] :SetAttribute('oUF-initialConfigFunction', ([[self:SetWidth(%d); self:SetHeight(%d)]]):format(ns.db.width, ns.db.height))
				ns._Headers[raidframe..i]:SetAttribute("groupFilter", i <= ns.db.numCol and i or "")				

				i = i + 1
			end
		end
	end	
	ns.updateObjects()
end

function ns.ApplyClickSetting()
    ApplyClickSet = CheckCombat()
	if ApplyClickSet then return end
	for _, object in next, ns._Objects do
		ns:RegisterClicks(object)
	end
	print(L.applyclicksetting)
end-----------------------添加结束
function ns:PLAYER_REGEN_ENABLED()                                                   ----------部分覆盖修改
    print(L.outcombatlock)
    lockprint = nil
	if updateObject then ns.updateObjects(); updateObject = nil end
	if ApplyClickSet then ns.ApplyClickSetting(); ApplyClickSet = nil end
	if updateFrameSet then ns.updateFrameSetting(); updateFrameSet = nil end

    ns:UnregisterEvent("PLAYER_REGEN_ENABLED")
end                                                                                 ----------部分覆盖修改 结束

local SM = LibStub("LibSharedMedia-3.0", true)
local fonts = SM:List("font")
local statusbars = SM:List("statusbar")

local generalopts = {
    type = "group", name = "General", order = 1,
    args = {
        scale = {
            name = L.generalscale,
            type = "range",
            order = 1,
            min = 0.5,
            max = 2.0,
            step = .05,
            get = function(info) return ns.db.scale end,
            set = function(info,val) ns.db.scale = val; ns.updateObjects() end,
        },
        scalegroup = {
            type = "group", name = "Scale on Raid size", order = 2, inline = true,
            args = {
                scaleYes = {
                    name = "根据团队人数自动设置",
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.scaleYes end,
                    set = function(info,val) ns.db.scaleYes = val; ns.updateObjects() end,
                },
                scale25 = {
                    name = "25人",
                    type = "range",
                    order = 2,
                    desc = "团队超过10人自动变为25人框架.", 
                    min = 0.5,
                    max = 2.0,
                    step = .05,
                    disabled = function(info) return not ns.db.scaleYes end,
                    get = function(info) return ns.db.scale25 end,
                    set = function(info,val) ns.db.scale25 = val; ns.updateObjects() end,
                },
                scale40 = {
                    name = "40人",
                    type = "range",
                    order = 3,
                    desc = "团队超过25人自动变为40人框架.",
                    min = 0.5,
                    max = 2.0,
                    step = .05,
                    disabled = function(info) return not ns.db.scaleYes end,
                    get = function(info) return ns.db.scale40 end,
                    set = function(info,val) ns.db.scale40 = val; ns.updateObjects() end,
                },
            },
        },
        width = {
            name = L.generalwidth,
            type = "range",
            order = 4,
            min = 20,
            max = 150,
            step = 1,
            get = function(info) return ns.db.width end,
            set = function(info,val) ns.db.width = val; wipe(ns.nameCache); ns.updateObjects() end,
        },
        height = {
            name = L.generalheight,
            type = "range",
            order = 5,
            min = 20,
            max = 150,
            step = 1,
            get = function(info) return ns.db.height end,
            set = function(info,val) ns.db.height = val; ns.updateObjects() end,
        },
        spacing = {
            name = L.generalspacing,
            type = "range",
            order = 6,
            min = 0,
            max = 30,
            step = 1,
            get = function(info) return ns.db.spacing end,
            set = function(info,val) ns.db.spacing = val; end,
        }, 
        raid = {
            name = L.generalraid,
            type = "group",
            order = 7,
            inline = true,
            args = {
                horizontal = {
                    name = L.generalraidhorizontalname,
                    type = "toggle",
                    order = 1,
					desc = L.generalraidhorizontaldesc,
                    get = function(info) return ns.db.horizontal end,
                    set = function(info,val)
                        if(val == true and (ns.db.growth ~= "UP" or ns.db.growth ~= "DOWN")) then
                            ns.db.growth = "UP"
                        elseif(val == false and (ns.db.growth ~= "RIGHT" or ns.db.growth ~= "LEFT")) then
                            ns.db.growth = "RIGHT"
                        end
                        ns.db.horizontal = val; 
                    end,
                },
                growth = {
                    name = L.generalraidgrowthname,
                    type = "select",
                    order = 2,
					desc = L.generalraidgrowthdesc,
                    values = function(info,val) 
                        info = ns.db.growth
                        if not ns.db.horizontal then
                            return { ["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT" }
                        else
                            return { ["UP"] = "UP", ["DOWN"] = "DOWN" }
                        end
                    end,
                    get = function(info) return ns.db.growth end,
                    set = function(info,val) ns.db.growth = val; end,
                },
                groups = {
                    name = L.generalraidgroupname,
                    type = "range",
                    order = 3,
                    min = 1,
                    max = 8,
                    step = 1,
					desc = L.generalraidgroupdesc,
                    get = function(info) return ns.db.numCol end,
                    set = function(info,val) ns.db.numCol = val; end,
                },
                multi = {
                    name = L.generalraidmultiname,
                    type = "toggle",
                    desc = L.generalraidmultidesc,
                    order = 5,
                    get = function(info) return ns.db.multi end,
                    set = function(info,val) ns.db.multi = val 
                        if val == true then
                            ns.db.sortClass = false
                            ns.db.sortName = false
                        end
                    end,
                },
                units = {
                    name = L.generalraidunitsname,
                    type = "range",
                    order = 4,
                    min = 1,
                    max = 40,
                    step = 1,
                    disabled = function(info) 
                        if ns.db.multi then return true end 
                    end,
                    get = function(info) return ns.db.numUnits end,
                    set = function(info,val) ns.db.numUnits = val; end,
                },
                sortName = {
                    name = L.generalraidsortName,
                    type = "toggle",
                    order = 6,
                    get = function(info) return ns.db.sortName end,
                    set = function(info,val) ns.db.sortName = val 
                        if val == true then
                            ns.db.multi = false
                        end
                    end,
                },
                sortClass = {
                    name = L.generalraidsortClassname,
                    type = "toggle",
                    order = 7,
                    get = function(info) return ns.db.sortClass end,
                    set = function(info,val) ns.db.sortClass = val
                        if val == true then
                            ns.db.multi = false
                        end
                    end,
                },
                classOrder = {
                    name = L.generalraidclassOrdername,
                    type = "input",
                    desc = "Uppercase English class names separated by a comma. \n { CLASS[,CLASS]... }",
                    order = 8,
                    disabled = function() if not ns.db.sortClass then return true end end,
                    get = function(info) return ns.db.classOrder end,
                    set = function(info,val) ns.db.classOrder = tostring(val) end,
                },
                resetClassOrder = {
                    name = L.generalraidresetClassOrdername,
                    type = "execute",
                    order = 9,
                    disabled = function() if not ns.db.sortClass then return true end end,
                    func = function() ns.db.classOrder = ns.defaults.classOrder end,
                },
            },
        },
        pets = {
            name = L.generalpetsname,
            type = "group",
            order = 11,
            inline = true,
            args = {
                pethorizontal = {
                    name = L.generalpethorizontal,
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.pethorizontal end,
                    set = function(info,val)
                        if(val == true and (ns.db.petgrowth ~= "UP" or ns.db.petgrowth ~= "DOWN")) then
                            ns.db.petgrowth = "UP"
                        elseif(val == false and (ns.db.petgrowth ~= "RIGHT" or ns.db.petgrowth ~= "LEFT")) then
                            ns.db.petgrowth = "RIGHT"
                        end
                        ns.db.pethorizontal = val; 
                    end,
                },
                petgrowth = {
                    name = L.generalpetgrowth,
                    type = "select",
                    order = 2,
                    values = function(info,val) 
                        info = ns.db.petgrowth
                        if not ns.db.pethorizontal then
                            return { ["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT" }
                        else
                            return { ["UP"] = "UP", ["DOWN"] = "DOWN" }
                        end
                    end,
                    get = function(info) return ns.db.petgrowth end,
                    set = function(info,val) ns.db.petgrowth = val; end,
                },
                petunits = {
                    name = L.generalppetunits,
                    type = "range",
                    order = 3,
                    min = 1,
                    max = 40,
                    step = 1,
                    get = function(info) return ns.db.petUnits end,
                    set = function(info,val) ns.db.petUnits = val; end,
                },
            },
        },
        MT = {
            name = "MainTanks",
            type = "group",
            inline = true,
            order = 16,
            args= {
                MThorizontal = {
                    name = L.generalpethorizontal,
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.MThorizontal end,
                    set = function(info,val)
                        if(val == true and (ns.db.MTgrowth ~= "UP" or ns.db.MTgrowth ~= "DOWN")) then
                            ns.db.MTgrowth = "UP"
                        elseif(val == false and (ns.db.MTgrowth ~= "RIGHT" or ns.db.MTgrowth ~= "LEFT")) then
                            ns.db.MTgrowth = "RIGHT"
                        end
                        ns.db.MThorizontal = val; 
                    end,
                },
                MTgrowth = {
                    name = L.generalpetgrowth,
                    type = "select",
                    order = 2,
                    values = function(info,val) 
                        info = ns.db.MTgrowth
                        if not ns.db.MThorizontal then
                            return { ["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT" }
                        else
                            return { ["UP"] = "UP", ["DOWN"] = "DOWN" }
                        end
                    end,
                    get = function(info) return ns.db.MTgrowth end,
                    set = function(info,val) ns.db.MTgrowth = val; end,
                },
                MTunits = {
                    name = L.generalppetunits,
                    type = "range",
                    order = 3,
                    min = 1,
                    max = 40,
                    step = 1,
                    get = function(info) return ns.db.MTUnits end,
                    set = function(info,val) ns.db.MTUnits = val; end,
                },
            },
        },
    },
}

local statusbaropts = {
    type = "group", name = L.statusbarname, order = 2,
    args = {
        statusbargroup = { 
            type = "group", name = "Statusbar Texture", inline = true, order = 1,
            args = {
                statusbar = {
                    name = L.statusbarname,
                    type = "select",
                    order = 1,
                    itemControl = "DDI-Statusbar",
                    values = statusbars,
                    get = function(info) 
                        for i, v in next, statusbars do
                            if v == ns.db.texture then return i end
                        end
                    end,
                    set = function(info, val) ns.db.texture = statusbars[val]; 
                        ns.db.texturePath = SM:Fetch("statusbar",statusbars[val]); 
                        ns.updateObjects() 
                    end,
                },
                orientation = {
                    name = L.statusbarorientation,
                    type = "select",
                    order = 2,
                    values = ns.orientation,
                    get = function(info) return ns.db.orientation end,
                    set = function(info,val) ns.db.orientation = val; ns.updateObjects() end,
                },
                hpreversed = {
                    name = "反转",
                    type = "toggle",
                    order = 3,
                    get = function(info) return ns.db.hpreversed end,
                    set = function(info,val) ns.db.hpreversed = val;
                        ns.updateObjects(); 
                    end,
                },
            },
        },
        powerbar = {
            name = L.statusbarpowerbar,
            type = "group",
            order = 2,
            inline = true,
            args = {
                power = {
                    name = L.statusbarpowerbarname,
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.powerbar end,
                    set = function(info,val) ns.db.powerbar = val; ns.updateObjects() end,
                },
                porientation = {
                    name = L.statusbarporientation,
                    type = "select",
                    order = 2,
                    values = ns.orientation,
                    get = function(info) return ns.db.porientation end,
                    set = function(info,val) ns.db.porientation = val; ns.updateObjects() end,
                },
                ppreversed = {
                    name = "反转",
                    type = "toggle",
                    order = 3,
                    get = function(info) return ns.db.ppreversed end,
                    set = function(info,val) ns.db.ppreversed = val;
                        ns.updateObjects(); 
                    end,
                },

                psize = {
                    name = L.statusbarpsize,
                    type = "range",
                    order = 4,
                    min = .02,
                    max = .30,
                    step = .02,
                    get = function(info) return ns.db.powerbarsize end,
                    set = function(info,val) ns.db.powerbarsize = val; ns.updateObjects() end,
                },
            },
        },
        altpower = {
            name = L.statusbaraltpower,
            type = "group",
            order = 3,
            inline = true,
            args = {
                text = {
                    name = L.statusbaraltpowertext,
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.altpower end,
                    set = function(info,val) ns.db.altpower = val end,
                },
            },
        },
    },
}

local fontopts = {
    type = "group", name = L.fontoptsname, order = 3,
    args = {
        font = {
            name = L.fontoptsname,
            type = "select",
            order = 1,
            itemControl = "DDI-Font",
            values = fonts,
            get = function(info)
                for i, v in next, fonts do
                    if v == ns.db.font then return i end
                end
            end,
            set = function(info, val) ns.db.font = fonts[val];
                ns.db.fontPath = SM:Fetch("font",fonts[val]);
                wipe(ns.nameCache); ns.updateObjects() 
            end,
        },
        outline = {
            name = L.fontoptsoutline,
            type = "select",
            order = 2,
            values = ns.outline,
            get = function(info) 
                if not ns.db.outline then
                    return "None"
                else
                    return ns.db.outline
                end
            end,
            set = function(info,val) 
                if val == "None" then
                    ns.db.outline = nil
                else
                    ns.db.outline = val
                end
                ns.updateObjects()
            end,
        },
        fontsize = {
            name = L.fontoptsfontsize,
            type = "range",
            order = 3,
			desc = L.fontoptsfontsizedesc,
            min = 8,
            max = 32,
            step = 1,
            get = function(info) return ns.db.fontsize end,
            set = function(info,val) ns.db.fontsize = val; wipe(ns.nameCache); ns.updateObjects() end,
        },
        fontsizeEdge = {
            name = L.fontoptsfontsizeEdge,
            type = "range",
            order = 4,
            desc = L.fontoptsfontsizeEdgedesc,
            min = 8,
            max = 32,
            step = 1,
            get = function(info) return ns.db.fontsizeEdge  end,
            set = function(info,val) ns.db.fontsizeEdge = val; wipe(ns.nameCache); ns.updateObjects() end,
        },
    },
}

local rangeopts = {
    type = "group", name = L.rangeoptsname, order = 4, width = "half",
    args = {
        oor = {
            name = "超出范围透明度",
            type = "range",
            order = 4,
            min = 0,
            max = 1,
            step = .1,
            get = function(info) return ns.db.outsideRange end,
            set = function(info,val) ns.db.outsideRange = val end,
        },

        rangegroup = { 
            type = "group", name = "Range", inline = true, order = 1,
            args = {
                arrow = {
                    name = L.fontoptsarrow,
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.arrow end,
                    set = function(info,val) ns.db.arrow = val end,
                },
                arrowscale = {
                    name = L.generalscale,
                    type = "range",
                    order = 2,
                    min = 0.5,
                    max = 3,
                    step = .1,
                    get = function(info) return ns.db.arrowscale end,
                    set = function(info,val) ns.db.arrowscale = val; ns.updateObjects() end,
                },
                mouseover = {
                    name = L.fontoptsmouseover,
                    type = "toggle",
                    order = 3,
                    disabled = function(info) if not ns.db.arrow then return true end end,
                    get = function(info) return ns.db.arrowmouseover end,
                    set = function(info,val) ns.db.arrowmouseover = val end,
                },
                mouseoveralways = {
                    name = "鼠标划过总是显示.",
                    type = "toggle",
                    order = 4,
                    desc = "鼠标悬停显示箭头，无论范围.",
                    disabled = function(info) if not ns.db.arrow then return true end end,
                    get = function(info) return ns.db.arrowmouseoveralways end,
                    set = function(info,val) ns.db.arrowmouseoveralways = val end,
                },
            },
        },
    },
}

local healopts = {
    type = "group", name = L.healoptsname, order = 5,
    args = {
        healtext = {
            type = "group",
            name = L.healopthealtext,
            order = 1,
            inline = true,
            args = {
                text = {
                    name = L.healopthealtextname,
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.healtext end,
                    set = function(info,val) ns.db.healtext= val end,
                },
            },
        },
        healbar = {
            type = "group",
            name = L.healopthealbar,
            order = 2,
            inline = true,
            args = {
                bar = {
                    name = L.healopthealbarname,
                    type = "toggle",
                    order = 2,
                    get = function(info) return ns.db.healbar end,
                    set = function(info,val) ns.db.healbar = val end,
                },
                myheal = {
                    name = L.healopthealbarmyheal,
                    type = "color",
                    order = 3,
                    hasAlpha = true,
                    get = function(info) return ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b, ns.db.myhealcolor.a  end,
                    set = function(info,r,g,b,a) ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b, ns.db.myhealcolor.a = r,g,b,a;
                        ns.updateObjects(); 
                    end,
                },
                otherheal = {
                    name = L.healopthealbarotherheal,
                    type = "color",
                    order = 4,
                    hasAlpha = true,
                    get = function(info) return ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b, ns.db.otherhealcolor.a  end,
                    set = function(info,r,g,b,a) ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b, ns.db.otherhealcolor.a = r,g,b,a;
                        ns.updateObjects(); 
                    end,
                },
                overflow = {
                    name = L.healopthealbaroverflow,
                    type = "toggle",
                    order = 6,
                    get = function(info) return ns.db.healoverflow end,
                    set = function(info,val) ns.db.healoverflow = val end,
                },
                others = {
                    name = L.healopthealbarothers,
                    type = "toggle",
                    order = 7,
                    get = function(info) return ns.db.healothersonly end,
                    set = function(info,val) ns.db.healothersonly = val end,
                }, 
            },
        },
        hptext = {
            type = "group",
            name = L.healoptshptext,
            order = 8,
            inline = true,
            args = {
                deficit = {
                    name = L.healoptshptextname,
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.deficit end,
                    set = function(info,val) ns.db.deficit = val 
                        if val == true then
                            ns.db.perc = false
                            ns.db.actual = false
                        end
                    end,
                },
                perc = {
                    name = "显示生命百分比",
                    type = "toggle",
                    order = 2,
                    get = function(info) return ns.db.perc end,
                    set = function(info,val) ns.db.perc = val 
                        if val == true then
                            ns.db.deficit = false
                            ns.db.actual = false
                        end
                    end,
                },
                actual = {
                    name = "显示当前值",
                    type = "toggle",
                    order = 3,
                    get = function(info) return ns.db.actual end,
                    set = function(info,val) ns.db.actual = val 
                        if val == true then
                            ns.db.deficit = false
                            ns.db.perc = false
                        end
                    end,
                },
            },
        },
    },
}

local miscopts = {
    type = "group", name = L.miscoptsname, order = 6,
    args = {
        checkgroup = { type = "group", name = "综合选项", inline = true, order = 1,
        args = {
            party = {
                name = L.miscoptsparty,
                type = "toggle",
                order = 1,
                get = function(info) return ns.db.party end,
                set = function(info,val) ns.db.party = val; end,
            },
            solo = {
                name = L.miscoptssolo,
                type = "toggle",
                order = 2,
                get = function(info) return ns.db.solo end,
                set = function(info,val) ns.db.solo = val; end,
            },
            player = {
                name = L.miscoptsplayer,
                type = "toggle",
                order = 3,
                get = function(info) return ns.db.player end,
                set = function(info,val) ns.db.player = val; end,
            },
            pets = {
                name = L.miscoptspets,
                type = "toggle",
                order = 4,
                get = function(info) return ns.db.pets end,
                set = function(info,val) ns.db.pets = val end,
            },
            MT = {
                name = L.miscoptsMT,
                type = "toggle",
                order = 5,
                get = function(info) return ns.db.MT end,
                set = function(info,val) ns.db.MT = val end,
            },
            omfChar = {
                name = "为每个角色保存位置",
                type = "toggle",
                order = 6,
                get = function(info) return ns.db.omfChar end,
                set = function(info,val) ns.db.omfChar = val end,
            },
            role = {
                name = L.miscoptsrole,
                type = "toggle",
                order = 7,
                get = function(info) return ns.db.roleicon end,
                set = function(info,val) ns.db.roleicon = val end,
            },
            tborder = {
                name = "高亮目标边框",
                type = "toggle",
                order = 8,
                get = function(info) return ns.db.tborder end,
                set = function(info,val) ns.db.tborder = val end,
            },
            fborder = {
                name = L.miscoptsfborder,
                type = "toggle",
                order = 9,
                get = function(info) return ns.db.fborder end,
                set = function(info,val) ns.db.fborder = val end,
            },
            afk = {
                name = L.miscoptsAFK,
                type = "toggle",
                order = 10,
                get = function(info) return ns.db.afk end,
                set = function(info,val) ns.db.afk = val end,
            },
            highlight = {
                name = L.miscoptshighlight,
                type = "toggle",
                order = 11,
                get = function(info) return ns.db.highlight end,
                set = function(info,val) ns.db.highlight = val end,
            },
            dispel = {
                name = L.miscoptsdispel,
                type = "toggle",
                desc = "将光环以图标形式显示",
                order = 12,
                get = function(info) return ns.db.dispel end,
                set = function(info,val) ns.db.dispel = val end,
            },
            tooltip = {
                name = L.miscoptstooltip,
                type = "toggle",
                order = 13,
                get = function(info) return ns.db.tooltip end,
                set = function(info,val) ns.db.tooltip = val end,
            },
            smooth = {
                name = L.miscoptssmooth,
                type = "toggle",
                order = 14,
                get = function(info) return ns.db.smooth end,
                set = function(info,val) ns.db.smooth = val; ns.updateObjects() end,
            },
            hidemenu = {
                name = L.miscoptshidemenu,
                type = "toggle",
                order = 15,
                desc = "Prevent toggling the unit menu in combat.",
                get = function(info) return ns.db.hidemenu end,
                set = function(info,val) ns.db.hidemenu = val; end,
            },
            autorez = {
                name = "自动复活目标",
                type = "toggle",
                order = 16,
                desc = "队友死亡时自动复活之 |cffFF0000无法与Clique插件一起工作.|r",
                get = function(info) return ns.db.autorez end,
                set = function(info,val) ns.db.autorez = val; ns.updateObjects() end,
            },
        },
    },
    slidersgroup = { type = "group", name = "指示设置", inline = true, order = 2,
    args = {
        indicator = {
            name = "指示块大小",
            type = "range",
            order = 16,
            min = 4,
            max = 20,
            step = 1,
            get = function(info) return ns.db.indicatorsize end,
            set = function(info,val) ns.db.indicatorsize = val; ns.updateObjects() end,
        },
        symbol = {
            name = "右下指示块大小",
            type = "range",
            order = 17,
            min = 8,
            max = 20,
            step = 1,
            get = function(info) return ns.db.symbolsize end,
            set = function(info,val) ns.db.symbolsize = val; ns.updateObjects() end,
        },
        icon = {
            name = "Leader, raid, role icons 图标大小",
            type = "range",
            order = 18,
            min = 8,
            max = 20,
            step = 1,
            get = function(info) return ns.db.leadersize end,
            set = function(info,val) ns.db.leadersize = val; ns.updateObjects() end,
        },
        aura = {
            name = "光环大小",
            type = "range",
            order = 19,
            min = 8,
            max = 30,
            step = 1,
            get = function(info) return ns.db.aurasize end,
            set = function(info,val) ns.db.aurasize = val; ns.updateObjects() end,
        },
    },
},
    },
}

local coloropts = {
    type = "group", name = L.coloropts, order = 7,
    args = {
        HP = {
            name = L.coloroptshp,
            type = "group",
            order = 1,
            inline = true,
            args = {
                reverse = {
                    name = L.coloroptshpreverse,
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.reversecolors end,
                    set = function(info,val) ns.db.reversecolors = val;
                        if ns.db.definecolors and val == true then
                            ns.db.definecolors = false
                        end
                        ns:Colors(); ns.updateObjects(); 
                    end,
                },
                hpinverted = {
                    name = "反转生命值和背景",
                    type = "toggle",
                    order = 2,
                    desc = "Does not play nice with the Heal Bar",
                    get = function(info) return ns.db.hpinverted end,
                    set = function(info,val) ns.db.hpinverted = val;
                        ns.updateObjects(); 
                    end,
                },
                hpdefine = {
                    type = "group",
                    name = L.coloroptshpdefine,
                    order = 3,
                    inline = true,
                    args = {
                        definecolors = {
                            name = L.coloroptshpdefine,
                            type = "toggle",
                            order = 2,
                            get = function(info) return ns.db.definecolors end,
                            set = function(info,val) ns.db.definecolors = val;
                                if ns.db.reversecolors and val == true then
                                    ns.db.reversecolors = false
                                end
                                ns:Colors(); ns.updateObjects(); 
                            end,
                        },
                        hpcolor = {
                            name = L.coloroptshpcolor,
                            type = "color",
                            order = 3,
                            hasAlpha = false,
                            get = function(info) return ns.db.hpcolor.r, ns.db.hpcolor.g, ns.db.hpcolor.b, ns.db.hpcolor.a end,
                            set = function(info,r,g,b,a) ns.db.hpcolor.r, ns.db.hpcolor.g, ns.db.hpcolor.b, ns.db.hpcolor.a = r,g,b,a;
                                ns:Colors(); ns.updateObjects(); 
                            end,
                        },
                        hpbgcolor = {
                            name = L.coloroptshpbgcolor,
                            type = "color",
                            order = 4,
                            hasAlpha = true,
                            get = function(info) return ns.db.hpbgcolor.r, ns.db.hpbgcolor.g, ns.db.hpbgcolor.b, ns.db.hpbgcolor.a end,
                            set = function(info,r,g,b,a) ns.db.hpbgcolor.r, ns.db.hpbgcolor.g, ns.db.hpbgcolor.b, ns.db.hpbgcolor.a = r,g,b,a;
                                ns:Colors(); ns.updateObjects(); 
                            end,
                        },
                        colorSmooth = {
                            name = L.coloroptscolorSmooth,
                            type = "toggle",
                            order = 5,
                            disabled = function(info) return not ns.db.definecolors end,
                            get = function(info) return ns.db.colorSmooth end,
                            set = function(info,val) ns.db.colorSmooth = val;
                                if ns.db.hpinverted and val == true then
                                    ns.db.hpinverted = false
                                end
                                ns.updateObjects(); 
                            end,
                        },
                        gradient = {
                            name = L.coloroptsgradient,
                            type = "color",
                            order = 6,
                            hasAlpha = false,
                            get = function(info) return ns.db.gradient.r, ns.db.gradient.g, ns.db.gradient.b, ns.db.gradient.a end,
                            set = function(info,r,g,b,a) ns.db.gradient.r, ns.db.gradient.g, ns.db.gradient.b, ns.db.gradient.a = r,g,b,a;
                                ns.updateObjects(); 
                            end,
                        },
                    },
                },
            },
        },
        PP = {
            name = L.coloroptspp,
            type = "group",
            order = 2,
            inline = true,
            args = {
                powerclass = {
                    name = L.coloroptshpreverse,
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.powerclass end,
                    set = function(info,val) ns.db.powerclass = val; ns.updateObjects(); 
                        if ns.db.powerdefinecolors and val == true then
                            ns.db.powerdefinecolors = false
                        end
                        ns:Colors(); ns.updateObjects();
                    end,
                },
                ppinverted = {
                    name = "反转能力条和背景",
                    type = "toggle",
                    order = 2,
                    get = function(info) return ns.db.ppinverted end,
                    set = function(info,val) ns.db.ppinverted = val;
                        ns.updateObjects(); 
                    end,
                },
                ppdefine = {
                    type = "group",
                    name = L.coloroptsppdefine,
                    order = 3,
                    inline = true,
                    args = {
                        powerdefinecolors = {
                            name = L.coloroptsppdefine,
                            type = "toggle",
                            order = 2,
                            get = function(info) return ns.db.powerdefinecolors end,
                            set = function(info,val) ns.db.powerdefinecolors = val;
                                if ns.db.powerclass and val == true then
                                    ns.db.powerclass = false
                                end
                                ns:Colors(); ns.updateObjects(); 
                            end,
                        },
                        powercolor = {
                            name = L.coloroptspowercolor,
                            type = "color",
                            order = 3,
                            hasAlpha = false,
                            get = function(info) return ns.db.powercolor.r, ns.db.powercolor.g, ns.db.powercolor.b, ns.db.powercolor.a end,
                            set = function(info,r,g,b,a) ns.db.powercolor.r, ns.db.powercolor.g, ns.db.powercolor.b, ns.db.powercolor.a = r,g,b,a; 
                                ns:Colors(); ns.updateObjects(); 
                            end,
                        },
                        powerbgcolor = {
                            name = L.coloroptspowerbgcolor,
                            type = "color",
                            order = 4,
                            hasAlpha = true,
                            get = function(info) return ns.db.powerbgcolor.r, ns.db.powerbgcolor.g, ns.db.powerbgcolor.b, ns.db.powerbgcolor.a end,
                            set = function(info,r,g,b,a) ns.db.powerbgcolor.r, ns.db.powerbgcolor.g, ns.db.powerbgcolor.b, ns.db.powerbgcolor.a = r,g,b,a;
                                ns:Colors(); ns.updateObjects(); 
                            end,
                        },
                    },
                },
            },
        },
    },
}

local clusteropts = {
    type = "group", name = "治疗专用", order = 8, width = "half",
    --clustergroup = { 
    --type = "group", name = "Cluster", inline = true, order = 1,
    args = {
        enabled = {
            name = "使用",
            type = "toggle",
            order = 1,
            desc = "在框架的右角说明有多少人生命值低于设定值并且在治疗范围内.",
            get = function(info) return ns.db.cluster.enabled end,
            set = function(info,val) ns.db.cluster.enabled = val; 
                ns.updateObjects(); 
            end,
        },
        range = {
            name = "距离",
            type = "range",
            order = 2,
            min = 5,
            max = 40,
            step = 1,
            get = function(info) return ns.db.cluster.range end,
            set = function(info,val) ns.db.cluster.range = val; ns.updateObjects(); end,
        },
        perc = {
            name = "生命百分比",
            type = "range",
            order = 3,
			desc = "在此设定生命值门限.",
            min = 10,
            max = 100,
            step = 5,
            get = function(info) return ns.db.cluster.perc end,
            set = function(info,val) ns.db.cluster.perc = val; ns.updateObjects(); end,
        },
        freq = {
            name = "扫描间隔",
            type = "range",
            order = 4,
            desc = "Set how often to scan in milliseconds.",
            min = 100,
            max = 1000,
            step = 50,
            get = function(info) return ns.db.cluster.freq end,
            set = function(info,val) ns.db.cluster.freq = val; ns.updateObjects(); end,
        },
        textcolor = {
            name = "文字颜色",
            type = "color",
            order = 5,
            hasAlpha = false,
            get = function(info) return ns.db.cluster.textcolor.r, ns.db.cluster.textcolor.g, ns.db.cluster.textcolor.b, ns.db.cluster.textcolor.a end,
            set = function(info,r,g,b,a) ns.db.cluster.textcolor.r, ns.db.cluster.textcolor.g, ns.db.cluster.textcolor.b, ns.db.cluster.textcolor.a = r,g,b,a; 
                ns.updateObjects(); 
            end,
        },
    },
    --},
}

local ClickCastSets = {
    type = "group",
	name = L.ClickCast, 
	order = 9, 
	childGroups = "select",
	args = {
		Enable = {
			name = L.ClickCastenable,
			type = "toggle",
			order = 1,
			width  = "full",
			desc = L.ClickCastenabledesc,
			get = function(info) return ns.db.ClickCastenable end,
			set = function(info,val) ns.db.ClickCastenable = val;end,
			},
		SetDefault = {
				name = L.ClickCastSetDefault,
				type = "execute",
				func = function() ns:ClickSetDefault();ns.db.ClickCastsetchange = true; ns.ApplyClickSetting(); end,
				order = 2,
				desc = L.ClickCastSetDefaultdesc,
			},
		apply = {
				name = L.ClickCastapply,
				type = "execute",
				func = function() ns.db.ClickCastsetchange = true; ns.ApplyClickSetting(); end,
				order = 3,
				desc = L.ClickCastapplydesc,
			},

		CSGroup1 = {
			order = 4,
			type = "group",
			name = L.ClickCastleft,		
			disabled = function() return not ns.db.ClickCastenable end,
			args = {
				type1 = {
					order = 1,
					type = "select",
					name = L.ClickCastleft,
					get = function(info) return ns.db.ClickCastset["1"]["Click"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"1","Click",L.ClickCastleft);  end,
					values = defaultvalues
				},
				shiftztype1 = {
					order = 2,
					type = "select",
					name = "shift + "..L.ClickCastleft,
					get = function(info) return ns.db.ClickCastset["1"]["shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"1","shift-","shift + "..L.ClickCastleft);  end,
					values = defaultvalues						
				},
				ctrlztype1 = {
					order = 3,
					type = "select",
					name = "ctrl + "..L.ClickCastleft,
					get = function(info) return ns.db.ClickCastset["1"]["ctrl-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"1","ctrl-", "ctrl + "..L.ClickCastleft);  end,
					values = defaultvalues
				},
				altztype1 = {
					order = 4,
					type = "select",
					name = "alt + "..L.ClickCastleft,
					get = function(info) return ns.db.ClickCastset["1"]["alt-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"1","alt-","alt + "..L.ClickCastleft);  end,
					values = defaultvalues
				},
				altzctrlztype1 = {
					order = 5,
					type = "select",
					name = "alt + ctrl + "..L.ClickCastleft,
					get = function(info) return ns.db.ClickCastset["1"]["alt-ctrl-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"1","alt-ctrl-", "alt + ctrl + "..L.ClickCastleft);  end,
					values = defaultvalues
				},
				altzshiftztype1 = {
					order = 6,
					type = "select",
					name = "alt + shift + "..L.ClickCastleft,
					get = function(info) return ns.db.ClickCastset["1"]["alt-shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"1","alt-shift-","alt + shift + "..L.ClickCastleft);  end,
					values = defaultvalues
				},
				ctrlzshifttype1 = {
					order = 7,
					type = "select",
					name = "ctrl + shift + "..L.ClickCastleft,
					get = function(info) return ns.db.ClickCastset["1"]["ctrl-shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"1","ctrl-shift-","ctrl + shift + "..L.ClickCastleft);  end,
					values = defaultvalues
				},
			},
		},
		CSGroup2 = {
			order = 5,
			type = "group",
			name = L.ClickCastright,
			
			disabled = function() return not ns.db.ClickCastenable end,	
			args = {
				type2 = {
					order = 1,
					type = "select",
					name = L.ClickCastright,
					get = function(info) return ns.db.ClickCastset["2"]["Click"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"2","Click",L.ClickCastright);  end,
					values = defaultvalues
				},
				shiftztype2 = {
					order = 2,
					type = "select",
					name = "shift + "..L.ClickCastright,
					get = function(info) return ns.db.ClickCastset["2"]["shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"2","shift-","shift + "..L.ClickCastright);  end,
					values = defaultvalues				
				},
				ctrlztype2 = {
					order = 3,
					type = "select",
					name = "ctrl + "..L.ClickCastright,
					get = function(info) return ns.db.ClickCastset["2"]["ctrl-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"2","ctrl-","ctrl + "..L.ClickCastright);  end,
					values = defaultvalues
				},
				altztype2 = {
					order = 4,
					type = "select",
					name = "alt + "..L.ClickCastright,
					get = function(info) return ns.db.ClickCastset["2"]["alt-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"2","alt-","alt + "..L.ClickCastright);  end,
					values = defaultvalues
				},
				altzctrlztype2 = {
					order = 5,
					type = "select",
					name = "alt + ctrl + "..L.ClickCastright,
					get = function(info) return ns.db.ClickCastset["2"]["alt-ctrl-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"2","alt-ctrl-","alt + ctrl + "..L.ClickCastright);  end,
					values = defaultvalues
				},
				altzshiftztype2 = {
					order = 6,
					type = "select",
					name = "alt + shift + "..L.ClickCastright,
					get = function(info) return ns.db.ClickCastset["2"]["alt-shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"2","alt-shift-","alt + shift + "..L.ClickCastright);  end,
					values = defaultvalues
				},
				ctrlzshifttype2 = {
					order = 7,
					type = "select",
					name = "ctrl + shift + "..L.ClickCastright,
					get = function(info) return ns.db.ClickCastset["2"]["ctrl-shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"2","ctrl-shift-","ctrl + shift + "..L.ClickCastright);  end,
					values = defaultvalues
				},
			},
		},

		CSGroup3 = {
			order = 6,
			type = "group",
			name = L.ClickCastmiddle,
			
			disabled = function() return not ns.db.ClickCastenable end,	
			args = {
				type3 = {
					order = 1,
					type = "select",
					name = L.ClickCastmiddle,
					get = function(info) return ns.db.ClickCastset["3"]["Click"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"3","Click",L.ClickCastmiddle);  end,
					values = defaultvalues
				},
				shiftztype3 = {
					order = 2,
					type = "select",
					name = "shift + "..L.ClickCastmiddle,
					get = function(info) return ns.db.ClickCastset["3"]["shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"3","shift-","shift + "..L.ClickCastmiddle);  end,
					values = defaultvalues					
				},
				ctrlztype3 = {
					order = 3,
					type = "select",
					name = "ctrl + "..L.ClickCastmiddle,
					get = function(info) return ns.db.ClickCastset["3"]["ctrl-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"3","ctrl-", "ctrl + "..L.ClickCastmiddle);  end,
					values = defaultvalues
				},
				altztype3 = {
					order = 4,
					type = "select",
					name = "alt + "..L.ClickCastmiddle,
					get = function(info) return ns.db.ClickCastset["3"]["alt-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"3","alt-","alt + "..L.ClickCastmiddle);  end,
					values = defaultvalues
				},
				altzctrlztype3 = {
					order = 5,
					type = "select",
					name = "alt + ctrl + "..L.ClickCastmiddle,
					get = function(info) return ns.db.ClickCastset["3"]["alt-ctrl-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"3","alt-ctrl-","alt + ctrl + "..L.ClickCastmiddle);  end,
					values = defaultvalues
				},
				altzshiftztype3 = {
					order = 6,
					type = "select",
					name = "alt + shift + "..L.ClickCastmiddle,
					get = function(info) return ns.db.ClickCastset["3"]["alt-shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"3","alt-shift-","alt + shift + "..L.ClickCastmiddle);  end,
					values = defaultvalues
				},
				ctrlzshifttype3 = {
					order = 7,
					type = "select",
					name = "ctrl + shift + "..L.ClickCastmiddle,
					get = function(info) return ns.db.ClickCastset["3"]["ctrl-shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"3","ctrl-shift-", "ctrl + shift + "..L.ClickCastmiddle);  end,
					values = defaultvalues
				},
			},
		},
		CSGroup4 = {
			order = 7,
			type = "group",
			name = L.ClickCastfour,
			
			disabled = function() return not ns.db.ClickCastenable end,	
			args = {
				type4 = {
					order = 1,
					type = "select",
					name = L.ClickCastfour,
					get = function(info) return ns.db.ClickCastset["4"]["Click"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"4","Click", L.ClickCastfour);  end,
					values = defaultvalues
				},
				shiftztype4 = {
					order = 2,
					type = "select",
					name = "shift + "..L.ClickCastfour,
					get = function(info) return ns.db.ClickCastset["4"]["shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"4","shift-","shift + "..L.ClickCastfour);  end,
					values = defaultvalues						
				},
				ctrlztype4 = {
					order = 3,
					type = "select",
					name = "ctrl + "..L.ClickCastfour,
					get = function(info) return ns.db.ClickCastset["4"]["ctrl-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"4","ctrl-","ctrl + "..L.ClickCastfour);  end,
					values = defaultvalues
				},
				altztype4 = {
					order = 4,
					type = "select",
					name = "alt + "..L.ClickCastfour,
					get = function(info) return ns.db.ClickCastset["4"]["alt-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"4","alt-","alt + "..L.ClickCastfour);  end,
					values = defaultvalues
				},
				altzctrlztype4 = {
					order = 5,
					type = "select",
					name = "alt + ctrl + "..L.ClickCastfour,
					get = function(info) return ns.db.ClickCastset["4"]["alt-ctrl-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"4","alt-ctrl-", "alt + ctrl + "..L.ClickCastfour);  end,
					values = defaultvalues
				},
				altzshiftztype4 = {
					order = 6,
					type = "select",
					name = "alt + shift + "..L.ClickCastfour,
					get = function(info) return ns.db.ClickCastset["4"]["alt-shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"4","alt-shift-","alt + shift + "..L.ClickCastfour);  end,
					values = defaultvalues
				},
				ctrlzshifttype4 = {
					order = 7,
					type = "select",
					name = "ctrl + shift + "..L.ClickCastfour,
					get = function(info) return ns.db.ClickCastset["4"]["ctrl-shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"4","ctrl-shift-", "ctrl + shift + "..L.ClickCastfour);  end,
					values = defaultvalues
				},
			},
		},
		CSGroup5 = {
			order = 8,
			type = "group",
			name = L.ClickCastfive,
			
			disabled = function() return not ns.db.ClickCastenable end,	
			args = {
				type5 = {
					order = 1,
					type = "select",
					name = L.ClickCastfive,
					get = function(info) return ns.db.ClickCastset["5"]["Click"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"5","Click",L.ClickCastfive);  end,
					values = defaultvalues
				},
				shiftztype5 = {
					order = 2,
					type = "select",
					name = "shift + "..L.ClickCastfive,
					get = function(info) return ns.db.ClickCastset["5"]["shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"5","shift-","shift + "..L.ClickCastfive);  end,
					values = defaultvalues					
				},
				ctrlztype5 = {
					order = 3,
					type = "select",
					name = "ctrl + "..L.ClickCastfive,
					get = function(info) return ns.db.ClickCastset["5"]["ctrl-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"5","ctrl-","ctrl + "..L.ClickCastfive);  end,
					values = defaultvalues
				},
				altztype5 = {
					order = 4,
					type = "select",
					name = "alt + "..L.ClickCastfive,
					get = function(info) return ns.db.ClickCastset["5"]["alt-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"5","alt-","alt + "..L.ClickCastfive);  end,
					values = defaultvalues
				},
				altzctrlztype5 = {
					order = 5,
					type = "select",
					name = "alt + ctrl + "..L.ClickCastfive,
					get = function(info) return ns.db.ClickCastset["5"]["alt-ctrl-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"5","alt-ctrl-", "alt + ctrl + "..L.ClickCastfive);  end,
					values = defaultvalues
				},
				altzshiftztype5 = {
					order = 6,
					type = "select",
					name = "alt + shift + "..L.ClickCastfive,
					get = function(info) return ns.db.ClickCastset["5"]["alt-shift-"]["action"] end,
					set = function(info,val) SetClickKeyvalue(val,"5","alt-shift-","alt + shift + "..L.ClickCastfive);  end,
					values = defaultvalues
				},
				ctrlzshifttype5 = {
					order = 7,
					type = "select",
					name = "ctrl + shift + "..L.ClickCastfive,
					get = function(info) return ns.db.ClickCastset["5"]["ctrl-shift-"]["action"]   end,
					set = function(info,val) SetClickKeyvalue(val,"5","ctrl-shift-","ctrl + shift + "..L.ClickCastfive);  end,
					values = defaultvalues
				},
			},
		},
		macro = {
					order = 9,
					type = "input",
					width  = "full",
					multiline  = true,
					name = function(info)return macroedit.keyname..L.ClickCastmacro end,		
					hidden =  function() return macroedit.hidden end,				
					desc = L.ClickCastmacrodesc,
					get = function(info) if  macroedit.path then return macroedit.path["macrotext"] else return "" end end,
					set = function(info,val) 
						macroedit.path["macrotext"] = val
						macroedit.hidden = true
					end,
		},
    },	
}

if ns.db.ClickCastenable then	
	local class = select(2, UnitClass("player"))
	for _, v in pairs(default_spells[class]) do
		local spellname = GetSpellInfo(v)	
		if spellname then
			for  i = 1, 5 do
				ClickCastSets["args"]["CSGroup"..i ]["args"]["type"..i ]["values"][tostring(spellname)]  = spellname
				ClickCastSets["args"]["CSGroup"..i ]["args"]["shiftztype"..i ]["values"][tostring(spellname)]  = spellname
				ClickCastSets["args"]["CSGroup"..i ]["args"]["ctrlztype"..i ]["values"][tostring(spellname)]  = spellname
				ClickCastSets["args"]["CSGroup"..i ]["args"]["altztype"..i ]["values"][tostring(spellname)]  = spellname
				ClickCastSets["args"]["CSGroup"..i ]["args"]["altzctrlztype"..i ]["values"][tostring(spellname)]  = spellname
				ClickCastSets["args"]["CSGroup"..i ]["args"]["altzshiftztype"..i ]["values"][tostring(spellname)]  = spellname
				ClickCastSets["args"]["CSGroup"..i ]["args"]["ctrlzshifttype"..i ]["values"][tostring(spellname)]  = spellname
			end
		end
	end
end

local options = {
    type = "group", name = ADDON_NAME,
    args = {
        unlock = {
            name = L.optionsunlock,
            type = "execute",
            func = function() ns:Movable(); end,
            order = 1,
        },
        reload = {
            name = L.optionsreload,
            type = "execute",
            desc = L.optionsreloaddesc,
            func = function() ReloadUI(); end,
            order = 2,
        },
		default = {
            name = L.optionsdefault,
            type = "execute",
            desc = L.optionsdefaultdesc,
            func = function() 
				for k, v in pairs(ns.defaults) do
					ns.db[k] = v 
				end
				ns.db.ClickCastsetchange = true
				ns.ClickSetDefault()
				ns.ApplyClickSetting()
				ns.updateObjects()
			end,
            order = 3,
        },
		
        general = generalopts,
        statusbar = statusbaropts,
        font = fontopts,
        range = rangeopts,
        heal = healopts,
        misc = miscopts,
        color = coloropts,
        cluster = clusteropts,
		ClickSet = ClickCastSets,
    },
}

local AceConfig = LibStub("AceConfig-3.0")
AceConfig:RegisterOptionsTable(ADDON_NAME, options)

local ACD = LibStub('AceConfigDialog-3.0')
ACD:AddToBlizOptions(ADDON_NAME, ADDON_NAME)

--InterfaceOptions_AddCategory(ns.movableopt)
LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)
