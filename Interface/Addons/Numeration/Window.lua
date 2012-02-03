local F, C = unpack(Aurora)
local addon = select(2, ...)
function MakeShadow(Parent, Size)
	local Shadow = CreateFrame("Frame", nil, Parent)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Size, -Size)
	Shadow:SetPoint("TOPRIGHT", Size, Size)
	Shadow:SetPoint("BOTTOMLEFT", -Size, -Size)
	Shadow:SetBackdrop({edgeFile = "Interface\\Addons\\s_Core\\Media\\glowTex", edgeSize = Size})
	Shadow:SetBackdropColor( .05, .05, .05, .9)
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end
local window = CreateFrame("Frame", "NumerationFrame", UIParent)
window.bg = CreateFrame("Frame", nil, window)
window.bg:SetFrameLevel(1)
window.bg:SetFrameStrata(window:GetFrameStrata())
window.bg:SetPoint("TOPLEFT")
window.bg:SetPoint("BOTTOMRIGHT")
window.bg:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground", 
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", 
	edgeSize = 1,
})
window.bg:SetBackdropColor( 0, 0, 0, 0.6 )
window.bg:SetBackdropBorderColor( .05,.05,.05, .9 )
addon.window = window
MakeShadow(window, 3)
local lines = {}

local noop = function() end
local backAction = noop
local reportAction = noop
local backdrop = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "", tile = true, tileSize = 16, edgeSize = 0,
	insets = { left = 0, right = 0, top = 0, bottom = 0 }
}
local clickFunction = function(self, btn)
	if btn == "LeftButton" then
		self.detailAction(self)
	elseif btn == "RightButton" then
		backAction(self)
	elseif btn == "MiddleButton" then
		reportAction(self.num)
	end
end

local optionFunction = function(f, id, _, checked)
	addon:SetOption(id, checked)
end
local numReports = 9
local reportFunction = function(f, chatType, channel)
	addon:Report(numReports, chatType, channel)
	CloseDropDownMenus()
end
local dropdown = CreateFrame("Frame", "NumerationMenuFrame", nil, "UIDropDownMenuTemplate")
MakeShadow(dropdown, 3)
local menuTable = {
	{ text = "Numeration", isTitle = true, notCheckable = true, notClickable = true },
	{ text = "报告", notCheckable = true, hasArrow = true,
		menuList = {
			{ text = "报告", isTitle = true, notCheckable = true, notClickable = true },
			{ text = SAY, arg1 = "SAY", func = reportFunction, notCheckable = 1 },
			{ text = RAID, arg1 = "RAID", func = reportFunction, notCheckable = 1 },
			{ text = PARTY, arg1 = "PARTY", func = reportFunction, notCheckable = 1 },
			{ text = GUILD, arg1 = "GUILD", func = reportFunction, notCheckable = 1 },
			{ text = OFFICER, arg1 = "OFFICER", func = reportFunction, notCheckable = 1 },
			{ text = WHISPER, func = function() window:ShowWhisperWindow() end, notCheckable = 1 },
			{ text = CHANNEL, notCheckable = 1, keepShownOnClick = true, hasArrow = true, menuList = {} }
		},
	},
	{ text = "选项", notCheckable = true, hasArrow = true,
		menuList = {
			{ text = "合并宠物伤害", arg1 = "petsmerged", func = optionFunction, checked = function() return addon:GetOption("petsmerged") end, keepShownOnClick = true },
			{ text = "仅保留BOSS数据", arg1 = "keeponlybosses", func = optionFunction, checked = function() return addon:GetOption("keeponlybosses") end, keepShownOnClick = true },
			{ text = "仅在副本中统计", arg1 = "onlyinstance", func = optionFunction, checked = function() return addon:GetOption("onlyinstance") end, keepShownOnClick = true },
			{ text = "显示小地图图标", func = function(f, a1, a2, checked) addon:MinimapIconShow(checked) end, checked = function() return not NumerationCharOptions.minimap.hide end, keepShownOnClick = true },
			{ text = "Solo时隐藏", arg1 = "hideonsolo", func = optionFunction, checked = function() return addon:GetOption("hideonsolo") end, keepShownOnClick = true },
		},
	},
	{ text = "", notClickable = true },
	{ text = "重置", func = function() window:ShowResetWindow() end, notCheckable = true },
}

local updateReportChannels = function()
	menuTable[2].menuList[8].menuList = table.wipe(menuTable[2].menuList[8].menuList)
	for i = 1, GetNumDisplayChannels() do
		local name, _, _, channelNumber, _, active, category = GetChannelDisplayInfo(i)
		if category == "CHANNEL_CATEGORY_CUSTOM" then
			tinsert(menuTable[2].menuList[8].menuList, { text = name, arg1 = "CHANNEL", arg2 = channelNumber, func = reportFunction, notCheckable = 1 })
		end
	end
end

local reportActionFunction = function(num)
	updateReportChannels()
	numReports = num
	EasyMenu(menuTable[2].menuList, dropdown, "cursor", 0 , 0, "MENU")
end


local s
function window:OnInitialize()
	s = addon.windowsettings
	self.maxlines = s.maxlines
	self:SetWidth(s.width)
	self:SetHeight(3+s.titleheight+s.maxlines*(s.lineheight+s.linegap) - s.linegap)

	self:SetClampedToScreen(true)
	self:EnableMouse(true)
	self:EnableMouseWheel(true)
	self:SetMovable(true)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart", function() if IsAltKeyDown() then self:StartMoving() end end)
	self:SetScript("OnDragStop", function()
		self:StopMovingOrSizing()
		
		-- positioning code taken from recount
		local xOfs, yOfs = self:GetCenter()
		local s = self:GetEffectiveScale()
		local uis = UIParent:GetScale()
		xOfs = xOfs*s - GetScreenWidth()*uis/2
		yOfs = yOfs*s - GetScreenHeight()*uis/2
		
		addon:SetOption("x", xOfs/uis)
		addon:SetOption("y", yOfs/uis)
	end)

	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0, s.backgroundalpha)
	
	local x, y = addon:GetOption("x"), addon:GetOption("y")
	if not x or not y then
		self:SetPoint(unpack(s.pos))
	else
		-- positioning code taken from recount
		local s = self:GetEffectiveScale()
		local uis = UIParent:GetScale()
		self:SetPoint("CENTER", UIParent, "CENTER", x*uis/s, y*uis/s)
	end

	local scroll = self:CreateTexture(nil, "ARTWORK")
	self.scroll = scroll
		scroll:SetTexture([[Interface\Buttons\WHITE8X8]])
		scroll:SetTexCoord(.8, 1, .8, 1)
		scroll:SetVertexColor(0, 0, 0, .8)
		scroll:SetWidth(4)
		scroll:SetHeight(4)
		scroll:Hide()
	
	local reset = CreateFrame("Button", nil, self)
	self.reset = reset
		reset:SetBackdrop(backdrop)
		reset:SetBackdropColor(0, 0, 0, s.titlealpha)
		reset:SetNormalFontObject(ChatFontSmall)
		-- reset:SetText(">")
		local tex = reset:CreateTexture(nil, "ARTWORK")
		tex:SetSize(8, 8)
		tex:SetPoint("CENTER")
		tex:SetTexture("Interface\\AddOns\\Numeration\\arrow-right-active")
		reset:SetWidth(s.titleheight)
		reset:SetHeight(s.titleheight)
		reset:SetPoint("TOPRIGHT", -1, -1)
		reset:SetScript("OnMouseUp", function()
			updateReportChannels()
			numReports = 9
			EasyMenu(menuTable, dropdown, "cursor", 0 , 0, "MENU")
		end)
		reset:SetScript("OnEnter", function() reset:SetBackdropColor(s.buttonhighlightcolor[1], s.buttonhighlightcolor[2], s.buttonhighlightcolor[3], .3) end)
		reset:SetScript("OnLeave", function() reset:SetBackdropColor(0, 0, 0, s.titlealpha) end)
	F.Reskin(reset)
	local segment = CreateFrame("Button", nil, self)
	self.segment = segment
		segment:SetBackdrop(backdrop)
		segment:SetBackdropColor(0, 0, 0, s.titlealpha/2)
		segment:SetNormalFontObject(ChatFontSmall)
		segment:SetText(" ")
		segment:SetWidth(s.titleheight-2)
		segment:SetHeight(s.titleheight-2)
		segment:SetPoint("RIGHT", reset, "LEFT", -2, 0)
		segment:SetScript("OnMouseUp", function() addon.nav.view = "Sets" addon.nav.set = nil addon:RefreshDisplay() dropdown:Show() end)
		segment:SetScript("OnEnter", function()
			segment:SetBackdropColor(s.buttonhighlightcolor[1], s.buttonhighlightcolor[2], s.buttonhighlightcolor[3], .3)
			GameTooltip:SetOwner(segment, "ANCHOR_BOTTOMRIGHT")
			local name = ""
			if addon.nav.set == "current" then
				name = "当前战斗"
			else
				local set = addon:GetSet(addon.nav.set)
				if set then
					name = set.name
				end
			end
			GameTooltip:AddLine(name)
			GameTooltip:Show()
		end)
		segment:SetScript("OnLeave", function() segment:SetBackdropColor(0, 0, 0, s.titlealpha/2) GameTooltip:Hide() end)
	F.Reskin(segment)
	local title = self:CreateTexture(nil, "ARTWORK")
	self.title = title
		title:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
		title:SetTexCoord(.8, 1, .8, 1)
		title:SetVertexColor(.25, .66, .35, s.titlealpha)
		title:SetPoint("TOPLEFT", 1, -1)
		title:SetPoint("BOTTOMRIGHT", reset, "BOTTOMLEFT", -1, 0)
	local font = self:CreateFontString(nil, "ARTWORK")
	self.titletext = font
		-- font:SetJustifyH("LEFT")
		font:SetJustifyH("CENTER")
		font:SetFont(s.titlefont, s.titlefontsize, "OUTLINE")
		font:SetTextColor(s.titlefontcolor[1], s.titlefontcolor[2], s.titlefontcolor[3], 1)
		font:SetHeight(s.titleheight)
		font:SetPoint("LEFT", title, "LEFT", 4, 0)
		-- font:SetPoint("RIGHT", segment, "LEFT", -1, 0)
		font:SetPoint("RIGHT", reset, "RIGHT", -4, 0)

	self.detailAction = noop
	self:SetScript("OnMouseDown", clickFunction)
	self:SetScript("OnMouseWheel", function(self, num)
		addon:Scroll(num)
	end)
end

function window:Clear()
--	self:SetBackAction()
	self.scroll:Hide()
	self:SetDetailAction()
	for id,line in pairs(lines) do
		line:SetIcon()
		line.spellId = nil
		line:Hide()
	end
end

function window:UpdateSegment(segment)
	if not segment then
		self.segment:Hide()
	else
		self.segment:SetText(segment)
		self.segment:Show()
	end
end

function window:SetTitle(name, r, g, b)
	self.title:SetVertexColor(r, g, b, s.titlealpha)
	self.titletext:SetText(name)
end

function window:GetTitle()
	return self.titletext:GetText()
end

function window:SetScrollPosition(curPos, maxPos)
	if not s.scrollbar then return end
	if maxPos <= s.maxlines then return end
	local total = s.maxlines*(s.lineheight+s.linegap)
	self.scroll:SetHeight(s.maxlines/maxPos*total)
	self.scroll:SetPoint("TOPLEFT", self.reset, "BOTTOMRIGHT", 2, -1-(curPos-1)/maxPos*total)
	self.scroll:Show()
end

function window:SetBackAction(f)
	backAction = f or noop
	reportAction = noop
end

local SetValues = function(f, c, m)
	f:SetMinMaxValues(0, m)
	f:SetValue(c)
end
local SetIcon = function(f, icon)
	if icon then
		f:SetWidth(s.width-s.lineheight-2)
		f.icon:SetTexture(icon)
		f.icon:Show()
	else
		f:SetWidth(s.width-2)
		f.icon:Hide()
	end
end
local SetLeftText = function(f, ...)
	f.name:SetFormattedText(...)
end
local SetRightText = function(f, ...)
	f.value:SetFormattedText(...)
end
local SetColor = function(f, r, g, b, a)
	f:SetStatusBarColor(r, g, b, a or s.linealpha)
end
local SetDetailAction = function(f, func)
	f.detailAction = func or noop
end
local SetReportNumber = function(f, num)
	reportAction = reportActionFunction
	f.num = num
end
window.SetDetailAction = SetDetailAction

local onEnter = function(self)
	if not self.spellId then return end
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 4, s.lineheight)
	GameTooltip:SetHyperlink("spell:"..self.spellId)
end
local onLeave = function(self)
	GameTooltip:Hide()
end
function window:GetLine(id)
	if lines[id] then return lines[id] end
	
	local f = CreateFrame("StatusBar", nil, self)
	lines[id] = f
		f:EnableMouse(true)
		f.detailAction = noop
		f:SetScript("OnMouseDown", clickFunction)
		f:SetScript("OnEnter", onEnter)
		f:SetScript("OnLeave", onLeave)
		f:SetStatusBarTexture(s.linetexture)
		f:SetStatusBarColor(.6, .6, .6, 1)
		f:SetWidth(s.width-2)
		f:SetHeight(s.lineheight)
	if id == 0 then
		f:SetPoint("TOPRIGHT", self.reset, "BOTTOMRIGHT", 0, -1)
	else
		f:SetPoint("TOPRIGHT", lines[id-1], "BOTTOMRIGHT", 0, -s.linegap)
	end
	local icon = f:CreateTexture(nil, "OVERLAY")
	f.icon = icon
		icon:SetWidth(s.lineheight)
		icon:SetHeight(s.lineheight)
		icon:SetPoint("RIGHT", f, "LEFT")
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:Hide()
	local value = f:CreateFontString(nil, "ARTWORK")
	f.value = value
		value:SetHeight(s.lineheight)
		value:SetJustifyH("RIGHT")
		value:SetFont(s.linefont, s.linefontsize, "THINOUTLINE")
		value:SetTextColor(s.linefontcolor[1], s.linefontcolor[2], s.linefontcolor[3], 1)
		value:SetPoint("RIGHT", -1, 0)
	local name = f:CreateFontString(nil, "ARTWORK")
	f.name = name
		name:SetHeight(s.lineheight)
		name:SetNonSpaceWrap(false)
		name:SetJustifyH("LEFT")
		name:SetFont(s.linefont, s.linefontsize, "THINOUTLINE")
		name:SetTextColor(s.linefontcolor[1], s.linefontcolor[2], s.linefontcolor[3], 1)
		name:SetPoint("LEFT", icon, "RIGHT", 1, 0)
		name:SetPoint("RIGHT", value, "LEFT", -1, 0)
	
	f.SetValues = SetValues
	f.SetIcon = SetIcon
	f.SetLeftText = SetLeftText
	f.SetRightText = SetRightText
	f.SetColor = SetColor
	f.SetDetailAction = SetDetailAction
	f.SetReportNumber = SetReportNumber

	return f
end

local reset
function window:ShowResetWindow()
	if not reset then
		reset = CreateFrame("Frame", nil, window)
		MakeShadow(reset, 3)
		reset.bg = CreateFrame("Frame", nil, reset)
		reset.bg:SetFrameLevel(1)
		reset.bg:SetFrameStrata(reset:GetFrameStrata())
		reset.bg:SetPoint("TOPLEFT")
		reset.bg:SetPoint("BOTTOMRIGHT")
		reset.bg:SetBackdrop({
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground", 
			edgeFile = "Interface\\Addons\\Numeration\\glow", 
			edgeSize = 1,
		})
		reset.bg:SetBackdropColor( 0, 0, 0, 0.6 )
		reset.bg:SetBackdropBorderColor( 0, 0, 0 )
		reset:SetWidth(200)
		reset:SetHeight(45)
		reset:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
		
		reset.titletext = reset:CreateFontString(nil, "ARTWORK")
		reset.titletext:SetFont(s.titlefont, s.titlefontsize, "OUTLINE")
		reset.titletext:SetTextColor(s.titlefontcolor[1], s.titlefontcolor[2], s.titlefontcolor[3], 1)
		reset.titletext:SetText("Numeration: 重置数据 ?")
		reset.titletext:SetPoint("TOP", 0, -2)
		
		reset.yes = CreateFrame("Button", nil, reset)
		reset.yes:SetNormalFontObject(ChatFontSmall)
		reset.yes:SetText("是")
		reset.yes:SetWidth(80)
		reset.yes:SetHeight(18)
		reset.yes:SetPoint("BOTTOMLEFT", 10, 5)
		reset.yes:SetScript("OnMouseUp", function() addon:Reset() reset:Hide() end)
		reset.yes:SetBackdrop({
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", 
			edgeSize = 1, 
		})
		reset.yes:SetBackdropBorderColor(0, 0, 0)
		F.Reskin(reset.yes)
		local tex = reset.yes:CreateTexture(nil, "BACKGROUND")
		tex:SetPoint("TOPLEFT")
		tex:SetPoint("BOTTOMRIGHT")
		tex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
		
		reset.no = CreateFrame("Button", nil, reset)
		reset.no:SetNormalFontObject(ChatFontSmall)
		reset.no:SetText("否")
		reset.no:SetWidth(80)
		reset.no:SetHeight(18)
		reset.no:SetPoint("BOTTOMRIGHT", -10, 5)
		reset.no:SetScript("OnMouseUp", function() reset:Hide() end)
		reset.no:SetBackdrop({
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", 
			edgeSize = 1, 
		})
		reset.no:SetBackdropBorderColor(0, 0, 0)
		
		local tex2 = reset.no:CreateTexture(nil, "BACKGROUND")
		tex2:SetPoint("TOPLEFT")
		tex2:SetPoint("BOTTOMRIGHT")
		tex2:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		tex2:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
		F.Reskin(reset.no)
	end

	reset:Show()
end

local whisper
function window:ShowWhisperWindow()
	if not whisper then
		whisper = CreateFrame("Frame", nil, window)
		MakeShadow(whisper, 3)
		whisper.bg = CreateFrame("Frame", nil, whisper)
		whisper.bg:SetFrameLevel(1)
		whisper.bg:SetFrameStrata(whisper:GetFrameStrata())
		whisper.bg:SetPoint("TOPLEFT")
		whisper.bg:SetPoint("BOTTOMRIGHT")
		whisper.bg:SetBackdrop({
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground", 
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", 
			edgeSize = 1,
		})
		whisper.bg:SetBackdropColor( 0, 0, 0, 0.6 )
		whisper.bg:SetBackdropBorderColor( 0, 0, 0 )
		whisper:SetWidth(200)
		whisper:SetHeight(45)
		whisper:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
		
		whisper.titletext = whisper:CreateFontString(nil, "ARTWORK")
		whisper.titletext:SetFont(s.titlefont, s.titlefontsize, "OUTLINE")
		whisper.titletext:SetTextColor(s.titlefontcolor[1], s.titlefontcolor[2], s.titlefontcolor[3], 1)
		whisper.titletext:SetText("Numeration: 密语目标")
		whisper.titletext:SetPoint("TOP", 0, -2)

		whisper.target = CreateFrame("EditBox", "NumerationWhisperEditBox", whisper)
		whisper.target:SetFontObject(ChatFontSmall)
		whisper.target:SetWidth(90)
		whisper.target:SetHeight(18)
		whisper.target:SetPoint("BOTTOMLEFT", 10, 5)
		whisper.target:SetScript("OnEscapePressed", function() whisper:Hide() end)
		whisper.target:SetScript("OnEnterPressed", function() reportFunction(self, "WHISPER", whisper.target:GetText()) whisper:Hide() end)
		whisper.target:SetBackdrop({
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", 
			edgeSize = 1, 
		})
		whisper.target:SetBackdropBorderColor(0, 0, 0)		

		whisper.yes = CreateFrame("Button", nil, whisper)
		whisper.yes:SetNormalFontObject(ChatFontSmall)
		whisper.yes:SetText(WHISPER)
		whisper.yes:SetWidth(70)
		whisper.yes:SetHeight(18)
		whisper.yes:SetPoint("BOTTOMRIGHT", -10, 5)
		whisper.yes:SetScript("OnMouseUp", function() reportFunction(self, "WHISPER", whisper.target:GetText()) whisper:Hide() end)
		whisper.yes:SetBackdrop({
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", 
			edgeSize = 1, 
		})
		whisper.yes:SetBackdropBorderColor(0, 0, 0)
		F.Reskin(whisper.yes)
		local tex = whisper.yes:CreateTexture(nil, "BACKGROUND")
		tex:SetPoint("TOPLEFT")
		tex:SetPoint("BOTTOMRIGHT")
		tex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
	end
	if UnitIsPlayer("target") and UnitCanCooperate("player", "target") then
		whisper.target:SetText(UnitName("target"))
	end

	whisper:Show()
end
