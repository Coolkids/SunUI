local S, C, L, DB = unpack(select(2, ...))
local _
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Warnning")

local f = CreateFrame("Frame", nil, UIParent)
f:SetToplevel(true)
f:SetFrameStrata("FULLSCREEN_DIALOG")
f:SetAllPoints(UIParent)
f:EnableMouse(false)
f:Hide()
f.tex = f:CreateTexture()
f.tex:SetTexture("Interface\\FullScreenTextures\\LowHealth")
f.tex:SetAllPoints(f)
f.tex:SetBlendMode("ADD")

f.tex.anim = f.tex:CreateAnimationGroup()
	
f.tex.anim.fadeout = f.tex.anim:CreateAnimation("ALPHA")
f.tex.anim.fadeout:SetChange(-1)
f.tex.anim.fadeout:SetOrder(1)
f.tex.anim.fadeout:SetDuration(0.5)

f.tex.anim.fadein = f.tex.anim:CreateAnimation("ALPHA")
f.tex.anim.fadein:SetChange(1)
f.tex.anim.fadein:SetOrder(2)
f.tex.anim.fadein:SetDuration(0.5)

f.tex.anim:SetLooping("REPEAT")

f:RegisterEvent("PLAYER_DEAD")
f:RegisterEvent("UNIT_HEALTH")
f:SetScript("OnEvent", function(self, event, unit)
	if unit ~= "player" then return end
	if ( UnitHealth("player")/UnitHealthMax("player") < 0.25 ) and not UnitIsDead("player") and not UnitIsGhost("player") then
		self:Show()
		if not self.tex.anim:IsPlaying() then
			self.tex.anim:Play()
		end
	else
		self:Hide()
		if self.tex.anim:IsPlaying() then
			self.tex.anim:Stop()
		end
	end
end)

function Module:OnEnable()
	if not C["WarnDB"]["Open"] then
		f:UnregisterAllEvents()
		f = nil
	end
end