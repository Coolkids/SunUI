local S, _, _, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("SunUI BaseData")
DB.scale = 0.7

function Module:OnInitialize()
  DB.scale = MiniDB["uiScale"]
  local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/DB.scale
  local function scale(x)
	return (mult*math.floor(x/mult+.5)) 
  end
  S.mult = mult
  S.Scale = scale
end
