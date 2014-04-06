local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")

function IB:CreateLatency()
	local A = S:GetModule("Skins")
	local stat = CreateFrame("Frame", "InfoPanel1", TopInfoPanel or UIParent)
	stat:SetFrameStrata("BACKGROUND")
	stat:SetFrameLevel(3)
	stat:EnableMouse(true)
	
	stat.text = S:CreateFS(stat, nil, nil, IB.font)
	stat.text:SetPoint("LEFT", TopInfoMoveHeader, "LEFT", 0, 0)
	stat:SetAllPoints(stat.text)
	
	stat.icon = stat:CreateTexture(nil, "OVERLAY")
	stat.icon:SetSize(8, 8)
	stat.icon:SetPoint("RIGHT", stat, "LEFT", -5, 0)
	stat.icon:SetTexture(IB.backdrop)
	
	A:CreateShadow(stat, stat.icon)
	local function colorlatency(latency)
		if latency < 100 then
			stat.icon:SetVertexColor(100/255, 210/255, 100/255, 0.8)
		elseif (latency >= 100 and latency < 200) then
			stat.icon:SetVertexColor(232/255, 218/255, 15/255, 0.8)
		else
			stat.icon:SetVertexColor(210/255, 100/255, 100/255, 0.8)
		end
	end
	local int = 1
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local _, _, latencyHome, latencyWorld = GetNetStats()
			colorlatency(latencyHome)
			stat.text:SetText(latencyHome.."|cffffd700ms|r")
			int = 1
		end
	end
	stat:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["延迟"],0,.6,1)
		GameTooltip:AddLine(" ")
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local bandwidth = GetAvailableBandwidth()
		local r1, g1, b1 = S:ColorGradient(latencyHome/100, IB.InfoBarStatusColor[1][1], IB.InfoBarStatusColor[1][2], IB.InfoBarStatusColor[1][3], 
																			IB.InfoBarStatusColor[2][1], IB.InfoBarStatusColor[2][2], IB.InfoBarStatusColor[2][3],
																			IB.InfoBarStatusColor[3][1], IB.InfoBarStatusColor[3][2], IB.InfoBarStatusColor[3][3])
		local r2, g2, b2 = S:ColorGradient(latencyWorld/100, IB.InfoBarStatusColor[1][1], IB.InfoBarStatusColor[1][2], IB.InfoBarStatusColor[1][3], 
																			IB.InfoBarStatusColor[2][1], IB.InfoBarStatusColor[2][2], IB.InfoBarStatusColor[2][3],
																			IB.InfoBarStatusColor[3][1], IB.InfoBarStatusColor[3][2], IB.InfoBarStatusColor[3][3])
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(L["本地延迟"], latencyHome.."ms", 0.75, 0.9, 1, r1, g1, b1)
		GameTooltip:AddDoubleLine(L["世界延迟"], latencyWorld.."ms", 0.75, 0.9, 1, r2, g2, b2)
		if bandwidth ~= 0 then
			GameTooltip:AddDoubleLine(L["带宽"]..": " , string.format("%.2f Mbps", bandwidth),0.69, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddDoubleLine(L["下载"]..": " , string.format("%.2f%%", GetDownloadedPercentage() *100),0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
		end
		GameTooltip:Show()
	end)
	stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	stat:SetScript("OnMouseDown", function(self, button) 
		ToggleFrame(GameMenuFrame)
	end)
	
	stat:SetScript("OnUpdate", Update) 
end