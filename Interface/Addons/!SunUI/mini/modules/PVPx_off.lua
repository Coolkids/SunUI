local _, _, _, DB = unpack(select(2, ...))

-- Config
local fsize = 16 -- 字體大小
local _G = _G
local UIParent = UIParent
local function dummy() end

local function WorldStateAlwaysUpFrame_Update()   
   _G["WorldStateAlwaysUpFrame"]:ClearAllPoints()
   _G["WorldStateAlwaysUpFrame"].ClearAllPoints = dummy
   _G["WorldStateAlwaysUpFrame"]:SetPoint("TOP",UIParent,"TOP", 200, -55) -- 位置
   _G["WorldStateAlwaysUpFrame"].SetPoint = dummy
   local alwaysUpShown = 1   
   for i = alwaysUpShown, NUM_ALWAYS_UP_UI_FRAMES do   
      _G["AlwaysUpFrame"..i.."Text"]:SetFont(DB.Font, fsize, "THINOUTLINE")
   end
end
hooksecurefunc("WorldStateAlwaysUpFrame_Update", WorldStateAlwaysUpFrame_Update)