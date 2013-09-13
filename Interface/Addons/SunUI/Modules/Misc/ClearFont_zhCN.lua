local S, L, DB, _, C = unpack(select(2, ...))
if not (GetLocale() == "zhCN") then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("ClearFont_zhCN", "AceEvent-3.0", "AceHook-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local CF_SCALE
-- 指出在哪里寻找字体
local CLEAR_FONT_BASE = "Fonts\\"

-- 金币、堆叠、按键绑定等字体
local CLEAR_FONT_NUMBER = CLEAR_FONT_BASE.."ARHei.TTF"
-- 生命条、经验条上的字体
local CLEAR_FONT_EXP = CLEAR_FONT_BASE.."ARHei.TTF"
-- 任务说明和书信、石碑的正文字体
local CLEAR_FONT_QUEST = CLEAR_FONT_BASE.."ARKai_T.TTF"
-- 战斗伤害数值提示
local CLEAR_FONT_DAMAGE = CLEAR_FONT_BASE.."ARKai_C.TTF"
-- 游戏界面中的主要字体
local CLEAR_FONT = CLEAR_FONT_BASE.."ARKai_T.TTF"
-- 物品、技能的说明字体
local CLEAR_FONT_ITEM = CLEAR_FONT_BASE.."ARKai_T.TTF"
-- 聊天字体
local CLEAR_FONT_CHAT = CLEAR_FONT_BASE.."ARHei.TTF"
local CF_SCALE = 1
local function CanSetFont(object) 
   return (type(object)=="table" 
	   and object.SetFont and object.IsObjectType 
		  and not object:IsObjectType("SimpleHTML")); 
end
local function ApplySystemFonts(event, addon)
	if addon ~= "SunUI" then return end
	-- 聊天泡泡
	STANDARD_TEXT_FONT = CLEAR_FONT_CHAT;
	-- 頭像上的名字，漂浮文本（遠處即可看見）
	UNIT_NAME_FONT = CLEAR_FONT;
	-- 頭像上的名字，在姓名板上（NamePlate，按“V”後靠近目標，出現的血條）
	NAMEPLATE_FONT = CLEAR_FONT;
	-- 被攻擊目標上方彈出的傷害指示（與插件SCT/DCT無關）
	DAMAGE_TEXT_FONT = CLEAR_FONT_DAMAGE;


	-- ----------------------------------------------------------------------------- 
	-- 下拉功能表字體大小（Note by Kirkburn）
	--  ***注意*** ClearFont 只能定義這個字體的大小（受限於Blizzard默認遊戲框架）
	-- ----------------------------------------------------------------------------- 
	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12 * CF_SCALE;

	-- -----------------------------------------------------------------------------
	-- 職業色彩（以下均為預設值/默認遮罩）
	-- -----------------------------------------------------------------------------

	--	RAID_CLASS_COLORS = {
	--		["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 },			-- 獵人
	--		["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 },			-- 術士
	--		["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0 },				-- 牧師
	--		["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 },			-- 聖騎士
	--		["MAGE"] = { r = 0.41, g = 0.8, b = 0.94 },				-- 法師
	--		["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41 },			-- 潛行者
	--		["DRUID"] = { r = 1.0, g = 0.49, b = 0.04 },			-- 德魯伊
	--		["SHAMAN"] = { r = 0.14, g = 0.35, b = 1.0 },			-- 薩滿
	--		["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 }			-- 戰士
	--		["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },	-- 死亡騎士
	--	};

-- -----------------------------------------------------------------------------
-- 主遊戲字體: 隨處可見的主要的字體
-- -----------------------------------------------------------------------------

-- 主標題，按鈕，技能標題（技能書面板），任務名（任務日誌面板），好友角色名字（社交面板），榮譽點數、競技場點數（PvP面板），系統功能表專案
	if (CanSetFont(GameFontNormal)) then 				GameFontNormal:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- 預設值：15
-- 副標題，系統功能表按鈕，成就點數、成就條目（成就面板），貨幣面板條目，高亮任務名（任務日誌面板），日曆日期
	if (CanSetFont(GameFontHighlight)) then 			GameFontHighlight:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- 預設值：15

-- （未確認）
	if (CanSetFont(GameFontNormalMed3)) then 			GameFontNormalMed3:SetFont(CLEAR_FONT, 13 * CF_SCALE); end	-- 預設值：14
	if (CanSetFont(GameFontNormalMed3)) then 			GameFontNormalMed3:SetTextColor(1.0, 0.82, 0); end	-- 預設值：(1.0, 0.82, 0)

-- 按鈕（不可選狀態）
	if (CanSetFont(GameFontDisable)) then 				GameFontDisable:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
	if (CanSetFont(GameFontDisable)) then 				GameFontDisable:SetTextColor(0.5, 0.5, 0.5); end	-- 預設值：(0.5, 0.5, 0.5)

-- 各種色彩文字
	if (CanSetFont(GameFontGreen)) then 				GameFontGreen:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- 預設值：15
	if (CanSetFont(GameFontRed)) then 					GameFontRed:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
	if (CanSetFont(GameFontBlack)) then 				GameFontBlack:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
	if (CanSetFont(GameFontWhite)) then 				GameFontWhite:SetFont(CLEAR_FONT, 14 * CF_SCALE); end


-- -----------------------------------------------------------------------------
-- 小字體：經常用小字體的地方，如角色屬性面板，BUFF時間，宏標題
-- -----------------------------------------------------------------------------

-- 頭像框架名字，BUFF時間，未選擇的面板標籤，面板中大部分描述字體，天賦點的數位，頭銜獎勵（成就面板），查詢、公會成員角色名字（社交面板），
-- 競技場站隊詳細、站隊等級（PvP面板），日曆活動條目
	if (CanSetFont(GameFontNormalSmall)) then 			GameFontNormalSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end		-- 預設值：15

-- 高亮字體，下拉功能表選項，已選擇的面板標籤，角色屬性、技能的數位、聲望條目（角色資訊面板），天賦點數（天賦面板），角色等級、職業等資訊、公會資訊（社交面板），
-- 詳細榮譽點、競技場比分（PvP面板），時間資訊，系統功能表子專案
	if (CanSetFont(GameFontHighlightSmall)) then 		GameFontHighlightSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- 預設值：15
	if (CanSetFont(GameFontHighlightSmallOutline)) then	GameFontHighlightSmallOutline:SetFont(CLEAR_FONT, 12 * CF_SCALE, "OUTLINE"); end

-- PvP面板描述，團隊面板按鈕等
	if (CanSetFont(GameFontDisableSmall)) then			GameFontDisableSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- 預設值：15
	if (CanSetFont(GameFontDisableSmall)) then			GameFontDisableSmall:SetTextColor(0.5, 0.5, 0.5); end	-- 預設值：(0.5, 0.5, 0.5)

-- （未確認）
	if (CanSetFont(GameFontDarkGraySmall)) then 		GameFontDarkGraySmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- 預設值：15
	if (CanSetFont(GameFontDarkGraySmall)) then 		GameFontDarkGraySmall:SetTextColor(0.35, 0.35, 0.35); end	-- 預設值：(0.35, 0.35, 0.35)

-- （未確認）
	if (CanSetFont(GameFontGreenSmall)) then 			GameFontGreenSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- 預設值：15
	if (CanSetFont(GameFontRedSmall)) then				GameFontRedSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end
	
-- 超小字體
	if (CanSetFont(GameFontHighlightExtraSmall)) then 		GameFontHighlightExtraSmall:SetFont(CLEAR_FONT, 11 * CF_SCALE); end		-- 預設值：15


-- -----------------------------------------------------------------------------
-- 大字體：標題
-- -----------------------------------------------------------------------------

-- 時鐘，碼錶
	if (CanSetFont(GameFontNormalLarge)) then 			GameFontNormalLarge:SetFont(CLEAR_FONT, 13 * CF_SCALE); end		-- 預設值：17
	if (CanSetFont(GameFontHighlightLarge)) then 		GameFontHighlightLarge:SetFont(CLEAR_FONT, 13 * CF_SCALE); end

-- 競技場面板
	if (CanSetFont(GameFontDisableLarge)) then			GameFontDisableLarge:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- 預設值：17
	if (CanSetFont(GameFontDisableLarge)) then			GameFontDisableLarge:SetTextColor(0.5, 0.5, 0.5); end	-- 預設值：(0.5, 0.5, 0.5)

-- （未確認）
	if (CanSetFont(GameFontGreenLarge)) then 			GameFontGreenLarge:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- 預設值：17
	if (CanSetFont(GameFontRedLarge)) then 			GameFontRedLarge:SetFont(CLEAR_FONT, 14 * CF_SCALE); end


-- -----------------------------------------------------------------------------
-- 巨大字體：Raid警報
-- -----------------------------------------------------------------------------

	if (CanSetFont(GameFontNormalHuge)) then			GameFontNormalHuge:SetFont(CLEAR_FONT, 20 * CF_SCALE); end	-- 預設值：20
	if (CanSetFont(GameFontNormalHugeBlack)) then		GameFontNormalHugeBlack:SetFont(CLEAR_FONT, 20 * CF_SCALE); end	-- 預設值：20


-- -----------------------------------------------------------------------------
-- Boss表情文字
-- -----------------------------------------------------------------------------

	if (CanSetFont(BossEmoteNormalHuge)) then			BossEmoteNormalHuge:SetFont(CLEAR_FONT, 25 * CF_SCALE); end		-- 預設值：25

-- -----------------------------------------------------------------------------
-- 數位字體: 拍賣行，金幣，按鍵綁定，物品堆疊數量
-- -----------------------------------------------------------------------------

-- 金幣，物品、Buff堆疊數量
	if (CanSetFont(NumberFontNormal)) then				NumberFontNormal:SetFont(CLEAR_FONT_NUMBER, 12 * CF_SCALE, "OUTLINE"); end		-- 預設值：12
	if (CanSetFont(NumberFontNormalYellow)) then 		NumberFontNormalYellow:SetFont(CLEAR_FONT_NUMBER, 12 * CF_SCALE); end

-- 動作條的按鍵綁定
	if (CanSetFont(NumberFontNormalSmall)) then 		NumberFontNormalSmall:SetFont(CLEAR_FONT_NUMBER, 11 * CF_SCALE, "OUTLINE"); end		-- 預設值：11
	if (CanSetFont(NumberFontNormalSmallGray)) then 	NumberFontNormalSmallGray:SetFont(CLEAR_FONT_NUMBER, 11 * CF_SCALE, "THINOUTLINE"); end

-- （未確認）
	if (CanSetFont(NumberFontNormalLarge)) then 		NumberFontNormalLarge:SetFont(CLEAR_FONT_NUMBER, 14 * CF_SCALE, "OUTLINE"); end		-- 預設值：14

-- 玩家頭像上的被攻擊指示
	if (CanSetFont(NumberFontNormalHuge)) then			NumberFontNormalHuge:SetFont(CLEAR_FONT_DAMAGE, 20 * CF_SCALE, "THINOUTLINE"); end	-- 預設值：20
--	if (CanSetFont(NumberFontNormalHuge)) then			NumberFontNormalHuge:SetAlpha(30); end


-- -----------------------------------------------------------------------------
-- 聊天視窗字體和聊天輸入框字體
-- -----------------------------------------------------------------------------

-- 聊天輸入框字體
	if (CanSetFont(ChatFontNormal)) then 				ChatFontNormal:SetFont(CLEAR_FONT_CHAT, 11 * CF_SCALE, "THINOUTLINE"); end	-- 預設值：14

-- 聊天視窗默認字體
	if (CanSetFont(ChatFontSmall)) then 				ChatFontSmall:SetFont(CLEAR_FONT_CHAT, 12 * CF_SCALE); end	-- 預設值：12


-- -----------------------------------------------------------------------------
-- 任務日誌: 任務日誌、書籍等
-- -----------------------------------------------------------------------------

-- 任務標題
	if (CanSetFont(QuestTitleFont)) then 				QuestTitleFont:SetFont(CLEAR_FONT_QUEST, 15 * CF_SCALE); end	-- 預設值：17

	if (CanSetFont(QuestTitleFontBlackShadow)) then 	QuestTitleFontBlackShadow:SetFont(CLEAR_FONT_QUEST, 15 * CF_SCALE); end	-- 預設值：17
	if (CanSetFont(QuestTitleFontBlackShadow)) then 	QuestTitleFontBlackShadow:SetTextColor(1.0, 0.82, 0); end			-- 預設值：(1.0, 0.82, 0)

-- 任務描述
	if (CanSetFont(QuestFont)) then 		   			QuestFont:SetFont(CLEAR_FONT_QUEST, 14 * CF_SCALE); end		-- 預設值：14
	if (CanSetFont(QuestFont)) then 		   			QuestFont:SetTextColor(1, 1, 1); end			-- 預設值：(0, 0, 0)

-- 任務目標
	if (CanSetFont(QuestFontNormalSmall)) then			QuestFontNormalSmall:SetFont(CLEAR_FONT, 13 * CF_SCALE); end	-- 預設值：14
	if (CanSetFont(QuestFontNormalSmall)) then			QuestFontNormalSmall:SetShadowColor(0.3, 0.18, 0); end	-- 預設值：(0.3, 0.18, 0)

-- 任務高亮
	if (CanSetFont(QuestFontHighlight)) then 			QuestFontHighlight:SetFont(CLEAR_FONT_QUEST, 13 * CF_SCALE); end	-- 預設值：13


-- -----------------------------------------------------------------------------
-- 物品信息: 那些"按右鍵閱讀"的物品（任務物品的內容字體，比如可以攜帶的書籍、信件的副本等）
-- -----------------------------------------------------------------------------

	if (CanSetFont(ItemTextFontNormal)) then 	 	  	ItemTextFontNormal:SetFont(CLEAR_FONT_QUEST, 15 * CF_SCALE); end		-- 預設值：15
	if (CanSetFont(ItemTextFontNormal)) then			ItemTextFontNormal:SetShadowColor(0.18, 0.12, 0.06); end	-- 預設值：(0.18, 0.12, 0.06)


-- -----------------------------------------------------------------------------
-- 郵件
-- -----------------------------------------------------------------------------

	if (CanSetFont(MailTextFontNormal)) then 	 	  	MailTextFontNormal:SetFont(CLEAR_FONT_QUEST, 15 * CF_SCALE); end	-- 預設值：15
	if (CanSetFont(MailTextFontNormal)) then 		   	MailTextFontNormal:SetTextColor(1, 1, 1); end		-- 預設值：(0.18, 0.12, 0.06)
--	if (CanSetFont(MailTextFontNormal)) then 	 	  	MailTextFontNormal:SetShadowColor(0.54, 0.4, 0.1); end
--	if (CanSetFont(MailTextFontNormal)) then 	 	  	MailTextFontNormal:SetShadowOffset(1, -1); end
   
   
-- -----------------------------------------------------------------------------
-- 技能：技能類型（被動、種族特長等）、技能等級
-- -----------------------------------------------------------------------------

	if (CanSetFont(SubSpellFont)) then					SubSpellFont:SetFont(CLEAR_FONT_QUEST, 12 * CF_SCALE); end	-- 預設值：12
	if (CanSetFont(SubSpellFont)) then 	   			SubSpellFont:SetTextColor(0.35, 0.2, 0); end	-- 預設值：(0.35, 0.2, 0)


-- -----------------------------------------------------------------------------
-- 對話方塊按鈕："同意"等字樣
-- -----------------------------------------------------------------------------

	if (CanSetFont(DialogButtonNormalText)) then 		DialogButtonNormalText:SetFont(CLEAR_FONT, 13 * CF_SCALE); end	-- 預設值：13
	if (CanSetFont(DialogButtonHighlightText)) then 	DialogButtonHighlightText:SetFont(CLEAR_FONT, 13 * CF_SCALE); end


-- -----------------------------------------------------------------------------
-- 區域切換顯示：在螢幕中央通知
-- -----------------------------------------------------------------------------

-- 大區功能變數名稱
	if (CanSetFont(ZoneTextFont)) then 	   			ZoneTextFont:SetFont(CLEAR_FONT, 32 * CF_SCALE, "THINOUTLINE"); end		-- 預設值：112
	if (CanSetFont(ZoneTextFont)) then 	   			ZoneTextFont:SetShadowColor(1.0, 0.9294, 0.7607); end	-- 預設值：(1.0, 0.9294, 0.7607)
	if (CanSetFont(ZoneTextFont)) then 	   			ZoneTextFont:SetShadowOffset(1, -1); end

-- 次區功能變數名稱
	if (CanSetFont(SubZoneTextFont)) then				SubZoneTextFont:SetFont(CLEAR_FONT, 26 * CF_SCALE, "THINOUTLINE"); end		-- 預設值：26


-- -----------------------------------------------------------------------------
-- PvP信息：如“爭奪中的領土”、“聯盟領地”等
-- -----------------------------------------------------------------------------

	if (CanSetFont(PVPInfoTextFont)) then				PVPInfoTextFont:SetFont(CLEAR_FONT, 20 * CF_SCALE, "THINOUTLINE"); end		-- 預設值：22


-- -----------------------------------------------------------------------------
-- 錯誤字體："另一個動作正在進行中"等字樣
-- -----------------------------------------------------------------------------

	if (CanSetFont(ErrorFont)) then					ErrorFont:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- 預設值：17
	if (CanSetFont(ErrorFont)) then					ErrorFont:SetShadowOffset(1, -1); end	-- 預設值：(1, -1)


-- -----------------------------------------------------------------------------
-- 狀態欄：頭像框架中的數字（生命值、法力值/怒氣值/能量值等），經驗條（經驗、聲望等）
-- -----------------------------------------------------------------------------

	if (CanSetFont(TextStatusBarText)) then			TextStatusBarText:SetFont(CLEAR_FONT_EXP, 12 * CF_SCALE, "OUTLINE"); end	-- 預設值：12
	if (CanSetFont(TextStatusBarTextLarge)) then		TextStatusBarTextLarge:SetFont(CLEAR_FONT_EXP, 14 * CF_SCALE, "OUTLINE"); end	-- 預設值：15
	

-- -----------------------------------------------------------------------------
-- 戰鬥紀錄文字
-- -----------------------------------------------------------------------------

	if (CanSetFont(CombatLogFont)) then				CombatLogFont:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- 預設值：16


-- -----------------------------------------------------------------------------
-- 提示框（ToolTip）
-- -----------------------------------------------------------------------------

-- 提示框正文
	if (CanSetFont(GameTooltipText)) then				GameTooltipText:SetFont(CLEAR_FONT_ITEM, 13 * CF_SCALE); end		-- 預設值：13
   
-- 裝備比較的小字部分
	if (CanSetFont(GameTooltipTextSmall)) then			GameTooltipTextSmall:SetFont(CLEAR_FONT_ITEM, 12 * CF_SCALE); end	-- 預設值：12
   
-- 提示框標題
	if (CanSetFont(GameTooltipHeaderText)) then		GameTooltipHeaderText:SetFont(CLEAR_FONT, 15 * CF_SCALE, "OUTLINE"); end	-- 預設值：16


-- -----------------------------------------------------------------------------
-- 世界地圖：位置標題
-- -----------------------------------------------------------------------------

	if (CanSetFont(WorldMapTextFont)) then				WorldMapTextFont:SetFont(CLEAR_FONT, 102 * CF_SCALE, "THINOUTLINE"); end	-- 預設值：102
	if (CanSetFont(WorldMapTextFont)) then				WorldMapTextFont:SetShadowColor(1.0, 0.9294, 0.7607); end	-- 預設值：(1.0, 0.9294, 0.7607)
	--if (CanSetFont(WorldMapTextFont)) then				WorldMapTextFont:SetShadowOffset(1, -1); end
--	if (CanSetFont(WorldMapTextFont)) then				WorldMapTextFont:SetAlpha(0.4); end


-- -----------------------------------------------------------------------------
-- 發貨單：拍賣行郵寄來的發貨單
-- -----------------------------------------------------------------------------

	if (CanSetFont(InvoiceTextFontNormal)) then 	   	InvoiceTextFontNormal:SetFont(CLEAR_FONT_QUEST, 13 * CF_SCALE); end	-- 預設值：12
	if (CanSetFont(InvoiceTextFontNormal)) then 	   	InvoiceTextFontNormal:SetTextColor(0.18, 0.12, 0.06); end	-- 預設值：(0.18, 0.12, 0.06)

	if (CanSetFont(InvoiceTextFontSmall)) then			InvoiceTextFontSmall:SetFont(CLEAR_FONT_QUEST, 11 * CF_SCALE); end	-- 預設值：10
	if (CanSetFont(InvoiceTextFontSmall)) then			InvoiceTextFontSmall:SetTextColor(0.18, 0.12, 0.06); end	-- 預設值：(0.18, 0.12, 0.06)


-- -----------------------------------------------------------------------------
-- 戰鬥文字: 暴雪內置戰鬥指示器
-- -----------------------------------------------------------------------------

	if (CanSetFont(CombatTextFont)) then				CombatTextFont:SetFont(CLEAR_FONT_DAMAGE, 25 * CF_SCALE); end		-- 預設值：25


-- -----------------------------------------------------------------------------
-- 影片字幕文字（New in WotLK/3.x）
-- -----------------------------------------------------------------------------

	if (CanSetFont(MovieSubtitleFont)) then			MovieSubtitleFont:SetFont(CLEAR_FONT, 25 * CF_SCALE); end		-- 預設值：25
	if (CanSetFont(MovieSubtitleFont)) then			MovieSubtitleFont:SetTextColor(1.0, 0.78, 0); end	-- 預設值：(1.0, 0.78, 0)


-- -----------------------------------------------------------------------------
-- 成就系統（New in WotLK/3.x）
-- -----------------------------------------------------------------------------

-- 成就系統其他面板上的成就分數
	if (CanSetFont(AchievementPointsFont)) then		AchievementPointsFont:SetFont(CLEAR_FONT, 13 * CF_SCALE); end		-- 預設值：13

-- 成就系統總匯面板的成就分數
	if (CanSetFont(AchievementPointsFontSmall)) then	AchievementPointsFontSmall:SetFont(CLEAR_FONT, 13 * CF_SCALE); end		-- 預設值：13

-- 成就系統描述的內容
	if (CanSetFont(AchievementDescriptionFont)) then	AchievementDescriptionFont:SetFont(CLEAR_FONT, 13 * CF_SCALE); end		-- 預設值：13

-- 成就系統描述的副標題
	if (CanSetFont(AchievementCriteriaFont)) then		AchievementCriteriaFont:SetFont(CLEAR_FONT, 13 * CF_SCALE); end		-- 預設值：13
   
-- 成就系統記錄的日期
	if (CanSetFont(AchievementDateFont)) then			AchievementDateFont:SetFont(CLEAR_FONT, 11 * CF_SCALE); end		-- 預設值：13


-- -----------------------------------------------------------------------------
-- 新騎乘、車輛系統相關（待確認，New in WotLK/3.2+）
-- -----------------------------------------------------------------------------

	if (CanSetFont(VehicleMenuBarStatusBarText)) then		VehicleMenuBarStatusBarText:SetFont(CLEAR_FONT, 15 * CF_SCALE); end		-- 預設值：15
	if (CanSetFont(VehicleMenuBarStatusBarText)) then		VehicleMenuBarStatusBarText:SetTextColor(1.0, 1.0, 1.0); end	-- 預設值：(1.0, 1.0, 1.0)


-- -----------------------------------------------------------------------------
-- 焦點框架字體（待確認，New in CTM/4.0+）
-- -----------------------------------------------------------------------------
	if (CanSetFont(FocusFontSmall)) then				FocusFontSmall:SetFont(CLEAR_FONT, 15 * CF_SCALE); end		-- 預設值：16
end
function Module:WorldStateAlwaysUpFrame_Update()   
   for i = 1, NUM_ALWAYS_UP_UI_FRAMES do   
      _G["AlwaysUpFrame"..i.."Text"]:SetFont(DB.Font, DB.FontSize, "THINOUTLINE")
   end
end
function Module:OnInitialize()
	CF_SCALE = SunUIConfig.db.profile.MiniDB.FontScale*S.Scale(1)
	self:RegisterEvent("ADDON_LOADED", ApplySystemFonts);
	self:SecureHook("WorldStateAlwaysUpFrame_Update", "WorldStateAlwaysUpFrame_Update")
end