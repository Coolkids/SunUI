-- Simplified Chinese by Diablohu/yleaf(yaroot@gmail.com)
-- http://wow.gamespot.com.cn
-- Last Update: 12/13/2008

-- yleaf (yaroot@gmail.com) 9-19-2009
-- merge traslation by bigfoot team  - yleaf 9-10-2010

if GetLocale() ~= "zhCN" then return end

DBM_CORE_NEED_SUPPORT				= "嘿, 你是否拥有良好的程序开发或语言能力? 如果是的话, DBM团队真心需要你的帮助以保持成为WOW里面最佳的首领报警插件。请访问 www.deadlybossmods.com 或发送邮件给 tandanu@deadlybossmods.com 或者 nitram@deadlybossmods.com 来加入我们的行列。"
DBM_HOW_TO_USE_MOD					= "欢迎使用DBM。在聊天框输入 /dbm 就可以打开设定面板进行设置。手动载入不同副本模块就可以根据你自己的喜好来调整每个首领的相关报警设定。"

DBM_CORE_LOAD_MOD_ERROR				= "读取%s模块时发生错误：%s"
DBM_CORE_LOAD_MOD_SUCCESS			= "成功读取%s模块！"
DBM_CORE_LOAD_GUI_ERROR				= "无法读取图形界面：%s"

DBM_CORE_COMBAT_STARTED				= "%s作战开始，祝你走运 :)"
DBM_CORE_BOSS_DOWN					= "%s被击杀！用时%s。"
DBM_CORE_BOSS_DOWN_L				= "%s被击杀！本次用时%s，上次用时%s，最快击杀用时%s。总击杀%d次。"--Localize this with new string, won't use it til it has enough language support.
DBM_CORE_BOSS_DOWN_NR				= "%s被击杀！用时%s，新的击杀纪录诞生了！（原纪录为%s）总击杀%d次。"--Localize this with new string, won't use it til it has enough language support.
DBM_CORE_COMBAT_ENDED_AT			= "%s(%s)作战结束，用时%s。"
DBM_CORE_COMBAT_ENDED_AT_LONG		= "%s（%s）作战结束，用时%s。总尝试%d次。"--This is usuable now since it's a new string and won't break locals missing this.
DBM_CORE_COMBAT_STATE_RECOVERED		= "%s已开战%s, 正在恢复计时条..."

DBM_CORE_TIMER_FORMAT_SECS			= "%d秒"
DBM_CORE_TIMER_FORMAT_MINS			= "%d分钟"
DBM_CORE_TIMER_FORMAT				= "%d分%d秒"

DBM_CORE_MIN						= "分"
DBM_CORE_MIN_FMT					= "%d 分"
DBM_CORE_SEC						= "秒"
DBM_CORE_SEC_FMT					= "%d 秒"
DBM_CORE_DEAD						= "死亡"
DBM_CORE_OK							= "确定"

DBM_CORE_GENERIC_WARNING_BERSERK	= "%s%s后狂暴"
DBM_CORE_GENERIC_TIMER_BERSERK		= "狂暴"
DBM_CORE_OPTION_TIMER_BERSERK		= "显示狂暴倒计时"
DBM_CORE_OPTION_HEALTH_FRAME		= "显示首领生命值窗口"

DBM_CORE_OPTION_CATEGORY_TIMERS		= "计时条"
DBM_CORE_OPTION_CATEGORY_WARNINGS	= "警报"
DBM_CORE_OPTION_CATEGORY_MISC		= "其它"

DBM_CORE_AUTO_RESPONDED				= "已自动回复密语。"
DBM_CORE_STATUS_WHISPER				= "%s：%s，%d/%d存活"
DBM_CORE_AUTO_RESPOND_WHISPER		= "%s正在与%s交战，（当前%s，%d/%d存活）"
DBM_CORE_WHISPER_COMBAT_END_KILL	= "%s已经击败%s!"
DBM_CORE_WHISPER_COMBAT_END_WIPE_AT	= "%s在%s(%s)的战斗中灭团了。"

DBM_CORE_VERSIONCHECK_HEADER		= "Deadly Boss Mods - 版本检测"
DBM_CORE_VERSIONCHECK_ENTRY			= "%s：%s(r%d)"
DBM_CORE_VERSIONCHECK_ENTRY_NO_DBM	= "%s：尚未安装DBM"
DBM_CORE_VERSIONCHECK_FOOTER		= "团队中有%d名成员正在使用Deadly Boss Mods"
DBM_CORE_YOUR_VERSION_OUTDATED		= "你的 Deadly Boss Mod 已经过期。请到 www.deadlybossmods.com 下载最新版本。"

DBM_CORE_UPDATEREMINDER_HEADER		= "你的Deadly Boss Mods版本已过期。\n你可以在如下地址下载到新版本%s(r%d)："
DBM_CORE_UPDATEREMINDER_FOOTER		= "Ctrl-C：复制下载地址到剪切板。"
DBM_CORE_UPDATEREMINDER_NOTAGAIN	= "发现新版本后弹出提示框"

DBM_CORE_MOVABLE_BAR				= "拖动我！"

DBM_PIZZA_SYNC_INFO					= "|Hplayer:%1$s|h[%1$s]|h向你发送了一个倒计时：'%2$s'\n|HDBM:cancel:%2$s:nil|h|cff3588ff[取消该计时]|r|h  |HDBM:ignore:%2$s:%1$s|h|cff3588ff[忽略来自%1$s的计时]|r|h"
DBM_PIZZA_CONFIRM_IGNORE			= "是否要在该次游戏连接中屏蔽来自%s的计时？"
DBM_PIZZA_ERROR_USAGE				= "命令：/dbm [broadcast] timer <时间（秒）> <文本>"

DBM_CORE_ERROR_DBMV3_LOADED			= "目前有2个版本的Deadly Boss Mods正在运行：DBMv3和DBMv4。\n单击“确定”按钮可将DBMv3关闭并重载用户界面。\n我们建议将插件目录下的DBMv3删除。"

DBM_CORE_MINIMAP_TOOLTIP_HEADER		= "Deadly Boss Mods"
DBM_CORE_MINIMAP_TOOLTIP_FOOTER		= "Shift+单击或右键点击即可移动"

DBM_CORE_RANGECHECK_HEADER			= "距离监视（%d码）"
DBM_CORE_RANGECHECK_SETRANGE		= "设置距离"
DBM_CORE_RANGECHECK_SOUNDS			= "声音"
DBM_CORE_RANGECHECK_SOUND_OPTION_1	= "当有玩家接近时播放声音提示"
DBM_CORE_RANGECHECK_SOUND_OPTION_2	= "多名玩家接近提示"
DBM_CORE_RANGECHECK_SOUND_0			= "无"
DBM_CORE_RANGECHECK_SOUND_1			= "默认声音"
DBM_CORE_RANGECHECK_SOUND_2			= "蜂鸣"
DBM_CORE_RANGECHECK_HIDE			= "隐藏"
DBM_CORE_RANGECHECK_SETRANGE_TO		= "%d码"
DBM_CORE_RANGECHECK_LOCK			= "锁定框架"
DBM_CORE_RANGECHECK_OPTION_FRAMES		= "框架"
DBM_CORE_RANGECHECK_OPTION_RADAR		= "显示雷达框架"
DBM_CORE_RANGECHECK_OPTION_TEXT			= "显示文字框架"
DBM_CORE_RANGECHECK_OPTION_BOTH			= "两者同时显示"
DBM_CORE_RANGECHECK_OPTION_SPEED	= "更新频率(需重载)"
DBM_CORE_RANGECHECK_OPTION_SLOW		= "慢速(低CPU占用)"
DBM_CORE_RANGECHECK_OPTION_AVERAGE	= "中速"
DBM_CORE_RANGECHECK_OPTION_FAST		= "快速(基本同步)"
DBM_CORE_RANGERADAR_HEADER			= "距离雷达 (%d码)"

DBM_CORE_INFOFRAME_LOCK				= "锁定框架"
DBM_CORE_INFOFRAME_HIDE				= "隐藏"
DBM_CORE_INFOFRAME_SHOW_SELF			= "总是显示你的能量"		-- Always show your own power value even if you are below the threshold

DBM_LFG_INVITE						= "地下城准备确认"

DBM_CORE_SLASHCMD_HELP				= {
	"可用命令：",
	"/dbm version：进行团队范围的DBM版本检测（也可使用：ver）",
--	"/dbm version2: 进行团队范围的DBM版本检测并密语给那些使用过期版本的玩家（也可使用：ver2）",
	"/dbm unlock：显示一个可移动的计时条，可通过对它来移动所有DBM计时条的位置（也可使用：move）",
	"/dbm timer <x> <文本>：开始一个以<文本>为名称的时间为<x>秒的倒计时",
	"/dbm broadcast timer <x> <文本>：向团队广播一个以<文本>为名称的时间为<x>秒的倒计时（需要团队领袖或助理权限）",
	"/dbm break <分钟>: 开始一个<分钟>时间的休息计时条。并向所有团队成员发送这个DBM休息计时条（需开启团队广播及助理权限）。",
	"/dbm pull <秒>: 开始一个<秒>时间的开怪计时条。 并向所有团队成员发送这个DBM开怪计时条（需开启团队广播及助理权限）。",
	"/dbm arrow: 显示DBM箭头, 输入 /dbm arrow help 获得更多说明信息。",
	"/dbm lockout: 向团队成员请求他们当前的团队副本锁定情况(或使用: lockouts, ids) (需开启团队广播及助理权限)。",
	"/dbm help：显示可用命令的说明。",
}

DBM_ERROR_NO_PERMISSION				= "无权进行该操作。"

DBM_CORE_BOSSHEALTH_HIDE_FRAME		= "隐藏"

DBM_CORE_ALLIANCE					= "联盟"
DBM_CORE_HORDE						= "部落"

DBM_CORE_UNKNOWN					= "未知"

DBM_CORE_BREAK_START				= "现在开始休息 - 你有%s分钟！"
DBM_CORE_BREAK_MIN					= "%s分钟后休息结束！"
DBM_CORE_BREAK_SEC					= "%s秒后休息结束！"
DBM_CORE_TIMER_BREAK				= "休息时间！"
DBM_CORE_ANNOUNCE_BREAK_OVER		= "休息时间已经结束"

DBM_CORE_TIMER_PULL					= "开怪倒计时"
DBM_CORE_ANNOUNCE_PULL				= "%d 秒后开怪"
DBM_CORE_ANNOUNCE_PULL_NOW			= "开怪！"

DBM_CORE_ACHIEVEMENT_TIMER_SPEED_KILL = "快速击杀"

-- Auto-generated Timer Localizations
DBM_CORE_AUTO_TIMER_TEXTS = {
	target					= "%s: %%s",
	cast					= "%s",
	active		= "%s 结束",
	fades		= "%s 消失",
	cd					= "%s 冷却",
	cdcount					= "%s 冷却 (%%d)",
	next 					= "下一次 %s",
	nextcount 					= "下一次 %s (%%d)",
	achievement 				= "%s"
}

DBM_CORE_AUTO_TIMER_OPTIONS = {
	target					= "显示$spell:%s减益计时",
	cast					= "显示$spell:%s施法计时",
	active					= "显示$spell:%s持续计时",
	fades		= "显示$spell:%s消失剩余时间计时",
	cd					= "显示$spell:%s冷却计时",
	cdcount					= "显示$spell:%s计数冷却计时",
	next					= "显示下一次$spell:%s计时",
	nextcount					= "显示下一次$spell:%s计数计时",
	achievement				= "显示成就：%s计时"
}

-- Auto-generated Warning Localizations
DBM_CORE_AUTO_ANNOUNCE_TEXTS = {
	target					= "%s: >%%s<",
	targetcount		= "%s(%%d)于>%%s<",
	spell					= "%s",
	adds		= "%s 剩余: %%d",
	cast					= "施放%s：%.1f秒",
	soon					= "即将 %s",
	prewarn					= "%2$s后 %1$s",
	phase					= "第%s阶段",
	prephase				= "第%s阶段 即将到来",
	count					= "%s (%%d)",
	stack					= "%s: >%%s< (%%d)"
}

local prewarnOption				= "显示提前警报：$spell:%s"
DBM_CORE_AUTO_ANNOUNCE_OPTIONS = {
	target					= "警报$spell:%s的目标",
	targetcount				= "警报$spell:%s的目标并计数",
	spell					= "显示警报：$spell:%s",
	adds		= "显示警报：$spell:%s的剩余数量",
	cast					= "显示施法警报：$spell:%s",
	soon					= prewarnOption,
	prewarn					= prewarnOption,
	phase					= "显示第%s阶段提示",
	prephase				= "为第%s阶段显示提前警报",
	count					= "显示计数警报：$spell:%s",
	stack					= "警报$spell:%s的堆叠层数"
}

-- Auto-generated Special Warning Localizations
DBM_CORE_AUTO_SPEC_WARN_OPTIONS = {
	spell					= "显示特别警报：$spell:%s",
	dispel					= "需要驱散/偷取$spell:%s时显示特别警报",
	interrupt				= "需要打断$spell:%s时显示特别警报",
	you					= "当你中了$spell:%s时显示特别警报",
	target					= "当有人中了$spell:%s时显示特别警报",
	close					= "当你附近有人中了$spell:%s时显示特别警报",
	move					= "当你中了$spell:%s需要躲开时显示特别警报",
	run					= "当你中了$spell:%s需要跑开时显示特别警报",
	cast					= "为$spell:%s正在施法显示特别警报",
	stack					= "当叠加了>=%d层$spell:%s时显示特别警报",
	switch		= "为$spell:%s需要切换目标显示特别警报"
}

DBM_CORE_AUTO_SPEC_WARN_TEXTS = {
	spell					= "%s!",
	dispel					= "%%s中了%s - 快驱散",
	interrupt				= "%s - 快打断",
	you					= "你中了%s",
	target					= "%%s中了%s",
	close					= "你附近的%%s中了%s",
	move					= "%s - 快躲开",
	run					= "%s - 快跑",
	cast					= "%s - 停止施法",
	stack					= "%s (%%d)",
	switch = "%s - 切换目标"
}


DBM_CORE_AUTO_ICONS_OPTION_TEXT			= "设定标记给$spell:%s的目标"
DBM_CORE_AUTO_SOUND_OPTION_TEXT			= "为$spell:%s播放“快跑啊！”警报音效"
DBM_CORE_AUTO_COUNTDOWN_OPTION_TEXT	= "为$spell:%s施放前播放倒计时音效"
DBM_CORE_AUTO_COUNTOUT_OPTION_TEXT	= "为$spell:%s持续结束前播放倒计时音效"
DBM_CORE_AUTO_YELL_OPTION_TEXT			= "当你中了$spell:%s时大喊"
DBM_CORE_AUTO_YELL_ANNOUNCE_TEXT		= "我中了%s！"--Verify (%s is spellname)


-- New special warnings
DBM_CORE_MOVE_SPECIAL_WARNING_BAR		= "可拖动的特别警报"
DBM_CORE_MOVE_SPECIAL_WARNING_TEXT		= "特别警报"


DBM_CORE_RANGE_CHECK_ZONE_UNSUPPORTED		= "此区域不支持%d码的距离检查。\n已支持的距离有10，11，15及28码。"

DBM_ARROW_MOVABLE				= "可移动箭头"
DBM_ARROW_NO_RAIDGROUP				= "此功能仅适用于副本中的团队。"
DBM_ARROW_ERROR_USAGE	= {
	"DBM-Arrow 可用命令：",
	"/dbm arrow <x> <y>  新建一个箭头在指定位置(0 < x/y < 100)",
	"/dbm arrow <玩家>  新建一个箭头并指向你队伍或团队中特定的玩家",
	"/dbm arrow hide  隐藏箭头",
	"/dbm arrow move  移动或锁定箭头",
}

DBM_SPEED_KILL_TIMER_TEXT			= "记录击杀"
DBM_SPEED_KILL_TIMER_OPTION			= "显示一个计时条来挑战你上次的最快击杀"


DBM_REQ_INSTANCE_ID_PERMISSION		= "%s想要查看你的副本ID和进度锁定情况。\n你想发送该信息给%s吗? 在你的当前进程（除非你下线）他可以一直查阅该信息。"
DBM_ERROR_NO_RAID					= "你必须在一个团队中才可以使用这个功能。"
DBM_INSTANCE_INFO_REQUESTED			= "查看团队成员的副本锁定情况。\n请注意，队员们将会被询问是否愿意发送数据给你，因此可能需要等待一分钟才能获得全部的回复。"
DBM_INSTANCE_INFO_STATUS_UPDATE		= "从%d个玩家获得反馈，来自%d个DBM用户：%d人发送了数据, %d人拒绝回传数据。等待结果还需要%d秒..."
DBM_INSTANCE_INFO_ALL_RESPONSES		= "已获得全部团队成员的回传数据"
DBM_INSTANCE_INFO_DETAIL_DEBUG		= "发送者: %s 结果类型: %s 副本名称: %s 副本ID: %s 难度: %d 团队人数: %d 进度: %s"
DBM_INSTANCE_INFO_DETAIL_HEADER		= "%s (%d), 难度 %d:"
DBM_INSTANCE_INFO_DETAIL_INSTANCE	= "    ID %s, 进度 %d: %s"
DBM_INSTANCE_INFO_STATS_DENIED		= "拒绝回传数据: %s"
DBM_INSTANCE_INFO_STATS_AWAY		= "暂离: %s"
DBM_INSTANCE_INFO_STATS_NO_RESPONSE	= "没有安装最新版本的DBM: %s"
DBM_INSTANCE_INFO_RESULTS			= "副本ID扫描结果。注意如果团队中有不同语言版本的魔兽客户端，那么同一副本可能会出现不止一次。"
DBM_INSTANCE_INFO_SHOW_RESULTS		= "已回复的玩家: %s\n|HDBM:showRaidIdResults|h|cff3588ff[现在显示结果]|r|h"
