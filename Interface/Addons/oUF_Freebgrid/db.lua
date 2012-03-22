local ADDON_NAME, ns = ...

local binding_modifiers = { "Click", "shift-", "ctrl-", "alt-", "ctrl-shift-", "alt-shift-", "alt-ctrl-"}

ns.mediapath = "Interface\\AddOns\\oUF_Freebgrid\\media\\"

ns.defaults = {
    scale = 0.8,
    width = 65,
    height = 40,
    texture = "gradient",
    texturePath = ns.mediapath.."gradient",   
    fontPath = STANDARD_TEXT_FONT,
    font = "默认",
    fontsize = 16,
    fontsizeEdge = 11,
    outline = "OUTLINE",
    solo = true,
    player = true,
    party = true,
    numCol = 8,
    numUnits = 5,
    petUnits = 5,
    MTUnits = 5,
    spacing = 3,
    orientation = "HORIZONTAL",
    porientation = "HORIZONTAL",
    horizontal = true,
    pethorizontal = true,
    MThorizontal = true,
    growth = "DOWN",
    petgrowth = "DOWN",
    MTgrowth = "DOWN",
	GCD = true,
	GCDChange = true,
    reversecolors = true,
    definecolors = false,
    powerbar = true,
    onlymana = true,
    powerbarsize = .1,
    outsideRange = .40,
    arrow = true,
    arrowscale = 1.0,
    arrowmouseover = true,
    rangeIsNotConnected = true,
    healtext = false,
    healbar = true,
    healoverflow = true,
    healothersonly = false,
    healalpha = .40,
    hppercent = 90,
    roleicon = true,
    lowmana = true,
    manapercent = 10,
    pets = false,
    MT = false,
	tankaura = true,
    indicatorsize = 8,
    symbolsize = 18,
    leadersize = 12,
    aurasize = 22,
    multi = true,
	hptext = "DEFICIT",
	vehiclecolor = {r = 0.2, g = 0.9, b = 0.1, a = 1},	--载具颜色
	enemycolor = {r = 0.03, g = 0.03, b = 0.23, a = 1},	--敌对颜色
	deadcolor = {r = 0.3, g = 0.3, b = 0.3, a = 1},		--死亡颜色
    myhealcolor = { r = 0.0, g = 1.0, b = 0.5, a = 0.4 },
    otherhealcolor = { r = 0.0, g = 1.0, b = 0.0, a = 0.4 },
    hpcolor = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
    hpbgcolor = { r = 0.33, g = 0.33, b = 0.33, a = 1 },
    powercolor = { r = 0.17, g = 0.6, b = 1, a = 1 },
    powerbgcolor = { r = 0.33, g = 0.33, b = 0.33, a = 1 },
    powerdefinecolors = true,
	classbgcolor = true,
    colorSmooth = false,
    gradient = { r = 1, g = 0, b = 0, a = 1 },
    dispel = "BORDER",	--可驱散debuff显示方式,"NONE" = 不显示,"ICON" = "只显示图标","BORDER"= "图标+边框显示","INDICATOR"= "图标+右侧指示器显示",
    fborder = false,
    afk = false,
    highlight = true,
    powerclass = false,
    tooltip = false,
    smooth = true,
    altpower = false,
    sortClass = false,
    classOrder = "DEATHKNIGHT,DRUID,HUNTER,MAGE,PALADIN,PRIEST,ROGUE,SHAMAN,WARLOCK,WARRIOR",
    hidemenu = false,
	Resurrection = true,
	hideblzraid = true,
	ClickCastenable = true,
	ClickCastsetchange = false,
    ClickCastset = {},
	Freebgridomf2Char = {
		["Defaults"] ={
			["oUF_FreebgridPetFrame"] = "LEFTUIParent2500",
			["oUF_FreebgridRaidFrame"] = "LEFTUIParent80",
			["oUF_FreebgridMTFrame"] = "TOPLEFTUIParent8-60",
		},
	},
}

local ClassClickSets = {
	PRIEST = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 139,--"恢復",
							},
			["ctrl-"]		= {
				["action"]	= 527,--"驅散魔法",
							},
			["alt-"]		= {
				["action"]	= 2061,--"快速治療",
							},
			["alt-ctrl-"]	= {
				["action"]	= 2006,--"復活術",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]		= 17,--"真言術:盾",
							},
			["shift-"]		= {
				["action"]	= 33076,--"癒合禱言",
							},
			["ctrl-"]		= {
				["action"]	= 528,--"驅除疾病", 
							},
			["alt-"]		= {
				["action"]	= 2060,--"強效治療術",
							},
			["alt-ctrl-"]	= {
				["action"]	= 32546,--"束縛治療",
							},
		},
		["3"] = {
			["Click"]			= {
				["action"]	= 34861,--"治療之環",
							},
			["shift-"]		= {
				["action"]	= 2050, --治疗术
							},
			["alt-"]		= {
				["action"]	= 1706, --漂浮术
							},
			["ctrl-"]		= {
				["action"]	= 21562,--耐
							},
		},
		["4"] = {
			["Click"]		= {
				["action"]		= 596, --治疗祷言
							},
			["shift-"]		= {
				["action"]	= 47758, -- 苦修
							},
			["ctrl-"]		= {
				["action"]	= 73325, -- 信仰飞跃
							},
		},
		["5"] = {
			["Click"]			= {
				["action"]	= 48153, -- 守护之魂
							},
			["shift-"]		= {
				["action"]	= 88625, -- 圣言术
							},
			["ctrl-"]		= {
				["action"]	= 33206,--痛苦压制
							},
		},
	},
	
	DRUID = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 774,--"回春術",
							},
			["ctrl-"]		= {
				["action"]	= 2782,--"净化腐蚀",
							},
			["alt-"]		= {
				["action"]	= 8936,--"癒合",
							},
			["alt-ctrl-"]	= {
				["action"]	= 50769,--"復活",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 48438,--"野性成长",
							},
			["shift-"]		= {
				["action"]	= 18562,--"迅捷治愈",
							},
			["ctrl-"]		= {
				["action"]	= 88423, -- 自然治愈
							},
			["alt-"]		= {
				["action"]	= 50464,--"滋補術",
							},
			["alt-ctrl-"]	= {
				["action"]	= 1126, -- 野性印记
							},
		},
		["3"] = {
			["Click"]			= {
				["action"]	= 33763,--"生命之花",
							},
			["shift-"]		= {
				["action"]	= 5185,--治疗之触
							},
			["ctrl-"]		= {
				["action"]	= 20484,--复生,
							},
		},
		["4"] = {
			["Click"]			= {
				["action"]	= 29166,----激活
							},
			["alt-"]		= {
				["action"]		= 33763,----生命之花
							},
		},
	},
	SHAMAN = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["ctrl-shift-"]	= {
				["action"]	= 974,		--"大地之盾",
				},
			["ctrl-"]		= {
				["action"]	= 2008,		--"先祖之魂",
							},
			["alt-"]		= {
				["action"]	= 8004,		--"治疗之涌",
							},
			["shift-"]		= {
				["action"]	= 1064,		--"治疗链",
							},
			["alt-ctrl-"]	= {
				["action"]	= 331,		--"治疗波",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 51886,	--"净化灵魂",
							},
			["ctrl-"]		= {
				["action"]	= 546,		--水上行走
							},
			["alt-"]		= {
				["action"]	= 131,		--水下呼吸
							},
		},
		["3"] = {
			["Click"]			= {
				["action"]	= 61295,	--"激流",
							},
			["alt-ctrl-"]	= {
				["action"]	= 77472,	--"强效治疗波",	
							},
		},
		["4"] = {
			["Click"]			= {
				["action"]	= 73680,	--"元素释放",
							},
		},
		["5"] = {

		},
	},

	PALADIN = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 635,--"聖光術",
							},
			["alt-"]		= {
				["action"]	= 19750,--"聖光閃現",
							},
			["ctrl-"]		= {
				["action"]	= 53563,--"圣光信标",
							},
			["alt-ctrl-"]	= {
				["action"]	= 7328,--"救贖",
							},
		},
		["2"] = {
		    ["Click"]			= {
				["action"]	= 20473,--"神聖震擊",
							},
			["shift-"]		= {
				["action"]	= 82326,--"神圣之光",
							},
			["ctrl-"]		= {
				["action"]	= 4987,--"淨化術",
							},
			["alt-"]		= {
				["action"]	= 85673,--"荣耀圣令",
							},
			["alt-ctrl-"]	= {
				["action"]	= 633,--"聖療術",
							},
		},
		["3"] = {
		    ["Click"]			= {
				["action"]	= 31789,--正義防護
							},
			["alt-"]		= {
				["action"]	= 1044,--自由之手
							},
			["ctrl-"]	= {
				["action"]	= 31789, -- 正义防御
							},
		},
		["4"] = {
			["Click"]			= {
				["action"]	= 1022,	--"保护之手",
							},
			["alt-"]		= {
				["action"]	= 6940,  --牺牲之手
							},
		},
		["5"] = {
			["Click"]			= {
				["action"]	= 1038,	--"拯救之手",
							},
		},
	},

	WARRIOR = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["ctrl-"]		= {
				["action"]	= 50720,--"戒備守護",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 3411,--"阻擾",
							},
		},
	},

	MAGE = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["alt-"]		= {
				["action"]	= 1459,--"秘法智力",
							},
			["ctrl-"]		= {
				["action"]	= 54646,--"专注",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 475,--"解除詛咒",
							},
			["shift-"]		= {
				["action"]	= 130,--"缓落",
							},
		},
	},

	WARLOCK = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["alt-"]		= {
				["action"]	= 80398,--"黑暗意图",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 5697,--"魔息",
							},
		},
	},

	HUNTER = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 34477,--"誤導",
							},
			["shift-"]		= {
				["action"]	= 136, --治疗宠物
							},
		},
	},
	
	ROGUE = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 57933,--"偷天換日",
							},
		},
	},
	
	DEATHKNIGHT = {
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 61999, --复活盟友
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 47541, --死缠
							},
			["alt-"]		= {
				["action"]	= 49016, -- 邪恶狂乱（邪恶天赋)
							},
		},
	},
}

local function GetTalentSpec()
	local spec = GetPrimaryTalentTree() or 0
	return spec
end

function ns.ClickSetDefault ()
	local db = {}
	local i
	for i=1, 5  do
		db[tostring(i )] = {}
		local modifier
		for _, modifier in ipairs(binding_modifiers) do
			db[tostring(i )][modifier] = {}
			db[tostring(i )][modifier]["action"] = "NONE"
		end
	end

	local class = select(2, UnitClass("player"))
		for k, _ in pairs(ClassClickSets[class]) do
				for j, _ in pairs(ClassClickSets[class][k]) do
					local var = ClassClickSets[class][k][j]["action"]
					local spellname = GetSpellInfo(var)
					if (var == "target" or var == "menu" or var == "follow") then
						db[k][j]["action"] = var
					elseif spellname then						
						db[k][j]["action"] = spellname
					end
				end
		end
	ns.db.ClickCastset = db
end

function ns.InitDB()
	_G[ADDON_NAME.."DB"]  = _G[ADDON_NAME.."DB"] or {}	
	for n, _ in pairs(_G[ADDON_NAME.."DB"]) do		--删除旧版的配置文件
		if not string.match(n,"Talent") then
			_G[ADDON_NAME.."DB"] [n] = nil
		end
	end
	
	ns.TalentTree = "Talent"..GetTalentSpec()
	local tree = ns.TalentTree

	if type(_G[ADDON_NAME.."DB"][tree]) ~= "table" then
		_G[ADDON_NAME.."DB"][tree] = {}
	end	
	
	for k, v in pairs(ns.defaults) do
        if(type(_G[ADDON_NAME.."DB"][tree][k]) == 'nil') then
            _G[ADDON_NAME.."DB"][tree][k] = v
        end
    end
	
	ns.db = _G[ADDON_NAME.."DB"][tree]

	if not ns.db.ClickCastsetchange then
		ns.ClickSetDefault () 
		ns.db.ClickCastsetchange = true	
	end
	
	if ns.TalentChanged then
		ns.restorePosition()
		ns.updateFrameSetting()
		ns.ApplyClickSetting()
		ns.TalentChanged = nil
	end
end

function ns.FlushDB()			
	for i,v in pairs(ns.defaults) do if type(ns.db[i]) ~= "table" and ns.db[i] == v then ns.db[i] = nil end end
end



