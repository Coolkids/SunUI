local addon, ns = ...
local S, C, L, DB = unpack(select(2, ...))
local cast = CreateFrame("Frame")  
  -- special thanks to Allez for coming up with this solution
local channelingTicks = {
	-- warlock
	[GetSpellInfo(689)] = 3, -- "Drain Life"
	[GetSpellInfo(5740)] = 4, -- "Rain of Fire"
	-- druid
	[GetSpellInfo(44203)] = 4, -- "Tranquility"
	[GetSpellInfo(16914)] = 10, -- "Hurricane"
	-- priest
	[GetSpellInfo(15407)] = 3, -- "Mind Flay"
	[GetSpellInfo(48045)] = 5, -- "Mind Sear"
	[GetSpellInfo(47540)] = 2, -- "Penance"
	-- mage
	[GetSpellInfo(5143)] = 5, -- "Arcane Missiles"
	[GetSpellInfo(10)] = 5, -- "Blizzard"
	[GetSpellInfo(12051)] = 4, -- "Evocation"
}
local ticks = {}

cast.setBarTicks = function(castBar, ticknum)
	if ticknum and ticknum > 0 then
		local delta = castBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = castBar:CreateTexture(nil, 'OVERLAY')
				ticks[k]:SetTexture(DB.bar_texture)
				ticks[k]:SetVertexColor(0.8, 0.6, 0.6)
				ticks[k]:SetWidth(4)
				ticks[k]:SetHeight(castBar:GetHeight())
			end
			ticks[k]:ClearAllPoints()
			ticks[k]:SetPoint("CENTER", castBar, "LEFT", delta * k, 0 )
			ticks[k]:Show()
		end
	else
		for k, v in pairs(ticks) do
			v:Hide()
		end
	end
end

cast.OnCastbarUpdate = function(self, elapsed)
if not self.Lag then self.Lag = 0 end  ------------------------------------AND THIS SDALKSJD:LKJASLDKJA:LSKDJ:LKASJD:
if GetNetStats() == 0 then return end -- test
	local currentTime = GetTime()
	if self.casting or self.channeling then
		local parent = self:GetParent()
		local duration = self.casting and self.duration + elapsed or self.duration - elapsed
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end
		if parent.unit == 'player' then
			if self.delay ~= 0 then
				self.Time:SetFormattedText('%.1f | |cffff0000%.1f|r', duration, self.casting and self.max + self.delay or self.max - self.delay)
			elseif self.Lag then -- to avoid errors with the bars that actually have no Lag display
				self.Time:SetFormattedText('%.1f | %.1f', duration, self.max)
				self.Lag:SetFormattedText("%d ms", self.SafeZone.timeDiff * 1000)
			end
		else
			self.Time:SetFormattedText('%.1f | %.1f', duration, self.casting and self.max + self.delay or self.max - self.delay)
		end
		self.duration = duration
		self:SetValue(duration)
		self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
	elseif self.fadeOut then
		self.Spark:Hide()
		local alpha = self:GetAlpha() - 0.02
		if alpha > 0 then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end

cast.OnCastSent = function(self, event, unit, spell, rank)
	if self.unit ~= unit or not self.Castbar.SafeZone then return end
	self.Castbar.SafeZone.sendTime = GetTime()
end

cast.PostCastStart = function(self, unit, name, rank, text)
	self:SetAlpha(1.0)
	self.Spark:Show()
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	if unit == 'vehicle' then 
		self.SafeZone:Hide()
		self.Lag:Hide()
	elseif unit == 'player' then
		if GetNetStats() == 0 then return end -- test
		local sf = self.SafeZone 
		if not sf then return end -- fix for swapped vehicles' cast bars when channeling
		if not sf.sendTime then sf.sendTime = GetTime() end
		sf.timeDiff = GetTime() - sf.sendTime
		sf.timeDiff = sf.timeDiff > self.max and self.max or sf.timeDiff
		sf:SetWidth(self:GetWidth() * sf.timeDiff / self.max)
		sf:Show()
		if not UnitInVehicle("player") then sf:Show() else sf:Hide() end
		if self.casting then
			cast.setBarTicks(self, 0)
		else
			local spell = UnitChannelInfo(unit)
			self.channelingTicks = channelingTicks[spell] or 0
			cast.setBarTicks(self, self.channelingTicks)
		end
	elseif (unit == "target" or unit == "focus" or (unit and unit:find("boss%d"))) and self.interrupt then
		self:SetStatusBarColor(1.0, 0.09, 0, 1)
	else
		self:SetStatusBarColor(.3, .45, .65, 1)
	end
end

cast.PostCastStop = function(self, unit, name, rank, castid)
	if not self.fadeOut then 
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.max)
	self:Show()
end

cast.PostChannelStop = function(self, unit, name, rank)
	cast.setBarTicks(self, 0)
	self.fadeOut = true
	self:SetValue(0)
	self:Show()
end

cast.PostCastFailed = function(self, event, unit, name, rank, castid)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	if not self.fadeOut then
		self.fadeOut = true
	end
	self:Show()
end
  --hand the lib to the namespace for further usage
  ns.cast = cast