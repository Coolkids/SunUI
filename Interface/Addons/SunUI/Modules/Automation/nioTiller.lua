local nioTillersFrame = CreateFrame("Frame")
local nioTillers = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("nioTillers", "AceHook-3.0")
local seedIDs = {
	79102, --绿色卷心菜
	80590, --胡萝卜
	80591, --青葱
	80592, --南瓜
	80593, --红花葱
	80594, --粉红菜头
	80595, --白菜头
	89328, --翠玉瓜
	89326, --巫莓
	89329, --条纹甜瓜
	85267, --秋绽树
	85268, --春绽树
	85269, --冬绽树
	85216, --神秘种子
	85217, --魔菜
	89202, --猛禽菜
	85215, --蛇根草
	89197, --风切仙人掌
	89233, --歌铃花
}
local IsEnabled = false
local auras ={}
local Ranch

-----------------------------
-- Configuration
-----------------------------
local config = {
	Position = {position = "CENTER", xoff = 0, yoff = 0,},
	Mainbutton = {size = 40, fontsize = 20,},
	Normalbutton = {size = 30, fontsize = 14,},
	BorderColor = {0.14,0.43,0.65,1},
}
local default_options = {
	Position = {pos = "CENTER", position = "CENTER", xoff = 0, yoff = 0,},
	Orientation = 1,
	ShowOnlyOwned = true,
	Shown = true,
	ShowTooltip = true,
	LastSeed = 46772,
}

-----------------------------
-- Localization
-----------------------------
local locale = GetLocale()
if locale == "enUS" then Ranch = "Sunsong Ranch"
elseif locale == "enGB" then Ranch = "Sunsong Ranch"
elseif locale == "deDE" then Ranch = "Gehöft Sonnensang"
elseif locale == "itIT" then Ranch = "Tenuta Cantasole"
elseif locale == "esMX" then Ranch = "Rancho Cantosol"
elseif locale == "esES" then Ranch = "Rancho Cantosol"
elseif locale == "frFR" then Ranch = "Ferme Chant du Soleil"
elseif locale == "koKR" then Ranch = "태양노래 농장"
elseif locale == "ptBR" then Ranch = "Fazenda Sol Cantante"
elseif locale == "ruRU" then Ranch = "Ферма Солнечной Песни"
elseif locale == "zhCN" then Ranch = "日歌农场"
elseif locale == "zhTW" then Ranch = "日歌農莊"
end

 -----------------------------
-- Options
-----------------------------
local function MainbuttonOnClick(self, button)
	if button == "LeftButton" then
		if nioTillerDBC.Shown then 
			nioTillerDBC.Shown = false
			for i = 2, #seedIDs+1 do nioTillers.btn[i]:Hide() end
		else
			nioTillerDBC.Shown = true
			nioTillers:ShowButtons()	
		end
	elseif button == "RightButton" and not IsModifierKeyDown() then
		if nioTillerDBC.ShowOnlyOwned then nioTillerDBC.ShowOnlyOwned = false					
		else nioTillerDBC.ShowOnlyOwned = true end
		nioTillers:HideButtons()
		nioTillers:ShowButtons()
		nioTillers:RefreshItemCount()
	elseif button == "RightButton" and IsShiftKeyDown() then
		if nioTillerDBC.ShowTooltip then nioTillerDBC.ShowTooltip = false					
		else nioTillerDBC.ShowTooltip = true end
	elseif button == "RightButton" and IsControlKeyDown() then
		if nioTillerDBC.Orientation < 4 then nioTillerDBC.Orientation = nioTillerDBC.Orientation + 1					
		else nioTillerDBC.Orientation = 1 end
		nioTillers:SetOrientation()
	end
end

-----------------------------
-- Frame Creation
-----------------------------
-- Secure Buttons
function nioTillers:CreateSAButtons()
	nioTillers.SAButtons = {}
	local itemids = {"0", "89815", "89880", "80513", "79104"} -- seeds, plow, shovel, aura1, aura2
	local unit = {"0", "player", "mouseover", "mouseover", "mouseover"}
	for i = 1,5 do
		local btn = CreateFrame("Button", "TillerButton"..i, nil, "SecureActionButtonTemplate")
		btn:EnableMouse(true)
		btn:RegisterForClicks("AnyUp")
		if i > 1 then
			--print(12323)
			btn:SetAttribute("type", "item")
			btn:SetAttribute("item", "item:"..itemids[i])
			btn:SetAttribute("unit", unit[i])				
		end
		nioTillers.SAButtons[i] = btn
	end
end

--tooltips
local function OnEnter(self)
	itemName = GetItemInfo(self.id)
	GameTooltip:SetOwner(self)
	GameTooltip:SetText(itemName..": "..GetItemCount(self.id))
	GameTooltip:Show()
end
local function OnEnterMain(self)
	if not nioTillerDBC.ShowTooltip then return end
	GameTooltip:SetOwner(self)
	if GetLocale() == "zhTW" then
		GameTooltip:SetText("使用方法:")
		GameTooltip:AddLine("|cff69ccf0點擊小圖標|cffffd200選擇種子")
		GameTooltip:AddLine("|cff69ccf0雙擊右鍵|cffffd200 對著泥土(種地)對植物(除蟲/灑水)")
		GameTooltip:AddLine("|cff69ccf0Alt+右鍵|cffffd200 使用犁(崇拜後出現的)")
		GameTooltip:AddLine("|cff69ccf0Ctrl+右鍵|cffffd200 使用鏟子(移除植物 需要背包中有)")
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cff0090ff點擊這個按鈕:|r")
		GameTooltip:AddLine("|cff69ccf0左鍵|cffffd200顯示/隱藏種子欄")
		GameTooltip:AddLine("|cff69ccf0右鍵|cffffd200 顯示所有種子/顯示背包中的種子")
		GameTooltip:AddLine("|cff69ccf0Alt+右鍵|cffffd200 移動這個按鈕")
		GameTooltip:AddLine("|cff69ccf0Ctrl+右鍵|cffffd200 旋轉種子欄")
		GameTooltip:AddLine("|cff69ccf0Shift+右鍵|cffffd200 to 顯示/隱藏這個提示")
	elseif GetLocale() == "zhCN" then
		GameTooltip:SetText("使用方法:")
		GameTooltip:AddLine("|cff69ccf0点击小图标|cffffd200选择种子")
		GameTooltip:AddLine("|cff69ccf0双击右键|cffffd200 对着泥土(种地)对植物(除虫/洒水)")
		GameTooltip:AddLine("|cff69ccf0Alt+右键|cffffd200 使用犁(崇拜后出现的)")
		GameTooltip:AddLine("|cff69ccf0Ctrl+右键|cffffd200 使用铲子(移除植物 需要背包中有)")
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cff0090ff点击这个按钮:|r")
		GameTooltip:AddLine("|cff69ccf0左键|cffffd200显示/隐藏种子栏")
		GameTooltip:AddLine("|cff69ccf0右键|cffffd200 显示所有种子/显示背包中的种子")
		GameTooltip:AddLine("|cff69ccf0Alt+右键|cffffd200 移动这个按钮")
		GameTooltip:AddLine("|cff69ccf0Ctrl+右键|cffffd200 旋转种子栏")
		GameTooltip:AddLine("|cff69ccf0Shift+右键|cffffd200 to 显示/隐藏这个提示")
	else
		GameTooltip:SetText("On your ranch:")
		GameTooltip:AddLine("|cff69ccf0Click|cffffd200 a seed on the bar to select it")
		GameTooltip:AddLine("|cff69ccf0Double-Right-Click|cffffd200 to seed or use the appropiate tools")
		GameTooltip:AddLine("|cff69ccf0Alt-Right-Click|cffffd200 to use your plow")
		GameTooltip:AddLine("|cff69ccf0Ctrl-Right-Click|cffffd200 to use your shovel")
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cff0090ffClicking this button:|r")
		GameTooltip:AddLine("|cff69ccf0Left-Click|cffffd200 to show/hide the seed bar")
		GameTooltip:AddLine("|cff69ccf0Right-Click|cffffd200 to show all/owned seeds on the bar")
		GameTooltip:AddLine("|cff69ccf0Alt-Right-Click|cffffd200 to move")
		GameTooltip:AddLine("|cff69ccf0Ctrl-Right-Click|cffffd200 to rotate the bar")
		GameTooltip:AddLine("|cff69ccf0Shift-Right-Click|cffffd200 to show/hide this tooltip")
	end
	
	GameTooltip:Show()
end
local function OnLeave(self)
	GameTooltip:Hide()
end

-- button style
local function StyleButton(btn, size, fontsize)
	btn:SetSize(size-2, size-2)
	
	btn.icon = btn:CreateTexture(nil,"BACKGROUND ",nil)
	btn.icon:SetAllPoints()
	--btn.icon:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -2)
	--btn.icon:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, 2)
	btn.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	
	btn.count = btn:CreateFontString(nil, "OVERLAY")
	btn.count:SetPoint("CENTER", 0,0)
	btn.count:SetTextColor(1, 1, 1)
	btn.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
	btn:CreateShadow()
	--btn:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"})
	--btn:SetBackdropColor(config.BorderColor[1],config.BorderColor[2],config.BorderColor[3],config.BorderColor[4])

	return btn
end

-- set orientation
function nioTillers:SetOrientation()
	for i = 2, #seedIDs+1 do
		self.btn[i]:ClearAllPoints()
		if nioTillerDBC.Orientation == 1 then self.btn[i]:SetPoint("LEFT", self.btn[1], "RIGHT", (i-2)*(config.Normalbutton.size + 2) +4, 0)
		elseif nioTillerDBC.Orientation == 2 then self.btn[i]:SetPoint("TOP", self.btn[1], "BOTTOM", 0, -(i-2)*(config.Normalbutton.size + 2) -2)
		elseif nioTillerDBC.Orientation == 3 then self.btn[i]:SetPoint("RIGHT", self.btn[1], "LEFT", -(i-2)*(config.Normalbutton.size + 2) -4, 0)
		elseif nioTillerDBC.Orientation == 4 then self.btn[i]:SetPoint("BOTTOM", self.btn[1], "TOP", 0, (i-2)*(config.Normalbutton.size + 2) +2) end
	end
end

--make buttons
function nioTillers:MakeButtons()
	self.btn = {}
	local holder = CreateFrame("Button", "nioTillersMainButton", UIParent)
	holder = StyleButton(holder, config.Mainbutton.size, config.Mainbutton.fontsize)
	holder:SetMovable(true)
	holder:SetPoint(nioTillerDBC.Position.pos, UIParent, nioTillerDBC.Position.position, nioTillerDBC.Position.xoff, nioTillerDBC.Position.yoff) 
	holder:EnableMouse(true)
	holder:RegisterForClicks("AnyUp");
	holder:SetScript("OnMouseDown", function(self, button)
		if IsAltKeyDown() and button == "RightButton" then 
			self:StartMoving() 
			self:SetUserPlaced(true)
		end
	end)
	holder:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then self:StopMovingOrSizing() end
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		nioTillerDBC.Position.pos, nioTillerDBC.Position.position, nioTillerDBC.Position.xoff, nioTillerDBC.Position.yoff =  AnchorF,AnchorT, X, Y
	end)
	holder:SetScript("OnEnter", OnEnterMain)
	holder:SetScript("OnLeave", OnLeave)
	holder:SetScript("OnClick", MainbuttonOnClick)
	holder:Hide()
	self.btn[1] = holder
	--print(#seedIDs)
	for i = 2,#seedIDs+1 do
		local btn = CreateFrame("Button", "nioTillerBtn"..i, holder)
		btn = StyleButton(btn, config.Normalbutton.size, config.Normalbutton.fontsize)
		btn.holder = holder
		btn.sabutton = self.SAButtons[1]
		btn:SetScript("OnEnter", OnEnter)
		btn:SetScript("OnLeave", OnLeave)

		btn:Hide()
		self.btn[i] = btn		
	end
	
	nioTillers:SetOrientation()
end

-----------------------------
-- Fetch double clicks
-----------------------------
-- look for double clicks
function nioTillers:CheckForDoubleClick()
	if self.lastClickTime then
		local pressTime = GetTime()
		local doubleTime = pressTime - self.lastClickTime
		if ( (doubleTime < 0.4) and (doubleTime > 0.05) ) then
			self.lastClickTime = nil
			return true
		end
	end
	self.lastClickTime = GetTime()
	return false
end

-- Thanks to the Cosmos team for figuring this one out
local function WF_OnMouseDown(...)
	-- Only steal 'right clicks' (self is arg #1!)
	local button = select(2, ...)
	if button == "RightButton" and not InCombatLockdown() and nioTillers:CheckForDoubleClick() then	
		local guid = UnitGUID("target")
		local ID = 0
		if guid then ID = tonumber(guid:sub(6, 12), 16) end
		--print(323)
		--print(guid, ID)
		--local name = UnitName("target")
		--14992129
		if ID == 14992129 or ID == 14992128 and GetItemCount(nioTillers.SAButtons[1].itemid) > 0 then
		--if name == "開墾過的沃土" and GetItemCount(nioTillers.SAButtons[1].itemid) > 0 then
			--print(23)
			if IsMouselooking() then MouselookStop() end
			nioTillersFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
			nioTillersFrame:RegisterEvent("UI_ERROR_MESSAGE")
			SetOverrideBindingClick(nioTillers.SAButtons[1], false, "BUTTON2", "TillerButton1")
		elseif UnitAura("target", auras[1]) and GetItemCount(80513) > 0 then
			if IsMouselooking() then MouselookStop() end
			nioTillersFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
			nioTillersFrame:RegisterEvent("UI_ERROR_MESSAGE")
			SetOverrideBindingClick(nioTillers.SAButtons[4], false, "BUTTON2", "TillerButton4")		
		elseif UnitAura("target", auras[2]) and GetItemCount(79104) > 0  then
			if IsMouselooking() then MouselookStop() end
			nioTillersFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
			nioTillersFrame:RegisterEvent("UI_ERROR_MESSAGE")
			SetOverrideBindingClick(nioTillers.SAButtons[5], false, "BUTTON2", "TillerButton5")		
		end
	end
end

-----------------------------
-- Button handling
-----------------------------
local function SetMainButton(id, sabtn, holder, iconname)
	if not sabtn then return end
	sabtn:SetAttribute("type", "item")
	sabtn:SetAttribute("item", "item:"..id)
	sabtn:SetAttribute("unit", "target")
	sabtn:SetAttribute("spell", nil)
	sabtn:SetAttribute("action", nil)
	sabtn.itemid = id
	holder.icon:SetTexture(iconname)
	holder.count:SetText(GetItemCount(id))
	holder.id = id
	nioTillerDBC.LastSeed = id
end

function nioTillers:ShowButtons()	
	btncount = 2
	for i,v in ipairs(seedIDs) do		
		local count = GetItemCount(v)
		if (count > 0 and nioTillerDBC.ShowOnlyOwned) or not nioTillerDBC.ShowOnlyOwned then
			local btn = self.btn[btncount]
			--print(btn, v, btncount)
			btn.iconname = GetItemIcon(v)
			btn.icon:SetTexture(btn.iconname)
			btn.count:SetText(count)
			btn.id = v
			btn:EnableMouse(true)
			btn:RegisterForClicks("AnyUp")
			btn:SetScript("OnClick", function (self, button)
				SetMainButton(self.id, self.sabutton, self.holder, self.iconname)
			end);
			btn:Show()
			btncount = btncount+1
		end
	end
end

function nioTillers:HideButtons()
	for i = 2, #seedIDs+1 do
		local btn = self.btn[i]
		btn.icon:SetTexture(nil)
		btn.count:SetText(nil)
		btn.id = nil
	
		btn:EnableMouse(false)
		btn:SetScript("OnClick", nil)
		btn:Hide()
	end
end

function nioTillers:RefreshItemCount()
	for i = 1, #seedIDs+1 do
		local btn = self.btn[i]
		local count = GetItemCount(btn.id)
		if count == 0 then btn.icon:SetDesaturated(1)
		else btn.icon:SetDesaturated(nil) end
		btn.count:SetText(count)
	end
end
 
 -----------------------------
-- Enable/disable
-----------------------------
function nioTillers:Enable()
	if IsEnabled then return end
	IsEnabled = true
	self.btn[1]:Show()
	self:ShowButtons()
	self:RefreshItemCount()
	if not self:IsHooked(WorldFrame, "OnMouseDown") then
		self:HookScript(WorldFrame, "OnMouseDown", WF_OnMouseDown)
	end

	SetOverrideBindingClick(self.SAButtons[2], false, "ALT-BUTTON2", "TillerButton2")
	SetOverrideBindingClick(self.SAButtons[3], false, "CTRL-BUTTON2", "TillerButton3")
	
	SetMainButton(nioTillerDBC.LastSeed, nioTillers.SAButtons[1], nioTillers.btn[1], GetItemIcon(nioTillerDBC.LastSeed))
	
	nioTillersFrame:RegisterEvent("BAG_UPDATE")
end
function nioTillers:Disable()
	if not IsEnabled then return end
	IsEnabled = false
	self:HideButtons()
	self.btn[1]:Hide()
	
	ClearOverrideBindings(self.SAButtons[1])
	ClearOverrideBindings(self.SAButtons[2])
	ClearOverrideBindings(self.SAButtons[3])
	ClearOverrideBindings(self.SAButtons[4])
	ClearOverrideBindings(self.SAButtons[5])
	
	if self:IsHooked(WorldFrame, "OnMouseDown") then
		self:Unhook(WorldFrame, "OnMouseDown")
	end
	
	nioTillersFrame:UnregisterEvent("BAG_UPDATE")
end

-----------------------------
-- Frame registering and initialization
-----------------------------
local function nioTillersEvents(self, event)
	if event == "ZONE_CHANGED" then
		if GetSubZoneText() == Ranch then nioTillers:Enable()
		else nioTillers:Disable() end
	elseif event == "BAG_UPDATE" then
		nioTillers:RefreshItemCount()
	elseif event == "UNIT_SPELLCAST_SENT" or event == "UI_ERROR_MESSAGE" then
		ClearOverrideBindings(nioTillers.SAButtons[1])
		ClearOverrideBindings(nioTillers.SAButtons[4])
		ClearOverrideBindings(nioTillers.SAButtons[5])
		nioTillersFrame:UnregisterEvent("UNIT_SPELLCAST_SENT")
		nioTillersFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	elseif event == "ADDON_LOADED" then
		--if not nioTillerDBC then nioTillerDBC = {} end
		--if nioTillerDBC == {} then nioTillerDBC = default_options end
		nioTillerDBC = nioTillerDBC or default_options	
		if nioTillerDBC["Position"] == nil then nioTillerDBC = default_options end
		nioTillers:MakeButtons()
		nioTillersFrame:UnregisterEvent("ADDON_LOADED")
	elseif event == "PLAYER_ENTERING_WORLD" then
		auras =  {GetSpellInfo(115483), GetSpellInfo(115824)}
		if GetSubZoneText() == Ranch then nioTillers:Enable() end
		nioTillersFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end
function nioTillers:OnInitialize()
	nioTillersFrame:RegisterEvent("ADDON_LOADED")
	nioTillersFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	nioTillersFrame:RegisterEvent("ZONE_CHANGED")
end

function nioTillers:OnEnable()
	nioTillersFrame:SetScript("OnEvent", nioTillersEvents)
	nioTillers:CreateSAButtons()
end