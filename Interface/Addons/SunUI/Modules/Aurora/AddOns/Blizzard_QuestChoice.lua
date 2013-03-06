local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_QuestChoice"] = function()
	for i = 1, 18 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	S.CreateBD(QuestChoiceFrame)
	S.CreateSD(QuestChoiceFrame)
	S.Reskin(QuestChoiceFrame.Option1.OptionButton)
	S.Reskin(QuestChoiceFrame.Option2.OptionButton)
	S.ReskinClose(QuestChoiceFrame.CloseButton)
end