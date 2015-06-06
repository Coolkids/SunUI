--Create a Mover frame by Elv
local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local AddOnName = ...
local AceConfig = LibStub("AceConfigDialog-3.0")

S.CreatedMovers = {}
local selectedValue = "ALL"
local selectedFrame
local MoverTypes = {
    "ALL",
    "GENERAL",
	"UNITFRAMES",
    "ACTIONBARS",
	"MINITOOLS",
	"FILGER",
}

local function SizeChanged(frame)
	if InCombatLockdown() then return; end
	frame.mover:SetSize(frame:GetSize())
end

local function GetPoint(obj)
	local point, anchor, secondaryPoint, x, y = obj:GetPoint()
	if not anchor then anchor = UIParent end

	return string.format("%s\031%s\031%s\031%d\031%d", point, anchor:GetName(), secondaryPoint, S:Round(x), S:Round(y))
end

local function MoverTypes_OnClick(self)
	selectedValue = self.value
	S:ToggleConfigMode(false, self.value)
	UIDropDownMenu_SetSelectedValue(SunUIMoverPopupWindowDropDown, self.value)
end

local function MoverTypes_Initialize()
	local info = UIDropDownMenu_CreateInfo()
	info.func = MoverTypes_OnClick
	
	for _, moverTypes in ipairs(MoverTypes) do
		info.text = L[moverTypes]
		info.value = moverTypes
		UIDropDownMenu_AddButton(info)
	end

	UIDropDownMenu_SetSelectedValue(SunUIMoverPopupWindowDropDown, selectedValue)
end

local function Mover_Setting(arrow)
	if selectedFrame == nil then return end
	local point, anchor, secondaryPoint, x, y = string.split("\031", GetPoint(_G[selectedFrame.name]))
	if arrow == "up" then
		selectedFrame:SetPoint(point, anchor, secondaryPoint, x, y+1)
	elseif arrow == "down" then
		selectedFrame:SetPoint(point, anchor, secondaryPoint, x, y-1)
	elseif arrow == "left" then
		selectedFrame:SetPoint(point, anchor, secondaryPoint, x-1, y)
	elseif arrow == "right" then
		selectedFrame:SetPoint(point, anchor, secondaryPoint, x+1, y)
	end	
	S:SaveMoverPosition(selectedFrame.name)
end

local function CreatePopup()
	local A = S:GetModule("Skins")
	local f = CreateFrame("Frame", "SunUIMoverPopupWindow", UIParent)
	f:SetFrameStrata("DIALOG")
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:SetWidth(360)
	f:SetHeight(110)
	f:SetPoint("TOP", 0, -50)
	f:Hide()
	A:SetBD(f)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) self:StartMoving() self:SetUserPlaced(false) end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	f:SetScript("OnShow", function() PlaySound("igMainMenuOption") end)
	f:SetScript("OnHide", function() PlaySound("gsTitleOptionExit") end)

	local title = f:CreateFontString(nil, "OVERLAY")
	title:SetFontObject(GameFontNormal)
	title:SetShadowOffset(S.mult, -S.mult)
	title:SetShadowColor(0, 0, 0)
	title:SetPoint("TOP", f, "TOP", 0, -10)
	title:SetJustifyH("CENTER")
	title:SetText("SunUI")

	local desc = f:CreateFontString(nil, "ARTWORK")
	desc:SetFontObject("GameFontHighlight")
	desc:SetJustifyV("TOP")
	desc:SetJustifyH("LEFT")
	desc:SetPoint("TOPLEFT", 18, -32)
	desc:SetPoint("BOTTOMRIGHT", -18, 48)
	desc:SetText(L["锚点已解锁，拖动锚点移动位置，完成后点击锁定按钮。"])

	local lock = CreateFrame("Button", "SunUILock", f, "OptionsButtonTemplate")
	_G[lock:GetName() .. "Text"]:SetText(L["锁定"])

	lock:SetScript("OnClick", function(self)
		SlashCmdList.TOGGLEGRID()
		S:ToggleConfigMode(true)
		AceConfig["Open"](AceConfig,"SunUI") 
		selectedValue = "ALL"
		UIDropDownMenu_SetSelectedValue(SunUIMoverPopupWindowDropDown, selectedValue)
	end)

	lock:SetPoint("BOTTOMRIGHT", -14, 14)
	A:Reskin(lock)

	f:RegisterEvent('PLAYER_REGEN_DISABLED')
	f:SetScript("OnEvent", function(self)
		if self:IsShown() then
			self:Hide()
		end
	end)

	local moverTypes = CreateFrame("Frame", f:GetName().."DropDown", f, "UIDropDownMenuTemplate")
	moverTypes:Point("BOTTOMRIGHT", lock, "TOPRIGHT", 18, -5)
    moverTypes:Width(160)
	A:ReskinDropDown(moverTypes)
	moverTypes.text = moverTypes:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	moverTypes.text:SetPoint("RIGHT", moverTypes, "LEFT", 2, 2)
	moverTypes.text:SetText(L["模式"])	
	
	
	UIDropDownMenu_Initialize(moverTypes, MoverTypes_Initialize)


	--框体细调
	local fs = CreateFrame("Frame", "SunUIMoverSetPopupWindow", f)
	fs:SetFrameStrata("DIALOG")
	fs:SetToplevel(true)
	fs:EnableMouse(true)
	fs:SetClampedToScreen(true)
	fs:SetWidth(360)
	fs:SetHeight(150)
	fs:SetPoint("LEFT", UIParent, "LEFT", 200, 0)
	A:SetBD(fs)
	fs:SetMovable(true)
	fs:RegisterForDrag("LeftButton")
	fs:SetScript("OnDragStart", function(self) self:StartMoving() self:SetUserPlaced(false) end)
	fs:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

	local ti = fs:CreateFontString(nil, "OVERLAY")
	ti:SetFontObject(GameFontNormal)
	ti:SetShadowOffset(S.mult, -S.mult)
	ti:SetShadowColor(0, 0, 0)
	ti:SetPoint("TOPLEFT", fs, "TOPLEFT", 10, -10)
	ti:SetJustifyH("CENTER")
	ti:SetText(L["框体名字"])

	fs.name = fs:CreateFontString(nil, "ARTWORK")
	fs.name:SetFontObject("GameFontHighlight")
	fs.name:SetJustifyV("TOP")
	fs.name:SetJustifyH("LEFT")
	fs.name:SetPoint("LEFT", ti, "RIGHT", 5, 0)
	fs.name:SetText("")


	fs.point = fs:CreateFontString(nil, "ARTWORK")
	fs.point:SetFontObject("GameFontHighlight")
	fs.point:SetPoint("TOPLEFT", ti, "BOTTOMLEFT", 0, -5)
	fs.point:SetText("")
	
	local ti2 = fs:CreateFontString(nil, "OVERLAY")
	ti2:SetFontObject(GameFontNormal)
	ti2:SetShadowOffset(S.mult, -S.mult)
	ti2:SetShadowColor(0, 0, 0)
	ti2:SetPoint("LEFT", 10, 0)
	ti2:SetJustifyH("CENTER")
	ti2:SetText(L["手动输入"])

	local editBox = CreateFrame("EditBox", "SunUIMoverSetEditBox", fs)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetPoint("TOPLEFT", ti2, "BOTTOMLEFT", 0, -5)
	editBox:SetWidth(230)
	editBox:SetHeight(20)
	editBox.border = CreateFrame("Frame", nil, editBox)
	editBox.border:SetPoint("TOPLEFT", -3, 0)
	editBox.border:SetPoint("BOTTOMRIGHT", 0, 0)
	A:CreateBD(editBox.border, 0)
	
	editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	editBox:SetScript("OnEnterPressed", function(self)
		if selectedFrame == nil then return end
		local point, anchor, secondaryPoint, x, y
		if self:GetText():find(",") then
			point, anchor, secondaryPoint, x, y = string.split(",", self:GetText())
			selectedFrame:ClearAllPoints()
			selectedFrame:SetPoint(point, anchor, secondaryPoint, x, y)
			S:SaveMoverPosition(selectedFrame.name)
			SunUIMoverSetPopupWindow.point:SetText(tostring(point).." ,"..tostring(anchor).." ,"..tostring(secondaryPoint).." ,"..tostring(x).." ,"..tostring(y))
			editBox:SetText("")
		else
			editBox:SetText(L["格式不正确"])
		end
		self:ClearFocus() 
	end)

	local up = CreateFrame("Button", "SunUIMoverSetUp", fs, "OptionsButtonTemplate")
	_G[up:GetName() .. "Text"]:SetText("↑")

	up:SetScript("OnMouseWheel", function(self)
		Mover_Setting("up")
	end)
	up:SetScript("OnMouseDown", function(self)
		Mover_Setting("up")
	end)

	up:SetSize(20, 20)
	up:SetPoint("TOPRIGHT", -45, -50)
	A:Reskin(up)

	
	local down = CreateFrame("Button", "SunUIMoverSetDown", fs, "OptionsButtonTemplate")
	_G[down:GetName() .. "Text"]:SetText("↓")

	down:SetScript("OnMouseWheel", function(self)
		Mover_Setting("down")
	end)
	down:SetScript("OnMouseDown", function(self)
		Mover_Setting("down")
	end)
	down:SetSize(20, 20)
	down:SetPoint("TOP", up, "BOTTOM", 0, -20)
	A:Reskin(down)

	local left = CreateFrame("Button", "SunUIMoverSetLeft", fs, "OptionsButtonTemplate")
	_G[left:GetName() .. "Text"]:SetText("←")

	left:SetScript("OnMouseWheel", function(self)
		Mover_Setting("left")
	end)
	left:SetScript("OnMouseDown", function(self)
		Mover_Setting("left")
	end)
	left:SetSize(20, 20)
	left:SetPoint("TOPRIGHT", up, "BOTTOMLEFT", -10, 0)
	A:Reskin(left)

	local right = CreateFrame("Button", "SunUIMoverSetRight", fs, "OptionsButtonTemplate")
	_G[right:GetName() .. "Text"]:SetText("→")

	right:SetScript("OnMouseWheel", function(self)
		Mover_Setting("right")
	end)
	right:SetScript("OnMouseDown", function(self)
		Mover_Setting("right")
	end)
	right:SetSize(20, 20)
	right:SetPoint("TOPLEFT", up, "BOTTOMRIGHT", 10, 0)
	A:Reskin(right)


end

local function CreateMover(parent, name, text, overlay, postdrag, ignoreSizeChange)
	if not parent then return end
	if S.CreatedMovers[name].Created then return end
	local index = S.db.layout.mainLayout
	local A = S:GetModule("Skins")

	if overlay == nil then overlay = true end

	local point, anchor, secondaryPoint, x, y = string.split("\031", GetPoint(parent))

	local f = CreateFrame("Button", name, UIParent)
	f:SetFrameLevel(parent:GetFrameLevel() + 1)
	f:SetWidth(parent:GetWidth())
	f:SetHeight(parent:GetHeight())

	if overlay == true then
		f:SetFrameStrata("DIALOG")
	else
		f:SetFrameStrata("BACKGROUND")
	end
	if S.db["movers"]and S.db["movers"][index] and S.db["movers"][index][name] then
		if type(S.db["movers"][index][name]) == "table" then
            f:SetPoint(S.db["movers"][index][name]["p"], UIParent, S.db["movers"][index][name]["p2"], S.db["movers"][index][name]["p3"], S.db["movers"][index][name]["p4"])
			S.db["movers"][index][name] = GetPoint(f)
			f:ClearAllPoints()
		end

		local point, anchor, secondaryPoint, x, y = string.split("\031", S.db["movers"][index][name])
		f:SetPoint(point, anchor, secondaryPoint, x, y)
	else
		f:SetPoint(point, anchor, secondaryPoint, x, y)
	end
	A:Reskin(f)
	f:RegisterForDrag("LeftButton", "RightButton")
	f:HookScript("OnMouseDown", function(self)
		selectedFrame = self
		selectedFrame.parent = parent
		selectedFrame.name = name
		SunUIMoverSetPopupWindow.name:SetText(text)
		local point, anchor, secondaryPoint, x, y = string.split("\031", GetPoint(_G[name]))
		SunUIMoverSetPopupWindow.point:SetText(tostring(point).." ,"..tostring(anchor).." ,"..tostring(secondaryPoint).." ,"..tostring(x).." ,"..tostring(y))
	end)

	f:SetScript("OnDragStart", function(self) 
		if InCombatLockdown() then S:Print(ERR_NOT_IN_COMBAT) return end
		self:StartMoving() 
	end)

	f:SetScript("OnDragStop", function(self) 
		if InCombatLockdown() then S:Print(ERR_NOT_IN_COMBAT) return end
		self:StopMovingOrSizing()

		local screenWidth, screenHeight, screenCenter = UIParent:GetRight(), UIParent:GetTop(), UIParent:GetCenter()
		local x, y = self:GetCenter()
		local point
		
		local LEFT = screenWidth / 3
		local RIGHT = screenWidth * 2 / 3
		local TOP = screenHeight / 2
		
		if y >= TOP then
			point = "TOP"
			y = -(screenHeight - self:GetTop())
		else
			point = "BOTTOM"
			y = self:GetBottom()
		end
		
		if x >= RIGHT then
			point = point.."RIGHT"
			x = self:GetRight() - screenWidth
		elseif x <= LEFT then
			point = point.."LEFT"
			x = self:GetLeft()
		else
			x = x - screenCenter
		end

		self:ClearAllPoints()
		self:Point(point, UIParent, point, x, y)

		S:SaveMoverPosition(name)
		
		if postdrag ~= nil and type(postdrag) == "function" then
			postdrag(self, S:GetScreenQuadrant(self))
		end

		self:SetUserPlaced(false)

	end)

    if not ignoreSizeChange then
        parent:SetScript("OnSizeChanged", SizeChanged)
        parent.mover = f
    end
	parent:ClearAllPoints()
	parent:SetPoint(point, f, 0, 0)
	parent.ClearAllPoints = function() return end
	parent.SetAllPoints = function() return end
	parent.SetPoint = function() return end

	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(S["media"].font, S["media"].fontsize)
	fs:SetShadowOffset(S.mult*1.2, -S.mult*1.2)
	fs:SetJustifyH("CENTER")
	fs:SetPoint("CENTER")
	fs:SetText(text or name)
	fs:SetTextColor(1, 1, 1)
	f:SetFontString(fs)
	f.text = fs

	f:HookScript("OnEnter", function(self) 
		self.text:SetTextColor(self:GetBackdropBorderColor())
	end)
	f:HookScript("OnLeave", function(self)
		self.text:SetTextColor(1, 1, 1)
	end)

	f:SetMovable(true)
	f:Hide()

	if postdrag ~= nil and type(postdrag) == "function" then
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self, event)
			postdrag(f)
			self:UnregisterAllEvents()
		end)
	end

	S.CreatedMovers[name].Created = true
end

function S:CreateMover(parent, name, text, overlay, postdrag, moverTypes, ignoreSizeChange)
	if not moverTypes then moverTypes = "ALL,GENERAL" end

	if S.CreatedMovers[name] == nil then 
		S.CreatedMovers[name] = {}
		S.CreatedMovers[name]["parent"] = parent
		S.CreatedMovers[name]["text"] = text
		S.CreatedMovers[name]["overlay"] = overlay
		S.CreatedMovers[name]["postdrag"] = postdrag
		S.CreatedMovers[name]["point"] = GetPoint(parent)

		S.CreatedMovers[name]["type"] = {}
		local types = {string.split(",", moverTypes)}
		for i = 1, #types do
			local moverType = types[i]
			S.CreatedMovers[name]["type"][moverType] = true
		end
	end

	CreateMover(parent, name, text, overlay, postdrag, ignoreSizeChange)
end

function S:SaveMoverPosition(name)
	local index = S.db.layout.mainLayout
	if not _G[name] then return end
	if not S.db.movers then S.db.movers = {} end
	if not S.db.movers[index] then S.db.movers[index] = {} end

	S.db.movers[index][name] = GetPoint(_G[name])
	local point, anchor, secondaryPoint, x, y = string.split("\031", S.db["movers"][index][name])
	SunUIMoverSetPopupWindow.point:SetText(tostring(point).." ,"..tostring(anchor).." ,"..tostring(secondaryPoint).." ,"..tostring(x).." ,"..tostring(y))
end

function S:ToggleConfigMode(override, moverType)
	if InCombatLockdown() then return end
	if override ~= nil and override ~= "" then S.ConfigurationMode = override end

	if S.ConfigurationMode ~= true then
		if not SunUIMoverPopupWindow then
			CreatePopup()
		end
		
		SunUIMoverPopupWindow:Show()
		AceConfig["Close"](AceConfig, "SunUI") 
		GameTooltip:Hide()		
		S.ConfigurationMode = true
	else
		if SunUIMoverPopupWindow then
			SunUIMoverPopupWindow:Hide()
		end	
		
		S.ConfigurationMode = false
	end
	
	if type(moverType) ~= "string" then
		moverType = nil
	end
	
	self:ToggleMovers(S.ConfigurationMode, moverType or "ALL")
end

function S:ToggleMovers(show, moverType)
	for name, _ in pairs(S.CreatedMovers) do
		if not show then
			_G[name]:Hide()
		else
			if S.CreatedMovers[name]["type"][moverType] then
				_G[name]:Show()
			else
				_G[name]:Hide()
			end
		end
	end
end

function S:ResetMovers(arg)
	if arg == "" or arg == nil then
		for name, _ in pairs(S.CreatedMovers) do
			local f = _G[name]
			local point, anchor, secondaryPoint, x, y = string.split("\031", S.CreatedMovers[name]["point"])
			f:ClearAllPoints()
			f:SetPoint(point, anchor, secondaryPoint, x, y)
			
			for key, value in pairs(S.CreatedMovers[name]) do
				if key == "postdrag" and type(value) == "function" then
					value(f, S:GetScreenQuadrant(f))
				end
			end
		end	
		self.db.movers = nil
	else
		for name, _ in pairs(S.CreatedMovers) do
			for key, value in pairs(S.CreatedMovers[name]) do
				local mover
				if key == "text" then
					if arg == value then 
						local f = _G[name]
						local point, anchor, secondaryPoint, x, y = string.split("\031", S.CreatedMovers[name]["point"])
						f:ClearAllPoints()
						f:SetPoint(point, anchor, secondaryPoint, x, y)				
						
						if self.db.movers then
							self.db.movers[name] = nil
						end
						
						if S.CreatedMovers[name]["postdrag"] ~= nil and type(S.CreatedMovers[name]["postdrag"]) == "function" then
							S.CreatedMovers[name]["postdrag"](f, S:GetScreenQuadrant(f))
						end
					end
				end
			end	
		end
	end
end

function S:SetMoversPositions()
	local index = S.db.layout.mainLayout
	for name, _ in pairs(S.CreatedMovers) do
		local f = _G[name]
		local point, anchor, secondaryPoint, x, y
		if S.db["movers"] and S.db["movers"][index] and S.db["movers"][index][name] and type(S.db["movers"][index][name]) == "string" then
			point, anchor, secondaryPoint, x, y = string.split("\031", S.db["movers"][index][name])
			f:ClearAllPoints()
			f:SetPoint(point, anchor, secondaryPoint, x, y)
		elseif f then
			point, anchor, secondaryPoint, x, y = string.split("\031", S.CreatedMovers[name]["point"])
			f:ClearAllPoints()
			f:SetPoint(point, anchor, secondaryPoint, x, y)
		end		
	end
end

function S:LoadMovers()
	for n, _ in pairs(S.CreatedMovers) do
		local p, t, o, pd
		for key, value in pairs(S.CreatedMovers[n]) do
			if key == "parent" then
				p = value
			elseif key == "text" then
				t = value
			elseif key == "overlay" then
				o = value
			elseif key == "postdrag" then
				pd = value
			end
		end
		CreateMover(p, n, t, o, pd)
	end
end
