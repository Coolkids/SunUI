local ADDON_NAME, ns = ...

local L = ns.Locale

local default_ClassClick = {
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
			["alt-ctrl-"]	= {
				["action"]	= 10060,--"能量灌注",
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
				["action"]	= 5697,--"无尽呼吸",
							},
		},
	},

	HUNTER = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 53271,--"主人的召唤"
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
	MONK = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 116849,--"做茧缚命",
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

local class = select(2, UnitClass("player"))
local classClickdb = default_ClassClick[class]
local modifiers = { "Click", "shift-", "ctrl-", "alt-", "ctrl-shift-", "alt-shift-", "alt-ctrl-"}
local db = {
	enable = true,
	downclick = true,
}
local i
for i = 1, 5  do
	db[tostring(i)] = {}
	local modifier
	for _, modifier in ipairs(modifiers) do
		db[tostring(i)][modifier] = {}
		db[tostring(i)][modifier]["action"] = "NONE"
	end
end

for k, _ in pairs(classClickdb) do
	for j, _ in pairs(classClickdb[k]) do
		local var = classClickdb[k][j]["action"]
		local spellname = GetSpellInfo(var)
		if (var == "target" or var == "menu" or var == "follow") then
			db[k][j]["action"] = var
		elseif spellname then						
			db[k][j]["action"] = spellname
		end
	end
end
ns.defaults.ClickCast = db

function ns:RegisterClicks(object)
	local direction = ns.db.ClickCast.downclick and "AnyDown" or "AnyUp"
	
    if ns.db.ClickCast.enable then 
		local action, macrotext, key_tmp
		local C = ns.db.ClickCast
		for id, var in pairs(C) do
			if id ~= "haschange" and id ~= "enable" and id ~= "downclick" then
				for	key, _ in pairs(C[id]) do
					key_tmp = string.gsub(key,"Click","")
					action =  C[id][key]["action"]
					macrotext = C[id][key]["macrotext"]
					if action == "macro" and type(macrotext) == "string" then
						object:SetAttribute(key_tmp.."type"..id, "macro")
						object:SetAttribute(key_tmp.."macrotext"..id, macrotext)
					elseif action == "follow" then
						object:SetAttribute(key_tmp.."type"..id, "macro")
						object:SetAttribute(key_tmp.."macrotext"..id, "/follow mouseover")
					elseif	action == "menu" then		
						object:SetAttribute(key_tmp.."type"..id, "menu")
					elseif	action == "target" then		
						object:SetAttribute(key_tmp.."type"..id, "target")
					else				
						object:SetAttribute(key_tmp.."type"..id, "spell")
						object:SetAttribute(key_tmp.."spell"..id, action)
					end				
				end
			end
		end
		object:RegisterForClicks(direction)
	else
		--for _, modifier in ipairs(modifiers) do
		--	local modkey = string.gsub(modifier,"Click","")
		--	object:SetAttribute(modkey.."type2", "menu")
		--	object:SetAttribute(modkey.."type1", "target")
		--end
	end
end

function ns:ApplyClickSetting()
	if ns:CheckCombat(ns.ApplyClickSetting) then return end

	for _, object in next, ns._Objects do
		ns:RegisterClicks(object)
	end
	print(ADDON_NAME..": "..L.applyclicksetting)
end
