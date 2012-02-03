--[[

格式:CreateCastBar(self)

--]]


--- ----------------------------------
--> Init
--- ----------------------------------
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("castbar")
local addon, ns = ...
local oUF = oUF or ns.oUF
--assert(oUF, 'oUF_ThreatBar was unable to locate oUF install.')

--- ----------------------------------
--> Config
--- ----------------------------------

local bar_texture = DB.bar_texture  --bar原材质
local NameFont = DB.Font --法術名稱字體
local NumbFont = DB.Font -- 法術數字字體

-- 各個法術條的位置
function Module:OnInitialize()
C=MoveHandleDB
A=UnitFrameDB
end
--- ----------------------------------
--> Function
--- ----------------------------------



Castframe = function(f)
    if f.Castframe==nil then
      local Castframe = CreateFrame("Frame", nil, f)
      Castframe:SetFrameLevel(12)
      Castframe:SetFrameStrata(f:GetFrameStrata())
      Castframe:SetPoint("TOPLEFT", 4, -4)
      Castframe:SetPoint("BOTTOMLEFT", 4, 4)
      Castframe:SetPoint("TOPRIGHT", -4, -4)
      Castframe:SetPoint("BOTTOMRIGHT", -4, 4)
	  S.MakeShadow(Castframe, 3)
      f.Castframe = Castframe
    end
end 

--[[
local fixStatusbar = function(b)
	b:GetStatusBarTexture():SetHorizTile(false)
	b:GetStatusBarTexture():SetVertTile(false)
end
--]]
local fontstring = function(f, name, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, outline)
    fs:SetShadowColor(0,0,0,1)
    return fs
end

local channelingTicks = {
	-- warlock
	[GetSpellInfo(1120)] = 5, -- drain soul
	[GetSpellInfo(689)] = 5, -- drain life
	[GetSpellInfo(5740)] = 4, -- rain of fire
	-- druid
	[GetSpellInfo(740)] = 4, -- Tranquility
	[GetSpellInfo(16914)] = 10, -- Hurricane
	-- priest
	[GetSpellInfo(15407)] = 3, -- mind flay
	[GetSpellInfo(48045)] = 5, -- mind sear
	[GetSpellInfo(47540)] = 2, -- penance 
	-- mage
	[GetSpellInfo(5143)] = 5, -- arcane missiles
	[GetSpellInfo(10)] = 5, -- blizzard
	[GetSpellInfo(12051)] = 4, -- evocation
}
local ticks = {}
	setBarTicks = function(castBar, ticknum)
	if ticknum and ticknum > 0 then
		local delta = castBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = castBar:CreateTexture(nil, 'OVERLAY')
				ticks[k]:SetTexture(bar_texture)
				ticks[k]:SetVertexColor(0, 0, 0)
				ticks[k]:SetWidth(3)--分段施法宽度
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

CastBar_OnCastbarUpdate = function(self, elapsed)
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
			else
				self.Time:SetFormattedText('%.1f | %.1f', duration, self.max)
				self.Lag:SetFormattedText("%d ms", self.SafeZone.timeDiff * 1000)
			end
		else
			self.Time:SetFormattedText('%.1f | %.1f', duration, self.casting and self.max + self.delay or self.max - self.delay)
		end
		self.duration = duration
		self:SetValue(duration)
		self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
	else
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

CastBar_OnCastSent = function(self, event, unit, spell, rank)
	if self.unit ~= unit or not self.Castbar.SafeZone then return end
	self.Castbar.SafeZone.sendTime = GetTime()
end

CastBar_PostCastStart = function(self, unit, name, rank, text)
	local pcolor = {255/255, 128/255, 128/255}
	local interruptcb = {95/255, 182/255, 255/255}
	self:SetAlpha(1.0)
	self.Spark:Show()
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	local parent = self:GetParent()
	if parent.unit == "player" then
		local sf = self.SafeZone
		sf.timeDiff = GetTime() - sf.sendTime
		sf.timeDiff = sf.timeDiff > self.max and self.max or sf.timeDiff
		sf:SetWidth(self:GetWidth() * sf.timeDiff / self.max)
		sf:Show()
		if self.casting then
			setBarTicks(self, 0)
		else
			local spell = UnitChannelInfo(unit)
			self.channelingTicks = channelingTicks[spell] or 0
			setBarTicks(self, self.channelingTicks)
		end
	--elseif (parent.unit == "target" or parent.unit == "focus" or parent.unit == "party") and not self.interrupt then
	elseif not self.interrupt then
		self:SetStatusBarColor(interruptcb[1],interruptcb[2],interruptcb[3],1)
	else
		self:SetStatusBarColor(pcolor[1], pcolor[2], pcolor[3],1)
	end
end

CastBar_PostCastStop = function(self, unit, name, rank, castid)
	if not self.fadeOut then 
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.max)
	self:Show()
end

CastBar_PostChannelStop = function(self, unit, name, rank)
	self.fadeOut = true
	self:SetValue(0)
	self:Show()
end

CastBar_PostCastFailed = function(self, event, unit, name, rank, castid)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	if not self.fadeOut then
		self.fadeOut = true
	end
	self:Show()
end	

--castbar--
local cbColor = {95/255, 182/255, 255/255}

function EnableCB(self)

end

function DisableCB(self)

end

--- ----------------------------------
--> Create CastBar
--- ----------------------------------



function CreateCastBar(f, unit)


	s = CreateFrame("StatusBar", "oUF_Castbar"..f.unit, f)--"oUF_Castbar"..f.mystyle
	s:SetHeight(A["PlayerCastBarHeight"]) -- 高度
	s:SetWidth(A["PlayerCastBarWidth"]) -- 寬度
	if f.unit == "player" then
		--s:SetPoint(unpack(C["PlayerCastbar"]))
		s:SetPoint("BOTTOM","Castbarplay","BOTTOM", 0, 0)
	elseif f.unit == "target" then	
    s:SetHeight(A["TargetCastBarHeight"])
	s:SetWidth(A["TargetCastBarWidth"])
		--s:SetPoint(unpack(C["TargetCastbar"]))
		s:SetPoint("BOTTOM","Castbartarget","BOTTOM", 0, 0)
	elseif f.unit == "focus" then
		s:SetHeight(A["FocusCastBarHeight"])
		s:SetWidth(A["FocusCastBarWidth"])
		--s:SetPoint(unpack(C["FocusCastbar"]))
		s:SetPoint("BOTTOM","Castbarfouce","BOTTOM", 0, 0)
	elseif f.unit == "pet" then
		s:SetHeight(A["PetCastBarHeight"])
		s:SetWidth(A["PetCastBarWidth"])
		--s:SetPoint(unpack(C["PetCastbar"]))
		s:SetPoint("BOTTOM","Castbarpet","BOTTOM", 0, 0)
	else
		s:SetPoint("CENTER",UIParent,"CENTER",-182,-248)
			
	end
	
	s:SetStatusBarTexture(bar_texture)
	S.MakeBG(s, 0)
		local spar = s:CreateTexture(nil, "OVERLAY")
		spar:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
		spar:SetBlendMode("ADD")
		spar:SetAlpha(.8)
		spar:SetPoint("TOPLEFT", s:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
		spar:SetPoint("BOTTOMRIGHT", s:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)
	--fixStatusbar(s)
	s:SetStatusBarColor(95/255, 182/255, 255/255,1)
	s:SetFrameLevel(1)
	s.CastingColor = cbColor
	s.CompleteColor = {20/255, 208/255, 0/255}
	s.FailColor = {255/255, 12/255, 0/255}
	s.ChannelingColor = cbColor

	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	S.MakeTexShadow(h, s, 3)
	
	--CreateShadow(h)
    sp = s:CreateTexture(nil, "OVERLAY")
    sp:SetBlendMode("ADD")
    sp:SetAlpha(0.5)
    sp:SetHeight(s:GetHeight()*2.5)
	--castbar txt--
    local txt = fontstring(s, NameFont, 15, "OUTLINE")
    txt:SetPoint("LEFT", 2, 7)
    txt:SetJustifyH("LEFT")
    local t = fontstring(s, NumbFont, 12, "OUTLINE")
    t:SetPoint("RIGHT", -2, 7)
    txt:SetPoint("RIGHT", t, "LEFT", -5, 2)
	
	--castbar icon--
	
    local 
	i = s:CreateTexture(nil, "ARTWORK")
	i:SetSize(A["Icon"], A["Icon"])
	i:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	i:SetPoint("BOTTOMRIGHT", s, "BOTTOMLEFT", -5, 0)
	--i:SetPoint("BOTTOM", s, "TOP", 0, 5)
	i.Shadow = S.MakeTexShadow(s, i, 3)
	--[[i = s:CreateTexture(nil, "ARTWORK")
    i:SetSize(L["Icon"], L["Icon"])
	if f.unit == "target" then
	i:SetSize(L["Icon"], L["Icon"])
	end	
	if f.unit == "player" then
    i:SetPoint("BOTTOMRIGHT", s, "BOTTOMLEFT", -5, 0)
	if f.unit == "target" then
	i:SetPoint("LEFT", s, "RIGHT", 2, 0)
	else
    i:SetPoint("RIGHT", s, "LEFT", -4, 0)
	end
    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    local h2 = CreateFrame("Frame", nil, s)
    h2:SetFrameLevel(0)
    h2:SetPoint("TOPLEFT",i,"TOPLEFT",-5,5)
    h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
	Castframe(h2)
	end--]]

	
	
    if f.unit == "player" then
      local z = s:CreateTexture(nil,"OVERLAY")
      z:SetTexture(bar_texture)
      z:SetVertexColor(1,0.1,0,.6)
      z:SetPoint("TOPRIGHT")
      z:SetPoint("BOTTOMRIGHT")
	  s:SetFrameLevel(10)
      s.SafeZone = z
      local l = fontstring(s, NumbFont, 14, "THINOUTLINE")
      l:SetPoint("CENTER", -2, 17)
      l:SetJustifyH("RIGHT")
	  l:Hide()
      s.Lag = l
      f:RegisterEvent("UNIT_SPELLCAST_SENT", CastBar_OnCastSent)
    end
	
	s.OnUpdate = CastBar_OnCastbarUpdate
    s.PostCastStart = CastBar_PostCastStart
    s.PostChannelStart = CastBar_PostCastStart
    s.PostCastStop = CastBar_PostCastStop
    s.PostChannelStop = CastBar_PostChannelStop
    s.PostCastFailed = CastBar_PostCastFailed
    s.PostCastInterrupted = CastBar_PostCastFailed
	
    f.Castbar = s
    f.Castbar.Text = txt
    f.Castbar.Time = t
    f.Castbar.Icon = i
    f.Castbar.Spark = sp
end
--- ----------------------------------
--> End
--- ----------------------------------

oUF:AddElement("CastBar", UpdateCB, EnableCB, DisableCB)