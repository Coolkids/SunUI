--http://mods.curse.com/addons/wow/close-up
local _G = getfenv(0)
local GetCursorPosition = GetCursorPosition
local function nada() end
local Model_OnMouseDown = _G.Model_OnMouseDown
local Model_OnMouseUp = _G.Model_OnMouseUp

-- someone wanted the feature to hide the dressing rooms' backgrounds
local function ToggleBG(notog)
	if not notog then CU_HideBG = not CU_HideBG end
	local f = (CU_HideBG and DressUpBackgroundTopLeft.Hide) or DressUpBackgroundTopLeft.Show
	f(DressUpBackgroundTopLeft)
	f(DressUpBackgroundTopRight)
	f(DressUpBackgroundBotLeft)
	f(DressUpBackgroundBotRight)
	if AuctionDressUpBackgroundTop then
		f(AuctionDressUpBackgroundTop)
		f(AuctionDressUpBackgroundBot)
	end
end

local function OnUpdate(this)
	local currentx, currenty = GetCursorPosition()
	if this.isrotating then
		if IsAltKeyDown() then
			local cz, cx, cy = this:GetPosition()
			this:SetPosition(cz + (currenty - this.prevy) * 0.3, cx, cy)
		else
			this:SetFacing(this:GetFacing() + ((currentx - this.prevx) / 50))
		end
	elseif this.isposing then
		local cz, cx, cy = this:GetPosition()
		this:SetPosition(cz, cx + ((currentx - this.prevx) / 50), cy + ((currenty - this.prevy) / 50))
	end
	this.prevx, this.prevy = currentx, currenty
end
local function OnMouseDown(this, a1)
	if Model_OnMouseDown then
		Model_OnMouseDown(this, a1)
	else
		this.pMouseDown(a1)
	end
	this:SetScript("OnUpdate", OnUpdate)
	if a1 == "LeftButton" then
		if IsControlKeyDown() then
			ToggleBG()
		else
			this.isrotating = 1
		end
	elseif a1 == "RightButton" then
		this.isposing = 1
	end
	this.prevx, this.prevy = GetCursorPosition()
end
local function OnMouseUp(this, a1)
	if Model_OnMouseUp then
		Model_OnMouseUp(this, a1)
	else
		this.pMouseUp(a1)
	end
	
	this:SetScript("OnUpdate", nil)
	if a1 == "LeftButton" then
		this.isrotating = nil
	end
	if a1 == "RightButton" then
		this.isposing = nil
	end
end
local function OnMouseWheel(this, a1)
	local cz, cx, cy = this:GetPosition()
	this:SetPosition(cz + ((a1 > 0 and 0.6) or -0.6), cx, cy)
end

-- base functions
-- - model - model frame name (string)
-- - w/h - new width/height of the model frame
-- - x/y - new x/y positions for default setpoint
-- - sigh - if rotation buttons have different base names than parent
-- - norotate - if the model doesn't have default rotate buttons
local function Apply(model, w, h, x, y, sigh, norotate)
	local gmodel = _G[model]
	if not gmodel then return end
	if not norotate then
		model = sigh or model
		if _G[model.."RotateRightButton"] then
			_G[model.."RotateRightButton"]:Hide()
		end
		if _G[model.."RotateLeftButton"] then
			_G[model.."RotateLeftButton"]:Hide()
		end
		if gmodel.RotateRightButton then
			gmodel.RotateRightButton:Hide()
		end
		if gmodel.RotateLeftButton then
			gmodel.RotateLeftButton:Hide()
		end
	end
	if _G[model.."ControlFrame"] then
		_G[model.."ControlFrame"]:Hide()
		_G[model.."ControlFrame"]:EnableMouse(false)
		_G[model.."ControlFrame"]:SetScript("OnEnter", nada)
		_G[model.."ControlFrame"].Show = nada
	end
	if w then gmodel:SetWidth(w) end
	if h then gmodel:SetHeight(h) end
	if x or y then 
		local p,rt,rp,px,py = gmodel:GetPoint()
		gmodel:SetPoint(p, rt, rp, x or px, y or py) 
	end
	gmodel:SetModelScale(2)
	gmodel:EnableMouse(true)
	gmodel:EnableMouseWheel(true)
	gmodel.pMouseDown = gmodel:GetScript("OnMouseDown") or nada
	gmodel.pMouseUp = gmodel:GetScript("OnMouseUp") or nada
	gmodel:SetScript("OnMouseDown", OnMouseDown)
	gmodel:SetScript("OnMouseUp", OnMouseUp)
	gmodel:SetScript("OnMouseWheel", OnMouseWheel)
end
-- in case someone wants to apply it to his/her model
CloseUpApplyChange = Apply

local gtt = GameTooltip
local function gttshow(this)
	gtt:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
	gtt:SetText(this.tt)
	if CloseUpNPCModel and CloseUpNPCModel:IsVisible() and this.tt == "Undress" then
		gtt:AddLine("Cannot dress NPC models")
	end
	gtt:Show()
end
local function gtthide()
	gtt:Hide()
end
local function newbutton(name, parent, text, w, h, button, tt, func)
	local b = button or CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
	b:SetText(text or b:GetText())
	b:SetWidth(w or b:GetWidth())
	b:SetHeight(h or b:GetHeight())
	b:SetScript("OnClick", func)
	if tt then
		b.tt = tt
		b:SetScript("OnEnter", gttshow)
		b:SetScript("OnLeave", gtthide)
	end
	return b
end

-- modifies the auction house dressing room
local function DoAH()
	Apply("AuctionDressUpModel", nil, 370, 0, 10)
	local tb, du = SideDressUpModelResetButton, SideDressUpModel
	local w, h = 20, tb:GetHeight()
	newbutton(nil, nil, "T", w, h, tb, "Target", function()
		if UnitExists("target") and UnitIsVisible("target") then
			du:SetUnit("target")
		end
	end)
	local a,b,c,d,e = tb:GetPoint()
	tb:SetPoint(a,b,c,d,e-30)
	newbutton("CloseUpAHResetButton", du, "R", 20, 22, nil, "Reset", function() Model_Reset(du) end):SetPoint("RIGHT", tb, "LEFT", 0, 0)
	newbutton("CloseUpAHUndressButton", du, "U", 20, 22, nil, "Undress", function() du:Undress() end):SetPoint("LEFT", tb, "RIGHT", 0, 0)
	ToggleBG(true)
	if _G["SideDressUpModelControlFrame"] then
		_G["SideDressUpModelControlFrame"]:Hide()
		_G["SideDressUpModelControlFrame"]:EnableMouse(false)
		_G["SideDressUpModelControlFrame"]:SetScript("OnEnter", nada)
		_G["SideDressUpModelControlFrame"].Show = nada
	end
end
local function DoPet()
	if PetJournalPetCardModelFrame then
		Apply("PetJournalPetCardModelFrame")
		if _G["MountJournal"] and _G["MountJournal"].MountDisplay and _G["MountJournal"].MountDisplay.ModelFrame then
			if not MountJournalModelFrame then
				MountJournalModelFrame = _G["MountJournal"].MountDisplay.ModelFrame
			end
			Apply("MountJournalModelFrame")
		end
	end
end
-- now apply the changes
-- need an event frame since 2 of the models are from LoD addons
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(this, event, a1)
	if a1 == "Blizzard_AuctionUI" then
		DoAH()
	elseif a1 == "Blizzard_InspectUI" then
		Apply("InspectModelFrame")
	elseif a1 == "Blizzard_PetJournal" then
		DoPet()
	end
end)
-- in case Blizzard_AuctionUI or Blizzard_InspectUI were loaded early
if AuctionDressUpModel then
	DoAH()
end
if InspectModelFrame then 
	Apply("InspectModelFrame")
end
DoPet()

-- main dressing room model with undress buttons
do
	Apply("DressUpModel", nil, 332, nil, 104)
	local tb = DressUpFrameCancelButton
	local w, h = 40, tb:GetHeight()
	local m = DressUpModel

	-- since 2.1 dressup models doesn't apply properly to NPCs, make a substitute
	local tm = CreateFrame("PlayerModel", "CloseUpNPCModel", DressUpFrame)
	tm:SetAllPoints(DressUpModel)
	tm:Hide()
	Apply("CloseUpNPCModel", nil, nil, nil, nil, nil, true)
	
	DressUpFrame:HookScript("OnShow", function()
		tm:Hide()
		m:Show()
		ToggleBG(true)
	end)
	if _G["DressUpFrameResetButton"] and _G["DressUpModel"] then
		_G["DressUpFrameResetButton"]:SetScript("OnClick", function()
			Model_Reset(_G["DressUpModel"])
		end)
	end
	-- convert default close button into set target button
	newbutton(nil, nil, "Tar", w, h, tb, "Target", function()
		if UnitExists("target") and UnitIsVisible("target") then 
			if UnitIsPlayer("target") then
				tm:Hide()
				m:Show()
				m:SetUnit("target")
			else
				tm:Show()
				m:Hide()
				tm:SetUnit("target")
			end
			SetPortraitTexture(DressUpFramePortrait, "target")
		end
	end)
	local a,b,c,d,e = tb:GetPoint()
	tb:SetPoint(a, b, c, d - (w/2), e)

	newbutton("CloseUpUndressButton", DressUpFrame, "Und", w, h, nil, "Undress", function() m:Undress() end):SetPoint("LEFT", tb, "RIGHT", -2, 0)
end

Apply("CharacterModelFrame")
Apply("TabardModel", nil, nil, nil, nil, "TabardCharacterModel")
Apply("PetModelFrame")
Apply("PetStableModel")
Apply("QuestNPCModel", nil, nil, nil, nil, nil, true)
Apply("TutorialNPCModel", nil, nil, nil, nil, nil, true)
if _G["PetPaperDollPetInfo"] then
	PetPaperDollPetInfo:SetFrameStrata("HIGH")
end
Apply("CompanionModelFrame")


