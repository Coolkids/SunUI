local S, C, L, DB = unpack(SunUI)
if (DB.MyClass ~= "PRIEST" and DB.MyClass ~= "SHAMAN") then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("ShadowPet")
function Module:OnInitialize()
	local spellname, timeing, spellid
		if DB.MyClass == "PRIEST" then 
			spellname= GetSpellInfo(34433)
			timeing = 15
			spellid = 34433
		else
			spellname= GetSpellInfo(51533)
			timeing = 30
			spellid = 51533
		end
		
	local sformat = string.format
	local floor = math.floor
	local timer = 0
	local bars = {}

	local FormatTime = function(time)
		if time >= 60 then
			return sformat("%.2d:%.2d", floor(time / 60), time % 60)
		elseif time >= 10 then
			return sformat("%.2d", time)
		else
			return "|cffFF6161"..sformat("%.2d", time).."|r"
		end
	end

	local CreateFS = function(frame, fsize, fstyle)
		local fstring = frame:CreateFontString(nil, "OVERLAY")
		fstring:SetFont(DB.Font, 12, "OUTLINE")
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
		if self.endTime < curTime then
			StopTimer(self)
			return
		end
		if not oUF_SunUIPet:IsShown() then
			StopTimer(self)
			return
		end
		self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
		self.right:SetText(FormatTime(self.endTime - curTime))
		self.right:SetTextColor(S.ColorGradient((self.endTime - curTime)/15,1, 0, 0, 1, 1, 0, 0.8, 0.87, 0.9))
		self:SetStatusBarColor(S.ColorGradient((self.endTime - curTime)/15,1, 0, 0, 1, 1, 0, 0.8, 0.87, 0.9))
	end

	local OnMouseDown = function(self, button)
		if button == "RightButton" then
			StopTimer(self)
		end
	end

	local CreateBar = function()
		local bar = CreateFrame("Statusbar", nil, UIParent)
		bar:SetSize(C["UnitFrameDB"]["PetWidth"]*C["UnitFrameDB"]["PetScale"], 6)
		bar:SetStatusBarTexture(DB.Statusbar)
		bar:SetMinMaxValues(0, 100)
		bar:CreateShadow("Background")
		
		bar.left = CreateFS(bar)
		bar.left:SetPoint("LEFT", 2, 6)
		bar.left:SetJustifyH("LEFT")
		bar.left:SetSize(140, 20)

		bar.right = CreateFS(bar)
		bar.right:SetPoint("RIGHT", 1, 6)
		bar.right:SetJustifyH("RIGHT")

		bar.icon = CreateFrame("Button", nil, bar)
		bar.icon:SetSize(16, 16)
		bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
		bar.icon:CreateShadow()
		return bar
	end

	local StartTimer = function(name, spellId)
		local bar = CreateBar()
		local spell, rank, icon = GetSpellInfo(spellId)
		bar.endTime = GetTime() + timeing
		bar.startTime = GetTime()
		bar.left:SetText(name)
		bar.right:SetText(FormatTime(timeing))
		bar.icon:SetNormalTexture(icon)
		bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		bar.spell = spell
		bar:Show()
		--bar:SetStatusBarColor(192/255, 192/255, 192/255)
		--bar:SetStatusBarColor(FormatTime(15)/15,1, 0, 0, 1, 1, 0, 0.8, 0.87, 0.9)
		bar:SetScript("OnUpdate", BarUpdate)
		bar:EnableMouse(true)
		bar:SetScript("OnMouseDown", OnMouseDown)
		tinsert(bars, bar)
		MoveHandle.ShadowPet = S.MakeMoveHandle(bar, "暗影魔计时条", "ShadowPet")
	end

	local EuiPriestPetOnUpdate = function(self)
		if (DB.MyClass ~= "PRIEST" and DB.MyClass ~= "SHAMAN") then return end
		if oUF_SunUIPet:IsShown() and self.havePet == false then
			StartTimer(spellname, spellid);
			self.havePet = true;
		end
	end

	local addon = CreateFrame("Frame", "EuiPriestPet", UIParent)
	addon.havePet = false
	addon:SetScript("OnUpdate", EuiPriestPetOnUpdate);
end
