------------------------------------------------------------
-- QuestPrice.lua
--
-- Abin
-- 2010/12/10
------------------------------------------------------------

local _G = _G
local QuestLogFrame = QuestLogFrame
local pcall = pcall
local GetQuestLogItemLink = GetQuestLogItemLink
local GetQuestItemLink = GetQuestItemLink
local select = select
local GetItemInfo = GetItemInfo
local MoneyFrame_SetType = MoneyFrame_SetType
local MoneyFrame_Update = MoneyFrame_Update

local function QuestPriceFrame_OnUpdate(self)
	local button = self.button
	if not button.rewardType or button.rewardType == "item" then
		local result, link = pcall(QuestLogFrame:IsShown() and GetQuestLogItemLink or GetQuestItemLink, button.type, button:GetID())
		if not result then
			link = nil
		end

		if link ~= self.link then
			self.link = link
			local price = link and select(11, GetItemInfo(link))
			if price and price > 0 then
				MoneyFrame_Update(self, price)
				self:SetAlpha(1)
			else
				self:SetAlpha(0)
			end
		end
	end
end

local function CreatePriceFrame(name)
	local button = _G[name]
	if button then
		local frame = CreateFrame("Frame", name.."QuestPriceFrame", button, "SmallMoneyFrameTemplate")
		frame:SetPoint("BOTTOMRIGHT", 10, 0)
		frame:Raise()
		frame:SetScale(0.85)
		frame:SetAlpha(0)
		MoneyFrame_SetType(frame, "STATIC")
		frame.button = button
		frame:SetScript("OnShow", QuestPriceFrame_OnUpdate)
		frame:SetScript("OnUpdate", QuestPriceFrame_OnUpdate)
	end
end

local i
for i = 1, 10 do
	CreatePriceFrame("QuestInfoItem"..i) -- 3.35/CTM
	CreatePriceFrame("QuestLogItem"..i) -- CWLK 3.22
	CreatePriceFrame("QuestDetailItem"..i) -- CWLK 3.22
	CreatePriceFrame("QuestRewardItem"..i) -- CWLK 3.22
end