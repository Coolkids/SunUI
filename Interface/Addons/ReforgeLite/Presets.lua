-- Part of ReforgeLite by d07.RiV (Iroared)
-- All rights reserved

local L = ReforgeLiteLocale
local MOP = (GetNumTalentTabs == nil)

----------------------------------------- CAP PRESETS ---------------------------------

function ReforgeLite:RatingPerPoint (stat, level)
  level = level or UnitLevel("player")
  if stat == self.STATS.SPELLHIT then
    stat = self.STATS.HIT
  end
  return ReforgeLiteScalingTable[stat][level] or 0
end
function ReforgeLite:GetMeleeHitBonus ()
  return GetHitModifier () or 0
end
function ReforgeLite:GetSpellHitBonus ()
  return GetSpellHitModifier () or 0
end
function ReforgeLite:GetExpertiseBonus ()
  if MOP then
    return GetExpertise () - GetCombatRatingBonus (CR_EXPERTISE)
  else
    return GetExpertise () - math.floor (GetCombatRatingBonus (CR_EXPERTISE))
  end
end
function ReforgeLite:GetNeededMeleeHit ()
  local diff = self.pdb.targetLevel
  if MOP then
    return math.max(0, 3 + 1.5 * diff)
  else
    if diff <= 2 then
      return math.max (0, 5 + 0.5 * diff)
    else
      return 2 + 2 * diff
    end
  end
end
function ReforgeLite:GetNeededSpellHit ()
  local diff = self.pdb.targetLevel
  if MOP then
    return math.max(0, 6 + 3 * diff)
  else
    if diff <= 2 then
      return math.max (0, 4 + diff)
    else
      return 11 * diff - 16
    end
  end
end
function ReforgeLite:GetNeededExpertiseSoft ()
  local diff = self.pdb.targetLevel
  if MOP then
    return math.max(0, 3 + 1.5 * diff)
  else
    return math.ceil (math.max (0, 5 + 0.5 * diff) / 0.25)
  end
end
function ReforgeLite:GetNeededExpertiseHard ()
  local diff = self.pdb.targetLevel
  if MOP then
    return math.max(0, 6 + 3 * diff)
  else
    if diff <= 2 then
      return math.ceil (math.max (0, 5 + 0.5 * diff) / 0.25)
    else
      return math.ceil (14 / 0.25)
    end
  end
end

ReforgeLite.capPresets = {
  {
    value = 1,
    name = L["Manual"],
    getter = nil
  },
  {
    value = 2,
    name = L["Melee hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.HIT) * (ReforgeLite:GetNeededMeleeHit () - ReforgeLite:GetMeleeHitBonus ())
    end
  },
  {
    value = 3,
    name = L["Spell hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.SPELLHIT) * (ReforgeLite:GetNeededSpellHit () - ReforgeLite:GetSpellHitBonus ())
    end
  },
  {
    value = 4,
    name = L["Melee DW hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.HIT) * (ReforgeLite:GetNeededMeleeHit () + 19 - ReforgeLite:GetMeleeHitBonus ())
    end
  },
  {
    value = 5,
    name = L["Expertise soft cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.EXP) * (ReforgeLite:GetNeededExpertiseSoft () - ReforgeLite:GetExpertiseBonus ())
    end
  },
  {
    value = 6,
    name = L["Expertise hard cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.EXP) * (ReforgeLite:GetNeededExpertiseHard () - ReforgeLite:GetExpertiseBonus ())
    end
  },
}

----------------------------------------- WEIGHT PRESETS ------------------------------

local StatSpirit = 1
local StatDodge = 2
local StatParry = 3
local StatHit = 4
local StatCrit = 5
local StatHaste = 6
local StatExp = 7
local StatMastery = 8
local MeleeHitCap = 2
local SpellHitCap = 3
local MeleeDWHitCap = 4
local ExpSoftCap = 5
local ExpHardCap = 6
local AtLeast = 1
local AtMost = 2

local MeleeCaps = {
  {
    stat = StatHit,
    points = {
      {
        method = AtLeast,
        preset = MeleeHitCap
      }
    }
  },
  {
    stat = StatExp,
    points = {
      {
        method = AtLeast,
        preset = ExpSoftCap
      }
    }
  }
}
local CasterCaps = {
  {
    stat = StatHit,
    points = {
      {
        method = AtLeast,
        preset = SpellHitCap
      }
    }
  }
}

ReforgeLite.presets = {
  ["DEATHKNIGHT"] = {
    ["<Blood> - <Avoidance>"] = {
      prio = {
        {stat = StatMastery},
        {stat = StatParry},
        {stat = StatDodge},
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatHaste},
      }
    },
    ["<Blood> - <Control>"] = {
      prio = {
        {stat = StatMastery},
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatParry},
        {stat = StatDodge},
        {stat = StatHaste},
      },
    },
    ["<Frost> - <2H Weapon>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatHaste},
        {stat = StatCrit},
        {stat = StatMastery},
      },
    },
    ["<Frost> - <Dual Wielding>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatMastery},
        {stat = StatHaste},
        {stat = StatCrit},
        {stat = StatHit, preset = MeleeDWHitCap},
      },
    },
    ["<Unholy>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatHaste},
        {stat = StatCrit},
        {stat = StatMastery},
      },
    },
  },
  ["DRUID"] = {
    ["<Balance>"] = {
      prio = {
        {stat = StatHit, preset = SpellHitCap},
        {stat = StatHaste, value = 5273},
        {stat = StatCrit},
        {stat = StatMastery},
        {stat = StatHaste},
      },
    },
    ["<Balance> - T14"] = {
      prio = {
        {stat = StatHit, preset = SpellHitCap},
        {stat = StatHaste, value = 3706},
        {stat = StatCrit},
        {stat = StatMastery},
        {stat = StatHaste},
      },
    },
    ["<Feral>"] = {
      prio = {
        {stat = StatMastery},
        {stat = StatCrit},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatHaste},
      },
    },
    ["<Guardian>"] = {
      prio = {
        {stat = StatDodge},
        {stat = StatMastery},
        {stat = StatCrit},
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpHardCap},
        {stat = StatHaste},
      },
    },
    ["<Restoration>"] = {
      prio = {
        {stat = StatSpirit},
        {stat = StatHaste, value = 3043},
        {stat = StatMastery},
        {stat = StatCrit},
        {stat = StatHaste},
      },
    },
  },
  ["HUNTER"] = {
    ["<Beast Mastery>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatMastery},
        {stat = StatCrit},
        {stat = StatHaste},
      },
    },
    ["<Marksmanship>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatHaste},
        {stat = StatCrit},
        {stat = StatMastery},
      },
    },
    ["<Survival>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatCrit},
        {stat = StatHaste},
        {stat = StatMastery},
      },
    },
  },
  ["MAGE"] = {
    ["<Arcane>"] = {
      prio = {
        {stat = StatHit, preset = SpellHitCap},
        {stat = StatMastery},
        {stat = StatHaste},
        {stat = StatCrit},
      },
    },
    ["<Fire>"] = {
      prio = {
        {stat = StatHit, preset = SpellHitCap},
        {stat = StatCrit},
        {stat = StatMastery},
        {stat = StatHaste},
      },
    },
    ["<Frost>"] = {
      prio = {
        {stat = StatHit, preset = SpellHitCap},
        {stat = StatHaste},
        {stat = StatCrit},
        {stat = StatMastery},
      },
    },
  },
  ["MONK"] = {
    ["<Brewmaster>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpHardCap},
        {stat = StatHaste},
        {stat = StatCrit},
        {stat = StatParry},
        {stat = StatDodge},
        {stat = StatMastery},
      },
    },
    ["<Mistweaver>"] = {
      prio = {
        {stat = StatSpirit},
        {stat = StatHaste, value = 1345},
        {stat = StatMastery},
        {stat = StatCrit},
        {stat = StatHaste},
      },
    },
    ["<Windwalker>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatHaste},
        {stat = StatCrit},
        {stat = StatMastery},
      },
    },
  },
  ["PALADIN"] = {
    ["<Holy>"] = {
      prio = {
        {stat = StatSpirit},
        {stat = StatMastery},
        {stat = StatHaste},
        {stat = StatCrit},
      },
    },
    ["<Protection>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpHardCap},
        {stat = StatMastery},
        {stat = StatHaste},
        {stat = StatParry},
        {stat = StatDodge},
      },
    },
    ["<Retribution>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatHaste},
        {stat = StatMastery},
        {stat = StatCrit},
      },
    },
  },
  ["PRIEST"] = {
    ["<Discipline>"] = {
      prio = {
        {stat = StatSpirit},
        {stat = StatMastery},
        {stat = StatHaste},
        {stat = StatCrit},
      },
    },
    ["<Holy>"] = {
      prio = {
        {stat = StatSpirit},
        {stat = StatHaste, value = 3039},
        {stat = StatMastery},
        {stat = StatCrit},
        {stat = StatHaste},
      },
    },
    ["<Shadow>"] = {
      prio = {
        {stat = StatHit, preset = SpellHitCap},
        {stat = StatHaste},
        {stat = StatCrit},
        {stat = StatMastery},
      },
    },
  },
  ["ROGUE"] = {
    ["<Assassination>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatMastery},
        {stat = StatCrit},
        {stat = StatHaste},
        {stat = StatHit, preset = MeleeDWHitCap},
      },
    },
    ["<Combat>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatHaste},
        {stat = StatMastery},
        {stat = StatCrit},
        {stat = StatHit, preset = MeleeDWHitCap},
      },
    },
    ["<Subtlety>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatHaste},
        {stat = StatCrit},
        {stat = StatMastery},
        {stat = StatHit, preset = MeleeDWHitCap},
      },
    },
  },
  ["SHAMAN"] = {
    ["<Elemental>"] = {
      prio = {
        {stat = StatHit, preset = SpellHitCap},
        {stat = StatHaste},
        {stat = StatMastery},
        {stat = StatCrit},
      },
    },
    ["<Enhancement>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatMastery},
        {stat = StatCrit},
        {stat = StatHaste},
      },
    },
    ["<Restoration>"] = {
      prio = {
        {stat = StatSpirit},
        {stat = StatHaste, value = 871},
        {stat = StatMastery},
        {stat = StatCrit},
        {stat = StatHaste},
      },
    },
  },
  ["WARLOCK"] = {
    ["<Affliction>"] = {
      prio = {
        {stat = StatHit, preset = SpellHitCap},
        {stat = StatMastery},
        {stat = StatHaste},
        {stat = StatCrit},
      },
    },
    ["<Demonology>"] = {
      prio = {
        {stat = StatHit, preset = SpellHitCap},
        {stat = StatCrit},
        {stat = StatHaste},
        {stat = StatMastery},
      },
    },
    ["<Destruction>"] = {
      prio = {
        {stat = StatHit, preset = SpellHitCap},
        {stat = StatCrit},
        {stat = StatHaste},
        {stat = StatMastery},
      },
    },
  },
  ["WARRIOR"] = {
    ["<Arms>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatCrit},
        {stat = StatMastery},
        {stat = StatHaste},
      },
    },
    ["<Fury>"] = {
      prio = {
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatCrit},
        {stat = StatMastery},
        {stat = StatHaste},
      },
    },
    ["<Protection> - <Avoidance>"] = {
      prio = {
        {stat = StatMastery},
        {stat = StatParry},
        {stat = StatDodge},
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatHaste},
      }
    },
    ["<Protection> - <Control>"] = {
      prio = {
        {stat = StatMastery},
        {stat = StatHit, preset = MeleeHitCap},
        {stat = StatExp, preset = ExpSoftCap},
        {stat = StatParry},
        {stat = StatDodge},
        {stat = StatHaste},
      },
    },
  },
}

local _, unitClass = UnitClass ("player")
ReforgeLite.presets = ReforgeLite.presets[unitClass]

function ReforgeLite:InitPresets ()
  self.presets["<Custom>"] = self.db.customPresets
  
  if PawnVersion then
    local PawnMap = {
      Spirit = true,
      DodgeRating = true,
      ParryRating
    }
    self.presets["Pawn scales"] = function ()
      if PawnCommon == nil or PawnCommon.Scales == nil then return {} end
      local result = {}
      for k, v in pairs (PawnCommon.Scales) do
        local preset = {leaf = "import"}
        preset.weights = {}
        local raw = v.Values or {}
        preset.weights[self.STATS.SPIRIT] = raw["Spirit"] or 0
        preset.weights[self.STATS.DODGE] = raw["DodgeRating"] or 0
        preset.weights[self.STATS.PARRY] = raw["ParryRating"] or 0
        preset.weights[self.STATS.HIT] = raw["HitRating"] or 0
        preset.weights[self.STATS.CRIT] = raw["CritRating"] or 0
        preset.weights[self.STATS.HASTE] = raw["HasteRating"] or 0
        preset.weights[self.STATS.EXP] = raw["ExpertiseRating"] or 0
        preset.weights[self.STATS.MASTERY] = raw["MasteryRating"] or 0
        local total = 0
        local average = 0
        for i = 1, #self.itemStats do
          if preset.weights[i] ~= 0 then
            total = total + 1
            average = average + preset.weights[i]
          end
        end
        if total > 0 and average > 0 then
          local factor = 1
          while factor * average / total < 10 do
            factor = factor * 100
          end
          while factor * average / total > 1000 do
            factor = factor / 10
          end
          for i = 1, #self.itemStats do
            preset.weights[i] = preset.weights[i] * factor
          end
          result[v.LocalizedName or k] = preset
        end
      end
      return result
    end
  end

  self.presetMenu = CreateFrame ("Frame", "ReforgeLitePresetMenu")
  self.presetMenu.info = {}
  self.presetMenu.initialize = function (menu, level)
    if not level then return end
    local info = menu.info
    wipe (info)
    local list = self.presets
    if level > 1 then
      list = UIDROPDOWNMENU_MENU_VALUE
    end
    info.notCheckable = true

    for k, v in pairs (list) do
      if type (v) == "function" then
        v = v ()
      end
      info.text = k:gsub("<(.*)>",function(s) return ReforgeLiteLocale[s] end)
      info.value = v
      if v.caps or v.weights or v.leaf or v.prio then
        info.func = function ()
          CloseDropDownMenus ()
          if v.leaf == "import" then
            self:SetStatWeights (v.weights, v.caps, v.prio)
          else
            self:SetStatWeights (v.weights, v.caps or {}, v.prio)
          end
        end
        info.hasArrow = nil
        info.keepShownOnClick = nil
      else
        info.func = nil
        if next (v) then
          info.hasArrow = true
        else
          info.hasArrow = nil
        end
        info.keepShownOnClick = true
      end
      UIDropDownMenu_AddButton (info, level)
    end
  end

  self.methodPresetMenu = CreateFrame ("Frame", "ReforgeLiteMethodPresetMenu")
  self.methodPresetMenu.info = {}
  self.methodPresetMenu.initialize = function (menu, level)
    if level ~= 1 then return end
    local info = menu.info
    wipe (info)
    info.notCheckable = true

    for k, v in pairs (self.pdb.customMethodPresets) do
      info.text = k
      info.value = v
      info.func = function ()
        CloseDropDownMenus ()
        self.pdb.method = v
        self:UpdateMethodCategory ()
      end
      info.hasArrow = nil
      info.keepShownOnClick = nil
      UIDropDownMenu_AddButton (info, level)
    end
  end

  self.presetDelMenu = CreateFrame ("Frame", "ReforgeLitePresetDelMenu")
  self.presetDelMenu.info = {}
  self.presetDelMenu.initialize = function (menu, level)
    if level ~= 1 then return end
    local info = menu.info
    wipe (info)
    info.notCheckable = true
    for k, v in pairs (self.db.customPresets) do
      info.text = k
      info.func = function ()
        self.db.customPresets[k] = nil
        if next (self.db.customPresets) == nil then
          self.deletePresetButton:Disable ()
        end
      end
      UIDropDownMenu_AddButton (info, level)
    end
  end

  self.methodPresetDelMenu = CreateFrame ("Frame", "ReforgeLiteMethodPresetDelMenu")
  self.methodPresetDelMenu.info = {}
  self.methodPresetDelMenu.initialize = function (menu, level)
    if level ~= 1 then return end
    local info = menu.info
    wipe (info)
    info.notCheckable = true

    for k, v in pairs (self.pdb.customMethodPresets) do
      info.text = k
      info.func = function ()
        self.db.customMethodPresets[k] = nil
        if next (self.pdb.customMethodPresets) == nil then
          self.methodPresetsButton:Disable()
          self.deleteMethodPresetButton:Disable ()
        end
      end
      UIDropDownMenu_AddButton (info, level)
    end
  end
end
