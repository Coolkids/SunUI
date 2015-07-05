local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local FG = S:NewModule("Filger", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
FG.modName = L["技能监视"]
FG.order = 23
function FG:GetOptions()
	local options = {
		RayGui = {
			order = 1,
			type = "execute",
			name = L["技能监视"],
			desc = L["技能监视"],
			func = function()
				LibStub("AceConfigDialog-3.0"):Open("RayWatcherConfig")
				LibStub("AceConfigDialog-3.0"):Close("SunUI")
				local f = LibStub("AceConfigDialog-3.0").OpenFrames["RayWatcherConfig"].frame
				f:HookScript("OnHide", function(self) 
	       	 		LibStub("AceConfigDialog-3.0"):Open("SunUI")
	       	 		--self:SetScript("OnHide", nil)
       	 		end)
			end,
		},
	}
	return options
end

function FG:Info()
	return L["技能监视信息"]
end

S:RegisterModule(FG:GetName())