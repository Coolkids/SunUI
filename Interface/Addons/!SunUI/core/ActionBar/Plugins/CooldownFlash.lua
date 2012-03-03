local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local lib = LibStub("LibCooldown")
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("CooldownFlash")
function Module:OnInitialize()
	C = ActionBarDB
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
		flash.icon = flash:CreateTexture(nil, "OVERLAY")
		flash:SetScript("OnEvent", function()
			local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/GetCVar("uiScale")
			local function scale(x) return mult*math.floor(x/mult+.5) end
			flash:SetPoint("BOTTOM", CooldownFlash, "BOTTOM", 0, 0)
			flash:SetSize(C["CooldownFlashSize"]*scale(1),C["CooldownFlashSize"]*scale(1))
			--flash:SetBackdropColor(.1,.1,.1)
			--flash:SetBackdropBorderColor(.6,.6,.6)
			flash.icon:SetPoint("TOPLEFT", scale(2), scale(-2))
			flash.icon:SetPoint("BOTTOMRIGHT", scale(-2), scale(2))
			flash.icon:SetTexCoord(.08, .92, .08, .92)
			CreateShadow(flash, flash.icon)
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