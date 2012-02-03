-- Engines
local S, _, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):NewAddon("AddonManager")
local AddonList, AddonButton, Page, MaxPage = {}, {}, 1, 1
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b


--核心
local function UpdateAddonList()
	wipe(AddonList)
	UpdateAddOnMemoryUsage()
	for i = 1, GetNumAddOns() do
		local name, title, notes, enabled = GetAddOnInfo(i)
		local mem = GetAddOnMemoryUsage(i)
		local usage = GetAddOnCPUUsage(i)
		tinsert(AddonList, {Name = name, Title = title, Notes = notes, Enabled = enabled, Mem = mem, Usage = usage})
	end
	MaxPage = floor(#AddonList/12)+1
end

local function UpdateAddonButton(MainFrame)
	local Start, End = (Page-1)*12+1, Page*12 < #AddonList and Page*12 or #AddonList
	MainFrame.UpdatePageText()
	for key, value in pairs(AddonButton) do
		value:ClearAllPoints()
		value:Hide()
	end
	wipe(AddonButton)
	for i = Start, End do
		local Button = CreateFrame("Button", nil, MainFrame)
		Button:SetSize(240, 16)
		Button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:ClearLines()
			GameTooltip:AddLine(AddonList[i]["Title"], 112/255, 192/255, 245/255)
			GameTooltip:AddLine(AddonList[i]["Notes"], 1, 1, 1)
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(L["内存占用"], S.FormatMemory(AddonList[i]["Mem"]), 112/255, 192/255, 245/255, 1, 1, 1)
			GameTooltip:AddDoubleLine(L["处理器占用"], AddonList[i]["Usage"].."%", 112/255, 192/255, 245/255, 1, 1, 1)
			GameTooltip:Show()
		end)
		Button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		Button:SetScript("OnClick", function(self)
			if AddonList[i]["Enabled"] then
				DisableAddOn(AddonList[i]["Name"])
				AddonList[i]["Enabled"] = false
				self.Tex:SetVertexColor(0.1, 0.1, 0.1, 0.8)
			else
				EnableAddOn(AddonList[i]["Name"])
				AddonList[i]["Enabled"] = true
				self.Tex:SetVertexColor(0, 0.67, 1, 0.8)
			end
		end)
		if i == Start then
			Button:SetPoint("TOP", MainFrame, 0, -10)
		else
			Button:SetPoint("TOP", AddonButton[i-Start], "BOTTOM", 0, -10)
		end
		Button.Tex = Button:CreateTexture(nil, "OVERLAY")
		Button.Tex:SetTexture(DB.Statusbar)
		Button.Tex:SetSize(16, 16)
		Button.Tex:SetPoint("LEFT")
		if AddonList[i]["Enabled"] then
			Button.Tex:SetVertexColor(0, 0.67, 1, 0.8)
		else
			Button.Tex:SetVertexColor(0.1, 0.1, 0.1, 0.8)
		end
		Button.Text = S.MakeFontString(Button, 11)
		Button.Text:SetText(AddonList[i]["Title"])
		Button.Text:SetPoint("LEFT", Button.Tex, "RIGHT", 10, 0)
		tinsert(AddonButton, Button)
	end
end

local function BuildGameMenuButton(Tittle)	
	local Button = CreateFrame("Button", "AddonManagerGameMenuButton", GameMenuFrame, "GameMenuButtonTemplate")
	S.Reskin(Button)
	Button:SetSize(GameMenuButtonHelp:GetWidth(), GameMenuButtonHelp:GetHeight())
	Button:SetText(L["插件管理"])
	Button:SetPoint(GameMenuButtonHelp:GetPoint())
	Button:SetScript("OnClick", function()
		HideUIPanel(GameMenuFrame)
		UpdateAddonList()
		Tittle:Show()
	end)
	GameMenuButtonHelp:SetPoint("TOP", Button, "BOTTOM", 0, -1)
	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight()+Button:GetHeight())	
end

local function BuildMainFrame()
	local Tittle = S.MakeButton(UIParent)
	Tittle:SetSize(264, 16)
	Tittle:SetPoint("CENTER", 0, 150)
	Tittle:SetMovable(true)
	Tittle:RegisterForDrag("LeftButton")
	Tittle:SetScript("OnDragStart", function(self) self:StartMoving() end)
	Tittle:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	Tittle.Text = S.MakeFontString(Tittle, 10)
	Tittle.Text:SetText(L["SunUI插件管理"])
	Tittle.Text:SetPoint("CENTER")
	local Reload = S.MakeButton(Tittle)
	Reload:SetSize(16, 16)
	Reload:SetPoint("RIGHT", Tittle, "LEFT", -5, 0)
	Reload:SetScript("OnClick",function(self) ReloadUI() end)
	Reload.Text = S.MakeFontString(Reload, 10)
	Reload.Text:SetText("R")
	Reload.Text:SetPoint("CENTER")
	local Close = S.MakeButton(Tittle)
	Close:SetSize(16, 16)
	Close:SetPoint("LEFT", Tittle, "RIGHT", 5, 0)
	Close:SetScript("OnClick",function(self) Tittle:Hide() end)
	Close.Text = S.MakeFontString(Close, 10)
	Close.Text:SetText("X")
	Close.Text:SetPoint("CENTER", 1, 0)
	local MainFrame = CreateFrame("Frame", nil, Tittle)
	MainFrame:SetFrameStrata("HIGH")
	MainFrame:SetSize(300, 320)
	MainFrame:SetPoint("TOP", Tittle, "BOTTOM", 0, -5)
	MainFrame.BG = S.MakeBG(MainFrame, 5)
	local Bottom = S.MakeButton(MainFrame)
	Bottom:SetSize(264, 16)
	Bottom:SetPoint("TOP", MainFrame, "BOTTOM", 0, -5)
	Bottom.Text = S.MakeFontString(Bottom, 10)
	function MainFrame.UpdatePageText() Bottom.Text:SetText(L["第"]..Page..L["页/共"]..MaxPage..L["页"]) end
	Bottom.Text:SetText(L["第"]..Page..L["页/共"]..MaxPage..L["页"])
	Bottom.Text:SetPoint("CENTER")
	local Pre = S.MakeButton(Bottom)
	Pre:SetSize(16, 16)
	Pre:SetPoint("RIGHT", Bottom, "LEFT", -5, 0)
	Pre:SetScript("OnClick",function(self)
		Page = Page-1 > 0 and Page-1 or 1
		UpdateAddonButton(MainFrame)
	end)
	Pre.Text = S.MakeFontString(Pre, 12)
	Pre.Text:SetText("<")
	Pre.Text:SetPoint("CENTER")
	local Next = S.MakeButton(Bottom)
	Next:SetSize(16, 16)
	Next:SetPoint("LEFT", Bottom, "RIGHT", 5, 0)
	Next:SetScript("OnClick",function(self)
		Page = Page <= MaxPage-1 and Page+1 or Page
		UpdateAddonButton(MainFrame)
	end)
	Next.Text = S.MakeFontString(Next, 12)
	Next.Text:SetText(">")
	Next.Text:SetPoint("CENTER")
	
	Tittle:Hide()
	return MainFrame, Tittle
end

function Module:OnEnable()
	local MainFrame, Tittle = BuildMainFrame()
	UpdateAddonList()
	UpdateAddonButton(MainFrame)
	BuildGameMenuButton(Tittle)
end