local S, C, L, DB = unpack(SunUI)

local _G = _G
local format = format
local pairs = pairs
local print = print
local table = table
local tostring = tostring
local type = type

local GRAY_FONT_COLOR_CODE = GRAY_FONT_COLOR_CODE
local GREEN_FONT_COLOR_CODE = GREEN_FONT_COLOR_CODE
local ORANGE_FONT_COLOR_CODE = ORANGE_FONT_COLOR_CODE
local RED_FONT_COLOR_CODE = RED_FONT_COLOR_CODE
local YELLOW_FONT_COLOR_CODE = YELLOW_FONT_COLOR_CODE

local FONT_COLOR_CODE_CLOSE = FONT_COLOR_CODE_CLOSE
local FRIENDS_BUTTON_TYPE_BNET = FRIENDS_BUTTON_TYPE_BNET
local FRIENDS_BUTTON_TYPE_WOW = FRIENDS_BUTTON_TYPE_WOW
local FRIENDS_FRIENDS_TO_DISPLAY = FRIENDS_FRIENDS_TO_DISPLAY
local LEVEL = LEVEL

local FriendsFrameFriendsScrollFrameScrollBar = FriendsFrameFriendsScrollFrameScrollBar
local FriendsListColorsDB = FriendsListColorsDB
local FriendsList_Update = FriendsList_Update
local GetFriendInfo = GetFriendInfo
local hooksecurefunc = hooksecurefunc
local UnitLevel = UnitLevel

local realIdColor = format("%02x%02x%02x", FRIENDS_BNET_NAME_COLOR.r*255, FRIENDS_BNET_NAME_COLOR.g*255, FRIENDS_BNET_NAME_COLOR.b*255)

-- create addon frame (hidden) and declare default variables
local addonName = ...
local f, cfg, db = CreateFrame("Frame"), {
  name="FriendsListColors",
  sname="FLC",
  slash={"/flc", "/friendslistcolors"},
  syntaxes={
    {"N", "C", "L", "Z", "S", "O"},
    {"NC", "CC", "LC", "ZC", "SC", "OC"},
    {"ND", "CD", "LD", "ZD", "SD", "OD"},
    {"Name", "Class", "Level", "Zone", "AFK/DNS", "Note"},
  },
  ccolors={},
  gray=GRAY_FONT_COLOR_CODE:sub(5),
  dummy={"Vladinator", "Druid", 85, "Good tank", "Stormwind City"},
  -- default configuration values if unconfigured
  defaults={
    syntax="$NC, {D!LEVEL} $LD $C", -- "Name, Level 80, Shaman" where name is  by class, level is colored by difficulty and class without specific color
  },
}
-- populate ccolors table
for k, v in pairs(RAID_CLASS_COLORS)do cfg.ccolors[k] = (v.colorStr or format("ff%02x%02x%02x", v.r*255, v.g*255, v.b*255)):sub(3) end

-- localized classes, i.e. locclasses["Magier"] returns "Mage"
local locclasses = {}
for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE)do locclasses[v] = k end
for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE)do locclasses[v] = k end

-- output
local function out(msg)
  print(format("|cff00ffff%s|r: %s", cfg.sname, tostring(msg)))
end

-- returns hex color (xxyyzz) using player level and an argument as "target level"
local getDiff = function(tar)
  local diff, col = tar - UnitLevel("player")
  if diff > 4 then
    col = RED_FONT_COLOR_CODE
  elseif diff > 2 then
    col = ORANGE_FONT_COLOR_CODE -- need more orange, this is like /emote
  elseif diff >= 0 then
    col = YELLOW_FONT_COLOR_CODE
  elseif diff >= -4 then
    col = GREEN_FONT_COLOR_CODE -- too bright green
  else
    col = GRAY_FONT_COLOR_CODE
  end
  return col:sub(0,4) == "|cff" and col:sub(5) or col -- remove "|cff" if present (don't know what will happen in the future with these constants)
end

-- format entries by special syntax I've defined for this addon
local form = function(str, ...) -- ... = 1:name, 2:class, 3:level, 4:zone, 5:status, 6:note
  if type(str) ~= "string" or str:len() == 0 then
    return "Fatal error in "..cfg.sname..", what have you done?" -- something fatal happen, oh no!
  end
  local values, code = {...}
  if #values > 0 then
    local dcolor = getDiff(values[3] or 0) -- with fallback value
    local ccolor = cfg.ccolors[(locclasses[values[2] or ""] or ""):gsub(" ",""):upper()] or cfg.gray -- with fallback value
    local syntaxes = cfg.syntaxes
    -- handle double chars like $XY
    for code in str:gmatch("%$%u%u") do
      -- color by class
      for k,v in pairs(syntaxes[2]) do
        if code == "$"..v then
          str = str:gsub(code, format("|cff%s%s%s", ccolor, values[k] or "", FONT_COLOR_CODE_CLOSE))
          break
        end
      end
      -- color by difficulty
      for k,v in pairs(syntaxes[3]) do
        if code == "$"..v then
          str = str:gsub(code, format("|cff%s%s%s", dcolor, values[k] or "", FONT_COLOR_CODE_CLOSE))
          break
        end
      end
    end
    -- handle single chars like $X
    for code in str:gmatch("%$%u") do
      for k,v in pairs(syntaxes[1]) do
        if code == "$"..v then
          str = str:gsub(code, format("|cff%s%s%s", ccolor, values[k] or "", FONT_COLOR_CODE_CLOSE))
          break
        end
      end
    end
    -- global variables {!LEVEL} becomes "Level" localized or just pure string if it's not found in _G
    for code in str:gmatch("%{%!(.+)%}") do
      str = str:gsub("%{%!"..code.."%}", _G[code] and tostring(_G[code]) or code)
    end
    -- global variables {X!LEVEL} (where X is C or D) becomes "Level" localized or just pure string if it's not found in _G. it's also colored by class or difficulty color
    for code1, code2 in str:gmatch("%{(%u)%!(.+)%}") do
      if code1 == "C" then
        str = str:gsub("%{"..code1.."%!"..code2.."%}", format("|cff%s%s%s", ccolor, _G[code2] and tostring(_G[code2]) or code2, FONT_COLOR_CODE_CLOSE))
      elseif code1 == "D" then
        str = str:gsub("%{"..code1.."%!"..code2.."%}", format("|cff%s%s%s", dcolor, _G[code2] and tostring(_G[code2]) or code2, FONT_COLOR_CODE_CLOSE))
      else
        str = str:gsub("%{"..code1.."%!"..code2.."%}", _G[code2] and tostring(_G[code2]) or code2) -- fallback, no coloring
      end
    end
  end
  return str
end

-- function will be referenced by the hook on the bottom and called when the friend list is updated by scrolling or the event is fired to update it
local updFunc = function()
  for index = 1, FRIENDS_FRIENDS_TO_DISPLAY do
    local friend = _G["FriendsFrameFriendsScrollFrameButton"..index]
    if friend and (friend.buttonType == FRIENDS_BUTTON_TYPE_BNET or friend.buttonType == FRIENDS_BUTTON_TYPE_WOW) and type(friend.id) == "number" then
      if friend.buttonType == FRIENDS_BUTTON_TYPE_BNET then
        local _, realName, _, _, _, _, client, connected, _, status1, status2, _, note, _, _ = BNGetFriendInfo(friend.id)
        if connected and client == BNET_CLIENT_WOW then
          if BNGetNumFriendToons(friend.id) > 0 then -- at logout this prevents errors, since the friend is online but without a toon when they logout
            _, name, client, _, _, _, _, class, _, zone, level, _, _, _, _, _ = BNGetFriendToonInfo(friend.id, 1)
            if name then
              if status1 then
                status = "<"..AFK..">"
              elseif status2 then
                status = "<"..DND..">"
              else
                status = ""
              end
              friend.name:SetText("|cff"..realIdColor..realName.."|r "..form(db.syntax, name, class, level, zone or "", status or "", ""))
              friend.name:SetTextColor(FRIENDS_WOW_NAME_COLOR.r, FRIENDS_WOW_NAME_COLOR.g, FRIENDS_WOW_NAME_COLOR.b)
            end
          end
        elseif not connected then -- append note at the end, like normal friends are shown when offline
          friend.name:SetText(realName.." "..form("$N |cffCCCCCC$O|r", "", "", 0, "", "", note or ""))
          friend.name:SetTextColor(FRIENDS_GRAY_COLOR.r, FRIENDS_GRAY_COLOR.g, FRIENDS_GRAY_COLOR.b)
        end
      else
        local name, level, class, zone, connected, status, note = GetFriendInfo(friend.id)
        if name then
          if connected then
            friend.name:SetText(form(db.syntax, name, class, level, zone or "", status or "", note or ""))
          else
            friend.name:SetText(form("$N |cffCCCCCC$O|r", name, class, level, zone or "", status or "", note or ""))
          end
        end
      end
    end
  end
end
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == cfg.name or addon == addonName then -- support loading when embedded
		FriendsListColorsDB = FriendsListColorsDB or cfg.defaults
		db = FriendsListColorsDB
		hooksecurefunc("FriendsList_Update", updFunc);
		--hooksecurefunc("HybridScrollFrame_Update", updFunc);
	end
end)