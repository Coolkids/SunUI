local addon, engine = ...
engine[1] = {} -- S, functions, constants, variables
engine[2] = {} -- L, localization
engine[3] = {} -- DB

SunUI = engine
local SunUI = LibStub("AceAddon-3.0"):NewAddon("SunUI")
local S, L, DB, _, C = unpack(select(2, ...))
local _G =_G
MoveHandle = {}
--全局设置
local Media = "Interface\\Addons\\SunUI\\media\\"
DB.dummy = function() return end
DB.zone = GetLocale()
DB.level = UnitLevel("player")
DB.MyClass = select(2, UnitClass("player"))
DB.PlayerName = select(1, UnitName("player"))
if CUSTOM_CLASS_COLORS then
	DB.MyClassColor = CUSTOM_CLASS_COLORS[DB.MyClass]
else
	DB.MyClassColor = RAID_CLASS_COLORS[DB.MyClass]
end
DB.Font = GameFontNormal:GetFont()
DB.Solid = Media.."solid"
DB.Button = Media.."Button"
DB.GlowTex = Media.."glowTex"
DB.Statusbar2 = Media.."statusbars\\statusbar7"
DB.Statusbar = "Interface\\Buttons\\WHITE8x8" --Media.."dM3"
DB.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
DB.edgetex = 	"Interface\\Tooltips\\UI-Tooltip-Border"
DB.aurobackdrop = "Interface\\ChatFrame\\ChatFrameBackground"
DB.onepx = "Interface\\Buttons\\WHITE8x8"
DB.Warning = Media.."Warning.mp3"
DB.MyRealm = GetRealmName()
DB.FontSize = select(2, GameFontNormal:GetFont())


local players = {
	["Cooikid"] = true,
	["Coolkid"] = true,
	["Coolkids"] = true,
	["Coolkid"] = true,
	["Kenans"] = true,
	["月殤軒"] = true,
	["月殤玄"] = true,
	["月殤妶"] = true,
	["月殤玹"] = true,
	["月殤旋"] = true,
	["月殤璇"] = true,
}
function S.IsCoolkid()
	if players[DB.PlayerName] == true then 
		return true 
	else	
		return false	
	end
end
