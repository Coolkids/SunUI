local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local mod = E:GetModule('DataBars')

local databars = {}

E.Options.args.databars = {
	type = "group",
	name = L["DataBars"],
	childGroups = "tab",
	get = function(info) return E.db.databars[ info[#info] ] end,
	set = function(info, value) E.db.databars[ info[#info] ] = value; end,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L["DATABAR_DESC"],
		},
		spacer = {
			order = 2,
			type = "description",
			name = "",
		},
		experience = {
			order = 5,
			get = function(info) return mod.db.experience[ info[#info] ] end,
			set = function(info, value) mod.db.experience[ info[#info] ] = value; mod:UpdateExperienceDimensions() end,
			type = "group",
			name = XPBAR_LABEL,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value) mod.db.experience[ info[#info] ] = value; mod:EnableDisable_ExperienceBar() end,
				},
				mouseover = {
					order = 1,
					type = "toggle",
					name = L["Mouseover"],
				},
				hideAtMaxLevel = {
					order = 2,
					type = "toggle",
					name = L["Hide At Max Level"],
					set = function(info, value) mod.db.experience[ info[#info] ] = value; mod:UpdateExperience() end,
				},
				hideInVehicle = {
					order = 3,
					type = "toggle",
					name = L["Hide In Vehicle"],
					set = function(info, value) mod.db.experience[ info[#info] ] = value; mod:UpdateExperience() end,
				},
				reverseFill = {
					order = 4,
					type = "toggle",
					name = L["Reverse Fill Direction"],
				},
				orientation = {
					order = 5,
					type = "select",
					name = L["Statusbar Fill Orientation"],
					desc = L["Direction the bar moves on gains/losses"],
					values = {
						['HORIZONTAL'] = L["Horizontal"],
						['VERTICAL'] = L["Vertical"]
					}
				},
				width = {
					order = 6,
					type = "range",
					name = L["Width"],
					min = 5, max = ceil(GetScreenWidth() or 800), step = 1,
				},
				height = {
					order = 7,
					type = "range",
					name = L["Height"],
					min = 5, max = ceil(GetScreenHeight() or 800), step = 1,
				},
				textSize = {
					order = 8,
					name = L["Font Size"],
					type = "range",
					min = 6, max = 22, step = 1,
				},
				textFormat = {
					order = 9,
					type = 'select',
					name = L["Text Format"],
					values = {
						NONE = NONE,
						PERCENT = L["Percent"],
						CURMAX = L["Current - Max"],
						CURPERC = L["Current - Percent"],
					},
					set = function(info, value) mod.db.experience[ info[#info] ] = value; mod:UpdateExperience() end,
				},
			},
		},
		reputation = {
			order = 6,
			get = function(info) return mod.db.reputation[ info[#info] ] end,
			set = function(info, value) mod.db.reputation[ info[#info] ] = value; mod:UpdateReputationDimensions() end,
			type = "group",
			name = REPUTATION,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value) mod.db.reputation[ info[#info] ] = value; mod:EnableDisable_ReputationBar() end,
				},
				mouseover = {
					order = 1,
					type = "toggle",
					name = L["Mouseover"],
				},
				hideInVehicle = {
					order = 2,
					type = "toggle",
					name = L["Hide In Vehicle"],
					set = function(info, value) mod.db.reputation[ info[#info] ] = value; mod:UpdateReputation() end,
				},
				reverseFill = {
					order = 3,
					type = "toggle",
					name = L["Reverse Fill Direction"],
				},
				orientation = {
					order = 4,
					type = "select",
					name = L["Statusbar Fill Orientation"],
					desc = L["Direction the bar moves on gains/losses"],
					values = {
						['HORIZONTAL'] = L["Horizontal"],
						['VERTICAL'] = L["Vertical"]
					}
				},
				textFormat = {
					order = 5,
					type = 'select',
					name = L["Text Format"],
					values = {
						NONE = NONE,
						PERCENT = L["Percent"],
						CURMAX = L["Current - Max"],
						CURPERC = L["Current - Percent"],
					},
					set = function(info, value) mod.db.reputation[ info[#info] ] = value; mod:UpdateReputation() end,
				},
				width = {
					order = 6,
					type = "range",
					name = L["Width"],
					min = 5, max = ceil(GetScreenWidth() or 800), step = 1,
				},
				height = {
					order = 7,
					type = "range",
					name = L["Height"],
					min = 5, max = ceil(GetScreenHeight() or 800), step = 1,
				},
				textSize = {
					order = 8,
					name = L["Font Size"],
					type = "range",
					min = 6, max = 22, step = 1,
				},
			},
		},
		artifact = {
			order = 6,
			get = function(info) return mod.db.artifact[ info[#info] ] end,
			set = function(info, value) mod.db.artifact[ info[#info] ] = value; mod:UpdateArtifactDimensions() end,
			type = "group",
			name = L["Artifact Bar"],
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value) mod.db.artifact[ info[#info] ] = value; mod:EnableDisable_ArtifactBar() end,
				},
				mouseover = {
					order = 1,
					type = "toggle",
					name = L["Mouseover"],
				},
				hideInVehicle = {
					order = 3,
					type = "toggle",
					name = L["Hide In Vehicle"],
					set = function(info, value) mod.db.artifact[ info[#info] ] = value; mod:UpdateArtifact() end,
				},
				reverseFill = {
					order = 4,
					type = "toggle",
					name = L["Reverse Fill Direction"],
				},
				orientation = {
					order = 5,
					type = "select",
					name = L["Statusbar Fill Orientation"],
					desc = L["Direction the bar moves on gains/losses"],
					values = {
						['HORIZONTAL'] = L["Horizontal"],
						['VERTICAL'] = L["Vertical"]
					}
				},
				width = {
					order = 6,
					type = "range",
					name = L["Width"],
					min = 5, max = ceil(GetScreenWidth() or 800), step = 1,
				},
				height = {
					order = 7,
					type = "range",
					name = L["Height"],
					min = 5, max = ceil(GetScreenHeight() or 800), step = 1,
				},
				textSize = {
					order = 8,
					name = L["Font Size"],
					type = "range",
					min = 6, max = 22, step = 1,
				},
				textFormat = {
					order = 9,
					type = 'select',
					name = L["Text Format"],
					values = {
						NONE = NONE,
						PERCENT = L["Percent"],
						CURMAX = L["Current - Max"],
						CURPERC = L["Current - Percent"],
					},
					set = function(info, value) mod.db.artifact[ info[#info] ] = value; mod:UpdateArtifact() end,
				},
			},
		},
		honor = {
			order = 7,
			get = function(info) return mod.db.honor[ info[#info] ] end,
			set = function(info, value) mod.db.honor[ info[#info] ] = value; mod:UpdateHonorDimensions() end,
			type = "group",
			name = HONOR,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value) mod.db.honor[ info[#info] ] = value; mod:EnableDisable_HonorBar() end,
				},
				mouseover = {
					order = 1,
					type = "toggle",
					name = L["Mouseover"],
				},
				hideInVehicle = {
					order = 3,
					type = "toggle",
					name = L["Hide In Vehicle"],
					set = function(info, value) mod.db.honor[ info[#info] ] = value; mod:UpdateHonor() end,
				},
				reverseFill = {
					order = 4,
					type = "toggle",
					name = L["Reverse Fill Direction"],
				},
				orientation = {
					order = 5,
					type = "select",
					name = L["Statusbar Fill Orientation"],
					desc = L["Direction the bar moves on gains/losses"],
					values = {
						['HORIZONTAL'] = L["Horizontal"],
						['VERTICAL'] = L["Vertical"]
					}
				},
				width = {
					order = 6,
					type = "range",
					name = L["Width"],
					min = 5, max = ceil(GetScreenWidth() or 800), step = 1,
				},
				height = {
					order = 7,
					type = "range",
					name = L["Height"],
					min = 5, max = ceil(GetScreenHeight() or 800), step = 1,
				},
				textSize = {
					order = 8,
					name = L["Font Size"],
					type = "range",
					min = 6, max = 22, step = 1,
				},
				textFormat = {
					order = 9,
					type = 'select',
					name = L["Text Format"],
					values = {
						NONE = NONE,
						PERCENT = L["Percent"],
						CURMAX = L["Current - Max"],
						CURPERC = L["Current - Percent"],
					},
					set = function(info, value) mod.db.honor[ info[#info] ] = value; mod:UpdateHonor() end,
				},
			},
		},	
	},
}