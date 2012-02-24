local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("ShadowPet")
if DB.ShadowPetOpen ~= true then return end
if DB.MyClass ~= "PRIEST" then return end

local spellname = GetSpellInfo(34433)

local sformat = string.format
local floor = math.floor
local timer = 0
local bars = {}
function Module:OnInitialize()
C=MoveHandleDB

local PRIESTAnchor = CreateFrame("Frame", "PRIESTAnchor", UIParent)

PRIESTAnchor:SetSize(140, 20)

PRIESTAnchor:SetPoint("BOTTOM","ShadowPet","BOTTOM", 0, 0)
end

local FormatTime = function(time)
	if time >= 60 then
		return sformat("%.2d:%.2d", floor(time / 60), time % 60)
	else
		return sformat("%.2d", time)
	end
end

local CreateFS = function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, "OVERLAY")
	fstring:SetFont(DB.Font, 15, "OUTLINE")
	return fstring
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	EuiPriestPet.havePet = false
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
--	if self.endTime < curTime then
--		StopTimer(self)
--		return
--	end
	if not oUF_monoPetFrame:IsShown() then
		StopTimer(self)
		return
	end
	self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnMouseDown = function(self, button)
	if button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = CreateFrame("Statusbar", nil, UIParent)
	bar:SetFrameStrata("LOW")
	bar:SetSize(140, 20)
	bar:SetStatusBarTexture(DB.Statusbar)
	bar:SetMinMaxValues(0, 100)

	bar.backdrop = CreateFrame("Frame", nil, bar)
	bar.backdrop:SetPoint("TOPLEFT", -2, 2)
	bar.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	bar.backdrop:SetFrameStrata("BACKGROUND")
	bar.backdrop:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\AddOns\\s_Core\\Media\\glowTex", edgeSize = 3,
	insets = {top = 3, left = 3, bottom = 3, right = 3},
    })
	bar.backdrop:SetBackdropColor(0, 0, 0, 0.2)
    bar.backdrop:SetBackdropBorderColor(0, 0, 0)

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints(bar)
	bar.bg:SetTexture(DB.Statusbar)

	bar.left = CreateFS(bar)
	bar.left:SetPoint("LEFT", 2, 0)
	bar.left:SetJustifyH("LEFT")
	bar.left:SetSize(140, 20)

	bar.right = CreateFS(bar)
	bar.right:SetPoint("RIGHT", 1, 0)
	bar.right:SetJustifyH("RIGHT")

	bar.icon = CreateFrame("Button", nil, bar)
	bar.icon:SetSize(20, 20)
	bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -6, 0)
	S.MakeShadow(bar.icon, 3)
	bar.icon.backdrop = CreateFrame("Frame", nil, bar.icon)
	bar.icon.backdrop:SetPoint("TOPLEFT", -2, 2)
	bar.icon.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	bar.icon.backdrop:SetFrameStrata("BACKGROUND")
	S.MakeShadow(bar, 3)
	return bar
end

local StartTimer = function(name, spellId)
	local bar = CreateBar()
	local spell, rank, icon = GetSpellInfo(spellId)
	bar.endTime = GetTime() + 15
	bar.startTime = GetTime()
	bar.left:SetText(name)
	bar.right:SetText(FormatTime(15))
	bar.icon:SetNormalTexture(icon)
	bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	bar.spell = spell
	bar:Show()
	bar:SetStatusBarColor(192/255, 192/255, 192/255)
	bar.bg:SetVertexColor(192/255, 192/255, 192/255, 0.25)
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnMouseDown", OnMouseDown)
	tinsert(bars, bar)
	bar:SetAllPoints(PRIESTAnchor);
end

local EuiPriestPetOnUpdate = function(self)
	if DB.MyClass ~= "PRIEST" then return end
	if oUF_monoPetFrame:IsShown() and self.havePet == false then
		StartTimer(spellname, 34433);
		self.havePet = true;
	end
end

local addon = CreateFrame("Frame", "EuiPriestPet", UIParent)
addon.havePet = false
addon:SetScript("OnUpdate", EuiPriestPetOnUpdate);