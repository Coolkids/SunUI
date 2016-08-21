local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local RT = E:NewModule("RLTools", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local RU = E:GetModule('RaidUtility');
function RT:CreateText(parent, text, point)
	local texture = E:CreateFS(parent)
	texture:SetText(text)
	texture:SetTextColor(RAID_CLASS_COLORS[E.myclass].r, RAID_CLASS_COLORS[E.myclass].g, RAID_CLASS_COLORS[E.myclass].b)
	texture:SetJustifyV("MIDDLE")
	texture:SetJustifyH("CENTER")
	if point then
		texture:SetPoint(unpack(point))
	else
		texture:SetAllPoints()
	end
	return texture
end

function RT:CreateButton(parent, width, height, text, point, func, reskin)
	local button
	if type(parent) == "table" then
		button = CreateFrame("Button", nil, parent)
	elseif _G[parent] then
		button = CreateFrame("Button", nil, _G[parent])
	else
		button = CreateFrame("Button", nil, UIParent)
	end
	 
	button:SetSize(width, height)
	button:SetPoint(unpack(point))
	button.text = self:CreateText(button, text)
	if reskin==nil or reskin then
		local A = E:GetModule("Skins-SunUI")
		A:Reskin(button)
	end
	button:SetScript("OnMouseDown", func)
	return button
end

function RT:initButton()
	--主按钮
	self.mainButton = self:CreateButton(oUF_PetBattleFrameHider, 70, 20, RT.L.RAIDCHECK_RAIDTOOL, {"TOP", UIParent, "TOP", 0, -5}, function()
		if not self.mainFrame.bannerShown then
			E:ShowAnima(self.mainFrame)
		else
			E:HideAnima(self.mainFrame)
		end
	end)
	E:CreateMover(self.mainButton, "RLToolsMover", RT.L.RAIDCHECK_RAIDTOOL, nil, nil, nil,"ALL,SunUI")
	--主界面
	self.mainFrame = CreateFrame("Button", nil, self.mainButton)
	self.mainFrame:SetSize(226, 166)
	self.mainFrame:SetPoint("TOP", self.mainButton, "BOTTOM", 0, -5)
	self.mainFrame:Hide()
	
	--返回按钮
	self.backButton = self:CreateButton(self.mainFrame, 22, 22, "^", {"TOP", self.mainFrame, "BOTTOM", 0, -5}, function()
		E:HideAnima(self.mainFrame)
	end)

	--解散队伍/团队
	self.mainFrame.disband = self:CreateButton(self.mainFrame, 70, 20, TEAM_DISBAND, {"TOPLEFT", self.mainFrame, "TOPLEFT", 3, -3}, function()
		SlashCmdList.GROUPDISBAND()
	end)  
	--转换小队
	self.mainFrame.toparty = self:CreateButton(self.mainFrame, 70, 20, CONVERT_TO_PARTY, {"LEFT", self.mainFrame.disband, "RIGHT", 5, 0}, function()
		ConvertToParty()
	end)  
	--转换团队
	self.mainFrame.toraid = self:CreateButton(self.mainFrame, 70, 20, CONVERT_TO_RAID, {"LEFT", self.mainFrame.toparty, "RIGHT", 5, 0}, function()
		ConvertToRaid()
	end)  
	--职责确认
	self.mainFrame.role = self:CreateButton(self.mainFrame, 70, 20, ROLE_POLL, {"TOP", self.mainFrame.disband, "BOTTOM", 0, -5}, function()
		InitiateRolePoll()
	end)  
	--就位确认
	self.mainFrame.ready = self:CreateButton(self.mainFrame, 70, 20, READY_CHECK, {"LEFT", self.mainFrame.role, "RIGHT", 5, 0}, function()
		DoReadyCheck()
	end)
	self.mainFrame.control = self:CreateButton(self.mainFrame, 70, 20, RAID_CONTROL, {"LEFT", self.mainFrame.ready, "RIGHT", 5, 0}, function()
		ToggleFriendsFrame(4)
	end)
	--队伍标记图标
	self.mainFrame.lable1 = self:CreateText(self.mainFrame, RAID_TARGET_ICON, {"TOPLEFT", self.mainFrame.role, "BOTTOMLEFT", 0, -5})
	--图标
	for i = 1, 8 do
		self.mainFrame["mark"..i] = CreateFrame("Button", nil, self.mainFrame)
		self.mainFrame["mark"..i]:SetSize(20, 20)
		self.mainFrame["mark"..i]:SetID(i)
		if i == 1 then
			self.mainFrame["mark"..i]:SetPoint("TOPLEFT", self.mainFrame.lable1, "BOTTOMLEFT", 0, -5)
		else
			self.mainFrame["mark"..i]:SetPoint("LEFT", self.mainFrame["mark"..(i-1)], "RIGHT", 5, 0)
		end
		self.mainFrame["mark"..i].texture = self.mainFrame["mark"..i]:CreateTexture(nil, "ARTWORK");
		self.mainFrame["mark"..i].texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
		self.mainFrame["mark"..i].texture:SetAllPoints()
		SetRaidTargetIconTexture(self.mainFrame["mark"..i].texture, i)
		self.mainFrame["mark"..i]:SetScript("OnMouseDown", function(self)
			SetRaidTarget("target", self:GetID())
		end)
	end
	self.mainFrame.mark9 = CreateFrame("Button", nil, self.mainFrame)
	self.mainFrame.mark9:SetSize(20, 20)
	self.mainFrame.mark9:SetID(0)
	self.mainFrame.mark9:SetPoint("LEFT", self.mainFrame.mark8, "RIGHT", 5, 0)
	self.mainFrame.mark9.texture = self:CreateText(self.mainFrame.mark9, RAID_TARGET_NONE)
	self.mainFrame.mark9:SetScript("OnMouseDown", function(self)
		SetRaidTarget("target", self:GetID())
	end)

	--世界标记2
	self.mainFrame.lable2 = self:CreateText(self.mainFrame, string.sub(WORLD_MARKER, 0,WORLD_MARKER:find("%%")-1), {"TOPLEFT", self.mainFrame.mark1, "BOTTOMLEFT", 0, -5})
	local wmmark={
		[1] = 6;
		[2] = 4;
		[3] = 3;
		[4] = 7;
		[5] = 1;
		[6] = 2;
		[7] = 5;
		[8] = 8;
	}

	--地面标记
	for i = 1, 8 do
		self.mainFrame["wmark"..i] = CreateFrame("Button", "SunUI_wmark"..i, self.mainFrame, "SecureActionButtonTemplate")
		self.mainFrame["wmark"..i]:SetSize(20, 20)
		if i == 1 then
			self.mainFrame["wmark"..i]:SetPoint("TOPLEFT", self.mainFrame, "TOPLEFT", 3, -112)
		else
			self.mainFrame["wmark"..i]:SetPoint("LEFT", self.mainFrame["wmark"..(i-1)], "RIGHT", 5, 0)
		end
		self.mainFrame["wmark"..i].texture = self.mainFrame["wmark"..i]:CreateTexture(nil, "ARTWORK");
		self.mainFrame["wmark"..i].texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
		self.mainFrame["wmark"..i].texture:SetAllPoints(self.mainFrame["wmark"..i])
		
		SetRaidTargetIconTexture(self.mainFrame["wmark"..i].texture, wmmark[i])
		self.mainFrame["wmark"..i]:SetAttribute("type", "macro")
		self.mainFrame["wmark"..i]:SetAttribute("macrotext1", string.format("/wm %d",i))
		--S:Print(self.mainFrame["wmark"..i]:GetPoint())
	end
	self.mainFrame.wmark9 = CreateFrame("Button", nil, self.mainFrame, "SecureActionButtonTemplate")
	self.mainFrame.wmark9:SetSize(20, 20)
	self.mainFrame.wmark9:SetPoint("LEFT", self.mainFrame.wmark8, "RIGHT", 5, 0)
	self.mainFrame.wmark9.texture = self:CreateText(self.mainFrame.wmark9, RAID_TARGET_NONE)
	self.mainFrame.wmark9:SetScript("OnMouseDown", function(self, btn)
		ClearRaidMarker()
	end)

	self.mainFrame.asbutton = self:CreateButton(self.mainFrame, 45, 20, ALL_ASSIST_LABEL, {"BOTTOMRIGHT", -28, 3}, function(self) 
		if RaidFrameAllAssistCheckButton:IsEnabled() then
			SetEveryoneIsAssistant(true)
			self.checkButton:SetChecked(true)
		else
			self.checkButton:SetChecked(false)
		end
	end, false)
	
	self.mainFrame.asbutton.checkButton = CreateFrame("CheckButton", nil, self.mainFrame.asbutton, "OptionsCheckButtonTemplate")
	self.mainFrame.asbutton.checkButton:SetPoint("LEFT", self.mainFrame.asbutton, "RIGHT", 3, 0)
	self.mainFrame.asbutton.checkButton:SetScript("OnClick", function(self)
		if RaidFrameAllAssistCheckButton:IsEnabled() then
			SetEveryoneIsAssistant(self:GetChecked())
		else
			self:SetChecked(false)
		end
	end)

	--buff检查
	self.mainFrame.buffcheck = self:CreateButton(self.mainFrame, 60, 20, RT.L.RaidCheckTipLeftButtonOnRightInfo, {"BOTTOMLEFT", 3, 3}, function()
		RT:CheckRaidBuff()
	end)
	--药剂检查
	self.mainFrame.flaskcheck = self:CreateButton(self.mainFrame, 60, 20, RT.L.RaidCheckTipRightButtonOnRightInfo, {"LEFT", self.mainFrame.buffcheck, "RIGHT", 5, 0}, function()
		RT:CheckRaidFlask()
	end)

	--世界标记
	self.mainFrame.wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
	self.mainFrame.wm:SetParent(self.mainButton)
	self.mainFrame.wm:ClearAllPoints()
	self.mainFrame.wm:SetPoint("RIGHT", self.mainButton, "LEFT", -5, 0)
	self.mainFrame.wm:SetSize(20, 20)

	--世界标记
	self.mainFrame.more = self:CreateButton(self.mainButton, 20, 20, ">", {"LEFT", self.mainButton, "RIGHT", 5, 0}, function(self, button)
		local wmmenuFrame = CreateFrame("Frame", "SunUI_RaidTools_UIDropDownMenu", self.mainButton, "UIDropDownMenuTemplate") 
		local wmmenuList = { 
			{text = RT.L.RaidCheckTipLeftButtonOnLeftInfo, 
			func = function() RT:CheckPosition() end}, 
			{text = RT.L.RaidCheckTipRightButtonOnLeftInfo, 
			func = function() DoReadyCheck() end}, 
			{text = RT.L.RaidCheckTipLeftButtonOnRightInfo, 
			func = function() RT:CheckRaidBuff() end}, 
			{text = RT.L.RaidCheckTipRightButtonOnRightInfo, 
			func = function() RT:CheckRaidFlask() end}, 
		}

		if (button=="RightButton") then 
			EasyMenu(wmmenuList, wmmenuFrame, "cursor", 10, 0, "MENU", 2)
		elseif (button=="LeftButton") then
			DoReadyCheck()
		else
			InitiateRolePoll()
		end
	end)
end

function RT:SetPoint()
	if TopInfoPanel then
		self.mainButton:SetPoint("TOP", TopInfoPanel, "BOTTOM", 0, -5)
	else
		self.mainButton:SetPoint("TOP", UIParent, 0, -5)
	end
end

function RT:Reskin()
	local A = E:GetModule("Skins-SunUI")
	A:Reskin(self.mainButton)
	A:CreateShadow2(self.mainFrame, "Background")
	A:Reskin(self.mainFrame.wm, false, true)
	A:ReskinCheck(self.mainFrame.asbutton.checkButton)
end

function RT:SetScript()
	self.mainFrame.wm:HookScript("OnMouseDown", function(self, btn)
		if btn == "RightButton" then
			ClearRaidMarker()
		end
	end)

	self.mainFrame.asbutton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(ALL_ASSIST_DESCRIPTION)
		if not RaidFrameAllAssistCheckButton:IsEnabled() then
			GameTooltip:AddLine(ALL_ASSIST_NOT_LEADER_ERROR, 1, 0, 0)
		end
		GameTooltip:Show()
	end)
	self.mainFrame.asbutton:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
end

function RT:PLAYER_ENTERING_WORLD()
	self:OnEvent()
end

function RT:GROUP_ROSTER_UPDATE()
	self:OnEvent()
end
function RT:OnEvent()
	local inraid = self:CheckRaidStatus()
	if inraid then
		self.mainButton:Show()
	else
		self.mainButton:Hide()
	end
end

function RT:Initialize()
	self:initButton()
	--self:SetPoint()
	self:Reskin()
	self:SetScript()
	--事件
	self:RegisterEvent("PLAYER_ENTERING_WORLD") 
	self:RegisterEvent("GROUP_ROSTER_UPDATE")  
end

function RU:ToggleRaidUtil()
	self:UnregisterAllEvents()
	RaidUtilityPanel:Hide()	
	RaidUtility_ShowButton:Hide()	
	return;
end

E:RegisterModule(RT:GetName())