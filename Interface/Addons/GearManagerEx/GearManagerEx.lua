------------------------------------------------------------
-- GearManagerEx.lua
--
-- Abin
-- 2009-6-10
------------------------------------------------------------

local L = GEARMANAGEREX_LOCALE -- Locale table
local VERSION = GetAddOnMetadata("GearManagerEx", "Version") or "1.0"
local BANKS = { -1, 5, 6, 7, 8, 9, 10, 11 } -- Bag id's for bank
local BAGS = { 0, 1, 2, 3, 4 } -- Bag id's for container

local db = { talentBind = {}, stripped = {}, showHelms = {}, showCloaks = {} } -- Mapped to GearManagerExDB
local activeId, activeSet, bankOpened, rClickedSet, rClickedSetIcon, prevDropDown

-- Checked icon frame
local checkFrame = CreateFrame("Frame", "GearManagerExCheckFrame", PaperDollEquipmentManagerPane)
checkFrame:Hide()

local checkIcon = checkFrame:CreateTexture("GearManagerExCheckFrameIcon", "OVERLAY")
checkIcon:SetAllPoints(checkFrame)
checkIcon:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")

--Prints a message
local function PrintMessage(msg, ...)
	-- DEFAULT_CHAT_FRAME:AddMessage("|cffffff78GearManagerEx:|r "..tostring(msg), ...)
end

-- Extracts item id
local function GetItemId(bag, slot)
	local lnk
	if slot then
		lnk = GetContainerItemLink(bag, slot)
	else
		lnk = GetInventoryItemLink("player", bag)
	end

	if lnk then
		local _, _, id = strfind(lnk, "item:(%d+).+%[(.+)%]")
		return tonumber(id or "")
	end
end

-- Use a container item by id
local function UseContainerItemById(containers, itemId)
	if itemId and itemId > 0 then
		local bag, slot
		for _, bag in ipairs(containers) do
			for slot = 1, GetContainerNumSlots(bag) do
				local id = GetItemId(bag, slot)
				if id == itemId then
					-- No taint will occur while the bank is open
					UseContainerItem(bag, slot)
					return bag, slot
				end
			end
		end
	end
end

-- Update checked/unchecked status for all set buttons
local function UpdateSetButtons()
	local i, found
	for i = 1, MAX_EQUIPMENT_SETS_PER_PLAYER do
		local button = getglobal("GearSetButton"..i)
		if button then
			if button.name and button.name ~= "" then
				if not found and button.name == activeSet then
					found = 1
					checkFrame:SetParent(button)
					checkFrame:ClearAllPoints()
					checkFrame:SetAllPoints(button)
					checkFrame:Show()
				end
				button.hotkey:Show()
			else
				button.hotkey:Hide()
			end
		end
	end

	if not found then
		checkFrame:SetParent(PaperDollEquipmentManagerPane)
		checkFrame:Hide()
	end
end

-- Texture to icon index
local function GetIconIDFromTexture(iconTexture)
	if not strfind(iconTexture, "\\") then
		iconTexture = "Interface\\Icons\\"..iconTexture
	end

	RefreshEquipmentSetIconInfo()
	local numIcons = GetNumMacroIcons()
	local i
	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		if GetInventoryItemTexture("player", i) then
			numIcons = numIcons + 1
		end
	end

	for i = 1, numIcons do
		local texture, id = GetEquipmentSetIconInfo(i)
		if texture == iconTexture then
			return id
		end
	end
	return 1
end

-- Check whether a set is currently worn
local function CheckSetWorn(equipped, name)
	if not name then
		return
	end

	local ids = GetEquipmentSetItemIDs(name)
	local k, v
	for k, v in pairs(ids) do
		if v and v > 1 and equipped[k] ~= v then
			return
		end
	end
	return 1
end

-- Find the currently worn set and update the UI
local function UpdateWornSet()
	local equipped = {}
	local i, id, name
	for i = 0, 19 do
		equipped[i] = GetItemId(i) or 0
	end

	for i = 1, GetNumEquipmentSets() do
		local setName = GetEquipmentSetInfo(i)
		if CheckSetWorn(equipped, setName) then
			id, name = i, setName
			break
		end
	end

	if name ~= activeSet then
		CloseDropDownMenus()
		local prevName = activeSet
		activeId, activeSet = id, name
		UpdateSetButtons()
		if name then
			local show = db.showHelms[name]
			if type(show) == "number" then
				ShowHelm(show == 1)
			end

			show = db.showCloaks[name]
			if type(show) == "number" then
				ShowCloak(show == 1)
			end

			PrintMessage(format(L["wore set"], name))
		end

		-- Notify other addons, if any interested
		GearManagerEx_OnActiveSetChanged(name, prevName)
	end
end

-- The background message handler frame
local manager = CreateFrame("Frame")
manager:Hide()
manager:RegisterEvent("ADDON_LOADED")
manager:RegisterEvent("PLAYER_LOGIN")
manager:RegisterEvent("UPDATE_BINDINGS")
manager:RegisterEvent("BANKFRAME_OPENED")
manager:RegisterEvent("BANKFRAME_CLOSED")
manager:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
manager:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
manager:RegisterEvent("EQUIPMENT_SETS_CHANGED")

manager:SetScript("OnEvent", function(self, event, id)
	if event == "ADDON_LOADED" and id == "GearManagerEx" then
		--SetCVar("equipmentManager", 1) -- cvar no longer exists in CTM
		--PaperDollEquipmentManagerPane:Show()

		if type(GearManagerExDB) ~= "table" then
			GearManagerExDB = {}
		end

		db = GearManagerExDB

		if type(db.talentBind) ~= "table" then
			db.talentBind = {}
		end

		if type(db.showHelms) ~= "table" then
			db.showHelms = {}
		end

		if type(db.showCloaks) ~= "table" then
			db.showCloaks = {}
		end

		-- DEFAULT_CHAT_FRAME:AddMessage("|cffffff78GearManagerEx "..VERSION.."|r by Abin loaded.")

	elseif event == "UPDATE_BINDINGS" then
		local i
		for i = 1, MAX_EQUIPMENT_SETS_PER_PLAYER do
			local button = getglobal("GearSetButton"..i)
			if button and button.hotkey then
				local key = GetBindingKey("GEARMANAGEREX_WEARSET"..i)
				button.hotkey:SetText(GetBindingText(key, "KEY_", 1))
			end
		end
	elseif event == "BANKFRAME_OPENED" then
		bankOpened = 1
		CloseDropDownMenus()
	elseif event == "BANKFRAME_CLOSED" then
		bankOpened = nil
		CloseDropDownMenus()
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		self.needEquipSet = db.talentBind[id]
	elseif event == "PLAYER_LOGIN" then
		UpdateWornSet()
		self:Show()
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		self.needCheck = 1 -- Highly concurrent events, use post-processing to avoid performance drop...
	elseif event == "EQUIPMENT_SETS_CHANGED" then
		local name
		for name in pairs(db.showHelms) do
			if not GetEquipmentSetInfoByName(name) then
				db.showHelms[name] = nil
				db.showCloaks[name] = nil
			end
		end

		for name in pairs(db.showCloaks) do
			if not GetEquipmentSetInfoByName(name) then
				db.showCloaks[name] = nil
			end
		end

		UpdateWornSet()
	end
end)

manager:SetScript("OnUpdate", function(self, elapsed)
	self.updateElapsed = (self.updateElapsed or 0) + elapsed
	if self.updateElapsed > TOOLTIP_UPDATE_TIME then
		self.updateElapsed = 0

		if self.needEquipSet then
			EquipmentManager_EquipSet(self.needEquipSet)
			self.needEquipSet = nil
		elseif self.needCheck then
			self.needCheck = nil
			UpdateWornSet()
		end
	end
end)

-- The drop down setMenu for set buttons
local setMenu = CreateFrame("Button", "GearManagerExDropDownButtonSetMenu", GearManagerDialog, "UIDropDownMenuTemplate")
setMenu.point = "TOPLEFT"
setMenu.relativePoint = "BOTTOMLEFT"
setMenu.xOffset = -4
setMenu.yOffset = -4

local function OnMenuDepositSet()
	GearManagerEx_BankSet(rClickedSet, 1)
end

local function OnMenuWithdrawSet()
	GearManagerEx_BankSet(rClickedSet)
end

local function OnMenuBindSetToTalent1()
	GearManagerEx_BindSetToTalent(rClickedSet, 1)
end

local function OnMenuBindSetToTalent2()
	GearManagerEx_BindSetToTalent(rClickedSet, 2)
end

local function OnMenuShowHelm()
	GearManagerEx_ToggleShowHelm(rClickedSet)
end

local function OnMenuShowCloak()
	GearManagerEx_ToggleShowCloak(rClickedSet)
end

-- Our menu items for advanced set operations
UIDropDownMenu_Initialize(setMenu, function()
	UIDropDownMenu_AddButton({ text = rClickedSet, isTitle = 1, icon = rClickedSetIcon })
	UIDropDownMenu_AddButton({ text = L["put into bank"], disabled = not bankOpened, func = OnMenuDepositSet })
	UIDropDownMenu_AddButton({ text = L["take from bank"], disabled = not bankOpened, func = OnMenuWithdrawSet })
	UIDropDownMenu_AddButton({ text = SHOW_CLOAK, checked = db.showCloaks[rClickedSet] == 1, func = OnMenuShowCloak })
	UIDropDownMenu_AddButton({ text = SHOW_HELM, checked = db.showHelms[rClickedSet] == 1, func = OnMenuShowHelm })

	if GetNumSpecGroups() > 1 then
		UIDropDownMenu_AddButton({ text = L["bind to"]..TALENT_SPEC_PRIMARY, checked = db.talentBind[1] == rClickedSet, func = OnMenuBindSetToTalent1 })
		UIDropDownMenu_AddButton({ text = L["bind to"]..TALENT_SPEC_SECONDARY, checked = db.talentBind[2] == rClickedSet, func = OnMenuBindSetToTalent2 })
	end
	UIDropDownMenu_AddButton({ text = CLOSE })
end, "MENU")

--------------------------------------------------------------
-- Create Hotkey text for GearSetButton1-10
----------------------------------------------------------------
--local i
--for i = 1, MAX_EQUIPMENT_SETS_PER_PLAYER do
--	local button = getglobal("GearSetPopupButton"..i)
--	if button then
--		button.hotkey = button:CreateFontString(button:GetName().."HotKey", "OVERLAY", "NumberFontNormalSmallGray")
--		button.hotkey:SetJustifyH("RIGHT")
--		button.hotkey:SetPoint("TOPLEFT", 2, -2)
--		button.hotkey:SetPoint("TOPRIGHT", -2, -2)

		-- Hook "OnMouseDown" for every button to show the drop down menu
--		button:HookScript("OnMouseDown", function(self, button)
--			if prevDropDown ~= self then
--				CloseDropDownMenus()
--			end

--			if button == "LeftButton" and self.name and self.name ~= "" then
--				prevDropDown = self
--				setMenu.relativeTo = self
--				rClickedSet = self.name
--				rClickedSetIcon = self.icon:GetTexture()
--				ToggleDropDownMenu(nil, nil, setMenu)
--			end
--
--			GameTooltip:Hide()
--		end)
--	end
--end



hooksecurefunc("GearSetButton_OnClick", function(self, ...)
				prevDropDown = self
				setMenu.relativeTo = self
				rClickedSet = self.name
				rClickedSetIcon = self.icon:GetTexture()
				ToggleDropDownMenu(nil, nil, setMenu)
end)







-- Colorize set tooltip texts with item quality, instead of plain white
local function ReplaceTooltipTextColor(fs)
	if fs and fs:GetText() then
		local _, _, quality = GetItemInfo(fs:GetText())
		if quality then
			local r, g, b = GetItemQualityColor(quality)
			fs:SetTextColor(r, g, b)
		end
	end
end

if select(4, GetBuildInfo()) < 30300 then
	-- Hook GameTooltip if it's displaying an equipment set
	GameTooltip:HookScript("OnTooltipSetEquipmentSet", function(self)
		local i
		for i = 1, self:NumLines() do
			ReplaceTooltipTextColor(getglobal("GameTooltipTextLeft"..i))
			ReplaceTooltipTextColor(getglobal("GameTooltipTextRight"..i))
		end
	end)
end

-- Prompt the player that he can right-click a set for more operations
hooksecurefunc("GearSetButton_OnEnter", function(self)
	if self.name and self.name ~= "" and GameTooltipTextLeft1:GetText() == self.name then
		GameTooltip:AddLine(" ")
		--GameTooltip:AddDoubleLine(L["set hotkey"], self.hotkey:GetText(), nil, nil, nil, 1, 1, 1)
		GameTooltip:AddLine(L["tooltip prompt"], 0, 1, 0, 1)
		GameTooltip:Show()
	end
end)


-- Update the checked/unchecked stats for every set button
hooksecurefunc("PaperDollEquipmentManagerPane_Update", function()
	UpdateSetButtons()
end)

--------------------------------------------------------------
-- Quick strip
--------------------------------------------------------------

local DURASLOTS = { 16, 17, 18, 5, 7, 1, 3, 8, 10, 6, 9 } -- Inventory slots that possibly have durabilities
local lastOpt = 0 -- Last operated time

local function IsEquippableSlot(slot)
	return slot > 15 or not InCombatLockdown()
end

local function GetItemLocked()
	local bag, slot
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			if select(3, GetContainerItemInfo(bag, slot)) then
				return bag, slot
			end
		end
	end
end

-- Find available bag slots to put items into
local function GetAvailableBags()
	local bags = {}
	local i
	for i = 0, 4 do
		local slots, family = GetContainerNumFreeSlots(i)
		bags[i] = (family == 0) and slots or 0
	end
	return bags
end

local function GetFirstAvailableBag(bags)
	local i
	for i = 0, 4 do
		if bags[i] > 0 then
			return i
		end
	end
end

local function FindContainerItem(lnk, allowLocked)
	if type(lnk) == "string" then
		local bag, slot
		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				local _, _, locked, _, _, _, link = GetContainerItemInfo(bag, slot)
				if (allowLocked or not locked) and link == lnk then
					return bag, slot
				end
			end
		end
	end
end

local function VerifyStrippedDB()
	local hasContents
	if type(db.stripped) == "table" then
		local inv, lnk
		for inv, lnk in pairs(db.stripped) do
			if type(inv) == "number" and not GetInventoryItemLink("player", inv) and FindContainerItem(lnk, 1) then
				hasContents = 1
			else
				db.stripped[inv] = nil
			end
		end
	end

	if not hasContents then
		db.stripped = nil
	end

	return hasContents
end

-- Strip off all items those have durabilities
local function StripOff()
	local bags = GetAvailableBags()
	local count = 0
	local i
	for i = 1, #DURASLOTS do
		local inv = DURASLOTS[i]
		local lnk = GetInventoryItemLink("player", inv)
		if lnk and IsEquippableSlot(inv) and GetInventoryItemDurability(inv) then
			local bag = GetFirstAvailableBag(bags)
			if bag then
				bags[bag] = bags[bag] - 1
				PickupInventoryItem(inv)
				if CursorHasItem() then
					if bag == 0 then
						PutItemInBackpack()
					else
						PutItemInBag(19 + bag)
					end

					if not db.stripped then
						db.stripped = {}
					end

					db.stripped[inv] = lnk
					count = count + 1
				end
			else
				PrintMessage(ERR_INV_FULL, 1, 0, 0)
				return count
			end
		end
	end
	return count
end

-- Wear back whatever we stripped off through a previous call to StripOff()
local function WearBack()
	local count = 0
	local inv, lnk
	for inv, lnk in pairs(db.stripped) do
		if IsEquippableSlot(inv) then
			local bag, slot = FindContainerItem(lnk)
			if bag and slot then
				PickupContainerItem(bag, slot)
				if CursorHasItem() then
					EquipCursorItem(inv)
					count = count + 1
				end
			end
		end
	end
	db.stripped = nil
	return count
end

------------------------------------------------------------
-- Globals
------------------------------------------------------------

-- The purpose of this function is to give other addons a chance to get notified when the "active set" changes,
-- it is called when either a set is completely worn, or a previously worn set becomes no longer complete.
-- "currentName" - the current active set name, can be nil.
-- "previousName" - the previous active set name, can be nil.
-- For example, if "currentName" is nil and "previousName" is not, it indicates that some piece(s) of the set has
-- just been taken off.
-- Other addons may catch this event by secure-hooking "GearManagerEx_OnActiveSetChanged".
function GearManagerEx_OnActiveSetChanged(currentName, previousName)
	-- Dummy
end

-- Show/hide GearManagerDialog
function GearManagerEx_ToggleUI()
	if PaperDollEquipmentManagerPane:IsVisible() then
		PaperDollEquipmentManagerPane:Hide()
	else
		if not PaperDollFrame:IsVisible() then
			ToggleCharacter("PaperDollFrame")
		end
		PaperDollEquipmentManagerPane:Show()
	end
end

-- Get the current active set info: index, name, icon
function GearManagerEx_GetActiveSet()
	if activeId then
		local name, icon, internalId = GetEquipmentSetInfo(activeId)
		return activeId, name, icon, internalId
	end
end

-- Moves a set into bank, or take it out of bank
function GearManagerEx_BankSet(name, deposit)
	if bankOpened and type(name) == "string" then
		local setids = GetEquipmentSetItemIDs(name)
		if not setids then
			return
		end

		local containers = deposit and BAGS or BANKS
		local id
		for _, id in pairs(setids) do
			if id and id ~= 0 then
				UseContainerItemById(containers, id)
			end
		end
		return 1
	end
end

-- Bind a set to a talent group
function GearManagerEx_BindSetToTalent(name, talentId)
	if type(talentId) ~= "number" or (talentId ~= 1 and talentId ~= 2) then
		return
	end

	if type(name) == "string" and db.talentBind[talentId] ~= name then
		db.talentBind[talentId] = name
		if talentId == 1 then
			if db.talentBind[2] == name then
				db.talentBind[2] = nil
			end
		else
			if db.talentBind[1] == name then
				db.talentBind[1] = nil
			end
		end
	else
		db.talentBind[talentId] = nil
	end
end

-- Directly save a set
function GearManagerEx_ResaveSet(name)
	if type(name) == "string" then
		local icon = GetEquipmentSetInfoByName(name)
		if not icon then
			return
		end

		PrintMessage(format(L["set saved"], name))
		SaveEquipmentSet(name, GetIconIDFromTexture(icon))
		return 1
	end
end

local setToRename
local function OnPopupRenameSet(name)
	name = strtrim(name or "")
	if name == "" then
		return 1
	end

	if GetEquipmentSetInfoByName(name) then
		PrintMessage(format(L["name exists"], name), 1, 0, 0)
		return 1
	end

	db.showHelms[name] = db.showHelms[setToRename]
	db.showCloaks[name] = db.showCloaks[setToRename]

	PrintMessage(format(L["set renamed"], setToRename, name))
	RenameEquipmentSet(setToRename, name)
end

local renameData = {
	button1 = OKAY,
	button2 = CANCEL,
	hasEditBox = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1,

	OnAccept = function(self)
		return OnPopupRenameSet(self.editBox:GetText())
	end,

	EditBoxOnEnterPressed = function(self)
		if not OnPopupRenameSet(self:GetText()) then
			self:GetParent():Hide()
		end
	end,

	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,

	OnShow = function(self)
		self.editBox:SetText(setToRename or "")
		self.editBox:SetFocus()
		self.editBox:HighlightText()
	end,
}

StaticPopupDialogs["GEARMANAGEREX_RENAMESET"] = renameData

function GearManagerEx_RenameSet(name)
	if type(name) == "string" and GetEquipmentSetInfoByName(name) then
		renameData.text = format(L["label text"], name)
		setToRename = name
		StaticPopup_Show("GEARMANAGEREX_RENAMESET")
		return 1
	end
end

function GearManagerEx_DeleteSet(name)
	if type(name) ~= "string" or not GetEquipmentSetInfoByName(name) then
		return
	end

	local frame = StaticPopup_Show("CONFIRM_DELETE_EQUIPMENT_SET", name)
	frame.data = name
	return 1
end

-- Strip/wear
function GearManagerEx_QuickStrip()
	if UnitIsDeadOrGhost("player") or not HasFullControl() or GetItemLocked() then
		UIErrorsFrame:AddMessage(ERR_CLIENT_LOCKED_OUT, 1.0, 0.1, 0.1, 1.0)
		return
	end

	if GetTime() - lastOpt < 2 then
		PrintMessage(L["too fast"], 1, 0, 0)
		return
	end

	ClearCursor()
	if VerifyStrippedDB() then
		PrintMessage(format(L["wore back"], WearBack()))
	else
		PrintMessage(format(L["stripped off"], StripOff()))
	end
	lastOpt = GetTime()
end

-- Equip a set by index
function GearManagerEx_EquipSetByIndex(id)
	if type(id) == "number" then
		local name = GetEquipmentSetInfo(id)
		if name then
			EquipmentManager_EquipSet(name)
		end
	end
end

function GearManagerEx_IsHelmShownForSet(name)
	if type(name) == "string" and GetEquipmentSetInfoByName(name) then
		return db.showHelms[name] == 1
	end
end

function GearManagerEx_IsCloakShownForSet(name)
	if type(name) == "string" and GetEquipmentSetInfoByName(name) then
		return db.showCloaks[name] == 1
	end
end

-- Toggle show/hide helm of a set
function GearManagerEx_ToggleShowHelm(name)
	if type(name) ~= "string" or not GetEquipmentSetInfoByName(name) then
		return
	end

	local show = db.showHelms[name] == 1 and 0 or 1
	db.showHelms[name] = show

	if activeSet == name then
		ShowHelm(show == 1)
	end
end

-- Toggle show/hide cloak of a set
function GearManagerEx_ToggleShowCloak(name)
	if type(name) ~= "string" or not GetEquipmentSetInfoByName(name) then
		return
	end

	local show = db.showCloaks[name] == 1 and 0 or 1
	db.showCloaks[name] = show

	if activeSet == name then
		ShowCloak(show == 1)
	end
end

------------------------------------------------------------
-- Binding texts
------------------------------------------------------------

BINDING_HEADER_GEARMANAGEREX_TITLE = "GearManagerEx"
BINDING_NAME_GEARMANAGEREX_TOGGLEUI = L["open"]..EQUIPMENT_MANAGER
BINDING_NAME_GEARMANAGEREX_QUICKSTRIP = L["quick strip"]
BINDING_NAME_GEARMANAGEREX_WEARSET1 = L["wear set"].." 1"
BINDING_NAME_GEARMANAGEREX_WEARSET2 = L["wear set"].." 2"
BINDING_NAME_GEARMANAGEREX_WEARSET3 = L["wear set"].." 3"
BINDING_NAME_GEARMANAGEREX_WEARSET4 = L["wear set"].." 4"
BINDING_NAME_GEARMANAGEREX_WEARSET5 = L["wear set"].." 5"
BINDING_NAME_GEARMANAGEREX_WEARSET6 = L["wear set"].." 6"
BINDING_NAME_GEARMANAGEREX_WEARSET7 = L["wear set"].." 7"
BINDING_NAME_GEARMANAGEREX_WEARSET8 = L["wear set"].." 8"
BINDING_NAME_GEARMANAGEREX_WEARSET9 = L["wear set"].." 9"
BINDING_NAME_GEARMANAGEREX_WEARSET10 = L["wear set"].." 10"