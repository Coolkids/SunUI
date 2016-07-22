local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local LSM = LibStub("LibSharedMedia-3.0")
local Unfit = LibStub("Unfit-1.0")
S["RegisteredModules"] = {}
S.resolution           = ({GetScreenResolutions()})[GetCurrentResolution()] or GetCVar("gxWindowedResolution")
S.screenheight         = tonumber(string.match(S.resolution, "%d+x(%d+)"))
S.screenwidth          = tonumber(string.match(S.resolution, "(%d+)x+%d"))
S.mult                 = 1

S.HiddenFrame = CreateFrame("Frame")
S.HiddenFrame:Hide()

local AddonNotSupported = {}
local demoFrame

S.ItemUpgrade = setmetatable ({
	[1]   = 8,
	[373] = 4,
	[374] = 8,
	[375] = 4,
	[376] = 4,
	[377] = 4,
	[379] = 4,
	[380] = 4,
	[445] = 0,
	[446] = 4,
	[447] = 8,
	[451] = 0,
	[452] = 8,
	[453] = 0,
	[454] = 4,
	[455] = 8,
	[456] = 0,
	[457] = 8,
	[458] = 0,
	[459] = 4,
	[460] = 8,
	[461] = 12,
	[462] = 16,
	[465] = 0,
	[466] = 4,
	[467] = 8,
	[468] = 0,
	[469] = 4,
	[470] = 8,
	[471] = 12,
	[472] = 16,
	[476] = 0,
	[477] = 4,
	[478] = 8,
	[479] = 0,
	[480] = 8,
	[491] = 0,
	[492] = 4,
	[493] = 8,
	[494] = 0,
	[495] = 4,
	[496] = 8,
	[497] = 12,
	[498] = 16,
	[504] = 12,
	[505] = 16,
	[506] = 20,
	[507] = 24, 
	[529] = 0,
	[530] = 5, 
	[531] = 10, 
},{__index=function() return 0 end})

S.DiffIDToString = setmetatable ({
	[1] = "",[2] = "H",[3] = "",[4] = "",[5] = "H",
	[6]  = "H",[7] = "LFR",[8] = "C",[9] = "",[10] = "",
	[11] = "HC",[12] = "C",[13] = "",[14] = "F/N",[15] = "H",
	[16] = "M", [23] = "M", [24] = "T",
	
},{__index=function() return "" end})


function S.dummy()
	return
end

function S:UIScale()
	S.lowversion = false

	if S.screenwidth < 1600 then
		S.lowversion = true
	elseif S.screenwidth >= 3840 or (UIParent:GetWidth() + 1 > S.screenwidth) then
		local width = S.screenwidth
		local height = S.screenheight

		-- because some user enable bezel compensation, we need to find the real width of a single monitor.
		-- I don"t know how it really work, but i"m assuming they add pixel to width to compensate the bezel. :P

		-- HQ resolution
		if width >= 9840 then width = 3280 end                   	                -- WQSXGA
		if width >= 7680 and width < 9840 then width = 2560 end                     -- WQXGA
		if width >= 5760 and width < 7680 then width = 1920 end 	                -- WUXGA & HDTV
		if width >= 5040 and width < 5760 then width = 1680 end 	                -- WSXGA+

		-- adding height condition here to be sure it work with bezel compensation because WSXGA+ and UXGA/HD+ got approx same width
		if width >= 4800 and width < 5760 and height == 900 then width = 1600 end   -- UXGA & HD+

		-- low resolution screen
		if width >= 4320 and width < 4800 then width = 1440 end 	                -- WSXGA
		if width >= 4080 and width < 4320 then width = 1360 end 	                -- WXGA
		if width >= 3840 and width < 4080 then width = 1224 end 	                -- SXGA & SXGA (UVGA) & WXGA & HDTV

		if width < 1600 then
			S.lowversion = true
		end

		-- register a constant, we will need it later for launch.lua
		S.eyefinity = width
	end

	if S.lowversion == true then
		S.ResScale = 0.9
	else
		S.ResScale = 1
	end

	self.mult = 768/string.match(S.resolution, "%d+x(%d+)")/self.global.general.uiscale
end

function S:Scale(x)
	return (self.mult*math.floor(x/self.mult+.5))
end

function S:DoSkill(name)
	for i=1,GetNumTradeSkills()do
		local skillName,skillType,numAvailable=GetTradeSkillInfo(i)
		if skillName and skillName:find(name)and numAvailable>0 then
			DoTradeSkill(i,numAvailable)
			UIErrorsFrame:AddMessage("["..skillName.."]x"..numAvailable, TradeSkillTypeColor[skillType].r, TradeSkillTypeColor[skillType].g, TradeSkillTypeColor[skillType].b)
			break
		end
	end
end

function S:RegisterModule(name)
	if self.initialized then
		self:GetModule(name):Initialize()
		tinsert(self["RegisteredModules"], name)
	else
		tinsert(self["RegisteredModules"], name)
	end
end

function S:TableIsEmpty(t)
	if type(t) ~= "table" then
		return true
	else
		return next(t) == nil
	end
end

function S:GetItemUpgradeLevel(iLink)
	if not iLink then
		return 0
	else
		local _, _, itemRarity, itemLevel, _, _, _, _, itemEquip = GetItemInfo(iLink)
		local code = string.match(iLink, ":(%d+):%d:%d|h")
		if not itemLevel then return 0 end
		return itemLevel + self.ItemUpgrade[tonumber(code)], itemEquip
	end
end

function S:InitializeModules()
	for i = 1, #self["RegisteredModules"] do
		local module = self:GetModule(self["RegisteredModules"][i])
		if (self.db[self["RegisteredModules"][i]] == nil or self.db[self["RegisteredModules"][i]].enable ~= false) and module.Initialize then
			local _, catch = pcall(module.Initialize, module)
			if catch and GetCVarBool("scriptErrors") == 1 then
				if not IsAddOnLoaded("Blizzard_DebugTools") then
					LoadAddOn("Blizzard_DebugTools")
				end
				ScriptErrorsFrame_OnError(catch, false)
			end
		end
	end
end

function S:PLAYER_ENTERING_WORLD()
	RequestTimePlayed()
	Advanced_UIScaleSlider:Kill()
	Advanced_UseUIScale:Kill()
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", S.global.general.uiscale)
	DEFAULT_CHAT_FRAME:AddMessage(L["欢迎使用SunUI"])
	DEFAULT_CHAT_FRAME:AddMessage(L["QQ群"])
	DEFAULT_CHAT_FRAME:AddMessage(L["更新地址"])
	self:UnregisterEvent("PLAYER_ENTERING_WORLD" )

	local eventcount = 0
	local GarbageCollector = CreateFrame("Frame")
	GarbageCollector:RegisterAllEvents()
	GarbageCollector:SetScript("OnEvent", function(self, event, addon)
		if InCombatLockdown() then return end
		eventcount = eventcount + 1
		if eventcount > 6000 or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED"  then
			collectgarbage("collect")
			eventcount = 0
		end
	end)
end
function S:GameMenuFrame_UpdateVisibleButtons()
	_G["GameMenuFrame"]:SetHeight(_G["GameMenuFrame"]:GetHeight()+_G["GameMenuButtonMacros"]:GetHeight()+8);
end
function S:ToggleGameMenu()
end

function S:Initialize()
	self:LoadMovers()
	--TODO 初始化安装地方
	if not self.db.installed then
		self:CreateInstallFrame()
	end

	self:CheckRole()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckRole")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "CheckRole")
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "CheckRole")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", "CheckRole")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", "CheckRole")
	self:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "CheckRole")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:Delay(5, function() collectgarbage("collect") end)

	local configButton = CreateFrame("Button", "SunUIConfigButton", GameMenuFrame, "GameMenuButtonTemplate")
	configButton:SetSize(GameMenuButtonMacros:GetWidth(), GameMenuButtonMacros:GetHeight())
	configButton:SetPoint("BOTTOM" , GameMenuFrame, "BOTTOM", 0, 10)
	configButton:SetText(L["SunUI"])
	configButton:SetScript("OnClick", function()
		HideUIPanel(GameMenuFrame)
		self:OpenConfig()
	end)
	S:SecureHook("GameMenuFrame_UpdateVisibleButtons")

	local A = self:GetModule("Skins")
	A:Reskin(configButton)
end

--Check the player"s role
local roles = {
	PALADIN = {
		[1] = "Caster",
		[2] = "Tank",
		[3] = "Melee",
	},
	PRIEST = "Caster",
	WARLOCK = "Caster",
	WARRIOR = {
		[1] = "Melee",
		[2] = "Melee",
		[3] = "Tank",
	},
	HUNTER = "Melee",
	SHAMAN = {
		[1] = "Caster",
		[2] = "Melee",
		[3] = "Caster",
	},
	ROGUE = "Melee",
	MAGE = "Caster",
	DEATHKNIGHT = {
		[1] = "Tank",
		[2] = "Melee",
		[3] = "Melee",
	},
	DRUID = {
		[1] = "Caster",
		[2] = "Melee",
		[3] = "Tank",
		[4] = "Caster"
	},
	MONK = {
		[1] = "Tank",
		[2] = "Caster",
		[3] = "Melee",
	},
}

local healingClasses = {
	PALADIN = 1,
	SHAMAN = 3,
	DRUID = 4,
	MONK = 2,
	PRIEST = {1, 2}
}

function S:CheckRole()
	local talentTree = GetSpecialization()
	local IsInPvPGear = false;
	local resilperc = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	if resilperc > GetDodgeChance() and resilperc > GetParryChance() and UnitLevel("player") == MAX_PLAYER_LEVEL then
		IsInPvPGear = true;
	end

	self.Role = nil;

	if type(roles[self.myclass]) == "string" then
		self.Role = roles[self.myclass]
	elseif talentTree then
		self.Role = roles[self.myclass][talentTree]
	end

	if self.Role == "Tank" and IsInPvPGear then
		self.Role = "Melee"
	end

	if not self.Role then
		local playerint = select(2, UnitStat("player", 4));
		local playeragi	= select(2, UnitStat("player", 2));
		local base, posBuff, negBuff = UnitAttackPower("player");
		local playerap = base + posBuff + negBuff;

		if (playerap > playerint) or (playeragi > playerint) then
			self.Role = "Melee";
		else
			self.Role = "Caster";
		end
	end

	if healingClasses[self.myclass] then
		local tree = healingClasses[self.myclass]
		if type(tree) == "number" then
			if talentTree == tree then
				self.isHealer = true
				return
			end
		elseif type(tree) == "table" then
			for _, index in pairs(tree) do
				if index == talentTree then
					self.isHealer = true
					return
				end
			end
		end
	end
	self.isHealer = false
end

local tmp={}
function S:Print(...)
	local n=0
	for i=1, select("#", ...) do
		n=n+1
		tmp[n] = tostring(select(i, ...))
	end
	DEFAULT_CHAT_FRAME:AddMessage(L["SunUI"].." "..table.concat(tmp," ",1,n) )
end

function S:Debug(...)
	if not S:IsDeveloper() then return end
	local n=0
	for i=1, select("#", ...) do
		n=n+1
		tmp[n] = tostring(select(i, ...))
	end
	DEFAULT_CHAT_FRAME:AddMessage("|cffff0000debug|r: " .. table.concat(tmp," ",1,n) )
end

function S:ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select("#", ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end

	local num = select("#", ...) / 3
	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

function S:Round(num, idp)
	if(idp and idp > 0) then
		local mult = 10 ^ idp
		return floor(num * mult + 0.5) / mult
	end
	return floor(num + 0.5)
end

local waitTable = {}
local waitFrame
function S:Delay(delay, func, ...)
	if(type(delay)~="number" or type(func)~="function") then
		return false
	end
	if(waitFrame == nil) then
		waitFrame = CreateFrame("Frame","WaitFrame", UIParent)
		waitFrame:SetScript("onUpdate",function (self,elapse)
			local count = #waitTable
			local i = 1
			while(i<=count) do
				local waitRecord = tremove(waitTable,i)
				local d = tremove(waitRecord,1)
				local f = tremove(waitRecord,1)
				local p = tremove(waitRecord,1)
				if(d>elapse) then
					tinsert(waitTable,i,{d-elapse,f,p})
					i = i + 1
				else
					count = count - 1
					f(unpack(p))
				end
			end
		end)
	end
	tinsert(waitTable,{delay,func,{...}})
	return true
end

function S:RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

function S:ShortValue(v)
	if v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end
--dots true of false
function S:ShortenString(string, numChars, dots)
	local bytes = string:len()
	if (bytes <= numChars) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
				len = len + 1
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
				len = len + 1
			end
			if (len == numChars) then break end
		end

		if (len == numChars and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

function S:GetScreenQuadrant(frame)
	local x, y = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local screenHeight = GetScreenHeight()
	local point

	if not frame:GetCenter() then
		return "UNKNOWN", frame:GetName()
	end

	if (x > (screenWidth / 4) and x < (screenWidth / 4)*3) and y > (screenHeight / 4)*3 then
		point = "TOP"
	elseif x < (screenWidth / 4) and y > (screenHeight / 4)*3 then
		point = "TOPLEFT"
	elseif x > (screenWidth / 4)*3 and y > (screenHeight / 4)*3 then
		point = "TOPRIGHT"
	elseif (x > (screenWidth / 4) and x < (screenWidth / 4)*3) and y < (screenHeight / 4) then
		point = "BOTTOM"
	elseif x < (screenWidth / 4) and y < (screenHeight / 4) then
		point = "BOTTOMLEFT"
	elseif x > (screenWidth / 4)*3 and y < (screenHeight / 4) then
		point = "BOTTOMRIGHT"
	elseif x < (screenWidth / 4) and (y > (screenHeight / 4) and y < (screenHeight / 4)*3) then
		point = "LEFT"
	elseif x > (screenWidth / 4)*3 and y < (screenHeight / 4)*3 and y > (screenHeight / 4) then
		point = "RIGHT"
	else
		point = "CENTER"
	end

	return point
end
--[[
local Unusable

if S.myclass == "DEATHKNIGHT" then
	Unusable = {{3, 4, 10, 11, 13, 14, 15, 16}, {7}}
elseif S.myclass == "DRUID" then
	Unusable = {{1, 2, 3, 4, 8, 9, 14, 15, 16}, {4, 5, 7}, true}
elseif S.myclass == "HUNTER" then
	Unusable = {{5, 6, 16}, {5, 6, 7}}
elseif S.myclass == "MAGE" then
	Unusable = {{1, 2, 3, 4, 5, 6, 7, 9, 11, 14, 15}, {3, 4, 5, 7}, true}
elseif S.myclass == "PALADIN" then
	Unusable = {{3, 4, 10, 11, 13, 14, 15, 16}, {}, true}
elseif S.myclass == "PRIEST" then
	Unusable = {{1, 2, 3, 4, 6, 7, 8, 9, 11, 14, 15}, {3, 4, 5, 7}, true}
elseif S.myclass == "ROGUE" then
	Unusable = {{2, 6, 7, 9, 10, 16}, {4, 5, 6, 7}}
elseif S.myclass == "SHAMAN" then
	Unusable = {{3, 4, 7, 8, 9, 14, 15, 16}, {5}}
elseif S.myclass == "WARLOCK" then
	Unusable = {{1, 2, 3, 4, 5, 6, 7, 9, 11, 14, 15}, {3, 4, 5, 7}, true}
elseif S.myclass == "WARRIOR" then
	Unusable = {{16}, {7}}
elseif S.myclass == "MONK" then
	Unusable = {{2, 3, 4, 6, 9, 13, 14, 15, 16}, {4, 5, 7}}
end

for class = 1, 2 do
	local subs = {GetAuctionItemSubClasses(class)}
	for i, subclass in ipairs(Unusable[class]) do
		if subs[subclass] then
			Unusable[subs[subclass\]\] = true
		end
	end
	Unusable[class] = nil
	subs = nil
end

function S:IsClassUnusable(subclass, slot)
	if subclass then
		return Unusable[subclass] or slot == "INVTYPE_WEAPONOFFHAND" and Unusable[3]
	end
end

function S:IsItemUnusable(...)
	if ... then
		local subclass, _, slot = select(7, GetItemInfo(...))
		return S:IsClassUnusable(subclass, slot)
	end
end
--]]

function S:IsClassUnusable(subclass, slot)
	return Unfit:IsClassUnusable(S.myclass, subclass, slot)
end

function S:IsItemUnusable(...)
	return Unfit:IsClassUnusable(...)
end

function S:AddBlankTabLine(cat, ...)
	local blank = {"blank", true, "fakeChild", true, "noInherit", true}
	local cnt = ... or 1
	for i = 1, cnt do
		cat:AddLine(blank)
	end
end

function S:MakeTabletHeader(col, size, indentation, justifyTable)
	local header = {}
	local colors = {}
	colors = {0.9, 0.8, 0.7}

	for i = 1, #col do
		if ( i == 1 ) then
			header["text"] = col[i]
			header["justify"] = justifyTable[i]
			header["size"] = size
			header["textR"] = colors[1]
			header["textG"] = colors[2]
			header["textB"] = colors[3]
			header["indentation"] = indentation
		else
			header["text"..i] = col[i]
			header["justify"..i] = justifyTable[i]
			header["size"..i] = size
			header["text"..i.."R"] = colors[1]
			header["text"..i.."G"] = colors[2]
			header["text"..i.."B"] = colors[3]
			header["indentation"] = indentation
		end
	end
	return header
end

S["media"] = {}
S["texts"] = {}

function S:UpdateFontTemplates()
	for text, _ in pairs(self["texts"]) do
		if text then
			text:FontTemplate(text.font, text.fontSize, text.fontStyle);
		else
			self["texts"][text] = nil;
		end
	end
end

function S:UpdateMedia()
	--Fonts
	self["media"].font = LSM:Fetch("font", self.global["media"].font)
	self["media"].dmgfont = LSM:Fetch("font", self.global["media"].dmgfont)
	self["media"].pxfont = LSM:Fetch("font", self.global["media"].pxfont)
	self["media"].cdfont = LSM:Fetch("font", self.global["media"].cdfont)
	self["media"].fontsize = self.global["media"].fontsize
	self["media"].fontflag = self.global["media"].fontflag

	--Textures
	self["media"].blank = LSM:Fetch("statusbar", self.global["media"].blank)
	self["media"].normal = LSM:Fetch("statusbar", self.global["media"].normal)
	self["media"].gloss = LSM:Fetch("statusbar", self.global["media"].gloss)
	self["media"].glow = LSM:Fetch("border", self.global["media"].glow)

	--Border Color
	self["media"].bordercolor = self.global["media"].bordercolor

	--Backdrop Color
	self["media"].backdropcolor = self.global["media"].backdropcolor
	self["media"].backdropfadecolor = self.global["media"].backdropfadecolor

	self:UpdateBlizzardFonts()
end

function S:CreateDemoFrame()
	local A = S:GetModule("Skins")
	demoFrame = CreateFrame("Frame", "SunUIDemoFrame", LibStub("AceConfigDialog-3.0").OpenFrames["SunUI"].frame)
	demoFrame:Size(300, 200)
	demoFrame:Point("LEFT", LibStub("AceConfigDialog-3.0").OpenFrames["SunUI"].frame, "RIGHT", 20, 0)
	demoFrame:SetTemplate("Transparent")
	demoFrame.outBorder = CreateFrame("Frame", nil, demoFrame)
	demoFrame.outBorder:SetOutside(demoFrame, 1, 1)
	demoFrame.outBorder:CreateShadow()
	demoFrame.title = demoFrame:CreateFontString(nil, "OVERLAY")
	demoFrame.title:FontTemplate()
	demoFrame.title:SetText("Debug Frame")
	demoFrame.title:Point("TOPLEFT", 10, -5)
	demoFrame.inlineFrame1 = CreateFrame("Frame", nil, demoFrame)
	demoFrame.inlineFrame1:SetFrameLevel(demoFrame:GetFrameLevel() + 1)
	demoFrame.inlineFrame1:Size(150, 150)
	demoFrame.inlineFrame1:Point("TOPLEFT", 10, -30)
	demoFrame.inlineFrame1:SetTemplate("Transparent")
	demoFrame.button1 = CreateFrame("Button", nil, demoFrame, "UIPanelButtonTemplate")
	demoFrame.button1:Point("BOTTOMLEFT", 30, 40)
	demoFrame.button1:SetText("Test")
	demoFrame.button1:Size(100, 20)
	A:Reskin(demoFrame.button1)
	demoFrame.button2 = CreateFrame("Button", nil, demoFrame, "UIPanelButtonTemplate")
	demoFrame.button2:Point("BOTTOMRIGHT", -10, 10)
	demoFrame.button2:SetText("Close")
	demoFrame.button2:Size(100, 20)
	demoFrame.button2:SetScript("OnClick", function() demoFrame:Hide() end)
	A:Reskin(demoFrame.button2)

	tinsert(UISpecialFrames, demoFrame:GetName())
end

function S:UpdateDemoFrame()
	local borderr, borderg, borderb = unpack(S.global.media.bordercolor)
	local backdropr, backdropg, backdropb = unpack(S.global.media.backdropcolor)
	local backdropfader, backdropfadeg, backdropfadeb, backdropfadea = unpack(S.global.media.backdropfadecolor)
	if not demoFrame then
		self:CreateDemoFrame()
	end
	if not demoFrame:IsShown() then
		demoFrame:Show()
	end
	demoFrame:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
	demoFrame:SetBackdropBorderColor(borderr, borderg, borderb)
	demoFrame.outBorder.border:SetBackdropBorderColor(borderr, borderg, borderb)
	demoFrame.inlineFrame1:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
	demoFrame.inlineFrame1:SetBackdropBorderColor(borderr, borderg, borderb)
	demoFrame.button1:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
	demoFrame.button1:SetBackdropBorderColor(borderr, borderg, borderb)
	demoFrame.button1.backdropTexture:SetVertexColor(backdropr, backdropg, backdropb)
	demoFrame.button2:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
	demoFrame.button2:SetBackdropBorderColor(borderr, borderg, borderb)
	demoFrame.button2.backdropTexture:SetVertexColor(backdropr, backdropg, backdropb)
end

local CPU_USAGE = {}
local function CompareCPUDiff(module)
	local greatestUsage, greatestCalls, greatestName
	local greatestDiff = 0
	local mod = S:GetModule(module, true) or S

	for name, oldUsage in pairs(CPU_USAGE) do
		local newUsage, calls = GetFunctionCPUUsage(mod[name], true)
		local differance = newUsage - oldUsage

		if differance > greatestDiff then
			greatestName = name
			greatestUsage = newUsage
			greatestCalls = calls
			greatestDiff = differance
		end
	end

	if(greatestName) then
		S:Print(greatestName.. " 为CPU占用最多的函数, 用时: "..greatestUsage.."ms. 共执行 ".. greatestCalls.." 次.")
	else
		S:Print("nothing happened.")
	end
end

function S:GetTopCPUFunc(msg)
	if GetCVar("scriptProfile") ~= "1" then return end

	local module, delay = string.split(",",msg)

	module = module == "nil" and nil or module
	delay = delay == "nil" and nil or tonumber(delay)

	wipe(CPU_USAGE)
	local mod = self:GetModule(module, true) or self
	for name, func in pairs(mod) do
		if type(mod[name]) == "function" and name ~= "GetModule" then
			CPU_USAGE[name] = GetFunctionCPUUsage(mod[name], true)
		end
	end

	self:Delay(delay or 5, CompareCPUDiff, module)
	self:Print("Calculating CPU Usage..")
end

S.Developer = {"Coolkid", "Coolkids", "Coolkid", "Kenans", "月殤軒", "月殤玄", "月殤妶", "月殤玹", "月殤旋", "月殤璇", "Coolkida"}

function S:IsDeveloper()
	for _, name in pairs(S.Developer) do
		if name == S.myname then
			return true
		end
	end
	return false
end

function S:ADDON_LOADED(event, addon)
	self:UnregisterEvent("ADDON_LOADED")
end
S:RegisterEvent("ADDON_LOADED")

function S:FadeOutFrame(p, t, show)  --隐藏  show为false时候为完全隐藏
	if type(p) == "table" then 
		if p:GetAlpha()>0 then
			local fadeInfo = {}
			fadeInfo.mode = "OUT"
			fadeInfo.timeToFade = t or 1.5
			if not show then
				fadeInfo.finishedFunc = function() p:Hide() end 
			end
			fadeInfo.startAlpha = p:GetAlpha()
			fadeInfo.endAlpha = 0
			UIFrameFade(p, fadeInfo)
		end 
		return
	end
	if not _G[p] then print("SunUI:没有发现"..p.."这个框体")return end
	if _G[p]:GetAlpha()>0 then
		local fadeInfo = {}
		fadeInfo.mode = "OUT"
		fadeInfo.timeToFade = t or 1.5
		if not show then
			fadeInfo.finishedFunc = function() _G[p]:Hide() end 
		end
		fadeInfo.startAlpha = _G[p]:GetAlpha()
		fadeInfo.endAlpha = 0
		UIFrameFade(_G[p], fadeInfo)
	end 
end

function S:FormatTime(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		--return format("%dd", floor(s/day + 0.5)), s % day
		return format(COOLDOWN_DURATION_DAYS, floor(s/day + 0.5)), s % day
	elseif s >= hour then
		--return format("%dh", floor(s/hour + 0.5)), s % hour
		return format(COOLDOWN_DURATION_HOURS, floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		--return format("%dm", floor(s/minute + 0.5)), s % minute
		return format(COOLDOWN_DURATION_MIN, floor(s/minute + 0.5)), s % minute
	end
	return format("%ds", s), (s * 100 - floor(s * 100))/100
end

function S:CreateFS(parent, fontSize, justify, fontname, fontStyle)
    local f = parent:CreateFontString(nil, "OVERLAY")
	
	if fontname == nil then
		f:FontTemplate(nil, fontSize, fontStyle)
	else
		f:FontTemplate(fontname, fontSize, fontStyle)
	end

    if justify then f:SetJustifyH(justify) end

    return f
end

function S:CheckChat(warning)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if warning and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			return "RAID_WARNING"
		else
			return "RAID"
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
	return "SAY"
end

function S:GetSpell(k)
  if GetSpellInfo(k) then
    return GetSpellInfo(k)
  else
    S:Print("法术ID无效", k)
    return ""
  end
end

function S:GetSpell(k)
  if GetSpellInfo(k) then
    return GetSpellInfo(k)
  else
    S:Print("法术ID无效", k)
    return k
  end
end