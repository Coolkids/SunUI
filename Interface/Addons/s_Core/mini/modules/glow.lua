local S, C, L, DB = unpack(select(2, ...))


local frameDB = {CharacterHeadSlot,
					CharacterNeckSlot,
					CharacterShoulderSlot,
					CharacterBackSlot,
					CharacterChestSlot,
					CharacterWristSlot,
					CharacterShirtSlot,
					CharacterTabardSlot,
					CharacterMainHandSlot,
					CharacterSecondaryHandSlot,
					CharacterRangedSlot,
					CharacterHandsSlot,
					CharacterWaistSlot,
					CharacterLegsSlot,
					CharacterFeetSlot,
					CharacterFinger0Slot,
					CharacterFinger1Slot,
					CharacterTrinket0Slot,
					CharacterTrinket1Slot
				}

local slotDB = {"HeadSlot",
					"NeckSlot",
					"ShoulderSlot",
					"BackSlot",
					"ChestSlot",
					"WristSlot",
					"ShirtSlot",
					"TabardSlot",
					"MainHandSlot",
					"SecondaryHandSlot",
					"RangedSlot",
					"HandsSlot",
					"WaistSlot",
					"LegsSlot",
					"FeetSlot",
					"Finger0Slot",
					"Finger1Slot",
					"Trinket0Slot",
					"Trinket1Slot"
				}

local isEnchantable = {"HeadSlot",
					"ShoulderSlot",
					"BackSlot",
					"ChestSlot",
					"MainHandSlot",
					"SecondaryHandSlot",
					"LegsSlot",
					"FeetSlot"
					}
					
local iEqAvg, iAvg
local txtG, txtR, txtY, txtW = tonumber(0xFF00CC00), tonumber(0xFFCC0000), tonumber(0xFFCCCC00), tonumber(0xFFFFFFFF)

local iLvlFrames = {}
local iQualityFrames = {}
local iDuraFrames = {}
local iModFrames = {}
				
function iLvLrMain()
	iLvLrFrame = CreateFrame("Frame", "iLvLrFrame", UIParent)
	
	iLvLrFrame:RegisterEvent("ADDON_LOADED")
	iLvLrFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	iLvLrFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	iLvLrFrame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	iLvLrFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	iLvLrFrame:RegisterEvent("SOCKET_INFO_UPDATE")
	iLvLrFrame:SetScript("OnEvent", iLvLrOnEvent)
end

function iLvLrOnEvent(self, event)
	if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" then
		iLvLrOnLoad()
	elseif event == "UNIT_INVENTORY_CHANGED" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "SOCKET_INFO_UPDATE" then
		iLvLrOnItemUpdate()
		iLvLrOnModUpdate()
	elseif event == "UPDATE_INVENTORY_DURABILITY" then
		iLvLrOnDuraUpdate()
	end
end

function iLvLrOnLoad()
	--print("in OnLoad")
	for k ,v in pairs(slotDB) do
		local iLevel = fetchIlvl(v)
		if iLevel then
			makeQuality(frameDB[k], v)
			if v == "ShirtSlot" or v == "TabardSlot" then
				-- Do Nothing
			else
				makeIlvl(frameDB[k], v)
				makeDurability(frameDB[k], v)
				makeMod(frameDB[k], v)
			end
		end
	end
end

function iLvLrOnItemUpdate()
	--print("in OnItemUpdate")
	for k ,v in pairs(slotDB) do
		local iLevel = fetchIlvl(v)
		if iLevel then
			makeQuality(frameDB[k], v)
			if v == "ShirtSlot" or v == "TabardSlot" then
				-- Do Nothing
			else
				makeIlvl(frameDB[k], v)
				makeDurability(frameDB[k], v)
				makeMod(frameDB[k], v)
			end
		else
			if iLvlFrames[v] then
				iLvlFrames[v]:Hide()
			end
			if iQualityFrames[v] then
				iQualityFrames[v]:Hide()
			end
			if iDuraFrames[v] then
				iDuraFrames[v]:Hide()
			end
			if iModFrames[v] then
				iModFrames[v]:Hide()
			end
		end
	end
end

function iLvLrOnDuraUpdate()
	--print("in OnDuraUpdate")
	for k ,v in pairs(slotDB) do
		local iLevel = fetchIlvl(v)
		if iLevel then
			if v == "ShirtSlot" or v == "TabardSlot" then
				-- Do Nothing
			else
				makeDurability(frameDB[k], v)
			end
		else
			if iDuraFrames[v] then
				iDuraFrames[v]:Hide()
			end
		end
	end
end

function iLvLrOnModUpdate()
	for k ,v in pairs(slotDB) do
		local iLevel = fetchIlvl(v)
		if iLevel then
			if v == "ShirtSlot" or v == "TabardSlot" then
				-- Do Nothing
			else
				makeMod(frameDB[k], v)
			end
		else
			if iModFrames[v] then
				iModFrames[v]:Hide()
			end
		end
	end
end

function fetchIlvl(slotName)
	--print("in fetchIlvl")
	local slotId, texture, checkRelic = GetInventorySlotInfo(slotName)
	local itemId = GetInventoryItemID("player", slotId)
	if itemId then
		local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemId)
		return(iLevel)
	end
end

function fetchQuality(slotName)
	--print("in fetchQuality")
	local slotId, texture, checkRelic = GetInventorySlotInfo(slotName)
	local itemId = GetInventoryItemID("player", slotId)
	if itemId then
		local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemId)
		local r, g, b, hex = GetItemQualityColor(quality)
		return r, g, b
	end
end

function fetchDura(slotName)
	--print("in fetchDura")
	local slotId, texture, checkRelic = GetInventorySlotInfo(slotName)
	if slotId then
		local itemDurability, itemMaxDurability = GetInventoryItemDurability(slotId)
		if itemDurability then
			return itemDurability, itemMaxDurability
		end
	end
end

function fetchSocketCount(slotName)
	local inventoryID = GetInventorySlotInfo(slotName)
	local itemLink = GetInventoryItemLink("player", inventoryID)
	
	local socketCount = 0
	for i = 1, 4 do
		if  _G["iLvLrScannerTexture" .. i]  then
	 		_G["iLvLrScannerTexture" .. i]:SetTexture("")
	 	end
	end
	
	if not iLvLrScanner then CreateFrame("GameToolTip", "iLvLrScanner", UIParent, "GameTooltipTemplate") end
	local ttScanner = iLvLrScanner
	
	ttScanner:SetOwner(iLvLrFrame, "ANCHOR_NONE")
	ttScanner:ClearLines()
	ttScanner:SetHyperlink(itemLink)
	
	for i = 1, 4 do
		local texture = _G["iLvLrScannerTexture" .. i]:GetTexture()
		if texture then
			socketCount = socketCount + 1
		end
	end
	
	ttScanner:Hide()
	
	return socketCount
end

function fetchGem(slotName)
	local inventoryID = GetInventorySlotInfo(slotName)
	local itemLink = GetInventoryItemLink("player", inventoryID)
	
	local missingGems = 0
							
	local emptyTextures = {"Interface\\ItemSocketingFrame\\UI-EmptySocket-Meta", 
							"Interface\\ItemSocketingFrame\\UI-EmptySocket-Red",
							"Interface\\ItemSocketingFrame\\UI-EmptySocket-Yellow",
							"Interface\\ItemSocketingFrame\\UI-EmptySocket-Blue",
							"Interface\\ItemSocketingFrame\\UI-EmptySocket-CogWheel",
							"Interface\\ItemSocketingFrame\\UI-EmptySocket-Hydraulic",
							"Interface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic",
							"Interface\\ItemSocketingFrame\\UI-EmptySocket"
							}
	
	for i = 1, 4 do
		if ( _G["iLvLrScannerTexture" .. i] ) then
	 		_G["iLvLrScannerTexture" .. i]:SetTexture("");
	 	end;
	end;
	
	if not iLvLrScanner then CreateFrame("GameToolTip", "iLvLrScanner", UIParent, "GameTooltipTemplate") end
	local ttScanner = iLvLrScanner
	
	ttScanner:SetOwner(iLvLrFrame, "ANCHOR_NONE")
	ttScanner:ClearLines()
	ttScanner:SetHyperlink(itemLink)
	
	for i = 1, 4 do
		local texture = _G["iLvLrScannerTexture" .. i]:GetTexture()
		if texture then
			for k, v in pairs(emptyTextures) do
				if texture == v then
					missingGems = missingGems + 1
				end
			end
		end
	end
	
	ttScanner:Hide()
	
	return missingGems
end

function fetchBaseSocket(slotName)
	local inventoryID = GetInventorySlotInfo(slotName)
	local itemLink = GetInventoryItemLink("player", inventoryID)
	
	local parsedItemDataTable = {}
	local foundStart, foundEnd, parsedItemData = string.find(itemLink, "^|c%x+|H(.+)|h%[.*%]")
	
	for v in string.gmatch(parsedItemData, "[^:]+") do
		tinsert(parsedItemDataTable, v)
	end
	
	local baseItem = "|Hitem:" .. parsedItemDataTable[2] .. ":0"
	local itemName, itemLink, itemQuality, itemLevel, itemReqLevel, itemClass, itemSubclass, itemMaxStack, itemEquipSlot, itemTexture, itemVendorPrice = GetItemInfo(baseItem)
	local baseSocketCount = 0
	for i = 1, 4 do
		if  _G["iLvLrScannerTexture" .. i]  then
	 		_G["iLvLrScannerTexture" .. i]:SetTexture("")
	 	end
	end
	
	if not iLvLrScanner then CreateFrame("GameToolTip", "iLvLrScanner", UIParent, "GameTooltipTemplate") end
	local ttScanner = iLvLrScanner
	
	ttScanner:SetOwner(iLvLrFrame, "ANCHOR_NONE")
	ttScanner:ClearLines()
	ttScanner:SetHyperlink(itemLink)
	
	for i = 1, 4 do
		local texture = _G["iLvLrScannerTexture" .. i]:GetTexture()
		if texture then
			baseSocketCount = baseSocketCount + 1
		end
	end
	
	ttScanner:Hide()
	
	return baseSocketCount
end

function fetchChant(slotName)
	local inventoryID = GetInventorySlotInfo(slotName)
	local itemLink = GetInventoryItemLink("player", inventoryID)
	
	local parsedItemDataTable = {}
	local foundStart, foundEnd, parsedItemData = string.find(itemLink, "^|c%x+|H(.+)|h%[.*%]")
	for v in string.gmatch(parsedItemData, "[^:]+") do
		tinsert(parsedItemDataTable, v)
	end
	
	return parsedItemDataTable[3]
end

function fetchProfs()
	local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions()
	local profs = {prof1, prof2, archaeology, fishing, cooking, firstAid}
	local profNames = {}
	
	for k, v in pairs(profs) do
		local name, texture, rank, maxRank, numSpells, spelloffset, skillLine, rankModifier = GetProfessionInfo(v)
		tinsert(profNames, name)
	end
	
	return profNames
end

function fetchSubclass(slotName)
	local slotId, texture, checkRelic = GetInventorySlotInfo(slotName)
	local itemId = GetInventoryItemID("player", slotId)
	if itemId then
		local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemId)
		return(subclass)
	end
end

function makeIlvl(frame, slot)
	--print("in makeText")
	iEqAvg, iAvg = GetAverageItemLevel()
	local iLvl = iLvlFrames[slot]
	if not iLvl then
		iLvl = CreateFrame("Frame", nil, frame)
		
		if frame == CharacterHeadSlot or frame == CharacterNeckSlot or frame == CharacterShoulderSlot or frame == CharacterBackSlot or frame == CharacterChestSlot or frame == CharacterWristSlot or frame == CharacterShirtSlot or frame == CharacterTabardSlot then
			iLvl:SetPoint("CENTER", frame, "CENTER", 42, -1)
		elseif frame == CharacterHandsSlot or frame == CharacterWaistSlot or frame == CharacterLegsSlot or frame == CharacterFeetSlot or frame == CharacterFinger0Slot or frame == CharacterFinger1Slot or frame == CharacterTrinket0Slot or frame == CharacterTrinket1Slot then
			iLvl:SetPoint("CENTER", frame, "CENTER", -42, -1)
		elseif frame == CharacterMainHandSlot or frame == CharacterSecondaryHandSlot or frame == CharacterRangedSlot then
			iLvl:SetPoint("CENTER", frame, "CENTER", 0, 41)
		end
		
		iLvl:SetSize(10,10)
		iLvl:SetBackdrop({bgFile = nil, edgeFile = nil, tile = false, tileSize = 32, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		iLvl:SetBackdropColor(0,0,0,0)
		
		local iLvlText = iLvl:CreateFontString(nil, "ARTWORK")
		isValid = iLvlText:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
		iLvlText:SetPoint("CENTER", iLvl, "CENTER", 0, 0)
		iLvl.text = iLvlText
		
		local iLevel = fetchIlvl(slot)
		if iLevel <= (floor(iEqAvg) - 10) then
			iLvl.text:SetFormattedText("|c%x%i", txtR, iLevel)
		elseif iLevel >= (floor(iEqAvg) +10) then
			iLvl.text:SetFormattedText("|c%x%i", txtG, iLevel)
		else
			iLvl.text:SetFormattedText("|c%x%i", txtW, iLevel)
		end
		
		iLvlFrames[slot] = iLvl
	else
		local iLevel = fetchIlvl(slot)
		if iLevel <= (floor(iEqAvg) - 10) then
			iLvl.text:SetFormattedText("|c%x%i", txtR, iLevel)
		elseif iLevel >= (floor(iEqAvg) +10) then
			iLvl.text:SetFormattedText("|c%x%i", txtG, iLevel)
		else
			iLvl.text:SetFormattedText("|c%x%i", txtW, iLevel)
		end
		
		iLvlFrames[slot] = iLvl
	end
	
	iLvl:Show()
end

function makeQuality(frame, slot)
	--print("in makeQuality")
	local iQuality = iQualityFrames[slot]
	if not iQuality then
		iQuality = CreateFrame("Frame", nil, frame)
		iQuality:SetPoint("CENTER", frame, "CENTER", 0, 0)
		iQuality:SetSize(frame:GetWidth()+5, frame:GetHeight()+5)
		iQuality:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = 4})
		
		local r, g, b = fetchQuality(slot)
		if r == 1 and g == 1 and b == 1 then
		iQuality:SetBackdropBorderColor(0, 0, 0, 0.1)
		else
		iQuality:SetBackdropBorderColor(r, g, b, 1.0)
		end
		iQualityFrames[slot] = iQuality
	else
	iQuality:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = 4})
		local r, g, b = fetchQuality(slot)
		if r == 1 and g == 1 and b == 1 then
		iQuality:SetBackdropBorderColor(0, 0, 0, 0.1)
		else
		iQuality:SetBackdropBorderColor(r, g, b, 1.0)
		end
	end
	
	iQuality:Show()
end

function makeDurability(frame, slot)
	--print("in makeDurability")
	local iDura = iDuraFrames[slot]
	if not iDura then
		iDura = CreateFrame("Frame", nil, frame)
		
		if frame == CharacterHeadSlot or frame == CharacterNeckSlot or frame == CharacterShoulderSlot or frame == CharacterBackSlot or frame == CharacterChestSlot or frame == CharacterWristSlot or frame == CharacterShirtSlot or frame == CharacterTabardSlot then
			iDura:SetPoint("BOTTOM", frame, "BOTTOM", 42, 0)
		elseif frame == CharacterHandsSlot or frame == CharacterWaistSlot or frame == CharacterLegsSlot or frame == CharacterFeetSlot or frame == CharacterFinger0Slot or frame == CharacterFinger1Slot or frame == CharacterTrinket0Slot or frame == CharacterTrinket1Slot then
			iDura:SetPoint("BOTTOM", frame, "BOTTOM", -42, 0)
		elseif frame == CharacterMainHandSlot or frame == CharacterSecondaryHandSlot or frame == CharacterRangedSlot then
			iDura:SetPoint("BOTTOM", frame, "BOTTOM", 0, 42)
		end
		
		iDura:SetSize(10,10)
		iDura:SetBackdrop({bgFile = nil, edgeFile = nil, tile = false, tileSize = 32, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		iDura:SetBackdropColor(0,0,0,0)
		
		local iDuraText = iDura:CreateFontString(nil, "ARTWORK")
		isValid = iDuraText:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
		iDuraText:SetPoint("CENTER", iDura, "CENTER", 0, 0)
		iDura.text = iDuraText
		
		itemDurability, itemMaxDurability = fetchDura(slot)
		if itemDurability then
			local itemDurabilityPercentage = (itemDurability / itemMaxDurability) --* 100
			if(ceil(itemDurabilityPercentage * 100) < 100)then
					iDura.text:SetTextColor(1 - itemDurabilityPercentage, itemDurabilityPercentage, 0)
					iDura.text:SetText(ceil(itemDurabilityPercentage * 100) .. "%")
				else
					iDura.text:SetTextColor(0, 1, 0)
					iDura.text:SetText(ceil(100) .. "%")
				end
			--[[if itemDurabilityPercentage > 25 then
				iDura.text:SetFormattedText("|c%x%i%%", txtG, itemDurabilityPercentage)
			elseif itemDurabilityPercentage > 0 and itemDurabilityPercentage <= 25 then
				iDura.text:SetFormattedText("|c%x%i%%", txtY, itemDurabilityPercentage)
			elseif itemDurabilityPercentage == 0 then
				iDura.text:SetFormattedText("|c%x%i%%", txtR, itemDurabilityPercentage)
			end--]]
		--else
			--iDura.text:SetFormattedText("")
		end
		
		iDuraFrames[slot] = iDura
	else
		itemDurability, itemMaxDurability = fetchDura(slot)
		if itemDurability then
			local itemDurabilityPercentage = (itemDurability / itemMaxDurability) --* 100
			if(ceil(itemDurabilityPercentage * 100) < 100)then
					iDura.text:SetTextColor(1 - itemDurabilityPercentage, itemDurabilityPercentage, 0)
					iDura.text:SetText(ceil(itemDurabilityPercentage * 100) .. "%")
				else
					iDura.text:SetTextColor(0, 1, 0)
					iDura.text:SetText(ceil(100) .. "%")
				end
		else
			iDura.text:SetFormattedText("")
		end
		
		iDuraFrames[slot] = iDura
	end
	
	iDura:Show()
end

function makeMod(frame, slot)
	--print("in makeMod")
	local missingGem, numSockets, isEnchanted, canEnchant
	local iMod = iModFrames[slot]
	if not iMod then
		iMod = CreateFrame("Frame", nil, frame)
		
		if frame == CharacterHeadSlot or frame == CharacterNeckSlot or frame == CharacterShoulderSlot or frame == CharacterBackSlot or frame == CharacterChestSlot or frame == CharacterWristSlot or frame == CharacterShirtSlot or frame == CharacterTabardSlot then
			iMod:SetPoint("TOP", frame, "TOP", 42, -3)
		elseif frame == CharacterHandsSlot or frame == CharacterWaistSlot or frame == CharacterLegsSlot or frame == CharacterFeetSlot or frame == CharacterFinger0Slot or frame == CharacterFinger1Slot or frame == CharacterTrinket0Slot or frame == CharacterTrinket1Slot then
			iMod:SetPoint("TOP", frame, "TOP", -42, -3)
		elseif frame == CharacterMainHandSlot or frame == CharacterSecondaryHandSlot or frame == CharacterRangedSlot then
			iMod:SetPoint("TOP", frame, "TOP", 0, 39)
		end
		
		iMod:SetSize(10,10)
		iMod:SetBackdrop({bgFile = nil, edgeFile = nil, tile = false, tileSize = 32, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		iMod:SetBackdropColor(0,0,0,0)
		
		local iModText = iMod:CreateFontString(nil, "ARTWORK")
		isValid = iModText:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
		iModText:SetPoint("CENTER", iMod, "CENTER", 0, 0)
		iMod.text = iModText
		
		missingGem = fetchGem(slot)
		numSockets = fetchSocketCount(slot)
		canEnchant = false
		missingSpecial = 0
		
		if slot == "Finger0Slot" or slot == "Finger1Slot" then
			local profNames = fetchProfs()
			for k, v in pairs(profNames) do
				if v == "Enchanting" then
					canEnchant = true
					isEnchanted = fetchChant(slot)
				end
			end
		elseif slot == "RangedSlot" then
			local subClass = fetchSubclass(slot)
			if subClass == "Bows" or subClass == "Guns" or subClass == "Crossbows" then
				canEnchant = true
				isEnchanted = fetchChant(slot)
			end
		elseif slot == "WristSlot" or slot == "HandsSlot" then
			local isBS = false
			canEnchant = true
			local profNames = fetchProfs()
			for k, v in pairs(profNames) do
				if v == "Blacksmithing" then
					isBS = true
					local baseSockets = fetchBaseSocket(slot)
					if (baseSockets - numSockets) == -1 then
						missingSpecial = 1
					else
						missingSpecial = 0
					end
				end
			end
			isEnchanted = fetchChant(slot)
			
			if isBs and missingSpecial == 0 then
				isEnchanted = 0
			end
		elseif slot == "WaistSlot" then
			canEnchant = true
			local baseSockets = fetchBaseSocket(slot)
			if (baseSockets - numSockets) == -1 then
				isEnchanted = 1
			else
				isEnchanted = 0
			end
		else
			for k ,v in pairs(isEnchantable) do
				if v == slot then
					canEnchant = true
					isEnchanted = fetchChant(slot)
				end
			end
		end
		
		isEnchanted = tonumber(isEnchanted)
		
		if numSockets > 0 and canEnchant == true then
			if isEnchanted == 0 and missingGem > 0 then
				iMod.text:SetFormattedText("|c%x%s |c%x%s", txtR, "E", txtR, "G")
			elseif isEnchanted == 0 and missingGem == 0 then
				iMod.text:SetFormattedText("|c%x%s |c%x%s", txtR, "E", txtG, "G")
			elseif isEnchanted > 0 and missingGem > 0 then
				iMod.text:SetFormattedText("|c%x%s |c%x%s", txtG, "E", txtR, "G")
			elseif isEnchanted > 0 and missingGem == 0 then
				iMod.text:SetFormattedText("|c%x%s |c%x%s", txtG, "E", txtG, "G")
			end
		elseif numSockets > 0 and canEnchant == false then
			if missingGem > 0 then
				iMod.text:SetFormattedText("|c%x%s", txtR, "G")
			elseif missingGem == 0 then
				iMod.text:SetFormattedText("|c%x%s", txtG, "G")
			end
		elseif numSockets == 0 and canEnchant == true then
			if isEnchanted == 0 then
				iMod.text:SetFormattedText("|c%x%s", txtR, "E")
			elseif isEnchanted > 0 then
				iMod.text:SetFormattedText("|c%x%s", txtG, "E")
			end
		elseif numSockets == 0 and canEnchant == false then
			iMod.text:SetFormattedText("")
		end
		
		iModFrames[slot] = iMod
		
	else
	
		missingGem = fetchGem(slot)
		numSockets = fetchSocketCount(slot)
		canEnchant = false
		missingSpecial = 0
		
		if slot == "Finger0Slot" or slot == "Finger1Slot" then
			local profNames = fetchProfs()
			for k, v in pairs(profNames) do
				if v == "Enchanting" then
					canEnchant = true
					isEnchanted = fetchChant(slot)
				end
			end
		elseif slot == "RangedSlot" then
			local subClass = fetchSubclass(slot)
			if subClass == "Bows" or subClass == "Guns" or subClass == "Crossbows" then
				canEnchant = true
				isEnchanted = fetchChant(slot)
			end
		elseif slot == "WristSlot" or slot == "HandsSlot" then
			local isBS = false
			canEnchant = true
			local profNames = fetchProfs()
			for k, v in pairs(profNames) do
				if v == "Blacksmithing" then
					isBS = true
					local baseSockets = fetchBaseSocket(slot)
					if (baseSockets - numSockets) == -1 then
						missingSpecial = 1
					else
						missingSpecial = 0
					end
				end
			end
			isEnchanted = fetchChant(slot)
			
			if isBs and missingSpecial == 0 then
				isEnchanted = 0
			end
		elseif slot == "WaistSlot" then
			canEnchant = true
			local baseSockets = fetchBaseSocket(slot)
			if (baseSockets - numSockets) == -1 then
				isEnchanted = 1
			else
				isEnchanted = 0
			end
		else
			for k ,v in pairs(isEnchantable) do
				if v == slot then
					canEnchant = true
					isEnchanted = fetchChant(slot)
				end
			end
		end
		
		isEnchanted = tonumber(isEnchanted)
		
		if numSockets > 0 and canEnchant == true then
			if isEnchanted == 0 and missingGem > 0 then
				iMod.text:SetFormattedText("|c%x%s |c%x%s", txtR, "E", txtR, "G")
			elseif isEnchanted == 0 and missingGem == 0 then
				iMod.text:SetFormattedText("|c%x%s |c%x%s", txtR, "E", txtG, "G")
			elseif isEnchanted > 0 and missingGem > 0 then
				iMod.text:SetFormattedText("|c%x%s |c%x%s", txtG, "E", txtR, "G")
			elseif isEnchanted > 0 and missingGem == 0 then
				iMod.text:SetFormattedText("|c%x%s |c%x%s", txtG, "E", txtG, "G")
			end
		elseif numSockets > 0 and canEnchant == false then
			if missingGem > 0 then
				iMod.text:SetFormattedText("|c%x%s", txtR, "G")
			elseif missingGem == 0 then
				iMod.text:SetFormattedText("|c%x%s", txtG, "G")
			end
		elseif numSockets == 0 and canEnchant == true then
			if isEnchanted == 0 then
				iMod.text:SetFormattedText("|c%x%s", txtR, "E")
			elseif isEnchanted > 0 then
				iMod.text:SetFormattedText("|c%x%s", txtG, "E")
			end
		elseif numSockets == 0 and canEnchant == false then
			iMod.text:SetFormattedText("")
		end
		
		iModFrames[slot] = iMod
	end
	
	iMod:Show()
end

iLvLrMain()
