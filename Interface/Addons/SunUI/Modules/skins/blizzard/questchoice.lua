local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	for i = 1, 15 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	for i = 17, 19 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	for i = 1, 2 do
		local option = QuestChoiceFrame["Option"..i]
		local rewards = option.Rewards
		local icon = rewards.Item.Icon
		local currencies = rewards.Currencies

		option.OptionText:SetTextColor(.9, .9, .9)
		rewards.Item.Name:SetTextColor(1, 1, 1)

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetDrawLayer("BACKGROUND", 1)
		A:CreateBG(icon)

		for j = 1, 3 do
			local cu = currencies["Currency"..j]

			cu.Icon:SetTexCoord(.08, .92, .08, .92)
			A:CreateBG(cu.Icon)
		end
	end

	A:CreateBD(QuestChoiceFrame)
	A:CreateSD(QuestChoiceFrame)
	A:Reskin(QuestChoiceFrame.Option1.OptionButton)
	A:Reskin(QuestChoiceFrame.Option2.OptionButton)
	A:ReskinClose(QuestChoiceFrame.CloseButton)
end

A:RegisterSkin("Blizzard_QuestChoice", LoadSkin)
