local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local PT = E:NewModule("PetTime", "AceEvent-3.0", "AceTimer-3.0")
local filter = COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local list= {
	[132604] = 15,
	[132603] = 15,
	[51533] = 30,	--天赋2 萨满
	[123904] = 45, --90级天赋2 武僧
	[102706] = 15, --德鲁伊60级3
	[33831] = 15, 
	[102693] = 15,
	[102703] = 15,
	[46585] = 60, 	
	[49206] = 30, --DK 天赋3
	[86659] = 12, --QS
	[86669] = 30,
	[86698] = 30,
}

local bar = CreateFrame("StatusBar", nil, UIParent)
bar:Hide()

local FormatTime = function(time)
	if time >= 60 then
		return format("%.2d:%.2d", floor(time / 60), time % 60)
	else
		return format("%.2d", time)
	end
end

local function UpdatePet(self)
	local curTime = GetTime()
	if self.max < curTime then
		PT:StopBar()
		return
	end
	bar:SetValue(100 - (curTime - self.startTime) / (self.max - self.startTime) * 100)
	bar.right:SetText(FormatTime(self.max - curTime))
	local r, g, b = S:ColorGradient((1-(curTime - self.startTime) / (self.max - self.startTime)),1, 0.2, 0.2, 1, 1, 0, 0.2, 1, 0.2)
	bar.right:SetTextColor(r, g, b)
	bar:SetStatusBarColor(r, g, b)
end
--萨满切天赋
function PT:ACTIVE_TALENT_GROUP_CHANGED()
	local spec = GetSpecialization()
	if spec == 2 then 
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end
--武僧 小德洗天赋..
function PT:PLAYER_TALENT_UPDATE()
	local study
	local num = S.myclass == "MONK" and 17 or 12
	local spellid = S.myclass == "MONK" and 123904 or 106737
	local name, iconTexture, tier, column, selected, available = GetTalentInfo(num,false,GetActiveSpecGroup(false,false))
	if selected and name == select(1, GetSpellInfo(spellid)) then
		study = true
	else
		study =false
	end
	if study then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function PT:StopBar()
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
end
function PT:StartBar()
	bar:SetScript("OnUpdate", UpdatePet)
	bar:Show()
end
local OnMouseDown = function(self, button)
	if button == "RightButton" then
		PT:StopBar()
	end
end
bar:EnableMouse(true)
bar:SetScript("OnMouseDown", OnMouseDown)
function PT:COMBAT_LOG_EVENT_UNFILTERED(_, ...)
	local _, eventType, _, _, sourceName, sourceFlags = ...
	if band(sourceFlags, filter) == 0 or sourceName ~= S.myname then return end
	local spellId = select(12, ...)
	if eventType == "SPELL_SUMMON" and list[spellId] then
		bar.max = list[spellId] + GetTime()
		bar.startTime = GetTime()
		if not bar.texture then
			bar.icon:SetNormalTexture(GetSpellTexture(spellId))
			bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			bar.left:SetText(GetSpellInfo(spellId))
			bar.texture = true
		end
		self:StartBar()
	end
end
function PT:Init()
	bar:SetStatusBarTexture(S["media"].normal)
	bar:SetMinMaxValues(0, 100)
	bar:SetValue(0)
	S:SmoothBar(bar)
	bar:CreateShadow(0.5)
	bar.right = S:CreateFS(bar, 12)
	bar.right:SetPoint("RIGHT", 1, 6)
	bar.right:SetJustifyH("RIGHT")

	bar.left = S:CreateFS(bar, 12)
	bar.left:SetPoint("LEFT", 2, 6)
	bar.left:SetJustifyH("LEFT")
	bar.left:SetSize(140, 20)


	bar.icon = CreateFrame("Button", nil, bar)
	bar.icon:SetSize(20, 20)
	bar.icon:SetPoint("TOPRIGHT", bar, "TOPLEFT", -10, 0)
	bar.icon:CreateShadow()
	local A = S:GetModule("Skins-SunUI")
	A:CreateMark(bar)

	local Data = P["ClassAT"]
	local C = Data
	bar:SetSize(C.petWidth-1, 6)
	bar:SetPoint("BOTTOM", "UIParent", "BOTTOM", -233, 220)
	if S.myclass == "PRIEST" or S.myclass == "PALADIN" or S.myclass == "DEATHKNIGHT" then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	elseif S.myclass == "MONK" or S.myclass == "DRUID" then
		self:RegisterEvent("PLAYER_TALENT_UPDATE")
		self:PLAYER_TALENT_UPDATE()
	elseif S.myclass == "SHAMAN" then
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		self:ACTIVE_TALENT_GROUP_CHANGED()
	end
	
	S:CreateMover(bar, "PetTimeMover", "宠物计时", true, nil, "ALL,MINITOOLS")
end

function PT:Initialize()
	self:Init()
end

E:RegisterModule(PT:GetName())