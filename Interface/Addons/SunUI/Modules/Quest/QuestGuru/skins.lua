local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function SkinFrame()
	local QT = S:GetModule("Quest")
	if not QT.db.QuestGuru then return end
	QuestGuru:StripTextures(true)
	QuestGuru:SetFrameLevel(90)
	QuestGuru:SetFrameStrata("HIGH")
	QuestGuruInset:Kill()
	QuestGuruScrollFrameScrollBar:StripTextures(true)
	QuestGuru.mapButton:SetHighlightTexture("")
	QuestGuru.mapButton:SetDisabledTexture("")
	--A:Reskin(QuestGuru.abandon)
	--A:Reskin(QuestGuru.push)
	--A:Reskin(QuestGuru.track)
	for i=1, QuestGuru:GetNumChildren() do
		local region = select(i, QuestGuru:GetChildren())
		if region and region:GetObjectType() == "Button" then
			if region:GetText() then
				A:Reskin(region)
			end
		end
	end
	QuestGuru.emptyLog:Kill()
	A:ReskinClose(QuestGuruCloseButton)
	
	A:ReskinScroll(QuestGuruScrollFrameScrollBar)
	A:ReskinScroll(QuestGuruDetailScrollFrameScrollBar)
	
	QGC_FrameTitleText:SetFormattedText(QUESTLOG_BUTTON)
	QGC_FrameTitleText.SetFormattedText = S.dummy
	A:SetBD(QuestGuru)
end

A:RegisterSkin("SunUI", SkinFrame)