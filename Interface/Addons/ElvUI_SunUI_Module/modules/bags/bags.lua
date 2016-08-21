local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local B = E:NewModule('SunUI-Bags', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local Search = LibStub('LibItemSearch-1.2-ElvUI')


function B:Initialize()
	local frame = {
		_G["ElvUI_BankContainerFrame"],
		_G["ElvUI_ContainerFrame"],
	}
	for i = 1, #frame do
		if frame[i] then
			frame[i]:SetScript("OnDragStart", function(self) self:StartMoving() end)
			frame[i]:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		end
	end
	
end


E:RegisterModule(B:GetName())