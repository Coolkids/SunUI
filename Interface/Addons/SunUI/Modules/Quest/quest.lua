local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local QT = S:NewModule("Quest", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
QT.modName = L["任务增强"]
QT.order = 12
function QT:GetOptions()
	local options = {
		AutoQuest = {
			type = "toggle",
			name = L["自动交接任务"],
			desc = L["自动交接任务"],
			order = 1,
			set = function(info, value) self.db.AutoQuest = value
				self:UpdateAutoAccept()
			end,
		},
		QuestGuru = {
			type = "toggle",
			name = L["原始任务窗口"],
			desc = L["原始任务窗口"],
			order = 2,
		},
	}
	return options
end

function QT:initQuestGuru()
	if self.db.QuestGuru then
		QuestGuru:RegisterEvent("PLAYER_ENTERING_WORLD")
		QuestGuru:SetScript("OnEvent", function(self, event) self.OnEvent(self, event) end)
		QuestGuru:SetScript("OnShow", function(self) self.OnShow(self) end)
		QuestGuru:SetScript("OnHide", function(self) self.OnHide(self) end)
		QuestGuru:SetScript("OnMouseDown", function(self) self:StartMoving() end)
		QuestGuru:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
	else
		QuestGuru:UnregisterAllEvents()
		QuestGuru:SetScript("OnEvent", nil)
		QuestGuru:SetScript("OnShow", nil)
		QuestGuru:SetScript("OnHide", nil)
		QuestGuru:SetScript("OnMouseDown", nil)
		QuestGuru:SetScript("OnMouseUp", nil)
		QuestGuru:Hide()
	end
end

function QT:Initialize()
	self:initAutoAccept()
	self:initQuestGuru()
end

S:RegisterModule(QT:GetName())