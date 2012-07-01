if GetLocale() ~= "zhCN" then return end
local L

-------------------------
--  Blackrock Caverns  --
--------------------------
-- Rom'ogg Bonecrusher --
--------------------------
L = DBM:GetModLocalization("Romogg")

L:SetGeneralLocalization({
	name = "摧骨者罗姆欧格"
})

-------------------------------
-- Corla, Herald of Twilight --
-------------------------------
L = DBM:GetModLocalization("Corla")

L:SetGeneralLocalization({
	name = "柯尔拉，暮光之兆"
})

L:SetWarningLocalization({
	WarnAdd		= "小怪被释放了"
})

L:SetOptionLocalization({
	WarnAdd		= "当一只小怪失去$spell:75608时警告"
})

-----------------------
-- Karsh SteelBender --
-----------------------
L = DBM:GetModLocalization("KarshSteelbender")

L:SetGeneralLocalization({
	name = "卡尔什·断钢"
})

L:SetTimerLocalization({
	TimerSuperheated 	= "过热的水银护甲 (%d)"	-- should work, no need for translation :)
})

L:SetOptionLocalization({
	TimerSuperheated	= "为$spell:75846显示持续时间计时条"
})

------------
-- Beauty --
------------
L = DBM:GetModLocalization("Beauty")

L:SetGeneralLocalization({
	name = "如花"
})

-----------------------------
-- Ascendant Lord Obsidius --
-----------------------------
L = DBM:GetModLocalization("AscendantLordObsidius")

L:SetGeneralLocalization({
	name = "升腾者领主奥西迪斯"
})

L:SetOptionLocalization({
	SetIconOnBoss	= "施放$spell:76200后标记首领本体"
})

---------------------
--  The Deadmines  --
---------------------
-- Glubtok --
-------------
L = DBM:GetModLocalization("Glubtok")

L:SetGeneralLocalization({
	name = "格拉布托克"
})

-----------------------
-- Helix Gearbreaker --
-----------------------
L = DBM:GetModLocalization("Helix")

L:SetGeneralLocalization({
	name = "赫利克斯·破甲"
})

---------------------
-- Foe Reaper 5000 --
---------------------
L = DBM:GetModLocalization("FoeReaper")

L:SetGeneralLocalization({
	name = "死神5000"
})

L:SetOptionLocalization{
	HarvestIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(88495)
}

----------------------
-- Admiral Ripsnarl --
----------------------
L = DBM:GetModLocalization("Ripsnarl")

L:SetGeneralLocalization({
	name = "撕心狼将军"
})

----------------------
-- "Captain" Cookie --
----------------------
L = DBM:GetModLocalization("Cookie")

L:SetGeneralLocalization({
	name = "“船长”曲奇"
})

----------------------
-- Vanessa VanCleef --
----------------------
L = DBM:GetModLocalization("Vanessa")

L:SetGeneralLocalization({
	name = "梵妮莎·范克里夫"
})

L:SetTimerLocalization({
	achievementGauntlet	= "坚定的范克里夫复仇者"
})

------------------
--  Grim Batol  --
---------------------
-- General Umbriss --
---------------------
L = DBM:GetModLocalization("GeneralUmbriss")

L:SetGeneralLocalization({
	name = "乌比斯将军"
})

L:SetOptionLocalization{
	PingBlitz	= "当乌比斯将军即将迅猛突袭你时点击小地图"
}

L:SetMiscLocalization{
	Blitz		= "盯住了|cFFFF0000(%S+)"
}

--------------------------
-- Forgemaster Throngus --
--------------------------
L = DBM:GetModLocalization("ForgemasterThrongus")

L:SetGeneralLocalization({
	name = "铸炉之主索朗格斯"
})

-------------------------
-- Drahga Shadowburner --
-------------------------
L = DBM:GetModLocalization("DrahgaShadowburner")

L:SetGeneralLocalization({
	name = "达加·燃影者"
})

L:SetMiscLocalization{
	ValionaYell	= "巨龙，听从我的命令！接住我！",	-- translate -- Yell when Valiona is incoming
	Add		= "%s开始施放",
	Valiona		= "瓦里昂娜"
}

------------
-- Erudax --
------------
L = DBM:GetModLocalization("Erudax")

L:SetGeneralLocalization({
	name = "埃鲁达克"
})

----------------------------
--  Halls of Origination  --
----------------------------
-- Temple Guardian Anhuur --
----------------------------
L = DBM:GetModLocalization("TempleGuardianAnhuur")

L:SetGeneralLocalization({
	name = "神殿守护者安努尔"
})

---------------------
-- Earthrager Ptah --
---------------------
L = DBM:GetModLocalization("EarthragerPtah")

L:SetGeneralLocalization({
	name = "地怒者塔赫"
})

L:SetMiscLocalization{
	Kill		= "塔赫……不复存在了……"
}

--------------
-- Anraphet --
--------------
L = DBM:GetModLocalization("Anraphet")

L:SetGeneralLocalization({
	name = "安拉斐特"
})

L:SetTimerLocalization({
	achievementGauntlet	= "超越光速"
})

L:SetMiscLocalization({
	Brann				= "好啊，我们走！只需要在门禁系统中输入最终登录序列……然后……"
})

------------
-- Isiset --
------------
L = DBM:GetModLocalization("Isiset")

L:SetGeneralLocalization({
	name = "伊希斯特"
})

L:SetWarningLocalization({
	WarnSplitSoon	= "分裂 即将到来"
})

L:SetOptionLocalization({
	WarnSplitSoon	= "为分裂显示预先警告"
})

-------------
-- Ammunae --
------------- 
L = DBM:GetModLocalization("Ammunae")

L:SetGeneralLocalization({
	name = "阿穆纳伊"
})

-------------
-- Setesh  --
------------- 
L = DBM:GetModLocalization("Setesh")

L:SetGeneralLocalization({
	name = "塞特斯"
})

----------
-- Rajh --
----------
L = DBM:GetModLocalization("Rajh")

L:SetGeneralLocalization({
	name = "拉夏"
})

--------------------------------
--  Lost City of the Tol'vir  --
--------------------------------
-- General Husam --
-------------------
L = DBM:GetModLocalization("GeneralHusam")

L:SetGeneralLocalization({
	name = "胡辛姆将军"
})

------------------------------------
-- Siamat, Lord of the South Wind --
------------------------------------
L = DBM:GetModLocalization("Siamat")

L:SetGeneralLocalization({
	name = "希亚玛特"		-- "Siamat, Lord of the South Wind" --> Real name is too long :((
})

L:SetWarningLocalization{
	specWarnPhase2Soon	= "5秒后进入第2阶段"
}

L:SetTimerLocalization({
	timerPhase2 	= "第2阶段开始"
})

L:SetOptionLocalization{
	specWarnPhase2Soon	= "当第2阶段即将到来(5秒)时显示特别警告",
	timerPhase2 	= "为第2阶段开始显示计时条"
}

------------------------
-- High Prophet Barim --
------------------------
L = DBM:GetModLocalization("HighProphetBarim")

L:SetGeneralLocalization({
	name = "高阶预言者巴林姆"
})

L:SetOptionLocalization{
	BossHealthAdds	= "在首领血量框架显示小怪血量"	-- translate
}

L:SetMiscLocalization{
	BlazeHeavens		= "天堂炽焰",	-- translate
	HarbringerDarkness	= "黑暗先驱"	-- translate
}

--------------
-- Lockmaw --
--------------
L = DBM:GetModLocalization("Lockmaw")

L:SetGeneralLocalization({
	name = "锁喉"
})

L:SetOptionLocalization{
	RangeFrame	= "显示距离框 (5码)"		-- translate
}

----------
-- Augh --
----------
L = DBM:GetModLocalization("Augh")

L:SetGeneralLocalization({
	name = "奥弗"		-- translate
})

-----------------------
--  Shadowfang Keep  --
-----------------------
-- Baron Ashbury --
-------------------
L = DBM:GetModLocalization("Ashbury")

L:SetGeneralLocalization({
	name = "灰葬男爵"
})

-----------------------
-- Baron Silverlaine --
-----------------------
L = DBM:GetModLocalization("Silverlaine")

L:SetGeneralLocalization({
	name = "席瓦莱恩男爵"
})

--------------------------
-- Commander Springvale --
--------------------------
L = DBM:GetModLocalization("Springvale")

L:SetGeneralLocalization({
	name = "指挥官斯普林瓦尔"
})

L:SetTimerLocalization({
	TimerAdds		= "下批小怪"
})

L:SetOptionLocalization{
	TimerAdds		= "为下一批小怪显示计时条"
}

L:SetMiscLocalization{
	YellAdds		= "击退入侵者！"
}

-----------------
-- Lord Walden --
-----------------
L = DBM:GetModLocalization("Walden")

L:SetGeneralLocalization({
	name = "沃登勋爵"
})

L:SetWarningLocalization{
	specWarnCoagulant	= "绿色混合 - 不断移动!",	-- Green light
	specWarnRedMix		= "红色混合 - 不要移动!"		-- Red light
}

L:SetOptionLocalization{
	RedLightGreenLight	= "为红/绿色移动方式显示特别警告"
}

------------------
-- Lord Godfrey --
------------------
L = DBM:GetModLocalization("Godfrey")

L:SetGeneralLocalization({
	name = "高弗雷勋爵"
})

---------------------
--  The Stonecore  --
---------------------
-- Corborus --
-------------- 
L = DBM:GetModLocalization("Corborus")

L:SetGeneralLocalization({
	name = "克伯鲁斯"
})

L:SetWarningLocalization({
	WarnEmerge	= "钻出地面",
	WarnSubmerge	= "钻进地里"
})

L:SetTimerLocalization({
	TimerEmerge	= "下一次 钻出地面",
	TimerSubmerge	= "下一次 钻进地里"
})

L:SetOptionLocalization({
	WarnEmerge	= "为钻出地面显示警告",
	WarnSubmerge	= "为钻进地里显示警告",
	TimerEmerge	= "为钻出地面显示计时条",
	TimerSubmerge	= "为钻进地里显示计时条",
	CrystalArrow	= "当你附近的人中了$spell:81634时显示DBM箭头",
	RangeFrame	= "显示距离框 (5码)"
})

-----------
-- Ozruk --
----------- 
L = DBM:GetModLocalization("Ozruk")

L:SetGeneralLocalization({
	name = "欧泽鲁克"
})

--------------
-- Slabhide --
-------------- 
L = DBM:GetModLocalization("Slabhide")

L:SetGeneralLocalization({
	name = "岩皮"
})

L:SetWarningLocalization({
	WarnAirphase			= "空中阶段",
	WarnGroundphase			= "地上阶段",
	specWarnCrystalStorm		= "水晶风暴 - 找掩护"
})

L:SetTimerLocalization({
	TimerAirphase			= "下一次 空中阶段",
	TimerGroundphase		= "下一次 地上阶段"
})

L:SetOptionLocalization({
	WarnAirphase			= "当岩皮升空时显示警告",
	WarnGroundphase			= "当岩皮降落时显示警告",
	TimerAirphase			= "为下一次 空中阶段显示计时条",
	TimerGroundphase		= "为下一次 地上阶段显示计时条",
	specWarnCrystalStorm		= "为$spell:92265显示特别警告"
})

-------------------------
-- High Priestess Azil --
------------------------
L = DBM:GetModLocalization("HighPriestessAzil")

L:SetGeneralLocalization({
	name = "高阶女祭司艾苏尔"
})

---------------------------
--  The Vortex Pinnacle  --
---------------------------
-- Grand Vizier Ertan --
------------------------
L = DBM:GetModLocalization("GrandVizierErtan")

L:SetGeneralLocalization({
	name = "大宰相尔埃尔坦"
})

L:SetMiscLocalization{
	Retract		= "%s收回了他的旋风之盾！"
}

--------------
-- Altairus --
-------------- 
L = DBM:GetModLocalization("Altairus")

L:SetGeneralLocalization({
	name = "阿尔泰鲁斯"
})

L:SetOptionLocalization({
	BreathIcon	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(88308)
})

-----------
-- Asaad --
-----------
L = DBM:GetModLocalization("Asaad")

L:SetGeneralLocalization({
	name = "阿萨德"
})

L:SetOptionLocalization({
	SpecWarnStaticCling	= "为$spell:87618显示特别警告"
})

L:SetWarningLocalization({
	SpecWarnStaticCling	= "快跳！"
})

---------------------------
--  The Throne of Tides  --
---------------------------
-- Lady Naz'jar --
------------------ 
L = DBM:GetModLocalization("LadyNazjar")

L:SetGeneralLocalization({
	name = "纳兹夏尔女士"
})

-----======-----------
-- Commander Ulthok --
---------------------- 
L = DBM:GetModLocalization("CommanderUlthok")

L:SetGeneralLocalization({
	name = "指挥官乌尔索克"
})

-------------------------
-- Erunak Stonespeaker --
-------------------------
L = DBM:GetModLocalization("ErunakStonespeaker")

L:SetGeneralLocalization({
	name = "蛊心魔古厄夏"
})

------------
-- Ozumat --
------------ 
L = DBM:GetModLocalization("Ozumat")

L:SetGeneralLocalization({
	name = "厄祖玛特"
})

----------------
--  Zul'Aman  --
---------------
--  Nalorakk --
---------------
L = DBM:GetModLocalization("Nalorakk5")

L:SetGeneralLocalization{
	name = "纳洛拉克(熊)"
}

L:SetWarningLocalization{
	WarnBear		= "熊形态",
	WarnBearSoon	= "5秒后 熊形态",
	WarnNormal		= "普通形态",
	WarnNormalSoon	= "5秒后 普通形态"
}

L:SetTimerLocalization{
	TimerBear		= "熊形态",
	TimerNormal		= "普通形态"
}

L:SetOptionLocalization{
	WarnBear		= "为熊形态显示警告",--Translate
	WarnBearSoon	= "为熊形态显示预先警告",--Translate
	WarnNormal		= "为普通形态显示警告",--Translate
	WarnNormalSoon	= "为普通形态显示预先警告",--Translate
	TimerBear		= "为熊形态显示计时条",--Translate
	TimerNormal		= "为普通形态显示计时条",
	InfoFrame		= "在信息框显示中了$spell:42402的玩家"
}

L:SetMiscLocalization{
	YellBear 	= "你们召唤野兽？你马上就要大大的后悔了！",
	YellNormal	= "纳洛拉克，变形，出发！",
	PlayerDebuffs	= "刚被冲锋过"
}

---------------
--  Akil'zon --
---------------
L = DBM:GetModLocalization("Akilzon5")

L:SetGeneralLocalization{
	name = "埃基尔松(鹰)"
}

L:SetOptionLocalization{
	StormIcon	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(97300),
	RangeFrame	= "显示距离框(10码)",
	StormArrow	= "为$spell:97300显示DBM箭头",
	SetIconOnEagle	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(97318)
}

---------------
--  Jan'alai --
---------------
L = DBM:GetModLocalization("Janalai5")

L:SetGeneralLocalization{
	name = "加亚莱(龙鹰)"
}

L:SetOptionLocalization{
	FlameIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(43140)
}

L:SetMiscLocalization{
	YellBomb	= "烧死你们！",
	YellHatchAll= "现在，让我来告诉你们什么叫……数量优势。",
	YellAdds	= "孵化者呢？快去孵蛋！"
}

--------------
--  Halazzi --
--------------
L = DBM:GetModLocalization("Halazzi5")

L:SetGeneralLocalization{
	name = "哈尔拉兹(山猫)"
}

L:SetWarningLocalization{
	WarnSpirit	= "灵魂阶段",
	WarnNormal	= "普通阶段"
}

L:SetOptionLocalization{
	WarnSpirit	= "为灵魂阶段显示警告",--Translate
	WarnNormal	= "为普通阶段显示警告"--Translate
}

L:SetMiscLocalization{
	YellSpirit	= "狂野的灵魂与我同在……",
	YellNormal	= "灵魂，到我这里来！"
}

--------------------------
--  Hex Lord Malacrass --
--------------------------
L = DBM:GetModLocalization("Malacrass5")

L:SetGeneralLocalization{
	name = "妖术领主玛拉卡斯"
}

L:SetTimerLocalization{
	TimerSiphon	= "%s: %s"
}

L:SetOptionLocalization{
	TimerSiphon	= "为$spell:43501显示计时条"
}

L:SetMiscLocalization{
	YellPull	= "阴影将会降临在你们头上……"
}

-------------
-- Daakara --
-------------
L = DBM:GetModLocalization("Daakara")

L:SetGeneralLocalization{
	name = "达卡拉"
}

L:SetTimerLocalization{
	timerNextForm	= "下一次转换形态"
}

L:SetOptionLocalization{
	timerNextForm	= "为转换形态显示计时条",
	InfoFrame		= "在信息框显示中了$spell:42402的玩家",
	ThrowIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(97639),
	ClawRageIcon	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(97672)
}

L:SetMiscLocalization{
	PlayerDebuffs	= "刚被冲锋过"
}

-----------------
--  Zul'Gurub  --
-------------------------
-- High Priest Venoxis --
-------------------------
L = DBM:GetModLocalization("Venoxis")

L:SetGeneralLocalization{
	name = "高阶祭司温诺希斯"
}

L:SetOptionLocalization{
	SetIconOnToxicLink	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(96477),
	LinkArrow		= "当你中了$spell:96477时显示DBM箭头"
}

------------------------
-- Bloodlord Mandokir --
------------------------
L = DBM:GetModLocalization("Mandokir")

L:SetGeneralLocalization{
	name = "血领主曼多基尔"
}

L:SetWarningLocalization{
	WarnRevive		= "还剩余 %d 救赎的灵魂",
	SpecWarnOhgan	= "奥根复活! 快击杀!" -- check this, i'm not good at English
}

L:SetOptionLocalization{
	WarnRevive		= "通告还剩余多少救赎的灵魂",
	SpecWarnOhgan	= "当奥根复活的时候显示警告", -- check this, i'm not good at English
	SetIconOnOhgan	= "当奥根复活的时候给他设定标记"
}

L:SetMiscLocalization{
	Ohgan		= "奥根"
}

------------
-- Zanzil --
------------
L = DBM:GetModLocalization("Zanzil")

L:SetGeneralLocalization{
	name = "赞吉尔"
}

L:SetWarningLocalization{
	SpecWarnToxic	= "去点绿锅"
}

L:SetOptionLocalization{
	SpecWarnToxic	= "当你没有$spell:96328时显示特别警告",
	InfoFrame		= "在信息框显示没有$spell:96328的玩家",
	SetIconOnGaze	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(96342)
}

L:SetMiscLocalization{
	PlayerDebuffs	= "没有点绿锅"
}

----------------------------
-- High Priestess Kilnara --
----------------------------
L = DBM:GetModLocalization("Kilnara")

L:SetGeneralLocalization{
	name = "高阶祭司基尔娜拉"
}

L:SetMiscLocalization{
	WaveAgony	= "感受我的痛楚！"
}

----------------------------
-- Jindo --
----------------------------
L = DBM:GetModLocalization("Jindo")

L:SetGeneralLocalization{
	name = "碎神者金度"
}

L:SetWarningLocalization{
	WarnBarrierDown	= "哈卡之链被破坏 - 剩余 %d/3"
}

L:SetOptionLocalization{
	WarnBarrierDown	= "当哈卡之链被破坏时显示警告",
	BodySlamIcon	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(97198)
}

L:SetMiscLocalization{
	Kill			= "你太放肆了，金度，你竟敢把远远凌驾于你的力量当作儿戏。难道你忘了我是谁？难道你忘了我能做什么？" -- temporarily
}

----------------------
-- Cache of Madness --
----------------------
-------------
-- Gri'lek --
-------------
--L= DBM:GetModLocalization(603)

L = DBM:GetModLocalization("CoMGrilek")

L:SetGeneralLocalization{
	name = "格里雷克"
}

L:SetMiscLocalization({
	pursuitEmote	= "%s正在追赶"
})

---------------
-- Hazza'rah --
---------------
--L= DBM:GetModLocalization(604)

L = DBM:GetModLocalization("CoMGHazzarah")

L:SetGeneralLocalization{
	name = "哈扎拉尔"
}

--------------
-- Renataki --
--------------
--L= DBM:GetModLocalization(605)

L = DBM:GetModLocalization("CoMRenataki")

L:SetGeneralLocalization{
	name = "雷纳塔基"
}

---------------
-- Wushoolay --
---------------
--L= DBM:GetModLocalization(606)

L = DBM:GetModLocalization("CoMWushoolay")

L:SetGeneralLocalization{
	name = "乌苏雷"
}

--------------------
--  World Bosses  --
-------------------------
-- Akma'hat --
-------------------------
L = DBM:GetModLocalization("Akmahat")

L:SetGeneralLocalization{
	name = "阿卡玛哈特"
}

-----------
-- Garr --
----------
L = DBM:GetModLocalization("Garr")

L:SetGeneralLocalization{
	name = "加尔 (Cata)"
}

----------------
-- Julak-Doom --
----------------
L = DBM:GetModLocalization("JulakDoom")

L:SetGeneralLocalization{
	name = "厄运尤拉克"
}

L:SetOptionLocalization{
	SetIconOnMC	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(93621)
}

-----------
-- Mobus --
-----------
L = DBM:GetModLocalization("Mobus")

L:SetGeneralLocalization{
	name = "魔布斯"
}

-----------
-- Xariona --
-----------
L = DBM:GetModLocalization("Xariona")

L:SetGeneralLocalization{
	name = "埃克萨妮奥娜"
}

----------------
--  End Time  --
----------------------
-- Echo of Sylvanas --
----------------------
L = DBM:GetModLocalization("EchoSylvanas")

L:SetGeneralLocalization{
	name = "希尔瓦娜斯的残影"
}

---------------------
-- Echo of Tyrande --
---------------------
L = DBM:GetModLocalization("EchoTyrande")

L:SetGeneralLocalization{
	name = "泰兰德的残影"
}

-------------------
-- Echo of Jaina --
-------------------
L = DBM:GetModLocalization("EchoJaina")

L:SetGeneralLocalization{
	name = "吉安娜的残影"
}

L:SetTimerLocalization{
	TimerFlarecoreDetonate	= "炙焰之核爆炸"
}

L:SetOptionLocalization{
	TimerFlarecoreDetonate	= "为$spell:101927显示计时条"
}

----------------------
-- Echo of Baine --
----------------------
L = DBM:GetModLocalization("EchoBaine")

L:SetGeneralLocalization{
	name = "贝恩的残影"
}

--------------
-- Murozond --
--------------
L = DBM:GetModLocalization("Murozond")

L:SetGeneralLocalization{
	name = "姆诺兹多"
}

L:SetMiscLocalization{
	Kill		= "你根本不明白你究竟干了什么。阿曼苏尔……我……看到……的……"
}

------------------------
--  Well of Eternity  --
------------------------
-- Peroth'arn --
----------------
L = DBM:GetModLocalization("Perotharn")

L:SetGeneralLocalization{
	name = "佩罗萨恩"
}

L:SetMiscLocalization{
	Pull		= "没有凡人能从我手中逃脱！"
}

-------------
-- Azshara --
-------------
L = DBM:GetModLocalization("Azshara")

L:SetGeneralLocalization{
	name = "艾萨拉女王"
}

L:SetWarningLocalization{
	WarnAdds	= "小怪即将激活"
}

L:SetTimerLocalization{
	TimerAdds	= "下一批小怪"
}

L:SetOptionLocalization{
	WarnAdds	= "新一批小怪\"激活\"时显示警告",
	TimerAdds	= "为下一次小怪\"激活\"显示计时条"
}

L:SetMiscLocalization{
	Kill		= "够了！我虽然好客，但现在必须要去处理更重要的事情了。"
}

-----------------------------
-- Mannoroth and Varo'then --
-----------------------------
L = DBM:GetModLocalization("Mannoroth")

L:SetGeneralLocalization{
	name = "玛诺洛斯和禁卫队长瓦罗森"
}

L:SetTimerLocalization{
	TimerTyrandeHelp	= "泰兰德需要帮助"
}

L:SetOptionLocalization{
	TimerTyrandeHelp	= "为泰兰德需要帮助显示计时条"
}

L:SetMiscLocalization{
	Kill		= "玛法里奥，他成功了！传送门崩溃了！"
}

------------------------
--  Hour of Twilight  --
------------------------
-- Arcurion --
--------------
L = DBM:GetModLocalization("Arcurion")

L:SetGeneralLocalization{
	name = "阿奎里恩"
}

L:SetTimerLocalization{
	TimerCombatStart	= "战斗开始"
}

L:SetOptionLocalization{
	TimerCombatStart	= "为战斗开始显示计时条"
}

L:SetMiscLocalization{
	Event		= "现身吧！",
	Pull		= "暮光大军出现在峡谷上方的悬崖边。"
}

----------------------
-- Asira Dawnslayer --
----------------------
L = DBM:GetModLocalization("AsiraDawnslayer")

L:SetGeneralLocalization{
	name = "埃希拉·黎明克星"
}

L:SetMiscLocalization{
	Pull		= "……解决了那东西，你和这群乌合之众就是我的下一个目标。唔，我还以为你们根本到不了这儿！"
}

---------------------------
-- Archbishop Benedictus --
---------------------------
L = DBM:GetModLocalization("Benedictus")

L:SetGeneralLocalization{
	name = "大主教本尼迪塔斯"
}

L:SetTimerLocalization{
	TimerCombatStart	= "战斗开始"
}

L:SetOptionLocalization{
	TimerCombatStart	= "为战斗开始显示计时条"
}

L:SetMiscLocalization{
	Event		= "萨满，你会把巨龙之魂交给我。"
}