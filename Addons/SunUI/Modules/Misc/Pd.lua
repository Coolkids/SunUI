local S, L, DB, _, C = unpack(select(2, ...))
local dropdown

-- up-to-date list of professions and the latest spellIds
local PROFESSIONS = {
  {
    105206, -- Alchemy
    110396, -- Blacksmithing
    110400, -- Enchanting
    110403, -- Engineering
    110417, -- Inscription
    110420, -- Jewelcrafting
    110423, -- Leatherworking
    110426, -- Tailoring
  },
  {
    104381, -- Cooking
    110406, -- First Aid
  },
}

-- the onupdate function
local function DropDown_OnUpdate(dropdown, elapsed)
  dropdown.elapsed = dropdown.elapsed + elapsed
  if dropdown.elapsed > 1 then
    dropdown:SetScript("OnUpdate", nil)
    dropdown.elapsed = 0
    dropdown:Hide()
  end
end

-- cancel automatic countdown because we came back
local function DropDown_OnEnter(self)
  if dropdown then
    dropdown:SetScript("OnUpdate", nil)
    dropdown.elapsed = 0
  end
end

-- automatically hide when we have left the area for too long
local function DropDown_OnLeave(self)
  if dropdown and dropdown:IsShown() then
    dropdown.elapsed = 0
    dropdown:SetScript("OnUpdate", DropDown_OnUpdate)
  end
end

-- handle clicked links from dropdown menu
local function DropDown_OnClick(self)
  local spellId = self.spellId
  local guid = UnitGUID("player"):sub(4)
  local _, template = GetSpellLink(spellId)
  if type(template) ~= "string" or template:len() == 0 then
    return print("Professions Database found an invalid profession link with the spellId", spellId, "- please report this issue as soon as possible.")
  end
  local chars = template:sub(select(2, template:find(guid)), template:find("|h")):len() - 3
  local maxed = type(PROFESSION_RANKS) == "table" and select(2, next(PROFESSION_RANKS[#PROFESSION_RANKS])) or 0
  local suffix = ""
  for i = 1, chars do
    suffix = suffix.."/"
  end
  local link = format("trade:%d:%d:%d:%s:%s", spellId, maxed, maxed, guid, suffix)
  local text = format("|H%s|h[%s]|h", link, GetSpellInfo(spellId) or "spellId#"..spellId)
  if IsModifiedClick() then
    local fixedLink = format("|cffffd000%s|r", text)
    if ChatEdit_GetActiveWindow() then
      ChatEdit_InsertLink(fixedLink)
    else
      print("Open the chat and shift-click", fixedLink, "to link it.")
    end
  else
    dropdown:Hide()
    SetItemRef(link, text, "LeftButton", DEFAULT_CHAT_FRAME)
  end
end

-- add a shadow on buttons that are pushed down
local function DropDownButton_OnMouseDown(button)
  button.label:SetShadowColor(0, 0, 0, 1)
  button.label:SetShadowOffset(2, -2)
end

-- remove shadow when it's no longer pushed
local function DropDownButton_OnMouseUp(button)
  button.label:SetShadowColor(0, 0, 0, 0)
end

-- add button to dropdown (icon and text that is clickable)
local function DropDown_AddButton(dropdown, info)
  dropdown.buttons = dropdown.buttons or {}
  local button = CreateFrame("Button", "$parentButton"..(#dropdown.buttons + 1), dropdown)
  button.spellId = info.spellId
  button.label = button:CreateFontString("$parentText", "ARTWORK", "FriendsFont_Large")
  local font = {button.label:GetFont()}
  font[2] = 12 -- default is 14 for FriendsFont_Large
  if not button.spellId then
    font[2] = font[2] + 1 -- a bit larger for headers
    font[3] = "OUTLINE"
  end
  button.label:SetFont(unpack(font))
  button.label:SetText(info.text)
  button.label:SetPoint("LEFT", info.icon and (16 + 2) or 2, 0) -- if shown add icon padding
  button.icon = button:CreateTexture("$parentIcon")
  button.icon:SetSize(16, 16)
  button.icon:SetPoint("LEFT")
  button.icon:SetTexture(info.icon or "Interface\\Icons\\Temp")
  if info.icon then
    button.icon:Show()
  else
    button.icon:Hide()
  end
  button:SetSize(button.label:GetStringWidth() + 2 + (button.icon:IsShown() and (16 + 2) or 0), (button.label:GetStringHeight() < 16 and 16 or button.label:GetStringHeight()) + 4) -- width + padding + (if shown add icon padding), width + padding
  if dropdown.last then
    button:SetPoint("TOPLEFT", dropdown.last, "BOTTOMLEFT", 0, 0)
  else
    button:SetPoint("TOPLEFT", dropdown, 8, -8)
  end
  if button.spellId then
    button:RegisterForClicks("LeftButtonUp")
    button:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight", "ADD")
    button:SetScript("OnMouseDown", DropDownButton_OnMouseDown)
    button:SetScript("OnMouseUp", DropDownButton_OnMouseUp)
    button:SetScript("OnHide", DropDownButton_OnMouseUp)
    button:SetScript("OnClick", DropDown_OnClick)
  end
  button:SetScript("OnEnter", DropDown_OnEnter)
  button:SetScript("OnLeave", DropDown_OnLeave)
  dropdown.last = button
  table.insert(dropdown.buttons, button)
  return button:GetSize()
end

-- draw our own dropdown version (no more taint please!)
local function DropDown_Init()
  dropdown = CreateFrame("Frame", "ProfessionsDatabaseDropDown", UIParent)
  dropdown:EnableMouse(true)
  dropdown:SetFrameStrata("TOOLTIP")
  dropdown:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = {left = 4, right = 4, top = 4, bottom = 4},
  })
  dropdown:SetBackdropColor(0, 0, 0, 1)
  for i, spells in ipairs(PROFESSIONS) do
    DropDown_AddButton(dropdown, {text = i == 1 and PRIMARY or SECONDARY})
    for _, spell in ipairs(spells) do
      local name, _, texture = GetSpellInfo(spell)
      DropDown_AddButton(dropdown, {text = name, spellId = spell, icon = texture})
    end
  end
  local w, h = 0, 0
  for _, button in pairs(dropdown.buttons) do
    w = w > button:GetWidth() and w or button:GetWidth()
    h = h + button:GetHeight()
  end
  for _, button in pairs(dropdown.buttons) do
    button:SetWidth(w)
  end
  dropdown:SetSize(w + 16, h + 16) -- frame bottom/right padding
  dropdown:SetPoint("CENTER")
  dropdown:Hide()
  dropdown:SetScript("OnEnter", DropDown_OnEnter)
  dropdown:SetScript("OnLeave", DropDown_OnLeave)
  dropdown:SetScript("OnHide", function(dropdown)
    dropdown:SetScript("OnUpdate", nil)
    dropdown.elapsed = 0
  end)
end

-- toggles the dropdown on button or middle of screen
local function DropDown_Toggle(self)
  if not dropdown then
    DropDown_Init()
  end
  if dropdown:IsShown() then
    dropdown:Hide()
  else
    dropdown:ClearAllPoints()
    if self then
      dropdown:SetPoint("TOPLEFT", self, self:GetWidth() - 4, -self:GetHeight() + 4)
    else
      dropdown:SetPoint("CENTER")
    end
    dropdown:Show()
  end
end

-- hides the dropdown when the spellbook hides
local function DropDown_Hide(self)
  if self and dropdown then
    dropdown:Hide()
  end
end

-- create button in spellbook (top right corner, a blue "?" icon)
local button = CreateFrame("Button", "ProfessionsDatabaseToggleButton", SpellBookProfessionFrame)
button:SetSize(16, 16)
button:SetPoint("TOPRIGHT", button:GetParent(), "TOPRIGHT", -26, -3)
button:SetScript("OnClick", DropDown_Toggle)
button:SetScript("OnHide", DropDown_Hide)
button:SetScript("OnEnter", DropDown_OnEnter)
button:SetScript("OnLeave", DropDown_OnLeave)
button:RegisterForClicks("LeftButtonUp")
button:SetNormalTexture("Interface\\GossipFrame\\DailyActiveQuestIcon")
button:SetPushedTexture("Interface\\GossipFrame\\DailyActiveQuestIcon")
button:SetHighlightTexture("Interface\\GossipFrame\\DailyActiveQuestIcon", "ADD")

-- register slash command function
SlashCmdList["ProfessionsDatabase_CMD"] = function()
  DropDown_Toggle()
end

-- register the slash commands
for i, slash in pairs({"/pdb", "/profd", "/profdb"}) do
  _G["SLASH_ProfessionsDatabase_CMD"..i] = slash
end