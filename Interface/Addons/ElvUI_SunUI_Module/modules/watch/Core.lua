local RayUIWatcher = LibStub("AceAddon-3.0"):NewAddon("RayWatcher", "AceEvent-3.0")
local E, _, _, P, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local _, ns = ...
local myclass = E.myclass
local colors = RAID_CLASS_COLORS
ns.modules = {}
local testing = false

local watcherPrototype = {}
local _G = _G
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local CooldownFrame_Set = CooldownFrame_Set

local function Round(v, decimals)
	if not decimals then decimals = 0 end
    return (("%%.%df"):format(decimals)):format(v)
end

function watcherPrototype:OnEnable()
		if self.parent then
			self.parent:Show()
		end
		self:TestMode(testing)
		self:Update()
end
	
function watcherPrototype:OnDisable()
	if self.parent then
		self.parent:Hide()
	end
end

function watcherPrototype:CreateButton(mode)
	local A = E:GetModule("Skins-SunUI")
	local button=CreateFrame("Button", nil, self.parent)
	local help=CreateFrame("Button", nil, button)
	help:SetFrameLevel(button:GetFrameLevel()+2)
	A:CreateShadow2(button)
	button:StyleButton(true)
	button:SetPushedTexture(nil)
	button:SetSize(self.size, self.size)
	self.parent:SetSize(self.size, self.size)
	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetAllPoints()
	button.icon:SetTexCoord(.08, .92, .08, .92)
	button.count = help:CreateFontString(nil, "OVERLAY", 2)
	button.count:SetFont(P["media"].font, P["media"].fontsize * (Round(self.size) / 26), 'THINOUTLINE')
	button.count:SetPoint("TOPRIGHT", button , "TOPRIGHT", 4, 5)
	
	button.value = help:CreateFontString(nil, "OVERLAY")
	button.value:SetFont(P["media"].font, P["media"].fontsize * (Round(self.size) / 26)-2, 'THINOUTLINE')
	button.value:SetPoint("CENTER", button , "BOTTOM", 0, 2)
	button.value:SetJustifyH("RIGHT")
	
	button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			if self.filter == "BUFF" then
				GameTooltip:SetUnitAura(self.unitID, self.index, "HELPFUL")
			elseif self.filter == "DEBUFF" then
				GameTooltip:SetUnitAura(self.unitID, self.index, "HARMFUL")
			elseif self.filter == "itemCD" then
				GameTooltip:SetHyperlink(select(2,GetItemInfo(self.spellID)))
			elseif self.filter == "slotCD" then
                GameTooltip:SetInventoryItem("player", self.spellID)
			else
				GameTooltip:SetSpellByID(self.spellID)
			end
			GameTooltip:Show()
		end)
	button:SetScript("OnLeave", GameTooltip_Hide)
	if mode=="BAR" then
		local A = E:GetModule("Skins-SunUI")
		button.statusbar = CreateFrame("StatusBar", nil, button)
		button.statusbar:SetFrameStrata("BACKGROUND")
		A:CreateShadow2(button.statusbar, 0.5)
		if self.barwidth == nil then 
			print("SunUI:RayWatch,'Bar'模式计时条宽度未定义,恢复默认宽度155,如果您有设置宽度值请重新登录,如果您依旧看到次消息请向作者反馈")
			self.barwidth = 155
		end
		button.statusbar:SetWidth(self.barwidth - 6)
		button.statusbar:SetHeight(6)
		button.statusbar:SetStatusBarTexture(P["media"].normal)
		button.statusbar:SetStatusBarColor(colors[myclass].r, colors[myclass].g, colors[myclass].b)
		if ( self.iconside == "RIGHT" ) then
			button.statusbar:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -5, 2)
		else
			button.statusbar:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 5, 2)
		end
		button.statusbar:SetMinMaxValues(0, 1)
		button.statusbar:SetValue(1)
		A:CreateMark(button.statusbar)
		button.time = button:CreateFontString(nil, "OVERLAY")
		button.time:FontTemplate()
		button.time:SetPoint("BOTTOMRIGHT", button.statusbar, "TOPRIGHT", 0, 4)
		button.time:SetText("60")
		button.name = button:CreateFontString(nil, "OVERLAY")
		button.name:FontTemplate()
		button.name:SetPoint("BOTTOMLEFT", button.statusbar, "TOPLEFT", 0, 4)
		button.name:SetText("技能名称")
		button.mode = "BAR"
	else			
		button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
		button.cooldown:SetAllPoints(button.icon)
		button.cooldown:SetReverse()
		button.cooldown:SetFrameLevel(button:GetFrameLevel()+1)
		button.mode = "ICON"	
	end
	button.owner = self
	return button
end

function watcherPrototype:UpdateButton(button, index, icon, count, duration, expires, spellID, unitID, filter, value)
	button.icon:SetTexture(icon)
	button.count:SetText(count > 1 and count or "")
	--button.value:SetText((value and value > 1000) and value or "")
	if button.cooldown then
		if filter:find("CD") then
			button.cooldown:SetReverse(false)
			CooldownFrame_Set(button.cooldown, expires, duration, 1)
		else
			button.cooldown:SetReverse(true)
			CooldownFrame_Set(button.cooldown, expires - duration, duration, 1)
		end
	end
	if filter:find("CD") then
		button.start = expires
		button.duration = duration
	else
		button.start = expires - duration
		button.duration = duration
	end
	button.index = index
	button.filter = filter
	button.unitID = unitID
	button.spellID = spellID
	if filter == "itemCD" then
		button.spn = GetItemInfo(spellID)
	elseif filter == "slotCD" then
		local slotLink = GetInventoryItemLink("player", spellID)
		button.spn = GetItemInfo(slotLink)
	else
		button.spn = GetSpellInfo(spellID)
	end
	if not button:IsShown() then
		button:Show()
	end
end

local function BarUpdate(self, elapsed)
	if self.spellID then
		if self.filter == "BUFF" or self.filter == "DEBUFF" then
			local _, _, _, _, _, duration, expires = (self.filter == "BUFF" and UnitBuff or UnitDebuff)(self.unitID, self.index)
			if not duration then
				self.owner:Update()
			end
			if duration == 0 then
				self.statusbar:SetMinMaxValues(0, 1)
				self.time:SetText("")
				self.name:SetText(self.spn)
				self.statusbar:SetValue(1)
			else
				self.statusbar:SetMinMaxValues(0, duration)
				local time = expires - GetTime()
				self.statusbar:SetValue(time)
				self.name:SetText(self.spn)
				if time <= 60 then
					self.time:SetFormattedText("%.1f", time)
				else
					self.time:SetFormattedText("%d:%.2d", time/60, time%60)
				end
			end			
		elseif self.filter == "CD" or self.filter == "itemCD" or self.filter == "slotCD" then
			local start, duration
			if self.filter == "slotCD" then
				start, duration = GetInventoryItemCooldown("player", self.spellID)
			elseif self.filter == "CD" then
				start, duration = GetSpellCooldown(self.spellID)
			elseif self.filter == "itemCD" then
				start, duration = GetItemCooldown(self.spellID)
			end
			if self.mode == "BAR" then
				self.statusbar:SetMinMaxValues(0, duration)
				local time = start + duration - GetTime()
				self.statusbar:SetValue(time)
				if time <= 60 then
					self.time:SetFormattedText("%.1f", time)
				else
					self.time:SetFormattedText("%d:%.2d", time/60, time%60)
				end
				self.name:SetText(self.spn)
			end
			if start == 0 then
				self:SetScript("OnUpdate", nil)
				self.owner:Update()
			end
		end
	end
end

function watcherPrototype:CheckAura()
	if self.BUFF then
		for unitID in pairs(self.BUFF.unitIDs) do
			if self.BUFF.unitIDs[unitID] then
				local index = 1
				while UnitBuff(unitID, index) and not ( index > 40 ) do
					local _, _, icon, count, _, duration, expires, caster, _, _, spellID, _, _, _, value = UnitBuff(unitID,index)
					if self.BUFF[spellID] and self.BUFF[spellID].unitID == unitID and ( caster == self.BUFF[spellID].caster or self.BUFF[spellID].caster:lower() == "all" ) then
						if not self.button[self.current] then
							self.button[self.current] = self:CreateButton(self.mode)					
							self:SetPosition(self.current)
						end
						self:UpdateButton(self.button[self.current], index, icon, count, duration, expires, spellID, unitID, "BUFF", value)
						if self.mode == "BAR" then
							self.button[self.current]:SetScript("OnUpdate", BarUpdate)
						else
							self.button[self.current]:SetScript("OnUpdate", nil)
						end
						self.current = self.current + 1
					end
					index = index + 1
				end
			end
		end
	end
	if self.DEBUFF then
		for unitID in pairs(self.DEBUFF.unitIDs) do
			if self.DEBUFF.unitIDs[unitID] then
				local index = 1
				while UnitDebuff(unitID, index) and not ( index > 1024 ) do
					local _, _, icon, count, _, duration, expires, caster, _, _, spellID, _, _, _, value = UnitDebuff(unitID,index)
					if self.DEBUFF[spellID] and self.DEBUFF[spellID].unitID == unitID and ( caster == self.DEBUFF[spellID].caster or self.DEBUFF[spellID].caster:lower() == "all" ) then
						if not self.button[self.current] then
							self.button[self.current] = self:CreateButton(self.mode)					
							self:SetPosition(self.current)
						end	
						self:UpdateButton(self.button[self.current], index, icon, count, duration, expires, spellID, unitID, "DEBUFF", value)
						if self.mode == "BAR" then
							self.button[self.current]:SetScript("OnUpdate", BarUpdate)
						else
							self.button[self.current]:SetScript("OnUpdate", nil)
						end
						self.current = self.current + 1
					end
					index = index + 1
				end
			end
		end
	end
end

function watcherPrototype:CheckCooldown()
	if self.CD then
		for spellID in pairs(self.CD) do
			if type(spellID) == "number" and self.CD[spellID] then
				local start, duration = GetSpellCooldown(spellID)
				local _, _, icon = GetSpellInfo(spellID)
				if start ~= 0 and duration > 2.9 then
					if not self.button[self.current] then
						self.button[self.current] = self:CreateButton(self.mode)					
						self:SetPosition(self.current)
					end	
					self:UpdateButton(self.button[self.current], nil, icon, 0, duration, start, spellID, nil, "CD")
					if self.mode == "BAR" then
						self.button[self.current]:SetScript("OnUpdate", BarUpdate)
					else
						self.button[self.current]:SetScript("OnUpdate", nil)
					end
					self.current = self.current + 1
				end
			end
		end
	end
	if self.itemCD then
		for itemID in pairs(self.itemCD) do
			if type(itemID) == "number" and self.itemCD[itemID] then
				local start, duration = GetItemCooldown(itemID)
				local _, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemID)
				if start ~= 0 and duration > 2.9 then
					if not self.button[self.current] then
						self.button[self.current] = self:CreateButton(self.mode)					
						self:SetPosition(self.current)
					end	
					self:UpdateButton(self.button[self.current], nil, icon, 0, duration, start, itemID, nil, "itemCD")
					if self.mode == "BAR" then
						self.button[self.current]:SetScript("OnUpdate", BarUpdate)
					else
						self.button[self.current]:SetScript("OnUpdate", nil)
					end
					self.current = self.current + 1
				end
			end
		end
	end
	if self.slotCD then
		for slotID in pairs(self.slotCD) do
				if type(slotID) == "number" and self.slotCD[slotID] then
						local slotLink = GetInventoryItemLink("player", slotID)
						if slotLink then
								local _, _, _, _, _, _, _, _, _, icon = GetItemInfo(slotLink)
								local start, duration = GetInventoryItemCooldown("player", slotID)
								if start ~= 0 and duration > 2.9 then
										if not self.button[self.current] then
												self.button[self.current] = self:CreateButton(self.mode)
												self:SetPosition(self.current)
										end
										self:UpdateButton(self.button[self.current], nil, icon, 0, duration, start, slotID, nil, "slotCD")
										if self.mode == "BAR" then
											self.button[self.current]:SetScript("OnUpdate", BarUpdate)
										else
											self.button[self.current]:SetScript("OnUpdate", nil)
										end
										self.current = self.current + 1
								end
						end
				end
		end
	end
end

function watcherPrototype:Update()
	self.current = 1
	for i = 1, #self.button do
		if self.button[i]:IsShown() then
			self.button[i]:Hide()
		end
	end
	
	self:CheckAura()
	self:CheckCooldown()
end

function watcherPrototype:SetPosition(num)
	if not self.button[num] then return end
	if num == 1 then 
		self.button[num]:ClearAllPoints()
		self.button[num]:SetPoint("CENTER", self.parent, "CENTER", 0, 0)
	elseif self.direction == "LEFT" then
		self.button[num]:ClearAllPoints()
		self.button[num]:SetPoint("RIGHT", self.button[num-1], "LEFT", -5, 0)
	elseif self.direction == "RIGHT" then
		self.button[num]:ClearAllPoints()
		self.button[num]:SetPoint("LEFT", self.button[num-1], "RIGHT", 5, 0)
	elseif self.direction == "DOWN" then
		self.button[num]:ClearAllPoints()
		self.button[num]:SetPoint("TOP", self.button[num-1], "BOTTOM", 0, -5)
	else
		self.button[num]:ClearAllPoints()
		self.button[num]:SetPoint("BOTTOM", self.button[num-1], "TOP", 0, 5)
	end
end

function watcherPrototype:TestMode(arg)
	if not self:IsEnabled() then return end
	if arg == true then
		local num = 1
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		for _, subt in pairs({"BUFF", "DEBUFF", "CD", "itemCD"}) do
			for i,v in pairs(self[subt] or {}) do
				if i ~= "unitIDs" then
					if not self.button[num] then
						self.button[num] = self:CreateButton(self.mode)					
						self:SetPosition(num)
					end
					local icon
					if subt == "itemCD" then
						icon = select(10, GetItemInfo(i))
					else
						icon = select(3, GetSpellInfo(i))
					end
					if icon then
						self:UpdateButton(self.button[num], 1, icon, 9, 0, 0, i, "player", subt:upper())
					else
						print("|cff7aa6d6Ray|r|cffff0000W|r|cff7aa6d6atcher|r: "..self.name.." "..subt.." ID: "..i.."不存在")
					end
					num = num + 1
				end
			end
		end
		self.moverFrame:Show()
	else
		self:RegisterEvent("UNIT_AURA", "OnEvent")
		self:RegisterEvent("PLAYER_TARGET_CHANGED", "OnEvent")
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN", "OnEvent")
		for _, v in pairs(ns.modules) do
			v:Update()
		end
		self.moverFrame:Hide()
	end
end

function watcherPrototype:OnEvent(event, unit)
	if event == "PLAYER_ENTERING_WORLD" then
		if not self.parent:GetPoint() then
			self.parent:SetPoint(unpack(self.setpoint))
		end
		local _, parent = self.parent:GetPoint()
		if parent then self.parent:SetParent(parent) end
		self:Update()
		if self.disabled then self:Disable() end
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	local needUpdate
	if self.BUFF and unit and self.BUFF.unitIDs[unit] then
		needUpdate = true
	end
	if self.DEBUFF and unit and self.DEBUFF.unitIDs[unit] then
		needUpdate = true
	end
	if needUpdate or not unit then
		self:Update()
	end
end

function RayUIWatcher:OnInitialize()
	if type(ns.watchers[myclass]) == "table" then
		for _, t in ipairs(ns.watchers[myclass]) do
			self:NewWatcher(t)
		end
	end
	if type(ns.watchers["ALL"]) == "table" then
		for _, t in ipairs(ns.watchers["ALL"]) do
			self:NewWatcher(t)
		end
	end
	ns.watchers = nil
	
	local RayWatcherConfig = LibStub("AceAddon-3.0"):GetAddon("RayWatcherConfig")
	RayWatcherConfig:Load()
	
	for group, options in pairs(RayWatcherConfig.db.profile) do
		if ns.modules[group] then
			for option, value in pairs(options) do
				if type(value) ~= 'table' then
					ns.modules[group][option] = value
				end
			end
			if type(options.BUFF) == "table" then
				for id, value in pairs(options.BUFF) do
					ns.modules[group]["BUFF"] = ns.modules[group]["BUFF"] or {}
					ns.modules[group]["BUFF"][id] = value
				end
			end
			if type(options.DEBUFF) == "table" then
				for id, value in pairs(options.DEBUFF or {}) do
					ns.modules[group]["DEBUFF"] = ns.modules[group]["DEBUFF"] or {}
					ns.modules[group]["DEBUFF"][id] = value
				end
			end
			if type(options.CD) == "table" then
				for id, value in pairs(options.CD or {}) do
					ns.modules[group]["CD"] = ns.modules[group]["CD"] or {}
					ns.modules[group]["CD"][id] = value
				end
			end
			if type(options.itemCD) == "table" then
				for id, value in pairs(options.itemCD or {}) do
					ns.modules[group]["itemCD"] = ns.modules[group]["itemCD"] or {}
					ns.modules[group]["itemCD"][id] = value
				end
			end
			if type(options.slotCD) == "table" then
				for id, value in pairs(options.slotCD or {}) do
					ns.modules[group]["slotCD"] = ns.modules[group]["slotCD"] or {}
					ns.modules[group]["slotCD"][id] = value
				end
			end
		end
	end
end

function RayUIWatcher:OnEnable()
end

function RayUIWatcher:OnDisable()
	print("|cff7aa6d6Ray|r|cffff0000W|r|cff7aa6d6atcher|r已禁用")
end

function RayUIWatcher:ADDON_LOADED(event, addon)
	if addon == "RayWatcher" then
		print("|cff7aa6d6Ray|r|cffff0000W|r|cff7aa6d6atcher|r已加载, 输入/rw2打开设置界面.")
		self:UnregisterEvent("ADDON_LOADED")
	end
end

function RayUIWatcher:NewWatcher(data)
	if type(data) ~= 'table' then 
		error(format("bad argument #1 to 'RayUIWatcher:New' (table expected, got %s)", type(name)))
		return
	end
	local name, module
	for i, v in pairs(data) do
		if type(v) ~= "table" then
			if i:lower()=="name" then
				name = v
			end
		end
	end
	if name then
		module = self:NewModule(name, "AceEvent-3.0")
	else
		error("can't find argument 'name'")
		return
	end
	local function search(k, plist)
		for i=1, table.getn(plist) do
		   local v = plist[i][k]
		   if v then return v end
		end
	end
	local function createClass(...)
		local c = {}
		local arg = {...}
		setmetatable(c, {__index = function (t, k)
			return search(k, arg)
		end})
		c.__index = c
		function c:new (o)
			o = o or {}
			setmetatable(o, c)
			return o
		end
		return c
	end
	local oldmeta = getmetatable(module)
	module = setmetatable(module, { __index = createClass(oldmeta, watcherPrototype) })
	module.button = {}	
	
	for i,v in pairs(data) do
		if type(v) == "function" then
			v = v()
		end
		if type(v) ~= "table" or (type(v) == "table" and type(i) ~= "number") then
			module[i:lower()] = v
		elseif type(v) == 'table' then
			if (v.spellID or v.itemID or v.slotID) and v.filter then
				if v.filter == "CD" and v.slotID then v.filter = "slotCD" end
                if v.filter == "CD" and v.itemID then v.filter = "itemCD" end
				module[v.filter] = module[v.filter] or {}
				module[v.filter][v.spellID or v.itemID or v.slotID] = module[v.filter][v.spellID or v.itemID or v.slotID] or {}
				for ii,vv in pairs(v) do
					if ii ~= 'filter' and ii ~= 'spellID' and ii ~= 'itemID' and ii ~= "slotID" and v.filter ~= "CD" and v.filter ~= "itemCD" and v.filter ~= "slotCD" then
						ii = ii == 'unitId' and 'unitID' or ii
						module[v.filter][v.spellID or v.itemID][ii] = vv
					end
					if (ii == 'unitId' or ii == 'unitID') and (v.filter == "BUFF" or v.filter == "DEBUFF")then
						module[v.filter]['unitIDs'] = module[v.filter]['unitIDs'] or {}
						module[v.filter]['unitIDs'][vv] = true
					end
				end
			end
		end
	end

	
	
	module.parent = CreateFrame("Frame", module.name, UIParent)
	module.parent:SetSize(module.size, module.size)
	module.parent:SetMovable(true)
	
	local mover = CreateFrame("Button", nil, module.parent)
	module.moverFrame = mover
	module.moverFrame.owner = module
	mover:SetAllPoints(module.parent)
	mover:SetFrameStrata("FULLSCREEN_DIALOG")
	mover.mask = mover:CreateTexture(nil, "OVERLAY")
	mover.mask:SetAllPoints(mover)
	mover.mask:SetTexture(0, 1, 0, 0.5)
	mover.text = mover:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	mover.text:SetPoint("CENTER")
	mover.text:SetText(module.name)
	
	mover:RegisterForDrag("LeftButton")
	mover:RegisterForClicks("AnyUp")
	mover:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
	mover:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)

	mover:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self.owner.name)
		GameTooltip:AddLine("拖拽左键移动", 1, 1, 1)
		GameTooltip:Show()
	end)

	mover:SetScript("OnUpdate", nil)
	
	mover:Hide()
	
	if module.BUFF or module.DEBUFF then
		module:RegisterEvent("UNIT_AURA", "OnEvent")
		module:RegisterEvent("PLAYER_TARGET_CHANGED", "OnEvent")
		module:RegisterEvent("PLAYER_FOCUS_CHANGED", "OnEvent")
	end
	if module.CD or module.itemCD then
		module:RegisterEvent("SPELL_UPDATE_COOLDOWN", "OnEvent")
		module:RegisterEvent("SPELL_UPDATE_USABLE", "OnEvent")
		--module:RegisterEvent("BAG_UPDATE_COOLDOWN", "OnEvent")
	end
	module:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
	ns.modules[module.name] = module
end

function ns.TestMode()
	testing = not testing
	for _, v in pairs(ns.modules) do		
		v:TestMode(testing)
	end
end

RayUIWatcher:RegisterEvent("ADDON_LOADED")

SlashCmdList["TESTMODE"]=function()
	ns.TestMode()
end