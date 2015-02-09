local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local area = GetLocale()
local L
if (area ~= "zhTW") and (area ~= "zhCN") then
	L = AceLocale:NewLocale("SunUI", area)
end

if not L then return end

--core area type
do
	L["一般"] = "General"
	L["设置"] = "Set"
	L["启用"] = "Enable"
	L["SunUI"] = "|cff3f7bf5SunUI|r"
	L["布局选择"] = "Select Layout"
	L["技能监视"] = "Skills Monitor"
	L["请选择一个布局开始使用"] = "Please Select A Layout"
	L["默认"] = "Default"
	L["设置完成"] = "Setup Complete"
	L["伤害输出"] = "Damage Output"
	L["治疗"] = "Treatment"
	L["模式"] = "Pattern"
	L["锁定"] = "Lock"
	L["版本"] = "Version"
	L["UI缩放"] = "UIScale"
	L["界面风格"] = "Interface Style"
	L["阴影"] = "Shadow"
	L["1像素"] = "1 Pixel"
	L["解锁锚点"] = "Unlock Anchor"
	L["选择布局"] = "Select Layout"
	L["显示教程"] = "Display Guide"
	L["字体材质"] = "Fonts"
	L["字体"] = "Fonts"
	L["一般字体"] = "Generic Font"
	L["字体大小"] = "Font Size"
	L["字体描边"] = "Font Shadow"
	L["伤害字体"] = "Damage Font"
	L["像素字体"] = "Pixel Font"
	L["冷却字体"] = "Cooldown Font"
	L["材质"] = "Textures"
	L["一般材质"] = "General"
	L["空白材质"] = "Blank"
	L["玻璃材质"] = "Transparent"
	L["阴影边框"] = "Border Shadow"
	L["颜色"] = "Color"
	L["边框颜色"] = "Border Color"
	L["背景颜色"] = "Background Color"
	L["透明框架背景颜色"] = "Frame Background"
	L["恢复颜色"] = "Restore Colors"
	L["改变参数需重载应用设置"] = "Reload UI"
	L["是否重置所有锚点"] = "Reset Anchor"
	L["插件美化"] = "Beautification Plug"
	L["锚点已解锁，拖动锚点移动位置，完成后点击锁定按钮。"] = "Unlock Anchor"
	L["ALL"] = true
	L["GENERAL"] = true
	L["UNITFRAMES"] = true
	L["MINITOOLS"] = true
	L["ACTIONBARS"] = true
	L["FILGER"] = true
	L["ARENA"] = true
	L["成就锚点"] = "Achievement anchor"
end
--安装
do
	L["安装完毕"] = "Installed"
	L["完毕信息"] ="SunUI has now been installed! \n \n Please click Done.\n \n Enjoy!"
	L["安装DBM设置"] = "3. Install DBM Settings"
	L["安装DBM设置信息"] = "If you do not have DBM, installation will not proceed. Make sure to install the DBM. You can also use /dbm to change settings."
	L["聊天框设置"] = "2. Chat"
	L["聊天框设置信息"] = "Right click on the chat tab for additional settings."
	L["核心数据"] = "1. Load SunUI core data."
	L["核心数据信息"] = "This step will load the SunUI default settings. Please do not skip."
	L["教程6名字"] = "6. End"
	L["教程6信息"] = "tutorial. For more detailed settings, see /sunui Please also check http://bbs.ngacn.cc/read.php?tid=4743077&_fp=1&_ff"
	L["教程5名字"] = "5. Commands"
	L["教程5信息"] = "Some common console commands \n /sunui all the available settings \n /align display a grid on the screen \n /hb keybinding \n /rl reload UI \n /wf unlock watchframe \n /vs carrier mobile \ whole business skills \n /rw2 buffsettings \n /pdb plugin \n /autoset automatic UI scaling \n /setdbm reset DBM \n /setsunui reopen the installation wizard "
	L["教程4名字"] = "4. Things you should know"
	L["教程4信息"] = "SunUI 95% of the settings are done through a graphical interface which can be accessed with the console command /sunui. \n experience bar in the action bar point your mouse to display the following .. "
	L["教程3名字"] = "3. Characteristics"
	L["教程3信息"] = "SunUI is a redesigned Blizzard user interface with a large number of user-friendly settings."
	L["教程2名字"] = "2. Unitframes"
	L["教程2信息"] = "SunUI unitframes uses oUF_Mono as a template but provides more customizations via /sunui \n Unitframes use the oUF framework which uses lower memory and CPU usage. "
	L["教程1名字"] = "1. Overview"
	L["教程1信息"] = "Welcome to SunUI. \n SunUI is built from Tukui but is not a Tukui plug-in. It has a clean and clear interface but has complete functions. The overall look is gorgeous but not bloated. It has low CPU utilization. "
	L["欢迎"] = "Welcome"
	L["欢迎信息"] = "Thank you for using SunUI \n \n \n \n These steps will guide you in installing SunUI. \n \n \n In order to achieve the best results, please do not skip the installation program. \n \n \n \n \n If you need to reinstall, enter the command /sunui"
	L["教程"] = "Tutorial"
	L["安装SunUI"] = "Install SunUI"
	L["下一步"] = "Next"
	L["结束"] = "Done"
	L["安装"] = "Install"
	L["跳过"] = "Skip"
	L["欢迎使用SunUI"] = "Welcome to SunUI"
	L["QQ群"] = ""
	L["更新地址"] = "update URL https://github.com/Coolkids/SunUI"
end

	--actionbar area
do
	L["动作条"] = "ActionBars"
	L["bar1布局"] = "Bar1 Layout"
	L["bar2布局"] = "Bar2 Layout"
	L["bar3布局"] = "Bar3 Layout"
	L["bar4布局"] = "Bar4 Layout"
	L["bar5布局"] = "Bar5 Layout"
	L["请选择布局"] = "Select Layout"
	L["12x1布局"] = "12x1 Layout"
	L["6x2布局"] = "6x2 Layout"
	L["正常布局"] = "Normal Distribution"
	L["4方块布局"] = "4 Square Layout"
	L["隐藏快捷键显示"] = "Hide Shortcut Show"
	L["隐藏宏名称显示"] = "Hide Macro Name Display"
	L["冷却闪光"] = "Cooldown Flash"
	L["按键绑定"] = "Key Bindings"
	L["动作条按钮大小"] = "Action Bar Button Size"
	L["动作条间距大小"] = "Action Bar Spacing size"
	L["动作条字体大小"] = "Action Bar Font Size"
	L["宏名字字体大小"] = "Macro Name Font Size"
	L["动作条缩放大小"] = "Action Bar Sizing"
	L["特殊按钮缩放大小"] = "Special Button Sizing"
	L["宠物条缩放大小"] = "Pet Bar Sizing"
	L["姿态栏缩放大小"] = "Aggro Column Sizing"
	L["冷却闪光图标大小"] = "Cooldown Flash Icon Size"
	L["CD时透明度"] = "CD transparency"
	L["全部动作条渐隐"] = "Fade all Action Bars"
	L["Bar1渐隐"] = "Bar1 Fade"
	L["Bar2渐隐"] = "Bar2 Fade"
	L["Bar3渐隐"] = "Bar3 Fade"
	L["Bar4渐隐"] = "Bar4 Fade"
	L["Bar5渐隐"] = "Bar5 Fade"
	L["姿态栏渐隐"] = "Aggro Bar Fade"
	L["宠物渐隐"] = "Pet Fade"
	L["Big1大小"] = "Big1 size"
	L["Big2大小"] = "Big2 size"
	L["Big3大小"] = "Big3 size"
	L["Big4大小"] = "Big4 size"
	L["主动作条锚点"] = "Initiative as a bar Anchor"
	L["左下动作条锚点"] = "Left Action Bar Anchor"
	L["右下动作条锚点"] = "Right Action Bar Anchor"
	L["大动作条锚点"] = "Big Action Bar Anchor"
	L["右1动作条锚点"] = "Right Action Bar Anchor"
	L["右2动作条锚点"] = "Right Action Bar 2 Anchor"
	L["特殊动作条锚点"] = "Special Action Bar Anchor"
	L["宠物动作条锚点"] = "Pet Action Bar Anchor"
	L["姿态栏锚点"] = "Aggro Bar Anchor"
	L["冷却闪光锚点"] = "Cooldown Flash Anchor"
end
--Bags
do
	L["背包"] = "Bags"
	L["背包图标"] = "Bag Icon"
	L["银行图标"] = "Bank Icon"
	L["图标间距"] = "Icon Spacing"
	L["背包框体宽度"] = "Bag Frame Width"
	L["银行框体宽度"] = "Bank Frame width"
	L["整理背包"] = "Sort Bags"
	L["左键逆向,右键正向"] = "Left Reverse, Right forward"
end
--buff
do
	L["增益美化"] = "Buffs and Debuffs"
	L["图标大小"] = "Icon Size"
	L["每行图标数"] = "Icons per row"
	L["BUFF增长方向"] = "BUFF Growth Direction"
	L["DEBUFF增长方向"] = "DEBUFF Growth Direction"
	L["从右向左"] = "Right to Left"
	L["从左向右"] = "Left to Right"
	L["Buff锚点"] = "Buff anchor"
	L["Debuff锚点"] = "Debuff anchor"
end
--buttons
do
	L["按钮集合"] = "Button to Set"
	L["大脚世界频道"] = "Bigfoot World Channel"
	L["离开大脚频道"] = "Leave Bigfoot World Channel"
	L["加入大脚世界频道"] = "Join Bigfoot World Channel"
	L["大脚世界频道"] = "Bigfoot World Channel"
	L["开启"] = "Open"
	L["关闭"] = "Close"
	L["大脚世界频道开关"] = "Bigfoot World Channel switch"
	L["点击进入或者离开"] = "Click to enter or leave"
	L["您现在大脚世界频道处于"] = "You are now in the Bigfoot World Channel"
	L["状态"] = "Status"
	L["表情"] = "Face"
end
--chat
do
	L["双击聊天标签"] = "Double-click on the Chat tab"
	L["来复制聊天信息"] = "to copy the chat messages"
	L["屏蔽DND消息"] = "Hide DND Message"
	L["时间戳"] = "Timestamp"
	L["聊天框背景"] = "Chat Box Background"
	L["聊天美化"] = "Skin Chat"
	L["输入框边框染色"] = "Input Box Border Color"
	L["频道栏"] = "Channel Bar"
	L["其他按钮"] = "Other Buttons"
end
--Nameplates
do
	L["姓名板美化"] = "Skin Nameplates"
	L["姓名板字体大小"] = "Nameplate Font Size"
	L["姓名板血条高度"] = "Nameplate Height"
	L["姓名板血条宽度"] = "Nameplate Width"
	L["启用debuff显示"] = "Enable Debuff Display"
	L["图标大小"] = "Icon Size"
	L["显示职业图标"] = "Show Role Icon"
	L["显示仇恨"] = "Show Aggro"
	L["显示生命值"] = "Show Health Value"
	L["显示法术名"] = "Show Spell Name"
	L["生命值显示模式"] = "Show Health Color"
	L["只显示数值"] = "Show Value Only"
	L["只显示百分比"] = "Show percentage Only"
	L["都显示"] = "Show"
end
do
	L["聊天过滤"] = "Chat Filter"
end
--loot
do
	L["拾取美化"] = "Skin"
	L["Roll锚点"] = "Roll anchor"
end
--MAP
do
	L["地图美化"] = "Skin Map"
	L["小地图"] = "Small Map"
end

--powerbar
do
	L["PowerBar"] = true
	L["启用职业能量条"] = "Enable Energy bar"
	L["框体宽度"] = "Frame Width"
	L["框体高度"] = "Frame Height"
	L["渐隐"] = "Fade"
	L["生命值"] = "Value"
	L["生命值用百分比替代"] = "Percentage"
	L["魔法值用百分比替代"] = "Mana Percentage"
	L["不显示文字"] = "Hide Text"
end

--Task
do
	L["任务增强"] = "Mission Enhancement"
	L["自动交接任务"] = "Automatic Transfer Task"
	L["原始任务窗口"] = "Original Task Window"
end
--Tooltip
do
	L["鼠标提示"] = "Tooltip"
	L["鼠标提示锚点"] = "Anchor to Pointer"
	L["提示框体跟随鼠标"] = "Anchor to Pointer"
	L["进入战斗自动隐藏"] = "Combat Auto-Hide"
	L["缩放大小"] = "Sizing"
	L["隐藏头衔"] = "Hide Title"
	L["物品ID"] = "Item ID"
	L["法术ID"] = "Spell ID"
end
--Misc
do
	L["小工具"] = "Misc"
	L["启用出售垃圾"] = "Enable Sell Junk"
	L["启用自动修理"] = "Enable Auto Repair"
	L["启用系统红字屏蔽"] = "Enabling System Red Shield"
	L["隐藏团队警告"] = "Hide Party Warning"
	L["快速分解"] = "Auto Release"
	L["自动接受复活"] = "Auto Accept Resurrection"
	L["低血量报警"] = "Low Health Alarm"
	L["AFK界面"] = "AFK Interface"
	L["正义/勇气点检查"] = "JP/VP in Tooltip"
end
--Notification
do
	L["通知"] = "Notification"
	L["开启声音提示"] = "Turn On Voice Prompts"
end
--Nameplates
do
	L["头像美化"] = "Nameplates"
	L["显示模式"] = "Display Mode"
	L["治疗模式"] = "Caster Mode"
	L["DPS/Tank模式"] = "DPS/Tank Mode"
	L["职业着色"] = "Class Color"
	L["显示吸收"] = "Show Absorb"
	L["独立施法条"] = "Normal Cast Bar"
	L["布衣职业施法条"] = "Class Colored Cast Bar"
	L["仅仅布衣职业使用独立施法条"] = "Separate Class Cast Bar"
	L["显示目标的目标"] = "Display Target"
	L["显示竞技场"] = "Display Arena"
	L["特殊boss能量条高度"] = "Boss Special Energy Bar Height"
	L["能量条高度"] = "Energy Bar Height"
	L["玩家高度"] = "Player Height"
	L["玩家宽度"] = "Player Width"
	L["目标高度"] = "Target Height"
	L["目标宽度"] = "Target Width"
	L["目标的目标高度"] = "Target Target Height"
	L["目标的目标宽度"] = "Target Target Width"
	L["焦点高度"] = "Focus Height"
	L["焦点宽度"] = "Focus Width"
	L["焦点目标高度"] = "Focus Target Height"
	L["焦点目标宽度"] = "Focus Target Width"
	L["宠物高度"] = "Pet Height"
	L["宠物宽度"] = "Pet Width"
	L["boss高度"] = "Boss Height"
	L["boss宽度"] = "Boss Width"
	L["竞技场高度"] = "Arena Height"
	L["竞技场宽度"] = "Arena Width"
	L["玩家debuff数量"] = "Player Debuffs"
	L["目标debuff数量"] = "Target Debuffs"
	L["目标buff数量"] = "Boss Buffs"
	L["boss buff数量"] = "Arena Buffs"
	L["竞技场buff数量"] = "Focus Buffs"
	L["焦点debuff数量"] = "Focus Debuffs"
	L["玩家施法条"] = "Player Castbar"
	L["玩家"] = "Player"
	L["目标"] = "Target"
	L["焦点"] = "Focus"
	L["宠物"] = "Pet"
	L["目标的目标"] = "Target Goals"
	L["Boss"] = true
	L["竞技场"] = "Arena"
	L["玩家debuff大小"] = "Player Debuff Size"
	L["目标状态大小"] = "Target State Size"
	L["焦点debuff大小"] = "Focus Debuff size"
	L["boss buff大小"] = "Boss Buff Size"
	L["竞技场buff大小"] = "Arena Buff Size"
	L["头像自动隐藏"] = "Nameplate Auto Hide"
	L["隐藏暴雪小队/团队"] = "Hide Blizzard Party"
	L["施法条高度"] = "Castbar Height"
	L["施法条宽度"] = "Castbar Width"
end
--afk
do
	L["欢迎使用"] = "Welcome to "
	L["您现在处于"] = "You are now in "
	L["状态"] = " status."
	L["点我解锁"] = "Click To Unlock"
end
--Information Section
do
	L["您没有击杀任何野外boss"] = "You do not have to kill any world boss."
	L["信息条"] = "Info Bar"
	L["启动信息条1"] = "Top Info"
	L["顶部背景"] = "Top Background"
	L["延时"] = "Delay"
	L["内存"] = "Memory"
	L["金币"] = "Gold"
	L["启动信息条2"] = "Bottom Info"
	L["底部背景"] = "Bottom Background"
	L["时钟"] = "Clock"
	L["耐久"] = "Durability"
	L["地城"] = "Hearth"
	L["天赋"] = "Talent"
	L["信息条1"] = "Info 1"
	L["信息条2"] = "Info 2"
	L["目前"] = "Current"
	L["收入"] = "Income"
	L["花费"] = "Spend"
	L["亏损"] = "Loss"
	L["服务器"] = "Server"
	L["总计"] = "Total"
	L["延迟"] = "Delay"
	L["本地延迟"] = "Local Delay"
	L["世界延迟"] = "World Delay"
	L["带宽"] = "Bandwidth"
	L["下载"] = "Download"
	L["内存"] = "Memory"
	L["总CPU使用"] = "Total CPU usage"
	L["总内存使用"] = "Total memory usage"
	L["共释放内存"] = "Total release memory"
end

do
	L["缺失Buff"] = "Missing Buff"
	L["Buff提醒"] = "Buff Reminder"
	L["显示团队增益缺失提醒"] = "Display Party missing buffs"
	L["只在队伍中显示"] = "Only show in the Party"
	L["团队增益图标排列方式"] = "Party icon arrangement"
	L["团队增益图标排列方式"] = "Party icon arrangement"
	L["横排"] = "Horizontal"
	L["竖排"] = "Vertical"
	L["显示职业增益缺失提醒"] = "Display profession gain missing remind"
	L["职业增益图标大小"] = "Occupational gain icon size"
	L["Buff提醒"] = "Buff remind"
	L["缺失Buff"] = "Missing Buff"
end
--Casting Announcement
do
	L["施法通告"] = "Casting Announcement"
	L["只是通告自己施放的法术"] = "Announce Cast Spells"
	L["启用打断通告"] = "Announce Interrupt"
	L["启用治疗大招通告"] = "Announce Heal"
	L["启用误导通告"] = "Announce Misdirect"
	L["启用保命技能通告"] = "life-saving skills to enable Notices"
	L["启用给出大招通告"] = "enable gives notice big move"
	L["包含天使,痛苦压制,保护等等"] = "Include Angel, Pain Suppression, Protection, etc."
	L["启用复活技能通告"] = "Announce Resurrection"
	L["启用团队减伤通告"] = "Enable team by injury Notice"
	L["正在施放"] = " being cast."
	L["已施放"] = " has been cast."
	L["复活"] = "Resurrection"
end
--Automatic Specialization
do
	L["自动换装"] = "Auto spec"
	L["选择主天赋装备"] = "Select the main spec and equipment"
	L["选择副天赋装备"] = "Selected secondary spec and equipment"
end
--Professions Assistant
do
	L["斩杀提示"] = "Loss of Control"
	L["职业助手"] = "Professions Assistant"
	L["图标大小"] = "Icon Size"
	L["宠物计时"] = "Pet Timing"
end
do
	L["世界地图"] = "World Map"
end

do
	L["内置CD监视"] = "Built-in Cooldown"
	L["启用图标模式"] = "Enable Icon Mode"
	L["计时条增长方向"] = "Timing bar growth direction"
	L["向下"] = "Down"
	L["向上"] = "Up"
	
	L["团队CD监视"] = "Party Cooldown"
	L["换行数目"] = "Wrap number"
	L["换行方向"] = "Wrap direction"
	L["向左"] = "Left"
	L["向右"] = "Right"
	L["上限"] = "Cap"
end