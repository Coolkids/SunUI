--[[
TODO:
 + Make "Have Materials" and "Has skill up" somehow include banks if checked.
]]
local S, C, L, DB = unpack(select(2, ...))
local _
local addon = CreateFrame("Frame")
addon.name = ...

-- primary and secondary professions
addon.profs = {
  {
    80731, -- Alchemy
    76666, -- Blacksmithing
    74258, -- Enchanting
    82774, -- Engineering
    86008, -- Inscription
    73318, -- Jewelcrafting
    81199, -- Leatherworking
    75156, -- Tailoring
  },
  {
    88053, -- Cooking
    74559, -- First Aid
  },
}

-- handle the clicks from the dropdown menu (chat insertion or opening the profession)
local handle = function(spellid, chat)
  local f = ""
  local g = UnitGUID("player"):sub(4)
  local t = select(2, GetSpellLink(spellid))
  if (t or ""):len() == 0 then
    return print((GetSpellLink(spellid) or "[spell#"..spellid.."]").." is an invalid profession and can't be shown!")
  end
  local c = t:sub(select(2, t:find(g)), t:find("\124h")):len()-3
  local maxed = type(PROFESSION_RANKS) == "table" and select(2, next(PROFESSION_RANKS[#PROFESSION_RANKS])) or 0
  for i = 1, c do f = f.."/" end
  local link = format("trade:%d:%d:%d:%s:%s", spellid, maxed, maxed, g, f)
  local text = format("\124H%s\124h[%s]\124h", link, GetSpellInfo(spellid) or "spell#"..spellid)
  if chat then
    local flink = format("\124cffffd000%s\124r", text)
    if ChatEdit_GetActiveWindow() then
      ChatEdit_InsertLink(flink)
    else
      print(format("Open the chat then shift-click %s to link it.", flink))
    end
  else
    SetItemRef(link, text, "LeftButton", DEFAULT_CHAT_FRAME)
  end
end

-- spellbook "..." button for professions
local btn = CreateFrame("Button", addon.name.."Button", SpellBookProfessionFrame, "UIPanelButtonTemplate")
btn:ClearAllPoints()
btn:SetPoint("BOTTOMRIGHT", -32, 24)
btn:SetWidth(24)
btn:SetHeight(16)
btn:SetText("...")
local dd = CreateFrame("Frame", btn:GetName().."Dropdown", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(dd, function()
  local skipped = 0
  if type(addon.profs) == "table" and type(addon.profs[1]) == "table" and next(addon.profs[1]) then
    UIDropDownMenu_AddButton({isTitle=1, notCheckable=1, text="Primary"})
    for _, spellid in pairs(addon.profs[1]) do
      local info = UIDropDownMenu_CreateInfo()
      info.notCheckable = 1
      info.text = GetSpellInfo(spellid)
      info.icon = select(3, GetSpellInfo(spellid))
      info.arg1 = spellid
      info.func = function(line) handle(line.arg1, IsModifierKeyDown()) end
      UIDropDownMenu_AddButton(info)
    end
  else
    skipped = skipped + 1
  end
  if type(addon.profs) == "table" and type(addon.profs[2]) == "table" and next(addon.profs[2]) then
    UIDropDownMenu_AddButton({isTitle=1, notCheckable=1, text="Secondary"})
    for _, spellid in pairs(addon.profs[2]) do
      local info = UIDropDownMenu_CreateInfo()
      info.notCheckable = 1
      info.text = GetSpellInfo(spellid)
      info.icon = select(3, GetSpellInfo(spellid))
      info.arg1 = spellid
      info.func = function(line) handle(line.arg1, IsModifierKeyDown()) end
      UIDropDownMenu_AddButton(info)
    end
  else
    skipped = skipped + 1
  end
  if skipped == 2 then
    UIDropDownMenu_AddButton({isTitle=1, notCheckable=1, text="This addon needs to be updated!"})
  end
end, "MENU")
btn:SetScript("OnClick", function(btn)
  ToggleDropDownMenu(1, nil, dd, btn, 0, 0)
end)

-- add slash command for toggling showing the menu (places it on the middle of the screen)
local center = CreateFrame("Frame", nil, UIParent)
center:SetPoint("CENTER", -dd:GetWidth()*1.4, dd:GetHeight()*3.2) -- place so menu shows centered
center:SetWidth(1)
center:SetHeight(1)
_G["SLASH_"..addon.name.."_PDB_CMD1"] = "/pdb"
_G["SLASH_"..addon.name.."_PDB_CMD2"] = "/profd"
SlashCmdList[addon.name.."_PDB_CMD"] = function()
  ToggleDropDownMenu(1, nil, dd, center, 0, 0)
end

ProfessionsDatabaseCache = nil -- temporarily disabled the cache system (requires a lot of improvements, preformance wise)