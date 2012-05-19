local S, C, L, DB = unpack(select(2, ...))
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("Core"):GetModule("SunUIConfig")
function SunUIConfig:OnInitialize()
	SunUIConfig:Load()
	for group, options in pairs(SunUIConfig.db.profile) do
		if not C[group] then C[group] = {} end
		if C[group] then
			for option, value in pairs(options) do
				C[group][option] = value
			end
		end
	end
	MoveHandle = {}
end