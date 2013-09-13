local S, L, DB, _, C = unpack(select(2, ...))
local lib = LibStub("LibCooldown")
local CF = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("CooldownFlash", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local flash = CreateFrame("Frame", nil, UIParent)
flash.icon = flash:CreateTexture(nil, "OVERLAY")
flash.icon:SetAllPoints(flash)
flash.icon:SetTexCoord(.08, .92, .08, .92)
flash:CreateShadow()
flash:Hide()
local filter = {
	["pet"] = "all",
	["item"] = {
		[6948] = true, -- hearthstone
	},
	["spell"] = {
		[125439] = true,
	},
}
function CF:SetUpdate()
	flash:SetScript("OnUpdate", function(self, e)
		flash.e = flash.e + e
		if flash.e > .75 then
			flash:Hide()
		elseif flash.e < .25 then
			flash:SetAlpha(flash.e*4)
		elseif flash.e > .5 then
			flash:SetAlpha(1-(flash.e%.5)*4)
		end
	end)
end
function CF:UpdateSet()
	if C["CooldownFlash"] then
		CF:SetUpdate()
		lib:RegisterCallback("stop", function(id, class)
			if filter[class]=="all" or filter[class][id] then return end
			flash.icon:SetTexture(class=="item" and GetItemIcon(id) or GetSpellTexture(id))
			flash.e = 0
			flash:Show()
		end)
	else
		CF:UnregisterEvent("PLAYER_ENTERING_WORLD")
		wipe(lib.stopcalls)
		flash:SetScript("OnUpdate", nil)
		flash:Hide()
	end
end
function CF:UpdateSize()
	flash:SetSize(C["CooldownFlashSize"],C["CooldownFlashSize"])
end
function CF:OnInitialize()
	if (IsAddOnLoaded("ncCooldownFlash")) then
		return 
	end
	C = SunUIConfig.db.profile.ActionBarDB
	self:UpdateSet()
	self:UpdateSize()
	MoveHandle.CooldownFlash = S.MakeMoveHandle(flash, L["冷却闪光"], "CooldownFlash")
end