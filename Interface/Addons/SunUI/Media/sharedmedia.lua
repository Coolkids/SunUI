local LSM = LibStub("LibSharedMedia-3.0")

if LSM == nil then return end

LSM:Register("statusbar","SunUI Normal", [[Interface\AddOns\SunUI\media\statusbar.tga]])
LSM:Register("statusbar","SunUI Blank", [[Interface\BUTTONS\WHITE8X8]])
LSM:Register("statusbar","SunUI Gloss", [[Interface\AddOns\SunUI\media\gloss.tga]])
LSM:Register("border", "SunUI GlowBorder", [[Interface\AddOns\SunUI\media\glowTex.tga]])
if GetLocale() == "zhCN" then
	LSM:Register("font","SunUI Font", [[Fonts\ARKai_T.ttf]], 255)
	LSM:Register("font","SunUI Combat", [[Fonts\ARKai_C.ttf]], 255)
elseif GetLocale() == "zhTW" then
	LSM:Register("font","SunUI Font", [[Fonts\bLEI00D.ttf]], 255)
	LSM:Register("font","SunUI Combat", [[Fonts\bKAI00M.ttf]], 255)
end
LSM:Register("font","SunUI Pixel", [[Interface\AddOns\SunUI\media\pixel.ttf]], 255)
LSM:Register("font","SunUI Roadway", [[Interface\AddOns\SunUI\media\ROADWAY.ttf]], 255)
