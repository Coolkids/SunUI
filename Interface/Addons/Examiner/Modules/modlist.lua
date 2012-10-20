local ex = Examiner;
local cfg;

-- Module
local mod = ex:CreateModule("More","Module List");
mod.help = "Show more modules\nShift click for last active page";
mod:CreatePage(false,"Module List");
mod:HasButton(true);

-- Variables
local NUM_BUTTONS = 8;
local BUTTON_HEIGHT = (mod.page:GetHeight() - 47) / NUM_BUTTONS;
local UpdateShownItems;
local shownMods = {};
local buttons = {};

--------------------------------------------------------------------------------------------------------
--                                           Module Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- OnInitialize
function mod:OnInitialize()
	cfg = ex.cfg;
	self:BuildModuleList();
end

-- OnInspect
function mod:OnInspect(unit)
	self:BuildModuleList();
end

-- OnInspectReady
function mod:OnInspectReady(unit)
	self:BuildModuleList();
end

-- OnCacheLoaded
function mod:OnCacheLoaded(entry,unit)
	self:BuildModuleList();
end

-- OnClearInspect
function mod:OnClearInspect()
	self:BuildModuleList();
end

-- OnPageChanged
function mod:OnPageChanged(module,shown)
	if (self == module) then
		self:BuildModuleList();
	end
end

-- OnButtonClick
function mod:OnButtonClick(frame,button)
	-- Left
	if (button == "LeftButton") then
		if (IsShiftKeyDown()) then
			ex:ShowModulePage(cfg.lastActivatedModule);
		end
	-- Right
	elseif (button == "RightButton") then
		local module = ex.modules[cfg.activePage];
		if (module) and (not IsModifierKeyDown()) then
			if (module.MenuInit and module.MenuSelect) then
				AzDropDown.ToggleMenu(frame,module.MenuInit,module.MenuSelect,"TOPLEFT","BOTTOMLEFT");
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- Button: OnClick
local function Button_OnClick(self,button)
	local id = self.id;
	local module = ex.modules[id];
	if (module.hasData) then
		PlaySound("igMainMenuOptionCheckBoxOn");
		cfg.lastActivatedModule = id;
		-- Call Module OnButtonClick
		if (module.OnButtonClick) then
			module:OnButtonClick(self,button);
		end
		-- Unmodified Left Clicks
		if (not IsModifierKeyDown()) then
			if (button == "LeftButton") and (module.page) then
				ex:ShowModulePage(id);
				AzDropDown.HideMenu();
			elseif (module.MenuInit and module.MenuSelect) then
				AzDropDown.ToggleMenu(self,module.MenuInit,module.MenuSelect,"TOPLEFT","BOTTOMLEFT");
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                                Code                                                --
--------------------------------------------------------------------------------------------------------

-- Build Module List
function mod:BuildModuleList()
	wipe(shownMods);
	for index, module in ipairs(ex.modules) do
		if (module.page) and (not module.button) then
			shownMods[#shownMods + 1] = module;
		end
	end
	UpdateShownItems();
end

-- Update
function UpdateShownItems()
	FauxScrollFrame_Update(mod.scroll,#shownMods,#buttons,BUTTON_HEIGHT);
	local index = mod.scroll.offset;
	-- loopy
	for i = 1, NUM_BUTTONS do
		index = (index + 1);
		local btn = buttons[i];
		local mod = shownMods[index];
		if (mod) then
			btn.name:SetText(mod.title or mod.token);
			btn.id = mod.index;
			
			if (mod.hasData) then
				btn.name:SetTextColor(0.5,1,0.5);
			else
				btn.name:SetTextColor(1,0.5,0.5);
			end
			
			btn.icon:SetTexture("Interface\\Icons\\Ability_Druid_ImprovedTreeForm");
			btn:Show();
		else
			btn:Hide();
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Creation                                          --
--------------------------------------------------------------------------------------------------------

-- Buttons
for i = 1, NUM_BUTTONS do
	local btn = CreateFrame("Button",nil,mod.page);
	buttons[i] = btn;

	btn:SetHeight(BUTTON_HEIGHT);
	btn:RegisterForClicks("LeftButtonDown","RightButtonDown");
	btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	btn:Hide();

	if (i == 1) then
		btn:SetPoint("TOPLEFT",8,-36.5);
		btn:SetPoint("TOPRIGHT",-28,-36.5);
	else
		btn:SetPoint("TOPLEFT",buttons[i - 1],"BOTTOMLEFT");
		btn:SetPoint("TOPRIGHT",buttons[i - 1],"BOTTOMRIGHT");
	end

	btn:SetScript("OnClick",Button_OnClick);
--	btn:SetScript("OnEnter",nil);
--	btn:SetScript("OnLeave",ex.HideGTT);

	btn.icon = btn:CreateTexture(nil,"ARTWORK");
	btn.icon:SetWidth(BUTTON_HEIGHT - 2);
	btn.icon:SetHeight(BUTTON_HEIGHT - 2);
	btn.icon:SetPoint("LEFT",2,0);
	btn.icon:SetTexCoord(0.07,0.93,0.07,0.93);
	btn.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");

	btn.val = btn:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	btn.val:SetPoint("RIGHT",-4,0);
	btn.val:SetTextColor(1,1,0);

	btn.name = btn:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	btn.name:SetPoint("LEFT",btn.icon,"RIGHT",3,0);
	btn.name:SetPoint("RIGHT",btn.val,"LEFT",-8,0);
	btn.name:SetJustifyH("LEFT");
end

-- Scroll
mod.scroll = CreateFrame("ScrollFrame","Examiner"..mod.token.."Scroll",mod.page,"FauxScrollFrameTemplate");
mod.scroll:SetPoint("TOPLEFT",buttons[1]);
mod.scroll:SetPoint("BOTTOMRIGHT",buttons[NUM_BUTTONS],-6,-1);
mod.scroll:SetScript("OnVerticalScroll",function(self,offset) FauxScrollFrame_OnVerticalScroll(self,offset,BUTTON_HEIGHT,UpdateShownItems) end);