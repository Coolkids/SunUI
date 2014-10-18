local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function SkinAce3()
	local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
	if not AceGUI then return end
	local oldRegisterAsWidget = AceGUI.RegisterAsWidget

	local r, g, b = S.myclasscolor.r, S.myclasscolor.g, S.myclasscolor.b

	AceGUI.RegisterAsWidget = function(self, widget)
		local TYPE = widget.type
		--print(TYPE)
		if TYPE == "MultiLineEditBox" then
			local frame = widget.frame
			A:Reskin(widget.button)
			A:ReskinScroll(widget.scrollBar)
		elseif TYPE == "CheckBox" then
			widget.checkbg:Kill()
			widget.highlight:Kill()
			widget.frame:SetHighlightTexture(A["media"].backdrop)
			local hl = widget.frame:GetHighlightTexture()
			hl:SetPoint("TOPLEFT", widget.checkbg, 5, -5)
			hl:SetPoint("BOTTOMRIGHT", widget.checkbg, -5, 5)
			hl:SetVertexColor(r, g, b)

			if not widget.skinnedCheckBG then
				widget.skinnedCheckBG = CreateFrame('Frame', nil, widget.frame)
				widget.skinnedCheckBG:SetPoint('TOPLEFT', widget.checkbg, 'TOPLEFT', 4, -4)
				widget.skinnedCheckBG:SetPoint('BOTTOMRIGHT', widget.checkbg, 'BOTTOMRIGHT', -4, 4)
				A:CreateBD(widget.skinnedCheckBG, 0)
				A:CreateBackdropTexture(widget.skinnedCheckBG)
			end

			if widget.skinnedCheckBG.oborder then
				widget.check:SetParent(widget.skinnedCheckBG.oborder)
			else
				widget.check:SetParent(widget.skinnedCheckBG)
			end
			--widget.check:SetTexture("")
			widget.check:SetTexture(A["media"].backdrop)
			widget.check.SetTexture = function() end
			widget.check:SetPoint("TOPLEFT", widget.checkbg, 5, -5)
			widget.check:SetPoint("BOTTOMRIGHT", widget.checkbg, -5, 5)
			--print(widget.check:GetTexture())
			widget.check:SetDesaturated(true)
			widget.check:SetVertexColor(r, g, b)
			
		elseif TYPE == "Dropdown" then
			local frame = widget.dropdown
			local button = widget.button
			local text = widget.text
			frame:StripTextures()
			local bg = CreateFrame("Frame", nil, frame)
			bg:SetPoint("TOPLEFT", 16, 0)
			bg:SetPoint("BOTTOMRIGHT", -15, 0)
			bg:SetFrameLevel(frame:GetFrameLevel()-1)
			A:CreateBD(bg, 0)
			A:CreateBackdropTexture(bg)

			A:Reskin(button)
			button:SetSize(25, 25)
			button:ClearAllPoints()
			button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -15, 0)
			button:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -15, 0)

			button:SetDisabledTexture(A["media"].backdrop)
			local dis = button:GetDisabledTexture()
			dis:SetVertexColor(0, 0, 0, .3)
			dis:SetDrawLayer("OVERLAY")

			local downtex = button:CreateTexture(nil, "ARTWORK")
			downtex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-down-active")
			downtex:SetSize(8, 8)
			downtex:SetPoint("CENTER")
			downtex:SetVertexColor(1, 1, 1)

			button:SetParent(bg)
			text:SetParent(bg)
			button:HookScript('OnClick', function(this)
				local self = this.obj
				A:CreateBD(self.pullout.frame)
			end)
		elseif TYPE == "LSM30_Font" or TYPE == "LSM30_Sound" or TYPE == "LSM30_Border" or TYPE == "LSM30_Background" or TYPE == "LSM30_Statusbar" then
			local frame = widget.frame
			local button = frame.dropButton
			local text = frame.text
			frame:StripTextures()

			A:Reskin(button)
			button:SetSize(20, 20)

			button:SetDisabledTexture(A["media"].backdrop)
			local dis = button:GetDisabledTexture()
			dis:SetVertexColor(0, 0, 0, .3)
			dis:SetDrawLayer("OVERLAY")

			local downtex = button:CreateTexture(nil, "ARTWORK")
			downtex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-down-active")
			downtex:SetSize(8, 8)
			downtex:SetPoint("CENTER")
			downtex:SetVertexColor(1, 1, 1)
			frame.text:ClearAllPoints()
			frame.text:SetPoint('RIGHT', button, 'LEFT', -2, 0)

			if not frame.backdrop then
				frame.backdrop = CreateFrame("Frame", nil, frame)
				frame.backdrop:SetPoint("TOPLEFT", -3, 3)
				frame.backdrop:SetPoint("BOTTOMRIGHT", 3, -3)
				A:CreateBackdropTexture(frame.backdrop)
				A:CreateBD(frame.backdrop)
				if frame:GetFrameLevel() - 1 >= 0 then
					frame.backdrop:SetFrameLevel(frame:GetFrameLevel() - 1)
				else
					frame.backdrop:SetFrameLevel(0)
				end
				if TYPE == "LSM30_Font" then
					frame.backdrop:SetPoint("TOPLEFT", 20, -20)
				elseif TYPE == "LSM30_Sound" then
					frame.backdrop:SetPoint("TOPLEFT", 20, -20)
					widget.soundbutton:SetParent(frame.backdrop)
					widget.soundbutton:ClearAllPoints()
					widget.soundbutton:SetPoint('LEFT', frame.backdrop, 'LEFT', 2, 0)
				elseif TYPE == "LSM30_Statusbar" then
					frame.backdrop:SetPoint("TOPLEFT", 20, -20)
					widget.bar:ClearAllPoints()
					widget.bar:SetPoint('TOPLEFT', frame.backdrop, 'TOPLEFT', 2, -2)
					widget.bar:SetPoint('BOTTOMRIGHT', frame.backdrop, 'BOTTOMRIGHT', -2, 2)
					widget.bar:SetParent(frame.backdrop)
				elseif TYPE == "LSM30_Border" or TYPE == "LSM30_Background" then
					frame.backdrop:SetPoint("TOPLEFT", 42, -20)
				end

				frame.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 3)
			end
			button:SetParent(frame.backdrop)
			button:ClearAllPoints()
			button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -20)
			button:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 3)
			text:SetParent(frame.backdrop)
			button:HookScript('OnClick', function(this, button)
				local self = this.obj
				if self.dropdown then
					A:CreateBD(self.dropdown)
				end
			end)
		elseif TYPE == "EditBox" then
			local frame = widget.editbox
			local button = widget.button
			-- frame:StripTextures()
			frame.Left:Kill()
			frame.Middle:Kill()
			frame.Right:Kill()
			A:ReskinInput(frame)
			button:ClearAllPoints()
			button:SetPoint("RIGHT", frame, "RIGHT", -7, 0)
			button:SetParent(frame)
			A:Reskin(button)
		elseif TYPE == "Button" then
			local frame = widget.frame
			A:Reskin(frame)
		elseif TYPE == "Slider" then
			local frame = widget.slider
			local editbox = widget.editbox
			local lowtext = widget.lowtext
			local hightext = widget.hightext
			local HEIGHT = 12

			frame:StripTextures()
			A:CreateBD(frame, 0)
			frame:SetHeight(HEIGHT)
			A:CreateBackdropTexture(frame)

			local slider = frame:GetThumbTexture()
			slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
			slider:SetBlendMode("ADD")

			A:CreateBD(editbox, 0)
			editbox.SetBackdropColor = function() end
			editbox.SetBackdropBorderColor = function() end
			editbox:SetHeight(15)
			editbox:SetPoint("TOP", frame, "BOTTOM", 0, -1)
			A:CreateBackdropTexture(editbox)

			lowtext:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 2, -2)
			hightext:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -2, -2)


		--[[elseif TYPE == "ColorPicker" then
			local frame = widget.frame
			local colorSwatch = widget.colorSwatch
		]]
		elseif TYPE == "Heading" then
			widget.left:SetHeight(1)
			widget.left:SetTexture(.4, .4, .4)
			widget.left:SetGradientAlpha("HORIZONTAL", .8, .8, .8, 0, .8, .8, .8, 1)
			widget.right:SetHeight(1)
			widget.right:SetTexture(.4, .4, .4)
			widget.right:SetGradientAlpha("HORIZONTAL", .8, .8, .8, 1, .8, .8, .8, 0)
		end
		return oldRegisterAsWidget(self, widget)
	end

	local oldRegisterAsContainer = AceGUI.RegisterAsContainer

	AceGUI.RegisterAsContainer = function(self, widget)
		local TYPE = widget.type
		if TYPE == "ScrollFrame" then
			local frame = widget.scrollbar
			frame:StripTextures()
			A:ReskinScroll(frame)
		elseif TYPE == "InlineGroup" or TYPE == "TreeGroup" or TYPE == "TabGroup" or TYPE == "SimpleGroup" or TYPE == "Frame" or TYPE == "DropdownGroup" then
			local frame = widget.content:GetParent()
			A:CreateBD(frame, .3)
			if TYPE == "Frame" then
				frame:StripTextures()
				for i=1, frame:GetNumChildren() do
					local child = select(i, frame:GetChildren())
					if child:GetObjectType() == "Button" and child:GetText() then
						A:Reskin(child)
					else
						child:StripTextures()
					end
				end
				A:CreateSD(frame)
				A:CreateBD(frame)
			end

			if widget.treeframe then
				A:CreateBD(widget.treeframe, .3)
				frame:SetPoint("TOPLEFT", widget.treeframe, "TOPRIGHT", 1, 0)
			end

			if TYPE == "TabGroup" then
				local oldCreateTab = widget.CreateTab
				widget.CreateTab = function(self, id)
					local tab = oldCreateTab(self, id)
					tab:StripTextures()
					return tab
				end
			end
		end
		return oldRegisterAsContainer(self, widget)
	end
end

A:RegisterSkin("SunUI", SkinAce3)