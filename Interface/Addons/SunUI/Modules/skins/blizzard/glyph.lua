local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b
	
	GlyphFrameBackground:Hide()
	GlyphFrameSideInset:DisableDrawLayer("BACKGROUND")
	GlyphFrameSideInset:DisableDrawLayer("BORDER")
	GlyphFrame.specRing:SetTexture("")
	A:CreateBG(GlyphFrameClearInfoFrame)
	GlyphFrameClearInfoFrameIcon:SetTexCoord(.08, .92, .08, .92)

	for i = 1, 2 do
		_G["GlyphFrameHeader"..i.."Left"]:Hide()
		_G["GlyphFrameHeader"..i.."Middle"]:Hide()
		_G["GlyphFrameHeader"..i.."Right"]:Hide()

	end

	A:CreateBDFrame(GlyphFrame.specIcon, 0)
	GlyphFrame.specIcon:SetTexCoord(.08, .92, .08, .92)

	local function onUpdate(self)
		local id = self:GetID()
		if GlyphMatchesSocket(id) then
			self.bg:SetBackdropBorderColor(r, g, b)
		else
			self.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end

	for i = 1, NUM_GLYPH_SLOTS do
		local glyph = _G["GlyphFrameGlyph"..i]

		glyph.ring:SetAlpha(0)
		glyph.glyph:SetTexCoord(.08, .92, .08, .92)
		glyph.highlight:SetTexture("")
		if (i==1) or (i==3) or (i==5) then
			local w,h = glyph:GetWidth(), glyph:GetHeight()
			glyph:SetSize(w-10,h-10)
		end
		glyph.glyph:SetAllPoints(glyph.glyph:GetParent())
		glyph.bg = A:CreateBDFrame(glyph.glyph, .25)

		glyph:HookScript("OnUpdate", onUpdate)
	end

	hooksecurefunc("GlyphFrame_Update", function(self)
		local spec = GetSpecialization(false, false, PlayerTalentFrame.talentGroup)
		if spec then
			local _, _, _, icon = GetSpecializationInfo(spec, false, self.isPet)
			GlyphFrame.specIcon:SetTexture(icon)
		end
	end)

	hooksecurefunc("GlyphFrameGlyph_UpdateSlot", function(self)
		local id = self:GetID();
		local talentGroup = PlayerTalentFrame and PlayerTalentFrame.talentGroup
		local enabled, glyphType, glyphTooltipIndex, glyphSpell, iconFilename = GetGlyphSocketInfo(id, talentGroup)

		if not glyphType then return end

		if enabled and glyphSpell and iconFilename then
			self.glyph:SetTexture(iconFilename)
		end
	end)

	for i = 1, #GlyphFrame.scrollFrame.buttons do
		local bu = _G["GlyphFrameScrollFrameButton"..i]
		local ic = _G["GlyphFrameScrollFrameButton"..i.."Icon"]

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 38, -2)
		bg:SetPoint("BOTTOMRIGHT", 0, 2)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		A:CreateBD(bg, .25)

		_G["GlyphFrameScrollFrameButton"..i.."Name"]:SetParent(bg)
		_G["GlyphFrameScrollFrameButton"..i.."TypeName"]:SetParent(bg)
		bu:SetHighlightTexture("")
		bu.disabledBG:SetTexture("")
		select(4, bu:GetRegions()):SetAlpha(0)

		local check = select(2, bu:GetRegions())
		check:SetPoint("TOPLEFT", 39, -3)
		check:SetPoint("BOTTOMRIGHT", -1, 3)
		check:SetTexture(A.media.backdrop)
		check:SetVertexColor(r, g, b, .2)

		A:CreateBG(ic)

		ic:SetTexCoord(.08, .92, .08, .92)
	end

	A:ReskinInput(GlyphFrameSearchBox)
	A:ReskinScroll(GlyphFrameScrollFrameScrollBar)
	A:ReskinDropDown(GlyphFrameFilterDropDown)
end

A:RegisterSkin("Blizzard_GlyphUI", LoadSkin)