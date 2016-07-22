local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local CT = S:NewModule("Chat", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

CT.modName = L["聊天美化"]
CT.order = 8

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
--时间戳颜色
TIMESTAMP_FORMAT_HHMM = "|cff64C2F5[%I:%M]|r "
TIMESTAMP_FORMAT_HHMMSS = "|cff64C2F5[%I:%M:%S]|r "
TIMESTAMP_FORMAT_HHMMSS_24HR = "|cff64C2F5[%H:%M:%S]|r "
TIMESTAMP_FORMAT_HHMMSS_AMPM = "|cff64C2F5[%I:%M:%S %p]|r "
TIMESTAMP_FORMAT_HHMM_24HR = "|cff64C2F5[%H:%M]|r "
TIMESTAMP_FORMAT_HHMM_AMPM = "|cff64C2F5[%I:%M %p]|r "
local function toggleDown(f)
	if f:GetCurrentScroll() > 0 then
		_G[f:GetName().."ButtonFrameBottomButton"]:Show()
	else
		_G[f:GetName().."ButtonFrameBottomButton"]:Hide()
	end
end

local function ApplyChatStyle(self)
	if self == "PET_BATTLE_COMBAT_LOG" then self = ChatFrame11 end
	local f = self:GetName()
	if self.reskinned then return end
	self.reskinned = true
	local A = S:GetModule("Skins")

	self:HookScript("OnMessageScrollChanged", toggleDown)
	self:HookScript("OnShow", toggleDown)
	self:SetClampedToScreen(false)
	self:SetFading(true)

	--self:SetShadowOffset(0, 0, 0, 0)

	self:SetMinResize(0,0)
	self:SetMaxResize(0,0)

	self.editBox:ClearAllPoints()
	self.editBox:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', 0, 21)
    self.editBox:SetPoint('TOPRIGHT', ChatFrame1, 'TOPRIGHT', 6, 45)
	self.editBox:SetFont(S["media"].font, 12, "THINOUTLINE")
	self.editBox.header:SetFont(S["media"].font, 12, "THINOUTLINE")
	self.editBox.header:SetShadowColor(0, 0, 0, 0)
	self.editBox:SetShadowColor(0, 0, 0, 0)
	self.editBox:SetAltArrowKeyMode(nil)
	self.editBox:Hide()
	self.editBox:HookScript("OnEditFocusGained", function(self) self:Show() end)
	self.editBox:HookScript("OnEditFocusLost", function(self) self:Hide() end)
	_G[f.."Tab"]:HookScript("OnClick", function() _G[f.."EditBox"]:Hide() end)
	
	_G[f.."EditBoxLanguage"]:SetPoint("LEFT", _G[f.."EditBox"], "RIGHT", 5, 0)
	_G[f.."EditBoxLanguage"]:SetSize(_G[f.."EditBox"]:GetHeight(),_G[f.."EditBox"]:GetHeight())
	_G[f.."EditBoxLanguage"]:StripTextures()
	A:CreateBD(_G[f.."EditBoxLanguage"], 0.6)
	local x=({_G[f.."EditBox"]:GetRegions()})
	for i=5,#x do
    x[i]:SetAlpha(0)
	end

	A:CreateBD(self.editBox)

	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[f..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end

	--Hide the new editbox "ghost"
	_G[f.."EditBoxLeft"]:SetAlpha(0)
	_G[f.."EditBoxRight"]:SetAlpha(0)
	_G[f.."EditBoxMid"]:SetAlpha(0)

	--self:SetClampRectInsets(0, 0, 0, 0)
	--按钮
	_G[f..'ButtonFrame'].Show = _G[f..'ButtonFrame'].Hide
    _G[f..'ButtonFrame']:Hide()
	
	local bb = _G[f.."ButtonFrameBottomButton"]
	local flash = _G[f.."ButtonFrameBottomButtonFlash"]
	A:ReskinArrow(bb, "down")
	bb:SetParent(self)
	bb:ClearAllPoints()
	bb:Hide()
	bb:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -20)
	bb.SetPoint = S.dummy
	flash:Kill()
	bb:SetScript("OnClick", function(self) 
		self:GetParent():ScrollToBottom()
        self:Hide() 
	end)
	--频道
    if f ~= "ChatFrame2" then
		local am = _G[f].AddMessage 
		_G[f].AddMessage = function(self, text, ...) 
			return am(self, text:gsub('|h%[(%d+)%. .-%]|h', '|h%[%1%]|h'), ...)
		end 
	end
	--战斗记录部分
	if self == ChatFrame2 then
		_G["CombatLogQuickButtonFrame_Custom"]:StripTextures()
	end
	
	--标签美化
	_G[f.."TabText"]:SetTextColor(0.40, 0.78, 1) -- 1,.7,.2
	_G[f.."TabText"].SetTextColor = function() end
	_G[f.."TabText"]:FontTemplate(nil,nil,"THINOUTLINE")
end
function CT:ChatEditBoxColor()
	if self.db.ChatEditBoxColor then
		for i = 1, NUM_CHAT_WINDOWS do
			local cf = _G["ChatFrame"..i]:GetName()
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
	end
end
function CT:ChatFix()
	ChatFrameMenuButton:Kill()
	FriendsMicroButton:Kill()
	--GeneralDockManager:Kill()
	--GeneralDockManager:SetParent(S.HiddenFrame)
	--GeneralDockManagerScrollFrame:SetScript("OnShow", function(self) self:Hide() end)
	--GeneralDockManagerScrollFrame:SetSize(0.001,0.001)
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
-- Colour real ID links

local function GetLinkColor(data)
	local type, id, arg1 = string.match(data, '(%w+):(%d+)')
	if(type == 'item') then
		local _, _, quality = GetItemInfo(id)
		if(quality) then
			local _, _, _, hex = GetItemQualityColor(quality)
			return '|c' .. hex
		else
			-- Item is not cached yet, show a white color instead
			-- Would like to fix this somehow
			return '|cffffffff'
		end
	elseif(type == 'quest') then
		local _, _, level = string.match(data, '(%w+):(%d+):(%d+)')
		if not level then level = UnitLevel("player") end -- fix for account wide quests
		local color = GetQuestDifficultyColor(level)
		return format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
	elseif(type == 'spell') then
		return '|cff71d5ff'
	elseif(type == 'achievement') then
		return '|cffffff00'
	elseif(type == 'trade' or type == 'enchant') then
		return '|cffffd000'
	elseif(type == 'instancelock') then
		return '|cffff8000'
	elseif(type == 'glyph' or type == 'journal') then
		return '|cff66bbff'
	elseif(type == 'talent') then
		return '|cff4e96f7'
	elseif(type == 'levelup') then
		return '|cffFF4E00'
	else
		return '|cffffffff'
	end
end

local function AddLinkColors(self, event, msg, ...)
	local data = string.match(msg, '|H(.-)|h(.-)|h')
	if(data) then
		local newmsg = string.gsub(msg, '|H(.-)|h(.-)|h', GetLinkColor(data) .. '|H%1|h%2|h|r')
		return false, newmsg, ...
	else
		return false, msg, ...
	end
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
	self:ChatEditBoxColor()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER', AddLinkColors)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER_INFORM', AddLinkColors)
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
			SetCVar("showTimestamps", TIMESTAMP_FORMAT_HHMMSS)
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
	self:ccfInitialize()
end
S:RegisterModule(CT:GetName())