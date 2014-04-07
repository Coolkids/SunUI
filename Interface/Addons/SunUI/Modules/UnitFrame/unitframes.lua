local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")
local UF = S:GetModule("UnitFrames")
local parent, ns = ...
local oUF = ns.oUF

local class = select(2, UnitClass("player"))

local colors = setmetatable({
	power = setmetatable({
		["MANA"] = {.9, .9, .9},
		["RAGE"] = {.9, .1, .1},
		["FUEL"] = {0, 0.55, 0.5},
		["FOCUS"] = {.9, .5, .1},
		["ENERGY"] = {.9, .9, .1},
		["AMMOSLOT"] = {0.8, 0.6, 0},
		["RUNIC_POWER"] = {.1, .9, .9},
		["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
		["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})
local reactioncolours = {
	[1] = {1, .12, .24},
	[2] = {1, .12, .24},
	[3] = {1, .12, .24},
	[4] = {1, 1, 0.3},
	[5] = {0.26, 1, 0.22},
	[6] = {0.26, 1, 0.22},
	[7] = {0.26, 1, 0.22},
	[8] = {0.26, 1, 0.22},
}

--[[ Short values ]]

local siValue = function(val)
	if(val >= 1e6) then
		return format("%.2fm", val * 0.000001)
	elseif(val >= 1e4) then
		return format("%.1fk", val * 0.001)
	else
		return val
	end
end

-- [[ Update resurrection/selection name colour ]]

local updateNameColour = function(self, unit)
	if UnitIsUnit(unit, "target") then
		self.Text:SetTextColor(.1, .7, 1)
	elseif UnitIsDead(unit) then
		self.Text:SetTextColor(.6, .6, .6)
	else
		self.Text:SetTextColor(1, 1, 1)
	end
end

-- to use on child frame
local updateNameColourAlt = function(self)
	local frame = self:GetParent()
	if frame.unit then
		if UnitIsUnit(frame.unit, "target") then
			frame.Text:SetTextColor(.1, .7, 1)
		elseif UnitIsDead(frame.unit) then
			frame.Text:SetTextColor(.6, .6, .6)
		else
			frame.Text:SetTextColor(1, 1, 1)
		end
	else
		frame.Text:SetTextColor(1, 1, 1)
	end
end

--[[ Tags ]]

oUF.Tags.Methods['sunuf:health'] = function(unit)
	if(not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end

	local min, max = UnitHealth(unit), UnitHealthMax(unit)

	if unit == "player" then
		return siValue(min)
	else
		return format("|cffffffff%s|r %.0f", siValue(min), (min/max)*100)
	end
end
oUF.Tags.Events['sunuf:health'] = oUF.Tags.Events.missinghp

-- boss health requires frequent updates to work
oUF.Tags.Methods['sunuf:bosshealth'] = function(unit)
	local val = oUF.Tags.Methods['sunuf:health'](unit)
	return val or ""
end
oUF.Tags.Events['sunuf:bosshealth'] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_TARGETABLE_CHANGED"

oUF.Tags.Methods['sunuf:maxhealth'] = function(unit)
	if(not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end

	local max = UnitHealthMax(unit)
	return max
end
oUF.Tags.Events['sunuf:maxhealth'] = oUF.Tags.Events.missinghp

local function shortName(unit)
	name = UnitName(unit)
	if name and name:len() > 4 then name = name:sub(1, 4) end

	return name
end

oUF.Tags.Methods['sunuf:name'] = function(unit)
	if not UnitIsConnected(unit) then
		return "Off"
	elseif UnitIsDead(unit) then
		return "Dead"
	elseif UnitIsGhost(unit) then
		return "Ghost"
	else
		return shortName(unit)
	end
end
oUF.Tags.Events['sunuf:name'] = oUF.Tags.Events.missinghp

oUF.Tags.Methods['sunuf:missinghealth'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)

	if not UnitIsConnected(unit) then
		return "Off"
	elseif UnitIsDead(unit) then
		return "Dead"
	elseif UnitIsGhost(unit) then
		return "Ghost"
	elseif min ~= max then
		return siValue(max-min)
	else
		return shortName(unit)
	end
end
oUF.Tags.Events['sunuf:missinghealth'] = oUF.Tags.Events.missinghp

oUF.Tags.Methods['sunuf:power'] = function(unit)
	local min, max = UnitPower(unit), UnitPowerMax(unit)
	local _, class = UnitClass(unit)
	if(min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end

	return siValue(min)
end
oUF.Tags.Events['sunuf:power'] = oUF.Tags.Events.missingpp

--[[ Update health ]]

local PostUpdateHealth = function(Health, unit, min, max)
	local self = Health:GetParent()
	local r, g, b
	local reaction = reactioncolours[UnitReaction(unit, "player") or 5]

	local offline = not UnitIsConnected(unit)
	local tapped = not UnitPlayerControlled(unit) and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) and not UnitIsTappedByAllThreatList(unit)

	if tapped or offline then
		r, g, b = .6, .6, .6
	elseif unit == "pet" then
		local _, class = UnitClass("player")
		r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
	elseif UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if class then r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b else r, g, b = 1, 1, 1 end
	elseif unit:find("boss%d") then
		r, g, b = self.ColorGradient(min, max, unpack(self.colors.smooth))
	else
		r, g, b = unpack(reaction)
	end

	if unit == "target" or unit:find("arena") then
		Health.value:SetTextColor(unpack(reaction))
	end

	if UF.db.layout == 2 and not UF.db.healerClasscolours then
		if offline or UnitIsDead(unit) or UnitIsGhost(unit) then
			self.Healthdef:Hide()
		else
			self.Healthdef:SetMinMaxValues(0, max)
			self.Healthdef:SetValue(max-min)
			self.Healthdef:GetStatusBarTexture():SetVertexColor(self.ColorGradient(min, max, unpack(self.colors.smooth)))
			self.Healthdef:Show()
		end

		self.Power:SetStatusBarColor(r, g, b)
		self.Power.bg:SetVertexColor(r/2, g/2, b/2)

		if tapped or offline then
			self.gradient:SetGradientAlpha("VERTICAL", .6, .6, .6, .6, .4, .4, .4, .6)
		else
			self.gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
		end

		if self.Text then
			updateNameColour(self, unit)
		end
	else
		if UnitIsDead(unit) or UnitIsGhost(unit) then
			Health:SetValue(0)
		end
		Health:GetStatusBarTexture():SetGradient("VERTICAL", r, g, b, r/2, g/2, b/2)
	end
end

--[[ Hide Blizz frames ]]
function UF:hideBlizzframes()
	if IsAddOnLoaded("Blizzard_CompactRaidFrames") then
		CompactRaidFrameManager:SetParent(S.HiddenFrame)
		CompactUnitFrameProfiles:UnregisterAllEvents()
	end

	for i = 1, MAX_PARTY_MEMBERS do
		local pet = "PartyMemberFrame"..i.."PetFrame"

		_G[pet]:SetParent(S.HiddenFrame)
		_G[pet.."HealthBar"]:UnregisterAllEvents()
	end
end
--[[ Debuff highlight ]]

local PostUpdateIcon = function(_, unit, icon, index, _, filter)
	local _, _, _, _, dtype = UnitAura(unit, index, icon.filter)
	if icon.isDebuff and dtype and UnitIsFriend("player", unit) then
		local color = DebuffTypeColor[dtype]
		icon.bg:SetVertexColor(color.r, color.g, color.b)
	else
		icon.bg:SetVertexColor(0, 0, 0)
	end
end

--[[ Update power value ]]

local PostUpdatePower = function(Power, unit, min, max)
	local Health = Power:GetParent().Health
	if min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		Power:SetValue(0)
	end
end

-- [[ Threat update (party) ]]

local UpdateThreat = function(self, event, unit)
	if(unit ~= self.unit) then return end

	local threat = self.Threat

	unit = unit or self.unit
	local status = UnitThreatSituation(unit)

	if(status and status > 0) then
		local r, g, b = GetThreatStatusColor(status)
		self.bd:SetBackdropBorderColor(r, g, b)
	else
		self.bd:SetBackdropBorderColor(0, 0, 0)
	end
end

--[[ Global ]]

local Shared = function(self, unit, isSingle)
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:RegisterForClicks("AnyUp")

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", -1, 1)
	bd:SetPoint("BOTTOMRIGHT", 1, -1)
	bd:SetFrameStrata("BACKGROUND")

	self.bd = bd

	--[[ Health ]]

	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetFrameStrata("LOW")
	Health:SetStatusBarTexture(S["media"].normal)
	Health:SetStatusBarColor(0, 0, 0, 0)

	Health.frequentUpdates = true
	S:SmoothBar(Health)

	Health:SetPoint("TOP")
	Health:SetPoint("LEFT")
	Health:SetPoint("RIGHT")
	Health:SetPoint("BOTTOM", 0, 1 + UF.db.powerHeight)

	self.Health = Health

	--[[ Gradient ]]

	if UF.db.layout == 2 and not UF.db.healerClasscolours then
		local gradient = Health:CreateTexture(nil, "BACKGROUND")
		gradient:SetPoint("TOPLEFT")
		gradient:SetPoint("BOTTOMRIGHT")
		gradient:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)

		self.gradient = gradient

		A:CreateBD(bd, 0)
	else
		A:CreateBD(bd)
	end

	--[[ Health deficit colour ]]

	if UF.db.layout == 2 and not UF.db.healerClasscolours then
		local Healthdef = CreateFrame("StatusBar", nil, self)
		Healthdef:SetFrameStrata("LOW")
		Healthdef:SetAllPoints(Health)
		Healthdef:SetStatusBarTexture(S["media"].normal)
		Healthdef:SetStatusBarColor(1, 1, 1)

		Healthdef:SetReverseFill(true)
		S:SmoothBar(Healthdef)

		self.Healthdef = Healthdef
	end

	--[[ Power ]]

	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetStatusBarTexture(S["media"].normal)

	Power.frequentUpdates = true
	S:SmoothBar(Power)

	Power:SetHeight(UF.db.powerHeight)

	Power:SetPoint("LEFT")
	Power:SetPoint("RIGHT")
	Power:SetPoint("TOP", Health, "BOTTOM", 0, -1)

	self.Power = Power

	local Powertex = Power:CreateTexture(nil, "OVERLAY")
	Powertex:SetHeight(1)
	Powertex:SetPoint("TOPLEFT", 0, 1)
	Powertex:SetPoint("TOPRIGHT", 0, 1)
	Powertex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	Powertex:SetVertexColor(0, 0, 0)

	Power.bg = Power:CreateTexture(nil, "BACKGROUND")
	Power.bg:SetHeight(UF.db.powerHeight)
	Power.bg:SetPoint("LEFT")
	Power.bg:SetPoint("RIGHT")
	Power.bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	Power.bg:SetVertexColor(0, 0, 0, .5)

	-- Colour power by power type for dps/tank layout. Because this is brighter, make the background darker for contrast.
	if UF.db.layout == 1 or UF.db.healerClasscolours then
		Power.colorPower = true
		Power.bg:SetVertexColor(0, 0, 0, .25)
	end

	--[[ Alt Power ]]

	if unit == "player" or unit == "pet" then
		local AltPowerBar = CreateFrame("StatusBar", nil, self)
		AltPowerBar:SetWidth(UF.db.playerWidth)
		AltPowerBar:SetHeight(UF.db.altPowerHeight)
		AltPowerBar:SetStatusBarTexture(S["media"].normal)
		AltPowerBar:SetPoint("BOTTOM", oUF_SunUFPlayer, 0, -2)

		local abd = CreateFrame("Frame", nil, AltPowerBar)
		abd:SetPoint("TOPLEFT", -1, 1)
		abd:SetPoint("BOTTOMRIGHT", 1, -1)
		abd:SetFrameLevel(AltPowerBar:GetFrameLevel()-1)
		A:CreateBD(abd)

		AltPowerBar.Text = S:CreateFS(AltPowerBar, 10, "RIGHT")
		AltPowerBar.Text:SetPoint("RIGHT", oUF_SunUFPlayer, "TOPRIGHT", 0, 6)

		AltPowerBar:SetScript("OnValueChanged", function(_, value)
			local min, max = AltPowerBar:GetMinMaxValues()
			local r, g, b = self.ColorGradient(value, max, unpack(self.colors.smooth))
			AltPowerBar:SetStatusBarColor(r, g, b)
			AltPowerBar.Text:SetTextColor(r, g, b)
		end)

		AltPowerBar.PostUpdate = function(_, _, cur)
			AltPowerBar.Text:SetText(cur)
		end

		S:SmoothBar(AltPowerBar)

		AltPowerBar:HookScript("OnShow", function()
			oUF_SunUFPlayer.MaxHealthPoints:Hide()
		end)
		AltPowerBar:HookScript("OnHide", function()
			oUF_SunUFPlayer.MaxHealthPoints:Show()
		end)

		AltPowerBar:EnableMouse(true)

		self.AltPowerBar = AltPowerBar
	end

	--[[ Castbar ]]

	local Castbar = CreateFrame("StatusBar", nil, self)
	Castbar:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
	Castbar:SetStatusBarColor(0, 0, 0, 0)

	local Spark = Castbar:CreateTexture(nil, "OVERLAY")
	Spark:SetBlendMode("ADD")
	Spark:SetWidth(16)
	Castbar.Spark = Spark

	self.Castbar = Castbar

	local PostCastStart = function(Castbar, unit, spell, spellrank)
		if self.Iconbg then
			if Castbar.interrupt and (unit=="target" or unit:find("boss%d")) then
				self.Iconbg:SetVertexColor(1, 0, 0)
			else
				self.Iconbg:SetVertexColor(0, 0, 0)
			end
		end
	end

	local PostCastStop = function(Castbar, unit)
		if Castbar.Text then Castbar.Text:SetText("") end
	end

	local PostCastStopUpdate = function(self, event, unit)
		if(unit ~= self.unit) then return end
		return PostCastStop(self.Castbar, unit)
	end

	self:RegisterEvent("UNIT_NAME_UPDATE", PostCastStopUpdate)
	table.insert(self.__elements, PostCastStopUpdate)

	-- [[ Heal prediction ]]

	if UF.db.layout == 2 then
		local mhpb = self:CreateTexture()
		mhpb:SetTexture(S["media"].normal)
		mhpb:SetVertexColor(0, .5, 1)

		local ohpb = self:CreateTexture()
		ohpb:SetTexture(S["media"].normal)
		ohpb:SetVertexColor(.5, 0, 1)

		self.HealPrediction = {
			-- status bar to show my incoming heals
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
			frequentUpdates = true,
		}

		if UF.db.absorb then
			local absorbBar = self:CreateTexture()
			absorbBar:SetTexture(S["media"].normal)
			absorbBar:SetVertexColor(.8, .34, .8)

			local overAbsorbGlow = self:CreateTexture(nil, "OVERLAY")
			overAbsorbGlow:SetWidth(16)
			overAbsorbGlow:SetBlendMode("ADD")
			overAbsorbGlow:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", -7, 0)
			overAbsorbGlow:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMRIGHT", -7, 0)

			self.HealPrediction["absorbBar"] = absorbBar
			self.HealPrediction["overAbsorbGlow"] = overAbsorbGlow
		end
	end

	-- [[ Raid target icons ]]

	local RaidIcon = self:CreateTexture()
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("RIGHT", self, "LEFT", -3, 0)

	self.RaidIcon = RaidIcon

	--[[ Set up the layout ]]

	self.colors = colors

	self.disallowVehicleSwap = true

	if(isSingle) then
		if unit == "player" then
			self:SetSize(UF.db.playerWidth, UF.db.playerHeight)
		elseif unit == "target" then
			self:SetSize(UF.db.targetWidth, UF.db.targetHeight)
		elseif unit == "targettarget" then
			self:SetSize(UF.db.targettargetWidth, UF.db.targettargetHeight)
		elseif unit:find("arena%d") then
			self:SetSize(UF.db.arenaWidth, UF.db.arenaHeight)
		elseif unit == "focus" then
			self:SetSize(UF.db.focusWidth, UF.db.focusHeight)
		elseif unit == "pet" then
			self:SetSize(UF.db.petWidth, UF.db.petHeight)
		elseif unit and unit:find("boss%d") then
			self:SetSize(UF.db.bossWidth, UF.db.bossHeight)
		end
	end

	Castbar.PostChannelStart = PostCastStart
	Castbar.PostCastStart = PostCastStart

	Castbar.PostCastStop = PostCastStop
	Castbar.PostChannelStop = PostCastStop

	Health.PostUpdate = PostUpdateHealth
	Power.PostUpdate = PostUpdatePower
end

-- [[ Unit specific functions ]]

local UnitSpecific = {
	pet = function(self, ...)
		Shared(self, ...)

		local Health = self.Health
		local Power = self.Power
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		Health:SetHeight(UF.db.petHeight - UF.db.powerHeight - 1)

		Castbar:SetAllPoints(Health)
		Castbar.Width = self:GetWidth()

		Spark:SetHeight(self.Health:GetHeight())
	end,

	player = function(self, ...)
		Shared(self, ...)

		local Health = self.Health
		local Power = self.Power
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		Health:SetHeight(UF.db.playerHeight - UF.db.powerHeight - 1)

		local HealthPoints = S:CreateFS(Health, 10, "LEFT")
		self.MaxHealthPoints = S:CreateFS(Health, 10, "RIGHT")

		HealthPoints:SetPoint("BOTTOMLEFT", Health, "TOPLEFT", 0, 3)
		self.MaxHealthPoints:SetPoint("BOTTOMRIGHT", Health, "TOPRIGHT", 0, 3)

		self:Tag(HealthPoints, '[dead][offline][sunuf:health]')
		self:Tag(self.MaxHealthPoints, '[sunuf:maxhealth]')
		Health.value = HealthPoints

		local _, UnitPowerType = UnitPowerType("player")
		if UnitPowerType == "MANA" or class == "DRUID" then
			local PowerPoints = S:CreateFS(Power, 10)
			PowerPoints:SetPoint("LEFT", HealthPoints, "RIGHT", 2, 0)
			PowerPoints:SetTextColor(.4, .7, 1)

			self:Tag(PowerPoints, '[sunuf:power]')
			Power.value = PowerPoints
		end

		Castbar.Width = self:GetWidth()
		Spark:SetHeight(self.Health:GetHeight())
		Castbar.Text = S:CreateFS(Castbar)
		Castbar.Text:SetDrawLayer("ARTWORK")

		local IconFrame = CreateFrame("Frame", nil, Castbar)

		local Icon = IconFrame:CreateTexture(nil, "OVERLAY")
		Icon:SetAllPoints(IconFrame)
		Icon:SetTexCoord(.08, .92, .08, .92)

		Castbar.Icon = Icon

		self.Iconbg = IconFrame:CreateTexture(nil, "BACKGROUND")
		self.Iconbg:Point("TOPLEFT", -1 , 1)
		self.Iconbg:Point("BOTTOMRIGHT", 1, -1)
		self.Iconbg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")

		if UF.db.castbarSeparate and (class == "MAGE" or class == "PRIEST" or class == "WARLOCK" or not UF.db.castbarSeparateOnlyCasters) then
			Castbar:SetStatusBarTexture(S["media"].normal)
			Castbar:SetStatusBarColor(S.myclasscolor.r, S.myclasscolor.g, S.myclasscolor.b)
			Castbar:SetWidth(self:GetWidth())
			Castbar:SetHeight(self:GetHeight())
			Castbar:SetPoint("BOTTOM", "UIParent", "BOTTOM",0, 110) --玩家施法条
			S:CreateMover(Castbar, "PlayCastBarMover", L["玩家施法条"], true, nil, "ALL,UNITFRAMES")
			Castbar.Text:SetAllPoints(Castbar)
			local sf = Castbar:CreateTexture(nil, "OVERLAY")
			sf:SetVertexColor(.5, .5, .5, .5)
			Castbar.SafeZone = sf
			IconFrame:SetPoint("RIGHT", Castbar, "LEFT", -3, 0)
			IconFrame:SetSize(22, 22)

			local bg = CreateFrame("Frame", nil, Castbar)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(Castbar:GetFrameLevel()-1)
			A:CreateBD(bg)
		else
			Castbar:SetAllPoints(Health)
			Castbar.Text:SetAllPoints(Health)
			IconFrame:SetPoint("RIGHT", self, "LEFT", -10, 0)
			IconFrame:SetSize(44, 44)
		end

		local PvP = S:CreateFS(self)
		PvP:SetPoint("BOTTOMRIGHT", Health, "TOPRIGHT", -50, 3)
		PvP:SetText("P")

		local UpdatePvP = function(self, event, unit)
			if(unit ~= self.unit) then return end

			local pvp = self.PvP

			local factionGroup = UnitFactionGroup(unit)
			if(UnitIsPVPFreeForAll(unit) or (factionGroup and factionGroup ~= "Neutral" and UnitIsPVP(unit))) then
				if factionGroup == "Alliance" then
					PvP:SetTextColor(0, 0.68, 0.94)
				else
					PvP:SetTextColor(1, 0, 0)
				end

				pvp:Show()
			else
				pvp:Hide()
			end
		end

		self.PvP = PvP
		PvP.Override = UpdatePvP

		-- We position these later on
		local Debuffs = CreateFrame("Frame", nil, self)
		Debuffs.initialAnchor = "TOPRIGHT"
		Debuffs["growth-x"] = "LEFT"
		Debuffs["growth-y"] = "DOWN"
		Debuffs['spacing-x'] = 3
		Debuffs['spacing-y'] = 3

		Debuffs:SetHeight(60)
		Debuffs:SetWidth(UF.db.playerWidth)
		Debuffs.num = UF.db.num_player_debuffs
		Debuffs.size = 26

		self.Debuffs = Debuffs
		Debuffs.PostUpdateIcon = PostUpdateIcon
		local PB = S:GetModule("PowerBar")
		
		if class == "DEATHKNIGHT" and PB.db.Open == false then
			local runes = CreateFrame("Frame", nil, self)
			runes:SetWidth(UF.db.playerWidth)
			runes:SetHeight(2)
			runes:SetPoint("BOTTOMRIGHT", Debuffs, "TOPRIGHT", 0, 3)

			local rbd = CreateFrame("Frame", nil, runes)
			rbd:SetBackdrop({
				edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
				edgeSize = 1,
			})
			rbd:SetBackdropBorderColor(0, 0, 0)
			rbd:SetPoint("TOPLEFT", -1, 1)
			rbd:SetPoint("BOTTOMRIGHT", 1, -1)

			for i = 1, 6 do
				runes[i] = CreateFrame("StatusBar", nil, self)
				runes[i]:SetHeight(2)
				runes[i]:SetStatusBarTexture(S["media"].normal)
				runes[i]:SetStatusBarColor(255/255,101/255,101/255)

				local rbd = CreateFrame("Frame", nil, runes[i])
				rbd:SetBackdrop({
					edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
					edgeSize = 1,
				})
				rbd:SetBackdropBorderColor(0, 0, 0)
				rbd:SetPoint("TOPLEFT", runes[i], -1, 1)
				rbd:SetPoint("BOTTOMRIGHT", runes[i], 1, -1)

				if i == 1 then
					runes[i]:SetPoint("LEFT", runes)
					runes[i]:SetWidth(UF.db.playerWidth/6)
				else
					runes[i]:SetPoint("LEFT", runes[i-1], "RIGHT", 1, 0)
					runes[i]:SetWidth((UF.db.playerWidth/6)-1)
				end
			end

			self.Runes = runes
			self.SpecialPowerBar = runes
		elseif class == "DRUID" and PB.db.Open == false then
			local DruidMana, eclipseBar

			local function moveDebuffAnchors()
				if DruidMana:IsShown() or eclipseBar:IsShown() then
					local offset
					if DruidMana:IsShown() then
						offset = 1
					else
						offset = 2
					end
					if self.AltPowerBar:IsShown() then
						self.Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -(7 + offset + UF.db.altPowerHeight))
					else
						self.Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -(6 + offset))
					end
				else
					if self.AltPowerBar:IsShown() then
						self.Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -(4 + UF.db.altPowerHeight))
					else
						self.Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -3)
					end
				end
			end

			DruidMana = CreateFrame("StatusBar", nil, self)
			DruidMana:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
			DruidMana:SetStatusBarColor(0, 0.76, 1)
			DruidMana:SetSize(UF.db.playerWidth, 1)
			DruidMana:SetPoint("BOTTOMRIGHT", Debuffs, "TOPRIGHT", 0, 3)

			A:CreateBDFrame(DruidMana, .25)

			self.DruidMana = DruidMana

			DruidMana.PostUpdate = moveDebuffAnchors

			eclipseBar = CreateFrame("Frame", nil, self)
			eclipseBar:SetWidth(UF.db.playerWidth)
			eclipseBar:SetHeight(2)
			eclipseBar:SetPoint("BOTTOMRIGHT", Debuffs, "TOPRIGHT", 0, 3)

			A:CreateBDFrame(eclipseBar, .25)

			local glow = CreateFrame("Frame", nil, eclipseBar)
			glow:SetBackdrop({
				edgeFile = S["media"].glow.glow,
				edgeSize = 5,
			})
			glow:SetPoint("TOPLEFT", -6, 6)
			glow:SetPoint("BOTTOMRIGHT", 6, -6)

			local hasEclipse = function(self, unit)
				if self.hasSolarEclipse then
					glow:SetBackdropBorderColor(.80, .82, .60, 1)
				elseif self.hasLunarEclipse then
					glow:SetBackdropBorderColor(.30, .52, .90, 1)
				else
					glow:SetBackdropBorderColor(0, 0, 0, 0)
				end
			end

			local LunarBar = CreateFrame("StatusBar", nil, eclipseBar)
			LunarBar:SetPoint("LEFT", eclipseBar, "LEFT")
			LunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
			LunarBar:SetStatusBarTexture(S["media"].normal)
			LunarBar:SetStatusBarColor(.80, .82, .60)
			eclipseBar.LunarBar = LunarBar

			S:SmoothBar(LunarBar)

			local SolarBar = CreateFrame("StatusBar", nil, eclipseBar)
			SolarBar:SetPoint("LEFT", LunarBar:GetStatusBarTexture(), "RIGHT")
			SolarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
			SolarBar:SetStatusBarTexture(S["media"].normal)
			SolarBar:SetStatusBarColor(.30, .52, .90)
			eclipseBar.SolarBar = SolarBar

			S:SmoothBar(SolarBar)

			local spark = SolarBar:CreateTexture(nil, "OVERLAY")
			spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
			spark:SetBlendMode("ADD")
			spark:SetHeight(4)
			spark:SetPoint("CENTER", SolarBar:GetStatusBarTexture(), "LEFT")

			local eclipseBarText = S:CreateFS(eclipseBar, 24)
			eclipseBarText:SetPoint("LEFT", self, "RIGHT", 10, 0)
			eclipseBarText:Hide()

			self.EclipseBar = eclipseBar

			self.EclipseBar.PostUnitAura = hasEclipse

			eclipseBar:RegisterEvent("PLAYER_REGEN_ENABLED")
			eclipseBar:RegisterEvent("PLAYER_REGEN_DISABLED")
			eclipseBar:HookScript("OnEvent", function(self, event)
				if event == "PLAYER_REGEN_DISABLED" then
					eclipseBarText:Show()
				elseif event == "PLAYER_REGEN_ENABLED" then
					eclipseBarText:Hide()
				end
			end)

			self.EclipseBar.PostUpdatePower = function(self)
				if GetEclipseDirection() == "sun" then
					eclipseBarText:SetTextColor(.30, .52, .90)
				elseif GetEclipseDirection() == "moon" then
					eclipseBarText:SetTextColor(.80, .82, .60)
				else
					eclipseBarText:SetTextColor(1, 1, 1)
				end

				local power = UnitPower("player", SPELL_POWER_ECLIPSE)
				if power == 0 then
					eclipseBarText:SetText("")
				else
					eclipseBarText:SetText(math.abs(power))
				end
			end

			self.EclipseBar.PostUpdateVisibility = moveDebuffAnchors

			self.AltPowerBar:HookScript("OnShow", moveDebuffAnchors)
			self.AltPowerBar:HookScript("OnHide", moveDebuffAnchors)
		elseif class == "MAGE" then
			local rp = CreateFrame("Frame", nil, self)
			rp:SetSize(UF.db.playerWidth, 2)
			rp:SetPoint("BOTTOMRIGHT", Debuffs, "TOPRIGHT", 0, 3)

			for i = 1, 2 do
				rp[i] = CreateFrame("StatusBar", nil, rp)
				rp[i]:SetHeight(2)
				rp[i]:SetStatusBarTexture(S["media"].normal)

				A:CreateBDFrame(rp[i])

				if i == 1 then
					rp[i]:SetPoint("LEFT", rp)
					rp[i]:SetWidth(UF.db.playerWidth/2)
				else
					rp[i]:SetPoint("LEFT", rp[i-1], "RIGHT", 1, 0)
					rp[i]:SetWidth((UF.db.playerWidth/2)-1)
				end
			end

			self.RunePower = rp
			self.SpecialPowerBar = rp
		elseif class == "MONK" and PB.db.Open == false then
			local pulsating = false

			local r, g, b = PowerBarColor["CHI"].r, PowerBarColor["CHI"].g, PowerBarColor["CHI"].b

			local UpdateOrbs = function(self, event, unit, powerType)
				if unit ~= "player" then return end
				if event == "UNIT_POWER_FREQUENT" then
					if not (powerType == "CHI" or powerType == "DARK_FORCE") then
						return
					end
				end

				local chi = UnitPower(unit, SPELL_POWER_CHI)

				if chi == UnitPowerMax(unit, SPELL_POWER_CHI) then
					if not pulsating then
						pulsating = true
						self.glow:SetAlpha(1)
						A:CreatePulse(self.glow)
						self.count:SetText(chi)
						self.count:SetTextColor(r, g, b)
						self.count:FontTemplate(nil, 40)
					end
				elseif chi == 0 then
					self.glow:SetScript("OnUpdate", nil)
					self.glow:SetAlpha(0)
					self.count:SetText("")
					pulsating = false
				else
					self.glow:SetScript("OnUpdate", nil)
					self.glow:SetAlpha(0)
					self.count:SetText(chi)
					self.count:SetTextColor(1, 1, 1)
					self.count:FontTemplate(nil, 24)
					pulsating = false
				end
			end

			local glow = CreateFrame("Frame", nil, self)
			glow:SetBackdrop({
				edgeFile = S["media"].glow.glow,
				edgeSize = 5,
			})
			glow:SetPoint("TOPLEFT", self, -6, 6)
			glow:SetPoint("BOTTOMRIGHT", self, 6, -6)
			glow:SetBackdropBorderColor(r, g, b)

			self.glow = glow

			local count = S:CreateFS(self, 24)
			count:SetPoint("LEFT", self, "RIGHT", 10, 0)

			self.count = count

			self.Harmony = glow
			glow.Override = UpdateOrbs

			-- Brewmaster stagger bar

			local staggerBar = CreateFrame("StatusBar", nil, self)
			staggerBar:SetSize(UF.db.playerWidth, 2)
			staggerBar:SetPoint("BOTTOMRIGHT", Debuffs, "TOPRIGHT", 0, 3)
			staggerBar:SetStatusBarTexture(S["media"].normal)
			A:CreateBDFrame(staggerBar)

			self.Stagger = staggerBar
			self.SpecialPowerBar = staggerBar
		elseif class == "PALADIN" and PB.db.Open == false then
			local UpdateHoly = function(self, event, unit, powerType)
				if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end

				local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)

				if(num == UnitPowerMax("player", SPELL_POWER_HOLY_POWER)) then
					self.glow:SetAlpha(1)
					A:CreatePulse(self.glow)
					self.count:SetText(num)
					self.count:SetTextColor(1, 1, 0)
					self.count:FontTemplate(nil, 40)
				elseif num == 0 then
					self.glow:SetScript("OnUpdate", nil)
					self.glow:SetAlpha(0)
					self.count:SetText("")
				else
					self.glow:SetScript("OnUpdate", nil)
					self.glow:SetAlpha(0)
					self.count:SetText(num)
					self.count:SetTextColor(1, 1, 1)
					self.count:FontTemplate(nil, 24)
				end
			end

			local glow = CreateFrame("Frame", nil, self)
			glow:SetBackdrop({
				edgeFile = S["media"].glow.glow,
				edgeSize = 5,
			})
			glow:SetPoint("TOPLEFT", self, -6, 6)
			glow:SetPoint("BOTTOMRIGHT", self, 6, -6)
			glow:SetBackdropBorderColor(228/255, 225/255, 16/255)

			self.glow = glow

			local count = S:CreateFS(self, 24)
			count:SetPoint("LEFT", self, "RIGHT", 10, 0)

			self.count = count

			self.HolyPower = glow
			glow.Override = UpdateHoly
		elseif class == "PRIEST" and PB.db.Open == false then
			local UpdateOrbs = function(self, event, unit, powerType)
				if(self.unit ~= unit or (powerType and powerType ~= 'SHADOW_ORBS')) then return end

				local numOrbs = UnitPower("player", SPELL_POWER_SHADOW_ORBS)
				
				if(numOrbs == PRIEST_BAR_NUM_ORBS) then
					self.glow:SetAlpha(1)
					A:CreatePulse(self.glow)
					self.count:SetText(numOrbs)
					self.count:SetTextColor(.6, 0, 1)
					self.count:FontTemplate(nil, 40)
				elseif numOrbs == 0 then
					self.glow:SetScript("OnUpdate", nil)
					self.glow:SetAlpha(0)
					self.count:SetText("")
				else
					self.glow:SetScript("OnUpdate", nil)
					self.glow:SetAlpha(0)
					self.count:SetText(numOrbs)
					self.count:SetTextColor(1, 1, 1)
					self.count:FontTemplate(nil, 24)
				end
			end

			local glow = CreateFrame("Frame", nil, self)
			glow:SetBackdrop({
				edgeFile = S["media"].glow.glow,
				edgeSize = 5,
			})
			glow:SetPoint("TOPLEFT", self, -6, 6)
			glow:SetPoint("BOTTOMRIGHT", self, 6, -6)
			glow:SetBackdropBorderColor(.6, 0, 1)

			self.glow = glow

			local count = S:CreateFS(self, 24)
			count:SetPoint("LEFT", self, "RIGHT", 10, 0)

			self.count = count

			self.ShadowOrbs = glow
			glow.Override = UpdateOrbs
		elseif class == "WARLOCK" and PB.db.Open == false then
			local bars = CreateFrame("Frame", nil, self)
			bars:SetWidth(UF.db.playerWidth)
			bars:SetHeight(2)
			bars:SetPoint("BOTTOMRIGHT", Debuffs, "TOPRIGHT", 0, 3)

			for i = 1, 4 do
				bars[i] = CreateFrame("StatusBar", nil, bars)
				bars[i]:SetHeight(2)
				bars[i]:SetStatusBarTexture(S["media"].normal)

				local bbd = CreateFrame("Frame", nil, bars[i])
				bbd:SetPoint("TOPLEFT", bars[i], -1, 1)
				bbd:SetPoint("BOTTOMRIGHT", bars[i], 1, -1)
				bbd:SetFrameLevel(bars[i]:GetFrameLevel()-1)
				A:CreateBD(bbd)

				if i == 1 then
					bars[i]:SetPoint("LEFT", bars)
					bars[i]:SetWidth(UF.db.playerWidth/4)
				else
					bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
					bars[i]:SetWidth((UF.db.playerWidth/4)-1)
				end
			end

			self.WarlockSpecBars = bars
			self.SpecialPowerBar = bars
		end

		local function moveDebuffAnchors()
			if self.SpecialPowerBar and self.SpecialPowerBar:IsShown() then
				if self.AltPowerBar:IsShown() then
					Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -(9 + UF.db.altPowerHeight))
				else
					Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -8)
				end
			else
				if self.AltPowerBar:IsShown() then
					Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -(4 + UF.db.altPowerHeight))
				else
					Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -3)
				end
			end
		end

		self.AltPowerBar:HookScript("OnShow", moveDebuffAnchors)
		self.AltPowerBar:HookScript("OnHide", moveDebuffAnchors)
		if self.SpecialPowerBar then
			self.SpecialPowerBar:HookScript("OnShow", moveDebuffAnchors)
			self.SpecialPowerBar:HookScript("OnHide", moveDebuffAnchors)
		end
		moveDebuffAnchors()

		local CounterBar = CreateFrame("StatusBar", nil, self)
		CounterBar:SetWidth(UF.db.playerWidth)
		CounterBar:SetHeight(16)
		CounterBar:SetStatusBarTexture(S["media"].normal)
		CounterBar:SetPoint("TOP", UIParent, "TOP", 0, -100)

		local cbd = CreateFrame("Frame", nil, CounterBar)
		cbd:SetPoint("TOPLEFT", -1, 1)
		cbd:SetPoint("BOTTOMRIGHT", 1, -1)
		cbd:SetFrameLevel(CounterBar:GetFrameLevel()-1)
		A:CreateBD(cbd)

		CounterBar.Text = S:CreateFS(CounterBar)
		CounterBar.Text:SetPoint("CENTER")

		local r, g, b
		local max

		CounterBar:SetScript("OnValueChanged", function(_, value)
			_, max = CounterBar:GetMinMaxValues()
			r, g, b = self.ColorGradient(value, max, unpack(self.colors.smooth))
			CounterBar:SetStatusBarColor(r, g, b)

			CounterBar.Text:SetText(floor(value))
		end)

		self.CounterBar = CounterBar

		-- do
			-- local f = CreateFrame("Frame")

			-- local function incrementAlpha()
				-- local alpha = self:GetAlpha()

				-- if alpha >= 1 then
					-- self:SetAlpha(1)
					-- f:SetScript("OnUpdate", nil)
					-- return
				-- end

				-- self:SetAlpha(alpha + 0.05)
			-- end

			-- local function decrementAlpha()
				-- local alpha = self:GetAlpha()

				-- if alpha <= 0 then
					-- self:SetAlpha(0)
					-- f:SetScript("OnUpdate", nil)
					-- return
				-- end

				-- self:SetAlpha(alpha - 0.05)
			-- end

			-- f:RegisterEvent("PLAYER_REGEN_ENABLED")
			-- f:RegisterEvent("PLAYER_REGEN_DISABLED")
			-- f:RegisterEvent("PLAYER_TARGET_CHANGED")
			-- f:SetScript("OnEvent", function(_, event)
				-- if event == "PLAYER_REGEN_ENABLED" then
					-- f:SetScript("OnUpdate", decrementAlpha)
				-- elseif event == "PLAYER_REGEN_DISABLED" then
					-- f:SetScript("OnUpdate", incrementAlpha)
				-- else
					-- if UnitName("target") ~= nil then
						-- f:SetScript("OnUpdate", incrementAlpha)
					-- else
						-- f:SetScript("OnUpdate", decrementAlpha)
					-- end
				-- end
			-- end)

			-- self:SetAlpha(0)
		-- end
	end,

	target = function(self, ...)
		Shared(self, ...)

		local Health = self.Health
		local Power = self.Power
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		Health:SetHeight(UF.db.targetHeight - UF.db.powerHeight - 1)

		local HealthPoints = S:CreateFS(Health, 10, "LEFT")

		HealthPoints:SetPoint("BOTTOMLEFT", Health, "TOPLEFT", 0, 2)

		self:Tag(HealthPoints, '[dead][offline][sunuf:health]%')
		Health.value = HealthPoints

		local PowerPoints = S:CreateFS(Power, 10)
		PowerPoints:SetPoint("BOTTOMLEFT", Health.value, "BOTTOMRIGHT", 3, 0)

		self:Tag(PowerPoints, '[sunuf:power]')

		Power.value = PowerPoints

		local tt = CreateFrame("Frame", nil, self)
		tt:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 7 + S["media"].fontsize + (UF.db.targettarget and 10 or 0))
		tt:SetWidth(110)
		tt:SetHeight(12)

		ttt = S:CreateFS(tt, S["media"].fontsize, "RIGHT")
		ttt:SetPoint("BOTTOMRIGHT", tt)

		tt:RegisterEvent("UNIT_TARGET")
		tt:RegisterEvent("PLAYER_TARGET_CHANGED")
		tt:SetScript("OnEvent", function()
			if(UnitName("targettarget")==UnitName("player")) then
				ttt:SetText("> YOU <")
				ttt:SetTextColor(1, 0, 0)
			else
				ttt:SetText(UnitName"targettarget")
				ttt:SetTextColor(1, 1, 1)
			end
		end)

		Castbar:SetAllPoints(Health)
		Castbar.Width = self:GetWidth()

		Spark:SetHeight(self.Health:GetHeight())

		Castbar.Text = S:CreateFS(Castbar)
		Castbar.Text:SetDrawLayer("ARTWORK")
		Castbar.Text:SetAllPoints(Health)

		local IconFrame = CreateFrame("Frame", nil, Castbar)
		IconFrame:SetPoint("LEFT", self, "RIGHT", 3, 0)
		IconFrame:SetSize(44, 44)

		local Icon = IconFrame:CreateTexture(nil, "OVERLAY")
		Icon:SetAllPoints(IconFrame)
		Icon:SetTexCoord(.08, .92, .08, .92)

		Castbar.Icon = Icon

		self.Iconbg = IconFrame:CreateTexture(nil, "BACKGROUND")
		self.Iconbg:SetPoint("TOPLEFT", -1 , 1)
		self.Iconbg:SetPoint("BOTTOMRIGHT", 1, -1)
		self.Iconbg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")

		local Name = S:CreateFS(self)
		Name:SetPoint("BOTTOMLEFT", Power.value, "BOTTOMRIGHT")
		Name:SetPoint("RIGHT", self)
		Name:SetJustifyH"RIGHT"
		Name:SetTextColor(1, 1, 1)

		self:Tag(Name, '[name]')
		self.Name = Name

		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
		Auras.initialAnchor = "TOPLEFT"
		Auras["growth-x"] = "RIGHT"
		Auras["growth-y"] = "DOWN"
		Auras['spacing-x'] = 3
		Auras['spacing-y'] = 3
		Auras.numDebuffs = UF.db.num_target_debuffs
		Auras.numBuffs = UF.db.num_target_buffs
		Auras:SetHeight(500)
		Auras:SetWidth(UF.db.targetWidth)
		Auras.size = 13
		Auras.gap = true

		self.Auras = Auras

		Auras.showStealableBuffs = true
		Auras.PostUpdateIcon = PostUpdateIcon

		-- complicated filter is complicated
		-- icon hides if:
		-- it's a debuff on an enemy target which isn't yours, isn't cast by the target and isn't in the useful buffs filter
		-- it's a buff on an enemy player target which is not important

		local playerUnits = {
			player = true,
			pet = true,
			vehicle = true,
		}

		Auras.CustomFilter = function(_, unit, icon, _, _, _, _, _, _, _, caster, _, _, spellID)
			if(icon.isDebuff and not UnitIsFriend("player", unit) and not playerUnits[icon.owner] and icon.owner ~= self.unit and not UF.debuffFilter[spellID])
			or(not icon.isDebuff and UnitIsPlayer(unit) and not UnitIsFriend("player", unit) and not UF.dangerousBuffs[spellID]) then
				return false
			end
			return true
		end
	end,

	focus = function(self, ...)
		Shared(self, ...)

		local Health = self.Health
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		Health:SetHeight(UF.db.focusHeight - UF.db.powerHeight - 1)

		Castbar:SetAllPoints(Health)
		Castbar.Width = self:GetWidth()

		Spark:SetHeight(Health:GetHeight())

		local Debuffs = CreateFrame("Frame", nil, self)
		Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
		Debuffs.initialAnchor = "BOTTOMLEFT"
		Debuffs["growth-x"] = "RIGHT"
		Debuffs["growth-y"] = "UP"
		Debuffs["spacing-x"] = 3
		Debuffs:SetHeight(22)
		Debuffs:SetWidth(UF.db.focusWidth)
		Debuffs.size = 22
		Debuffs.num = UF.db.num_focus_debuffs
		self.Debuffs = Debuffs

		Debuffs.PostUpdateIcon = PostUpdateIcon
	end,

	targettarget = function(self, ...)
		Shared(self, ...)

		local Health = self.Health
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		Health:SetHeight(UF.db.targettargetHeight - UF.db.powerHeight - 1)

		Castbar:SetAllPoints(Health)
		Castbar.Width = self:GetWidth()

		Spark:SetHeight(Health:GetHeight())
	end,

	boss = function(self, ...)
		Shared(self, ...)

		local Health = self.Health
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		self:SetAttribute('initial-height', UF.db.bossHeight)
		self:SetAttribute('initial-width', UF.db.bossWidth)

		Health:SetHeight(UF.db.bossHeight - UF.db.powerHeight - 1)

		local HealthPoints = S:CreateFS(Health, 10, "RIGHT")
		HealthPoints:SetPoint("RIGHT", self, "TOPRIGHT", 0, 6)
		self:Tag(HealthPoints, '[dead][sunuf:bosshealth]')

		Health.value = HealthPoints

		local Name = S:CreateFS(self, 10, "LEFT")
		Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 2)
		Name:SetWidth((UF.db.bossWidth / 2) + 10)
		Name:SetHeight(8)

		self:Tag(Name, '[name]')
		self.Name = Name

		local AltPowerBar = CreateFrame("StatusBar", nil, self)
		AltPowerBar:SetWidth(UF.db.bossWidth)
		AltPowerBar:SetHeight(UF.db.altPowerHeight)
		AltPowerBar:SetStatusBarTexture(S["media"].normal)
		AltPowerBar:SetPoint("BOTTOM", 0, -2)

		local abd = CreateFrame("Frame", nil, AltPowerBar)
		abd:SetPoint("TOPLEFT", -1, 1)
		abd:SetPoint("BOTTOMRIGHT", 1, -1)
		abd:SetFrameLevel(AltPowerBar:GetFrameLevel()-1)
		A:CreateBD(abd)

		AltPowerBar.Text = S:CreateFS(AltPowerBar, 10, "CENTER")
		AltPowerBar.Text:SetPoint("CENTER", self, "TOP", 0, 6)

		AltPowerBar:SetScript("OnValueChanged", function(_, value)
			local min, max = AltPowerBar:GetMinMaxValues()
			local r, g, b = self.ColorGradient(value, max, unpack(self.colors.smooth))

			AltPowerBar:SetStatusBarColor(r, g, b)
			AltPowerBar.Text:SetTextColor(r, g, b)
		end)

		AltPowerBar.PostUpdate = function(_, _, cur)
			AltPowerBar.Text:SetText(cur)
		end

		self.AltPowerBar = AltPowerBar

		Castbar:SetAllPoints(Health)
		Castbar.Width = self:GetWidth()

		Spark:SetHeight(self.Health:GetHeight())

		Castbar.Text = S:CreateFS(self)
		Castbar.Text:SetDrawLayer("ARTWORK")
		Castbar.Text:SetAllPoints(Health)

		local IconFrame = CreateFrame("Frame", nil, Castbar)
		IconFrame:SetPoint("LEFT", self, "RIGHT", 3, 0)
		IconFrame:SetHeight(22)
		IconFrame:SetWidth(22)

		local Icon = IconFrame:CreateTexture(nil, "OVERLAY")
		Icon:SetAllPoints(IconFrame)
		Icon:SetTexCoord(.08, .92, .08, .92)

		Castbar.Icon = Icon

		self.Iconbg = IconFrame:CreateTexture(nil, "BACKGROUND")
		self.Iconbg:SetPoint("TOPLEFT", -1 , 1)
		self.Iconbg:SetPoint("BOTTOMRIGHT", 1, -1)
		self.Iconbg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")

		local Buffs = CreateFrame("Frame", nil, self)
		Buffs.initialAnchor = "TOPLEFT"
		Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
		Buffs["growth-x"] = "RIGHT"
		Buffs["growth-y"] = "DOWN"
		Buffs['spacing-x'] = 3
		Buffs['spacing-y'] = 3

		Buffs:SetHeight(22)
		Buffs:SetWidth(UF.db.bossWidth - 24)
		Buffs.num = UF.db.num_boss_buffs
		Buffs.size = 26

		self.Buffs = Buffs

		Buffs.PostUpdateIcon = PostUpdateIcon

		AltPowerBar:HookScript("OnShow", function()
			Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -(5 + UF.db.altPowerHeight))
		end)

		AltPowerBar:HookScript("OnHide", function()
			Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -(3 + UF.db.altPowerHeight))
		end)
	end,

	arena = function(self, ...)
		if not UF.db.enableArena then return end

		Shared(self, ...)

		local Health = self.Health
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		self:SetAttribute('initial-height', UF.db.arenaHeight)
		self:SetAttribute('initial-width', UF.db.arenaWidth)

		Health:SetHeight(UF.db.arenaHeight - UF.db.powerHeight - 1)

		local HealthPoints = S:CreateFS(Health, 10, "RIGHT")
		HealthPoints:SetPoint("RIGHT", self, "TOPRIGHT", 0, 6)
		self:Tag(HealthPoints, '[dead][sunuf:health]')

		Health.value = HealthPoints

		local Name = S:CreateFS(self, 10, "LEFT")
		Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 2)
		Name:SetWidth(110)
		Name:SetHeight(8)

		self:Tag(Name, '[name]')
		self.Name = Name

		Castbar:SetAllPoints(Health)
		Castbar.Width = self:GetWidth()

		Spark:SetHeight(self.Health:GetHeight())

		Castbar.Text = S:CreateFS(self)
		Castbar.Text:SetDrawLayer("ARTWORK")
		Castbar.Text:SetAllPoints(Health)

		local IconFrame = CreateFrame("Frame", nil, Castbar)
		IconFrame:SetPoint("LEFT", self, "RIGHT", 3, 0)
		IconFrame:SetHeight(22)
		IconFrame:SetWidth(22)

		local Icon = IconFrame:CreateTexture(nil, "OVERLAY")
		Icon:SetAllPoints(IconFrame)
		Icon:SetTexCoord(.08, .92, .08, .92)

		Castbar.Icon = Icon

		self.Iconbg = IconFrame:CreateTexture(nil, "BACKGROUND")
		self.Iconbg:SetPoint("TOPLEFT", -1 , 1)
		self.Iconbg:SetPoint("BOTTOMRIGHT", 1, -1)
		self.Iconbg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")

		local Buffs = CreateFrame("Frame", nil, self)
		Buffs.initialAnchor = "TOPLEFT"
		Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
		Buffs["growth-x"] = "RIGHT"
		Buffs["growth-y"] = "DOWN"
		Buffs['spacing-x'] = 3
		Buffs['spacing-y'] = 3

		Buffs:SetHeight(22)
		Buffs:SetWidth(UF.db.arenaWidth)
		Buffs.num = UF.db.num_arena_buffs
		Buffs.size = 26

		self.Buffs = Buffs

		Buffs.PostUpdateIcon = PostUpdateIcon

		self.RaidIcon:SetPoint("LEFT", self, "RIGHT", 3, 0)
	end,
}

do
	local range = {
		insideAlpha = 1,
		outsideAlpha = .3,
	}

	UnitSpecific.party = function(self, ...)
		Shared(self, ...)

		self.disallowVehicleSwap = false

		local Health, Power = self.Health, self.Power

		local Text = S:CreateFS(Health, 10, "CENTER")
		Text:SetPoint("CENTER", 1, 0)
		self.Text = Text

		if UF.db.layout == 2 then
			Health:SetHeight(UF.db.partyHeightHealer - UF.db.powerHeight - 1)
			self:Tag(Text, '[sunuf:missinghealth]')

		else
			Health:SetHeight(UF.db.partyHeight - UF.db.powerHeight - 1)
			if UF.db.partyNameAlways then
				self:Tag(Text, '[sunuf:name]')
			else
				self:Tag(Text, '[dead][offline]')
			end
		end

		self.ResurrectIcon = self:CreateTexture(nil, "OVERLAY")
		self.ResurrectIcon:SetSize(16, 16)
		self.ResurrectIcon:SetPoint("CENTER")

		self.RaidIcon:ClearAllPoints()
		self.RaidIcon:SetPoint("CENTER", self, "CENTER")

		local Leader = S:CreateFS(self, 10, "LEFT")
		Leader:SetText("l")
		Leader:SetPoint("TOPLEFT", Health, 2, -1)

		self.Leader = Leader

		local MasterLooter = S:CreateFS(self, 10, "RIGHT")
		MasterLooter:SetText("m")
		MasterLooter:SetPoint("TOPRIGHT", Health, 1, 0)

		self.MasterLooter = MasterLooter

		local rc = self:CreateTexture(nil, "OVERLAY")
		rc:SetPoint("TOPLEFT", Health)
		rc:SetSize(16, 16)

		self.ReadyCheck = rc

		local UpdateLFD = function(self, event)
			local lfdrole = self.LFDRole
			local role = UnitGroupRolesAssigned(self.unit)

			if role == "DAMAGER" then
				lfdrole:SetTextColor(1, .1, .1, 1)
				lfdrole:SetText(".")
			elseif role == "TANK" then
				lfdrole:SetTextColor(.3, .4, 1, 1)
				lfdrole:SetText("x")
			elseif role == "HEALER" then
				lfdrole:SetTextColor(0, 1, 0, 1)
				lfdrole:SetText("+")
			else
				lfdrole:SetTextColor(0, 0, 0, 0)
			end
		end

		local lfd = S:CreateFS(Health, 10, "CENTER")
		lfd:SetPoint("BOTTOM", Health, 1, 1)
		lfd.Override = UpdateLFD

		self.LFDRole = lfd

		if UF.db.layout == 2 then
			local Debuffs = CreateFrame("Frame", nil, self)
			Debuffs.initialAnchor = "CENTER"
			Debuffs:SetPoint("BOTTOM", 0, UF.db.powerHeight - 1)
			Debuffs["growth-x"] = "RIGHT"
			Debuffs["spacing-x"] = 3

			Debuffs:SetHeight(16)
			Debuffs:SetWidth(37)
			Debuffs.num = 2
			Debuffs.size = 16

			self.Debuffs = Debuffs

			Debuffs.PostCreateIcon = function(icons, index)
				index:EnableMouse(false)
			end

			-- Import the global table for faster usage
			local hideDebuffs = UF.hideDebuffs

			Debuffs.CustomFilter = function(_, _, _, _, _, _, _, _, _, _, caster, _, _, spellID)
				if hideDebuffs[spellID] then
					return false
				end
				return true
			end

			Debuffs.PostUpdate = function(icons)
				local vb = icons.visibleDebuffs

				if vb == 2 then
					Debuffs:SetPoint("BOTTOM", -9, 0)
				else
					Debuffs:SetPoint("BOTTOM")
				end
			end

			Debuffs.PostUpdateIcon = function(icons, unit, icon, index, _, filter)
				local _, _, _, _, dtype = UnitAura(unit, index, icon.filter)
				if dtype and UnitIsFriend("player", unit) then
					local color = DebuffTypeColor[dtype]
					icon.bg:SetVertexColor(color.r, color.g, color.b)
				else
					icon.bg:SetVertexColor(0, 0, 0)
				end
				icon:EnableMouse(false)
			end

			local Buffs = CreateFrame("Frame", nil, self)
			Buffs.initialAnchor = "CENTER"
			Buffs:SetPoint("TOP", 0, -2)
			Buffs["growth-x"] = "RIGHT"
			Buffs["spacing-x"] = 3

			Buffs:SetSize(43, 12)
			Buffs.num = 3
			Buffs.size = 12

			self.Buffs = Buffs

			Buffs.PostCreateIcon = function(icons, index)
				index:EnableMouse(false)
				index.cd.noshowcd = true
			end

			Buffs.PostUpdateIcon = function(_, _, icon)
				icon:EnableMouse(false)
			end

			local myBuffs = UF.myBuffs
			local allBuffs = UF.allBuffs

			Buffs.CustomFilter = function(_, _, _, _, _, _, _, _, _, _, caster, _, _, spellID)
				if (caster == "player" and myBuffs[spellID]) or allBuffs[spellID] then
					return true
				end
			end

			Buffs.PostUpdate = function(icons)
				local vb = icons.visibleBuffs

				if vb == 3 then
					Buffs:SetPoint("TOP", -15, -2)
				elseif vb == 2 then
					Buffs:SetPoint("TOP", -7, -2)
				else
					Buffs:SetPoint("TOP", 0, -2)
				end
			end
		end

		local Threat = CreateFrame("Frame", nil, self)
		self.Threat = Threat
		Threat.Override = UpdateThreat

		if UF.db.layout == 2 then
			local select = CreateFrame("Frame", nil, self)
			select:RegisterEvent("PLAYER_TARGET_CHANGED")
			select:SetScript("OnEvent", updateNameColourAlt)
		end

		self.Range = range
	end
end

--[[ Register and activate style ]]

oUF:RegisterStyle("SunUF", Shared)
for unit,layout in next, UnitSpecific do
	oUF:RegisterStyle('SunUF - ' .. unit:gsub("^%l", string.upper), layout)
end

local spawnHelper = function(self, unit, ...)
	if(UnitSpecific[unit]) then
		self:SetActiveStyle('SunUF - ' .. unit:gsub("^%l", string.upper))
	elseif(UnitSpecific[unit:match('[^%d]+')]) then -- boss1 -> boss
		self:SetActiveStyle('SunUF - ' .. unit:match('[^%d]+'):gsub("^%l", string.upper))
	else
		self:SetActiveStyle'SunUF'
	end

	local object = self:Spawn(unit)
	object:SetPoint(...)
	return object
end

local function round(x)
	return floor(x + .5)
end

function UF:initLayout()
	
	oUF:Factory(function(self)
		
		local player, target, focus, pet
		
		player = spawnHelper(self, 'player', unpack({"BOTTOM", "UIParent", "BOTTOM", -175, 172}))
		S:CreateMover(player, "PlayFrameMover", L["玩家"], true, nil, "ALL,UNITFRAMES")
		
		target = spawnHelper(self, 'target', unpack({"BOTTOM", "UIParent", "BOTTOM",  175,  172}))
		S:CreateMover(target, "TargetFrameMover", L["目标"], true, nil, "ALL,UNITFRAMES")
		
		focus = spawnHelper(self, 'focus', "BOTTOMRIGHT", player, "TOPRIGHT", 0, S["media"].fontsize + 7)
		S:CreateMover(focus, "FocusFrameMover", L["焦点"], true, nil, "ALL,UNITFRAMES")
		
		pet = spawnHelper(self, 'pet', "BOTTOMLEFT", player, "TOPLEFT", 0, S["media"].fontsize + 7)
		S:CreateMover(pet, "PetFrameMover", L["宠物"], true, nil, "ALL,UNITFRAMES")
		
		if UF.db.targettarget then
			local tot = spawnHelper(self, 'targettarget', "BOTTOM", target, "TOP", 0, S["media"].fontsize + 7)
			S:CreateMover(tot, "ToTFrameMover", L["目标的目标"], true, nil, "ALL,UNITFRAMES")
		end

		for n = 1, MAX_BOSS_FRAMES do
			local boss = spawnHelper(self, 'boss' .. n, 'LEFT', 50, 0 - (56 * n))
			S:CreateMover(boss, "Boss"..n.."FrameMover", L["Boss"]..n, true, nil, "ALL,UNITFRAMES")
		end

		if UF.db.enableArena then
			for n = 1, 5 do
				local are = spawnHelper(self, 'arena' .. n, 'LEFT', 50, -14 - (56 * n))
				S:CreateMover(are, "Arena"..n.."FrameMover", L["竞技场"]..n, true, nil, "ALL,UNITFRAMES")
			end
		end
	end)
end