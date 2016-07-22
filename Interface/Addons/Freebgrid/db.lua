local ADDON_NAME, ns = ...

local L = ns.Locale

local mediapath = "Interface\\AddOns\\Freebgrid\\media\\"
ns.media = {
	indicator = mediapath.."squares.ttf",
	symbols = mediapath.."PIZZADUDEBULLETS.ttf",
}

ns.db = {}
ns.general = {}

ns.PowerBarColor = {
	["MANA"] = { r = 0.00, g = 0.00, b = 1.00 },
	["RAGE"] = { r = 1.00, g = 0.00, b = 0.00 },
	["FOCUS"] = { r = 1.00, g = 0.50, b = 0.25 },
	["ENERGY"] = { r = 1.00, g = 1.00, b = 0.00 },
	["UNUSED"] = { r = 0.00, g = 1.00, b = 1.00 },
	["RUNES"] = { r = 0.50, g = 0.50, b = 0.50 },
	["RUNIC_POWER"] = { r = 0.00, g = 0.82, b = 1.00 },
	["SOUL_SHARDS"] = { r = 0.50, g = 0.32, b = 0.55 },
	["ECLIPSE"] = { negative = { r = 0.30, g = 0.52, b = 0.90 },  positive = { r = 0.80, g = 0.82, b = 0.60 }},
	["HOLY_POWER"] = { r = 0.95, g = 0.90, b = 0.60 },
	["AMMOSLOT"] = { r = 0.80, g = 0.60, b = 0.00 },
	["FUEL"] = { r = 0.0, g = 0.55, b = 0.5 },
}
ns.RaidClassColors = {
	["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 },
	["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 },
	["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0 },
	["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 },
	["MAGE"] = { r = 0.41, g = 0.8, b = 0.94 },
	["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41 },
	["DRUID"] = { r = 1.0, g = 0.49, b = 0.04 },
	["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87 },
	["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 },
	["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
	["MONK"] = { r = 0.0, g = 0.98 , b = 0.58 },
	["DEMONHUNTER"] = {r = 0.64, g = 0.19, b = 0.79},
}

local Gcd_class_spells = {
	["DEATHKNIGHT"]	= 45902,		
	["HUNTER"]		= 1978,			
	["PRIEST"] 		= 21562,		
	["PALADIN"]		= 635,			
	["WARLOCK"]		= 686,			
	["MAGE"]		= 133,			
	["WARRIOR"]		= 7386,			
	["SHAMAN"] 		= 331,			
	["ROGUE"]		= 1752,			
	["DRUID"] 		= 1126,		
	["MONK"] 		= 115921,
}

local Indicators_class_default = {
	["DRUID"] = {--职业
		["TL"] = {
			["1"] = {
				id 	= {774},		--"回春术"
				isbuff	= true,
				mine	= true,
			},
			["2"] = {
				id 	= {155777},		--"回春术(萌芽)"
				isbuff	= true,
				mine	= true,
				color	= {r = .8, g = 1, b = 0.0},
			},
		},
		["TR"] = {},
		["BL"] = {
			["1"] = {
				id 		= {8936},		--"愈合"
				isbuff	= true,
				mine	= false,
				lack	= false,
			},
			["2"] = {
				id 		= {48438},		--"野性成长"
				isbuff	= true,
				mine	= false,
				lack	= false,
				color	= {r = .8, g = 1, b = 0.0},
			},
		},
		["RC"] = {},
		["BR"] = {{},
		["Cen"] = {
			["1"] = {
				id 		= {774},		--"回春"
				isbuff	= true,
				mine	= true,
				etime	= true,
			},
		},
	},
	["PRIEST"] = {
		["TL"] = {
			["1"] = {
				id 		= {17},			--"真言术:盾"
				isbuff	= true,
				mine	= true,
				lack	= false,
			},
			["2"] = {
				id 		= {6788},		--"虚弱灵魂"
				isbuff	= false,
				mine	= false,
				lack	= false,
				color	= {r = 1, g = 0.0, b = 0.0},
			},
		
		},
		["TR"] = {},
		["BL"] = {
			["1"] = {
				id 		= {62618,47753},		--"真言术:障"
				isbuff	= true,
				--lack	= false,
			},
		},
		["RC"] = {},
		["BR"] = {
			["1"] = {
				id 		= {41635},		--"愈合祷言"
				isbuff	= true,
				mine	= true,
				lack	= false,
				etime	= false,
				count 	= true,
			},
		},
		["Cen"] = {
			["1"] = {
				id 		= {139,152118},	--"恢复/意志洞悉"
				isbuff	= true,
				mine	= true,
				lack	= false,
				etime	= true,
			},
		},
	},
	["PALADIN"] = {
		["TL"] = {
			["1"] = {
				id 	= {25771},			--自律
				isbuff	= false,
				mine	= true,
				lack	= false,
				color	= {r = 1, g = 0.0, b = 0.0},
			},
		},
		["TR"] = {},
		["BL"] = {
			["1"] = {
				id 		= {53563, 156910,200025},		--"圣光道标, 信仰道标,美德道标"
				isbuff	= true,
				mine	= true,
				lack	= false,
			},
		},
		["RC"] = {},
		["BR"] = {},
		["Cen"] = {
			["1"] = {
				id 		= {1022, 204013, 1044, 6940, 204018},	--祝福之手
				isbuff	= true,
				mine	= true,
				lack	= false,
				etime	= true,
			},
		},
	},
	["WARLOCK"] = {
		["TL"] = {},
		["TR"] = {},
		["BL"] = {
			["1"] = {
				id 		= {20707},		--"灵魂石"
				isbuff	= true,
				mine	= true,
				lack	= false,
			},
		},
		["RC"] = {},
		["BR"] = {
			["1"] = {
				id 		= {20707},		--"灵魂石"
				isbuff	= true,
				mine	= false,
				lack	= false,
				etime	= false,
			},
		},
		["Cen"] = {},
	},
	["WARRIOR"] = {
		["TL"] = {},
		["TR"] = {},
		["BL"] = {},
		["RC"] = {},
		["BR"] = {},
		["Cen"] = {},
	},
	["DEATHKNIGHT"] = {
		["TL"] = {},
		["TR"] = {},
		["BL"] = {},
		["RC"] = {},
		["BR"] = {},
		["Cen"] = {},
	},
	["SHAMAN"] = {
		["TL"] = {
			["1"] = {
				id 		= {61295},		--"激流"
				isbuff	= true,
				mine	= true,
				lack	= false,
				color	= {r = 0.0, g = 1, b = 0.0},
			},

		},
		["TR"] = {
			["1"] = {
				id 		= {105284},		--"先祖活力"
				isbuff	= true,
				mine	= false,
				lack	= false,
				color	= {r = .8, g = 1, b = 0.0},
			},
		},
		["BL"] = {},
		["RC"] = {},
		["BR"] = {},
		["Cen"] = {
			["1"] = {
				id 		= {61295},		--"激流"
				isbuff	= true,
				mine	= true,
				lack	= false,
				etime	= true,
			},
		},
	},
	["HUNTER"] = {
		["TL"] = {},
		["BL"] = {},
		["RC"] = {},
		["BR"] = {},
		["Cen"] = {},
	},
	["ROGUE"] = {
		["TL"] = {},
		["BL"] = {},
		["RC"] = {},
		["BR"] = {},
		["Cen"] = {},
	},
	["MONK"] = {
		["TL"] = {
			["1"] = {
				id 		= {119611},		--"复苏之雾"
				isbuff	= true,
				mine	= true,
			},
		},
		["TR"] = {},
		["BL"] = {
			["1"] = {
				id 		= {132120},		--"氤氲之雾"
				isbuff	= true,
			},
		},
		["RC"] = {},
		["BR"] = {},
		["Cen"] = {
			["1"] = {
				id 		= {119611},		--"复苏之雾"
				isbuff	= true,
				mine	= true,
				lack	= false,
				etime	= true,
			},
		},
	},
	["MAGE"] = {
		["TL"] = {},
		["TR"] = {},
		["BL"] = {},
		["RC"] = {},
		["BR"] = {},
		["Cen"] = {},
	},
	}
}


ns.defaults = {
    scale = 1.0,
    width = 78,
    height = 38,
    texture = "Blizzard",
    texturePath = mediapath.."gradient",   
    fontPath = STANDARD_TEXT_FONT,
    font = L.defaultfont,
    fontsize = 12,
    fontsizeEdge = 10,
    outline = "THINOUTLINE",
	shadowoffset = 1,
    solo = true,
    player = true,
    party = true,
    numCol = 8,
    spacing = 4,
    orientation = "HORIZONTAL",
    porientation = "HORIZONTAL",
    horizontal = true,
    pethorizontal = true,
    MThorizontal = true,
	abbnumber = true,
    growth = "UP",
    petgrowth = "UP",
    MTgrowth = "DOWN",
	Gcd = true,
    reversecolors = true,
    definecolors = false,
    powerbar = true,
    onlymana = true,
    powerbarsize = .08,
    outsideRange = .40,
    arrow = true,
    arrowscale = 1.0,
    arrowmouseover = true,
    healtext = false,
    healbar = true,
    healoverflow = false,
    healothersonly = false,
    healalpha = .40,
    hppercent = 90,
    roleicon = true,
    lowmana = true,
    manapercent = 10,
    pets = false,
    MT = false,
    indicatorsize = 11,
    symbolsize = 12,
    leadersize = 12,
	dispeliconsize = 15,
    aurasize = 18,
	secaurasize = 12,
	hptext = "DEFICIT",
	vehiclecolor = {r = 0.2, g = 0.9, b = 0.1, a = 1},	--载具颜色
	enemycolor = {r = 0.25, g = 0.05, b = 0.27, a = 1},	--敌对颜色
	deadcolor = {r = 0.3, g = 0.3, b = 0.3, a = 1},		--死亡颜色
    myhealcolor = { r = 0.0, g = 1.0, b = 0.5, a = 0.4 },
    otherhealcolor = { r = 0.0, g = 1.0, b = 0.0, a = 0.4 },
    hpcolor = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
    hpbgcolor = { r = 0.33, g = 0.33, b = 0.33, a = 1 },
    powercolor = { r = 0.17, g = 0.6, b = 1, a = 1 },
    powerbgcolor = { r = 0.33, g = 0.33, b = 0.33, a = 1 },
    powerdefinecolors = true,
	classbgcolor = true,
    dispel = true,
    fborder = false,
    highlight = true,
    powerclass = false,
    tooltip = true,
    smooth = true,
	Indicatorsenable = true,
    hidemenu = true,
	Resurrection = true,
	hideblzraid = true,
	hideblzparty = true,
	aurora = false,
	Freebgridomf2Char = {
		["Defaults"] ={
			["FreebgridPetFrame"] = "LEFTUIParent2500",
			["FreebgridRaidFrame"] = "LEFTUIParent80",
			["FreebgridMTFrame"] = "TOPLEFTUIParent8-60",
		},
	},
}

local function copyTable(src, dest) --只拷贝dest表内值为nil的数据,非覆盖拷贝.
	if type(dest) ~= "table" then dest = {} end
	if type(src) == "table" then
		for k,v in pairs(src) do
			
			if type(v) == "table" then
				v = copyTable(v, dest[k])
			end
			if type(dest[k]) == 'nil' then 
				dest[k] = v
			end
		end
	end
	return dest
end

function ns:CopyDefaults(dest, src)
	
	for k, v in pairs(src) do
		if type(v) == "table" then
			if not rawget(dest, k) then rawset(dest, k, {}) end
			if type(dest[k]) == "table" then
				self:CopyDefaults(dest[k], v)
			end
		else
			if rawget(dest, k) == nil then
				rawset(dest, k, v)
			end
		end
	end
end

local function removeDefaults(src, dest)
	if type(dest) ~= "table" then return end
	for k, v in pairs(src) do 
		if type(v) == "table" and type(dest[k]) == "table" then
			removeDefaults(v, dest[k])
			if next(dest[k]) == nil then
				dest[k] = nil
			end
		else
			if dest[k] == src[k] then
				dest[k] = nil
			end
		end
	end	
end

function ns:UpdatePlayerData()		
	ns.general.classDisplayName, ns.general.class,ns.general.classID = UnitClass("player")
	ns.general.playername = UnitName("player")
	ns.general.isHealer = self:IsHealer(ns.general.class)
	ns.general.realmname = GetRealmName()
	ns.general.playerDBKey = ns.general.playername.." - "..ns.general.realmname
	ns.general.MapID = self:GetMapID()  
	ns.general.GcdSpellID = Gcd_class_spells[ns.general.class]
	ns.general.IndicatorsSet = Indicators_class_default[ns.general.class]
	ns.general.dispellist = self:GetDispelClass()
	ns.general.TalentSpec, ns.general.activeSpecGroup, ns.general.TalentGroupName = self:GetTalentSpec()
end	
	
function ns:InitDB()
	_G[ADDON_NAME.."DB"] = _G[ADDON_NAME.."DB"] or {}	
	
	ns:UpdatePlayerData()

	local G = ns.general
	local DB = _G[ADDON_NAME.."DB"] 

	for n, _ in pairs(DB) do		--删除旧版的配置文件
		if not string.match(n,"profile") then
			DB[n] = nil
		end
	end
	
	if type(DB.profiles) ~= "table" then
		DB.profiles = {}
	end
	if type(DB.profiles[G.playerDBKey]) ~= "table" then
		DB.profiles[G.playerDBKey] = {}
	end
	
	if type(DB.profileKeys) ~= "table" then
		DB.profileKeys = {}
	end
	if type(DB.profileKeys[G.playerDBKey]) ~= "table" then
		DB.profileKeys[G.playerDBKey] = {}
	end
	if type(DB.profileKeys[G.playerDBKey].profile) ~= "table" then
		DB.profileKeys[G.playerDBKey].profile = {}
	end

	if not ns.general.TalentSpec or DB.profileKeys[G.playerDBKey].dualspec then
		if not DB.profileKeys[G.playerDBKey].profile.dual or type(DB.profiles[DB.profileKeys[G.playerDBKey].profile.dual]) ~= "table" then
			DB.profileKeys[G.playerDBKey].profile.dual = G.playerDBKey
		end
	else
		if not DB.profileKeys[G.playerDBKey].profile["1"] then
			DB.profileKeys[G.playerDBKey].profile["1"] = G.playerDBKey
		end
		if not DB.profileKeys[G.playerDBKey].profile["2"] then
			DB.profileKeys[G.playerDBKey].profile["2"] = G.playerDBKey
		end
	end
	
	if not ns.general.TalentSpec or DB.profileKeys[G.playerDBKey].dualspec then
		ns.general.Profilename = DB.profileKeys[G.playerDBKey].profile.dual
	else
		ns.general.Profilename = DB.profileKeys[G.playerDBKey].profile[tostring(ns.general.activeSpecGroup)]
	end
	_G[ADDON_NAME.."DB"] = DB

	ns.db = _G[ADDON_NAME.."DB"].profiles[ns.general.Profilename]
	ns:CopyDefaults(ns.db, ns.defaults)
end

function ns:FlushDB(key)
	local name = key or ns.general.Profilename
	
	removeDefaults(ns.defaults, _G[ADDON_NAME.."DB"].profiles[name])
end



