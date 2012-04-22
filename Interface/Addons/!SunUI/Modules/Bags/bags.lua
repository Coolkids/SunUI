local S, C, L, DB = unpack(select(2, ...))
local config = {
	size = 30,
	spacing = 2,
	bpr = 10
}

local toggle
local togglebag

local bags = {
	bag = {
		CharacterBag0Slot,
		CharacterBag1Slot,
		CharacterBag2Slot,
		CharacterBag3Slot
	},
	bank = {
		BankFrameBag1,
		BankFrameBag2,
		BankFrameBag3,
		BankFrameBag4,
		BankFrameBag5,
		BankFrameBag6,
		BankFrameBag7
	}
}

function SetUp(framen, ...)
	local frame = CreateFrame("Frame", "bBag_"..framen, UIParent)
	frame:SetWidth(((config.size+config.spacing)*config.bpr)+20-config.spacing)
	frame:SetPoint(...)
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(1)
	frame:RegisterForDrag("LeftButton","RightButton")
	frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	frame:Hide()
	--frame:CreateBD()
	 S.SetBD(frame)
	frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:SetUserPlaced(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton","RightButton")
	
	local frame_bags = CreateFrame('Frame', "bBag_"..framen.."_bags")
	frame_bags:SetParent("bBag_"..framen)
	frame_bags:SetWidth(10)
	frame_bags:SetHeight(10)
	frame_bags:SetPoint("BOTTOMRIGHT", "bBag_"..framen, "TOPRIGHT", 0, -2)
	frame_bags:Hide()
	frame_bags:CreateBD()
	
	local frame_bags_toggle = CreateFrame('Frame', "bBag_"..framen.."_bags_toggle")
	frame_bags_toggle:SetHeight(20)
	frame_bags_toggle:SetWidth(20)
	frame_bags_toggle:SetPoint("TOPRIGHT", "bBag_"..framen, "TOPRIGHT", -26, -6)
	frame_bags_toggle:SetParent("bBag_"..framen)
	frame_bags_toggle:EnableMouse(true)
	
	local frame_bags_toggle_text = frame_bags_toggle:CreateFontString("button")
	frame_bags_toggle_text:SetPoint("CENTER", frame_bags_toggle, "CENTER")
	frame_bags_toggle_text:SetFont(DB.Font, 12, "OUTLINE")
	frame_bags_toggle_text:SetText("B")
	frame_bags_toggle_text:SetTextColor(.4,.4,.4)
	frame_bags_toggle:SetScript('OnMouseUp', function()
		if (togglebag ~= 1) then
			togglebag = 1
		else
			togglebag= 0
		end
		if togglebag == 1 then
			frame_bags:Show()
			frame_bags_toggle_text:SetTextColor(1,1,1)
		else
			frame_bags:Hide()
			frame_bags_toggle_text:SetTextColor(.4,.4,.4)
		end
	end)
	
	local jp = CreateFrame('Frame', "bBag_"..framen.."_bags_toggle")
	jp:SetHeight(20)
	jp:SetWidth(20)
	jp:SetPoint("TOPRIGHT", "bBag_"..framen, "TOPRIGHT", -14, -6)
	jp:SetParent("bBag_"..framen)
	jp:EnableMouse(true)
	
	local jpt = jp:CreateFontString("button")
	jpt:SetPoint("CENTER", jp, "CENTER")
	jpt:SetFont(DB.Font, 12, "OUTLINE")
	jpt:SetText("P")
	jpt:SetTextColor(.4,.4,.4)
	jp:SetScript('OnMouseUp', function()
		JPack:Pack()
	end)
	
	local close = CreateFrame('Frame', "bBag_"..framen.."_bags_toggle")
	close:SetHeight(20)
	close:SetWidth(20)
	close:SetPoint("TOPRIGHT", "bBag_"..framen, "TOPRIGHT", 0, -6)
	close:SetParent("bBag_"..framen)
	close:EnableMouse(true)
	
	local closet = close:CreateFontString("button")
	closet:SetPoint("CENTER", close, "CENTER")
	closet:SetFont(DB.Font, 12, "OUTLINE")
	closet:SetText("X")
	closet:SetTextColor(.4,.4,.4)
	close:SetScript('OnMouseUp', function()
		CloseAllBags()
	end)
	
	if (framen == "bag") then
		for _, f in pairs(bags.bag) do
			local count = _G[f:GetName().."Count"]
			local icon = _G[f:GetName().."IconTexture"]
			f:SetParent(_G["bBag_"..framen.."_bags"])
			f:ClearAllPoints()
			f:SetWidth(24)
			f:SetHeight(24)
			if lastbuttonbag then
				f:SetPoint("LEFT", lastbuttonbag, "RIGHT", config.spacing, 0)
			else
				f:SetPoint("TOPLEFT", _G["bBag_"..framen.."_bags"], "TOPLEFT", 8, -8)
			end
			count.Show = function() end
			count:Hide()

			icon:SetTexCoord(.1, .9, .1, .9)
			f:SetNormalTexture("")
			f:SetPushedTexture("")
			f:SetCheckedTexture("")
			--f:CreateBorder()
			lastbuttonbag = f
			_G["bBag_"..framen.."_bags"]:SetWidth((24+config.spacing)*(getn(bags.bag))+14)
			_G["bBag_"..framen.."_bags"]:SetHeight(40)
		end
	else
		for _, f in pairs(bags.bank) do
			local count = _G[f:GetName().."Count"]
			local icon = _G[f:GetName().."IconTexture"]
			f:SetParent(_G["bBag_"..framen.."_bags"])
			f:ClearAllPoints()
			f:SetWidth(24)
			f:SetHeight(24)
			if lastbuttonbank then
				f:SetPoint("LEFT", lastbuttonbank, "RIGHT", config.spacing, 0)
			else
				f:SetPoint("TOPLEFT", _G["bBag_"..framen.."_bags"], "TOPLEFT", 8, -8)
			end
			count.Show = function() end
			count:Hide()

			icon:SetTexCoord(.06, .94, .06, .94)
			f:SetNormalTexture("")
			f:SetPushedTexture("")
			f:SetHighlightTexture("")
			--f:CreateBorder()
			lastbuttonbank = f
			_G["bBag_"..framen.."_bags"]:SetWidth((24+config.spacing)*(getn(bags.bank))+14)
			_G["bBag_"..framen.."_bags"]:SetHeight(40)
		end
	end
end

local function skin(index, frame)
    for i = 1, index do
        local bag = _G[frame..i]
		local f = _G[bag:GetName().."IconTexture"]
        bag:SetNormalTexture("")
        bag:SetPushedTexture("")
		bag:CreateBorder()
        f:Point("TOPLEFT", bag, 1.5, -1.5)
		f:Point("BOTTOMRIGHT", bag, -1.5, 1.5)
        f:SetTexCoord(.1, .9, .1, .9)
    end
end

ContainerFrame1Item1:SetScript("OnShow", function() 
    toggle = 1
end)
ContainerFrame1Item1:SetScript("OnHide", function() 
    toggle = 0
end)

for i = 1, 12 do
	_G["ContainerFrame"..i..'CloseButton']:Hide()
	_G["ContainerFrame"..i..'PortraitButton']:Hide()
	_G["ContainerFrame"..i]:EnableMouse(false)
	_G["ContainerFrame"..i]:HookScript("OnHide", function(self) if toggle == 1 then self:Show() else self:Hide() end end)
	skin(36, "ContainerFrame"..i.."Item")
	for p = 1, 7 do
		select(p, _G["ContainerFrame"..i]:GetRegions()):SetAlpha(0)
    end
end

ContainerFrame1Item1:SetScript("OnHide", function() _G["bBag_bag"]:Hide()end)
ContainerFrame1Item1:SetScript("OnShow", function() _G["bBag_bag"]:Show()end)
BankFrameItem1:SetScript("OnHide", function() 
	for i = 5, 12 do
		ToggleBag(i) 
	end
	_G["bBag_bank"]:Hide()
end)
BankFrameItem1:SetScript("OnShow", function() 
	for i = 5, 12 do
		ToggleBag(i) 
	end
	_G["bBag_bank"]:Show()
end)

SetUp("bag", "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 10)
SetUp("bank", "TOPLEFT", UIParent, "TOPLEFT", 20, -20)
skin(28, "BankFrameItem")
skin(7, "BankFrameBag")

BagItemSearchBox:SetScript("OnUpdate", function()
	BagItemSearchBox:ClearAllPoints()
	BagItemSearchBox:SetSize(4.5*(config.spacing+config.size),20)
	BagItemSearchBox:SetPoint("LEFT", ContainerFrame1MoneyFrame, "RIGHT", 2, 0)
end)

function SkinEditBox(frame)
	if _G[frame:GetName().."Left"] then _G[frame:GetName().."Left"]:Hide() end
	if _G[frame:GetName().."Middle"] then _G[frame:GetName().."Middle"]:Hide() end
	if _G[frame:GetName().."Right"] then _G[frame:GetName().."Right"]:Hide() end
	if _G[frame:GetName().."Mid"] then _G[frame:GetName().."Mid"]:Hide() end
	
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(2)
	frame:SetWidth(200) 
end

SkinEditBox(BagItemSearchBox)

function ContainerFrame_GenerateFrame(frame, size, id)
	frame.size = size;
	for i=1, size, 1 do
		local index = size - i + 1;
		local itemButton = _G[frame:GetName().."Item"..i];
		itemButton:SetID(index);
		itemButton:Show();
	end
	frame:SetID(id);
	frame:Show();
	updateContainerFrameAnchors();
	
	if ( id < 5 ) then
		local numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
		for bag = 1, 5 do
			local slots = GetContainerNumSlots(bag-1)
			for item = slots, 1, -1 do
				local itemframes = _G["ContainerFrame"..bag.."Item"..item]
				itemframes:ClearAllPoints()
				itemframes:SetWidth(config.size)
				itemframes:SetHeight(config.size)
				itemframes:SetFrameStrata("HIGH")
				itemframes:SetFrameLevel(2)
				ContainerFrame1MoneyFrame:ClearAllPoints()
				ContainerFrame1MoneyFrame:Show()
				ContainerFrame1MoneyFrame:SetPoint("TOPLEFT", _G["bBag_bag"], "TOPLEFT", 6, -10)
				ContainerFrame1MoneyFrame:SetFrameStrata("HIGH")
				ContainerFrame1MoneyFrame:SetFrameLevel(2)
				if bag==1 and item==16 then
					itemframes:SetPoint("TOPLEFT", _G["bBag_bag"], "TOPLEFT", 10, -30)
					lastrowbutton = itemframes
					lastbutton = itemframes
				elseif numbuttons==config.bpr then
					itemframes:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+config.size))
					itemframes:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+config.size))
					lastrowbutton = itemframes
					numrows = numrows + 1
					numbuttons = 1
				else
					itemframes:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+config.size), 0)
					itemframes:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+config.size), 0)
					numbuttons = numbuttons + 1
				end
				lastbutton = itemframes
			end
		end
		_G["bBag_bag"]:SetHeight(((config.size+config.spacing)*(numrows+1)+40)-config.spacing)
	else
		local numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
		for bank = 1, 28 do
			local bankitems = _G["BankFrameItem"..bank]
			bankitems:ClearAllPoints()
			bankitems:SetWidth(config.size)
			bankitems:SetHeight(config.size)
			bankitems:SetFrameStrata("HIGH")
			bankitems:SetFrameLevel(2)
			ContainerFrame2MoneyFrame:Show()
			ContainerFrame2MoneyFrame:ClearAllPoints()
			ContainerFrame2MoneyFrame:SetPoint("TOPLEFT", _G["bBag_bank"], "TOPLEFT", 6, -10)
			ContainerFrame2MoneyFrame:SetFrameStrata("HIGH")
			ContainerFrame2MoneyFrame:SetFrameLevel(2)
			BankFrameMoneyFrame:Hide()
			if bank==1 then
				bankitems:SetPoint("TOPLEFT", _G["bBag_bank"], "TOPLEFT", 10, -30)
				lastrowbutton = bankitems
				lastbutton = bankitems
			elseif numbuttons==config.bpr then
				bankitems:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+config.size))
				bankitems:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+config.size))
				lastrowbutton = bankitems
				numrows = numrows + 1
				numbuttons = 1
			else
				bankitems:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+config.size), 0)
				bankitems:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+config.size), 0)
				numbuttons = numbuttons + 1
			end
			lastbutton = bankitems
		end
		for bag = 6, 12 do
			local slots = GetContainerNumSlots(bag-1)
			for item = slots, 1, -1 do
				local itemframes = _G["ContainerFrame"..bag.."Item"..item]
				itemframes:ClearAllPoints()
				itemframes:SetWidth(config.size)
				itemframes:SetHeight(config.size)
				itemframes:SetFrameStrata("HIGH")
				itemframes:SetFrameLevel(2)
				if numbuttons==config.bpr then
					itemframes:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+config.size))
					itemframes:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+config.size))
					lastrowbutton = itemframes
					numrows = numrows + 1
					numbuttons = 1
				else
					itemframes:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+config.size), 0)
					itemframes:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+config.size), 0)
					numbuttons = numbuttons + 1
				end
				lastbutton = itemframes
			end
		end
		_G["bBag_bank"]:SetHeight(((config.size+config.spacing)*(numrows+1)+40)-config.spacing)
	end
end
