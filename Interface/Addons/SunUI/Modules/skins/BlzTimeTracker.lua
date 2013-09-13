local S, L, DB, _, C = unpack(select(2, ...))
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
--Dummy Bar
--/run TimerTracker_OnLoad(TimerTracker); TimerTracker_OnEvent(TimerTracker, "START_TIMER", 1, 30, 30)
local function SkinIt(bar)
	for i=1, bar:GetNumRegions() do
		local region = select(i, bar:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			region:SetFont(DB.Font, 14*(SunUIConfig.db.profile.MiniDB.FontScale)*S.Scale(1), "THINOUTLINE")
			region:SetShadowColor(0,0,0,0)
		end
	end
	
	bar:SetStatusBarTexture(DB.Statusbar2)
	--bar:SetStatusBarColor(95/255, 182/255, 255/255)
	bar:CreateShadow("Background")
	--S.CreateBack(bar)
	S.CreateMark(bar)
	--local texture = bar:GetStatusBarTexture()
	--S.CreateTop(texture, 95/255, 182/255, 255/255)
end

local function SkinBlizzTimer()	
	for _, b in pairs(TimerTracker.timerList) do
		if b["bar"] and not b["bar"].skinned then
			SkinIt(b["bar"])
			b["bar"].skinned = true
		end
	end
end

local load = CreateFrame("Frame")
load:RegisterEvent("START_TIMER")
load:SetScript("OnEvent", SkinBlizzTimer)