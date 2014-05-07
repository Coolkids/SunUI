--[[
	BagSync.lua
		A item tracking addon similar to Bagnon_Forever (special thanks to Tuller).
		Works with practically any Bag mod available, Bagnon not required.
	Author: Xruptor
--]]
local S, _, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local BagSync = S:NewModule("SunUIBagSync", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

------------------------------
--          CONFIG          --
------------------------------

local showTotal = true			-- 在鼠标提示中显示总数
local enableFaction = true		-- 显示对立阵营角色的物品 (联盟/部落)
local enableMailbox = true		-- 显示邮箱中的物品
local enableAuction = false		-- 显示拍卖行中的物品

------------------------------
--       LOCALIZATION       --
------------------------------

local L = GetLocale() == "zhCN" and {
	["Bags: %d"] = "背包：%d",
	["Bank: %d"] = "银行：%d",
	["Equipped: %d"] = "已装备：%d",
	["Mailbox: %d"] = "邮箱：%d",
	["AH: %d"] = "拍卖行：%d",
	["Total:"] = "总计：",
} or GetLocale() == "zhTW" and {
	["Bags: %d"] = "背包: %d",
	["Bank: %d"] = "銀行: %d",
	["Equipped: %d"] = "已裝備: %d",
	["Mailbox: %d"] = "郵箱：%d",
	["AH: %d"] = "拍賣行：%d",
	["Total:"] = "總計: ",
} or { 
	["Bags: %d"] = "Bags: %d",
	["Bank: %d"] = "Bank: %d",
	["Equipped: %d"] = "Equipped: %d",
	["Mailbox: %d"] = "Mailbox：%d",
	["AH: %d"] = "AH：%d",
	["Total:"] = "Total: ",
}

------------------------------
--        VARIABLES	        --
------------------------------

local lastItem
local lastDisplayed = {}
local currentPlayer
local currentRealm
local playerClass
local playerFaction
local NUM_EQUIPMENT_SLOTS = 18
local BS_DB
local atBank = false

local SILVER = '|cffc7c7cf%s|r'
local MOSS = '|cFF71D5FF%s|r'
local TTL_C = '|cFFF4A460%s|r'

------------------------------
--        MAIN OBJ	        --
------------------------------
function BagSync:Initialize()
	self:PLAYER_LOGIN()
end
----------------------
--   DB Functions   --
----------------------

local function StartupDB()
	S.global.BagSyncDB = S.global.BagSyncDB or {}
	S.global.BagSyncDB[currentRealm] = S.global.BagSyncDB[currentRealm] or {}
	S.global.BagSyncDB[currentRealm][currentPlayer] = S.global.BagSyncDB[currentRealm][currentPlayer] or {}
	BS_DB = S.global.BagSyncDB[currentRealm][currentPlayer]
end

----------------------
--      Local       --
----------------------

local function GetBagSize(bagid)
	if bagid == 'equip' then
		return NUM_EQUIPMENT_SLOTS
	end
	return GetContainerNumSlots(bagid)
end

local function GetTag(bagname, bagid, slot)
	if bagname and bagid and slot then
		return bagname..':'..bagid..':'..slot
	end
	return nil
end

--special thanks to tuller :)
local function ToShortLink(link)
	--honestly I did it this half-ass way because of tired of having to update this everytime blizzard decides to alter their itemid format.
	--at least this way it will always pull the first number after itemid: and before the second :
	--it's not the best way to do this, but it's better then having to freaking modify a regex every so often.  Their latest change is due to Transmorgify.
	if link and type(link) == "string" and string.find(link, "item:") then
		--first attempt
		local _, first = string.find(link, "item:")
		local second = string.find(link, ":", first+1) --first occurance of : after item:
		local finally = string.sub(link, first+1, second-1) --after item:  and before second :
		if tonumber(finally) then
			return finally
		end
		--second attempt
		local a,b,c,d,e,f,g,h = link:match('(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+)')
		if(b == '0' and b == c and c == d and d == e and e == f and f == g) then
			return a
		end
		--final attempt
		return format('item:%s:%s:%s:%s:%s:%s:%s:%s', a, b, c, d, e, f, g, h)
	end
	return nil
end

----------------------
--  Bag Functions   --
----------------------

local function SaveItem(bagname, bagid, slot)
	local index = GetTag(bagname, bagid, slot)
	if not index then return nil end
	
	--reset our tooltip data since we scanned new items (we want current data not old)
	lastItem = nil
	lastDisplayed = {}

	local texture, count = GetContainerItemInfo(bagid, slot)

	if texture then
		local link = ToShortLink(GetContainerItemLink(bagid, slot))
		count = count > 1 and count or nil
		
		--Example ["bag:0:1"] = link, count
		if (link and count) then
			BS_DB[index] = format('%s,%d', link, count)
		else
			BS_DB[index] = link
		end
		
		return
	end
	
	BS_DB[index] = nil
end

local function SaveBag(bagname, bagid, rollupdate)
	if not BS_DB then StartupDB() end
	--this portion of the code will save the bag data, (type of bag, size of bag, bag item link, etc..)
	--this is used later to quickly grab bag data and size without having to go through the whole
	--song and dance again
	--bd = bagdata
	--Example ["bd:bagid:0"] = size, link, count
	local size = GetBagSize(bagid)
	local index = GetTag('bd', bagname, bagid)
	if not index then return end
	
	if size > 0 then
		local invID = bagid > 0 and ContainerIDToInventoryID(bagid)
		local link = ToShortLink(GetInventoryItemLink('player', invID))
		local count =  GetInventoryItemCount('player', invID)
		if count < 1 then count = nil end

		if (size and link and count) then
			BS_DB[index] = format('%d,%s,%d', size, link, count)
		elseif (size and link) then
			BS_DB[index] = format('%d,%s', size, link)
		else
			BS_DB[index] = size
		end
	else
		BS_DB[index] = nil
	end
	
	--used to scan the entire bag and save it's item data
	if rollupdate then
		for slot = 1, GetBagSize(bagid) do
			SaveItem(bagname, bagid, slot)
		end
	end
end

local function OnBagUpdate(bagid)
	--this will update the bank/bag slots
	local bagname

	--get the correct bag name based on it's id, trying NOT to use numbers as Blizzard may change bagspace in the future
	--so instead I'm using constants :)
	
	if bagid == -4 or bagid == -2 then return end --dont touch tokens or keyring
	
	if bagid == BANK_CONTAINER then
		bagname = 'bank'
	elseif (bagid >= NUM_BAG_SLOTS + 1) and (bagid <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) then
		bagname = 'bank'
	elseif (bagid >= BACKPACK_CONTAINER) and (bagid <= BACKPACK_CONTAINER + NUM_BAG_SLOTS) then
		bagname = 'bag'
	else
		return
	end

	if atBank then
		--force an update of the primary bank container (which is -1, in case something was moved)
		--blizzard doesn't send a bag update for the -1 bank slot for some reason
		--true = forces a rollupdate to scan entire bag
		SaveBag('bank', BANK_CONTAINER, true)
	end
	
	--save the bag data in case it was changed
	SaveBag(bagname, bagid, false)

	--now save the item information in the bag
	for slot = 1, GetBagSize(bagid) do
		SaveItem(bagname, bagid, slot)
	end
end

local function SaveEquipment()
	--reset our tooltip data since we scanned new items (we want current data not old)
	lastItem = nil
	lastDisplayed = {}
	
	--start at 1, 0 used to be the old range slot (not needed anymore)
	for slot = 1, NUM_EQUIPMENT_SLOTS do
		local link = GetInventoryItemLink('player', slot)
		local index = GetTag('equip', 0, slot)

		if link then
			local linkItem = ToShortLink(link)
			local count =  GetInventoryItemCount('player', slot)
			count = count > 1 and count or nil

			if (linkItem and count) then
					BS_DB[index] = format('%s,%d', linkItem, count)
			else
				BS_DB[index] = linkItem
			end
		else
			BS_DB[index] = nil
		end
	end
end

local function ScanEntireBank()
	--scan the primary Bank Bag -1, for some reason Blizzard never sends updates on it
	SaveBag('bank', BANK_CONTAINER, true)
	--NUM_BAG_SLOTS+1 to NUM_BAG_SLOTS+NUM_BANKBAGSLOTS are your bank bags 
	for i = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		SaveBag('bank', i, true)
	end
end

local function ScanMailbox()
	--this is to prevent buffer overflow from the CheckInbox() function calling ScanMailbox too much :)
	if isCheckingMail then return end
	isCheckingMail = true

	 --used to initiate mail check from server, for some reason GetInboxNumItems() returns zero sometimes
	 --even though the user has mail in the mailbox.  This can be attributed to lag.
	CheckInbox()

	local mailCount = 0
	local numInbox = GetInboxNumItems()

	--scan the inbox
	if (numInbox > 0) then
		for mailIndex = 1, numInbox do
			for i=1, ATTACHMENTS_MAX_RECEIVE do
				local name, itemTexture, count, quality, canUse = GetInboxItem(mailIndex, i)
				local link = GetInboxItemLink(mailIndex, i)
				
				if name and link then
					mailCount = mailCount + 1
					
					local index = GetTag('mailbox', 0, mailCount)
					local linkItem = ToShortLink(link)
					
					if (count) then
						BS_DB[index] = format('%s,%d', linkItem, count)
					else
						BS_DB[index] = linkItem
					end
				end
				
			end
		end
	end
	
	--lets avoid looping through data if we can help it
	--store the amount of mail at our mailbox for comparison
	local bChk = GetTag('bd', 'inbox', 0)

	if BS_DB[bChk] then
		local bVal = BS_DB[bChk]
		--only delete if our current mail count is smaller then our stored amount
		if mailCount < bVal then
			for x = (mailCount + 1), bVal do
				local delIndex = GetTag('mailbox', 0, x)
				if BS_DB[delIndex] then BS_DB[delIndex] = nil end
			end
		end
	end
	
	--store our mail count regardless
	BS_DB[bChk] = mailCount

	isCheckingMail = false
end

local function ScanAuctionHouse()
	local ahCount = 0
	local numActiveAuctions = GetNumAuctionItems("owner")
	
	--scan the auction house
	if (numActiveAuctions > 0) then
		for ahIndex = 1, numActiveAuctions do
			local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highBidder, owner, saleStatus  = GetAuctionItemInfo("owner", ahIndex)
			if name then
				local link = GetAuctionItemLink("owner", ahIndex)
				local timeLeft = GetAuctionItemTimeLeft("owner", ahIndex)
				
				if link and timeLeft then
					ahCount = ahCount + 1
					local index = GetTag('auction', 0, ahCount)
					local linkItem = ToShortLink(link)
					if linkItem then
						count = (count or 1)
						BS_DB[index] = format('%s,%s,%s', linkItem, count, timeLeft)
					else
						BS_DB[index] = linkItem
					end
				end
			end
		end
	end
	
	--check for stragglers from previous auction house count
	local bChk = GetTag('bd', 'auction_count', 0)

	if BS_DB[bChk] then
		local bVal = BS_DB[bChk]
		--only delete if our current auction count is smaller then our stored amount
		if ahCount < bVal then
			for x = (ahCount + 1), bVal do
				local delIndex = GetTag('auction', 0, x)
				if BS_DB[delIndex] then BS_DB[delIndex] = nil end
			end
		end
	end
	
	--store our new auction house count
	BS_DB[bChk] = ahCount
end

--this method is global for all toons, removes expired auctions on login
local function RemoveExpiredAuctions()
	local bChk = GetTag('bd', 'auction_count', 0)
	local timestampChk = { 30*60, 2*60*60, 12*60*60, 48*60*60 }
				
	for realm, rd in pairs(S.global.BagSyncDB) do
		--realm
		for k, v in pairs(rd) do
			--users k=name, v=values
			if S.global.BagSyncDB[realm][k].AH_LastScan then --only proceed if we have an auction house time to work with
				--check to see if we even have a count
				if S.global.BagSyncDB[realm][k][bChk] then
					--we do so lets do a loop
					local bVal = S.global.BagSyncDB[realm][k][bChk]
					--do a loop through all of them and check to see if any expired
					for x = 1, bVal do
						local getIndex = GetTag('auction', 0, x)
						if S.global.BagSyncDB[realm][k][getIndex] then
							--check for expired and remove if necessary
							--it's okay if the auction count is showing more then actually stored, it's just used as a means
							--to scan through all our items.  Even if we have only 3 and the count is 6 it will just skip the last 3.
							local dblink, dbcount, dbtimeleft = strsplit(',', S.global.BagSyncDB[realm][k][getIndex])
							
							--only proceed if we have everything to work with, otherwise this auction data is corrupt
							if dblink and dbcount and dbtimeleft then
								if tonumber(dbtimeleft) < 1 or tonumber(dbtimeleft) > 4 then dbtimeleft = 4 end --just in case
								--now do the time checks
								local diff = time() - S.global.BagSyncDB[realm][k].AH_LastScan 
								if diff > timestampChk[tonumber(dbtimeleft)] then
									--technically this isn't very realiable.  but I suppose it's better the  nothing
									S.global.BagSyncDB[realm][k][getIndex] = nil
								end
							else
								--it's corrupt delete it
								S.global.BagSyncDB[realm][k][getIndex] = nil
							end
						end
					end
				end
			end
		end
	end
	
end

------------------------
--      Tooltip!      --
-- (Special thanks to tuller)
------------------------

function BagSync:resetTooltip()
	lastDisplayed = {}
	lastItem = nil
end

local function CountsToInfoString(invCount, bankCount, equipCount, mailboxCount, auctionCount)
	local info
	local total = invCount + bankCount + equipCount + mailboxCount + auctionCount

	if invCount > 0 then
		info = L["Bags: %d"]:format(invCount)
	end

	if bankCount > 0 then
		local count = L["Bank: %d"]:format(bankCount)
		if info then
			info = strjoin(', ', info, count)
		else
			info = count
		end
	end

	if equipCount > 0 then
		local count = L["Equipped: %d"]:format(equipCount)
		if info then
			info = strjoin(', ', info, count)
		else
			info = count
		end
	end

	if mailboxCount > 0 then
		local count = L["Mailbox: %d"]:format(mailboxCount)
		if info then
			info = strjoin(', ', info, count)
		else
			info = count
		end
	end
	
	if auctionCount > 0 then
		local count = L["AH: %d"]:format(auctionCount)
		if info then
			info = strjoin(', ', info, count)
		else
			info = count
		end
	end
	
	if info then
		if total and not(total == invCount or total == bankCount or total == equipCount or total == mailboxCount or total == auctionCount) then
			local totalStr = format(SILVER, total)
			return totalStr .. format(SILVER, format(' (%s)', info))
		end
		return format(SILVER, info)
	end
end

--sort by key element rather then value
local function pairsByKeys (t, f)
	local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
	return iter
end

local function rgbhex(r, g, b)
  if type(r) == "table" then
	if r.r then
	  r, g, b = r.r, r.g, r.b
	else
	  r, g, b = unpack(r)
	end
  end
  return string.format("|cff%02x%02x%02x", (r or 1) * 255, (g or 1) * 255, (b or 1) * 255)
end


local function getNameColor(sName, sClass)
	return format(MOSS, sName)
end

local function AddOwners(frame, link)
	frame.BagSyncShowOnce = nil

	--if we can't convert the item link then lets just ignore it altogether
	local itemLink = ToShortLink(link)
	if not itemLink then
		frame:Show()
		return
	end
	
	--ignore the hearthstone
	if itemLink and tonumber(itemLink) and tonumber(itemLink) == 6948 then
		frame:Show()
		return
	end

	--lag check (check for previously displayed data) if so then display it
	if lastItem and itemLink and itemLink == lastItem then
		for i = 1, #lastDisplayed do
			local ename, ecount  = strsplit('@', lastDisplayed[i])
			if ename and ecount then
				frame:AddDoubleLine(ename, ecount)
			end
		end
		frame:Show()
		return
	end
	
	--reset our last displayed
	lastDisplayed = {}
	lastItem = itemLink
	
	--this is so we don't scan the same guild multiple times
	local previousGuilds = {}
	local grandTotal = 0
	
	--loop through our characters
	for k, v in pairs(S.global.BagSyncDB[currentRealm]) do

		local infoString
		local invCount, bankCount, equipCount, mailboxCount, auctionCount = 0, 0, 0, 0, 0
		local pFaction = v.faction or playerFaction --just in case ;) if we dont know the faction yet display it anyways
		
		--check if we should show both factions or not
		if enableFaction or pFaction == playerFaction then

			--now count the stuff for the user
			for q, r in pairs(v) do
				if itemLink then
					local dblink, dbcount = strsplit(',', r)
					if dblink then
						if string.find(q, 'bank') and dblink == itemLink then
							bankCount = bankCount + (dbcount or 1)
						elseif string.find(q, 'bag') and dblink == itemLink then
							invCount = invCount + (dbcount or 1)
						elseif string.find(q, 'equip') and dblink == itemLink then
							equipCount = equipCount + (dbcount or 1)
						elseif string.find(q, 'mailbox') and dblink == itemLink then
							mailboxCount = mailboxCount + (dbcount or 1)
						elseif string.find(q, 'auction') and dblink == itemLink then
							auctionCount = auctionCount + (dbcount or 1)
						end
					end
				end
			end

			--get class for the unit if there is one
			local pClass = v.class or nil
		
			infoString = CountsToInfoString(invCount, bankCount, equipCount, mailboxCount, auctionCount)
			grandTotal = grandTotal + invCount + bankCount + equipCount + mailboxCount + auctionCount

			if infoString and infoString ~= '' then
				frame:AddDoubleLine(getNameColor(k, pClass), infoString)
				table.insert(lastDisplayed, getNameColor(k or 'Unknown', pClass).."@"..(infoString or 'unknown'))
			end

		end
		
	end
		
	--show grand total if we have something
	--don't show total if there is only one item
	if showTotal and grandTotal > 0 and getn(lastDisplayed) > 1 then
		frame:AddDoubleLine(format(TTL_C, L["Total:"]), format(SILVER, grandTotal))
		table.insert(lastDisplayed, format(TTL_C, L["Total:"]).."@"..format(SILVER, grandTotal))
	end

	frame:Show()
end

--Thanks to Aranarth from wowinterface.  Replaced HookScript with insecure hooks
local orgTipSetItem = {}
local orgTipOnUpdate = {}

local function Tip_OnSetItem(self, ...)
	orgTipSetItem[self](self, ...)
	local _, itemLink = self:GetItem()
	if itemLink and GetItemInfo(itemLink) then
		local itemName = GetItemInfo(itemLink)
		if not self.BagSyncThrottle then self.BagSyncThrottle = GetTime() end
		if not self.BagSyncPrevious then self.BagSyncPrevious = itemName end
		if not self.BagSyncShowOnce and self:GetName() == "GameTooltip" then self.BagSyncShowOnce = true end

		if itemName ~= self.BagSyncPrevious then
			self.BagSyncPrevious = itemName
			self.BagSyncThrottle = GetTime()
		end

		if self:GetName() ~= "GameTooltip" or (GetTime() - self.BagSyncThrottle) >= 0.05 then
			self.BagSyncShowOnce = nil
			return AddOwners(self, itemLink)
		end
	end
end

local function Tip_OnUpdate(self, ...)
	orgTipOnUpdate[self](self, ...)
	if self:GetName() == "GameTooltip" and self.BagSyncShowOnce and self.BagSyncThrottle and (GetTime() - self.BagSyncThrottle) >= 0.05 then
		local _, itemLink = self:GetItem()
		self.BagSyncShowOnce = nil
		if itemLink then
			return AddOwners(self, itemLink)
		end
	end
end

for _, tip in next, { GameTooltip, ItemRefTooltip } do
	
	orgTipSetItem[tip] = tip:GetScript"OnTooltipSetItem"
	tip:SetScript("OnTooltipSetItem", Tip_OnSetItem)
	
	if tip == ItemRefTooltip then
		orgTipOnUpdate[tip] = tip.UpdateTooltip
		tip.UpdateTooltip = Tip_OnUpdate
	else
		orgTipOnUpdate[tip] = tip:GetScript"OnUpdate"
		tip:SetScript("OnUpdate", Tip_OnUpdate)
	end
end

------------------------------
--    LOGIN HANDLER         --
------------------------------

function BagSync:PLAYER_LOGIN()
	
	--load our player info after login
	currentPlayer = UnitName('player')
	currentRealm = GetRealmName()
	playerClass = select(2, UnitClass("player"))
	playerFaction = UnitFactionGroup("player")

	--initiate the db
	StartupDB()

	--save all inventory data, including backpack(0)
	for i = BACKPACK_CONTAINER, BACKPACK_CONTAINER + NUM_BAG_SLOTS do
		SaveBag('bag', i, true)
	end

	--force an equipment scan
	SaveEquipment()
	
	--clean up old auctions
	RemoveExpiredAuctions()
	
	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('BANKFRAME_CLOSED')
	self:RegisterEvent('BAG_UPDATE')
	self:RegisterEvent('UNIT_INVENTORY_CHANGED')
	if enableMailbox then
		self:RegisterEvent('MAIL_SHOW')
		self:RegisterEvent('MAIL_INBOX_UPDATE')
	end
	if enableAuction then 
		self:RegisterEvent("AUCTION_HOUSE_SHOW")
		self:RegisterEvent("AUCTION_OWNED_LIST_UPDATE")
	end
end

------------------------------
--      BAG UPDATES  	    --
------------------------------

function BagSync:BAG_UPDATE(event, bagid)
	--The new token bag or token currency tab has a bag number of -4, lets ignore this bag when new tokens are added
	--http://www.wowwiki.com/API_TYPE_bagID
	if bagid == -4 or bagid == -2 then return end --dont do tokens or keyring
	--if not token bag then proceed
	if not(bagid == BANK_CONTAINER or bagid > NUM_BAG_SLOTS) or atBank then
		OnBagUpdate(bagid)
	end
end

function BagSync:UNIT_INVENTORY_CHANGED(event, unit)
	if unit == 'player' then
		SaveEquipment()
	end
end

------------------------------
--      BANK	            --
------------------------------

function BagSync:BANKFRAME_OPENED()
	atBank = true
	ScanEntireBank()
end

function BagSync:BANKFRAME_CLOSED()
	atBank = false
end

------------------------------
--      MAILBOX  	        --
------------------------------

function BagSync:MAIL_SHOW()
	if isCheckingMail then return end
	if not enableMailbox then return end
	ScanMailbox()
end

function BagSync:MAIL_INBOX_UPDATE()
	if isCheckingMail then return end
	if not enableMailbox then return end
	ScanMailbox()
end

------------------------------
--     AUCTION HOUSE        --
------------------------------

function BagSync:AUCTION_HOUSE_SHOW()
	if not enableAuction then return end
	ScanAuctionHouse()
end

function BagSync:AUCTION_OWNED_LIST_UPDATE()
	if not enableAuction then return end
	BS_DB.AH_LastScan = time()
	ScanAuctionHouse()
end

S:RegisterModule(BagSync:GetName())