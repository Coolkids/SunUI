﻿local S, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
S.layoutList = {}
for i=1,20 do
	table.insert(S.layoutList, i)
end
S.Options = {
	type = "group",
	name = AddOnName,
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["版本"]..string.format(": |cff7aa6d6%s|r",S.version),
			width = "full",
		},
		general = {
			order = 2,
			type = "group",
			name = L["一般"],
			get = function(info)
				return S.global.general[ info[#info] ]
			end,
			set = function(info, value)
				S.global.general[ info[#info] ] = value
				StaticPopup_Show("CFG_RELOAD")
			end,
			args = {
				uiscale = {
					order = 1,
					name = L["UI缩放"],
					desc = L["UI缩放"],
					type = "range",
					min = 0.64, max = 1.5, step = 0.01,
					isPercent = true,
				},
				theme = {
					order = 2,
					type = "toggle",
					name = L["界面风格"],
					type = "select",
					values = {
						["Shadow"] = L["阴影"],
						["Pixel"] = L["1像素"],
					},
				},
				spacer = {
					order = 3,
					name = " ",
					desc = " ",
					type = "description",
				},
				mainLayout = {
					order = 4,
					type = "toggle",
					name = L["布局管理器"],
					desc = L["布局管理器"],
					type = "select",
					values = S.layoutList,
					get = function(info)
						return S.db.layout.mainLayout
					end,
					set = function(info, value)
						S.db.layout.mainLayout = value
						S:SetMoversPositions()
					end,

				},
				ToggleAnchors = {
					order = 5,
					type = "execute",
					name = L["解锁锚点"],
					desc = L["解锁锚点"],
					func = function()
                        S:ToggleConfigMode()
                        SlashCmdList.TOGGLEGRID()
					end,
				},
			},
		},
		media = {
			order = 3,
			type = "group",
			name = L["字体材质"],
			get = function(info)
				return S.global.media[ info[#info] ]
			end,
			set = function(info, value)
				S.global.media[ info[#info] ] = value
				StaticPopup_Show("CFG_RELOAD")
			end,
			args = {
				fontGroup = {
					order = 1,
					type = "group",
					name = L["字体"],
					guiInline = true,
					args = {
						font = {
							type = "select", dialogControl = "LSM30_Font",
							order = 1,
							name = L["一般字体"],
							values = AceGUIWidgetLSMlists.font,
							set = function(info, value)
								S.global.media[ info[#info] ] = value
								S:UpdateMedia()
								S:UpdateFontTemplates()
							end,
						},
						fontsize = {
							type = "range",
							order = 2,
							name = L["字体大小"],
							type = "range",
							min = 9, max = 14, step = 1,
							set = function(info, value)
								S.global.media[ info[#info] ] = value
								S:UpdateMedia()
								S:UpdateFontTemplates()
							end,
						},
						fontflag = {
							type = "select",
							order = 3,
							name = L["字体描边"],
							values = {["NONE"] = "NONE", ["THINOUTLINE"] = "THINOUTLINE", ["MONOCHROME"] = "MONOCHROME", ["OUTLINE"] = "OUTLINE", ["THICKOUTLINE"] = "THICKOUTLINE" },
							set = function(info, value)
								S.global.media[ info[#info] ] = value
								S:UpdateMedia()
								S:UpdateFontTemplates()
							end,
						},
						dmgfont = {
							type = "select", dialogControl = "LSM30_Font",
							order = 4,
							name = L["伤害字体"],
							values = AceGUIWidgetLSMlists.font,
							set = function(info, value)
								S.global.media[ info[#info] ] = value
								S:UpdateMedia()
								S:UpdateFontTemplates()
							end,
						},
						pxfont = {
							type = "select", dialogControl = "LSM30_Font",
							order = 5,
							name = L["像素字体"],
							values = AceGUIWidgetLSMlists.font,
						},
						cdfont = {
							type = "select", dialogControl = "LSM30_Font",
							order = 6,
							name = L["冷却字体"],
							values = AceGUIWidgetLSMlists.font,
						},
					},
				},
				textureGroup = {
					order = 2,
					type = "group",
					name = L["材质"],
					guiInline = true,
					args = {
						normal = {
							type = "select", dialogControl = "LSM30_Statusbar",
							order = 1,
							name = L["一般材质"],
							values = AceGUIWidgetLSMlists.statusbar,
						},
						blank = {
							type = "select", dialogControl = "LSM30_Statusbar",
							order = 2,
							name = L["空白材质"],
							values = AceGUIWidgetLSMlists.statusbar,
						},
						gloss = {
							type = "select", dialogControl = "LSM30_Statusbar",
							order = 3,
							name = L["玻璃材质"],
							values = AceGUIWidgetLSMlists.statusbar,
						},
						glow = {
							type = "select", dialogControl = "LSM30_Border",
							order = 4,
							name = L["阴影边框"],
							values = AceGUIWidgetLSMlists.border,
						},
					},
				},
				colorGroup = {
					order = 4,
					type = "group",
					name = L["颜色"],
					guiInline = true,
					args = {
						bordercolor = {
							order = 1,
							type = "color",
							hasAlpha = false,
							name = L["边框颜色"],
							get = function(info)
								local t = S.global.media[ info[#info] ]
								return unpack(t)
							end,
							set = function(info, r, g, b)
								S.global.media[ info[#info] ] = {}
								local t = S.global.media[ info[#info] ]
								t[1], t[2], t[3] = r, g, b
                                S:UpdateDemoFrame()
								StaticPopup_Show("CFG_RELOAD")
							end,
						},
						backdropcolor = {
							order = 2,
							type = "color",
							hasAlpha = false,
							name = L["背景颜色"],
							get = function(info)
								local t = S.global.media[ info[#info] ]
								return unpack(t)
							end,
							set = function(info, r, g, b, a)
								S.global.media[ info[#info] ] = {}
								local t = S.global.media[ info[#info] ]
								t[1], t[2], t[3] = r, g, b
                                S:UpdateDemoFrame()
								StaticPopup_Show("CFG_RELOAD")
							end,
						},
						backdropfadecolor = {
							order = 3,
							type = "color",
							hasAlpha = true,
							name = L["透明框架背景颜色"],
							get = function(info)
								local t = S.global.media[ info[#info] ]
								return unpack(t)
							end,
							set = function(info, r, g, b, a)
								S.global.media[ info[#info] ] = {}
								local t = S.global.media[ info[#info] ]
								t[1], t[2], t[3], t[4] = r, g, b, a
                                S:UpdateDemoFrame()
								StaticPopup_Show("CFG_RELOAD")
							end,
						},
                        resetbutton = {
                            type = "execute",
                            order = 5,
                            name = L["恢复颜色"],
                            func = function()
                                S.global.media.backdropcolor = G.media.backdropcolor
                                S.global.media.backdropfadecolor = G.media.backdropfadecolor
                                S.global.media.bordercolor = G.media.bordercolor
                                ReloadUI()
                            end,
                        },
					},
				},
			},
		},
	},
}

StaticPopupDialogs["CFG_RELOAD"] = {
	text = L["改变参数需重载应用设置"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}