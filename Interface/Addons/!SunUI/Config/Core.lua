-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("Config", "AceConsole-3.0")
local Version = 20120323
function Module:SetDefault()
	SlashCmdList.AutoSet()
	CoreVersion = Version
	WelcomeDB = 1
end
MoveHandle = {}
DB["Modules"] = {}
DB["Config"] = {
	ResetToDefault = {
		type = "execute",
		name = L["恢复默认设置"],
		order = 1,
		func = function()
			StaticPopupDialogs["sure"] = {
			text = L["恢复默认标语"],
				button1 = OKAY,
				button2 = CANCEL,
			OnAccept = function()
				for _, value in pairs(DB["Modules"]) do value.ResetToDefault() end
				Module:SetDefault()
				ReloadUI()
				end,
			OnCancel = function()
				end,
			timeout = 0,
			hideOnEscape = 0,
			}
			StaticPopup_Show("sure")
	end
	},
	UnLock = {
		type = "execute",
		name = L["解锁框体"],
		order = 2,
		func = function()
			if not UnitAffectingCombat("player") then
				for _, value in pairs(MoveHandle) do value:Show() end
			end		
		end,
	},
	Lock = {
		type = "execute",
		name = L["锁定框体"],
		order = 3,
		func = function()
			if not UnitAffectingCombat("player") then
				for _, value in pairs(MoveHandle) do value:Hide() end
			end
		end,
	},
	Reload = {
		type = "execute",
		name = L["应用(重载界面)"],
		order = 4,
		func = function() ReloadUI() end
	},
}

function Module:ShowConfig()
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("SunUI Config", 800, 600)
	LibStub("AceConfigDialog-3.0"):Open("SunUI Config")
end

function Module:BuildGameMenuButton()
	local Button = CreateFrame("Button", "SunUIGameMenuButton", GameMenuFrame, "GameMenuButtonTemplate")
	S.Reskin(Button)
	Button:SetSize(GameMenuButtonHelp:GetWidth(), GameMenuButtonHelp:GetHeight())
	Button:SetText("|cffDDA0DDSun|r|cff44CCFFUI|r")
	Button:SetPoint(GameMenuButtonHelp:GetPoint())
	Button:SetScript("OnClick", function()
		HideUIPanel(GameMenuFrame)
		Module:ShowConfig()
	end)
	GameMenuButtonHelp:SetPoint("TOP", Button, "BOTTOM", 0, -1)
	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight()+Button:GetHeight())	
end

function Module:OnInitialize()
	for _, value in pairs(DB["Modules"]) do
		value.LoadSettings()
		value.BuildGUI()
	end
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SunUI Config", {
		type = "group",
		name = "|cffDDA0DDSun|r|cff44CCFFUI|r",
		args = DB["Config"],
	})
	Module:RegisterChatCommand("SunUI", "ShowConfig")
end
local function BuildFrame()
	local f = CreateFrame("Frame", "SunUI_InstallFrame", UIParent)
	f:SetSize(400, 400)
	f:SetPoint("CENTER")
	f:SetFrameStrata("HIGH")
	S.CreateBD(f)
	S.CreateSD(f)

	local sb = CreateFrame("StatusBar", nil, f)
	sb:SetPoint("BOTTOM", f, "BOTTOM", 0, 60)
	sb:SetSize(320, 20)
	sb:SetStatusBarTexture(DB.Statusbar)
	sb:Hide()
	
	local sbd = CreateFrame("Frame", nil, sb)
	sbd:SetPoint("TOPLEFT", sb, -1, 1)
	sbd:SetPoint("BOTTOMRIGHT", sb, 1, -1)
	sbd:SetFrameLevel(sb:GetFrameLevel()-1)
	S.CreateBD(sbd, .25)

	local header = f:CreateFontString(nil, "OVERLAY")
	header:SetFont(DB.Font, 16, "THINOUTLINE")
	header:SetPoint("TOP", f, "TOP", 0, -20)

	local body = f:CreateFontString(nil, "OVERLAY")
	body:SetJustifyH("LEFT")
	body:SetFont(DB.Font, 13, "THINOUTLINE")
	body:SetWidth(f:GetWidth()-40)
	body:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -60)

	local credits = f:CreateFontString(nil, "OVERLAY")
	credits:SetFont(DB.Font, 9, "THINOUTLINE")
	credits:SetText("SunUI by Coolkid @ 天空之牆 - TW")
	credits:SetPoint("BOTTOM", f, "BOTTOM", 0, 4)

	local sbt = sb:CreateFontString(nil, "OVERLAY")
	sbt:SetFont(DB.Font, 13, "THINOUTLINE")
	sbt:SetPoint("CENTER", sb)

	local option1 = CreateFrame("Button", "SunUI_Install_Option1", f, "UIPanelButtonTemplate")
	option1:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 20, 20)
	option1:SetSize(128, 25)
	S.Reskin(option1)

	local option2 = CreateFrame("Button", "SunUI_Install_Option2", f, "UIPanelButtonTemplate")
	option2:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -20, 20)
	option2:SetSize(128, 25)
	S.Reskin(option2)
	--local close = CreateFrame("Button", "SunUI_Install_CloseButton", f, "UIPanelCloseButton")
	--close:SetPoint("TOPRIGHT", f, "TOPRIGHT")
	--S.ReskinClose(close)
	--SetUpChat
	local function SetChat()
		local channels = {
				"SAY",
				"EMOTE",
				"YELL",
				"GUILD",
				"OFFICER",
				"GUILD_ACHIEVEMENT",
				"ACHIEVEMENT",
				"WHISPER",
				"PARTY",
				"PARTY_LEADER",
				"RAID",
				"RAID_LEADER",
				"RAID_WARNING",
				"BATTLEGROUND",
				"BATTLEGROUND_LEADER",
				"CHANNEL1",
				"CHANNEL2",
				"CHANNEL3",
				"CHANNEL4",
				"CHANNEL5",
				"CHANNEL6",
				"CHANNEL7",
			}
			
		for i, v in ipairs(channels) do
			ToggleChatColorNamesByClassGroup(true, v)
		end
		
		FCF_SetLocked(ChatFrame1, nil)
		FCF_SetChatWindowFontSize(self, ChatFrame1, 15) 
		ChatFrame1:ClearAllPoints()
		ChatFrame1:SetPoint("BOTTOMLEFT", 5, 28)
		ChatFrame1:SetWidth(327)
		ChatFrame1:SetHeight(122)
		ChatFrame1:SetUserPlaced(true)
		for i = 1,10 do FCF_SetWindowAlpha(_G["ChatFrame"..i], 0) end
		FCF_SavePositionAndDimensions(ChatFrame1)
		FCF_SetLocked(ChatFrame1, 1)
	end
	--SetUpDBM
	local function SetDBM()
		if(DBM_SavedOptions) then table.wipe(DBM_SavedOptions) end
		DBM_SavedOptions["DisableCinematics"] = true
		DBM_SavedOptions.Enabled = true
		DBT_SavedOptions["DBM"].Scale = 1
		DBT_SavedOptions["DBM"].HugeScale = 1
		DBT_SavedOptions["DBM"].Texture = DB.Statusbar
		DBT_SavedOptions["DBM"].ExpandUpwards = false
		DBT_SavedOptions["DBM"].BarXOffset = 0
		DBT_SavedOptions["DBM"].BarYOffset = 12
		DBT_SavedOptions["DBM"].IconLeft = true
		DBT_SavedOptions["DBM"].Texture = "Interface\\Buttons\\WHITE8x8"
		DBT_SavedOptions["DBM"].IconRight = false	
		DBT_SavedOptions["DBM"].Flash = false
		DBT_SavedOptions["DBM"].FadeIn = true
		DBT_SavedOptions["DBM"].TimerX = 420
		DBT_SavedOptions["DBM"].TimerY = -29
		DBT_SavedOptions["DBM"].TimerPoint = "TOPLEFT"
		DBT_SavedOptions["DBM"].StartColorR = 1
		DBT_SavedOptions["DBM"].StartColorG = 1
		DBT_SavedOptions["DBM"].StartColorB = 0
		DBT_SavedOptions["DBM"].EndColorR = 1
		DBT_SavedOptions["DBM"].EndColorG = 0
		DBT_SavedOptions["DBM"].EndColorB = 0
		DBT_SavedOptions["DBM"].Width = 130
		DBT_SavedOptions["DBM"].HugeWidth = 155
		DBT_SavedOptions["DBM"].HugeTimerPoint = "TOP"
		DBT_SavedOptions["DBM"].HugeTimerX = -150
		DBT_SavedOptions["DBM"].HugeTimerY = -207
	end
	--按钮
	local step4 = function()
		sb:SetValue(4)
		PlaySoundFile("Sound\\interface\\LevelUp.wav")
		header:SetText("安装完毕")
		body:SetText("现在已经安装完毕.\n\n请点击结束重载界面完成最后安装.\n\nEnjoy!")
		sbt:SetText("4/4")
		option1:Hide()
		option2:SetText("结束")
		option2:SetScript("OnClick", function()
			ReloadUI()
		end)
	end

	local step3 = function()
		sb:SetValue(3)
		header:SetText("3. 安装DBM设置")
		body:SetText("如果你没有安装DBM这一步将不会生效,请确定您安装了DBM\n\n即将安装DBM设置.\n\n当然您也可以输入/dbm进行设置.")
		sbt:SetText("3/4")
		option1:SetScript("OnClick", step4)
		option2:SetScript("OnClick", function()
			SetDBM()
			step4()
		end)
	end

	local step2 = function()
		sb:SetValue(2)
		header:SetText("2. 聊天框设置")
		body:SetText("将按照插件默认设置配置聊天框,详细微调请鼠标右点聊天标签")
		sbt:SetText("2/4")
		option1:SetScript("OnClick", step3)
		option2:SetScript("OnClick", function()
			SetChat()
			step3()
		end)
	end

	local step1 = function()
		sb:SetMinMaxValues(0, 4)
		sb:Show()
		sb:SetValue(1)
		sb:GetStatusBarTexture():SetGradient("VERTICAL", 0.20, .9, 0.12, 0.36, 1, 0.30)
		header:SetText("1. 载入SunUI核心数据")
		body:SetText("这一步将载入SunUI默认参数,请不要跳过\n\n更多详细设置在SunUI控制台内\n\n打开控制台方法:1.Esc>SunUI 2.输入命令/sunui 3.聊天框右侧上部渐隐按钮集合内点击S按钮")
		sbt:SetText("1/4")
		option1:Show()
		option1:SetText("跳过")
		option2:SetText("下一步")
		option1:SetScript("OnClick", step2)
		option2:SetScript("OnClick", function()
			Module:SetDefault()
			step2()
		end)
	end

	local tut6 = function()
		sb:SetValue(6)
		header:SetText("6. 结束")
		body:SetText("教程结束.更多详细设置请见/sunui 如果遇到灵异问题或者使用Bug 请到http://bbs.ngacn.cc/read.php?tid=4743077&_fp=1&_ff=200 回复记得带上BUG截图 亲~~")
		sbt:SetText("6/6")
		option1:Show()
		option1:SetText("结束")
		option2:SetText("安装")
		option1:SetScript("OnClick", function()
			UIFrameFade(f,{
				mode = "OUT",
				timeToFade = 0.5,
				finishedFunc = function(f) f:Hide() end,
				finishedArg1 = f,
			})
		end)
		option2:SetScript("OnClick", step1)
	end

	local tut5 = function()
		sb:SetValue(5)
		header:SetText("5. 命令")
		body:SetText("一些常用命令 \n/sunui 控制台 全局解锁什么的 ps:绝大部分设置需要重载生效 \n/align 在屏幕上显示网格,方便安排布局\n/hb 绑定动作条快捷键\n/rl 重载UI\n/wf 解锁任务追踪框体\n/vs 载具移动\n/pdb 插件全商业技能\n/rw2 buff监控设置\n/autoset 自动设置UI缩放\n/setdbm 重新设置DBM\n/setsunui重新打开安装向导")
		sbt:SetText("5/6")
		option2:SetScript("OnClick", tut6)
	end

	local tut4 = function()
		sb:SetValue(4)
		header:SetText("4. 您应该知道的东西")
		body:SetText("SunUI 95%的设置都是可以通过图形界面来完成的, 大多数的设置在/sunui中 少部分的设置在ESC>界面中.")
		sbt:SetText("4/6")
		option2:SetScript("OnClick", tut5)
	end

	local tut3 = function()
		sb:SetValue(3)
		header:SetText("3. 特性")
		body:SetText("SunUI是重新设计过的暴雪用户界面.具有大量人性化设计.您可以在各个细节中体验到")
		sbt:SetText("3/6")
		option2:SetScript("OnClick", tut4)
	end

	local tut2 = function()
		sb:SetValue(2)
		header:SetText("2.单位框架")
		body:SetText("SunUI的头像部分使用mono的oUF_Mono为模版进行改进而来.增加了更多额外的设置.自由度很高,你可以使用/sunui ->头像设置 进行更多的个性化设置. \n而团队框架则没有选用oUF部分,而是使用了暴雪内建团队框架的改良版,它比oUF的团队框架有更低的内存与CPU占用.更适合老爷机器.")
		sbt:SetText("2/6")
		option2:SetScript("OnClick", tut3)
	end

	local tut1 = function()
		sb:SetMinMaxValues(0, 6)
		sb:Show()
		sb:SetValue(1)
		sb:GetStatusBarTexture():SetGradient("VERTICAL", 0, 0.65, .9, .1, .9, 1)
		header:SetText("1. 概述")
		body:SetText("欢迎使用SunUI\n SunUI是一个类Tukui但是又不是Tukui的整合插件.它界面整洁清晰,功能齐全,整体看起来华丽而不臃肿.内存CPU占用小即使是老爷机也能跑.适用于宽频界面.")

		sbt:SetText("1/6")
		option1:Hide()
		option2:SetText("下一个")
		option2:SetScript("OnClick", tut2)
	end
	
	header:SetText("欢迎")
	body:SetText("欢迎您使用SunUI \n\n\n\n几个小步骤将引导你安装SunUI. \n\n\n为了达到最佳的使用效果,请不要随意跳过这个安装程序\n\n\n\n\n如果需要再次安装 请输入命令/sunui")

	option1:SetText("教程")
	option2:SetText("安装SunUI")

	option1:SetScript("OnClick", tut1)
	option2:SetScript("OnClick", step1)
end
SlashCmdList["SETSUNUI"] = function()
	if not UnitAffectingCombat("player") then
		BuildFrame()
	end
end
SLASH_SETSUNUI1 = "/setsunui"
function Module:OnEnable()
	Module:BuildGameMenuButton()
	if not CoreVersion or (CoreVersion < Version) then 
		BuildFrame()
	end
end