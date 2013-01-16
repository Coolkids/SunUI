local S, L, DB, _, C = unpack(select(2, ...))
local N = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("NamePlates", "AceEvent-3.0", "AceTimer-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local LSM = LibStub("LibSharedMedia-3.0", true)

local noscalemult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")
local OVERLAY = "Interface\\TargetingFrame\\UI-TargetingFrame-Flash"
local blankTex = "Interface\\Buttons\\WHITE8x8"	

local backdrop = {
	edgeFile = DB.GlowTex, edgeSize = 3,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
}

local numChildren = -1
local frames = {}

local DebuffWhiteList = {
	-- Death Knight
		[GetSpellInfo(47476)] = true, --strangulate
	-- Druid
		[GetSpellInfo(33786)] = true, --Cyclone
		[GetSpellInfo(2637)] = true, --Hibernate
		[GetSpellInfo(339)] = true, --Entangling Roots
		[GetSpellInfo(80964)] = true, --Skull Bash
		[GetSpellInfo(78675)] = true, --Solar Beam
	-- Hunter
		[GetSpellInfo(3355)] = true, --Freezing Trap Effect
		--[GetSpellInfo(60210)] = true, --Freezing Arrow Effect
		[GetSpellInfo(1513)] = true, --scare beast
		[GetSpellInfo(19503)] = true, --scatter shot
		[GetSpellInfo(34490)] = true, --silence shot
	-- Mage
		[GetSpellInfo(31661)] = true, --Dragon's Breath
		[GetSpellInfo(61305)] = true, --Polymorph
		[GetSpellInfo(122)] = true, --Frost Nova
		[GetSpellInfo(82691)] = true, --Ring of Frost
	-- Paladin
		[GetSpellInfo(20066)] = true, --Repentance
		[GetSpellInfo(10326)] = true, --Turn Evil
		[GetSpellInfo(853)] = true, --Hammer of Justice
	-- Priest
		[GetSpellInfo(605)] = true, --Mind Control
		[GetSpellInfo(64044)] = true, --Psychic Horror
		[GetSpellInfo(8122)] = true, --Psychic Scream
		[GetSpellInfo(9484)] = true, --Shackle Undead
		[GetSpellInfo(15487)] = true, --Silence
	-- Rogue
		[GetSpellInfo(2094)] = true, --Blind
		[GetSpellInfo(1776)] = true, --Gouge
		[GetSpellInfo(6770)] = true, --Sap
	-- Shaman
		[GetSpellInfo(51514)] = true, --Hex
		[GetSpellInfo(3600)] = true, --Earthbind
		[GetSpellInfo(8056)] = true, --Frost Shock
		[GetSpellInfo(63685)] = true, --Freeze
	-- Warlock
		[GetSpellInfo(710)] = true, --Banish
		[GetSpellInfo(6789)] = true, --Death Coil
		[GetSpellInfo(5782)] = true, --Fear
		[GetSpellInfo(5484)] = true, --Howl of Terror
		[GetSpellInfo(6358)] = true, --Seduction
		[GetSpellInfo(30283)] = true, --Shadowfury
	-- Warrior
		[GetSpellInfo(20511)] = true, --Intimidating Shout
	-- Racial
		[GetSpellInfo(25046)] = true, --Arcane Torrent
		[GetSpellInfo(20549)] = true, --War Stomp
	--PVE
}
local DebuffBlackList = {
	[GetSpellInfo(15407)] = true,
}
-- format numbers
local function round(val, idp)
  if idp and idp > 0 then
    local mult = 10^idp
    return math.floor(val * mult + 0.5) / mult
  end
  return math.floor(val + 0.5)
end

local function UpdateAuraAnchors(frame)
	for i = 1, 5 do
		if frame.icons and frame.icons[i] and frame.icons[i]:IsShown() then
			if frame.icons.lastShown then 
				frame.icons[i]:Point("RIGHT", frame.icons.lastShown, "LEFT", -2, 0)
			else
				frame.icons[i]:Point("RIGHT",frame.icons,"RIGHT")
			end
			frame.icons.lastShown = frame.icons[i]
		end
	end
	
	frame.icons.lastShown = nil;
end
--Create our Aura Icons
local function CreateAuraIcon(parent)
	local button = CreateFrame("Frame",nil,parent)
	button:SetScript("OnHide", function(self) UpdateAuraAnchors(self:GetParent()) end)
	button:Width(C["IconSize"])
	button:Height(C["IconSize"])

	button.shadow = CreateFrame("Frame", nil, button)
	button.shadow:SetFrameLevel(0)
	button.shadow:Point("TOPLEFT", -2*noscalemult, 2*noscalemult)
	button.shadow:Point("BOTTOMRIGHT", 2*noscalemult, -2*noscalemult)
	button.shadow:SetBackdrop( { 
		edgeFile = DB.GlowTex,
		bgFile = DB.Solid,
		edgeSize = S.Scale(4),
		insets = {left = S.Scale(4), right = S.Scale(4), top = S.Scale(4), bottom = S.Scale(4)},
	})
	button.shadow:SetBackdropColor( 0, 0, 0 )
	button.shadow:SetBackdropBorderColor( 0, 0, 0 )
	
	button.bord = button:CreateTexture(nil, "BORDER")
	button.bord:SetTexture(0, 0, 0, 1)
	button.bord:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult,-noscalemult)
	button.bord:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult,noscalemult)
	
	button.bg2 = button:CreateTexture(nil, "ARTWORK")
	button.bg2:SetTexture( .05, .05, .05, .9)
	button.bg2:Point("TOPLEFT",button,"TOPLEFT", noscalemult*2,-noscalemult*2)
	button.bg2:Point("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult*2,noscalemult*2)	
	
	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:Point("TOPLEFT",button,"TOPLEFT", noscalemult*3,-noscalemult*3)
	button.icon:Point("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult*3,noscalemult*3)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.text = button:CreateFontString(nil, 'OVERLAY')
	button.text:Point("CENTER", 1, 1)
	button.text:SetJustifyH('CENTER')
	button.text:SetFont(DB.Font, 10, "OUTLINE")
	button.text:SetShadowColor(0, 0, 0, 0)

	button.count = button:CreateFontString(nil,"OVERLAY")
	button.count:SetFont(DB.Font, 9, "OUTLINE")
	button.count:SetShadowColor(0, 0, 0, 0.4)
	button.count:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 0)
	return button
end

local day, hour, minute, second = 86400, 3600, 60, 1
local function formatTime(s)
	if s >= day then
		return format("%dd", ceil(s / hour))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	end
	return format("%.f", s)
end

local function UpdateAuraTimer(self, elapsed)
	if not self.timeLeft then return end
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.1 then
		if not self.firstUpdate then
			self.timeLeft = self.timeLeft - self.elapsed
		else
			self.timeLeft = self.timeLeft - GetTime()
			self.firstUpdate = false
		end
		if self.timeLeft > 0 then
			local time = formatTime(self.timeLeft)
			self.text:SetText(time)
			if self.timeLeft <= minute then
				self.text:SetTextColor(1, 1, 0)
			else
				self.text:SetTextColor(1, 1, 1)
			end
		else
			self.text:SetText('')
			self:SetScript("OnUpdate", nil)
			self:Hide()
		end
		self.elapsed = 0
	end
end

--Update an Aura Icon
local function UpdateAuraIcon(button, unit, index, filter)
	local name,_,icon,count,debuffType,duration,expirationTime,_,_,_,spellID = UnitAura(unit,index,filter)
	
	if debuffType then
		button.bord:SetTexture(DebuffTypeColor[debuffType].r, DebuffTypeColor[debuffType].g, DebuffTypeColor[debuffType].b)
	else
		button.bord:SetTexture(1, 0, 0, 1)
	end

	button.icon:SetTexture(icon)
	button.firstUpdate = true
	button.expirationTime = expirationTime
	button.duration = duration
	button.spellID = spellID	
	button.timeLeft = expirationTime
	if count > 1 then 
		button.count:SetText(count)
	else
		button.count:SetText("")
	end
	if not button:GetScript("OnUpdate") then
		button:SetScript("OnUpdate", UpdateAuraTimer)
	end
	button:Show()
end

--Filter auras on nameplate, and determine if we need to update them or not.
local function OnAura(frame, unit)
	if not frame.icons or not frame.unit or not C["Showdebuff"] then return end
	--print(unit)
	local i = 1
	for index = 1,40 do
		if i > 110 / C["IconSize"] then return end
		local match
		local name,_,_,_,_,duration,_,caster,_,_,spellid = UnitAura(frame.unit,index,"HARMFUL")
		
		if caster == "player" and duration>0 then match = true end
		if DebuffWhiteList[name] then match = true end
		if DebuffBlackList[name] then match = false end
		if duration and match == true then
			if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
			local icon = frame.icons[i]
			if i == 1 then icon:Point("RIGHT",frame.icons,"RIGHT") end
			if i ~= 1 and i <= 110 / C["IconSize"] then icon:Point("RIGHT", frame.icons[i-1], "LEFT", -2, 0) end
			i = i + 1
			UpdateAuraIcon(icon, frame.unit, index, "HARMFUL")
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

local function UpdateObjects(frame)
	--print("新建框体")
	if frame.icons then return end
	frame.icons = CreateFrame("Frame",nil, frame)
	frame.icons:SetPoint("BOTTOMRIGHT",frame,"TOPRIGHT", -15, 0)
	frame.icons:Width(C["IconSize"] + 110)
	frame.icons:Height(C["IconSize"])
	frame.icons:SetFrameLevel(frame:GetFrameLevel()+2)
	frame:HookScript("OnEvent", OnAura)
end

-- We need to reset everything when a nameplate it hidden 重置所有框体内容
local function OnHide(frame)
	--print(frame.icons)
	if frame.icons then
		for _, icon in ipairs(frame.icons) do
			icon:Hide()
		end
	end
	frame:SetScript("OnUpdate", nil)
end
local function SkinObjects(frame, nameFrame)
	local hp, cb = frame:GetChildren()
	local threat, hpborder, overlay, level, bossicon, raidicon, elite = frame:GetRegions()
	local oldname = nameFrame:GetRegions()
	
	frame.overlay = overlay
	frame.oldname = oldname
	frame:RegisterEvent("UNIT_AURA")
	UpdateObjects(frame)
	frame:HookScript("OnHide", OnHide)
	frames[frame] = true
end

local function CheckUnit_Guid(frame, ...)
	--local numParty, numRaid = GetNumPartyMembers(), GetNumRaidMembers()
	if UnitExists("target") and frame:GetParent():GetAlpha() == 1 and UnitName("target") == frame.oldname:GetText() then
		frame.guid = UnitGUID("target")
		frame.unit = "target"
		OnAura(frame, "target")
	elseif frame.overlay:IsShown() and UnitExists("mouseover") and UnitName("mouseover") == frame.oldname:GetText() then
		frame.guid = UnitGUID("mouseover")
		frame.unit = "mouseover"
		OnAura(frame, "mouseover")
	else
		frame.unit = nil
	end	
end
--Attempt to match a nameplate with a GUID from the combat log
local function MatchGUID(frame, destGUID, spellID)
	--print(frame, destGUID, spellID)
	if not frame.guid then return end
	if frame.guid == destGUID then
		for k,icon in ipairs(frame.icons) do 
			if icon.spellID == spellID then
				--print("Hide",frame.oldname:GetText(),GetSpellLink(icon.spellID))
				icon:Hide()
			end 
		end
	end
end

--Run a function for all visible nameplates, we use this for the blacklist, to check unitguid, and to hide drunken text
local function ForEachPlate(functionToRun, ...)
	for frame in pairs(frames) do
		if frame:IsShown() then
			functionToRun(frame, ...)
		end
	end
end
local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
	
		if not frames[frame] and (frame:GetName() and not frame.isSkinned and frame:GetName():find("NamePlate%d")) then
			SkinObjects(frame:GetChildren())
			frame.isSkinned = true
		end
	end
end

function N:COMBAT_LOG_EVENT_UNFILTERED(times, temp, event, ...)
	
	if event == "SPELL_AURA_REMOVED" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...
		--print(sourceGUID,UnitGUID("player"))
		if sourceGUID == UnitGUID("player") then
			--print(spellID)
			ForEachPlate(MatchGUID, destGUID, spellID)
		end
	end
end
local function SetCV()
	SetCVar("bloatthreat",0)
	SetCVar("bloattest",0)
	SetCVar("bloatnameplates",0.0)
	SetCVar("ShowClassColorInNameplate",1)
end

function N:OnInitialize()
		--if IsAddOnLoaded("TidyPlates") or IsAddOnLoaded("Aloft") or IsAddOnLoaded("dNamePlates") or IsAddOnLoaded("caelNamePlates") or IsAddOnLoaded("Kui_Nameplates") then
		--	return
		--end
	C = SunUIConfig.db.profile.NameplateDB
	if C["enable"] ~= true then return end
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetScript("OnUpdate", function(self, elapsed)
		if WorldFrame:GetNumChildren() ~= numChildren then
			numChildren = WorldFrame:GetNumChildren()
			HookFrames(WorldFrame:GetChildren())
		end
		ForEachPlate(CheckUnit_Guid)
	end)
	N:RegisterEvent("PLAYER_LOGIN", SetCV)
	N:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	if C["Combat"] then
		N:RegisterEvent("PLAYER_REGEN_DISABLED", function()
			SetCVar("nameplateShowEnemies", 1)
		end)	
	end
	if C["NotCombat"] then
		N:RegisterEvent("PLAYER_REGEN_ENABLED", function()
			SetCVar("nameplateShowEnemies", 0)
		end)
	end
end