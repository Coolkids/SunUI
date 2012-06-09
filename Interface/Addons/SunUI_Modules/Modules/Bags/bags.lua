local S, C, L, DB = unpack(SunUI)

local Bag = CreateFrame("Frame", nil, UIParent)
local ST_NORMAL = 1
local ST_SOULBAG = 2
local ST_SPECIAL = 3
local ST_QUIVER = 4
local bagFrame, bankFrame
local BAGS_BACKPACK = {0, 1, 2, 3, 4}
local BAGS_BANK = {-1, 5, 6, 7, 8, 9, 10, 11}
local trashParent = CreateFrame("Frame", nil, UIParent)
local trashButton, trashBag = {}, {}

Bag.buttons = {}
Bag.bags = {}
local Unusable

if DB.MyClass == 'DEATHKNIGHT' then
	Unusable = {{3, 4, 10, 11, 13, 14, 15, 16}, {6}}
elseif DB.MyClass == 'DRUID' then
	Unusable = {{1, 2, 3, 4, 8, 9, 14, 15, 16}, {4, 5, 6}, true}
elseif DB.MyClass == 'HUNTER' then
	Unusable = {{5, 6, 16}, {5, 6, 7}}
elseif DB.MyClass == 'MAGE' then
	Unusable = {{1, 2, 3, 4, 5, 6, 7, 9, 11, 14, 15}, {3, 4, 5, 6, 7}, true}
elseif DB.MyClass == 'PALADIN' then
	Unusable = {{3, 4, 10, 11, 13, 14, 15, 16}, {}, true}
elseif DB.MyClass == 'PRIEST' then
	Unusable = {{1, 2, 3, 4, 6, 7, 8, 9, 11, 14, 15}, {3, 4, 5, 6, 7}, true}
elseif DB.MyClass == 'ROGUE' then
	Unusable = {{2, 6, 7, 9, 10, 16}, {4, 5, 6, 7}}
elseif DB.MyClass == 'SHAMAN' then
	Unusable = {{3, 4, 7, 8, 9, 14, 15, 16}, {5}}
elseif DB.MyClass == 'WARLOCK' then
	Unusable = {{1, 2, 3, 4, 5, 6, 7, 9, 11, 14, 15}, {3, 4, 5, 6, 7}, true}
elseif DB.MyClass == 'WARRIOR' then
	Unusable = {{16}, {7}}
end

for class = 1, 2 do
	local subs = {GetAuctionItemSubClasses(class)}
	for i, subclass in ipairs(Unusable[class]) do
		Unusable[subs[subclass]] = true
	end
	Unusable[class] = nil
	subs = nil
end

local function IsClassUnusable(subclass, slot)
	if subclass then
		return Unusable[subclass] or slot == 'INVTYPE_WEAPONOFFHAND' and Unusable[3]
	end
end

local function IsItemUnusable(...)
	if ... then
		local subclass, _, slot = select(7, GetItemInfo(...))
		return IsClassUnusable(subclass, slot)
	end
end
local function ResetAndClear(self)
	if not self then return end
	
	if self:GetParent().detail then
		self:GetParent().detail:Show()
	end
		
	self:ClearFocus()
	Bag:SearchReset()
end

--This one isn't for the actual bag buttons its for the buttons you can use to swap bags.
function Bag:BagFrameSlotNew(frame, slot)
	for _, v in ipairs(frame.buttons) do
		if v.slot == slot then
			return v, false
		end
	end

	local ret = {}
	if slot > 3 then
		ret.slot = slot
		slot = slot - 4
		ret.frame = CreateFrame("CheckButton", "SunUIBankBag" .. slot, frame, "BankItemButtonBagTemplate")
		ret.frame:SetID(slot + 4)
		table.insert(frame.buttons, ret)

		if not ret.frame.tooltipText then
			ret.frame.tooltipText = ""
		end		
	else
		--This is fucking retarded, the frame name needs to have 9 digits before the word Bag.
		ret.frame = CreateFrame("CheckButton", "SunUIMainBag" .. slot .. "Slot", frame, "BagSlotButtonTemplate")			
		ret.slot = slot
		table.insert(frame.buttons, ret)
	end
	
	ret.frame:HookScript("OnEnter", function()
		local bag
		for ind, val in ipairs(self.buttons) do
			if val.bag == ret.slot then
				val.frame:SetAlpha(1)
			else
				val.frame:SetAlpha(0.2)
			end
		end
	end)

	ret.frame:HookScript("OnLeave", function()
		for _, btn in ipairs(self.buttons) do
			btn.frame:SetAlpha(1)
		end
	end)	
	
	ret.frame:SetScript('OnClick', nil)

	ret.frame:StyleButton()
	ret.frame:SetFrameLevel(ret.frame:GetFrameLevel() + 1)
	if not ret.frame.border then
		local border = CreateFrame("Frame", nil, ret.frame)
		border:Point("TOPLEFT", 1, -1)
		border:Point("BOTTOMRIGHT", -1, 1)
		border:SetFrameLevel(0)
		ret.frame.border = border
		ret.frame.border:CreateBorder()
	end
	
	local t = _G[ret.frame:GetName().."IconTexture"]
	ret.frame:SetPushedTexture("")
	ret.frame:SetNormalTexture("")
	ret.frame:SetCheckedTexture(nil)
	t:SetTexCoord(.08, .92, .08, .92)
	t:Point("TOPLEFT", ret.frame, 2, -2)
	t:Point("BOTTOMRIGHT", ret.frame, -2, 2)
	
	return ret
end

local BAGTYPE_PROFESSION = 0x0008 + 0x0010 + 0x0020 + 0x0040 + 0x0080 + 0x0200 + 0x0400
local BAGTYPE_FISHING = 32768
function Bag:BagType(bag)
	local bagType = select(2, GetContainerNumFreeSlots(bag))
	
	if bit.band(bagType, BAGTYPE_FISHING) > 0 then
		return ST_FISHBAG
	elseif bit.band(bagType, BAGTYPE_PROFESSION) > 0 then		
		return ST_SPECIAL
	end

	return ST_NORMAL
end

function Bag:BagNew(bag, f)
	for i, v in pairs(self.bags) do
		if v:GetID() == bag then
			v.bagType = self:BagType(bag)
			return v
		end
	end

	local ret

	if #trashBag > 0 then
		local f = -1
		for i, v in pairs(trashBag) do
			if v:GetID() == bag then
				f = i
				break
			end
		end

		if f ~= -1 then
			ret = trashBag[f]
			table.remove(trashBag, f)
			ret:Show()
			ret.bagType = Bag:BagType(bag)
			return ret
		end
	end

	ret = CreateFrame("Frame", "RayUIBag" .. bag, f)
	ret.bagType = Bag:BagType(bag)

	ret:SetID(bag)
	return ret
end

function Bag:SlotUpdate(b)
	local texture, count, locked = GetContainerItemInfo(b.bag, b.slot)
	local clink = GetContainerItemLink(b.bag, b.slot)
	
	if not b.frame.lock then
		b.frame.border:SetBackdropBorderColor(0, 0, 0, 1)
	end
	
	if b.Cooldown then
		local cd_start, cd_finish, cd_enable = GetContainerItemCooldown(b.bag, b.slot)
		CooldownFrame_SetTimer(b.Cooldown, cd_start, cd_finish, cd_enable)	
	end

	if(clink) then
		local iType
		b.name, _, b.rarity, _, _, iType = GetItemInfo(clink)
		
		if IsItemUnusable(clink) then
			_G[b.frame:GetName().."IconTexture"]:SetVertexColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		else
			_G[b.frame:GetName().."IconTexture"]:SetVertexColor(1, 1, 1)
		end	
		b.frame:SetBackdropColor(0, 0, 0)
		-- color slot according to item quality
		if not b.frame.lock and b.rarity and b.rarity > 1 then
			b.frame.border:SetBackdropBorderColor(GetItemQualityColor(b.rarity))
			_G[b.frame:GetName().."IconTexture"]:Point("TOPLEFT", 1.2, -1.2)
			_G[b.frame:GetName().."IconTexture"]:Point("BOTTOMRIGHT", -1.2, 1.2)
		elseif GetContainerItemQuestInfo(b.bag, b.slot) then
			b.frame.border:SetBackdropBorderColor(1, 1, 0)
			_G[b.frame:GetName().."IconTexture"]:Point("TOPLEFT", 1.2, -1.2)
			_G[b.frame:GetName().."IconTexture"]:Point("BOTTOMRIGHT", -1.2, 1.2)
		else
			_G[b.frame:GetName().."IconTexture"]:SetAllPoints()
		end
	else
		b.name, b.rarity = nil, nil
		b.frame:SetBackdropColor(0, 0, 0, 0)
	end

	SetItemButtonTexture(b.frame, texture)
	SetItemButtonCount(b.frame, count)
	SetItemButtonDesaturated(b.frame, locked, 0.5, 0.5, 0.5)
		
	b.frame:Show()
end

function Bag:SlotNew(bag, slot)
	for _, v in ipairs(self.buttons) do
		if v.bag == bag and v.slot == slot then
			return v, false
		end
	end

	local tpl = "ContainerFrameItemButtonTemplate"

	if bag == -1 then
		tpl = "BankItemButtonGenericTemplate"
	end

	local ret = {}

	if #trashButton > 0 then
		local f = -1
		for i, v in ipairs(trashButton) do
			local b, s = v:GetName():match("(%d+)_(%d+)")

			b = tonumber(b)
			s = tonumber(s)

			if b == bag and s == slot then
				f = i
				break
			end
		end

		if f ~= -1 then
			ret.frame = trashButton[f]
			table.remove(trashButton, f)
		end
	end

	if not ret.frame then
		ret.frame = CreateFrame("CheckButton", "SunUINormBag" .. bag .. "_" .. slot, self.bags[bag], tpl)
		ret.frame:StyleButton(true)

		if not ret.frame.border then
			local border = CreateFrame("Frame", nil, ret.frame)
			border:Point("TOPLEFT", -1, 1)
			border:Point("BOTTOMRIGHT", 1, -1)
			border:SetFrameLevel(6)
			ret.frame.border = border
			ret.frame.border:SetBackdrop({
				edgeFile = DB.Solid, 
				edgeSize = S.mult+0.2,
				insets = { left = -S.mult-0.2, right = -S.mult-0.2, top = -S.mult-0.2, bottom = -S.mult-0.2 }
			})
			ret.frame.border:SetBackdropBorderColor(0, 0, 0, 1)
			
			local tex = ret.frame:CreateTexture(nil, "BACKGROUND")
			tex:SetAllPoints()
			tex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
			tex:SetGradientAlpha("VERTICAL", 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2)
		end

		ret.frame:SetBackdrop({
			bgFile = DB.Solid, 
			insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})

		local t = _G[ret.frame:GetName().."IconTexture"]
		ret.frame:SetNormalTexture(nil)
		ret.frame:SetCheckedTexture(nil)
		
		t:SetTexCoord(.08, .92, .08, .92)
		t:SetAllPoints()
		
		local count = _G[ret.frame:GetName().."Count"]
		count:ClearAllPoints()
		count:Point("BOTTOMRIGHT", ret.frame, "BOTTOMRIGHT", 1, 0)
		count:SetFont(DB.Font, S.mult*12, "OUTLINE")
	end

	ret.bag = bag
	ret.slot = slot
	ret.frame:SetID(slot)

	ret.Cooldown = _G[ret.frame:GetName() .. "Cooldown"]
	ret.Cooldown:Show()

	self:SlotUpdate(ret)

	return ret, true
end

function Bag:Layout(isBank)
	local slots = 0
	local rows = 0
	local offset = 26
	local cols, f, bs, bSize, BagWidth
	local spacing = 5

	if not isBank then
		BagWidth = 400
		bs = BAGS_BACKPACK
		f = bagFrame
		bSize = 32
		-- cols = (floor((BagWidth - 10)/370 * 10))
		cols = floor((BagWidth - 10 + spacing)/((bSize + 1) + spacing))
	else
		BagWidth = 600
		bs = BAGS_BANK
		f = bankFrame
		bSize = 32
		-- cols = (floor((BagWidth - 10)/370 * 10))
		cols = floor((BagWidth - 10 + spacing)/((bSize + 1) + spacing))
	end
	
	if not f then return end
	
	local w = 0
	w = w + ((#bs - 1) * bSize)
	w = w + (12 * (#bs - 2))

	f.ContainerHolder:Height(10 + bSize)
	f.ContainerHolder:Width(w)
	
	--Position BagFrame Bag Icons
	local idx = 0
	local numSlots, full = GetNumBankSlots()
	for i, v in ipairs(bs) do
		if (not isBank and v <= 3 ) or (isBank and v ~= -1 and numSlots >= 1) then
			local b = Bag:BagFrameSlotNew(f.ContainerHolder, v)

			local xOff = 12
			xOff = xOff + (idx * bSize)
			xOff = xOff + (idx * 4)

			b.frame:ClearAllPoints()
			b.frame:Point("LEFT", f.ContainerHolder, "LEFT", xOff, 0)
			b.frame:Size(bSize)
			
			if isBank then
				BankFrameItemButton_Update(b.frame)
				BankFrameItemButton_UpdateLocked(b.frame)
			end
			
			idx = idx + 1
			
			if isBank and not full and i > numSlots then
				break
			end
		end
	end
	
	for _, i in ipairs(bs) do
		local x = GetContainerNumSlots(i)
		if x > 0 then
			if not self.bags[i] then
				self.bags[i] = self:BagNew(i, f)
			end
			
			slots = slots + GetContainerNumSlots(i)
		end
	end
	
	rows = floor (slots / cols)
	if (slots % cols) ~= 0 then
		rows = rows + 1
	end	

	f:Width(BagWidth)
	f:Height(rows * (bSize + 1) + (rows - 1) * spacing + offset + 24)
	
	f.HolderFrame:SetWidth(((bSize + 1) + spacing) * cols - spacing)
	f.HolderFrame:SetHeight(f:GetHeight() - 3)
	f.HolderFrame:SetPoint("BOTTOM", f, "BOTTOM")
	
	--Fun Part, Position Actual Bag Buttons
	local idx = 0
	for _, i in ipairs(bs) do
		local bag_cnt = GetContainerNumSlots(i)

		if bag_cnt > 0 then
			self.bags[i] = Bag:BagNew(i, f)
			local bagType = self.bags[i].bagType
			self.bags[i]:Show()
			
			for j = 1, bag_cnt do
				local b, isnew = self:SlotNew(i, j)
				local xOff
				local yOff
				local x = (idx % cols)
				local y = floor(idx / cols)

				if isnew then
					table.insert(self.buttons, idx + 1, b)
				end

				xOff = (x * (bSize + 1)) + (x * spacing)

				yOff = offset + 12 + (y * (bSize + 1)) + ((y - 1) * spacing)
				yOff = yOff * -1

				b.frame:ClearAllPoints()
				b.frame:SetPoint("TOPLEFT", f.HolderFrame, "TOPLEFT", xOff, yOff)
				b.frame:Size(bSize)
				
				local clink = GetContainerItemLink
				if (clink and b.rarity and b.rarity > 1) then
					b.frame.border:SetBackdropBorderColor(GetItemQualityColor(b.rarity))
				elseif (clink and b.qitem) then
					b.frame.border:SetBackdropBorderColor(1, 0, 0)			
				elseif bagType == ST_QUIVER then
					b.frame.border:SetBackdropBorderColor(0.8, 0.8, 0.2)
					b.frame.lock = true
				elseif bagType == ST_SOULBAG then
					b.frame.border:SetBackdropBorderColor(0.5, 0.2, 0.2)
					b.frame.lock = true
				elseif bagType == ST_SPECIAL then
					b.frame:SetBackdropBorderColor(0.2, 0.2, 0.8)
					b.frame.lock = true
				end
				
				-- color profession bag slot border ~yellow
				if bagType == ST_SPECIAL then b.frame.border:SetBackdropBorderColor(255/255, 243/255,  82/255) b.frame.lock = true end
				
				idx = idx + 1
			end
		end
	end	
end

function Bag:BagSlotUpdate(bag)
	if not self.buttons then
		return
	end

	for _, v in ipairs (self.buttons) do
		if v.bag == bag then
			self:SlotUpdate(v)
		end
	end
end

function Bag:Bags_OnShow()
	Bag:PLAYERBANKSLOTS_CHANGED(29)
	Bag:Layout()
end

function Bag:Bags_OnHide()
	if bankFrame then
		bankFrame:Hide()
	end
end

local UpdateSearch = function(self, t)
	if t == true then
		Bag:SearchUpdate(self:GetText(), self:GetParent())
	end
end

function Bag:SearchUpdate(str, frameMatch)
	str = string.lower(str)

	for _, b in ipairs(self.buttons) do
		if b.name then
			local _, setName = GetContainerItemEquipmentSetInfo(b.bag, b.slot)
			setName = setName or ""
			local ilink = GetContainerItemLink(b.bag, b.slot)
			local class, subclass, _, equipSlot = select(6, GetItemInfo(ilink))
			equipSlot = _G[equipSlot] or ""
			if (not string.find (string.lower(b.name), str) and not string.find (string.lower(setName), str) and not string.find (string.lower(class), str) and not string.find (string.lower(subclass), str) and not string.find (string.lower(equipSlot), str)) and b.frame:GetParent():GetParent() == frameMatch then
				SetItemButtonDesaturated(b.frame, 1, 1, 1, 1)
				b.frame:SetAlpha(0.4)
			else
				SetItemButtonDesaturated(b.frame, 0, 1, 1, 1)
				b.frame:SetAlpha(1)
			end
		end
	end
end

function Bag:SearchReset()
	for _, b in ipairs(self.buttons) do
		SetItemButtonDesaturated(b.frame, 0, 1, 1, 1)
		b.frame:SetAlpha(1)
	end
end

local function OpenEditbox(self)
	self:GetParent().detail:Hide()
	self:GetParent().editBox:Show()
	self:GetParent().editBox:SetText(SEARCH)
	self:GetParent().editBox:HighlightText()
end

	
local function Tooltip_Hide(self)
	if self.backdropTexture then
		self:SetBackdropBorderColor(unpack(C.media.bordercolor))
	end
	
	GameTooltip:Hide()
end

local function Tooltip_Show(self)
	GameTooltip:SetOwner(self:GetParent(), "ANCHOR_TOP", 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)
	
	if self.ttText2 then
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(self.ttText2, self.ttText2desc, 1, 1, 1)
	end
	
	GameTooltip:Show()
	
	if self.backdropTexture then
		self:SetBackdropBorderColor(0, .5, 1)
	end	
end

function Bag:CreateBagFrame(type)
	local name = type..'Frame'
	local f = CreateFrame('Button', name, UIParent)
	S.SetBD(f)
	f:SetFrameStrata("DIALOG")
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) self:StartMoving() self:SetUserPlaced(false) end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	
	if type == 'Bags' then
		f:Point('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -15, 30)
	else
		f:Point('BOTTOMRIGHT', BagsFrameHolderFrame, 'BOTTOMLEFT', -30, 0)
	end
	
	f.HolderFrame = CreateFrame("Frame", name.."HolderFrame", f)
	
	f.closeButton = CreateFrame('Button', name..'CloseButton', f)
	f.closeButton:Point('TOPRIGHT', -3, -3)
	f.closeButton:Size(15, 15)
	f.closeButton:SetScript("OnEnter", Tooltip_Show)
	f.closeButton:SetScript("OnLeave", Tooltip_Hide)
	S.ReskinClose(f.closeButton)
	
	if type == 'bags' then
		f.closeButton:SetScript('OnClick', self.CloseBags)
	else
		f.closeButton:SetScript('OnClick', function() f:Hide() end)
	end
	
	f.editBox = CreateFrame('EditBox', name..'EditBox', f)
	f.editBox:Hide()
	f.editBox:SetFrameLevel(f.editBox:GetFrameLevel() + 2)
	f.editBox:Height(15)
	f.editBox:Point('BOTTOMLEFT', f.HolderFrame, 'TOPLEFT', 2, -31)
	f.editBox:Point('BOTTOMRIGHT', f.HolderFrame, 'TOPRIGHT', -153, -31)
	f.editBox:SetAutoFocus(true)	
	f.editBox:SetScript("OnEscapePressed", ResetAndClear)
	f.editBox:SetScript("OnEnterPressed", ResetAndClear)
	f.editBox:SetScript("OnEditFocusLost", f.editBox.Hide)
	f.editBox:SetScript("OnEditFocusGained", f.editBox.HighlightText)
	f.editBox:SetScript("OnTextChanged", UpdateSearch)
	f.editBox:SetText(SEARCH)
	f.editBox:SetFont(DB.Font, S.mult*12)
	f.editBox:SetShadowColor(0, 0, 0)
	f.editBox:SetShadowOffset(S.mult, -S.mult)
	f.editBox.border = CreateFrame("Frame", nil, f.editBox)
	f.editBox.border:Point("TOPLEFT", -3, 0)
	f.editBox.border:Point("BOTTOMRIGHT", 0, 0)
	S.CreateBD(f.editBox.border, 0)

	local tex = f.editBox:CreateTexture(nil, "BACKGROUND")
	tex:Point("TOPLEFT", -3, 0)
	tex:Point("BOTTOMRIGHT", 0, 0)
	tex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	f.detail = f:CreateFontString(nil, "ARTWORK")
	f.detail:SetFont(DB.Font, S.mult*12)
	f.detail:SetShadowColor(0, 0, 0)
	f.detail:SetShadowOffset(S.mult, -S.mult)
	f.detail:SetAllPoints(f.editBox)
	f.detail:SetJustifyH("LEFT")
	f.detail:SetText(SEARCH)

	local button = CreateFrame("Button", nil, f)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetAllPoints(f.detail)
	button.ttText = SEARCHING_FOR_ITEMS
	button:SetScript("OnClick", function(self, btn)
		if btn == "RightButton" then
			OpenEditbox(self)
		else
			if self:GetParent().editBox:IsShown() then
				self:GetParent().editBox:Hide()
				self:GetParent().editBox:ClearFocus()
				self:GetParent().detail:Show()
				Bag:SearchReset()
			else
				OpenEditbox(self)
			end
		end
	end)	
	
	button:SetScript("OnEnter", Tooltip_Show)
	button:SetScript("OnLeave", Tooltip_Hide)	
		
	f.ContainerHolder = CreateFrame('Frame', name..'ContainerHolder', f)
	f.ContainerHolder:SetFrameLevel(f.ContainerHolder:GetFrameLevel() + 4)
	f.ContainerHolder:Point('BOTTOMLEFT', f, 'TOPLEFT', 0, 1)
	f.ContainerHolder.buttons = {}
	f.ContainerHolder:Hide()
	S.CreateBD(f.ContainerHolder)

	return f
end

function Bag:InitBags()
	local f = self:CreateBagFrame('Bags')
	f:SetScript('OnShow', self.Bags_OnShow)
	f:SetScript('OnHide', self.Bags_OnHide)
	
	--Gold Text
	f.goldText = f:CreateFontString(nil, 'OVERLAY')
	f.goldText:SetFont(DB.Font, S.mult*12)
	f.goldText:SetShadowColor(0, 0, 0)
	f.goldText:SetShadowOffset(S.mult, -S.mult)
	f.goldText:Height(15)
	f.goldText:Point('BOTTOMLEFT', f.detail, 'BOTTOMRIGHT', 4, 0)
	f.goldText:Point('TOPRIGHT', f.HolderFrame, 'TOPRIGHT', -12, -17)
	f.goldText:SetJustifyH("RIGHT")
	f.goldText:SetText(GetCoinTextureString(GetMoney(), 12))
	
	f:SetScript("OnEvent", function(self)
		self.goldText:SetText(GetCoinTextureString(GetMoney(), 12))
	end)
	f:RegisterEvent("PLAYER_MONEY")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("PLAYER_TRADE_MONEY")
	f:RegisterEvent("TRADE_MONEY_CHANGED")
	
	--Sort Button
	f.sortButton = CreateFrame('Button', nil, f)
	f.sortButton:Point('TOPLEFT', f, 'TOPLEFT', 7, -4)
	f.sortButton:Size(55, 10)
	f.sortButton.ttText = "整理背包"
	f.sortButton.ttText2 = "按住shift:"
	f.sortButton.ttText2desc = "整理特殊背包"
	f.sortButton:SetScript("OnEnter", Tooltip_Show)
	f.sortButton:SetScript("OnLeave", Tooltip_Hide)	
	f.sortButton:SetScript('OnClick', function() if IsShiftKeyDown() then Bag:Sort(f, 'c/p'); else Bag:Sort(f, 'd'); end end)
	S.Reskin(f.sortButton)
	
	--Stack Button
	f.stackButton = CreateFrame('Button', nil, f)
	f.stackButton:Point('LEFT', f.sortButton, 'RIGHT', 3, 0)
	f.stackButton:Size(55, 10)
	f.stackButton.ttText = "堆叠物品"
	f.stackButton.ttText2 = "按住shift:"
	f.stackButton.ttText2desc = "堆叠特殊背包物品"
	f.stackButton:SetScript("OnEnter", Tooltip_Show)
	f.stackButton:SetScript("OnLeave", Tooltip_Hide)	
	f.stackButton:SetScript('OnClick', function() if IsShiftKeyDown() then Bag:SetBagsForSorting("c/p"); Bag:Restack(f); else Bag:SetBagsForSorting("d"); Bag:Restack(f); end end)
	S.Reskin(f.stackButton)
	
	--Bags Button
	f.bagsButton = CreateFrame('Button', nil, f)
	f.bagsButton:Point('LEFT', f.stackButton, 'RIGHT', 3, 0)
	f.bagsButton:Size(55, 10)
	f.bagsButton.ttText = "显示背包"
	f.bagsButton:SetScript("OnEnter", Tooltip_Show)
	f.bagsButton:SetScript("OnLeave", Tooltip_Hide)	
	f.bagsButton:SetScript('OnClick', function() 
		ToggleFrame(f.ContainerHolder) 
	end)
	S.Reskin(f.bagsButton)
	
	tinsert(UISpecialFrames, f:GetName())
	
	f:Hide()
	bagFrame = f
end

function Bag:InitBank()
	local f = self:CreateBagFrame('Bank')
	f:SetScript('OnHide', CloseBankFrame)
	
	--Gold Text
	f.purchaseBagButton = CreateFrame('Button', nil, f)
	f.purchaseBagButton:Size(100, 17)
	f.purchaseBagButton:Point('TOPRIGHT', f, 'TOPRIGHT', -25, -4)
	f.purchaseBagButton:SetFrameLevel(f.purchaseBagButton:GetFrameLevel() + 2)
	f.purchaseBagButton.text = f.purchaseBagButton:CreateFontString(nil, 'OVERLAY')
	f.purchaseBagButton.text:SetFont(DB.Font, S.mult*12)
	f.purchaseBagButton.text:SetShadowColor(0, 0, 0)
	f.purchaseBagButton.text:SetShadowOffset(S.mult, -S.mult)
	f.purchaseBagButton.text:SetPoint('CENTER', 0, 1)
	f.purchaseBagButton.text:SetJustifyH('CENTER')
	f.purchaseBagButton.text:SetText(BankFramePurchaseButton:GetText())
	f.purchaseBagButton:SetScript("OnEnter", Tooltip_Show)
	f.purchaseBagButton:SetScript("OnLeave", Tooltip_Hide)	
	f.purchaseBagButton:SetScript("OnClick", function()
		local _, full = GetNumBankSlots()
		if not full then
			StaticPopup_Show("BUY_BANK_SLOT")
		else
			StaticPopup_Show("CANNOT_BUY_BANK_SLOT")
		end
	end)	
	S.Reskin(f.purchaseBagButton)
	
	--Sort Button
	f.sortButton = CreateFrame('Button', nil, f)
	f.sortButton:Point('TOPLEFT', f, 'TOPLEFT', 14, -4)
	f.sortButton:Size(85, 10)
	--f.sortButton:SetTemplate('Default', true)
	f.sortButton.ttText = "整理背包"
	f.sortButton.ttText2 = "按住shift:"
	f.sortButton.ttText2desc = "整理特殊背包"
	f.sortButton:SetScript("OnEnter", Tooltip_Show)
	f.sortButton:SetScript("OnLeave", Tooltip_Hide)	
	f.sortButton:SetScript('OnClick', function() if IsShiftKeyDown() then Bag:Sort(f, 'c/p', true); else Bag:Sort(f, 'd', true); end end)
	S.Reskin(f.sortButton)
	
	--Stack Button
	f.stackButton = CreateFrame('Button', nil, f)
	f.stackButton:Point('LEFT', f.sortButton, 'RIGHT', 3, 0)
	f.stackButton:Size(85, 10)
	--f.stackButton:SetTemplate('Default', true)
	f.stackButton.ttText = "堆叠物品"
	f.stackButton.ttText2 = "按住shift:"
	f.stackButton.ttText2desc = "堆叠特殊背包物品"
	f.stackButton:SetScript("OnEnter", Tooltip_Show)
	f.stackButton:SetScript("OnLeave", Tooltip_Hide)	
	f.stackButton:SetScript('OnClick', function() if IsShiftKeyDown() then Bag:SetBagsForSorting("c/p", true); Bag:Restack(f); else Bag:SetBagsForSorting("d", true); Bag:Restack(f); end end)
	S.Reskin(f.stackButton)
	
	--Bags Button
	f.bagsButton = CreateFrame('Button', nil, f)
	f.bagsButton:Point('LEFT', f.stackButton, 'RIGHT', 3, 0)
	f.bagsButton:Size(85, 10)
	--f.bagsButton:SetTemplate('Default', true)
	f.bagsButton.ttText = "显示背包"
	f.bagsButton:SetScript("OnEnter", Tooltip_Show)
	f.bagsButton:SetScript("OnLeave", Tooltip_Hide)	
	f.bagsButton:SetScript('OnClick', function() 
		local numSlots, full = GetNumBankSlots()
		if numSlots >= 1 then
			ToggleFrame(f.ContainerHolder) 
		else
			StaticPopup_Show("NO_BANK_BAGS")
		end	
	end)
	S.Reskin(f.bagsButton)
	
	bankFrame = f
end

function Bag:BAG_UPDATE(event, id)
	self:BagSlotUpdate(id)
end

function Bag:ITEM_LOCK_CHANGED(event, bag, slot)
	if slot == nil then
		return
	end

	for _, v in ipairs(self.buttons) do
		if v.bag == bag and v.slot == slot then
			self:SlotUpdate(v)
			break
		end
	end
end

function Bag:BANKFRAME_OPENED(event)
	if not bankFrame then
		self:InitBank()
	end
		
	self:Layout(true)
	for _, x in ipairs(BAGS_BANK) do
		self:BagSlotUpdate(x)
	end
	
	bankFrame:Show()
	self:OpenBags()
end

function Bag:BANKFRAME_CLOSED(event)
	if not bankFrame then return end
	bankFrame:Hide()
end

function Bag:PLAYERBANKSLOTS_CHANGED(event)
	for i, v in pairs(self.buttons) do
		self:SlotUpdate(v)
	end
	
	for _, x in ipairs(BAGS_BANK) do
		self:BagSlotUpdate(x)
	end
end

function Bag:GUILDBANKBAGSLOTS_CHANGED(event)
	for i, v in pairs(self.buttons) do
		self:SlotUpdate(v)
	end
	
	for _, x in ipairs(BAGS_BANK) do
		self:BagSlotUpdate(x)
	end
end

function Bag:BAG_CLOSED(event, id)
	local b = self.bags[id]
	if b then
		table.remove(self.bags, id)
		b:Hide()
		table.insert(trashBag, #trashBag + 1, b)
	end

	while true do
		local changed = false

		for i, v in ipairs(self.buttons) do
			if v.bag == id then
				v.frame:Hide()

				table.insert(trashButton, #trashButton + 1, v.frame)
				table.remove(self.buttons, i)

				v = nil
				changed = true
			end
		end

		if not changed then
			break
		end
	end
	
	if bagFrame:IsShown() then
		ToggleFrame(bagFrame)
		ToggleFrame(bagFrame)
	end
end

function Bag:CloseBags()
	bagFrame:Hide()
	
	if bankFrame then
		bankFrame:Hide()
	end
end

function Bag:OpenBags()
	bagFrame:Show()
end

function Bag:ToggleBags()
	ToggleFrame(bagFrame)
end

function Bag:RestackOnUpdate(e)
	if not self.elapsed then
		self.elapsed = 0
	end

	self.elapsed = self.elapsed + e

	if self.elapsed < 0.1 then
		return
	end

	self.elapsed = 0
	Bag:Restack(self)
end

local function InBags(x)
	if not Bag.bags[x] then
		return false
	end

	for _, v in ipairs(Bag.sortBags) do
		if x == v then
			return true
		end
	end
	return false
end

function Bag:BAG_UPDATE_COOLDOWN()
	for i, v in pairs(self.buttons) do
		self:SlotUpdate(v)
	end
end

function Bag:Restack(frame)
	local st = {}

	Bag:OpenBags()

	for i, v in pairs(self.buttons) do
		if InBags(v.bag) then
			local tex, cnt, _, _, _, _, clink = GetContainerItemInfo(v.bag, v.slot)
			if clink then
				local n, _, _, _, _, _, _, s = GetItemInfo(clink)

				if cnt ~= s then
					if not st[n] then
						st[n] = {{
							item = v,
							size = cnt,
							max = s
						}}
					else
						table.insert(st[n], {
							item = v,
							size = cnt,
							max = s
						})
					end
				end
			end
		end
	end

	local did_restack = false

	for i, v in pairs(st) do
		if #v > 1 then
			for j = 2, #v, 2 do
				local a, b = v[j - 1], v[j]
				local _, _, l1 = GetContainerItemInfo(a.item.bag, a.item.slot)
				local _, _, l2 = GetContainerItemInfo(b.item.bag, b.item.slot)

				if l1 or l2 then
					did_restack = true
				else
					PickupContainerItem (a.item.bag, a.item.slot)
					PickupContainerItem (b.item.bag, b.item.slot)
					did_restack = true
				end
			end
		end
	end

	if did_restack then
		frame:SetScript("OnUpdate", Bag.RestackOnUpdate)
	else
		frame:SetScript("OnUpdate", nil)
	end
end

function Bag:SortOnUpdate(e)
	if not self.elapsed then
		self.elapsed = 0
	end

	if not Bag.itmax then
		Bag.itmax = 0
	end

	self.elapsed = self.elapsed + e

	if self.elapsed < 0.1 then
		return
	end

	self.elapsed = 0
	Bag.itmax = Bag.itmax + 1

	local changed, blocked  = false, false

	if Bag.sortList == nil or next(Bag.sortList, nil) == nil then
		-- wait for all item locks to be released.
		local locks = false

		for i, v in pairs(Bag.buttons) do
			local _, _, l = GetContainerItemInfo(v.bag, v.slot)
			if l then
				locks = true
			else
				v.block = false
			end
		end

		if locks then
			-- something still locked. wait some more.
			return
		else
			-- all unlocked. get a new table.
			self:SetScript("OnUpdate", nil)
			Bag:SortBags(self)

			if Bag.sortList == nil then
				return
			end
		end
	end

	-- go through the list and move stuff if we can.
	for i, v in ipairs (Bag.sortList) do
		repeat
			if v.ignore then
				blocked = true
				break
			end

			if v.srcSlot.block then
				changed = true
				break
			end

			if v.dstSlot.block then
				changed = true
				break
			end

			local _, _, l1 = GetContainerItemInfo(v.dstSlot.bag, v.dstSlot.slot)
			local _, _, l2 = GetContainerItemInfo(v.srcSlot.bag, v.srcSlot.slot)

			if l1 then
				v.dstSlot.block = true
			end

			if l2 then
				v.srcSlot.block = true
			end

			if l1 or l2 then
				break
			end

			if v.sbag ~= v.dbag or v.sslot ~= v.dslot then
				if v.srcSlot.name ~= v.dstSlot.name then
					v.srcSlot.block = true
					v.dstSlot.block = true
					PickupContainerItem (v.sbag, v.sslot)
					PickupContainerItem (v.dbag, v.dslot)
					changed = true
					break
				end
			end
		until true
	end

	Bag.sortList = nil

	if (not changed and not blocked) or Bag.itmax > 250 then
		self:SetScript("OnUpdate", nil)
		Bag.sortList = nil
	end
end

function Bag:SortBags(frame)
	if InCombatLockdown() then return end;
	local bs = self.sortBags
	if #bs < 1 then
		return
	end

	local st = {}
	self:OpenBags()

	for i, v in pairs(self.buttons) do
		if InBags(v.bag) then
			self:SlotUpdate(v)

			if v.name then
				local tex, cnt, _, _, _, _, clink = GetContainerItemInfo(v.bag, v.slot)
				local n, _, q, iL, rL, c1, c2, _, Sl = GetItemInfo(clink)
				table.insert(st, {
					srcSlot = v,
					sslot = v.slot,
					sbag = v.bag,
					--sort = q .. iL .. c1 .. c2 .. rL .. Sl .. n .. i,
					--sort = q .. iL .. c1 .. c2 .. rL .. Sl .. n .. (#self.buttons - i),
					sort = q .. c1 .. c2 .. rL .. n .. iL .. Sl .. (#self.buttons - i),
					--sort = q .. (#self.buttons - i) .. n,
				})
			end
		end
	end

	table.sort (st, function(a, b)
		return a.sort > b.sort
	end)

	local st_idx = #bs
	local dbag = bs[st_idx]
	local dslot = GetContainerNumSlots(dbag)
 
	for i, v in ipairs (st) do
		v.dbag = dbag
		v.dslot = dslot
		v.dstSlot = self:SlotNew(dbag, dslot)
 
		dslot = dslot - 1
 
		if dslot == 0 then
			while true do
				st_idx = st_idx - 1
 
				if st_idx < 0 then
					break
				end
 
				dbag = bs[st_idx]
				
				if dbag and (Bag:BagType(dbag) == ST_NORMAL or Bag:BagType(dbag) == ST_SPECIAL or dbag < 1) then
					break
				end
			end
			
			if dbag then
				dslot = GetContainerNumSlots(dbag)
			else
				dslot = 8
			end
		end
	end

	local changed = true
	while changed do
		changed = false
		for i, v in ipairs (st) do
			if (v.sslot == v.dslot) and (v.sbag == v.dbag) then
				table.remove (st, i)
				changed = true
			end
		end
	end

	if st == nil or next(st, nil) == nil then
		frame:SetScript("OnUpdate", nil)
	else
		self.sortList = st
		frame:SetScript("OnUpdate", Bag.SortOnUpdate)
	end
end

function Bag:SetBagsForSorting(c, bank)
	self:OpenBags()

	self.sortBags = {}

	local cmd = ((c == nil or c == "") and {"d"} or {strsplit("/", c)})

	for _, s in ipairs(cmd) do
		if s == "c" then
			self.sortBags = {}
		elseif s == "d" then
			if not bank then
				for _, i in ipairs(BAGS_BACKPACK) do
					if self.bags[i] and self.bags[i].bagType == ST_NORMAL then
						table.insert(self.sortBags, i)
					end
				end
			else
				for _, i in ipairs(BAGS_BANK) do
					if self.bags[i] and self.bags[i].bagType == ST_NORMAL then
						table.insert(self.sortBags, i)
					end
				end
			end
		elseif s == "p" then
			if not bank then
				for _, i in ipairs(BAGS_BACKPACK) do
					if self.bags[i] and self.bags[i].bagType == ST_SPECIAL then
						table.insert(self.sortBags, i)
					end
				end
			else
				for _, i in ipairs(BAGS_BANK) do
					if self.bags[i] and self.bags[i].bagType == ST_SPECIAL then
						table.insert(self.sortBags, i)
					end
				end
			end
		else
			table.insert(self.sortBags, tonumber(s))
		end
	end
end

function Bag:Sort(frame, args, bank)
	if not args then
		args = ""
	end

	self.itmax = 0
	self:SetBagsForSorting(args, bank)
	self:SortBags(frame)
end

Bag:InitBags()

--Register Events
Bag:RegisterEvent("BAG_UPDATE")
Bag:RegisterEvent("ITEM_LOCK_CHANGED")
Bag:RegisterEvent("BANKFRAME_OPENED")
Bag:RegisterEvent("BANKFRAME_CLOSED")
Bag:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
Bag:RegisterEvent("BAG_CLOSED")	
Bag:RegisterEvent("BAG_UPDATE_COOLDOWN")
Bag:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED")
Bag:SetScript("OnEvent", function(self, event, ...)
	if type(self[event]) == "function" then
		self[event](self, event, ...)
	end
end)

--Hook onto Blizzard Functions
ToggleBackpack = Bag.ToggleBags
ToggleBag = Bag.ToggleBags
ToggleAllBags = Bag.ToggleBags
OpenAllBags = Bag.OpenBags
OpenBackpack = Bag.OpenBags
CloseAllBags = Bag.CloseBags
CloseBackpack = Bag.CloseBags

TradeFrame:HookScript("OnShow", function() Bag:OpenBags() end)
TradeFrame:HookScript("OnHide", function() Bag:CloseBags() end)

--Stop Blizzard bank bags from functioning.
BankFrame:UnregisterAllEvents()

StackSplitFrame:SetFrameStrata('DIALOG')
LootFrame:SetFrameStrata('DIALOG')

StaticPopupDialogs["BUY_BANK_SLOT"] = {
	text = CONFIRM_BUY_BANK_SLOT,
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		PurchaseSlot()
	end,
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, GetBankSlotCost())
	end,
	hasMoneyFrame = 1,
	timeout = 0,
	hideOnEscape = 1,
	preferredIndex = 3
}

StaticPopupDialogs["CANNOT_BUY_BANK_SLOT"] = {
	text = "不能购买更多的银行栏位了!",
	button1 = ACCEPT,
	timeout = 0,
	whileDead = 1,	
	preferredIndex = 3
}

StaticPopupDialogs["NO_BANK_BAGS"] = {
	text = "你必须先购买一个银行栏位!",
	button1 = ACCEPT,
	timeout = 0,
	whileDead = 1,	
	preferredIndex = 3
}