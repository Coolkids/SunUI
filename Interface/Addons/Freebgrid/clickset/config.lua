local ADDON_NAME, ns = "Freebgrid", Freebgrid_NS

local L = ns.Locale

local macroedit = {
	hidden = true,
	path = nil,
	path1 = nil,
}
local defaultvalues = {
	["NONE"] = L.none,
	["target"] = L.target,
	["menu"] = L.menu,
	["follow"] = L.follow,
	["macro"] = L.macro,
}
local default_spells = {
	PRIEST = { 	
			17,			--"真言術:盾",
			139,			--"恢復",
			527,			--"纯净术",
			596,			--"治疗祷言",
			1706,			--"漂浮术",
			2096,			--"心灵视界",
			2006,			--"復活術",
			2050,			--"治疗术",
			2060,			--"強效治療術",
			2061,			--"快速治療",
			6346,			--"防护恐惧结界",
			10060,			--"能量灌注",
			21562,			--"真言术:韧",
			32546,			--"束縛治療",	
			33076,			--"癒合禱言",
			33206,			--"痛苦压制",
			34861,			--"治療之環",
			47540,			--"苦修",
			48045,			--"精神灼烧",	
			48153,			--"守护之魂",
			73325,			--"信仰飞跃",
			88684,			--"圣言术:静",
			108968,			--"虚空转移",
	},
	
	DRUID = { 
			774,			--"回春術",
			2782,			--"净化腐蚀",
			8936,			--"癒合",
			50769,			--"起死回生",
			48438,			--"野性成长",
			18562,			--"迅捷治愈",
			50464,			--"滋補術",
			1126,			--"野性印记",
			5185,			--"治疗之触",
			20484,			--"复生",
			29166,			--"激活"
			33763,			--"生命绽放",
			467,			--"荆棘术",
			88423,			--"自然之愈",
	},
	SHAMAN = { 
			974,			--"大地之盾",
			2008,			--"先祖之魂",
			8004,			--"治疗之涌",
			1064,			--"治疗链",
			331,			--"治疗波",
			51886,			--"净化灵魂",
			546,			--"水上行走",
			61295,			--"激流",
			77472,			--"强效治疗波",	
			73680,			--"元素释放",
	},

	PALADIN = { 
			635,			--"聖光術",
			19750,			--"聖光閃現",
			53563,			--"圣光信标",
			7328,			--"救贖",
		    	20473,			--"神聖震擊",
			82326,			--"神圣之光",
			82327,			--"圣光普照"
			4987,			--"淨化術",
			85673,			--"荣耀圣令",
			633,			--"聖療術",
		    	31789,			--"正義防護",
			1044,			--"自由之手",
			31789,			--"正义防御",
			1022,			--"保护之手",
			6940,  			--"牺牲之手",
			1038,			--"拯救之手",
			114039,			--"纯净之手",
			114163,			--"永恒之火",
			114157,			--"处决宣判",
			114165,			--"神圣棱镜",
			20925,			--"圣洁护盾",
			19740,			--"力量祝福",
			20217,			--"王者祝福",
	},

	WARRIOR = { 
			114030,			--"警戒",
			114029,			--"捍卫",
			3411,			--"阻擾",
	},

	MAGE = { 
			1459,			--"秘法智力",
			475,			--"解除詛咒",
			130,			--"缓落",
	},

	WARLOCK = { 
			109773,			--"黑暗意图",
			5697,			--"无尽呼吸",
	},
	
	MONK = { 	
			115151,			--"复苏之雾",
			116694,			--"升腾之雾",
			115175,			--"抚慰之雾",
			124682,			--"氤氲之雾",
			116670,			--"振魂引",
			116841,			--"虎威",
			124081,			--"禅意珠",
			115098,			--"真气波"
			115450,			--"化瘀术",
			115178,			--"轮回转世",
			115921,			--"帝王传承",
			116781,			--"白虎传承",
			116849,			--"做茧缚命",
	},

	HUNTER = { 
			34477,			--"誤導",
			53271,      		--"主人的召唤"
			53480,			--"牺牲咆哮"
	},
	
	ROGUE = { 
			57934,			--"栽赃嫁祸",
	},
	
	DEATHKNIGHT = {
			61999,			--复活盟友
			47541,			--死缠
			49016,			--邪恶狂乱
	},
}

local SetClickKeyvalue = function(info,value)
	--local index = string.sub(info,string.find(info,"%d"))
	local index = string.sub(info,-1)
	if index then
		local val = string.gsub(info, "z", "-")
		local name = val
		val = string.gsub(val, "type%d", "", 1)
		if val == "" then val = "Click" end

		if value == "macro" then
			ns.db.ClickCast[index][val]["action"] = "macro"
			macroedit.hidden = false
			macroedit.path = index
			macroedit.path1 = val
		else
			ns.db.ClickCast[index][val]["action"] = value
			macroedit.hidden = true
			macroedit.path =nil
			macroedit.path1 =nil

		end
	end
end		

local GetClickKeyvalue = function(info)
	local index = string.sub(info,-1)
	--local index = string.sub(info,string.find(info,"%d"))
	local value = ""
	if index then
		local val = string.gsub(info, "z", "-")
		val = string.gsub(val, "type%d", "", 1)
		if val == "" then val = "Click" end
		value = ns.db.ClickCast[index][val]["action"]
	end
	return value
end		

local function setDefault(src, dest)
	if type(dest) ~= "table" then dest = {} end
	if type(src) == "table" then
		for k,v in pairs(src) do
			
			if type(v) == "table" then
				v = setDefault(v, dest[k])
			end
			dest[k] = v
		end
	end
	return dest
end

if type(ns.options) ~= "table" then
	ns.options = {
		type = "group", name = ADDON_NAME,
		get = function(info) return ns.db[info[#info]] end,
		set = function(info, value) ns.db[info[#info]] = value end,
		args={}
	}
end
ns.options.args.ClickCast = {
    type = "group",
	name = L.ClickCast, 
	childGroups = "select",
	get = function(info) return GetClickKeyvalue(info[#info]) end,
	set = function(info, value) SetClickKeyvalue(info[#info], value) end,
	args = {
		enable = {
			name = L.enable,
			type = "toggle",
			order = 1,
			width  = "full",
			desc = L.ClickCastdesc,
			get = function(info) return ns.db.ClickCast.enable end,
			set = function(info,val) ns.db.ClickCast.enable = val;end,
			},
		SetDefault = {
			name = L.SetDefault,
			type = "execute",
			func = function() setDefault(ns.defaults.ClickCast, ns.db.ClickCast);ns:ApplyClickSetting(); end,
			order = 2,
			desc = L.SetDefaultdesc,
			},
		apply = {
			name = L.ClickCastapply,
			type = "execute",
			func = function() ns:UpdateClickCastSet(); end,
			order = 3,
			desc = L.ClickCastapplydesc,
			},
		downclick = {
            name = L.downclick,
            type = "toggle",
            order = 4,
			disabled = function() return not ns.db.ClickCast.enable end,
            get = function(info) return ns.db.ClickCast.downclick end,
			set = function(info,val) ns.db.ClickCast.downclick = val; ns:UpdateClickCastSet();end,
        },
		CSGroup1 = {
			order = 5,
			type = "group",
			name = L.type1 ,		
			disabled = function() return not ns.db.ClickCast.enable end,
			args = {
				type1 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype1 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues						
				},
				ctrlztype1 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype1 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype1 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype1 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype1 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup2 = {
			order = 6,
			type = "group",
			name = L.type2 ,			
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type2 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype2 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues				
				},
				ctrlztype2 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype2 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype2 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype2 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype2 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup3 = {
			order = 7,
			type = "group",
			name = L.type3 ,			
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type3 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype3 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues					
				},
				ctrlztype3 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype3 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype3 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype3 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype3 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup4 = {
			order = 8,
			type = "group",
			name = L.type4 ,		
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type4 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype4 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues						
				},
				ctrlztype4 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype4 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype4 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype4 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype4 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup5 = {
			order = 9,
			type = "group",
			name = L.type5 ,			
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type5 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype5 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues					
				},
				ctrlztype5 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype5 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype5 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype5 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype5 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		macro = {
				order = 10,
				type = "input",
				width  = "full",
				multiline  = true,
				name = function(info)
				if macroedit.path then
					return macroedit.path1.."-"..macroedit.path.." "..L.ClickCastmacro
				else
					return ""			
				end	end,
				hidden =  function() return macroedit.hidden end,				
				desc = L.ClickCastmacrodesc,
				get = function(info) 
				if macroedit.path then 
					return ns.db.ClickCast[macroedit.path][macroedit.path1]["macrotext"] 
				else 
					return "" 
				end end,
				set = function(info,val)
					ns.db.ClickCast[macroedit.path][macroedit.path1]["macrotext"] = val
					macroedit.hidden = true
					ns:ApplyClickSetting() 
				end,
		},
    },	
}

local class = select(2, UnitClass("player"))
for _, v in pairs(default_spells[class]) do	--创建职业默认技能表
	local spellname = GetSpellInfo(v)	
	if spellname then
		defaultvalues[tostring(spellname)] = spellname
	end
end

for i = 1, 5 do	--设置下拉菜单
	local path = ns.options.args.ClickCast["args"]["CSGroup"..tostring(i)]["args"]
	for k, _ in ipairs (path) do
		path[k]["values"] = defaultvalues
	end
end

local getclickargsname = function(var)
	local v = string.gsub(var, "z", " + ")
	local ktype = L[string.match(v, "type%d")]		
	local name = string.gsub(v, "type%d", "")..ktype

	return name
end	

for i = 1, 5 do	--设置名称
	local path = ns.options.args.ClickCast["args"]["CSGroup"..tostring(i)]["args"]
	for k, _ in pairs (path) do
		path[k]["name"] = getclickargsname(k)
	end
end
