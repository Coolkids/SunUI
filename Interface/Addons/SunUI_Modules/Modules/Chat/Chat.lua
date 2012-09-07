local S, C, L, DB = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Chat", "AceEvent-3.0")
 local _G = _G
function Module:OnEnable()
-- 聊天设置	
local fontsize = 10                          --other variables
local tscol = "64C2F5"						-- Timestamp coloring
local TimeStampsCopy = C["MiniDB"]["TimeStamps"]					-- 时间戳

	for i = 1, 25 do
		CHAT_FONT_HEIGHTS[i] = i+4
	end
	local LinkHover = {}; LinkHover.show = {	-- enable (true) or disable (false) LinkHover functionality for different things in chat
		["achievement"] = true,
		["enchant"]     = true,
		["glyph"]       = true,
		["item"]        = true,
		["quest"]       = true,
		["spell"]       = true,
		["talent"]      = true,
		["unit"]        = true,}

	-- 打开输入框回到上次对话
	ChatTypeInfo.SAY.sticky = 0
	ChatTypeInfo.EMOTE.sticky = 0
	ChatTypeInfo.YELL.sticky = 0
	ChatTypeInfo.PARTY.sticky = 1
	ChatTypeInfo.RAID.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.GUILD.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 0
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
	ChatTypeInfo.BN_WHISPER.sticky = 0

	-------------- > Custom timestamps color
	do
		ChatFrame2ButtonFrameBottomButton:RegisterEvent("PLAYER_LOGIN")
		ChatFrame2ButtonFrameBottomButton:SetScript("OnEvent", function(f)
			TIMESTAMP_FORMAT_HHMM = "|cff"..tscol.."[%I:%M]|r "
			TIMESTAMP_FORMAT_HHMMSS = "|cff"..tscol.."[%I:%M:%S]|r "
			TIMESTAMP_FORMAT_HHMMSS_24HR = "|cff"..tscol.."[%H:%M:%S]|r "
			TIMESTAMP_FORMAT_HHMMSS_AMPM = "|cff"..tscol.."[%I:%M:%S %p]|r "
			TIMESTAMP_FORMAT_HHMM_24HR = "|cff"..tscol.."[%H:%M]|r "
			TIMESTAMP_FORMAT_HHMM_AMPM = "|cff"..tscol.."[%I:%M %p]|r "
			f:UnregisterEvent("PLAYER_LOGIN")
			f:SetScript("OnEvent", nil)
		end)
	end

	---------------- > 渐隐透明度
	CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
	CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0

	local function kill(f)
		if f.UnregisterAllEvents then
			f:UnregisterAllEvents()
		end
		f:Hide()
	end
	
	do
		-- Buttons Hiding/moving 
		--local kill = function(f) f:Hide() end
		ChatFrameMenuButton:Hide()
		ChatFrameMenuButton:SetScript("OnShow", kill)
		FriendsMicroButton:Hide()
		FriendsMicroButton:SetScript("OnShow", kill)

		for i = 1, NUM_CHAT_WINDOWS do
			local cf = _G['ChatFrame'..i]
			cf:SetFading(true)  --渐隐
			if cf then 
				S.CreateBD(cf, .6)
			end
			--EditBox Module
			local ebParts = {'Left', 'Mid', 'Right'}
			local eb = _G['ChatFrame'..i..'EditBox']
			for _, ebPart in ipairs(ebParts) do
				_G['ChatFrame'..i..'EditBox'..ebPart]:SetTexture(nil)
				local ebed = _G['ChatFrame'..i..'EditBoxFocus'..ebPart]
				ebed:SetTexture(nil)
				ebed:SetHeight(18)
			end
			eb:SetAltArrowKeyMode(false)
			eb:ClearAllPoints()
			eb:Point("BOTTOMLEFT", cf, "TOPLEFT",  0, 3)
			eb:Point("BOTTOMRIGHT", cf, "TOPRIGHT", 0, 3)
			eb:SetHeight(18)
			S.CreateBD(eb, 0.6)
			
			local chat = format("ChatFrame%s",i)
			_G[chat.."EditBoxLanguage"]:ClearAllPoints()
			_G[chat.."EditBoxLanguage"]:SetPoint("LEFT", _G[chat.."EditBox"], "RIGHT", S.Scale(5), 0)
			_G[chat.."EditBoxLanguage"]:SetSize(_G[chat.."EditBox"]:GetHeight(),_G[chat.."EditBox"]:GetHeight())
			_G[chat.."EditBoxLanguage"]:StripTextures()
			S.CreateBD(_G[chat.."EditBoxLanguage"], 0.6)
			_G['ChatFrame'..i..'EditBox']:HookScript("OnEditFocusGained", function(self) self:Show() end)
			_G['ChatFrame'..i..'EditBox']:HookScript("OnEditFocusLost", function(self) self:Hide() end)
			local a = CreateFrame("Frame",nil,WorldFrame)
			a:RegisterEvent("PLAYER_ENTERING_WORLD") 
			a:SetScript("OnEvent",function(self,event,...) 
				if(event == "PLAYER_ENTERING_WORLD") then
					_G['ChatFrame'..i..'EditBox']:SetAlpha(0) 
				end 
			end)
	
		--Remove scroll buttons
			local bf = _G['ChatFrame'..i..'ButtonFrame']
			bf:Hide()
			bf:SetScript("OnShow",  kill)
		
		--Scroll to the bottom button
			local function BottomButtonClick(self)
				self:GetParent():ScrollToBottom();
			end
			local bb = _G["ChatFrame"..i.."ButtonFrameBottomButton"]
			bb:SetParent(_G["ChatFrame"..i])
			bb:SetHeight(18)
			bb:SetWidth(18)
			bb:ClearAllPoints()
			bb:SetPoint("TOPRIGHT", cf, "TOPRIGHT", 0, -6)
			bb:SetAlpha(0.4)
			--bb.SetPoint = function() end
			bb:SetScript("OnClick", BottomButtonClick)
			
		--fix fading
			cf:SetFading(false)
			--cf:SetClampRectInsets(0,0,0,0)
			local tab = _G["ChatFrame"..i.."Tab"]
				tab:SetAlpha(1)
				--if tab:GetAlpha() ~= 0 then tab.SetAlpha = UIFrameFadeRemoveFrame end
				_G["ChatFrame"..i.."TabText"]:SetTextColor(0.40, 0.78, 1) -- 1,.7,.2
				_G["ChatFrame"..i.."TabText"].SetTextColor = function() end
				_G["ChatFrame"..i.."TabText"]:SetFont(DB.Font,12,"THINOUTLINE")
				_G["ChatFrame"..i.."TabText"]:SetShadowOffset(1.75, -1.75)
				
				kill(_G[format("ChatFrame%sTabLeft", i)])
				kill(_G[format("ChatFrame%sTabMiddle", i)])
				kill(_G[format("ChatFrame%sTabRight", i)])
				kill(_G[format("ChatFrame%sTabSelectedLeft", i)])
				kill(_G[format("ChatFrame%sTabSelectedMiddle", i)])
				kill(_G[format("ChatFrame%sTabSelectedRight", i)])
				kill(_G[format("ChatFrame%sTabHighlightLeft", i)])
				kill(_G[format("ChatFrame%sTabHighlightMiddle", i)])
				kill(_G[format("ChatFrame%sTabHighlightRight", i)])
				kill(_G[format("ChatFrame%sTabSelectedLeft", i)])
				kill(_G[format("ChatFrame%sTabSelectedMiddle", i)])
				kill(_G[format("ChatFrame%sTabSelectedRight", i)])
				kill(_G[format("ChatFrame%sTabGlow", i)])
				
				tab.leftSelectedTexture:Hide()
				tab.middleSelectedTexture:Hide()
				tab.rightSelectedTexture:Hide()
				tab.leftSelectedTexture.Show = tab.leftSelectedTexture.Hide
				tab.middleSelectedTexture.Show = tab.middleSelectedTexture.Hide
				tab.rightSelectedTexture.Show = tab.rightSelectedTexture.Hide
				tab:SetAlpha(0)
				tab.noMouseAlpha = 0
				
		-- Hide chat textures
			for j = 1, #CHAT_FRAME_TEXTURES do
				_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
			end
		--Unlimited chatframes resizing
			cf:SetMinResize(0,0)
			cf:SetMaxResize(0,0)
		
		--Allow the chat frame to move to the end of the screen
			cf:SetClampedToScreen(true)
			cf:SetClampRectInsets(0,0,0,0)
		end
	end

	---------------- > Channel names
	local gsub = _G.string.gsub
	local time = _G.time
	local newAddMsg = {}

	local chn, rplc
	do
		rplc = {
			L["综合"], --General
			L["交易"], --Trade
			L["世界防务"], --WorldDefense
			L["本地防御"], --LocalDefense
			L["寻求组队"], --LookingForGroup
			L["工会招募"], --GuildRecruitment
			L["战场"], --Battleground
			L["战场领袖"], --Battleground Leader
			L["工会"], --Guild
			L["小队"], --Party
			L["小队队长"], --Party Leader
			L["地城领袖"], --Party Leader (Guide)
			L["官员"], --Officer
			L["团队"], --Raid
			L["团队领袖"], --Raid Leader
			L["团队警告"], --Raid Warning
		}
		chn = {
			"%[%d+%. General.-%]",
			"%[%d+%. Trade.-%]",
			"%[%d+%. WorldDefense%]",
			"%[%d+%. LocalDefense.-%]",
			"%[%d+%. LookingForGroup%]",
			"%[%d+%. GuildRecruitment.-%]",
			gsub(CHAT_BATTLEGROUND_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_BATTLEGROUND_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_GUILD_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_PARTY_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_PARTY_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_PARTY_GUIDE_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_OFFICER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_RAID_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_RAID_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_RAID_WARNING_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		}
		local Lo = GetLocale()
		if Lo == "ruRU" then --Russian
			chn[1] = "%[%d+%. Общий.-%]"
			chn[2] = "%[%d+%. Торговля.-%]"
			chn[3] = "%[%d+%. Оборона: глобальный%]" --Defense: Global
			chn[4] = "%[%d+%. Оборона.-%]" --Defense: Zone
			chn[5] = "%[%d+%. Поиск спутников%]"
			chn[6] = "%[%d+%. Гильдии.-%]"
		elseif L == "deDE" then --German
			chn[1] = "%[%d+%. Allgemein.-%]"
			chn[2] = "%[%d+%. Handel.-%]"
			chn[3] = "%[%d+%. Weltverteidigung%]"
			chn[4] = "%[%d+%. LokaleVerteidigung.-%]"
			chn[5] = "%[%d+%. SucheNachGruppe%]"
			chn[6] = "%[%d+%. Gildenrekrutierung.-%]"
		end
	end
	local function AddMessage(frame, text, ...)
		for i = 1, 16 do
			text = gsub(text, chn[i], rplc[i])
		end
		--If Blizz timestamps is enabled, stamp anything it misses
		if CHAT_TIMESTAMP_FORMAT and not text:find("|r") then
			text = BetterDate(CHAT_TIMESTAMP_FORMAT, time())..text
		end
		text = gsub(text, "%[(%d0?)%. .-%]", "[%1]") --custom channels
		return newAddMsg[frame:GetName()](frame, text, ...)
	end
	do
		for i = 1, 5 do
			if i ~= 2 then -- skip combatlog
				local f = _G[format("%s%d", "ChatFrame", i)]
				newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
				f.AddMessage = AddMessage
			end
		end
	end
	---------------- > Enable/Disable mouse for editbox
	eb_mouseon = function()
		for i =1, 10 do
			local eb = _G['ChatFrame'..i..'EditBox']
			eb:EnableMouse(true)
		end
	end
	eb_mouseoff = function()
		for i =1, 10 do
			local eb = _G['ChatFrame'..i..'EditBox']
			eb:EnableMouse(false)
		end
	end
	hooksecurefunc("ChatFrame_OpenChat",eb_mouseon)
	hooksecurefunc("ChatEdit_SendText",eb_mouseoff)

	---------------- > Show tooltips when hovering a link in chat (credits to Adys for his LinkHover)
	function LinkHover.OnHyperlinkEnter(_this, linkData, link)
		local t = linkData:match("^(.-):")
		if LinkHover.show[t] and IsAltKeyDown() then
			ShowUIPanel(GameTooltip)
			GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
			GameTooltip:SetHyperlink(link)
			GameTooltip:Show()
		end
	end
	function LinkHover.OnHyperlinkLeave(_this, linkData, link)
		local t = linkData:match("^(.-):")
		if LinkHover.show[t] then
			HideUIPanel(GameTooltip)
		end
	end
	local function LinkHoverOnLoad()
		for i = 1, NUM_CHAT_WINDOWS do
			local f = _G["ChatFrame"..i]
			f:SetScript("OnHyperlinkEnter", LinkHover.OnHyperlinkEnter)
			f:SetScript("OnHyperlinkLeave", LinkHover.OnHyperlinkLeave)
		end
	end
	LinkHoverOnLoad()

	---------------- > Chat Scroll Module
	hooksecurefunc('FloatingChatFrame_OnMouseScroll', function(self, dir)
		if dir > 0 then
			if IsShiftKeyDown() then
				self:ScrollToTop()
			elseif IsControlKeyDown() then
				--only need to scroll twice because of blizzards scroll
				self:ScrollUp()
				self:ScrollUp()
			end
		elseif dir < 0 then
			if IsShiftKeyDown() then
				self:ScrollToBottom()
			elseif IsControlKeyDown() then
				--only need to scroll twice because of blizzards scroll
				self:ScrollDown()
				self:ScrollDown()
			end
		end
	end)

	---------------- > afk/dnd msg filter
	if C["MiniDB"]["DNDFilter"] then  
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
		-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(msg) return true end)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)
	end

	---------------- > Batch ChatCopy Module
	local lines = {}
	do
		--Create Frames/Objects
		local frame = CreateFrame("Frame", "BCMCopyFrame", UIParent)
		frame:SetWidth(600)
		frame:SetHeight(500)
		frame:SetPoint("CENTER", UIParent, "CENTER")
		frame:Hide()
		frame:SetFrameStrata("DIALOG")
		if not frame.style then 
			S.SetBD(frame)
			frame.style = true
		end
		local scrollArea = CreateFrame("ScrollFrame", "BCMCopyScroll", frame, "UIPanelScrollFrameTemplate")
		scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
		scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)
		
		local editBox = CreateFrame("EditBox", "BCMCopyBox", frame)
		editBox:SetMultiLine(true)
		editBox:SetMaxLetters(99999)
		editBox:EnableMouse(true)
		editBox:SetAutoFocus(false)
		editBox:SetFontObject(ChatFontNormal)
		editBox:SetWidth(400)
		editBox:SetHeight(270)
		editBox:SetScript("OnEscapePressed", function(f) f:GetParent():GetParent():Hide() f:SetText("") end)
		scrollArea:SetScrollChild(editBox)
		
		
		local close = CreateFrame("Button", "BCMCloseButton", frame, "UIPanelCloseButton")
		close:SetSize(20, 20)
		close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
		S.ReskinClose(close)
		local copyFunc = function(frame, btn)
			local cf = _G[format("%s%d", "ChatFrame", frame:GetID())]
			local _, size = cf:GetFont()
			FCF_SetChatWindowFontSize(cf, cf, 0.01)
			local ct = 1
			for i = select("#", cf:GetRegions()), 1, -1 do
				local region = select(i, cf:GetRegions())
				if region:GetObjectType() == "FontString" then
					lines[ct] = tostring(region:GetText())
					ct = ct + 1
				end
			end
			local lineCt = ct - 1
			local text = table.concat(lines, "\n", 1, lineCt)
			FCF_SetChatWindowFontSize(cf, cf, size)
			BCMCopyFrame:Show()
			BCMCopyBox:SetText(text)
			BCMCopyBox:HighlightText(0)
			wipe(lines)
		end
		local hintFunc = function(frame)
			GameTooltip:SetOwner(frame, "ANCHOR_TOP")
			if SHOW_NEWBIE_TIPS == "1" then
				GameTooltip:AddLine(CHAT_OPTIONS_LABEL, 1, 1, 1)
				GameTooltip:AddLine(NEWBIE_TOOLTIP_CHATOPTIONS, nil, nil, nil, 1)
			end
			GameTooltip:AddLine((SHOW_NEWBIE_TIPS == "1" and "\n" or "").."雙擊標籤複製", 1, 1, 1)
			GameTooltip:Show()
		end
		for i = 1, 10 do
			local tab = _G[format("%s%d%s", "ChatFrame", i, "Tab")]
			tab:SetScript("OnDoubleClick", copyFunc)
			tab:SetScript("OnEnter", hintFunc)
		end
		BCMCopyScrollScrollBar:StripTextures()
		S.ReskinScroll(BCMCopyScrollScrollBar)
	end


	---------------- > Per-line chat copy via time stamps
	if TimeStampsCopy then
		local AddMsg = {}
		local AddMessage = function(frame, text, ...)
			text = string.gsub(text, "%[(%d+)%. .-%]", "[%1]")
			text = ('|cffffffff|Hm_Chat|h|r%s|h %s'):format('|cff'..tscol..''..date('%H:%M')..'|r', text)
			return AddMsg[frame:GetName()](frame, text, ...)
		end
		for i = 1, 10 do
			if i ~= 2 then
				AddMsg["ChatFrame"..i] = _G["ChatFrame"..i].AddMessage
				_G["ChatFrame"..i].AddMessage = AddMessage
			end
		end
	end
end