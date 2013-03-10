local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_ChallengesUI"] = function()
		ChallengesFrameInset:DisableDrawLayer("BORDER")
		ChallengesFrameInsetBg:Hide()
		ChallengesFrameDetails.bg:Hide()
		select(2, ChallengesFrameDetails:GetRegions()):Hide()
		select(9, ChallengesFrameDetails:GetRegions()):Hide()
		select(10, ChallengesFrameDetails:GetRegions()):Hide()
		select(11, ChallengesFrameDetails:GetRegions()):Hide()
		ChallengesFrameLeaderboard:GetRegions():Hide()

		S.Reskin(ChallengesFrameLeaderboard)

		local bg = CreateFrame("Frame", nil, ChallengesFrameDetails)
		bg:Point("TOPLEFT", 1, -73)
		bg:Size(332, 49)
		bg:SetFrameLevel(ChallengesFrameDetails:GetFrameLevel())
		S.CreateBD(bg, .25)

		ChallengesFrameDungeonButton1:Point("TOPLEFT", ChallengesFrame, "TOPLEFT", 8, -83)

		for i = 1, 9 do
			local bu = ChallengesFrame["button"..i]
			S.CreateBD(bu, .25)
			bu:SetHighlightTexture("")
			bu.selectedTex:SetTexture(DB.media.backdrop)
			bu.selectedTex:SetAlpha(.2)
			bu.selectedTex:Point("TOPLEFT", 1, -1)
			bu.selectedTex:Point("BOTTOMRIGHT", -1, 1)
		end

		for i = 1, 3 do
			local rewardsRow = ChallengesFrame["RewardRow"..i]
			for j = 1, 2 do
				local bu = rewardsRow["Reward"..j]

				bu.Icon:SetTexCoord(.08, .92, .08, .92)
				S.CreateBG(bu.Icon)
			end
		end
end