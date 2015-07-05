local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local RFG = S:NewModule("SunUI_RaidFrameGUISuppest", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
RFG.modName = RAID_CONTROL
RFG.order = 24

function RFG:GetOptions()
	local options = {
		RaidFrameGUISuppest = {
			order = 1,
			type = "execute",
			name = RAID_CONTROL,
			desc = RAID_CONTROL,
			func = function()
				if not IsAddOnLoaded('Freebgrid_Config') then
		            LoadAddOn('Freebgrid_Config')
		        end
		        LibStub("AceConfigDialog-3.0"):Open("Freebgrid")
		        local f = LibStub("AceConfigDialog-3.0").OpenFrames["Freebgrid"].frame
				LibStub("AceConfigDialog-3.0"):Close("SunUI")
				f:HookScript("OnHide", function(self) 
		        	LibStub("AceConfigDialog-3.0"):Open("SunUI")
		        	--self:SetScript("OnHide", nil)
	        	end)
			end,
		},
	}
	return options
end

function RFG:Info()
	return RAIDOPTIONS_MENU
end

S:RegisterModule(RFG:GetName())