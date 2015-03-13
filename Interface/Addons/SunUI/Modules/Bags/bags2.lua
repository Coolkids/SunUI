local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local cargBags = select(2, ...).cargBags

local B = S:NewModule("Bags", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
B.modName = L["背包"]
B.order = 9

B.ProfessionColors = {
	[0x0008] = {224/255, 187/255, 74/255}, -- Leatherworking
	[0x0010] = {74/255, 77/255, 224/255}, -- Inscription
	[0x0020] = {18/255, 181/255, 32/255}, -- Herbs
	[0x0040] = {160/255, 3/255, 168/255}, -- Enchanting
	[0x0080] = {232/255, 118/255, 46/255}, -- Engineering
	[0x0200] = {8/255, 180/255, 207/255}, -- Gems
	[0x0400] = {105/255, 79/255,  7/255}, -- Mining
	[0x010000] = {222/255, 13/255,  65/255} -- Cooking
}

B.INVTYPE = setmetatable({
	["INVTYPE_2HWEAPON"] = INVTYPE_2HWEAPON,
	["INVTYPE_AMMO"] = INVTYPE_AMMO,
	["INVTYPE_BAG"] = INVTYPE_BAG,
	["INVTYPE_BODY"] = INVTYPE_BODY,
	["INVTYPE_CHEST"] = INVTYPE_CHEST,
	["INVTYPE_CLOAK"] = INVTYPE_CLOAK,
	["INVTYPE_FEET"] = INVTYPE_FEET,
	["INVTYPE_FINGER"] = INVTYPE_FINGER,
	["INVTYPE_HAND"] = INVTYPE_HAND,
	["INVTYPE_HEAD"] = INVTYPE_HEAD,
	["INVTYPE_HOLDABLE"] = INVTYPE_HOLDABLE,
	["INVTYPE_LEGS"] = INVTYPE_LEGS,
	["INVTYPE_NECK"] = INVTYPE_NECK,
	["INVTYPE_QUIVER"] = INVTYPE_QUIVER,
	["INVTYPE_RANGED"] = INVTYPE_RANGED,
	["INVTYPE_RANGEDRIGHT"] = INVTYPE_RANGEDRIGHT,
	["INVTYPE_RELIC"] = INVTYPE_RELIC,
	["INVTYPE_ROBE"] = INVTYPE_ROBE,
	["INVTYPE_SHIELD"] = INVTYPE_SHIELD,
	["INVTYPE_SHOULDER"] = INVTYPE_SHOULDER,
	["INVTYPE_TABARD"] = INVTYPE_TABARD,
	["INVTYPE_THROWN"] = INVTYPE_THROWN,
	["INVTYPE_TRINKET"] = INVTYPE_TRINKET,
	["INVTYPE_WAIST"] = INVTYPE_WAIST,
	["INVTYPE_WEAPON"] = INVTYPE_WEAPON,
	["INVTYPE_WEAPONMAINHAND"] = INVTYPE_WEAPONMAINHAND,
	["INVTYPE_WEAPONMAINHAND_PET"] = INVTYPE_WEAPONMAINHAND_PET,
	["INVTYPE_WEAPONOFFHAND"] = INVTYPE_WEAPONOFFHAND,
	["INVTYPE_WRIST"] = INVTYPE_WRIST,
},{__index=function() return "" end})

function B:GetOptions()
	local options = {
		BagSize = {
			type = "range", order = 1,
			name = L["背包图标"],
			min = 20, max = 50, step = 1,
			set = function(info, value)
				self.db.BagSize = value
				self:Layout(false) 
			end,
		},
		BankSize = {
			type = "range", order = 2,
			name = L["银行图标"],
			min = 20, max = 50, step = 1,
			set = function(info, value)
				self.db.BankSize = value
				self:Layout(true) 
			end,
		},
		Spacing = {
			type = "range", order = 3,
			name = L["图标间距"], desc = L["图标间距"],
			min = 0, max = 10, step = 1,
			set = function(info, value)
				self.db.Spacing = value
				self:Layout(true)
				self:Layout(false) 
			end,
		},
		BagWidth = {
			type = "input",
			name = L["背包框体宽度"],
			order = 4,
			get = function() return tostring(self.db.BagWidth) end,
			set = function(_, value) 
				self.db.BagWidth = tonumber(value) 
				self:Layout(false) 
			end,
		},
		BankWidth = {
			type = "input",
			name = L["银行框体宽度"],
			order = 5,
			get = function() return tostring(self.db.BankWidth) end,
			set = function(_, value) 
				self.db.BankWidth = tonumber(value) 
				self:Layout(true) 
			end,
		},
		EquipType = {
			type = "toggle",
			name = L["物品类型及等级"],
			order = 6,
		},
	}
	return options
end





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
			Columns = 10,   --列数
			Scale = 1, 
			Bags = "bags", 
			Movable = true, 
	})
	f.main:SetFilter(onlyBags, true)
	f.main:SetPoint("RIGHT", -20, 0)

	-- 银行
	f.bank = MyContainer:New("Bank", {
			Columns = 13,  --列数
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
	self:SetSize(B.db.BagSize, B.db.BagSize)
	
	self.Icon:SetAllPoints()
	self.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	
	self.Count:SetPoint("BOTTOMRIGHT", 0, 2)
	self.Count:SetFont(S["media"].font, S["media"].fontsize, "OUTLINE")
	
	self.equiptype = S:CreateFS(self)
	self.equiptype:SetPoint("TOPRIGHT", 0, -2)
	self.equiptype:SetJustifyH("RIGHT")
	self.equiptype:SetFont(S["media"].font, S["media"].fontsize-1, "OUTLINE")

	self.equiplevel = S:CreateFS(self)
	self.equiplevel:SetPoint("BOTTOMRIGHT", 0, 2)
	self.equiplevel:SetJustifyH("RIGHT")
	self.equiplevel:SetFont(S["media"].font, S["media"].fontsize, "OUTLINE")
	
	
	self.Border = CreateFrame("Frame", nil, self)
	self.Border:SetAllPoints(self)
	self.Border:CreateBorder()
	A:CreateBackdropTexture(self, 0.6)
	
	self.shadow = CreateFrame("Frame", nil, self)
	self.shadow:SetOutside(f.Bags[bagID][slotID], 3, 3)
	self.shadow:SetFrameLevel(0)
	self.shadow:SetBackdrop( { 
		edgeFile = S["media"].glow,
		edgeSize = S:Scale(3),
		insets = {left = S:Scale(3), right = S:Scale(3), top = S:Scale(3), bottom = S:Scale(3)},
	})
	self.shadow:SetBackdropColor(0, 0, 0)
	self.shadow:Hide()
	
	
	self:StyleButton(true)
	self:SetCheckedTexture(nil)
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
	--尝试添加更多物品信息
	local clink = GetContainerItemLink(self.bagID, self.slotID)
	if (clink) then
		local iType, iLevel, iClass, iSubClass, _
		_, _, _, iLevel, _, iClass, iSubClass, _, iType = GetItemInfo(clink)
		if S:IsItemUnusable(clink) then
			SetItemButtonTextureVertexColor(self, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		else
			SetItemButtonTextureVertexColor(self, 1, 1, 1)
		end
		--装备类型 + 等级
		if B.db.EquipType then
			if iType and not (self.questId and not self.isActive) and not (self.questId or self.isQuestItem) and B.INVTYPE[iType]~= "" then
				self.equiptype:Show()
				if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
					local temptext, round
					if iType:find("WEAPON") then
						self.equiptype:SetText(iSubClass)
						temptext = iSubClass
					else
						self.equiptype:SetText(B.INVTYPE[iType])
						temptext = B.INVTYPE[iType]
					end
					round = temptext:len()
					--S:Print("字数:", round)
					if round == 0 then 
						round = 1 
					else
						round = 2/(round/3)
					end
					if round > 1 then
						round = 1
					end
					--S:Print("系数:", round, "倒数:", 1-round,"字号:", S["media"].fontsize * round)
					self.equiptype:SetFont(S["media"].font, (S["media"].fontsize - 1) * round, S["media"].fontflag)
					--S:Print(iSubClass, B.INVTYPE[iType])
				else
					self.equiptype:SetText("")
					self.equiptype:Hide()
				end
				if S:IsItemUnusable(clink) then
					self.equiptype:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
				elseif item.rarity then
					local r, g, b = GetItemQualityColor(item.rarity)
					self.equiptype:SetTextColor(r, g, b)
				end
				if B.INVTYPE[iType] ~= "" then
					self.equiplevel:Show()
					self.equiplevel:SetText(iLevel)
					local total, equipped = GetAverageItemLevel()
					--local StatusColor = {{0.5, 0.5, 0.5}, {1, 1, 0}, {0.25, 0.75, 0.25}} --灰 黄 绿
					local temp = iLevel - equipped
					local r, g, b
					if temp > 0 then
						r, g, b = 0.25, 0.75, 0.25
					elseif temp < -20 then
						r, g, b = 0.5, 0.5, 0.5
					elseif temp <=0 and temp >= -20 then
						r, g, b = 1, 1, 0
					end
					self.equiplevel:SetTextColor(r, g, b)
				else
					self.equiptype:SetText("")
					self.equiptype:Hide()
				end
			else
				self.equiplevel:SetText("")
				self.equiplevel:Hide()
				self.equiptype:SetText("")
				self.equiptype:Hide()
			end
		else
			self.equiplevel:SetText("")
			self.equiplevel:Hide()
			self.equiptype:SetText("")
			self.equiptype:Hide()
		end
		
	else
		--slot:SetBackdropColor(0, 0, 0, 0)
		--slot.border:SetBackdropBorderColor(0, 0, 0)
		self.equiplevel:SetText("")
		self.equiplevel:Hide()
		self.equiptype:SetText("")
		self.equiptype:Hide()
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
	local width, height = self:LayoutButtons("grid", self.Settings.Columns, 4, 10, -10)
	self:SetSize(width + 20, height + 10)
	if self.UpdateDimensions then
		self:UpdateDimensions()
	end
end

-- 创建框体
function MyContainer:OnCreate(name, settings)
	local A = S:GetModule("Skins")
    self.Settings = settings
	self.UpdateDimensions = UpdateDimensions
	
	A:SetBD(self)
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
	infoFrame:SetWidth(210)
	infoFrame:SetHeight(32)
	
	-- 信息条插件:金币
	local tagDisplay = self:SpawnPlugin("TagDisplay", "[money]", infoFrame)
	tagDisplay:SetFontObject("NumberFontNormal")
	tagDisplay:SetFont(DB.Font, 11, "THINOUTLINE")
	tagDisplay:SetPoint("RIGHT", infoFrame, "RIGHT", -10, 0)	
	-- 信息条插件:搜索栏
	local searchText = infoFrame:CreateFontString(nil, "OVERLAY")
	searchText:SetPoint("LEFT", infoFrame, "LEFT", 0, 1)
	searchText:SetFont(DB.Font, 11, "THINOUTLINE")
	searchText:SetText("搜索")	
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
	local BagToggle = CreateFrame("Button", nil, self)   --新建button TODO
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
	BagToggle.Text:SetFont(DB.Font, 11, "THINOUTLINE") --TODO
	BagToggle.Text:SetText("背包")
	
	-- 背包整理按钮
	local SortButton = CreateFrame("Button", nil, self)    --TODO
	SortButton:SetSize(70, 20)
	SortButton:SetPoint("BOTTOMRIGHT", -30, 7)
	SortButton:SetScript('OnMouseDown', function(self, button) 
		if InCombatLockdown() then return end
		if button == "RightButton" then JPack:Pack(nil, 1) else JPack:Pack(nil, 2) end 
	end)
	SortButton.ttText = L["整理背包"]
	SortButton.ttText2 = L["整理背包"]
	SortButton.ttText2desc = "左键逆向,右键正向"
	SortButton:SetScript("OnEnter", self.Tooltip_Show)
	SortButton:SetScript("OnLeave", self.Tooltip_Hide)
	A:Reskin(SortButton)

	-- 关闭按钮
	local CloseButton = CreateFrame("Button", nil, self)    --TODO
	CloseButton:SetSize(20, 20)
	CloseButton:SetScript( "OnClick", function(self) CloseAllBags() end)
	CloseButton:SetPoint("BOTTOMRIGHT", -7, 7)
	CloseButton.Texture = CloseButton:CreateFontString(nil, "OVERLAY")
	CloseButton.Texture:SetPoint("CENTER", 1, 1)
	CloseButton.Texture:SetFont(DB.Font, 14, "THINOUTLINE")
	CloseButton.Texture:SetText("x")
end

