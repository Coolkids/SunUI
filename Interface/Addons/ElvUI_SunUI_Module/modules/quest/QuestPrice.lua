------------------------------------------------------------
-- QuestPrice.lua
--
-- Abin
-- 2010/12/10
------------------------------------------------------------
local E, L, V, P, G = unpack(ElvUI)
local _G = _G
local QuestLogFrame = QuestMapDetailsScrollFrame
local pcall = pcall
local GetQuestLogItemLink = GetQuestLogItemLink
local GetQuestItemLink = GetQuestItemLink
local select = select
local GetItemInfo = GetItemInfo
local MoneyFrame_SetType = MoneyFrame_SetType
local MoneyFrame_Update = MoneyFrame_Update

local function QuestPriceFrame_OnUpdate(self)
	local button = self.button
	if not button.objectType or button.objectType == "item" then
		local result, link = pcall(QuestLogFrame:IsShown() and GetQuestLogItemLink or GetQuestItemLink, button.type, button:GetID())
		if not result then
			link = nil
		end
		--print("1"..link)
		if link ~= self.link then
			--print("2"..link)
			self.link = link
			local price = link and select(11, GetItemInfo(link))
			local quality = link and select(3, GetItemInfo(link))
			if price and price > 0 then
				MoneyFrame_Update(self, price)
				self:SetAlpha(1)
			else
				self:SetAlpha(0)
			end
			if quality and quality > 1 then
				if not button.bbg then
					local A = S:GetModule("Skins")
					button.bbg = A:CreateBG(button.Icon, 1)
				end
				button.bbg:SetVertexColor(GetItemQualityColor(quality))
			end
		end
	end
end

local function CreatePriceFrame(name)
	local button = _G[name]
	--S:Print(name, button)

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
--任务追踪打开页面
QuestLogPopupDetailFrame:HookScript("OnShow", function()
	local i
	for i = 1, 10 do
		--CreatePriceFrame("QuestInfoItem"..i) -- 3.35/CTM
		--CreatePriceFrame("QuestLogItem"..i) -- CWLK 3.22
		--CreatePriceFrame("QuestDetailItem"..i) -- CWLK 3.22
		--CreatePriceFrame("QuestRewardItem"..i) -- CWLK 3.22
		CreatePriceFrame("QuestInfoRewardsFrameQuestInfoItem"..i) -- WOD 6.0.2
	end
end)
--L键打开页面
hooksecurefunc("QuestInfo_GetRewardButton", function()
	local i
	for i = 1, 10 do
		--CreatePriceFrame("QuestInfoItem"..i) -- 3.35/CTM
		--CreatePriceFrame("QuestLogItem"..i) -- CWLK 3.22
		--CreatePriceFrame("QuestDetailItem"..i) -- CWLK 3.22
		--CreatePriceFrame("QuestRewardItem"..i) -- CWLK 3.22
		CreatePriceFrame("MapQuestInfoRewardsFrameQuestInfoItem"..i) -- WOD 6.0.2
		CreatePriceFrame("MapQuestInfoRewardsFrameQuestInfoItem"..i) -- WOD 6.0.2
	end
end)
