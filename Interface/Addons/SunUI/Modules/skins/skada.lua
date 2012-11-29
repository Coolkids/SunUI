local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SkinSkada", "AceEvent-3.0")
local function StripOptions(options)
	options.baroptions.args.barspacing = nil
	options.titleoptions.args.texture = nil
	options.titleoptions.args.bordertexture = nil
	options.titleoptions.args.thickness = nil
	options.titleoptions.args.margin = nil
	options.titleoptions.args.color = nil
	options.windowoptions = nil
end

local function LoadSkin()
	local Skada = Skada
	local barSpacing = 1
	local borderWidth = 1
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
		--skada:SetFrameLevel(5)
		--local titlefont = CreateFont("TitleFont"..win.db.name)
		--win.bargroup.button:SetNormalFontObject(titlefont)

		skada:SetBackdrop(nil)
		local h = CreateFrame("Frame", nil, skada)
		h:SetAllPoints()
		h:SetFrameLevel(skada:GetFrameLevel()-1)
		if not h.shadow then
			h:CreateShadow("Background")
		end
		h:ClearAllPoints()
		if win.db.enabletitle then
			h:Point('TOPLEFT', win.bargroup.button, 'TOPLEFT')
		else
			h:Point('TOPLEFT', win.bargroup, 'TOPLEFT')
		end
		h:Point('BOTTOMRIGHT', win.bargroup, 'BOTTOMRIGHT')
	end	
end
local Skada_Skin = CreateFrame("Frame")
Skada_Skin:RegisterEvent("PLAYER_ENTERING_WORLD")
Skada_Skin:SetScript("OnEvent", function(self)
	self:UnregisterAllEvents()
	self = nil
	if not IsAddOnLoaded("Skada") then return end
	LoadSkin()
end)