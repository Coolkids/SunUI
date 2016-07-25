SunUI即日起转换为ElvUI的一个分支<br/>
SunUI严重依赖于ElvUI, ElvUI核心可以随意更新<br/>
ElvUI更新地址  <br/>
http://git.tukui.org/Elv/elvui   
<br/>
为什么要这么做呢?<br/>
因为我也想抱抱大腿.一个人做维护时间,精力都不够,每次大版本更新都基本等于重写,还是去抱抱大腿吧..<br/>
<br/>
<br/>
<br/>
目前进度:<br/>
1.完成美化<br/>
2.完成默认值的修改<br/>
3.鼠标提示修改<br/>
4.加入原版-通知插件功能<br/>
5.加入原版-种菜钓鱼功能<br/>
6.职业助手-斩杀提示<br/>
7.施法通告-默认关闭打断(跟ElvUI冲突)<br/>
8.自动交接任务<br/>
9.修复raywatch<br/>
10.施法通告<br/>
11.原来聊天除掉广告过滤的所有功能<br/>
12.powerbar<br/>
13.DBM美化<br/>
<br/>
未完工:<br/>
1.冷却计时(有可能抛弃掉)<br/>
<br/>
<br/>
如果你觉得头像丑...那可能无解了..或者你自己替换头像插件<br/>
<br/>
看不到伤害数字的同学可以有以下建议<br/>
建议安装AdvancedInterfaceOptions插件<br/>
更新地址http://mods.curse.com/addons/wow/advancedinterfaceoptions   <br/>
配置下floatingCombatTextCombatDamage属性 PS:本插件默认会配置这个属性<br/>
<br/>
powerbar设置方法<br/>
ElvUI_SunUI_Module\config\config.lua<br/>
P["PowerBar"]={    <br/>
	Open = true,    --开关   <br/>
	Width = 200,	--宽度   <br/>
	Height = 5,		--高度   <br/>
	Fade = true,	--脱离战斗渐隐   <br/>
	HealthPower = true,    --开启血量/魔法值   <br/>
	DisableText = true,		--开启血量/魔法值文字 true为隐藏文字 false为开启文字   <br/>
	HealthPowerPer = true,		--血量百分比化   <br/>
	ManaPowerPer = true,		--魔法值百分比化    <br/>
}  <br/>
<br/>
