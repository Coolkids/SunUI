--[[
	Kui Nameplates
	Kesava-Auchindoun EU
]]
local addon, ns = ...
local kui = LibStub('Kui-1.0')
local LSM = LibStub('LibSharedMedia-3.0')

LibStub('AceAddon-3.0'):NewAddon(ns, 'KuiNameplates')

-- add yanone kaffesatz and accidental presidency to LSM (only supports latin)
LSM:Register(LSM.MediaType.FONT, 'Yanone Kaffesatz', kui.m.f.yanone)
LSM:Register(LSM.MediaType.FONT, 'Accidental Presidency', kui.m.f.accid)
-- TODO should probably move LSM stuff into Kui, and replace the table there

local locale = GetLocale()
local latin  = (locale ~= 'zhCN' and locale ~= 'zhTW' and locale ~= 'koKR' and locale ~= 'ruRU')

-------------------------------------------------------------- Default config --
local defaults = {
	profile = {
		general = {
			combat      = false, -- automatically show hostile plates upon entering combat
			highlight   = true, -- highlight plates on mouse-over
			combopoints = true, -- display combo points
			fixaa       = true, -- attempt to make plates appear sharper (with some drawbacks)
			font        = (latin and 'Yanone Kaffesatz' or LSM:GetDefault(LSM.MediaType.FONT)), -- the font used for all text
			fontscale   = 1.0, -- the scale of all displayed font sizes
		},
		fade = {
			smooth      = true, -- smoothy fade plates (fading is instant if disabled)
			fadespeed   = .5, -- fade animation speed modifier
			fademouse   = false, -- fade in plates on mouse-over
			fadeall     = false, -- fade all plates by default
			fadedalpha  = .3, -- the alpha value to fade plates out to
		},
		tank = {
			enabled    = false, -- recolour a plate's bar and glow colour when you have threat
			barcolour  = { .2, .9, .1, 1 }, -- the bar colour to use when you have threat
			glowcolour = { 1, 0, 0, 1, 1 } -- the glow colour to use when you have threat
		},
		text = {
			level        = true, -- display levels
			friendlyname = { 1, 1, 1 }, -- friendly name text colour
			enemyname    = { 1, 1, 1 }  -- enemy name text colour
		},
		hp = {
			friendly  = '=:m;<:d;', -- health display pattern for friendly units
			hostile   = '<:p;', -- health display pattern for hostile/neutral units
			showalt   = false, -- show alternate (contextual) health values as well as main values
			mouseover = false, -- hide health values until you mouse over or target the plate
			tapped    = true, -- use grey health bar colour for tapped units
			smooth    = true -- smoothly animate health bar changes
		},
		castbar = {
			enabled   = true, -- show a castbar (at all)
			casttime  = true, -- display cast time and time remaining
			spellname = true, -- display spell name
			spellicon = true, -- display spell icon
			barcolour = { .43, .47, .55, 1 }, -- the colour of the spell bar (interruptible casts)
			warnings  = false, -- display spell cast warnings on any plates
			usenames  = false -- use unit names to display cast warnings on their correct frames: may increase memory usage and may cause warnings to be displayed on incorrect frames when there are many units with the same name. Reccommended on for PvP, off for PvE.
		},
	}
}

------------------------------------------------------------------------ init --
function ns:OnInitialize()
	self.db = LibStub('AceDB-3.0'):New('KuiNameplatesGDB', defaults)

	LibStub('AceConfig-3.0'):RegisterOptionsTable('kuinameplates-profiles', LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db))
	LibStub('AceConfigDialog-3.0'):AddToBlizOptions('kuinameplates-profiles', 'Profiles', 'Kui Nameplates')
	
	self.db.RegisterCallback(self, 'OnProfileChanged', 'ProfileChanged')
end