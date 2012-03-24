local S, _, _, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("SunUI BaseData")


function Module:OnInitialize()
  local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/MiniDB["uiScale"]
  local function scale(x)
	return (mult*math.floor(x/mult+.5)) 
  end
  S.mult = mult
  S.Scale = scale
end
