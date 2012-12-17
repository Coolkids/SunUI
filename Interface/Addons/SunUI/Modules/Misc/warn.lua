local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Warnning", "AceEvent-3.0")

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


local function Health(event, unit)
	if unit ~= "player" then return end
	if ( UnitHealth("player")/UnitHealthMax("player") < 0.3 ) and not UnitIsDead("player") and not UnitIsGhost("player") then
		f:Show()
		if not f.tex.anim:IsPlaying() then
			f.tex.anim:Play()
		end
	else
		f:Hide()
		if f.tex.anim:IsPlaying() then
			f.tex.anim:Stop()
		end
	end
end

function Module:OnEnable()
	if C["WarnDB"]["Open"] then
		Module:RegisterEvent("PLAYER_DEAD", Health)
		Module:RegisterEvent("UNIT_HEALTH", Health)
	else
		f = nil
		f.tex.anim = nil
	end
end