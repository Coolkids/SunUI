local S, _, _, DB = unpack(select(2, ...))


--全局设置
local Media = "Interface\\Addons\\!SunUI\\media\\"
DB.dummy = function() return end
DB.zone = GetLocale()
DB.level = UnitLevel("player")
--DB.myrealm = GetRealmName()
DB.MyClass = select(2, UnitClass("player"))
DB.PlayerName, _ = UnitName("player")
DB.MyClassColor = RAID_CLASS_COLORS[DB.MyClass]
DB.Font = ChatFrame1:GetFont()
DB.Solid = Media.."solid"
DB.Button = Media.."Button"
DB.GlowTex = Media.."glowTex"
DB.Statusbar = Media.."Statusbar7"
DB.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
DB.edgetex = 	"Interface\\Tooltips\\UI-Tooltip-Border"
--DB.aurobackdrop = "Interface\\ChatFrame\\ChatFrameBackground"
--DB.bfont = Media.."ROADWAY.ttf"
DB.onepx = "Interface\\Buttons\\WHITE8x8"
DB.Warning = Media.."Warning.mp3"

--Advanced_UseUIScale:Hide()
--Advanced_UIScaleSlider:Hide()


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
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD" )
end)