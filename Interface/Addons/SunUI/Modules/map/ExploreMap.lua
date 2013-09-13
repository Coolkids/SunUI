local S, L, DB, _, C = unpack(select(2, ...))

local FACTION = UnitFactionGroup("player")
local questCompletion, exploreCompletion, adjustedX, adjustedY
local datebase, L_ZONE_WINTERGRASP, L_ZONE_TOLBARAD, L_ZONE_TOLBARADPEN, L_ZONE_ARATHIBASIN, L_ZONE_GILNEAS
if DB.zone ==  "zhCN" then
	L_ZONE_WINTERGRASP = "冬握湖"
	L_ZONE_TOLBARAD = "托尔巴拉德"
	L_ZONE_TOLBARADPEN = "托尔巴拉德半岛"
	L_ZONE_ARATHIBASIN = "阿拉希盆地"
	L_ZONE_GILNEAS = "吉尔尼斯之战"
	datebase= {
		["东部王国"]							= {X =   42, A =    0, H =    0},
		["卡利姆多"]							= {X =   43, A =    0, H =    0},
		["外域"]							= {X =   44, A =    0, H =    0},
		["诺森德"]							= {X =   45, A =    0, H =    0},
		["世界地图"]							= {X =  nil, A =    0, H =    0},
		["潘达利亚"]							= {X = 6974, A =    0, H =    0},
		-- Eastern Kingdoms
		["阿拉希高地"]						= {X =  761, A = 4896, H = 4896},
		["荒芜之地"]							= {X =  765, A = 4900, H = 4900},
		["诅咒之地"]							= {X =  766, A = 4909, H = 4909},
		["燃烧平原"]							= {X =  775, A = 4901, H = 4901},
		["逆风小径"]							= {X =  777, A =    0, H =    0},
		["丹莫罗"]							= {X =  627, A =    0, H =    0},
		["暮色森林"]							= {X =  778, A = 4903, H =    0},
		["东瘟疫之地"]						= {X =  771, A = 4892, H = 4892},
		["艾尔文森林"]						= {X =  776, A =    0, H =    0},
		["永歌森林"]							= {X =  859, A =    0, H =    0},
		["幽魂之地"]							= {X =  858, A =    0, H = 4908},
		["希尔斯布莱德丘陵"]					= {X =  772, A =    0, H = 4895},
		["洛克莫丹"]							= {X =  779, A = 4899, H =    0},
		["北荆棘谷"]							= {X =  781, A = 4906, H = 4906},
		["赤脊山"]							= {X =  780, A = 4902, H =    0},
		["灼热峡谷"]							= {X =  774, A = 4910, H = 4910},
		["银松森林"]							= {X =  769, A =    0, H = 4894},
		["悲伤沼泽"]							= {X =  782, A = 4904, H = 4904},
		["荆棘谷海角"]						= {X = 4995, A = 4905, H = 4905},
		["辛特兰"]							= {X =  773, A = 4897, H = 4897},
		["提瑞斯法林地"]						= {X =  768, A =    0, H =    0},
		["西瘟疫之地"]						= {X =  770, A = 4893, H = 4893},
		["西部荒野"]							= {X =  802, A = 4903, H =    0},
		["湿地"]							= {X =  841, A = 4899, H =    0},
		-- Kalimdor
		["灰谷"]							= {X =  845, A = 4925, H = 4976},
		["艾萨拉"]							= {X =  852, A =    0, H = 4927},
		["秘蓝岛"]							= {X =  860, A =    0, H =    0},
		["秘血岛"]							= {X =  861, A = 4926, H = 4926},
		["黑海岸"]							= {X =  844, A = 4928, H = 4928},
		["凄凉之地"]							= {X =  848, A = 4930, H = 4930},
		["杜隆塔尔"]							= {X =  728, A =    0, H =    0},
		["尘泥沼泽"]							= {X =  850, A = 4929, H = 4978},
		["费伍德森林"]						= {X =  853, A = 4931, H = 4931},
		["菲拉斯"]							= {X =  849, A = 4932, H = 4979},
		["月光林地"]							= {X =  855, A =    0, H =    0},
		["莫高雷"]							= {X =  736, A =    0, H =    0},
		["北贫瘠之地"]						= {X =  750, A =    0, H = 4933},
		["希利苏斯"]							= {X =  856, A = 4934, H = 4934},
		["南贫瘠之地"]						= {X = 4996, A = 4937, H = 4981},
		["石爪山脉"]							= {X =  847, A = 4936, H = 4980},
		["塔纳利斯"]							= {X =  851, A = 4935, H = 4935},
		["泰达希尔"]							= {X =  842, A =    0, H =    0},
		["千针石林"]							= {X =  846, A = 4938, H = 4938},
		["安戈洛环形山"]						= {X =  854, A = 4939, H = 4939},
		["冬泉谷"]							= {X =  857, A = 4940, H = 4940},
		-- Outland
		["刀锋山"]							= {X =  865, A = 1193, H = 1193},
		["地狱火半岛"]						= {X =  862, A = 1189, H = 1271},
		["纳格兰"]							= {X =  866, A = 1192, H = 1273},
		["虚空风暴"]							= {X =  843, A = 1194, H = 1194},
		["影月谷"]							= {X =  864, A = 1195, H = 1195},
		["泰罗卡森林"]						= {X =  867, A = 1191, H = 1272},
		["赞加沼泽"]							= {X =  863, A = 1190, H = 1190},
		-- Northrend
		["北风苔原"]							= {X = 1264, A =   33, H = 1358},
		["晶歌森林"]							= {X = 1457, A =    0, H =    0},
		["龙骨荒野"]							= {X = 1265, A =   35, H = 1356},
		["灰熊丘陵"]							= {X = 1266, A =   37, H = 1357},
		["嚎风峡湾"]							= {X = 1263, A =   34, H = 1356},
		["冰冠冰川"]					 		= {X = 1270, A =   40, H =   40},
		["索拉查盆地"]						= {X = 1268, A =   39, H =   39},
		["风暴峭壁"]							= {X = 1269, A =   38, H =   38},
		["祖达克"]							= {X = 1267, A =   36, H =   36},
		-- Cataclysm
		["深岩之洲"]							= {X = 4864, A = 4871, H = 4871},
		["海加尔"]							= {X = 4863, A = 4870, H = 4870},
		["暮光高地"]							= {X = 4866, A = 4873, H = 5501},
		["奥丹姆"]							= {X = 4865, A = 4872, H = 4872},
		["瓦丝琪尔"]							= {X = 4825, A = 4869, H = 4982},
		["托尔巴拉德"]						= {X =    0, A = 4874, H = 4874},
		["托尔巴拉德半岛"]					= {X =    0, A = 4874, H = 4874},
		-- Pandaria
		["翡翠林"]							= {X = 6351, A = 6300, H = 6534},
		["四风谷"]							= {X = 6969, A = 6301, H = 6301},
		["昆莱山"]							= {X = 6976, A = 6537, H = 6538},
		["螳螂高原"]							= {X = 6977, A = 6539, H = 6539},
		["恐惧废土"]							= {X = 6978, A = 6540, H = 6540},
		["锦绣谷"]							= {X = 6979, A =    0, H =    0},
		-- Boolean Explores
		["奎尔丹纳斯岛"]						= {X =  868, A =    0, H =    0},
		["安其拉：堕落王国"]					= {X =    0, A =    0, H =    0},
		["冬拥湖"]							= {X =    0, A =    0, H =    0},
	}
elseif DB.zone ==  "zhTW" then
	L_ZONE_WINTERGRASP = "冬握湖"
	L_ZONE_TOLBARAD = "托巴拉德"
	L_ZONE_TOLBARADPEN = "托巴拉德半島"
	L_ZONE_ARATHIBASIN = "阿拉希盆地"
	L_ZONE_GILNEAS = "吉爾尼斯之戰"
	datebase = {
		["東部王國"]							= {X =   42, A =    0, H =    0},
		["卡林多"]							= {X =   43, A =    0, H =    0},
		["外域"]							= {X =   44, A =    0, H =    0},
		["北裂境"]							= {X =   45, A =    0, H =    0},
		["潘達利亞"]						= {X = 6974, A =    0, H =    0}, -- Needs review
		["世界地圖"]							= {X =  nil, A =    0, H =    0},
		-- Eastern Kingdoms
		["阿拉希高地"]						= {X =  761, A = 4896, H = 4896},
		["荒蕪之地"]							= {X =  765, A = 4900, H = 4900},
		["詛咒之地"]							= {X =  766, A = 4909, H = 4909},
		["燃燒平原"]							= {X =  775, A = 4901, H = 4901},
		["逆風小徑"]							= {X =  777, A =    0, H =    0},
		["丹莫洛"]							= {X =  627, A =    0, H =    0},
		["暮色森林"]							= {X =  778, A = 4903, H =    0},
		["東瘟疫之地"]						= {X =  771, A = 4892, H = 4892},
		["艾爾文森林"]						= {X =  776, A =    0, H =    0},
		["永歌森林"]							= {X =  859, A =    0, H =    0},
		["鬼魂之地"]							= {X =  858, A =    0, H = 4908},
		["希爾斯布萊德丘陵"]					= {X =  772, A =    0, H = 4895},
		["洛克莫丹"]							= {X =  779, A = 4899, H =    0},
		["北荊棘谷"]							= {X =  781, A = 4906, H = 4906},
		["赤脊山"]							= {X =  780, A = 4902, H =    0},
		["灼熱峽谷"]							= {X =  774, A = 4910, H = 4910},
		["銀松森林"]							= {X =  769, A =    0, H = 4894},
		["悲傷沼澤"]							= {X =  782, A = 4904, H = 4904},
		["荊棘谷海角"]						= {X = 4995, A = 4905, H = 4905},
		["辛特蘭"]							= {X =  773, A = 4897, H = 4897},
		["提里斯法林地"]						= {X =  768, A =    0, H =    0},
		["西瘟疫之地"]						= {X =  770, A = 4893, H = 4893},
		["西部荒野"]							= {X =  802, A = 4903, H =    0},
		["濕地"]							= {X =  841, A = 4899, H =    0},
		-- Kalimdor
		["梣谷"]							= {X =  845, A = 4925, H = 4976},
		["艾薩拉"]							= {X =  852, A =    0, H = 4927},
		["藍謎島"]							= {X =  860, A =    0, H =    0},
		["血謎島"]							= {X =  861, A = 4926, H = 4926},
		["黑海岸"]							= {X =  844, A = 4928, H = 4928},
		["淒涼之地"]							= {X =  848, A = 4930, H = 4930},
		["杜洛塔"]							= {X =  728, A =    0, H =    0},
		["塵泥沼澤"]							= {X =  850, A = 4929, H = 4978},
		["費伍德森林"]						= {X =  853, A = 4931, H = 4931},
		["菲拉斯"]							= {X =  849, A = 4932, H = 4979},
		["月光林地"]							= {X =  855, A =    0, H =    0},
		["莫高雷"]							= {X =  736, A =    0, H =    0},
		["北貧瘠之地"]						= {X =  750, A =    0, H = 4933},
		["希利蘇斯"]							= {X =  856, A = 4934, H = 4934},
		["南貧瘠之地"]						= {X = 4996, A = 4937, H = 4981},
		["石爪山脈"]							= {X =  847, A = 4936, H = 4980},
		["塔納利斯"]							= {X =  851, A = 4935, H = 4935},
		["泰達希爾"]							= {X =  842, A =    0, H =    0},
		["千針石林"]							= {X =  846, A = 4938, H = 4938},
		["安戈洛環形山"]						= {X =  854, A = 4939, H = 4939},
		["冬泉谷"]							= {X =  857, A = 4940, H = 4940},
		-- Outland
		["劍刃山脈"]							= {X =  865, A = 1193, H = 1193},
		["地獄火半島"]						= {X =  862, A = 1189, H = 1271},
		["納葛蘭"]							= {X =  866, A = 1192, H = 1273},
		["虛空風暴"]							= {X =  843, A = 1194, H = 1194},
		["影月谷"]							= {X =  864, A = 1195, H = 1195},
		["泰洛卡森林"]						= {X =  867, A = 1191, H = 1272},
		["贊格沼澤"]							= {X =  863, A = 1190, H = 1190},
		-- Northrend
		["北風凍原"]							= {X = 1264, A =   33, H = 1358},
		["水晶之歌森林"]						= {X = 1457, A =    0, H =    0},
		["龍骨荒野"]							= {X = 1265, A =   35, H = 1356},
		["灰白之丘"]							= {X = 1266, A =   37, H = 1357},
		["凜風峽灣"]							= {X = 1263, A =   34, H = 1356},
		["寒冰皇冠"]							= {X = 1270, A =   40, H =   40},
		["休拉薩盆地"]						= {X = 1268, A =   39, H =   39},
		["風暴群山"]							= {X = 1269, A =   38, H =   38},
		["祖爾德拉克"]						= {X = 1267, A =   36, H =   36},
		-- Cataclysm
		["地深之源"]							= {X = 4864, A = 4871, H = 4871},
		["海加爾山"]							= {X = 4863, A = 4870, H = 4870},
		["暮光高地"]							= {X = 4866, A = 4873, H = 5501},
		["奧丹姆"]							= {X = 4865, A = 4872, H = 4872},
		["瓦許伊爾"]							= {X = 4825, A = 4869, H = 4982},
		["托巴拉德"]							= {X =    0, A = 4874, H = 4874},
		["托巴拉德半島"]						= {X =    0, A = 4874, H = 4874},
		-- Pandaria
		["翠玉林"]							= {X = 6351, A = 6300, H = 6534},
		["四風峽"]							= {X = 6969, A = 6301, H = 6301},
		["崑萊峰"]							= {X = 6976, A = 6537, H = 6538},
		["螳螂荒原"]							= {X = 6977, A = 6539, H = 6539},
		["悚然荒野"]							= {X = 6978, A = 6540, H = 6540},
		["恆春谷"]							= {X = 6979, A =    0, H =    0},
		-- Boolean Explores
		["奎爾達納斯之島"]					= {X =  868, A =    0, H =    0},
		["安其拉: 沒落的王朝"]				= {X =    0, A =    0, H =    0},
		["冬握湖"]							= {X =    0, A =    0, H =    0},
	}
else
	L_ZONE_WINTERGRASP = "Wintergrasp"
	L_ZONE_TOLBARAD = "Tol Barad"
	L_ZONE_TOLBARADPEN = "Tol Barad Peninsula"
	L_ZONE_ARATHIBASIN = "Arathi Basin"
	L_ZONE_GILNEAS = "The Battle for Gilneas"
	datebase = {
		["Eastern Kingdoms"]				= {X =   42, A =    0, H =    0},
		["Kalimdor"]						= {X =   43, A =    0, H =    0},
		["Outland"]							= {X =   44, A =    0, H =    0},
		["Northrend"]						= {X =   45, A =    0, H =    0},
		["Pandaria"]						= {X = 6974, A =    0, H =    0},
		["World Map"]						= {X =  nil, A =    0, H =    0},
		-- Eastern Kingdoms
		["Arathi Highlands"]				= {X =  761, A = 4896, H = 4896},
		["Badlands"]						= {X =  765, A = 4900, H = 4900},
		["Blasted Lands"]					= {X =  766, A = 4909, H = 4909},
		["Burning Steppes"]					= {X =  775, A = 4901, H = 4901},
		["Deadwind Pass"]					= {X =  777, A =    0, H =    0},
		["Dun Morogh"]						= {X =  627, A =    0, H =    0},
		["Duskwood"]						= {X =  778, A = 4903, H =    0},
		["Eastern Plaguelands"]				= {X =  771, A = 4892, H = 4892},
		["Elwynn Forest"]					= {X =  776, A =    0, H =    0},
		["Eversong Woods"]					= {X =  859, A =    0, H =    0},
		["Ghostlands"]						= {X =  858, A =    0, H = 4908},
		["Hillsbrad Foothills"]				= {X =  772, A =    0, H = 4895},
		["Loch Modan"]						= {X =  779, A = 4899, H =    0},
		["Northern Stranglethorn"]			= {X =  781, A = 4906, H = 4906},
		["Redridge Mountains"]				= {X =  780, A = 4902, H =    0},
		["Searing Gorge"]					= {X =  774, A = 4910, H = 4910},
		["Silverpine Forest"]				= {X =  769, A =    0, H = 4894},
		["Swamp of Sorrows"]				= {X =  782, A = 4904, H = 4904},
		["The Cape of Stranglethorn"]		= {X = 4995, A = 4905, H = 4905},
		["The Hinterlands"]					= {X =  773, A = 4897, H = 4897},
		["Tirisfal Glades"]					= {X =  768, A =    0, H =    0},
		["Western Plaguelands"]				= {X =  770, A = 4893, H = 4893},
		["Westfall"]						= {X =  802, A = 4903, H =    0},
		["Wetlands"]						= {X =  841, A = 4899, H =    0},
		-- Kalimdor
		["Ashenvale"]						= {X =  845, A = 4925, H = 4976},
		["Azshara"]							= {X =  852, A =    0, H = 4927},
		["Azuremyst Isle"]					= {X =  860, A =    0, H =    0},
		["Bloodmyst Isle"]					= {X =  861, A = 4926, H = 4926},
		["Darkshore"]						= {X =  844, A = 4928, H = 4928},
		["Desolace"]						= {X =  848, A = 4930, H = 4930},
		["Durotar"]							= {X =  728, A =    0, H =    0},
		["Dustwallow Marsh"]				= {X =  850, A = 4929, H = 4978},
		["Felwood"]							= {X =  853, A = 4931, H = 4931},
		["Feralas"]							= {X =  849, A = 4932, H = 4979},
		["Moonglade"]						= {X =  855, A =    0, H =    0},
		["Mulgore"]							= {X =  736, A =    0, H =    0},
		["Northern Barrens"]				= {X =  750, A =    0, H = 4933},
		["Silithus"]						= {X =  856, A = 4934, H = 4934},
		["Southern Barrens"]				= {X = 4996, A = 4937, H = 4981},
		["Stonetalon Mountains"]			= {X =  847, A = 4936, H = 4980},
		["Tanaris"]							= {X =  851, A = 4935, H = 4935},
		["Teldrassil"]						= {X =  842, A =    0, H =    0},
		["Thousand Needles"]				= {X =  846, A = 4938, H = 4938},
		["Un'Goro Crater"]					= {X =  854, A = 4939, H = 4939},
		["Winterspring"]					= {X =  857, A = 4940, H = 4940},
		-- Outland
		["Blade's Edge Mountains"]			= {X =  865, A = 1193, H = 1193},
		["Hellfire Peninsula"]				= {X =  862, A = 1189, H = 1271},
		["Nagrand"]							= {X =  866, A = 1192, H = 1273},
		["Netherstorm"]						= {X =  843, A = 1194, H = 1194},
		["Shadowmoon Valley"]				= {X =  864, A = 1195, H = 1195},
		["Terokkar Forest"]					= {X =  867, A = 1191, H = 1272},
		["Zangarmarsh"]						= {X =  863, A = 1190, H = 1190},
		-- Northrend
		["Borean Tundra"]					= {X = 1264, A =   33, H = 1358},
		["Crystalsong Forest"]				= {X = 1457, A =    0, H =    0},
		["Dragonblight"]					= {X = 1265, A =   35, H = 1356},
		["Grizzly Hills"]					= {X = 1266, A =   37, H = 1357},
		["Howling Fjord"]					= {X = 1263, A =   34, H = 1356},
		["Icecrown"]						= {X = 1270, A =   40, H =   40},
		["Sholazar Basin"]					= {X = 1268, A =   39, H =   39},
		["The Storm Peaks"]					= {X = 1269, A =   38, H =   38},
		["Zul'Drak"]						= {X = 1267, A =   36, H =   36},
		-- Cataclysm
		["Deepholm"]						= {X = 4864, A = 4871, H = 4871},
		["Mount Hyjal"]						= {X = 4863, A = 4870, H = 4870},
		["Twilight Highlands"]				= {X = 4866, A = 4873, H = 5501},
		["Uldum"]							= {X = 4865, A = 4872, H = 4872},
		["Vashj'ir"]						= {X = 4825, A = 4869, H = 4982},
		["Tol Barad"]						= {X =    0, A = 4874, H = 4874},
		["Tol Barad Peninsula"]				= {X =    0, A = 4874, H = 4874},
		-- Pandaria
		["The Jade Forest"]					= {X = 6351, A = 6300, H = 6534},
		["Valley of the Four Winds"]		= {X = 6969, A = 6301, H = 6301},
		["Kun-Lai Summit"]					= {X = 6976, A = 6537, H = 6538},
		["Townlong Steppes"]				= {X = 6977, A = 6539, H = 6539},
		["Dread Wastes"]					= {X = 6978, A = 6540, H = 6540},
		["Vale of Eternal Blossoms"]		= {X = 6979, A =    0, H =    0},
		-- Boolean Explores
		["Isle of Quel'Danas"]				= {X =  868, A =    0, H =    0},
		["Ahn'Qiraj: The Fallen Kingdom"]	= {X =    0, A =    0, H =    0},
		["Wintergrasp"]						= {X =    0, A =    0, H =    0},
	}
end

local function GetInfo(mapName)
	if datebase[mapName] == nil then
		return nil, nil
	end
	local explore = datebase[mapName].X
	if FACTION == "Alliance" then
		quest = datebase[mapName].A
	else
		quest = datebase[mapName].H
	end
	if explore == -1 or explore == nil then
		-- World map stuff
		return nil, nil
	end
	-- Zone exploration info gathering
	local completed = 0
	local total = GetAchievementNumCriteria(explore)
	if explore == 0 then
		exploreCompletion = nil
	else
		if total == 0 then
			_, _, isComplete = GetAchievementInfo(explore)
			total = 1
			if isComplete then
				completed = 1
			end
		else
			for x = 1, total do
				_, _, isComplete = GetAchievementCriteriaInfo(explore, x)
				if isComplete then
					completed = completed + 1
				end
			end
		end
		percentage = string.format("%d", (completed / total * 100))
		exploreCompletion = L["探索"]..percentage.."%"
	end
	-- Zone quest info gathering
	if quest == 0 then
		questCompletion = nil
	else
		_, _, _, questsDone, questsNeeded = GetAchievementCriteriaInfo(quest, 1)
		percentage = string.format("%d", (questsDone / questsNeeded * 100))
		if mapName == L_ZONE_TOLBARAD or mapName == L_ZONE_TOLBARADPEN then
			qHeader = DAILY..": "
		else
			qHeader = QUESTS_LABEL..": "
		end
		if questsDone == questsNeeded then
			questCompletion = qHeader.."100%"
		else
			questCompletion = qHeader..questsDone.."/"..questsNeeded.." ("..percentage.."%)"
		end
	end
	return exploreCompletion, questCompletion
end

-- Hijack World Map Name Update
function WorldMapFrame_SetMapName()
	local mapName = WORLD_MAP
	if WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
		local zoneId = UIDropDownMenu_GetSelectedID(WorldMapZoneDropDown)
		-- zoneId is nil for instances, Azeroth, or the cosmic view, in which case we'll keep the "WorldMap" title
		if zoneId then
			if zoneId > 0 then
				mapName = UIDropDownMenu_GetText(WorldMapZoneDropDown)
			elseif UIDropDownMenu_GetSelectedID(WorldMapContinentDropDown) > 0 then
				mapName = UIDropDownMenu_GetText(WorldMapContinentDropDown)
			end
		end
	end
	exploreCompletion, questCompletion = GetInfo(mapName)
	if exploreCompletion ~= nil then
		mapName = mapName..": "..exploreCompletion
	end
	if questCompletion ~= nil then
		mapName = mapName..", "..questCompletion
	end
	WorldMapFrameTitle:SetText(mapName)
end

local function XLM_UD(self, elapsed)
	local x, y = GetCursorPosition()
	x = x / WorldMapButton:GetEffectiveScale()
	y = y / WorldMapButton:GetEffectiveScale()

	local centerX, centerY = WorldMapButton:GetCenter()
	local width = WorldMapButton:GetWidth()
	local height = WorldMapButton:GetHeight()
	adjustedY = (centerY + (height / 2) - y) / height
	adjustedX = (x - (centerX - (width / 2))) / width

	local name, fileName
	if WorldMapButton:IsMouseOver() and WorldMapFrame:IsShown() then
		name, fileName = UpdateMapHighlight(adjustedX, adjustedY)
		if name ~= nil then
			local w, h
			w, h = GameTooltip:GetSize()
			GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
			GameTooltip:ClearAllPoints()
			local x, y = GetCursorPosition()
			x = x / UIParent:GetEffectiveScale()
			y = y / UIParent:GetEffectiveScale()
			GameTooltip:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x + 20 , y - 20)
			GameTooltip:SetText(name)
			line1, line2 = GetInfo(name)
			GameTooltip:AddLine(line1)
			GameTooltip:AddLine(line2)
			GameTooltip:Show()
		else
			GameTooltip:Hide()
		end
		GameTooltip:FadeOut()
	end

	if fileName then
		WorldMapHighlight:SetDesaturated(true)
		if line1 ~= nil then
			loc = tonumber(string.sub(line1, 10, (string.find(line1, "%%") - 1)))
			if loc == nil then return end
			if loc == 100 then
				WorldMapHighlight:SetVertexColor(0, 1, 0, 1)
			elseif loc == 0 then
				WorldMapHighlight:SetVertexColor(1, 0, 0, 1)
			else
				WorldMapHighlight:SetVertexColor(1, 1, 0, 1)
			end
		else
			WorldMapHighlight:SetVertexColor(1, 1, 1)
		end
	else
		WorldMapHighlight:Hide()
	end
end

local ExpLoreMasterFrame = CreateFrame("Frame")
ExpLoreMasterFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ExpLoreMasterFrame:SetScript("OnUpdate", function(self, event, elapsed)
	if event == "ZONE_CHANGED_NEW_AREA" then
		SetMapToCurrentZone()
	end
	XLM_UD(self, elapsed)
end)