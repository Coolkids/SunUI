local S, L, DB, _, C = unpack(select(2, ...))
local N = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("NamePlates", "AceEvent-3.0", "AceTimer-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local LSM = LibStub("LibSharedMedia-3.0", true)
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

local PlateBlacklist = {
	--["訓練假人"] = true,
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
	--火
	[GetSpellInfo(2894)] = GetSpellTexture(2894), --火元素圖騰
	[GetSpellInfo(8190)] = GetSpellTexture(8190),--熔岩圖騰
	[GetSpellInfo(3599)] = GetSpellTexture(3599), --灼熱圖騰
	--风
	[GetSpellInfo(108269)] = GetSpellTexture(108269), --電容圖騰
	[GetSpellInfo(8177)] = GetSpellTexture(8177), --根基圖騰
	[GetSpellInfo(120668)] = GetSpellTexture(120668), --風暴鞭笞圖騰
	[GetSpellInfo(108273)] = GetSpellTexture(108273), --風行圖騰
	[GetSpellInfo(98008)] = GetSpellTexture(98008), --靈魂連結圖騰
	--地
	[GetSpellInfo(2484)] = GetSpellTexture(2484),--地縛圖騰
	[GetSpellInfo(8143)] = GetSpellTexture(8143), --戰慄圖騰
	[GetSpellInfo(2062)] = GetSpellTexture(2062), --土元素圖騰
	--水
	[GetSpellInfo(5394)] = GetSpellTexture(5394), --治療之泉圖騰
	[GetSpellInfo(108280)] = GetSpellTexture(108280), --療癒之潮圖騰
	[GetSpellInfo(16190)] = GetSpellTexture(16190), --法力之潮圖
	--test
	--["訓練假人"]  = GetSpellTexture(2894),
}
local function TotemIcon(frame)
	local totname = frame.oldname:GetText()
	if totems[totname] then		
		if not frame.totem then
			frame.icon:SetTexCoord(.08, .92, .08, .92)
			frame.totem = true
		end
		if frame.name ~= name and not frame.icon:IsShown() then
			--print("Show", GetTime())
			frame.icon:Show()
			frame.Ticon:Show()
			frame.icon:SetTexture(totems[totname])
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
--0.96 0.55 0.73 --圣骑士
--0.53333216905594 0.53333216905594 0.99999779462814
local function Color(frame)
	local r, g, b = frame.healthOriginal:GetStatusBarColor()
	--print(r, g, b)
	if r > 0.52 and r < 0.55 and r == g and b > 0.98 then   -- Tapped
		--print(r, g, b)
		r, g, b = 0.6, 0.6, 0.6
		--print(123)
	elseif g + b == 0 then
		r, g, b = 0.7, 0.2, 0.1
	elseif r + b == 0 then
		r, g, b = 0.1, 0.6, 0.1
	elseif r + g == 0 then
		r, g, b = 0.31, 0.45, 0.63
	elseif 2 - (r + g) < 0.05 and b == 0 then
		r, g, b = 0.71, 0.71, 0.35
	else
	end
	frame.r, frame.g, frame.b = r, g, b
	--S.CreateTop(texture, r, g, b)
	S.CreateTop(frame.hp:GetStatusBarTexture(), r, g, b)
end

local function UpdateThreat(frame, elapsed)
	
	if(frame.threat:IsShown()) then
		local r, g, b = frame.threat:GetVertexColor()
		frame.hp.shadow:Show()
		--print(r, g,b)
		if g + b == 0 then
			if DB.Role == "Tank" then
				S.CreateTop(frame.hp:GetStatusBarTexture(), .2, .6, .1)
			else
				frame.name:SetTextColor(1, 0.2, 0.2)
				frame.hp.shadow:SetBackdropBorderColor(1, 0.2, 0.2, 1)
			end
		else
			if DB.Role == "Tank" then
				--print(1213)
				S.CreateTop(frame.hp:GetStatusBarTexture(), 240/255, 154/255, 17/255)
			else
				frame.name:SetTextColor(1, 1, 0)
				frame.hp.shadow:SetBackdropBorderColor(1, 1, 0, 1)
			end
		end
	else
		if InCombatLockdown() and DB.Role == "Tank" then
			S.CreateTop(frame.hp:GetStatusBarTexture(), .7, .2, .1)   --bad
		else
			frame.hp.shadow:Hide()
			frame.name:SetTextColor(1, 1, 1)
		end
	end
	--print(frame.r, frame.g, frame.b)
end
local function ShowHealth(frame)
	local minHealth, maxHealth = frame.healthOriginal:GetMinMaxValues()
    local valueHealth = frame.healthOriginal:GetValue()
	local d =(valueHealth/maxHealth)*100
	frame.hp:SetMinMaxValues(minHealth, maxHealth)
	frame.hp:SetValue(valueHealth)
	frame.hp.pct:SetText(format("%.0f %s",d,"%"))

	if cfg.TotemIcon then
		TotemIcon(frame)
	end
end
local function AdjustNameLevel(frame, ...)
	if UnitName("target") == frame.name:GetText() and frame:GetParent():GetAlpha() == 1 then
		frame.name:SetDrawLayer("OVERLAY")
	else
		frame.name:SetDrawLayer("BORDER")
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
	if not frame.icons or not frame.unit or not C["Showdebuff"] then return end  --
	local i = 1
	for index = 1,40 do
		if i > C["HPWidth"] / C["IconSize"] then return end
		local match
		local name,_,_,_,_,duration,_,caster,_,_,spellid = UnitAura(frame.unit,index,"HARMFUL")
		
		if caster == "player" and duration>0 then match = true end
		if DebuffWhiteList[name] then match = true end
		if DebuffBlackList[name] then match = false end
		if duration and match == true then
			if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
			local icon = frame.icons[i]
			if i == 1 then icon:Point("RIGHT",frame.icons,"RIGHT") end
			if i ~= 1 and i <= C["HPWidth"] / C["IconSize"] then icon:Point("RIGHT", frame.icons[i-1], "LEFT", -2, 0) end
			i = i + 1
			UpdateAuraIcon(icon, frame.unit, index, "HARMFUL")
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

local function UpdateObjects(frame)
	local frame = frame:GetParent()
	Color(frame)
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(C["HPWidth"], C["HPHeight"])	
	frame.hp:SetPoint('CENTER', frame)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)
	local name = frame.oldname:GetText()
	if name:len()> 18 then name = name:sub(1, 18).."..." end
	frame.name:SetText(name)
	frame.hp:SetMinMaxValues(frame.healthOriginal:GetMinMaxValues())
	frame.highlight:ClearAllPoints()
	frame.highlight:SetAllPoints(frame.hp)

	local level, elite, mylevel = tonumber(frame.level:GetText()), frame.elite:IsShown(), UnitLevel("player")
	local lvlr, lvlg, lvlb = frame.level:GetTextColor()
	frame.level:ClearAllPoints()
	frame.level.Show = function() end
	frame.level:Hide()
	if frame.boss:IsShown() then
		frame.level:SetText("B")
		frame.name:SetText('|cffDC3C2D'..frame.level:GetText()..'|r '..name)
	elseif not elite and level == mylevel then
		frame.name:SetText(name)
	elseif level then
		frame.level:SetText(level..(elite and "+" or ""))
		frame.name:SetText(format('|cff%02x%02x%02x', lvlr*255, lvlg*255, lvlb*255)..frame.level:GetText()..'|r '..name)
	end
	
	if frame.icons then return end
	frame.icons = CreateFrame("Frame",nil,frame)
	frame.icons:Point("BOTTOMRIGHT",frame.hp,"TOPRIGHT", 0, 8)
	frame.icons:Width(C["IconSize"] + C["HPWidth"])
	frame.icons:Height(C["IconSize"])
	frame.icons:SetFrameLevel(frame.hp:GetFrameLevel()+2)
	frame:HookScript("OnEvent", OnAura)
	
	HideObjects(frame)
end

local function UpdateCastbar(frame)
    frame.border:ClearAllPoints()
    frame.border:SetPoint("TOP",frame:GetParent().hp,"BOTTOM", 0,-5)
	frame.border:SetSize(C["HPWidth"], C["CastBarHeight"])
    frame:SetPoint("RIGHT",frame.border,0,0)
    frame:SetPoint("TOP",frame.border,0,0)
    frame:SetPoint("BOTTOM",frame.border,0,0)
    frame:SetPoint("LEFT",frame.border,0,0)
	local texture = frame:GetStatusBarTexture()
	frame.cbtexture = texture
	if not frame.shield:IsShown() then
		S.CreateTop(texture, .5,.65,.85)
	else
		S.CreateTop(texture, 1,0,0)
	end
end	

local OnValueChanged = function(self)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
 	if not self.shield:IsShown() then
		S.CreateTop(self.cbtexture,.5,.65,.85)
	else
		S.CreateTop(self.cbtexture, 1,0,0)
	end 
end

local OnSizeChanged = function(self)
	self.needFix = true
end
-- We need to reset everything when a nameplate it hidden 重置所有框体内容
local function OnHide(frame)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.unit = nil
	frame.guid = nil
	frame.icon:Hide()
	frame.Ticon:Hide()
	frame.icon:SetTexture(nil)
	--print("OnHide", GetTime())
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
	local _, cbborder, cbshield, cbicon = cb:GetRegions()
	
	overlay:SetTexture(DB.Statusbar)
	overlay:SetVertexColor(0.25, 0.25, 0.25, 0)
	frame.highlight = overlay
	
	-- Health Bar
	frame.healthOriginal = hp
	local newhp = CreateFrame("Statusbar", nil, frame)
	newhp:SetFrameLevel(hp:GetFrameLevel())
	newhp:SetFrameStrata(hp:GetFrameStrata())
	S.SmoothBar(newhp)
	--if not S.IsCoolkid() then
	newhp:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	--else
		--newhp:SetStatusBarTexture("Interface\\AddOns\\SunUI\\media\\statusbars\\statusbar8")
	--end
	frame.hp = newhp
	if not newhp.shadow then
		newhp:CreateShadow()
		newhp.shadow:Hide()
		S.CreateMark(newhp)
	end
	newhp.border:SetFrameLevel(0)
	newhp.hpGlow = hp.border
	
	local hpbg = CreateFrame("Frame", nil, newhp)
	hpbg:SetAllPoints(newhp)
	hpbg:SetFrameLevel(0)
	S.CreateBack(hpbg)
	 
	frame.threat = threat

	local help = CreateFrame("Frame", nil, newhp)
	help:SetAllPoints(newhp)
	help:SetFrameLevel(newhp:GetFrameLevel()+1)
	newhp.pct = help:CreateFontString(nil, "OVERLAY")	
	newhp.pct:SetFont(DB.Font, C["Fontsize"], "THINOUTLINE")
	newhp.pct:SetPoint('BOTTOMRIGHT', newhp, 'TOPRIGHT', 0, -4)
	
	local offset = UIParent:GetScale() / cb:GetEffectiveScale()
	cb:CreateShadow()
	S.CreateBack(cb)

	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPRIGHT", newhp, "TOPLEFT", -4, 1)		
	cbicon:SetSize(C["CastBarIconSize"], C["CastBarIconSize"])
	cbicon:SetTexCoord(.07, .93, .07, .93)
	S.CreateShadow(cb, cbicon)
	
	cb.icon = cbicon
	cb.shield = cbshield
	cb:HookScript('OnShow', UpdateCastbar)
	cb:HookScript('OnSizeChanged', OnSizeChanged)
	cb:HookScript('OnValueChanged', OnValueChanged)	
	if not S.IsCoolkid() then
		cb:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	else
		cb:SetStatusBarTexture("Interface\\AddOns\\SunUI\\media\\statusbars\\statusbar8")
	end
	frame.cb = cb

	local name = help:CreateFontString(nil, 'OVERLAY', 2)
	name:SetPoint('BOTTOMLEFT', newhp, 'TOPLEFT', 0, -4)
	name:SetFont(DB.Font, C["Fontsize"]*S.Scale(1), "THINOUTLINE")
	frame.oldname = oldname
	frame.name = name
	
	
	--level:SetFont(DB.Font, C["Fontsize"]*S.Scale(1), "THINOUTLINE")
	--level:SetShadowOffset(1.25, -1.25)
	frame.level = level

	--Highlight
	overlay:SetTexture(1,1,1,0.01)
	overlay:SetAllPoints(newhp)
	frame.overlay = overlay
	-- totem icon
	local icon = frame:CreateTexture(nil, "BACKGROUND")
	icon:Point("BOTTOMRIGHT", newhp, "BOTTOMLEFT", -5, 0)
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
	
	QueueObject(frame, hp)
	UpdateObjects(newhp)
	UpdateCastbar(cb)
	frame:RegisterEvent("UNIT_AURA")
	frame:HookScript("OnHide", OnHide)
	newhp:HookScript("OnShow", UpdateObjects)
	frames[frame] = true
end
local function CheckBlacklist(frame, ...)
	if PlateBlacklist[frame.oldname:GetText()] then
		frame:SetScript("OnUpdate", nil)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.level:Hide()
	end
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
		if IsAddOnLoaded("TidyPlates") or IsAddOnLoaded("Aloft") or IsAddOnLoaded("dNamePlates") or IsAddOnLoaded("caelNamePlates") then
			return
		end
	C = SunUIConfig.db.profile.NameplateDB
	if C["enable"] ~= true then return end
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetScript("OnUpdate", function(self, elapsed)
		if WorldFrame:GetNumChildren() ~= numChildren then
			numChildren = WorldFrame:GetNumChildren()
			HookFrames(WorldFrame:GetChildren())
		end
		
		ForEachPlate(AdjustNameLevel)
		ForEachPlate(Color)
		ForEachPlate(ShowHealth)
		ForEachPlate(UpdateThreat)
		ForEachPlate(CheckBlacklist)
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