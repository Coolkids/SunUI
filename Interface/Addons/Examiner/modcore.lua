local ex = Examiner;
local gtt = GameTooltip;

local ModuleCore = {};

ModuleCore.__index = ModuleCore;
ex.ModuleCore = ModuleCore;

-- Tables
ex.modules = {};
ex.buttons = {};

--------------------------------------------------------------------------------------------------------
--                                          Helper Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Returns the Module with given "token"
function ex:GetModuleFromToken(token)
	for index, mod in ipairs(ex.modules) do
		if (mod.token == token) then
			return mod, index;
		end
	end
end

-- Creates a new Module
function ex:CreateModule(token,title)
	local mod = setmetatable({ token = token, title = title, hasData = true, index = #ex.modules + 1 },ModuleCore);
	ex.modules[#ex.modules + 1] = mod;
	return mod;
end

-- Send Module Event
function ex:SendModuleEvent(event,...)
	for index, mod in ipairs(self.modules) do
		if (mod[event]) then
			mod[event](mod,...);
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Detail Object                                           --
--------------------------------------------------------------------------------------------------------

local DetailObject = {};
DetailObject.__index = DetailObject;

function ex:CreateDetailObject()
	return setmetatable({ entries = LibTableRecycler:New() },DetailObject);
end

function DetailObject:Update()
	ex:SendModuleEvent("OnDetailsUpdate");
end

function DetailObject:Add(label,value,tip)
	local tbl = self.entries:Fetch();
	tbl.label = label; tbl.value = value; tbl.tip = tip;
end

function DetailObject:Clear()
	self.entries:Recycle();
end

--------------------------------------------------------------------------------------------------------
--                                          Button Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Buttons: OnClick
local function Buttons_OnClick(self,button)
	local id = self.id;
	local mod = ex.modules[id];
	-- Call Module OnButtonClick
	if (mod.OnButtonClick) then
		mod:OnButtonClick(self,button);
	end
	-- Unmodified Left Clicks
	if (not IsModifierKeyDown()) then
		if (button == "LeftButton") and (mod.page) then
			ex:ShowModulePage(id);
			AzDropDown.HideMenu();
		elseif (mod.MenuInit and mod.MenuSelect) then
			AzDropDown.ToggleMenu(self,mod.MenuInit,mod.MenuSelect,"TOPLEFT","BOTTOMLEFT");
		end
	end
end

-- Buttons: OnEnter
local function Buttons_OnEnter(self,motion)
	local mod = ex.modules[self.id];
	gtt:SetOwner(self,"ANCHOR_NONE");
	gtt:SetPoint("BOTTOMLEFT",self,"TOPLEFT");
	gtt:AddLine(mod.title);
	gtt:AddLine(mod.help,1,1,1);
	gtt:Show();
end

-- Create Button
local function CreateModuleButton(label,tipHeader,tipText)
	local btn = CreateFrame("Button",nil,ex,"UIPanelButtonGrayTemplate");
	btn:SetWidth(75);
	btn:SetHeight(21);
	btn:SetFrameLevel(btn:GetFrameLevel() + 2);
	btn:RegisterForClicks("AnyUp");
	btn:SetScript("OnClick",Buttons_OnClick);
	btn:SetScript("OnEnter",Buttons_OnEnter);
	btn:SetScript("OnLeave",ex.HideGTT);

	ex.buttons[#ex.buttons + 1] = btn;
	return btn;
end

--------------------------------------------------------------------------------------------------------
--                                            Meta Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Is the module the current shown page?
function ModuleCore:IsShown()
	return (ex.cfg.activePage == self.index);
end

-- Returns if module is allowed to cache
function ModuleCore:CanCache()
	return self.canCache and ex.cfg.caching.Core and ex.cfg.caching[self.token];
end

-- Tells if this module has data available for Examiner to show
function ModuleCore:HasData(value)
	self.hasData = (value and true or nil);
	if (value) then
		if (self.button) then
			self.button:Enable();
		end
	else
		if (self.page) then
			self.page:Hide();
		end
		if (self.button) then
			self.button:Disable();
		end
	end
end

-- Has Button
function ModuleCore:HasButton(value)
	self.hasButton = value;
	-- Position Module Buttons
	local numBtn = 0;
	for index, mod in ipairs(ex.modules) do
		if (mod.hasButton) then
			numBtn = (numBtn + 1);
			local btn = ex.buttons[numBtn] or CreateModuleButton();
			if (numBtn > 1) then
				btn:SetPoint("LEFT",ex.buttons[numBtn - 1],"RIGHT",1,0);
			else
				btn:SetPoint("BOTTOMLEFT",24,13);
			end
			mod.hasData = nil;
			btn:Enable();
			btn.id = index;
			btn:SetText(mod.token);
			mod.button = btn;
		end
	end
	-- Resize Buttons
	local btnWidth = ((ex.model:GetWidth() - 4) / numBtn - 1);
	for index, btn in ipairs(ex.buttons) do
		if (index <= numBtn) then
			btn:SetWidth(btnWidth);
			btn:Show();
		else
			btn:Hide();
		end
	end
end

-- Creates a Default Module Page
local backdrop = { bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } };
function ModuleCore:CreatePage(full,header)
	local page = CreateFrame("Frame",nil,ex.model);
	page:SetWidth(full and 320 or 235);
	page:SetHeight(full and 330 or 288);
	page:SetPoint("TOP");
	page:SetBackdrop(backdrop);
	page:SetBackdropColor(0.06,0.132,0.21,0.7);
	page:SetBackdropBorderColor(0.7,0.7,0.8,1);
	page:Hide();
	if (header) then
		page.header = page:CreateFontString(nil,"ARTWORK");
		page.header:SetFont(GameFontNormal:GetFont(),16,"THICKOUTLINE");
		page.header:SetTextColor(0.5,0.75,1);
		page.header:SetPoint("TOP",0,-14);
		page.header:SetText(header);
	end
	self.page = page;
	self.showItems = (not full or nil);
	return page;
end