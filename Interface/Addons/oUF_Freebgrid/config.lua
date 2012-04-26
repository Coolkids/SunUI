local ADDON_NAME, ns = "oUF_Freebgrid", Freebgrid_NS

local L = ns.Locale

local outline = {
    ["NONE"] = L.none,
    ["OUTLINE"] = "OUTLINE",
    ["THINOUTLINE"] = "THINOUTLINE",
    ["MONOCHROME"] = "MONOCHROME",
    ["OUTLINEMONO"] = "OUTLINEMONOCHROME",
}

local orientation = {
    ["VERTICAL"] = L.outlinevertical,
    ["HORIZONTAL"] = L.outlinehorizontal,
}

local hptext = {
	["DEFICIT"] 	= L.hptextdeficit,
	["PERC"]		= L.hptextperc,
	["ACTUAL"]		= L.hptextactual,
}

local dispeltext = {
	["ICON"] 		= L.dispeltexticon,
	["BORDER"]		= L.dispeltextborder,
}

local indicator = ns.media.indicator
local symbols = ns.media.symbols

local SM = LibStub("LibSharedMedia-3.0", true)
local fonts = SM:List("font")
local statusbars = SM:List("statusbar")

local function updateFonts(object)
    object.Name:SetFont(ns.db.fontPath, ns.db.fontsize, ns.db.outline)
    object.Name:SetWidth(ns.db.width)
    object.AFKtext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
    object.AFKtext:SetWidth(ns.db.width)
    object.AuraStatusCen:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline) 
    object.AuraStatusCen:SetWidth(ns.db.width)
    object.Healtext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline) 
    object.Healtext:SetWidth(ns.db.width)
end

local function updateIndicators(object)
    object.AuraStatusTL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
    object.AuraStatusTR:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
    object.AuraStatusBL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
	object.AuraStatusRC:SetFont(symbols, ns.db.symbolsize-2, "THINOUTLINE")
    object.AuraStatusBR:SetFont(symbols, ns.db.symbolsize, "THINOUTLINE")

end

local function updateIcons(object)
    object.Leader:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.Assistant:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.MasterLooter:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.RaidIcon:SetSize(ns.db.leadersize+2, ns.db.leadersize+2)
    object.ReadyCheck:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.freebAuras.button:SetSize(ns.db.aurasize, ns.db.aurasize)
    object.freebAuras.size = ns.db.aurasize
	object.freebSecAuras.button:SetSize(ns.db.secaurasize, ns.db.secaurasize)
    object.freebSecAuras.size = ns.db.secaurasize
end

local function updateHealbar(object)
    object.myHealPredictionBar:ClearAllPoints()
    object.otherHealPredictionBar:ClearAllPoints()

    if ns.db.orientation == "VERTICAL" then
        object.myHealPredictionBar:SetPoint("BOTTOMLEFT", object.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
        object.myHealPredictionBar:SetPoint("BOTTOMRIGHT", object.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
        object.myHealPredictionBar:SetSize(0, ns.db.height)
        object.myHealPredictionBar:SetOrientation"VERTICAL"

        object.otherHealPredictionBar:SetPoint("BOTTOMLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
        object.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
        object.otherHealPredictionBar:SetSize(0, ns.db.height)
        object.otherHealPredictionBar:SetOrientation"VERTICAL"
    else
        object.myHealPredictionBar:SetPoint("TOPLEFT", object.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
        object.myHealPredictionBar:SetPoint("BOTTOMLEFT", object.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
        object.myHealPredictionBar:SetSize(ns.db.width, 0)
        object.myHealPredictionBar:SetOrientation"HORIZONTAL"

        object.otherHealPredictionBar:SetPoint("TOPLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
        object.otherHealPredictionBar:SetPoint("BOTTOMLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
        object.otherHealPredictionBar:SetSize(ns.db.width, 0)
        object.otherHealPredictionBar:SetOrientation"HORIZONTAL"
    end

    object.myHealPredictionBar:GetStatusBarTexture():SetTexture(ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b, ns.db.myhealcolor.a)
    object.otherHealPredictionBar:GetStatusBarTexture():SetTexture(ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b, ns.db.otherhealcolor.a)
end

function ns:updateObjects()
	if ns:CheckCombat(ns.updateObjects) then return end
	
    for _, object in next, ns._Objects do
        object:SetSize(ns.db.width, ns.db.height)
        object:SetScale(ns.db.scale)

        ns:UpdateHealth(object.Health)
        ns:UpdatePower(object.Power)
        if UnitExists(object.unit) then
            object.Health:ForceUpdate()
            object.Power:ForceUpdate()
        end
        updateFonts(object)
        updateIndicators(object)
        updateIcons(object)
        updateHealbar(object)
        ns:UpdateName(object.Name, object.unit)

        if ns.db.smooth then
            object:EnableElement('freebSmooth')
        else
            object:DisableElement('freebSmooth')
        end
    end

    _G["oUF_FreebgridRaidFrame"]:SetSize(ns.db.width, ns.db.height)
    _G["oUF_FreebgridPetFrame"]:SetSize(ns.db.width, ns.db.height)
    _G["oUF_FreebgridMTFrame"]:SetSize(ns.db.width, ns.db.height)
	
	collectgarbage("collect")
end


if type(ns.options) ~= "table" then
	ns.options = {
		type = "group", name = ADDON_NAME,
		get = function(info) return ns.db[ info[#info] ] end,
		set = function(info, value) ns.db[ info[#info] ] = value end,
		args={}
	}
end
ns.options.args.unlock = {
	name = L.optionsunlock,
	type = "execute",
	func = function() ns:Movable(); end,
	order = 1,
}
ns.options.args.reload = {
	name = L.optionsreload,
	type = "execute",
	desc = L.optionsreloaddesc,
	func = function() ReloadUI(); end,
	order = 2,
}

ns.options.args.general = {
    type = "group", name = L.generalname, order = 1,
    args = {
        scale = {
            name = L.generalscale,
            type = "range",
            order = 1,
            min = 0.5,
            max = 2.0,
            step = .1,
            set = function(info,val) ns.db.scale = val; ns.updateObjects() end,
        },
        width = {
            name = L.generalwidth,
            type = "range",
            order = 2,
            min = 20,
            max = 150,
            step = 1,
            set = function(info,val) ns.db.width = val; wipe(ns.nameCache); ns:UpdateAttribute(); ns.updateObjects() end,
        },
        height = {
            name = L.generalheight,
            type = "range",
            order = 3,
            min = 20,
            max = 150,
            step = 1,
            set = function(info,val) ns.db.height = val;ns:UpdateAttribute();ns.updateObjects() end,
        },
        spacing = {
            name = L.generalspacing,
            type = "range",
            order = 4,
            min = 0,
            max = 30,
            step = 1,
            set = function(info,val) ns.db.spacing = val; ns:UpdateAttribute();end,
        }, 
        raid = {
            name = L.generalraid,
            type = "group",
            order = 5,
            inline = true,
            args = {
                horizontal = {
                    name = L.generalraidhorizontalname,
                    type = "toggle",
                    order = 1,
					desc = L.generalraidhorizontaldesc,
                    set = function(info,val)
                        if(val == true and (ns.db.growth ~= "UP" or ns.db.growth ~= "DOWN")) then
                            ns.db.growth = "UP"
                        elseif(val == false and (ns.db.growth ~= "RIGHT" or ns.db.growth ~= "LEFT")) then
                            ns.db.growth = "RIGHT"
                        end
                        ns.db.horizontal = val; 
						 ns:UpdateAttribute();
                    end,
                },
                growth = {
                    name = L.generalraidgrowthname,
                    type = "select",
                    order = 2,
					desc = L.generalraidgrowthdesc,
                    values = function(info,val) 
                        info = ns.db.growth
                        if not ns.db.horizontal then
                            return { ["LEFT"] = L.left, ["RIGHT"] = L.right}
                       else
                            return {  ["UP"] = L.up, ["DOWN"] = L.down}
                        end
                    end,
                    set = function(info,val) ns.db.growth = val; ns:UpdateAttribute(); end,
                },
                numCol = {
                    name = L.generalraidgroupname,
                    type = "range",
                    order = 3,
                    min = 1,
                    max = 8,
                    step = 1,
					desc = L.generalraidgroupdesc,
                    set = function(info,val) ns.db.numCol = val;  ns.UpdateAttribute();end,
                },
              
          

            },
        },
        pets = {
            name = L.generalpetsname,
            type = "group",
            order = 11,
			disabled = true,
            inline = true,
            args = {
                pethorizontal = {
                    name = L.generalpethorizontal,
                    type = "toggle",
                    order = 1,
                    set = function(info,val)
                        if(val == true and (ns.db.petgrowth ~= "UP" or ns.db.petgrowth ~= "DOWN")) then
                            ns.db.petgrowth = "UP"
                        elseif(val == false and (ns.db.petgrowth ~= "RIGHT" or ns.db.petgrowth ~= "LEFT")) then
                            ns.db.petgrowth = "RIGHT"
                        end
                        ns.db.pethorizontal = val; 
                    end,
                },
                petgrowth = {
                    name = L.generalpetgrowth,
                    type = "select",
                    order = 2,
                    values = function(info,val) 
                        info = ns.db.petgrowth
                        if not ns.db.pethorizontal then
                            return { ["LEFT"] = L.left, ["RIGHT"] = L.right }
                        else
                            return { ["UP"] = L.up, ["DOWN"] = L.down}
                        end
                    end,
                },
            },
        },
        MT = {
            name = L.miscoptsMT,
            type = "group",
			disabled = true,
            inline = true,
            order = 16,
            args= {
                MThorizontal = {
                    name = L.generalpethorizontal,
                    type = "toggle",
                    order = 1,
                    set = function(info,val)
                        if(val == true and (ns.db.MTgrowth ~= "UP" or ns.db.MTgrowth ~= "DOWN")) then
                            ns.db.MTgrowth = "UP"
                        elseif(val == false and (ns.db.MTgrowth ~= "RIGHT" or ns.db.MTgrowth ~= "LEFT")) then
                            ns.db.MTgrowth = "RIGHT"
                        end
                        ns.db.MThorizontal = val; 
                    end,
                },
                MTgrowth = {
                    name = L.generalpetgrowth,
                    type = "select",
                    order = 2,
                    values = function(info,val) 
                        info = ns.db.MTgrowth
                        if not ns.db.MThorizontal then
                            return { ["LEFT"] = L.left, ["RIGHT"] = L.right }
                        else
                            return { ["UP"] = L.up, ["DOWN"] = L.down}
                        end
                    end,
                },
            },
        },
    },
}

ns.options.args.statusbar = {
    type = "group", name = L.statusbarname, order = 2,
    args = {
        statusbar = {
            name = L.statusbarname,
            type = "select",
            order = 1,
            itemControl = "DDI-Statusbar",
            values = statusbars,
            get = function(info) 
                for i, v in next, statusbars do
                    if v == ns.db.texture then return i end
                end
            end,
            set = function(info, val) ns.db.texture = statusbars[val]; 
                ns.db.texturePath = SM:Fetch("statusbar",statusbars[val]); 
                ns.updateObjects() 
            end,
        },
        orientation = {
            name = L.statusbarorientation,
            type = "select",
            order = 2,
            values = orientation,
            set = function(info,val) ns.db.orientation = val; ns.updateObjects() end,
        },
        power = {
            name = L.statusbarpowerbar,
            type = "group",
            order = 2,
            inline = true,
            args = {
				powerbar = {
							name = L.statusbarpowerbarname,
							type = "toggle",
							order = 1,
							set = function(info,val) ns.db.powerbar = val; ns.updateObjects() end,
						},
				onlymana = {
							name = L.statusbaronlymana,
							type = "toggle",
							order = 2,
							disabled = function(info) return not ns.db.powerbar end,
							set = function(info,val) ns.db.onlymana = val; ns.updateObjects() end,
						},
				lowmana = {
							name = L.statusbarlowmana,
							type = "toggle",
							order = 3,
							disabled = function(info) return not ns.db.powerbar end,
						},
				manapercent = {
							name = L.statusbarpercent,
							type = "range",
							order = 4,
							min = 10,
							max = 100,
							step = 1,
							desc = L.statusbarpercentdesc,
							disabled = function(info) return not ns.db.powerbar end,
					
						},
				porientation = {
							name = L.statusbarporientation,
							type = "select",
							order = 5,
							disabled = function(info) return not ns.db.powerbar end,
							values = orientation,
							set = function(info,val) ns.db.porientation = val; ns.updateObjects() end,
						},
				powerbarsize = {
							name = L.statusbarpsize,
							type = "range",
							order = 6,
							min = .02,
							max = .30,
							step = .02,
							disabled = function(info) return not ns.db.powerbar end,
							set = function(info,val) ns.db.powerbarsize = val; ns.updateObjects() end,
						},
					},
				},
		altpowertext = {
			name = L.statusbaraltpower,
			type = "group",
			order = 3,
			inline = true,
			args = {
				altpower = {
					name = L.statusbaraltpowertext,
					type = "toggle",
					order = 1,
					desc = L.statusbaraltpowerdesc,
				},
			},
		},
    },
}

ns.options.args.font = {
    type = "group", name = L.fontoptsname, order = 3,
    args = {
        font = {
            name = L.fontoptsname,
            type = "select",
            order = 1,
            itemControl = "DDI-Font",
            values = fonts,
            get = function(info)
                for i, v in next, fonts do
                    if v == ns.db.font then return i end		    
                end
            end,
            set = function(info, val) ns.db.font = fonts[val];
                ns.db.fontPath = SM:Fetch("font",fonts[val]);
                wipe(ns.nameCache); ns.updateObjects() 
            end,
        },
        outline = {
            name = L.fontoptsoutline,
            type = "select",
            order = 2,
            values = outline,
            get = function(info) 
                if not ns.db.outline then
                    return "NONE"
                else
                    return ns.db.outline
                end
            end,
            set = function(info,val) 
                if val == "NONE" then
                    ns.db.outline = "NONE"
                else
                    ns.db.outline = val					
                end
                ns.updateObjects()
            end,
        },
        fontsize = {
            name = L.fontoptsfontsize,
            type = "range",
            order = 3,
			desc = L.fontoptsfontsizedesc,
            min = 8,
            max = 32,
            step = 1,
            set = function(info,val) ns.db.fontsize = val; wipe(ns.nameCache);  ns.updateObjects() end,
        },
        fontsizeEdge = {
            name = L.fontoptsfontsizeEdge,
            type = "range",
            order = 4,
            desc = L.fontoptsfontsizeEdgedesc,
            min = 8,
            max = 32,
            step = 1,
            set = function(info,val) ns.db.fontsizeEdge = val; wipe(ns.nameCache);  ns.updateObjects() end,
        },
    },
}

ns.options.args.range = {
    type = "group", name = L.rangeoptsname, order = 4,
    args = {
        outsideRange = {
            name = L.fontoptsoor,
            type = "range",
            order = 1,
            min = 0,
            max = 1,
            step = .1,
        },
        arrow = {
            name = L.fontoptsarrow,
            type = "toggle",
            order = 2,
			desc = L.fontoptsarrowdesc,
            set = function(info,val) ns.db.arrow = val;
			if val == false then
				ns.db.arrowmouseover = false
			end	    
	    end,
        },
	arrowscale = {
            name = L.generalscale,
            type = "range",
            order = 3,
            min = 0.5,
            max = 2.0,
            step = 0.5,
			desc = L.fontoptsscaledesc,
            set = function(info,val) ns.db.arrowscale = val; ns.updateObjects() end,
        },
    arrowmouseover = {
            name = L.fontoptsmouseover,
            type = "toggle",
            order = 4,
            disabled = function(info) return not ns.db.arrow end,
	},
	rangeIsNotConnected = {
            name = L.fontoptsIsNotConnected,
            type = "toggle",
            order = 5,
        },
    },
}

ns.options.args.heal = {
    type = "group", name = L.healoptsname, order = 5,
    args = {
        text = {
            type = "group",
            name = L.healopthealtext,
            order = 1,
            inline = true,
            args = {
                healtext = {
                    name = L.healopthealtextname,
                    type = "toggle",
                    order = 1,
                },
            },
        },
        bar = {
            type = "group",
            name = L.healopthealbar,
            order = 2,
            inline = true,
            args = {
                healbar = {
                    name = L.healopthealbarname,
                    type = "toggle",
                    order = 2,
                },
                myheal = {
                    name = L.healopthealbarmyheal,
                    type = "color",
                    order = 3,
                    hasAlpha = true,
                    get = function(info) return ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b, ns.db.myhealcolor.a  end,
                    set = function(info,r,g,b,a) ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b, ns.db.myhealcolor.a = r,g,b,a;
                        ns.updateObjects(); 
                    end,
                },
                otherheal = {
                    name = L.healopthealbarotherheal,
                    type = "color",
                    order = 4,
                    hasAlpha = true,
                    get = function(info) return ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b, ns.db.otherhealcolor.a  end,
                    set = function(info,r,g,b,a) ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b, ns.db.otherhealcolor.a = r,g,b,a;
                        ns.updateObjects(); 
                    end,
                },
                healoverflow = {
                    name = L.healopthealbaroverflow,
                    type = "toggle",
                    order = 6,
                },
                healothersonly = {
                    name = L.healopthealbarothers,
                    type = "toggle",
                    order = 7,
                }, 
            },
        },

		text = {
			type = "group",
			name = L.healoptshptext,
			order = 8,
			inline = true,
			args = {
				hptext = {
					name = L.healoptshptextname,
					type = "select",
					order = 1,
					values =  hptext,
				},
				hppercent = {
					name = L.healoptspercent,
					type = "range",
					order = 4,
					min = 10,
					max = 100,
					step = 1,
					desc = L.healoptspercentdesc,
					set = function(info,val) ns.db.hppercent = val; ns.updateObjects() end,		
				},
			},
		},
    },
}

ns.options.args.misc = {
    type = "group", name = L.miscoptsname, order = 6,
    args = {
		hideblzraid = {
            name = L.miscoptshideraid,
            type = "toggle",
            order = 1,
			desc = L.miscoptshideraiddesc,
			set = function(info,val) ns.db.hideblzraid = val; ns:UpdateBlizzardRaidFrame() end,
        },
        party = {
            name = L.miscoptsparty,
            type = "toggle",
            order = 2,
            set = function(info,val) ns.db.party = val;  ns.UpdateAttribute();end,
        },
        solo = {
            name = L.miscoptssolo,
            type = "toggle",
            order = 3,
            set = function(info,val) ns.db.solo = val;  ns.UpdateAttribute();end,
        },
        player = {
            name = L.miscoptsplayer,
            type = "toggle",
            order = 4,
            set = function(info,val) ns.db.player = val;  ns.UpdateAttribute();end,
        },
        pets = {
            name = L.miscoptspets,
            type = "toggle",
            order = 5,
			set = function(info,val) ns.db.pets = val; ns:UpdateAttribute(); end,
        },
        MT = {
            name = L.miscoptsMT,
            type = "toggle",
            order = 6,
			set = function(info,val) ns.db.MT = val; ns:UpdateAttribute(); end,
        },
        GCD = {
            name = L.miscoptsGCD,
            type = "toggle",
            order = 7,    
			desc = L.miscoptsGCDdesc,
        },
        roleicon = {
            name = L.miscoptsrole,
            type = "toggle",
            order = 9,
        },
        fborder = {
            name = L.miscoptsfborder,
            type = "toggle",
            order = 10,
        },
        afk = {
            name = L.miscoptsAFK,
            type = "toggle",
            order = 11,
        },
        highlight = {
            name = L.miscoptshighlight,
            type = "toggle",
            order = 12,
        },
       
        tooltip = {
            name = L.miscoptstooltip,
            type = "toggle",
            order = 13,
			desc = L.miscoptstooltipdesc,
        },
        smooth = {
            name = L.miscoptssmooth,
            type = "toggle",
            order = 14,
            set = function(info,val) ns.db.smooth = val; ns.updateObjects() end,
        },
        hidemenu = {
            name = L.miscoptshidemenu,
            type = "toggle",
            order = 15,
            desc = L.miscoptshidemenudesc,
        },
		Resurrection = {
            name = L.miscoptsres,
            type = "toggle",
            order = 16,
            desc = L.miscoptsresdesc,
        },

		dispel = {
            name = L.miscoptsdispel,
            type = "select",
            order = 19,
            values = dispeltext,
        },
        indicatorsize = {
            name = L.miscoptsindicator,
            type = "range",
            order = 20,
            min = 4,
            max = 20,
            step = 1,
            set = function(info,val) ns.db.indicatorsize = val; ns.updateObjects() end,
        },
        symbolsize = {
            name = L.miscoptssymbol,
            type = "range",
            order = 21,
            min = 8,
            max = 20,
            step = 1,
            set = function(info,val) ns.db.symbolsize = val; ns.updateObjects() end,
        },
        leadersize = {
            name = L.miscoptsicon,
            type = "range",
            order = 22,
            min = 0,
            max = 20,
            step = 1,
            set = function(info,val) ns.db.leadersize = val; ns.updateObjects() end,
        },
        aurasize = {
            name = L.miscoptsaura,
            type = "range",
            order = 23,
            min = 8,
            max = 30,
            step = 1,
            set = function(info,val) ns.db.aurasize = val; ns.updateObjects() end,
        },
		secaurasize = {
            name = L.miscoptssecaura,
            type = "range",
            order = 24,
            min = 8,
            max = 30,
            step = 1,
            set = function(info,val) ns.db.secaurasize = val; ns.updateObjects() end,
        },
    },
}

ns.options.args.color = {
    type = "group", name = L.coloropts, order = 7,
	get = function(info) return ns.db[info[#info]].r,ns.db[info[#info]].g,ns.db[info[#info]].b,ns.db[info[#info]].a; end,
	set = function(info, r,g,b,a) ns.db[info[#info]].r,ns.db[info[#info]].g,ns.db[info[#info]].b,ns.db[info[#info]].a = r,g,b,a; ns:Colors();ns.updateObjects(); end,
    args = {
        HP = {
            name = L.coloroptshp,
            type = "group",
            order = 1,
            inline = true,
            args = {
                reverse = {
                    name = L.coloroptshpreverse,
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.reversecolors end,
                    set = function(info,val) ns.db.reversecolors = val;
					if ns.db.definecolors and val == true then
						ns.db.definecolors = false
					end
					ns:Colors(); ns.updateObjects();
                    end,
                },
                hpdefine = {
                    type = "group",
                    name = L.coloroptshpdefine,
                    order = 2,
                    inline = true,
                    args = {
                        definecolors = {
                            name = L.coloroptshpdefine,
                            type = "toggle",
                            order = 2,
                            get = function(info) return ns.db.definecolors end,
                            set = function(info,val) ns.db.definecolors = val;
							if ns.db.reversecolors and val == true then
								ns.db.reversecolors = false
							end
                            ns:Colors(); ns.updateObjects(); 
                            end,
                        },
                        hpcolor = {
                            name = L.coloroptshpcolor,
                            type = "color",
                            order = 3,
                            hasAlpha = false,
							disabled = function(info) return not ns.db.definecolors end,
                        },
						classbgcolor = {
                            name = L.coloroptsclassbgcolor,
                            type = "toggle",
                            order = 4,
							disabled = function(info) return not ns.db.definecolors end,
                            get = function(info) return ns.db.classbgcolor end,
                            set = function(info,val) ns.db.classbgcolor = val;
							if ns.db.reversecolors and val == true then
								ns.db.reversecolors = false
							end
                            ns:Colors(); ns.updateObjects(); 
                            end,
                        },
                        hpbgcolor = {
                            name = L.coloroptshpbgcolor,
                            type = "color",
                            order = 5,
                            hasAlpha = false,
							disabled = function(info) return not ns.db.definecolors or  ns.db.classbgcolor end,
                        },
                    },
                },
            },
        },
        PP = {
            name = L.coloroptspp,
            type = "group",
            order = 2,
            inline = true,
            args = {
                powerclass = {
                    name = L.coloroptshpreverse,
                    type = "toggle",
                    order = 1,
                    get = function(info) return ns.db.powerclass end,
                    set = function(info,val) ns.db.powerclass = val;
                        if val == true then
                            ns.db.powerdefinecolors = false
                        end
                        ns:Colors(); ns.updateObjects();
                    end,
                },
                ppdefine = {
                    type = "group",
                    name = L.coloroptsppdefine,
                    order = 2,
                    inline = true,
                    args = {
                        powerdefinecolors = {
                            name = L.coloroptsppdefine,
                            type = "toggle",
                            order = 2,
                            get = function(info) return ns.db.powerdefinecolors end,
                            set = function(info,val) ns.db.powerdefinecolors = val;
                                if val == true then
                                    ns.db.powerclass = false
                                end
                                ns:Colors(); ns.updateObjects(); 
                            end,
                        },
                        powercolor = {
                            name = L.coloroptspowercolor,
                            type = "color",
                            order = 3,
                            hasAlpha = false,
							disabled = function(info) return ns.db.powerclass end,
                        },
                        powerbgcolor = {
                            name = L.coloroptspowerbgcolor,
                            type = "color",
                            order = 4,
                            hasAlpha = false,
							disabled = function(info) return ns.db.powerclass end,
                        },
                    },
                },
            },
        },
		other = {
            name = L.coloroptsother,
            type = "group",
            order = 3,
            inline = true,
            args = {
				vehiclecolor = {
				name = L.coloroptsvehiclecolor,
				type = "color",
				order = 1,
				hasAlpha = false,
				desc = L.coloroptsvehiclecolordesc,
				},
				enemycolor = {
				name = L.coloroptsenemycolor,
				type = "color",
				order = 2,
				hasAlpha = false,
				desc = L.coloroptsenemycolordesc,
				},
				deadcolor = {
				name = L.coloroptsdeadcolor,
				type = "color",
				order = 3,
				hasAlpha = false,
				desc = L.coloroptsdeadcolordesc,
				},
			},
		},
		
    },
}

local profiles = {
	["NONE"] = L.none,
}
local inProfile, toProfile = "NONE","NONE"

for k,_ in pairs(_G[ADDON_NAME.."DB"].profiles) do 
	profiles[k] = k 
end

local function updatevalues()
	local path = ns.options.args.profile.args
	for k, v in pairs(path) do	
		if path[k].type == "select" then
			path[k].values = profiles	
		end	
	end
end

local function delProfile(key)
	local db = _G[ADDON_NAME.."DB"]
	
	if db.profiles[key] then
		db.profiles[key] = nil
		profiles[key] = nil		
	end

	for k, v in pairs(db.profileKeys[ns.general.playerDBKey].profile) do
		if v == key then
			db.profileKeys[ns.general.playerDBKey].profile[k] = "default"
		end
	end
	_G[ADDON_NAME.."DB"] = db
	updatevalues()
end

local function copyProfile()
	local todb = _G[ADDON_NAME.."DB"].profiles[toProfile] or {}
	local indb = _G[ADDON_NAME.."DB"].profiles[inProfile] or {}
	wipe(todb)
	todb = indb

	_G[ADDON_NAME.."DB"].profiles[toProfile] = todb
end

local function newProfile(key)
	local db = _G[ADDON_NAME.."DB"]

	if type(db.profiles[key]) ~= "table" then
		db.profiles[key] = {}
		profiles[key] = key
	end
	_G[ADDON_NAME.."DB"] = db
	updatevalues()
end

local function getTalentProfile(talent)
	local db = _G[ADDON_NAME.."DB"]
	local DBKey = ns.general.playerDBKey
	local val = "NONE"
	if type(db.profileKeys[DBKey]) == "table" then
		if not talent and db.profileKeys[DBKey].dualspec then 
			val = db.profileKeys[DBKey].profile.dual or "NONE"
		elseif talent == "primary" then
			val = db.profileKeys[DBKey].profile["1"] or "NONE"
		elseif talent == "second" then
			val = db.profileKeys[DBKey].profile["2"] or "NONE"
		end
	end
	_G[ADDON_NAME.."DB"] = db
	return val
end

local function setTalentProfile(key, talent)
	local db = _G[ADDON_NAME.."DB"]
	local DBKey = ns.general.playerDBKey
	if talent == "primary" then
		db.profileKeys[DBKey].profile["1"] = key
	elseif talent == "second" then
		db.profileKeys[DBKey].profile["2"] = key
	else
		db.profileKeys[DBKey].profile.dual = key
	end
	_G[ADDON_NAME.."DB"] = db
end

ns.options.args.profile = {
    type = "group", name = "配置文件", order = -9,
    args = {
		desc = {
			order = 1,
			type = "description",
			name = "在这里你可以对角色的配置文件进行设置.\n\n|cffFF0000注意:你所做的改动只会在下次重载UI或正常退出WOW时保存.非正常关机或强行关闭WOW将会丢失数据.|r\n",
		},
		reload = {
			name = "重置配置文件",
			type = "execute",
			func = function()  
				wipe(ns.db)
				ns.db = _G[ADDON_NAME.."DB"].profiles[ns.general.Profilename]
				ns:CopyDefaults(ns.db, ns.defaults)
				if type(ns.db.ClickCast) == "table" and type(ns.ApplyClickSetting) == "function" then
					ns:ApplyClickSetting()
				end
				ns:UpdateAttribute()
				ns:updateObjects()
				ns:RestoreDefaultPosition()
			end,
			order = 2,
		},
		reloaddesc = {
			order = 4,
			type = "description",
			name = function(info) return "将当前名称为: \"|cffFF0000"..ns.general.Profilename.."|r\"的配置文件恢复为默认值.\n" end,
		},
		new = {
			name = "新建配置文件",
			order = 5,
			type = "input",
			get = false,
			set = function(info,val) newProfile(val); end,
		},
		del = {
			name = "删除一个配置文件",
			type = "select",
			order = 6,			
			get = false,
			set = function(info,val) delProfile(val); end,
			confirm = true,
			confirmText = "你确认要删除这个配置文件?",
			values = profiles,
		},
		newdesc = {
			order = 7,
			type = "description",
			name = "在文本框内输入一个名字创立一个新的配置文件,在你启用它之前,只是一个空的配置文件.\n",
		},
		intlist = {
			name = "从",
			type = "select",
			order = 8,
			desc = "从当前可用的配置文件里面选择一个进行配置.",
			get = function(info) return inProfile end,
			set = function(info,val) inProfile = val;end,
			values = profiles,
		},
		tolist = {
			name = "复制到",
			type = "select",
			order = 9,
			get = function(info) return toProfile end,
			set = function(info,val) toProfile = val;end,
			values = profiles,
		},
		copy = {
			name = "复制配置文件",
			type = "execute",
			order = 10,
			confirm = true,
			confirmText = "将会清空目标文件,你确认要复制这个配置文件?",
			hidden = function(info) return inProfile == toProfile or inProfile == "NONE" or toProfile == "NONE"; end,
			func = function() copyProfile(); end,
			
		},			
		copydesc = {
			order = 11,
			type = "description",
			name = "在这里你可以复制某个你中意的配置文件,而不需要再行设置.\n",
		},
		deldesc1 = {
			order = 12,
			type = "description",
			name = "",
		},
		dualProfile = {
			name = "双天赋使用相同配置",
			type = "toggle",
			order = 13,
			get = function(info) return _G[ADDON_NAME.."DB"].profileKeys[ns.general.playerDBKey].dualspec end,
			set = function(info,val) _G[ADDON_NAME.."DB"].profileKeys[ns.general.playerDBKey].dualspec = val; end,
		},
		talentdsc = {
			name = "\n你可以选择双天赋使用相同配置或分别使用不同配置文件.",
			type = "description",
			order = 14,
		},
		dualspec = {
			name = "双天赋配置文件",
			type = "select",
			order = 15,
			hidden = function() return not _G[ADDON_NAME.."DB"].profileKeys[ns.general.playerDBKey].dualspec end,
			desc ="选择一个配置文件,在任意天赋时都会自动调用这个配置文件.",
			get = function(info) return getTalentProfile(); end,
			set = function(info,val) setTalentProfile(val);end,
			values = profiles,
		},
		primarytalent = {
			name = "主天赋",
			type = "select",
			order = 16,
			hidden = function() return _G[ADDON_NAME.."DB"].profileKeys[ns.general.playerDBKey].dualspec end,
			desc ="选择一个配置文件,当你切换到主天赋时会自动调用这个配置文件.",
			get = function(info) return getTalentProfile("primary"); end,
			set = function(info,val) setTalentProfile(val,"primary");end,
			values = profiles,
		},
		secondtalent = {
			name = "副天赋",
			type = "select",
			order = 17,
			hidden = function() return _G[ADDON_NAME.."DB"].profileKeys[ns.general.playerDBKey].dualspec end,
			desc ="选择一个配置文件,当你切换到副天赋时会自动调用这个配置文件.",
			get = function(info) return getTalentProfile("second"); end,
			set = function(info,val) setTalentProfile(val,"second"); end,
			values = profiles,
		},
	},
}

local AceConfig = LibStub("AceConfig-3.0")
AceConfig:RegisterOptionsTable(ADDON_NAME, ns.options)

local ACD = LibStub('AceConfigDialog-3.0')
ACD:AddToBlizOptions(ADDON_NAME, ADDON_NAME)

--InterfaceOptions_AddCategory(ns.movableopt)
LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)
