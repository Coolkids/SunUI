local AddOnName = ...
if (GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW") then return end

local function RGBToHex(r, g, b)
   r = r <= 1 and r >= 0 and r or 0
   g = g <= 1 and g >= 0 and g or 0
   b = b <= 1 and b >= 0 and b or 0
   return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

local A = setmetatable(GetLocale() == "zhCN" and {
   ["(.*) won: (.+)"]                               = "(.*)赢得了：(.+)",
   ["%s|HLootCollector:%d|h[%s roll]|h|r %s won %s "] = "%s|HLootCollector:%d|h[%s]|h|r %s 赢得了 %s ",
   ["(.*) has?v?e? selected (.+) for: (.+)"]        = "(.+)选择了(.+)取向：(.+)",
   ["(.+) Roll . (%d+) for (.+) by (.+)"]           = "((.+))(%d+)点：(.+)((.+))",
   ["(.+) Roll - (%d+) for (.+) by (.+) + Role Bonus"]    = "((.+)%+职责加成)(%d+)点：(.+)((.+))",
   [" passed on: "]                                 = "放弃了：",
   [" automatically passed on: "]                   = "自动放弃了",
   ["You passed on: "]                              = "你放弃了：",
   ["Everyone passed on: "]                         = "所有人都放弃了：",
   ["Winner"]                              = "获胜者",
} or GetLocale() == "zhTW" and {
   ["(.*) won: (.+)"]                               = "(.*)贏得了:(.+)",
   ["%s|HLootCollector:%d|h[%s roll]|h|r %s won %s "] = "%s|HLootCollector:%d|h[%s]|h|r %s 贏得了 %s ",
   ["(.*) has?v?e? selected (.+) for: (.+)"]        = "(.+)選擇\228?\186?\134?(.+):(.+)",
   ["(.+) Roll . (%d+) for (.+) by (.+)"]           = "([^-]+) %- (.+)由(.+)擲出(%d+)",
   ["(.+) Roll - (%d+) for (.+) by (.+) + Role Bonus"]    = "%((.+)%+角色加成%)(%d+)點:(.+)%((.+)%)",
   [" passed on: "]                                 = "放棄了:",
   [" automatically passed on: "]                   = "自動放棄:",
   ["You passed on: "]                              = "你放棄了:",
   ["Everyone passed on: "]                         = "所有人都放棄了:",
   ["Winner"]                              = "獲勝者",
} or {}, {__index = function(t,i) return i end})


local colorneed, colorgreed, colorde = "|cff4dd6ff", "|cffffff00", "|cffff00ff"
local rollcolors, coloredwords = {[ROLL_DISENCHANT] = colorde, [GREED] = colorgreed, [NEED] = colorneed}, {}
for i,v in pairs(rollcolors) do coloredwords[i] = v..i end
rolls = {}
frames = {}
local iszhTW = GetLocale() == "zhTW"


local function FindRoll(link, player, hasselected)
   for i,roll in ipairs(rolls) do
      if roll._link == link and not roll._winner and (not roll[player] or hasselected) then return roll end
   end
   local newroll = {_link = link}
   table.insert(rolls, newroll)
   return newroll
end

function FindFrame()
   wipe(frames)
   for i = 1, 7 do
      local name = "ChatFrame"..i
      for i,v in pairs(_G[name].messageTypeList) do
         if v == "LOOT" then
            frames[name] = true
         end
      end
   end
end


local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
   f:UnregisterEvent("ADDON_LOADED")
   f:RegisterEvent("CHAT_MSG_LOOT")
   f:SetScript("OnEvent", function(self, event, msg)
      FindFrame()
      local rolltype, rollval, link, player = msg:match(A["(.+) Roll - (%d+) for (.+) by (.+) + Role Bonus"])
      if not player then
         rolltype, rollval, link, player = msg:match(A["(.+) Roll . (%d+) for (.+) by (.+)"])
         if iszhTW then link, player, rollval = rollval, link, player end
      end

      if player then
         local roll = FindRoll(link, player, true)
         roll[player] = {rolltype, rollcolors[rolltype]..rollval, select(2, UnitClass(player))}
         return
      end
      local player, selection, link = msg:match(A["(.*) has?v?e? selected (.+) for: (.+)"])
      if player and player ~= "" then
         player = player == YOU and UnitName("player") or player
         FindRoll(link, player)[player] = {selection, nil}
         return
      end

      local player, link = msg:match(A["(.*) won: (.+)"])
      if player then
         player = player == YOU and UnitName("player") or player
         for i, roll in ipairs(rolls) do
            if roll._link == link and roll[player] and not roll._printed then
               roll._printed = true
               roll._winner = player
               local rolltype = roll[roll._winner][1]
               local r, g, b = 1, 1, 1
               if roll[roll._winner][3] then
                  r, g, b = RAID_CLASS_COLORS[roll[roll._winner][3]].r, RAID_CLASS_COLORS[roll[roll._winner][3]].g, RAID_CLASS_COLORS[roll[roll._winner][3]].b
               end
               local name, server = UnitName(player)
               if (server and server ~= "") then
                  name = name.."-"..server
               end
               local msg = string.format(A["%s|HLootCollector:%d|h[%s roll]|h|r %s won %s "], rollcolors[rolltype], i, rolltype, "|Hplayer:"..(name or player).."|h["..RGBToHex(r, g, b)..player.."|r]|h", link)
                  for cf in pairs(frames) do
                     _G[cf]:AddMessage(msg)
                  end
               return
            end
         end
         return
      end
   end)
end)


ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", function(self, event, msg)
   if msg:match(A["(.*) won: (.+)"]) or msg:match(A["(.*) has?v?e? selected (.+) for: (.+)"]) or msg:match(A["(.+) Roll . (%d+) for (.+) by (.+)"]) or msg:match(A["(.+) Roll - (%d+) for (.+) by (.+) + Role Bonus"])
      or msg:match(A["You passed on: "]) or msg:match(A[" automatically passed on: "]) or (msg:match(A[" passed on: "]) and not msg:match(A["Everyone passed on: "])) then
      return true
   end
end)


local orig2 = SetItemRef
function SetItemRef(link, text, button)
   local id = link:match("LootCollector:(%d+)")
   if id then
      ShowUIPanel(ItemRefTooltip)
      if not ItemRefTooltip:IsShown() then ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE") end

      local roll = rolls[tonumber(id)]
      local rolltype = roll[roll._winner][1]
      ItemRefTooltip:ClearLines()
      ItemRefTooltip:AddLine(rolltype.."|r - "..roll._link)
      local r, g, b = 1, 1, 1
      if roll[roll._winner][3] then
         r, g, b = RAID_CLASS_COLORS[roll[roll._winner][3]].r, RAID_CLASS_COLORS[roll[roll._winner][3]].g, RAID_CLASS_COLORS[roll[roll._winner][3]].b
      end
      ItemRefTooltip:AddDoubleLine(A["Winner"]..": ", RGBToHex(r, g, b)..roll._winner.."|r")
      for i,v in pairs(roll) do
         if string.sub(i, 1, 1) ~= "_" then
            local r, g, b = 1, 1, 1
            if v[3] then
               r, g, b = RAID_CLASS_COLORS[v[3]].r, RAID_CLASS_COLORS[v[3]].g, RAID_CLASS_COLORS[v[3]].b
            end
            if i == UnitName("player") then
               ItemRefTooltip:AddDoubleLine(RGBToHex(r, g, b)..i.."|r (|cffff0000"..YOU.."|r)", v[2])
            elseif i == roll._winner then
               ItemRefTooltip:AddDoubleLine(RGBToHex(r, g, b)..i.."|r (|cffff0000"..A["Winner"].."|r)", v[2])
            else
               ItemRefTooltip:AddDoubleLine(RGBToHex(r, g, b)..i.."|r", v[2])
            end
         end
      end
      ItemRefTooltip:Show()
   else
      return orig2(link, text, button)
   end
end