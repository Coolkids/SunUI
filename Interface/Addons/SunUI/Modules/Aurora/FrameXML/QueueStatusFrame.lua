local S, L, DB, _, C = unpack(select(2, ...))

local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

tinsert(DB.AuroraModules["SunUI"], function()
	for i = 1, 9 do
		select(i, QueueStatusFrame:GetRegions()):Hide()
	end

	S.CreateBD(QueueStatusFrame)

	hooksecurefunc("QueueStatusFrame_GetEntry", function(self, entryIndex)
		local entry = self.StatusEntries[entryIndex]

		if not entry.styled then
			for _, roleButton in pairs({entry.HealersFound, entry.TanksFound, entry.DamagersFound}) do
				roleButton.Texture:SetTexture(DB.media.roleIcons)
				roleButton.Cover:SetTexture(DB.media.roleIcons)

				local left = roleButton:CreateTexture(nil, "OVERLAY")
				left:SetWidth(1)
				left:SetTexture(DB.media.backdrop)
				left:SetVertexColor(0, 0, 0)
				left:Point("TOPLEFT", 5, -3)
				left:Point("BOTTOMLEFT", 5, 6)

				local right = roleButton:CreateTexture(nil, "OVERLAY")
				right:SetWidth(1)
				right:SetTexture(DB.media.backdrop)
				right:SetVertexColor(0, 0, 0)
				right:Point("TOPRIGHT", -4, -3)
				right:Point("BOTTOMRIGHT", -4, 6)

				local top = roleButton:CreateTexture(nil, "OVERLAY")
				top:SetHeight(1)
				top:SetTexture(DB.media.backdrop)
				top:SetVertexColor(0, 0, 0)
				top:Point("TOPLEFT", 5, -3)
				top:Point("TOPRIGHT", -4, -3)

				local bottom = roleButton:CreateTexture(nil, "OVERLAY")
				bottom:SetHeight(1)
				bottom:SetTexture(DB.media.backdrop)
				bottom:SetVertexColor(0, 0, 0)
				bottom:Point("BOTTOMLEFT", 5, 6)
				bottom:Point("BOTTOMRIGHT", -4, 6)
			end

			for i = 1, LFD_NUM_ROLES do
				local roleIcon = entry["RoleIcon"..i]

				roleIcon:SetTexture(DB.media.roleIcons)

				entry["RoleIconBorders"..i] = {}
				local borders = entry["RoleIconBorders"..i]

				local left = entry:CreateTexture(nil, "OVERLAY")
				left:SetWidth(1)
				left:SetTexture(DB.media.backdrop)
				left:SetVertexColor(0, 0, 0)
				left:Point("TOPLEFT", roleIcon, 2, -2)
				left:Point("BOTTOMLEFT", roleIcon, 2, 3)
				tinsert(borders, left)

				local right = entry:CreateTexture(nil, "OVERLAY")
				right:SetWidth(1)
				right:SetTexture(DB.media.backdrop)
				right:SetVertexColor(0, 0, 0)
				right:SetPoint("TOPRIGHT", roleIcon, -2, -2)
				right:SetPoint("BOTTOMRIGHT", roleIcon, -2, 3)
				tinsert(borders, right)

				local top = entry:CreateTexture(nil, "OVERLAY")
				top:SetHeight(1)
				top:SetTexture(DB.media.backdrop)
				top:SetVertexColor(0, 0, 0)
				top:SetPoint("TOPLEFT", roleIcon, 2, -2)
				top:SetPoint("TOPRIGHT", roleIcon, -2, -2)
				tinsert(borders, top)

				local bottom = entry:CreateTexture(nil, "OVERLAY")
				bottom:SetHeight(1)
				bottom:SetTexture(DB.media.backdrop)
				bottom:SetVertexColor(0, 0, 0)
				bottom:SetPoint("BOTTOMLEFT", roleIcon, 2, 3)
				bottom:SetPoint("BOTTOMRIGHT", roleIcon, -2, 3)
				tinsert(borders, bottom)
			end

			entry.styled = true
		end
	end)

	hooksecurefunc("QueueStatusEntry_SetMinimalDisplay", function(entry)
		for i = 1, LFD_NUM_ROLES do
			for _, border in pairs(entry["RoleIconBorders"..i]) do
				border:Hide()
			end
		end
	end)

	hooksecurefunc("QueueStatusEntry_SetFullDisplay", function(entry)
		for i = 1, LFD_NUM_ROLES do
			local shown = entry["RoleIcon"..i]:IsShown()

			for _, border in pairs(entry["RoleIconBorders"..i]) do
				border:SetShown(shown)
			end
		end
	end)
end)