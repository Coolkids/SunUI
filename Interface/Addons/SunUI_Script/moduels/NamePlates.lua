local S, C, L, DB = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("NamePlates")
if DB.Nuke == true then return end

function Module:OnInitialize()
C = NameplateDB
if C["enable"] ~= true then return end
local FONTSIZE = C["Fontsize"]*S.Scale(1)
local hpHeight = C["HPHeight"]
local hpWidth = C["HPWidth"]
local iconSize = C["CastBarIconSize"]		--Size of all Icons, RaidIcon/ClassIcon/Castbar Icon
local cbHeight = C["CastBarHeight"]
local cbWidth = C["CastBarWidth"]
local blankTex = "Interface\\Buttons\\WHITE8x8"	
local OVERLAY = [=[Interface\TargetingFrame\UI-TargetingFrame-Flash]=]
local numChildren = -1
local frames = {}
local noscalemult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")

-- local goodR, goodG, goodB = 75/255,  175/255, 76/255
-- local badR, badG, badB = 0.78, 0.25, 0.25
local goodR, goodG, goodB = .2, .6, .1
local badR, badG, badB = .7, .2, .1
local transitionR, transitionG, transitionB = 218/255, 197/255, 92/255
local transitionR2, transitionG2, transitionB2 = 240/255, 154/255, 17/255

local DebuffWhiteList = {
	-- Death Knight
		[GetSpellInfo(47476)] = true, --strangulate
		[GetSpellInfo(49203)] = true, --hungering cold
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
		[GetSpellInfo(18469)] = true, --Silenced - Improved Counterspell
		[GetSpellInfo(122)] = true, --Frost Nova
		[GetSpellInfo(55080)] = true, --Shattered Barrier
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
		[GetSpellInfo(18425)] = true, --Silenced - Improved Kick
	-- Shaman
		[GetSpellInfo(51514)] = true, --Hex
		[GetSpellInfo(3600)] = true, --Earthbind
		[GetSpellInfo(8056)] = true, --Frost Shock
		[GetSpellInfo(63685)] = true, --Freeze
		[GetSpellInfo(39796)] = true, --Stoneclaw Stun
	-- Warlock
		[GetSpellInfo(710)] = true, --Banish
		[GetSpellInfo(6789)] = true, --Death Coil
		[GetSpellInfo(5782)] = true, --Fear
		[GetSpellInfo(5484)] = true, --Howl of Terror
		[GetSpellInfo(6358)] = true, --Seduction
		[GetSpellInfo(30283)] = true, --Shadowfury
		[GetSpellInfo(89605)] = true, --Aura of Foreboding
	-- Warrior
		[GetSpellInfo(20511)] = true, --Intimidating Shout
	-- Racial
		[GetSpellInfo(25046)] = true, --Arcane Torrent
		[GetSpellInfo(20549)] = true, --War Stomp
	--PVE
}

local PlateBlacklist = {
	--圖騰
	[GetSpellInfo(2062)] = true,  --土元素圖騰
	[GetSpellInfo(2894)] = true,  --火元素圖騰
	[GetSpellInfo(8184)] = true,  --元素抗性圖騰
	[GetSpellInfo(8227)] = true,  --火舌圖騰
	[GetSpellInfo(5394)] = true,  --治療之泉圖騰
	[GetSpellInfo(8190)] = true,  --熔岩圖騰
	[GetSpellInfo(5675)] = true,  --法力之泉圖騰
	[GetSpellInfo(3599)] = true,  --灼熱圖騰
	[GetSpellInfo(5730)] = true,  --石爪圖騰
	[GetSpellInfo(8071)] = true,  --石甲圖騰
	[GetSpellInfo(8075)] = true,  --大地之力圖騰
	[GetSpellInfo(8512)] = true,  --風怒圖騰
	[GetSpellInfo(3738)] = true,  --風懲圖騰
	[GetSpellInfo(87718)] = true,  --平静思绪圖騰

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
}

local NamePlates = CreateFrame("Frame")

local function QueueObject(parent, object)
	parent.queue = parent.queue or {}
	parent.queue[object] = true
end

local function HideObjects(parent)
	for object in pairs(parent.queue) do
		if(object:GetObjectType() == 'Texture') then
			object:SetTexture(nil)
			object.SetTexture = function() return end
		elseif (object:GetObjectType() == 'FontString') then
			object.ClearAllPoints = function() return end
			object.SetFont = function() return end
			object.Point = function() return end
			object:Hide()
			object.Show = function() return end
			object.SetText = function() return end
			object.SetShadowOffset = function() return end
		else
			object:Hide()
			object.Show = function() return end
		end
	end
end

--Create a fake backdrop frame using textures
local function CreateVirtualFrame(parent, point)
	if point == nil then point = parent end
	
	if point.backdrop or parent.backdrop then return end
	
	parent.backdrop = CreateFrame("Frame", nil ,parent)
	parent.backdrop:SetAllPoints()
	parent.backdrop:SetBackdrop({
		bgFile = DB.Solid,
		edgeFile = DB.GlowTex,
		edgeSize = 5,
		insets = {left = 3, right = 3, top = 3, bottom = 3}
	})

	parent.backdrop:SetPoint('TOPLEFT', point, -4, 4)
	parent.backdrop:SetPoint('BOTTOMRIGHT', point, 4, -4)
	parent.backdrop:SetBackdropColor(.05, .05, .05, .9)
	parent.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
	if parent:GetFrameLevel() - 1 >0 then
		parent.backdrop:SetFrameLevel(parent:GetFrameLevel() - 1)
	else
		parent.backdrop:SetFrameLevel(0)
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
	button.count:SetFont(DB.Font,9,"THINOUTLINE")
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
		if i > 5 then return end
		local match
		local name,_,_,_,_,duration,_,caster,_,_,spellid = UnitAura(frame.unit,index,"HARMFUL")
		
		if caster == "player" and duration>0 then match = true end
		if DebuffWhiteList[name] then match = true end
		
		if duration and match == true then
			if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
			local icon = frame.icons[i]
			if i == 1 then icon:Point("RIGHT",frame.icons,"RIGHT") end
			if i ~= 1 and i <= 5 then icon:Point("RIGHT", frame.icons[i-1], "LEFT", -2, 0) end
			i = i + 1
			UpdateAuraIcon(icon, frame.unit, index, "HARMFUL")
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

--Color the castbar depending on if we can interrupt or not, 
--also resize it as nameplates somehow manage to resize some frames when they reappear after being hidden
local function UpdateCastbar(frame)
	frame:ClearAllPoints()
	frame:Size(cbWidth, cbHeight)
	frame:Point('TOPLEFT', frame:GetParent().hp, 'BOTTOMLEFT', 0, -5)
	frame:GetStatusBarTexture():SetHorizTile(true)
	if(frame.shield:IsShown()) then
		frame:SetStatusBarColor(1, 0, 0)
	else
		frame:SetStatusBarColor(0, 1, 0)
	end
end	

--Determine whether or not the cast is Channelled or a Regular cast so we can grab the proper Cast Name
local function UpdateCastText(frame, curValue)
	local minValue, maxValue = frame:GetMinMaxValues()
	
	if UnitChannelInfo("target") then
		frame.time:SetFormattedText("%.1f ", curValue)
		frame.name:SetText(select(1, (UnitChannelInfo("target"))))
	end
	
	if UnitCastingInfo("target") then
		frame.time:SetFormattedText("%.1f ", maxValue - curValue)
		frame.name:SetText(select(1, (UnitCastingInfo("target"))))
	end
end

--Sometimes castbar likes to randomly resize
local OnValueChanged = function(self, curValue)
	UpdateCastText(self, curValue)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
end

--Sometimes castbar likes to randomly resize
local OnSizeChanged = function(self)
	self.needFix = true
end

--We need to reset everything when a nameplate it hidden, this is so theres no left over data when a nameplate gets reshown for a differant mob.
local function OnHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.unit = nil
	frame.threatStatus = nil
	frame.guid = nil
	frame.hasClass = nil
	frame.isFriendly = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
	if frame.icons then
		for _,icon in ipairs(frame.icons) do
			icon:Hide()
		end
	end	
	
	frame:SetScript("OnUpdate",nil)
end

--Color Nameplate
local function Colorize(frame)
	local r,g,b = frame.healthOriginal:GetStatusBarColor()
	
	for class, color in pairs(RAID_CLASS_COLORS) do
		local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
			frame.hasClass = true
			frame.isFriendly = false
			frame.hp:SetStatusBarColor(unpack(DB.colors.class[class]))
			return
		end
	end
	
	if g+b == 0 then -- hostile
		r,g,b = unpack(DB.colors.reaction[1])
		frame.isFriendly = false
	elseif r+b == 0 then -- friendly npc
		r,g,b = unpack(DB.colors.power["MANA"])
		frame.isFriendly = true
	elseif r+g > 1.95 then -- neutral
		r,g,b = unpack(DB.colors.reaction[4])
		frame.isFriendly = false
	elseif r+g == 0 then -- friendly player
		r,g,b = unpack(DB.colors.reaction[5])
		frame.isFriendly = true
	else -- enemy player
		frame.isFriendly = false
	end
	frame.hasClass = false
	
	frame.hp:SetStatusBarColor(r,g,b)
end

--HealthBar OnShow, use this to set variables for the nameplate, also size the healthbar here because it likes to lose it's
--size settings when it gets reshown
local function UpdateObjects(frame)
	local frame = frame:GetParent()
	
	local r, g, b = frame.hp:GetStatusBarColor()	
	
	--Have to reposition this here so it doesnt resize after being hidden
	frame.hp:ClearAllPoints()
	frame.hp:Size(hpWidth, hpHeight)	
	frame.hp:Point('TOP', frame, 'TOP', 0, -15)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)
	
	frame.hp:SetMinMaxValues(frame.healthOriginal:GetMinMaxValues())
	frame.hp:SetValue(frame.healthOriginal:GetValue())

	
	--Colorize Plate
	Colorize(frame)
	frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor = frame.hp:GetStatusBarColor()
	frame.hp.hpbg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.1)
	frame.hp.name:SetTextColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	
	local level, elite, mylevel = tonumber(frame.hp.oldlevel:GetText()), frame.hp.elite:IsShown(), UnitLevel("player")
	
	--Set the name text
	if frame.hp.boss:IsShown() then
		frame.hp.name:SetText(S.RGBToHex(0.8, 0.05, 0).." ??|r "..frame.hp.oldname:GetText())
	else
		frame.hp.name:SetText(S.RGBToHex(frame.hp.oldlevel:GetTextColor())..level..(elite and " +|r" or " |r")..frame.hp.oldname:GetText())
	end	
	frame.overlay:ClearAllPoints()
	frame.overlay:SetAllPoints(frame.hp)
	
	if frame.icons then return end
	frame.icons = CreateFrame("Frame",nil,frame)
	frame.icons:Point("BOTTOMRIGHT",frame.hp,"TOPRIGHT", 0, FONTSIZE)
	frame.icons:Width(20 + hpWidth)
	frame.icons:Height(25)
	frame.icons:SetFrameLevel(frame.hp:GetFrameLevel()+2)
	frame:RegisterEvent("UNIT_AURA")
	frame:HookScript("OnEvent", OnAura)

	HideObjects(frame)
end

--This is where we create most 'Static' objects for the nameplate, it gets fired when a nameplate is first seen.
local function SkinObjects(frame)
	local oldhp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldname, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local _, cbborder, cbshield, cbicon = cb:GetRegions()

	--Health Bar
	frame.healthOriginal = oldhp
	local hp = CreateFrame("Statusbar", nil, frame)
	hp:SetFrameLevel(oldhp:GetFrameLevel())
	hp:SetFrameStrata(oldhp:GetFrameStrata())
	hp:SetStatusBarTexture(DB.Statusbar)
	CreateVirtualFrame(hp)

	hp.oldlevel = oldlevel
	hp.boss = bossicon
	hp.elite = elite
	
	hp.value = frame:CreateFontString(nil, "OVERLAY")	
	hp.value:SetFont(DB.Font, FONTSIZE, "THINOUTLINE")
	hp.value:SetShadowColor(0, 0, 0, 0.4)
	hp.value:Point("BOTTOMRIGHT", hp, "TOPRIGHT", 0, 2)
	hp.value:SetJustifyH("RIGHT")
	hp.value:SetTextColor(1,1,1)
	hp.value:SetShadowOffset(S.mult, -S.mult)
	
	--Create Name Text
	hp.name = frame:CreateFontString(nil, 'OVERLAY')
	hp.name:Point("BOTTOMLEFT", hp, "TOPLEFT", 0, 2)
	hp.name:Point("BOTTOMRIGHT", hp, "TOPRIGHT", -20, 2)
	hp.name:SetFont(DB.Font, FONTSIZE, "THINOUTLINE")
	hp.name:SetJustifyH("LEFT")
	hp.name:SetShadowColor(0, 0, 0, 0.4)
	hp.name:SetShadowOffset(S.mult, -S.mult)
	hp.oldname = oldname

	hp.hpbg = hp:CreateTexture(nil, 'BORDER')
	hp.hpbg:SetAllPoints(hp)
	hp.hpbg:SetTexture(1,1,1,0.1) 		
	
	hp:HookScript('OnShow', UpdateObjects)
	frame.hp = hp
	
	--Cast Bar
	cb:SetStatusBarTexture(DB.Statusbar)
	CreateVirtualFrame(cb)
	
	--Create Cast Time Text
	cb.time = cb:CreateFontString(nil, "ARTWORK")
	cb.time:Point("TOPRIGHT", cb, "BOTTOMRIGHT", 0, -1)
	cb.time:SetFont(DB.Font, FONTSIZE, "THINOUTLINE")
	cb.time:SetJustifyH("RIGHT")
	cb.time:SetShadowColor(0, 0, 0, 0.4)
	cb.time:SetTextColor(1, 1, 1)
	cb.time:SetShadowOffset(S.mult, -S.mult)

	--Create Cast Name Text
	cb.name = cb:CreateFontString(nil, "ARTWORK")
	cb.name:Point("TOPLEFT", cb, "BOTTOMLEFT", 0, -1)
	cb.name:SetFont(DB.Font, FONTSIZE, "THINOUTLINE")
	cb.name:SetJustifyH("LEFT")
	cb.name:SetTextColor(1, 1, 1)
	cb.name:SetShadowColor(0, 0, 0, 0.4)
	cb.name:SetShadowOffset(S.mult, -S.mult)		
	
	--Setup CastBar Icon
	cbicon:ClearAllPoints()
	cbicon:Point("BOTTOMRIGHT", cb, "BOTTOMLEFT", -5, 0)		
	cbicon:Size(iconSize, iconSize)
	cbicon:SetTexCoord(.07, .93, .07, .93)
	cbicon:SetDrawLayer("OVERLAY")
	cb.icon = cbicon
	if not cbicon.backdrop then	
		cbicon.backdrop = CreateFrame("Frame", nil ,cb)
		cbicon.backdrop:SetAllPoints()
		cbicon.backdrop:SetBackdrop({
			bgFile = DB.Solid,
			edgeFile = DB.GlowTex,
			edgeSize = 3*noscalemult,
			insets = {
				top = 3*noscalemult, left = 3*noscalemult, bottom = 3*noscalemult, right = 3*noscalemult
			}
		})
		cbicon.backdrop:Point('TOPLEFT', cbicon, -3*noscalemult, 3*noscalemult)
		cbicon.backdrop:Point('BOTTOMRIGHT', cbicon, 3*noscalemult, -3*noscalemult)
		cbicon.backdrop:SetBackdropColor(.05, .05, .05, .9)
		cbicon.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
		if cb:GetFrameLevel() - 1 >0 then
			cbicon.backdrop:SetFrameLevel(cb:GetFrameLevel() - 1)
		else
			cbicon.backdrop:SetFrameLevel(0)
		end
	end
	
	cb.shield = cbshield
	cbshield:ClearAllPoints()
	cbshield:Point("TOP", cb, "BOTTOM")
	cb:HookScript('OnShow', UpdateCastbar)
	cb:HookScript('OnSizeChanged', OnSizeChanged)
	cb:HookScript('OnValueChanged', OnValueChanged)			
	frame.cb = cb
	
	--Highlight
	overlay:SetTexture(1,1,1,0.15)
	overlay:SetAllPoints(hp)
	frame.overlay = overlay

	--Reposition and Resize RaidIcon
	raidicon:ClearAllPoints()
	raidicon:Point("BOTTOM", hp, "TOP", 0, 2)
	raidicon:Size(iconSize*1.4, iconSize*1.4)
	raidicon:SetTexture("Interface\\AddOns\\!SunUI\\Media\\raidicons.blp")	
	frame.raidicon = raidicon
	
	--Hide Old Stuff
	QueueObject(frame, oldhp)
	QueueObject(frame, oldlevel)
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, oldname)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)
	
	UpdateObjects(hp)
	UpdateCastbar(cb)
	
	frame:HookScript('OnHide', OnHide)
	frames[frame] = true
	frame.RayUIPlate = true
end

local function UpdateThreat(frame, elapsed)
	frame.hp:Show()
	if frame.hasClass == true then return end
	if not frame.region:IsShown() then
		if InCombatLockdown() and frame.isFriendly ~= true then
			--No Threat
			if DB.Role == "Tank" then
				frame.hp.backdrop:SetBackdropBorderColor(1, 0, 0,1)--(badR, badG, badB)  --红
				frame.hp.hpbg:SetTexture(badR, badG, badB, 0.1) --红
				--frame.hp.backdrop:SetBackdropBorderColor(badR, badG, badB, 1)
				frame.threatStatus = "BAD"
			else
				frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)--(goodR, goodG, goodB, 0.1)
				frame.hp.hpbg:SetTexture(goodR, goodG, goodB, 0.1)
				--frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
				frame.threatStatus = "GOOD"
			end		
		else
			--Set colors to their original, not in combat
			--frame.hp.backdrop:SetBackdropBorderColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
			frame.hp.hpbg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.1)
			frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
			frame.threatStatus = nil
		end
	else
		--Ok we either have threat or we're losing/gaining it
		local r, g, b = frame.region:GetVertexColor()
		if g + b == 0 then
			--Have Threat
			if DB.Role == "Tank" then
				frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)--(goodR, goodG, goodB, 0.1)
				frame.hp.hpbg:SetTexture(goodR, goodG, goodB, 0.1)  --绿
				--frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
				frame.threatStatus = "GOOD"
			else
				frame.hp.backdrop:SetBackdropBorderColor(1, 0, 0,1)--(badR, badG, badB)有仇恨时的红色边框
				frame.hp.hpbg:SetTexture(badR, badG, badB, 0.1)
				--frame.hp.backdrop:SetBackdropBorderColor(badR, badG, badB, 1)
				frame.threatStatus = "BAD"
			end
		else
			--Losing/Gaining Threat
			if DB.Role == "Tank" then
				if frame.threatStatus == "GOOD" then
					--Losing Threat
					frame.hp.backdrop:SetBackdropBorderColor(1, 1, 0, 1)--(transitionR2, transitionG2, transitionB2, 0.1)--橘黄
					frame.hp.hpbg:SetTexture(1, 1, 0, 0.1)--(transitionR2, transitionG2, transitionB2, 0.1)--橘黄
					--frame.hp.backdrop:SetBackdropBorderColor(badR, badG, badB, 1)
				else
					--Gaining Threat
					frame.hp.backdrop:SetBackdropBorderColor(1, 1, 0, 1)--(transitionR, transitionG, transitionB)--深黄
					frame.hp.hpbg:SetTexture(1, 1, 0, 0.1)--(transitionR, transitionG, transitionB, 0.1)
					--frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
				end
			else
				if frame.threatStatus == "GOOD" then
					--Losing Threat
					frame.hp.backdrop:SetBackdropBorderColor(1, 1, 0, 1)--(transitionR, transitionG, transitionB, 0.1) --深黄
					frame.hp.hpbg:SetTexture(1, 1, 0, 0.1)--(transitionR, transitionG, transitionB, 0.1)
					--frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
				else
					--Gaining Threat
					frame.hp.backdrop:SetBackdropBorderColor(1, 1, 0, 1)--(transitionR2, transitionG2, transitionB2)	--橘黄
					frame.hp.hpbg:SetTexture(1, 1, 0, 0.1)--(transitionR2, transitionG2, transitionB2, 0.1)	
					--frame.hp.backdrop:SetBackdropBorderColor(badR, badG, badB, 1)
				end				
			end
		end
	end
end

--Create our blacklist for nameplates, so prevent a certain nameplate from ever showing
local function CheckBlacklist(frame, ...)
	if PlateBlacklist[frame.hp.oldname:GetText()] then
		frame:SetScript("OnUpdate", function() end)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.hp.oldlevel:Hide()
	end
end

--When becoming intoxicated blizzard likes to re-show the old level text, this should fix that
local function HideDrunkenText(frame, ...)
	if frame and frame.hp.oldlevel and frame.hp.oldlevel:IsShown() then
		frame.hp.oldlevel:Hide()
	end
end

--Force the name text of a nameplate to be behind other nameplates unless it is our target
local function AdjustNameLevel(frame, ...)
	if UnitName("target") == frame.hp.oldname:GetText() and frame:GetAlpha() == 1 then
		frame.hp.name:SetDrawLayer("OVERLAY")
	else
		frame.hp.name:SetDrawLayer("BORDER")
	end
end

--Health Text, also border coloring for certain plates depending on health
local function ShowHealth(frame, ...)
	-- show current health value
	local minHealth, maxHealth = frame.healthOriginal:GetMinMaxValues()
	local valueHealth = frame.healthOriginal:GetValue()
	local d =(valueHealth/maxHealth)*100
	
	--Match values
	frame.hp:SetValue(valueHealth - 1)	--Bug Fix 4.1
	frame.hp:SetValue(valueHealth)	
	
	frame.hp.value:SetText(string.format("%d%%", math.floor((valueHealth/maxHealth)*100)))
	
	--Change frame style if the frame is our target or not
	if UnitName("target") == frame.hp.oldname:GetText() and frame:GetAlpha() == 1 then
		--Targetted Unit
		frame.hp.name:SetTextColor(1, 1, 1)
	else
		--Not Targetted
		-- frame.hp.name:SetTextColor(1, 1, 1)
		frame.hp.name:SetTextColor(frame.hp:GetStatusBarColor())
	end
			
	--Setup frame shadow to change depending on enemy players health, also setup targetted unit to have white shadow
	if frame.hasClass == true or frame.isFriendly == true then
		if(d <= 50 and d >= 20) then
			frame.hp.backdrop:SetBackdropBorderColor(1, 1, 0, 1)
		elseif(d < 20) then
			frame.hp.backdrop:SetBackdropBorderColor(1, 0, 0, 1)
		else
			frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
		end
	elseif (frame.hasClass ~= true and frame.isFriendly ~= true) then
		--frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
	end
end

--Scan all visible nameplate for a known unit.
local function CheckUnit_Guid(frame, ...)
	--local numParty, numRaid = GetNumPartyMembers(), GetNumRaidMembers()
	if UnitExists("target") and frame:GetAlpha() == 1 and UnitName("target") == frame.hp.oldname:GetText() then
		frame.guid = UnitGUID("target")
		frame.unit = "target"
		OnAura(frame, "target")
	elseif frame.overlay:IsShown() and UnitExists("mouseover") and UnitName("mouseover") == frame.hp.oldname:GetText() then
		frame.guid = UnitGUID("mouseover")
		frame.unit = "mouseover"
		OnAura(frame, "mouseover")
	else
		frame.unit = nil
	end	
end

--Update settings for nameplate to match config
local function CheckSettings(frame, ...)
	--Width
	if cbWidth ~= hpWidth then
		cbWidth = hpWidth

	end
end

--Attempt to match a nameplate with a GUID from the combat log
local function MatchGUID(frame, destGUID, spellID)
	if not frame.guid then return end
	
	
	if frame.guid == destGUID then
		for _,icon in ipairs(frame.icons) do 
			if icon.spellID == spellID then 
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

--Check if the frames default overlay texture matches blizzards nameplates default overlay texture
local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local region = frame:GetRegions()
		
		if(not frames[frame] and (frame:GetName() and frame:GetName():find("NamePlate%d")) and region and region:GetObjectType() == 'Texture' and region:GetTexture() == OVERLAY) then
			SkinObjects(frame)
			frame.region = region
		end
	end
end

--Core right here, scan for any possible nameplate frames that are Children of the WorldFrame
CreateFrame('Frame'):SetScript('OnUpdate', function(self, elapsed)
	if(WorldFrame:GetNumChildren() ~= numChildren) then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())
	end

	if(self.elapsed and self.elapsed > 0.2) then
		ForEachPlate(UpdateThreat, self.elapsed)
		ForEachPlate(AdjustNameLevel)
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
	
	ForEachPlate(ShowHealth)
	ForEachPlate(CheckBlacklist)
	ForEachPlate(HideDrunkenText)
	ForEachPlate(CheckUnit_Guid)
	ForEachPlate(CheckSettings)
end)

function NamePlates:COMBAT_LOG_EVENT_UNFILTERED(_, event, ...)
	if event == "SPELL_AURA_REMOVED" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...
		
		if sourceGUID == UnitGUID("player") then
			ForEachPlate(MatchGUID, destGUID, spellID)
		end
	end
end

function NamePlates:PLAYER_ENTERING_WORLD()
	SetCVar("threatWarning", 3)
	SetCVar("bloatthreat", 0)
	SetCVar("bloattest", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("bloatnameplates", 0)
	if C["Combat"]	then
		if InCombatLockdown() then 
			SetCVar("nameplateShowEnemies", 1) 
		end
	end
end


function NamePlates:PLAYER_REGEN_DISABLED()
	SetCVar("nameplateShowEnemies", 1)
end

NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
NamePlates:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
NamePlates:RegisterEvent("PLAYER_ENTERING_WORLD")
if C["Combat"] then
	NamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")
end
end