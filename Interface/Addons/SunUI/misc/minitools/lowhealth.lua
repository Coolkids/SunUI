local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local LH = S:GetModule("MiniTools")

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

f.tex.anim.fadeout = f.tex.anim:CreateAnimation("ALPHA", "FadeOut")
f.tex.anim.fadeout:SetOrder(1)
f.tex.anim.fadeout:SetFromAlpha(1)
f.tex.anim.fadeout:SetToAlpha(0)
f.tex.anim.fadeout:SetDuration(0.5)

f.tex.anim.fadein = f.tex.anim:CreateAnimation("ALPHA", "FadeIn")
f.tex.anim.fadein:SetOrder(2)
f.tex.anim.fadein:SetFromAlpha(0)
f.tex.anim.fadein:SetToAlpha(1)
f.tex.anim.fadein:SetDuration(0.5)

f.tex.anim:SetLooping("REPEAT")

function LH:UNIT_HEALTH(event, unit)
	if unit ~= "player" then return end
	if ( UnitHealth("player")/UnitHealthMax("player") < self.db.LowHealthPer ) and not UnitIsDead("player") and not UnitIsGhost("player") then
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
function LH:PLAYER_DEAD()
	self:UNIT_HEALTH(nil, "player")
end
function LH:UpdateLowHealthSet()
	if self.db.LowHealth then
		LH:RegisterEvent("PLAYER_DEAD")
		LH:RegisterEvent("UNIT_HEALTH")
	else
		LH:UnregisterEvent("PLAYER_DEAD")
		LH:UnregisterEvent("UNIT_HEALTH")
		f:Hide()
		if f.tex.anim:IsPlaying() then
			f.tex.anim:Stop()
		end
	end
end