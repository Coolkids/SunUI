local F = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("sFish", "AceEvent-3.0", "AceHook-3.0")
local knowFish = false
local spell = GetSpellInfo(131474)
local isPole = false
local holder = CreateFrame("Frame", nil, UIParent);
-- Lure library
local fishlure = {
	-- {	["id"] = 34832,
		-- ["n"] = "Captain Rumsey's Lager",			     -- 10 for 3 mins
		-- ["b"] = 10,
		-- ["s"] = 1,
		-- ["d"] = 3,
		-- ["u"] = 1,
	-- },
	{	["id"] = 6529,
		["n"] = "Shiny Bauble",							  -- 25 for 10 mins
		["b"] = 25,
		["s"] = 1,
		["d"] = 10,
	},
	{	["id"] = 6811,
		["n"] = "Aquadynamic Fish Lens",				  -- 50 for 10 mins
		["b"] = 50,
		["s"] = 50,
		["d"] = 10,
	},
	{	["id"] = 6530,
		["n"] = "Nightcrawlers",						  -- 50 for 10 mins
		["b"] = 50,
		["s"] = 50,
		["d"] = 10,
	},
	{	["id"] = 33820,
		["n"] = "Weather-Beaten Fishing Hat",		  -- 75 for 10 minutes
		["b"] = 75,
		["s"] = 1,
		["d"] = 10,
		["w"] = true,
	},
	{	["id"] = 88710,
		["n"] = "Weather-Beaten Fishing Hat",		  -- 150 for 10 minutes
		["b"] = 150,
		["s"] = 1,
		["d"] = 10,
		["w"] = true,
	},
	{	["id"] = 7307,
		["n"] = "Flesh Eating Worm",					  -- 75 for 10 mins
		["b"] = 75,
		["s"] = 100,
		["d"] = 10,
	},
	{	["id"] = 6532,
		["n"] = "Bright Baubles",						  -- 75 for 10 mins
		["b"] = 75,
		["s"] = 100,
		["d"] = 10,
	},
	{	["id"] = 34861,
		["n"] = "Sharpened Fish Hook",				  -- 100 for 10 minutes
		["b"] = 100,
		["s"] = 100,
		["d"] = 10,
	},
	{	["id"] = 6533,
		["n"] = "Aquadynamic Fish Attractor",		  -- 100 for 10 minutes
		["b"] = 100,
		["s"] = 100,
		["d"] = 10,
	},
	{	["id"] = 62673,
		["n"] = "Feathered Lure",					  -- 100 for 10 minutes
		["b"] = 100,
		["s"] = 100,
		["d"] = 10,
	},
	{	["id"] = 46006,
		["n"] = "Glow Worm",							  -- 100 for 60 minutes
		["b"] = 100,
		["s"] = 100,
		["d"] = 60,
	},
	{	["id"] = 68049,
		["n"] = "Heat-Treated Spinning Lure",		  -- 150 for 5 minutes
		["b"] = 150,
		["s"] = 250,
		["d"] = 5,
	},
	{	["id"] = 67404,
		["n"] = "Glass Fishing Bobber",				  -- ???
		["b"] = 15,
		["s"] = 1,
		["d"] = 10,
	},
}
table.sort(fishlure,
	function(a,b)
		if ( a.b == b.b ) then
			return a.d < b.d;
		else
			return a.b < b.b;
		end
	end
)
local function ResetOverride()
	btn.holder:Hide();
	ClearOverrideBindings(btn);
end
local function GetCurrentSkill()
	local fishing = select(4, GetProfessions())
	if (fishing) then
		local rank = select(3, GetProfessionInfo(fishing))
		return rank
	end
	return 0, 0, 0
end
local useinventory = {};
local lureinventory = {};
local function UpdateLureInventory()
	local rawskill = GetCurrentSkill();
	wipe(useinventory)
	wipe(lureinventory)
	--lureinventory = {};
	for _,lure in ipairs(fishlure) do
		local id = lure.id;
		local count = GetItemCount(id);
		if ( count > 0 ) then
			if ( lure.w ) then
				tinsert(lureinventory, lure);
			elseif ( lure.s <= rawskill ) then
				if ( not lure.w) then
					tinsert(useinventory, lure);
				end
			end
			--lure.n = GetItemInfo(id);
		end
	end
 end

local function ClickHandled(self)
	ResetOverride();
end
local function OverrideClick()
	SetOverrideBindingClick(btn, true, "BUTTON2", "FishHolder");
	btn.holder:Show();
end
btn = CreateFrame("Button", "FishHolder", holder, "SecureActionButtonTemplate");
btn.holder = holder;
btn:EnableMouse(true);
btn:RegisterForClicks("RightButtonUp");
btn:Show();

holder:SetPoint("LEFT", UIParent, "RIGHT", 10000, 0);
holder:SetFrameStrata("LOW");
holder:Hide();
btn:SetScript("PostClick", ClickHandled)

local function IsFishPole()
	local itemId = GetInventoryItemID("player", 16)
	if itemId then
		local subclass = select(7, GetItemInfo(itemId))
		local weaponSubTypesList = select(17, GetAuctionItemSubClasses(1))
		if subclass == weaponSubTypesList then
			return true
		else
			return false
		end
	else
		return false
	end
end
local lastClickTime = nil
local function CheckForDoubleClick()
	if lastClickTime then
		local pressTime = GetTime()
		local doubleTime = pressTime - lastClickTime
		if ( (doubleTime < 0.4) and (doubleTime > 0.05) ) then
			lastClickTime = nil
			return true
		end
	end
	lastClickTime = GetTime()
	return false
end
local function OnMouseDown(...)
	local button = select(2, ...)
	if button == "RightButton" and not InCombatLockdown() and CheckForDoubleClick() and knowFish and isPole then
		local hasMainHandEnchant=GetWeaponEnchantInfo()
		if hasMainHandEnchant then
			btn:SetAttribute("type", "spell")
			btn:SetAttribute('spell', spell)
		elseif #lureinventory > 0 then
			btn:SetAttribute("type", "item")
			btn:SetAttribute("item", "item:"..lureinventory[1].id)
			if GetItemCooldown(lureinventory[1].id) > 0 then
				btn:SetAttribute("type", "spell")
				btn:SetAttribute('spell', spell)
			end
		elseif #useinventory > 0 then
			btn:SetAttribute("type", "item")
			btn:SetAttribute("item", "item:"..useinventory[1].id)
			if GetItemCooldown(useinventory[1].id) > 0 then
				btn:SetAttribute("type", "spell")
				btn:SetAttribute('spell', spell)
			end
		else
			btn:SetAttribute("type", "spell")
			btn:SetAttribute('spell', spell)
		end
			OverrideClick()
	end
end

function F:HookWorldFrame()
	if not self:IsHooked(WorldFrame, "OnMouseDown") then
		--print("Hook")
		self:HookScript(WorldFrame, "OnMouseDown", OnMouseDown)
	end
end
function F:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if(IsSpellKnown(131474)) then
		knowFish = true
	end
	isPole = IsFishPole()
	if isPole and knowFish then
		UpdateLureInventory()
		self:HookWorldFrame()
	end
end

function F:PLAYER_EQUIPMENT_CHANGED()
	if InCombatLockdown() then return end
	isPole = IsFishPole()
	if(IsSpellKnown(131474)) then
		knowFish = true
	end
	if not InCombatLockdown() and knowFish and isPole then
		self:HookWorldFrame()
		UpdateLureInventory()
		self:RegisterEvent("BAG_UPDATE")
	else
		--print("UnHook")
		ClearOverrideBindings(btn)
		if self:IsHooked(WorldFrame, "OnMouseDown") then
			self:Unhook(WorldFrame, "OnMouseDown")
		end
		self:UnregisterEvent("BAG_UPDATE")
	end
end

function F:BAG_UPDATE()
	UpdateLureInventory()
end

function F:OnEnable()
	if InCombatLockdown() then return end
	F:RegisterEvent("PLAYER_ENTERING_WORLD")
	F:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
end