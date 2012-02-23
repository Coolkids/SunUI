-- Engines
local _, ns = ...
local cargBags = ns.cargBags
local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
----------------
--  主程序  --
----------------

local Bags = cargBags:NewImplementation("Bags")
Bags:RegisterBlizzard() 

local function highlightFunction(button, match)
	button:SetAlpha(match and 1 or 0.3)
end

local f = {}
function Bags:OnInit()

	local onlyBags = function(item) return item.bagID >= 0 and item.bagID <= 4 end
	local onlyBank = function(item) return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11 end
	
	local MyContainer = Bags:GetContainerClass()
	
	-- 玩家背包
	f.main = MyContainer:New("Main", {
			Columns = 10, 
			Scale = 1, 
			Bags = "bags", 
			Movable = true, 
	})
	f.main:SetFilter(onlyBags, true)
	f.main:SetPoint("RIGHT", -20, 0)

	-- 银行
	f.bank = MyContainer:New("Bank", {
			Columns = 13, 
			Scale = 1, 
			Bags = "bank", 
			Movable = true, 
	})
	f.bank:SetFilter(onlyBank, true) 
	f.bank:SetPoint("CENTER", -100, 0)
	f.bank:Hide()

end

function Bags:OnBankOpened()
	self:GetContainer("Bank"):Show()
end

function Bags:OnBankClosed()
	self:GetContainer("Bank"):Hide()
end


local MyButton = Bags:GetItemButtonClass()
MyButton:Scaffold("Default")

function MyButton:OnCreate()
	self:SetNormalTexture(nil)
	self:Size(32, 32)
	
	self.Icon:SetAllPoints()
	self.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	self.Count:SetPoint("BOTTOMRIGHT", 3, 1)
	self.Count:SetFont( DB.Font, 10*S.Scale(1), "THINOUTLINE")
	
	self.Border = CreateFrame("Frame", nil, self)
	--self.Border:SetAllPoints(self.Icon)
	self.Border:SetPoint("CENTER", point or self.Icon)
	self.Border:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = S.Scale(4)})
	self.Border:SetBackdropBorderColor(0, 0, 0, 0)
	self.Border:Size(37, 37)

	self.BG = CreateFrame("Frame", nil, self)
	self.BG:SetPoint("TOPLEFT", self.Icon, 0, 0)
	self.BG:SetPoint("BOTTOMRIGHT", self.Icon, 0, 0)
	self.BG:SetBackdrop({bgFile = DB.Solid, insets = { left = S.mult, right = S.mult, top = S.mult, bottom = S.mult }})
	self.BG:SetBackdropColor(0.2, 0.2, 0.2, 0.5)
	self.BG:SetFrameLevel(0)


	_G[self:GetName().."IconQuestTexture"]:SetSize(0.01, 0.01)
end

function MyButton:OnUpdate(item)
	if item.questID or item.isQuestItem then
		self.Border:SetBackdropBorderColor(1, 1, 0, 1)
	elseif item.rarity and item.rarity > 1 then
		local r, g, b = GetItemQualityColor(item.rarity)
		self.Border:SetBackdropBorderColor(r, g, b, 1)
	else
		self.Border:SetBackdropBorderColor(0, 0, 0, 1)
	end
end

--	背包图标模板
local BagButton = Bags:GetClass("BagButton", true, "BagButton")
function BagButton:OnCreate()
	self:GetCheckedTexture():SetVertexColor(0.3, 0.9, 0.9, 0.5)
end

-- 更新背包栏
local UpdateDimensions = function(self)
	local width, height = self:LayoutButtons("grid", self.Settings.Columns, 4, 10, -10)
	local margin = 40
	if self.BagBar and self.BagBar:IsShown() then
		margin = margin + 45
	end
	self:SetHeight(height + margin)
end

local MyContainer = Bags:GetContainerClass()
function MyContainer:OnContentsChanged()
	self:SortButtons("bagSlot")
	local width, height = self:LayoutButtons("grid", self.Settings.Columns, 5, 10, -10)
	self:SetSize(width + 20, height + 10)
	if self.UpdateDimensions then
		self:UpdateDimensions()
	end
end

-- 创建框体
function MyContainer:OnCreate(name, settings)
    self.Settings = settings
	self.UpdateDimensions = UpdateDimensions
	
	self:SetBackdrop({ 
		bgFile = DB.bgFile, insets = {left = 4, right = 4, top = 4, bottom = 4},
		edgeFile = DB.GlowTex, edgeSize = 3, 
	})
	self:SetBackdropColor(0, 0, 0, 0.8)
	self:SetBackdropBorderColor(0, 0, 0, 1)

	self:SetParent(settings.Parent or Bags)
	self:SetFrameStrata("HIGH")

	if settings.Movable then
		self:SetMovable(true)
		self:RegisterForClicks("LeftButton")
	    self:SetScript("OnMouseDown", function()
			self:ClearAllPoints() 
			self:StartMoving()
	    end)
		self:SetScript("OnMouseUp", self.StopMovingOrSizing)
	end

	settings.Columns = settings.Columns
	self:SetScale(settings.Scale)
	
	-- 信息条
	local infoFrame = CreateFrame("Button", nil, self)
	infoFrame:SetPoint("BOTTOM", -20, 0)
	infoFrame:SetWidth(220)
	infoFrame:SetHeight(32)
	
	-- 信息条插件:金币
	local tagDisplay = self:SpawnPlugin("TagDisplay", "[money]", infoFrame)
	tagDisplay:SetFontObject("NumberFontNormal")
	tagDisplay:SetFont(DB.Font, 11*S.Scale(1))
	tagDisplay:SetPoint("RIGHT", infoFrame, "RIGHT", 0, 0)	
	-- 信息条插件:搜索栏
	local searchText = infoFrame:CreateFontString(nil, "OVERLAY")
	searchText:SetPoint("LEFT", infoFrame, "LEFT", 0, 1)
	searchText:SetFont(DB.Font, 11*S.Scale(1), "THINOUTLINE")
	searchText:SetText(L["搜索"])	
	local search = self:SpawnPlugin("SearchBar", infoFrame)
	search.highlightFunction = highlightFunction
	search.isGlobal = true
	search:SetPoint("LEFT", infoFrame, "LEFT", 0, 5)
	
	-- 信息条插件:背包栏
	local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
	bagBar:SetSize(bagBar:LayoutButtons("grid", 7))
	bagBar:SetScale(0.8)
	bagBar.highlightFunction = highlightFunction
	bagBar.isGlobal = true
	bagBar:Hide()
	self.BagBar = bagBar
	bagBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 10, 46)
	
	-- 背包栏开关按钮
	self:UpdateDimensions()
	local BagToggle = S.MakeButton(self)
	BagToggle:SetSize(40, 20)
	BagToggle:SetPoint("BOTTOMLEFT", 9, 7)
	BagToggle:SetScript("OnClick", function()
		if self.BagBar:IsShown() then
			self.BagBar:Hide()
		else
			self.BagBar:Show()
		end
		self:UpdateDimensions()
	end)
	BagToggle.Text = BagToggle:CreateFontString(nil, "OVERLAY")
	BagToggle.Text:SetPoint("CENTER")
	BagToggle.Text:SetFont(DB.Font, 11*S.Scale(1), "THINOUTLINE")
	BagToggle.Text:SetText(L["背包"])
	
	-- 背包整理按钮
	local SortButton = S.MakeButton(self)
	SortButton:SetSize(70, 20)
	SortButton:SetPoint("BOTTOMRIGHT", -30, 7)
	SortButton:SetScript("OnClick", function() JPack:Pack() end)
	SortButton.Text = SortButton:CreateFontString(nil, "OVERLAY")
	SortButton.Text:SetPoint("CENTER")
	SortButton.Text:SetFont(DB.Font, 11*S.Scale(1), "THINOUTLINE")
	SortButton.Text:SetText(L["整理背包"])

	-- 关闭按钮
	local CloseButton = S.MakeButton(self)
	--CloseButton:SetFrameLevel(3)
	CloseButton:SetSize(20, 20)
	CloseButton:SetScript( "OnClick", function(self) CloseAllBags() end)
	CloseButton:SetPoint("BOTTOMRIGHT", -7, 7)
	CloseButton.Texture = CloseButton:CreateFontString(nil, "OVERLAY")
	CloseButton.Texture:SetPoint("CENTER", 1, 1)
	CloseButton.Texture:SetFont(DB.Font, 11*S.Scale(1), "THINOUTLINE")
	CloseButton.Texture:SetText("x")
end

