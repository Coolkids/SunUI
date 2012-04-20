local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("loot", "AceTimer-3.0")
function Module:OnInitialize()
local  iconsize = 24
local L = {
	fish = "Fishy loot",
	empty = "Empty slot",
}
local addon = CreateFrame("Button", "m_Loot")
local title = addon:CreateFontString(nil, "OVERLAY")
local lb = CreateFrame("Button", "m_LootAdv", addon, "UIPanelScrollDownButtonTemplate")		-- Link button
local LDD = CreateFrame("Frame", "m_LootLDD", addon, "UIDropDownMenuTemplate")				-- Link dropdown menu frame

local sq, ss, sn
local OnEnter = function(self)
	local slot = self:GetID()
	if(LootSlotIsItem(slot)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end
	S.StartGlow(self)
	--self.drop:Show()
	--self.drop:SetVertexColor(1, 1, 0)
end


local function OnLinkClick(self)
    ToggleDropDownMenu(1, nil, LDD, lb, 0, 0)
end

local function LDD_OnClick(self)
    local val = self.value
	Announce(val)
end

function Announce(chn)
    local nums = GetNumLootItems()
    if(nums == 0) then return end
    if UnitIsPlayer("target") or not UnitExists("target") then -- Chests are hard to identify!
		SendChatMessage("*** SunUI Loot from chest ***", chn)
	else
		SendChatMessage("*** SunUI Loot from "..UnitName("target").." ***", chn)
	end
    for i = 1, GetNumLootItems() do
        if(LootSlotIsItem(i)) then
            local link = GetLootSlotLink(i)
            local messlink = "- %s"
            SendChatMessage(format(messlink, link), chn)
        end
    end
end

local function LDD_Initialize()  
    local info = {}
    
    info.text = "Announce to"
    info.notCheckable = true
    info.isTitle = true
    UIDropDownMenu_AddButton(info)
    
    --announce chanels
    info = {}
    info.text = "  raid"
    info.value = "raid"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
    
    info = {}
    info.text = "  guild"
    info.value = "guild"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
	
	info = {}
    info.text = "  party"
    info.value = "party"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "  say"
    info.value = "say"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
    
    info = nil
end

local OnLeave = function(self)
	S.StopGlow(self)
	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
		ss = self:GetID()
		sq = self.quality
		sn = self.name:GetText()
		LootSlot(ss)
	end
end

local OnUpdate = function(self)
	if(GameTooltip:IsOwned(self)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end
end

local createSlot = function(id)
	local frame = CreateFrame("Button", 'm_LootSlot'..id, addon)
	frame:SetPoint("LEFT", 6, 0)
	frame:SetPoint("RIGHT", -6, 0)
	frame:SetHeight(iconsize+2)
	frame:SetID(id)
	
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnUpdate", OnUpdate)
	
	frame.glow = CreateFrame("Frame", nil, frame)
	frame.glow:SetBackdrop({
		edgeFile = DB.GlowTex,
		edgeSize = S.Scale(5),
	})
	frame.glow:SetPoint("TOPLEFT", -6, 6)
	frame.glow:SetPoint("BOTTOMRIGHT", 6, -6)
	frame.glow:SetBackdropBorderColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
	frame.glow:SetAlpha(0)
	
	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:SetHeight(iconsize)
	iconFrame:SetWidth(iconsize)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint("LEFT", frame, 2,0)
	
	local icon = iconFrame:CreateTexture(nil, "BACKGROUND")
	icon:SetAlpha(.8)
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetAllPoints(iconFrame)
	frame.icon = icon
    
	local overlay = CreateFrame("Frame", nil, iconFrame)
	overlay:SetBackdrop({
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",   --, 
			edgeSize = S.mult+0.2, 
		})
	overlay:SetPoint("TOPLEFT",iconFrame,"TOPLEFT", -1, 1)
	overlay:SetPoint("BOTTOMRIGHT",iconFrame,"BOTTOMRIGHT", 1, -1)
	frame.overlay = overlay
	
	local count = iconFrame:CreateFontString(nil, "OVERLAY")
	count:ClearAllPoints()
	count:SetJustifyH"RIGHT"
	count:SetPoint("BOTTOMRIGHT", iconFrame, 2, 2)
	count:SetFontObject(NumberFontNormal)
	count:SetShadowOffset(.8, -.8)
	count:SetShadowColor(0, 0, 0, 1)
	count:SetText(1)
	frame.count = count

	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH"LEFT"
	name:ClearAllPoints()
	name:SetPoint("RIGHT", frame)
	name:SetPoint("LEFT", icon, "RIGHT",8,0)
	name:SetNonSpaceWrap(true)
	name:SetFont(DB.Font, 12*S.Scale(1), "OUTLINE")
	--name:SetFontObject(GameFontWhite)GameTooltipHeaderText

	name:SetWidth(70)
	frame.name = name
	frame:SetPoint("TOP", addon, 8, (-5+iconsize)-(id*(iconsize+5))-10)
	--frame:SetBackdrop{
	--edgeFile = DB.edgetex, edgeSize = 10,
	--insets = {left = 0, right = 0, top = 0, bottom = 0},
	--}
	addon.slots[id] = frame
	
	return frame

end

title:SetFont(DB.Font, 14*S.Scale(1), "OUTLINE")
title:SetJustifyH"LEFT"
title:SetPoint("TOPLEFT", addon, "TOPLEFT", 4, 6)

addon:SetScript("OnMouseDown", function(self) if(IsAltKeyDown()) then self:StartMoving() end end)
addon:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
addon:SetScript("OnHide", function(self)
	StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
	CloseLoot()
end)
addon:SetMovable(true)
addon:RegisterForClicks"anyup"

addon:SetParent(UIParent)
addon:SetUserPlaced(true)
addon:SetPoint("TOPLEFT", 0, -104)
addon:SetWidth(160)  
addon:SetHeight(84)
--addon:CreateShadow("Background")
S.SetBD(addon)


addon:SetClampedToScreen(true)
addon:SetClampRectInsets(0, 0, 14, 0)
addon:SetHitRectInsets(0, 0, -14, 0)
addon:SetFrameStrata"HIGH"
addon:SetToplevel(true)

lb:ClearAllPoints()
lb:SetWidth(20)
lb:SetHeight(14)
lb:SetScale(0.85)
lb:SetPoint("TOPRIGHT", addon, "TOPRIGHT", -35, -5)
lb:SetFrameStrata("TOOLTIP")
lb:RegisterForClicks("RightButtonUp", "LeftButtonUp")
lb:SetScript("OnClick", OnLinkClick)
lb:Hide()
UIDropDownMenu_Initialize(LDD, LDD_Initialize, "MENU")

addon.slots = {}
addon.LOOT_CLOSED = function(self)
	StaticPopup_Hide"LOOT_BIND"
	self:Hide()

	for _, v in pairs(self.slots) do
		v:Hide()
	end
	lb:Hide()
end
addon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()
	lb:Show()
	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	if(IsFishingLoot()) then
		title:SetText(L.fish)
	elseif(not UnitIsFriend("player", "target") and UnitIsDead"target") then
		title:SetText(UnitName"target")
	else
		title:SetText(LOOT)
	end

	-- Blizzard uses strings here
	if(GetCVar("lootUnderMouse") == "1") then
		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", x-40, y+20)
		self:GetCenter()
		self:Raise()
	end

	local m = 0
	if(items > 0) then
		if item == 0 then return end
		for i=1, items do
			local slot = addon.slots[i] or createSlot(i)
			local texture, item, quantity, quality, locked = GetLootSlotInfo(i)
			local color
			if quality then
				local color = ITEM_QUALITY_COLORS[quality]
			end
			if quality < 2 then q.r, q.g, q.b = 0, 0, 0 else q.r, q.g, q.b = color.r, color.g, color.b end
			if(LootSlotIsCoin(i)) then
				item = item:gsub("\n", ", ")
			end

			if(quantity and quantity > 1) then
				slot.count:SetText(quantity)
				slot.count:Show()
			else
				slot.count:Hide()
			end

			slot.overlay:SetBackdropBorderColor(q.r, q.g, q.b)
			slot:SetBackdropBorderColor(color.r, color.g, color.b)
			--slot.drop:SetVertexColor(color.r, color.g, color.b)
			--slot.drop:Show()

			slot.quality = quality
			slot.name:SetText(item)
			slot.name:SetTextColor(color.r, color.g, color.b)
			slot.icon:SetTexture(texture)

			m = math.max(m, quality)

			slot:Enable()
			slot:Show()
		end
	else
		local slot = addon.slots[1] or createSlot(1)
		local color = ITEM_QUALITY_COLORS[0]

		slot.name:SetText(L.empty)
		slot.name:SetTextColor(color.r, color.g, color.b)
		slot.icon:SetTexture[[Interface\Icons\INV_Misc_Herb_AncientLichen]]

		items = 1

		slot.count:Hide()
		--slot.drop:Hide()
		slot:Disable()
		slot:Show()
	end

	local color = ITEM_QUALITY_COLORS[m]
	self:SetBackdropBorderColor(color.r, color.g, color.b, .8)
	self:SetHeight(math.max((items*(iconsize+10))+27), 20)
	self:SetWidth(150)
	title:SetWidth(125)
	title:SetHeight(iconsize+2)
	
	local close = CreateFrame("Button", nil, addon, "UIPanelCloseButton" )
	close:SetPoint("TOPRIGHT", 0, 8)
	close:SetScale(0.7)
	--close:SetScript("OnClick", function(self) self:GetParent():Hide() end)
	S.ReskinClose(close)

end

addon.LOOT_SLOT_CLEARED = function(self, event, slot)
	if(not self:IsShown()) then return end

	addon.slots[slot]:Hide()
	
end



addon.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(1, nil, GroupLootDropDown, addon.slots[ss], 0, 0)
end

addon.UPDATE_MASTER_LOOT_LIST = function(self)
	UIDropDownMenu_Refresh(GroupLootDropDown)
end

addon:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

addon:RegisterEvent"LOOT_OPENED"
addon:RegisterEvent"LOOT_SLOT_CLEARED"
addon:RegisterEvent"LOOT_CLOSED"
addon:RegisterEvent"OPEN_MASTER_LOOT_LIST"
addon:RegisterEvent"UPDATE_MASTER_LOOT_LIST"
addon:Hide()

-- Fuzz
LootFrame:UnregisterAllEvents()
table.insert(UISpecialFrames, "m_Loot")

function _G.GroupLootDropDown_GiveLoot(self)
	if ( sq >= MASTER_LOOT_THREHOLD ) then
		local dialog = StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION", ITEM_QUALITY_COLORS[sq].hex..sn..FONT_COLOR_CODE_CLOSE, self:GetText())
		if (dialog) then
			dialog.data = self.value
		end
	else
		GiveMasterLoot(ss, self.value)
	end
	CloseDropDownMenus()
end

StaticPopupDialogs["CONFIRM_LOOT_DISTRIBUTION"].OnAccept = function(self, data)
	GiveMasterLoot(ss, data)
end

-- MasterLoot module
local hexColors = {}
for k, v in pairs(RAID_CLASS_COLORS) do
	hexColors[k] = string.format("|cff%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
end
hexColors["UNKNOWN"] = string.format("|cff%02x%02x%02x", 0.6*255, 0.6*255, 0.6*255)

if CUSTOM_CLASS_COLORS then
	local function update()
		for k, v in pairs(CUSTOM_CLASS_COLORS) do
			hexColors[k] = ("|cff%02x%02x%02x"):format(v.r * 255, v.g * 255, v.b * 255)
		end
	end
	CUSTOM_CLASS_COLORS:RegisterCallback(update)
	update()
end

local playerName = UnitName("player")
local unknownColor = { r = .6, g = .6, b = .6 }
local classesInRaid = {}
local randoms = {}
local function CandidateUnitClass(candidate)
	local class, fileName = UnitClass(candidate)
	if class then
		return class, fileName
	end
	return L_ML_UNKNOWN, "UNKNOWN"
end

local function init()
	local candidate, color
	local info = UIDropDownMenu_CreateInfo()
	
	if UIDROPDOWNMENU_MENU_LEVEL == 2 then
		-- raid class menu
		for i = 1, 40 do
			candidate = GetMasterLootCandidate(i)
			if candidate then
				local class = select(2, CandidateUnitClass(candidate))
				if class == UIDROPDOWNMENU_MENU_VALUE then -- we check for not class adding everyone that left the raid to every menu to prevent not being able to loot to them
					-- Add candidate button
					info.text = candidate -- coloredNames[candidate]
					info.colorCode = hexColors[class] or hexColors["UNKOWN"]
					info.textHeight = 12
					info.value = i
					info.notCheckable = 1
					info.disabled = nil
					info.func = GroupLootDropDown_GiveLoot
					UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL)
				end
			end
		end
		return
	end

	info.isTitle = 1
	info.text = GIVE_LOOT
	info.textHeight = 12
	info.notCheckable = 1
	info.disabled = nil
	info.notClickable = nil
	UIDropDownMenu_AddButton(info)
	
	if ( GetNumRaidMembers() > 0 ) then
		-- In a raid

		for k, v in pairs(classesInRaid) do
			classesInRaid[k] = nil
		end
		for i = 1, 40 do
			candidate = GetMasterLootCandidate(i)
			if candidate then
				local cname, class = CandidateUnitClass(candidate)
				classesInRaid[class] = cname
			end		
		end

		for k, v in pairs(classesInRaid) do
			info.isTitle = nil
			info.text = v -- classColors[k]..v.."|r"
			info.colorCode = hexColors[k] or hexColors["UNKOWN"]
			info.textHeight = 12
			info.hasArrow = 1
			info.notCheckable = 1
			info.value = k
			info.func = nil
			info.disabled = nil
			UIDropDownMenu_AddButton(info)
		end
	else
		-- In a party
		for i=1, MAX_PARTY_MEMBERS+1, 1 do
			candidate = GetMasterLootCandidate(i)
			if candidate then
				-- Add candidate button
				info.text = candidate -- coloredNames[candidate]
				info.colorCode = hexColors[select(2,CandidateUnitClass(candidate))] or hexColors["UNKOWN"]
				info.textHeight = 12
				info.value = i
				info.notCheckable = 1
				info.hasArrow = nil
				info.isTitle = nil
				info.disabled = nil
				info.func = GroupLootDropDown_GiveLoot
				UIDropDownMenu_AddButton(info)
			end
		end
	end
	
	for k, v in pairs(randoms) do randoms[k] = nil end
	for i = 1, 40 do
		candidate = GetMasterLootCandidate(i)
		if candidate then
			table.insert(randoms, i)
		end
	end
	if #randoms > 0 then
		info.colorCode = "|cffffffff"
		info.isTitle = nil
		info.textHeight = 12
		info.value = randoms[math.random(1, #randoms)]
		info.notCheckable = 1
		info.text = "Random"
		info.func = GroupLootDropDown_GiveLoot
		info.icon = nil--"Interface\\Buttons\\UI-GroupLoot-Dice-Up"
		UIDropDownMenu_AddButton(info)
	end
	for i = 1, 40 do
		candidate = GetMasterLootCandidate(i)
		if candidate and candidate == playerName then
			info.colorCode = hexColors[select(2,CandidateUnitClass(candidate))] or hexColors["UNKOWN"]
			info.isTitle = nil
			info.textHeight = 12
			info.value = i
			info.notCheckable = 1
			info.text = "Self"
			info.func = GroupLootDropDown_GiveLoot
			info.icon = nil--"Interface\\Buttons\\UI-GroupLoot-Coin-Up"
			UIDropDownMenu_AddButton(info)
		end
	end
end

UIDropDownMenu_Initialize(GroupLootDropDown, init, "MENU")
end