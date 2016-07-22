--[[   ____    ______
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/

 [=====================================]
 [  Author: Dandraffbal-Stormreaver US ]
 [  xCT+ Version 4.x.x                 ]
 [  ©2015. All Rights Reserved.        ]
 [====================================]]

local build = select(4, GetBuildInfo())

local ADDON_NAME, addon = ...
local LSM = LibStub("LibSharedMedia-3.0")
local x, noop = addon.engine, addon.noop
local blankTable, unpack, select = {}, unpack, select
local string_gsub, string_match, sformat, pairs = string.gsub, string.match, string.format, pairs

-- New Icon "!"
local NEW = x.new

-- Store Localized Strings
-- To remove: "Changed Target!"
local XCT_CT_DEC_0, XCT_CT_DEC_1, XCT_CT_DEC_2 = COMBAT_THREAT_DECREASE_0, COMBAT_THREAT_DECREASE_1, COMBAT_THREAT_DECREASE_2
local XCT_CT_INC_1, XCT_CT_INC_3 = COMBAT_THREAT_INCREASE_1, COMBAT_THREAT_INCREASE_3

local PLAYER_NAME = UnitName('player')
local _, PLAYER_CLASS = UnitClass('player')
if PLAYER_CLASS then
  PLAYER_NAME = ('|c%s%s|r'):format(RAID_CLASS_COLORS[PLAYER_CLASS].colorStr, PLAYER_NAME)
end

-- Creating an Config
addon.options = {
  -- Add a place for the user to grab
  name = "                                                      " .. "Version: "..(GetAddOnMetadata("xCT+", "Version") or "Unknown") .. "                                                      ",
  handler = x,
  type = 'group',
  args = {
    xCT_Title = {
      order = 0,
      type = 'description',
      fontSize = 'large',
      name = "|cffFF0000x|rCT|cffFFFF00+|r |cff798BDDConfiguration Tool|r\n",
      width = 'double',
    },

    spacer0 = {
      order = 1,
      type = 'description',
      name = "|cffFFFF00Helpful Tips:|r\n\n",
      width = 'half',
    },

    helpfulTip = {
      order = 2,
      type = 'description',
      fontSize = 'medium',
      name = "On the left list, under the |cffFFFF00Startup Message|r checkbox, you can click on the |cff798BDD+ Buttons|r (plus) to show more options.",
      width = 'double',
    },

    --[[xCT_Header = {
      order = 10,
      type = "header",
      name = "Version: "..(GetAddOnMetadata("xCT+", "Version") or "Unknown"),
      width = "full",
    },]]

    space1 = {
      order = 10,
      type = 'description',
      name = "\n",
      width = 'full',
    },

    showStartupText = {
      order = 11,
      type = 'toggle',
      name = "Startup Message",
      get = function(info) return x.db.profile.showStartupText end,
      set = function(info, value) x.db.profile.showStartupText = value end,
    },
    hideConfig = {
      order = 12,
      type = 'toggle',
      name = "Hide Config in Combat",
      desc = "This option helps prevent UI taints by closing the config when you enter combat.\n\n|cffFF8000Highly Recommended Enabled|r",
      get = function(info) return x.db.profile.hideConfig end,
      set = function(info, value) x.db.profile.hideConfig = value; if not value then StaticPopup_Show("XCT_PLUS_HIDE_IN_COMBAT") end end,
    },
    --[==[RestoreDefaults = {
      order = 3,
      type = 'execute',
      name = "Restore Defaults",
      func = x.RestoreAllDefaults,
    },]==]
    space2 = {
      order = 20,
      type = 'description',
      name = " ",
      width = 'half',
    },
    space3 = {
      order = 30,
      type = 'description',
      name = " ",
      width = 'half',
    },
    space4 = {
      order = 30,
      type = 'description',
      name = " ",
      width = 'half',
    },
    ToggleTestMode = {
      order = 31,
      type = 'execute',
      name = "Test",
      func = x.ToggleTestMode,
      desc = "Allows you to preview xCT+ inorder to tweak settings outside of combat.\n\nYou can also type: '|cffFF0000/xct test|r'",
      width = 'half',
    },
    ToggleFrames = {
      order = 32,
      type = 'execute',
      name = "Move",
      desc = "Allows you to adjust the position of all the xCT+ frames on your screen.\n\nYou can also type: '|cffFF0000/xct lock|r'",
      func = x.ToggleConfigMode,
      width = 'half',
    },

    hiddenObjectShhhhhh = {
      order = 9001,
      type = 'description',
      name = function(info) x:OnAddonConfigRefreshed() return "" end,
    },
  },
}

-- A fast C-Var Update routine
local function isCVarsDisabled( ) return x.db.profile.bypassCVars end


x.cvar_update = function( force )
  -- Floating Combat Text: Threat Changes
  if not x.db.profile.blizzardFCT.CombatThreatChanges then
    COMBAT_THREAT_DECREASE_0, COMBAT_THREAT_DECREASE_1, COMBAT_THREAT_DECREASE_2 = "", "", ""
    COMBAT_THREAT_INCREASE_1, COMBAT_THREAT_INCREASE_3 = "", ""
  elseif COMBAT_THREAT_DECREASE_0 == "" then
    -- only overwrite Blizzard constants if they were previously changed
    COMBAT_THREAT_DECREASE_0, COMBAT_THREAT_DECREASE_1, COMBAT_THREAT_DECREASE_2 = XCT_CT_DEC_0, XCT_CT_DEC_1, XCT_CT_DEC_2
    COMBAT_THREAT_INCREASE_1, COMBAT_THREAT_INCREASE_3 = XCT_CT_INC_1, XCT_CT_INC_3
  end

  if  isCVarsDisabled( ) then
    if force then
      StaticPopup_Show("XCT_PLUS_FORCE_CVAR_UPDATE")
    else
      return
    end
  end

  if x.db.profile.blizzardFCT.floatingCombatTextAllSpellMechanics then
    SetCVar("floatingCombatTextAllSpellMechanics", 1)
  else
    SetCVar("floatingCombatTextAllSpellMechanics", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextAuras then
    SetCVar("floatingCombatTextAuras", 1)
  else
    SetCVar("floatingCombatTextAuras", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextCombatDamage then
    SetCVar("floatingCombatTextCombatDamage", 1)
  else
    SetCVar("floatingCombatTextCombatDamage", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextCombatDamageAllAutos then
    SetCVar("floatingCombatTextCombatDamageAllAutos", 1)
  else
    SetCVar("floatingCombatTextCombatDamageAllAutos", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextCombatDamageDirectionalOffset then
    SetCVar("floatingCombatTextCombatDamageDirectionalOffset", 1)
  else
    SetCVar("floatingCombatTextCombatDamageDirectionalOffset", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextCombatDamageDirectionalScale then
    SetCVar("floatingCombatTextCombatDamageDirectionalScale", 1)
  else
    SetCVar("floatingCombatTextCombatDamageDirectionalScale", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextCombatHealing then
    SetCVar("floatingCombatTextCombatHealing", 1)
  else
    SetCVar("floatingCombatTextCombatHealing", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextCombatHealingAbsorbSelf then
    SetCVar("floatingCombatTextCombatHealingAbsorbSelf", 1)
  else
    SetCVar("floatingCombatTextCombatHealingAbsorbSelf", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextCombatHealingAbsorbTarget then
    SetCVar("floatingCombatTextCombatHealingAbsorbTarget", 1)
  else
    SetCVar("floatingCombatTextCombatHealingAbsorbTarget", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextCombatLogPeriodicSpells then
    SetCVar("floatingCombatTextCombatLogPeriodicSpells", 1)
  else
    SetCVar("floatingCombatTextCombatLogPeriodicSpells", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextCombatState then
    SetCVar("floatingCombatTextCombatState", 1)
  else
    SetCVar("floatingCombatTextCombatState", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextComboPoints then
    SetCVar("floatingCombatTextComboPoints", 1)
  else
    SetCVar("floatingCombatTextComboPoints", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextDamageReduction then
    SetCVar("floatingCombatTextDamageReduction", 1)
  else
    SetCVar("floatingCombatTextDamageReduction", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextDodgeParryMiss then
    SetCVar("floatingCombatTextDodgeParryMiss", 1)
  else
    SetCVar("floatingCombatTextDodgeParryMiss", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextEnergyGains then
    SetCVar("floatingCombatTextEnergyGains", 1)
  else
    SetCVar("floatingCombatTextEnergyGains", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextFloatMode then
    SetCVar("floatingCombatTextFloatMode", 1)
  else
    SetCVar("floatingCombatTextFloatMode", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextFriendlyHealers then
    SetCVar("floatingCombatTextFriendlyHealers", 1)
  else
    SetCVar("floatingCombatTextFriendlyHealers", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextHonorGains then
    SetCVar("floatingCombatTextHonorGains", 1)
  else
    SetCVar("floatingCombatTextHonorGains", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextLowManaHealth then
    SetCVar("floatingCombatTextLowManaHealth", 1)
  else
    SetCVar("floatingCombatTextLowManaHealth", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextPeriodicEnergyGains then
    SetCVar("floatingCombatTextPeriodicEnergyGains", 1)
  else
    SetCVar("floatingCombatTextPeriodicEnergyGains", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextPetMeleeDamage then
    SetCVar("floatingCombatTextPetMeleeDamage", 1)
  else
    SetCVar("floatingCombatTextPetMeleeDamage", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextPetSpellDamage then
    SetCVar("floatingCombatTextPetSpellDamage", 1)
  else
    SetCVar("floatingCombatTextPetSpellDamage", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextReactives then
    SetCVar("floatingCombatTextReactives", 1)
  else
    SetCVar("floatingCombatTextReactives", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextRepChanges then
    SetCVar("floatingCombatTextRepChanges", 1)
  else
    SetCVar("floatingCombatTextRepChanges", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextSpellMechanics then
    SetCVar("floatingCombatTextSpellMechanics", 1)
  else
    SetCVar("floatingCombatTextSpellMechanics", 0)
  end

  if x.db.profile.blizzardFCT.floatingCombatTextSpellMechanicsOther then
    SetCVar("floatingCombatTextSpellMechanicsOther", 1)
  else
    SetCVar("floatingCombatTextSpellMechanicsOther", 0)
  end
end

-- Generic Get/Set methods
local function get0(info) return x.db.profile[info[#info-1]][info[#info]] end
local function set0(info, value) x.db.profile[info[#info-1]][info[#info]] = value; x.cvar_update() end
local function set0_update(info, value) x.db.profile[info[#info-1]][info[#info]] = value; x:UpdateFrames(); x.cvar_update() end
local function get0_1(info) return x.db.profile[info[#info-2]][info[#info]] end
local function set0_1(info, value) x.db.profile[info[#info-2]][info[#info]] = value; x.cvar_update() end
local function getTextIn0(info) return string_gsub(x.db.profile[info[#info-1]][info[#info]], "|", "||") end
local function setTextIn0(info, value) x.db.profile[info[#info-1]][info[#info]] = string_gsub(value, "||", "|"); x.cvar_update() end
local function get1(info) return x.db.profile.frames[info[#info-1]][info[#info]] end
local function set1(info, value) x.db.profile.frames[info[#info-1]][info[#info]] = value; x.cvar_update() end
local function set1_update(info, value) set1(info, value); x:UpdateFrames(info[#info-1]); x.cvar_update() end
local function get2(info) return x.db.profile.frames[info[#info-2]][info[#info]] end
local function set2(info, value) x.db.profile.frames[info[#info-2]][info[#info]] = value; x.cvar_update() end
local function set2_update(info, value) set2(info, value); x:UpdateFrames(info[#info-2]); x.cvar_update() end
local function set2_update_force(info, value) set2(info, value); x:UpdateFrames(info[#info-2]); x.cvar_update(true) end
local function getColor2(info) return unpack(x.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end
local function setColor2(info, r, g, b) x.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end
local function getTextIn2(info) return string_gsub(x.db.profile.frames[info[#info-2]][info[#info]], "|", "||") end
local function setTextIn2(info, value) x.db.profile.frames[info[#info-2]][info[#info]] = string_gsub(value, "||", "|") end
local function getNumber2(info) return tostring(x.db.profile[info[#info-2]][info[#info]]) end
local function setNumber2(info, value) if tonumber(value) then x.db.profile[info[#info-2]][info[#info]] = tonumber(value) end end

local function outgoingSpellColorsHidden(info) return not x.db.profile.frames["outgoing"].standardSpellColor end

local function isFrameEnabled(info) return x.db.profile.frames[info[#info-1]].enabledFrame end
local function isFrameDisabled(info) return not x.db.profile.frames[info[#info-1]].enabledFrame end
local function isFrameItemDisabled(info) return not x.db.profile.frames[info[#info-2]].enabledFrame end
local function isFrameNotScrollable(info) return isFrameItemDisabled(info) or not x.db.profile.frames[info[#info-2]].enableScrollable end
local function isFrameUseCustomFade(info) return not x.db.profile.frames[info[#info-2]].enableCustomFade or isFrameItemDisabled(info) end
local function isFrameFadingDisabled(info) return isFrameUseCustomFade(info) or not x.db.profile.frames[info[#info-2]].enableFade end
local function isFrameIconDisabled(info) return isFrameItemDisabled(info) or not x.db.profile.frames[info[#info-2]].iconsEnabled end

-- This is TEMP
local function isFrameItemEnabled(info) return x.db.profile.frames[info[#info-2]].enabledFrame end


local function setSpecialCriticalOptions(info, value)
  x.db.profile[info[#info-2]].mergeCriticalsWithOutgoing = false
  x.db.profile[info[#info-2]].mergeCriticalsByThemselves = false
  x.db.profile[info[#info-2]].mergeDontMergeCriticals = false
  x.db.profile[info[#info-2]].mergeHideMergedCriticals = false

  x.db.profile[info[#info-2]][info[#info]] = true
end

local function setFormating(info, value)
  x.db.profile.spells.formatAbbreviate = false
  x.db.profile.spells.formatGroups = false

  x.db.profile.spells[info[#info]] = true
end

local function getDBSpells(info)
  return x.db.profile.spells[info[#info]]
end

-- Apply to All variables
local miscFont, miscFontOutline, miscEnableCustomFade;

-- Spell Filter Methods
local checkAdd = {
  listBuffs = false,
  listDebuffs = false,
  listSpells = false,
  listProcs = false,
}

local function getCheckAdd(info) return checkAdd[info[#info-1]] end
local function setCheckAdd(info, value) checkAdd[info[#info-1]] = value end

local function trim(s)
  return ( s:gsub("^%s*(.-)%s*$", "%1") )
end

-- For each 'comma' separated value in 'input' (string) do 'func(value, ...)'
local function foreach(input, comma, func, ...)
  local pattern = ("[^%s]+"):format(comma)
  local s, e = 0, 0
  while e do
    s, e = input:find(pattern, e + 1)
    if s and e then
      func(trim(input:sub(s, e)), ...)
    end
  end
end

local function setSpell(info, value)
  if not checkAdd[info[#info-1]] then
    -- Add Spell
    foreach(value, ';', x.AddFilteredSpell, info[#info-1])
  else
    -- Remove Spell
    foreach(value, ';', x.RemoveFilteredSpell, info[#info-1])
  end
end

local function IsTrackSpellsDisabled() return not x.db.profile.spellFilter.trackSpells end

-- Lists that will be used to show tracked spells
local buffHistory, debuffHistory, spellHistory, procHistory, itemHistory = { }, { }, { }, { }, { }


-- GetSpellTextureFormatted( spellID, message, multistrike, iconSize, justify, strColor, mergeOverride, forceOff )

local function GetBuffHistory()
  for i in pairs(buffHistory) do
    buffHistory[i] = nil
  end

  for i in pairs(x.spellCache.buffs) do
    buffHistory[i] = x:GetSpellTextureFormatted(i, "", 0, 16, nil, nil, nil, true).." "..i
  end

  return buffHistory
end

local function GetDebuffHistory()
  for i in pairs(debuffHistory) do
    debuffHistory[i] = nil
  end

  for i in pairs(x.spellCache.debuffs) do
    debuffHistory[i] = x:GetSpellTextureFormatted(i, "", 0, 16, nil, nil, nil, true).." "..i
  end

  return debuffHistory
end

local function GetSpellHistory()
  for i in pairs(spellHistory) do
    spellHistory[i] = nil
  end

  for i in pairs(x.spellCache.spells) do
    local name = GetSpellInfo(i) or "Unknown Spell ID"
    spellHistory[tostring(i)] = x:GetSpellTextureFormatted(i, "", 0, 16, nil, nil, nil, true).." "..name.." (|cff798BDD"..i.."|r)"
  end

  return spellHistory
end

local function GetProcHistory()
  for i in pairs(procHistory) do
    procHistory[i] = nil
  end

  for i in pairs(x.spellCache.procs) do
    procHistory[i] = x:GetSpellTextureFormatted(i, "", 0, 16, nil, nil, nil, true).." "..i
  end

  return procHistory
end

local function GetItemHistory()
  for i in pairs(itemHistory) do
    itemHistory[i] = nil
  end

  for i in pairs(x.spellCache.items) do
	local name, _, _, _, _, _, _, _, _, texture = GetItemInfo( i )
    itemHistory[i] = sformat("|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s", texture, 16, 16, name)
  end

  return itemHistory
end


addon.options.args["spells"] = {
  name = "Spam Merger",
  type = 'group',
  childGroups = 'tab',
  order = 2,
  args = {

    mergeOptions = {
      name = "Merge Options",
      type = 'group',
      order = 11,
      args = {

        enableMerger = {
          order = 1,
          type = 'toggle',
          name = "Enable Merger",
          get = get0_1,
          set = set0_1,
        },
        enableMergerDebug = {
          order = 2,
          type = 'toggle',
          width = "double",
          name = "Show Spell IDs",
          get = get0_1,
          set = set0_1,
        },

        listSpacer1 = {
          type = "description",
          order = 10,
          name = "\n|cff798BDDMerge Incoming Healing|r:",
          fontSize = 'large',
        },

        mergeHealing = {
          order = 11,
          type = 'toggle',
          name = "Merge Healing by Name",
          desc = "Merges incoming healing by the name of the person that healed you.",
          get = get0_1,
          set = set0_1,
          width = 'double',
        },

        listSpacer2 = {
          type = "description",
          order = 20,
          name = "\n|cff798BDDMerge Multiple Dispells|r:",
          fontSize = 'large',
        },

        mergeDispells = {
          order = 21,
          type = 'toggle',
          name = "Merge Dispells by Spell Name",
          desc = "Merges multiple dispells that you perform together, if the aura name is the same.",
          get = get0_1,
          set = set0_1,
          width = 'double',
        },

        listSpacer3 = {
          type = "description",
          order = 30,
          name = "\n|cff798BDDMerge Auto-Attacks|r:",
          fontSize = 'large',
        },

        mergeSwings = {
          order = 31,
          type = 'toggle',
          name = "Merge Melee Swings",
          desc = "|cffFF0000ID|r 6603 |cff798BDD(Player Melee)|r\n|cffFF0000ID|r 0 |cff798BDD(Pet Melee)|r",
          get = get0_1,
          set = set0_1,
        },

        mergeRanged = {
          order = 32,
          type = 'toggle',
          name = "Merge Ranged Attacks",
          desc = "|cffFF0000ID|r 75",
          get = get0_1,
          set = set0_1,
        },

        listSpacer4 = {
          type = "description",
          order = 40,
          name = "\n|cff798BDDMerge Critical Hits|r (Choose one):",
          fontSize = 'large',
        },

        mergeDontMergeCriticals = {
          order = 41,
          type = 'toggle',
          name = "Don't Merge Critical Hits Together",
          desc = "Crits will not get merged in the critical frame, but they will be included in the outgoing total. |cffFFFF00(Default)|r",
          get = get0_1,
          set = setSpecialCriticalOptions,
          width = 'full',
        },

        mergeCriticalsWithOutgoing = {
          order = 42,
          type = 'toggle',
          name = "Merge Critical Hits with Outgoing",
          desc = "Crits will be merged, but the total merged amount in the outgoing frame includes crits.",
          get = get0_1,
          set = setSpecialCriticalOptions,
          width = 'full',
        },

        mergeCriticalsByThemselves = {
          order = 43,
          type = 'toggle',
          name = "Merge Critical Hits by Themselves",
          desc = "Crits will be merged and the total merged amount in the outgoing frame |cffFF0000DOES NOT|r include crits.",
          get = get0_1,
          set = setSpecialCriticalOptions,
          width = 'full',
        },

        mergeHideMergedCriticals = {
          order = 44,
          type = 'toggle',
          name = "Hide Merged Criticals",
          desc = "Criticals that have been merged with the Outgoing frame will not be shown in the Critical frame",
          get = get0_1,
          set = setSpecialCriticalOptions,
          width = 'full',
        },

      },
    },

    classList = {
      name = "Class Spells", --"List of Mergeable Spells |cff798BDD(Class Specific)|r",
      type = 'group',
      order = 21,
      childGroups = 'select',
      args = {
        title = {
          type = 'description',
          order = 0,
          name = "List of Mergeable Spells |cff798BDD(Class Specific)|r",
          fontSize = "large",
          width = "double",
        },

        --[[  TODO: Add Check all and uncheck all buttons ]]

        mergeListDesc = {
          type = "description",
          order = 1,
          fontSize = "small",
          name = "Uncheck a spell if you do not want it merged. Contact me to add new spells. See |cffFFFF00Credits|r for contact info.\n\n",
        },

        --[[classes = {
          name = "Class Spells",
          type = 'group',
          order = 2,
          childGroups = 'select',
          args = {

          },
        }]]


        ["DEATHKNIGHT"] = { type = 'group', order = 1,  name = "|cffC41F3BDeath Knight|r" },
        ["DEMONHUNTER"] = { type = 'group', order = 2,  name = "|cffA330C9Demon Hunter|r" },
        ["DRUID"]       = { type = 'group', order = 3,  name = "|cffFF7D0ADruid|r" },
        ["HUNTER"]      = { type = 'group', order = 4,  name = "|cffABD473Hunter|r" },
        ["MAGE"]        = { type = 'group', order = 5,  name = "|cff69CCF0Mage|r" },
        ["MONK"]        = { type = 'group', order = 6,  name = "|cff00FF96Monk|r" },
        ["PALADIN"]     = { type = 'group', order = 7,  name = "|cffF58CBAPaladin|r" },
        ["PRIEST"]      = { type = 'group', order = 8,  name = "|cffFFFFFFPriest|r" },
        ["ROGUE"]       = { type = 'group', order = 9,  name = "|cffFFF569Rogue|r" },
        ["SHAMAN"]      = { type = 'group', order = 10, name = "|cff0070DEShaman|r" },
        ["WARLOCK"]     = { type = 'group', order = 11, name = "|cff9482C9Warlock|r" },
        ["WARRIOR"]     = { type = 'group', order = 12, name = "|cffC79C6EWarrior|r" },

      },
    },

    globalList = {
      name = "Global Spells",
      type = 'group',
      order = 22,
      args = {
        title = {
          type = 'description',
          order = 0,
          name = "List of Mergeable Spells |cff798BDD(See Category)|r",
          fontSize = "large",
          width = "double",
        },
        mergeListDesc = {
          type = "description",
          order = 1,
          fontSize = "small",
          name = "Uncheck an item if you do not want it merged. Contact me to add new items. See |cffFFFF00Credits|r for contact info.\n\n",
        },
      },
    },

  },
}

addon.options.args["spellFilter"] = {
  name = "Filters",
  type = "group",
  order = 3,
  args = {
    --[[filterSpacer1 = {
      type = 'description',
      order = 1,
      fontSize = "medium",
      name = "",
    },]]

    filterValues = {
      name = "Minimal Value Thresholds",
      type = 'group',
      order = 10,
      guiInline = true,
      args = {
        listSpacer0 = {
          type = "description",
          order = 0,
          name = "|cff798BDDIncoming Player Power Threshold|r: (Mana, Rage, Energy, etc.)",
          fontSize = "large",
        },

        filterPowerValue = {
          order = 1,
          type = 'input',
          name = "Incoming Power",
          desc = "The minimal amount of player's power required inorder for it to be displayed.",
          set = setNumber2,
          get = getNumber2,
        },

        listSpacer1 = {
          type = "description",
          order = 10,
          name = "\n|cff798BDDOutgoing Damage and Healing Threshold|r:",
          fontSize = "large",
        },

        filterOutgoingDamageValue = {
          order = 11,
          type = 'input',
          name = "Outgoing Damage",
          desc = "The minimal amount of damage required inorder for it to be displayed.",
          set = setNumber2,
          get = getNumber2,
        },

        filterOutgoingHealingValue = {
          order = 12,
          type = 'input',
          name = "Outgoing Healing",
          desc = "The minimal amount of healing required inorder for it to be displayed.",
          set = setNumber2,
          get = getNumber2,
        },

        listSpacer2 = {
          type = "description",
          order = 20,
          name = "\n|cff798BDDIncoming Damage and Healing Threshold|r:",
          fontSize = "large",
        },

        filterIncomingDamageValue = {
          order = 21,
          type = 'input',
          name = "Incoming Damage",
          desc = "The minimal amount of damage required inorder for it to be displayed.",
          set = setNumber2,
          get = getNumber2,
        },

        filterIncomingHealingValue = {
          order = 22,
          type = 'input',
          name = "Incoming Healing",
          set = setNumber2,
          get = getNumber2,
        },
      },
    },

    spellFilter = {
      name = "Track Spell History",
      type = 'group',
      order = 21,
      guiInline = true,
      args = {
        trackSpells = {
          order = 1,
          type = 'toggle',
          name = "Enable History",
          desc = "Track all the spells that you've seen. This will make filtering them out easier.",
          set = set0_1,
          get = get0_1,
        }
      }
    },


    listBuffs = {
      name = "|cffFFFFFFFilter:|r |cff798BDDBuffs|r",
      type = 'group',
      order = 20,
      guiInline = false,
      args = {
        title = {
          order = 0,
          type = "description",
          name = "These options allow you to filter out |cff1AFF1ABuff|r auras that your player gains or loses.  In order to filter them, you need to type the |cffFFFF00exact name of the aura|r (case sensitive).",
        },
        whitelistBuffs = {
          order = 1,
          type = 'toggle',
          name = "Whitelist",
          desc = "Filtered auras gains and fades that are |cff1AFF1ABuffs|r will be on a whitelist (opposed to a blacklist).",
          set = set0_1,
          get = get0_1,
          width = "full",
        },
        spellName = {
          order = 6,
          type = 'input',
          name = "Aura Name",
          desc = "The full, case-sensitive name of the |cff1AFF1ABuff|r you want to filter.\n\nYou can add/remove |cff798BDDmultiple|r entries by separating them with a |cffFF8000semicolon|r (e.g. 'Shadowform;Power Word: Fortitude').",
          set = setSpell,
          get = noop,
        },
        checkAdd = {
          order = 7,
          type = 'toggle',
          name = "Remove",
          desc = "Check to remove the aura from the filtered list.",
          get = getCheckAdd,
          set = setCheckAdd,
        },

        -- This is a feature option that I will enable when I get more time D:
        selectTracked = {
          order = 8,
          type = 'select',
          name = "Buff History:",
          desc = "A list of |cff1AFF1ABuff|r names that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
          disabled = IsTrackSpellsDisabled,
          values = GetBuffHistory,
          get = noop,
          set = setSpell,
        },
      },
    },

    listDebuffs = {
      name = "|cffFFFFFFFilter:|r |cff798BDDDebuffs|r",
      type = 'group',
      order = 30,
      guiInline = false,
      args = {
        title = {
          order = 0,
          type = "description",
          name = "These options allow you to filter out |cffFF1A1ADebuff|r auras that your player gains or loses. In order to filter them, you need to type the |cffFFFF00exact name of the aura|r (case sensitive).",
        },
        whitelistDebuffs = {
          order = 1,
          type = 'toggle',
          name = "Whitelist",
          desc = "Filtered auras gains and fades that are |cffFF1A1ADebuffs|r will be on a whitelist (opposed to a blacklist).",
          set = set0_1,
          get = get0_1,
          width = "full",
        },
        spellName = {
          order = 2,
          type = 'input',
          name = "Aura Name",
          desc = "The full, case-sensitive name of the |cffFF1A1ADebuff|r you want to filter.",
          set = setSpell,
          get = noop,
        },
        checkAdd = {
          order = 3,
          type = 'toggle',
          name = "Remove",
          desc = "Check to remove the aura from the filtered list.",
          get = getCheckAdd,
          set = setCheckAdd,
        },

        -- This is a feature option that I will enable when I get more time D:
        selectTracked = {
          order = 4,
          type = 'select',
          name = "Debuff History:",
          desc = "A list of |cffFF1A1ABuff|r names that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
          disabled = IsTrackSpellsDisabled,
          values = GetDebuffHistory,
          get = noop,
          set = setSpell,
        },
      },
    },

    listProcs = {
      name = "|cffFFFFFFFilter:|r |cff798BDDProcs|r",
      type = 'group',
      order = 40,
      guiInline = false,
      args = {
        title = {
          order = 0,
          type = "description",
          name = "These options allow you to filter out spell |cffFFFF00Procs|r that your player triggers.  In order to filter them, you need to type the |cffFFFF00exact name of the proc|r (case sensitive).",
        },
        whitelistProcs = {
          order = 1,
          type = 'toggle',
          name = "Whitelist",
          desc = "Check for whitelist, uncheck for blacklist.",
          set = set0_1,
          get = get0_1,
          width = "full",
        },
        spellName = {
          order = 6,
          type = 'input',
          name = "Proc Name",
          desc = "The full, case-sensitive name of the |cff1AFF1AProc|r you want to filter.\n\nYou can add/remove |cff798BDDmultiple|r entries by separating them with a |cffFF8000semicolon|r (e.g. 'Shadowform;Power Word: Fortitude').",
          set = setProc,
          get = noop,
        },
        checkAdd = {
          order = 7,
          type = 'toggle',
          name = "Remove",
          desc = "Check to remove the item from the filtered list.",
          get = getCheckAdd,
          set = setCheckAdd,
        },

        -- This is a feature option that I will enable when I get more time D:
        selectTracked = {
          order = 8,
          type = 'select',
          name = "Proc History:",
          desc = "A list of |cff1AFF1AProc|r items that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
          disabled = IsTrackSpellsDisabled,
          values = GetProcHistory,
          get = noop,
          set = setSpell,
        },
      },
    },

    listSpells = {
      name = "|cffFFFFFFFilter:|r |cff798BDDOutgoing Spells|r",
      type = 'group',
      order = 50,
      guiInline = false,
      args = {
        title = {
          order = 0,
          type = "description",
          name = "These options allow you to filter |cff71d5ffOutgoing Spells|r that your player does. In order to filter them, you need to type the |cffFFFF00Spell ID|r of the spell.",
        },
        whitelistSpells = {
          order = 1,
          type = 'toggle',
          name = "Whitelist",
          desc = "Filtered |cff71d5ffOutgoing Spells|r will be on a whitelist (opposed to a blacklist).",
          set = set0_1,
          get = get0_1,
          width = "full",
        },
        spellName = {
          order = 2,
          type = 'input',
          name = "Spell ID",
          desc = "The spell ID of the |cff71d5ffOutgoing Spell|r you want to filter.",
          set = setSpell,
          get = noop,
        },
        checkAdd = {
          order = 3,
          type = 'toggle',
          name = "Remove",
          desc = "Check to remove the spell from the filtered list.",
          get = getCheckAdd,
          set = setCheckAdd,
        },

        -- This is a feature option that I will enable when I get more time D:
        selectTracked = {
          order = 4,
          type = 'select',
          name = "Spell History:",
          desc = "A list of |cff71d5ffOutgoing Spell|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
          disabled = IsTrackSpellsDisabled,
          values = GetSpellHistory,
          get = noop,
          set = setSpell,
        },
      },
    },

    listItems = {
      name = "|cffFFFFFFFilter:|r |cff798BDDItems (Plus)|r",
      type = 'group',
      order = 50,
      guiInline = false,
      args = {
        title = {
          order = 0,
          type = "description",
          name = "These options allow you to filter out |cff8020FFItems|r that your player collects.  In order to filter them, you need to type the |cffFFFF00exact name of the item|r (case sensitive).",
        },
        whitelistItems = {
          order = 1,
          type = 'toggle',
          name = "Whitelist",
          desc = "Filtered |cff798BDDItems (Plus)|r will be on a whitelist (opposed to a blacklist).",
          set = set0_1,
          get = get0_1,
          width = "full",
        },
        spellName = {
          order = 2,
          type = 'input',
          name = "Item ID",
          desc = "The Item ID of the |cff798BDDItem|r you want to filter.",
          set = setSpell,
          get = noop,
        },
        checkAdd = {
          order = 3,
          type = 'toggle',
          name = "Remove",
          desc = "Check to remove the spell from the filtered list.",
          get = getCheckAdd,
          set = setCheckAdd,
        },

        -- This is a feature option that I will enable when I get more time D:
        selectTracked = {
          order = 4,
          type = 'select',
          name = "Item History:",
          desc = "A list of |cff798BDDItem|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
          disabled = IsTrackSpellsDisabled,
          values = GetItemHistory,
          get = noop,
          set = setSpell,
        },
      },
    },


  },
}

addon.options.args["Credits"] = {
  name = "Credits",
  type = 'group',
  order = 4,
  args = {
    title = {
      type = "header",
      order = 0,
      name = "Credits",
    },
    specialThanksTitle = {
      type = 'description',
      order = 1,
      name = "|cffFFFF00Special Thanks|r",
      fontSize = "large",
    },
    specialThanksList = {
      type = 'description',
      order = 2,
      fontSize = "medium",
      name = "  |cffAA0000Tukz|r, |cffAA0000Elv|r, |cffFFFF00Affli|r, |cffFF8000BuG|r, |cff8080FFShestak|r, Nidra, gnangnan, NitZo, Naughtia, Derap, sortokk, ckaotik, Cecile.",
    },
    testerTitleSpace1 = {
      type = 'description',
      order = 3,
      name = " ",
    },

    testerTitle = {
      type = 'description',
      order = 10,
      name = "|cffFFFF00Beta Testers - Version 3.0.0|r",
      fontSize = "large",
    },
    userName1 = {
      type = 'description',
      order = 11,
      fontSize = "medium",
      name = " |cffAAAAFF Alex|r,|cff8080EE BuG|r,|cffAAAAFF Kkthnxbye|r,|cff8080EE Azilroka|r,|cffAAAAFF Prizma|r,|cff8080EE schmeebs|r,|cffAAAAFF Pat|r,|cff8080EE hgwells|r,|cffAAAAFF Jaron|r,|cff8080EE Fitzbattleaxe|r,|cffAAAAFF Nihan|r,|cff8080EE Jaxo|r,|cffAAAAFF Schaduw|r,|cff8080EE sylenced|r,|cffAAAAFF kaleidoscope|r,|cff8080EE Killatones|r,|cffAAAAFF Trokko|r,|cff8080EE Yperia|r,|cffAAAAFF Edoc|r,|cff8080EE Cazart|r,|cffAAAAFF Nevah|r,|cff8080EE Refrakt|r,|cffAAAAFF Thakah|r,|cff8080EE johnis007|r,|cffAAAAFF Sgt|r,|cff8080EE NitZo|r,|cffAAAAFF cptblackgb|r,|cff8080EE pollyzoid|r.",
    },

    testerTitleSpace2 = {
      type = 'description',
      order = 20,
      name = " ",
    },
    curseTitle = {
      type = 'description',
      order = 21,
      name = "|cffFFFF00Beta Testers - Version 4.0.0 (Curse)|r",
      fontSize = "large",
    },
    userName2 = {
      type = 'description',
      order = 22,
      fontSize = "medium",
      name = " |cffAAAAFF CadjieBOOM|r,|cff8080EE Mokal|r,|cffAAAAFF ShadoFall|r,|cff8080EE alloman|r,|cffAAAAFF chhld|r,|cff8080EE chizzlestick|r,|cffAAAAFF egreym|r,|cff8080EE nukme|r,|cffAAAAFF razrwolf|r,|cff8080EE star182|r,|cffAAAAFF zacheklund|r"
    },

    testerTitleSpace3 = {
      type = 'description',
      order = 30,
      name = " ",
    },
    tukuiTitle = {
      type = 'description',
      order = 31,
      name = "|cffFFFF00Beta Testers - Version 4.0.0 (Tukui)|r",
      fontSize = "large",
    },
    userName3 = {
      type = 'description',
      order = 32,
      fontSize = "medium",
      name = " |cffAAAAFF Affiniti|r,|cff8080EE Badinfluence|r,|cffAAAAFF Badinfluence|r,|cff8080EE BuG|r,|cffAAAAFF Curdi|r,|cff8080EE Dorkie|r,|cffAAAAFF Galadeon|r,|cff8080EE HarryDotter|r,|cffAAAAFF Joebacsi21|r,|cff8080EE Kuron|r,|cffAAAAFF Mabb22|r,|cff8080EE Narlya|r,|cffAAAAFF Nihan|r,|cff8080EE Verdell|r,|cffAAAAFF arzelia|r,|cff8080EE blessed|r,|cffAAAAFF djouga|r,|cff8080EE fakemessiah|r,|cffAAAAFF faze|r,|cff8080EE firewall|r,|cffAAAAFF jatha86|r,|cff8080EE jaydogg10|r,|cffAAAAFF jlor|r,|cff8080EE lunariongames|r,|cffAAAAFF stoankold|r",
    },

    testerTitleSpace3Legion = {
      type = 'description',
      order = 33,
      name = " ",
    },
    tukuiTitleLegion = {
      type = 'description',
      order = 34,
      name = "|cffFFFF00Beta Testers - Version 4.2.0 for Legion|r",
      fontSize = "large",
    },
    userName3Legion = {
      type = 'description',
      order = 35,
      fontSize = "medium",
      name = " |cffAAAAFF Azazu|r,|cff8080EE Merathilis|r,|cffAAAAFF Torch|r,|cff8080EE Broni|r,|cffAAAAFF Zylos|r",
    },

    testerTitleSpace4 = {
      type = 'description',
      order = 40,
      name = " ",
    },

    githubTitle = {
      type = 'description',
      order = 41,
      name = "|cffFFFF00Thank You Github Contributors!|r",
      fontSize = "large",
    },
    userName4 = {
      type = 'description',
      order = 42,
      fontSize = "medium",
      name = " |cff22FF80 Tonyleila|r,|cff1AAD59 ckaotik|r,|cff22FF80 Stanzilla|r,|cff1AAD59 Torch (behub)|r,|cff22FF80 vforge|r",
    },

    testerTitleSpace5 = {
      type = 'description',
      order = 50,
      name = " ",
    },

    contactTitle = {
      type = 'description',
      order = 51,
      name = "|cffFFFF00Contact Me|r",
      fontSize = "large",
    },

    contactStep1 = {
      type = 'description',
      order = 52,
      name = "1. GitHub: |cff22FF80https://github.com/dandruff/xCT|r\n\n2. Send a PM to |cffFF8000Dandruff|r at |cff6495EDhttp://tukui.org/|r",
    }
  }
}

addon.options.args["FloatingCombatText"] = {
  name = "Floating Combat Text",
  type = 'group',
  order = 1,
  args = {
    title2 = {
      order = 0,
      type = "description",
      name = "|cffA0A0A0Some changes might require a full|r |cffD0D000Client Restart|r |cffA0A0A0(completely exit out of WoW). Do not|r |cffD00000Alt+F4|r |cffA0A0A0or|r |cffD00000Command+Q|r |cffA0A0A0or your settings might not save. Use '|r|cff798BDD/exit|r|cffA0A0A0' to close the client.|r\n\n",
      fontSize = "small",
    },

    listSpacer1 = {
      type = "description",
      order = 3,
      name = "\n\n|cff798BDDFloating Combat Text|r |cffFF0000Advanced Settings|r:",
      fontSize = 'large',
    },

    bypassCVARUpdates = {
      order = 4,
      type = 'toggle',
      name = "Bypass CVar Updates (requires |cffFF0000/reload|r)",
      desc = "Allows you to bypass xCT+'s CVar engine. This option might help if you have FCT enabled, but it disappears after awhile. Once you set your FCT options, enable this. Requires a UI reload after changing.",
      width = 'full',
      get = function( info ) return x.db.profile.bypassCVars end,
      set = function( info, value ) x.db.profile.bypassCVars = value end,
    },

    listSpacer2 = {
      type = "description",
      order = 5,
      name = "\n\n",
      fontSize = 'large',
    },

    blizzardFCT = {
      name = "", --Blizzard's Floating Combat Text |cffFFFFFF(Head Numbers)|r",
      type = 'group',
      order = 1,
      guiInline = true,
      disabled = isCVarsDisabled,
      args = {
        listSpacer0 = {
          type = "description",
          order = 0,
          name = "|cff798BDDFloating Combat Text Options|r:\n",
          fontSize = 'large',
        },

        -- Damage
        headerDamage = {
          type = "description",
          order = 1,
          name = "|cffFFFF00Damage:|r",
          fontSize = 'medium',
        },

        floatingCombatTextCombatDamage = {
          order = 2,
          name = "Show Damage",
          type = 'toggle',
          desc = "Enable this option if you want to see your damage.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextCombatLogPeriodicSpells = {
          order = 3,
          name = "Show DoTs",
          type = 'toggle',
          desc = "Enable this option if you want to see your damage over time.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextCombatDamageAllAutos = {
          order = 4,
          name = "Show Auto Attacks",
          type = 'toggle',
          desc = "Enable this option if you want to see all auto-attack numbers, rather than hiding non-event numbers.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextPetMeleeDamage = {
          order = 5,
          name = "Show Pet Melee",
          type = 'toggle',
          desc = "Enable this option if you want to see pet's melee damage.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextPetSpellDamage = {
          order = 6,
          name = "Show Pet Spells",
          type = 'toggle',
          desc = "Enable this option if you want to see pet's spell damage.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextDamageReduction = {
          order = 7,
          name = "Show Damage Reduction",
          type = 'toggle',
          desc = "New option in Legion. Updating description soon.",
          get = get0,
          set = set0_update,
        },

        -- Healing and Absorbs
        headerHealingAbsorbs = {
          type = "description",
          order = 10,
          name = "\n|cffFFFF00Healing and Absorbs:|r",
          fontSize = 'medium',
        },

        floatingCombatTextCombatHealing = {
          order = 11,
          name = "Show Healing",
          type = 'toggle',
          desc = "Enable this option if you want to see your healing.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextFriendlyHealers = {
          order = 12,
          name = "Show Friendly Healers",
          type = 'toggle',
          desc = "New option in Legion. Updating description soon.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextCombatHealingAbsorbSelf = {
          order = 13,
          name = "Show Absorbs (Self)",
          type = 'toggle',
          desc = "Enable this option if you want to see shields that are put on you.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextCombatHealingAbsorbTarget = {
          order = 14,
          name = "Show Absorbs (Target)",
          type = 'toggle',
          desc = "Enable this option if you want to see shields that are put on your target.",
          get = get0,
          set = set0_update,
        },


        -- Gains
        headerGains = {
          type = "description",
          order = 20,
          name = "\n|cffFFFF00Player Gains:|r",
          fontSize = 'medium',
        },

        floatingCombatTextEnergyGains = {
          order = 21,
          name = "Show Energy",
          type = 'toggle',
          desc = "Enable this option if you want to see class engery gains.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextPeriodicEnergyGains = {
          order = 21,
          name = "Show Energy (Periodic)",
          type = 'toggle',
          desc = "Enable this option if you want to see class engery gains that happen over time.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextComboPoints = {
          order = 22,
          name = "Show Combo Points",
          type = 'toggle',
          desc = "Enable this option if you want to see combo point gains.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextHonorGains = {
          order = 23,
          name = "Show Honor",
          type = 'toggle',
          desc = "Enable this option if you want to see your honor point gains.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextRepChanges = {
          order = 24,
          name = "Show Rep Changes",
          type = 'toggle',
          desc = "Enable this option if you want to see your reputation gains or losses.",
          get = get0,
          set = set0_update,
        },


        -- Status Effects
        headerStatusEffects = {
          type = "description",
          order = 30,
          name = "\n|cffFFFF00Status Effects:|r",
          fontSize = 'medium',
        },

        floatingCombatTextDodgeParryMiss = {
          order = 31,
          name = "Show Miss Types",
          type = 'toggle',
          desc = "Enable this option if you want to see misses (dodges, parries, etc).",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextAuras = {
          order = 32,
          name = "Show Auras",
          type = 'toggle',
          desc = "New option in Legion. Updating description soon.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextSpellMechanics = {
          order = 33,
          name = "Show Effects (Mine)",
          type = 'toggle',
          desc = "Enable if you want to see your effects (snare, root, etc).",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextSpellMechanicsOther = {
          order = 34,
          name = "Show Effects (Group)",
          type = 'toggle',
          desc = "Enable if you want to see other effects (snare, root, etc) from your group.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextAllSpellMechanics = {
          order = 35,
          name = "Show Effects (All)",
          type = 'toggle',
          desc = "Enable if you want to see all effects (snare, root, etc) from anyone.",
          get = get0,
          set = set0_update,
        },

        CombatThreatChanges = {
          order = 36,
          type = 'toggle',
          name = "Show Threat Changes",
          desc = "Enable this option if you want to see threat changes.",
          get = get0,
          set = set0_update,
        },


        -- Player's Status
        headerPlayerStatus = {
          type = "description",
          order = 40,
          name = "\n|cffFFFF00Player Status:|r",
          fontSize = 'medium',
        },

        floatingCombatTextCombatState = {
          order = 41,
          name = "Show Combat State",
          type = 'toggle',
          desc = "Enable this option if you want to see when you are leaving and entering combat.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextLowManaHealth = {
          order = 42,
          name = "Show Low HP/Mana",
          type = 'toggle',
          desc = "Enable this option if you want to see when you are low mana and health.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextReactives = {
          order = 43,
          name = "Show Reactives",
          type = 'toggle',
          desc = "Enable this option if you want to see your spell reactives (Kill Shot, Shadow Word: Death, etc).",
          get = get0,
          set = set0_update,
        },


        -- Misc
        --[[
        headerMisc = {
          type = "description",
          order = 20,
          name = "|cffFFFF00Misc:|r",
          fontSize = 'medium',
        },

        floatingCombatTextCombatDamageDirectionalOffset = {
          order = 51,
          name = "Show Damage",
          type = 'toggle',
          desc = "Amount to offset directional damage numbers when they start.",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextCombatDamageDirectionalScale = {
          order = 51,
          name = "Show Damage",
          type = 'toggle',
          desc = "Directional damage numbers movement scale (0 = no directional numbers)",
          get = get0,
          set = set0_update,
        },

        floatingCombatTextFloatMode = {
          order = 51,
          name = "Show Damage",
          type = 'range',
          desc = "The combat text float mode.",
          
          min = 1, max = 100,
          get = get0,
          set = set0_update,
        },]]













        --[==[
        CombatDamage = {
          order = 2,
          type = 'toggle',
          name = "Show Damage",
          desc = "Enable this option if you want your damage as Floating Combat Text.",
          get = get0,
          set = set0_update,
        },

        CombatLogPeriodicSpells = {
          order = 3,
          type = 'toggle',
          name = "Show Damage over Time",
          desc = "Enable this option if you want your DoT's as Floating Combat Text.",
          get = get0,
          set = set0_update,
          disabled = function(info) return isCVarsDisabled( ) or not x.db.profile.blizzardFCT.CombatDamage end,
        },

        PetMeleeDamage = {
          order = 4,
          type = 'toggle',
          name = "Show Pet Melee Damage",
          desc = "Enable this option if you want your pet's melee damage as Floating Combat Text.",
          get = get0,
          set = set0_update,
          disabled = function(info) return isCVarsDisabled( ) or not x.db.profile.blizzardFCT.CombatDamage end,
        },

        CombatHealing = {
          order = 5,
          type = 'toggle',
          name = "Show Healing",
          desc = "Enable this option if you want your healing as Floating Combat Text.",
          get = get0,
          set = set0_update,
        },

        CombatHealingAbsorbTarget = {
          order = 6,
          type = 'toggle',
          name = "Show Absorbs",
          desc = "Enable this option if you want your aborbs as Floating Combat Text.",
          get = get0,
          set = set0_update,
        },

        

        -- Floating Combat Text Effects
        fctSpellMechanics = {
          order = 8,
          type = 'toggle',
          name = "Show Effects",
          desc = "Enable this option if you want to see your snares and roots.",
          get = get0,
          set = set0_update,
        },

        fctSpellMechanicsOther = {
          order = 9,
          type = 'toggle',
          name = "Show Other's Effects",
          desc = "Enable this option if you want to see other player's snares and roots too.",
          get = get0,
          set = set0_update,
          disabled = function(info) return isCVarsDisabled( ) or not x.db.profile.blizzardFCT.fctSpellMechanics end,
        },

        listSpacer2 = {
          type = "description",
          order = 20,
          name = "\n\n|cff798BDDFloating Combat Text Target Mode|r:",
          fontSize = 'large',
        },

        CombatDamageStyle = {
          type = "select",
              order = 21,
          name = "Target Mode:",
          values = {
            [1] = COMBAT_TARGET_MODE_NEW,
            [2] = COMBAT_TARGET_MODE_OLD,
          },
          get = get0,
          set = set0_update,
          desc = "Allows you to change how your target's FCT is displayed.\n\n|cff798BDD"..COMBAT_TARGET_MODE_NEW.."|r - |cffFF8000(Fastest)|r displays damage on your target in an arc. New in WoD.\n\n|cff798BDD"..COMBAT_TARGET_MODE_OLD.."|r - |cffFF8000(Slower)|r displays damage floating up. This was the old default in MoP.",
        },

        listSpacer3 = {
          type = "description",
          order = 30,
          name = "\n\n|cff798BDDFloating Combat Text Font|r:",
          fontSize = 'large',
        },

        enabled = {
          order = 31,
          type = 'toggle',
          name = "Customize",
          get = get0,
          set = set0_update,
        },

        font = {
          type = 'select', dialogControl = 'LSM30_Font',
          order = 32,
          name = "Blizzard's FCT Font",
          desc = "Set the font Blizzard's head numbers (|cffFFFF00Default:|r Friz Quadrata TT)",
          values = AceGUIWidgetLSMlists.font,
          get = get0,
          set = function(info, value)
            x.db.profile.blizzardFCT.font = value
            x.db.profile.blizzardFCT.fontName = LSM:Fetch("font", value)

            --x:UpdateFrames()
            --x.cvar_update()
          end,
          disabled = function(info) return isCVarsDisabled( ) or not x.db.profile.blizzardFCT.enabled end,
        },
        ]==]




      },
    },
    --[[
    battlePetFCT = {
      name = "Battle Pets",
      type = 'group',
      order = 2,
      args = {
        title1 = {
          order = 0,
          type = "description",
          name = "Battle Pet Settings to go in here :)",
        },
      },
    },
    ]]
  },
}

addon.options.args["Frames"] = {
  name = "Frames",
  type = 'group',
  order = 0,
  args = {


    frameSettings = {
      name = "Frame Settings ",
      type = 'group',
      order = 1,
      guiInline = true,
      args = {

        listSpacer0 = {
          type = "description",
          order = 1,
          name = "|cff798BDDWhen Moving the Frames|r:",
          fontSize = 'large',
        },

        showGrid = {
          order = 2,
          type = 'toggle',
          name = "Show Align Grid",
          desc = "Shows a grid after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better.",
          get = get0,
          set = set0,
        },

        showPositions = {
          order = 3,
          type = 'toggle',
          name = "Show Positions",
          desc = "Shows the locations and sizes of your frames after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better.",
          get = get0,
          set = set0,
        },

        listSpacer1 = {
          type = "description",
          order = 10,
          name = "\n|cff798BDDWhen Showing the Frames|r:",
          fontSize = 'large',
        },

        frameStrata = {
          type = 'select',
          order = 11,
          name = "Frame Strata",
          desc = "The Z-Layer to place the |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames onto. If you find that another addon is in front of |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames, try increasing the Frame Strata.",
          values = {
            --["1PARENT"]             = "Parent |cffFF0000(Lowest)|r",
            ["2BACKGROUND"]         = "Background |cffFF0000(Lowest)|r",
            ["3LOW"]                = "Low",
            ["4MEDIUM"]             = "Medium",
            ["5HIGH"]               = "High |cffFFFF00(Default)|r",
            ["6DIALOG"]             = "Dialog",
            ["7FULLSCREEN"]         = "Fullscreen",
            ["8FULLSCREEN_DIALOG"]  = "Fullscreen Dialog",
            ["9TOOLTIP"]            = "ToolTip |cffAAFF80(Highest)|r",
          },
          get = get0,
          set = set0_update,
        },

        listSpacer2 = {
          type = "description",
          order = 20,
          name = "\n|cff798BDDWhen Leaving Combat|r:",
          fontSize = 'large',
        },

        clearLeavingCombat = {
          order = 21,
          type = 'toggle',
          name = "Clear Frames",
          desc = "Enable this option if you have problems with 'floating' icons.",
          width = "full",
          get = get0,
          set = set0,
        },

      },
    },

    spacer1 = {
      type = 'description',
      name = "\n",
      order = 2,
    },

    megaDamage = {
      name = "Number Format Settings",
      type = 'group',
      order = 3,
      guiInline = true,
      args = {
        listSpacer0 = {
          type = "description",
          order = 0,
          name = "|cff798BDDFormat Numbers in the Frames|r (Choose one):",
          fontSize = 'large',
        },
        formatAbbreviate = {
          type = 'toggle',
          order = 1,
          name = "Abbreviate Numbers",
          set = setFormating,
          get = getDBSpells,
        },
        formatGroups = {
          type = 'toggle',
          order = 2,
          name = "Decimal Marks",
          desc = "Groups decimals and separates them by commas; this allows for better responsiveness when reading numbers.\n\n|cffFF0000EXAMPLE|r |cff798BDD12,890|r",
          set = setFormating,
          get = getDBSpells,
        },

        abbDesc = {
          type = "description",
          order = 9,
          name = "\n\n|cffFFFF00PLEASE NOTE|r |cffAAAAAAFormat settings need to be independently enabled on each frame through its respective settings page.|r",
          fontSize = 'small',
        },

        listSpacer1 = {
          type = "description",
          order = 10,
          name = "\n|cff798BDDAdditional Abbreviation Settings|r:",
          fontSize = 'large',
        },
        thousandSymbol = {
          order = 11,
          type = 'input',
          name = "Thousand",
          desc = "Symbol for: |cffFF0000Thousands|r |cff798BDD(10e+3)|r",
          get = getTextIn0,
          set = setTextIn0,
        },
        millionSymbol = {
          order = 12,
          type = 'input',
          name = "Million",
          desc = "Symbol for: |cffFF0000Millions|r |cff798BDD(10e+6)|r",
          get = getTextIn0,
          set = setTextIn0,
        },
        decimalPoint = {
          order = 13,
          type = 'toggle',
          name = "Single Decimal",
          desc = "Shows a single decimal when abbreviating the value (e.g. will show |cff798BDD5.9K|r instead of |cff798BDD6K|r).",
          get = get0,
          set = set0,
        },
      },
    },

    spacer2 = {
      type = 'description',
      name = "\n",
      order = 4,
    },

    miscFonts = {
      order = 5,
      type = 'group',
      guiInline = true,
      name = "Global Frame Settings |cffFFFFFF(Experimental)|r",
      args = {
        miscDesc = {
          type = "description",
          order = 0,
          name = "The following settings are marked as experimental. They should all work, but they might not be very useful. Expect chanrges or updates to these in the near future.\n\nClick |cffFFFF00Set All|r to apply setting to all |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames.\n",
        },


        font = {
          type = 'select', dialogControl = 'LSM30_Font',
          order = 1,
          name = "Font",
          desc = "Set the font of the frame.",
          values = AceGUIWidgetLSMlists.font,
          get = function(info) return miscFont end,
          set = function(info, value) miscFont = value end,
        },

        applyFont = {
          type = 'execute',
          order = 2,
          name = "Set All",
          width = "half",
          func = function()
            if miscFont then
              for framename, settings in pairs(x.db.profile.frames) do
                settings.font = miscFont
              end
              x:UpdateFrames()
            end
          end,
        },

        spacer1 = {
          type = 'description',
          order = 3,
          name = "",
        },

        fontOutline = {
          type = 'select',
          order = 4,
          name = "Font Outline",
          desc = "Set the font outline.",
          values = {
            ['1NONE'] = "None",
            ['2OUTLINE'] = 'OUTLINE',
            -- BUG: Setting font to monochrome AND above size 16 will crash WoW
            -- http://us.battle.net/wow/en/forum/topic/6470967362
            ['3MONOCHROME'] = 'MONOCHROME',
            ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
            ['5THICKOUTLINE'] = 'THICKOUTLINE',
          },
          get = function(info) return miscFontOutline end,
          set = function(info, value) miscFontOutline = value end,
        },

        applyFontOutline = {
          type = 'execute',
          order = 5,
          name = "Set All",
          width = "half",
          func = function()
            if miscFontOutline then
              for framename, settings in pairs(x.db.profile.frames) do
                settings.fontOutline = miscFontOutline
              end
              x:UpdateFrames()
            end
          end,
        },

        spacer2 = {
          type = 'description',
          order = 6,
          name = "",
        },

        customFade = {
          type = 'toggle',
          order = 7,
          name = "Use Custom Fade",
          desc = "Allows you to customize the fade time of each frame.",
          get = function(info) return miscEnableCustomFade end,
          set = function(info, value) miscEnableCustomFade = value end,
        },

        applyCustomFade = {
          type = 'execute',
          order = 8,
          name = "Set All",
          width = "half",
          func = function()
            if miscEnableCustomFade ~= nil then
              for framename, settings in pairs(x.db.profile.frames) do
                if settings.enableCustomFade ~= nil then
                  settings.enableCustomFade = miscEnableCustomFade
                end
              end
              x:UpdateFrames()
            end
          end,
        },

      },
    },

    spacer3 = {
      type = 'description',
      name = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
      order = 6,
    },

--[[ XCT+ The Frames: ]]
    general = {
      name = "|cffFFFFFFGeneral|r",
      type = 'group',
      order = 11,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                --[1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot, Currency & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },
            scrollableInCombat = {
              order = 13,
              type = 'toggle',
              name = "Disable in Combat",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameFading = {
              type = 'description',
              order = 20,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 21,
              type = 'toggle',
              name = "Use Custom Fade",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 22,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 23,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 24,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 64, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },

            iconSizeSettings = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDIcon Size Settings|r:",
              fontSize = 'large',
            },
            iconsEnabled = {
              order = 11,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = get2,
              set = set2,
              disabled = isFrameItemDisabled,
            },
            iconsSize = {
              order = 12,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
              disabled = isFrameIconDisabled,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

        specialTweaks = {
          order = 40,
          name = "Special Tweaks",
          type = 'group',
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showInterrupts = {
              order = 1,
              type = 'toggle',
              name = "Interrupts",
              desc = "Display the spell you successfully interrupted.",
              get = get2,
              set = set2,
            },
            showDispells = {
              order = 2,
              type = 'toggle',
              name = "Dispell/Steal",
              desc = "Show the spell that you dispelled or stole.",
              get = get2,
              set = set2,
            },
            showPartyKills = {
              order = 3,
              type = 'toggle',
              name = "Unit Killed",
              desc = "Display unit that was killed by your final blow.",
              get = get2,
              set = set2,
            },
            showBuffs = {
              order = 4,
              type = 'toggle',
              name = "Buff Gains/Fades",
              desc = "Display the names of helpful auras |cff00FF00(Buffs)|r that you gain and lose.",
              get = get2,
              set = set2,
            },
            showDebuffs = {
              order = 5,
              type = 'toggle',
              name = "Debuff Gains/Fades",
              desc = "Display the names of harmful auras |cffFF0000(Debuffs)|r that you gain and lose.",
              get = get2,
              set = set2,
            },
            showLowManaHealth = {
              order = 6,
              type = 'toggle',
              name = "Low Mana/Health",
              desc = "Displays 'Low Health/Mana' when your health/mana reaches the low threshold.",
              get = get2,
              set = set2,
            },
            showCombatState = {
              order = 7,
              type = 'toggle',
              name = "Leave/Enter Combat",
              desc = "Displays when the player is leaving or entering combat.",
              get = get2,
              set = set2,
            },
            showRepChanges = {
              order = 8,
              type = 'toggle',
              name = "Show Reputation",
              desc = "Displays your player's reputation gains and losses.",
              get = get2,
              set = set2,
            },
            showHonorGains = {
              order = 9,
              type = 'toggle',
              name = "Show Honor",
              desc = "Displays your player's honor gains.",
              get = get2,
              set = set2,
            },
          },
        },

      },
    },

    outgoing = {
      name = "|cffFFFFFFOutgoing|r",
      type = 'group',
      order = 12,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                --[2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot, Currency & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },
            scrollableInCombat = {
              order = 13,
              type = 'toggle',
              name = "Disable in Combat",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameFading = {
              type = 'description',
              order = 30,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 31,
              type = 'toggle',
              name = "Use Custom Fade",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 32,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 33,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 34,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 64, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },

            iconSizeSettings = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDIcon Size Settings|r:",
              fontSize = 'large',
            },
            iconsEnabled = {
              order = 11,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = get2,
              set = set2,
              disabled = isFrameItemDisabled,
            },
            iconsSize = {
              order = 12,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
              disabled = isFrameIconDisabled,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

        specialTweaks = {
          order = 40,
          type = 'group',
          name = "Special Tweaks",
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            enableOutDmg = {
              order = 1,
              type = 'toggle',
              name = "Show Outgoing Damage",
              desc = "Show damage you do.",
              get = get2,
              set = set2,
            },
            enableOutHeal = {
              order = 2,
              type = 'toggle',
              name = "Show Outgoing Healing",
              desc = "Show healing you do.",
              get = get2,
              set = set2,
            },
            enablePetDmg = {
              order = 3,
              type = 'toggle',
              name = "Show Pet Damage",
              desc = "Show your pet's damage.",
              get = get2,
              set = set2,
            },
            enableAutoAttack = {
              order = 4,
              type = 'toggle',
              name = "Show Auto Attack",
              desc = "Show your auto attack damage.",
              get = get2,
              set = set2,
            },
            enableDotDmg = {
              order = 5,
              type = 'toggle',
              name = "Show DoTs",
              desc = "Show your Damage-Over-Time (DOT) damage. (|cffFF0000Requires:|r Outgoing Damage)",
              get = get2,
              set = set2,
            },
            enableHots = {
              order = 6,
              type = 'toggle',
              name = "Show HoTs",
              desc = "Show your Heal-Over-Time (HOT) healing. (|cffFF0000Requires:|r Outgoing Healing)",
              get = get2,
              set = set2,
            },
            enableImmunes = {
              order = 7,
              type = 'toggle',
              name = "Show Immunes",
              desc = "Display 'Immune' when your target cannot take damage.",
              get = get2,
              set = set2,
            },
            enableMisses = {
              order = 8,
              type = 'toggle',
              name = "Show Miss Types",
              desc = "Display 'Miss', 'Dodge', 'Parry' when you miss your target.",
              get = get2,
              set = set2,
            },
          },
        },

      },
    },

    critical = {
      name = "|cffFFFFFFOutgoing|r |cff798BDD(Criticals)|r",
      type = 'group',
      order = 13,
      childGroups = 'tab',
      args = {


        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                --[3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot, Currency & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },
            scrollableInCombat = {
              order = 13,
              type = 'toggle',
              name = "Disable in Combat",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameFading = {
              type = 'description',
              order = 30,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 31,
              type = 'toggle',
              name = "Use Custom Fade",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 32,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 33,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 34,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 64, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },

            iconSizeSettings = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDIcon Size Settings|r:",
              fontSize = 'large',
            },
            iconsEnabled = {
              order = 11,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = get2,
              set = set2,
              disabled = isFrameItemDisabled,
            },
            iconsSize = {
              order = 12,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
              disabled = isFrameIconDisabled,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

        specialTweaks = {
          order = 40,
          type = 'group',
          name = "Special Tweaks",
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showSwing = {
              order = 1,
              type = 'toggle',
              name = "Show Auto Attacks",
              desc = "Show Auto Attack and Swings criticals in this frame. If disabled here, they are automatically shown in the Outgoing frame and can be completely disabled there.",
              get = get2,
              set = set2,
            },
            prefixSwing = {
              order = 2,
              type = 'toggle',
              name = "Show Auto Attacks (Pre)Postfix",
              desc = "Make Auto Attack and Swing criticals more visible by adding the prefix and postfix.",
              get = get2,
              set = set2,
            },

            criticalAppearance = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDCritical Appearance|r:",
              fontSize = 'large',
            },
            critPrefix = {
              order = 11,
              type = 'input',
              name = "Prefix",
              desc = "Prefix this value to the beginning when displaying a critical amount.",
              get = getTextIn2,
              set = setTextIn2,
              disabled = isFrameItemDisabled,
            },
            critPostfix = {
              order = 12,
              type = 'input',
              name = "Postfix",
              desc = "Postfix this value to the end when displaying a critical amount.",
              get = getTextIn2,
              set = setTextIn2,
              disabled = isFrameItemDisabled,
            },
          },

        },
      },
    },

    damage = {
      name = "|cffFFFFFFIncoming|r |cff798BDD(Damage)|r",
      type = 'group',
      order = 14,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                --[4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot, Currency & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },
            scrollableInCombat = {
              order = 13,
              type = 'toggle',
              name = "Disable in Combat",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameFading = {
              type = 'description',
              order = 20,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 21,
              type = 'toggle',
              name = "Use Custom Fade",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 22,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 23,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 24,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 64, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

        specialTweaks = {
          order = 40,
          name = "Special Tweaks",
          type = 'group',
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showDodgeParryMiss = {
              order = 1,
              type = 'toggle',
              name = "Show Miss Types",
              desc = "Displays Dodge, Parry, or Miss when you miss incoming damage.",
              get = get2,
              set = set2,
            },
            showDamageReduction = {
              order = 2,
              type = 'toggle',
              name = "Show Reductions",
              desc = "Formats incoming damage to show how much was absorbed.",
              get = get2,
              set = set2,
            },
          },
        },
      },
    },

    healing = {
      name = "|cffFFFFFFIncoming|r |cff798BDD(Healing)|r",
      type = 'group',
      order = 15,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                --[5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot, Currency & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },
            scrollableInCombat = {
              order = 13,
              type = 'toggle',
              name = "Disable in Combat",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameFading = {
              type = 'description',
              order = 20,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 21,
              type = 'toggle',
              name = "Use Custom Fade",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 22,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 23,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 24,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 64, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

        specialTweaks = {
          order = 40,
          name = "Special Tweaks",
          type = 'group',
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showFriendlyHealers = {
              order = 1,
              type = 'toggle',
              name = "Show Names",
              desc = "Shows the healer names next to incoming heals.\n|cffFF0000Requires:|r CVar Engine in order to change.",
              get = get2,
              set = set2,
            },
            enableClassNames = {
              order = 2,
              type = 'toggle',
              name = "Class Color Names",
              desc = "Color healer names by class. \n\n|cffFF0000Requires:|r Healer in |cffAAAAFFParty|r or |cffFF8000Raid|r",
              get = get2,
              set = set2,
            },
            enableRealmNames = {
              order = 3,
              type = 'toggle',
              name = "Show Realm Names",
              desc = "Show incoming healer names with their realm name.",
              get = get2,
              set = set2,
            },
            enableOverHeal = {
              order = 4,
              type = 'toggle',
              name = "Show Overheals",
              desc = "Show the overhealing you do in your heals. Switch off to not show overheal and make healing less spamming.",
              get = get2,
              set = set2,
            },
            enableSelfAbsorbs = {
              order = 5,
              type = 'toggle',
              name = "Show Absorbs",
              desc = "Shows incoming absorbs.",
              get = get2,
              set = set2,
            },
            showOnlyMyHeals = {
              order = 6,
              type = 'toggle',
              name = "Show My Heals Only",
              desc = "Shows only the player's healing done to himself or herself.",
              get = get2,
              set = set2,
            },
            showOnlyPetHeals = {
              order = 7,
              type = 'toggle',
              name = "Show Pet Heals Too",
              desc = "Will also attempt to show the player pet's healing.",
              get = get2,
              set = set2,
              disabled = function() return not x.db.profile.frames.healing.showOnlyMyHeals end
            },
          },
        },
      },
    },

    class = {
      name = "|cffFFFFFFClass Combo Points|r",
      type = 'group',
      order = 16,
      childGroups = 'tab',
      args = {
        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'description',
              order = 2,
              name = "\n|cffFF0000Secondary Frame Not Available|r - |cffFFFFFFThis frame cannot output to another frame when it is disabled.\n\n",
              width = "double",
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            --[[frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },
            scrollableInCombat = {
              order = 13,
              type = 'toggle',
              name = "Disable in Combat",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },]]
          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 64, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

      },
    },

    power = {
      name = "|cffFFFFFFClass Power|r",
      type = 'group',
      order = 17,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                --[6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot, Currency & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },
            scrollableInCombat = {
              order = 13,
              type = 'toggle',
              name = "Disable in Combat",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameFading = {
              type = 'description',
              order = 20,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 21,
              type = 'toggle',
              name = "Use Custom Fade",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 22,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 23,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 24,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 64, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

        specialTweaks = {
          order = 40,
          name = "Special Tweaks",
          type = 'group',
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showEnergyGains = {
              order = 1,
              type = 'toggle',
              name = "Show Energy Gains",
              desc = "Show instant energy gains.",
              get = get2,
              set = set2,
            },
            showPeriodicEnergyGains = {
              order = 2,
              type = 'toggle',
              name = "Show Periodic Energy Gains",
              desc = "Show energy gained over time.",
              get = get2,
              set = set2,
            },
            showEnergyType = {
              order = 3,
              type = 'toggle',
              name = "Show Energy Type",
              desc = "Show the type of energy that you are gaining.",
              get = get2,
              set = set2,
            },

            title1 = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDFilter Resources|r:",
              fontSize = 'large',
            },
            title2 = {
              type = 'description',
              order = 11,
              name = "Check the energies that you do not wish to be displayed for your character:",
              fontSize = 'small',
            },

            disableResource_MANA = {
              order = 20,
              type = 'toggle',
              name = "Disable |cff798BDD"..MANA,
              get = get2,
              set = set2,
              width = "full",
            },
            disableResource_RAGE = {
              order = 21,
              type = 'toggle',
              name = "Disable |cff798BDD"..RAGE,
              get = get2,
              set = set2,
              width = "full",
            },
            disableResource_FOCUS = {
              order = 22,
              type = 'toggle',
              name = "Disable |cff798BDD"..FOCUS,
              get = get2,
              set = set2,
              width = "full",
            },
            disableResource_ENERGY = {
              order = 23,
              type = 'toggle',
              name = "Disable |cff798BDD"..ENERGY,
              get = get2,
              set = set2,
              width = "full",
            },
            disableResource_CHI = {
              order = 24,
              type = 'toggle',
              name = "Disable |cff798BDD"..CHI,
              get = get2,
              set = set2,
              width = "full",
            },
            disableResource_RUNES = {
              order = 25,
              type = 'toggle',
              name = "Disable |cff798BDD"..RUNES,
              get = get2,
              set = set2,
              width = "full",
            },
            disableResource_RUNIC_POWER = {
              order = 26,
              type = 'toggle',
              name = "Disable |cff798BDD"..RUNIC_POWER,
              get = get2,
              set = set2,
              width = "full",
            },
            disableResource_SOUL_SHARDS = {
              order = 27,
              type = 'toggle',
              name = "Disable |cff798BDD"..SOUL_SHARDS,
              get = get2,
              set = set2,
              width = "full",
            },
            disableResource_ECLIPSE_negative = {
              order = 28,
              type = 'toggle',
              name = "Disable |cff798BDD"..ECLIPSE.."|r (Negative)",
              get = get2,
              set = set2,
              width = "full",
            },
            disableResource_ECLIPSE_positive = {
              order = 28,
              type = 'toggle',
              name = "Disable |cff798BDD"..ECLIPSE.."|r (Positive)",
              get = get2,
              set = set2,
              width = "full",
            },
            disableResource_HOLY_POWER = {
              order = 29,
              type = 'toggle',
              name = "Disable |cff798BDD"..HOLY_POWER,
              get = get2,
              set = set2,
              width = "full",
            },

          },
        },
      },
    },

    procs = {
      name = "|cffFFFFFFSpecial Effects|r |cff798BDD(Procs)|r",
      type = 'group',
      order = 18,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2_update,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                --[7] = "Special Effects (Procs)",
                [8] = "Loot, Currency & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },
            scrollableInCombat = {
              order = 13,
              type = 'toggle',
              name = "Disable in Combat",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameFading = {
              type = 'description',
              order = 20,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 21,
              type = 'toggle',
              name = "Use Custom Fade",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 22,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 23,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 24,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 64, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },

            iconSizeSettings = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDIcon Size Settings|r:",
              fontSize = 'large',
            },
            iconsEnabled = {
              order = 11,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = get2,
              set = set2,
              disabled = isFrameItemDisabled,
            },
            iconsSize = {
              order = 12,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
              disabled = isFrameIconDisabled,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

      },
    },

    loot = {
      name = "|cffFFFFFFLoot, Currency & Money|r",
      type = 'group',
      order = 19,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                --[8] = "Loot, Currency & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },
            scrollableInCombat = {
              order = 13,
              type = 'toggle',
              name = "Disable in Combat",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameFading = {
              type = 'description',
              order = 30,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 31,
              type = 'toggle',
              name = "Use Custom Fade",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 32,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 33,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 34,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 64, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },

            iconSizeSettings = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDIcon Size Settings|r:",
              fontSize = 'large',
            },
            iconsEnabled = {
              order = 11,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = get2,
              set = set2,
              disabled = isFrameItemDisabled,
            },
            iconsSize = {
              order = 12,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
              disabled = isFrameIconDisabled,
            },
          },
        },

        specialTweaks = {
          order = 40,
          type = 'group',
          name = "Special Tweaks",
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showMoney = {
              order = 1,
              type = 'toggle',
              name = "Looted Money",
              desc = "Displays money that you pick up.",
              get = get2,
              set = set2,
            },
            showItems = {
              order = 2,
              type = 'toggle',
              name = "Looted Items",
              desc = "Displays items that you pick up.",
              get = get2,
              set = set2,
            },
            showCurrency = {
              order = 3,
              type = 'toggle',
              name = "Gained Currency",
              desc = "Displays currecy that you gain.",
              get = get2,
              set = set2,
            },
            showItemTypes = {
              order = 4,
              type = 'toggle',
              name = "Show Item Types",
              desc = "Formats the looted message to also include the type of item (e.g. Trade Goods, Armor, Junk, etc.).",
              get = get2,
              set = set2,
            },
            showItemTotal = {
              order = 5,
              type = 'toggle',
              name = "Total Items",
              desc = "Displays how many items you have in your bag.",
              get = get2,
              set = set2,
            },
            showCrafted = {
              order = 6,
              type = 'toggle',
              name = "Crafted Items",
              desc = "Displays items that you crafted.",
              get = get2,
              set = set2,
            },
            showQuest = {
              order = 7,
              type = 'toggle',
              name = "Quest Items",
              desc = "Displays items that pertain to a quest.",
              get = get2,
              set = set2,
            },
            colorBlindMoney = {
              order = 8,
              type = 'toggle',
              name = "Color Blind Mode",
              desc = "Displays money using letters G, S, and C instead of icons.",
              get = get2,
              set = set2,
            },
            filterItemQuality = {
              order = 9,
              type = 'select',
              name = "Filter Item Quality",
              desc = "Will not display any items that are below this quality (does not filter Quest or Crafted items).",
              values = {
                [0] = '1. |cff9d9d9d'..ITEM_QUALITY0_DESC..'|r',   -- Poor
                [1] = '2. |cffffffff'..ITEM_QUALITY1_DESC..'|r',   -- Common
                [2] = '3. |cff1eff00'..ITEM_QUALITY2_DESC..'|r',   -- Uncommon
                [3] = '4. |cff0070dd'..ITEM_QUALITY3_DESC..'|r',   -- Rare
                [4] = '5. |cffa335ee'..ITEM_QUALITY4_DESC..'|r',   -- Epic
                [5] = '6. |cffff8000'..ITEM_QUALITY5_DESC..'|r',   -- Legendary
                [6] = '7. |cffe6cc80'..ITEM_QUALITY6_DESC..'|r',   -- Artifact
                [7] = '8. |cffe6cc80'..ITEM_QUALITY7_DESC..'|r',   -- Heirloom
              },
              get = get2,
              set = set2,
            },
          },
        },

      },
    },
  },
}
