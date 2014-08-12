local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("SunUI", "zhTW")
if not L then return end
--core 区域文字
do
	L["一般"] = true
	L["设置"] = true
	L["启用"] = true
	L["SunUI"] = "|cff3f7bf5SunUI|r"
	L["布局选择"] = true
	L["技能监视"] = true
	L["请选择一个布局开始使用"] = true
	L["默认"] = true
	L["设置完成"] = true
	L["伤害输出"] = true
	L["治疗"] = true
	L["模式"] = true
	L["锁定"] = true
	L["版本"] = true
	L["UI缩放"] = true
	L["界面风格"] = true
	L["阴影"] = true
	L["1像素"] = true
	L["解锁锚点"] = true
	L["选择布局"] = true
	L["显示教程"] = true
	L["字体材质"] = true
	L["字体"] = true
	L["一般字体"] = true
	L["字体大小"] = true
	L["伤害字体"] = true
	L["像素字体"] = true
	L["冷却字体"] = true
	L["材质"] = true
	L["一般材质"] = true
	L["空白材质"] = true
	L["玻璃材质"] = true
	L["阴影边框"] = true
	L["颜色"] = true
	L["边框颜色"] = true
	L["背景颜色"] = true
	L["透明框架背景颜色"] = true
	L["恢复颜色"] = true
	L["改变参数需重载应用设置"] = true
	L["是否重置所有锚点"] = true
	L["插件美化"] = true
	L["锚点已解锁，拖动锚点移动位置，完成后点击锁定按钮。"] = true
	L["ALL"] = "全部"
	L["GENERAL"] = "其他"
	L["UNITFRAMES"] = "头像"
	L["MINITOOLS"] = "小工具"
	L["ACTIONBARS"] = "动作条"
	L["ARENA"] = true
	L["成就锚点"] = true
end
--安装
do
	L["安装完毕"] = "安装完毕"
	L["完毕信息"] ="现在已经安装完毕.\n\n请点击结束重载界面完成最后安装.\n\nEnjoy!"
	L["安装DBM设置"] = "3. 安装DBM设置"
	L["安装DBM设置信息"] = "如果你没有安装DBM这一步将不会生效,请确定您安装了DBM\n\n即将安装DBM设置.\n\n当然您也可以输入/dbm进行设置."
	L["聊天框设置"] = "2. 聊天框设置"
	L["聊天框设置信息"] = "将按照插件默认设置配置聊天框,详细微调请鼠标右点聊天标签"
	L["核心数据"] = "1. 载入SunUI核心数据"
	L["核心数据信息"] = "这一步将载入SunUI默认参数,请不要跳过\n\n更多详细设置在SunUI控制台内\n\n打开控制台方法:1.Esc>SunUI 2.输入命令/sunui 3.聊天框右侧上部渐隐按钮集合内点击S按钮(非中文语言系客户端没有此功能)"
	L["教程6名字"] = "6. 结束"
	L["教程6信息"] = "教程结束.更多详细设置请见/sunui 如果遇到灵异问题或者使用Bug 请到http://bbs.ngacn.cc/read.php?tid=4743077&_fp=1&_ff=200 回复记得带上BUG截图 亲~~"
	L["教程5名字"] = "5. 命令"
	L["教程5信息"] = "一些常用命令 \n/sunui 控制台 全局解锁什么的 ps:绝大部分设置需要重载生效 \n/align 在屏幕上显示网格,方便安排布局\n/hb 绑定动作条快捷键\n/rl 重载UI\n/wf 解锁任务追踪框体\n/vs 载具移动\n/pdb 插件全商业技能\n/rw2 buff监控设置\n/autoset 自动设置UI缩放\n/setdbm 重新设置DBM\n/setsunui重新打开安装向导"
	L["教程4名字"] = "4. 您应该知道的东西"
	L["教程4信息"] = "SunUI 95%的设置都是可以通过图形界面来完成的, 大多数的设置在/sunui中 少部分的设置在ESC>界面中.\n经验条在动作条下面..鼠标指向显示"
	L["教程3名字"] = "3. 特性"
	L["教程3信息"] = "SunUI是重新设计过的暴雪用户界面.具有大量人性化设计.您可以在各个细节中体验到"
	L["教程2名字"] = "2.单位框架"
	L["教程2信息"] = "SunUI的头像部分使用mono的oUF_Mono为模版进行改进而来.增加了更多额外的设置.自由度很高,你可以使用/sunui ->头像设置 进行更多的个性化设置. \n而团队框架则没有选用oUF部分,而是使用了暴雪内建团队框架的改良版,它比oUF的团队框架有更低的内存与CPU占用.更适合老爷机器."
	L["教程1名字"] = "1. 概述"
	L["教程1信息"] = "欢迎使用SunUI\n SunUI是一个类Tukui但是又不是Tukui的整合插件.它界面整洁清晰,功能齐全,整体看起来华丽而不臃肿.内存CPU占用小即使是老爷机也能跑.适用于宽频界面."
	L["欢迎"] = "欢迎"
	L["欢迎信息"] = "欢迎您使用SunUI \n\n\n\n几个小步骤将引导你安装SunUI. \n\n\n为了达到最佳的使用效果,请不要随意跳过这个安装程序\n\n\n\n\n如果需要再次安装 请输入命令/sunui"
	L["教程"] = "教程"
	L["安装SunUI"] = "安装SunUI"
	L["下一步"] = true
	L["结束"] = true
	L["安装"] = true
	L["跳过"] = true
end

	--actionbar区域
do
	L["动作条"] = true
	L["bar1布局"] = true
	L["bar2布局"] = true
	L["bar3布局"] = true
	L["bar4布局"] = true
	L["bar5布局"] = true
	L["请选择布局"] = true
	L["12x1布局"] = true
	L["6x2布局"] = true
	L["正常布局"] = true
	L["4方块布局"] = true
	L["隐藏快捷键显示"] = true
	L["隐藏宏名称显示"] = true
	L["冷却闪光"] = true
	L["按键绑定"] = true
	L["动作条按钮大小"] = true
	L["动作条间距大小"] = true
	L["动作条字体大小"] = true
	L["宏名字字体大小"] = true
	L["动作条缩放大小"] = true
	L["特殊按钮缩放大小"] = true
	L["宠物条缩放大小"] = true
	L["姿态栏缩放大小"] = true
	L["冷却闪光图标大小"] = true
	L["CD时透明度"] = true
	L["全部动作条渐隐"] = true
	L["Bar1渐隐"] = true
	L["Bar2渐隐"] = true
	L["Bar3渐隐"] = true
	L["Bar4渐隐"] = true
	L["Bar5渐隐"] = true
	L["姿态栏渐隐"] = true
	L["宠物渐隐"] = true
	L["Big1大小"] = true
	L["Big2大小"] = true
	L["Big3大小"] = true
	L["Big4大小"] = true
	L["主动作条锚点"] = true
	L["左下动作条锚点"] = true
	L["右下动作条锚点"] = true
	L["大动作条锚点"] = true
	L["右1动作条锚点"] = true
	L["右2动作条锚点"] = true
	L["特殊动作条锚点"] = true
	L["宠物动作条锚点"] = true
	L["姿态栏锚点"] = true
	L["冷却闪光锚点"] = true
end
--背包
do
	L["背包"] = true
	L["背包图标"] = true
	L["银行图标"] = true
	L["图标间距"] = true
	L["背包框体宽度"] = true
	L["银行框体宽度"] = true
	L["整理背包"] = true
	L["左键逆向,右键正向"] = true
end
--buff
do
	L["增益美化"] = true
	L["图标大小"] = true
	L["每行图标数"] = true
	L["BUFF增长方向"] = true
	L["DEBUFF增长方向"] = true
	L["从右向左"] = true
	L["从左向右"] = true
	L["Buff锚点"] = true
	L["Debuff锚点"] = true
end
--buttons
do
	L["按钮集合"] = true
	L["大脚世界频道"] = true
	L["离开大脚频道"] = true
	L["加入大脚世界频道"] = true
	L["大脚世界频道"] = "大腳世界頻道"
	L["开启"] = true
	L["关闭"] = true
	L["大脚世界频道开关"] = true
	L["点击进入或者离开"] = true
	L["您现在大脚世界频道处于"] = true
	L["状态"] = true
	L["表情"] = true
end
--chat
do
	L["双击聊天标签"] = true
	L["来复制聊天信息"] = true
	L["屏蔽DND消息"] = true
	L["时间戳"] = true
	L["聊天框背景"] = true
	L["聊天美化"] = true
	L["输入框边框染色"] = true
	L["频道栏"] = true
	L["其他按钮"] = true
end

do
	L["聊天过滤"] = true
end
--loot
do
	L["拾取美化"] = true
	L["Roll锚点"] = true
end
--MAP
do
	L["地图美化"] = true
	L["小地图"] = true
end
--姓名板
do
	L["姓名板美化"] = true
	L["姓名板字体大小"] = true
	L["姓名板血条高度"] = true
	L["姓名板血条宽度"] = true
	L["启用debuff显示"] = true
	L["图标大小"] = true
	L["显示职业图标"] = true
	L["显示仇恨"] = true
	L["显示生命值"] = true
	L["显示法术名"] = true
	L["生命值显示模式"] = true
	L["只显示数值"] = true
	L["只显示百分比"] = true
	L["都显示"] = true
end
--powerbar
do
	L["PowerBar"] = true
	L["启用职业能量条"] = true
	L["框体宽度"] = true
	L["框体高度"] = true
	L["渐隐"] = true
	L["生命值"] = true
	L["生命值用百分比替代"] = true
	L["魔法值用百分比替代"] = true
	L["不显示文字"] = true
end

--任务
do
	L["任务增强"] = true
	L["自动交接任务"] = true
end
--鼠标提示
do
	L["鼠标提示"] = true
	L["鼠标提示锚点"] = true
	L["提示框体跟随鼠标"] = true
	L["进入战斗自动隐藏"] = true
	L["缩放大小"] = true
	L["隐藏头衔"] = true
	L["物品ID"] = true
	L["法术ID"] = true
end
--小工具
do
	L["小工具"] = true
	L["启用出售垃圾"] = true
	L["启用自动修理"] = true
	L["启用系统红字屏蔽"] = true
	L["隐藏团队警告"] = true
	L["快速分解"] = true
	L["自动接受复活"] = true
	L["低血量报警"] = true
	L["AFK界面"] = true
	L["正义/勇气点检查"] = true
end
--通知
do
	L["通知"] = true
	L["开启声音提示"] = true
end
--头像
do
	L["头像美化"] = true
	L["显示模式"] = true
	L["治疗模式"] = true
	L["DPS/Tank模式"] = true
	L["职业着色"] = true
	L["显示吸收"] = true
	L["独立施法条"] = true
	L["布衣职业施法条"] = true
	L["仅仅布衣职业使用独立施法条"] = true
	L["显示目标的目标"] = true
	L["显示竞技场"] = true
	L["特殊boss能量条高度"] = true
	L["能量条高度"] = true
	L["玩家高度"] = true
	L["玩家宽度"] = true
	L["目标高度"] = true
	L["目标宽度"] = true
	L["目标的目标高度"] = true
	L["目标的目标宽度"] = true
	L["焦点高度"] = true
	L["焦点宽度"] = true
	L["焦点目标高度"] = true
	L["焦点目标宽度"] = true
	L["宠物高度"] = true
	L["宠物宽度"] = true
	L["boss高度"] = true
	L["boss宽度"] = true
	L["竞技场高度"] = true
	L["竞技场宽度"] = true
	L["玩家debuff数量"] = true
	L["目标debuff数量"] = true
	L["目标buff数量"] = true
	L["boss buff数量"] = true
	L["竞技场buff数量"] = true
	L["焦点debuff数量"] = true
	L["玩家施法条"] = true
	L["玩家"] = true
	L["目标"] = true
	L["焦点"] = true
	L["宠物"] = true
	L["目标的目标"] = true
	L["Boss"] = true
	L["竞技场"] = true
	L["玩家debuff大小"] = true
	L["目标状态大小"] = true
	L["焦点debuff大小"] = true
	L["boss buff大小"] = true
	L["竞技场buff大小"] = true
	L["头像自动隐藏"] = true
	L["隐藏暴雪小队/团队"] = true
	L["施法条高度"] = true
	L["施法条宽度"] = true
end
--afk
do
	L["欢迎使用"] = true
	L["您现在处于"] = true
	L["状态"] = true
	L["点我解锁"] = true
end
--信息条
do
	L["您没有击杀任何野外boss"] = true
	L["信息条"] = true
	L["启动信息条1"] = true
	L["顶部背景"] = true
	L["延时"] = true
	L["内存"] = true
	L["金币"] = true
	L["启动信息条2"] = true
	L["底部背景"] = true
	L["时钟"] = true
	L["耐久"] = true
	L["地城"] = true
	L["天赋"] = true
	L["信息条1"] = true
	L["信息条2"] = true
	L["目前"] = true
	L["收入"] = true
	L["花费"] = true
	L["亏损"] = true
	L["服务器"] = true
	L["总计"] = true
	L["延迟"] = true
	L["本地延迟"] = true
	L["世界延迟"] = true
	L["带宽"] = true
	L["下载"] = true
	L["内存"] = true
	L["总CPU使用"] = true
	L["总内存使用"] = true
	L["共释放内存"] = true
end

do
	L["缺失Buff"] = true
	L["Buff提醒"] = true
	L["显示团队增益缺失提醒"] = true
	L["只在队伍中显示"] = true
	L["团队增益图标排列方式"] = true
	L["团队增益图标排列方式"] = true
	L["横排"] = true
	L["竖排"] = true
	L["显示职业增益缺失提醒"] = true
	L["职业增益图标大小"] = true
	L["Buff提醒"] = true
	L["缺失Buff"] = true
end
--施法通知
do
	L["施法通告"] = true
	L["只是通告自己施放的法术"] = true
	L["启用打断通告"] = true
	L["启用治疗大招通告"] = true
	L["启用误导通告"] = true
	L["启用保命技能通告"] = true
	L["启用给出大招通告"] = true
	L["包含天使,痛苦压制,保护等等"] = true
	L["启用复活技能通告"] = true
	L["启用团队减伤通告"] = true
	L["正在施放"] = true
	L["已施放"] = true
	L["复活"] = true
end
--自动换装
do
	L["自动换装"] = true
	L["选择主天赋装备"] = true
	L["选择副天赋装备"] = true
end
--职业助手
do
	L["斩杀提示"] = true
	L["职业助手"] = true
	L["图标大小"] = true
	L["宠物计时"] = true
end
do
	L["世界地图"] = true
end

do
	L["内置CD监视"] = true
	L["启用图标模式"] = true
	L["计时条增长方向"] = true
	L["向下"] = true
	L["向上"] = true
	
	L["团队CD监视"] = true
	L["换行数目"] = true
	L["换行方向"] = true
	L["向左"] = true
	L["向右"] = true
	L["上限"] = true
end