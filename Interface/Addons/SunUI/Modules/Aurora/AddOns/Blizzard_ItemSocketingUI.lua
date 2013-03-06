local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_ItemSocketingUI"] = function()
	ItemSocketingFrame:DisableDrawLayer("BORDER")
	ItemSocketingFrame:DisableDrawLayer("ARTWORK")
	ItemSocketingScrollFrameTop:SetAlpha(0)
	ItemSocketingScrollFrameMiddle:SetAlpha(0)
	ItemSocketingScrollFrameBottom:SetAlpha(0)
	ItemSocketingSocket1Left:SetAlpha(0)
	ItemSocketingSocket1Right:SetAlpha(0)
	ItemSocketingSocket2Left:SetAlpha(0)
	ItemSocketingSocket2Right:SetAlpha(0)
	ItemSocketingSocket3Left:SetAlpha(0)
	ItemSocketingSocket3Right:SetAlpha(0)

	for i = 1, MAX_NUM_SOCKETS do
		local bu = _G["ItemSocketingSocket"..i]

		_G["ItemSocketingSocket"..i.."BracketFrame"]:Hide()
		_G["ItemSocketingSocket"..i.."Background"]:SetAlpha(0)
		select(2, bu:GetRegions()):Hide()

		bu:SetPushedTexture("")
		bu.icon:SetTexCoord(.08, .92, .08, .92)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetAllPoints(bu)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		S.CreateBD(bg, .25)

		bu.glow = CreateFrame("Frame", nil, bu)
		bu.glow:SetBackdrop({
			edgeFile = DB.media.glow,
			edgeSize = 4,
		})
		bu.glow:Point("TOPLEFT", -4, 4)
		bu.glow:Point("BOTTOMRIGHT", 4, -4)
	end

	hooksecurefunc("ItemSocketingFrame_Update", function()
		for i = 1, MAX_NUM_SOCKETS do
			local color = GEM_TYPE_INFO[GetSocketTypes(i)]
			_G["ItemSocketingSocket"..i].glow:SetBackdropBorderColor(color.r, color.g, color.b)

		end

		local num = GetNumSockets()
		if num == 3 then
			ItemSocketingSocket1:Point("BOTTOM", ItemSocketingFrame, "BOTTOM", -75, 39)
		elseif num == 2 then
			ItemSocketingSocket1:Point("BOTTOM", ItemSocketingFrame, "BOTTOM", -35, 39)
		else
			ItemSocketingSocket1:Point("BOTTOM", ItemSocketingFrame, "BOTTOM", 0, 39)
		end
	end)

	S.ReskinPortraitFrame(ItemSocketingFrame, true)
	S.CreateBD(ItemSocketingScrollFrame, .25)
	S.Reskin(ItemSocketingSocketButton)
	S.ReskinScroll(ItemSocketingScrollFrameScrollBar)
end