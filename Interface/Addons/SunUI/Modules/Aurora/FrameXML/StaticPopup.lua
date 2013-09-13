local S, L, DB, _, C = unpack(select(2, ...))

local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

tinsert(DB.AuroraModules["SunUI"], function()
	local r, g, b = DB.r, DB.g, DB.b

	local function colourMinimize(f)
		if f:IsEnabled() then
			f.minimize:SetVertexColor(r, g, b)
		end
	end

	local function clearMinimize(f)
		f.minimize:SetVertexColor(1, 1, 1)
	end

	for i = 1, 4 do
		local frame = _G["StaticPopup"..i]
		local bu = _G["StaticPopup"..i.."ItemFrame"]
		local close = _G["StaticPopup"..i.."CloseButton"]

		local gold = _G["StaticPopup"..i.."MoneyInputFrameGold"]
		local silver = _G["StaticPopup"..i.."MoneyInputFrameSilver"]
		local copper = _G["StaticPopup"..i.."MoneyInputFrameCopper"]

		_G["StaticPopup"..i.."ItemFrameNameFrame"]:Hide()
		_G["StaticPopup"..i.."ItemFrameIconTexture"]:SetTexCoord(.08, .92, .08, .92)

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")
		bu:SetPushedTexture("")
		S.CreateBG(bu)

		silver:Point("LEFT", gold, "RIGHT", 1, 0)
		copper:Point("LEFT", silver, "RIGHT", 1, 0)

		S.CreateBD(frame)
		S.CreateSD(frame)

		for j = 1, 3 do
			S.Reskin(frame["button"..j])
		end

		S.ReskinClose(close)

		close.minimize = close:CreateTexture(nil, "OVERLAY")
		close.minimize:SetSize(9, 1)
		close.minimize:SetPoint("CENTER")
		close.minimize:SetTexture(DB.media.backdrop)
		close.minimize:SetVertexColor(1, 1, 1)
		close:HookScript("OnEnter", colourMinimize)
		close:HookScript("OnLeave", clearMinimize)

		S.ReskinInput(_G["StaticPopup"..i.."EditBox"], 20)
		S.ReskinInput(gold)
		S.ReskinInput(silver)
		S.ReskinInput(copper)
	end

	hooksecurefunc("StaticPopup_Show", function(which, text_arg1, text_arg2, data)
		local info = StaticPopupDialogs[which]

		if not info then return end

		local dialog = nil
		dialog = StaticPopup_FindVisible(which, data)

		if not dialog then
			local index = 1
			if info.preferredIndex then
				index = info.preferredIndex
			end
			for i = index, STATICPOPUP_NUMDIALOGS do
				local frame = _G["StaticPopup"..i]
				if not frame:IsShown() then
					dialog = frame
					break
				end
			end

			if not dialog and info.preferredIndex then
				for i = 1, info.preferredIndex do
					local frame = _G["StaticPopup"..i]
					if not frame:IsShown() then
						dialog = frame
						break
					end
				end
			end
		end

		if not dialog then return end

		if info.closeButton then
			local closeButton = _G[dialog:GetName().."CloseButton"]

			closeButton:SetNormalTexture("")
			closeButton:SetPushedTexture("")

			if info.closeButtonIsHide then
				for _, pixel in pairs(closeButton.pixels) do
					pixel:Hide()
				end
				closeButton.minimize:Show()
			else
				for _, pixel in pairs(closeButton.pixels) do
					pixel:Show()
				end
				closeButton.minimize.Hide()
			end
		end
	end)
end)