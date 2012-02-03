local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Style2")

function Module:OnInitialize()
if ActionBarDB.Style == 2 then
C = ActionBarDB
  local _G = _G

  local nomoreplay = function() end

  local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

  if DB.color.classcolored then
    DB.color.normal = classcolor
  end

  --backdrop settings
  local bgfile, edgefile = "", ""
  if DB.background.showshadow then edgefile = DB.textures.outer_shadow end
  if DB.background.useflatbackground and DB.background.showbg then bgfile = DB.textures.buttonbackflat end

  --backdrop
  local backdrop = {
    bgFile = bgfile,
    edgeFile = edgefile,
    tile = false,
    tileSize = 32,
    edgeSize = DB.background.inset,
    insets = {
      left = DB.background.inset,
      right = DB.background.inset,
      top = DB.background.inset,
      bottom = DB.background.inset,
    },
  }

  local function applyBackground(bu)
    --shadows+background
    if bu:GetFrameLevel() > 0 and (DB.background.showbg or DB.background.showshadow) then
    --if DB.background.showbg or DB.background.showshadow then
      bu.bg = CreateFrame("Frame", nil, bu)
      bu.bg:SetAllPoints(bu)
      bu.bg:SetPoint("TOPLEFT", bu, "TOPLEFT", -4, 4)
      bu.bg:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 4, -4)
      bu.bg:SetFrameLevel(bu:GetFrameLevel()-1)

      if DB.background.classcolored then
        DB.background.backgroundcolor = classcolor
        DB.background.shadowcolor = classcolor
      end

      if DB.background.showbg and not DB.background.useflatbackground then
        local t = bu.bg:CreateTexture(nil,"BACKGROUND",-8)
        t:SetTexture(DB.textures.buttonback)
        t:SetAllPoints(bu)
        t:SetVertexColor(DB.background.backgroundcolor.r,DB.background.backgroundcolor.g,DB.background.backgroundcolor.b,DB.background.backgroundcolor.a)
      end

      bu.bg:SetBackdrop(backdrop)
      if DB.background.useflatbackground then
        bu.bg:SetBackdropColor(DB.background.backgroundcolor.r,DB.background.backgroundcolor.g,DB.background.backgroundcolor.b,DB.background.backgroundcolor.a)
      end
      if DB.background.showshadow then
        bu.bg:SetBackdropBorderColor(DB.background.shadowcolor.r,DB.background.shadowcolor.g,DB.background.shadowcolor.b,DB.background.shadowcolor.a)
      end
    end
  end

  local function ntSetVertexColorFunc(nt, r, g, b, a)
    --do stuff
    if nt then
      local self = nt:GetParent()
      --print(self:GetName()..": r"..r.."g"..g.."b"..b)--debug
      local action = self.action
      if r==1 and g==1 and b==1 and action and (IsEquippedAction(action)) then
        nt:SetVertexColor(DB.color.equipped.r,DB.color.equipped.g,DB.color.equipped.b,1)
      elseif r==0.5 and g==0.5 and b==1 then
        --blizzard oom color
        nt:SetVertexColor(DB.color.normal.r,DB.color.normal.g,DB.color.normal.b,1)
      elseif r==1 and g==1 and b==1 then
        nt:SetVertexColor(DB.color.normal.r,DB.color.normal.g,DB.color.normal.b,1)
      end
    end
  end

  --initial style func
  local function rActionButtonStyler_AB_style(self)
    if self.rABS_Styled then return end

    local action = self.action
    local name = self:GetName()
    local bu  = _G[name]
    local ic  = _G[name.."Icon"]
    local co  = _G[name.."Count"]
    local bo  = _G[name.."Border"]
    local ho  = _G[name.."HotKey"]
    local cd  = _G[name.."Cooldown"]
    local na  = _G[name.."Name"]
    local fl  = _G[name.."Flash"]
    local nt  = _G[name.."NormalTexture"]
    local fbg  = _G[name.."FloatingBG"]

    if not nt then
      --error no button to style found, get out asap
      self.rABS_Styled = true
      --print(name)
      return
    end

    if fbg then
      fbg:Hide()
      fbg.Show = nomoreplay
    end

    --hide the border (plain ugly, sry blizz)
    bo:Hide()
    bo.Show = nomoreplay

    if  C["HideHotKey"] == false then
      ho:SetFont(DB.Font, C["FontSize"]*S.Scale(1), "OUTLINE")
      ho:ClearAllPoints()
      ho:SetPoint(DB.hotkeys.pos1.a1,bu,DB.hotkeys.pos1.x,DB.hotkeys.pos1.y)
      ho:SetPoint(DB.hotkeys.pos2.a1,bu,DB.hotkeys.pos2.x,DB.hotkeys.pos2.y)
    else
      ho:Hide()
      ho.Show = nomoreplay
    end

    if C["HideMacroName"] == false then
      na:SetFont(DB.Font, C["MFontSize"]*S.Scale(1), "OUTLINE")
      na:ClearAllPoints()
      na:SetPoint(DB.macroname.pos1.a1,bu,DB.macroname.pos1.x,DB.macroname.pos1.y)
      na:SetPoint(DB.macroname.pos2.a1,bu,DB.macroname.pos2.x,DB.macroname.pos2.y)
    else
      na:Hide()
    end

    if DB.itemcount.show then
      co:SetFont(DB.Font, C["FontSize"]*S.Scale(1), "OUTLINE")
      co:ClearAllPoints()
      co:SetPoint(DB.itemcount.pos1.a1,bu,DB.itemcount.pos1.x,DB.itemcount.pos1.y)
    else
      co:Hide()
    end

    --applying the textures
    fl:SetTexture(DB.textures.flash)
    bu:SetHighlightTexture(DB.textures.hover)
    bu:SetPushedTexture(DB.textures.pushed)
    bu:SetCheckedTexture(DB.textures.checked)
    bu:SetNormalTexture(DB.textures.normal)

    --cut the default border of the icons and make them shiny
    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
    ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)

    --adjust the cooldown frame
    cd:SetPoint("TOPLEFT", bu, "TOPLEFT", DB.cooldown.spacing, -DB.cooldown.spacing)
    cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -DB.cooldown.spacing, DB.cooldown.spacing)

    --apply the normaltexture
    if ( IsEquippedAction(action) ) then
      bu:SetNormalTexture(DB.textures.equipped)
      nt:SetVertexColor(DB.color.equipped.r,DB.color.equipped.g,DB.color.equipped.b,1)
    else
      bu:SetNormalTexture(DB.textures.normal)
      nt:SetVertexColor(DB.color.normal.r,DB.color.normal.g,DB.color.normal.b,1)
    end

    --make the normaltexture match the buttonsize
    nt:SetAllPoints(bu)

    --disable resetting of textures
    fl.SetTexture = nomoreplay
    bu.SetHighlightTexture = nomoreplay
    bu.SetPushedTexture = nomoreplay
    bu.SetCheckedTexture = nomoreplay
    bu.SetNormalTexture = nomoreplay

    --hook to prevent Blizzard from reseting our colors
    hooksecurefunc(nt, "SetVertexColor", ntSetVertexColorFunc)

    --shadows+background
    if not bu.bg then applyBackground(bu) end

    self.rABS_Styled = true

  end

  --style pet buttons
  local function rActionButtonStyler_AB_stylepet()

    for i=1, NUM_PET_ACTION_SLOTS do
      local name = "PetActionButton"..i
      local bu  = _G[name]
      local ic  = _G[name.."Icon"]
      local fl  = _G[name.."Flash"]
      local nt  = _G[name.."NormalTexture2"]

      nt:SetAllPoints(bu)

      --applying color
      nt:SetVertexColor(DB.color.normal.r,DB.color.normal.g,DB.color.normal.b,1)

      --setting the textures
      fl:SetTexture(DB.textures.flash)
      bu:SetHighlightTexture(DB.textures.hover)
      bu:SetPushedTexture(DB.textures.pushed)
      bu:SetCheckedTexture(DB.textures.checked)
      bu:SetNormalTexture(DB.textures.normal)

      --cut the default border of the icons and make them shiny
      ic:SetTexCoord(0.1,0.9,0.1,0.9)
      ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
      ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)

      --shadows+background
      if not bu.bg then applyBackground(bu) end

    end
  end

  --style shapeshift buttons
  local function rActionButtonStyler_AB_styleshapeshift()
    for i=1, NUM_SHAPESHIFT_SLOTS do
      local name = "ShapeshiftButton"..i
      local bu  = _G[name]
      local ic  = _G[name.."Icon"]
      local fl  = _G[name.."Flash"]
      local nt  = _G[name.."NormalTexture2"]

      nt:SetAllPoints(bu)

      --applying color
      nt:SetVertexColor(DB.color.normal.r,DB.color.normal.g,DB.color.normal.b,1)

      --setting the textures
      fl:SetTexture(DB.textures.flash)
      bu:SetHighlightTexture(DB.textures.hover)
      bu:SetPushedTexture(DB.textures.pushed)
      bu:SetCheckedTexture(DB.textures.checked)
      bu:SetNormalTexture(DB.textures.normal)

      --cut the default border of the icons and make them shiny
      ic:SetTexCoord(0.1,0.9,0.1,0.9)
      ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
      ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)

      --shadows+background
      if not bu.bg then applyBackground(bu) end

    end
  end

  ---------------------------------------
  -- CALLS // HOOKS
  ---------------------------------------

  hooksecurefunc("ActionButton_Update",         rActionButtonStyler_AB_style)
  hooksecurefunc("ShapeshiftBar_Update",        rActionButtonStyler_AB_styleshapeshift)
  hooksecurefunc("ShapeshiftBar_UpdateState",   rActionButtonStyler_AB_styleshapeshift)
  hooksecurefunc("PetActionBar_Update",         rActionButtonStyler_AB_stylepet)
  end
  end