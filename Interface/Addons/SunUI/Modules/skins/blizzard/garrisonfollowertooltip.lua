local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local function restyleGarrisonFollowerTooltipTemplate(frame)
		for i = 1, 9 do
			select(i, frame:GetRegions()):Hide()
		end

		A:CreateBD(frame)
	end

	local function restyleGarrisonFollowerAbilityTooltipTemplate(frame)
		for i = 1, 9 do
			select(i, frame:GetRegions()):Hide()
		end

		local icon = frame.Icon

		icon:SetTexCoord(.08, .92, .08, .92)
		A:CreateBG(icon)

		A:CreateBD(frame)
	end

	restyleGarrisonFollowerTooltipTemplate(GarrisonFollowerTooltip)
	restyleGarrisonFollowerAbilityTooltipTemplate(GarrisonFollowerAbilityTooltip)

	restyleGarrisonFollowerTooltipTemplate(FloatingGarrisonFollowerTooltip)
	A:ReskinClose(FloatingGarrisonFollowerTooltip.CloseButton)

	restyleGarrisonFollowerAbilityTooltipTemplate(FloatingGarrisonFollowerAbilityTooltip)
	A:ReskinClose(FloatingGarrisonFollowerAbilityTooltip.CloseButton)

	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", function(tooltipFrame)

		-- Abilities

		if tooltipFrame.numAbilitiesStyled == nil then
			tooltipFrame.numAbilitiesStyled = 1
		end

		local numAbilitiesStyled = tooltipFrame.numAbilitiesStyled

		local abilities = tooltipFrame.Abilities

		local ability = abilities[numAbilitiesStyled]
		while ability do
			local icon = ability.Icon

			icon:SetTexCoord(.08, .92, .08, .92)
			A:CreateBG(icon)

			numAbilitiesStyled = numAbilitiesStyled + 1
			ability = abilities[numAbilitiesStyled]
		end

		tooltipFrame.numAbilitiesStyled = numAbilitiesStyled

		-- Traits

		if tooltipFrame.numTraitsStyled == nil then
			tooltipFrame.numTraitsStyled = 1
		end

		local numTraitsStyled = tooltipFrame.numTraitsStyled

		local traits = tooltipFrame.Traits

		local trait = traits[numTraitsStyled]
		while trait do
			local icon = trait.Icon

			icon:SetTexCoord(.08, .92, .08, .92)
			A:CreateBG(icon)

			numTraitsStyled = numTraitsStyled + 1
			trait = traits[numTraitsStyled]
		end

		tooltipFrame.numTraitsStyled = numTraitsStyled
	end)
end

A:RegisterSkin("SunUI", LoadSkin)