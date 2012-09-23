local S, C, L, DB, _ = unpack(select(2, ...))
if (DB.MyClass ~= "PRIEST" and DB.MyClass ~= "SHAMAN") then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("ShadowPet")
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
		
local FormatTime = function(time)
	if time >= 60 then
		return string.format("%.2d:%.2d", math.floor(time / 60), time % 60)
	else
		return string.format("%.2d", time)
	end
end

local CreateFS = function(frame)
	local fstring = frame:CreateFontString(nil, "OVERLAY")
	fstring:SetFont(DB.Font, 12, "OUTLINE")
	return fstring
end	
local function UpdatePet(self,elapsed)
		if GetPetTimeRemaining() and GetPetTimeRemaining() < timeing then
		local t = GetPetTimeRemaining()/1000
			self:SetValue(GetPetTimeRemaining())
			self.right:SetText(FormatTime(t))
			local r, g, b = S.ColorGradient(GetPetTimeRemaining()/timeing,1, 0, 0, 1, 1, 0, 0.8, 0.87, 0.9)
			self.right:SetTextColor(r, g, b)
			self:SetStatusBarColor(r, g, b)	
		else
			self:SetValue(0)
			self.right:SetText("")
		end
	end
function Module:OnEnable()	
	local bar = CreateFrame("StatusBar", nil, UIParent)
	bar:SetSize(C["UnitFrameDB"]["PetWidth"]*C["UnitFrameDB"]["PetScale"], 6)
	bar:SetStatusBarTexture(DB.Statusbar)
	bar:GetStatusBarTexture():SetHorizTile(false)
	bar:SetMinMaxValues(0, timeing)
	bar:SetValue(0)
	bar:CreateShadow()
	bar:SetReverseFill(true)
	local gradient = bar:CreateTexture(nil, "BACKGROUND")
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture(DB.Statusbar)
	gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
	
	bar.right = CreateFS(bar)
	bar.right:SetPoint("RIGHT", 1, 6)
	bar.right:SetJustifyH("RIGHT")
	
	bar.left = CreateFS(bar)
	bar.left:SetPoint("LEFT", 2, 6)
	bar.left:SetJustifyH("LEFT")
	bar.left:SetSize(140, 20)
	bar.left:SetText(spellname)
	
	bar.icon = CreateFrame("Button", nil, bar)
	bar.icon:SetSize(16, 16)
	bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
	bar.icon:SetNormalTexture(select(3, GetSpellInfo(spellid)))
	bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	bar.icon:CreateShadow()
	
	bar:Hide()
	MoveHandle.ShadowPet = S.MakeMoveHandle(bar, "暗影魔计时条", "ShadowPet")
	
	local h = CreateFrame("Frame", nil, UIParent)
	h:SetScript("OnUpdate", function()
		if UnitExists("pet") then
			bar:Show()
		else
			bar:Hide()
		end
	end)

	bar:SetScript("OnUpdate",UpdatePet)
end
