--[[
TODO:
 + Make "Have Materials" and "Has skill up" somehow include banks if checked.
]]

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
--[=[

-- bank and guild bank cache
ProfessionsDatabaseCache = ProfessionsDatabaseCache or {bank = {}, gbank = {}}
addon.cache = ProfessionsDatabaseCache

-- hook tradeskillui addon (lod)
addon.hooktradeskill = function(self)
  if self.hooktradeskillran then return 1 end
  self.hooktradeskillran = 1
  local tonumber = tonumber
  local TradeSkillUpdate
  self.nudge = function(self, tiponly)
    local ddb1, ddb2 = DropDownList1Button1, DropDownList1Button2
    if ddb1 and ddb1:IsShown() and ddb1:GetText("Have Materials") then
      if TradeSkillFrame.filterTbl.hasBankMats or TradeSkillFrame.filterTbl.hasGuildBankMats then
        local notice = "Including Bank and/or Guild Bank Materials\nwill not affect the \"Have Materials\" and \"Has skill up\"\nfilters as they are built in and can not be altered."
        ddb1.tooltipTitle = "Notice"
        ddb1.tooltipText = notice
        ddb1.tooltipWhileDisabled = 1
        ddb1.tooltipOnButton = 1
        ddb2.tooltipTitle = "Notice"
        ddb2.tooltipText = notice
        ddb2.tooltipWhileDisabled = 1
        ddb2.tooltipOnButton = 1
      else
        ddb1.tooltipTitle = nil
        ddb1.tooltipText = nil
        ddb2.tooltipTitle = nil
        ddb2.tooltipText = nil
      end
    end
    if tiponly then return end
    TradeSkillFrame_SetSelection(TradeSkillFrame.selectedSkill)
    TradeSkillFrame_Update()
  end
  hooksecurefunc("TradeSkillUpdateFilterBar", function(subName, slotName)
    local filterText = TradeSkillFilterBarText:IsVisible() and TradeSkillFilterBarText:GetText() or ""
    filterText = filterText:sub((FILTER..": "):len()+1)
    if TradeSkillFrame.filterTbl.hasBankMats then 
      if filterText ~= "" then filterText = filterText..", " end
      filterText = filterText.."Include Bank Materials"
    end
    if TradeSkillFrame.filterTbl.hasGuildBankMats then 
      if filterText ~= "" then filterText = filterText..", " end
      filterText = filterText.."Include Guild Bank Materials"
    end
    if filterText == "" then
      TradeSkillFilterBar:Hide()
      TradeSkillSkill1:Show()
    else
      TradeSkillFilterBar:Show()
      TradeSkillSkill1:Hide()
      TradeSkillFilterBarText:SetText(FILTER..": "..filterText)
    end
    TradeSkillListScrollFrameScrollBar:SetValue(0)
    FauxScrollFrame_SetOffset(TradeSkillListScrollFrame, 0)
    if addon.nudge then addon:nudge() else TradeSkillFrame_Update() end
  end)
  local dropdownMenu = function(self, level)
    if level == 1 then
      local notice = "Including Bank and/or Guild Bank Materials\nmay create FPS drop and performance issues.\nNow you know and to get rid of it simply\nuncheck these filters."
      local info = UIDropDownMenu_CreateInfo()
      info.text = "Include Bank Materials"
      info.func = function()
        TradeSkillFrame.filterTbl.hasBankMats = not TradeSkillFrame.filterTbl.hasBankMats
        TradeSkillUpdateFilterBar()
      end
      info.keepShownOnClick = true
      info.checked = TradeSkillFrame.filterTbl.hasBankMats
      info.isNotRadio = true
      info.tooltipTitle = "Warning"
      info.tooltipText = notice
      info.tooltipWhileDisabled = 1
      info.tooltipOnButton = 1
      UIDropDownMenu_AddButton(info, level)
      info = UIDropDownMenu_CreateInfo()
      info.text = "Include Guild Bank Materials"
      info.func = function()
        TradeSkillFrame.filterTbl.hasGuildBankMats = not TradeSkillFrame.filterTbl.hasGuildBankMats
        TradeSkillUpdateFilterBar()
      end
      info.keepShownOnClick = true
      info.checked = TradeSkillFrame.filterTbl.hasGuildBankMats
      info.isNotRadio = true
      info.tooltipTitle = "Warning"
      info.tooltipText = notice
      info.tooltipWhileDisabled = 1
      info.tooltipOnButton = 1
      UIDropDownMenu_AddButton(info, level)
    end
    if addon.nudge then addon:nudge(1) end
  end
  hooksecurefunc("TradeSkillFilterDropDown_OnLoad", dropdownMenu)
  hooksecurefunc("TradeSkillFilterDropDown_Initialize", dropdownMenu)
  hooksecurefunc(TradeSkillFilterDropDown, "initialize", dropdownMenu)
  TradeSkillFilterBarExitButton:HookScript("OnClick", function(self, ...)
    TradeSkillFrame.filterTbl.hasBankMats = false
    TradeSkillFrame.filterTbl.hasGuildBankMats = false
    TradeSkillUpdateFilterBar()
  end)
  local getReagentInfo = function(name)
    local num = 0
    if name then
      if TradeSkillFrame.filterTbl.hasBankMats then
        num = num + (addon.cache.bank[name] or 0)
      end
      if TradeSkillFrame.filterTbl.hasGuildBankMats and addon.loadedgbank then
        num = num + (addon.cache.gbank[name] or 0)
      end
    end
    return num
  end
  local oGetTradeSkillReagentInfo = GetTradeSkillReagentInfo
  local oGetTradeSkillInfo = GetTradeSkillInfo
  GetTradeSkillReagentInfo = function(i, j, ...)
    local temp = {oGetTradeSkillReagentInfo(i, j, ...)}
    if #temp == 0 then return end
    if type(temp[4]) == "number" then
      temp[4] = temp[4] + getReagentInfo(temp[1])
    end
    return unpack(temp)
  end
  GetTradeSkillInfo = function(i, ...)
    local temp = {oGetTradeSkillInfo(i, ...)}
    if #temp == 0 then return end
    if temp[2] ~= "header" then
      local num, c, p = 2^8 -- 256 reagents max (theoretically)
      for r = 1, GetTradeSkillNumReagents(i) do
        a, _, c, p = GetTradeSkillReagentInfo(i, r)
        num = min(num, p/c)
      end
      temp[3] = tonumber(format("%d", num == 2^8 and 0 or num)) or temp[3] or 0
    end
    return unpack(temp)
  end
  local skillUpdate = function(self, id)
    local skillName, skillType, numAvailable, isExpanded, serviceType, numSkillUps = GetTradeSkillInfo(id, 1)
    if skillName and numAvailable > 0 then
      local skillNamePrefix, nameWidth, countWidth = ENABLE_COLORBLIND_MODE == "1" and (TradeSkillTypePrefix[skillType] or " ") or " "
      skillName = skillNamePrefix..skillName
      self.count:SetText("["..numAvailable.."]")
      TradeSkillFrameDummyString:SetText(skillName)
      nameWidth = TradeSkillFrameDummyString:GetWidth()
      countWidth = self.count:GetWidth()
      self.text:SetText(skillName)
      if nameWidth + 2 + countWidth > TRADE_SKILL_TEXT_WIDTH then
        self.text:SetWidth(TRADE_SKILL_TEXT_WIDTH-2-countWidth)
      else
        self.text:SetWidth(0)
      end
    end
  end
  -- TODO-START: trying to reduce high load and performance instability in this segment :(
  TradeSkillUpdate = function()
    if TradeSkillFrame.filterTbl.hasBankMats or TradeSkillFrame.filterTbl.hasGuildBankMats then
      local hasFilterBar, button = TradeSkillFilterBar:IsShown()
      for i = 1, (TRADE_SKILLS_DISPLAYED - (hasFilterBar and 1 or 0)) do
        button = _G["TradeSkillSkill"..(i + (hasFilterBar and 1 or 0))]
        if button then skillUpdate(button, button:GetID()) end
      end
    end
  end
  hooksecurefunc("TradeSkillFrame_Update", TradeSkillUpdate)
  TradeSkillFrame:HookScript("OnHide", function()
    if TradeSkillFrame.filterTbl.hasBankMats or TradeSkillFrame.filterTbl.hasGuildBankMats then
      TradeSkillFilterBarExitButton:Click("LeftButton")
    end
  end)
  -- TODO-END
  return 1
end

-- this will trigger loading the cache system and the bonus tradeskill features (comment to remove the functionality)
addon:RegisterEvent("ADDON_LOADED") -- add "--" in front this line to only use for the profession linking and browsing, no cache and filtering will be added. handy if you experience performance issues! ;)

-- respond on specific events appropriately
addon:SetScript("OnEvent", function(self, event, ...)
  if event == "ADDON_LOADED" then
    if ... == self.name then
      self.cache = ProfessionsDatabaseCache
      self:RegisterEvent("BANKFRAME_CLOSED")
      self:RegisterEvent("BANKFRAME_OPENED")
      self:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED")
      self:RegisterEvent("GUILDBANKFRAME_CLOSED")
      self:RegisterEvent("GUILDBANKFRAME_OPENED")
      self:RegisterEvent("ITEM_LOCK_CHANGED")
    elseif ... == "Blizzard_TradeSkillUI" then
      self:hooktradeskill()
    elseif ... == "Blizzard_GuildBankUI" then
      self.loadedgbank = 1
    end
  elseif event == "BANKFRAME_OPENED" or event == "BANKFRAME_CLOSED" or (self.bankopen and event == "ITEM_LOCK_CHANGED") then
    if event == "BANKFRAME_OPENED" then self.bankopen = 1 elseif event == "BANKFRAME_CLOSED" then self.bankopen = nil end
    table.wipe(self.cache.bank)
    local name
    for c = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS + 1 do
      if c == NUM_BAG_SLOTS + NUM_BANKBAGSLOTS + 1 then c = -1 end -- scan the main bank bag
      for s = 1, GetContainerNumSlots(c) do
        name = GetItemInfo(GetContainerItemID(c, s) or 0)
        if name then
          self.cache.bank[name] = (self.cache.bank[name] or 0) + select(2, GetContainerItemInfo(c, s))
        end
      end
    end
    if self.nudge then self:nudge() end
  elseif self.loadedgbank and (event == "GUILDBANKFRAME_OPENED" or event == "GUILDBANKFRAME_CLOSED" or (self.gbankopen and event == "GUILDBANKBAGSLOTS_CHANGED")) then
    if event == "GUILDBANKFRAME_OPENED" then self.gbankopen = 1 elseif event == "GUILDBANKFRAME_CLOSED" then self.gbankopen = nil end
    table.wipe(self.cache.gbank)
    local name
    for b = 1, (GetNumGuildBankTabs() or 0) do
      for s = 1, (MAX_GUILDBANK_SLOTS_PER_TAB or 0) do
        name = GetItemInfo(GetGuildBankItemLink(b, s) or 0)
        if name then
          self.cache.gbank[name] = (self.cache.gbank[name] or 0) + select(2, GetGuildBankItemInfo(b, s))
        end
      end
    end
    if self.nudge then self:nudge() end
  elseif self.nudge then
    self:nudge()
  end
end)

--]=]
