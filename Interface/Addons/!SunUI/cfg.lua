local S, _, _, DB = unpack(select(2, ...))


--全局设置
local Media = "Interface\\Addons\\!SunUI\\media\\"
DB.dummy = function() return end
DB.zone = GetLocale()
DB.level = UnitLevel("player")
DB.myrealm = GetRealmName()
DB.MyClass = select(2, UnitClass("player"))
DB.PlayerName, _ = UnitName("player")
DB.MyClassColor = RAID_CLASS_COLORS[DB.MyClass]
DB.Font = ChatFrame1:GetFont()
DB.Solid = Media.."solid"
DB.Button = Media.."Button"
DB.GlowTex = Media.."glowTex"
DB.Statusbar = Media.."Statusbar7"
DB.bordertex =	Media.."icon_clean"	
DB.closebtex =	Media.."black-close"
DB.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
DB.edgetex = 	"Interface\\Tooltips\\UI-Tooltip-Border"
DB.loottex =		"Interface\\QuestFrame\\UI-QuestLogTitleHighlight"
DB.aurobackdrop = "Interface\\ChatFrame\\ChatFrameBackground"
DB.bfont = Media.."ROADWAY.ttf"
DB.onepx = "Interface\\Buttons\\WHITE8x8"
DB.Warning = Media.."Warning.mp3"

-- 聊天设置
DB.AutoApply = false									--聊天设置锁定		
DB.def_position = {"BOTTOMLEFT",UIParent,"BOTTOMLEFT",20,30} -- Chat Frame position
DB.chat_height = 230
DB.chat_width = 440
DB.fontsize = 10                          --other variables
DB.eb_point = {"BOTTOM", -200, 180}		-- Editbox position
DB.eb_width = 400						-- Editbox width
DB.tscol = "64C2F5"						-- Timestamp coloring
DB.TimeStampsCopy = true					-- 时间戳

--Loot 
 DB.iconsize = 28 					-- 图标大小

 
--仇恨条
DB.OpenThreat = true
DB.ArrowT = Media.."ArrowT"
DB.Arrow = Media.."Arrow"
--动作条

DB.bars = {
    bar1 = {     
	    uselayout2x6    = false,
		showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      testmode        = false,
    },
    bar2 = {
      uselayout2x6    = false,
      showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      testmode        = false,
    },
    bar3 = {
      uselayout2x6    = false,
      showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      testmode        = false,
    },
    bar4 = {
      showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      testmode        = false,
    },
    bar5 = {
      showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      testmode        = false,
    },

    stancebar = {
      showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      testmode        = false,
      disable         = false,
    },
    petbar = {
      showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      testmode        = false,
      disable         = false,
    },

    extrabar = {
      userplaced      = true,
      locked          = true,
      testmode        = false,
      disable         = false,
    },
    micromenu = {
      showonmouseover = true,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      testmode        = false,
      disable         = true,
    },
    bags = {
      showonmouseover = true,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      testmode        = false,
      disable         = true,
    },
    totembar = {
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked 
      testmode        = false,
      disable         = false,
    },
    vehicleexit = {
      userplaced      =true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      testmode        = false,
    },
  }
 
--旧版动作条美化
local ActionBarMedia = "Interface\\AddOns\\!SunUI\\Media\\ActionBar\\"
 DB.textures = {
    normal            = ActionBarMedia.."gloss",
    flash             = ActionBarMedia.."flash",
    hover             = ActionBarMedia.."hover",
    pushed            = ActionBarMedia.."gloss",
    checked           = ActionBarMedia.."checked",
    equipped          = ActionBarMedia.."gloss",
    buttonback        = ActionBarMedia.."button_background",
    buttonbackflat    = ActionBarMedia.."button_background_flat",
    outer_shadow      = ActionBarMedia.."outer_shadow",
  }

  DB.background = {
    showbg            = false,  --show an background image?
    showshadow        = true,   --show an outer shadow?
    useflatbackground = false,  --true uses plain flat color instead
    backgroundcolor   = { r = 0.3, g = 0.3, b = 0.3, a = 0.7},
    shadowcolor       = { r = 0, g = 0, b = 0, a = 0.9},
    classcolored      = false,
    inset             = 5, 
  }
  
  DB.color = {
    normal            = { r = 0.37, g = 0.3, b = 0.3, },
    equipped          = { r = 0.1, g = 0.5, b = 0.1, },
    classcolored      = false,
  }
  
  DB.hotkeys = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "TOPRIGHT", x = 0, y = 0 }, 
    pos2             = { a1 = "TOPLEFT", x = 0, y = 0 }, --important! two points are needed to make the hotkeyname be inside of the button
  }
  
  DB.macroname = {
    show            = true,
    fontsize        = 10,
    pos1             = { a1 = "BOTTOMLEFT", x = 0, y = 0 }, 
    pos2             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 }, --important! two points are needed to make the macroname be inside of the button
  }
  
  DB.itemcount = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 }, 
  }
  
  DB.cooldown = {
    spacing         = 0,
  }
  
---mini功能
DB.combatpointOpen = true --盗贼连击点显示
DB.Ratings = true  --装备属性转换

--暗影魔計時
DB.ShadowPetOpen = true
-- 头像
DB.playerauras = "DEBUFFS"  		-- small aura frame for player, available options: "BUFFS", "DEBUFFS", "AURAS", "NONE"
DB.EnableCombatFeedback = false	-- enables CombatFeedback on player and target unit frames

--Advanced_UseUIScale:Hide()
--Advanced_UIScaleSlider:Hide()
DB.colors = {
	power = {
		["MANA"] = {0.31, 0.45, 0.63},
	},
	reaction = {
		[1] = { .7, .2, .1 }, -- Hated
		[4] = { 1, .8, 0 }, -- Neutral
		[5] = { .2, .6, .1 }, -- Friendly
	},
	class = {
		["DEATHKNIGHT"] = { 196/255,  30/255,  60/255 },
		["DRUID"]       = { 255/255, 125/255,  10/255 },
		["HUNTER"]      = { 171/255, 214/255, 116/255 },
		["MAGE"]        = { 104/255, 205/255, 255/255 },
		["PALADIN"]     = { 245/255, 140/255, 186/255 },
		["PRIEST"]      = { 212/255, 212/255, 212/255 },
		["ROGUE"]       = { 255/255, 243/255,  82/255 },
		["SHAMAN"]      = {  41/255,  79/255, 155/255 },
		["WARLOCK"]     = { 148/255, 130/255, 201/255 },
		["WARRIOR"]     = { 199/255, 156/255, 110/255 },
	},
}

local Launch = CreateFrame("Frame")
Launch:RegisterEvent("PLAYER_ENTERING_WORLD")
Launch:SetScript("OnEvent", function(self, event)
	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			for _, v in pairs({GetAddOnInfo(i)}) do
				if v and type(v) == 'string' and (v:lower():find("BigFoot") or v:lower():find("Duowan") or v:lower():find("163UI") or v:lower():find("FishUI") or v:lower():find("大脚") or v:lower():find("大腳") or v:lower():find("多玩")) then
					DB.Nuke = true else DB.Nuke = false  
				end
			end
		end
		if IsAddOnLoaded(i) then
			for _, v in pairs({GetAddOnInfo(i)}) do
				if v and type(v) == 'string' and (v:lower():find("RatingBuster")) then
					DB.Ratings = false 
				end
			end
		end
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD" )
end)