local S, L, DB, _, C = unpack(select(2, ...))
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local MB = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("MirrorBars", "AceEvent-3.0")
local settings = { 
   width = 252, 
   height = 18, 
   texture = DB.Statusbar, 
 
   position = { 
      ["BREATH"] = 'TOP#UIParent#TOP#0#-96'; 
      ["EXHAUSTION"] = 'TOP#UIParent#TOP#0#-119'; 
      ["FEIGNDEATH"] = 'TOP#UIParent#TOP#0#-142'; 
   }; 

   colors = { 
		EXHAUSTION = {1, .9, 0}; 
		BREATH = {0.31, 0.45, 0.63}; 
		DEATH = {1, .7, 0}; 
		FEIGNDEATH = {1, .7, 0}; 
   }; 
} 

local function SkinIt(bar)    
	local _, originalPoint, _, _, _ = bar:GetPoint() 
    
	bar:ClearAllPoints() 
	bar:SetPoint("TOPLEFT", originalPoint, "TOPLEFT", 2, -2) 
	bar:SetPoint("BOTTOMRIGHT", originalPoint, "BOTTOMRIGHT", -2, 2) 
       
	for i=1, bar:GetNumRegions() do 
		local region = select(i, bar:GetRegions()) 
		if region:GetObjectType() == "Texture" then 
			region:SetTexture(nil) 
		elseif region:GetObjectType() == "FontString" then 
			region:SetFont(DB.Font, 12, "THINOUTLINE") 
			region:SetShadowColor(0,0,0,0) 
		end 
	end 
end 


local function SkinBlizzTimer(self, event) 
	for _, b in pairs(TimerTracker.timerList) do 
		if not b["bar"].skinned then 
			SkinIt(b["bar"]) 
			b["bar"].skinned = true 
		end 
	end 
end

local Spawn, PauseAll 
do 
	local barPool = {} 

	local loadPosition = function(self) 
		local pos = settings.position[self.type] 
		local p1, frame, p2, x, y = strsplit("#", pos) 

		return self:SetPoint(p1, frame, p2, x, y) 
	end 

	local OnUpdate = function(self, elapsed) 
		if(self.paused) then return end 

		self:SetValue(GetMirrorTimerProgress(self.type) / 1e3) 
	end 

	local Start = function(self, value, maxvalue, scale, paused, text) 
		if(paused > 0) then 
			self.paused = 1 
		elseif(self.paused) then 
			self.paused = nil 
		end 

		self.text:SetText(text) 

		self:SetMinMaxValues(0, maxvalue / 1e3) 
		self:SetValue(value / 1e3) 

		if(not self:IsShown()) then self:Show() end 
	end 

	function Spawn(type) 
		if(barPool[type]) then return barPool[type] end 
		local frame = CreateFrame('StatusBar', nil, UIParent) 

		frame:SetScript("OnUpdate", OnUpdate) 

		local r, g, b = unpack(settings.colors[type]) 
		frame:CreateShadow("")
		S.CreateBack(frame)
		

		local text = frame:CreateFontString(nil, 'OVERLAY') 
		text:SetFont(GameFontNormalSmall:GetFont(), 14, "THINOUTLINE") 
		text:SetShadowOffset(1, -1) 
		text:SetShadowColor(0, 0, 0, 1) 

		text:SetJustifyH'CENTER' 
		text:SetTextColor(1, 1, 1) 

		text:SetPoint('LEFT', frame) 
		text:SetPoint('RIGHT', frame) 
		text:SetPoint('TOP', frame, 0, 2) 
		text:SetPoint('BOTTOM', frame) 

		frame:SetSize(settings.width, settings.height) 

		frame:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)

		S.CreateTop(frame:GetStatusBarTexture(), r, g, b)
		S.CreateMark(frame)
	  
		frame.type = type 
		frame.text = text 

		frame.Start = Start 
		frame.Stop = Stop 

		loadPosition(frame) 

		barPool[type] = frame 
		return frame 
	end 

	function PauseAll(val) 
		for _, bar in next, barPool do 
			bar.paused = val 
		end 
	end 
end 

local function On_ADDON_LOADED()
	UIParent:UnregisterEvent'MIRROR_TIMER_START' 
	MB:UnregisterEvent'ADDON_LOADED' 
end 

local function On_PLAYER_ENTERING_WORLD() 
	for i=1, MIRRORTIMER_NUMTIMERS do 
		local type, value, maxvalue, scale, paused, text = GetMirrorTimerInfo(i) 
		if(type ~= 'UNKNOWN') then 
			Spawn(type):Start(value, maxvalue, scale, paused, text) 
		end 
	end 
end

local function On_MIRROR_TIMER_START(event, type, value, maxvalue, scale, paused, text)
	return Spawn(type):Start(value, maxvalue, scale, paused, text) 
end

local function On_MIRROR_TIMER_STOP(event, type) 
	return Spawn(type):Hide() 
end 

local function On_MIRROR_TIMER_PAUSE(event, duration) 
	return PauseAll((duration > 0 and duration) or nil) 
end 
function MB:OnInitialize()
	MB:RegisterEvent("ADDON_LOADED", On_ADDON_LOADED)
	MB:RegisterEvent("PLAYER_ENTERING_WORLD", On_PLAYER_ENTERING_WORLD)
	MB:RegisterEvent("MIRROR_TIMER_START", On_MIRROR_TIMER_START)
	MB:RegisterEvent("MIRROR_TIMER_STOP", On_MIRROR_TIMER_STOP)
	MB:RegisterEvent("MIRROR_TIMER_PAUSE", On_MIRROR_TIMER_PAUSE)
end