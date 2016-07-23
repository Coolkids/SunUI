local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = LibStub("LibSharedMedia-3.0")

local function SetFont(name, font)
  if name then
    name = font
  else
    E:Print("不存在的列", tostring(name))
  end
end

if GetLocale() == "zhCN" then
	LSM:Register("font","SunUI Font", [[Fonts\ARKai_T.ttf]], 255)
	LSM:Register("font","SunUI Combat", [[Fonts\ARKai_C.ttf]], 255)
elseif GetLocale() == "zhTW" then
	LSM:Register("font","SunUI Font", [[Fonts\bLEI00D.ttf]], 255)
	LSM:Register("font","SunUI Combat", [[Fonts\bKAI00M.ttf]], 255)
end

P.general.font = "SunUI Font"
P.nameplates.font = "SunUI Font"
P.auras.font = "SunUI Font"
P.chat.font = "SunUI Font"
P.datatexts.font = "SunUI Font"
P.tooltip.font = "SunUI Font"
P.tooltip.healthBar.font = "SunUI Font"
P.unitframe.font = "SunUI Font"
P.actionbar.font = "SunUI Font"
V.general.dmgfont = "SunUI Font"
V.general.namefont = "SunUI Font"
V.general.chatBubbleFont = "SunUI Font"



