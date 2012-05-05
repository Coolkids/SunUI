--[[
The idea is to avoid wasting any resources if we're not in a guild.  The
IsInGuild() check fails if done at load time, but will work a few seconds
later.  Blizzard has a function which runs 5 seconds after load (which
happens to be the function that triggers a G_R_U, but that's coincidental)
so hook that function and check then.

If the post-loadscreen delay before re-enabling roster selection is too
long or too short, twiddle the SetDuration argument.

farmbuyer
]]

AutoCompleteInfoDelayer:HookScript("OnFinished", function()

	if not IsInGuild() then return end

	local frame = CreateFrame("Frame", "GuildRosterSelectedFixFrame")
	local zoning = false

	frame:SetScript("OnEvent", function (self, event)
		if event == "PLAYER_LEAVING_WORLD" then
			--print"PLW"
			zoning = true

		elseif event == "PLAYER_ENTERING_WORLD" then
			--print"PEW"
			self.group:Play()

		elseif event == "GUILD_ROSTER_UPDATE" then
			--print"SETUP"
			self:UnregisterEvent("GUILD_ROSTER_UPDATE")
			self:RegisterEvent("PLAYER_LEAVING_WORLD")
			self:RegisterEvent("PLAYER_ENTERING_WORLD")

			self.group = self:CreateAnimationGroup()
			self.anim = self.group:CreateAnimation("Animation")
			self.anim:SetDuration(8)
			self.anim:SetOrder(1)
			self.group:SetLooping("NONE")
			self.group:SetScript("OnFinished", function()
				--print"FINISHED"
				zoning = false
			end)

			local real_GGRS = _G.GetGuildRosterSelection
			function _G.GetGuildRosterSelection()
				if zoning then
					--print"AVOIDING"
					return 0
				else
					return real_GGRS()
				end
			end

		end
	end)

	frame:RegisterEvent("GUILD_ROSTER_UPDATE")
end)

-- vim:noet
