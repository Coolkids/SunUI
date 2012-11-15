local S, C, L, DB = unpack(select(2, ...))

if (GetLocale() == "zhTW" or GetLocale() == "zhCN") then  return end
-- 控制台
--标语
L["恢复默认标语"] = "|cffDDA0DDSun|r|cff44CCFFUI|r\n|cffFF0000Sure to Default Setting|r\n"
L["欢迎标语"] = "Welcome|cffDDA0DDSun|r|cff44CCFFUI|r\n\nLoading Default Setting\n"
L["警告"] = "|cffFFD700Use this Module need big memory.|r"
--总
L["恢复默认设置"] = "DefaultSet"
L["解锁框体"] = "unLock"
L["锁定框体"] = "Lock"
L["应用(重载界面)"] = "Accpet(Reload)"
-- 动作条
L["动作条"] = "ActionBar"
L["请选择主动作条布局"] = "Main ActionBar Layout"
L["bar1布局"] = "Bar1 Layout"
L["bar2布局"] = "Bar2 Layout"
L["bar3布局"] = "Bar3 Layout"
L["bar4布局"] = "Bar4 Layout"
L["bar5布局"] = "Bar5 Layout"
L["12x1布局"] = "12x1"
L["6x2布局"] = "6x2"
L["4方块布局"] = "Big 4 ActionBar"
L["不要4方块布局"] = "Not Big 4 ActionBar"
L["动作条皮肤风格"] = "ActionBar Slyte"
L["请选择动作条皮肤风格"] = "select ActionBar Slyte"
L["阴影风格"] = "Shadow Slyte"
L["框框风格"] = "Borde"
L["隐藏快捷键显示"] = "Hide Hotkey"
L["隐藏宏名称显示"] = "Hide Macro Name"
L["冷却闪光"] = "Cooldown Flash"
L["动作条按钮大小"] = "ActionBar Button Size"
L["动作条间距大小"] = "ActionBar Button Spacing"
L["动作条字体大小"] = "ActionBar Font Size"
L["宏名字字体大小"] = "Macro Name Font Size"
L["主动作条缩放大小"] = "Main ActionBar Scale"
L["特殊按钮缩放大小"] = "ExtraBar Sacle"
L["宠物条缩放大小"] = "PetBar Sacle"
L["姿态栏缩放大小"] = "StanceBar Sacle"
L["图腾栏缩放大小"] = "TotemBar Sacle"
L["冷却闪光图标大小"] = "CooldownFlash Size"
--姓名板
L["姓名板"] = "Nameplate"
L["姓名板字体大小"] = "Nameplate Font Size"
L["姓名板血条高度"] = "Nameplate HP Height"
L["姓名板血条宽度"] = "Nameplate HP Width"
L["姓名板施法条图标大小"] = "Nameplate Castbar Icon Size"
L["姓名板施法条高度"] = "Nameplate Castbar Height"
L["姓名板施法条宽度"] = "Nameplate Castbar Width"
L["启用姓名板"] = "enable Nameplate"
L["启用战斗显示"] = "enable in combat"
L["启用debuff显示"] = "show debuff"
--鼠标提示
L["鼠标提示"] = "Tooltips"
L["提示框体跟随鼠标"] = "Cursor"
L["进入战斗自动隐藏"] = "Hide In Combat"
L["字体大小"] = "Font Size"
L["隐藏头衔"] = "Hide Titles"
L["主天赋"] = "Main Talent:|cffffffff "
L["副天赋"] = "Second  Talent:|cffffffff "
L["成就点数"] = "|cFFF1C502Achievement Point:  |cFFFFFFFF"
L["正在查询成就"] = "Loading.."
L["释放者"] = "Cast By:"
L["法术ID"] = "Spell ID"
--增益效果
L["增益效果"] = "BUFF"
L["图标大小"] = "Icon Size："
L["BUFF增长方向"] = "Set Buff Direction："
L["从右向左"] = "right to left"
L["从左向右"] = "left to right"
L["DEBUFF增长方向"] = "Set DeBuff Direction："
L["每行图标数"] = "Icon Per Row"
--仇恨监视
L["仇恨监视"] = "Threat"
L["仇恨条宽度"] = "Threat bat Width："
L["仇恨条姓名长度"] = "Name Text Length："
L["显示仇恨人数"] = "ThreatLimited："
--reminder
L["缺失提醒"] = "Reminder"
L["显示团队增益缺失提醒"] = "Show Raid Buff"
L["只在队伍中显示"] = "Show Only In Party"
L["团队增益图标大小"] = "Raid Buff Size："
L["团队增益图标排列方式"] = "Raid Buff Direction："
L["横排"] = "横排"
L["竖排"] = "竖排"
L["显示职业增益缺失提醒"] = "Show Class Buff"
L["开启声音警报"] = "Sound warning"
L["职业增益图标大小"] = "Class Buff Size："
L["职业增益图标间距"] = "Class Buff Space："
--界面皮肤
L["界面皮肤"] = "Skin"
L["启用DBM皮肤"] = "DBM Skin"
--头像
L["头像框体"] = "UnitFrame"
L["开启boss框体"] = "Boss UnitFrame"
L["血条职业颜色"] = "ClassColorbars"
L["蓝条颜色"] = "PowerColor"
L["蓝条职业颜色"] = "PowerClassColor"
L["是否开启头像"] = "Portraits"
L["是否只显示你释放的debuff"] = "only show player debuffs on target"
L["头像字体大小"] = "Font Size："
L["法力条高度"] = "PowerHeight："
L["头像缩放大小"] = "UnitFrame Scale："
L["玩家施法条宽度"] = "Player Castbar Width："
L["玩家施法条高度"] = "Player Castbar Height："
L["目标施法条宽度"] = "Target Castbar Width："
L["目标施法条高度"] = "Target Castbar Height："
L["焦点施法条宽度"] = "Focus Castbar Width："
L["焦点施法条高度"] = "Focus Castbar Height："
L["宠物施法条宽度"] = "Pet Castbar Width："
L["宠物施法条高度"] = "Pet Castbar Height："
L["施法条图标大小"] = "Castbar Icon Size："
--mini
L["小东西设置"] = "Mini"
L["启用出售垃圾"] = "AutoSell"
L["启用自动修理"] = "AutoRepair"
L["启用聊天信息过滤"] = "ChatFilter"
L["启用系统红字屏蔽"] = "Fast System Error"
L["启用打断通报"] = "Interrupt Say"
L["PVP冷却计时"] = "PVP CD Time"
L["启用团队工具"] = "Raid Tools"
L["需要团长或者助理权限"] = "Need RL or Assistant"
L["启用自动邀请"] = "Autoinvite"
L["自动邀请关键字"] = "Invite_Word："
L["启用自动离开有进度的随机副本或团队"] = "Auto leave old LFD or LFR"
L["UI缩放"] = "uiScale"
L["UI缩放大小"] = "uiScale Size："
L["应用"] = "Accpet"
L["启用插件UI缩放设定"] = "Open SunUI uiScale"
L["自动设定UI缩放"] = "Auto set uiScale"
L["需要开启插件UI缩放设定"] = "Need Open SunUI uiScale"
L["锁定UI缩放"] = "Lock uiScale "
L["内置CD"] = "Internal cooldown"
L["启动内置CD"] = "Open Internal cooldown"
L["内置CD字体大小"] = "Internal cooldown font size："
L["框体宽度"] = "bar height："
L["框体高度"] = "bar width："
L["计时条增长方向"] = "bar Direction："
L["向下"] = "Down"
L["向上"] = "Up"
L["启用施法通告"] = "enable cast announce"
--other
L["内存占用"] = "|cffFFD700Memory：|r"
L["处理器占用"] = "|cffFFD700CPU：|r"
L["插件管理"] = "|cffDDA0DDAddonManager|r"
L["SunUI插件管理"] = "|cffDDA0DDSun|r|cff44CCFFUI|r AddonManager"
L["第"] = "No. "
L["页/共"] = "  /  "
L["页"] = " Page"
--打断
L["我已打断: =>"] = "I Interrupt: =>"
L["<=的 "] = "<= "
--背包
L["背包"] = "Bags"
L["搜索"] = "Search"
L["整理背包"] = "JPack"
--move
L["玩家施法条"] = "Player Castbar"
L["目标施法条"] = "Target Castbar"
L["焦点施法条"] = "Focus Castbar"
L["宠物施法条"] = "Pet Castbar"
L["内置CD监视"] = "Internal cooldown"
L["仇恨监视"] = "Threat"
L["缺少药剂buff提示"] =  "Reminder"
L["连击点"] = "Combat Point"
L["暗影魔计时条"] = "Shadow Pet Time"
L["小地图"] = "MiniMap"
L["鼠标左键拖动我!"] = "Hold down to drag"
L["药水"] = "Reminder"
L["冷却闪光"] = "CooldownFlash"
--minimap
L["角色信息"] = "Character"
L["法术书"] = "SpellBook"
L["天赋"] = "Talent"
L["成就"] = "Achievement"
L["任务日志"] = "QuestLog"
L["社交"] = "Friends"
L["公会"] = "Guild"
L["地城查找器"] = "LFD"
L["团队查找器"] = "LFR"
L["帮助"] = "Help"
L["行事历"] = "Calendar"
L["地城手册"] = "EncounterJournal"
L["就位确认"] = "ReadyCheck"
L["角色检查"] = "InitiateRolePoll"
L["转化为团队"] = "ConvertToRaid"
L["转化为小队"] = "ConvertToParty"
--声望条
L["经验值"] = "Experience:"
L["剩余"] = 'Last: %s'
L["休息"] = '|cffb3e1ffReset: %s (%d%%)'
L["阵营"] = 'Name: %s'
L["状态"] = 'State: |c'
L["声望"] = 'Faction: %s/%s (%d%%)'
L["仇恨"] = "Hated"
L["敌对"] = "Hostile"
L["不友好"] = "Unfriendly"
L["中立"] = "Neutral"
L["友好"] = "Friendly"
L["尊敬"] = "Honored"
L["崇敬"] = "Revered"
L["崇拜"] = "Exalted"
--信息条
L["没有工会"] = "No Guild"
L["免伤分析"] = "Resistance Analysis"
L["免伤"] = "Spell Resistance"
L["等级缓和"] = "等级缓和"
L["头部"] = "Head"
L["肩部"] = "Shoulder"
L["胸部"] = "Chest"
L["腰部"] = "Waist"
L["手腕"] = "Wrists"
L["手"] = "Hands"
L["腿部"] = "Legs"
L["脚"] = "Feet"
L["主手"] = "Main Hand"
L["副手"] = "Off Hand"
L["远程"] = "Ranged"
L["共释放内存"] = "Total Memory Freed"
L["总共内存使用"] = "Total Memory in use"
L["延迟"] = "Latency"
L["本地延迟"] = "Local"
L["世界延迟"] = "World"
L["耐久度"] = "Durability"
L["信息面板"] = "Info Panel"
L["启用顶部信息条"] = "Enable Top infobar"
L["启用底部信息条"] = "Enable Bottom infobar"
L["底部信息条宽度"] = "Bottom inforbar width"
L["底部信息条高度"] = "Bottom infobar height"
L["带宽"] = "Bandwidth"
L["下载"] = "Downlaod"
L["背包"] = "Bag"
L["背包剩余"] = "Empty Slots"
L["背包总计"] = "Total Slots"
L["邮件"] = "Mail"
L["新邮件"] = "New Mail"
L["无邮件"] = "No Mail"
L["地区"] = "Area"
L["Hidden"] = "Hidden"
L["Alt"] = "Alt"
L["Default UI Memory Usage:"] = "Default UI Memory Usage:"
L["Total Memory Usage:"] = "Total Memory Usage:"
--chat
L["综合"] = "[General]"
L["交易"] = "[Trade]"
L["世界防务"] = "[WorldDefense]"
L["本地防御"] = "[LocalDefense]"
L["寻求组队"] = "[LookingForGroup]"
L["工会招募"] = "[GuildRecruitment]"
L["战场"] = "[Battleground]"
L["战场领袖"] = "[Battleground Leader]"
L["工会"] = "[Guild]"
L["小队"] = "[Party]"
L["小队队长"] = "[Party Leader]"
L["地城领袖"] = "[Party Leader]"
L["官员"] = "[Officer]"
L["团队"] = "[Raid]"
L["团队领袖"] = "[Raid Leader]"
L["团队警告"] = "[Raid Warning]"
--staddonmanage
L["Search"] = "Search"
L["ReloadUI"] = "Reload UI"
L["Profiles"] = "Profiles"
L["New_Profile"] = "New Profile"
L["Enable_All"] = "Enable All"
L["Disable_All"] = "Disable All"
L["Profile_Name"] = "Profile Name"
L["Set_To"] = "Set To.."
L["Add_To"] = "Add To.."
L["Remove_From"] = "Remove From.."
L["Delete_Profile"] = "Delete Profile.."
L["Confirm_Delete"] = "Are you sure you want to delete this profile? Hold down shift and click again if you are."
L["Dependencies"] = "Dependencies"
L["Optional Dependencies"] = "Optional Dependencies"
L["全局字体大小"] = "Overall Font Size"
--3.6
L["一次显示插件数目"] = "Number of Addons been shown at the same time"
L["动作条渐隐"] = "Hide ActionBar"
L["隐藏团队警告"] = "Hide Raid Warning"
L["玩家与目标框体宽度"] = "Player and Target Frame Width"
L["玩家与目标框体高度"] = "Player and Target Frame Height"
L["宠物ToT焦点框体宽度"] = "Pet ToT Focus Frame Width"
L["宠物ToT焦点框体高度"] = "Pet ToT Focus Frame Height"
L["宠物ToT焦点缩放大小"] = "Pet ToT Focus Frame Scale"
L["Boss小队竞技场框体宽度"] = "Boss Party Arena Frame Width"
L["Boss小队竞技场框体高度"] = "Boss Party Arena Frame Height"
L["Boss小队竞技场缩放大小"] = "Boss Party Arena Frame Scale"
L["开启目标的目标"] = "Target's Target"
L["开启宠物框体"] = "Pet Frame"
L["开启焦点框体"] = "Focus Frame"
L["开启小队框体"] = "Party Frame"
L["开启boss框体"] = "Boss Frame"
L["开启竞技场框体"] = "Arena Frame"
L["开启物理攻击计时条"] = "Enable "
L["开启头像渐隐"] = "Fadeout Player's Portrait"
L["开启头像职业血条颜色"] = "HPbar Color As Class"
L["锁定玩家施法条到玩家头像"] = "Lock Player's Castbar to Portrait"
L["锁定目标施法条到目标框体"] = "Lock Player's Castbar to Target Frame"
L["锁定焦点施法条到焦点框体"] = "Lock Focus's Castbar to Focus Frame"
L["头像透明度"] = "Unit Transparency"
--320
L["目标增减益"] = "Target's Buff/Debuff"
L["显示"] = "Show"
L["不显示"] = "Hide"
--422
L["团队框架"] = "RAID Frame"
L["技能监视"] = "RayWatch"
--503
L["打开任务物品按钮"] = "任务物品按钮"
L["打开自动补购"] = "打开自动补购"
L["打开坦克护盾监视"] = "坦克护盾监视"
L["打开团队技能CD监视"] = "团队技能CD监视"

--new
-- Talent spec
L_PLANNER_DEATHKNIGHT_1 = "Blood"
L_PLANNER_DEATHKNIGHT_2 = "Frost"
L_PLANNER_DEATHKNIGHT_3 = "Unholy"
L_PLANNER_DRUID_1 = "Balance"
L_PLANNER_DRUID_2 = "Feral Combat"
L_PLANNER_DRUID_3 = "Guardian"
L_PLANNER_DRUID_4 = "Restoration"
L_PLANNER_HUNTER_1 = "Beast Mastery"
L_PLANNER_HUNTER_2 = "Marksmanship"
L_PLANNER_HUNTER_3 = "Survival"
L_PLANNER_MAGE_1 = "Arcane"
L_PLANNER_MAGE_2 = "Fire"
L_PLANNER_MAGE_3 = "Frost"
L_PLANNER_MONK_1 = "Brewmaster"
L_PLANNER_MONK_2 = "Mistweaver"
L_PLANNER_MONK_3 = "Windwalker"
L_PLANNER_PALADIN_1 = "Holy"
L_PLANNER_PALADIN_2 = "Protection"
L_PLANNER_PALADIN_3 = "Retribution"
L_PLANNER_PRIEST_1 = "Discipline"
L_PLANNER_PRIEST_2 = "Holy"
L_PLANNER_PRIEST_3 = "Shadow"
L_PLANNER_ROGUE_1 = "Assassination"
L_PLANNER_ROGUE_2 = "Combat"
L_PLANNER_ROGUE_3 = "Subtlety"
L_PLANNER_SHAMAN_1 = "Elemental"
L_PLANNER_SHAMAN_2 = "Enhancement"
L_PLANNER_SHAMAN_3 = "Restoration"
L_PLANNER_WARLOCK_1 = "Affliction"
L_PLANNER_WARLOCK_2 = "Demonology"
L_PLANNER_WARLOCK_3 = "Destruction"
L_PLANNER_WARRIOR_1 = "Arms"
L_PLANNER_WARRIOR_2 = "Fury"
L_PLANNER_WARRIOR_3 = "Protection"
-- LitePanels AFK module
L_PANELS_AFK = "You are AFK!"
L_PANELS_AFK_RCLICK = "Right-Click to hide."
L_PANELS_AFK_LCLICK = "Left-Click to go back."
-- Tooltip
L_TOOLTIP_NO_TALENT = "No Talents"
L_TOOLTIP_LOADING = "Loading..."
L_TOOLTIP_ACH_STATUS = "Your Status:"
L_TOOLTIP_ACH_COMPLETE = "Your Status: Completed on "
L_TOOLTIP_ACH_INCOMPLETE = "Your Status: Incomplete"
L_TOOLTIP_SPELL_ID = "Spell ID:"
L_TOOLTIP_ITEM_ID = "Item ID:"
L_TOOLTIP_WHO_TARGET = "Targeted By"
L_TOOLTIP_ITEM_COUNT = "Item count:"
L_TOOLTIP_INSPECT_OPEN = "Inspect Frame is open"
--loot
L_LOOT_CANNOT = "Cannot roll"
--map
-- Zone name
L_ZONE_WINTERGRASP = "Wintergrasp"
L_ZONE_TOLBARAD = "Tol Barad"
L_ZONE_TOLBARADPEN = "Tol Barad Peninsula"
L_ZONE_ARATHIBASIN = "Arathi Basin"
L_ZONE_GILNEAS = "The Battle for Gilneas"
-- ExploreMap
L_EXTRA_EXPLORED = "Explored: "
L_EXTRA_ZONEACHID = {
	-- http://www.wowhead.com/achievement=*
	-- e(X)plore achievement id, (Q)uest achievement id
	["Eastern Kingdoms"]				= {X =   42, A =    0, H =    0},
	["Kalimdor"]						= {X =   43, A =    0, H =    0},
	["Outland"]							= {X =   44, A =    0, H =    0},
	["Northrend"]						= {X =   45, A =    0, H =    0},
	["Pandaria"]						= {X = 6974, A =    0, H =    0},
	["World Map"]						= {X =  nil, A =    0, H =    0},
	-- Eastern Kingdoms
	["Arathi Highlands"]				= {X =  761, A = 4896, H = 4896},
	["Badlands"]						= {X =  765, A = 4900, H = 4900},
	["Blasted Lands"]					= {X =  766, A = 4909, H = 4909},
	["Burning Steppes"]					= {X =  775, A = 4901, H = 4901},
	["Deadwind Pass"]					= {X =  777, A =    0, H =    0},
	["Dun Morogh"]						= {X =  627, A =    0, H =    0},
	["Duskwood"]						= {X =  778, A = 4903, H =    0},
	["Eastern Plaguelands"]				= {X =  771, A = 4892, H = 4892},
	["Elwynn Forest"]					= {X =  776, A =    0, H =    0},
	["Eversong Woods"]					= {X =  859, A =    0, H =    0},
	["Ghostlands"]						= {X =  858, A =    0, H = 4908},
	["Hillsbrad Foothills"]				= {X =  772, A =    0, H = 4895},
	["Loch Modan"]						= {X =  779, A = 4899, H =    0},
	["Northern Stranglethorn"]			= {X =  781, A = 4906, H = 4906},
	["Redridge Mountains"]				= {X =  780, A = 4902, H =    0},
	["Searing Gorge"]					= {X =  774, A = 4910, H = 4910},
	["Silverpine Forest"]				= {X =  769, A =    0, H = 4894},
	["Swamp of Sorrows"]				= {X =  782, A = 4904, H = 4904},
	["The Cape of Stranglethorn"]		= {X = 4995, A = 4905, H = 4905},
	["The Hinterlands"]					= {X =  773, A = 4897, H = 4897},
	["Tirisfal Glades"]					= {X =  768, A =    0, H =    0},
	["Western Plaguelands"]				= {X =  770, A = 4893, H = 4893},
	["Westfall"]						= {X =  802, A = 4903, H =    0},
	["Wetlands"]						= {X =  841, A = 4899, H =    0},
	-- Kalimdor
	["Ashenvale"]						= {X =  845, A = 4925, H = 4976},
	["Azshara"]							= {X =  852, A =    0, H = 4927},
	["Azuremyst Isle"]					= {X =  860, A =    0, H =    0},
	["Bloodmyst Isle"]					= {X =  861, A = 4926, H = 4926},
	["Darkshore"]						= {X =  844, A = 4928, H = 4928},
	["Desolace"]						= {X =  848, A = 4930, H = 4930},
	["Durotar"]							= {X =  728, A =    0, H =    0},
	["Dustwallow Marsh"]				= {X =  850, A = 4929, H = 4978},
	["Felwood"]							= {X =  853, A = 4931, H = 4931},
	["Feralas"]							= {X =  849, A = 4932, H = 4979},
	["Moonglade"]						= {X =  855, A =    0, H =    0},
	["Mulgore"]							= {X =  736, A =    0, H =    0},
	["Northern Barrens"]				= {X =  750, A =    0, H = 4933},
	["Silithus"]						= {X =  856, A = 4934, H = 4934},
	["Southern Barrens"]				= {X = 4996, A = 4937, H = 4981},
	["Stonetalon Mountains"]			= {X =  847, A = 4936, H = 4980},
	["Tanaris"]							= {X =  851, A = 4935, H = 4935},
	["Teldrassil"]						= {X =  842, A =    0, H =    0},
	["Thousand Needles"]				= {X =  846, A = 4938, H = 4938},
	["Un'Goro Crater"]					= {X =  854, A = 4939, H = 4939},
	["Winterspring"]					= {X =  857, A = 4940, H = 4940},
	-- Outland
	["Blade's Edge Mountains"]			= {X =  865, A = 1193, H = 1193},
	["Hellfire Peninsula"]				= {X =  862, A = 1189, H = 1271},
	["Nagrand"]							= {X =  866, A = 1192, H = 1273},
	["Netherstorm"]						= {X =  843, A = 1194, H = 1194},
	["Shadowmoon Valley"]				= {X =  864, A = 1195, H = 1195},
	["Terokkar Forest"]					= {X =  867, A = 1191, H = 1272},
	["Zangarmarsh"]						= {X =  863, A = 1190, H = 1190},
	-- Northrend
	["Borean Tundra"]					= {X = 1264, A =   33, H = 1358},
	["Crystalsong Forest"]				= {X = 1457, A =    0, H =    0},
	["Dragonblight"]					= {X = 1265, A =   35, H = 1356},
	["Grizzly Hills"]					= {X = 1266, A =   37, H = 1357},
	["Howling Fjord"]					= {X = 1263, A =   34, H = 1356},
	["Icecrown"]						= {X = 1270, A =   40, H =   40},
	["Sholazar Basin"]					= {X = 1268, A =   39, H =   39},
	["The Storm Peaks"]					= {X = 1269, A =   38, H =   38},
	["Zul'Drak"]						= {X = 1267, A =   36, H =   36},
	-- Cataclysm
	["Deepholm"]						= {X = 4864, A = 4871, H = 4871},
	["Mount Hyjal"]						= {X = 4863, A = 4870, H = 4870},
	["Twilight Highlands"]				= {X = 4866, A = 4873, H = 5501},
	["Uldum"]							= {X = 4865, A = 4872, H = 4872},
	["Vashj'ir"]						= {X = 4825, A = 4869, H = 4982},
	["Tol Barad"]						= {X =    0, A = 4874, H = 4874},
	["Tol Barad Peninsula"]				= {X =    0, A = 4874, H = 4874},
	-- Pandaria
	["The Jade Forest"]					= {X = 6351, A = 6300, H = 6534},
	["Valley of the Four Winds"]		= {X = 6969, A = 6301, H = 6301},
	--["Krasarang Wilds"]					= {X = 6975, A = 6535, H = 6536},
	["Kun-Lai Summit"]					= {X = 6976, A = 6537, H = 6538},
	["Townlong Steppes"]				= {X = 6977, A = 6539, H = 6539},
	["Dread Wastes"]					= {X = 6978, A = 6540, H = 6540},
	["Vale of Eternal Blossoms"]		= {X = 6979, A =    0, H =    0},
	-- Boolean Explores
	["Isle of Quel'Danas"]				= {X =  868, A =    0, H =    0},
	["Ahn'Qiraj: The Fallen Kingdom"]	= {X =    0, A =    0, H =    0},
	["Wintergrasp"]						= {X =    0, A =    0, H =    0},
}
L_MISC_UI_OUTDATED = "Your version of SunUI is out of date. You can download the latest version from https://github.com/Coolkids/SunUI"

--11.14
L["版本号:"] = "版本号:"
L["按键绑定"] = "按键绑定"
L["经验条宽度"] = "经验条宽度"
L["经验条高度"] = "经验条高度"
L["经验条垂直模式"] = "经验条垂直模式"
L["经验条渐隐"] = "经验条渐隐"
L["全部动作条渐隐"] = "全部动作条渐隐"
L["Bar1渐隐"] = "Bar1渐隐"
L["Bar2渐隐"] = "Bar2渐隐"
L["Bar3渐隐"] = "Bar3渐隐"
L["Bar4渐隐"] = "Bar4渐隐"
L["Bar5渐隐"] = "Bar5渐隐"
L["姿态栏渐隐"] = "姿态栏渐隐"
L["宠物渐隐"] = "宠物渐隐"
L["Big1大小"] = "Big1大小"
L["Big2大小"] = "Big2大小"
L["Big3大小"] = "Big3大小"
L["Big4大小"] = "Big4大小"
L["启用脱离战斗隐藏"] = "启用脱离战斗隐藏"
L["焦点放大"] = "焦点放大"
L["施法条开关"] = "施法条开关"
L["距离监视"] = "距离监视"
L["超过40码头像渐隐"] = "超过40码头像渐隐"
L["距离监视透明度"] = "距离监视透明度"
L["超出距离头像透明度"] = "超出距离头像透明度"
L["焦点debuff过滤"] = "焦点debuff过滤"
L["只显示玩家释放的debuff"] = "只显示玩家释放的debuff"
L["头像文字渐隐"] = "头像文字渐隐"
L["非战斗非指向时隐藏"] = "非战斗非指向时隐藏"
L["血条非透明模式"] = "血条非透明模式"
L["不打钩为透明模式"] = "不打钩为透明模式"
L["小队头像"] = "小队头像"
L["开启复仇监视"] = "开启复仇监视"
L["开启仇恨监视"] = "开启仇恨监视"
L["玩家框体BUFF显示"] = "玩家框体BUFF显示"
L["副本排队助手"] = "副本排队助手"
L["隐藏暴雪团队框架"] = "隐藏暴雪团队框架"
L["快速分解"] = "快速分解"
L["自动接受复活"] = "自动接受复活"
L["AFK锁屏"] = "AFK锁屏"
L["自动交接任务"] = "自动交接任务"
L["过滤DND/AFK自动回复消息"] = "过滤DND/AFK自动回复消息"
L["聊天时间戳"] = "聊天时间戳"
L["聊天框背景"] = "聊天框背景"
L["战斗提醒"] = "战斗提醒"
L["进出战斗提醒"] = "进出战斗提醒"
L["Aurora主题"] = "Aurora主题"
L["透明模式"] = "透明模式"
L["显示未探索地区"] = "显示未探索地区"
L["启用图标模式"] = "启用图标模式"
L["职业能量条"] = "职业能量条"
L["启用职业能量条"] = "启用职业能量条"
L["渐隐"] = "渐隐"
L["生命值"] = "生命值"
L["警告提示"] = "警告提示"
L["启用警告提示"] = "启用警告提示"
L["低血量"] = "低血量"
L["开启低血量报警"] = "开启低血量报警"
L["施法通告"] = "施法通告"
L["启用施法通告"] = "启用施法通告"
L["只是通告自己施放的法术"] = "只是通告自己施放的法术"
L["启用打断通告"] = "启用打断通告"
L["启用治疗大招通告"] = "启用治疗大招通告"
L["启用误导通告"] = "启用误导通告"
L["启用保命技能通告"] = "启用保命技能通告"
L["启用给出大招通告"] = "启用给出大招通告"
L["包含天使,痛苦压制,保护等等"] = "包含天使,痛苦压制,保护等等"
L["启用复活技能通告"] = "启用复活技能通告"
L["启用团队减伤通告"] = "启用团队减伤通告"
L["启用队友施法通告"] = "启用队友施法通告"
L["背包图标"] = "背包图标"
L["银行图标"] = "银行图标"
L["图标间距"] = "图标间距"
L["背包框体宽度"] = "背包框体宽度"
L["银行框体宽度"] = "银行框体宽度"
L["自动换装"] = "自动换装"
L["启用自动换装"] = "启用自动换装"
L["选择主天赋装备"] = "选择主天赋装备"
L["选择副天赋装备"] = "选择副天赋装备"
L["战斗中无法打开控制台"] = "战斗中无法打开控制台"
L["改变参数需重载应用设置"] = "改变参数需重载应用设置"
L["结束"] = "结束"
L["下一步"] = "下一步"
L["跳过"] = "跳过"
L["安装"] = "安装"
L["打断"] = " 打断→"
L["正在施放"] = "正在施放"
L["已施放"] = "已施放"
L["复活"] = "復活→"
L["警告"] = "警告"
L["耐久过低"] = "耐久过低"
L["奖励"] = "奖励"
L["团队工具"] = "团队工具"
L["非暴雪插件总计"] = "非暴雪插件总计"
L["一共占用"] = "一共占用"
L["回收内存"] = "|cffeda55f点击回收内存"
L["目前"] = "目前"
L["收入"] = "收入"
L["花费"] = "花费"
L["亏损"] = "亏损"
L["利润"] = "利润"
L["服务器"] = "服务器"
L["总计"] = "总计"
L["隐藏小地图"] = "隐藏小地图"
L["隐藏伤害统计"] = "隐藏伤害统计"
L["暂时不兼容其他伤害统计"] = "暂时不兼容其他伤害统计"
L["欢迎使用"] = "欢迎使用"
L["个人主页"] = "个人主页"
L["您现在处于"] = "您现在处于"
L["状态"] = "状态"
L["点我解锁"] = "点我解锁"
L["星期天"] = "星期天"
L["星期一"] = "星期一"
L["星期二"] = "星期二"
L["星期三"] = "星期三"
L["星期四"] = "星期四"
L["星期五"] = "星期五"
L["星期六"] = "星期六"
L["经验条"] = "经验条"