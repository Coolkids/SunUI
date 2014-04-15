local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local CT = S:NewModule("Chat", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

CT.modName = L["聊天美化"]
CT.order = 8
local tscol = "64C2F5"						-- Timestamp coloring
local newAddMsg = {}
for i = 1, 18 do
	CHAT_FONT_HEIGHTS[i] = i+6
end

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
---------------- > Channel names
-- Global strings
_G.CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE_CHAT|h".."[I]".."|h %s:\32"
_G.CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE_CHAT|h".."[IL]".."|h %s:\32"
_G.CHAT_GUILD_GET = "|Hchannel:Guild|h".."[G]".."|h %s:\32"
_G.CHAT_OFFICER_GET = "|Hchannel:o|h".."[O]".."|h %s:\32"
_G.CHAT_PARTY_GET = "|Hchannel:Party|h".."[P]".."|h %s:\32"
_G.CHAT_PARTY_GUIDE_GET = "|Hchannel:party|h".."[P]".."|h %s:\32"
_G.CHAT_PARTY_LEADER_GET = "|Hchannel:party|h".."[P]".."|h %s:\32"
_G.CHAT_RAID_GET = "|Hchannel:raid|h".."[R]".."|h %s:\32"
_G.CHAT_RAID_LEADER_GET = "|Hchannel:raid|h".."[R]".."|h %s:\32"
_G.CHAT_RAID_WARNING_GET = "[W]".." %s:\32"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_YELL_GET = "%s:\32"

_G.CHAT_FLAG_AFK = "|cffFF0000".."[AFK]".."|r "
_G.CHAT_FLAG_DND = "|cffE7E716".."[DND]".."|r "
_G.CHAT_FLAG_GM = "|cff4154F5".."[GM]".."|r "
 
-------------- > Custom timestamps color

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

--new
--美化
local tabs = {"Left", "Middle", "Right", "SelectedLeft", "SelectedMiddle",
    "SelectedRight", "Glow", "HighlightLeft", "HighlightMiddle", 
    "HighlightRight"}
local function ApplyChatStyle(self)
	local A = S:GetModule("Skins")
	if self == "PET_BATTLE_COMBAT_LOG" then self = ChatFrame11 end
	if not self or (self and self.skinApplied) then return end

	local cf = self:GetName()
    local tex = ({_G[cf..'EditBox']:GetRegions()})
    _G[cf]:SetClampedToScreen(false)
    _G[cf..'ButtonFrame'].Show = _G[cf..'ButtonFrame'].Hide 
    _G[cf..'ButtonFrame']:Hide()
    
    _G[cf..'EditBox']:SetAltArrowKeyMode(false)
    _G[cf..'EditBox']:ClearAllPoints()
    _G[cf..'EditBox']:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', 0, 21)
    _G[cf..'EditBox']:SetPoint('TOPRIGHT', _G.ChatFrame1, 'TOPRIGHT', 6, 45)
	A:CreateBD(_G[cf..'EditBox'])
	_G[cf..'EditBox']:Hide()
    _G[cf..'EditBox']:HookScript("OnEditFocusGained", function(self) self:Show() end)
	_G[cf..'EditBox']:HookScript("OnEditFocusLost", function(self) self:Hide() end)
	_G[cf..'EditBox']:FontTemplate()
    _G[cf..'EditBoxHeader']:SetShadowOffset(0, 0)
    _G[cf.."EditBoxLanguage"]:ClearAllPoints()
	_G[cf.."EditBoxLanguage"]:SetPoint("LEFT", _G[cf.."EditBox"], "RIGHT", 5, 0)
	_G[cf.."EditBoxLanguage"]:SetSize(_G[cf.."EditBox"]:GetHeight(),_G[cf.."EditBox"]:GetHeight())
	_G[cf.."EditBoxLanguage"]:StripTextures()
	A:CreateBD(_G[cf.."EditBoxLanguage"], 0.6)
	if CT.db.ChatEditBoxColor then
		hooksecurefunc("ChatEdit_UpdateHeader", function()
			local type = _G[cf..'EditBox']:GetAttribute("chatType")
			if ( type == "CHANNEL" ) then
				local id = _G[cf..'EditBox']:GetAttribute("channelTarget")
				if id == 0 then
					_G[cf..'EditBox']:SetBackdropBorderColor(0, 0, 0)
				else
					_G[cf..'EditBox']:SetBackdropBorderColor(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
				end
			else
				_G[cf..'EditBox']:SetBackdropBorderColor(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
			end
		end)
	end
	_G[cf.."Tab"]:HookScript("OnClick", function() _G[cf.."EditBox"]:Hide() end)
    tex[6]:SetAlpha(0) tex[7]:SetAlpha(0) tex[8]:SetAlpha(0) tex[9]:SetAlpha(0) tex[10]:SetAlpha(0) tex[11]:SetAlpha(0)
    local bb = _G[cf.."ButtonFrameBottomButton"]
	local flash = _G[cf.."ButtonFrameBottomButtonFlash"]
	A:ReskinArrow(bb, "down")
	if _G[cf] == _G["ChatFrame2"] then
		_G["CombatLogQuickButtonFrame_Custom"]:StripTextures()
		local cb = _G["CombatLogQuickButtonFrame_CustomAdditionalFilterButton"]
		cb:SetSize(16, 16)
		A:ReskinArrow(cb, "down")
	end
	bb:SetParent(_G[cf])
	bb:SetFrameStrata("MEDIUM")
	bb:SetHeight(16)
	bb:SetWidth(16)
	bb:ClearAllPoints()
	bb:SetPoint("TOPRIGHT", _G[cf], "TOPRIGHT", -5, -5)
	flash:ClearAllPoints()
	flash:SetPoint("TOPLEFT", -3, 3)
	flash:SetPoint("BOTTOMRIGHT", 3, -3)
	bb:SetAlpha(1)
	bb:SetScript("OnClick", function(self)
		self:GetParent():ScrollToBottom()
	end)
    
    for g = 1, #CHAT_FRAME_TEXTURES do
        _G[cf..CHAT_FRAME_TEXTURES[g]]:SetTexture(nil)
    end
    for index, value in pairs(tabs) do
        local texture = _G[cf..'Tab'..value]
        texture:SetTexture(nil)
    end
	_G[cf.."TabText"]:SetTextColor(0.40, 0.78, 1) -- 1,.7,.2
	_G[cf.."TabText"].SetTextColor = function() end
	_G[cf.."TabText"]:FontTemplate()
    if cf ~= "ChatFrame2" then
		local am = _G[cf].AddMessage 
		_G[cf].AddMessage = function(frame, text, ...) 
			return am(frame, text:gsub('|h%[(%d+)%. .-%]|h', '|h%[%1%]|h'), ...)
		end 
	end
	self.skinApplied = true
end

function CT:ChatFix()
	ChatFrameMenuButton:Kill()
	FriendsMicroButton:Kill()
	FloatingChatFrame_OnMouseScroll = function(self, dir)
    if(dir > 0) then
        if(IsShiftKeyDown()) then
            self:ScrollToTop() else self:ScrollUp() end
    else if(IsShiftKeyDown()) then 
        self:ScrollToBottom() else self:ScrollDown() end
    end
end
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
end
----------------------------------------------------------------------------------------
--	Copy Chat
----------------------------------------------------------------------------------------
local lines = {}
local frame = nil
local editBox = nil
local isf = nil
local sizes = {
	":14:14",
	":15:15",
	":16:16",
	":12:20",
	":14"
}

local function CreatCopyFrame()
	local A = S:GetModule("Skins")
	frame = CreateFrame("Frame", "CopyFrame", UIParent)
	frame:SetWidth(500)
	frame:SetHeight(300)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:SetFrameStrata("DIALOG")
	tinsert(UISpecialFrames, "CopyFrame")
	--frame:Hide()
	frame:SetMovable(true)
	--frame:RegisterForClicks"anyup"
	frame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
	frame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
	frame:RegisterForDrag("LeftButton")
	if not frame.style then
		A:SetBD(frame)
		frame.style = true
	end
	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)
	A:ReskinScroll(CopyScrollScrollBar)
	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetPoint("CENTER", frame)
	editBox:SetWidth(500)
	editBox:SetHeight(300)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	editBox:SetScript("OnTextSet", function(self)
		local text = self:GetText()

		for _, size in pairs(sizes) do
			if string.find(text, size) and not string.find(text, size.."]") then
				self:SetText(string.gsub(text, size, ":12:12"))
			end
		end
	end)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)
	A:ReskinClose(close)
	isf = true
end

local function GetLines(...)
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(p)
	cf = _G[format("%s%d", "ChatFrame", p:GetID())]
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	if size < 11 then
		FCF_SetChatWindowFontSize(cf, cf, 11)
	else
		FCF_SetChatWindowFontSize(cf, cf, size)
	end
	if not isf then CreatCopyFrame() end
	if CopyFrame:IsShown() then CopyFrame:Hide() return end
	CopyFrame:Show()
	editBox:SetText(text)
end

function CT:PLAYER_ENTERING_WORLD()
	for i = 1, NUM_CHAT_WINDOWS do
		ApplyChatStyle(_G["ChatFrame"..i])
	end
	hooksecurefunc("FCF_OpenTemporaryWindow", ApplyChatStyle)
	self:UpdateChatbar()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function CT:GetOptions()
	local options = {
		DNDFilter = {
			type = "toggle", order = 1,
			name = L["屏蔽DND消息"],
		},
		TimeStamps = {
			type = "toggle", order = 2,
			name = L["时间戳"],
		},
		ChatBackground = {
			type = "toggle", order = 3,
			name = L["聊天框背景"],
		},
		ChatEditBoxColor = {
			type = "toggle", order = 4,
			name = L["输入框边框染色"],
		},
		ChannelBar = {
			type = "toggle", order = 5,
			name = L["频道栏"],
			set = function(info, value) 
				self.db.ChannelBar = value
				self:UpdateChatbar()
			end,
		},
		ChatFilter = {
			type = "toggle", order = 6,
			name = L["聊天过滤"],
		},
	}
	return options
end

function CT:Initialize()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	
	if self.db.DNDFilter then  
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)
	end
	if self.db.TimeStamps then 
		if GetCVar("showTimestamps") == "none" then  
			SetCVar("showTimestamps", [[%H:%M:%S]])
		end
	else
		SetCVar("showTimestamps", "none")
	end
	if self.db.ChatBackground then 
		local A = S:GetModule("Skins")
		for i = 1, NUM_CHAT_WINDOWS do
			local cf = _G['ChatFrame'..i]
			if cf then
				A:SetBD(cf)
			end
		end
	end
	
	for i = 1, 10 do
		local tab = _G[format("%s%d%s", "ChatFrame", i, "Tab")]
		tab:SetScript("OnDoubleClick", Copy)
		tab:HookScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:AddLine(L["双击聊天标签"])
			GameTooltip:AddLine(L["来复制聊天信息"])
			GameTooltip:Show()  
		end)
		tab:HookScript("OnLeave", function() 
			GameTooltip:Hide()
		end)
	end
	self:ChatFix()
	self:UpdateChatbar()
	self:InitChatFilter()
	self:initTabChannel()
end
S:RegisterModule(CT:GetName())