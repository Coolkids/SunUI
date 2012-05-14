----------------------------------------------------------------------------------------
--	AutoButton for used items(by Elv22)
----------------------------------------------------------------------------------------
local S, C, L, DB = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("AutoButton")
function Module:OnInitialize()
	if MiniDB["AutoBotton"] ~= true  then return end
	local Items = {
		39213,	-- 大型爆盐炸弹 (征服之岛)
		46847,	-- 爆盐炸弹 (征服之岛)
		47030,	-- 巨型爆盐炸弹 (征服之岛)
		42986,	-- RP-GG导弹 (冬拥湖)
		37860,	-- 红玉精华 (魔环)
		37815,	-- 翡翠精华 (魔环)
		37859,	-- 琥珀精华 (魔环)
		46029,	-- 磁核 (奥杜尔)
		38689,	-- 小鸡网 (日常)
		63351,	-- 塔赫莱特王朝之槌 (日常)
		52507,	-- 星尘2号 (日常)
		69240,	-- 魔法药膏 (日常)
		69235,	-- 狼的尖牙 (日常)
		62829,  -- 磁性废料收集器 (日常)
		71978,	-- 暗月绷带 (日常)
		45072,	-- 鲜艳的彩蛋 (节日)
	}
	local EquipedItems = {
		49278,	-- 地精火箭背包 (ICC)
	}
	-- Create anchor
	--local AutoButtonAnchor = CreateFrame("Frame", "AutoButtonAnchor", UIParent)
	--AutoButtonAnchor:Size(40)
	--AutoButtonAnchor:SetPoint("TOPRIGHT", WatchFrame, "TOPLEFT", -10, 0)
	
	
			
	local function AutoButtonHide()
		AutoButton:SetAlpha(0)
		if not InCombatLockdown() then
			AutoButton:EnableMouse(false)
		else
			AutoButton:RegisterEvent("PLAYER_REGEN_ENABLED")
			AutoButton:SetScript("OnEvent", function(self, event) 
				if event == "PLAYER_REGEN_ENABLED" then
					AutoButton:EnableMouse(false) 
					AutoButton:UnregisterEvent("PLAYER_REGEN_ENABLED") 
				end
			end)
		end
	end

	local function AutoButtonShow(item)
		AutoButton:SetAlpha(1)
		if not InCombatLockdown() then
			AutoButton:EnableMouse(true)
			if item then
				AutoButton:SetAttribute("item", item)
			end
		else
			AutoButton:RegisterEvent("PLAYER_REGEN_ENABLED")
			AutoButton:SetScript("OnEvent", function(self, event) 
				if event == "PLAYER_REGEN_ENABLED" then
					AutoButton:EnableMouse(true) 
					if item then
						AutoButton:SetAttribute("item", item)
					end
					AutoButton:UnregisterEvent("PLAYER_REGEN_ENABLED") 
				end
			end)
		end
	end

	local Scanner = CreateFrame("Frame")
	Scanner:RegisterEvent("BAG_UPDATE")
	Scanner:RegisterEvent("UNIT_INVENTORY_CHANGED")
	Scanner:RegisterEvent("PLAYER_ENTERING_WORLD")
	Scanner:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			-- Create anchor
			local AutoButtonAnchor = CreateFrame("Frame", "AutoButtonAnchor", UIParent)
			AutoButtonAnchor:Size(40)
			--AutoButtonAnchor:SetPoint("TOPRIGHT", WatchFrame, "TOPLEFT", -10, 0)
			MoveHandle.AutoButton = S.MakeMoveHandle(AutoButtonAnchor, "AutoButton", "AutoButton")
			-- Create button
			local AutoButton = CreateFrame("Button", "AutoButton", UIParent, "SecureActionButtonTemplate")
			AutoButton:Size(40)
			AutoButton:Point("CENTER", AutoButtonAnchor, "CENTER", 0, 0)
			AutoButton:CreateShadow()
			AutoButton:StyleButton(true)
			AutoButton:SetAttribute("type", "item")
			AutoButtonHide()

			-- Texture for our button
			AutoButton.t = AutoButton:CreateTexture(nil, "OVERLAY", nil)
			AutoButton.t:SetPoint("TOPLEFT", AutoButton, "TOPLEFT")
			AutoButton.t:SetPoint("BOTTOMRIGHT", AutoButton, "BOTTOMRIGHT")
			AutoButton.t:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			-- Count text for our button
			AutoButton.c = AutoButton:CreateFontString(nil, "OVERLAY", f)
			AutoButton.c:SetFont(DB.Font, ActionBarDB["FontSize"], "OUTLINE")
			AutoButton.c:SetTextColor(1, 1, 1, 1)
			AutoButton.c:Point("BOTTOMRIGHT", AutoButton, "BOTTOMRIGHT", -2, 0)
			AutoButton.c:SetJustifyH("RIGHT")	

			-- Cooldown
			AutoButton.Cooldown = CreateFrame("Cooldown", nil, AutoButton)
			AutoButton.Cooldown:SetPoint("TOPLEFT", AutoButton, "TOPLEFT")
			AutoButton.Cooldown:SetPoint("BOTTOMRIGHT", AutoButton, "BOTTOMRIGHT")
		else		
			AutoButtonHide()
			-- Scan bags for Item matchs
			for b = 0, NUM_BAG_SLOTS do
				for s = 1, GetContainerNumSlots(b) do
					local itemID = GetContainerItemID(b, s)
					itemID = tonumber(itemID)
					for i, Items in pairs(Items) do
						if itemID == Items then
							local itemName = GetItemInfo(itemID)
							local count = GetItemCount(itemID)
							local itemIcon = GetItemIcon(itemID)

							-- Set our texture to the item found in bags
							AutoButton.t:SetTexture(itemIcon)

							-- Get the count if there is one
							if count and count ~= 1 then
								AutoButton.c:SetText(count)
							else
								AutoButton.c:SetText("")
							end

							AutoButton:SetScript("OnUpdate", function(self, elapsed)
								local cd_start, cd_finish, cd_enable = GetContainerItemCooldown(b, s)
								CooldownFrame_SetTimer(AutoButton.Cooldown, cd_start, cd_finish, cd_enable)
							end)
							AutoButtonShow(itemName)
						end
					end
				end
			end

			-- Scan inventory for Equipment matches
			for w = 1, 19 do
				for e, EquipedItems in pairs(EquipedItems) do
					if GetInventoryItemID("player", w) == EquipedItems then
						local itemName = GetItemInfo(EquipedItems)
						local itemIcon = GetInventoryItemTexture("player", w)
						
						-- Set our texture to the item found in bags
						AutoButton.t:SetTexture(itemIcon)
						AutoButton.c:SetText("")
						
						AutoButton:SetScript("OnUpdate", function(self, elapsed)
							local cd_start, cd_finish, cd_enable = GetInventoryItemCooldown("player", w)
							CooldownFrame_SetTimer(AutoButton.Cooldown, cd_start, cd_finish, cd_enable)
						end)
						AutoButtonShow(itemName)
					end
				end
			end
		end
	end)
end