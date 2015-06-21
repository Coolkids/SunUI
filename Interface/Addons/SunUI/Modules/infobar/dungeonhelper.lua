local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")

function IB:CreateDungeonhelper()

	local A = S:GetModule("Skins")
	local stat = CreateFrame("Frame", "InfoPanelBottom3", BottomInfoPanel or UIParent)
	stat:SetFrameStrata("BACKGROUND")
	stat:SetFrameLevel(3)
	stat:EnableMouse(true)

	stat.text = S:CreateFS(stat, nil, nil, IB.font)
	stat.text:SetPoint("LEFT", InfoPanelBottom2 or InfoPanelBottom1, "RIGHT", 20, 0)
	
	stat.icon = stat:CreateTexture(nil, "OVERLAY")
	stat.icon:SetSize(8, 8)
	stat.icon:SetPoint("RIGHT", stat.text, "LEFT", -5, 0)
	stat.icon:SetTexture(IB.backdrop)
	stat.icon:SetVertexColor(unpack(IB.InfoBarStatusColor[3]))
	A:CreateShadow(stat, stat.icon)
	
	stat:SetPoint("TOPLEFT", stat.icon)
	stat:SetPoint("BOTTOMLEFT", stat.icon)
	stat:SetPoint("TOPRIGHT", stat.text)
	stat:SetPoint("BOTTOMRIGHT", stat.text)

	-- for i = 1, GetNumRandomDungeons() do
		-- local id, name = GetLFGRandomDungeonInfo(i)
		-- print(id .. ": " .. name.. "index:"..i)
	-- end
	--id=462, i=9 -- 随机MOP5H
	local str = BATTLEGROUND_HOLIDAY   --"戰鬥的號角";
	--local tank = "|TInterface\\Addons\\SunUI_Freebgrid\\media\\lfd_role.tga:"..S["media"].fontsize..":"..S["media"].fontsize..":0:0:64:64:0:17:22:41|t"
	--local healer = "|TInterface\\Addons\\SunUI_Freebgrid\\media\\lfd_role.tga:"..S["media"].fontsize..":"..S["media"].fontsize..":0:0:64:64:21:39:0:19|t"
	--local damager = "|TInterface\\Addons\\SunUI_Freebgrid\\media\\lfd_role.tga:"..S["media"].fontsize..":"..S["media"].fontsize..":0:0:64:64:21:39:23:42|t"
	local tank = "|TInterface\\Addons\\SunUI\\media\\tank.tga:"..(S["media"].fontsize+6)..":"..(S["media"].fontsize+6).."|t"
	local healer = "|TInterface\\Addons\\SunUI\\media\\healer.tga:"..(S["media"].fontsize+6)..":"..(S["media"].fontsize+6).."|t"
	local damager = "|TInterface\\Addons\\SunUI\\media\\dps.tga:"..(S["media"].fontsize+6)..":"..(S["media"].fontsize+6).."|t"
	local id = 462
	
	local function ShowGameToolTip(self)
		if InCombatLockdown() then return end
		local text = ""
		local _, forTank, forHealer, forDamage, _, _, _ = GetLFGRoleShortageRewards(id, 1)
		local id, name = GetLFGRandomDungeonInfo(9)
		--print(name)
		if forTank then 
			text = text..tank
		end
		if forHealer then 
			text = text..healer
		end
		if forDamage then 
			text = text..damager
		end
		if text == "" then text = "|cffffd700N/A|r" end
		
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(str, 0,.6,1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(name, text, 1, 1, 1, 1, 1, 1)
		GameTooltip:Show()
	end
	
	local function OnEvent()
		local text = ""
		local _, forTank, forHealer, forDamage, _, _, _ = GetLFGRoleShortageRewards(id, 1)
		if forTank then 
			text = text..tank
		end
		if forHealer then 
			text = text..healer
		end
		if forDamage then 
			text = text..damager
		end
		if text == "" then text = "|cffffd700N/A|r" end
		stat.text:SetText(text)
	end
	stat:SetScript("OnEvent", OnEvent)
	stat:SetScript("OnEnter", ShowGameToolTip)
	stat:SetScript("OnLeave", GameTooltip_Hide)
	stat:SetScript("OnMouseDown", function() PVEFrame_ToggleFrame("GroupFinderFrame", LFDParentFrame) end)
	
	stat:RegisterEvent("LFG_OFFER_CONTINUE")
	stat:RegisterEvent("LFG_ROLE_CHECK_ROLE_CHOSEN")
	stat:RegisterEvent("LFG_QUEUE_STATUS_UPDATE")
	stat:RegisterEvent("LFG_PROPOSAL_UPDATE")
	stat:RegisterEvent("LFG_BOOT_PROPOSAL_UPDATE")
	stat:RegisterEvent("LFG_PROPOSAL_SHOW")
	stat:RegisterEvent("LFG_PROPOSAL_FAILED")
	stat:RegisterEvent("LFG_PROPOSAL_SUCCEEDED")
	stat:RegisterEvent("LFG_UPDATE")
	stat:RegisterEvent("LFG_ROLE_CHECK_SHOW")
	stat:RegisterEvent("LFG_ROLE_CHECK_HIDE")
	stat:RegisterEvent("LFG_ROLE_UPDATE")
	stat:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
	stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	stat:RegisterEvent("LFG_COMPLETION_REWARD")
	stat:RegisterEvent("PARTY_MEMBERS_CHANGED")
end