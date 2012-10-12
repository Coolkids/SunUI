local SETTINGS_VERSION = 15
local SORT_LEVEL = 1
local SORT_ALPHA = 2
local SORT_PETTYPE = 3
local SORT_RARITY = 4
local SORT_MAXSTAT =5
local SORT_PETID = 6
local MAX_BALANCED = 0
local MAX_ATTACK = 5
local MAX_SPEED = 10
local MAX_STAMINA = 15
local ASCENDING =  1
local DESCENDING = 2
local USER = nil
local COMPANION_BUTTON_HEIGHT = 46;
local MAX_ACTIVE_PETS = 3

PetJournalEnhanced = LibStub("AceAddon-3.0"):NewAddon("PetJournalEnhanced","AceEvent-3.0")
PetJournalEnhanced.petMapping = {}
PetJournalEnhanced.LastPetCount = nil
PetJournalEnhanced.locStr ={}

local Hooked = {}

function PetJournalEnhanced:UpdatePets()
	self:SortPets()
	Hooked.PetJournal_FindPetCardIndex()
	Hooked.PetJournal_UpdatePetList()
end

function PetJournalEnhanced:RefreshPets()
	local numPets = C_PetJournal.GetNumPets(false);
	if numPets ~=  #PetJournalEnhanced.petMapping then
		PetJournalEnhanced:SortPets()
	end
end

function PetJournalEnhanced:InitPetJournal()
	self.SortFunctions = self:GetSortFunctions()
	UIDropDownMenu_Initialize(PetJournalFilterDropDown, Hooked.PetJournalFilterDropDown , "MENU")
	hooksecurefunc("PetJournal_UpdatePetCard", Hooked.PetJournal_UpdatePetCard)
	hooksecurefunc(C_PetJournal,"SetFavorite",Hooked.C_PetJournal_SetFavorite)
	PetJournal:HookScript("OnShow",function() PetJournalEnhanced:UpdatePets() end)
	PetJournalSearchBox:HookScript("OnTextChanged",function() PetJournalEnhanced:UpdatePets() end)
	PetJournal.listScroll.update = Hooked.PetJournal_UpdatePetList
	PetJournal_ShowPetCard = Hooked.PetJournal_ShowPetCard
	PetJournal_FindPetCardIndex = Hooked.PetJournal_FindPetCardIndex
	PetJournal_SelectSpecies = Hooked.PetJournal_SelectSpecies
	PetJournal_SelectPet = Hooked.PetJournal_SelectPet
	PetJournal_UpdatePetList = Hooked.PetJournal_UpdatePetList
	PetJournal_ShowPetDropdown = Hooked.PetJournal_ShowPetDropdown
	hooksecurefunc("PetJournal_UpdatePetLoadOut", Hooked.PetJournal_UpdatePetLoadOut)


end

function PetJournalEnhanced:GetSortFunctions()
	local sortFunctions = {}
	--[[local levelThenName =  self.GetCompareFunc("level", self.GetCompareFunc("name",nil,ASCENDING))
	sortFunctions[SORT_LEVEL] = self.GetCompareFunc("favorite", self.GetCompareFunc("isOwned",self.GetCompareFunc("canBattle", levelThenName , DESCENDING),DESCENDING),DESCENDING)
	sortFunctions[SORT_ALPHA] =  self.GetCompareFunc("favorite",self.GetCompareFunc("isOwned", self.GetCompareFunc("name", self.GetCompareFunc("level")) , DESCENDING),DESCENDING)
	sortFunctions[SORT_PETTYPE] =  self.GetCompareFunc("favorite",self.GetCompareFunc("isOwned" ,self.GetCompareFunc("canBattle", self.GetCompareFunc("petType", levelThenName) , DESCENDING ),DESCENDING),DESCENDING)
	sortFunctions[SORT_RARITY] =  self.GetCompareFunc("favorite",self.GetCompareFunc("isOwned" ,self.GetCompareFunc("canBattle", self.GetCompareFunc("rarity", levelThenName) , DESCENDING ),DESCENDING),DESCENDING)
	sortFunctions[SORT_MAXSTAT] =  self.GetCompareFunc("favorite",self.GetCompareFunc("isOwned" ,self.GetCompareFunc("canBattle", self.GetCompareFunc("maxStat",levelThenName) , DESCENDING ) ,DESCENDING),DESCENDING)
	]]

	sortFunctions[SORT_ALPHA] =  self:ComposeSortFunction("favorite",DESCENDING,"isOwned",DESCENDING,"name",USER,"level",DESCENDING);
	sortFunctions[SORT_LEVEL] = self:ComposeSortFunction("favorite",DESCENDING,"isOwned",DESCENDING,"canBattle",DESCENDING,"level",USER,"name",ASCENDING);
	sortFunctions[SORT_PETTYPE] =  self:ComposeSortFunction("favorite",DESCENDING,"isOwned",DESCENDING,"canBattle",DESCENDING,"petType",USER,"level",DESCENDING,"name",ASCENDING);
	sortFunctions[SORT_RARITY] =  self:ComposeSortFunction("favorite",DESCENDING,"isOwned",DESCENDING,"canBattle",DESCENDING,"rarity",USER,"level",DESCENDING,"name",ASCENDING);
	sortFunctions[SORT_MAXSTAT] =  self:ComposeSortFunction("favorite",DESCENDING,"isOwned",DESCENDING,"canBattle",DESCENDING,"maxStat",USER,"level",DESCENDING,"name",ASCENDING);
	--sortFunctions[SORT_PETID] = self:ComposeSortFunction("favorite",DESCENDING,"isOwned",DESCENDING,"petID",nil);
	--sortFunctions[SORT_PETID] =  self:GetCompareFunc("favorite",self:GetCompareFunc("isOwned" , self:GetCompareFunc("petID",self:GetCompareFunc("name",nil, ASCENDING)) , DESCENDING),DESCENDING)

	return sortFunctions
end


function PetJournalEnhanced:ComposeSortFunction(...)
	local args = {...}
	local func = nil
	for i=#args,1,-2 do
		local name = args[i-1];
		local direction = args[i]
		func = self:GetCompareFunc(name,func,direction)
	end
	return func
end

function PetJournalEnhanced:GetCompareFunc(var,func,direction)

	return function(a,b)
		local avar = a[var]
		local bvar = b[var]
		if type(avar) == "boolean" then
			avar = avar and 1 or 0
			bvar = bvar and 1 or 0
		end

		if avar == bvar and func then
			return func(a,b)
		end

		if direction then
			if direction == ASCENDING then
				return avar < bvar
			elseif  direction == DESCENDING then
				return avar > bvar
			end
		elseif  PetJournalEnhancedOptions.sortOrder == ASCENDING then
			return avar < bvar
		elseif PetJournalEnhancedOptions.sortOrder == DESCENDING then
			return avar > bvar
		end
	end
end

function PetJournalEnhanced.GetMaxStat(maxHealth,attack,speed)

	maxHealth = tonumber(maxHealth)
	stamina = tonumber(math.floor((maxHealth -100)/5))
	attack = tonumber(attack)
	speed = tonumber(speed)

	if attack > speed and attack > stamina then
		return MAX_ATTACK
	elseif speed > attack and speed > stamina  then
		return MAX_SPEED
	elseif stamina > attack and stamina > speed  then
		return MAX_STAMINA
	end

	return MAX_BALANCED
end

function PetJournalEnhanced:Reset()
	PetJournalEnhancedOptions = {}
	PetJournalEnhancedOptions.SettingsVersion = SETTINGS_VERSION
	PetJournalEnhancedOptions.sortSelection = {}
	PetJournalEnhancedOptions.sortSelection = 1
	PetJournalEnhancedOptions.filterByZone = false;
	PetJournalEnhancedOptions.sortOrder = ASCENDING
	PetJournalEnhancedOptions.warning = true
	PetJournalEnhancedOptions.showUniquePetCount = true
	PetJournalEnhancedOptions.showColoredNames = true
	PetJournalEnhancedOptions.showColoredBorders = true
	PetJournalEnhancedOptions.showMaxStatIcon = true
	PetJournalEnhancedOptions.petBattles = {}
	PetJournalEnhancedOptions.petBattles.showQuality = true
	PetJournalEnhancedOptions.petBattles.showCooldowns = true
end



function PetJournalEnhanced:SortPets()
	if PetJournal:IsShown() then
		local numPets = C_PetJournal.GetNumPets(PetJournal.isWild)
		wipe(self.petMapping)
			collectgarbage("collect")
		for i=1,numPets do
			local petID, speciesID, isOwned, customName, level, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet, canBattle = C_PetJournal.GetPetInfoByIndex(i, PetJournal.isWild)
			local health, maxHealth, attack, speed, rarity = C_PetJournal.GetPetStats(petID)

			--["speciesID"] = speciesID, ["customName"] = customName, ["favorite"] = favorite, ["isRevoked"] = isRevoked, ["icon"] =icon, ["creatureID"] = creatureID, ["sourceText"] = sourceText, ["description"] = description, ["isWildPet"] = isWildPet,
			--pet = {["petID"] = petID,  ["isOwned"] = isOwned,  ["level"] = level,   ["name"] =name, ["petType"]=petType, [ "canBattle"] = canBattle,["favorite"]=favorite }
			pet = {}
			pet.petID = petID
			pet.isOwned = isOwned
			pet.level = level
			pet.name = name
			pet.petType = petType
			pet.canBattle = canBattle
			pet.favorite = favorite
			pet.index = i
			--pet.health = health
			--pet.maxHealth = maxHealth
			--pet.attack = attack
			--pet.speed = speed
			pet.rarity = rarity
			--pet.health = 0
			--pet.maxHealth = 0
			--pet.attack = 0
			--pet.speed = 0
			pet.maxStat = 0

			if petID and petID > 0 and canBattle and maxHealth and attack and speed then
				pet.maxStat = self.GetMaxStat(maxHealth,attack,speed)
			end

			if not pet.canBattle then
				pet.level = 0
			end

			if PetJournalEnhancedOptions.filterByZone then
				if string.find(sourceText, GetZoneText(),1,true) then
					table.insert(self.petMapping,pet)
				end
			else
				table.insert(self.petMapping,pet)
			end

			--table.insert(self.petMapping,pet)
		end
		table.sort(self.petMapping,self.SortFunctions[PetJournalEnhancedOptions.sortSelection])
	end


	-- if( GetAddOnMemoryUsage(self:GetName()) > 500) then
		-- print("collected")
	-- end
end

function PetJournalEnhanced:OnInitialize()
	if not PetJournalEnhancedOptions or not PetJournalEnhancedOptions.SettingsVersion or PetJournalEnhancedOptions.SettingsVersion ~= SETTINGS_VERSION then
			self:Reset()
	end

	self:InitPetJournal()
	self:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
	self:RegisterEvent("ZONE_CHANGED");
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterMessage("PETJOURNAL_ENHANCED_OPTIONS_UPDATE")

	self:RegisterEvent("PET_JOURNAL_PET_DELETED")
	--self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

	if IsAddOnLoaded("_PetJournalEnhanced") then
		StaticPopup_Show("PETJOURNAL_ENHANCED_DUPLICATE")
	end

	local LibPetJournal = LibStub("LibPetJournal-2.0")
	LibPetJournal:RegisterCallback("PetListUpdated", self.ScanPets)
end

 --event handlers
function PetJournalEnhanced:ZONE_CHANGED_NEW_AREA()
	self:ZONE_CHANGED()
end


function PetJournalEnhanced:ScanPets()
	PetJournalEnhanced:UpdatePets()
end

function PetJournalEnhanced:PETJOURNAL_ENHANCED_OPTIONS_UPDATE()
	self:UpdatePets()
end

function PetJournalEnhanced:PET_JOURNAL_PET_DELETED()
	self:UpdatePets()
end

function PetJournalEnhanced:ADDON_LOADED(event,...)
	local name = ...
	if name == "_PetJournalEnhanced"  then
		StaticPopup_Show("PETJOURNAL_ENHANCED_DUPLICATE")
	end
end

function PetJournalEnhanced:ZONE_CHANGED()
	if PetJournalEnhancedOptions.filterByZone then
		PetJournalEnhanced:UpdatePets()
	end
end

function PetJournalEnhanced:PET_JOURNAL_LIST_UPDATE()
	self:RefreshPets()
end

--blizzard functions to overwrite
function Hooked.PetJournal_ShowPetDropdown(index, anchorTo, offsetX, offsetY)
	if not PetJournal:IsShown() then return end
	--print("PetJournal_ShowPetDropdown")
	if (not index) then
		return;
	end

	PetJournal.menuPetIndex = index;
	PetJournal.menuPetID = C_PetJournal.GetPetInfoByIndex(PetJournalEnhanced.petMapping[index].index);
	ToggleDropDownMenu(1, nil, PetJournal.petOptionsMenu, anchorTo, offsetX, offsetY);
end

function Hooked.C_PetJournal_SetFavorite()
	PetJournalEnhanced:UpdatePets()
end

function Hooked.PetJournal_ShowPetCard(index)
	if not PetJournal:IsShown() then return end
	--print("PetJournal_ShowPetCard")
	PetJournal_HidePetDropdown();
	PetJournalPetCard.petIndex = index;
	local owned;
	PetJournalPetCard.petID, PetJournalPetCard.speciesID, owned = C_PetJournal.GetPetInfoByIndex(PetJournalEnhanced.petMapping[index].index, PetJournal.isWild);
	if ( not owned ) then
		PetJournalPetCard.petID = nil;
	end
	PetJournal_UpdatePetCard(PetJournalPetCard);
	PetJournal_UpdatePetList();
	PetJournal_UpdateSummonButtonState();
end

function Hooked.PetJournal_FindPetCardIndex()
	if not PetJournal:IsShown() then return end
	--local description = debugstack()

	--print("PetJournal_FindPetCardIndex")
	--print(description)

	PetJournalEnhanced:RefreshPets()

	PetJournalPetCard.petIndex = nil;
	for i = 1,#PetJournalEnhanced.petMapping do
		local petID, speciesID, owned = C_PetJournal.GetPetInfoByIndex(PetJournalEnhanced.petMapping[i].index,false);
		if (owned and petID == PetJournalPetCard.petID) or
			(not owned and speciesID == PetJournalPetCard.speciesID)  then
				PetJournalPetCard.petIndex = i;
				break;
		end
	end
end

function Hooked.PetJournal_SelectSpecies(self, targetSpeciesID)
	if not PetJournal:IsShown() then return end
	--print("PetJournal_SelectSpecies")

	--PetJournalEnhanced:RefreshPets()

	local petIndex = nil;
	for i = 1,#PetJournalEnhanced.petMapping do
		local petID, speciesID, owned = C_PetJournal.GetPetInfoByIndex(PetJournalEnhanced.petMapping[i].index, isWild);
		if (speciesID == targetSpeciesID) then
			petIndex = i;
			break;
		end
	end

	if ( petIndex ) then --Might be filtered out and have no index.

		PetJournalPetList_UpdateScrollPos(self.listScroll, petIndex);
	end
	PetJournal_ShowPetCardBySpeciesID(targetSpeciesID);
end

function Hooked.PetJournal_SelectPet(self, targetPetID)
	if not PetJournal:IsShown() then return end
	--print("PetJournal_SelectPet")

	--PetJournalEnhanced:RefreshPets()

	local petIndex = nil;
	for i = 1,#PetJournalEnhanced.petMapping do
		local petID, speciesID, owned = C_PetJournal.GetPetInfoByIndex(PetJournalEnhanced.petMapping[i].index, isWild);
		if (petID == targetPetID) then
			petIndex = i;
			break;
		end
	end

	if ( petIndex ) then --Might be filtered out and have no index.
		PetJournalPetList_UpdateScrollPos(self.listScroll, petIndex);
	end
	PetJournal_ShowPetCardByID(targetPetID);
end

function Hooked.PetJournal_UpdatePetList()
	if not PetJournal:IsShown() then return end

	local scrollFrame = PetJournal.listScroll;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local petButtons = scrollFrame.buttons;
	local pet, index;

	local isWild = PetJournal.isWild;

	local numPets, numOwned = C_PetJournal.GetNumPets(isWild);
	PetJournal.PetCount.Count:SetText(numOwned);

	local summonedPetID = C_PetJournal.GetSummonedPetID();

	--PetJournalEnhanced:RefreshPets()

	for i = 1,#petButtons do
		pet = petButtons[i];

		index = offset + i;
		if index <= #PetJournalEnhanced.petMapping then
			local petID, speciesID, isOwned, customName, level, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet, canBattle = C_PetJournal.GetPetInfoByIndex(PetJournalEnhanced.petMapping[index].index, isWild);

			if isOwned and PetJournalEnhancedOptions.showColoredNames and canBattle then
				local r, g, b,hex  = GetItemQualityColor(PetJournalEnhanced.petMapping[index].rarity-1)
				name = "|c"..hex..name.."|r"
--~ 				if customName then
--~ 					customName = "|c"..hex..customName.."|r"
--~ 				end
			end

			if customName then
				pet.name:SetText(customName);
				pet.name:SetHeight(12);
				pet.subName:Show();
				pet.subName:SetText(name);
			else
				pet.name:SetText(name)
				--pet.name:SetText(name.." "..index.." org: "..PetJournalEnhanced.petMapping[index].index );
				pet.name:SetHeight(30);
				pet.subName:Hide();
			end
			pet.icon:SetTexture(icon);
			pet.petTypeIcon:SetTexture(GetPetTypeTexture(petType));

			if (favorite) then
				pet.dragButton.favorite:Show();
			else
				pet.dragButton.favorite:Hide();
			end

			if isOwned then
				local health, maxHealth, attack, speed, rarity = C_PetJournal.GetPetStats(petID);

				pet.dragButton.levelBG:SetShown(canBattle);
				pet.dragButton.level:SetShown(canBattle);
				pet.dragButton.level:SetText(level);

				pet.icon:SetDesaturated(0);
				pet.name:SetFontObject("GameFontNormal");
				pet.petTypeIcon:SetShown(canBattle);
				pet.petTypeIcon:SetDesaturated(0);
				pet.dragButton:Enable();
				if (isWildPet) then
					pet.iconBorder:Show();
					pet.iconBorder:SetVertexColor(ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b);
				else
					pet.iconBorder:Hide();
				end
				if (health and health <= 0) then
					pet.isDead:Show();
				else
					pet.isDead:Hide();
				end
				if(isRevoked == true) then
					pet.dragButton.levelBG:Hide();
					pet.dragButton.level:Hide();
					pet.iconBorder:Hide();
					pet.icon:SetDesaturated(1);
					pet.petTypeIcon:SetDesaturated(1);
					pet.dragButton:Disable();
				end
			else
				pet.dragButton.levelBG:Hide();
				pet.dragButton.level:Hide();
				pet.icon:SetDesaturated(1);
				pet.iconBorder:Hide();
				pet.name:SetFontObject("GameFontDisable");
				pet.petTypeIcon:SetShown(canBattle);
				pet.petTypeIcon:SetDesaturated(1);
				pet.dragButton:Disable();
				pet.isDead:Hide();
			end

			if ( petID and petID == summonedPetID ) then
				pet.dragButton.ActiveTexture:Show();
			else
				pet.dragButton.ActiveTexture:Hide();
			end

			pet.petID = petID;
			pet.speciesID = speciesID;
			pet.index = index;
			pet.owned = isOwned;
			pet:Show();

			--Update Petcard Button
			if PetJournalPetCard.petIndex == index then
				pet.selected = true;
				pet.selectedTexture:Show();
			else
				pet.selected = false;
				pet.selectedTexture:Hide()
			end


			--being PJE code
			if not pet.highStat then
				pet.highStat = pet:CreateTexture(nil,"OVERLAY")
				pet.highStat:SetTexture("Interface\\PetBattles\\PetBattle-StatIcons")
				pet.highStat:SetTexCoord(0.0,0.5,0.0,0.5)
				pet.highStat:SetSize(12,12)
				pet.highStat:SetPoint("BOTTOMLEFT",pet.icon,"BOTTOMLEFT",2,1)
				pet.highStat:SetDrawLayer("OVERLAY", 7)

				pet.highStatBg = pet:CreateTexture(nil,"OVERLAY",2)
				pet.highStatBg:SetTexture("Interface\\PetBattles\\PetJournal")
				pet.highStatBg:SetTexCoord(0.06835938,0.10937500,0.02246094,0.04296875)
				pet.highStatBg:SetSize(21,21)
				pet.highStatBg:SetPoint("BOTTOMLEFT",pet.icon,"BOTTOMLEFT",-3,-3)
				pet.highStatBg:SetDrawLayer("OVERLAY", 6)
			end

			pet.highStat:Hide()
			pet.highStatBg:Hide()

			if pet.petID and pet.owned and canBattle then
				local health, maxHealth, attack, speed, rarity = C_PetJournal.GetPetStats(pet.petID)


				if rarity and PetJournalEnhancedOptions.showColoredBorders then
					pet.iconBorder:SetVertexColor(ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b)
					pet.iconBorder:Show()
				end

				if PetJournalEnhancedOptions.showMaxStatIcon then
					if  pet.owned and canBattle then
						local maxStat = PetJournalEnhanced.GetMaxStat(maxHealth,attack,speed)

						if maxStat == MAX_BALANCED then
							pet.highStat:SetTexCoord(0.0,0.0,0.0,0.0)
							pet.highStat:Hide()
							pet.highStatBg:Hide()
						else
							if maxStat == MAX_ATTACK then
								pet.highStat:SetTexCoord(0.0,0.5,0.0,0.5)
							elseif maxStat == MAX_STAMINA then
								pet.highStat:SetTexCoord(0.5,1.0,0.5,1.0)
							elseif maxStat == MAX_SPEED then
								pet.highStat:SetTexCoord(0.0,0.5,0.5,1)
							end
							pet.highStat:Show()
							pet.highStatBg:Show()
						end
					end
				end
			end

		else
			pet:Hide();
		end
	end

	local totalHeight = #PetJournalEnhanced.petMapping * COMPANION_BUTTON_HEIGHT;
	HybridScrollFrame_Update(scrollFrame, totalHeight, scrollFrame:GetHeight());
end

function Hooked.PetJournalFilterDropDown(self, level)

	local info = UIDropDownMenu_CreateInfo();
	info.keepShownOnClick = true;

	if level == 1 then

		info.text = COLLECTED
		info.func = 	function(_, _, _, value)
							C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, value);

							if (value) then
								UIDropDownMenu_EnableButton(1,2);
							else
								UIDropDownMenu_DisableButton(1,2);
							end;

							PetJournalEnhanced:UpdatePets()
						end
		info.checked = not C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_COLLECTED);
		info.isNotRadio = true;
		UIDropDownMenu_AddButton(info, level)

		info.text = FAVORITES_FILTER
		info.func = 	function(_, _, _, value)
							C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_FAVORITES, value);
							PetJournalEnhanced:UpdatePets()
						end
		info.disabled = not info.checked or info.checked ~= true;
		info.checked = not C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_FAVORITES);
		info.isNotRadio = true;
		info.leftPadding = 16;
		UIDropDownMenu_AddButton(info, level)
		info.leftPadding = 0;
		info.disabled = nil;

		info.text = NOT_COLLECTED
		info.func = 	function(_, _, _, value)
							C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED, value);
							PetJournalEnhanced:UpdatePets()
						end
		info.checked = not C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_NOT_COLLECTED);
		info.isNotRadio = true;
		UIDropDownMenu_AddButton(info, level)

		info.checked = 	nil;
		info.isNotRadio = nil;
		info.func =  nil;
		info.hasArrow = true;
		info.notCheckable = true;

		info.text = PET_FAMILIES
		info.value = 1;
		UIDropDownMenu_AddButton(info, level)

		info.text = SOURCES
		info.value = 2;
		UIDropDownMenu_AddButton(info, level)

	else --if level == 2 then
		if UIDROPDOWNMENU_MENU_VALUE == 1 then
			info.hasArrow = false;
			info.isNotRadio = true;
			info.notCheckable = true;


			info.text = CHECK_ALL
			info.func = function()
							C_PetJournal.AddAllPetTypesFilter();
							UIDropDownMenu_Refresh(PetJournalFilterDropDown, 1, 2);
							PetJournalEnhanced:UpdatePets()
						end
			UIDropDownMenu_AddButton(info, level)

			info.text = UNCHECK_ALL
			info.func = function()
							C_PetJournal.ClearAllPetTypesFilter();
							UIDropDownMenu_Refresh(PetJournalFilterDropDown, 1, 2);
							PetJournalEnhanced:UpdatePets()
						end
			UIDropDownMenu_AddButton(info, level)

			info.notCheckable = false;
			local numTypes = C_PetJournal.GetNumPetTypes();
			for i=1,numTypes do
				info.text = _G["BATTLE_PET_NAME_"..i];
				info.func = function(_, _, _, value)
							C_PetJournal.SetPetTypeFilter(i, value);
							PetJournalEnhanced:UpdatePets()
						end
				info.checked = function() return not C_PetJournal.IsPetTypeFiltered(i) end;
				UIDropDownMenu_AddButton(info, level);
			end
		elseif UIDROPDOWNMENU_MENU_VALUE == 2 then
			info.hasArrow = false;
			info.isNotRadio = true;
			info.notCheckable = true;


			info.text = CHECK_ALL
			info.func = function()
							C_PetJournal.AddAllPetSourcesFilter();
							UIDropDownMenu_Refresh(PetJournalFilterDropDown, 2, 2);
							PetJournalEnhanced:UpdatePets()
						end
			UIDropDownMenu_AddButton(info, level)

			info.text = UNCHECK_ALL
			info.func = function()
							C_PetJournal.ClearAllPetSourcesFilter();
							UIDropDownMenu_Refresh(PetJournalFilterDropDown, 2, 2);
							PetJournalEnhanced:UpdatePets()
						end
			UIDropDownMenu_AddButton(info, level)

			info.notCheckable = false;
			local numSources = C_PetJournal.GetNumPetSources();
			for i=1,numSources do
				info.text = _G["BATTLE_PET_SOURCE_"..i];
				info.func = function(_, _, _, value)
							C_PetJournal.SetPetSourceFilter(i, value);
							PetJournalEnhanced:UpdatePets()
						end
				info.checked = function() return not C_PetJournal.IsPetSourceFiltered(i) end;
				UIDropDownMenu_AddButton(info, level);
			end
		end
	end

	local info = UIDropDownMenu_CreateInfo()

	if level == 1 then
		info.keepShownOnClick = true
		info.checked = 	nil
		info.isNotRadio = nil
		info.func =  nil
		info.hasArrow = true
		info.notCheckable = true
		info.text = PetJournalEnhanced.locStr.SortOptions
		info.value = 3
		UIDropDownMenu_AddButton(info, level)

		info = UIDropDownMenu_CreateInfo()

		info.keepShownOnClick = true
		info.checked = PetJournalEnhancedOptions.showExtraPetInfo
		info.isNotRadio = true

		--[[info.text = "Show additional pet info"
		info.func = 	function(_, _, _, value)

					PetJournalEnhancedOptions.showExtraPetInfo = not PetJournalEnhancedOptions.showExtraPetInfo
					PetJournalEnhanced:UpdatePets()
				end
		info.checked = function() return PetJournalEnhancedOptions.showExtraPetInfo end
		UIDropDownMenu_AddButton(info, level)]]

		info.text = PetJournalEnhanced.locStr.Filterpetsbycurrentzone
		info.func = 	function(_, _, _, value)

					PetJournalEnhancedOptions.filterByZone = not PetJournalEnhancedOptions.filterByZone
					PetJournalEnhanced:UpdatePets()
				end
		info.checked = function() return PetJournalEnhancedOptions.filterByZone end
		UIDropDownMenu_AddButton(info, level)

	end
	if level == 2 and UIDROPDOWNMENU_MENU_VALUE == 3 then
		info.keepShownOnClick = true
		info.text = PetJournalEnhanced.locStr.SortOrder
		info.func = nil;
		info.notCheckable = true
		UIDropDownMenu_AddButton(info, level)

		info.notCheckable = false;
		local sortTypes = {[LEVEL] = SORT_LEVEL, 
		[PetJournalEnhanced.locStr.Alphabetical]= SORT_ALPHA, 
		[TYPE]= SORT_PETTYPE, [RARITY]= SORT_RARITY,
		[PetJournalEnhanced.locStr.PetHighestStat]= SORT_MAXSTAT}--,["Added to Pet Journal"]=SORT_PETID}

		for sortName,sortValue in pairs(sortTypes) do

			info.keepShownOnClick = true
			info.checked = false
			info.isNotRadio = false
			info.text = sortName
			info.func = 	function(_, _, _, value)

						PetJournalEnhancedOptions.sortSelection = sortValue
						UIDropDownMenu_Refresh(PetJournalFilterDropDown,1,2)
						PetJournalEnhanced:UpdatePets()
					end
			info.checked = function() return PetJournalEnhancedOptions.sortSelection == sortValue end
			UIDropDownMenu_AddButton(info, level)

		end

		info.keepShownOnClick = true
		info.checked = false
		info.isNotRadio = false


		info.text = PetJournalEnhanced.locStr.SortDirection
		info.func = nil;
		info.notCheckable = true
		UIDropDownMenu_AddButton(info, level)

		info.notCheckable = false;
		info.text = PetJournalEnhanced.locStr.SortAscending
		info.func = 	function(_, _, _, value)

					PetJournalEnhancedOptions.sortOrder = ASCENDING
					UIDropDownMenu_Refresh(PetJournalFilterDropDown,1,2)
					PetJournalEnhanced:UpdatePets()
				end
		info.checked = function() return PetJournalEnhancedOptions.sortOrder ==  ASCENDING end
		UIDropDownMenu_AddButton(info, level)

		info.text = PetJournalEnhanced.locStr.SortDescending
		info.func = 	function(_, _, _, value)
					PetJournalEnhancedOptions.sortOrder = DESCENDING
					UIDropDownMenu_Refresh(PetJournalFilterDropDown,1,2)
					PetJournalEnhanced:UpdatePets()
				end
		info.checked = function() return  PetJournalEnhancedOptions.sortOrder == DESCENDING end
		UIDropDownMenu_AddButton(info, level)
	end
end

function Hooked.PetJournal_UpdatePetCard()
	if PetJournalPetCard.petID  then
		local speciesID, customName, level, xp, maxXp, displayID, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable = C_PetJournal.GetPetInfoByPetID(PetJournalPetCard.petID)
	    if canBattle then
			local health, maxHealth, power, speed, rarity = C_PetJournal.GetPetStats(PetJournalPetCard.petID)
			PetJournalPetCard.QualityFrame.quality:SetText(_G["BATTLE_PET_BREED_QUALITY"..rarity])
			local r,g,b,hex  = GetItemQualityColor(rarity-1)

			if PetJournalEnhancedOptions.showColoredNames and canBattle then
				if customName then
					PetJournalPetCard.PetInfo.subName:SetText("|c"..hex..name.."|r")
				else
					PetJournalPetCard.PetInfo.name:SetText("|c"..hex..name.."|r")
				end
			end

			PetJournalPetCard.QualityFrame.quality:SetVertexColor(r, g, b)
			PetJournalPetCard.QualityFrame:Show()
		else
			PetJournalPetCard.QualityFrame:Hide()
		end
	end
end

function Hooked.PetJournal_UpdatePetLoadOut()
	if PetJournalEnhancedOptions.showColoredNames then
		for i=1, MAX_ACTIVE_PETS do
			local Pet = PetJournal.Loadout["Pet"..i];
			local petID, _, _, _, locked =  C_PetJournal.GetPetLoadOutInfo(i)
			if not locked and petID > 0 then
				local _, customName, _, _, _, _, name = C_PetJournal.GetPetInfoByPetID(petID)
				local rarity = select(5,C_PetJournal.GetPetStats(petID))
				local hex  = select(4,GetItemQualityColor(rarity-1))
				if customName then
					Pet.name:SetText(name);
 					Pet.subName:SetText("|c"..hex..customName.."|r");
				else
					Pet.name:SetText("|c"..hex..name.."|r");
					--pet.name:SetText(name.." "..index.." org: "..PetJournalEnhanced.petMapping[index].index );
				end
			end
		end
	end
end

StaticPopupDialogs["PETJOURNAL_ENHANCED_DUPLICATE"] = {
    text = "You have a second copy of PetJournal Enhanced|n installed named _PetJournalEnhanced|n in your /interface/addons/ folder",
    button1 = "OK",
    button2 = "Don't warn me again",
    OnAccept = function (self)  end,
    OnCancel = function (self) PetJournalEnhancedOptions.warning = false end,
    OnHide = function (self) end,
    hideOnEscape = 1,
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
}




