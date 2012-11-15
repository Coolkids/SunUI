local S, C, L, DB = unpack(select(2, ...))
local _
if IsAddOnLoaded("TidyPlates") or IsAddOnLoaded("Aloft") or IsAddOnLoaded("dNamePlates") or IsAddOnLoaded("caelNamePlates") then
	return
end

local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("NamePlates")
local   cfg={
	TotemIcon = true, 				-- Toggle totem icons
	TotemSize = 20,				-- Totem icon size
}
local noscalemult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")
local OVERLAY = "Interface\\TargetingFrame\\UI-TargetingFrame-Flash"
local blankTex = "Interface\\Buttons\\WHITE8x8"	

local backdrop = {
	edgeFile = DB.GlowTex, edgeSize = 3,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
}

local numChildren = -1
local frames = {}

local NamePlates = CreateFrame("Frame")
NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
local f = CreateFrame"Frame"
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", function(self, event)
	if(event=="PLAYER_LOGIN") then
		SetCVar("bloatthreat",0)
		SetCVar("bloattest",0)
		SetCVar("bloatnameplates",0.0)
		SetCVar("ShowClassColorInNameplate",1)
	end
end)

local PlateBlacklist = {
	--亡者大軍
	["亡者军团食尸鬼"] = true,
	["食屍鬼大軍"] = true,
	["Army of the Dead Ghoul"] = true,

	--陷阱
	["Venomous Snake"] = true,
	["毒蛇"] = true,
	["剧毒蛇"] = true,

	["Viper"] = true,
	["響尾蛇"] = true,
	
	--Misc
	["Lava Parasite"] = true,
	["熔岩蟲"] = true,
	["熔岩寄生虫"] = true,
	--DS
	["腐化之血"] = S.IsCoolkid(),
}
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

local function SVal(val)
	if(val >= 1e6) then
		return round(val/1e6,1).."m"
	elseif(val >= 1e3) then
		return round(val/1e3,1).."k"
	else
		return val
	end
end

local function QueueObject(parent, object)
	parent.queue = parent.queue or {}
	parent.queue[object] = true
end

local function HideObjects(parent)
	for object in pairs(parent.queue) do
		if object:GetObjectType() == "Texture" then
			object:SetTexture(nil)
			object.SetTexture = function() end
		elseif object:GetObjectType() == "FontString" then
			object.ClearAllPoints = function() end
			object.SetFont = function() end
			object.SetPoint = function() end
			object:Hide()
			object.Show = function() end
			object.SetText = function() end
			object.SetShadowOffset = function() end
		else
			object:Hide()
			object.Show = function() end
		end
	end
end
local totems = {
	[GetSpellInfo(2484)] = [[Interface\Icons\Spell_nature_strengthofearthtotem02]],
	[GetSpellInfo(8143)] = [[Interface\Icons\Spell_nature_tremortotem]],	
	[GetSpellInfo(16190)] = [[Interface\Icons\Spell_frost_summonwaterelemental]],	
	[GetSpellInfo(8177)] = [[Interface\Icons\Spell_nature_groundingtotem]],	
	[GetSpellInfo(2062)] = [[Interface\Icons\Spell_nature_earthelemental_totem]],
	[GetSpellInfo(2894)] = [[Interface\Icons\spell_fire_elemental_totem]],	
	[GetSpellInfo(98008)] = [[Interface\Icons\spell_shaman_spiritlink]],	
	[GetSpellInfo(3599)] = [[Interface\Icons\Spell_fire_searingtotem]],
	[GetSpellInfo(8190)] = [[Interface\Icons\Spell_fire_selfdestruct]],
	[GetSpellInfo(5394)] = [[Interface\Icons\Inv_spear_04]],
}

local function UpdateThreat(frame,elapsed)
	if(frame.region:IsShown()) then
		local _, val = frame.region:GetVertexColor()
		if(val > 0.7) then
			frame.name:SetTextColor(1, 1, 0)
		else
			frame.name:SetTextColor(1, 0, 0)
		end
	else
		frame.name:SetTextColor(1, 1, 1)
	end
	frame.hp:SetStatusBarColor(frame.r, frame.g, frame.b)
	
	if not frame.oldglow:IsShown() then
		frame.hp.hpGlow:SetBackdropBorderColor(0, 0, 0)
		frame.hp.border:SetBackdropBorderColor(0, 0, 0, 1)
	else
		local r, g, b = frame.oldglow:GetVertexColor()
		frame.hp.hpGlow:SetBackdropBorderColor(r, g, b)
		frame.hp.border:SetBackdropBorderColor(0, 0, 0, 0)
	end
	
	-- show current health value
    local minHealth, maxHealth = frame.healthOriginal:GetMinMaxValues()
    local valueHealth = frame.healthOriginal:GetValue()
	local d =(valueHealth/maxHealth)*100

		if(d < 100) and valueHealth > 1 then
			--frame.hp.value:SetText(SVal(valueHealth))
			frame.hp.pct:SetText(format("%.1f %s",d,"%"))
		else
			--frame.hp.value:SetText("")
			frame.hp.pct:SetText("")
		end

		if(d <= 35 and d >= 25) then
			--frame.hp.value:SetTextColor(253/255, 238/255, 80/255)
			frame.hp.pct:SetTextColor(253/255, 238/255, 80/255)
		elseif(d < 25 and d >= 20) then
			--frame.hp.value:SetTextColor(250/255, 130/255, 0/255)
			frame.hp.pct:SetTextColor(250/255, 130/255, 0/255)
		elseif(d < 20) then
			--frame.hp.value:SetTextColor(200/255, 20/255, 40/255)
			frame.hp.pct:SetTextColor(200/255, 20/255, 40/255)
		else
			--frame.hp.value:SetTextColor(1,1,1)
			frame.hp.pct:SetTextColor(1,1,1)
		end	
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
	button:Width(20)
	button:Height(20)

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
	elseif s >= minute / 12 then
		return floor(s)
	end
	
	return format("%.1f", s)
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
			if self.timeLeft <= 5 then
				self.text:SetTextColor(1, 0, 0)
			elseif self.timeLeft <= minute then
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
	if not frame.icons or not frame.unit or not C["Showdebuff"] then return end  --
	local i = 1
	for index = 1,40 do
		if i > C["HPWidth"] / 20 then return end
		local match
		local name,_,_,_,_,duration,_,caster,_,_,spellid = UnitAura(frame.unit,index,"HARMFUL")
		
		if caster == "player" and duration>0 then match = true end
		if DebuffWhiteList[name] then match = true end
		if DebuffBlackList[name] then match = false end
		if duration and match == true then
			if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
			local icon = frame.icons[i]
			if i == 1 then icon:Point("RIGHT",frame.icons,"RIGHT") end
			if i ~= 1 and i <= C["HPWidth"] / 20 then icon:Point("RIGHT", frame.icons[i-1], "LEFT", -2, 0) end
			i = i + 1
			UpdateAuraIcon(icon, frame.unit, index, "HARMFUL")
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

local function UpdateObjects(frame)
	frame = frame:GetParent()
	local r, g, b = frame.hp:GetStatusBarColor()
		local newr, newg, newb
		if g + b == 0 then
			newr, newg, newb = 0.7, 0.2, 0.1
			frame.hp:SetStatusBarColor(0.7, 0.2, 0.1)
		elseif r + b == 0 then
			newr, newg, newb = 0.2, 0.6, 0.1
			frame.hp:SetStatusBarColor(0.2, 0.6, 0.1)
		elseif r + g == 0 then
			newr, newg, newb = 0.31, 0.45, 0.63
			frame.hp:SetStatusBarColor(0.31, 0.45, 0.63)
		elseif 2 - (r + g) < 0.05 and b == 0 then
			newr, newg, newb = 0.71, 0.71, 0.35
			frame.hp:SetStatusBarColor(0.71, 0.71, 0.35)
		else
			newr, newg, newb = r, g, b
		end
	frame.r, frame.g, frame.b = newr, newg, newb
	
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(C["HPWidth"], C["HPHeight"])	
	frame.hp:SetPoint('CENTER', frame, 0, 10)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)
	
	frame.name:SetText(frame.oldname:GetText())
	
	frame.highlight:ClearAllPoints()
	frame.highlight:SetAllPoints(frame.hp)

	-- color hp bg dependend on hp color
    --local BGr, BGg, BGb = frame.hp:GetStatusBarColor()
	--frame.hp.hpbg2:SetVertexColor(BGr*0.18, BGg*0.18, BGb*0.18)
	
	local level, elite, mylevel = tonumber(frame.level:GetText()), frame.elite:IsShown(), UnitLevel("player")
	local lvlr, lvlg, lvlb = frame.level:GetTextColor()
	frame.level:ClearAllPoints()
	frame.level:SetPoint("RIGHT", frame.hp, "LEFT", -2, 0)
	frame.level:Hide()
	if frame.boss:IsShown() then
		frame.level:SetText("B")
		frame.name:SetText('|cffDC3C2D'..frame.level:GetText()..'|r '..frame.oldname:GetText())
	elseif not elite and level == mylevel then
		frame.name:SetText(frame.oldname:GetText())
	else
		frame.level:SetText(level..(elite and "+" or ""))
		frame.name:SetText(format('|cff%02x%02x%02x', lvlr*255, lvlg*255, lvlb*255)..frame.level:GetText()..'|r '..frame.oldname:GetText())
	end
	
	if frame.icons then return end
	frame.icons = CreateFrame("Frame",nil,frame)
	frame.icons:Point("BOTTOMRIGHT",frame.hp,"TOPRIGHT", 0, FONTSIZE)
	frame.icons:Width(20 + C["HPWidth"])
	frame.icons:Height(25)
	frame.icons:SetFrameLevel(frame.hp:GetFrameLevel()+2)
	frame:RegisterEvent("UNIT_AURA")
	frame:HookScript("OnEvent", OnAura)
	
	HideObjects(frame)
	
	if cfg.TotemIcon then 
		if totems[frame.oldname:GetText()] then		
			if not frame.totem then
				frame.icon:SetTexCoord(.08, .92, .08, .92)
				frame.totem = true
			end
			if frame.name ~= name then
				frame.icon:Show()
				frame.Ticon:Show()
				frame.icon:SetTexture(totems[frame.oldname:GetText()])
				--frame.name:ClearAllPoints()
			end
		else
			if frame.totem then
				frame.icon:Hide()
				frame.Ticon:Hide()
				frame.icon:SetTexture()
				frame.totem = nil
			end
		end
	end
end

local function UpdateCastbar(frame)
    frame.border:ClearAllPoints()
    frame.border:SetPoint("TOP",frame:GetParent().hp,"BOTTOM", 0,-5)
	frame.border:SetSize(C["HPWidth"], C["CastBarHeight"])
    frame:SetPoint("RIGHT",frame.border,0,0)
    frame:SetPoint("TOP",frame.border,0,0)
    frame:SetPoint("BOTTOM",frame.border,0,0)
    frame:SetPoint("LEFT",frame.border,0,0)

	if not frame.shield:IsShown() then
		frame:SetStatusBarColor(.5,.65,.85)
	else
		frame:SetStatusBarColor(1,0,0)
	end
end	

local OnValueChanged = function(self)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
	-- have to define not protected casts colors again due to some weird bug reseting colors when you start channeling a spell 
 	if not self.shield:IsShown() then
		self:SetStatusBarColor(.5,.65,.85)
	else
		--self:SetStatusBarColor(1,.49,0)
		self:SetStatusBarColor(1,0,0)
	end 
end

local OnSizeChanged = function(self)
	self.needFix = true
end
-- We need to reset everything when a nameplate it hidden 重置所有框体内容
local function OnHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.unit = nil
	frame.guid = nil
	frame.hasClass = nil
	frame.isFriendly = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
	if frame.icons then
		for _, icon in ipairs(frame.icons) do
			icon:Hide()
		end
	end

	frame:SetScript("OnUpdate", nil)
end
local function SkinObjects(frame)
	local hp, cb = frame:GetChildren()

	local threat, hpborder, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()
	local _, cbborder, cbshield, cbicon = cb:GetRegions()
	
	frame.healthOriginal = hp
	
	overlay:SetTexture(DB.Statusbar)
	overlay:SetVertexColor(0.25, 0.25, 0.25)
	frame.highlight = overlay
	
	hp:HookScript('OnShow', UpdateObjects)
	hp:SetStatusBarTexture(DB.Statusbar)
	frame.hp = hp
	hp:CreateShadow()
	hp.hpGlow = hp.shadow
	S.CreateBack(hp)
	-- hp.hpGlow = CreateFrame("Frame", nil, hp)
	-- hp.hpGlow:SetPoint("TOPLEFT", hp, "TOPLEFT", -3.5, 3.5)
	-- hp.hpGlow:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", 3.5, -3.5)
	-- hp.hpGlow:SetBackdrop(backdrop)
	-- hp.hpGlow:SetBackdropColor(0, 0, 0)
	-- hp.hpGlow:SetBackdropBorderColor(0, 0, 0)

	-- pixel art starts here... making targeting border as the commented method above deforms after reloading UI
 	
	--hp.value = hp:CreateFontString(nil, "OVERLAY")	
	--hp.value:SetFont(DB.Font, C["Fontsize"]*S.Scale(1), "THINOUTLINE")
	--hp.value:SetPoint("LEFT", hp, "RIGHT", 5, 0)
	
	hp.pct = hp:CreateFontString(nil, "OVERLAY")	
	hp.pct:SetFont(DB.Font, C["Fontsize"], "THINOUTLINE")
	hp.pct:SetPoint("CENTER", hp, "CENTER", 0, 0)

	local offset = UIParent:GetScale() / cb:GetEffectiveScale()
	cb:CreateShadow()
	S.CreateBack(cb)

	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPRIGHT", hp, "TOPLEFT", -4, 1)		
	cbicon:SetSize(C["CastBarIconSize"], C["CastBarIconSize"])
	cbicon:SetTexCoord(.07, .93, .07, .93)
	S.CreateShadow(cb, cbicon)
	
	cb.icon = cbicon
	cb.shield = cbshield
	cb:HookScript('OnShow', UpdateCastbar)
	cb:HookScript('OnSizeChanged', OnSizeChanged)
	cb:HookScript('OnValueChanged', OnValueChanged)	
	cb:SetStatusBarTexture(DB.Statusbar)
	frame.cb = cb

	local name = hp:CreateFontString(nil, 'OVERLAY')
	name:SetPoint('BOTTOMLEFT', hp, 'TOPLEFT', -10, 4)
	name:SetPoint('BOTTOMRIGHT', hp, 'TOPRIGHT', 10, 4)
	name:SetFont(DB.Font, C["Fontsize"]*S.Scale(1), "THINOUTLINE")
	frame.oldname = oldname
	frame.name = name
	
	frame.level = level
	level:SetFont(DB.Font, C["Fontsize"]*S.Scale(1), "THINOUTLINE")
	--level:SetShadowOffset(1.25, -1.25)
	
	--Highlight
	overlay:SetTexture(1,1,1,0.15)
	overlay:SetAllPoints(hp)
	frame.overlay = overlay
	-- totem icon
	local icon = frame:CreateTexture(nil, "BACKGROUND")
	icon:SetPoint("CENTER", frame, 0, 38)
	icon:SetSize(cfg.TotemSize, cfg.TotemSize)
	icon:Hide()
	frame.icon = icon
	
	local Ticon = frame:CreateTexture(nil, 'BACKGROUND')
	Ticon:SetPoint('BOTTOMRIGHT', icon, offset, -offset)
	Ticon:SetPoint('TOPLEFT', icon, -offset, offset)
	Ticon:Hide()
	Ticon:SetTexture(0, 0, 0)
	frame.Ticon = Ticon
	
	frame.elite = elite
	frame.boss = bossicon
	elite:SetTexture(nil)
	bossicon:SetTexture(nil)
	
	raidicon:ClearAllPoints()
	raidicon:SetPoint("BOTTOM", name, "TOP", 0, 0)
	raidicon:SetSize(C["CastBarIconSize"]+4, C["CastBarIconSize"]+4)	

	frame.oldglow = threat
	threat:SetTexture(nil)
	
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, oldname)

	UpdateObjects(hp)
	UpdateCastbar(cb)
	frame:HookScript("OnHide", OnHide)
	frames[frame] = true
end
local function CheckBlacklist(frame, ...)
	if PlateBlacklist[frame.oldname:GetText()] then
		frame:SetScript("OnUpdate", function() end)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.hp.oldlevel:Hide()
	end
end
local function CheckUnit_Guid(frame, ...)
	--local numParty, numRaid = GetNumPartyMembers(), GetNumRaidMembers()
	if UnitExists("target") and frame:GetAlpha() == 1 and UnitName("target") == frame.oldname:GetText() then
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
--dead
local function MatchDDeadGUID(frame, destGUID)
	--print(frame, destGUID, spellID)
	if not frame.guid then return end
	if frame.guid == destGUID then
		for k,icon in ipairs(frame.icons) do 
			if icon.spellID then
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
		local region = frame:GetRegions()
		
		if(not frames[frame] and (frame:GetName() and not frame.isSkinned and frame:GetName():find("NamePlate%d")) and region and region:GetObjectType() == 'Texture') then
			SkinObjects(frame)
			frame.region = region
			frame.isSkinned = true
		end
	end
end

function NamePlates:COMBAT_LOG_EVENT_UNFILTERED(_, event, ...)
	if event == "SPELL_AURA_REMOVED" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...
		if sourceGUID == UnitGUID("player") then
			ForEachPlate(MatchGUID, destGUID, spellID)
		end
	end
end
NamePlates:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

function Module:OnInitialize()
	C = C["NameplateDB"]
	if C["enable"] ~= true then return end
	CreateFrame('Frame'):SetScript('OnUpdate', function(self, elapsed)
		if(WorldFrame:GetNumChildren() ~= numChildren) then
			numChildren = WorldFrame:GetNumChildren()
			HookFrames(WorldFrame:GetChildren())
		end
		if(self.elapsed and self.elapsed > 0.1) then
			--for frame in pairs(frames) do
				ForEachPlate(UpdateThreat, self.elapsed)
				--UpdateThreat(frame)
				--UpdateTarget(frame)
			--end
			self.elapsed = 0
		else
			self.elapsed = (self.elapsed or 0) + elapsed
		end

		ForEachPlate(CheckBlacklist)
		ForEachPlate(CheckUnit_Guid)
	end)
	if C["Combat"] then
		function NamePlates:PLAYER_REGEN_DISABLED()
			SetCVar("nameplateShowEnemies", 1)
		end
	end
	if C["NotCombat"] then
		function NamePlates:PLAYER_REGEN_ENABLED()
			SetCVar("nameplateShowEnemies", 0)
		end
	end
end