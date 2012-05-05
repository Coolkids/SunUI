-- Engines
local S, C, L, DB = unpack(select(2, ...))
 
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Welcome", "AceEvent-3.0")
function Module.ResetToDefault()
	wipe(WelcomeDB)
end

function Module:OnEnable()
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", function()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if WelcomeDB ~= 1 and CoreVersion ~= nil then
			StaticPopupDialogs["SetuiScale"] = {
				text = "第一次使用将会自动调整ui缩放,界面布局.",
				button1 = OKAY,
				OnAccept = function()
					SlashCmdList.AutoSet()	
				end,
				timeout = 0,
				whileDead = 1,
				hideOnEscape = 0,
			}
			StaticPopup_Show("SetuiScale")
		end
		WelcomeDB = 1
	end)
end