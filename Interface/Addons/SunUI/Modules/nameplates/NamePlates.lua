local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local N = S:NewModule("NamePlates", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local parent, ns = ...
local oUF = ns.oUF
N.modName = L["姓名板美化"]
N.order = 7
local noscalemult
function N:GetOptions()
	local options = {
		group1 = {
			type = "group", order = 1,
			name = " ",guiInline = true,
			args = {
				enable = {
					type = "toggle",
					name = L["启用"],
					desc = L["启用"],
					order = 1,
				},
			},
		},
		group2 = {
			type = "group", order = 2,
			name = " ",guiInline = true,disabled = function() return not self.db.enable end,
			args = {
				Fontsize = {
					type = "input",
					name = L["姓名板字体大小"],
					desc = L["姓名板字体大小"],
					order = 1,
					get = function() return tostring(self.db.Fontsize) end,
					set = function(_, value) 
						self.db.Fontsize = tonumber(value)
						self:UpdateSet()
					end,
				},
				HPHeight = {
					type = "input",
					name = L["姓名板血条高度"],
					desc = L["姓名板血条高度"],
					order = 2,
					get = function() return tostring(self.db.HPHeight) end,
					set = function(_, value) 
						self.db.HPHeight = tonumber(value)
						self:UpdateSet()
					end,
				},
				HPWidth = {
					type = "input",
					name = L["姓名板血条宽度"],
					desc = L["姓名板血条宽度"],
					order = 3,
					get = function() return tostring(self.db.HPWidth) end,
					set = function(_, value) 
						self.db.HPWidth = tonumber(value) 
						self:UpdateSet()
					end,
				},			
				Combat = {
					type = "toggle",
					name = L["启用战斗显示"],
					order = 6,
					get = function() return self.db.Combat end,
					set = function(_, value) 
						self.db.Combat = value
						self:UpdateSet2()
					end,
				},
				NotCombat = {
					type = "toggle",
					name = L["启用脱离战斗隐藏"],
					order = 7,
					get = function() return self.db.NotCombat end,
					set = function(_, value) 
						self.db.NotCombat = value 
						self:UpdateSet2()
					end,
				},
				Showdebuff = {
					type = "toggle",
					name = L["启用debuff显示"],
					order = 8,
					get = function() return self.db.Showdebuff end,
					set = function(_, value) 
						self.db.Showdebuff = value 
						self:UpdateSet()
					end,
				},
				IconSize = {
					type = "range", order = 9,
					name = L["图标大小"], desc = L["图标大小"],disabled = function(info) return not self.db.Showdebuff end,
					min = 10, max = 60, step = 1,
					get = function() return self.db.IconSize end,
					set = function(_, value) 
						self.db.IconSize = value 
						self:UpdateSet()
					end,
				},
				classicon = {
					type = "toggle",
					name = L["显示职业图标"],
					order = 10,
				},
				enhancethreat = {
					type = "toggle",
					name = L["显示仇恨"],
					order = 11,
				},
				nameabbrev = {
					type = "toggle",
					name = L["名字长度限制"],
					order = 12,
				},
				health_value = {
					type = "toggle",
					name = L["显示生命值"],
					order = 13,
				},
				castbar_name = {
					type = "toggle",
					name = L["显示法术名"],
					order = 14,
				},
			}
		},
	}
	return options
end

----------------------------------------------------------------------------------------
-- Based on dNameplates(by Dawn, editor Elv22)
----------------------------------------------------------------------------------------
local frames, numChildren, select = {}, -1, select
local goodR, goodG, goodB = unpack(oUF.colors.reaction[5])
local badR, badG, badB = unpack(oUF.colors.reaction[1])

local transitionR, transitionG, transitionB = 218/255, 197/255, 92/255
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
	--["腐化之血"] = S.IsCoolkid(),
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
function N:UTF(string, i, dots)
	if not string then return end
	local bytes = string:len()
	if bytes <= i then
		return string
	else
		local len, pos = 0, 1
		while (pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 192 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
			elseif c >= 240 and c <= 247 then
				pos = pos + 4
			end
			if len == i then break end
		end
		if len == i and pos <= bytes then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end
local function Abbrev(name)
	local newname = (string.len(name) > 18) and string.gsub(name, "%s?(.[\128-\191]*)%S+%s", "%1. ") or name
	return N:UTF(newname, 18, false)
end

local function QueueObject(frame, object)
	frame.queue = frame.queue or {}
	frame.queue[object] = true
end

local function HideObjects(frame)
	for object in pairs(frame.queue) do
		if object:GetObjectType() == "Texture" then
			object:SetTexture('')
		elseif object:GetObjectType() == "FontString" then
			object:SetWidth(0.001)
		elseif object:GetObjectType() == "StatusBar" then
			object:SetStatusBarTexture('')
		else
			object:Hide()
		end
	end
end

-- Create a fake backdrop frame using textures
local function CreateVirtualFrame(frame, point)
	
	if point == nil then point = frame end
	if point.backdrop then return end
	frame.backdrop = CreateFrame("Frame", nil ,frame)
	frame.backdrop:SetAllPoints()
	if S.global.general.theme == "Shadow" then
		frame.backdrop:SetBackdrop({
			bgFile = S["media"].blank,
			edgeFile = S["media"].glow,
			edgeSize = 3*noscalemult,
			insets = {
				top = 3*noscalemult, left = 3*noscalemult, bottom = 3*noscalemult, right = 3*noscalemult
			}
		})
		frame.backdrop:SetPoint("TOPLEFT", point, -3*noscalemult, 3*noscalemult)
		frame.backdrop:SetPoint("BOTTOMRIGHT", point, 3*noscalemult, -3*noscalemult)
	else
		frame.backdrop:SetBackdrop({
			bgFile = S["media"].blank,
			edgeFile = S["media"].blank,
			edgeSize = noscalemult,
			insets = {
				top = noscalemult, left = noscalemult, bottom = noscalemult, right = noscalemult
			}
		})
		frame.backdrop:SetPoint("TOPLEFT", point, -noscalemult, noscalemult)
		frame.backdrop:SetPoint("BOTTOMRIGHT", point, noscalemult, -noscalemult)
	end
	frame.backdrop:SetBackdropColor(.05, .05, .05, .9)
	frame.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
	if frame:GetFrameLevel() - 1 >0 then
		frame.backdrop:SetFrameLevel(frame:GetFrameLevel() - 1)
	else
		frame.backdrop:SetFrameLevel(0)
	end
	
end

local function SetVirtualBorder(frame, r, g, b)
	--frame.bordertop:SetTexture(r, g, b)
	--frame.borderbottom:SetTexture(r, g, b)
	--frame.borderleft:SetTexture(r, g, b)
	--frame.borderright:SetTexture(r, g, b)
end

-- Create aura icons
local function CreateAuraIcon(frame)
	
	local button = CreateFrame("Frame", nil, frame.hp)
	button:SetWidth(N.db.IconSize)
	button:SetHeight(N.db.IconSize*16/25)

	if S.global.general.theme == "Shadow" then
		button.shadow = CreateFrame("Frame", nil, button)
		button.shadow:SetFrameLevel(0)
		button.shadow:Point("TOPLEFT", -2*noscalemult, 2*noscalemult)
		button.shadow:Point("BOTTOMRIGHT", 2*noscalemult, -2*noscalemult)
		button.shadow:SetBackdrop( {
			edgeFile = S["media"].glow,
			bgFile = S["media"].blank,
			edgeSize = S:Scale(4),
			insets = {left = S:Scale(4), right = S:Scale(4), top = S:Scale(4), bottom = S:Scale(4)},
		})
		button.shadow:SetBackdropColor( 0, 0, 0 )
		button.shadow:SetBackdropBorderColor( 0, 0, 0 )
	end
	
	button.bord = button:CreateTexture(nil, "BORDER")
	button.bord:SetTexture(0, 0, 0, 1)
	button.bord:SetPoint("TOPLEFT", button, "TOPLEFT", -noscalemult, noscalemult)
	button.bord:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", noscalemult, -noscalemult)
	
	
	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetAllPoints(button)
	--button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", -noscalemult * 3, noscalemult * 3)
	--button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", noscalemult * 3, -noscalemult * 3)
	--button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:SetTexCoord(.07, 1-.07, .23, 1-.23)
	
	button.text = button:CreateFontString(nil, 'OVERLAY')
	button.text:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, -3)
	button.text:SetJustifyH('CENTER')
	button.text:SetFont(S["media"].font, S["media"].fontsize * (N.db.IconSize / 24), "OUTLINE")
	button.text:SetShadowColor(0, 0, 0, 0)
	button.text:SetShadowOffset(S.mult, -S.mult)

	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:SetFont(S["media"].font, S["media"].fontsize * (N.db.IconSize / 24), "OUTLINE")
	button.count:SetShadowOffset(S.mult, -S.mult)
	button.count:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0, 3)

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
-- Update an aura icon
local function UpdateAuraIcon(button, unit, index, filter)
	local _, _, icon, count, _, duration, expirationTime, _, _, _, spellID = UnitAura(unit, index, filter)

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

-- Filter auras on nameplate, and determine if we need to update them or not
local function OnAura(frame, unit)
	if not frame.icons or not frame.unit or not N.db.Showdebuff then return end
	local i = 1
	for index = 1, 40 do
		if i > N.db.HPWidth / N.db.IconSize then return end
		local match
		local name, _, _, _, _, duration, _, caster, _, _ = UnitAura(frame.unit, index, "HARMFUL")
		if caster == "player" and duration>0 then match = true end
		if DebuffWhiteList[name] then match = true end
		if DebuffBlackList[name] then match = false end

		if duration and match == true then
			if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
			local icon = frame.icons[i]
			if i == 1 then icon:SetPoint("RIGHT", frame.icons, "RIGHT") end
			if i ~= 1 and i <= N.db.HPWidth / N.db.IconSize then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", -2, 0) end
			i = i + 1
			UpdateAuraIcon(icon, frame.unit, index, "HARMFUL")
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

local function CastTextUpdate(frame, curValue)
	local _, maxValue = frame:GetMinMaxValues()
	local last = frame.last and frame.last or 0
	local finish = (curValue > last) and (maxValue - curValue) or curValue

	frame.time:SetFormattedText("%.1f ", finish)
	frame.last = curValue

	if frame.shield:IsShown() then
		frame:SetStatusBarColor(0.78, 0.25, 0.25)
		frame.bg:SetTexture(0.78, 0.25, 0.25, 0.2)
	else
		frame.bg:SetTexture(0.75, 0.75, 0.25, 0.2)
	end
end

local function HealthBar_ValueChanged(frame)
	frame = frame:GetParent()
	frame.hp:SetMinMaxValues(frame.healthOriginal:GetMinMaxValues())
	frame.hp:SetValue(frame.healthOriginal:GetValue() - 1) -- Blizzard bug fix
	frame.hp:SetValue(frame.healthOriginal:GetValue())
end

-- We need to reset everything when a nameplate it hidden
local function OnHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.hp:SetScale(1)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.cb:SetScale(1)
	frame.unit = nil
	frame.guid = nil
	frame.isClass = nil
	frame.isFriendly = nil
	frame.isTapped = nil
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

-- Color Nameplate
local function Colorize(frame)
	local r, g, b = frame.healthOriginal:GetStatusBarColor()
	local texcoord = {0, 0, 0, 0}

	for class, _ in pairs(RAID_CLASS_COLORS) do
		local r, g, b = floor(r * 100 + 0.5) / 100, floor(g * 100 + 0.5) / 100, floor(b * 100 + 0.5) / 100
		if class == "MONK" then
			b = b - 0.01
		end
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
			frame.isClass = true
			frame.isFriendly = false
			if N.db.classicon == true then
				texcoord = CLASS_BUTTONS[class]
				frame.class.Glow:Show()
				frame.class:SetTexCoord(texcoord[1], texcoord[2], texcoord[3], texcoord[4])
			end
			frame.hp.name:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b)
			frame.hp:SetStatusBarColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b)
			frame.hp.bg:SetTexture(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b, 0.2)
			return
		end
	end

	frame.isTapped = false
	frame.isClass = false

	if r + b + b > 2 then	-- Tapped
		r, g, b = 0.6, 0.6, 0.6
		frame.isFriendly = false
		frame.isTapped = true
	elseif g + b == 0 then	-- Hostile
		r, g, b = unpack(oUF.colors.reaction[1])
		frame.isFriendly = false
	elseif r + b == 0 then	-- Friendly npc
		r, g, b = unpack(oUF.colors.reaction[5])
		frame.isFriendly = true
	elseif r + g > 1.95 then	-- Neutral
		r, g, b = unpack(oUF.colors.reaction[4])
		frame.isFriendly = false
	elseif r + g == 0 then	-- Friendly player
		r, g, b = 0.31, 0.45, 0.63
		frame.isFriendly = true
	else	-- Enemy player
		frame.isFriendly = false
	end

	if N.db.classicon == true then
		if frame.isClass == true then
			frame.class.Glow:Show()
		else
			frame.class.Glow:Hide()
		end
		frame.class:SetTexCoord(texcoord[1], texcoord[2], texcoord[3], texcoord[4])
	end

	frame.hp:SetStatusBarColor(r, g, b)
	frame.hp.bg:SetTexture(r, g, b, 0.2)
	frame.hp.name:SetTextColor(r, g, b)
end

-- HealthBar OnShow, use this to set variables for the nameplate
local function UpdateObjects(frame)
	frame = frame:GetParent()

	-- Set scale
	while frame.hp:GetEffectiveScale() < 1 do
		frame.hp:SetScale(frame.hp:GetScale() + 0.01)
	end

	while frame.cb:GetEffectiveScale() < 1 do
		frame.cb:SetScale(frame.cb:GetScale() + 0.01)
	end

	-- Have to reposition this here so it doesnt resize after being hidden
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(N.db.HPWidth * noscalemult, N.db.HPHeight * noscalemult)
	frame.hp:SetPoint("TOP", frame, "TOP", 0, -15)

	-- Match values
	HealthBar_ValueChanged(frame.hp)

	-- Colorize Plate
	Colorize(frame)
	frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor = frame.hp:GetStatusBarColor()
	SetVirtualBorder(frame.hp, unpack(S["media"].bordercolor))

	-- Set the name text
	if N.db.nameabbrev == true and N.db.Showdebuff ~= true then
		frame.hp.name:SetText(Abbrev(frame.hp.oldname:GetText()))
	else
		frame.hp.name:SetText(frame.hp.oldname:GetText())
	end

	-- Setup level text
	local level, elite, mylevel = tonumber(frame.hp.oldlevel:GetText()), frame.hp.elite:IsShown(), UnitLevel("player")
	frame.hp.level:ClearAllPoints()
	
	frame.hp.level:SetPoint("BOTTOMLEFT", frame.hp, "TOPLEFT", 0, 2)
	frame.hp.name:SetPoint('LEFT', frame.hp.level, 'RIGHT', 1, 0)
	frame.hp.level:SetTextColor(frame.hp.oldlevel:GetTextColor())
	if frame.hp.boss:IsShown() then
		frame.hp.level:SetText("??")
		frame.hp.level:SetTextColor(0.8, 0.05, 0)
		frame.hp.level:Show()
	elseif not elite and level == mylevel then
		frame.hp.name:SetPoint("BOTTOMLEFT", frame.hp, "TOPLEFT", 0, 2)
		frame.hp.level:Hide()
	else
		frame.hp.level:SetText(level..(elite and "+" or ""))
		frame.hp.level:Show()
	end

	HideObjects(frame)
end

-- This is where we create most 'Static' objects for the nameplate
local function SkinObjects(frame, nameFrame)
	
	local oldhp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local oldname = nameFrame:GetRegions()
	local _, cbborder, cbshield, cbicon, cbname, cbshadow = cb:GetRegions()

	-- Health Bar
	frame.healthOriginal = oldhp
	local hp = CreateFrame("Statusbar", nil, frame)
	hp:SetFrameLevel(oldhp:GetFrameLevel())
	hp:SetFrameStrata(oldhp:GetFrameStrata())
	hp:SetStatusBarTexture(S["media"].normal)
	CreateVirtualFrame(hp)
	S:SmoothBar(hp)
	-- Create Level
	hp.level = hp:CreateFontString(nil, "OVERLAY")
	hp.level:SetFont(S["media"].font, N.db.Fontsize, "THINOUTLINE")
	hp.level:SetShadowOffset(S.mult, -S.mult)
	hp.level:SetTextColor(1, 1, 1)
	hp.oldlevel = oldlevel
	hp.boss = bossicon
	hp.elite = elite

	-- Create Health Text
	if N.db.health_value == true then
		hp.value = hp:CreateFontString(nil, "OVERLAY")
		hp.value:SetFont(S["media"].font, S["media"].fontsize * (N.db.HPHeight / 16), "THINOUTLINE")
		hp.value:SetShadowOffset(S.mult, -S.mult)
		hp.value:SetPoint("RIGHT", hp, "RIGHT", 0, 0)
		hp.value:SetTextColor(1, 1, 1)
	end

	-- Create Name Text
	hp.name = hp:CreateFontString(nil, "OVERLAY")
	hp.name:SetPoint('LEFT', hp.level, 'RIGHT', 1, 0)
	--hp.name:SetPoint("BOTTOMRIGHT", hp, "TOPRIGHT", 3, 4)
	hp.name:SetFont(S["media"].font, N.db.Fontsize, "THINOUTLINE")
	hp.name:SetShadowOffset(S.mult, -S.mult)
	hp.oldname = oldname

	hp.bg = hp:CreateTexture(nil, "BORDER")
	hp.bg:SetAllPoints(hp)
	hp.bg:SetTexture(1, 1, 1, 0.2)

	hp:HookScript("OnShow", UpdateObjects)
	frame.hp = hp

	if not frame.threat then
		frame.threat = threat
	end

	-- Create Cast Bar
	cb:ClearAllPoints()
	cb:SetPoint("TOPRIGHT", hp, "BOTTOMRIGHT", 0, -8)
	cb:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 0, -8-(N.db.HPHeight * noscalemult))
	cb:SetStatusBarTexture(S["media"].normal)
	CreateVirtualFrame(cb)

	cb.bg = cb:CreateTexture(nil, "BORDER")
	cb.bg:SetAllPoints(cb)
	cb.bg:SetTexture(0.75, 0.75, 0.25, 0.2)

	-- Create Cast Time Text
	cb.time = cb:CreateFontString(nil, "ARTWORK")
	cb.time:SetPoint("RIGHT", cb, "RIGHT", 3, 0)
	cb.time:SetFont(S["media"].font, N.db.Fontsize, "THINOUTLINE")
	cb.time:SetShadowOffset(S.mult, -S.mult)
	cb.time:SetTextColor(1, 1, 1)

	-- Create Cast Name Text
	cbname:ClearAllPoints()
	cb.name = cbname
	if N.db.castbar_name == true then
		cb.name:SetPoint("LEFT", cb, "LEFT", 3, 0)
		cb.name:SetFont(S["media"].font, N.db.Fontsize, "THINOUTLINE")
		cb.name:SetShadowOffset(S.mult, -S.mult)
		cb.name:SetTextColor(1, 1, 1)
	end

	-- Create Class Icon
	if N.db.classicon == true then
		local cIconTex = hp:CreateTexture(nil, "OVERLAY")
		cIconTex:SetPoint("TOPRIGHT", hp, "TOPLEFT", -5, 2)
		cIconTex:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
		cIconTex:SetSize((N.db.HPHeight * 2) + 11, (N.db.HPHeight * 2) + 11)
		frame.class = cIconTex

		frame.class.Glow = CreateFrame("Frame", nil, frame)
		frame.class.Glow:SetTemplate("Transparent")
		frame.class.Glow:SetScale(noscalemult)
		frame.class.Glow:SetPoint("TOPLEFT", frame.class, "TOPLEFT", 0, 0)
		frame.class.Glow:SetPoint("BOTTOMRIGHT", frame.class, "BOTTOMRIGHT", 0, 0)
		frame.class.Glow:SetFrameLevel(hp:GetFrameLevel() -1 > 0 and hp:GetFrameLevel() -1 or 0)
		frame.class.Glow:Hide()
	end

	-- Create CastBar Icon
	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPLEFT", hp, "TOPRIGHT", 8, 0)
	cbicon:SetSize((N.db.HPHeight * 2) + 8, (N.db.HPHeight * 2) + 8)
	cbicon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	cbicon:SetDrawLayer("OVERLAY")
	cb.icon = cbicon
	CreateVirtualFrame(cb, cb.icon)

	cb.shield = cbshield
	cb:HookScript("OnValueChanged", CastTextUpdate)
	frame.cb = cb

	-- Aura tracking
	if N.db.Showdebuff == true then
		if not frame.icons then
			frame.icons = CreateFrame("Frame", nil, frame.hp)
			frame.icons:SetPoint("BOTTOMRIGHT", frame.hp, "TOPRIGHT", 0, N.db.Fontsize + 5)
			frame.icons:SetWidth(20 + N.db.HPWidth)
			frame.icons:SetHeight(N.db.IconSize)
			frame.icons:SetFrameLevel(frame.hp:GetFrameLevel() + 2)
			frame:RegisterEvent("UNIT_AURA")
			frame:HookScript("OnEvent", OnAura)
		end
	end

	-- Highlight texture
	if not frame.overlay then
		overlay:SetTexture(1, 1, 1, 0.15)
		overlay:SetAllPoints(frame.hp)
		frame.overlay = overlay
	end

	-- Raid icon
	if not frame.raidicon then
		raidicon:ClearAllPoints()
		raidicon:SetPoint("BOTTOM", hp, "TOP", 0, N.db.Showdebuff == true and 38 or 16)
		raidicon:SetSize((N.db.HPHeight * 2) + 8, (N.db.HPHeight * 2) + 8)
		frame.raidicon = raidicon
	end

	-- Hide Old Stuff
	QueueObject(frame, oldhp)
	QueueObject(frame, oldlevel)
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, cbshadow)
	QueueObject(frame, oldname)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)

	UpdateObjects(hp)

	frame:HookScript("OnHide", OnHide)
	frames[frame] = true
end

local function UpdateThreat(frame, elapsed)
	Colorize(frame)

	if frame.isClass or frame.isTapped then return end

	if N.db.enhancethreat ~= true then
		if frame.threat:IsShown() then
			local _, val = frame.threat:GetVertexColor()
			if val > 0.7 then
				SetVirtualBorder(frame.hp, transitionR, transitionG, transitionB)
			else
				SetVirtualBorder(frame.hp, badR, badG, badB)
			end
		else
			SetVirtualBorder(frame.hp, unpack(S["media"].bordercolor))
		end
	else
		if not frame.threat:IsShown() then
			if InCombatLockdown() and frame.isFriendly ~= true then
				-- No Threat
				if S.Role == "Tank" then
					frame.hp:SetStatusBarColor(badR, badG, badB)
					frame.hp.bg:SetTexture(badR, badG, badB, 0.2)
				else
					frame.hp:SetStatusBarColor(goodR, goodG, goodB)
					frame.hp.bg:SetTexture(goodR, goodG, goodB, 0.2)
				end
			end
		else
			-- Ok we either have threat or we're losing/gaining it
			local r, g, b = frame.threat:GetVertexColor()
			if g + b == 0 then
				-- Have Threat
				if S.Role == "Tank" then
					frame.hp:SetStatusBarColor(goodR, goodG, goodB)
					frame.hp.bg:SetTexture(goodR, goodG, goodB, 0.2)
				else
					frame.hp:SetStatusBarColor(badR, badG, badB)
					frame.hp.bg:SetTexture(badR, badG, badB, 0.2)
				end
			else
				-- Losing/Gaining Threat
				frame.hp:SetStatusBarColor(transitionR, transitionG, transitionB)
				frame.hp.bg:SetTexture(transitionR, transitionG, transitionB, 0.2)
			end
		end
	end
end

-- Create our blacklist for nameplates
local function CheckBlacklist(frame, ...)
	if N.db.nameabbrev == true then return end
	if PlateBlacklist[frame.hp.name:GetText()] then
		frame:SetScript("OnUpdate", function() end)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.hp.oldlevel:Hide()
	end
end

-- Force the name text of a nameplate to be behind other nameplates unless it is our target
local function AdjustNameLevel(frame, ...)
	if GetUnitName("target") == frame.hp.name:GetText() and frame:GetParent():GetAlpha() == 1 then
		frame.hp.name:SetDrawLayer("OVERLAY")
	else
		frame.hp.name:SetDrawLayer("BORDER")
	end
end

-- Health Text, also border coloring for certain plates depending on health
local function ShowHealth(frame, ...)
	-- Match values
	HealthBar_ValueChanged(frame.hp)

	-- Show current health value
	local _, maxHealth = frame.healthOriginal:GetMinMaxValues()
	local valueHealth = frame.healthOriginal:GetValue()
	local d = (valueHealth / maxHealth) * 100

	if N.db.health_value == true then
		frame.hp.value:SetText(S:ShortValue(valueHealth).." - "..(string.format("%d%%", math.floor((valueHealth / maxHealth) * 100))))
	end

	-- Setup frame shadow to change depending on enemy players health, also setup targetted unit to have white shadow
	if frame.isClass == true or frame.isFriendly == true then
		if d <= 50 and d >= 20 then
			SetVirtualBorder(frame.hp, 1, 1, 0)
		elseif d < 20 then
			SetVirtualBorder(frame.hp, 1, 0, 0)
		else
			SetVirtualBorder(frame.hp, unpack(S["media"].bordercolor))
		end
	elseif (frame.isClass ~= true and frame.isFriendly ~= true) and N.db.enhancethreat == true then
		SetVirtualBorder(frame.hp, unpack(S["media"].bordercolor))
	end

	if GetUnitName("target") and frame:GetParent():GetAlpha() == 1 then
		frame.hp:SetSize((N.db.HPWidth) * noscalemult, (N.db.HPHeight) * noscalemult)
		frame.cb:SetPoint("BOTTOMLEFT", frame.hp, "BOTTOMLEFT", 0, -8-((N.db.HPHeight) * noscalemult))
		frame.cb.icon:SetSize(((N.db.HPHeight) * 2) + 8, ((N.db.HPHeight) * 2) + 8)
	else
		frame.hp:SetSize(N.db.HPWidth * noscalemult, N.db.HPHeight * noscalemult)
		frame.cb:SetPoint("BOTTOMLEFT", frame.hp, "BOTTOMLEFT", 0, -8-(N.db.HPHeight * noscalemult))
		frame.cb.icon:SetSize((N.db.HPHeight * 2) + 8, (N.db.HPHeight * 2) + 8)
	end
end

-- Scan all visible nameplate for a known unit
local function CheckUnit_Guid(frame, ...)
	if UnitExists("target") and frame:GetParent():GetAlpha() == 1 and GetUnitName("target") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("target")
		frame.unit = "target"
		OnAura(frame, "target")
	elseif frame.overlay:IsShown() and UnitExists("mouseover") and GetUnitName("mouseover") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("mouseover")
		frame.unit = "mouseover"
		OnAura(frame, "mouseover")
	else
		frame.unit = nil
	end
end

-- Attempt to match a nameplate with a GUID from the combat log
local function MatchGUID(frame, destGUID, spellID)
	if not frame.guid then return end

	if frame.guid == destGUID then
		for _, icon in ipairs(frame.icons) do
			if icon.spellID == spellID then
				icon:Hide()
			end
		end
	end
end

-- Run a function for all visible nameplates, we use this for the blacklist, to check unitguid, and to hide drunken text
local function ForEachPlate(functionToRun, ...)
	for frame in pairs(frames) do
		if frame and frame:GetParent():IsShown() then
			functionToRun(frame, ...)
		end
	end
end

-- Check if the frames default overlay texture matches blizzards nameplates default overlay texture
local function HookFrames(...)
	for index = 1, select("#", ...) do
		local frame = select(index, ...)

		if frame:GetName() and not frame.isSkinned and frame:GetName():find("NamePlate%d") then
			local child1, child2 = frame:GetChildren()
			SkinObjects(child1, child2)
			frame.isSkinned = true
		end
	end
end


function N:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, ...)
	if event == "SPELL_AURA_REMOVED" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...

		if sourceGUID == UnitGUID("player") or arg4 == UnitGUID("pet") then
			ForEachPlate(MatchGUID, destGUID, spellID)
		end
	end
end

function N:Initialize()
	if not self.db.enable then return end
	noscalemult = S.mult * S.global.general.uiscale
	local Frame = CreateFrame("Frame", nil, UIParent)
	
	Frame:SetScript("OnUpdate", function(self, elapsed)
		if WorldFrame:GetNumChildren() ~= numChildren then
			numChildren = WorldFrame:GetNumChildren()
			HookFrames(WorldFrame:GetChildren())
		end

		if self.elapsed and self.elapsed > 0.2 then
			ForEachPlate(UpdateThreat, self.elapsed)
			ForEachPlate(AdjustNameLevel)
			self.elapsed = 0
		else
			self.elapsed = (self.elapsed or 0) + elapsed
		end

		ForEachPlate(ShowHealth)
		ForEachPlate(CheckBlacklist)
		if N.db.Showdebuff then
			ForEachPlate(CheckUnit_Guid)
		end
	end)
	if N.db.Showdebuff then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
	if self.db.Combat then
		self:RegisterEvent("PLAYER_REGEN_DISABLED", function()
			SetCVar("nameplateShowEnemies", 1)
		end)	
	end
	if self.db.NotCombat then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
			SetCVar("nameplateShowEnemies", 0)
		end)
	end
	
	SetCVar("bloatthreat",0)
	SetCVar("bloattest",0)
	SetCVar("bloatnameplates",0.0)
	SetCVar("ShowClassColorInNameplate",1)
	if N.db.enhancethreat == true then
		SetCVar("threatWarning", 3)
	end
end
function N:UpdateSet()
	for k,v in pairs(frames) do
		k.hp:SetSize(self.db.HPWidth, self.db.HPHeight)
		
		k.cb.icon:SetSize((N.db.HPHeight * 2) + 8, (N.db.HPHeight * 2) + 8)
		k.hp.name:SetFont(S["media"].font, self.db.Fontsize, "THINOUTLINE")
		k.raidicon:SetSize((N.db.HPHeight * 2) + 8, (N.db.HPHeight * 2) + 8)
		k.cb.time:SetFont(S["media"].font, N.db.Fontsize, "THINOUTLINE")
		k.hp.level:SetFont(S["media"].font, N.db.Fontsize, "THINOUTLINE")
		k.cb:SetPoint("TOPRIGHT", k.hp, "BOTTOMRIGHT", 0, -8)
		k.cb:SetPoint("BOTTOMLEFT", k.hp, "BOTTOMLEFT", 0, -8-(N.db.HPHeight * noscalemult))
	
		if N.db.classicon == true then
			k.class:SetSize((N.db.HPHeight * 2) + 11, (N.db.HPHeight * 2) + 11)
		end
		if N.db.castbar_name == true then
			k.cb.name:SetPoint("LEFT", cb, "LEFT", 3, 0)
			k.cb.name:SetFont(S["media"].font, N.db.Fontsize, "THINOUTLINE")
		end
		if N.db.health_value == true then
			k.hp.value:SetFont(S["media"].font, N.db.Fontsize, "THINOUTLINE")
		end
	end
end
function N:UpdateSet2()
	if self.db.Combat then
		N:RegisterEvent("PLAYER_REGEN_DISABLED", function()
			SetCVar("nameplateShowEnemies", 1)
		end)
	else
		N:UnregisterEvent("PLAYER_REGEN_DISABLED")
	end
	if self.db.NotCombat then
		N:RegisterEvent("PLAYER_REGEN_ENABLED", function()
			SetCVar("nameplateShowEnemies", 0)
		end)
	else
		N:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

end
S:RegisterModule(N:GetName())