local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = LibStub("LibSharedMedia-3.0")

P["media"]={
	font = "SunUI Font",
	dmgfont = "SunUI Combat",
	fontsize = 12,
	fontflag = "THINOUTLINE",
	gloss = "SunUI Gloss",
	blank = "SunUI Blank",
	normal = "SunUI Normal",
	cdfont = "SunUI Roadway",
	pxfont = "SunUI PIXEL",
	glow = "SunUI GlowBorder",
	backdropcolor = { .1, .1, .1 },
	backdropfadecolor = { .04, .04, .04, .7 },
	bordercolor = { 0, 0, 0 },
}
P["media"].blank = LSM:Fetch("statusbar", P["media"].blank)
P["media"].normal = LSM:Fetch("statusbar", P["media"].normal)
P["media"].gloss = LSM:Fetch("statusbar", P["media"].gloss)
P["media"].glow = LSM:Fetch("border", P["media"].glow)

--Border Color
P["media"].bordercolor = P["media"].bordercolor

--Backdrop Color
P["media"].backdropcolor = P["media"].backdropcolor
P["media"].backdropfadecolor = P["media"].backdropfadecolor


P["media"].font = LSM:Fetch("font", P["media"].font)
P["general"].bordercolor = { r = 0.1,g = 0.1,b = 0.1 }
P["general"].backdropcolor = { r = 0.1,g = 0.1,b = 0.1 }
P["general"].backdropfadecolor = { r = .06,g = .06,b = .06, a = 0.8 }   --调整底部透明度
P["general"].valuecolor = {r = 23/255,g = 132/255,b = 209/255}
P['general'].bottomPanel = false
P["tooltip"].cursorAnchor = true

V["general"].normTex = "SunUI Normal"
V["general"].glossTex = "SunUI Normal"

P['unitframe'].statusbar = "SunUI Normal"
P['unitframe'].font = 'SunUI Font'
P['unitframe'].fontSize = 12
P['unitframe'].fontOutline = 'OUTLINE'

P["actionbar"].font = 'SunUI Font'
P["actionbar"].fontSize = 10
P["actionbar"].fontOutline = 'OUTLINE'


P['tooltip'].font = "SunUI Font"
P['tooltip'].fontOutline = "NONE"
P['tooltip'].headerFontSize = 14
P['tooltip'].textFontSize = 14
P['tooltip'].smallTextFontSize = 12
P['tooltip'].healthBar.text = true
P['tooltip'].healthBar.height = 7
P['tooltip'].healthBar.font = 'SunUI Font'
P['tooltip'].healthBar.fontSize = 10

P['chat'].font = 'SunUI Font'
P['chat'].fontSize = 12
P['chat'].fontOutline = 'NONE'
P['chat'].editBoxPosition = 'ABOVE_CHAT'

P['datatexts'].font = 'SunUI Font'
P['datatexts'].fontSize = 12
P['datatexts'].fontOutline = 'NONE'

P['auras'].font = 'SunUI Font'
P['auras'].fontSize = 10
P['auras'].fontOutline = 'OUTLINE'

P["nameplates"].statusbar = "ElvUI Norm"
P["nameplates"].font = 'SunUI Font'
P["nameplates"].fontSize = 8
P["nameplates"].fontOutline = 'OUTLINE'

P['bags'].itemLevelFont = 'SunUI Font'
P['bags'].itemLevelFontOutline = "OUTLINE"
P['bags'].countFont = 'SunUI Font'
P['bags'].countFontSize = 10
P['bags'].countFontOutline = "OUTLINE"


