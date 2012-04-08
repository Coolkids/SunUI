local ADDON_NAME, ns = ...

local L = ns.Locale

local mediapath = "Interface\\AddOns\\oUF_Freebgrid\\media\\"
ns.media = {
	indicator = mediapath.."squares.ttf",
	symbols = mediapath.."PIZZADUDEBULLETS.ttf",
}

ns.db = {}
ns.general = {}

if GetLocale() == "zhCN" then
	STANDARD_TEXT_FONT = [[Fonts\ZYKai_T.ttf]]
elseif GetLocale() == "zhTW" then
	STANDARD_TEXT_FONT = [[Fonts\bLEI00D.ttf]]
end

ns.defaults = {
    scale = 1.0,
    width = 78,
    height = 42,
    texture = "gradient",
    texturePath = mediapath.."gradient",   
    fontPath = STANDARD_TEXT_FONT,
    font = L.defaultfont,
    fontsize = 12,
    fontsizeEdge = 11,
    outline = "OUTLINE",
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
    growth = "DOWN",
    petgrowth = "DOWN",
    MTgrowth = "DOWN",
	GCD = true,
    reversecolors = true,
    definecolors = false,
    powerbar = true,
    onlymana = true,
    powerbarsize = .08,
    outsideRange = .40,
    arrow = true,
    arrowscale = 1.0,
    arrowmouseover = true,
    rangeIsNotConnected = true,
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
    indicatorsize = 8,
    symbolsize = 18,
    leadersize = 12,
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
    dispel = "BORDER",	--可驱散debuff显示方式,"ICON" = "只显示图标","BORDER"= "图标+边框显示"
    fborder = false,
    afk = false,
    highlight = true,
    powerclass = false,
    tooltip = true,
    smooth = true,
    altpower = true,

    hidemenu = true,
	Resurrection = true,
	hideblzraid = true,

	Freebgridomf2Char = {
		["Defaults"] ={
			["oUF_FreebgridPetFrame"] = "LEFTUIParent2500",
			["oUF_FreebgridRaidFrame"] = "LEFTUIParent80",
			["oUF_FreebgridMTFrame"] = "TOPLEFTUIParent8-60",
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

function ns:LoadPlayerData()		
	ns.general.class = select(2, UnitClass("player"))
	ns.general.playername = UnitName("player")
	ns.general.isHealer = self:IsHealer()
	ns.general.realmname = GetRealmName()
	ns.general.playerDBKey = ns.general.playername.." - "..ns.general.realmname
	ns.general.MapID = self:GetMapID()
	ns.general.dispellist = self:GetDispelClass()
	ns.general.TalentSpec, ns.general.TalentGroup, ns.general.TalentGroupName = self:GetTalentSpec()
end	
	
function ns:InitDB()
	_G[ADDON_NAME.."DB"] = _G[ADDON_NAME.."DB"] or {}	
	
	ns:LoadPlayerData()

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
	
	if ns.general.TalentSpec == 0 or DB.profileKeys[G.playerDBKey].dualspec then
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
	
	if ns.general.TalentSpec == 0 or DB.profileKeys[G.playerDBKey].dualspec then
		ns.general.Profilename = DB.profileKeys[G.playerDBKey].profile.dual
	else
		ns.general.Profilename = DB.profileKeys[G.playerDBKey].profile[tostring(ns.general.TalentGroup)]
	end

	ns.db = _G[ADDON_NAME.."DB"].profiles[ns.general.Profilename]
	ns:CopyDefaults(ns.db, ns.defaults)
end

function ns:FlushDB(key)
	local name = key or ns.general.Profilename
	
	removeDefaults(ns.defaults, _G[ADDON_NAME.."DB"].profiles[name])
end



