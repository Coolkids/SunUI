local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")
----------------------------------------------------------------------------------------
--	Skada skin
----------------------------------------------------------------------------------------
local function OnLoad()
	local barmod = Skada.displays["bar"]

	-- Used to strip unecessary options from the in-game config
	local function StripOptions(options)
		options.baroptions.args.barspacing = nil
		options.titleoptions.args.texture = nil
		options.titleoptions.args.bordertexture = nil
		options.titleoptions.args.thickness = nil
		options.titleoptions.args.margin = nil
		options.titleoptions.args.color = nil
		options.windowoptions = nil
		options.baroptions.args.barfont = nil
		options.baroptions.args.reversegrowth = nil
		options.titleoptions.args.font = nil
	end

	barmod.AddDisplayOptions_ = barmod.AddDisplayOptions
	barmod.AddDisplayOptions = function(self, win, options)
		self:AddDisplayOptions_(win, options)
		StripOptions(options)
	end

	for k, options in pairs(Skada.options.args.windows.args) do
		if options.type == "group" then
			StripOptions(options.args)
		end
	end

	-- Override settings from in-game GUI
	barmod.ApplySettings_ = barmod.ApplySettings
	barmod.ApplySettings = function(self, win)
		barmod.ApplySettings_(self, win)

		local skada = win.bargroup

		local titlefont = CreateFont("TitleFont"..win.db.name)
		titlefont:SetFont(S["media"].font, S["media"].fontsize, S["media"].fontflag)
		titlefont:SetShadowColor(0, 0, 0)

		if win.db.enabletitle then
			skada.button:SetNormalFontObject(titlefont)
			skada.button:SetBackdrop(nil)
			skada.button:GetFontString():SetPoint("TOPLEFT", skada.button, "TOPLEFT", 2, -2)
			skada.button:SetHeight(19)

			skada.button.bg = skada.button:CreateTexture(nil, "BACKGROUND")
			skada.button.bg:SetTexture(S["media"].normal)
			skada.button.bg:SetVertexColor(unpack(S["media"].bordercolor))
			skada.button.bg:SetPoint("TOPLEFT", win.bargroup.button, "TOPLEFT", 0, 0)
			skada.button.bg:SetPoint("BOTTOMRIGHT", win.bargroup.button, "BOTTOMRIGHT", 0, 7)
		end

		skada:SetTexture(S["media"].normal)
		skada:SetSpacing(4)
		skada:SetBackdrop(nil)
		A:SetBD(skada, -5, 23, 3, -5)
	end

	hooksecurefunc(Skada, "UpdateDisplay", function(self)
		for _, win in ipairs(self:GetWindows()) do
			for i, v in pairs(win.bargroup:GetBars()) do
				if not v.BarStyled then
					if not v.shadow then
						v:CreateShadow()
					end

					v:SetHeight(12)

					v.label:ClearAllPoints()
					v.label.ClearAllPoints = S.dummy
					v.label:SetPoint("LEFT", v, "LEFT", 2, 0)
					v.label.SetPoint = S.dummy

					v.label:SetFont(S["media"].font, S["media"].fontsize, S["media"].fontflag)
					v.label.SetFont = S.dummy
					v.label:SetShadowOffset(0, 0)
					v.label.SetShadowOffset = S.dummy

					v.timerLabel:ClearAllPoints()
					v.timerLabel.ClearAllPoints = S.dummy
					v.timerLabel:SetPoint("RIGHT", v, "RIGHT", 0, 0)
					v.timerLabel.SetPoint = S.dummy

					v.timerLabel:SetFont(S["media"].font, S["media"].fontsize, S["media"].fontflag)
					v.timerLabel.SetFont = S.dummy
					v.timerLabel:SetShadowOffset(0, 0)
					v.timerLabel.SetShadowOffset = S.dummy

					v.BarStyled = true
				end
				if v.icon and v.icon:IsShown() then
					v.border:SetPoint("TOPLEFT", -16, 0)
					v.border:SetPoint("BOTTOMRIGHT", 1, -1)
				else
					v.border:SetPoint("TOPLEFT", -1, 1)
					v.border:SetPoint("BOTTOMRIGHT", 1, -1)
				end
			end
		end
	end)

	hooksecurefunc(Skada, "OpenReportWindow", function(self)
		if not self.ReportWindow.frame.reskinned then
			self.ReportWindow.frame:StripTextures()
			--self.ReportWindow.frame:SetTemplate("Transparent")
			--A:ReskinClose(self.ReportWindow.frame:GetChildren())
			self.ReportWindow.frame.reskinned = true
		end
	end)

	-- Update pre-existing displays
	for _, window in ipairs(Skada:GetWindows()) do
		window:UpdateDisplay()
	end
end

A:RegisterSkin("Skada", OnLoad)

