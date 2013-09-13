local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SkinSkada", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local function StripOptions(options)
	options.baroptions.args.barspacing = nil
	options.titleoptions.args.texture = nil
	options.titleoptions.args.bordertexture = nil
	options.titleoptions.args.thickness = nil
	options.titleoptions.args.margin = nil
	options.titleoptions.args.color = nil
	options.windowoptions = nil
end
 local function SkinBar(self)
	for _,window in ipairs(self:GetWindows()) do
		for i,v in pairs(window.bargroup:GetBars()) do
			if not v.BarStyled then
				if SunUIConfig.db.profile.MiniDB.uistyle ~= "plane" then
					v.texture.SetVertexColor = function(t, r, g, b) 
						S.CreateTop(v.texture, r, g, b)
					end
				end
				v.BarStyled = true
			end
		end
	end
end
function  Module:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not IsAddOnLoaded("Skada") then return end
	local Skada = Skada
	local barSpacing = S.Scale(1)
	local borderWidth = S.Scale(1)
	local barmod = Skada.displays["bar"]

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

	barmod.ApplySettings_ = barmod.ApplySettings
	barmod.ApplySettings = function(self, win)
		barmod.ApplySettings_(self, win)

		local skada = win.bargroup

		if win.db.enabletitle then
			skada.button:SetBackdrop(nil)
		end

		skada:SetTexture(DB.Statusbar)
		skada:SetSpacing(barSpacing)
		--local titlefont = CreateFont("TitleFont"..win.db.name)
		--titlefont:SetFont(DB.Font, select(2, ChatFrame1:GetFont()), "OUTLINE")
		--win.bargroup.button:SetNormalFontObject(titlefont)

		local color = win.db.title.color
		win.bargroup.button:SetBackdropColor(0, 0, 0, 1)

		skada:SetBackdrop(nil)
		if not skada.shadow then
			skada:CreateShadow("Background")
		end
		skada.shadow:ClearAllPoints()
		if win.db.enabletitle then
			skada.shadow:Point('TOPLEFT', win.bargroup.button, 'TOPLEFT', -5, 5)
		else
			skada.shadow:Point('TOPLEFT', win.bargroup, 'TOPLEFT', -5, 5)
		end
		skada.shadow:Point('BOTTOMRIGHT', win.bargroup, 'BOTTOMRIGHT', 5, -5)

		win.bargroup.button:SetFrameStrata("MEDIUM")
		win.bargroup.button:SetFrameLevel(5)
		win.bargroup:SetFrameStrata("MEDIUM")
	end	
	hooksecurefunc(Skada, "UpdateDisplay",SkinBar)
end

function Module:OnEnable()
	Module:RegisterEvent("PLAYER_ENTERING_WORLD")
end