local S, L, DB, _, C = unpack(select(2, ...))
if (DB.MyClass ~= "PRIEST" and DB.MyClass ~= "SHAMAN") then return end
local PT = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Pet Time", "AceEvent-3.0", "AceTimer-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local _G = _G

local spellname, timeing, spellid
if DB.MyClass == "PRIEST" then 
	spellname= GetSpellInfo(34433)
	timeing = 15000
	spellid = 34433
else
	spellname= GetSpellInfo(51533)
	timeing = 30000
	spellid = 51533
end

local bar = CreateFrame("StatusBar", nil, UIParent)
bar:SetStatusBarTexture(DB.Statusbar)
bar:SetMinMaxValues(0, timeing)
bar:SetValue(0)
bar:CreateShadow()
bar.bg = bar:GetStatusBarTexture()
bar.right = S.MakeFontString(bar, 12)
bar.right:SetPoint("RIGHT", 1, 6)
bar.right:SetJustifyH("RIGHT")

bar.left = S.MakeFontString(bar, 12)
bar.left:SetPoint("LEFT", 2, 6)
bar.left:SetJustifyH("LEFT")
bar.left:SetSize(140, 20)
bar.left:SetText(spellname)

bar.icon = CreateFrame("Button", nil, bar)
bar.icon:SetSize(16, 16)
bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
bar.icon:SetNormalTexture(GetSpellTexture(spellid))
bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
bar.icon:CreateShadow()

bar:Hide()
local function FormatTime(time)
	return string.format("%.2d", time)
end

function UpdatePet()
	local t = GetPetTimeRemaining()
	if t and t < timeing and t >= 0 then
		bar:SetValue(t)
		bar.right:SetText(FormatTime(t/1000))
		local r, g, b = S.ColorGradient(t/timeing,1, 0.2, 0.2, 1, 1, 0, 0.8, 0.87, 0.9)
		bar.right:SetTextColor(r, g, b)
		S.CreateTop(bar.bg, r, g, b)
	else
		bar:SetValue(0)
		bar.right:SetText("")
	end
end
function PT:UpdateTime()
	if UnitExists("pet") and GetPetTimeRemaining() and not UnitInVehicle("player") then
		if not bar:IsShown() then
			bar:Show()
		end
		UpdatePet()
	else
		bar:Hide()
	end
end
function PT:OnEnable()
	S.CreateMark(bar)
	S.CreateBack(bar)
	C = SunUIConfig.db.profile
	bar:SetSize(C["UnitFrameDB"]["PetWidth"]*C["UnitFrameDB"]["PetScale"], 6)
	MoveHandle.ShadowPet = S.MakeMoveHandle(bar, "暗影魔计时条", "ShadowPet")
	PT:ScheduleRepeatingTimer("UpdateTime", 0.2)
end