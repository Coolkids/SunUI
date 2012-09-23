local S, C, L, DB = unpack(select(2, ...))
 
local lib = LibStub("LibCooldown")
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("CooldownFlash")

function Module:OnEnable()
	C = C["ActionBarDB"]
	if C["CooldownFlash"] ~= true then return end

		local filter = {
			["pet"] = "all",
			["item"] = {
				[6948] = true, -- hearthstone
			},
			["spell"] = {
			},
		}

		local flash = CreateFrame("Frame", nil, UIParent)
		flash:SetSize(C["CooldownFlashSize"],C["CooldownFlashSize"])
		MoveHandle.CooldownFlash = S.MakeMoveHandle(flash, L["冷却闪光"], "CooldownFlash")
		flash.icon = flash:CreateTexture(nil, "OVERLAY")
		flash:SetScript("OnEvent", function()
			flash.icon:SetAllPoints(flash)
			flash.icon:SetTexCoord(.08, .92, .08, .92)
			flash:CreateShadow()
			flash:Hide()
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
			flash:UnregisterEvent("PLAYER_ENTERING_WORLD")
			flash:SetScript("OnEvent", nil)
		end)
		flash:RegisterEvent("PLAYER_ENTERING_WORLD")

		lib:RegisterCallback("stop", function(id, class)
			if filter[class]=="all" or filter[class][id] then return end
			flash.icon:SetTexture(class=="item" and GetItemIcon(id) or select(3, GetSpellInfo(id)))
			flash.e = 0
			flash:Show()
		end)
end