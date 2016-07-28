local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local mod=E:GetModule("SunUI-Modules", 'AceTimer-3.0', 'AceHook-3.0', 'AceEvent-3.0')

function mod:CreateMiniFlash()
	local PMinimap = CreateFrame("Frame", nil, Minimap)
	PMinimap:SetFrameStrata("BACKGROUND")
	PMinimap:SetFrameLevel(0)
	PMinimap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -150, 150)
	PMinimap:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 150, -150)
	PMinimap.texture = PMinimap:CreateTexture(nil)
	PMinimap.texture:SetAllPoints(PMinimap)
	PMinimap.texture:SetTexture("World\\GENERIC\\ACTIVEDOODADS\\INSTANCEPORTAL\\GENERICGLOW2.BLP")
	PMinimap.texture:SetVertexColor(E.myclasscolor.r, E.myclasscolor.g, E.myclasscolor.b)
	PMinimap.texture:SetBlendMode("ADD")
	
	PMinimap.texture.anim = PMinimap.texture:CreateAnimationGroup()
	
	PMinimap.texture.anim.fadeout = PMinimap.texture.anim:CreateAnimation("ALPHA", "FadeOut")
	PMinimap.texture.anim.fadeout:SetFromAlpha(1)
	PMinimap.texture.anim.fadeout:SetToAlpha(0)
	PMinimap.texture.anim.fadeout:SetOrder(1)
	PMinimap.texture.anim.fadeout:SetDuration(3)

	PMinimap.texture.anim.fade = PMinimap.texture.anim:CreateAnimation("ALPHA", "FadeOut")
	PMinimap.texture.anim.fade:SetFromAlpha(0)
	PMinimap.texture.anim.fade:SetToAlpha(0)
	PMinimap.texture.anim.fade:SetOrder(2)
	PMinimap.texture.anim.fade:SetDuration(2)
	
	PMinimap.texture.anim.fadein = PMinimap.texture.anim:CreateAnimation("ALPHA", "FadeIn")
	PMinimap.texture.anim.fadein:SetFromAlpha(0)
	PMinimap.texture.anim.fadein:SetToAlpha(1)
	PMinimap.texture.anim.fadein:SetOrder(3)
	PMinimap.texture.anim.fadein:SetDuration(3)
	
	PMinimap.texture.anim.fade2 = PMinimap.texture.anim:CreateAnimation("ALPHA", "FadeIn")
	PMinimap.texture.anim.fade2:SetFromAlpha(1)
	PMinimap.texture.anim.fade2:SetToAlpha(1)
	PMinimap.texture.anim.fade2:SetOrder(4)
	PMinimap.texture.anim.fade2:SetDuration(2)
	
	PMinimap.texture.anim:SetLooping("REPEAT")
	PMinimap.texture.anim:Play()
end